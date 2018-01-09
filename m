Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:16434 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1756163AbeAIWZ1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Jan 2018 17:25:27 -0500
Date: Wed, 10 Jan 2018 09:25:23 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Growing RAID10 with active XFS filesystem
Message-ID: <20180109222523.GJ16421@dastard>
References: <f289da8f-96ec-7db4-abb1-b151d553c088@gmail.com>
 <20180108192607.GS5602@magnolia>
 <20180108220139.GB16421@dastard>
 <5A548D31.4000002@youngman.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5A548D31.4000002@youngman.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Wols Lists <antlists@youngman.org.uk>
Cc: linux-xfs@vger.kernel.org, linux-raid@vger.kernel.org

On Tue, Jan 09, 2018 at 09:36:49AM +0000, Wols Lists wrote:
> On 08/01/18 22:01, Dave Chinner wrote:
> > Yup, 21 devices in a RAID 10. That's a really nasty config for
> > RAID10 which requires an even number of disks to mirror correctly.
> > Why does MD even allow this sort of whacky, sub-optimal
> > configuration?
> 
> Just to point out - if this is raid-10 (and not raid-1+0 which is a
> completely different beast) this is actually a normal linux config. I'm
> planning to set up a raid-10 across 3 devices. What happens is that is
> that raid-10 writes X copies across Y devices. If X = Y then it's a
> normal mirror config, if X > Y it makes good use of space (and if X < Y
> it doesn't make sense :-)
> 
> SDA: 1, 2, 4, 5
> 
> SDB: 1, 3, 4, 6
> 
> SDC: 2, 3, 5, 6

It's nice to know that MD has redefined RAID-10 to be different to
the industry standard definition that has been used for 20 years and
optimised filesystem layouts for.  Rotoring data across odd numbers
of disks like this is going to really, really suck on filesystems
that are stripe layout aware..

For example, XFS has hot-spot prevention algorithms in it's
internal physical layout for striped devices. It aligns AGs across
different stripe units so that metadata and data doesn't all get
aligned to the one disk in a RAID0/5/6 stripe. If the stripes are
rotoring across disks themselves, then we're going to end up back in
the same position we started with - multiple AGs aligned to the
same disk.

The result is that many XFS workloads are going to hotspot disks and
result in unbalanced load when there are an odd number of disks in a
RAID-10 array.  Actually, it's probably worse than having no
alignment, because it makes hotspot occurrence and behaviour very
unpredictable.

Worse is the fact that there's absolutely nothing we can do to
optimise allocation alignment or IO behaviour at the filesystem
level. We'll have to make mkfs.xfs aware of this clusterfuck and
turn off stripe alignment when we detect such a layout, but that
doesn't help all the existing user installations out there right
now.

IMO, odd-numbered disks in RAID-10 should be considered harmful and
never used....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
