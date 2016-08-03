Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id ECF4E7CA4
	for <xfs@oss.sgi.com>; Tue,  2 Aug 2016 19:13:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A3B37304032
	for <xfs@oss.sgi.com>; Tue,  2 Aug 2016 17:13:31 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id Vwi1sBIBUFyiS2SQ (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 02 Aug 2016 17:13:28 -0700 (PDT)
Date: Tue, 2 Aug 2016 17:12:57 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 07/47] xfs: add function pointers for get/update keys to
	the btree
Message-ID: <20160803001257.GO8590@birch.djwong.org>
References: <146907695530.25461.3225785294902719773.stgit@birch.djwong.org>
	<146907700604.25461.2181974283557088355.stgit@birch.djwong.org>
	<20160801063902.GI15590@infradead.org>
	<20160801173331.GC8590@birch.djwong.org>
	<20160802122325.GA11128@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160802122325.GA11128@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, vishal.l.verma@intel.com, bfoster@redhat.com, xfs@oss.sgi.com

On Tue, Aug 02, 2016 at 05:23:25AM -0700, Christoph Hellwig wrote:
> On Mon, Aug 01, 2016 at 10:33:31AM -0700, Darrick J. Wong wrote:
> > That's roughly the approach I took in previous versions of this patch,
> > but using the OVERLAPPING flag to dispatch the overlapped vs. non-
> > versions of the get*keys and updkey* functions confused Dave, so he
> > asked me to add to function pointers[1] to the btree ops and dispatch
> > that way.
> 
> I remember I had a similar disagreement with Dave on the long vs
> short pointers when doing the initial common btree work, and
> I prevailed using the flag :)
> 
> Below is a patch to on top of your for-dave-for-4.8-2 branch
> which uses the flag, but also keeps your useful refactoring.
> 
> This both reduces source:
> 
>  6 files changed, 61 insertions(+), 136 deletions(-)
> 
> as well as binary:
> 
> hch@brick:~/work/xfs$ size xfs.o-*
>    text	   data	    bss	    dec	    hex	filename
>  911881	 160951	   1568	1074400	 1064e0	xfs.o-flag
>  912457	 160951	   1568	1074976	 106720	xfs.o-pointer
> 
> sizes and makes the whole thing much easier to follow and understand.

Ok, sounds good.  Disentangling this was actually simpler than I thought it
would be, so I tossed it on the branch I'm (imminently) sending to Dave.
I reworked some of the comments to reflect the newer approach.

We ought to collect a S-o-B from you too.

--D

> 
> diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
> index c60eeb8..5ba2dac 100644
> --- a/fs/xfs/libxfs/xfs_alloc_btree.c
> +++ b/fs/xfs/libxfs/xfs_alloc_btree.c
> @@ -403,10 +403,6 @@ static const struct xfs_btree_ops xfs_allocbt_ops = {
>  	.keys_inorder		= xfs_allocbt_keys_inorder,
>  	.recs_inorder		= xfs_allocbt_recs_inorder,
>  #endif
> -
> -	.get_leaf_keys		= xfs_btree_get_leaf_keys,
> -	.get_node_keys		= xfs_btree_get_node_keys,
> -	.update_keys		= xfs_btree_update_keys,
>  };
>  
>  /*
> diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
> index 9e34ca4..cd85274 100644
> --- a/fs/xfs/libxfs/xfs_bmap_btree.c
> +++ b/fs/xfs/libxfs/xfs_bmap_btree.c
> @@ -763,10 +763,6 @@ static const struct xfs_btree_ops xfs_bmbt_ops = {
>  	.keys_inorder		= xfs_bmbt_keys_inorder,
>  	.recs_inorder		= xfs_bmbt_recs_inorder,
>  #endif
> -
> -	.get_leaf_keys		= xfs_btree_get_leaf_keys,
> -	.get_node_keys		= xfs_btree_get_node_keys,
> -	.update_keys		= xfs_btree_update_keys,
>  };
>  
>  /*
> diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
> index fe5f27e..45a9545b 100644
> --- a/fs/xfs/libxfs/xfs_btree.c
> +++ b/fs/xfs/libxfs/xfs_btree.c
> @@ -1951,29 +1951,6 @@ error0:
>  	return error;
>  }
>  
> -/* Determine the low key of a leaf block (simple) */
> -void
> -xfs_btree_get_leaf_keys(
> -	struct xfs_btree_cur	*cur,
> -	struct xfs_btree_block	*block,
> -	union xfs_btree_key	*key)
> -{
> -	union xfs_btree_rec	*rec;
> -
> -	rec = xfs_btree_rec_addr(cur, 1, block);
> -	cur->bc_ops->init_key_from_rec(key, rec);
> -}
> -
> -/* Determine the low key of a node block (simple) */
> -void
> -xfs_btree_get_node_keys(
> -	struct xfs_btree_cur	*cur,
> -	struct xfs_btree_block	*block,
> -	union xfs_btree_key	*key)
> -{
> -	memcpy(key, xfs_btree_key_addr(cur, 1, block), cur->bc_ops->key_len);
> -}
> -
>  /* Find the high key storage area from a regular key. */
>  STATIC union xfs_btree_key *
>  xfs_btree_high_key_from_key(
> @@ -1985,38 +1962,41 @@ xfs_btree_high_key_from_key(
>  			(cur->bc_ops->key_len / 2));
>  }
>  
> -/* Determine the low and high keys of a leaf block (overlapped) */
> -void
> -xfs_btree_get_leaf_keys_overlapped(
> +/* Determine the low (and high if overlapped) key of a leaf block */
> +STATIC void
> +xfs_btree_get_leaf_keys(
>  	struct xfs_btree_cur	*cur,
>  	struct xfs_btree_block	*block,
>  	union xfs_btree_key	*key)
>  {
> -	int			n;
>  	union xfs_btree_rec	*rec;
> -	union xfs_btree_key	max_hkey;
> -	union xfs_btree_key	hkey;
> -	union xfs_btree_key	*high;
>  
> -	ASSERT(cur->bc_flags & XFS_BTREE_OVERLAPPING);
>  	rec = xfs_btree_rec_addr(cur, 1, block);
>  	cur->bc_ops->init_key_from_rec(key, rec);
>  
> -	cur->bc_ops->init_high_key_from_rec(&max_hkey, rec);
> -	for (n = 2; n <= xfs_btree_get_numrecs(block); n++) {
> -		rec = xfs_btree_rec_addr(cur, n, block);
> -		cur->bc_ops->init_high_key_from_rec(&hkey, rec);
> -		if (cur->bc_ops->diff_two_keys(cur, &hkey, &max_hkey) > 0)
> -			max_hkey = hkey;
> -	}
> +	if (cur->bc_flags & XFS_BTREE_OVERLAPPING) {
> +		union xfs_btree_key	max_hkey;
> +		union xfs_btree_key	hkey;
> +		union xfs_btree_key	*high;
> +		int			n;
> +
> +		cur->bc_ops->init_high_key_from_rec(&max_hkey, rec);
> +		for (n = 2; n <= xfs_btree_get_numrecs(block); n++) {
> +			rec = xfs_btree_rec_addr(cur, n, block);
> +			cur->bc_ops->init_high_key_from_rec(&hkey, rec);
> +			if (cur->bc_ops->diff_two_keys(cur, &hkey, &max_hkey)
> +					> 0)
> +				max_hkey = hkey;
> +		}
>  
> -	high = xfs_btree_high_key_from_key(cur, key);
> -	memcpy(high, &max_hkey, cur->bc_ops->key_len / 2);
> +		high = xfs_btree_high_key_from_key(cur, key);
> +		memcpy(high, &max_hkey, cur->bc_ops->key_len / 2);
> +	}
>  }
>  
>  /* Determine the low and high keys of a node block (overlapped) */
> -void
> -xfs_btree_get_node_keys_overlapped(
> +STATIC void
> +xfs_btree_get_node_keys(
>  	struct xfs_btree_cur	*cur,
>  	struct xfs_btree_block	*block,
>  	union xfs_btree_key	*key)
> @@ -2026,19 +2006,23 @@ xfs_btree_get_node_keys_overlapped(
>  	union xfs_btree_key	*max_hkey;
>  	union xfs_btree_key	*high;
>  
> -	ASSERT(cur->bc_flags & XFS_BTREE_OVERLAPPING);
> -	memcpy(key, xfs_btree_key_addr(cur, 1, block),
> -			cur->bc_ops->key_len / 2);
> -
> -	max_hkey = xfs_btree_high_key_addr(cur, 1, block);
> -	for (n = 2; n <= xfs_btree_get_numrecs(block); n++) {
> -		hkey = xfs_btree_high_key_addr(cur, n, block);
> -		if (cur->bc_ops->diff_two_keys(cur, hkey, max_hkey) > 0)
> -			max_hkey = hkey;
> -	}
> +	if (cur->bc_flags & XFS_BTREE_OVERLAPPING) {
> +		memcpy(key, xfs_btree_key_addr(cur, 1, block),
> +				cur->bc_ops->key_len / 2);
> +
> +		max_hkey = xfs_btree_high_key_addr(cur, 1, block);
> +		for (n = 2; n <= xfs_btree_get_numrecs(block); n++) {
> +			hkey = xfs_btree_high_key_addr(cur, n, block);
> +			if (cur->bc_ops->diff_two_keys(cur, hkey, max_hkey) > 0)
> +				max_hkey = hkey;
> +		}
>  
> -	high = xfs_btree_high_key_from_key(cur, key);
> -	memcpy(high, max_hkey, cur->bc_ops->key_len / 2);
> +		high = xfs_btree_high_key_from_key(cur, key);
> +		memcpy(high, max_hkey, cur->bc_ops->key_len / 2);
> +	} else {
> +		memcpy(key, xfs_btree_key_addr(cur, 1, block),
> +				cur->bc_ops->key_len);
> +	}
>  }
>  
>  /* Derive the keys for any btree block. */
> @@ -2049,9 +2033,9 @@ xfs_btree_get_keys(
>  	union xfs_btree_key	*key)
>  {
>  	if (be16_to_cpu(block->bb_level) == 0)
> -		cur->bc_ops->get_leaf_keys(cur, block, key);
> +		xfs_btree_get_leaf_keys(cur, block, key);
>  	else
> -		cur->bc_ops->get_node_keys(cur, block, key);
> +		xfs_btree_get_node_keys(cur, block, key);
>  }
>  
>  /*
> @@ -2125,28 +2109,12 @@ __xfs_btree_updkeys(
>  		xfs_btree_log_keys(cur, bp, ptr, ptr);
>  		if (level + 1 >= cur->bc_nlevels)
>  			break;
> -		cur->bc_ops->get_node_keys(cur, block, lkey);
> +		xfs_btree_get_node_keys(cur, block, lkey);
>  	}
>  
>  	return 0;
>  }
>  
> -/*
> - * Update all the keys from some level in cursor back to the root, stopping
> - * when we find a key pair that don't need updating.
> - */
> -int
> -xfs_btree_update_keys_overlapped(
> -	struct xfs_btree_cur	*cur,
> -	int			level)
> -{
> -	struct xfs_buf		*bp;
> -	struct xfs_btree_block	*block;
> -
> -	block = xfs_btree_get_block(cur, level, &bp);
> -	return __xfs_btree_updkeys(cur, level, block, bp, false);
> -}
> -
>  /* Update all the keys from some level in cursor back to the root. */
>  STATIC int
>  xfs_btree_updkeys_force(
> @@ -2163,7 +2131,7 @@ xfs_btree_updkeys_force(
>  /*
>   * Update the parent keys of the given level, progressing towards the root.
>   */
> -int
> +STATIC int
>  xfs_btree_update_keys(
>  	struct xfs_btree_cur	*cur,
>  	int			level)
> @@ -2174,20 +2142,21 @@ xfs_btree_update_keys(
>  	union xfs_btree_key	key;
>  	int			ptr;
>  
> -	ASSERT(!(cur->bc_flags & XFS_BTREE_OVERLAPPING));
> +	ASSERT(level >= 0);
> +
> +	block = xfs_btree_get_block(cur, level, &bp);
> +	if (cur->bc_flags & XFS_BTREE_OVERLAPPING)
> +		return __xfs_btree_updkeys(cur, level, block, bp, false);
>  
>  	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
>  	XFS_BTREE_TRACE_ARGIK(cur, level, keyp);
>  
> -	ASSERT(level >= 0);
> -
>  	/*
>  	 * Go up the tree from this level toward the root.
>  	 * At each level, update the key value to the value input.
>  	 * Stop when we reach a level where the cursor isn't pointing
>  	 * at the first entry in the block.
>  	 */
> -	block = xfs_btree_get_block(cur, level, &bp);
>  	xfs_btree_get_keys(cur, block, &key);
>  	for (level++, ptr = 1; ptr == 1 && level < cur->bc_nlevels; level++) {
>  #ifdef DEBUG
> @@ -2257,7 +2226,7 @@ xfs_btree_update(
>  
>  	/* Pass new key value up to our parent. */
>  	if (xfs_btree_needs_key_update(cur, ptr)) {
> -		error = cur->bc_ops->update_keys(cur, 0);
> +		error = xfs_btree_update_keys(cur, 0);
>  		if (error)
>  			goto error0;
>  	}
> @@ -2447,13 +2416,13 @@ xfs_btree_lshift(
>  		goto error1;
>  
>  	/* Update the parent keys of the right block. */
> -	error = cur->bc_ops->update_keys(cur, level);
> +	error = xfs_btree_update_keys(cur, level);
>  	if (error)
>  		goto error1;
>  
>  	/* Update the parent high keys of the left block, if needed. */
>  	if (tcur->bc_flags & XFS_BTREE_OVERLAPPING) {
> -		error = tcur->bc_ops->update_keys(tcur, level);
> +		error = xfs_btree_update_keys(tcur, level);
>  		if (error)
>  			goto error1;
>  	}
> @@ -2633,13 +2602,13 @@ xfs_btree_rshift(
>  
>  	/* Update the parent high keys of the left block, if needed. */
>  	if (cur->bc_flags & XFS_BTREE_OVERLAPPING) {
> -		error = cur->bc_ops->update_keys(cur, level);
> +		error = xfs_btree_update_keys(cur, level);
>  		if (error)
>  			goto error1;
>  	}
>  
>  	/* Update the parent keys of the right block. */
> -	error = cur->bc_ops->update_keys(tcur, level);
> +	error = xfs_btree_update_keys(tcur, level);
>  	if (error)
>  		goto error1;
>  
> @@ -2778,7 +2747,7 @@ __xfs_btree_split(
>  		xfs_btree_log_ptrs(cur, rbp, 1, rrecs);
>  
>  		/* Stash the keys of the new block for later insertion. */
> -		cur->bc_ops->get_node_keys(cur, right, key);
> +		xfs_btree_get_node_keys(cur, right, key);
>  	} else {
>  		/* It's a leaf.  Move records.  */
>  		union xfs_btree_rec	*lrp;	/* left record pointer */
> @@ -2792,7 +2761,7 @@ __xfs_btree_split(
>  		xfs_btree_log_recs(cur, rbp, 1, rrecs);
>  
>  		/* Stash the keys of the new block for later insertion. */
> -		cur->bc_ops->get_leaf_keys(cur, right, key);
> +		xfs_btree_get_leaf_keys(cur, right, key);
>  	}
>  
>  	/*
> @@ -2822,7 +2791,7 @@ __xfs_btree_split(
>  
>  	/* Update the parent high keys of the left block, if needed. */
>  	if (cur->bc_flags & XFS_BTREE_OVERLAPPING) {
> -		error = cur->bc_ops->update_keys(cur, level);
> +		error = xfs_btree_update_keys(cur, level);
>  		if (error)
>  			goto error0;
>  	}
> @@ -3143,9 +3112,9 @@ xfs_btree_new_root(
>  		 * Get the keys for the left block's keys and put them directly
>  		 * in the parent block.  Do the same for the right block.
>  		 */
> -		cur->bc_ops->get_node_keys(cur, left,
> +		xfs_btree_get_node_keys(cur, left,
>  				xfs_btree_key_addr(cur, 1, new));
> -		cur->bc_ops->get_node_keys(cur, right,
> +		xfs_btree_get_node_keys(cur, right,
>  				xfs_btree_key_addr(cur, 2, new));
>  	} else {
>  		/*
> @@ -3153,9 +3122,9 @@ xfs_btree_new_root(
>  		 * directly in the parent block.  Do the same for the right
>  		 * block.
>  		 */
> -		cur->bc_ops->get_leaf_keys(cur, left,
> +		xfs_btree_get_leaf_keys(cur, left,
>  			xfs_btree_key_addr(cur, 1, new));
> -		cur->bc_ops->get_leaf_keys(cur, right,
> +		xfs_btree_get_leaf_keys(cur, right,
>  			xfs_btree_key_addr(cur, 2, new));
>  	}
>  	xfs_btree_log_keys(cur, nbp, 1, 2);
> @@ -3434,7 +3403,7 @@ xfs_btree_insrec(
>  	if (bp && bp->b_bn != old_bn) {
>  		xfs_btree_get_keys(cur, block, lkey);
>  	} else if (xfs_btree_needs_key_update(cur, optr)) {
> -		error = cur->bc_ops->update_keys(cur, level);
> +		error = xfs_btree_update_keys(cur, level);
>  		if (error)
>  			goto error0;
>  	}
> @@ -3880,7 +3849,7 @@ xfs_btree_delrec(
>  	 * key values above us in the tree.
>  	 */
>  	if (xfs_btree_needs_key_update(cur, ptr)) {
> -		error = cur->bc_ops->update_keys(cur, level);
> +		error = xfs_btree_update_keys(cur, level);
>  		if (error)
>  			goto error0;
>  	}
> diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
> index 9b6d628..04d0865 100644
> --- a/fs/xfs/libxfs/xfs_btree.h
> +++ b/fs/xfs/libxfs/xfs_btree.h
> @@ -214,19 +214,6 @@ struct xfs_btree_ops {
>  				union xfs_btree_rec *r1,
>  				union xfs_btree_rec *r2);
>  #endif
> -
> -	/* derive the low & high keys from the records in a leaf block */
> -	void	(*get_leaf_keys)(struct xfs_btree_cur *cur,
> -				 struct xfs_btree_block *block,
> -				 union xfs_btree_key *key);
> -
> -	/* derive the low & high keys from the keys in a node block */
> -	void	(*get_node_keys)(struct xfs_btree_cur *cur,
> -				 struct xfs_btree_block *block,
> -				 union xfs_btree_key *key);
> -
> -	/* update the parent keys of given btree level */
> -	int	(*update_keys)(struct xfs_btree_cur *cur, int level);
>  };
>  
>  /*
> @@ -527,17 +514,6 @@ bool xfs_btree_sblock_verify(struct xfs_buf *bp, unsigned int max_recs);
>  uint xfs_btree_compute_maxlevels(struct xfs_mount *mp, uint *limits,
>  				 unsigned long len);
>  
> -void xfs_btree_get_leaf_keys(struct xfs_btree_cur *cur,
> -		struct xfs_btree_block *block, union xfs_btree_key *key);
> -void xfs_btree_get_node_keys(struct xfs_btree_cur *cur,
> -		struct xfs_btree_block *block, union xfs_btree_key *key);
> -int xfs_btree_update_keys(struct xfs_btree_cur *cur, int level);
> -void xfs_btree_get_leaf_keys_overlapped(struct xfs_btree_cur *cur,
> -		struct xfs_btree_block *block, union xfs_btree_key *key);
> -void xfs_btree_get_node_keys_overlapped(struct xfs_btree_cur *cur,
> -		struct xfs_btree_block *block, union xfs_btree_key *key);
> -int xfs_btree_update_keys_overlapped(struct xfs_btree_cur *cur, int level);
> -
>  /* return codes */
>  #define XFS_BTREE_QUERY_RANGE_CONTINUE	0	/* keep iterating */
>  #define XFS_BTREE_QUERY_RANGE_ABORT	1	/* stop iterating */
> diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
> index c83691e..31ca220 100644
> --- a/fs/xfs/libxfs/xfs_ialloc_btree.c
> +++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
> @@ -320,10 +320,6 @@ static const struct xfs_btree_ops xfs_inobt_ops = {
>  	.keys_inorder		= xfs_inobt_keys_inorder,
>  	.recs_inorder		= xfs_inobt_recs_inorder,
>  #endif
> -
> -	.get_leaf_keys		= xfs_btree_get_leaf_keys,
> -	.get_node_keys		= xfs_btree_get_node_keys,
> -	.update_keys		= xfs_btree_update_keys,
>  };
>  
>  static const struct xfs_btree_ops xfs_finobt_ops = {
> @@ -345,10 +341,6 @@ static const struct xfs_btree_ops xfs_finobt_ops = {
>  	.keys_inorder		= xfs_inobt_keys_inorder,
>  	.recs_inorder		= xfs_inobt_recs_inorder,
>  #endif
> -
> -	.get_leaf_keys		= xfs_btree_get_leaf_keys,
> -	.get_node_keys		= xfs_btree_get_node_keys,
> -	.update_keys		= xfs_btree_update_keys,
>  };
>  
>  /*
> diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
> index 232450c..bc1faeb 100644
> --- a/fs/xfs/libxfs/xfs_rmap_btree.c
> +++ b/fs/xfs/libxfs/xfs_rmap_btree.c
> @@ -453,10 +453,6 @@ static const struct xfs_btree_ops xfs_rmapbt_ops = {
>  	.keys_inorder		= xfs_rmapbt_keys_inorder,
>  	.recs_inorder		= xfs_rmapbt_recs_inorder,
>  #endif
> -
> -	.get_leaf_keys		= xfs_btree_get_leaf_keys_overlapped,
> -	.get_node_keys		= xfs_btree_get_node_keys_overlapped,
> -	.update_keys		= xfs_btree_update_keys_overlapped,
>  };
>  
>  /*

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
