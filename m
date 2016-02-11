Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E94B67CB4
	for <xfs@oss.sgi.com>; Thu, 11 Feb 2016 17:48:16 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D7EAC8F8033
	for <xfs@oss.sgi.com>; Thu, 11 Feb 2016 15:48:16 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id diHLMMhjetcZwcZ0 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 11 Feb 2016 15:48:14 -0800 (PST)
Date: Thu, 11 Feb 2016 15:48:07 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/5] libxfs: refactor the btree size calculator code
Message-ID: <20160211234807.GI6350@birch.djwong.org>
References: <20160123003502.2475.99558.stgit@birch.djwong.org>
	<20160123003508.2475.53723.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160123003508.2475.53723.stgit@birch.djwong.org>
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
To: david@fromorbit.com
Cc: xfs@oss.sgi.com

On Fri, Jan 22, 2016 at 04:35:08PM -0800, Darrick J. Wong wrote:
> Create a macro to generate btree height calculator functions.
> This will be used (much) later when we get to the refcount
> btree.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  libxfs/xfs_bmap.c       |   18 +-----------------
>  libxfs/xfs_bmap_btree.c |    9 +++++++++
>  libxfs/xfs_bmap_btree.h |    3 +++
>  libxfs/xfs_btree.c      |   28 ++++++++++++++++++++++++++++
>  libxfs/xfs_btree.h      |    3 +++
>  5 files changed, 44 insertions(+), 17 deletions(-)
> 
> 
> diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
> index aef7cf3..c134765 100644
> --- a/libxfs/xfs_bmap.c
> +++ b/libxfs/xfs_bmap.c
> @@ -172,25 +172,9 @@ xfs_bmap_worst_indlen(
>  	xfs_inode_t	*ip,		/* incore inode pointer */
>  	xfs_filblks_t	len)		/* delayed extent length */
>  {
> -	int		level;		/* btree level number */
> -	int		maxrecs;	/* maximum record count at this level */
> -	xfs_mount_t	*mp;		/* mount structure */
>  	xfs_filblks_t	rval;		/* return value */
>  
> -	mp = ip->i_mount;
> -	maxrecs = mp->m_bmap_dmxr[0];
> -	for (level = 0, rval = 0;
> -	     level < XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK);
> -	     level++) {
> -		len += maxrecs - 1;
> -		do_div(len, maxrecs);
> -		rval += len;
> -		if (len == 1)
> -			return rval + XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK) -
> -				level - 1;
> -		if (level == 0)
> -			maxrecs = mp->m_bmap_dmxr[1];
> -	}
> +	rval = xfs_bmbt_calc_size(ip->i_mount, len);

NAK.  This function figures out how many blocks could be required to handle
adding (worst-case one-extent-per-block) extents to the bmbt and btree splits
all the way up the tree, whereas xfs_btree_calc_size() merely calculates the
number of blocks needed to create a tree with some number of records.  When I
start using the AG reservation code and counting the number of blocks in use at
mount time, using the below xfs_btree_calc_size() to calculate the resevation
size leads to undersized reservations, which (I think?) explains why I still
occasionally run out of blocks when expanding the refcount tree, which is
supposed to reserve /all/ the blocks it'll ever need.

This function should go back to the way it was, and the xfs_btree_calc_size()
function will get fixed to calculate tree size correctly.

Also NAK on the kernelside version of this patch.

--D

>  	return rval;
>  }
>  
> diff --git a/libxfs/xfs_bmap_btree.c b/libxfs/xfs_bmap_btree.c
> index 2ef1836..3c595e2 100644
> --- a/libxfs/xfs_bmap_btree.c
> +++ b/libxfs/xfs_bmap_btree.c
> @@ -880,3 +880,12 @@ xfs_bmbt_change_owner(
>  	xfs_btree_del_cursor(cur, error ? XFS_BTREE_ERROR : XFS_BTREE_NOERROR);
>  	return error;
>  }
> +
> +xfs_filblks_t
> +xfs_bmbt_calc_size(
> +	struct xfs_mount	*mp,
> +	unsigned long		len)
> +{
> +	return xfs_btree_calc_size(mp, mp->m_bmap_dmxr,
> +			XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK), len);
> +}
> diff --git a/libxfs/xfs_bmap_btree.h b/libxfs/xfs_bmap_btree.h
> index 819a8a4..04bc6e2 100644
> --- a/libxfs/xfs_bmap_btree.h
> +++ b/libxfs/xfs_bmap_btree.h
> @@ -140,4 +140,7 @@ extern int xfs_bmbt_change_owner(struct xfs_trans *tp, struct xfs_inode *ip,
>  extern struct xfs_btree_cur *xfs_bmbt_init_cursor(struct xfs_mount *,
>  		struct xfs_trans *, struct xfs_inode *, int);
>  
> +extern xfs_filblks_t xfs_bmbt_calc_size(struct xfs_mount *mp,
> +		unsigned long len);
> +
>  #endif	/* __XFS_BMAP_BTREE_H__ */
> diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
> index 658f27e..d5f16c5 100644
> --- a/libxfs/xfs_btree.c
> +++ b/libxfs/xfs_btree.c
> @@ -4081,6 +4081,34 @@ xfs_btree_change_owner(
>  	return 0;
>  }
>  
> +/*
> + * xfs_btree_calc_size() -- Calculate the number of blocks needed to store
> + *			    a given number of records.
> + */
> +xfs_filblks_t
> +xfs_btree_calc_size(
> +	struct xfs_mount	*mp,
> +	uint			*limits,
> +	int			maxlevels,
> +	unsigned long		len)
> +{
> +	int			level;
> +	int			maxrecs;
> +	xfs_filblks_t		rval;
> +
> +	maxrecs = limits[0];
> +	for (level = 0, rval = 0; level < maxlevels; level++) {
> +		len += maxrecs - 1;
> +		do_div(len, maxrecs);
> +		rval += len;
> +		if (len == 1)
> +			return rval + maxlevels - level - 1;
> +		if (level == 0)
> +			maxrecs = limits[1];
> +	}
> +	return rval;
> +}
> +
>  /**
>   * xfs_btree_sblock_v5hdr_verify() -- verify the v5 fields of a short-format
>   *				      btree block
> diff --git a/libxfs/xfs_btree.h b/libxfs/xfs_btree.h
> index 48cb251..b25ffd3 100644
> --- a/libxfs/xfs_btree.h
> +++ b/libxfs/xfs_btree.h
> @@ -465,6 +465,9 @@ static inline int xfs_btree_get_level(struct xfs_btree_block *block)
>  #define XFS_BTREE_TRACE_ARGR(c, r)
>  #define	XFS_BTREE_TRACE_CURSOR(c, t)
>  
> +xfs_filblks_t xfs_btree_calc_size(struct xfs_mount *mp, uint *limits,
> +		int maxlevels, unsigned long len);
> +
>  bool xfs_btree_sblock_v5hdr_verify(struct xfs_buf *bp);
>  bool xfs_btree_sblock_verify(struct xfs_buf *bp, unsigned int max_recs);
>  
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
