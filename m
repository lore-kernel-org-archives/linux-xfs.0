Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 12 Nov 2007 20:11:26 -0800 (PST)
Received: from itchy (dhcp17.melbourne.sgi.com [134.14.55.17])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lAD4B93Y012369
	for <xfs@oss.sgi.com>; Mon, 12 Nov 2007 20:11:11 -0800
From: xaiki@sgi.com
Subject: [PATCH TAKE 2 6/6] less AGs for single disks configs.
Date: Tue, 13 Nov 2007 15:10:57 +1100
Message-Id: <1194927057-26415-7-git-send-email-xaiki@sgi.com>
In-Reply-To: <1194927057-26415-6-git-send-email-xaiki@sgi.com>
References: <20071029075657.GA84369978@melbourne.sgi.com>
 <1194927057-26415-1-git-send-email-xaiki@sgi.com>
 <1194927057-26415-2-git-send-email-xaiki@sgi.com>
 <1194927057-26415-3-git-send-email-xaiki@sgi.com>
 <1194927057-26415-4-git-send-email-xaiki@sgi.com>
 <1194927057-26415-5-git-send-email-xaiki@sgi.com>
 <1194927057-26415-6-git-send-email-xaiki@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: Niv Sardi <xaiki@sgi.com>

From: Niv Sardi <xaiki@sgi.com>

get the underlying structure with get_subvol_stripe_wrapper(),
and pass sunit | swidth as an argument to calc_default_ag_geometry().

if it is set, we are in single disk, get XFS_AG_MAX_BLOCKS for FS >= 4TB,
and calculate ag numbers regarding to that.
get 4 AGs for FS < 4TB.

we calculate according to blocks or count if we have them, add an assert to
ensure we have one of the 2.
---
 xfsprogs/mkfs/xfs_mkfs.c |   28 ++++++++++++++++++++++++----
 1 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/xfsprogs/mkfs/xfs_mkfs.c b/xfsprogs/mkfs/xfs_mkfs.c
index a8af6e2..e15d667 100644
--- a/xfsprogs/mkfs/xfs_mkfs.c
+++ b/xfsprogs/mkfs/xfs_mkfs.c
@@ -401,10 +401,11 @@ void
 calc_default_ag_geometry(
 	int		blocklog,
 	__uint64_t	dblocks,
+	int		multidisk,
 	__uint64_t	*agsize,
 	__uint64_t	*agcount)
 {
-	__uint64_t	blocks;
+	__uint64_t	blocks = 0;
 	__uint64_t	count = 0;
 	int		shift = 0;
 
@@ -436,6 +437,17 @@ calc_default_ag_geometry(
 	 *
 	 * This scales us up smoothly between min/max AG sizes.
 	 */
+
+	if (!multidisk) {
+		if (dblocks >= TERABYTES(4, blocklog)) {
+                        blocks = XFS_AG_MAX_BLOCKS(blocklog);
+                        goto done;
+                }
+                count = 4;
+
+                goto done;
+        }
+
 	if (dblocks > GIGABYTES(512, blocklog))
 		shift = 5;
 	else if (dblocks > GIGABYTES(8, blocklog))
@@ -447,8 +459,12 @@ calc_default_ag_geometry(
 	blocks = dblocks >> shift;
 
 done:
+	ASSERT (count || blocks);
 	if (!count)
 		count = dblocks / blocks + (dblocks % blocks != 0);
+	if (!blocks)
+		blocks = dblocks / count;
+
 	*agsize = blocks;
 	*agcount = count;
 }
@@ -1779,10 +1795,14 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 		agsize /= blocksize;
 		agcount = dblocks / agsize + (dblocks % agsize != 0);
 
-	} else if (daflag)	/* User-specified AG size */
+	} else if (daflag)	/* User-specified AG count */
 		agsize = dblocks / agcount + (dblocks % agcount != 0);
-	else
-		calc_default_ag_geometry(blocklog, dblocks, &agsize, &agcount);
+	else {
+		get_subvol_stripe_wrapper(dfile, SVTYPE_DATA,
+					  &xlv_dsunit, &xlv_dswidth, &sectoralign),
+			calc_default_ag_geometry(blocklog, dblocks, xlv_dsunit | xlv_dswidth,
+						 &agsize, &agcount);
+	}
 
 	/*
 	 * If the last AG is too small, reduce the filesystem size
-- 
1.5.3.5
