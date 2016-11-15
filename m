Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:6595 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S965906AbcKOFzE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Nov 2016 00:55:04 -0500
Date: Tue, 15 Nov 2016 16:54:16 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH RFC] xfs: drop SYNC_WAIT from xfs_reclaim_inodes_ag
 during slab reclaim
Message-ID: <20161115055416.GP28922@dastard>
References: <20161017002427.GA70229@clm-mbp.masoncoding.com>
 <20161017015251.GU23194@dastard>
 <e0c37926-a670-98b6-4bd7-b438def130bd@fb.com>
 <20161017223057.GV23194@dastard>
 <f6dadb97-4233-4bbf-3edc-4985c7727548@fb.com>
 <20161018020324.GA23194@dastard>
 <20161114005951.GB2127@clm-mbp.thefacebook.com>
 <20161114072708.GN28922@dastard>
 <1f19925d-6ba8-9bde-b3a8-0bdade80f564@fb.com>
 <20161114235801.GO28922@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161114235801.GO28922@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Chris Mason <clm@fb.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Nov 15, 2016 at 10:58:01AM +1100, Dave Chinner wrote:
> On Mon, Nov 14, 2016 at 03:56:14PM -0500, Chris Mason wrote:
.....
> So a single "stall event" blows out the p99 latencies really badly.
> This is probably the single most important revelation about this
> so far...
> 
> > I think the difference between mine and yours is we didn't quite get
> > the allocation stalls down to zero, so making tasks wait for the
> > shrinker shows up in the end numbers.
> 
> Right, but so far we haven't answered the obvious question: what
> triggers the stall events?

Our prime suspicion in all this has been that blocking on dirty
inodes has been preventing the XFS inode cache shrinker from making
progress. That does not appear to be the case at all here. From
a half hour sample of my local workload:


    Inode Clustering
      xs_iflush_count.......         20119    <<<<<<
      xs_icluster_flushcnt..         20000
      xs_icluster_flushinode        440411
    Vnode Statistics
      vn_active.............        130903
      vn_alloc..............             0
      vn_get................             0
      vn_hold...............             0
      vn_rele...............       1217355
      vn_reclaim............       1217355   <<<<<<<
      vn_remove.............       1217355

There have been 1.2 million inodes reclaimed from the cache, but
there have only been 20,000 dirty inode buffer writes. Yes, that's
written 440,000 dirty inodes - the inode write clustering is
capturing about 22 inodes per write - but the inode writeback load
is minimal at about 10 IO/s. XFS inode reclaim is not blocking
significantly on dirty inodes.

.....

> What is particularly interesting in chart 3 is the vfs.inodes.count
> and xfs_inode slab metrics (red and pink lines respectively). The
> active xfs_inode slab objects starts off below the vfs inode count,
> then over time 6 cycles xfs_inode count slowly increases above th
> vfs inode count. Then we get an allocation stall event, and it
> returns the xfs_inode count to less than the vfs inode count. The
> second stall even occurs at a similar point.

Ok, this behaviour is not relevant. It's a result of inode cache
scan cycling behaviour that I added where skipped inodes are not
immediately revisited by SYNC_WAIT scans.

Ok, the more I look into this, the less I think this is an XFS inode
cache shrinker blocking problem. These gigantic "allocation stall"
are a complete and utter mess at the vmscan level.

I caught a trace in a vanilla 4.9-rc4 kernel where a stall event
trashed 8GB of page cache and ~60,000 inodes in about 2s flat. This
has nothing to do with XFS shrinkers blocking, and everything to do
with the mm subsystem going apeshit.

Let's start here at 8501.5s, where kswapd suddenly kicks in and
starts scanning - The first invocation of the XFs shrinker for
node3 reports:

kswapd3-861   [015]  8501.546421: mm_shrink_slab_start: super_cache_scan+0x0 0xffff88023abfc4c0: nid: 3 objects to shrink 552 gfp_flags GFP_KERNEL pgs_scanned 45 lru_pgs 198175 cache items 9197 delta 4 total_scan 556

the page cache has ~200k pages, and the inode cache 9000 objects.
kswapd didn't scan many pages, didn't add much delta to the shrinker.
kswapd keeps running, not finding any pages to reclaim and escalting
priority, running the shrinker on each escalation:

kswapd3-861   [015]  8501.548073: mm_vmscan_lru_shrink_inactive: nid=3 nr_scanned=22 nr_reclaimed=22 priority=8 flags=RECLAIM_WB_FILE|RECLAIM_WB_ASYNC
kswapd3-861   [015]  8501.548090: mm_shrink_slab_start: super_cache_scan+0x0 0xffff88023abfc4c0: nid: 3 objects to shrink 613 gfp_flags GFP_KERNEL pgs_scanned 726 lru_pgs 197537 cache items 9197 delta 67 total_scan 680

By priority 8, we can see the pages scanned and the shrinker delta
is going up, but no significant reclaim progress has been made.

Priority 7:

kswapd3-861   [015]  8501.549347: mm_shrink_slab_start: super_cache_scan+0x0 0xffff88023abfc4c0: nid: 3 objects to shrink 680 gfp_flags GFP_KERNEL pgs_scanned 1448 lru_pgs 196821 cache items 9197 delta 135 total_scan 815

Still no shrinker work, and kswapd stops here, having reached it's
thresholds. Shortly after it starts again

kswapd3-861   [015]  8501.571629: mm_vmscan_kswapd_wake: nid=3 zid=3 order=0

Priority winds up to 8:

kswapd3-861   [015]  8501.572660: mm_shrink_slab_start: super_cache_scan+0x0 0xffff88023abfc4c0: nid: 3 objects to shrink 876 gfp_flags GFP_KERNEL pgs_scanned 718 lru_pgs 195330 cache items 9197 delta 67 total_scan 943

But still not over the shrinker threshold. At priorty 7, it kicks
over the batch threshold and we free 326 cached objects:

kswapd3-861   [015]  8501.573640: mm_shrink_slab_start: super_cache_scan+0x0 0xffff88023abfc4c0: nid: 3 objects to shrink 943 gfp_flags GFP_KERNEL pgs_scanned 1430 lru_pgs 194619 cache items 9197 delta 135 total_scan 1078
kswapd3-861   [015]  8501.577927: mm_shrink_slab_end:   super_cache_scan+0x0 0xffff88023abfc4c0: nid: 3 unused scan count 943 new scan count 54 total_scan 54 last shrinker return val 362

Again, kswapd stops here, to be woken about 10ms later, winds up to
priority 7, ends with lru_pgs 192292 cache items 8779

kswapd3-861   [015]  8501.586501: mm_vmscan_kswapd_wake: nid=3 zid=3 order=0

So after another 10 wakeups and P7 reclaims, we are at:

kswapd3-861   [015]  8501.711927: mm_shrink_slab_start: super_cache_scan+0x0 0xffff88023abfc4c0: nid: 3 objects to shrink 845 gfp_flags GFP_KERNEL pgs_scanned 1220 lru_pgs 167629 cache items 8400 delta 122 total_scan 967

This pattern continues, freeing pages and winding up priority:

kswapd3-861   [015]  8501.763802: mm_vmscan_lru_isolate: isolate_mode=0 classzone=3 order=0 nr_requested=32 nr_scanned=32 nr_taken=32 file=1
kswapd3-861   [015]  8501.799755: mm_vmscan_lru_shrink_inactive: nid=3 nr_scanned=32 nr_reclaimed=32 priority=5 flags=RECLAIM_WB_FILE|RECLAIM_WB_ASYNC
kswapd3-861   [015]  8501.899717: mm_vmscan_lru_shrink_inactive: nid=3 nr_scanned=32 nr_reclaimed=32 priority=4 flags=RECLAIM_WB_FILE|RECLAIM_WB_ASYNC

by the time we get to priority 4, we've lost half the page cache and
a thid of the inode cache: lru_pgs 105911 cache items 6802. kswapd
keeps being started and winding up to priority 4, where after another
200ms:

kswapd3-861   [015]  8502.093850: mm_vmscan_lru_shrink_inactive: nid=3 nr_scanned=32 nr_reclaimed=32 priority=4 flags=RECLAIM_WB_FILE|RECLAIM_WB_ASYNC
....
kswapd3-861   [015]  8502.096649: mm_shrink_slab_start: super_cache_scan+0x0 0xffff88023abfc4c0: nid: 3 objects to shrink 850 gfp_flags GFP_KERNEL pgs_scanned 3104 lru_pgs 75733 cache items 4596 delta 376 total_scan 1226

This inode shirnker invocation blocks for the first time for:

kswapd3-861   [015]  8502.423233: mm_shrink_slab_end:   super_cache_scan+0x0 0xffff88023abfc4c0: nid: 3 unused scan count 850 new scan count 309 total_scan 202 last shrinker return val 628

About 300ms because it's the cache is now really small and we were
asked to scan more than a quarter of it.  At this point we've lost 60%
of the page cache and half the inode cache.

kswapd continues to be run and wind up the reclaim pressure. It's
at priority 5 next time the XFS inode cache shrinker is run:

kswapd3-861   [015]  8502.441241: mm_shrink_slab_start: super_cache_scan+0x0 0xffff88023abfc4c0: nid: 3 objects to shrink 920 gfp_flags GFP_KERNEL pgs_scanned 1754 lru_pgs 66784 cache items 4417 delta 232 total_scan 1152
 kswapd3-861   [015]  8502.706469: mm_shrink_slab_end:   super_cache_scan+0x0 0xffff88023abfc4c0: nid: 3 unused scan count 920 new scan count 437 total_scan 128 last shrinker return val 668

Again, we block for 250ms. kswapd then winds up to prior 4 but doesn't
quite trigger the shrinker. It then runs again, triggers the
shrinker at prior 6, blocks for 400ms, now down to:

	8502.815198: lru_pgs 60245 cache items 4078

kwapd continues, winds up to prio 4, triggers shrinker again, blocks
for 100ms, and by this time we're at lru_pgs 50169 cache items 2972.
We've lost 75% of the page cache and 70% of the inode cache.

kswapd is woken again immediately, runs to prio 5, no blocking, no
changes in cache footprint. Then:

kswapd3-861   [015]  8503.318575: mm_vmscan_kswapd_wake: nid=3 zid=3 order=0
....
kswapd3-861   [015]  8503.327057: mm_vmscan_lru_shrink_inactive: nid=3 nr_scanned=32 nr_reclaimed=32 priority=3 flags=RECLAIM_WB_FILE|RECLAIM_WB_ASYNC

We ramp up to priority 3 and by this stage we've done serious damage
to the inode caches:

kswapd3-861   [015]  8503.330165: mm_shrink_slab_start: super_cache_scan+0x0 0xffff88023abfc4c0: nid: 3 objects to shrink 72 gfp_flags GFP_KERNEL pgs_scanned 3104 lru_pgs 43054 cache items 2007 delta 289 total_scan 361

And we keep scanning at prio 3 putting serious pressure on the page
cache, and then it happens:

kswapd3-861   [015]  8503.333975: mm_shrink_slab_start: super_cache_scan+0x0 0xffff88023abfc4c0: nid: 3 objects to shrink 361 gfp_flags GFP_KERNEL pgs_scanned 3104 lru_pgs 39969 cache items 2067 delta 321 total_scan 682
....
kswapd3-861   [015]  8503.337100: mm_shrink_slab_start: super_cache_scan+0x0 0xffff88023abfc4c0: nid: 3 objects to shrink 682 gfp_flags GFP_KERNEL pgs_scanned 3104 lru_pgs 36888 cache items 2661 delta 447 total_scan 1129
....
 kswapd3-861   [015]  8503.344760: mm_vmscan_lru_shrink_inactive: nid=3 nr_scanned=32 nr_reclaimed=0 priority=3 flags=RECLAIM_WB_FILE|RECLAIM_WB_ASYNC
 kswapd3-861   [015]  8503.344766: mm_vmscan_lru_isolate: isolate_mode=0 classzone=3 order=0 nr_requested=32 nr_scanned=32 nr_taken=32 file=1
 kswapd3-861   [015]  8503.344788: mm_vmscan_writepage:  page=0xffffea00003415a5 pfn=3413413 flags=RECLAIM_WB_FILE|RECLAIM_WB_ASYNC
 kswapd3-861   [015]  8503.344793: mm_vmscan_writepage:  page=0xffffea00003bcd44 pfn=3919172 flags=RECLAIM_WB_FILE|RECLAIM_WB_ASYNC

Yup, memory reclaim starts dirty page writeback. From this point,
there are ~10,000 pages written by memory reclaim over the next
700ms. This is how close we go to kicking the OOM - we hit prio 1:

kswapd3-861   [015]  8503.935138: mm_vmscan_lru_shrink_inactive: nid=3 nr_scanned=32 nr_reclaimed=32 priority=1 flags=RECLAIM_WB_FILE|RECLAIM_WB_ASYNC

The XFS inode shrinker blocking plays no significant part in this
series of events. yes, it contributes to /reclaim latency/, but it
is not the cause of the catastrophic breakdown that results in
kswapd emptying the page cache and the slab caches to accomodate the
memory demand coming from userspace. We can fix the blocking
problems with the XFS shrinker, but it's not the shrinker's job to
stop this overload situation from happening.

Indeed, I just ran the workload with my patch and captured an alloc
stall in the same manner with the same tracing. It has the same
"kswapd keeps being run and escalating reclaim until there's nothing
left to reclaim" behaviour. kswapd never blocks in the XFS inode
shrinker now, so the allocation latencies are all from direct
reclaim doing work, which is exactly as it should be.

The fact that we are seeing dirty page writeback from kswapd
indicates that the memory pressure this workload generates from
userspace is not being adequately throttled in
throttle_direct_reclaim() to allow dirty writeback to be done in an
efficient and timely manner. The memory reclaim throttling needs to
back off more in overload situations like this - we need to slow
down the incoming demand to the reclaim rate rather than just
increasing pressure and hoping that kswapd doesn't burn up in a ball
of OOM....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
