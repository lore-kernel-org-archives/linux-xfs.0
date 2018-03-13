Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:37926 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932772AbeCMKtf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Mar 2018 06:49:35 -0400
Received: from 77.117.139.172.wireless.dyn.drei.com ([77.117.139.172] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1evhUs-0006EU-NY
        for linux-xfs@vger.kernel.org; Tue, 13 Mar 2018 10:49:35 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/8] xfs: remove misleading comment text on xfs_inode_item_unlock
Date: Tue, 13 Mar 2018 11:49:20 +0100
Message-Id: <20180313104927.12926-2-hch@lst.de>
In-Reply-To: <20180313104927.12926-1-hch@lst.de>
References: <20180313104927.12926-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_inode_item.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index d5037f060d6f..b83fa38f1c74 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -579,9 +579,6 @@ xfs_inode_item_push(
 
 /*
  * Unlock the inode associated with the inode log item.
- * Clear the fields of the inode and inode log item that
- * are specific to the current transaction.  If the
- * hold flags is set, do not unlock the inode.
  */
 STATIC void
 xfs_inode_item_unlock(
-- 
2.14.2

