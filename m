Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 12 Nov 2007 20:11:11 -0800 (PST)
Received: from itchy (dhcp17.melbourne.sgi.com [134.14.55.17])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lAD4B2ol012298
	for <xfs@oss.sgi.com>; Mon, 12 Nov 2007 20:11:04 -0800
From: xaiki@sgi.com
Subject: [PATCH TAKE 2 5/6] reduce imaxpct for big filesystems,
Date: Tue, 13 Nov 2007 15:10:56 +1100
Message-Id: <1194927057-26415-6-git-send-email-xaiki@sgi.com>
In-Reply-To: <1194927057-26415-5-git-send-email-xaiki@sgi.com>
References: <20071029075657.GA84369978@melbourne.sgi.com>
 <1194927057-26415-1-git-send-email-xaiki@sgi.com>
 <1194927057-26415-2-git-send-email-xaiki@sgi.com>
 <1194927057-26415-3-git-send-email-xaiki@sgi.com>
 <1194927057-26415-4-git-send-email-xaiki@sgi.com>
 <1194927057-26415-5-git-send-email-xaiki@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: Niv Sardi <xaiki@sgi.com>

From: Niv Sardi <xaiki@sgi.com>

imaxpct is set to 25% (XFS_DFL_IMAXIMUM_PCT) for FS < 1 TB,
then 5% for FS < 50 TB,
and then (over 50 TB) 1%.

It is implemented as a simple step function in calc_default_imaxpct()
---
 xfsprogs/mkfs/xfs_mkfs.c |   27 +++++++++++++++++++++++++--
 1 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/xfsprogs/mkfs/xfs_mkfs.c b/xfsprogs/mkfs/xfs_mkfs.c
index 3689eb7..a8af6e2 100644
--- a/xfsprogs/mkfs/xfs_mkfs.c
+++ b/xfsprogs/mkfs/xfs_mkfs.c
@@ -374,6 +374,29 @@ validate_log_size(__uint64_t logblocks, int blocklog, int min_logblocks)
 	}
 }
 
+static int
+calc_default_imaxpct(
+	int		blocklog,
+	__uint64_t	dblocks)
+{
+	/*
+	 * This returns the % of the disk space that is used for
+	 * inodes, it changes relatively to the FS size:
+	 *  - over  50 TB, use 1%,
+	 *  - 1TB - 50 TB, use 5%,
+	 *  - under  1 TB, use XFS_DFL_IMAXIMUM_PCT (25%).
+	 */
+
+	if (dblocks < TERABYTES(1, blocklog)) {
+		return XFS_DFL_IMAXIMUM_PCT;
+	} else if (dblocks < TERABYTES(50, blocklog)) {
+		return 5;
+	}
+
+	return 1;
+}
+
+
 void
 calc_default_ag_geometry(
 	int		blocklog,
@@ -1986,7 +2009,7 @@ an AG size that is one stripe unit smaller, for example %llu.\n"),
 			dfile, isize, (long long)agcount, (long long)agsize,
 			"", sectorsize, attrversion,
 			"", blocksize, (long long)dblocks,
-				imflag ? imaxpct : XFS_DFL_IMAXIMUM_PCT,
+			       calc_default_imaxpct(blocklog, dblocks),
 			"", dsunit, dswidth,
 			dirversion, dirversion == 1 ? blocksize : dirblocksize,
 			logfile, 1 << blocklog, (long long)logblocks,
@@ -2023,7 +2046,7 @@ an AG size that is one stripe unit smaller, for example %llu.\n"),
 		(__uint8_t)(rtextents ?
 			libxfs_highbit32((unsigned int)rtextents) : 0);
 	sbp->sb_inprogress = 1;	/* mkfs is in progress */
-	sbp->sb_imax_pct = imflag ? imaxpct : XFS_DFL_IMAXIMUM_PCT;
+	sbp->sb_imax_pct = calc_default_imaxpct(blocklog, dblocks);
 	sbp->sb_icount = 0;
 	sbp->sb_ifree = 0;
 	sbp->sb_fdblocks = dblocks - agcount * XFS_PREALLOC_BLOCKS(mp) -
-- 
1.5.3.5
