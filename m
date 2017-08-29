Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:55482 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751875AbdH2XvB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Aug 2017 19:51:01 -0400
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1dmqHX-0002dH-0y
        for linux-xfs@vger.kernel.org; Wed, 30 Aug 2017 09:50:55 +1000
Received: from dave by discord.disaster.area with local (Exim 4.89)
        (envelope-from <david@fromorbit.com>)
        id 1dmqHW-0005WV-W9
        for linux-xfs@vger.kernel.org; Wed, 30 Aug 2017 09:50:54 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 24/42] mkfs: factor superblock feature validation
Date: Wed, 30 Aug 2017 09:50:34 +1000
Message-Id: <20170829235052.21050-25-david@fromorbit.com>
In-Reply-To: <20170829235052.21050-1-david@fromorbit.com>
References: <20170829235052.21050-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Signed-Off-By: Dave Chinner <dchinner@redhat.com>
---
 mkfs/xfs_mkfs.c | 228 +++++++++++++++++++++++++++++++-------------------------
 1 file changed, 127 insertions(+), 101 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 64542442148c..1c697dd5d4e1 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2090,6 +2090,130 @@ _("log stripe unit specified, using v2 logs\n"));
 
 }
 
+/*
+ * Check that the incoming features make sense. The CLI structure was
+ * initialised with the default values before parsing, so we can just
+ * check it and copy it straight across to the cfg structure if it
+ * checks out.
+ */
+static void
+validate_sb_features(
+	struct mkfs_params	*cfg,
+	struct cli_params	*cli)
+{
+	/*
+	 * Now we have blocks and sector sizes set up, check parameters that are
+	 * no longer optional for CRC enabled filesystems.  Catch them up front
+	 * here before doing anything else.
+	 */
+	if (cli->sb_feat.crcs_enabled) {
+		/* minimum inode size is 512 bytes, rest checked later */
+		if (cli->inodesize &&
+		    cli->inodesize < (1 << XFS_DINODE_DFL_CRC_LOG)) {
+			fprintf(stderr,
+_("Minimum inode size for CRCs is %d bytes\n"),
+				1 << XFS_DINODE_DFL_CRC_LOG);
+			usage();
+		}
+
+		/* inodes always aligned */
+		if (!cli->sb_feat.inode_align) {
+			fprintf(stderr,
+_("Inodes always aligned for CRC enabled filesytems\n"));
+			usage();
+		}
+
+		/* lazy sb counters always on */
+		if (!cli->sb_feat.lazy_sb_counters) {
+			fprintf(stderr,
+_("Lazy superblock counted always enabled for CRC enabled filesytems\n"));
+			usage();
+		}
+
+		/* version 2 logs always on */
+		if (cli->sb_feat.log_version != 2) {
+			fprintf(stderr,
+_("V2 logs always enabled for CRC enabled filesytems\n"));
+			usage();
+		}
+
+		/* attr2 always on */
+		if (cli->sb_feat.attr_version != 2) {
+			fprintf(stderr,
+_("V2 attribute format always enabled on CRC enabled filesytems\n"));
+			usage();
+		}
+
+		/* 32 bit project quota always on */
+		/* attr2 always on */
+		if (cli->sb_feat.projid16bit) {
+			fprintf(stderr,
+_("32 bit Project IDs always enabled on CRC enabled filesytems\n"));
+			usage();
+		}
+
+		/* ftype always on */
+		if (!cli->sb_feat.dirftype) {
+			fprintf(stderr,
+_("Directory ftype field always enabled on CRC enabled filesytems\n"));
+			usage();
+		}
+
+	} else {
+		/*
+		 * The kernel doesn't currently support crc=0,finobt=1
+		 * filesystems. If crcs are not enabled and the user has not
+		 * explicitly turned finobt on, then silently turn it off to
+		 * avoid an unnecessary warning.
+		 * If the user explicitly tried to use crc=0,finobt=1,
+		 * then issue an error.
+		 * The same is also for sparse inodes.
+		 */
+		if (cli->sb_feat.finobt && cli_opt_set(&mopts, M_FINOBT)) {
+			fprintf(stderr,
+_("finobt not supported without CRC support\n"));
+			usage();
+		}
+		cli->sb_feat.finobt = false;
+
+		if (cli->sb_feat.spinodes) {
+			fprintf(stderr,
+_("sparse inodes not supported without CRC support\n"));
+			usage();
+		}
+		cli->sb_feat.spinodes = false;
+
+		if (cli->sb_feat.rmapbt) {
+			fprintf(stderr,
+_("rmapbt not supported without CRC support\n"));
+			usage();
+		}
+		cli->sb_feat.rmapbt = false;
+
+		if (cli->sb_feat.reflink) {
+			fprintf(stderr,
+_("reflink not supported without CRC support\n"));
+			usage();
+		}
+		cli->sb_feat.reflink = false;
+	}
+
+
+	if (cli->sb_feat.rmapbt && cli->xi->rtname) {
+		fprintf(stderr,
+_("rmapbt not supported with realtime devices\n"));
+		usage();
+		cli->sb_feat.rmapbt = false;
+	}
+
+	/*
+	 * Copy features across to config structure now.
+	 */
+	cfg->sb_feat = cli->sb_feat;
+	if (!platform_uuid_is_null(&cli->uuid))
+		platform_uuid_copy(&cfg->uuid, &cli->uuid);
+}
+
 static void
 print_mkfs_cfg(
 	struct mkfs_params	*cfg,
@@ -2820,7 +2944,7 @@ main(
 	};
 	struct mkfs_params	cfg = {};
 
-	platform_uuid_generate(&uuid);
+	platform_uuid_generate(&cli.uuid);
 	progname = basename(argv[0]);
 	setlocale(LC_ALL, "");
 	bindtextdomain(PACKAGE, LOCALEDIR);
@@ -3012,11 +3136,6 @@ main(
 	sb_feat = cli.sb_feat;
 	/* end temp don't break code */
 
-	if (sb_feat.crcs_enabled && !sb_feat.dirftype) {
-		fprintf(stderr, _("cannot disable ftype with crcs enabled\n"));
-		usage();
-	}
-
 	/*
 	 * Extract as much of the valid config as we can from the CLI input
 	 * before opening the libxfs devices.
@@ -3025,6 +3144,7 @@ main(
 	validate_sectorsize(&cfg, &cli, &dft, &ft, dfile, dry_run,
 			    force_overwrite);
 	validate_log_sectorsize(&cfg, &cli, &dft);
+	validate_sb_features(&cfg, &cli);
 
 	/* temp don't break code */
 	sectorsize = cfg.sectorsize;
@@ -3034,103 +3154,9 @@ main(
 	lsectorsize = cfg.lsectorsize;
 	lsectorlog = cfg.lsectorlog;
 	sb_feat = cfg.sb_feat;
+	platform_uuid_copy(&uuid, &cfg.uuid);
 	/* end temp don't break code */
 
-	/*
-	 * Now we have blocks and sector sizes set up, check parameters that are
-	 * no longer optional for CRC enabled filesystems.  Catch them up front
-	 * here before doing anything else.
-	 */
-	if (sb_feat.crcs_enabled) {
-		/* minimum inode size is 512 bytes, ipflag checked later */
-		if ((isflag || ilflag) && inodelog < XFS_DINODE_DFL_CRC_LOG) {
-			fprintf(stderr,
-_("Minimum inode size for CRCs is %d bytes\n"),
-				1 << XFS_DINODE_DFL_CRC_LOG);
-			usage();
-		}
-
-		/* inodes always aligned */
-		if (!sb_feat.inode_align) {
-			fprintf(stderr,
-_("Inodes always aligned for CRC enabled filesytems\n"));
-			usage();
-		}
-
-		/* lazy sb counters always on */
-		if (!sb_feat.lazy_sb_counters) {
-			fprintf(stderr,
-_("Lazy superblock counted always enabled for CRC enabled filesytems\n"));
-			usage();
-		}
-
-		/* version 2 logs always on */
-		if (sb_feat.log_version != 2) {
-			fprintf(stderr,
-_("V2 logs always enabled for CRC enabled filesytems\n"));
-			usage();
-		}
-
-		/* attr2 always on */
-		if (sb_feat.attr_version != 2) {
-			fprintf(stderr,
-_("V2 attribute format always enabled on CRC enabled filesytems\n"));
-			usage();
-		}
-
-		/* 32 bit project quota always on */
-		/* attr2 always on */
-		if (sb_feat.projid16bit) {
-			fprintf(stderr,
-_("32 bit Project IDs always enabled on CRC enabled filesytems\n"));
-			usage();
-		}
-	} else {
-		/*
-		 * The kernel doesn't currently support crc=0,finobt=1
-		 * filesystems. If crcs are not enabled and the user has not
-		 * explicitly turned finobt on, then silently turn it off to
-		 * avoid an unnecessary warning.
-		 * If the user explicitly tried to use crc=0,finobt=1,
-		 * then issue an error.
-		 * The same is also for sparse inodes.
-		 */
-		if (sb_feat.finobt && mopts.subopt_params[M_FINOBT].seen) {
-			fprintf(stderr,
-_("finobt not supported without CRC support\n"));
-			usage();
-		}
-		sb_feat.finobt = 0;
-
-		if (sb_feat.spinodes) {
-			fprintf(stderr,
-_("sparse inodes not supported without CRC support\n"));
-			usage();
-		}
-		sb_feat.spinodes = 0;
-
-		if (sb_feat.rmapbt) {
-			fprintf(stderr,
-_("rmapbt not supported without CRC support\n"));
-			usage();
-		}
-		sb_feat.rmapbt = false;
-
-		if (sb_feat.reflink) {
-			fprintf(stderr,
-_("reflink not supported without CRC support\n"));
-			usage();
-		}
-		sb_feat.reflink = false;
-	}
-
-
-	if (sb_feat.rmapbt && xi.rtname) {
-		fprintf(stderr,
-_("rmapbt not supported with realtime devices\n"));
-		usage();
-		sb_feat.rmapbt = false;
-	}
 
 	if (nsflag || nlflag) {
 		if (dirblocksize < blocksize ||
-- 
2.13.3

