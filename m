Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78495C11F65
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Jun 2021 16:10:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B40661456
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Jun 2021 16:10:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231414AbhF3QMa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 30 Jun 2021 12:12:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:34964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229753AbhF3QM3 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 30 Jun 2021 12:12:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ADE056135C;
        Wed, 30 Jun 2021 16:10:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625069400;
        bh=Xl7eQVtsogaciu27BAH2AIGRlIJkJEZRzH+EdARB1Mg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rzXOLlkt2/bNBPWYNShVAW0kHnaJath5ppfosXb6X5xD4Izu+IhKdg4wi6WHrkzYF
         E3WmPyZwLB5MHhzLb0I+Nzey8ftin8U5e+WB4wnJFdmn4ae4ROAVFGj0UsgU9QUcfI
         9F8S0JamwdEMb1nDpvORx5BjQII3NB+X19OBxmJ75UD8eUT17F401vzIcWBrtlNqaR
         Gze8/bIM88NP8PidNZ/qSg5NR0gSMMvcUekBT2dY5ps6ktyh5zuRLfj+Qe7waAj/6h
         pUpWjQlkDtBEN15UFnAMSy9bOgoUbjLTBaWf90K72u402W3QdYtCjQom24jYMgInwF
         zS28DxH0HJSdg==
Date:   Wed, 30 Jun 2021 09:10:00 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/9] xfs: convert XLOG_FORCED_SHUTDOWN() to
 xlog_is_shutdown()
Message-ID: <20210630161000.GO13784@locust>
References: <20210630063813.1751007-1-david@fromorbit.com>
 <20210630063813.1751007-2-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210630063813.1751007-2-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 30, 2021 at 04:38:05PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Make it less shouty and a static inline before adding more calls
> through the log code.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Easy peasy,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_log.c         | 32 ++++++++++++++++----------------
>  fs/xfs/xfs_log_cil.c     | 10 +++++-----
>  fs/xfs/xfs_log_priv.h    |  7 +++++--
>  fs/xfs/xfs_log_recover.c |  9 +++------
>  fs/xfs/xfs_trans.c       |  2 +-
>  5 files changed, 30 insertions(+), 30 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 71fd8c0cad92..5ae11e7bf2fd 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -247,7 +247,7 @@ xlog_grant_head_wait(
>  	list_add_tail(&tic->t_queue, &head->waiters);
>  
>  	do {
> -		if (XLOG_FORCED_SHUTDOWN(log))
> +		if (xlog_is_shutdown(log))
>  			goto shutdown;
>  		xlog_grant_push_ail(log, need_bytes);
>  
> @@ -261,7 +261,7 @@ xlog_grant_head_wait(
>  		trace_xfs_log_grant_wake(log, tic);
>  
>  		spin_lock(&head->lock);
> -		if (XLOG_FORCED_SHUTDOWN(log))
> +		if (xlog_is_shutdown(log))
>  			goto shutdown;
>  	} while (xlog_space_left(log, &head->grant) < need_bytes);
>  
> @@ -366,7 +366,7 @@ xfs_log_writable(
>  		return false;
>  	if (xfs_readonly_buftarg(mp->m_log->l_targ))
>  		return false;
> -	if (XFS_FORCED_SHUTDOWN(mp))
> +	if (xlog_is_shutdown(mp->m_log))
>  		return false;
>  	return true;
>  }
> @@ -383,7 +383,7 @@ xfs_log_regrant(
>  	int			need_bytes;
>  	int			error = 0;
>  
> -	if (XLOG_FORCED_SHUTDOWN(log))
> +	if (xlog_is_shutdown(log))
>  		return -EIO;
>  
>  	XFS_STATS_INC(mp, xs_try_logspace);
> @@ -451,7 +451,7 @@ xfs_log_reserve(
>  
>  	ASSERT(client == XFS_TRANSACTION || client == XFS_LOG);
>  
> -	if (XLOG_FORCED_SHUTDOWN(log))
> +	if (xlog_is_shutdown(log))
>  		return -EIO;
>  
>  	XFS_STATS_INC(mp, xs_try_logspace);
> @@ -787,7 +787,7 @@ xlog_wait_on_iclog(
>  	struct xlog		*log = iclog->ic_log;
>  
>  	trace_xlog_iclog_wait_on(iclog, _RET_IP_);
> -	if (!XLOG_FORCED_SHUTDOWN(log) &&
> +	if (!xlog_is_shutdown(log) &&
>  	    iclog->ic_state != XLOG_STATE_ACTIVE &&
>  	    iclog->ic_state != XLOG_STATE_DIRTY) {
>  		XFS_STATS_INC(log->l_mp, xs_log_force_sleep);
> @@ -796,7 +796,7 @@ xlog_wait_on_iclog(
>  		spin_unlock(&log->l_icloglock);
>  	}
>  
> -	if (XLOG_FORCED_SHUTDOWN(log))
> +	if (xlog_is_shutdown(log))
>  		return -EIO;
>  	return 0;
>  }
> @@ -915,7 +915,7 @@ xfs_log_unmount_write(
>  
>  	xfs_log_force(mp, XFS_LOG_SYNC);
>  
> -	if (XLOG_FORCED_SHUTDOWN(log))
> +	if (xlog_is_shutdown(log))
>  		return;
>  
>  	/*
> @@ -1024,7 +1024,7 @@ xfs_log_space_wake(
>  	struct xlog		*log = mp->m_log;
>  	int			free_bytes;
>  
> -	if (XLOG_FORCED_SHUTDOWN(log))
> +	if (xlog_is_shutdown(log))
>  		return;
>  
>  	if (!list_empty_careful(&log->l_write_head.waiters)) {
> @@ -1115,7 +1115,7 @@ xfs_log_cover(
>  
>  	ASSERT((xlog_cil_empty(mp->m_log) && xlog_iclogs_empty(mp->m_log) &&
>  	        !xfs_ail_min_lsn(mp->m_log->l_ailp)) ||
> -	       XFS_FORCED_SHUTDOWN(mp));
> +		xlog_is_shutdown(mp->m_log));
>  
>  	if (!xfs_log_writable(mp))
>  		return 0;
> @@ -1546,7 +1546,7 @@ xlog_commit_record(
>  	};
>  	int	error;
>  
> -	if (XLOG_FORCED_SHUTDOWN(log))
> +	if (xlog_is_shutdown(log))
>  		return -EIO;
>  
>  	error = xlog_write(log, &vec, ticket, lsn, iclog, XLOG_COMMIT_TRANS);
> @@ -1627,7 +1627,7 @@ xlog_grant_push_ail(
>  	xfs_lsn_t	threshold_lsn;
>  
>  	threshold_lsn = xlog_grant_push_threshold(log, need_bytes);
> -	if (threshold_lsn == NULLCOMMITLSN || XLOG_FORCED_SHUTDOWN(log))
> +	if (threshold_lsn == NULLCOMMITLSN || xlog_is_shutdown(log))
>  		return;
>  
>  	/*
> @@ -2806,7 +2806,7 @@ xlog_state_do_callback(
>  			cycled_icloglock = true;
>  
>  			spin_lock(&log->l_icloglock);
> -			if (XLOG_FORCED_SHUTDOWN(log))
> +			if (xlog_is_shutdown(log))
>  				wake_up_all(&iclog->ic_force_wait);
>  			else
>  				xlog_state_clean_iclog(log, iclog);
> @@ -2858,7 +2858,7 @@ xlog_state_done_syncing(
>  	 * split log writes, on the second, we shut down the file system and
>  	 * no iclogs should ever be attempted to be written to disk again.
>  	 */
> -	if (!XLOG_FORCED_SHUTDOWN(log)) {
> +	if (!xlog_is_shutdown(log)) {
>  		ASSERT(iclog->ic_state == XLOG_STATE_SYNCING);
>  		iclog->ic_state = XLOG_STATE_DONE_SYNC;
>  	}
> @@ -2906,7 +2906,7 @@ xlog_state_get_iclog_space(
>  
>  restart:
>  	spin_lock(&log->l_icloglock);
> -	if (XLOG_FORCED_SHUTDOWN(log)) {
> +	if (xlog_is_shutdown(log)) {
>  		spin_unlock(&log->l_icloglock);
>  		return -EIO;
>  	}
> @@ -3754,7 +3754,7 @@ xfs_log_force_umount(
>  	 * No need to get locks for this.
>  	 */
>  	if (logerror && log->l_iclog->ic_state == XLOG_STATE_IOERROR) {
> -		ASSERT(XLOG_FORCED_SHUTDOWN(log));
> +		ASSERT(xlog_is_shutdown(log));
>  		return 1;
>  	}
>  
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index d162e8b83e90..23eec4f76f19 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -584,7 +584,7 @@ xlog_cil_committed(
>  	struct xfs_cil_ctx	*ctx)
>  {
>  	struct xfs_mount	*mp = ctx->cil->xc_log->l_mp;
> -	bool			abort = XLOG_FORCED_SHUTDOWN(ctx->cil->xc_log);
> +	bool			abort = xlog_is_shutdown(ctx->cil->xc_log);
>  
>  	/*
>  	 * If the I/O failed, we're aborting the commit and already shutdown.
> @@ -853,7 +853,7 @@ xlog_cil_push_work(
>  		 * shutdown, but then went back to sleep once already in the
>  		 * shutdown state.
>  		 */
> -		if (XLOG_FORCED_SHUTDOWN(log)) {
> +		if (xlog_is_shutdown(log)) {
>  			spin_unlock(&cil->xc_push_lock);
>  			goto out_abort_free_ticket;
>  		}
> @@ -962,7 +962,7 @@ xlog_cil_push_work(
>  out_abort_free_ticket:
>  	xfs_log_ticket_ungrant(log, tic);
>  out_abort:
> -	ASSERT(XLOG_FORCED_SHUTDOWN(log));
> +	ASSERT(xlog_is_shutdown(log));
>  	xlog_cil_committed(ctx);
>  }
>  
> @@ -1115,7 +1115,7 @@ xlog_cil_commit(
>  
>  	xlog_cil_insert_items(log, tp);
>  
> -	if (regrant && !XLOG_FORCED_SHUTDOWN(log))
> +	if (regrant && !xlog_is_shutdown(log))
>  		xfs_log_ticket_regrant(log, tp->t_ticket);
>  	else
>  		xfs_log_ticket_ungrant(log, tp->t_ticket);
> @@ -1188,7 +1188,7 @@ xlog_cil_force_seq(
>  		 * shutdown, but then went back to sleep once already in the
>  		 * shutdown state.
>  		 */
> -		if (XLOG_FORCED_SHUTDOWN(log))
> +		if (xlog_is_shutdown(log))
>  			goto out_shutdown;
>  		if (ctx->sequence > sequence)
>  			continue;
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index 4c41bbfa33b0..80d4e1325e1d 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -454,8 +454,11 @@ struct xlog {
>  #define XLOG_BUF_CANCEL_BUCKET(log, blkno) \
>  	((log)->l_buf_cancel_table + ((uint64_t)blkno % XLOG_BC_TABLE_SIZE))
>  
> -#define XLOG_FORCED_SHUTDOWN(log) \
> -	(unlikely((log)->l_flags & XLOG_IO_ERROR))
> +static inline bool
> +xlog_is_shutdown(struct xlog *log)
> +{
> +	return (log->l_flags & XLOG_IO_ERROR);
> +}
>  
>  /* common routines */
>  extern int
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 1a291bf50776..f1b828dedb25 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -144,7 +144,7 @@ xlog_do_io(
>  
>  	error = xfs_rw_bdev(log->l_targ->bt_bdev, log->l_logBBstart + blk_no,
>  			BBTOB(nbblks), data, op);
> -	if (error && !XFS_FORCED_SHUTDOWN(log->l_mp)) {
> +	if (error && !xlog_is_shutdown(log)) {
>  		xfs_alert(log->l_mp,
>  			  "log recovery %s I/O error at daddr 0x%llx len %d error %d",
>  			  op == REQ_OP_WRITE ? "write" : "read",
> @@ -3278,10 +3278,7 @@ xlog_do_recover(
>  	if (error)
>  		return error;
>  
> -	/*
> -	 * If IO errors happened during recovery, bail out.
> -	 */
> -	if (XFS_FORCED_SHUTDOWN(mp))
> +	if (xlog_is_shutdown(log))
>  		return -EIO;
>  
>  	/*
> @@ -3303,7 +3300,7 @@ xlog_do_recover(
>  	xfs_buf_hold(bp);
>  	error = _xfs_buf_read(bp, XBF_READ);
>  	if (error) {
> -		if (!XFS_FORCED_SHUTDOWN(mp)) {
> +		if (!xlog_is_shutdown(log)) {
>  			xfs_buf_ioerror_alert(bp, __this_address);
>  			ASSERT(0);
>  		}
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index 87bffd12c20c..e26ade9fc630 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -908,7 +908,7 @@ __xfs_trans_commit(
>  	 */
>  	xfs_trans_unreserve_and_mod_dquots(tp);
>  	if (tp->t_ticket) {
> -		if (regrant && !XLOG_FORCED_SHUTDOWN(mp->m_log))
> +		if (regrant && !xlog_is_shutdown(mp->m_log))
>  			xfs_log_ticket_regrant(mp->m_log, tp->t_ticket);
>  		else
>  			xfs_log_ticket_ungrant(mp->m_log, tp->t_ticket);
> -- 
> 2.31.1
> 
