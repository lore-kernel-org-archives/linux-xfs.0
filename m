Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A940CC433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Apr 2022 03:03:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357350AbiD0DGn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Apr 2022 23:06:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357352AbiD0DGm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Apr 2022 23:06:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D94745FF31
        for <linux-xfs@vger.kernel.org>; Tue, 26 Apr 2022 20:03:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 447B961C7A
        for <linux-xfs@vger.kernel.org>; Wed, 27 Apr 2022 03:03:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 932A2C385A0;
        Wed, 27 Apr 2022 03:03:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651028610;
        bh=MUw0lBywT39PbNt1Nd1CeV+lcKmLVGvcQ4H6L4LVxjg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GRGkcr7mwmo+Z9g/zm9gkSlSiIzTW1WfXuHJz6QFtcDKU3yUBJ1kRuppFjT8sivUU
         MTViYU4usV20z0Yyhuuv47ujsCOVj8/H9mt6sLqSN7R3mj20/O8I2+ABq3IX95xwWc
         XuHp8Lmshk7ZPob8tb6HPwXdcD91fEBU3LNpFBL/B46eobjnkDHrLKUJR7Nrt36vxJ
         yKBC3o1/rpE+DCQ8YQ2o4zUa1A2Gf0wLWTgicoJJLHdHaCY+ST/NIDZACMLwtKGzXm
         duJIbOUUgbkyYhnYp0YBDWNqWOTyvVQLXZaeIHn4QASDadM5w+9OvCu6PdZXmIwqfu
         Q6rvj4/1Exm+Q==
Date:   Tue, 26 Apr 2022 20:03:30 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/8] xfs: don't commit the first deferred transaction
 without intents
Message-ID: <20220427030330.GA17025@magnolia>
References: <20220427022259.695399-1-david@fromorbit.com>
 <20220427022259.695399-3-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220427022259.695399-3-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 27, 2022 at 12:22:53PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
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
> ---
>  fs/xfs/libxfs/xfs_defer.c | 29 +++++++++++++++++------------
>  1 file changed, 17 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
> index 0805ade2d300..66b4555bda8e 100644
> --- a/fs/xfs/libxfs/xfs_defer.c
> +++ b/fs/xfs/libxfs/xfs_defer.c
> @@ -186,7 +186,7 @@ static const struct xfs_defer_op_type *defer_op_types[] = {
>  	[XFS_DEFER_OPS_TYPE_AGFL_FREE]	= &xfs_agfl_free_defer_type,
>  };
>  
> -static void
> +static bool
>  xfs_defer_create_intent(
>  	struct xfs_trans		*tp,
>  	struct xfs_defer_pending	*dfp,
> @@ -197,6 +197,7 @@ xfs_defer_create_intent(
>  	if (!dfp->dfp_intent)
>  		dfp->dfp_intent = ops->create_intent(tp, &dfp->dfp_work,
>  						     dfp->dfp_count, sort);
> +	return dfp->dfp_intent;

Same comment as last time -- please make it more obvious that we're
returning whether or not ->create_intent actually added a log item:

	return dfp->dfp_intent != NULL;

and not returning the log intent item itself.

Otherwise looks ok, so with that fixed,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

>  }
>  
>  /*
> @@ -204,16 +205,18 @@ xfs_defer_create_intent(
>   * associated extents, then add the entire intake list to the end of
>   * the pending list.
>   */
> -STATIC void
> +static bool
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
> @@ -487,7 +490,7 @@ int
>  xfs_defer_finish_noroll(
>  	struct xfs_trans		**tp)
>  {
> -	struct xfs_defer_pending	*dfp;
> +	struct xfs_defer_pending	*dfp = NULL;
>  	int				error = 0;
>  	LIST_HEAD(dop_pending);
>  
> @@ -506,17 +509,19 @@ xfs_defer_finish_noroll(
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
> 2.35.1
> 
