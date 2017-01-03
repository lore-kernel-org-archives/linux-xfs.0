Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48926 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965514AbdACS2Y (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 3 Jan 2017 13:28:24 -0500
Date: Tue, 3 Jan 2017 13:28:18 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 1/3] xfs: glean crc status from mp not flags in
 xfs_btree_init_block_int
Message-ID: <20170103182818.GB18120@bfoster.bfoster>
References: <670e1f09-754d-4171-0a73-f918956eba2d@redhat.com>
 <af7765f4-7930-71bb-aa2e-688a9fb644f0@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <af7765f4-7930-71bb-aa2e-688a9fb644f0@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Thu, Dec 22, 2016 at 11:44:59AM -0600, Eric Sandeen wrote:
> xfs_btree_init_block_int() can determine whether crcs are
> in effect without the passed-in XFS_BTREE_CRC_BLOCKS flag;
> the mp argument allows us to determine this from the
> superblock.  Remove the flag from callers, and use
> xfs_sb_version_hascrc(&mp->m_sb) internally instead.
> 
> This removes one difference between the if & else cases
> in the callers.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index c27344c..e645aa8 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -727,7 +727,7 @@ static inline bool xfs_bmap_wants_extents(struct xfs_inode *ip, int whichfork)
>  	if (xfs_sb_version_hascrc(&mp->m_sb))
>  		xfs_btree_init_block_int(mp, block, XFS_BUF_DADDR_NULL,
>  				 XFS_BMAP_CRC_MAGIC, 1, 1, ip->i_ino,
> -				 XFS_BTREE_LONG_PTRS | XFS_BTREE_CRC_BLOCKS);
> +				 XFS_BTREE_LONG_PTRS);
>  	else
>  		xfs_btree_init_block_int(mp, block, XFS_BUF_DADDR_NULL,
>  				 XFS_BMAP_MAGIC, 1, 1, ip->i_ino,
> @@ -804,7 +804,7 @@ static inline bool xfs_bmap_wants_extents(struct xfs_inode *ip, int whichfork)
>  	if (xfs_sb_version_hascrc(&mp->m_sb))
>  		xfs_btree_init_block_int(mp, ablock, abp->b_bn,
>  				XFS_BMAP_CRC_MAGIC, 0, 0, ip->i_ino,
> -				XFS_BTREE_LONG_PTRS | XFS_BTREE_CRC_BLOCKS);
> +				XFS_BTREE_LONG_PTRS);
>  	else
>  		xfs_btree_init_block_int(mp, ablock, abp->b_bn,
>  				XFS_BMAP_MAGIC, 0, 0, ip->i_ino,
> diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
> index 8007d2b..f0293d4 100644
> --- a/fs/xfs/libxfs/xfs_bmap_btree.c
> +++ b/fs/xfs/libxfs/xfs_bmap_btree.c
> @@ -74,7 +74,7 @@
>  	if (xfs_sb_version_hascrc(&mp->m_sb))
>  		xfs_btree_init_block_int(mp, rblock, XFS_BUF_DADDR_NULL,
>  				 XFS_BMAP_CRC_MAGIC, 0, 0, ip->i_ino,
> -				 XFS_BTREE_LONG_PTRS | XFS_BTREE_CRC_BLOCKS);
> +				 XFS_BTREE_LONG_PTRS);
>  	else
>  		xfs_btree_init_block_int(mp, rblock, XFS_BUF_DADDR_NULL,
>  				 XFS_BMAP_MAGIC, 0, 0, ip->i_ino,
> diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
> index 5c8e6f2..f49fc2f 100644
> --- a/fs/xfs/libxfs/xfs_btree.c
> +++ b/fs/xfs/libxfs/xfs_btree.c
> @@ -1090,6 +1090,8 @@ static inline size_t xfs_btree_ptr_len(struct xfs_btree_cur *cur)
>  	__u64			owner,
>  	unsigned int		flags)
>  {
> +	int			crc = xfs_sb_version_hascrc(&mp->m_sb);
> +
>  	buf->bb_magic = cpu_to_be32(magic);
>  	buf->bb_level = cpu_to_be16(level);
>  	buf->bb_numrecs = cpu_to_be16(numrecs);
> @@ -1097,7 +1099,7 @@ static inline size_t xfs_btree_ptr_len(struct xfs_btree_cur *cur)
>  	if (flags & XFS_BTREE_LONG_PTRS) {
>  		buf->bb_u.l.bb_leftsib = cpu_to_be64(NULLFSBLOCK);
>  		buf->bb_u.l.bb_rightsib = cpu_to_be64(NULLFSBLOCK);
> -		if (flags & XFS_BTREE_CRC_BLOCKS) {
> +		if (crc) {
>  			buf->bb_u.l.bb_blkno = cpu_to_be64(blkno);
>  			buf->bb_u.l.bb_owner = cpu_to_be64(owner);
>  			uuid_copy(&buf->bb_u.l.bb_uuid, &mp->m_sb.sb_meta_uuid);
> @@ -1110,7 +1112,7 @@ static inline size_t xfs_btree_ptr_len(struct xfs_btree_cur *cur)
>  
>  		buf->bb_u.s.bb_leftsib = cpu_to_be32(NULLAGBLOCK);
>  		buf->bb_u.s.bb_rightsib = cpu_to_be32(NULLAGBLOCK);
> -		if (flags & XFS_BTREE_CRC_BLOCKS) {
> +		if (crc) {
>  			buf->bb_u.s.bb_blkno = cpu_to_be64(blkno);
>  			buf->bb_u.s.bb_owner = cpu_to_be32(__owner);
>  			uuid_copy(&buf->bb_u.s.bb_uuid, &mp->m_sb.sb_meta_uuid);
> diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> index 93d12fa..bd20051 100644
> --- a/fs/xfs/xfs_fsops.c
> +++ b/fs/xfs/xfs_fsops.c
> @@ -354,7 +354,7 @@
>  
>  		if (xfs_sb_version_hascrc(&mp->m_sb))
>  			xfs_btree_init_block(mp, bp, XFS_ABTB_CRC_MAGIC, 0, 1,
> -						agno, XFS_BTREE_CRC_BLOCKS);
> +						agno, 0);
>  		else
>  			xfs_btree_init_block(mp, bp, XFS_ABTB_MAGIC, 0, 1,
>  						agno, 0);
> @@ -383,7 +383,7 @@
>  
>  		if (xfs_sb_version_hascrc(&mp->m_sb))
>  			xfs_btree_init_block(mp, bp, XFS_ABTC_CRC_MAGIC, 0, 1,
> -						agno, XFS_BTREE_CRC_BLOCKS);
> +						agno, 0);
>  		else
>  			xfs_btree_init_block(mp, bp, XFS_ABTC_MAGIC, 0, 1,
>  						agno, 0);
> @@ -414,7 +414,7 @@
>  			}
>  
>  			xfs_btree_init_block(mp, bp, XFS_RMAP_CRC_MAGIC, 0, 0,
> -						agno, XFS_BTREE_CRC_BLOCKS);
> +						agno, 0);
>  			block = XFS_BUF_TO_BLOCK(bp);
>  
>  
> @@ -490,7 +490,7 @@
>  
>  		if (xfs_sb_version_hascrc(&mp->m_sb))
>  			xfs_btree_init_block(mp, bp, XFS_IBT_CRC_MAGIC, 0, 0,
> -						agno, XFS_BTREE_CRC_BLOCKS);
> +						agno, 0);
>  		else
>  			xfs_btree_init_block(mp, bp, XFS_IBT_MAGIC, 0, 0,
>  						agno, 0);
> @@ -515,8 +515,7 @@
>  
>  			if (xfs_sb_version_hascrc(&mp->m_sb))
>  				xfs_btree_init_block(mp, bp, XFS_FIBT_CRC_MAGIC,
> -						     0, 0, agno,
> -						     XFS_BTREE_CRC_BLOCKS);
> +						     0, 0, agno, 0);
>  			else
>  				xfs_btree_init_block(mp, bp, XFS_FIBT_MAGIC, 0,
>  						     0, agno, 0);
> @@ -541,8 +540,7 @@
>  			}
>  
>  			xfs_btree_init_block(mp, bp, XFS_REFC_CRC_MAGIC,
> -					     0, 0, agno,
> -					     XFS_BTREE_CRC_BLOCKS);
> +					     0, 0, agno, 0);
>  
>  			error = xfs_bwrite(bp);
>  			xfs_buf_relse(bp);
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
