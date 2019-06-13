Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:57430 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726622AbfFMSDN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Jun 2019 14:03:13 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 04/20] xfs: remove the dummy iop_push implementation for inode creation items
Date: Thu, 13 Jun 2019 20:02:44 +0200
Message-Id: <20190613180300.30447-5-hch@lst.de>
In-Reply-To: <20190613180300.30447-1-hch@lst.de>
References: <20190613180300.30447-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Brian Foster <bfoster@redhat.com>

This method should never be called, so don't waste code on it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_icreate_item.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/fs/xfs/xfs_icreate_item.c b/fs/xfs/xfs_icreate_item.c
index 03c174ff1ab3..cbaabc55f0c9 100644
--- a/fs/xfs/xfs_icreate_item.c
+++ b/fs/xfs/xfs_icreate_item.c
@@ -83,23 +83,12 @@ xfs_icreate_item_committed(
 	return (xfs_lsn_t)-1;
 }
 
-/* item can never get into the AIL */
-STATIC uint
-xfs_icreate_item_push(
-	struct xfs_log_item	*lip,
-	struct list_head	*buffer_list)
-{
-	ASSERT(0);
-	return XFS_ITEM_SUCCESS;
-}
-
 /*
  * This is the ops vector shared by all buf log items.
  */
 static const struct xfs_item_ops xfs_icreate_item_ops = {
 	.iop_size	= xfs_icreate_item_size,
 	.iop_format	= xfs_icreate_item_format,
-	.iop_push	= xfs_icreate_item_push,
 	.iop_unlock	= xfs_icreate_item_unlock,
 	.iop_committed	= xfs_icreate_item_committed,
 };
-- 
2.20.1
