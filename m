Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40140 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726421AbfDWOTE (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 23 Apr 2019 10:19:04 -0400
Date: Tue, 23 Apr 2019 10:19:02 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 8/9] xfs: Roll delayed attr operations by returning EAGAIN
Message-ID: <20190423141901.GA10224@bfoster>
References: <20190412225036.22939-1-allison.henderson@oracle.com>
 <20190412225036.22939-9-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190412225036.22939-9-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Allison Henderson <allison.henderson@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Apr 12, 2019 at 03:50:35PM -0700, Allison Henderson wrote:
> This patch modifies xfs_attr_set_args to return -EAGAIN
> when a transaction needs to be rolled.  All functions
> currently calling xfs_attr_set_args are modified to use
> the deferred attr operation, or handle the -EAGAIN return
> code
> 
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c | 62 ++++++++++++++++++++++++++++++++++++++++--------
>  fs/xfs/libxfs/xfs_attr.h |  2 +-
>  fs/xfs/xfs_attr_item.c   | 41 +++++++++++++++++++++++++++-----
>  fs/xfs/xfs_trans.h       |  2 ++
>  fs/xfs/xfs_trans_attr.c  | 56 +++++++++++++++++++++++++------------------
>  5 files changed, 123 insertions(+), 40 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 0042708..4ddd86b 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -236,10 +236,37 @@ int
>  xfs_attr_set_args(
>  	struct xfs_da_args	*args,
>  	struct xfs_buf          **leaf_bp,
> +	enum xfs_attr_state	*state,
>  	bool			roll_trans)
>  {
>  	struct xfs_inode	*dp = args->dp;
>  	int			error = 0;
> +	int			sf_size;
> +
> +	switch (*state) {
> +	case (XFS_ATTR_STATE1):
> +		goto state1;
> +	case (XFS_ATTR_STATE2):
> +		goto state2;
> +	case (XFS_ATTR_STATE3):
> +		goto state3;
> +	}
> +
> +	/*
> +	 * New inodes may not have an attribute fork yet. So set the attribute
> +	 * fork appropriately
> +	 */
> +	if (XFS_IFORK_Q((args->dp)) == 0) {
> +		sf_size = sizeof(struct xfs_attr_sf_hdr) +
> +		     XFS_ATTR_SF_ENTSIZE_BYNAME(args->namelen, args->valuelen);
> +		xfs_bmap_set_attrforkoff(args->dp, sf_size, NULL);
> +		args->dp->i_afp = kmem_zone_zalloc(xfs_ifork_zone, KM_SLEEP);
> +		args->dp->i_afp->if_flags = XFS_IFEXTENTS;
> +	}
> +
> +	*state = XFS_ATTR_STATE1;
> +	return -EAGAIN;

As noted previously, this return seems unnecessary since we've not done
anything in the transaction to this point.

> +state1:
>  
>  	/*
>  	 * If the attribute list is non-existent or a shortform list,
> @@ -248,7 +275,6 @@ xfs_attr_set_args(
>  	if (dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL ||
>  	    (dp->i_d.di_aformat == XFS_DINODE_FMT_EXTENTS &&
>  	     dp->i_d.di_anextents == 0)) {
> -
>  		/*
>  		 * Build initial attribute list (if required).
>  		 */
> @@ -262,6 +288,9 @@ xfs_attr_set_args(
>  		if (error != -ENOSPC)
>  			return error;
>  
> +		*state = XFS_ATTR_STATE2;
> +		return -EAGAIN;
> +state2:

Here we've failed the sf add but not yet done the conversion, which
means we've still not done anything in the transaction. I suspect we
should probably convert to leaf and then return -EAGAIN.

>  		/*
>  		 * It won't fit in the shortform, transform to a leaf block.
>  		 * GROT: another possible req'mt for a double-split btree op.
> @@ -270,14 +299,14 @@ xfs_attr_set_args(
>  		if (error)
>  			return error;
>  
> -		if (roll_trans) {
> -			/*
> -			 * Prevent the leaf buffer from being unlocked so that a
> -			 * concurrent AIL push cannot grab the half-baked leaf
> -			 * buffer and run into problems with the write verifier.
> -			 */
> -			xfs_trans_bhold(args->trans, *leaf_bp);
> +		/*
> +		 * Prevent the leaf buffer from being unlocked so that a
> +		 * concurrent AIL push cannot grab the half-baked leaf
> +		 * buffer and run into problems with the write verifier.
> +		 */
> +		xfs_trans_bhold(args->trans, *leaf_bp);
>  
> +		if (roll_trans) {
>  			error = xfs_defer_finish(&args->trans);
>  			if (error)
>  				return error;
> @@ -293,6 +322,12 @@ xfs_attr_set_args(
>  			xfs_trans_bjoin(args->trans, *leaf_bp);
>  			*leaf_bp = NULL;
>  		}
> +
> +		*state = XFS_ATTR_STATE3;
> +		return -EAGAIN;
> +state3:

Hmm, and this appears to be the last place we return -EAGAIN from the
set code. Am I following this correctly that we basically expect any of
the other rolls down in xfs_attr_[leaf|node]_addname() to go away in
deferred context? If so, why is that?

That aside, I'm wondering whether we need the whole state thing to track
this. For example, why not have a high level flow as something like the
following?

xfs_attr_set_args()
{
	...
	if (local format) {
		error = xfs_attr_try_sf_addname(dp, args);
		if (error == -ENOSPC) {
			error = xfs_attr_shortform_to_leaf(args, leaf_bp);
			return -EAGAIN;
		} else
			return error;
	} else if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
		error = xfs_attr_leaf_addname(args);
	} else {
		error = xfs_attr_node_addname(args);
	}
}

Of course, this may need further changes if we do end up incorporating
the rolls down in the leaf/node functions. Perhaps we could pull apart
those functions such that we -EAGAIN on the conversions required to
address -ENOSPC returns. That might provide a natural boundary to
re-enter the top-level function without the need for a state machine, at
least for any rolls that occurs before we actually do an attr op
(post-op rolls may very well require more state to incorporate).
Thoughts?

Brian

> +		if (*leaf_bp != NULL)
> +			xfs_trans_brelse(args->trans, *leaf_bp);
>  	}
>  
>  	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
> @@ -419,7 +454,9 @@ xfs_attr_set(
>  		goto out_trans_cancel;
>  
>  	xfs_trans_ijoin(args.trans, dp, 0);
> -	error = xfs_attr_set_args(&args, &leaf_bp, true);
> +
> +	error = xfs_attr_set_deferred(dp, args.trans, name, namelen,
> +			value, valuelen, flags);
>  	if (error)
>  		goto out_release_leaf;
>  	if (!args.trans) {
> @@ -554,8 +591,13 @@ xfs_attr_remove(
>  	 */
>  	xfs_trans_ijoin(args.trans, dp, 0);
>  
> -	error = xfs_attr_remove_args(&args, true);
> +	error = xfs_has_attr(&args);
> +	if (error)
> +		goto out;
> +
>  
> +	error = xfs_attr_remove_deferred(dp, args.trans,
> +			name, namelen, flags);
>  	if (error)
>  		goto out;
>  
> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> index 4ce3b0a..da95e69 100644
> --- a/fs/xfs/libxfs/xfs_attr.h
> +++ b/fs/xfs/libxfs/xfs_attr.h
> @@ -181,7 +181,7 @@ int xfs_attr_set(struct xfs_inode *dp, const unsigned char *name,
>  		 size_t namelen, unsigned char *value, int valuelen,
>  		 int flags);
>  int xfs_attr_set_args(struct xfs_da_args *args, struct xfs_buf **leaf_bp,
> -		 bool roll_trans);
> +		 enum xfs_attr_state *state, bool roll_trans);
>  int xfs_attr_remove(struct xfs_inode *dp, const unsigned char *name,
>  		    size_t namelen, int flags);
>  int xfs_has_attr(struct xfs_da_args *args);
> diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
> index 36e6d1e..292d608 100644
> --- a/fs/xfs/xfs_attr_item.c
> +++ b/fs/xfs/xfs_attr_item.c
> @@ -464,8 +464,11 @@ xfs_attri_recover(
>  	struct xfs_attri_log_format	*attrp;
>  	struct xfs_trans_res		tres;
>  	int				local;
> -	int				error = 0;
> +	int				error, err2 = 0;
>  	int				rsvd = 0;
> +	enum xfs_attr_state		state = 0;
> +	struct xfs_buf			*leaf_bp = NULL;
> +
>  
>  	ASSERT(!test_bit(XFS_ATTRI_RECOVERED, &attrip->flags));
>  
> @@ -540,14 +543,40 @@ xfs_attri_recover(
>  	xfs_ilock(ip, XFS_ILOCK_EXCL);
>  
>  	xfs_trans_ijoin(args.trans, ip, 0);
> -	error = xfs_trans_attr(&args, attrdp, attrp->alfi_op_flags);
> -	if (error)
> -		goto abort_error;
>  
> +	do {
> +		leaf_bp = NULL;
> +
> +		error = xfs_trans_attr(&args, attrdp, &leaf_bp, &state,
> +				attrp->alfi_op_flags);
> +		if (error && error != -EAGAIN)
> +			goto abort_error;
> +
> +		xfs_trans_log_inode(args.trans, ip,
> +				XFS_ILOG_CORE | XFS_ILOG_ADATA);
> +
> +		err2 = xfs_trans_commit(args.trans);
> +		if (err2) {
> +			error = err2;
> +			goto abort_error;
> +		}
> +
> +		if (error == -EAGAIN) {
> +			err2 = xfs_trans_alloc(mp, &tres, args.total, 0,
> +				XFS_TRANS_PERM_LOG_RES, &args.trans);
> +			if (err2) {
> +				error = err2;
> +				goto abort_error;
> +			}
> +			xfs_trans_ijoin(args.trans, ip, 0);
> +		}
> +
> +	} while (error == -EAGAIN);
> +
> +	if (leaf_bp)
> +		xfs_trans_brelse(args.trans, leaf_bp);
>  
>  	set_bit(XFS_ATTRI_RECOVERED, &attrip->flags);
> -	xfs_trans_log_inode(args.trans, ip, XFS_ILOG_CORE | XFS_ILOG_ADATA);
> -	error = xfs_trans_commit(args.trans);
>  	xfs_iunlock(ip, XFS_ILOCK_EXCL);
>  	return error;
>  
> diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
> index 7bb9d8e..c785cd7 100644
> --- a/fs/xfs/xfs_trans.h
> +++ b/fs/xfs/xfs_trans.h
> @@ -239,6 +239,8 @@ xfs_trans_get_attrd(struct xfs_trans *tp,
>  		    struct xfs_attri_log_item *attrip);
>  int xfs_trans_attr(struct xfs_da_args *args,
>  		   struct xfs_attrd_log_item *attrdp,
> +		   struct xfs_buf **leaf_bp,
> +		   void *state,
>  		   uint32_t attr_op_flags);
>  
>  int		xfs_trans_commit(struct xfs_trans *);
> diff --git a/fs/xfs/xfs_trans_attr.c b/fs/xfs/xfs_trans_attr.c
> index 3679348..a3339ea 100644
> --- a/fs/xfs/xfs_trans_attr.c
> +++ b/fs/xfs/xfs_trans_attr.c
> @@ -56,10 +56,11 @@ int
>  xfs_trans_attr(
>  	struct xfs_da_args		*args,
>  	struct xfs_attrd_log_item	*attrdp,
> +	struct xfs_buf			**leaf_bp,
> +	void				*state,
>  	uint32_t			op_flags)
>  {
>  	int				error;
> -	struct xfs_buf			*leaf_bp = NULL;
>  
>  	error = xfs_qm_dqattach_locked(args->dp, 0);
>  	if (error)
> @@ -68,7 +69,8 @@ xfs_trans_attr(
>  	switch (op_flags) {
>  	case XFS_ATTR_OP_FLAGS_SET:
>  		args->op_flags |= XFS_DA_OP_ADDNAME;
> -		error = xfs_attr_set_args(args, &leaf_bp, false);
> +		error = xfs_attr_set_args(args, leaf_bp,
> +				(enum xfs_attr_state *)state, false);
>  		break;
>  	case XFS_ATTR_OP_FLAGS_REMOVE:
>  		ASSERT(XFS_IFORK_Q((args->dp)));
> @@ -78,11 +80,6 @@ xfs_trans_attr(
>  		error = -EFSCORRUPTED;
>  	}
>  
> -	if (error) {
> -		if (leaf_bp)
> -			xfs_trans_brelse(args->trans, leaf_bp);
> -	}
> -
>  	/*
>  	 * Mark the transaction dirty, even on error. This ensures the
>  	 * transaction is aborted, which:
> @@ -184,27 +181,40 @@ xfs_attr_finish_item(
>  	char				*name_value;
>  	int				error;
>  	int				local;
> -	struct xfs_da_args		args;
> +	struct xfs_da_args		*args;
>  
>  	attr = container_of(item, struct xfs_attr_item, xattri_list);
> -	name_value = ((char *)attr) + sizeof(struct xfs_attr_item);
> -
> -	error = xfs_attr_args_init(&args, attr->xattri_ip, name_value,
> -				   attr->xattri_name_len, attr->xattri_flags);
> -	if (error)
> -		goto out;
> +	args = &attr->xattri_args;
> +
> +	if (attr->xattri_state == 0) {
> +		/* Only need to initialize args context once */
> +		name_value = ((char *)attr) + sizeof(struct xfs_attr_item);
> +		error = xfs_attr_args_init(args, attr->xattri_ip, name_value,
> +					   attr->xattri_name_len,
> +					   attr->xattri_flags);
> +		if (error)
> +			goto out;
> +
> +		args->hashval = xfs_da_hashname(args->name, args->namelen);
> +		args->value = &name_value[attr->xattri_name_len];
> +		args->valuelen = attr->xattri_value_len;
> +		args->op_flags = XFS_DA_OP_OKNOENT;
> +		args->total = xfs_attr_calc_size(args, &local);
> +		attr->xattri_leaf_bp = NULL;
> +	}
>  
> -	args.hashval = xfs_da_hashname(args.name, args.namelen);
> -	args.value = &name_value[attr->xattri_name_len];
> -	args.valuelen = attr->xattri_value_len;
> -	args.op_flags = XFS_DA_OP_OKNOENT;
> -	args.total = xfs_attr_calc_size(&args, &local);
> -	args.trans = tp;
> +	/*
> +	 * Always reset trans after EAGAIN cycle
> +	 * since the transaction is new
> +	 */
> +	args->trans = tp;
>  
> -	error = xfs_trans_attr(&args, done_item,
> -			attr->xattri_op_flags);
> +	error = xfs_trans_attr(args, done_item, &attr->xattri_leaf_bp,
> +			&attr->xattri_state, attr->xattri_op_flags);
>  out:
> -	kmem_free(attr);
> +	if (error != -EAGAIN)
> +		kmem_free(attr);
> +
>  	return error;
>  }
>  
> -- 
> 2.7.4
> 
