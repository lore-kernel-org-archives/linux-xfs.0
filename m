Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8292BC433DB
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Feb 2021 04:07:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4705364EE3
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Feb 2021 04:07:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229599AbhBZEHg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Feb 2021 23:07:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:56330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229498AbhBZEHf (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 25 Feb 2021 23:07:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E16E364F1F;
        Fri, 26 Feb 2021 04:06:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614312414;
        bh=qidtUx29+PGe4K8/6/p4zCEwqBtTBM+Go/N3g4rD7mU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DT8rjvzoMGgJmLBq8WrpDfXkW5YSh85OJj8CgV0Wx01RpdI4om/JFN9cCpp1hpwQs
         7zABvwrIKp3xyy8KapRjx6qEb9XCpc/1kPZkD0EvNAOmiPKBxfZrGTpGYWwMz/adeM
         aOKl3mklgxZjEUX6vd8o/y021+orxbn+IfO/xv6hiZGKAYPfeoCjLKpVYbLZE+3QgC
         cuUF4ljwo9y3BmLQ34DBy5aHkRoBv+SBdBFfBreSUFORMPQt6eca2WD0K41khsq5Fy
         dyTdQ7gY1AZYI434sscKrBpvbRT5kKgJ+A5wg1IhlTTotq6tjGrKea2wZFa5LiFeRH
         SCamCCb3PNOKw==
Date:   Thu, 25 Feb 2021 20:06:54 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v15 07/22] xfs: Add helper xfs_attr_node_addname_find_attr
Message-ID: <20210226040654.GU7272@magnolia>
References: <20210218165348.4754-1-allison.henderson@oracle.com>
 <20210218165348.4754-8-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210218165348.4754-8-allison.henderson@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 18, 2021 at 09:53:33AM -0700, Allison Henderson wrote:
> This patch separates the first half of xfs_attr_node_addname into a
> helper function xfs_attr_node_addname_find_attr.  It also replaces the
> restart goto with with an EAGAIN return code driven by a loop in the
> calling function.  This looks odd now, but will clean up nicly once we
> introduce the state machine.  It will also enable hoisting the last
> state out of xfs_attr_node_addname with out having to plumb in a "done"
> parameter to know if we need to move to the next state or not.
> 
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>

Looks ok to me,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_attr.c | 80 ++++++++++++++++++++++++++++++------------------
>  1 file changed, 51 insertions(+), 29 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index bee8d3fb..4333b61 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -52,7 +52,10 @@ STATIC int xfs_attr_leaf_hasname(struct xfs_da_args *args, struct xfs_buf **bp);
>   * Internal routines when attribute list is more than one block.
>   */
>  STATIC int xfs_attr_node_get(xfs_da_args_t *args);
> -STATIC int xfs_attr_node_addname(xfs_da_args_t *args);
> +STATIC int xfs_attr_node_addname(struct xfs_da_args *args,
> +				 struct xfs_da_state *state);
> +STATIC int xfs_attr_node_addname_find_attr(struct xfs_da_args *args,
> +				 struct xfs_da_state **state);
>  STATIC int xfs_attr_node_removename(xfs_da_args_t *args);
>  STATIC int xfs_attr_node_addname_work(struct xfs_da_args *args);
>  STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
> @@ -265,6 +268,7 @@ xfs_attr_set_args(
>  	struct xfs_da_args	*args)
>  {
>  	struct xfs_inode	*dp = args->dp;
> +	struct xfs_da_state     *state;
>  	int			error;
>  
>  	/*
> @@ -310,7 +314,14 @@ xfs_attr_set_args(
>  			return error;
>  	}
>  
> -	return xfs_attr_node_addname(args);
> +	do {
> +		error = xfs_attr_node_addname_find_attr(args, &state);
> +		if (error)
> +			return error;
> +		error = xfs_attr_node_addname(args, state);
> +	} while (error == -EAGAIN);
> +
> +	return error;
>  }
>  
>  /*
> @@ -883,42 +894,21 @@ xfs_attr_node_hasname(
>   * External routines when attribute list size > geo->blksize
>   *========================================================================*/
>  
> -/*
> - * Add a name to a Btree-format attribute list.
> - *
> - * This will involve walking down the Btree, and may involve splitting
> - * leaf nodes and even splitting intermediate nodes up to and including
> - * the root node (a special case of an intermediate node).
> - *
> - * "Remote" attribute values confuse the issue and atomic rename operations
> - * add a whole extra layer of confusion on top of that.
> - */
>  STATIC int
> -xfs_attr_node_addname(
> -	struct xfs_da_args	*args)
> +xfs_attr_node_addname_find_attr(
> +	struct xfs_da_args	*args,
> +	struct xfs_da_state     **state)
>  {
> -	struct xfs_da_state	*state;
> -	struct xfs_da_state_blk	*blk;
> -	struct xfs_inode	*dp;
> -	int			retval, error;
> -
> -	trace_xfs_attr_node_addname(args);
> +	int			retval;
>  
>  	/*
> -	 * Fill in bucket of arguments/results/context to carry around.
> -	 */
> -	dp = args->dp;
> -restart:
> -	/*
>  	 * Search to see if name already exists, and get back a pointer
>  	 * to where it should go.
>  	 */
> -	retval = xfs_attr_node_hasname(args, &state);
> +	retval = xfs_attr_node_hasname(args, state);
>  	if (retval != -ENOATTR && retval != -EEXIST)
>  		goto out;
>  
> -	blk = &state->path.blk[ state->path.active-1 ];
> -	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
>  	if (retval == -ENOATTR && (args->attr_flags & XATTR_REPLACE))
>  		goto out;
>  	if (retval == -EEXIST) {
> @@ -941,6 +931,38 @@ xfs_attr_node_addname(
>  		args->rmtvaluelen = 0;
>  	}
>  
> +	return 0;
> +out:
> +	if (*state)
> +		xfs_da_state_free(*state);
> +	return retval;
> +}
> +
> +/*
> + * Add a name to a Btree-format attribute list.
> + *
> + * This will involve walking down the Btree, and may involve splitting
> + * leaf nodes and even splitting intermediate nodes up to and including
> + * the root node (a special case of an intermediate node).
> + *
> + * "Remote" attribute values confuse the issue and atomic rename operations
> + * add a whole extra layer of confusion on top of that.
> + */
> +STATIC int
> +xfs_attr_node_addname(
> +	struct xfs_da_args	*args,
> +	struct xfs_da_state	*state)
> +{
> +	struct xfs_da_state_blk	*blk;
> +	struct xfs_inode	*dp;
> +	int			retval, error;
> +
> +	trace_xfs_attr_node_addname(args);
> +
> +	dp = args->dp;
> +	blk = &state->path.blk[state->path.active-1];
> +	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
> +
>  	retval = xfs_attr3_leaf_add(blk->bp, state->args);
>  	if (retval == -ENOSPC) {
>  		if (state->path.active == 1) {
> @@ -966,7 +988,7 @@ xfs_attr_node_addname(
>  			if (error)
>  				goto out;
>  
> -			goto restart;
> +			return -EAGAIN;
>  		}
>  
>  		/*
> -- 
> 2.7.4
> 
