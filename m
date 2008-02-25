Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 24 Feb 2008 19:43:33 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m1P3hSSh020778
	for <xfs@oss.sgi.com>; Sun, 24 Feb 2008 19:43:30 -0800
Received: from pc-bnaujok.melbourne.sgi.com (pc-bnaujok.melbourne.sgi.com [134.14.55.58]) by larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id OAA12965 for <xfs@oss.sgi.com>; Mon, 25 Feb 2008 14:43:55 +1100
Date: Mon, 25 Feb 2008 14:45:32 +1100
Subject: [REVIEW] fix mkfs.xfs agcount between 64 and 128MB
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: multipart/mixed; boundary=----------bhyZ9w5nAIrTiCggLJdToo
MIME-Version: 1.0
Message-ID: <op.t61916fp3jf8g2@pc-bnaujok.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

------------bhyZ9w5nAIrTiCggLJdToo
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
Content-Transfer-Encoding: Quoted-Printable

With the AG count =3D 4 changes for a single disk, device sizes between 64M=
B=20=20
and 128MB still scale from 4 to 8 AGs. This is causing some questions!

The attached patch enforces 4 AGs for devices between 64 and 128MB=20=20
(including multi-disk setups, which should be extremely rare at this=20=20
size). This means the AG size will vary from 16 to 32MB depending on the=20=
=20
device size.

Barry.



------------bhyZ9w5nAIrTiCggLJdToo
Content-Disposition: attachment; filename=fix_agcount_in_mkfs_for_small_sizes.patch
Content-Type: text/x-patch; name=fix_agcount_in_mkfs_for_small_sizes.patch
Content-Transfer-Encoding: Quoted-Printable

Index: ci/xfsprogs/mkfs/xfs_mkfs.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- ci.orig/xfsprogs/mkfs/xfs_mkfs.c	2008-02-25 14:36:56.000000000 +1100
+++ ci/xfsprogs/mkfs/xfs_mkfs.c	2008-02-25 14:39:38.249637450 +1100
@@ -412,7 +412,7 @@
 	/*
 	 * First handle the extremes - the points at which we will
 	 * always use the maximum AG size, the points at which we
-	 * always use the minimum, and a "small-step" for 16-128MB.
+	 * always use the minimum, and a "small-step" for 16-64MB.
 	 *
 	 * These apply regardless of storage configuration.
 	 */
@@ -423,13 +423,13 @@
 		blocks =3D dblocks;
 		count =3D 1;
 		goto done;
-	} else if (dblocks < MEGABYTES(128, blocklog)) {
+	} else if (dblocks < MEGABYTES(64, blocklog)) {
 		blocks =3D MEGABYTES(16, blocklog);
 		goto done;
 	}
=20
 	/*
-	 * Sizes between 128MB and 32TB:
+	 * Sizes between 64MB and 32TB:
 	 *
 	 * For the remainder we choose an AG size based on the
 	 * number of data blocks available, trying to keep the
@@ -444,7 +444,7 @@
 	 * scale up smoothly between min/max AG sizes.
 	 */
=20
-	if (!multidisk) {
+	if (!multidisk || dblocks < MEGABYTES(128, blocklog)) {
 		if (dblocks >=3D TERABYTES(4, blocklog)) {
                         blocks =3D XFS_AG_MAX_BLOCKS(blocklog);
                         goto done;

------------bhyZ9w5nAIrTiCggLJdToo--
