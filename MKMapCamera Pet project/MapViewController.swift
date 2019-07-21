//
//  MapViewController.swift
//  MKMapCamera Pet project
//
//  Created by Viswa Kodela on 7/20/19.
//  Copyright © 2019 Viswa Kodela. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {
    
    // MARK:- Init
    
    
    
    // MARK:- Properties
    private var mapView: MKMapView!
    private var camera: MKMapCamera!
    private var locationManager: CLLocationManager! = nil
    private var userLocation: CLLocation!
    
    private let distance: CLLocationDistance = 650
    private let pitch: CGFloat = 65
    private let heading = 0.0
    
    
    // MARK:- View Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setLocationManager()
        configureMapView()
    }
    
    // MARK:- Helper Methods
    private func configureUI() {
        view.backgroundColor = .white
    }
    
    private func configureMapView() {
        let map = MKMapView()
        map.translatesAutoresizingMaskIntoConstraints = false
        map.showsUserLocation = true
        map.mapType = .hybridFlyover
        
        self.mapView = map
        
        view.addSubview(mapView)
        mapView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
    }
    
    private func setLocationManager() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
    }
    
    private func checkLocationAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }

}


// MARK:- Location Manager Delegate
extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
            
        case .notDetermined:
            checkLocationAuthorization()
        case .restricted:
        // TODO:- Show Alert to say that the user is restricted to use this service
            break
        case .denied:
        // TODO:- User is not permitted to use this
            break
        case .authorizedAlways:
            locationManager.requestAlwaysAuthorization()
        case .authorizedWhenInUse:
            checkLocationAuthorization()
        @unknown default:
            return
        }
        
        self.userLocation = locationManager.location
        
        if let currentLocation = locationManager.location?.coordinate {
            self.camera = MKMapCamera(lookingAtCenter: currentLocation, fromDistance: distance, pitch: pitch, heading: heading)
            mapView.camera = self.camera
        }
    }
}

