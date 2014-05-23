Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5C24A7F3F
	for <xfs@oss.sgi.com>; Fri, 23 May 2014 12:51:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 385B28F8040
	for <xfs@oss.sgi.com>; Fri, 23 May 2014 10:51:20 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id TjewJiJ9YMYvaoIp for
	<xfs@oss.sgi.com>; Fri, 23 May 2014 10:51:18 -0700 (PDT)
Date: Fri, 23 May 2014 13:51:07 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: kill xfs_buf_geterror()
Message-ID: <20140523175106.GA8343@laptop.bfoster>
References: <1400802807-19936-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1400802807-19936-1-git-send-email-david@fromorbit.com>
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

On Fri, May 23, 2014 at 09:53:27AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Most of the callers are just calling ASSERT(!xfs_buf_geterror())
> which means they are checking for bp->b_error == 0. If bp is null in
> this case, we will assert fail, and hence it's no different in
> result to oopsing because of a null bp. In some cases, errors have
> already been checked for or the function returning the buffer can't
> return a buffer with an error, so it's just a redundant assert.
> Either way, the assert can either be removed.
> 
> The other two non-assert callers can just test for a buffer and
> error properly.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

Looks good to me.

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_alloc.c    |  1 -
>  fs/xfs/xfs_btree.c    | 12 ++----------
>  fs/xfs/xfs_buf.h      |  5 -----
>  fs/xfs/xfs_buf_item.c |  2 +-
>  fs/xfs/xfs_dquot.c    |  6 +++---
>  fs/xfs/xfs_ialloc.c   |  1 -
>  fs/xfs/xfs_log.c      |  2 +-
>  fs/xfs/xfs_rtbitmap.c |  1 -
>  8 files changed, 7 insertions(+), 23 deletions(-)
> 
> diff --git a/fs/xfs/xfs_alloc.c b/fs/xfs/xfs_alloc.c
> index c1cf6a3..077c3417 100644
> --- a/fs/xfs/xfs_alloc.c
> +++ b/fs/xfs/xfs_alloc.c
> @@ -541,7 +541,6 @@ xfs_alloc_read_agfl(
>  			XFS_FSS_TO_BB(mp, 1), 0, &bp, &xfs_agfl_buf_ops);
>  	if (error)
>  		return error;
> -	ASSERT(!xfs_buf_geterror(bp));
>  	xfs_buf_set_ref(bp, XFS_AGFL_REF);
>  	*bpp = bp;
>  	return 0;
> diff --git a/fs/xfs/xfs_btree.c b/fs/xfs/xfs_btree.c
> index 182bac2..bf810c6 100644
> --- a/fs/xfs/xfs_btree.c
> +++ b/fs/xfs/xfs_btree.c
> @@ -553,14 +553,11 @@ xfs_btree_get_bufl(
>  	xfs_fsblock_t	fsbno,		/* file system block number */
>  	uint		lock)		/* lock flags for get_buf */
>  {
> -	xfs_buf_t	*bp;		/* buffer pointer (return value) */
>  	xfs_daddr_t		d;		/* real disk block address */
>  
>  	ASSERT(fsbno != NULLFSBLOCK);
>  	d = XFS_FSB_TO_DADDR(mp, fsbno);
> -	bp = xfs_trans_get_buf(tp, mp->m_ddev_targp, d, mp->m_bsize, lock);
> -	ASSERT(!xfs_buf_geterror(bp));
> -	return bp;
> +	return xfs_trans_get_buf(tp, mp->m_ddev_targp, d, mp->m_bsize, lock);
>  }
>  
>  /*
> @@ -575,15 +572,12 @@ xfs_btree_get_bufs(
>  	xfs_agblock_t	agbno,		/* allocation group block number */
>  	uint		lock)		/* lock flags for get_buf */
>  {
> -	xfs_buf_t	*bp;		/* buffer pointer (return value) */
>  	xfs_daddr_t		d;		/* real disk block address */
>  
>  	ASSERT(agno != NULLAGNUMBER);
>  	ASSERT(agbno != NULLAGBLOCK);
>  	d = XFS_AGB_TO_DADDR(mp, agno, agbno);
> -	bp = xfs_trans_get_buf(tp, mp->m_ddev_targp, d, mp->m_bsize, lock);
> -	ASSERT(!xfs_buf_geterror(bp));
> -	return bp;
> +	return xfs_trans_get_buf(tp, mp->m_ddev_targp, d, mp->m_bsize, lock);
>  }
>  
>  /*
> @@ -723,7 +717,6 @@ xfs_btree_read_bufl(
>  				   mp->m_bsize, lock, &bp, ops);
>  	if (error)
>  		return error;
> -	ASSERT(!xfs_buf_geterror(bp));
>  	if (bp)
>  		xfs_buf_set_ref(bp, refval);
>  	*bpp = bp;
> @@ -1179,7 +1172,6 @@ xfs_btree_read_buf_block(
>  	if (error)
>  		return error;
>  
> -	ASSERT(!xfs_buf_geterror(*bpp));
>  	xfs_btree_set_refs(cur, *bpp);
>  	*block = XFS_BUF_TO_BLOCK(*bpp);
>  	return 0;
> diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
> index 0e47fd1..3a7a552 100644
> --- a/fs/xfs/xfs_buf.h
> +++ b/fs/xfs/xfs_buf.h
> @@ -298,11 +298,6 @@ extern void xfs_buf_iomove(xfs_buf_t *, size_t, size_t, void *,
>  
>  extern int xfs_bioerror_relse(struct xfs_buf *);
>  
> -static inline int xfs_buf_geterror(xfs_buf_t *bp)
> -{
> -	return bp ? bp->b_error : ENOMEM;
> -}
> -
>  /* Buffer Utility Routines */
>  extern xfs_caddr_t xfs_buf_offset(xfs_buf_t *, size_t);
>  
> diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> index 64b17f5..4654338 100644
> --- a/fs/xfs/xfs_buf_item.c
> +++ b/fs/xfs/xfs_buf_item.c
> @@ -1052,7 +1052,7 @@ xfs_buf_iodone_callbacks(
>  	static ulong		lasttime;
>  	static xfs_buftarg_t	*lasttarg;
>  
> -	if (likely(!xfs_buf_geterror(bp)))
> +	if (likely(!bp->b_error))
>  		goto do_callbacks;
>  
>  	/*
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index 5fec738..3ee0cd4 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -353,10 +353,10 @@ xfs_qm_dqalloc(
>  			       dqp->q_blkno,
>  			       mp->m_quotainfo->qi_dqchunklen,
>  			       0);
> -
> -	error = xfs_buf_geterror(bp);
> -	if (error)
> +	if (!bp) {
> +		error = ENOMEM;
>  		goto error1;
> +	}
>  	bp->b_ops = &xfs_dquot_buf_ops;
>  
>  	/*
> diff --git a/fs/xfs/xfs_ialloc.c b/fs/xfs/xfs_ialloc.c
> index e8dfaf0..5960e55 100644
> --- a/fs/xfs/xfs_ialloc.c
> +++ b/fs/xfs/xfs_ialloc.c
> @@ -2129,7 +2129,6 @@ xfs_read_agi(
>  	if (error)
>  		return error;
>  
> -	ASSERT(!xfs_buf_geterror(*bpp));
>  	xfs_buf_set_ref(*bpp, XFS_AGI_REF);
>  	return 0;
>  }
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 3554098..292308d 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -1165,7 +1165,7 @@ xlog_iodone(xfs_buf_t *bp)
>  	/*
>  	 * Race to shutdown the filesystem if we see an error.
>  	 */
> -	if (XFS_TEST_ERROR((xfs_buf_geterror(bp)), l->l_mp,
> +	if (XFS_TEST_ERROR(bp->b_error, l->l_mp,
>  			XFS_ERRTAG_IODONE_IOERR, XFS_RANDOM_IODONE_IOERR)) {
>  		xfs_buf_ioerror_alert(bp, __func__);
>  		xfs_buf_stale(bp);
> diff --git a/fs/xfs/xfs_rtbitmap.c b/fs/xfs/xfs_rtbitmap.c
> index b1f2fe8..f4dd697 100644
> --- a/fs/xfs/xfs_rtbitmap.c
> +++ b/fs/xfs/xfs_rtbitmap.c
> @@ -74,7 +74,6 @@ xfs_rtbuf_get(
>  				   mp->m_bsize, 0, &bp, NULL);
>  	if (error)
>  		return error;
> -	ASSERT(!xfs_buf_geterror(bp));
>  	*bpp = bp;
>  	return 0;
>  }
> -- 
> 1.9.0
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
