Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 376107CB4
	for <xfs@oss.sgi.com>; Tue,  2 Aug 2016 10:42:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id ED7AB304039
	for <xfs@oss.sgi.com>; Tue,  2 Aug 2016 08:42:51 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id inTKm0jPduq4HdZ7 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 02 Aug 2016 08:42:48 -0700 (PDT)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id 1B5963CF
	for <xfs@oss.sgi.com>; Tue,  2 Aug 2016 15:42:48 +0000 (UTC)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 1/8] mkfs: remove intermediate getstr followed by getnum
Date: Tue,  2 Aug 2016 17:42:12 +0200
Message-Id: <1470152539-18759-2-git-send-email-jtulak@redhat.com>
In-Reply-To: <1470152539-18759-1-git-send-email-jtulak@redhat.com>
References: <1470152539-18759-1-git-send-email-jtulak@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Jan Tulak <jtulak@redhat.com>

Some options loaded a number as a stringi with getstr and converted it to
number with getnum later in the code, without any reason for this approach.
(They were probably forgotten in some past cleaning.)

This patch changes them to skip the string and use getnum directly in the main
option-parsing loop, as do all the other numerical options.

Signed-off-by: Jan Tulak <jtulak@redhat.com>
---
 mkfs/xfs_mkfs.c | 88 +++++++++++++++++++++++++--------------------------------
 1 file changed, 38 insertions(+), 50 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 8007dd0..188adb4 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -1395,7 +1395,7 @@ main(
 	char			*dfile;
 	int			dirblocklog;
 	int			dirblocksize;
-	char			*dsize;
+	__uint64_t 		dbytes;
 	int			dsu;
 	int			dsw;
 	int			dsunit;
@@ -1419,7 +1419,7 @@ main(
 	xfs_rfsblock_t		logblocks;
 	char			*logfile;
 	int			loginternal;
-	char			*logsize;
+	__uint64_t 		logbytes;
 	xfs_fsblock_t		logstart;
 	int			lvflag;
 	int			lsflag;
@@ -1448,11 +1448,11 @@ main(
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
@@ -1498,7 +1498,8 @@ main(
 	qflag = 0;
 	imaxpct = inodelog = inopblock = isize = 0;
 	dfile = logfile = rtfile = NULL;
-	dsize = logsize = rtsize = rtextsize = protofile = NULL;
+	protofile = NULL;
+	rtbytes = rtextbytes = logbytes = dbytes = 0;
 	dsu = dsw = dsunit = dswidth = lalign = lsu = lsunit = 0;
 	nodsflag = norsflag = 0;
 	force_overwrite = 0;
@@ -1564,7 +1565,7 @@ main(
 					xi.dname = getstr(value, &dopts, D_NAME);
 					break;
 				case D_SIZE:
-					dsize = getstr(value, &dopts, D_SIZE);
+					dbytes = getnum(value, &dopts, D_SIZE);
 					break;
 				case D_SUNIT:
 					dsunit = getnum(value, &dopts, D_SUNIT);
@@ -1711,7 +1712,7 @@ main(
 					lvflag = 1;
 					break;
 				case L_SIZE:
-					logsize = getstr(value, &lopts, L_SIZE);
+					logbytes = getnum(value, &lopts, L_SIZE);
 					break;
 				case L_SECTLOG:
 					lsectorlog = getnum(value, &lopts,
@@ -1835,8 +1836,7 @@ main(
 				switch (getsubopt(&p, (constpp)subopts,
 						  &value)) {
 				case R_EXTSIZE:
-					rtextsize = getstr(value, &ropts,
-							   R_EXTSIZE);
+					rtextbytes = getnum(value, &ropts, R_EXTSIZE);
 					break;
 				case R_FILE:
 					xi.risfile = getnum(value, &ropts,
@@ -1848,7 +1848,7 @@ main(
 							   R_NAME);
 					break;
 				case R_SIZE:
-					rtsize = getstr(value, &ropts, R_SIZE);
+					rtbytes = getnum(value, &ropts, R_SIZE);
 					break;
 				case R_NOALIGN:
 					norsflag = getnum(value, &ropts,
@@ -1952,14 +1952,14 @@ _("Minimum block size for CRC enabled filesystems is %d bytes.\n"),
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
@@ -2119,10 +2119,7 @@ _("sparse inodes not supported without CRC support\n"));
 	}
 
 
-	if (dsize) {
-		__uint64_t dbytes;
-
-		dbytes = getnum(dsize, &dopts, D_SIZE);
+	if (dbytes) {
 		if (dbytes % XFS_MIN_BLOCKSIZE) {
 			fprintf(stderr,
 			_("illegal data length %lld, not a multiple of %d\n"),
@@ -2151,10 +2148,7 @@ _("sparse inodes not supported without CRC support\n"));
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
@@ -2168,10 +2162,7 @@ _("sparse inodes not supported without CRC support\n"));
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
@@ -2188,10 +2179,7 @@ _("sparse inodes not supported without CRC support\n"));
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
@@ -2208,7 +2196,7 @@ _("sparse inodes not supported without CRC support\n"));
 		__uint64_t	rswidth;
 		__uint64_t	rtextbytes;
 
-		if (!norsflag && !xi.risfile && !(!rtsize && xi.disfile))
+		if (!norsflag && !xi.risfile && !(!rtbytes && xi.disfile))
 			rswidth = ft.rtswidth;
 		else
 			rswidth = 0;
@@ -2319,15 +2307,15 @@ _("sparse inodes not supported without CRC support\n"));
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
@@ -2360,22 +2348,22 @@ reported by the device (%u).\n"),
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
@@ -2578,26 +2566,26 @@ an AG size that is one stripe unit smaller, for example %llu.\n"),
 				   sb_feat.log_version, lsunit, sb_feat.finobt);
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
@@ -2661,7 +2649,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 		 * Readjust the log size to fit within an AG if it was sized
 		 * automatically.
 		 */
-		if (!logsize) {
+		if (!logbytes) {
 			logblocks = MIN(logblocks,
 					XFS_ALLOC_AG_MAX_USABLE(mp));
 
-- 
2.5.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
