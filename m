Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0L9NZhI260935 for <xfs@oss.sgi.com>; Fri, 21 Jan 2011 03:23:37 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E4B7E148BB81
	for <xfs@oss.sgi.com>; Fri, 21 Jan 2011 01:25:52 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id KpMGC7jD1DfCCjBO for
	<xfs@oss.sgi.com>; Fri, 21 Jan 2011 01:25:52 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.72 #1 (Red Hat
	Linux)) id 1PgDFf-0002Ex-La
	for xfs@oss.sgi.com; Fri, 21 Jan 2011 09:25:51 +0000
Message-Id: <20110121092551.629220945@bombadil.infradead.org>
Date: Fri, 21 Jan 2011 04:22:33 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 6/6] xfs: remove handling of duplicates the busy extent tree
References: <20110121092227.115815324@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-remove-duplicate-extent-handling
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

With the recent changes we never re-used busy extents.  Remove all handling
of them and replace them with asserts.  This also effectively reverts
commit 955833cf2ad0aa39b336e853cad212d867199984

	"xfs: make the log ticket ID available outside the log infrastructure"

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_ag.h
===================================================================
--- xfs.orig/fs/xfs/xfs_ag.h	2011-01-18 13:06:47.588254235 +0100
+++ xfs/fs/xfs/xfs_ag.h	2011-01-18 13:07:05.608012022 +0100
@@ -187,7 +187,6 @@ struct xfs_busy_extent {
 	xfs_agnumber_t	agno;
 	xfs_agblock_t	bno;
 	xfs_extlen_t	length;
-	xlog_tid_t	tid;		/* transaction that created this */
 	int		flags;
 };
 
Index: xfs/fs/xfs/xfs_alloc.c
===================================================================
--- xfs.orig/fs/xfs/xfs_alloc.c	2011-01-18 13:06:47.595254654 +0100
+++ xfs/fs/xfs/xfs_alloc.c	2011-01-18 13:08:34.000000000 +0100
@@ -2518,83 +2518,7 @@ error0:
 /*
  * Insert a new extent into the busy tree.
  *
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
+ * The busy extent tree is indexed by the start block of the busy extent
  */
 STATIC void
 xfs_alloc_busy_insert(
@@ -2609,8 +2533,6 @@ xfs_alloc_busy_insert(
 	struct xfs_perag	*pag;
 	struct rb_node		**rbp;
 	struct rb_node		*parent;
-	int			match;
-
 
 	new = kmem_zalloc(sizeof(struct xfs_busy_extent), KM_MAYFAIL);
 	if (!new) {
@@ -2628,74 +2550,35 @@ xfs_alloc_busy_insert(
 	new->bno = bno;
 	new->length = len;
 	new->flags = flags;
-	new->tid = xfs_log_get_trans_ident(tp);
-
 	INIT_LIST_HEAD(&new->list);
 
 	/* trace before insert to be able to see failed inserts */
 	trace_xfs_alloc_busy(tp, agno, bno, len, 0);
 
 	pag = xfs_perag_get(tp->t_mountp, new->agno);
-restart:
 	spin_lock(&pag->pagb_lock);
 	rbp = &pag->pagb_tree.rb_node;
 	parent = NULL;
-	busyp = NULL;
-	match = 0;
-	while (*rbp && match >= 0) {
+	while (*rbp) {
 		parent = *rbp;
 		busyp = rb_entry(parent, struct xfs_busy_extent, rb_node);
 
 		if (new->bno < busyp->bno) {
-			/* may overlap, but exact start block is lower */
+			ASSERT(new->bno + new->length <= busyp->bno);
 			rbp = &(*rbp)->rb_left;
-			if (new->bno + new->length > busyp->bno)
-				match = busyp->tid == new->tid ? 1 : -1;
-		} else if (new->bno > busyp->bno) {
-			/* may overlap, but exact start block is higher */
-			rbp = &(*rbp)->rb_right;
-			if (bno < busyp->bno + busyp->length)
-				match = busyp->tid == new->tid ? 1 : -1;
 		} else {
-			match = busyp->tid == new->tid ? 1 : -1;
-			break;
+			ASSERT(new->bno > busyp->bno);
+			ASSERT(bno >= busyp->bno + busyp->length);
+			rbp = &(*rbp)->rb_right;
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
-
 	list_add(&new->list, &tp->t_busy);
+
 	spin_unlock(&pag->pagb_lock);
 	xfs_perag_put(pag);
-	kmem_free(busyp);
 }
 
 /*
Index: xfs/fs/xfs/xfs_log.c
===================================================================
--- xfs.orig/fs/xfs/xfs_log.c	2011-01-18 13:06:47.612254724 +0100
+++ xfs/fs/xfs/xfs_log.c	2011-01-18 13:07:05.929013420 +0100
@@ -3256,13 +3256,6 @@ xfs_log_ticket_get(
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
--- xfs.orig/fs/xfs/xfs_log.h	2011-01-18 13:06:47.618254514 +0100
+++ xfs/fs/xfs/xfs_log.h	2011-01-18 13:07:05.936017889 +0100
@@ -189,8 +189,6 @@ void	  xlog_iodone(struct xfs_buf *);
 struct xlog_ticket *xfs_log_ticket_get(struct xlog_ticket *ticket);
 void	  xfs_log_ticket_put(struct xlog_ticket *ticket);
 
-xlog_tid_t xfs_log_get_trans_ident(struct xfs_trans *tp);
-
 int	xfs_log_commit_cil(struct xfs_mount *mp, struct xfs_trans *tp,
 				struct xfs_log_vec *log_vector,
 				xfs_lsn_t *commit_lsn, int flags);
Index: xfs/fs/xfs/xfs_log_priv.h
===================================================================
--- xfs.orig/fs/xfs/xfs_log_priv.h	2011-01-18 13:06:47.625253956 +0100
+++ xfs/fs/xfs/xfs_log_priv.h	2011-01-18 13:07:05.951006924 +0100
@@ -148,6 +148,8 @@ static inline uint xlog_get_client_id(__
 #define	XLOG_RECOVERY_NEEDED	0x4	/* log was recovered */
 #define XLOG_IO_ERROR		0x8	/* log hit an I/O error, and being
 					   shutdown */
+typedef __uint32_t xlog_tid_t;
+
 
 #ifdef __KERNEL__
 /*
Index: xfs/fs/xfs/xfs_types.h
===================================================================
--- xfs.orig/fs/xfs/xfs_types.h	2011-01-18 13:06:47.645254026 +0100
+++ xfs/fs/xfs/xfs_types.h	2011-01-18 13:07:05.958005458 +0100
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
