Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96E2EC433E6
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Feb 2021 03:08:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3386F64DE2
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Feb 2021 03:08:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229566AbhBZDIA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Feb 2021 22:08:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:52668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229460AbhBZDIA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 25 Feb 2021 22:08:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 43DDE64EE2;
        Fri, 26 Feb 2021 03:07:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614308839;
        bh=mLLwOAzB2gSPm0EhS6uxtS8+Tiv+xqMwI7qU5xQ4LhU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RnkbWjX8qIRfmMXh8P1dCBiKMhnYmjw6FQOxfV1LbSh2Tm1+UB2McMVhaXLP6blbH
         QXrq8ihqZLtzxhHE2gEZqqEGwW0qdri/9j5NigMfVYqxlQN5jFuODretphivooqXn2
         y6HhyM/YRpq3hNXzHKRaYBNHMEOqvYadljzFrnTplF7mxvmntx1Y9z17veIVSnKAjW
         695VqMNWJjpB/3sjpSOGYPFxaE+raMpdpdr/buxVaJ5pufpqrph/gdP80AVC/XRJ9C
         SagddYicYVuW0pEJ60/Wd+pHSu5f8vURklpVJ/0nX43jfo1nhp4QyftEjFHy/OZYmf
         P4/zMyM7YWUcg==
Date:   Thu, 25 Feb 2021 19:07:19 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v15 05/22] xfs: Add helper xfs_attr_set_fmt
Message-ID: <20210226030719.GS7272@magnolia>
References: <20210218165348.4754-1-allison.henderson@oracle.com>
 <20210218165348.4754-6-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210218165348.4754-6-allison.henderson@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 18, 2021 at 09:53:31AM -0700, Allison Henderson wrote:
> This patch adds a helper function xfs_attr_set_fmt.  This will help
> isolate the code that will require state management from the portions
> that do not.  xfs_attr_set_fmt returns 0 when the attr has been set and
> no further action is needed.  It returns -EAGAIN when shortform has been
> transformed to leaf, and the calling function should proceed the set the
> attr in leaf form.
> 
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c | 77 +++++++++++++++++++++++++++---------------------
>  1 file changed, 44 insertions(+), 33 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index a064c5b..205ad26 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -216,6 +216,46 @@ xfs_attr_is_shortform(
>  		ip->i_afp->if_nextents == 0);
>  }
>  
> +STATIC int
> +xfs_attr_set_fmt(
> +	struct xfs_da_args	*args)
> +{
> +	struct xfs_buf          *leaf_bp = NULL;
> +	struct xfs_inode	*dp = args->dp;
> +	int			error2, error = 0;
> +
> +	/*
> +	 * Try to add the attr to the attribute list in the inode.
> +	 */
> +	error = xfs_attr_try_sf_addname(dp, args);
> +	if (error != -ENOSPC) {
> +		error2 = xfs_trans_commit(args->trans);
> +		args->trans = NULL;
> +		return error ? error : error2;
> +	}
> +
> +	/*
> +	 * It won't fit in the shortform, transform to a leaf block.
> +	 * GROT: another possible req'mt for a double-split btree op.
> +	 */
> +	error = xfs_attr_shortform_to_leaf(args, &leaf_bp);
> +	if (error)
> +		return error;
> +
> +	/*
> +	 * Prevent the leaf buffer from being unlocked so that a
> +	 * concurrent AIL push cannot grab the half-baked leaf buffer
> +	 * and run into problems with the write verifier.
> +	 */
> +	xfs_trans_bhold(args->trans, leaf_bp);
> +	error = xfs_defer_finish(&args->trans);
> +	xfs_trans_bhold_release(args->trans, leaf_bp);
> +	if (error)
> +		xfs_trans_brelse(args->trans, leaf_bp);

Shouldn't this pass the error back to the caller?

--D

> +
> +	return -EAGAIN;
> +}
> +
>  /*
>   * Set the attribute specified in @args.
>   */
> @@ -224,8 +264,7 @@ xfs_attr_set_args(
>  	struct xfs_da_args	*args)
>  {
>  	struct xfs_inode	*dp = args->dp;
> -	struct xfs_buf          *leaf_bp = NULL;
> -	int			error2, error = 0;
> +	int			error;
>  
>  	/*
>  	 * If the attribute list is already in leaf format, jump straight to
> @@ -234,36 +273,9 @@ xfs_attr_set_args(
>  	 * again.
>  	 */
>  	if (xfs_attr_is_shortform(dp)) {
> -		/*
> -		 * Try to add the attr to the attribute list in the inode.
> -		 */
> -		error = xfs_attr_try_sf_addname(dp, args);
> -		if (error != -ENOSPC) {
> -			error2 = xfs_trans_commit(args->trans);
> -			args->trans = NULL;
> -			return error ? error : error2;
> -		}
> -
> -		/*
> -		 * It won't fit in the shortform, transform to a leaf block.
> -		 * GROT: another possible req'mt for a double-split btree op.
> -		 */
> -		error = xfs_attr_shortform_to_leaf(args, &leaf_bp);
> -		if (error)
> +		error = xfs_attr_set_fmt(args);
> +		if (error != -EAGAIN)
>  			return error;
> -
> -		/*
> -		 * Prevent the leaf buffer from being unlocked so that a
> -		 * concurrent AIL push cannot grab the half-baked leaf buffer
> -		 * and run into problems with the write verifier.
> -		 */
> -		xfs_trans_bhold(args->trans, leaf_bp);
> -		error = xfs_defer_finish(&args->trans);
> -		xfs_trans_bhold_release(args->trans, leaf_bp);
> -		if (error) {
> -			xfs_trans_brelse(args->trans, leaf_bp);
> -			return error;
> -		}
>  	}
>  
>  	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
> @@ -297,8 +309,7 @@ xfs_attr_set_args(
>  			return error;
>  	}
>  
> -	error = xfs_attr_node_addname(args);
> -	return error;
> +	return xfs_attr_node_addname(args);
>  }
>  
>  /*
> -- 
> 2.7.4
> 
