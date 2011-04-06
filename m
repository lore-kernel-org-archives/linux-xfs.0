Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p366GIXx019695 for <xfs@oss.sgi.com>; Wed, 6 Apr 2011 01:16:19 -0500
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A9E513A8A9A
	for <xfs@oss.sgi.com>; Tue,  5 Apr 2011 23:19:33 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	jU3cswq0eEUF5mxr for <xfs@oss.sgi.com>;
	Tue, 05 Apr 2011 23:19:33 -0700 (PDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1Q7M5H-00040a-1a
	for xfs@oss.sgi.com; Wed, 06 Apr 2011 16:19:19 +1000
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1Q7M5I-0004WT-SD
	for xfs@oss.sgi.com; Wed, 06 Apr 2011 16:19:20 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 7/9] xfs: push the AIL from memory reclaim and periodic sync
Date: Wed,  6 Apr 2011 16:19:16 +1000
Message-Id: <1302070758-17312-8-git-send-email-david@fromorbit.com>
In-Reply-To: <1302070758-17312-1-git-send-email-david@fromorbit.com>
References: <1302070758-17312-1-git-send-email-david@fromorbit.com>
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

When we are short on memory, we want to expedite the cleaning of
dirty objects.  Hence when we run short on memory, we need to kick
the AIL flushing into action to clean as many dirty objects as
quickly as possible.  To implement this, sample the lsn of the log
item at the head of the AIL and use that as the push target for the
AIL flush.

Further, we keep items in the AIL that are dirty that are not
tracked any other way, so we can get objects sitting in the AIL that
don't get written back until the AIL is pushed. Hence to get the
filesystem to the idle state, we might need to push the AIL to flush
out any remaining dirty objects sitting in the AIL. This requires
the same push mechanism as the reclaim push.

This patch also renames xfs_trans_ail_tail() to xfs_ail_min_lsn() to
match the new xfs_ail_max_lsn() function introduced in this patch.
Similarly for xfs_trans_ail_push -> xfs_ail_push.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/linux-2.6/xfs_sync.c |    7 +++++-
 fs/xfs/xfs_log.c            |    6 ++--
 fs/xfs/xfs_trans_ail.c      |   52 ++++++++++++++++++++++++++++++++++++++++--
 fs/xfs/xfs_trans_priv.h     |    7 +++--
 4 files changed, 62 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_sync.c b/fs/xfs/linux-2.6/xfs_sync.c
index 011dbac..36be592 100644
--- a/fs/xfs/linux-2.6/xfs_sync.c
+++ b/fs/xfs/linux-2.6/xfs_sync.c
@@ -22,6 +22,7 @@
 #include "xfs_log.h"
 #include "xfs_inum.h"
 #include "xfs_trans.h"
+#include "xfs_trans_priv.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_mount.h"
@@ -462,6 +463,9 @@ xfs_sync_worker(
 		else
 			xfs_log_force(mp, 0);
 		error = xfs_qm_sync(mp, SYNC_TRYLOCK);
+
+		/* start pushing all the metadata that is currently dirty */
+		xfs_ail_push_all(mp->m_ail);
 	}
 
 	/* queue us up again */
@@ -1024,8 +1028,9 @@ xfs_reclaim_inode_shrink(
 
 	mp = container_of(shrink, struct xfs_mount, m_inode_shrink);
 	if (nr_to_scan) {
-		/* kick background reclaimer */
+		/* kick background reclaimer and push the AIL */
 		xfs_syncd_queue_reclaim(mp);
+		xfs_ail_push_all(mp->m_ail);
 
 		if (!(gfp_mask & __GFP_FS))
 			return -1;
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 25efa9b..2464316 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -761,7 +761,7 @@ xfs_log_need_covered(xfs_mount_t *mp)
 		break;
 	case XLOG_STATE_COVER_NEED:
 	case XLOG_STATE_COVER_NEED2:
-		if (!xfs_trans_ail_tail(log->l_ailp) &&
+		if (!xfs_ail_min_lsn(log->l_ailp) &&
 		    xlog_iclogs_empty(log)) {
 			if (log->l_covered_state == XLOG_STATE_COVER_NEED)
 				log->l_covered_state = XLOG_STATE_COVER_DONE;
@@ -801,7 +801,7 @@ xlog_assign_tail_lsn(
 	xfs_lsn_t		tail_lsn;
 	struct log		*log = mp->m_log;
 
-	tail_lsn = xfs_trans_ail_tail(mp->m_ail);
+	tail_lsn = xfs_ail_min_lsn(mp->m_ail);
 	if (!tail_lsn)
 		tail_lsn = atomic64_read(&log->l_last_sync_lsn);
 
@@ -1239,7 +1239,7 @@ xlog_grant_push_ail(
 	 * the filesystem is shutting down.
 	 */
 	if (!XLOG_FORCED_SHUTDOWN(log))
-		xfs_trans_ail_push(log->l_ailp, threshold_lsn);
+		xfs_ail_push(log->l_ailp, threshold_lsn);
 }
 
 /*
diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index cfbb6c6..ad6fd69 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -91,6 +91,20 @@ xfs_ail_min(
 }
 
 /*
+ * Return a pointer to the last item in the AIL.
+ * If the AIL is empty, then return NULL.
+ */
+static xfs_log_item_t *
+xfs_ail_max(
+	struct xfs_ail  *ailp)
+{
+	if (list_empty(&ailp->xa_ail))
+		return NULL;
+
+	return list_entry(ailp->xa_ail.prev, xfs_log_item_t, li_ail);
+}
+
+/*
  * Return a pointer to the item which follows
  * the given item in the AIL.  If the given item
  * is the last item in the list, then return NULL.
@@ -116,7 +130,7 @@ xfs_ail_next(
  * lsn of the last item in the AIL.
  */
 xfs_lsn_t
-xfs_trans_ail_tail(
+xfs_ail_min_lsn(
 	struct xfs_ail	*ailp)
 {
 	xfs_lsn_t	lsn = 0;
@@ -132,6 +146,25 @@ xfs_trans_ail_tail(
 }
 
 /*
+ * Return the maximum lsn held in the AIL, or zero if the AIL is empty.
+ */
+static xfs_lsn_t
+xfs_ail_max_lsn(
+	struct xfs_ail  *ailp)
+{
+	xfs_lsn_t       lsn = 0;
+	xfs_log_item_t  *lip;
+
+	spin_lock(&ailp->xa_lock);
+	lip = xfs_ail_max(ailp);
+	if (lip)
+		lsn = lip->li_lsn;
+	spin_unlock(&ailp->xa_lock);
+
+	return lsn;
+}
+
+/*
  * AIL traversal cursor initialisation.
  *
  * The cursor keeps track of where our current traversal is up
@@ -499,7 +532,7 @@ xfs_ail_worker(
 }
 
 /*
- * xfs_trans_ail_push
+ * xfs_ail_push
  *
  * This routine is called to move the tail of the AIL forward.  It does this by
  * trying to flush items in the AIL whose lsns are below the given
@@ -515,7 +548,7 @@ xfs_ail_worker(
  * any of the objects, so the lock is not needed.
  */
 void
-xfs_trans_ail_push(
+xfs_ail_push(
 	struct xfs_ail	*ailp,
 	xfs_lsn_t	threshold_lsn)
 {
@@ -537,6 +570,19 @@ xfs_trans_ail_push(
 }
 
 /*
+ * Push out all items in the AIL immediately
+ */
+void
+xfs_ail_push_all(
+	struct xfs_ail  *ailp)
+{
+	xfs_lsn_t       threshold_lsn = xfs_ail_max_lsn(ailp);
+
+	if (threshold_lsn)
+		xfs_ail_push(ailp, threshold_lsn);
+}
+
+/*
  * This is to be called when an item is unlocked that may have
  * been in the AIL.  It will wake up the first member of the AIL
  * wait list if this item's unlocking might allow it to progress.
diff --git a/fs/xfs/xfs_trans_priv.h b/fs/xfs/xfs_trans_priv.h
index 6ebd322..6b164e9 100644
--- a/fs/xfs/xfs_trans_priv.h
+++ b/fs/xfs/xfs_trans_priv.h
@@ -104,12 +104,13 @@ xfs_trans_ail_delete(
 	xfs_trans_ail_delete_bulk(ailp, &lip, 1);
 }
 
-void			xfs_trans_ail_push(struct xfs_ail *, xfs_lsn_t);
+void			xfs_ail_push(struct xfs_ail *, xfs_lsn_t);
+void			xfs_ail_push_all(struct xfs_ail *);
+xfs_lsn_t		xfs_ail_min_lsn(struct xfs_ail *ailp);
+
 void			xfs_trans_unlocked_item(struct xfs_ail *,
 					xfs_log_item_t *);
 
-xfs_lsn_t		xfs_trans_ail_tail(struct xfs_ail *ailp);
-
 struct xfs_log_item	*xfs_trans_ail_cursor_first(struct xfs_ail *ailp,
 					struct xfs_ail_cursor *cur,
 					xfs_lsn_t lsn);
-- 
1.7.2.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
