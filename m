Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAT1BNSC076930 for <xfs@oss.sgi.com>; Sun, 28 Nov 2010 19:11:23 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 90C001AF8D1
	for <xfs@oss.sgi.com>; Sun, 28 Nov 2010 17:13:03 -0800 (PST)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	qDtqUktkVX2nJB12 for <xfs@oss.sgi.com>;
	Sun, 28 Nov 2010 17:13:03 -0800 (PST)
Received: from dastard (unverified [121.44.88.148])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	47443934-1927428
	for <xfs@oss.sgi.com>; Mon, 29 Nov 2010 11:43:01 +1030 (CDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1PMsIe-0000bB-0O
	for xfs@oss.sgi.com; Mon, 29 Nov 2010 12:13:00 +1100
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1PMsIO-0005V3-Ko
	for xfs@oss.sgi.com; Mon, 29 Nov 2010 12:12:44 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 8/8] xfs: use AIL bulk delete function to implement single
	delete
Date: Mon, 29 Nov 2010 12:12:32 +1100
Message-Id: <1290993152-20999-9-git-send-email-david@fromorbit.com>
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

We now have two copies of AIL delete operations that are mostly
duplicate functionality. The single log item deletes can be
implemented via the bulk updates by turning xfs_trans_ail_delete()
into a simple wrapper. This removes all the duplicate delete
functionality and associated helpers.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_trans_ail.c  |   70 +++-------------------------------------------
 fs/xfs/xfs_trans_priv.h |   20 +++++++++-----
 2 files changed, 18 insertions(+), 72 deletions(-)

diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index 2f44f92..91aaf7b 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -520,80 +520,21 @@ xfs_trans_ail_update_bulk(
 }
 
 /*
- * Delete the given item from the AIL.  It must already be in
- * the AIL.
- *
- * Wakeup anyone with an lsn less than item's lsn.    If the item
- * we delete in the AIL is the minimum one, update the tail lsn in the
- * log manager.
- *
- * Clear the IN_AIL flag from the item, reset its lsn to 0, and
- * bump the AIL's generation count to indicate that the tree
- * has changed.
- *
- * This function must be called with the AIL lock held.  The lock
- * is dropped before returning.
- */
-void
-xfs_trans_ail_delete(
-	struct xfs_ail	*ailp,
-	xfs_log_item_t	*lip) __releases(ailp->xa_lock)
-{
-	xfs_log_item_t		*mlip;
-	xfs_lsn_t		tail_lsn;
-
-	if (lip->li_flags & XFS_LI_IN_AIL) {
-		mlip = xfs_ail_min(ailp);
-		xfs_ail_delete(ailp, lip);
-
-
-		lip->li_flags &= ~XFS_LI_IN_AIL;
-		lip->li_lsn = 0;
-
-		if (mlip == lip) {
-			mlip = xfs_ail_min(ailp);
-			/*
-			 * It is not safe to access mlip after the AIL lock
-			 * is dropped, so we must get a copy of li_lsn
-			 * before we do so.  This is especially important
-			 * on 32-bit platforms where accessing and updating
-			 * 64-bit values like li_lsn is not atomic.
-			 */
-			tail_lsn = mlip ? mlip->li_lsn : 0;
-			spin_unlock(&ailp->xa_lock);
-			xfs_log_move_tail(ailp->xa_mount, tail_lsn);
-		} else {
-			spin_unlock(&ailp->xa_lock);
-		}
-	}
-	else {
-		/*
-		 * If the file system is not being shutdown, we are in
-		 * serious trouble if we get to this stage.
-		 */
-		struct xfs_mount	*mp = ailp->xa_mount;
-
-		spin_unlock(&ailp->xa_lock);
-		if (!XFS_FORCED_SHUTDOWN(mp)) {
-			xfs_cmn_err(XFS_PTAG_AILDELETE, CE_ALERT, mp,
-		"%s: attempting to delete a log item that is not in the AIL",
-					__func__);
-			xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
-		}
-	}
-}
-
-/*
  * Bulk update version of xfs_trans_ail_delete
  *
  * This version takes an array of log items that all need to removed from the
  * AIL. The caller is already holding the AIL lock, and done all the checks
  * necessary to ensure the items passed in via @lgia are ready for deletion.
+ * If an item we delete in the AIL is the minimum one, update the tail lsn in
+ * the log manager.
  *
  * This function will not drop the AIL lock until all items are removed from
  * the AIL to minimise the amount of lock traffic on the AIL. This does not
  * greatly increase the AIL hold time, but does significantly reduce the amount
  * of traffic on the lock, especially during IO completion.
+ *
+ * This function must be called with the AIL lock held.  The lock is dropped
+ * before returning.
  */
 void
 xfs_trans_ail_delete_bulk(
@@ -648,7 +589,6 @@ xfs_trans_ail_delete_bulk(
 	xfs_log_move_tail(ailp->xa_mount, tail_lsn);
 }
 
-
 /*
  * The active item list (AIL) is a doubly linked list of log
  * items sorted by ascending lsn.  The base of the list is
diff --git a/fs/xfs/xfs_trans_priv.h b/fs/xfs/xfs_trans_priv.h
index 1cf42e7..2bd3c19 100644
--- a/fs/xfs/xfs_trans_priv.h
+++ b/fs/xfs/xfs_trans_priv.h
@@ -89,13 +89,19 @@ xfs_trans_ail_update(
 	xfs_trans_ail_update_bulk(ailp, lgia, 1, lsn);
 }
 
-void			xfs_trans_ail_delete(struct xfs_ail *ailp,
-					struct xfs_log_item *lip)
-					__releases(ailp->xa_lock);
-void			xfs_trans_ail_delete_bulk(struct xfs_ail *ailp,
-					struct xfs_log_item **lgia,
-					int nr_items)
-					__releases(ailp->xa_lock);
+void	xfs_trans_ail_delete_bulk(struct xfs_ail *ailp,
+				struct xfs_log_item **lgia, int nr_items)
+				__releases(ailp->xa_lock);
+static inline void
+xfs_trans_ail_delete(
+	struct xfs_ail	*ailp,
+	xfs_log_item_t	*lip) __releases(ailp->xa_lock)
+{
+	struct xfs_log_item	*lgia[1] = { lip, };
+
+	xfs_trans_ail_delete_bulk(ailp, lgia, 1);
+}
+
 void			xfs_trans_ail_push(struct xfs_ail *, xfs_lsn_t);
 void			xfs_trans_unlocked_item(struct xfs_ail *,
 					xfs_log_item_t *);
-- 
1.7.2.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
