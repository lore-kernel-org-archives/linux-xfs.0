Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 11 Nov 2007 20:05:28 -0800 (PST)
Received: from itchy (dhcp17.melbourne.sgi.com [134.14.55.17])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lAC45CTT027725
	for <xfs@oss.sgi.com>; Sun, 11 Nov 2007 20:05:16 -0800
From: xaiki@sgi.com
Subject: [[PATCH, RESEND]] reduce imaxpct for big filesystems,
Date: Mon, 12 Nov 2007 14:48:48 +1100
Message-Id: <1194839329-22003-5-git-send-email-xaiki@sgi.com>
In-Reply-To: <1194839329-22003-4-git-send-email-xaiki@sgi.com>
References: <20071031233516.GB88034736@melbourne.sgi.com>
 <1194839329-22003-1-git-send-email-xaiki@sgi.com>
 <1194839329-22003-2-git-send-email-xaiki@sgi.com>
 <1194839329-22003-3-git-send-email-xaiki@sgi.com>
 <1194839329-22003-4-git-send-email-xaiki@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: Niv Sardi <xaiki@sgi.com>

From: Niv Sardi <xaiki@sgi.com>

imaxpct is set to 25% for FS < 1 TB,
then 5% for FS < 50 TB,
and then 1%.

It is implemented as a step function in calc_default_imaxpct()
---
 xfsprogs/mkfs/xfs_mkfs.c |   19 +++++++++++++++++--
 1 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/xfsprogs/mkfs/xfs_mkfs.c b/xfsprogs/mkfs/xfs_mkfs.c
index 3689eb7..78c2c77 100644
--- a/xfsprogs/mkfs/xfs_mkfs.c
+++ b/xfsprogs/mkfs/xfs_mkfs.c
@@ -374,6 +374,21 @@ validate_log_size(__uint64_t logblocks, int blocklog, int min_logblocks)
 	}
 }
 
+int
+calc_default_imaxpct(
+	int		blocklog,
+	__uint64_t	dblocks)
+{
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
@@ -1986,7 +2001,7 @@ an AG size that is one stripe unit smaller, for example %llu.\n"),
 			dfile, isize, (long long)agcount, (long long)agsize,
 			"", sectorsize, attrversion,
 			"", blocksize, (long long)dblocks,
-				imflag ? imaxpct : XFS_DFL_IMAXIMUM_PCT,
+			       calc_default_imaxpct(blocklog, dblocks),
 			"", dsunit, dswidth,
 			dirversion, dirversion == 1 ? blocksize : dirblocksize,
 			logfile, 1 << blocklog, (long long)logblocks,
@@ -2023,7 +2038,7 @@ an AG size that is one stripe unit smaller, for example %llu.\n"),
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
