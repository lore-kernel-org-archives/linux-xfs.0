Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4FC407CA1
	for <xfs@oss.sgi.com>; Thu, 23 Jun 2016 12:20:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0FC628F8033
	for <xfs@oss.sgi.com>; Thu, 23 Jun 2016 10:20:16 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id dQCbYPYCjgz2zkQB (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 23 Jun 2016 10:19:50 -0700 (PDT)
Date: Thu, 23 Jun 2016 13:19:48 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 015/119] xfs: refactor btree owner change into a separate
	visit-blocks function
Message-ID: <20160623171947.GA40109@bfoster.bfoster>
References: <146612627129.12839.3827886950949809165.stgit@birch.djwong.org>
	<146612636805.12839.15108503251791000478.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <146612636805.12839.15108503251791000478.stgit@birch.djwong.org>
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

On Thu, Jun 16, 2016 at 06:19:28PM -0700, Darrick J. Wong wrote:
> Refactor the btree_change_owner function into a more generic apparatus
> which visits all blocks in a btree.  We'll use this in a subsequent
> patch for counting btree blocks for AG reservations.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_btree.c |  141 +++++++++++++++++++++++++++++----------------
>  fs/xfs/libxfs/xfs_btree.h |    5 ++
>  2 files changed, 96 insertions(+), 50 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
> index 5f5cf23..eac876a 100644
> --- a/fs/xfs/libxfs/xfs_btree.c
> +++ b/fs/xfs/libxfs/xfs_btree.c
> @@ -4289,6 +4289,81 @@ xfs_btree_get_rec(
>  	return 0;
>  }
>  
> +/* Visit a block in a btree. */
> +STATIC int
> +xfs_btree_visit_block(
> +	struct xfs_btree_cur		*cur,
> +	int				level,
> +	xfs_btree_visit_blocks_fn	fn,
> +	void				*data)
> +{
> +	struct xfs_btree_block		*block;
> +	struct xfs_buf			*bp;
> +	union xfs_btree_ptr		rptr;
> +	int				error;
> +
> +	/* do right sibling readahead */
> +	xfs_btree_readahead(cur, level, XFS_BTCUR_RIGHTRA);
> +	block = xfs_btree_get_block(cur, level, &bp);
> +
> +	/* process the block */
> +	error = fn(cur, level, data);
> +	if (error)
> +		return error;
> +
> +	/* now read rh sibling block for next iteration */
> +	xfs_btree_get_sibling(cur, block, &rptr, XFS_BB_RIGHTSIB);
> +	if (xfs_btree_ptr_is_null(cur, &rptr))
> +		return -ENOENT;
> +
> +	return xfs_btree_lookup_get_block(cur, level, &rptr, &block);
> +}
> +
> +
> +/* Visit every block in a btree. */
> +int
> +xfs_btree_visit_blocks(
> +	struct xfs_btree_cur		*cur,
> +	xfs_btree_visit_blocks_fn	fn,
> +	void				*data)
> +{
> +	union xfs_btree_ptr		lptr;
> +	int				level;
> +	struct xfs_btree_block		*block = NULL;
> +	int				error = 0;
> +
> +	cur->bc_ops->init_ptr_from_cur(cur, &lptr);
> +
> +	/* for each level */
> +	for (level = cur->bc_nlevels - 1; level >= 0; level--) {
> +		/* grab the left hand block */
> +		error = xfs_btree_lookup_get_block(cur, level, &lptr, &block);
> +		if (error)
> +			return error;
> +
> +		/* readahead the left most block for the next level down */
> +		if (level > 0) {
> +			union xfs_btree_ptr     *ptr;
> +
> +			ptr = xfs_btree_ptr_addr(cur, 1, block);
> +			xfs_btree_readahead_ptr(cur, ptr, 1);
> +
> +			/* save for the next iteration of the loop */
> +			lptr = *ptr;
> +		}
> +
> +		/* for each buffer in the level */
> +		do {
> +			error = xfs_btree_visit_block(cur, level, fn, data);
> +		} while (!error);
> +
> +		if (error != -ENOENT)
> +			return error;
> +	}
> +
> +	return 0;
> +}
> +
>  /*
>   * Change the owner of a btree.
>   *
> @@ -4313,26 +4388,27 @@ xfs_btree_get_rec(
>   * just queue the modified buffer as delayed write buffer so the transaction
>   * recovery completion writes the changes to disk.
>   */
> +struct xfs_btree_block_change_owner_info {
> +	__uint64_t		new_owner;
> +	struct list_head	*buffer_list;
> +};
> +
>  static int
>  xfs_btree_block_change_owner(
>  	struct xfs_btree_cur	*cur,
>  	int			level,
> -	__uint64_t		new_owner,
> -	struct list_head	*buffer_list)
> +	void			*data)
>  {
> +	struct xfs_btree_block_change_owner_info	*bbcoi = data;
>  	struct xfs_btree_block	*block;
>  	struct xfs_buf		*bp;
> -	union xfs_btree_ptr     rptr;
> -
> -	/* do right sibling readahead */
> -	xfs_btree_readahead(cur, level, XFS_BTCUR_RIGHTRA);
>  
>  	/* modify the owner */
>  	block = xfs_btree_get_block(cur, level, &bp);
>  	if (cur->bc_flags & XFS_BTREE_LONG_PTRS)
> -		block->bb_u.l.bb_owner = cpu_to_be64(new_owner);
> +		block->bb_u.l.bb_owner = cpu_to_be64(bbcoi->new_owner);
>  	else
> -		block->bb_u.s.bb_owner = cpu_to_be32(new_owner);
> +		block->bb_u.s.bb_owner = cpu_to_be32(bbcoi->new_owner);
>  
>  	/*
>  	 * If the block is a root block hosted in an inode, we might not have a
> @@ -4346,19 +4422,14 @@ xfs_btree_block_change_owner(
>  			xfs_trans_ordered_buf(cur->bc_tp, bp);
>  			xfs_btree_log_block(cur, bp, XFS_BB_OWNER);
>  		} else {
> -			xfs_buf_delwri_queue(bp, buffer_list);
> +			xfs_buf_delwri_queue(bp, bbcoi->buffer_list);
>  		}
>  	} else {
>  		ASSERT(cur->bc_flags & XFS_BTREE_ROOT_IN_INODE);
>  		ASSERT(level == cur->bc_nlevels - 1);
>  	}
>  
> -	/* now read rh sibling block for next iteration */
> -	xfs_btree_get_sibling(cur, block, &rptr, XFS_BB_RIGHTSIB);
> -	if (xfs_btree_ptr_is_null(cur, &rptr))
> -		return -ENOENT;
> -
> -	return xfs_btree_lookup_get_block(cur, level, &rptr, &block);
> +	return 0;
>  }
>  
>  int
> @@ -4367,43 +4438,13 @@ xfs_btree_change_owner(
>  	__uint64_t		new_owner,
>  	struct list_head	*buffer_list)
>  {
> -	union xfs_btree_ptr     lptr;
> -	int			level;
> -	struct xfs_btree_block	*block = NULL;
> -	int			error = 0;
> +	struct xfs_btree_block_change_owner_info	bbcoi;
>  
> -	cur->bc_ops->init_ptr_from_cur(cur, &lptr);
> +	bbcoi.new_owner = new_owner;
> +	bbcoi.buffer_list = buffer_list;
>  
> -	/* for each level */
> -	for (level = cur->bc_nlevels - 1; level >= 0; level--) {
> -		/* grab the left hand block */
> -		error = xfs_btree_lookup_get_block(cur, level, &lptr, &block);
> -		if (error)
> -			return error;
> -
> -		/* readahead the left most block for the next level down */
> -		if (level > 0) {
> -			union xfs_btree_ptr     *ptr;
> -
> -			ptr = xfs_btree_ptr_addr(cur, 1, block);
> -			xfs_btree_readahead_ptr(cur, ptr, 1);
> -
> -			/* save for the next iteration of the loop */
> -			lptr = *ptr;
> -		}
> -
> -		/* for each buffer in the level */
> -		do {
> -			error = xfs_btree_block_change_owner(cur, level,
> -							     new_owner,
> -							     buffer_list);
> -		} while (!error);
> -
> -		if (error != -ENOENT)
> -			return error;
> -	}
> -
> -	return 0;
> +	return xfs_btree_visit_blocks(cur, xfs_btree_block_change_owner,
> +			&bbcoi);
>  }
>  
>  /**
> diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
> index 898fee5..0ec3055 100644
> --- a/fs/xfs/libxfs/xfs_btree.h
> +++ b/fs/xfs/libxfs/xfs_btree.h
> @@ -506,4 +506,9 @@ int xfs_btree_query_range(struct xfs_btree_cur *cur,
>  		union xfs_btree_irec *low_rec, union xfs_btree_irec *high_rec,
>  		xfs_btree_query_range_fn fn, void *priv);
>  
> +typedef int (*xfs_btree_visit_blocks_fn)(struct xfs_btree_cur *cur, int level,
> +		void *data);
> +int xfs_btree_visit_blocks(struct xfs_btree_cur *cur,
> +		xfs_btree_visit_blocks_fn fn, void *data);
> +
>  #endif	/* __XFS_BTREE_H__ */
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
