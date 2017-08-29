Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:40108 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751186AbdH2So0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Aug 2017 14:44:26 -0400
Date: Tue, 29 Aug 2017 11:44:21 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 8/8] xfs: replace xfs_qm_get_rtblks with a direct call to
 xfs_bmap_count_leaves
Message-ID: <20170829184421.GA4757@magnolia>
References: <20170829174835.2218-1-hch@lst.de>
 <20170829174835.2218-9-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170829174835.2218-9-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Tue, Aug 29, 2017 at 07:48:35PM +0200, Christoph Hellwig wrote:
> Use the existing functionality instead of directly poking into the extent
> list.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

> ---
>  fs/xfs/xfs_qm.c | 44 ++++++++++++--------------------------------
>  1 file changed, 12 insertions(+), 32 deletions(-)
> 
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index 15751dc2a27d..010a13a201aa 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -31,6 +31,7 @@
>  #include "xfs_error.h"
>  #include "xfs_bmap.h"
>  #include "xfs_bmap_btree.h"
> +#include "xfs_bmap_util.h"
>  #include "xfs_trans.h"
>  #include "xfs_trans_space.h"
>  #include "xfs_qm.h"
> @@ -1120,31 +1121,6 @@ xfs_qm_quotacheck_dqadjust(
>  	return 0;
>  }
>  
> -STATIC int
> -xfs_qm_get_rtblks(
> -	xfs_inode_t	*ip,
> -	xfs_qcnt_t	*O_rtblks)
> -{
> -	xfs_filblks_t	rtblks;			/* total rt blks */
> -	xfs_extnum_t	idx;			/* extent record index */
> -	xfs_ifork_t	*ifp;			/* inode fork pointer */
> -	xfs_extnum_t	nextents;		/* number of extent entries */
> -	int		error;
> -
> -	ASSERT(XFS_IS_REALTIME_INODE(ip));
> -	ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
> -	if (!(ifp->if_flags & XFS_IFEXTENTS)) {
> -		if ((error = xfs_iread_extents(NULL, ip, XFS_DATA_FORK)))
> -			return error;
> -	}
> -	rtblks = 0;
> -	nextents = xfs_iext_count(ifp);
> -	for (idx = 0; idx < nextents; idx++)
> -		rtblks += xfs_bmbt_get_blockcount(xfs_iext_get_ext(ifp, idx));
> -	*O_rtblks = (xfs_qcnt_t)rtblks;
> -	return 0;
> -}
> -
>  /*
>   * callback routine supplied to bulkstat(). Given an inumber, find its
>   * dquots and update them to account for resources taken by that inode.
> @@ -1160,7 +1136,8 @@ xfs_qm_dqusage_adjust(
>  	int		*res)		/* result code value */
>  {
>  	xfs_inode_t	*ip;
> -	xfs_qcnt_t	nblks, rtblks = 0;
> +	xfs_qcnt_t	nblks;
> +	xfs_filblks_t	rtblks = 0;	/* total rt blks */
>  	int		error;
>  
>  	ASSERT(XFS_IS_QUOTA_RUNNING(mp));
> @@ -1190,12 +1167,15 @@ xfs_qm_dqusage_adjust(
>  	ASSERT(ip->i_delayed_blks == 0);
>  
>  	if (XFS_IS_REALTIME_INODE(ip)) {
> -		/*
> -		 * Walk thru the extent list and count the realtime blocks.
> -		 */
> -		error = xfs_qm_get_rtblks(ip, &rtblks);
> -		if (error)
> -			goto error0;
> +		struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
> +
> +		if (!(ifp->if_flags & XFS_IFEXTENTS)) {
> +			error = xfs_iread_extents(NULL, ip, XFS_DATA_FORK);
> +			if (error)
> +				goto error0;
> +		}
> +
> +		xfs_bmap_count_leaves(ifp, &rtblks);
>  	}
>  
>  	nblks = (xfs_qcnt_t)ip->i_d.di_nblocks - rtblks;
> -- 
> 2.11.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
