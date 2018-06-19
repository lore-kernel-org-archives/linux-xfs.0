Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:35722 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755920AbeFSF1b (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Jun 2018 01:27:31 -0400
Date: Mon, 18 Jun 2018 22:27:26 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 09/24] xfs: don't use XFS_BMAPI_IGSTATE in xfs_map_blocks
Message-ID: <20180619052726.GR8128@magnolia>
References: <20180615130209.1970-1-hch@lst.de>
 <20180615130209.1970-10-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180615130209.1970-10-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Fri, Jun 15, 2018 at 03:01:54PM +0200, Christoph Hellwig wrote:
> We want to be able to use the extent state as a reliably indicator for
> the type of I/O, and stop using the buffer head state.  For this we
> need to stop using the XFS_BMAPI_IGSTATE so that we don't see merged
> extents of different types.
> 
> Based on a patch from Dave Chinner.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Brian Foster <bfoster@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_aops.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index 307ca66879b3..39b933e17192 100644
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
> 2.17.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
