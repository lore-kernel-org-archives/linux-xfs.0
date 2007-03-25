Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 25 Mar 2007 16:22:11 -0700 (PDT)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l2PNM66p030936
	for <xfs@oss.sgi.com>; Sun, 25 Mar 2007 16:22:07 -0700
From: Neil Brown <neilb@suse.de>
Date: Mon, 26 Mar 2007 09:21:43 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17927.1031.996460.858328@notabene.brown>
Subject: Re: XFS and write barriers.
In-Reply-To: message from David Chinner on Sunday March 25
References: <17923.11463.459927.628762@notabene.brown>
	<20070323053043.GD32602149@melbourne.sgi.com>
	<17923.34462.210758.852042@notabene.brown>
	<20070325041755.GJ32602149@melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs@oss.sgi.com, hch@infradead.org

On Sunday March 25, dgc@sgi.com wrote:
> > Barriers only make sense inside drive firmware.
> 
> I disagree. e.g. Barriers have to be handled by the block layer to
> prevent reordering of I/O in the request queues as well. The
> block layer is responsible for ensuring barrier I/Os, as
> indicated by the filesystem, act as real barriers.

Absolutely.  The block layer needs to understand about barriers and
allow them to do their job, which means not re-ordering requests
around barriers.
My point was that if the functionality cannot be provided in the
lowest-level firmware (as it cannot for raid0 as there is no single
lowest-level firmware), then it should be implemented at the
filesystem level.  Implementing barriers in md or dm doesn't make any
sense (though passing barriers through can in some situations).

> 
> > Trying to emulate it
> > in the md layer doesn't make any sense as the filesystem is in a much
> > better position to do any emulation required.
> 
> You're saying that the emulation of block layer functionality is the
> responsibility of layers above the block layer. Why is this not
> considered a layering violation?

:-)
Maybe it depends on your perspective.  I think this is filesystem
layer functionality.  Making sure blocks are written in the right
order sounds like something that the filesystem should be primarily
responsible for.

The most straight-forward way to implement this is to make sure all
preceding blocks have been written before writing the barrier block.
All filesystems should be able to do this (if it is important to
them).

Because block IO tends to have long pipelines and because this
operation will stall the pipeline, it makes sense for a block IO
subsystem to provide the possibility of implementing this sequencing
without a complete stall, and the 'barrier' flag makes that possible.
But that doesn't mean it is block-layer functionality.  It means (to
me) it is common fs functionality that the block layer is helping out
with.

> > 
> > There should never be a possibility of filesystem corruption.
> > If the a barrier request fails, the filesystem should:
> >   wait for any dependant request to complete
> >   call blkdev_issue_flush
> >   schedule the write of the 'barrier' block
> >   call blkdev_issue_flush again.
> 
> IOWs, the filesystem has to use block device calls to emulate a block device
> barrier I/O. Why can't the block layer, on reception of a barrier write
> and detecting that barriers are no longer supported by the underlying
> device (i.e. in MD), do:
> 
> 	wait for all queued I/Os to complete
> 	call blkdev_issue_flush
> 	schedule the write of the 'barrier' block
> 	call blkdev_issue_flush again.
> 
> And not involve the filesystem at all? i.e. why should the filesystem
> have to do this?

Certainly it could.
However
 a/ The the block layer would have to wait for *all* queued I/O,
    where-as the filesystem would only have to wait for queued IO
    which has a semantic dependence on the barrier block.  So the
    filesystem can potentially perform the operation more efficiently.
 b/ Some block devices don't support barriers, so the filesystem needs
    to have the mechanisms in place to do this already.  Why duplicate
    it in the block layer?
(c/ md/raid0 doesn't track all the outstanding requests...:-)

I think the block device should support barriers when it can do so
more efficiently than the filesystem.  For a single SCSI drive, it
can.  For a logical volume striped over multiple physical devices, it
cannot.

> 
> > My understand is that that sequence is as safe as a barrier, but maybe
> > not as fast.
> 
> Yes, and my understanding is that the block device is perfectly capable
> of implementing this just as safely as the filesystem.
> 

But possibly not as efficiently...

What did XFS do before the block layer supported barriers?


> > The patch looks at least believable.  As you can imagine it is awkward
> > to test thoroughly.
> 
> As well as being pretty much impossible to test reliably with an
> automated testing framework. Hence so ongoing test coverage will
> approach zero.....

This is a problem with barriers in general.... it is very hard to test
that the data is encoded on the platter at any given time :-(

NeilBrown
