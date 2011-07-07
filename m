Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p67B6kdT159989 for <xfs@oss.sgi.com>; Thu, 7 Jul 2011 06:06:46 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7CA4F15ECDA7
	for <xfs@oss.sgi.com>; Thu,  7 Jul 2011 04:06:45 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	KsRGYstyYb0VaFUX for <xfs@oss.sgi.com>;
	Thu, 07 Jul 2011 04:06:45 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1QemPs-000402-Mg
	for xfs@oss.sgi.com; Thu, 07 Jul 2011 11:06:44 +0000
Message-Id: <20110707110644.667342204@bombadil.infradead.org>
Date: Thu, 07 Jul 2011 07:05:56 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 21/28] xfs: cleanup struct xfs_dir2_leaf
References: <20110707110535.205001532@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-cleanup-xfs_dir2_leaf_t
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Simplify the confusing xfs_dir2_leaf structure.  It is supposed to describe
an XFS dir2 leaf format btree block, but due to the variable sized nature
of almost all elements in it it can't actuall do anything close to that
job.   Remove the members that are after the first variable sized array,
given that they could only be used for sizeof expressions that can as well
just use the underlying types directly, and make the ents array a real
C99 variable sized array.

Also factor out the xfs_dir2_leaf_size, to make the sizing of a leaf
entry which already was convoluted somewhat readable after using the
longer type names in the sizeof expressions.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Alex Elder <aelder@sgi.com>

Index: xfs/fs/xfs/xfs_dir2_leaf.c
===================================================================
--- xfs.orig/fs/xfs/xfs_dir2_leaf.c	2011-07-07 10:06:54.418727503 +0200
+++ xfs/fs/xfs/xfs_dir2_leaf.c	2011-07-07 10:10:13.968717400 +0200
@@ -367,9 +367,12 @@ xfs_dir2_leaf_addname(
 	/*
 	 * How many bytes do we need in the leaf block?
 	 */
-	needbytes =
-		(leaf->hdr.stale ? 0 : (uint)sizeof(leaf->ents[0])) +
-		(use_block != -1 ? 0 : (uint)sizeof(leaf->bests[0]));
+	needbytes = 0;
+	if (!leaf->hdr.stale)
+		needbytes += sizeof(xfs_dir2_leaf_entry_t);
+	if (use_block == -1)
+		needbytes += sizeof(xfs_dir2_data_off_t);
+
 	/*
 	 * Now kill use_block if it refers to a missing block, so we
 	 * can use it as an indication of allocation needed.
@@ -1763,6 +1766,20 @@ xfs_dir2_leaf_trim_data(
 	return 0;
 }
 
+static inline size_t
+xfs_dir2_leaf_size(
+	struct xfs_dir2_leaf_hdr	*hdr,
+	int				counts)
+{
+	int			entries;
+
+	entries = be16_to_cpu(hdr->count) - be16_to_cpu(hdr->stale);
+	return sizeof(xfs_dir2_leaf_hdr_t) +
+	    entries * sizeof(xfs_dir2_leaf_entry_t) +
+	    counts * sizeof(xfs_dir2_data_off_t) +
+	    sizeof(xfs_dir2_leaf_tail_t);
+}
+
 /*
  * Convert node form directory to leaf form directory.
  * The root of the node form dir needs to already be a LEAFN block.
@@ -1844,18 +1861,17 @@ xfs_dir2_node_to_leaf(
 	free = fbp->data;
 	ASSERT(be32_to_cpu(free->hdr.magic) == XFS_DIR2_FREE_MAGIC);
 	ASSERT(!free->hdr.firstdb);
+
 	/*
 	 * Now see if the leafn and free data will fit in a leaf1.
 	 * If not, release the buffer and give up.
 	 */
-	if ((uint)sizeof(leaf->hdr) +
-	    (be16_to_cpu(leaf->hdr.count) - be16_to_cpu(leaf->hdr.stale)) * (uint)sizeof(leaf->ents[0]) +
-	    be32_to_cpu(free->hdr.nvalid) * (uint)sizeof(leaf->bests[0]) +
-	    (uint)sizeof(leaf->tail) >
-	    mp->m_dirblksize) {
+	if (xfs_dir2_leaf_size(&leaf->hdr, be32_to_cpu(free->hdr.nvalid)) >
+			mp->m_dirblksize) {
 		xfs_da_brelse(tp, fbp);
 		return 0;
 	}
+
 	/*
 	 * If the leaf has any stale entries in it, compress them out.
 	 * The compact routine will log the header.
@@ -1874,7 +1890,7 @@ xfs_dir2_node_to_leaf(
 	 * Set up the leaf bests table.
 	 */
 	memcpy(xfs_dir2_leaf_bests_p(ltp), free->bests,
-		be32_to_cpu(ltp->bestcount) * sizeof(leaf->bests[0]));
+		be32_to_cpu(ltp->bestcount) * sizeof(xfs_dir2_data_off_t));
 	xfs_dir2_leaf_log_bests(tp, lbp, 0, be32_to_cpu(ltp->bestcount) - 1);
 	xfs_dir2_leaf_log_tail(tp, lbp);
 	xfs_dir2_leaf_check(dp, lbp);
Index: xfs/fs/xfs/xfs_dir2_leaf.h
===================================================================
--- xfs.orig/fs/xfs/xfs_dir2_leaf.h	2011-07-07 10:06:54.432060837 +0200
+++ xfs/fs/xfs/xfs_dir2_leaf.h	2011-07-07 10:14:04.795372387 +0200
@@ -18,6 +18,36 @@
 #ifndef __XFS_DIR2_LEAF_H__
 #define	__XFS_DIR2_LEAF_H__
 
+/*
+ * Directory format 2, leaf block structures.
+ *
+ * A pure data block looks like the following drawing on disk:
+ *
+ *    +---------------------------+
+ *    | xfs_dir2_leaf_hdr_t       |
+ *    +---------------------------+
+ *    | xfs_dir2_leaf_entry_t     |
+ *    | xfs_dir2_leaf_entry_t     |
+ *    | xfs_dir2_leaf_entry_t     |
+ *    | xfs_dir2_leaf_entry_t     |
+ *    | ...                       |
+ *    +---------------------------+
+ *    | xfs_dir2_data_off_t       |
+ *    | xfs_dir2_data_off_t       |
+ *    | xfs_dir2_data_off_t       |
+ *    | ...                       |
+ *    +---------------------------+
+ *    | xfs_dir2_leaf_tail_t      |
+ *    +---------------------------+
+ *
+ * The bests (xfs_dir2_data_off_t members) and tail are at the end of the
+ * block for single-leaf only (magic = XFS_DIR2_LEAF1_MAGIC not
+ * XFS_DIR2_LEAFN_MAGIC).
+ *
+ * As all the entries are variable size structures the accessors in this
+ * file should be used to iterate over them.
+ */
+
 struct uio;
 struct xfs_dabuf;
 struct xfs_da_args;
@@ -67,15 +97,10 @@ typedef struct xfs_dir2_leaf_tail {
 
 /*
  * Leaf block.
- * bests and tail are at the end of the block for single-leaf only
- * (magic = XFS_DIR2_LEAF1_MAGIC not XFS_DIR2_LEAFN_MAGIC).
  */
 typedef struct xfs_dir2_leaf {
 	xfs_dir2_leaf_hdr_t	hdr;		/* leaf header */
-	xfs_dir2_leaf_entry_t	ents[1];	/* entries */
-						/* ... */
-	xfs_dir2_data_off_t	bests[1];	/* best free counts */
-	xfs_dir2_leaf_tail_t	tail;		/* leaf tail */
+	xfs_dir2_leaf_entry_t	ents[];	/* entries */
 } xfs_dir2_leaf_t;
 
 /*

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
