Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 26 Dec 2006 17:38:44 -0800 (PST)
Received: from wx-out-0506.google.com (wx-out-0506.google.com [66.249.82.236])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kBR1ccqw005965
	for <xfs@oss.sgi.com>; Tue, 26 Dec 2006 17:38:38 -0800
Received: by wx-out-0506.google.com with SMTP id t4so3838380wxc
        for <xfs@oss.sgi.com>; Tue, 26 Dec 2006 17:37:46 -0800 (PST)
From: "Diego 'Flameeyes' =?iso-8859-1?q?Petten=F2?=" <flameeyes@gentoo.org>
Subject: Correction: acl patch (to leave the .la file to libtool) for 2.2.39
Date: Wed, 27 Dec 2006 02:37:28 +0100
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2574674.mR8yEfx0HH";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200612270237.28711@enterprise.flameeyes.is-a-geek.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

--nextPart2574674.mR8yEfx0HH
Content-Type: multipart/mixed;
  boundary="Boundary-01=_Y5ckFrcZGtFQ3i0"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--Boundary-01=_Y5ckFrcZGtFQ3i0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

I've erroneously sent the patch for an old version of acl, I'm attaching th=
e=20
correct one for 2.2.39.

--=20
Diego "Flameeyes" Petten=F2 - http://farragut.flameeyes.is-a-geek.org/
Gentoo/Alt lead, Gentoo/FreeBSD, Video, Sound, ALSA, PAM, KDE, CJK, Ruby ...

--Boundary-01=_Y5ckFrcZGtFQ3i0
Content-Type: text/x-diff;
  charset="us-ascii";
  name="acl-2.2.39-leave-las-to-libtool.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="acl-2.2.39-leave-las-to-libtool.patch"

Index: acl-2.2.39/m4/package_attrdev.m4
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- acl-2.2.39.orig/m4/package_attrdev.m4
+++ acl-2.2.39/m4/package_attrdev.m4
@@ -48,8 +48,6 @@ AC_DEFUN([AC_PACKAGE_NEED_GETXATTR_LIBAT
     libattr=3D"-lattr"
     test -f `pwd`/../attr/libattr/libattr.la && \
         libattr=3D"`pwd`/../attr/libattr/libattr.la"
-    test -f ${libexecdir}${libdirsuffix}/libattr.la && \
-	libattr=3D"${libexecdir}${libdirsuffix}/libattr.la"
     AC_SUBST(libattr)
   ])
=20
@@ -64,8 +62,6 @@ AC_DEFUN([AC_PACKAGE_NEED_ATTRGET_LIBATT
     libattr=3D"-lattr"
     test -f `pwd`/../attr/libattr/libattr.la && \
         libattr=3D"`pwd`/../attr/libattr/libattr.la"
-    test -f ${libexecdir}${libdirsuffix}/libattr.la && \
-	libattr=3D"${libexecdir}${libdirsuffix}/libattr.la"
     AC_SUBST(libattr)
   ])
=20

--Boundary-01=_Y5ckFrcZGtFQ3i0--

--nextPart2574674.mR8yEfx0HH
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBFkc5Ye2h1+2mHVWMRAkCnAJ4k3O2JrnPAwhRcyiO85Fum7xEVqQCglKLs
VTNZ3fcAeKtrJxSWGgIgZS0=
=YFBW
-----END PGP SIGNATURE-----

--nextPart2574674.mR8yEfx0HH--
