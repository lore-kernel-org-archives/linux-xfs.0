Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:40488 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751845AbdH2XvE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Aug 2017 19:51:04 -0400
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1dmqHX-0002e1-FR
        for linux-xfs@vger.kernel.org; Wed, 30 Aug 2017 09:50:55 +1000
Received: from dave by discord.disaster.area with local (Exim 4.89)
        (envelope-from <david@fromorbit.com>)
        id 1dmqHX-0005XH-E4
        for linux-xfs@vger.kernel.org; Wed, 30 Aug 2017 09:50:55 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 40/42] mkfs: cleanup redundant temporary code
Date: Wed, 30 Aug 2017 09:50:50 +1000
Message-Id: <20170829235052.21050-41-david@fromorbit.com>
In-Reply-To: <20170829235052.21050-1-david@fromorbit.com>
References: <20170829235052.21050-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Now the factoring is complete, we can remove the remaining temporary
code that was used to isolate the factoring from the rest of the
code.

Signed-Off-By: Dave Chinner <dchinner@redhat.com>
---
 mkfs/xfs_mkfs.c | 185 +++++++++++---------------------------------------------
 1 file changed, 34 insertions(+), 151 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index cbba679ba06d..9d087bc068a7 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -33,8 +33,8 @@ static void unknown(char opt, char *s);
 static int  ispow2(unsigned int i);
 
 /*
- * The configured block and sector sizes are defined as global variables so
- * that they don't need to be passed to functions that require them.
+ * XXX: The configured block and sector sizes are defined as global variables so
+ * that they don't need to be passed to getnum/cvtnum().
  */
 unsigned int		blocksize;
 unsigned int		sectorsize;
@@ -3638,52 +3638,34 @@ main(
 	int			argc,
 	char			**argv)
 {
-	uint64_t		agcount;
 	xfs_agnumber_t		agno;
-	uint64_t		agsize;
-	int			blocklog;
 	xfs_buf_t		*buf;
 	int			c;
-	xfs_rfsblock_t		dblocks;
-	char			*dfile;
-	int			dirblocklog;
-	int			dirblocksize;
-	int			dsunit;
-	int			dswidth;
-	int			force_overwrite;
-	struct fsxattr		fsx;
-	int			imaxpct;
-	int			inodelog;
-	int			inopblock;
-	int			isize;
-	char			*label = NULL;
-	xfs_agnumber_t		logagno;
-	xfs_rfsblock_t		logblocks;
-	char			*logfile;
-	int			loginternal;
-	xfs_fsblock_t		logstart;
-	int			lsectorlog;
-	int			lsectorsize;
-	int			lsunit;
-	xfs_extlen_t		nbmblocks;
+	char			*dfile = NULL;
+	char			*logfile = NULL;
+	char			*rtfile = NULL;
 	int			dry_run = 0;
 	int			discard = 1;
-	char			*protofile;
-	char			*protostring;
+	int			force_overwrite = 0;
 	int			quiet = 0;
-	xfs_rfsblock_t		rtblocks;
-	xfs_extlen_t		rtextblocks;
-	xfs_rtblock_t		rtextents;
-	char			*rtfile;
-	int			sectorlog;
-	uuid_t			uuid;
-	int			worst_freelist;
-	libxfs_init_t		xi;
+	char			*protofile = NULL;
+	char			*protostring = NULL;
+	int			worst_freelist = 0;
+
+	struct libxfs_xinit	xi = {
+		.isdirect = LIBXFS_DIRECT,
+		.isreadonly = LIBXFS_EXCLUSIVELY,
+	};
 	struct xfs_mount	mbuf = {};
 	struct xfs_mount	*mp = &mbuf;
 	struct xfs_sb		*sbp = &mp->m_sb;
-	struct fs_topology	ft;
-	struct sb_feat_args	sb_feat;
+	struct fs_topology	ft = {};
+	struct cli_params	cli = {
+		.xi = &xi,
+		.loginternal = 1,
+	};
+	struct mkfs_params	cfg = {};
+
 	/* build time defaults */
 	struct mkfs_default_params	dft = {
 		.source = "package build definitions",
@@ -3708,10 +3690,6 @@ main(
 			.nortalign = false,
 		},
 	};
-	struct cli_params	cli = {
-		.xi = &xi,
-	};
-	struct mkfs_params	cfg = {};
 
 	platform_uuid_generate(&cli.uuid);
 	progname = basename(argv[0]);
@@ -3735,28 +3713,6 @@ main(
 	memcpy(&cli.sb_feat, &dft.sb_feat, sizeof(cli.sb_feat));
 	memcpy(&cli.fsx, &dft.fsx, sizeof(cli.fsx));
 
-	/*
-	 * Initialise cli parameters that can be set to zero to an appropriate
-	 * value so we can tell if they have been set or or changed from the
-	 * default value.
-	 */
-	cli.loginternal = 1;	/* internal by default */
-
-	agsize = dblocks = 0;
-	loginternal = 1;
-	logagno = logblocks = rtblocks = rtextblocks = 0;
-	imaxpct = inodelog = inopblock = isize = 0;
-	dfile = logfile = rtfile = NULL;
-	protofile = NULL;
-	dsunit = dswidth = lsunit = 0;
-	force_overwrite = 0;
-	worst_freelist = 0;
-	memset(&fsx, 0, sizeof(fsx));
-
-	memset(&xi, 0, sizeof(xi));
-	xi.isdirect = LIBXFS_DIRECT;
-	xi.isreadonly = LIBXFS_EXCLUSIVELY;
-
 	while ((c = getopt(argc, argv, "b:d:i:l:L:m:n:KNp:qr:s:CfV")) != EOF) {
 		switch (c) {
 		case 'C':
@@ -3764,33 +3720,19 @@ main(
 			force_overwrite = 1;
 			break;
 		case 'b':
+		case 'd':
 		case 'i':
 		case 'l':
+		case 'm':
 		case 'n':
 		case 'r':
 		case 's':
 			parse_subopts(c, optarg, &cli);
 			break;
-		case 'd':
-			parse_subopts(c, optarg, &cli);
-
-			/* temp don't break code */
-			fsx.fsx_xflags |= cli.fsx.fsx_xflags;
-			fsx.fsx_projid = cli.fsx.fsx_projid;
-			fsx.fsx_extsize = cli.fsx.fsx_extsize;
-			/* end temp don't break code */
-			break;
 		case 'L':
 			if (strlen(optarg) > sizeof(sbp->sb_fname))
 				illegal(optarg, "L");
-			label = optarg;
-			break;
-		case 'm':
-			parse_subopts(c, optarg, &cli);
-
-			/* temp don't break code */
-			platform_uuid_copy(&uuid, &cli.uuid);
-			/* end temp don't break code */
+			cfg.label = optarg;
 			break;
 		case 'N':
 			dry_run = 1;
@@ -3821,9 +3763,7 @@ main(
 	} else
 		dfile = xi.dname;
 
-	/* temp don't break code */
-	sb_feat = cli.sb_feat;
-	/* end temp don't break code */
+	protostring = setup_proto(protofile);
 
 	/*
 	 * Extract as much of the valid config as we can from the CLI input
@@ -3832,6 +3772,14 @@ main(
 	validate_blocksize(&cfg, &cli, &dft);
 	validate_sectorsize(&cfg, &cli, &dft, &ft, dfile, dry_run,
 			    force_overwrite);
+
+	/*
+	 * XXX: we still need to set block size and sector size global variables
+	 * so that getnum/cvtnum works correctly
+	 */
+	blocksize = cfg.blocksize;
+	sectorsize = cfg.sectorsize;
+
 	validate_log_sectorsize(&cfg, &cli, &dft);
 	validate_sb_features(&cfg, &cli);
 
@@ -3887,71 +3835,6 @@ main(
 	 */
 	calculate_log_size(&cfg, &cli, mp);
 
-	protostring = setup_proto(protofile);
-
-	/* temp don't break code */
-	sectorsize = cfg.sectorsize;
-	sectorlog = cfg.sectorlog;
-	blocksize = cfg.blocksize;
-	blocklog = cfg.blocklog;
-	lsectorsize = cfg.lsectorsize;
-	lsectorlog = cfg.lsectorlog;
-	sb_feat = cfg.sb_feat;
-	platform_uuid_copy(&uuid, &cfg.uuid);
-	dirblocksize = cfg.dirblocksize;
-	dirblocklog = cfg.dirblocklog;
-	isize = cfg.inodesize;
-	inodelog = cfg.inodelog;
-	inopblock = cfg.inopblock;
-	dblocks = cfg.dblocks;
-	logblocks = cfg.logblocks;
-	rtblocks = cfg.rtblocks;
-	rtextblocks = cfg.rtextblocks;
-	nbmblocks = cfg.rtbmblocks;
-	rtextents = cfg.rtextents;
-	dsunit = cfg.dsunit;
-	dswidth = cfg.dswidth;
-	lsunit = cfg.lsunit;
-	agsize = cfg.agsize;
-	agcount = cfg.agcount;
-	imaxpct = cfg.imaxpct;
-	logagno = cfg.logagno;
-	logstart = cfg.logstart;
-	/* end temp don't break code */
-
-	/* Temp support code  to set up mkfs cfg parameters */
-	cfg.blocksize = blocksize;
-	cfg.blocklog = blocklog;
-	cfg.sectorsize = sectorsize;
-	cfg.sectorlog = sectorlog;
-	cfg.lsectorsize = lsectorsize;
-	cfg.lsectorlog = lsectorlog;
-	cfg.dirblocksize = dirblocksize;
-	cfg.dirblocklog = dirblocklog;
-	cfg.inodesize = isize;
-	cfg.inodelog = inodelog;
-	cfg.inopblock = inopblock;
-
-	cfg.dblocks = dblocks;
-	cfg.logblocks = logblocks;
-	cfg.rtblocks = rtblocks;
-	cfg.rtextblocks = rtextblocks;
-	cfg.rtextents = rtextents;
-	cfg.rtbmblocks = nbmblocks;
-	cfg.dsunit = dsunit;
-	cfg.dswidth = dswidth;
-	cfg.lsunit = lsunit;
-	cfg.agsize = agsize;
-	cfg.agcount = agcount;
-	cfg.imaxpct = imaxpct;
-	cfg.loginternal = loginternal;
-	cfg.logstart = logstart;
-	cfg.logagno = logagno;
-	cfg.label = label;
-	platform_uuid_copy(&cfg.uuid, &uuid);
-	memcpy(&cfg.sb_feat, &sb_feat, sizeof(sb_feat));
-	/* end temp support code */
-
 	if (!quiet || dry_run) {
 		print_mkfs_cfg(&cfg, dfile, logfile, rtfile);
 		if (dry_run)
@@ -3996,7 +3879,7 @@ main(
 	/*
 	 * Allocate the root inode and anything else in the proto file.
 	 */
-	parse_proto(mp, &fsx, &protostring);
+	parse_proto(mp, &cli.fsx, &protostring);
 
 	/*
 	 * Protect ourselves against possible stupidity
-- 
2.13.3

