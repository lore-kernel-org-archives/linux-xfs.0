Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:55482 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751856AbdH2XvI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Aug 2017 19:51:08 -0400
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1dmqHX-0002dE-0N
        for linux-xfs@vger.kernel.org; Wed, 30 Aug 2017 09:50:55 +1000
Received: from dave by discord.disaster.area with local (Exim 4.89)
        (envelope-from <david@fromorbit.com>)
        id 1dmqHW-0005WS-VP
        for linux-xfs@vger.kernel.org; Wed, 30 Aug 2017 09:50:54 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 23/42] mkfs: factor log sector size validation
Date: Wed, 30 Aug 2017 09:50:33 +1000
Message-Id: <20170829235052.21050-24-david@fromorbit.com>
In-Reply-To: <20170829235052.21050-1-david@fromorbit.com>
References: <20170829235052.21050-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

This also adds a check that disallows changing the sector size on
internal logs.

Signed-Off-By: Dave Chinner <dchinner@redhat.com>
---
 mkfs/xfs_mkfs.c | 101 ++++++++++++++++++++++++++++++++++++--------------------
 1 file changed, 65 insertions(+), 36 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 4e256942173f..64542442148c 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2037,6 +2037,59 @@ _("Minimum block size for CRC enabled filesystems is %d bytes.\n"),
 
 }
 
+/*
+ * Grab log sector size and validate.
+ *
+ * XXX: should we probe sector size on external log device rather than using
+ * the data device sector size?
+ */
+static void
+validate_log_sectorsize(
+	struct mkfs_params	*cfg,
+	struct cli_params	*cli,
+	struct mkfs_default_params *dft)
+{
+
+	if (cli->loginternal && cli->lsectorsize &&
+	    cli->lsectorsize != cfg->sectorsize) {
+		fprintf(stderr,
+_("Can't change sector size on internal log!\n"));
+		usage();
+	}
+
+	if (!cli->lsectorsize)
+		cfg->lsectorsize = dft->sectorsize;
+	else
+		cfg->lsectorsize = cli->lsectorsize;
+	cfg->lsectorlog = libxfs_highbit32(cfg->lsectorsize);
+
+	if (cfg->lsectorsize < XFS_MIN_SECTORSIZE ||
+	    cfg->lsectorsize > XFS_MAX_SECTORSIZE ||
+	    cfg->lsectorsize > cfg->blocksize) {
+		fprintf(stderr, _("illegal log sector size %d\n"),
+			cfg->lsectorsize);
+		usage();
+	}
+	if (cfg->lsectorsize > XFS_MIN_SECTORSIZE) {
+		if (cli->sb_feat.log_version < 2) {
+			/* user specified non-default log version */
+			fprintf(stderr,
+_("Version 1 logs do not support sector size %d\n"),
+				cfg->lsectorsize);
+			usage();
+		}
+	}
+
+	/* if lsu or lsunit was specified, automatically use v2 logs */
+	if ((cli_opt_set(&lopts, L_SU) || cli_opt_set(&lopts, L_SUNIT)) &&
+	    cli->sb_feat.log_version == 1) {
+		fprintf(stderr,
+_("log stripe unit specified, using v2 logs\n"));
+		cli->sb_feat.log_version = 2;
+	}
+
+}
+
 static void
 print_mkfs_cfg(
 	struct mkfs_params	*cfg,
@@ -2707,8 +2760,6 @@ main(
 	int			lsunitflag;
 	int			lsectorlog;
 	int			lsectorsize;
-	int			lslflag;
-	int			lssflag;
 	int			lsu;
 	int			lsunit;
 	int			min_logblocks;
@@ -2791,9 +2842,13 @@ main(
 	memcpy(&cli.sb_feat, &dft.sb_feat, sizeof(cli.sb_feat));
 	memcpy(&cli.fsx, &dft.fsx, sizeof(cli.fsx));
 
-	lslflag = lssflag = 0;
-	lsectorlog = 0;
-	lsectorsize = 0;
+	/*
+	 * Initialise cli parameters that can be set to zero to an appropriate
+	 * value so we can tell if they have been set or or changed from the
+	 * default value.
+	 */
+	cli.loginternal = 1;	/* internal by default */
+
 	agsize = daflag = dasize = dblocks = 0;
 	ilflag = imflag = ipflag = isflag = 0;
 	liflag = laflag = lsflag = lsuflag = lsunitflag = ldflag = lvflag = 0;
@@ -2822,6 +2877,7 @@ main(
 			force_overwrite = 1;
 			break;
 		case 'b':
+		case 's':
 			parse_subopts(c, optarg, &cli);
 			break;
 		case 'd':
@@ -2875,8 +2931,6 @@ main(
 			loginternal = cli.loginternal;
 			logfile = xi.logname;
 			logsize = cli.logsize;
-			lsectorsize = cli.lsectorsize;
-			lsectorlog = libxfs_highbit32(lsectorsize);
 
 			lsunit = cli.lsunit;
 			lsunitflag = cli_opt_set(&lopts, L_SUNIT);
@@ -2890,8 +2944,6 @@ main(
 			ldflag = cli_opt_set(&lopts, L_NAME) ||
 				 cli_opt_set(&lopts, L_DEV);
 			lvflag = cli_opt_set(&lopts, L_VERSION);
-			lslflag = cli_opt_set(&lopts, L_SECTLOG);
-			lssflag = cli_opt_set(&lopts, L_SECTSIZE);
 			/* end temp don't break code */
 			break;
 		case 'L':
@@ -2940,17 +2992,6 @@ main(
 			norsflag = cli.sb_feat.nortalign;
 			/* end temp don't break code */
 			break;
-		case 's':
-			parse_subopts(c, optarg, &cli);
-
-			/* temp don't break code */
-			lsectorsize = cli.lsectorsize;
-			lsectorlog = libxfs_highbit32(lsectorsize);
-			lslflag = cli_opt_set(&sopts, S_LOG) ||
-					   cli_opt_set(&sopts, S_SECTLOG);
-
-			lssflag = cli_opt_set(&sopts, S_SIZE) ||
-					   cli_opt_set(&sopts, S_SECTSIZE);
 			break;
 		case 'V':
 			printf(_("%s version %s\n"), progname, VERSION);
@@ -2983,23 +3024,18 @@ main(
 	validate_blocksize(&cfg, &cli, &dft);
 	validate_sectorsize(&cfg, &cli, &dft, &ft, dfile, dry_run,
 			    force_overwrite);
+	validate_log_sectorsize(&cfg, &cli, &dft);
 
 	/* temp don't break code */
 	sectorsize = cfg.sectorsize;
 	sectorlog = cfg.sectorlog;
 	blocksize = cfg.blocksize;
 	blocklog = cfg.blocklog;
+	lsectorsize = cfg.lsectorsize;
+	lsectorlog = cfg.lsectorlog;
+	sb_feat = cfg.sb_feat;
 	/* end temp don't break code */
 
-	if (lsectorsize < XFS_MIN_SECTORSIZE ||
-	    lsectorsize > XFS_MAX_SECTORSIZE || lsectorsize > blocksize) {
-		fprintf(stderr, _("illegal log sector size %d\n"), lsectorsize);
-		usage();
-	} else if (lsectorsize > XFS_MIN_SECTORSIZE && !lsu && !lsunit) {
-		lsu = blocksize;
-		sb_feat.log_version = 2;
-	}
-
 	/*
 	 * Now we have blocks and sector sizes set up, check parameters that are
 	 * no longer optional for CRC enabled filesystems.  Catch them up front
@@ -3244,13 +3280,6 @@ _("rmapbt not supported with realtime devices\n"));
 		exit(1);
 	}
 
-	/* if lsu or lsunit was specified, automatically use v2 logs */
-	if ((lsu || lsunit) && sb_feat.log_version == 1) {
-		fprintf(stderr,
-			_("log stripe unit specified, using v2 logs\n"));
-		sb_feat.log_version = 2;
-	}
-
 	calc_stripe_factors(dsu, dsw, sectorsize, lsu, lsectorsize,
 				&dsunit, &dswidth, &lsunit);
 
-- 
2.13.3

