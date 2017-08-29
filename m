Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:36957 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751918AbdH2XvH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Aug 2017 19:51:07 -0400
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1dmqHX-0002di-Ax
        for linux-xfs@vger.kernel.org; Wed, 30 Aug 2017 09:50:55 +1000
Received: from dave by discord.disaster.area with local (Exim 4.89)
        (envelope-from <david@fromorbit.com>)
        id 1dmqHX-0005Wz-90
        for linux-xfs@vger.kernel.org; Wed, 30 Aug 2017 09:50:55 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 34/42] mkfs: factor rt device validation
Date: Wed, 30 Aug 2017 09:50:44 +1000
Message-Id: <20170829235052.21050-35-david@fromorbit.com>
In-Reply-To: <20170829235052.21050-1-david@fromorbit.com>
References: <20170829235052.21050-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Signed-Off-By: Dave Chinner <dchinner@redhat.com>
---
 mkfs/xfs_mkfs.c | 109 ++++++++++++++++++++++++++++++++------------------------
 1 file changed, 63 insertions(+), 46 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 2fcc0d39a0a8..c6032e4af4c5 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2661,6 +2661,64 @@ reported by the device (%u).\n"),
 }
 
 static void
+validate_rtdev(
+	struct mkfs_params	*cfg,
+	struct cli_params	*cli,
+	char			**devname)
+{
+	struct libxfs_xinit	*xi = cli->xi;
+
+	*devname = NULL;
+
+	if (!xi->rtdev) {
+		if (cli->rtsize) {
+			fprintf(stderr,
+_("size specified for non-existent rt subvolume\n"));
+			usage();
+		}
+
+		*devname = _("none");
+		cfg->rtblocks = 0;
+		cfg->rtextents = 0;
+		cfg->rtbmblocks = 0;
+		return;
+	}
+	if (!xi->rtsize) {
+		fprintf(stderr, _("Invalid zero length rt subvolume found\n"));
+		usage();
+	}
+
+	/* volume rtdev */
+	if (xi->volname)
+		*devname = _("volume rt");
+	else
+		*devname = xi->rtname;
+
+	if (cli->rtsize) {
+		if (cfg->rtblocks > DTOBT(xi->rtsize, cfg->blocklog)) {
+			fprintf(stderr,
+_("size %s specified for rt subvolume is too large, maxi->um is %lld blocks\n"),
+				cli->rtsize,
+				(long long)DTOBT(xi->rtsize, cfg->blocklog));
+			usage();
+		}
+		if (xi->rtbsize > cfg->sectorsize) {
+			fprintf(stderr, _(
+"Warning: the realtime subvolume sector size %u is less than the sector size\n\
+reported by the device (%u).\n"),
+				cfg->sectorsize, xi->rtbsize);
+		}
+	} else {
+		/* grab volume size */
+		cfg->rtblocks = DTOBT(xi->rtsize, cfg->blocklog);
+	}
+
+	cfg->rtextents = cfg->rtblocks / cfg->rtextblocks;
+	cfg->rtbmblocks = (xfs_extlen_t)howmany(cfg->rtextents,
+						NBBY * cfg->blocksize);
+}
+
+static void
 print_mkfs_cfg(
 	struct mkfs_params	*cfg,
 	char			*dfile,
@@ -3333,7 +3391,6 @@ main(
 	xfs_extlen_t		rtextblocks;
 	xfs_rtblock_t		rtextents;
 	char			*rtfile;
-	char			*rtsize;
 	xfs_sb_t		*sbp;
 	int			sectorlog;
 	uint64_t		tmp_agsize;
@@ -3407,7 +3464,7 @@ main(
 	logagno = logblocks = rtblocks = rtextblocks = 0;
 	imaxpct = inodelog = inopblock = isize = 0;
 	dfile = logfile = rtfile = NULL;
-	logsize = rtsize = protofile = NULL;
+	logsize = protofile = NULL;
 	dsunit = dswidth = lalign = lsunit = 0;
 	nodsflag = 0;
 	force_overwrite = 0;
@@ -3426,6 +3483,7 @@ main(
 			break;
 		case 'b':
 		case 'n':
+		case 'r':
 		case 's':
 			parse_subopts(c, optarg, &cli);
 			break;
@@ -3487,14 +3545,6 @@ main(
 		case 'q':
 			quiet = 1;
 			break;
-		case 'r':
-			parse_subopts(c, optarg, &cli);
-
-			/* temp don't break code */
-			rtsize = cli.rtsize;
-			/* end temp don't break code */
-			break;
-			break;
 		case 'V':
 			printf(_("%s version %s\n"), progname, VERSION);
 			exit(0);
@@ -3550,6 +3600,7 @@ main(
 	open_devices(&cfg, &xi, (discard && !dry_run));
 	validate_datadev(&cfg, &cli);
 	validate_logdev(&cfg, &cli, &logfile);
+	validate_rtdev(&cfg, &cli, &rtfile);
 
 	/* temp don't break code */
 	sectorsize = cfg.sectorsize;
@@ -3569,48 +3620,14 @@ main(
 	logblocks = cfg.logblocks;
 	rtblocks = cfg.rtblocks;
 	rtextblocks = cfg.rtextblocks;
+	nbmblocks = cfg.rtbmblocks;
+	rtextents = cfg.rtextents;
 	dsunit = cfg.dsunit;
 	dswidth = cfg.dswidth;
 	lsunit = cfg.lsunit;
 	nodsflag = cfg.sb_feat.nodalign;
 	/* end temp don't break code */
 
-	if (xi.rtname)
-		rtfile = xi.rtname;
-	else
-	if (xi.volname && xi.rtdev)
-		rtfile = _("volume rt");
-	else if (!xi.rtdev)
-		rtfile = _("none");
-
-	if (rtsize && xi.rtsize > 0 && xi.rtbsize > sectorsize) {
-		fprintf(stderr, _(
-"Warning: the realtime subvolume sector size %u is less than the sector size\n\
-reported by the device (%u).\n"),
-			sectorsize, xi.rtbsize);
-	}
-
-	if (rtsize && xi.rtsize > 0 && rtblocks > DTOBT(xi.rtsize, blocklog)) {
-		fprintf(stderr,
-			_("size %s specified for rt subvolume is too large, "
-			"maximum is %lld blocks\n"),
-			rtsize, (long long)DTOBT(xi.rtsize, blocklog));
-		usage();
-	} else if (!rtsize && xi.rtsize > 0)
-		rtblocks = DTOBT(xi.rtsize, blocklog);
-	else if (rtsize && !xi.rtdev) {
-		fprintf(stderr,
-			_("size specified for non-existent rt subvolume\n"));
-		usage();
-	}
-	if (xi.rtdev) {
-		rtextents = rtblocks / rtextblocks;
-		nbmblocks = (xfs_extlen_t)howmany(rtextents, NBBY * blocksize);
-	} else {
-		rtextents = rtblocks = 0;
-		nbmblocks = 0;
-	}
-
 	if (dasize) {		/* User-specified AG size */
 		/*
 		 * Check specified agsize is a multiple of blocksize.
-- 
2.13.3

