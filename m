Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:4438 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752015AbcKQBAq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Nov 2016 20:00:46 -0500
Date: Thu, 17 Nov 2016 12:00:08 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH RFC] xfs: drop SYNC_WAIT from xfs_reclaim_inodes_ag
 during slab reclaim
Message-ID: <20161117010008.GC19783@dastard>
References: <20161114005951.GB2127@clm-mbp.thefacebook.com>
 <20161114072708.GN28922@dastard>
 <1f19925d-6ba8-9bde-b3a8-0bdade80f564@fb.com>
 <20161114235801.GO28922@dastard>
 <20161115055416.GP28922@dastard>
 <77e23f2d-04f6-beb1-4515-6513a82b0686@fb.com>
 <20161116013009.GQ28922@dastard>
 <20161116030344.GA7746@clm-mbp.masoncoding.com>
 <20161116233136.GA19783@dastard>
 <20161117002726.GA4811@clm-mbp.masoncoding.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161117002726.GA4811@clm-mbp.masoncoding.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Chris Mason <clm@fb.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Nov 16, 2016 at 07:27:27PM -0500, Chris Mason wrote:
> On Thu, Nov 17, 2016 at 10:31:36AM +1100, Dave Chinner wrote:
> >>>So I'm running on 16GB RAM and have 100-150MB of XFS slab.
> >>>Percentage wise, the inode cache is a larger portion of memory than
> >>>in your machines. I can increase the number of files to increase it
> >>>further, but I don't think that will change anything.
> >>
> >>I think the way to see what I'm seeing would be to drop the number
> >>of IO threads (-T) and bump both -m and -M.  Basically less inode
> >>working set and more memory working set.
> >
> >If I increase m/M by any non-trivial amount, the test OOMs within a
> >couple of minutes of starting even after cutting the number of IO
> >threads in half. I've managed to increase -m by 10% without OOM -
> >I'll keep trying to increase this part of the load as much as I
> >can as I refine the patchset I have.
> 
> Gotcha.  -m is long lasting, allocated once at the start of the run
> and stays around for ever.  It basically soaks up ram.  -M is
> allocated once per work loop, and it should be where the stalls
> really hit.  I'll peel off a flash machine tomorrow and find a
> command line that matches my results so far.
> 
> What kind of flash are you using?  I can choose between modern nvme
> or something more crusty.

Crusty old stuff - a pair of EVO 840s in HW-RAID0 behind 512MB of
BBWC. Read rates peak at ~150MB/s, write rates sustain at about
75MB/s.

I'm testing on a 200GB filesystem, configured as:

mkfs.xfs -f -dagcount=8,size=200g /dev/vdc

The backing file for /dev/vdc is fully preallocated and linear,
accessed via virtio/direct IO, so it's no different to accessing the
real block device....

> >>>That's what removing the blocking from the shrinker causes the
> >>>overall work rate to go down - it results in the cache not
> >>>maintaining a working set of inodes and so increases the IO load and
> >>>that then slows everything down.
> >>
> >>At least on my machines, it made the overall work rate go up.  Both
> >>simoop and prod are 10-15% faster.
> >
> >Ok, I'll see if I can tune the workload here to behave more like
> >this....
> 
> What direction do you have in mind for your current patches?  Many
> tiers have shadows where we can put experimental code without
> feeling bad if machines crash or data is lost.  I'm happy to line up
> tests if you want data from specific workloads.

Right now I have kswapd as fully non-blocking - even more so that
your one line patch because reclaim can (and does) still block on
inode locks with SYNC_TRYLOCK set. I don't see any problems with
doing this.

I'm still trying to work out what to do with direct reclaim - it's
clearly the source of the worst allocation latency problems, and it
also seems to be the contributing factor to the obnoxious kswapd FFE
behaviour.  There's a couple more variations I want to try to see if
I can make it block less severely, but what I do in the short term
here is largely dependent on the effect on other benchmarks and
loads....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
