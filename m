Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBD4WVbS158321 for <xfs@oss.sgi.com>; Sun, 12 Dec 2010 22:32:31 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E8BE71CBC735
	for <xfs@oss.sgi.com>; Sun, 12 Dec 2010 20:34:21 -0800 (PST)
Received: from mail.internode.on.net (bld-mail14.adl6.internode.on.net
	[150.101.137.99]) by cuda.sgi.com with ESMTP id
	MBlYizSQdomEaMGs for <xfs@oss.sgi.com>;
	Sun, 12 Dec 2010 20:34:21 -0800 (PST)
Received: from dastard (unverified [121.44.88.148])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	50128060-1927428
	for <xfs@oss.sgi.com>; Mon, 13 Dec 2010 15:04:20 +1030 (CDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1PS06z-00021P-Ow
	for xfs@oss.sgi.com; Mon, 13 Dec 2010 15:34:09 +1100
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1PS05L-0004ia-Mk
	for xfs@oss.sgi.com; Mon, 13 Dec 2010 15:32:27 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 6/9] xfs: consume iodone callback items on buffers as they are
	processed
Date: Mon, 13 Dec 2010 15:32:20 +1100
Message-Id: <1292214743-18073-7-git-send-email-david@fromorbit.com>
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

To allow buffer iodone callbacks to consume multiple items off the
callback list, first we need to convert the xfs_buf_do_callbacks()
to consume items and always pull the next item from the head of the
list.

The means the item list walk is never dependent on knowing the
next item on the list and hence allows callbacks to remove items
from the list as well. This allows callbacks to do bulk operations
by scanning the list for identical callbacks, consuming them all
and then processing them in bulk, negating the need for multiple
callbacks of that type.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf_item.c |   32 +++++++++++++++++++++-----------
 1 files changed, 21 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 2686d0d..ed2b65f 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -142,7 +142,7 @@ xfs_buf_item_log_check(
 #endif
 
 STATIC void	xfs_buf_error_relse(xfs_buf_t *bp);
-STATIC void	xfs_buf_do_callbacks(xfs_buf_t *bp, xfs_log_item_t *lip);
+STATIC void	xfs_buf_do_callbacks(struct xfs_buf *bp);
 
 /*
  * This returns the number of log iovecs needed to log the
@@ -450,7 +450,7 @@ xfs_buf_item_unpin(
 		 * xfs_trans_ail_delete() drops the AIL lock.
 		 */
 		if (bip->bli_flags & XFS_BLI_STALE_INODE) {
-			xfs_buf_do_callbacks(bp, (xfs_log_item_t *)bip);
+			xfs_buf_do_callbacks(bp);
 			XFS_BUF_SET_FSPRIVATE(bp, NULL);
 			XFS_BUF_CLR_IODONE_FUNC(bp);
 		} else {
@@ -918,15 +918,26 @@ xfs_buf_attach_iodone(
 	XFS_BUF_SET_IODONE_FUNC(bp, xfs_buf_iodone_callbacks);
 }
 
+/*
+ * We can have many callbacks on a buffer. Running the callbacks individually
+ * can cause a lot of contention on the AIL lock, so we allow for a single
+ * callback to be able to scan the remaining lip->li_bio_list for other items
+ * of the same type and callback to be processed in the first call.
+ *
+ * As a result, the loop walking the callback list below will also modify the
+ * list. it removes the first item from the list and then runs the callback.
+ * The loop then restarts from the new head of the list. This allows the
+ * callback to scan and modify the list attached to the buffer and we don't
+ * have to care about maintaining a next item pointer.
+ */
 STATIC void
 xfs_buf_do_callbacks(
-	xfs_buf_t	*bp,
-	xfs_log_item_t	*lip)
+	struct xfs_buf		*bp)
 {
-	xfs_log_item_t	*nlip;
+	struct xfs_log_item	*lip;
 
-	while (lip != NULL) {
-		nlip = lip->li_bio_list;
+	while ((lip = XFS_BUF_FSPRIVATE(bp, xfs_log_item_t *)) != NULL) {
+		XFS_BUF_SET_FSPRIVATE(bp, lip->li_bio_list);
 		ASSERT(lip->li_cb != NULL);
 		/*
 		 * Clear the next pointer so we don't have any
@@ -936,7 +947,6 @@ xfs_buf_do_callbacks(
 		 */
 		lip->li_bio_list = NULL;
 		lip->li_cb(bp, lip);
-		lip = nlip;
 	}
 }
 
@@ -970,7 +980,7 @@ xfs_buf_iodone_callbacks(
 			ASSERT(XFS_BUF_TARGET(bp) == mp->m_ddev_targp);
 			XFS_BUF_SUPER_STALE(bp);
 			trace_xfs_buf_item_iodone(bp, _RET_IP_);
-			xfs_buf_do_callbacks(bp, lip);
+			xfs_buf_do_callbacks(bp);
 			XFS_BUF_SET_FSPRIVATE(bp, NULL);
 			XFS_BUF_CLR_IODONE_FUNC(bp);
 			xfs_buf_ioend(bp, 0);
@@ -1029,7 +1039,7 @@ xfs_buf_iodone_callbacks(
 		return;
 	}
 
-	xfs_buf_do_callbacks(bp, lip);
+	xfs_buf_do_callbacks(bp);
 	XFS_BUF_SET_FSPRIVATE(bp, NULL);
 	XFS_BUF_CLR_IODONE_FUNC(bp);
 	xfs_buf_ioend(bp, 0);
@@ -1063,7 +1073,7 @@ xfs_buf_error_relse(
 	 * We have to unpin the pinned buffers so do the
 	 * callbacks.
 	 */
-	xfs_buf_do_callbacks(bp, lip);
+	xfs_buf_do_callbacks(bp);
 	XFS_BUF_SET_FSPRIVATE(bp, NULL);
 	XFS_BUF_CLR_IODONE_FUNC(bp);
 	XFS_BUF_SET_BRELSE_FUNC(bp,NULL);
-- 
1.7.2.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
