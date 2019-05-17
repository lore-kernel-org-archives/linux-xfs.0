Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:44054 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728334AbfEQHcT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 May 2019 03:32:19 -0400
Received: from 089144210233.atnat0019.highway.a1.net ([89.144.210.233] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hRXLm-0000jV-Cx
        for linux-xfs@vger.kernel.org; Fri, 17 May 2019 07:32:18 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 04/20] xfs: remove the dummy iop_push implementation for inode creation items
Date: Fri, 17 May 2019 09:31:03 +0200
Message-Id: <20190517073119.30178-5-hch@lst.de>
In-Reply-To: <20190517073119.30178-1-hch@lst.de>
References: <20190517073119.30178-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

This method should never be called, so don't waste code on it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
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
