Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 19 Apr 2007 01:23:42 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l3J8NafB019495
	for <xfs@oss.sgi.com>; Thu, 19 Apr 2007 01:23:38 -0700
Date: Thu, 19 Apr 2007 18:23:31 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: review: allocate bmapi args
Message-ID: <20070419082331.GW48531920@melbourne.sgi.com>
References: <20070419072505.GS48531920@melbourne.sgi.com> <1176969062.6273.169.camel@edge>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1176969062.6273.169.camel@edge>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Nathan Scott <nscott@aconex.com>
Cc: David Chinner <dgc@sgi.com>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Thu, Apr 19, 2007 at 05:51:02PM +1000, Nathan Scott wrote:
> On Thu, 2007-04-19 at 17:25 +1000, David Chinner wrote:
> > 
> > +       bma = kmem_zalloc(sizeof(xfs_bmalloca_t), KM_SLEEP);
> > +       if (!bma)
> > +               return XFS_ERROR(ENOMEM); 
> 
> I guess you meant KM_NOSLEEP? 

No, I meant a sleeping allocation. I guess that mea I don't
need the error handling....

> Are you sure this is legit though?

It *must* be. We already rely on being able to do substantial
amounts of allocation in this path....

> (are all callers going to be able to handle this?)  I'm thinking
> of the writeout paths where we're doing space allocation (unwritten
> extent conversion comes through here too) in order to free up some
> page cache so other memory allocs elsewhere can proceed.  I don't
> see any other memory allocations in this area of the code, so I
> guess I'd be treading really carefully here..

We modify the incore extent list as it grows and shrinks in this
path. It is critical that we are able to allocate at least small
amounts of memory in these writeback paths, and we currently do that
with kmem_alloc(KM_SLEEP). A quick search of the xfs_iext_*
functions shows lots of allocations are done in manipulating
the incore extents....

Then there's needing new pages in the page cache and xfs_buf_t's
if we trigger a btree split duringthe allocation, and so on.

IOWS, there's plenty of far larger allocations down through this
path already, and if any one of them doesn't succeed we are
pretty much fscked. given that we haven't had any reports of
writeback deadlocks since the new incore extent handling went
in, I think small allocations like this are not a problem.

FWIW, I have done low memory testing and I wasn't about to trigger
any problems.....

> (Oh, and why the _zalloc?  Could just do an _alloc, since previous
> code was using non-zeroed memory - so, should have been filling in
> all fields).

Habit. And it doesn't hurt performance at all - we've got to take
that cache miss somewhere along the line....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
