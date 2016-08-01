Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id EAA017D24
	for <xfs@oss.sgi.com>; Mon,  1 Aug 2016 12:54:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7F5AF304051
	for <xfs@oss.sgi.com>; Mon,  1 Aug 2016 10:54:16 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id wBeBZBhfHTjSYfpO (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 01 Aug 2016 10:54:13 -0700 (PDT)
Date: Mon, 1 Aug 2016 10:54:07 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2 07/47] xfs: add function pointers for get/update keys
	to the btree
Message-ID: <20160801175407.GA8593@birch.djwong.org>
References: <146907695530.25461.3225785294902719773.stgit@birch.djwong.org>
	<146907700604.25461.2181974283557088355.stgit@birch.djwong.org>
	<20160728194615.GA15746@birch.djwong.org>
	<20160801155736.GA64218@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160801155736.GA64218@bfoster.bfoster>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, vishal.l.verma@intel.com, xfs@oss.sgi.com

On Mon, Aug 01, 2016 at 11:57:36AM -0400, Brian Foster wrote:
> On Thu, Jul 28, 2016 at 12:46:15PM -0700, Darrick J. Wong wrote:
> > Add some function pointers to bc_ops to get the btree keys for
> > leaf and node blocks, and to update parent keys of a block.
> > Convert the _btree_updkey calls to use our new pointer, and
> > modify the tree shape changing code to call the appropriate
> > get_*_keys pointer instead of _btree_copy_keys because the
> > overlapping btree has to calculate high key values.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/libxfs/xfs_alloc_btree.c  |    4 +
> >  fs/xfs/libxfs/xfs_bmap_btree.c   |    4 +
> >  fs/xfs/libxfs/xfs_btree.c        |  164 +++++++++++++++++++++++---------------
> >  fs/xfs/libxfs/xfs_btree.h        |   19 ++++
> >  fs/xfs/libxfs/xfs_ialloc_btree.c |    8 ++
> >  5 files changed, 135 insertions(+), 64 deletions(-)
> > 
> ...
> > diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
> > index 8d8e362..405442d 100644
> > --- a/fs/xfs/libxfs/xfs_btree.c
> > +++ b/fs/xfs/libxfs/xfs_btree.c
> ...
> > @@ -2146,11 +2194,10 @@ xfs_btree_lshift(
> >  		 */
> >  		cur->bc_ops->init_key_from_rec(&key,
> >  			xfs_btree_rec_addr(cur, 1, right));
> > -		rkp = &key;
> 
> Sorry, I should have been more clear. I think this entire hunk (the
> above key initialization and comment) is effectively dead.
> 
> >  	}
> >  
> > -	/* Update the parent key values of right. */
> > -	error = xfs_btree_updkey(cur, rkp, level + 1);
> > +	/* Update the parent keys of the right block. */
> > +	error = cur->bc_ops->update_keys(cur, level);
> >  	if (error)
> >  		goto error0;
> >  
> > @@ -2292,7 +2339,6 @@ xfs_btree_rshift(
> >  		xfs_btree_log_recs(cur, rbp, 1, rrecs + 1);
> >  
> >  		cur->bc_ops->init_key_from_rec(&key, rrp);
> > -		rkp = &key;
> 
> Same here. key isn't used beyond this.
> 
> I see that hch has some objections to the design here. FWIW, resolution
> of that aside, and with the above fixes:

Ah, right.  "key" and its initializers can go away in both functions.
I'll fix that and find out if Dave wants to take this (and the other fixes)
for a 4.8 merge request, or just defer them until -rc2.

--D

> Reviewed-by: Brian Foster <bfoster@redhat.com>
> 
> >  
> >  		ASSERT(cur->bc_ops->recs_inorder(cur, rrp,
> >  			xfs_btree_rec_addr(cur, 2, right)));
> > @@ -2321,7 +2367,8 @@ xfs_btree_rshift(
> >  	if (error)
> >  		goto error1;
> >  
> > -	error = xfs_btree_updkey(tcur, rkp, level + 1);
> > +	/* Update the parent keys of the right block. */
> > +	error = cur->bc_ops->update_keys(tcur, level);
> >  	if (error)
> >  		goto error1;
> >  
> > @@ -2422,6 +2469,11 @@ __xfs_btree_split(
> >  
> >  	XFS_BTREE_STATS_ADD(cur, moves, rrecs);
> >  
> > +	/* Adjust numrecs for the later get_*_keys() calls. */
> > +	lrecs -= rrecs;
> > +	xfs_btree_set_numrecs(left, lrecs);
> > +	xfs_btree_set_numrecs(right, xfs_btree_get_numrecs(right) + rrecs);
> > +
> >  	/*
> >  	 * Copy btree block entries from the left block over to the
> >  	 * new block, the right. Update the right block and log the
> > @@ -2447,14 +2499,15 @@ __xfs_btree_split(
> >  		}
> >  #endif
> >  
> > +		/* Copy the keys & pointers to the new block. */
> >  		xfs_btree_copy_keys(cur, rkp, lkp, rrecs);
> >  		xfs_btree_copy_ptrs(cur, rpp, lpp, rrecs);
> >  
> >  		xfs_btree_log_keys(cur, rbp, 1, rrecs);
> >  		xfs_btree_log_ptrs(cur, rbp, 1, rrecs);
> >  
> > -		/* Grab the keys to the entries moved to the right block */
> > -		xfs_btree_copy_keys(cur, key, rkp, 1);
> > +		/* Stash the keys of the new block for later insertion. */
> > +		cur->bc_ops->get_node_keys(cur, right, key);
> >  	} else {
> >  		/* It's a leaf.  Move records.  */
> >  		union xfs_btree_rec	*lrp;	/* left record pointer */
> > @@ -2463,27 +2516,23 @@ __xfs_btree_split(
> >  		lrp = xfs_btree_rec_addr(cur, src_index, left);
> >  		rrp = xfs_btree_rec_addr(cur, 1, right);
> >  
> > +		/* Copy records to the new block. */
> >  		xfs_btree_copy_recs(cur, rrp, lrp, rrecs);
> >  		xfs_btree_log_recs(cur, rbp, 1, rrecs);
> >  
> > -		cur->bc_ops->init_key_from_rec(key,
> > -			xfs_btree_rec_addr(cur, 1, right));
> > +		/* Stash the keys of the new block for later insertion. */
> > +		cur->bc_ops->get_leaf_keys(cur, right, key);
> >  	}
> >  
> > -
> >  	/*
> >  	 * Find the left block number by looking in the buffer.
> > -	 * Adjust numrecs, sibling pointers.
> > +	 * Adjust sibling pointers.
> >  	 */
> >  	xfs_btree_get_sibling(cur, left, &rrptr, XFS_BB_RIGHTSIB);
> >  	xfs_btree_set_sibling(cur, right, &rrptr, XFS_BB_RIGHTSIB);
> >  	xfs_btree_set_sibling(cur, right, &lptr, XFS_BB_LEFTSIB);
> >  	xfs_btree_set_sibling(cur, left, &rptr, XFS_BB_RIGHTSIB);
> >  
> > -	lrecs -= rrecs;
> > -	xfs_btree_set_numrecs(left, lrecs);
> > -	xfs_btree_set_numrecs(right, xfs_btree_get_numrecs(right) + rrecs);
> > -
> >  	xfs_btree_log_block(cur, rbp, XFS_BB_ALL_BITS);
> >  	xfs_btree_log_block(cur, lbp, XFS_BB_NUMRECS | XFS_BB_RIGHTSIB);
> >  
> > @@ -2802,6 +2851,7 @@ xfs_btree_new_root(
> >  		bp = lbp;
> >  		nptr = 2;
> >  	}
> > +
> >  	/* Fill in the new block's btree header and log it. */
> >  	xfs_btree_init_block_cur(cur, nbp, cur->bc_nlevels, 2);
> >  	xfs_btree_log_block(cur, nbp, XFS_BB_ALL_BITS);
> > @@ -2810,19 +2860,24 @@ xfs_btree_new_root(
> >  
> >  	/* Fill in the key data in the new root. */
> >  	if (xfs_btree_get_level(left) > 0) {
> > -		xfs_btree_copy_keys(cur,
> > -				xfs_btree_key_addr(cur, 1, new),
> > -				xfs_btree_key_addr(cur, 1, left), 1);
> > -		xfs_btree_copy_keys(cur,
> > -				xfs_btree_key_addr(cur, 2, new),
> > -				xfs_btree_key_addr(cur, 1, right), 1);
> > +		/*
> > +		 * Get the keys for the left block's keys and put them directly
> > +		 * in the parent block.  Do the same for the right block.
> > +		 */
> > +		cur->bc_ops->get_node_keys(cur, left,
> > +				xfs_btree_key_addr(cur, 1, new));
> > +		cur->bc_ops->get_node_keys(cur, right,
> > +				xfs_btree_key_addr(cur, 2, new));
> >  	} else {
> > -		cur->bc_ops->init_key_from_rec(
> > -				xfs_btree_key_addr(cur, 1, new),
> > -				xfs_btree_rec_addr(cur, 1, left));
> > -		cur->bc_ops->init_key_from_rec(
> > -				xfs_btree_key_addr(cur, 2, new),
> > -				xfs_btree_rec_addr(cur, 1, right));
> > +		/*
> > +		 * Get the keys for the left block's records and put them
> > +		 * directly in the parent block.  Do the same for the right
> > +		 * block.
> > +		 */
> > +		cur->bc_ops->get_leaf_keys(cur, left,
> > +			xfs_btree_key_addr(cur, 1, new));
> > +		cur->bc_ops->get_leaf_keys(cur, right,
> > +			xfs_btree_key_addr(cur, 2, new));
> >  	}
> >  	xfs_btree_log_keys(cur, nbp, 1, 2);
> >  
> > @@ -2858,7 +2913,7 @@ xfs_btree_make_block_unfull(
> >  	int			*index,	/* new tree index */
> >  	union xfs_btree_ptr	*nptr,	/* new btree ptr */
> >  	struct xfs_btree_cur	**ncur,	/* new btree cursor */
> > -	union xfs_btree_key	*key, /* key of new block */
> > +	union xfs_btree_key	*key,	/* key of new block */
> >  	int			*stat)
> >  {
> >  	int			error = 0;
> > @@ -3086,8 +3141,8 @@ xfs_btree_insrec(
> >  	xfs_btree_log_block(cur, bp, XFS_BB_NUMRECS);
> >  
> >  	/* If we inserted at the start of a block, update the parents' keys. */
> > -	if (optr == 1) {
> > -		error = xfs_btree_updkey(cur, key, level + 1);
> > +	if (xfs_btree_needs_key_update(cur, optr)) {
> > +		error = cur->bc_ops->update_keys(cur, level);
> >  		if (error)
> >  			goto error0;
> >  	}
> > @@ -3107,7 +3162,7 @@ xfs_btree_insrec(
> >  	 */
> >  	*ptrp = nptr;
> >  	if (!xfs_btree_ptr_is_null(cur, &nptr)) {
> > -		*key = nkey;
> > +		xfs_btree_copy_keys(cur, key, &nkey, 1);
> >  		*curp = ncur;
> >  	}
> >  
> > @@ -3386,8 +3441,6 @@ xfs_btree_delrec(
> >  	struct xfs_buf		*bp;		/* buffer for block */
> >  	int			error;		/* error return value */
> >  	int			i;		/* loop counter */
> > -	union xfs_btree_key	key;		/* storage for keyp */
> > -	union xfs_btree_key	*keyp = &key;	/* passed to the next level */
> >  	union xfs_btree_ptr	lptr;		/* left sibling block ptr */
> >  	struct xfs_buf		*lbp;		/* left buffer pointer */
> >  	struct xfs_btree_block	*left;		/* left btree block */
> > @@ -3458,13 +3511,6 @@ xfs_btree_delrec(
> >  			xfs_btree_log_keys(cur, bp, ptr, numrecs - 1);
> >  			xfs_btree_log_ptrs(cur, bp, ptr, numrecs - 1);
> >  		}
> > -
> > -		/*
> > -		 * If it's the first record in the block, we'll need to pass a
> > -		 * key up to the next level (updkey).
> > -		 */
> > -		if (ptr == 1)
> > -			keyp = xfs_btree_key_addr(cur, 1, block);
> >  	} else {
> >  		/* It's a leaf. operate on records */
> >  		if (ptr < numrecs) {
> > @@ -3473,16 +3519,6 @@ xfs_btree_delrec(
> >  				-1, numrecs - ptr);
> >  			xfs_btree_log_recs(cur, bp, ptr, numrecs - 1);
> >  		}
> > -
> > -		/*
> > -		 * If it's the first record in the block, we'll need a key
> > -		 * structure to pass up to the next level (updkey).
> > -		 */
> > -		if (ptr == 1) {
> > -			cur->bc_ops->init_key_from_rec(&key,
> > -					xfs_btree_rec_addr(cur, 1, block));
> > -			keyp = &key;
> > -		}
> >  	}
> >  
> >  	/*
> > @@ -3549,8 +3585,8 @@ xfs_btree_delrec(
> >  	 * If we deleted the leftmost entry in the block, update the
> >  	 * key values above us in the tree.
> >  	 */
> > -	if (ptr == 1) {
> > -		error = xfs_btree_updkey(cur, keyp, level + 1);
> > +	if (xfs_btree_needs_key_update(cur, ptr)) {
> > +		error = cur->bc_ops->update_keys(cur, level);
> >  		if (error)
> >  			goto error0;
> >  	}
> > diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
> > index b4f3035..e097e60 100644
> > --- a/fs/xfs/libxfs/xfs_btree.h
> > +++ b/fs/xfs/libxfs/xfs_btree.h
> > @@ -180,6 +180,19 @@ struct xfs_btree_ops {
> >  				union xfs_btree_rec *r1,
> >  				union xfs_btree_rec *r2);
> >  #endif
> > +
> > +	/* derive the low & high keys from the records in a leaf block */
> > +	void	(*get_leaf_keys)(struct xfs_btree_cur *cur,
> > +				 struct xfs_btree_block *block,
> > +				 union xfs_btree_key *key);
> > +
> > +	/* derive the low & high keys from the keys in a node block */
> > +	void	(*get_node_keys)(struct xfs_btree_cur *cur,
> > +				 struct xfs_btree_block *block,
> > +				 union xfs_btree_key *key);
> > +
> > +	/* update the parent keys of given btree level */
> > +	int	(*update_keys)(struct xfs_btree_cur *cur, int level);
> >  };
> >  
> >  /*
> > @@ -475,4 +488,10 @@ bool xfs_btree_sblock_verify(struct xfs_buf *bp, unsigned int max_recs);
> >  uint xfs_btree_compute_maxlevels(struct xfs_mount *mp, uint *limits,
> >  				 unsigned long len);
> >  
> > +void xfs_btree_get_leaf_keys(struct xfs_btree_cur *cur,
> > +		struct xfs_btree_block *block, union xfs_btree_key *key);
> > +void xfs_btree_get_node_keys(struct xfs_btree_cur *cur,
> > +		struct xfs_btree_block *block, union xfs_btree_key *key);
> > +int xfs_btree_update_keys(struct xfs_btree_cur *cur, int level);
> > +
> >  #endif	/* __XFS_BTREE_H__ */
> > diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
> > index 88da2ad..a48f448 100644
> > --- a/fs/xfs/libxfs/xfs_ialloc_btree.c
> > +++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
> > @@ -314,6 +314,10 @@ static const struct xfs_btree_ops xfs_inobt_ops = {
> >  	.keys_inorder		= xfs_inobt_keys_inorder,
> >  	.recs_inorder		= xfs_inobt_recs_inorder,
> >  #endif
> > +
> > +	.get_leaf_keys		= xfs_btree_get_leaf_keys,
> > +	.get_node_keys		= xfs_btree_get_node_keys,
> > +	.update_keys		= xfs_btree_update_keys,
> >  };
> >  
> >  static const struct xfs_btree_ops xfs_finobt_ops = {
> > @@ -335,6 +339,10 @@ static const struct xfs_btree_ops xfs_finobt_ops = {
> >  	.keys_inorder		= xfs_inobt_keys_inorder,
> >  	.recs_inorder		= xfs_inobt_recs_inorder,
> >  #endif
> > +
> > +	.get_leaf_keys		= xfs_btree_get_leaf_keys,
> > +	.get_node_keys		= xfs_btree_get_node_keys,
> > +	.update_keys		= xfs_btree_update_keys,
> >  };
> >  
> >  /*
> > 
> > _______________________________________________
> > xfs mailing list
> > xfs@oss.sgi.com
> > http://oss.sgi.com/mailman/listinfo/xfs
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
