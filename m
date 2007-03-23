Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 23 Mar 2007 03:12:41 -0700 (PDT)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l2NACa6p002894
	for <xfs@oss.sgi.com>; Fri, 23 Mar 2007 03:12:37 -0700
Date: Fri, 23 Mar 2007 09:50:55 +0000
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: XFS and write barriers.
Message-ID: <20070323095055.GA13478@infradead.org>
References: <17923.11463.459927.628762@notabene.brown> <20070323053043.GD32602149@melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070323053043.GD32602149@melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Neil Brown <neilb@suse.de>, xfs@oss.sgi.com, hch@infradead.org

On Fri, Mar 23, 2007 at 04:30:43PM +1100, David Chinner wrote:
> On Fri, Mar 23, 2007 at 12:26:31PM +1100, Neil Brown wrote:
> > 
> > Hi,
> >  I have two concerns related to XFS and write barrier support that I'm
> >  hoping can be resolved.
> > 
> > Firstly in xfs_mountfs_check_barriers in fs/xfs/linux-2.6/xfs_super.c,
> > it tests ....->queue->ordered to see if that is QUEUE_ORDERED_NONE.
> > If it is, then barriers are disabled.
> > 
> > I think this is a layering violation - xfs really has no business
> > looking that deeply into the device.
> 
> Except that the device behaviour determines what XFS needs to do
> and there used to be no other way to find out.
> 
> Christoph, any reason for needing this check anymore? I can't see
> any particular reason for needing to do this as __make_request()
> will check it for us when we test now.

When I first implemented it I really dislike the idea of having request
fail asynchrnously due to the lack of barriers.  Then someone (Jens?)
told me we need to do this check anyway because devices might lie to
us, at which point I implemented the test superblock writeback to
check if it actually works.

So yes, we could probably get rid of the check now, although I'd
prefer the block layer exporting an API to the filesystem to tell
it whether there is any point in trying to use barriers.

> > Secondly, if a barrier write fails due to EOPNOTSUPP, it should be
> > retried without the barrier (after possibly waiting for dependant
> > requests to complete).  This is what other filesystems do, but I
> > cannot find the code in xfs which does this.
> 
> XFS doesn't handle this - I was unaware that the barrier status of the
> underlying block device could change....
> 
> OOC, when did this behaviour get introduced?

That would be really bad.  XFS metadata buffers can have multiple bios
and retrying a single one would be rather difficult.

> +	/*
> +	 * We can get an EOPNOTSUPP to ordered writes.  Here we clear the
> +	 * ordered flag and reissue them.  Because we can't tell the higher
> +	 * layers directly that they should not issue ordered I/O anymore, they
> +	 * need to check if the ordered flag was cleared during I/O completion.
> +	 */
> +	if ((bp->b_error == EOPNOTSUPP) &&
> +	    (bp->b_flags & (XBF_ORDERED|XBF_ASYNC)) == (XBF_ORDERED|XBF_ASYNC)) {
> +		XB_TRACE(bp, "ordered_retry", bp->b_iodone);
> +		bp->b_flags &= ~XBF_ORDERED;
> +		xfs_buf_iorequest(bp);
> +	} else if (bp->b_iodone)
>  		(*(bp->b_iodone))(bp);
>  	else if (bp->b_flags & XBF_ASYNC)
>  		xfs_buf_relse(bp);

So you're retrying the whole I/O, this is probably better than trying
to handle this at the bio level.  I still don't quite like doing another
I/O from the I/O completion handler.
