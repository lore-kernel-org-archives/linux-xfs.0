Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n3826SBb053929 for <xfs@oss.sgi.com>; Tue, 7 Apr 2009 21:06:43 -0500
Received: from smtp.nchc.org.tw (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C24651F8B95
	for <xfs@oss.sgi.com>; Tue,  7 Apr 2009 19:05:48 -0700 (PDT)
Received: from smtp.nchc.org.tw (smtp.nchc.org.tw [140.110.16.10]) by
	cuda.sgi.com with ESMTP id fIV8FEi7j4aJYVnr for
	<xfs@oss.sgi.com>; Tue, 07 Apr 2009 19:05:48 -0700 (PDT)
Date: Wed, 8 Apr 2009 10:05:45 +0800
From: Thomas Tsai <thomas@nchc.org.tw>
Subject: Build xfs 3.0 deb problem
Message-Id: <20090408100545.2354f572.thomas@nchc.org.tw>
Mime-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3093327086829252462=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============3093327086829252462==
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__8_Apr_2009_10_05_45_+0800_7HkNsx9dhK+G4FLi"

--Signature=_Wed__8_Apr_2009_10_05_45_+0800_7HkNsx9dhK+G4FLi
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello xfs,

I get the source tarball and easy run Makepkgs debian
The build result look fine but lose some library files like libxfs.a....

I really need libxfs-dev to build my package.
Please give me a hand, tkx.

-- dpkg -L xfslibs-dev
/.
/lib
/usr
/usr/lib
/usr/lib/libhandle.la
/usr/lib/libhandle.a
/usr/lib/libdisk.a
/usr/share
/usr/share/doc
/usr/share/doc/xfslibs-dev
/usr/share/doc/xfslibs-dev/copyright
/usr/share/doc/xfslibs-dev/changelog.Debian.gz
/usr/share/man
/usr/share/man/man3
/usr/share/man/man3/path_to_handle.3.gz =20
/usr/share/man/man3/xfsctl.3.gz
/usr/include
/usr/include/xfs
/usr/include/xfs/jdm.h
/usr/include/xfs/xfs.h
/usr/include/xfs/xqm.h
/usr/include/xfs/linux.h
/usr/include/xfs/handle.h
/usr/include/xfs/platform_defs.h
/usr/include/xfs/xfs_fs.h
/lib/libhandle.la
/lib/libhandle.so
/lib/libhandle.a
/usr/lib/libhandle.so
/usr/share/man/man3/attr_list_by_handle.3.gz
/usr/share/man/man3/path_to_fshandle.3.gz
/usr/share/man/man3/handle_to_fshandle.3.gz
...more man files

--=20
Thomas Tsai <thomas@nchc.org.tw>

--Signature=_Wed__8_Apr_2009_10_05_45_+0800_7HkNsx9dhK+G4FLi
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFJ3AZ8XpcitEY3ms8RApmzAJ4u6SZDy8hi7DHLa8cjFSpczrjQuACcDjmr
3FvWyR4UyagFW55fiFImrT8=
=GEcJ
-----END PGP SIGNATURE-----

--Signature=_Wed__8_Apr_2009_10_05_45_+0800_7HkNsx9dhK+G4FLi--


--===============3093327086829252462==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3093327086829252462==--
