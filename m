Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 09 Apr 2008 09:08:27 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m39G8IAw011396
	for <xfs@oss.sgi.com>; Wed, 9 Apr 2008 09:08:20 -0700
Received: from minas.ics.muni.cz (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 592A776C5CC
	for <xfs@oss.sgi.com>; Wed,  9 Apr 2008 09:08:55 -0700 (PDT)
Received: from minas.ics.muni.cz (minas.ics.muni.cz [147.251.4.40]) by cuda.sgi.com with ESMTP id ipKQq3LPAXOzzrjy for <xfs@oss.sgi.com>; Wed, 09 Apr 2008 09:08:55 -0700 (PDT)
Received: from dior.ics.muni.cz (dior.ics.muni.cz [147.251.6.10])
	by minas.ics.muni.cz (8.13.8/8.13.8/SuSE Linux 0.8) with ESMTP id m39G8rIe019763
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Wed, 9 Apr 2008 18:08:54 +0200
Received: from album.ics.muni.cz (album.ics.muni.cz [147.251.23.20])
	by dior.ics.muni.cz (8.13.8+Sun/8.13.8) with SMTP id m39G8qSE010326
	for <xfs@oss.sgi.com>; Wed, 9 Apr 2008 18:08:53 +0200 (CEST)
Date: Wed, 9 Apr 2008 18:08:45 +0200
From: petr.pisar@atlas.cz
Subject: Czech translation for attr-2.4.41
Message-ID: <20080409160843.GA20142@album.bayer.ipv6ia.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DBIVS5p969aUjpLe"
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

--DBIVS5p969aUjpLe
Content-Type: multipart/mixed; boundary="uAKRQypu60I7Lcqm"
Content-Disposition: inline

--uAKRQypu60I7Lcqm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello,

I'v tranlated attr package into Czech language. Patch against version 2.4.41
is attached.

-- Petr

--uAKRQypu60I7Lcqm
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="attr-2.4.41-cs.diff"
Content-Transfer-Encoding: quoted-printable

diff --git a/po/Makefile b/po/Makefile
index 5d2541d..06c5a2e 100644
--- a/po/Makefile
+++ b/po/Makefile
@@ -6,7 +6,7 @@ TOPDIR =3D ..
 include $(TOPDIR)/include/builddefs
=20
 POTHEAD =3D $(PKG_NAME).pot
-LINGUAS =3D de es fr gl nl pl sv
+LINGUAS =3D cs de es fr gl nl pl sv
 LSRCFILES =3D $(LINGUAS:%=3D%.po) $(POTHEAD)
 LDIRT =3D $(POTHEAD)
=20
diff --git a/po/cs.po b/po/cs.po
new file mode 100644
index 0000000..e73c98c
--- /dev/null
+++ b/po/cs.po
@@ -0,0 +1,229 @@
+# Czech translation for attr.
+# Copyright (C) 2008 authors of attr source code (msgids)
+# This file is distributed under the same license as the attr package.
+# Petr Pisar <petr.pisar@atlas.cz>, 2008.
+#
+msgid ""
+msgstr ""
+"Project-Id-Version: attr 2.4.41\n"
+"Report-Msgid-Bugs-To: \n"
+"POT-Creation-Date: 2008-02-11 17:34+1100\n"
+"PO-Revision-Date: 2008-04-09 16:30+0200\n"
+"Last-Translator: Petr Pisar <petr.pisar@atlas.cz>\n"
+"Language-Team: Czech <translation-team-cs@lists.sourceforge.net>\n"
+"MIME-Version: 1.0\n"
+"Content-Type: text/plain; charset=3DUTF-8\n"
+"Content-Transfer-Encoding: 8bit\n"
+
+#: ../attr/attr.c:46
+#, c-format
+msgid ""
+"Usage: %s [-LRSq] -s attrname [-V attrvalue] pathname  # set value\n"
+"       %s [-LRSq] -g attrname pathname                 # get value\n"
+"       %s [-LRSq] -r attrname pathname                 # remove attr\n"
+"       %s [-LRq]  -l pathname                          # list attrs \n"
+"      -s reads a value from stdin and -g writes a value to stdout\n"
+msgstr ""
+"U=C5=BEit=C3=AD: %s [-LRSq] -s n=C3=A1zev_atributu [-V hodnota] cesta  # =
nastav=C3=AD hodnotu\n"
+"       %s [-LRSq] -g n=C3=A1zev_atributu cesta               # zjist=C3=
=AD hodnotu\n"
+"       %s [-LRSq] -r n=C3=A1zev_atributu cesta               # odstran=C3=
=AD atribut\n"
+"       %s [-LRq]  -l cesta                              # vyp=C3=AD=C5=A1=
e atributy\n"
+"  -s =C4=8Dte hodnotu ze standardn=C3=ADho vstupu a -g ji vypisuje na sta=
ndardn=C3=AD "
+"v=C3=BDstup.\n"
+
+#: ../attr/attr.c:83 ../attr/attr.c:100 ../attr/attr.c:109 ../attr/attr.c:=
118
+#, c-format
+msgid "Only one of -s, -g, -r, or -l allowed\n"
+msgstr "Povolen je pr=C3=A1v=C4=9B jeden z=C2=A0p=C5=99ep=C3=ADna=C4=8D=C5=
=AF -s, -g, -r nebo -l\n"
+
+#: ../attr/attr.c:91
+#, c-format
+msgid "-V only allowed with -s\n"
+msgstr "-V=E2=80=AFje povoleno sej s -s\n"
+
+#: ../attr/attr.c:136
+#, c-format
+msgid "Unrecognized option: %c\n"
+msgstr "Nerozpoznan=C3=BD p=C5=99ep=C3=ADna=C4=8D: %c\n"
+
+#: ../attr/attr.c:143
+#, c-format
+msgid "A filename to operate on is required\n"
+msgstr "Jm=C3=A9no souboru, se kter=C3=BDm se bude pracovat, je vy=C5=BEad=
ov=C3=A1no.\n"
+
+#: ../attr/attr.c:171
+#, c-format
+msgid "Could not set \"%s\" for %s\n"
+msgstr "Souboru %2$s nelze nastavit atribut =E2=80=9E%1$s=E2=80=9C\n"
+
+#: ../attr/attr.c:176
+#, c-format
+msgid "Attribute \"%s\" set to a %d byte value for %s:\n"
+msgstr "Atributu =E2=80=9E%1$s=E2=80=9C souboru %3$s nastavena %2$dbajtov=
=C3=A1 hodnota:\n"
+
+#: ../attr/attr.c:194
+#, c-format
+msgid "Could not get \"%s\" for %s\n"
+msgstr "Ze souboru %2$s nelze z=C3=ADskat atribut =E2=80=9E%1$s=E2=80=9C\n"
+
+#: ../attr/attr.c:199
+#, c-format
+msgid "Attribute \"%s\" had a %d byte value for %s:\n"
+msgstr "Atribut =E2=80=9E%1$s=E2=80=9C souboru %3$s m=C4=9Bl %2$dbajtovou =
hodnotu:\n"
+
+#: ../attr/attr.c:212
+#, c-format
+msgid "Could not remove \"%s\" for %s\n"
+msgstr "Ze souboru %2$s nelze odstranit atribut =E2=80=9E%1$s=E2=80=9C\n"
+
+#: ../attr/attr.c:230
+#, c-format
+msgid "Could not list \"%s\" for %s\n"
+msgstr "Ze souboru %2$s nelze vypsat atribut =E2=80=9E%1$s=E2=80=9C\n"
+
+#: ../attr/attr.c:240
+#, c-format
+msgid "Attribute \"%s\" has a %d byte value for %s\n"
+msgstr "Atribut =E2=80=9E%1$s=E2=80=9C souboru %3$s m=C3=A1 %2$dbajtovou h=
odnotu\n"
+
+#: ../attr/attr.c:252
+#, c-format
+msgid "At least one of -s, -g, -r, or -l is required\n"
+msgstr "Alespo=C5=88 jeden z=C2=A0p=C5=99ep=C3=ADna=C4=8D=C5=AF -s, -g, -r=
 nebo -l je vy=C5=BEadov=C3=A1n\n"
+
+#: ../getfattr/getfattr.c:97 ../setfattr/setfattr.c:70
+msgid "No such attribute"
+msgstr "Takov=C3=BD atribut neexistuje"
+
+#: ../getfattr/getfattr.c:255
+#, c-format
+msgid "%s: Removing leading '/' from absolute path names\n"
+msgstr "%s: Odstra=C5=88uji =C3=BAvodn=C3=AD =E2=80=9E/=E2=80=9C z=C2=A0ab=
solutn=C3=AD cesty\n"
+
+#: ../getfattr/getfattr.c:372
+#, c-format
+msgid "%s %s -- get extended attributes\n"
+msgstr "%s %s=C2=A0=E2=80=93=C2=A0z=C3=ADsk=C3=A1 roz=C5=A1=C3=AD=C5=99en=
=C3=A9 atributy\n"
+
+#: ../getfattr/getfattr.c:374 ../setfattr/setfattr.c:175
+#, c-format
+msgid "Usage: %s %s\n"
+msgstr "Pou=C5=BEit=C3=AD: %s %s\n"
+
+#: ../getfattr/getfattr.c:377
+#, c-format
+msgid ""
+"  -n, --name=3Dname         get the named extended attribute value\n"
+"  -d, --dump              get all extended attribute values\n"
+"  -e, --encoding=3D...      encode values (as 'text', 'hex' or 'base64')\=
n"
+"      --match=3Dpattern     only get attributes with names matching patte=
rn\n"
+"      --only-values       print the bare values only\n"
+"  -h, --no-dereference    do not dereference symbolic links\n"
+"      --absolute-names    don't strip leading '/' in pathnames\n"
+"  -R, --recursive         recurse into subdirectories\n"
+"  -L, --logical           logical walk, follow symbolic links\n"
+"  -P  --physical          physical walk, do not follow symbolic links\n"
+"      --version           print version and exit\n"
+"      --help              this help text\n"
+msgstr ""
+"  -n, --name=3Dn=C3=A1zev        zjist=C3=AD hodnotu jmenovan=C3=A9ho roz=
=C5=A1=C3=AD=C5=99en=C3=A9ho atributu\n"
+"  -d, --dump              zjist=C3=AD hodnoty v=C5=A1ech roz=C5=A1=C3=AD=
=C5=99en=C3=BDch atribut=C5=AF\n"
+"  -e, --encoding=3D=E2=80=A6        zak=C3=B3duje hodnotu (jako =E2=80=9E=
text=E2=80=9C, =E2=80=9Ehex=E2=80=9C nebo "
+"=E2=80=9Ebase64=E2=80=9C)\n"
+"      --match=3Dvzor        z=C3=ADsk=C3=A1 jen atributy, jejich=C5=BE jm=
=C3=A9na vyhovuj=C3=AD vzoru\n"
+"      --only-values       vyp=C3=AD=C5=A1e =C4=8Dist=C4=9B jenom hodnoty\=
n"
+"  -h, --no-dereference    nen=C3=A1sleduje symbolick=C3=A9 odkazy\n"
+"      --absolute-names    neodstra=C5=88uje =C3=BAvodn=C3=AD =E2=80=9E/=
=E2=80=9C z=C2=A0cest k=C2=A0soubor=C5=AFm\n"
+"  -R, --recursive         sestupuje do podadres=C3=A1=C5=99=C5=AF\n"
+"  -L, --logical           logick=C3=BD pr=C5=AFchod, n=C3=A1sleduje symbo=
lick=C3=A9 odkazy\n"
+"  -P  --physical          fyzick=C3=BD pr=C5=AFchod, symbolick=C3=A9 odka=
zy nen=C3=A1sleduje\n"
+"      --version           vyp=C3=AD=C5=A1e verzi a skon=C4=8D=C3=AD\n"
+"      --help              text t=C3=A9to n=C3=A1pov=C4=9Bdy\n"
+
+#: ../getfattr/getfattr.c:473
+#, c-format
+msgid "%s: invalid regular expression \"%s\"\n"
+msgstr "%s: chybn=C3=BD regul=C3=A1rn=C3=AD v=C3=BDraz =E2=80=9E%s=E2=80=
=9C\n"
+
+#: ../getfattr/getfattr.c:487
+#, c-format
+msgid ""
+"Usage: %s %s\n"
+"Try `%s --help' for more information.\n"
+msgstr ""
+"Pou=C5=BEit=C3=AD: %s %s\n"
+"Pro v=C3=ADce informac=C3=AD zkuste =E2=80=9E%s --help=E2=80=9C.\n"
+
+#: ../setfattr/setfattr.c:123
+#, c-format
+msgid "%s: %s: No filename found in line %d, aborting\n"
+msgstr "%s: %s: =C5=BD=C3=A1dn=C3=A9 jm=C3=A9no souboru nenalezeno na =C5=
=99=C3=A1dku %d, kon=C4=8D=C3=ADm.\n"
+
+#: ../setfattr/setfattr.c:127
+#, c-format
+msgid "%s: No filename found in line %d of standard input, aborting\n"
+msgstr ""
+"%s: =C5=BD=C3=A1dn=C3=A9 jm=C3=A9no souboru nenalezeno na =C5=99=C3=A1dku=
 %d standardn=C3=ADho vstupu, kon=C4=8D=C3=ADm\n"
+
+#: ../setfattr/setfattr.c:174
+#, c-format
+msgid "%s %s -- set extended attributes\n"
+msgstr "%s %s=C2=A0=E2=80=93 nastav=C3=AD roz=C5=A1=C3=AD=C5=99en=C3=A9 at=
ributy\n"
+
+#: ../setfattr/setfattr.c:176
+#, c-format
+msgid "       %s %s\n"
+msgstr "       %s %s\n"
+
+#: ../setfattr/setfattr.c:178
+#, c-format
+msgid ""
+"  -n, --name=3Dname         set the value of the named extended attribute=
\n"
+"  -x, --remove=3Dname       remove the named extended attribute\n"
+"  -v, --value=3Dvalue       use value as the attribute value\n"
+"  -h, --no-dereference    do not dereference symbolic links\n"
+"      --restore=3Dfile      restore extended attributes\n"
+"      --version           print version and exit\n"
+"      --help              this help text\n"
+msgstr ""
+"  -n, --name=3Dn=C3=A1zev        nastav=C3=AD hodnotu jmenovan=C3=A9ho ro=
z=C5=A1=C3=AD=C5=99en=C3=A9ho atributu\n"
+"  -x, --remove=3Dn=C3=A1zev      odstran=C3=AD jmenovan=C3=BD roz=C5=A1=
=C3=AD=C5=99en=C3=BD atribut\n"
+"  -v, --value=3Dhodnota     jako hodnotu atributu pou=C5=BEije hodnotu\n"
+"  -h, --no-dereference    do not dereference symbolic links\n"
+"      --restore=3Dsoubor    obnov=C3=AD roz=C5=A1=C3=AD=C5=99en=C3=A9 atr=
ibuty\n"
+"      --version           vyp=C3=AD=C5=A1e verzi a skon=C4=8D=C3=AD\n"
+"      --help              text t=C3=A9to n=C3=A1pov=C4=9Bdy\n"
+
+#: ../setfattr/setfattr.c:253
+#, c-format
+msgid ""
+"Usage: %s %s\n"
+"       %s %s\n"
+"Try `%s --help' for more information.\n"
+msgstr ""
+"Pou=C5=BEit=C3=AD: %s %s\n"
+"         %s %s\n"
+"Pro v=C3=ADce informac=C3=AD zkuste =E2=80=9E%s --help=E2=80=9C.\n"
+
+#: ../libattr/attr_copy_fd.c:82 ../libattr/attr_copy_fd.c:97
+#: ../libattr/attr_copy_file.c:80 ../libattr/attr_copy_file.c:95
+#, c-format
+msgid "listing attributes of %s"
+msgstr "vypisuji atribut souboru %s"
+
+#: ../libattr/attr_copy_fd.c:117 ../libattr/attr_copy_fd.c:134
+#: ../libattr/attr_copy_file.c:115 ../libattr/attr_copy_file.c:132
+#, c-format
+msgid "getting attribute %s of %s"
+msgstr "z=C3=ADsk=C3=A1v=C3=A1m atribut %s souboru %s"
+
+#: ../libattr/attr_copy_fd.c:147 ../libattr/attr_copy_fd.c:165
+#: ../libattr/attr_copy_file.c:144 ../libattr/attr_copy_file.c:163
+#, c-format
+msgid "setting attributes for %s"
+msgstr "nastavuji atributy souboru %s"
+
+#: ../libattr/attr_copy_fd.c:153 ../libattr/attr_copy_file.c:151
+#, c-format
+msgid "setting attribute %s for %s"
+msgstr "nastavuji atribut %s souboru %s"

--uAKRQypu60I7Lcqm--

--DBIVS5p969aUjpLe
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQFH/OoLuR4f4nEwzHIRAlPxAKCHSXl6ZoWZaJKEgqDbB8nwTDoMtwCggOq5
e6Oslqkjg10MO71rE6U0v0o=
=Plwo
-----END PGP SIGNATURE-----

--DBIVS5p969aUjpLe--
