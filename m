Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45D8FC47089
	for <linux-xfs@archiver.kernel.org>; Thu, 27 May 2021 18:49:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1309F613AF
	for <linux-xfs@archiver.kernel.org>; Thu, 27 May 2021 18:49:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234588AbhE0Sv1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 May 2021 14:51:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:53458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229712AbhE0Sv1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 27 May 2021 14:51:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E7244613D1;
        Thu, 27 May 2021 18:49:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622141394;
        bh=TFUpyc3IAOgD6/I1rRqUcG2dg7hr8uqSauiVA0hQpq0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tvvb/dlE/d7bZQgsA8C2Ea+9d2BwJWyjRRmqIG5xwvHygQ4uOzQU/WjGzpLQhKdLY
         hNujV0RcFQp6bsZUEHqI6f7NQ3M2ohmClgs9cpkc4G25Jhz7uaIKQbNQXy4fokBoZ9
         Ibw6ALC6fMv/zx1fH70k9mM2NBtFcOmZm4VP7o01LyNTHKVgiIEVKiayrkA6PwkqQf
         V+okm3Oh38rkAe9xpVKqYu4TXO/K34vIftYDce5X6zpYK0fdXgMfSXeIqPvRCo5O1I
         c3w5QEvupntTplLwnuxXi9XszQGx3Tatk50GS00C4Sp/JmwOm1Yj+1eKfLIKERKVCj
         RgD/FB9xM8q3w==
Date:   Thu, 27 May 2021 11:49:53 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 32/39] xfs: convert CIL busy extents to per-cpu
Message-ID: <20210527184953.GJ2402049@locust>
References: <20210519121317.585244-1-david@fromorbit.com>
 <20210519121317.585244-33-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210519121317.585244-33-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 19, 2021 at 10:13:10PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> To get them out from under the CIL lock.
> 
> This is an unordered list, so we can simply punt it to per-cpu lists
> during transaction commits and reaggregate it back into a single
> list during the CIL push work.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_log_cil.c | 22 +++++++++++++++++++---
>  1 file changed, 19 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index 4ddc302a766b..b12a2f9ba23a 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -93,6 +93,11 @@ xlog_cil_pcp_aggregate(
>  
>  		ctx->ticket->t_curr_res += cilpcp->space_reserved;
>  		ctx->ticket->t_unit_res += cilpcp->space_reserved;
> +		if (!list_empty(&cilpcp->busy_extents)) {
> +			list_splice_init(&cilpcp->busy_extents,
> +					&ctx->busy_extents);
> +		}
> +
>  		cilpcp->space_reserved = 0;
>  		cilpcp->space_used = 0;
>  	}
> @@ -523,6 +528,9 @@ xlog_cil_insert_items(
>  		atomic_add(cilpcp->space_used, &ctx->space_used);
>  		cilpcp->space_used = 0;
>  	}
> +	/* attach the transaction to the CIL if it has any busy extents */
> +	if (!list_empty(&tp->t_busy))
> +		list_splice_init(&tp->t_busy, &cilpcp->busy_extents);
>  	put_cpu_ptr(cilpcp);
>  
>  	/*
> @@ -562,9 +570,6 @@ xlog_cil_insert_items(
>  			list_move_tail(&lip->li_cil, &cil->xc_cil);
>  	}
>  
> -	/* attach the transaction to the CIL if it has any busy extents */
> -	if (!list_empty(&tp->t_busy))
> -		list_splice_init(&tp->t_busy, &ctx->busy_extents);
>  	spin_unlock(&cil->xc_cil_lock);
>  
>  	if (tp->t_ticket->t_curr_res < 0)
> @@ -1447,6 +1452,10 @@ xlog_cil_pcp_dead(
>  			ctx->ticket->t_curr_res += cilpcp->space_reserved;
>  			ctx->ticket->t_unit_res += cilpcp->space_reserved;
>  		}
> +		if (!list_empty(&cilpcp->busy_extents)) {
> +			list_splice_init(&cilpcp->busy_extents,
> +					&ctx->busy_extents);
> +		}
>  
>  		cilpcp->space_used = 0;
>  		cilpcp->space_reserved = 0;
> @@ -1502,7 +1511,9 @@ static void __percpu *
>  xlog_cil_pcp_alloc(
>  	struct xfs_cil		*cil)
>  {
> +	struct xlog_cil_pcp	*cilpcp;
>  	void __percpu		*pcp;
> +	int			cpu;
>  
>  	pcp = alloc_percpu(struct xlog_cil_pcp);
>  	if (!pcp)
> @@ -1512,6 +1523,11 @@ xlog_cil_pcp_alloc(
>  		free_percpu(pcp);
>  		return NULL;
>  	}
> +
> +	for_each_possible_cpu(cpu) {
> +		cilpcp = per_cpu_ptr(pcp, cpu);
> +		INIT_LIST_HEAD(&cilpcp->busy_extents);
> +	}
>  	return pcp;
>  }
>  
> -- 
> 2.31.1
> 
