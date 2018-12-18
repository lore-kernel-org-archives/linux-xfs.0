Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:48278 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726714AbeLRWbO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Dec 2018 17:31:14 -0500
Date: Tue, 18 Dec 2018 14:31:08 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 03/11] xfs: remove the s_maxbytes checks in xfs_map_blocks
Message-ID: <20181218223108.GQ27208@magnolia>
References: <20181203222503.30649-1-hch@lst.de>
 <20181203222503.30649-4-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181203222503.30649-4-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Mon, Dec 03, 2018 at 05:24:55PM -0500, Christoph Hellwig wrote:
> We already ensure all data fits into s_maxbytes in the write / fault
> path.  The only reason we have them here is that they were copy and
> pasted from xfs_bmapi_read when we stopped using that function.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_aops.c | 8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index 8fec6fd4c632..5b6fab283316 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -301,7 +301,8 @@ xfs_map_blocks(
>  	struct xfs_inode	*ip = XFS_I(inode);
>  	struct xfs_mount	*mp = ip->i_mount;
>  	ssize_t			count = i_blocksize(inode);
> -	xfs_fileoff_t		offset_fsb = XFS_B_TO_FSBT(mp, offset), end_fsb;
> +	xfs_fileoff_t		offset_fsb = XFS_B_TO_FSBT(mp, offset);
> +	xfs_fileoff_t		end_fsb = XFS_B_TO_FSB(mp, offset + count);
>  	xfs_fileoff_t		cow_fsb = NULLFILEOFF;
>  	struct xfs_bmbt_irec	imap;
>  	struct xfs_iext_cursor	icur;
> @@ -356,11 +357,6 @@ xfs_map_blocks(
>  	xfs_ilock(ip, XFS_ILOCK_SHARED);
>  	ASSERT(ip->i_d.di_format != XFS_DINODE_FMT_BTREE ||
>  	       (ip->i_df.if_flags & XFS_IFEXTENTS));
> -	ASSERT(offset <= mp->m_super->s_maxbytes);
> -
> -	if (offset > mp->m_super->s_maxbytes - count)
> -		count = mp->m_super->s_maxbytes - offset;
> -	end_fsb = XFS_B_TO_FSB(mp, (xfs_ufsize_t)offset + count);
>  
>  	/*
>  	 * Check if this is offset is covered by a COW extents, and if yes use
> -- 
> 2.19.1
> 
