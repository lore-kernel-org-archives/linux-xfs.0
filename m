Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05F3EC2B9F4
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Jun 2021 20:28:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CAF78613D8
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Jun 2021 20:28:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231668AbhFQUad (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Jun 2021 16:30:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:33736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231282AbhFQUad (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 17 Jun 2021 16:30:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 026A3610CA;
        Thu, 17 Jun 2021 20:28:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623961705;
        bh=hBJHF6YtF6759Km1dpdFqJEoi9qxsJeU6gHoQM4W2vI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TV/7Uefp7BWggda5WB1MyKBfmqjTcNftbt8iXv6gJxlOhrd3ZmtU9ZwQ/xm3eJar+
         NqRqSyS8cLxaSlmRsF8LTofehdxZiYEAZ7Th4dNyXSZjtB7eydgoduUQEIGMOYZxU7
         o9yh8O/+EyX46hvdmUhf58jJJbKO8oZlcMm3sQ3jjDAZOPSLLYO2JUdRIxgSOmXM0E
         Zjq7Kr7YE4YqFEkDyBieeH+XI17UGD9HGBE8/o9SzaZw5qc6eNvShmCjNR40X6uN9h
         fFJVVtfDOotYplJzm/a+U/yA81Z0o4+StyDV0MlRSpEE6T2rqy24rxNJBLY4lQeNgN
         wUl71/GtAHtjA==
Date:   Thu, 17 Jun 2021 13:28:24 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/8] xfs: separate out setting CIL context LSNs from
 xlog_write
Message-ID: <20210617202824.GZ158209@locust>
References: <20210617082617.971602-1-david@fromorbit.com>
 <20210617082617.971602-7-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210617082617.971602-7-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 17, 2021 at 06:26:15PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> In preparation for moving more CIL context specific functionality
> into these operations.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks fine as a hoist, though I wonder why you didn't do this in patch
4?

--D

> ---
>  fs/xfs/xfs_log.c      | 17 ++---------------
>  fs/xfs/xfs_log_cil.c  | 23 +++++++++++++++++++++++
>  fs/xfs/xfs_log_priv.h |  2 ++
>  3 files changed, 27 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index fc0e43c57683..1c214b395223 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -2408,21 +2408,8 @@ xlog_write(
>  	if (error)
>  		return error;
>  
> -	/*
> -	 * If we have a CIL context, record the LSN of the iclog we were just
> -	 * granted space to start writing into. If the context doesn't have
> -	 * a start_lsn recorded, then this iclog will contain the start record
> -	 * for the checkpoint. Otherwise this write contains the commit record
> -	 * for the checkpoint.
> -	 */
> -	if (ctx) {
> -		spin_lock(&ctx->cil->xc_push_lock);
> -		if (!ctx->start_lsn)
> -			ctx->start_lsn = be64_to_cpu(iclog->ic_header.h_lsn);
> -		else
> -			ctx->commit_lsn = be64_to_cpu(iclog->ic_header.h_lsn);
> -		spin_unlock(&ctx->cil->xc_push_lock);
> -	}
> +	if (ctx)
> +		xlog_cil_set_ctx_write_state(ctx, iclog);
>  
>  	lv = list_first_entry_or_null(lv_chain, struct xfs_log_vec, lv_list);
>  	while (lv) {
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index f993ec69fc97..2d8d904ffb78 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -783,6 +783,29 @@ xlog_cil_build_trans_hdr(
>  	tic->t_curr_res -= lvhdr->lv_bytes;
>  }
>  
> +/*
> + * Record the LSN of the iclog we were just granted space to start writing into.
> + * If the context doesn't have a start_lsn recorded, then this iclog will
> + * contain the start record for the checkpoint. Otherwise this write contains
> + * the commit record for the checkpoint.
> + */
> +void
> +xlog_cil_set_ctx_write_state(
> +	struct xfs_cil_ctx	*ctx,
> +	struct xlog_in_core	*iclog)
> +{
> +	struct xfs_cil		*cil = ctx->cil;
> +	xfs_lsn_t		lsn = be64_to_cpu(iclog->ic_header.h_lsn);
> +
> +	ASSERT(!ctx->commit_lsn);
> +	spin_lock(&cil->xc_push_lock);
> +	if (!ctx->start_lsn)
> +		ctx->start_lsn = lsn;
> +	else
> +		ctx->commit_lsn = lsn;
> +	spin_unlock(&cil->xc_push_lock);
> +}
> +
>  /*
>   * Ensure that the order of log writes follows checkpoint sequence order. This
>   * relies on the context LSN being zero until the log write has guaranteed the
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index af8a9dfa8068..849ba2eb3483 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -563,6 +563,8 @@ void	xlog_cil_destroy(struct xlog *log);
>  bool	xlog_cil_empty(struct xlog *log);
>  void	xlog_cil_commit(struct xlog *log, struct xfs_trans *tp,
>  			xfs_csn_t *commit_seq, bool regrant);
> +void	xlog_cil_set_ctx_write_state(struct xfs_cil_ctx *ctx,
> +			struct xlog_in_core *iclog);
>  
>  /*
>   * CIL force routines
> -- 
> 2.31.1
> 
