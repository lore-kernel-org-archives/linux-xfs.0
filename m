Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:50451 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751450AbdDMIFj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Apr 2017 04:05:39 -0400
Received: from 212095007060.public.telering.at ([212.95.7.60] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1cyZl3-0007ZF-N1
        for linux-xfs@vger.kernel.org; Thu, 13 Apr 2017 08:05:38 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 04/10] xfs: remove an unsafe retry in xfs_bmbt_alloc_block
Date: Thu, 13 Apr 2017 10:05:11 +0200
Message-Id: <20170413080517.12564-5-hch@lst.de>
In-Reply-To: <20170413080517.12564-1-hch@lst.de>
References: <20170413080517.12564-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

We've already reserved all possible required blocks and checked
they are avaible in the same AG.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_bmap_btree.c | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index 3e17ceda038c..ce41dd5fbb34 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -476,19 +476,6 @@ xfs_bmbt_alloc_block(
 	if (error)
 		goto error0;
 
-	if (args.fsbno == NULLFSBLOCK && args.minleft) {
-		/*
-		 * Could not find an AG with enough free space to satisfy
-		 * a full btree split.  Try again and if
-		 * successful activate the lowspace algorithm.
-		 */
-		args.fsbno = 0;
-		args.type = XFS_ALLOCTYPE_FIRST_AG;
-		error = xfs_alloc_vextent(&args);
-		if (error)
-			goto error0;
-		cur->bc_private.b.dfops->dop_low = true;
-	}
 	if (WARN_ON_ONCE(args.fsbno == NULLFSBLOCK)) {
 		XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
 		*stat = 0;
-- 
2.11.0

