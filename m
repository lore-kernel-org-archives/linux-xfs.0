Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:32344 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S935589AbdI0A4I (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Sep 2017 20:56:08 -0400
Date: Wed, 27 Sep 2017 10:43:02 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Rationale for hardware RAID 10 su, sw values in FAQ
Message-ID: <20170927004302.GB3666@dastard>
References: <b8c45869-849f-5124-f74f-68da0f9f34d7@mcneill.gen.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b8c45869-849f-5124-f74f-68da0f9f34d7@mcneill.gen.nz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ewen McNeill <xfs@ewen.mcneill.gen.nz>
Cc: linux-xfs@vger.kernel.org

On Tue, Sep 26, 2017 at 09:54:28PM +1300, Ewen McNeill wrote:
> The FAQ:
> 
> http://xfs.org/index.php/XFS_FAQ#Q:_How_to_calculate_the_correct_sunit.2Cswidth_values_for_optimal_performance
> 
> suggests using:
> 
> su = hardware RAID stripe size on single disk
> 
> sw = (disks in RAID-10 / 2)
> 
> on hardware RAID 10 volumes, but doesn't provide a reason for that
> "sw" value (other than that "(disks in RAID-10 / 2)" are the
> effective data disks).

Because the RAID-0 portion of the RAID-10 volume is half the number
of disks.

RAID-1 does not affect the performance of the underlying volume -
the behaviour and performance of RAID-1 is identical to a single
drive, so layout can not be optimised to improve performance on
RAID-1 volumes. RAID-0, OTOH, can give dramatically better
performance if we tell the filesystem about it because we can do
things like allocate more carefully to prevent hotspots....

> In the RAID 5 / RAID 6 case, obviously you want (su * sw) to cover
> the user data that you can write across the whole array in a single
> stripe, since that is the "writeable unit" on the array on which
> read/modify/write will need to be done -- so you do not want to have
> a data structure spanning the boundary between two writeable units
> (as that means two blocks will need to be read / modify / written).

Yes, it's more complex than that, especially when striping RAID5/6
luns together (e.g. RAID50), but the concept is correct - su/sw tell
the filesystem what the most efficient write sizes and alignment
are.

> In the RAID 10 case it is clearly preferable to avoid spanning
> across the boundary of a _single_ disk's (pair's) stripe size (su *
> 1), as then _two_ pairs of disks in the RAID 10 need to get involved
> in the write (so you potentially have two seek penalties, etc).
> 
> But in the RAID 10 case the each physical disk is just paired with
> one other disk, and that pair can be written independently of the
> rest -- since there's no parity information as such, there's
> normally no need for a read / modify / write cycle of any block
> larger than, eg, a physical sector or SSD erase block.

Which is exactly the same as RAID 0.

> So why is "sw" in the RAID 10 case given as "(disks in RAID-10 / 2)"
> rather than "1"?  Wouldn't
> 
> su = hardware RAID stripe size on single disk
> 
> sw = 1
> 
> make more sense for RAID 10?

Nope, because then you have no idea about how many disks you have
to spread the data over. e.g. if we have 8 disks and a sw=1, then
how do you optimise allocation to hit every disk just once for
a (su * number of disks) sized write? i.e. the sw config allows
allocation and IO sizes to be optimised to load all disks in the
RAID-0 stripe equally.

> In the RAID 10 case, spanning across the whole data disk set seems
> likely to align data structures (more frequently) on the first disk
> pair in the RAID set (especially with larger single-disk stripe
> sizes), potentially making that the "metadata disk pair" -- and thus
> both potentially having more metadata activity on it, and also being
> more at risk if one disk in that pair is lost or that pair is
> rebuilding.

Nope, the filesystem does not do that. Allocation is complex, and
the filesystem may choose to pack the data (small files) so there is
no alignment, it may align to /any/ stripe unit for allocations of
stripe unit size of larger, or for really large allocations it may
attempt to align and round out to stripe width.

It does all this to prevent hot spots on disk in the RAID - that's
the problem you're trying to describe, I think. There was lots of
analysis and optimisation work done back at SGI around 1999/2000 to
sort out all the hot-spot problems in really large arrays. Out of
that came things like mkfs placing static metadata across all stripe
units instead of just the first in a stripe width, better selection
of initial alignment, etc.

For the vast majority of users, hot spot problems went away and we
really haven't seen such problems in the 15+ years since these
problems were addressed...

> (The same "align to start of disk set" would seem to
> happen with RAID 5 / RAID 6 too, but is unavoidable due to the
> "large smallest physically modifiable block" issue.)

RAID5/6 have different issues, and the way you have to think about
RAID5/6 luns changes depending on how you are aggregating them into
a larger single unit (e.g. optimising for RAID-0 stripes of RAID5/6
luns is highly complex).

> What am I missing that leads to the FAQ suggesting "sw = (disks in
> RAID-10 / 2)"?  Perhaps this additional rationale could be added to
> that FAQ question?  (Or if "sw = 1" actually does make sense on RAID
> 10, the FAQ could be updated to suggest that as an option.)

That RAID-10 is optimised for the dominant RAID-0 layout and IO
characteristics, not the RAID-1 characteristics which have no impact
on performance and hence don't require any optimisations.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
