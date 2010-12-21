Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBL7SL6R244786 for <xfs@oss.sgi.com>; Tue, 21 Dec 2010 01:28:21 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AE63621202B
	for <xfs@oss.sgi.com>; Mon, 20 Dec 2010 23:30:17 -0800 (PST)
Received: from mail.internode.on.net (bld-mail15.adl6.internode.on.net
	[150.101.137.100]) by cuda.sgi.com with ESMTP id
	hymCAFgU18PH7Hhu for <xfs@oss.sgi.com>;
	Mon, 20 Dec 2010 23:30:17 -0800 (PST)
Received: from dastard (unverified [121.44.88.148])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	39223389-1927428
	for <xfs@oss.sgi.com>; Tue, 21 Dec 2010 18:00:16 +1030 (CDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1PUwfd-0001DW-D6
	for xfs@oss.sgi.com; Tue, 21 Dec 2010 18:30:05 +1100
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1PUwfS-0006Zi-0l
	for xfs@oss.sgi.com; Tue, 21 Dec 2010 18:29:54 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 22/34] xfs: use AIL bulk delete function to implement single
	delete
Date: Tue, 21 Dec 2010 18:29:18 +1100
Message-Id: <1292916570-25015-23-git-send-email-david@fromorbit.com>
In-Reply-To: <1292916570-25015-1-git-send-email-david@fromorbit.com>
References: <1292916570-25015-1-git-send-email-david@fromorbit.com>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_trans_ail.c  |   65 -----------------------------------------------
 fs/xfs/xfs_trans_priv.h |   18 ++++++++-----
 2 files changed, 11 insertions(+), 72 deletions(-)

diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index 8481a5a..c5bbbc4 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -523,70 +523,6 @@ xfs_trans_ail_update_bulk(
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
  * xfs_trans_ail_delete_bulk - remove multiple log items from the AIL
  *
  * @xfs_trans_ail_delete_bulk takes an array of log items that all need to
@@ -660,7 +596,6 @@ xfs_trans_ail_delete_bulk(
 	xfs_log_move_tail(ailp->xa_mount, tail_lsn);
 }
 
-
 /*
  * The active item list (AIL) is a doubly linked list of log
  * items sorted by ascending lsn.  The base of the list is
diff --git a/fs/xfs/xfs_trans_priv.h b/fs/xfs/xfs_trans_priv.h
index f469205..35162c2 100644
--- a/fs/xfs/xfs_trans_priv.h
+++ b/fs/xfs/xfs_trans_priv.h
@@ -87,13 +87,17 @@ xfs_trans_ail_update(
 	xfs_trans_ail_update_bulk(ailp, &lip, 1, lsn);
 }
 
-void			xfs_trans_ail_delete(struct xfs_ail *ailp,
-					struct xfs_log_item *lip)
-					__releases(ailp->xa_lock);
-void			xfs_trans_ail_delete_bulk(struct xfs_ail *ailp,
-					struct xfs_log_item **log_items,
-					int nr_items)
-					__releases(ailp->xa_lock);
+void	xfs_trans_ail_delete_bulk(struct xfs_ail *ailp,
+				struct xfs_log_item **log_items, int nr_items)
+				__releases(ailp->xa_lock);
+static inline void
+xfs_trans_ail_delete(
+	struct xfs_ail	*ailp,
+	xfs_log_item_t	*lip) __releases(ailp->xa_lock)
+{
+	xfs_trans_ail_delete_bulk(ailp, &lip, 1);
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
