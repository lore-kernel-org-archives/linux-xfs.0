Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:45212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752145AbdCCXOY (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 3 Mar 2017 18:14:24 -0500
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: [PATCH 3/9] mkfs.xfs: move iopts to to struct mkfs_xfs_opts
Date: Fri,  3 Mar 2017 15:13:10 -0800
Message-Id: <20170303231316.12716-4-mcgrof@kernel.org>
In-Reply-To: <20170303231316.12716-1-mcgrof@kernel.org>
References: <20170303231316.12716-1-mcgrof@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@sandeen.net, linux-xfs@vger.kernel.org
Cc: jack@suse.com, jeffm@suse.com, okurz@suse.com, lpechacek@suse.com, "Luis R. Rodriguez" <mcgrof@kernel.org>

This moves all main() iopts to struct mkfs_xfs_opts in
order to help with clutter and later enable re-parsing
options for other purposes.

Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
---
 mkfs/xfs_mkfs.c | 342 ++++++++++++++++++++++++++++----------------------------
 1 file changed, 173 insertions(+), 169 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 868cab2164d6..4575d7c84f0a 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -708,6 +708,23 @@ struct opt_params mopts = {
 	},
 };
 
+struct sb_feat_args {
+	int	log_version;
+	int	attr_version;
+	int	dir_version;
+	int	spinodes;
+	int	finobt;
+	bool	inode_align;
+	bool	nci;
+	bool	lazy_sb_counters;
+	bool	projid16bit;
+	bool	crcs_enabled;
+	bool	dirftype;
+	bool	parent_pointers;
+	bool	rmapbt;
+	bool	reflink;
+};
+
 struct mkfs_xfs_opts {
 	int			blocklog;
 	int			blflag;
@@ -728,6 +745,16 @@ struct mkfs_xfs_opts {
 	int			nodsflag;
 	int			sectorlog;
 	int			slflag;
+
+	struct sb_feat_args	sb_feat;
+	int			inodelog;
+	int			isize;
+	int			ilflag;
+	int			imaxpct;
+	int			imflag;
+	int			ipflag;
+	int			isflag;
+	int			inopblock;
 };
 
 #define TERABYTES(count, blog)	((__uint64_t)(count) << (40 - (blog)))
@@ -1171,23 +1198,6 @@ discard_blocks(dev_t dev, __uint64_t nsectors)
 		platform_discard_blocks(fd, 0, nsectors << 9);
 }
 
-struct sb_feat_args {
-	int	log_version;
-	int	attr_version;
-	int	dir_version;
-	int	spinodes;
-	int	finobt;
-	bool	inode_align;
-	bool	nci;
-	bool	lazy_sb_counters;
-	bool	projid16bit;
-	bool	crcs_enabled;
-	bool	dirftype;
-	bool	parent_pointers;
-	bool	rmapbt;
-	bool	reflink;
-};
-
 static void
 sb_set_features(
 	struct xfs_sb		*sbp,
@@ -1518,11 +1528,74 @@ parse_subopts(
 			}
 		}
 		break;
+	case 'i':
+		while (*p != '\0') {
+			switch (getsubopt(&p, (char **)iopts.subopts, &value)) {
+			case I_ALIGN:
+				params->sb_feat.inode_align =
+					getnum(value, &iopts, I_ALIGN);
+				break;
+			case I_LOG:
+				params->inodelog = getnum(value, &iopts, I_LOG);
+				params->isize = 1 << params->inodelog;
+				params->ilflag = 1;
+				break;
+			case I_MAXPCT:
+				params->imaxpct = getnum(value, &iopts,
+							 I_MAXPCT);
+				params->imflag = 1;
+				break;
+			case I_PERBLOCK:
+				params->inopblock = getnum(value, &iopts,
+							   I_PERBLOCK);
+				params->ipflag = 1;
+				break;
+			case I_SIZE:
+				params->isize = getnum(value, &iopts, I_SIZE);
+				params->inodelog =
+					libxfs_highbit32(params->isize);
+				params->isflag = 1;
+				break;
+			case I_ATTR:
+				params->sb_feat.attr_version =
+					getnum(value, &iopts, I_ATTR);
+				break;
+			case I_PROJID32BIT:
+				params->sb_feat.projid16bit =
+					!getnum(value, &iopts, I_PROJID32BIT);
+				break;
+			case I_SPINODES:
+				params->sb_feat.spinodes =
+					getnum(value, &iopts, I_SPINODES);
+				break;
+			default:
+				unknown('i', value);
+			}
+		}
+		break;
 	default:
 		usage();
 	}
 }
 
+static void init_sb_feat_args_default(struct sb_feat_args *sb_feat)
+{
+	sb_feat->finobt = 1;
+	sb_feat->spinodes = 0;
+	sb_feat->log_version = 2;
+	sb_feat->attr_version = 2;
+	sb_feat->dir_version = XFS_DFL_DIR_VERSION;
+	sb_feat->inode_align = XFS_IFLAG_ALIGN;
+	sb_feat->nci = false;
+	sb_feat->lazy_sb_counters = true;
+	sb_feat->projid16bit = false;
+	sb_feat->crcs_enabled = true;
+	sb_feat->dirftype = true;
+	sb_feat->parent_pointers = false;
+	sb_feat->rmapbt = false;
+	sb_feat->reflink = false;
+}
+
 int
 main(
 	int			argc,
@@ -1541,14 +1614,6 @@ main(
 	int			dirblocklog;
 	int			dirblocksize;
 	int			force_overwrite;
-	int			ilflag;
-	int			imaxpct;
-	int			imflag;
-	int			inodelog;
-	int			inopblock;
-	int			ipflag;
-	int			isflag;
-	int			isize;
 	char			*label = NULL;
 	int			laflag;
 	int			lalign;
@@ -1597,25 +1662,11 @@ main(
 	uuid_t			uuid;
 	int			worst_freelist;
 	struct fs_topology	ft;
-	struct sb_feat_args	sb_feat = {
-		.finobt = 1,
-		.spinodes = 0,
-		.log_version = 2,
-		.attr_version = 2,
-		.dir_version = XFS_DFL_DIR_VERSION,
-		.inode_align = XFS_IFLAG_ALIGN,
-		.nci = false,
-		.lazy_sb_counters = true,
-		.projid16bit = false,
-		.crcs_enabled = true,
-		.dirftype = true,
-		.parent_pointers = false,
-		.rmapbt = false,
-		.reflink = false,
-	};
 	struct mkfs_xfs_opts params;
+	struct sb_feat_args *sb_feat = &params.sb_feat;
 
 	memset(&params, 0, sizeof(params));
+	init_sb_feat_args_default(sb_feat);
 
 	platform_uuid_generate(&uuid);
 	progname = basename(argv[0]);
@@ -1628,14 +1679,12 @@ main(
 	lsectorlog = 0;
 	sectorsize = lsectorsize = 0;
 	dblocks = 0;
-	ilflag = imflag = ipflag = isflag = 0;
 	liflag = laflag = lsflag = lsuflag = lsunitflag = ldflag = lvflag = 0;
 	loginternal = 1;
 	logagno = logblocks = rtblocks = rtextblocks = 0;
 	Nflag = nlflag = nsflag = nvflag = 0;
 	dirblocklog = dirblocksize = 0;
 	qflag = 0;
-	imaxpct = inodelog = inopblock = isize = 0;
 	dfile = logfile = rtfile = NULL;
 	logsize = rtsize = rtextsize = protofile = NULL;
 	lalign = lsu = lsunit = 0;
@@ -1654,57 +1703,9 @@ main(
 			break;
 		case 'b':
 		case 'd':
-			p = optarg;
-			parse_subopts(c, p, &params);
-			break;
 		case 'i':
 			p = optarg;
-			while (*p != '\0') {
-				char	**subopts = (char **)iopts.subopts;
-				char	*value;
-
-				switch (getsubopt(&p, subopts, &value)) {
-				case I_ALIGN:
-					sb_feat.inode_align = getnum(value,
-								&iopts, I_ALIGN);
-					break;
-				case I_LOG:
-					inodelog = getnum(value, &iopts, I_LOG);
-					isize = 1 << inodelog;
-					ilflag = 1;
-					break;
-				case I_MAXPCT:
-					imaxpct = getnum(value, &iopts,
-							 I_MAXPCT);
-					imflag = 1;
-					break;
-				case I_PERBLOCK:
-					inopblock = getnum(value, &iopts,
-							   I_PERBLOCK);
-					ipflag = 1;
-					break;
-				case I_SIZE:
-					isize = getnum(value, &iopts, I_SIZE);
-					inodelog = libxfs_highbit32(isize);
-					isflag = 1;
-					break;
-				case I_ATTR:
-					sb_feat.attr_version =
-						getnum(value, &iopts, I_ATTR);
-					break;
-				case I_PROJID32BIT:
-					sb_feat.projid16bit =
-						!getnum(value, &iopts,
-							I_PROJID32BIT);
-					break;
-				case I_SPINODES:
-					sb_feat.spinodes = getnum(value,
-							&iopts, I_SPINODES);
-					break;
-				default:
-					unknown('i', value);
-				}
-			}
+			parse_subopts(c, p, &params);
 			break;
 		case 'l':
 			p = optarg;
@@ -1742,7 +1743,7 @@ main(
 					loginternal = 0;
 					break;
 				case L_VERSION:
-					sb_feat.log_version =
+					sb_feat->log_version =
 						getnum(value, &lopts, L_VERSION);
 					lvflag = 1;
 					break;
@@ -1763,7 +1764,7 @@ main(
 					lssflag = 1;
 					break;
 				case L_LAZYSBCNTR:
-					sb_feat.lazy_sb_counters =
+					sb_feat->lazy_sb_counters =
 							getnum(value, &lopts,
 							       L_LAZYSBCNTR);
 					break;
@@ -1785,13 +1786,13 @@ main(
 
 				switch (getsubopt(&p, subopts, &value)) {
 				case M_CRC:
-					sb_feat.crcs_enabled =
+					sb_feat->crcs_enabled =
 						getnum(value, &mopts, M_CRC);
-					if (sb_feat.crcs_enabled)
-						sb_feat.dirftype = true;
+					if (sb_feat->crcs_enabled)
+						sb_feat->dirftype = true;
 					break;
 				case M_FINOBT:
-					sb_feat.finobt = getnum(
+					sb_feat->finobt = getnum(
 						value, &mopts, M_FINOBT);
 					break;
 				case M_UUID:
@@ -1801,11 +1802,11 @@ main(
 						illegal(optarg, "m uuid");
 					break;
 				case M_RMAPBT:
-					sb_feat.rmapbt = getnum(
+					sb_feat->rmapbt = getnum(
 						value, &mopts, M_RMAPBT);
 					break;
 				case M_REFLINK:
-					sb_feat.reflink = getnum(
+					sb_feat->reflink = getnum(
 						value, &mopts, M_REFLINK);
 					break;
 				default:
@@ -1837,16 +1838,16 @@ main(
 					value = getstr(value, &nopts, N_VERSION);
 					if (!strcasecmp(value, "ci")) {
 						/* ASCII CI mode */
-						sb_feat.nci = true;
+						sb_feat->nci = true;
 					} else {
-						sb_feat.dir_version =
+						sb_feat->dir_version =
 							getnum(value, &nopts,
 							       N_VERSION);
 					}
 					nvflag = 1;
 					break;
 				case N_FTYPE:
-					sb_feat.dirftype = getnum(value, &nopts,
+					sb_feat->dirftype = getnum(value, &nopts,
 								  N_FTYPE);
 					break;
 				default:
@@ -1966,13 +1967,13 @@ main(
 		fprintf(stderr, _("illegal block size %d\n"), blocksize);
 		usage();
 	}
-	if (sb_feat.crcs_enabled && blocksize < XFS_MIN_CRC_BLOCKSIZE) {
+	if (sb_feat->crcs_enabled && blocksize < XFS_MIN_CRC_BLOCKSIZE) {
 		fprintf(stderr,
 _("Minimum block size for CRC enabled filesystems is %d bytes.\n"),
 			XFS_MIN_CRC_BLOCKSIZE);
 		usage();
 	}
-	if (sb_feat.crcs_enabled && !sb_feat.dirftype) {
+	if (sb_feat->crcs_enabled && !sb_feat->dirftype) {
 		fprintf(stderr, _("cannot disable ftype with crcs enabled\n"));
 		usage();
 	}
@@ -2073,7 +2074,7 @@ _("block size %d cannot be smaller than logical sector size %d\n"),
 		usage();
 	} else if (lsectorsize > XFS_MIN_SECTORSIZE && !lsu && !lsunit) {
 		lsu = blocksize;
-		sb_feat.log_version = 2;
+		sb_feat->log_version = 2;
 	}
 
 	/*
@@ -2081,9 +2082,10 @@ _("block size %d cannot be smaller than logical sector size %d\n"),
 	 * no longer optional for CRC enabled filesystems.  Catch them up front
 	 * here before doing anything else.
 	 */
-	if (sb_feat.crcs_enabled) {
+	if (sb_feat->crcs_enabled) {
 		/* minimum inode size is 512 bytes, ipflag checked later */
-		if ((isflag || ilflag) && inodelog < XFS_DINODE_DFL_CRC_LOG) {
+		if ((params.isflag || params.ilflag) &&
+		     params.inodelog < XFS_DINODE_DFL_CRC_LOG) {
 			fprintf(stderr,
 _("Minimum inode size for CRCs is %d bytes\n"),
 				1 << XFS_DINODE_DFL_CRC_LOG);
@@ -2091,28 +2093,28 @@ _("Minimum inode size for CRCs is %d bytes\n"),
 		}
 
 		/* inodes always aligned */
-		if (!sb_feat.inode_align) {
+		if (!sb_feat->inode_align) {
 			fprintf(stderr,
 _("Inodes always aligned for CRC enabled filesytems\n"));
 			usage();
 		}
 
 		/* lazy sb counters always on */
-		if (!sb_feat.lazy_sb_counters) {
+		if (!sb_feat->lazy_sb_counters) {
 			fprintf(stderr,
 _("Lazy superblock counted always enabled for CRC enabled filesytems\n"));
 			usage();
 		}
 
 		/* version 2 logs always on */
-		if (sb_feat.log_version != 2) {
+		if (sb_feat->log_version != 2) {
 			fprintf(stderr,
 _("V2 logs always enabled for CRC enabled filesytems\n"));
 			usage();
 		}
 
 		/* attr2 always on */
-		if (sb_feat.attr_version != 2) {
+		if (sb_feat->attr_version != 2) {
 			fprintf(stderr,
 _("V2 attribute format always enabled on CRC enabled filesytems\n"));
 			usage();
@@ -2120,7 +2122,7 @@ _("V2 attribute format always enabled on CRC enabled filesytems\n"));
 
 		/* 32 bit project quota always on */
 		/* attr2 always on */
-		if (sb_feat.projid16bit) {
+		if (sb_feat->projid16bit) {
 			fprintf(stderr,
 _("32 bit Project IDs always enabled on CRC enabled filesytems\n"));
 			usage();
@@ -2135,41 +2137,41 @@ _("32 bit Project IDs always enabled on CRC enabled filesytems\n"));
 		 * then issue an error.
 		 * The same is also for sparse inodes.
 		 */
-		if (sb_feat.finobt && mopts.subopt_params[M_FINOBT].seen) {
+		if (sb_feat->finobt && mopts.subopt_params[M_FINOBT].seen) {
 			fprintf(stderr,
 _("finobt not supported without CRC support\n"));
 			usage();
 		}
-		sb_feat.finobt = 0;
+		sb_feat->finobt = 0;
 
-		if (sb_feat.spinodes) {
+		if (sb_feat->spinodes) {
 			fprintf(stderr,
 _("sparse inodes not supported without CRC support\n"));
 			usage();
 		}
-		sb_feat.spinodes = 0;
+		sb_feat->spinodes = 0;
 
-		if (sb_feat.rmapbt) {
+		if (sb_feat->rmapbt) {
 			fprintf(stderr,
 _("rmapbt not supported without CRC support\n"));
 			usage();
 		}
-		sb_feat.rmapbt = false;
+		sb_feat->rmapbt = false;
 
-		if (sb_feat.reflink) {
+		if (sb_feat->reflink) {
 			fprintf(stderr,
 _("reflink not supported without CRC support\n"));
 			usage();
 		}
-		sb_feat.reflink = false;
+		sb_feat->reflink = false;
 	}
 
 
-	if (sb_feat.rmapbt && params.xi.rtname) {
+	if (sb_feat->rmapbt && params.xi.rtname) {
 		fprintf(stderr,
 _("rmapbt not supported with realtime devices\n"));
 		usage();
-		sb_feat.rmapbt = false;
+		sb_feat->rmapbt = false;
 	}
 
 	if (nsflag || nlflag) {
@@ -2205,15 +2207,15 @@ _("rmapbt not supported with realtime devices\n"));
 				(long long)dbytes, blocksize,
 				(long long)(dblocks << params.blocklog));
 	}
-	if (ipflag) {
-		inodelog = params.blocklog - libxfs_highbit32(inopblock);
-		isize = 1 << inodelog;
-	} else if (!ilflag && !isflag) {
-		inodelog = sb_feat.crcs_enabled ? XFS_DINODE_DFL_CRC_LOG
+	if (params.ipflag) {
+		params.inodelog = params.blocklog - libxfs_highbit32(params.inopblock);
+		params.isize = 1 << params.inodelog;
+	} else if (!params.ilflag && !params.isflag) {
+		params.inodelog = sb_feat->crcs_enabled ? XFS_DINODE_DFL_CRC_LOG
 						: XFS_DINODE_DFL_LOG;
-		isize = 1 << inodelog;
+		params.isize = 1 << params.inodelog;
 	}
-	if (sb_feat.crcs_enabled && inodelog < XFS_DINODE_DFL_CRC_LOG) {
+	if (sb_feat->crcs_enabled && params.inodelog < XFS_DINODE_DFL_CRC_LOG) {
 		fprintf(stderr,
 		_("Minimum inode size for CRCs is %d bytes\n"),
 			1 << XFS_DINODE_DFL_CRC_LOG);
@@ -2302,12 +2304,12 @@ _("rmapbt not supported with realtime devices\n"));
 	/*
 	 * Check some argument sizes against mins, maxes.
 	 */
-	if (isize > blocksize / XFS_MIN_INODE_PERBLOCK ||
-	    isize < XFS_DINODE_MIN_SIZE ||
-	    isize > XFS_DINODE_MAX_SIZE) {
+	if (params.isize > blocksize / XFS_MIN_INODE_PERBLOCK ||
+	    params.isize < XFS_DINODE_MIN_SIZE ||
+	    params.isize > XFS_DINODE_MAX_SIZE) {
 		int	maxsz;
 
-		fprintf(stderr, _("illegal inode size %d\n"), isize);
+		fprintf(stderr, _("illegal inode size %d\n"), params.isize);
 		maxsz = MIN(blocksize / XFS_MIN_INODE_PERBLOCK,
 			    XFS_DINODE_MAX_SIZE);
 		if (XFS_DINODE_MIN_SIZE == maxsz)
@@ -2322,10 +2324,10 @@ _("rmapbt not supported with realtime devices\n"));
 	}
 
 	/* if lsu or lsunit was specified, automatically use v2 logs */
-	if ((lsu || lsunit) && sb_feat.log_version == 1) {
+	if ((lsu || lsunit) && sb_feat->log_version == 1) {
 		fprintf(stderr,
 			_("log stripe unit specified, using v2 logs\n"));
-		sb_feat.log_version = 2;
+		sb_feat->log_version = 2;
 	}
 
 	calc_stripe_factors(params.dsu, params.dsw, sectorsize, lsu, lsectorsize,
@@ -2631,8 +2633,8 @@ an AG size that is one stripe unit smaller, for example %llu.\n"),
 
 	validate_ag_geometry(params.blocklog, dblocks, params.agsize, params.agcount);
 
-	if (!imflag)
-		imaxpct = calc_default_imaxpct(params.blocklog, dblocks);
+	if (!params.imflag)
+		params.imaxpct = calc_default_imaxpct(params.blocklog, dblocks);
 
 	/*
 	 * check that log sunit is modulo fsblksize or default it to dsunit.
@@ -2641,12 +2643,12 @@ an AG size that is one stripe unit smaller, for example %llu.\n"),
 	if (lsunit) {
 		/* convert from 512 byte blocks to fs blocks */
 		lsunit = DTOBT(lsunit);
-	} else if (sb_feat.log_version == 2 && loginternal && params.dsunit) {
+	} else if (sb_feat->log_version == 2 && loginternal && params.dsunit) {
 		/* lsunit and dsunit now in fs blocks */
 		lsunit = params.dsunit;
 	}
 
-	if (sb_feat.log_version == 2 && (lsunit * blocksize) > 256 * 1024) {
+	if (sb_feat->log_version == 2 && (lsunit * blocksize) > 256 * 1024) {
 		/* Warn only if specified on commandline */
 		if (lsuflag || lsunitflag) {
 			fprintf(stderr,
@@ -2659,11 +2661,12 @@ an AG size that is one stripe unit smaller, for example %llu.\n"),
 	}
 
 	min_logblocks = max_trans_res(params.agsize,
-				   sb_feat.crcs_enabled, sb_feat.dir_version,
+				   sb_feat->crcs_enabled, sb_feat->dir_version,
 				   params.sectorlog, params.blocklog,
-				   inodelog, dirblocklog,
-				   sb_feat.log_version, lsunit, sb_feat.finobt,
-				   sb_feat.rmapbt, sb_feat.reflink);
+				   params.inodelog,
+				   dirblocklog,
+				   sb_feat->log_version, lsunit, sb_feat->finobt,
+				   sb_feat->rmapbt, sb_feat->reflink);
 	ASSERT(min_logblocks);
 	min_logblocks = MAX(XFS_MIN_LOG_BLOCKS, min_logblocks);
 	if (!logsize && dblocks >= (1024*1024*1024) >> params.blocklog)
@@ -2743,7 +2746,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 	 * sb_versionnum, finobt and rmapbt flags must be set before we use
 	 * libxfs_prealloc_blocks().
 	 */
-	sb_set_features(&mp->m_sb, &sb_feat, sectorsize,
+	sb_set_features(&mp->m_sb, sb_feat, sectorsize,
 			lsectorsize, params.dsunit);
 
 
@@ -2810,19 +2813,19 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 		   "log      =%-22s bsize=%-6d blocks=%lld, version=%d\n"
 		   "         =%-22s sectsz=%-5u sunit=%d blks, lazy-count=%d\n"
 		   "realtime =%-22s extsz=%-6d blocks=%lld, rtextents=%lld\n"),
-			dfile, isize, (long long)params.agcount,
+			dfile, params.isize, (long long)params.agcount,
 			(long long)params.agsize,
-			"", sectorsize, sb_feat.attr_version,
-				    !sb_feat.projid16bit,
-			"", sb_feat.crcs_enabled, sb_feat.finobt, sb_feat.spinodes,
-			sb_feat.rmapbt, sb_feat.reflink,
-			"", blocksize, (long long)dblocks, imaxpct,
+			"", sectorsize, sb_feat->attr_version,
+				    !sb_feat->projid16bit,
+			"", sb_feat->crcs_enabled, sb_feat->finobt, sb_feat->spinodes,
+			sb_feat->rmapbt, sb_feat->reflink,
+			"", blocksize, (long long)dblocks, params.imaxpct,
 			"", params.dsunit, params.dswidth,
-			sb_feat.dir_version, dirblocksize, sb_feat.nci,
-				sb_feat.dirftype,
+			sb_feat->dir_version, dirblocksize, sb_feat->nci,
+				sb_feat->dirftype,
 			logfile, 1 << params.blocklog, (long long)logblocks,
-			sb_feat.log_version, "", lsectorsize, lsunit,
-				sb_feat.lazy_sb_counters,
+			sb_feat->log_version, "", lsectorsize, lsunit,
+				sb_feat->lazy_sb_counters,
 			rtfile, rtextblocks << params.blocklog,
 			(long long)rtblocks, (long long)rtextents);
 		if (Nflag)
@@ -2846,16 +2849,16 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 	sbp->sb_rbmblocks = nbmblocks;
 	sbp->sb_logblocks = (xfs_extlen_t)logblocks;
 	sbp->sb_sectsize = (__uint16_t)sectorsize;
-	sbp->sb_inodesize = (__uint16_t)isize;
-	sbp->sb_inopblock = (__uint16_t)(blocksize / isize);
+	sbp->sb_inodesize = (__uint16_t)params.isize;
+	sbp->sb_inopblock = (__uint16_t)(blocksize / params.isize);
 	sbp->sb_sectlog = (__uint8_t)params.sectorlog;
-	sbp->sb_inodelog = (__uint8_t)inodelog;
-	sbp->sb_inopblog = (__uint8_t)(params.blocklog - inodelog);
+	sbp->sb_inodelog = (__uint8_t)params.inodelog;
+	sbp->sb_inopblog = (__uint8_t)(params.blocklog - params.inodelog);
 	sbp->sb_rextslog =
 		(__uint8_t)(rtextents ?
 			libxfs_highbit32((unsigned int)rtextents) : 0);
 	sbp->sb_inprogress = 1;	/* mkfs is in progress */
-	sbp->sb_imax_pct = imaxpct;
+	sbp->sb_imax_pct = params.imaxpct;
 	sbp->sb_icount = 0;
 	sbp->sb_ifree = 0;
 	sbp->sb_fdblocks = dblocks - params.agcount * libxfs_prealloc_blocks(mp) -
@@ -2866,17 +2869,17 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 	sbp->sb_unit = params.dsunit;
 	sbp->sb_width = params.dswidth;
 	sbp->sb_dirblklog = dirblocklog - params.blocklog;
-	if (sb_feat.log_version == 2) {	/* This is stored in bytes */
+	if (sb_feat->log_version == 2) {	/* This is stored in bytes */
 		lsunit = (lsunit == 0) ? 1 : XFS_FSB_TO_B(mp, lsunit);
 		sbp->sb_logsunit = lsunit;
 	} else
 		sbp->sb_logsunit = 0;
-	if (sb_feat.inode_align) {
+	if (sb_feat->inode_align) {
 		int	cluster_size = XFS_INODE_BIG_CLUSTER_SIZE;
-		if (sb_feat.crcs_enabled)
-			cluster_size *= isize / XFS_DINODE_MIN_SIZE;
+		if (sb_feat->crcs_enabled)
+			cluster_size *= params.isize / XFS_DINODE_MIN_SIZE;
 		sbp->sb_inoalignmt = cluster_size >> params.blocklog;
-		sb_feat.inode_align = sbp->sb_inoalignmt != 0;
+		sb_feat->inode_align = sbp->sb_inoalignmt != 0;
 	} else
 		sbp->sb_inoalignmt = 0;
 	if (lsectorsize != BBSIZE || sectorsize != BBSIZE) {
@@ -2887,7 +2890,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 		sbp->sb_logsectsize = 0;
 	}
 
-	sb_set_features(&mp->m_sb, &sb_feat, sectorsize,
+	sb_set_features(&mp->m_sb, sb_feat, sectorsize,
 			lsectorsize, params.dsunit);
 
 	if (force_overwrite)
@@ -2949,7 +2952,8 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 	libxfs_log_clear(mp->m_logdev_targp, NULL,
 		XFS_FSB_TO_DADDR(mp, logstart),
 		(xfs_extlen_t)XFS_FSB_TO_BB(mp, logblocks),
-		&sbp->sb_uuid, sb_feat.log_version, lsunit, XLOG_FMT, XLOG_INIT_CYCLE, false);
+		&sbp->sb_uuid, sb_feat->log_version, lsunit,
+		XLOG_FMT, XLOG_INIT_CYCLE, false);
 
 	mp = libxfs_mount(mp, sbp, params.xi.ddev, params.xi.logdev,
 			  params.xi.rtdev, 0);
@@ -3069,7 +3073,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 		agi->agi_count = 0;
 		agi->agi_root = cpu_to_be32(XFS_IBT_BLOCK(mp));
 		agi->agi_level = cpu_to_be32(1);
-		if (sb_feat.finobt) {
+		if (sb_feat->finobt) {
 			agi->agi_free_root = cpu_to_be32(XFS_FIBT_BLOCK(mp));
 			agi->agi_free_level = cpu_to_be32(1);
 		}
@@ -3220,7 +3224,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 		/*
 		 * Free INO btree root block
 		 */
-		if (sb_feat.finobt) {
+		if (sb_feat->finobt) {
 			buf = libxfs_getbuf(mp->m_ddev_targp,
 					XFS_AGB_TO_DADDR(mp, agno, XFS_FIBT_BLOCK(mp)),
 					bsize);
-- 
2.11.0

