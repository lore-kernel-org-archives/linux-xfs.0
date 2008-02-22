Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 21 Feb 2008 19:54:21 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m1M3sDdo030429
	for <xfs@oss.sgi.com>; Thu, 21 Feb 2008 19:54:15 -0800
Received: from pc-bnaujok.melbourne.sgi.com (pc-bnaujok.melbourne.sgi.com [134.14.55.58]) by larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id OAA10512 for <xfs@oss.sgi.com>; Fri, 22 Feb 2008 14:54:39 +1100
Date: Fri, 22 Feb 2008 14:56:20 +1100
Subject: [REVIEW] Fix end of device zeroing with > 1K sector sizes
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: multipart/mixed; boundary=----------KKkRnrShlLmYU3HHyEqPoq
MIME-Version: 1.0
Message-ID: <op.t6wqj6zq3jf8g2@pc-bnaujok.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

------------KKkRnrShlLmYU3HHyEqPoq
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
Content-Transfer-Encoding: Quoted-Printable

It has been found that mkfs with big sector sizes and devices/partitions
that aren't aligned to the sector size can cause short writes when zeroing
the end of the device. As mkfs.xfs didn't complete, the filesystem is
unmountable.

Eg:

# mkfs.xfs -f -L fs_1 -s size=3D4096 -l size=3D64m,sunit=3D512 /dev/hdd1
mkfs.xfs: error - wrote only 130048 of 131072 bytes


The attached patch rounds down the device size to either 1K or
the sector size, whichever is greater.

Barry.
------------KKkRnrShlLmYU3HHyEqPoq
Content-Disposition: attachment; filename=fix_eodev_zeroing.patch
Content-Type: text/x-patch; name=fix_eodev_zeroing.patch
Content-Transfer-Encoding: Quoted-Printable

--- a/xfsprogs/mkfs/xfs_mkfs.c	2008-02-22 14:48:27.000000000 +1100
+++ b/xfsprogs/mkfs/xfs_mkfs.c	2008-02-22 14:41:38.093984235 +1100
@@ -703,6 +703,7 @@ main(
 	int			sectoralign;
 	int			sectorlog;
 	unsigned int		sectorsize;
+	__uint64_t		sector_mask;
 	int			slflag;
 	int			ssflag;
 	__uint64_t		tmp_agsize;
@@ -1637,12 +1638,18 @@ main(
 	 * Ok, Linux only has a 1024-byte resolution on device _size_,
 	 * and the sizes below are in basic 512-byte blocks,
 	 * so if we have (size % 2), on any partition, we can't get
-	 * to the last 512 bytes.  Just chop it down by a block.
+	 * to the last 512 bytes.  The same issue exists for larger
+	 * sector sizes - we cannot write past the last sector.
+	 *
+	 * So, we reduce the size (in basic blocks) to a perfect
+	 * multiple of the sector size, or 1024, whichever is larger.
 	 */
=20
-	xi.dsize -=3D (xi.dsize % 2);
-	xi.rtsize -=3D (xi.rtsize % 2);
-	xi.logBBsize -=3D (xi.logBBsize % 2);
+	sector_mask =3D xfs_mask64hi((sectorlog < 10 ? 10 : sectorlog) - BBSHIFT);
+	xi.dsize &=3D sector_mask;
+	xi.rtsize &=3D sector_mask;
+	xi.logBBsize &=3D xfs_mask64hi((lsectorlog < 10 ? 10 : lsectorlog) -
+				BBSHIFT);
=20
 	if (!force_overwrite) {
 		if (check_overwrite(dfile) ||

------------KKkRnrShlLmYU3HHyEqPoq--
