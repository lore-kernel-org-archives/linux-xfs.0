Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:45158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751989AbdCCXOY (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 3 Mar 2017 18:14:24 -0500
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: [PATCH 1/9] mkfs.xfs: add helper to parse command line options
Date: Fri,  3 Mar 2017 15:13:08 -0800
Message-Id: <20170303231316.12716-2-mcgrof@kernel.org>
In-Reply-To: <20170303231316.12716-1-mcgrof@kernel.org>
References: <20170303231316.12716-1-mcgrof@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@sandeen.net, linux-xfs@vger.kernel.org
Cc: jack@suse.com, jeffm@suse.com, okurz@suse.com, lpechacek@suse.com, "Luis R. Rodriguez" <mcgrof@kernel.org>

Command line arguments are verified using a scheme which
has been extended over the years. Making re-use of it however
is not so easy mostly because all variables required are local
on main() and assumptions of this for the verifiers.

To enable future use of the verifiers in other areas add helper
routine parse_subopts() which can be used to parse subopts, the
subopts must be set then in the struct mkfs_xfs_opts, and all we
pass is the value being parsed along with the subopt type.

In the future this work should also help enable moving a lot of
cruft on main() into helpers, given eventually we'll be able to
pass around all important parameters.

We start of with adding support for the b subopts.

Leave the globals as-is for now.

Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
---
 mkfs/xfs_mkfs.c | 167 +++++++++++++++++++++++++++++++-------------------------
 1 file changed, 93 insertions(+), 74 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index affa4052d62d..7ca972ee9675 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -708,6 +708,12 @@ struct opt_params mopts = {
 	},
 };
 
+struct mkfs_xfs_opts {
+	int			blocklog;
+	int			blflag;
+	int			bsflag;
+};
+
 #define TERABYTES(count, blog)	((__uint64_t)(count) << (40 - (blog)))
 #define GIGABYTES(count, blog)	((__uint64_t)(count) << (30 - (blog)))
 #define MEGABYTES(count, blog)	((__uint64_t)(count) << (20 - (blog)))
@@ -715,7 +721,7 @@ struct opt_params mopts = {
 /*
  * Use this macro before we have superblock and mount structure
  */
-#define	DTOBT(d)	((xfs_rfsblock_t)((d) >> (blocklog - BBSHIFT)))
+#define	DTOBT(d)	((xfs_rfsblock_t)((d) >> (params.blocklog - BBSHIFT)))
 
 /*
  * Use this for block reservations needed for mkfs's conditions
@@ -1393,6 +1399,38 @@ getstr(
 	return str;
 }
 
+static void
+parse_subopts(
+	int type,
+	char *p,
+	struct mkfs_xfs_opts *params)
+{
+	char	*value;
+
+	switch (type) {
+	case 'b':
+		while (*p != '\0') {
+			switch (getsubopt(&p, (char **)bopts.subopts, &value)) {
+			case B_LOG:
+				params->blocklog = getnum(value, &bopts, B_LOG);
+				blocksize = 1 << params->blocklog;
+				params->blflag = 1;
+				break;
+			case B_SIZE:
+				blocksize = getnum(value, &bopts, B_SIZE);
+				params->blocklog = libxfs_highbit32(blocksize);
+				params->bsflag = 1;
+				break;
+			default:
+				unknown('b', value);
+			}
+		}
+		break;
+	default:
+		usage();
+	}
+}
+
 int
 main(
 	int			argc,
@@ -1405,9 +1443,6 @@ main(
 	__uint64_t		agsize;
 	xfs_alloc_rec_t		*arec;
 	struct xfs_btree_block	*block;
-	int			blflag;
-	int			blocklog;
-	int			bsflag;
 	int			bsize;
 	xfs_buf_t		*buf;
 	int			c;
@@ -1501,6 +1536,9 @@ main(
 		.rmapbt = false,
 		.reflink = false,
 	};
+	struct mkfs_xfs_opts params;
+
+	memset(&params, 0, sizeof(params));
 
 	platform_uuid_generate(&uuid);
 	progname = basename(argv[0]);
@@ -1508,8 +1546,8 @@ main(
 	bindtextdomain(PACKAGE, LOCALEDIR);
 	textdomain(PACKAGE);
 
-	blflag = bsflag = slflag = ssflag = lslflag = lssflag = 0;
-	blocklog = blocksize = 0;
+	slflag = ssflag = lslflag = lssflag = 0;
+	blocksize = 0;
 	sectorlog = lsectorlog = 0;
 	sectorsize = lsectorsize = 0;
 	agsize = daflag = dasize = dblocks = 0;
@@ -1541,26 +1579,7 @@ main(
 			break;
 		case 'b':
 			p = optarg;
-			while (*p != '\0') {
-				char	**subopts = (char **)bopts.subopts;
-				char	*value;
-
-				switch (getsubopt(&p, subopts, &value)) {
-				case B_LOG:
-					blocklog = getnum(value, &bopts, B_LOG);
-					blocksize = 1 << blocklog;
-					blflag = 1;
-					break;
-				case B_SIZE:
-					blocksize = getnum(value, &bopts,
-							   B_SIZE);
-					blocklog = libxfs_highbit32(blocksize);
-					bsflag = 1;
-					break;
-				default:
-					unknown('b', value);
-				}
-			}
+			parse_subopts(c, p, &params);
 			break;
 		case 'd':
 			p = optarg;
@@ -1941,8 +1960,8 @@ main(
 	 * For RAID4/5/6 we want to align sector size and block size,
 	 * so we need to start with the device geometry extraction too.
 	 */
-	if (!blflag && !bsflag) {
-		blocklog = XFS_DFL_BLOCKSIZE_LOG;
+	if (!params.blflag && !params.bsflag) {
+		params.blocklog = XFS_DFL_BLOCKSIZE_LOG;
 		blocksize = 1 << XFS_DFL_BLOCKSIZE_LOG;
 	}
 	if (blocksize < XFS_MIN_BLOCKSIZE || blocksize > XFS_MAX_BLOCKSIZE) {
@@ -2159,7 +2178,7 @@ _("rmapbt not supported with realtime devices\n"));
 		if (blocksize < (1 << XFS_MIN_REC_DIRSIZE))
 			dirblocklog = XFS_MIN_REC_DIRSIZE;
 		else
-			dirblocklog = blocklog;
+			dirblocklog = params.blocklog;
 		dirblocksize = 1 << dirblocklog;
 	}
 
@@ -2174,15 +2193,15 @@ _("rmapbt not supported with realtime devices\n"));
 				(long long)dbytes, XFS_MIN_BLOCKSIZE);
 			usage();
 		}
-		dblocks = (xfs_rfsblock_t)(dbytes >> blocklog);
+		dblocks = (xfs_rfsblock_t)(dbytes >> params.blocklog);
 		if (dbytes % blocksize)
 			fprintf(stderr, _("warning: "
 	"data length %lld not a multiple of %d, truncated to %lld\n"),
 				(long long)dbytes, blocksize,
-				(long long)(dblocks << blocklog));
+				(long long)(dblocks << params.blocklog));
 	}
 	if (ipflag) {
-		inodelog = blocklog - libxfs_highbit32(inopblock);
+		inodelog = params.blocklog - libxfs_highbit32(inopblock);
 		isize = 1 << inodelog;
 	} else if (!ilflag && !isflag) {
 		inodelog = sb_feat.crcs_enabled ? XFS_DINODE_DFL_CRC_LOG
@@ -2206,12 +2225,12 @@ _("rmapbt not supported with realtime devices\n"));
 				(long long)logbytes, XFS_MIN_BLOCKSIZE);
 			usage();
 		}
-		logblocks = (xfs_rfsblock_t)(logbytes >> blocklog);
+		logblocks = (xfs_rfsblock_t)(logbytes >> params.blocklog);
 		if (logbytes % blocksize)
 			fprintf(stderr,
 	_("warning: log length %lld not a multiple of %d, truncated to %lld\n"),
 				(long long)logbytes, blocksize,
-				(long long)(logblocks << blocklog));
+				(long long)(logblocks << params.blocklog));
 	}
 	if (rtsize) {
 		__uint64_t rtbytes;
@@ -2223,12 +2242,12 @@ _("rmapbt not supported with realtime devices\n"));
 				(long long)rtbytes, XFS_MIN_BLOCKSIZE);
 			usage();
 		}
-		rtblocks = (xfs_rfsblock_t)(rtbytes >> blocklog);
+		rtblocks = (xfs_rfsblock_t)(rtbytes >> params.blocklog);
 		if (rtbytes % blocksize)
 			fprintf(stderr,
 	_("warning: rt length %lld not a multiple of %d, truncated to %lld\n"),
 				(long long)rtbytes, blocksize,
-				(long long)(rtblocks << blocklog));
+				(long long)(rtblocks << params.blocklog));
 	}
 	/*
 	 * If specified, check rt extent size against its constraints.
@@ -2243,7 +2262,7 @@ _("rmapbt not supported with realtime devices\n"));
 				(long long)rtextbytes, blocksize);
 			usage();
 		}
-		rtextblocks = (xfs_extlen_t)(rtextbytes >> blocklog);
+		rtextblocks = (xfs_extlen_t)(rtextbytes >> params.blocklog);
 	} else {
 		/*
 		 * If realtime extsize has not been specified by the user,
@@ -2261,7 +2280,7 @@ _("rmapbt not supported with realtime devices\n"));
 		/* check that rswidth is a multiple of fs blocksize */
 		if (!norsflag && rswidth && !(BBTOB(rswidth) % blocksize)) {
 			rswidth = DTOBT(rswidth);
-			rtextbytes = rswidth << blocklog;
+			rtextbytes = rswidth << params.blocklog;
 			if (XFS_MIN_RTEXTSIZE <= rtextbytes &&
 			    (rtextbytes <= XFS_MAX_RTEXTSIZE)) {
 				rtextblocks = rswidth;
@@ -2269,7 +2288,7 @@ _("rmapbt not supported with realtime devices\n"));
 		}
 		if (!rtextblocks) {
 			rtextblocks = (blocksize < XFS_MIN_RTEXTSIZE) ?
-					XFS_MIN_RTEXTSIZE >> blocklog : 1;
+					XFS_MIN_RTEXTSIZE >> params.blocklog : 1;
 		}
 	}
 	ASSERT(rtextblocks);
@@ -2472,7 +2491,7 @@ reported by the device (%u).\n"),
 	} else if (daflag) {	/* User-specified AG count */
 		agsize = dblocks / agcount + (dblocks % agcount != 0);
 	} else {
-		calc_default_ag_geometry(blocklog, dblocks,
+		calc_default_ag_geometry(params.blocklog, dblocks,
 				dsunit | dswidth, &agsize, &agcount);
 	}
 
@@ -2494,18 +2513,18 @@ reported by the device (%u).\n"),
 			/*
 			 * Round up to stripe unit boundary. Also make sure
 			 * that agsize is still larger than
-			 * XFS_AG_MIN_BLOCKS(blocklog)
+			 * XFS_AG_MIN_BLOCKS(params.blocklog)
 		 	 */
 			tmp_agsize = ((agsize + (dsunit - 1))/ dsunit) * dsunit;
 			/*
 			 * Round down to stripe unit boundary if rounding up
 			 * created an AG size that is larger than the AG max.
 			 */
-			if (tmp_agsize > XFS_AG_MAX_BLOCKS(blocklog))
+			if (tmp_agsize > XFS_AG_MAX_BLOCKS(params.blocklog))
 				tmp_agsize = ((agsize) / dsunit) * dsunit;
 
-			if ((tmp_agsize >= XFS_AG_MIN_BLOCKS(blocklog)) &&
-			    (tmp_agsize <= XFS_AG_MAX_BLOCKS(blocklog))) {
+			if ((tmp_agsize >= XFS_AG_MIN_BLOCKS(params.blocklog)) &&
+			    (tmp_agsize <= XFS_AG_MAX_BLOCKS(params.blocklog))) {
 				agsize = tmp_agsize;
 				if (!daflag)
 					agcount = dblocks/agsize +
@@ -2522,7 +2541,7 @@ reported by the device (%u).\n"),
 					 * agsize is out of bounds, this will
 					 * print nice details & exit.
 					 */
-					validate_ag_geometry(blocklog, dblocks,
+					validate_ag_geometry(params.blocklog, dblocks,
 							    agsize, agcount);
 					exit(1);
 				}
@@ -2535,7 +2554,7 @@ reported by the device (%u).\n"),
 			 * does not happen.
 			 */
 			tmp_agsize = agsize - dsunit;
-			if (tmp_agsize < XFS_AG_MIN_BLOCKS(blocklog)) {
+			if (tmp_agsize < XFS_AG_MIN_BLOCKS(params.blocklog)) {
 				tmp_agsize = agsize + dsunit;
 				if (dblocks < agsize) {
 					/* oh well, nothing to do */
@@ -2557,7 +2576,7 @@ an AG size that is one stripe unit smaller, for example %llu.\n"),
 				 */
 				if ( dblocks % agsize != 0 &&
 				    (dblocks % agsize <
-				    XFS_AG_MIN_BLOCKS(blocklog))) {
+				    XFS_AG_MIN_BLOCKS(params.blocklog))) {
 					dblocks = (xfs_rfsblock_t)((agcount - 1) * agsize);
 					agcount--;
 					ASSERT(agcount != 0);
@@ -2582,17 +2601,17 @@ an AG size that is one stripe unit smaller, for example %llu.\n"),
 	 * and drop the blocks.
 	 */
 	if ( dblocks % agsize != 0 &&
-	     (dblocks % agsize < XFS_AG_MIN_BLOCKS(blocklog))) {
+	     (dblocks % agsize < XFS_AG_MIN_BLOCKS(params.blocklog))) {
 		ASSERT(!daflag);
 		dblocks = (xfs_rfsblock_t)((agcount - 1) * agsize);
 		agcount--;
 		ASSERT(agcount != 0);
 	}
 
-	validate_ag_geometry(blocklog, dblocks, agsize, agcount);
+	validate_ag_geometry(params.blocklog, dblocks, agsize, agcount);
 
 	if (!imflag)
-		imaxpct = calc_default_imaxpct(blocklog, dblocks);
+		imaxpct = calc_default_imaxpct(params.blocklog, dblocks);
 
 	/*
 	 * check that log sunit is modulo fsblksize or default it to dsunit.
@@ -2615,18 +2634,18 @@ an AG size that is one stripe unit smaller, for example %llu.\n"),
 			fprintf(stderr,
 	_("log stripe unit adjusted to 32KiB\n"));
 		}
-		lsunit = (32 * 1024) >> blocklog;
+		lsunit = (32 * 1024) >> params.blocklog;
 	}
 
 	min_logblocks = max_trans_res(agsize,
 				   sb_feat.crcs_enabled, sb_feat.dir_version,
-				   sectorlog, blocklog, inodelog, dirblocklog,
+				   sectorlog, params.blocklog, inodelog, dirblocklog,
 				   sb_feat.log_version, lsunit, sb_feat.finobt,
 				   sb_feat.rmapbt, sb_feat.reflink);
 	ASSERT(min_logblocks);
 	min_logblocks = MAX(XFS_MIN_LOG_BLOCKS, min_logblocks);
-	if (!logsize && dblocks >= (1024*1024*1024) >> blocklog)
-		min_logblocks = MAX(min_logblocks, XFS_MIN_LOG_BYTES>>blocklog);
+	if (!logsize && dblocks >= (1024*1024*1024) >> params.blocklog)
+		min_logblocks = MAX(min_logblocks, XFS_MIN_LOG_BYTES>>params.blocklog);
 	if (logsize && xi.logBBsize > 0 && logblocks > DTOBT(xi.logBBsize)) {
 		fprintf(stderr,
 _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
@@ -2646,17 +2665,17 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 		logblocks = 0;
 	} else if (loginternal && !logsize) {
 
-		if (dblocks < GIGABYTES(1, blocklog)) {
+		if (dblocks < GIGABYTES(1, params.blocklog)) {
 			/* tiny filesystems get minimum sized logs. */
 			logblocks = min_logblocks;
-		} else if (dblocks < GIGABYTES(16, blocklog)) {
+		} else if (dblocks < GIGABYTES(16, params.blocklog)) {
 
 			/*
 			 * For small filesystems, we want to use the
 			 * XFS_MIN_LOG_BYTES for filesystems smaller than 16G if
 			 * at all possible, ramping up to 128MB at 256GB.
 			 */
-			logblocks = MIN(XFS_MIN_LOG_BYTES >> blocklog,
+			logblocks = MIN(XFS_MIN_LOG_BYTES >> params.blocklog,
 					min_logblocks * XFS_DFL_LOG_FACTOR);
 		} else {
 			/*
@@ -2665,8 +2684,8 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 			 * max log size of 128M at 256GB fs size. IOWs,
 			 * the ratio of fs size to log size is 2048:1.
 			 */
-			logblocks = (dblocks << blocklog) / 2048;
-			logblocks = logblocks >> blocklog;
+			logblocks = (dblocks << params.blocklog) / 2048;
+			logblocks = logblocks >> params.blocklog;
 		}
 
 		/* Ensure the chosen size meets minimum log size requirements */
@@ -2678,18 +2697,18 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 
 		/* and now clamp the size to the maximum supported size */
 		logblocks = MIN(logblocks, XFS_MAX_LOG_BLOCKS);
-		if ((logblocks << blocklog) > XFS_MAX_LOG_BYTES)
-			logblocks = XFS_MAX_LOG_BYTES >> blocklog;
+		if ((logblocks << params.blocklog) > XFS_MAX_LOG_BYTES)
+			logblocks = XFS_MAX_LOG_BYTES >> params.blocklog;
 
 	}
-	validate_log_size(logblocks, blocklog, min_logblocks);
+	validate_log_size(logblocks, params.blocklog, min_logblocks);
 
 	protostring = setup_proto(protofile);
-	bsize = 1 << (blocklog - BBSHIFT);
+	bsize = 1 << (params.blocklog - BBSHIFT);
 	mp = &mbuf;
 	sbp = &mp->m_sb;
 	memset(mp, 0, sizeof(xfs_mount_t));
-	sbp->sb_blocklog = (__uint8_t)blocklog;
+	sbp->sb_blocklog = (__uint8_t)params.blocklog;
 	sbp->sb_sectlog = (__uint8_t)sectorlog;
 	sbp->sb_agblklog = (__uint8_t)libxfs_log2_roundup((unsigned int)agsize);
 	sbp->sb_agblocks = (xfs_agblock_t)agsize;
@@ -2713,7 +2732,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 					libxfs_alloc_ag_max_usable(mp));
 
 			/* revalidate the log size is valid if we changed it */
-			validate_log_size(logblocks, blocklog, min_logblocks);
+			validate_log_size(logblocks, params.blocklog, min_logblocks);
 		}
 		if (logblocks > agsize - libxfs_prealloc_blocks(mp)) {
 			fprintf(stderr,
@@ -2739,19 +2758,19 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 		if (lsunit) {
 			logstart = fixup_internal_log_stripe(mp,
 					lsflag, logstart, agsize, lsunit,
-					&logblocks, blocklog, &lalign);
+					&logblocks, params.blocklog, &lalign);
 		} else if (dsunit) {
 			logstart = fixup_internal_log_stripe(mp,
 					lsflag, logstart, agsize, dsunit,
-					&logblocks, blocklog, &lalign);
+					&logblocks, params.blocklog, &lalign);
 		}
 	} else {
 		logstart = 0;
 		if (lsunit)
 			fixup_log_stripe_unit(lsflag, lsunit,
-					&logblocks, blocklog);
+					&logblocks, params.blocklog);
 	}
-	validate_log_size(logblocks, blocklog, min_logblocks);
+	validate_log_size(logblocks, params.blocklog, min_logblocks);
 
 	if (!qflag || Nflag) {
 		printf(_(
@@ -2773,10 +2792,10 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 			"", dsunit, dswidth,
 			sb_feat.dir_version, dirblocksize, sb_feat.nci,
 				sb_feat.dirftype,
-			logfile, 1 << blocklog, (long long)logblocks,
+			logfile, 1 << params.blocklog, (long long)logblocks,
 			sb_feat.log_version, "", lsectorsize, lsunit,
 				sb_feat.lazy_sb_counters,
-			rtfile, rtextblocks << blocklog,
+			rtfile, rtextblocks << params.blocklog,
 			(long long)rtblocks, (long long)rtextents);
 		if (Nflag)
 			exit(0);
@@ -2803,7 +2822,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 	sbp->sb_inopblock = (__uint16_t)(blocksize / isize);
 	sbp->sb_sectlog = (__uint8_t)sectorlog;
 	sbp->sb_inodelog = (__uint8_t)inodelog;
-	sbp->sb_inopblog = (__uint8_t)(blocklog - inodelog);
+	sbp->sb_inopblog = (__uint8_t)(params.blocklog - inodelog);
 	sbp->sb_rextslog =
 		(__uint8_t)(rtextents ?
 			libxfs_highbit32((unsigned int)rtextents) : 0);
@@ -2818,7 +2837,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 	sbp->sb_qflags = 0;
 	sbp->sb_unit = dsunit;
 	sbp->sb_width = dswidth;
-	sbp->sb_dirblklog = dirblocklog - blocklog;
+	sbp->sb_dirblklog = dirblocklog - params.blocklog;
 	if (sb_feat.log_version == 2) {	/* This is stored in bytes */
 		lsunit = (lsunit == 0) ? 1 : XFS_FSB_TO_B(mp, lsunit);
 		sbp->sb_logsunit = lsunit;
@@ -2828,7 +2847,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 		int	cluster_size = XFS_INODE_BIG_CLUSTER_SIZE;
 		if (sb_feat.crcs_enabled)
 			cluster_size *= isize / XFS_DINODE_MIN_SIZE;
-		sbp->sb_inoalignmt = cluster_size >> blocklog;
+		sbp->sb_inoalignmt = cluster_size >> params.blocklog;
 		sb_feat.inode_align = sbp->sb_inoalignmt != 0;
 	} else
 		sbp->sb_inoalignmt = 0;
-- 
2.11.0

