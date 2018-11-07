Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail01.adl2.internode.on.net ([150.101.137.133]:26347 "EHLO
        ipmail01.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727196AbeKHJKe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Nov 2018 04:10:34 -0500
Date: Thu, 8 Nov 2018 10:37:40 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] xfs: take a ref on failed bufs in xfs_inode_item_push
Message-ID: <20181107233740.GZ19305@dastard>
References: <20181107201055.25883-1-josef@toxicpanda.com>
 <20181107201055.25883-3-josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181107201055.25883-3-josef@toxicpanda.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Josef Bacik <josef@toxicpanda.com>
Cc: kernel-team@fb.com, linux-xfs@vger.kernel.org

On Wed, Nov 07, 2018 at 03:10:55PM -0500, Josef Bacik wrote:
> If we failed to writeout a xfs_buf we'll grab a ref for it and put it on
> li->li_buf.  Then when submitting the failed bufs we'll clear LI_FAILED
> on the li, which clears the LI_FAILED flag, but also drops the ref on
> the buf.  Since it isn't on a IO list at this point this could very well
> be the last ref on the buf, which wreaks havoc when we go to add the buf
> to the delwrite list.  Fix this by holding a ref on the buf before we
> call xfs_buf_resubmit_failed_buffers in order to make sure the buf
> doesn't disappear before we're able to clear the error and add it to the
> delwri list.  This fixes the panics I was seeing with error injection.
> 
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> ---
>  fs/xfs/xfs_inode_item.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index fa1c4fe2ffbf..df49adf1989c 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -503,13 +503,16 @@ xfs_inode_item_push(
>  	 * previously. Resubmit the buffer for IO.
>  	 */
>  	if (test_bit(XFS_LI_FAILED, &lip->li_flags)) {
> -		if (!xfs_buf_trylock(bp))
> +		xfs_buf_hold(bp);
> +		if (!xfs_buf_trylock(bp)) {
> +			xfs_buf_rele(bp);
>  			return XFS_ITEM_LOCKED;
> +		}
>  
>  		if (!xfs_buf_resubmit_failed_buffers(bp, buffer_list))
>  			rval = XFS_ITEM_FLUSHING;
>  
> -		xfs_buf_unlock(bp);
> +		xfs_buf_relse(bp);
>  		return rval;
>  	}

This just doesn't smell right to me.

/me rummages around in the code

Ok, so I think the bug is in xfs_buf_resubmit_failed_buffers() in
that it removes all the "failed" reference counts from the buffer
before it adds the delwri reference count back to the buffer. Taking
a high level reference count like above just papers over the
transient reference counting error in
xfs_buf_resubmit_failed_buffers().

It also fails to fix the other xfs_buf_resubmit_failed_buffers()
caller, which has exactly the same problem (dquot writeback).

Perhaps something like the patch below?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com


xfs: fix transient reference count error in xfs_buf_resubmit_failed_buffers

From: Dave Chinner <dchinner@redhat.com>

When retrying a failed inode or dquot buffer,
xfs_buf_resubmit_failed_buffers() clears all the failed flags from
the inode/dquot log items. In doing so, it also drops all the
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
