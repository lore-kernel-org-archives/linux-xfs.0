Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D7B9C433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Nov 2021 23:28:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231185AbhKWXcD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 Nov 2021 18:32:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:38248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229890AbhKWXcD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 23 Nov 2021 18:32:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 561ED6023D;
        Tue, 23 Nov 2021 23:28:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637710134;
        bh=C/zjaKaSiUPuwAqwNvwAXf3Qg3jd9jyIJJ9pqMhNkkc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UTSo6knJdPeoyf0/2Oht9Py5FBZPHq/jiWOPxCpDro2uGvVgM6W+9m/+S91RL0a6Z
         2wq+FMQUMSt4OQ9h4h2/qZdq99AymqlWuZlbBim4c1hpMOYl7dHJKXFzFvn+5/yFwj
         NG6GEJqpL4mFgFs45B4m2GrMQN2phq38ZDZzBalK2cO82qXY4YgjOes+phEob6voaE
         FTn41vu4nI+eZr4RJWsJO83AC45sXhJoB00NXvYNEIsfWyqbAUA8tY+2f72PMYhkhk
         KSrZ3pxcD8bvFmtWzb4i5NkCdtvAHYgjwQjyHXol4e1LKa5PecQRu6Sn7iJ3bCcF8x
         QFyqO1GvwJLNw==
Date:   Tue, 23 Nov 2021 15:28:53 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v25 02/12] xfs: don't commit the first deferred
 transaction without intents
Message-ID: <20211123232853.GX266024@magnolia>
References: <20211117041343.3050202-1-allison.henderson@oracle.com>
 <20211117041343.3050202-3-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211117041343.3050202-3-allison.henderson@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 16, 2021 at 09:13:33PM -0700, Allison Henderson wrote:
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

Nit: This ought to be "return dfp->dfp_intent != NULL" to reinforce that
we're returning whether or not the dfp has an associated log item vs.
returning the actual log item.

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
>  		list_splice_init(&(*tp)->t_dfops, &dop_pending);
>  
> -		error = xfs_defer_trans_roll(tp);
> -		if (error)
> -			goto out_shutdown;
> +		if (has_intents || dfp) {

I can't help but wonder if it would be simpler to make the xattr code
walk through the delattr state machine until there's actually an intent
to log?  I forget, which patch in this series actually sets up this
situation?

Atomic extent swapping sort of has a similar situation in that the first
transaction logs the inode core update and the swapext intent item, and
that's it.

--D

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
>  
>  		dfp = list_first_entry(&dop_pending, struct xfs_defer_pending,
>  				       dfp_list);
> -- 
> 2.25.1
> 
