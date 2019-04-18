Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51214 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731317AbfDRP1I (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 18 Apr 2019 11:27:08 -0400
Date: Thu, 18 Apr 2019 11:27:05 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 3/9] xfs: Add trans toggle to attr routines
Message-ID: <20190418152705.GA2885@bfoster>
References: <20190412225036.22939-1-allison.henderson@oracle.com>
 <20190412225036.22939-4-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190412225036.22939-4-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Allison Henderson <allison.henderson@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Apr 12, 2019 at 03:50:30PM -0700, Allison Henderson wrote:
> This patch adds a roll_trans parameter to all attribute routines
> that may roll a transaction. Calling functions may pass true to
> roll transactions as normal, or false to hold them.
> 
> This patch is temporary and will be removed later when all code
> paths have been made to pass a false value.  The temporary boolean
> assists us to introduce changes across multiple smaller patches instead
> of handling all affected code paths in one large patch.
> 
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> ---

A couple more sentences in the commit log with details on the purpose
for this would be helpful. E.g., the current state of the attr code
rolls the transaction at various places, the implementation we're moving
to can't or shouldn't do this because <reasons>, etc.

>  fs/xfs/libxfs/xfs_attr.c        | 257 +++++++++++++++++++++++-----------------
>  fs/xfs/libxfs/xfs_attr.h        |   5 +-
>  fs/xfs/libxfs/xfs_attr_leaf.c   |  20 +++-
>  fs/xfs/libxfs/xfs_attr_leaf.h   |   8 +-
>  fs/xfs/libxfs/xfs_attr_remote.c |  50 ++++----
>  fs/xfs/libxfs/xfs_attr_remote.h |   4 +-
>  6 files changed, 203 insertions(+), 141 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 3da6b0d..c50bbf6 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
...
> @@ -743,7 +762,8 @@ xfs_attr_leaf_addname(
>   */
>  STATIC int
>  xfs_attr_leaf_removename(
> -	struct xfs_da_args	*args)
> +	struct xfs_da_args	*args,
> +	bool roll_trans)

Indentation ^

Nits aside this looks like fairly mechanical plumbing, doesn't change
behavior in the current attr codepaths and seems reasonable as a
transient step:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  {
>  	struct xfs_inode	*dp;
>  	struct xfs_buf		*bp;
> @@ -776,9 +796,12 @@ xfs_attr_leaf_removename(
>  		/* bp is gone due to xfs_da_shrink_inode */
>  		if (error)
>  			return error;
> -		error = xfs_defer_finish(&args->trans);
> -		if (error)
> -			return error;
> +
> +		if (roll_trans) {
> +			error = xfs_defer_finish(&args->trans);
> +			if (error)
> +				return error;
> +		}
>  	}
>  	return 0;
>  }
> @@ -831,7 +854,8 @@ xfs_attr_leaf_get(xfs_da_args_t *args)
>   */
>  STATIC int
>  xfs_attr_node_addname(
> -	struct xfs_da_args	*args)
> +	struct xfs_da_args	*args,
> +	bool			roll_trans)
>  {
>  	struct xfs_da_state	*state;
>  	struct xfs_da_state_blk	*blk;
> @@ -899,17 +923,20 @@ xfs_attr_node_addname(
>  			error = xfs_attr3_leaf_to_node(args);
>  			if (error)
>  				goto out;
> -			error = xfs_defer_finish(&args->trans);
> -			if (error)
> -				goto out;
>  
> -			/*
> -			 * Commit the node conversion and start the next
> -			 * trans in the chain.
> -			 */
> -			error = xfs_trans_roll_inode(&args->trans, dp);
> -			if (error)
> -				goto out;
> +			if (roll_trans) {
> +				error = xfs_defer_finish(&args->trans);
> +				if (error)
> +					goto out;
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
> @@ -923,9 +950,13 @@ xfs_attr_node_addname(
>  		error = xfs_da3_split(state);
>  		if (error)
>  			goto out;
> -		error = xfs_defer_finish(&args->trans);
> -		if (error)
> -			goto out;
> +
> +		if (roll_trans) {
> +			error = xfs_defer_finish(&args->trans);
> +			if (error)
> +				goto out;
> +		}
> +
>  	} else {
>  		/*
>  		 * Addition succeeded, update Btree hashvals.
> @@ -944,9 +975,11 @@ xfs_attr_node_addname(
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
> @@ -955,7 +988,7 @@ xfs_attr_node_addname(
>  	 * maximum size of a transaction and/or hit a deadlock.
>  	 */
>  	if (args->rmtblkno > 0) {
> -		error = xfs_attr_rmtval_set(args);
> +		error = xfs_attr_rmtval_set(args, roll_trans);
>  		if (error)
>  			return error;
>  	}
> @@ -971,7 +1004,7 @@ xfs_attr_node_addname(
>  		 * In a separate transaction, set the incomplete flag on the
>  		 * "old" attr and clear the incomplete flag on the "new" attr.
>  		 */
> -		error = xfs_attr3_leaf_flipflags(args);
> +		error = xfs_attr3_leaf_flipflags(args, roll_trans);
>  		if (error)
>  			goto out;
>  
> @@ -985,7 +1018,7 @@ xfs_attr_node_addname(
>  		args->rmtblkcnt = args->rmtblkcnt2;
>  		args->rmtvaluelen = args->rmtvaluelen2;
>  		if (args->rmtblkno) {
> -			error = xfs_attr_rmtval_remove(args);
> +			error = xfs_attr_rmtval_remove(args, roll_trans);
>  			if (error)
>  				return error;
>  		}
> @@ -1019,9 +1052,11 @@ xfs_attr_node_addname(
>  			error = xfs_da3_join(state);
>  			if (error)
>  				goto out;
> -			error = xfs_defer_finish(&args->trans);
> -			if (error)
> -				goto out;
> +			if (roll_trans) {
> +				error = xfs_defer_finish(&args->trans);
> +				if (error)
> +					goto out;
> +			}
>  		}
>  
>  		/*
> @@ -1035,7 +1070,7 @@ xfs_attr_node_addname(
>  		/*
>  		 * Added a "remote" value, just clear the incomplete flag.
>  		 */
> -		error = xfs_attr3_leaf_clearflag(args);
> +		error = xfs_attr3_leaf_clearflag(args, roll_trans);
>  		if (error)
>  			goto out;
>  	}
> @@ -1058,7 +1093,8 @@ xfs_attr_node_addname(
>   */
>  STATIC int
>  xfs_attr_node_removename(
> -	struct xfs_da_args	*args)
> +	struct xfs_da_args	*args,
> +	bool			roll_trans)
>  {
>  	struct xfs_da_state	*state;
>  	struct xfs_da_state_blk	*blk;
> @@ -1108,10 +1144,10 @@ xfs_attr_node_removename(
>  		 * Mark the attribute as INCOMPLETE, then bunmapi() the
>  		 * remote value.
>  		 */
> -		error = xfs_attr3_leaf_setflag(args);
> +		error = xfs_attr3_leaf_setflag(args, roll_trans);
>  		if (error)
>  			goto out;
> -		error = xfs_attr_rmtval_remove(args);
> +		error = xfs_attr_rmtval_remove(args, roll_trans);
>  		if (error)
>  			goto out;
>  
> @@ -1139,15 +1175,19 @@ xfs_attr_node_removename(
>  		error = xfs_da3_join(state);
>  		if (error)
>  			goto out;
> -		error = xfs_defer_finish(&args->trans);
> -		if (error)
> -			goto out;
> -		/*
> -		 * Commit the Btree join operation and start a new trans.
> -		 */
> -		error = xfs_trans_roll_inode(&args->trans, dp);
> -		if (error)
> -			goto out;
> +
> +		if (roll_trans) {
> +			error = xfs_defer_finish(&args->trans);
> +			if (error)
> +				goto out;
> +			/*
> +			 * Commit the Btree join operation and start
> +			 * a new trans.
> +			 */
> +			error = xfs_trans_roll_inode(&args->trans, dp);
> +			if (error)
> +				goto out;
> +		}
>  	}
>  
>  	/*
> @@ -1170,9 +1210,12 @@ xfs_attr_node_removename(
>  			/* bp is gone due to xfs_da_shrink_inode */
>  			if (error)
>  				goto out;
> -			error = xfs_defer_finish(&args->trans);
> -			if (error)
> -				goto out;
> +
> +			if (roll_trans) {
> +				error = xfs_defer_finish(&args->trans);
> +				if (error)
> +					goto out;
> +			}
>  		} else
>  			xfs_trans_brelse(args->trans, bp);
>  	}
> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> index 52f63dc..f0e91bf 100644
> --- a/fs/xfs/libxfs/xfs_attr.h
> +++ b/fs/xfs/libxfs/xfs_attr.h
> @@ -142,10 +142,11 @@ int xfs_attr_get(struct xfs_inode *ip, const unsigned char *name,
>  int xfs_attr_set(struct xfs_inode *dp, const unsigned char *name,
>  		 size_t namelen, unsigned char *value, int valuelen,
>  		 int flags);
> -int xfs_attr_set_args(struct xfs_da_args *args, struct xfs_buf **leaf_bp);
> +int xfs_attr_set_args(struct xfs_da_args *args, struct xfs_buf **leaf_bp,
> +		 bool roll_trans);
>  int xfs_attr_remove(struct xfs_inode *dp, const unsigned char *name,
>  		    size_t namelen, int flags);
> -int xfs_attr_remove_args(struct xfs_da_args *args);
> +int xfs_attr_remove_args(struct xfs_da_args *args, bool roll_trans);
>  int xfs_attr_list(struct xfs_inode *dp, char *buffer, int bufsize,
>  		  int flags, struct attrlist_cursor_kern *cursor);
>  bool xfs_attr_namecheck(const void *name, size_t length);
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index 1f6e396..128bfe9 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -2637,7 +2637,8 @@ xfs_attr_leaf_newentsize(
>   */
>  int
>  xfs_attr3_leaf_clearflag(
> -	struct xfs_da_args	*args)
> +	struct xfs_da_args	*args,
> +	bool			roll_trans)
>  {
>  	struct xfs_attr_leafblock *leaf;
>  	struct xfs_attr_leaf_entry *entry;
> @@ -2698,7 +2699,9 @@ xfs_attr3_leaf_clearflag(
>  	/*
>  	 * Commit the flag value change and start the next trans in series.
>  	 */
> -	return xfs_trans_roll_inode(&args->trans, args->dp);
> +	if (roll_trans)
> +		error = xfs_trans_roll_inode(&args->trans, args->dp);
> +	return error;
>  }
>  
>  /*
> @@ -2706,7 +2709,8 @@ xfs_attr3_leaf_clearflag(
>   */
>  int
>  xfs_attr3_leaf_setflag(
> -	struct xfs_da_args	*args)
> +	struct xfs_da_args	*args,
> +	bool			roll_trans)
>  {
>  	struct xfs_attr_leafblock *leaf;
>  	struct xfs_attr_leaf_entry *entry;
> @@ -2749,7 +2753,9 @@ xfs_attr3_leaf_setflag(
>  	/*
>  	 * Commit the flag value change and start the next trans in series.
>  	 */
> -	return xfs_trans_roll_inode(&args->trans, args->dp);
> +	if (roll_trans)
> +		error = xfs_trans_roll_inode(&args->trans, args->dp);
> +	return error;
>  }
>  
>  /*
> @@ -2761,7 +2767,8 @@ xfs_attr3_leaf_setflag(
>   */
>  int
>  xfs_attr3_leaf_flipflags(
> -	struct xfs_da_args	*args)
> +	struct xfs_da_args	*args,
> +	bool			roll_trans)
>  {
>  	struct xfs_attr_leafblock *leaf1;
>  	struct xfs_attr_leafblock *leaf2;
> @@ -2867,7 +2874,8 @@ xfs_attr3_leaf_flipflags(
>  	/*
>  	 * Commit the flag value change and start the next trans in series.
>  	 */
> -	error = xfs_trans_roll_inode(&args->trans, args->dp);
> +	if (roll_trans)
> +		error = xfs_trans_roll_inode(&args->trans, args->dp);
>  
>  	return error;
>  }
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.h b/fs/xfs/libxfs/xfs_attr_leaf.h
> index 7b74e18..9d830ec 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.h
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.h
> @@ -49,10 +49,10 @@ void	xfs_attr_fork_remove(struct xfs_inode *ip, struct xfs_trans *tp);
>   */
>  int	xfs_attr3_leaf_to_node(struct xfs_da_args *args);
>  int	xfs_attr3_leaf_to_shortform(struct xfs_buf *bp,
> -				   struct xfs_da_args *args, int forkoff);
> -int	xfs_attr3_leaf_clearflag(struct xfs_da_args *args);
> -int	xfs_attr3_leaf_setflag(struct xfs_da_args *args);
> -int	xfs_attr3_leaf_flipflags(struct xfs_da_args *args);
> +			struct xfs_da_args *args, int forkoff);
> +int	xfs_attr3_leaf_clearflag(struct xfs_da_args *args, bool roll_trans);
> +int	xfs_attr3_leaf_setflag(struct xfs_da_args *args, bool roll_trans);
> +int	xfs_attr3_leaf_flipflags(struct xfs_da_args *args, bool roll_trans);
>  
>  /*
>   * Routines used for growing the Btree.
> diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
> index 65ff600..18fbd22 100644
> --- a/fs/xfs/libxfs/xfs_attr_remote.c
> +++ b/fs/xfs/libxfs/xfs_attr_remote.c
> @@ -435,7 +435,8 @@ xfs_attr_rmtval_get(
>   */
>  int
>  xfs_attr_rmtval_set(
> -	struct xfs_da_args	*args)
> +	struct xfs_da_args	*args,
> +	bool			roll_trans)
>  {
>  	struct xfs_inode	*dp = args->dp;
>  	struct xfs_mount	*mp = dp->i_mount;
> @@ -488,9 +489,12 @@ xfs_attr_rmtval_set(
>  				  &nmap);
>  		if (error)
>  			return error;
> -		error = xfs_defer_finish(&args->trans);
> -		if (error)
> -			return error;
> +
> +		if (roll_trans) {
> +			error = xfs_defer_finish(&args->trans);
> +			if (error)
> +				return error;
> +		}
>  
>  		ASSERT(nmap == 1);
>  		ASSERT((map.br_startblock != DELAYSTARTBLOCK) &&
> @@ -498,12 +502,14 @@ xfs_attr_rmtval_set(
>  		lblkno += map.br_blockcount;
>  		blkcnt -= map.br_blockcount;
>  
> -		/*
> -		 * Start the next trans in the chain.
> -		 */
> -		error = xfs_trans_roll_inode(&args->trans, dp);
> -		if (error)
> -			return error;
> +		if (roll_trans) {
> +			/*
> +			 * Start the next trans in the chain.
> +			 */
> +			error = xfs_trans_roll_inode(&args->trans, dp);
> +			if (error)
> +				return error;
> +		}
>  	}
>  
>  	/*
> @@ -563,7 +569,8 @@ xfs_attr_rmtval_set(
>   */
>  int
>  xfs_attr_rmtval_remove(
> -	struct xfs_da_args	*args)
> +	struct xfs_da_args	*args,
> +	bool			roll_trans)
>  {
>  	struct xfs_mount	*mp = args->dp->i_mount;
>  	xfs_dablk_t		lblkno;
> @@ -625,16 +632,19 @@ xfs_attr_rmtval_remove(
>  				    XFS_BMAPI_ATTRFORK, 1, &done);
>  		if (error)
>  			return error;
> -		error = xfs_defer_finish(&args->trans);
> -		if (error)
> -			return error;
>  
> -		/*
> -		 * Close out trans and start the next one in the chain.
> -		 */
> -		error = xfs_trans_roll_inode(&args->trans, args->dp);
> -		if (error)
> -			return error;
> +		if (roll_trans) {
> +			error = xfs_defer_finish(&args->trans);
> +			if (error)
> +				return error;
> +
> +			/*
> +			 * Close out trans and start the next one in the chain.
> +			 */
> +			error = xfs_trans_roll_inode(&args->trans, args->dp);
> +			if (error)
> +				return error;
> +		}
>  	}
>  	return 0;
>  }
> diff --git a/fs/xfs/libxfs/xfs_attr_remote.h b/fs/xfs/libxfs/xfs_attr_remote.h
> index 9d20b66..c7c073d 100644
> --- a/fs/xfs/libxfs/xfs_attr_remote.h
> +++ b/fs/xfs/libxfs/xfs_attr_remote.h
> @@ -9,7 +9,7 @@
>  int xfs_attr3_rmt_blocks(struct xfs_mount *mp, int attrlen);
>  
>  int xfs_attr_rmtval_get(struct xfs_da_args *args);
> -int xfs_attr_rmtval_set(struct xfs_da_args *args);
> -int xfs_attr_rmtval_remove(struct xfs_da_args *args);
> +int xfs_attr_rmtval_set(struct xfs_da_args *args, bool roll_trans);
> +int xfs_attr_rmtval_remove(struct xfs_da_args *args, bool roll_trans);
>  
>  #endif /* __XFS_ATTR_REMOTE_H__ */
> -- 
> 2.7.4
> 
