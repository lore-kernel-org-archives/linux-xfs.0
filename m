Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1050.oracle.com ([156.151.31.82]:38201 "EHLO
        userp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750888AbdAQTSI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Jan 2017 14:18:08 -0500
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81])
        by userp1050.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v0HIfB3j020825
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 17 Jan 2017 18:41:11 GMT
Date: Tue, 17 Jan 2017 10:39:00 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2] xfs: fix COW writeback race
Message-ID: <20170117183900.GG5883@birch.djwong.org>
References: <1484639331-2137-1-git-send-email-hch@lst.de>
 <20170117134421.GB12426@bfoster.bfoster>
 <20170117143721.GA32641@lst.de>
 <20170117171449.GC12426@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170117171449.GC12426@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Tue, Jan 17, 2017 at 12:14:51PM -0500, Brian Foster wrote:
> On Tue, Jan 17, 2017 at 03:37:21PM +0100, Christoph Hellwig wrote:
> > On Tue, Jan 17, 2017 at 08:44:21AM -0500, Brian Foster wrote:
> > > Any reason we don't try to address the core race rather than shake up
> > > the affected code to accommodate it?
> > 
> > I think there are two aspects to the whole thing.  One is the way
> > xfs_bmapi_write currently works is fundamentally wrong - if the
> > caller only needs a conversion from delalloc to real space trying
> > to allocate space is always wrong and we should catch it early.
> > The second is if we should do the eager conversion of the whole
> > found extent for either the data and/or the COW fork.
> > 
> 
> Makes sense. I agree that the former is probably the right thing to do,
> it just seems more like an error check than a solution for a race. The
> second is probably a bigger question, as I assume we do that to request
> as large allocations as possible.

I'm under the impression that yes, we do #2 to maximize request sizes.
AFAICT this patch preserves that behavior and gets rid of the behavior
where cow delalloc conversion creates real extents where there
previously were holes.

> > > I ask for a couple reasons: 1.) I'm
> > > not quite following the specific race from the description and 2.) I
> > > considered doing the exact same thing at first for the eofblocks i_size
> > > issue, but more digging rooted out the problem in the eofblocks code.
> > > This one may not be as straightforward a fix, of course... (but if not,
> > > the commit log should probably explain why).
> > 
> > My hope was that the long commit message explained the issue, but
> > I guess I need to go into even more details.
> > 
> > The writeback code (both COW and real) works like this
> > 
> > take ilock
> > read in an extent at offset O
> > drop ilock
> > 
> > if extent is delalloc:
> >   while !done with the whole extent
> >     take ilock
> >     convert partial extent to a real allocation
> >     drop ilock
> > 
> > But if multiple threads are doing writeback on pages next to
> > each other another thread might have already converted parts
> > of all of the extent found in the beginning to a real allocation.
> > That on it's own is not a problem because xfs_bmapi_write
> > handles a call to allocate an already real allocation as a no-op.
> > But with the COW code moving real extents from the COW fork to
> > the data fork after I/O completion this can become a problem,
> > because we now might not only have delalloc or real extents in
> > the area covered by extent returned from the inital xfs_bmapi_read
> > call, but also a hole in the COW work.  At which point it blows up.
> > 
> 
> Got it, thanks. So all of the writeback stuff is protected via
> page/buffer locks, and even if we still had those locks, it doesn't
> matter because the same extent is obviously covered by many page/buffer
> objects.
> 
> > As for why we're doing the eager conversion:  at least for the data
> > fork this was initentional to get better allocation patterns, I
> > remember a discussion with Dave on that a long time ago.  Maybe we
> > shouldn't do it for the COW for to avoid these sorts of races, but
> > then again without xfs_bmapi_write being stupid the race is harmless.
> > 
> 
> Yeah, and doing otherwise may break the assumption that larger delallocs
> produce larger physical allocs (re: cowextsz hint and potentially
> preallocation).

Yep.

> > > What happens in this case if eof is true? It looks like got could be
> > > bogus, yet we still carry on using it in the post-allocation part of the
> > > loop.
> > 
> > For an initial EOF lookup it could indeed be bogus.  To properly
> > work it would need something like the trick xfs_bmapi_read uses
> > for this case.
> > 
> 
> That seems reasonable so long as we skip the parts of the loop that are
> expecting a real (non-hole) startblock.
> 
> > > The fact that the allocation code breaks out of the loop if
> > > allocation doesn't occur is a bit of a red flag that the post-allocation
> > > code may very well expect to always have an allocated mapping.
> > 
> > The post-allocation cleanup code bust handle xfs_bmapi_allocate
> > returning an error before doing anything, and because of that it's
> > full of conditionals for everything that could or could not have
> > happened.
> > 
> 
> We have the following in the need_alloc block:
> 
>                         error = xfs_bmapi_allocate(&bma);
>                         if (error)
>                                 goto error0;
>                         if (bma.blkno == NULLFSBLOCK)
>                                 break;
> 
> ... which breaks out of the loop on error or allocation failure. The
> first call after that block is xfs_bmapi_trim_map(), which uses got
> without any consideration for holes that I can see.

Wait, what?  The break gets us out of the while loop, not the
"if (inhole || wasdelay)" clause that precedes the _trim_map.

The while loop ends at "*nmap = n", correct?  So the NULLFSBLOCK case
shouldn't be calling _trim_map with uninitialized got.

> > > That aside... if we do want to do something like this, I wonder whether
> > > it's more cleanly handled by the caller.
> > 
> > I don't see how it could be done in the caller - the caller wants
> > the bmap code to convert a delayed allocation and not allocate
> > entirely new blocks.  The best way to do so is to tell the bmapi
> > code not do allocate new blocks.  Now if you mean splitting up
> > xfs_bmapi_write into different functions for allocating real blocks,
> > converting delalloc blocks or just flipping the unwritten bit: that's
> > something I'd like to look into - the current interface is just
> > too confusing.
> 
> Things like the above had me thinking it might be more clear to
> explicitly read the extent and check for delalloc in the caller while
> under the appropriate lock (and if XFS_COW_FORK). That's kind of what I
> was alluding to above wrt to closing the race. That's just an idea,
> however, and doesn't necessarily improve the error handling in the way
> that this patch does (to avoid the transaction overrun). Given that, I'm
> not against what this patch is currently doing so long as we fix up the
> rest of the loop. Your idea of xfs_bmapi_convert() or some such sounds
> like a nice potential cleanup at some point too.

I'd wondered when I was writing all the cow code if it would make the
code easier to understand if the _bmapi_write was split into different
frontend wrappers of the underlying implementation.  It's a little weird
that for a remapping you have to stuff the new physical block in a
_fsblock_t and pass that in as a pointer argument.

--D

> 
> Brian
> 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
