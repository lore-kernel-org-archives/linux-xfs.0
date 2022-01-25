Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 007EAC433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Jan 2022 04:17:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352505AbiAYEQs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Jan 2022 23:16:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S3408028AbiAYChm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jan 2022 21:37:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23299C061769
        for <linux-xfs@vger.kernel.org>; Mon, 24 Jan 2022 16:52:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B3C236091F
        for <linux-xfs@vger.kernel.org>; Tue, 25 Jan 2022 00:52:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18CC8C340E4;
        Tue, 25 Jan 2022 00:52:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643071926;
        bh=iRxEWQRHF2hmxTOAyz8IyruGocB2mWyqo//LY+633aM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Bf/KO135jPmmgoQQgglnxD3NbLafVukIPwACCn0C8jM6y+yOi5PMPep5i0LIKm1iP
         2tRfmCnOb58PRln4w29KKymZscQNq+jhM0CTpxxnxIPjpFQAWrXFkn3kWdORqqYbBM
         GywUHwZBtgnI48mug9FyGSKjVESaZtMaLC4+hc9DCGvPawtXa7fFB+tJv37I6UgBHq
         W3Bp4lWgzs+Q39R77PC9j+ZisUXEefc+L9mcn8G6GDMaX0l+CbZ1caI0Gpg4Qh0xZH
         rlNgYPhR9+nTJObYhy4oukQRmrU0GM2R0+g9rX6yxRz6tcGkRtCJKeeeC9pEloHJ0p
         mKbbteO7q4fRQ==
Date:   Mon, 24 Jan 2022 16:52:05 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v26 02/12] xfs: don't commit the first deferred
 transaction without intents
Message-ID: <20220125005205.GZ13540@magnolia>
References: <20220124052708.580016-1-allison.henderson@oracle.com>
 <20220124052708.580016-3-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220124052708.580016-3-allison.henderson@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Jan 23, 2022 at 10:26:58PM -0700, Allison Henderson wrote:
> If the first operation in a string of defer ops has no intents,
> then there is no reason to commit it before running the first call
> to xfs_defer_finish_one(). This allows the defer ops to be used
> effectively for non-intent based operations without requiring an
> unnecessary extra transaction commit when first called.
> 
> This fixes a regression in per-attribute modification transaction
> count when delayed attributes are not being used.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_defer.c | 29 +++++++++++++++++------------
>  1 file changed, 17 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
> index 6dac8d6b8c21..51574f0371b5 100644
> --- a/fs/xfs/libxfs/xfs_defer.c
> +++ b/fs/xfs/libxfs/xfs_defer.c
> @@ -187,7 +187,7 @@ static const struct xfs_defer_op_type *defer_op_types[] = {
>  	[XFS_DEFER_OPS_TYPE_AGFL_FREE]	= &xfs_agfl_free_defer_type,
>  };
>  
> -static void
> +static bool
>  xfs_defer_create_intent(
>  	struct xfs_trans		*tp,
>  	struct xfs_defer_pending	*dfp,
> @@ -198,6 +198,7 @@ xfs_defer_create_intent(
>  	if (!dfp->dfp_intent)
>  		dfp->dfp_intent = ops->create_intent(tp, &dfp->dfp_work,
>  						     dfp->dfp_count, sort);
> +	return dfp->dfp_intent;

Hm.  My first reaction is that this still ought to be an explicit
boolean comparison...

>  }
>  
>  /*
> @@ -205,16 +206,18 @@ xfs_defer_create_intent(
>   * associated extents, then add the entire intake list to the end of
>   * the pending list.
>   */
> -STATIC void
> +STATIC bool
>  xfs_defer_create_intents(
>  	struct xfs_trans		*tp)
>  {
>  	struct xfs_defer_pending	*dfp;
> +	bool				ret = false;
>  
>  	list_for_each_entry(dfp, &tp->t_dfops, dfp_list) {
>  		trace_xfs_defer_create_intent(tp->t_mountp, dfp);
> -		xfs_defer_create_intent(tp, dfp, true);
> +		ret |= xfs_defer_create_intent(tp, dfp, true);
>  	}
> +	return ret;
>  }
>  
>  /* Abort all the intents that were committed. */
> @@ -488,7 +491,7 @@ int
>  xfs_defer_finish_noroll(
>  	struct xfs_trans		**tp)
>  {
> -	struct xfs_defer_pending	*dfp;
> +	struct xfs_defer_pending	*dfp = NULL;
>  	int				error = 0;
>  	LIST_HEAD(dop_pending);
>  
> @@ -507,17 +510,19 @@ xfs_defer_finish_noroll(
>  		 * of time that any one intent item can stick around in memory,
>  		 * pinning the log tail.
>  		 */
> -		xfs_defer_create_intents(*tp);
> +		bool has_intents = xfs_defer_create_intents(*tp);

...but now it occurs to me that I think we can test ((*tp)->t_flags &
XFS_TRANS_DIRTY) instead of setting up the explicit return type.

If the ->create_intent function actually logs an intent item to the
transaction, we need to commit that intent item (to persist it to disk)
before we start on the work that it represents.  If an intent item has
been added, the transaction will be dirty.

At this point in the loop, we're trying to set ourselves up to call
->finish_one.  The ->finish_one implementations expect a clean
transaction, which means that we /never/ want to get to...

>  		list_splice_init(&(*tp)->t_dfops, &dop_pending);
>  
> -		error = xfs_defer_trans_roll(tp);
> -		if (error)
> -			goto out_shutdown;
> +		if (has_intents || dfp) {
> +			error = xfs_defer_trans_roll(tp);
> +			if (error)
> +				goto out_shutdown;
>  
> -		/* Possibly relog intent items to keep the log moving. */
> -		error = xfs_defer_relog(tp, &dop_pending);
> -		if (error)
> -			goto out_shutdown;
> +			/* Possibly relog intent items to keep the log moving. */
> +			error = xfs_defer_relog(tp, &dop_pending);
> +			if (error)
> +				goto out_shutdown;
> +		}

...this point here with the transaction still dirty.  Therefore, I think
all this patch really needs to change is that first _trans_roll:

	xfs_defer_create_intents(*tp);
	list_splice_init(&(*tp)->t_dfops, &dop_pending);

	/*
	 * We must ensure the transaction is clean before we try to finish
	 * deferred work by committing logged intent items and anything
	 * else that dirtied the transaction.
	 */
	if ((*tpp)->t_flags & XFS_TRANS_DIRTY) {
		error = xfs_defer_trans_roll(tp);
		if (error)
			goto out_shutdown;
	}

	/* Possibly relog intent items to keep the log moving. */
	error = xfs_defer_relog(tp, &dop_pending);
	if (error)
		goto out_shutdown;

	dfp = list_first_entry(&dop_pending, struct xfs_defer_pending,
			       dfp_list);
	error = xfs_defer_finish_one(*tp, dfp);
	if (error && error != -EAGAIN)
		goto out_shutdown;

Thoughts?

--D

>  
>  		dfp = list_first_entry(&dop_pending, struct xfs_defer_pending,
>  				       dfp_list);
> -- 
> 2.25.1
> 
