Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0HBqbtd009746 for <xfs@oss.sgi.com>; Sun, 17 Jan 2010 05:52:38 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E83311C57685
	for <xfs@oss.sgi.com>; Sun, 17 Jan 2010 03:53:36 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id dWDGfjv2Fpn7ybyn for
	<xfs@oss.sgi.com>; Sun, 17 Jan 2010 03:53:36 -0800 (PST)
Date: Sun, 17 Jan 2010 06:53:36 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/9] xfsprogs: Fix miscellaneous warnings in libxfs
Message-ID: <20100117115336.GE10994@infradead.org>
References: <1263463752-5052-1-git-send-email-david@fromorbit.com>
	<1263463752-5052-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1263463752-5052-3-git-send-email-david@fromorbit.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

> -/* space allocation */
> +/* space allocation - use static inlines to avoid unused var warnings */
>  #define xfs_alloc_search_busy(tp,ag,b,len)	((void) 0)
> -#define xfs_alloc_mark_busy(tp,ag,b,len)	((void) 0)
> +static inline void xfs_alloc_mark_busy(xfs_trans_t *tp,
> +	xfs_agnumber_t agno, xfs_agblock_t bno, xfs_extlen_t len) {}
>  #define xfs_rotorstep				1
>  #define xfs_bmap_rtalloc(a)			(ENOSYS)
>  #define xfs_rtpick_extent(mp,tp,len,p)		(ENOSYS)

Maybe just convert all these to inlines so that we make sure all
arguments are evaluated?

> diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
> index cf1123a..4cc6431 100644
> --- a/libxfs/xfs_bmap.c
> +++ b/libxfs/xfs_bmap.c
> @@ -4274,7 +4274,7 @@ xfs_bmapi(
>  	xfs_fsblock_t	abno;		/* allocated block number */
>  	xfs_extlen_t	alen;		/* allocated extent length */
>  	xfs_fileoff_t	aoff;		/* allocated file offset */
> -	xfs_bmalloca_t	bma;		/* args for xfs_bmap_alloc */
> +	xfs_bmalloca_t	bma = { 0 };	/* args for xfs_bmap_alloc */
>  	xfs_btree_cur_t	*cur;		/* bmap btree cursor */
>  	xfs_fileoff_t	end;		/* end of mapped file region */
>  	int		eof;		/* we've hit the end of extents */

Not nice but okay..

> diff --git a/libxfs/xfs_mount.c b/libxfs/xfs_mount.c
> index 02bff42..662c8d2 100644
> --- a/libxfs/xfs_mount.c
> +++ b/libxfs/xfs_mount.c
> @@ -400,15 +400,14 @@ xfs_mod_sb(xfs_trans_t *tp, __int64_t fields)
>  
>  	xfs_sb_to_disk(XFS_BUF_TO_SBP(bp), &mp->m_sb, fields);
>  
> -	/* find modified range */
> +	/* find modified range - get last first to avoid spurious warning */
> +	f = (xfs_sb_field_t)xfs_highbit64((__uint64_t)fields);
> +	ASSERT((1LL << f) & XFS_SB_MOD_BITS);
> +	last = xfs_sb_info[f + 1].offset - 1;
>  
>  	f = (xfs_sb_field_t)xfs_lowbit64((__uint64_t)fields);
>  	ASSERT((1LL << f) & XFS_SB_MOD_BITS);
>  	first = xfs_sb_info[f].offset;
>  
> -	f = (xfs_sb_field_t)xfs_highbit64((__uint64_t)fields);
> -	ASSERT((1LL << f) & XFS_SB_MOD_BITS);
> -	last = xfs_sb_info[f + 1].offset - 1;
> -

I don't see how this can shut up a warning, but as it doesn't cause harm
I'm fine with it.  But this and the above one really need to go in via
the kernel tree first.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
