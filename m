Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:35240 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933129AbeAKTmW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Jan 2018 14:42:22 -0500
Date: Thu, 11 Jan 2018 11:42:19 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/8] xfs: remove wrappers around b_fspriv
Message-ID: <20180111194219.GA5602@magnolia>
References: <1515699458-6925-1-git-send-email-sandeen@sandeen.net>
 <1515699458-6925-2-git-send-email-sandeen@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1515699458-6925-2-git-send-email-sandeen@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org

On Thu, Jan 11, 2018 at 01:37:31PM -0600, Eric Sandeen wrote:
> From: Christoph Hellwig <hch@lst.de>
> 
> Source kernel commit adadbeefb34f755a3477da51035eeeec2c1fde38
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Alex Elder <aelder@sgi.com>
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
> ---
>  libxfs/libxfs_io.h |  2 --
>  libxfs/logitem.c   |  6 +++---
>  libxfs/trans.c     | 48 +++++++++++++++++++++---------------------------
>  libxfs/util.c      |  2 +-
>  4 files changed, 25 insertions(+), 33 deletions(-)
> 
> diff --git a/libxfs/libxfs_io.h b/libxfs/libxfs_io.h
> index 1209e52..29fb1c7 100644
> --- a/libxfs/libxfs_io.h
> +++ b/libxfs/libxfs_io.h
> @@ -111,8 +111,6 @@ enum xfs_buf_flags_t {	/* b_flags bits */
>  #define XFS_BUF_SET_ADDR(bp,blk)	((bp)->b_bn = (blk))
>  #define XFS_BUF_SET_COUNT(bp,cnt)	((bp)->b_bcount = (cnt))
>  
> -#define XFS_BUF_FSPRIVATE(bp,type)	((type)(bp)->b_fspriv)
> -#define XFS_BUF_SET_FSPRIVATE(bp,val)	(bp)->b_fspriv = (void *)(val)

/me still hates the unhelpful 'priv' name, but yay for demacroing.

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

>  #define XFS_BUF_FSPRIVATE2(bp,type)	((type)(bp)->b_fsprivate2)
>  #define XFS_BUF_SET_FSPRIVATE2(bp,val)	(bp)->b_fsprivate2 = (void *)(val)
>  #define XFS_BUF_FSPRIVATE3(bp,type)	((type)(bp)->b_fsprivate3)
> diff --git a/libxfs/logitem.c b/libxfs/logitem.c
> index 4dcc506..0c183b5 100644
> --- a/libxfs/logitem.c
> +++ b/libxfs/logitem.c
> @@ -99,8 +99,8 @@ xfs_buf_item_init(
>  	if (XFS_BUF_FSPRIVATE3(bp, xfs_mount_t *) != mp)
>  		XFS_BUF_SET_FSPRIVATE3(bp, mp);
>  	XFS_BUF_SET_BDSTRAT_FUNC(bp, xfs_bdstrat_cb);
> -	if (XFS_BUF_FSPRIVATE(bp, void *) != NULL) {
> -		lip = XFS_BUF_FSPRIVATE(bp, xfs_log_item_t *);
> +	if (bp->b_fspriv != NULL) {
> +		lip = bp->b_fspriv;
>  		if (lip->li_type == XFS_LI_BUF) {
>  #ifdef LI_DEBUG
>  			fprintf(stderr,
> @@ -123,7 +123,7 @@ xfs_buf_item_init(
>  	bip->bli_format.blf_type = XFS_LI_BUF;
>  	bip->bli_format.blf_blkno = (int64_t)XFS_BUF_ADDR(bp);
>  	bip->bli_format.blf_len = (unsigned short)BTOBB(XFS_BUF_COUNT(bp));
> -	XFS_BUF_SET_FSPRIVATE(bp, bip);
> +	bp->b_fspriv = bip;
>  }
>  
>  
> diff --git a/libxfs/trans.c b/libxfs/trans.c
> index 3d64f26..6a1901b 100644
> --- a/libxfs/trans.c
> +++ b/libxfs/trans.c
> @@ -297,11 +297,10 @@ libxfs_trans_inode_alloc_buf(
>  	xfs_trans_t		*tp,
>  	xfs_buf_t		*bp)
>  {
> -	xfs_buf_log_item_t	*bip;
> +	xfs_buf_log_item_t	*bip = bp->b_fspriv;;
>  
>  	ASSERT(XFS_BUF_FSPRIVATE2(bp, xfs_trans_t *) == tp);
> -	ASSERT(XFS_BUF_FSPRIVATE(bp, void *) != NULL);
> -	bip = XFS_BUF_FSPRIVATE(bp, xfs_buf_log_item_t *);
> +	ASSERT(bip != NULL);
>  	bip->bli_flags |= XFS_BLI_INODE_ALLOC_BUF;
>  	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_DINO_BUF);
>  }
> @@ -364,12 +363,11 @@ libxfs_trans_dirty_buf(
>  	struct xfs_trans	*tp,
>  	struct xfs_buf		*bp)
>  {
> -	struct xfs_buf_log_item	*bip;
> +	struct xfs_buf_log_item	*bip = bp->b_fspriv;
>  
>  	ASSERT(XFS_BUF_FSPRIVATE2(bp, xfs_trans_t *) == tp);
> -	ASSERT(XFS_BUF_FSPRIVATE(bp, void *) != NULL);
> +	ASSERT(bip != NULL);
>  
> -	bip = XFS_BUF_FSPRIVATE(bp, xfs_buf_log_item_t *);
>  #ifdef XACT_DEBUG
>  	fprintf(stderr, "dirtied buffer %p, transaction %p\n", bp, tp);
>  #endif
> @@ -393,12 +391,10 @@ libxfs_trans_log_buf(
>  	uint			first,
>  	uint			last)
>  {
> -	struct xfs_buf_log_item	*bip;
> +	struct xfs_buf_log_item	*bip = bp->b_fspriv;
>  
>  	ASSERT((first <= last) && (last < XFS_BUF_COUNT(bp)));
>  
> -	bip = XFS_BUF_FSPRIVATE(bp, xfs_buf_log_item_t *);
> -
>  	xfs_trans_dirty_buf(tp, bp);
>  	xfs_buf_item_log(bip, first, last);
>  }
> @@ -439,7 +435,7 @@ libxfs_trans_brelse(
>  		return;
>  	}
>  	ASSERT(XFS_BUF_FSPRIVATE2(bp, xfs_trans_t *) == tp);
> -	bip = XFS_BUF_FSPRIVATE(bp, xfs_buf_log_item_t *);
> +	bip = bp->b_fspriv;
>  	ASSERT(bip->bli_item.li_type == XFS_LI_BUF);
>  	if (bip->bli_recur > 0) {
>  		bip->bli_recur--;
> @@ -462,15 +458,14 @@ libxfs_trans_binval(
>  	xfs_trans_t		*tp,
>  	xfs_buf_t		*bp)
>  {
> -	xfs_buf_log_item_t	*bip;
> +	xfs_buf_log_item_t	*bip = bp->b_fspriv;
>  #ifdef XACT_DEBUG
>  	fprintf(stderr, "binval'd buffer %p, transaction %p\n", bp, tp);
>  #endif
>  
>  	ASSERT(XFS_BUF_FSPRIVATE2(bp, xfs_trans_t *) == tp);
> -	ASSERT(XFS_BUF_FSPRIVATE(bp, void *) != NULL);
> +	ASSERT(bip != NULL);
>  
> -	bip = XFS_BUF_FSPRIVATE(bp, xfs_buf_log_item_t *);
>  	if (bip->bli_flags & XFS_BLI_STALE)
>  		return;
>  	XFS_BUF_UNDELAYWRITE(bp);
> @@ -496,7 +491,7 @@ libxfs_trans_bjoin(
>  #endif
>  
>  	xfs_buf_item_init(bp, tp->t_mountp);
> -	bip = XFS_BUF_FSPRIVATE(bp, xfs_buf_log_item_t *);
> +	bip = bp->b_fspriv;
>  	xfs_trans_add_item(tp, (xfs_log_item_t *)bip);
>  	XFS_BUF_SET_FSPRIVATE2(bp, tp);
>  }
> @@ -506,15 +501,14 @@ libxfs_trans_bhold(
>  	xfs_trans_t		*tp,
>  	xfs_buf_t		*bp)
>  {
> -	xfs_buf_log_item_t	*bip;
> +	xfs_buf_log_item_t	*bip =bp->b_fspriv;
>  
>  	ASSERT(XFS_BUF_FSPRIVATE2(bp, xfs_trans_t *) == tp);
> -	ASSERT(XFS_BUF_FSPRIVATE(bp, void *) != NULL);
> +	ASSERT(bp->b_fspriv != NULL);
>  #ifdef XACT_DEBUG
>  	fprintf(stderr, "bhold'd buffer %p, transaction %p\n", bp, tp);
>  #endif
>  
> -	bip = XFS_BUF_FSPRIVATE(bp, xfs_buf_log_item_t *);
>  	bip->bli_flags |= XFS_BLI_HOLD;
>  }
>  
> @@ -535,7 +529,7 @@ libxfs_trans_get_buf_map(
>  	bp = xfs_trans_buf_item_match(tp, btp, map, nmaps);
>  	if (bp != NULL) {
>  		ASSERT(XFS_BUF_FSPRIVATE2(bp, xfs_trans_t *) == tp);
> -		bip = XFS_BUF_FSPRIVATE(bp, xfs_buf_log_item_t *);
> +		bip = bp->b_fspriv;
>  		ASSERT(bip != NULL);
>  		bip->bli_recur++;
>  		return bp;
> @@ -549,7 +543,7 @@ libxfs_trans_get_buf_map(
>  #endif
>  
>  	xfs_buf_item_init(bp, tp->t_mountp);
> -	bip = XFS_BUF_FSPRIVATE(bp, xfs_buf_log_item_t*);
> +	bip = bp->b_fspriv;
>  	bip->bli_recur = 0;
>  	xfs_trans_add_item(tp, (xfs_log_item_t *)bip);
>  
> @@ -575,7 +569,7 @@ libxfs_trans_getsb(
>  	bp = xfs_trans_buf_item_match(tp, mp->m_dev, &map, 1);
>  	if (bp != NULL) {
>  		ASSERT(XFS_BUF_FSPRIVATE2(bp, xfs_trans_t *) == tp);
> -		bip = XFS_BUF_FSPRIVATE(bp, xfs_buf_log_item_t *);
> +		bip = bp->b_fspriv;
>  		ASSERT(bip != NULL);
>  		bip->bli_recur++;
>  		return bp;
> @@ -587,7 +581,7 @@ libxfs_trans_getsb(
>  #endif
>  
>  	xfs_buf_item_init(bp, mp);
> -	bip = XFS_BUF_FSPRIVATE(bp, xfs_buf_log_item_t*);
> +	bip = bp->b_fspriv;
>  	bip->bli_recur = 0;
>  	xfs_trans_add_item(tp, (xfs_log_item_t *)bip);
>  
> @@ -626,8 +620,8 @@ libxfs_trans_read_buf_map(
>  	bp = xfs_trans_buf_item_match(tp, btp, map, nmaps);
>  	if (bp != NULL) {
>  		ASSERT(XFS_BUF_FSPRIVATE2(bp, xfs_trans_t *) == tp);
> -		ASSERT(XFS_BUF_FSPRIVATE(bp, void *) != NULL);
> -		bip = XFS_BUF_FSPRIVATE(bp, xfs_buf_log_item_t*);
> +		ASSERT(bp->b_fspriv != NULL);
> +		bip = bp->b_fspriv;
>  		bip->bli_recur++;
>  		goto done;
>  	}
> @@ -644,7 +638,7 @@ libxfs_trans_read_buf_map(
>  #endif
>  
>  	xfs_buf_item_init(bp, tp->t_mountp);
> -	bip = XFS_BUF_FSPRIVATE(bp, xfs_buf_log_item_t *);
> +	bip = bp->b_fspriv;
>  	bip->bli_recur = 0;
>  	xfs_trans_add_item(tp, (xfs_log_item_t *)bip);
>  
> @@ -732,7 +726,7 @@ inode_item_done(
>  		return;
>  	}
>  
> -	XFS_BUF_SET_FSPRIVATE(bp, iip);
> +	bp->b_fspriv = iip;
>  	error = libxfs_iflush_int(ip, bp);
>  	if (error) {
>  		fprintf(stderr, _("%s: warning - iflush_int failed (%d)\n"),
> @@ -741,7 +735,7 @@ inode_item_done(
>  	}
>  
>  	ip->i_transp = NULL;	/* disassociate from transaction */
> -	XFS_BUF_SET_FSPRIVATE(bp, NULL);	/* remove log item */
> +	bp->b_fspriv = NULL;			/* remove log item */
>  	XFS_BUF_SET_FSPRIVATE2(bp, NULL);	/* remove xact ptr */
>  	libxfs_writebuf(bp, 0);
>  #ifdef XACT_DEBUG
> @@ -760,7 +754,7 @@ buf_item_done(
>  
>  	bp = bip->bli_buf;
>  	ASSERT(bp != NULL);
> -	XFS_BUF_SET_FSPRIVATE(bp, NULL);	/* remove log item */
> +	bp->b_fspriv = NULL;			/* remove log item */
>  	XFS_BUF_SET_FSPRIVATE2(bp, NULL);	/* remove xact ptr */
>  
>  	hold = (bip->bli_flags & XFS_BLI_HOLD);
> diff --git a/libxfs/util.c b/libxfs/util.c
> index 8003b26..5f49b82 100644
> --- a/libxfs/util.c
> +++ b/libxfs/util.c
> @@ -466,7 +466,7 @@ libxfs_iflush_int(xfs_inode_t *ip, xfs_buf_t *bp)
>  	xfs_dinode_t		*dip;
>  	xfs_mount_t		*mp;
>  
> -	ASSERT(XFS_BUF_FSPRIVATE(bp, void *) != NULL);
> +	ASSERT(bp-b_fspriv != NULL);
>  	ASSERT(ip->i_d.di_format != XFS_DINODE_FMT_BTREE ||
>  		ip->i_d.di_nextents > ip->i_df.if_ext_max);
>  	ASSERT(ip->i_d.di_version > 1);
> -- 
> 1.8.3.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
