Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E1AF07F37
	for <xfs@oss.sgi.com>; Wed, 28 Aug 2013 06:12:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6EB73AC015
	for <xfs@oss.sgi.com>; Wed, 28 Aug 2013 04:12:11 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	ShHcA7OzGHjrh3AE for <xfs@oss.sgi.com>;
	Wed, 28 Aug 2013 04:12:09 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1VEdfP-0004vv-Cb
	for xfs@oss.sgi.com; Wed, 28 Aug 2013 21:12:03 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1VEdfP-0001fs-BQ
	for xfs@oss.sgi.com; Wed, 28 Aug 2013 21:12:03 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfs: finish removing IOP_* macros.
Date: Wed, 28 Aug 2013 21:12:03 +1000
Message-Id: <1377688323-6404-1-git-send-email-david@fromorbit.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

In optimising the CIL operations, some of the IOP_* macros for
calling log item operations were removed. Remove the rest of them as
Christoph requested.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_trans.c     | 23 +++++++++++++----------
 fs/xfs/xfs_trans.h     |  8 +-------
 fs/xfs/xfs_trans_ail.c |  4 ++--
 fs/xfs/xfs_trans_buf.c |  2 +-
 4 files changed, 17 insertions(+), 20 deletions(-)

diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index b986400..5411e01 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -716,10 +716,10 @@ xfs_trans_free_items(
 		lip->li_desc = NULL;
 
 		if (commit_lsn != NULLCOMMITLSN)
-			IOP_COMMITTING(lip, commit_lsn);
+			lip->li_ops->iop_committing(lip, commit_lsn);
 		if (flags & XFS_TRANS_ABORT)
 			lip->li_flags |= XFS_LI_ABORTED;
-		IOP_UNLOCK(lip);
+		lip->li_ops->iop_unlock(lip);
 
 		xfs_trans_free_item_desc(lidp);
 	}
@@ -739,8 +739,11 @@ xfs_log_item_batch_insert(
 	/* xfs_trans_ail_update_bulk drops ailp->xa_lock */
 	xfs_trans_ail_update_bulk(ailp, cur, log_items, nr_items, commit_lsn);
 
-	for (i = 0; i < nr_items; i++)
-		IOP_UNPIN(log_items[i], 0);
+	for (i = 0; i < nr_items; i++) {
+		struct xfs_log_item *lip = log_items[i];
+
+		lip->li_ops->iop_unpin(lip, 0);
+	}
 }
 
 /*
@@ -750,11 +753,11 @@ xfs_log_item_batch_insert(
  *
  * If we are called with the aborted flag set, it is because a log write during
  * a CIL checkpoint commit has failed. In this case, all the items in the
- * checkpoint have already gone through IOP_COMMITED and IOP_UNLOCK, which
+ * checkpoint have already gone through iop_commited and iop_unlock, which
  * means that checkpoint commit abort handling is treated exactly the same
  * as an iclog write error even though we haven't started any IO yet. Hence in
- * this case all we need to do is IOP_COMMITTED processing, followed by an
- * IOP_UNPIN(aborted) call.
+ * this case all we need to do is iop_committed processing, followed by an
+ * iop_unpin(aborted) call.
  *
  * The AIL cursor is used to optimise the insert process. If commit_lsn is not
  * at the end of the AIL, the insert cursor avoids the need to walk
@@ -787,7 +790,7 @@ xfs_trans_committed_bulk(
 
 		if (aborted)
 			lip->li_flags |= XFS_LI_ABORTED;
-		item_lsn = IOP_COMMITTED(lip, commit_lsn);
+		item_lsn = lip->li_ops->iop_committed(lip, commit_lsn);
 
 		/* item_lsn of -1 means the item needs no further processing */
 		if (XFS_LSN_CMP(item_lsn, (xfs_lsn_t)-1) == 0)
@@ -799,7 +802,7 @@ xfs_trans_committed_bulk(
 		 */
 		if (aborted) {
 			ASSERT(XFS_FORCED_SHUTDOWN(ailp->xa_mount));
-			IOP_UNPIN(lip, 1);
+			lip->li_ops->iop_unpin(lip, 1);
 			continue;
 		}
 
@@ -817,7 +820,7 @@ xfs_trans_committed_bulk(
 				xfs_trans_ail_update(ailp, lip, item_lsn);
 			else
 				spin_unlock(&ailp->xa_lock);
-			IOP_UNPIN(lip, 0);
+			lip->li_ops->iop_unpin(lip, 0);
 			continue;
 		}
 
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 4786170..09cf40b 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -77,14 +77,8 @@ struct xfs_item_ops {
 	void (*iop_committing)(xfs_log_item_t *, xfs_lsn_t);
 };
 
-#define IOP_UNPIN(ip, remove)	(*(ip)->li_ops->iop_unpin)(ip, remove)
-#define IOP_PUSH(ip, list)	(*(ip)->li_ops->iop_push)(ip, list)
-#define IOP_UNLOCK(ip)		(*(ip)->li_ops->iop_unlock)(ip)
-#define IOP_COMMITTED(ip, lsn)	(*(ip)->li_ops->iop_committed)(ip, lsn)
-#define IOP_COMMITTING(ip, lsn) (*(ip)->li_ops->iop_committing)(ip, lsn)
-
 /*
- * Return values for the IOP_PUSH() routines.
+ * Return values for the iop_push() routines.
  */
 #define XFS_ITEM_SUCCESS	0
 #define XFS_ITEM_PINNED		1
diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index 0e7df03..21c6d7d 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -379,11 +379,11 @@ xfsaild_push(
 		int	lock_result;
 
 		/*
-		 * Note that IOP_PUSH may unlock and reacquire the AIL lock.  We
+		 * Note that iop_push may unlock and reacquire the AIL lock.  We
 		 * rely on the AIL cursor implementation to be able to deal with
 		 * the dropped lock.
 		 */
-		lock_result = IOP_PUSH(lip, &ailp->xa_buf_list);
+		lock_result = lip->li_ops->iop_push(lip, &ailp->xa_buf_list);
 		switch (lock_result) {
 		case XFS_ITEM_SUCCESS:
 			XFS_STATS_INC(xs_push_ail_success);
diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
index aa5a04b..8c75b8f 100644
--- a/fs/xfs/xfs_trans_buf.c
+++ b/fs/xfs/xfs_trans_buf.c
@@ -505,7 +505,7 @@ xfs_trans_brelse(xfs_trans_t	*tp,
 
 /*
  * Mark the buffer as not needing to be unlocked when the buf item's
- * IOP_UNLOCK() routine is called.  The buffer must already be locked
+ * iop_unlock() routine is called.  The buffer must already be locked
  * and associated with the given transaction.
  */
 /* ARGSUSED */
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
