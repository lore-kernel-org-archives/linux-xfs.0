Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6I3edG9078016 for <xfs@oss.sgi.com>; Sun, 17 Jul 2011 22:40:39 -0500
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 94A091D88095
	for <xfs@oss.sgi.com>; Sun, 17 Jul 2011 20:40:37 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	XkP5hDbymAMCJNYD for <xfs@oss.sgi.com>;
	Sun, 17 Jul 2011 20:40:37 -0700 (PDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1Qieh7-0008Bd-72
	for xfs@oss.sgi.com; Mon, 18 Jul 2011 13:40:33 +1000
Received: from dave by disappointment with local (Exim 4.76)
	(envelope-from <dave@disappointment.disaster>) id 1Qiegw-0002a9-SR
	for xfs@oss.sgi.com; Mon, 18 Jul 2011 13:40:22 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/4] xfs: remove confusing ail cursor wrapper
Date: Mon, 18 Jul 2011 13:40:17 +1000
Message-Id: <1310960419-9875-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1310960419-9875-1-git-send-email-david@fromorbit.com>
References: <1310960419-9875-1-git-send-email-david@fromorbit.com>
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

xfs_trans_ail_cursor_set() doesn't set the cursor to the current log
item, it sets it to the next item. There is already a function for
doing this - xfs_trans_ail_cursor_next() - and the _set function is
simply a two line wrapper.  Remove it and open code the setting of
the cursor in the two locations that call it to remove the
confusion.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_trans_ail.c |   50 ++++++++++++++++++-----------------------------
 1 files changed, 19 insertions(+), 31 deletions(-)

diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index 9a69dc0..7908c79 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -189,20 +189,6 @@ xfs_trans_ail_cursor_init(
 }
 
 /*
- * Set the cursor to the next item, because when we look
- * up the cursor the current item may have been freed.
- */
-STATIC void
-xfs_trans_ail_cursor_set(
-	struct xfs_ail		*ailp,
-	struct xfs_ail_cursor	*cur,
-	struct xfs_log_item	*lip)
-{
-	if (lip)
-		cur->item = xfs_ail_next(ailp, lip);
-}
-
-/*
  * Get the next item in the traversal and advance the cursor.
  * If the cursor was invalidated (inidicated by a lip of 1),
  * restart the traversal.
@@ -216,7 +202,8 @@ xfs_trans_ail_cursor_next(
 
 	if ((__psint_t)lip & 1)
 		lip = xfs_ail_min(ailp);
-	xfs_trans_ail_cursor_set(ailp, cur, lip);
+	if (lip)
+		cur->item = xfs_ail_next(ailp, lip);
 	return lip;
 }
 
@@ -272,9 +259,10 @@ xfs_trans_ail_cursor_clear(
 }
 
 /*
- * Initialise the cursor to the first item in the AIL with the given @lsn.
- * This searches the list from lowest LSN to highest. Pass a @lsn of zero
- * to initialise the cursor to the first item in the AIL.
+ * Find the first item in the AIL with the given @lsn by searching in ascending
+ * LSN order and initialise the cursor to point to the next item for a
+ * ascending traversal.  Pass a @lsn of zero to initialise the cursor to the
+ * first item in the AIL. Returns NULL if the list is empty.
  */
 xfs_log_item_t *
 xfs_trans_ail_cursor_first(
@@ -285,26 +273,24 @@ xfs_trans_ail_cursor_first(
 	xfs_log_item_t		*lip;
 
 	xfs_trans_ail_cursor_init(ailp, cur);
-	lip = xfs_ail_min(ailp);
-	if (lsn == 0)
+
+	if (lsn == 0) {
+		lip = xfs_ail_min(ailp);
 		goto out;
+	}
 
 	list_for_each_entry(lip, &ailp->xa_ail, li_ail) {
 		if (XFS_LSN_CMP(lip->li_lsn, lsn) >= 0)
 			goto out;
 	}
-	lip = NULL;
+	return NULL;
+
 out:
-	xfs_trans_ail_cursor_set(ailp, cur, lip);
+	if (lip)
+		cur->item = xfs_ail_next(ailp, lip);
 	return lip;
 }
 
-/*
- * Initialise the cursor to the last item in the AIL with the given @lsn.
- * This searches the list from highest LSN to lowest. If there is no item with
- * the value of @lsn, then it sets the cursor to the last item with an LSN lower
- * than @lsn.
- */
 static struct xfs_log_item *
 __xfs_trans_ail_cursor_last(
 	struct xfs_ail		*ailp,
@@ -320,8 +306,10 @@ __xfs_trans_ail_cursor_last(
 }
 
 /*
- * Initialise the cursor to the last item in the AIL with the given @lsn.
- * This searches the list from highest LSN to lowest.
+ * Find the last item in the AIL with the given @lsn by searching in descending
+ * LSN order and initialise the cursor to point to that item.  If there is no
+ * item with the value of @lsn, then it sets the cursor to the last item with an
+ * LSN lower than @lsn.  Returns NULL if the list is empty.
  */
 struct xfs_log_item *
 xfs_trans_ail_cursor_last(
@@ -335,7 +323,7 @@ xfs_trans_ail_cursor_last(
 }
 
 /*
- * splice the log item list into the AIL at the given LSN. We splice to the
+ * Splice the log item list into the AIL at the given LSN. We splice to the
  * tail of the given LSN to maintain insert order for push traversals. The
  * cursor is optional, allowing repeated updates to the same LSN to avoid
  * repeated traversals.
-- 
1.7.5.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
