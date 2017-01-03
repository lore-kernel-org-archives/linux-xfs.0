Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40904 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965519AbdACS23 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 3 Jan 2017 13:28:29 -0500
Date: Tue, 3 Jan 2017 13:28:28 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 3/3 V2] xfs: remove boilerplate around
 xfs_btree_init_block
Message-ID: <20170103182827.GD18120@bfoster.bfoster>
References: <670e1f09-754d-4171-0a73-f918956eba2d@redhat.com>
 <6dceebc0-6f81-ada3-f834-cbf4b34b91d9@sandeen.net>
 <ad59dbfb-0528-77a5-8ff6-eae5272db4bf@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ad59dbfb-0528-77a5-8ff6-eae5272db4bf@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Thu, Dec 22, 2016 at 01:44:50PM -0600, Eric Sandeen wrote:
> Now that xfs_btree_init_block_int is able to determine crc
> status from the passed-in mp, we can determine the proper
> magic as well if we are given a btree number, rather than
> an explicit magic value.
> 
> Change xfs_btree_init_block[_int] callers to pass in the
> btree number, and let xfs_btree_init_block_int use the
> xfs_magics array via the xfs_btree_magic macro to determine
> which magic value is needed.  This makes all of the
> if (crc) / else stanzas identical, and the if/else can be
> removed, leading to a single, common init_block call.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

> 
> V2: remove ASSERT after xfs_btree_magic now that it's built
> into that function
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index e645aa8..b30ff0a 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -724,15 +724,9 @@ static inline bool xfs_bmap_wants_extents(struct xfs_inode *ip, int whichfork)
>  	 * Fill in the root.
>  	 */
>  	block = ifp->if_broot;
> -	if (xfs_sb_version_hascrc(&mp->m_sb))
> -		xfs_btree_init_block_int(mp, block, XFS_BUF_DADDR_NULL,
> -				 XFS_BMAP_CRC_MAGIC, 1, 1, ip->i_ino,
> +	xfs_btree_init_block_int(mp, block, XFS_BUF_DADDR_NULL,
> +				 XFS_BTNUM_BMAP, 1, 1, ip->i_ino,
>  				 XFS_BTREE_LONG_PTRS);
> -	else
> -		xfs_btree_init_block_int(mp, block, XFS_BUF_DADDR_NULL,
> -				 XFS_BMAP_MAGIC, 1, 1, ip->i_ino,
> -				 XFS_BTREE_LONG_PTRS);
> -
>  	/*
>  	 * Need a cursor.  Can't allocate until bb_level is filled in.
>  	 */
> @@ -801,13 +795,8 @@ static inline bool xfs_bmap_wants_extents(struct xfs_inode *ip, int whichfork)
>  	 */
>  	abp->b_ops = &xfs_bmbt_buf_ops;
>  	ablock = XFS_BUF_TO_BLOCK(abp);
> -	if (xfs_sb_version_hascrc(&mp->m_sb))
> -		xfs_btree_init_block_int(mp, ablock, abp->b_bn,
> -				XFS_BMAP_CRC_MAGIC, 0, 0, ip->i_ino,
> -				XFS_BTREE_LONG_PTRS);
> -	else
> -		xfs_btree_init_block_int(mp, ablock, abp->b_bn,
> -				XFS_BMAP_MAGIC, 0, 0, ip->i_ino,
> +	xfs_btree_init_block_int(mp, ablock, abp->b_bn,
> +				XFS_BTNUM_BMAP, 0, 0, ip->i_ino,
>  				XFS_BTREE_LONG_PTRS);
>  
>  	arp = XFS_BMBT_REC_ADDR(mp, ablock, 1);
> diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
> index f0293d4..a8867a7 100644
> --- a/fs/xfs/libxfs/xfs_bmap_btree.c
> +++ b/fs/xfs/libxfs/xfs_bmap_btree.c
> @@ -71,15 +71,9 @@
>  	xfs_bmbt_key_t		*tkp;
>  	__be64			*tpp;
>  
> -	if (xfs_sb_version_hascrc(&mp->m_sb))
> -		xfs_btree_init_block_int(mp, rblock, XFS_BUF_DADDR_NULL,
> -				 XFS_BMAP_CRC_MAGIC, 0, 0, ip->i_ino,
> -				 XFS_BTREE_LONG_PTRS);
> -	else
> -		xfs_btree_init_block_int(mp, rblock, XFS_BUF_DADDR_NULL,
> -				 XFS_BMAP_MAGIC, 0, 0, ip->i_ino,
> +	xfs_btree_init_block_int(mp, rblock, XFS_BUF_DADDR_NULL,
> +				 XFS_BTNUM_BMAP, 0, 0, ip->i_ino,
>  				 XFS_BTREE_LONG_PTRS);
> -
>  	rblock->bb_level = dblock->bb_level;
>  	ASSERT(be16_to_cpu(rblock->bb_level) > 0);
>  	rblock->bb_numrecs = dblock->bb_numrecs;
> diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
> index 81866dd..0dcc5f2 100644
> --- a/fs/xfs/libxfs/xfs_btree.c
> +++ b/fs/xfs/libxfs/xfs_btree.c
> @@ -1097,13 +1097,14 @@ static inline size_t xfs_btree_ptr_len(struct xfs_btree_cur *cur)
>  	struct xfs_mount	*mp,
>  	struct xfs_btree_block	*buf,
>  	xfs_daddr_t		blkno,
> -	__u32			magic,
> +	xfs_btnum_t		btnum,
>  	__u16			level,
>  	__u16			numrecs,
>  	__u64			owner,
>  	unsigned int		flags)
>  {
>  	int			crc = xfs_sb_version_hascrc(&mp->m_sb);
> +	__u32			magic = xfs_btree_magic(crc, btnum);
>  
>  	buf->bb_magic = cpu_to_be32(magic);
>  	buf->bb_level = cpu_to_be16(level);
> @@ -1138,14 +1139,14 @@ static inline size_t xfs_btree_ptr_len(struct xfs_btree_cur *cur)
>  xfs_btree_init_block(
>  	struct xfs_mount *mp,
>  	struct xfs_buf	*bp,
> -	__u32		magic,
> +	xfs_btnum_t	btnum,
>  	__u16		level,
>  	__u16		numrecs,
>  	__u64		owner,
>  	unsigned int	flags)
>  {
>  	xfs_btree_init_block_int(mp, XFS_BUF_TO_BLOCK(bp), bp->b_bn,
> -				 magic, level, numrecs, owner, flags);
> +				 btnum, level, numrecs, owner, flags);
>  }
>  
>  STATIC void
> @@ -1156,8 +1157,6 @@ static inline size_t xfs_btree_ptr_len(struct xfs_btree_cur *cur)
>  	int			numrecs)
>  {
>  	__u64			owner;
> -	int			crc = xfs_sb_version_hascrc(&cur->bc_mp->m_sb);
> -	xfs_btnum_t		btnum = cur->bc_btnum;
>  
>  	/*
>  	 * we can pull the owner from the cursor right now as the different
> @@ -1171,7 +1170,7 @@ static inline size_t xfs_btree_ptr_len(struct xfs_btree_cur *cur)
>  		owner = cur->bc_private.a.agno;
>  
>  	xfs_btree_init_block_int(cur->bc_mp, XFS_BUF_TO_BLOCK(bp), bp->b_bn,
> -				 xfs_btree_magic(crc, btnum), level, numrecs,
> +				 cur->bc_btnum, level, numrecs,
>  				 owner, cur->bc_flags);
>  }
>  
> diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
> index 3aaced3..ae10b7b 100644
> --- a/fs/xfs/libxfs/xfs_btree.h
> +++ b/fs/xfs/libxfs/xfs_btree.h
> @@ -415,7 +415,7 @@ struct xfs_buf *				/* buffer for agno/agbno */
>  xfs_btree_init_block(
>  	struct xfs_mount *mp,
>  	struct xfs_buf	*bp,
> -	__u32		magic,
> +	xfs_btnum_t	btnum,
>  	__u16		level,
>  	__u16		numrecs,
>  	__u64		owner,
> @@ -426,7 +426,7 @@ struct xfs_buf *				/* buffer for agno/agbno */
>  	struct xfs_mount	*mp,
>  	struct xfs_btree_block	*buf,
>  	xfs_daddr_t		blkno,
> -	__u32			magic,
> +	xfs_btnum_t		btnum,
>  	__u16			level,
>  	__u16			numrecs,
>  	__u64			owner,
> diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> index bd20051..e702928 100644
> --- a/fs/xfs/xfs_fsops.c
> +++ b/fs/xfs/xfs_fsops.c
> @@ -352,12 +352,7 @@
>  			goto error0;
>  		}
>  
> -		if (xfs_sb_version_hascrc(&mp->m_sb))
> -			xfs_btree_init_block(mp, bp, XFS_ABTB_CRC_MAGIC, 0, 1,
> -						agno, 0);
> -		else
> -			xfs_btree_init_block(mp, bp, XFS_ABTB_MAGIC, 0, 1,
> -						agno, 0);
> +		xfs_btree_init_block(mp, bp, XFS_BTNUM_BNO, 0, 1, agno, 0);
>  
>  		arec = XFS_ALLOC_REC_ADDR(mp, XFS_BUF_TO_BLOCK(bp), 1);
>  		arec->ar_startblock = cpu_to_be32(mp->m_ag_prealloc_blocks);
> @@ -381,12 +376,7 @@
>  			goto error0;
>  		}
>  
> -		if (xfs_sb_version_hascrc(&mp->m_sb))
> -			xfs_btree_init_block(mp, bp, XFS_ABTC_CRC_MAGIC, 0, 1,
> -						agno, 0);
> -		else
> -			xfs_btree_init_block(mp, bp, XFS_ABTC_MAGIC, 0, 1,
> -						agno, 0);
> +		xfs_btree_init_block(mp, bp, XFS_BTNUM_CNT, 0, 1, agno, 0);
>  
>  		arec = XFS_ALLOC_REC_ADDR(mp, XFS_BUF_TO_BLOCK(bp), 1);
>  		arec->ar_startblock = cpu_to_be32(mp->m_ag_prealloc_blocks);
> @@ -413,7 +403,7 @@
>  				goto error0;
>  			}
>  
> -			xfs_btree_init_block(mp, bp, XFS_RMAP_CRC_MAGIC, 0, 0,
> +			xfs_btree_init_block(mp, bp, XFS_BTNUM_RMAP, 0, 0,
>  						agno, 0);
>  			block = XFS_BUF_TO_BLOCK(bp);
>  
> @@ -488,12 +478,7 @@
>  			goto error0;
>  		}
>  
> -		if (xfs_sb_version_hascrc(&mp->m_sb))
> -			xfs_btree_init_block(mp, bp, XFS_IBT_CRC_MAGIC, 0, 0,
> -						agno, 0);
> -		else
> -			xfs_btree_init_block(mp, bp, XFS_IBT_MAGIC, 0, 0,
> -						agno, 0);
> +		xfs_btree_init_block(mp, bp, XFS_BTNUM_INO , 0, 0, agno, 0);
>  
>  		error = xfs_bwrite(bp);
>  		xfs_buf_relse(bp);
> @@ -513,12 +498,8 @@
>  				goto error0;
>  			}
>  
> -			if (xfs_sb_version_hascrc(&mp->m_sb))
> -				xfs_btree_init_block(mp, bp, XFS_FIBT_CRC_MAGIC,
> +			xfs_btree_init_block(mp, bp, XFS_BTNUM_FINO,
>  						     0, 0, agno, 0);
> -			else
> -				xfs_btree_init_block(mp, bp, XFS_FIBT_MAGIC, 0,
> -						     0, agno, 0);
>  
>  			error = xfs_bwrite(bp);
>  			xfs_buf_relse(bp);
> @@ -539,7 +520,7 @@
>  				goto error0;
>  			}
>  
> -			xfs_btree_init_block(mp, bp, XFS_REFC_CRC_MAGIC,
> +			xfs_btree_init_block(mp, bp, XFS_BTNUM_REFC,
>  					     0, 0, agno, 0);
>  
>  			error = xfs_bwrite(bp);
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
