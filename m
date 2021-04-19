Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38C31C433B4
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Apr 2021 06:53:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0945F6113C
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Apr 2021 06:53:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231490AbhDSGxh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 19 Apr 2021 02:53:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbhDSGxg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 19 Apr 2021 02:53:36 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB7D1C06174A
        for <linux-xfs@vger.kernel.org>; Sun, 18 Apr 2021 23:53:07 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id t22so23617505pgu.0
        for <linux-xfs@vger.kernel.org>; Sun, 18 Apr 2021 23:53:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=Jo5xmsWW6L03ePKMthIAq+72H2aVRbAPSRXGbTtnewI=;
        b=o5FMGl826z4C2u7VaGL+SOprXU5ICvH4raXE5tPn/mLLTxSoWiNNopI/fiL6bnwSgP
         Gvq2ZEItcoHoqakCuSlYZQ3sVnpQ1HIIC7DVofPOdbCw/wEZaTJYHS8UY/y4wMilyqPW
         eFnF8qxYwY9VRnaFZpqTfsm2VwuB+JIZWBzVowb8FZxyg4/fYK3HoyYf1su46k/uoB6v
         TknD5izuTz34N8vshJLgFJY1CN2GXHZZFlszuODp1SYMziUpxCGCVtGh2qRpcjma5EI+
         BbrYEbgWZh/Mrh3JF98QTlLkxSP8cZZqYqlVkyWLypnlPzsJblB6WuYd9o5BD1d/3Os6
         oZXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=Jo5xmsWW6L03ePKMthIAq+72H2aVRbAPSRXGbTtnewI=;
        b=TgaGx+iH8kp6tyGSYYjU7H9yJD73L39SYWbF+WVZRa5jqamClq14nb9jUzqf7QHpQz
         3h7nf8VSMv59PXwaRUnr9RrGmuQN4RKikB6yCnuVNHWHliB35wtFO6iUF9otyAJ2UOkX
         AAlI6WLglGFAd5nOEgHcqx6XexLS0VPxVDbesCsAvvfQSCdD7J0nn66uvct9ul/5EdgW
         aT1vqWOtklZZa2kt3iCYbHK2mq39PAJ/boHy4ti45ncUV2GvGUfLkkgq3iMdgzrybOod
         63JTGZCP9zy8mXtwIKyS8TdJ+aIfvz8A5yfTQkloXvCvzr12bdM5wg52S5g2gEgUb+OL
         XXEg==
X-Gm-Message-State: AOAM532fxLUcpkcWKUY3MzsGqyZvyHHKZz9/swiRuahvfReaFIeoihdt
        4IZHF7QIg8dGIKUac0JmKvyBk5xByjs=
X-Google-Smtp-Source: ABdhPJzAHg07P/lN0t5RktW9gPCNQ0Jc0l2AAa+RNDpiZApoEiDX4+zqZMwSCoyOnvzXVJa/b1R7Ow==
X-Received: by 2002:a62:ed0b:0:b029:25c:9ea2:abea with SMTP id u11-20020a62ed0b0000b029025c9ea2abeamr8499494pfh.46.1618815187070;
        Sun, 18 Apr 2021 23:53:07 -0700 (PDT)
Received: from garuda ([122.179.111.183])
        by smtp.gmail.com with ESMTPSA id b23sm13878620pjh.5.2021.04.18.23.53.05
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 18 Apr 2021 23:53:06 -0700 (PDT)
References: <20210416092045.2215-1-allison.henderson@oracle.com> <20210416092045.2215-11-allison.henderson@oracle.com>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v17 10/11] xfs: Add delay ready attr remove routines
In-reply-to: <20210416092045.2215-11-allison.henderson@oracle.com>
Date:   Mon, 19 Apr 2021 12:23:03 +0530
Message-ID: <87lf9eix4g.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 16 Apr 2021 at 14:50, Allison Henderson wrote:
> This patch modifies the attr remove routines to be delay ready. This
> means they no longer roll or commit transactions, but instead return
> -EAGAIN to have the calling routine roll and refresh the transaction. In
> this series, xfs_attr_remove_args is merged with
> xfs_attr_node_removename become a new function, xfs_attr_remove_iter.
> This new version uses a sort of state machine like switch to keep track
> of where it was when EAGAIN was returned. A new version of
> xfs_attr_remove_args consists of a simple loop to refresh the
> transaction until the operation is completed. A new XFS_DAC_DEFER_FINISH
> flag is used to finish the transaction where ever the existing code used
> to.
>
> Calls to xfs_attr_rmtval_remove are replaced with the delay ready
> version __xfs_attr_rmtval_remove. We will rename
> __xfs_attr_rmtval_remove back to xfs_attr_rmtval_remove when we are
> done.
>
> xfs_attr_rmtval_remove itself is still in use by the set routines (used
> during a rename).  For reasons of preserving existing function, we
> modify xfs_attr_rmtval_remove to call xfs_defer_finish when the flag is
> set.  Similar to how xfs_attr_remove_args does here.  Once we transition
> the set routines to be delay ready, xfs_attr_rmtval_remove is no longer
> used and will be removed.
>
> This patch also adds a new struct xfs_delattr_context, which we will use
> to keep track of the current state of an attribute operation. The new
> xfs_delattr_state enum is used to track various operations that are in
> progress so that we know not to repeat them, and resume where we left
> off before EAGAIN was returned to cycle out the transaction. Other
> members take the place of local variables that need to retain their
> values across multiple function recalls.  See xfs_attr.h for a more
> detailed diagram of the states.
>
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c        | 208 +++++++++++++++++++++++++++-------------
>  fs/xfs/libxfs/xfs_attr.h        | 131 +++++++++++++++++++++++++
>  fs/xfs/libxfs/xfs_attr_leaf.c   |   2 +-
>  fs/xfs/libxfs/xfs_attr_remote.c |  48 ++++++----
>  fs/xfs/libxfs/xfs_attr_remote.h |   2 +-
>  fs/xfs/xfs_attr_inactive.c      |   2 +-
>  6 files changed, 305 insertions(+), 88 deletions(-)
>
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index ed06b60..0bea8dd 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -57,7 +57,6 @@ STATIC int xfs_attr_node_addname(struct xfs_da_args *args,
>  				 struct xfs_da_state *state);
>  STATIC int xfs_attr_node_addname_find_attr(struct xfs_da_args *args,
>  				 struct xfs_da_state **state);
> -STATIC int xfs_attr_node_removename(xfs_da_args_t *args);
>  STATIC int xfs_attr_node_addname_clear_incomplete(struct xfs_da_args *args);
>  STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
>  				 struct xfs_da_state **state);
> @@ -221,6 +220,31 @@ xfs_attr_is_shortform(
>  		ip->i_afp->if_nextents == 0);
>  }
>
> +/*
> + * Checks to see if a delayed attribute transaction should be rolled.  If so,
> + * transaction is finished or rolled as needed.
> + */
> +int
> +xfs_attr_trans_roll(
> +	struct xfs_delattr_context	*dac)
> +{
> +	struct xfs_da_args		*args = dac->da_args;
> +	int				error;
> +
> +	if (dac->flags & XFS_DAC_DEFER_FINISH) {
> +		/*
> +		 * The caller wants us to finish all the deferred ops so that we
> +		 * avoid pinning the log tail with a large number of deferred
> +		 * ops.
> +		 */
> +		dac->flags &= ~XFS_DAC_DEFER_FINISH;
> +		error = xfs_defer_finish(&args->trans);
> +	} else
> +		error = xfs_trans_roll_inode(&args->trans, args->dp);
> +
> +	return error;
> +}
> +
>  STATIC int
>  xfs_attr_set_fmt(
>  	struct xfs_da_args	*args)
> @@ -527,21 +551,23 @@ xfs_has_attr(
>   */
>  int
>  xfs_attr_remove_args(
> -	struct xfs_da_args      *args)
> +	struct xfs_da_args	*args)
>  {
> -	struct xfs_inode	*dp = args->dp;
> -	int			error;
> +	int				error;
> +	struct xfs_delattr_context	dac = {
> +		.da_args	= args,
> +	};
>
> -	if (!xfs_inode_hasattr(dp)) {
> -		error = -ENOATTR;
> -	} else if (dp->i_afp->if_format == XFS_DINODE_FMT_LOCAL) {
> -		ASSERT(dp->i_afp->if_flags & XFS_IFINLINE);
> -		error = xfs_attr_shortform_remove(args);
> -	} else if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
> -		error = xfs_attr_leaf_removename(args);
> -	} else {
> -		error = xfs_attr_node_removename(args);
> -	}
> +	do {
> +		error = xfs_attr_remove_iter(&dac);
> +		if (error != -EAGAIN)
> +			break;
> +
> +		error = xfs_attr_trans_roll(&dac);
> +		if (error)
> +			return error;
> +
> +	} while (true);
>
>  	return error;
>  }
> @@ -1187,14 +1213,16 @@ xfs_attr_leaf_mark_incomplete(
>   */
>  STATIC
>  int xfs_attr_node_removename_setup(
> -	struct xfs_da_args	*args,
> -	struct xfs_da_state	**state)
> +	struct xfs_delattr_context	*dac)
>  {
> -	int			error;
> +	struct xfs_da_args		*args = dac->da_args;
> +	struct xfs_da_state		**state = &dac->da_state;
> +	int				error;
>
>  	error = xfs_attr_node_hasname(args, state);
>  	if (error != -EEXIST)
>  		return error;
> +	error = 0;
>
>  	ASSERT((*state)->path.blk[(*state)->path.active - 1].bp != NULL);
>  	ASSERT((*state)->path.blk[(*state)->path.active - 1].magic ==
> @@ -1203,10 +1231,13 @@ int xfs_attr_node_removename_setup(
>  	if (args->rmtblkno > 0) {
>  		error = xfs_attr_leaf_mark_incomplete(args, *state);
>  		if (error)
> -			return error;
> +			goto out;
>
> -		return xfs_attr_rmtval_invalidate(args);
> +		error = xfs_attr_rmtval_invalidate(args);
>  	}
> +out:
> +	if (error)
> +		xfs_da_state_free(*state);
>
>  	return 0;

The above should be "return error". Otherwise, we might be missing out on
reporting failures from xfs_attr_leaf_mark_incomplete() or
xfs_attr_rmtval_invalidate().

>  }
> @@ -1231,70 +1262,117 @@ xfs_attr_node_remove_cleanup(
>  }
>
>  /*
> - * Remove a name from a B-tree attribute list.
> + * Remove the attribute specified in @args.
>   *
>   * This will involve walking down the Btree, and may involve joining
>   * leaf nodes and even joining intermediate nodes up to and including
>   * the root node (a special case of an intermediate node).
> + *
> + * This routine is meant to function as either an in-line or delayed operation,
> + * and may return -EAGAIN when the transaction needs to be rolled.  Calling
> + * functions will need to handle this, and recall the function until a
> + * successful error code is returned.
>   */
> -STATIC int
> -xfs_attr_node_removename(
> -	struct xfs_da_args	*args)
> +int
> +xfs_attr_remove_iter(
> +	struct xfs_delattr_context	*dac)
>  {
> -	struct xfs_da_state	*state;
> -	int			retval, error;
> -	struct xfs_inode	*dp = args->dp;
> +	struct xfs_da_args		*args = dac->da_args;
> +	struct xfs_da_state		*state = dac->da_state;
> +	int				retval, error;
> +	struct xfs_inode		*dp = args->dp;
>
>  	trace_xfs_attr_node_removename(args);
>
> -	error = xfs_attr_node_removename_setup(args, &state);
> -	if (error)
> -		goto out;
> +	switch (dac->dela_state) {
> +	case XFS_DAS_UNINIT:
> +		if (!xfs_inode_hasattr(dp))
> +			return -ENOATTR;
>
> -	/*
> -	 * If there is an out-of-line value, de-allocate the blocks.
> -	 * This is done before we remove the attribute so that we don't
> -	 * overflow the maximum size of a transaction and/or hit a deadlock.
> -	 */
> -	if (args->rmtblkno > 0) {
> -		error = xfs_attr_rmtval_remove(args);
> -		if (error)
> -			goto out;
> +		if (dp->i_afp->if_format == XFS_DINODE_FMT_LOCAL) {
> +			ASSERT(dp->i_afp->if_flags & XFS_IFINLINE);
> +			return xfs_attr_shortform_remove(args);
> +		}
> +
> +		if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
> +			return xfs_attr_leaf_removename(args);
> +
> +		if (!dac->da_state) {
> +			error = xfs_attr_node_removename_setup(dac);
> +			if (error)
> +				return error;
> +			state = dac->da_state;
> +		}
> +
> +	/* fallthrough */
> +	case XFS_DAS_RMTBLK:
> +		dac->dela_state = XFS_DAS_RMTBLK;
>
>  		/*
> -		 * Refill the state structure with buffers, the prior calls
> -		 * released our buffers.
> +		 * If there is an out-of-line value, de-allocate the blocks.
> +		 * This is done before we remove the attribute so that we don't
> +		 * overflow the maximum size of a transaction and/or hit a
> +		 * deadlock.
>  		 */
> -		error = xfs_attr_refillstate(state);
> -		if (error)
> -			goto out;
> -	}
> -	retval = xfs_attr_node_remove_cleanup(args, state);
> +		if (args->rmtblkno > 0) {
> +			/*
> +			 * May return -EAGAIN. Remove blocks until 0 is returned
> +			 */
> +			error = __xfs_attr_rmtval_remove(dac);
> +			if (error == -EAGAIN)
> +				return error;
> +			else if (error)
> +				goto out;
> +
> +			/*
> +			 * Refill the state structure with buffers, the prior
> +			 * calls released our buffers.
> +			 */
> +			ASSERT(args->rmtblkno == 0);
> +			error = xfs_attr_refillstate(state);
> +			if (error)
> +				goto out;
> +
> +			dac->dela_state = XFS_DAS_CLNUP;
> +			dac->flags |= XFS_DAC_DEFER_FINISH;
> +			return -EAGAIN;
> +		}
> +
> +	case XFS_DAS_CLNUP:
> +		retval = xfs_attr_node_remove_cleanup(args, state);
>
> -	/*
> -	 * Check to see if the tree needs to be collapsed.
> -	 */
> -	if (retval && (state->path.active > 1)) {
> -		error = xfs_da3_join(state);
> -		if (error)
> -			goto out;
> -		error = xfs_defer_finish(&args->trans);
> -		if (error)
> -			goto out;
>  		/*
> -		 * Commit the Btree join operation and start a new trans.
> +		 * Check to see if the tree needs to be collapsed. Set the flag
> +		 * to indicate that the calling function needs to move the
> +		 * shrink operation
>  		 */
> -		error = xfs_trans_roll_inode(&args->trans, dp);
> -		if (error)
> -			goto out;
> -	}
> +		if (retval && (state->path.active > 1)) {
> +			error = xfs_da3_join(state);
> +			if (error)
> +				goto out;
>
> -	/*
> -	 * If the result is small enough, push it all into the inode.
> -	 */
> -	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
> -		error = xfs_attr_node_shrink(args, state);
> +			dac->flags |= XFS_DAC_DEFER_FINISH;
> +			dac->dela_state = XFS_DAS_RM_SHRINK;
> +			return -EAGAIN;
> +		}
> +
> +		/* fallthrough */
> +	case XFS_DAS_RM_SHRINK:
> +		/*
> +		 * If the result is small enough, push it all into the inode.
> +		 */
> +		if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
> +			error = xfs_attr_node_shrink(args, state);
> +
> +		break;
> +	default:
> +		ASSERT(0);
> +		error = -EINVAL;
> +		goto out;
> +	}
>
> +	if (error == -EAGAIN)
> +		return error;

The above two statements probably not required. AFAICT, the call to
xfs_attr_node_shrink() is the only instance which can cause "error" to have a
non-zero return value if control reaches this point in the function. All other
locations in the function seem to either return from the function or jump to
"out" label on detecting an error.

>  out:
>  	if (state)
>  		xfs_da_state_free(state);

--
chandan
