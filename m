Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 24 Mar 2007 20:51:42 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l2P3pa6p025220
	for <xfs@oss.sgi.com>; Sat, 24 Mar 2007 20:51:38 -0700
Date: Sun, 25 Mar 2007 14:51:26 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: XFS and write barriers.
Message-ID: <20070325035126.GI32602149@melbourne.sgi.com>
References: <17923.11463.459927.628762@notabene.brown> <20070323053043.GD32602149@melbourne.sgi.com> <20070323095055.GA13478@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070323095055.GA13478@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: David Chinner <dgc@sgi.com>, Neil Brown <neilb@suse.de>, xfs@oss.sgi.com

On Fri, Mar 23, 2007 at 09:50:55AM +0000, Christoph Hellwig wrote:
> On Fri, Mar 23, 2007 at 04:30:43PM +1100, David Chinner wrote:
> > On Fri, Mar 23, 2007 at 12:26:31PM +1100, Neil Brown wrote:
> > > 
> > > Hi,
> > >  I have two concerns related to XFS and write barrier support that I'm
> > >  hoping can be resolved.
> > > 
> > > Firstly in xfs_mountfs_check_barriers in fs/xfs/linux-2.6/xfs_super.c,
> > > it tests ....->queue->ordered to see if that is QUEUE_ORDERED_NONE.
> > > If it is, then barriers are disabled.
> > > 
> > > I think this is a layering violation - xfs really has no business
> > > looking that deeply into the device.
> > 
> > Except that the device behaviour determines what XFS needs to do
> > and there used to be no other way to find out.
> > 
> > Christoph, any reason for needing this check anymore? I can't see
> > any particular reason for needing to do this as __make_request()
> > will check it for us when we test now.
> 
> When I first implemented it I really dislike the idea of having request
> fail asynchrnously due to the lack of barriers.  Then someone (Jens?)
> told me we need to do this check anyway because devices might lie to
> us, at which point I implemented the test superblock writeback to
> check if it actually works.
> 
> So yes, we could probably get rid of the check now, although I'd
> prefer the block layer exporting an API to the filesystem to tell
> it whether there is any point in trying to use barriers.

Ditto.

> > > Secondly, if a barrier write fails due to EOPNOTSUPP, it should be
> > > retried without the barrier (after possibly waiting for dependant
> > > requests to complete).  This is what other filesystems do, but I
> > > cannot find the code in xfs which does this.
> > 
> > XFS doesn't handle this - I was unaware that the barrier status of the
> > underlying block device could change....
> > 
> > OOC, when did this behaviour get introduced?
> 
> That would be really bad.  XFS metadata buffers can have multiple bios
> and retrying a single one would be rather difficult.
> 
> > +	/*
> > +	 * We can get an EOPNOTSUPP to ordered writes.  Here we clear the
> > +	 * ordered flag and reissue them.  Because we can't tell the higher
> > +	 * layers directly that they should not issue ordered I/O anymore, they
> > +	 * need to check if the ordered flag was cleared during I/O completion.
> > +	 */
> > +	if ((bp->b_error == EOPNOTSUPP) &&
> > +	    (bp->b_flags & (XBF_ORDERED|XBF_ASYNC)) == (XBF_ORDERED|XBF_ASYNC)) {
> > +		XB_TRACE(bp, "ordered_retry", bp->b_iodone);
> > +		bp->b_flags &= ~XBF_ORDERED;
> > +		xfs_buf_iorequest(bp);
> > +	} else if (bp->b_iodone)
> >  		(*(bp->b_iodone))(bp);
> >  	else if (bp->b_flags & XBF_ASYNC)
> >  		xfs_buf_relse(bp);
> 
> So you're retrying the whole I/O, this is probably better than trying
> to handle this at the bio level.  I still don't quite like doing another
> I/O from the I/O completion handler.

You're not the only one, Christoph. This may be better than trying
to handle it at lower layers, and far better than having to handle
it at every point in the higher layers where we may issue barrier
I/Os. 

But I *seriously dislike* having to reissue async I/Os in this
manner and then having to rely on a higher layer's I/o completion
handler to detect the fact that the I/O was retried to change the
way the filesystem issues I/Os in the future. It's a really crappy
way of communicating between layers....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
