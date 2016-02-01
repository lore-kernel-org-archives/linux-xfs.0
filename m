Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 562527CB1
	for <xfs@oss.sgi.com>; Mon,  1 Feb 2016 09:02:51 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2B8478F8033
	for <xfs@oss.sgi.com>; Mon,  1 Feb 2016 07:02:48 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Hx3Cui2BYUDwBP4j (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 01 Feb 2016 07:02:44 -0800 (PST)
Date: Mon, 1 Feb 2016 10:17:56 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/5] libxfs: refactor the btree size calculator code
Message-ID: <20160201151755.GB3992@bfoster.bfoster>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs@oss.sgi.com

On Fri, Jan 22, 2016 at 04:35:08PM -0800, Darrick J. Wong wrote:
> Create a macro to generate btree height calculator functions.
> This will be used (much) later when we get to the refcount
> btree.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

The refactoring looks fine to me... though shouldn't this head into the
kernel first and get backported to xfsprogs (or did I miss that
somewhere)?

That and one question below...

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

We go from xfs_filblks_t to unsigned long here. Isn't the latter 4 bytes
on 32-bit systems? Was that intentional?

Brian

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
