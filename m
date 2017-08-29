Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:11621 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751845AbdH2XvB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Aug 2017 19:51:01 -0400
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1dmqHX-0002ds-CE
        for linux-xfs@vger.kernel.org; Wed, 30 Aug 2017 09:50:55 +1000
Received: from dave by discord.disaster.area with local (Exim 4.89)
        (envelope-from <david@fromorbit.com>)
        id 1dmqHX-0005X5-B1
        for linux-xfs@vger.kernel.org; Wed, 30 Aug 2017 09:50:55 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 36/42] mkfs: factor AG alignment
Date: Wed, 30 Aug 2017 09:50:46 +1000
Message-Id: <20170829235052.21050-37-david@fromorbit.com>
In-Reply-To: <20170829235052.21050-1-david@fromorbit.com>
References: <20170829235052.21050-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Signed-Off-By: Dave Chinner <dchinner@redhat.com>
---
 mkfs/xfs_mkfs.c | 246 +++++++++++++++++++++++++++-----------------------------
 1 file changed, 117 insertions(+), 129 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index a0dcea2609a6..1ab9e98b8b02 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2750,6 +2750,121 @@ _("agsize (%s) not a multiple of fs blk size (%d)\n"),
 	}
 }
 
+/*
+ * Align the AG size to stripe geometry. If this fails and we are using
+ * discovered stripe geometry, tell the caller to clear the stripe geometry.
+ * Otherwise, set the aligned geometry (valid or invalid!) so that the
+ * validation call will fail and exit.
+ */
+static void
+align_ag_geometry(
+	struct mkfs_params	*cfg)
+{
+	uint64_t	tmp_agsize;
+	int		dsunit = cfg->dsunit;
+
+	if (!dsunit)
+		return;
+
+	/*
+	 * agsize is not a multiple of dsunit
+	 */
+	if ((cfg->agsize % dsunit) != 0) {
+		/*
+		 * Round up to stripe unit boundary. Also make sure
+		 * that agsize is still larger than
+		 * XFS_AG_MIN_BLOCKS(blocklog)
+		 */
+		tmp_agsize = ((cfg->agsize + dsunit - 1) / dsunit) * dsunit;
+		/*
+		 * Round down to stripe unit boundary if rounding up
+		 * created an AG size that is larger than the AG max.
+		 */
+		if (tmp_agsize > XFS_AG_MAX_BLOCKS(cfg->blocklog))
+			tmp_agsize = (cfg->agsize / dsunit) * dsunit;
+
+		if (tmp_agsize < XFS_AG_MIN_BLOCKS(cfg->blocklog) &&
+		    tmp_agsize > XFS_AG_MAX_BLOCKS(cfg->blocklog)) {
+
+			/*
+			 * If the AG size is invalid and we are using device
+			 * probed stripe alignment, just clear the alignment
+			 * and continue on.
+			 */
+			if (!cli_opt_set(&dopts, D_SUNIT) &&
+			    !cli_opt_set(&dopts, D_SU)) {
+				cfg->dsunit = 0;
+				cfg->dswidth = 0;
+				goto validate;
+			}
+			/*
+			 * set the agsize to the invalid value so the following
+			 * validation of the ag will fail and print a nice error
+			 * and exit.
+			 */
+			cfg->agsize = tmp_agsize;
+			goto validate;
+		}
+
+		/* update geometry to be stripe unit aligned */
+		cfg->agsize = tmp_agsize;
+		if (!cli_opt_set(&dopts, D_AGCOUNT))
+			cfg->agcount = cfg->dblocks / cfg->agsize +
+					(cfg->dblocks % cfg->agsize != 0);
+		if (cli_opt_set(&dopts, D_AGSIZE))
+			fprintf(stderr,
+_("agsize rounded to %lld, sunit = %d\n"),
+				(long long)cfg->agsize, dsunit);
+	}
+
+	if ((cfg->agsize % cfg->dswidth) == 0 && cfg->agcount > 1) {
+
+		if (cli_opt_set(&dopts, D_AGCOUNT) ||
+		    cli_opt_set(&dopts, D_AGSIZE)) {
+			fprintf(stderr, _(
+"Warning: AG size is a multiple of stripe width.  This can cause performance\n\
+problems by aligning all AGs on the same disk.  To avoid this, run mkfs with\n\
+an AG size that is one stripe unit smaller or larger, for example %llu.\n"),
+				(unsigned long long)cfg->agsize - dsunit);
+			goto validate;
+		}
+
+		/*
+		 * This is a non-optimal configuration because all AGs start on
+		 * the same disk in the stripe.  Changing the AG size by one
+		 * sunit will guarantee that this does not happen.
+		 */
+		tmp_agsize = cfg->agsize - dsunit;
+		if (tmp_agsize < XFS_AG_MIN_BLOCKS(cfg->blocklog)) {
+			tmp_agsize = cfg->agsize + dsunit;
+			if (cfg->dblocks < cfg->agsize) {
+				/* oh well, nothing to do */
+				tmp_agsize = cfg->agsize;
+			}
+		}
+
+		cfg->agsize = tmp_agsize;
+		cfg->agcount = cfg->dblocks / cfg->agsize +
+				(cfg->dblocks % cfg->agsize != 0);
+	}
+
+	/*
+	 * If the last AG is too small, reduce the filesystem size
+	 * and drop the blocks.
+	 */
+	if (cfg->dblocks % cfg->agsize != 0 &&
+	     (cfg->dblocks % cfg->agsize < XFS_AG_MIN_BLOCKS(cfg->blocklog))) {
+		ASSERT(!cli_opt_set(&dopts, D_AGCOUNT));
+		cfg->dblocks = (xfs_rfsblock_t)((cfg->agcount - 1) * cfg->agsize);
+		cfg->agcount--;
+		ASSERT(cfg->agcount != 0);
+	}
+
+validate:
+	validate_ag_geometry(cfg->blocklog, cfg->dblocks,
+			     cfg->agsize, cfg->agcount);
+}
+
 static void
 print_mkfs_cfg(
 	struct mkfs_params	*cfg,
@@ -3381,8 +3496,6 @@ main(
 	int			blocklog;
 	xfs_buf_t		*buf;
 	int			c;
-	int			daflag;
-	int			dasize;
 	xfs_rfsblock_t		dblocks;
 	char			*dfile;
 	int			dirblocklog;
@@ -3413,7 +3526,6 @@ main(
 	xfs_mount_t		*mp;
 	xfs_mount_t		mbuf;
 	xfs_extlen_t		nbmblocks;
-	int			nodsflag;
 	int			dry_run = 0;
 	int			discard = 1;
 	char			*protofile;
@@ -3425,7 +3537,6 @@ main(
 	char			*rtfile;
 	xfs_sb_t		*sbp;
 	int			sectorlog;
-	uint64_t		tmp_agsize;
 	uuid_t			uuid;
 	int			worst_freelist;
 	libxfs_init_t		xi;
@@ -3489,7 +3600,7 @@ main(
 	 */
 	cli.loginternal = 1;	/* internal by default */
 
-	agsize = daflag = dasize = dblocks = 0;
+	agsize = dblocks = 0;
 	imflag = 0;
 	laflag = lsflag = 0;
 	loginternal = 1;
@@ -3498,7 +3609,6 @@ main(
 	dfile = logfile = rtfile = NULL;
 	logsize = protofile = NULL;
 	dsunit = dswidth = lalign = lsunit = 0;
-	nodsflag = 0;
 	force_overwrite = 0;
 	worst_freelist = 0;
 	memset(&fsx, 0, sizeof(fsx));
@@ -3523,13 +3633,6 @@ main(
 			parse_subopts(c, optarg, &cli);
 
 			/* temp don't break code */
-			agcount = cli.agcount;
-			if (cli_opt_set(&dopts, D_AGSIZE)) {
-				agsize = getnum(cli.agsize, &dopts, D_AGSIZE);
-				dasize = 1;
-			}
-			daflag = cli_opt_set(&dopts, D_AGCOUNT);
-
 			fsx.fsx_xflags |= cli.fsx.fsx_xflags;
 			fsx.fsx_projid = cli.fsx.fsx_projid;
 			fsx.fsx_extsize = cli.fsx.fsx_extsize;
@@ -3641,6 +3744,7 @@ main(
 	 * aligns to device geometry correctly.
 	 */
 	calculate_initial_ag_geometry(&cfg, &cli);
+	align_ag_geometry(&cfg);
 
 	/* temp don't break code */
 	sectorsize = cfg.sectorsize;
@@ -3665,127 +3769,11 @@ main(
 	dsunit = cfg.dsunit;
 	dswidth = cfg.dswidth;
 	lsunit = cfg.lsunit;
-	nodsflag = cfg.sb_feat.nodalign;
 	agsize = cfg.agsize;
 	agcount = cfg.agcount;
 	/* end temp don't break code */
 
 
-	/*
-	 * If dsunit is a multiple of fs blocksize, then check that is a
-	 * multiple of the agsize too
-	 */
-	if (dsunit && !(BBTOB(dsunit) % blocksize) &&
-	    dswidth && !(BBTOB(dswidth) % blocksize)) {
-
-		/* convert from 512 byte blocks to fs blocksize */
-		dsunit = DTOBT(dsunit, blocklog);
-		dswidth = DTOBT(dswidth, blocklog);
-
-		/*
-		 * agsize is not a multiple of dsunit
-		 */
-		if ((agsize % dsunit) != 0) {
-			/*
-			 * Round up to stripe unit boundary. Also make sure
-			 * that agsize is still larger than
-			 * XFS_AG_MIN_BLOCKS(blocklog)
-		 	 */
-			tmp_agsize = ((agsize + (dsunit - 1))/ dsunit) * dsunit;
-			/*
-			 * Round down to stripe unit boundary if rounding up
-			 * created an AG size that is larger than the AG max.
-			 */
-			if (tmp_agsize > XFS_AG_MAX_BLOCKS(blocklog))
-				tmp_agsize = ((agsize) / dsunit) * dsunit;
-
-			if ((tmp_agsize >= XFS_AG_MIN_BLOCKS(blocklog)) &&
-			    (tmp_agsize <= XFS_AG_MAX_BLOCKS(blocklog))) {
-				agsize = tmp_agsize;
-				if (!daflag)
-					agcount = dblocks/agsize +
-						(dblocks % agsize != 0);
-				if (dasize)
-					fprintf(stderr,
-				_("agsize rounded to %lld, swidth = %d\n"),
-						(long long)agsize, dswidth);
-			} else {
-				if (nodsflag) {
-					dsunit = dswidth = 0;
-				} else {
-					/*
-					 * agsize is out of bounds, this will
-					 * print nice details & exit.
-					 */
-					validate_ag_geometry(blocklog, dblocks,
-							    agsize, agcount);
-					exit(1);
-				}
-			}
-		}
-		if (dswidth && ((agsize % dswidth) == 0) && (agcount > 1)) {
-			/* This is a non-optimal configuration because all AGs
-			 * start on the same disk in the stripe.  Changing
-			 * the AG size by one sunit will guarantee that this
-			 * does not happen.
-			 */
-			tmp_agsize = agsize - dsunit;
-			if (tmp_agsize < XFS_AG_MIN_BLOCKS(blocklog)) {
-				tmp_agsize = agsize + dsunit;
-				if (dblocks < agsize) {
-					/* oh well, nothing to do */
-					tmp_agsize = agsize;
-				}
-			}
-			if (daflag || dasize) {
-				fprintf(stderr, _(
-"Warning: AG size is a multiple of stripe width.  This can cause performance\n\
-problems by aligning all AGs on the same disk.  To avoid this, run mkfs with\n\
-an AG size that is one stripe unit smaller, for example %llu.\n"),
-					(unsigned long long)tmp_agsize);
-			} else {
-				agsize = tmp_agsize;
-				agcount = dblocks/agsize + (dblocks % agsize != 0);
-				/*
-				 * If the last AG is too small, reduce the
-				 * filesystem size and drop the blocks.
-				 */
-				if ( dblocks % agsize != 0 &&
-				    (dblocks % agsize <
-				    XFS_AG_MIN_BLOCKS(blocklog))) {
-					dblocks = (xfs_rfsblock_t)((agcount - 1) * agsize);
-					agcount--;
-					ASSERT(agcount != 0);
-				}
-			}
-		}
-	} else {
-		if (nodsflag)
-			dsunit = dswidth = 0;
-		else {
-			fprintf(stderr,
-				_("%s: Stripe unit(%d) or stripe width(%d) is "
-				"not a multiple of the block size(%d)\n"),
-				progname, BBTOB(dsunit), BBTOB(dswidth),
-				blocksize);
-			exit(1);
-		}
-	}
-
-	/*
-	 * If the last AG is too small, reduce the filesystem size
-	 * and drop the blocks.
-	 */
-	if ( dblocks % agsize != 0 &&
-	     (dblocks % agsize < XFS_AG_MIN_BLOCKS(blocklog))) {
-		ASSERT(!daflag);
-		dblocks = (xfs_rfsblock_t)((agcount - 1) * agsize);
-		agcount--;
-		ASSERT(agcount != 0);
-	}
-
-	validate_ag_geometry(blocklog, dblocks, agsize, agcount);
-
 	if (!imflag)
 		imaxpct = calc_default_imaxpct(blocklog, dblocks);
 
-- 
2.13.3

