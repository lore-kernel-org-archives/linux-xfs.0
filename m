Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:37769 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751527AbdKAApQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Oct 2017 20:45:16 -0400
Date: Wed, 1 Nov 2017 11:45:13 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC PATCH 0/14] xfs: Towards thin provisioning aware filesystems
Message-ID: <20171101004513.GK5858@dastard>
References: <20171026083322.20428-1-david@fromorbit.com>
 <20171030133117.GA3535@bfoster.bfoster>
 <20171030210941.GA5858@dastard>
 <20171031112432.GA7093@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171031112432.GA7093@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Oct 31, 2017 at 07:24:32AM -0400, Brian Foster wrote:
> On Tue, Oct 31, 2017 at 08:09:41AM +1100, Dave Chinner wrote:
> > On Mon, Oct 30, 2017 at 09:31:17AM -0400, Brian Foster wrote:
> > > On Thu, Oct 26, 2017 at 07:33:08PM +1100, Dave Chinner wrote:
> > > > This patchset is aimed at filesystems that are installed on sparse
> > > > block devices, a.k.a thin provisioned devices. The aim of the
> > > > patchset is to bring the space management aspect of the storage
> > > > stack up into the filesystem rather than keeping it below the
> > > > filesystem where users and the filesystem have no clue they are
> > > > about to run out of space.
....
> > I get that "total_blocks" sounds better, but to me that's a capacity
> > measurement, not an indication of the size of the underlying address
> > space the block device has provided. m_usable_blocks is obviously a
> > capacity measurement, but I was trying to convey that m_LBA_size is
> > not a capacity measurement but an externally imposed addressing
> > limit.
> > 
> > <shrug>
> > 
> > I guess if I document it well enough m_total_blocks will work.
> > 
> 
> Hmm, yeah I see what you mean. Unfortunately I can't really think of
> anything aside from m_total_blocks or perhaps m_phys_blocks at the
> moment.

m_phys_blocks seems closer to the intent. If that's acceptible I'll
change the code to that.

> > > Finally, I tend to agree with Amir's comment with regard to
> > > shrink/growfs... at least infosar as I understand his concern. If we do
> > > support physical shrink in the future, what do we expect the interface
> > > to look like in light of this change?
> > 
> > I don't expect it to look any different. It's exactly the same as
> > growfs - thinspace filesystem will simply do a logical grow/shrink,
> > fat filesystems will need to do a physical grow/shrink
> > adding/removing AGs.
> > 
> 
> How would you physically shrink a thin filesystem?

You wouldn't. There should never be a need to do this because it a
thinspace shrink doesn't actually free any space - it's just a usage
limit. fstrim is what actually shrinks the storage space used,
regardless of the current maximum capcity of the thin filesystem.

So I don't really see any point in physically shrink a thin
filesystem because that defeats the entire purpose of having a thin
filesystem in the first place.

> > > Given that this already requires on-disk changes and the addition of a
> > > feature bit, it seems prudent to me to update the growfs API
> > > accordingly. Isn't a growfs new_usable_blocks field or some such all we
> > > really need to address that concern?
> > 
> > I really do not see any reason for changing the growfs interface
> > right now. If there's a problem in future that physical shrink
> > introduces, we can rev the interface when the problem arises.
> > 
> 
> Indeed. I'm not terribly concerned about the growfs interface, but in
> the interest of trying to make sure the point is clear... does that mean
> we'd add a new usable_blocks field to the growfs structure if/when
> physical shrink is supported?

No. growfs simply says "grow/shrink to size X" and the kernel then
determines if a physical or thin grow/shrink operation is performed
and does the work/checks appropriate to make that work.

The only thing we need to ensure is that growfs has the necessary
info to correctly set the size of the filesystem when it is doing
operations that don't want to change the size of the filesystem
(e.g. changing imaxpct).  i.e. an old growfs should be able to
grow/shrink a thin filesystem correctly without being aware it is a
thin filesystem.

> If so, doesn't that mean we'd have two
> fields that are used to logically shrink the fs, depending on interface
> version, or that we'd have some kernels that logically shrink based on
> 'newblocks' and some that don't?

No.

> The larger question I have is what do we save by not just adding
> usable_blocks to growfs_data now so the interface remains
> self-explanatory? That seems relatively minor with respect to the
> on-disk changes.

We avoid having to modify an API for no real reason. We don't change
userspace APIs unless we have an actual need, and I'm not seeing
anyone articulate an actual need to change the growfs ioctl.

Further, changing the growfs API for thinspace filesystems means
that old growfs binaries will do bad things on thinspace filesystems
because growfs doesn't do version/feature checks. Hence we have to
make thinspace grow operations work sanely for existing
XFS_IOC_FSGEOMETRY_V4 callers, and that means we can't rely on a new
XFS_IOC_GROWFSDATA ioctl just to operate on thinspace filesystems.

*If* we add physical shrink support we can rev the growfs interface
at that point in time *if we need to*. But I'm simply not convinced
we will need to change it at all...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
