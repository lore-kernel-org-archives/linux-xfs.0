Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:40826 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753056AbeGDAuu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Jul 2018 20:50:50 -0400
Date: Tue, 3 Jul 2018 17:50:34 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 11/25] xfs: remove xfs_bmapi_write() firstblock param
Message-ID: <20180704005034.GK32415@magnolia>
References: <20180703172319.24509-1-bfoster@redhat.com>
 <20180703172319.24509-12-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180703172319.24509-12-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Jul 03, 2018 at 01:23:05PM -0400, Brian Foster wrote:
> All callers pass ->t_firstblock from the current transaction.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_attr_remote.c |  3 +--
>  fs/xfs/libxfs/xfs_bmap.c        | 18 +++++-------------
>  fs/xfs/libxfs/xfs_bmap.h        |  3 +--
>  fs/xfs/libxfs/xfs_da_btree.c    |  5 ++---
>  fs/xfs/xfs_bmap_util.c          |  5 ++---
>  fs/xfs/xfs_dquot.c              |  3 +--
>  fs/xfs/xfs_iomap.c              | 10 ++++------
>  fs/xfs/xfs_reflink.c            |  6 +++---
>  fs/xfs/xfs_rtalloc.c            |  4 ++--
>  fs/xfs/xfs_symlink.c            |  3 +--
>  10 files changed, 22 insertions(+), 38 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
> index 205098aeb4bc..2db9ef186e05 100644
> --- a/fs/xfs/libxfs/xfs_attr_remote.c
> +++ b/fs/xfs/libxfs/xfs_attr_remote.c
> @@ -484,8 +484,7 @@ xfs_attr_rmtval_set(
>  			       &args->trans->t_firstblock);
>  		nmap = 1;
>  		error = xfs_bmapi_write(args->trans, dp, (xfs_fileoff_t)lblkno,
> -				  blkcnt, XFS_BMAPI_ATTRFORK,
> -				  &args->trans->t_firstblock, args->total, &map,
> +				  blkcnt, XFS_BMAPI_ATTRFORK, args->total, &map,
>  				  &nmap);
>  		if (error)
>  			goto out_defer_cancel;
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 05647d4b8f3e..fd4125e3b097 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -4213,12 +4213,6 @@ xfs_bmapi_convert_unwritten(
>   * extent state if necessary.  Details behaviour is controlled by the flags
>   * parameter.  Only allocates blocks from a single allocation group, to avoid
>   * locking problems.
> - *
> - * The returned value in "firstblock" from the first call in a transaction
> - * must be remembered and presented to subsequent calls in "firstblock".
> - * An upper bound for the number of blocks to be allocated is supplied to
> - * the first call in "total"; if no allocation group has that many free
> - * blocks then the call will fail (return NULLFSBLOCK in "firstblock").
>   */
>  int
>  xfs_bmapi_write(
> @@ -4227,8 +4221,6 @@ xfs_bmapi_write(
>  	xfs_fileoff_t		bno,		/* starting file offs. mapped */
>  	xfs_filblks_t		len,		/* length to map in file */
>  	int			flags,		/* XFS_BMAPI_... */
> -	xfs_fsblock_t		*firstblock,	/* first allocated block
> -						   controls a.g. for allocs */
>  	xfs_extlen_t		total,		/* total blocks needed */
>  	struct xfs_bmbt_irec	*mval,		/* output: map values */
>  	int			*nmap)		/* i/o: mval size/count */
> @@ -4296,7 +4288,7 @@ xfs_bmapi_write(
>  
>  	XFS_STATS_INC(mp, xs_blk_mapw);
>  
> -	if (!tp || *firstblock == NULLFSBLOCK) {
> +	if (!tp || tp->t_firstblock == NULLFSBLOCK) {
>  		if (XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_BTREE)
>  			bma.minleft = be16_to_cpu(ifp->if_broot->bb_level) + 1;
>  		else
> @@ -4323,7 +4315,7 @@ xfs_bmapi_write(
>  	bma.ip = ip;
>  	bma.total = total;
>  	bma.datatype = 0;
> -	bma.firstblock = firstblock;
> +	bma.firstblock = &tp->t_firstblock;
>  	ASSERT(!tp || tp->t_dfops);
>  
>  	while (bno < end && n < *nmap) {
> @@ -4476,11 +4468,11 @@ xfs_bmapi_write(
>  
>  	if (bma.cur) {
>  		if (!error) {
> -			ASSERT(*firstblock == NULLFSBLOCK ||
> -			       XFS_FSB_TO_AGNO(mp, *firstblock) <=
> +			ASSERT(tp->t_firstblock == NULLFSBLOCK ||
> +			       XFS_FSB_TO_AGNO(mp, tp->t_firstblock) <=
>  			       XFS_FSB_TO_AGNO(mp,
>  				       bma.cur->bc_private.b.firstblock));
> -			*firstblock = bma.cur->bc_private.b.firstblock;
> +			tp->t_firstblock = bma.cur->bc_private.b.firstblock;
>  		}
>  		xfs_btree_del_cursor(bma.cur,
>  			error ? XFS_BTREE_ERROR : XFS_BTREE_NOERROR);
> diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
> index 2da6c6daada8..1f9e29f32f20 100644
> --- a/fs/xfs/libxfs/xfs_bmap.h
> +++ b/fs/xfs/libxfs/xfs_bmap.h
> @@ -204,8 +204,7 @@ int	xfs_bmapi_read(struct xfs_inode *ip, xfs_fileoff_t bno,
>  		int *nmap, int flags);
>  int	xfs_bmapi_write(struct xfs_trans *tp, struct xfs_inode *ip,
>  		xfs_fileoff_t bno, xfs_filblks_t len, int flags,
> -		xfs_fsblock_t *firstblock, xfs_extlen_t total,
> -		struct xfs_bmbt_irec *mval, int *nmap);
> +		xfs_extlen_t total, struct xfs_bmbt_irec *mval, int *nmap);
>  int	__xfs_bunmapi(struct xfs_trans *tp, struct xfs_inode *ip,
>  		xfs_fileoff_t bno, xfs_filblks_t *rlen, int flags,
>  		xfs_extnum_t nexts, xfs_fsblock_t *firstblock);
> diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
> index 2f2be86c10dc..fe4a192696ae 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.c
> +++ b/fs/xfs/libxfs/xfs_da_btree.c
> @@ -2061,7 +2061,7 @@ xfs_da_grow_inode_int(
>  	nmap = 1;
>  	error = xfs_bmapi_write(tp, dp, *bno, count,
>  			xfs_bmapi_aflag(w)|XFS_BMAPI_METADATA|XFS_BMAPI_CONTIG,
> -			&tp->t_firstblock, args->total, &map, &nmap);
> +			args->total, &map, &nmap);
>  	if (error)
>  		return error;
>  
> @@ -2083,8 +2083,7 @@ xfs_da_grow_inode_int(
>  			c = (int)(*bno + count - b);
>  			error = xfs_bmapi_write(tp, dp, b, c,
>  					xfs_bmapi_aflag(w)|XFS_BMAPI_METADATA,
> -					&tp->t_firstblock, args->total,
> -					&mapp[mapi], &nmap);
> +					args->total, &mapp[mapi], &nmap);
>  			if (error)
>  				goto out_free_map;
>  			if (nmap < 1)
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index b690def4962b..0c433dbc6eb2 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -972,9 +972,8 @@ xfs_alloc_file_space(
>  
>  		xfs_defer_init(tp, &dfops, &tp->t_firstblock);
>  		error = xfs_bmapi_write(tp, ip, startoffset_fsb,
> -					allocatesize_fsb, alloc_type,
> -					&tp->t_firstblock, resblks, imapp,
> -					&nimaps);
> +					allocatesize_fsb, alloc_type, resblks,
> +					imapp, &nimaps);
>  		if (error)
>  			goto error0;
>  
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index 2fc5e21373be..84359eeb20f4 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -311,8 +311,7 @@ xfs_dquot_disk_alloc(
>  	xfs_trans_ijoin(tp, quotip, XFS_ILOCK_EXCL);
>  	error = xfs_bmapi_write(tp, quotip, dqp->q_fileoffset,
>  			XFS_DQUOT_CLUSTER_SIZE_FSB, XFS_BMAPI_METADATA,
> -			&tp->t_firstblock, XFS_QM_DQALLOC_SPACE_RES(mp),
> -			&map, &nmaps);
> +			XFS_QM_DQALLOC_SPACE_RES(mp), &map, &nmaps);
>  	if (error)
>  		goto error0;
>  	ASSERT(map.br_blockcount == XFS_DQUOT_CLUSTER_SIZE_FSB);
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index 4a8a85b0fad2..46ade3f7a5a3 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -256,8 +256,7 @@ xfs_iomap_write_direct(
>  	xfs_defer_init(tp, &dfops, &tp->t_firstblock);
>  	nimaps = 1;
>  	error = xfs_bmapi_write(tp, ip, offset_fsb, count_fsb,
> -				bmapi_flags, &tp->t_firstblock, resblks, imap,
> -				&nimaps);
> +				bmapi_flags, resblks, imap, &nimaps);
>  	if (error)
>  		goto out_bmap_cancel;
>  
> @@ -768,8 +767,7 @@ xfs_iomap_write_allocate(
>  			 * pointer that the caller gave to us.
>  			 */
>  			error = xfs_bmapi_write(tp, ip, map_start_fsb,
> -						count_fsb, flags,
> -						&tp->t_firstblock, nres, imap,
> +						count_fsb, flags, nres, imap,
>  						&nimaps);
>  			if (error)
>  				goto trans_cancel;
> @@ -877,8 +875,8 @@ xfs_iomap_write_unwritten(
>  		xfs_defer_init(tp, &dfops, &tp->t_firstblock);
>  		nimaps = 1;
>  		error = xfs_bmapi_write(tp, ip, offset_fsb, count_fsb,
> -					XFS_BMAPI_CONVERT, &tp->t_firstblock,
> -					resblks, &imap, &nimaps);
> +					XFS_BMAPI_CONVERT, resblks, &imap,
> +					&nimaps);
>  		if (error)
>  			goto error_on_bmapi_transaction;
>  
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index eed6b9df7944..258183f28141 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -324,7 +324,7 @@ xfs_reflink_convert_cow_extent(
>  	if (imap->br_blockcount == 0)
>  		return 0;
>  	return xfs_bmapi_write(NULL, ip, imap->br_startoff, imap->br_blockcount,
> -			XFS_BMAPI_COWFORK | XFS_BMAPI_CONVERT, NULL, 0, imap,
> +			XFS_BMAPI_COWFORK | XFS_BMAPI_CONVERT, 0, imap,
>  			&nimaps);
>  }
>  
> @@ -347,7 +347,7 @@ xfs_reflink_convert_cow(
>  	xfs_ilock(ip, XFS_ILOCK_EXCL);
>  	error = xfs_bmapi_write(NULL, ip, offset_fsb, count_fsb,
>  			XFS_BMAPI_COWFORK | XFS_BMAPI_CONVERT |
> -			XFS_BMAPI_CONVERT_ONLY, NULL, 0, &imap, &nimaps);
> +			XFS_BMAPI_CONVERT_ONLY, 0, &imap, &nimaps);
>  	xfs_iunlock(ip, XFS_ILOCK_EXCL);
>  	return error;
>  }
> @@ -430,7 +430,7 @@ xfs_reflink_allocate_cow(
>  	/* Allocate the entire reservation as unwritten blocks. */
>  	error = xfs_bmapi_write(tp, ip, imap->br_startoff, imap->br_blockcount,
>  			XFS_BMAPI_COWFORK | XFS_BMAPI_PREALLOC,
> -			&tp->t_firstblock, resblks, imap, &nimaps);
> +			resblks, imap, &nimaps);
>  	if (error)
>  		goto out_bmap_cancel;
>  
> diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> index 1c894ea2abca..edd949376a51 100644
> --- a/fs/xfs/xfs_rtalloc.c
> +++ b/fs/xfs/xfs_rtalloc.c
> @@ -792,8 +792,8 @@ xfs_growfs_rt_alloc(
>  		 */
>  		nmap = 1;
>  		error = xfs_bmapi_write(tp, ip, oblocks, nblocks - oblocks,
> -					XFS_BMAPI_METADATA, &tp->t_firstblock,
> -					resblks, &map, &nmap);
> +					XFS_BMAPI_METADATA, resblks, &map,
> +					&nmap);
>  		if (!error && nmap < 1)
>  			error = -ENOSPC;
>  		if (error)
> diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
> index 18d9b4d301e5..94301b63525f 100644
> --- a/fs/xfs/xfs_symlink.c
> +++ b/fs/xfs/xfs_symlink.c
> @@ -288,8 +288,7 @@ xfs_symlink(
>  		nmaps = XFS_SYMLINK_MAPS;
>  
>  		error = xfs_bmapi_write(tp, ip, first_fsb, fs_blocks,
> -				  XFS_BMAPI_METADATA, &tp->t_firstblock,
> -				  resblks, mval, &nmaps);
> +				  XFS_BMAPI_METADATA, resblks, mval, &nmaps);
>  		if (error)
>  			goto out_bmap_cancel;
>  
> -- 
> 2.17.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
