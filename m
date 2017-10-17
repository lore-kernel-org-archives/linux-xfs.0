Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59066 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932493AbdJQOoR (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 17 Oct 2017 10:44:17 -0400
Date: Tue, 17 Oct 2017 10:44:15 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] [RFC] xfs: make xfs_writepage_map extent map centric
Message-ID: <20171017144252.GA4005@localhost.localdomain>
References: <20171011081131.8029-1-david@fromorbit.com>
 <20171012161433.GA40005@bfoster.bfoster>
 <20171012232221.GV15067@dastard>
 <20171013131347.GB44461@bfoster.bfoster>
 <20171014222532.GB15067@dastard>
 <20171016121754.GD58994@bfoster.bfoster>
 <20171017015835.GQ15067@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171017015835.GQ15067@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Oct 17, 2017 at 12:58:35PM +1100, Dave Chinner wrote:
> On Mon, Oct 16, 2017 at 08:17:54AM -0400, Brian Foster wrote:
> > On Sun, Oct 15, 2017 at 09:25:32AM +1100, Dave Chinner wrote:
> > > On Fri, Oct 13, 2017 at 09:13:48AM -0400, Brian Foster wrote:
> > > > On Fri, Oct 13, 2017 at 10:22:21AM +1100, Dave Chinner wrote:
> > > > > On Thu, Oct 12, 2017 at 12:14:37PM -0400, Brian Foster wrote:
> > > > > > On Wed, Oct 11, 2017 at 07:11:31PM +1100, Dave Chinner wrote:
...
> > This is simply not the case as it pertains to how the current code deals
> > with holes. Initially I was thinking we still quietly wrote the page,
> > but that is incorrect too. Christoph added the XFS_BMAPI_DELALLOC flag
> > in commit d2b3964a ("xfs: fix COW writeback race") that alters this
> > behavior.
> 
> The XFS_BMAPI_DELALLOC behaviour is completely undocumented. there's
> nothing in the code that explains what it's for, and the commit
> message is just as baffling. I had to ask Darrick WhatTF it was and
> WhyTF it had wacky asserts for the COW fork and so on. I still
> had to infer what it was supposed to do from the original thread.
> 

Yeah, I agree wrt to the commit log and lack of documentation. I
recalled the change in behavior shortly after realizing/remembering
about the change, but perhaps that was more from the mail thread because
the commit log is pretty sparse. That said, I don't think it was an
accidental change or anything of that nature.

> > The current behavior of the broken dirty page over a hole case is that
> > we no longer silenty attempt a hole -> real allocation.  Instead,
> > writeback fails with -EIO. With this patch, that exact same broken case
> > fails the assert, but otherwise skips the dirty page without any error
> > or notification to userspace.
> 
> Yes, XFS_BMAPI_DELALLOC means we say no to unreserved allocations
> over holes in xfs_iomap_write_allocate(). But why did we even get
> to xfs_iomap_write_allocate() with a type == XFS_IO_DELALLOC
> bufferhead over a hole in the first place?
> 

It's clearly a broken/error scenario...

> We got there because we trusted the bufferhead state to match the
> underlying extent state rather than looking at the extent state to
> determine the correct action. And, as a result, we do the wrong
> thing and then throw a bandaid over it to hide the fact we've done
> the wrong thing.
> 

Eh? We trusted the bufferhead state to match the underlying extent
state. If it doesn't, we return an error.

> If xfs_map_blocks()/xfs_map_cow() land in a hole, we should *never*
> call xfs_iomap_write_allocate() because we do not have a reservation
> that allows us to allocate blocks. No ifs, no buts, it's just wrong
> and we shouldn't do it. But landing in a hole in these functions
> isn't an actually an indication of an error.
> 

The implementation is a bit hacky for sure, but to justify dropping the
error because we shouldn't be calling the function its in is a bit
pedantic IMO. The question here is more "what is the right behavior?"

> What is an error is calling xfs_iomap_write_allocate() once we've
> found a hole because we trusted cached bufferhead state that says
> "you must allocate". We know that bufferhead state can go wrong - I
> trust the extent list recrods and state far more than I trust
> bufferheads to carry the correct state, and the fact we need
> workarounds like XFS_BMAPI_DELALLOC to defend against
> inconsistencies between the incore extent state and the bufferhead
> state demonstrate that.
> 

Sure, but the recent problems in this area that I remember were XFS
bugs. Unless I'm misremembering, the most recent driver for this was
that we had at least one scenario where the page/buffer state was valid
and we (XFS) reclaimed or somehow or another failed to allocate a block
at the associated file offset. The most likely effect on the user was
the reservation warning and otherwise no impact to the data.

> > IOW, by skipping the
> > iomap_write_allocate() code unconditionally we've effectively removed an
> > error check and made the pre-existing assert logic responsible for it.
> 
> The pre-existing bufferhead assert logic is not responsible for
> skipping the iomap_write_allocate() code. The code as it stands is
> simply broken, and XFS_BMAPI_DELALLOC is just a band-aid.
> 
> The changes to combine xfs_map_cow() and xfs_map_blocks() allow us
> to detect holes correctly and so we do not even attempt to allocate
> over them. We don't need to rely on xfs_bmapi_write() to detect that
> the caller 2-3 layers up had a fuckup and asked us to allocate into
> a hole incorrectly; those higher layers now get that right by
> detecting and skipping over holes.
> 

To try and summarize... the inconsistency can either be due to incorrect
page state or incorrect extent state. We don't know which at the time
this might occur, but both have occurred in the past. The historical
behavior was to forcefully allocate a block and write the data based on
the page state. The current behavior is to return an error. The behavior
after this patch is to skip the page based on extent state, regardless
of page state.

I think the behavior in this patch is fine in the case where the page
state might be incorrect, as you've noted above. So what about in the
case where the page state is correct and the extent state is not? IOW,
if userspace wrote data that is valid and otherwise correctly sitting in
the pagecache and XFS screws up the extent state to create ahole, what
behavior is preferred? As a user, would you prefer an error or silent
data corruption?

In the end, I don't care too much about what's a band-aid or not, what
functions we should or shouldn't be calling based on layering, etc. The
important question to me is what is the right behavior in this
situation? The answer depends on which side is correct. If the extent
state is correctly a hole, then clearly we should skip the page. If the
pagecache is correct and the hole is due to a bug, then we probably want
to try and preserve the data. Since we don't really know which is which
and it's not totally safe to allocate a block, the only sane thing to do
here IMO is return an error and let userspace know the file needs
attention (and let us know there's a bug that needs fixing..).

Brian

> > So regardless of what specific buffer state checks pre-existed or
> > not, this patch subtly changes an existing error condition to an
> > assertion without any explicit intent/justification.  I can
> > understand not wanting to add new logic related to buffer heads,
> > but I don't think "buffer heads suck" is a good enough reason
> > alone to just drop the error. The safer approach is to retain the
> > error so that it's clear we need to find a better way to detect it
> > before we eliminate buffer_heads.
> 
> "the code was a band-aid, it can no longer be hit" is a perfectly
> good reason to drop it. :/
> 
> > It would be nice if we could just rely on the page state to detect the
> > error.  For example, is there any real non-erroneous case for having a
> > dirty page completely over a hole within EOF of a file?
> 
> The existing code silently skips over such pages right now.  The new
> code does the same thing, only it doesn't trust the bufferhead state
> to determine if the page lies over a hole. XFS_BMAPI_DELALLOC
> should be redundant now - I'll go remove it and see what happens...
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
