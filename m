Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:43797 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S941094AbcLVTWR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Dec 2016 14:22:17 -0500
Date: Thu, 22 Dec 2016 11:22:11 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/3] xfs: make xfs_btree_magic more generic
Message-ID: <20161222192211.GG5487@birch.djwong.org>
References: <670e1f09-754d-4171-0a73-f918956eba2d@redhat.com>
 <af5e3ed3-bc57-deeb-be96-9bbb6f19b0ed@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <af5e3ed3-bc57-deeb-be96-9bbb6f19b0ed@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Thu, Dec 22, 2016 at 11:47:26AM -0600, Eric Sandeen wrote:
> Right now the xfs_btree_magic() define takes only a cursor;
> change this to take crc and btnum args to make it more generically
> useful, and move to a header file.
> 
> This will allow xfs_btree_init_block_int callers which don't
> have a cursor to make use of the xfs_magics array, which will
> happen in the next patch.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
> index f49fc2f..cdb952a 100644
> --- a/fs/xfs/libxfs/xfs_btree.c
> +++ b/fs/xfs/libxfs/xfs_btree.c
> @@ -50,8 +50,6 @@
>  	  XFS_BMAP_CRC_MAGIC, XFS_IBT_CRC_MAGIC, XFS_FIBT_CRC_MAGIC,
>  	  XFS_REFC_CRC_MAGIC }
>  };
> -#define xfs_btree_magic(cur) \
> -	xfs_magics[!!((cur)->bc_flags & XFS_BTREE_CRC_BLOCKS)][cur->bc_btnum]
>  
>  STATIC int				/* error (0 or EFSCORRUPTED) */
>  xfs_btree_check_lblock(
> @@ -62,10 +60,13 @@
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
> @@ -74,7 +75,7 @@
>  	}
>  
>  	lblock_ok = lblock_ok &&
> -		be32_to_cpu(block->bb_magic) == xfs_btree_magic(cur) &&
> +		be32_to_cpu(block->bb_magic) == xfs_btree_magic(crc, btnum) &&
>  		be16_to_cpu(block->bb_level) == level &&
>  		be16_to_cpu(block->bb_numrecs) <=
>  			cur->bc_ops->get_maxrecs(cur, level) &&
> @@ -110,13 +111,16 @@
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
> @@ -125,7 +129,7 @@
>  	}
>  
>  	sblock_ok = sblock_ok &&
> -		be32_to_cpu(block->bb_magic) == xfs_btree_magic(cur) &&
> +		be32_to_cpu(block->bb_magic) == xfs_btree_magic(crc, btnum) &&
>  		be16_to_cpu(block->bb_level) == level &&
>  		be16_to_cpu(block->bb_numrecs) <=
>  			cur->bc_ops->get_maxrecs(cur, level) &&
> @@ -1142,7 +1146,9 @@ static inline size_t xfs_btree_ptr_len(struct xfs_btree_cur *cur)
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
> @@ -1156,7 +1162,7 @@ static inline size_t xfs_btree_ptr_len(struct xfs_btree_cur *cur)
>  		owner = cur->bc_private.a.agno;
>  
>  	xfs_btree_init_block_int(cur->bc_mp, XFS_BUF_TO_BLOCK(bp), bp->b_bn,
> -				 xfs_btree_magic(cur), level, numrecs,
> +				 xfs_btree_magic(crc, btnum), level, numrecs,
>  				 owner, cur->bc_flags);
>  }
>  
> diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
> index 8d74870..8ddacf4 100644
> --- a/fs/xfs/libxfs/xfs_types.h
> +++ b/fs/xfs/libxfs/xfs_types.h
> @@ -113,6 +113,8 @@
>  	XFS_BTNUM_INOi, XFS_BTNUM_FINOi, XFS_BTNUM_REFCi, XFS_BTNUM_MAX
>  } xfs_btnum_t;
>  
> +#define xfs_btree_magic(crc, btnum)	xfs_magics[crc][btnum]

TBH I was expecting this to be a static inline function instead of a
macro that looks like a function.  Maybe an assert to catch things like
crc=0, btnum=XFS_BTNUM_RMAP that aren't supposed to exist.

(I see that the third patch has one assert, but why not just leave it in
the helper to catch any error case?)

--D

> +
>  struct xfs_name {
>  	const unsigned char	*name;
>  	int			len;
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
