Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:38703 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753957AbdDMIFv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Apr 2017 04:05:51 -0400
Received: from 212095007060.public.telering.at ([212.95.7.60] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1cyZlB-0007dK-Mm
        for linux-xfs@vger.kernel.org; Thu, 13 Apr 2017 08:05:46 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 06/10] xfs: fix bmap minleft calculation
Date: Thu, 13 Apr 2017 10:05:13 +0200
Message-Id: <20170413080517.12564-7-hch@lst.de>
In-Reply-To: <20170413080517.12564-1-hch@lst.de>
References: <20170413080517.12564-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

We need to set a proper minleft value even if we didn't do a previous
allocation in the transaction, as we can't switch to a different AG
after allocating the data extent.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_bmap.c | 27 +++++++++++++++++----------
 fs/xfs/libxfs/xfs_bmap.h |  1 -
 2 files changed, 17 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 53f1386b1868..6faefa342748 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3570,6 +3570,22 @@ xfs_bmap_btalloc_filestreams(
 	return 0;
 }
 
+/*
+ * Return the minimum number of blocks required for the bmap btree manipulation
+ * after adding a single extent.
+ */
+static xfs_extlen_t
+xfs_bmap_minleft(
+	struct xfs_bmalloca	*ap)
+{
+	int			whichfork = xfs_bmapi_whichfork(ap->flags);
+	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ap->ip, whichfork);
+
+	if (XFS_IFORK_FORMAT(ap->ip, whichfork) == XFS_DINODE_FMT_BTREE)
+		return be16_to_cpu(ifp->if_broot->bb_level) + 1;
+	return 1;
+}
+
 STATIC int
 xfs_bmap_btalloc(
 	struct xfs_bmalloca	*ap)	/* bmap alloc argument struct */
@@ -3738,7 +3754,7 @@ xfs_bmap_btalloc(
 		args.alignment = 1;
 		args.minalignslop = 0;
 	}
-	args.minleft = ap->minleft;
+	args.minleft = xfs_bmap_minleft(ap);
 	args.wasdel = ap->wasdel;
 	args.resv = XFS_AG_RESV_NONE;
 	args.datatype = ap->datatype;
@@ -4493,15 +4509,6 @@ xfs_bmapi_write(
 
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
index d9e0b1db4cdb..36a7f36f5f38 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -48,7 +48,6 @@ struct xfs_bmalloca {
 	int			logflags;/* flags for transaction logging */
 
 	xfs_extlen_t		total;	/* total blocks needed for xaction */
-	xfs_extlen_t		minleft; /* amount must be left after alloc */
 	bool			eof;	/* set if allocating past last extent */
 	bool			wasdel;	/* replacing a delayed allocation */
 	bool			aeof;	/* allocated space at eof */
-- 
2.11.0

