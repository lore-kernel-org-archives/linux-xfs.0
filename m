Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 24 Feb 2008 23:00:46 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m1P70brx016133
	for <xfs@oss.sgi.com>; Sun, 24 Feb 2008 23:00:40 -0800
Received: from pc-bnaujok.melbourne.sgi.com (pc-bnaujok.melbourne.sgi.com [134.14.55.58]) by larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id SAA18773 for <xfs@oss.sgi.com>; Mon, 25 Feb 2008 18:01:04 +1100
Date: Mon, 25 Feb 2008 18:03:31 +1100
Subject: [REVIEW #2] fix mkfs.xfs agcount between 16 and 128MB
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: multipart/mixed; boundary=----------jZbBGAEb7HRbAuSRp8Iqpc
MIME-Version: 1.0
References: <op.t61916fp3jf8g2@pc-bnaujok.melbourne.sgi.com>
Message-ID: <op.t62i75mp3jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <op.t61916fp3jf8g2@pc-bnaujok.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

------------jZbBGAEb7HRbAuSRp8Iqpc
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
Content-Transfer-Encoding: Quoted-Printable

On Mon, 25 Feb 2008 14:45:32 +1100, Barry Naujok <bnaujok@sgi.com> wrote:

> With the AG count =3D 4 changes for a single disk, device sizes between=
=20=20
> 64MB
> and 128MB still scale from 4 to 8 AGs. This is causing some questions!
>
> The attached patch enforces 4 AGs for devices between 64 and 128MB
> (including multi-disk setups, which should be extremely rare at this
> size). This means the AG size will vary from 16 to 32MB depending on the
> device size.
>
> Barry.

With more questioning and playing, it seems < 64MB wasn't exactly optimal
either. Basically, the size was always rounded to a multiple of 16MB
(which is the minimum AG size).

The new patch basically enforces agcount=3D2 for 32 to 64MB and agcount=3D1
for less than 32MB.


------------jZbBGAEb7HRbAuSRp8Iqpc
Content-Disposition: attachment; filename=fix_agcount_in_mkfs_for_small_sizes.patch
Content-Type: text/x-patch; name=fix_agcount_in_mkfs_for_small_sizes.patch
Content-Transfer-Encoding: Quoted-Printable

Index: ci/xfsprogs/mkfs/xfs_mkfs.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- ci.orig/xfsprogs/mkfs/xfs_mkfs.c	2008-02-25 14:36:56.000000000 +1100
+++ ci/xfsprogs/mkfs/xfs_mkfs.c	2008-02-25 17:59:53.722217734 +1100
@@ -410,27 +410,17 @@
 	int		shift =3D 0;
=20
 	/*
-	 * First handle the extremes - the points at which we will
-	 * always use the maximum AG size, the points at which we
-	 * always use the minimum, and a "small-step" for 16-128MB.
+	 * First handle the high extreme - the point at which we will
+	 * always use the maximum AG size.
 	 *
 	 * These apply regardless of storage configuration.
 	 */
 	if (dblocks >=3D TERABYTES(32, blocklog)) {
 		blocks =3D XFS_AG_MAX_BLOCKS(blocklog);
 		goto done;
-	} else if (dblocks < MEGABYTES(16, blocklog)) {
-		blocks =3D dblocks;
-		count =3D 1;
-		goto done;
-	} else if (dblocks < MEGABYTES(128, blocklog)) {
-		blocks =3D MEGABYTES(16, blocklog);
-		goto done;
 	}
=20
 	/*
-	 * Sizes between 128MB and 32TB:
-	 *
 	 * For the remainder we choose an AG size based on the
 	 * number of data blocks available, trying to keep the
 	 * number of AGs relatively small (especially compared
@@ -439,25 +429,29 @@
 	 * count can be increased by growfs, so prefer to use
 	 * smaller counts at mkfs time.
 	 *
-	 * For a single underlying storage device less than 4TB
-	 * in size, just use 4 AGs, otherwise (for JBOD/RAIDs)
-	 * scale up smoothly between min/max AG sizes.
+	 * For a single underlying storage device between 128MB
+	 * and 4TB in size, just use 4 AGs, otherwise scale up
+	 * smoothly between min/max AG sizes.
 	 */
=20
-	if (!multidisk) {
+	if (!multidisk && dblocks >=3D MEGABYTES(128, blocklog)) {
 		if (dblocks >=3D TERABYTES(4, blocklog)) {
-                        blocks =3D XFS_AG_MAX_BLOCKS(blocklog);
-                        goto done;
-                }
-                shift =3D 2;
-        } else if (dblocks > GIGABYTES(512, blocklog))
+			blocks =3D XFS_AG_MAX_BLOCKS(blocklog);
+			goto done;
+		}
+		shift =3D 2;
+	} else if (dblocks > GIGABYTES(512, blocklog))
 		shift =3D 5;
 	else if (dblocks > GIGABYTES(8, blocklog))
 		shift =3D 4;
 	else if (dblocks >=3D MEGABYTES(128, blocklog))
 		shift =3D 3;
+	else if (dblocks >=3D MEGABYTES(64, blocklog))
+		shift =3D 2;
+	else if (dblocks >=3D MEGABYTES(32, blocklog))
+		shift =3D 1;
 	else
-		ASSERT(0);
+		shift =3D 0;
 	/*
 	 * If dblocks is not evenly divisible by the number of
 	 * desired AGs, round "blocks" up so we don't lose the

------------jZbBGAEb7HRbAuSRp8Iqpc--
