Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:45196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752139AbdCCXOY (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 3 Mar 2017 18:14:24 -0500
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: [PATCH 2/9] mkfs.xfs: move dopts to struct mkfs_xfs_opts
Date: Fri,  3 Mar 2017 15:13:09 -0800
Message-Id: <20170303231316.12716-3-mcgrof@kernel.org>
In-Reply-To: <20170303231316.12716-1-mcgrof@kernel.org>
References: <20170303231316.12716-1-mcgrof@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@sandeen.net, linux-xfs@vger.kernel.org
Cc: jack@suse.com, jeffm@suse.com, okurz@suse.com, lpechacek@suse.com, "Luis R. Rodriguez" <mcgrof@kernel.org>

Following the logic, move all dopts into struct mkfs_xfs_opts to
enable re-parsing / resetting of the variables more easily later.

Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
---
 mkfs/xfs_mkfs.c | 616 ++++++++++++++++++++++++++++++--------------------------
 1 file changed, 325 insertions(+), 291 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 7ca972ee9675..868cab2164d6 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -712,6 +712,22 @@ struct mkfs_xfs_opts {
 	int			blocklog;
 	int			blflag;
 	int			bsflag;
+
+	struct fsxattr		fsx;
+	libxfs_init_t		xi;
+	__uint64_t		agcount;
+	__uint64_t		agsize;
+	int			daflag;
+	int			ssflag;
+	int			dasize;
+	char			*dsize;
+	int			dsunit;
+	int			dswidth;
+	int			dsu;
+	int			dsw;
+	int			nodsflag;
+	int			sectorlog;
+	int			slflag;
 };
 
 #define TERABYTES(count, blog)	((__uint64_t)(count) << (40 - (blog)))
@@ -1406,6 +1422,7 @@ parse_subopts(
 	struct mkfs_xfs_opts *params)
 {
 	char	*value;
+	int c;
 
 	switch (type) {
 	case 'b':
@@ -1426,6 +1443,81 @@ parse_subopts(
 			}
 		}
 		break;
+	case 'd':
+		while (*p != '\0') {
+			switch (getsubopt(&p, (char **)dopts.subopts, &value)) {
+			case D_AGCOUNT:
+				params->agcount = getnum(value, &dopts,
+							 D_AGCOUNT);
+				params->daflag = 1;
+				break;
+			case D_AGSIZE:
+				params->agsize = getnum(value, &dopts, D_AGSIZE);
+				params->dasize = 1;
+				break;
+			case D_FILE:
+				params->xi.disfile = getnum(value, &dopts,
+						    D_FILE);
+				break;
+			case D_NAME:
+				params->xi.dname = getstr(value, &dopts, D_NAME);
+				break;
+			case D_SIZE:
+				params->dsize = getstr(value, &dopts, D_SIZE);
+				break;
+			case D_SUNIT:
+				params->dsunit = getnum(value, &dopts, D_SUNIT);
+				break;
+			case D_SWIDTH:
+				params->dswidth = getnum(value, &dopts,
+							 D_SWIDTH);
+				break;
+			case D_SU:
+				params->dsu = getnum(value, &dopts, D_SU);
+				break;
+			case D_SW:
+				params->dsw = getnum(value, &dopts, D_SW);
+				break;
+			case D_NOALIGN:
+				params->nodsflag = getnum(value, &dopts,
+							  D_NOALIGN);
+				break;
+			case D_SECTLOG:
+				params->sectorlog = getnum(value, &dopts,
+							   D_SECTLOG);
+				sectorsize = 1 << params->sectorlog;
+				params->slflag = 1;
+				break;
+			case D_SECTSIZE:
+				sectorsize = getnum(value, &dopts,
+						    D_SECTSIZE);
+				params->sectorlog =
+					libxfs_highbit32(sectorsize);
+				params->ssflag = 1;
+				break;
+			case D_RTINHERIT:
+				c = getnum(value, &dopts, D_RTINHERIT);
+				if (c)
+					params->fsx.fsx_xflags |=
+						XFS_DIFLAG_RTINHERIT;
+				break;
+			case D_PROJINHERIT:
+				params->fsx.fsx_projid = getnum(value, &dopts,
+							D_PROJINHERIT);
+				params->fsx.fsx_xflags |=
+					XFS_DIFLAG_PROJINHERIT;
+				break;
+			case D_EXTSZINHERIT:
+				params->fsx.fsx_extsize = getnum(value, &dopts,
+							 D_EXTSZINHERIT);
+				params->fsx.fsx_xflags |=
+					XFS_DIFLAG_EXTSZINHERIT;
+				break;
+			default:
+				unknown('d', value);
+			}
+		}
+		break;
 	default:
 		usage();
 	}
@@ -1436,29 +1528,19 @@ main(
 	int			argc,
 	char			**argv)
 {
-	__uint64_t		agcount;
 	xfs_agf_t		*agf;
 	xfs_agi_t		*agi;
 	xfs_agnumber_t		agno;
-	__uint64_t		agsize;
 	xfs_alloc_rec_t		*arec;
 	struct xfs_btree_block	*block;
 	int			bsize;
 	xfs_buf_t		*buf;
 	int			c;
-	int			daflag;
-	int			dasize;
 	xfs_rfsblock_t		dblocks;
 	char			*dfile;
 	int			dirblocklog;
 	int			dirblocksize;
-	char			*dsize;
-	int			dsu;
-	int			dsw;
-	int			dsunit;
-	int			dswidth;
 	int			force_overwrite;
-	struct fsxattr		fsx;
 	int			ilflag;
 	int			imaxpct;
 	int			imflag;
@@ -1493,7 +1575,6 @@ main(
 	xfs_mount_t		mbuf;
 	xfs_extlen_t		nbmblocks;
 	int			nlflag;
-	int			nodsflag;
 	int			norsflag;
 	xfs_alloc_rec_t		*nrec;
 	int			nsflag;
@@ -1511,14 +1592,10 @@ main(
 	char			*rtfile;
 	char			*rtsize;
 	xfs_sb_t		*sbp;
-	int			sectorlog;
 	__uint64_t		sector_mask;
-	int			slflag;
-	int			ssflag;
 	__uint64_t		tmp_agsize;
 	uuid_t			uuid;
 	int			worst_freelist;
-	libxfs_init_t		xi;
 	struct fs_topology	ft;
 	struct sb_feat_args	sb_feat = {
 		.finobt = 1,
@@ -1546,11 +1623,11 @@ main(
 	bindtextdomain(PACKAGE, LOCALEDIR);
 	textdomain(PACKAGE);
 
-	slflag = ssflag = lslflag = lssflag = 0;
+	lslflag = lssflag = 0;
 	blocksize = 0;
-	sectorlog = lsectorlog = 0;
+	lsectorlog = 0;
 	sectorsize = lsectorsize = 0;
-	agsize = daflag = dasize = dblocks = 0;
+	dblocks = 0;
 	ilflag = imflag = ipflag = isflag = 0;
 	liflag = laflag = lsflag = lsuflag = lsunitflag = ldflag = lvflag = 0;
 	loginternal = 1;
@@ -1560,16 +1637,14 @@ main(
 	qflag = 0;
 	imaxpct = inodelog = inopblock = isize = 0;
 	dfile = logfile = rtfile = NULL;
-	dsize = logsize = rtsize = rtextsize = protofile = NULL;
-	dsu = dsw = dsunit = dswidth = lalign = lsu = lsunit = 0;
-	nodsflag = norsflag = 0;
+	logsize = rtsize = rtextsize = protofile = NULL;
+	lalign = lsu = lsunit = 0;
+	norsflag = 0;
 	force_overwrite = 0;
 	worst_freelist = 0;
-	memset(&fsx, 0, sizeof(fsx));
 
-	memset(&xi, 0, sizeof(xi));
-	xi.isdirect = LIBXFS_DIRECT;
-	xi.isreadonly = LIBXFS_EXCLUSIVELY;
+	params.xi.isdirect = LIBXFS_DIRECT;
+	params.xi.isreadonly = LIBXFS_EXCLUSIVELY;
 
 	while ((c = getopt(argc, argv, "b:d:i:l:L:m:n:KNp:qr:s:CfV")) != EOF) {
 		switch (c) {
@@ -1578,87 +1653,9 @@ main(
 			force_overwrite = 1;
 			break;
 		case 'b':
-			p = optarg;
-			parse_subopts(c, p, &params);
-			break;
 		case 'd':
 			p = optarg;
-			while (*p != '\0') {
-				char	**subopts = (char **)dopts.subopts;
-				char	*value;
-
-				switch (getsubopt(&p, subopts, &value)) {
-				case D_AGCOUNT:
-					agcount = getnum(value, &dopts,
-							 D_AGCOUNT);
-					daflag = 1;
-					break;
-				case D_AGSIZE:
-					agsize = getnum(value, &dopts, D_AGSIZE);
-					dasize = 1;
-					break;
-				case D_FILE:
-					xi.disfile = getnum(value, &dopts,
-							    D_FILE);
-					break;
-				case D_NAME:
-					xi.dname = getstr(value, &dopts, D_NAME);
-					break;
-				case D_SIZE:
-					dsize = getstr(value, &dopts, D_SIZE);
-					break;
-				case D_SUNIT:
-					dsunit = getnum(value, &dopts, D_SUNIT);
-					break;
-				case D_SWIDTH:
-					dswidth = getnum(value, &dopts,
-							 D_SWIDTH);
-					break;
-				case D_SU:
-					dsu = getnum(value, &dopts, D_SU);
-					break;
-				case D_SW:
-					dsw = getnum(value, &dopts, D_SW);
-					break;
-				case D_NOALIGN:
-					nodsflag = getnum(value, &dopts,
-								D_NOALIGN);
-					break;
-				case D_SECTLOG:
-					sectorlog = getnum(value, &dopts,
-							   D_SECTLOG);
-					sectorsize = 1 << sectorlog;
-					slflag = 1;
-					break;
-				case D_SECTSIZE:
-					sectorsize = getnum(value, &dopts,
-							    D_SECTSIZE);
-					sectorlog =
-						libxfs_highbit32(sectorsize);
-					ssflag = 1;
-					break;
-				case D_RTINHERIT:
-					c = getnum(value, &dopts, D_RTINHERIT);
-					if (c)
-						fsx.fsx_xflags |=
-							XFS_DIFLAG_RTINHERIT;
-					break;
-				case D_PROJINHERIT:
-					fsx.fsx_projid = getnum(value, &dopts,
-								D_PROJINHERIT);
-					fsx.fsx_xflags |=
-						XFS_DIFLAG_PROJINHERIT;
-					break;
-				case D_EXTSZINHERIT:
-					fsx.fsx_extsize = getnum(value, &dopts,
-								 D_EXTSZINHERIT);
-					fsx.fsx_xflags |=
-						XFS_DIFLAG_EXTSZINHERIT;
-					break;
-				default:
-					unknown('d', value);
-				}
-			}
+			parse_subopts(c, p, &params);
 			break;
 		case 'i':
 			p = optarg;
@@ -1721,7 +1718,7 @@ main(
 					laflag = 1;
 					break;
 				case L_FILE:
-					xi.lisfile = getnum(value, &lopts,
+					params.xi.lisfile = getnum(value, &lopts,
 							    L_FILE);
 					break;
 				case L_INTERNAL:
@@ -1740,7 +1737,7 @@ main(
 				case L_NAME:
 				case L_DEV:
 					logfile = getstr(value, &lopts, L_NAME);
-					xi.logname = logfile;
+					params.xi.logname = logfile;
 					ldflag = 1;
 					loginternal = 0;
 					break;
@@ -1883,12 +1880,12 @@ main(
 							   R_EXTSIZE);
 					break;
 				case R_FILE:
-					xi.risfile = getnum(value, &ropts,
+					params.xi.risfile = getnum(value, &ropts,
 							    R_FILE);
 					break;
 				case R_NAME:
 				case R_DEV:
-					xi.rtname = getstr(value, &ropts,
+					params.xi.rtname = getstr(value, &ropts,
 							   R_NAME);
 					break;
 				case R_SIZE:
@@ -1915,12 +1912,12 @@ main(
 					if (lssflag)
 						conflict('s', subopts,
 							 S_SECTSIZE, S_SECTLOG);
-					sectorlog = getnum(value, &sopts,
+					params.sectorlog = getnum(value, &sopts,
 							   S_SECTLOG);
-					lsectorlog = sectorlog;
-					sectorsize = 1 << sectorlog;
+					lsectorlog = params.sectorlog;
+					sectorsize = 1 << params.sectorlog;
 					lsectorsize = sectorsize;
-					lslflag = slflag = 1;
+					lslflag = params.slflag = 1;
 					break;
 				case S_SIZE:
 				case S_SECTSIZE:
@@ -1930,10 +1927,10 @@ main(
 					sectorsize = getnum(value, &sopts,
 							    S_SECTSIZE);
 					lsectorsize = sectorsize;
-					sectorlog =
+					params.sectorlog =
 						libxfs_highbit32(sectorsize);
-					lsectorlog = sectorlog;
-					lssflag = ssflag = 1;
+					lsectorlog = params.sectorlog;
+					lssflag = params.ssflag = 1;
 					break;
 				default:
 					unknown('s', value);
@@ -1951,9 +1948,10 @@ main(
 		fprintf(stderr, _("extra arguments\n"));
 		usage();
 	} else if (argc - optind == 1) {
-		dfile = xi.volname = getstr(argv[optind], &dopts, D_NAME);
+		dfile = params.xi.volname =
+			getstr(argv[optind], &dopts, D_NAME);
 	} else
-		dfile = xi.dname;
+		dfile = params.xi.dname;
 
 	/*
 	 * Blocksize and sectorsize first, other things depend on them
@@ -1979,12 +1977,12 @@ _("Minimum block size for CRC enabled filesystems is %d bytes.\n"),
 		usage();
 	}
 
-	if (!slflag && !ssflag) {
-		sectorlog = XFS_MIN_SECTORSIZE_LOG;
+	if (!params.slflag && !params.ssflag) {
+		params.sectorlog = XFS_MIN_SECTORSIZE_LOG;
 		sectorsize = XFS_MIN_SECTORSIZE;
 	}
 	if (!lslflag && !lssflag) {
-		lsectorlog = sectorlog;
+		lsectorlog = params.sectorlog;
 		lsectorsize = sectorsize;
 	}
 
@@ -1995,23 +1993,30 @@ _("Minimum block size for CRC enabled filesystems is %d bytes.\n"),
 	 * sector size mismatches between the new filesystem and the underlying
 	 * host filesystem.
 	 */
-	check_device_type(dfile, &xi.disfile, !dsize, !dfile,
-			  Nflag ? NULL : &xi.dcreat, force_overwrite, "d");
+	check_device_type(dfile, &params.xi.disfile, !params.dsize, !dfile,
+			  Nflag ? NULL : &params.xi.dcreat,
+			  force_overwrite, "d");
 	if (!loginternal)
-		check_device_type(xi.logname, &xi.lisfile, !logsize, !xi.logname,
-				  Nflag ? NULL : &xi.lcreat,
+		check_device_type(params.xi.logname,
+				  &params.xi.lisfile,
+				  !logsize,
+				  !params.xi.logname,
+				  Nflag ? NULL : &params.xi.lcreat,
 				  force_overwrite, "l");
-	if (xi.rtname)
-		check_device_type(xi.rtname, &xi.risfile, !rtsize, !xi.rtname,
-				  Nflag ? NULL : &xi.rcreat,
+	if (params.xi.rtname)
+		check_device_type(params.xi.rtname,
+				  &params.xi.risfile,
+				  !rtsize,
+				  !params.xi.rtname,
+				  Nflag ? NULL : &params.xi.rcreat,
 				  force_overwrite, "r");
-	if (xi.disfile || xi.lisfile || xi.risfile)
-		xi.isdirect = 0;
+	if (params.xi.disfile || params.xi.lisfile || params.xi.risfile)
+		params.xi.isdirect = 0;
 
 	memset(&ft, 0, sizeof(ft));
-	get_topology(&xi, &ft, force_overwrite);
+	get_topology(&params.xi, &ft, force_overwrite);
 
-	if (!ssflag) {
+	if (!params.ssflag) {
 		/*
 		 * Unless specified manually on the command line use the
 		 * advertised sector size of the device.  We use the physical
@@ -2039,17 +2044,17 @@ _("switching to logical sector size %d\n"),
 		}
 	}
 
-	if (!ssflag) {
-		sectorlog = libxfs_highbit32(sectorsize);
+	if (!params.ssflag) {
+		params.sectorlog = libxfs_highbit32(sectorsize);
 		if (loginternal) {
 			lsectorsize = sectorsize;
-			lsectorlog = sectorlog;
+			lsectorlog = params.sectorlog;
 		}
 	}
 
 	if (sectorsize < XFS_MIN_SECTORSIZE ||
 	    sectorsize > XFS_MAX_SECTORSIZE || sectorsize > blocksize) {
-		if (ssflag)
+		if (params.ssflag)
 			fprintf(stderr, _("illegal sector size %d\n"), sectorsize);
 		else
 			fprintf(stderr,
@@ -2160,7 +2165,7 @@ _("reflink not supported without CRC support\n"));
 	}
 
 
-	if (sb_feat.rmapbt && xi.rtname) {
+	if (sb_feat.rmapbt && params.xi.rtname) {
 		fprintf(stderr,
 _("rmapbt not supported with realtime devices\n"));
 		usage();
@@ -2183,10 +2188,10 @@ _("rmapbt not supported with realtime devices\n"));
 	}
 
 
-	if (dsize) {
+	if (params.dsize) {
 		__uint64_t dbytes;
 
-		dbytes = getnum(dsize, &dopts, D_SIZE);
+		dbytes = getnum(params.dsize, &dopts, D_SIZE);
 		if (dbytes % XFS_MIN_BLOCKSIZE) {
 			fprintf(stderr,
 			_("illegal data length %lld, not a multiple of %d\n"),
@@ -2272,7 +2277,8 @@ _("rmapbt not supported with realtime devices\n"));
 		__uint64_t	rswidth;
 		__uint64_t	rtextbytes;
 
-		if (!norsflag && !xi.risfile && !(!rtsize && xi.disfile))
+		if (!norsflag && !params.xi.risfile &&
+		    !(!rtsize && params.xi.disfile))
 			rswidth = ft.rtswidth;
 		else
 			rswidth = 0;
@@ -2322,17 +2328,17 @@ _("rmapbt not supported with realtime devices\n"));
 		sb_feat.log_version = 2;
 	}
 
-	calc_stripe_factors(dsu, dsw, sectorsize, lsu, lsectorsize,
-				&dsunit, &dswidth, &lsunit);
+	calc_stripe_factors(params.dsu, params.dsw, sectorsize, lsu, lsectorsize,
+				&params.dsunit, &params.dswidth, &lsunit);
 
-	xi.setblksize = sectorsize;
+	params.xi.setblksize = sectorsize;
 
 	/*
 	 * Initialize.  This will open the log and rt devices as well.
 	 */
-	if (!libxfs_init(&xi))
+	if (!libxfs_init(&params.xi))
 		usage();
-	if (!xi.ddev) {
+	if (!params.xi.ddev) {
 		fprintf(stderr, _("no device name given in argument list\n"));
 		usage();
 	}
@@ -2348,50 +2354,52 @@ _("rmapbt not supported with realtime devices\n"));
 	 * multiple of the sector size, or 1024, whichever is larger.
 	 */
 
-	sector_mask = (__uint64_t)-1 << (MAX(sectorlog, 10) - BBSHIFT);
-	xi.dsize &= sector_mask;
-	xi.rtsize &= sector_mask;
-	xi.logBBsize &= (__uint64_t)-1 << (MAX(lsectorlog, 10) - BBSHIFT);
+	sector_mask = (__uint64_t)-1 << (MAX(params.sectorlog, 10) - BBSHIFT);
+	params.xi.dsize &= sector_mask;
+	params.xi.rtsize &= sector_mask;
+	params.xi.logBBsize &= (__uint64_t)-1 << (MAX(lsectorlog, 10) - BBSHIFT);
 
 
 	/* don't do discards on print-only runs or on files */
 	if (discard && !Nflag) {
-		if (!xi.disfile)
-			discard_blocks(xi.ddev, xi.dsize);
-		if (xi.rtdev && !xi.risfile)
-			discard_blocks(xi.rtdev, xi.rtsize);
-		if (xi.logdev && xi.logdev != xi.ddev && !xi.lisfile)
-			discard_blocks(xi.logdev, xi.logBBsize);
+		if (!params.xi.disfile)
+			discard_blocks(params.xi.ddev, params.xi.dsize);
+		if (params.xi.rtdev && !params.xi.risfile)
+			discard_blocks(params.xi.rtdev, params.xi.rtsize);
+		if (params.xi.logdev && params.xi.logdev != params.xi.ddev &&
+		    !params.xi.lisfile)
+			discard_blocks(params.xi.logdev, params.xi.logBBsize);
 	}
 
 	if (!liflag && !ldflag)
-		loginternal = xi.logdev == 0;
-	if (xi.logname)
-		logfile = xi.logname;
+		loginternal = params.xi.logdev == 0;
+	if (params.xi.logname)
+		logfile = params.xi.logname;
 	else if (loginternal)
 		logfile = _("internal log");
-	else if (xi.volname && xi.logdev)
+	else if (params.xi.volname && params.xi.logdev)
 		logfile = _("volume log");
 	else if (!ldflag) {
 		fprintf(stderr, _("no log subvolume or internal log\n"));
 		usage();
 	}
-	if (xi.rtname)
-		rtfile = xi.rtname;
+	if (params.xi.rtname)
+		rtfile = params.xi.rtname;
 	else
-	if (xi.volname && xi.rtdev)
+	if (params.xi.volname && params.xi.rtdev)
 		rtfile = _("volume rt");
-	else if (!xi.rtdev)
+	else if (!params.xi.rtdev)
 		rtfile = _("none");
-	if (dsize && xi.dsize > 0 && dblocks > DTOBT(xi.dsize)) {
+	if (params.dsize && params.xi.dsize > 0 &&
+	    dblocks > DTOBT(params.xi.dsize)) {
 		fprintf(stderr,
 			_("size %s specified for data subvolume is too large, "
 			"maximum is %lld blocks\n"),
-			dsize, (long long)DTOBT(xi.dsize));
+			params.dsize, (long long)DTOBT(params.xi.dsize));
 		usage();
-	} else if (!dsize && xi.dsize > 0)
-		dblocks = DTOBT(xi.dsize);
-	else if (!dsize) {
+	} else if (!params.dsize && params.xi.dsize > 0)
+		dblocks = DTOBT(params.xi.dsize);
+	else if (!params.dsize) {
 		fprintf(stderr, _("can't get size of data subvolume\n"));
 		usage();
 	}
@@ -2402,7 +2410,7 @@ _("rmapbt not supported with realtime devices\n"));
 		usage();
 	}
 
-	if (loginternal && xi.logdev) {
+	if (loginternal && params.xi.logdev) {
 		fprintf(stderr,
 			_("can't have both external and internal logs\n"));
 		usage();
@@ -2412,39 +2420,39 @@ _("rmapbt not supported with realtime devices\n"));
 		usage();
 	}
 
-	if (xi.dbsize > sectorsize) {
+	if (params.xi.dbsize > sectorsize) {
 		fprintf(stderr, _(
 "Warning: the data subvolume sector size %u is less than the sector size \n\
 reported by the device (%u).\n"),
-			sectorsize, xi.dbsize);
+			sectorsize, params.xi.dbsize);
 	}
-	if (!loginternal && xi.lbsize > lsectorsize) {
+	if (!loginternal && params.xi.lbsize > lsectorsize) {
 		fprintf(stderr, _(
 "Warning: the log subvolume sector size %u is less than the sector size\n\
 reported by the device (%u).\n"),
-			lsectorsize, xi.lbsize);
+			lsectorsize, params.xi.lbsize);
 	}
-	if (rtsize && xi.rtsize > 0 && xi.rtbsize > sectorsize) {
+	if (rtsize && params.xi.rtsize > 0 && params.xi.rtbsize > sectorsize) {
 		fprintf(stderr, _(
 "Warning: the realtime subvolume sector size %u is less than the sector size\n\
 reported by the device (%u).\n"),
-			sectorsize, xi.rtbsize);
+			sectorsize, params.xi.rtbsize);
 	}
 
-	if (rtsize && xi.rtsize > 0 && rtblocks > DTOBT(xi.rtsize)) {
+	if (rtsize && params.xi.rtsize > 0 && rtblocks > DTOBT(params.xi.rtsize)) {
 		fprintf(stderr,
 			_("size %s specified for rt subvolume is too large, "
 			"maximum is %lld blocks\n"),
-			rtsize, (long long)DTOBT(xi.rtsize));
+			rtsize, (long long)DTOBT(params.xi.rtsize));
 		usage();
-	} else if (!rtsize && xi.rtsize > 0)
-		rtblocks = DTOBT(xi.rtsize);
-	else if (rtsize && !xi.rtdev) {
+	} else if (!rtsize && params.xi.rtsize > 0)
+		rtblocks = DTOBT(params.xi.rtsize);
+	else if (rtsize && !params.xi.rtdev) {
 		fprintf(stderr,
 			_("size specified for non-existent rt subvolume\n"));
 		usage();
 	}
-	if (xi.rtdev) {
+	if (params.xi.rtdev) {
 		rtextents = rtblocks / rtextblocks;
 		nbmblocks = (xfs_extlen_t)howmany(rtextents, NBBY * blocksize);
 	} else {
@@ -2452,145 +2460,158 @@ reported by the device (%u).\n"),
 		nbmblocks = 0;
 	}
 
-	if (!nodsflag) {
-		if (dsunit) {
-			if (ft.dsunit && ft.dsunit != dsunit) {
+	if (!params.nodsflag) {
+		if (params.dsunit) {
+			if (ft.dsunit && ft.dsunit != params.dsunit) {
 				fprintf(stderr,
 					_("%s: Specified data stripe unit %d "
 					"is not the same as the volume stripe "
 					"unit %d\n"),
-					progname, dsunit, ft.dsunit);
+					progname, params.dsunit, ft.dsunit);
 			}
-			if (ft.dswidth && ft.dswidth != dswidth) {
+			if (ft.dswidth && ft.dswidth != params.dswidth) {
 				fprintf(stderr,
 					_("%s: Specified data stripe width %d "
 					"is not the same as the volume stripe "
 					"width %d\n"),
-					progname, dswidth, ft.dswidth);
+					progname, params.dswidth, ft.dswidth);
 			}
 		} else {
-			dsunit = ft.dsunit;
-			dswidth = ft.dswidth;
-			nodsflag = 1;
+			params.dsunit = ft.dsunit;
+			params.dswidth = ft.dswidth;
+			params.nodsflag = 1;
 		}
-	} /* else dsunit & dswidth can't be set if nodsflag is set */
+	} /* else dsunit & dswidth can't be set if params.nodsflag is set */
 
-	if (dasize) {		/* User-specified AG size */
+	if (params.dasize) {		/* User-specified AG size */
 		/*
 		 * Check specified agsize is a multiple of blocksize.
 		 */
-		if (agsize % blocksize) {
+		if (params.agsize % blocksize) {
 			fprintf(stderr,
 		_("agsize (%lld) not a multiple of fs blk size (%d)\n"),
-				(long long)agsize, blocksize);
+				(long long)params.agsize, blocksize);
 			usage();
 		}
-		agsize /= blocksize;
-		agcount = dblocks / agsize + (dblocks % agsize != 0);
+		params.agsize /= blocksize;
+		params.agcount = dblocks / params.agsize +
+			(dblocks % params.agsize != 0);
 
-	} else if (daflag) {	/* User-specified AG count */
-		agsize = dblocks / agcount + (dblocks % agcount != 0);
+	} else if (params.daflag) {	/* User-specified AG count */
+		params.agsize = dblocks / params.agcount +
+			(dblocks % params.agcount != 0);
 	} else {
-		calc_default_ag_geometry(params.blocklog, dblocks,
-				dsunit | dswidth, &agsize, &agcount);
+		calc_default_ag_geometry(params.blocklog,
+					 dblocks,
+					 params.dsunit | params.dswidth,
+					 &params.agsize,
+					 &params.agcount);
 	}
 
 	/*
 	 * If dsunit is a multiple of fs blocksize, then check that is a
 	 * multiple of the agsize too
 	 */
-	if (dsunit && !(BBTOB(dsunit) % blocksize) &&
-	    dswidth && !(BBTOB(dswidth) % blocksize)) {
+	if (params.dsunit && !(BBTOB(params.dsunit) % blocksize) &&
+	    params.dswidth && !(BBTOB(params.dswidth) % blocksize)) {
 
 		/* convert from 512 byte blocks to fs blocksize */
-		dsunit = DTOBT(dsunit);
-		dswidth = DTOBT(dswidth);
+		params.dsunit = DTOBT(params.dsunit);
+		params.dswidth = DTOBT(params.dswidth);
 
 		/*
 		 * agsize is not a multiple of dsunit
 		 */
-		if ((agsize % dsunit) != 0) {
+		if ((params.agsize % params.dsunit) != 0) {
 			/*
 			 * Round up to stripe unit boundary. Also make sure
 			 * that agsize is still larger than
 			 * XFS_AG_MIN_BLOCKS(params.blocklog)
 		 	 */
-			tmp_agsize = ((agsize + (dsunit - 1))/ dsunit) * dsunit;
+			tmp_agsize = ((params.agsize +
+				       (params.dsunit - 1)) /
+					params.dsunit) * params.dsunit;
 			/*
 			 * Round down to stripe unit boundary if rounding up
 			 * created an AG size that is larger than the AG max.
 			 */
 			if (tmp_agsize > XFS_AG_MAX_BLOCKS(params.blocklog))
-				tmp_agsize = ((agsize) / dsunit) * dsunit;
+				tmp_agsize = ((params.agsize) / params.dsunit)
+					* params.dsunit;
 
 			if ((tmp_agsize >= XFS_AG_MIN_BLOCKS(params.blocklog)) &&
 			    (tmp_agsize <= XFS_AG_MAX_BLOCKS(params.blocklog))) {
-				agsize = tmp_agsize;
-				if (!daflag)
-					agcount = dblocks/agsize +
-						(dblocks % agsize != 0);
-				if (dasize)
+				params.agsize = tmp_agsize;
+				if (!params.daflag)
+					params.agcount = dblocks/params.agsize +
+						(dblocks % params.agsize != 0);
+				if (params.dasize)
 					fprintf(stderr,
 				_("agsize rounded to %lld, swidth = %d\n"),
-						(long long)agsize, dswidth);
+						(long long)params.agsize,
+						params.dswidth);
 			} else {
-				if (nodsflag) {
-					dsunit = dswidth = 0;
+				if (params.nodsflag) {
+					params.dsunit = params.dswidth = 0;
 				} else {
 					/*
 					 * agsize is out of bounds, this will
 					 * print nice details & exit.
 					 */
 					validate_ag_geometry(params.blocklog, dblocks,
-							    agsize, agcount);
+							    params.agsize, params.agcount);
 					exit(1);
 				}
 			}
 		}
-		if (dswidth && ((agsize % dswidth) == 0) && (agcount > 1)) {
+		if (params.dswidth &&
+		    ((params.agsize % params.dswidth) == 0) &&
+		    (params.agcount > 1)) {
 			/* This is a non-optimal configuration because all AGs
 			 * start on the same disk in the stripe.  Changing
 			 * the AG size by one sunit will guarantee that this
 			 * does not happen.
 			 */
-			tmp_agsize = agsize - dsunit;
+			tmp_agsize = params.agsize - params.dsunit;
 			if (tmp_agsize < XFS_AG_MIN_BLOCKS(params.blocklog)) {
-				tmp_agsize = agsize + dsunit;
-				if (dblocks < agsize) {
+				tmp_agsize = params.agsize + params.dsunit;
+				if (dblocks < params.agsize) {
 					/* oh well, nothing to do */
-					tmp_agsize = agsize;
+					tmp_agsize = params.agsize;
 				}
 			}
-			if (daflag || dasize) {
+			if (params.daflag || params.dasize) {
 				fprintf(stderr, _(
 "Warning: AG size is a multiple of stripe width.  This can cause performance\n\
 problems by aligning all AGs on the same disk.  To avoid this, run mkfs with\n\
 an AG size that is one stripe unit smaller, for example %llu.\n"),
 					(unsigned long long)tmp_agsize);
 			} else {
-				agsize = tmp_agsize;
-				agcount = dblocks/agsize + (dblocks % agsize != 0);
+				params.agsize = tmp_agsize;
+				params.agcount = dblocks/params.agsize +
+					(dblocks % params.agsize != 0);
 				/*
 				 * If the last AG is too small, reduce the
 				 * filesystem size and drop the blocks.
 				 */
-				if ( dblocks % agsize != 0 &&
-				    (dblocks % agsize <
+				if ( dblocks % params.agsize != 0 &&
+				    (dblocks % params.agsize <
 				    XFS_AG_MIN_BLOCKS(params.blocklog))) {
-					dblocks = (xfs_rfsblock_t)((agcount - 1) * agsize);
-					agcount--;
-					ASSERT(agcount != 0);
+					dblocks = (xfs_rfsblock_t)
+						((params.agcount - 1) * params.agsize);
+					params.agcount--;
+					ASSERT(params.agcount != 0);
 				}
 			}
 		}
 	} else {
-		if (nodsflag)
-			dsunit = dswidth = 0;
+		if (params.nodsflag)
+			params.dsunit = params.dswidth = 0;
 		else {
 			fprintf(stderr,
 				_("%s: Stripe unit(%d) or stripe width(%d) is "
 				"not a multiple of the block size(%d)\n"),
-				progname, BBTOB(dsunit), BBTOB(dswidth),
+				progname, BBTOB(params.dsunit), BBTOB(params.dswidth),
 				blocksize);
 			exit(1);
 		}
@@ -2600,15 +2621,15 @@ an AG size that is one stripe unit smaller, for example %llu.\n"),
 	 * If the last AG is too small, reduce the filesystem size
 	 * and drop the blocks.
 	 */
-	if ( dblocks % agsize != 0 &&
-	     (dblocks % agsize < XFS_AG_MIN_BLOCKS(params.blocklog))) {
-		ASSERT(!daflag);
-		dblocks = (xfs_rfsblock_t)((agcount - 1) * agsize);
-		agcount--;
-		ASSERT(agcount != 0);
+	if ( dblocks % params.agsize != 0 &&
+	     (dblocks % params.agsize < XFS_AG_MIN_BLOCKS(params.blocklog))) {
+		ASSERT(!params.daflag);
+		dblocks = (xfs_rfsblock_t)((params.agcount - 1) * params.agsize);
+		params.agcount--;
+		ASSERT(params.agcount != 0);
 	}
 
-	validate_ag_geometry(params.blocklog, dblocks, agsize, agcount);
+	validate_ag_geometry(params.blocklog, dblocks, params.agsize, params.agcount);
 
 	if (!imflag)
 		imaxpct = calc_default_imaxpct(params.blocklog, dblocks);
@@ -2620,9 +2641,9 @@ an AG size that is one stripe unit smaller, for example %llu.\n"),
 	if (lsunit) {
 		/* convert from 512 byte blocks to fs blocks */
 		lsunit = DTOBT(lsunit);
-	} else if (sb_feat.log_version == 2 && loginternal && dsunit) {
+	} else if (sb_feat.log_version == 2 && loginternal && params.dsunit) {
 		/* lsunit and dsunit now in fs blocks */
-		lsunit = dsunit;
+		lsunit = params.dsunit;
 	}
 
 	if (sb_feat.log_version == 2 && (lsunit * blocksize) > 256 * 1024) {
@@ -2637,23 +2658,25 @@ an AG size that is one stripe unit smaller, for example %llu.\n"),
 		lsunit = (32 * 1024) >> params.blocklog;
 	}
 
-	min_logblocks = max_trans_res(agsize,
+	min_logblocks = max_trans_res(params.agsize,
 				   sb_feat.crcs_enabled, sb_feat.dir_version,
-				   sectorlog, params.blocklog, inodelog, dirblocklog,
+				   params.sectorlog, params.blocklog,
+				   inodelog, dirblocklog,
 				   sb_feat.log_version, lsunit, sb_feat.finobt,
 				   sb_feat.rmapbt, sb_feat.reflink);
 	ASSERT(min_logblocks);
 	min_logblocks = MAX(XFS_MIN_LOG_BLOCKS, min_logblocks);
 	if (!logsize && dblocks >= (1024*1024*1024) >> params.blocklog)
 		min_logblocks = MAX(min_logblocks, XFS_MIN_LOG_BYTES>>params.blocklog);
-	if (logsize && xi.logBBsize > 0 && logblocks > DTOBT(xi.logBBsize)) {
+	if (logsize && params.xi.logBBsize > 0 &&
+	    logblocks > DTOBT(params.xi.logBBsize)) {
 		fprintf(stderr,
 _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
-			logsize, (long long)DTOBT(xi.logBBsize));
+			logsize, (long long)DTOBT(params.xi.logBBsize));
 		usage();
-	} else if (!logsize && xi.logBBsize > 0) {
-		logblocks = DTOBT(xi.logBBsize);
-	} else if (logsize && !xi.logdev && !loginternal) {
+	} else if (!logsize && params.xi.logBBsize > 0) {
+		logblocks = DTOBT(params.xi.logBBsize);
+	} else if (logsize && !params.xi.logdev && !loginternal) {
 		fprintf(stderr,
 			_("size specified for non-existent log subvolume\n"));
 		usage();
@@ -2661,7 +2684,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 		fprintf(stderr, _("size %lld too large for internal log\n"),
 			(long long)logblocks);
 		usage();
-	} else if (!loginternal && !xi.logdev) {
+	} else if (!loginternal && !params.xi.logdev) {
 		logblocks = 0;
 	} else if (loginternal && !logsize) {
 
@@ -2692,7 +2715,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 		logblocks = MAX(min_logblocks, logblocks);
 
 		/* make sure the log fits wholly within an AG */
-		if (logblocks >= agsize)
+		if (logblocks >= params.agsize)
 			logblocks = min_logblocks;
 
 		/* and now clamp the size to the maximum supported size */
@@ -2709,9 +2732,10 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 	sbp = &mp->m_sb;
 	memset(mp, 0, sizeof(xfs_mount_t));
 	sbp->sb_blocklog = (__uint8_t)params.blocklog;
-	sbp->sb_sectlog = (__uint8_t)sectorlog;
-	sbp->sb_agblklog = (__uint8_t)libxfs_log2_roundup((unsigned int)agsize);
-	sbp->sb_agblocks = (xfs_agblock_t)agsize;
+	sbp->sb_sectlog = (__uint8_t)params.sectorlog;
+	sbp->sb_agblklog =
+		(__uint8_t)libxfs_log2_roundup((unsigned int)params.agsize);
+	sbp->sb_agblocks = (xfs_agblock_t)params.agsize;
 	mp->m_blkbb_log = sbp->sb_blocklog - BBSHIFT;
 	mp->m_sectbb_log = sbp->sb_sectlog - BBSHIFT;
 
@@ -2719,7 +2743,8 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 	 * sb_versionnum, finobt and rmapbt flags must be set before we use
 	 * libxfs_prealloc_blocks().
 	 */
-	sb_set_features(&mp->m_sb, &sb_feat, sectorsize, lsectorsize, dsunit);
+	sb_set_features(&mp->m_sb, &sb_feat, sectorsize,
+			lsectorsize, params.dsunit);
 
 
 	if (loginternal) {
@@ -2734,7 +2759,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 			/* revalidate the log size is valid if we changed it */
 			validate_log_size(logblocks, params.blocklog, min_logblocks);
 		}
-		if (logblocks > agsize - libxfs_prealloc_blocks(mp)) {
+		if (logblocks > params.agsize - libxfs_prealloc_blocks(mp)) {
 			fprintf(stderr,
 	_("internal log size %lld too large, must fit in allocation group\n"),
 				(long long)logblocks);
@@ -2742,14 +2767,14 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 		}
 
 		if (laflag) {
-			if (logagno >= agcount) {
+			if (logagno >= params.agcount) {
 				fprintf(stderr,
 		_("log ag number %d too large, must be less than %lld\n"),
-					logagno, (long long)agcount);
+					logagno, (long long)params.agcount);
 				usage();
 			}
 		} else
-			logagno = (xfs_agnumber_t)(agcount / 2);
+			logagno = (xfs_agnumber_t)(params.agcount / 2);
 
 		logstart = XFS_AGB_TO_FSB(mp, logagno, libxfs_prealloc_blocks(mp));
 		/*
@@ -2757,11 +2782,13 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 		 */
 		if (lsunit) {
 			logstart = fixup_internal_log_stripe(mp,
-					lsflag, logstart, agsize, lsunit,
+					lsflag, logstart, params.agsize, lsunit,
 					&logblocks, params.blocklog, &lalign);
-		} else if (dsunit) {
+		} else if (params.dsunit) {
 			logstart = fixup_internal_log_stripe(mp,
-					lsflag, logstart, agsize, dsunit,
+							     lsflag, logstart,
+							     params.agsize,
+							     params.dsunit,
 					&logblocks, params.blocklog, &lalign);
 		}
 	} else {
@@ -2783,13 +2810,14 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 		   "log      =%-22s bsize=%-6d blocks=%lld, version=%d\n"
 		   "         =%-22s sectsz=%-5u sunit=%d blks, lazy-count=%d\n"
 		   "realtime =%-22s extsz=%-6d blocks=%lld, rtextents=%lld\n"),
-			dfile, isize, (long long)agcount, (long long)agsize,
+			dfile, isize, (long long)params.agcount,
+			(long long)params.agsize,
 			"", sectorsize, sb_feat.attr_version,
 				    !sb_feat.projid16bit,
 			"", sb_feat.crcs_enabled, sb_feat.finobt, sb_feat.spinodes,
 			sb_feat.rmapbt, sb_feat.reflink,
 			"", blocksize, (long long)dblocks, imaxpct,
-			"", dsunit, dswidth,
+			"", params.dsunit, params.dswidth,
 			sb_feat.dir_version, dirblocksize, sb_feat.nci,
 				sb_feat.dirftype,
 			logfile, 1 << params.blocklog, (long long)logblocks,
@@ -2814,13 +2842,13 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 	sbp->sb_logstart = logstart;
 	sbp->sb_rootino = sbp->sb_rbmino = sbp->sb_rsumino = NULLFSINO;
 	sbp->sb_rextsize = rtextblocks;
-	sbp->sb_agcount = (xfs_agnumber_t)agcount;
+	sbp->sb_agcount = (xfs_agnumber_t)params.agcount;
 	sbp->sb_rbmblocks = nbmblocks;
 	sbp->sb_logblocks = (xfs_extlen_t)logblocks;
 	sbp->sb_sectsize = (__uint16_t)sectorsize;
 	sbp->sb_inodesize = (__uint16_t)isize;
 	sbp->sb_inopblock = (__uint16_t)(blocksize / isize);
-	sbp->sb_sectlog = (__uint8_t)sectorlog;
+	sbp->sb_sectlog = (__uint8_t)params.sectorlog;
 	sbp->sb_inodelog = (__uint8_t)inodelog;
 	sbp->sb_inopblog = (__uint8_t)(params.blocklog - inodelog);
 	sbp->sb_rextslog =
@@ -2830,13 +2858,13 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 	sbp->sb_imax_pct = imaxpct;
 	sbp->sb_icount = 0;
 	sbp->sb_ifree = 0;
-	sbp->sb_fdblocks = dblocks - agcount * libxfs_prealloc_blocks(mp) -
+	sbp->sb_fdblocks = dblocks - params.agcount * libxfs_prealloc_blocks(mp) -
 		(loginternal ? logblocks : 0);
 	sbp->sb_frextents = 0;	/* will do a free later */
 	sbp->sb_uquotino = sbp->sb_gquotino = sbp->sb_pquotino = 0;
 	sbp->sb_qflags = 0;
-	sbp->sb_unit = dsunit;
-	sbp->sb_width = dswidth;
+	sbp->sb_unit = params.dsunit;
+	sbp->sb_width = params.dswidth;
 	sbp->sb_dirblklog = dirblocklog - params.blocklog;
 	if (sb_feat.log_version == 2) {	/* This is stored in bytes */
 		lsunit = (lsunit == 0) ? 1 : XFS_FSB_TO_B(mp, lsunit);
@@ -2859,10 +2887,11 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 		sbp->sb_logsectsize = 0;
 	}
 
-	sb_set_features(&mp->m_sb, &sb_feat, sectorsize, lsectorsize, dsunit);
+	sb_set_features(&mp->m_sb, &sb_feat, sectorsize,
+			lsectorsize, params.dsunit);
 
 	if (force_overwrite)
-		zero_old_xfs_structures(&xi, sbp);
+		zero_old_xfs_structures(&params.xi, sbp);
 
 	/*
 	 * Zero out the beginning of the device, to obliterate any old
@@ -2870,7 +2899,8 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 	 * swap (somewhere around the page size), jfs (32k),
 	 * ext[2,3] and reiserfs (64k) - and hopefully all else.
 	 */
-	libxfs_buftarg_init(mp, xi.ddev, xi.logdev, xi.rtdev);
+	libxfs_buftarg_init(mp, params.xi.ddev, params.xi.logdev,
+			    params.xi.rtdev);
 	buf = libxfs_getbuf(mp->m_ddev_targp, 0, BTOBB(WHACK_SIZE));
 	memset(XFS_BUF_PTR(buf), 0, WHACK_SIZE);
 	libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
@@ -2889,8 +2919,9 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 	 * if needed so that the reads for the end of the device in the mount
 	 * code will succeed.
 	 */
-	if (xi.disfile && xi.dsize * xi.dbsize < dblocks * blocksize) {
-		if (ftruncate(xi.dfd, dblocks * blocksize) < 0) {
+	if (params.xi.disfile &&
+	    params.xi.dsize * params.xi.dbsize < dblocks * blocksize) {
+		if (ftruncate(params.xi.dfd, dblocks * blocksize) < 0) {
 			fprintf(stderr,
 				_("%s: Growing the data section failed\n"),
 				progname);
@@ -2903,9 +2934,9 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 	 * old MD RAID (or other) metadata at the end of the device.
 	 * (MD sb is ~64k from the end, take out a wider swath to be sure)
 	 */
-	if (!xi.disfile) {
+	if (!params.xi.disfile) {
 		buf = libxfs_getbuf(mp->m_ddev_targp,
-				    (xi.dsize - BTOBB(WHACK_SIZE)),
+				    (params.xi.dsize - BTOBB(WHACK_SIZE)),
 				    BTOBB(WHACK_SIZE));
 		memset(XFS_BUF_PTR(buf), 0, WHACK_SIZE);
 		libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
@@ -2920,7 +2951,8 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 		(xfs_extlen_t)XFS_FSB_TO_BB(mp, logblocks),
 		&sbp->sb_uuid, sb_feat.log_version, lsunit, XLOG_FMT, XLOG_INIT_CYCLE, false);
 
-	mp = libxfs_mount(mp, sbp, xi.ddev, xi.logdev, xi.rtdev, 0);
+	mp = libxfs_mount(mp, sbp, params.xi.ddev, params.xi.logdev,
+			  params.xi.rtdev, 0);
 	if (mp == NULL) {
 		fprintf(stderr, _("%s: filesystem failed to initialize\n"),
 			progname);
@@ -2932,7 +2964,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 	 * These initialisations should be pulled into libxfs to keep the
 	 * kernel/userspace header initialisation code the same.
 	 */
-	for (agno = 0; agno < agcount; agno++) {
+	for (agno = 0; agno < params.agcount; agno++) {
 		struct xfs_agfl	*agfl;
 		int		bucket;
 		struct xfs_perag *pag = libxfs_perag_get(mp, agno);
@@ -2957,12 +2989,13 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 		buf->b_ops = &xfs_agf_buf_ops;
 		agf = XFS_BUF_TO_AGF(buf);
 		memset(agf, 0, sectorsize);
-		if (agno == agcount - 1)
-			agsize = dblocks - (xfs_rfsblock_t)(agno * agsize);
+		if (agno == params.agcount - 1)
+			params.agsize = dblocks -
+				(xfs_rfsblock_t)(agno * params.agsize);
 		agf->agf_magicnum = cpu_to_be32(XFS_AGF_MAGIC);
 		agf->agf_versionnum = cpu_to_be32(XFS_AGF_VERSION);
 		agf->agf_seqno = cpu_to_be32(agno);
-		agf->agf_length = cpu_to_be32(agsize);
+		agf->agf_length = cpu_to_be32(params.agsize);
 		agf->agf_roots[XFS_BTNUM_BNOi] = cpu_to_be32(XFS_BNO_BLOCK(mp));
 		agf->agf_roots[XFS_BTNUM_CNTi] = cpu_to_be32(XFS_CNT_BLOCK(mp));
 		agf->agf_levels[XFS_BTNUM_BNOi] = cpu_to_be32(1);
@@ -2984,7 +3017,8 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 		agf->agf_flfirst = 0;
 		agf->agf_fllast = cpu_to_be32(XFS_AGFL_SIZE(mp) - 1);
 		agf->agf_flcount = 0;
-		nbmblocks = (xfs_extlen_t)(agsize - libxfs_prealloc_blocks(mp));
+		nbmblocks = (xfs_extlen_t)(params.agsize -
+					   libxfs_prealloc_blocks(mp));
 		agf->agf_freeblks = cpu_to_be32(nbmblocks);
 		agf->agf_longest = cpu_to_be32(nbmblocks);
 		if (xfs_sb_version_hascrc(&mp->m_sb))
@@ -2992,7 +3026,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 
 		if (loginternal && agno == logagno) {
 			be32_add_cpu(&agf->agf_freeblks, -logblocks);
-			agf->agf_longest = cpu_to_be32(agsize -
+			agf->agf_longest = cpu_to_be32(params.agsize -
 				XFS_FSB_TO_AGBNO(mp, logstart) - logblocks);
 		}
 		if (libxfs_alloc_min_freelist(mp, pag) > worst_freelist)
@@ -3031,7 +3065,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 		agi->agi_magicnum = cpu_to_be32(XFS_AGI_MAGIC);
 		agi->agi_versionnum = cpu_to_be32(XFS_AGI_VERSION);
 		agi->agi_seqno = cpu_to_be32(agno);
-		agi->agi_length = cpu_to_be32((xfs_agblock_t)agsize);
+		agi->agi_length = cpu_to_be32((xfs_agblock_t)params.agsize);
 		agi->agi_count = 0;
 		agi->agi_root = cpu_to_be32(XFS_IBT_BLOCK(mp));
 		agi->agi_level = cpu_to_be32(1);
@@ -3096,7 +3130,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 		 * so, reset the record count to 0 to avoid exposure of an invalid
 		 * record start block.
 		 */
-		arec->ar_blockcount = cpu_to_be32(agsize -
+		arec->ar_blockcount = cpu_to_be32(params.agsize -
 					be32_to_cpu(arec->ar_startblock));
 		if (!arec->ar_blockcount)
 			block->bb_numrecs = 0;
@@ -3141,7 +3175,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 		 * so, reset the record count to 0 to avoid exposure of an invalid
 		 * record start block.
 		 */
-		arec->ar_blockcount = cpu_to_be32(agsize -
+		arec->ar_blockcount = cpu_to_be32(params.agsize -
 					be32_to_cpu(arec->ar_startblock));
 		if (!arec->ar_blockcount)
 			block->bb_numrecs = 0;
@@ -3304,7 +3338,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 	/*
 	 * BNO, CNT free block list
 	 */
-	for (agno = 0; agno < agcount; agno++) {
+	for (agno = 0; agno < params.agcount; agno++) {
 		xfs_alloc_arg_t	args;
 		xfs_trans_t	*tp;
 		struct xfs_trans_res tres = {0};
@@ -3328,7 +3362,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 	/*
 	 * Allocate the root inode and anything else in the proto file.
 	 */
-	parse_proto(mp, &fsx, &protostring);
+	parse_proto(mp, &params.fsx, &protostring);
 
 	/*
 	 * Protect ourselves against possible stupidity
@@ -3385,11 +3419,11 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 	libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
 
 	libxfs_umount(mp);
-	if (xi.rtdev)
-		libxfs_device_close(xi.rtdev);
-	if (xi.logdev && xi.logdev != xi.ddev)
-		libxfs_device_close(xi.logdev);
-	libxfs_device_close(xi.ddev);
+	if (params.xi.rtdev)
+		libxfs_device_close(params.xi.rtdev);
+	if (params.xi.logdev && params.xi.logdev != params.xi.ddev)
+		libxfs_device_close(params.xi.logdev);
+	libxfs_device_close(params.xi.ddev);
 
 	return 0;
 }
-- 
2.11.0

