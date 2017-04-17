Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57024 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754367AbdDQSIY (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 17 Apr 2017 14:08:24 -0400
Date: Mon, 17 Apr 2017 14:08:22 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 10/10] xfs: remove xfs_bmap_alloc
Message-ID: <20170417180821.GC42232@bfoster.bfoster>
References: <20170413080517.12564-1-hch@lst.de>
 <20170413080517.12564-11-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170413080517.12564-11-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Thu, Apr 13, 2017 at 10:05:17AM +0200, Christoph Hellwig wrote:
> Just opencode it in the only caller to make the code flow easier to
> follow.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_alloc.c |  2 +-
>  fs/xfs/libxfs/xfs_bmap.c  | 22 ++++++----------------
>  fs/xfs/libxfs/xfs_bmap.h  |  2 +-
>  3 files changed, 8 insertions(+), 18 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index 7486401ccbd3..02326142ccb0 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -2606,7 +2606,7 @@ xfs_alloc_vextent(
>  	/*
>  	 * Just fix this up, for the case where the last a.g. is shorter
>  	 * (or there's only one a.g.) and the caller couldn't easily figure
> -	 * that out (xfs_bmap_alloc).
> +	 * that out (xfs_bmap_btalloc).
>  	 */
>  	agsize = mp->m_sb.sb_agblocks;
>  	if (args->maxlen > agsize)
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 9e3f0e6a9062..8e94030bcb8f 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -3842,20 +3842,6 @@ xfs_bmap_btalloc(
>  	return 0;
>  }
>  
> -/*
> - * xfs_bmap_alloc is called by xfs_bmapi to allocate an extent for a file.
> - * It figures out where to ask the underlying allocator to put the new extent.
> - */
> -STATIC int
> -xfs_bmap_alloc(
> -	struct xfs_bmalloca	*ap)	/* bmap alloc argument struct */
> -{
> -	if (XFS_IS_REALTIME_INODE(ap->ip) &&
> -	    xfs_alloc_is_userdata(ap->datatype))
> -		return xfs_bmap_rtalloc(ap);
> -	return xfs_bmap_btalloc(ap);
> -}
> -
>  /* Trim extent to fit a logical block range. */
>  void
>  xfs_trim_extent(
> @@ -4273,7 +4259,11 @@ xfs_bmapi_allocate(
>  			return error;
>  	}
>  
> -	error = xfs_bmap_alloc(bma);
> +	if (XFS_IS_REALTIME_INODE(bma->ip) &&
> +	    xfs_alloc_is_userdata(bma->datatype))
> +		error = xfs_bmap_rtalloc(bma);
> +	else
> +		error = xfs_bmap_btalloc(bma);
>  	if (error)
>  		return error;
>  
> @@ -4451,7 +4441,7 @@ xfs_bmapi_write(
>  {
>  	struct xfs_mount	*mp = ip->i_mount;
>  	struct xfs_ifork	*ifp;
> -	struct xfs_bmalloca	bma = { NULL };	/* args for xfs_bmap_alloc */
> +	struct xfs_bmalloca	bma = { NULL };	/* args for xfs_bmap_*alloc */
>  	xfs_fileoff_t		end;		/* end of mapped file region */
>  	bool			eof = false;	/* after the end of extents */
>  	int			error;		/* error return */
> diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
> index f35a2b2c4f06..6de7d321f8a2 100644
> --- a/fs/xfs/libxfs/xfs_bmap.h
> +++ b/fs/xfs/libxfs/xfs_bmap.h
> @@ -28,7 +28,7 @@ struct xfs_trans;
>  extern kmem_zone_t	*xfs_bmap_free_item_zone;
>  
>  /*
> - * Argument structure for xfs_bmap_alloc.
> + * Argument structure for xfs_bmap_*alloc.
>   */
>  struct xfs_bmalloca {
>  	xfs_fsblock_t		*firstblock; /* i/o first block allocated */
> -- 
> 2.11.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
