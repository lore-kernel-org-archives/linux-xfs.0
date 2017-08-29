Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:55482 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751856AbdH2XvF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Aug 2017 19:51:05 -0400
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1dmqHX-0002de-9M
        for linux-xfs@vger.kernel.org; Wed, 30 Aug 2017 09:50:55 +1000
Received: from dave by discord.disaster.area with local (Exim 4.89)
        (envelope-from <david@fromorbit.com>)
        id 1dmqHX-0005Ww-86
        for linux-xfs@vger.kernel.org; Wed, 30 Aug 2017 09:50:55 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 33/42] mkfs: factor log device validation
Date: Wed, 30 Aug 2017 09:50:43 +1000
Message-Id: <20170829235052.21050-34-david@fromorbit.com>
In-Reply-To: <20170829235052.21050-1-david@fromorbit.com>
References: <20170829235052.21050-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Signed-Off-By: Dave Chinner <dchinner@redhat.com>
---
 mkfs/xfs_mkfs.c | 147 ++++++++++++++++++++++++++++++++++----------------------
 1 file changed, 89 insertions(+), 58 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 81f1e12a941e..2fcc0d39a0a8 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2574,6 +2574,92 @@ reported by the device (%u).\n"),
 	}
 }
 
+/*
+ * This is more complex than it needs to be because we still support volume
+ * based external logs. They are only discovered *after* the devices have been
+ * opened, hence the crazy "is this really an internal log" checks here.
+ */
+static void
+validate_logdev(
+	struct mkfs_params	*cfg,
+	struct cli_params	*cli,
+	char			**devname)
+{
+	struct libxfs_xinit	*xi = cli->xi;
+
+	*devname = NULL;
+
+	/* check for volume log first */
+	if (cli->loginternal && xi->volname && xi->logdev) {
+		*devname = _("volume log");
+		cfg->loginternal = false;
+	} else
+		cfg->loginternal = cli->loginternal;
+
+	/* now run device checks */
+	if (cfg->loginternal) {
+		if (xi->logdev) {
+			fprintf(stderr,
+_("can't have both external and internal logs\n"));
+			usage();
+		}
+
+		/*
+		 * if no sector size has been specified on the command line,
+		 * use what has been configured and validated for the data
+		 * device.
+		 */
+		if (!cli->lsectorsize) {
+			cfg->lsectorsize = cfg->sectorsize;
+			cfg->lsectorlog = cfg->sectorlog;
+		}
+
+		if (cfg->sectorsize != cfg->lsectorsize) {
+			fprintf(stderr,
+_("data and log sector sizes must be equal for internal logs\n"));
+			usage();
+		}
+		if (cli->logsize && cfg->logblocks >= cfg->dblocks) {
+			fprintf(stderr,
+_("log size %lld too large for internal log\n"),
+				(long long)cfg->logblocks);
+			usage();
+		}
+		*devname = _("internal log");
+		return;
+	}
+
+	/* External/log subvolume checks */
+	if (xi->logname)
+		*devname = xi->logname;
+	if (!*devname || !xi->logdev) {
+		fprintf(stderr, _("no log subvolume or external log.\n"));
+		usage();
+	}
+
+	if (!cfg->logblocks) {
+		if (xi->logBBsize == 0) {
+			fprintf(stderr,
+_("unable to get size of the log subvolume.\n"));
+			usage();
+		}
+		cfg->logblocks = DTOBT(xi->logBBsize, cfg->blocklog);
+	} else if (cfg->logblocks > DTOBT(xi->logBBsize, cfg->blocklog)) {
+		fprintf(stderr,
+_("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
+			cli->logsize,
+			(long long)DTOBT(xi->logBBsize, cfg->blocklog));
+		usage();
+	}
+
+	if (xi->lbsize > cfg->lsectorsize) {
+		fprintf(stderr, _(
+"Warning: the log subvolume sector size %u is less than the sector size\n\
+reported by the device (%u).\n"),
+			cfg->lsectorsize, xi->lbsize);
+	}
+}
+
 static void
 print_mkfs_cfg(
 	struct mkfs_params	*cfg,
@@ -3223,15 +3309,12 @@ main(
 	char			*label = NULL;
 	int			laflag;
 	int			lalign;
-	int			ldflag;
-	int			liflag;
 	xfs_agnumber_t		logagno;
 	xfs_rfsblock_t		logblocks;
 	char			*logfile;
 	int			loginternal;
 	char			*logsize;
 	xfs_fsblock_t		logstart;
-	int			lvflag;
 	int			lsflag;
 	int			lsectorlog;
 	int			lsectorsize;
@@ -3319,7 +3402,7 @@ main(
 
 	agsize = daflag = dasize = dblocks = 0;
 	imflag = 0;
-	liflag = laflag = lsflag = ldflag = lvflag = 0;
+	laflag = lsflag = 0;
 	loginternal = 1;
 	logagno = logblocks = rtblocks = rtextblocks = 0;
 	imaxpct = inodelog = inopblock = isize = 0;
@@ -3375,15 +3458,7 @@ main(
 
 			/* temp don't break code */
 			logagno = cli.logagno;
-			loginternal = cli.loginternal;
-			logfile = xi.logname;
-			logsize = cli.logsize;
-
 			laflag = cli_opt_set(&lopts, L_AGNUM);
-			liflag = cli_opt_set(&lopts, L_INTERNAL);
-			ldflag = cli_opt_set(&lopts, L_NAME) ||
-				 cli_opt_set(&lopts, L_DEV);
-			lvflag = cli_opt_set(&lopts, L_VERSION);
 			/* end temp don't break code */
 			break;
 		case 'L':
@@ -3474,6 +3549,7 @@ main(
 	 */
 	open_devices(&cfg, &xi, (discard && !dry_run));
 	validate_datadev(&cfg, &cli);
+	validate_logdev(&cfg, &cli, &logfile);
 
 	/* temp don't break code */
 	sectorsize = cfg.sectorsize;
@@ -3499,18 +3575,6 @@ main(
 	nodsflag = cfg.sb_feat.nodalign;
 	/* end temp don't break code */
 
-	if (!liflag && !ldflag)
-		loginternal = xi.logdev == 0;
-	if (xi.logname)
-		logfile = xi.logname;
-	else if (loginternal)
-		logfile = _("internal log");
-	else if (xi.volname && xi.logdev)
-		logfile = _("volume log");
-	else if (!ldflag) {
-		fprintf(stderr, _("no log subvolume or internal log\n"));
-		usage();
-	}
 	if (xi.rtname)
 		rtfile = xi.rtname;
 	else
@@ -3519,22 +3583,6 @@ main(
 	else if (!xi.rtdev)
 		rtfile = _("none");
 
-	if (loginternal && xi.logdev) {
-		fprintf(stderr,
-			_("can't have both external and internal logs\n"));
-		usage();
-	} else if (loginternal && sectorsize != lsectorsize) {
-		fprintf(stderr,
-	_("data and log sector sizes must be equal for internal logs\n"));
-		usage();
-	}
-
-	if (!loginternal && xi.lbsize > lsectorsize) {
-		fprintf(stderr, _(
-"Warning: the log subvolume sector size %u is less than the sector size\n\
-reported by the device (%u).\n"),
-			lsectorsize, xi.lbsize);
-	}
 	if (rtsize && xi.rtsize > 0 && xi.rtbsize > sectorsize) {
 		fprintf(stderr, _(
 "Warning: the realtime subvolume sector size %u is less than the sector size\n\
@@ -3711,24 +3759,7 @@ an AG size that is one stripe unit smaller, for example %llu.\n"),
 	min_logblocks = MAX(XFS_MIN_LOG_BLOCKS, min_logblocks);
 	if (!logsize && dblocks >= (1024*1024*1024) >> blocklog)
 		min_logblocks = MAX(min_logblocks, XFS_MIN_LOG_BYTES>>blocklog);
-	if (logsize && xi.logBBsize > 0 && logblocks > DTOBT(xi.logBBsize, blocklog)) {
-		fprintf(stderr,
-_("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
-			logsize, (long long)DTOBT(xi.logBBsize, blocklog));
-		usage();
-	} else if (!logsize && xi.logBBsize > 0) {
-		logblocks = DTOBT(xi.logBBsize, blocklog);
-	} else if (logsize && !xi.logdev && !loginternal) {
-		fprintf(stderr,
-			_("size specified for non-existent log subvolume\n"));
-		usage();
-	} else if (loginternal && logsize && logblocks >= dblocks) {
-		fprintf(stderr, _("size %lld too large for internal log\n"),
-			(long long)logblocks);
-		usage();
-	} else if (!loginternal && !xi.logdev) {
-		logblocks = 0;
-	} else if (loginternal && !logsize) {
+	if (loginternal && !logsize) {
 
 		if (dblocks < GIGABYTES(1, blocklog)) {
 			/* tiny filesystems get minimum sized logs. */
-- 
2.13.3

