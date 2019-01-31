Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49882 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726957AbfAaSKQ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 31 Jan 2019 13:10:16 -0500
Date: Thu, 31 Jan 2019 13:10:13 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 03/11] xfs: remove the s_maxbytes checks in xfs_map_blocks
Message-ID: <20190131181013.GE36239@bfoster>
References: <20190131075524.4769-1-hch@lst.de>
 <20190131075524.4769-4-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190131075524.4769-4-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>

On Thu, Jan 31, 2019 at 08:55:16AM +0100, Christoph Hellwig wrote:
> We already ensure all data fits into s_maxbytes in the write / fault
> path.  The only reason we have them here is that they were copy and
> pasted from xfs_bmapi_read when we stopped using that function.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_aops.c | 8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index a3fa60d1d2df..8bfb62d8776f 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -338,7 +338,8 @@ xfs_map_blocks(
>  	struct xfs_inode	*ip = XFS_I(inode);
>  	struct xfs_mount	*mp = ip->i_mount;
>  	ssize_t			count = i_blocksize(inode);
> -	xfs_fileoff_t		offset_fsb = XFS_B_TO_FSBT(mp, offset), end_fsb;
> +	xfs_fileoff_t		offset_fsb = XFS_B_TO_FSBT(mp, offset);
> +	xfs_fileoff_t		end_fsb = XFS_B_TO_FSB(mp, offset + count);
>  	xfs_fileoff_t		cow_fsb = NULLFILEOFF;
>  	struct xfs_bmbt_irec	imap;
>  	struct xfs_iext_cursor	icur;
> @@ -374,11 +375,6 @@ xfs_map_blocks(
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
> 2.20.1
> 
