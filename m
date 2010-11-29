Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAT1BN8a076936 for <xfs@oss.sgi.com>; Sun, 28 Nov 2010 19:11:24 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AC2C813F658E
	for <xfs@oss.sgi.com>; Sun, 28 Nov 2010 17:13:03 -0800 (PST)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	JbWL463t3u0DAeRv for <xfs@oss.sgi.com>;
	Sun, 28 Nov 2010 17:13:03 -0800 (PST)
Received: from dastard (unverified [121.44.88.148])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	48205227-1927428
	for <xfs@oss.sgi.com>; Mon, 29 Nov 2010 11:43:01 +1030 (CDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1PMsIT-0000ad-LN
	for xfs@oss.sgi.com; Mon, 29 Nov 2010 12:12:49 +1100
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1PMsIE-0005Uk-9H
	for xfs@oss.sgi.com; Mon, 29 Nov 2010 12:12:34 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/8] xfs: Pull EFI/EFD handling out from under the AIL lock
Date: Mon, 29 Nov 2010 12:12:25 +1100
Message-Id: <1290993152-20999-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1290993152-20999-1-git-send-email-david@fromorbit.com>
References: <1290993152-20999-1-git-send-email-david@fromorbit.com>
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

EFI/EFD interactions are protected from races by the AIL lock. They
are the only type of log items that require the the AIL lock to
serialise internal state, so they need to be separated from the AIL
lock before we can do bulk insert operations on the AIL.

To acheive this, convert the counter of the number of extents in the
EFI to an atomic so it can be safely manipulated by EFD processing
without locks. Also, convert the EFI state flag manipulations to use
atomic bit operations so no locks are needed to record state
changes. Finally, use the state bits to determine when it is safe to
free the EFI and clean up the code to do this neatly.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_extfree_item.c  |   83 ++++++++++++++++++++++++--------------------
 fs/xfs/xfs_extfree_item.h  |   12 +++---
 fs/xfs/xfs_log_recover.c   |    4 +-
 fs/xfs/xfs_trans_extfree.c |    8 +++-
 4 files changed, 59 insertions(+), 48 deletions(-)

diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index a55e687..7062576 100644
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
 
@@ -289,36 +296,36 @@ xfs_efi_copy_format(xfs_log_iovec_t *buf, xfs_efi_log_format_t *dst_efi_fmt)
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
+	ASSERT(atomic_read(&efip->efi_next_extent) >= nextents);
+	if (!atomic_sub_and_test(nextents, &efip->efi_next_extent))
+		return;
 
-	spin_lock(&ailp->xa_lock);
-	ASSERT(efip->efi_next_extent >= nextents);
-	efip->efi_next_extent -= nextents;
-	extents_left = efip->efi_next_extent;
-	if (extents_left == 0) {
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
diff --git a/fs/xfs/xfs_trans_extfree.c b/fs/xfs/xfs_trans_extfree.c
index f783d5e..f7590f5 100644
--- a/fs/xfs/xfs_trans_extfree.c
+++ b/fs/xfs/xfs_trans_extfree.c
@@ -69,12 +69,16 @@ xfs_trans_log_efi_extent(xfs_trans_t		*tp,
 	tp->t_flags |= XFS_TRANS_DIRTY;
 	efip->efi_item.li_desc->lid_flags |= XFS_LID_DIRTY;
 
-	next_extent = efip->efi_next_extent;
+	/*
+	 * atomic_inc_return gives us the value after the increment;
+	 * we want to use it as an array index so we need to subtract 1 from
+	 * it.
+	 */
+	next_extent = atomic_inc_return(&efip->efi_next_extent) - 1;
 	ASSERT(next_extent < efip->efi_format.efi_nextents);
 	extp = &(efip->efi_format.efi_extents[next_extent]);
 	extp->ext_start = start_block;
 	extp->ext_len = ext_len;
-	efip->efi_next_extent++;
 }
 
 
-- 
1.7.2.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
