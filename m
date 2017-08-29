Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:40488 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751916AbdH2XvG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Aug 2017 19:51:06 -0400
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1dmqHX-0002du-Cu
        for linux-xfs@vger.kernel.org; Wed, 30 Aug 2017 09:50:55 +1000
Received: from dave by discord.disaster.area with local (Exim 4.89)
        (envelope-from <david@fromorbit.com>)
        id 1dmqHX-0005X8-Bo
        for linux-xfs@vger.kernel.org; Wed, 30 Aug 2017 09:50:55 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 37/42] mkfs: rework imaxpct calculation
Date: Wed, 30 Aug 2017 09:50:47 +1000
Message-Id: <20170829235052.21050-38-david@fromorbit.com>
In-Reply-To: <20170829235052.21050-1-david@fromorbit.com>
References: <20170829235052.21050-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Signed-Off-By: Dave Chinner <dchinner@redhat.com>
---
 mkfs/xfs_mkfs.c | 65 +++++++++++++++++++++++++--------------------------------
 1 file changed, 29 insertions(+), 36 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 1ab9e98b8b02..ae6514cb0a1f 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -1055,28 +1055,6 @@ validate_log_size(uint64_t logblocks, int blocklog, int min_logblocks)
 	}
 }
 
-static int
-calc_default_imaxpct(
-	int		blocklog,
-	uint64_t	dblocks)
-{
-	/*
-	 * This returns the % of the disk space that is used for
-	 * inodes, it changes relatively to the FS size:
-	 *  - over  50 TB, use 1%,
-	 *  - 1TB - 50 TB, use 5%,
-	 *  - under  1 TB, use XFS_DFL_IMAXIMUM_PCT (25%).
-	 */
-
-	if (dblocks < TERABYTES(1, blocklog)) {
-		return XFS_DFL_IMAXIMUM_PCT;
-	} else if (dblocks < TERABYTES(50, blocklog)) {
-		return 5;
-	}
-
-	return 1;
-}
-
 static void
 validate_ag_geometry(
 	int		blocklog,
@@ -2866,6 +2844,31 @@ validate:
 }
 
 static void
+calculate_imaxpct(
+	struct mkfs_params	*cfg,
+	struct cli_params	*cli)
+{
+	cfg->imaxpct = cli->imaxpct;
+	if (cfg->imaxpct)
+		return;
+
+	/*
+	 * This returns the % of the disk space that is used for
+	 * inodes, it changes relatively to the FS size:
+	 *  - over  50 TB, use 1%,
+	 *  - 1TB - 50 TB, use 5%,
+	 *  - under  1 TB, use XFS_DFL_IMAXIMUM_PCT (25%).
+	 */
+
+	if (cfg->dblocks < TERABYTES(1, cfg->blocklog))
+		cfg->imaxpct = XFS_DFL_IMAXIMUM_PCT;
+	else if (cfg->dblocks < TERABYTES(50, cfg->blocklog))
+		cfg->imaxpct = 5;
+	else
+		cfg->imaxpct = 1;
+}
+
+static void
 print_mkfs_cfg(
 	struct mkfs_params	*cfg,
 	char			*dfile,
@@ -3505,7 +3508,6 @@ main(
 	int			force_overwrite;
 	struct fsxattr		fsx;
 	int			imaxpct;
-	int			imflag;
 	int			inodelog;
 	int			inopblock;
 	int			isize;
@@ -3601,7 +3603,6 @@ main(
 	cli.loginternal = 1;	/* internal by default */
 
 	agsize = dblocks = 0;
-	imflag = 0;
 	laflag = lsflag = 0;
 	loginternal = 1;
 	logagno = logblocks = rtblocks = rtextblocks = 0;
@@ -3624,6 +3625,7 @@ main(
 			force_overwrite = 1;
 			break;
 		case 'b':
+		case 'i':
 		case 'n':
 		case 'r':
 		case 's':
@@ -3638,14 +3640,6 @@ main(
 			fsx.fsx_extsize = cli.fsx.fsx_extsize;
 			/* end temp don't break code */
 			break;
-		case 'i':
-			parse_subopts(c, optarg, &cli);
-
-			/* temp don't break code */
-			imaxpct = cli.imaxpct;
-			imflag = cli_opt_set(&iopts, I_MAXPCT);
-			/* end temp don't break code */
-			break;
 		case 'l':
 			parse_subopts(c, optarg, &cli);
 
@@ -3746,6 +3740,8 @@ main(
 	calculate_initial_ag_geometry(&cfg, &cli);
 	align_ag_geometry(&cfg);
 
+	calculate_imaxpct(&cfg, &cli);
+
 	/* temp don't break code */
 	sectorsize = cfg.sectorsize;
 	sectorlog = cfg.sectorlog;
@@ -3771,12 +3767,9 @@ main(
 	lsunit = cfg.lsunit;
 	agsize = cfg.agsize;
 	agcount = cfg.agcount;
+	imaxpct = cfg.imaxpct;
 	/* end temp don't break code */
 
-
-	if (!imflag)
-		imaxpct = calc_default_imaxpct(blocklog, dblocks);
-
 	min_logblocks = max_trans_res(agsize,
 				   sb_feat.crcs_enabled, sb_feat.dir_version,
 				   sectorlog, blocklog, inodelog, dirblocklog,
-- 
2.13.3

