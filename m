Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6MG4kkL093005 for <xfs@oss.sgi.com>; Fri, 22 Jul 2011 11:04:46 -0500
From: Alex Elder <aelder@sgi.com>
Message-Id: <201107221604.p6MG4ghs011316@stout.americas.sgi.com>
Date: Fri, 22 Jul 2011 11:04:41 -0500
Subject: [PATCH,
	v2] xfs: set cursor in xfs_ail_splice() even when AIL was empty
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

In xfs_ail_splice(), if a cursor is provided it is updated to
point to the last item on the list being spliced into the AIL.
But if the AIL was found to be empty, the cursor (if provided)
is just initialized instead.

There is no reason the empty AIL case needs to be treated any
differently.  And treating it the same way allows this code
to be rearranged a bit, with a somewhat tidier result.

Signed-off-by: Alex Elder <aelder@sgi.com>

Updated to avoid passing an empty list to xfs_ail_splice().

---
 fs/xfs/xfs_trans_ail.c |   67 +++++++++++++++++++++----------------------------
 1 file changed, 29 insertions(+), 38 deletions(-)

Index: b/fs/xfs/xfs_trans_ail.c
===================================================================
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -299,7 +299,7 @@ xfs_trans_ail_cursor_last(
  * Splice the log item list into the AIL at the given LSN. We splice to the
  * tail of the given LSN to maintain insert order for push traversals. The
  * cursor is optional, allowing repeated updates to the same LSN to avoid
- * repeated traversals.
+ * repeated traversals.  This should not be called with an empty list.
  */
 static void
 xfs_ail_splice(
@@ -308,50 +308,39 @@ xfs_ail_splice(
 	struct list_head	*list,
 	xfs_lsn_t		lsn)
 {
-	struct xfs_log_item	*lip = cur ? cur->item : NULL;
-	struct xfs_log_item	*next_lip;
+	struct xfs_log_item	*lip;
+
+	ASSERT(!list_empty(list));
 
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
@@ -682,6 +671,7 @@ xfs_trans_ail_update_bulk(
 	int			i;
 	LIST_HEAD(tmp);
 
+	ASSERT(nr_items > 0);		/* Not required, but true. */
 	mlip = xfs_ail_min(ailp);
 
 	for (i = 0; i < nr_items; i++) {
@@ -701,7 +691,8 @@ xfs_trans_ail_update_bulk(
 		list_add(&lip->li_ail, &tmp);
 	}
 
-	xfs_ail_splice(ailp, cur, &tmp, lsn);
+	if (!list_empty(&tmp))
+		xfs_ail_splice(ailp, cur, &tmp, lsn);
 
 	if (!mlip_changed) {
 		spin_unlock(&ailp->xa_lock);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
