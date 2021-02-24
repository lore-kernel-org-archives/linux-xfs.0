Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BA58C433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Feb 2021 18:48:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3BC8065052
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Feb 2021 18:48:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235259AbhBXSsO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Feb 2021 13:48:14 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:32750 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235187AbhBXSsE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Feb 2021 13:48:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614192395;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yLHypIHltgngKx/EFSG4+tkmYxk3pO4jG6nkg4V8V2I=;
        b=N8fYqwQ8s+YaHApdT0p+ZjZuBkXidg4Wl7QCNi55an6aHrmhQ8Sn4dA3IRnZCBWd02DpEZ
        /pkCElygRZ/QS77a2sQJFTquTfz4Cn+X7Hvx/1rRgswIDE28X0nCMYQNZPzbZTlUzW6zZN
        iLk+DwJji4emLjJRx9gd6xKtrd4VvqA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-296-Kn-e6IkKOZOkiAsZF1H1Ug-1; Wed, 24 Feb 2021 13:46:31 -0500
X-MC-Unique: Kn-e6IkKOZOkiAsZF1H1Ug-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A65BF8A8F07;
        Wed, 24 Feb 2021 18:45:48 +0000 (UTC)
Received: from bfoster (ovpn-119-92.rdu2.redhat.com [10.10.119.92])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3355D5D6AD;
        Wed, 24 Feb 2021 18:45:48 +0000 (UTC)
Date:   Wed, 24 Feb 2021 13:45:46 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v15 11/22] xfs: Add delay ready attr remove routines
Message-ID: <20210224184546.GL981777@bfoster>
References: <20210218165348.4754-1-allison.henderson@oracle.com>
 <20210218165348.4754-12-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210218165348.4754-12-allison.henderson@oracle.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 18, 2021 at 09:53:37AM -0700, Allison Henderson wrote:
> This patch modifies the attr remove routines to be delay ready. This
> means they no longer roll or commit transactions, but instead return
> -EAGAIN to have the calling routine roll and refresh the transaction. In
> this series, xfs_attr_remove_args has become xfs_attr_remove_iter, which
> uses a sort of state machine like switch to keep track of where it was
> when EAGAIN was returned. xfs_attr_node_removename has also been
> modified to use the switch, and a new version of xfs_attr_remove_args
> consists of a simple loop to refresh the transaction until the operation
> is completed. A new XFS_DAC_DEFER_FINISH flag is used to finish the
> transaction where ever the existing code used to.
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
>  fs/xfs/libxfs/xfs_attr.c        | 223 +++++++++++++++++++++++++++++-----------
>  fs/xfs/libxfs/xfs_attr.h        | 100 ++++++++++++++++++
>  fs/xfs/libxfs/xfs_attr_leaf.c   |   2 +-
>  fs/xfs/libxfs/xfs_attr_remote.c |  48 +++++----
>  fs/xfs/libxfs/xfs_attr_remote.h |   2 +-
>  fs/xfs/xfs_attr_inactive.c      |   2 +-
>  6 files changed, 294 insertions(+), 83 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 56d4b56..d46b92a 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
...
> @@ -221,6 +221,34 @@ xfs_attr_is_shortform(
>  		ip->i_afp->if_nextents == 0);
>  }
>  
> +/*
> + * Checks to see if a delayed attribute transaction should be rolled.  If so,
> + * also checks for a defer finish.  Transaction is finished and rolled as
> + * needed, and returns true of false if the delayed operation should continue.
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
> +		if (error)
> +			return error;

No need for the error check here.

> +	} else
> +		error = xfs_trans_roll_inode(&args->trans, args->dp);
> +
> +	return error;
> +}
> +
>  STATIC int
>  xfs_attr_set_fmt(
>  	struct xfs_da_args	*args)
> @@ -531,23 +559,58 @@ xfs_has_attr(
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
> +
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
> +
> +	return error;
> +}
> +
> +/*
> + * Remove the attribute specified in @args.
> + *
> + * This function may return -EAGAIN to signal that the transaction needs to be
> + * rolled.  Callers should continue calling this function until they receive a
> + * return value other than -EAGAIN.
> + */
> +int
> +xfs_attr_remove_iter(
> +	struct xfs_delattr_context	*dac)
> +{
> +	struct xfs_da_args		*args = dac->da_args;
> +	struct xfs_inode		*dp = args->dp;
>  
> -	if (!xfs_inode_hasattr(dp)) {
> -		error = -ENOATTR;
> -	} else if (dp->i_afp->if_format == XFS_DINODE_FMT_LOCAL) {
> +	/* If we are shrinking a node, resume shrink */
> +	if (dac->dela_state == XFS_DAS_RM_SHRINK)
> +		goto node;
> +
> +	if (!xfs_inode_hasattr(dp))
> +		return -ENOATTR;
> +
> +	if (dp->i_afp->if_format == XFS_DINODE_FMT_LOCAL) {
>  		ASSERT(dp->i_afp->if_flags & XFS_IFINLINE);
> -		error = xfs_attr_shortform_remove(args);
> -	} else if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
> -		error = xfs_attr_leaf_removename(args);
> -	} else {
> -		error = xfs_attr_node_removename(args);
> +		return xfs_attr_shortform_remove(args);
>  	}
>  
> -	return error;
> +	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
> +		return xfs_attr_leaf_removename(args);
> +node:
> +	/* If we are not short form or leaf, then proceed to remove node */
> +	return  xfs_attr_node_removename_iter(dac);

Extra whitespace before the function name;

Also, can we lift xfs_attr_node_removename_iter() into this function,
form the current implementation of xfs_attr_remove_iter() into the
UNINIT state, and move the current UNINIT state into a new RMT_BLK state
to support reentry? ISTM that would condense everything to a single
switch statement that can live inside xfs_attr_remove_iter(). IOW, we
can kill off the 'node:' level and multi-layer state management here.
Hm?

>  }
>  
>  /*
...
> @@ -1207,22 +1272,28 @@ int xfs_attr_node_removename_setup(
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
>  }
>  
>  STATIC int
> -xfs_attr_node_remove_rmt(
> -	struct xfs_da_args	*args,
> -	struct xfs_da_state	*state)
> +xfs_attr_node_remove_rmt (

Extra whitespace before the opening brace.

> +	struct xfs_delattr_context	*dac,
> +	struct xfs_da_state		*state)
>  {
> -	int			error = 0;
> +	int				error = 0;
>  
> -	error = xfs_attr_rmtval_remove(args);
> +	/*
> +	 * May return -EAGAIN to request that the caller recall this function
> +	 */
> +	error = __xfs_attr_rmtval_remove(dac);
>  	if (error)
>  		return error;
>  
...
> @@ -1285,51 +1365,74 @@ xfs_attr_node_remove_step(
>   *
>   * This routine will find the blocks of the name to remove, remove them and
>   * shrink the tree if needed.
> + *
> + * This routine is meant to function as either an inline or delayed operation,
> + * and may return -EAGAIN when the transaction needs to be rolled.  Calling
> + * functions will need to handle this, and recall the function until a
> + * successful error code is returned.
>   */
>  STATIC int
> -xfs_attr_node_removename(
> -	struct xfs_da_args	*args)
> +xfs_attr_node_removename_iter(
> +	struct xfs_delattr_context	*dac)
>  {
> -	struct xfs_da_state	*state = NULL;
> -	int			retval, error;
> -	struct xfs_inode	*dp = args->dp;
> +	struct xfs_da_args		*args = dac->da_args;
> +	struct xfs_da_state		*state = NULL;
> +	int				retval, error;
> +	struct xfs_inode		*dp = args->dp;
>  
>  	trace_xfs_attr_node_removename(args);
>  
> -	error = xfs_attr_node_removename_setup(args, &state);
> -	if (error)
> -		goto out;
> -
> -	error = xfs_attr_node_remove_step(args, state);
> -	if (error)
> -		goto out;
> -
> -	retval = xfs_attr_node_remove_cleanup(args, state);
> -
> -	/*
> -	 * Check to see if the tree needs to be collapsed.
> -	 */
> -	if (retval && (state->path.active > 1)) {
> -		error = xfs_da3_join(state);
> -		if (error)
> -			goto out;
> -		error = xfs_defer_finish(&args->trans);
> +	if (!dac->da_state) {
> +		error = xfs_attr_node_removename_setup(dac);
>  		if (error)
>  			goto out;
> +	}
> +	state = dac->da_state;
> +
> +	switch (dac->dela_state) {
> +	case XFS_DAS_UNINIT:
>  		/*
> -		 * Commit the Btree join operation and start a new trans.
> +		 * repeatedly remove remote blocks, remove the entry and join.
> +		 * returns -EAGAIN or 0 for completion of the step.
>  		 */
> -		error = xfs_trans_roll_inode(&args->trans, dp);
> +		error = xfs_attr_node_remove_step(dac);
>  		if (error)
> -			goto out;
> -	}
> +			break;

Hmm.. so re: my comment further down on xfs_attr_rmtval_remove(),
wouldn't that change semantics here? I.e., once remote blocks are
removed this would previously carry on with a clean transaction. Now it
looks like we'd carry on with the dirty transaction that removed the
last remote extent. This suggests that perhaps we should return once
more and fall into a new state to remove the name..? Also, it would be
nice to remove the several seemingly unnecessary layers of indirection
here. For example, something like the following (also considering my
comment above wrt to xfs_attr_remove_iter() and UNINIT):

	case UNINIT:
		...
		/* fallthrough */
	case RMTBLK:
		if (args->rmtblkno > 0) {
			dac->dela_state = RMTBLK;
			error = __xfs_attr_rmtval_remove(dac);
			if (error)
				break;

			ASSERT(args->rmtblkno == 0);
			xfs_attr_refillstate(state);
			dac->flags |= XFS_DAC_DEFER_FINISH;
			dac->dela_state = RMNAME;
			return -EAGAIN;
		}
		/* fallthrough */
	case RMNAME:
		...
	...

>  
> -	/*
> -	 * If the result is small enough, push it all into the inode.
> -	 */
> -	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
> -		error = xfs_attr_node_shrink(args, state);
> +		retval = xfs_attr_node_remove_cleanup(args, state);
>  
...
> diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
> index 48d8e9c..f09820c 100644
> --- a/fs/xfs/libxfs/xfs_attr_remote.c
> +++ b/fs/xfs/libxfs/xfs_attr_remote.c
...
> @@ -685,31 +687,29 @@ xfs_attr_rmtval_remove(
>  	 * Keep de-allocating extents until the remote-value region is gone.
>  	 */
>  	do {
> -		retval = __xfs_attr_rmtval_remove(args);
> -		if (retval && retval != -EAGAIN)
> -			return retval;
> +		error = __xfs_attr_rmtval_remove(&dac);
> +		if (error != -EAGAIN)
> +			break;

Previously this would roll once and exit the loop on retval == 0. Now it
looks like we break out of the loop immediately. Why the change?

Brian

>  
> -		/*
> -		 * Close out trans and start the next one in the chain.
> -		 */
> -		error = xfs_trans_roll_inode(&args->trans, args->dp);
> +		error = xfs_attr_trans_roll(&dac);
>  		if (error)
>  			return error;
> -	} while (retval == -EAGAIN);
> +	} while (true);
>  
> -	return 0;
> +	return error;
>  }
>  
>  /*
>   * Remove the value associated with an attribute by deleting the out-of-line
> - * buffer that it is stored on. Returns EAGAIN for the caller to refresh the
> + * buffer that it is stored on. Returns -EAGAIN for the caller to refresh the
>   * transaction and re-call the function
>   */
>  int
>  __xfs_attr_rmtval_remove(
> -	struct xfs_da_args	*args)
> +	struct xfs_delattr_context	*dac)
>  {
> -	int			error, done;
> +	struct xfs_da_args		*args = dac->da_args;
> +	int				error, done;
>  
>  	/*
>  	 * Unmap value blocks for this attr.
> @@ -719,12 +719,20 @@ __xfs_attr_rmtval_remove(
>  	if (error)
>  		return error;
>  
> -	error = xfs_defer_finish(&args->trans);
> -	if (error)
> -		return error;
> -
> -	if (!done)
> +	/*
> +	 * We dont need an explicit state here to pick up where we left off.  We
> +	 * can figure it out using the !done return code.  Calling function only
> +	 * needs to keep recalling this routine until we indicate to stop by
> +	 * returning anything other than -EAGAIN. The actual value of
> +	 * attr->xattri_dela_state may be some value reminicent of the calling
> +	 * function, but it's value is irrelevant with in the context of this
> +	 * function.  Once we are done here, the next state is set as needed
> +	 * by the parent
> +	 */
> +	if (!done) {
> +		dac->flags |= XFS_DAC_DEFER_FINISH;
>  		return -EAGAIN;
> +	}
>  
>  	return error;
>  }
> diff --git a/fs/xfs/libxfs/xfs_attr_remote.h b/fs/xfs/libxfs/xfs_attr_remote.h
> index 9eee615..002fd30 100644
> --- a/fs/xfs/libxfs/xfs_attr_remote.h
> +++ b/fs/xfs/libxfs/xfs_attr_remote.h
> @@ -14,5 +14,5 @@ int xfs_attr_rmtval_remove(struct xfs_da_args *args);
>  int xfs_attr_rmtval_stale(struct xfs_inode *ip, struct xfs_bmbt_irec *map,
>  		xfs_buf_flags_t incore_flags);
>  int xfs_attr_rmtval_invalidate(struct xfs_da_args *args);
> -int __xfs_attr_rmtval_remove(struct xfs_da_args *args);
> +int __xfs_attr_rmtval_remove(struct xfs_delattr_context *dac);
>  #endif /* __XFS_ATTR_REMOTE_H__ */
> diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
> index bfad669..aaa7e66 100644
> --- a/fs/xfs/xfs_attr_inactive.c
> +++ b/fs/xfs/xfs_attr_inactive.c
> @@ -15,10 +15,10 @@
>  #include "xfs_da_format.h"
>  #include "xfs_da_btree.h"
>  #include "xfs_inode.h"
> +#include "xfs_attr.h"
>  #include "xfs_attr_remote.h"
>  #include "xfs_trans.h"
>  #include "xfs_bmap.h"
> -#include "xfs_attr.h"
>  #include "xfs_attr_leaf.h"
>  #include "xfs_quota.h"
>  #include "xfs_dir2.h"
> -- 
> 2.7.4
> 

