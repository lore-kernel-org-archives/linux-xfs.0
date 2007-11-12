Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 11 Nov 2007 20:05:29 -0800 (PST)
Received: from itchy (dhcp17.melbourne.sgi.com [134.14.55.17])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lAC45CAG027724
	for <xfs@oss.sgi.com>; Sun, 11 Nov 2007 20:05:16 -0800
From: xaiki@sgi.com
Subject: [[PATCH, RESEND]] less AGs for single disks configs.
Date: Mon, 12 Nov 2007 14:48:49 +1100
Message-Id: <1194839329-22003-6-git-send-email-xaiki@sgi.com>
In-Reply-To: <1194839329-22003-5-git-send-email-xaiki@sgi.com>
References: <20071031233516.GB88034736@melbourne.sgi.com>
 <1194839329-22003-1-git-send-email-xaiki@sgi.com>
 <1194839329-22003-2-git-send-email-xaiki@sgi.com>
 <1194839329-22003-3-git-send-email-xaiki@sgi.com>
 <1194839329-22003-4-git-send-email-xaiki@sgi.com>
 <1194839329-22003-5-git-send-email-xaiki@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: Niv Sardi <xaiki@sgi.com>

From: Niv Sardi <xaiki@sgi.com>

get the underlying structure with get_subvol_stripe_wrapper(),
and pass sunit | swidth as an argument to calc_default_ag_geometry().

if it is set, get the AG sizes bigger.

this also cleans up a typo:
-       } else if (daflag)      /* User-specified AG size */
+       } else if (daflag)      /* User-specified AG count */
---
 xfsprogs/mkfs/xfs_mkfs.c |   18 ++++++++++++------
 1 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/xfsprogs/mkfs/xfs_mkfs.c b/xfsprogs/mkfs/xfs_mkfs.c
index 78c2c77..4cf9975 100644
--- a/xfsprogs/mkfs/xfs_mkfs.c
+++ b/xfsprogs/mkfs/xfs_mkfs.c
@@ -393,6 +393,7 @@ void
 calc_default_ag_geometry(
 	int		blocklog,
 	__uint64_t	dblocks,
+	int		multidisk,
 	__uint64_t	*agsize,
 	__uint64_t	*agcount)
 {
@@ -428,12 +429,13 @@ calc_default_ag_geometry(
 	 *
 	 * This scales us up smoothly between min/max AG sizes.
 	 */
+
 	if (dblocks > GIGABYTES(512, blocklog))
-		shift = 5;
+		shift = 5 - (multidisk == 0);
 	else if (dblocks > GIGABYTES(8, blocklog))
-		shift = 4;
+		shift = 4 - (multidisk == 0);
 	else if (dblocks >= MEGABYTES(128, blocklog))
-		shift = 3;
+		shift = 3 - (multidisk == 0);
 	else
 		ASSERT(0);
 	blocks = dblocks >> shift;
@@ -1771,10 +1773,14 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
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
