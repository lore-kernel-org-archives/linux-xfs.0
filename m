Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1MIuppK058910 for <xfs@oss.sgi.com>; Sun, 22 Feb 2009 12:56:51 -0600
Received: from smtp.gentoo.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7FE8F1985F5C
	for <xfs@oss.sgi.com>; Sun, 22 Feb 2009 10:56:20 -0800 (PST)
Received: from smtp.gentoo.org (smtp.gentoo.org [140.211.166.183]) by
	cuda.sgi.com with ESMTP id 1KT0HzmYpJlt10Fk for
	<xfs@oss.sgi.com>; Sun, 22 Feb 2009 10:56:20 -0800 (PST)
From: Mike Frysinger <vapier@gentoo.org>
Subject: [patch] fix tolower issue in xfsprogs
Date: Sun, 22 Feb 2009 13:55:40 -0500
MIME-Version: 1.0
Message-Id: <200902221355.44626.vapier@gentoo.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4380729979859427113=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>

--===============4380729979859427113==
Content-Type: multipart/signed;
  boundary="nextPart3031919.GeK7OXbSTt";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart3031919.GeK7OXbSTt
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

the xfsprogs uses tolower() in xfs_dir2.c but doesnt include ctype.h for th=
e=20
definition
=2Dmike

=2D-- libxfs/xfs_dir2.c
+++ libxfs/xfs_dir2.c
@@ -22,6 +22,7 @@
  */
=20
 #include <xfs.h>
+#include <ctype.h>	/* for tolower() */
=20
 extern const struct xfs_nameops xfs_default_nameops;
=20


--nextPart3031919.GeK7OXbSTt
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.10 (GNU/Linux)

iQIcBAABAgAGBQJJoZ+wAAoJEEFjO5/oN/WBqhAP/0KXn2tuy0/xtxIc0Oqw12A0
bcSA/aQOlSXzjgDOcrs6ZujV60RYgcVE+YMOltoDrZUEwlTHH3uUJYONMbMJhVkr
pZuTOxBrf1kIMcOhUNxLG3fKVqdMifVulRSk40KStCBzOLMFEiluliwqgdvOI1Gi
nP9ZIBn9op07+3TdSgt3bZVBvPFaXRObulG5XJIjmMj2+RCVXtXf2MNe0Q1g6Rxh
YFSsslJmj6MIps0IMVILpNmsXvzx6Fr26bGcaRvds07X/gugSU0kqx0yZDrm9oi5
wr9pfLVofDLePWA9zXg1H43AJ8bgGRa4qfALlrS2RMfdAxeSh21tETgWoMivbs2v
uiWG3AQ8qUhcCKwA+GcBNuXb+2CYyBZo5/d1IU+k3pwoGX8sOC497Gs0K2Z2k4Hy
TxyCMagGABlfo3rWAlz11boB6OP6OqnwxX2eUZ7cZMPlo3s65Y+vVBQQ6BWBlKoK
X2/H4UDgESCysZXTo3FQjydHfHoQx7Vio/86nuxzROIVug1Q8YhNW3+qPaKAKEwd
zDGhEdf7AzUDUvK12bfb5v8Qh+5SlZrWatRbe+cfLAjIGGWAzwOoRcMpVp6woL82
Sogy8043bvH6SGVQYzROu56iMpjj7l84qRAZ8gl5BInWzpVXkE3/scrlq5v8b/B3
Sb+wq7y607+cBoehjXlK
=kYEX
-----END PGP SIGNATURE-----

--nextPart3031919.GeK7OXbSTt--


--===============4380729979859427113==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4380729979859427113==--
