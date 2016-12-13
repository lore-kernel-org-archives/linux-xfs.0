Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40488 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932700AbcLMP7v (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Dec 2016 10:59:51 -0500
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/4] xfs: calculate minleft correctly for bmap allocations
Date: Tue, 13 Dec 2016 16:59:25 +0100
Message-Id: <1481644767-9098-3-git-send-email-hch@lst.de>
In-Reply-To: <1481644767-9098-1-git-send-email-hch@lst.de>
References: <1481644767-9098-1-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: eguan@redhat.com, darrick.wong@oracle.com

We need to take into account the worst possible number of bmap and rmap
btree block allocations.  Use the helper we have to calculate it instead
of doing an overly optimistic estimate.  Also move the call to calculate
it into the function that sets the allocation parameters, as we have
more accurate information about the allocation there.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_bmap.c | 16 ++++++----------
 fs/xfs/libxfs/xfs_bmap.h |  1 -
 2 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 44773c9..2126ecc 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3764,7 +3764,12 @@ xfs_bmap_btalloc(
 		args.alignment = 1;
 		args.minalignslop = 0;
 	}
-	args.minleft = ap->minleft;
+
+	/*
+	 * Ensure we have enough blocks left in the AG to satisfy all possible
+	 * bmap and rmap tree block allocations.
+	 */
+	args.minleft = xfs_bmap_worst_indlen(ap->ip, args.maxlen);
 	args.wasdel = ap->wasdel;
 	args.resv = XFS_AG_RESV_NONE;
 	args.datatype = ap->datatype;
@@ -4572,15 +4577,6 @@ xfs_bmapi_write(
 
 	XFS_STATS_INC(mp, xs_blk_mapw);
 
-	if (*firstblock == NULLFSBLOCK) {
-		if (XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_BTREE)
-			bma.minleft = be16_to_cpu(ifp->if_broot->bb_level) + 1;
-		else
-			bma.minleft = 1;
-	} else {
-		bma.minleft = 0;
-	}
-
 	if (!(ifp->if_flags & XFS_IFEXTENTS)) {
 		error = xfs_iread_extents(tp, ip, whichfork);
 		if (error)
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index cecd094..92e6755 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -49,7 +49,6 @@ struct xfs_bmalloca {
 
 	xfs_extlen_t		total;	/* total blocks needed for xaction */
 	xfs_extlen_t		minlen;	/* minimum allocation size (blocks) */
-	xfs_extlen_t		minleft; /* amount must be left after alloc */
 	bool			eof;	/* set if allocating past last extent */
 	bool			wasdel;	/* replacing a delayed allocation */
 	bool			aeof;	/* allocated space at eof */
-- 
2.1.4

