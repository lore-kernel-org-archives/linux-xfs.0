Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:57108 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752502AbdDKLKZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Apr 2017 07:10:25 -0400
Received: from 212095007090.public.telering.at ([212.95.7.90] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1cxtgm-0004oq-Hj
        for linux-xfs@vger.kernel.org; Tue, 11 Apr 2017 11:10:24 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/6] xfs: remove attr fork handling in xfs_bmap_finish_one
Date: Tue, 11 Apr 2017 13:10:07 +0200
Message-Id: <20170411111011.9437-3-hch@lst.de>
In-Reply-To: <20170411111011.9437-1-hch@lst.de>
References: <20170411111011.9437-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

We never do COW operations for the attr fork, so don't pretend we handle
them.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_bmap.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 2a426d127e05..b95e66fd0935 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -6491,7 +6491,6 @@ xfs_bmap_finish_one(
 	struct xfs_bmbt_irec		bmap;
 	int				nimaps = 1;
 	xfs_fsblock_t			firstfsb;
-	int				flags = XFS_BMAPI_REMAP;
 	int				done;
 	int				error = 0;
 
@@ -6505,10 +6504,8 @@ xfs_bmap_finish_one(
 			XFS_FSB_TO_AGBNO(tp->t_mountp, startblock),
 			ip->i_ino, whichfork, startoff, blockcount, state);
 
-	if (whichfork != XFS_DATA_FORK && whichfork != XFS_ATTR_FORK)
+	if (WARN_ON_ONCE(whichfork != XFS_DATA_FORK))
 		return -EFSCORRUPTED;
-	if (whichfork == XFS_ATTR_FORK)
-		flags |= XFS_BMAPI_ATTRFORK;
 
 	if (XFS_TEST_ERROR(false, tp->t_mountp,
 			XFS_ERRTAG_BMAP_FINISH_ONE,
@@ -6519,13 +6516,13 @@ xfs_bmap_finish_one(
 	case XFS_BMAP_MAP:
 		firstfsb = bmap.br_startblock;
 		error = xfs_bmapi_write(tp, ip, bmap.br_startoff,
-					bmap.br_blockcount, flags, &firstfsb,
+					bmap.br_blockcount, XFS_BMAPI_REMAP, &firstfsb,
 					bmap.br_blockcount, &bmap, &nimaps,
 					dfops);
 		break;
 	case XFS_BMAP_UNMAP:
 		error = xfs_bunmapi(tp, ip, bmap.br_startoff,
-				bmap.br_blockcount, flags, 1, &firstfsb,
+				bmap.br_blockcount, XFS_BMAPI_REMAP, 1, &firstfsb,
 				dfops, &done);
 		ASSERT(done);
 		break;
-- 
2.11.0

