Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61454C12002
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jul 2021 22:09:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3FEAF600D4
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jul 2021 22:09:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231402AbhGNWMQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 14 Jul 2021 18:12:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:46432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229750AbhGNWMQ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 14 Jul 2021 18:12:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5C91C613C5;
        Wed, 14 Jul 2021 22:09:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626300564;
        bh=tfVlx0z0XP9ntEazSvpC6kewlP51oldLKfK8LZc1umI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=f6Z6Jn9MBPwlBE6J6gMWoyjMJF4c6hhgVBiJrWqFO2W3rWKmlaXZyq7tvokdVOXUQ
         pL0TfrPqk8In6zl8kihWO0VvIf8cwHKcAvD+UU0B2Xy9dl75A4tJtpQmTSWi7PI4g/
         1RUxFFXxqe5cmQ+/apqBTCn/Y1IWTNuh5LRjtRFtBbcuj37HT36+k0Umno5SEUJXOy
         GVqRBMxQdB78SwIwK+ZodU7Q8cwBXub+kh6O6a/zObilbbQGDUhy9l1tDUYZm3jQVr
         AcinifcSsAALqqi6wT+oZYsiTOoM9pOAFBMsXAXUrhIX4YzawnA+7wrGkU0k29WVc7
         /kSrwYLa+N12A==
Date:   Wed, 14 Jul 2021 15:09:24 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 8/9] xfs: don't run shutdown callbacks on active iclogs
Message-ID: <20210714220924.GQ22402@magnolia>
References: <20210714031958.2614411-1-david@fromorbit.com>
 <20210714031958.2614411-9-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210714031958.2614411-9-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 14, 2021 at 01:19:57PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When the log is shutdown, it currently walks all the iclogs and runs
> callbacks that are attached to the iclogs, regardless of whether the
> iclog is queued for IO completion or not. This creates a problem for
> contexts attaching callbacks to iclogs in that a racing shutdown can
> run the callbacks even before the attaching context has finished
> processing the iclog and releasing it for IO submission.
> 
> If the callback processing of the iclog frees the structure that is
> attached to the iclog, then this leads to an UAF scenario that can
> only be protected against by holding the icloglock from the point
> callbacks are attached through to the release of the iclog. While we
> currently do this, it is not practical or sustainable.
> 
> Hence we need to make shutdown processing the responsibility of the
> context that holds active references to the iclog. We know that the
> contexts attaching callbacks to the iclog must have active
> references to the iclog, and that means they must be in either
> ACTIVE or WANT_SYNC states. xlog_state_do_callback() will skip over
> iclogs in these states -except- when the log is shut down.
> 
> xlog_state_do_callback() checks the state of the iclogs while
> holding the icloglock, therefore the reference count/state change
> that occurs in xlog_state_release_iclog() after the callbacks are
> atomic w.r.t. shutdown processing.
> 
> We can't push the responsibility of callback cleanup onto the CIL
> context because we can have ACTIVE iclogs that have callbacks
> attached that have already been released. Hence we really need to
> internalise the cleanup of callbacks into xlog_state_release_iclog()
> processing.
> 
> Indeed, we already have that internalisation via:
> 
> xlog_state_release_iclog
>   drop last reference
>     ->SYNCING
>   xlog_sync
>     xlog_write_iclog
>       if (log_is_shutdown)
>         xlog_state_done_syncing()
> 	  xlog_state_do_callback()
> 	    <process shutdown on iclog that is now in SYNCING state>
> 
> The problem is that xlog_state_release_iclog() aborts before doing
> anything if the log is already shut down. It assumes that the
> callbacks have already been cleaned up, and it doesn't need to do
> any cleanup.
> 
> Hence the fix is to remove the xlog_is_shutdown() check from
> xlog_state_release_iclog() so that reference counts are correctly
> released from the iclogs, and when the reference count is zero we
> always transition to SYNCING if the log is shut down. Hence we'll
> always enter the xlog_sync() path in a shutdown and eventually end
> up erroring out the iclog IO and running xlog_state_do_callback() to
> process the callbacks attached to the iclog.
> 
> This allows us to stop processing referenced ACTIVE/WANT_SYNC iclogs
> directly in the shutdown code, and in doing so gets rid of the UAF
> vector that currently exists. This then decouples the adding of
> callbacks to the iclogs from xlog_state_release_iclog() as we
> guarantee that xlog_state_release_iclog() will process the callbacks
> if the log has been shut down before xlog_state_release_iclog() has
> been called.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Seems reasonable...
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_log.c     | 43 +++++++++++++++++++++++++++++++++++++------
>  fs/xfs/xfs_log_cil.c | 15 +++++++--------
>  2 files changed, 44 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 4d72d9efed7c..01c20b42b2fc 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -41,6 +41,8 @@ xlog_dealloc_log(
>  /* local state machine functions */
>  STATIC void xlog_state_done_syncing(
>  	struct xlog_in_core	*iclog);
> +STATIC void xlog_state_do_callback(
> +	struct xlog		*log);
>  STATIC int
>  xlog_state_get_iclog_space(
>  	struct xlog		*log,
> @@ -492,6 +494,11 @@ xfs_log_reserve(
>   * space waiters so they can process the newly set shutdown state. We really
>   * don't care what order we process callbacks here because the log is shut down
>   * and so state cannot change on disk anymore.
> + *
> + * We avoid processing actively referenced iclogs so that we don't run callbacks
> + * while the iclog owner might still be preparing the iclog for IO submssion.
> + * These will be caught by xlog_state_iclog_release() and call this function
> + * again to process any callbacks that may have been added to that iclog.
>   */
>  static void
>  xlog_state_shutdown_callbacks(
> @@ -503,7 +510,12 @@ xlog_state_shutdown_callbacks(
>  	spin_lock(&log->l_icloglock);
>  	iclog = log->l_iclog;
>  	do {
> +		if (atomic_read(&iclog->ic_refcnt)) {
> +			/* Reference holder will re-run iclog callbacks. */
> +			continue;
> +		}
>  		list_splice_init(&iclog->ic_callbacks, &cb_list);
> +		wake_up_all(&iclog->ic_write_wait);
>  		wake_up_all(&iclog->ic_force_wait);
>  	} while ((iclog = iclog->ic_next) != log->l_iclog);
>  
> @@ -514,7 +526,7 @@ xlog_state_shutdown_callbacks(
>  }
>  
>  static bool
> -__xlog_state_release_iclog(
> +xlog_state_want_sync(
>  	struct xlog		*log,
>  	struct xlog_in_core	*iclog)
>  {
> @@ -537,27 +549,46 @@ __xlog_state_release_iclog(
>  }
>  
>  /*
> - * Flush iclog to disk if this is the last reference to the given iclog and the
> - * it is in the WANT_SYNC state.
> + * Release the active reference to the iclog. If this is the last reference to
> + * the iclog being dropped, check if the caller wants to be synced to disk and
> + * initiate IO submission. If the log has been shut down, then we need to run
> + * callback processing on this iclog as shutdown callback processing skips
> + * actively referenced iclogs.
>   */
>  int
>  xlog_state_release_iclog(
>  	struct xlog		*log,
>  	struct xlog_in_core	*iclog)
> +		__releases(&log->l_icloglock)
> +		__acquires(&log->l_icloglock)
>  {
>  	lockdep_assert_held(&log->l_icloglock);
>  
>  	trace_xlog_iclog_release(iclog, _RET_IP_);
> -	if (xlog_is_shutdown(log))
> +	if (!atomic_dec_and_test(&iclog->ic_refcnt))
> +		goto out_check_shutdown;
> +
> +	if (xlog_is_shutdown(log)) {
> +		/*
> +		 * No more references to this iclog, so process the pending
> +		 * iclog callbacks that were waiting on the release of this
> +		 * iclog.
> +		 */
> +		spin_unlock(&log->l_icloglock);
> +		xlog_state_shutdown_callbacks(log);
> +		spin_lock(&log->l_icloglock);
>  		return -EIO;
> +	}
>  
> -	if (atomic_dec_and_test(&iclog->ic_refcnt) &&
> -	    __xlog_state_release_iclog(log, iclog)) {
> +	if (xlog_state_want_sync(log, iclog)) {
>  		spin_unlock(&log->l_icloglock);
>  		xlog_sync(log, iclog);
>  		spin_lock(&log->l_icloglock);
>  	}
>  
> +out_check_shutdown:
> +	if (xlog_is_shutdown(log))
> +		return -EIO;
>  	return 0;
>  }
>  
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index 2c9d9bcd25cb..62967449fe8c 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -874,11 +874,10 @@ xlog_cil_push_work(
>  	xfs_log_ticket_ungrant(log, tic);
>  
>  	/*
> -	 * Once we attach the ctx to the iclog, a shutdown can process the
> -	 * iclog, run the callbacks and free the ctx. The only thing preventing
> -	 * this potential UAF situation here is that we are holding the
> -	 * icloglock. Hence we cannot access the ctx once we have attached the
> -	 * callbacks and dropped the icloglock.
> +	 * Once we attach the ctx to the iclog, it is effectively owned by the
> +	 * iclog and we can only use it while we still have an active reference
> +	 * to the iclog. i.e. once we call xlog_state_release_iclog() we can no
> +	 * longer safely reference the ctx.
>  	 */
>  	spin_lock(&log->l_icloglock);
>  	if (xlog_is_shutdown(log)) {
> @@ -910,9 +909,6 @@ xlog_cil_push_work(
>  	 * wakeup until this commit_iclog is written to disk.  Hence we use the
>  	 * iclog header lsn and compare it to the commit lsn to determine if we
>  	 * need to wait on iclogs or not.
> -	 *
> -	 * NOTE: It is not safe to reference the ctx after this check as we drop
> -	 * the icloglock if we have to wait for completion of other iclogs.
>  	 */
>  	if (ctx->start_lsn != commit_lsn) {
>  		xfs_lsn_t	plsn;
> @@ -942,6 +938,9 @@ xlog_cil_push_work(
>  	 */
>  	commit_iclog->ic_flags |= XLOG_ICL_NEED_FUA;
>  	xlog_state_release_iclog(log, commit_iclog);
> +
> +	/* Not safe to reference ctx now! */
> +
>  	spin_unlock(&log->l_icloglock);
>  	return;
>  
> -- 
> 2.31.1
> 
