Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7Q8BdLu054946 for <xfs@oss.sgi.com>; Fri, 26 Aug 2011 03:11:39 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9194411AB7B
	for <xfs@oss.sgi.com>; Fri, 26 Aug 2011 01:11:34 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	4AAsaK4zaTUQqcjf for <xfs@oss.sgi.com>;
	Fri, 26 Aug 2011 01:11:34 -0700 (PDT)
Date: Fri, 26 Aug 2011 04:11:32 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/4] xfs: Don't allocate new buffers on every call to
	_xfs_buf_find
Message-ID: <20110826081132.GA3551@infradead.org>
References: <1314341497-23910-1-git-send-email-david@fromorbit.com>
	<1314341497-23910-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1314341497-23910-2-git-send-email-david@fromorbit.com>
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

> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index c57836d..594cea5 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -171,10 +171,16 @@ STATIC void
>  _xfs_buf_initialize(
>  	xfs_buf_t		*bp,
>  	xfs_buftarg_t		*target,
> -	xfs_off_t		range_base,
> -	size_t			range_length,
> +	xfs_off_t		bno,
> +	size_t			num_blocks,
>  	xfs_buf_flags_t		flags)
>  {
> +	xfs_off_t		range_base;
> +	size_t			range_length;
> +
> +	range_base = BBTOB(bno);
> +	range_length = BBTOB(num_blocks);

What is the point of changing the mostly unrelated _xfs_buf_initialize
prototype in this patch?

I think it (and the other renaming changes related to it) are fine,
but should be a separate patch.  And once you touch _xfs_buf_initialize
after the core of this patch, please merge it with xfs_buf_allocate into
a new xfs_buf_alloc that does the full allocation + initialization and
can also replace xfs_buf_get_empty.

> +	bp = _xfs_buf_find(target, bno, num_blocks, flags, new_bp);
> +	if (!bp) {
> +		xfs_buf_deallocate(new_bp);
> +		return NULL;
> +	}
> +
>  	if (bp == new_bp) {
>  		error = xfs_buf_allocate_memory(bp, flags);
>  		if (error)
>  			goto no_buffer;
> +	} else
>  		xfs_buf_deallocate(new_bp);

I'd recommend moving the call to xfs_buf_allocate_memory into
_xfs_buf_find so that it returns a fully allocated buffer.  In fact I'd
also move the xfs_buf_deallocate(new_bp) into the found side of
_xfs_buf_find, avoiding any conditionals in xfs_buf_get.


>  
> -	XFS_STATS_INC(xb_get);
> -
>  	/*
> -	 * Always fill in the block number now, the mapped cases can do
> -	 * their own overlay of this later.
> +	 * Now we have a workable buffer, fill in the block number so
> +	 * that we can do IO on it.
>  	 */
> -	bp->b_bn = ioff;
> -	bp->b_count_desired = bp->b_buffer_length;
> +	bp->b_bn = bno;

Note that we only need this if we did not find an existing buffer.  It's
not strictly related to the patch, but given that you stop assigning
b_count_desired and redo this whole area it might be worth shifting it
into the if (bp == new_bp) conditional area.


>  
> +found:
> +	ASSERT(bp->b_flags & XBF_MAPPED);

This doesn't look right to me.  Various buffers like inode or remoate attrs
are unmapped, and I can't see any reason why we would assert not beeing
allowed to find them here.

Thinking about it more I'm also not sure skipping the code to map
buffers on a straight cache hit is a good idea - there's nothing
inherent to requiring a given buffer to be mapped for all callers.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
