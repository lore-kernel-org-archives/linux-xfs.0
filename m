Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:54616 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752082AbdIQVHS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 17 Sep 2017 17:07:18 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 11/47] xfs: check _btree_check_block value
Date: Sun, 17 Sep 2017 14:06:36 -0700
Message-Id: <20170917210712.10804-12-hch@lst.de>
In-Reply-To: <20170917210712.10804-1-hch@lst.de>
References: <20170917210712.10804-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit 1e86eabe73b73c82e1110c746ed3ec6d5e1c0a0d upstream.

Check the _btree_check_block return value for the firstrec and lastrec
functions, since we have the ability to signal that the repositioning
did not succeed.

Fixes-coverity-id: 114067
Fixes-coverity-id: 114068
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_btree.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 91c68913d495..e9f26a09a0be 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -714,7 +714,8 @@ xfs_btree_firstrec(
 	 * Get the block pointer for this level.
 	 */
 	block = xfs_btree_get_block(cur, level, &bp);
-	xfs_btree_check_block(cur, block, level, bp);
+	if (xfs_btree_check_block(cur, block, level, bp))
+		return 0;
 	/*
 	 * It's empty, there is no such record.
 	 */
@@ -743,7 +744,8 @@ xfs_btree_lastrec(
 	 * Get the block pointer for this level.
 	 */
 	block = xfs_btree_get_block(cur, level, &bp);
-	xfs_btree_check_block(cur, block, level, bp);
+	if (xfs_btree_check_block(cur, block, level, bp))
+		return 0;
 	/*
 	 * It's empty, there is no such record.
 	 */
-- 
2.14.1

