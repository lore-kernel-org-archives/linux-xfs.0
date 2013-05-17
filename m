Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5F6CA29E15
	for <xfs@oss.sgi.com>; Fri, 17 May 2013 06:14:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3C2FB304059
	for <xfs@oss.sgi.com>; Fri, 17 May 2013 04:14:04 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	uwifanZwHbyzql3Z for <xfs@oss.sgi.com>;
	Fri, 17 May 2013 04:13:55 -0700 (PDT)
Received: from [192.168.1.1] (helo=disappointment)
	by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UdIbX-0008Rq-2E
	for xfs@oss.sgi.com; Fri, 17 May 2013 21:13:43 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UdIbM-0005EY-Vd
	for xfs@oss.sgi.com; Fri, 17 May 2013 21:13:32 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 12/30] xfs: add CRC checking to dir2 leaf blocks
Date: Fri, 17 May 2013 21:13:07 +1000
Message-Id: <1368789205-19969-13-git-send-email-david@fromorbit.com>
In-Reply-To: <1368789205-19969-1-git-send-email-david@fromorbit.com>
References: <1368789205-19969-1-git-send-email-david@fromorbit.com>
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

This addition follows the same pattern as the dir2 block CRCs.
Seeing as both LEAF1 and LEAFN types need to changed at the same
time, this is a pretty large amount of change. leaf block headers
need to be abstracted away from the on-disk structures (struct
xfs_dir3_icleaf_hdr), as do the base leaf entry locations.

This header abstract allows the in-core header and leaf entry
location to be passed around instead of the leaf block itself. This
saves a lot of converting individual variables from on-disk format
to host format where they are used, so there's a good chance that
the compiler will be able to produce much more optimal code as it's
not having to byteswap variables all over the place.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 db/check.c                |    2 +-
 db/dir2.c                 |    2 +-
 include/xfs_da_btree.h    |   23 ++
 include/xfs_dir2_format.h |   60 +++-
 libxfs/xfs_da_btree.c     |   45 ++-
 libxfs/xfs_dir2_block.c   |   19 +-
 libxfs/xfs_dir2_leaf.c    |  786 ++++++++++++++++++++++++++++-----------------
 libxfs/xfs_dir2_node.c    |  475 +++++++++++++++------------
 libxfs/xfs_dir2_priv.h    |   32 +-
 repair/dir2.c             |   12 +-
 repair/phase6.c           |   14 +-
 11 files changed, 938 insertions(+), 532 deletions(-)

diff --git a/db/check.c b/db/check.c
index f464d4a..b7855c0 100644
--- a/db/check.c
+++ b/db/check.c
@@ -3140,7 +3140,7 @@ process_leaf_node_dir_v2_int(
 		error++;
 		return;
 	}
-	lep = leaf->ents;
+	lep = xfs_dir3_leaf_ents_p(leaf);
 	for (i = stale = 0; i < be16_to_cpu(leaf->hdr.count); i++) {
 		if (be32_to_cpu(lep[i].address) == XFS_DIR2_NULL_DATAPTR)
 			stale++;
diff --git a/db/dir2.c b/db/dir2.c
index a539f2d..176bdab 100644
--- a/db/dir2.c
+++ b/db/dir2.c
@@ -80,7 +80,7 @@ const field_t	dir2_flds[] = {
 	  FLD_COUNT, TYP_NONE },
 	{ "lbests", FLDT_DIR2_DATA_OFF, dir2_leaf_bests_offset,
 	  dir2_leaf_bests_count, FLD_ARRAY|FLD_OFFSET|FLD_COUNT, TYP_NONE },
-	{ "lents", FLDT_DIR2_LEAF_ENTRY, OI(LOFF(ents)), dir2_leaf_ents_count,
+	{ "lents", FLDT_DIR2_LEAF_ENTRY, OI(LOFF(__ents)), dir2_leaf_ents_count,
 	  FLD_ARRAY|FLD_COUNT, TYP_NONE },
 	{ "ltail", FLDT_DIR2_LEAF_TAIL, dir2_leaf_tail_offset,
 	  dir2_leaf_tail_count, FLD_OFFSET|FLD_COUNT, TYP_NONE },
diff --git a/include/xfs_da_btree.h b/include/xfs_da_btree.h
index ee5170c..0854b95 100644
--- a/include/xfs_da_btree.h
+++ b/include/xfs_da_btree.h
@@ -47,6 +47,29 @@ typedef struct xfs_da_blkinfo {
 } xfs_da_blkinfo_t;
 
 /*
+ * CRC enabled directory structure types
+ *
+ * The headers change size for the additional verification information, but
+ * otherwise the tree layouts and contents are unchanged.
+ */
+#define	XFS_DIR3_LEAF1_MAGIC	0x3df1	/* magic number: v2 dirlf single blks */
+#define	XFS_DIR3_LEAFN_MAGIC	0x3dff	/* magic number: v2 dirlf multi blks */
+
+struct xfs_da3_blkinfo {
+	/*
+	 * the node link manipulation code relies on the fact that the first
+	 * element of this structure is the struct xfs_da_blkinfo so it can
+	 * ignore the differences in the rest of the structures.
+	 */
+	struct xfs_da_blkinfo	hdr;
+	__be32			crc;	/* CRC of block */
+	__be64			blkno;	/* first block of the buffer */
+	__be64			lsn;	/* sequence number of last write */
+	uuid_t			uuid;	/* filesystem we belong to */
+	__be64			owner;	/* inode that owns the block */
+};
+
+/*
  * This is the structure of the root and intermediate nodes in the Btree.
  * The leaf nodes are defined above.
  *
diff --git a/include/xfs_dir2_format.h b/include/xfs_dir2_format.h
index 8db394a..ce3626b 100644
--- a/include/xfs_dir2_format.h
+++ b/include/xfs_dir2_format.h
@@ -464,6 +464,21 @@ typedef struct xfs_dir2_leaf_hdr {
 	__be16			stale;		/* count of stale entries */
 } xfs_dir2_leaf_hdr_t;
 
+struct xfs_dir3_leaf_hdr {
+	struct xfs_da3_blkinfo	info;		/* header for da routines */
+	__be16			count;		/* count of entries */
+	__be16			stale;		/* count of stale entries */
+	__be32			pad;
+};
+
+struct xfs_dir3_icleaf_hdr {
+	__uint32_t		forw;
+	__uint32_t		back;
+	__uint16_t		magic;
+	__uint16_t		count;
+	__uint16_t		stale;
+};
+
 /*
  * Leaf block entry.
  */
@@ -483,23 +498,50 @@ typedef struct xfs_dir2_leaf_tail {
  * Leaf block.
  */
 typedef struct xfs_dir2_leaf {
-	xfs_dir2_leaf_hdr_t	hdr;		/* leaf header */
-	xfs_dir2_leaf_entry_t	ents[];		/* entries */
+	xfs_dir2_leaf_hdr_t	hdr;			/* leaf header */
+	xfs_dir2_leaf_entry_t	__ents[];		/* entries */
 } xfs_dir2_leaf_t;
 
-/*
- * DB blocks here are logical directory block numbers, not filesystem blocks.
- */
+struct xfs_dir3_leaf {
+	struct xfs_dir3_leaf_hdr	hdr;		/* leaf header */
+	struct xfs_dir2_leaf_entry	__ents[];	/* entries */
+};
+
+#define XFS_DIR3_LEAF_CRC_OFF  offsetof(struct xfs_dir3_leaf_hdr, info.crc)
+
+static inline int
+xfs_dir3_leaf_hdr_size(struct xfs_dir2_leaf *lp)
+{
+	if (lp->hdr.info.magic == cpu_to_be16(XFS_DIR3_LEAF1_MAGIC) ||
+	    lp->hdr.info.magic == cpu_to_be16(XFS_DIR3_LEAFN_MAGIC))
+		return sizeof(struct xfs_dir3_leaf_hdr);
+	return sizeof(struct xfs_dir2_leaf_hdr);
+}
 
-static inline int xfs_dir2_max_leaf_ents(struct xfs_mount *mp)
+static inline int
+xfs_dir3_max_leaf_ents(struct xfs_mount *mp, struct xfs_dir2_leaf *lp)
 {
-	return (mp->m_dirblksize - (uint)sizeof(struct xfs_dir2_leaf_hdr)) /
+	return (mp->m_dirblksize - xfs_dir3_leaf_hdr_size(lp)) /
 		(uint)sizeof(struct xfs_dir2_leaf_entry);
 }
 
 /*
  * Get address of the bestcount field in the single-leaf block.
  */
+static inline struct xfs_dir2_leaf_entry *
+xfs_dir3_leaf_ents_p(struct xfs_dir2_leaf *lp)
+{
+	if (lp->hdr.info.magic == cpu_to_be16(XFS_DIR3_LEAF1_MAGIC) ||
+	    lp->hdr.info.magic == cpu_to_be16(XFS_DIR3_LEAFN_MAGIC)) {
+		struct xfs_dir3_leaf *lp3 = (struct xfs_dir3_leaf *)lp;
+		return lp3->__ents;
+	}
+	return lp->__ents;
+}
+
+/*
+ * Get address of the bestcount field in the single-leaf block.
+ */
 static inline struct xfs_dir2_leaf_tail *
 xfs_dir2_leaf_tail_p(struct xfs_mount *mp, struct xfs_dir2_leaf *lp)
 {
@@ -518,6 +560,10 @@ xfs_dir2_leaf_bests_p(struct xfs_dir2_leaf_tail *ltp)
 }
 
 /*
+ * DB blocks here are logical directory block numbers, not filesystem blocks.
+ */
+
+/*
  * Convert dataptr to byte in file space
  */
 static inline xfs_dir2_off_t
diff --git a/libxfs/xfs_da_btree.c b/libxfs/xfs_da_btree.c
index a31d353..63cd299 100644
--- a/libxfs/xfs_da_btree.c
+++ b/libxfs/xfs_da_btree.c
@@ -118,7 +118,8 @@ xfs_da_node_read_verify(
 			bp->b_ops->verify_read(bp);
 			return;
 		case XFS_DIR2_LEAFN_MAGIC:
-			bp->b_ops = &xfs_dir2_leafn_buf_ops;
+		case XFS_DIR3_LEAFN_MAGIC:
+			bp->b_ops = &xfs_dir3_leafn_buf_ops;
 			bp->b_ops->verify_read(bp);
 			return;
 		default:
@@ -375,11 +376,18 @@ xfs_da_root_split(xfs_da_state_t *state, xfs_da_state_blk_t *blk1,
 		size = (int)((char *)&oldroot->btree[be16_to_cpu(oldroot->hdr.count)] -
 			     (char *)oldroot);
 	} else {
-		ASSERT(oldroot->hdr.info.magic == cpu_to_be16(XFS_DIR2_LEAFN_MAGIC));
+		struct xfs_dir3_icleaf_hdr leafhdr;
+		struct xfs_dir2_leaf_entry *ents;
+
 		leaf = (xfs_dir2_leaf_t *)oldroot;
-		size = (int)((char *)&leaf->ents[be16_to_cpu(leaf->hdr.count)] -
-			     (char *)leaf);
+		xfs_dir3_leaf_hdr_from_disk(&leafhdr, leaf);
+		ents = xfs_dir3_leaf_ents_p(leaf);
+
+		ASSERT(leafhdr.magic == XFS_DIR2_LEAFN_MAGIC ||
+		       leafhdr.magic == XFS_DIR3_LEAFN_MAGIC);
+		size = (int)((char *)&ents[leafhdr.count] - (char *)leaf);
 	}
+	/* XXX: can't just copy CRC headers from one block to another */
 	memcpy(node, oldroot, size);
 	xfs_trans_log_buf(tp, bp, 0, size - 1);
 
@@ -403,7 +411,8 @@ xfs_da_root_split(xfs_da_state_t *state, xfs_da_state_blk_t *blk1,
 	node->hdr.count = cpu_to_be16(2);
 
 #ifdef DEBUG
-	if (oldroot->hdr.info.magic == cpu_to_be16(XFS_DIR2_LEAFN_MAGIC)) {
+	if (oldroot->hdr.info.magic == cpu_to_be16(XFS_DIR2_LEAFN_MAGIC) ||
+	    oldroot->hdr.info.magic == cpu_to_be16(XFS_DIR3_LEAFN_MAGIC)) {
 		ASSERT(blk1->blkno >= mp->m_dirleafblk &&
 		       blk1->blkno < mp->m_dirfreeblk);
 		ASSERT(blk2->blkno >= mp->m_dirleafblk &&
@@ -761,6 +770,7 @@ xfs_da_blkinfo_onlychild_validate(struct xfs_da_blkinfo *blkinfo, __u16 level)
 
 	if (level == 1) {
 		ASSERT(magic == cpu_to_be16(XFS_DIR2_LEAFN_MAGIC) ||
+		       magic == cpu_to_be16(XFS_DIR3_LEAFN_MAGIC) ||
 		       magic == cpu_to_be16(XFS_ATTR_LEAF_MAGIC));
 	} else
 		ASSERT(magic == cpu_to_be16(XFS_DA_NODE_MAGIC));
@@ -1544,6 +1554,7 @@ xfs_da_path_shift(xfs_da_state_t *state, xfs_da_state_path_t *path,
 		info = blk->bp->b_addr;
 		ASSERT(info->magic == cpu_to_be16(XFS_DA_NODE_MAGIC) ||
 		       info->magic == cpu_to_be16(XFS_DIR2_LEAFN_MAGIC) ||
+		       info->magic == cpu_to_be16(XFS_DIR3_LEAFN_MAGIC) ||
 		       info->magic == cpu_to_be16(XFS_ATTR_LEAF_MAGIC));
 		blk->magic = be16_to_cpu(info->magic);
 		if (blk->magic == XFS_DA_NODE_MAGIC) {
@@ -1563,12 +1574,13 @@ xfs_da_path_shift(xfs_da_state_t *state, xfs_da_state_path_t *path,
 								      NULL);
 				break;
 			case XFS_DIR2_LEAFN_MAGIC:
+			case XFS_DIR3_LEAFN_MAGIC:
+				blk->magic = XFS_DIR2_LEAFN_MAGIC;
 				blk->hashval = xfs_dir2_leafn_lasthash(blk->bp,
 								       NULL);
 				break;
 			default:
-				ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC ||
-				       blk->magic == XFS_DIR2_LEAFN_MAGIC);
+				ASSERT(0);
 				break;
 			}
 		}
@@ -1812,10 +1824,16 @@ xfs_da_swap_lastblock(
 	/*
 	 * Get values from the moved block.
 	 */
-	if (dead_info->magic == cpu_to_be16(XFS_DIR2_LEAFN_MAGIC)) {
+	if (dead_info->magic == cpu_to_be16(XFS_DIR2_LEAFN_MAGIC) ||
+	    dead_info->magic == cpu_to_be16(XFS_DIR3_LEAFN_MAGIC)) {
+		struct xfs_dir3_icleaf_hdr leafhdr;
+		struct xfs_dir2_leaf_entry *ents;
+
 		dead_leaf2 = (xfs_dir2_leaf_t *)dead_info;
+		xfs_dir3_leaf_hdr_from_disk(&leafhdr, dead_leaf2);
+		ents = xfs_dir3_leaf_ents_p(dead_leaf2);
 		dead_level = 0;
-		dead_hash = be32_to_cpu(dead_leaf2->ents[be16_to_cpu(dead_leaf2->hdr.count) - 1].hashval);
+		dead_hash = be32_to_cpu(ents[leafhdr.count - 1].hashval);
 	} else {
 		ASSERT(dead_info->magic == cpu_to_be16(XFS_DA_NODE_MAGIC));
 		dead_node = (xfs_da_intnode_t *)dead_info;
@@ -2260,10 +2278,17 @@ xfs_da_read_buf(
 		    XFS_TEST_ERROR((magic != XFS_DA_NODE_MAGIC) &&
 				   (magic != XFS_ATTR_LEAF_MAGIC) &&
 				   (magic != XFS_DIR2_LEAF1_MAGIC) &&
+				   (magic != XFS_DIR3_LEAF1_MAGIC) &&
 				   (magic != XFS_DIR2_LEAFN_MAGIC) &&
+				   (magic != XFS_DIR3_LEAFN_MAGIC) &&
 				   (magic1 != XFS_DIR2_BLOCK_MAGIC) &&
+				   (magic1 != XFS_DIR3_BLOCK_MAGIC) &&
 				   (magic1 != XFS_DIR2_DATA_MAGIC) &&
-				   (free->hdr.magic != cpu_to_be32(XFS_DIR2_FREE_MAGIC)),
+				   (magic1 != XFS_DIR3_DATA_MAGIC) &&
+				   (free->hdr.magic !=
+					cpu_to_be32(XFS_DIR2_FREE_MAGIC)) &&
+				   (free->hdr.magic !=
+					cpu_to_be32(XFS_DIR3_FREE_MAGIC)),
 				mp, XFS_ERRTAG_DA_READ_BUF,
 				XFS_RANDOM_DA_READ_BUF))) {
 			trace_xfs_da_btree_corrupt(bp, _RET_IP_);
diff --git a/libxfs/xfs_dir2_block.c b/libxfs/xfs_dir2_block.c
index 18eabd1..b98b749 100644
--- a/libxfs/xfs_dir2_block.c
+++ b/libxfs/xfs_dir2_block.c
@@ -897,6 +897,8 @@ xfs_dir2_leaf_to_block(
 	__be16			*tagp;		/* end of entry (tag) */
 	int			to;		/* block/leaf to index */
 	xfs_trans_t		*tp;		/* transaction pointer */
+	struct xfs_dir2_leaf_entry *ents;
+	struct xfs_dir3_icleaf_hdr leafhdr;
 
 	trace_xfs_dir2_leaf_to_block(args);
 
@@ -904,8 +906,12 @@ xfs_dir2_leaf_to_block(
 	tp = args->trans;
 	mp = dp->i_mount;
 	leaf = lbp->b_addr;
-	ASSERT(leaf->hdr.info.magic == cpu_to_be16(XFS_DIR2_LEAF1_MAGIC));
+	xfs_dir3_leaf_hdr_from_disk(&leafhdr, leaf);
+	ents = xfs_dir3_leaf_ents_p(leaf);
 	ltp = xfs_dir2_leaf_tail_p(mp, leaf);
+
+	ASSERT(leafhdr.magic == XFS_DIR2_LEAF1_MAGIC ||
+	       leafhdr.magic == XFS_DIR3_LEAF1_MAGIC);
 	/*
 	 * If there are data blocks other than the first one, take this
 	 * opportunity to remove trailing empty data blocks that may have
@@ -942,7 +948,7 @@ xfs_dir2_leaf_to_block(
 	 * Size of the "leaf" area in the block.
 	 */
 	size = (uint)sizeof(xfs_dir2_block_tail_t) +
-	       (uint)sizeof(*lep) * (be16_to_cpu(leaf->hdr.count) - be16_to_cpu(leaf->hdr.stale));
+	       (uint)sizeof(*lep) * (leafhdr.count - leafhdr.stale);
 	/*
 	 * Look at the last data entry.
 	 */
@@ -971,18 +977,17 @@ xfs_dir2_leaf_to_block(
 	 * Initialize the block tail.
 	 */
 	btp = xfs_dir2_block_tail_p(mp, hdr);
-	btp->count = cpu_to_be32(be16_to_cpu(leaf->hdr.count) - be16_to_cpu(leaf->hdr.stale));
+	btp->count = cpu_to_be32(leafhdr.count - leafhdr.stale);
 	btp->stale = 0;
 	xfs_dir2_block_log_tail(tp, dbp);
 	/*
 	 * Initialize the block leaf area.  We compact out stale entries.
 	 */
 	lep = xfs_dir2_block_leaf_p(btp);
-	for (from = to = 0; from < be16_to_cpu(leaf->hdr.count); from++) {
-		if (leaf->ents[from].address ==
-		    cpu_to_be32(XFS_DIR2_NULL_DATAPTR))
+	for (from = to = 0; from < leafhdr.count; from++) {
+		if (ents[from].address == cpu_to_be32(XFS_DIR2_NULL_DATAPTR))
 			continue;
-		lep[to++] = leaf->ents[from];
+		lep[to++] = ents[from];
 	}
 	ASSERT(to == be32_to_cpu(btp->count));
 	xfs_dir2_block_log_leaf(tp, dbp, 0, be32_to_cpu(btp->count) - 1);
diff --git a/libxfs/xfs_dir2_leaf.c b/libxfs/xfs_dir2_leaf.c
index 0f848b4..f00b23c 100644
--- a/libxfs/xfs_dir2_leaf.c
+++ b/libxfs/xfs_dir2_leaf.c
@@ -1,5 +1,6 @@
 /*
  * Copyright (c) 2000-2003,2005 Silicon Graphics, Inc.
+ * Copyright (c) 2013 Red Hat, Inc.
  * All Rights Reserved.
  *
  * This program is free software; you can redistribute it and/or
@@ -21,73 +22,257 @@
 /*
  * Local function declarations.
  */
-#ifdef DEBUG
-static void xfs_dir2_leaf_check(struct xfs_inode *dp, struct xfs_buf *bp);
-#else
-#define	xfs_dir2_leaf_check(dp, bp)
-#endif
 static int xfs_dir2_leaf_lookup_int(xfs_da_args_t *args, struct xfs_buf **lbpp,
 				    int *indexp, struct xfs_buf **dbpp);
-static void xfs_dir2_leaf_log_bests(struct xfs_trans *tp, struct xfs_buf *bp,
+static void xfs_dir3_leaf_log_bests(struct xfs_trans *tp, struct xfs_buf *bp,
 				    int first, int last);
-static void xfs_dir2_leaf_log_tail(struct xfs_trans *tp, struct xfs_buf *bp);
+static void xfs_dir3_leaf_log_tail(struct xfs_trans *tp, struct xfs_buf *bp);
 
-static void
-xfs_dir2_leaf_verify(
+/*
+ * Check the internal consistency of a leaf1 block.
+ * Pop an assert if something is wrong.
+ */
+#ifdef DEBUG
+#define	xfs_dir3_leaf_check(mp, bp) \
+do { \
+	if (!xfs_dir3_leaf1_check((mp), (bp))) \
+		ASSERT(0); \
+} while (0);
+
+STATIC bool
+xfs_dir3_leaf1_check(
+	struct xfs_mount	*mp,
+	struct xfs_buf		*bp)
+{
+	struct xfs_dir2_leaf	*leaf = bp->b_addr;
+	struct xfs_dir3_icleaf_hdr leafhdr;
+
+	xfs_dir3_leaf_hdr_from_disk(&leafhdr, leaf);
+
+	if (leafhdr.magic == XFS_DIR3_LEAF1_MAGIC) {
+		struct xfs_dir3_leaf_hdr *leaf3 = bp->b_addr;
+		if (be64_to_cpu(leaf3->info.blkno) != bp->b_bn)
+			return false;
+	} else if (leafhdr.magic != XFS_DIR2_LEAF1_MAGIC)
+		return false;
+
+	return xfs_dir3_leaf_check_int(mp, &leafhdr, leaf);
+}
+#else
+#define	xfs_dir3_leaf_check(mp, bp)
+#endif
+
+void
+xfs_dir3_leaf_hdr_from_disk(
+	struct xfs_dir3_icleaf_hdr	*to,
+	struct xfs_dir2_leaf		*from)
+{
+	if (from->hdr.info.magic == cpu_to_be16(XFS_DIR2_LEAF1_MAGIC) ||
+	    from->hdr.info.magic == cpu_to_be16(XFS_DIR2_LEAFN_MAGIC)) {
+		to->forw = be32_to_cpu(from->hdr.info.forw);
+		to->back = be32_to_cpu(from->hdr.info.back);
+		to->magic = be16_to_cpu(from->hdr.info.magic);
+		to->count = be16_to_cpu(from->hdr.count);
+		to->stale = be16_to_cpu(from->hdr.stale);
+	} else {
+		struct xfs_dir3_leaf_hdr *hdr3 = (struct xfs_dir3_leaf_hdr *)from;
+
+		to->forw = be32_to_cpu(hdr3->info.hdr.forw);
+		to->back = be32_to_cpu(hdr3->info.hdr.back);
+		to->magic = be16_to_cpu(hdr3->info.hdr.magic);
+		to->count = be16_to_cpu(hdr3->count);
+		to->stale = be16_to_cpu(hdr3->stale);
+	}
+
+	ASSERT(to->magic == XFS_DIR2_LEAF1_MAGIC ||
+	       to->magic == XFS_DIR3_LEAF1_MAGIC ||
+	       to->magic == XFS_DIR2_LEAFN_MAGIC ||
+	       to->magic == XFS_DIR3_LEAFN_MAGIC);
+}
+
+void
+xfs_dir3_leaf_hdr_to_disk(
+	struct xfs_dir2_leaf		*to,
+	struct xfs_dir3_icleaf_hdr	*from)
+{
+	ASSERT(from->magic == XFS_DIR2_LEAF1_MAGIC ||
+	       from->magic == XFS_DIR3_LEAF1_MAGIC ||
+	       from->magic == XFS_DIR2_LEAFN_MAGIC ||
+	       from->magic == XFS_DIR3_LEAFN_MAGIC);
+
+	if (from->magic == XFS_DIR2_LEAF1_MAGIC ||
+	    from->magic == XFS_DIR2_LEAFN_MAGIC) {
+		to->hdr.info.forw = cpu_to_be32(from->forw);
+		to->hdr.info.back = cpu_to_be32(from->back);
+		to->hdr.info.magic = cpu_to_be16(from->magic);
+		to->hdr.count = cpu_to_be16(from->count);
+		to->hdr.stale = cpu_to_be16(from->stale);
+	} else {
+		struct xfs_dir3_leaf_hdr *hdr3 = (struct xfs_dir3_leaf_hdr *)to;
+
+		hdr3->info.hdr.forw = cpu_to_be32(from->forw);
+		hdr3->info.hdr.back = cpu_to_be32(from->back);
+		hdr3->info.hdr.magic = cpu_to_be16(from->magic);
+		hdr3->count = cpu_to_be16(from->count);
+		hdr3->stale = cpu_to_be16(from->stale);
+	}
+}
+
+bool
+xfs_dir3_leaf_check_int(
+	struct xfs_mount	*mp,
+	struct xfs_dir3_icleaf_hdr *hdr,
+	struct xfs_dir2_leaf	*leaf)
+{
+	struct xfs_dir2_leaf_entry *ents;
+	xfs_dir2_leaf_tail_t	*ltp;
+	int			stale;
+	int			i;
+
+	ents = xfs_dir3_leaf_ents_p(leaf);
+	ltp = xfs_dir2_leaf_tail_p(mp, leaf);
+
+	/*
+	 * XXX (dgc): This value is not restrictive enough.
+	 * Should factor in the size of the bests table as well.
+	 * We can deduce a value for that from di_size.
+	 */
+	if (hdr->count > xfs_dir3_max_leaf_ents(mp, leaf))
+		return false;
+
+	/* Leaves and bests don't overlap in leaf format. */
+	if ((hdr->magic == XFS_DIR2_LEAF1_MAGIC ||
+	     hdr->magic == XFS_DIR3_LEAF1_MAGIC) &&
+	    (char *)&ents[hdr->count] > (char *)xfs_dir2_leaf_bests_p(ltp))
+		return false;
+
+	/* Check hash value order, count stale entries.  */
+	for (i = stale = 0; i < hdr->count; i++) {
+		if (i + 1 < hdr->count) {
+			if (be32_to_cpu(ents[i].hashval) >
+					be32_to_cpu(ents[i + 1].hashval))
+				return false;
+		}
+		if (ents[i].address == cpu_to_be32(XFS_DIR2_NULL_DATAPTR))
+			stale++;
+	}
+	if (hdr->stale != stale)
+		return false;
+	return true;
+}
+
+static bool
+xfs_dir3_leaf_verify(
 	struct xfs_buf		*bp,
-	__be16			magic)
+	__uint16_t		magic)
 {
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
-	struct xfs_dir2_leaf_hdr *hdr = bp->b_addr;
-	int			block_ok = 0;
+	struct xfs_dir2_leaf	*leaf = bp->b_addr;
+	struct xfs_dir3_icleaf_hdr leafhdr;
+
+	ASSERT(magic == XFS_DIR2_LEAF1_MAGIC || magic == XFS_DIR2_LEAFN_MAGIC);
+
+	xfs_dir3_leaf_hdr_from_disk(&leafhdr, leaf);
+	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+		struct xfs_dir3_leaf_hdr *leaf3 = bp->b_addr;
 
-	block_ok = hdr->info.magic == magic;
-	if (!block_ok) {
-		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, hdr);
+		if ((magic == XFS_DIR2_LEAF1_MAGIC &&
+		     leafhdr.magic != XFS_DIR3_LEAF1_MAGIC) ||
+		    (magic == XFS_DIR2_LEAFN_MAGIC &&
+		     leafhdr.magic != XFS_DIR3_LEAFN_MAGIC))
+			return false;
+
+		if (!uuid_equal(&leaf3->info.uuid, &mp->m_sb.sb_uuid))
+			return false;
+		if (be64_to_cpu(leaf3->info.blkno) != bp->b_bn)
+			return false;
+	} else {
+		if (leafhdr.magic != magic)
+			return false;
+	}
+	return xfs_dir3_leaf_check_int(mp, &leafhdr, leaf);
+}
+
+static void
+__read_verify(
+	struct xfs_buf  *bp,
+	__uint16_t	magic)
+{
+	struct xfs_mount	*mp = bp->b_target->bt_mount;
+
+	if ((xfs_sb_version_hascrc(&mp->m_sb) &&
+	     !xfs_verify_cksum(bp->b_addr, BBTOB(bp->b_length),
+					  XFS_DIR3_LEAF_CRC_OFF)) ||
+	    !xfs_dir3_leaf_verify(bp, magic)) {
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, bp->b_addr);
 		xfs_buf_ioerror(bp, EFSCORRUPTED);
 	}
 }
 
 static void
-xfs_dir2_leaf1_read_verify(
+__write_verify(
+	struct xfs_buf  *bp,
+	__uint16_t	magic)
+{
+	struct xfs_mount	*mp = bp->b_target->bt_mount;
+	struct xfs_buf_log_item	*bip = bp->b_fspriv;
+	struct xfs_dir3_leaf_hdr *hdr3 = bp->b_addr;
+
+	if (!xfs_dir3_leaf_verify(bp, magic)) {
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, bp->b_addr);
+		xfs_buf_ioerror(bp, EFSCORRUPTED);
+		return;
+	}
+
+	if (!xfs_sb_version_hascrc(&mp->m_sb))
+		return;
+
+	if (bip)
+		hdr3->info.lsn = cpu_to_be64(bip->bli_item.li_lsn);
+
+	xfs_update_cksum(bp->b_addr, BBTOB(bp->b_length), XFS_DIR3_LEAF_CRC_OFF);
+}
+
+static void
+xfs_dir3_leaf1_read_verify(
 	struct xfs_buf	*bp)
 {
-	xfs_dir2_leaf_verify(bp, cpu_to_be16(XFS_DIR2_LEAF1_MAGIC));
+	__read_verify(bp, XFS_DIR2_LEAF1_MAGIC);
 }
 
 static void
-xfs_dir2_leaf1_write_verify(
+xfs_dir3_leaf1_write_verify(
 	struct xfs_buf	*bp)
 {
-	xfs_dir2_leaf_verify(bp, cpu_to_be16(XFS_DIR2_LEAF1_MAGIC));
+	__write_verify(bp, XFS_DIR2_LEAF1_MAGIC);
 }
 
 void
-xfs_dir2_leafn_read_verify(
+xfs_dir3_leafn_read_verify(
 	struct xfs_buf	*bp)
 {
-	xfs_dir2_leaf_verify(bp, cpu_to_be16(XFS_DIR2_LEAFN_MAGIC));
+	__read_verify(bp, XFS_DIR2_LEAFN_MAGIC);
 }
 
 void
-xfs_dir2_leafn_write_verify(
+xfs_dir3_leafn_write_verify(
 	struct xfs_buf	*bp)
 {
-	xfs_dir2_leaf_verify(bp, cpu_to_be16(XFS_DIR2_LEAFN_MAGIC));
+	__write_verify(bp, XFS_DIR2_LEAFN_MAGIC);
 }
 
-static const struct xfs_buf_ops xfs_dir2_leaf1_buf_ops = {
-	.verify_read = xfs_dir2_leaf1_read_verify,
-	.verify_write = xfs_dir2_leaf1_write_verify,
+const struct xfs_buf_ops xfs_dir3_leaf1_buf_ops = {
+	.verify_read = xfs_dir3_leaf1_read_verify,
+	.verify_write = xfs_dir3_leaf1_write_verify,
 };
 
-const struct xfs_buf_ops xfs_dir2_leafn_buf_ops = {
-	.verify_read = xfs_dir2_leafn_read_verify,
-	.verify_write = xfs_dir2_leafn_write_verify,
+const struct xfs_buf_ops xfs_dir3_leafn_buf_ops = {
+	.verify_read = xfs_dir3_leafn_read_verify,
+	.verify_write = xfs_dir3_leafn_write_verify,
 };
 
 static int
-xfs_dir2_leaf_read(
+xfs_dir3_leaf_read(
 	struct xfs_trans	*tp,
 	struct xfs_inode	*dp,
 	xfs_dablk_t		fbno,
@@ -95,11 +280,11 @@ xfs_dir2_leaf_read(
 	struct xfs_buf		**bpp)
 {
 	return xfs_da_read_buf(tp, dp, fbno, mappedbno, bpp,
-				XFS_DATA_FORK, &xfs_dir2_leaf1_buf_ops);
+				XFS_DATA_FORK, &xfs_dir3_leaf1_buf_ops);
 }
 
 int
-xfs_dir2_leafn_read(
+xfs_dir3_leafn_read(
 	struct xfs_trans	*tp,
 	struct xfs_inode	*dp,
 	xfs_dablk_t		fbno,
@@ -107,7 +292,81 @@ xfs_dir2_leafn_read(
 	struct xfs_buf		**bpp)
 {
 	return xfs_da_read_buf(tp, dp, fbno, mappedbno, bpp,
-				XFS_DATA_FORK, &xfs_dir2_leafn_buf_ops);
+				XFS_DATA_FORK, &xfs_dir3_leafn_buf_ops);
+}
+
+/*
+ * Initialize a new leaf block, leaf1 or leafn magic accepted.
+ */
+static void
+xfs_dir3_leaf_init(
+	struct xfs_mount	*mp,
+	struct xfs_buf		*bp,
+	xfs_ino_t		owner,
+	__uint16_t		type)
+{
+	struct xfs_dir2_leaf	*leaf = bp->b_addr;
+
+	ASSERT(type == XFS_DIR2_LEAF1_MAGIC || type == XFS_DIR2_LEAFN_MAGIC);
+
+	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+		struct xfs_dir3_leaf_hdr *leaf3 = bp->b_addr;
+
+		memset(leaf3, 0, sizeof(*leaf3));
+
+		leaf3->info.hdr.magic = (type == XFS_DIR2_LEAF1_MAGIC)
+					 ? cpu_to_be16(XFS_DIR3_LEAF1_MAGIC)
+					 : cpu_to_be16(XFS_DIR3_LEAFN_MAGIC);
+		leaf3->info.blkno = cpu_to_be64(bp->b_bn);
+		leaf3->info.owner = cpu_to_be64(owner);
+		uuid_copy(&leaf3->info.uuid, &mp->m_sb.sb_uuid);
+	} else {
+		memset(leaf, 0, sizeof(*leaf));
+		leaf->hdr.info.magic = cpu_to_be16(type);
+	}
+
+	/*
+	 * If it's a leaf-format directory initialize the tail.
+	 * Caller is responsible for initialising the bests table.
+	 */
+	if (type == XFS_DIR2_LEAF1_MAGIC) {
+		struct xfs_dir2_leaf_tail *ltp;
+
+		ltp = xfs_dir2_leaf_tail_p(mp, leaf);
+		ltp->bestcount = 0;
+		bp->b_ops = &xfs_dir3_leaf1_buf_ops;
+	} else
+		bp->b_ops = &xfs_dir3_leafn_buf_ops;
+}
+
+int
+xfs_dir3_leaf_get_buf(
+	xfs_da_args_t		*args,
+	xfs_dir2_db_t		bno,
+	struct xfs_buf		**bpp,
+	__uint16_t		magic)
+{
+	struct xfs_inode	*dp = args->dp;
+	struct xfs_trans	*tp = args->trans;
+	struct xfs_mount	*mp = dp->i_mount;
+	struct xfs_buf		*bp;
+	int			error;
+
+	ASSERT(magic == XFS_DIR2_LEAF1_MAGIC || magic == XFS_DIR2_LEAFN_MAGIC);
+	ASSERT(bno >= XFS_DIR2_LEAF_FIRSTDB(mp) &&
+	       bno < XFS_DIR2_FREE_FIRSTDB(mp));
+
+	error = xfs_da_get_buf(tp, dp, xfs_dir2_db_to_da(mp, bno), -1, &bp,
+			       XFS_DATA_FORK);
+	if (error)
+		return error;
+
+	xfs_dir3_leaf_init(mp, bp, dp->i_ino, magic);
+	xfs_dir3_leaf_log_header(tp, bp);
+	if (magic == XFS_DIR2_LEAF1_MAGIC)
+		xfs_dir3_leaf_log_tail(tp, bp);
+	*bpp = bp;
+	return 0;
 }
 
 /*
@@ -134,6 +393,8 @@ xfs_dir2_block_to_leaf(
 	int			needscan;	/* need to rescan bestfree */
 	xfs_trans_t		*tp;		/* transaction pointer */
 	struct xfs_dir2_data_free *bf;
+	struct xfs_dir2_leaf_entry *ents;
+	struct xfs_dir3_icleaf_hdr leafhdr;
 
 	trace_xfs_dir2_block_to_leaf(args);
 
@@ -153,27 +414,33 @@ xfs_dir2_block_to_leaf(
 	/*
 	 * Initialize the leaf block, get a buffer for it.
 	 */
-	if ((error = xfs_dir2_leaf_init(args, ldb, &lbp, XFS_DIR2_LEAF1_MAGIC))) {
+	error = xfs_dir3_leaf_get_buf(args, ldb, &lbp, XFS_DIR2_LEAF1_MAGIC);
+	if (error)
 		return error;
-	}
-	ASSERT(lbp != NULL);
+
 	leaf = lbp->b_addr;
 	hdr = dbp->b_addr;
 	xfs_dir3_data_check(dp, dbp);
 	btp = xfs_dir2_block_tail_p(mp, hdr);
 	blp = xfs_dir2_block_leaf_p(btp);
 	bf = xfs_dir3_data_bestfree_p(hdr);
+	ents = xfs_dir3_leaf_ents_p(leaf);
+
 	/*
 	 * Set the counts in the leaf header.
 	 */
-	leaf->hdr.count = cpu_to_be16(be32_to_cpu(btp->count));
-	leaf->hdr.stale = cpu_to_be16(be32_to_cpu(btp->stale));
+	xfs_dir3_leaf_hdr_from_disk(&leafhdr, leaf);
+	leafhdr.count = be32_to_cpu(btp->count);
+	leafhdr.stale = be32_to_cpu(btp->stale);
+	xfs_dir3_leaf_hdr_to_disk(leaf, &leafhdr);
+	xfs_dir3_leaf_log_header(tp, lbp);
+
 	/*
 	 * Could compact these but I think we always do the conversion
 	 * after squeezing out stale entries.
 	 */
-	memcpy(leaf->ents, blp, be32_to_cpu(btp->count) * sizeof(xfs_dir2_leaf_entry_t));
-	xfs_dir2_leaf_log_ents(tp, lbp, 0, be16_to_cpu(leaf->hdr.count) - 1);
+	memcpy(ents, blp, be32_to_cpu(btp->count) * sizeof(xfs_dir2_leaf_entry_t));
+	xfs_dir3_leaf_log_ents(tp, lbp, 0, leafhdr.count - 1);
 	needscan = 0;
 	needlog = 1;
 	/*
@@ -208,15 +475,16 @@ xfs_dir2_block_to_leaf(
 	 */
 	if (needlog)
 		xfs_dir2_data_log_header(tp, dbp);
-	xfs_dir2_leaf_check(dp, lbp);
+	xfs_dir3_leaf_check(mp, lbp);
 	xfs_dir3_data_check(dp, dbp);
-	xfs_dir2_leaf_log_bests(tp, lbp, 0, 0);
+	xfs_dir3_leaf_log_bests(tp, lbp, 0, 0);
 	return 0;
 }
 
 STATIC void
-xfs_dir2_leaf_find_stale(
-	struct xfs_dir2_leaf	*leaf,
+xfs_dir3_leaf_find_stale(
+	struct xfs_dir3_icleaf_hdr *leafhdr,
+	struct xfs_dir2_leaf_entry *ents,
 	int			index,
 	int			*lowstale,
 	int			*highstale)
@@ -225,7 +493,7 @@ xfs_dir2_leaf_find_stale(
 	 * Find the first stale entry before our index, if any.
 	 */
 	for (*lowstale = index - 1; *lowstale >= 0; --*lowstale) {
-		if (leaf->ents[*lowstale].address ==
+		if (ents[*lowstale].address ==
 		    cpu_to_be32(XFS_DIR2_NULL_DATAPTR))
 			break;
 	}
@@ -235,10 +503,8 @@ xfs_dir2_leaf_find_stale(
 	 * Stop if the result would require moving more entries than using
 	 * lowstale.
 	 */
-	for (*highstale = index;
-	     *highstale < be16_to_cpu(leaf->hdr.count);
-	     ++*highstale) {
-		if (leaf->ents[*highstale].address ==
+	for (*highstale = index; *highstale < leafhdr->count; ++*highstale) {
+		if (ents[*highstale].address ==
 		    cpu_to_be32(XFS_DIR2_NULL_DATAPTR))
 			break;
 		if (*lowstale >= 0 && index - *lowstale <= *highstale - index)
@@ -247,8 +513,9 @@ xfs_dir2_leaf_find_stale(
 }
 
 struct xfs_dir2_leaf_entry *
-xfs_dir2_leaf_find_entry(
-	xfs_dir2_leaf_t		*leaf,		/* leaf structure */
+xfs_dir3_leaf_find_entry(
+	struct xfs_dir3_icleaf_hdr *leafhdr,
+	struct xfs_dir2_leaf_entry *ents,
 	int			index,		/* leaf table position */
 	int			compact,	/* need to compact leaves */
 	int			lowstale,	/* index of prev stale leaf */
@@ -256,7 +523,7 @@ xfs_dir2_leaf_find_entry(
 	int			*lfloglow,	/* low leaf logging index */
 	int			*lfloghigh)	/* high leaf logging index */
 {
-	if (!leaf->hdr.stale) {
+	if (!leafhdr->stale) {
 		xfs_dir2_leaf_entry_t	*lep;	/* leaf entry table pointer */
 
 		/*
@@ -264,18 +531,16 @@ xfs_dir2_leaf_find_entry(
 		 *
 		 * If there are no stale entries, just insert a hole at index.
 		 */
-		lep = &leaf->ents[index];
-		if (index < be16_to_cpu(leaf->hdr.count))
+		lep = &ents[index];
+		if (index < leafhdr->count)
 			memmove(lep + 1, lep,
-				(be16_to_cpu(leaf->hdr.count) - index) *
-				 sizeof(*lep));
+				(leafhdr->count - index) * sizeof(*lep));
 
 		/*
 		 * Record low and high logging indices for the leaf.
 		 */
 		*lfloglow = index;
-		*lfloghigh = be16_to_cpu(leaf->hdr.count);
-		be16_add_cpu(&leaf->hdr.count, 1);
+		*lfloghigh = leafhdr->count++;
 		return lep;
 	}
 
@@ -289,16 +554,17 @@ xfs_dir2_leaf_find_entry(
 	 * entries before and after our insertion point.
 	 */
 	if (compact == 0)
-		xfs_dir2_leaf_find_stale(leaf, index, &lowstale, &highstale);
+		xfs_dir3_leaf_find_stale(leafhdr, ents, index,
+					 &lowstale, &highstale);
 
 	/*
 	 * If the low one is better, use it.
 	 */
 	if (lowstale >= 0 &&
-	    (highstale == be16_to_cpu(leaf->hdr.count) ||
+	    (highstale == leafhdr->count ||
 	     index - lowstale - 1 < highstale - index)) {
 		ASSERT(index - lowstale - 1 >= 0);
-		ASSERT(leaf->ents[lowstale].address ==
+		ASSERT(ents[lowstale].address ==
 		       cpu_to_be32(XFS_DIR2_NULL_DATAPTR));
 
 		/*
@@ -306,37 +572,34 @@ xfs_dir2_leaf_find_entry(
 		 * for the new entry.
 		 */
 		if (index - lowstale - 1 > 0) {
-			memmove(&leaf->ents[lowstale],
-				&leaf->ents[lowstale + 1],
+			memmove(&ents[lowstale], &ents[lowstale + 1],
 				(index - lowstale - 1) *
-				sizeof(xfs_dir2_leaf_entry_t));
+					sizeof(xfs_dir2_leaf_entry_t));
 		}
 		*lfloglow = MIN(lowstale, *lfloglow);
 		*lfloghigh = MAX(index - 1, *lfloghigh);
-		be16_add_cpu(&leaf->hdr.stale, -1);
-		return &leaf->ents[index - 1];
+		leafhdr->stale--;
+		return &ents[index - 1];
 	}
 
 	/*
 	 * The high one is better, so use that one.
 	 */
 	ASSERT(highstale - index >= 0);
-	ASSERT(leaf->ents[highstale].address ==
-	       cpu_to_be32(XFS_DIR2_NULL_DATAPTR));
+	ASSERT(ents[highstale].address == cpu_to_be32(XFS_DIR2_NULL_DATAPTR));
 
 	/*
 	 * Copy entries down to cover the stale entry and make room for the
 	 * new entry.
 	 */
 	if (highstale - index > 0) {
-		memmove(&leaf->ents[index + 1],
-			&leaf->ents[index],
+		memmove(&ents[index + 1], &ents[index],
 			(highstale - index) * sizeof(xfs_dir2_leaf_entry_t));
 	}
 	*lfloglow = MIN(index, *lfloglow);
 	*lfloghigh = MAX(highstale, *lfloghigh);
-	be16_add_cpu(&leaf->hdr.stale, -1);
-	return &leaf->ents[index];
+	leafhdr->stale--;
+	return &ents[index];
 }
 
 /*
@@ -374,6 +637,8 @@ xfs_dir2_leaf_addname(
 	xfs_trans_t		*tp;		/* transaction pointer */
 	xfs_dir2_db_t		use_block;	/* data block number */
 	struct xfs_dir2_data_free *bf;		/* bestfree table */
+	struct xfs_dir2_leaf_entry *ents;
+	struct xfs_dir3_icleaf_hdr leafhdr;
 
 	trace_xfs_dir2_leaf_addname(args);
 
@@ -381,7 +646,7 @@ xfs_dir2_leaf_addname(
 	tp = args->trans;
 	mp = dp->i_mount;
 
-	error = xfs_dir2_leaf_read(tp, dp, mp->m_dirleafblk, -1, &lbp);
+	error = xfs_dir3_leaf_read(tp, dp, mp->m_dirleafblk, -1, &lbp);
 	if (error)
 		return error;
 
@@ -394,16 +659,19 @@ xfs_dir2_leaf_addname(
 	index = xfs_dir2_leaf_search_hash(args, lbp);
 	leaf = lbp->b_addr;
 	ltp = xfs_dir2_leaf_tail_p(mp, leaf);
+	ents = xfs_dir3_leaf_ents_p(leaf);
+	xfs_dir3_leaf_hdr_from_disk(&leafhdr, leaf);
 	bestsp = xfs_dir2_leaf_bests_p(ltp);
 	length = xfs_dir2_data_entsize(args->namelen);
+
 	/*
 	 * See if there are any entries with the same hash value
 	 * and space in their block for the new entry.
 	 * This is good because it puts multiple same-hash value entries
 	 * in a data block, improving the lookup of those entries.
 	 */
-	for (use_block = -1, lep = &leaf->ents[index];
-	     index < be16_to_cpu(leaf->hdr.count) && be32_to_cpu(lep->hashval) == args->hashval;
+	for (use_block = -1, lep = &ents[index];
+	     index < leafhdr.count && be32_to_cpu(lep->hashval) == args->hashval;
 	     index++, lep++) {
 		if (be32_to_cpu(lep->address) == XFS_DIR2_NULL_DATAPTR)
 			continue;
@@ -436,7 +704,7 @@ xfs_dir2_leaf_addname(
 	 * How many bytes do we need in the leaf block?
 	 */
 	needbytes = 0;
-	if (!leaf->hdr.stale)
+	if (!leafhdr.stale)
 		needbytes += sizeof(xfs_dir2_leaf_entry_t);
 	if (use_block == -1)
 		needbytes += sizeof(xfs_dir2_data_off_t);
@@ -451,16 +719,15 @@ xfs_dir2_leaf_addname(
 	 * If we don't have enough free bytes but we can make enough
 	 * by compacting out stale entries, we'll do that.
 	 */
-	if ((char *)bestsp - (char *)&leaf->ents[be16_to_cpu(leaf->hdr.count)] <
-				needbytes && be16_to_cpu(leaf->hdr.stale) > 1) {
+	if ((char *)bestsp - (char *)&ents[leafhdr.count] < needbytes &&
+	    leafhdr.stale > 1)
 		compact = 1;
-	}
+
 	/*
 	 * Otherwise if we don't have enough free bytes we need to
 	 * convert to node form.
 	 */
-	else if ((char *)bestsp - (char *)&leaf->ents[be16_to_cpu(
-						leaf->hdr.count)] < needbytes) {
+	else if ((char *)bestsp - (char *)&ents[leafhdr.count] < needbytes) {
 		/*
 		 * Just checking or no space reservation, give up.
 		 */
@@ -508,15 +775,15 @@ xfs_dir2_leaf_addname(
 	 * point later.
 	 */
 	if (compact) {
-		xfs_dir2_leaf_compact_x1(lbp, &index, &lowstale, &highstale,
-			&lfloglow, &lfloghigh);
+		xfs_dir3_leaf_compact_x1(&leafhdr, ents, &index, &lowstale,
+			&highstale, &lfloglow, &lfloghigh);
 	}
 	/*
 	 * There are stale entries, so we'll need log-low and log-high
 	 * impossibly bad values later.
 	 */
-	else if (be16_to_cpu(leaf->hdr.stale)) {
-		lfloglow = be16_to_cpu(leaf->hdr.count);
+	else if (leafhdr.stale) {
+		lfloglow = leafhdr.count;
 		lfloghigh = -1;
 	}
 	/*
@@ -548,14 +815,14 @@ xfs_dir2_leaf_addname(
 			memmove(&bestsp[0], &bestsp[1],
 				be32_to_cpu(ltp->bestcount) * sizeof(bestsp[0]));
 			be32_add_cpu(&ltp->bestcount, 1);
-			xfs_dir2_leaf_log_tail(tp, lbp);
-			xfs_dir2_leaf_log_bests(tp, lbp, 0, be32_to_cpu(ltp->bestcount) - 1);
+			xfs_dir3_leaf_log_tail(tp, lbp);
+			xfs_dir3_leaf_log_bests(tp, lbp, 0, be32_to_cpu(ltp->bestcount) - 1);
 		}
 		/*
 		 * If we're filling in a previously empty block just log it.
 		 */
 		else
-			xfs_dir2_leaf_log_bests(tp, lbp, use_block, use_block);
+			xfs_dir3_leaf_log_bests(tp, lbp, use_block, use_block);
 		hdr = dbp->b_addr;
 		bf = xfs_dir3_data_bestfree_p(hdr);
 		bestsp[use_block] = bf[0].length;
@@ -616,10 +883,10 @@ xfs_dir2_leaf_addname(
 	if (be16_to_cpu(bestsp[use_block]) != be16_to_cpu(bf[0].length)) {
 		bestsp[use_block] = bf[0].length;
 		if (!grown)
-			xfs_dir2_leaf_log_bests(tp, lbp, use_block, use_block);
+			xfs_dir3_leaf_log_bests(tp, lbp, use_block, use_block);
 	}
 
-	lep = xfs_dir2_leaf_find_entry(leaf, index, compact, lowstale,
+	lep = xfs_dir3_leaf_find_entry(&leafhdr, ents, index, compact, lowstale,
 				       highstale, &lfloglow, &lfloghigh);
 
 	/*
@@ -631,82 +898,40 @@ xfs_dir2_leaf_addname(
 	/*
 	 * Log the leaf fields and give up the buffers.
 	 */
-	xfs_dir2_leaf_log_header(tp, lbp);
-	xfs_dir2_leaf_log_ents(tp, lbp, lfloglow, lfloghigh);
-	xfs_dir2_leaf_check(dp, lbp);
+	xfs_dir3_leaf_hdr_to_disk(leaf, &leafhdr);
+	xfs_dir3_leaf_log_header(tp, lbp);
+	xfs_dir3_leaf_log_ents(tp, lbp, lfloglow, lfloghigh);
+	xfs_dir3_leaf_check(mp, lbp);
 	xfs_dir3_data_check(dp, dbp);
 	return 0;
 }
 
-#ifdef DEBUG
-/*
- * Check the internal consistency of a leaf1 block.
- * Pop an assert if something is wrong.
- */
-STATIC void
-xfs_dir2_leaf_check(
-	struct xfs_inode	*dp,		/* incore directory inode */
-	struct xfs_buf		*bp)		/* leaf's buffer */
-{
-	int			i;		/* leaf index */
-	xfs_dir2_leaf_t		*leaf;		/* leaf structure */
-	xfs_dir2_leaf_tail_t	*ltp;		/* leaf tail pointer */
-	xfs_mount_t		*mp;		/* filesystem mount point */
-	int			stale;		/* count of stale leaves */
-
-	leaf = bp->b_addr;
-	mp = dp->i_mount;
-	ASSERT(leaf->hdr.info.magic == cpu_to_be16(XFS_DIR2_LEAF1_MAGIC));
-	/*
-	 * This value is not restrictive enough.
-	 * Should factor in the size of the bests table as well.
-	 * We can deduce a value for that from di_size.
-	 */
-	ASSERT(be16_to_cpu(leaf->hdr.count) <= xfs_dir2_max_leaf_ents(mp));
-	ltp = xfs_dir2_leaf_tail_p(mp, leaf);
-	/*
-	 * Leaves and bests don't overlap.
-	 */
-	ASSERT((char *)&leaf->ents[be16_to_cpu(leaf->hdr.count)] <=
-	       (char *)xfs_dir2_leaf_bests_p(ltp));
-	/*
-	 * Check hash value order, count stale entries.
-	 */
-	for (i = stale = 0; i < be16_to_cpu(leaf->hdr.count); i++) {
-		if (i + 1 < be16_to_cpu(leaf->hdr.count))
-			ASSERT(be32_to_cpu(leaf->ents[i].hashval) <=
-			       be32_to_cpu(leaf->ents[i + 1].hashval));
-		if (leaf->ents[i].address == cpu_to_be32(XFS_DIR2_NULL_DATAPTR))
-			stale++;
-	}
-	ASSERT(be16_to_cpu(leaf->hdr.stale) == stale);
-}
-#endif	/* DEBUG */
-
 /*
  * Compact out any stale entries in the leaf.
  * Log the header and changed leaf entries, if any.
  */
 void
-xfs_dir2_leaf_compact(
+xfs_dir3_leaf_compact(
 	xfs_da_args_t	*args,		/* operation arguments */
+	struct xfs_dir3_icleaf_hdr *leafhdr,
 	struct xfs_buf	*bp)		/* leaf buffer */
 {
 	int		from;		/* source leaf index */
 	xfs_dir2_leaf_t	*leaf;		/* leaf structure */
 	int		loglow;		/* first leaf entry to log */
 	int		to;		/* target leaf index */
+	struct xfs_dir2_leaf_entry *ents;
 
 	leaf = bp->b_addr;
-	if (!leaf->hdr.stale) {
+	if (!leafhdr->stale)
 		return;
-	}
+
 	/*
 	 * Compress out the stale entries in place.
 	 */
-	for (from = to = 0, loglow = -1; from < be16_to_cpu(leaf->hdr.count); from++) {
-		if (leaf->ents[from].address ==
-		    cpu_to_be32(XFS_DIR2_NULL_DATAPTR))
+	ents = xfs_dir3_leaf_ents_p(leaf);
+	for (from = to = 0, loglow = -1; from < leafhdr->count; from++) {
+		if (ents[from].address == cpu_to_be32(XFS_DIR2_NULL_DATAPTR))
 			continue;
 		/*
 		 * Only actually copy the entries that are different.
@@ -714,19 +939,21 @@ xfs_dir2_leaf_compact(
 		if (from > to) {
 			if (loglow == -1)
 				loglow = to;
-			leaf->ents[to] = leaf->ents[from];
+			ents[to] = ents[from];
 		}
 		to++;
 	}
 	/*
 	 * Update and log the header, log the leaf entries.
 	 */
-	ASSERT(be16_to_cpu(leaf->hdr.stale) == from - to);
-	be16_add_cpu(&leaf->hdr.count, -(be16_to_cpu(leaf->hdr.stale)));
-	leaf->hdr.stale = 0;
-	xfs_dir2_leaf_log_header(args->trans, bp);
+	ASSERT(leafhdr->stale == from - to);
+	leafhdr->count -= leafhdr->stale;
+	leafhdr->stale = 0;
+
+	xfs_dir3_leaf_hdr_to_disk(leaf, leafhdr);
+	xfs_dir3_leaf_log_header(args->trans, bp);
 	if (loglow != -1)
-		xfs_dir2_leaf_log_ents(args->trans, bp, loglow, to - 1);
+		xfs_dir3_leaf_log_ents(args->trans, bp, loglow, to - 1);
 }
 
 /*
@@ -738,8 +965,9 @@ xfs_dir2_leaf_compact(
  * and leaf logging indices.
  */
 void
-xfs_dir2_leaf_compact_x1(
-	struct xfs_buf	*bp,		/* leaf buffer */
+xfs_dir3_leaf_compact_x1(
+	struct xfs_dir3_icleaf_hdr *leafhdr,
+	struct xfs_dir2_leaf_entry *ents,
 	int		*indexp,	/* insertion index */
 	int		*lowstalep,	/* out: stale entry before us */
 	int		*highstalep,	/* out: stale entry after us */
@@ -750,22 +978,20 @@ xfs_dir2_leaf_compact_x1(
 	int		highstale;	/* stale entry at/after index */
 	int		index;		/* insertion index */
 	int		keepstale;	/* source index of kept stale */
-	xfs_dir2_leaf_t	*leaf;		/* leaf structure */
 	int		lowstale;	/* stale entry before index */
 	int		newindex=0;	/* new insertion index */
 	int		to;		/* destination copy index */
 
-	leaf = bp->b_addr;
-	ASSERT(be16_to_cpu(leaf->hdr.stale) > 1);
+	ASSERT(leafhdr->stale > 1);
 	index = *indexp;
 
-	xfs_dir2_leaf_find_stale(leaf, index, &lowstale, &highstale);
+	xfs_dir3_leaf_find_stale(leafhdr, ents, index, &lowstale, &highstale);
 
 	/*
 	 * Pick the better of lowstale and highstale.
 	 */
 	if (lowstale >= 0 &&
-	    (highstale == be16_to_cpu(leaf->hdr.count) ||
+	    (highstale == leafhdr->count ||
 	     index - lowstale <= highstale - index))
 		keepstale = lowstale;
 	else
@@ -774,15 +1000,14 @@ xfs_dir2_leaf_compact_x1(
 	 * Copy the entries in place, removing all the stale entries
 	 * except keepstale.
 	 */
-	for (from = to = 0; from < be16_to_cpu(leaf->hdr.count); from++) {
+	for (from = to = 0; from < leafhdr->count; from++) {
 		/*
 		 * Notice the new value of index.
 		 */
 		if (index == from)
 			newindex = to;
 		if (from != keepstale &&
-		    leaf->ents[from].address ==
-		    cpu_to_be32(XFS_DIR2_NULL_DATAPTR)) {
+		    ents[from].address == cpu_to_be32(XFS_DIR2_NULL_DATAPTR)) {
 			if (from == to)
 				*lowlogp = to;
 			continue;
@@ -796,7 +1021,7 @@ xfs_dir2_leaf_compact_x1(
 		 * Copy only the entries that have moved.
 		 */
 		if (from > to)
-			leaf->ents[to] = leaf->ents[from];
+			ents[to] = ents[from];
 		to++;
 	}
 	ASSERT(from > to);
@@ -810,8 +1035,8 @@ xfs_dir2_leaf_compact_x1(
 	/*
 	 * Adjust the leaf header values.
 	 */
-	be16_add_cpu(&leaf->hdr.count, -(from - to));
-	leaf->hdr.stale = cpu_to_be16(1);
+	leafhdr->count -= from - to;
+	leafhdr->stale = 1;
 	/*
 	 * Remember the low/high stale value only in the "right"
 	 * direction.
@@ -819,75 +1044,18 @@ xfs_dir2_leaf_compact_x1(
 	if (lowstale >= newindex)
 		lowstale = -1;
 	else
-		highstale = be16_to_cpu(leaf->hdr.count);
-	*highlogp = be16_to_cpu(leaf->hdr.count) - 1;
+		highstale = leafhdr->count;
+	*highlogp = leafhdr->count - 1;
 	*lowstalep = lowstale;
 	*highstalep = highstale;
 }
 
-/*
- * Initialize a new leaf block, leaf1 or leafn magic accepted.
- */
-int
-xfs_dir2_leaf_init(
-	xfs_da_args_t		*args,		/* operation arguments */
-	xfs_dir2_db_t		bno,		/* directory block number */
-	struct xfs_buf		**bpp,		/* out: leaf buffer */
-	int			magic)		/* magic number for block */
-{
-	struct xfs_buf		*bp;		/* leaf buffer */
-	xfs_inode_t		*dp;		/* incore directory inode */
-	int			error;		/* error return code */
-	xfs_dir2_leaf_t		*leaf;		/* leaf structure */
-	xfs_dir2_leaf_tail_t	*ltp;		/* leaf tail structure */
-	xfs_mount_t		*mp;		/* filesystem mount point */
-	xfs_trans_t		*tp;		/* transaction pointer */
-
-	dp = args->dp;
-	ASSERT(dp != NULL);
-	tp = args->trans;
-	mp = dp->i_mount;
-	ASSERT(bno >= XFS_DIR2_LEAF_FIRSTDB(mp) &&
-	       bno < XFS_DIR2_FREE_FIRSTDB(mp));
-	/*
-	 * Get the buffer for the block.
-	 */
-	error = xfs_da_get_buf(tp, dp, xfs_dir2_db_to_da(mp, bno), -1, &bp,
-			       XFS_DATA_FORK);
-	if (error)
-		return error;
-
-	/*
-	 * Initialize the header.
-	 */
-	leaf = bp->b_addr;
-	leaf->hdr.info.magic = cpu_to_be16(magic);
-	leaf->hdr.info.forw = 0;
-	leaf->hdr.info.back = 0;
-	leaf->hdr.count = 0;
-	leaf->hdr.stale = 0;
-	xfs_dir2_leaf_log_header(tp, bp);
-	/*
-	 * If it's a leaf-format directory initialize the tail.
-	 * In this case our caller has the real bests table to copy into
-	 * the block.
-	 */
-	if (magic == XFS_DIR2_LEAF1_MAGIC) {
-		bp->b_ops = &xfs_dir2_leaf1_buf_ops;
-		ltp = xfs_dir2_leaf_tail_p(mp, leaf);
-		ltp->bestcount = 0;
-		xfs_dir2_leaf_log_tail(tp, bp);
-	} else
-		bp->b_ops = &xfs_dir2_leafn_buf_ops;
-	*bpp = bp;
-	return 0;
-}
 
 /*
  * Log the bests entries indicated from a leaf1 block.
  */
 static void
-xfs_dir2_leaf_log_bests(
+xfs_dir3_leaf_log_bests(
 	xfs_trans_t		*tp,		/* transaction pointer */
 	struct xfs_buf		*bp,		/* leaf buffer */
 	int			first,		/* first entry to log */
@@ -895,11 +1063,12 @@ xfs_dir2_leaf_log_bests(
 {
 	__be16			*firstb;	/* pointer to first entry */
 	__be16			*lastb;		/* pointer to last entry */
-	xfs_dir2_leaf_t		*leaf;		/* leaf structure */
+	struct xfs_dir2_leaf	*leaf = bp->b_addr;
 	xfs_dir2_leaf_tail_t	*ltp;		/* leaf tail structure */
 
-	leaf = bp->b_addr;
-	ASSERT(leaf->hdr.info.magic == cpu_to_be16(XFS_DIR2_LEAF1_MAGIC));
+	ASSERT(leaf->hdr.info.magic == cpu_to_be16(XFS_DIR2_LEAF1_MAGIC) ||
+	       leaf->hdr.info.magic == cpu_to_be16(XFS_DIR3_LEAF1_MAGIC));
+
 	ltp = xfs_dir2_leaf_tail_p(tp->t_mountp, leaf);
 	firstb = xfs_dir2_leaf_bests_p(ltp) + first;
 	lastb = xfs_dir2_leaf_bests_p(ltp) + last;
@@ -911,7 +1080,7 @@ xfs_dir2_leaf_log_bests(
  * Log the leaf entries indicated from a leaf1 or leafn block.
  */
 void
-xfs_dir2_leaf_log_ents(
+xfs_dir3_leaf_log_ents(
 	xfs_trans_t		*tp,		/* transaction pointer */
 	struct xfs_buf		*bp,		/* leaf buffer */
 	int			first,		/* first entry to log */
@@ -919,13 +1088,17 @@ xfs_dir2_leaf_log_ents(
 {
 	xfs_dir2_leaf_entry_t	*firstlep;	/* pointer to first entry */
 	xfs_dir2_leaf_entry_t	*lastlep;	/* pointer to last entry */
-	xfs_dir2_leaf_t		*leaf;		/* leaf structure */
+	struct xfs_dir2_leaf	*leaf = bp->b_addr;
+	struct xfs_dir2_leaf_entry *ents;
 
-	leaf = bp->b_addr;
 	ASSERT(leaf->hdr.info.magic == cpu_to_be16(XFS_DIR2_LEAF1_MAGIC) ||
-	       leaf->hdr.info.magic == cpu_to_be16(XFS_DIR2_LEAFN_MAGIC));
-	firstlep = &leaf->ents[first];
-	lastlep = &leaf->ents[last];
+	       leaf->hdr.info.magic == cpu_to_be16(XFS_DIR3_LEAF1_MAGIC) ||
+	       leaf->hdr.info.magic == cpu_to_be16(XFS_DIR2_LEAFN_MAGIC) ||
+	       leaf->hdr.info.magic == cpu_to_be16(XFS_DIR3_LEAFN_MAGIC));
+
+	ents = xfs_dir3_leaf_ents_p(leaf);
+	firstlep = &ents[first];
+	lastlep = &ents[last];
 	xfs_trans_log_buf(tp, bp, (uint)((char *)firstlep - (char *)leaf),
 		(uint)((char *)lastlep - (char *)leaf + sizeof(*lastlep) - 1));
 }
@@ -934,34 +1107,38 @@ xfs_dir2_leaf_log_ents(
  * Log the header of the leaf1 or leafn block.
  */
 void
-xfs_dir2_leaf_log_header(
+xfs_dir3_leaf_log_header(
 	struct xfs_trans	*tp,
 	struct xfs_buf		*bp)
 {
-	xfs_dir2_leaf_t		*leaf;		/* leaf structure */
+	struct xfs_dir2_leaf	*leaf = bp->b_addr;
 
-	leaf = bp->b_addr;
 	ASSERT(leaf->hdr.info.magic == cpu_to_be16(XFS_DIR2_LEAF1_MAGIC) ||
-	       leaf->hdr.info.magic == cpu_to_be16(XFS_DIR2_LEAFN_MAGIC));
+	       leaf->hdr.info.magic == cpu_to_be16(XFS_DIR3_LEAF1_MAGIC) ||
+	       leaf->hdr.info.magic == cpu_to_be16(XFS_DIR2_LEAFN_MAGIC) ||
+	       leaf->hdr.info.magic == cpu_to_be16(XFS_DIR3_LEAFN_MAGIC));
+
 	xfs_trans_log_buf(tp, bp, (uint)((char *)&leaf->hdr - (char *)leaf),
-		(uint)(sizeof(leaf->hdr) - 1));
+			  xfs_dir3_leaf_hdr_size(leaf) - 1);
 }
 
 /*
  * Log the tail of the leaf1 block.
  */
 STATIC void
-xfs_dir2_leaf_log_tail(
+xfs_dir3_leaf_log_tail(
 	struct xfs_trans	*tp,
 	struct xfs_buf		*bp)
 {
-	xfs_dir2_leaf_t		*leaf;		/* leaf structure */
+	struct xfs_dir2_leaf	*leaf = bp->b_addr;
 	xfs_dir2_leaf_tail_t	*ltp;		/* leaf tail structure */
-	xfs_mount_t		*mp;		/* filesystem mount point */
+	struct xfs_mount	*mp = tp->t_mountp;
+
+	ASSERT(leaf->hdr.info.magic == cpu_to_be16(XFS_DIR2_LEAF1_MAGIC) ||
+	       leaf->hdr.info.magic == cpu_to_be16(XFS_DIR3_LEAF1_MAGIC) ||
+	       leaf->hdr.info.magic == cpu_to_be16(XFS_DIR2_LEAFN_MAGIC) ||
+	       leaf->hdr.info.magic == cpu_to_be16(XFS_DIR3_LEAFN_MAGIC));
 
-	mp = tp->t_mountp;
-	leaf = bp->b_addr;
-	ASSERT(leaf->hdr.info.magic == cpu_to_be16(XFS_DIR2_LEAF1_MAGIC));
 	ltp = xfs_dir2_leaf_tail_p(mp, leaf);
 	xfs_trans_log_buf(tp, bp, (uint)((char *)ltp - (char *)leaf),
 		(uint)(mp->m_dirblksize - 1));
@@ -985,6 +1162,7 @@ xfs_dir2_leaf_lookup(
 	xfs_dir2_leaf_t		*leaf;		/* leaf structure */
 	xfs_dir2_leaf_entry_t	*lep;		/* leaf entry */
 	xfs_trans_t		*tp;		/* transaction pointer */
+	struct xfs_dir2_leaf_entry *ents;
 
 	trace_xfs_dir2_leaf_lookup(args);
 
@@ -996,12 +1174,14 @@ xfs_dir2_leaf_lookup(
 	}
 	tp = args->trans;
 	dp = args->dp;
-	xfs_dir2_leaf_check(dp, lbp);
+	xfs_dir3_leaf_check(dp->i_mount, lbp);
 	leaf = lbp->b_addr;
+	ents = xfs_dir3_leaf_ents_p(leaf);
 	/*
 	 * Get to the leaf entry and contained data entry address.
 	 */
-	lep = &leaf->ents[index];
+	lep = &ents[index];
+
 	/*
 	 * Point to the data entry.
 	 */
@@ -1045,18 +1225,23 @@ xfs_dir2_leaf_lookup_int(
 	xfs_trans_t		*tp;		/* transaction pointer */
 	xfs_dir2_db_t		cidb = -1;	/* case match data block no. */
 	enum xfs_dacmp		cmp;		/* name compare result */
+	struct xfs_dir2_leaf_entry *ents;
+	struct xfs_dir3_icleaf_hdr leafhdr;
 
 	dp = args->dp;
 	tp = args->trans;
 	mp = dp->i_mount;
 
-	error = xfs_dir2_leaf_read(tp, dp, mp->m_dirleafblk, -1, &lbp);
+	error = xfs_dir3_leaf_read(tp, dp, mp->m_dirleafblk, -1, &lbp);
 	if (error)
 		return error;
 
 	*lbpp = lbp;
 	leaf = lbp->b_addr;
-	xfs_dir2_leaf_check(dp, lbp);
+	xfs_dir3_leaf_check(mp, lbp);
+	ents = xfs_dir3_leaf_ents_p(leaf);
+	xfs_dir3_leaf_hdr_from_disk(&leafhdr, leaf);
+
 	/*
 	 * Look for the first leaf entry with our hash value.
 	 */
@@ -1065,9 +1250,9 @@ xfs_dir2_leaf_lookup_int(
 	 * Loop over all the entries with the right hash value
 	 * looking to match the name.
 	 */
-	for (lep = &leaf->ents[index]; index < be16_to_cpu(leaf->hdr.count) &&
-				be32_to_cpu(lep->hashval) == args->hashval;
-				lep++, index++) {
+	for (lep = &ents[index];
+	     index < leafhdr.count && be32_to_cpu(lep->hashval) == args->hashval;
+	     lep++, index++) {
 		/*
 		 * Skip over stale leaf entries.
 		 */
@@ -1172,6 +1357,8 @@ xfs_dir2_leaf_removename(
 	xfs_dir2_data_off_t	oldbest;	/* old value of best free */
 	xfs_trans_t		*tp;		/* transaction pointer */
 	struct xfs_dir2_data_free *bf;		/* bestfree table */
+	struct xfs_dir2_leaf_entry *ents;
+	struct xfs_dir3_icleaf_hdr leafhdr;
 
 	trace_xfs_dir2_leaf_removename(args);
 
@@ -1186,12 +1373,14 @@ xfs_dir2_leaf_removename(
 	mp = dp->i_mount;
 	leaf = lbp->b_addr;
 	hdr = dbp->b_addr;
-	bf = xfs_dir3_data_bestfree_p(hdr);
 	xfs_dir3_data_check(dp, dbp);
+	bf = xfs_dir3_data_bestfree_p(hdr);
+	xfs_dir3_leaf_hdr_from_disk(&leafhdr, leaf);
+	ents = xfs_dir3_leaf_ents_p(leaf);
 	/*
 	 * Point to the leaf entry, use that to point to the data entry.
 	 */
-	lep = &leaf->ents[index];
+	lep = &ents[index];
 	db = xfs_dir2_dataptr_to_db(mp, be32_to_cpu(lep->address));
 	dep = (xfs_dir2_data_entry_t *)
 	      ((char *)hdr + xfs_dir2_dataptr_to_off(mp, be32_to_cpu(lep->address)));
@@ -1209,10 +1398,13 @@ xfs_dir2_leaf_removename(
 	/*
 	 * We just mark the leaf entry stale by putting a null in it.
 	 */
-	be16_add_cpu(&leaf->hdr.stale, 1);
-	xfs_dir2_leaf_log_header(tp, lbp);
+	leafhdr.stale++;
+	xfs_dir3_leaf_hdr_to_disk(leaf, &leafhdr);
+	xfs_dir3_leaf_log_header(tp, lbp);
+
 	lep->address = cpu_to_be32(XFS_DIR2_NULL_DATAPTR);
-	xfs_dir2_leaf_log_ents(tp, lbp, index, index);
+	xfs_dir3_leaf_log_ents(tp, lbp, index, index);
+
 	/*
 	 * Scan the freespace in the data block again if necessary,
 	 * log the data block header if necessary.
@@ -1227,7 +1419,7 @@ xfs_dir2_leaf_removename(
 	 */
 	if (be16_to_cpu(bf[0].length) != oldbest) {
 		bestsp[db] = bf[0].length;
-		xfs_dir2_leaf_log_bests(tp, lbp, db, db);
+		xfs_dir3_leaf_log_bests(tp, lbp, db, db);
 	}
 	xfs_dir3_data_check(dp, dbp);
 	/*
@@ -1245,7 +1437,7 @@ xfs_dir2_leaf_removename(
 			 */
 			if (error == ENOSPC && args->total == 0)
 				error = 0;
-			xfs_dir2_leaf_check(dp, lbp);
+			xfs_dir3_leaf_check(mp, lbp);
 			return error;
 		}
 		dbp = NULL;
@@ -1268,8 +1460,8 @@ xfs_dir2_leaf_removename(
 			memmove(&bestsp[db - i], bestsp,
 				(be32_to_cpu(ltp->bestcount) - (db - i)) * sizeof(*bestsp));
 			be32_add_cpu(&ltp->bestcount, -(db - i));
-			xfs_dir2_leaf_log_tail(tp, lbp);
-			xfs_dir2_leaf_log_bests(tp, lbp, 0, be32_to_cpu(ltp->bestcount) - 1);
+			xfs_dir3_leaf_log_tail(tp, lbp);
+			xfs_dir3_leaf_log_bests(tp, lbp, 0, be32_to_cpu(ltp->bestcount) - 1);
 		} else
 			bestsp[db] = cpu_to_be16(NULLDATAOFF);
 	}
@@ -1279,7 +1471,7 @@ xfs_dir2_leaf_removename(
 	else if (db != mp->m_dirdatablk)
 		dbp = NULL;
 
-	xfs_dir2_leaf_check(dp, lbp);
+	xfs_dir3_leaf_check(mp, lbp);
 	/*
 	 * See if we can convert to block form.
 	 */
@@ -1302,6 +1494,7 @@ xfs_dir2_leaf_replace(
 	xfs_dir2_leaf_t		*leaf;		/* leaf structure */
 	xfs_dir2_leaf_entry_t	*lep;		/* leaf entry */
 	xfs_trans_t		*tp;		/* transaction pointer */
+	struct xfs_dir2_leaf_entry *ents;
 
 	trace_xfs_dir2_leaf_replace(args);
 
@@ -1313,10 +1506,11 @@ xfs_dir2_leaf_replace(
 	}
 	dp = args->dp;
 	leaf = lbp->b_addr;
+	ents = xfs_dir3_leaf_ents_p(leaf);
 	/*
 	 * Point to the leaf entry, get data address from it.
 	 */
-	lep = &leaf->ents[index];
+	lep = &ents[index];
 	/*
 	 * Point to the data entry.
 	 */
@@ -1330,7 +1524,7 @@ xfs_dir2_leaf_replace(
 	dep->inumber = cpu_to_be64(args->inumber);
 	tp = args->trans;
 	xfs_dir2_data_log_entry(tp, dbp, dep);
-	xfs_dir2_leaf_check(dp, lbp);
+	xfs_dir3_leaf_check(dp->i_mount, lbp);
 	xfs_trans_brelse(tp, lbp);
 	return 0;
 }
@@ -1352,17 +1546,22 @@ xfs_dir2_leaf_search_hash(
 	xfs_dir2_leaf_t		*leaf;		/* leaf structure */
 	xfs_dir2_leaf_entry_t	*lep;		/* leaf entry */
 	int			mid=0;		/* current leaf index */
+	struct xfs_dir2_leaf_entry *ents;
+	struct xfs_dir3_icleaf_hdr leafhdr;
 
 	leaf = lbp->b_addr;
+	ents = xfs_dir3_leaf_ents_p(leaf);
+	xfs_dir3_leaf_hdr_from_disk(&leafhdr, leaf);
+
 #ifndef __KERNEL__
-	if (!leaf->hdr.count)
+	if (!leafhdr.count)
 		return 0;
 #endif
 	/*
 	 * Note, the table cannot be empty, so we have to go through the loop.
 	 * Binary search the leaf entries looking for our hash value.
 	 */
-	for (lep = leaf->ents, low = 0, high = be16_to_cpu(leaf->hdr.count) - 1,
+	for (lep = ents, low = 0, high = leafhdr.count - 1,
 		hashwant = args->hashval;
 	     low <= high; ) {
 		mid = (low + high) >> 1;
@@ -1448,23 +1647,29 @@ xfs_dir2_leaf_trim_data(
 	bestsp = xfs_dir2_leaf_bests_p(ltp);
 	be32_add_cpu(&ltp->bestcount, -1);
 	memmove(&bestsp[1], &bestsp[0], be32_to_cpu(ltp->bestcount) * sizeof(*bestsp));
-	xfs_dir2_leaf_log_tail(tp, lbp);
-	xfs_dir2_leaf_log_bests(tp, lbp, 0, be32_to_cpu(ltp->bestcount) - 1);
+	xfs_dir3_leaf_log_tail(tp, lbp);
+	xfs_dir3_leaf_log_bests(tp, lbp, 0, be32_to_cpu(ltp->bestcount) - 1);
 	return 0;
 }
 
 static inline size_t
-xfs_dir2_leaf_size(
-	struct xfs_dir2_leaf_hdr	*hdr,
+xfs_dir3_leaf_size(
+	struct xfs_dir3_icleaf_hdr	*hdr,
 	int				counts)
 {
-	int			entries;
+	int	entries;
+	int	hdrsize;
+
+	entries = hdr->count - hdr->stale;
+	if (hdr->magic == XFS_DIR2_LEAF1_MAGIC ||
+	    hdr->magic == XFS_DIR2_LEAFN_MAGIC)
+		hdrsize = sizeof(struct xfs_dir2_leaf_hdr);
+	else
+		hdrsize = sizeof(struct xfs_dir3_leaf_hdr);
 
-	entries = be16_to_cpu(hdr->count) - be16_to_cpu(hdr->stale);
-	return sizeof(xfs_dir2_leaf_hdr_t) +
-	    entries * sizeof(xfs_dir2_leaf_entry_t) +
-	    counts * sizeof(xfs_dir2_data_off_t) +
-	    sizeof(xfs_dir2_leaf_tail_t);
+	return hdrsize + entries * sizeof(xfs_dir2_leaf_entry_t)
+	               + counts * sizeof(xfs_dir2_data_off_t)
+		       + sizeof(xfs_dir2_leaf_tail_t);
 }
 
 /*
@@ -1488,6 +1693,7 @@ xfs_dir2_node_to_leaf(
 	xfs_mount_t		*mp;		/* filesystem mount point */
 	int			rval;		/* successful free trim? */
 	xfs_trans_t		*tp;		/* transaction pointer */
+	struct xfs_dir3_icleaf_hdr leafhdr;
 	struct xfs_dir3_icfree_hdr freehdr;
 
 	/*
@@ -1538,7 +1744,11 @@ xfs_dir2_node_to_leaf(
 		return 0;
 	lbp = state->path.blk[0].bp;
 	leaf = lbp->b_addr;
-	ASSERT(leaf->hdr.info.magic == cpu_to_be16(XFS_DIR2_LEAFN_MAGIC));
+	xfs_dir3_leaf_hdr_from_disk(&leafhdr, leaf);
+
+	ASSERT(leafhdr.magic == XFS_DIR2_LEAFN_MAGIC ||
+	       leafhdr.magic == XFS_DIR3_LEAFN_MAGIC);
+
 	/*
 	 * Read the freespace block.
 	 */
@@ -1554,36 +1764,40 @@ xfs_dir2_node_to_leaf(
 	 * Now see if the leafn and free data will fit in a leaf1.
 	 * If not, release the buffer and give up.
 	 */
-	if (xfs_dir2_leaf_size(&leaf->hdr, freehdr.nvalid) > mp->m_dirblksize) {
+	if (xfs_dir3_leaf_size(&leafhdr, freehdr.nvalid) > mp->m_dirblksize) {
 		xfs_trans_brelse(tp, fbp);
 		return 0;
 	}
 
 	/*
 	 * If the leaf has any stale entries in it, compress them out.
-	 * The compact routine will log the header.
 	 */
-	if (be16_to_cpu(leaf->hdr.stale))
-		xfs_dir2_leaf_compact(args, lbp);
-	else
-		xfs_dir2_leaf_log_header(tp, lbp);
+	if (leafhdr.stale)
+		xfs_dir3_leaf_compact(args, &leafhdr, lbp);
 
-	lbp->b_ops = &xfs_dir2_leaf1_buf_ops;
-	leaf->hdr.info.magic = cpu_to_be16(XFS_DIR2_LEAF1_MAGIC);
+	lbp->b_ops = &xfs_dir3_leaf1_buf_ops;
+	leafhdr.magic = (leafhdr.magic == XFS_DIR2_LEAFN_MAGIC)
+					? XFS_DIR2_LEAF1_MAGIC
+					: XFS_DIR3_LEAF1_MAGIC;
 
 	/*
 	 * Set up the leaf tail from the freespace block.
 	 */
 	ltp = xfs_dir2_leaf_tail_p(mp, leaf);
 	ltp->bestcount = cpu_to_be32(freehdr.nvalid);
+
 	/*
 	 * Set up the leaf bests table.
 	 */
 	memcpy(xfs_dir2_leaf_bests_p(ltp), xfs_dir3_free_bests_p(mp, free),
 		freehdr.nvalid * sizeof(xfs_dir2_data_off_t));
-	xfs_dir2_leaf_log_bests(tp, lbp, 0, be32_to_cpu(ltp->bestcount) - 1);
-	xfs_dir2_leaf_log_tail(tp, lbp);
-	xfs_dir2_leaf_check(dp, lbp);
+
+	xfs_dir3_leaf_hdr_to_disk(leaf, &leafhdr);
+	xfs_dir3_leaf_log_header(tp, lbp);
+	xfs_dir3_leaf_log_bests(tp, lbp, 0, be32_to_cpu(ltp->bestcount) - 1);
+	xfs_dir3_leaf_log_tail(tp, lbp);
+	xfs_dir3_leaf_check(mp, lbp);
+
 	/*
 	 * Get rid of the freespace block.
 	 */
diff --git a/libxfs/xfs_dir2_node.c b/libxfs/xfs_dir2_node.c
index f87a245..9b93816 100644
--- a/libxfs/xfs_dir2_node.c
+++ b/libxfs/xfs_dir2_node.c
@@ -24,14 +24,6 @@
  */
 static int xfs_dir2_leafn_add(struct xfs_buf *bp, xfs_da_args_t *args,
 			      int index);
-#ifdef DEBUG
-static void xfs_dir2_leafn_check(struct xfs_inode *dp, struct xfs_buf *bp);
-#else
-#define	xfs_dir2_leafn_check(dp, bp)
-#endif
-static void xfs_dir2_leafn_moveents(xfs_da_args_t *args, struct xfs_buf *bp_s,
-				    int start_s, struct xfs_buf *bp_d,
-				    int start_d, int count);
 static void xfs_dir2_leafn_rebalance(xfs_da_state_t *state,
 				     xfs_da_state_blk_t *blk1,
 				     xfs_da_state_blk_t *blk2);
@@ -41,6 +33,39 @@ static int xfs_dir2_leafn_remove(xfs_da_args_t *args, struct xfs_buf *bp,
 static int xfs_dir2_node_addname_int(xfs_da_args_t *args,
 				     xfs_da_state_blk_t *fblk);
 
+/*
+ * Check internal consistency of a leafn block.
+ */
+#ifdef DEBUG
+#define	xfs_dir3_leaf_check(mp, bp) \
+do { \
+	if (!xfs_dir3_leafn_check((mp), (bp))) \
+		ASSERT(0); \
+} while (0);
+
+static bool
+xfs_dir3_leafn_check(
+	struct xfs_mount	*mp,
+	struct xfs_buf		*bp)
+{
+	struct xfs_dir2_leaf	*leaf = bp->b_addr;
+	struct xfs_dir3_icleaf_hdr leafhdr;
+
+	xfs_dir3_leaf_hdr_from_disk(&leafhdr, leaf);
+
+	if (leafhdr.magic == XFS_DIR3_LEAFN_MAGIC) {
+		struct xfs_dir3_leaf_hdr *leaf3 = bp->b_addr;
+		if (be64_to_cpu(leaf3->info.blkno) != bp->b_bn)
+			return false;
+	} else if (leafhdr.magic != XFS_DIR2_LEAFN_MAGIC)
+		return false;
+
+	return xfs_dir3_leaf_check_int(mp, &leafhdr, leaf);
+}
+#else
+#define	xfs_dir3_leaf_check(mp, bp)
+#endif
+
 static bool
 xfs_dir3_free_verify(
 	struct xfs_buf		*bp)
@@ -344,11 +369,19 @@ xfs_dir2_leaf_to_node(
 	xfs_dir2_free_log_bests(tp, fbp, 0, freehdr.nvalid - 1);
 	xfs_dir2_free_log_header(tp, fbp);
 
-	/* convert the leaf to a leafnode */
-	leaf->hdr.info.magic = cpu_to_be16(XFS_DIR2_LEAFN_MAGIC);
-	lbp->b_ops = &xfs_dir2_leafn_buf_ops;
-	xfs_dir2_leaf_log_header(tp, lbp);
-	xfs_dir2_leafn_check(dp, lbp);
+	/*
+	 * Converting the leaf to a leafnode is just a matter of changing the
+	 * magic number and the ops. Do the change directly to the buffer as
+	 * it's less work (and less code) than decoding the header to host
+	 * format and back again.
+	 */
+	if (leaf->hdr.info.magic == cpu_to_be16(XFS_DIR2_LEAF1_MAGIC))
+		leaf->hdr.info.magic = cpu_to_be16(XFS_DIR2_LEAFN_MAGIC);
+	else
+		leaf->hdr.info.magic = cpu_to_be16(XFS_DIR3_LEAFN_MAGIC);
+	lbp->b_ops = &xfs_dir3_leafn_buf_ops;
+	xfs_dir3_leaf_log_header(tp, lbp);
+	xfs_dir3_leaf_check(mp, lbp);
 	return 0;
 }
 
@@ -372,6 +405,8 @@ xfs_dir2_leafn_add(
 	int			lowstale;	/* previous stale entry */
 	xfs_mount_t		*mp;		/* filesystem mount point */
 	xfs_trans_t		*tp;		/* transaction pointer */
+	struct xfs_dir3_icleaf_hdr leafhdr;
+	struct xfs_dir2_leaf_entry *ents;
 
 	trace_xfs_dir2_leafn_add(args, index);
 
@@ -379,6 +414,8 @@ xfs_dir2_leafn_add(
 	mp = dp->i_mount;
 	tp = args->trans;
 	leaf = bp->b_addr;
+	xfs_dir3_leaf_hdr_from_disk(&leafhdr, leaf);
+	ents = xfs_dir3_leaf_ents_p(leaf);
 
 	/*
 	 * Quick check just to make sure we are not going to index
@@ -394,15 +431,15 @@ xfs_dir2_leafn_add(
 	 * a compact.
 	 */
 
-	if (be16_to_cpu(leaf->hdr.count) == xfs_dir2_max_leaf_ents(mp)) {
-		if (!leaf->hdr.stale)
+	if (leafhdr.count == xfs_dir3_max_leaf_ents(mp, leaf)) {
+		if (!leafhdr.stale)
 			return XFS_ERROR(ENOSPC);
-		compact = be16_to_cpu(leaf->hdr.stale) > 1;
+		compact = leafhdr.stale > 1;
 	} else
 		compact = 0;
-	ASSERT(index == 0 || be32_to_cpu(leaf->ents[index - 1].hashval) <= args->hashval);
-	ASSERT(index == be16_to_cpu(leaf->hdr.count) ||
-	       be32_to_cpu(leaf->ents[index].hashval) >= args->hashval);
+	ASSERT(index == 0 || be32_to_cpu(ents[index - 1].hashval) <= args->hashval);
+	ASSERT(index == leafhdr.count ||
+	       be32_to_cpu(ents[index].hashval) >= args->hashval);
 
 	if (args->op_flags & XFS_DA_OP_JUSTCHECK)
 		return 0;
@@ -411,62 +448,35 @@ xfs_dir2_leafn_add(
 	 * Compact out all but one stale leaf entry.  Leaves behind
 	 * the entry closest to index.
 	 */
-	if (compact) {
-		xfs_dir2_leaf_compact_x1(bp, &index, &lowstale, &highstale,
-			&lfloglow, &lfloghigh);
-	}
-	/*
-	 * Set impossible logging indices for this case.
-	 */
-	else if (leaf->hdr.stale) {
-		lfloglow = be16_to_cpu(leaf->hdr.count);
+	if (compact)
+		xfs_dir3_leaf_compact_x1(&leafhdr, ents, &index, &lowstale,
+					 &highstale, &lfloglow, &lfloghigh);
+	else if (leafhdr.stale) {
+		/*
+		 * Set impossible logging indices for this case.
+		 */
+		lfloglow = leafhdr.count;
 		lfloghigh = -1;
 	}
 
 	/*
 	 * Insert the new entry, log everything.
 	 */
-	lep = xfs_dir2_leaf_find_entry(leaf, index, compact, lowstale,
+	lep = xfs_dir3_leaf_find_entry(&leafhdr, ents, index, compact, lowstale,
 				       highstale, &lfloglow, &lfloghigh);
 
 	lep->hashval = cpu_to_be32(args->hashval);
 	lep->address = cpu_to_be32(xfs_dir2_db_off_to_dataptr(mp,
 				args->blkno, args->index));
-	xfs_dir2_leaf_log_header(tp, bp);
-	xfs_dir2_leaf_log_ents(tp, bp, lfloglow, lfloghigh);
-	xfs_dir2_leafn_check(dp, bp);
+
+	xfs_dir3_leaf_hdr_to_disk(leaf, &leafhdr);
+	xfs_dir3_leaf_log_header(tp, bp);
+	xfs_dir3_leaf_log_ents(tp, bp, lfloglow, lfloghigh);
+	xfs_dir3_leaf_check(mp, bp);
 	return 0;
 }
 
 #ifdef DEBUG
-/*
- * Check internal consistency of a leafn block.
- */
-void
-xfs_dir2_leafn_check(
-	struct xfs_inode *dp,
-	struct xfs_buf	*bp)
-{
-	int		i;			/* leaf index */
-	xfs_dir2_leaf_t	*leaf;			/* leaf structure */
-	xfs_mount_t	*mp;			/* filesystem mount point */
-	int		stale;			/* count of stale leaves */
-
-	leaf = bp->b_addr;
-	mp = dp->i_mount;
-	ASSERT(leaf->hdr.info.magic == cpu_to_be16(XFS_DIR2_LEAFN_MAGIC));
-	ASSERT(be16_to_cpu(leaf->hdr.count) <= xfs_dir2_max_leaf_ents(mp));
-	for (i = stale = 0; i < be16_to_cpu(leaf->hdr.count); i++) {
-		if (i + 1 < be16_to_cpu(leaf->hdr.count)) {
-			ASSERT(be32_to_cpu(leaf->ents[i].hashval) <=
-			       be32_to_cpu(leaf->ents[i + 1].hashval));
-		}
-		if (leaf->ents[i].address == cpu_to_be32(XFS_DIR2_NULL_DATAPTR))
-			stale++;
-	}
-	ASSERT(be16_to_cpu(leaf->hdr.stale) == stale);
-}
-
 static void
 xfs_dir2_free_hdr_check(
 	struct xfs_mount *mp,
@@ -494,15 +504,22 @@ xfs_dir2_leafn_lasthash(
 	struct xfs_buf	*bp,			/* leaf buffer */
 	int		*count)			/* count of entries in leaf */
 {
-	xfs_dir2_leaf_t	*leaf;			/* leaf structure */
+	struct xfs_dir2_leaf	*leaf = bp->b_addr;
+	struct xfs_dir2_leaf_entry *ents;
+	struct xfs_dir3_icleaf_hdr leafhdr;
+
+	xfs_dir3_leaf_hdr_from_disk(&leafhdr, leaf);
+
+	ASSERT(leafhdr.magic == XFS_DIR2_LEAFN_MAGIC ||
+	       leafhdr.magic == XFS_DIR3_LEAFN_MAGIC);
 
-	leaf = bp->b_addr;
-	ASSERT(leaf->hdr.info.magic == cpu_to_be16(XFS_DIR2_LEAFN_MAGIC));
 	if (count)
-		*count = be16_to_cpu(leaf->hdr.count);
-	if (!leaf->hdr.count)
+		*count = leafhdr.count;
+	if (!leafhdr.count)
 		return 0;
-	return be32_to_cpu(leaf->ents[be16_to_cpu(leaf->hdr.count) - 1].hashval);
+
+	ents = xfs_dir3_leaf_ents_p(leaf);
+	return be32_to_cpu(ents[leafhdr.count - 1].hashval);
 }
 
 /*
@@ -531,16 +548,19 @@ xfs_dir2_leafn_lookup_for_addname(
 	xfs_dir2_db_t		newdb;		/* new data block number */
 	xfs_dir2_db_t		newfdb;		/* new free block number */
 	xfs_trans_t		*tp;		/* transaction pointer */
+	struct xfs_dir2_leaf_entry *ents;
+	struct xfs_dir3_icleaf_hdr leafhdr;
 
 	dp = args->dp;
 	tp = args->trans;
 	mp = dp->i_mount;
 	leaf = bp->b_addr;
-	ASSERT(leaf->hdr.info.magic == cpu_to_be16(XFS_DIR2_LEAFN_MAGIC));
-#ifdef __KERNEL__
-	ASSERT(be16_to_cpu(leaf->hdr.count) > 0);
-#endif
-	xfs_dir2_leafn_check(dp, bp);
+	xfs_dir3_leaf_hdr_from_disk(&leafhdr, leaf);
+	ents = xfs_dir3_leaf_ents_p(leaf);
+
+	xfs_dir3_leaf_check(mp, bp);
+	ASSERT(leafhdr.count > 0);
+
 	/*
 	 * Look up the hash value in the leaf entries.
 	 */
@@ -560,9 +580,9 @@ xfs_dir2_leafn_lookup_for_addname(
 	/*
 	 * Loop over leaf entries with the right hash value.
 	 */
-	for (lep = &leaf->ents[index]; index < be16_to_cpu(leaf->hdr.count) &&
-				be32_to_cpu(lep->hashval) == args->hashval;
-				lep++, index++) {
+	for (lep = &ents[index];
+	     index < leafhdr.count && be32_to_cpu(lep->hashval) == args->hashval;
+	     lep++, index++) {
 		/*
 		 * Skip stale leaf entries.
 		 */
@@ -678,16 +698,19 @@ xfs_dir2_leafn_lookup_for_entry(
 	xfs_dir2_db_t		newdb;		/* new data block number */
 	xfs_trans_t		*tp;		/* transaction pointer */
 	enum xfs_dacmp		cmp;		/* comparison result */
+	struct xfs_dir2_leaf_entry *ents;
+	struct xfs_dir3_icleaf_hdr leafhdr;
 
 	dp = args->dp;
 	tp = args->trans;
 	mp = dp->i_mount;
 	leaf = bp->b_addr;
-	ASSERT(leaf->hdr.info.magic == cpu_to_be16(XFS_DIR2_LEAFN_MAGIC));
-#ifdef __KERNEL__
-	ASSERT(be16_to_cpu(leaf->hdr.count) > 0);
-#endif
-	xfs_dir2_leafn_check(dp, bp);
+	xfs_dir3_leaf_hdr_from_disk(&leafhdr, leaf);
+	ents = xfs_dir3_leaf_ents_p(leaf);
+
+	xfs_dir3_leaf_check(mp, bp);
+	ASSERT(leafhdr.count > 0);
+
 	/*
 	 * Look up the hash value in the leaf entries.
 	 */
@@ -702,9 +725,9 @@ xfs_dir2_leafn_lookup_for_entry(
 	/*
 	 * Loop over leaf entries with the right hash value.
 	 */
-	for (lep = &leaf->ents[index]; index < be16_to_cpu(leaf->hdr.count) &&
-				be32_to_cpu(lep->hashval) == args->hashval;
-				lep++, index++) {
+	for (lep = &ents[index];
+	     index < leafhdr.count && be32_to_cpu(lep->hashval) == args->hashval;
+	     lep++, index++) {
 		/*
 		 * Skip stale leaf entries.
 		 */
@@ -776,8 +799,7 @@ xfs_dir2_leafn_lookup_for_entry(
 				return XFS_ERROR(EEXIST);
 		}
 	}
-	ASSERT(index == be16_to_cpu(leaf->hdr.count) ||
-					(args->op_flags & XFS_DA_OP_OKNOENT));
+	ASSERT(index == leafhdr.count || (args->op_flags & XFS_DA_OP_OKNOENT));
 	if (curbp) {
 		if (args->cmpresult == XFS_CMP_DIFFERENT) {
 			/* Giving back last used data block. */
@@ -822,52 +844,50 @@ xfs_dir2_leafn_lookup_int(
  * Log entries and headers.  Stale entries are preserved.
  */
 static void
-xfs_dir2_leafn_moveents(
-	xfs_da_args_t	*args,			/* operation arguments */
-	struct xfs_buf	*bp_s,			/* source leaf buffer */
-	int		start_s,		/* source leaf index */
-	struct xfs_buf	*bp_d,			/* destination leaf buffer */
-	int		start_d,		/* destination leaf index */
-	int		count)			/* count of leaves to copy */
+xfs_dir3_leafn_moveents(
+	xfs_da_args_t			*args,	/* operation arguments */
+	struct xfs_buf			*bp_s,	/* source */
+	struct xfs_dir3_icleaf_hdr	*shdr,
+	struct xfs_dir2_leaf_entry	*sents,
+	int				start_s,/* source leaf index */
+	struct xfs_buf			*bp_d,	/* destination */
+	struct xfs_dir3_icleaf_hdr	*dhdr,
+	struct xfs_dir2_leaf_entry	*dents,
+	int				start_d,/* destination leaf index */
+	int				count)	/* count of leaves to copy */
 {
-	xfs_dir2_leaf_t	*leaf_d;		/* destination leaf structure */
-	xfs_dir2_leaf_t	*leaf_s;		/* source leaf structure */
-	int		stale;			/* count stale leaves copied */
-	xfs_trans_t	*tp;			/* transaction pointer */
+	struct xfs_trans		*tp = args->trans;
+	int				stale;	/* count stale leaves copied */
 
 	trace_xfs_dir2_leafn_moveents(args, start_s, start_d, count);
 
 	/*
 	 * Silently return if nothing to do.
 	 */
-	if (count == 0) {
+	if (count == 0)
 		return;
-	}
-	tp = args->trans;
-	leaf_s = bp_s->b_addr;
-	leaf_d = bp_d->b_addr;
+
 	/*
 	 * If the destination index is not the end of the current
 	 * destination leaf entries, open up a hole in the destination
 	 * to hold the new entries.
 	 */
-	if (start_d < be16_to_cpu(leaf_d->hdr.count)) {
-		memmove(&leaf_d->ents[start_d + count], &leaf_d->ents[start_d],
-			(be16_to_cpu(leaf_d->hdr.count) - start_d) *
-			sizeof(xfs_dir2_leaf_entry_t));
-		xfs_dir2_leaf_log_ents(tp, bp_d, start_d + count,
-			count + be16_to_cpu(leaf_d->hdr.count) - 1);
+	if (start_d < dhdr->count) {
+		memmove(&dents[start_d + count], &dents[start_d],
+			(dhdr->count - start_d) * sizeof(xfs_dir2_leaf_entry_t));
+		xfs_dir3_leaf_log_ents(tp, bp_d, start_d + count,
+				       count + dhdr->count - 1);
 	}
 	/*
 	 * If the source has stale leaves, count the ones in the copy range
 	 * so we can update the header correctly.
 	 */
-	if (leaf_s->hdr.stale) {
+	if (shdr->stale) {
 		int	i;			/* temp leaf index */
 
 		for (i = start_s, stale = 0; i < start_s + count; i++) {
-			if (leaf_s->ents[i].address ==
-			    cpu_to_be32(XFS_DIR2_NULL_DATAPTR))
+			if (sents[i].address ==
+					cpu_to_be32(XFS_DIR2_NULL_DATAPTR))
 				stale++;
 		}
 	} else
@@ -875,29 +895,27 @@ xfs_dir2_leafn_moveents(
 	/*
 	 * Copy the leaf entries from source to destination.
 	 */
-	memcpy(&leaf_d->ents[start_d], &leaf_s->ents[start_s],
+	memcpy(&dents[start_d], &sents[start_s],
 		count * sizeof(xfs_dir2_leaf_entry_t));
-	xfs_dir2_leaf_log_ents(tp, bp_d, start_d, start_d + count - 1);
+	xfs_dir3_leaf_log_ents(tp, bp_d, start_d, start_d + count - 1);
+
 	/*
 	 * If there are source entries after the ones we copied,
 	 * delete the ones we copied by sliding the next ones down.
 	 */
-	if (start_s + count < be16_to_cpu(leaf_s->hdr.count)) {
-		memmove(&leaf_s->ents[start_s], &leaf_s->ents[start_s + count],
+	if (start_s + count < shdr->count) {
+		memmove(&sents[start_s], &sents[start_s + count],
 			count * sizeof(xfs_dir2_leaf_entry_t));
-		xfs_dir2_leaf_log_ents(tp, bp_s, start_s, start_s + count - 1);
+		xfs_dir3_leaf_log_ents(tp, bp_s, start_s, start_s + count - 1);
 	}
+
 	/*
 	 * Update the headers and log them.
 	 */
-	be16_add_cpu(&leaf_s->hdr.count, -(count));
-	be16_add_cpu(&leaf_s->hdr.stale, -(stale));
-	be16_add_cpu(&leaf_d->hdr.count, count);
-	be16_add_cpu(&leaf_d->hdr.stale, stale);
-	xfs_dir2_leaf_log_header(tp, bp_s);
-	xfs_dir2_leaf_log_header(tp, bp_d);
-	xfs_dir2_leafn_check(args->dp, bp_s);
-	xfs_dir2_leafn_check(args->dp, bp_d);
+	shdr->count -= count;
+	shdr->stale -= stale;
+	dhdr->count += count;
+	dhdr->stale += stale;
 }
 
 /*
@@ -906,21 +924,25 @@ xfs_dir2_leafn_moveents(
  */
 int						/* sort order */
 xfs_dir2_leafn_order(
-	struct xfs_buf	*leaf1_bp,		/* leaf1 buffer */
-	struct xfs_buf	*leaf2_bp)		/* leaf2 buffer */
+	struct xfs_buf		*leaf1_bp,		/* leaf1 buffer */
+	struct xfs_buf		*leaf2_bp)		/* leaf2 buffer */
 {
-	xfs_dir2_leaf_t	*leaf1;			/* leaf1 structure */
-	xfs_dir2_leaf_t	*leaf2;			/* leaf2 structure */
-
-	leaf1 = leaf1_bp->b_addr;
-	leaf2 = leaf2_bp->b_addr;
-	ASSERT(leaf1->hdr.info.magic == cpu_to_be16(XFS_DIR2_LEAFN_MAGIC));
-	ASSERT(leaf2->hdr.info.magic == cpu_to_be16(XFS_DIR2_LEAFN_MAGIC));
-	if (be16_to_cpu(leaf1->hdr.count) > 0 &&
-	    be16_to_cpu(leaf2->hdr.count) > 0 &&
-	    (be32_to_cpu(leaf2->ents[0].hashval) < be32_to_cpu(leaf1->ents[0].hashval) ||
-	     be32_to_cpu(leaf2->ents[be16_to_cpu(leaf2->hdr.count) - 1].hashval) <
-	     be32_to_cpu(leaf1->ents[be16_to_cpu(leaf1->hdr.count) - 1].hashval)))
+	struct xfs_dir2_leaf	*leaf1 = leaf1_bp->b_addr;
+	struct xfs_dir2_leaf	*leaf2 = leaf2_bp->b_addr;
+	struct xfs_dir2_leaf_entry *ents1;
+	struct xfs_dir2_leaf_entry *ents2;
+	struct xfs_dir3_icleaf_hdr hdr1;
+	struct xfs_dir3_icleaf_hdr hdr2;
+
+	xfs_dir3_leaf_hdr_from_disk(&hdr1, leaf1);
+	xfs_dir3_leaf_hdr_from_disk(&hdr2, leaf2);
+	ents1 = xfs_dir3_leaf_ents_p(leaf1);
+	ents2 = xfs_dir3_leaf_ents_p(leaf2);
+
+	if (hdr1.count > 0 && hdr2.count > 0 &&
+	    (be32_to_cpu(ents2[0].hashval) < be32_to_cpu(ents1[0].hashval) ||
+	     be32_to_cpu(ents2[hdr2.count - 1].hashval) <
+				be32_to_cpu(ents1[hdr1.count - 1].hashval)))
 		return 1;
 	return 0;
 }
@@ -949,6 +971,10 @@ xfs_dir2_leafn_rebalance(
 #endif
 	int			oldsum;		/* old total leaf count */
 	int			swap;		/* swapped leaf blocks */
+	struct xfs_dir2_leaf_entry *ents1;
+	struct xfs_dir2_leaf_entry *ents2;
+	struct xfs_dir3_icleaf_hdr hdr1;
+	struct xfs_dir3_icleaf_hdr hdr2;
 
 	args = state->args;
 	/*
@@ -963,11 +989,17 @@ xfs_dir2_leafn_rebalance(
 	}
 	leaf1 = blk1->bp->b_addr;
 	leaf2 = blk2->bp->b_addr;
-	oldsum = be16_to_cpu(leaf1->hdr.count) + be16_to_cpu(leaf2->hdr.count);
+	xfs_dir3_leaf_hdr_from_disk(&hdr1, leaf1);
+	xfs_dir3_leaf_hdr_from_disk(&hdr2, leaf2);
+	ents1 = xfs_dir3_leaf_ents_p(leaf1);
+	ents2 = xfs_dir3_leaf_ents_p(leaf2);
+
+	oldsum = hdr1.count + hdr2.count;
 #ifdef DEBUG
-	oldstale = be16_to_cpu(leaf1->hdr.stale) + be16_to_cpu(leaf2->hdr.stale);
+	oldstale = hdr1.stale + hdr2.stale;
 #endif
 	mid = oldsum >> 1;
+
 	/*
 	 * If the old leaf count was odd then the new one will be even,
 	 * so we need to divide the new count evenly.
@@ -975,10 +1007,10 @@ xfs_dir2_leafn_rebalance(
 	if (oldsum & 1) {
 		xfs_dahash_t	midhash;	/* middle entry hash value */
 
-		if (mid >= be16_to_cpu(leaf1->hdr.count))
-			midhash = be32_to_cpu(leaf2->ents[mid - be16_to_cpu(leaf1->hdr.count)].hashval);
+		if (mid >= hdr1.count)
+			midhash = be32_to_cpu(ents2[mid - hdr1.count].hashval);
 		else
-			midhash = be32_to_cpu(leaf1->ents[mid].hashval);
+			midhash = be32_to_cpu(ents1[mid].hashval);
 		isleft = args->hashval <= midhash;
 	}
 	/*
@@ -992,30 +1024,42 @@ xfs_dir2_leafn_rebalance(
 	 * Calculate moved entry count.  Positive means left-to-right,
 	 * negative means right-to-left.  Then move the entries.
 	 */
-	count = be16_to_cpu(leaf1->hdr.count) - mid + (isleft == 0);
+	count = hdr1.count - mid + (isleft == 0);
 	if (count > 0)
-		xfs_dir2_leafn_moveents(args, blk1->bp,
-			be16_to_cpu(leaf1->hdr.count) - count, blk2->bp, 0, count);
+		xfs_dir3_leafn_moveents(args, blk1->bp, &hdr1, ents1,
+					hdr1.count - count, blk2->bp,
+					&hdr2, ents2, 0, count);
 	else if (count < 0)
-		xfs_dir2_leafn_moveents(args, blk2->bp, 0, blk1->bp,
-			be16_to_cpu(leaf1->hdr.count), count);
-	ASSERT(be16_to_cpu(leaf1->hdr.count) + be16_to_cpu(leaf2->hdr.count) == oldsum);
-	ASSERT(be16_to_cpu(leaf1->hdr.stale) + be16_to_cpu(leaf2->hdr.stale) == oldstale);
+		xfs_dir3_leafn_moveents(args, blk2->bp, &hdr2, ents2, 0,
+					blk1->bp, &hdr1, ents1,
+					hdr1.count, count);
+
+	ASSERT(hdr1.count + hdr2.count == oldsum);
+	ASSERT(hdr1.stale + hdr2.stale == oldstale);
+
+	/* log the changes made when moving the entries */
+	xfs_dir3_leaf_hdr_to_disk(leaf1, &hdr1);
+	xfs_dir3_leaf_hdr_to_disk(leaf2, &hdr2);
+	xfs_dir3_leaf_log_header(args->trans, blk1->bp);
+	xfs_dir3_leaf_log_header(args->trans, blk2->bp);
+
+	xfs_dir3_leaf_check(args->dp->i_mount, blk1->bp);
+	xfs_dir3_leaf_check(args->dp->i_mount, blk2->bp);
+
 	/*
 	 * Mark whether we're inserting into the old or new leaf.
 	 */
-	if (be16_to_cpu(leaf1->hdr.count) < be16_to_cpu(leaf2->hdr.count))
+	if (hdr1.count < hdr2.count)
 		state->inleaf = swap;
-	else if (be16_to_cpu(leaf1->hdr.count) > be16_to_cpu(leaf2->hdr.count))
+	else if (hdr1.count > hdr2.count)
 		state->inleaf = !swap;
 	else
-		state->inleaf =
-			swap ^ (blk1->index <= be16_to_cpu(leaf1->hdr.count));
+		state->inleaf = swap ^ (blk1->index <= hdr1.count);
 	/*
 	 * Adjust the expected index for insertion.
 	 */
 	if (!state->inleaf)
-		blk2->index = blk1->index - be16_to_cpu(leaf1->hdr.count);
+		blk2->index = blk1->index - hdr1.count;
 
 	/*
 	 * Finally sanity check just to make sure we are not returning a
@@ -1137,6 +1181,8 @@ xfs_dir2_leafn_remove(
 	int			needscan;	/* need to rescan data frees */
 	xfs_trans_t		*tp;		/* transaction pointer */
 	struct xfs_dir2_data_free *bf;		/* bestfree table */
+	struct xfs_dir3_icleaf_hdr leafhdr;
+	struct xfs_dir2_leaf_entry *ents;
 
 	trace_xfs_dir2_leafn_remove(args, index);
 
@@ -1144,11 +1190,14 @@ xfs_dir2_leafn_remove(
 	tp = args->trans;
 	mp = dp->i_mount;
 	leaf = bp->b_addr;
-	ASSERT(leaf->hdr.info.magic == cpu_to_be16(XFS_DIR2_LEAFN_MAGIC));
+	xfs_dir3_leaf_hdr_from_disk(&leafhdr, leaf);
+	ents = xfs_dir3_leaf_ents_p(leaf);
+
 	/*
 	 * Point to the entry we're removing.
 	 */
-	lep = &leaf->ents[index];
+	lep = &ents[index];
+
 	/*
 	 * Extract the data block and offset from the entry.
 	 */
@@ -1156,14 +1205,18 @@ xfs_dir2_leafn_remove(
 	ASSERT(dblk->blkno == db);
 	off = xfs_dir2_dataptr_to_off(mp, be32_to_cpu(lep->address));
 	ASSERT(dblk->index == off);
+
 	/*
 	 * Kill the leaf entry by marking it stale.
 	 * Log the leaf block changes.
 	 */
-	be16_add_cpu(&leaf->hdr.stale, 1);
-	xfs_dir2_leaf_log_header(tp, bp);
+	leafhdr.stale++;
+	xfs_dir3_leaf_hdr_to_disk(leaf, &leafhdr);
+	xfs_dir3_leaf_log_header(tp, bp);
+
 	lep->address = cpu_to_be32(XFS_DIR2_NULL_DATAPTR);
-	xfs_dir2_leaf_log_ents(tp, bp, index, index);
+	xfs_dir3_leaf_log_ents(tp, bp, index, index);
+
 	/*
 	 * Make the data entry free.  Keep track of the longest freespace
 	 * in the data block in case it changes.
@@ -1252,15 +1305,13 @@ xfs_dir2_leafn_remove(
 			return error;
 	}
 
-	xfs_dir2_leafn_check(dp, bp);
+	xfs_dir3_leaf_check(mp, bp);
 	/*
 	 * Return indication of whether this leaf block is empty enough
 	 * to justify trying to join it with a neighbor.
 	 */
-	*rval =
-		((uint)sizeof(leaf->hdr) +
-		 (uint)sizeof(leaf->ents[0]) *
-		 (be16_to_cpu(leaf->hdr.count) - be16_to_cpu(leaf->hdr.stale))) <
+	*rval = (xfs_dir3_leaf_hdr_size(leaf) +
+		 (uint)sizeof(ents[0]) * (leafhdr.count - leafhdr.stale)) <
 		mp->m_dir_magicpct;
 	return 0;
 }
@@ -1293,11 +1344,11 @@ xfs_dir2_leafn_split(
 	/*
 	 * Initialize the new leaf block.
 	 */
-	error = xfs_dir2_leaf_init(args, xfs_dir2_da_to_db(mp, blkno),
-		&newblk->bp, XFS_DIR2_LEAFN_MAGIC);
-	if (error) {
+	error = xfs_dir3_leaf_get_buf(args, xfs_dir2_da_to_db(mp, blkno),
+				      &newblk->bp, XFS_DIR2_LEAFN_MAGIC);
+	if (error)
 		return error;
-	}
+
 	newblk->blkno = blkno;
 	newblk->magic = XFS_DIR2_LEAFN_MAGIC;
 	/*
@@ -1321,8 +1372,8 @@ xfs_dir2_leafn_split(
 	 */
 	oldblk->hashval = xfs_dir2_leafn_lasthash(oldblk->bp, NULL);
 	newblk->hashval = xfs_dir2_leafn_lasthash(newblk->bp, NULL);
-	xfs_dir2_leafn_check(args->dp, oldblk->bp);
-	xfs_dir2_leafn_check(args->dp, newblk->bp);
+	xfs_dir3_leaf_check(mp, oldblk->bp);
+	xfs_dir3_leaf_check(mp, newblk->bp);
 	return error;
 }
 
@@ -1348,9 +1399,10 @@ xfs_dir2_leafn_toosmall(
 	int			error;		/* error return value */
 	int			forward;	/* sibling block direction */
 	int			i;		/* sibling counter */
-	xfs_da_blkinfo_t	*info;		/* leaf block header */
 	xfs_dir2_leaf_t		*leaf;		/* leaf structure */
 	int			rval;		/* result from path_shift */
+	struct xfs_dir3_icleaf_hdr leafhdr;
+	struct xfs_dir2_leaf_entry *ents;
 
 	/*
 	 * Check for the degenerate case of the block being over 50% full.
@@ -1358,11 +1410,13 @@ xfs_dir2_leafn_toosmall(
 	 * to coalesce with a sibling.
 	 */
 	blk = &state->path.blk[state->path.active - 1];
-	info = blk->bp->b_addr;
-	ASSERT(info->magic == cpu_to_be16(XFS_DIR2_LEAFN_MAGIC));
-	leaf = (xfs_dir2_leaf_t *)info;
-	count = be16_to_cpu(leaf->hdr.count) - be16_to_cpu(leaf->hdr.stale);
-	bytes = (uint)sizeof(leaf->hdr) + count * (uint)sizeof(leaf->ents[0]);
+	leaf = blk->bp->b_addr;
+	xfs_dir3_leaf_hdr_from_disk(&leafhdr, leaf);
+	ents = xfs_dir3_leaf_ents_p(leaf);
+	xfs_dir3_leaf_check(mp, blk->bp);
+
+	count = leafhdr.count - leafhdr.stale;
+	bytes = xfs_dir3_leaf_hdr_size(leaf) + count * sizeof(ents[0]);
 	if (bytes > (state->blocksize >> 1)) {
 		/*
 		 * Blk over 50%, don't try to join.
@@ -1381,7 +1435,7 @@ xfs_dir2_leafn_toosmall(
 		 * Make altpath point to the block we want to keep and
 		 * path point to the block we want to drop (this one).
 		 */
-		forward = (info->forw != 0);
+		forward = (leafhdr.forw != 0);
 		memcpy(&state->altpath, &state->path, sizeof(state->path));
 		error = xfs_da_path_shift(state, &state->altpath, forward, 0,
 			&rval);
@@ -1397,15 +1451,17 @@ xfs_dir2_leafn_toosmall(
 	 * We prefer coalescing with the lower numbered sibling so as
 	 * to shrink a directory over time.
 	 */
-	forward = be32_to_cpu(info->forw) < be32_to_cpu(info->back);
+	forward = leafhdr.forw < leafhdr.back;
 	for (i = 0, bp = NULL; i < 2; forward = !forward, i++) {
-		blkno = forward ? be32_to_cpu(info->forw) : be32_to_cpu(info->back);
+		struct xfs_dir3_icleaf_hdr hdr2;
+
+		blkno = forward ? leafhdr.forw : leafhdr.back;
 		if (blkno == 0)
 			continue;
 		/*
 		 * Read the sibling leaf block.
 		 */
-		error = xfs_dir2_leafn_read(state->args->trans, state->args->dp,
+		error = xfs_dir3_leafn_read(state->args->trans, state->args->dp,
 					    blkno, -1, &bp);
 		if (error)
 			return error;
@@ -1413,13 +1469,15 @@ xfs_dir2_leafn_toosmall(
 		/*
 		 * Count bytes in the two blocks combined.
 		 */
-		leaf = (xfs_dir2_leaf_t *)info;
-		count = be16_to_cpu(leaf->hdr.count) - be16_to_cpu(leaf->hdr.stale);
+		count = leafhdr.count - leafhdr.stale;
 		bytes = state->blocksize - (state->blocksize >> 2);
+
 		leaf = bp->b_addr;
-		ASSERT(leaf->hdr.info.magic == cpu_to_be16(XFS_DIR2_LEAFN_MAGIC));
-		count += be16_to_cpu(leaf->hdr.count) - be16_to_cpu(leaf->hdr.stale);
-		bytes -= count * (uint)sizeof(leaf->ents[0]);
+		xfs_dir3_leaf_hdr_from_disk(&hdr2, leaf);
+		ents = xfs_dir3_leaf_ents_p(leaf);
+		count += hdr2.count - hdr2.stale;
+		bytes -= count * sizeof(ents[0]);
+
 		/*
 		 * Fits with at least 25% to spare.
 		 */
@@ -1466,34 +1524,53 @@ xfs_dir2_leafn_unbalance(
 	xfs_da_args_t		*args;		/* operation arguments */
 	xfs_dir2_leaf_t		*drop_leaf;	/* dead leaf structure */
 	xfs_dir2_leaf_t		*save_leaf;	/* surviving leaf structure */
+	struct xfs_dir3_icleaf_hdr savehdr;
+	struct xfs_dir3_icleaf_hdr drophdr;
+	struct xfs_dir2_leaf_entry *sents;
+	struct xfs_dir2_leaf_entry *dents;
 
 	args = state->args;
 	ASSERT(drop_blk->magic == XFS_DIR2_LEAFN_MAGIC);
 	ASSERT(save_blk->magic == XFS_DIR2_LEAFN_MAGIC);
 	drop_leaf = drop_blk->bp->b_addr;
 	save_leaf = save_blk->bp->b_addr;
-	ASSERT(drop_leaf->hdr.info.magic == cpu_to_be16(XFS_DIR2_LEAFN_MAGIC));
-	ASSERT(save_leaf->hdr.info.magic == cpu_to_be16(XFS_DIR2_LEAFN_MAGIC));
+
+	xfs_dir3_leaf_hdr_from_disk(&savehdr, save_leaf);
+	xfs_dir3_leaf_hdr_from_disk(&drophdr, drop_leaf);
+	sents = xfs_dir3_leaf_ents_p(save_leaf);
+	dents = xfs_dir3_leaf_ents_p(drop_leaf);
+
 	/*
 	 * If there are any stale leaf entries, take this opportunity
 	 * to purge them.
 	 */
-	if (drop_leaf->hdr.stale)
-		xfs_dir2_leaf_compact(args, drop_blk->bp);
-	if (save_leaf->hdr.stale)
-		xfs_dir2_leaf_compact(args, save_blk->bp);
+	if (drophdr.stale)
+		xfs_dir3_leaf_compact(args, &drophdr, drop_blk->bp);
+	if (savehdr.stale)
+		xfs_dir3_leaf_compact(args, &savehdr, save_blk->bp);
+
 	/*
 	 * Move the entries from drop to the appropriate end of save.
 	 */
-	drop_blk->hashval = be32_to_cpu(drop_leaf->ents[be16_to_cpu(drop_leaf->hdr.count) - 1].hashval);
+	drop_blk->hashval = be32_to_cpu(dents[drophdr.count - 1].hashval);
 	if (xfs_dir2_leafn_order(save_blk->bp, drop_blk->bp))
-		xfs_dir2_leafn_moveents(args, drop_blk->bp, 0, save_blk->bp, 0,
-			be16_to_cpu(drop_leaf->hdr.count));
+		xfs_dir3_leafn_moveents(args, drop_blk->bp, &drophdr, dents, 0,
+					save_blk->bp, &savehdr, sents, 0,
+					drophdr.count);
 	else
-		xfs_dir2_leafn_moveents(args, drop_blk->bp, 0, save_blk->bp,
-			be16_to_cpu(save_leaf->hdr.count), be16_to_cpu(drop_leaf->hdr.count));
-	save_blk->hashval = be32_to_cpu(save_leaf->ents[be16_to_cpu(save_leaf->hdr.count) - 1].hashval);
-	xfs_dir2_leafn_check(args->dp, save_blk->bp);
+		xfs_dir3_leafn_moveents(args, drop_blk->bp, &drophdr, dents, 0,
+					save_blk->bp, &savehdr, sents,
+					savehdr.count, drophdr.count);
+	save_blk->hashval = be32_to_cpu(sents[savehdr.count - 1].hashval);
+
+	/* log the changes made when moving the entries */
+	xfs_dir3_leaf_hdr_to_disk(save_leaf, &savehdr);
+	xfs_dir3_leaf_hdr_to_disk(drop_leaf, &drophdr);
+	xfs_dir3_leaf_log_header(args->trans, save_blk->bp);
+	xfs_dir3_leaf_log_header(args->trans, drop_blk->bp);
+
+	xfs_dir3_leaf_check(args->dp->i_mount, save_blk->bp);
+	xfs_dir3_leaf_check(args->dp->i_mount, drop_blk->bp);
 }
 
 /*
@@ -2098,13 +2175,15 @@ xfs_dir2_node_replace(
 	 * and locked it.  But paranoia is good.
 	 */
 	if (rval == EEXIST) {
+		struct xfs_dir2_leaf_entry *ents;
 		/*
 		 * Find the leaf entry.
 		 */
 		blk = &state->path.blk[state->path.active - 1];
 		ASSERT(blk->magic == XFS_DIR2_LEAFN_MAGIC);
 		leaf = blk->bp->b_addr;
-		lep = &leaf->ents[blk->index];
+		ents = xfs_dir3_leaf_ents_p(leaf);
+		lep = &ents[blk->index];
 		ASSERT(state->extravalid);
 		/*
 		 * Point to the data entry.
diff --git a/libxfs/xfs_dir2_priv.h b/libxfs/xfs_dir2_priv.h
index 910e644..932565d 100644
--- a/libxfs/xfs_dir2_priv.h
+++ b/libxfs/xfs_dir2_priv.h
@@ -77,24 +77,25 @@ extern void xfs_dir2_data_use_free(struct xfs_trans *tp, struct xfs_buf *bp,
 		xfs_dir2_data_aoff_t len, int *needlogp, int *needscanp);
 
 /* xfs_dir2_leaf.c */
-extern const struct xfs_buf_ops xfs_dir2_leafn_buf_ops;
+extern const struct xfs_buf_ops xfs_dir3_leafn_buf_ops;
 
-extern int xfs_dir2_leafn_read(struct xfs_trans *tp, struct xfs_inode *dp,
+extern int xfs_dir3_leafn_read(struct xfs_trans *tp, struct xfs_inode *dp,
 		xfs_dablk_t fbno, xfs_daddr_t mappedbno, struct xfs_buf **bpp);
 extern int xfs_dir2_block_to_leaf(struct xfs_da_args *args,
 		struct xfs_buf *dbp);
 extern int xfs_dir2_leaf_addname(struct xfs_da_args *args);
-extern void xfs_dir2_leaf_compact(struct xfs_da_args *args,
-		struct xfs_buf *bp);
-extern void xfs_dir2_leaf_compact_x1(struct xfs_buf *bp, int *indexp,
+extern void xfs_dir3_leaf_compact(struct xfs_da_args *args,
+		struct xfs_dir3_icleaf_hdr *leafhdr, struct xfs_buf *bp);
+extern void xfs_dir3_leaf_compact_x1(struct xfs_dir3_icleaf_hdr *leafhdr,
+		struct xfs_dir2_leaf_entry *ents, int *indexp,
 		int *lowstalep, int *highstalep, int *lowlogp, int *highlogp);
 extern int xfs_dir2_leaf_getdents(struct xfs_inode *dp, void *dirent,
 		size_t bufsize, xfs_off_t *offset, filldir_t filldir);
-extern int xfs_dir2_leaf_init(struct xfs_da_args *args, xfs_dir2_db_t bno,
-		struct xfs_buf **bpp, int magic);
-extern void xfs_dir2_leaf_log_ents(struct xfs_trans *tp, struct xfs_buf *bp,
+extern int xfs_dir3_leaf_get_buf(struct xfs_da_args *args, xfs_dir2_db_t bno,
+		struct xfs_buf **bpp, __uint16_t magic);
+extern void xfs_dir3_leaf_log_ents(struct xfs_trans *tp, struct xfs_buf *bp,
 		int first, int last);
-extern void xfs_dir2_leaf_log_header(struct xfs_trans *tp,
+extern void xfs_dir3_leaf_log_header(struct xfs_trans *tp,
 		struct xfs_buf *bp);
 extern int xfs_dir2_leaf_lookup(struct xfs_da_args *args);
 extern int xfs_dir2_leaf_removename(struct xfs_da_args *args);
@@ -104,11 +105,18 @@ extern int xfs_dir2_leaf_search_hash(struct xfs_da_args *args,
 extern int xfs_dir2_leaf_trim_data(struct xfs_da_args *args,
 		struct xfs_buf *lbp, xfs_dir2_db_t db);
 extern struct xfs_dir2_leaf_entry *
-xfs_dir2_leaf_find_entry(struct xfs_dir2_leaf *leaf, int index, int compact,
-		int lowstale, int highstale,
-		int *lfloglow, int *lfloghigh);
+xfs_dir3_leaf_find_entry(struct xfs_dir3_icleaf_hdr *leafhdr,
+		struct xfs_dir2_leaf_entry *ents, int index, int compact,
+		int lowstale, int highstale, int *lfloglow, int *lfloghigh);
 extern int xfs_dir2_node_to_leaf(struct xfs_da_state *state);
 
+extern void xfs_dir3_leaf_hdr_from_disk(struct xfs_dir3_icleaf_hdr *to,
+		struct xfs_dir2_leaf *from);
+extern void xfs_dir3_leaf_hdr_to_disk(struct xfs_dir2_leaf *to,
+		struct xfs_dir3_icleaf_hdr *from);
+extern bool xfs_dir3_leaf_check_int(struct xfs_mount *mp,
+		struct xfs_dir3_icleaf_hdr *hdr, struct xfs_dir2_leaf *leaf);
+
 /* xfs_dir2_node.c */
 extern int xfs_dir2_leaf_to_node(struct xfs_da_args *args,
 		struct xfs_buf *lbp);
diff --git a/repair/dir2.c b/repair/dir2.c
index c01e0bc..9f1d50b 100644
--- a/repair/dir2.c
+++ b/repair/dir2.c
@@ -1627,24 +1627,26 @@ process_leaf_block_dir2(
 {
 	int			i;
 	int			stale;
+	struct xfs_dir2_leaf_entry *ents;
+
+	ents = xfs_dir3_leaf_ents_p(leaf);
 
 	for (i = stale = 0; i < be16_to_cpu(leaf->hdr.count); i++) {
-		if ((char *)&leaf->ents[i] >= (char *)leaf + mp->m_dirblksize) {
+		if ((char *)&ents[i] >= (char *)leaf + mp->m_dirblksize) {
 			do_warn(
 _("bad entry count in block %u of directory inode %" PRIu64 "\n"),
 				da_bno, ino);
 			return 1;
 		}
-		if (be32_to_cpu(leaf->ents[i].address) == XFS_DIR2_NULL_DATAPTR)
+		if (be32_to_cpu(ents[i].address) == XFS_DIR2_NULL_DATAPTR)
 			stale++;
-		else if (be32_to_cpu(leaf->ents[i].hashval) < last_hashval) {
+		else if (be32_to_cpu(ents[i].hashval) < last_hashval) {
 			do_warn(
 _("bad hash ordering in block %u of directory inode %" PRIu64 "\n"),
 				da_bno, ino);
 			return 1;
 		}
-		*next_hashval = last_hashval =
-					be32_to_cpu(leaf->ents[i].hashval);
+		*next_hashval = last_hashval = be32_to_cpu(ents[i].hashval);
 	}
 	if (stale != be16_to_cpu(leaf->hdr.stale)) {
 		do_warn(
diff --git a/repair/phase6.c b/repair/phase6.c
index 4c65acf..bd1fad4 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -1826,6 +1826,7 @@ longform_dir2_check_leaf(
 	xfs_dir2_leaf_t		*leaf;
 	xfs_dir2_leaf_tail_t	*ltp;
 	int			seeval;
+	struct xfs_dir2_leaf_entry *ents;
 
 	da_bno = mp->m_dirleafblk;
 	if (libxfs_da_read_buf(NULL, ip, da_bno, -1, &bp, XFS_DATA_FORK, NULL)) {
@@ -1835,6 +1836,7 @@ longform_dir2_check_leaf(
 		/* NOTREACHED */
 	}
 	leaf = bp->b_addr;
+	ents = xfs_dir3_leaf_ents_p(leaf);
 	ltp = xfs_dir2_leaf_tail_p(mp, leaf);
 	bestsp = xfs_dir2_leaf_bests_p(ltp);
 	if (be16_to_cpu(leaf->hdr.info.magic) != XFS_DIR2_LEAF1_MAGIC ||
@@ -1843,8 +1845,8 @@ longform_dir2_check_leaf(
 				be16_to_cpu(leaf->hdr.count) <
 					be16_to_cpu(leaf->hdr.stale) ||
 				be16_to_cpu(leaf->hdr.count) >
-					xfs_dir2_max_leaf_ents(mp) ||
-				(char *)&leaf->ents[be16_to_cpu(
+					xfs_dir3_max_leaf_ents(mp, leaf) ||
+				(char *)&ents[be16_to_cpu(
 					leaf->hdr.count)] > (char *)bestsp) {
 		do_warn(
 	_("leaf block %u for directory inode %" PRIu64 " bad header\n"),
@@ -1852,7 +1854,7 @@ longform_dir2_check_leaf(
 		libxfs_putbuf(bp);
 		return 1;
 	}
-	seeval = dir_hash_see_all(hashtab, leaf->ents,
+	seeval = dir_hash_see_all(hashtab, ents,
 				be16_to_cpu(leaf->hdr.count),
 				be16_to_cpu(leaf->hdr.stale));
 	if (dir_hash_check(hashtab, ip, seeval)) {
@@ -1895,6 +1897,7 @@ longform_dir2_check_node(
 	xfs_fileoff_t		next_da_bno;
 	int			seeval = 0;
 	int			used;
+	struct xfs_dir2_leaf_entry *ents;
 
 	for (da_bno = mp->m_dirleafblk, next_da_bno = 0;
 			next_da_bno != NULLFILEOFF && da_bno < mp->m_dirfreeblk;
@@ -1910,6 +1913,7 @@ longform_dir2_check_node(
 			return 1;
 		}
 		leaf = bp->b_addr;
+		ents = xfs_dir3_leaf_ents_p(leaf);
 		if (be16_to_cpu(leaf->hdr.info.magic) != XFS_DIR2_LEAFN_MAGIC) {
 			if (be16_to_cpu(leaf->hdr.info.magic) ==
 							XFS_DA_NODE_MAGIC) {
@@ -1923,7 +1927,7 @@ longform_dir2_check_node(
 			libxfs_putbuf(bp);
 			return 1;
 		}
-		if (be16_to_cpu(leaf->hdr.count) > xfs_dir2_max_leaf_ents(mp) ||
+		if (be16_to_cpu(leaf->hdr.count) > xfs_dir3_max_leaf_ents(mp, leaf) ||
 					be16_to_cpu(leaf->hdr.count) <
 						be16_to_cpu(leaf->hdr.stale)) {
 			do_warn(
@@ -1932,7 +1936,7 @@ longform_dir2_check_node(
 			libxfs_putbuf(bp);
 			return 1;
 		}
-		seeval = dir_hash_see_all(hashtab, leaf->ents,
+		seeval = dir_hash_see_all(hashtab, ents,
 					be16_to_cpu(leaf->hdr.count),
 					be16_to_cpu(leaf->hdr.stale));
 		libxfs_putbuf(bp);
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
