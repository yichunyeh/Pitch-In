//
//  ViewController.swift
//  NYUHack
//
//  Created by YiChunYeh on 3/24/18.
//  Copyright © 2018 YiChunYeh. All rights reserved.
//

import UIKit
import UIKit
import GoogleMaps

class POIItem: NSObject, GMUClusterItem {
    var position: CLLocationCoordinate2D
    var name: String!
    
    init(position: CLLocationCoordinate2D, name: String) {
        self.position = position
        self.name = name
    }
}

class ViewController: UIViewController, GMUClusterManagerDelegate,GMSMapViewDelegate ,CLLocationManagerDelegate{
//    private var mapView: GMSMapView!
    @IBOutlet weak var mapView: GMSMapView!
    private let locationManager = CLLocationManager()
    private var heatmapLayer: GMUHeatmapTileLayer!
    private var clusterManager: GMUClusterManager!
    private var gradientColors = [UIColor.green, UIColor.red]
    private var gradientStartPoints = [0.1, 1.0] as? [NSNumber]
    let mainColor = #colorLiteral(red: 0.2126812935, green: 0.5116971731, blue: 0.2621504962, alpha: 1)
    @IBAction func profile(_ sender: UIButton) {
    }
    
    @IBAction func report(_ sender: UIButton) {
    }
    
    @IBAction func community(_ sender: UIButton) {
    }
    
    override func loadView() {
        super.loadView()
//        let camera = GMSCameraPosition.camera(withLatitude: 40.730610, longitude: -73.935242, zoom: 6.0)
//        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
//
//        mapView.isMyLocationEnabled = true
//        view = mapView
//        mapView.delegate = self
//        mapView.settings.myLocationButton = true
//
//        locationManager.requestWhenInUseAuthorization()
//
//        let zoomCamera = GMSCameraUpdate.zoomIn()
//        mapView.animate(with: zoomCamera)
//
//        let userLocattion = CLLocationCoordinate2D(latitude:40.730610, longitude: -73.935242)
//
//        let userCam = GMSCameraUpdate.setTarget(userLocattion)
//        mapView.animate(with: userCam)
//
//        let marker = GMSMarker()
//        let marker2 = GMSMarker()
//        marker.position = CLLocationCoordinate2D(latitude: 40.730610, longitude: -73.935242)
//        marker2.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 150.20)
//        marker.map = mapView
//        marker2.map = mapView

    }
    override func viewDidLoad() {
        super.viewDidLoad()

//        let iconGenerator = GMUDefaultClusterIconGenerator()
//        let algorithm = GMUNonHierarchicalDistanceBasedAlgorithm()
//        let renderer = GMUDefaultClusterRenderer(mapView: mapView, clusterIconGenerator: iconGenerator)
//        clusterManager = GMUClusterManager(map: mapView, algorithm: algorithm,
//                                           renderer: renderer)
//
//        generateClusterItems()
//
//        clusterManager.cluster()
//        clusterManager.setDelegate(self, mapDelegate: self)
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        mapView.delegate = self

        heatmapLayer = GMUHeatmapTileLayer()
        heatmapLayer.radius = 80
        heatmapLayer.opacity = 0.8
        heatmapLayer.gradient = GMUGradient(colors: gradientColors,
                                            startPoints: gradientStartPoints!,
                                            colorMapSize: 256)
        addHeatmap()
        heatmapLayer.map = mapView
        
        let zoomCamera = GMSCameraUpdate.zoomIn()
        mapView.animate(with: zoomCamera)
        
        let userLocattion = CLLocationCoordinate2D(latitude:40.730610, longitude: -73.935242)
        
        let userCam = GMSCameraUpdate.setTarget(userLocattion)
        mapView.animate(with: userCam)
        
        let marker = GMSMarker()

        marker.position = CLLocationCoordinate2D(latitude: 40.730610, longitude: -73.935242)

        marker.title = "NYC"
        marker.snippet = "lat :\(-33.86) , lng :\(150.20)"

        marker.map = mapView

        
        
    }
    func clusterManager(_ clusterManager: GMUClusterManager, didTap cluster: GMUCluster) -> Bool {
        print("clusterManager didTap cluster")
        return true
    }
    func clusterManager(_ clusterManager: GMUClusterManager, didTap clusterItem: GMUClusterItem) -> Bool {
        print("clusterManager didTap clusterItem")
        return true
    }
    
//    // MARK: - GMSMapViewDelegate
//    extension MapViewController: GMSMapViewDelegate {
//        
//    }

    
    // MARK: - GMUMapViewDelegate
		
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        if let poiItem = marker.userData as? POIItem {
            NSLog("Did tap marker for cluster item \(poiItem.name)")
        } else {
            NSLog("Did tap a normal marker")
        }
        return false
    }
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
       
    }
    func mapView(_ mapView: GMSMapView, markerInfoContents marker: GMSMarker) -> UIView? {
        let view = UIView()
        
        view.frame = CGRect(x: 0, y: 0, width: 200, height: 100)
        view.backgroundColor = UIColor.white

        let button = UIButton()
        button.setTitle("pitch in here", for: .normal)
        
        button.backgroundColor = mainColor
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true
        button.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
        button.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        button.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10).isActive = true

        return view

    }

    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        performSegue(withIdentifier: "pitch", sender:nil)
    }
    //MARK: - Location Manager delegates
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//
//        let location = locations.last
//
//        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude:(location?.coordinate.longitude)!, zoom:14)
//        mapView.animate(to: camera)
//
//        //Finally stop updating location otherwise it will come again and again in this delegate
//        self.locationManager.stopUpdatingLocation()
//
//    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedWhenInUse else {
            return
        }

//        locationManager.startUpdatingLocation()
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        
        mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 6, bearing: 0, viewingAngle: 0)
        locationManager.stopUpdatingLocation()
//        fetchNearbyPlaces(coordinate: location.coordinate)
    }
    // Randomly generates cluster items within some extent of the camera and
    // adds them to the cluster manager.
    private func generateClusterItems() {
        do {
            if let path = Bundle.main.url(forResource: "geolocation", withExtension: "json") {
                let data = try Data(contentsOf: path)
                let json = try JSONSerialization.jsonObject(with: data, options:.allowFragments)
                if let object = json as? [[String : Any]] {
                    for item in object {
                        //let marker3 = GMSMarker()
                        let lat = item["latitude"] as! String
                        //print(lat)
                        let lng = item["longitude"] as! String
                        //print(lng)
                        //marker.position = CLLocationCoordinate2D(latitude: lat, longitude: lng)
                        //marker.map = mapView
                        let index = item["score"]
                        let name = "Item \(index!)"

                        print("name:\(name), lat :\(lat) , lng:\(lng)")

                        let item =
                            POIItem(position: CLLocationCoordinate2DMake(Double(lat)!, Double(lng)!), name: name)
                        clusterManager.add(item)
                    }
                } else {
                    print("Could not read the JSON.")
                }
            } else {
                 print("Could not read the JSON.")
            }
        } catch {
            print(error.localizedDescription)
        }
    }

    /// Returns a random value between -1.0 and 1.0.
    private func randomScale() -> Double {
        return Double(arc4random()) / Double(UINT32_MAX) * 2.0 - 1.0
    }

    func addHeatmap()  {
        var list = [GMUWeightedLatLng]()
        do {
            // Get the data: latitude/longitude positions of police stations.
            if let path = Bundle.main.url(forResource: "geolocation", withExtension: "json") {
                let data = try Data(contentsOf: path)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let object = json as? [[String: Any]] {
                    for item in object {
                        let lat = CLLocationDegrees(item["latitude"] as! String)!
                        let lng = CLLocationDegrees(item["longitude"] as! String)!
                        let index = Float(item["score"] as! String)!
                        print("index:\(index), lat :\(lat) , lng:\(lng)")
                        let coords = GMUWeightedLatLng(coordinate: CLLocationCoordinate2DMake(lat , lng ), intensity: index )
                        list.append(coords)
                        
                        //add marker
                        let marker = GMSMarker()
                        
                        marker.position = CLLocationCoordinate2D(latitude: lat, longitude: lng)
                        
                        marker.snippet = "index:\(index), lat :\(lat) , lng:\(lng)"
                        
                        marker.map = mapView
                    }
                } else {
                    print("Could not read the JSON.")
                }
            }
        } catch {
            print(error.localizedDescription)
        }
        // Add the latlngs to the heatmap layer.
        heatmapLayer.weightedData = list
    }


}

