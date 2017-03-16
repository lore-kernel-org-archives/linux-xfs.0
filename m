Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from buxtehude.debian.org ([209.87.16.39]:50006 "EHLO
        buxtehude.debian.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755104AbdCPQaJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Mar 2017 12:30:09 -0400
Subject: Bug#766811: spurious library links
Reply-To: Michael Biebl <biebl@debian.org>, 766811@bugs.debian.org
From: Michael Biebl <biebl@debian.org>
References: <20141026004825.GA27863@bongo.bofh.it>
 <20160124151308.GA7620@jwilk.net> <20160206005821.GA11551@bongo.bofh.it>
 <20160206132241.GA2869@jwilk.net> <20160210031703.GA28092@bongo.bofh.it>
 <822351939.19802495.1455074423707.JavaMail.zimbra@redhat.com>
 <822351939.19802495.1455074423707.JavaMail.zimbra@redhat.com>
Message-ID: <785bca5c-7b92-1c20-7a68-7c8b79419fa4@debian.org>
Date: Thu, 16 Mar 2017 17:28:21 +0100
MIME-Version: 1.0
In-Reply-To: <822351939.19802495.1455074423707.JavaMail.zimbra@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="aost9Rw9hMsVHaAsxWIPxgTdr9W6idISJ"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: 766811@bugs.debian.org, Nathan Scott <nathans@debian.org>, Marco d'Itri <md@linux.it>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--aost9Rw9hMsVHaAsxWIPxgTdr9W6idISJ
Content-Type: multipart/mixed; boundary="eOl4gRGpcxSR3vux7UhXGRQ8TjJDcX8QU";
 protected-headers="v1"
From: Michael Biebl <biebl@debian.org>
To: 766811@bugs.debian.org, Nathan Scott <nathans@debian.org>,
 Marco d'Itri <md@linux.it>
Message-ID: <785bca5c-7b92-1c20-7a68-7c8b79419fa4@debian.org>
Subject: Re: Bug#766811: spurious library links
References: <20141026004825.GA27863@bongo.bofh.it>
 <20160124151308.GA7620@jwilk.net> <20160206005821.GA11551@bongo.bofh.it>
 <20160206132241.GA2869@jwilk.net> <20160210031703.GA28092@bongo.bofh.it>
 <822351939.19802495.1455074423707.JavaMail.zimbra@redhat.com>
 <822351939.19802495.1455074423707.JavaMail.zimbra@redhat.com>
In-Reply-To: <822351939.19802495.1455074423707.JavaMail.zimbra@redhat.com>

--eOl4gRGpcxSR3vux7UhXGRQ8TjJDcX8QU
Content-Type: multipart/mixed;
 boundary="------------945F744CD487ADD97741E54A"

This is a multi-part message in MIME format.
--------------945F744CD487ADD97741E54A
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: quoted-printable

Hi Nathan

On Tue, 9 Feb 2016 22:20:23 -0500 (EST) Nathan Scott
<nathans@debian.org> wrote:

> > Should I NMU?
>=20
> Please go right ahead Marco - many thanks!

So this NMU happened, but unfortunately your followup maintainer upload,
i.e. 4.5.0 did not include the changes from the NMU.

Nathan, could you make another upload including the fix from Marco?

I've attached the debdiff which still seems to apply against 4.9.0

Seeing that this issue already caused two duplicates being filed, I'd
say it's worth fixing for stretch.

Regards,
Michael

--=20
Why is it that all of the instruments seeking intelligent life in the
universe are pointed away from Earth?


--------------945F744CD487ADD97741E54A
Content-Type: text/plain; charset=UTF-8;
 name="xfsprogs_4.3.0+nmu1.debdiff"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="xfsprogs_4.3.0+nmu1.debdiff"

diff -Nru xfsprogs-4.3.0/debian/changelog xfsprogs-4.3.0+nmu1/debian/chan=
gelog
--- xfsprogs-4.3.0/debian/changelog	2015-11-27 00:38:33.000000000 +0100
+++ xfsprogs-4.3.0+nmu1/debian/changelog	2016-02-10 04:39:50.000000000 +0=
100
@@ -1,3 +1,11 @@
+xfsprogs (4.3.0+nmu1) unstable; urgency=3Dmedium
+
+  * Non-maintainer upload.
+  * Disabled the code in include/buildmacros which creates bogus symlink=
s
+    for libraries. (Closes: #766811)
+
+ -- Marco d'Itri <md@linux.it>  Wed, 10 Feb 2016 04:24:23 +0100
+
 xfsprogs (4.3.0) unstable; urgency=3Dlow
=20
   * New upstream release
diff -Nru xfsprogs-4.3.0/include/buildmacros xfsprogs-4.3.0+nmu1/include/=
buildmacros
--- xfsprogs-4.3.0/include/buildmacros	2015-09-11 03:51:36.000000000 +020=
0
+++ xfsprogs-4.3.0+nmu1/include/buildmacros	2016-02-10 04:39:50.000000000=
 +0100
@@ -76,7 +76,7 @@
 	../$(INSTALL) -m 644 $(LIBNAME).lai $(PKG_LIB_DIR)/$(LIBNAME).la ; \
 	../$(INSTALL) -m 755 -d $(PKG_ROOT_LIB_DIR); \
 	../$(INSTALL) -T so_base $(LIBNAME).lai $(PKG_ROOT_LIB_DIR); \
-	if [ "x$(shell readlink -f $(PKG_LIB_DIR))" !=3D \
+	if false && [ "x$(shell readlink -f $(PKG_LIB_DIR))" !=3D \
 	     "x$(shell readlink -f $(PKG_ROOT_LIB_DIR))" ]; then \
 		../$(INSTALL) -S $(PKG_LIB_DIR)/$(LIBNAME).a $(PKG_ROOT_LIB_DIR)/$(LIB=
NAME).a; \
 		../$(INSTALL) -S $(PKG_LIB_DIR)/$(LIBNAME).la $(PKG_ROOT_LIB_DIR)/$(LI=
BNAME).la; \

--------------945F744CD487ADD97741E54A--

--eOl4gRGpcxSR3vux7UhXGRQ8TjJDcX8QU--

--aost9Rw9hMsVHaAsxWIPxgTdr9W6idISJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEECbOsLssWnJBDRcxUauHfDWCPItwFAljKvSUACgkQauHfDWCP
Itz3wA//alfRoW4/2DzLIOU4ZkSVoTYQYFYHG6SoYLvNJN51WLTrZvRo+6TqiNkZ
6Do8mRmOOVyZ0rQUd0hrijp+npgZANJngQtgvNxajuwzfv4P4yStPhTxjjfl1wGN
Phtmc7Q6fcJ38wmywbdZRth9bVSWleBYt6YDZtQbGxFpTb7U211lA82bVZBQfw0+
mdmqBT3GTrIYfPbbyuCAEMaiujypdo/di1HGDXNNcqfITnOKab9V4C6y5z3/i/j0
KA5qbmUa8eYoT/mzgT1d+UCo5HrUWYKAM9QT4BckKqqbGTHYvzXuWPJwgwuQDVDy
DwqENRjwYW+OG0gjYluH3ypCGbyDtadXh1dmBqk1rfh3AONNceHqci5i3WEx7Tf9
kv2rA78B8PfvFRDK+eqQ+ENbEaSVwVvgW+Kg3acST0dPXWKLbf21j7ot+tsxRyLi
yX6i57+616kBNbKoG5dtG+KBhoO4OBe9GizpjgC8fJ9O8EDMesdkHsBs6IIp2Mux
RtTp79IvSj3R18bh5WnCp2qQzTxxI/qBg1J2s+m3YJosEfHzUYFtzcPycfZUk4Fp
w9Gh/fuIk8Xq/2/W5Sb3KFzk2+PknjlJ+JqV6/5t7Hg0svfrOs4rVS4V7caNbJOF
c4ckCcEp3zBCzm7rLQXAwoRKU/HoNiuuXg1LgmZZGfBNgZPR8VI=
=tJ+x
-----END PGP SIGNATURE-----

--aost9Rw9hMsVHaAsxWIPxgTdr9W6idISJ--
