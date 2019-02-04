Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725980AbfBDQyh (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 4 Feb 2019 11:54:37 -0500
From: Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH v2 06/10] xfs: fix transient reference count error in xfs_buf_resubmit_failed_buffers
Date: Mon,  4 Feb 2019 08:54:23 -0800
Message-Id: <20190204165427.23607-7-mcgrof@kernel.org>
In-Reply-To: <20190204165427.23607-1-mcgrof@kernel.org>
References: <20190204165427.23607-1-mcgrof@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org, gregkh@linuxfoundation.org, Alexander.Levin@microsoft.com
Cc: stable@vger.kernel.org, amir73il@gmail.com, hch@infradead.org, Dave Chinner <dchinner@redhat.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, Luis Chamberlain <mcgrof@kernel.org>

From: Dave Chinner <dchinner@redhat.com>

commit d43aaf1685aa471f0593685c9f54d53e3af3cf3f upstream.

When retrying a failed inode or dquot buffer,
xfs_buf_resubmit_failed_buffers() clears all the failed flags from
the inde/dquot log items. In doing so, it also drops all the
reference counts on the buffer that the failed log items hold. This
means it can drop all the active references on the buffer and hence
free the buffer before it queues it for write again.

Putting the buffer on the delwri queue takes a reference to the
buffer (so that it hangs around until it has been written and
completed), but this goes bang if the buffer has already been freed.

Hence we need to add the buffer to the delwri queue before we remove
the failed flags from the log items attached to the buffer to ensure
it always remains referenced during the resubmit process.

Reported-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 fs/xfs/xfs_buf_item.c | 28 +++++++++++++++++++++-------
 1 file changed, 21 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 12d8455bfbb2..010db5f8fb00 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -1233,9 +1233,23 @@ xfs_buf_iodone(
 }
 
 /*
- * Requeue a failed buffer for writeback
+ * Requeue a failed buffer for writeback.
  *
- * Return true if the buffer has been re-queued properly, false otherwise
+ * We clear the log item failed state here as well, but we have to be careful
+ * about reference counts because the only active reference counts on the buffer
+ * may be the failed log items. Hence if we clear the log item failed state
+ * before queuing the buffer for IO we can release all active references to
+ * the buffer and free it, leading to use after free problems in
+ * xfs_buf_delwri_queue. It makes no difference to the buffer or log items which
+ * order we process them in - the buffer is locked, and we own the buffer list
+ * so nothing on them is going to change while we are performing this action.
+ *
+ * Hence we can safely queue the buffer for IO before we clear the failed log
+ * item state, therefore  always having an active reference to the buffer and
+ * avoiding the transient zero-reference state that leads to use-after-free.
+ *
+ * Return true if the buffer was added to the buffer list, false if it was
+ * already on the buffer list.
  */
 bool
 xfs_buf_resubmit_failed_buffers(
@@ -1243,16 +1257,16 @@ xfs_buf_resubmit_failed_buffers(
 	struct list_head	*buffer_list)
 {
 	struct xfs_log_item	*lip;
+	bool			ret;
+
+	ret = xfs_buf_delwri_queue(bp, buffer_list);
 
 	/*
-	 * Clear XFS_LI_FAILED flag from all items before resubmit
-	 *
-	 * XFS_LI_FAILED set/clear is protected by ail_lock, caller  this
+	 * XFS_LI_FAILED set/clear is protected by ail_lock, caller of this
 	 * function already have it acquired
 	 */
 	list_for_each_entry(lip, &bp->b_li_list, li_bio_list)
 		xfs_clear_li_failed(lip);
 
-	/* Add this buffer back to the delayed write list */
-	return xfs_buf_delwri_queue(bp, buffer_list);
+	return ret;
 }
-- 
2.18.0
