Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49674 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726547AbeJCTEF (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 3 Oct 2018 15:04:05 -0400
Date: Wed, 3 Oct 2018 08:15:54 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 3/8] xfs: remove magic handling of unwritten extents in
 xfs_bmapi_allocate
Message-ID: <20181003121553.GB61971@bfoster>
References: <20181002174207.25275-1-hch@lst.de>
 <20181002174207.25275-4-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181002174207.25275-4-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Tue, Oct 02, 2018 at 10:42:02AM -0700, Christoph Hellwig wrote:
> There is no real need to treat unwritten delalloc extent special in
> any way here, so remove the special casing and related comment.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_bmap.c | 16 +++-------------
>  1 file changed, 3 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index da6b768664e3..3bb250ee6c7c 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -4069,20 +4069,10 @@ xfs_bmapi_allocate(
>  	bma->got.br_startoff = bma->offset;
>  	bma->got.br_startblock = bma->blkno;
>  	bma->got.br_blockcount = bma->length;
> -	bma->got.br_state = XFS_EXT_NORM;
> -
> -	/*
> -	 * In the data fork, a wasdelay extent has been initialized, so
> -	 * shouldn't be flagged as unwritten.
> -	 *
> -	 * For the cow fork, however, we convert delalloc reservations
> -	 * (extents allocated for speculative preallocation) to
> -	 * allocated unwritten extents, and only convert the unwritten
> -	 * extents to real extents when we're about to write the data.
> -	 */
> -	if ((!bma->wasdel || (bma->flags & XFS_BMAPI_COWFORK)) &&
> -	    (bma->flags & XFS_BMAPI_PREALLOC))
> +	if (bma->flags & XFS_BMAPI_PREALLOC)
>  		bma->got.br_state = XFS_EXT_UNWRITTEN;
> +	else
> +		bma->got.br_state = XFS_EXT_NORM;
>  
>  	if (bma->wasdel)
>  		error = xfs_bmap_add_extent_delay_real(bma, whichfork);
> -- 
> 2.19.0
> 
