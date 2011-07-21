Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6LM5hvv046968 for <xfs@oss.sgi.com>; Thu, 21 Jul 2011 17:05:43 -0500
From: Alex Elder <aelder@sgi.com>
Message-Id: <201107212205.p6LM5dxF016460@stout.americas.sgi.com>
Date: Thu, 21 Jul 2011 17:05:39 -0500
Subject: [PATCH] xfs: set cursor in xfs_ail_splice() even when AIL was
 empty
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

In xfs_ail_splice(), if a cursor is provided it is updated
to point to the last item on the list to be spliced into
the AIL.  But if the AIL was found to be empty, the cursor
(if provided) is just initialized instead.

There is no reason the null AIL case needs to be any different.
And treating it the same way allows this code to be rearranged
a bit, with a somewhat tidier result.

Signed-off-by: Alex Elder <aelder@sgi.com>

---
 fs/xfs/xfs_trans_ail.c |   68 ++++++++++++++++++++-----------------------------
 1 file changed, 28 insertions(+), 40 deletions(-)

Index: b/fs/xfs/xfs_trans_ail.c
===================================================================
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -303,55 +303,42 @@ xfs_trans_ail_cursor_last(
  */
 static void
 xfs_ail_splice(
-	struct xfs_ail		*ailp,
-	struct xfs_ail_cursor	*cur,
-	struct list_head	*list,
-	xfs_lsn_t		lsn)
+	struct xfs_ail          *ailp,
+	struct xfs_ail_cursor   *cur,
+	struct list_head        *list,
+	xfs_lsn_t               lsn)
 {
-	struct xfs_log_item	*lip = cur ? cur->item : NULL;
-	struct xfs_log_item	*next_lip;
+	struct xfs_log_item     *lip;
 
 	/*
-	 * Get a new cursor if we don't have a placeholder or the existing one
-	 * has been invalidated.
+	 * Use the cursor to determine the insertion point if one is
+	 * provided.  If not, or if the one we got is not valid,
+	 * find the place in the AIL where the items belong.
 	 */
-	if (!lip || (__psint_t)lip & 1) {
+	lip = cur ? cur->item : NULL;
+	if (!lip || (__psint_t) lip & 1)
 		lip = __xfs_trans_ail_cursor_last(ailp, lsn);
 
-		if (!lip) {
-			/* The list is empty, so just splice and return.  */
-			if (cur)
-				cur->item = NULL;
-			list_splice(list, &ailp->xa_ail);
-			return;
-		}
-	}
+	/*
+	 * If a cursor is provided, we know we're processing the AIL
+	 * in lsn order, and future items to be spliced in will
+	 * follow the last one being inserted now.  Update the
+	 * cursor to point to that last item, now while we have a
+	 * reliable pointer to it.
+	 */
+	if (cur)
+		cur->item = list_entry(list->prev, struct xfs_log_item, li_ail);
 
 	/*
-	 * Our cursor points to the item we want to insert _after_, so we have
-	 * to update the cursor to point to the end of the list we are splicing
-	 * in so that it points to the correct location for the next splice.
-	 * i.e. before the splice
-	 *
-	 *  lsn -> lsn -> lsn + x -> lsn + x ...
-	 *          ^
-	 *          | cursor points here
-	 *
-	 * After the splice we have:
-	 *
-	 *  lsn -> lsn -> lsn -> lsn -> .... -> lsn -> lsn + x -> lsn + x ...
-	 *          ^                            ^
-	 *          | cursor points here         | needs to move here
-	 *
-	 * So we set the cursor to the last item in the list to be spliced
-	 * before we execute the splice, resulting in the cursor pointing to
-	 * the correct item after the splice occurs.
+	 * Finally perform the splice.  Unless the AIL was empty,
+	 * lip points to the item in the AIL _after_ which the new
+	 * items should go.  If lip is null the AIL was empty, so
+	 * the new items go at the head of the AIL.
 	 */
-	if (cur) {
-		next_lip = list_entry(list->prev, struct xfs_log_item, li_ail);
-		cur->item = next_lip;
-	}
-	list_splice(list, &lip->li_ail);
+	if (lip)
+		list_splice(list, &lip->li_ail);
+	else
+		list_splice(list, &ailp->xa_ail);
 }
 
 /*
@@ -682,6 +669,7 @@ xfs_trans_ail_update_bulk(
 	int			i;
 	LIST_HEAD(tmp);
 
+	ASSERT(nr_items > 0);		/* Not required, but true. */
 	mlip = xfs_ail_min(ailp);
 
 	for (i = 0; i < nr_items; i++) {

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
