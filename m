Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id ADAA87F7B
	for <xfs@oss.sgi.com>; Thu, 22 May 2014 19:08:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 94A3A8F8035
	for <xfs@oss.sgi.com>; Thu, 22 May 2014 17:08:08 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	AyMDe3VNhrJaMDKJ for <xfs@oss.sgi.com>;
	Thu, 22 May 2014 17:08:05 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1Wncxn-00072A-DE
	for xfs@oss.sgi.com; Fri, 23 May 2014 10:03:55 +1000
Received: from dave by disappointment with local (Exim 4.82)
	(envelope-from <dave@disappointment.disaster>) id 1Wncxn-0005UO-CB
	for xfs@oss.sgi.com; Fri, 23 May 2014 10:03:55 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 16/16] xfs: repalce attr LBSIZE with xfs_da_geometry
Date: Fri, 23 May 2014 10:03:52 +1000
Message-Id: <1400803432-20048-17-git-send-email-david@fromorbit.com>
In-Reply-To: <1400803432-20048-1-git-send-email-david@fromorbit.com>
References: <1400803432-20048-1-git-send-email-david@fromorbit.com>
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

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_attr.c        |   2 +-
 fs/xfs/xfs_attr_leaf.c   | 114 ++++++++++++++++++++++++-----------------------
 fs/xfs/xfs_attr_remote.c |  55 ++++++++++++-----------
 fs/xfs/xfs_da_format.h   |  10 -----
 4 files changed, 89 insertions(+), 92 deletions(-)

diff --git a/fs/xfs/xfs_attr.c b/fs/xfs/xfs_attr.c
index 3d8c03e..470a22d 100644
--- a/fs/xfs/xfs_attr.c
+++ b/fs/xfs/xfs_attr.c
@@ -863,7 +863,7 @@ xfs_attr_leaf_get(xfs_da_args_t *args)
 }
 
 /*========================================================================
- * External routines when attribute list size > XFS_LBSIZE(mp).
+ * External routines when attribute list size > geo->blksize
  *========================================================================*/
 
 /*
diff --git a/fs/xfs/xfs_attr_leaf.c b/fs/xfs/xfs_attr_leaf.c
index 7761103..ae33b14 100644
--- a/fs/xfs/xfs_attr_leaf.c
+++ b/fs/xfs/xfs_attr_leaf.c
@@ -80,11 +80,12 @@ STATIC int xfs_attr3_leaf_figure_balance(xfs_da_state_t *state,
 /*
  * Utility routines.
  */
-STATIC void xfs_attr3_leaf_moveents(struct xfs_attr_leafblock *src_leaf,
+STATIC void xfs_attr3_leaf_moveents(struct xfs_da_args *args,
+			struct xfs_attr_leafblock *src_leaf,
 			struct xfs_attr3_icleaf_hdr *src_ichdr, int src_start,
 			struct xfs_attr_leafblock *dst_leaf,
 			struct xfs_attr3_icleaf_hdr *dst_ichdr, int dst_start,
-			int move_count, struct xfs_mount *mp);
+			int move_count);
 STATIC int xfs_attr_leaf_entsize(xfs_attr_leafblock_t *leaf, int index);
 
 void
@@ -806,18 +807,18 @@ xfs_attr3_leaf_to_shortform(
 
 	trace_xfs_attr_leaf_to_sf(args);
 
-	tmpbuffer = kmem_alloc(XFS_LBSIZE(dp->i_mount), KM_SLEEP);
+	tmpbuffer = kmem_alloc(args->geo->blksize, KM_SLEEP);
 	if (!tmpbuffer)
 		return ENOMEM;
 
-	memcpy(tmpbuffer, bp->b_addr, XFS_LBSIZE(dp->i_mount));
+	memcpy(tmpbuffer, bp->b_addr, args->geo->blksize);
 
 	leaf = (xfs_attr_leafblock_t *)tmpbuffer;
 	xfs_attr3_leaf_hdr_from_disk(&ichdr, leaf);
 	entry = xfs_attr3_leaf_entryp(leaf);
 
 	/* XXX (dgc): buffer is about to be marked stale - why zero it? */
-	memset(bp->b_addr, 0, XFS_LBSIZE(dp->i_mount));
+	memset(bp->b_addr, 0, args->geo->blksize);
 
 	/*
 	 * Clean out the prior contents of the attribute list.
@@ -906,12 +907,12 @@ xfs_attr3_leaf_to_node(
 	/* copy leaf to new buffer, update identifiers */
 	xfs_trans_buf_set_type(args->trans, bp2, XFS_BLFT_ATTR_LEAF_BUF);
 	bp2->b_ops = bp1->b_ops;
-	memcpy(bp2->b_addr, bp1->b_addr, XFS_LBSIZE(mp));
+	memcpy(bp2->b_addr, bp1->b_addr, args->geo->blksize);
 	if (xfs_sb_version_hascrc(&mp->m_sb)) {
 		struct xfs_da3_blkinfo *hdr3 = bp2->b_addr;
 		hdr3->blkno = cpu_to_be64(bp2->b_bn);
 	}
-	xfs_trans_log_buf(args->trans, bp2, 0, XFS_LBSIZE(mp) - 1);
+	xfs_trans_log_buf(args->trans, bp2, 0, args->geo->blksize - 1);
 
 	/*
 	 * Set up the new root node.
@@ -932,7 +933,7 @@ xfs_attr3_leaf_to_node(
 	btree[0].before = cpu_to_be32(blkno);
 	icnodehdr.count = 1;
 	dp->d_ops->node_hdr_to_disk(node, &icnodehdr);
-	xfs_trans_log_buf(args->trans, bp1, 0, XFS_LBSIZE(mp) - 1);
+	xfs_trans_log_buf(args->trans, bp1, 0, args->geo->blksize - 1);
 	error = 0;
 out:
 	return error;
@@ -968,10 +969,10 @@ xfs_attr3_leaf_create(
 	bp->b_ops = &xfs_attr3_leaf_buf_ops;
 	xfs_trans_buf_set_type(args->trans, bp, XFS_BLFT_ATTR_LEAF_BUF);
 	leaf = bp->b_addr;
-	memset(leaf, 0, XFS_LBSIZE(mp));
+	memset(leaf, 0, args->geo->blksize);
 
 	memset(&ichdr, 0, sizeof(ichdr));
-	ichdr.firstused = XFS_LBSIZE(mp);
+	ichdr.firstused = args->geo->blksize;
 
 	if (xfs_sb_version_hascrc(&mp->m_sb)) {
 		struct xfs_da3_blkinfo *hdr3 = bp->b_addr;
@@ -990,7 +991,7 @@ xfs_attr3_leaf_create(
 	ichdr.freemap[0].size = ichdr.firstused - ichdr.freemap[0].base;
 
 	xfs_attr3_leaf_hdr_to_disk(leaf, &ichdr);
-	xfs_trans_log_buf(args->trans, bp, 0, XFS_LBSIZE(mp) - 1);
+	xfs_trans_log_buf(args->trans, bp, 0, args->geo->blksize - 1);
 
 	*bpp = bp;
 	return 0;
@@ -1175,11 +1176,11 @@ xfs_attr3_leaf_add_work(
 	 * Allocate space for the new string (at the end of the run).
 	 */
 	mp = args->trans->t_mountp;
-	ASSERT(ichdr->freemap[mapindex].base < XFS_LBSIZE(mp));
+	ASSERT(ichdr->freemap[mapindex].base < args->geo->blksize);
 	ASSERT((ichdr->freemap[mapindex].base & 0x3) == 0);
 	ASSERT(ichdr->freemap[mapindex].size >=
 		xfs_attr_leaf_newentsize(args, NULL));
-	ASSERT(ichdr->freemap[mapindex].size < XFS_LBSIZE(mp));
+	ASSERT(ichdr->freemap[mapindex].size < args->geo->blksize);
 	ASSERT((ichdr->freemap[mapindex].size & 0x3) == 0);
 
 	ichdr->freemap[mapindex].size -= xfs_attr_leaf_newentsize(args, &tmp);
@@ -1267,14 +1268,13 @@ xfs_attr3_leaf_compact(
 	struct xfs_attr_leafblock *leaf_dst;
 	struct xfs_attr3_icleaf_hdr ichdr_src;
 	struct xfs_trans	*trans = args->trans;
-	struct xfs_mount	*mp = trans->t_mountp;
 	char			*tmpbuffer;
 
 	trace_xfs_attr_leaf_compact(args);
 
-	tmpbuffer = kmem_alloc(XFS_LBSIZE(mp), KM_SLEEP);
-	memcpy(tmpbuffer, bp->b_addr, XFS_LBSIZE(mp));
-	memset(bp->b_addr, 0, XFS_LBSIZE(mp));
+	tmpbuffer = kmem_alloc(args->geo->blksize, KM_SLEEP);
+	memcpy(tmpbuffer, bp->b_addr, args->geo->blksize);
+	memset(bp->b_addr, 0, args->geo->blksize);
 	leaf_src = (xfs_attr_leafblock_t *)tmpbuffer;
 	leaf_dst = bp->b_addr;
 
@@ -1287,7 +1287,7 @@ xfs_attr3_leaf_compact(
 
 	/* Initialise the incore headers */
 	ichdr_src = *ichdr_dst;	/* struct copy */
-	ichdr_dst->firstused = XFS_LBSIZE(mp);
+	ichdr_dst->firstused = args->geo->blksize;
 	ichdr_dst->usedbytes = 0;
 	ichdr_dst->count = 0;
 	ichdr_dst->holes = 0;
@@ -1302,13 +1302,13 @@ xfs_attr3_leaf_compact(
 	 * Copy all entry's in the same (sorted) order,
 	 * but allocate name/value pairs packed and in sequence.
 	 */
-	xfs_attr3_leaf_moveents(leaf_src, &ichdr_src, 0, leaf_dst, ichdr_dst, 0,
-				ichdr_src.count, mp);
+	xfs_attr3_leaf_moveents(args, leaf_src, &ichdr_src, 0,
+				leaf_dst, ichdr_dst, 0, ichdr_src.count);
 	/*
 	 * this logs the entire buffer, but the caller must write the header
 	 * back to the buffer when it is finished modifying it.
 	 */
-	xfs_trans_log_buf(trans, bp, 0, XFS_LBSIZE(mp) - 1);
+	xfs_trans_log_buf(trans, bp, 0, args->geo->blksize - 1);
 
 	kmem_free(tmpbuffer);
 }
@@ -1459,8 +1459,8 @@ xfs_attr3_leaf_rebalance(
 		/*
 		 * Move high entries from leaf1 to low end of leaf2.
 		 */
-		xfs_attr3_leaf_moveents(leaf1, &ichdr1, ichdr1.count - count,
-				leaf2, &ichdr2, 0, count, state->mp);
+		xfs_attr3_leaf_moveents(args, leaf1, &ichdr1,
+				ichdr1.count - count, leaf2, &ichdr2, 0, count);
 
 	} else if (count > ichdr1.count) {
 		/*
@@ -1488,8 +1488,8 @@ xfs_attr3_leaf_rebalance(
 		/*
 		 * Move low entries from leaf2 to high end of leaf1.
 		 */
-		xfs_attr3_leaf_moveents(leaf2, &ichdr2, 0, leaf1, &ichdr1,
-					ichdr1.count, count, state->mp);
+		xfs_attr3_leaf_moveents(args, leaf2, &ichdr2, 0, leaf1, &ichdr1,
+					ichdr1.count, count);
 	}
 
 	xfs_attr3_leaf_hdr_to_disk(leaf1, &ichdr1);
@@ -1795,7 +1795,6 @@ xfs_attr3_leaf_remove(
 	struct xfs_attr_leafblock *leaf;
 	struct xfs_attr3_icleaf_hdr ichdr;
 	struct xfs_attr_leaf_entry *entry;
-	struct xfs_mount	*mp = args->trans->t_mountp;
 	int			before;
 	int			after;
 	int			smallest;
@@ -1809,7 +1808,7 @@ xfs_attr3_leaf_remove(
 	leaf = bp->b_addr;
 	xfs_attr3_leaf_hdr_from_disk(&ichdr, leaf);
 
-	ASSERT(ichdr.count > 0 && ichdr.count < XFS_LBSIZE(mp) / 8);
+	ASSERT(ichdr.count > 0 && ichdr.count < args->geo->blksize / 8);
 	ASSERT(args->index >= 0 && args->index < ichdr.count);
 	ASSERT(ichdr.firstused >= ichdr.count * sizeof(*entry) +
 					xfs_attr3_leaf_hdr_size(leaf));
@@ -1817,7 +1816,7 @@ xfs_attr3_leaf_remove(
 	entry = &xfs_attr3_leaf_entryp(leaf)[args->index];
 
 	ASSERT(be16_to_cpu(entry->nameidx) >= ichdr.firstused);
-	ASSERT(be16_to_cpu(entry->nameidx) < XFS_LBSIZE(mp));
+	ASSERT(be16_to_cpu(entry->nameidx) < args->geo->blksize);
 
 	/*
 	 * Scan through free region table:
@@ -1832,8 +1831,8 @@ xfs_attr3_leaf_remove(
 	smallest = XFS_ATTR_LEAF_MAPSIZE - 1;
 	entsize = xfs_attr_leaf_entsize(leaf, args->index);
 	for (i = 0; i < XFS_ATTR_LEAF_MAPSIZE; i++) {
-		ASSERT(ichdr.freemap[i].base < XFS_LBSIZE(mp));
-		ASSERT(ichdr.freemap[i].size < XFS_LBSIZE(mp));
+		ASSERT(ichdr.freemap[i].base < args->geo->blksize);
+		ASSERT(ichdr.freemap[i].size < args->geo->blksize);
 		if (ichdr.freemap[i].base == tablesize) {
 			ichdr.freemap[i].base -= sizeof(xfs_attr_leaf_entry_t);
 			ichdr.freemap[i].size += sizeof(xfs_attr_leaf_entry_t);
@@ -1910,11 +1909,11 @@ xfs_attr3_leaf_remove(
 	 * removing the name.
 	 */
 	if (smallest) {
-		tmp = XFS_LBSIZE(mp);
+		tmp = args->geo->blksize;
 		entry = xfs_attr3_leaf_entryp(leaf);
 		for (i = ichdr.count - 1; i >= 0; entry++, i--) {
 			ASSERT(be16_to_cpu(entry->nameidx) >= ichdr.firstused);
-			ASSERT(be16_to_cpu(entry->nameidx) < XFS_LBSIZE(mp));
+			ASSERT(be16_to_cpu(entry->nameidx) < args->geo->blksize);
 
 			if (be16_to_cpu(entry->nameidx) < tmp)
 				tmp = be16_to_cpu(entry->nameidx);
@@ -1954,7 +1953,6 @@ xfs_attr3_leaf_unbalance(
 	struct xfs_attr3_icleaf_hdr drophdr;
 	struct xfs_attr3_icleaf_hdr savehdr;
 	struct xfs_attr_leaf_entry *entry;
-	struct xfs_mount	*mp = state->mp;
 
 	trace_xfs_attr_leaf_unbalance(state->args);
 
@@ -1981,13 +1979,15 @@ xfs_attr3_leaf_unbalance(
 		 */
 		if (xfs_attr3_leaf_order(save_blk->bp, &savehdr,
 					 drop_blk->bp, &drophdr)) {
-			xfs_attr3_leaf_moveents(drop_leaf, &drophdr, 0,
+			xfs_attr3_leaf_moveents(state->args,
+						drop_leaf, &drophdr, 0,
 						save_leaf, &savehdr, 0,
-						drophdr.count, mp);
+						drophdr.count);
 		} else {
-			xfs_attr3_leaf_moveents(drop_leaf, &drophdr, 0,
+			xfs_attr3_leaf_moveents(state->args,
+						drop_leaf, &drophdr, 0,
 						save_leaf, &savehdr,
-						savehdr.count, drophdr.count, mp);
+						savehdr.count, drophdr.count);
 		}
 	} else {
 		/*
@@ -2017,19 +2017,23 @@ xfs_attr3_leaf_unbalance(
 
 		if (xfs_attr3_leaf_order(save_blk->bp, &savehdr,
 					 drop_blk->bp, &drophdr)) {
-			xfs_attr3_leaf_moveents(drop_leaf, &drophdr, 0,
+			xfs_attr3_leaf_moveents(state->args,
+						drop_leaf, &drophdr, 0,
 						tmp_leaf, &tmphdr, 0,
-						drophdr.count, mp);
-			xfs_attr3_leaf_moveents(save_leaf, &savehdr, 0,
+						drophdr.count);
+			xfs_attr3_leaf_moveents(state->args,
+						save_leaf, &savehdr, 0,
 						tmp_leaf, &tmphdr, tmphdr.count,
-						savehdr.count, mp);
+						savehdr.count);
 		} else {
-			xfs_attr3_leaf_moveents(save_leaf, &savehdr, 0,
+			xfs_attr3_leaf_moveents(state->args,
+						save_leaf, &savehdr, 0,
 						tmp_leaf, &tmphdr, 0,
-						savehdr.count, mp);
-			xfs_attr3_leaf_moveents(drop_leaf, &drophdr, 0,
+						savehdr.count);
+			xfs_attr3_leaf_moveents(state->args,
+						drop_leaf, &drophdr, 0,
 						tmp_leaf, &tmphdr, tmphdr.count,
-						drophdr.count, mp);
+						drophdr.count);
 		}
 		memcpy(save_leaf, tmp_leaf, state->blocksize);
 		savehdr = tmphdr; /* struct copy */
@@ -2084,7 +2088,7 @@ xfs_attr3_leaf_lookup_int(
 	leaf = bp->b_addr;
 	xfs_attr3_leaf_hdr_from_disk(&ichdr, leaf);
 	entries = xfs_attr3_leaf_entryp(leaf);
-	ASSERT(ichdr.count < XFS_LBSIZE(args->dp->i_mount) / 8);
+	ASSERT(ichdr.count < args->geo->blksize / 8);
 
 	/*
 	 * Binary search.  (note: small blocks will skip this loop)
@@ -2188,7 +2192,7 @@ xfs_attr3_leaf_getvalue(
 
 	leaf = bp->b_addr;
 	xfs_attr3_leaf_hdr_from_disk(&ichdr, leaf);
-	ASSERT(ichdr.count < XFS_LBSIZE(args->dp->i_mount) / 8);
+	ASSERT(ichdr.count < args->geo->blksize / 8);
 	ASSERT(args->index < ichdr.count);
 
 	entry = &xfs_attr3_leaf_entryp(leaf)[args->index];
@@ -2239,14 +2243,14 @@ xfs_attr3_leaf_getvalue(
 /*ARGSUSED*/
 STATIC void
 xfs_attr3_leaf_moveents(
+	struct xfs_da_args		*args,
 	struct xfs_attr_leafblock	*leaf_s,
 	struct xfs_attr3_icleaf_hdr	*ichdr_s,
 	int				start_s,
 	struct xfs_attr_leafblock	*leaf_d,
 	struct xfs_attr3_icleaf_hdr	*ichdr_d,
 	int				start_d,
-	int				count,
-	struct xfs_mount		*mp)
+	int				count)
 {
 	struct xfs_attr_leaf_entry	*entry_s;
 	struct xfs_attr_leaf_entry	*entry_d;
@@ -2266,10 +2270,10 @@ xfs_attr3_leaf_moveents(
 	ASSERT(ichdr_s->magic == XFS_ATTR_LEAF_MAGIC ||
 	       ichdr_s->magic == XFS_ATTR3_LEAF_MAGIC);
 	ASSERT(ichdr_s->magic == ichdr_d->magic);
-	ASSERT(ichdr_s->count > 0 && ichdr_s->count < XFS_LBSIZE(mp) / 8);
+	ASSERT(ichdr_s->count > 0 && ichdr_s->count < args->geo->blksize / 8);
 	ASSERT(ichdr_s->firstused >= (ichdr_s->count * sizeof(*entry_s))
 					+ xfs_attr3_leaf_hdr_size(leaf_s));
-	ASSERT(ichdr_d->count < XFS_LBSIZE(mp) / 8);
+	ASSERT(ichdr_d->count < args->geo->blksize / 8);
 	ASSERT(ichdr_d->firstused >= (ichdr_d->count * sizeof(*entry_d))
 					+ xfs_attr3_leaf_hdr_size(leaf_d));
 
@@ -2321,11 +2325,11 @@ xfs_attr3_leaf_moveents(
 			entry_d->nameidx = cpu_to_be16(ichdr_d->firstused);
 			entry_d->flags = entry_s->flags;
 			ASSERT(be16_to_cpu(entry_d->nameidx) + tmp
-							<= XFS_LBSIZE(mp));
+							<= args->geo->blksize);
 			memmove(xfs_attr3_leaf_name(leaf_d, desti),
 				xfs_attr3_leaf_name(leaf_s, start_s + i), tmp);
 			ASSERT(be16_to_cpu(entry_s->nameidx) + tmp
-							<= XFS_LBSIZE(mp));
+							<= args->geo->blksize);
 			memset(xfs_attr3_leaf_name(leaf_s, start_s + i), 0, tmp);
 			ichdr_s->usedbytes -= tmp;
 			ichdr_d->usedbytes += tmp;
@@ -2346,7 +2350,7 @@ xfs_attr3_leaf_moveents(
 		tmp = count * sizeof(xfs_attr_leaf_entry_t);
 		entry_s = &xfs_attr3_leaf_entryp(leaf_s)[start_s];
 		ASSERT(((char *)entry_s + tmp) <=
-		       ((char *)leaf_s + XFS_LBSIZE(mp)));
+		       ((char *)leaf_s + args->geo->blksize));
 		memset(entry_s, 0, tmp);
 	} else {
 		/*
@@ -2361,7 +2365,7 @@ xfs_attr3_leaf_moveents(
 		tmp = count * sizeof(xfs_attr_leaf_entry_t);
 		entry_s = &xfs_attr3_leaf_entryp(leaf_s)[ichdr_s->count];
 		ASSERT(((char *)entry_s + tmp) <=
-		       ((char *)leaf_s + XFS_LBSIZE(mp)));
+		       ((char *)leaf_s + args->geo->blksize));
 		memset(entry_s, 0, tmp);
 	}
 
diff --git a/fs/xfs/xfs_attr_remote.c b/fs/xfs/xfs_attr_remote.c
index 0f0679a..b5adfec 100644
--- a/fs/xfs/xfs_attr_remote.c
+++ b/fs/xfs/xfs_attr_remote.c
@@ -125,6 +125,7 @@ xfs_attr3_rmt_read_verify(
 	char		*ptr;
 	int		len;
 	xfs_daddr_t	bno;
+	int		blksize = mp->m_attr_geo->blksize;
 
 	/* no verification of non-crc buffers */
 	if (!xfs_sb_version_hascrc(&mp->m_sb))
@@ -133,21 +134,20 @@ xfs_attr3_rmt_read_verify(
 	ptr = bp->b_addr;
 	bno = bp->b_bn;
 	len = BBTOB(bp->b_length);
-	ASSERT(len >= XFS_LBSIZE(mp));
+	ASSERT(len >= blksize);
 
 	while (len > 0) {
-		if (!xfs_verify_cksum(ptr, XFS_LBSIZE(mp),
-				      XFS_ATTR3_RMT_CRC_OFF)) {
+		if (!xfs_verify_cksum(ptr, blksize, XFS_ATTR3_RMT_CRC_OFF)) {
 			xfs_buf_ioerror(bp, EFSBADCRC);
 			break;
 		}
-		if (!xfs_attr3_rmt_verify(mp, ptr, XFS_LBSIZE(mp), bno)) {
+		if (!xfs_attr3_rmt_verify(mp, ptr, blksize, bno)) {
 			xfs_buf_ioerror(bp, EFSCORRUPTED);
 			break;
 		}
-		len -= XFS_LBSIZE(mp);
-		ptr += XFS_LBSIZE(mp);
-		bno += mp->m_bsize;
+		len -= blksize;
+		ptr += blksize;
+		bno += BTOBB(blksize);
 	}
 
 	if (bp->b_error)
@@ -165,6 +165,7 @@ xfs_attr3_rmt_write_verify(
 	char		*ptr;
 	int		len;
 	xfs_daddr_t	bno;
+	int		blksize = mp->m_attr_geo->blksize;
 
 	/* no verification of non-crc buffers */
 	if (!xfs_sb_version_hascrc(&mp->m_sb))
@@ -173,10 +174,10 @@ xfs_attr3_rmt_write_verify(
 	ptr = bp->b_addr;
 	bno = bp->b_bn;
 	len = BBTOB(bp->b_length);
-	ASSERT(len >= XFS_LBSIZE(mp));
+	ASSERT(len >= blksize);
 
 	while (len > 0) {
-		if (!xfs_attr3_rmt_verify(mp, ptr, XFS_LBSIZE(mp), bno)) {
+		if (!xfs_attr3_rmt_verify(mp, ptr, blksize, bno)) {
 			xfs_buf_ioerror(bp, EFSCORRUPTED);
 			xfs_verifier_error(bp);
 			return;
@@ -187,11 +188,11 @@ xfs_attr3_rmt_write_verify(
 			rmt = (struct xfs_attr3_rmt_hdr *)ptr;
 			rmt->rm_lsn = cpu_to_be64(bip->bli_item.li_lsn);
 		}
-		xfs_update_cksum(ptr, XFS_LBSIZE(mp), XFS_ATTR3_RMT_CRC_OFF);
+		xfs_update_cksum(ptr, blksize, XFS_ATTR3_RMT_CRC_OFF);
 
-		len -= XFS_LBSIZE(mp);
-		ptr += XFS_LBSIZE(mp);
-		bno += mp->m_bsize;
+		len -= blksize;
+		ptr += blksize;
+		bno += BTOBB(blksize);
 	}
 	ASSERT(len == 0);
 }
@@ -240,12 +241,13 @@ xfs_attr_rmtval_copyout(
 	char		*src = bp->b_addr;
 	xfs_daddr_t	bno = bp->b_bn;
 	int		len = BBTOB(bp->b_length);
+	int		blksize = mp->m_attr_geo->blksize;
 
-	ASSERT(len >= XFS_LBSIZE(mp));
+	ASSERT(len >= blksize);
 
 	while (len > 0 && *valuelen > 0) {
 		int hdr_size = 0;
-		int byte_cnt = XFS_ATTR3_RMT_BUF_SPACE(mp, XFS_LBSIZE(mp));
+		int byte_cnt = XFS_ATTR3_RMT_BUF_SPACE(mp, blksize);
 
 		byte_cnt = min(*valuelen, byte_cnt);
 
@@ -263,9 +265,9 @@ xfs_attr_rmtval_copyout(
 		memcpy(*dst, src + hdr_size, byte_cnt);
 
 		/* roll buffer forwards */
-		len -= XFS_LBSIZE(mp);
-		src += XFS_LBSIZE(mp);
-		bno += mp->m_bsize;
+		len -= blksize;
+		src += blksize;
+		bno += BTOBB(blksize);
 
 		/* roll attribute data forwards */
 		*valuelen -= byte_cnt;
@@ -287,12 +289,13 @@ xfs_attr_rmtval_copyin(
 	char		*dst = bp->b_addr;
 	xfs_daddr_t	bno = bp->b_bn;
 	int		len = BBTOB(bp->b_length);
+	int		blksize = mp->m_attr_geo->blksize;
 
-	ASSERT(len >= XFS_LBSIZE(mp));
+	ASSERT(len >= blksize);
 
 	while (len > 0 && *valuelen > 0) {
 		int hdr_size;
-		int byte_cnt = XFS_ATTR3_RMT_BUF_SPACE(mp, XFS_LBSIZE(mp));
+		int byte_cnt = XFS_ATTR3_RMT_BUF_SPACE(mp, blksize);
 
 		byte_cnt = min(*valuelen, byte_cnt);
 		hdr_size = xfs_attr3_rmt_hdr_set(mp, dst, ino, *offset,
@@ -304,17 +307,17 @@ xfs_attr_rmtval_copyin(
 		 * If this is the last block, zero the remainder of it.
 		 * Check that we are actually the last block, too.
 		 */
-		if (byte_cnt + hdr_size < XFS_LBSIZE(mp)) {
+		if (byte_cnt + hdr_size < blksize) {
 			ASSERT(*valuelen - byte_cnt == 0);
-			ASSERT(len == XFS_LBSIZE(mp));
+			ASSERT(len == blksize);
 			memset(dst + hdr_size + byte_cnt, 0,
-					XFS_LBSIZE(mp) - hdr_size - byte_cnt);
+					blksize - hdr_size - byte_cnt);
 		}
 
 		/* roll buffer forwards */
-		len -= XFS_LBSIZE(mp);
-		dst += XFS_LBSIZE(mp);
-		bno += mp->m_bsize;
+		len -= blksize;
+		dst += blksize;
+		bno += BTOBB(blksize);
 
 		/* roll attribute data forwards */
 		*valuelen -= byte_cnt;
diff --git a/fs/xfs/xfs_da_format.h b/fs/xfs/xfs_da_format.h
index 44d7fac..0a49b02 100644
--- a/fs/xfs/xfs_da_format.h
+++ b/fs/xfs/xfs_da_format.h
@@ -19,10 +19,6 @@
 #ifndef __XFS_DA_FORMAT_H__
 #define __XFS_DA_FORMAT_H__
 
-/*========================================================================
- * Directory Structure when greater than XFS_LBSIZE(mp) bytes.
- *========================================================================*/
-
 /*
  * This structure is common to both leaf nodes and non-leaf nodes in the Btree.
  *
@@ -122,8 +118,6 @@ struct xfs_da3_icnode_hdr {
 	__uint16_t	level;
 };
 
-#define	XFS_LBSIZE(mp)	(mp)->m_sb.sb_blocksize
-
 /*
  * Directory version 2.
  *
@@ -620,10 +614,6 @@ xfs_dir2_block_leaf_p(struct xfs_dir2_block_tail *btp)
  * of an attribute name may not be unique, we may have duplicate keys.  The
  * internal links in the Btree are logical block offsets into the file.
  *
- *========================================================================
- * Attribute structure when equal to XFS_LBSIZE(mp) bytes.
- *========================================================================
- *
  * Struct leaf_entry's are packed from the top.  Name/values grow from the
  * bottom but are not packed.  The freemap contains run-length-encoded entries
  * for the free bytes after the leaf_entry's, but only the N largest such,
-- 
1.9.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
