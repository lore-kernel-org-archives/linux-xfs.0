Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4ACA97F5D
	for <xfs@oss.sgi.com>; Mon, 15 Jun 2015 09:58:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B9208AC001
	for <xfs@oss.sgi.com>; Mon, 15 Jun 2015 07:58:22 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id K8St0HsvIkyUHTjD (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 15 Jun 2015 07:58:21 -0700 (PDT)
Date: Mon, 15 Jun 2015 10:58:19 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 04/20] xfs: clean up XFS_MIN_FREELIST macros
Message-ID: <20150615145819.GD36091@bfoster.bfoster>
References: <1433311497-10245-1-git-send-email-david@fromorbit.com>
	<1433311497-10245-5-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1433311497-10245-5-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Wed, Jun 03, 2015 at 04:04:41PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> We no longer calculate the minimum freelist size from the on-disk
> AGF, so we don't need the macros used for this. That means the
> nested macros can be cleaned up, and turn this into an actual
> function so the logic is clear and concise. This will make it much
> easier to add support for the rmap btree when the time comes.
> 
> This also gets rid of the XFS_AG_MAXLEVELS macro used by these
> freelist macros as it is simply a wrapper around a single variable.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_alloc.c       | 22 +++++++++++++++++++---
>  fs/xfs/libxfs/xfs_alloc.h       |  2 ++
>  fs/xfs/libxfs/xfs_bmap.c        |  2 +-
>  fs/xfs/libxfs/xfs_format.h      | 13 -------------
>  fs/xfs/libxfs/xfs_trans_resv.h  |  4 ++--
>  fs/xfs/libxfs/xfs_trans_space.h |  2 +-
>  fs/xfs/xfs_filestream.c         |  2 +-
>  7 files changed, 26 insertions(+), 21 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index 352db46..d4aa844 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -1870,6 +1870,23 @@ xfs_alloc_longest_free_extent(
>  	return pag->pagf_flcount > 0 || pag->pagf_longest > 0;
>  }
>  
> +unsigned int
> +xfs_alloc_min_freelist(
> +	struct xfs_mount	*mp,
> +	struct xfs_perag	*pag)
> +{
> +	unsigned int		min_free;
> +
> +	/* space needed by-bno freespace btree */
> +	min_free = min_t(unsigned int, pag->pagf_levels[XFS_BTNUM_BNOi] + 1,
> +				       mp->m_ag_maxlevels);
> +	/* space needed by-size freespace btree */
> +	min_free += min_t(unsigned int, pag->pagf_levels[XFS_BTNUM_CNTi] + 1,
> +				       mp->m_ag_maxlevels);
> +
> +	return min_free;
> +}
> +
>  /*
>   * Check if the operation we are fixing up the freelist for should go ahead or
>   * not. If we are freeing blocks, we always allow it, otherwise the allocation
> @@ -1944,7 +1961,7 @@ xfs_alloc_fix_freelist(
>  		goto out_agbp_relse;
>  	}
>  
> -	need = XFS_MIN_FREELIST_PAG(pag, mp);
> +	need = xfs_alloc_min_freelist(mp, pag);
>  	if (!xfs_alloc_space_available(args, need, flags))
>  		goto out_agbp_relse;
>  
> @@ -1963,9 +1980,8 @@ xfs_alloc_fix_freelist(
>  		}
>  	}
>  
> -
>  	/* If there isn't enough total space or single-extent, reject it. */
> -	need = XFS_MIN_FREELIST_PAG(pag, mp);
> +	need = xfs_alloc_min_freelist(mp, pag);
>  	if (!xfs_alloc_space_available(args, need, flags))
>  		goto out_agbp_relse;
>  
> diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
> index a4d3b9a..ca1c816 100644
> --- a/fs/xfs/libxfs/xfs_alloc.h
> +++ b/fs/xfs/libxfs/xfs_alloc.h
> @@ -132,6 +132,8 @@ typedef struct xfs_alloc_arg {
>  
>  xfs_extlen_t xfs_alloc_longest_free_extent(struct xfs_mount *mp,
>  		struct xfs_perag *pag, xfs_extlen_t need);
> +unsigned int xfs_alloc_min_freelist(struct xfs_mount *mp,
> +		struct xfs_perag *pag);
>  
>  /*
>   * Compute and fill in value of m_ag_maxlevels.
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 7382cce..983a5d0 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -3522,7 +3522,7 @@ xfs_bmap_longest_free_extent(
>  	}
>  
>  	longest = xfs_alloc_longest_free_extent(mp, pag,
> -						XFS_MIN_FREELIST_PAG(pag, mp));
> +					xfs_alloc_min_freelist(mp, pag));
>  	if (*blen < longest)
>  		*blen = longest;
>  
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index 815f61b..a0ae572 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -766,19 +766,6 @@ typedef struct xfs_agfl {
>  
>  #define XFS_AGFL_CRC_OFF	offsetof(struct xfs_agfl, agfl_crc)
>  
> -
> -#define	XFS_AG_MAXLEVELS(mp)		((mp)->m_ag_maxlevels)
> -#define	XFS_MIN_FREELIST_RAW(bl,cl,mp)	\
> -	(MIN(bl + 1, XFS_AG_MAXLEVELS(mp)) + MIN(cl + 1, XFS_AG_MAXLEVELS(mp)))
> -#define	XFS_MIN_FREELIST(a,mp)		\
> -	(XFS_MIN_FREELIST_RAW(		\
> -		be32_to_cpu((a)->agf_levels[XFS_BTNUM_BNOi]), \
> -		be32_to_cpu((a)->agf_levels[XFS_BTNUM_CNTi]), mp))
> -#define	XFS_MIN_FREELIST_PAG(pag,mp)	\
> -	(XFS_MIN_FREELIST_RAW(		\
> -		(unsigned int)(pag)->pagf_levels[XFS_BTNUM_BNOi], \
> -		(unsigned int)(pag)->pagf_levels[XFS_BTNUM_CNTi], mp))
> -
>  #define XFS_AGB_TO_FSB(mp,agno,agbno)	\
>  	(((xfs_fsblock_t)(agno) << (mp)->m_sb.sb_agblklog) | (agbno))
>  #define	XFS_FSB_TO_AGNO(mp,fsbno)	\
> diff --git a/fs/xfs/libxfs/xfs_trans_resv.h b/fs/xfs/libxfs/xfs_trans_resv.h
> index 2d5bdfc..7978150 100644
> --- a/fs/xfs/libxfs/xfs_trans_resv.h
> +++ b/fs/xfs/libxfs/xfs_trans_resv.h
> @@ -73,9 +73,9 @@ struct xfs_trans_resv {
>   * 2 trees * (2 blocks/level * max depth - 1) * block size
>   */
>  #define	XFS_ALLOCFREE_LOG_RES(mp,nx) \
> -	((nx) * (2 * XFS_FSB_TO_B((mp), 2 * XFS_AG_MAXLEVELS(mp) - 1)))
> +	((nx) * (2 * XFS_FSB_TO_B((mp), 2 * (mp)->m_ag_maxlevels - 1)))
>  #define	XFS_ALLOCFREE_LOG_COUNT(mp,nx) \
> -	((nx) * (2 * (2 * XFS_AG_MAXLEVELS(mp) - 1)))
> +	((nx) * (2 * (2 * (mp)->m_ag_maxlevels - 1)))
>  
>  /*
>   * Per-directory log reservation for any directory change.
> diff --git a/fs/xfs/libxfs/xfs_trans_space.h b/fs/xfs/libxfs/xfs_trans_space.h
> index bf9c457..41e0428 100644
> --- a/fs/xfs/libxfs/xfs_trans_space.h
> +++ b/fs/xfs/libxfs/xfs_trans_space.h
> @@ -67,7 +67,7 @@
>  #define	XFS_DIOSTRAT_SPACE_RES(mp, v)	\
>  	(XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK) + (v))
>  #define	XFS_GROWFS_SPACE_RES(mp)	\
> -	(2 * XFS_AG_MAXLEVELS(mp))
> +	(2 * (mp)->m_ag_maxlevels)
>  #define	XFS_GROWFSRT_SPACE_RES(mp,b)	\
>  	((b) + XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK))
>  #define	XFS_LINK_SPACE_RES(mp,nl)	\
> diff --git a/fs/xfs/xfs_filestream.c b/fs/xfs/xfs_filestream.c
> index 9ac5eaa..c4c130f 100644
> --- a/fs/xfs/xfs_filestream.c
> +++ b/fs/xfs/xfs_filestream.c
> @@ -197,7 +197,7 @@ xfs_filestream_pick_ag(
>  		}
>  
>  		longest = xfs_alloc_longest_free_extent(mp, pag,
> -						XFS_MIN_FREELIST_PAG(pag, mp));
> +					xfs_alloc_min_freelist(mp, pag));
>  		if (((minlen && longest >= minlen) ||
>  		     (!minlen && pag->pagf_freeblks >= minfree)) &&
>  		    (!pag->pagf_metadata || !(flags & XFS_PICK_USERDATA) ||
> -- 
> 2.0.0
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
