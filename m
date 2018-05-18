Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:49980 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752274AbeERQtX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 18 May 2018 12:49:23 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 17/34] xfs: use iomap_bmap
Date: Fri, 18 May 2018 18:48:13 +0200
Message-Id: <20180518164830.1552-18-hch@lst.de>
In-Reply-To: <20180518164830.1552-1-hch@lst.de>
References: <20180518164830.1552-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, linux-mm@kvack.org

Switch to the iomap based bmap implementation to get rid of one of the
last users of xfs_get_blocks.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_aops.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 80de476cecf8..56e405572909 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -1378,10 +1378,9 @@ xfs_vm_bmap(
 	struct address_space	*mapping,
 	sector_t		block)
 {
-	struct inode		*inode = (struct inode *)mapping->host;
-	struct xfs_inode	*ip = XFS_I(inode);
+	struct xfs_inode	*ip = XFS_I(mapping->host);
 
-	trace_xfs_vm_bmap(XFS_I(inode));
+	trace_xfs_vm_bmap(ip);
 
 	/*
 	 * The swap code (ab-)uses ->bmap to get a block mapping and then
@@ -1394,9 +1393,7 @@ xfs_vm_bmap(
 	 */
 	if (xfs_is_reflink_inode(ip) || XFS_IS_REALTIME_INODE(ip))
 		return 0;
-
-	filemap_write_and_wait(mapping);
-	return generic_block_bmap(mapping, block, xfs_get_blocks);
+	return iomap_bmap(mapping, block, &xfs_iomap_ops);
 }
 
 STATIC int
-- 
2.17.0

