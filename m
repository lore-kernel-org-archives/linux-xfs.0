Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 497F9C4707F
	for <linux-xfs@archiver.kernel.org>; Tue, 25 May 2021 20:35:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2303F6140E
	for <linux-xfs@archiver.kernel.org>; Tue, 25 May 2021 20:35:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231978AbhEYUg5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 May 2021 16:36:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:34628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230218AbhEYUg5 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 25 May 2021 16:36:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F2205613D2;
        Tue, 25 May 2021 20:35:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621974927;
        bh=NCAdOKLdm4nf8BoOp9YxBqCfYOaVz9rzoeXX4jdiOWo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=o2A0bW8kMmuLAUwvlzIpcha0ekeCIVRBvd9MyGDvYmsvpocSH0PgDTsWwBcYWfHTx
         0+xQhiJypx20Bxo14uoSb3YpmoNbXu0HtjJn2402A2Gcle3L0ObidUQJz7YV6oPX1I
         l0QbGm0waKWGz22/3GOXAeTXW7y0JTeP/bXBybVBpfMnNjBMJffTgjW7hxA3bqNc5v
         g3EdnftBQJFKoSoAChJXvr/PymVKN9SLVbkGoF+ZgawMzq1Y73E3WjNWquE/YF9dCU
         5cmlghjBnn7/+RUoouAQZb6+bGQQV6pDFUankGrrPJVT3Z0gpL1UrFU+MkO8Jf+ZLZ
         pEUbfN7GnO/Xg==
Date:   Tue, 25 May 2021 13:35:26 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v19 12/14] xfs: Clean up
 xfs_attr_node_addname_clear_incomplete
Message-ID: <20210525203526.GJ202121@locust>
References: <20210525195504.7332-1-allison.henderson@oracle.com>
 <20210525195504.7332-13-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210525195504.7332-13-allison.henderson@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 25, 2021 at 12:55:02PM -0700, Allison Henderson wrote:
> We can use the helper function xfs_attr_node_remove_name to reduce
> duplicate code in this function
> 
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>

Nice cleanup,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_attr.c | 11 +++--------
>  1 file changed, 3 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index f7b0e79..32d451b 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -63,6 +63,8 @@ STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
>  STATIC int xfs_attr_refillstate(xfs_da_state_t *state);
>  STATIC int xfs_attr_set_iter(struct xfs_delattr_context *dac,
>  			     struct xfs_buf **leaf_bp);
> +STATIC int xfs_attr_node_remove_name(struct xfs_da_args *args,
> +				     struct xfs_da_state *state);
>  
>  int
>  xfs_inode_hasattr(
> @@ -1207,7 +1209,6 @@ xfs_attr_node_addname_clear_incomplete(
>  {
>  	struct xfs_da_args		*args = dac->da_args;
>  	struct xfs_da_state		*state = NULL;
> -	struct xfs_da_state_blk		*blk;
>  	int				retval = 0;
>  	int				error = 0;
>  
> @@ -1222,13 +1223,7 @@ xfs_attr_node_addname_clear_incomplete(
>  	if (error)
>  		goto out;
>  
> -	/*
> -	 * Remove the name and update the hashvals in the tree.
> -	 */
> -	blk = &state->path.blk[state->path.active-1];
> -	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
> -	error = xfs_attr3_leaf_remove(blk->bp, args);
> -	xfs_da3_fixhashpath(state, &state->path);
> +	error = xfs_attr_node_remove_name(args, state);
>  
>  	/*
>  	 * Check to see if the tree needs to be collapsed.
> -- 
> 2.7.4
> 
