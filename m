Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o2LE7C4X151751 for <xfs@oss.sgi.com>; Sun, 21 Mar 2010 09:07:12 -0500
Received: from smtp.plastictree.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 75DA1265301
	for <xfs@oss.sgi.com>; Sun, 21 Mar 2010 07:08:50 -0700 (PDT)
Received: from smtp.plastictree.net (h1283867.stratoserver.net [85.214.127.6])
	by cuda.sgi.com with ESMTP id 0EylxrYCIUVMwJz9 for
	<xfs@oss.sgi.com>; Sun, 21 Mar 2010 07:08:50 -0700 (PDT)
Date: Sun, 21 Mar 2010 15:13:50 +0100
From: Lasse Kliemann <lasse-private-2010@mail.plastictree.net>
Subject: builddefs.in
Message-ID: <20100321141349.GE1827@lasse.mail.plastictre.net>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6338297734058103298=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============6338297734058103298==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NOl3kBTBh+CNLogO"
Content-Disposition: inline


--NOl3kBTBh+CNLogO
Content-Type: multipart/mixed; boundary="yEbVe0JFHWhrOjGA"
Content-Disposition: inline


--yEbVe0JFHWhrOjGA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Using 3.1.1.

When configured with a '--prefix', the build fails:

[...]
    [CC]     linux.lo
    [LD]     libxfs.la
libtool: link: only absolute run-paths are allowed
gmake[2]: *** [libxfs.la] Error 1
gmake[1]: *** [libxfs] Error 2
make: *** [default] Error 2

Calling 'make' in 'libxfs' reveals that '-rpath' option is used=20
with no argument. The attached patch remedies this. Indeed, with=20
this patch the correct argument is given to '-rpath', at least in=20
'libxfs' subdirectory.=20

It also remedies a similar problem when installing executables=20
into '.../sbin' directory.

--yEbVe0JFHWhrOjGA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="builddefs.in-patch"
Content-Transfer-Encoding: quoted-printable

diff --git a/include/builddefs.in b/include/builddefs.in
index cc75b5d..801b09e 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -52,8 +52,8 @@ datarootdir	=3D @datarootdir@
 top_builddir	=3D @top_builddir@
=20
 PKG_SBIN_DIR	=3D @sbindir@
-PKG_ROOT_SBIN_DIR =3D @root_sbindir@
-PKG_ROOT_LIB_DIR=3D @root_libdir@@libdirsuffix@
+PKG_ROOT_SBIN_DIR =3D @sbindir@
+PKG_ROOT_LIB_DIR=3D @libdir@@libdirsuffix@
 PKG_LIB_DIR	=3D @libdir@@libdirsuffix@
 PKG_INC_DIR	=3D @includedir@/xfs
 DK_INC_DIR	=3D @includedir@/disk

--yEbVe0JFHWhrOjGA--

--NOl3kBTBh+CNLogO
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iQIcBAEBAgAGBQJLpimdAAoJEFYll6N4nhdvNlcP/28cecgsrGhmvCXSihc9P1L3
todqTUL6XTyI1DUrubpm6vqsI0G0jdoaZW9Arsk8ryXbNrPHkomjQ7CPDrwjLzc7
da4culR2yLgfl/zVkEg974vMdtMg8pMJCKP83j2Q2XuzNmhVrfkJ5o8K2X+sYgX6
T3rIjIPhMivxDSefpOeUtKSpLivhqPKPYGoPEv4cvF2dvdx8mwKL4XWvCrVlAECX
VMhPT4iw4zdnN5YqWqvEgLtw9DKZqs3h1K4XcAb1/smmurb6jLWfSLpbgwg3Loy6
JZNXwxXvhAnz58iarLxblE14kTunU/vgTTWEmBlX2KrRsyF/7FSirfcxJwtvywnz
vTzNnAygRJAWN2skYcMFQOv0DkiIdzkANTcARKS+fFC3lfMMsPKqLejku9/baLqk
UxZjWR3zuxKD1/8RQIrNrJMd6k5LYulcAJTK/jVgPxhFsTEoleeUa18vlF3eaISE
EuUJ/aZK7zSuF2w31tOi5dIlv4K6VwcM8Sy4yt2PFKvKaND1v4lccFZdfSJsDLwg
AaO5GvoT55Y2L8kgOyZ3pegMkIc1vd+40f/n6IXXniPb/ES/DRe8bjFnn/4wxA7H
sBmO5d3U9WMYZJlJAwhUYf/PeXZJxFXPW+gAp+vZCD4ta1RptWTMLazz93N92t9A
D6uZO9aEwmV0zEYfqs7s
=sKLD
-----END PGP SIGNATURE-----

--NOl3kBTBh+CNLogO--


--===============6338297734058103298==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6338297734058103298==--
