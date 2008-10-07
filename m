Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 07 Oct 2008 15:08:13 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m97M88pA009045
	for <xfs@oss.sgi.com>; Tue, 7 Oct 2008 15:08:08 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5525B1B0C579
	for <xfs@oss.sgi.com>; Tue,  7 Oct 2008 15:09:45 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id UAveCHiUbyrbbP6L for <xfs@oss.sgi.com>; Tue, 07 Oct 2008 15:09:45 -0700 (PDT)
Received: from dave by disturbed with local (Exim 4.69)
	(envelope-from <david@fromorbit.com>)
	id 1KnKkL-0002Vm-LV
	for xfs@oss.sgi.com; Wed, 08 Oct 2008 09:09:37 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 5/7] XFS: Do not classify freed allocation btree blocks as busy
Date: Wed,  8 Oct 2008 09:09:35 +1100
Message-Id: <1223417377-8679-6-git-send-email-david@fromorbit.com>
In-Reply-To: <1223417377-8679-1-git-send-email-david@fromorbit.com>
References: <1223417377-8679-1-git-send-email-david@fromorbit.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

During an allocation or freeing of an extent, we occasionally have
an interesting thing happen during a btree update. We may merge a
block as part of a record delete, then allocate it again immediately
afterwards when inserting a modified extent.
xfs_alloc_fixup_trees() does this sort of manipulation to the
btrees, and so can merge then immediately split the tree resulting
the in the same busy block being used from the free list.

Previously, this would trigger a synchronous log force of the entire
log (as the current transaction had a lsn of 0 until committed), but
continue to allow the extent to be used because if it is not on disk
now then it must have been freed and marked busy in this
transaction.

In the case of allocbt blocks, we log the fact that they get moved
to the freelist and we also log them when the move off the free list
back into the free space trees. When we move the blocks off the
freelist back to the trees, we mark the extent busy at that point so
that it doesn't get reused until the transaction is committed.

This means that as long as the block is on the AGFL and is only used
for allocbt blocks, we don't have to force the log to ensure prior
manipulating transactions are on disk as the process of log recovery
will replay the transactions in the correct order.

However, we still need to protect against the fact that as we
approach ENOSPC in an AG we can allocate data and metadata blocks
direct from the AGFL. In this case, we need to treat btree blocks
just like any other busy extent. Hence we still need to track btree
blocks in the busy extent tree, but we need to distinguish them from
normal extents so we can apply the necessary exceptions for btree
block allocation.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/xfs_ag.h          |    5 ++
 fs/xfs/xfs_alloc.c       |  181 +++++++++++++++++++++++++++++++++++-----------
 fs/xfs/xfs_alloc.h       |    5 --
 fs/xfs/xfs_alloc_btree.c |   13 ----
 4 files changed, 145 insertions(+), 59 deletions(-)

diff --git a/fs/xfs/xfs_ag.h b/fs/xfs/xfs_ag.h
index 7048d3d..ec87185 100644
--- a/fs/xfs/xfs_ag.h
+++ b/fs/xfs/xfs_ag.h
@@ -164,6 +164,11 @@ struct xfs_busy_extent {
 	xfs_agnumber_t	agno;
 	xfs_agblock_t	bno;
 	xfs_extlen_t	length;
+	int		flags;
+};
+
+enum {
+	XFS_BUSY_EXT_FREELIST = 0x0001,	/* busy extent on freelist from abt */
 };
 
 /*
diff --git a/fs/xfs/xfs_alloc.c b/fs/xfs/xfs_alloc.c
index f9d092e..e5fb397 100644
--- a/fs/xfs/xfs_alloc.c
+++ b/fs/xfs/xfs_alloc.c
@@ -90,8 +90,22 @@ STATIC int xfs_alloc_ag_vextent_small(xfs_alloc_arg_t *,
  *
  * xfs_alloc_mark_busy - add to the per-ag busy list
  * xfs_alloc_clear_busy - remove an item from the per-ag busy list
+ *
+ * A single transaction can move an allocbt block to the AGFL and
+ * then reallocate it immediately within the same transaction. It
+ * may even get reused in a different transaction. In both these cases,
+ * we don't need to do anything special; all the changes to the buffer
+ * including he fact it has been freed and reallocated will be logged.
+ *
+ * Hence we can provide a special exception for blocks that become
+ * busy via freelist manipulations - if they are going to be re-used
+ * as allocbt blocks then we don't need to wait for transaction
+ * completion to remove the extent from the busy list - we can
+ * do it the moment we pull the extent off the free list. To do this,
+ * though, we need to know that the busy extent was a allocbt block
+ * and record that in the busy extent structure.
  */
-static void
+STATIC void
 xfs_alloc_busy_insert(
 	struct xfs_perag	*pag,
 	xfs_agblock_t		bno,
@@ -105,24 +119,29 @@ xfs_alloc_busy_insert(
 		parent = *rbp;
 		busyp = rb_entry(parent, struct xfs_busy_extent, rb_node);
 
+		ASSERT(bno != busyp->bno);
 		if (bno < busyp->bno)
 			rbp = &(*rbp)->rb_left;
 		else if (bno > busyp->bno)
 			rbp = &(*rbp)->rb_right;
-		else
-			BUG();
+		else {
+			cmn_err(CE_WARN,
+				"XFS: ignoring duplicate busy extent.\n");
+			ASSERT(0);
+		}
 	}
 
 	rb_link_node(node, parent, rbp);
 	rb_insert_color(node, &pag->pagb_tree);
 }
 
-void
+STATIC void
 xfs_alloc_mark_busy(
 	struct xfs_trans	*tp,
 	xfs_agnumber_t		agno,
 	xfs_agblock_t		bno,
-	xfs_extlen_t		len)
+	xfs_extlen_t		len,
+	int			freelist)	/* metadata block to freelist */
 {
 	struct xfs_busy_extent	*busyp;
 	struct xfs_perag	*pag;
@@ -142,6 +161,8 @@ xfs_alloc_mark_busy(
 	busyp->agno = agno;
 	busyp->bno = bno;
 	busyp->length = len;
+	if (freelist)
+		busyp->flags |= XFS_BUSY_EXT_FREELIST; 
 
 	pag = xfs_perag_get(tp->t_mountp, agno);
 	spin_lock(&pag->pagb_lock);
@@ -153,23 +174,21 @@ xfs_alloc_mark_busy(
 }
 
 /*
- * Search for a busy extent within the range of the extent we are about to
- * allocate.
+ * Search for a busy extent that overlaps the range of the extent we
+ * are about to allocate.
  */
 static struct xfs_busy_extent *
-xfs_alloc_busy_search(
+__xfs_alloc_busy_search(
 	struct xfs_trans	*tp,
+	struct xfs_perag	*pag,
 	xfs_agnumber_t		agno,
 	xfs_agblock_t		bno,
 	xfs_extlen_t		len)
 {
-	struct xfs_perag	*pag;
 	struct rb_node		*rbp;
 	xfs_agblock_t		uend, bend;
 
 	uend = bno + len - 1;
-	pag = xfs_perag_get(tp->t_mountp, agno);
-	spin_lock(&pag->pagb_lock);
 	rbp = pag->pagb_tree.rb_node;
 	while (rbp) {
 		struct xfs_busy_extent	*busyp;
@@ -181,17 +200,31 @@ xfs_alloc_busy_search(
 		else if (bno > bend)
 			rbp = rbp->rb_right;
 		else {
-			/* (start1,length1) within (start2, length2) */
+			/* (start1,length1) overlaps (start2, length2) */
 			TRACE_BUSYSEARCH("xfs_alloc_busy_search",
 					 "found1", agno, bno, len, tp);
-			spin_unlock(&pag->pagb_lock);
-			xfs_perag_put(pag);
 			return busyp;
 		}
 	}
+	return NULL;
+}
+
+STATIC struct xfs_busy_extent *
+xfs_alloc_busy_search(
+	struct xfs_trans	*tp,
+	xfs_agnumber_t		agno,
+	xfs_agblock_t		bno,
+	xfs_extlen_t		len)
+{
+	struct xfs_busy_extent	*busyp;
+	struct xfs_perag	*pag = xfs_perag_get(tp->t_mountp, agno);
+
+	spin_lock(&pag->pagb_lock);
+	busyp = __xfs_alloc_busy_search(tp, pag, agno, bno, len);
 	spin_unlock(&pag->pagb_lock);
+
 	xfs_perag_put(pag);
-	return NULL;
+	return busyp;
 }
 
 void
@@ -307,6 +340,44 @@ xfs_alloc_get_rec(
 }
 
 /*
+ * If the extent is busy via xfs_alloc_put_freelist(), and we are
+ * currently reusing it via xfs_alloc_get_freelist(), remove the
+ * extent from the busy list. Do this search and remove atomically
+ * so we don't race with transaction completion calling
+ * xfs_alloc_clear_busy().
+ *
+ * We should never get the situation where an extent on the freelist
+ * is busy due to other methods of freeing extents. If it happens,
+ * let the caller handle it (e.g. by using a synchronous log
+ * force to wait for the extent to become unbusy).
+ */
+static struct xfs_busy_extent *
+xfs_alloc_search_clear_busy_freelist(
+	struct xfs_trans	*tp,
+	xfs_agnumber_t		agno,
+	xfs_agblock_t		bno,
+	xfs_extlen_t		len,
+	int			btreeblk)
+{
+	struct xfs_busy_extent	*busyp;
+	struct xfs_perag	*pag = xfs_perag_get(tp->t_mountp, agno);
+
+	spin_lock(&pag->pagb_lock);
+	busyp = __xfs_alloc_busy_search(tp, pag, agno, bno, len);
+	if (busyp && btreeblk && (busyp->flags & XFS_BUSY_EXT_FREELIST)) {
+		TRACE_UNBUSY("xfs_alloc_search_clear_busy_freelist",
+			"found", busyp->agno, busyp->bno, busyp->length, tp);
+		rb_erase(&busyp->rb_node, &pag->pagb_tree);
+		kmem_free(busyp);
+		busyp = NULL;
+	}
+	spin_unlock(&pag->pagb_lock);
+
+	xfs_perag_put(pag);
+	return busyp;
+}
+
+/*
  * Compute aligned version of the found extent.
  * Takes alignment and min length into account.
  */
@@ -1946,17 +2017,16 @@ xfs_free_ag_extent(
 		agno, bno, len, isfl);
 
 	/*
-	 * Since blocks move to the free list without the coordination
-	 * used in xfs_bmap_finish, we can't allow block to be available
-	 * for reallocation and non-transaction writing (user data)
-	 * until we know that the transaction that moved it to the free
-	 * list is permanently on disk.  We track the blocks by declaring
-	 * these blocks as "busy"; the busy list is maintained on a per-ag
-	 * basis and each transaction records which entries should be removed
-	 * when the iclog commits to disk.  If a busy block is allocated,
-	 * the iclog is pushed up to the LSN that freed the block.
+	 * Since blocks move to the free list without the coordination used in
+	 * xfs_bmap_finish, we can't allow block to be available for
+	 * reallocation and non-transaction writing (user data) until we know
+	 * that the transaction that moved it to the free list is permanently
+	 * on disk.  We track the blocks by declaring these blocks as "busy";
+	 * the busy list is maintained on a per-ag basis and the extent cannot
+	 * be reallocated until the transaction that frees it is safely on
+	 * disk.
 	 */
-	xfs_alloc_mark_busy(tp, agno, bno, len);
+	xfs_alloc_mark_busy(tp, agno, bno, len, 0);
 	return 0;
 
  error0:
@@ -2177,6 +2247,29 @@ xfs_alloc_fix_freelist(
 /*
  * Get a block from the freelist.
  * Returns with the buffer for the block gotten.
+ *
+ * Notes on busy extent list maniipulations:
+ *
+ * As blocks are freed, they are added to the per-ag busy list and
+ * remain there until the freeing transaction is committed to disk.
+ * Now that we have allocated blocks, this list must be searched to see
+ * if a block is being reused.
+ *
+ * The only way we can get a busy extent on the freelist is when an
+ * alloc btree block is freed. Because this is a metadata block and all
+ * modifications are logged, we don't need to push the freeing
+ * transaction to disk if this allocation is for another btree block -
+ * the natural ordering of the log transactions will ensure that
+ * recovery will do the right thing. However, we need to remove it from
+ * the busy extent list as we have reused it.
+ *
+ * If this is to be used as any other type of block, we really
+ * need to ensure that the freeing transaction is on disk before we
+ * re-use it. The above case is the common case, so only when we are
+ * near ENOSPC will we be allocating other metadata or data blocks
+ * from the free list. In that case, waiting here for a log force
+ * to push the transaction to disk is not a big deal because it should
+ * be very infrequent.
  */
 int				/* error */
 xfs_alloc_get_freelist(
@@ -2234,22 +2327,11 @@ xfs_alloc_get_freelist(
 	xfs_alloc_log_agf(tp, agbp, logflags);
 	*bnop = bno;
 
-	/*
-	 * As blocks are freed, they are added to the per-ag busy list
-	 * and remain there until the freeing transaction is committed to
-	 * disk.  Now that we have allocated blocks, this list must be
-	 * searched to see if a block is being reused.  If one is, then
-	 * the freeing transaction must be pushed to disk before this
-	 * transaction.
-	 *
-	 * We do this by setting the current transaction
-	 * to a sync transaction which guarantees that the freeing transaction
-	 * is on disk before this transaction. This is done instead of a
-	 * synchronous log force here so that we don't sit and wait with
-	 * the AGF locked in the transaction during the log force.
-	 */
-	if (xfs_alloc_busy_search(tp, be32_to_cpu(agf->agf_seqno), bno, 1))
-		xfs_trans_set_sync(tp);
+	/* handle busy extents */
+	if (xfs_alloc_search_clear_busy_freelist(tp,
+			be32_to_cpu(agf->agf_seqno), bno, 1, btreeblk))
+		xfs_log_force(mp, 0, XFS_LOG_FORCE|XFS_LOG_SYNC);
+
 	return 0;
 }
 
@@ -2306,6 +2388,15 @@ xfs_alloc_pagf_init(
 
 /*
  * Put the block on the freelist for the allocation group.
+ *
+ * Notes on handling busy extents:
+ *
+ * If this is a btree block, we need to let the busy extent list handling
+ * know about it so that we can optimise xfs_alloc_get_freelist() to allow
+ * us to re-use extents that were btree blocks without problems. We do this
+ * so that the entire freelist is available for btree blocks and we can do
+ * this because all modifications, allocations and freeing of allocbt blocks
+ * are logged and hence strongly ordered.
  */
 int					/* error */
 xfs_alloc_put_freelist(
@@ -2357,6 +2448,14 @@ xfs_alloc_put_freelist(
 		(int)((xfs_caddr_t)blockp - (xfs_caddr_t)agfl),
 		(int)((xfs_caddr_t)blockp - (xfs_caddr_t)agfl +
 			sizeof(xfs_agblock_t) - 1));
+
+	/*
+	 * If it's a btree block, mark it busy as it has just been freed.
+	 * Otherwise we are just replenishing the free list with extents that
+	 * are already free so we don't need to track them.
+	 */
+	if (btreeblk)
+		xfs_alloc_mark_busy(tp, be32_to_cpu(agf->agf_seqno), bno, 1, 1);
 	return 0;
 }
 
diff --git a/fs/xfs/xfs_alloc.h b/fs/xfs/xfs_alloc.h
index 21040af..69111dd 100644
--- a/fs/xfs/xfs_alloc.h
+++ b/fs/xfs/xfs_alloc.h
@@ -122,11 +122,6 @@ extern ktrace_t *xfs_alloc_trace_buf;
 #define	XFS_ALLOC_KTRACE_BUSYSEARCH	6
 #endif
 
-void
-xfs_alloc_mark_busy(xfs_trans_t *tp,
-		xfs_agnumber_t agno,
-		xfs_agblock_t bno,
-		xfs_extlen_t len);
 
 void
 xfs_alloc_clear_busy(xfs_trans_t *tp, struct xfs_busy_extent *busyp);
diff --git a/fs/xfs/xfs_alloc_btree.c b/fs/xfs/xfs_alloc_btree.c
index 9e63f8c..f41bfae 100644
--- a/fs/xfs/xfs_alloc_btree.c
+++ b/fs/xfs/xfs_alloc_btree.c
@@ -119,19 +119,6 @@ xfs_allocbt_free_block(
 	error = xfs_alloc_put_freelist(cur->bc_tp, agbp, NULL, bno, 1);
 	if (error)
 		return error;
-
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
-	xfs_alloc_mark_busy(cur->bc_tp, be32_to_cpu(agf->agf_seqno), bno, 1);
 	xfs_trans_agbtree_delta(cur->bc_tp, -1);
 	return 0;
 }
-- 
1.5.6.5
