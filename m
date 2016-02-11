Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 22C5D7CA2
	for <xfs@oss.sgi.com>; Thu, 11 Feb 2016 00:45:54 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 10FCF8F8050
	for <xfs@oss.sgi.com>; Wed, 10 Feb 2016 22:45:53 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	qXUHuoUPkGygAOHW for <xfs@oss.sgi.com>;
	Wed, 10 Feb 2016 22:45:51 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1aTl0e-0007o8-S2
	for xfs@oss.sgi.com; Thu, 11 Feb 2016 17:45:48 +1100
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1aTl0e-00057O-RH
	for xfs@oss.sgi.com; Thu, 11 Feb 2016 17:45:48 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/6] xfs: remove xfs_cancel_ioend
Date: Thu, 11 Feb 2016 17:45:42 +1100
Message-Id: <1455173146-19535-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1455173146-19535-1-git-send-email-david@fromorbit.com>
References: <1455173146-19535-1-git-send-email-david@fromorbit.com>
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

We currently have code to cancel ioends being built because we
change bufferhead state as we build the ioend. On error, this needs
to be unwound and so we have cancelling code that walks the buffers
on the ioend chain and undoes these state changes.

However, the IO submission path already handles state changes for
buffers when a submission error occurs, so we don't really need a
separate cancel function to do this - we can simply submit the
ioend chain with the specific error and it will be cancelled rather
than submitted.

Hence we can remove the explicit cancel code and just rely on
submission to deal with the error correctly.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_aops.c | 93 +++++++++++++++++++++++++++----------------------------
 1 file changed, 46 insertions(+), 47 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 00452cb..4941efd 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -528,38 +528,6 @@ xfs_submit_ioend(
 }
 
 /*
- * Cancel submission of all buffer_heads so far in this endio.
- * Toss the endio too.  Only ever called for the initial page
- * in a writepage request, so only ever one page.
- */
-STATIC void
-xfs_cancel_ioend(
-	xfs_ioend_t		*ioend)
-{
-	xfs_ioend_t		*next;
-	struct buffer_head	*bh, *next_bh;
-
-	do {
-		next = ioend->io_list;
-		bh = ioend->io_buffer_head;
-		do {
-			next_bh = bh->b_private;
-			clear_buffer_async_write(bh);
-			/*
-			 * The unwritten flag is cleared when added to the
-			 * ioend. We're not submitting for I/O so mark the
-			 * buffer unwritten again for next time around.
-			 */
-			if (ioend->io_type == XFS_IO_UNWRITTEN)
-				set_buffer_unwritten(bh);
-			unlock_buffer(bh);
-		} while ((bh = next_bh) != NULL);
-
-		mempool_free(ioend, xfs_ioend_pool);
-	} while ((ioend = next) != NULL);
-}
-
-/*
  * Test to see if we've been building up a completion structure for
  * earlier buffers -- if so, we try to append to this ioend if we
  * can, otherwise we finish off any current ioend and start another.
@@ -931,6 +899,28 @@ out_invalidate:
 	return;
 }
 
+static int
+xfs_writepage_submit(
+	struct xfs_ioend	*ioend,
+	struct xfs_ioend	*iohead,
+	struct writeback_control *wbc,
+	int			status)
+{
+	struct blk_plug		plug;
+
+	/* Reserve log space if we might write beyond the on-disk inode size. */
+	if (!status && ioend && ioend->io_type != XFS_IO_UNWRITTEN &&
+	    xfs_ioend_is_append(ioend))
+		status = xfs_setfilesize_trans_alloc(ioend);
+
+	if (iohead) {
+		blk_start_plug(&plug);
+		xfs_submit_ioend(wbc, iohead, status);
+		blk_finish_plug(&plug);
+	}
+	return status;
+}
+
 /*
  * Write out a dirty page.
  *
@@ -1142,6 +1132,7 @@ xfs_vm_writepage(
 		return 0;
 
 	ASSERT(iohead);
+	ASSERT(err == 0);
 
 	/*
 	 * Any errors from this point onwards need tobe reported through the IO
@@ -1167,25 +1158,33 @@ xfs_vm_writepage(
 				  wbc, end_index);
 	}
 
+	return xfs_writepage_submit(ioend, iohead, wbc, 0);
 
+error:
 	/*
-	 * Reserve log space if we might write beyond the on-disk inode size.
+	 * On error, we have to fail the iohead here because we buffers locked
+	 * in the ioend chain. If we don't do this, we'll deadlock invalidating
+	 * the page as that tries to lock the buffers on the page. Also, because
+	 * we may have set pages under writeback, we have to run IO completion to
+	 * mark the error state of the IO appropriately, so we can't cancel the
+	 * ioend directly here. That means we have to mark this page as under
+	 * writeback if we included any buffers from it in the ioend chain.
 	 */
-	err = 0;
-	if (ioend->io_type != XFS_IO_UNWRITTEN && xfs_ioend_is_append(ioend))
-		err = xfs_setfilesize_trans_alloc(ioend);
+	if (count)
+		xfs_start_page_writeback(page, 0, count);
+	xfs_writepage_submit(ioend, iohead, wbc, err);
 
-	xfs_submit_ioend(wbc, iohead, err);
-
-	return 0;
-
-error:
-	if (iohead)
-		xfs_cancel_ioend(iohead);
-
-	xfs_aops_discard_page(page);
-	ClearPageUptodate(page);
-	unlock_page(page);
+	/*
+	 * We can only discard the page we had the IO error on if we haven't
+	 * included it in the ioend above. If it has already been errored out,
+	 * the it is unlocked and we can't touch it here.
+	 */
+	if (!count) {
+		xfs_aops_discard_page(page);
+		ClearPageUptodate(page);
+		unlock_page(page);
+	}
+	mapping_set_error(page->mapping, err);
 	return err;
 
 redirty:
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
