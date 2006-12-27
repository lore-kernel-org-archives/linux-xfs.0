Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 26 Dec 2006 17:41:07 -0800 (PST)
Received: from wx-out-0506.google.com (wx-out-0506.google.com [66.249.82.224])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kBR1f1qw006333
	for <xfs@oss.sgi.com>; Tue, 26 Dec 2006 17:41:03 -0800
Received: by wx-out-0506.google.com with SMTP id t4so3838899wxc
        for <xfs@oss.sgi.com>; Tue, 26 Dec 2006 17:40:09 -0800 (PST)
From: "Diego 'Flameeyes' =?iso-8859-1?q?Petten=F2?=" <flameeyes@gentoo.org>
Subject: Patch for attr and acl to correctly use libtool while crosscompiling
Date: Wed, 27 Dec 2006 02:12:31 +0100
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3264982.kTH0vska8r";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200612270212.40922@enterprise.flameeyes.is-a-geek.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

--nextPart3264982.kTH0vska8r
Content-Type: multipart/mixed;
  boundary="Boundary-01=_AickF+D9x3X3lXi"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--Boundary-01=_AickF+D9x3X3lXi
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

I'm attaching a patch, that applies to attr as well as acl, and allows to=
=20
cross-compile attr and acl, by correctly using GNU libtool (building a loca=
l=20
copy of it) rather than abusing the system one (that might not be suited fo=
r=20
the crosscompile target).

Basically, the search for libtool is demanded to AC_PROG_LIBTOOL macro as=
=20
needed (that requires top_builddir being expanded), and AC_PROG_CC has to b=
e=20
called (or the wrong compiler would be used and libtool would bail out on=
=20
itself at final link).

For acl there's also an extra patch, that removes the use=20
of /usr/lib/libattr.la if found, this because /usr/lib/libattr.la might not=
=20
be compiled for the platform you're building for; just leave -lattr to=20
libtool to expand to the correct .la file (unless building inline in the sa=
me=20
directory).

With these patches applied, crosscompiling acl and attr is a piece of cacke.

HTH,
--=20
Diego "Flameeyes" Petten=F2 - http://farragut.flameeyes.is-a-geek.org/
Gentoo/Alt lead, Gentoo/FreeBSD, Video, Sound, ALSA, PAM, KDE, CJK, Ruby ...

--Boundary-01=_AickF+D9x3X3lXi
Content-Type: text/x-diff;
  charset="iso-8859-1";
  name="attr-2.4.32-libtool.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="attr-2.4.32-libtool.patch"

Index: attr-2.4.32/m4/package_utilies.m4
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- attr-2.4.32.orig/m4/package_utilies.m4
+++ attr-2.4.32/m4/package_utilies.m4
@@ -32,15 +32,7 @@ AC_DEFUN([AC_PACKAGE_UTILITIES],
     AC_SUBST(make)
     AC_PACKAGE_NEED_UTILITY($1, "$make", make, [GNU make])
=20
-    if test -z "$LIBTOOL"; then
-	AC_PATH_PROG(LIBTOOL, glibtool,, /usr/bin)
-    fi
-    if test -z "$LIBTOOL"; then
-	AC_PATH_PROG(LIBTOOL, libtool,, /usr/bin:/usr/local/bin:/usr/freeware/bin)
-    fi
-    libtool=3D$LIBTOOL
-    AC_SUBST(libtool)
-    AC_PACKAGE_NEED_UTILITY($1, "$libtool", libtool, [GNU libtool])
+    AC_PROG_LIBTOOL
=20
     if test -z "$TAR"; then
         AC_PATH_PROG(TAR, tar,, /usr/freeware/bin:/bin:/usr/local/bin:/usr=
/bin)
Index: attr-2.4.32/include/builddefs.in
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- attr-2.4.32.orig/include/builddefs.in
+++ attr-2.4.32/include/builddefs.in
@@ -17,6 +17,7 @@ LIBMISC =3D $(TOPDIR)/libmisc/libmisc.la
=20
 prefix =3D @prefix@
 exec_prefix =3D @exec_prefix@
+top_builddir =3D @top_builddir@
=20
 PKG_NAME	=3D @pkg_name@
 PKG_USER	=3D @pkg_user@
Index: attr-2.4.32/m4/package_globals.m4
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- attr-2.4.32.orig/m4/package_globals.m4
+++ attr-2.4.32/m4/package_globals.m4
@@ -8,6 +8,8 @@ AC_DEFUN([AC_PACKAGE_GLOBALS],
   [ pkg_name=3D"$1"
     AC_SUBST(pkg_name)
=20
+    AC_PROG_CC
+
     . ./VERSION
     pkg_version=3D${PKG_MAJOR}.${PKG_MINOR}.${PKG_REVISION}
     AC_SUBST(pkg_version)

--Boundary-01=_AickF+D9x3X3lXi
Content-Type: text/x-diff;
  charset="iso-8859-1";
  name="acl-2.2.34-leave-las-to-libtool.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="acl-2.2.34-leave-las-to-libtool.patch"

Index: acl-2.2.34/m4/package_attrdev.m4
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- acl-2.2.34.orig/m4/package_attrdev.m4
+++ acl-2.2.34/m4/package_attrdev.m4
@@ -43,7 +43,6 @@ AC_DEFUN([AC_PACKAGE_NEED_GETXATTR_LIBAT
     libattr=3D"-lattr"
     test -f `pwd`/../attr/libattr/libattr.la && \
         libattr=3D"`pwd`/../attr/libattr/libattr.la"
-    test -f /usr/lib/libattr.la && libattr=3D"/usr/lib/libattr.la"
     AC_SUBST(libattr)
   ])
=20

--Boundary-01=_AickF+D9x3X3lXi--

--nextPart3264982.kTH0vska8r
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBFkciIe2h1+2mHVWMRAh0QAKC0leWqxQLLeQV+c9H9sh13sCXlvACeNQ1j
c+sXG2hwzFP7LD/W31+HgXo=
=VJqo
-----END PGP SIGNATURE-----

--nextPart3264982.kTH0vska8r--
