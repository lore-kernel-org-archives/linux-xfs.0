Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:36957 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751913AbdH2XvF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Aug 2017 19:51:05 -0400
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1dmqHX-0002dc-7Y
        for linux-xfs@vger.kernel.org; Wed, 30 Aug 2017 09:50:55 +1000
Received: from dave by discord.disaster.area with local (Exim 4.89)
        (envelope-from <david@fromorbit.com>)
        id 1dmqHX-0005Wq-66
        for linux-xfs@vger.kernel.org; Wed, 30 Aug 2017 09:50:55 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 31/42] mkfs: factor device opening
Date: Wed, 30 Aug 2017 09:50:41 +1000
Message-Id: <20170829235052.21050-32-david@fromorbit.com>
In-Reply-To: <20170829235052.21050-1-david@fromorbit.com>
References: <20170829235052.21050-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Signed-Off-By: Dave Chinner <dchinner@redhat.com>
---
 mkfs/xfs_mkfs.c | 92 ++++++++++++++++++++++++++++++++-------------------------
 1 file changed, 51 insertions(+), 41 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index fe380d2b388d..e8fa53fea8e0 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2482,6 +2482,52 @@ _("log stripe unit (%d bytes) is too large (maximum is 256KiB)\n"
 }
 
 static void
+open_devices(
+	struct mkfs_params	*cfg,
+	struct libxfs_xinit	*xi,
+	bool			discard)
+{
+	uint64_t		sector_mask;
+
+	/*
+	 * Initialize.  This will open the log and rt devices as well.
+	 */
+	xi->setblksize = cfg->sectorsize;
+	if (!libxfs_init(xi))
+		usage();
+	if (!xi->ddev) {
+		fprintf(stderr, _("no device name given in argument list\n"));
+		usage();
+	}
+
+	/*
+	 * Ok, Linux only has a 1024-byte resolution on device _size_,
+	 * and the sizes below are in basic 512-byte blocks,
+	 * so if we have (size % 2), on any partition, we can't get
+	 * to the last 512 bytes.  The same issue exists for larger
+	 * sector sizes - we cannot write past the last sector.
+	 *
+	 * So, we reduce the size (in basic blocks) to a perfect
+	 * multiple of the sector size, or 1024, whichever is larger.
+	 */
+	sector_mask = (uint64_t)-1 << (MAX(cfg->sectorlog, 10) - BBSHIFT);
+	xi->dsize &= sector_mask;
+	xi->rtsize &= sector_mask;
+	xi->logBBsize &= (uint64_t)-1 << (MAX(cfg->lsectorlog, 10) - BBSHIFT);
+
+
+	if (!discard)
+		return;
+
+	if (!xi->disfile)
+		discard_blocks(xi->ddev, xi->dsize);
+	if (xi->rtdev && !xi->risfile)
+		discard_blocks(xi->rtdev, xi->rtsize);
+	if (xi->logdev && xi->logdev != xi->ddev && !xi->lisfile)
+		discard_blocks(xi->logdev, xi->logBBsize);
+}
+
+static void
 print_mkfs_cfg(
 	struct mkfs_params	*cfg,
 	char			*dfile,
@@ -3161,7 +3207,6 @@ main(
 	char			*rtsize;
 	xfs_sb_t		*sbp;
 	int			sectorlog;
-	uint64_t		sector_mask;
 	uint64_t		tmp_agsize;
 	uuid_t			uuid;
 	int			worst_freelist;
@@ -3378,6 +3423,11 @@ main(
 	validate_rtextsize(&cfg, &cli, &ft);
 	calc_stripe_factors(&cfg, &cli, &ft);
 
+	/*
+	 * Open and validate the device configurations
+	 */
+	open_devices(&cfg, &xi, (discard && !dry_run));
+
 	/* temp don't break code */
 	sectorsize = cfg.sectorsize;
 	sectorlog = cfg.sectorlog;
@@ -3402,46 +3452,6 @@ main(
 	nodsflag = cfg.sb_feat.nodalign;
 	/* end temp don't break code */
 
-
-	xi.setblksize = sectorsize;
-
-	/*
-	 * Initialize.  This will open the log and rt devices as well.
-	 */
-	if (!libxfs_init(&xi))
-		usage();
-	if (!xi.ddev) {
-		fprintf(stderr, _("no device name given in argument list\n"));
-		usage();
-	}
-
-	/*
-	 * Ok, Linux only has a 1024-byte resolution on device _size_,
-	 * and the sizes below are in basic 512-byte blocks,
-	 * so if we have (size % 2), on any partition, we can't get
-	 * to the last 512 bytes.  The same issue exists for larger
-	 * sector sizes - we cannot write past the last sector.
-	 *
-	 * So, we reduce the size (in basic blocks) to a perfect
-	 * multiple of the sector size, or 1024, whichever is larger.
-	 */
-
-	sector_mask = (uint64_t)-1 << (MAX(sectorlog, 10) - BBSHIFT);
-	xi.dsize &= sector_mask;
-	xi.rtsize &= sector_mask;
-	xi.logBBsize &= (uint64_t)-1 << (MAX(lsectorlog, 10) - BBSHIFT);
-
-
-	/* don't do discards on print-only runs or on files */
-	if (discard && !dry_run) {
-		if (!xi.disfile)
-			discard_blocks(xi.ddev, xi.dsize);
-		if (xi.rtdev && !xi.risfile)
-			discard_blocks(xi.rtdev, xi.rtsize);
-		if (xi.logdev && xi.logdev != xi.ddev && !xi.lisfile)
-			discard_blocks(xi.logdev, xi.logBBsize);
-	}
-
 	if (!liflag && !ldflag)
 		loginternal = xi.logdev == 0;
 	if (xi.logname)
-- 
2.13.3

