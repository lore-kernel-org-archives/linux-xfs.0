Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4F58C433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Mar 2022 23:05:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230272AbiC1XHQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Mar 2022 19:07:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230283AbiC1XHO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Mar 2022 19:07:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 963BB6270
        for <linux-xfs@vger.kernel.org>; Mon, 28 Mar 2022 16:05:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3A4A560E73
        for <linux-xfs@vger.kernel.org>; Mon, 28 Mar 2022 23:05:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FC0AC340EC;
        Mon, 28 Mar 2022 23:05:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648508731;
        bh=vUug5o5NjzWUeOjXP5zYav+ZHcJh9bEKApga/Df328Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XPYoutg+5tFHGVfQ4nVndJFHwE5VX2MSDH1QwKkstW/jvFJHhT/edjOXaT/QDylsZ
         jIRArvZjuQoHP/SHJYmSNRqhMpDu6sxVtNt2p3iEZGFd8dbiNwolkQV7k6DDimO+YD
         iI2uo6OYBKzjb3U3iZnFLhbgPWh05ap3m4OjO8cOdHjHD8gO7jtt/1w2SWR8GO2ncX
         BoyKWdsar/ERqYMc+EhfmSebwdORCGZnQ3P9yyWLRXIjv01WCaqB/nEt3n6Nnz7HPW
         Q6DWf7vonGcOJ2vPmAwVl0R2niU4ESjmqyGHIPtJTKNC9sDlZhkNc8BU1dy2iQ0Oqe
         1awpVnxcdrxNg==
Date:   Mon, 28 Mar 2022 16:05:31 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/6] xfs: run callbacks before waking waiters in
 xlog_state_shutdown_callbacks
Message-ID: <20220328230531.GB27713@magnolia>
References: <20220324002103.710477-1-david@fromorbit.com>
 <20220324002103.710477-4-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220324002103.710477-4-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 24, 2022 at 11:21:00AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Brian reported a null pointer dereference failure during unmount in
> xfs/006. He tracked the problem down to the AIL being torn down
> before a log shutdown had completed and removed all the items from
> the AIL. The failure occurred in this path while unmount was
> proceeding in another task:
> 
>  xfs_trans_ail_delete+0x102/0x130 [xfs]
>  xfs_buf_item_done+0x22/0x30 [xfs]
>  xfs_buf_ioend+0x73/0x4d0 [xfs]
>  xfs_trans_committed_bulk+0x17e/0x2f0 [xfs]
>  xlog_cil_committed+0x2a9/0x300 [xfs]
>  xlog_cil_process_committed+0x69/0x80 [xfs]
>  xlog_state_shutdown_callbacks+0xce/0xf0 [xfs]
>  xlog_force_shutdown+0xdf/0x150 [xfs]
>  xfs_do_force_shutdown+0x5f/0x150 [xfs]
>  xlog_ioend_work+0x71/0x80 [xfs]
>  process_one_work+0x1c5/0x390
>  worker_thread+0x30/0x350
>  kthread+0xd7/0x100
>  ret_from_fork+0x1f/0x30
> 
> This is processing an EIO error to a log write, and it's
> triggering a force shutdown. This causes the log to be shut down,
> and then it is running attached iclog callbacks from the shutdown
> context. That means the fs and log has already been marked as
> xfs_is_shutdown/xlog_is_shutdown and so high level code will abort
> (e.g. xfs_trans_commit(), xfs_log_force(), etc) with an error
> because of shutdown.
> 
> The umount would have been blocked waiting for a log force
> completion inside xfs_log_cover() -> xfs_sync_sb(). The first thing
> for this situation to occur is for xfs_sync_sb() to exit without
> waiting for the iclog buffer to be comitted to disk. The
> above trace is the completion routine for the iclog buffer, and
> it is shutting down the filesystem.
> 
> xlog_state_shutdown_callbacks() does this:
> 
> {
>         struct xlog_in_core     *iclog;
>         LIST_HEAD(cb_list);
> 
>         spin_lock(&log->l_icloglock);
>         iclog = log->l_iclog;
>         do {
>                 if (atomic_read(&iclog->ic_refcnt)) {
>                         /* Reference holder will re-run iclog callbacks. */
>                         continue;
>                 }
>                 list_splice_init(&iclog->ic_callbacks, &cb_list);
> >>>>>>           wake_up_all(&iclog->ic_write_wait);
> >>>>>>           wake_up_all(&iclog->ic_force_wait);
>         } while ((iclog = iclog->ic_next) != log->l_iclog);
> 
>         wake_up_all(&log->l_flush_wait);
>         spin_unlock(&log->l_icloglock);
> 
> >>>>>>  xlog_cil_process_committed(&cb_list);
> }
> 
> It wakes forces waiters before shutdown processes all the pending
> callbacks.

I'm not sure what this means.

Are you saying that log shutdown wakes up iclog waiters before it
processes pending callbacks?  And then anyone who waits on an iclog (log
forces, I guess?) will wake up and race with the callbacks?

> That means the xfs_sync_sb() waiting on a sync
> transaction in xfs_log_force() on iclog->ic_force_wait will get
> woken before the callbacks attached to that iclog are run. This
> results in xfs_sync_sb() returning an error, and so unmount unblocks
> and continues to run whilst the log shutdown is still in progress.
> 
> Normally this is just fine because the force waiter has nothing to
> do with AIL operations. But in the case of this unmount path, the
> log force waiter goes on to tear down the AIL because the log is now
> shut down and so nothing ever blocks it again from the wait point in
> xfs_log_cover().
> 
> Hence it's a race to see who gets to the AIL first - the unmount
> code or xlog_cil_process_committed() killing the superblock buffer.
> 
> To fix this, we just have to change the order of processing in
> xlog_state_shutdown_callbacks() to run the callbacks before it wakes
> any task waiting on completion of the iclog.

Hmm.  I think my guess above is correct, then.  I /think/ the code looks
ok based on my above guess at comprehension.

--D

> 
> Reported-by: Brian Foster <bfoster@redhat.com>
> Fixes: aad7272a9208 ("xfs: separate out log shutdown callback processing")
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_log.c | 22 +++++++++++++---------
>  1 file changed, 13 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index fbf1b08b698c..388d53df7620 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -487,7 +487,10 @@ xfs_log_reserve(
>   * Run all the pending iclog callbacks and wake log force waiters and iclog
>   * space waiters so they can process the newly set shutdown state. We really
>   * don't care what order we process callbacks here because the log is shut down
> - * and so state cannot change on disk anymore.
> + * and so state cannot change on disk anymore. However, we cannot wake waiters
> + * until the callbacks have been processed because we may be in unmount and
> + * we must ensure that all AIL operations the callbacks perform have completed
> + * before we tear down the AIL.
>   *
>   * We avoid processing actively referenced iclogs so that we don't run callbacks
>   * while the iclog owner might still be preparing the iclog for IO submssion.
> @@ -501,7 +504,6 @@ xlog_state_shutdown_callbacks(
>  	struct xlog_in_core	*iclog;
>  	LIST_HEAD(cb_list);
>  
> -	spin_lock(&log->l_icloglock);
>  	iclog = log->l_iclog;
>  	do {
>  		if (atomic_read(&iclog->ic_refcnt)) {
> @@ -509,14 +511,16 @@ xlog_state_shutdown_callbacks(
>  			continue;
>  		}
>  		list_splice_init(&iclog->ic_callbacks, &cb_list);
> +		spin_unlock(&log->l_icloglock);
> +
> +		xlog_cil_process_committed(&cb_list);
> +
> +		spin_lock(&log->l_icloglock);
>  		wake_up_all(&iclog->ic_write_wait);
>  		wake_up_all(&iclog->ic_force_wait);
>  	} while ((iclog = iclog->ic_next) != log->l_iclog);
>  
>  	wake_up_all(&log->l_flush_wait);
> -	spin_unlock(&log->l_icloglock);
> -
> -	xlog_cil_process_committed(&cb_list);
>  }
>  
>  /*
> @@ -571,11 +575,8 @@ xlog_state_release_iclog(
>  		 * pending iclog callbacks that were waiting on the release of
>  		 * this iclog.
>  		 */
> -		if (last_ref) {
> -			spin_unlock(&log->l_icloglock);
> +		if (last_ref)
>  			xlog_state_shutdown_callbacks(log);
> -			spin_lock(&log->l_icloglock);
> -		}
>  		return -EIO;
>  	}
>  
> @@ -3889,7 +3890,10 @@ xlog_force_shutdown(
>  	wake_up_all(&log->l_cilp->xc_start_wait);
>  	wake_up_all(&log->l_cilp->xc_commit_wait);
>  	spin_unlock(&log->l_cilp->xc_push_lock);
> +
> +	spin_lock(&log->l_icloglock);
>  	xlog_state_shutdown_callbacks(log);
> +	spin_unlock(&log->l_icloglock);
>  
>  	return log_error;
>  }
> -- 
> 2.35.1
> 
