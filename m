Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:17233 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751691AbdJ3VKW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 Oct 2017 17:10:22 -0400
Date: Tue, 31 Oct 2017 08:09:41 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC PATCH 0/14] xfs: Towards thin provisioning aware filesystems
Message-ID: <20171030210941.GA5858@dastard>
References: <20171026083322.20428-1-david@fromorbit.com>
 <20171030133117.GA3535@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171030133117.GA3535@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Oct 30, 2017 at 09:31:17AM -0400, Brian Foster wrote:
> On Thu, Oct 26, 2017 at 07:33:08PM +1100, Dave Chinner wrote:
> > This patchset is aimed at filesystems that are installed on sparse
> > block devices, a.k.a thin provisioned devices. The aim of the
> > patchset is to bring the space management aspect of the storage
> > stack up into the filesystem rather than keeping it below the
> > filesystem where users and the filesystem have no clue they are
> > about to run out of space.
> > 
> 
> Just a few high level comments/thoughts after a very quick pass..
> 
> ...
> > The patchset has several parts to it. It is built on a 4.14-rc5
> > kernel with for-next and Darrick's scrub tree from a couple of days
> > ago merged into it.
> > 
> > The first part of teh series is a growfs refactoring. This can
> > probably stand alone, and the idea is to move the refactored
> > infrastructure into libxfs so it can be shared with mkfs. This also
> > cleans up a lot of the cruft in growfs and so makes it much easier
> > to add the changes later in the series.
> > 
> 
> It'd be nice to see this as a separate patchset. It does indeed seem
> like it could be applied before all of the other bits are worked out.

Yes, i plan to do that, and with it separated also get it into shape
where it can be shared with mkfs via libxfs.

> > The second part of the patchset moves the functionality of
> > sb_dblocks into the struct xfs_mount. This provides the separation
> > of address space checks and capacty related calculations that the
> > thinspace mods require. This also fixes the problem of freshly made,
> > empty filesystems reporting 2% of the space as used.
> > 
> 
> This all seems mostly sane to me. FWIW, the in-core fields (particularly
> ->m_LBA_size) strike me as oddly named. "LBA size" strikes me as the
> addressable range of the underlying device, regardless of fs size (but I
> understand that's not how it's used here). If we have ->m_usable_blocks,
> why not name the other something like ->m_total_blocks or just
> ->m_blocks? That suggests to me that the fields are related, mutable,
> accounted in units of blocks, etc. Just a nit, though.

Yeah, I couldn't think of a better pair of names - the point I was
trying to get across is that what we call "dblocks" is actually an
assumption about the structure of the block device address space
we are working on. i.e. that it's a contiguous, linear address space
from 0 to "dblocks".

I get that "total_blocks" sounds better, but to me that's a capacity
measurement, not an indication of the size of the underlying address
space the block device has provided. m_usable_blocks is obviously a
capacity measurement, but I was trying to convey that m_LBA_size is
not a capacity measurement but an externally imposed addressing
limit.

<shrug>

I guess if I document it well enough m_total_blocks will work.


> That aside, it also seems like this part could technically stand as an
> independent change. 

*nod*

> > The XFS_IOC_FSGEOMETRY ioctl needed to be bumped to a new version
> > because the structure needed growing.
> > 
> > Finally, there's the patches that provide thinspace support and the
> > growfs mods needed to grow and shrink.
> > 
> 
> I still think there's a gap related to fs and bdev block size that needs
> to be addressed with regard to preventing pool depletion, but I think
> that can ultimately be handled with documentation. I also wonder a bit
> about consistency between online modifications to usable blocks and fs
> blocks that might have been allocated but not yet written (i.e.,
> unwritten extents and the log on freshly created filesystems). IOW,
> shrinking the filesystem in such cases may not limit pool allocation in
> the way a user might expect.
> 
> Did we ever end up with support for bdev fallocate?

Yes, we do have that.

> If so, I wonder if
> for example it would be useful to fallocate the physical log at mount or
> mkfs time for thin enabled fs'.

We zero the log and stamp it with cycle headers, so it will already
be fully allocated in th eunderlying device after running mkfs.

> The unwritten extent case may just be a
> matter of administration sanity since the filesystem shrink will
> consider those as allocated blocks and thus imply that the fs expects
> the ability to write them.

Yes, that is correct. To make things work as expected, we'll need
to propagating fallocate calls to the block device from the
filesystem when mounted. There's a bunch of stuff there that we can
add once the core "this is a thin filesystem" awareness has been
added.

> Finally, I tend to agree with Amir's comment with regard to
> shrink/growfs... at least infosar as I understand his concern. If we do
> support physical shrink in the future, what do we expect the interface
> to look like in light of this change?

I don't expect it to look any different. It's exactly the same as
growfs - thinspace filesystem will simply do a logical grow/shrink,
fat filesystems will need to do a physical grow/shrink
adding/removing AGs.

I suspect Amir is worried about the fact that I put "LBA_size"
in geom.datablocks instead of "usable_space" for thin-aware
filesystems (i.e. I just screwed up writing the new patch). Like I
said, I haven't updated the userspace stuff yet, so the thinspace
side of that hasn't been tested yet. If I screwed up xfs_growfs (and
I have because some of the tests are reporting incorrect
post-grow sizes on fat filesytsems) I tend to find out as soon as I
run it.

Right now I think using m_LBA_size and m_usable_space in the geom
structure was a mistake - they should remain the superblock values
because otherwise the hidden metadata reservations can affect what
is reported to userspace, and that's where I think the test failures
are coming from....


> FWIW, I also think there's an
> element of design/interface consistency to the argument (aside from the
> concern over the future of the physical shrink api). We've separated
> total blocks from usable blocks in other userspace interfaces
> (geometry). Not doing so for growfs is somewhat inconsistent, and also
> creates confusion over the meaning of newblocks in different contexts.

It has to be done for the geometry info so that xfs_info can report
the thinspace size of the filesytem in addition to the physical
size. It does not need to be done to make growfs work correctly.

> Given that this already requires on-disk changes and the addition of a
> feature bit, it seems prudent to me to update the growfs API
> accordingly. Isn't a growfs new_usable_blocks field or some such all we
> really need to address that concern?

I really do not see any reason for changing the growfs interface
right now. If there's a problem in future that physical shrink
introduces, we can rev the interface when the problem arises.

Cheers

Dave.
-- 
Dave Chinner
david@fromorbit.com
