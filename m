Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8C59C47082
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Jun 2021 16:43:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9DD906024A
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Jun 2021 16:43:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbhFCQpi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Jun 2021 12:45:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:35266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229794AbhFCQpi (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 3 Jun 2021 12:45:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 564696024A;
        Thu,  3 Jun 2021 16:43:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622738633;
        bh=9FUTIUJHxjF9MVt3vhuX4nnfDDRKrl6WPy6Hfagm2WQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IU/gH6pp60qgWKP1TjzyyjQS9PVn14kYvqE07/ZvfP/1xUO9wOeEu461/68XqxS3m
         MA/G00QxOpSuVUMtARQwP5zqGP+uyA/vL3oRwHzzMWOQW6RksZZzfeWsok97MgVp8/
         as4mo8Ku+aoFrO0eWKl28kG+kHoii9D7tkgunmkBQ7WkRW9N4cbeGA3VlL+WL/Ljia
         zsFH8fmqfNgJ1gJtzEX0bb6T3kAh+UQcPbD7+tTrRNBWRe9hXjYGOqCV20UpOSRojg
         5kgcOPmA5PO1iQj10qVFP3x+rGRmJ7ySLChhCPLBYle6qGAiMtFd3s4yWlrFw12p44
         WNYBmGuoV1yFA==
Date:   Thu, 3 Jun 2021 09:43:52 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 31/39] xfs: track CIL ticket reservation in percpu
 structure
Message-ID: <20210603164352.GW26380@locust>
References: <20210603052240.171998-1-david@fromorbit.com>
 <20210603052240.171998-32-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210603052240.171998-32-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 03, 2021 at 03:22:32PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> To get it out from under the cil spinlock.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_log_cil.c  | 21 ++++++++++++++++-----
>  fs/xfs/xfs_log_priv.h |  1 +
>  2 files changed, 17 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index 620824c6f7fa..f5ce7099afc5 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -91,12 +91,17 @@ xlog_cil_pcp_aggregate(
>  	for_each_online_cpu(cpu) {
>  		cilpcp = per_cpu_ptr(cil->xc_pcp, cpu);
>  
> +		ctx->ticket->t_curr_res += cilpcp->space_reserved;
> +		ctx->ticket->t_unit_res += cilpcp->space_reserved;
> +		cilpcp->space_reserved = 0;
> +
>  		/*
>  		 * We're in the middle of switching cil contexts.  Reset the
>  		 * counter we use to detect when the current context is nearing
>  		 * full.
>  		 */
>  		cilpcp->space_used = 0;
> +

Dumb nit: empty line at end of block.

--D

>  	}
>  }
>  
> @@ -516,6 +521,7 @@ xlog_cil_insert_items(
>  	 * based on how close we are to the hard limit.
>  	 */
>  	cilpcp = get_cpu_ptr(cil->xc_pcp);
> +	cilpcp->space_reserved += ctx_res;
>  	cilpcp->space_used += len;
>  	if (space_used >= XLOG_CIL_SPACE_LIMIT(log) ||
>  	    cilpcp->space_used >
> @@ -526,10 +532,6 @@ xlog_cil_insert_items(
>  	}
>  	put_cpu_ptr(cilpcp);
>  
> -	spin_lock(&cil->xc_cil_lock);
> -	ctx->ticket->t_unit_res += ctx_res;
> -	ctx->ticket->t_curr_res += ctx_res;
> -
>  	/*
>  	 * If we've overrun the reservation, dump the tx details before we move
>  	 * the log items. Shutdown is imminent...
> @@ -551,6 +553,7 @@ xlog_cil_insert_items(
>  	 * We do this here so we only need to take the CIL lock once during
>  	 * the transaction commit.
>  	 */
> +	spin_lock(&cil->xc_cil_lock);
>  	list_for_each_entry(lip, &tp->t_items, li_trans) {
>  
>  		/* Skip items which aren't dirty in this transaction. */
> @@ -1439,12 +1442,20 @@ xlog_cil_pcp_dead(
>  	spin_lock(&xlog_cil_pcp_lock);
>  	list_for_each_entry_safe(cil, n, &xlog_cil_pcp_list, xc_pcp_list) {
>  		struct xlog_cil_pcp	*cilpcp = per_cpu_ptr(cil->xc_pcp, cpu);
> +		struct xfs_cil_ctx	*ctx;
>  
>  		spin_unlock(&xlog_cil_pcp_lock);
>  		down_write(&cil->xc_ctx_lock);
> +		ctx = cil->xc_ctx;
> +
> +		atomic_add(cilpcp->space_used, &ctx->space_used);
> +		if (ctx->ticket) {
> +			ctx->ticket->t_curr_res += cilpcp->space_reserved;
> +			ctx->ticket->t_unit_res += cilpcp->space_reserved;
> +		}
>  
> -		atomic_add(cilpcp->space_used, &cil->xc_ctx->space_used);
>  		cilpcp->space_used = 0;
> +		cilpcp->space_reserved = 0;
>  
>  		up_write(&cil->xc_ctx_lock);
>  		spin_lock(&xlog_cil_pcp_lock);
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index 373b7dbde4af..b80cb3a0edb7 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -232,6 +232,7 @@ struct xfs_cil_ctx {
>   */
>  struct xlog_cil_pcp {
>  	uint32_t		space_used;
> +	uint32_t		space_reserved;
>  	struct list_head	busy_extents;
>  	struct list_head	log_items;
>  };
> -- 
> 2.31.1
> 
