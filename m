Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:31575 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S965486AbdI0EdM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 27 Sep 2017 00:33:12 -0400
Date: Wed, 27 Sep 2017 14:33:08 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Rationale for hardware RAID 10 su, sw values in FAQ
Message-ID: <20170927043308.GC3666@dastard>
References: <b8c45869-849f-5124-f74f-68da0f9f34d7@mcneill.gen.nz>
 <20170927004302.GB3666@dastard>
 <db821c38-1307-0681-ffc2-4400ffd8d27a@mcneill.gen.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <db821c38-1307-0681-ffc2-4400ffd8d27a@mcneill.gen.nz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ewen McNeill <xfs@ewen.mcneill.gen.nz>
Cc: linux-xfs@vger.kernel.org

On Wed, Sep 27, 2017 at 02:56:16PM +1300, Ewen McNeill wrote:
> Hi Dave,
> 
> On 27/09/17 13:43, Dave Chinner wrote:
> >RAID-1 does not affect the performance of the underlying volume -
> >the behaviour and performance of RAID-1 is identical to a single
> >drive, so layout can not be optimised to improve performance on
> >RAID-1 volumes. RAID-0, OTOH, can give dramatically better
> >performance if we tell the filesystem about it because we can do
> >things like allocate more carefully to prevent hotspots....
> >[...]
> >> [why not sw=1]
> >Nope, because then you have no idea about how many disks you have
> >to spread the data over. e.g. if we have 8 disks and a sw=1, then
> >how do you optimise allocation to hit every disk just once for
> >a (su * number of disks) sized write? i.e. the sw config allows
> >allocation and IO sizes to be optimised to load all disks in the
> >RAID-0 stripe equally.
> 
> Thanks for the detailed answer.  I'd been assuming that the su/sw
> values were to align with "rewritable chunks" (which clearly is
> important in the RAID 5 / 6 case), and ignoring the benefit in
> letting the file system choose allocation locations in RAID 0 to
> best maximise distribution across the individual RAID 0 elements to
> avoid hot spots.

RAID 5/6 need the same optimisations as RAID-0. In that case,
optimal RAID performance occurs when writing stripe width aligned
and sized IOs so there is no need for RMW cycles to calculate
parity. For large files being written sequentially, it really
doesn't matter that much if the head and/or tail are not exactly
stripe width aligned as things like the stripe cache in MD or the
BBWC in hardware RAID take care of delaying the data IO long enough
to do full stripe writes....

> >[hot spot work in late 1990s]  Out of
> >that came things like mkfs placing static metadata across all stripe
> >units instead of just the first in a stripe width, better selection
> >of initial alignment, etc.
> 
> It's good to hear that XFS work already anticipated the side effect
> that I was concerned about (accidentally aligning everything on
> "start of stripe * width boundary, and thus one disk).
> 
> I did end up creating the file system with su=512k,sw=6 (RAID 10 on
> 12 disks) anyway, so I'm glad to hear this is supported by earlier
> performance tuning work.
> 
> As a suggestion the FAQ section (http://xfs.org/index.php/XFS_FAQ#Q:_How_to_calculate_the_correct_sunit.2Cswidth_values_for_optimal_performance)
> could hint at this reasoning with, eg:
> 
> -=- cut here -=-
> A RAID stripe size of 256KB with a RAID-10 over 16 disks should use
> 
>  su = 256k
>  sw = 8 (RAID-10 of 16 disks has 8 data disks)
> 
> because in RAID-10 the RAID-0 behaviour dominates performance, and this
> allows XFS to spread the workload evenly across all pairs of disks.
> --= cut here -=-

This assumes the reader understands exaclty how RAID works and how
the different types of RAID affect IO performance. The FAQ simply
tries to convey how to get it right without going into the
complicated reasons for doing it that way. Most users don't care
about the implementation or reasons, they just want to know how to
set it up correctly and quickly :P

> and/or that FAQ entry could also talk about RAID-0 sw/su tuning
> values which would provide a hint towards the "spread workload over
> all disks" rationale.

The FAQ is not the place to explain how the filesystem optimises
allocation for different types of storage. The moment we add that
for RAID-0, we;ve got to do it for RAID 5, then raid 6, then
someone will ask about raid 50, etc and suddenly the typical reader
no longer understands the answer to the question....

If you look at the admin doc that is sitting a git repo:

https://git.kernel.org/pub/scm/fs/xfs/xfs-documentation.git/tree/admin/XFS_Performance_Tuning/filesystem_tunables.asciidoc

You'll see the section about all this reads:

	==== Alignment to storage geometry

	TODO: This is extremely complex and requires an entire chapter to itself.

because nobody (well, me, really) has had the time to write
everything down that is needed to cover this topic sufficiently...


Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
