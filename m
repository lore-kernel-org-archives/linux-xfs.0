Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43602 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752140AbdDQSIL (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 17 Apr 2017 14:08:11 -0400
Date: Mon, 17 Apr 2017 14:08:08 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 08/10] xfs: introduce a XFS_BMAPI_BESTEFFORT flag
Message-ID: <20170417180808.GA42232@bfoster.bfoster>
References: <20170413080517.12564-1-hch@lst.de>
 <20170413080517.12564-9-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170413080517.12564-9-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Thu, Apr 13, 2017 at 10:05:15AM +0200, Christoph Hellwig wrote:
> We currently have two classes of xfs_bmapi_write callers that have
> conflicting space reservation needs.  Many callers expect to be able
> to reserve the number of total blocks passed in a single AG for
> the use with the current allocation as well as future allocations
> in the same transactions, or transactions chained off from it.
> 
> Other callers want to allocate up to the number of blocks passed in,
> although they are fine with a smaller number of blocks to make
> forward progress.  For those we only need to leave a few blocks aside
> for the bmap btree manipulations when doing the main space allocation.
> 
> This patch introduces a new XFS_BMAPI_BESTEFFORT flag for the second
> kind of callers that ignores the total flag and just uses the minleft
> parameter to leave space for bmap btree allocations and splits.
> 
> With this we can remove the potentially dangerous fallback that
> ignores the total reservation in xfs_bmap_btalloc.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_attr_remote.c |  6 ++++--
>  fs/xfs/libxfs/xfs_bmap.c        | 27 ++++++++++++++++++++-------
>  fs/xfs/libxfs/xfs_bmap.h        |  3 +++
>  fs/xfs/xfs_bmap_util.c          |  2 ++
>  fs/xfs/xfs_iomap.c              |  4 ++--
>  fs/xfs/xfs_reflink.c            |  3 ++-
>  6 files changed, 33 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
> index d52f525f5b2d..35a99d15521c 100644
> --- a/fs/xfs/libxfs/xfs_attr_remote.c
> +++ b/fs/xfs/libxfs/xfs_attr_remote.c
> @@ -464,8 +464,10 @@ xfs_attr_rmtval_set(
>  		xfs_defer_init(args->dfops, args->firstblock);
>  		nmap = 1;
>  		error = xfs_bmapi_write(args->trans, dp, (xfs_fileoff_t)lblkno,
> -				  blkcnt, XFS_BMAPI_ATTRFORK, args->firstblock,
> -				  args->total, &map, &nmap, args->dfops);
> +				  blkcnt,
> +				  XFS_BMAPI_ATTRFORK | XFS_BMAPI_BESTEFFORT,
> +				  args->firstblock, args->total, &map, &nmap,
> +				  args->dfops);
>  		if (!error)
>  			error = xfs_defer_finish(&args->trans, args->dfops, dp);
>  		if (error) {
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 6faefa342748..c06e7d500ed1 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -915,7 +915,7 @@ xfs_bmap_local_to_extents(
>  		args.fsbno = *firstblock;
>  		args.type = XFS_ALLOCTYPE_NEAR_BNO;
>  	}
> -	args.total = args.minlen = args.maxlen = args.prod = 1;
> +	args.minlen = args.maxlen = args.prod = 1;
>  	error = xfs_alloc_vextent(&args);
>  	if (error)
>  		goto done;
> @@ -3504,7 +3504,6 @@ xfs_bmap_btalloc_nullfb(
>  	int			error;
>  
>  	args->type = XFS_ALLOCTYPE_START_BNO;
> -	args->total = ap->total;
>  
>  	startag = ag = XFS_FSB_TO_AGNO(mp, args->fsbno);
>  	if (startag == NULLAGNUMBER)
> @@ -3538,7 +3537,6 @@ xfs_bmap_btalloc_filestreams(
>  	int			error;
>  
>  	args->type = XFS_ALLOCTYPE_NEAR_BNO;
> -	args->total = ap->total;
>  
>  	ag = XFS_FSB_TO_AGNO(mp, args->fsbno);
>  	if (ag == NULLAGNUMBER)
> @@ -3684,10 +3682,9 @@ xfs_bmap_btalloc(
>  			args.type = XFS_ALLOCTYPE_FIRST_AG;
>  		else
>  			args.type = XFS_ALLOCTYPE_START_BNO;
> -		args.total = args.minlen = 1;
> +		args.minlen = 1;
>  	} else {
>  		args.type = XFS_ALLOCTYPE_NEAR_BNO;
> -		args.total = ap->total;
>  		args.minlen = 1;
>  	}
>  	/* apply extent size hints if obtained earlier */
> @@ -3754,7 +3751,24 @@ xfs_bmap_btalloc(
>  		args.alignment = 1;
>  		args.minalignslop = 0;
>  	}
> -	args.minleft = xfs_bmap_minleft(ap);
> +
> +	/*
> +	 * If the XFS_BMAPI_BESTEFFORT flag is set we try to allocate any
> +	 * space that's available, even if it is less than requested.  We
> +	 * still need to set a minleft value to guarantee that we can still
> +	 * manipulate the bmap btree, though.  The total value is ignored in
> +	 * this case.
> +	 *
> +	 * If the flag is not set the total value specifies the total space
> +	 * that the transaction may use, and we must find an AG that has
> +	 * enough space available for all of total, or this allocation request
> +	 * will fail.
> +	 */
> +	if (ap->flags & XFS_BMAPI_BESTEFFORT)
> +		args.minleft = xfs_bmap_minleft(ap);
> +	else
> +		args.total = ap->total;
> +

This seems Ok, but I don't think it's very elegant to have callers pass
a total parameter along with a flag to ignore it. Couldn't we just set
minleft when total is not used and pass zero from those particular
callers, or do we actually need to support the !BESTEFFORT && total == 0
case? (At the very least, we could assert that total == 0 when
BESTEFFORT is set.)

Brian

>  	args.wasdel = ap->wasdel;
>  	args.resv = XFS_AG_RESV_NONE;
>  	args.datatype = ap->datatype;
> @@ -3800,7 +3814,6 @@ xfs_bmap_btalloc(
>  	if (args.fsbno == NULLFSBLOCK && nullfb) {
>  		args.fsbno = 0;
>  		args.type = XFS_ALLOCTYPE_FIRST_AG;
> -		args.total = 1;
>  		if ((error = xfs_alloc_vextent(&args)))
>  			return error;
>  		ap->dfops->dop_low = true;
> diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
> index 36a7f36f5f38..f35a2b2c4f06 100644
> --- a/fs/xfs/libxfs/xfs_bmap.h
> +++ b/fs/xfs/libxfs/xfs_bmap.h
> @@ -79,6 +79,9 @@ struct xfs_extent_free_item
>  #define XFS_BMAPI_PREALLOC	0x008	/* preallocation op: unwritten space */
>  #define XFS_BMAPI_IGSTATE	0x010	/* Ignore state - */
>  					/* combine contig. space */
> +
> +#define XFS_BMAPI_BESTEFFORT	0x020	/* may allocate less than requested */
> +
>  /*
>   * unwritten extent conversion - this needs write cache flushing and no additional
>   * allocation alignments. When specified with XFS_BMAPI_PREALLOC it converts
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index 4d1920e594b0..f809ebc7a495 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -1033,6 +1033,8 @@ xfs_alloc_file_space(
>  	startoffset_fsb	= XFS_B_TO_FSBT(mp, offset);
>  	allocatesize_fsb = XFS_B_TO_FSB(mp, count);
>  
> +	alloc_type |= XFS_BMAPI_BESTEFFORT;
> +
>  	/*
>  	 * Allocate file space until done or until there is an error
>  	 */
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index 009f8243dddc..1abed9b6d5c5 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -171,7 +171,7 @@ xfs_iomap_write_direct(
>  	uint		qblocks, resblks, resrtextents;
>  	int		error;
>  	int		lockmode;
> -	int		bmapi_flags = XFS_BMAPI_PREALLOC;
> +	int		bmapi_flags = XFS_BMAPI_PREALLOC | XFS_BMAPI_BESTEFFORT;
>  	uint		tflags = 0;
>  
>  	rt = XFS_IS_REALTIME_INODE(ip);
> @@ -679,7 +679,7 @@ xfs_iomap_write_allocate(
>  	xfs_trans_t	*tp;
>  	int		nimaps;
>  	int		error = 0;
> -	int		flags = XFS_BMAPI_DELALLOC;
> +	int		flags = XFS_BMAPI_DELALLOC | XFS_BMAPI_BESTEFFORT;
>  	int		nres;
>  
>  	if (whichfork == XFS_COW_FORK)
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index c0f3754caca2..aad321c16d2f 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -455,7 +455,8 @@ xfs_reflink_allocate_cow(
>  
>  	/* Allocate the entire reservation as unwritten blocks. */
>  	error = xfs_bmapi_write(tp, ip, imap->br_startoff, imap->br_blockcount,
> -			XFS_BMAPI_COWFORK | XFS_BMAPI_PREALLOC, &first_block,
> +			XFS_BMAPI_COWFORK | XFS_BMAPI_PREALLOC |
> +			XFS_BMAPI_BESTEFFORT, &first_block,
>  			resblks, imap, &nimaps, &dfops);
>  	if (error)
>  		goto out_bmap_cancel;
> -- 
> 2.11.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
