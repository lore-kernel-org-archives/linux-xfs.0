Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 231EDC433B4
	for <linux-xfs@archiver.kernel.org>; Thu,  1 Apr 2021 18:03:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F3D34610C7
	for <linux-xfs@archiver.kernel.org>; Thu,  1 Apr 2021 18:03:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236849AbhDASDB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 1 Apr 2021 14:03:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:34939 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235587AbhDAR4c (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Apr 2021 13:56:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617299791;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xKB7Wd+iG2pb2bysEdivXna/DC2L+UZLMDmoum+F30g=;
        b=Ulqs91cnQdlYgZDSPg2NK2Wp+GVBYqXRCwwBWEalia1qU+5aia0DZcwatgFrpqo3Yv6Tyq
        qFR/6XEWwEkiC7zRbhGJBoinmwaXQjo9ulBEC0e6y/GNEY1ypIW1kmPLPU3SE3eBiPCdCH
        8sc5j3OYGWj9suGvQ00RW4ZFT3Hbg+Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-24-S1Jm8RjuO4SV-fHJ46VkBg-1; Thu, 01 Apr 2021 12:56:03 -0400
X-MC-Unique: S1Jm8RjuO4SV-fHJ46VkBg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4560F800D53;
        Thu,  1 Apr 2021 16:56:02 +0000 (UTC)
Received: from bfoster (ovpn-112-117.rdu2.redhat.com [10.10.112.117])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D69125C1BB;
        Thu,  1 Apr 2021 16:56:00 +0000 (UTC)
Date:   Thu, 1 Apr 2021 12:55:51 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v16 10/11] xfs: Add delay ready attr remove routines
Message-ID: <YGX7FxrMvV01xEzZ@bfoster>
References: <20210326003308.32753-1-allison.henderson@oracle.com>
 <20210326003308.32753-11-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210326003308.32753-11-allison.henderson@oracle.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 25, 2021 at 05:33:07PM -0700, Allison Henderson wrote:
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
>  fs/xfs/libxfs/xfs_attr.c        | 206 +++++++++++++++++++++++++++-------------
>  fs/xfs/libxfs/xfs_attr.h        | 125 ++++++++++++++++++++++++
>  fs/xfs/libxfs/xfs_attr_leaf.c   |   2 +-
>  fs/xfs/libxfs/xfs_attr_remote.c |  48 ++++++----
>  fs/xfs/libxfs/xfs_attr_remote.h |   2 +-
>  fs/xfs/xfs_attr_inactive.c      |   2 +-
>  6 files changed, 297 insertions(+), 88 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 41accd5..4a73691 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
...
> @@ -221,6 +220,32 @@ xfs_attr_is_shortform(
>  		ip->i_afp->if_nextents == 0);
>  }
>  
> +/*
> + * Checks to see if a delayed attribute transaction should be rolled.  If so,
> + * also checks for a defer finish.  Transaction is finished and rolled as
> + * needed, and returns true of false if the delayed operation should continue.
> + */

Outdated comment wrt to the return value.

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
...
> @@ -1232,70 +1264,114 @@ xfs_attr_node_remove_cleanup(
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
> +	/* fallthrough */
> +	case XFS_DAS_RMTBLK:
> +		dac->dela_state = XFS_DAS_RMTBLK;
> +
> +		if (!dac->da_state) {
> +			error = xfs_attr_node_removename_setup(dac);
> +			if (error)
> +				goto out;

Do we need the goto here if _removename_setup() frees state on error (or
is the latter change necessary)?

> +		}
> +		state = dac->da_state;

Also, can this fold into the above if (!da_state) branch? Or maybe the
whole setup branch pulled up into the UNINIT state? Not a big deal, but
it does look a little out of place in the RMTBLK state.

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
> +			 * May return -EAGAIN. Remove blocks until
> +			 * args->rmtblkno == 0
> +			 */
> +			error = __xfs_attr_rmtval_remove(dac);
> +			if (error)
> +				break;

I feel that the difference between a break and goto out might confuse
some of the error handling. Right now, it looks like the exit path
handles either scenario, so we could presumably do something like the
following at the end of the function:

	if (error != -EAGAIN && state)
		xfs_da_state_free(state);
	return error;

... and just ditch the label. Alternatively we could retain the label above
the state check, but just use it consistently throughout the function.

Other than those few nits, this one looks pretty good to me.

Brian

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
> +			dac->flags |= XFS_DAC_DEFER_FINISH;
> +			return -EAGAIN;
> +		}
> +
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
>  out:
>  	if (state)
>  		xfs_da_state_free(state);
> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> index 3e97a93..92a6a50 100644
> --- a/fs/xfs/libxfs/xfs_attr.h
> +++ b/fs/xfs/libxfs/xfs_attr.h
> @@ -74,6 +74,127 @@ struct xfs_attr_list_context {
>  };
>  
>  
> +/*
> + * ========================================================================
> + * Structure used to pass context around among the delayed routines.
> + * ========================================================================
> + */
> +
> +/*
> + * Below is a state machine diagram for attr remove operations. The  XFS_DAS_*
> + * states indicate places where the function would return -EAGAIN, and then
> + * immediately resume from after being recalled by the calling function. States
> + * marked as a "subroutine state" indicate that they belong to a subroutine, and
> + * so the calling function needs to pass them back to that subroutine to allow
> + * it to finish where it left off. But they otherwise do not have a role in the
> + * calling function other than just passing through.
> + *
> + * xfs_attr_remove_iter()
> + *              │
> + *              v
> + *        have attr to remove? ──n──> done
> + *              │
> + *              y
> + *              │
> + *              v
> + *        are we short form? ──y──> xfs_attr_shortform_remove ──> done
> + *              │
> + *              n
> + *              │
> + *              V
> + *        are we leaf form? ──y──> xfs_attr_leaf_removename ──> done
> + *              │
> + *              n
> + *              │
> + *              V
> + *   ┌── need to setup state?
> + *   │          │
> + *   n          y
> + *   │          │
> + *   │          v
> + *   │ find attr and get state
> + *   │    attr has blks? ───n────???
> + *   │          │                v
> + *   │          │         find and invalidate
> + *   │          y         the blocks. mark
> + *   │          │         attr incomplete
> + *   │          ├────────────────┘
> + *   └──────────┤
> + *              │
> + *              v
> + *      Have blks to remove? ─────y────???
> + *              │       ^      remove the blks
> + *              │       │              │
> + *              │       │              v
> + *              │       │        refill the state
> + *              n       │              │
> + *              │       │              v
> + *              │       │         XFS_DAS_RMTBLK
> + *              │       └─────  re-enter with one
> + *              │               less blk to remove
> + *              │
> + *              v
> + *       remove leaf and
> + *       update hash with
> + *   xfs_attr_node_remove_cleanup
> + *              │
> + *              v
> + *           need to
> + *        shrink tree? ─n─???
> + *              │         │
> + *              y         │
> + *              │         │
> + *              v         │
> + *          join leaf     │
> + *              │         │
> + *              v         │
> + *      XFS_DAS_RM_SHRINK │
> + *              │         │
> + *              v         │
> + *       do the shrink    │
> + *              │         │
> + *              v         │
> + *          free state <──┘
> + *              │
> + *              v
> + *            done
> + *
> + */
> +
> +/*
> + * Enum values for xfs_delattr_context.da_state
> + *
> + * These values are used by delayed attribute operations to keep track  of where
> + * they were before they returned -EAGAIN.  A return code of -EAGAIN signals the
> + * calling function to roll the transaction, and then recall the subroutine to
> + * finish the operation.  The enum is then used by the subroutine to jump back
> + * to where it was and resume executing where it left off.
> + */
> +enum xfs_delattr_state {
> +	XFS_DAS_UNINIT		= 0,  /* No state has been set yet */
> +	XFS_DAS_RMTBLK,		      /* Removing remote blks */
> +	XFS_DAS_RM_SHRINK,	      /* We are shrinking the tree */
> +};
> +
> +/*
> + * Defines for xfs_delattr_context.flags
> + */
> +#define XFS_DAC_DEFER_FINISH		0x01 /* finish the transaction */
> +
> +/*
> + * Context used for keeping track of delayed attribute operations
> + */
> +struct xfs_delattr_context {
> +	struct xfs_da_args      *da_args;
> +
> +	/* Used in xfs_attr_node_removename to roll through removing blocks */
> +	struct xfs_da_state     *da_state;
> +
> +	/* Used to keep track of current state of delayed operation */
> +	unsigned int            flags;
> +	enum xfs_delattr_state  dela_state;
> +};
> +
>  /*========================================================================
>   * Function prototypes for the kernel.
>   *========================================================================*/
> @@ -91,6 +212,10 @@ int xfs_attr_set(struct xfs_da_args *args);
>  int xfs_attr_set_args(struct xfs_da_args *args);
>  int xfs_has_attr(struct xfs_da_args *args);
>  int xfs_attr_remove_args(struct xfs_da_args *args);
> +int xfs_attr_remove_iter(struct xfs_delattr_context *dac);
> +int xfs_attr_trans_roll(struct xfs_delattr_context *dac);
>  bool xfs_attr_namecheck(const void *name, size_t length);
> +void xfs_delattr_context_init(struct xfs_delattr_context *dac,
> +			      struct xfs_da_args *args);
>  
>  #endif	/* __XFS_ATTR_H__ */
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index d6ef69a..3780141 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -19,8 +19,8 @@
>  #include "xfs_bmap_btree.h"
>  #include "xfs_bmap.h"
>  #include "xfs_attr_sf.h"
> -#include "xfs_attr_remote.h"
>  #include "xfs_attr.h"
> +#include "xfs_attr_remote.h"
>  #include "xfs_attr_leaf.h"
>  #include "xfs_error.h"
>  #include "xfs_trace.h"
> diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
> index 48d8e9c..908521e7 100644
> --- a/fs/xfs/libxfs/xfs_attr_remote.c
> +++ b/fs/xfs/libxfs/xfs_attr_remote.c
> @@ -674,10 +674,12 @@ xfs_attr_rmtval_invalidate(
>   */
>  int
>  xfs_attr_rmtval_remove(
> -	struct xfs_da_args      *args)
> +	struct xfs_da_args		*args)
>  {
> -	int			error;
> -	int			retval;
> +	int				error;
> +	struct xfs_delattr_context	dac  = {
> +		.da_args	= args,
> +	};
>  
>  	trace_xfs_attr_rmtval_remove(args);
>  
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
> +	 * We don't need an explicit state here to pick up where we left off. We
> +	 * can figure it out using the !done return code. Calling function only
> +	 * needs to keep recalling this routine until we indicate to stop by
> +	 * returning anything other than -EAGAIN. The actual value of
> +	 * attr->xattri_dela_state may be some value reminiscent of the calling
> +	 * function, but it's value is irrelevant with in the context of this
> +	 * function. Once we are done here, the next state is set as needed
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

