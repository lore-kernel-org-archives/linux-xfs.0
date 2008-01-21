Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 20 Jan 2008 21:36:16 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m0L5a5nc018018
	for <xfs@oss.sgi.com>; Sun, 20 Jan 2008 21:36:10 -0800
Date: Mon, 21 Jan 2008 16:37:53 +1100
Subject: [REVIEW] growfs support for CI
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: multipart/mixed; boundary=----------cnxN6PYfs48WGnrhyS2w9D
MIME-Version: 1.0
Message-ID: <op.t49lxfd93jf8g2@pc-bnaujok.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>, xfs-dev <xfs-dev@sgi.com>

------------cnxN6PYfs48WGnrhyS2w9D
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
Content-Transfer-Encoding: 7bit

Missed in the first set of patches was xfs_growfs/xfs_info support
for the CI stuff.

Attached is additional patches for kernel and user-space.

Barry.
------------cnxN6PYfs48WGnrhyS2w9D
Content-Disposition: attachment; filename=ci_growfs_kernel.patch
Content-Type: text/x-patch; name=ci_growfs_kernel.patch
Content-Transfer-Encoding: Base64

Cj09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQpmcy94ZnMveGZzX2Zz
LmgKPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09CgotLS0gYS9mcy94
ZnMveGZzX2ZzLmgJMjAwOC0wMS0yMSAxNjozNDowMC4wMDAwMDAwMDAgKzEx
MDAKKysrIGIvZnMveGZzL3hmc19mcy5oCTIwMDgtMDEtMjEgMTY6MTg6MjMu
NzQ4NjI2NTQ1ICsxMTAwCkBAIC0yMzksNyArMjM5LDkgQEAgdHlwZWRlZiBz
dHJ1Y3QgeGZzX2Zzb3BfcmVzYmxrcyB7CiAjZGVmaW5lIFhGU19GU09QX0dF
T01fRkxBR1NfTE9HVjIJMHgwMTAwCS8qIGxvZyBmb3JtYXQgdmVyc2lvbiAy
CSovCiAjZGVmaW5lIFhGU19GU09QX0dFT01fRkxBR1NfU0VDVE9SCTB4MDIw
MAkvKiBzZWN0b3Igc2l6ZXMgPjFCQgkqLwogI2RlZmluZSBYRlNfRlNPUF9H
RU9NX0ZMQUdTX0FUVFIyCTB4MDQwMAkvKiBpbmxpbmUgYXR0cmlidXRlcyBy
ZXdvcmsgKi8KKyNkZWZpbmUgWEZTX0ZTT1BfR0VPTV9GTEFHU19ESVJWMkNJ
CTB4MTAwMAkvKiBBU0NJSSBvbmx5IENJIG5hbWVzICovCiAjZGVmaW5lIFhG
U19GU09QX0dFT01fRkxBR1NfTEFaWVNCCTB4NDAwMAkvKiBsYXp5IHN1cGVy
YmxvY2sgY291bnRlcnMgKi8KKyNkZWZpbmUgWEZTX0ZTT1BfR0VPTV9GTEFH
U19VTklDT0RFCTB4MTAwMDAJLyogdW5pY29kZSBmaWxlbmFtZXMgKi8KIAog
CiAvKgoKPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09CmZzL3hmcy94
ZnNfZnNvcHMuYwo9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0KCi0t
LSBhL2ZzL3hmcy94ZnNfZnNvcHMuYwkyMDA4LTAxLTIxIDE2OjM0OjAwLjAw
MDAwMDAwMCArMTEwMAorKysgYi9mcy94ZnMveGZzX2Zzb3BzLmMJMjAwOC0w
MS0yMSAxNjoxMzoxMC42MDgyNzkzMTEgKzExMDAKQEAgLTk1LDEwICs5NSwx
NCBAQCB4ZnNfZnNfZ2VvbWV0cnkoCiAJCQkJWEZTX0ZTT1BfR0VPTV9GTEFH
U19ESVJWMiA6IDApIHwKIAkJCShYRlNfU0JfVkVSU0lPTl9IQVNTRUNUT1Io
Jm1wLT5tX3NiKSA/CiAJCQkJWEZTX0ZTT1BfR0VPTV9GTEFHU19TRUNUT1Ig
OiAwKSB8CisJCQkoeGZzX3NiX3ZlcnNpb25faGFzb2xkY2koJm1wLT5tX3Ni
KSA/CisJCQkJWEZTX0ZTT1BfR0VPTV9GTEFHU19ESVJWMkNJIDogMCkgfAog
CQkJKHhmc19zYl92ZXJzaW9uX2hhc2xhenlzYmNvdW50KCZtcC0+bV9zYikg
PwogCQkJCVhGU19GU09QX0dFT01fRkxBR1NfTEFaWVNCIDogMCkgfAogCQkJ
KFhGU19TQl9WRVJTSU9OX0hBU0FUVFIyKCZtcC0+bV9zYikgPwotCQkJCVhG
U19GU09QX0dFT01fRkxBR1NfQVRUUjIgOiAwKTsKKwkJCQlYRlNfRlNPUF9H
RU9NX0ZMQUdTX0FUVFIyIDogMCkgfAorCQkJKHhmc19zYl92ZXJzaW9uX2hh
c3VuaWNvZGUoJm1wLT5tX3NiKSA/CisJCQkJWEZTX0ZTT1BfR0VPTV9GTEFH
U19VTklDT0RFIDogMCk7CiAJCWdlby0+bG9nc2VjdHNpemUgPSBYRlNfU0Jf
VkVSU0lPTl9IQVNTRUNUT1IoJm1wLT5tX3NiKSA/CiAJCQkJbXAtPm1fc2Iu
c2JfbG9nc2VjdHNpemUgOiBCQlNJWkU7CiAJCWdlby0+cnRzZWN0c2l6ZSA9
IG1wLT5tX3NiLnNiX2Jsb2Nrc2l6ZTsK

------------cnxN6PYfs48WGnrhyS2w9D
Content-Disposition: attachment; filename=ci_growfs_user.patch
Content-Type: text/x-patch; name=ci_growfs_user.patch
Content-Transfer-Encoding: Quoted-Printable

Index: ci/xfsprogs/growfs/xfs_growfs.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- ci.orig/xfsprogs/growfs/xfs_growfs.c	2008-01-17 12:46:36.000000000 +1100
+++ ci/xfsprogs/growfs/xfs_growfs.c	2008-01-21 16:28:58.581225955 +1100
@@ -59,7 +59,7 @@
 	char		*logname,
 	char		*rtname,
 	int		lazycount,
-	int		dirversion,
+	char		*dirversion,
 	int		logversion,
 	int		attrversion)
 {
@@ -68,7 +68,7 @@
 	    "         =3D%-22s sectsz=3D%-5u attr=3D%u\n"
 	    "data     =3D%-22s bsize=3D%-6u blocks=3D%llu, imaxpct=3D%u\n"
 	    "         =3D%-22s sunit=3D%-6u swidth=3D%u blks\n"
-	    "naming   =3Dversion %-14u bsize=3D%-6u\n"
+	    "naming   =3Dversion %-14s bsize=3D%-6u%s\n"
 	    "log      =3D%-22s bsize=3D%-6u blocks=3D%u, version=3D%u\n"
 	    "         =3D%-22s sectsz=3D%-5u sunit=3D%u blks, lazy-count=3D%u\n"
 	    "realtime =3D%-22s extsz=3D%-6u blocks=3D%llu, rtextents=3D%llu\n"),
@@ -79,6 +79,7 @@
 			geo.imaxpct,
 		"", geo.sunit, geo.swidth,
   		dirversion, geo.dirblocksize,
+  		geo.flags & XFS_FSOP_GEOM_FLAGS_UNICODE ? " utf8" : "",
 		isint ? _("internal") : logname ? logname : _("external"),
 			geo.blocksize, geo.logblocks, logversion,
 		"", geo.logsectsize, geo.logsunit / geo.blocksize, lazycount,
@@ -95,7 +96,7 @@
 	long long		ddsize;	/* device size in 512-byte blocks */
 	int			dflag;	/* -d flag */
 	int			attrversion;/* attribute version number */
-	int			dirversion; /* directory version number */
+	char			*dirversion; /* directory version */
 	int			logversion; /* log version number */
 	long long		dlsize;	/* device size in 512-byte blocks */
 	long long		drsize;	/* device size in 512-byte blocks */
@@ -235,7 +236,8 @@
 	}
 	isint =3D geo.logstart > 0;
 	lazycount =3D geo.flags & XFS_FSOP_GEOM_FLAGS_LAZYSB ? 1 : 0;
-	dirversion =3D geo.flags & XFS_FSOP_GEOM_FLAGS_DIRV2 ? 2 : 1;
+	dirversion =3D geo.flags & XFS_FSOP_GEOM_FLAGS_DIRV2CI ? "ci" :
+			geo.flags & XFS_FSOP_GEOM_FLAGS_DIRV2 ? "2" : "1";
 	logversion =3D geo.flags & XFS_FSOP_GEOM_FLAGS_LOGV2 ? 2 : 1;
 	attrversion =3D geo.flags & XFS_FSOP_GEOM_FLAGS_ATTR2 ? 2 : \
 			(geo.flags & XFS_FSOP_GEOM_FLAGS_ATTR ? 1 : 0);
Index: ci/xfsprogs/include/xfs_fs.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- ci.orig/xfsprogs/include/xfs_fs.h	2007-10-10 16:12:47.000000000 +1000
+++ ci/xfsprogs/include/xfs_fs.h	2008-01-21 16:18:09.726376630 +1100
@@ -241,7 +241,9 @@
 #define XFS_FSOP_GEOM_FLAGS_LOGV2	0x0100	/* log format version 2	*/
 #define XFS_FSOP_GEOM_FLAGS_SECTOR	0x0200	/* sector sizes >1BB	*/
 #define XFS_FSOP_GEOM_FLAGS_ATTR2	0x0400	/* inline attributes rework */
+#define XFS_FSOP_GEOM_FLAGS_DIRV2CI	0x1000	/* ASCII only CI names */
 #define XFS_FSOP_GEOM_FLAGS_LAZYSB	0x4000	/* lazy superblock counters */
+#define XFS_FSOP_GEOM_FLAGS_UNICODE	0x10000	/* unicode filenames */
=20
=20
 /*

------------cnxN6PYfs48WGnrhyS2w9D--
