Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19167C433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Mar 2021 00:26:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D8C8E64FAE
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Mar 2021 00:26:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229595AbhCKA0Y (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 10 Mar 2021 19:26:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:49838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229459AbhCKA0P (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 10 Mar 2021 19:26:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E47C564F60;
        Thu, 11 Mar 2021 00:26:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615422375;
        bh=dzV0e4kvMO+9Kr9igPEzMQNiGTB7eW0/K614dj13sZI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sXGqWUlNsN7E7IrMUZ5L+K25mZCSXmUUE53Z2EzhaUDqfedWwtrf2t22SWC3sfIYs
         4w7hHN5yhQNUGN4S020FKQ7CHn7VlREVTZB/yba95lJCCWIFwFsxgfA0Jy6ak4KyUC
         7e+EpOHEElPp8lDVwSxPC9cfVqGtj5e511BbEipqY2C27lmNsN9F12dwuFx/DR5oyd
         Tt2E9Tjt+TP795k36eSciOLEZFz6ol0IfFfckW8i7eWV+Tb/LV4WjaVM8KWk10kAu0
         xRFuTmNcWctW6IZPAdx2mbC74CMhMT8ucRNSVlOQKiz3/HHJTBb0JN0LrBUkMlzflH
         Dr+zFNOZ5JRCw==
Date:   Wed, 10 Mar 2021 16:26:10 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 37/45] xfs: track CIL ticket reservation in percpu
 structure
Message-ID: <20210311002610.GK3419940@magnolia>
References: <20210305051143.182133-1-david@fromorbit.com>
 <20210305051143.182133-38-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210305051143.182133-38-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 05, 2021 at 04:11:35PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> To get it out from under the cil spinlock.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_log_cil.c  | 11 ++++++-----
>  fs/xfs/xfs_log_priv.h |  2 +-
>  2 files changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index 5519d112c1fd..a2f93bd7644b 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -492,6 +492,7 @@ xlog_cil_insert_items(
>  	 * based on how close we are to the hard limit.
>  	 */
>  	cilpcp = get_cpu_ptr(cil->xc_pcp);
> +	cilpcp->space_reserved += ctx_res;
>  	cilpcp->space_used += len;
>  	if (space_used >= XLOG_CIL_SPACE_LIMIT(log) ||
>  	    cilpcp->space_used >
> @@ -502,10 +503,6 @@ xlog_cil_insert_items(
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
> @@ -527,6 +524,7 @@ xlog_cil_insert_items(
>  	 * We do this here so we only need to take the CIL lock once during
>  	 * the transaction commit.
>  	 */
> +	spin_lock(&cil->xc_cil_lock);
>  	list_for_each_entry(lip, &tp->t_items, li_trans) {
>  
>  		/* Skip items which aren't dirty in this transaction. */
> @@ -798,10 +796,13 @@ xlog_cil_push_work(
>  
>  	down_write(&cil->xc_ctx_lock);
>  
> -	/* Reset the CIL pcp counters */
> +	/* Aggregate and reset the CIL pcp counters */
>  	for_each_online_cpu(cpu) {
>  		cilpcp = per_cpu_ptr(cil->xc_pcp, cpu);
> +		ctx->ticket->t_curr_res += cilpcp->space_reserved;

Why isn't it necessary to update ctx->ticket->t_unit_res any more?

(Admittedly I'm struggling to figure out why it matters to keep it
updated even in the current code base...)

--D

>  		cilpcp->space_used = 0;
> +		cilpcp->space_reserved = 0;
> +
>  	}
>  
>  	spin_lock(&cil->xc_push_lock);
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index 4eb373357f26..278b9eaea582 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -236,7 +236,7 @@ struct xfs_cil_ctx {
>   */
>  struct xlog_cil_pcp {
>  	uint32_t		space_used;
> -	uint32_t		curr_res;
> +	uint32_t		space_reserved;
>  	struct list_head	busy_extents;
>  	struct list_head	log_items;
>  };
> -- 
> 2.28.0
> 
