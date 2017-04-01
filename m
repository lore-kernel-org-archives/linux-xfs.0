Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:52416 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751541AbdDAGlj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 1 Apr 2017 02:41:39 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 16/27] xfs: don't fail xfs_extent_busy allocation
Date: Sat,  1 Apr 2017 08:40:15 +0200
Message-Id: <20170401064026.5783-17-hch@lst.de>
In-Reply-To: <20170401064026.5783-1-hch@lst.de>
References: <20170401064026.5783-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>

commit 5e30c23d13919a718b22d4921dc5c0accc59da27 upstream.

We don't just need the structure to track busy extents which can be
avoided with a synchronous transaction, but also to keep track of
pending discard.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
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

