Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:41754 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753119AbeGDAwp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Jul 2018 20:52:45 -0400
Date: Tue, 3 Jul 2018 17:52:29 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 15/25] xfs: remove xfs_bmalloca firstblock field
Message-ID: <20180704005229.GO32415@magnolia>
References: <20180703172319.24509-1-bfoster@redhat.com>
 <20180703172319.24509-16-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180703172319.24509-16-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Jul 03, 2018 at 01:23:09PM -0400, Brian Foster wrote:
> The xfs_bmalloca.firstblock field carries the firstblock value from
> the transaction into the bmap infrastructure. It's initialized in
> one place from ->t_firstblock, so drop the field and access
> ->t_firstblock directly throughout the bmap code.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_bmap.c | 44 +++++++++++++++++++++-------------------
>  fs/xfs/libxfs/xfs_bmap.h |  1 -
>  2 files changed, 23 insertions(+), 22 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 43157e5ff46b..bd1273546b54 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -1794,7 +1794,7 @@ xfs_bmap_add_extent_delay_real(
>  
>  		if (xfs_bmap_needs_btree(bma->ip, whichfork)) {
>  			error = xfs_bmap_extents_to_btree(bma->tp, bma->ip,
> -					bma->firstblock, &bma->cur, 1,
> +					&bma->tp->t_firstblock, &bma->cur, 1,
>  					&tmp_rval, whichfork);
>  			rval |= tmp_rval;
>  			if (error)
> @@ -1872,7 +1872,7 @@ xfs_bmap_add_extent_delay_real(
>  
>  		if (xfs_bmap_needs_btree(bma->ip, whichfork)) {
>  			error = xfs_bmap_extents_to_btree(bma->tp, bma->ip,
> -				bma->firstblock, &bma->cur, 1, &tmp_rval,
> +				&bma->tp->t_firstblock, &bma->cur, 1, &tmp_rval,
>  				whichfork);
>  			rval |= tmp_rval;
>  			if (error)
> @@ -1953,7 +1953,7 @@ xfs_bmap_add_extent_delay_real(
>  
>  		if (xfs_bmap_needs_btree(bma->ip, whichfork)) {
>  			error = xfs_bmap_extents_to_btree(bma->tp, bma->ip,
> -					bma->firstblock, &bma->cur, 1,
> +					&bma->tp->t_firstblock, &bma->cur, 1,
>  					&tmp_rval, whichfork);
>  			rval |= tmp_rval;
>  			if (error)
> @@ -1991,7 +1991,7 @@ xfs_bmap_add_extent_delay_real(
>  
>  		ASSERT(bma->cur == NULL);
>  		error = xfs_bmap_extents_to_btree(bma->tp, bma->ip,
> -				bma->firstblock, &bma->cur, da_old > 0,
> +				&bma->tp->t_firstblock, &bma->cur, da_old > 0,
>  				&tmp_logflags, whichfork);
>  		bma->logflags |= tmp_logflags;
>  		if (error)
> @@ -3056,10 +3056,11 @@ xfs_bmap_adjacent(
>  		XFS_FSB_TO_AGBNO(mp, x) < mp->m_sb.sb_agblocks)
>  
>  	mp = ap->ip->i_mount;
> -	nullfb = *ap->firstblock == NULLFSBLOCK;
> +	nullfb = ap->tp->t_firstblock == NULLFSBLOCK;
>  	rt = XFS_IS_REALTIME_INODE(ap->ip) &&
>  		xfs_alloc_is_userdata(ap->datatype);
> -	fb_agno = nullfb ? NULLAGNUMBER : XFS_FSB_TO_AGNO(mp, *ap->firstblock);
> +	fb_agno = nullfb ? NULLAGNUMBER : XFS_FSB_TO_AGNO(mp,
> +							ap->tp->t_firstblock);
>  	/*
>  	 * If allocating at eof, and there's a previous real block,
>  	 * try to use its last block as our starting point.
> @@ -3417,8 +3418,9 @@ xfs_bmap_btalloc(
>  	}
>  
>  
> -	nullfb = *ap->firstblock == NULLFSBLOCK;
> -	fb_agno = nullfb ? NULLAGNUMBER : XFS_FSB_TO_AGNO(mp, *ap->firstblock);
> +	nullfb = ap->tp->t_firstblock == NULLFSBLOCK;
> +	fb_agno = nullfb ? NULLAGNUMBER : XFS_FSB_TO_AGNO(mp,
> +							ap->tp->t_firstblock);
>  	if (nullfb) {
>  		if (xfs_alloc_is_userdata(ap->datatype) &&
>  		    xfs_inode_is_filestream(ap->ip)) {
> @@ -3429,7 +3431,7 @@ xfs_bmap_btalloc(
>  			ap->blkno = XFS_INO_TO_FSB(mp, ap->ip->i_ino);
>  		}
>  	} else
> -		ap->blkno = *ap->firstblock;
> +		ap->blkno = ap->tp->t_firstblock;
>  
>  	xfs_bmap_adjacent(ap);
>  
> @@ -3440,7 +3442,7 @@ xfs_bmap_btalloc(
>  	if (nullfb || XFS_FSB_TO_AGNO(mp, ap->blkno) == fb_agno)
>  		;
>  	else
> -		ap->blkno = *ap->firstblock;
> +		ap->blkno = ap->tp->t_firstblock;
>  	/*
>  	 * Normal allocation, done through xfs_alloc_vextent.
>  	 */
> @@ -3453,7 +3455,7 @@ xfs_bmap_btalloc(
>  
>  	/* Trim the allocation back to the maximum an AG can fit. */
>  	args.maxlen = min(ap->length, mp->m_ag_max_usable);
> -	args.firstblock = *ap->firstblock;
> +	args.firstblock = ap->tp->t_firstblock;
>  	blen = 0;
>  	if (nullfb) {
>  		/*
> @@ -3602,13 +3604,13 @@ xfs_bmap_btalloc(
>  		 * check the allocation happened at the same or higher AG than
>  		 * the first block that was allocated.
>  		 */
> -		ASSERT(*ap->firstblock == NULLFSBLOCK ||
> -		       XFS_FSB_TO_AGNO(mp, *ap->firstblock) <=
> +		ASSERT(ap->tp->t_firstblock == NULLFSBLOCK ||
> +		       XFS_FSB_TO_AGNO(mp, ap->tp->t_firstblock) <=
>  		       XFS_FSB_TO_AGNO(mp, args.fsbno));
>  
>  		ap->blkno = args.fsbno;
> -		if (*ap->firstblock == NULLFSBLOCK)
> -			*ap->firstblock = args.fsbno;
> +		if (ap->tp->t_firstblock == NULLFSBLOCK)
> +			ap->tp->t_firstblock = args.fsbno;
>  		ASSERT(nullfb || fb_agno <= args.agno);
>  		ap->length = args.len;
>  		/*
> @@ -4065,12 +4067,12 @@ xfs_bmapi_allocate(
>  		return error;
>  
>  	if (bma->cur)
> -		bma->cur->bc_private.b.firstblock = *bma->firstblock;
> +		bma->cur->bc_private.b.firstblock = bma->tp->t_firstblock;
>  	if (bma->blkno == NULLFSBLOCK)
>  		return 0;
>  	if ((ifp->if_flags & XFS_IFBROOT) && !bma->cur) {
>  		bma->cur = xfs_bmbt_init_cursor(mp, bma->tp, bma->ip, whichfork);
> -		bma->cur->bc_private.b.firstblock = *bma->firstblock;
> +		bma->cur->bc_private.b.firstblock = bma->tp->t_firstblock;
>  	}
>  	/*
>  	 * Bump the number of extents we've allocated
> @@ -4106,7 +4108,8 @@ xfs_bmapi_allocate(
>  	else
>  		error = xfs_bmap_add_extent_hole_real(bma->tp, bma->ip,
>  				whichfork, &bma->icur, &bma->cur, &bma->got,
> -				bma->firstblock, &bma->logflags, bma->flags);
> +				&bma->tp->t_firstblock, &bma->logflags,
> +				bma->flags);
>  
>  	bma->logflags |= tmp_logflags;
>  	if (error)
> @@ -4157,7 +4160,7 @@ xfs_bmapi_convert_unwritten(
>  	if ((ifp->if_flags & XFS_IFBROOT) && !bma->cur) {
>  		bma->cur = xfs_bmbt_init_cursor(bma->ip->i_mount, bma->tp,
>  					bma->ip, whichfork);
> -		bma->cur->bc_private.b.firstblock = *bma->firstblock;
> +		bma->cur->bc_private.b.firstblock = bma->tp->t_firstblock;
>  	}
>  	mval->br_state = (mval->br_state == XFS_EXT_UNWRITTEN)
>  				? XFS_EXT_NORM : XFS_EXT_UNWRITTEN;
> @@ -4174,7 +4177,7 @@ xfs_bmapi_convert_unwritten(
>  	}
>  
>  	error = xfs_bmap_add_extent_unwritten_real(bma->tp, bma->ip, whichfork,
> -			&bma->icur, &bma->cur, mval, bma->firstblock,
> +			&bma->icur, &bma->cur, mval, &bma->tp->t_firstblock,
>  			&tmp_logflags);
>  	/*
>  	 * Log the inode core unconditionally in the unwritten extent conversion
> @@ -4315,7 +4318,6 @@ xfs_bmapi_write(
>  	bma.ip = ip;
>  	bma.total = total;
>  	bma.datatype = 0;
> -	bma.firstblock = &tp->t_firstblock;
>  	ASSERT(!tp || tp->t_dfops);
>  
>  	while (bno < end && n < *nmap) {
> diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
> index fa839679ecb6..bbd641ae3261 100644
> --- a/fs/xfs/libxfs/xfs_bmap.h
> +++ b/fs/xfs/libxfs/xfs_bmap.h
> @@ -19,7 +19,6 @@ extern kmem_zone_t	*xfs_bmap_free_item_zone;
>   * Argument structure for xfs_bmap_alloc.
>   */
>  struct xfs_bmalloca {
> -	xfs_fsblock_t		*firstblock; /* i/o first block allocated */
>  	struct xfs_trans	*tp;	/* transaction pointer */
>  	struct xfs_inode	*ip;	/* incore inode pointer */
>  	struct xfs_bmbt_irec	prev;	/* extent before the new one */
> -- 
> 2.17.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
