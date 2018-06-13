Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:49132 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S935261AbeFMMLi (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 13 Jun 2018 08:11:38 -0400
Date: Wed, 13 Jun 2018 08:11:36 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v7 03/23] xfs: Add trans toggle to attr routines
Message-ID: <20180613121136.GA65076@bfoster>
References: <1528607108-11059-1-git-send-email-allison.henderson@oracle.com>
 <1528607108-11059-4-git-send-email-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1528607108-11059-4-git-send-email-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Allison Henderson <allison.henderson@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Sat, Jun 09, 2018 at 10:04:48PM -0700, Allison Henderson wrote:
> This patch adds a roll_trans parameter to all attribute routines.
> Calling functions may pass true to roll transactions as normal,
> or false to hold them.  We will need this later for delayed
> attribute operations.
> 
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c      | 165 ++++++++++++++++++++++++------------------
>  fs/xfs/libxfs/xfs_attr_leaf.c |  12 +--
>  fs/xfs/libxfs/xfs_attr_leaf.h |  10 ++-
>  3 files changed, 108 insertions(+), 79 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 1524197..e8cb369 100644
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
> @@ -207,15 +207,16 @@ STATIC int
>  xfs_attr_try_sf_addname(
>  	struct xfs_inode	*dp,
>  	struct xfs_da_args	*args,
> -	int			flags)
> +	int			flags,
> +	bool			roll_trans)
>  {
>  
>  	struct xfs_mount	*mp = dp->i_mount;
>  	int			error;
>  	int			err2;
>  
> -	error = xfs_attr_shortform_addname(args);
> -	if (error != -ENOSPC) {
> +	error = xfs_attr_shortform_addname(args, roll_trans);
> +	if (error != -ENOSPC && roll_trans) {

Doesn't this change behavior beyond committing the transaction or not?
E.g., we skip the time call that follows if !roll_trans. Would the
!roll_trans caller know/care about that?

>  		/*
>  		 * Commit the shortform mods, and we're done.
>  		 * NOTE: this is also the error path
> @@ -335,7 +336,7 @@ xfs_attr_set(
>  		 * Try to add the attr to the attribute list in
>  		 * the inode.
>  		 */
> -		error = xfs_attr_try_sf_addname(dp, &args, flags);
> +		error = xfs_attr_try_sf_addname(dp, &args, flags, true);
>  		if (error != -ENOSPC) {
>  			xfs_iunlock(dp, XFS_ILOCK_EXCL);
>  			return error;
> @@ -374,9 +375,9 @@ xfs_attr_set(
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
> @@ -471,11 +472,11 @@ xfs_attr_remove(
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
> @@ -516,7 +517,7 @@ xfs_attr_remove(
>   * This is the external routine.
>   */
>  STATIC int
> -xfs_attr_shortform_addname(xfs_da_args_t *args)
> +xfs_attr_shortform_addname(xfs_da_args_t *args, bool roll_trans)
>  {
>  	int newsize, forkoff, retval;
>  
> @@ -528,7 +529,7 @@ xfs_attr_shortform_addname(xfs_da_args_t *args)
>  	} else if (retval == -EEXIST) {
>  		if (args->flags & ATTR_CREATE)
>  			return retval;
> -		retval = xfs_attr_shortform_remove(args);
> +		retval = xfs_attr_shortform_remove(args, roll_trans);
>  		ASSERT(retval == 0);
>  	}
>  
> @@ -543,7 +544,7 @@ xfs_attr_shortform_addname(xfs_da_args_t *args)
>  	if (!forkoff)
>  		return -ENOSPC;
>  
> -	xfs_attr_shortform_add(args, forkoff);
> +	xfs_attr_shortform_add(args, forkoff, roll_trans);
>  	return 0;
>  }
>  
> @@ -559,7 +560,7 @@ xfs_attr_shortform_addname(xfs_da_args_t *args)
>   * if bmap_one_block() says there is only one block (ie: no remote blks).
>   */
>  STATIC int
> -xfs_attr_leaf_addname(xfs_da_args_t *args)
> +xfs_attr_leaf_addname(xfs_da_args_t *args, bool roll_trans)
>  {
>  	xfs_inode_t *dp;
>  	struct xfs_buf *bp;
> @@ -622,36 +623,42 @@ xfs_attr_leaf_addname(xfs_da_args_t *args)
>  		 * can manage its own transactions.
>  		 */
>  		xfs_defer_init(args->dfops, args->firstblock);
> -		error = xfs_attr3_leaf_to_node(args);
> +		error = xfs_attr3_leaf_to_node(args, roll_trans);
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
>  
> -		/*
> -		 * Commit the current trans (including the inode) and start
> -		 * a new one.
> -		 */
> -		error = xfs_trans_roll_inode(&args->trans, dp);
> -		if (error)
> -			return error;
> +			/*
> +			 * Commit the current trans (including the inode) and
> +			 * start a new one.
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
> @@ -709,9 +716,11 @@ xfs_attr_leaf_addname(xfs_da_args_t *args)
>  		/*
>  		 * If the result is small enough, shrink it all into the inode.
>  		 */
> -		if ((forkoff = xfs_attr_shortform_allfit(bp, dp))) {
> +		if ((forkoff = xfs_attr_shortform_allfit(bp, dp)) &&
> +				roll_trans) {

Similar here (and one or two other places in the patch).. I haven't
looked ahead at the follow on code, but it seems a bit strange for a
"don't roll trans" flag to toggle attr fork behavior.

>  			xfs_defer_init(args->dfops, args->firstblock);
> -			error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
> +			error = xfs_attr3_leaf_to_shortform(bp, args, forkoff,
> +					roll_trans);
>  			/* bp is gone due to xfs_da_shrink_inode */
>  			if (error)
>  				goto out_defer_cancel;
> @@ -745,7 +754,7 @@ xfs_attr_leaf_addname(xfs_da_args_t *args)
>   * if bmap_one_block() says there is only one block (ie: no remote blks).
>   */
>  STATIC int
> -xfs_attr_leaf_removename(xfs_da_args_t *args)
> +xfs_attr_leaf_removename(xfs_da_args_t *args, bool roll_trans)
>  {
>  	xfs_inode_t *dp;
>  	struct xfs_buf *bp;
> @@ -774,15 +783,19 @@ xfs_attr_leaf_removename(xfs_da_args_t *args)
>  	 * If the result is small enough, shrink it all into the inode.
>  	 */
>  	if ((forkoff = xfs_attr_shortform_allfit(bp, dp))) {
> -		xfs_defer_init(args->dfops, args->firstblock);
> -		error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
> +		if (roll_trans)
> +			xfs_defer_init(args->dfops, args->firstblock);
> +		error = xfs_attr3_leaf_to_shortform(bp, args, forkoff,
> +							roll_trans);

While here roll_trans seems to only control the transaction behavior.
Hm?

Brian

>  		/* bp is gone due to xfs_da_shrink_inode */
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
>  	}
>  	return 0;
>  out_defer_cancel:
> @@ -837,7 +850,7 @@ xfs_attr_leaf_get(xfs_da_args_t *args)
>   * add a whole extra layer of confusion on top of that.
>   */
>  STATIC int
> -xfs_attr_node_addname(xfs_da_args_t *args)
> +xfs_attr_node_addname(xfs_da_args_t *args, bool roll_trans)
>  {
>  	xfs_da_state_t *state;
>  	xfs_da_state_blk_t *blk;
> @@ -903,21 +916,24 @@ xfs_attr_node_addname(xfs_da_args_t *args)
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
> +				error = xfs_defer_finish(&args->trans,
> +						args->dfops);
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
> @@ -933,9 +949,11 @@ xfs_attr_node_addname(xfs_da_args_t *args)
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
> @@ -954,9 +972,11 @@ xfs_attr_node_addname(xfs_da_args_t *args)
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
> @@ -1031,9 +1051,12 @@ xfs_attr_node_addname(xfs_da_args_t *args)
>  			if (error)
>  				goto out_defer_cancel;
>  			xfs_defer_ijoin(args->dfops, dp);
> -			error = xfs_defer_finish(&args->trans, args->dfops);
> -			if (error)
> -				goto out_defer_cancel;
> +			if (roll_trans) {
> +				error = xfs_defer_finish(&args->trans,
> +						args->dfops);
> +				if (error)
> +					goto out_defer_cancel;
> +			}
>  		}
>  
>  		/*
> @@ -1072,7 +1095,7 @@ xfs_attr_node_addname(xfs_da_args_t *args)
>   * the root node (a special case of an intermediate node).
>   */
>  STATIC int
> -xfs_attr_node_removename(xfs_da_args_t *args)
> +xfs_attr_node_removename(xfs_da_args_t *args, bool roll_trans)
>  {
>  	xfs_da_state_t *state;
>  	xfs_da_state_blk_t *blk;
> @@ -1181,9 +1204,11 @@ xfs_attr_node_removename(xfs_da_args_t *args)
>  		if (error)
>  			goto out;
>  
> -		if ((forkoff = xfs_attr_shortform_allfit(bp, dp))) {
> +		if ((forkoff = xfs_attr_shortform_allfit(bp, dp)) &&
> +					roll_trans) {
>  			xfs_defer_init(args->dfops, args->firstblock);
> -			error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
> +			error = xfs_attr3_leaf_to_shortform(bp, args, forkoff,
> +					roll_trans);
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
> index 4da08af..79c236c 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.h
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.h
> @@ -45,12 +45,13 @@ typedef struct xfs_attr_inactive_list {
>   * Internal routines when attribute fork size < XFS_LITINO(mp).
>   */
>  void	xfs_attr_shortform_create(struct xfs_da_args *args);
> -void	xfs_attr_shortform_add(struct xfs_da_args *args, int forkoff);
> +void	xfs_attr_shortform_add(struct xfs_da_args *args, int forkoff,
> +			bool roll_trans);
>  int	xfs_attr_shortform_lookup(struct xfs_da_args *args);
>  int	xfs_attr_shortform_getvalue(struct xfs_da_args *args);
>  int	xfs_attr_shortform_to_leaf(struct xfs_da_args *args,
>  			struct xfs_buf **leaf_bp);
> -int	xfs_attr_shortform_remove(struct xfs_da_args *args);
> +int	xfs_attr_shortform_remove(struct xfs_da_args *args, bool roll_trans);
>  int	xfs_attr_shortform_allfit(struct xfs_buf *bp, struct xfs_inode *dp);
>  int	xfs_attr_shortform_bytesfit(struct xfs_inode *dp, int bytes);
>  xfs_failaddr_t xfs_attr_shortform_verify(struct xfs_inode *ip);
> @@ -59,9 +60,10 @@ void	xfs_attr_fork_remove(struct xfs_inode *ip, struct xfs_trans *tp);
>  /*
>   * Internal routines when attribute fork size == XFS_LBSIZE(mp).
>   */
> -int	xfs_attr3_leaf_to_node(struct xfs_da_args *args);
> +int	xfs_attr3_leaf_to_node(struct xfs_da_args *args, bool roll_trans);
>  int	xfs_attr3_leaf_to_shortform(struct xfs_buf *bp,
> -				   struct xfs_da_args *args, int forkoff);
> +			struct xfs_da_args *args, int forkoff,
> +			bool roll_trans);
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
