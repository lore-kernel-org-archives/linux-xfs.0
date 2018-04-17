Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:58718 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750765AbeDQGDx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Apr 2018 02:03:53 -0400
Date: Mon, 16 Apr 2018 23:03:32 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: set format back to extents if
 xfs_bmap_extents_to_btree fails
Message-ID: <20180417060332.GF5203@magnolia>
References: <0add6e45-4382-c16b-3bb1-1d4eaee1adc3@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0add6e45-4382-c16b-3bb1-1d4eaee1adc3@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>, wen.xu@gatech.edu

On Mon, Apr 16, 2018 at 11:26:12PM -0500, Eric Sandeen wrote:
> If xfs_bmap_extents_to_btree fails in a mode where we call
> xfs_iroot_realloc(-1) to de-allocate the root, set the
> format back to extents.
> 
> Otherwise we can assume we can dereference ifp->if_broot
> based on the XFS_DINODE_FMT_BTREE format, and crash.
> 
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=199423
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks ok, will test...
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 6a7c2f0..040eeda 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -725,12 +725,16 @@ static inline bool xfs_bmap_wants_extents(struct xfs_inode *ip, int whichfork)
>  	*logflagsp = 0;
>  	if ((error = xfs_alloc_vextent(&args))) {
>  		xfs_iroot_realloc(ip, -1, whichfork);
> +		ASSERT(ifp->if_broot == NULL);
> +		XFS_IFORK_FMT_SET(ip, whichfork, XFS_DINODE_FMT_EXTENTS);
>  		xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
>  		return error;
>  	}
>  
>  	if (WARN_ON_ONCE(args.fsbno == NULLFSBLOCK)) {
>  		xfs_iroot_realloc(ip, -1, whichfork);
> +		ASSERT(ifp->if_broot == NULL);
> +		XFS_IFORK_FMT_SET(ip, whichfork, XFS_DINODE_FMT_EXTENTS);
>  		xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
>  		return -ENOSPC;
>  	}
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
