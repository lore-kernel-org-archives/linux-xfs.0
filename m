Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 05 Jun 2007 01:23:50 -0700 (PDT)
Received: from astra.simleu.ro (astra.simleu.ro [80.97.18.177])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l558NjWt020118
	for <xfs@oss.sgi.com>; Tue, 5 Jun 2007 01:23:47 -0700
Date: Tue, 5 Jun 2007 10:00:12 +0200
From: Iustin Pop <iusty@k1024.org>
Subject: Re: XFS shrink functionality
Message-ID: <20070605080012.GA10677@teal.hq.k1024.org>
References: <1180715974.10796.46.camel@localhost> <20070604001632.GA86004887@sgi.com> <20070604084154.GA8273@teal.hq.k1024.org> <20070604092115.GX85884050@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070604092115.GX85884050@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Ruben Porras <nahoo82@gmail.com>, xfs@oss.sgi.com, cw@f00f.org

On Mon, Jun 04, 2007 at 07:21:15PM +1000, David Chinner wrote:
> > allocated on an available AG and when you remove the originals, the
> > to-be-shrinked AGs become free. Yes, utterly non-optimal, but it was the
> > simplest way to do it based on what I knew at the time.
> 
> Not quite that simple, unfortunately. You can't leave the
> AGs locked in the same way we do for a grow because we need
> to be able to use the AGs to move stuff about and that
> requires locking them. Hence we need a separate mechanism
> to prevent allocation in a given AG outside of locking them.
> 
> Hence we need:
> 
> 	- a transaction to mark AGs "no-allocate"
> 	- a transaction to mark AGs "allocatable"
> 	- a flag in each AGF/AGI to say the AG is available for
> 	  allocations (persistent over crashes)
> 	- a flag in the per-ag structure to indicate allocation
> 	  status of the AG.
> 	- everywhere we select an AG for allocation, we need to
> 	  check this flag and skip the AG if it's not available.
> 
> FWIW, the transactions can probably just be an extension of
> xfs_alloc_log_agf() and xfs_alloc_log_agi()....

A question: do you think that the cost of having this in the code
(especially the last part, check that flag in every allocation function)
is acceptable? I mean, let's say one would write the patch to implement
all this. Does it have a chance to be accepted? Or will people say it's
only bloat? ...


> > I was
> > more thinking that the offline-AG should be a bit on the AG that could
> > be changed by the admin (like xfs_freeze); this could also help for
> > other reasons than shrink (when on a big FS some AGs lie on a physical
> > device and others on a different device, and you would like to restrict
> > writes to a given AG, as much as possible).
> 
> Yes, that's exactly what I'm talking about ;)
Ah, I see now what did you mean by having a transaction for
locking/unlocking AGs for allocation.

> Yeah, 1) and 4) are separable parts of the problem and can be done
> in any order. 2) can be implemented relatively easily as stated
> above.
> 
> 3) is the hard one - we need to find the owner of each block
> (metadata and data) remaining in the AGs to be removed. This may be
> a directory btree block, a inode extent btree block, a data block,
> and extended attr block, etc. Moving the data blocks is easy to
> do (swap extents), but moving the metadata blocks is a major PITA
> as it will need to be done transactionally and that will require
> a bunch of new (complex) code to be written, I think. It will be
> of equivalent complexity to defragmenting metadata....
> 
> If we ignore the metadata block problem then finding and moving the
> data blocks should not be a problem - swap extents can be used for
> that as well - but it will be extremely time consuming and won't
> scale to large filesystem sizes....

So given these caveats, is there a chance that a) this will be actually
useful and b) will this be accepted?

The last time I tried to work on this there has been no real feedback
and I'm thinking that maybe the code will be too intrusive and will give
to little gain to be accepted.

Thanks for your comments,
iustin
