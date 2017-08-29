Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:11621 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751877AbdH2XvG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Aug 2017 19:51:06 -0400
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1dmqHW-0002ch-O5
        for linux-xfs@vger.kernel.org; Wed, 30 Aug 2017 09:50:54 +1000
Received: from dave by discord.disaster.area with local (Exim 4.89)
        (envelope-from <david@fromorbit.com>)
        id 1dmqHW-0005Vy-MO
        for linux-xfs@vger.kernel.org; Wed, 30 Aug 2017 09:50:54 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 13/42] mkfs: Introduce mkfs configuration structure
Date: Wed, 30 Aug 2017 09:50:23 +1000
Message-Id: <20170829235052.21050-14-david@fromorbit.com>
In-Reply-To: <20170829235052.21050-1-david@fromorbit.com>
References: <20170829235052.21050-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Formatting the on disk XFS structures requires a certain set of
validated and calculated parameters. By the time we start writing
information to diskm this has all be done. Abstract this information
out into a separate structure and initialise it with all the
calculated parameters so we can factor the mkfs formatting code
to use it.

Signed-Off-By: Dave Chinner <dchinner@redhat.com>
---
 mkfs/xfs_mkfs.c | 87 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 87 insertions(+)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 5a646b89cd0f..b92c3316358f 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -799,6 +799,58 @@ struct cli_params {
 	struct libxfs_xinit	*xi;
 };
 
+/*
+ * Calculated filesystem feature and geometry information.
+ *
+ * This structure contains the information we will use to create the on-disk
+ * filesystem from. The validation and calculation code uses it to store all the
+ * temporary and final config state for the filesystem.
+ *
+ * The information in this structure will contain a mix of validated CLI input
+ * variables, default feature state and calculated values that are needed to
+ * construct the superblock and other on disk features. These are all in one
+ * place so that we don't have to pass handfuls of seemingly arbitrary variables
+ * around to different functions to do teh work we need to do.
+ */
+struct mkfs_params {
+	int		blocksize;
+	int		blocklog;
+	int		sectorsize;
+	int		sectorlog;
+	int		lsectorsize;
+	int		lsectorlog;
+	int		dirblocksize;
+	int		dirblocklog;
+	int		inodesize;
+	int		inodelog;
+	int		inopblock;
+
+	uint64_t	dblocks;
+	uint64_t	logblocks;
+	uint64_t	rtblocks;
+	uint64_t	rtextblocks;
+	uint64_t	rtextents;
+	uint64_t	rtbmblocks;	/* rt bitmap blocks */
+
+	int		dsunit;		/* in FSBs */
+	int		dswidth;	/* in FSBs */
+	int		lsunit;		/* in FSBs */
+
+	uint64_t	agsize;
+	uint64_t	agcount;
+
+	int		imaxpct;
+
+	bool		loginternal;
+	uint64_t	logstart;
+	uint64_t	logagno;
+
+	uuid_t		uuid;
+	char		*label;
+
+	struct sb_feat_args	sb_feat;
+};
+
 #define TERABYTES(count, blog)	((uint64_t)(count) << (40 - (blog)))
 #define GIGABYTES(count, blog)	((uint64_t)(count) << (30 - (blog)))
 #define MEGABYTES(count, blog)	((uint64_t)(count) << (20 - (blog)))
@@ -1941,6 +1993,7 @@ main(
 		.xi = &xi,
 		.sb_feat = sb_feat,
 	};
+	struct mkfs_params	cfg = {};
 
 	platform_uuid_generate(&uuid);
 	progname = basename(argv[0]);
@@ -2965,6 +3018,39 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 	}
 	validate_log_size(logblocks, blocklog, min_logblocks);
 
+	/* Temp support code  to set up mkfs cfg parameters */
+	cfg.blocksize = blocksize;
+	cfg.blocklog = blocklog;
+	cfg.sectorsize = sectorsize;
+	cfg.sectorlog = sectorlog;
+	cfg.lsectorsize = lsectorsize;
+	cfg.lsectorlog = lsectorlog;
+	cfg.dirblocksize = dirblocksize;
+	cfg.dirblocklog = dirblocklog;
+	cfg.inodesize = isize;
+	cfg.inodelog = inodelog;
+	cfg.inopblock = inopblock;
+
+	cfg.dblocks = dblocks;
+	cfg.logblocks = logblocks;
+	cfg.rtblocks = rtblocks;
+	cfg.rtextblocks = rtextblocks;
+	cfg.rtextents = rtextents;
+	cfg.rtbmblocks = nbmblocks;
+	cfg.dsunit = dsunit;
+	cfg.dswidth = dswidth;
+	cfg.lsunit = lsunit;
+	cfg.agsize = agsize;
+	cfg.agcount = agcount;
+	cfg.imaxpct = imaxpct;
+	cfg.loginternal = loginternal;
+	cfg.logstart = logstart;
+	cfg.logagno = logagno;
+	cfg.label = label;
+	platform_uuid_copy(&cfg.uuid, &uuid);
+	memcpy(&cfg.sb_feat, &sb_feat, sizeof(sb_feat));
+	/* end temp support code */
+
 	if (!qflag || Nflag) {
 		printf(_(
 		   "meta-data=%-22s isize=%-6d agcount=%lld, agsize=%lld blks\n"
@@ -2994,6 +3080,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 			exit(0);
 	}
 
+
 	if (label)
 		strncpy(sbp->sb_fname, label, sizeof(sbp->sb_fname));
 	sbp->sb_magicnum = XFS_SB_MAGIC;
-- 
2.13.3

