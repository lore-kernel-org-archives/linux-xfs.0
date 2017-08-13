Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:52016 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751011AbdHMOmZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 13 Aug 2017 10:42:25 -0400
Received: from clnet-p099-196.ikbnet.co.at ([83.175.99.196] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1dgu5x-0003XK-2A
        for linux-xfs@vger.kernel.org; Sun, 13 Aug 2017 14:42:25 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/3] xfs: rename xfs_defer_join to xfs_defer_join_inode
Date: Sun, 13 Aug 2017 16:42:15 +0200
Message-Id: <20170813144216.11192-3-hch@lst.de>
In-Reply-To: <20170813144216.11192-1-hch@lst.de>
References: <20170813144216.11192-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_bmap.c  | 2 +-
 fs/xfs/libxfs/xfs_defer.c | 4 ++--
 fs/xfs/libxfs/xfs_defer.h | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index c09c16b1ad3b..24eba36ef818 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -6452,7 +6452,7 @@ __xfs_bmap_add(
 	bi->bi_whichfork = whichfork;
 	bi->bi_bmap = *bmap;
 
-	error = xfs_defer_join(dfops, bi->bi_owner);
+	error = xfs_defer_join_inode(dfops, bi->bi_owner);
 	if (error) {
 		kmem_free(bi);
 		return error;
diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index 87169bf56a09..043844f00f6e 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -281,7 +281,7 @@ xfs_defer_has_unfinished_work(
  * to xfs_defer_finish().
  */
 int
-xfs_defer_join(
+xfs_defer_join_inode(
 	struct xfs_defer_ops		*dop,
 	struct xfs_inode		*ip)
 {
@@ -324,7 +324,7 @@ xfs_defer_finish(
 
 	trace_xfs_defer_finish((*tp)->t_mountp, dop);
 
-	xfs_defer_join(dop, ip);
+	xfs_defer_join_inode(dop, ip);
 
 	/* Until we run out of pending work to finish... */
 	while (xfs_defer_has_unfinished_work(dop)) {
diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
index f6e93ef0bffe..4632c798ea2b 100644
--- a/fs/xfs/libxfs/xfs_defer.h
+++ b/fs/xfs/libxfs/xfs_defer.h
@@ -77,7 +77,7 @@ int xfs_defer_finish(struct xfs_trans **tp, struct xfs_defer_ops *dop,
 void xfs_defer_cancel(struct xfs_defer_ops *dop);
 void xfs_defer_init(struct xfs_defer_ops *dop, xfs_fsblock_t *fbp);
 bool xfs_defer_has_unfinished_work(struct xfs_defer_ops *dop);
-int xfs_defer_join(struct xfs_defer_ops *dop, struct xfs_inode *ip);
+int xfs_defer_join_inode(struct xfs_defer_ops *dop, struct xfs_inode *ip);
 
 /* Description of a deferred type. */
 struct xfs_defer_op_type {
-- 
2.11.0

