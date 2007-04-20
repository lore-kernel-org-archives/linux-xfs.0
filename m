Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 19 Apr 2007 22:34:21 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l3K5YFfB025985
	for <xfs@oss.sgi.com>; Thu, 19 Apr 2007 22:34:17 -0700
Date: Fri, 20 Apr 2007 15:34:11 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: review: allocate bmapi args
Message-ID: <20070420053411.GM32602149@melbourne.sgi.com>
References: <20070419072505.GS48531920@melbourne.sgi.com> <1176969062.6273.169.camel@edge> <20070419082331.GW48531920@melbourne.sgi.com> <1177044117.6273.203.camel@edge>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1177044117.6273.203.camel@edge>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Nathan Scott <nscott@aconex.com>
Cc: David Chinner <dgc@sgi.com>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Fri, Apr 20, 2007 at 02:41:57PM +1000, Nathan Scott wrote:
> On Thu, 2007-04-19 at 18:23 +1000, David Chinner wrote:
> > ...
> > > Are you sure this is legit though?
> > 
> > It *must* be. We already rely on being able to do substantial
> > amounts of allocation in this path....
> 
> Not necessarily, we only sometimes (for some values of BMAPI flags
> I mean) do memory allocations.
> 
> > ...
> > We modify the incore extent list as it grows and shrinks in this
> > path. It is critical that we are able to allocate at least small 
> 
> Well, not always.  For cases where we modify the extents we must
> call in here with Steve's funky I'm-in-a-transaction process-flag
> set, which is the secret handshake for the memory allocator to not
> use GFP_FS.

*nod*

> For cases where we are only reading the extent list,
> we would not be doing allocations before and we'd not be protected
> by that extra magic.  So now those paths can start getting ENOMEM
> in places where that wouldn't have happened before.. I guess that
> filesystem shutdowns could result, possibly.

Well, with a sleeping allocation we'll get hangs, not shutdowns.
Quite frankly, hangs are far easier to debug than shutdowns. If it
is really does become an issue, we could use mempools here - we
can guarantee that we will return the object to the pool if we
don't hang on some other allocation and hence we'd always be
able to make progress.

However, I'm not sure I want to go that far without having actually
seen a normal allocation cause a problem here and right now I think
that saving ~250 bytes of stack (~10-15% of XFS's stack usage on
ia32!) through the paths we know blow is substantial.

> > FWIW, I have done low memory testing and I wasn't about to trigger
> > any problems.....
> 
> It would be a once-in-a-blue-moon type problem though, unfortunately;
> one of the really-really-hard to trigger types of problem.

Yes, that it is. But a sysrq-t will point out the problem
immediately as we'll see processes hung trying to do memory
allocation.

> > > (Oh, and why the _zalloc?  Could just do an _alloc, since previous
> > > code was using non-zeroed memory - so, should have been filling in
> > > all fields).
> > 
> > Habit. And it doesn't hurt performance at all - we've got to take
> 
> Hrmmm... is there any point in having a non-zeroing interface at
> all then?

Sorry - i should have said that "for small allocations like this it
doesn't hurt performance" - the cycles consumed by the allocation
and lost in the initial cacheline fetch are far, far greater than
those spent in zeroing part of a cacheline once it's accessable.

> I thought the non-zeroing version was about all using
> the fact that you know you're going to overwrite all the fields
> anyway shortly, so theres no point zeroing initially...

Zeroing causes sequential access to cachelines and hence hardware
prefetchers can operate quickly and reduce the number of CPU stalls
compared to filling out the structure in random order. And some CPUs
can zero-fill cachelines without having fetched them from memory
(PPC can do this IIRC) so you don't even stall the CPU....

But there's still plenty of cases where you don't want to touch
some or all of the allocated region (e.g. you're about to memcpy()
something into it) so we still need the non-zeroing version of
the allocator...

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
