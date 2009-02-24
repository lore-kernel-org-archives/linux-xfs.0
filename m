Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1O5Aw37125434 for <xfs@oss.sgi.com>; Mon, 23 Feb 2009 23:10:58 -0600
Received: from smtp.gentoo.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 875BF144C36
	for <xfs@oss.sgi.com>; Mon, 23 Feb 2009 21:10:27 -0800 (PST)
Received: from smtp.gentoo.org (smtp.gentoo.org [140.211.166.183]) by
	cuda.sgi.com with ESMTP id 8fK9zyYiy0B1v2xI for
	<xfs@oss.sgi.com>; Mon, 23 Feb 2009 21:10:27 -0800 (PST)
From: Mike Frysinger <vapier@gentoo.org>
Subject: [patch] fix parallel build failures in xfsprogs-3.0.0
Date: Tue, 24 Feb 2009 00:10:24 -0500
MIME-Version: 1.0
Message-Id: <200902240010.25434.vapier@gentoo.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1119520011912637804=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>

--===============1119520011912637804==
Content-Type: multipart/signed;
  boundary="nextPart2705183.h6C4sm1jTP";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart2705183.h6C4sm1jTP
Content-Type: multipart/mixed;
  boundary="Boundary-01=_BF4oJ/7tfLnCkw+"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--Boundary-01=_BF4oJ/7tfLnCkw+
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

i noticed that xfsprogs-3.0.0 sometimes fails to build in parallel with an=
=20
error about fsr not being able to find libhandle.  looking at the top level=
=20
Makefile shows the obvious missing depend (fsr: libhandle).  playing around=
 a=20
bit found a few more not so obvious missing depends on the include subdir, =
so=20
i fixed that too.
=2Dmike

--Boundary-01=_BF4oJ/7tfLnCkw+
Content-Type: text/x-patch;
  charset="us-ascii";
  name="xfsprogs-3.0.0-parallel-build.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline;
	filename="xfsprogs-3.0.0-parallel-build.patch"

http://bugs.gentoo.org/260005

=2D-- a/Makefile
+++ b/Makefile
@@ -15,11 +15,11 @@
 LDIRT =3D config.log .dep config.status config.cache confdefs.h conftest* \
 	Logs/* built .census install.* install-dev.* *.gz
=20
=2DLIB_SUBDIRS =3D include libxfs libxlog libxcmd libhandle libdisk
+LIB_SUBDIRS =3D libxfs libxlog libxcmd libhandle libdisk
 TOOL_SUBDIRS =3D copy db estimate fsck fsr growfs io logprint mkfs quota \
 		mdrestore repair rtcp m4 man doc po debian build
=20
=2DSUBDIRS =3D $(LIB_SUBDIRS) $(TOOL_SUBDIRS)
+SUBDIRS =3D include $(LIB_SUBDIRS) $(TOOL_SUBDIRS)
=20
 default: include/builddefs include/platform_defs.h
 ifeq ($(HAVE_BUILDDEFS), no)
@@ -29,9 +29,10 @@
 endif
=20
 # tool/lib dependencies
=2Dlibxcmd: include
+$(LIB_SUBDIRS) $(TOOL_SUBDIRS): include
 copy mdrestore: libxfs
 db logprint: libxfs libxlog
+fsr: libhandle
 growfs: libxfs libxcmd
 io: libxcmd libhandle
 mkfs: libxfs libdisk

--Boundary-01=_BF4oJ/7tfLnCkw+--

--nextPart2705183.h6C4sm1jTP
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.10 (GNU/Linux)

iQIcBAABAgAGBQJJo4FBAAoJEEFjO5/oN/WBGZMQAMni1duSq5s8JbuGo7IncM8R
fy7snAKvLvVHmaNMiUdRp8t3W/M/9qcQSXxVN3WKG9g6oZ4WW4fh+kca2di4m55G
WVoxqTM5x8c8k3ELyAekowVpRyLEh+kkIZPcGtluk0enxUj8DnwP4u9b65kC0SOK
+d6Beke0wHStOpJ93dAJQ4VT5xbacXbJcUBXMn3QpRntqiAA/iiG02L2dYpRlqET
OU3b1hcyOtIJ+roGYxeKlrTvT1ifnAolvyHSsYgZwHAkjL/zKExMGM1kPBSB0Zst
2wEpeS0FiXmUtQAOehfEHcojwb4H0ty8vsPnIZ7MoufJ8jXmQ7bjYXkIrNZRle5a
7lI5FA0H5cKAlei5n15yGYpE9yB2nGVz21E1ttyHn+0AEO+jWjyG/Aq/tGRNpv7P
NATuhRiLtrOYM3vX/TCjMyLaEO/PQBSOxjngpBJc2beMVkH5zXveTv70iVMZ9xXa
F64nX8hfnNd3KnnauokohrIRnCxHFpM5qBQ3FOPdK7GXOryE4lntwQEdDKf6K/xW
92MgkothGWHUm0Yn50WSzlvpmMDqz/LoHIKepfmz84WIXHzcA2Rx7JOL0FeBgL+y
9ym7UoHy1xWqXiN41pgePWdCMZZZC/kFr+s/neS2WlTc2QW95UEyRzfqks2RMt4C
7z1QhVwey05GJbPW/Ynd
=pGVo
-----END PGP SIGNATURE-----

--nextPart2705183.h6C4sm1jTP--


--===============1119520011912637804==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1119520011912637804==--
