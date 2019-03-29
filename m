Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:43724 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729906AbfC2UPu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 29 Mar 2019 16:15:50 -0400
Subject: Re: [PATCH 1/2] xfs: wake commit waiters on CIL abort before log item
 abort
References: <20190329134059.12723-1-bfoster@redhat.com>
 <20190329134059.12723-2-bfoster@redhat.com>
From: Allison Henderson <allison.henderson@oracle.com>
Message-ID: <a0ed46ed-dbf6-7f7c-1430-aefb0dd7919e@oracle.com>
Date: Fri, 29 Mar 2019 13:15:44 -0700
MIME-Version: 1.0
In-Reply-To: <20190329134059.12723-2-bfoster@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org

Alrighty, thanks for the detailed commit message, it helps.  Sometimes I 
wonder if adding links to the corresponding discussion threads would 
help tie the patches to the discussions that went into them?  In any 
case, you can add my review.

Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

On 3/29/19 6:40 AM, Brian Foster wrote:
> XFS shutdown deadlocks have been reproduced by fstest generic/475.
> The deadlock signature involves log I/O completion running error
> handling to abort logged items and waiting for an inode cluster
> buffer lock in the buffer item unpin handler. The buffer lock is
> held by xfsaild attempting to flush an inode. The buffer happens to
> be pinned and so xfs_iflush() triggers an async log force to begin
> work required to get it unpinned. The log force is blocked waiting
> on the commit completion, which never occurs and thus leaves the
> filesystem deadlocked.
> 
> The root problem is that aborted log I/O completion pots commit
> completion behind callback completion, which is unexpected for async
> log forces. Under normal running conditions, an async log force
> returns to the caller once the CIL ctx has been formatted/submitted
> and the commit completion event triggered at the tail end of
> xlog_cil_push(). If the filesystem has shutdown, however, we rely on
> xlog_cil_committed() to trigger the completion event and it happens
> to do so after running log item unpin callbacks. This makes it
> unsafe to invoke an async log force from contexts that hold locks
> that might also be required in log completion processing.
> 
> To address this problem, wake commit completion waiters before
> aborting log items in the log I/O completion handler. This ensures
> that an async log force will not deadlock on held locks if the
> filesystem happens to shutdown. Note that it is still unsafe to
> issue a sync log force while holding such locks because a sync log
> force explicitly waits on the force completion, which occurs after
> log I/O completion processing.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>   fs/xfs/xfs_log_cil.c | 21 +++++++++++++--------
>   1 file changed, 13 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index d3884e08b43c..5e595948bc5a 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -582,6 +582,19 @@ xlog_cil_committed(
>   	struct xfs_cil_ctx	*ctx = args;
>   	struct xfs_mount	*mp = ctx->cil->xc_log->l_mp;
>   
> +	/*
> +	 * If the I/O failed, we're aborting the commit and already shutdown.
> +	 * Wake any commit waiters before aborting the log items so we don't
> +	 * block async log pushers on callbacks. Async log pushers explicitly do
> +	 * not wait on log force completion because they may be holding locks
> +	 * required to unpin items.
> +	 */
> +	if (abort) {
> +		spin_lock(&ctx->cil->xc_push_lock);
> +		wake_up_all(&ctx->cil->xc_commit_wait);
> +		spin_unlock(&ctx->cil->xc_push_lock);
> +	}
> +
>   	xfs_trans_committed_bulk(ctx->cil->xc_log->l_ailp, ctx->lv_chain,
>   					ctx->start_lsn, abort);
>   
> @@ -589,15 +602,7 @@ xlog_cil_committed(
>   	xfs_extent_busy_clear(mp, &ctx->busy_extents,
>   			     (mp->m_flags & XFS_MOUNT_DISCARD) && !abort);
>   
> -	/*
> -	 * If we are aborting the commit, wake up anyone waiting on the
> -	 * committing list.  If we don't, then a shutdown we can leave processes
> -	 * waiting in xlog_cil_force_lsn() waiting on a sequence commit that
> -	 * will never happen because we aborted it.
> -	 */
>   	spin_lock(&ctx->cil->xc_push_lock);
> -	if (abort)
> -		wake_up_all(&ctx->cil->xc_commit_wait);
>   	list_del(&ctx->committing);
>   	spin_unlock(&ctx->cil->xc_push_lock);
>   
> 
