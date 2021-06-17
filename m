Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,TVD_PH_BODY_ACCOUNTS_PRE
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 312AEC2B9F4
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Jun 2021 20:24:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C38C613D8
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Jun 2021 20:24:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230299AbhFQU0L (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Jun 2021 16:26:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:60816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230137AbhFQU0L (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 17 Jun 2021 16:26:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EFBEB6044F;
        Thu, 17 Jun 2021 20:24:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623961443;
        bh=4GIvxOBO/riUGieJZeQjdY6jKBQEmVsRbWr+8ZW5gRI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OLVwSE04nSoeWOhekbq9TmeYV3TF+wmW3s31e86XACsYcRc2bdCb40rv7+kvVu33R
         Bg0gHuqSkMbNchhdK+V2qF1xSrVNcgmitc18pjuHEnIb6zCzqjM3KifI0aaUW38UFk
         gEpFXOaH+a2SwdweI6J3XQUZDewj8tGmD5gCcT3jLueoEaZ/4c8CoDNv8VtfUKOVvV
         HuIpXIhTM9lmDrZEwb128+glNvEpTyB3osW0/sxedNTglvpqsS8N7QubYT4bBQ9245
         5kbgx/vHGEZMP7l5DiyJEEE3ru7fJrJywOHbzy5efcnSa8vG8P/HIOTFC4Dg6tBPao
         ucFJLHx9f1iFA==
Date:   Thu, 17 Jun 2021 13:24:02 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/8] xfs: pass a CIL context to xlog_write()
Message-ID: <20210617202402.GX158209@locust>
References: <20210617082617.971602-1-david@fromorbit.com>
 <20210617082617.971602-5-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210617082617.971602-5-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 17, 2021 at 06:26:13PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Pass the CIL context to xlog_write() rather than a pointer to a LSN
> variable. Only the CIL checkpoint calls to xlog_write() need to know
> about the start LSN of the writes, so rework xlog_write to directly
> write the LSNs into the CIL context structure.
> 
> This removes the commit_lsn variable from xlog_cil_push_work(), so
> now we only have to issue the commit record ordering wakeup from
> there.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_log.c      | 22 +++++++++++++++++-----
>  fs/xfs/xfs_log_cil.c  | 19 ++++++++-----------
>  fs/xfs/xfs_log_priv.h |  4 ++--
>  3 files changed, 27 insertions(+), 18 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index cf661c155786..fc0e43c57683 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -871,7 +871,7 @@ xlog_write_unmount_record(
>  	 */
>  	if (log->l_targ != log->l_mp->m_ddev_targp)
>  		blkdev_issue_flush(log->l_targ->bt_bdev);
> -	return xlog_write(log, &lv_chain, ticket, NULL, NULL, reg.i_len);
> +	return xlog_write(log, NULL, &lv_chain, ticket, NULL, reg.i_len);
>  }
>  
>  /*
> @@ -2383,9 +2383,9 @@ xlog_write_partial(
>  int
>  xlog_write(
>  	struct xlog		*log,
> +	struct xfs_cil_ctx	*ctx,
>  	struct list_head	*lv_chain,
>  	struct xlog_ticket	*ticket,
> -	xfs_lsn_t		*start_lsn,
>  	struct xlog_in_core	**commit_iclog,
>  	uint32_t		len)
>  {
> @@ -2408,9 +2408,21 @@ xlog_write(
>  	if (error)
>  		return error;
>  
> -	/* start_lsn is the LSN of the first iclog written to. */
> -	if (start_lsn)
> -		*start_lsn = be64_to_cpu(iclog->ic_header.h_lsn);
> +	/*
> +	 * If we have a CIL context, record the LSN of the iclog we were just
> +	 * granted space to start writing into. If the context doesn't have
> +	 * a start_lsn recorded, then this iclog will contain the start record
> +	 * for the checkpoint. Otherwise this write contains the commit record
> +	 * for the checkpoint.
> +	 */
> +	if (ctx) {
> +		spin_lock(&ctx->cil->xc_push_lock);
> +		if (!ctx->start_lsn)
> +			ctx->start_lsn = be64_to_cpu(iclog->ic_header.h_lsn);
> +		else
> +			ctx->commit_lsn = be64_to_cpu(iclog->ic_header.h_lsn);
> +		spin_unlock(&ctx->cil->xc_push_lock);

This cycling of the push lock when setting start_lsn is new.  What are
we protecting against here by taking the lock?

Also, just to check my assumptions: why do we take the push lock when
setting commit_lsn?  Is that to synchronize with the xc_committing loop
that looks for contexts that need pushing?

--D

> +	}
>  
>  	lv = list_first_entry_or_null(lv_chain, struct xfs_log_vec, lv_list);
>  	while (lv) {
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index 2c8b25888c53..35fc3e57d870 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -790,14 +790,13 @@ xlog_cil_build_trans_hdr(
>   */
>  int
>  xlog_cil_write_commit_record(
> -	struct xlog		*log,
> -	struct xlog_ticket	*ticket,
> -	struct xlog_in_core	**iclog,
> -	xfs_lsn_t		*lsn)
> +	struct xfs_cil_ctx	*ctx,
> +	struct xlog_in_core	**iclog)
>  {
> +	struct xlog		*log = ctx->cil->xc_log;
>  	struct xlog_op_header	ophdr = {
>  		.oh_clientid = XFS_TRANSACTION,
> -		.oh_tid = cpu_to_be32(ticket->t_tid),
> +		.oh_tid = cpu_to_be32(ctx->ticket->t_tid),
>  		.oh_flags = XLOG_COMMIT_TRANS,
>  	};
>  	struct xfs_log_iovec reg = {
> @@ -818,8 +817,8 @@ xlog_cil_write_commit_record(
>  		return -EIO;
>  
>  	/* account for space used by record data */
> -	ticket->t_curr_res -= reg.i_len;
> -	error = xlog_write(log, &lv_chain, ticket, lsn, iclog, reg.i_len);
> +	ctx->ticket->t_curr_res -= reg.i_len;
> +	error = xlog_write(log, ctx, &lv_chain, ctx->ticket, iclog, reg.i_len);
>  	if (error)
>  		xfs_force_shutdown(log->l_mp, SHUTDOWN_LOG_IO_ERROR);
>  	return error;
> @@ -1038,7 +1037,7 @@ xlog_cil_push_work(
>  	 * use the commit record lsn then we can move the tail beyond the grant
>  	 * write head.
>  	 */
> -	error = xlog_write(log, &ctx->lv_chain, ctx->ticket, &ctx->start_lsn,
> +	error = xlog_write(log, ctx, &ctx->lv_chain, ctx->ticket,
>  				NULL, num_bytes);
>  
>  	/*
> @@ -1083,8 +1082,7 @@ xlog_cil_push_work(
>  	}
>  	spin_unlock(&cil->xc_push_lock);
>  
> -	error = xlog_cil_write_commit_record(log, ctx->ticket, &commit_iclog,
> -			&commit_lsn);
> +	error = xlog_cil_write_commit_record(ctx, &commit_iclog);
>  	if (error)
>  		goto out_abort_free_ticket;
>  
> @@ -1104,7 +1102,6 @@ xlog_cil_push_work(
>  	 * and wake up anyone who is waiting for the commit to complete.
>  	 */
>  	spin_lock(&cil->xc_push_lock);
> -	ctx->commit_lsn = commit_lsn;
>  	wake_up_all(&cil->xc_commit_wait);
>  	spin_unlock(&cil->xc_push_lock);
>  
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index 26f26769d1c6..af8a9dfa8068 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -487,8 +487,8 @@ xlog_write_adv_cnt(void **ptr, int *len, int *off, size_t bytes)
>  
>  void	xlog_print_tic_res(struct xfs_mount *mp, struct xlog_ticket *ticket);
>  void	xlog_print_trans(struct xfs_trans *);
> -int	xlog_write(struct xlog *log, struct list_head *lv_chain,
> -		struct xlog_ticket *tic, xfs_lsn_t *start_lsn,
> +int	xlog_write(struct xlog *log, struct xfs_cil_ctx *ctx,
> +		struct list_head *lv_chain, struct xlog_ticket *tic,
>  		struct xlog_in_core **commit_iclog, uint32_t len);
>  
>  void	xfs_log_ticket_ungrant(struct xlog *log, struct xlog_ticket *ticket);
> -- 
> 2.31.1
> 
