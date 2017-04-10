Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:16534 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752211AbdDJT5l (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Apr 2017 15:57:41 -0400
Date: Mon, 10 Apr 2017 12:57:35 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 6/6] xfs: remove bmap block allocation retries
Message-ID: <20170410195735.GB10459@birch.djwong.org>
References: <20170403121833.7825-1-hch@lst.de>
 <20170403121833.7825-7-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170403121833.7825-7-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Mon, Apr 03, 2017 at 02:18:33PM +0200, Christoph Hellwig wrote:
> Now that reflink operations don't set the firstblock value we don't
> need the workarounds for non-NULL firstblock values without a prior
> allocation.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_bmap.c       | 29 -----------------------------
>  fs/xfs/libxfs/xfs_bmap_btree.c | 17 -----------------
>  2 files changed, 46 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 0035f96a6e5a..c66e9c25e3c2 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -764,7 +764,6 @@ xfs_bmap_extents_to_btree(
>  		args.fsbno = XFS_INO_TO_FSB(mp, ip->i_ino);
>  	} else if (dfops->dop_low) {
>  		args.type = XFS_ALLOCTYPE_START_BNO;
> -try_another_ag:
>  		args.fsbno = *firstblock;
>  	} else {
>  		args.type = XFS_ALLOCTYPE_NEAR_BNO;
> @@ -779,20 +778,6 @@ xfs_bmap_extents_to_btree(
>  		return error;
>  	}
>  
> -	/*
> -	 * During a CoW operation, the allocation and bmbt updates occur in
> -	 * different transactions.  The mapping code tries to put new bmbt
> -	 * blocks near extents being mapped, but the only way to guarantee this
> -	 * is if the alloc and the mapping happen in a single transaction that
> -	 * has a block reservation.  That isn't the case here, so if we run out
> -	 * of space we'll try again with another AG.
> -	 */
> -	if (xfs_sb_version_hasreflink(&cur->bc_mp->m_sb) &&
> -	    args.fsbno == NULLFSBLOCK &&
> -	    args.type == XFS_ALLOCTYPE_NEAR_BNO) {
> -		args.type = XFS_ALLOCTYPE_FIRST_AG;
> -		goto try_another_ag;
> -	}
>  	if (WARN_ON_ONCE(args.fsbno == NULLFSBLOCK)) {
>  		xfs_iroot_realloc(ip, -1, whichfork);
>  		xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
> @@ -925,7 +910,6 @@ xfs_bmap_local_to_extents(
>  	 * file currently fits in an inode.
>  	 */
>  	if (*firstblock == NULLFSBLOCK) {
> -try_another_ag:
>  		args.fsbno = XFS_INO_TO_FSB(args.mp, ip->i_ino);
>  		args.type = XFS_ALLOCTYPE_START_BNO;
>  	} else {
> @@ -938,19 +922,6 @@ xfs_bmap_local_to_extents(
>  	if (error)
>  		goto done;
>  
> -	/*
> -	 * During a CoW operation, the allocation and bmbt updates occur in
> -	 * different transactions.  The mapping code tries to put new bmbt
> -	 * blocks near extents being mapped, but the only way to guarantee this
> -	 * is if the alloc and the mapping happen in a single transaction that
> -	 * has a block reservation.  That isn't the case here, so if we run out
> -	 * of space we'll try again with another AG.
> -	 */
> -	if (xfs_sb_version_hasreflink(&ip->i_mount->m_sb) &&
> -	    args.fsbno == NULLFSBLOCK &&
> -	    args.type == XFS_ALLOCTYPE_NEAR_BNO) {
> -		goto try_another_ag;
> -	}
>  	/* Can't fail, the space was reserved. */
>  	ASSERT(args.fsbno != NULLFSBLOCK);
>  	ASSERT(args.len == 1);
> diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
> index fd55db479385..3e17ceda038c 100644
> --- a/fs/xfs/libxfs/xfs_bmap_btree.c
> +++ b/fs/xfs/libxfs/xfs_bmap_btree.c
> @@ -448,7 +448,6 @@ xfs_bmbt_alloc_block(
>  	if (args.fsbno == NULLFSBLOCK) {
>  		args.fsbno = be64_to_cpu(start->l);
>  		args.type = XFS_ALLOCTYPE_START_BNO;
> -try_another_ag:
>  		/*
>  		 * Make sure there is sufficient room left in the AG to
>  		 * complete a full tree split for an extent insert.  If
> @@ -477,22 +476,6 @@ xfs_bmbt_alloc_block(
>  	if (error)
>  		goto error0;
>  
> -	/*
> -	 * During a CoW operation, the allocation and bmbt updates occur in
> -	 * different transactions.  The mapping code tries to put new bmbt
> -	 * blocks near extents being mapped, but the only way to guarantee this
> -	 * is if the alloc and the mapping happen in a single transaction that
> -	 * has a block reservation.  That isn't the case here, so if we run out
> -	 * of space we'll try again with another AG.
> -	 */
> -	if (xfs_sb_version_hasreflink(&cur->bc_mp->m_sb) &&
> -	    args.fsbno == NULLFSBLOCK &&
> -	    args.type == XFS_ALLOCTYPE_NEAR_BNO) {
> -		args.fsbno = cur->bc_private.b.firstblock;
> -		args.type = XFS_ALLOCTYPE_FIRST_AG;
> -		goto try_another_ag;
> -	}
> -
>  	if (args.fsbno == NULLFSBLOCK && args.minleft) {
>  		/*
>  		 * Could not find an AG with enough free space to satisfy
> -- 
> 2.11.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
