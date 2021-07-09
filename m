Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F245BC07E99
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Jul 2021 04:17:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D400C6144C
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Jul 2021 04:17:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229710AbhGIEUJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 9 Jul 2021 00:20:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:59840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229441AbhGIEUJ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 9 Jul 2021 00:20:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B83F861447;
        Fri,  9 Jul 2021 04:17:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625804246;
        bh=0zntT4R6FbW1ILY/zVOQH4UFLl5popIkZ2hjeWyFSIg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PT6DS22d/ycgyZ5wNxDeTorqZ8d0wreWYHejebfutwM1Z/ZYcV/kk3Edx0n2Wv2MO
         YVEwWNMTXNOBt7jAOUJaAhsDRe0odFmbwk41C0aFJOEzRr28ILjRUuzDyufO3QvTaE
         f2ybftWl1zA9KU0cQUSXjA5OOmOzjX7HyG2hZtbzXLMSCqV9V5fYiGk6aJJRnhs7iw
         HznisgXYm1Ym8RzMXf9O/JClf3sPsX+aXPzgnG4Hx24rn8EjU6XOvSyiOMmu9kDZnS
         9LKWxJAILfPNR8nytkVne+fzOOQVye4JaHYeoYG2/BVPXvc9wHhXUuxZBME8nIi3jg
         qcDagjWm3uYHw==
Date:   Thu, 8 Jul 2021 21:17:26 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v21 13/13] xfs: Add helper function xfs_attr_leaf_addname
Message-ID: <20210709041726.GR11588@locust>
References: <20210707222111.16339-1-allison.henderson@oracle.com>
 <20210707222111.16339-14-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210707222111.16339-14-allison.henderson@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 07, 2021 at 03:21:11PM -0700, Allison Henderson wrote:
> This patch adds a helper function xfs_attr_leaf_addname.  While this
> does help to break down xfs_attr_set_iter, it does also hoist out some
> of the state management.  This patch has been moved to the end of the
> clean up series for further discussion.
> 
> Suggested-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c | 107 ++++++++++++++++++++++++++---------------------
>  fs/xfs/xfs_trace.h       |   1 +
>  2 files changed, 60 insertions(+), 48 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index cb7e689..80486b4 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -284,6 +284,64 @@ xfs_attr_sf_addname(
>  	return -EAGAIN;
>  }
>  
> +STATIC int
> +xfs_attr_leaf_addname(
> +	struct xfs_attr_item	*attr)
> +{
> +	struct xfs_da_args	*args = attr->xattri_da_args;
> +	struct xfs_buf		*leaf_bp = attr->xattri_leaf_bp;
> +	struct xfs_inode	*dp = args->dp;
> +	int			error;
> +
> +	if (xfs_attr_is_leaf(dp)) {
> +		error = xfs_attr_leaf_try_add(args, leaf_bp);
> +		if (error == -ENOSPC) {
> +			error = xfs_attr3_leaf_to_node(args);
> +			if (error)
> +				return error;
> +
> +			/*
> +			 * Finish any deferred work items and roll the
> +			 * transaction once more.  The goal here is to call
> +			 * node_addname with the inode and transaction in the
> +			 * same state (inode locked and joined, transaction
> +			 * clean) no matter how we got to this step.
> +			 *
> +			 * At this point, we are still in XFS_DAS_UNINIT, but
> +			 * when we come back, we'll be a node, so we'll fall
> +			 * down into the node handling code below
> +			 */
> +			trace_xfs_attr_set_iter_return(
> +				attr->xattri_dela_state, args->dp);
> +			return -EAGAIN;
> +		} else if (error) {

Silly nit: No need for else if, regular if works fine here.

Oh, hm, this is just a hoist patch, and we're not supposed to
hoist-and-mutate.  But this is a small change, so fmeh rules.

With that tidied,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> +			return error;
> +		}
> +
> +		attr->xattri_dela_state = XFS_DAS_FOUND_LBLK;
> +	} else {
> +		error = xfs_attr_node_addname_find_attr(attr);
> +		if (error)
> +			return error;
> +
> +		error = xfs_attr_node_addname(attr);
> +		if (error)
> +			return error;
> +
> +		/*
> +		 * If addname was successful, and we dont need to alloc or
> +		 * remove anymore blks, we're done.
> +		 */
> +		if (!args->rmtblkno && !args->rmtblkno2)
> +			return error;
> +
> +		attr->xattri_dela_state = XFS_DAS_FOUND_NBLK;
> +	}
> +
> +	trace_xfs_attr_leaf_addname_return(attr->xattri_dela_state, args->dp);
> +	return -EAGAIN;
> +}
> +
>  /*
>   * Set the attribute specified in @args.
>   * This routine is meant to function as a delayed operation, and may return
> @@ -319,55 +377,8 @@ xfs_attr_set_iter(
>  			*leaf_bp = NULL;
>  		}
>  
> -		if (xfs_attr_is_leaf(dp)) {
> -			error = xfs_attr_leaf_try_add(args, *leaf_bp);
> -			if (error == -ENOSPC) {
> -				error = xfs_attr3_leaf_to_node(args);
> -				if (error)
> -					return error;
> -
> -				/*
> -				 * Finish any deferred work items and roll the
> -				 * transaction once more.  The goal here is to
> -				 * call node_addname with the inode and
> -				 * transaction in the same state (inode locked
> -				 * and joined, transaction clean) no matter how
> -				 * we got to this step.
> -				 *
> -				 * At this point, we are still in
> -				 * XFS_DAS_UNINIT, but when we come back, we'll
> -				 * be a node, so we'll fall down into the node
> -				 * handling code below
> -				 */
> -				trace_xfs_attr_set_iter_return(
> -					attr->xattri_dela_state, args->dp);
> -				return -EAGAIN;
> -			} else if (error) {
> -				return error;
> -			}
> -
> -			attr->xattri_dela_state = XFS_DAS_FOUND_LBLK;
> -		} else {
> -			error = xfs_attr_node_addname_find_attr(attr);
> -			if (error)
> -				return error;
> +		return xfs_attr_leaf_addname(attr);
>  
> -			error = xfs_attr_node_addname(attr);
> -			if (error)
> -				return error;
> -
> -			/*
> -			 * If addname was successful, and we dont need to alloc
> -			 * or remove anymore blks, we're done.
> -			 */
> -			if (!args->rmtblkno && !args->rmtblkno2)
> -				return error;
> -
> -			attr->xattri_dela_state = XFS_DAS_FOUND_NBLK;
> -		}
> -		trace_xfs_attr_set_iter_return(attr->xattri_dela_state,
> -					       args->dp);
> -		return -EAGAIN;
>  	case XFS_DAS_FOUND_LBLK:
>  		/*
>  		 * If there was an out-of-line value, allocate the blocks we
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index f9840dd..cf8bd3a 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -4008,6 +4008,7 @@ DEFINE_EVENT(xfs_das_state_class, name, \
>  	TP_ARGS(das, ip))
>  DEFINE_DAS_STATE_EVENT(xfs_attr_sf_addname_return);
>  DEFINE_DAS_STATE_EVENT(xfs_attr_set_iter_return);
> +DEFINE_DAS_STATE_EVENT(xfs_attr_leaf_addname_return);
>  DEFINE_DAS_STATE_EVENT(xfs_attr_node_addname_return);
>  DEFINE_DAS_STATE_EVENT(xfs_attr_remove_iter_return);
>  DEFINE_DAS_STATE_EVENT(xfs_attr_rmtval_remove_return);
> -- 
> 2.7.4
> 
