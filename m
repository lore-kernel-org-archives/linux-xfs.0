Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:27944 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751947AbdH2XvJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Aug 2017 19:51:09 -0400
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1dmqHX-0002dN-3T
        for linux-xfs@vger.kernel.org; Wed, 30 Aug 2017 09:50:55 +1000
Received: from dave by discord.disaster.area with local (Exim 4.89)
        (envelope-from <david@fromorbit.com>)
        id 1dmqHX-0005We-2F
        for linux-xfs@vger.kernel.org; Wed, 30 Aug 2017 09:50:55 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 27/42] mkfs: factor out device size calculations
Date: Wed, 30 Aug 2017 09:50:37 +1000
Message-Id: <20170829235052.21050-28-david@fromorbit.com>
In-Reply-To: <20170829235052.21050-1-david@fromorbit.com>
References: <20170829235052.21050-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Signed-Off-By: Dave Chinner <dchinner@redhat.com>
---
 mkfs/xfs_mkfs.c | 94 ++++++++++++++++++++++++++-------------------------------
 1 file changed, 43 insertions(+), 51 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 0062380254c9..e7e366cc518c 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2292,6 +2292,37 @@ validate_inodesize(
 	}
 }
 
+static xfs_rfsblock_t
+calc_dev_size(
+	char			*size,
+	struct mkfs_params	*cfg,
+	struct opt_params	*opts,
+	int			sizeopt,
+	char			*type)
+{
+	uint64_t		dbytes;
+	xfs_rfsblock_t		dblocks;
+
+	if (!size)
+		return 0;
+
+	dbytes = getnum(size, opts, sizeopt);
+	if (dbytes % XFS_MIN_BLOCKSIZE) {
+		fprintf(stderr,
+		_("illegal %s length %lld, not a multiple of %d\n"),
+			type, (long long)dbytes, XFS_MIN_BLOCKSIZE);
+		usage();
+	}
+	dblocks = (xfs_rfsblock_t)(dbytes >> cfg->blocklog);
+	if (dbytes % cfg->blocksize) {
+		fprintf(stderr,
+_("warning: %s length %lld not a multiple of %d, truncated to %lld\n"),
+			type, (long long)dbytes, cfg->blocksize,
+			(long long)(dblocks << cfg->blocklog));
+	}
+	return dblocks;
+}
+
 static void
 print_mkfs_cfg(
 	struct mkfs_params	*cfg,
@@ -3206,6 +3237,15 @@ main(
 	validate_dirblocksize(&cfg, &cli);
 	validate_inodesize(&cfg, &cli);
 
+	/*
+	 * if the device size was specified convert it to a block count
+	 * now we have a valid block size. These will be set to zero if
+	 * nothing was specified, indicating we should use the full device.
+	 */
+	cfg.dblocks = calc_dev_size(cli.dsize, &cfg, &dopts, D_SIZE, "data");
+	cfg.logblocks = calc_dev_size(cli.logsize, &cfg, &lopts, L_SIZE, "log");
+	cfg.rtblocks = calc_dev_size(cli.rtsize, &cfg, &ropts, R_SIZE, "rt");
+
 	/* temp don't break code */
 	sectorsize = cfg.sectorsize;
 	sectorlog = cfg.sectorlog;
@@ -3220,59 +3260,11 @@ main(
 	isize = cfg.inodesize;
 	inodelog = cfg.inodelog;
 	inopblock = cfg.inopblock;
+	dblocks = cfg.dblocks;
+	logblocks = cfg.logblocks;
+	rtblocks = cfg.rtblocks;
 	/* end temp don't break code */
 
-	if (dsize) {
-		uint64_t dbytes;
-
-		dbytes = getnum(dsize, &dopts, D_SIZE);
-		if (dbytes % XFS_MIN_BLOCKSIZE) {
-			fprintf(stderr,
-			_("illegal data length %lld, not a multiple of %d\n"),
-				(long long)dbytes, XFS_MIN_BLOCKSIZE);
-			usage();
-		}
-		dblocks = (xfs_rfsblock_t)(dbytes >> blocklog);
-		if (dbytes % blocksize)
-			fprintf(stderr, _("warning: "
-	"data length %lld not a multiple of %d, truncated to %lld\n"),
-				(long long)dbytes, blocksize,
-				(long long)(dblocks << blocklog));
-	}
-	if (logsize) {
-		uint64_t logbytes;
-
-		logbytes = getnum(logsize, &lopts, L_SIZE);
-		if (logbytes % XFS_MIN_BLOCKSIZE) {
-			fprintf(stderr,
-			_("illegal log length %lld, not a multiple of %d\n"),
-				(long long)logbytes, XFS_MIN_BLOCKSIZE);
-			usage();
-		}
-		logblocks = (xfs_rfsblock_t)(logbytes >> blocklog);
-		if (logbytes % blocksize)
-			fprintf(stderr,
-	_("warning: log length %lld not a multiple of %d, truncated to %lld\n"),
-				(long long)logbytes, blocksize,
-				(long long)(logblocks << blocklog));
-	}
-	if (rtsize) {
-		uint64_t rtbytes;
-
-		rtbytes = getnum(rtsize, &ropts, R_SIZE);
-		if (rtbytes % XFS_MIN_BLOCKSIZE) {
-			fprintf(stderr,
-			_("illegal rt length %lld, not a multiple of %d\n"),
-				(long long)rtbytes, XFS_MIN_BLOCKSIZE);
-			usage();
-		}
-		rtblocks = (xfs_rfsblock_t)(rtbytes >> blocklog);
-		if (rtbytes % blocksize)
-			fprintf(stderr,
-	_("warning: rt length %lld not a multiple of %d, truncated to %lld\n"),
-				(long long)rtbytes, blocksize,
-				(long long)(rtblocks << blocklog));
-	}
 	/*
 	 * If specified, check rt extent size against its constraints.
 	 */
-- 
2.13.3

