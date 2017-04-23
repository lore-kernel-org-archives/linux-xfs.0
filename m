Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49174 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1163236AbdDWSzL (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 23 Apr 2017 14:55:11 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 78F3D80E79
        for <linux-xfs@vger.kernel.org>; Sun, 23 Apr 2017 18:55:11 +0000 (UTC)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 03/12] mkfs: remove intermediate getstr followed by getnum
Date: Sun, 23 Apr 2017 20:54:54 +0200
Message-Id: <20170423185503.31415-4-jtulak@redhat.com>
In-Reply-To: <20170423185503.31415-1-jtulak@redhat.com>
References: <20170423185503.31415-1-jtulak@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Jan Tulak <jtulak@redhat.com>

Some options loaded a number as a string with getstr and converted it to
number with getnum later in the code, without any reason for this
approach.  (They were probably forgotten in some past cleaning.)

This patch changes them to skip the string and use getnum directly in
the main option-parsing loop, as do all the other numerical options.

And as we now have two variables of the same type for the same value,
merge them together. (e.g. former string dsize and number dbytes).

Signed-off-by: Jan Tulak <jtulak@redhat.com>
---
CHANGES:
* The first patch now ensures that we still have the raw input and
  we are not changing the form of user input (i.e. size stays in given
  units...)

 mkfs/xfs_mkfs.c | 88 ++++++++++++++++++++++++++-------------------------------
 1 file changed, 40 insertions(+), 48 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 0a795a6..7a72b11 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -1363,6 +1363,7 @@ getnum(
 	uint64_t		c;
 
 	check_opt(opts, index, false);
+	set_conf_raw(opts, index, str);
 	/* empty strings might just return a default value */
 	if (!str || *str == '\0') {
 		if (sp->flagval == SUBOPT_NEEDS_VAL)
@@ -1450,7 +1451,7 @@ main(
 	char			*dfile;
 	uint64_t		dirblocklog;
 	uint64_t		dirblocksize;
-	char			*dsize;
+	uint64_t		dbytes;
 	uint64_t		dsu;
 	uint64_t		dsw;
 	uint64_t		dsunit;
@@ -1474,7 +1475,7 @@ main(
 	xfs_rfsblock_t		logblocks;
 	char			*logfile;
 	uint64_t		loginternal;
-	char			*logsize;
+	uint64_t		logbytes;
 	xfs_fsblock_t		logstart;
 	bool			lvflag;
 	bool			lsflag;
@@ -1503,11 +1504,11 @@ main(
 	char			*protostring;
 	bool			qflag;
 	xfs_rfsblock_t		rtblocks;
+	uint64_t		rtbytes;
 	xfs_extlen_t		rtextblocks;
 	xfs_rtblock_t		rtextents;
-	char			*rtextsize;
+	uint64_t		rtextbytes;
 	char			*rtfile;
-	char			*rtsize;
 	xfs_sb_t		*sbp;
 	uint64_t		sectorlog;
 	uint64_t		sector_mask;
@@ -1555,7 +1556,8 @@ main(
 	qflag = false;
 	imaxpct = inodelog = inopblock = isize = 0;
 	dfile = logfile = rtfile = NULL;
-	dsize = logsize = rtsize = rtextsize = protofile = NULL;
+	protofile = NULL;
+	rtbytes = rtextbytes = logbytes = dbytes = 0;
 	dsu = dsw = dsunit = dswidth = lalign = lsu = lsunit = 0;
 	nodsflag = norsflag = false;
 	force_overwrite = false;
@@ -1619,7 +1621,7 @@ main(
 					xi.dname = getstr(value, &dopts, D_NAME);
 					break;
 				case D_SIZE:
-					dsize = getstr(value, &dopts, D_SIZE);
+					dbytes = getnum(value, &dopts, D_SIZE);
 					break;
 				case D_SUNIT:
 					dsunit = getnum(value, &dopts, D_SUNIT);
@@ -1764,7 +1766,7 @@ main(
 					lvflag = 1;
 					break;
 				case L_SIZE:
-					logsize = getstr(value, &lopts, L_SIZE);
+					logbytes = getnum(value, &lopts, L_SIZE);
 					break;
 				case L_SECTLOG:
 					lsectorlog = getnum(value, &lopts,
@@ -1893,8 +1895,7 @@ main(
 
 				switch (getsubopt(&p, subopts, &value)) {
 				case R_EXTSIZE:
-					rtextsize = getstr(value, &ropts,
-							   R_EXTSIZE);
+					rtextbytes = getnum(value, &ropts, R_EXTSIZE);
 					break;
 				case R_FILE:
 					xi.risfile = getnum(value, &ropts,
@@ -1906,7 +1907,7 @@ main(
 							   R_NAME);
 					break;
 				case R_SIZE:
-					rtsize = getstr(value, &ropts, R_SIZE);
+					rtbytes = getnum(value, &ropts, R_SIZE);
 					break;
 				case R_NOALIGN:
 					norsflag = getnum(value, &ropts,
@@ -2009,14 +2010,14 @@ _("Minimum block size for CRC enabled filesystems is %d bytes.\n"),
 	 * sector size mismatches between the new filesystem and the underlying
 	 * host filesystem.
 	 */
-	check_device_type(dfile, &xi.disfile, !dsize, !dfile,
+	check_device_type(dfile, &xi.disfile, !dbytes, !dfile,
 			  Nflag ? NULL : &xi.dcreat, force_overwrite, "d");
 	if (!loginternal)
-		check_device_type(xi.logname, &xi.lisfile, !logsize, !xi.logname,
-				  Nflag ? NULL : &xi.lcreat,
+		check_device_type(xi.logname, &xi.lisfile, !logbytes,
+				  !xi.logname, Nflag ? NULL : &xi.lcreat,
 				  force_overwrite, "l");
 	if (xi.rtname)
-		check_device_type(xi.rtname, &xi.risfile, !rtsize, !xi.rtname,
+		check_device_type(xi.rtname, &xi.risfile, !rtbytes, !xi.rtname,
 				  Nflag ? NULL : &xi.rcreat,
 				  force_overwrite, "r");
 	if (xi.disfile || xi.lisfile || xi.risfile)
@@ -2197,10 +2198,7 @@ _("rmapbt not supported with realtime devices\n"));
 	}
 
 
-	if (dsize) {
-		uint64_t dbytes;
-
-		dbytes = getnum(dsize, &dopts, D_SIZE);
+	if (dbytes) {
 		if (dbytes % XFS_MIN_BLOCKSIZE) {
 			fprintf(stderr,
 			_("illegal data length %"PRIu64", not a multiple of %d\n"),
@@ -2229,10 +2227,7 @@ _("rmapbt not supported with realtime devices\n"));
 		usage();
 	}
 
-	if (logsize) {
-		uint64_t logbytes;
-
-		logbytes = getnum(logsize, &lopts, L_SIZE);
+	if (logbytes) {
 		if (logbytes % XFS_MIN_BLOCKSIZE) {
 			fprintf(stderr,
 			_("illegal log length %"PRIu64", not a multiple of %d\n"),
@@ -2246,10 +2241,7 @@ _("rmapbt not supported with realtime devices\n"));
 				logbytes, blocksize,
 				(uint64_t)(logblocks << blocklog));
 	}
-	if (rtsize) {
-		uint64_t rtbytes;
-
-		rtbytes = getnum(rtsize, &ropts, R_SIZE);
+	if (rtbytes) {
 		if (rtbytes % XFS_MIN_BLOCKSIZE) {
 			fprintf(stderr,
 			_("illegal rt length %"PRIu64", not a multiple of %d\n"),
@@ -2266,10 +2258,7 @@ _("rmapbt not supported with realtime devices\n"));
 	/*
 	 * If specified, check rt extent size against its constraints.
 	 */
-	if (rtextsize) {
-		uint64_t rtextbytes;
-
-		rtextbytes = getnum(rtextsize, &ropts, R_EXTSIZE);
+	if (rtextbytes) {
 		if (rtextbytes % blocksize) {
 			fprintf(stderr,
 		_("illegal rt extent size %"PRIu64", not a multiple of %"PRIu64"\n"),
@@ -2286,7 +2275,7 @@ _("rmapbt not supported with realtime devices\n"));
 		uint64_t	rswidth;
 		uint64_t	rtextbytes;
 
-		if (!norsflag && !xi.risfile && !(!rtsize && xi.disfile))
+		if (!norsflag && !xi.risfile && !(!rtbytes && xi.disfile))
 			rswidth = ft.rtswidth;
 		else
 			rswidth = 0;
@@ -2397,15 +2386,16 @@ _("rmapbt not supported with realtime devices\n"));
 		rtfile = _("volume rt");
 	else if (!xi.rtdev)
 		rtfile = _("none");
-	if (dsize && xi.dsize > 0 && dblocks > DTOBT(xi.dsize)) {
+	if (dbytes && xi.dsize > 0 && dblocks > DTOBT(xi.dsize)) {
 		fprintf(stderr,
 			_("size %s specified for data subvolume is too large, "
 			"maximum is %"PRIu64" blocks\n"),
-			dsize, (uint64_t)DTOBT(xi.dsize));
+			get_conf_raw(&dopts, D_SIZE),
+			(uint64_t)DTOBT(xi.dsize));
 		usage();
-	} else if (!dsize && xi.dsize > 0)
+	} else if (!dbytes && xi.dsize > 0)
 		dblocks = DTOBT(xi.dsize);
-	else if (!dsize) {
+	else if (!dbytes) {
 		fprintf(stderr, _("can't get size of data subvolume\n"));
 		usage();
 	}
@@ -2438,22 +2428,23 @@ reported by the device (%u).\n"),
 reported by the device (%u).\n"),
 			lsectorsize, xi.lbsize);
 	}
-	if (rtsize && xi.rtsize > 0 && xi.rtbsize > sectorsize) {
+	if (rtbytes && xi.rtsize > 0 && xi.rtbsize > sectorsize) {
 		fprintf(stderr, _(
 "Warning: the realtime subvolume sector size %"PRIu64" is less than the sector size\n\
 reported by the device (%u).\n"),
 			sectorsize, xi.rtbsize);
 	}
 
-	if (rtsize && xi.rtsize > 0 && rtblocks > DTOBT(xi.rtsize)) {
+	if (rtbytes && xi.rtsize > 0 && rtblocks > DTOBT(xi.rtsize)) {
 		fprintf(stderr,
 			_("size %s specified for rt subvolume is too large, "
 			"maximum is %"PRIu64" blocks\n"),
-			rtsize, (uint64_t)DTOBT(xi.rtsize));
+			get_conf_raw(&ropts, R_SIZE),
+			(uint64_t)DTOBT(xi.rtsize));
 		usage();
-	} else if (!rtsize && xi.rtsize > 0)
+	} else if (!rtbytes && xi.rtsize > 0)
 		rtblocks = DTOBT(xi.rtsize);
-	else if (rtsize && !xi.rtdev) {
+	else if (rtbytes && !xi.rtdev) {
 		fprintf(stderr,
 			_("size specified for non-existent rt subvolume\n"));
 		usage();
@@ -2658,26 +2649,27 @@ an AG size that is one stripe unit smaller, for example %"PRIu64".\n"),
 				   sb_feat.rmapbt, sb_feat.reflink);
 	ASSERT(min_logblocks);
 	min_logblocks = MAX(XFS_MIN_LOG_BLOCKS, min_logblocks);
-	if (!logsize && dblocks >= (1024*1024*1024) >> blocklog)
+	if (!logbytes && dblocks >= (1024*1024*1024) >> blocklog)
 		min_logblocks = MAX(min_logblocks, XFS_MIN_LOG_BYTES>>blocklog);
-	if (logsize && xi.logBBsize > 0 && logblocks > DTOBT(xi.logBBsize)) {
+	if (logbytes && xi.logBBsize > 0 && logblocks > DTOBT(xi.logBBsize)) {
 		fprintf(stderr,
 _("size %s specified for log subvolume is too large, maximum is %"PRIu64" blocks\n"),
-			logsize, (uint64_t)DTOBT(xi.logBBsize));
+			get_conf_raw(&lopts, L_SIZE),
+			(uint64_t)DTOBT(xi.logBBsize));
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
 		fprintf(stderr, _("size %"PRIu64" too large for internal log\n"),
 			logblocks);
 		usage();
 	} else if (!loginternal && !xi.logdev) {
 		logblocks = 0;
-	} else if (loginternal && !logsize) {
+	} else if (loginternal && !logbytes) {
 
 		if (dblocks < GIGABYTES(1, blocklog)) {
 			/* tiny filesystems get minimum sized logs. */
@@ -2741,7 +2733,7 @@ _("size %s specified for log subvolume is too large, maximum is %"PRIu64" blocks
 		 * Readjust the log size to fit within an AG if it was sized
 		 * automatically.
 		 */
-		if (!logsize) {
+		if (!logbytes) {
 			logblocks = MIN(logblocks,
 					libxfs_alloc_ag_max_usable(mp));
 
-- 
2.1.4

