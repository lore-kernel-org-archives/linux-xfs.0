Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:54859 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754690AbdKIN1R (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Nov 2017 08:27:17 -0500
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5/6] xfs: add comments documenting the rebalance algorithm
Date: Thu,  9 Nov 2017 14:26:55 +0100
Message-Id: <20171109132656.1649-6-hch@lst.de>
In-Reply-To: <20171109132656.1649-1-hch@lst.de>
References: <20171109132656.1649-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: bfoster@redhat.com

Reported-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_iext_tree.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_iext_tree.c b/fs/xfs/libxfs/xfs_iext_tree.c
index 3974989b0929..81e0480822d8 100644
--- a/fs/xfs/libxfs/xfs_iext_tree.c
+++ b/fs/xfs/libxfs/xfs_iext_tree.c
@@ -672,6 +672,11 @@ xfs_iext_rebalance_node(
 	struct xfs_iext_node	*node,
 	int			nr_entries)
 {
+	/*
+	 * If the neighbouring nodes are completely full, or have different
+	 * parents, we might never be able to merge our node, and will only
+	 * delete it once the number of entries hits zero.
+	 */
 	if (nr_entries == 0)
 		return node;
 
@@ -693,6 +698,11 @@ xfs_iext_rebalance_node(
 		int nr_next = xfs_iext_node_nr_entries(next, 0), i;
 
 		if (nr_entries + nr_next <= KEYS_PER_NODE) {
+			/*
+			 * Merge the next node into this node so that we don't
+			 * have to do an additional update of the keys in the
+			 * higher levels.
+			 */
 			for (i = 0; i < nr_next; i++) {
 				node->keys[nr_entries + i] = next->keys[i];
 				node->ptrs[nr_entries + i] = next->ptrs[i];
@@ -741,6 +751,11 @@ xfs_iext_remove_node(
 		return;
 
 	if (level < ifp->if_height) {
+		/*
+		 * If we aren't at the root yet try to find a neighbour node to
+		 * merge with (or delete the node if it is empty), and then
+		 * recurse up to the next level.
+		 */
 		level++;
 		parent = xfs_iext_find_level(ifp, offset, level);
 		pos = xfs_iext_node_pos(parent, offset);
@@ -755,6 +770,10 @@ xfs_iext_remove_node(
 			goto again;
 		}
 	} else if (nr_entries == 1) {
+		/*
+		 * If we are at the root and only one entry is left we can just
+		 * free this node and update the root pointer.
+		 */
 		ASSERT(node == ifp->if_u1.if_root);
 		ifp->if_u1.if_root = node->ptrs[0];
 		ifp->if_height--;
@@ -789,6 +808,11 @@ xfs_iext_rebalance_leaf(
 		int nr_next = xfs_iext_leaf_nr_entries(ifp, leaf->next, 0), i;
 
 		if (fill + nr_next <= RECS_PER_LEAF) {
+			/*
+			 * Merge the next node into this node so that we don't
+			 * have to do an additional update of the keys in the
+			 * higher levels.
+			 */
 			for (i = 0; i < nr_next; i++)
 				leaf->recs[fill + i] = leaf->next->recs[i];
 
-- 
2.14.2

