Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:40488 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751953AbdH2XvK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Aug 2017 19:51:10 -0400
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1dmqHX-0002dn-Bc
        for linux-xfs@vger.kernel.org; Wed, 30 Aug 2017 09:50:55 +1000
Received: from dave by discord.disaster.area with local (Exim 4.89)
        (envelope-from <david@fromorbit.com>)
        id 1dmqHX-0005X2-A6
        for linux-xfs@vger.kernel.org; Wed, 30 Aug 2017 09:50:55 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 35/42] mkfs: factor AG geometry calculations
Date: Wed, 30 Aug 2017 09:50:45 +1000
Message-Id: <20170829235052.21050-36-david@fromorbit.com>
In-Reply-To: <20170829235052.21050-1-david@fromorbit.com>
References: <20170829235052.21050-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Signed-Off-By: Dave Chinner <dchinner@redhat.com>
---
 mkfs/xfs_mkfs.c | 61 +++++++++++++++++++++++++++++++++++++++------------------
 1 file changed, 42 insertions(+), 19 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index c6032e4af4c5..a0dcea2609a6 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2719,6 +2719,38 @@ reported by the device (%u).\n"),
 }
 
 static void
+calculate_initial_ag_geometry(
+	struct mkfs_params	*cfg,
+	struct cli_params	*cli)
+{
+	if (cli->agsize) {		/* User-specified AG size */
+		cfg->agsize = getnum(cli->agsize, &dopts, D_AGSIZE);
+
+		/*
+		 * Check specified agsize is a multiple of blocksize.
+		 */
+		if (cfg->agsize % cfg->blocksize) {
+			fprintf(stderr,
+_("agsize (%s) not a multiple of fs blk size (%d)\n"),
+				cli->agsize, cfg->blocksize);
+			usage();
+		}
+		cfg->agsize /= cfg->blocksize;
+		cfg->agcount = cfg->dblocks / cfg->agsize +
+				(cfg->dblocks % cfg->agsize != 0);
+
+	} else if (cli->agcount) {	/* User-specified AG count */
+		cfg->agcount = cli->agcount;
+		cfg->agsize = cfg->dblocks / cfg->agcount +
+				(cfg->dblocks % cfg->agcount != 0);
+	} else {
+		calc_default_ag_geometry(cfg->blocklog, cfg->dblocks,
+					 cfg->dsunit, &cfg->agsize,
+					 &cfg->agcount);
+	}
+}
+
+static void
 print_mkfs_cfg(
 	struct mkfs_params	*cfg,
 	char			*dfile,
@@ -3602,6 +3634,14 @@ main(
 	validate_logdev(&cfg, &cli, &logfile);
 	validate_rtdev(&cfg, &cli, &rtfile);
 
+	/*
+	 * At this point when know exactly what size all the devices are,
+	 * so we can start validating and calculating layout options that are
+	 * dependent on device sizes. Once calculated, make sure everything
+	 * aligns to device geometry correctly.
+	 */
+	calculate_initial_ag_geometry(&cfg, &cli);
+
 	/* temp don't break code */
 	sectorsize = cfg.sectorsize;
 	sectorlog = cfg.sectorlog;
@@ -3626,27 +3666,10 @@ main(
 	dswidth = cfg.dswidth;
 	lsunit = cfg.lsunit;
 	nodsflag = cfg.sb_feat.nodalign;
+	agsize = cfg.agsize;
+	agcount = cfg.agcount;
 	/* end temp don't break code */
 
-	if (dasize) {		/* User-specified AG size */
-		/*
-		 * Check specified agsize is a multiple of blocksize.
-		 */
-		if (agsize % blocksize) {
-			fprintf(stderr,
-		_("agsize (%lld) not a multiple of fs blk size (%d)\n"),
-				(long long)agsize, blocksize);
-			usage();
-		}
-		agsize /= blocksize;
-		agcount = dblocks / agsize + (dblocks % agsize != 0);
-
-	} else if (daflag) {	/* User-specified AG count */
-		agsize = dblocks / agcount + (dblocks % agcount != 0);
-	} else {
-		calc_default_ag_geometry(blocklog, dblocks,
-				dsunit | dswidth, &agsize, &agcount);
-	}
 
 	/*
 	 * If dsunit is a multiple of fs blocksize, then check that is a
-- 
2.13.3

