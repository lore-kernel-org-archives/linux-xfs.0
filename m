Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8B1848017
	for <xfs@oss.sgi.com>; Wed, 12 Jun 2013 05:37:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 09017AC005
	for <xfs@oss.sgi.com>; Wed, 12 Jun 2013 03:37:08 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	F9yFTFzObyMjE9XW for <xfs@oss.sgi.com>;
	Wed, 12 Jun 2013 03:37:06 -0700 (PDT)
Received: from [192.168.1.1] (helo=disappointment)
	by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UmiQD-0001Bn-PE
	for xfs@oss.sgi.com; Wed, 12 Jun 2013 20:36:57 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UmiQ3-0006nf-Mt
	for xfs@oss.sgi.com; Wed, 12 Jun 2013 20:36:47 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 16/22] libxfs: sync xfs_da_btree.c
Date: Wed, 12 Jun 2013 20:36:28 +1000
Message-Id: <1371033394-26006-17-git-send-email-david@fromorbit.com>
In-Reply-To: <1371033394-26006-1-git-send-email-david@fromorbit.com>
References: <1371033394-26006-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

Some variables we renamed in the kernel code, and there are a few
other minor differences. Fix them up.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 libxfs/xfs_da_btree.c |   63 ++++++++++++++++++++++++++-----------------------
 1 file changed, 33 insertions(+), 30 deletions(-)

diff --git a/libxfs/xfs_da_btree.c b/libxfs/xfs_da_btree.c
index e83a3ad..d7798af 100644
--- a/libxfs/xfs_da_btree.c
+++ b/libxfs/xfs_da_btree.c
@@ -480,8 +480,10 @@ xfs_da3_split(
 	 * There might be three blocks involved if a double split occurred,
 	 * and the original block 0 could be at any position in the list.
 	 *
-	 * Note: the info structures being modified here for both v2 and v3 da
-	 * headers, so we can do this linkage just using the v2 structures.
+	 * Note: the magic numbers and sibling pointers are in the same
+	 * physical place for both v2 and v3 headers (by design). Hence it
+	 * doesn't matter which version of the xfs_da_intnode structure we use
+	 * here as the result will be the same using either structure.
 	 */
 	node = oldblk->bp->b_addr;
 	if (node->hdr.info.forw) {
@@ -820,7 +822,7 @@ xfs_da3_node_rebalance(
 		 */
 		nodehdr2.count += count;
 		tmp = count * (uint)sizeof(xfs_da_node_entry_t);
-		btree_s = &btree1[nodehdr1.count- count];
+		btree_s = &btree1[nodehdr1.count - count];
 		btree_d = &btree2[0];
 		memcpy(btree_d, btree_s, tmp);
 		nodehdr1.count -= count;
@@ -1380,10 +1382,10 @@ xfs_da3_node_unbalance(
 {
 	struct xfs_da_intnode	*drop_node;
 	struct xfs_da_intnode	*save_node;
-	struct xfs_da_node_entry *dbtree;
-	struct xfs_da_node_entry *sbtree;
-	struct xfs_da3_icnode_hdr dhdr;
-	struct xfs_da3_icnode_hdr shdr;
+	struct xfs_da_node_entry *drop_btree;
+	struct xfs_da_node_entry *save_btree;
+	struct xfs_da3_icnode_hdr drop_hdr;
+	struct xfs_da3_icnode_hdr save_hdr;
 	struct xfs_trans	*tp;
 	int			sindex;
 	int			tmp;
@@ -1392,43 +1394,44 @@ xfs_da3_node_unbalance(
 
 	drop_node = drop_blk->bp->b_addr;
 	save_node = save_blk->bp->b_addr;
-	xfs_da3_node_hdr_from_disk(&dhdr, drop_node);
-	xfs_da3_node_hdr_from_disk(&shdr, save_node);
-	dbtree = xfs_da3_node_tree_p(drop_node);
-	sbtree = xfs_da3_node_tree_p(save_node);
+	xfs_da3_node_hdr_from_disk(&drop_hdr, drop_node);
+	xfs_da3_node_hdr_from_disk(&save_hdr, save_node);
+	drop_btree = xfs_da3_node_tree_p(drop_node);
+	save_btree = xfs_da3_node_tree_p(save_node);
 	tp = state->args->trans;
 
 	/*
 	 * If the dying block has lower hashvals, then move all the
 	 * elements in the remaining block up to make a hole.
 	 */
-	if ((be32_to_cpu(dbtree[0].hashval) < be32_to_cpu(sbtree[ 0 ].hashval)) ||
-	    (be32_to_cpu(dbtree[dhdr.count - 1].hashval) <
-				be32_to_cpu(sbtree[shdr.count - 1].hashval))) {
+	if ((be32_to_cpu(drop_btree[0].hashval) <
+			be32_to_cpu(save_btree[0].hashval)) ||
+	    (be32_to_cpu(drop_btree[drop_hdr.count - 1].hashval) <
+			be32_to_cpu(save_btree[save_hdr.count - 1].hashval))) {
 		/* XXX: check this - is memmove dst correct? */
-		tmp = shdr.count * (uint)sizeof(xfs_da_node_entry_t);
-		memmove(&sbtree[dhdr.count], &sbtree[0], tmp);
+		tmp = save_hdr.count * sizeof(xfs_da_node_entry_t);
+		memmove(&save_btree[drop_hdr.count], &save_btree[0], tmp);
 
 		sindex = 0;
 		xfs_trans_log_buf(tp, save_blk->bp,
-			XFS_DA_LOGRANGE(save_node, &sbtree[0],
-				(shdr.count + dhdr.count) *
+			XFS_DA_LOGRANGE(save_node, &save_btree[0],
+				(save_hdr.count + drop_hdr.count) *
 						sizeof(xfs_da_node_entry_t)));
 	} else {
-		sindex = shdr.count;
+		sindex = save_hdr.count;
 		xfs_trans_log_buf(tp, save_blk->bp,
-			XFS_DA_LOGRANGE(save_node, &sbtree[sindex],
-				dhdr.count * sizeof(xfs_da_node_entry_t)));
+			XFS_DA_LOGRANGE(save_node, &save_btree[sindex],
+				drop_hdr.count * sizeof(xfs_da_node_entry_t)));
 	}
 
 	/*
 	 * Move all the B-tree elements from drop_blk to save_blk.
 	 */
-	tmp = dhdr.count * (uint)sizeof(xfs_da_node_entry_t);
-	memcpy(&sbtree[sindex], &dbtree[0], tmp);
-	shdr.count += dhdr.count;
+	tmp = drop_hdr.count * (uint)sizeof(xfs_da_node_entry_t);
+	memcpy(&save_btree[sindex], &drop_btree[0], tmp);
+	save_hdr.count += drop_hdr.count;
 
-	xfs_da3_node_hdr_to_disk(save_node, &shdr);
+	xfs_da3_node_hdr_to_disk(save_node, &save_hdr);
 	xfs_trans_log_buf(tp, save_blk->bp,
 		XFS_DA_LOGRANGE(save_node, &save_node->hdr,
 				xfs_da3_node_hdr_size(save_node)));
@@ -1436,7 +1439,7 @@ xfs_da3_node_unbalance(
 	/*
 	 * Save the last hashval in the remaining block for upward propagation.
 	 */
-	save_blk->hashval = be32_to_cpu(sbtree[shdr.count - 1].hashval);
+	save_blk->hashval = be32_to_cpu(save_btree[save_hdr.count - 1].hashval);
 }
 
 /*========================================================================
@@ -2201,8 +2204,6 @@ xfs_da3_swap_lastblock(
 	} else {
 		struct xfs_da3_icnode_hdr deadhdr;
 
-		ASSERT(dead_info->magic == cpu_to_be16(XFS_DA_NODE_MAGIC) ||
-		       dead_info->magic == cpu_to_be16(XFS_DA3_NODE_MAGIC));
 		dead_node = (xfs_da_intnode_t *)dead_info;
 		xfs_da3_node_hdr_from_disk(&deadhdr, dead_node);
 		btree = xfs_da3_node_tree_p(dead_node);
@@ -2441,7 +2442,8 @@ xfs_buf_map_from_irec(
 	ASSERT(nirecs >= 1);
 
 	if (nirecs > 1) {
-		map = kmem_zalloc(nirecs * sizeof(struct xfs_buf_map), KM_SLEEP);
+		map = kmem_zalloc(nirecs * sizeof(struct xfs_buf_map),
+				  KM_SLEEP | KM_NOFS);
 		if (!map)
 			return ENOMEM;
 		*mapp = map;
@@ -2497,7 +2499,8 @@ xfs_dabuf_map(
 		 * Optimize the one-block case.
 		 */
 		if (nfsb != 1)
-			irecs = kmem_zalloc(sizeof(irec) * nfsb, KM_SLEEP);
+			irecs = kmem_zalloc(sizeof(irec) * nfsb,
+					    KM_SLEEP | KM_NOFS);
 
 		nirecs = nfsb;
 		error = xfs_bmapi_read(dp, (xfs_fileoff_t)bno, nfsb, irecs,
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
