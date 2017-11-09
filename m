Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:43908 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754436AbdKIN1J (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Nov 2017 08:27:09 -0500
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/6] xfs: add some comments to xfs_iext_insert/xfs_iext_insert_node
Date: Thu,  9 Nov 2017 14:26:52 +0100
Message-Id: <20171109132656.1649-3-hch@lst.de>
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
 fs/xfs/libxfs/xfs_iext_tree.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_iext_tree.c b/fs/xfs/libxfs/xfs_iext_tree.c
index 85d7f708eafc..c28a24aca9c5 100644
--- a/fs/xfs/libxfs/xfs_iext_tree.c
+++ b/fs/xfs/libxfs/xfs_iext_tree.c
@@ -525,6 +525,10 @@ xfs_iext_insert_node(
 	if (nr_entries == KEYS_PER_NODE)
 		new = xfs_iext_split_node(&node, &pos, &nr_entries);
 
+	/*
+	 * Update the pointers in higher levels if the first entry changes
+	 * in an existing node.
+	 */
 	if (node != new && pos == 0 && nr_entries > 0)
 		xfs_iext_update_node(ifp, node->keys[0], offset, level, node);
 
@@ -643,6 +647,10 @@ xfs_iext_insert(
 	if (nr_entries == RECS_PER_LEAF)
 		new = xfs_iext_split_leaf(cur, &nr_entries);
 
+	/*
+	 * Update the pointers in higher levels if the first entry changes
+	 * in an existing node.
+	 */
 	if (cur->leaf != new && cur->pos == 0 && nr_entries > 0) {
 		xfs_iext_update_node(ifp, xfs_iext_leaf_key(cur->leaf, 0),
 				offset, 1, cur->leaf);
-- 
2.14.2

