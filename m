Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:23665 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753175AbcKPXdF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Nov 2016 18:33:05 -0500
Date: Thu, 17 Nov 2016 10:31:36 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH RFC] xfs: drop SYNC_WAIT from xfs_reclaim_inodes_ag
 during slab reclaim
Message-ID: <20161116233136.GA19783@dastard>
References: <f6dadb97-4233-4bbf-3edc-4985c7727548@fb.com>
 <20161018020324.GA23194@dastard>
 <20161114005951.GB2127@clm-mbp.thefacebook.com>
 <20161114072708.GN28922@dastard>
 <1f19925d-6ba8-9bde-b3a8-0bdade80f564@fb.com>
 <20161114235801.GO28922@dastard>
 <20161115055416.GP28922@dastard>
 <77e23f2d-04f6-beb1-4515-6513a82b0686@fb.com>
 <20161116013009.GQ28922@dastard>
 <20161116030344.GA7746@clm-mbp.masoncoding.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161116030344.GA7746@clm-mbp.masoncoding.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Chris Mason <clm@fb.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Nov 15, 2016 at 10:03:52PM -0500, Chris Mason wrote:
> On Wed, Nov 16, 2016 at 12:30:09PM +1100, Dave Chinner wrote:
> >On Tue, Nov 15, 2016 at 02:00:47PM -0500, Chris Mason wrote:
> >>On 11/15/2016 12:54 AM, Dave Chinner wrote:
> >>>On Tue, Nov 15, 2016 at 10:58:01AM +1100, Dave Chinner wrote:
> >>>>On Mon, Nov 14, 2016 at 03:56:14PM -0500, Chris Mason wrote:
> >>>There have been 1.2 million inodes reclaimed from the cache, but
> >>>there have only been 20,000 dirty inode buffer writes. Yes, that's
> >>>written 440,000 dirty inodes - the inode write clustering is
> >>>capturing about 22 inodes per write - but the inode writeback load
> >>>is minimal at about 10 IO/s. XFS inode reclaim is not blocking
> >>>significantly on dirty inodes.
> >>
> >>I think our machines are different enough that we're not seeing the
> >>same problems.  Or at least we're seeing different sides of the
> >>problem.
> >>
> >>We have 130GB of ram and on average about 300-500MB of XFS slab,
> >>total across all 15 filesystems.  Your inodes are small and cuddly,
> >>and I'd rather have more than less.  I see more with simoop than we
> >>see in prod, but either way its a reasonable percentage of system
> >>ram considering the horrible things being done.
> >
> >So I'm running on 16GB RAM and have 100-150MB of XFS slab.
> >Percentage wise, the inode cache is a larger portion of memory than
> >in your machines. I can increase the number of files to increase it
> >further, but I don't think that will change anything.
> 
> I think the way to see what I'm seeing would be to drop the number
> of IO threads (-T) and bump both -m and -M.  Basically less inode
> working set and more memory working set.

If I increase m/M by any non-trivial amount, the test OOMs within a
couple of minutes of starting even after cutting the number of IO
threads in half. I've managed to increase -m by 10% without OOM -
I'll keep trying to increase this part of the load as much as I
can as I refine the patchset I have.

> >>Both patched (yours or mine) and unpatched, XFS inode reclaim is
> >>keeping up.   With my patch in place, tracing during simoop does
> >>show more kswapd prio=1 scanning than unpatched, so I'm clearly
> >>stretching the limits a little more.  But we've got 30+ days of
> >>uptime in prod on almost 60 machines.  The oom rate is roughly in
> >>line with v3.10, and miles better than v4.0.
> >
> >IOWs, you have a workaround that keeps your production systems
> >running. That's fine for your machines that are running this load,
> >but it's not working well for any of the other other loads I've
> >looked at.  That is, removing the throttling from the XFS inode
> >shrinker causes instability and adverse reclaim of the inode cache
> >in situations where the maintaining a working set in memory is
> >required for performance.
> 
> We agree on all of this much more than not.  Josef has spent a lot
> of time recently on shrinkers (w/btrfs but the ideas are similar),
> and I'm wrapping duct tape around workloads until the overall
> architecture is less fragile.
> 
> Using slab for metadata in an FS like btrfs where dirty metadata is
> almost unbounded is a huge challenge in the current framework.  Ext4
> is moving to dramatically bigger logs, so it would eventually have
> the same problems.

Your 8TB XFS filesystems will be using 2GB logs (unless mkfs
settings were tweaked manually), so there's a huge amount of
metadata 15x8TB XFS filesystems can pin in memory, too...

> >Indeed, one of the things I noticed with the simoops workload
> >running the shrinker patches is that it no longer kept either the
> >inode cache or the XFS metadata cache in memory long enough for the
> >du to run without requiring IO. i.e. the caches no longer maintained
> >the working set of objects needed to optimise a regular operation
> >and the du scans took a lot longer.
> 
> With simoop, du is supposed to do IO.  It's crazy to expect to be
> able to scan all the inodes on a huge FS (or 15 of them) and keep it
> all in cache along with everything else hadoop does.  I completely
> agree there are cases where having the working set in ram is valid,
> just simoop isn't one ;)

Sure, I was just pointing out that even simoop was seeing signficant
changes in cache residency as a result of this change....

> >That's what removing the blocking from the shrinker causes the
> >overall work rate to go down - it results in the cache not
> >maintaining a working set of inodes and so increases the IO load and
> >that then slows everything down.
> 
> At least on my machines, it made the overall work rate go up.  Both
> simoop and prod are 10-15% faster. 

Ok, I'll see if I can tune the workload here to behave more like
this....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
