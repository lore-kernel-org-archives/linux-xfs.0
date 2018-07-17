Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:38542 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730460AbeGQX7E (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Jul 2018 19:59:04 -0400
Received: from sjc00ib2.hgst.com ([199.255.44.5] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1ffZKC-0001Dt-Ew
        for linux-xfs@vger.kernel.org; Tue, 17 Jul 2018 23:24:08 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5/6] xfs: maintain a sequence count for inode fork manipulations
Date: Tue, 17 Jul 2018 16:24:04 -0700
Message-Id: <20180717232405.18511-6-hch@lst.de>
In-Reply-To: <20180717232405.18511-1-hch@lst.de>
References: <20180717232405.18511-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Add a simple 32-bit unsigned integer as the sequence count for
modifications to the extent list in the inode fork.  This will be
used to optimize away extent list lookups in the writeback code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_iext_tree.c  | 6 ++++++
 fs/xfs/libxfs/xfs_inode_fork.h | 1 +
 2 files changed, 7 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_iext_tree.c b/fs/xfs/libxfs/xfs_iext_tree.c
index b80c63faace2..8a7aea041ee1 100644
--- a/fs/xfs/libxfs/xfs_iext_tree.c
+++ b/fs/xfs/libxfs/xfs_iext_tree.c
@@ -624,6 +624,8 @@ xfs_iext_insert(
 	struct xfs_iext_leaf	*new = NULL;
 	int			nr_entries, i;
 
+	ifp->if_seq++;
+
 	if (ifp->if_height == 0)
 		xfs_iext_alloc_root(ifp, cur);
 	else if (ifp->if_height == 1)
@@ -864,6 +866,8 @@ xfs_iext_remove(
 	ASSERT(ifp->if_u1.if_root != NULL);
 	ASSERT(xfs_iext_valid(ifp, cur));
 
+	ifp->if_seq++;
+
 	nr_entries = xfs_iext_leaf_nr_entries(ifp, leaf, cur->pos) - 1;
 	for (i = cur->pos; i < nr_entries; i++)
 		leaf->recs[i] = leaf->recs[i + 1];
@@ -970,6 +974,8 @@ xfs_iext_update_extent(
 {
 	struct xfs_ifork	*ifp = xfs_iext_state_to_fork(ip, state);
 
+	ifp->if_seq++;
+
 	if (cur->pos == 0) {
 		struct xfs_bmbt_irec	old;
 
diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index 1492143371f3..f20b2468ca35 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -14,6 +14,7 @@ struct xfs_dinode;
  */
 struct xfs_ifork {
 	int			if_bytes;	/* bytes in if_u1 */
+	unsigned int		if_seq;
 	struct xfs_btree_block	*if_broot;	/* file's incore btree root */
 	short			if_broot_bytes;	/* bytes allocated for root */
 	unsigned char		if_flags;	/* per-fork flags */
-- 
2.18.0

