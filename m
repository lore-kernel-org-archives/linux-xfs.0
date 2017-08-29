Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:36957 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751669AbdH2XvL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Aug 2017 19:51:11 -0400
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1dmqHX-0002dI-24
        for linux-xfs@vger.kernel.org; Wed, 30 Aug 2017 09:50:55 +1000
Received: from dave by discord.disaster.area with local (Exim 4.89)
        (envelope-from <david@fromorbit.com>)
        id 1dmqHX-0005WY-0d
        for linux-xfs@vger.kernel.org; Wed, 30 Aug 2017 09:50:55 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 25/42] mkfs: factor directory blocksize validation
Date: Wed, 30 Aug 2017 09:50:35 +1000
Message-Id: <20170829235052.21050-26-david@fromorbit.com>
In-Reply-To: <20170829235052.21050-1-david@fromorbit.com>
References: <20170829235052.21050-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Signed-Off-By: Dave Chinner <dchinner@redhat.com>
---
 mkfs/xfs_mkfs.c | 78 +++++++++++++++++++++++++++++++--------------------------
 1 file changed, 42 insertions(+), 36 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 1c697dd5d4e1..72b21d715613 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2215,6 +2215,36 @@ _("rmapbt not supported with realtime devices\n"));
 }
 
 static void
+validate_dirblocksize(
+	struct mkfs_params	*cfg,
+	struct cli_params	*cli)
+{
+
+	if (cli->dirblocksize)
+		cfg->dirblocksize = getnum(cli->dirblocksize, &nopts, N_SIZE);
+	if (cli->dirblocklog)
+		cfg->dirblocksize = 1 << cli->dirblocklog;
+
+	if (cfg->dirblocksize) {
+		if (cfg->dirblocksize < cfg->blocksize ||
+		    cfg->dirblocksize > XFS_MAX_BLOCKSIZE) {
+			fprintf(stderr, _("illegal directory block size %d\n"),
+				cfg->dirblocksize);
+			usage();
+		}
+		cfg->dirblocklog = libxfs_highbit32(cfg->dirblocksize);
+		return;
+	}
+
+	/* use default size based on current block size */
+	if (cfg->blocksize < (1 << XFS_MIN_REC_DIRSIZE))
+		cfg->dirblocklog = XFS_MIN_REC_DIRSIZE;
+	else
+		cfg->dirblocklog = cfg->blocklog;
+	cfg->dirblocksize = 1 << cfg->dirblocklog;
+}
+
+static void
 print_mkfs_cfg(
 	struct mkfs_params	*cfg,
 	char			*dfile,
@@ -2890,16 +2920,13 @@ main(
 	xfs_mount_t		*mp;
 	xfs_mount_t		mbuf;
 	xfs_extlen_t		nbmblocks;
-	int			nlflag;
 	int			nodsflag;
 	int			norsflag;
-	int			nsflag;
-	int			nvflag;
-	int			dry_run;
+	int			dry_run = 0;
 	int			discard = 1;
 	char			*protofile;
 	char			*protostring;
-	int			quiet;
+	int			quiet = 0;
 	xfs_rfsblock_t		rtblocks;
 	xfs_extlen_t		rtextblocks;
 	xfs_rtblock_t		rtextents;
@@ -2978,9 +3005,6 @@ main(
 	liflag = laflag = lsflag = lsuflag = lsunitflag = ldflag = lvflag = 0;
 	loginternal = 1;
 	logagno = logblocks = rtblocks = rtextblocks = 0;
-	dry_run = nlflag = nsflag = nvflag = 0;
-	dirblocklog = dirblocksize = 0;
-	quiet = 0;
 	imaxpct = inodelog = inopblock = isize = 0;
 	dfile = logfile = rtfile = NULL;
 	dsize = logsize = rtsize = rtextsize = protofile = NULL;
@@ -3001,6 +3025,7 @@ main(
 			force_overwrite = 1;
 			break;
 		case 'b':
+		case 'n':
 		case 's':
 			parse_subopts(c, optarg, &cli);
 			break;
@@ -3082,17 +3107,6 @@ main(
 			platform_uuid_copy(&uuid, &cli.uuid);
 			/* end temp don't break code */
 			break;
-		case 'n':
-			parse_subopts(c, optarg, &cli);
-
-			/* temp don't break code */
-			if ((nsflag = cli_opt_set(&nopts, N_SIZE)))
-				dirblocksize = getnum(cli.dirblocksize, &nopts, N_SIZE);
-			dirblocklog = cli.dirblocklog;
-
-			nlflag = cli_opt_set(&nopts, N_LOG);
-			/* end temp don't break code */
-			break;
 		case 'N':
 			dry_run = 1;
 			break;
@@ -3146,6 +3160,13 @@ main(
 	validate_log_sectorsize(&cfg, &cli, &dft);
 	validate_sb_features(&cfg, &cli);
 
+	/*
+	 * we've now completed basic validation of the features, sector and
+	 * block sizes, so from this point onwards we use the values found in
+	 * the cfg structure for them, not the command line structure.
+	 */
+	validate_dirblocksize(&cfg, &cli);
+
 	/* temp don't break code */
 	sectorsize = cfg.sectorsize;
 	sectorlog = cfg.sectorlog;
@@ -3155,25 +3176,10 @@ main(
 	lsectorlog = cfg.lsectorlog;
 	sb_feat = cfg.sb_feat;
 	platform_uuid_copy(&uuid, &cfg.uuid);
+	dirblocksize = cfg.dirblocksize;
+	dirblocklog = cfg.dirblocklog;
 	/* end temp don't break code */
 
-
-	if (nsflag || nlflag) {
-		if (dirblocksize < blocksize ||
-					dirblocksize > XFS_MAX_BLOCKSIZE) {
-			fprintf(stderr, _("illegal directory block size %d\n"),
-				dirblocksize);
-			usage();
-		}
-	} else {
-		if (blocksize < (1 << XFS_MIN_REC_DIRSIZE))
-			dirblocklog = XFS_MIN_REC_DIRSIZE;
-		else
-			dirblocklog = blocklog;
-		dirblocksize = 1 << dirblocklog;
-	}
-
-
 	if (dsize) {
 		uint64_t dbytes;
 
-- 
2.13.3

