Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id AAAA67F5D
	for <xfs@oss.sgi.com>; Mon, 30 Mar 2015 10:12:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9A57C8F8049
	for <xfs@oss.sgi.com>; Mon, 30 Mar 2015 08:12:51 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 6NH4VTkqUD4nB6KR (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 30 Mar 2015 08:12:47 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (Postfix) with ESMTPS id EB727AC7BD
	for <xfs@oss.sgi.com>; Mon, 30 Mar 2015 15:12:46 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-237.bos.redhat.com [10.18.41.237])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t2UFCkaw023778
	for <xfs@oss.sgi.com>; Mon, 30 Mar 2015 11:12:46 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 1/3] xfs: pass attr geometry to attr leaf header conversion
	functions
Date: Mon, 30 Mar 2015 11:12:43 -0400
Message-Id: <1427728365-15842-2-git-send-email-bfoster@redhat.com>
In-Reply-To: <1427728365-15842-1-git-send-email-bfoster@redhat.com>
References: <1427728365-15842-1-git-send-email-bfoster@redhat.com>
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

The firstused field of the xfs_attr3_leaf_hdr structure is subject to an
overflow when fs blocksize is 64k. In preparation to handle this
overflow in the header conversion functions, pass the attribute geometry
to the functions that convert the in-core structure to and from the
on-disk structure.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_attr_leaf.c | 63 +++++++++++++++++++++++--------------------
 fs/xfs/libxfs/xfs_attr_leaf.h |  6 +++--
 fs/xfs/xfs_attr_inactive.c    |  3 ++-
 fs/xfs/xfs_attr_list.c        |  9 ++++---
 4 files changed, 46 insertions(+), 35 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 15105db..3337516 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -88,6 +88,7 @@ STATIC int xfs_attr_leaf_entsize(xfs_attr_leafblock_t *leaf, int index);
 
 void
 xfs_attr3_leaf_hdr_from_disk(
+	struct xfs_da_geometry		*geo,
 	struct xfs_attr3_icleaf_hdr	*to,
 	struct xfs_attr_leafblock	*from)
 {
@@ -129,6 +130,7 @@ xfs_attr3_leaf_hdr_from_disk(
 
 void
 xfs_attr3_leaf_hdr_to_disk(
+	struct xfs_da_geometry		*geo,
 	struct xfs_attr_leafblock	*to,
 	struct xfs_attr3_icleaf_hdr	*from)
 {
@@ -178,7 +180,7 @@ xfs_attr3_leaf_verify(
 	struct xfs_attr_leafblock *leaf = bp->b_addr;
 	struct xfs_attr3_icleaf_hdr ichdr;
 
-	xfs_attr3_leaf_hdr_from_disk(&ichdr, leaf);
+	xfs_attr3_leaf_hdr_from_disk(mp->m_attr_geo, &ichdr, leaf);
 
 	if (xfs_sb_version_hascrc(&mp->m_sb)) {
 		struct xfs_da3_node_hdr *hdr3 = bp->b_addr;
@@ -757,9 +759,10 @@ xfs_attr_shortform_allfit(
 	struct xfs_attr3_icleaf_hdr leafhdr;
 	int			bytes;
 	int			i;
+	struct xfs_mount	*mp = bp->b_target->bt_mount;
 
 	leaf = bp->b_addr;
-	xfs_attr3_leaf_hdr_from_disk(&leafhdr, leaf);
+	xfs_attr3_leaf_hdr_from_disk(mp->m_attr_geo, &leafhdr, leaf);
 	entry = xfs_attr3_leaf_entryp(leaf);
 
 	bytes = sizeof(struct xfs_attr_sf_hdr);
@@ -812,7 +815,7 @@ xfs_attr3_leaf_to_shortform(
 	memcpy(tmpbuffer, bp->b_addr, args->geo->blksize);
 
 	leaf = (xfs_attr_leafblock_t *)tmpbuffer;
-	xfs_attr3_leaf_hdr_from_disk(&ichdr, leaf);
+	xfs_attr3_leaf_hdr_from_disk(args->geo, &ichdr, leaf);
 	entry = xfs_attr3_leaf_entryp(leaf);
 
 	/* XXX (dgc): buffer is about to be marked stale - why zero it? */
@@ -923,7 +926,7 @@ xfs_attr3_leaf_to_node(
 	btree = dp->d_ops->node_tree_p(node);
 
 	leaf = bp2->b_addr;
-	xfs_attr3_leaf_hdr_from_disk(&icleafhdr, leaf);
+	xfs_attr3_leaf_hdr_from_disk(args->geo, &icleafhdr, leaf);
 	entries = xfs_attr3_leaf_entryp(leaf);
 
 	/* both on-disk, don't endian-flip twice */
@@ -988,7 +991,7 @@ xfs_attr3_leaf_create(
 	}
 	ichdr.freemap[0].size = ichdr.firstused - ichdr.freemap[0].base;
 
-	xfs_attr3_leaf_hdr_to_disk(leaf, &ichdr);
+	xfs_attr3_leaf_hdr_to_disk(args->geo, leaf, &ichdr);
 	xfs_trans_log_buf(args->trans, bp, 0, args->geo->blksize - 1);
 
 	*bpp = bp;
@@ -1073,7 +1076,7 @@ xfs_attr3_leaf_add(
 	trace_xfs_attr_leaf_add(args);
 
 	leaf = bp->b_addr;
-	xfs_attr3_leaf_hdr_from_disk(&ichdr, leaf);
+	xfs_attr3_leaf_hdr_from_disk(args->geo, &ichdr, leaf);
 	ASSERT(args->index >= 0 && args->index <= ichdr.count);
 	entsize = xfs_attr_leaf_newentsize(args, NULL);
 
@@ -1126,7 +1129,7 @@ xfs_attr3_leaf_add(
 	tmp = xfs_attr3_leaf_add_work(bp, &ichdr, args, 0);
 
 out_log_hdr:
-	xfs_attr3_leaf_hdr_to_disk(leaf, &ichdr);
+	xfs_attr3_leaf_hdr_to_disk(args->geo, leaf, &ichdr);
 	xfs_trans_log_buf(args->trans, bp,
 		XFS_DA_LOGRANGE(leaf, &leaf->hdr,
 				xfs_attr3_leaf_hdr_size(leaf)));
@@ -1294,7 +1297,7 @@ xfs_attr3_leaf_compact(
 						ichdr_dst->freemap[0].base;
 
 	/* write the header back to initialise the underlying buffer */
-	xfs_attr3_leaf_hdr_to_disk(leaf_dst, ichdr_dst);
+	xfs_attr3_leaf_hdr_to_disk(args->geo, leaf_dst, ichdr_dst);
 
 	/*
 	 * Copy all entry's in the same (sorted) order,
@@ -1344,9 +1347,10 @@ xfs_attr_leaf_order(
 {
 	struct xfs_attr3_icleaf_hdr ichdr1;
 	struct xfs_attr3_icleaf_hdr ichdr2;
+	struct xfs_mount *mp = leaf1_bp->b_target->bt_mount;
 
-	xfs_attr3_leaf_hdr_from_disk(&ichdr1, leaf1_bp->b_addr);
-	xfs_attr3_leaf_hdr_from_disk(&ichdr2, leaf2_bp->b_addr);
+	xfs_attr3_leaf_hdr_from_disk(mp->m_attr_geo, &ichdr1, leaf1_bp->b_addr);
+	xfs_attr3_leaf_hdr_from_disk(mp->m_attr_geo, &ichdr2, leaf2_bp->b_addr);
 	return xfs_attr3_leaf_order(leaf1_bp, &ichdr1, leaf2_bp, &ichdr2);
 }
 
@@ -1388,8 +1392,8 @@ xfs_attr3_leaf_rebalance(
 	ASSERT(blk2->magic == XFS_ATTR_LEAF_MAGIC);
 	leaf1 = blk1->bp->b_addr;
 	leaf2 = blk2->bp->b_addr;
-	xfs_attr3_leaf_hdr_from_disk(&ichdr1, leaf1);
-	xfs_attr3_leaf_hdr_from_disk(&ichdr2, leaf2);
+	xfs_attr3_leaf_hdr_from_disk(state->args->geo, &ichdr1, leaf1);
+	xfs_attr3_leaf_hdr_from_disk(state->args->geo, &ichdr2, leaf2);
 	ASSERT(ichdr2.count == 0);
 	args = state->args;
 
@@ -1490,8 +1494,8 @@ xfs_attr3_leaf_rebalance(
 					ichdr1.count, count);
 	}
 
-	xfs_attr3_leaf_hdr_to_disk(leaf1, &ichdr1);
-	xfs_attr3_leaf_hdr_to_disk(leaf2, &ichdr2);
+	xfs_attr3_leaf_hdr_to_disk(state->args->geo, leaf1, &ichdr1);
+	xfs_attr3_leaf_hdr_to_disk(state->args->geo, leaf2, &ichdr2);
 	xfs_trans_log_buf(args->trans, blk1->bp, 0, args->geo->blksize - 1);
 	xfs_trans_log_buf(args->trans, blk2->bp, 0, args->geo->blksize - 1);
 
@@ -1684,7 +1688,7 @@ xfs_attr3_leaf_toosmall(
 	 */
 	blk = &state->path.blk[ state->path.active-1 ];
 	leaf = blk->bp->b_addr;
-	xfs_attr3_leaf_hdr_from_disk(&ichdr, leaf);
+	xfs_attr3_leaf_hdr_from_disk(state->args->geo, &ichdr, leaf);
 	bytes = xfs_attr3_leaf_hdr_size(leaf) +
 		ichdr.count * sizeof(xfs_attr_leaf_entry_t) +
 		ichdr.usedbytes;
@@ -1740,7 +1744,7 @@ xfs_attr3_leaf_toosmall(
 		if (error)
 			return error;
 
-		xfs_attr3_leaf_hdr_from_disk(&ichdr2, bp->b_addr);
+		xfs_attr3_leaf_hdr_from_disk(state->args->geo, &ichdr2, bp->b_addr);
 
 		bytes = state->args->geo->blksize -
 			(state->args->geo->blksize >> 2) -
@@ -1805,7 +1809,7 @@ xfs_attr3_leaf_remove(
 	trace_xfs_attr_leaf_remove(args);
 
 	leaf = bp->b_addr;
-	xfs_attr3_leaf_hdr_from_disk(&ichdr, leaf);
+	xfs_attr3_leaf_hdr_from_disk(args->geo, &ichdr, leaf);
 
 	ASSERT(ichdr.count > 0 && ichdr.count < args->geo->blksize / 8);
 	ASSERT(args->index >= 0 && args->index < ichdr.count);
@@ -1923,7 +1927,7 @@ xfs_attr3_leaf_remove(
 	} else {
 		ichdr.holes = 1;	/* mark as needing compaction */
 	}
-	xfs_attr3_leaf_hdr_to_disk(leaf, &ichdr);
+	xfs_attr3_leaf_hdr_to_disk(args->geo, leaf, &ichdr);
 	xfs_trans_log_buf(args->trans, bp,
 			  XFS_DA_LOGRANGE(leaf, &leaf->hdr,
 					  xfs_attr3_leaf_hdr_size(leaf)));
@@ -1957,8 +1961,8 @@ xfs_attr3_leaf_unbalance(
 
 	drop_leaf = drop_blk->bp->b_addr;
 	save_leaf = save_blk->bp->b_addr;
-	xfs_attr3_leaf_hdr_from_disk(&drophdr, drop_leaf);
-	xfs_attr3_leaf_hdr_from_disk(&savehdr, save_leaf);
+	xfs_attr3_leaf_hdr_from_disk(state->args->geo, &drophdr, drop_leaf);
+	xfs_attr3_leaf_hdr_from_disk(state->args->geo, &savehdr, save_leaf);
 	entry = xfs_attr3_leaf_entryp(drop_leaf);
 
 	/*
@@ -2012,7 +2016,7 @@ xfs_attr3_leaf_unbalance(
 		tmphdr.firstused = state->args->geo->blksize;
 
 		/* write the header to the temp buffer to initialise it */
-		xfs_attr3_leaf_hdr_to_disk(tmp_leaf, &tmphdr);
+		xfs_attr3_leaf_hdr_to_disk(state->args->geo, tmp_leaf, &tmphdr);
 
 		if (xfs_attr3_leaf_order(save_blk->bp, &savehdr,
 					 drop_blk->bp, &drophdr)) {
@@ -2039,7 +2043,7 @@ xfs_attr3_leaf_unbalance(
 		kmem_free(tmp_leaf);
 	}
 
-	xfs_attr3_leaf_hdr_to_disk(save_leaf, &savehdr);
+	xfs_attr3_leaf_hdr_to_disk(state->args->geo, save_leaf, &savehdr);
 	xfs_trans_log_buf(state->args->trans, save_blk->bp, 0,
 					   state->args->geo->blksize - 1);
 
@@ -2085,7 +2089,7 @@ xfs_attr3_leaf_lookup_int(
 	trace_xfs_attr_leaf_lookup(args);
 
 	leaf = bp->b_addr;
-	xfs_attr3_leaf_hdr_from_disk(&ichdr, leaf);
+	xfs_attr3_leaf_hdr_from_disk(args->geo, &ichdr, leaf);
 	entries = xfs_attr3_leaf_entryp(leaf);
 	ASSERT(ichdr.count < args->geo->blksize / 8);
 
@@ -2190,7 +2194,7 @@ xfs_attr3_leaf_getvalue(
 	int			valuelen;
 
 	leaf = bp->b_addr;
-	xfs_attr3_leaf_hdr_from_disk(&ichdr, leaf);
+	xfs_attr3_leaf_hdr_from_disk(args->geo, &ichdr, leaf);
 	ASSERT(ichdr.count < args->geo->blksize / 8);
 	ASSERT(args->index < ichdr.count);
 
@@ -2391,8 +2395,9 @@ xfs_attr_leaf_lasthash(
 {
 	struct xfs_attr3_icleaf_hdr ichdr;
 	struct xfs_attr_leaf_entry *entries;
+	struct xfs_mount *mp = bp->b_target->bt_mount;
 
-	xfs_attr3_leaf_hdr_from_disk(&ichdr, bp->b_addr);
+	xfs_attr3_leaf_hdr_from_disk(mp->m_attr_geo, &ichdr, bp->b_addr);
 	entries = xfs_attr3_leaf_entryp(bp->b_addr);
 	if (count)
 		*count = ichdr.count;
@@ -2486,7 +2491,7 @@ xfs_attr3_leaf_clearflag(
 	ASSERT(entry->flags & XFS_ATTR_INCOMPLETE);
 
 #ifdef DEBUG
-	xfs_attr3_leaf_hdr_from_disk(&ichdr, leaf);
+	xfs_attr3_leaf_hdr_from_disk(args->geo, &ichdr, leaf);
 	ASSERT(args->index < ichdr.count);
 	ASSERT(args->index >= 0);
 
@@ -2550,7 +2555,7 @@ xfs_attr3_leaf_setflag(
 
 	leaf = bp->b_addr;
 #ifdef DEBUG
-	xfs_attr3_leaf_hdr_from_disk(&ichdr, leaf);
+	xfs_attr3_leaf_hdr_from_disk(args->geo, &ichdr, leaf);
 	ASSERT(args->index < ichdr.count);
 	ASSERT(args->index >= 0);
 #endif
@@ -2629,11 +2634,11 @@ xfs_attr3_leaf_flipflags(
 	entry2 = &xfs_attr3_leaf_entryp(leaf2)[args->index2];
 
 #ifdef DEBUG
-	xfs_attr3_leaf_hdr_from_disk(&ichdr1, leaf1);
+	xfs_attr3_leaf_hdr_from_disk(args->geo, &ichdr1, leaf1);
 	ASSERT(args->index < ichdr1.count);
 	ASSERT(args->index >= 0);
 
-	xfs_attr3_leaf_hdr_from_disk(&ichdr2, leaf2);
+	xfs_attr3_leaf_hdr_from_disk(args->geo, &ichdr2, leaf2);
 	ASSERT(args->index2 < ichdr2.count);
 	ASSERT(args->index2 >= 0);
 
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.h b/fs/xfs/libxfs/xfs_attr_leaf.h
index e2929da..025c4b8 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.h
+++ b/fs/xfs/libxfs/xfs_attr_leaf.h
@@ -100,9 +100,11 @@ int	xfs_attr_leaf_newentsize(struct xfs_da_args *args, int *local);
 int	xfs_attr3_leaf_read(struct xfs_trans *tp, struct xfs_inode *dp,
 			xfs_dablk_t bno, xfs_daddr_t mappedbno,
 			struct xfs_buf **bpp);
-void	xfs_attr3_leaf_hdr_from_disk(struct xfs_attr3_icleaf_hdr *to,
+void	xfs_attr3_leaf_hdr_from_disk(struct xfs_da_geometry *geo,
+				     struct xfs_attr3_icleaf_hdr *to,
 				     struct xfs_attr_leafblock *from);
-void	xfs_attr3_leaf_hdr_to_disk(struct xfs_attr_leafblock *to,
+void	xfs_attr3_leaf_hdr_to_disk(struct xfs_da_geometry *geo,
+				   struct xfs_attr_leafblock *to,
 				   struct xfs_attr3_icleaf_hdr *from);
 
 #endif	/* __XFS_ATTR_LEAF_H__ */
diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
index 83af4c1..f9c1c64 100644
--- a/fs/xfs/xfs_attr_inactive.c
+++ b/fs/xfs/xfs_attr_inactive.c
@@ -132,9 +132,10 @@ xfs_attr3_leaf_inactive(
 	int			size;
 	int			tmp;
 	int			i;
+	struct xfs_mount	*mp = bp->b_target->bt_mount;
 
 	leaf = bp->b_addr;
-	xfs_attr3_leaf_hdr_from_disk(&ichdr, leaf);
+	xfs_attr3_leaf_hdr_from_disk(mp->m_attr_geo, &ichdr, leaf);
 
 	/*
 	 * Count the number of "remote" value extents.
diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
index a43d370..65fb37a 100644
--- a/fs/xfs/xfs_attr_list.c
+++ b/fs/xfs/xfs_attr_list.c
@@ -225,6 +225,7 @@ xfs_attr_node_list(xfs_attr_list_context_t *context)
 	int error, i;
 	struct xfs_buf *bp;
 	struct xfs_inode	*dp = context->dp;
+	struct xfs_mount	*mp = dp->i_mount;
 
 	trace_xfs_attr_node_list(context);
 
@@ -256,7 +257,8 @@ xfs_attr_node_list(xfs_attr_list_context_t *context)
 			case XFS_ATTR_LEAF_MAGIC:
 			case XFS_ATTR3_LEAF_MAGIC:
 				leaf = bp->b_addr;
-				xfs_attr3_leaf_hdr_from_disk(&leafhdr, leaf);
+				xfs_attr3_leaf_hdr_from_disk(mp->m_attr_geo,
+							     &leafhdr, leaf);
 				entries = xfs_attr3_leaf_entryp(leaf);
 				if (cursor->hashval > be32_to_cpu(
 						entries[leafhdr.count - 1].hashval)) {
@@ -340,7 +342,7 @@ xfs_attr_node_list(xfs_attr_list_context_t *context)
 			xfs_trans_brelse(NULL, bp);
 			return error;
 		}
-		xfs_attr3_leaf_hdr_from_disk(&leafhdr, leaf);
+		xfs_attr3_leaf_hdr_from_disk(mp->m_attr_geo, &leafhdr, leaf);
 		if (context->seen_enough || leafhdr.forw == 0)
 			break;
 		cursor->blkno = leafhdr.forw;
@@ -368,11 +370,12 @@ xfs_attr3_leaf_list_int(
 	struct xfs_attr_leaf_entry	*entry;
 	int				retval;
 	int				i;
+	struct xfs_mount		*mp = context->dp->i_mount;
 
 	trace_xfs_attr_list_leaf(context);
 
 	leaf = bp->b_addr;
-	xfs_attr3_leaf_hdr_from_disk(&ichdr, leaf);
+	xfs_attr3_leaf_hdr_from_disk(mp->m_attr_geo, &ichdr, leaf);
 	entries = xfs_attr3_leaf_entryp(leaf);
 
 	cursor = context->cursor;
-- 
1.9.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
