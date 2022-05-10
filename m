Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71C03C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 10 May 2022 23:15:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231211AbiEJXPt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 May 2022 19:15:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232316AbiEJXPr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 May 2022 19:15:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 219BA20185
        for <linux-xfs@vger.kernel.org>; Tue, 10 May 2022 16:15:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CA90DB81983
        for <linux-xfs@vger.kernel.org>; Tue, 10 May 2022 23:15:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4382CC385CC;
        Tue, 10 May 2022 23:15:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652224542;
        bh=9a0XLtkZbUBjczvM/b2JaAdN03i1o642SuBwCtmJj3U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UaE8jzs3xq6+ER17aM9tOcoHxfdijP2zIHwyHUf0XJ4sbO4Jn4+JNBxkuHz2WnSVu
         Hf9BFBIPdyKSDDJQbgOq7Ya4z6kIuYVycXWbac88a4Go/YbCIkhfEhCkO4qboPez+q
         mKp7abwiikIpyE3Y+vKMpOpsqdWT8welV5VwCTP2hv3BsfQ+ZL/hCTPhUg2I6h0GNr
         7Dd1bKMnJNTDZnbkALBYMf2QrGJZxmoJsd9kaKUFdGyCGsDEmvnw6HgP7vRHKtXzPd
         8cZMV0U2rHm05w61DzJv3N6HMw4XwWMec55OVTx9HcZu5hMcIU+Te1/jXpOzqfAYNt
         f7YoZJ442SW2A==
Date:   Tue, 10 May 2022 16:15:41 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/18] xfs: kill XFS_DAC_LEAF_ADDNAME_INIT
Message-ID: <20220510231541.GJ27195@magnolia>
References: <20220509004138.762556-1-david@fromorbit.com>
 <20220509004138.762556-7-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220509004138.762556-7-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 09, 2022 at 10:41:26AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> We re-enter the XFS_DAS_FOUND_LBLK state when we have to allocate
> multiple extents for a remote xattr. We currently have a flag
> called XFS_DAC_LEAF_ADDNAME_INIT to avoid running the remote attr
> hole finding code more than once.
> 
> However, for the node format tree, we have a separate state for this
> so we never reenter the state machine at XFS_DAS_FOUND_NBLK and so
> it does not need a special flag to skip over the remote attr hold
> finding code.
> 
> Convert the leaf block code to use the same state machine as the
> node blocks and kill the  XFS_DAC_LEAF_ADDNAME_INIT flag.
> 
> This further points out that this "ALLOC" state is only traversed
> if we have remote xattrs or we are doing a rename operation. Rename
> both the leaf and node alloc states to _ALLOC_RMT to indicate they
> are iterating to do allocation of remote xattr blocks.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Allison Henderson<allison.henderson@oracle.com>

I agree this is a good idea to have rmtval allocation as separate
states in the machine.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_attr.c | 45 ++++++++++++++++++++--------------------
>  fs/xfs/libxfs/xfs_attr.h |  6 ++++--
>  fs/xfs/xfs_trace.h       |  3 ++-
>  3 files changed, 29 insertions(+), 25 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index edc31075fde4..ab8a884af512 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -406,40 +406,41 @@ xfs_attr_set_iter(
>  		return xfs_attr_node_addname(attr);
>  
>  	case XFS_DAS_FOUND_LBLK:
> +		/*
> +		 * Find space for remote blocks and fall into the allocation
> +		 * state.
> +		 */
> +		if (args->rmtblkno > 0) {
> +			error = xfs_attr_rmtval_find_space(attr);
> +			if (error)
> +				return error;
> +		}
> +		attr->xattri_dela_state = XFS_DAS_LEAF_ALLOC_RMT;
> +		fallthrough;
> +	case XFS_DAS_LEAF_ALLOC_RMT:
> +
>  		/*
>  		 * If there was an out-of-line value, allocate the blocks we
>  		 * identified for its storage and copy the value.  This is done
>  		 * after we create the attribute so that we don't overflow the
>  		 * maximum size of a transaction and/or hit a deadlock.
>  		 */
> -
> -		/* Open coded xfs_attr_rmtval_set without trans handling */
> -		if ((attr->xattri_flags & XFS_DAC_LEAF_ADDNAME_INIT) == 0) {
> -			attr->xattri_flags |= XFS_DAC_LEAF_ADDNAME_INIT;
> -			if (args->rmtblkno > 0) {
> -				error = xfs_attr_rmtval_find_space(attr);
> +		if (args->rmtblkno > 0) {
> +			if (attr->xattri_blkcnt > 0) {
> +				error = xfs_attr_rmtval_set_blk(attr);
>  				if (error)
>  					return error;
> +				trace_xfs_attr_set_iter_return(
> +						attr->xattri_dela_state,
> +						args->dp);
> +				return -EAGAIN;
>  			}
> -		}
>  
> -		/*
> -		 * Repeat allocating remote blocks for the attr value until
> -		 * blkcnt drops to zero.
> -		 */
> -		if (attr->xattri_blkcnt > 0) {
> -			error = xfs_attr_rmtval_set_blk(attr);
> +			error = xfs_attr_rmtval_set_value(args);
>  			if (error)
>  				return error;
> -			trace_xfs_attr_set_iter_return(attr->xattri_dela_state,
> -						       args->dp);
> -			return -EAGAIN;
>  		}
>  
> -		error = xfs_attr_rmtval_set_value(args);
> -		if (error)
> -			return error;
> -
>  		/*
>  		 * If this is not a rename, clear the incomplete flag and we're
>  		 * done.
> @@ -534,15 +535,15 @@ xfs_attr_set_iter(
>  				return error;
>  		}
>  
> +		attr->xattri_dela_state = XFS_DAS_NODE_ALLOC_RMT;
>  		fallthrough;
> -	case XFS_DAS_ALLOC_NODE:
> +	case XFS_DAS_NODE_ALLOC_RMT:
>  		/*
>  		 * If there was an out-of-line value, allocate the blocks we
>  		 * identified for its storage and copy the value.  This is done
>  		 * after we create the attribute so that we don't overflow the
>  		 * maximum size of a transaction and/or hit a deadlock.
>  		 */
> -		attr->xattri_dela_state = XFS_DAS_ALLOC_NODE;
>  		if (args->rmtblkno > 0) {
>  			if (attr->xattri_blkcnt > 0) {
>  				error = xfs_attr_rmtval_set_blk(attr);
> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> index ad52b5dc59e4..d016af4dbf81 100644
> --- a/fs/xfs/libxfs/xfs_attr.h
> +++ b/fs/xfs/libxfs/xfs_attr.h
> @@ -451,11 +451,12 @@ enum xfs_delattr_state {
>  	XFS_DAS_RM_NAME,		/* Remove attr name */
>  	XFS_DAS_RM_SHRINK,		/* We are shrinking the tree */
>  	XFS_DAS_FOUND_LBLK,		/* We found leaf blk for attr */
> +	XFS_DAS_LEAF_ALLOC_RMT,		/* We are allocating remote blocks */
>  	XFS_DAS_FOUND_NBLK,		/* We found node blk for attr */
> +	XFS_DAS_NODE_ALLOC_RMT,		/* We are allocating remote blocks */
>  	XFS_DAS_FLIP_LFLAG,		/* Flipped leaf INCOMPLETE attr flag */
>  	XFS_DAS_RM_LBLK,		/* A rename is removing leaf blocks */
>  	XFS_DAS_RD_LEAF,		/* Read in the new leaf */
> -	XFS_DAS_ALLOC_NODE,		/* We are allocating node blocks */
>  	XFS_DAS_FLIP_NFLAG,		/* Flipped node INCOMPLETE attr flag */
>  	XFS_DAS_RM_NBLK,		/* A rename is removing node blocks */
>  	XFS_DAS_CLR_FLAG,		/* Clear incomplete flag */
> @@ -471,11 +472,12 @@ enum xfs_delattr_state {
>  	{ XFS_DAS_RM_NAME,	"XFS_DAS_RM_NAME" }, \
>  	{ XFS_DAS_RM_SHRINK,	"XFS_DAS_RM_SHRINK" }, \
>  	{ XFS_DAS_FOUND_LBLK,	"XFS_DAS_FOUND_LBLK" }, \
> +	{ XFS_DAS_LEAF_ALLOC_RMT, "XFS_DAS_LEAF_ALLOC_RMT" }, \
>  	{ XFS_DAS_FOUND_NBLK,	"XFS_DAS_FOUND_NBLK" }, \
> +	{ XFS_DAS_NODE_ALLOC_RMT, "XFS_DAS_NODE_ALLOC_RMT" },  \
>  	{ XFS_DAS_FLIP_LFLAG,	"XFS_DAS_FLIP_LFLAG" }, \
>  	{ XFS_DAS_RM_LBLK,	"XFS_DAS_RM_LBLK" }, \
>  	{ XFS_DAS_RD_LEAF,	"XFS_DAS_RD_LEAF" }, \
> -	{ XFS_DAS_ALLOC_NODE,	"XFS_DAS_ALLOC_NODE" }, \
>  	{ XFS_DAS_FLIP_NFLAG,	"XFS_DAS_FLIP_NFLAG" }, \
>  	{ XFS_DAS_RM_NBLK,	"XFS_DAS_RM_NBLK" }, \
>  	{ XFS_DAS_CLR_FLAG,	"XFS_DAS_CLR_FLAG" }, \
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index 8f722be25c29..067ab31d7a20 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -4137,11 +4137,12 @@ TRACE_DEFINE_ENUM(XFS_DAS_RMTBLK);
>  TRACE_DEFINE_ENUM(XFS_DAS_RM_NAME);
>  TRACE_DEFINE_ENUM(XFS_DAS_RM_SHRINK);
>  TRACE_DEFINE_ENUM(XFS_DAS_FOUND_LBLK);
> +TRACE_DEFINE_ENUM(XFS_DAS_LEAF_ALLOC_RMT);
>  TRACE_DEFINE_ENUM(XFS_DAS_FOUND_NBLK);
> +TRACE_DEFINE_ENUM(XFS_DAS_NODE_ALLOC_RMT);
>  TRACE_DEFINE_ENUM(XFS_DAS_FLIP_LFLAG);
>  TRACE_DEFINE_ENUM(XFS_DAS_RM_LBLK);
>  TRACE_DEFINE_ENUM(XFS_DAS_RD_LEAF);
> -TRACE_DEFINE_ENUM(XFS_DAS_ALLOC_NODE);
>  TRACE_DEFINE_ENUM(XFS_DAS_FLIP_NFLAG);
>  TRACE_DEFINE_ENUM(XFS_DAS_RM_NBLK);
>  TRACE_DEFINE_ENUM(XFS_DAS_CLR_FLAG);
> -- 
> 2.35.1
> 
