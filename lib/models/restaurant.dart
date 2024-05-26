import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/models/cart_item.dart';
import 'package:food_delivery_app/models/food.dart';
import 'package:intl/intl.dart';

class Restaurant extends ChangeNotifier {
  final List<Food> _menu = [
    // Burgers
    Food(
      name: 'Classic Cheeseburger',
      decription: 'A juicy beef patty with melted cheddar, lettuce, tomato, and a hint of onion and pickle',
      imagePath: "lib/images/burgers/burger.jpg",
      price: 4.99,
      category: FoodCategory.burgers,
      availableAddons: [
        Addon(name: 'Extra cheese', price: 0.99),
        Addon(name: 'Bacon', price: 1.99),
        Addon(name: 'Avocado', price: 2.99),
      ],
    ),
    Food(
      name: 'Chicken Burger',
      decription: 'A juicy beef patty with melted cheddar, lettuce, tomato, and a hint of onion and pickle',
      imagePath: "lib/images/burgers/burger2.jpg",
      price: 4.99,
      category: FoodCategory.burgers,
      availableAddons: [
        Addon(name: 'Extra cheese', price: 0.99),
        Addon(name: 'Bacon', price: 1.99),
        Addon(name: 'Avocado', price: 2.99),
      ],
    ),

    // Salads
    Food(
      name: 'Classic Salad',
      decription: 'A fresh mix of greens and vegetables, often served with a light dressing.',
      imagePath: "lib/images/salads/salad.jpg",
      price: 2.99,
      category: FoodCategory.salads,
      availableAddons: [
        Addon(name: 'Olives', price: 0.49),
        Addon(name: 'Tomatoes', price: 1.59),
      ],
    ),
    Food(
      name: 'Cesar Salad',
      decription: 'A popular salad featuring romaine lettuce, croutons, Parmesan cheese, and Caesar dressing.',
      imagePath: "lib/images/salads/salad2.jpeg",
      price: 3.99,
      category: FoodCategory.salads,
      availableAddons: [
        Addon(name: 'Olives', price: 0.49),
        Addon(name: 'Tomatoes', price: 1.59),
      ],
    ),

    // Sides
    Food(
      name: 'Onion Rings',
      decription: 'Crispy, deep-fried rings of onion, often served as a savory appetizer.',
      imagePath: "lib/images/sides/side.jpeg",
      price: 0.99,
      category: FoodCategory.sides,
      availableAddons: [],
    ),
    Food(
      name: 'Garlic Bread',
      decription: 'A delicious side dish made from toasted bread topped with garlic and butter.',
      imagePath: "lib/images/sides/side2.jpeg",
      price: 0.99,
      category: FoodCategory.sides,
      availableAddons: [],
    ),

    // Desserts
    Food(
      name: 'Ice cream',
      decription: 'A creamy, frozen dessert available in various flavors and often enjoyed on a hot day.',
      imagePath: "lib/images/desserts/dessert.jpg",
      price: 0.99,
      category: FoodCategory.desserts,
      availableAddons: [
        Addon(name: 'Cream', price: 0.49),
        Addon(name: 'Sticks', price: 0.39),
      ],
    ),
    Food(
      name: 'Cake',
      decription: 'A sweet, layered treat typically served with frosting and perfect for celebrations.',
      imagePath: "lib/images/desserts/dessert2.jpg",
      price: 0.99,
      category: FoodCategory.desserts,
      availableAddons: [],
    ),

    // Drinks
    Food(
      name: 'Apple juice',
      decription: 'A refreshing, sweet beverage made from pressed apples.',
      imagePath: "lib/images/drinks/drink2.jpeg",
      price: 2.99,
      category: FoodCategory.drinks,
      availableAddons: [],
    ),
    Food(
      name: 'Pina colada',
      decription: 'A tropical cocktail made with rum, coconut cream, and pineapple juice.',
      imagePath: "lib/images/drinks/drink.jpeg",
      price: 3.99,
      category: FoodCategory.drinks,
      availableAddons: [],
    ),
  ];

  final List<CartItem> _cart = [];
  String _deliveryAddress = '87 Angorra Str';

  List<Food> get menu => _menu;
  List<CartItem> get cart => _cart;
  String get deliveryAddress => _deliveryAddress;

  // Operations

  void addToCart(Food food, List<Addon> selectedAddons) {
    CartItem? cartItem = _cart.firstWhereOrNull((item) {
      bool isSameFood = item.food == food;

      bool isSameAddons = const ListEquality().equals(item.selectedAddons, selectedAddons);

      return isSameAddons && isSameFood;
    });

    if (cartItem != null) {
      cartItem.quantity++;
    } else {
      _cart.add(
        CartItem(
          food: food,
          selectedAddons: selectedAddons,
        ),
      );
    }
    notifyListeners();
  }

  void removeFromCart(CartItem cartItem) {
    int cartIndex = _cart.indexOf(cartItem);

    if (cartIndex != -1) {
      if (_cart[cartIndex].quantity > 1) {
        _cart[cartIndex].quantity--;
      } else {
        _cart.removeAt(cartIndex);
      }
    }
    notifyListeners();
  }

  double getTotalPrice() {
    double total = 0.0;

    for (CartItem cartItem in _cart) {
      double itemTotal = cartItem.food.price;
      for (Addon addon in cartItem.selectedAddons) {
        itemTotal += addon.price;
      }

      total += itemTotal * cartItem.quantity;
    }
    return total;
  }

  int getTotalItemCount() {
    int totalItemCount = 0;

    for (CartItem cartItem in _cart) {
      totalItemCount += cartItem.quantity;
    }

    return totalItemCount;
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }

  void updateDeliveryAddress(String newAddress) {
    _deliveryAddress = newAddress;
    notifyListeners();
  }

  // Receipt

  String generateCartReceipt() {
    final receipt = StringBuffer();
    receipt.writeln('Here is your receipt');
    receipt.writeln();

    String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

    receipt.writeln(formattedDate);
    receipt.writeln();
    receipt.writeln('----------');

    for (final cartItem in _cart) {
      receipt.writeln('${cartItem.quantity} x ${cartItem.food.name} - ${_formatPrice(cartItem.food.price)}');
      if (cartItem.selectedAddons.isNotEmpty) {
        receipt.writeln('     Add-ons: ${_formatAddons(cartItem.selectedAddons)}');
      }
      receipt.writeln();
    }
    receipt.writeln('-----------');
    receipt.writeln();
    receipt.writeln('Total Items: ${getTotalItemCount()}');
    receipt.writeln('Total Price: ${_formatPrice(getTotalPrice())}');
    receipt.writeln();
    receipt.writeln('Delivering to$deliveryAddress');

    return receipt.toString();
  }

  String _formatPrice(double price) {
    return '\$${price.toStringAsFixed(2)}';
  }

  String _formatAddons(List<Addon> addons) {
    return addons.map((addon) => '${addon.name} (${_formatPrice(addon.price)})').join(', ');
  }
}
