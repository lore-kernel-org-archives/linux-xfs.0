Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20C361847
	for <linux-xfs@vger.kernel.org>; Thu,  4 Jan 2024 01:14:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BPf2Bi+4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94855C433C7;
	Thu,  4 Jan 2024 01:14:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704330840;
	bh=TvNLV12hFpU76X1xlzZ94IUg8ySmdwahiEHzqpovomM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BPf2Bi+4yblbnfd+k2fxWDxE1ULSz7KJIwHUlduThWNqDWQtpKK76owC095Nk7PCJ
	 NUG+QdiFE43ZG5luwmQU72p38m3iFYeNQ4A1bwu/dxlInY5857uXBafsJjqP9DTDVv
	 AWD4U8rJjTzSxRrn75xuAGdX9DBJ+9AgND367GEwp+FUAiaGcI3KcvI9zOJimaC00Y
	 M7ryLGGRNLBIZuhROxzAwURqnIvTY5C2DV2S1AADyBT3SdoXncO6AY1+kGd7zIWpFP
	 UeBmxVEgXoWAncFIxLnHGWvacnlyRVABQvE5h6/lIf2rMO5WYnR89h5FWB/1LO/74E
	 Y5+2tDAGFkpGQ==
Date: Wed, 3 Jan 2024 17:14:00 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/5] xfs: factor out a xfs_btree_owner helper
Message-ID: <20240104011400.GL361584@frogsfrogsfrogs>
References: <20240103203836.608391-1-hch@lst.de>
 <20240103203836.608391-5-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240103203836.608391-5-hch@lst.de>

On Wed, Jan 03, 2024 at 09:38:35PM +0100, Christoph Hellwig wrote:
> Split out a helper to calculate the owner for a given btree instead
> of dulicating the logic in two places.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_btree.c     | 52 +++++++++++++++--------------------
>  fs/xfs/libxfs/xfs_btree_mem.h |  5 ----
>  fs/xfs/scrub/xfbtree.c        | 29 -------------------
>  3 files changed, 22 insertions(+), 64 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
> index 3bc8aa6049b9a7..bd51c428f66780 100644
> --- a/fs/xfs/libxfs/xfs_btree.c
> +++ b/fs/xfs/libxfs/xfs_btree.c
> @@ -1298,6 +1298,19 @@ xfs_btree_init_buf(
>  	bp->b_ops = ops->buf_ops;
>  }
>  
> +static uint64_t
> +xfs_btree_owner(
> +	struct xfs_btree_cur	*cur)
> +{
> +#ifdef CONFIG_XFS_BTREE_IN_XFILE
> +	if (cur->bc_flags & XFS_BTREE_IN_XFILE)
> +		return cur->bc_mem.xfbtree->owner;
> +#endif

Hrm.  I guess I never /did/ use xfbtree_owner except for this one file.

> +	if (cur->bc_flags & XFS_BTREE_LONG_PTRS)
> +		return cur->bc_ino.ip->i_ino;
> +	return cur->bc_ag.pag->pag_agno;
> +}
> +
>  void
>  xfs_btree_init_block_cur(
>  	struct xfs_btree_cur	*cur,
> @@ -1305,22 +1318,8 @@ xfs_btree_init_block_cur(
>  	int			level,
>  	int			numrecs)
>  {
> -	__u64			owner;
> -
> -	/*
> -	 * we can pull the owner from the cursor right now as the different
> -	 * owners align directly with the pointer size of the btree. This may
> -	 * change in future, but is safe for current users of the generic btree
> -	 * code.
> -	 */
> -	if (cur->bc_flags & XFS_BTREE_IN_XFILE)
> -		owner = xfbtree_owner(cur);
> -	else if (cur->bc_flags & XFS_BTREE_LONG_PTRS)
> -		owner = cur->bc_ino.ip->i_ino;
> -	else
> -		owner = cur->bc_ag.pag->pag_agno;
> -
> -	xfs_btree_init_buf(cur->bc_mp, bp, cur->bc_ops, level, numrecs, owner);
> +	xfs_btree_init_buf(cur->bc_mp, bp, cur->bc_ops, level, numrecs,
> +			xfs_btree_owner(cur));
>  }
>  
>  /*
> @@ -1875,25 +1874,18 @@ xfs_btree_check_block_owner(
>  	struct xfs_btree_cur	*cur,
>  	struct xfs_btree_block	*block)
>  {
> -	if (!xfs_has_crc(cur->bc_mp))
> +	if (!xfs_has_crc(cur->bc_mp) ||

I wonder, shouldn't this be (bc_flags & XFS_BTREE_CRC_BLOCKS) and not
xfs_has_crc?  They're one and the same, but as the geometry flags are
all getting moved to xfs_btree_ops, we ought to be consistent about what
we check.

--D

> +	    (cur->bc_flags & XFS_BTREE_BMBT_INVALID_OWNER))
>  		return NULL;
>  
> -	if (cur->bc_flags & XFS_BTREE_IN_XFILE)
> -		return xfbtree_check_block_owner(cur, block);
> -
> -	if (!(cur->bc_flags & XFS_BTREE_LONG_PTRS)) {
> -		if (be32_to_cpu(block->bb_u.s.bb_owner) !=
> -						cur->bc_ag.pag->pag_agno)
> +	if (cur->bc_flags & XFS_BTREE_LONG_PTRS) {
> +		if (be64_to_cpu(block->bb_u.l.bb_owner) != xfs_btree_owner(cur))
> +			return __this_address;
> +	} else {
> +		if (be32_to_cpu(block->bb_u.s.bb_owner) != xfs_btree_owner(cur))
>  			return __this_address;
> -		return NULL;
>  	}
>  
> -	if (cur->bc_flags & XFS_BTREE_BMBT_INVALID_OWNER)
> -		return NULL;
> -
> -	if (be64_to_cpu(block->bb_u.l.bb_owner) != cur->bc_ino.ip->i_ino)
> -		return __this_address;
> -
>  	return NULL;
>  }
>  
> diff --git a/fs/xfs/libxfs/xfs_btree_mem.h b/fs/xfs/libxfs/xfs_btree_mem.h
> index eeb3340a22d201..3a5492c2cc26b6 100644
> --- a/fs/xfs/libxfs/xfs_btree_mem.h
> +++ b/fs/xfs/libxfs/xfs_btree_mem.h
> @@ -43,9 +43,6 @@ void xfbtree_init_ptr_from_cur(struct xfs_btree_cur *cur,
>  struct xfs_btree_cur *xfbtree_dup_cursor(struct xfs_btree_cur *cur);
>  bool xfbtree_verify_xfileoff(struct xfs_btree_cur *cur,
>  		unsigned long long xfoff);
> -xfs_failaddr_t xfbtree_check_block_owner(struct xfs_btree_cur *cur,
> -		struct xfs_btree_block *block);
> -unsigned long long xfbtree_owner(struct xfs_btree_cur *cur);
>  xfs_failaddr_t xfbtree_lblock_verify(struct xfs_buf *bp, unsigned int max_recs);
>  xfs_failaddr_t xfbtree_sblock_verify(struct xfs_buf *bp, unsigned int max_recs);
>  unsigned long long xfbtree_buf_to_xfoff(struct xfs_btree_cur *cur,
> @@ -102,8 +99,6 @@ static inline unsigned int xfbtree_bbsize(void)
>  #define xfbtree_alloc_block			NULL
>  #define xfbtree_free_block			NULL
>  #define xfbtree_verify_xfileoff(cur, xfoff)	(false)
> -#define xfbtree_check_block_owner(cur, block)	NULL
> -#define xfbtree_owner(cur)			(0ULL)
>  #define xfbtree_buf_to_xfoff(cur, bp)		(-1)
>  
>  static inline int
> diff --git a/fs/xfs/scrub/xfbtree.c b/fs/xfs/scrub/xfbtree.c
> index 63b69aeadc623d..11dad651508067 100644
> --- a/fs/xfs/scrub/xfbtree.c
> +++ b/fs/xfs/scrub/xfbtree.c
> @@ -165,35 +165,6 @@ xfbtree_dup_cursor(
>  	return ncur;
>  }
>  
> -/* Check the owner of an in-memory btree block. */
> -xfs_failaddr_t
> -xfbtree_check_block_owner(
> -	struct xfs_btree_cur	*cur,
> -	struct xfs_btree_block	*block)
> -{
> -	struct xfbtree		*xfbt = cur->bc_mem.xfbtree;
> -
> -	if (cur->bc_flags & XFS_BTREE_LONG_PTRS) {
> -		if (be64_to_cpu(block->bb_u.l.bb_owner) != xfbt->owner)
> -			return __this_address;
> -
> -		return NULL;
> -	}
> -
> -	if (be32_to_cpu(block->bb_u.s.bb_owner) != xfbt->owner)
> -		return __this_address;
> -
> -	return NULL;
> -}
> -
> -/* Return the owner of this in-memory btree. */
> -unsigned long long
> -xfbtree_owner(
> -	struct xfs_btree_cur	*cur)
> -{
> -	return cur->bc_mem.xfbtree->owner;
> -}
> -
>  /* Return the xfile offset (in blocks) of a btree buffer. */
>  unsigned long long
>  xfbtree_buf_to_xfoff(
> -- 
> 2.39.2
> 
> 
