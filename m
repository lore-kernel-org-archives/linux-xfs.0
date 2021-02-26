Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48FBBC433E0
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Feb 2021 03:04:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E400364EE7
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Feb 2021 03:04:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229598AbhBZDEY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Feb 2021 22:04:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:51304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229586AbhBZDEX (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 25 Feb 2021 22:04:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C423E64EE4;
        Fri, 26 Feb 2021 03:03:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614308622;
        bh=51OI27eQ3l6KEpHpcWfTMTuPvMbab5efwPZw4yRIc1o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vGR1OQ/a7DBAT183So0cf9ds2u1/HAkZ3yBcHlYiye0mSMQAqij+0bTS8CBVym+3p
         KuEZU//LOeT9p9EV13TZc4L8nTFQ4ke0l27xAmWrp6lM+4gnKI1yS+rrfsq0nKrB7j
         v/Xk8omN8YcofAvXywu+Dp0C0rDUtHA75CrRbtvM1e2NBByrXEaR7gJNk1PQNHgMxR
         JvnlIP1CQAPK2zSTpQhUUZSE5A3tmNYK0Jik5IRkXHfol2dRj7xX/YdA4Hv9r0Iu+d
         a93TnBJSHTglxLHSM4uZ3OfnkA41bNRys56ffPckvEeyqgmISFvYmY7z+RnMosdpcl
         E0KjMwB6HzIZA==
Date:   Thu, 25 Feb 2021 19:03:43 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v15 04/22] xfs: Hoist xfs_attr_set_shortform
Message-ID: <20210226030343.GR7272@magnolia>
References: <20210218165348.4754-1-allison.henderson@oracle.com>
 <20210218165348.4754-5-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210218165348.4754-5-allison.henderson@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 18, 2021 at 09:53:30AM -0700, Allison Henderson wrote:
> This patch hoists xfs_attr_set_shortform into the calling function. This
> will help keep all state management code in the same scope.
> 
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>

Whoah, /removing/ a function! :)

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_attr.c | 81 ++++++++++++++++--------------------------------
>  1 file changed, 27 insertions(+), 54 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 3cf76e2..a064c5b 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -217,53 +217,6 @@ xfs_attr_is_shortform(
>  }
>  
>  /*
> - * Attempts to set an attr in shortform, or converts short form to leaf form if
> - * there is not enough room.  If the attr is set, the transaction is committed
> - * and set to NULL.
> - */
> -STATIC int
> -xfs_attr_set_shortform(
> -	struct xfs_da_args	*args,
> -	struct xfs_buf		**leaf_bp)
> -{
> -	struct xfs_inode	*dp = args->dp;
> -	int			error, error2 = 0;
> -
> -	/*
> -	 * Try to add the attr to the attribute list in the inode.
> -	 */
> -	error = xfs_attr_try_sf_addname(dp, args);
> -	if (error != -ENOSPC) {
> -		error2 = xfs_trans_commit(args->trans);
> -		args->trans = NULL;
> -		return error ? error : error2;
> -	}
> -	/*
> -	 * It won't fit in the shortform, transform to a leaf block.  GROT:
> -	 * another possible req'mt for a double-split btree op.
> -	 */
> -	error = xfs_attr_shortform_to_leaf(args, leaf_bp);
> -	if (error)
> -		return error;
> -
> -	/*
> -	 * Prevent the leaf buffer from being unlocked so that a concurrent AIL
> -	 * push cannot grab the half-baked leaf buffer and run into problems
> -	 * with the write verifier. Once we're done rolling the transaction we
> -	 * can release the hold and add the attr to the leaf.
> -	 */
> -	xfs_trans_bhold(args->trans, *leaf_bp);
> -	error = xfs_defer_finish(&args->trans);
> -	xfs_trans_bhold_release(args->trans, *leaf_bp);
> -	if (error) {
> -		xfs_trans_brelse(args->trans, *leaf_bp);
> -		return error;
> -	}
> -
> -	return 0;
> -}
> -
> -/*
>   * Set the attribute specified in @args.
>   */
>  int
> @@ -272,7 +225,7 @@ xfs_attr_set_args(
>  {
>  	struct xfs_inode	*dp = args->dp;
>  	struct xfs_buf          *leaf_bp = NULL;
> -	int			error = 0;
> +	int			error2, error = 0;
>  
>  	/*
>  	 * If the attribute list is already in leaf format, jump straight to
> @@ -281,16 +234,36 @@ xfs_attr_set_args(
>  	 * again.
>  	 */
>  	if (xfs_attr_is_shortform(dp)) {
> +		/*
> +		 * Try to add the attr to the attribute list in the inode.
> +		 */
> +		error = xfs_attr_try_sf_addname(dp, args);
> +		if (error != -ENOSPC) {
> +			error2 = xfs_trans_commit(args->trans);
> +			args->trans = NULL;
> +			return error ? error : error2;
> +		}
> +
> +		/*
> +		 * It won't fit in the shortform, transform to a leaf block.
> +		 * GROT: another possible req'mt for a double-split btree op.
> +		 */
> +		error = xfs_attr_shortform_to_leaf(args, &leaf_bp);
> +		if (error)
> +			return error;
>  
>  		/*
> -		 * If the attr was successfully set in shortform, the
> -		 * transaction is committed and set to NULL.  Otherwise, is it
> -		 * converted from shortform to leaf, and the transaction is
> -		 * retained.
> +		 * Prevent the leaf buffer from being unlocked so that a
> +		 * concurrent AIL push cannot grab the half-baked leaf buffer
> +		 * and run into problems with the write verifier.
>  		 */
> -		error = xfs_attr_set_shortform(args, &leaf_bp);
> -		if (error || !args->trans)
> +		xfs_trans_bhold(args->trans, leaf_bp);
> +		error = xfs_defer_finish(&args->trans);
> +		xfs_trans_bhold_release(args->trans, leaf_bp);
> +		if (error) {
> +			xfs_trans_brelse(args->trans, leaf_bp);
>  			return error;
> +		}
>  	}
>  
>  	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
> -- 
> 2.7.4
> 
