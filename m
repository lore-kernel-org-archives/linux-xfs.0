Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:23794 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752807AbdDQTic (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Apr 2017 15:38:32 -0400
Date: Mon, 17 Apr 2017 12:37:56 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: reserve enough blocks to handle btree splits when
 remapping
Message-ID: <20170417193756.GB5193@birch.djwong.org>
References: <20170412214852.GR8502@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170412214852.GR8502@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>

On Wed, Apr 12, 2017 at 02:48:52PM -0700, Darrick J. Wong wrote:
> In xfs_reflink_end_cow, we erroneously reserve only enough blocks to
> handle adding 1 extent.  This is problematic if we fragment free space,
> have to do CoW, and then have to perform multiple bmap btree expansions.
> Furthermore, the BUI recovery routine doesn't reserve /any/ blocks to
> handle btree splits, so log recovery fails after our first error causes
> the filesystem to go down.
> 
> Therefore, refactor the transaction block reservation macros until we
> have a macro that works for our deferred (re)mapping activities, and fix
> both problems by using that macro.
> 
> With 1k blocks we can hit this fairly often in g/187 if the scratch fs
> is big enough.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_trans_space.h |   18 ++++++++++++------
>  fs/xfs/xfs_bmap_item.c          |    7 ++++++-
>  fs/xfs/xfs_reflink.c            |    3 ++-
>  3 files changed, 20 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_trans_space.h b/fs/xfs/libxfs/xfs_trans_space.h
> index 7917f6e..04278cf 100644
> --- a/fs/xfs/libxfs/xfs_trans_space.h
> +++ b/fs/xfs/libxfs/xfs_trans_space.h
> @@ -23,6 +23,16 @@
>   */
>  #define XFS_MAX_CONTIG_RMAPS_PER_BLOCK(mp)    \
>  		(((mp)->m_rmap_mxr[0]) - ((mp)->m_rmap_mnr[0]))
> +static inline unsigned int
> +XFS_RMAPADD_SPACE_RES(
> +	struct xfs_mount	*mp)
> +{
> +	return xfs_sb_version_hasrmapbt(&mp->m_sb) ? mp->m_rmap_maxlevels : 0;
> +}
> +#define XFS_NRMAPADD_SPACE_RES(mp,b,w)\
> +	(((b + XFS_MAX_CONTIG_RMAPS_PER_BLOCK(mp) - 1) / \
> +	  XFS_MAX_CONTIG_RMAPS_PER_BLOCK(mp)) * \
> +	  XFS_RMAPADD_SPACE_RES(mp))
>  #define XFS_MAX_CONTIG_EXTENTS_PER_BLOCK(mp)    \
>  		(((mp)->m_alloc_mxr[0]) - ((mp)->m_alloc_mnr[0]))
>  #define	XFS_EXTENTADD_SPACE_RES(mp,w)	(XFS_BM_MAXLEVELS(mp,w) - 1)
> @@ -31,12 +41,8 @@
>  	  XFS_MAX_CONTIG_EXTENTS_PER_BLOCK(mp)) * \
>  	  XFS_EXTENTADD_SPACE_RES(mp,w))
>  #define XFS_SWAP_RMAP_SPACE_RES(mp,b,w)\
> -	(((b + XFS_MAX_CONTIG_EXTENTS_PER_BLOCK(mp) - 1) / \
> -	  XFS_MAX_CONTIG_EXTENTS_PER_BLOCK(mp)) * \
> -	  XFS_EXTENTADD_SPACE_RES(mp,w) + \
> -	 ((b + XFS_MAX_CONTIG_RMAPS_PER_BLOCK(mp) - 1) / \
> -	  XFS_MAX_CONTIG_RMAPS_PER_BLOCK(mp)) * \
> -	  (mp)->m_rmap_maxlevels)
> +	(XFS_NEXTENTADD_SPACE_RES((mp), (b), (w)) + \
> +	 XFS_NRMAPADD_SPACE_RES((mp), (b), (w)))
>  #define	XFS_DAENTER_1B(mp,w)	\
>  	((w) == XFS_DATA_FORK ? (mp)->m_dir_geo->fsbcount : 1)
>  #define	XFS_DAENTER_DBS(mp,w)	\
> diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
> index 9bf57c7..055ab8f 100644
> --- a/fs/xfs/xfs_bmap_item.c
> +++ b/fs/xfs/xfs_bmap_item.c
> @@ -34,6 +34,8 @@
>  #include "xfs_bmap.h"
>  #include "xfs_icache.h"
>  #include "xfs_trace.h"
> +#include "xfs_bmap_btree.h"
> +#include "xfs_trans_space.h"
>  
>  
>  kmem_zone_t	*xfs_bui_zone;
> @@ -402,6 +404,7 @@ xfs_bui_recover(
>  	struct xfs_inode		*ip = NULL;
>  	struct xfs_defer_ops		dfops;
>  	xfs_fsblock_t			firstfsb;
> +	unsigned int			resblks;
>  
>  	ASSERT(!test_bit(XFS_BUI_RECOVERED, &buip->bui_flags));
>  
> @@ -446,7 +449,9 @@ xfs_bui_recover(
>  		return -EIO;
>  	}
>  
> -	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, 0, 0, 0, &tp);
> +	resblks = XFS_SWAP_RMAP_SPACE_RES(mp, 1, XFS_DATA_FORK);
> +	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, resblks, 0,
> +			0, &tp);
>  	if (error)
>  		return error;
>  	budp = xfs_trans_get_bud(tp, buip);
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index c0f3754..b811742 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -706,7 +706,8 @@ xfs_reflink_end_cow(
>  	end_fsb = XFS_B_TO_FSB(ip->i_mount, offset + count);
>  
>  	/* Start a rolling transaction to switch the mappings */
> -	resblks = XFS_EXTENTADD_SPACE_RES(ip->i_mount, XFS_DATA_FORK);
> +	resblks = XFS_SWAP_RMAP_SPACE_RES(ip->i_mount,
> +			end_fsb - offset_fsb + 1, XFS_DATA_FORK);

I forgot that (end_fsb - offset_fsb + 1) is a 64-bit quantity, so this
patch breaks the build on 32-bit systems.  Assuming that we're unlikely
ever to need to remap 16T of single-block extents, we could just clamp
the worst case extent count to 2^32-1 and throw in a warning in case
this assumption ever gets violated...

--D

>  	error = xfs_trans_alloc(ip->i_mount, &M_RES(ip->i_mount)->tr_write,
>  			resblks, 0, 0, &tp);
>  	if (error)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
