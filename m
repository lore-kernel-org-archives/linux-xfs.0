Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51D40C4707F
	for <linux-xfs@archiver.kernel.org>; Thu, 27 May 2021 18:48:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2C2A7613D1
	for <linux-xfs@archiver.kernel.org>; Thu, 27 May 2021 18:48:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233633AbhE0Stz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 May 2021 14:49:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:51882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229712AbhE0Stz (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 27 May 2021 14:49:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4F312613AF;
        Thu, 27 May 2021 18:48:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622141302;
        bh=rjgrO4WH1Re1FAu87f2Q+24KrlNTLytrxLlEmZ/dGYE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AsczjD4DIusraU8n9ucv+6h1hw5iEnFqatU43RUT9jNLb0DfxFQGZkkHM+njsF6I6
         0yXggamXpM32FIjY0aMoIr43GFuNvmflwlPJ8Hes4oXJY4PG3PFCeJD6S+fkzJfRS0
         s0YVM5XWRuUEXrKMt51TW09uS8bR7XJPPNEUdGDPuMMWue02Rc2s8TwhFbWalNHtN6
         hlL6uXP+lxn0+pTAPARIgq/blSoziCtLoLv3jP/ACbVxPxbkcfBwC4eJvmo2s6js3B
         wTFbebU9Nrk46PUUIRwvTqr5c6xN9m/eRa1TB2caBUNITtSrIy+KXPqx5i+AnotNA3
         TCbTKnEJMQoew==
Date:   Thu, 27 May 2021 11:48:21 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 31/39] xfs: track CIL ticket reservation in percpu
 structure
Message-ID: <20210527184821.GI2402049@locust>
References: <20210519121317.585244-1-david@fromorbit.com>
 <20210519121317.585244-32-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210519121317.585244-32-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 19, 2021 at 10:13:09PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> To get it out from under the cil spinlock.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks ... straightforward enough for a percpu thing ;)
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_log_cil.c  | 20 +++++++++++++++-----
>  fs/xfs/xfs_log_priv.h |  2 +-
>  2 files changed, 16 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index 72693fba929b..4ddc302a766b 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -90,6 +90,10 @@ xlog_cil_pcp_aggregate(
>  
>  	for_each_online_cpu(cpu) {
>  		cilpcp = per_cpu_ptr(cil->xc_pcp, cpu);
> +
> +		ctx->ticket->t_curr_res += cilpcp->space_reserved;
> +		ctx->ticket->t_unit_res += cilpcp->space_reserved;
> +		cilpcp->space_reserved = 0;
>  		cilpcp->space_used = 0;
>  	}
>  }
> @@ -510,6 +514,7 @@ xlog_cil_insert_items(
>  	 * based on how close we are to the hard limit.
>  	 */
>  	cilpcp = get_cpu_ptr(cil->xc_pcp);
> +	cilpcp->space_reserved += ctx_res;
>  	cilpcp->space_used += len;
>  	if (space_used >= XLOG_CIL_SPACE_LIMIT(log) ||
>  	    cilpcp->space_used >
> @@ -520,10 +525,6 @@ xlog_cil_insert_items(
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
> @@ -545,6 +546,7 @@ xlog_cil_insert_items(
>  	 * We do this here so we only need to take the CIL lock once during
>  	 * the transaction commit.
>  	 */
> +	spin_lock(&cil->xc_cil_lock);
>  	list_for_each_entry(lip, &tp->t_items, li_trans) {
>  
>  		/* Skip items which aren't dirty in this transaction. */
> @@ -1434,12 +1436,20 @@ xlog_cil_pcp_dead(
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
> index 7dc6275818de..b80cb3a0edb7 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -232,7 +232,7 @@ struct xfs_cil_ctx {
>   */
>  struct xlog_cil_pcp {
>  	uint32_t		space_used;
> -	uint32_t		curr_res;
> +	uint32_t		space_reserved;
>  	struct list_head	busy_extents;
>  	struct list_head	log_items;
>  };
> -- 
> 2.31.1
> 
