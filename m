Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p2MJwmDU046899 for <xfs@oss.sgi.com>; Tue, 22 Mar 2011 14:58:58 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 849FB36B19C
	for <xfs@oss.sgi.com>; Tue, 22 Mar 2011 13:01:38 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 2c1nQUC5VrTpgtnu for
	<xfs@oss.sgi.com>; Tue, 22 Mar 2011 13:01:38 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.72 #1 (Red Hat
	Linux)) id 1Q27lp-0000rM-MF
	for xfs@oss.sgi.com; Tue, 22 Mar 2011 20:01:37 +0000
Message-Id: <20110322200137.657110761@bombadil.infradead.org>
Date: Tue, 22 Mar 2011 15:55:53 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 3/6] xfs: exact busy extent tracking
References: <20110322195550.260682574@bombadil.infradead.org>
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
in case of a reuse.   Also replace setting transactions to sync with forcing
the log out in case we found a busy extent to reuse.  This makes the code a
lot more simple, and is required for discard support later on.  While it
will cause performance regressios with just this patch applied, the impact
is more than mitigated by the next patch in the series.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_alloc.c
===================================================================
--- xfs.orig/fs/xfs/xfs_alloc.c	2011-03-20 19:41:55.835479390 +0100
+++ xfs/fs/xfs/xfs_alloc.c	2011-03-21 14:49:14.157973188 +0100
@@ -1396,8 +1396,8 @@ xfs_alloc_ag_vextent_small(
 		if (error)
 			goto error0;
 		if (fbno != NULLAGBLOCK) {
-			if (xfs_alloc_busy_search(args->mp, args->agno, fbno, 1))
-				xfs_trans_set_sync(args->tp);
+			xfs_alloc_busy_reuse(args->tp, args->agno, fbno, 1);
+
 			if (args->userdata) {
 				xfs_buf_t	*bp;
 
@@ -2459,100 +2459,6 @@ error0:
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
@@ -2564,9 +2470,7 @@ xfs_alloc_busy_insert(
 	struct xfs_busy_extent	*busyp;
 	struct xfs_perag	*pag;
 	struct rb_node		**rbp;
-	struct rb_node		*parent;
-	int			match;
-
+	struct rb_node		*parent = NULL;
 
 	new = kmem_zalloc(sizeof(struct xfs_busy_extent), KM_MAYFAIL);
 	if (!new) {
@@ -2583,66 +2487,30 @@ xfs_alloc_busy_insert(
 	new->agno = agno;
 	new->bno = bno;
 	new->length = len;
-	new->tid = xfs_log_get_trans_ident(tp);
-
 	INIT_LIST_HEAD(&new->list);
 
 	/* trace before insert to be able to see failed inserts */
 	trace_xfs_alloc_busy(tp, agno, bno, len, 0);
 
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
 			/* may overlap, but exact start block is lower */
 			rbp = &(*rbp)->rb_left;
-			if (new->bno + new->length > busyp->bno)
-				match = busyp->tid == new->tid ? 1 : -1;
+			BUG_ON(new->bno + new->length > busyp->bno);
 		} else if (new->bno > busyp->bno) {
 			/* may overlap, but exact start block is higher */
 			rbp = &(*rbp)->rb_right;
-			if (bno < busyp->bno + busyp->length)
-				match = busyp->tid == new->tid ? 1 : -1;
+			BUG_ON(bno < busyp->bno + busyp->length);
 		} else {
-			match = busyp->tid == new->tid ? 1 : -1;
-			break;
+			BUG();
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
@@ -2650,7 +2518,6 @@ restart:
 	list_add(&new->list, &tp->t_busy);
 	spin_unlock(&pag->pagb_lock);
 	xfs_perag_put(pag);
-	kmem_free(busyp);
 }
 
 /*
@@ -2704,6 +2571,173 @@ xfs_alloc_busy_search(
 	return match;
 }
 
+STATIC int
+xfs_alloc_busy_try_reuse(
+	struct xfs_perag	*pag,
+	struct xfs_busy_extent	*busyp,
+	xfs_agblock_t		fbno,
+	xfs_agblock_t		fend)
+{
+	xfs_agblock_t	bbno = busyp->bno;
+	xfs_agblock_t	bend = bbno + busyp->length;
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
+		 * We would have to split the busy extent to be able
+		 * to track it correct, which we cannot do because we
+		 * would have to modify the list of busy extents
+		 * attached to the transaction/CIL context, which
+		 * is mutable.
+		 *
+		 * Force out the log to clear the busy extents
+		 * and retry the search.
+		 */
+		return -1;
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
+		 * The busy extent is fully covered by the extent
+		 * we are allocating, and can simply be removed from
+		 * the rbtree.  However we cannot remove it from the
+		 * immutable list tracking busy extents in the
+		 * transaction or CIL context, so set the length
+		 * to zero to mark it invalid.
+		 */
+		rb_erase(&busyp->rb_node, &pag->pagb_tree);
+		busyp->length = 0;
+	} else if (bbno == fbno) {
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
+
+		busyp->bno = fend;
+	} else if (bend == fend) {
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
+
+		busyp->length = fbno - busyp->bno;
+	} else {
+		BUG();
+	}
+
+	return 1;
+}
+
+
+/*
+ * For a given extent [fbno, flen], make sure we can reuse it safely.
+ */
+void
+xfs_alloc_busy_reuse(
+	struct xfs_trans	*tp,
+	xfs_agnumber_t		agno,
+	xfs_agblock_t		fbno,
+	xfs_extlen_t		flen)
+{
+	struct xfs_perag	*pag;
+	struct rb_node		*rbp;
+
+	ASSERT(flen > 0);
+
+	pag = xfs_perag_get(tp->t_mountp, agno);
+restart:
+	spin_lock(&pag->pagb_lock);
+	rbp = pag->pagb_tree.rb_node;
+	while (rbp) {
+		struct xfs_busy_extent *busyp =
+			rb_entry(rbp, struct xfs_busy_extent, rb_node);
+		xfs_agblock_t	fend = fbno + flen;
+		xfs_agblock_t	bbno = busyp->bno;
+		xfs_agblock_t	bend = bbno + busyp->length;
+		int		overlap;
+
+		if (fend <= bbno) {
+			rbp = rbp->rb_left;
+			continue;
+		} else if (fbno >= bend) {
+			rbp = rbp->rb_right;
+			continue;
+		}
+
+		overlap = xfs_alloc_busy_try_reuse(pag, busyp,
+						   fbno, fbno + flen);
+		if (overlap) {
+			spin_unlock(&pag->pagb_lock);
+			xfs_log_force(tp->t_mountp, XFS_LOG_SYNC);
+			goto restart;
+		}
+
+		/*
+		 * No more busy extents to search.
+		 */
+		if (bbno <= fbno && bend >= fend)
+			break;
+
+		if (fbno < bbno)
+			rbp = rbp->rb_left;
+		else
+			rbp = rbp->rb_right;
+	}
+	spin_unlock(&pag->pagb_lock);
+	xfs_perag_put(pag);
+}
+
 /*
  * For a given extent [fbno, flen], search the busy extent list
  * to find a subset of the extent that is not busy.
@@ -2889,14 +2923,12 @@ xfs_alloc_busy_clear(
 	trace_xfs_alloc_unbusy(mp, busyp->agno, busyp->bno,
 						busyp->length);
 
-	ASSERT(xfs_alloc_busy_search(mp, busyp->agno, busyp->bno,
-						busyp->length) == 1);
-
 	list_del_init(&busyp->list);
 
 	pag = xfs_perag_get(mp, busyp->agno);
 	spin_lock(&pag->pagb_lock);
-	rb_erase(&busyp->rb_node, &pag->pagb_tree);
+	if (busyp->length)
+		rb_erase(&busyp->rb_node, &pag->pagb_tree);
 	spin_unlock(&pag->pagb_lock);
 	xfs_perag_put(pag);
 
Index: xfs/fs/xfs/xfs_alloc.h
===================================================================
--- xfs.orig/fs/xfs/xfs_alloc.h	2011-03-20 19:41:55.847481367 +0100
+++ xfs/fs/xfs/xfs_alloc.h	2011-03-21 14:48:04.202480897 +0100
@@ -145,6 +145,10 @@ xfs_alloc_busy_clear(struct xfs_mount *m
 int
 xfs_alloc_busy_search(struct xfs_mount *mp, xfs_agnumber_t agno,
 	xfs_agblock_t bno, xfs_extlen_t len);
+
+void
+xfs_alloc_busy_reuse(struct xfs_trans *tp, xfs_agnumber_t agno,
+	xfs_agblock_t fbno, xfs_extlen_t flen);
 #endif	/* __KERNEL__ */
 
 /*
Index: xfs/fs/xfs/xfs_alloc_btree.c
===================================================================
--- xfs.orig/fs/xfs/xfs_alloc_btree.c	2011-03-20 19:41:55.863479131 +0100
+++ xfs/fs/xfs/xfs_alloc_btree.c	2011-03-21 14:48:04.210474164 +0100
@@ -94,8 +94,8 @@ xfs_allocbt_alloc_block(
 		*stat = 0;
 		return 0;
 	}
-	if (xfs_alloc_busy_search(cur->bc_mp, cur->bc_private.a.agno, bno, 1))
-		xfs_trans_set_sync(cur->bc_tp);
+
+	xfs_alloc_busy_reuse(cur->bc_tp, cur->bc_private.a.agno, bno, 1);
 
 	xfs_trans_agbtree_delta(cur->bc_tp, 1);
 	new->s = cpu_to_be32(bno);
Index: xfs/fs/xfs/xfs_ag.h
===================================================================
--- xfs.orig/fs/xfs/xfs_ag.h	2011-03-21 14:37:58.553976032 +0100
+++ xfs/fs/xfs/xfs_ag.h	2011-03-21 14:48:04.222474401 +0100
@@ -187,7 +187,6 @@ struct xfs_busy_extent {
 	xfs_agnumber_t	agno;
 	xfs_agblock_t	bno;
 	xfs_extlen_t	length;
-	xlog_tid_t	tid;		/* transaction that created this */
 };
 
 /*
Index: xfs/fs/xfs/xfs_log.c
===================================================================
--- xfs.orig/fs/xfs/xfs_log.c	2011-03-21 14:37:58.565974096 +0100
+++ xfs/fs/xfs/xfs_log.c	2011-03-21 14:38:03.000000000 +0100
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
--- xfs.orig/fs/xfs/xfs_log.h	2011-03-21 14:37:58.578474771 +0100
+++ xfs/fs/xfs/xfs_log.h	2011-03-21 14:38:03.000000000 +0100
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
--- xfs.orig/fs/xfs/xfs_log_priv.h	2011-03-21 14:37:58.590474432 +0100
+++ xfs/fs/xfs/xfs_log_priv.h	2011-03-21 14:38:03.000000000 +0100
@@ -144,6 +144,8 @@ static inline uint xlog_get_client_id(__
 #define	XLOG_RECOVERY_NEEDED	0x4	/* log was recovered */
 #define XLOG_IO_ERROR		0x8	/* log hit an I/O error, and being
 					   shutdown */
+typedef __uint32_t xlog_tid_t;
+
 
 #ifdef __KERNEL__
 /*
Index: xfs/fs/xfs/xfs_types.h
===================================================================
--- xfs.orig/fs/xfs/xfs_types.h	2011-03-21 14:37:58.610475776 +0100
+++ xfs/fs/xfs/xfs_types.h	2011-03-21 14:38:03.000000000 +0100
@@ -73,8 +73,6 @@ typedef	__int32_t	xfs_tid_t;	/* transact
 typedef	__uint32_t	xfs_dablk_t;	/* dir/attr block number (in file) */
 typedef	__uint32_t	xfs_dahash_t;	/* dir/attr hash value */
 
-typedef __uint32_t	xlog_tid_t;	/* transaction ID type */
-
 /*
  * These types are 64 bits on disk but are either 32 or 64 bits in memory.
  * Disk based types:

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
