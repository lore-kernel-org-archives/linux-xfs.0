Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 07 Oct 2008 15:08:18 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m97M88kl009049
	for <xfs@oss.sgi.com>; Tue, 7 Oct 2008 15:08:08 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3E67F4C8255
	for <xfs@oss.sgi.com>; Tue,  7 Oct 2008 15:09:46 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id tNrHrH6owA9LYfnG for <xfs@oss.sgi.com>; Tue, 07 Oct 2008 15:09:46 -0700 (PDT)
Received: from dave by disturbed with local (Exim 4.69)
	(envelope-from <david@fromorbit.com>)
	id 1KnKkL-0002Vd-FX
	for xfs@oss.sgi.com; Wed, 08 Oct 2008 09:09:37 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/7] XFS: replace fixed size busy extent array with an rbtree
Date: Wed,  8 Oct 2008 09:09:32 +1100
Message-Id: <1223417377-8679-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1223417377-8679-1-git-send-email-david@fromorbit.com>
References: <1223417377-8679-1-git-send-email-david@fromorbit.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

When we free a metadata extent, we record it in the per-AG busy
extent array so that it is not re-used before the freeing
transaction hits the disk. This array is fixed size, so when it
overflows we make further allocation transactions synchronous
because we cannot track more freed extents until those transactions
hit the disk and are completed. Under heavy mixed allocation and
freeing workloads with large log buffers, we can overflow this array
quite easily.

This is important as we want to be able to issue block discard
commands when we free extents, and that has to happen after the free
transaction has been committed to disk. This is made complex by the
way the overflows are handled - we don't record the extent to be
freed in the busy list, so we've got no callback to issue the
discard request from. Hence we need a different tracking mechanism
to be easily able to issue discard blocks.

Further, the array is sparsely populated, which means that inserts
need to search for a free slot, and array searches often have to
search many more slots that are actually used to check all the
busy extents. Quite inefficient, really.

To fix all these problems, make the busy extent tracking dynamic and
faster to search by converting it to a per-AG rbtree and indexing it
by block number. We always search by block number, so this means
that the search and insert scaling becomes O(log n) instead of
O(array size).  This will also allow us to efficiently track far
more busy extents than the current method allows.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/xfs_ag.h         |   20 ++--
 fs/xfs/xfs_alloc.c      |  235 +++++++++++++++++++++++++++--------------------
 fs/xfs/xfs_alloc.h      |    5 +-
 fs/xfs/xfs_mount.c      |    8 +--
 fs/xfs/xfs_trans.c      |    6 +-
 fs/xfs/xfs_trans.h      |   10 +-
 fs/xfs/xfs_trans_item.c |   19 +---
 fs/xfs/xfs_trans_priv.h |    3 -
 8 files changed, 161 insertions(+), 145 deletions(-)

diff --git a/fs/xfs/xfs_ag.h b/fs/xfs/xfs_ag.h
index 2bfd863..e7aaa1c 100644
--- a/fs/xfs/xfs_ag.h
+++ b/fs/xfs/xfs_ag.h
@@ -156,14 +156,16 @@ typedef struct xfs_agfl {
 } xfs_agfl_t;
 
 /*
- * Busy block/extent entry.  Used in perag to mark blocks that have been freed
- * but whose transactions aren't committed to disk yet.
+ * Busy block/extent entry.  Indexed by a rbtree in perag to mark blocks that
+ * have been freed but whose transactions aren't committed to disk yet.
  */
-typedef struct xfs_perag_busy {
-	xfs_agblock_t	busy_start;
-	xfs_extlen_t	busy_length;
-	struct xfs_trans *busy_tp;	/* transaction that did the free */
-} xfs_perag_busy_t;
+struct xfs_busy_extent {
+	struct rb_node	rb_node;
+	xfs_agnumber_t	agno;
+	xfs_agblock_t	bno;
+	xfs_extlen_t	length;
+	struct xfs_trans *tp;	/* transaction that did the free */
+};
 
 /*
  * Per-ag incore structure, copies of information in agf and agi,
@@ -192,9 +194,9 @@ typedef struct xfs_perag
 	xfs_agino_t	pagi_freecount;	/* number of free inodes */
 	xfs_agino_t	pagi_count;	/* number of allocated inodes */
 	int		pagb_count;	/* pagb slots in use */
-	xfs_perag_busy_t *pagb_list;	/* unstable blocks */
 #ifdef __KERNEL__
-	spinlock_t	pagb_lock;	/* lock for pagb_list */
+	spinlock_t	pagb_lock;	/* lock for pagb_tree */
+	struct rb_root	pagb_tree;	/* ordered tree of busy extents */
 
 	atomic_t        pagf_fstrms;    /* # of filestreams active in this AG */
 
diff --git a/fs/xfs/xfs_alloc.c b/fs/xfs/xfs_alloc.c
index 0a2a872..98908ba 100644
--- a/fs/xfs/xfs_alloc.c
+++ b/fs/xfs/xfs_alloc.c
@@ -60,18 +60,18 @@ ktrace_t *xfs_alloc_trace_buf;
 	xfs_alloc_trace_free(__func__, s, mp, a, b, x, f, __LINE__)
 #define	TRACE_MODAGF(s,a,f)	\
 	xfs_alloc_trace_modagf(__func__, s, mp, a, f, __LINE__)
-#define	TRACE_BUSY(__func__,s,ag,agb,l,sl,tp)	\
-	xfs_alloc_trace_busy(__func__, s, mp, ag, agb, l, sl, tp, XFS_ALLOC_KTRACE_BUSY, __LINE__)
-#define	TRACE_UNBUSY(__func__,s,ag,sl,tp)	\
-	xfs_alloc_trace_busy(__func__, s, mp, ag, -1, -1, sl, tp, XFS_ALLOC_KTRACE_UNBUSY, __LINE__)
+#define	TRACE_BUSY(__func__,s,ag,agb,l,tp)	\
+	xfs_alloc_trace_busy(__func__, s, mp, ag, agb, l, 0, tp, XFS_ALLOC_KTRACE_BUSY, __LINE__)
+#define	TRACE_UNBUSY(__func__,s,ag,agb,l,tp)	\
+	xfs_alloc_trace_busy(__func__, s, mp, ag, agb, l, 0, tp, XFS_ALLOC_KTRACE_UNBUSY, __LINE__)
 #define	TRACE_BUSYSEARCH(__func__,s,ag,agb,l,tp)	\
 	xfs_alloc_trace_busy(__func__, s, mp, ag, agb, l, 0, tp, XFS_ALLOC_KTRACE_BUSYSEARCH, __LINE__)
 #else
 #define	TRACE_ALLOC(s,a)
 #define	TRACE_FREE(s,a,b,x,f)
 #define	TRACE_MODAGF(s,a,f)
-#define	TRACE_BUSY(s,a,ag,agb,l,sl,tp)
-#define	TRACE_UNBUSY(fname,s,ag,sl,tp)
+#define	TRACE_BUSY(s,a,ag,agb,l,tp)
+#define	TRACE_UNBUSY(fname,s,ag,agb,l,tp)
 #define	TRACE_BUSYSEARCH(fname,s,ag,agb,l,tp)
 #endif	/* XFS_ALLOC_TRACE */
 
@@ -2293,8 +2293,7 @@ xfs_alloc_read_agf(
 		pag->pagf_levels[XFS_BTNUM_CNTi] =
 			be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNTi]);
 		spin_lock_init(&pag->pagb_lock);
-		pag->pagb_list = kmem_zalloc(XFS_PAGB_NUM_SLOTS *
-					sizeof(xfs_perag_busy_t), KM_SLEEP);
+		pag->pagb_tree = RB_ROOT;
 		pag->pagf_init = 1;
 	}
 #ifdef DEBUG
@@ -2578,128 +2577,162 @@ error0:
  * xfs_alloc_mark_busy - add to the per-ag busy list
  * xfs_alloc_clear_busy - remove an item from the per-ag busy list
  */
-void
-xfs_alloc_mark_busy(xfs_trans_t *tp,
-		    xfs_agnumber_t agno,
-		    xfs_agblock_t bno,
-		    xfs_extlen_t len)
+static void
+xfs_alloc_busy_insert(
+	struct xfs_perag	*pag,
+	xfs_agblock_t		bno,
+	struct rb_node		*node)
 {
-	xfs_mount_t		*mp;
-	xfs_perag_busy_t	*bsy;
-	int			n;
+	struct rb_node		**rbp = &pag->pagb_tree.rb_node;
+	struct rb_node		*parent = NULL;
+	struct xfs_busy_extent	*busyp;
+
+	while (*rbp) {
+		parent = *rbp;
+		busyp = rb_entry(parent, struct xfs_busy_extent, rb_node);
+
+		if (bno < busyp->bno)
+			rbp = &(*rbp)->rb_left;
+		else if (bno > busyp->bno)
+			rbp = &(*rbp)->rb_right;
+		else
+			BUG();
+	}
 
-	mp = tp->t_mountp;
-	spin_lock(&mp->m_perag[agno].pagb_lock);
+	rb_link_node(node, parent, rbp);
+	rb_insert_color(node, &pag->pagb_tree);
+}
 
-	/* search pagb_list for an open slot */
-	for (bsy = mp->m_perag[agno].pagb_list, n = 0;
-	     n < XFS_PAGB_NUM_SLOTS;
-	     bsy++, n++) {
-		if (bsy->busy_tp == NULL) {
-			break;
-		}
-	}
+void
+xfs_alloc_mark_busy(
+	struct xfs_trans	*tp,
+	xfs_agnumber_t		agno,
+	xfs_agblock_t		bno,
+	xfs_extlen_t		len)
+{
+	struct xfs_busy_extent	*busyp;
+	struct xfs_perag	*pag;
 
-	if (n < XFS_PAGB_NUM_SLOTS) {
-		bsy = &mp->m_perag[agno].pagb_list[n];
-		mp->m_perag[agno].pagb_count++;
-		TRACE_BUSY("xfs_alloc_mark_busy", "got", agno, bno, len, n, tp);
-		bsy->busy_start = bno;
-		bsy->busy_length = len;
-		bsy->busy_tp = tp;
-		xfs_trans_add_busy(tp, agno, n);
-	} else {
-		TRACE_BUSY("xfs_alloc_mark_busy", "FULL", agno, bno, len, -1, tp);
+	busyp = kmem_zalloc(sizeof(struct xfs_busy_extent), KM_MAYFAIL);
+	if (!busyp) {
 		/*
-		 * The busy list is full!  Since it is now not possible to
-		 * track the free block, make this a synchronous transaction
-		 * to insure that the block is not reused before this
-		 * transaction commits.
+		 * No Memory!  Since it is now not possible to track the free
+		 * block, make this a synchronous transaction to insure that
+		 * the block is not reused before this transaction commits.
 		 */
+		TRACE_BUSY("xfs_alloc_mark_busy", "ENOMEM", agno, bno, len, tp);
 		xfs_trans_set_sync(tp);
+		return;
 	}
 
-	spin_unlock(&mp->m_perag[agno].pagb_lock);
+	busyp->agno = agno;
+	busyp->bno = bno;
+	busyp->length = len;
+	busyp->tp = tp;
+
+	pag = xfs_perag_get(tp->t_mountp, agno);
+	spin_lock(&pag->pagb_lock);
+	xfs_alloc_busy_insert(pag, bno, &busyp->rb_node);
+	xfs_trans_add_busy(tp, busyp);
+	TRACE_BUSY("xfs_alloc_mark_busy", "got", agno, bno, len, tp);
+	spin_unlock(&pag->pagb_lock);
+	xfs_perag_put(pag);
+}
+
+/*
+ * Search for a busy extent within the range of the extent we are about to
+ * allocate.  You need to be holding the busy extent tree lock when calling
+ * __xfs_alloc_busy_search().
+ */
+static struct xfs_busy_extent *
+__xfs_alloc_busy_search(
+	struct xfs_trans	*tp,
+	xfs_agnumber_t		agno,
+	xfs_agblock_t		bno,
+	xfs_extlen_t		len)
+{
+	struct xfs_perag	*pag;
+	struct rb_node		*rbp;
+	xfs_agblock_t		uend, bend;
+
+	uend = bno + len - 1;
+	pag = xfs_perag_get(tp->t_mountp, agno);
+	rbp = pag->pagb_tree.rb_node;
+	while (rbp) {
+		struct xfs_busy_extent	*busyp;
+
+		busyp = rb_entry(rbp, struct xfs_busy_extent, rb_node);
+		bend = busyp->bno + busyp->length - 1;
+		if (uend < busyp->bno)
+			rbp = rbp->rb_left;
+		else if (bno > bend)
+			rbp = rbp->rb_right;
+		else {
+			/* (start1,length1) within (start2, length2) */
+			TRACE_BUSYSEARCH("xfs_alloc_search_busy",
+					 "found1", agno, bno, len, tp);
+			xfs_perag_put(pag);
+			return busyp;
+		}
+	}
+	xfs_perag_put(pag);
+	return NULL;
 }
 
 void
-xfs_alloc_clear_busy(xfs_trans_t *tp,
-		     xfs_agnumber_t agno,
-		     int idx)
+xfs_alloc_clear_busy(
+	struct xfs_trans	*tp,
+	struct xfs_busy_extent	*busyp)
 {
-	xfs_mount_t		*mp;
-	xfs_perag_busy_t	*list;
+	struct xfs_perag	*pag;
 
-	mp = tp->t_mountp;
+	pag = xfs_perag_get(tp->t_mountp, busyp->agno);
+	spin_lock(&pag->pagb_lock);
 
-	spin_lock(&mp->m_perag[agno].pagb_lock);
-	list = mp->m_perag[agno].pagb_list;
+	/* check that the busyp is still in the rbtree */
+	ASSERT(__xfs_alloc_busy_search(tp, busyp->agno, busyp->bno,
+						busyp->length) == busyp);
 
-	ASSERT(idx < XFS_PAGB_NUM_SLOTS);
-	if (list[idx].busy_tp == tp) {
-		TRACE_UNBUSY("xfs_alloc_clear_busy", "found", agno, idx, tp);
-		list[idx].busy_tp = NULL;
-		mp->m_perag[agno].pagb_count--;
-	} else {
-		TRACE_UNBUSY("xfs_alloc_clear_busy", "missing", agno, idx, tp);
-	}
+	TRACE_UNBUSY("xfs_alloc_clear_busy", "found", busyp->agno, busyp->bno,
+							busyp->length, tp);
+	rb_erase(&busyp->rb_node, &pag->pagb_tree);
+	spin_unlock(&pag->pagb_lock);
+	xfs_perag_put(pag);
 
-	spin_unlock(&mp->m_perag[agno].pagb_lock);
+	kmem_free(busyp);
 }
 
-
 /*
  * If we find the extent in the busy list, force the log out to get the
  * extent out of the busy list so the caller can use it straight away.
  */
 STATIC void
-xfs_alloc_search_busy(xfs_trans_t *tp,
-		    xfs_agnumber_t agno,
-		    xfs_agblock_t bno,
-		    xfs_extlen_t len)
+xfs_alloc_search_busy(
+	struct xfs_trans	*tp,
+	xfs_agnumber_t		agno,
+	xfs_agblock_t		bno,
+	xfs_extlen_t		len)
 {
-	xfs_mount_t		*mp;
-	xfs_perag_busy_t	*bsy;
-	xfs_agblock_t		uend, bend;
+	struct xfs_perag	*pag;
+	struct xfs_busy_extent	*busyp;
 	xfs_lsn_t		lsn;
-	int			cnt;
-
-	mp = tp->t_mountp;
-
-	spin_lock(&mp->m_perag[agno].pagb_lock);
-	cnt = mp->m_perag[agno].pagb_count;
-
-	uend = bno + len - 1;
 
-	/* search pagb_list for this slot, skipping open slots */
-	for (bsy = mp->m_perag[agno].pagb_list; cnt; bsy++) {
-
-		/*
-		 * (start1,length1) within (start2, length2)
-		 */
-		if (bsy->busy_tp != NULL) {
-			bend = bsy->busy_start + bsy->busy_length - 1;
-			if ((bno > bend) || (uend < bsy->busy_start)) {
-				cnt--;
-			} else {
-				TRACE_BUSYSEARCH("xfs_alloc_search_busy",
-					 "found1", agno, bno, len, tp);
-				break;
-			}
-		}
+	pag = xfs_perag_get(tp->t_mountp, agno);
+	spin_lock(&pag->pagb_lock);
+	busyp = __xfs_alloc_busy_search(tp, agno, bno, len);
+	if (!busyp) {
+		TRACE_BUSYSEARCH("xfs_alloc_search_busy", "not-found", agno, bno, len, tp);
+		spin_unlock(&pag->pagb_lock);
+		xfs_perag_put(pag);
+		return;
 	}
-
 	/*
-	 * If a block was found, force the log through the LSN of the
+	 * A block was found, force the log through the LSN of the
 	 * transaction that freed the block
 	 */
-	if (cnt) {
-		TRACE_BUSYSEARCH("xfs_alloc_search_busy", "found", agno, bno, len, tp);
-		lsn = bsy->busy_tp->t_commit_lsn;
-		spin_unlock(&mp->m_perag[agno].pagb_lock);
-		xfs_log_force(mp, lsn, XFS_LOG_FORCE|XFS_LOG_SYNC);
-	} else {
-		TRACE_BUSYSEARCH("xfs_alloc_search_busy", "not-found", agno, bno, len, tp);
-		spin_unlock(&mp->m_perag[agno].pagb_lock);
-	}
+	TRACE_BUSYSEARCH("xfs_alloc_search_busy", "found", agno, bno, len, tp);
+	lsn = busyp->tp->t_commit_lsn;
+	spin_unlock(&pag->pagb_lock);
+	xfs_log_force(tp->t_mountp, lsn, XFS_LOG_FORCE|XFS_LOG_SYNC);
+	xfs_perag_put(pag);
 }
diff --git a/fs/xfs/xfs_alloc.h b/fs/xfs/xfs_alloc.h
index 5881727..21040af 100644
--- a/fs/xfs/xfs_alloc.h
+++ b/fs/xfs/xfs_alloc.h
@@ -22,6 +22,7 @@ struct xfs_buf;
 struct xfs_mount;
 struct xfs_perag;
 struct xfs_trans;
+struct xfs_busy_extent;
 
 /*
  * Freespace allocation types.  Argument to xfs_alloc_[v]extent.
@@ -128,9 +129,7 @@ xfs_alloc_mark_busy(xfs_trans_t *tp,
 		xfs_extlen_t len);
 
 void
-xfs_alloc_clear_busy(xfs_trans_t *tp,
-		xfs_agnumber_t ag,
-		int idx);
+xfs_alloc_clear_busy(xfs_trans_t *tp, struct xfs_busy_extent *busyp);
 
 #endif	/* __KERNEL__ */
 
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 794a4e2..2239685 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -131,14 +131,8 @@ STATIC void
 xfs_free_perag(
 	xfs_mount_t	*mp)
 {
-	if (mp->m_perag) {
-		int	agno;
-
-		for (agno = 0; agno < mp->m_maxagi; agno++)
-			if (mp->m_perag[agno].pagb_list)
-				kmem_free(mp->m_perag[agno].pagb_list);
+	if (mp->m_perag)
 		kmem_free(mp->m_perag);
-	}
 }
 
 /*
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index ad137ef..e88b9bf 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -1338,10 +1338,8 @@ xfs_trans_committed(
 	lbcp = &tp->t_busy;
 	while (lbcp != NULL) {
 		for (i = 0, lbsp = lbcp->lbc_busy; i < lbcp->lbc_unused; i++, lbsp++) {
-			if (!XFS_LBC_ISFREE(lbcp, i)) {
-				xfs_alloc_clear_busy(tp, lbsp->lbc_ag,
-						     lbsp->lbc_idx);
-			}
+			if (!XFS_LBC_ISFREE(lbcp, i))
+				xfs_alloc_clear_busy(tp, lbsp->lbc_busyp);
 		}
 		lbcp = lbcp->lbc_next;
 	}
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index d6fe4a8..6a5e8d5 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -762,6 +762,7 @@ struct xfs_log_item_desc;
 struct xfs_mount;
 struct xfs_trans;
 struct xfs_dquot_acct;
+struct xfs_busy_extent;
 
 typedef struct xfs_log_item {
 	struct list_head		li_ail;		/* AIL pointers */
@@ -824,8 +825,7 @@ typedef struct xfs_item_ops {
  */
 
 typedef struct xfs_log_busy_slot {
-	xfs_agnumber_t		lbc_ag;
-	ushort			lbc_idx;	/* index in perag.busy[] */
+	struct xfs_busy_extent	*lbc_busyp;
 } xfs_log_busy_slot_t;
 
 #define XFS_LBC_NUM_SLOTS	31
@@ -971,9 +971,9 @@ int		_xfs_trans_commit(xfs_trans_t *,
 void		xfs_trans_cancel(xfs_trans_t *, int);
 int		xfs_trans_ail_init(struct xfs_mount *);
 void		xfs_trans_ail_destroy(struct xfs_mount *);
-xfs_log_busy_slot_t *xfs_trans_add_busy(xfs_trans_t *tp,
-					xfs_agnumber_t ag,
-					xfs_extlen_t idx);
+
+xfs_log_busy_slot_t *xfs_trans_add_busy(struct xfs_trans *tp,
+					struct xfs_busy_extent *busyp);
 
 extern kmem_zone_t	*xfs_trans_zone;
 
diff --git a/fs/xfs/xfs_trans_item.c b/fs/xfs/xfs_trans_item.c
index e110bf5..3baa0af 100644
--- a/fs/xfs/xfs_trans_item.c
+++ b/fs/xfs/xfs_trans_item.c
@@ -449,7 +449,9 @@ xfs_trans_unlock_chunk(
  * descriptor with its ???? field.
  */
 xfs_log_busy_slot_t *
-xfs_trans_add_busy(xfs_trans_t *tp, xfs_agnumber_t ag, xfs_extlen_t idx)
+xfs_trans_add_busy(
+	xfs_trans_t		*tp,
+	struct xfs_busy_extent	*busyp)
 {
 	xfs_log_busy_chunk_t	*lbcp;
 	xfs_log_busy_slot_t	*lbsp;
@@ -479,16 +481,8 @@ xfs_trans_add_busy(xfs_trans_t *tp, xfs_agnumber_t ag, xfs_extlen_t idx)
 		tp->t_busy.lbc_next = lbcp;
 		tp->t_busy_free = XFS_LIC_NUM_SLOTS - 1;
 
-		/*
-		 * Initialize the descriptor and the generic portion
-		 * of the log item.
-		 *
-		 * Point the new slot at this item and return it.
-		 * Also point the log item at its currently active
-		 * descriptor and set the item's mount pointer.
-		 */
-		lbsp->lbc_ag = ag;
-		lbsp->lbc_idx = idx;
+		/* Initialize the descriptor and return it */
+		lbsp->lbc_busyp = busyp;
 		return lbsp;
 	}
 
@@ -521,8 +515,7 @@ xfs_trans_add_busy(xfs_trans_t *tp, xfs_agnumber_t ag, xfs_extlen_t idx)
 	}
 	lbsp = XFS_LBC_SLOT(lbcp, i);
 	tp->t_busy_free--;
-	lbsp->lbc_ag = ag;
-	lbsp->lbc_idx = idx;
+	lbsp->lbc_busyp = busyp;
 	return lbsp;
 }
 
diff --git a/fs/xfs/xfs_trans_priv.h b/fs/xfs/xfs_trans_priv.h
index 73e2ad3..fd50556 100644
--- a/fs/xfs/xfs_trans_priv.h
+++ b/fs/xfs/xfs_trans_priv.h
@@ -39,9 +39,6 @@ void				xfs_trans_free_items(struct xfs_trans *, int);
 void				xfs_trans_unlock_items(struct xfs_trans *,
 							xfs_lsn_t);
 void				xfs_trans_free_busy(xfs_trans_t *tp);
-xfs_log_busy_slot_t		*xfs_trans_add_busy(xfs_trans_t *tp,
-						    xfs_agnumber_t ag,
-						    xfs_extlen_t idx);
 
 /*
  * AIL traversal cursor.
-- 
1.5.6.5
