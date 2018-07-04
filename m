Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:44006 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752388AbeGDArS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Jul 2018 20:47:18 -0400
Date: Tue, 3 Jul 2018 17:47:03 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 07/25] xfs: use ->t_firstblock for all xfs_bmapi_write()
 callers
Message-ID: <20180704004703.GG32415@magnolia>
References: <20180703172319.24509-1-bfoster@redhat.com>
 <20180703172319.24509-8-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180703172319.24509-8-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Jul 03, 2018 at 01:23:01PM -0400, Brian Foster wrote:
> Convert all xfs_bmapi_write() users to ->t_firstblock.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_bmap_util.c |  8 ++++----
>  fs/xfs/xfs_dquot.c     |  5 ++---
>  fs/xfs/xfs_iomap.c     | 20 +++++++++-----------
>  fs/xfs/xfs_reflink.c   |  7 +++----
>  fs/xfs/xfs_rtalloc.c   |  5 ++---
>  5 files changed, 20 insertions(+), 25 deletions(-)
> 
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index aea33d526db2..f9a0957343ea 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -872,7 +872,6 @@ xfs_alloc_file_space(
>  	xfs_filblks_t		allocatesize_fsb;
>  	xfs_extlen_t		extsz, temp;
>  	xfs_fileoff_t		startoffset_fsb;
> -	xfs_fsblock_t		firstfsb;
>  	int			nimaps;
>  	int			quota_flag;
>  	int			rt;
> @@ -971,10 +970,11 @@ xfs_alloc_file_space(
>  
>  		xfs_trans_ijoin(tp, ip, 0);
>  
> -		xfs_defer_init(tp, &dfops, &firstfsb);
> +		xfs_defer_init(tp, &dfops, &tp->t_firstblock);
>  		error = xfs_bmapi_write(tp, ip, startoffset_fsb,
> -					allocatesize_fsb, alloc_type, &firstfsb,
> -					resblks, imapp, &nimaps);
> +					allocatesize_fsb, alloc_type,
> +					&tp->t_firstblock, resblks, imapp,
> +					&nimaps);
>  		if (error)
>  			goto error0;
>  
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index c698e7f6f744..2fc5e21373be 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -290,13 +290,12 @@ xfs_dquot_disk_alloc(
>  	struct xfs_mount	*mp = tp->t_mountp;
>  	struct xfs_buf		*bp;
>  	struct xfs_inode	*quotip = xfs_quota_inode(mp, dqp->dq_flags);
> -	xfs_fsblock_t		firstblock;
>  	int			nmaps = 1;
>  	int			error;
>  
>  	trace_xfs_dqalloc(dqp);
>  
> -	xfs_defer_init(tp, tp->t_dfops, &firstblock);
> +	xfs_defer_init(tp, tp->t_dfops, &tp->t_firstblock);
>  
>  	xfs_ilock(quotip, XFS_ILOCK_EXCL);
>  	if (!xfs_this_quota_on(dqp->q_mount, dqp->dq_flags)) {
> @@ -312,7 +311,7 @@ xfs_dquot_disk_alloc(
>  	xfs_trans_ijoin(tp, quotip, XFS_ILOCK_EXCL);
>  	error = xfs_bmapi_write(tp, quotip, dqp->q_fileoffset,
>  			XFS_DQUOT_CLUSTER_SIZE_FSB, XFS_BMAPI_METADATA,
> -			&firstblock, XFS_QM_DQALLOC_SPACE_RES(mp),
> +			&tp->t_firstblock, XFS_QM_DQALLOC_SPACE_RES(mp),
>  			&map, &nmaps);
>  	if (error)
>  		goto error0;
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index c9b9c7984f95..4a8a85b0fad2 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -152,7 +152,6 @@ xfs_iomap_write_direct(
>  	xfs_fileoff_t	offset_fsb;
>  	xfs_fileoff_t	last_fsb;
>  	xfs_filblks_t	count_fsb, resaligned;
> -	xfs_fsblock_t	firstfsb;
>  	xfs_extlen_t	extsz;
>  	int		nimaps;
>  	int		quota_flag;
> @@ -254,10 +253,10 @@ xfs_iomap_write_direct(
>  	 * From this point onwards we overwrite the imap pointer that the
>  	 * caller gave to us.
>  	 */
> -	xfs_defer_init(tp, &dfops, &firstfsb);
> +	xfs_defer_init(tp, &dfops, &tp->t_firstblock);
>  	nimaps = 1;
>  	error = xfs_bmapi_write(tp, ip, offset_fsb, count_fsb,
> -				bmapi_flags, &firstfsb, resblks, imap,
> +				bmapi_flags, &tp->t_firstblock, resblks, imap,
>  				&nimaps);
>  	if (error)
>  		goto out_bmap_cancel;
> @@ -665,7 +664,6 @@ xfs_iomap_write_allocate(
>  	xfs_mount_t	*mp = ip->i_mount;
>  	xfs_fileoff_t	offset_fsb, last_block;
>  	xfs_fileoff_t	end_fsb, map_start_fsb;
> -	xfs_fsblock_t	first_block;
>  	struct xfs_defer_ops	dfops;
>  	xfs_filblks_t	count_fsb;
>  	xfs_trans_t	*tp;
> @@ -716,7 +714,7 @@ xfs_iomap_write_allocate(
>  			xfs_ilock(ip, XFS_ILOCK_EXCL);
>  			xfs_trans_ijoin(tp, ip, 0);
>  
> -			xfs_defer_init(tp, &dfops, &first_block);
> +			xfs_defer_init(tp, &dfops, &tp->t_firstblock);
>  
>  			/*
>  			 * it is possible that the extents have changed since
> @@ -770,8 +768,9 @@ xfs_iomap_write_allocate(
>  			 * pointer that the caller gave to us.
>  			 */
>  			error = xfs_bmapi_write(tp, ip, map_start_fsb,
> -						count_fsb, flags, &first_block,
> -						nres, imap, &nimaps);
> +						count_fsb, flags,
> +						&tp->t_firstblock, nres, imap,
> +						&nimaps);
>  			if (error)
>  				goto trans_cancel;
>  
> @@ -827,7 +826,6 @@ xfs_iomap_write_unwritten(
>  	xfs_fileoff_t	offset_fsb;
>  	xfs_filblks_t	count_fsb;
>  	xfs_filblks_t	numblks_fsb;
> -	xfs_fsblock_t	firstfsb;
>  	int		nimaps;
>  	xfs_trans_t	*tp;
>  	xfs_bmbt_irec_t imap;
> @@ -876,11 +874,11 @@ xfs_iomap_write_unwritten(
>  		/*
>  		 * Modify the unwritten extent state of the buffer.
>  		 */
> -		xfs_defer_init(tp, &dfops, &firstfsb);
> +		xfs_defer_init(tp, &dfops, &tp->t_firstblock);
>  		nimaps = 1;
>  		error = xfs_bmapi_write(tp, ip, offset_fsb, count_fsb,
> -					XFS_BMAPI_CONVERT, &firstfsb, resblks,
> -					&imap, &nimaps);
> +					XFS_BMAPI_CONVERT, &tp->t_firstblock,
> +					resblks, &imap, &nimaps);
>  		if (error)
>  			goto error_on_bmapi_transaction;
>  
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index 92b6e1b5d33c..f0486b748376 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -366,7 +366,6 @@ xfs_reflink_allocate_cow(
>  	struct xfs_bmbt_irec	got;
>  	struct xfs_defer_ops	dfops;
>  	struct xfs_trans	*tp = NULL;
> -	xfs_fsblock_t		first_block;
>  	int			nimaps, error = 0;
>  	bool			trimmed;
>  	xfs_filblks_t		resaligned;
> @@ -425,13 +424,13 @@ xfs_reflink_allocate_cow(
>  
>  	xfs_trans_ijoin(tp, ip, 0);
>  
> -	xfs_defer_init(tp, &dfops, &first_block);
> +	xfs_defer_init(tp, &dfops, &tp->t_firstblock);
>  	nimaps = 1;
>  
>  	/* Allocate the entire reservation as unwritten blocks. */
>  	error = xfs_bmapi_write(tp, ip, imap->br_startoff, imap->br_blockcount,
> -			XFS_BMAPI_COWFORK | XFS_BMAPI_PREALLOC, &first_block,
> -			resblks, imap, &nimaps);
> +			XFS_BMAPI_COWFORK | XFS_BMAPI_PREALLOC,
> +			&tp->t_firstblock, resblks, imap, &nimaps);
>  	if (error)
>  		goto out_bmap_cancel;
>  
> diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> index c102b0d26bc1..1c894ea2abca 100644
> --- a/fs/xfs/xfs_rtalloc.c
> +++ b/fs/xfs/xfs_rtalloc.c
> @@ -761,7 +761,6 @@ xfs_growfs_rt_alloc(
>  	struct xfs_buf		*bp;	/* temporary buffer for zeroing */
>  	xfs_daddr_t		d;		/* disk block address */
>  	int			error;		/* error return value */
> -	xfs_fsblock_t		firstblock;/* first block allocated in xaction */
>  	struct xfs_defer_ops	dfops;		/* list of freed blocks */
>  	xfs_fsblock_t		fsbno;		/* filesystem block for bno */
>  	struct xfs_bmbt_irec	map;		/* block map output */
> @@ -787,13 +786,13 @@ xfs_growfs_rt_alloc(
>  		xfs_ilock(ip, XFS_ILOCK_EXCL);
>  		xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
>  
> -		xfs_defer_init(tp, &dfops, &firstblock);
> +		xfs_defer_init(tp, &dfops, &tp->t_firstblock);
>  		/*
>  		 * Allocate blocks to the bitmap file.
>  		 */
>  		nmap = 1;
>  		error = xfs_bmapi_write(tp, ip, oblocks, nblocks - oblocks,
> -					XFS_BMAPI_METADATA, &firstblock,
> +					XFS_BMAPI_METADATA, &tp->t_firstblock,
>  					resblks, &map, &nmap);
>  		if (!error && nmap < 1)
>  			error = -ENOSPC;
> -- 
> 2.17.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
