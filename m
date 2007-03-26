Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 25 Mar 2007 20:14:29 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l2Q3EL6p003689
	for <xfs@oss.sgi.com>; Sun, 25 Mar 2007 20:14:24 -0700
Date: Mon, 26 Mar 2007 14:14:07 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: XFS and write barriers.
Message-ID: <20070326031407.GG32597093@melbourne.sgi.com>
References: <17923.11463.459927.628762@notabene.brown> <20070323053043.GD32602149@melbourne.sgi.com> <17923.34462.210758.852042@notabene.brown> <20070325041755.GJ32602149@melbourne.sgi.com> <17927.1031.996460.858328@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <17927.1031.996460.858328@notabene.brown>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Neil Brown <neilb@suse.de>
Cc: David Chinner <dgc@sgi.com>, xfs@oss.sgi.com, hch@infradead.org

On Mon, Mar 26, 2007 at 09:21:43AM +1000, Neil Brown wrote:
> My point was that if the functionality cannot be provided in the
> lowest-level firmware (as it cannot for raid0 as there is no single
> lowest-level firmware), then it should be implemented at the
> filesystem level.  Implementing barriers in md or dm doesn't make any
> sense (though passing barriers through can in some situations).

Hold on - you've said that the barrier support in a block deivce
can change because of MD doing hot swap. Now you're saying
there is no barrier implementation in md. Can you explain
*exactly* what barrier support there is in MD?

> > > Trying to emulate it
> > > in the md layer doesn't make any sense as the filesystem is in a much
> > > better position to do any emulation required.
> > 
> > You're saying that the emulation of block layer functionality is the
> > responsibility of layers above the block layer. Why is this not
> > considered a layering violation?
> 
> :-)
> Maybe it depends on your perspective.  I think this is filesystem
> layer functionality.  Making sure blocks are written in the right
> order sounds like something that the filesystem should be primarily
> responsible for.

Sure, but if the filesystem requires the block layer to provide
those ordering semantics to it. e.g. barrier I/Os.

Remember, different filesystem have different levels of
data+metadata safety and many of them do nothing to guarantee
write ordering.

> The most straight-forward way to implement this is to make sure all
> preceding blocks have been written before writing the barrier block.
> All filesystems should be able to do this (if it is important to them).
                                             ^^^^^^^^^^^^^^^^^^^^^^^^^^

And that is the key point - XFS provides no guarantee that your
data is on spinning rust other than I/O barriers when you have
volatile write caches.

IOWs, if you turn barriers off, we provide *no guarantees*
about the consistency of your filesystem after a power failure
if you are using volatile write caching. This mode is for
use with non-cached disks or disks with NVRAM caches where there
is no need for barriers.

> Because block IO tends to have long pipelines and because this
> operation will stall the pipeline, it makes sense for a block IO
> subsystem to provide the possibility of implementing this sequencing
> without a complete stall, and the 'barrier' flag makes that possible.
> But that doesn't mean it is block-layer functionality.  It means (to
> me) it is common fs functionality that the block layer is helping out
> with.

I disagree - it is a function supported and defined by the block
layer. Errors returned to the filesystem are directly defined
in the block layer, the ordering guarantees are provided by the
block layer and changes in semantics appear to be defined by
the block layer......

> > 	wait for all queued I/Os to complete
> > 	call blkdev_issue_flush
> > 	schedule the write of the 'barrier' block
> > 	call blkdev_issue_flush again.
> > 
> > And not involve the filesystem at all? i.e. why should the filesystem
> > have to do this?
> 
> Certainly it could.
> However
>  a/ The the block layer would have to wait for *all* queued I/O,
>     where-as the filesystem would only have to wait for queued IO
>     which has a semantic dependence on the barrier block.  So the
>     filesystem can potentially perform the operation more efficiently.

Assuming the filesystem can do it more efficiently. What if it
can't? What if, like XFS, when barriers are turned off, the
filesystem provides *no* guarantees?

>  b/ Some block devices don't support barriers, so the filesystem needs
>     to have the mechanisms in place to do this already.

No, you turn write caching off on the drive. This is an
especially important consideration given that many older drives
lied about cache flushes being complete (i.e. they were
implemented as no-ops).

> (c/ md/raid0 doesn't track all the outstanding requests...:-)

XFS doesn't track all outstanding requests either....

> What did XFS do before the block layer supported barriers?

Either turn off write caching or use non-volatile write caches.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
