Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51666 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S942833AbdDTId5 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 20 Apr 2017 04:33:57 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B6BAE51EF4
        for <linux-xfs@vger.kernel.org>; Thu, 20 Apr 2017 08:33:56 +0000 (UTC)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 2/2 v2] mkfs: remove long long type casts
Date: Thu, 20 Apr 2017 10:33:54 +0200
Message-Id: <20170420083354.12621-1-jtulak@redhat.com>
In-Reply-To: <20170419153025.10368-2-jtulak@redhat.com>
References: <20170419153025.10368-2-jtulak@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Jan Tulak <jtulak@redhat.com>

We have uint64_T, why cast it to long long for prints? Just print it as
it is.

Signed-off-by: Jan Tulak <jtulak@redhat.com>

---
EDIT:
* __uint64_t -> uint64_t
* convert %lu to PRIu64

Signed-off-by: Jan Tulak <jtulak@redhat.com>
---
 mkfs/xfs_mkfs.c | 148 ++++++++++++++++++++++++++++----------------------------
 1 file changed, 74 insertions(+), 74 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 40a32be..83a04fc 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -916,9 +916,9 @@ fixup_log_stripe_unit(
 			}
 			*logblocks = tmp_logblocks;
 		} else {
-			fprintf(stderr, _("log size %lld is not a multiple "
+			fprintf(stderr, _("log size %"PRIu64" is not a multiple "
 					  "of the log stripe unit %d\n"),
-				(long long) *logblocks, sunit);
+				*logblocks, sunit);
 			usage();
 		}
 	}
@@ -945,7 +945,7 @@ fixup_internal_log_stripe(
 	if (*logblocks > agsize - XFS_FSB_TO_AGBNO(mp, logstart)) {
 		fprintf(stderr,
 			_("Due to stripe alignment, the internal log size "
-			"(%lld) is too large.\n"), (long long) *logblocks);
+			"(%"PRIu64") is too large.\n"), *logblocks);
 		fprintf(stderr, _("Must fit within an allocation group.\n"));
 		usage();
 	}
@@ -957,20 +957,20 @@ validate_log_size(uint64_t logblocks, int blocklog, int min_logblocks)
 {
 	if (logblocks < min_logblocks) {
 		fprintf(stderr,
-	_("log size %lld blocks too small, minimum size is %d blocks\n"),
-			(long long)logblocks, min_logblocks);
+	_("log size %"PRIu64" blocks too small, minimum size is %d blocks\n"),
+			logblocks, min_logblocks);
 		usage();
 	}
 	if (logblocks > XFS_MAX_LOG_BLOCKS) {
 		fprintf(stderr,
-	_("log size %lld blocks too large, maximum size is %lld blocks\n"),
-			(long long)logblocks, XFS_MAX_LOG_BLOCKS);
+	_("log size %"PRIu64" blocks too large, maximum size is %lld blocks\n"),
+			logblocks, XFS_MAX_LOG_BLOCKS);
 		usage();
 	}
 	if ((logblocks << blocklog) > XFS_MAX_LOG_BYTES) {
 		fprintf(stderr,
-	_("log size %lld bytes too large, maximum size is %lld bytes\n"),
-			(long long)(logblocks << blocklog), XFS_MAX_LOG_BYTES);
+	_("log size %"PRIu64" bytes too large, maximum size is %lld bytes\n"),
+			(logblocks << blocklog), XFS_MAX_LOG_BYTES);
 		usage();
 	}
 }
@@ -1006,43 +1006,43 @@ validate_ag_geometry(
 {
 	if (agsize < XFS_AG_MIN_BLOCKS(blocklog)) {
 		fprintf(stderr,
-	_("agsize (%lld blocks) too small, need at least %lld blocks\n"),
-			(long long)agsize,
-			(long long)XFS_AG_MIN_BLOCKS(blocklog));
+	_("agsize (%"PRIu64" blocks) too small, need at least %"PRIu64" blocks\n"),
+			agsize,
+			(uint64_t)XFS_AG_MIN_BLOCKS(blocklog));
 		usage();
 	}
 
 	if (agsize > XFS_AG_MAX_BLOCKS(blocklog)) {
 		fprintf(stderr,
-	_("agsize (%lld blocks) too big, maximum is %lld blocks\n"),
-			(long long)agsize,
-			(long long)XFS_AG_MAX_BLOCKS(blocklog));
+	_("agsize (%"PRIu64" blocks) too big, maximum is %"PRIu64" blocks\n"),
+			agsize,
+			(uint64_t)XFS_AG_MAX_BLOCKS(blocklog));
 		usage();
 	}
 
 	if (agsize > dblocks) {
 		fprintf(stderr,
-	_("agsize (%lld blocks) too big, data area is %lld blocks\n"),
-			(long long)agsize, (long long)dblocks);
+	_("agsize (%"PRIu64" blocks) too big, data area is %"PRIu64" blocks\n"),
+			agsize, dblocks);
 			usage();
 	}
 
 	if (agsize < XFS_AG_MIN_BLOCKS(blocklog)) {
 		fprintf(stderr,
-	_("too many allocation groups for size = %lld\n"),
-				(long long)agsize);
-		fprintf(stderr, _("need at most %lld allocation groups\n"),
-			(long long)(dblocks / XFS_AG_MIN_BLOCKS(blocklog) +
+	_("too many allocation groups for size = %"PRIu64"\n"),
+				agsize);
+		fprintf(stderr, _("need at most %"PRIu64" allocation groups\n"),
+			(uint64_t) (dblocks / XFS_AG_MIN_BLOCKS(blocklog) +
 				(dblocks % XFS_AG_MIN_BLOCKS(blocklog) != 0)));
 		usage();
 	}
 
 	if (agsize > XFS_AG_MAX_BLOCKS(blocklog)) {
 		fprintf(stderr,
-	_("too few allocation groups for size = %lld\n"), (long long)agsize);
+	_("too few allocation groups for size = %"PRIu64"\n"), agsize);
 		fprintf(stderr,
-	_("need at least %lld allocation groups\n"),
-		(long long)(dblocks / XFS_AG_MAX_BLOCKS(blocklog) +
+	_("need at least %"PRIu64" allocation groups\n"),
+		(uint64_t)(dblocks / XFS_AG_MAX_BLOCKS(blocklog) +
 			(dblocks % XFS_AG_MAX_BLOCKS(blocklog) != 0)));
 		usage();
 	}
@@ -1054,9 +1054,9 @@ validate_ag_geometry(
 	if ( dblocks % agsize != 0 &&
 	     (dblocks % agsize < XFS_AG_MIN_BLOCKS(blocklog))) {
 		fprintf(stderr,
-	_("last AG size %lld blocks too small, minimum size is %lld blocks\n"),
-			(long long)(dblocks % agsize),
-			(long long)XFS_AG_MIN_BLOCKS(blocklog));
+	_("last AG size %"PRIu64" blocks too small, minimum size is %"PRIu64" blocks\n"),
+			(dblocks % agsize),
+			(uint64_t)XFS_AG_MIN_BLOCKS(blocklog));
 		usage();
 	}
 
@@ -1065,8 +1065,8 @@ validate_ag_geometry(
 	 */
 	if (agcount > XFS_MAX_AGNUMBER + 1) {
 		fprintf(stderr,
-	_("%lld allocation groups is too many, maximum is %lld\n"),
-			(long long)agcount, (long long)XFS_MAX_AGNUMBER + 1);
+	_("%"PRIu64" allocation groups is too many, maximum is %"PRIu64"\n"),
+			agcount, (uint64_t)XFS_MAX_AGNUMBER + 1);
 		usage();
 	}
 }
@@ -2186,16 +2186,16 @@ _("rmapbt not supported with realtime devices\n"));
 		dbytes = getnum(dsize, &dopts, D_SIZE);
 		if (dbytes % XFS_MIN_BLOCKSIZE) {
 			fprintf(stderr,
-			_("illegal data length %lld, not a multiple of %d\n"),
-				(long long)dbytes, XFS_MIN_BLOCKSIZE);
+			_("illegal data length %"PRIu64", not a multiple of %d\n"),
+				dbytes, XFS_MIN_BLOCKSIZE);
 			usage();
 		}
 		dblocks = (xfs_rfsblock_t)(dbytes >> blocklog);
 		if (dbytes % blocksize)
 			fprintf(stderr, _("warning: "
-	"data length %lld not a multiple of %"PRIu64", truncated to %lld\n"),
-				(long long)dbytes, blocksize,
-				(long long)(dblocks << blocklog));
+	"data length %"PRIu64" not a multiple of %"PRIu64", truncated to %"PRIu64"\n"),
+				dbytes, blocksize,
+				(uint64_t)(dblocks << blocklog));
 	}
 	if (ipflag) {
 		inodelog = blocklog - libxfs_highbit32(inopblock);
@@ -2218,16 +2218,16 @@ _("rmapbt not supported with realtime devices\n"));
 		logbytes = getnum(logsize, &lopts, L_SIZE);
 		if (logbytes % XFS_MIN_BLOCKSIZE) {
 			fprintf(stderr,
-			_("illegal log length %lld, not a multiple of %d\n"),
-				(long long)logbytes, XFS_MIN_BLOCKSIZE);
+			_("illegal log length %"PRIu64", not a multiple of %d\n"),
+				logbytes, XFS_MIN_BLOCKSIZE);
 			usage();
 		}
 		logblocks = (xfs_rfsblock_t)(logbytes >> blocklog);
 		if (logbytes % blocksize)
 			fprintf(stderr,
-	_("warning: log length %lld not a multiple of %"PRIu64", truncated to %lld\n"),
-				(long long)logbytes, blocksize,
-				(long long)(logblocks << blocklog));
+	_("warning: log length %"PRIu64" not a multiple of %"PRIu64", truncated to %"PRIu64"\n"),
+				logbytes, blocksize,
+				(uint64_t)(logblocks << blocklog));
 	}
 	if (rtsize) {
 		uint64_t rtbytes;
@@ -2235,16 +2235,16 @@ _("rmapbt not supported with realtime devices\n"));
 		rtbytes = getnum(rtsize, &ropts, R_SIZE);
 		if (rtbytes % XFS_MIN_BLOCKSIZE) {
 			fprintf(stderr,
-			_("illegal rt length %lld, not a multiple of %d\n"),
-				(long long)rtbytes, XFS_MIN_BLOCKSIZE);
+			_("illegal rt length %"PRIu64", not a multiple of %d\n"),
+				rtbytes, XFS_MIN_BLOCKSIZE);
 			usage();
 		}
 		rtblocks = (xfs_rfsblock_t)(rtbytes >> blocklog);
 		if (rtbytes % blocksize)
 			fprintf(stderr,
-	_("warning: rt length %lld not a multiple of %"PRIu64", truncated to %lld\n"),
-				(long long)rtbytes, blocksize,
-				(long long)(rtblocks << blocklog));
+	_("warning: rt length %"PRIu64" not a multiple of %"PRIu64", truncated to %"PRIu64"\n"),
+				rtbytes, blocksize,
+				(uint64_t)(rtblocks << blocklog));
 	}
 	/*
 	 * If specified, check rt extent size against its constraints.
@@ -2255,8 +2255,8 @@ _("rmapbt not supported with realtime devices\n"));
 		rtextbytes = getnum(rtextsize, &ropts, R_EXTSIZE);
 		if (rtextbytes % blocksize) {
 			fprintf(stderr,
-		_("illegal rt extent size %lld, not a multiple of %"PRIu64"\n"),
-				(long long)rtextbytes, blocksize);
+		_("illegal rt extent size %"PRIu64", not a multiple of %"PRIu64"\n"),
+				rtextbytes, blocksize);
 			usage();
 		}
 		rtextblocks = (xfs_extlen_t)(rtextbytes >> blocklog);
@@ -2383,8 +2383,8 @@ _("rmapbt not supported with realtime devices\n"));
 	if (dsize && xi.dsize > 0 && dblocks > DTOBT(xi.dsize)) {
 		fprintf(stderr,
 			_("size %s specified for data subvolume is too large, "
-			"maximum is %lld blocks\n"),
-			dsize, (long long)DTOBT(xi.dsize));
+			"maximum is %"PRIu64" blocks\n"),
+			dsize, (uint64_t)DTOBT(xi.dsize));
 		usage();
 	} else if (!dsize && xi.dsize > 0)
 		dblocks = DTOBT(xi.dsize);
@@ -2394,8 +2394,8 @@ _("rmapbt not supported with realtime devices\n"));
 	}
 	if (dblocks < XFS_MIN_DATA_BLOCKS) {
 		fprintf(stderr,
-	_("size %lld of data subvolume is too small, minimum %d blocks\n"),
-			(long long)dblocks, XFS_MIN_DATA_BLOCKS);
+	_("size %"PRIu64" of data subvolume is too small, minimum %d blocks\n"),
+			dblocks, XFS_MIN_DATA_BLOCKS);
 		usage();
 	}
 
@@ -2431,8 +2431,8 @@ reported by the device (%u).\n"),
 	if (rtsize && xi.rtsize > 0 && rtblocks > DTOBT(xi.rtsize)) {
 		fprintf(stderr,
 			_("size %s specified for rt subvolume is too large, "
-			"maximum is %lld blocks\n"),
-			rtsize, (long long)DTOBT(xi.rtsize));
+			"maximum is %"PRIu64" blocks\n"),
+			rtsize, (uint64_t)DTOBT(xi.rtsize));
 		usage();
 	} else if (!rtsize && xi.rtsize > 0)
 		rtblocks = DTOBT(xi.rtsize);
@@ -2478,8 +2478,8 @@ reported by the device (%u).\n"),
 		 */
 		if (agsize % blocksize) {
 			fprintf(stderr,
-		_("agsize (%lld) not a multiple of fs blk size (%"PRIu64")\n"),
-				(long long)agsize, blocksize);
+		_("agsize (%"PRIu64") not a multiple of fs blk size (%"PRIu64")\n"),
+				agsize, blocksize);
 			usage();
 		}
 		agsize /= blocksize;
@@ -2528,8 +2528,8 @@ reported by the device (%u).\n"),
 						(dblocks % agsize != 0);
 				if (dasize)
 					fprintf(stderr,
-				_("agsize rounded to %lld, swidth = %"PRIu64"\n"),
-						(long long)agsize, dswidth);
+				_("agsize rounded to %"PRIu64", swidth = %"PRIu64"\n"),
+						agsize, dswidth);
 			} else {
 				if (nodsflag) {
 					dsunit = dswidth = 0;
@@ -2562,8 +2562,8 @@ reported by the device (%u).\n"),
 				fprintf(stderr, _(
 "Warning: AG size is a multiple of stripe width.  This can cause performance\n\
 problems by aligning all AGs on the same disk.  To avoid this, run mkfs with\n\
-an AG size that is one stripe unit smaller, for example %llu.\n"),
-					(unsigned long long)tmp_agsize);
+an AG size that is one stripe unit smaller, for example %"PRIu64".\n"),
+					tmp_agsize);
 			} else {
 				agsize = tmp_agsize;
 				agcount = dblocks/agsize + (dblocks % agsize != 0);
@@ -2645,8 +2645,8 @@ an AG size that is one stripe unit smaller, for example %llu.\n"),
 		min_logblocks = MAX(min_logblocks, XFS_MIN_LOG_BYTES>>blocklog);
 	if (logsize && xi.logBBsize > 0 && logblocks > DTOBT(xi.logBBsize)) {
 		fprintf(stderr,
-_("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
-			logsize, (long long)DTOBT(xi.logBBsize));
+_("size %s specified for log subvolume is too large, maximum is %"PRIu64" blocks\n"),
+			logsize, (uint64_t)DTOBT(xi.logBBsize));
 		usage();
 	} else if (!logsize && xi.logBBsize > 0) {
 		logblocks = DTOBT(xi.logBBsize);
@@ -2655,8 +2655,8 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 			_("size specified for non-existent log subvolume\n"));
 		usage();
 	} else if (loginternal && logsize && logblocks >= dblocks) {
-		fprintf(stderr, _("size %lld too large for internal log\n"),
-			(long long)logblocks);
+		fprintf(stderr, _("size %"PRIu64" too large for internal log\n"),
+			logblocks);
 		usage();
 	} else if (!loginternal && !xi.logdev) {
 		logblocks = 0;
@@ -2733,16 +2733,16 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 		}
 		if (logblocks > agsize - libxfs_prealloc_blocks(mp)) {
 			fprintf(stderr,
-	_("internal log size %lld too large, must fit in allocation group\n"),
-				(long long)logblocks);
+	_("internal log size %"PRIu64" too large, must fit in allocation group\n"),
+				logblocks);
 			usage();
 		}
 
 		if (laflag) {
 			if (logagno >= agcount) {
 				fprintf(stderr,
-		_("log ag number %d too large, must be less than %lld\n"),
-					logagno, (long long)agcount);
+		_("log ag number %d too large, must be less than %"PRIu64"\n"),
+					logagno, agcount);
 				usage();
 			}
 		} else
@@ -2771,29 +2771,29 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 
 	if (!qflag || Nflag) {
 		printf(_(
-		   "meta-data=%-22s isize=%-6lu agcount=%lld, agsize=%lld blks\n"
+		   "meta-data=%-22s isize=%-6lu agcount=%"PRIu64", agsize=%"PRIu64" blks\n"
 		   "         =%-22s sectsz=%-5lu attr=%u, projid32bit=%u\n"
 		   "         =%-22s crc=%-8u finobt=%u, sparse=%u, rmapbt=%u, reflink=%u\n"
-		   "data     =%-22s bsize=%-6lu blocks=%llu, imaxpct=%"PRIu64"\n"
+		   "data     =%-22s bsize=%-6lu blocks=%"PRIu64", imaxpct=%"PRIu64"\n"
 		   "         =%-22s sunit=%-6lu swidth=%"PRIu64" blks\n"
 		   "naming   =version %-14u bsize=%-6lu ascii-ci=%d ftype=%d\n"
-		   "log      =%-22s bsize=%-6d blocks=%lld, version=%d\n"
+		   "log      =%-22s bsize=%-6d blocks=%"PRIu64", version=%d\n"
 		   "         =%-22s sectsz=%-5lu sunit=%"PRIu64" blks, lazy-count=%d\n"
-		   "realtime =%-22s extsz=%-6d blocks=%lld, rtextents=%lld\n"),
-			dfile, isize, (long long)agcount, (long long)agsize,
+		   "realtime =%-22s extsz=%-6d blocks=%"PRIu64", rtextents=%"PRIu64"\n"),
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
2.1.4

