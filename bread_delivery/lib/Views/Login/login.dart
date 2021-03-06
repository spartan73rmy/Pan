import 'package:bread_delivery/BLOC/Login/bloc/login_bloc.dart';
import 'package:bread_delivery/CommonWidgets/inputField.dart';
import 'package:bread_delivery/CommonWidgets/loadingScreen.dart';
import 'package:bread_delivery/CommonWidgets/passField.dart';
import 'package:bread_delivery/CommonWidgets/snackBar.dart';
import 'package:bread_delivery/Entities/userType.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Login extends StatefulWidget {
  Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _obscureText = true;
  TextEditingController _userNameController, _passwordController;
  String _emailError, _passwordError;

  @override
  void initState() {
    super.initState();
    _userNameController = new TextEditingController();
    _passwordController = new TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(actions: <Widget>[
          IconButton(
            icon: Icon(Icons.account_box),
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/Register',
              );
            },
          )
        ]),
        key: _scaffoldKey,
        body: BlocListener<LoginBloc, LoginState>(
          listener: (context, state) => {
            if (state is ErrorLogin)
              snackBar(context, state.toString())
            else if (state is SuccessLogin)
              Navigator.pushReplacementNamed(context, '/Home',
                  arguments: state.token.user.userType == UserType.adminT)
          },
          child: BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
            if (state is LoadingLogin) return LoadingScreen();
            return Padding(
                padding:
                    const EdgeInsets.only(top: 0.0, left: 16.0, right: 16.0),
                child: Form(
                    child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                      child: Icon(Icons.vpn_key,
                          size: 150, color: Colors.blueGrey),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),
                      child: Text(
                        "Inicio de Sesion",
                        style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                      child: InputField("Usuario", _userNameController,
                          _emailError, TextInputType.emailAddress),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),
                      child: PasswordField(
                        passwordController: _passwordController,
                        obscureText: _obscureText,
                        passwordError: _passwordError,
                        togglePassword: _togglePassword,
                      ),
                    ),
                    FloatingActionButton.extended(
                        icon: Icon(Icons.supervised_user_circle_sharp),
                        backgroundColor: Color(Colors.blueAccent.value),
                        label: Text("Iniciar Sesion",
                            style: TextStyle(fontSize: 20)),
                        onPressed: () => {_doLogin()}),
                  ],
                )));
          }),
        ));
  }

  _doLogin() {
    BlocProvider.of<LoginBloc>(context).add(
      DoLogin(_userNameController.text, _passwordController.text),
    );
  }

  _togglePassword() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }
}
