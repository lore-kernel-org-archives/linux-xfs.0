Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p619k85F056113 for <xfs@oss.sgi.com>; Fri, 1 Jul 2011 04:46:08 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2E476466AD
	for <xfs@oss.sgi.com>; Fri,  1 Jul 2011 02:46:06 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	VtmdswGvcGhv0E86 for <xfs@oss.sgi.com>;
	Fri, 01 Jul 2011 02:46:06 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1QcaIY-00020M-Jr
	for xfs@oss.sgi.com; Fri, 01 Jul 2011 09:46:06 +0000
Message-Id: <20110701094606.567693269@bombadil.infradead.org>
Date: Fri, 01 Jul 2011 05:43:42 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 21/27] xfs: cleanup struct xfs_dir2_leaf
References: <20110701094321.936534538@bombadil.infradead.org>
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

Index: xfs/fs/xfs/xfs_dir2_leaf.c
===================================================================
--- xfs.orig/fs/xfs/xfs_dir2_leaf.c	2011-06-30 09:38:41.646734133 +0200
+++ xfs/fs/xfs/xfs_dir2_leaf.c	2011-06-30 09:38:44.723400763 +0200
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
--- xfs.orig/fs/xfs/xfs_dir2_leaf.h	2011-06-30 09:18:07.263416117 +0200
+++ xfs/fs/xfs/xfs_dir2_leaf.h	2011-06-30 09:38:44.723400763 +0200
@@ -72,10 +72,7 @@ typedef struct xfs_dir2_leaf_tail {
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
