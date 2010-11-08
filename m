Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oA88tFIQ089693 for <xfs@oss.sgi.com>; Mon, 8 Nov 2010 02:55:16 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9D6661398EEE
	for <xfs@oss.sgi.com>; Mon,  8 Nov 2010 00:56:40 -0800 (PST)
Received: from mail.internode.on.net (bld-mail14.adl6.internode.on.net
	[150.101.137.99]) by cuda.sgi.com with ESMTP id
	YvGCiacmpZ0TOHTV for <xfs@oss.sgi.com>;
	Mon, 08 Nov 2010 00:56:40 -0800 (PST)
Received: from dastard (unverified [121.44.100.105])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	46083259-1927428
	for <xfs@oss.sgi.com>; Mon, 08 Nov 2010 19:26:39 +1030 (CDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1PFNWc-0001Cy-V3
	for xfs@oss.sgi.com; Mon, 08 Nov 2010 19:56:26 +1100
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1PFNVl-0004np-4u
	for xfs@oss.sgi.com; Mon, 08 Nov 2010 19:55:33 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 12/16] xfs: bulk AIL insertion during transaction commit
Date: Mon,  8 Nov 2010 19:55:15 +1100
Message-Id: <1289206519-18377-13-git-send-email-david@fromorbit.com>
In-Reply-To: <1289206519-18377-1-git-send-email-david@fromorbit.com>
References: <1289206519-18377-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

When inserting items into the AIL from the transaction committed
callbacks, we take the AIL lock for every single item that is to be
inserted. For a CIL checkpoint commit, this can be tens of thousands
of individual inserts, yet almost all of the items will be inserted
at the same point in the AIL because they have the same index.

To reduce the overhead and contention on the AIL lock for such
operations, introduce a "bulk insert" operation which allows a list
of log items with the same LSN to be inserted in a single operation
via a list splice. To do this, we need to pre-sort the log items
being committed into a temporary list for insertion.

The complexity is that not every log item will end up with the same
LSN, and not every item is actually inserted into the AIL. Items
that don't match the commit LSN will be inserted and unpinned as per
the current one-at-a-time method (relatively rare), while items that
are not to be inserted will be unpinned and freed immediately. Items
that are to be inserted at the given commit lsn are placed in a
temporary array and inserted into the AIL in bulk each time the
array fills up.

As a result of this, we trade off AIL hold time for a significant
reduction in traffic. lock_stat output shows that the worst case
hold time is unchanged, but contention from AIL inserts drops by an
order of magnitude and the number of lock traversal decreases
significantly.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_extfree_item.c  |   85 +++++++++++++++++-------------
 fs/xfs/xfs_extfree_item.h  |   12 ++--
 fs/xfs/xfs_inode_item.c    |   20 +++++++
 fs/xfs/xfs_log_cil.c       |    9 +---
 fs/xfs/xfs_log_recover.c   |    4 +-
 fs/xfs/xfs_trans.c         |   70 ++++++++++++++++++++++++-
 fs/xfs/xfs_trans_ail.c     |  124 +++++++++++++++++++++++++++++++++++++-------
 fs/xfs/xfs_trans_extfree.c |    4 +-
 fs/xfs/xfs_trans_priv.h    |    9 +++-
 9 files changed, 259 insertions(+), 78 deletions(-)

diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index a55e687..5e16d7d 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -74,7 +74,8 @@ xfs_efi_item_format(
 	struct xfs_efi_log_item	*efip = EFI_ITEM(lip);
 	uint			size;
 
-	ASSERT(efip->efi_next_extent == efip->efi_format.efi_nextents);
+	ASSERT(atomic_read(&efip->efi_next_extent) ==
+				efip->efi_format.efi_nextents);
 
 	efip->efi_format.efi_type = XFS_LI_EFI;
 
@@ -99,10 +100,10 @@ xfs_efi_item_pin(
 }
 
 /*
- * While EFIs cannot really be pinned, the unpin operation is the
- * last place at which the EFI is manipulated during a transaction.
- * Here we coordinate with xfs_efi_cancel() to determine who gets to
- * free the EFI.
+ * While EFIs cannot really be pinned, the unpin operation is the last place at
+ * which the EFI is manipulated during a transaction.  Here we coordinate with
+ * xfs_efi_release() (via XFS_EFI_COMMITTED) to determine who gets to free
+ * the EFI.
  */
 STATIC void
 xfs_efi_item_unpin(
@@ -112,18 +113,18 @@ xfs_efi_item_unpin(
 	struct xfs_efi_log_item	*efip = EFI_ITEM(lip);
 	struct xfs_ail		*ailp = lip->li_ailp;
 
-	spin_lock(&ailp->xa_lock);
-	if (efip->efi_flags & XFS_EFI_CANCELED) {
-		if (remove)
-			xfs_trans_del_item(lip);
-
-		/* xfs_trans_ail_delete() drops the AIL lock. */
-		xfs_trans_ail_delete(ailp, lip);
-		xfs_efi_item_free(efip);
-	} else {
-		efip->efi_flags |= XFS_EFI_COMMITTED;
-		spin_unlock(&ailp->xa_lock);
+	if (remove) {
+		/* transaction cancel - delete and free the item */
+		xfs_trans_del_item(lip);
+	} else if (test_and_clear_bit(XFS_EFI_COMMITTED, &efip->efi_flags)) {
+		/* efd has not be processed yet, it will free the efi */
+		return;
 	}
+
+	spin_lock(&ailp->xa_lock);
+	/* xfs_trans_ail_delete() drops the AIL lock. */
+	xfs_trans_ail_delete(ailp, lip);
+	xfs_efi_item_free(efip);
 }
 
 /*
@@ -152,16 +153,22 @@ xfs_efi_item_unlock(
 }
 
 /*
- * The EFI is logged only once and cannot be moved in the log, so
- * simply return the lsn at which it's been logged.  The canceled
- * flag is not paid any attention here.  Checking for that is delayed
- * until the EFI is unpinned.
+ * The EFI is logged only once and cannot be moved in the log, so simply return
+ * the lsn at which it's been logged.  The canceled flag is not paid any
+ * attention here.  Checking for that is delayed until the EFI is unpinned.
+ *
+ * For bulk transaction committed processing, the EFI may be processed but not
+ * yet unpinned prior to the EFD being processed. Set the XFS_EFI_COMMITTED
+ * flag so this case can be detected when processing the EFD.
  */
 STATIC xfs_lsn_t
 xfs_efi_item_committed(
 	struct xfs_log_item	*lip,
 	xfs_lsn_t		lsn)
 {
+	struct xfs_efi_log_item	*efip = EFI_ITEM(lip);
+
+	set_bit(XFS_EFI_COMMITTED, &efip->efi_flags);
 	return lsn;
 }
 
@@ -289,36 +296,38 @@ xfs_efi_copy_format(xfs_log_iovec_t *buf, xfs_efi_log_format_t *dst_efi_fmt)
 }
 
 /*
- * This is called by the efd item code below to release references to
- * the given efi item.  Each efd calls this with the number of
- * extents that it has logged, and when the sum of these reaches
- * the total number of extents logged by this efi item we can free
- * the efi item.
+ * This is called by the efd item code below to release references to the given
+ * efi item.  Each efd calls this with the number of extents that it has
+ * logged, and when the sum of these reaches the total number of extents logged
+ * by this efi item we can free the efi item.
+ *
+ * Freeing the efi item requires that we remove it from the AIL if it has
+ * already been placed there. However, the EFI may not yet have been placed in
+ * the AIL due to a bulk insert operation, so we have to be careful here. This
+ * case is detected if the XFS_EFI_COMMITTED flag is set. This code is
+ * tricky - both xfs_efi_item_unpin() and this code do test_and_clear_bit()
+ * operations on this flag - if it is not set here, then it means that the
+ * unpin has run and we don't need to free it. If it is set here, then we clear
+ * it to tell the unpin we have run and that the unpin needs to free the EFI.
  *
- * Freeing the efi item requires that we remove it from the AIL.
- * We'll use the AIL lock to protect our counters as well as
- * the removal from the AIL.
  */
 void
 xfs_efi_release(xfs_efi_log_item_t	*efip,
 		uint			nextents)
 {
 	struct xfs_ail		*ailp = efip->efi_item.li_ailp;
-	int			extents_left;
 
-	ASSERT(efip->efi_next_extent > 0);
-	ASSERT(efip->efi_flags & XFS_EFI_COMMITTED);
+	ASSERT(atomic_read(&efip->efi_next_extent) > 0);
 
-	spin_lock(&ailp->xa_lock);
-	ASSERT(efip->efi_next_extent >= nextents);
-	efip->efi_next_extent -= nextents;
-	extents_left = efip->efi_next_extent;
-	if (extents_left == 0) {
+	ASSERT(atomic_read(&efip->efi_next_extent) >= nextents);
+	if (!atomic_sub_and_test(nextents, &efip->efi_next_extent))
+		return;
+
+	if (!test_and_clear_bit(XFS_EFI_COMMITTED, &efip->efi_flags)) {
+		spin_lock(&ailp->xa_lock);
 		/* xfs_trans_ail_delete() drops the AIL lock. */
 		xfs_trans_ail_delete(ailp, (xfs_log_item_t *)efip);
 		xfs_efi_item_free(efip);
-	} else {
-		spin_unlock(&ailp->xa_lock);
 	}
 }
 
diff --git a/fs/xfs/xfs_extfree_item.h b/fs/xfs/xfs_extfree_item.h
index 0d22c56..26a7550 100644
--- a/fs/xfs/xfs_extfree_item.h
+++ b/fs/xfs/xfs_extfree_item.h
@@ -111,11 +111,11 @@ typedef struct xfs_efd_log_format_64 {
 #define	XFS_EFI_MAX_FAST_EXTENTS	16
 
 /*
- * Define EFI flags.
+ * Define EFI flag bits. Manipulated by set/clear/test_bit operators.
  */
-#define	XFS_EFI_RECOVERED	0x1
-#define	XFS_EFI_COMMITTED	0x2
-#define	XFS_EFI_CANCELED	0x4
+#define	XFS_EFI_RECOVERED	1
+#define	XFS_EFI_CANCELED	2
+#define	XFS_EFI_COMMITTED	3
 
 /*
  * This is the "extent free intention" log item.  It is used
@@ -125,8 +125,8 @@ typedef struct xfs_efd_log_format_64 {
  */
 typedef struct xfs_efi_log_item {
 	xfs_log_item_t		efi_item;
-	uint			efi_flags;	/* misc flags */
-	uint			efi_next_extent;
+	atomic_t		efi_next_extent;
+	unsigned long		efi_flags;	/* misc flags */
 	xfs_efi_log_format_t	efi_format;
 } xfs_efi_log_item_t;
 
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index c7ac020..3be7bdc 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -663,12 +663,32 @@ xfs_inode_item_unlock(
  * all dirty data in an inode, the latest copy in the on disk log
  * is the only one that matters.  Therefore, simply return the
  * given lsn.
+ *
+ * If the inode has been marked stale because the cluster is being freed,
+ * we don't want to (re-)insert this inode into the AIL. There is a race
+ * condition where the cluster buffer may be unpinned before the inode is
+ * inserted into the AIL during transaction committed processing. If the buffer
+ * is unpinned before the inode item has been committed and inserted, then
+ * it is possible for the buffer to be written and process IO completions
+ * before the inode is inserted into the AIL. In that case, we'd be inserting a
+ * clean, stale inode into the AIL which will never get removed. It will,
+ * however, get reclaimed which triggers an assert in xfs_inode_free()
+ * complaining about freein an inode still in the AIL.
+ *
+ * To avoid this, return a lower LSN than the one passed in so that the
+ * transaction committed code will not move the inode forward in the AIL
+ * but will still unpin it properly.
  */
 STATIC xfs_lsn_t
 xfs_inode_item_committed(
 	struct xfs_log_item	*lip,
 	xfs_lsn_t		lsn)
 {
+	struct xfs_inode_log_item *iip = INODE_ITEM(lip);
+	struct xfs_inode	*ip = iip->ili_inode;
+
+	if (xfs_iflags_test(ip, XFS_ISTALE))
+		return lsn - 1;
 	return lsn;
 }
 
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 23d6ceb..f36f1a2 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -361,15 +361,10 @@ xlog_cil_committed(
 	int	abort)
 {
 	struct xfs_cil_ctx	*ctx = args;
-	struct xfs_log_vec	*lv;
-	int			abortflag = abort ? XFS_LI_ABORTED : 0;
 	struct xfs_busy_extent	*busyp, *n;
 
-	/* unpin all the log items */
-	for (lv = ctx->lv_chain; lv; lv = lv->lv_next ) {
-		xfs_trans_item_committed(lv->lv_item, ctx->start_lsn,
-							abortflag);
-	}
+	xfs_trans_committed_bulk(ctx->cil->xc_log->l_ailp, ctx->lv_chain,
+					ctx->start_lsn, abort);
 
 	list_for_each_entry_safe(busyp, n, &ctx->busy_extents, list)
 		xfs_alloc_busy_clear(ctx->cil->xc_log->l_mp, busyp);
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 966d3f9..baad94a 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2717,8 +2717,8 @@ xlog_recover_do_efi_trans(
 		xfs_efi_item_free(efip);
 		return error;
 	}
-	efip->efi_next_extent = efi_formatp->efi_nextents;
-	efip->efi_flags |= XFS_EFI_COMMITTED;
+	atomic_set(&efip->efi_next_extent, efi_formatp->efi_nextents);
+	clear_bit(XFS_EFI_COMMITTED, &efip->efi_flags);
 
 	spin_lock(&log->l_ailp->xa_lock);
 	/*
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index f6d956b..5180b18 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -1350,7 +1350,7 @@ xfs_trans_fill_vecs(
  * they could be immediately flushed and we'd have to race with the flusher
  * trying to pull the item from the AIL as we add it.
  */
-void
+static void
 xfs_trans_item_committed(
 	struct xfs_log_item	*lip,
 	xfs_lsn_t		commit_lsn,
@@ -1426,6 +1426,74 @@ xfs_trans_committed(
 }
 
 /*
+ * Bulk operation version of xfs_trans_committed that takes a log vector of
+ * items to insert into the AIL. This uses bulk AIL insertion techniques to
+ * minimise lock traffic.
+ */
+void
+xfs_trans_committed_bulk(
+	struct xfs_ail		*ailp,
+	struct xfs_log_vec	*log_vector,
+	xfs_lsn_t		commit_lsn,
+	int			aborted)
+{
+#define LGIA_SIZE	32
+	struct xfs_log_item	*lgia[LGIA_SIZE];
+	struct xfs_log_vec	*lv;
+	int			i = 0;
+
+	/* unpin all the log items */
+	for (lv = log_vector; lv; lv = lv->lv_next ) {
+		struct xfs_log_item	*lip = lv->lv_item;
+		xfs_lsn_t		item_lsn;
+
+		if (aborted)
+			lip->li_flags |= XFS_LI_ABORTED;
+		item_lsn = IOP_COMMITTED(lip, commit_lsn);
+
+		/* item_lsn of -1 means the item was freed */
+		if (XFS_LSN_CMP(item_lsn, (xfs_lsn_t)-1) == 0)
+			continue;
+
+		if (item_lsn != commit_lsn) {
+
+			/*
+			 * Not a bulk update option due to unusual item_lsn.
+			 * Push into AIL immediately, rechecking the lsn once
+			 * we have the ail lock. Then unpin the item.
+			 */
+			spin_lock(&ailp->xa_lock);
+			if (XFS_LSN_CMP(item_lsn, lip->li_lsn) > 0) {
+				xfs_trans_ail_update(ailp, lip, item_lsn);
+			} else {
+				spin_unlock(&ailp->xa_lock);
+			}
+			IOP_UNPIN(lip, 0);
+			continue;
+		}
+
+		/* Item is a candidate for bulk AIL insert.  */
+		lgia[i++] = lv->lv_item;
+		if (i >= LGIA_SIZE) {
+			xfs_trans_ail_update_bulk(ailp, lgia, LGIA_SIZE,
+							commit_lsn);
+			for (i = 0; i < LGIA_SIZE; i++)
+				IOP_UNPIN(lgia[i], 0);
+			i = 0;
+		}
+	}
+
+	/* make sure we insert the remainder! */
+	if (i) {
+		int j;
+
+		xfs_trans_ail_update_bulk(ailp, lgia, i, commit_lsn);
+		for (j = 0; j < i; j++)
+			IOP_UNPIN(lgia[j], 0);
+	}
+}
+
+/*
  * Called from the trans_commit code when we notice that
  * the filesystem is in the middle of a forced shutdown.
  */
diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index dc90695..c83e6e9 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -29,7 +29,8 @@
 #include "xfs_error.h"
 
 STATIC void xfs_ail_insert(struct xfs_ail *, xfs_log_item_t *);
-STATIC xfs_log_item_t * xfs_ail_delete(struct xfs_ail *, xfs_log_item_t *);
+STATIC void xfs_ail_splice(struct xfs_ail *, struct list_head *, xfs_lsn_t);
+STATIC void xfs_ail_delete(struct xfs_ail *, xfs_log_item_t *);
 STATIC xfs_log_item_t * xfs_ail_min(struct xfs_ail *);
 STATIC xfs_log_item_t * xfs_ail_next(struct xfs_ail *, xfs_log_item_t *);
 
@@ -468,16 +469,13 @@ xfs_trans_ail_update(
 	xfs_log_item_t	*lip,
 	xfs_lsn_t	lsn) __releases(ailp->xa_lock)
 {
-	xfs_log_item_t		*dlip = NULL;
 	xfs_log_item_t		*mlip;	/* ptr to minimum lip */
 	xfs_lsn_t		tail_lsn;
 
 	mlip = xfs_ail_min(ailp);
 
 	if (lip->li_flags & XFS_LI_IN_AIL) {
-		dlip = xfs_ail_delete(ailp, lip);
-		ASSERT(dlip == lip);
-		xfs_trans_ail_cursor_clear(ailp, dlip);
+		xfs_ail_delete(ailp, lip);
 	} else {
 		lip->li_flags |= XFS_LI_IN_AIL;
 	}
@@ -485,7 +483,7 @@ xfs_trans_ail_update(
 	lip->li_lsn = lsn;
 	xfs_ail_insert(ailp, lip);
 
-	if (mlip == dlip) {
+	if (mlip == lip) {
 		mlip = xfs_ail_min(ailp);
 		/*
 		 * It is not safe to access mlip after the AIL lock is
@@ -505,6 +503,74 @@ xfs_trans_ail_update(
 }	/* xfs_trans_update_ail */
 
 /*
+ * Bulk update version of xfs_trans_ail_update.
+ *
+ * This version takes an array of log items that all need to be positioned at
+ * the same LSN in the AIL. This function takes the AIL lock once to execute
+ * the update operations on all the items in the array, and as such shoul dnot
+ * be called with the AIL lock held. As a result, once we have the AIL lock,
+ * we need to check each log item LSN to confirm it needs to be moved forward
+ * in the AIL.
+ *
+ * To optimise the insert operation, we delete all the items from the AIL in
+ * the first pass, moving them into a temporary list, then splice the temporary
+ * list into the correct position in the AIL. THis avoids needing to do an
+ * insert operation on every item.
+ */
+void
+xfs_trans_ail_update_bulk(
+	struct xfs_ail		*ailp,
+	struct xfs_log_item	**lgia,
+	int			nr_items,
+	xfs_lsn_t		lsn)
+{
+	xfs_log_item_t		*mlip;
+	int			mlip_changed = 0;
+	int			i;
+	LIST_HEAD(tmp);
+
+	spin_lock(&ailp->xa_lock);
+	mlip = xfs_ail_min(ailp);
+
+	for (i = 0; i < nr_items; i++) {
+		struct xfs_log_item *lip = lgia[i];
+		if (lip->li_flags & XFS_LI_IN_AIL) {
+			/* check if we really need to move the item */
+			if (XFS_LSN_CMP(lsn, lip->li_lsn) <= 0)
+				continue;
+
+			xfs_ail_delete(ailp, lip);
+			if (mlip == lip)
+				mlip_changed = 1;
+		} else {
+			lip->li_flags |= XFS_LI_IN_AIL;
+		}
+		lip->li_lsn = lsn;
+		list_add(&lip->li_ail, &tmp);
+	}
+
+	xfs_ail_splice(ailp, &tmp, lsn);
+
+	if (mlip_changed) {
+		/*
+		 * It is not safe to access mlip after the AIL lock is
+		 * dropped, so we must get a copy of li_lsn before we do
+		 * so.  This is especially important on 32-bit platforms
+		 * where accessing and updating 64-bit values like li_lsn
+		 * is not atomic.
+		 */
+		xfs_lsn_t	tail_lsn;
+
+		mlip = xfs_ail_min(ailp);
+		tail_lsn = mlip->li_lsn;
+		spin_unlock(&ailp->xa_lock);
+		xfs_log_move_tail(ailp->xa_mount, tail_lsn);
+		return;
+	}
+	spin_unlock(&ailp->xa_lock);
+}
+
+/*
  * Delete the given item from the AIL.  It must already be in
  * the AIL.
  *
@@ -524,21 +590,18 @@ xfs_trans_ail_delete(
 	struct xfs_ail	*ailp,
 	xfs_log_item_t	*lip) __releases(ailp->xa_lock)
 {
-	xfs_log_item_t		*dlip;
 	xfs_log_item_t		*mlip;
 	xfs_lsn_t		tail_lsn;
 
 	if (lip->li_flags & XFS_LI_IN_AIL) {
 		mlip = xfs_ail_min(ailp);
-		dlip = xfs_ail_delete(ailp, lip);
-		ASSERT(dlip == lip);
-		xfs_trans_ail_cursor_clear(ailp, dlip);
+		xfs_ail_delete(ailp, lip);
 
 
 		lip->li_flags &= ~XFS_LI_IN_AIL;
 		lip->li_lsn = 0;
 
-		if (mlip == dlip) {
+		if (mlip == lip) {
 			mlip = xfs_ail_min(ailp);
 			/*
 			 * It is not safe to access mlip after the AIL lock
@@ -632,7 +695,6 @@ STATIC void
 xfs_ail_insert(
 	struct xfs_ail	*ailp,
 	xfs_log_item_t	*lip)
-/* ARGSUSED */
 {
 	xfs_log_item_t	*next_lip;
 
@@ -658,21 +720,45 @@ xfs_ail_insert(
 	return;
 }
 
+STATIC void
+xfs_ail_splice(
+	struct xfs_ail	*ailp,
+	struct list_head *list,
+	xfs_lsn_t	lsn)
+{
+	xfs_log_item_t	*next_lip;
+
+	/*
+	 * If the list is empty, just insert the item.
+	 */
+	if (list_empty(&ailp->xa_ail)) {
+		list_splice(list, &ailp->xa_ail);
+		return;
+	}
+
+	list_for_each_entry_reverse(next_lip, &ailp->xa_ail, li_ail) {
+		if (XFS_LSN_CMP(next_lip->li_lsn, lsn) <= 0)
+			break;
+	}
+
+	ASSERT((&next_lip->li_ail == &ailp->xa_ail) ||
+	       (XFS_LSN_CMP(next_lip->li_lsn, lsn) <= 0));
+
+	list_splice_init(list, &next_lip->li_ail);
+	return;
+}
+
 /*
  * Delete the given item from the AIL.  Return a pointer to the item.
  */
-/*ARGSUSED*/
-STATIC xfs_log_item_t *
+STATIC void
 xfs_ail_delete(
 	struct xfs_ail	*ailp,
 	xfs_log_item_t	*lip)
-/* ARGSUSED */
 {
 	xfs_ail_check(ailp, lip);
-
 	list_del(&lip->li_ail);
-
-	return lip;
+	xfs_trans_ail_cursor_clear(ailp, lip);
 }
 
 /*
@@ -682,7 +768,6 @@ xfs_ail_delete(
 STATIC xfs_log_item_t *
 xfs_ail_min(
 	struct xfs_ail	*ailp)
-/* ARGSUSED */
 {
 	if (list_empty(&ailp->xa_ail))
 		return NULL;
@@ -699,7 +784,6 @@ STATIC xfs_log_item_t *
 xfs_ail_next(
 	struct xfs_ail	*ailp,
 	xfs_log_item_t	*lip)
-/* ARGSUSED */
 {
 	if (lip->li_ail.next == &ailp->xa_ail)
 		return NULL;
diff --git a/fs/xfs/xfs_trans_extfree.c b/fs/xfs/xfs_trans_extfree.c
index f783d5e..143ff840 100644
--- a/fs/xfs/xfs_trans_extfree.c
+++ b/fs/xfs/xfs_trans_extfree.c
@@ -69,12 +69,12 @@ xfs_trans_log_efi_extent(xfs_trans_t		*tp,
 	tp->t_flags |= XFS_TRANS_DIRTY;
 	efip->efi_item.li_desc->lid_flags |= XFS_LID_DIRTY;
 
-	next_extent = efip->efi_next_extent;
+	next_extent = atomic_read(&efip->efi_next_extent);
 	ASSERT(next_extent < efip->efi_format.efi_nextents);
 	extp = &(efip->efi_format.efi_extents[next_extent]);
 	extp->ext_start = start_block;
 	extp->ext_len = ext_len;
-	efip->efi_next_extent++;
+	atomic_inc(&efip->efi_next_extent);
 }
 
 
diff --git a/fs/xfs/xfs_trans_priv.h b/fs/xfs/xfs_trans_priv.h
index 62da86c..d25460f 100644
--- a/fs/xfs/xfs_trans_priv.h
+++ b/fs/xfs/xfs_trans_priv.h
@@ -22,15 +22,17 @@ struct xfs_log_item;
 struct xfs_log_item_desc;
 struct xfs_mount;
 struct xfs_trans;
+struct xfs_ail;
+struct xfs_log_vec;
 
 void	xfs_trans_add_item(struct xfs_trans *, struct xfs_log_item *);
 void	xfs_trans_del_item(struct xfs_log_item *);
 void	xfs_trans_free_items(struct xfs_trans *tp, xfs_lsn_t commit_lsn,
 				int flags);
-void	xfs_trans_item_committed(struct xfs_log_item *lip,
-				xfs_lsn_t commit_lsn, int aborted);
 void	xfs_trans_unreserve_and_mod_sb(struct xfs_trans *tp);
 
+void	xfs_trans_committed_bulk(struct xfs_ail *ailp, struct xfs_log_vec *lv,
+				xfs_lsn_t commit_lsn, int aborted);
 /*
  * AIL traversal cursor.
  *
@@ -76,6 +78,9 @@ struct xfs_ail {
 void			xfs_trans_ail_update(struct xfs_ail *ailp,
 					struct xfs_log_item *lip, xfs_lsn_t lsn)
 					__releases(ailp->xa_lock);
+void			 xfs_trans_ail_update_bulk(struct xfs_ail *ailp,
+					struct xfs_log_item **lgia,
+					int nr_items, xfs_lsn_t lsn);
 void			xfs_trans_ail_delete(struct xfs_ail *ailp,
 					struct xfs_log_item *lip)
 					__releases(ailp->xa_lock);
-- 
1.7.2.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
