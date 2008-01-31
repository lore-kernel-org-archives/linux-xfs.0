Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 30 Jan 2008 19:23:06 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m0V3Mwuv027504
	for <xfs@oss.sgi.com>; Wed, 30 Jan 2008 19:23:02 -0800
Message-ID: <47A13F24.4090408@redhat.com>
Date: Wed, 30 Jan 2008 21:23:16 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: xfsprogs patch for calc_default_ag_geometry
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>, Niv Sardi <xaiki@sgi.com>, xfs-oss <xfs@oss.sgi.com>

was just looking at this a little tonight.
I wonder if something like this makes things
any more correct and/or readable.

The patch looks a little ugly but once applied
I think the code makes more sense, it more closely
follows the original spirit of the function, while still
implementing the goal of different geometries for
single disks.

Most importantly it doesn't skip the tricky:

count = dblocks / blocks + (dblocks % blocks != 0);

which is probably what caused the regression.

Or maybe you guys already have your own fix :)

Index: xfsprogs-2.9.5/mkfs/xfs_mkfs.c
===================================================================
--- xfsprogs-2.9.5.orig/mkfs/xfs_mkfs.c
+++ xfsprogs-2.9.5/mkfs/xfs_mkfs.c
@@ -413,6 +413,8 @@ calc_default_ag_geometry(
 	 * First handle the extremes - the points at which we will
 	 * always use the maximum AG size, the points at which we
 	 * always use the minimum, and a "small-step" for 16-128Mb.
+	 *
+	 * These are chosen regardless of single- or multi-disk.
 	 */
 	if (dblocks >= TERABYTES(32, blocklog)) {
 		blocks = XFS_AG_MAX_BLOCKS(blocklog);
@@ -427,6 +429,9 @@ calc_default_ag_geometry(
 	}
 
 	/*
+	 * Sizes in the middle.
+	 *
+	 * For multidisk:
 	 * For the remainder we choose an AG size based on the
 	 * number of data blocks available, trying to keep the
 	 * number of AGs relatively small (especially compared
@@ -436,34 +441,34 @@ calc_default_ag_geometry(
 	 * smaller counts at mkfs time.
 	 *
 	 * This scales us up smoothly between min/max AG sizes.
+	 *
+	 * For a single disk:
+	 * Limit to 4 ags, unless quite large, then
+	 * max out the AG size.
 	 */
 
-	if (!multidisk) {
-		if (dblocks >= TERABYTES(4, blocklog)) {
+	if (multidisk) {
+		if (dblocks > GIGABYTES(512, blocklog))
+			shift = 5;
+		else if (dblocks > GIGABYTES(8, blocklog))
+			shift = 4;
+		else if (dblocks >= MEGABYTES(128, blocklog))
+			shift = 3;
+		else
+			ASSERT(0);
+	} else {
+		if (dblocks < TERABYTES(4, blocklog))
+			shift = 2;
+		else {
                         blocks = XFS_AG_MAX_BLOCKS(blocklog);
-                        goto done;
-                }
-                count = 4;
-
-                goto done;
-        }
-
-	if (dblocks > GIGABYTES(512, blocklog))
-		shift = 5;
-	else if (dblocks > GIGABYTES(8, blocklog))
-		shift = 4;
-	else if (dblocks >= MEGABYTES(128, blocklog))
-		shift = 3;
-	else
-		ASSERT(0);
-	blocks = dblocks >> shift;
+			goto done;
+		}
+	}
 
+	blocks = dblocks >> shift;
 done:
-	ASSERT (count || blocks);
 	if (!count)
 		count = dblocks / blocks + (dblocks % blocks != 0);
-	if (!blocks)
-		blocks = dblocks / count;
 
 	*agsize = blocks;
 	*agcount = count;
