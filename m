Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:32770 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754633AbdKIN1V (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Nov 2017 08:27:21 -0500
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 6/6] xfs: handle zero entries case in xfs_iext_rebalance_leaf
Date: Thu,  9 Nov 2017 14:26:56 +0100
Message-Id: <20171109132656.1649-7-hch@lst.de>
In-Reply-To: <20171109132656.1649-1-hch@lst.de>
References: <20171109132656.1649-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: bfoster@redhat.com

And also rename fill to nr_entries to match the rest of the code.

Reported-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_iext_tree.c | 24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_iext_tree.c b/fs/xfs/libxfs/xfs_iext_tree.c
index 81e0480822d8..343a94246f5b 100644
--- a/fs/xfs/libxfs/xfs_iext_tree.c
+++ b/fs/xfs/libxfs/xfs_iext_tree.c
@@ -787,13 +787,21 @@ xfs_iext_rebalance_leaf(
 	struct xfs_iext_cursor	*cur,
 	struct xfs_iext_leaf	*leaf,
 	xfs_fileoff_t		offset,
-	int			fill)
+	int			nr_entries)
 {
+	/*
+	 * If the neighbouring nodes are completely full we might never be able
+	 * to merge our node, and will only delete it once the number of
+	 * entries hits zero.
+	 */
+	if (nr_entries == 0)
+		goto remove_node;
+
 	if (leaf->prev) {
 		int nr_prev = xfs_iext_leaf_nr_entries(ifp, leaf->prev, 0), i;
 
-		if (nr_prev + fill <= RECS_PER_LEAF) {
-			for (i = 0; i < fill; i++)
+		if (nr_prev + nr_entries <= RECS_PER_LEAF) {
+			for (i = 0; i < nr_entries; i++)
 				leaf->prev->recs[nr_prev + i] = leaf->recs[i];
 
 			if (cur->leaf == leaf) {
@@ -807,18 +815,20 @@ xfs_iext_rebalance_leaf(
 	if (leaf->next) {
 		int nr_next = xfs_iext_leaf_nr_entries(ifp, leaf->next, 0), i;
 
-		if (fill + nr_next <= RECS_PER_LEAF) {
+		if (nr_entries + nr_next <= RECS_PER_LEAF) {
 			/*
 			 * Merge the next node into this node so that we don't
 			 * have to do an additional update of the keys in the
 			 * higher levels.
 			 */
-			for (i = 0; i < nr_next; i++)
-				leaf->recs[fill + i] = leaf->next->recs[i];
+			for (i = 0; i < nr_next; i++) {
+				leaf->recs[nr_entries + i] =
+					leaf->next->recs[i];
+			}
 
 			if (cur->leaf == leaf->next) {
 				cur->leaf = leaf;
-				cur->pos += fill;
+				cur->pos += nr_entries;
 			}
 
 			offset = xfs_iext_leaf_key(leaf->next, 0);
-- 
2.14.2

