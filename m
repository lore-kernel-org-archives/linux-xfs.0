Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53590 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935271AbdDFOlx (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 6 Apr 2017 10:41:53 -0400
From: Jan Tulak <jtulak@redhat.com>
Subject: [RFC PATCH 2/2] mkfs: remove long long type casts
Date: Thu,  6 Apr 2017 16:41:39 +0200
Message-Id: <20170406144139.20284-2-jtulak@redhat.com>
In-Reply-To: <20170406144139.20284-1-jtulak@redhat.com>
References: <20170406144139.20284-1-jtulak@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: mcgrof@kernel.org, sandeen@sandeen.net, Jan Tulak <jtulak@redhat.com>

We have uint64, why cast it to long long for prints? Just print it as
it is.

Signed-off-by: Jan Tulak <jtulak@redhat.com>
---
 mkfs/xfs_mkfs.c | 144 ++++++++++++++++++++++++++++----------------------------
 1 file changed, 72 insertions(+), 72 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 71382f70..885b5c0a 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -900,9 +900,9 @@ fixup_log_stripe_unit(
 			}
 			*logblocks = tmp_logblocks;
 		} else {
-			fprintf(stderr, _("log size %lld is not a multiple "
+			fprintf(stderr, _("log size %lu is not a multiple "
 					  "of the log stripe unit %d\n"),
-				(long long) *logblocks, sunit);
+				*logblocks, sunit);
 			usage();
 		}
 	}
@@ -929,7 +929,7 @@ fixup_internal_log_stripe(
 	if (*logblocks > agsize - XFS_FSB_TO_AGBNO(mp, logstart)) {
 		fprintf(stderr,
 			_("Due to stripe alignment, the internal log size "
-			"(%lld) is too large.\n"), (long long) *logblocks);
+			"(%lu) is too large.\n"), *logblocks);
 		fprintf(stderr, _("Must fit within an allocation group.\n"));
 		usage();
 	}
@@ -941,20 +941,20 @@ validate_log_size(__uint64_t logblocks, int blocklog, int min_logblocks)
 {
 	if (logblocks < min_logblocks) {
 		fprintf(stderr,
-	_("log size %lld blocks too small, minimum size is %d blocks\n"),
-			(long long)logblocks, min_logblocks);
+	_("log size %lu blocks too small, minimum size is %d blocks\n"),
+			logblocks, min_logblocks);
 		usage();
 	}
 	if (logblocks > XFS_MAX_LOG_BLOCKS) {
 		fprintf(stderr,
-	_("log size %lld blocks too large, maximum size is %lld blocks\n"),
-			(long long)logblocks, XFS_MAX_LOG_BLOCKS);
+	_("log size %lu blocks too large, maximum size is %lld blocks\n"),
+			logblocks, XFS_MAX_LOG_BLOCKS);
 		usage();
 	}
 	if ((logblocks << blocklog) > XFS_MAX_LOG_BYTES) {
 		fprintf(stderr,
-	_("log size %lld bytes too large, maximum size is %lld bytes\n"),
-			(long long)(logblocks << blocklog), XFS_MAX_LOG_BYTES);
+	_("log size %lu bytes too large, maximum size is %lld bytes\n"),
+			(logblocks << blocklog), XFS_MAX_LOG_BYTES);
 		usage();
 	}
 }
@@ -990,43 +990,43 @@ validate_ag_geometry(
 {
 	if (agsize < XFS_AG_MIN_BLOCKS(blocklog)) {
 		fprintf(stderr,
-	_("agsize (%lld blocks) too small, need at least %lld blocks\n"),
-			(long long)agsize,
-			(long long)XFS_AG_MIN_BLOCKS(blocklog));
+	_("agsize (%lu blocks) too small, need at least %lu blocks\n"),
+			agsize,
+			(__uint64_t)XFS_AG_MIN_BLOCKS(blocklog));
 		usage();
 	}
 
 	if (agsize > XFS_AG_MAX_BLOCKS(blocklog)) {
 		fprintf(stderr,
-	_("agsize (%lld blocks) too big, maximum is %lld blocks\n"),
-			(long long)agsize,
-			(long long)XFS_AG_MAX_BLOCKS(blocklog));
+	_("agsize (%lu blocks) too big, maximum is %lu blocks\n"),
+			agsize,
+			(__uint64_t)XFS_AG_MAX_BLOCKS(blocklog));
 		usage();
 	}
 
 	if (agsize > dblocks) {
 		fprintf(stderr,
-	_("agsize (%lld blocks) too big, data area is %lld blocks\n"),
-			(long long)agsize, (long long)dblocks);
+	_("agsize (%lu blocks) too big, data area is %lu blocks\n"),
+			agsize, dblocks);
 			usage();
 	}
 
 	if (agsize < XFS_AG_MIN_BLOCKS(blocklog)) {
 		fprintf(stderr,
-	_("too many allocation groups for size = %lld\n"),
-				(long long)agsize);
-		fprintf(stderr, _("need at most %lld allocation groups\n"),
-			(long long)(dblocks / XFS_AG_MIN_BLOCKS(blocklog) +
+	_("too many allocation groups for size = %lu\n"),
+				agsize);
+		fprintf(stderr, _("need at most %lu allocation groups\n"),
+			(__uint64_t) (dblocks / XFS_AG_MIN_BLOCKS(blocklog) +
 				(dblocks % XFS_AG_MIN_BLOCKS(blocklog) != 0)));
 		usage();
 	}
 
 	if (agsize > XFS_AG_MAX_BLOCKS(blocklog)) {
 		fprintf(stderr,
-	_("too few allocation groups for size = %lld\n"), (long long)agsize);
+	_("too few allocation groups for size = %lu\n"), agsize);
 		fprintf(stderr,
-	_("need at least %lld allocation groups\n"),
-		(long long)(dblocks / XFS_AG_MAX_BLOCKS(blocklog) +
+	_("need at least %lu allocation groups\n"),
+		(__uint64_t)(dblocks / XFS_AG_MAX_BLOCKS(blocklog) +
 			(dblocks % XFS_AG_MAX_BLOCKS(blocklog) != 0)));
 		usage();
 	}
@@ -1038,9 +1038,9 @@ validate_ag_geometry(
 	if ( dblocks % agsize != 0 &&
 	     (dblocks % agsize < XFS_AG_MIN_BLOCKS(blocklog))) {
 		fprintf(stderr,
-	_("last AG size %lld blocks too small, minimum size is %lld blocks\n"),
-			(long long)(dblocks % agsize),
-			(long long)XFS_AG_MIN_BLOCKS(blocklog));
+	_("last AG size %lu blocks too small, minimum size is %lu blocks\n"),
+			(dblocks % agsize),
+			(__uint64_t)XFS_AG_MIN_BLOCKS(blocklog));
 		usage();
 	}
 
@@ -1049,8 +1049,8 @@ validate_ag_geometry(
 	 */
 	if (agcount > XFS_MAX_AGNUMBER + 1) {
 		fprintf(stderr,
-	_("%lld allocation groups is too many, maximum is %lld\n"),
-			(long long)agcount, (long long)XFS_MAX_AGNUMBER + 1);
+	_("%lu allocation groups is too many, maximum is %lu\n"),
+			agcount, (__uint64_t)XFS_MAX_AGNUMBER + 1);
 		usage();
 	}
 }
@@ -2170,16 +2170,16 @@ _("rmapbt not supported with realtime devices\n"));
 		dbytes = getnum(dsize, &dopts, D_SIZE);
 		if (dbytes % XFS_MIN_BLOCKSIZE) {
 			fprintf(stderr,
-			_("illegal data length %lld, not a multiple of %d\n"),
-				(long long)dbytes, XFS_MIN_BLOCKSIZE);
+			_("illegal data length %lu, not a multiple of %d\n"),
+				dbytes, XFS_MIN_BLOCKSIZE);
 			usage();
 		}
 		dblocks = (xfs_rfsblock_t)(dbytes >> blocklog);
 		if (dbytes % blocksize)
 			fprintf(stderr, _("warning: "
-	"data length %lld not a multiple of %lu, truncated to %lld\n"),
-				(long long)dbytes, blocksize,
-				(long long)(dblocks << blocklog));
+	"data length %lu not a multiple of %lu, truncated to %lu\n"),
+				dbytes, blocksize,
+				(__uint64_t)(dblocks << blocklog));
 	}
 	if (ipflag) {
 		inodelog = blocklog - libxfs_highbit32(inopblock);
@@ -2202,16 +2202,16 @@ _("rmapbt not supported with realtime devices\n"));
 		logbytes = getnum(logsize, &lopts, L_SIZE);
 		if (logbytes % XFS_MIN_BLOCKSIZE) {
 			fprintf(stderr,
-			_("illegal log length %lld, not a multiple of %d\n"),
-				(long long)logbytes, XFS_MIN_BLOCKSIZE);
+			_("illegal log length %lu, not a multiple of %d\n"),
+				logbytes, XFS_MIN_BLOCKSIZE);
 			usage();
 		}
 		logblocks = (xfs_rfsblock_t)(logbytes >> blocklog);
 		if (logbytes % blocksize)
 			fprintf(stderr,
-	_("warning: log length %lld not a multiple of %lu, truncated to %lld\n"),
-				(long long)logbytes, blocksize,
-				(long long)(logblocks << blocklog));
+	_("warning: log length %lu not a multiple of %lu, truncated to %lu\n"),
+				logbytes, blocksize,
+				(__uint64_t)(logblocks << blocklog));
 	}
 	if (rtsize) {
 		__uint64_t rtbytes;
@@ -2219,16 +2219,16 @@ _("rmapbt not supported with realtime devices\n"));
 		rtbytes = getnum(rtsize, &ropts, R_SIZE);
 		if (rtbytes % XFS_MIN_BLOCKSIZE) {
 			fprintf(stderr,
-			_("illegal rt length %lld, not a multiple of %d\n"),
-				(long long)rtbytes, XFS_MIN_BLOCKSIZE);
+			_("illegal rt length %lu, not a multiple of %d\n"),
+				rtbytes, XFS_MIN_BLOCKSIZE);
 			usage();
 		}
 		rtblocks = (xfs_rfsblock_t)(rtbytes >> blocklog);
 		if (rtbytes % blocksize)
 			fprintf(stderr,
-	_("warning: rt length %lld not a multiple of %lu, truncated to %lld\n"),
-				(long long)rtbytes, blocksize,
-				(long long)(rtblocks << blocklog));
+	_("warning: rt length %lu not a multiple of %lu, truncated to %lu\n"),
+				rtbytes, blocksize,
+				(__uint64_t)(rtblocks << blocklog));
 	}
 	/*
 	 * If specified, check rt extent size against its constraints.
@@ -2239,8 +2239,8 @@ _("rmapbt not supported with realtime devices\n"));
 		rtextbytes = getnum(rtextsize, &ropts, R_EXTSIZE);
 		if (rtextbytes % blocksize) {
 			fprintf(stderr,
-		_("illegal rt extent size %lld, not a multiple of %lu\n"),
-				(long long)rtextbytes, blocksize);
+		_("illegal rt extent size %lu, not a multiple of %lu\n"),
+				rtextbytes, blocksize);
 			usage();
 		}
 		rtextblocks = (xfs_extlen_t)(rtextbytes >> blocklog);
@@ -2367,8 +2367,8 @@ _("rmapbt not supported with realtime devices\n"));
 	if (dsize && xi.dsize > 0 && dblocks > DTOBT(xi.dsize)) {
 		fprintf(stderr,
 			_("size %s specified for data subvolume is too large, "
-			"maximum is %lld blocks\n"),
-			dsize, (long long)DTOBT(xi.dsize));
+			"maximum is %lu blocks\n"),
+			dsize, (__uint64_t)DTOBT(xi.dsize));
 		usage();
 	} else if (!dsize && xi.dsize > 0)
 		dblocks = DTOBT(xi.dsize);
@@ -2378,8 +2378,8 @@ _("rmapbt not supported with realtime devices\n"));
 	}
 	if (dblocks < XFS_MIN_DATA_BLOCKS) {
 		fprintf(stderr,
-	_("size %lld of data subvolume is too small, minimum %d blocks\n"),
-			(long long)dblocks, XFS_MIN_DATA_BLOCKS);
+	_("size %lu of data subvolume is too small, minimum %d blocks\n"),
+			dblocks, XFS_MIN_DATA_BLOCKS);
 		usage();
 	}
 
@@ -2415,8 +2415,8 @@ reported by the device (%u).\n"),
 	if (rtsize && xi.rtsize > 0 && rtblocks > DTOBT(xi.rtsize)) {
 		fprintf(stderr,
 			_("size %s specified for rt subvolume is too large, "
-			"maximum is %lld blocks\n"),
-			rtsize, (long long)DTOBT(xi.rtsize));
+			"maximum is %lu blocks\n"),
+			rtsize, (__uint64_t)DTOBT(xi.rtsize));
 		usage();
 	} else if (!rtsize && xi.rtsize > 0)
 		rtblocks = DTOBT(xi.rtsize);
@@ -2462,8 +2462,8 @@ reported by the device (%u).\n"),
 		 */
 		if (agsize % blocksize) {
 			fprintf(stderr,
-		_("agsize (%lld) not a multiple of fs blk size (%lu)\n"),
-				(long long)agsize, blocksize);
+		_("agsize (%lu) not a multiple of fs blk size (%lu)\n"),
+				agsize, blocksize);
 			usage();
 		}
 		agsize /= blocksize;
@@ -2512,8 +2512,8 @@ reported by the device (%u).\n"),
 						(dblocks % agsize != 0);
 				if (dasize)
 					fprintf(stderr,
-				_("agsize rounded to %lld, swidth = %lu\n"),
-						(long long)agsize, dswidth);
+				_("agsize rounded to %lu, swidth = %lu\n"),
+						agsize, dswidth);
 			} else {
 				if (nodsflag) {
 					dsunit = dswidth = 0;
@@ -2629,8 +2629,8 @@ an AG size that is one stripe unit smaller, for example %llu.\n"),
 		min_logblocks = MAX(min_logblocks, XFS_MIN_LOG_BYTES>>blocklog);
 	if (logsize && xi.logBBsize > 0 && logblocks > DTOBT(xi.logBBsize)) {
 		fprintf(stderr,
-_("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
-			logsize, (long long)DTOBT(xi.logBBsize));
+_("size %s specified for log subvolume is too large, maximum is %lu blocks\n"),
+			logsize, (__uint64_t)DTOBT(xi.logBBsize));
 		usage();
 	} else if (!logsize && xi.logBBsize > 0) {
 		logblocks = DTOBT(xi.logBBsize);
@@ -2639,8 +2639,8 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 			_("size specified for non-existent log subvolume\n"));
 		usage();
 	} else if (loginternal && logsize && logblocks >= dblocks) {
-		fprintf(stderr, _("size %lld too large for internal log\n"),
-			(long long)logblocks);
+		fprintf(stderr, _("size %lu too large for internal log\n"),
+			logblocks);
 		usage();
 	} else if (!loginternal && !xi.logdev) {
 		logblocks = 0;
@@ -2717,16 +2717,16 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 		}
 		if (logblocks > agsize - libxfs_prealloc_blocks(mp)) {
 			fprintf(stderr,
-	_("internal log size %lld too large, must fit in allocation group\n"),
-				(long long)logblocks);
+	_("internal log size %lu too large, must fit in allocation group\n"),
+				logblocks);
 			usage();
 		}
 
 		if (laflag) {
 			if (logagno >= agcount) {
 				fprintf(stderr,
-		_("log ag number %d too large, must be less than %lld\n"),
-					logagno, (long long)agcount);
+		_("log ag number %d too large, must be less than %lu\n"),
+					logagno, agcount);
 				usage();
 			}
 		} else
@@ -2755,29 +2755,29 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 
 	if (!qflag || Nflag) {
 		printf(_(
-		   "meta-data=%-22s isize=%-6lu agcount=%lld, agsize=%lld blks\n"
+		   "meta-data=%-22s isize=%-6lu agcount=%lu, agsize=%lu blks\n"
 		   "         =%-22s sectsz=%-5lu attr=%u, projid32bit=%u\n"
 		   "         =%-22s crc=%-8u finobt=%u, sparse=%u, rmapbt=%u, reflink=%u\n"
-		   "data     =%-22s bsize=%-6lu blocks=%llu, imaxpct=%lu\n"
+		   "data     =%-22s bsize=%-6lu blocks=%lu, imaxpct=%lu\n"
 		   "         =%-22s sunit=%-6lu swidth=%lu blks\n"
 		   "naming   =version %-14u bsize=%-6lu ascii-ci=%d ftype=%d\n"
-		   "log      =%-22s bsize=%-6d blocks=%lld, version=%d\n"
+		   "log      =%-22s bsize=%-6d blocks=%lu, version=%d\n"
 		   "         =%-22s sectsz=%-5lu sunit=%lu blks, lazy-count=%d\n"
-		   "realtime =%-22s extsz=%-6d blocks=%lld, rtextents=%lld\n"),
-			dfile, isize, (long long)agcount, (long long)agsize,
+		   "realtime =%-22s extsz=%-6d blocks=%lu, rtextents=%lu\n"),
+			dfile, isize, agcount, agsize,
 			"", sectorsize, sb_feat.attr_version,
 				    !sb_feat.projid16bit,
 			"", sb_feat.crcs_enabled, sb_feat.finobt, sb_feat.spinodes,
 			sb_feat.rmapbt, sb_feat.reflink,
-			"", blocksize, (long long)dblocks, imaxpct,
+			"", blocksize, dblocks, imaxpct,
 			"", dsunit, dswidth,
 			sb_feat.dir_version, dirblocksize, sb_feat.nci,
 				sb_feat.dirftype,
-			logfile, 1 << blocklog, (long long)logblocks,
+			logfile, 1 << blocklog, logblocks,
 			sb_feat.log_version, "", lsectorsize, lsunit,
 				sb_feat.lazy_sb_counters,
 			rtfile, rtextblocks << blocklog,
-			(long long)rtblocks, (long long)rtextents);
+			rtblocks, rtextents);
 		if (Nflag)
 			exit(0);
 	}
-- 
2.12.1

