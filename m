Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 22 Jul 2008 17:05:00 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6N04tco024191
	for <xfs@oss.sgi.com>; Tue, 22 Jul 2008 17:04:57 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C06C6191C700
	for <xfs@oss.sgi.com>; Tue, 22 Jul 2008 17:06:04 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id VPU6WQCRlyMEhzHJ for <xfs@oss.sgi.com>; Tue, 22 Jul 2008 17:06:04 -0700 (PDT)
Date: Wed, 23 Jul 2008 10:05:48 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/4] XFS: Use the inode tree for finding dirty inodes
Message-ID: <20080723000548.GG5947@disturbed>
References: <1216556394-17529-1-git-send-email-david@fromorbit.com> <1216556394-17529-3-git-send-email-david@fromorbit.com> <20080722042829.GB27123@infradead.org> <20080722053019.GI6761@disturbed> <20080722072733.GA15376@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080722072733.GA15376@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Tue, Jul 22, 2008 at 03:27:33AM -0400, Christoph Hellwig wrote:
> On Tue, Jul 22, 2008 at 03:30:19PM +1000, Dave Chinner wrote:
> > Until the method we'll use for referencing VFS inodes in core XFS
> > code is clear, I'd rather leave it consistent with the rest of the code.
> 
> I would expect your cleanups in this area to go in before this patch,
> or not?

The cleanups are on top of these patches. I'll have to reorder and
redo them if they are to go in first...

> > As it is, I expect that this code will be revisited several times as
> > new functionality is added (e.g. combining the VFS and XFS inodes)
> > because that will change the way we interface with VFS and XFS inodes.
> > Much of this vnode specific code will change at that time; I'd
> > rather just change it once when the time is appropriate than have
> > to change it multiple times....
> 
> Well, it's not vnode specific code.  bhv_vnode_t is just a typedef for
> struct inode and the various functions dealing with it are trivial
> wrapper, many of them in fact expanding to no code at all.

Right, but we are still using bhv_vnode_t in core XFS code, not
struct inode. There haven't been patches to decide that one way or
another.

> But maybe
> killing this syntactic sugar should be a separate patch.

I think so - do it once and once only.

> I only fear
> we'll never get it in with the current review and commit latencies
> for XFS :(

I can see this being a big issue in the not-too-distant future.....

> > > This needs a big comment on why you're using the gang lookup for
> > > a single lookup.  I guess that's because the gang lookup skips to
> > > the next actually existing entry instead of returning NULL, but that's
> > > not really obvious to the reader.
> > 
> > Fair enough. This was later in the original series where this was
> > a dirty tag lookup and didn't need commenting ;)
> 
> Actually even then a comment describing why we want a gang lookup
> when just looking up a single element might be a good idea.

Sure - I added that.

> On the
> other hand I wonder whether we might actually want to use the gang
> lookups, the unconditional igrab is probably cheaper than lots of
> radix tree lookups.

Yes, agreed, and that is the way I'm heading. I want to get
everything working against the radix tree before attempting
to optimise the lookups.

The next steps are:

	- combine the XFS + VFS inodes into one structure so that we
	  can simplify inode lookup.
	- bypass the linux icache so all lookups run from the radix
	  tree. This involves adding our own dirty VFS inode
	  tracking. This initially just uses the VFS superblock
	  dirty list like the generic code
	- expand the dirty inode tracking to setting a tag in the
	  radix tree.
	- changing radix tree walkers looking for dirty inodes to
	  use tag lookups - this requires adding interfaces to the
	  radix tree code
	- Use a tag in the radix tree to mark inodes for reclaim.
	- change reclaim to use a radix tree walk.
	- changing radix tree walkers to all use gang and gang-tag
	  lookups - this requires adding interfaces to the radix
	  tree code
	- factor the individual radix tree walk implementations once
	  commonalities are obvious.

This is just basic groundwork. The interesting stuff starts after
this - separating data and inode flushing, avoiding RMW cycles in
xfs_iflush, writeback aggregation beyond a single inode cluster,
multi-level caching and cache compression, RCU locking, thread pools
to parallelise tree walks, and so on.

There's a bunch of stuff in the pipeline - this is the basic
groundwork needed to catch it all effectively...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
