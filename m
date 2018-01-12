Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41802 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933975AbeALPCZ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 12 Jan 2018 10:02:25 -0500
Date: Fri, 12 Jan 2018 10:02:24 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [RFC PATCH] xfs: Fix "use after free" of intent items
Message-ID: <20180112150223.GB32050@bfoster.bfoster>
References: <20180111125223.10727-1-chandan@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180111125223.10727-1-chandan@linux.vnet.ibm.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Cc: linux-xfs@vger.kernel.org, hch@infradead.org, darrick.wong@oracle.com

On Thu, Jan 11, 2018 at 06:22:23PM +0530, Chandan Rajendra wrote:
> generic/388 can cause the following "use after free" error to occur,
> 
>  =============================================================================
>  BUG xfs_efi_item (Not tainted): Poison overwritten
>  -----------------------------------------------------------------------------
> 
>  Disabling lock debugging due to kernel taint
>  INFO: 0x00000000292c4bd4-0x00000000292c4bd4. First byte 0x6a instead of 0x6b
>  INFO: Allocated in .kmem_zone_alloc+0xcc/0x190 age=79 cpu=0 pid=12436
>  	.__slab_alloc+0x54/0x80
>  	.kmem_cache_alloc+0x124/0x350
>  	.kmem_zone_alloc+0xcc/0x190
>  	.xfs_efi_init+0x48/0xf0
>  	.xfs_extent_free_create_intent+0x40/0x130
>  	.xfs_defer_intake_work+0x74/0x1e0
>  	.xfs_defer_finish+0xac/0x5c0
>  	.xfs_itruncate_extents+0x170/0x590
>  	.xfs_inactive_truncate+0xcc/0x170
>  	.xfs_inactive+0x1d8/0x2f0
>  	.xfs_fs_destroy_inode+0xe4/0x3d0
>  	.destroy_inode+0x68/0xb0
>  	.do_unlinkat+0x1e8/0x390
>  	system_call+0x58/0x6c
>  INFO: Freed in .xfs_efi_item_free+0x44/0x80 age=79 cpu=0 pid=12436
>  	.kmem_cache_free+0x120/0x2b0
>  	.xfs_efi_item_free+0x44/0x80
>  	.xfs_trans_free_items+0xd4/0x130
>  	.__xfs_trans_commit+0xd0/0x350
>  	.xfs_trans_roll+0x4c/0x90
>  	.xfs_defer_trans_roll+0xa4/0x2b0
>  	.xfs_defer_finish+0xb8/0x5c0
>  	.xfs_itruncate_extents+0x170/0x590
>  	.xfs_inactive_truncate+0xcc/0x170
>  	.xfs_inactive+0x1d8/0x2f0
>  	.xfs_fs_destroy_inode+0xe4/0x3d0
>  	.destroy_inode+0x68/0xb0
>  	.do_unlinkat+0x1e8/0x390
>  	system_call+0x58/0x6c
> 
> This happens due to the following interaction,
> 1. xfs_defer_finish() creates "extent free" intent item and adds it to the
>    list at xfs_trans->t_items.
> 2. xfs_defer_trans_roll() invokes __xfs_trans_commit(). Here, if the
>    XFS_MOUNT_FS_SHUTDOWN flag is set, we invoke io_unlock() operation of the
>    corresponding log item. For "extent free" log items xfs_efi_item_unlock()
>    gets invoked which frees the xfs_efi_log_item.
> 3. xfs_defer_trans_roll() then invokes xfs_defer_trans_abort(). Since the
>    xfs_defer_pending->dfp_intent is still set to the "extent free" intent
>    item, we invoke xfs_extent_free_abort_intent(). This accesses the
>    previously freed xfs_efi_log_item to decrement the ref count.
> 
> This commit fixes the bug by changing xfs_efi_item_unlock() to invoke
> xfs_efi_release() instead of xfs_efi_item_free(). The xfs_efi_log_item gets
> freed when xfs_extent_free_abort_intent() invokes xfs_efi_release() once again
> i.e. its refcount becomes zero and hence xfs_efi_item_free() is invoked.
> 

Interesting.. trying to refamiliarize myself with the expected reference
counting rules here, I see that this goes back to the old
xfs_bmap_finish() mechanism. That guy would grab an EFI, log it and then
attempt to roll/commit the transaction. IIRC, the direct release covers
the case where that tx commit fails. That is essentially equivalent to a
tx cancel in this example, so the tx is freed and xfs_bmap_finish() is
done (returns with an error). The ->iop_unlock() frees the EFI in this
case explicitly because 1.) the refcount is initialized to 2, one for
the log and one for the EFD and 2.) the EFD is never created in this
situation.

Given that, I suspect this code was correct with the bmap_finish() code
and became a problem sometime later. Have you done any investigation to
confirm/deny whether this is a regression since v4.7 or so?

Moving along to the current code... xfs_defer_finish() creates the EFI,
logs it, etc. and moves on to xfs_trans_roll(). If the tx commit fails,
we're in a similar abort/cancel situation as before. The deferred ops code
tracks the EFI within the dfops data structures, however, so it calls
into the ->abort_intent() callout to drop the other reference and we hit
this problem.

AFAICT, the abort handler covers the only situation where an intent
would be left hanging around with an extra reference for the done item
but without the done item in existence yet. Given that, I think it's
safe to change the intent log state machine handling as this patch does.
The caveat is that with this change it is now required that the
committer of a failed transaction is always responsible for releasing
the reference on intent items for the associated done items that are not
going to be created (where it wasn't required before). IOW, I suspect we
could just as safely remove the abort handling code to resolve the
problem.  Since dfops seems to handle the situation correctly, I don't
really feel strongly either way.

I do think that this patch should at least:

- document the historical context in the commit log, provided the above
  can be verified (i.e., why/since when is this a problem?)
- update the comments in the intent item unlock handlers and probably
  the dfops code to make sure the reference counting rules are clear
- include the same updates for other applicable items in the same patch

... and finally, this should be tested against a frequent shutdown
workload if not done so already. E.g., run 'while [ true ]; do fsstress;
umount; mount; done' in one thread and 'while [ true ]; do sleep N;
xfs_io -xc "shutdown -f" ...; done' in another and verify we don't
explode/hang.

Brian

> Reported-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
> ---
> 
> The above mentioned "use after free" occurs with other log items.
> (e.g. xfs_rui_item). If the below fix is found to be correct, I will
> apply it to other affected log items as well and post a new patch.
> 
>  fs/xfs/xfs_extfree_item.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
> index 64da906..2119441 100644
> --- a/fs/xfs/xfs_extfree_item.c
> +++ b/fs/xfs/xfs_extfree_item.c
> @@ -151,7 +151,7 @@ xfs_efi_item_unlock(
>  	struct xfs_log_item	*lip)
>  {
>  	if (lip->li_flags & XFS_LI_ABORTED)
> -		xfs_efi_item_free(EFI_ITEM(lip));
> +		xfs_efi_release(EFI_ITEM(lip));
>  }
>  
>  /*
> -- 
> 2.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
