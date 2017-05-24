Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52852 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750838AbdEXRIZ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 24 May 2017 13:08:25 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 65BF072496
        for <linux-xfs@vger.kernel.org>; Wed, 24 May 2017 17:08:24 +0000 (UTC)
Date: Wed, 24 May 2017 13:08:21 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 3/3 V2] xfs: Properly retry failed inode items in case of
 error during buffer writeback
Message-ID: <20170524170820.GC13925@bfoster.bfoster>
References: <20170522153220.25072-1-cmaiolino@redhat.com>
 <20170522153220.25072-4-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170522153220.25072-4-cmaiolino@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Mon, May 22, 2017 at 05:32:20PM +0200, Carlos Maiolino wrote:
> When a buffer has been failed during writeback, the inode items into it
> are kept flush locked, and are never resubmitted due the flush lock, so,
> if any buffer fails to be written, the items in AIL are never written to
> disk and never unlocked.
> 
> This causes unmount operation to hang due these items flush locked in AIL,
> but this also causes the items in AIL to never be written back, even when
> the IO device comes back to normal.
> 
> I've been testing this patch with a DM-thin device, creating a
> filesystem larger than the real device.
> 
> When writing enough data to fill the DM-thin device, XFS receives ENOSPC
> errors from the device, and keep spinning on xfsaild (when 'retry
> forever' configuration is set).
> 
> At this point, the filesystem can not be unmounted because of the flush locked
> items in AIL, but worse, the items in AIL are never retried at all
> (once xfs_inode_item_push() will skip the items that are flush locked),
> even if the underlying DM-thin device is expanded to the proper size.
> 
> This patch fixes both cases, retrying any item that has been failed
> previously, using the infra-structure provided by the previous patch.
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
> V2:
> 	- Fix XFS_LI_FAILED flag removal
> 	- Use atomic operations to set and clear XFS_LI_FAILED flag
> 	- Remove check for XBF_WRITE_FAIL in xfs_inode_item_push
> 	- Add more comments to the code
> 	- Add a helper function to resubmit the failed buffers, so this
> 	  can be also used in dquot system without duplicating code
> 
>  fs/xfs/xfs_buf_item.c   | 42 ++++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_buf_item.h   |  2 ++
>  fs/xfs/xfs_inode_item.c | 36 +++++++++++++++++++++++++++++++++++-
>  3 files changed, 79 insertions(+), 1 deletion(-)
> 
...
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index eeeadbb..97db299 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -27,6 +27,7 @@
>  #include "xfs_error.h"
>  #include "xfs_trace.h"
>  #include "xfs_trans_priv.h"
> +#include "xfs_buf_item.h"
>  #include "xfs_log.h"
>  
>  
> @@ -475,6 +476,24 @@ xfs_inode_item_unpin(
>  		wake_up_bit(&ip->i_flags, __XFS_IPINNED_BIT);
>  }
>  
> +STATIC void
> +xfs_inode_item_error(
> +	struct xfs_log_item	*lip,
> +	unsigned int		bflags)
> +{
> +
> +	/*
> +	 * The buffer writeback containing this inode has been failed
> +	 * mark it as failed and unlock the flush lock, so it can be retried
> +	 * again.
> +	 * It requires an atomic operation, once the parent object is not locked
> +	 * in this context, and we need to avoid races with other log item state
> +	 * changes.
> +	 */
> +	if (bflags & XBF_WRITE_FAIL)
> +		set_bit(XFS_LI_FAILED, &lip->li_flags);
> +}

With the change to patch 2 to set LI_FAILED on all log items, this can
go away completely. We know that LI_FAILED will be set on any log item
attached to a buffer that fails.

> +
>  STATIC uint
>  xfs_inode_item_push(
>  	struct xfs_log_item	*lip,
> @@ -517,8 +536,22 @@ xfs_inode_item_push(
>  	 * the AIL.
>  	 */
>  	if (!xfs_iflock_nowait(ip)) {
> +
> +		/*
> +		 * The buffer containing this item failed to be written back
> +		 * previously. Resubmit the buffer for IO.
> +		 */
> +		if (lip->li_flags & XFS_LI_FAILED) {
> +			if (!xfs_buf_resubmit_failed_buffers(ip, lip, bp,
> +							     buffer_list))
> +				rval = XFS_ITEM_FLUSHING;
> +
> +			goto out_unlock;
> +		}
> +

I think we need to do the XFS_LI_FAILED check first thing in
xfs_inode_item_push(). As part of the v1 discussion, Dave pointed out
that there is the possibility that somebody else is holding the inode
lock and blocking on the flush lock by the time xfs_inode_item_push() is
called. That means we would never get past the xfs_ilock_nowait() call
earlier in the function and thus never resubmit the buffer.

That aside, we're now modifying inode log item behavior based on
LI_FAILED. Since we now skip an iflush when LI_FAILED is set, we need to
handle the case in xfs_iflush_done() where the flush lock is unlocked
but the log item is not removed from the AIL. I think this should be
quite rare, but IIUC the scenario goes something like this:

	- Inode 1 transaction is committed, AIL push flushes the inode,
	  buffer I/O fails and the log item is set LI_FAILED. The inode
	  log item is now sitting in the AIL waiting for a retry.
	- Inode 1 is relogged and committed in another transaction. Its
	  place in the AIL is moved. The changes to the xfs_inode in
	  this tx have not been flushed to the buffer.
	- Inode 2 transaction is committed and inserted to AIL. Inode 2
	  is backed by the same buffer as inode 1.
	- AIL pushes inode 2, flushes to the buffer and submits. It does
	  not clear LI_FAILED of inode 1 because inode 2 has never
	  failed.
	- Buffer I/O succeeds, xfs_iflush_done() runs and removes inode
	  2 from the AIL and flush unlocks. Inode 1 is flush unlocked
	  but remains on the AIL because the flush from the second
	  transaction above has not yet occurred.
	- xfs_iflush_done() clears LI_FAILED so the subsequent AIL push
	  of inode 1 actually flushes the latest in-core inode to the
	  buffer.

So IOW, I think we need to include something like the hunk appended
below (untested) to this patch.

Dave,

Do you see anything wrong with this overall approach? I think this
avoids the hard dependency on atomic flags because all li_flags updates
remain under ->xa_lock. We've covered the I/O submission context concern
because we incorporate the previously discussed idea of clearing the
flag on successful I/O completion. Finally, normal running performance
should not be affected because the ->xa_lock is not taken anywhere new
unless I/O errors have occurred. Thoughts?

Brian

--- 8< ---

diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 29ada12..5e1ecb1 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -722,7 +722,8 @@ xfs_iflush_done(
 		 * the AIL lock.
 		 */
 		iip = INODE_ITEM(blip);
-		if (iip->ili_logged && blip->li_lsn == iip->ili_flush_lsn)
+		if ((iip->ili_logged && blip->li_lsn == iip->ili_flush_lsn) ||
+		    blip->li_flags & XFS_LI_FAILED)
 			need_ail++;
 
 		blip = next;
@@ -730,7 +731,8 @@ xfs_iflush_done(
 
 	/* make sure we capture the state of the initial inode. */
 	iip = INODE_ITEM(lip);
-	if (iip->ili_logged && lip->li_lsn == iip->ili_flush_lsn)
+	if ((iip->ili_logged && lip->li_lsn == iip->ili_flush_lsn) ||
+	    lip->li_flags & XFS_LI_FAILED)
 		need_ail++;
 
 	/*
@@ -751,6 +753,8 @@ xfs_iflush_done(
 			if (INODE_ITEM(blip)->ili_logged &&
 			    blip->li_lsn == INODE_ITEM(blip)->ili_flush_lsn)
 				mlip_changed |= xfs_ail_delete_one(ailp, blip);
+			else if (blip->li_flags & XFS_LI_FAILED)
+				blip->li_flags &= ~XFS_LI_FAILED;
 		}
 
 		if (mlip_changed) {
