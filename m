Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45844 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752037AbdCCUtE (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 3 Mar 2017 15:49:04 -0500
Date: Fri, 3 Mar 2017 15:49:03 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: clear XBF_ASYNC if we attach an iodone callback
Message-ID: <20170303204902.GF21245@bfoster.bfoster>
References: <1488552404-21379-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1488552404-21379-1-git-send-email-jbacik@fb.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Josef Bacik <jbacik@fb.com>
Cc: linux-xfs@vger.kernel.org, darrick.wong@oracle.com, kernel-team@fb.com

On Fri, Mar 03, 2017 at 09:46:44AM -0500, Josef Bacik wrote:
> While testing nbd disconnects I kept hitting the following hang
> 
> Call Trace:
>  schedule+0x35/0x80
>  xfs_ail_push_all_sync+0xa3/0xe0
>  ? prepare_to_wait_event+0x100/0x100
>  xfs_unmountfs+0x57/0x190
>  xfs_fs_put_super+0x32/0x90
>  generic_shutdown_super+0x6f/0xf0
>  kill_block_super+0x27/0x70
>  deactivate_locked_super+0x3e/0x70
>  deactivate_super+0x46/0x60
>  cleanup_mnt+0x3f/0x80
>  __cleanup_mnt+0x12/0x20
>  task_work_run+0x86/0xb0
>  exit_to_usermode_loop+0x6d/0x96
>  do_syscall_64+0x8b/0xa0
>  entry_SYSCALL64_slow_path+0x25/0x25
> 
> After some digging around I found that there was a log item on the ail
> with a callback of xfs_iflush_done.  A printk confirmed that at the call
> to xfs_buf_attach_iodone in xfs_iflush_int had XBF_ASYNC already set,
> which means on error we do not call xfs_buf_do_callbacks, which leaves
> the log item on the ail list which causes us to hang on unmount.  I
> assume the block has XBF_ASYNC set because we did a readahead on it, so
> it doesn't really need to have XBF_ASYNC set at this point as we do
> actually care about what happens to the buffer once IO is complete.
> With this patch my hang no longer happens.
> 
> Signed-off-by: Josef Bacik <jbacik@fb.com>
> ---
>  fs/xfs/xfs_buf_item.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> index 2975cb2..24fcb67 100644
> --- a/fs/xfs/xfs_buf_item.c
> +++ b/fs/xfs/xfs_buf_item.c
> @@ -1016,6 +1016,11 @@ xfs_buf_attach_iodone(
>  
>  	ASSERT(bp->b_iodone == NULL ||
>  	       bp->b_iodone == xfs_buf_iodone_callbacks);
> +	/*
> +	 * Somebody now cares about the fate of this buffer, clear XBF_ASYNC so
> +	 * that the iodone callback actually gets called.
> +	 */
> +	bp->b_flags &= ~XBF_ASYNC;

XBF_ASYNC generally describes the type of I/O being submitted for a
particular buffer (blocking or non), so it being set or not is kind of
outside the scope of xfs_iflush(). It really depends on how the caller
ultimately wants to write the buffer. For example, if we get here via
xfsaild_push()->xfs_inode_item_push(), the latter will do
xfs_buf_delwri_queue() and the former will eventually call
xfs_buf_delwri_submit_nowait(), which submits async I/O and so will
re-add XBF_ASYNC.

It is interesting if this prevents your problem. I can't quite make out
why that would be. The other xfs_iflush() caller is reclaim, which calls
xfs_bwrite() which itself clears XBF_ASYNC before submission.

What I'm guessing you're referring to above wrt to not calling
xfs_buf_do_callbacks() is the async check in
xfs_buf_iodone_callback_error(), which is only relevant on I/O error. If
the buffer I/O succeeds, we should always invoke the iodone callbacks
regardless of async state. Do you observe otherwise or does this I/O
indeed fail?

Anyways, if we change the buffer flags simply to control the behavior of
iodone_callback_error(), we've basically decided to treat an otherwise
async I/O as sync with the assumption that the submitter is going to
handle the I/O error. As mentioned above, we don't really have that
information here so that is kind of a dangerous assumption. At the very
least, it bypasses all of the configurable error handling infrastructure
that is specifically in place for async submitted buffers.

I'm wondering if you're hitting the flush locked inode retry problem
that Carlos has been working on. The problem is basically that if the
I/O fails on a buffer that backs a flush locked inode, we never retry
the buffer and xfsaild basically spins on pushing the inode. What
happens if you enable xfs tracepoints while the fs is hung?

Brian

>  	bp->b_iodone = xfs_buf_iodone_callbacks;
>  }
>  
> -- 
> 2.5.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
