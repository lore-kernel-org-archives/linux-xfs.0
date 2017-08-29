Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:11621 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751886AbdH2XvC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Aug 2017 19:51:02 -0400
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1dmqHX-0002dW-5Y
        for linux-xfs@vger.kernel.org; Wed, 30 Aug 2017 09:50:55 +1000
Received: from dave by discord.disaster.area with local (Exim 4.89)
        (envelope-from <david@fromorbit.com>)
        id 1dmqHX-0005Wk-47
        for linux-xfs@vger.kernel.org; Wed, 30 Aug 2017 09:50:55 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 29/42] mkfs: factor rtdev extent size validation
Date: Wed, 30 Aug 2017 09:50:39 +1000
Message-Id: <20170829235052.21050-30-david@fromorbit.com>
In-Reply-To: <20170829235052.21050-1-david@fromorbit.com>
References: <20170829235052.21050-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Signed-Off-By: Dave Chinner <dchinner@redhat.com>
---
 mkfs/xfs_mkfs.c | 108 +++++++++++++++++++++++++++++++-------------------------
 1 file changed, 59 insertions(+), 49 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 1f41d5f813f0..7595e378ad44 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2324,6 +2324,60 @@ _("warning: %s length %lld not a multiple of %d, truncated to %lld\n"),
 }
 
 static void
+validate_rtextsize(
+	struct mkfs_params	*cfg,
+	struct cli_params	*cli,
+	struct fs_topology	*ft)
+{
+	uint64_t		rtextbytes;
+
+	/*
+	 * If specified, check rt extent size against its constraints.
+	 */
+	if (cli->rtextsize) {
+
+		rtextbytes = getnum(cli->rtextsize, &ropts, R_EXTSIZE);
+		if (rtextbytes % cfg->blocksize) {
+			fprintf(stderr,
+		_("illegal rt extent size %lld, not a multiple of %d\n"),
+				(long long)rtextbytes, cfg->blocksize);
+			usage();
+		}
+		cfg->rtextblocks = (xfs_extlen_t)(rtextbytes >> cfg->blocklog);
+	} else {
+		/*
+		 * If realtime extsize has not been specified by the user,
+		 * and the underlying volume is striped, then set rtextblocks
+		 * to the stripe width.
+		 */
+		uint64_t	rswidth;
+
+		if (!cfg->sb_feat.nortalign && !cli->xi->risfile &&
+		    !(!cli->rtsize && cli->xi->disfile))
+			rswidth = ft->rtswidth;
+		else
+			rswidth = 0;
+
+		/* check that rswidth is a multiple of fs blocksize */
+		if (!cfg->sb_feat.nortalign && rswidth &&
+		    !(BBTOB(rswidth) % cfg->blocksize)) {
+			rswidth = DTOBT(rswidth, cfg->blocklog);
+			rtextbytes = rswidth << cfg->blocklog;
+			if (rtextbytes > XFS_MIN_RTEXTSIZE &&
+			    rtextbytes <= XFS_MAX_RTEXTSIZE) {
+				cfg->rtextblocks = rswidth;
+			}
+		}
+		if (!cfg->rtextblocks) {
+			cfg->rtextblocks = (cfg->blocksize < XFS_MIN_RTEXTSIZE)
+					? XFS_MIN_RTEXTSIZE >> cfg->blocklog
+					: 1;
+		}
+	}
+	ASSERT(cfg->rtextblocks);
+}
+
+static void
 print_mkfs_cfg(
 	struct mkfs_params	*cfg,
 	char			*dfile,
@@ -2997,7 +3051,6 @@ main(
 	xfs_mount_t		mbuf;
 	xfs_extlen_t		nbmblocks;
 	int			nodsflag;
-	int			norsflag;
 	int			dry_run = 0;
 	int			discard = 1;
 	char			*protofile;
@@ -3006,7 +3059,6 @@ main(
 	xfs_rfsblock_t		rtblocks;
 	xfs_extlen_t		rtextblocks;
 	xfs_rtblock_t		rtextents;
-	char			*rtextsize;
 	char			*rtfile;
 	char			*rtsize;
 	xfs_sb_t		*sbp;
@@ -3083,9 +3135,9 @@ main(
 	logagno = logblocks = rtblocks = rtextblocks = 0;
 	imaxpct = inodelog = inopblock = isize = 0;
 	dfile = logfile = rtfile = NULL;
-	dsize = logsize = rtsize = rtextsize = protofile = NULL;
+	dsize = logsize = rtsize = protofile = NULL;
 	dsu = dsw = dsunit = dswidth = lalign = lsu = lsunit = 0;
-	dsflag = nodsflag = norsflag = 0;
+	dsflag = nodsflag = 0;
 	force_overwrite = 0;
 	worst_freelist = 0;
 	memset(&fsx, 0, sizeof(fsx));
@@ -3194,9 +3246,7 @@ main(
 			parse_subopts(c, optarg, &cli);
 
 			/* temp don't break code */
-			rtextsize = cli.rtextsize;
 			rtsize = cli.rtsize;
-			norsflag = cli.sb_feat.nortalign;
 			/* end temp don't break code */
 			break;
 			break;
@@ -3246,6 +3296,8 @@ main(
 	cfg.logblocks = calc_dev_size(cli.logsize, &cfg, &lopts, L_SIZE, "log");
 	cfg.rtblocks = calc_dev_size(cli.rtsize, &cfg, &ropts, R_SIZE, "rt");
 
+	validate_rtextsize(&cfg, &cli, &ft);
+
 	/* temp don't break code */
 	sectorsize = cfg.sectorsize;
 	sectorlog = cfg.sectorlog;
@@ -3263,51 +3315,9 @@ main(
 	dblocks = cfg.dblocks;
 	logblocks = cfg.logblocks;
 	rtblocks = cfg.rtblocks;
+	rtextblocks = cfg.rtextblocks;
 	/* end temp don't break code */
 
-	/*
-	 * If specified, check rt extent size against its constraints.
-	 */
-	if (rtextsize) {
-		uint64_t rtextbytes;
-
-		rtextbytes = getnum(rtextsize, &ropts, R_EXTSIZE);
-		if (rtextbytes % blocksize) {
-			fprintf(stderr,
-		_("illegal rt extent size %lld, not a multiple of %d\n"),
-				(long long)rtextbytes, blocksize);
-			usage();
-		}
-		rtextblocks = (xfs_extlen_t)(rtextbytes >> blocklog);
-	} else {
-		/*
-		 * If realtime extsize has not been specified by the user,
-		 * and the underlying volume is striped, then set rtextblocks
-		 * to the stripe width.
-		 */
-		uint64_t	rswidth;
-		uint64_t	rtextbytes;
-
-		if (!norsflag && !xi.risfile && !(!rtsize && xi.disfile))
-			rswidth = ft.rtswidth;
-		else
-			rswidth = 0;
-
-		/* check that rswidth is a multiple of fs blocksize */
-		if (!norsflag && rswidth && !(BBTOB(rswidth) % blocksize)) {
-			rswidth = DTOBT(rswidth, blocklog);
-			rtextbytes = rswidth << blocklog;
-			if (XFS_MIN_RTEXTSIZE <= rtextbytes &&
-			    (rtextbytes <= XFS_MAX_RTEXTSIZE)) {
-				rtextblocks = rswidth;
-			}
-		}
-		if (!rtextblocks) {
-			rtextblocks = (blocksize < XFS_MIN_RTEXTSIZE) ?
-					XFS_MIN_RTEXTSIZE >> blocklog : 1;
-		}
-	}
-	ASSERT(rtextblocks);
 
 	calc_stripe_factors(dsu, dsw, sectorsize, lsu, lsectorsize,
 				&dsunit, &dswidth, &lsunit);
-- 
2.13.3

