Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0L9NXdg260913 for <xfs@oss.sgi.com>; Fri, 21 Jan 2011 03:23:34 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 781B819FBC01
	for <xfs@oss.sgi.com>; Fri, 21 Jan 2011 01:25:52 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id YGxC0xmL2Nq399xl for
	<xfs@oss.sgi.com>; Fri, 21 Jan 2011 01:25:52 -0800 (PST)
Message-Id: <20110121092551.402449845@bombadil.infradead.org>
Date: Fri, 21 Jan 2011 04:22:32 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 5/6] xfs: do not classify freed allocation btree blocks as busy
References: <20110121092227.115815324@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-optimize-busy-btree-blocks
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

During an allocation or freeing of an extent, we occasionally have an
interesting situation happen during a btree update.  We may merge a block
as part of a record delete, then allocate it again immediately afterwards
when inserting a modified extent.  xfs_alloc_fixup_trees() does this sort
of manipulation to the btrees, and so can merge then immediately split
the tree resulting the in the same busy block being used from the
freelist.

Previously, this would trigger a synchronous log force of the entire log
(as the current transaction had a lsn of 0 until committed), but continue
to allow the extent to be used because if it is not on disk now then it
must have been freed and marked busy in this transaction.

In the case of allocbt blocks, we log the fact that they get moved to the
freelist and we also log them when the move off the free list back into
the free space trees.  When we move the blocks off the freelist back to
the trees, we mark the extent busy at that point so that it doesn't get
reused until the transaction is committed.

This means that as long as the block is on the AGFL and is only used
for allocbt blocks, we don't have to force the log to ensure prior
manipulating transactions are on disk as the process of log recovery
will replay the transactions in the correct order.

However, we still need to protect against the fact that as we approach
ENOSPC in an AG we can allocate data and metadata blocks direct from the
AGFL. In this case, we need to treat btree blocks just like any other
busy extent. Hence we still need to track btree blocks in the busy extent
tree, but we need to distinguish them from normal extents so we can apply
the necessary exceptions for btree block allocation.

Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_ag.h
===================================================================
--- xfs.orig/fs/xfs/xfs_ag.h	2011-01-17 22:03:15.000000000 +0100
+++ xfs/fs/xfs/xfs_ag.h	2011-01-17 22:32:06.541004201 +0100
@@ -188,6 +188,11 @@ struct xfs_busy_extent {
 	xfs_agblock_t	bno;
 	xfs_extlen_t	length;
 	xlog_tid_t	tid;		/* transaction that created this */
+	int		flags;
+};
+
+enum {
+	XFS_BUSY_FREELIST	= 0x0001, /* busy extent on freelist from abt */
 };
 
 /*
Index: xfs/fs/xfs/xfs_alloc.c
===================================================================
--- xfs.orig/fs/xfs/xfs_alloc.c	2011-01-17 22:30:54.000000000 +0100
+++ xfs/fs/xfs/xfs_alloc.c	2011-01-17 22:39:29.021005529 +0100
@@ -46,8 +46,12 @@ STATIC int xfs_alloc_ag_vextent_near(xfs
 STATIC int xfs_alloc_ag_vextent_size(xfs_alloc_arg_t *);
 STATIC int xfs_alloc_ag_vextent_small(xfs_alloc_arg_t *,
 		xfs_btree_cur_t *, xfs_agblock_t *, xfs_extlen_t *, int *);
+STATIC void xfs_alloc_busy_insert(struct xfs_trans *, xfs_agnumber_t,
+		xfs_agblock_t, xfs_extlen_t, int);
 STATIC int xfs_alloc_busy_search(struct xfs_mount *, xfs_agnumber_t,
 		xfs_agblock_t, xfs_extlen_t);
+STATIC void xfs_alloc_busy_force(struct xfs_mount *, xfs_agnumber_t,
+		xfs_agblock_t, xfs_extlen_t, int);
 
 /*
  * Internal functions.
@@ -1691,7 +1695,7 @@ xfs_free_ag_extent(
 		 * Mark the extent busy unless it comes from the freelist,
 		 * in which case it has already been marked busy.
 		 */
-		xfs_alloc_busy_insert(tp, agno, bno, len);
+		xfs_alloc_busy_insert(tp, agno, bno, len, 0);
 	}
 
 	XFS_STATS_INC(xs_freex);
@@ -1996,22 +2000,23 @@ xfs_alloc_get_freelist(
 	xfs_alloc_log_agf(tp, agbp, logflags);
 	*bnop = bno;
 
-	/*
-	 * As blocks are freed, they are added to the per-ag busy list and
-	 * remain there until the freeing transaction is committed to disk.
-	 * Now that we have allocated blocks, this list must be searched to see
-	 * if a block is being reused.  If one is, then the freeing transaction
-	 * must be pushed to disk before this transaction.
-	 *
-	 * We do this by setting the current transaction to a sync transaction
-	 * which guarantees that the freeing transaction is on disk before this
-	 * transaction. This is done instead of a synchronous log force here so
-	 * that we don't sit and wait with the AGF locked in the transaction
-	 * during the log force.
-	 */
 	if (type != XFS_FREELIST_BALANCE) {
-		if (xfs_alloc_busy_search(mp, agno, bno, 1))
-			xfs_trans_set_sync(tp);
+		/*
+		 * If this block is marked busy we may have to force out the
+		 * log to prevent reuse until the freeing transaction has been
+		 * commited.
+		 *
+		 * If we're just allocating the block to rebalance the the
+		 * freelist size we can skip this exercise as the block
+		 * just keeps its busy marking while migrating to the
+		 * allocation btree.
+		 *
+		 * If the block was freed from a btree and gets reallocated
+		 * to it we may skip the log force, but details are handled
+		 * by xfs_alloc_busy_force.
+		 */
+		xfs_alloc_busy_force(mp, agno, bno, 1,
+				     type == XFS_FREELIST_BTREE);
 	}
 
 	return 0;
@@ -2081,26 +2086,27 @@ xfs_alloc_put_freelist(
 	xfs_agblock_t		bno,	/* block being freed */
 	int			btreeblk) /* block came from a AGF btree */
 {
-	xfs_agf_t		*agf;	/* a.g. freespace structure */
+	xfs_mount_t		*mp = tp->t_mountp;
+	xfs_agf_t		*agf = XFS_BUF_TO_AGF(agbp);
+	xfs_agnumber_t		agno = be32_to_cpu(agf->agf_seqno);
 	xfs_agfl_t		*agfl;	/* a.g. free block array */
 	__be32			*blockp;/* pointer to array entry */
 	int			error;
 	int			logflags;
-	xfs_mount_t		*mp;	/* mount structure */
 	xfs_perag_t		*pag;	/* per allocation group data */
 
-	agf = XFS_BUF_TO_AGF(agbp);
-	mp = tp->t_mountp;
+	if (!agflbp) {
+		error = xfs_alloc_read_agfl(mp, tp, agno, &agflbp);
+		if (error)
+			return error;
+	}
 
-	if (!agflbp && (error = xfs_alloc_read_agfl(mp, tp,
-			be32_to_cpu(agf->agf_seqno), &agflbp)))
-		return error;
 	agfl = XFS_BUF_TO_AGFL(agflbp);
 	be32_add_cpu(&agf->agf_fllast, 1);
 	if (be32_to_cpu(agf->agf_fllast) == XFS_AGFL_SIZE(mp))
 		agf->agf_fllast = 0;
 
-	pag = xfs_perag_get(mp, be32_to_cpu(agf->agf_seqno));
+	pag = xfs_perag_get(mp, agno);
 	be32_add_cpu(&agf->agf_flcount, 1);
 	xfs_trans_agflist_delta(tp, 1);
 	pag->pagf_flcount++;
@@ -2123,6 +2129,14 @@ xfs_alloc_put_freelist(
 		(int)((xfs_caddr_t)blockp - (xfs_caddr_t)agfl),
 		(int)((xfs_caddr_t)blockp - (xfs_caddr_t)agfl +
 			sizeof(xfs_agblock_t) - 1));
+
+	/*
+	 * If it's a btree block, mark it busy as it has just been freed.
+	 * Otherwise we are just replenishing the free list with extents
+	 * that are already free so we don't need to track them.
+	 */
+	if (btreeblk)
+		xfs_alloc_busy_insert(tp, agno, bno, 1, XFS_BUSY_FREELIST);
 	return 0;
 }
 
@@ -2582,12 +2596,13 @@ error0:
  * logically into the one checkpoint. If the checkpoint sequences are
  * different, however, we still need to wait on a log force.
  */
-void
+STATIC void
 xfs_alloc_busy_insert(
 	struct xfs_trans	*tp,
 	xfs_agnumber_t		agno,
 	xfs_agblock_t		bno,
-	xfs_extlen_t		len)
+	xfs_extlen_t		len,
+	int			flags)
 {
 	struct xfs_busy_extent	*new;
 	struct xfs_busy_extent	*busyp;
@@ -2612,6 +2627,7 @@ xfs_alloc_busy_insert(
 	new->agno = agno;
 	new->bno = bno;
 	new->length = len;
+	new->flags = flags;
 	new->tid = xfs_log_get_trans_ident(tp);
 
 	INIT_LIST_HEAD(&new->list);
@@ -2733,6 +2749,62 @@ xfs_alloc_busy_search(
 	return match;
 }
 
+STATIC void
+xfs_alloc_busy_force(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agno,
+	xfs_agblock_t		bno,
+	xfs_extlen_t		len,
+	int			btreeblk)
+{
+	struct xfs_perag	*pag;
+	struct rb_node		*rbp;
+	struct xfs_busy_extent	*busyp;
+	int			match = 0;
+
+	pag = xfs_perag_get(mp, agno);
+	spin_lock(&pag->pagb_lock);
+
+	rbp = pag->pagb_tree.rb_node;
+
+	/* find closest start bno overlap */
+	while (rbp) {
+		busyp = rb_entry(rbp, struct xfs_busy_extent, rb_node);
+		if (bno < busyp->bno) {
+			/* may overlap, but exact start block is lower */
+			if (bno + len > busyp->bno) {
+				match = 1;
+				break;
+			}
+			rbp = rbp->rb_left;
+		} else if (bno > busyp->bno) {
+			/* may overlap, but exact start block is higher */
+			if (bno < busyp->bno + busyp->length) {
+				match = 1;
+				break;
+			}
+			rbp = rbp->rb_right;
+		} else {
+			/* bno matches busyp, length determines exact match */
+			match = 1;
+			break;
+		}
+	}
+
+	if (match && btreeblk && (busyp->flags & XFS_BUSY_FREELIST)) {
+		list_del_init(&busyp->list);
+		rb_erase(&busyp->rb_node, &pag->pagb_tree);
+		kmem_free(busyp);
+		match = 0;
+	}
+	spin_unlock(&pag->pagb_lock);
+	trace_xfs_alloc_busysearch(mp, agno, bno, len, !!match);
+	xfs_perag_put(pag);
+
+	if (match)
+		xfs_log_force(mp, XFS_LOG_SYNC);
+}
+
 /*
  * For a given extent [fbno, flen], search the busy extent list
  * to find a subset of the extent that is not busy.
Index: xfs/fs/xfs/xfs_alloc_btree.c
===================================================================
--- xfs.orig/fs/xfs/xfs_alloc_btree.c	2011-01-17 22:24:35.000000000 +0100
+++ xfs/fs/xfs/xfs_alloc_btree.c	2011-01-17 22:32:06.550048202 +0100
@@ -109,7 +109,6 @@ xfs_allocbt_free_block(
 	struct xfs_buf		*bp)
 {
 	struct xfs_buf		*agbp = cur->bc_private.a.agbp;
-	struct xfs_agf		*agf = XFS_BUF_TO_AGF(agbp);
 	xfs_agblock_t		bno;
 	int			error;
 
@@ -118,18 +117,6 @@ xfs_allocbt_free_block(
 	if (error)
 		return error;
 
-	/*
-	 * Since blocks move to the free list without the coordination used in
-	 * xfs_bmap_finish, we can't allow block to be available for
-	 * reallocation and non-transaction writing (user data) until we know
-	 * that the transaction that moved it to the free list is permanently
-	 * on disk. We track the blocks by declaring these blocks as "busy";
-	 * the busy list is maintained on a per-ag basis and each transaction
-	 * records which entries should be removed when the iclog commits to
-	 * disk. If a busy block is allocated, the iclog is pushed up to the
-	 * LSN that freed the block.
-	 */
-	xfs_alloc_busy_insert(cur->bc_tp, be32_to_cpu(agf->agf_seqno), bno, 1);
 	xfs_trans_agbtree_delta(cur->bc_tp, -1);
 	return 0;
 }
Index: xfs/fs/xfs/xfs_alloc.h
===================================================================
--- xfs.orig/fs/xfs/xfs_alloc.h	2011-01-17 22:30:06.456005528 +0100
+++ xfs/fs/xfs/xfs_alloc.h	2011-01-17 22:40:14.542034513 +0100
@@ -120,10 +120,6 @@ xfs_alloc_longest_free_extent(struct xfs
 
 #ifdef __KERNEL__
 void
-xfs_alloc_busy_insert(struct xfs_trans *tp, xfs_agnumber_t agno,
-	xfs_agblock_t bno, xfs_extlen_t len);
-
-void
 xfs_alloc_busy_clear(struct xfs_mount *mp, struct xfs_busy_extent *busyp);
 
 void
@@ -140,7 +136,8 @@ xfs_alloc_compute_maxlevels(
 	struct xfs_mount	*mp);	/* file system mount structure */
 
 /*
- * Destination of blocks allocated by xfs_alloc_get_freelist.
+ * Destination of blocks allocated by xfs_alloc_get_freelist  /
+ * source of blocks freed by xfs_alloc_put_freelist.
  */
 #define XFS_FREELIST_ALLOC	0
 #define XFS_FREELIST_BTREE	1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
