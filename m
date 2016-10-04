Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52160 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754162AbcJDQia (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 4 Oct 2016 12:38:30 -0400
Date: Tue, 4 Oct 2016 12:38:28 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 32/63] xfs: support allocating delayed extents in CoW fork
Message-ID: <20161004163828.GE55212@bfoster.bfoster>
References: <147520472904.29434.15518629624221621056.stgit@birch.djwong.org>
 <147520494805.29434.17194986410231500471.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <147520494805.29434.17194986410231500471.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org

On Thu, Sep 29, 2016 at 08:09:08PM -0700, Darrick J. Wong wrote:
> Modify xfs_bmap_add_extent_delay_real() so that we can convert delayed
> allocation extents in the CoW fork to real allocations, and wire this
> up all the way back to xfs_iomap_write_allocate().  In a subsequent
> patch, we'll modify the writepage handler to call this.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_bmap.c |   51 ++++++++++++++++++++++++++++++++--------------
>  fs/xfs/xfs_aops.c        |    6 ++++-
>  fs/xfs/xfs_iomap.c       |    7 +++++-
>  fs/xfs/xfs_iomap.h       |    2 +-
>  4 files changed, 46 insertions(+), 20 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 5749618..85a0c86 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
...
> @@ -4510,6 +4522,11 @@ xfs_bmapi_write(
>  	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
>  	if (whichfork == XFS_ATTR_FORK)
>  		ASSERT(!(flags & XFS_BMAPI_REMAP));
> +	if (whichfork == XFS_COW_FORK) {
> +		ASSERT(!(flags & XFS_BMAPI_REMAP));
> +		ASSERT(!(flags & XFS_BMAPI_PREALLOC));
> +		ASSERT(!(flags & XFS_BMAPI_CONVERT));
> +	}

Just some more 'if (..) { ASSERT() }' stuff here and below...

Brian

>  	if (flags & XFS_BMAPI_REMAP) {
>  		ASSERT(!(flags & XFS_BMAPI_PREALLOC));
>  		ASSERT(!(flags & XFS_BMAPI_CONVERT));
> @@ -4579,6 +4596,8 @@ xfs_bmapi_write(
>  		 */
>  		if (flags & XFS_BMAPI_REMAP)
>  			ASSERT(inhole);
> +		if (flags & XFS_BMAPI_COWFORK)
> +			ASSERT(!inhole);
>  
>  		/*
>  		 * First, deal with the hole before the allocated space
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index 4a28fa9..007a520 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -362,9 +362,11 @@ xfs_map_blocks(
>  
>  	if (type == XFS_IO_DELALLOC &&
>  	    (!nimaps || isnullstartblock(imap->br_startblock))) {
> -		error = xfs_iomap_write_allocate(ip, offset, imap);
> +		error = xfs_iomap_write_allocate(ip, XFS_DATA_FORK, offset,
> +				imap);
>  		if (!error)
> -			trace_xfs_map_blocks_alloc(ip, offset, count, type, imap);
> +			trace_xfs_map_blocks_alloc(ip, offset, count, type,
> +					imap);
>  		return error;
>  	}
>  
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index e8312b0..ad6939d 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -667,6 +667,7 @@ xfs_file_iomap_begin_delay(
>  int
>  xfs_iomap_write_allocate(
>  	xfs_inode_t	*ip,
> +	int		whichfork,
>  	xfs_off_t	offset,
>  	xfs_bmbt_irec_t *imap)
>  {
> @@ -679,8 +680,12 @@ xfs_iomap_write_allocate(
>  	xfs_trans_t	*tp;
>  	int		nimaps;
>  	int		error = 0;
> +	int		flags = 0;
>  	int		nres;
>  
> +	if (whichfork == XFS_COW_FORK)
> +		flags |= XFS_BMAPI_COWFORK;
> +
>  	/*
>  	 * Make sure that the dquots are there.
>  	 */
> @@ -774,7 +779,7 @@ xfs_iomap_write_allocate(
>  			 * pointer that the caller gave to us.
>  			 */
>  			error = xfs_bmapi_write(tp, ip, map_start_fsb,
> -						count_fsb, 0, &first_block,
> +						count_fsb, flags, &first_block,
>  						nres, imap, &nimaps,
>  						&dfops);
>  			if (error)
> diff --git a/fs/xfs/xfs_iomap.h b/fs/xfs/xfs_iomap.h
> index 6498be4..a16b956 100644
> --- a/fs/xfs/xfs_iomap.h
> +++ b/fs/xfs/xfs_iomap.h
> @@ -25,7 +25,7 @@ struct xfs_bmbt_irec;
>  
>  int xfs_iomap_write_direct(struct xfs_inode *, xfs_off_t, size_t,
>  			struct xfs_bmbt_irec *, int);
> -int xfs_iomap_write_allocate(struct xfs_inode *, xfs_off_t,
> +int xfs_iomap_write_allocate(struct xfs_inode *, int, xfs_off_t,
>  			struct xfs_bmbt_irec *);
>  int xfs_iomap_write_unwritten(struct xfs_inode *, xfs_off_t, xfs_off_t);
>  
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
