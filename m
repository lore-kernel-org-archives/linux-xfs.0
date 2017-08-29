Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:55482 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751887AbdH2XvE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Aug 2017 19:51:04 -0400
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1dmqHX-0002dx-EQ
        for linux-xfs@vger.kernel.org; Wed, 30 Aug 2017 09:50:55 +1000
Received: from dave by discord.disaster.area with local (Exim 4.89)
        (envelope-from <david@fromorbit.com>)
        id 1dmqHX-0005XE-DI
        for linux-xfs@vger.kernel.org; Wed, 30 Aug 2017 09:50:55 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 39/42] mkfs: factor log size calculations
Date: Wed, 30 Aug 2017 09:50:49 +1000
Message-Id: <20170829235052.21050-40-david@fromorbit.com>
In-Reply-To: <20170829235052.21050-1-david@fromorbit.com>
References: <20170829235052.21050-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Signed-Off-By: Dave Chinner <dchinner@redhat.com>
---
 mkfs/xfs_mkfs.c | 420 +++++++++++++++++++++++++++++---------------------------
 1 file changed, 217 insertions(+), 203 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 3fc485524d99..cbba679ba06d 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -971,91 +971,6 @@ check_device_type(
 }
 
 static void
-fixup_log_stripe_unit(
-	int		lsflag,
-	int		sunit,
-	xfs_rfsblock_t	*logblocks,
-	int		blocklog)
-{
-	uint64_t	tmp_logblocks;
-
-	/*
-	 * Make sure that the log size is a multiple of the stripe unit
-	 */
-	if ((*logblocks % sunit) != 0) {
-		if (!lsflag) {
-			tmp_logblocks = ((*logblocks + (sunit - 1))
-						/ sunit) * sunit;
-			/*
-			 * If the log is too large, round down
-			 * instead of round up
-			 */
-			if ((tmp_logblocks > XFS_MAX_LOG_BLOCKS) ||
-			    ((tmp_logblocks << blocklog) > XFS_MAX_LOG_BYTES)) {
-				tmp_logblocks = (*logblocks / sunit) * sunit;
-			}
-			*logblocks = tmp_logblocks;
-		} else {
-			fprintf(stderr, _("log size %lld is not a multiple "
-					  "of the log stripe unit %d\n"),
-				(long long) *logblocks, sunit);
-			usage();
-		}
-	}
-}
-
-static xfs_fsblock_t
-fixup_internal_log_stripe(
-	xfs_mount_t	*mp,
-	int		lsflag,
-	xfs_fsblock_t	logstart,
-	uint64_t	agsize,
-	int		sunit,
-	xfs_rfsblock_t	*logblocks,
-	int		blocklog,
-	int		*lalign)
-{
-	if ((logstart % sunit) != 0) {
-		logstart = ((logstart + (sunit - 1))/sunit) * sunit;
-		*lalign = 1;
-	}
-
-	fixup_log_stripe_unit(lsflag, sunit, logblocks, blocklog);
-
-	if (*logblocks > agsize - XFS_FSB_TO_AGBNO(mp, logstart)) {
-		fprintf(stderr,
-			_("Due to stripe alignment, the internal log size "
-			"(%lld) is too large.\n"), (long long) *logblocks);
-		fprintf(stderr, _("Must fit within an allocation group.\n"));
-		usage();
-	}
-	return logstart;
-}
-
-void
-validate_log_size(uint64_t logblocks, int blocklog, int min_logblocks)
-{
-	if (logblocks < min_logblocks) {
-		fprintf(stderr,
-	_("log size %lld blocks too small, minimum size is %d blocks\n"),
-			(long long)logblocks, min_logblocks);
-		usage();
-	}
-	if (logblocks > XFS_MAX_LOG_BLOCKS) {
-		fprintf(stderr,
-	_("log size %lld blocks too large, maximum size is %lld blocks\n"),
-			(long long)logblocks, XFS_MAX_LOG_BLOCKS);
-		usage();
-	}
-	if ((logblocks << blocklog) > XFS_MAX_LOG_BYTES) {
-		fprintf(stderr,
-	_("log size %lld bytes too large, maximum size is %lld bytes\n"),
-			(long long)(logblocks << blocklog), XFS_MAX_LOG_BYTES);
-		usage();
-	}
-}
-
-static void
 validate_ag_geometry(
 	int		blocklog,
 	uint64_t	dblocks,
@@ -2885,6 +2800,210 @@ sb_set_features(
 }
 
 /*
+ * Make sure that the log size is a multiple of the stripe unit
+ */
+static void
+align_log_size(
+	struct mkfs_params	*cfg,
+	int			sunit)
+{
+	uint64_t	tmp_logblocks;
+
+	/* nothing to do if it's already aligned. */
+	if ((cfg->logblocks % sunit) == 0)
+		return;
+
+	if (cli_opt_set(&lopts, L_SIZE)) {
+		fprintf(stderr,
+_("log size %lld is not a multiple of the log stripe unit %d\n"),
+			(long long) cfg->logblocks, sunit);
+		usage();
+	}
+
+	tmp_logblocks = ((cfg->logblocks + (sunit - 1)) / sunit) * sunit;
+
+	/* If the log is too large, round down instead of round up */
+	if ((tmp_logblocks > XFS_MAX_LOG_BLOCKS) ||
+	    ((tmp_logblocks << cfg->blocklog) > XFS_MAX_LOG_BYTES)) {
+		tmp_logblocks = (cfg->logblocks / sunit) * sunit;
+	}
+	cfg->logblocks = tmp_logblocks;
+}
+
+/*
+ * Make sure that the internal log is correctly aligned to the specified
+ * stripe unit.
+ */
+static void
+align_internal_log(
+	struct mkfs_params	*cfg,
+	struct xfs_mount	*mp,
+	int			sunit)
+{
+	uint64_t	agspace;
+
+	/* round up log start if necessary */
+	if ((cfg->logstart % sunit) != 0)
+		cfg->logstart = ((cfg->logstart + (sunit - 1)) / sunit) * sunit;
+
+	/* round up/down the log size now */
+	align_log_size(cfg, sunit);
+
+	/* check the aligned log still fits in an AG. */
+	agspace = cfg->agsize - libxfs_prealloc_blocks(mp);
+	if (cfg->logblocks > agspace - XFS_FSB_TO_AGBNO(mp, cfg->logstart)) {
+		fprintf(stderr,
+_("Due to stripe alignment, the internal log size (%lld) is too large.\n"
+  "Must fit within an allocation group.\n"),
+			(long long) cfg->logblocks);
+		usage();
+	}
+}
+
+void
+validate_log_size(uint64_t logblocks, int blocklog, int min_logblocks)
+{
+	if (logblocks < min_logblocks) {
+		fprintf(stderr,
+	_("log size %lld blocks too small, minimum size is %d blocks\n"),
+			(long long)logblocks, min_logblocks);
+		usage();
+	}
+	if (logblocks > XFS_MAX_LOG_BLOCKS) {
+		fprintf(stderr,
+	_("log size %lld blocks too large, maximum size is %lld blocks\n"),
+			(long long)logblocks, XFS_MAX_LOG_BLOCKS);
+		usage();
+	}
+	if ((logblocks << blocklog) > XFS_MAX_LOG_BYTES) {
+		fprintf(stderr,
+	_("log size %lld bytes too large, maximum size is %lld bytes\n"),
+			(long long)(logblocks << blocklog), XFS_MAX_LOG_BYTES);
+		usage();
+	}
+}
+
+static void
+calculate_log_size(
+	struct mkfs_params	*cfg,
+	struct cli_params	*cli,
+	struct xfs_mount	*mp)
+{
+	struct sb_feat_args	*fp = &cfg->sb_feat;
+	struct xfs_sb		*sbp = &mp->m_sb;
+	int			min_logblocks;
+
+	min_logblocks = max_trans_res(sbp->sb_agblocks, fp->crcs_enabled,
+				      fp->dir_version, cfg->sectorlog,
+				      cfg->blocklog, cfg->inodelog,
+				      cfg->dirblocklog, fp->log_version,
+				      cfg->lsunit, fp->finobt, fp->rmapbt,
+				      fp->reflink, fp->inode_align);
+
+	ASSERT(min_logblocks);
+	min_logblocks = MAX(XFS_MIN_LOG_BLOCKS, min_logblocks);
+
+	/* if we have lots of blocks, check against XFS_MIN_LOG_BYTES, too */
+	if (!cli->logsize &&
+	    cfg->dblocks >= (1024*1024*1024) >> cfg->blocklog)
+		min_logblocks = MAX(min_logblocks,
+				    XFS_MIN_LOG_BYTES >> cfg->blocklog);
+
+	/*
+	 * external logs will have a device and size by now, so all we have
+	 * to do is validate it against minimum size and align it.
+	 */
+	if (!cfg->loginternal) {
+		if (min_logblocks > cfg->logblocks) {
+			fprintf(stderr,
+_("external log device %lld too small, must be at least %lld blocks\n"),
+				(long long)cfg->logblocks,
+				(long long)min_logblocks);
+			usage();
+		}
+		cfg->logstart = 0;
+		cfg->logagno = 0;
+		if (cfg->lsunit)
+			align_log_size(cfg, cfg->lsunit);
+
+		validate_log_size(cfg->logblocks, cfg->blocklog, min_logblocks);
+		return;
+	}
+
+	/* internal log - if no size specified, calculate automatically */
+	if (!cfg->logblocks) {
+		if (cfg->dblocks < GIGABYTES(1, cfg->blocklog)) {
+			/* tiny filesystems get minimum sized logs. */
+			cfg->logblocks = min_logblocks;
+		} else if (cfg->dblocks < GIGABYTES(16, cfg->blocklog)) {
+
+			/*
+			 * For small filesystems, we want to use the
+			 * XFS_MIN_LOG_BYTES for filesystems smaller than 16G if
+			 * at all possible, ramping up to 128MB at 256GB.
+			 */
+			cfg->logblocks = MIN(XFS_MIN_LOG_BYTES >> cfg->blocklog,
+					min_logblocks * XFS_DFL_LOG_FACTOR);
+		} else {
+			/*
+			 * With a 2GB max log size, default to maximum size
+			 * at 4TB. This keeps the same ratio from the older
+			 * max log size of 128M at 256GB fs size. IOWs,
+			 * the ratio of fs size to log size is 2048:1.
+			 */
+			cfg->logblocks = (cfg->dblocks << cfg->blocklog) / 2048;
+			cfg->logblocks = cfg->logblocks >> cfg->blocklog;
+		}
+
+		/* Ensure the chosen size meets minimum log size requirements */
+		cfg->logblocks = MAX(min_logblocks, cfg->logblocks);
+
+		/* make sure the log fits wholly within an AG */
+		cfg->logblocks = MIN(cfg->logblocks,
+				     libxfs_alloc_ag_max_usable(mp));
+
+		/* and now clamp the size to the maximum supported size */
+		cfg->logblocks = MIN(cfg->logblocks, XFS_MAX_LOG_BLOCKS);
+		if ((cfg->logblocks << cfg->blocklog) > XFS_MAX_LOG_BYTES)
+			cfg->logblocks = XFS_MAX_LOG_BYTES >> cfg->blocklog;
+
+		validate_log_size(cfg->logblocks, cfg->blocklog, min_logblocks);
+	}
+
+	if (cfg->logblocks > sbp->sb_agblocks - libxfs_prealloc_blocks(mp)) {
+		fprintf(stderr,
+_("internal log size %lld too large, must fit in allocation group\n"),
+			(long long)cfg->logblocks);
+		usage();
+	}
+
+	if (cli_opt_set(&lopts, L_AGNUM)) {
+		if (cli->logagno >= sbp->sb_agcount) {
+			fprintf(stderr,
+_("log ag number %lld too large, must be less than %lld\n"),
+				(long long)cli->logagno,
+				(long long)sbp->sb_agcount);
+			usage();
+		}
+		cfg->logagno = cli->logagno;
+	} else
+		cfg->logagno = (xfs_agnumber_t)(sbp->sb_agcount / 2);
+
+	cfg->logstart = XFS_AGB_TO_FSB(mp, cfg->logagno,
+				       libxfs_prealloc_blocks(mp));
+
+	/*
+	 * Align the logstart at stripe unit boundary.
+	 */
+	if (cfg->lsunit) {
+		align_internal_log(cfg, mp, cfg->lsunit);
+	} else if (cfg->dsunit) {
+		align_internal_log(cfg, mp, cfg->dsunit);
+	}
+	validate_log_size(cfg->logblocks, cfg->blocklog, min_logblocks);
+}
+
+/*
  * Set up mount and superblock with the minimum parameters required for
  * the libxfs macros needed by the log sizing code to run successfully.
  */
@@ -3538,19 +3657,14 @@ main(
 	int			inopblock;
 	int			isize;
 	char			*label = NULL;
-	int			laflag;
-	int			lalign;
 	xfs_agnumber_t		logagno;
 	xfs_rfsblock_t		logblocks;
 	char			*logfile;
 	int			loginternal;
-	char			*logsize;
 	xfs_fsblock_t		logstart;
-	int			lsflag;
 	int			lsectorlog;
 	int			lsectorsize;
 	int			lsunit;
-	int			min_logblocks;
 	xfs_extlen_t		nbmblocks;
 	int			dry_run = 0;
 	int			discard = 1;
@@ -3629,13 +3743,12 @@ main(
 	cli.loginternal = 1;	/* internal by default */
 
 	agsize = dblocks = 0;
-	laflag = lsflag = 0;
 	loginternal = 1;
 	logagno = logblocks = rtblocks = rtextblocks = 0;
 	imaxpct = inodelog = inopblock = isize = 0;
 	dfile = logfile = rtfile = NULL;
-	logsize = protofile = NULL;
-	dsunit = dswidth = lalign = lsunit = 0;
+	protofile = NULL;
+	dsunit = dswidth = lsunit = 0;
 	force_overwrite = 0;
 	worst_freelist = 0;
 	memset(&fsx, 0, sizeof(fsx));
@@ -3652,6 +3765,7 @@ main(
 			break;
 		case 'b':
 		case 'i':
+		case 'l':
 		case 'n':
 		case 'r':
 		case 's':
@@ -3666,14 +3780,6 @@ main(
 			fsx.fsx_extsize = cli.fsx.fsx_extsize;
 			/* end temp don't break code */
 			break;
-		case 'l':
-			parse_subopts(c, optarg, &cli);
-
-			/* temp don't break code */
-			logagno = cli.logagno;
-			laflag = cli_opt_set(&lopts, L_AGNUM);
-			/* end temp don't break code */
-			break;
 		case 'L':
 			if (strlen(optarg) > sizeof(sbp->sb_fname))
 				illegal(optarg, "L");
@@ -3775,6 +3881,14 @@ main(
 	 */
 	initialise_mount(&cfg, mp, sbp);
 
+	/*
+	 * With the mount set up, we can finally calculate the log size
+	 * constraints and do default size calculations and final validation
+	 */
+	calculate_log_size(&cfg, &cli, mp);
+
+	protostring = setup_proto(protofile);
+
 	/* temp don't break code */
 	sectorsize = cfg.sectorsize;
 	sectorlog = cfg.sectorlog;
@@ -3801,110 +3915,10 @@ main(
 	agsize = cfg.agsize;
 	agcount = cfg.agcount;
 	imaxpct = cfg.imaxpct;
+	logagno = cfg.logagno;
+	logstart = cfg.logstart;
 	/* end temp don't break code */
 
-	min_logblocks = max_trans_res(agsize,
-				   sb_feat.crcs_enabled, sb_feat.dir_version,
-				   sectorlog, blocklog, inodelog, dirblocklog,
-				   sb_feat.log_version, lsunit, sb_feat.finobt,
-				   sb_feat.rmapbt, sb_feat.reflink,
-				   sb_feat.inode_align);
-	ASSERT(min_logblocks);
-	min_logblocks = MAX(XFS_MIN_LOG_BLOCKS, min_logblocks);
-	if (!logsize && dblocks >= (1024*1024*1024) >> blocklog)
-		min_logblocks = MAX(min_logblocks, XFS_MIN_LOG_BYTES>>blocklog);
-	if (loginternal && !logsize) {
-
-		if (dblocks < GIGABYTES(1, blocklog)) {
-			/* tiny filesystems get minimum sized logs. */
-			logblocks = min_logblocks;
-		} else if (dblocks < GIGABYTES(16, blocklog)) {
-
-			/*
-			 * For small filesystems, we want to use the
-			 * XFS_MIN_LOG_BYTES for filesystems smaller than 16G if
-			 * at all possible, ramping up to 128MB at 256GB.
-			 */
-			logblocks = MIN(XFS_MIN_LOG_BYTES >> blocklog,
-					min_logblocks * XFS_DFL_LOG_FACTOR);
-		} else {
-			/*
-			 * With a 2GB max log size, default to maximum size
-			 * at 4TB. This keeps the same ratio from the older
-			 * max log size of 128M at 256GB fs size. IOWs,
-			 * the ratio of fs size to log size is 2048:1.
-			 */
-			logblocks = (dblocks << blocklog) / 2048;
-			logblocks = logblocks >> blocklog;
-		}
-
-		/* Ensure the chosen size meets minimum log size requirements */
-		logblocks = MAX(min_logblocks, logblocks);
-
-		/* make sure the log fits wholly within an AG */
-		if (logblocks >= agsize)
-			logblocks = min_logblocks;
-
-		/* and now clamp the size to the maximum supported size */
-		logblocks = MIN(logblocks, XFS_MAX_LOG_BLOCKS);
-		if ((logblocks << blocklog) > XFS_MAX_LOG_BYTES)
-			logblocks = XFS_MAX_LOG_BYTES >> blocklog;
-
-	}
-	validate_log_size(logblocks, blocklog, min_logblocks);
-
-	protostring = setup_proto(protofile);
-
-	if (loginternal) {
-		/*
-		 * Readjust the log size to fit within an AG if it was sized
-		 * automatically.
-		 */
-		if (!logsize) {
-			logblocks = MIN(logblocks,
-					libxfs_alloc_ag_max_usable(mp));
-
-			/* revalidate the log size is valid if we changed it */
-			validate_log_size(logblocks, blocklog, min_logblocks);
-		}
-		if (logblocks > agsize - libxfs_prealloc_blocks(mp)) {
-			fprintf(stderr,
-	_("internal log size %lld too large, must fit in allocation group\n"),
-				(long long)logblocks);
-			usage();
-		}
-
-		if (laflag) {
-			if (logagno >= agcount) {
-				fprintf(stderr,
-		_("log ag number %d too large, must be less than %lld\n"),
-					logagno, (long long)agcount);
-				usage();
-			}
-		} else
-			logagno = (xfs_agnumber_t)(agcount / 2);
-
-		logstart = XFS_AGB_TO_FSB(mp, logagno, libxfs_prealloc_blocks(mp));
-		/*
-		 * Align the logstart at stripe unit boundary.
-		 */
-		if (lsunit) {
-			logstart = fixup_internal_log_stripe(mp,
-					lsflag, logstart, agsize, lsunit,
-					&logblocks, blocklog, &lalign);
-		} else if (dsunit) {
-			logstart = fixup_internal_log_stripe(mp,
-					lsflag, logstart, agsize, dsunit,
-					&logblocks, blocklog, &lalign);
-		}
-	} else {
-		logstart = 0;
-		if (lsunit)
-			fixup_log_stripe_unit(lsflag, lsunit,
-					&logblocks, blocklog);
-	}
-	validate_log_size(logblocks, blocklog, min_logblocks);
-
 	/* Temp support code  to set up mkfs cfg parameters */
 	cfg.blocksize = blocksize;
 	cfg.blocklog = blocklog;
-- 
2.13.3

