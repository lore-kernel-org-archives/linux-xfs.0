Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:34806 "EHLO
        ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751070AbcLEBkI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 4 Dec 2016 20:40:08 -0500
Date: Mon, 5 Dec 2016 12:35:32 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 03/55] xfs: complain if we don't get nextents bmap records
Message-ID: <20161205013532.GR31101@dastard>
References: <148072891404.12995.15510849192837089093.stgit@birch.djwong.org>
 <148072893359.12995.10240545634733611493.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <148072893359.12995.10240545634733611493.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Dec 02, 2016 at 05:35:33PM -0800, Darrick J. Wong wrote:
> When reading into memory all extents of a btree-format inode fork,
> complain if the number of extents we find is not the same as the number
> of extents reported in the inode core.  This is needed to stop an IO
> action from accessing the garbage areas of the in-core fork.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_bmap.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 6f28814..9821161 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -1375,6 +1375,8 @@ xfs_bmap_read_extents(
>  			return error;
>  		block = XFS_BUF_TO_BLOCK(bp);
>  	}
> +	if (i != XFS_IFORK_NEXTENTS(ip, whichfork))
> +		return -EFSCORRUPTED;
>  	ASSERT(i == xfs_iext_count(ifp));
>  	ASSERT(i == XFS_IFORK_NEXTENTS(ip, whichfork));

This assert is now redundant and can be removed (which I've done).

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
