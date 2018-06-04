Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34536 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750868AbeFDMZG (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 4 Jun 2018 08:25:06 -0400
Date: Mon, 4 Jun 2018 08:25:04 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 08/21] xfs: don't use XFS_BMAPI_IGSTATE in xfs_map_blocks
Message-ID: <20180604122503.GA110455@bfoster.bfoster>
References: <20180531180759.21631-1-hch@lst.de>
 <20180531180759.21631-9-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180531180759.21631-9-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Thu, May 31, 2018 at 08:07:46PM +0200, Christoph Hellwig wrote:
> We want to be able to use the extent state as a reliably indicator for
> the type of I/O, and stop using the buffer head state.  For this we
> need to stop using the XFS_BMAPI_IGSTATE so that we don't see merged
> extents of different types.
> 
> Based on a patch from Dave Chinner.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Thanks for splitting these up. Looks good to me:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_aops.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index 25d112a4bcf5..2966d62b0594 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -385,7 +385,6 @@ xfs_map_blocks(
>  	ssize_t			count = i_blocksize(inode);
>  	xfs_fileoff_t		offset_fsb, end_fsb;
>  	int			error = 0;
> -	int			bmapi_flags = XFS_BMAPI_ENTIRE;
>  	int			nimaps = 1;
>  
>  	if (XFS_FORCED_SHUTDOWN(mp))
> @@ -405,8 +404,6 @@ xfs_map_blocks(
>  		return 0;
>  
>  	ASSERT(type != XFS_IO_COW);
> -	if (type == XFS_IO_UNWRITTEN)
> -		bmapi_flags |= XFS_BMAPI_IGSTATE;
>  
>  	xfs_ilock(ip, XFS_ILOCK_SHARED);
>  	ASSERT(ip->i_d.di_format != XFS_DINODE_FMT_BTREE ||
> @@ -418,7 +415,7 @@ xfs_map_blocks(
>  	end_fsb = XFS_B_TO_FSB(mp, (xfs_ufsize_t)offset + count);
>  	offset_fsb = XFS_B_TO_FSBT(mp, offset);
>  	error = xfs_bmapi_read(ip, offset_fsb, end_fsb - offset_fsb,
> -				imap, &nimaps, bmapi_flags);
> +				imap, &nimaps, XFS_BMAPI_ENTIRE);
>  	/*
>  	 * Truncate an overwrite extent if there's a pending CoW
>  	 * reservation before the end of this extent.  This forces us
> -- 
> 2.17.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
