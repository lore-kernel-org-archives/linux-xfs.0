Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0CLD1s5255389 for <xfs@oss.sgi.com>; Wed, 12 Jan 2011 15:13:01 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C6E171D2AC1D
	for <xfs@oss.sgi.com>; Wed, 12 Jan 2011 13:15:13 -0800 (PST)
Received: from mail.internode.on.net (bld-mail20.adl6.internode.on.net
	[150.101.137.105]) by cuda.sgi.com with ESMTP id
	t0IB6L0ZBLM4eF2l for <xfs@oss.sgi.com>;
	Wed, 12 Jan 2011 13:15:13 -0800 (PST)
Date: Thu, 13 Jan 2011 08:15:10 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] [RFC] xfs: stop using the page cache to back the
	buffer cache
Message-ID: <20110112211510.GQ28803@dastard>
References: <1294817201-18670-1-git-send-email-david@fromorbit.com>
	<20110112131604.GA28675@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110112131604.GA28675@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Wed, Jan 12, 2011 at 08:16:05AM -0500, Christoph Hellwig wrote:
> > -	if (bp->b_pages != bp->b_page_array) {
> > +	if (bp->b_pages && bp->b_pages != bp->b_page_array) {
> 
> If bp->p_ages is NULL it's per defintion different from b_page_array.

True. I'll drop that mod.

> 
> >  STATIC int
> > -_xfs_buf_lookup_pages(
> > +xfs_buf_allocate_buffer(
> 
> This is a bit misnamed and rather confusing vs xfs_buf_allocate.
> 
> Maybe call it xfs_buf_allocate_memory?

Yes, seems lik a better name.
> 
> > +	/*
> > +	 * for buffers that are contained within a single page, just allocate
> > +	 * the memory from the heap - there's no need for the complexity of
> > +	 * page arrays to keep allocation down to order 0.
> > +	 */
> > +	if (bp->b_buffer_length <= PAGE_SIZE) {
> 
> I think this should be a <, not <= - for page sized buffers avoiding
> the slab overhead should be much more efficient.

*nod*

The patch has been sitting around for a couple of weeks, and when I
did a quick look at it before posting it I wondered if I should make
that exact change before posting it. I decided not to because I
didn't want to wait for retesting before posting...

> 
> > +		page_count = 1;
> > +	} else {
> > +		end = bp->b_file_offset + bp->b_buffer_length;
> > +		page_count = xfs_buf_btoc(end) -
> > +					xfs_buf_btoct(bp->b_file_offset);
> > +	}
> >  
> >  	error = _xfs_buf_get_pages(bp, page_count, flags);
> >  	if (unlikely(error))
> >  		return error;
> > +
> > +	if (bp->b_page_count == 1) {
> 
> I'd just duplicate the _xfs_buf_get_pages inside the branches to make
> this a lot cleaner.  The page_count calculation in the else clause can
> never end up as 1 anyway.  Maybe even make it two different functions
> and let the only caller decide which one to use.

OK, I'll rework the logic here to clean up the flow.

> > +		unsigned long	pageaddr;
> > +
> > +		bp->b_addr = kmem_alloc(bp->b_buffer_length, xb_to_km(flags));
> > +		if (!bp->b_addr)
> > +			return ENOMEM;
> > +
> > +		pageaddr = (unsigned long)bp->b_addr & PAGE_MASK;
> > +		ASSERT(((unsigned long)(bp->b_addr + bp->b_buffer_length - 1) & PAGE_MASK) == pageaddr);
> > +
> > +		bp->b_offset = (unsigned long)bp->b_addr - pageaddr;
> 
> This can just be
> 
> 		bp->b_offset = offset_in_page(bp->b_addr);
> 
> > +		bp->b_pages[0] = virt_to_page((void *)pageaddr);
> 
> and this
> 
> 		bp->b_pages[0] = virt_to_page(bp->b_addr);
> 
> with that the above assert can be changed to not need a local variable
> and imho be slightly cleaner:
> 
> 		ASSERT(((unsigned long)bp->b_addr + bp->b_buffer_length - 1) &
> 			PAGE_MASK) ==
> 		       (unsigned long)bp->b_addr & PAGE_MASK);

Good idea, it can definitely be made cleaner.

> although I'm not sure it's actually correct.  slub is a pretty
> aggressive in using high order pages and might give us back memory that
> goes across multiple pages.  Adding a loop here to assign multiple pages
> if needed seems safer.

Hmmm. I've been using SLUB and not seen any assert triggers. I put
the assert there because I was concerned about whether this could
occur, but the heap is backed by power-of-two sized slabs so I think
that slub doesn't trigger it.

I'll have a think about how to handle buffers that span multiple
pages cleanly - like you said a loop is probably the easiest way to
handle it.

> > +		bp->b_flags |= XBF_MAPPED|_XBF_KMEM;
> 
> Space around the | operator, please.
> 
> > +		bp->b_flags &= XBF_MAPPED|_XBF_KMEM|_XBF_PAGES;
> 
> here, too.

Will do. As you've noticed, the code is pretty rough still. :/

> Additional comments:
> 
>  - the _XBF_PAGE_CACHE and _XBF_PAGE_LOCKED flags are now unused and can
>    be removed.
>  - the comment describing xfs_buf_t around line 141 in xfs_buf.h is now
>    incorrect.  It's not overly useful so I'd suggest removing it
>    completely.
>  - the comments above the buffer locking functions in xfs_buf.c
>    (including the meta-comment) are now incorrect and should be
>    fixed/removed.
>  - the call to mark_page_accessed in xfs_buf_get is now superflous,
>    as it only has a meaning for pagecache pages.

I'll clean them up for the next version. Thanks for the initial
sanity check, Christoph.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
