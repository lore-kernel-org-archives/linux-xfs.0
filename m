Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60546 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965521AbdACS23 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 3 Jan 2017 13:28:29 -0500
Date: Tue, 3 Jan 2017 13:28:23 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/3 V2] xfs: make xfs_btree_magic more generic
Message-ID: <20170103182823.GC18120@bfoster.bfoster>
References: <670e1f09-754d-4171-0a73-f918956eba2d@redhat.com>
 <af5e3ed3-bc57-deeb-be96-9bbb6f19b0ed@sandeen.net>
 <728f2c88-971b-6615-639a-7e1d0e61c295@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <728f2c88-971b-6615-639a-7e1d0e61c295@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Thu, Dec 22, 2016 at 01:43:55PM -0600, Eric Sandeen wrote:
> Right now the xfs_btree_magic() define takes only a cursor;
> change this to take crc and btnum args to make it more generically
> useful, and move to a function.
> 
> This will allow xfs_btree_init_block_int callers which don't
> have a cursor to make use of the xfs_magics array, which will
> happen in the next patch.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> V2: turn xfs_btree_magic into a function with a built-in ASSERT
> 
> diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
> index f49fc2f..81866dd 100644
> --- a/fs/xfs/libxfs/xfs_btree.c
> +++ b/fs/xfs/libxfs/xfs_btree.c
> @@ -50,8 +50,15 @@
>  	  XFS_BMAP_CRC_MAGIC, XFS_IBT_CRC_MAGIC, XFS_FIBT_CRC_MAGIC,
>  	  XFS_REFC_CRC_MAGIC }
>  };
> -#define xfs_btree_magic(cur) \
> -	xfs_magics[!!((cur)->bc_flags & XFS_BTREE_CRC_BLOCKS)][cur->bc_btnum]
> +
> +__uint32_t xfs_btree_magic(int crc, xfs_btnum_t btnum)
> +{
> +	__uint32_t magic = xfs_magics[crc][btnum];
> +
> +	/* Ensure we asked for crc for crc-only magics. */

Purely a nit, but for whatever reason this sentence confused me.
Perhaps just drop it, or say something like "ensure we asked for a valid
magic?"

Either way:

Reviewed-by: Brian Foster <bfoster@redhat.com>

> +	ASSERT(magic != 0);
> +	return magic;
> +}
>  
>  STATIC int				/* error (0 or EFSCORRUPTED) */
>  xfs_btree_check_lblock(
> @@ -62,10 +69,13 @@
>  {
>  	int			lblock_ok = 1; /* block passes checks */
>  	struct xfs_mount	*mp;	/* file system mount point */
> +	xfs_btnum_t		btnum = cur->bc_btnum;
> +	int			crc;
>  
>  	mp = cur->bc_mp;
> +	crc = xfs_sb_version_hascrc(&mp->m_sb);
>  
> -	if (xfs_sb_version_hascrc(&mp->m_sb)) {
> +	if (crc) {
>  		lblock_ok = lblock_ok &&
>  			uuid_equal(&block->bb_u.l.bb_uuid,
>  				   &mp->m_sb.sb_meta_uuid) &&
> @@ -74,7 +84,7 @@
>  	}
>  
>  	lblock_ok = lblock_ok &&
> -		be32_to_cpu(block->bb_magic) == xfs_btree_magic(cur) &&
> +		be32_to_cpu(block->bb_magic) == xfs_btree_magic(crc, btnum) &&
>  		be16_to_cpu(block->bb_level) == level &&
>  		be16_to_cpu(block->bb_numrecs) <=
>  			cur->bc_ops->get_maxrecs(cur, level) &&
> @@ -110,13 +120,16 @@
>  	struct xfs_agf		*agf;	/* ag. freespace structure */
>  	xfs_agblock_t		agflen;	/* native ag. freespace length */
>  	int			sblock_ok = 1; /* block passes checks */
> +	xfs_btnum_t		btnum = cur->bc_btnum;
> +	int			crc;
>  
>  	mp = cur->bc_mp;
> +	crc = xfs_sb_version_hascrc(&mp->m_sb);
>  	agbp = cur->bc_private.a.agbp;
>  	agf = XFS_BUF_TO_AGF(agbp);
>  	agflen = be32_to_cpu(agf->agf_length);
>  
> -	if (xfs_sb_version_hascrc(&mp->m_sb)) {
> +	if (crc) {
>  		sblock_ok = sblock_ok &&
>  			uuid_equal(&block->bb_u.s.bb_uuid,
>  				   &mp->m_sb.sb_meta_uuid) &&
> @@ -125,7 +138,7 @@
>  	}
>  
>  	sblock_ok = sblock_ok &&
> -		be32_to_cpu(block->bb_magic) == xfs_btree_magic(cur) &&
> +		be32_to_cpu(block->bb_magic) == xfs_btree_magic(crc, btnum) &&
>  		be16_to_cpu(block->bb_level) == level &&
>  		be16_to_cpu(block->bb_numrecs) <=
>  			cur->bc_ops->get_maxrecs(cur, level) &&
> @@ -1142,7 +1155,9 @@ static inline size_t xfs_btree_ptr_len(struct xfs_btree_cur *cur)
>  	int			level,
>  	int			numrecs)
>  {
> -	__u64 owner;
> +	__u64			owner;
> +	int			crc = xfs_sb_version_hascrc(&cur->bc_mp->m_sb);
> +	xfs_btnum_t		btnum = cur->bc_btnum;
>  
>  	/*
>  	 * we can pull the owner from the cursor right now as the different
> @@ -1156,7 +1171,7 @@ static inline size_t xfs_btree_ptr_len(struct xfs_btree_cur *cur)
>  		owner = cur->bc_private.a.agno;
>  
>  	xfs_btree_init_block_int(cur->bc_mp, XFS_BUF_TO_BLOCK(bp), bp->b_bn,
> -				 xfs_btree_magic(cur), level, numrecs,
> +				 xfs_btree_magic(crc, btnum), level, numrecs,
>  				 owner, cur->bc_flags);
>  }
>  
> diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
> index c2b01d1..3aaced3 100644
> --- a/fs/xfs/libxfs/xfs_btree.h
> +++ b/fs/xfs/libxfs/xfs_btree.h
> @@ -76,6 +76,8 @@
>  #define	XFS_BTNUM_RMAP	((xfs_btnum_t)XFS_BTNUM_RMAPi)
>  #define	XFS_BTNUM_REFC	((xfs_btnum_t)XFS_BTNUM_REFCi)
>  
> +__uint32_t xfs_btree_magic(int crc, xfs_btnum_t btnum);
> +
>  /*
>   * For logging record fields.
>   */
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
