Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 811EBC433E0
	for <linux-xfs@archiver.kernel.org>; Mon,  8 Mar 2021 23:48:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3FBFA6527E
	for <linux-xfs@archiver.kernel.org>; Mon,  8 Mar 2021 23:48:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229821AbhCHXr5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 8 Mar 2021 18:47:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:41414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229627AbhCHXre (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 8 Mar 2021 18:47:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0057F6527D;
        Mon,  8 Mar 2021 23:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615247254;
        bh=Aujo0UGrdBq75HsQ46oNmt30tpoNhYoql52wtJpLtfY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BdhBxwwpLUiHw7adX42OrPnlasQ+D45CBtSEasoc5LRXd71+D5PQCjgSNLuYH+9Dl
         D/Dl9qVj/IQ43N3WVygr8mafbIZLQZyN/qV59wfuQizF8HItlJxm8ZBW6RQ3ho6OpQ
         IsokQ8XlO6m1rPmnedSy/YE3T+mNcDkfmsXkHpNCsGyVnRllMDXcpdvDAgtciC0FBq
         VLzWPF6aGQDt/baiU2BcfdBA1OaGX7sGCu7PNrABiP/npEf6vW81AKuaGqtm1G9Fi7
         WeJhdTfmt31trxlstm3wxg6WgUNWwjnryo0MtURDOww1dD/+V1gIS+QfqtiiiYwnJs
         xWGve5WhRZB8g==
Date:   Mon, 8 Mar 2021 15:47:33 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 19/45] xfs: factor out the CIL transaction header building
Message-ID: <20210308234733.GF3419940@magnolia>
References: <20210305051143.182133-1-david@fromorbit.com>
 <20210305051143.182133-20-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210305051143.182133-20-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 05, 2021 at 04:11:17PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> It is static code deep in the middle of the CIL push logic. Factor
> it out into a helper so that it is clear and easy to modify
> separately.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Looks straightforward,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_log_cil.c | 71 +++++++++++++++++++++++++++++---------------
>  1 file changed, 47 insertions(+), 24 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index dfc9ef692a80..b515002e7959 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -651,6 +651,41 @@ xlog_cil_process_committed(
>  	}
>  }
>  
> +struct xlog_cil_trans_hdr {
> +	struct xfs_trans_header	thdr;
> +	struct xfs_log_iovec	lhdr;
> +};
> +
> +/*
> + * Build a checkpoint transaction header to begin the journal transaction.  We
> + * need to account for the space used by the transaction header here as it is
> + * not accounted for in xlog_write().
> + */
> +static void
> +xlog_cil_build_trans_hdr(
> +	struct xfs_cil_ctx	*ctx,
> +	struct xlog_cil_trans_hdr *hdr,
> +	struct xfs_log_vec	*lvhdr,
> +	int			num_iovecs)
> +{
> +	struct xlog_ticket	*tic = ctx->ticket;
> +
> +	memset(hdr, 0, sizeof(*hdr));
> +
> +	hdr->thdr.th_magic = XFS_TRANS_HEADER_MAGIC;
> +	hdr->thdr.th_type = XFS_TRANS_CHECKPOINT;
> +	hdr->thdr.th_tid = tic->t_tid;
> +	hdr->thdr.th_num_items = num_iovecs;
> +	hdr->lhdr.i_addr = &hdr->thdr;
> +	hdr->lhdr.i_len = sizeof(xfs_trans_header_t);
> +	hdr->lhdr.i_type = XLOG_REG_TYPE_TRANSHDR;
> +	tic->t_curr_res -= hdr->lhdr.i_len + sizeof(xlog_op_header_t);
> +
> +	lvhdr->lv_niovecs = 1;
> +	lvhdr->lv_iovecp = &hdr->lhdr;
> +	lvhdr->lv_next = ctx->lv_chain;
> +}
> +
>  /*
>   * Push the Committed Item List to the log.
>   *
> @@ -676,11 +711,9 @@ xlog_cil_push_work(
>  	struct xfs_log_vec	*lv;
>  	struct xfs_cil_ctx	*new_ctx;
>  	struct xlog_in_core	*commit_iclog;
> -	struct xlog_ticket	*tic;
>  	int			num_iovecs;
>  	int			error = 0;
> -	struct xfs_trans_header thdr;
> -	struct xfs_log_iovec	lhdr;
> +	struct xlog_cil_trans_hdr thdr;
>  	struct xfs_log_vec	lvhdr = { NULL };
>  	xfs_lsn_t		commit_lsn;
>  	xfs_lsn_t		push_seq;
> @@ -827,24 +860,8 @@ xlog_cil_push_work(
>  	 * Build a checkpoint transaction header and write it to the log to
>  	 * begin the transaction. We need to account for the space used by the
>  	 * transaction header here as it is not accounted for in xlog_write().
> -	 *
> -	 * The LSN we need to pass to the log items on transaction commit is
> -	 * the LSN reported by the first log vector write. If we use the commit
> -	 * record lsn then we can move the tail beyond the grant write head.
>  	 */
> -	tic = ctx->ticket;
> -	thdr.th_magic = XFS_TRANS_HEADER_MAGIC;
> -	thdr.th_type = XFS_TRANS_CHECKPOINT;
> -	thdr.th_tid = tic->t_tid;
> -	thdr.th_num_items = num_iovecs;
> -	lhdr.i_addr = &thdr;
> -	lhdr.i_len = sizeof(xfs_trans_header_t);
> -	lhdr.i_type = XLOG_REG_TYPE_TRANSHDR;
> -	tic->t_curr_res -= lhdr.i_len + sizeof(xlog_op_header_t);
> -
> -	lvhdr.lv_niovecs = 1;
> -	lvhdr.lv_iovecp = &lhdr;
> -	lvhdr.lv_next = ctx->lv_chain;
> +	xlog_cil_build_trans_hdr(ctx, &thdr, &lvhdr, num_iovecs);
>  
>  	/*
>  	 * Before we format and submit the first iclog, we have to ensure that
> @@ -852,7 +869,13 @@ xlog_cil_push_work(
>  	 */
>  	wait_for_completion(&bdev_flush);
>  
> -	error = xlog_write(log, &lvhdr, tic, &ctx->start_lsn, NULL,
> +	/*
> +	 * The LSN we need to pass to the log items on transaction commit is the
> +	 * LSN reported by the first log vector write, not the commit lsn. If we
> +	 * use the commit record lsn then we can move the tail beyond the grant
> +	 * write head.
> +	 */
> +	error = xlog_write(log, &lvhdr, ctx->ticket, &ctx->start_lsn, NULL,
>  				XLOG_START_TRANS);
>  	if (error)
>  		goto out_abort_free_ticket;
> @@ -891,11 +914,11 @@ xlog_cil_push_work(
>  	}
>  	spin_unlock(&cil->xc_push_lock);
>  
> -	error = xlog_commit_record(log, tic, &commit_iclog, &commit_lsn);
> +	error = xlog_commit_record(log, ctx->ticket, &commit_iclog, &commit_lsn);
>  	if (error)
>  		goto out_abort_free_ticket;
>  
> -	xfs_log_ticket_ungrant(log, tic);
> +	xfs_log_ticket_ungrant(log, ctx->ticket);
>  
>  	spin_lock(&commit_iclog->ic_callback_lock);
>  	if (commit_iclog->ic_state == XLOG_STATE_IOERROR) {
> @@ -946,7 +969,7 @@ xlog_cil_push_work(
>  	return;
>  
>  out_abort_free_ticket:
> -	xfs_log_ticket_ungrant(log, tic);
> +	xfs_log_ticket_ungrant(log, ctx->ticket);
>  out_abort:
>  	ASSERT(XLOG_FORCED_SHUTDOWN(log));
>  	xlog_cil_committed(ctx);
> -- 
> 2.28.0
> 
