Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 948FCC433E0
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Feb 2021 03:00:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 374F464EE7
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Feb 2021 03:00:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229491AbhBZDAu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Feb 2021 22:00:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:49942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229460AbhBZDAt (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 25 Feb 2021 22:00:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DF1E464EE4;
        Fri, 26 Feb 2021 03:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614308409;
        bh=scPiDGy66Q3PIGaFXlLVF6cokKONduX1jahn2SRUJF4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MPEvpgwfxt8M6/T9hWmnuq9XFfIbkrVbHOjDtXVzqMeZXNVjsASuHHKIRcIH8Jtx3
         ZbIPNPovWV5X7iQHqBQN+5eEhkH4Epr3KUiC51WiKLq7BJS7PmD/2H7aYfWjaXWEat
         SPw+0IaT7ch/kq4jXEObjaROGAIiE15GCArJZoaJHa4crSwcKwRF2Z01bEL6Rbtnuu
         Jqco6gVGkvFmeWIx7dwNYGQik/BsW6jiaKxONEKdhzvCEJ2Hu2mWDKtF3rCeLCsC0E
         tBKogf1PAX6fXnZx2SF0z18ax4kjDs+rzg/ExVGgOS7nFkEGxNicjXtXU2FWcfBCtm
         yOHYUVLN/+zPQ==
Date:   Thu, 25 Feb 2021 19:00:09 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v15 02/22] xfs: Add xfs_attr_node_remove_cleanup
Message-ID: <20210226030009.GP7272@magnolia>
References: <20210218165348.4754-1-allison.henderson@oracle.com>
 <20210218165348.4754-3-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210218165348.4754-3-allison.henderson@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 18, 2021 at 09:53:28AM -0700, Allison Henderson wrote:
> This patch pulls a new helper function xfs_attr_node_remove_cleanup out
> of xfs_attr_node_remove_step.  This helps to modularize
> xfs_attr_node_remove_step which will help make the delayed attribute
> code easier to follow
> 
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

Looks ok,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_attr.c | 29 ++++++++++++++++++++---------
>  1 file changed, 20 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 28ff93d..4e6c89d 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -1220,6 +1220,25 @@ xfs_attr_node_remove_rmt(
>  	return xfs_attr_refillstate(state);
>  }
>  
> +STATIC int
> +xfs_attr_node_remove_cleanup(
> +	struct xfs_da_args	*args,
> +	struct xfs_da_state	*state)
> +{
> +	struct xfs_da_state_blk	*blk;
> +	int			retval;
> +
> +	/*
> +	 * Remove the name and update the hashvals in the tree.
> +	 */
> +	blk = &state->path.blk[state->path.active-1];
> +	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
> +	retval = xfs_attr3_leaf_remove(blk->bp, args);
> +	xfs_da3_fixhashpath(state, &state->path);
> +
> +	return retval;
> +}
> +
>  /*
>   * Remove a name from a B-tree attribute list.
>   *
> @@ -1232,7 +1251,6 @@ xfs_attr_node_remove_step(
>  	struct xfs_da_args	*args,
>  	struct xfs_da_state	*state)
>  {
> -	struct xfs_da_state_blk	*blk;
>  	int			retval, error;
>  	struct xfs_inode	*dp = args->dp;
>  
> @@ -1247,14 +1265,7 @@ xfs_attr_node_remove_step(
>  		if (error)
>  			return error;
>  	}
> -
> -	/*
> -	 * Remove the name and update the hashvals in the tree.
> -	 */
> -	blk = &state->path.blk[ state->path.active-1 ];
> -	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
> -	retval = xfs_attr3_leaf_remove(blk->bp, args);
> -	xfs_da3_fixhashpath(state, &state->path);
> +	retval = xfs_attr_node_remove_cleanup(args, state);
>  
>  	/*
>  	 * Check to see if the tree needs to be collapsed.
> -- 
> 2.7.4
> 
