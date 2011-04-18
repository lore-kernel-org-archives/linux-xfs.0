Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3I6vIwX238903 for <xfs@oss.sgi.com>; Mon, 18 Apr 2011 01:57:20 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 89F661B750B6
	for <xfs@oss.sgi.com>; Mon, 18 Apr 2011 00:00:44 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 1JtZMjSfJ3mGMgs2 for
	<xfs@oss.sgi.com>; Mon, 18 Apr 2011 00:00:44 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.72 #1 (Red Hat
	Linux)) id 1QBiRv-0007Vu-Ui
	for xfs@oss.sgi.com; Mon, 18 Apr 2011 07:00:44 +0000
Message-Id: <20110418070043.915023373@bombadil.infradead.org>
Date: Mon, 18 Apr 2011 02:59:39 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 3/4] xfs: exact busy extent tracking
References: <20110418065936.355024592@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-better-busy-extent-tracking
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

Update the extent tree in case we have to reuse a busy extent, so that it
always is kept uptodate.  This is done by replacing the busy list searches
with a new xfs_alloc_busy_reuse helper, which updates the busy extent tree
in case of a reuse.  This allows us to allow reusing metadata extents
unconditionally, and thus avoid log forces especially for allocation btree
blocks.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_alloc.c
===================================================================
--- xfs.orig/fs/xfs/xfs_alloc.c	2011-04-15 09:40:41.397299257 +0200
+++ xfs/fs/xfs/xfs_alloc.c	2011-04-15 09:41:11.343803689 +0200
@@ -1396,8 +1396,9 @@ xfs_alloc_ag_vextent_small(
 		if (error)
 			goto error0;
 		if (fbno != NULLAGBLOCK) {
-			if (xfs_alloc_busy_search(args->mp, args->agno, fbno, 1))
-				xfs_trans_set_sync(args->tp);
+			xfs_alloc_busy_reuse(args->mp, args->agno, fbno, 1,
+					     args->userdata);
+
 			if (args->userdata) {
 				xfs_buf_t	*bp;
 
@@ -2475,100 +2476,6 @@ error0:
 	return error;
 }
 
-
-/*
- * AG Busy list management
- * The busy list contains block ranges that have been freed but whose
- * transactions have not yet hit disk.  If any block listed in a busy
- * list is reused, the transaction that freed it must be forced to disk
- * before continuing to use the block.
- *
- * xfs_alloc_busy_insert - add to the per-ag busy list
- * xfs_alloc_busy_clear - remove an item from the per-ag busy list
- * xfs_alloc_busy_search - search for a busy extent
- */
-
-/*
- * Insert a new extent into the busy tree.
- *
- * The busy extent tree is indexed by the start block of the busy extent.
- * there can be multiple overlapping ranges in the busy extent tree but only
- * ever one entry at a given start block. The reason for this is that
- * multi-block extents can be freed, then smaller chunks of that extent
- * allocated and freed again before the first transaction commit is on disk.
- * If the exact same start block is freed a second time, we have to wait for
- * that busy extent to pass out of the tree before the new extent is inserted.
- * There are two main cases we have to handle here.
- *
- * The first case is a transaction that triggers a "free - allocate - free"
- * cycle. This can occur during btree manipulations as a btree block is freed
- * to the freelist, then allocated from the free list, then freed again. In
- * this case, the second extxpnet free is what triggers the duplicate and as
- * such the transaction IDs should match. Because the extent was allocated in
- * this transaction, the transaction must be marked as synchronous. This is
- * true for all cases where the free/alloc/free occurs in the one transaction,
- * hence the addition of the ASSERT(tp->t_flags & XFS_TRANS_SYNC) to this case.
- * This serves to catch violations of the second case quite effectively.
- *
- * The second case is where the free/alloc/free occur in different
- * transactions. In this case, the thread freeing the extent the second time
- * can't mark the extent busy immediately because it is already tracked in a
- * transaction that may be committing.  When the log commit for the existing
- * busy extent completes, the busy extent will be removed from the tree. If we
- * allow the second busy insert to continue using that busy extent structure,
- * it can be freed before this transaction is safely in the log.  Hence our
- * only option in this case is to force the log to remove the existing busy
- * extent from the list before we insert the new one with the current
- * transaction ID.
- *
- * The problem we are trying to avoid in the free-alloc-free in separate
- * transactions is most easily described with a timeline:
- *
- *      Thread 1	Thread 2	Thread 3	xfslogd
- *	xact alloc
- *	free X
- *	mark busy
- *	commit xact
- *	free xact
- *			xact alloc
- *			alloc X
- *			busy search
- *			mark xact sync
- *			commit xact
- *			free xact
- *			force log
- *			checkpoint starts
- *			....
- *					xact alloc
- *					free X
- *					mark busy
- *					finds match
- *					*** KABOOM! ***
- *					....
- *							log IO completes
- *							unbusy X
- *			checkpoint completes
- *
- * By issuing a log force in thread 3 @ "KABOOM", the thread will block until
- * the checkpoint completes, and the busy extent it matched will have been
- * removed from the tree when it is woken. Hence it can then continue safely.
- *
- * However, to ensure this matching process is robust, we need to use the
- * transaction ID for identifying transaction, as delayed logging results in
- * the busy extent and transaction lifecycles being different. i.e. the busy
- * extent is active for a lot longer than the transaction.  Hence the
- * transaction structure can be freed and reallocated, then mark the same
- * extent busy again in the new transaction. In this case the new transaction
- * will have a different tid but can have the same address, and hence we need
- * to check against the tid.
- *
- * Future: for delayed logging, we could avoid the log force if the extent was
- * first freed in the current checkpoint sequence. This, however, requires the
- * ability to pin the current checkpoint in memory until this transaction
- * commits to ensure that both the original free and the current one combine
- * logically into the one checkpoint. If the checkpoint sequences are
- * different, however, we still need to wait on a log force.
- */
 void
 xfs_alloc_busy_insert(
 	struct xfs_trans	*tp,
@@ -2580,9 +2487,7 @@ xfs_alloc_busy_insert(
 	struct xfs_busy_extent	*busyp;
 	struct xfs_perag	*pag;
 	struct rb_node		**rbp;
-	struct rb_node		*parent;
-	int			match;
-
+	struct rb_node		*parent = NULL;
 
 	new = kmem_zalloc(sizeof(struct xfs_busy_extent), KM_MAYFAIL);
 	if (!new) {
@@ -2591,7 +2496,7 @@ xfs_alloc_busy_insert(
 		 * block, make this a synchronous transaction to insure that
 		 * the block is not reused before this transaction commits.
 		 */
-		trace_xfs_alloc_busy(tp, agno, bno, len, 1);
+		trace_xfs_alloc_busy_enomem(tp->t_mountp, agno, bno, len);
 		xfs_trans_set_sync(tp);
 		return;
 	}
@@ -2599,66 +2504,28 @@ xfs_alloc_busy_insert(
 	new->agno = agno;
 	new->bno = bno;
 	new->length = len;
-	new->tid = xfs_log_get_trans_ident(tp);
-
 	INIT_LIST_HEAD(&new->list);
 
 	/* trace before insert to be able to see failed inserts */
-	trace_xfs_alloc_busy(tp, agno, bno, len, 0);
+	trace_xfs_alloc_busy(tp->t_mountp, agno, bno, len);
 
 	pag = xfs_perag_get(tp->t_mountp, new->agno);
-restart:
 	spin_lock(&pag->pagb_lock);
 	rbp = &pag->pagb_tree.rb_node;
-	parent = NULL;
-	busyp = NULL;
-	match = 0;
-	while (*rbp && match >= 0) {
+	while (*rbp) {
 		parent = *rbp;
 		busyp = rb_entry(parent, struct xfs_busy_extent, rb_node);
 
 		if (new->bno < busyp->bno) {
-			/* may overlap, but exact start block is lower */
 			rbp = &(*rbp)->rb_left;
-			if (new->bno + new->length > busyp->bno)
-				match = busyp->tid == new->tid ? 1 : -1;
+			ASSERT(new->bno + new->length <= busyp->bno);
 		} else if (new->bno > busyp->bno) {
-			/* may overlap, but exact start block is higher */
 			rbp = &(*rbp)->rb_right;
-			if (bno < busyp->bno + busyp->length)
-				match = busyp->tid == new->tid ? 1 : -1;
+			ASSERT(bno >= busyp->bno + busyp->length);
 		} else {
-			match = busyp->tid == new->tid ? 1 : -1;
-			break;
+			ASSERT(0);
 		}
 	}
-	if (match < 0) {
-		/* overlap marked busy in different transaction */
-		spin_unlock(&pag->pagb_lock);
-		xfs_log_force(tp->t_mountp, XFS_LOG_SYNC);
-		goto restart;
-	}
-	if (match > 0) {
-		/*
-		 * overlap marked busy in same transaction. Update if exact
-		 * start block match, otherwise combine the busy extents into
-		 * a single range.
-		 */
-		if (busyp->bno == new->bno) {
-			busyp->length = max(busyp->length, new->length);
-			spin_unlock(&pag->pagb_lock);
-			ASSERT(tp->t_flags & XFS_TRANS_SYNC);
-			xfs_perag_put(pag);
-			kmem_free(new);
-			return;
-		}
-		rb_erase(&busyp->rb_node, &pag->pagb_tree);
-		new->length = max(busyp->bno + busyp->length,
-					new->bno + new->length) -
-				min(busyp->bno, new->bno);
-		new->bno = min(busyp->bno, new->bno);
-	} else
-		busyp = NULL;
 
 	rb_link_node(&new->rb_node, parent, rbp);
 	rb_insert_color(&new->rb_node, &pag->pagb_tree);
@@ -2666,7 +2533,6 @@ restart:
 	list_add(&new->list, &tp->t_busy);
 	spin_unlock(&pag->pagb_lock);
 	xfs_perag_put(pag);
-	kmem_free(busyp);
 }
 
 /*
@@ -2715,12 +2581,196 @@ xfs_alloc_busy_search(
 		}
 	}
 	spin_unlock(&pag->pagb_lock);
-	trace_xfs_alloc_busysearch(mp, agno, bno, len, !!match);
 	xfs_perag_put(pag);
 	return match;
 }
 
 /*
+ * The found free extent [fbno, fend] overlaps part or all of the given busy
+ * extent.  If the overlap covers the beginning, the end, or all of the busy
+ * extent, the overlapping portion can be made unbusy and used for the
+ * allocation.  We can't split a busy extent because we can't modify a
+ * transaction/CIL context busy list, but we can update an entries block
+ * number or length.
+ *
+ * Returns true if the extent can safely be reused, or false if the search
+ * needs to be restarted.
+ */
+STATIC bool
+xfs_alloc_busy_update_extent(
+	struct xfs_mount	*mp,
+	struct xfs_perag	*pag,
+	struct xfs_busy_extent	*busyp,
+	xfs_agblock_t		fbno,
+	xfs_extlen_t		flen,
+	bool			userdata)
+{
+	xfs_agblock_t		fend = fbno + flen;
+	xfs_agblock_t		bbno = busyp->bno;
+	xfs_agblock_t		bend = bbno + busyp->length;
+
+	/*
+	 * If there is a busy extent overlapping a user allocation, we have
+	 * no choice but to force the log and retry the search.
+	 *
+	 * Fortunately this does not happen during normal operation, but
+	 * only if the filesystem is very low on space and has to dip into
+	 * the AGFL for normal allocations.
+	 */
+	if (userdata)
+		goto out_force_log;
+
+	if (bbno < fbno && bend > fend) {
+		/*
+		 * Case 1:
+		 *    bbno           bend
+		 *    +BBBBBBBBBBBBBBBBB+
+		 *        +---------+
+		 *        fbno   fend
+		 */
+
+		/*
+		 * We would have to split the busy extent to be able to track
+		 * it correct, which we cannot do because we would have to
+		 * modify the list of busy extents attached to the transaction
+		 * or CIL context, which is immutable.
+		 *
+		 * Force out the log to clear the busy extent and retry the
+		 * search.
+		 */
+		goto out_force_log;
+	} else if (bbno >= fbno && bend <= fend) {
+		/*
+		 * Case 2:
+		 *    bbno           bend
+		 *    +BBBBBBBBBBBBBBBBB+
+		 *    +-----------------+
+		 *    fbno           fend
+		 *
+		 * Case 3:
+		 *    bbno           bend
+		 *    +BBBBBBBBBBBBBBBBB+
+		 *    +--------------------------+
+		 *    fbno                    fend
+		 *
+		 * Case 4:
+		 *             bbno           bend
+		 *             +BBBBBBBBBBBBBBBBB+
+		 *    +--------------------------+
+		 *    fbno                    fend
+		 *
+		 * Case 5:
+		 *             bbno           bend
+		 *             +BBBBBBBBBBBBBBBBB+
+		 *    +-----------------------------------+
+		 *    fbno                             fend
+		 *
+		 */
+
+		/*
+		 * The busy extent is fully covered by the extent we are
+		 * allocating, and can simply be removed from the rbtree.
+		 * However we cannot remove it from the immutable list
+		 * tracking busy extents in the transaction or CIL context,
+		 * so set the length to zero to mark it invalid.
+		 *
+		 * We also need to restart the busy extent search from the
+		 * tree root, because erasing the node can rearrange the
+		 * tree topology.
+		 */
+		rb_erase(&busyp->rb_node, &pag->pagb_tree);
+		busyp->length = 0;
+		return false;
+	} else if (fend < bend) {
+		/*
+		 * Case 6:
+		 *              bbno           bend
+		 *             +BBBBBBBBBBBBBBBBB+
+		 *             +---------+
+		 *             fbno   fend
+		 *
+		 * Case 7:
+		 *             bbno           bend
+		 *             +BBBBBBBBBBBBBBBBB+
+		 *    +------------------+
+		 *    fbno            fend
+		 *
+		 */
+		busyp->bno = fend;
+	} else if (bbno < fbno) {
+		/*
+		 * Case 8:
+		 *    bbno           bend
+		 *    +BBBBBBBBBBBBBBBBB+
+		 *        +-------------+
+		 *        fbno       fend
+		 *
+		 * Case 9:
+		 *    bbno           bend
+		 *    +BBBBBBBBBBBBBBBBB+
+		 *        +----------------------+
+		 *        fbno                fend
+		 */
+		busyp->length = fbno - busyp->bno;
+	} else {
+		ASSERT(0);
+	}
+
+	trace_xfs_alloc_busy_reuse(mp, pag->pag_agno, fbno, flen);
+	return true;
+
+out_force_log:
+	spin_unlock(&pag->pagb_lock);
+	xfs_log_force(mp, XFS_LOG_SYNC);
+	trace_xfs_alloc_busy_force(mp, pag->pag_agno, fbno, flen);
+	spin_lock(&pag->pagb_lock);
+	return false;
+}
+
+
+/*
+ * For a given extent [fbno, flen], make sure we can reuse it safely.
+ */
+void
+xfs_alloc_busy_reuse(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agno,
+	xfs_agblock_t		fbno,
+	xfs_extlen_t		flen,
+	bool			userdata)
+{
+	struct xfs_perag	*pag;
+	struct rb_node		*rbp;
+
+	ASSERT(flen > 0);
+
+	pag = xfs_perag_get(mp, agno);
+	spin_lock(&pag->pagb_lock);
+restart:
+	rbp = pag->pagb_tree.rb_node;
+	while (rbp) {
+		struct xfs_busy_extent *busyp =
+			rb_entry(rbp, struct xfs_busy_extent, rb_node);
+		xfs_agblock_t	bbno = busyp->bno;
+		xfs_agblock_t	bend = bbno + busyp->length;
+
+		if (fbno + flen <= bbno) {
+			rbp = rbp->rb_left;
+			continue;
+		} else if (fbno >= bend) {
+			rbp = rbp->rb_right;
+			continue;
+		}
+
+		if (!xfs_alloc_busy_update_extent(mp, pag, busyp, fbno, flen,
+						  userdata))
+			goto restart;
+	}
+	spin_unlock(&pag->pagb_lock);
+	xfs_perag_put(pag);
+}
+
+/*
  * For a given extent [fbno, flen], search the busy extent list to find a
  * subset of the extent that is not busy.  If *rlen is smaller than
  * args->minlen no suitable extent could be found, and the higher level
@@ -2734,13 +2784,16 @@ xfs_alloc_busy_trim(
 	xfs_agblock_t		*rbno,
 	xfs_extlen_t		*rlen)
 {
-	xfs_agblock_t		fbno = bno;
-	xfs_extlen_t		flen = len;
+	xfs_agblock_t		fbno;
+	xfs_extlen_t		flen;
 	struct rb_node		*rbp;
 
-	ASSERT(flen > 0);
+	ASSERT(len > 0);
 
 	spin_lock(&args->pag->pagb_lock);
+restart:
+	fbno = bno;
+	flen = len;
 	rbp = args->pag->pagb_tree.rb_node;
 	while (rbp && flen >= args->minlen) {
 		struct xfs_busy_extent *busyp =
@@ -2757,6 +2810,18 @@ xfs_alloc_busy_trim(
 			continue;
 		}
 
+		/*
+		 * If this is a metadata allocation, try to reuse the busy
+		 * extent instead of trimming the allocation.
+		 */
+		if (!args->userdata) {
+			if (!xfs_alloc_busy_update_extent(args->mp, args->pag,
+							  busyp, fbno, flen,
+							  false))
+				goto restart;
+			continue;
+		}
+
 		if (bbno <= fbno) {
 			/* start overlap */
 
@@ -2894,6 +2959,11 @@ fail:
 	 * re-check if the trimmed extent satisfies the minlen requirement.
 	 */
 	spin_unlock(&args->pag->pagb_lock);
+	if (fbno != bno || flen != len) {
+		trace_xfs_alloc_busy_trim(args->mp, args->agno, bno, len,
+					  fbno, flen);
+	}
+	trace_xfs_alloc_busy_trim(args->mp, args->agno, bno, len, fbno, 0);
 	*rbno = fbno;
 	*rlen = 0;
 }
@@ -2905,17 +2975,15 @@ xfs_alloc_busy_clear(
 {
 	struct xfs_perag	*pag;
 
-	trace_xfs_alloc_unbusy(mp, busyp->agno, busyp->bno,
-						busyp->length);
-
-	ASSERT(xfs_alloc_busy_search(mp, busyp->agno, busyp->bno,
-						busyp->length) == 1);
-
 	list_del_init(&busyp->list);
 
 	pag = xfs_perag_get(mp, busyp->agno);
 	spin_lock(&pag->pagb_lock);
-	rb_erase(&busyp->rb_node, &pag->pagb_tree);
+	if (busyp->length) {
+		trace_xfs_alloc_busy_clear(mp, busyp->agno, busyp->bno,
+						busyp->length);
+		rb_erase(&busyp->rb_node, &pag->pagb_tree);
+	}
 	spin_unlock(&pag->pagb_lock);
 	xfs_perag_put(pag);
 
Index: xfs/fs/xfs/xfs_alloc.h
===================================================================
--- xfs.orig/fs/xfs/xfs_alloc.h	2011-04-15 09:39:25.411044244 +0200
+++ xfs/fs/xfs/xfs_alloc.h	2011-04-15 09:40:41.727297470 +0200
@@ -145,6 +145,10 @@ xfs_alloc_busy_clear(struct xfs_mount *m
 int
 xfs_alloc_busy_search(struct xfs_mount *mp, xfs_agnumber_t agno,
 	xfs_agblock_t bno, xfs_extlen_t len);
+
+void
+xfs_alloc_busy_reuse(struct xfs_mount *mp, xfs_agnumber_t agno,
+	xfs_agblock_t fbno, xfs_extlen_t flen, bool userdata);
 #endif	/* __KERNEL__ */
 
 /*
Index: xfs/fs/xfs/xfs_alloc_btree.c
===================================================================
--- xfs.orig/fs/xfs/xfs_alloc_btree.c	2011-04-15 09:40:41.093967567 +0200
+++ xfs/fs/xfs/xfs_alloc_btree.c	2011-04-15 09:40:41.727297470 +0200
@@ -94,8 +94,8 @@ xfs_allocbt_alloc_block(
 		*stat = 0;
 		return 0;
 	}
-	if (xfs_alloc_busy_search(cur->bc_mp, cur->bc_private.a.agno, bno, 1))
-		xfs_trans_set_sync(cur->bc_tp);
+
+	xfs_alloc_busy_reuse(cur->bc_mp, cur->bc_private.a.agno, bno, 1, false);
 
 	xfs_trans_agbtree_delta(cur->bc_tp, 1);
 	new->s = cpu_to_be32(bno);
@@ -120,17 +120,6 @@ xfs_allocbt_free_block(
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
 	xfs_alloc_busy_insert(cur->bc_tp, be32_to_cpu(agf->agf_seqno), bno, 1);
 	xfs_trans_agbtree_delta(cur->bc_tp, -1);
 	return 0;
Index: xfs/fs/xfs/xfs_ag.h
===================================================================
--- xfs.orig/fs/xfs/xfs_ag.h	2011-04-15 09:39:25.434377449 +0200
+++ xfs/fs/xfs/xfs_ag.h	2011-04-15 09:40:41.727297470 +0200
@@ -187,7 +187,6 @@ struct xfs_busy_extent {
 	xfs_agnumber_t	agno;
 	xfs_agblock_t	bno;
 	xfs_extlen_t	length;
-	xlog_tid_t	tid;		/* transaction that created this */
 };
 
 /*
Index: xfs/fs/xfs/xfs_log.c
===================================================================
--- xfs.orig/fs/xfs/xfs_log.c	2011-04-15 09:39:25.447710711 +0200
+++ xfs/fs/xfs/xfs_log.c	2011-04-15 09:40:41.730630785 +0200
@@ -3248,13 +3248,6 @@ xfs_log_ticket_get(
 	return ticket;
 }
 
-xlog_tid_t
-xfs_log_get_trans_ident(
-	struct xfs_trans	*tp)
-{
-	return tp->t_ticket->t_tid;
-}
-
 /*
  * Allocate and initialise a new log ticket.
  */
Index: xfs/fs/xfs/xfs_log.h
===================================================================
--- xfs.orig/fs/xfs/xfs_log.h	2011-04-15 09:39:25.461043971 +0200
+++ xfs/fs/xfs/xfs_log.h	2011-04-15 09:40:41.733964100 +0200
@@ -189,8 +189,6 @@ void	  xlog_iodone(struct xfs_buf *);
 struct xlog_ticket *xfs_log_ticket_get(struct xlog_ticket *ticket);
 void	  xfs_log_ticket_put(struct xlog_ticket *ticket);
 
-xlog_tid_t xfs_log_get_trans_ident(struct xfs_trans *tp);
-
 void	xfs_log_commit_cil(struct xfs_mount *mp, struct xfs_trans *tp,
 				struct xfs_log_vec *log_vector,
 				xfs_lsn_t *commit_lsn, int flags);
Index: xfs/fs/xfs/xfs_log_priv.h
===================================================================
--- xfs.orig/fs/xfs/xfs_log_priv.h	2011-04-15 09:39:25.474377234 +0200
+++ xfs/fs/xfs/xfs_log_priv.h	2011-04-15 09:40:41.733964100 +0200
@@ -146,6 +146,8 @@ static inline uint xlog_get_client_id(__
 					   shutdown */
 #define XLOG_TAIL_WARN		0x10	/* log tail verify warning issued */
 
+typedef __uint32_t xlog_tid_t;
+
 #ifdef __KERNEL__
 /*
  * Below are states for covering allocation transactions.
Index: xfs/fs/xfs/xfs_types.h
===================================================================
--- xfs.orig/fs/xfs/xfs_types.h	2011-04-15 09:39:25.487710494 +0200
+++ xfs/fs/xfs/xfs_types.h	2011-04-15 09:40:41.733964100 +0200
@@ -73,8 +73,6 @@ typedef	__int32_t	xfs_tid_t;	/* transact
 typedef	__uint32_t	xfs_dablk_t;	/* dir/attr block number (in file) */
 typedef	__uint32_t	xfs_dahash_t;	/* dir/attr hash value */
 
-typedef __uint32_t	xlog_tid_t;	/* transaction ID type */
-
 /*
  * These types are 64 bits on disk but are either 32 or 64 bits in memory.
  * Disk based types:
Index: xfs/fs/xfs/linux-2.6/xfs_trace.h
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_trace.h	2011-04-15 09:40:41.397299257 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_trace.h	2011-04-15 09:40:41.737297415 +0200
@@ -1151,44 +1151,7 @@ TRACE_EVENT(xfs_bunmap,
 
 );
 
-#define XFS_BUSY_SYNC \
-	{ 0,	"async" }, \
-	{ 1,	"sync" }
-
-TRACE_EVENT(xfs_alloc_busy,
-	TP_PROTO(struct xfs_trans *trans, xfs_agnumber_t agno,
-		 xfs_agblock_t agbno, xfs_extlen_t len, int sync),
-	TP_ARGS(trans, agno, agbno, len, sync),
-	TP_STRUCT__entry(
-		__field(dev_t, dev)
-		__field(struct xfs_trans *, tp)
-		__field(int, tid)
-		__field(xfs_agnumber_t, agno)
-		__field(xfs_agblock_t, agbno)
-		__field(xfs_extlen_t, len)
-		__field(int, sync)
-	),
-	TP_fast_assign(
-		__entry->dev = trans->t_mountp->m_super->s_dev;
-		__entry->tp = trans;
-		__entry->tid = trans->t_ticket->t_tid;
-		__entry->agno = agno;
-		__entry->agbno = agbno;
-		__entry->len = len;
-		__entry->sync = sync;
-	),
-	TP_printk("dev %d:%d trans 0x%p tid 0x%x agno %u agbno %u len %u %s",
-		  MAJOR(__entry->dev), MINOR(__entry->dev),
-		  __entry->tp,
-		  __entry->tid,
-		  __entry->agno,
-		  __entry->agbno,
-		  __entry->len,
-		  __print_symbolic(__entry->sync, XFS_BUSY_SYNC))
-
-);
-
-TRACE_EVENT(xfs_alloc_unbusy,
+DECLARE_EVENT_CLASS(xfs_busy_class,
 	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
 		 xfs_agblock_t agbno, xfs_extlen_t len),
 	TP_ARGS(mp, agno, agbno, len),
@@ -1210,36 +1173,16 @@ TRACE_EVENT(xfs_alloc_unbusy,
 		  __entry->agbno,
 		  __entry->len)
 );
-
-#define XFS_BUSY_STATES \
-	{ 0,	"missing" }, \
-	{ 1,	"found" }
-
-TRACE_EVENT(xfs_alloc_busysearch,
-	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
-		 xfs_agblock_t agbno, xfs_extlen_t len, int found),
-	TP_ARGS(mp, agno, agbno, len, found),
-	TP_STRUCT__entry(
-		__field(dev_t, dev)
-		__field(xfs_agnumber_t, agno)
-		__field(xfs_agblock_t, agbno)
-		__field(xfs_extlen_t, len)
-		__field(int, found)
-	),
-	TP_fast_assign(
-		__entry->dev = mp->m_super->s_dev;
-		__entry->agno = agno;
-		__entry->agbno = agbno;
-		__entry->len = len;
-		__entry->found = found;
-	),
-	TP_printk("dev %d:%d agno %u agbno %u len %u %s",
-		  MAJOR(__entry->dev), MINOR(__entry->dev),
-		  __entry->agno,
-		  __entry->agbno,
-		  __entry->len,
-		  __print_symbolic(__entry->found, XFS_BUSY_STATES))
-);
+#define DEFINE_BUSY_EVENT(name) \
+DEFINE_EVENT(xfs_busy_class, name, \
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, \
+		 xfs_agblock_t agbno, xfs_extlen_t len), \
+	TP_ARGS(mp, agno, agbno, len))
+DEFINE_BUSY_EVENT(xfs_alloc_busy);
+DEFINE_BUSY_EVENT(xfs_alloc_busy_enomem);
+DEFINE_BUSY_EVENT(xfs_alloc_busy_force);
+DEFINE_BUSY_EVENT(xfs_alloc_busy_reuse);
+DEFINE_BUSY_EVENT(xfs_alloc_busy_clear);
 
 TRACE_EVENT(xfs_alloc_busy_trim,
 	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
