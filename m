Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:17439 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751236AbdH2SJd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Aug 2017 14:09:33 -0400
Date: Tue, 29 Aug 2017 11:09:28 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/8] xfs: add a xfs_iext_update_extent helper
Message-ID: <20170829180928.GV4757@magnolia>
References: <20170829174835.2218-1-hch@lst.de>
 <20170829174835.2218-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170829174835.2218-2-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Tue, Aug 29, 2017 at 07:48:28PM +0200, Christoph Hellwig wrote:
> This helper is used to update an extent record based on the extent index,
> and can be used to provide a level of abstractions between callers that
> want to modify in-core extent records and the details of the extent list
> implementation.
> 
> Also switch all users of the xfs_bmbt_set_all(xfs_iext_get_ext(...))
> pattern to this new helper.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

> ---
>  fs/xfs/libxfs/xfs_bmap.c       | 12 ++++++------
>  fs/xfs/libxfs/xfs_inode_fork.c | 12 ++++++++++++
>  fs/xfs/libxfs/xfs_inode_fork.h |  2 ++
>  3 files changed, 20 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index c09c16b1ad3b..502f531e4634 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -4918,7 +4918,7 @@ xfs_bmap_del_extent_delay(
>  		da_new = XFS_FILBLKS_MIN(xfs_bmap_worst_indlen(ip,
>  				got->br_blockcount), da_old);
>  		got->br_startblock = nullstartblock((int)da_new);
> -		xfs_bmbt_set_all(xfs_iext_get_ext(ifp, *idx), got);
> +		xfs_iext_update_extent(ifp, *idx, got);
>  		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
>  		break;
>  	case BMAP_RIGHT_CONTIG:
> @@ -4930,7 +4930,7 @@ xfs_bmap_del_extent_delay(
>  		da_new = XFS_FILBLKS_MIN(xfs_bmap_worst_indlen(ip,
>  				got->br_blockcount), da_old);
>  		got->br_startblock = nullstartblock((int)da_new);
> -		xfs_bmbt_set_all(xfs_iext_get_ext(ifp, *idx), got);
> +		xfs_iext_update_extent(ifp, *idx, got);
>  		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
>  		break;
>  	case 0:
> @@ -4956,7 +4956,7 @@ xfs_bmap_del_extent_delay(
>  						       del->br_blockcount);
>  
>  		got->br_startblock = nullstartblock((int)got_indlen);
> -		xfs_bmbt_set_all(xfs_iext_get_ext(ifp, *idx), got);
> +		xfs_iext_update_extent(ifp, *idx, got);
>  		trace_xfs_bmap_post_update(ip, *idx, 0, _THIS_IP_);
>  
>  		new.br_startoff = del_endoff;
> @@ -5026,7 +5026,7 @@ xfs_bmap_del_extent_cow(
>  		got->br_startoff = del_endoff;
>  		got->br_blockcount -= del->br_blockcount;
>  		got->br_startblock = del->br_startblock + del->br_blockcount;
> -		xfs_bmbt_set_all(xfs_iext_get_ext(ifp, *idx), got);
> +		xfs_iext_update_extent(ifp, *idx, got);
>  		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
>  		break;
>  	case BMAP_RIGHT_CONTIG:
> @@ -5035,7 +5035,7 @@ xfs_bmap_del_extent_cow(
>  		 */
>  		trace_xfs_bmap_pre_update(ip, *idx, state, _THIS_IP_);
>  		got->br_blockcount -= del->br_blockcount;
> -		xfs_bmbt_set_all(xfs_iext_get_ext(ifp, *idx), got);
> +		xfs_iext_update_extent(ifp, *idx, got);
>  		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
>  		break;
>  	case 0:
> @@ -5044,7 +5044,7 @@ xfs_bmap_del_extent_cow(
>  		 */
>  		trace_xfs_bmap_pre_update(ip, *idx, state, _THIS_IP_);
>  		got->br_blockcount = del->br_startoff - got->br_startoff;
> -		xfs_bmbt_set_all(xfs_iext_get_ext(ifp, *idx), got);
> +		xfs_iext_update_extent(ifp, *idx, got);
>  		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
>  
>  		new.br_startoff = del_endoff;
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
> index 0e80f34fe97c..fb310d08dc82 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.c
> +++ b/fs/xfs/libxfs/xfs_inode_fork.c
> @@ -2023,3 +2023,15 @@ xfs_iext_get_extent(
>  	xfs_bmbt_get_all(xfs_iext_get_ext(ifp, idx), gotp);
>  	return true;
>  }
> +
> +void
> +xfs_iext_update_extent(
> +	struct xfs_ifork	*ifp,
> +	xfs_extnum_t		idx,
> +	struct xfs_bmbt_irec	*gotp)
> +{
> +	ASSERT(idx >= 0);
> +	ASSERT(idx < xfs_iext_count(ifp));
> +
> +	xfs_bmbt_set_all(xfs_iext_get_ext(ifp, idx), gotp);
> +}
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
> index 7fb8365326d1..11af705219f6 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.h
> +++ b/fs/xfs/libxfs/xfs_inode_fork.h
> @@ -187,6 +187,8 @@ bool		xfs_iext_lookup_extent(struct xfs_inode *ip,
>  			xfs_extnum_t *idxp, struct xfs_bmbt_irec *gotp);
>  bool		xfs_iext_get_extent(struct xfs_ifork *ifp, xfs_extnum_t idx,
>  			struct xfs_bmbt_irec *gotp);
> +void		xfs_iext_update_extent(struct xfs_ifork *ifp, xfs_extnum_t idx,
> +			struct xfs_bmbt_irec *gotp);
>  
>  extern struct kmem_zone	*xfs_ifork_zone;
>  
> -- 
> 2.11.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
