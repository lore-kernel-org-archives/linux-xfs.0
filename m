Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42658 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752488AbeAZTY7 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 26 Jan 2018 14:24:59 -0500
Date: Fri, 26 Jan 2018 14:24:57 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 4/6] xfs: don't screw up direct writes when freesp is
 fragmented
Message-ID: <20180126192457.GC26910@bfoster.bfoster>
References: <151693228803.7395.12526880865470882359.stgit@magnolia>
 <151693231279.7395.4392783659285038910.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151693231279.7395.4392783659285038910.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Jan 25, 2018 at 06:05:12PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> xfs_bmap_btalloc is given a range of file offset blocks that must be
> allocated to some data/attr/cow fork.  If the fork has an extent size
> hint associated with it, the request will be enlarged on both ends to
> try to satisfy the alignment hint.  If free space is fragmentated,
> sometimes we can allocate some blocks but not enough to fulfill any of
> the requested range.  Since bmapi_allocate always trims the new extent
> mapping to match the originally requested range, this results in
> bmapi_write returning zero and no mapping.
> 
> The consequences of this vary -- buffered writes will simply re-call
> bmapi_write until it can satisfy at least one block from the original
> request.  Direct IO overwrites notice nmaps == 0 and return -ENOSPC
> through the dio mechanism out to userspace with the weird result that
> writes fail even when we have enough space because the ENOSPC return
> overrides any partial write status.  For direct CoW writes the situation
> is disastrous because nobody notices us returning an invalid zero-length
> wrong-offset mapping to iomap and the write goes off into space.
> 
> First of all, teach iomap and xfs_reflink_allocate_cow to check the
> mappings being returned and bail out with ENOSPC if we can't get any
> blocks.  Second of all, if free space is so fragmented we can't satisfy
> even a single block of the original allocation request but did get a few
> blocks, we should break the alignment hint in order to guarantee at
> least some forward progress for the direct write.  If we return a short
> allocation to iomap_apply it'll call back about the remaining blocks.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/iomap.c               |    2 +-
>  fs/xfs/libxfs/xfs_bmap.c |   15 +++++++++++++++
>  fs/xfs/xfs_reflink.c     |    6 ++++++
>  3 files changed, 22 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/fs/iomap.c b/fs/iomap.c
> index e5de772..aec35a0 100644
> --- a/fs/iomap.c
> +++ b/fs/iomap.c
> @@ -63,7 +63,7 @@ iomap_apply(struct inode *inode, loff_t pos, loff_t length, unsigned flags,
>  	ret = ops->iomap_begin(inode, pos, length, flags, &iomap);
>  	if (ret)
>  		return ret;
> -	if (WARN_ON(iomap.offset > pos))
> +	if (WARN_ON(iomap.offset > pos) || WARN_ON(iomap.length == 0))
>  		return -EIO;
>  
>  	/*
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 032befb..1fb885c 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -3386,6 +3386,8 @@ xfs_bmap_btalloc(
>  	xfs_agnumber_t	fb_agno;	/* ag number of ap->firstblock */
>  	xfs_agnumber_t	ag;
>  	xfs_alloc_arg_t	args;
> +	xfs_fileoff_t	orig_offset;
> +	xfs_extlen_t	orig_length;
>  	xfs_extlen_t	blen;
>  	xfs_extlen_t	nextminlen = 0;
>  	int		nullfb;		/* true if ap->firstblock isn't set */
> @@ -3395,6 +3397,8 @@ xfs_bmap_btalloc(
>  	int		stripe_align;
>  
>  	ASSERT(ap->length);
> +	orig_offset = ap->offset;
> +	orig_length = ap->length;
>  
>  	mp = ap->ip->i_mount;
>  
> @@ -3610,6 +3614,17 @@ xfs_bmap_btalloc(
>  			*ap->firstblock = args.fsbno;
>  		ASSERT(nullfb || fb_agno <= args.agno);
>  		ap->length = args.len;
> +		/*
> +		 * If we didn't get enough blocks to fill even one block of
> +		 * the original request, break the alignment and return
> +		 * whatever we got; it's the best we can do.  Free space is
> +		 * fragmented enough that we cannot honor the extent size
> +		 * hints but we can still make some forward progress.
> +		 */
> +		if (ap->length <= orig_length)
> +			ap->offset = orig_offset;
> +		else if (ap->offset + ap->length < orig_offset + orig_length)
> +			ap->offset = orig_offset + orig_length - ap->length;

Ok, but do we really want to shift the extent placement for any
allocation that is short? E.g., what if the allocation is short but
still covers the target offset? ISTM there's a tradeoff here between
filling the range asked for vs. following the heuristic in
xfs_bmap_extsize_align(). Even if we do end up shifting to prioritize
the target range, that doesn't seem to be what the comment describes by
saying "... we didn't get enough blocks to fill even one block of the
original request." :P

>  		xfs_bmap_btalloc_accounting(ap, &args);
>  	} else {
>  		ap->blkno = NULLFSBLOCK;
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index 9a6c545..9eca8aa 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -464,6 +464,12 @@ xfs_reflink_allocate_cow(
>  	error = xfs_trans_commit(tp);
>  	if (error)
>  		return error;
> +	/*
> +	 * Allocation succeeded but our request was not even partially
> +	 * satisfied?  Bail out.
> +	 */
> +	if (nimaps == 0)
> +		return -ENOSPC;

I think this should probably be a separate patch. This part is a
straightforward bug fix for a potentially critical issue (i.e., a no
brainer). While not that much code, the change above is an enhancement
with a bit more complexity to consider.

Brian

>  convert:
>  	return xfs_reflink_convert_cow_extent(ip, imap, offset_fsb, count_fsb,
>  			&dfops);
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
