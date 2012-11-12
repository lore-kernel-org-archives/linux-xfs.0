Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qACB8FNS214651 for <xfs@oss.sgi.com>; Mon, 12 Nov 2012 05:08:15 -0600
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	ZNDzYtEvoorHvvIx for <xfs@oss.sgi.com>;
	Mon, 12 Nov 2012 03:10:10 -0800 (PST)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1TXrtu-0004ym-Ts
	for xfs@oss.sgi.com; Mon, 12 Nov 2012 22:09:58 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1TXrtk-0000wK-Pq
	for xfs@oss.sgi.com; Mon, 12 Nov 2012 22:09:48 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/3] xfs: fix broken error handling in xfs_vm_writepage
Date: Mon, 12 Nov 2012 22:09:45 +1100
Message-Id: <1352718586-3538-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1352718586-3538-1-git-send-email-david@fromorbit.com>
References: <1352718586-3538-1-git-send-email-david@fromorbit.com>
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

When we shut down the filesystem, it might first be detected in
writeback when we are allocating a inode size transaction. This
happens after we have moved all the pages into the writeback state
and unlocked them. Unfortunately, if we fail to set up the
transaction we then abort writeback and try to invalidate the
current page. This then triggers are BUG() in block_invalidatepage()
because we are trying to invalidate an unlocked page.

Fixing this is a bit of a chicken and egg problem - we can't
allocate the transaction until we've clustered all the pages into
the IO and we know the size of it (i.e. whether the last block of
the IO is beyond the current EOF or not). However, we don't want to
hold pages locked for long periods of time, especially while we lock
other pages to cluster them into the write.

To fix this, we need to make a clear delineation in writeback where
errors can only be handled by IO completion processing. That is,
once we have marked a page for writeback and unlocked it, we have to
report errors via IO completion because we've already started the
IO. We may not have submitted any IO, but we've changed the page
state to indicate that it is under IO so we must now use the IO
completion path to report errors.

To do this, add an error field to xfs_submit_ioend() to pass it the
error that occurred during the building on the ioend chain. When
this is non-zero, mark each ioend with the error and call
xfs_finish_ioend() directly rather than building bios. This will
immediately push the ioends through completion processing with the
error that has occurred.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_aops.c |   54 ++++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 39 insertions(+), 15 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index e562dd4..e57e2da 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -481,11 +481,17 @@ static inline int bio_add_buffer(struct bio *bio, struct buffer_head *bh)
  *
  * The fix is two passes across the ioend list - one to start writeback on the
  * buffer_heads, and then submit them for I/O on the second pass.
+ *
+ * If @fail is non-zero, it means that we have a situation where some part of
+ * the submission process has failed after we have marked paged for writeback
+ * and unlocked them. In this situation, we need to fail the ioend chain rather
+ * than submit it to IO. This typically only happens on a filesystem shutdown.
  */
 STATIC void
 xfs_submit_ioend(
 	struct writeback_control *wbc,
-	xfs_ioend_t		*ioend)
+	xfs_ioend_t		*ioend,
+	int			fail)
 {
 	xfs_ioend_t		*head = ioend;
 	xfs_ioend_t		*next;
@@ -506,6 +512,18 @@ xfs_submit_ioend(
 		next = ioend->io_list;
 		bio = NULL;
 
+		/*
+		 * If we are failing the IO now, just mark the ioend with an
+		 * error and finish it. This will run IO completion immediately
+		 * as there is only one reference to the ioend at this point in
+		 * time.
+		 */
+		if (fail) {
+			ioend->io_error = -fail;
+			xfs_finish_ioend(ioend);
+			continue;
+		}
+
 		for (bh = ioend->io_buffer_head; bh; bh = bh->b_private) {
 
 			if (!bio) {
@@ -1060,7 +1078,18 @@ xfs_vm_writepage(
 
 	xfs_start_page_writeback(page, 1, count);
 
-	if (ioend && imap_valid) {
+	/* if there is no IO to be submitted for this page, we are done */
+	if (!ioend)
+		return 0;
+
+	ASSERT(iohead);
+
+	/*
+	 * Any errors from this point onwards need tobe reported through the IO
+	 * completion path as we have marked the initial page as under writeback
+	 * and unlocked it.
+	 */
+	if (imap_valid) {
 		xfs_off_t		end_index;
 
 		end_index = imap.br_startoff + imap.br_blockcount;
@@ -1079,20 +1108,15 @@ xfs_vm_writepage(
 				  wbc, end_index);
 	}
 
-	if (iohead) {
-		/*
-		 * Reserve log space if we might write beyond the on-disk
-		 * inode size.
-		 */
-		if (ioend->io_type != XFS_IO_UNWRITTEN &&
-		    xfs_ioend_is_append(ioend)) {
-			err = xfs_setfilesize_trans_alloc(ioend);
-			if (err)
-				goto error;
-		}
 
-		xfs_submit_ioend(wbc, iohead);
-	}
+	/*
+	 * Reserve log space if we might write beyond the on-disk inode size.
+	 */
+	err = 0;
+	if (ioend->io_type != XFS_IO_UNWRITTEN && xfs_ioend_is_append(ioend))
+		err = xfs_setfilesize_trans_alloc(ioend);
+
+	xfs_submit_ioend(wbc, iohead, err);
 
 	return 0;
 
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
