Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:36957 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751891AbdH2XvE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Aug 2017 19:51:04 -0400
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1dmqHX-0002dQ-4a
        for linux-xfs@vger.kernel.org; Wed, 30 Aug 2017 09:50:55 +1000
Received: from dave by discord.disaster.area with local (Exim 4.89)
        (envelope-from <david@fromorbit.com>)
        id 1dmqHX-0005Wh-34
        for linux-xfs@vger.kernel.org; Wed, 30 Aug 2017 09:50:55 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 28/42] mkfs: fix hidden parameter in DTOBT()
Date: Wed, 30 Aug 2017 09:50:38 +1000
Message-Id: <20170829235052.21050-29-david@fromorbit.com>
In-Reply-To: <20170829235052.21050-1-david@fromorbit.com>
References: <20170829235052.21050-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Hiding references to variables inside macros instead of passing them
as parameters is just plain nasty. Fix it before going any further.

Signed-Off-By: Dave Chinner <dchinner@redhat.com>
---
 mkfs/xfs_mkfs.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index e7e366cc518c..1f41d5f813f0 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -879,7 +879,7 @@ struct mkfs_default_params {
 /*
  * Use this macro before we have superblock and mount structure
  */
-#define	DTOBT(d)	((xfs_rfsblock_t)((d) >> (blocklog - BBSHIFT)))
+#define	DTOBT(d, bl)	((xfs_rfsblock_t)((d) >> ((bl) - BBSHIFT)))
 
 /*
  * Use this for block reservations needed for mkfs's conditions
@@ -3295,7 +3295,7 @@ main(
 
 		/* check that rswidth is a multiple of fs blocksize */
 		if (!norsflag && rswidth && !(BBTOB(rswidth) % blocksize)) {
-			rswidth = DTOBT(rswidth);
+			rswidth = DTOBT(rswidth, blocklog);
 			rtextbytes = rswidth << blocklog;
 			if (XFS_MIN_RTEXTSIZE <= rtextbytes &&
 			    (rtextbytes <= XFS_MAX_RTEXTSIZE)) {
@@ -3374,14 +3374,14 @@ main(
 		rtfile = _("volume rt");
 	else if (!xi.rtdev)
 		rtfile = _("none");
-	if (dsize && xi.dsize > 0 && dblocks > DTOBT(xi.dsize)) {
+	if (dsize && xi.dsize > 0 && dblocks > DTOBT(xi.dsize, blocklog)) {
 		fprintf(stderr,
 			_("size %s specified for data subvolume is too large, "
 			"maximum is %lld blocks\n"),
-			dsize, (long long)DTOBT(xi.dsize));
+			dsize, (long long)DTOBT(xi.dsize, blocklog));
 		usage();
 	} else if (!dsize && xi.dsize > 0)
-		dblocks = DTOBT(xi.dsize);
+		dblocks = DTOBT(xi.dsize, blocklog);
 	else if (!dsize) {
 		fprintf(stderr, _("can't get size of data subvolume\n"));
 		usage();
@@ -3422,14 +3422,14 @@ reported by the device (%u).\n"),
 			sectorsize, xi.rtbsize);
 	}
 
-	if (rtsize && xi.rtsize > 0 && rtblocks > DTOBT(xi.rtsize)) {
+	if (rtsize && xi.rtsize > 0 && rtblocks > DTOBT(xi.rtsize, blocklog)) {
 		fprintf(stderr,
 			_("size %s specified for rt subvolume is too large, "
 			"maximum is %lld blocks\n"),
-			rtsize, (long long)DTOBT(xi.rtsize));
+			rtsize, (long long)DTOBT(xi.rtsize, blocklog));
 		usage();
 	} else if (!rtsize && xi.rtsize > 0)
-		rtblocks = DTOBT(xi.rtsize);
+		rtblocks = DTOBT(xi.rtsize, blocklog);
 	else if (rtsize && !xi.rtdev) {
 		fprintf(stderr,
 			_("size specified for non-existent rt subvolume\n"));
@@ -3494,8 +3494,8 @@ reported by the device (%u).\n"),
 	    dswidth && !(BBTOB(dswidth) % blocksize)) {
 
 		/* convert from 512 byte blocks to fs blocksize */
-		dsunit = DTOBT(dsunit);
-		dswidth = DTOBT(dswidth);
+		dsunit = DTOBT(dsunit, blocklog);
+		dswidth = DTOBT(dswidth, blocklog);
 
 		/*
 		 * agsize is not a multiple of dsunit
@@ -3610,7 +3610,7 @@ an AG size that is one stripe unit smaller, for example %llu.\n"),
 
 	if (lsunit) {
 		/* convert from 512 byte blocks to fs blocks */
-		lsunit = DTOBT(lsunit);
+		lsunit = DTOBT(lsunit, blocklog);
 	} else if (sb_feat.log_version == 2 && loginternal && dsunit) {
 		/* lsunit and dsunit now in fs blocks */
 		lsunit = dsunit;
@@ -3638,13 +3638,13 @@ an AG size that is one stripe unit smaller, for example %llu.\n"),
 	min_logblocks = MAX(XFS_MIN_LOG_BLOCKS, min_logblocks);
 	if (!logsize && dblocks >= (1024*1024*1024) >> blocklog)
 		min_logblocks = MAX(min_logblocks, XFS_MIN_LOG_BYTES>>blocklog);
-	if (logsize && xi.logBBsize > 0 && logblocks > DTOBT(xi.logBBsize)) {
+	if (logsize && xi.logBBsize > 0 && logblocks > DTOBT(xi.logBBsize, blocklog)) {
 		fprintf(stderr,
 _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
-			logsize, (long long)DTOBT(xi.logBBsize));
+			logsize, (long long)DTOBT(xi.logBBsize, blocklog));
 		usage();
 	} else if (!logsize && xi.logBBsize > 0) {
-		logblocks = DTOBT(xi.logBBsize);
+		logblocks = DTOBT(xi.logBBsize, blocklog);
 	} else if (logsize && !xi.logdev && !loginternal) {
 		fprintf(stderr,
 			_("size specified for non-existent log subvolume\n"));
-- 
2.13.3

