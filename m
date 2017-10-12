Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:12457 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751053AbdJLF3J (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Oct 2017 01:29:09 -0400
Date: Thu, 12 Oct 2017 16:28:52 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 02/30] xfs: create block pointer check functions
Message-ID: <20171012052852.GQ15067@dastard>
References: <150777244315.1724.6916081372861799350.stgit@magnolia>
 <150777245581.1724.14031376814151145502.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <150777245581.1724.14031376814151145502.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Oct 11, 2017 at 06:40:55PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Create some helper functions to check that a block pointer points
> within the filesystem (or AG) and doesn't point at static metadata.
> We will use this for scrub.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Look fine

Reviewed-by: Dave Chinner <dchinner@redhat.com>

> ---
>  fs/xfs/libxfs/xfs_alloc.c    |   49 ++++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/libxfs/xfs_alloc.h    |    4 +++
>  fs/xfs/libxfs/xfs_rtbitmap.c |   12 ++++++++++
>  fs/xfs/xfs_rtalloc.h         |    2 ++
>  4 files changed, 67 insertions(+)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index 744dcae..bd3a943 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -2923,3 +2923,52 @@ xfs_alloc_query_all(
>  	query.fn = fn;
>  	return xfs_btree_query_all(cur, xfs_alloc_query_range_helper, &query);
>  }
> +
> +/* Find the size of the AG, in blocks. */
> +xfs_agblock_t
> +xfs_ag_block_count(
> +	struct xfs_mount	*mp,
> +	xfs_agnumber_t		agno)
> +{
> +	ASSERT(agno < mp->m_sb.sb_agcount);
> +
> +	if (agno < mp->m_sb.sb_agcount - 1)
> +		return mp->m_sb.sb_agblocks;
> +	return mp->m_sb.sb_dblocks - (agno * mp->m_sb.sb_agblocks);
> +}
> +
> +/*
> + * Verify that an AG block number pointer neither points outside the AG
> + * nor points at static metadata.
> + */
> +bool
> +xfs_verify_agbno_ptr(
> +	struct xfs_mount	*mp,
> +	xfs_agnumber_t		agno,
> +	xfs_agblock_t		agbno)
> +{
> +	xfs_agblock_t		eoag;
> +
> +	eoag = xfs_ag_block_count(mp, agno);
> +	if (agbno >= eoag)
> +		return false;
> +	if (agbno <= XFS_AGFL_BLOCK(mp))
> +		return false;
> +	return true;
> +}
> +
> +/*
> + * Verify that an FS block number pointer neither points outside the
> + * filesystem nor points at static AG metadata.
> + */
> +bool
> +xfs_verify_fsbno_ptr(
> +	struct xfs_mount	*mp,
> +	xfs_fsblock_t		fsbno)
> +{
> +	xfs_agnumber_t		agno = XFS_FSB_TO_AGNO(mp, fsbno);
> +
> +	if (agno >= mp->m_sb.sb_agcount)
> +		return false;
> +	return xfs_verify_agbno_ptr(mp, agno, XFS_FSB_TO_AGBNO(mp, fsbno));
> +}
> diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
> index ef26edc..3185807 100644
> --- a/fs/xfs/libxfs/xfs_alloc.h
> +++ b/fs/xfs/libxfs/xfs_alloc.h
> @@ -232,5 +232,9 @@ int xfs_alloc_query_range(struct xfs_btree_cur *cur,
>  		xfs_alloc_query_range_fn fn, void *priv);
>  int xfs_alloc_query_all(struct xfs_btree_cur *cur, xfs_alloc_query_range_fn fn,
>  		void *priv);
> +xfs_agblock_t xfs_ag_block_count(struct xfs_mount *mp, xfs_agnumber_t agno);
> +bool xfs_verify_agbno_ptr(struct xfs_mount *mp, xfs_agnumber_t agno,
> +		xfs_agblock_t agbno);
> +bool xfs_verify_fsbno_ptr(struct xfs_mount *mp, xfs_fsblock_t fsbno);
>  
>  #endif	/* __XFS_ALLOC_H__ */
> diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
> index 5d4e43e..0a49348 100644
> --- a/fs/xfs/libxfs/xfs_rtbitmap.c
> +++ b/fs/xfs/libxfs/xfs_rtbitmap.c
> @@ -1086,3 +1086,15 @@ xfs_rtalloc_query_all(
>  
>  	return xfs_rtalloc_query_range(tp, &keys[0], &keys[1], fn, priv);
>  }
> +
> +/*
> + * Verify that an realtime block number pointer doesn't point off the
> + * end of the realtime device.
> + */
> +bool
> +xfs_verify_rtbno_ptr(
> +	struct xfs_mount	*mp,
> +	xfs_rtblock_t		rtbno)
> +{
> +	return rtbno < mp->m_sb.sb_rblocks;
> +}
> diff --git a/fs/xfs/xfs_rtalloc.h b/fs/xfs/xfs_rtalloc.h
> index 79defa7..11b8554 100644
> --- a/fs/xfs/xfs_rtalloc.h
> +++ b/fs/xfs/xfs_rtalloc.h
> @@ -138,6 +138,7 @@ int xfs_rtalloc_query_range(struct xfs_trans *tp,
>  int xfs_rtalloc_query_all(struct xfs_trans *tp,
>  			  xfs_rtalloc_query_range_fn fn,
>  			  void *priv);
> +bool xfs_verify_rtbno_ptr(struct xfs_mount *mp, xfs_rtblock_t rtbno);
>  #else
>  # define xfs_rtallocate_extent(t,b,min,max,l,f,p,rb)    (ENOSYS)
>  # define xfs_rtfree_extent(t,b,l)                       (ENOSYS)
> @@ -146,6 +147,7 @@ int xfs_rtalloc_query_all(struct xfs_trans *tp,
>  # define xfs_rtalloc_query_range(t,l,h,f,p)             (ENOSYS)
>  # define xfs_rtalloc_query_all(t,f,p)                   (ENOSYS)
>  # define xfs_rtbuf_get(m,t,b,i,p)                       (ENOSYS)
> +# define xfs_verify_rtbno_ptr(m, r)			(false)
>  static inline int		/* error */
>  xfs_rtmount_init(
>  	xfs_mount_t	*mp)	/* file system mount structure */
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
Dave Chinner
david@fromorbit.com
