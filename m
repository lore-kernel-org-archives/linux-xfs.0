Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0CDDwpK194444 for <xfs@oss.sgi.com>; Wed, 12 Jan 2011 07:14:01 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 50A62153ECA2
	for <xfs@oss.sgi.com>; Wed, 12 Jan 2011 05:16:12 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id BlL4jzbbMhei9C7V for
	<xfs@oss.sgi.com>; Wed, 12 Jan 2011 05:16:12 -0800 (PST)
Date: Wed, 12 Jan 2011 08:16:05 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] [RFC] xfs: stop using the page cache to back the buffer
	cache
Message-ID: <20110112131604.GA28675@infradead.org>
References: <1294817201-18670-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1294817201-18670-1-git-send-email-david@fromorbit.com>
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

> -	if (bp->b_pages != bp->b_page_array) {
> +	if (bp->b_pages && bp->b_pages != bp->b_page_array) {

If bp->p_ages is NULL it's per defintion different from b_page_array.

>  STATIC int
> -_xfs_buf_lookup_pages(
> +xfs_buf_allocate_buffer(

This is a bit misnamed and rather confusing vs xfs_buf_allocate.

Maybe call it xfs_buf_allocate_memory?

> +	/*
> +	 * for buffers that are contained within a single page, just allocate
> +	 * the memory from the heap - there's no need for the complexity of
> +	 * page arrays to keep allocation down to order 0.
> +	 */
> +	if (bp->b_buffer_length <= PAGE_SIZE) {

I think this should be a <, not <= - for page sized buffers avoiding
the slab overhead should be much more efficient.

> +		page_count = 1;
> +	} else {
> +		end = bp->b_file_offset + bp->b_buffer_length;
> +		page_count = xfs_buf_btoc(end) -
> +					xfs_buf_btoct(bp->b_file_offset);
> +	}
>  
>  	error = _xfs_buf_get_pages(bp, page_count, flags);
>  	if (unlikely(error))
>  		return error;
> +
> +	if (bp->b_page_count == 1) {

I'd just duplicate the _xfs_buf_get_pages inside the branches to make
this a lot cleaner.  The page_count calculation in the else clause can
never end up as 1 anyway.  Maybe even make it two different functions
and let the only caller decide which one to use.

> +		unsigned long	pageaddr;
> +
> +		bp->b_addr = kmem_alloc(bp->b_buffer_length, xb_to_km(flags));
> +		if (!bp->b_addr)
> +			return ENOMEM;
> +
> +		pageaddr = (unsigned long)bp->b_addr & PAGE_MASK;
> +		ASSERT(((unsigned long)(bp->b_addr + bp->b_buffer_length - 1) & PAGE_MASK) == pageaddr);
> +
> +		bp->b_offset = (unsigned long)bp->b_addr - pageaddr;

This can just be

		bp->b_offset = offset_in_page(bp->b_addr);

> +		bp->b_pages[0] = virt_to_page((void *)pageaddr);

and this

		bp->b_pages[0] = virt_to_page(bp->b_addr);

with that the above assert can be changed to not need a local variable
and imho be slightly cleaner:

		ASSERT(((unsigned long)bp->b_addr + bp->b_buffer_length - 1) &
			PAGE_MASK) ==
		       (unsigned long)bp->b_addr & PAGE_MASK);

although I'm not sure it's actually correct.  slub is a pretty
aggressive in using high order pages and might give us back memory that
goes across multiple pages.  Adding a loop here to assign multiple pages
if needed seems safer.
		

> +		bp->b_flags |= XBF_MAPPED|_XBF_KMEM;

Space around the | operator, please.

> +		bp->b_flags &= XBF_MAPPED|_XBF_KMEM|_XBF_PAGES;

here, too.


Additional comments:

 - the _XBF_PAGE_CACHE and _XBF_PAGE_LOCKED flags are now unused and can
   be removed.
 - the comment describing xfs_buf_t around line 141 in xfs_buf.h is now
   incorrect.  It's not overly useful so I'd suggest removing it
   completely.
 - the comments above the buffer locking functions in xfs_buf.c
   (including the meta-comment) are now incorrect and should be
   fixed/removed.
 - the call to mark_page_accessed in xfs_buf_get is now superflous,
   as it only has a meaning for pagecache pages.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
