Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:55482 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751951AbdH2XvK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Aug 2017 19:51:10 -0400
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1dmqHW-0002dB-Vq
        for linux-xfs@vger.kernel.org; Wed, 30 Aug 2017 09:50:55 +1000
Received: from dave by discord.disaster.area with local (Exim 4.89)
        (envelope-from <david@fromorbit.com>)
        id 1dmqHW-0005WP-Ue
        for linux-xfs@vger.kernel.org; Wed, 30 Aug 2017 09:50:54 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 22/42] mkfs: factor blocksize validation
Date: Wed, 30 Aug 2017 09:50:32 +1000
Message-Id: <20170829235052.21050-23-david@fromorbit.com>
In-Reply-To: <20170829235052.21050-1-david@fromorbit.com>
References: <20170829235052.21050-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Signed-Off-By: Dave Chinner <dchinner@redhat.com>
---
 mkfs/xfs_mkfs.c | 68 ++++++++++++++++++++++++++++++++-------------------------
 1 file changed, 38 insertions(+), 30 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index a6d2dd516319..4e256942173f 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2004,6 +2004,40 @@ _("block size %d cannot be smaller than sector size %d\n"),
 }
 
 static void
+validate_blocksize(
+	struct mkfs_params	*cfg,
+	struct cli_params	*cli,
+	struct mkfs_default_params *dft)
+{
+	/*
+	 * Blocksize and sectorsize first, other things depend on them
+	 * For RAID4/5/6 we want to align sector size and block size,
+	 * so we need to start with the device geometry extraction too.
+	 */
+	if (!cli->blocksize)
+		cfg->blocksize = dft->blocksize;
+	else
+		cfg->blocksize = cli->blocksize;
+	cfg->blocklog = libxfs_highbit32(cfg->blocksize);
+
+	/* validate block sizes are in range */
+	if (cfg->blocksize < XFS_MIN_BLOCKSIZE ||
+	    cfg->blocksize > XFS_MAX_BLOCKSIZE) {
+		fprintf(stderr, _("illegal block size %d\n"), cfg->blocksize);
+		usage();
+	}
+
+	if (cli->sb_feat.crcs_enabled &&
+	    cfg->blocksize < XFS_MIN_CRC_BLOCKSIZE) {
+		fprintf(stderr,
+_("Minimum block size for CRC enabled filesystems is %d bytes.\n"),
+			XFS_MIN_CRC_BLOCKSIZE);
+		usage();
+	}
+
+}
+
+static void
 print_mkfs_cfg(
 	struct mkfs_params	*cfg,
 	char			*dfile,
@@ -2631,9 +2665,7 @@ main(
 	uint64_t		agcount;
 	xfs_agnumber_t		agno;
 	uint64_t		agsize;
-	int			blflag;
 	int			blocklog;
-	int			bsflag;
 	xfs_buf_t		*buf;
 	int			c;
 	int			daflag;
@@ -2759,8 +2791,7 @@ main(
 	memcpy(&cli.sb_feat, &dft.sb_feat, sizeof(cli.sb_feat));
 	memcpy(&cli.fsx, &dft.fsx, sizeof(cli.fsx));
 
-	blflag = bsflag = lslflag = lssflag = 0;
-	blocklog = blocksize = 0;
+	lslflag = lssflag = 0;
 	lsectorlog = 0;
 	lsectorsize = 0;
 	agsize = daflag = dasize = dblocks = 0;
@@ -2792,13 +2823,6 @@ main(
 			break;
 		case 'b':
 			parse_subopts(c, optarg, &cli);
-
-			/* temp don't break code */
-			blocksize = cli.blocksize;
-			blocklog = libxfs_highbit32(blocksize);
-			blflag = cli_opt_set(&bopts, B_LOG);
-			bsflag = cli_opt_set(&bopts, B_SIZE);
-			/* end temp don't break code */
 			break;
 		case 'd':
 			parse_subopts(c, optarg, &cli);
@@ -2947,25 +2971,6 @@ main(
 	sb_feat = cli.sb_feat;
 	/* end temp don't break code */
 
-	/*
-	 * Blocksize and sectorsize first, other things depend on them
-	 * For RAID4/5/6 we want to align sector size and block size,
-	 * so we need to start with the device geometry extraction too.
-	 */
-	if (!blflag && !bsflag) {
-		blocklog = XFS_DFL_BLOCKSIZE_LOG;
-		blocksize = 1 << XFS_DFL_BLOCKSIZE_LOG;
-	}
-	if (blocksize < XFS_MIN_BLOCKSIZE || blocksize > XFS_MAX_BLOCKSIZE) {
-		fprintf(stderr, _("illegal block size %d\n"), blocksize);
-		usage();
-	}
-	if (sb_feat.crcs_enabled && blocksize < XFS_MIN_CRC_BLOCKSIZE) {
-		fprintf(stderr,
-_("Minimum block size for CRC enabled filesystems is %d bytes.\n"),
-			XFS_MIN_CRC_BLOCKSIZE);
-		usage();
-	}
 	if (sb_feat.crcs_enabled && !sb_feat.dirftype) {
 		fprintf(stderr, _("cannot disable ftype with crcs enabled\n"));
 		usage();
@@ -2975,12 +2980,15 @@ _("Minimum block size for CRC enabled filesystems is %d bytes.\n"),
 	 * Extract as much of the valid config as we can from the CLI input
 	 * before opening the libxfs devices.
 	 */
+	validate_blocksize(&cfg, &cli, &dft);
 	validate_sectorsize(&cfg, &cli, &dft, &ft, dfile, dry_run,
 			    force_overwrite);
 
 	/* temp don't break code */
 	sectorsize = cfg.sectorsize;
 	sectorlog = cfg.sectorlog;
+	blocksize = cfg.blocksize;
+	blocklog = cfg.blocklog;
 	/* end temp don't break code */
 
 	if (lsectorsize < XFS_MIN_SECTORSIZE ||
-- 
2.13.3

