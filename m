Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:14520 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755193AbdDMS2f (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 13 Apr 2017 14:28:35 -0400
Date: Thu, 13 Apr 2017 14:28:33 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 03/10] xfs: remove the XFS_BMAPI_CONTIG flag
Message-ID: <20170413182832.GC25915@bfoster.bfoster>
References: <20170413080517.12564-1-hch@lst.de>
 <20170413080517.12564-4-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170413080517.12564-4-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Thu, Apr 13, 2017 at 10:05:10AM +0200, Christoph Hellwig wrote:
> The only user just went away, so we can remove the flag and the minlen
> parameter in struct xfs_bmalloca now.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_bmap.c | 17 +++++++----------
>  fs/xfs/libxfs/xfs_bmap.h |  3 ---
>  2 files changed, 7 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 7f42f6067eb5..aec4907056ba 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -3473,12 +3473,12 @@ xfs_bmap_select_minlen(
>  	xfs_extlen_t		*blen,
>  	int			notinit)
>  {
> -	if (notinit || *blen < ap->minlen) {
> +	if (notinit) {
>  		/*
>  		 * Since we did a BUF_TRYLOCK above, it is possible that
>  		 * there is space for this request.
>  		 */
> -		args->minlen = ap->minlen;
> +		args->minlen = 1;

The ap param is no longer used in this function. Otherwise looks Ok to
me:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  	} else if (*blen < args->maxlen) {
>  		/*
>  		 * If the best seen length is less than the request length,
> @@ -3670,11 +3670,11 @@ xfs_bmap_btalloc(
>  			args.type = XFS_ALLOCTYPE_FIRST_AG;
>  		else
>  			args.type = XFS_ALLOCTYPE_START_BNO;
> -		args.total = args.minlen = ap->minlen;
> +		args.total = args.minlen = 1;
>  	} else {
>  		args.type = XFS_ALLOCTYPE_NEAR_BNO;
>  		args.total = ap->total;
> -		args.minlen = ap->minlen;
> +		args.minlen = 1;
>  	}
>  	/* apply extent size hints if obtained earlier */
>  	if (align) {
> @@ -3776,9 +3776,8 @@ xfs_bmap_btalloc(
>  		if ((error = xfs_alloc_vextent(&args)))
>  			return error;
>  	}
> -	if (args.fsbno == NULLFSBLOCK && nullfb &&
> -	    args.minlen > ap->minlen) {
> -		args.minlen = ap->minlen;
> +	if (args.fsbno == NULLFSBLOCK && nullfb && args.minlen > 1) {
> +		args.minlen = 1;
>  		args.type = XFS_ALLOCTYPE_START_BNO;
>  		args.fsbno = ap->blkno;
>  		if ((error = xfs_alloc_vextent(&args)))
> @@ -3787,7 +3786,7 @@ xfs_bmap_btalloc(
>  	if (args.fsbno == NULLFSBLOCK && nullfb) {
>  		args.fsbno = 0;
>  		args.type = XFS_ALLOCTYPE_FIRST_AG;
> -		args.total = ap->minlen;
> +		args.total = 1;
>  		if ((error = xfs_alloc_vextent(&args)))
>  			return error;
>  		ap->dfops->dop_low = true;
> @@ -4246,8 +4245,6 @@ xfs_bmapi_allocate(
>  			bma->datatype |= XFS_ALLOC_USERDATA_ZERO;
>  	}
>  
> -	bma->minlen = (bma->flags & XFS_BMAPI_CONTIG) ? bma->length : 1;
> -
>  	/*
>  	 * Only want to do the alignment at the eof if it is userdata and
>  	 * allocation length is larger than a stripe unit.
> diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
> index a6e612cabe15..d9e0b1db4cdb 100644
> --- a/fs/xfs/libxfs/xfs_bmap.h
> +++ b/fs/xfs/libxfs/xfs_bmap.h
> @@ -48,7 +48,6 @@ struct xfs_bmalloca {
>  	int			logflags;/* flags for transaction logging */
>  
>  	xfs_extlen_t		total;	/* total blocks needed for xaction */
> -	xfs_extlen_t		minlen;	/* minimum allocation size (blocks) */
>  	xfs_extlen_t		minleft; /* amount must be left after alloc */
>  	bool			eof;	/* set if allocating past last extent */
>  	bool			wasdel;	/* replacing a delayed allocation */
> @@ -81,7 +80,6 @@ struct xfs_extent_free_item
>  #define XFS_BMAPI_PREALLOC	0x008	/* preallocation op: unwritten space */
>  #define XFS_BMAPI_IGSTATE	0x010	/* Ignore state - */
>  					/* combine contig. space */
> -#define XFS_BMAPI_CONTIG	0x020	/* must allocate only one extent */
>  /*
>   * unwritten extent conversion - this needs write cache flushing and no additional
>   * allocation alignments. When specified with XFS_BMAPI_PREALLOC it converts
> @@ -119,7 +117,6 @@ struct xfs_extent_free_item
>  	{ XFS_BMAPI_ATTRFORK,	"ATTRFORK" }, \
>  	{ XFS_BMAPI_PREALLOC,	"PREALLOC" }, \
>  	{ XFS_BMAPI_IGSTATE,	"IGSTATE" }, \
> -	{ XFS_BMAPI_CONTIG,	"CONTIG" }, \
>  	{ XFS_BMAPI_CONVERT,	"CONVERT" }, \
>  	{ XFS_BMAPI_ZERO,	"ZERO" }, \
>  	{ XFS_BMAPI_REMAP,	"REMAP" }, \
> -- 
> 2.11.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
