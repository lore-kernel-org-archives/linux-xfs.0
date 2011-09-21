Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8L6in7u122347 for <xfs@oss.sgi.com>; Wed, 21 Sep 2011 01:44:49 -0500
Received: from ipmail06.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D44941608544
	for <xfs@oss.sgi.com>; Tue, 20 Sep 2011 23:50:08 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	aDFPsCgw3DE0FBPR for <xfs@oss.sgi.com>;
	Tue, 20 Sep 2011 23:50:08 -0700 (PDT)
Date: Wed, 21 Sep 2011 16:44:43 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/4] xfs: Don't allocate new buffers on every call to
	_xfs_buf_find
Message-ID: <20110921064443.GO15688@dastard>
References: <1314341497-23910-1-git-send-email-david@fromorbit.com>
	<1314341497-23910-2-git-send-email-david@fromorbit.com>
	<20110826081132.GA3551@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110826081132.GA3551@infradead.org>
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

On Fri, Aug 26, 2011 at 04:11:32AM -0400, Christoph Hellwig wrote:
> > diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> > index c57836d..594cea5 100644
> > --- a/fs/xfs/xfs_buf.c
> > +++ b/fs/xfs/xfs_buf.c
> > @@ -171,10 +171,16 @@ STATIC void
> >  _xfs_buf_initialize(
> >  	xfs_buf_t		*bp,
> >  	xfs_buftarg_t		*target,
> > -	xfs_off_t		range_base,
> > -	size_t			range_length,
> > +	xfs_off_t		bno,
> > +	size_t			num_blocks,
> >  	xfs_buf_flags_t		flags)
> >  {
> > +	xfs_off_t		range_base;
> > +	size_t			range_length;
> > +
> > +	range_base = BBTOB(bno);
> > +	range_length = BBTOB(num_blocks);
> 
> What is the point of changing the mostly unrelated _xfs_buf_initialize
> prototype in this patch?

We were converting units backwards and forwards inconsistently, some
functions taking bytes, some basic blocks, and conversions were
being done all over the place.

> I think it (and the other renaming changes related to it) are fine,
> but should be a separate patch.

OK, fine, I can do that.

> And once you touch _xfs_buf_initialize
> after the core of this patch, please merge it with xfs_buf_allocate into
> a new xfs_buf_alloc that does the full allocation + initialization and
> can also replace xfs_buf_get_empty.

Not right now. That restructing can be done separately, probably in
the same patch set that fixes the API types problems...

> > +	bp = _xfs_buf_find(target, bno, num_blocks, flags, new_bp);
> > +	if (!bp) {
> > +		xfs_buf_deallocate(new_bp);
> > +		return NULL;
> > +	}
> > +
> >  	if (bp == new_bp) {
> >  		error = xfs_buf_allocate_memory(bp, flags);
> >  		if (error)
> >  			goto no_buffer;
> > +	} else
> >  		xfs_buf_deallocate(new_bp);
> 
> I'd recommend moving the call to xfs_buf_allocate_memory into
> _xfs_buf_find so that it returns a fully allocated buffer.  In fact I'd
> also move the xfs_buf_deallocate(new_bp) into the found side of
> _xfs_buf_find, avoiding any conditionals in xfs_buf_get.

<sigh>

This code s pretty much as you requested it after the first time I
posted it.

http://oss.sgi.com/archives/xfs/2011-08/msg00146.html

I'll go rewrite this again, but IMO all you are asking for is for me
to put a different colour on the bike shed....

> >  
> > -	XFS_STATS_INC(xb_get);
> > -
> >  	/*
> > -	 * Always fill in the block number now, the mapped cases can do
> > -	 * their own overlay of this later.
> > +	 * Now we have a workable buffer, fill in the block number so
> > +	 * that we can do IO on it.
> >  	 */
> > -	bp->b_bn = ioff;
> > -	bp->b_count_desired = bp->b_buffer_length;
> > +	bp->b_bn = bno;
> 
> Note that we only need this if we did not find an existing buffer.  It's
> not strictly related to the patch, but given that you stop assigning
> b_count_desired and redo this whole area it might be worth shifting it
> into the if (bp == new_bp) conditional area.

OK.

> >  
> > +found:
> > +	ASSERT(bp->b_flags & XBF_MAPPED);
> 
> This doesn't look right to me.  Various buffers like inode or remoate attrs
> are unmapped, and I can't see any reason why we would assert not beeing
> allowed to find them here.

Yeah, a bit of a thinko, but it never tripped on me....

> Thinking about it more I'm also not sure skipping the code to map
> buffers on a straight cache hit is a good idea - there's nothing
> inherent to requiring a given buffer to be mapped for all callers.

OK, will fix.


-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
