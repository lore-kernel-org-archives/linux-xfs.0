Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C78FC433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Mar 2021 02:01:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 67A2B64F81
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Mar 2021 02:01:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229459AbhCKCBS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 10 Mar 2021 21:01:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:36098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229675AbhCKCAq (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 10 Mar 2021 21:00:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2400A64F81;
        Thu, 11 Mar 2021 02:00:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615428046;
        bh=ZTQaFyBfCU5STJPeHGzVuxAw2qk/Y8OciR/0C1YT8Zw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eEYhHSm5qdFV34WR+9K63d9oksJ+TH0qRLSE6heAs6c9tzDRMt+FdYyW2sJlGAQXZ
         8A4ZsB+n4J2h+Bg4t4PQWTM52rlzeFsVnM8zFabMpXHprJOMnez5P3G6/VKt0VqO/1
         wkGm1I2/lD2L8LmUWWJCNphlpBF0SF7NDC7SacJgQ0hgAdRdpro7YKxYnhvyC/RXRY
         UJu5wJOoXmoBxp6T6zcwEQeBt2YZuniJC7+/LqS/vXkJ6PFOy/lJV4A3OU/suSwN9l
         We6dUI3h8q/L4BNSzlg0QM0/cCq6hLIZBkBzWryrMDaNdIPICuBYqdFlJo6JEEp4pJ
         61urZ8kclmG5A==
Date:   Wed, 10 Mar 2021 18:00:45 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 44/45] xfs: xlog_sync() manually adjusts grant head space
Message-ID: <20210311020045.GR3419940@magnolia>
References: <20210305051143.182133-1-david@fromorbit.com>
 <20210305051143.182133-45-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210305051143.182133-45-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 05, 2021 at 04:11:42PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When xlog_sync() rounds off the tail the iclog that is being
> flushed, it manually subtracts that space from the grant heads. This
> space is actually reserved by the transaction ticket that covers
> the xlog_sync() call from xlog_write(), but we don't plumb the
> ticket down far enough for it to account for the space consumed in
> the current log ticket.
> 
> The grant heads are hot, so we really should be accounting this to
> the ticket is we can, rather than adding thousands of extra grant
> head updates every CIL commit.
> 
> Interestingly, this actually indicates a potential log space overrun
> can occur when we force the log. By the time that xfs_log_force()
> pushes out an active iclog and consumes the roundoff space, the

Ok I was wondering about that when I was trying to figure out what all
this ticket space stealing code was doing.

So in addition to fixing the theoretical overrun, I guess the
performance fix here is that every time we write an iclog we might have
to move the grant heads forward so that we always write a full log
sector / log stripe unit?  And since a CIL context might write a lot of
iclogs, it's cheaper to make those grant adjustments to the CIL ticket
(which already asked for enough space to handle the roundoffs) since the
ticket only jumps in the hot path once when the ticket is ungranted?

If I got that right,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> reservation for that roundoff space has been returned to the grant
> heads and is no longer covered by a reservation. In theory the
> roundoff added to log force on an already full log could push the
> write head past the tail. In practice, the CIL commit that writes to
> the log and needs the iclog pushed will have reserved space for
> roundoff, so when it releases the ticket there will still be
> physical space for the roundoff to be committed to the log, even
> though it is no longer reserved. This roundoff won't be enough space
> to allow a transaction to be woken if the log is full, so overruns
> should not actually occur in practice.
> 
> That said, it indicates that we should not release the CIL context
> log ticket until after we've released the commit iclog. It also
> means that xlog_sync() still needs the direct grant head
> manipulation if we don't provide it with a ticket. Log forces are
> rare when we are in fast paths running 1.5 million transactions/s
> that make the grant heads hot, so let's optimise the hot case and
> pass CIL log tickets down to the xlog_sync() code.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_log.c      | 39 +++++++++++++++++++++++++--------------
>  fs/xfs/xfs_log_cil.c  | 19 ++++++++++++++-----
>  fs/xfs/xfs_log_priv.h |  3 ++-
>  3 files changed, 41 insertions(+), 20 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index fd58c3213ebf..1c7d522b12cd 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -55,7 +55,8 @@ xlog_grant_push_ail(
>  STATIC void
>  xlog_sync(
>  	struct xlog		*log,
> -	struct xlog_in_core	*iclog);
> +	struct xlog_in_core	*iclog,
> +	struct xlog_ticket	*ticket);
>  #if defined(DEBUG)
>  STATIC void
>  xlog_verify_dest_ptr(
> @@ -535,7 +536,8 @@ __xlog_state_release_iclog(
>  int
>  xlog_state_release_iclog(
>  	struct xlog		*log,
> -	struct xlog_in_core	*iclog)
> +	struct xlog_in_core	*iclog,
> +	struct xlog_ticket	*ticket)
>  {
>  	lockdep_assert_held(&log->l_icloglock);
>  
> @@ -545,7 +547,7 @@ xlog_state_release_iclog(
>  	if (atomic_dec_and_test(&iclog->ic_refcnt) &&
>  	    __xlog_state_release_iclog(log, iclog)) {
>  		spin_unlock(&log->l_icloglock);
> -		xlog_sync(log, iclog);
> +		xlog_sync(log, iclog, ticket);
>  		spin_lock(&log->l_icloglock);
>  	}
>  
> @@ -898,7 +900,7 @@ xlog_unmount_write(
>  	else
>  		ASSERT(iclog->ic_state == XLOG_STATE_WANT_SYNC ||
>  		       iclog->ic_state == XLOG_STATE_IOERROR);
> -	error = xlog_state_release_iclog(log, iclog);
> +	error = xlog_state_release_iclog(log, iclog, tic);
>  	xlog_wait_on_iclog(iclog);
>  
>  	if (tic) {
> @@ -1930,7 +1932,8 @@ xlog_calc_iclog_size(
>  STATIC void
>  xlog_sync(
>  	struct xlog		*log,
> -	struct xlog_in_core	*iclog)
> +	struct xlog_in_core	*iclog,
> +	struct xlog_ticket	*ticket)
>  {
>  	unsigned int		count;		/* byte count of bwrite */
>  	unsigned int		roundoff;       /* roundoff to BB or stripe */
> @@ -1941,12 +1944,20 @@ xlog_sync(
>  
>  	count = xlog_calc_iclog_size(log, iclog, &roundoff);
>  
> -	/* move grant heads by roundoff in sync */
> -	xlog_grant_add_space(log, &log->l_reserve_head.grant, roundoff);
> -	xlog_grant_add_space(log, &log->l_write_head.grant, roundoff);
> +	/*
> +	 * If we have a ticket, account for the roundoff via the ticket
> +	 * reservation to avoid touching the hot grant heads needlessly.
> +	 * Otherwise, we have to move grant heads directly.
> +	 */
> +	if (ticket) {
> +		ticket->t_curr_res -= roundoff;
> +	} else {
> +		xlog_grant_add_space(log, &log->l_reserve_head.grant, roundoff);
> +		xlog_grant_add_space(log, &log->l_write_head.grant, roundoff);
> +	}
>  
>  	/* put cycle number in every block */
> -	xlog_pack_data(log, iclog, roundoff); 
> +	xlog_pack_data(log, iclog, roundoff);
>  
>  	/* real byte length */
>  	size = iclog->ic_offset;
> @@ -2187,7 +2198,7 @@ xlog_write_get_more_iclog_space(
>  	xlog_state_finish_copy(log, iclog, *record_cnt, *data_cnt);
>  	ASSERT(iclog->ic_state == XLOG_STATE_WANT_SYNC ||
>  	       iclog->ic_state == XLOG_STATE_IOERROR);
> -	error = xlog_state_release_iclog(log, iclog);
> +	error = xlog_state_release_iclog(log, iclog, ticket);
>  	spin_unlock(&log->l_icloglock);
>  	if (error)
>  		return error;
> @@ -2470,7 +2481,7 @@ xlog_write(
>  		ASSERT(optype & XLOG_COMMIT_TRANS);
>  		*commit_iclog = iclog;
>  	} else {
> -		error = xlog_state_release_iclog(log, iclog);
> +		error = xlog_state_release_iclog(log, iclog, ticket);
>  	}
>  	spin_unlock(&log->l_icloglock);
>  
> @@ -2929,7 +2940,7 @@ xlog_state_get_iclog_space(
>  		 * reference to the iclog.
>  		 */
>  		if (!atomic_add_unless(&iclog->ic_refcnt, -1, 1))
> -			error = xlog_state_release_iclog(log, iclog);
> +			error = xlog_state_release_iclog(log, iclog, ticket);
>  		spin_unlock(&log->l_icloglock);
>  		if (error)
>  			return error;
> @@ -3157,7 +3168,7 @@ xfs_log_force(
>  			atomic_inc(&iclog->ic_refcnt);
>  			lsn = be64_to_cpu(iclog->ic_header.h_lsn);
>  			xlog_state_switch_iclogs(log, iclog, 0);
> -			if (xlog_state_release_iclog(log, iclog))
> +			if (xlog_state_release_iclog(log, iclog, NULL))
>  				goto out_error;
>  
>  			if (be64_to_cpu(iclog->ic_header.h_lsn) != lsn)
> @@ -3250,7 +3261,7 @@ xlog_force_lsn(
>  		}
>  		atomic_inc(&iclog->ic_refcnt);
>  		xlog_state_switch_iclogs(log, iclog, 0);
> -		if (xlog_state_release_iclog(log, iclog))
> +		if (xlog_state_release_iclog(log, iclog, NULL))
>  			goto out_error;
>  		if (log_flushed)
>  			*log_flushed = 1;
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index d60c72ad391a..aef60f19ab05 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -804,6 +804,7 @@ xlog_cil_push_work(
>  	int			cpu;
>  	struct xlog_cil_pcp	*cilpcp;
>  	LIST_HEAD		(log_items);
> +	struct xlog_ticket	*ticket;
>  
>  	new_ctx = xlog_cil_ctx_alloc();
>  	new_ctx->ticket = xlog_cil_ticket_alloc(log);
> @@ -1037,12 +1038,10 @@ xlog_cil_push_work(
>  	if (error)
>  		goto out_abort_free_ticket;
>  
> -	xfs_log_ticket_ungrant(log, ctx->ticket);
> -
>  	spin_lock(&commit_iclog->ic_callback_lock);
>  	if (commit_iclog->ic_state == XLOG_STATE_IOERROR) {
>  		spin_unlock(&commit_iclog->ic_callback_lock);
> -		goto out_abort;
> +		goto out_abort_free_ticket;
>  	}
>  	ASSERT_ALWAYS(commit_iclog->ic_state == XLOG_STATE_ACTIVE ||
>  		      commit_iclog->ic_state == XLOG_STATE_WANT_SYNC);
> @@ -1073,12 +1072,23 @@ xlog_cil_push_work(
>  		commit_iclog->ic_flags &= ~XLOG_ICL_NEED_FLUSH;
>  	}
>  
> +	/*
> +	 * Pull the ticket off the ctx so we can ungrant it after releasing the
> +	 * commit_iclog. The ctx may be freed by the time we return from
> +	 * releasing the commit_iclog (i.e. checkpoint has been completed and
> +	 * callback run) so we can't reference the ctx after the call to
> +	 * xlog_state_release_iclog().
> +	 */
> +	ticket = ctx->ticket;
> +
>  	/* release the hounds! */
>  	spin_lock(&log->l_icloglock);
>  	if (commit_iclog_sync && commit_iclog->ic_state == XLOG_STATE_ACTIVE)
>  		xlog_state_switch_iclogs(log, commit_iclog, 0);
> -	xlog_state_release_iclog(log, commit_iclog);
> +	xlog_state_release_iclog(log, commit_iclog, ticket);
>  	spin_unlock(&log->l_icloglock);
> +
> +	xfs_log_ticket_ungrant(log, ticket);
>  	return;
>  
>  out_skip:
> @@ -1089,7 +1099,6 @@ xlog_cil_push_work(
>  
>  out_abort_free_ticket:
>  	xfs_log_ticket_ungrant(log, ctx->ticket);
> -out_abort:
>  	ASSERT(XLOG_FORCED_SHUTDOWN(log));
>  	xlog_cil_committed(ctx);
>  }
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index 6a4160200417..3d43d3940757 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -487,7 +487,8 @@ int	xlog_commit_record(struct xlog *log, struct xlog_ticket *ticket,
>  		struct xlog_in_core **iclog, xfs_lsn_t *lsn);
>  void	xlog_state_switch_iclogs(struct xlog *log, struct xlog_in_core *iclog,
>  		int eventual_size);
> -int	xlog_state_release_iclog(struct xlog *xlog, struct xlog_in_core *iclog);
> +int	xlog_state_release_iclog(struct xlog *xlog, struct xlog_in_core *iclog,
> +		struct xlog_ticket *ticket);
>  
>  void	xfs_log_ticket_ungrant(struct xlog *log, struct xlog_ticket *ticket);
>  void	xfs_log_ticket_regrant(struct xlog *log, struct xlog_ticket *ticket);
> -- 
> 2.28.0
> 
