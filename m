Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:46822 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752835AbeEGXwR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 May 2018 19:52:17 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w47NpwlG096188
        for <linux-xfs@vger.kernel.org>; Mon, 7 May 2018 23:52:16 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2130.oracle.com with ESMTP id 2hs426ec5x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 07 May 2018 23:52:16 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w47NqFfa018689
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 7 May 2018 23:52:15 GMT
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w47NqFIg002674
        for <linux-xfs@vger.kernel.org>; Mon, 7 May 2018 23:52:15 GMT
Date: Mon, 7 May 2018 16:52:13 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 02/21] Add trans toggle to attr routines
Message-ID: <20180507235213.GU11261@magnolia>
References: <1525627494-12873-1-git-send-email-allison.henderson@oracle.com>
 <1525627494-12873-3-git-send-email-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1525627494-12873-3-git-send-email-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Allison Henderson <allison.henderson@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Sun, May 06, 2018 at 10:24:35AM -0700, Allison Henderson wrote:
> This patch adds a roll_trans parameter to all attribute routines.
> Calling functions may pass true to roll transactions as normal,
> or false to hold them.  We will need this later for delayed
> attribute operations.

/me kinda dislikes this, but I guess the reason for the roll_trans
parameter is that we can't call defer_finish from a defer ops finishing
function, right?

Under the existing attr code we do things like:

_trans_alloc
_defer_init
	*dirty transaction, accumulate dfops*
	_defer_finish
		*finish items*
	*dirty transaction again, accumulate more dfops*
	_defer_finish
		*finish_items*
_trans_commit

But since we /really/ can't have nested _defer_finish calls I guess we
have to do something like this?

_defer_finish
_attr_finish_item
	*dirty transaction, accumulate dfops*
	bail out with EAGAIN
_defer_roll
_attr_finish_item (again)
	*dirty transaction again, accumulate more dfops*
_defer_roll
	*finish items*

Thoughts?

--D

> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c      | 144 +++++++++++++++++++++++-------------------
>  fs/xfs/libxfs/xfs_attr_leaf.c |  12 ++--
>  fs/xfs/libxfs/xfs_attr_leaf.h |   8 +--
>  3 files changed, 90 insertions(+), 74 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index ce4a34a..0ade22b 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -55,21 +55,21 @@
>  /*
>   * Internal routines when attribute list fits inside the inode.
>   */
> -STATIC int xfs_attr_shortform_addname(xfs_da_args_t *args);
> +STATIC int xfs_attr_shortform_addname(xfs_da_args_t *args, bool roll_trans);
>  
>  /*
>   * Internal routines when attribute list is one block.
>   */
>  STATIC int xfs_attr_leaf_get(xfs_da_args_t *args);
> -STATIC int xfs_attr_leaf_addname(xfs_da_args_t *args);
> -STATIC int xfs_attr_leaf_removename(xfs_da_args_t *args);
> +STATIC int xfs_attr_leaf_addname(xfs_da_args_t *args, bool roll_trans);
> +STATIC int xfs_attr_leaf_removename(xfs_da_args_t *args, bool roll_trans);
>  
>  /*
>   * Internal routines when attribute list is more than one block.
>   */
>  STATIC int xfs_attr_node_get(xfs_da_args_t *args);
> -STATIC int xfs_attr_node_addname(xfs_da_args_t *args);
> -STATIC int xfs_attr_node_removename(xfs_da_args_t *args);
> +STATIC int xfs_attr_node_addname(xfs_da_args_t *args, bool roll_trans);
> +STATIC int xfs_attr_node_removename(xfs_da_args_t *args, bool roll_trans);
>  STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
>  STATIC int xfs_attr_refillstate(xfs_da_state_t *state);
>  
> @@ -297,7 +297,7 @@ xfs_attr_set(
>  		 * Try to add the attr to the attribute list in
>  		 * the inode.
>  		 */
> -		error = xfs_attr_shortform_addname(&args);
> +		error = xfs_attr_shortform_addname(&args, true);
>  		if (error != -ENOSPC) {
>  			/*
>  			 * Commit the shortform mods, and we're done.
> @@ -356,9 +356,9 @@ xfs_attr_set(
>  	}
>  
>  	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
> -		error = xfs_attr_leaf_addname(&args);
> +		error = xfs_attr_leaf_addname(&args, true);
>  	else
> -		error = xfs_attr_node_addname(&args);
> +		error = xfs_attr_node_addname(&args, true);
>  	if (error)
>  		goto out;
>  
> @@ -453,11 +453,11 @@ xfs_attr_remove(
>  		error = -ENOATTR;
>  	} else if (dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL) {
>  		ASSERT(dp->i_afp->if_flags & XFS_IFINLINE);
> -		error = xfs_attr_shortform_remove(&args);
> +		error = xfs_attr_shortform_remove(&args, true);
>  	} else if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
> -		error = xfs_attr_leaf_removename(&args);
> +		error = xfs_attr_leaf_removename(&args, true);
>  	} else {
> -		error = xfs_attr_node_removename(&args);
> +		error = xfs_attr_node_removename(&args, true);
>  	}
>  
>  	if (error)
> @@ -498,7 +498,7 @@ xfs_attr_remove(
>   * This is the external routine.
>   */
>  STATIC int
> -xfs_attr_shortform_addname(xfs_da_args_t *args)
> +xfs_attr_shortform_addname(xfs_da_args_t *args, bool roll_trans)
>  {
>  	int newsize, forkoff, retval;
>  
> @@ -510,7 +510,7 @@ xfs_attr_shortform_addname(xfs_da_args_t *args)
>  	} else if (retval == -EEXIST) {
>  		if (args->flags & ATTR_CREATE)
>  			return retval;
> -		retval = xfs_attr_shortform_remove(args);
> +		retval = xfs_attr_shortform_remove(args, roll_trans);
>  		ASSERT(retval == 0);
>  	}
>  
> @@ -525,7 +525,7 @@ xfs_attr_shortform_addname(xfs_da_args_t *args)
>  	if (!forkoff)
>  		return -ENOSPC;
>  
> -	xfs_attr_shortform_add(args, forkoff);
> +	xfs_attr_shortform_add(args, forkoff, roll_trans);
>  	return 0;
>  }
>  
> @@ -541,7 +541,7 @@ xfs_attr_shortform_addname(xfs_da_args_t *args)
>   * if bmap_one_block() says there is only one block (ie: no remote blks).
>   */
>  STATIC int
> -xfs_attr_leaf_addname(xfs_da_args_t *args)
> +xfs_attr_leaf_addname(xfs_da_args_t *args, bool roll_trans)
>  {
>  	xfs_inode_t *dp;
>  	struct xfs_buf *bp;
> @@ -604,36 +604,42 @@ xfs_attr_leaf_addname(xfs_da_args_t *args)
>  		 * can manage its own transactions.
>  		 */
>  		xfs_defer_init(args->dfops, args->firstblock);
> -		error = xfs_attr3_leaf_to_node(args);
> -		if (error)
> -			goto out_defer_cancel;
> -		xfs_defer_ijoin(args->dfops, dp);
> -		error = xfs_defer_finish(&args->trans, args->dfops);
> +		error = xfs_attr3_leaf_to_node(args, roll_trans);
>  		if (error)
>  			goto out_defer_cancel;
> +		if (roll_trans) {
> +			xfs_defer_ijoin(args->dfops, dp);
> +			error = xfs_defer_finish(&args->trans, args->dfops);
> +			if (error)
> +				goto out_defer_cancel;
>  
> -		/*
> -		 * Commit the current trans (including the inode) and start
> -		 * a new one.
> -		 */
> -		error = xfs_trans_roll_inode(&args->trans, dp);
> -		if (error)
> -			return error;
> +			/*
> +			 * Commit the current trans (including the inode) and start
> +			 * a new one.
> +			 */
> +			error = xfs_trans_roll_inode(&args->trans, dp);
> +			if (error)
> +				return error;
> +		}
>  
>  		/*
>  		 * Fob the whole rest of the problem off on the Btree code.
>  		 */
> -		error = xfs_attr_node_addname(args);
> +		error = xfs_attr_node_addname(args, roll_trans);
> +
>  		return error;
>  	}
>  
> -	/*
> -	 * Commit the transaction that added the attr name so that
> -	 * later routines can manage their own transactions.
> -	 */
> -	error = xfs_trans_roll_inode(&args->trans, dp);
> -	if (error)
> -		return error;
> +
> +	if (roll_trans) {
> +		/*
> +		 * Commit the transaction that added the attr name so that
> +		 * later routines can manage their own transactions.
> +		 */
> +		error = xfs_trans_roll_inode(&args->trans, dp);
> +		if (error)
> +			return error;
> +	}
>  
>  	/*
>  	 * If there was an out-of-line value, allocate the blocks we
> @@ -691,9 +697,9 @@ xfs_attr_leaf_addname(xfs_da_args_t *args)
>  		/*
>  		 * If the result is small enough, shrink it all into the inode.
>  		 */
> -		if ((forkoff = xfs_attr_shortform_allfit(bp, dp))) {
> +		if ((forkoff = xfs_attr_shortform_allfit(bp, dp)) && roll_trans) {
>  			xfs_defer_init(args->dfops, args->firstblock);
> -			error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
> +			error = xfs_attr3_leaf_to_shortform(bp, args, forkoff, roll_trans);
>  			/* bp is gone due to xfs_da_shrink_inode */
>  			if (error)
>  				goto out_defer_cancel;
> @@ -727,7 +733,7 @@ xfs_attr_leaf_addname(xfs_da_args_t *args)
>   * if bmap_one_block() says there is only one block (ie: no remote blks).
>   */
>  STATIC int
> -xfs_attr_leaf_removename(xfs_da_args_t *args)
> +xfs_attr_leaf_removename(xfs_da_args_t *args, bool roll_trans)
>  {
>  	xfs_inode_t *dp;
>  	struct xfs_buf *bp;
> @@ -755,9 +761,9 @@ xfs_attr_leaf_removename(xfs_da_args_t *args)
>  	/*
>  	 * If the result is small enough, shrink it all into the inode.
>  	 */
> -	if ((forkoff = xfs_attr_shortform_allfit(bp, dp))) {
> +	if ((forkoff = xfs_attr_shortform_allfit(bp, dp)) && roll_trans) {
>  		xfs_defer_init(args->dfops, args->firstblock);
> -		error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
> +		error = xfs_attr3_leaf_to_shortform(bp, args, forkoff, roll_trans);
>  		/* bp is gone due to xfs_da_shrink_inode */
>  		if (error)
>  			goto out_defer_cancel;
> @@ -819,7 +825,7 @@ xfs_attr_leaf_get(xfs_da_args_t *args)
>   * add a whole extra layer of confusion on top of that.
>   */
>  STATIC int
> -xfs_attr_node_addname(xfs_da_args_t *args)
> +xfs_attr_node_addname(xfs_da_args_t *args, bool roll_trans)
>  {
>  	xfs_da_state_t *state;
>  	xfs_da_state_blk_t *blk;
> @@ -885,21 +891,23 @@ xfs_attr_node_addname(xfs_da_args_t *args)
>  			xfs_da_state_free(state);
>  			state = NULL;
>  			xfs_defer_init(args->dfops, args->firstblock);
> -			error = xfs_attr3_leaf_to_node(args);
> +			error = xfs_attr3_leaf_to_node(args, roll_trans);
>  			if (error)
>  				goto out_defer_cancel;
>  			xfs_defer_ijoin(args->dfops, dp);
> -			error = xfs_defer_finish(&args->trans, args->dfops);
> -			if (error)
> -				goto out_defer_cancel;
> -
> -			/*
> -			 * Commit the node conversion and start the next
> -			 * trans in the chain.
> -			 */
> -			error = xfs_trans_roll_inode(&args->trans, dp);
> -			if (error)
> -				goto out;
> +			if (roll_trans) {
> +				error = xfs_defer_finish(&args->trans, args->dfops);
> +				if (error)
> +					goto out_defer_cancel;
> +
> +				/*
> +				 * Commit the node conversion and start the next
> +				 * trans in the chain.
> +				 */
> +				error = xfs_trans_roll_inode(&args->trans, dp);
> +				if (error)
> +					goto out;
> +			}
>  
>  			goto restart;
>  		}
> @@ -915,9 +923,11 @@ xfs_attr_node_addname(xfs_da_args_t *args)
>  		if (error)
>  			goto out_defer_cancel;
>  		xfs_defer_ijoin(args->dfops, dp);
> -		error = xfs_defer_finish(&args->trans, args->dfops);
> -		if (error)
> -			goto out_defer_cancel;
> +		if (roll_trans) {
> +			error = xfs_defer_finish(&args->trans, args->dfops);
> +			if (error)
> +				goto out_defer_cancel;
> +		}
>  	} else {
>  		/*
>  		 * Addition succeeded, update Btree hashvals.
> @@ -936,9 +946,11 @@ xfs_attr_node_addname(xfs_da_args_t *args)
>  	 * Commit the leaf addition or btree split and start the next
>  	 * trans in the chain.
>  	 */
> -	error = xfs_trans_roll_inode(&args->trans, dp);
> -	if (error)
> -		goto out;
> +	if (roll_trans) {
> +		error = xfs_trans_roll_inode(&args->trans, dp);
> +		if (error)
> +			goto out;
> +	}
>  
>  	/*
>  	 * If there was an out-of-line value, allocate the blocks we
> @@ -1013,9 +1025,11 @@ xfs_attr_node_addname(xfs_da_args_t *args)
>  			if (error)
>  				goto out_defer_cancel;
>  			xfs_defer_ijoin(args->dfops, dp);
> -			error = xfs_defer_finish(&args->trans, args->dfops);
> -			if (error)
> -				goto out_defer_cancel;
> +			if (roll_trans) {
> +				error = xfs_defer_finish(&args->trans, args->dfops);
> +				if (error)
> +					goto out_defer_cancel;
> +			}
>  		}
>  
>  		/*
> @@ -1054,7 +1068,7 @@ xfs_attr_node_addname(xfs_da_args_t *args)
>   * the root node (a special case of an intermediate node).
>   */
>  STATIC int
> -xfs_attr_node_removename(xfs_da_args_t *args)
> +xfs_attr_node_removename(xfs_da_args_t *args, bool roll_trans)
>  {
>  	xfs_da_state_t *state;
>  	xfs_da_state_blk_t *blk;
> @@ -1163,9 +1177,9 @@ xfs_attr_node_removename(xfs_da_args_t *args)
>  		if (error)
>  			goto out;
>  
> -		if ((forkoff = xfs_attr_shortform_allfit(bp, dp))) {
> +		if ((forkoff = xfs_attr_shortform_allfit(bp, dp)) && roll_trans) {
>  			xfs_defer_init(args->dfops, args->firstblock);
> -			error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
> +			error = xfs_attr3_leaf_to_shortform(bp, args, forkoff, roll_trans);
>  			/* bp is gone due to xfs_da_shrink_inode */
>  			if (error)
>  				goto out_defer_cancel;
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index 2135b8e..01935fe 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -546,7 +546,7 @@ xfs_attr_shortform_create(xfs_da_args_t *args)
>   * Overflow from the inode has already been checked for.
>   */
>  void
> -xfs_attr_shortform_add(xfs_da_args_t *args, int forkoff)
> +xfs_attr_shortform_add(xfs_da_args_t *args, int forkoff, bool roll_trans)
>  {
>  	xfs_attr_shortform_t *sf;
>  	xfs_attr_sf_entry_t *sfe;
> @@ -618,7 +618,7 @@ xfs_attr_fork_remove(
>   * Remove an attribute from the shortform attribute list structure.
>   */
>  int
> -xfs_attr_shortform_remove(xfs_da_args_t *args)
> +xfs_attr_shortform_remove(xfs_da_args_t *args, bool roll_trans)
>  {
>  	xfs_attr_shortform_t *sf;
>  	xfs_attr_sf_entry_t *sfe;
> @@ -970,7 +970,8 @@ int
>  xfs_attr3_leaf_to_shortform(
>  	struct xfs_buf		*bp,
>  	struct xfs_da_args	*args,
> -	int			forkoff)
> +	int			forkoff,
> +	bool			roll_trans)
>  {
>  	struct xfs_attr_leafblock *leaf;
>  	struct xfs_attr3_icleaf_hdr ichdr;
> @@ -1039,7 +1040,7 @@ xfs_attr3_leaf_to_shortform(
>  		nargs.valuelen = be16_to_cpu(name_loc->valuelen);
>  		nargs.hashval = be32_to_cpu(entry->hashval);
>  		nargs.flags = XFS_ATTR_NSP_ONDISK_TO_ARGS(entry->flags);
> -		xfs_attr_shortform_add(&nargs, forkoff);
> +		xfs_attr_shortform_add(&nargs, forkoff, roll_trans);
>  	}
>  	error = 0;
>  
> @@ -1053,7 +1054,8 @@ xfs_attr3_leaf_to_shortform(
>   */
>  int
>  xfs_attr3_leaf_to_node(
> -	struct xfs_da_args	*args)
> +	struct xfs_da_args	*args,
> +	bool			roll_trans)
>  {
>  	struct xfs_attr_leafblock *leaf;
>  	struct xfs_attr3_icleaf_hdr icleafhdr;
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.h b/fs/xfs/libxfs/xfs_attr_leaf.h
> index 4da08af..b5dea0e 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.h
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.h
> @@ -45,12 +45,12 @@ typedef struct xfs_attr_inactive_list {
>   * Internal routines when attribute fork size < XFS_LITINO(mp).
>   */
>  void	xfs_attr_shortform_create(struct xfs_da_args *args);
> -void	xfs_attr_shortform_add(struct xfs_da_args *args, int forkoff);
> +void	xfs_attr_shortform_add(struct xfs_da_args *args, int forkoff, bool roll_trans);
>  int	xfs_attr_shortform_lookup(struct xfs_da_args *args);
>  int	xfs_attr_shortform_getvalue(struct xfs_da_args *args);
>  int	xfs_attr_shortform_to_leaf(struct xfs_da_args *args,
>  			struct xfs_buf **leaf_bp);
> -int	xfs_attr_shortform_remove(struct xfs_da_args *args);
> +int	xfs_attr_shortform_remove(struct xfs_da_args *args, bool roll_trans);
>  int	xfs_attr_shortform_allfit(struct xfs_buf *bp, struct xfs_inode *dp);
>  int	xfs_attr_shortform_bytesfit(struct xfs_inode *dp, int bytes);
>  xfs_failaddr_t xfs_attr_shortform_verify(struct xfs_inode *ip);
> @@ -59,9 +59,9 @@ void	xfs_attr_fork_remove(struct xfs_inode *ip, struct xfs_trans *tp);
>  /*
>   * Internal routines when attribute fork size == XFS_LBSIZE(mp).
>   */
> -int	xfs_attr3_leaf_to_node(struct xfs_da_args *args);
> +int	xfs_attr3_leaf_to_node(struct xfs_da_args *args, bool roll_trans);
>  int	xfs_attr3_leaf_to_shortform(struct xfs_buf *bp,
> -				   struct xfs_da_args *args, int forkoff);
> +				   struct xfs_da_args *args, int forkoff, bool roll_trans);
>  int	xfs_attr3_leaf_clearflag(struct xfs_da_args *args);
>  int	xfs_attr3_leaf_setflag(struct xfs_da_args *args);
>  int	xfs_attr3_leaf_flipflags(struct xfs_da_args *args);
> -- 
> 2.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
