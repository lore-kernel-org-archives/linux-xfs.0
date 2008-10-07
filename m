Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 07 Oct 2008 15:08:13 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m97M84xk009007
	for <xfs@oss.sgi.com>; Tue, 7 Oct 2008 15:08:05 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 83D3D1B0C572
	for <xfs@oss.sgi.com>; Tue,  7 Oct 2008 15:09:43 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id tYTupxNUpenkVwdG for <xfs@oss.sgi.com>; Tue, 07 Oct 2008 15:09:43 -0700 (PDT)
Received: from dave by disturbed with local (Exim 4.69)
	(envelope-from <david@fromorbit.com>)
	id 1KnKkL-0002Vs-PL
	for xfs@oss.sgi.com; Wed, 08 Oct 2008 09:09:37 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 7/7] XFS: Simplify transaction busy extent tracking
Date: Wed,  8 Oct 2008 09:09:37 +1100
Message-Id: <1223417377-8679-8-git-send-email-david@fromorbit.com>
In-Reply-To: <1223417377-8679-1-git-send-email-david@fromorbit.com>
References: <1223417377-8679-1-git-send-email-david@fromorbit.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Now that we have a dynamic busy extent structure, we no
longer need the complex log busy chunk infrastructure to
track them in a transaction. We can simply use a linked
list hanging off the transaction structure to do this now.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/xfs_ag.h         |    3 +-
 fs/xfs/xfs_alloc.c      |    4 +-
 fs/xfs/xfs_trans.c      |   30 +++++++-------
 fs/xfs/xfs_trans.h      |   33 +---------------
 fs/xfs/xfs_trans_item.c |  102 -----------------------------------------------
 fs/xfs/xfs_trans_priv.h |    1 -
 6 files changed, 21 insertions(+), 152 deletions(-)

diff --git a/fs/xfs/xfs_ag.h b/fs/xfs/xfs_ag.h
index 62bb280..de105a4 100644
--- a/fs/xfs/xfs_ag.h
+++ b/fs/xfs/xfs_ag.h
@@ -160,7 +160,8 @@ typedef struct xfs_agfl {
  * have been freed but whose transactions aren't committed to disk yet.
  */
 struct xfs_busy_extent {
-	struct rb_node	rb_node;
+	struct rb_node	rb_node;	/* ag by-bno indexed search tree */
+	struct list_head list;		/* transaction busy extent list */
 	atomic_t	ref;
 	xfs_agnumber_t	agno;
 	xfs_agblock_t	bno;
diff --git a/fs/xfs/xfs_alloc.c b/fs/xfs/xfs_alloc.c
index 73536ef..ff3111f 100644
--- a/fs/xfs/xfs_alloc.c
+++ b/fs/xfs/xfs_alloc.c
@@ -202,13 +202,14 @@ xfs_alloc_mark_busy(
 	busyp->agno = agno;
 	busyp->bno = bno;
 	busyp->length = len;
+	INIT_LIST_HEAD(&busyp->list);
 	if (freelist)
 		busyp->flags |= XFS_BUSY_EXT_FREELIST; 
 
 	pag = xfs_perag_get(tp->t_mountp, agno);
 	spin_lock(&pag->pagb_lock);
 	if (xfs_alloc_busy_insert(pag, bno, busyp))
-		xfs_trans_add_busy(tp, busyp);
+		list_add(&busyp->list, &tp->t_busy);
 	TRACE_BUSY("xfs_alloc_mark_busy", "got", agno, bno, len, tp);
 	spin_unlock(&pag->pagb_lock);
 	xfs_perag_put(pag);
@@ -226,6 +227,7 @@ xfs_alloc_clear_busy(
 	spin_lock(&pag->pagb_lock);
 	ASSERT(!RB_EMPTY_NODE(&busyp->rb_node));
 	rb_erase(&busyp->rb_node, &pag->pagb_tree);
+	list_del_init(&busyp->list);
 	spin_unlock(&pag->pagb_lock);
 
 	xfs_perag_put(pag);
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index e88b9bf..d0d0f6f 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -253,9 +253,8 @@ _xfs_trans_alloc(
 	tp->t_type = type;
 	tp->t_mountp = mp;
 	tp->t_items_free = XFS_LIC_NUM_SLOTS;
-	tp->t_busy_free = XFS_LBC_NUM_SLOTS;
 	xfs_lic_init(&(tp->t_items));
-	XFS_LBC_INIT(&(tp->t_busy));
+	INIT_LIST_HEAD(&tp->t_busy);
 	return tp;
 }
 
@@ -282,9 +281,8 @@ xfs_trans_dup(
 	ntp->t_type = tp->t_type;
 	ntp->t_mountp = tp->t_mountp;
 	ntp->t_items_free = XFS_LIC_NUM_SLOTS;
-	ntp->t_busy_free = XFS_LBC_NUM_SLOTS;
 	xfs_lic_init(&(ntp->t_items));
-	XFS_LBC_INIT(&(ntp->t_busy));
+	INIT_LIST_HEAD(&ntp->t_busy);
 
 	ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
 	ASSERT(tp->t_ticket != NULL);
@@ -765,6 +763,19 @@ xfs_trans_unreserve_and_mod_sb(
 	}
 }
 
+/*
+ * xfs_trans_free_busy
+ * Free all of the busy extents from a transaction
+ */
+static void
+xfs_trans_free_busy(xfs_trans_t *tp)
+{
+	struct xfs_busy_extent	*busyp, *n;
+
+	list_for_each_entry_safe(busyp, n, &tp->t_busy, list) {
+		xfs_alloc_clear_busy(tp, busyp);
+	}
+}
 
 /*
  * xfs_trans_commit
@@ -1300,9 +1311,6 @@ xfs_trans_committed(
 {
 	xfs_log_item_chunk_t	*licp;
 	xfs_log_item_chunk_t	*next_licp;
-	xfs_log_busy_chunk_t	*lbcp;
-	xfs_log_busy_slot_t	*lbsp;
-	int			i;
 
 	/*
 	 * Call the transaction's completion callback if there
@@ -1335,14 +1343,6 @@ xfs_trans_committed(
 	/*
 	 * Clear all the per-AG busy list items listed in this transaction
 	 */
-	lbcp = &tp->t_busy;
-	while (lbcp != NULL) {
-		for (i = 0, lbsp = lbcp->lbc_busy; i < lbcp->lbc_unused; i++, lbsp++) {
-			if (!XFS_LBC_ISFREE(lbcp, i))
-				xfs_alloc_clear_busy(tp, lbsp->lbc_busyp);
-		}
-		lbcp = lbcp->lbc_next;
-	}
 	xfs_trans_free_busy(tp);
 
 	/*
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 6a5e8d5..b7e8cf0 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -819,33 +819,6 @@ typedef struct xfs_item_ops {
 #define XFS_ITEM_PUSHBUF	4
 
 /*
- * This structure is used to maintain a list of block ranges that have been
- * freed in the transaction.  The ranges are listed in the perag[] busy list
- * between when they're freed and the transaction is committed to disk.
- */
-
-typedef struct xfs_log_busy_slot {
-	struct xfs_busy_extent	*lbc_busyp;
-} xfs_log_busy_slot_t;
-
-#define XFS_LBC_NUM_SLOTS	31
-typedef struct xfs_log_busy_chunk {
-	struct xfs_log_busy_chunk	*lbc_next;
-	uint				lbc_free;	/* free slots bitmask */
-	ushort				lbc_unused;	/* first unused */
-	xfs_log_busy_slot_t		lbc_busy[XFS_LBC_NUM_SLOTS];
-} xfs_log_busy_chunk_t;
-
-#define	XFS_LBC_MAX_SLOT	(XFS_LBC_NUM_SLOTS - 1)
-#define	XFS_LBC_FREEMASK	((1U << XFS_LBC_NUM_SLOTS) - 1)
-
-#define	XFS_LBC_INIT(cp)	((cp)->lbc_free = XFS_LBC_FREEMASK)
-#define	XFS_LBC_CLAIM(cp, slot)	((cp)->lbc_free &= ~(1 << (slot)))
-#define	XFS_LBC_SLOT(cp, slot)	(&((cp)->lbc_busy[(slot)]))
-#define	XFS_LBC_VACANCY(cp)	(((cp)->lbc_free) & XFS_LBC_FREEMASK)
-#define	XFS_LBC_ISFREE(cp, slot) ((cp)->lbc_free & (1 << (slot)))
-
-/*
  * This is the type of function which can be given to xfs_trans_callback()
  * to be called upon the transaction's commit to disk.
  */
@@ -896,8 +869,7 @@ typedef struct xfs_trans {
 	unsigned int		t_items_free;	/* log item descs free */
 	xfs_log_item_chunk_t	t_items;	/* first log item desc chunk */
 	xfs_trans_header_t	t_header;	/* header for in-log trans */
-	unsigned int		t_busy_free;	/* busy descs free */
-	xfs_log_busy_chunk_t	t_busy;		/* busy/async free blocks */
+	struct list_head	t_busy;		/* list of busy extents */
 	unsigned long		t_pflags;	/* saved process flags state */
 } xfs_trans_t;
 
@@ -972,9 +944,6 @@ void		xfs_trans_cancel(xfs_trans_t *, int);
 int		xfs_trans_ail_init(struct xfs_mount *);
 void		xfs_trans_ail_destroy(struct xfs_mount *);
 
-xfs_log_busy_slot_t *xfs_trans_add_busy(struct xfs_trans *tp,
-					struct xfs_busy_extent *busyp);
-
 extern kmem_zone_t	*xfs_trans_zone;
 
 #endif	/* __KERNEL__ */
diff --git a/fs/xfs/xfs_trans_item.c b/fs/xfs/xfs_trans_item.c
index 3baa0af..687625f 100644
--- a/fs/xfs/xfs_trans_item.c
+++ b/fs/xfs/xfs_trans_item.c
@@ -438,105 +438,3 @@ xfs_trans_unlock_chunk(
 
 	return freed;
 }
-
-
-/*
- * This is called to add the given busy item to the transaction's
- * list of busy items.  It must find a free busy item descriptor
- * or allocate a new one and add the item to that descriptor.
- * The function returns a pointer to busy descriptor used to point
- * to the new busy entry.  The log busy entry will now point to its new
- * descriptor with its ???? field.
- */
-xfs_log_busy_slot_t *
-xfs_trans_add_busy(
-	xfs_trans_t		*tp,
-	struct xfs_busy_extent	*busyp)
-{
-	xfs_log_busy_chunk_t	*lbcp;
-	xfs_log_busy_slot_t	*lbsp;
-	int			i=0;
-
-	/*
-	 * If there are no free descriptors, allocate a new chunk
-	 * of them and put it at the front of the chunk list.
-	 */
-	if (tp->t_busy_free == 0) {
-		lbcp = (xfs_log_busy_chunk_t*)
-		       kmem_alloc(sizeof(xfs_log_busy_chunk_t), KM_SLEEP);
-		ASSERT(lbcp != NULL);
-		/*
-		 * Initialize the chunk, and then
-		 * claim the first slot in the newly allocated chunk.
-		 */
-		XFS_LBC_INIT(lbcp);
-		XFS_LBC_CLAIM(lbcp, 0);
-		lbcp->lbc_unused = 1;
-		lbsp = XFS_LBC_SLOT(lbcp, 0);
-
-		/*
-		 * Link in the new chunk and update the free count.
-		 */
-		lbcp->lbc_next = tp->t_busy.lbc_next;
-		tp->t_busy.lbc_next = lbcp;
-		tp->t_busy_free = XFS_LIC_NUM_SLOTS - 1;
-
-		/* Initialize the descriptor and return it */
-		lbsp->lbc_busyp = busyp;
-		return lbsp;
-	}
-
-	/*
-	 * Find the free descriptor. It is somewhere in the chunklist
-	 * of descriptors.
-	 */
-	lbcp = &tp->t_busy;
-	while (lbcp != NULL) {
-		if (XFS_LBC_VACANCY(lbcp)) {
-			if (lbcp->lbc_unused <= XFS_LBC_MAX_SLOT) {
-				i = lbcp->lbc_unused;
-				break;
-			} else {
-				/* out-of-order vacancy */
-				cmn_err(CE_DEBUG, "OOO vacancy lbcp 0x%p\n", lbcp);
-				ASSERT(0);
-			}
-		}
-		lbcp = lbcp->lbc_next;
-	}
-	ASSERT(lbcp != NULL);
-	/*
-	 * If we find a free descriptor, claim it,
-	 * initialize it, and return it.
-	 */
-	XFS_LBC_CLAIM(lbcp, i);
-	if (lbcp->lbc_unused <= i) {
-		lbcp->lbc_unused = i + 1;
-	}
-	lbsp = XFS_LBC_SLOT(lbcp, i);
-	tp->t_busy_free--;
-	lbsp->lbc_busyp = busyp;
-	return lbsp;
-}
-
-
-/*
- * xfs_trans_free_busy
- * Free all of the busy lists from a transaction
- */
-void
-xfs_trans_free_busy(xfs_trans_t *tp)
-{
-	xfs_log_busy_chunk_t	*lbcp;
-	xfs_log_busy_chunk_t	*lbcq;
-
-	lbcp = tp->t_busy.lbc_next;
-	while (lbcp != NULL) {
-		lbcq = lbcp->lbc_next;
-		kmem_free(lbcp);
-		lbcp = lbcq;
-	}
-
-	XFS_LBC_INIT(&tp->t_busy);
-	tp->t_busy.lbc_unused = 0;
-}
diff --git a/fs/xfs/xfs_trans_priv.h b/fs/xfs/xfs_trans_priv.h
index fd50556..901dc0f 100644
--- a/fs/xfs/xfs_trans_priv.h
+++ b/fs/xfs/xfs_trans_priv.h
@@ -38,7 +38,6 @@ struct xfs_log_item_desc	*xfs_trans_next_item(struct xfs_trans *,
 void				xfs_trans_free_items(struct xfs_trans *, int);
 void				xfs_trans_unlock_items(struct xfs_trans *,
 							xfs_lsn_t);
-void				xfs_trans_free_busy(xfs_trans_t *tp);
 
 /*
  * AIL traversal cursor.
-- 
1.5.6.5
