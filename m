Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBD4WNMJ158261 for <xfs@oss.sgi.com>; Sun, 12 Dec 2010 22:32:23 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A2ABB143FE38
	for <xfs@oss.sgi.com>; Sun, 12 Dec 2010 20:34:13 -0800 (PST)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	JbAOmSJpKeBDhvoK for <xfs@oss.sgi.com>;
	Sun, 12 Dec 2010 20:34:13 -0800 (PST)
Received: from dastard (unverified [121.44.88.148])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	49483526-1927428
	for <xfs@oss.sgi.com>; Mon, 13 Dec 2010 15:04:11 +1030 (CDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1PS06z-00021U-Qh
	for xfs@oss.sgi.com; Mon, 13 Dec 2010 15:34:09 +1100
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1PS05L-0004id-OV
	for xfs@oss.sgi.com; Mon, 13 Dec 2010 15:32:27 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 7/9] xfs: remove all the inodes on a buffer from the AIL in
	bulk
Date: Mon, 13 Dec 2010 15:32:21 +1100
Message-Id: <1292214743-18073-8-git-send-email-david@fromorbit.com>
In-Reply-To: <1292214743-18073-1-git-send-email-david@fromorbit.com>
References: <1292214743-18073-1-git-send-email-david@fromorbit.com>
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

When inode buffer IO completes, usually all of the inodes are removed from the
AIL. This involves processing them one at a time and taking the AIL lock once
for every inode. When all CPUs are processing inode IO completions, this causes
excessive amount sof contention on the AIL lock.

Instead, change the way we process inode IO completion in the buffer
IO done callback. Allow the inode IO done callback to walk the list
of IO done callbacks and pull all the inodes off the buffer in one
go and then process them as a batch.

Once all the inodes for removal are collected, take the AIL lock
once and do a bulk removal operation to minimise traffic on the AIL
lock.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_inode_item.c |   92 ++++++++++++++++++++++++++++++++++++++---------
 fs/xfs/xfs_trans_ail.c  |   73 +++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_trans_priv.h |    4 ++
 3 files changed, 152 insertions(+), 17 deletions(-)

diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 7c8d30c..fd4f398 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -842,15 +842,64 @@ xfs_inode_item_destroy(
  * flushed to disk.  It is responsible for removing the inode item
  * from the AIL if it has not been re-logged, and unlocking the inode's
  * flush lock.
+ *
+ * To reduce AIL lock traffic as much as possible, we scan the buffer log item
+ * list for other inodes that will run this function. We remove them from the
+ * buffer list so we can process all the inode IO completions in one AIL lock
+ * traversal.
  */
 void
 xfs_iflush_done(
 	struct xfs_buf		*bp,
 	struct xfs_log_item	*lip)
 {
-	struct xfs_inode_log_item *iip = INODE_ITEM(lip);
-	xfs_inode_t		*ip = iip->ili_inode;
+	struct xfs_inode_log_item *iip;
+	struct xfs_log_item	*blip;
+	struct xfs_log_item	*next;
+	struct xfs_log_item	*prev;
 	struct xfs_ail		*ailp = lip->li_ailp;
+	int			need_ail = 0;
+
+	/*
+	 * Scan the buffer IO completions for other inodes being completed and
+	 * attach them to the current inode log item.
+	 */
+	blip = XFS_BUF_FSPRIVATE(bp, xfs_log_item_t *);
+	prev = NULL;
+	while (blip != NULL) {
+		if (lip->li_cb != xfs_iflush_done) {
+			prev = blip;
+			blip = blip->li_bio_list;
+			continue;
+		}
+
+		/* remove from list */
+		next = blip->li_bio_list;
+		if (!prev) {
+			XFS_BUF_SET_FSPRIVATE(bp, next);
+		} else {
+			prev->li_bio_list = next;
+		}
+
+		/* add to current list */
+		blip->li_bio_list = lip->li_bio_list;
+		lip->li_bio_list = blip;
+
+		/*
+		 * while we have the item, do the unlocked check for needing
+		 * the AIL lock.
+		 */
+		iip = INODE_ITEM(blip);
+		if (iip->ili_logged && blip->li_lsn == iip->ili_flush_lsn)
+			need_ail++;
+
+		blip = next;
+	}
+
+	/* make sure we capture the state of the initial inode. */
+	iip = INODE_ITEM(lip);
+	if (iip->ili_logged && lip->li_lsn == iip->ili_flush_lsn)
+		need_ail++;
 
 	/*
 	 * We only want to pull the item from the AIL if it is
@@ -861,28 +910,37 @@ xfs_iflush_done(
 	 * the lock since it's cheaper, and then we recheck while
 	 * holding the lock before removing the inode from the AIL.
 	 */
-	if (iip->ili_logged && lip->li_lsn == iip->ili_flush_lsn) {
+	if (need_ail) {
+		struct xfs_log_item *log_items[need_ail];
+		int i = 0;
 		spin_lock(&ailp->xa_lock);
-		if (lip->li_lsn == iip->ili_flush_lsn) {
-			/* xfs_trans_ail_delete() drops the AIL lock. */
-			xfs_trans_ail_delete(ailp, lip);
-		} else {
-			spin_unlock(&ailp->xa_lock);
+		for (blip = lip; blip; blip = blip->li_bio_list) {
+			iip = INODE_ITEM(blip);
+			if (iip->ili_logged &&
+			    blip->li_lsn == iip->ili_flush_lsn) {
+				log_items[i++] = blip;
+			}
+			ASSERT(i <= need_ail);
 		}
+		/* xfs_trans_ail_delete_bulk() drops the AIL lock. */
+		xfs_trans_ail_delete_bulk(ailp, log_items, i);
 	}
 
-	iip->ili_logged = 0;
 
 	/*
-	 * Clear the ili_last_fields bits now that we know that the
-	 * data corresponding to them is safely on disk.
+	 * clean up and unlock the flush lock now we are done. We can clear the
+	 * ili_last_fields bits now that we know that the data corresponding to
+	 * them is safely on disk.
 	 */
-	iip->ili_last_fields = 0;
+	for (blip = lip; blip; blip = next) {
+		next = blip->li_bio_list;
+		blip->li_bio_list = NULL;
 
-	/*
-	 * Release the inode's flush lock since we're done with it.
-	 */
-	xfs_ifunlock(ip);
+		iip = INODE_ITEM(blip);
+		iip->ili_logged = 0;
+		iip->ili_last_fields = 0;
+		xfs_ifunlock(iip->ili_inode);
+	}
 }
 
 /*
diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index 726785f..a3d8406 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -639,6 +639,79 @@ xfs_trans_ail_delete(
 	}
 }
 
+/*
+ * xfs_trans_ail_delete_bulk - remove multiple log items from the AIL
+ *
+ * @xfs_trans_ail_delete_bulk takes an array of log items that all need to
+ * removed from the AIL. The caller is already holding the AIL lock, and done
+ * all the checks necessary to ensure the items passed in via @log_items are
+ * ready for deletion. This includes checking that the items are in the AIL.
+ *
+ * For each log item to be removed, unlink it  from the AIL, clear the IN_AIL
+ * flag from the item and reset the item's lsn to 0. If we remove the first
+ * item in the AIL, update the log tail to match the new minimum LSN in the
+ * AIL.
+ *
+ * This function will not drop the AIL lock until all items are removed from
+ * the AIL to minimise the amount of lock traffic on the AIL. This does not
+ * greatly increase the AIL hold time, but does significantly reduce the amount
+ * of traffic on the lock, especially during IO completion.
+ *
+ * This function must be called with the AIL lock held.  The lock is dropped
+ * before returning.
+ */
+void
+xfs_trans_ail_delete_bulk(
+	struct xfs_ail		*ailp,
+	struct xfs_log_item	**log_items,
+	int			nr_items) __releases(ailp->xa_lock)
+{
+	xfs_log_item_t		*mlip;
+	xfs_lsn_t		tail_lsn;
+	int			mlip_changed = 0;
+	int			i;
+
+	mlip = xfs_ail_min(ailp);
+
+	for (i = 0; i < nr_items; i++) {
+		struct xfs_log_item *lip = log_items[i];
+		if (!(lip->li_flags & XFS_LI_IN_AIL)) {
+			struct xfs_mount	*mp = ailp->xa_mount;
+
+			spin_unlock(&ailp->xa_lock);
+			if (!XFS_FORCED_SHUTDOWN(mp)) {
+				xfs_cmn_err(XFS_PTAG_AILDELETE, CE_ALERT, mp,
+		"%s: attempting to delete a log item that is not in the AIL",
+						__func__);
+				xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
+			}
+			return;
+		}
+
+		xfs_ail_delete(ailp, lip);
+		lip->li_flags &= ~XFS_LI_IN_AIL;
+		lip->li_lsn = 0;
+		if (mlip == lip)
+			mlip_changed = 1;
+	}
+
+	if (!mlip_changed) {
+		spin_unlock(&ailp->xa_lock);
+		return;
+	}
+
+	/*
+	 * It is not safe to access mlip after the AIL lock is dropped, so we
+	 * must get a copy of li_lsn before we do so.  This is especially
+	 * important on 32-bit platforms where accessing and updating 64-bit
+	 * values like li_lsn is not atomic. It is possible we've emptied the
+	 * AIL here, so if that is the case, pass an LSN of 0 to the tail move.
+	 */
+	mlip = xfs_ail_min(ailp);
+	tail_lsn = mlip ? mlip->li_lsn : 0;
+	spin_unlock(&ailp->xa_lock);
+	xfs_log_move_tail(ailp->xa_mount, tail_lsn);
+}
 
 
 /*
diff --git a/fs/xfs/xfs_trans_priv.h b/fs/xfs/xfs_trans_priv.h
index e039729..246ca4d 100644
--- a/fs/xfs/xfs_trans_priv.h
+++ b/fs/xfs/xfs_trans_priv.h
@@ -85,6 +85,10 @@ void			 xfs_trans_ail_update_bulk(struct xfs_ail *ailp,
 void			xfs_trans_ail_delete(struct xfs_ail *ailp,
 					struct xfs_log_item *lip)
 					__releases(ailp->xa_lock);
+void			xfs_trans_ail_delete_bulk(struct xfs_ail *ailp,
+					struct xfs_log_item **log_items,
+					int nr_items)
+					__releases(ailp->xa_lock);
 void			xfs_trans_ail_push(struct xfs_ail *, xfs_lsn_t);
 void			xfs_trans_unlocked_item(struct xfs_ail *,
 					xfs_log_item_t *);
-- 
1.7.2.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
