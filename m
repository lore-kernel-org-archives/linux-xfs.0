Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 261A9C2B9F4
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Jun 2021 21:31:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 06AF761040
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Jun 2021 21:31:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230321AbhFQVdw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Jun 2021 17:33:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:46814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230039AbhFQVdv (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 17 Jun 2021 17:33:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A437E61040;
        Thu, 17 Jun 2021 21:31:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623965503;
        bh=YrOqB49a2ZmoWSwlZkHQ4Eg+EB13hiP0Kl+5iJI2O6M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=B9dUxLygEEgVJhhKueNIKPHDXo/yhryyBSWQDp4Wql7UWdIbWYuXcR2yQfcEcuy0u
         Hr9soQz5nuZajqpvZlsfn5EgcGoa2/4q6RNI3uQaaNpMPW4rH+9D8wzC9A09YMcRNY
         j/SezdmejIkJWiiz1LoPKWTxOXVVhIGNcWnAPHbSDhNbt9AbLeUjfGpsKMYEev8K6F
         3w1IW1/158+IjsX0Cv8bwdVGLzcaQ8bHc9UyzkWVnPij7GmrkCocRLSnquBBII0OwL
         c/fWzJ3f77jc6M4zzbx+AlH9yEykC7Gywfd4eIkVR4B1DW0s+pQ5Ihz/b/E0okMpvw
         FdQv49Yp0xrTg==
Date:   Thu, 17 Jun 2021 14:31:43 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 8/8] xfs: order CIL checkpoint start records
Message-ID: <20210617213143.GF158232@locust>
References: <20210617082617.971602-1-david@fromorbit.com>
 <20210617082617.971602-9-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210617082617.971602-9-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 17, 2021 at 06:26:17PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Because log recovery depends on strictly ordered start records as
> well as strictly ordered commit records.
> 
> This is a zero day bug in the way XFS writes pipelined transactions
> to the journal which is exposed by commit facd77e4e38b ("xfs: CIL
> work is serialised, not pipelined") which re-introduces explicit
> concurrent commits back into the on-disk journal.
> 
> The XFS journal commit code has never ordered start records and we
> have relied on strict commit record ordering for correct recovery
> ordering of concurrently written transactions. Unfortunately, root
> cause analysis uncovered the fact that log recovery uses the LSN of
> the start record for transaction commit processing. Hence the
> commits are processed in strict orderi by recovery, but the LSNs

s/orderi/order/ ?

> associated with the commits can be out of order and so recovery may
> stamp incorrect LSNs into objects and/or misorder intents in the AIL
> for later processing. This can result in log recovery failures
> and/or on disk corruption, sometimes silent.
> 
> Because this is a long standing log recovery issue, we can't just
> fix log recovery and call it good.

Could there be production filesystems out there that have this
mismatched ordering of start lsn and commit lsn?  This still leaves the
mystery of crashed customer filesystems containing btree blocks where
128 bytes in the middle clearly contain contents that are don't match or
duplicate the rest of the block, as though someone forgot to replay a
buffer vector or something.

What would a fix to log recovery entail?  Not skipping recovered items
if the start/commit sequencing is not the same?  Or am I not
understanding the problem correctly?

> This still leaves older kernels
> susceptible to recovery failures and corruption when replaying a log
> from a kernel that pipelines checkpoints.

> There is also the issue
> that in-memory ordering for AIL pushing and data integrity
> operations are based on checkpoint start LSNs, and if the start LSN
> is incorrect in the journal, it is also incorrect in memory.
> 
> Hence there's really only one choice for fixing this zero-day bug:
> we need to strictly order checkpoint start records in ascending
> sequence order in the log, the same way we already strictly order
> commit records.
> 
> Fixes: facd77e4e38b ("xfs: CIL work is serialised, not pipelined")
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_log.c      |   1 +
>  fs/xfs/xfs_log_cil.c  | 101 +++++++++++++++++++++++++++++-------------
>  fs/xfs/xfs_log_priv.h |   1 +
>  3 files changed, 71 insertions(+), 32 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 359246d54db7..94b6bccb9de9 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -3743,6 +3743,7 @@ xfs_log_force_umount(
>  	 * avoid races.
>  	 */
>  	spin_lock(&log->l_cilp->xc_push_lock);
> +	wake_up_all(&log->l_cilp->xc_start_wait);
>  	wake_up_all(&log->l_cilp->xc_commit_wait);
>  	spin_unlock(&log->l_cilp->xc_push_lock);
>  	xlog_state_do_callback(log);
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index 87e30917ce2e..722c21f21b81 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -684,6 +684,7 @@ xlog_cil_committed(
>  	 */
>  	if (abort) {
>  		spin_lock(&ctx->cil->xc_push_lock);
> +		wake_up_all(&ctx->cil->xc_start_wait);
>  		wake_up_all(&ctx->cil->xc_commit_wait);
>  		spin_unlock(&ctx->cil->xc_push_lock);
>  	}
> @@ -788,6 +789,10 @@ xlog_cil_build_trans_hdr(
>   * If the context doesn't have a start_lsn recorded, then this iclog will
>   * contain the start record for the checkpoint. Otherwise this write contains
>   * the commit record for the checkpoint.
> + *
> + * Once we've set the LSN for the given operation, wake up any ordered write
> + * waiters that can make progress now that we have a stable LSN for write
> + * ordering purposes.
>   */
>  void
>  xlog_cil_set_ctx_write_state(
> @@ -798,9 +803,16 @@ xlog_cil_set_ctx_write_state(
>  	xfs_lsn_t		lsn = be64_to_cpu(iclog->ic_header.h_lsn);
>  
>  	ASSERT(!ctx->commit_lsn);
> -	spin_lock(&cil->xc_push_lock);
>  	if (!ctx->start_lsn) {
> +		spin_lock(&cil->xc_push_lock);
> +		/*
> +		 * The LSN we need to pass to the log items on transaction
> +		 * commit is the LSN reported by the first log vector write, not
> +		 * the commit lsn. If we use the commit record lsn then we can
> +		 * move the tail beyond the grant write head.
> +		 */
>  		ctx->start_lsn = lsn;
> +		wake_up_all(&cil->xc_start_wait);
>  		spin_unlock(&cil->xc_push_lock);
>  		return;
>  	}
> @@ -811,9 +823,6 @@ xlog_cil_set_ctx_write_state(
>  	 * context controls when the iclog is released for IO.
>  	 */
>  	atomic_inc(&iclog->ic_refcnt);
> -	ctx->commit_iclog = iclog;
> -	ctx->commit_lsn = lsn;
> -	spin_unlock(&cil->xc_push_lock);
>  
>  	/*
>  	 * xlog_state_get_iclog_space() guarantees there is enough space in the
> @@ -827,6 +836,12 @@ xlog_cil_set_ctx_write_state(
>  	}
>  	list_add_tail(&ctx->iclog_entry, &iclog->ic_callbacks);
>  	spin_unlock(&iclog->ic_callback_lock);
> +
> +	spin_lock(&cil->xc_push_lock);
> +	ctx->commit_iclog = iclog;
> +	ctx->commit_lsn = lsn;
> +	wake_up_all(&cil->xc_commit_wait);
> +	spin_unlock(&cil->xc_push_lock);
>  }
>  
>  /*
> @@ -834,10 +849,16 @@ xlog_cil_set_ctx_write_state(
>   * relies on the context LSN being zero until the log write has guaranteed the
>   * LSN that the log write will start at via xlog_state_get_iclog_space().
>   */
> +enum {
> +	_START_RECORD,
> +	_COMMIT_RECORD,
> +};

Stupid nit: If this enum had a name you could skip the default clause
below because the compiler would typecheck the usage for you.

I think I grok how the code changes introduce a new ordering
requirement, at least.

--D

> +
>  static int
>  xlog_cil_order_write(
>  	struct xfs_cil		*cil,
> -	xfs_csn_t		sequence)
> +	xfs_csn_t		sequence,
> +	int			record)
>  {
>  	struct xfs_cil_ctx	*ctx;
>  
> @@ -860,19 +881,50 @@ xlog_cil_order_write(
>  		 */
>  		if (ctx->sequence >= sequence)
>  			continue;
> -		if (!ctx->commit_lsn) {
> -			/*
> -			 * It is still being pushed! Wait for the push to
> -			 * complete, then start again from the beginning.
> -			 */
> -			xlog_wait(&cil->xc_commit_wait, &cil->xc_push_lock);
> -			goto restart;
> +
> +		/* Wait until the LSN for the record has been recorded. */
> +		switch (record) {
> +		case _START_RECORD:
> +			if (!ctx->start_lsn) {
> +				xlog_wait(&cil->xc_start_wait, &cil->xc_push_lock);
> +				goto restart;
> +			}
> +			break;
> +		case _COMMIT_RECORD:
> +			if (!ctx->commit_lsn) {
> +				xlog_wait(&cil->xc_commit_wait, &cil->xc_push_lock);
> +				goto restart;
> +			}
> +			break;
> +		default:
> +			ASSERT(0);
> +			break;
>  		}
>  	}
>  	spin_unlock(&cil->xc_push_lock);
>  	return 0;
>  }
>  
> +/*
> + * Write out the log vector change now attached to the CIL context. This will
> + * write a start record that needs to be strictly ordered in ascending CIL
> + * sequence order so that log recovery will always use in-order start LSNs when
> + * replaying checkpoints.
> + */
> +static int
> +xlog_cil_write_chain(
> +	struct xfs_cil_ctx	*ctx,
> +	uint32_t		num_bytes)
> +{
> +	struct xlog		*log = ctx->cil->xc_log;
> +	int			error;
> +
> +	error = xlog_cil_order_write(ctx->cil, ctx->sequence, _START_RECORD);
> +	if (error)
> +		return error;
> +	return xlog_write(log, ctx, &ctx->lv_chain, ctx->ticket, num_bytes);
> +}
> +
>  /*
>   * Write out the commit record of a checkpoint transaction to close off a
>   * running log write. These commit records are strictly ordered in ascending CIL
> @@ -906,7 +958,7 @@ xlog_cil_write_commit_record(
>  	if (XLOG_FORCED_SHUTDOWN(log))
>  		return -EIO;
>  
> -	error = xlog_cil_order_write(ctx->cil, ctx->sequence);
> +	error = xlog_cil_order_write(ctx->cil, ctx->sequence, _COMMIT_RECORD);
>  	if (error)
>  		return error;
>  
> @@ -1125,17 +1177,10 @@ xlog_cil_push_work(
>  	wait_for_completion(&bdev_flush);
>  
>  	/*
> -	 * The LSN we need to pass to the log items on transaction commit is the
> -	 * LSN reported by the first log vector write, not the commit lsn. If we
> -	 * use the commit record lsn then we can move the tail beyond the grant
> -	 * write head.
> -	 */
> -	error = xlog_write(log, ctx, &ctx->lv_chain, ctx->ticket, num_bytes);
> -
> -	/*
> -	 * Take the lvhdr back off the lv_chain as it should not be passed
> -	 * to log IO completion.
> +	 * Once we write the log vector chain, take the lvhdr back off it as it
> +	 * must not be passed to log IO completion.
>  	 */
> +	error = xlog_cil_write_chain(ctx, num_bytes);
>  	list_del(&lvhdr.lv_list);
>  	if (error)
>  		goto out_abort_free_ticket;
> @@ -1144,15 +1189,6 @@ xlog_cil_push_work(
>  	if (error)
>  		goto out_abort_free_ticket;
>  
> -	/*
> -	 * now the checkpoint commit is complete and we've attached the
> -	 * callbacks to the iclog we can assign the commit LSN to the context
> -	 * and wake up anyone who is waiting for the commit to complete.
> -	 */
> -	spin_lock(&cil->xc_push_lock);
> -	wake_up_all(&cil->xc_commit_wait);
> -	spin_unlock(&cil->xc_push_lock);
> -
>  	/*
>  	 * Pull the ticket off the ctx so we can ungrant it after releasing the
>  	 * commit_iclog. The ctx may be freed by the time we return from
> @@ -1728,6 +1764,7 @@ xlog_cil_init(
>  	init_waitqueue_head(&cil->xc_push_wait);
>  	init_rwsem(&cil->xc_ctx_lock);
>  	init_waitqueue_head(&cil->xc_commit_wait);
> +	init_waitqueue_head(&cil->xc_start_wait);
>  	log->l_cilp = cil;
>  
>  	ctx = xlog_cil_ctx_alloc();
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index 72dfa3b89513..b807a179b916 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -279,6 +279,7 @@ struct xfs_cil {
>  	bool			xc_push_commit_stable;
>  	struct list_head	xc_committing;
>  	wait_queue_head_t	xc_commit_wait;
> +	wait_queue_head_t	xc_start_wait;
>  	xfs_csn_t		xc_current_sequence;
>  	wait_queue_head_t	xc_push_wait;	/* background push throttle */
>  
> -- 
> 2.31.1
> 
