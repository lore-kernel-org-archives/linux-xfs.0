Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60992 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752724AbdHKMar (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 11 Aug 2017 08:30:47 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 73BD456798
        for <linux-xfs@vger.kernel.org>; Fri, 11 Aug 2017 12:30:47 +0000 (UTC)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 3/6] mkfs: remove intermediate getstr followed by getnum
Date: Fri, 11 Aug 2017 14:30:34 +0200
Message-Id: <20170811123037.15962-4-jtulak@redhat.com>
In-Reply-To: <20170811123037.15962-1-jtulak@redhat.com>
References: <20170811123037.15962-1-jtulak@redhat.com>
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

This patch has to be applied after "mkfs: Save raw user input ...",
because otherwise we would temporary lose the access to strings
with user-given values and thus wouldn't be able to report them in
case of an issue. (In reply to Eric's comment.)

UPDATE:
 * fix dbytes, rtbytes, rtextbytes and logbytes - these variables should
   be uint64, as the local old ones they are replacing, but were
   unintentionally created as int
---
 mkfs/xfs_mkfs.c | 90 ++++++++++++++++++++++++++-------------------------------
 1 file changed, 41 insertions(+), 49 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 9431f010..78e27498 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -1396,6 +1396,7 @@ getnum(
 	long long		c;
 
 	check_opt(opts, index, false);
+	set_conf_raw(opts, index, str);
 	/* empty strings might just return a default value */
 	if (!str || *str == '\0') {
 		if (sp->flagval == SUBOPT_NEEDS_VAL)
@@ -1483,13 +1484,13 @@ main(
 	char			*dfile;
 	int			dirblocklog;
 	int			dirblocksize;
-	char			*dsize;
+	uint64_t		dbytes;
 	int			dsu;
 	int			dsw;
 	int			dsunit;
 	int			dswidth;
 	int			dsflag;
-	int			force_overwrite;
+	bool			force_overwrite;
 	struct fsxattr		fsx;
 	int			ilflag;
 	int			imaxpct;
@@ -1508,7 +1509,7 @@ main(
 	xfs_rfsblock_t		logblocks;
 	char			*logfile;
 	int			loginternal;
-	char			*logsize;
+	uint64_t		logbytes;
 	xfs_fsblock_t		logstart;
 	int			lvflag;
 	int			lsflag;
@@ -1537,11 +1538,11 @@ main(
 	char			*protostring;
 	int			qflag;
 	xfs_rfsblock_t		rtblocks;
+	uint64_t		rtbytes;
 	xfs_extlen_t		rtextblocks;
 	xfs_rtblock_t		rtextents;
-	char			*rtextsize;
+	uint64_t		rtextbytes;
 	char			*rtfile;
-	char			*rtsize;
 	xfs_sb_t		*sbp;
 	int			sectorlog;
 	uint64_t		sector_mask;
@@ -1589,7 +1590,8 @@ main(
 	qflag = 0;
 	imaxpct = inodelog = inopblock = isize = 0;
 	dfile = logfile = rtfile = NULL;
-	dsize = logsize = rtsize = rtextsize = protofile = NULL;
+	protofile = NULL;
+	rtbytes = rtextbytes = logbytes = dbytes = 0;
 	dsu = dsw = dsunit = dswidth = lalign = lsu = lsunit = 0;
 	dsflag = nodsflag = norsflag = 0;
 	force_overwrite = 0;
@@ -1653,7 +1655,7 @@ main(
 					xi.dname = getstr(value, &dopts, D_NAME);
 					break;
 				case D_SIZE:
-					dsize = getstr(value, &dopts, D_SIZE);
+					dbytes = getnum(value, &dopts, D_SIZE);
 					break;
 				case D_SUNIT:
 					dsunit = getnum(value, &dopts, D_SUNIT);
@@ -1802,7 +1804,7 @@ main(
 					lvflag = 1;
 					break;
 				case L_SIZE:
-					logsize = getstr(value, &lopts, L_SIZE);
+					logbytes = getnum(value, &lopts, L_SIZE);
 					break;
 				case L_SECTLOG:
 					lsectorlog = getnum(value, &lopts,
@@ -1931,8 +1933,7 @@ main(
 
 				switch (getsubopt(&p, subopts, &value)) {
 				case R_EXTSIZE:
-					rtextsize = getstr(value, &ropts,
-							   R_EXTSIZE);
+					rtextbytes = getnum(value, &ropts, R_EXTSIZE);
 					break;
 				case R_FILE:
 					xi.risfile = getnum(value, &ropts,
@@ -1944,7 +1945,7 @@ main(
 							   R_NAME);
 					break;
 				case R_SIZE:
-					rtsize = getstr(value, &ropts, R_SIZE);
+					rtbytes = getnum(value, &ropts, R_SIZE);
 					break;
 				case R_NOALIGN:
 					norsflag = getnum(value, &ropts,
@@ -2047,14 +2048,14 @@ _("Minimum block size for CRC enabled filesystems is %d bytes.\n"),
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
@@ -2235,10 +2236,7 @@ _("rmapbt not supported with realtime devices\n"));
 	}
 
 
-	if (dsize) {
-		uint64_t dbytes;
-
-		dbytes = getnum(dsize, &dopts, D_SIZE);
+	if (dbytes) {
 		if (dbytes % XFS_MIN_BLOCKSIZE) {
 			fprintf(stderr,
 			_("illegal data length %lld, not a multiple of %d\n"),
@@ -2267,10 +2265,7 @@ _("rmapbt not supported with realtime devices\n"));
 		usage();
 	}
 
-	if (logsize) {
-		uint64_t logbytes;
-
-		logbytes = getnum(logsize, &lopts, L_SIZE);
+	if (logbytes) {
 		if (logbytes % XFS_MIN_BLOCKSIZE) {
 			fprintf(stderr,
 			_("illegal log length %lld, not a multiple of %d\n"),
@@ -2284,10 +2279,7 @@ _("rmapbt not supported with realtime devices\n"));
 				(long long)logbytes, blocksize,
 				(long long)(logblocks << blocklog));
 	}
-	if (rtsize) {
-		uint64_t rtbytes;
-
-		rtbytes = getnum(rtsize, &ropts, R_SIZE);
+	if (rtbytes) {
 		if (rtbytes % XFS_MIN_BLOCKSIZE) {
 			fprintf(stderr,
 			_("illegal rt length %lld, not a multiple of %d\n"),
@@ -2304,10 +2296,7 @@ _("rmapbt not supported with realtime devices\n"));
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
 		_("illegal rt extent size %lld, not a multiple of %d\n"),
@@ -2324,7 +2313,7 @@ _("rmapbt not supported with realtime devices\n"));
 		uint64_t	rswidth;
 		uint64_t	rtextbytes;
 
-		if (!norsflag && !xi.risfile && !(!rtsize && xi.disfile))
+		if (!norsflag && !xi.risfile && !(!rtbytes && xi.disfile))
 			rswidth = ft.rtswidth;
 		else
 			rswidth = 0;
@@ -2439,15 +2428,16 @@ _("rmapbt not supported with realtime devices\n"));
 		rtfile = _("volume rt");
 	else if (!xi.rtdev)
 		rtfile = _("none");
-	if (dsize && xi.dsize > 0 && dblocks > DTOBT(xi.dsize)) {
+	if (dbytes && xi.dsize > 0 && dblocks > DTOBT(xi.dsize)) {
 		fprintf(stderr,
 			_("size %s specified for data subvolume is too large, "
 			"maximum is %lld blocks\n"),
-			dsize, (long long)DTOBT(xi.dsize));
+			get_conf_raw_safe(&dopts, D_SIZE),
+			(long long)DTOBT(xi.dsize));
 		usage();
-	} else if (!dsize && xi.dsize > 0)
+	} else if (!dbytes && xi.dsize > 0)
 		dblocks = DTOBT(xi.dsize);
-	else if (!dsize) {
+	else if (!dbytes) {
 		fprintf(stderr, _("can't get size of data subvolume\n"));
 		usage();
 	}
@@ -2480,22 +2470,23 @@ reported by the device (%u).\n"),
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
 			_("size %s specified for rt subvolume is too large, "
 			"maximum is %lld blocks\n"),
-			rtsize, (long long)DTOBT(xi.rtsize));
+			get_conf_raw_safe(&ropts, R_SIZE),
+			(long long)DTOBT(xi.rtsize));
 		usage();
-	} else if (!rtsize && xi.rtsize > 0)
+	} else if (!rtbytes && xi.rtsize > 0)
 		rtblocks = DTOBT(xi.rtsize);
-	else if (rtsize && !xi.rtdev) {
+	else if (rtbytes && !xi.rtdev) {
 		fprintf(stderr,
 			_("size specified for non-existent rt subvolume\n"));
 		usage();
@@ -2701,26 +2692,27 @@ an AG size that is one stripe unit smaller, for example %llu.\n"),
 				   sb_feat.inode_align);
 	ASSERT(min_logblocks);
 	min_logblocks = MAX(XFS_MIN_LOG_BLOCKS, min_logblocks);
-	if (!logsize && dblocks >= (1024*1024*1024) >> blocklog)
+	if (!logbytes && dblocks >= (1024*1024*1024) >> blocklog)
 		min_logblocks = MAX(min_logblocks, XFS_MIN_LOG_BYTES>>blocklog);
-	if (logsize && xi.logBBsize > 0 && logblocks > DTOBT(xi.logBBsize)) {
+	if (logbytes && xi.logBBsize > 0 && logblocks > DTOBT(xi.logBBsize)) {
 		fprintf(stderr,
 _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
-			logsize, (long long)DTOBT(xi.logBBsize));
+			get_conf_raw_safe(&lopts, L_SIZE),
+			(long long)DTOBT(xi.logBBsize));
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
@@ -2784,7 +2776,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 		 * Readjust the log size to fit within an AG if it was sized
 		 * automatically.
 		 */
-		if (!logsize) {
+		if (!logbytes) {
 			logblocks = MIN(logblocks,
 					libxfs_alloc_ag_max_usable(mp));
 
-- 
2.13.3

