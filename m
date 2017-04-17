Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49112 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752639AbdDQOTe (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 17 Apr 2017 10:19:34 -0400
Date: Mon, 17 Apr 2017 10:19:32 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 05/10] xfs: remove the total argument to
 xfs_bmap_local_to_extents
Message-ID: <20170417141932.GC41659@bfoster.bfoster>
References: <20170413080517.12564-1-hch@lst.de>
 <20170413080517.12564-6-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170413080517.12564-6-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Thu, Apr 13, 2017 at 10:05:12AM +0200, Christoph Hellwig wrote:
> It must inherently be the same as the minlen/maxlen arguments for
> this allocation.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_bmap.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index aec4907056ba..53f1386b1868 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -867,7 +867,6 @@ xfs_bmap_local_to_extents(
>  	xfs_trans_t	*tp,		/* transaction pointer */
>  	xfs_inode_t	*ip,		/* incore inode pointer */
>  	xfs_fsblock_t	*firstblock,	/* first block allocated in xaction */
> -	xfs_extlen_t	total,		/* total blocks needed by transaction */
>  	int		*logflagsp,	/* inode logging flags */
>  	int		whichfork,
>  	void		(*init_fn)(struct xfs_trans *tp,
> @@ -916,8 +915,7 @@ xfs_bmap_local_to_extents(
>  		args.fsbno = *firstblock;
>  		args.type = XFS_ALLOCTYPE_NEAR_BNO;
>  	}
> -	args.total = total;
> -	args.minlen = args.maxlen = args.prod = 1;
> +	args.total = args.minlen = args.maxlen = args.prod = 1;
>  	error = xfs_alloc_vextent(&args);
>  	if (error)
>  		goto done;
> @@ -1067,7 +1065,7 @@ xfs_bmap_add_attrfork_local(
>  	}
>  
>  	if (S_ISLNK(VFS_I(ip)->i_mode))
> -		return xfs_bmap_local_to_extents(tp, ip, firstblock, 1,
> +		return xfs_bmap_local_to_extents(tp, ip, firstblock,
>  						 flags, XFS_DATA_FORK,
>  						 xfs_symlink_local_to_remote);
>  
> -- 
> 2.11.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
