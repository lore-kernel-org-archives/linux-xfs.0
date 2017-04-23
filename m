Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47434 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1163244AbdDWSzT (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 23 Apr 2017 14:55:19 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1C79C8050D
        for <linux-xfs@vger.kernel.org>; Sun, 23 Apr 2017 18:55:19 +0000 (UTC)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 10/12] mkfs: replace variables with opts table: -l options
Date: Sun, 23 Apr 2017 20:55:01 +0200
Message-Id: <20170423185503.31415-11-jtulak@redhat.com>
In-Reply-To: <20170423185503.31415-1-jtulak@redhat.com>
References: <20170423185503.31415-1-jtulak@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Jan Tulak <jtulak@redhat.com>

Remove variables that can be replaced with a direct access to the opts table,
so we have it all in a single place, acessible from anywhere.

Signed-off-by: Jan Tulak <jtulak@redhat.com>
---
 mkfs/xfs_mkfs.c | 253 ++++++++++++++++++++++++++++++--------------------------
 1 file changed, 136 insertions(+), 117 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index a5e7c7e..7d85471 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -465,6 +465,7 @@ struct opt_params {
 			  .minval = 0,
 			  .maxval = 1,
 			  .flagval = 1,
+			  .value = 1,
 			},
 			{ .index = L_SIZE,
 			  .conflicts = { LAST_CONFLICT },
@@ -813,7 +814,8 @@ parse_conf_val(int opt, int subopt, char *value)
 
 
 /*
- * Convert lsu to lsunit for 512 bytes blocks and check validity of the values.
+ * Convert L_SU to L_SUNIT for 512 bytes blocks and check validity of the
+ * values.
  */
 static void
 calc_stripe_factors(
@@ -865,7 +867,7 @@ calc_stripe_factors(
 	if (lsu)
 		*lsunit = BTOBBT(lsu);
 
-	/* verify if lsu/lsunit is a multiple block size */
+	/* verify if L_SU/L_SUNIT is a multiple block size */
 	if (lsu % get_conf_val(OPT_B, B_SIZE) != 0) {
 		fprintf(stderr,
 _("log stripe unit (%d) must be a multiple of the block size (%"PRIu64")\n"),
@@ -1507,22 +1509,15 @@ main(
 	uint64_t		lalign;
 	bool			ldflag;
 	bool			liflag;
-	xfs_agnumber_t		logagno;
 	xfs_rfsblock_t		logblocks;
 	char			*logfile;
-	uint64_t		loginternal;
-	uint64_t		logbytes;
 	xfs_fsblock_t		logstart;
 	bool			lvflag;
 	bool			lsflag;
 	bool			lsuflag;
 	bool			lsunitflag;
-	uint64_t		lsectorlog;
-	uint64_t		lsectorsize;
 	bool			lslflag;
 	bool			lssflag;
-	uint64_t		lsu;
-	uint64_t		lsunit;
 	uint64_t		min_logblocks;
 	xfs_mount_t		*mp;
 	xfs_mount_t		mbuf;
@@ -1577,20 +1572,17 @@ main(
 	textdomain(PACKAGE);
 
 	blflag = bsflag = slflag = ssflag = lslflag = lssflag = 0;
-	lsectorlog = 0;
-	lsectorsize = 0;
 	dasize = dblocks = 0;
 	daflag = ilflag = imflag = ipflag = isflag = false;
 	liflag = laflag = lsflag = lsuflag = lsunitflag = ldflag = lvflag = false;
-	loginternal = 1;
-	logagno = logblocks = rtblocks = rtextblocks = 0;
+	logblocks = rtblocks = rtextblocks = 0;
 	Nflag = nlflag = nsflag = nvflag = false;
 	dirblocklog = dirblocksize = 0;
 	qflag = false;
 	dfile = logfile = rtfile = NULL;
 	protofile = NULL;
-	rtbytes = rtextbytes = logbytes = 0;
-	lalign = lsu = lsunit = 0;
+	rtbytes = rtextbytes = 0;
+	lalign = 0;
 	norsflag = false;
 	force_overwrite = false;
 	worst_freelist = 0;
@@ -1824,9 +1816,7 @@ main(
 
 				switch (getsubopt(&p, subopts, &value)) {
 				case L_AGNUM:
-					logagno = parse_conf_val(OPT_L,
-								 L_AGNUM,
-								 value);
+					parse_conf_val(OPT_L, L_AGNUM, value);
 					laflag = 1;
 					break;
 				case L_FILE:
@@ -1835,20 +1825,16 @@ main(
 								    value);
 					break;
 				case L_INTERNAL:
-					loginternal =
-						parse_conf_val(OPT_L,
-							       L_INTERNAL,
-							       value);
+					parse_conf_val(OPT_L, L_INTERNAL,
+						       value);
 					liflag = 1;
 					break;
 				case L_SU:
-					lsu = parse_conf_val(OPT_L, L_SU,
-							     value);
+					parse_conf_val(OPT_L, L_SU, value);
 					lsuflag = 1;
 					break;
 				case L_SUNIT:
-					lsunit = parse_conf_val(OPT_L, L_SUNIT,
-								value);
+					parse_conf_val(OPT_L, L_SUNIT, value);
 					lsunitflag = 1;
 					break;
 				case L_NAME:
@@ -1857,7 +1843,7 @@ main(
 								L_NAME);
 					xi.logname = logfile;
 					ldflag = 1;
-					loginternal = 0;
+					set_conf_val(OPT_L, L_INTERNAL, 0);
 					set_conf_val(OPT_L, L_NAME, 1);
 					set_conf_val(OPT_L, L_DEV, 1);
 					break;
@@ -1871,29 +1857,24 @@ main(
 						     sb_feat.log_version);
 					break;
 				case L_SIZE:
-					logbytes = parse_conf_val(OPT_L,
-								  L_SIZE,
-								  value);
+					parse_conf_val(OPT_L, L_SIZE, value);
 					break;
 				case L_SECTLOG:
-					lsectorlog = parse_conf_val(OPT_L,
+					tmp = parse_conf_val(OPT_L,
 								    L_SECTLOG,
 								    value);
-					lsectorsize = 1 << lsectorlog;
-					lslflag = 1;
 					set_conf_val(OPT_L, L_SECTSIZE,
-						     lsectorsize);
+						     1 << tmp);
+					lslflag = 1;
 					break;
 				case L_SECTSIZE:
-					lsectorsize =
+					tmp =
 						parse_conf_val(OPT_L,
 							       L_SECTSIZE,
 							       value);
-					lsectorlog =
-						libxfs_highbit32(lsectorsize);
-					lssflag = 1;
 					set_conf_val(OPT_L, L_SECTLOG,
-						     lsectorlog);
+						     libxfs_highbit32(tmp));
+					lssflag = 1;
 					break;
 				case L_LAZYSBCNTR:
 					sb_feat.lazy_sb_counters =
@@ -2092,14 +2073,14 @@ main(
 
 					set_conf_val(OPT_S, S_LOG, tmp);
 					set_conf_val(OPT_D, D_SECTLOG, tmp);
-					lsectorlog = tmp;
+					set_conf_val(OPT_L, L_SECTLOG, tmp);
 					set_conf_val(OPT_D, D_SECTSIZE,
 						     1 << tmp);
 					set_conf_val(OPT_S, S_SIZE, 1 << tmp);
 					set_conf_val(OPT_S, S_SECTSIZE,
 						     1 << tmp);
 
-					lsectorsize = tmp;
+					set_conf_val(OPT_L, L_SECTSIZE, tmp);
 					lslflag = slflag = 1;
 					break;
 				case S_SIZE:
@@ -2114,14 +2095,13 @@ main(
 
 					set_conf_val(OPT_S, S_SIZE, tmp);
 					set_conf_val(OPT_D, D_SECTSIZE, tmp);
-					lsectorsize = tmp;
+					set_conf_val(OPT_L, L_SECTSIZE, tmp);
 					set_conf_val(OPT_D, D_SECTLOG,
 						libxfs_highbit32(tmp));
 					set_conf_val(OPT_S, S_LOG,
 						libxfs_highbit32(tmp));
 					set_conf_val(OPT_S, S_SECTLOG,
 						libxfs_highbit32(tmp));
-					lsectorlog = libxfs_highbit32(tmp);
 
 					lssflag = ssflag = 1;
 					break;
@@ -2178,8 +2158,9 @@ _("Minimum block size for CRC enabled filesystems is %d bytes.\n"),
 		set_conf_val(OPT_D, D_SECTSIZE, XFS_MIN_SECTORSIZE);
 	}
 	if (!lslflag && !lssflag) {
-		lsectorlog = get_conf_val(OPT_D, D_SECTLOG);
-		lsectorsize = get_conf_val(OPT_D, D_SECTSIZE);
+		set_conf_val(OPT_L, L_SECTLOG, get_conf_val(OPT_D, D_SECTLOG));
+		set_conf_val(OPT_L, L_SECTSIZE,
+			     get_conf_val(OPT_D, D_SECTSIZE));
 	}
 
 	/*
@@ -2192,8 +2173,9 @@ _("Minimum block size for CRC enabled filesystems is %d bytes.\n"),
 	check_device_type(dfile, &xi.disfile, !get_conf_val(OPT_D, D_SIZE),
 			  !dfile,
 			  Nflag ? NULL : &xi.dcreat, force_overwrite, "d");
-	if (!loginternal)
-		check_device_type(xi.logname, &xi.lisfile, !logbytes,
+	if (!get_conf_val(OPT_L, L_INTERNAL))
+		check_device_type(xi.logname, &xi.lisfile,
+				  !get_conf_val(OPT_L, L_SIZE),
 				  !xi.logname, Nflag ? NULL : &xi.lcreat,
 				  force_overwrite, "l");
 	if (xi.rtname)
@@ -2241,9 +2223,11 @@ _("switching to logical sector size %d\n"),
 	if (!ssflag) {
 		set_conf_val(OPT_D, D_SECTLOG,
 			     libxfs_highbit32(get_conf_val(OPT_D, D_SECTSIZE)));
-		if (loginternal) {
-			lsectorsize = get_conf_val(OPT_D, D_SECTSIZE);
-			lsectorlog = get_conf_val(OPT_D, D_SECTLOG);
+		if (get_conf_val(OPT_L, L_INTERNAL)) {
+			set_conf_val(OPT_L, L_SECTSIZE,
+				     get_conf_val(OPT_D, D_SECTSIZE));
+			set_conf_val(OPT_L, L_SECTLOG,
+				     get_conf_val(OPT_D, D_SECTLOG));
 		}
 	}
 
@@ -2264,13 +2248,16 @@ _("block size %"PRIu64" cannot be smaller than logical sector size %d\n"),
 			get_conf_val(OPT_D, D_SECTSIZE), ft.lsectorsize);
 		usage();
 	}
-	if (lsectorsize < XFS_MIN_SECTORSIZE ||
-	    lsectorsize > XFS_MAX_SECTORSIZE ||
-	    lsectorsize > get_conf_val(OPT_B, B_SIZE)) {
-		fprintf(stderr, _("illegal log sector size %"PRIu64"\n"), lsectorsize);
+	if (get_conf_val(OPT_L, L_SECTSIZE) < XFS_MIN_SECTORSIZE ||
+	    get_conf_val(OPT_L, L_SECTSIZE) > XFS_MAX_SECTORSIZE ||
+	    get_conf_val(OPT_L, L_SECTSIZE) > get_conf_val(OPT_B, B_SIZE)) {
+		fprintf(stderr, _("illegal log sector size %"PRIu64"\n"),
+			get_conf_val(OPT_L, L_SECTSIZE));
 		usage();
-	} else if (lsectorsize > XFS_MIN_SECTORSIZE && !lsu && !lsunit) {
-		lsu = get_conf_val(OPT_B, B_SIZE);
+	} else if (get_conf_val(OPT_L, L_SECTSIZE) > XFS_MIN_SECTORSIZE &&
+		   !get_conf_val(OPT_L, L_SU) &&
+		   !get_conf_val(OPT_L, L_SUNIT)) {
+		set_conf_val(OPT_L, L_SU, get_conf_val(OPT_B, B_SIZE));
 		sb_feat.log_version = 2;
 	}
 
@@ -2423,19 +2410,20 @@ _("rmapbt not supported with realtime devices\n"));
 		usage();
 	}
 
-	if (logbytes) {
-		if (logbytes % XFS_MIN_BLOCKSIZE) {
+	if (get_conf_val(OPT_L, L_SIZE)) {
+		if (get_conf_val(OPT_L, L_SIZE) % XFS_MIN_BLOCKSIZE) {
 			fprintf(stderr,
 			_("illegal log length %"PRIu64", not a multiple of %d\n"),
-				logbytes, XFS_MIN_BLOCKSIZE);
+				get_conf_val(OPT_L, L_SIZE), XFS_MIN_BLOCKSIZE);
 			usage();
 		}
-		logblocks = (xfs_rfsblock_t)(logbytes >>
+		logblocks = (xfs_rfsblock_t)(get_conf_val(OPT_L, L_SIZE) >>
 					     get_conf_val(OPT_B, B_LOG));
-		if (logbytes % get_conf_val(OPT_B, B_SIZE))
+		if (get_conf_val(OPT_L, L_SIZE) % get_conf_val(OPT_B, B_SIZE))
 			fprintf(stderr,
 	_("warning: log length %"PRIu64" not a multiple of %"PRIu64", truncated to %"PRIu64"\n"),
-				logbytes, get_conf_val(OPT_B, B_SIZE),
+				get_conf_val(OPT_L, L_SIZE),
+				get_conf_val(OPT_B, B_SIZE),
 				(uint64_t)(logblocks <<
 					   get_conf_val(OPT_B, B_LOG)));
 	}
@@ -2527,8 +2515,9 @@ _("rmapbt not supported with realtime devices\n"));
 		exit(1);
 	}
 
-	/* if lsu or lsunit was specified, automatically use v2 logs */
-	if ((lsu || lsunit) && sb_feat.log_version == 1) {
+	/* if L_SU or L_SUNIT was specified, automatically use v2 logs */
+	if ((get_conf_val(OPT_L, L_SU) ||
+	     get_conf_val(OPT_L, L_SUNIT)) && sb_feat.log_version == 1) {
 		fprintf(stderr,
 			_("log stripe unit specified, using v2 logs\n"));
 		sb_feat.log_version = 2;
@@ -2536,16 +2525,18 @@ _("rmapbt not supported with realtime devices\n"));
 
 	uint64_t dsunit = get_conf_val(OPT_D, D_SUNIT);
 	uint64_t dswidth = get_conf_val(OPT_D, D_SWIDTH);
+	uint64_t lsunit = get_conf_val(OPT_L, L_SUNIT);
 
 	calc_stripe_factors(get_conf_val(OPT_D, D_SU),
 			    get_conf_val(OPT_D, D_SW),
 			    get_conf_val(OPT_D, D_SECTSIZE),
-			    lsu,
-			    lsectorsize,
-				&dsunit, &dswidth, &lsunit);
+			    get_conf_val(OPT_L, L_SU),
+			    get_conf_val(OPT_L, L_SECTSIZE),
+			    &dsunit, &dswidth, &lsunit);
 
 	set_conf_val(OPT_D, D_SUNIT, dsunit);
 	set_conf_val(OPT_D, D_SWIDTH, dswidth);
+	set_conf_val(OPT_L, L_SUNIT, lsunit);
 
 	xi.setblksize = get_conf_val(OPT_D, D_SECTSIZE);
 
@@ -2574,7 +2565,8 @@ _("rmapbt not supported with realtime devices\n"));
 		(MAX(get_conf_val(OPT_D, D_SECTLOG), 10) - BBSHIFT);
 	xi.dsize &= sector_mask;
 	xi.rtsize &= sector_mask;
-	xi.logBBsize &= (uint64_t)-1 << (MAX(lsectorlog, 10) - BBSHIFT);
+	xi.logBBsize &= (uint64_t)-1 << (MAX(get_conf_val(OPT_L, L_SECTLOG),
+					     10) - BBSHIFT);
 
 
 	/* don't do discards on print-only runs or on files */
@@ -2588,10 +2580,10 @@ _("rmapbt not supported with realtime devices\n"));
 	}
 
 	if (!liflag && !ldflag)
-		loginternal = xi.logdev == 0;
+		set_conf_val(OPT_L, L_INTERNAL, xi.logdev == 0);
 	if (xi.logname)
 		logfile = xi.logname;
-	else if (loginternal)
+	else if (get_conf_val(OPT_L, L_INTERNAL))
 		logfile = _("internal log");
 	else if (xi.volname && xi.logdev)
 		logfile = _("volume log");
@@ -2627,12 +2619,13 @@ _("rmapbt not supported with realtime devices\n"));
 		usage();
 	}
 
-	if (loginternal && xi.logdev) {
+	if (get_conf_val(OPT_L, L_INTERNAL) && xi.logdev) {
 		fprintf(stderr,
 			_("can't have both external and internal logs\n"));
 		usage();
-	} else if (loginternal &&
-		   get_conf_val(OPT_D, D_SECTSIZE) != lsectorsize) {
+	} else if (get_conf_val(OPT_L, L_INTERNAL) &&
+		   get_conf_val(OPT_D, D_SECTSIZE) !=
+		   get_conf_val(OPT_L, L_SECTSIZE)) {
 		fprintf(stderr,
 	_("data and log sector sizes must be equal for internal logs\n"));
 		usage();
@@ -2644,11 +2637,12 @@ _("rmapbt not supported with realtime devices\n"));
 reported by the device (%u).\n"),
 			get_conf_val(OPT_D, D_SECTSIZE), xi.dbsize);
 	}
-	if (!loginternal && xi.lbsize > lsectorsize) {
+	if (!get_conf_val(OPT_L, L_INTERNAL) &&
+	    xi.lbsize > get_conf_val(OPT_L, L_SECTSIZE)) {
 		fprintf(stderr, _(
 "Warning: the log subvolume sector size %"PRIu64" is less than the sector size\n\
 reported by the device (%u).\n"),
-			lsectorsize, xi.lbsize);
+			get_conf_val(OPT_L, L_SECTSIZE), xi.lbsize);
 	}
 	if (rtbytes && xi.rtsize > 0 &&
 	    xi.rtbsize > get_conf_val(OPT_D, D_SECTSIZE)) {
@@ -2924,27 +2918,31 @@ an AG size that is one stripe unit smaller, for example %"PRIu64".\n"),
 	 * check that log sunit is modulo fsblksize or default it to D_SUNIT.
 	 */
 
-	if (lsunit) {
+	if (get_conf_val(OPT_L, L_SUNIT)) {
 		/* convert from 512 byte blocks to fs blocks */
-		lsunit = DTOBT(lsunit);
+		set_conf_val(OPT_L, L_SUNIT,
+			     DTOBT(get_conf_val(OPT_L, L_SUNIT)));
 	} else if (sb_feat.log_version == 2 &&
-		   loginternal &&
+		   get_conf_val(OPT_L, L_INTERNAL) &&
 		   get_conf_val(OPT_D, D_SUNIT)) {
-		/* lsunit and get_conf_val(OPT_D, D_SUNIT) now in fs blocks */
-		lsunit = get_conf_val(OPT_D, D_SUNIT);
+		/* L_SUNIT and D_SUNIT now in fs blocks */
+		set_conf_val(OPT_L, L_SUNIT, get_conf_val(OPT_D, D_SUNIT));
 	}
 
 	if (sb_feat.log_version == 2 &&
-	    (lsunit * get_conf_val(OPT_B, B_SIZE)) > 256 * 1024) {
+	    (get_conf_val(OPT_L, L_SUNIT) *
+	     get_conf_val(OPT_B, B_SIZE)) > 256 * 1024) {
 		/* Warn only if specified on commandline */
 		if (lsuflag || lsunitflag) {
 			fprintf(stderr,
 	_("log stripe unit (%"PRIu64" bytes) is too large (maximum is 256KiB)\n"),
-				(lsunit * get_conf_val(OPT_B, B_SIZE)));
+				(get_conf_val(OPT_L, L_SUNIT) *
+				 get_conf_val(OPT_B, B_SIZE)));
 			fprintf(stderr,
 	_("log stripe unit adjusted to 32KiB\n"));
 		}
-		lsunit = (32 * 1024) >> get_conf_val(OPT_B, B_LOG);
+		set_conf_val(OPT_L, L_SUNIT,
+			     (32 * 1024) >> get_conf_val(OPT_B, B_LOG));
 	}
 
 	min_logblocks = max_trans_res(get_conf_val(OPT_D, D_AGSIZE),
@@ -2952,34 +2950,40 @@ an AG size that is one stripe unit smaller, for example %"PRIu64".\n"),
 				   get_conf_val(OPT_D, D_SECTLOG),
 				   get_conf_val(OPT_B, B_LOG),
 				   get_conf_val(OPT_I, I_LOG), dirblocklog,
-				   sb_feat.log_version, lsunit, sb_feat.finobt,
+				   sb_feat.log_version,
+				   get_conf_val(OPT_L, L_SUNIT),
+				   sb_feat.finobt,
 				   sb_feat.rmapbt, sb_feat.reflink);
 	ASSERT(min_logblocks);
 	min_logblocks = MAX(XFS_MIN_LOG_BLOCKS, min_logblocks);
-	if (!logbytes &&
+	if (!get_conf_val(OPT_L, L_SIZE) &&
 	    dblocks >= (1024*1024*1024) >> get_conf_val(OPT_B, B_LOG))
 		min_logblocks = MAX(min_logblocks,
 				    XFS_MIN_LOG_BYTES >>
 				    get_conf_val(OPT_B, B_LOG));
-	if (logbytes && xi.logBBsize > 0 && logblocks > DTOBT(xi.logBBsize)) {
+	if (get_conf_val(OPT_L, L_SIZE) && xi.logBBsize > 0 &&
+	    logblocks > DTOBT(xi.logBBsize)) {
 		fprintf(stderr,
 _("size %s specified for log subvolume is too large, maximum is %"PRIu64" blocks\n"),
 			get_conf_raw(OPT_L, L_SIZE),
 			(uint64_t)DTOBT(xi.logBBsize));
 		usage();
-	} else if (!logbytes && xi.logBBsize > 0) {
+	} else if (!get_conf_val(OPT_L, L_SIZE) && xi.logBBsize > 0) {
 		logblocks = DTOBT(xi.logBBsize);
-	} else if (logbytes && !xi.logdev && !loginternal) {
+	} else if (get_conf_val(OPT_L, L_SIZE) && !xi.logdev &&
+		   !get_conf_val(OPT_L, L_INTERNAL)) {
 		fprintf(stderr,
 			_("size specified for non-existent log subvolume\n"));
 		usage();
-	} else if (loginternal && logbytes && logblocks >= dblocks) {
+	} else if (get_conf_val(OPT_L, L_INTERNAL) &&
+		   get_conf_val(OPT_L, L_SIZE) && logblocks >= dblocks) {
 		fprintf(stderr, _("size %"PRIu64" too large for internal log\n"),
 			logblocks);
 		usage();
-	} else if (!loginternal && !xi.logdev) {
+	} else if (!get_conf_val(OPT_L, L_INTERNAL) && !xi.logdev) {
 		logblocks = 0;
-	} else if (loginternal && !logbytes) {
+	} else if (get_conf_val(OPT_L, L_INTERNAL) &&
+		   !get_conf_val(OPT_L, L_SIZE)) {
 
 		if (dblocks < GIGABYTES(1, get_conf_val(OPT_B, B_LOG))) {
 			/* tiny filesystems get minimum sized logs. */
@@ -3043,16 +3047,16 @@ _("size %s specified for log subvolume is too large, maximum is %"PRIu64" blocks
 	 */
 	sb_set_features(&mp->m_sb, &sb_feat,
 			get_conf_val(OPT_D, D_SECTSIZE),
-			lsectorsize,
+			get_conf_val(OPT_L, L_SECTSIZE),
 			get_conf_val(OPT_D, D_SUNIT));
 
 
-	if (loginternal) {
+	if (get_conf_val(OPT_L, L_INTERNAL)) {
 		/*
 		 * Readjust the log size to fit within an AG if it was sized
 		 * automatically.
 		 */
-		if (!logbytes) {
+		if (!get_conf_val(OPT_L, L_SIZE)) {
 			logblocks = MIN(logblocks,
 					libxfs_alloc_ag_max_usable(mp));
 
@@ -3070,25 +3074,28 @@ _("size %s specified for log subvolume is too large, maximum is %"PRIu64" blocks
 		}
 
 		if (laflag) {
-			if (logagno >= get_conf_val(OPT_D, D_AGCOUNT)) {
+			if (get_conf_val(OPT_L, L_AGNUM) >=
+			    get_conf_val(OPT_D, D_AGCOUNT)) {
 				fprintf(stderr,
-		_("log ag number %d too large, must be less than %"PRIu64"\n"),
-					logagno,
+	_("log ag number %"PRIu64" too large, must be less than %"PRIu64"\n"),
+					get_conf_val(OPT_L, L_AGNUM),
 					get_conf_val(OPT_D, D_AGCOUNT));
 				usage();
 			}
 		} else
-			logagno = (xfs_agnumber_t)(
-					get_conf_val(OPT_D, D_AGCOUNT) / 2);
+			set_conf_val(OPT_L, L_AGNUM, (xfs_agnumber_t)(
+					get_conf_val(OPT_D, D_AGCOUNT) / 2));
 
-		logstart = XFS_AGB_TO_FSB(mp, logagno, libxfs_prealloc_blocks(mp));
+		logstart = XFS_AGB_TO_FSB(mp, get_conf_val(OPT_L, L_AGNUM),
+					  libxfs_prealloc_blocks(mp));
 		/*
 		 * Align the logstart at stripe unit boundary.
 		 */
-		if (lsunit) {
+		if (get_conf_val(OPT_L, L_SUNIT)) {
 			logstart = fixup_internal_log_stripe(mp,
 					lsflag, logstart,
-					get_conf_val(OPT_D, D_AGSIZE), lsunit,
+					get_conf_val(OPT_D, D_AGSIZE),
+					get_conf_val(OPT_L, L_SUNIT),
 					&logblocks,
 					get_conf_val(OPT_B, B_LOG), &lalign);
 		} else if (get_conf_val(OPT_D, D_SUNIT)) {
@@ -3101,8 +3108,9 @@ _("size %s specified for log subvolume is too large, maximum is %"PRIu64" blocks
 		}
 	} else {
 		logstart = 0;
-		if (lsunit)
-			fixup_log_stripe_unit(lsflag, lsunit,
+		if (get_conf_val(OPT_L, L_SUNIT))
+			fixup_log_stripe_unit(lsflag,
+					      get_conf_val(OPT_L, L_SUNIT),
 					&logblocks, get_conf_val(OPT_B, B_LOG));
 	}
 	validate_log_size(logblocks, get_conf_val(OPT_B, B_LOG), min_logblocks);
@@ -3134,7 +3142,9 @@ _("size %s specified for log subvolume is too large, maximum is %"PRIu64" blocks
 			sb_feat.dir_version, dirblocksize, sb_feat.nci,
 				sb_feat.dirftype,
 			logfile, 1 << get_conf_val(OPT_B, B_LOG), logblocks,
-			sb_feat.log_version, "", lsectorsize, lsunit,
+			sb_feat.log_version, "",
+			get_conf_val(OPT_L, L_SECTSIZE),
+			get_conf_val(OPT_L, L_SUNIT),
 				sb_feat.lazy_sb_counters,
 			rtfile, rtextblocks << get_conf_val(OPT_B, B_LOG),
 			rtblocks, rtextents);
@@ -3175,7 +3185,7 @@ _("size %s specified for log subvolume is too large, maximum is %"PRIu64" blocks
 	sbp->sb_ifree = 0;
 	sbp->sb_fdblocks = dblocks -
 		get_conf_val(OPT_D, D_AGCOUNT) * libxfs_prealloc_blocks(mp) -
-		(loginternal ? logblocks : 0);
+		(get_conf_val(OPT_L, L_INTERNAL) ? logblocks : 0);
 	sbp->sb_frextents = 0;	/* will do a free later */
 	sbp->sb_uquotino = sbp->sb_gquotino = sbp->sb_pquotino = 0;
 	sbp->sb_qflags = 0;
@@ -3183,8 +3193,11 @@ _("size %s specified for log subvolume is too large, maximum is %"PRIu64" blocks
 	sbp->sb_width = get_conf_val(OPT_D, D_SWIDTH);
 	sbp->sb_dirblklog = dirblocklog - get_conf_val(OPT_B, B_LOG);
 	if (sb_feat.log_version == 2) {	/* This is stored in bytes */
-		lsunit = (lsunit == 0) ? 1 : XFS_FSB_TO_B(mp, lsunit);
-		sbp->sb_logsunit = lsunit;
+		set_conf_val(OPT_L, L_SUNIT,
+			     (get_conf_val(OPT_L, L_SUNIT) == 0) ?
+			     1 : XFS_FSB_TO_B(mp,
+					      get_conf_val(OPT_L, L_SUNIT)));
+		sbp->sb_logsunit = get_conf_val(OPT_L, L_SUNIT);
 	} else
 		sbp->sb_logsunit = 0;
 	if (sb_feat.inode_align) {
@@ -3196,10 +3209,11 @@ _("size %s specified for log subvolume is too large, maximum is %"PRIu64" blocks
 		sb_feat.inode_align = sbp->sb_inoalignmt != 0;
 	} else
 		sbp->sb_inoalignmt = 0;
-	if (lsectorsize != BBSIZE ||
+	if (get_conf_val(OPT_L, L_SECTSIZE) != BBSIZE ||
 	    get_conf_val(OPT_D, D_SECTSIZE) != BBSIZE) {
-		sbp->sb_logsectlog = (__uint8_t)lsectorlog;
-		sbp->sb_logsectsize = (__uint16_t)lsectorsize;
+		sbp->sb_logsectlog = (__uint8_t)get_conf_val(OPT_L, L_SECTLOG);
+		sbp->sb_logsectsize =
+			(__uint16_t)get_conf_val(OPT_L, L_SECTSIZE);
 	} else {
 		sbp->sb_logsectlog = 0;
 		sbp->sb_logsectsize = 0;
@@ -3207,7 +3221,7 @@ _("size %s specified for log subvolume is too large, maximum is %"PRIu64" blocks
 
 	sb_set_features(&mp->m_sb, &sb_feat,
 			get_conf_val(OPT_D, D_SECTSIZE),
-			lsectorsize,
+			get_conf_val(OPT_L, L_SECTSIZE),
 			get_conf_val(OPT_D, D_SUNIT));
 
 	if (force_overwrite)
@@ -3269,7 +3283,8 @@ _("size %s specified for log subvolume is too large, maximum is %"PRIu64" blocks
 	libxfs_log_clear(mp->m_logdev_targp, NULL,
 		XFS_FSB_TO_DADDR(mp, logstart),
 		(xfs_extlen_t)XFS_FSB_TO_BB(mp, logblocks),
-		&sbp->sb_uuid, sb_feat.log_version, lsunit, XLOG_FMT, XLOG_INIT_CYCLE, false);
+		&sbp->sb_uuid, sb_feat.log_version,
+		get_conf_val(OPT_L, L_SUNIT), XLOG_FMT, XLOG_INIT_CYCLE, false);
 
 	mp = libxfs_mount(mp, sbp, xi.ddev, xi.logdev, xi.rtdev, 0);
 	if (mp == NULL) {
@@ -3346,7 +3361,8 @@ _("size %s specified for log subvolume is too large, maximum is %"PRIu64" blocks
 		if (xfs_sb_version_hascrc(&mp->m_sb))
 			platform_uuid_copy(&agf->agf_uuid, &mp->m_sb.sb_uuid);
 
-		if (loginternal && agno == logagno) {
+		if (get_conf_val(OPT_L, L_INTERNAL) &&
+		    agno == get_conf_val(OPT_L, L_AGNUM)) {
 			be32_add_cpu(&agf->agf_freeblks, -logblocks);
 			agf->agf_longest =
 				cpu_to_be32(get_conf_val(OPT_D, D_AGSIZE) -
@@ -3420,7 +3436,8 @@ _("size %s specified for log subvolume is too large, maximum is %"PRIu64" blocks
 
 		arec = XFS_ALLOC_REC_ADDR(mp, block, 1);
 		arec->ar_startblock = cpu_to_be32(libxfs_prealloc_blocks(mp));
-		if (loginternal && agno == logagno) {
+		if (get_conf_val(OPT_L, L_INTERNAL) &&
+		    agno == get_conf_val(OPT_L, L_AGNUM)) {
 			if (lalign) {
 				/*
 				 * Have to insert two records
@@ -3471,7 +3488,8 @@ _("size %s specified for log subvolume is too large, maximum is %"PRIu64" blocks
 
 		arec = XFS_ALLOC_REC_ADDR(mp, block, 1);
 		arec->ar_startblock = cpu_to_be32(libxfs_prealloc_blocks(mp));
-		if (loginternal && agno == logagno) {
+		if (get_conf_val(OPT_L, L_INTERNAL) &&
+		    agno == get_conf_val(OPT_L, L_AGNUM)) {
 			if (lalign) {
 				arec->ar_blockcount = cpu_to_be32(
 					XFS_FSB_TO_AGBNO(mp, logstart) -
@@ -3606,7 +3624,8 @@ _("size %s specified for log subvolume is too large, maximum is %"PRIu64" blocks
 			}
 
 			/* account for the log space */
-			if (loginternal && agno == logagno) {
+			if (get_conf_val(OPT_L, L_INTERNAL) && agno ==
+			    get_conf_val(OPT_L, L_AGNUM)) {
 				rrec = XFS_RMAP_REC_ADDR(block,
 					be16_to_cpu(block->bb_numrecs) + 1);
 				rrec->rm_startblock = cpu_to_be32(
-- 
2.1.4

