Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,TVD_PH_BODY_ACCOUNTS_PRE
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39D24C49EA2
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Jun 2021 19:59:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F1CE613EC
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Jun 2021 19:59:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230377AbhFQUBN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Jun 2021 16:01:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:56304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229816AbhFQUBN (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 17 Jun 2021 16:01:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0E4C261040;
        Thu, 17 Jun 2021 19:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623959945;
        bh=cccM2AbL0peF+eYcnXfgBHRxAqdQuVrykimuynwC3yA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ax/G7XLmycY+se2O4juDC3UsjHOSpqHCrvpyfhnWRBJ2lewWRrp9xdTb+Lvx3xUFT
         Kq+2ZSHelNTETQyQEHkV2EEhBMWD0gET5LG2uVEnNrRC3vtK5K8P/vQrh6WnNJYO2Y
         skEjklHVuxmNiSfyg0sdCZ37qjzWRv2aMljFFl5exb3Px3UAg34h8WD1numW7HjB5U
         okKbgowAGRIO8/ai8KKQYsNV1sSCqJM8eQ9A20GWTbsiUg+WyRFsZvWj3SRIjwAUKl
         riNFBRdKA5fVKF3vn9uDAAqpo62ytqVeVJr0V8afcOwSIpVxoONqGWhBEiKnLM2eHT
         5bxENmMJmiBFw==
Date:   Thu, 17 Jun 2021 12:59:04 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/8] xfs: factor out log write ordering from
 xlog_cil_push_work()
Message-ID: <20210617195904.GW158209@locust>
References: <20210617082617.971602-1-david@fromorbit.com>
 <20210617082617.971602-6-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210617082617.971602-6-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 17, 2021 at 06:26:14PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> So we can use it for start record ordering as well as commit record
> ordering in future.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

This tricked me for a second until I realized that xlog_cil_order_write
is the chunk of code just prior to the xlog_cil_write_commit_record
call.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_log_cil.c | 89 ++++++++++++++++++++++++++------------------
>  1 file changed, 52 insertions(+), 37 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index 35fc3e57d870..f993ec69fc97 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -784,9 +784,54 @@ xlog_cil_build_trans_hdr(
>  }
>  
>  /*
> - * Write out the commit record of a checkpoint transaction associated with the
> - * given ticket to close off a running log write. Return the lsn of the commit
> - * record.
> + * Ensure that the order of log writes follows checkpoint sequence order. This
> + * relies on the context LSN being zero until the log write has guaranteed the
> + * LSN that the log write will start at via xlog_state_get_iclog_space().
> + */
> +static int
> +xlog_cil_order_write(
> +	struct xfs_cil		*cil,
> +	xfs_csn_t		sequence)
> +{
> +	struct xfs_cil_ctx	*ctx;
> +
> +restart:
> +	spin_lock(&cil->xc_push_lock);
> +	list_for_each_entry(ctx, &cil->xc_committing, committing) {
> +		/*
> +		 * Avoid getting stuck in this loop because we were woken by the
> +		 * shutdown, but then went back to sleep once already in the
> +		 * shutdown state.
> +		 */
> +		if (XLOG_FORCED_SHUTDOWN(cil->xc_log)) {
> +			spin_unlock(&cil->xc_push_lock);
> +			return -EIO;
> +		}
> +
> +		/*
> +		 * Higher sequences will wait for this one so skip them.
> +		 * Don't wait for our own sequence, either.
> +		 */
> +		if (ctx->sequence >= sequence)
> +			continue;
> +		if (!ctx->commit_lsn) {
> +			/*
> +			 * It is still being pushed! Wait for the push to
> +			 * complete, then start again from the beginning.
> +			 */
> +			xlog_wait(&cil->xc_commit_wait, &cil->xc_push_lock);
> +			goto restart;
> +		}
> +	}
> +	spin_unlock(&cil->xc_push_lock);
> +	return 0;
> +}
> +
> +/*
> + * Write out the commit record of a checkpoint transaction to close off a
> + * running log write. These commit records are strictly ordered in ascending CIL
> + * sequence order so that log recovery will always replay the checkpoints in the
> + * correct order.
>   */
>  int
>  xlog_cil_write_commit_record(
> @@ -816,6 +861,10 @@ xlog_cil_write_commit_record(
>  	if (XLOG_FORCED_SHUTDOWN(log))
>  		return -EIO;
>  
> +	error = xlog_cil_order_write(ctx->cil, ctx->sequence);
> +	if (error)
> +		return error;
> +
>  	/* account for space used by record data */
>  	ctx->ticket->t_curr_res -= reg.i_len;
>  	error = xlog_write(log, ctx, &lv_chain, ctx->ticket, iclog, reg.i_len);
> @@ -1048,40 +1097,6 @@ xlog_cil_push_work(
>  	if (error)
>  		goto out_abort_free_ticket;
>  
> -	/*
> -	 * now that we've written the checkpoint into the log, strictly
> -	 * order the commit records so replay will get them in the right order.
> -	 */
> -restart:
> -	spin_lock(&cil->xc_push_lock);
> -	list_for_each_entry(new_ctx, &cil->xc_committing, committing) {
> -		/*
> -		 * Avoid getting stuck in this loop because we were woken by the
> -		 * shutdown, but then went back to sleep once already in the
> -		 * shutdown state.
> -		 */
> -		if (XLOG_FORCED_SHUTDOWN(log)) {
> -			spin_unlock(&cil->xc_push_lock);
> -			goto out_abort_free_ticket;
> -		}
> -
> -		/*
> -		 * Higher sequences will wait for this one so skip them.
> -		 * Don't wait for our own sequence, either.
> -		 */
> -		if (new_ctx->sequence >= ctx->sequence)
> -			continue;
> -		if (!new_ctx->commit_lsn) {
> -			/*
> -			 * It is still being pushed! Wait for the push to
> -			 * complete, then start again from the beginning.
> -			 */
> -			xlog_wait(&cil->xc_commit_wait, &cil->xc_push_lock);
> -			goto restart;
> -		}
> -	}
> -	spin_unlock(&cil->xc_push_lock);
> -
>  	error = xlog_cil_write_commit_record(ctx, &commit_iclog);
>  	if (error)
>  		goto out_abort_free_ticket;
> -- 
> 2.31.1
> 
