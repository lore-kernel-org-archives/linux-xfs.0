Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:11621 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751869AbdH2XvH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Aug 2017 19:51:07 -0400
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1dmqHX-0002dd-8T
        for linux-xfs@vger.kernel.org; Wed, 30 Aug 2017 09:50:55 +1000
Received: from dave by discord.disaster.area with local (Exim 4.89)
        (envelope-from <david@fromorbit.com>)
        id 1dmqHX-0005Wt-76
        for linux-xfs@vger.kernel.org; Wed, 30 Aug 2017 09:50:55 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 32/42] mkfs: factor data device validation
Date: Wed, 30 Aug 2017 09:50:42 +1000
Message-Id: <20170829235052.21050-33-david@fromorbit.com>
In-Reply-To: <20170829235052.21050-1-david@fromorbit.com>
References: <20170829235052.21050-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Signed-Off-By: Dave Chinner <dchinner@redhat.com>
---
 mkfs/xfs_mkfs.c | 75 +++++++++++++++++++++++++++++++++++++--------------------
 1 file changed, 49 insertions(+), 26 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index e8fa53fea8e0..81f1e12a941e 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2528,6 +2528,53 @@ open_devices(
 }
 
 static void
+validate_datadev(
+	struct mkfs_params	*cfg,
+	struct cli_params	*cli)
+{
+	struct libxfs_xinit	*xi = cli->xi;
+
+	if (!xi->dsize) {
+		/*
+		 * if the device is a file, we can't validate the size here.
+		 * Instead, the file will be truncated to the correct length
+		 * later on. if it's not a file, we've got a dud device.
+		 */
+		if (!xi->disfile) {
+			fprintf(stderr, _("can't get size of data subvolume\n"));
+			usage();
+		}
+		ASSERT(cfg->dblocks);
+	} else if (cfg->dblocks) {
+		/* check the size fits into the underlying device */
+		if (cfg->dblocks > DTOBT(xi->dsize, cfg->blocklog)) {
+			fprintf(stderr,
+_("size %s specified for data subvolume is too large, maximum is %lld blocks\n"),
+				cli->dsize,
+				(long long)DTOBT(xi->dsize, cfg->blocklog));
+			usage();
+		}
+	} else {
+		/* no user size, so use the full block device */
+		cfg->dblocks = DTOBT(xi->dsize, cfg->blocklog);
+	}
+
+	if (cfg->dblocks < XFS_MIN_DATA_BLOCKS) {
+		fprintf(stderr,
+_("size %lld of data subvolume is too small, minimum %d blocks\n"),
+			(long long)cfg->dblocks, XFS_MIN_DATA_BLOCKS);
+		usage();
+	}
+
+	if (xi->dbsize > cfg->sectorsize) {
+		fprintf(stderr, _(
+"Warning: the data subvolume sector size %u is less than the sector size \n\
+reported by the device (%u).\n"),
+			cfg->sectorsize, xi->dbsize);
+	}
+}
+
+static void
 print_mkfs_cfg(
 	struct mkfs_params	*cfg,
 	char			*dfile,
@@ -3164,7 +3211,6 @@ main(
 	char			*dfile;
 	int			dirblocklog;
 	int			dirblocksize;
-	char			*dsize;
 	int			dsunit;
 	int			dswidth;
 	int			force_overwrite;
@@ -3278,7 +3324,7 @@ main(
 	logagno = logblocks = rtblocks = rtextblocks = 0;
 	imaxpct = inodelog = inopblock = isize = 0;
 	dfile = logfile = rtfile = NULL;
-	dsize = logsize = rtsize = protofile = NULL;
+	logsize = rtsize = protofile = NULL;
 	dsunit = dswidth = lalign = lsunit = 0;
 	nodsflag = 0;
 	force_overwrite = 0;
@@ -3427,6 +3473,7 @@ main(
 	 * Open and validate the device configurations
 	 */
 	open_devices(&cfg, &xi, (discard && !dry_run));
+	validate_datadev(&cfg, &cli);
 
 	/* temp don't break code */
 	sectorsize = cfg.sectorsize;
@@ -3471,24 +3518,6 @@ main(
 		rtfile = _("volume rt");
 	else if (!xi.rtdev)
 		rtfile = _("none");
-	if (dsize && xi.dsize > 0 && dblocks > DTOBT(xi.dsize, blocklog)) {
-		fprintf(stderr,
-			_("size %s specified for data subvolume is too large, "
-			"maximum is %lld blocks\n"),
-			dsize, (long long)DTOBT(xi.dsize, blocklog));
-		usage();
-	} else if (!dsize && xi.dsize > 0)
-		dblocks = DTOBT(xi.dsize, blocklog);
-	else if (!dsize) {
-		fprintf(stderr, _("can't get size of data subvolume\n"));
-		usage();
-	}
-	if (dblocks < XFS_MIN_DATA_BLOCKS) {
-		fprintf(stderr,
-	_("size %lld of data subvolume is too small, minimum %d blocks\n"),
-			(long long)dblocks, XFS_MIN_DATA_BLOCKS);
-		usage();
-	}
 
 	if (loginternal && xi.logdev) {
 		fprintf(stderr,
@@ -3500,12 +3529,6 @@ main(
 		usage();
 	}
 
-	if (xi.dbsize > sectorsize) {
-		fprintf(stderr, _(
-"Warning: the data subvolume sector size %u is less than the sector size \n\
-reported by the device (%u).\n"),
-			sectorsize, xi.dbsize);
-	}
 	if (!loginternal && xi.lbsize > lsectorsize) {
 		fprintf(stderr, _(
 "Warning: the log subvolume sector size %u is less than the sector size\n\
-- 
2.13.3

