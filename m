Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:43207 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932172AbdBGRPj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Feb 2017 12:15:39 -0500
Received: from 80-109-146-114.cable.dynamic.surfer.at ([80.109.146.114] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1cb9MO-0006RD-CB
        for linux-xfs@vger.kernel.org; Tue, 07 Feb 2017 17:15:29 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/5] xfs: don't fail xfs_extent_busy allocation
Date: Tue,  7 Feb 2017 18:14:57 +0100
Message-Id: <20170207171501.4268-2-hch@lst.de>
In-Reply-To: <20170207171501.4268-1-hch@lst.de>
References: <20170207171501.4268-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

We don't just need the structure to track busy extents which can be
avoided with a synchronous transaction, but also to keep track of
pending discard.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_extent_busy.c | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/fs/xfs/xfs_extent_busy.c b/fs/xfs/xfs_extent_busy.c
index 162dc186cf04..29c2f997aedf 100644
--- a/fs/xfs/xfs_extent_busy.c
+++ b/fs/xfs/xfs_extent_busy.c
@@ -45,18 +45,7 @@ xfs_extent_busy_insert(
 	struct rb_node		**rbp;
 	struct rb_node		*parent = NULL;
 
-	new = kmem_zalloc(sizeof(struct xfs_extent_busy), KM_MAYFAIL);
-	if (!new) {
-		/*
-		 * No Memory!  Since it is now not possible to track the free
-		 * block, make this a synchronous transaction to insure that
-		 * the block is not reused before this transaction commits.
-		 */
-		trace_xfs_extent_busy_enomem(tp->t_mountp, agno, bno, len);
-		xfs_trans_set_sync(tp);
-		return;
-	}
-
+	new = kmem_zalloc(sizeof(struct xfs_extent_busy), KM_SLEEP);
 	new->agno = agno;
 	new->bno = bno;
 	new->length = len;
-- 
2.11.0

