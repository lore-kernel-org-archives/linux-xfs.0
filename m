Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id AA5FB7CA0
	for <xfs@oss.sgi.com>; Tue, 26 Jul 2016 14:10:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 637D8304053
	for <xfs@oss.sgi.com>; Tue, 26 Jul 2016 12:09:58 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id C1i1VFaqQLPZSVMa (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 26 Jul 2016 12:09:57 -0700 (PDT)
Date: Tue, 26 Jul 2016 15:09:54 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 07/47] xfs: add function pointers for get/update keys to
	the btree
Message-ID: <20160726190954.GA10742@bfoster.bfoster>
References: <146907695530.25461.3225785294902719773.stgit@birch.djwong.org>
	<146907700604.25461.2181974283557088355.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <146907700604.25461.2181974283557088355.stgit@birch.djwong.org>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-fsdevel@vger.kernel.org, vishal.l.verma@intel.com, xfs@oss.sgi.com

On Wed, Jul 20, 2016 at 09:56:46PM -0700, Darrick J. Wong wrote:
> Add some function pointers to bc_ops to get the btree keys for
> leaf and node blocks, and to update parent keys of a block.
> Convert the _btree_updkey calls to use our new pointer, and
> modify the tree shape changing code to call the appropriate
> get_*_keys pointer instead of _btree_copy_keys because the
> overlapping btree has to calculate high key values.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_alloc_btree.c  |    4 +
>  fs/xfs/libxfs/xfs_bmap_btree.c   |    4 +
>  fs/xfs/libxfs/xfs_btree.c        |  159 +++++++++++++++++++++++---------------
>  fs/xfs/libxfs/xfs_btree.h        |   19 +++++
>  fs/xfs/libxfs/xfs_ialloc_btree.c |    8 ++
>  5 files changed, 133 insertions(+), 61 deletions(-)
> 
> 
...
> diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
> index 8d8e362..70d1c60 100644
> --- a/fs/xfs/libxfs/xfs_btree.c
> +++ b/fs/xfs/libxfs/xfs_btree.c
...
> @@ -2149,8 +2197,8 @@ xfs_btree_lshift(
>  		rkp = &key;
>  	}
>  
> -	/* Update the parent key values of right. */
> -	error = xfs_btree_updkey(cur, rkp, level + 1);
> +	/* Update the parent keys of the right block. */
> +	error = cur->bc_ops->update_keys(cur, level);

Looks like there's some code to set up rkp just above that can probably
die.

>  	if (error)
>  		goto error0;
>  
> @@ -2321,7 +2369,8 @@ xfs_btree_rshift(
>  	if (error)
>  		goto error1;
>  
> -	error = xfs_btree_updkey(tcur, rkp, level + 1);
> +	/* Update the parent keys of the right block. */
> +	error = cur->bc_ops->update_keys(tcur, level);

Similar deal here, just a bit further up.

>  	if (error)
>  		goto error1;
>  
> @@ -2422,6 +2471,10 @@ __xfs_btree_split(
>  
>  	XFS_BTREE_STATS_ADD(cur, moves, rrecs);
>  
> +	lrecs -= rrecs;
> +	xfs_btree_set_numrecs(left, lrecs);
> +	xfs_btree_set_numrecs(right, xfs_btree_get_numrecs(right) + rrecs);
> +
>  	/*
>  	 * Copy btree block entries from the left block over to the
>  	 * new block, the right. Update the right block and log the
> @@ -2447,14 +2500,15 @@ __xfs_btree_split(
>  		}
>  #endif
>  
> +		/* Copy the keys & pointers to the new block. */
>  		xfs_btree_copy_keys(cur, rkp, lkp, rrecs);
>  		xfs_btree_copy_ptrs(cur, rpp, lpp, rrecs);
>  
>  		xfs_btree_log_keys(cur, rbp, 1, rrecs);
>  		xfs_btree_log_ptrs(cur, rbp, 1, rrecs);
>  
> -		/* Grab the keys to the entries moved to the right block */
> -		xfs_btree_copy_keys(cur, key, rkp, 1);
> +		/* Stash the keys of the new block for later insertion. */
> +		cur->bc_ops->get_node_keys(cur, right, key);
>  	} else {
>  		/* It's a leaf.  Move records.  */
>  		union xfs_btree_rec	*lrp;	/* left record pointer */
> @@ -2463,14 +2517,14 @@ __xfs_btree_split(
>  		lrp = xfs_btree_rec_addr(cur, src_index, left);
>  		rrp = xfs_btree_rec_addr(cur, 1, right);
>  
> +		/* Copy records to the new block. */
>  		xfs_btree_copy_recs(cur, rrp, lrp, rrecs);
>  		xfs_btree_log_recs(cur, rbp, 1, rrecs);
>  
> -		cur->bc_ops->init_key_from_rec(key,
> -			xfs_btree_rec_addr(cur, 1, right));
> +		/* Stash the keys of the new block for later insertion. */
> +		cur->bc_ops->get_leaf_keys(cur, right, key);
>  	}
>  
> -
>  	/*
>  	 * Find the left block number by looking in the buffer.
>  	 * Adjust numrecs, sibling pointers.
> @@ -2480,10 +2534,6 @@ __xfs_btree_split(
>  	xfs_btree_set_sibling(cur, right, &lptr, XFS_BB_LEFTSIB);
>  	xfs_btree_set_sibling(cur, left, &rptr, XFS_BB_RIGHTSIB);
>  
> -	lrecs -= rrecs;
> -	xfs_btree_set_numrecs(left, lrecs);
> -	xfs_btree_set_numrecs(right, xfs_btree_get_numrecs(right) + rrecs);
> -

The immediately previous comment needs an update if this gets moved.

>  	xfs_btree_log_block(cur, rbp, XFS_BB_ALL_BITS);
>  	xfs_btree_log_block(cur, lbp, XFS_BB_NUMRECS | XFS_BB_RIGHTSIB);
>  
...
> diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
> index b4f3035..bb40457 100644
> --- a/fs/xfs/libxfs/xfs_btree.h
> +++ b/fs/xfs/libxfs/xfs_btree.h
> @@ -180,6 +180,19 @@ struct xfs_btree_ops {
>  				union xfs_btree_rec *r1,
>  				union xfs_btree_rec *r2);
>  #endif
> +
> +	/* derive the low & high keys from the records in a leaf block */
> +	void	(*get_leaf_keys)(struct xfs_btree_cur *cur,
> +				 struct xfs_btree_block *block,
> +				 union xfs_btree_key *key);
> +
> +	/* derive the low & high keys from the keys in a node block */
> +	void	(*get_node_keys)(struct xfs_btree_cur *cur,
> +				 struct xfs_btree_block *block,
> +				 union xfs_btree_key *key);
> +
> +	/* update the parent keys of given btree level */
> +	int	(*update_keys)(struct xfs_btree_cur *cur, int level);
>  };
>  
>  /*
> @@ -474,5 +487,11 @@ bool xfs_btree_sblock_v5hdr_verify(struct xfs_buf *bp);
>  bool xfs_btree_sblock_verify(struct xfs_buf *bp, unsigned int max_recs);
>  uint xfs_btree_compute_maxlevels(struct xfs_mount *mp, uint *limits,
>  				 unsigned long len);
> + 

Whitespace damage here ^

Brian

> +void xfs_btree_get_leaf_keys(struct xfs_btree_cur *cur,
> +		struct xfs_btree_block *block, union xfs_btree_key *key);
> +void xfs_btree_get_node_keys(struct xfs_btree_cur *cur,
> +		struct xfs_btree_block *block, union xfs_btree_key *key);
> +int xfs_btree_update_keys(struct xfs_btree_cur *cur, int level);
>  
>  #endif	/* __XFS_BTREE_H__ */
> diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
> index 88da2ad..a48f448 100644
> --- a/fs/xfs/libxfs/xfs_ialloc_btree.c
> +++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
> @@ -314,6 +314,10 @@ static const struct xfs_btree_ops xfs_inobt_ops = {
>  	.keys_inorder		= xfs_inobt_keys_inorder,
>  	.recs_inorder		= xfs_inobt_recs_inorder,
>  #endif
> +
> +	.get_leaf_keys		= xfs_btree_get_leaf_keys,
> +	.get_node_keys		= xfs_btree_get_node_keys,
> +	.update_keys		= xfs_btree_update_keys,
>  };
>  
>  static const struct xfs_btree_ops xfs_finobt_ops = {
> @@ -335,6 +339,10 @@ static const struct xfs_btree_ops xfs_finobt_ops = {
>  	.keys_inorder		= xfs_inobt_keys_inorder,
>  	.recs_inorder		= xfs_inobt_recs_inorder,
>  #endif
> +
> +	.get_leaf_keys		= xfs_btree_get_leaf_keys,
> +	.get_node_keys		= xfs_btree_get_node_keys,
> +	.update_keys		= xfs_btree_update_keys,
>  };
>  
>  /*
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
