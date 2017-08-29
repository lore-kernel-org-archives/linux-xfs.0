Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:27944 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751891AbdH2XvH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Aug 2017 19:51:07 -0400
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1dmqHX-0002dZ-6S
        for linux-xfs@vger.kernel.org; Wed, 30 Aug 2017 09:50:55 +1000
Received: from dave by discord.disaster.area with local (Exim 4.89)
        (envelope-from <david@fromorbit.com>)
        id 1dmqHX-0005Wn-54
        for linux-xfs@vger.kernel.org; Wed, 30 Aug 2017 09:50:55 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 30/42] mkfs: rework stripe calculations
Date: Wed, 30 Aug 2017 09:50:40 +1000
Message-Id: <20170829235052.21050-31-david@fromorbit.com>
In-Reply-To: <20170829235052.21050-1-david@fromorbit.com>
References: <20170829235052.21050-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

The data and log stripe calculations a spaghettied all over the mkfs
code. This patch pulls all of the different chunks of code together
into calc_stripe_factors() and removes all the redundant/repeated
checks and calculations that are made.

Signed-Off-By: Dave Chinner <dchinner@redhat.com>
---
 mkfs/xfs_mkfs.c | 330 ++++++++++++++++++++++++++++++--------------------------
 1 file changed, 180 insertions(+), 150 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 7595e378ad44..fe380d2b388d 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -896,74 +896,6 @@ struct mkfs_default_params {
  */
 #define WHACK_SIZE (128 * 1024)
 
-/*
- * Convert lsu to lsunit for 512 bytes blocks and check validity of the values.
- */
-static void
-calc_stripe_factors(
-	int		dsu,
-	int		dsw,
-	int		dsectsz,
-	int		lsu,
-	int		lsectsz,
-	int		*dsunit,
-	int		*dswidth,
-	int		*lsunit)
-{
-	/* Handle data sunit/swidth options */
-	if ((*dsunit && !*dswidth) || (!*dsunit && *dswidth)) {
-		fprintf(stderr,
-			_("both data sunit and data swidth options "
-			"must be specified\n"));
-		usage();
-	}
-
-	if (dsu || dsw) {
-		if ((dsu && !dsw) || (!dsu && dsw)) {
-			fprintf(stderr,
-				_("both data su and data sw options "
-				"must be specified\n"));
-			usage();
-		}
-
-		if (dsu % dsectsz) {
-			fprintf(stderr,
-				_("data su must be a multiple of the "
-				"sector size (%d)\n"), dsectsz);
-			usage();
-		}
-
-		*dsunit  = (int)BTOBBT(dsu);
-		*dswidth = *dsunit * dsw;
-	}
-
-	if (*dsunit && (*dswidth % *dsunit != 0)) {
-		fprintf(stderr,
-			_("data stripe width (%d) must be a multiple of the "
-			"data stripe unit (%d)\n"), *dswidth, *dsunit);
-		usage();
-	}
-
-	/* Handle log sunit options */
-
-	if (lsu)
-		*lsunit = (int)BTOBBT(lsu);
-
-	/* verify if lsu/lsunit is a multiple block size */
-	if (lsu % blocksize != 0) {
-		fprintf(stderr,
-_("log stripe unit (%d) must be a multiple of the block size (%d)\n"),
-		lsu, blocksize);
-		exit(1);
-	}
-	if ((BBTOB(*lsunit) % blocksize != 0)) {
-		fprintf(stderr,
-_("log stripe unit (%d) must be a multiple of the block size (%d)\n"),
-		BBTOB(*lsunit), blocksize);
-		exit(1);
-	}
-}
-
 static void
 check_device_type(
 	const char	*name,
@@ -2377,6 +2309,178 @@ validate_rtextsize(
 	ASSERT(cfg->rtextblocks);
 }
 
+/*
+ * Validate the configured stripe geometry, or is none is specified, pull
+ * the configuration from the underlying device.
+ *
+ * CLI parameters come in as different units, go out as filesystem blocks.
+ */
+static void
+calc_stripe_factors(
+	struct mkfs_params	*cfg,
+	struct cli_params	*cli,
+	struct fs_topology	*ft)
+{
+	int		dsunit = 0;
+	int		dswidth = 0;
+	int		lsunit = 0;
+	int		dsu = 0;
+	int		dsw = 0;
+	int		lsu = 0;
+	bool		use_dev = false;
+
+	if (cli_opt_set(&dopts, D_SUNIT))
+		dsunit = cli->dsunit;
+	if (cli_opt_set(&dopts, D_SWIDTH))
+		dswidth = cli->dswidth;
+
+	if (cli_opt_set(&dopts, D_SU))
+		dsu = getnum(cli->dsu, &dopts, D_SU);
+	if (cli_opt_set(&dopts, D_SW))
+		dsw = cli->dsw;
+
+	/* data sunit/swidth options */
+	if ((dsunit && !dswidth) || (!dsunit && dswidth)) {
+		fprintf(stderr,
+_("both data sunit and data swidth options must be specified\n"));
+		usage();
+	}
+
+	/* convert dsu/dsw to dsunit/dswidth and use them from now on */
+	if (dsu || dsw) {
+		if ((dsu && !dsw) || (!dsu && dsw)) {
+			fprintf(stderr,
+_("both data su and data sw options must be specified\n"));
+			usage();
+		}
+
+		if (dsu % cfg->sectorsize) {
+			fprintf(stderr,
+_("data su must be a multiple of the sector size (%d)\n"), cfg->sectorsize);
+			usage();
+		}
+
+		dsunit  = (int)BTOBBT(dsu);
+		dswidth = dsunit * dsw;
+	}
+
+	if (dsunit && (dswidth % dsunit != 0)) {
+		fprintf(stderr,
+_("data stripe width (%d) must be a multiple of the data stripe unit (%d)\n"),
+			dswidth, dsunit);
+		usage();
+	}
+
+	/* If sunit & swidth were manually specified as 0, same as noalign */
+	if ((cli_opt_set(&dopts, D_SUNIT) || cli_opt_set(&dopts, D_SU)) &&
+	    !dsunit && !dswidth)
+		cfg->sb_feat.nodalign = true;
+
+	/* if we are not using alignment, don't apply device defaults */
+	if (cfg->sb_feat.nodalign) {
+		cfg->dsunit = 0;
+		cfg->dswidth = 0;
+		goto check_lsunit;
+	}
+
+	/* if no stripe config set, use the device default */
+	if (!dsunit) {
+		dsunit = ft->dsunit;
+		dswidth = ft->dswidth;
+		use_dev = true;
+	} else {
+		/* check and warn is alignment is sub-optimal */
+		if (ft->dsunit && ft->dsunit != dsunit) {
+			fprintf(stderr,
+_("%s: Specified data stripe unit %d is not the same as the volume stripe unit %d\n"),
+				progname, dsunit, ft->dsunit);
+		}
+		if (ft->dswidth && ft->dswidth != dswidth) {
+			fprintf(stderr,
+_("%s: Specified data stripe width %d is not the same as the volume stripe width %d\n"),
+				progname, dswidth, ft->dswidth);
+		}
+	}
+
+	/*
+	 * now we have our stripe config, check it's a multiple of block
+	 * size.
+	 */
+	if ((BBTOB(dsunit) % cfg->blocksize) ||
+	    (BBTOB(dswidth) % cfg->blocksize)) {
+		/*
+		 * If we are using device defaults, just clear them and we're
+		 * good to go. Otherwise bail out with an error.
+		 */
+		if (!use_dev) {
+			fprintf(stderr,
+_("%s: Stripe unit(%d) or stripe width(%d) is not a multiple of the block size(%d)\n"),
+				progname, BBTOB(dsunit), BBTOB(dswidth),
+				cfg->blocksize);
+			exit(1);
+		}
+		dsunit = 0;
+		dswidth = 0;
+		cfg->sb_feat.nodalign = true;
+	}
+
+	/* convert from 512 byte blocks to fs blocksize */
+	cfg->dsunit = DTOBT(dsunit, cfg->blocklog);
+	cfg->dswidth = DTOBT(dswidth, cfg->blocklog);
+
+check_lsunit:
+	/* log sunit options */
+	if (cli_opt_set(&lopts, L_SUNIT))
+		lsunit = cli->lsunit;
+	else if (cli_opt_set(&lopts, L_SU))
+		lsu = getnum(cli->lsu, &lopts, L_SU);
+	else /* set default log stripe unit if not set on CLI */
+		lsu = cfg->blocksize;
+
+	if (lsu) {
+		/* verify if lsu is a multiple block size */
+		if (lsu % cfg->blocksize != 0) {
+			fprintf(stderr,
+	_("log stripe unit (%d) must be a multiple of the block size (%d)\n"),
+				lsu, cfg->blocksize);
+			usage();
+		}
+		lsunit = (int)BTOBBT(lsu);
+	}
+	if (BBTOB(lsunit) % cfg->blocksize != 0) {
+		fprintf(stderr,
+_("log stripe unit (%d) must be a multiple of the block size (%d)\n"),
+			BBTOB(lsunit), cfg->blocksize);
+		usage();
+	}
+
+	/*
+	 * check that log sunit is modulo fsblksize or default it to dsunit.
+	 */
+	if (lsunit) {
+		/* convert from 512 byte blocks to fs blocks */
+		cfg->lsunit = DTOBT(lsunit, cfg->blocklog);
+	} else if (cfg->sb_feat.log_version == 2 &&
+		   cfg->loginternal && cfg->dsunit) {
+		/* lsunit and dsunit now in fs blocks */
+		cfg->lsunit = cfg->dsunit;
+	}
+
+	if (cfg->sb_feat.log_version == 2 &&
+	    cfg->lsunit * cfg->blocksize > 256 * 1024) {
+		/* Warn only if specified on commandline */
+		if (cli->lsu || cli->lsunit != -1) {
+			fprintf(stderr,
+_("log stripe unit (%d bytes) is too large (maximum is 256KiB)\n"
+  "log stripe unit adjusted to 32KiB\n"),
+				(cfg->lsunit * cfg->blocksize));
+		}
+		/* XXX: 64k block size? */
+		cfg->lsunit = (32 * 1024) / cfg->blocksize;
+	}
+
+}
+
 static void
 print_mkfs_cfg(
 	struct mkfs_params	*cfg,
@@ -3015,11 +3119,8 @@ main(
 	int			dirblocklog;
 	int			dirblocksize;
 	char			*dsize;
-	int			dsu;
-	int			dsw;
 	int			dsunit;
 	int			dswidth;
-	int			dsflag;
 	int			force_overwrite;
 	struct fsxattr		fsx;
 	int			imaxpct;
@@ -3040,11 +3141,8 @@ main(
 	xfs_fsblock_t		logstart;
 	int			lvflag;
 	int			lsflag;
-	int			lsuflag;
-	int			lsunitflag;
 	int			lsectorlog;
 	int			lsectorsize;
-	int			lsu;
 	int			lsunit;
 	int			min_logblocks;
 	xfs_mount_t		*mp;
@@ -3130,14 +3228,14 @@ main(
 
 	agsize = daflag = dasize = dblocks = 0;
 	imflag = 0;
-	liflag = laflag = lsflag = lsuflag = lsunitflag = ldflag = lvflag = 0;
+	liflag = laflag = lsflag = ldflag = lvflag = 0;
 	loginternal = 1;
 	logagno = logblocks = rtblocks = rtextblocks = 0;
 	imaxpct = inodelog = inopblock = isize = 0;
 	dfile = logfile = rtfile = NULL;
 	dsize = logsize = rtsize = protofile = NULL;
-	dsu = dsw = dsunit = dswidth = lalign = lsu = lsunit = 0;
-	dsflag = nodsflag = 0;
+	dsunit = dswidth = lalign = lsunit = 0;
+	nodsflag = 0;
 	force_overwrite = 0;
 	worst_freelist = 0;
 	memset(&fsx, 0, sizeof(fsx));
@@ -3168,18 +3266,6 @@ main(
 			}
 			daflag = cli_opt_set(&dopts, D_AGCOUNT);
 
-			dsunit = cli.dsunit;
-			dswidth = cli.dswidth;
-			dsw = cli.dsw;
-			if (cli_opt_set(&dopts, D_SU)) {
-				dsu = getnum(cli.dsu, &dopts, D_SU);
-				dsflag = 1;
-			}
-			dsflag |= cli_opt_set(&dopts, D_SW) ||
-				  cli_opt_set(&dopts, D_SUNIT) ||
-				  cli_opt_set(&dopts, D_SWIDTH);
-			nodsflag = cli_opt_set(&dopts, D_NOALIGN);
-
 			fsx.fsx_xflags |= cli.fsx.fsx_xflags;
 			fsx.fsx_projid = cli.fsx.fsx_projid;
 			fsx.fsx_extsize = cli.fsx.fsx_extsize;
@@ -3202,13 +3288,6 @@ main(
 			logfile = xi.logname;
 			logsize = cli.logsize;
 
-			lsunit = cli.lsunit;
-			lsunitflag = cli_opt_set(&lopts, L_SUNIT);
-			if (cli_opt_set(&lopts, L_SU)) {
-				lsu = getnum(cli.lsu, &lopts, L_SU);
-				lsuflag = 1;
-			}
-
 			laflag = cli_opt_set(&lopts, L_AGNUM);
 			liflag = cli_opt_set(&lopts, L_INTERNAL);
 			ldflag = cli_opt_set(&lopts, L_NAME) ||
@@ -3297,6 +3376,7 @@ main(
 	cfg.rtblocks = calc_dev_size(cli.rtsize, &cfg, &ropts, R_SIZE, "rt");
 
 	validate_rtextsize(&cfg, &cli, &ft);
+	calc_stripe_factors(&cfg, &cli, &ft);
 
 	/* temp don't break code */
 	sectorsize = cfg.sectorsize;
@@ -3316,16 +3396,13 @@ main(
 	logblocks = cfg.logblocks;
 	rtblocks = cfg.rtblocks;
 	rtextblocks = cfg.rtextblocks;
+	dsunit = cfg.dsunit;
+	dswidth = cfg.dswidth;
+	lsunit = cfg.lsunit;
+	nodsflag = cfg.sb_feat.nodalign;
 	/* end temp don't break code */
 
 
-	calc_stripe_factors(dsu, dsw, sectorsize, lsu, lsectorsize,
-				&dsunit, &dswidth, &lsunit);
-
-	/* If sunit & swidth were manually specified as 0, same as noalign */
-	if (dsflag && !dsunit && !dswidth)
-		nodsflag = 1;
-
 	xi.setblksize = sectorsize;
 
 	/*
@@ -3453,29 +3530,6 @@ reported by the device (%u).\n"),
 		nbmblocks = 0;
 	}
 
-	if (!nodsflag) {
-		if (dsunit) {
-			if (ft.dsunit && ft.dsunit != dsunit) {
-				fprintf(stderr,
-					_("%s: Specified data stripe unit %d "
-					"is not the same as the volume stripe "
-					"unit %d\n"),
-					progname, dsunit, ft.dsunit);
-			}
-			if (ft.dswidth && ft.dswidth != dswidth) {
-				fprintf(stderr,
-					_("%s: Specified data stripe width %d "
-					"is not the same as the volume stripe "
-					"width %d\n"),
-					progname, dswidth, ft.dswidth);
-			}
-		} else {
-			dsunit = ft.dsunit;
-			dswidth = ft.dswidth;
-			nodsflag = 1;
-		}
-	} /* else dsunit & dswidth can't be set if nodsflag is set */
-
 	if (dasize) {		/* User-specified AG size */
 		/*
 		 * Check specified agsize is a multiple of blocksize.
@@ -3614,30 +3668,6 @@ an AG size that is one stripe unit smaller, for example %llu.\n"),
 	if (!imflag)
 		imaxpct = calc_default_imaxpct(blocklog, dblocks);
 
-	/*
-	 * check that log sunit is modulo fsblksize or default it to dsunit.
-	 */
-
-	if (lsunit) {
-		/* convert from 512 byte blocks to fs blocks */
-		lsunit = DTOBT(lsunit, blocklog);
-	} else if (sb_feat.log_version == 2 && loginternal && dsunit) {
-		/* lsunit and dsunit now in fs blocks */
-		lsunit = dsunit;
-	}
-
-	if (sb_feat.log_version == 2 && (lsunit * blocksize) > 256 * 1024) {
-		/* Warn only if specified on commandline */
-		if (lsuflag || lsunitflag) {
-			fprintf(stderr,
-	_("log stripe unit (%d bytes) is too large (maximum is 256KiB)\n"),
-				(lsunit * blocksize));
-			fprintf(stderr,
-	_("log stripe unit adjusted to 32KiB\n"));
-		}
-		lsunit = (32 * 1024) >> blocklog;
-	}
-
 	min_logblocks = max_trans_res(agsize,
 				   sb_feat.crcs_enabled, sb_feat.dir_version,
 				   sectorlog, blocklog, inodelog, dirblocklog,
-- 
2.13.3

