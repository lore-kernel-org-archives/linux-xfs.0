Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:27944 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751910AbdH2XvF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Aug 2017 19:51:05 -0400
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1dmqHX-0002dL-2g
        for linux-xfs@vger.kernel.org; Wed, 30 Aug 2017 09:50:55 +1000
Received: from dave by discord.disaster.area with local (Exim 4.89)
        (envelope-from <david@fromorbit.com>)
        id 1dmqHX-0005Wb-1M
        for linux-xfs@vger.kernel.org; Wed, 30 Aug 2017 09:50:55 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 26/42] mkfs: factor inode size validation
Date: Wed, 30 Aug 2017 09:50:36 +1000
Message-Id: <20170829235052.21050-27-david@fromorbit.com>
In-Reply-To: <20170829235052.21050-1-david@fromorbit.com>
References: <20170829235052.21050-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Signed-Off-By: Dave Chinner <dchinner@redhat.com>
---
 mkfs/xfs_mkfs.c | 101 +++++++++++++++++++++++++++++---------------------------
 1 file changed, 53 insertions(+), 48 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 72b21d715613..0062380254c9 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2245,6 +2245,54 @@ validate_dirblocksize(
 }
 
 static void
+validate_inodesize(
+	struct mkfs_params	*cfg,
+	struct cli_params	*cli)
+{
+
+	if (cli->inopblock)
+		cfg->inodelog = cfg->blocklog - libxfs_highbit32(cli->inopblock);
+	else if (cli->inodesize)
+		cfg->inodelog = libxfs_highbit32(cli->inodesize);
+	else if (cfg->sb_feat.crcs_enabled)
+		cfg->inodelog = XFS_DINODE_DFL_CRC_LOG;
+	else
+		cfg->inodelog = XFS_DINODE_DFL_LOG;
+
+	cfg->inodesize = 1 << cfg->inodelog;
+	cfg->inopblock = cfg->blocksize / cfg->inodesize;
+
+	/* input parsing has already validated non-crc inode size range */
+	if (cfg->sb_feat.crcs_enabled &&
+	    cfg->inodelog < XFS_DINODE_DFL_CRC_LOG) {
+		fprintf(stderr,
+		_("Minimum inode size for CRCs is %d bytes\n"),
+			1 << XFS_DINODE_DFL_CRC_LOG);
+		usage();
+	}
+
+	if (cfg->inodesize > cfg->blocksize / XFS_MIN_INODE_PERBLOCK ||
+	    cfg->inopblock < XFS_MIN_INODE_PERBLOCK ||
+	    cfg->inodesize < XFS_DINODE_MIN_SIZE ||
+	    cfg->inodesize > XFS_DINODE_MAX_SIZE) {
+		int	maxsz;
+
+		fprintf(stderr, _("illegal inode size %d\n"), cfg->inodesize);
+		maxsz = MIN(cfg->blocksize / XFS_MIN_INODE_PERBLOCK,
+			    XFS_DINODE_MAX_SIZE);
+		if (XFS_DINODE_MIN_SIZE == maxsz)
+			fprintf(stderr,
+			_("allowable inode size with %d byte blocks is %d\n"),
+				cfg->blocksize, XFS_DINODE_MIN_SIZE);
+		else
+			fprintf(stderr,
+	_("allowable inode size with %d byte blocks is between %d and %d\n"),
+				cfg->blocksize, XFS_DINODE_MIN_SIZE, maxsz);
+		exit(1);
+	}
+}
+
+static void
 print_mkfs_cfg(
 	struct mkfs_params	*cfg,
 	char			*dfile,
@@ -2889,13 +2937,10 @@ main(
 	int			dsflag;
 	int			force_overwrite;
 	struct fsxattr		fsx;
-	int			ilflag;
 	int			imaxpct;
 	int			imflag;
 	int			inodelog;
 	int			inopblock;
-	int			ipflag;
-	int			isflag;
 	int			isize;
 	char			*label = NULL;
 	int			laflag;
@@ -3001,7 +3046,7 @@ main(
 	cli.loginternal = 1;	/* internal by default */
 
 	agsize = daflag = dasize = dblocks = 0;
-	ilflag = imflag = ipflag = isflag = 0;
+	imflag = 0;
 	liflag = laflag = lsflag = lsuflag = lsunitflag = ldflag = lvflag = 0;
 	loginternal = 1;
 	logagno = logblocks = rtblocks = rtextblocks = 0;
@@ -3061,13 +3106,6 @@ main(
 			parse_subopts(c, optarg, &cli);
 
 			/* temp don't break code */
-			isize = cli.inodesize;
-			inodelog = libxfs_highbit32(isize);
-			inopblock = cli.inopblock;
-			ilflag = cli_opt_set(&iopts, I_LOG);
-			isflag = cli_opt_set(&iopts, I_SIZE);
-			ipflag = cli_opt_set(&iopts, I_PERBLOCK);
-
 			imaxpct = cli.imaxpct;
 			imflag = cli_opt_set(&iopts, I_MAXPCT);
 			/* end temp don't break code */
@@ -3166,6 +3204,7 @@ main(
 	 * the cfg structure for them, not the command line structure.
 	 */
 	validate_dirblocksize(&cfg, &cli);
+	validate_inodesize(&cfg, &cli);
 
 	/* temp don't break code */
 	sectorsize = cfg.sectorsize;
@@ -3178,6 +3217,9 @@ main(
 	platform_uuid_copy(&uuid, &cfg.uuid);
 	dirblocksize = cfg.dirblocksize;
 	dirblocklog = cfg.dirblocklog;
+	isize = cfg.inodesize;
+	inodelog = cfg.inodelog;
+	inopblock = cfg.inopblock;
 	/* end temp don't break code */
 
 	if (dsize) {
@@ -3197,21 +3239,6 @@ main(
 				(long long)dbytes, blocksize,
 				(long long)(dblocks << blocklog));
 	}
-	if (ipflag) {
-		inodelog = blocklog - libxfs_highbit32(inopblock);
-		isize = 1 << inodelog;
-	} else if (!ilflag && !isflag) {
-		inodelog = sb_feat.crcs_enabled ? XFS_DINODE_DFL_CRC_LOG
-						: XFS_DINODE_DFL_LOG;
-		isize = 1 << inodelog;
-	}
-	if (sb_feat.crcs_enabled && inodelog < XFS_DINODE_DFL_CRC_LOG) {
-		fprintf(stderr,
-		_("Minimum inode size for CRCs is %d bytes\n"),
-			1 << XFS_DINODE_DFL_CRC_LOG);
-		usage();
-	}
-
 	if (logsize) {
 		uint64_t logbytes;
 
@@ -3290,28 +3317,6 @@ main(
 	}
 	ASSERT(rtextblocks);
 
-	/*
-	 * Check some argument sizes against mins, maxes.
-	 */
-	if (isize > blocksize / XFS_MIN_INODE_PERBLOCK ||
-	    isize < XFS_DINODE_MIN_SIZE ||
-	    isize > XFS_DINODE_MAX_SIZE) {
-		int	maxsz;
-
-		fprintf(stderr, _("illegal inode size %d\n"), isize);
-		maxsz = MIN(blocksize / XFS_MIN_INODE_PERBLOCK,
-			    XFS_DINODE_MAX_SIZE);
-		if (XFS_DINODE_MIN_SIZE == maxsz)
-			fprintf(stderr,
-			_("allowable inode size with %d byte blocks is %d\n"),
-				blocksize, XFS_DINODE_MIN_SIZE);
-		else
-			fprintf(stderr,
-	_("allowable inode size with %d byte blocks is between %d and %d\n"),
-				blocksize, XFS_DINODE_MIN_SIZE, maxsz);
-		exit(1);
-	}
-
 	calc_stripe_factors(dsu, dsw, sectorsize, lsu, lsectorsize,
 				&dsunit, &dswidth, &lsunit);
 
-- 
2.13.3

