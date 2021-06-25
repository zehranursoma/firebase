import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: FirebaseCrud(),
  ));
}

class FirebaseCrud extends StatefulWidget {
  const FirebaseCrud({Key key}) : super(key: key);

  @override
  _FirebaseCrudState createState() => _FirebaseCrudState();
}

class _FirebaseCrudState extends State<FirebaseCrud> {
  //----------------

  String ad, id, kategori;
  int sayfaSayisi;

  idAl(idTutucu) {
    this.id = idTutucu;
  }

  adAl(adTutucu) {
    this.ad = adTutucu;
  }

  kategoriAl(kategoriTutucu) {
    this.kategori = kategoriTutucu;
  }

  sayfaSayisiAl(sayfaTutucu) {
    this.sayfaSayisi = int.parse(sayfaTutucu);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Firebase Crud"),
        centerTitle: true,
      ),
      body: Column (
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              onChanged: (String idTutucu) {
                idAl(idTutucu);
              },
              decoration: InputDecoration(
                labelText: "Kitap Id",
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black54, width: 2),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              onChanged: (String adTutucu) {
                adAl(adTutucu);
              },
              decoration: InputDecoration(
                labelText: "Kitap Adı",
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black54, width: 2),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              onChanged: (String kategoriTutucu) {
                kategoriAl(kategoriTutucu);
              },
              decoration: InputDecoration(
                labelText: "Kitap Kategorisi",
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black54, width: 2),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              onChanged: (String sayfaTutucu) {
                sayfaSayisiAl(sayfaTutucu);
              },
              decoration: InputDecoration(
                labelText: "Kitap Sayfası",
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black54, width: 2),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    veriEkle();
                  },
                  child: Text("Ekle"),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                    onPrimary: Colors.white,
                    shadowColor: Colors.redAccent,
                    elevation: 5,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    veriOku();
                  },
                  child: Text("Oku"),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.yellow,
                    onPrimary: Colors.white,
                    shadowColor: Colors.redAccent,
                    elevation: 5,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    veriGuncelle();
                  },
                  child: Text("Güncelle"),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    onPrimary: Colors.white,
                    shadowColor: Colors.redAccent,
                    elevation: 5,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    veriSil();
                  },
                  child: Text("Sil"),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.orange,
                    onPrimary: Colors.white,
                    shadowColor: Colors.redAccent,
                    elevation: 5,
                  ),
                ),
              ],
            ),
          ),
          StreamBuilder(
            //-----------stream veri tabanından akşışın olacağı yoldaki veriler(snapshots)
            stream:
                FirebaseFirestore.instance.collection("Kitaplik").snapshots(),

            //------------inşa edici

            builder: (context, alinanVeri) {
              //akışta bir hata varsa
              if (alinanVeri.hasError) {
                return Text("Aktarım başarısız...");
              }

              //--------hata yoksa listView inşa edici döndersin
              return ListView.builder(
                shrinkWrap: true,
                //---satır sayısı
                itemCount: alinanVeri.data.docs.lenght,
                //----satır inşa edici
                itemBuilder: (context, index) {
                  //------satır verisi
                  DocumentSnapshot satirVerisi = alinanVeri.data.docs[index];

                  return Padding(
                    padding: const EdgeInsets.fromLTRB(20,8,0,8),
                    child:Row(
                      children:[
                      Expanded(
                        child: Text(satirVerisi["kitapAd"],
                        ),
                      ),
                      Expanded(
                        child: Text(satirVerisi["kitapId"],
                        ),
                      ),
                      Expanded(
                        child: Text(satirVerisi["kitapKategori"],
                        ),
                      ),
                      Expanded(
                        child: Text(satirVerisi["kitapSayfasayisi"],

                        ),
                      ),
],
                    ),
                  );
                },
              );
            },
          )
        ],
      ),
    );
  }

//------Firebase'e veri gönderecek
  void veriEkle() {
    DocumentReference veriYolu =
        FirebaseFirestore.instance.collection("Kitaplik").doc(id);

    Map<String, dynamic> kitaplar = {
      "kitapId": id,
      "kitapAd": ad,
      "kitapKategori": kategori,
      "kitapSayfasayisi": sayfaSayisi.toString(),
    };

    veriYolu.set(kitaplar).whenComplete(() {
      Fluttertoast.showToast(msg: id + "Id'li kitap eklendi");
    });
  }

//------Firebase'den veri okuyacak
  void veriOku() {
    DocumentReference veriOkumaYolu =
        FirebaseFirestore.instance.collection("Kitaplik").doc(id);
    //--------veriyi al alınan değere
    veriOkumaYolu.get().then((alinanDeger) {
      //--------------çoklu veriyi map e aktar
      //--------------alinan degerdeki verileri alinan veri olarak map e aktar
      Map<String, dynamic> alinanVeri = alinanDeger.data();

      //-------alinan verideki alanları tutuculara aktar

      String idTutucu = alinanVeri["kitapId"];
      String adTutucu = alinanVeri["kitapIAd"];
      String kategoriTutucu = alinanVeri["kitapKategori"];
      String sayfaTutucu = alinanVeri["kitapSayfasayisi"];

      //------------tutucuları göster

      Fluttertoast.showToast(
          msg: "Id: " +
              idTutucu +
              " Ad: " +
              adTutucu +
              " Kategori: " +
              kategoriTutucu +
              " Sayfa Sayisi:" +
              sayfaTutucu);
    });
  }

//------Firebase'de veri güncelleyecek
  void veriGuncelle() {
    //------Veri Yolu

    DocumentReference veriGuncellemeYolu =
        FirebaseFirestore.instance.collection("Kitaplik").doc(id);

    //--------Çoklu Veri Map i

    Map<String, dynamic> guncellenecekVeri = {
      "kitapId": id,
      "kitapAd": ad,
      "kitapKategori": kategori,
      "kitapSayfasayisi": sayfaSayisi.toString(),
    };

    //-------Veriyi guncelle

    veriGuncellemeYolu.update(guncellenecekVeri).whenComplete(() {
      Fluttertoast.showToast(msg: id + "ID li kitap guncellendi...");
    });
  }

//------Firebase'den veri silecek
  void veriSil() {
    //--veri Yolu

    DocumentReference veriSilmeYolu =
        FirebaseFirestore.instance.collection("Kitaplik").doc(id);

    //----veriyi sildirme

    veriSilmeYolu.delete().whenComplete(() {
      Fluttertoast.showToast(msg: id + "ID li kitap silindi...");
    });
  }
}
