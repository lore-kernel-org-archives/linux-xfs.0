Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:60700 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751367AbdA2Sov (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 29 Jan 2017 13:44:51 -0500
Received: from clnet-p099-196.ikbnet.co.at ([83.175.99.196] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1cXuS2-00019g-Up
        for linux-xfs@vger.kernel.org; Sun, 29 Jan 2017 18:43:47 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/4] xfs: don't fail xfs_extent_busy allocation
Date: Sun, 29 Jan 2017 19:43:38 +0100
Message-Id: <1485715421-17182-2-git-send-email-hch@lst.de>
In-Reply-To: <1485715421-17182-1-git-send-email-hch@lst.de>
References: <1485715421-17182-1-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

We don't just need the structure to track busy extents which can be
avoided with a synchronous transaction, but also to keep track of
pending discard.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_extent_busy.c | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/fs/xfs/xfs_extent_busy.c b/fs/xfs/xfs_extent_busy.c
index 162dc18..29c2f99 100644
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
2.1.4

