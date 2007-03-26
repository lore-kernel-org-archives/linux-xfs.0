Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 25 Mar 2007 21:27:51 -0700 (PDT)
Received: from mx1.suse.de (ns.suse.de [195.135.220.2])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l2Q4Ri6p018708
	for <xfs@oss.sgi.com>; Sun, 25 Mar 2007 21:27:46 -0700
From: Neil Brown <neilb@suse.de>
Date: Mon, 26 Mar 2007 14:27:24 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17927.19372.553410.527506@notabene.brown>
Subject: Re: XFS and write barriers.
In-Reply-To: message from David Chinner on Monday March 26
References: <17923.11463.459927.628762@notabene.brown>
	<20070323053043.GD32602149@melbourne.sgi.com>
	<17923.34462.210758.852042@notabene.brown>
	<20070325041755.GJ32602149@melbourne.sgi.com>
	<17927.1031.996460.858328@notabene.brown>
	<20070326031407.GG32597093@melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs@oss.sgi.com, hch@infradead.org

On Monday March 26, dgc@sgi.com wrote:
> On Mon, Mar 26, 2007 at 09:21:43AM +1000, Neil Brown wrote:
> > My point was that if the functionality cannot be provided in the
> > lowest-level firmware (as it cannot for raid0 as there is no single
> > lowest-level firmware), then it should be implemented at the
> > filesystem level.  Implementing barriers in md or dm doesn't make any
> > sense (though passing barriers through can in some situations).
> 
> Hold on - you've said that the barrier support in a block deivce
> can change because of MD doing hot swap. Now you're saying
> there is no barrier implementation in md. Can you explain
> *exactly* what barrier support there is in MD?

For all levels other than md/raid1, md rejects bio_barrier() requests
as -EOPNOTSUPP.

For raid1 it tests barrier support when writing the superblock and the
if all devices support barriers, then md/raid1 will allow
bio_barrier() down.  If it gets an unexpected failure it just rewrites
it without the barrier flag and fails any future write requests (which
isn't ideal, but is the best available, and should happen effectively
never).

So md/raid1 barrier support is completely dependant on the underlying
devices.  md/raid1 is aware of barriers but does not *implement*
them.  Does that make it clearer?

> > The most straight-forward way to implement this is to make sure all
> > preceding blocks have been written before writing the barrier block.
> > All filesystems should be able to do this (if it is important to them).
>                                              ^^^^^^^^^^^^^^^^^^^^^^^^^^
> 
> And that is the key point - XFS provides no guarantee that your
> data is on spinning rust other than I/O barriers when you have
> volatile write caches.
> 
> IOWs, if you turn barriers off, we provide *no guarantees*
> about the consistency of your filesystem after a power failure
> if you are using volatile write caching. This mode is for
> use with non-cached disks or disks with NVRAM caches where there
> is no need for barriers.

But.... as the block layer can re-order writes, even non-cached disks
could get the writes in a different or to the order in which you sent
them.

I have a report of xfs over md/raid1 going about 10% faster once we
managed to let barrier writes through, so presumably XFS does
something different if barriers are not enabled ???  What does it do
differently?


> 
> > Because block IO tends to have long pipelines and because this
> > operation will stall the pipeline, it makes sense for a block IO
> > subsystem to provide the possibility of implementing this sequencing
> > without a complete stall, and the 'barrier' flag makes that possible.
> > But that doesn't mean it is block-layer functionality.  It means (to
> > me) it is common fs functionality that the block layer is helping out
> > with.
> 
> I disagree - it is a function supported and defined by the block
> layer. Errors returned to the filesystem are directly defined
> in the block layer, the ordering guarantees are provided by the
> block layer and changes in semantics appear to be defined by
> the block layer......

chuckle....
You can tell we are on different sides of the fence, can't you ?

There is certainly some validity in your position...

> 
> > > 	wait for all queued I/Os to complete
> > > 	call blkdev_issue_flush
> > > 	schedule the write of the 'barrier' block
> > > 	call blkdev_issue_flush again.
> > > 
> > > And not involve the filesystem at all? i.e. why should the filesystem
> > > have to do this?
> > 
> > Certainly it could.
> > However
> >  a/ The the block layer would have to wait for *all* queued I/O,
> >     where-as the filesystem would only have to wait for queued IO
> >     which has a semantic dependence on the barrier block.  So the
> >     filesystem can potentially perform the operation more efficiently.
> 
> Assuming the filesystem can do it more efficiently. What if it
> can't? What if, like XFS, when barriers are turned off, the
> filesystem provides *no* guarantees?

(Yes.... Ted T'so like casting aspersions on XFS... I guess this is
why :-)

Is there some mount flag to say "cope without barriers" or "require
barriers" ??
I can imagine implementing barriers in raid5 (which keeps careful
track of everything) but I suspect it would be a performance hit.  It
might be nice if the sysadmin has to explicitly ask...

For that matter, I could get raid1 to reject replacement devices that
didn't support barriers, if there was a way for the filesystem to
explicitly ask for them.  I think we are getting back to interface
issues, aren't we? 

> 
> > (c/ md/raid0 doesn't track all the outstanding requests...:-)
> 
> XFS doesn't track all outstanding requests either....

That surprises me... but maybe it shouldn't.


Thanks.
NeilBrown
