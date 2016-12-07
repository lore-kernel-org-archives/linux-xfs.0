Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40790 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752785AbcLGNgn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 7 Dec 2016 08:36:43 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A2C1AC049D59
        for <linux-xfs@vger.kernel.org>; Wed,  7 Dec 2016 13:27:41 +0000 (UTC)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 01/22] mkfs: remove intermediate getstr followed by getnum
Date: Wed,  7 Dec 2016 14:27:08 +0100
Message-Id: <1481117249-21273-2-git-send-email-jtulak@redhat.com>
In-Reply-To: <1481117249-21273-1-git-send-email-jtulak@redhat.com>
References: <1481117249-21273-1-git-send-email-jtulak@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Jan Tulak <jtulak@redhat.com>

Some options loaded a number as a string with getstr and converted it to
number with getnum later in the code, without any reason for this approach.
(They were probably forgotten in some past cleaning.)

This patch changes them to skip the string and use getnum directly in the main
option-parsing loop, as do all the other numerical options.

And as we now have two variables of the same type for the same value,
merge them together. (e.g. former string dsize and number dbytes).

Signed-off-by: Jan Tulak <jtulak@redhat.com>
---
 mkfs/xfs_mkfs.c | 88 +++++++++++++++++++++++++--------------------------------
 1 file changed, 38 insertions(+), 50 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index affa405..b3bc218 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -1417,7 +1417,7 @@ main(
 	char			*dfile;
 	int			dirblocklog;
 	int			dirblocksize;
-	char			*dsize;
+	__uint64_t 		dbytes;
 	int			dsu;
 	int			dsw;
 	int			dsunit;
@@ -1441,7 +1441,7 @@ main(
 	xfs_rfsblock_t		logblocks;
 	char			*logfile;
 	int			loginternal;
-	char			*logsize;
+	__uint64_t 		logbytes;
 	xfs_fsblock_t		logstart;
 	int			lvflag;
 	int			lsflag;
@@ -1470,11 +1470,11 @@ main(
 	char			*protostring;
 	int			qflag;
 	xfs_rfsblock_t		rtblocks;
+	__uint64_t 		rtbytes;
 	xfs_extlen_t		rtextblocks;
 	xfs_rtblock_t		rtextents;
-	char			*rtextsize;
+	__uint64_t 		rtextbytes;
 	char			*rtfile;
-	char			*rtsize;
 	xfs_sb_t		*sbp;
 	int			sectorlog;
 	__uint64_t		sector_mask;
@@ -1522,7 +1522,8 @@ main(
 	qflag = 0;
 	imaxpct = inodelog = inopblock = isize = 0;
 	dfile = logfile = rtfile = NULL;
-	dsize = logsize = rtsize = rtextsize = protofile = NULL;
+	protofile = NULL;
+	rtbytes = rtextbytes = logbytes = dbytes = 0;
 	dsu = dsw = dsunit = dswidth = lalign = lsu = lsunit = 0;
 	nodsflag = norsflag = 0;
 	force_overwrite = 0;
@@ -1586,7 +1587,7 @@ main(
 					xi.dname = getstr(value, &dopts, D_NAME);
 					break;
 				case D_SIZE:
-					dsize = getstr(value, &dopts, D_SIZE);
+					dbytes = getnum(value, &dopts, D_SIZE);
 					break;
 				case D_SUNIT:
 					dsunit = getnum(value, &dopts, D_SUNIT);
@@ -1731,7 +1732,7 @@ main(
 					lvflag = 1;
 					break;
 				case L_SIZE:
-					logsize = getstr(value, &lopts, L_SIZE);
+					logbytes = getnum(value, &lopts, L_SIZE);
 					break;
 				case L_SECTLOG:
 					lsectorlog = getnum(value, &lopts,
@@ -1860,8 +1861,7 @@ main(
 
 				switch (getsubopt(&p, subopts, &value)) {
 				case R_EXTSIZE:
-					rtextsize = getstr(value, &ropts,
-							   R_EXTSIZE);
+					rtextbytes = getnum(value, &ropts, R_EXTSIZE);
 					break;
 				case R_FILE:
 					xi.risfile = getnum(value, &ropts,
@@ -1873,7 +1873,7 @@ main(
 							   R_NAME);
 					break;
 				case R_SIZE:
-					rtsize = getstr(value, &ropts, R_SIZE);
+					rtbytes = getnum(value, &ropts, R_SIZE);
 					break;
 				case R_NOALIGN:
 					norsflag = getnum(value, &ropts,
@@ -1976,14 +1976,14 @@ _("Minimum block size for CRC enabled filesystems is %d bytes.\n"),
 	 * sector size mismatches between the new filesystem and the underlying
 	 * host filesystem.
 	 */
-	check_device_type(dfile, &xi.disfile, !dsize, !dfile,
+	check_device_type(dfile, &xi.disfile, !dbytes, !dfile,
 			  Nflag ? NULL : &xi.dcreat, force_overwrite, "d");
 	if (!loginternal)
-		check_device_type(xi.logname, &xi.lisfile, !logsize, !xi.logname,
+		check_device_type(xi.logname, &xi.lisfile, !logbytes, !xi.logname,
 				  Nflag ? NULL : &xi.lcreat,
 				  force_overwrite, "l");
 	if (xi.rtname)
-		check_device_type(xi.rtname, &xi.risfile, !rtsize, !xi.rtname,
+		check_device_type(xi.rtname, &xi.risfile, !rtbytes, !xi.rtname,
 				  Nflag ? NULL : &xi.rcreat,
 				  force_overwrite, "r");
 	if (xi.disfile || xi.lisfile || xi.risfile)
@@ -2164,10 +2164,7 @@ _("rmapbt not supported with realtime devices\n"));
 	}
 
 
-	if (dsize) {
-		__uint64_t dbytes;
-
-		dbytes = getnum(dsize, &dopts, D_SIZE);
+	if (dbytes) {
 		if (dbytes % XFS_MIN_BLOCKSIZE) {
 			fprintf(stderr,
 			_("illegal data length %lld, not a multiple of %d\n"),
@@ -2196,10 +2193,7 @@ _("rmapbt not supported with realtime devices\n"));
 		usage();
 	}
 
-	if (logsize) {
-		__uint64_t logbytes;
-
-		logbytes = getnum(logsize, &lopts, L_SIZE);
+	if (logbytes) {
 		if (logbytes % XFS_MIN_BLOCKSIZE) {
 			fprintf(stderr,
 			_("illegal log length %lld, not a multiple of %d\n"),
@@ -2213,10 +2207,7 @@ _("rmapbt not supported with realtime devices\n"));
 				(long long)logbytes, blocksize,
 				(long long)(logblocks << blocklog));
 	}
-	if (rtsize) {
-		__uint64_t rtbytes;
-
-		rtbytes = getnum(rtsize, &ropts, R_SIZE);
+	if (rtbytes) {
 		if (rtbytes % XFS_MIN_BLOCKSIZE) {
 			fprintf(stderr,
 			_("illegal rt length %lld, not a multiple of %d\n"),
@@ -2233,10 +2224,7 @@ _("rmapbt not supported with realtime devices\n"));
 	/*
 	 * If specified, check rt extent size against its constraints.
 	 */
-	if (rtextsize) {
-		__uint64_t rtextbytes;
-
-		rtextbytes = getnum(rtextsize, &ropts, R_EXTSIZE);
+	if (rtextbytes) {
 		if (rtextbytes % blocksize) {
 			fprintf(stderr,
 		_("illegal rt extent size %lld, not a multiple of %d\n"),
@@ -2253,7 +2241,7 @@ _("rmapbt not supported with realtime devices\n"));
 		__uint64_t	rswidth;
 		__uint64_t	rtextbytes;
 
-		if (!norsflag && !xi.risfile && !(!rtsize && xi.disfile))
+		if (!norsflag && !xi.risfile && !(!rtbytes && xi.disfile))
 			rswidth = ft.rtswidth;
 		else
 			rswidth = 0;
@@ -2364,15 +2352,15 @@ _("rmapbt not supported with realtime devices\n"));
 		rtfile = _("volume rt");
 	else if (!xi.rtdev)
 		rtfile = _("none");
-	if (dsize && xi.dsize > 0 && dblocks > DTOBT(xi.dsize)) {
+	if (dbytes && xi.dsize > 0 && dblocks > DTOBT(xi.dsize)) {
 		fprintf(stderr,
-			_("size %s specified for data subvolume is too large, "
+			_("size %lld specified for data subvolume is too large, "
 			"maximum is %lld blocks\n"),
-			dsize, (long long)DTOBT(xi.dsize));
+			(long long)dbytes, (long long)DTOBT(xi.dsize));
 		usage();
-	} else if (!dsize && xi.dsize > 0)
+	} else if (!dbytes && xi.dsize > 0)
 		dblocks = DTOBT(xi.dsize);
-	else if (!dsize) {
+	else if (!dbytes) {
 		fprintf(stderr, _("can't get size of data subvolume\n"));
 		usage();
 	}
@@ -2405,22 +2393,22 @@ reported by the device (%u).\n"),
 reported by the device (%u).\n"),
 			lsectorsize, xi.lbsize);
 	}
-	if (rtsize && xi.rtsize > 0 && xi.rtbsize > sectorsize) {
+	if (rtbytes && xi.rtsize > 0 && xi.rtbsize > sectorsize) {
 		fprintf(stderr, _(
 "Warning: the realtime subvolume sector size %u is less than the sector size\n\
 reported by the device (%u).\n"),
 			sectorsize, xi.rtbsize);
 	}
 
-	if (rtsize && xi.rtsize > 0 && rtblocks > DTOBT(xi.rtsize)) {
+	if (rtbytes && xi.rtsize > 0 && rtblocks > DTOBT(xi.rtsize)) {
 		fprintf(stderr,
-			_("size %s specified for rt subvolume is too large, "
+			_("size %lld specified for rt subvolume is too large, "
 			"maximum is %lld blocks\n"),
-			rtsize, (long long)DTOBT(xi.rtsize));
+			(long long)rtbytes, (long long)DTOBT(xi.rtsize));
 		usage();
-	} else if (!rtsize && xi.rtsize > 0)
+	} else if (!rtbytes && xi.rtsize > 0)
 		rtblocks = DTOBT(xi.rtsize);
-	else if (rtsize && !xi.rtdev) {
+	else if (rtbytes && !xi.rtdev) {
 		fprintf(stderr,
 			_("size specified for non-existent rt subvolume\n"));
 		usage();
@@ -2625,26 +2613,26 @@ an AG size that is one stripe unit smaller, for example %llu.\n"),
 				   sb_feat.rmapbt, sb_feat.reflink);
 	ASSERT(min_logblocks);
 	min_logblocks = MAX(XFS_MIN_LOG_BLOCKS, min_logblocks);
-	if (!logsize && dblocks >= (1024*1024*1024) >> blocklog)
+	if (!logbytes && dblocks >= (1024*1024*1024) >> blocklog)
 		min_logblocks = MAX(min_logblocks, XFS_MIN_LOG_BYTES>>blocklog);
-	if (logsize && xi.logBBsize > 0 && logblocks > DTOBT(xi.logBBsize)) {
+	if (logbytes && xi.logBBsize > 0 && logblocks > DTOBT(xi.logBBsize)) {
 		fprintf(stderr,
-_("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
-			logsize, (long long)DTOBT(xi.logBBsize));
+_("size %lld specified for log subvolume is too large, maximum is %lld blocks\n"),
+			(long long)logbytes, (long long)DTOBT(xi.logBBsize));
 		usage();
-	} else if (!logsize && xi.logBBsize > 0) {
+	} else if (!logbytes && xi.logBBsize > 0) {
 		logblocks = DTOBT(xi.logBBsize);
-	} else if (logsize && !xi.logdev && !loginternal) {
+	} else if (logbytes && !xi.logdev && !loginternal) {
 		fprintf(stderr,
 			_("size specified for non-existent log subvolume\n"));
 		usage();
-	} else if (loginternal && logsize && logblocks >= dblocks) {
+	} else if (loginternal && logbytes && logblocks >= dblocks) {
 		fprintf(stderr, _("size %lld too large for internal log\n"),
 			(long long)logblocks);
 		usage();
 	} else if (!loginternal && !xi.logdev) {
 		logblocks = 0;
-	} else if (loginternal && !logsize) {
+	} else if (loginternal && !logbytes) {
 
 		if (dblocks < GIGABYTES(1, blocklog)) {
 			/* tiny filesystems get minimum sized logs. */
@@ -2708,7 +2696,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 		 * Readjust the log size to fit within an AG if it was sized
 		 * automatically.
 		 */
-		if (!logsize) {
+		if (!logbytes) {
 			logblocks = MIN(logblocks,
 					libxfs_alloc_ag_max_usable(mp));
 
-- 
2.8.1

