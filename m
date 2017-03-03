Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:45248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752147AbdCCXOY (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 3 Mar 2017 18:14:24 -0500
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: [PATCH 4/9] mkfs.xfs: move lopts to struct mkfs_xfs_opts
Date: Fri,  3 Mar 2017 15:13:11 -0800
Message-Id: <20170303231316.12716-5-mcgrof@kernel.org>
In-Reply-To: <20170303231316.12716-1-mcgrof@kernel.org>
References: <20170303231316.12716-1-mcgrof@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@sandeen.net, linux-xfs@vger.kernel.org
Cc: jack@suse.com, jeffm@suse.com, okurz@suse.com, lpechacek@suse.com, "Luis R. Rodriguez" <mcgrof@kernel.org>

This moves all main() lopts to struct mkfs_xfs_opts in
order to help with clutter and later enable re-parsing
options for other purposes.

Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
---
 mkfs/xfs_mkfs.c | 355 ++++++++++++++++++++++++++++----------------------------
 1 file changed, 180 insertions(+), 175 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 4575d7c84f0a..cd52b525f824 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -755,6 +755,23 @@ struct mkfs_xfs_opts {
 	int			ipflag;
 	int			isflag;
 	int			inopblock;
+
+	xfs_agnumber_t		logagno;
+	int			laflag;
+	int			liflag;
+	int			lsuflag;
+	int			lsu;
+	int			loginternal;
+	char			*logfile;
+	char			*logsize;
+	int			lsectorlog;
+	int			lsectorsize;
+	int			lsunit;
+	int			lsunitflag;
+	int			ldflag;
+	int			lvflag;
+	int			lslflag;
+	int			lssflag;
 };
 
 #define TERABYTES(count, blog)	((__uint64_t)(count) << (40 - (blog)))
@@ -1573,6 +1590,67 @@ parse_subopts(
 			}
 		}
 		break;
+	case 'l':
+		while (*p != '\0') {
+			switch (getsubopt(&p, (char **)lopts.subopts, &value)) {
+			case L_AGNUM:
+				params->logagno = getnum(value, &lopts, L_AGNUM);
+				params->laflag = 1;
+				break;
+			case L_FILE:
+				params->xi.lisfile = getnum(value, &lopts,
+						    L_FILE);
+				break;
+			case L_INTERNAL:
+				params->loginternal = getnum(value, &lopts,
+						     L_INTERNAL);
+				params->liflag = 1;
+				break;
+			case L_SU:
+				params->lsu = getnum(value, &lopts, L_SU);
+				params->lsuflag = 1;
+				break;
+			case L_SUNIT:
+				params->lsunit = getnum(value, &lopts, L_SUNIT);
+				params->lsunitflag = 1;
+				break;
+			case L_NAME:
+			case L_DEV:
+				params->logfile = getstr(value, &lopts, L_NAME);
+				params->xi.logname = params->logfile;
+				params->ldflag = 1;
+				params->loginternal = 0;
+				break;
+			case L_VERSION:
+				params->sb_feat.log_version =
+					getnum(value, &lopts, L_VERSION);
+				params->lvflag = 1;
+				break;
+			case L_SIZE:
+				params->logsize = getstr(value, &lopts, L_SIZE);
+				break;
+			case L_SECTLOG:
+				params->lsectorlog = getnum(value, &lopts,
+							    L_SECTLOG);
+				params->lsectorsize = 1 << params->lsectorlog;
+				params->lslflag = 1;
+				break;
+			case L_SECTSIZE:
+				params->lsectorsize = getnum(value, &lopts,
+							     L_SECTSIZE);
+				params->lsectorlog =
+					libxfs_highbit32(params->lsectorsize);
+				params->lssflag = 1;
+				break;
+			case L_LAZYSBCNTR:
+				params->sb_feat.lazy_sb_counters =
+					getnum(value, &lopts, L_LAZYSBCNTR);
+				break;
+			default:
+				unknown('l', value);
+			}
+		}
+		break;
 	default:
 		usage();
 	}
@@ -1615,26 +1693,10 @@ main(
 	int			dirblocksize;
 	int			force_overwrite;
 	char			*label = NULL;
-	int			laflag;
 	int			lalign;
-	int			ldflag;
-	int			liflag;
-	xfs_agnumber_t		logagno;
 	xfs_rfsblock_t		logblocks;
-	char			*logfile;
-	int			loginternal;
-	char			*logsize;
 	xfs_fsblock_t		logstart;
-	int			lvflag;
 	int			lsflag;
-	int			lsuflag;
-	int			lsunitflag;
-	int			lsectorlog;
-	int			lsectorsize;
-	int			lslflag;
-	int			lssflag;
-	int			lsu;
-	int			lsunit;
 	int			min_logblocks;
 	xfs_mount_t		*mp;
 	xfs_mount_t		mbuf;
@@ -1674,20 +1736,18 @@ main(
 	bindtextdomain(PACKAGE, LOCALEDIR);
 	textdomain(PACKAGE);
 
-	lslflag = lssflag = 0;
 	blocksize = 0;
-	lsectorlog = 0;
-	sectorsize = lsectorsize = 0;
+	sectorsize = 0;
 	dblocks = 0;
-	liflag = laflag = lsflag = lsuflag = lsunitflag = ldflag = lvflag = 0;
-	loginternal = 1;
-	logagno = logblocks = rtblocks = rtextblocks = 0;
+	params.loginternal = 1;
+	lsflag = 0;
+	logblocks = rtblocks = rtextblocks = 0;
 	Nflag = nlflag = nsflag = nvflag = 0;
 	dirblocklog = dirblocksize = 0;
 	qflag = 0;
-	dfile = logfile = rtfile = NULL;
-	logsize = rtsize = rtextsize = protofile = NULL;
-	lalign = lsu = lsunit = 0;
+	dfile = rtfile = NULL;
+	rtsize = rtextsize = protofile = NULL;
+	lalign = 0;
 	norsflag = 0;
 	force_overwrite = 0;
 	worst_freelist = 0;
@@ -1704,74 +1764,9 @@ main(
 		case 'b':
 		case 'd':
 		case 'i':
-			p = optarg;
-			parse_subopts(c, p, &params);
-			break;
 		case 'l':
 			p = optarg;
-			while (*p != '\0') {
-				char	**subopts = (char **)lopts.subopts;
-				char	*value;
-
-				switch (getsubopt(&p, subopts, &value)) {
-				case L_AGNUM:
-					logagno = getnum(value, &lopts, L_AGNUM);
-					laflag = 1;
-					break;
-				case L_FILE:
-					params.xi.lisfile = getnum(value, &lopts,
-							    L_FILE);
-					break;
-				case L_INTERNAL:
-					loginternal = getnum(value, &lopts,
-							     L_INTERNAL);
-					liflag = 1;
-					break;
-				case L_SU:
-					lsu = getnum(value, &lopts, L_SU);
-					lsuflag = 1;
-					break;
-				case L_SUNIT:
-					lsunit = getnum(value, &lopts, L_SUNIT);
-					lsunitflag = 1;
-					break;
-				case L_NAME:
-				case L_DEV:
-					logfile = getstr(value, &lopts, L_NAME);
-					params.xi.logname = logfile;
-					ldflag = 1;
-					loginternal = 0;
-					break;
-				case L_VERSION:
-					sb_feat->log_version =
-						getnum(value, &lopts, L_VERSION);
-					lvflag = 1;
-					break;
-				case L_SIZE:
-					logsize = getstr(value, &lopts, L_SIZE);
-					break;
-				case L_SECTLOG:
-					lsectorlog = getnum(value, &lopts,
-							    L_SECTLOG);
-					lsectorsize = 1 << lsectorlog;
-					lslflag = 1;
-					break;
-				case L_SECTSIZE:
-					lsectorsize = getnum(value, &lopts,
-							     L_SECTSIZE);
-					lsectorlog =
-						libxfs_highbit32(lsectorsize);
-					lssflag = 1;
-					break;
-				case L_LAZYSBCNTR:
-					sb_feat->lazy_sb_counters =
-							getnum(value, &lopts,
-							       L_LAZYSBCNTR);
-					break;
-				default:
-					unknown('l', value);
-				}
-			}
+			parse_subopts(c, p, &params);
 			break;
 		case 'L':
 			if (strlen(optarg) > sizeof(sbp->sb_fname))
@@ -1910,28 +1905,28 @@ main(
 				switch (getsubopt(&p, subopts, &value)) {
 				case S_LOG:
 				case S_SECTLOG:
-					if (lssflag)
+					if (params.lssflag)
 						conflict('s', subopts,
 							 S_SECTSIZE, S_SECTLOG);
 					params.sectorlog = getnum(value, &sopts,
 							   S_SECTLOG);
-					lsectorlog = params.sectorlog;
+					params.lsectorlog = params.sectorlog;
 					sectorsize = 1 << params.sectorlog;
-					lsectorsize = sectorsize;
-					lslflag = params.slflag = 1;
+					params.lsectorsize = sectorsize;
+					params.lslflag = params.slflag = 1;
 					break;
 				case S_SIZE:
 				case S_SECTSIZE:
-					if (lslflag)
+					if (params.lslflag)
 						conflict('s', subopts, S_SECTLOG,
 							 S_SECTSIZE);
 					sectorsize = getnum(value, &sopts,
 							    S_SECTSIZE);
-					lsectorsize = sectorsize;
+					params.lsectorsize = sectorsize;
 					params.sectorlog =
 						libxfs_highbit32(sectorsize);
-					lsectorlog = params.sectorlog;
-					lssflag = params.ssflag = 1;
+					params.lsectorlog = params.sectorlog;
+					params.lssflag = params.ssflag = 1;
 					break;
 				default:
 					unknown('s', value);
@@ -1982,9 +1977,9 @@ _("Minimum block size for CRC enabled filesystems is %d bytes.\n"),
 		params.sectorlog = XFS_MIN_SECTORSIZE_LOG;
 		sectorsize = XFS_MIN_SECTORSIZE;
 	}
-	if (!lslflag && !lssflag) {
-		lsectorlog = params.sectorlog;
-		lsectorsize = sectorsize;
+	if (!params.lslflag && !params.lssflag) {
+		params.lsectorlog = params.sectorlog;
+		params.lsectorsize = sectorsize;
 	}
 
 	/*
@@ -1997,10 +1992,10 @@ _("Minimum block size for CRC enabled filesystems is %d bytes.\n"),
 	check_device_type(dfile, &params.xi.disfile, !params.dsize, !dfile,
 			  Nflag ? NULL : &params.xi.dcreat,
 			  force_overwrite, "d");
-	if (!loginternal)
+	if (!params.loginternal)
 		check_device_type(params.xi.logname,
 				  &params.xi.lisfile,
-				  !logsize,
+				  !params.logsize,
 				  !params.xi.logname,
 				  Nflag ? NULL : &params.xi.lcreat,
 				  force_overwrite, "l");
@@ -2047,9 +2042,9 @@ _("switching to logical sector size %d\n"),
 
 	if (!params.ssflag) {
 		params.sectorlog = libxfs_highbit32(sectorsize);
-		if (loginternal) {
-			lsectorsize = sectorsize;
-			lsectorlog = params.sectorlog;
+		if (params.loginternal) {
+			params.lsectorsize = sectorsize;
+			params.lsectorlog = params.sectorlog;
 		}
 	}
 
@@ -2068,12 +2063,13 @@ _("block size %d cannot be smaller than logical sector size %d\n"),
 			sectorsize, ft.lsectorsize);
 		usage();
 	}
-	if (lsectorsize < XFS_MIN_SECTORSIZE ||
-	    lsectorsize > XFS_MAX_SECTORSIZE || lsectorsize > blocksize) {
-		fprintf(stderr, _("illegal log sector size %d\n"), lsectorsize);
+	if (params.lsectorsize < XFS_MIN_SECTORSIZE ||
+	    params.lsectorsize > XFS_MAX_SECTORSIZE || params.lsectorsize > blocksize) {
+		fprintf(stderr, _("illegal log sector size %d\n"),
+			params.lsectorsize);
 		usage();
-	} else if (lsectorsize > XFS_MIN_SECTORSIZE && !lsu && !lsunit) {
-		lsu = blocksize;
+	} else if (params.lsectorsize > XFS_MIN_SECTORSIZE && !params.lsu && !params.lsunit) {
+		params.lsu = blocksize;
 		sb_feat->log_version = 2;
 	}
 
@@ -2222,10 +2218,10 @@ _("rmapbt not supported with realtime devices\n"));
 		usage();
 	}
 
-	if (logsize) {
+	if (params.logsize) {
 		__uint64_t logbytes;
 
-		logbytes = getnum(logsize, &lopts, L_SIZE);
+		logbytes = getnum(params.logsize, &lopts, L_SIZE);
 		if (logbytes % XFS_MIN_BLOCKSIZE) {
 			fprintf(stderr,
 			_("illegal log length %lld, not a multiple of %d\n"),
@@ -2324,14 +2320,16 @@ _("rmapbt not supported with realtime devices\n"));
 	}
 
 	/* if lsu or lsunit was specified, automatically use v2 logs */
-	if ((lsu || lsunit) && sb_feat->log_version == 1) {
+	if ((params.lsu || params.lsunit) && sb_feat->log_version == 1) {
 		fprintf(stderr,
 			_("log stripe unit specified, using v2 logs\n"));
 		sb_feat->log_version = 2;
 	}
 
-	calc_stripe_factors(params.dsu, params.dsw, sectorsize, lsu, lsectorsize,
-				&params.dsunit, &params.dswidth, &lsunit);
+	calc_stripe_factors(params.dsu, params.dsw, sectorsize, params.lsu,
+				params.lsectorsize,
+				&params.dsunit, &params.dswidth,
+				&params.lsunit);
 
 	params.xi.setblksize = sectorsize;
 
@@ -2359,8 +2357,8 @@ _("rmapbt not supported with realtime devices\n"));
 	sector_mask = (__uint64_t)-1 << (MAX(params.sectorlog, 10) - BBSHIFT);
 	params.xi.dsize &= sector_mask;
 	params.xi.rtsize &= sector_mask;
-	params.xi.logBBsize &= (__uint64_t)-1 << (MAX(lsectorlog, 10) - BBSHIFT);
-
+	params.xi.logBBsize &= (__uint64_t)-1 <<
+		(MAX(params.lsectorlog, 10) - BBSHIFT);
 
 	/* don't do discards on print-only runs or on files */
 	if (discard && !Nflag) {
@@ -2373,15 +2371,15 @@ _("rmapbt not supported with realtime devices\n"));
 			discard_blocks(params.xi.logdev, params.xi.logBBsize);
 	}
 
-	if (!liflag && !ldflag)
-		loginternal = params.xi.logdev == 0;
+	if (!params.liflag && !params.ldflag)
+		params.loginternal = params.xi.logdev == 0;
 	if (params.xi.logname)
-		logfile = params.xi.logname;
-	else if (loginternal)
-		logfile = _("internal log");
+		params.logfile = params.xi.logname;
+	else if (params.loginternal)
+		params.logfile = _("internal log");
 	else if (params.xi.volname && params.xi.logdev)
-		logfile = _("volume log");
-	else if (!ldflag) {
+		params.logfile = _("volume log");
+	else if (!params.ldflag) {
 		fprintf(stderr, _("no log subvolume or internal log\n"));
 		usage();
 	}
@@ -2412,11 +2410,11 @@ _("rmapbt not supported with realtime devices\n"));
 		usage();
 	}
 
-	if (loginternal && params.xi.logdev) {
+	if (params.loginternal && params.xi.logdev) {
 		fprintf(stderr,
 			_("can't have both external and internal logs\n"));
 		usage();
-	} else if (loginternal && sectorsize != lsectorsize) {
+	} else if (params.loginternal && sectorsize != params.lsectorsize) {
 		fprintf(stderr,
 	_("data and log sector sizes must be equal for internal logs\n"));
 		usage();
@@ -2428,11 +2426,11 @@ _("rmapbt not supported with realtime devices\n"));
 reported by the device (%u).\n"),
 			sectorsize, params.xi.dbsize);
 	}
-	if (!loginternal && params.xi.lbsize > lsectorsize) {
+	if (!params.loginternal && params.xi.lbsize > params.lsectorsize) {
 		fprintf(stderr, _(
 "Warning: the log subvolume sector size %u is less than the sector size\n\
 reported by the device (%u).\n"),
-			lsectorsize, params.xi.lbsize);
+			params.lsectorsize, params.xi.lbsize);
 	}
 	if (rtsize && params.xi.rtsize > 0 && params.xi.rtbsize > sectorsize) {
 		fprintf(stderr, _(
@@ -2640,24 +2638,24 @@ an AG size that is one stripe unit smaller, for example %llu.\n"),
 	 * check that log sunit is modulo fsblksize or default it to dsunit.
 	 */
 
-	if (lsunit) {
+	if (params.lsunit) {
 		/* convert from 512 byte blocks to fs blocks */
-		lsunit = DTOBT(lsunit);
-	} else if (sb_feat->log_version == 2 && loginternal && params.dsunit) {
+		params.lsunit = DTOBT(params.lsunit);
+	} else if (sb_feat->log_version == 2 && params.loginternal && params.dsunit) {
 		/* lsunit and dsunit now in fs blocks */
-		lsunit = params.dsunit;
+		params.lsunit = params.dsunit;
 	}
 
-	if (sb_feat->log_version == 2 && (lsunit * blocksize) > 256 * 1024) {
+	if (sb_feat->log_version == 2 && (params.lsunit * blocksize) > 256 * 1024) {
 		/* Warn only if specified on commandline */
-		if (lsuflag || lsunitflag) {
+		if (params.lsuflag || params.lsunitflag) {
 			fprintf(stderr,
 	_("log stripe unit (%d bytes) is too large (maximum is 256KiB)\n"),
-				(lsunit * blocksize));
+				(params.lsunit * blocksize));
 			fprintf(stderr,
 	_("log stripe unit adjusted to 32KiB\n"));
 		}
-		lsunit = (32 * 1024) >> params.blocklog;
+		params.lsunit = (32 * 1024) >> params.blocklog;
 	}
 
 	min_logblocks = max_trans_res(params.agsize,
@@ -2665,31 +2663,32 @@ an AG size that is one stripe unit smaller, for example %llu.\n"),
 				   params.sectorlog, params.blocklog,
 				   params.inodelog,
 				   dirblocklog,
-				   sb_feat->log_version, lsunit, sb_feat->finobt,
+				   sb_feat->log_version, params.lsunit,
+				   sb_feat->finobt,
 				   sb_feat->rmapbt, sb_feat->reflink);
 	ASSERT(min_logblocks);
 	min_logblocks = MAX(XFS_MIN_LOG_BLOCKS, min_logblocks);
-	if (!logsize && dblocks >= (1024*1024*1024) >> params.blocklog)
+	if (!params.logsize && dblocks >= (1024*1024*1024) >> params.blocklog)
 		min_logblocks = MAX(min_logblocks, XFS_MIN_LOG_BYTES>>params.blocklog);
-	if (logsize && params.xi.logBBsize > 0 &&
+	if (params.logsize && params.xi.logBBsize > 0 &&
 	    logblocks > DTOBT(params.xi.logBBsize)) {
 		fprintf(stderr,
 _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
-			logsize, (long long)DTOBT(params.xi.logBBsize));
+			params.logsize, (long long)DTOBT(params.xi.logBBsize));
 		usage();
-	} else if (!logsize && params.xi.logBBsize > 0) {
+	} else if (!params.logsize && params.xi.logBBsize > 0) {
 		logblocks = DTOBT(params.xi.logBBsize);
-	} else if (logsize && !params.xi.logdev && !loginternal) {
+	} else if (params.logsize && !params.xi.logdev && !params.loginternal) {
 		fprintf(stderr,
 			_("size specified for non-existent log subvolume\n"));
 		usage();
-	} else if (loginternal && logsize && logblocks >= dblocks) {
+	} else if (params.loginternal && params.logsize && logblocks >= dblocks) {
 		fprintf(stderr, _("size %lld too large for internal log\n"),
 			(long long)logblocks);
 		usage();
-	} else if (!loginternal && !params.xi.logdev) {
+	} else if (!params.loginternal && !params.xi.logdev) {
 		logblocks = 0;
-	} else if (loginternal && !logsize) {
+	} else if (params.loginternal && !params.logsize) {
 
 		if (dblocks < GIGABYTES(1, params.blocklog)) {
 			/* tiny filesystems get minimum sized logs. */
@@ -2747,15 +2746,15 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 	 * libxfs_prealloc_blocks().
 	 */
 	sb_set_features(&mp->m_sb, sb_feat, sectorsize,
-			lsectorsize, params.dsunit);
+			params.lsectorsize, params.dsunit);
 
 
-	if (loginternal) {
+	if (params.loginternal) {
 		/*
 		 * Readjust the log size to fit within an AG if it was sized
 		 * automatically.
 		 */
-		if (!logsize) {
+		if (!params.logsize) {
 			logblocks = MIN(logblocks,
 					libxfs_alloc_ag_max_usable(mp));
 
@@ -2769,23 +2768,26 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 			usage();
 		}
 
-		if (laflag) {
-			if (logagno >= params.agcount) {
+		if (params.laflag) {
+			if (params.logagno >= params.agcount) {
 				fprintf(stderr,
 		_("log ag number %d too large, must be less than %lld\n"),
-					logagno, (long long)params.agcount);
+					params.logagno,
+					(long long)params.agcount);
 				usage();
 			}
 		} else
-			logagno = (xfs_agnumber_t)(params.agcount / 2);
+			params.logagno = (xfs_agnumber_t)(params.agcount / 2);
 
-		logstart = XFS_AGB_TO_FSB(mp, logagno, libxfs_prealloc_blocks(mp));
+		logstart = XFS_AGB_TO_FSB(mp, params.logagno,
+					  libxfs_prealloc_blocks(mp));
 		/*
 		 * Align the logstart at stripe unit boundary.
 		 */
-		if (lsunit) {
+		if (params.lsunit) {
 			logstart = fixup_internal_log_stripe(mp,
-					lsflag, logstart, params.agsize, lsunit,
+					lsflag, logstart, params.agsize,
+					params.lsunit,
 					&logblocks, params.blocklog, &lalign);
 		} else if (params.dsunit) {
 			logstart = fixup_internal_log_stripe(mp,
@@ -2796,9 +2798,9 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 		}
 	} else {
 		logstart = 0;
-		if (lsunit)
-			fixup_log_stripe_unit(lsflag, lsunit,
-					&logblocks, params.blocklog);
+		if (params.lsunit)
+			fixup_log_stripe_unit(lsflag, params.lsunit,
+					      &logblocks, params.blocklog);
 	}
 	validate_log_size(logblocks, params.blocklog, min_logblocks);
 
@@ -2823,9 +2825,11 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 			"", params.dsunit, params.dswidth,
 			sb_feat->dir_version, dirblocksize, sb_feat->nci,
 				sb_feat->dirftype,
-			logfile, 1 << params.blocklog, (long long)logblocks,
-			sb_feat->log_version, "", lsectorsize, lsunit,
-				sb_feat->lazy_sb_counters,
+			params.logfile, 1 << params.blocklog,
+			(long long)logblocks,
+			sb_feat->log_version, "", params.lsectorsize,
+			params.lsunit,
+			sb_feat->lazy_sb_counters,
 			rtfile, rtextblocks << params.blocklog,
 			(long long)rtblocks, (long long)rtextents);
 		if (Nflag)
@@ -2862,7 +2866,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 	sbp->sb_icount = 0;
 	sbp->sb_ifree = 0;
 	sbp->sb_fdblocks = dblocks - params.agcount * libxfs_prealloc_blocks(mp) -
-		(loginternal ? logblocks : 0);
+		(params.loginternal ? logblocks : 0);
 	sbp->sb_frextents = 0;	/* will do a free later */
 	sbp->sb_uquotino = sbp->sb_gquotino = sbp->sb_pquotino = 0;
 	sbp->sb_qflags = 0;
@@ -2870,8 +2874,9 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 	sbp->sb_width = params.dswidth;
 	sbp->sb_dirblklog = dirblocklog - params.blocklog;
 	if (sb_feat->log_version == 2) {	/* This is stored in bytes */
-		lsunit = (lsunit == 0) ? 1 : XFS_FSB_TO_B(mp, lsunit);
-		sbp->sb_logsunit = lsunit;
+		params.lsunit = (params.lsunit == 0) ? 1 : XFS_FSB_TO_B(mp,
+									params.lsunit);
+		sbp->sb_logsunit = params.lsunit;
 	} else
 		sbp->sb_logsunit = 0;
 	if (sb_feat->inode_align) {
@@ -2882,16 +2887,16 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 		sb_feat->inode_align = sbp->sb_inoalignmt != 0;
 	} else
 		sbp->sb_inoalignmt = 0;
-	if (lsectorsize != BBSIZE || sectorsize != BBSIZE) {
-		sbp->sb_logsectlog = (__uint8_t)lsectorlog;
-		sbp->sb_logsectsize = (__uint16_t)lsectorsize;
+	if (params.lsectorsize != BBSIZE || sectorsize != BBSIZE) {
+		sbp->sb_logsectlog = (__uint8_t)params.lsectorlog;
+		sbp->sb_logsectsize = (__uint16_t) params.lsectorsize;
 	} else {
 		sbp->sb_logsectlog = 0;
 		sbp->sb_logsectsize = 0;
 	}
 
 	sb_set_features(&mp->m_sb, sb_feat, sectorsize,
-			lsectorsize, params.dsunit);
+			params.lsectorsize, params.dsunit);
 
 	if (force_overwrite)
 		zero_old_xfs_structures(&params.xi, sbp);
@@ -2952,7 +2957,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 	libxfs_log_clear(mp->m_logdev_targp, NULL,
 		XFS_FSB_TO_DADDR(mp, logstart),
 		(xfs_extlen_t)XFS_FSB_TO_BB(mp, logblocks),
-		&sbp->sb_uuid, sb_feat->log_version, lsunit,
+		&sbp->sb_uuid, sb_feat->log_version, params.lsunit,
 		XLOG_FMT, XLOG_INIT_CYCLE, false);
 
 	mp = libxfs_mount(mp, sbp, params.xi.ddev, params.xi.logdev,
@@ -3028,7 +3033,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 		if (xfs_sb_version_hascrc(&mp->m_sb))
 			platform_uuid_copy(&agf->agf_uuid, &mp->m_sb.sb_uuid);
 
-		if (loginternal && agno == logagno) {
+		if (params.loginternal && agno == params.logagno) {
 			be32_add_cpu(&agf->agf_freeblks, -logblocks);
 			agf->agf_longest = cpu_to_be32(params.agsize -
 				XFS_FSB_TO_AGBNO(mp, logstart) - logblocks);
@@ -3104,7 +3109,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 
 		arec = XFS_ALLOC_REC_ADDR(mp, block, 1);
 		arec->ar_startblock = cpu_to_be32(libxfs_prealloc_blocks(mp));
-		if (loginternal && agno == logagno) {
+		if (params.loginternal && agno == params.logagno) {
 			if (lalign) {
 				/*
 				 * Have to insert two records
@@ -3159,7 +3164,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 
 		arec = XFS_ALLOC_REC_ADDR(mp, block, 1);
 		arec->ar_startblock = cpu_to_be32(libxfs_prealloc_blocks(mp));
-		if (loginternal && agno == logagno) {
+		if (params.loginternal && agno == params.logagno) {
 			if (lalign) {
 				arec->ar_blockcount = cpu_to_be32(
 					XFS_FSB_TO_AGBNO(mp, logstart) -
@@ -3304,7 +3309,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 			}
 
 			/* account for the log space */
-			if (loginternal && agno == logagno) {
+			if (params.loginternal && agno == params.logagno) {
 				rrec = XFS_RMAP_REC_ADDR(block,
 					be16_to_cpu(block->bb_numrecs) + 1);
 				rrec->rm_startblock = cpu_to_be32(
-- 
2.11.0

