Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 23 Apr 2007 15:33:13 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l3NMX7fB003514
	for <xfs@oss.sgi.com>; Mon, 23 Apr 2007 15:33:10 -0700
Date: Tue, 24 Apr 2007 08:32:57 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: review: allocate alloc args
Message-ID: <20070423223257.GM32602149@melbourne.sgi.com>
References: <20070419073216.GT48531920@melbourne.sgi.com> <20070423212201.GB13572@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070423212201.GB13572@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: David Chinner <dgc@sgi.com>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Mon, Apr 23, 2007 at 10:22:01PM +0100, Christoph Hellwig wrote:
> On Thu, Apr 19, 2007 at 05:32:16PM +1000, David Chinner wrote:
> > 
> > Save some stack space in the critical allocator paths
> > by allocating the xfs_alloc_arg_t structures (104 bytes
> > on 64bit, 88 bytes on 32bit systems) rather than placing
> > them on the stack.
> > 
> > There can be more than one of these structures on the stack
> > through the critical allocation path (e.g. xfs_bmap_btalloc()
> > and xfs_alloc_fix_freelist()) so there are significant
> > savings to be had here...
> 
> I don't like doing even more dynamic allocations that deep
> down in the stack.

I'm not a big fan of it either, but I don't really see any other
option here. We need a bunch of temporary space for structures
*somewhere*, and if there isn't enough stack space then it's
got to come frm somewhere else.

> Can we try another approach and see if
> we really need the full structure in all places but could
> rather pass down a few arguments or a smaller structure instead?

We use all the variables in the xfs_bmalloca_t structure when it is
passed, and we use most (all?) of the args in xfs_alloc_args_t in
the critical spots so I'm not sure whether this approach could gain
us much.

Given that both you and Nathan has expressed concern about these
two alloc arg patches, I'm going to hold off doing anythinng with
them. We're caught between a rock and a hard place here - if we
use too much stack and then can't dynamically allocate safely then
I don't really see that there is that much we can do to reduce stack
usage....

> I've done some work on that in the dir good with quite good results
> a while ago (and yes, I need to bring it up to date and send it out)

Sounds interesting - I'll have a closer look at this in the
allocator context.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
