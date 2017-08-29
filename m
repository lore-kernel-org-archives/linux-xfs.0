Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:27944 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751933AbdH2XvI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Aug 2017 19:51:08 -0400
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1dmqHW-0002d7-V4
        for linux-xfs@vger.kernel.org; Wed, 30 Aug 2017 09:50:55 +1000
Received: from dave by discord.disaster.area with local (Exim 4.89)
        (envelope-from <david@fromorbit.com>)
        id 1dmqHW-0005WM-Tm
        for linux-xfs@vger.kernel.org; Wed, 30 Aug 2017 09:50:54 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 21/42] mkfs: factor sectorsize validation
Date: Wed, 30 Aug 2017 09:50:31 +1000
Message-Id: <20170829235052.21050-22-david@fromorbit.com>
In-Reply-To: <20170829235052.21050-1-david@fromorbit.com>
References: <20170829235052.21050-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Start factoring all the sector size validation code into a
function that takes cli, dft and cfg structures. This starts
removing option flags and some of the temporary code in the input
parsing structures.

Signed-Off-By: Dave Chinner <dchinner@redhat.com>
---
 mkfs/xfs_mkfs.c | 207 +++++++++++++++++++++++++++++++-------------------------
 1 file changed, 114 insertions(+), 93 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 7b71f59dc654..a6d2dd516319 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -1903,6 +1903,107 @@ parse_subopts(
 }
 
 static void
+validate_sectorsize(
+	struct mkfs_params	*cfg,
+	struct cli_params	*cli,
+	struct mkfs_default_params *dft,
+	struct fs_topology	*ft,
+	char			*dfile,
+	int			dry_run,
+	int			force_overwrite)
+{
+	/* set configured sector sizes in preparation for checks */
+	if (!cli->sectorsize) {
+		cfg->sectorsize = dft->sectorsize;
+	} else {
+		cfg->sectorsize = cli->sectorsize;
+	}
+	cfg->sectorlog = libxfs_highbit32(cfg->sectorsize);
+
+	/*
+	 * Before anything else, verify that we are correctly operating on
+	 * files or block devices and set the control parameters correctly.
+	 */
+	check_device_type(dfile, &cli->xi->disfile, !cli->dsize, !dfile,
+			  dry_run ? NULL : &cli->xi->dcreat,
+			  force_overwrite, "d");
+	if (!cli->loginternal)
+		check_device_type(cli->xi->logname, &cli->xi->lisfile,
+				  !cli->logsize, !cli->xi->logname,
+				  dry_run ? NULL : &cli->xi->lcreat,
+				  force_overwrite, "l");
+	if (cli->xi->rtname)
+		check_device_type(cli->xi->rtname, &cli->xi->risfile,
+				  !cli->rtsize, !cli->xi->rtname,
+				  dry_run ? NULL : &cli->xi->rcreat,
+				  force_overwrite, "r");
+
+	/*
+	 * Explicitly disable direct IO for image files so we don't error out on
+	 * sector size mismatches between the new filesystem and the underlying
+	 * host filesystem.
+	 */
+	if (cli->xi->disfile || cli->xi->lisfile || cli->xi->risfile)
+		cli->xi->isdirect = 0;
+
+	memset(ft, 0, sizeof(*ft));
+	get_topology(cli->xi, ft, force_overwrite);
+
+	if (!cli->sectorsize) {
+		/*
+		 * Unless specified manually on the command line use the
+		 * advertised sector size of the device.  We use the physical
+		 * sector size unless the requested block size is smaller
+		 * than that, then we can use logical, but warn about the
+		 * inefficiency.
+		 *
+		 * Set the topology sectors if they were not probed to the
+		 * minimum supported sector size.
+		 */
+
+		if (!ft->lsectorsize)
+			ft->lsectorsize = XFS_MIN_SECTORSIZE;
+
+		/* Older kernels may not have physical/logical distinction */
+		if (!ft->psectorsize)
+			ft->psectorsize = ft->lsectorsize;
+
+		cfg->sectorsize = ft->psectorsize;
+		if (cfg->blocksize < cfg->sectorsize &&
+		    cfg->blocksize >= ft->lsectorsize) {
+			fprintf(stderr,
+_("specified blocksize %d is less than device physical sector size %d\n"
+  "switching to logical sector size %d\n"),
+				cfg->blocksize, ft->psectorsize,
+				ft->lsectorsize);
+			cfg->sectorsize = ft->lsectorsize;
+		}
+
+		cfg->sectorlog = libxfs_highbit32(cfg->sectorsize);
+	}
+
+	/* validate specified/probed sector size */
+	if (cfg->sectorsize < XFS_MIN_SECTORSIZE ||
+	    cfg->sectorsize > XFS_MAX_SECTORSIZE) {
+		fprintf(stderr, _("illegal sector size %d\n"), cfg->sectorsize);
+		usage();
+	}
+
+	if (cfg->blocksize < cfg->sectorsize) {
+		fprintf(stderr,
+_("block size %d cannot be smaller than sector size %d\n"),
+			cfg->blocksize, cfg->sectorsize);
+		usage();
+	}
+
+	if (cfg->sectorsize < ft->lsectorsize) {
+		fprintf(stderr, _("illegal sector size %d; hw sector is %d\n"),
+			cfg->sectorsize, ft->lsectorsize);
+		usage();
+	}
+}
+
+static void
 print_mkfs_cfg(
 	struct mkfs_params	*cfg,
 	char			*dfile,
@@ -2601,8 +2702,6 @@ main(
 	xfs_sb_t		*sbp;
 	int			sectorlog;
 	uint64_t		sector_mask;
-	int			slflag;
-	int			ssflag;
 	uint64_t		tmp_agsize;
 	uuid_t			uuid;
 	int			worst_freelist;
@@ -2660,10 +2759,10 @@ main(
 	memcpy(&cli.sb_feat, &dft.sb_feat, sizeof(cli.sb_feat));
 	memcpy(&cli.fsx, &dft.fsx, sizeof(cli.fsx));
 
-	blflag = bsflag = slflag = ssflag = lslflag = lssflag = 0;
+	blflag = bsflag = lslflag = lssflag = 0;
 	blocklog = blocksize = 0;
-	sectorlog = lsectorlog = 0;
-	sectorsize = lsectorsize = 0;
+	lsectorlog = 0;
+	lsectorsize = 0;
 	agsize = daflag = dasize = dblocks = 0;
 	ilflag = imflag = ipflag = isflag = 0;
 	liflag = laflag = lsflag = lsuflag = lsunitflag = ldflag = lvflag = 0;
@@ -2724,11 +2823,6 @@ main(
 				  cli_opt_set(&dopts, D_SWIDTH);
 			nodsflag = cli_opt_set(&dopts, D_NOALIGN);
 
-			sectorsize = cli.sectorsize;
-			sectorlog = libxfs_highbit32(sectorsize);
-			slflag = cli_opt_set(&dopts, D_SECTLOG);
-			ssflag = cli_opt_set(&dopts, D_SECTSIZE);
-
 			fsx.fsx_xflags |= cli.fsx.fsx_xflags;
 			fsx.fsx_projid = cli.fsx.fsx_projid;
 			fsx.fsx_extsize = cli.fsx.fsx_extsize;
@@ -2826,14 +2920,12 @@ main(
 			parse_subopts(c, optarg, &cli);
 
 			/* temp don't break code */
-			sectorsize = cli.sectorsize;
-			lsectorlog = libxfs_highbit32(sectorsize);
 			lsectorsize = cli.lsectorsize;
 			lsectorlog = libxfs_highbit32(lsectorsize);
-			lslflag = slflag = cli_opt_set(&sopts, S_LOG) ||
+			lslflag = cli_opt_set(&sopts, S_LOG) ||
 					   cli_opt_set(&sopts, S_SECTLOG);
 
-			lssflag = ssflag = cli_opt_set(&sopts, S_SIZE) ||
+			lssflag = cli_opt_set(&sopts, S_SIZE) ||
 					   cli_opt_set(&sopts, S_SECTSIZE);
 			break;
 		case 'V':
@@ -2879,89 +2971,18 @@ _("Minimum block size for CRC enabled filesystems is %d bytes.\n"),
 		usage();
 	}
 
-	if (!slflag && !ssflag) {
-		sectorlog = XFS_MIN_SECTORSIZE_LOG;
-		sectorsize = XFS_MIN_SECTORSIZE;
-	}
-	if (!lslflag && !lssflag) {
-		lsectorlog = sectorlog;
-		lsectorsize = sectorsize;
-	}
-
 	/*
-	 * Before anything else, verify that we are correctly operating on
-	 * files or block devices and set the control parameters correctly.
-	 * Explicitly disable direct IO for image files so we don't error out on
-	 * sector size mismatches between the new filesystem and the underlying
-	 * host filesystem.
+	 * Extract as much of the valid config as we can from the CLI input
+	 * before opening the libxfs devices.
 	 */
-	check_device_type(dfile, &xi.disfile, !dsize, !dfile,
-			  dry_run ? NULL : &xi.dcreat, force_overwrite, "d");
-	if (!loginternal)
-		check_device_type(xi.logname, &xi.lisfile, !logsize, !xi.logname,
-				  dry_run ? NULL : &xi.lcreat,
-				  force_overwrite, "l");
-	if (xi.rtname)
-		check_device_type(xi.rtname, &xi.risfile, !rtsize, !xi.rtname,
-				  dry_run ? NULL : &xi.rcreat,
-				  force_overwrite, "r");
-	if (xi.disfile || xi.lisfile || xi.risfile)
-		xi.isdirect = 0;
-
-	memset(&ft, 0, sizeof(ft));
-	get_topology(&xi, &ft, force_overwrite);
-
-	if (!ssflag) {
-		/*
-		 * Unless specified manually on the command line use the
-		 * advertised sector size of the device.  We use the physical
-		 * sector size unless the requested block size is smaller
-		 * than that, then we can use logical, but warn about the
-		 * inefficiency.
-		 */
-
-		/* Older kernels may not have physical/logical distinction */
-		if (!ft.psectorsize)
-			ft.psectorsize = ft.lsectorsize;
-
-		sectorsize = ft.psectorsize ? ft.psectorsize :
-					      XFS_MIN_SECTORSIZE;
-
-		if ((blocksize < sectorsize) && (blocksize >= ft.lsectorsize)) {
-			fprintf(stderr,
-_("specified blocksize %d is less than device physical sector size %d\n"),
-				blocksize, ft.psectorsize);
-			fprintf(stderr,
-_("switching to logical sector size %d\n"),
-				ft.lsectorsize);
-			sectorsize = ft.lsectorsize ? ft.lsectorsize :
-						      XFS_MIN_SECTORSIZE;
-		}
-	}
+	validate_sectorsize(&cfg, &cli, &dft, &ft, dfile, dry_run,
+			    force_overwrite);
 
-	if (!ssflag) {
-		sectorlog = libxfs_highbit32(sectorsize);
-		if (loginternal) {
-			lsectorsize = sectorsize;
-			lsectorlog = sectorlog;
-		}
-	}
+	/* temp don't break code */
+	sectorsize = cfg.sectorsize;
+	sectorlog = cfg.sectorlog;
+	/* end temp don't break code */
 
-	if (sectorsize < XFS_MIN_SECTORSIZE ||
-	    sectorsize > XFS_MAX_SECTORSIZE || sectorsize > blocksize) {
-		if (ssflag)
-			fprintf(stderr, _("illegal sector size %d\n"), sectorsize);
-		else
-			fprintf(stderr,
-_("block size %d cannot be smaller than logical sector size %d\n"),
-				blocksize, ft.lsectorsize);
-		usage();
-	}
-	if (sectorsize < ft.lsectorsize) {
-		fprintf(stderr, _("illegal sector size %d; hw sector is %d\n"),
-			sectorsize, ft.lsectorsize);
-		usage();
-	}
 	if (lsectorsize < XFS_MIN_SECTORSIZE ||
 	    lsectorsize > XFS_MAX_SECTORSIZE || lsectorsize > blocksize) {
 		fprintf(stderr, _("illegal log sector size %d\n"), lsectorsize);
-- 
2.13.3

