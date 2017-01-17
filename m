Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:35090 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751118AbdAQOhX (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 17 Jan 2017 09:37:23 -0500
Date: Tue, 17 Jan 2017 15:37:21 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2] xfs: fix COW writeback race
Message-ID: <20170117143721.GA32641@lst.de>
References: <1484639331-2137-1-git-send-email-hch@lst.de> <20170117134421.GB12426@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170117134421.GB12426@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, darrick.wong@oracle.com

On Tue, Jan 17, 2017 at 08:44:21AM -0500, Brian Foster wrote:
> Any reason we don't try to address the core race rather than shake up
> the affected code to accommodate it?

I think there are two aspects to the whole thing.  One is the way
xfs_bmapi_write currently works is fundamentally wrong - if the
caller only needs a conversion from delalloc to real space trying
to allocate space is always wrong and we should catch it early.
The second is if we should do the eager conversion of the whole
found extent for either the data and/or the COW fork.

> I ask for a couple reasons: 1.) I'm
> not quite following the specific race from the description and 2.) I
> considered doing the exact same thing at first for the eofblocks i_size
> issue, but more digging rooted out the problem in the eofblocks code.
> This one may not be as straightforward a fix, of course... (but if not,
> the commit log should probably explain why).

My hope was that the long commit message explained the issue, but
I guess I need to go into even more details.

The writeback code (both COW and real) works like this

take ilock
read in an extent at offset O
drop ilock

if extent is delalloc:
  while !done with the whole extent
    take ilock
    convert partial extent to a real allocation
    drop ilock

But if multiple threads are doing writeback on pages next to
each other another thread might have already converted parts
of all of the extent found in the beginning to a real allocation.
That on it's own is not a problem because xfs_bmapi_write
handles a call to allocate an already real allocation as a no-op.
But with the COW code moving real extents from the COW fork to
the data fork after I/O completion this can become a problem,
because we now might not only have delalloc or real extents in
the area covered by extent returned from the inital xfs_bmapi_read
call, but also a hole in the COW work.  At which point it blows up.

As for why we're doing the eager conversion:  at least for the data
fork this was initentional to get better allocation patterns, I
remember a discussion with Dave on that a long time ago.  Maybe we
shouldn't do it for the COW for to avoid these sorts of races, but
then again without xfs_bmapi_write being stupid the race is harmless.

> What happens in this case if eof is true? It looks like got could be
> bogus, yet we still carry on using it in the post-allocation part of the
> loop.

For an initial EOF lookup it could indeed be bogus.  To properly
work it would need something like the trick xfs_bmapi_read uses
for this case.

> The fact that the allocation code breaks out of the loop if
> allocation doesn't occur is a bit of a red flag that the post-allocation
> code may very well expect to always have an allocated mapping.

The post-allocation cleanup code bust handle xfs_bmapi_allocate
returning an error before doing anything, and because of that it's
full of conditionals for everything that could or could not have
happened.

> That aside... if we do want to do something like this, I wonder whether
> it's more cleanly handled by the caller.

I don't see how it could be done in the caller - the caller wants
the bmap code to convert a delayed allocation and not allocate
entirely new blocks.  The best way to do so is to tell the bmapi
code not do allocate new blocks.  Now if you mean splitting up
xfs_bmapi_write into different functions for allocating real blocks,
converting delalloc blocks or just flipping the unwritten bit: that's
something I'd like to look into - the current interface is just
too confusing.
