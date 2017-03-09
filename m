Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:49367 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751313AbdCIE4p (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Mar 2017 23:56:45 -0500
Date: Wed, 8 Mar 2017 20:56:36 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2] xfs: try any AG when allocating the first btree block
 when reflinking
Message-ID: <20170309045636.GS5280@birch.djwong.org>
References: <20170308180239.27452-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170308180239.27452-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Wed, Mar 08, 2017 at 10:02:39AM -0800, Christoph Hellwig wrote:
> When a reflink operation causes the bmap code to allocate a btree block
> we're currently doing single-AG allocations due to having ->firstblock
> set and then try any higher AG due a little reflink quirk we've put in
> when adding the reflink code.  But given that we do not have a minleft
> reservation of any kind in this AG we can still not have any space in
> the same or higher AG even if the file system has enough free space.
> To fix this use a XFS_ALLOCTYPE_FIRST_AG allocation in this fall back
> path instead.
> 
> [And yes, we need to redo this properly instead of piling hacks over
>  hacks.  I'm working on that, but it's not going to be a small series.
>  In the meantime this fixes the customer reported issue]
> 
> Also add a warning for failing allocations to make it easier to debug.

Looks good, tests ok;
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_bmap.c       | 10 +++++++---
>  fs/xfs/libxfs/xfs_bmap_btree.c |  6 +++---
>  2 files changed, 10 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index a9c66d47757a..fd7ccc10d244 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -763,8 +763,8 @@ xfs_bmap_extents_to_btree(
>  		args.type = XFS_ALLOCTYPE_START_BNO;
>  		args.fsbno = XFS_INO_TO_FSB(mp, ip->i_ino);
>  	} else if (dfops->dop_low) {
> -try_another_ag:
>  		args.type = XFS_ALLOCTYPE_START_BNO;
> +try_another_ag:
>  		args.fsbno = *firstblock;
>  	} else {
>  		args.type = XFS_ALLOCTYPE_NEAR_BNO;
> @@ -790,13 +790,17 @@ xfs_bmap_extents_to_btree(
>  	if (xfs_sb_version_hasreflink(&cur->bc_mp->m_sb) &&
>  	    args.fsbno == NULLFSBLOCK &&
>  	    args.type == XFS_ALLOCTYPE_NEAR_BNO) {
> -		dfops->dop_low = true;
> +		args.type = XFS_ALLOCTYPE_FIRST_AG;
>  		goto try_another_ag;
>  	}
> +	if (WARN_ON_ONCE(args.fsbno == NULLFSBLOCK)) {
> +		xfs_iroot_realloc(ip, -1, whichfork);
> +		xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
> +		return -ENOSPC;
> +	}
>  	/*
>  	 * Allocation can't fail, the space was reserved.
>  	 */
> -	ASSERT(args.fsbno != NULLFSBLOCK);
>  	ASSERT(*firstblock == NULLFSBLOCK ||
>  	       args.agno >= XFS_FSB_TO_AGNO(mp, *firstblock));
>  	*firstblock = cur->bc_private.b.firstblock = args.fsbno;
> diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
> index f93072b58a58..fd55db479385 100644
> --- a/fs/xfs/libxfs/xfs_bmap_btree.c
> +++ b/fs/xfs/libxfs/xfs_bmap_btree.c
> @@ -447,8 +447,8 @@ xfs_bmbt_alloc_block(
>  
>  	if (args.fsbno == NULLFSBLOCK) {
>  		args.fsbno = be64_to_cpu(start->l);
> -try_another_ag:
>  		args.type = XFS_ALLOCTYPE_START_BNO;
> +try_another_ag:
>  		/*
>  		 * Make sure there is sufficient room left in the AG to
>  		 * complete a full tree split for an extent insert.  If
> @@ -488,8 +488,8 @@ xfs_bmbt_alloc_block(
>  	if (xfs_sb_version_hasreflink(&cur->bc_mp->m_sb) &&
>  	    args.fsbno == NULLFSBLOCK &&
>  	    args.type == XFS_ALLOCTYPE_NEAR_BNO) {
> -		cur->bc_private.b.dfops->dop_low = true;
>  		args.fsbno = cur->bc_private.b.firstblock;
> +		args.type = XFS_ALLOCTYPE_FIRST_AG;
>  		goto try_another_ag;
>  	}
>  
> @@ -506,7 +506,7 @@ xfs_bmbt_alloc_block(
>  			goto error0;
>  		cur->bc_private.b.dfops->dop_low = true;
>  	}
> -	if (args.fsbno == NULLFSBLOCK) {
> +	if (WARN_ON_ONCE(args.fsbno == NULLFSBLOCK)) {
>  		XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
>  		*stat = 0;
>  		return 0;
> -- 
> 2.11.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
