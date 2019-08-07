Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40872 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726529AbfHGJbA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 7 Aug 2019 05:31:00 -0400
Date: Wed, 7 Aug 2019 11:30:56 +0200
From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH] [Regression, v5.0] mm: boosted kswapd reclaim b0rks
 system cache balance
Message-ID: <20190807093056.GS11812@dhcp22.suse.cz>
References: <20190807091858.2857-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190807091858.2857-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-mm@kvack.org, linux-xfs@vger.kernel.org, Mel Gorman <mgorman@suse.de>, Vlastimil Babka <vbabka@suse.cz>

[Cc Mel and Vlastimil as it seems like fallout from 1c30844d2dfe2]

On Wed 07-08-19 19:18:58, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When running a simple, steady state 4kB file creation test to
> simulate extracting tarballs larger than memory full of small files
> into the filesystem, I noticed that once memory fills up the cache
> balance goes to hell.
> 
> The workload is creating one dirty cached inode for every dirty
> page, both of which should require a single IO each to clean and
> reclaim, and creation of inodes is throttled by the rate at which
> dirty writeback runs at (via balance dirty pages). Hence the ingest
> rate of new cached inodes and page cache pages is identical and
> steady. As a result, memory reclaim should quickly find a steady
> balance between page cache and inode caches.
> 
> It doesn't.
> 
> The moment memory fills, the page cache is reclaimed at a much
> faster rate than the inode cache, and evidence suggests taht the
> inode cache shrinker is not being called when large batches of pages
> are being reclaimed. In roughly the same time period that it takes
> to fill memory with 50% pages and 50% slab caches, memory reclaim
> reduces the page cache down to just dirty pages and slab caches fill
> the entirity of memory.
> 
> At the point where the page cache is reduced to just the dirty
> pages, there is a clear change in write IO patterns. Up to this
> point it has been running at a steady 1500 write IOPS for ~200MB/s
> of write throughtput (data, journal and metadata). Once the page
> cache is trimmed to just dirty pages, the write IOPS immediately
> start spiking to 5-10,000 IOPS and there is a noticable change in
> IO sizes and completion times. The SSD is fast enough to soak these
> up, so the measured performance is only slightly affected (numbers
> below). It results in > ~50% throughput slowdowns on a spinning
> disk with a NVRAM RAID cache in front of it, though. I didn't
> capture the numbers at the time, and it takes far to long for me to
> care to run it again and get them.
> 
> SSD perf degradation as the LRU empties to just dirty pages:
> 
> FSUse%        Count         Size    Files/sec     App Overhead
> ......
>      0      4320000         4096      51349.6          1370049
>      0      4480000         4096      48492.9          1362823
>      0      4640000         4096      48473.8          1435623
>      0      4800000         4096      46846.6          1370959
>      0      4960000         4096      47086.6          1567401
>      0      5120000         4096      46288.8          1368056
>      0      5280000         4096      46003.2          1391604
>      0      5440000         4096      46033.4          1458440
>      0      5600000         4096      45035.1          1484132
>      0      5760000         4096      43757.6          1492594
>      0      5920000         4096      40739.4          1552104
>      0      6080000         4096      37309.4          1627355
>      0      6240000         4096      42003.3          1517357
> .....
> real    3m28.093s
> user    0m57.852s
> sys     14m28.193s
> 
> Average rate: 51724.6+/-2.4e+04 files/sec.
> 
> At first memory full point:
> 
> MemFree:          432676 kB
> Active(file):      89820 kB
> Inactive(file):  7330892 kB
> Dirty:           1603576 kB
> Writeback:          2908 kB
> Slab:            6579384 kB
> SReclaimable:    3727612 kB
> SUnreclaim:      2851772 kB
> 
> A few seconds later at about half the page cache reclaimed:
> 
> MemFree:         1880588 kB
> Active(file):      89948 kB
> Inactive(file):  3021796 kB
> Dirty:           1097072 kB
> Writeback:          2600 kB
> Slab:            8900912 kB
> SReclaimable:    5060104 kB
> SUnreclaim:      3840808 kB
> 
> And at about the 6080000 count point in the results above, right to
> the end of the test:
> 
> MemFree:          574900 kB
> Active(file):      89856 kB
> Inactive(file):   483120 kB
> Dirty:            372436 kB
> Writeback:           324 kB
> KReclaimable:    6506496 kB
> Slab:           11898956 kB
> SReclaimable:    6506496 kB
> SUnreclaim:      5392460 kB
> 
> 
> So the LRU is largely full of dirty pages, and we're getting spikes
> of random writeback from memory reclaim so it's all going to shit.
> Behaviour never recovers, the page cache remains pinned at just dirty
> pages, and nothing I could tune would make any difference.
> vfs_cache_pressure makes no difference - I would it up so high it
> should trim the entire inode caches in a singel pass, yet it didn't
> do anything. It was clear from tracing and live telemetry that the
> shrinkers were pretty much not running except when there was
> absolutely no memory free at all, and then they did the minimum
> necessary to free memory to make progress.
> 
> So I went looking at the code, trying to find places where pages got
> reclaimed and the shrinkers weren't called. There's only one -
> kswapd doing boosted reclaim as per commit 1c30844d2dfe ("mm: reclaim
> small amounts of memory when an external fragmentation event
> occurs"). I'm not even using THP or allocating huge pages, so this
> code should not be active or having any effect onmemory reclaim at
> all, yet the majority of reclaim is being done with "boost" and so
> it's not reclaiming slab caches at all. It will only free clean
> pages from the LRU.
> 
> And so when we do run out memory, it switches to normal reclaim,
> which hits dirty pages on the LRU and does some shrinker work, too,
> but then appears to switch back to boosted reclaim one watermarks
> are reached.
> 
> The patch below restores page cache vs inode cache balance for this
> steady state workload. It balances out at about 40% page cache, 60%
> slab cache, and sustained performance is 10-15% higher than without
> this patch because the IO patterns remain in control of dirty
> writeback and the filesystem, not kswapd.
> 
> Performance with boosted reclaim also running shrinkers over the
> same steady state portion of the test as above.
> 
> FSUse%        Count         Size    Files/sec     App Overhead
> ......
>      0      4320000         4096      51341.9          1409983
>      0      4480000         4096      51157.5          1486421
>      0      4640000         4096      52041.5          1421837
>      0      4800000         4096      52124.2          1442169
>      0      4960000         4096      56266.6          1388865
>      0      5120000         4096      52892.2          1357650
>      0      5280000         4096      51879.5          1326590
>      0      5440000         4096      52178.7          1362889
>      0      5600000         4096      53863.0          1345956
>      0      5760000         4096      52538.7          1321422
>      0      5920000         4096      53144.5          1336966
>      0      6080000         4096      53647.7          1372146
>      0      6240000         4096      52434.7          1362534
> 
> .....
> real    3m11.543s
> user    0m57.506s
> sys     14m20.913s
> 
> Average rate: 57634.2+/-2.8e+04 files/sec.
> 
> So it completed ~10% faster (both wall time and create rate) and had
> far better IO patterns so the differences would be even more
> pronounced on slow storage.
> 
> This patch is not a fix, just a demonstration of the fact that the
> heuristics this "boosted reclaim for compaction" are based on are
> flawed, will have nasty side effects for users that don't use THP
> and so needs revisiting.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  mm/vmscan.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 9034570febd9..702e6523f8ad 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -2748,10 +2748,10 @@ static bool shrink_node(pg_data_t *pgdat, struct scan_control *sc)
>  			shrink_node_memcg(pgdat, memcg, sc, &lru_pages);
>  			node_lru_pages += lru_pages;
>  
> -			if (sc->may_shrinkslab) {
> +			//if (sc->may_shrinkslab) {
>  				shrink_slab(sc->gfp_mask, pgdat->node_id,
>  				    memcg, sc->priority);
> -			}
> +			//}
>  
>  			/* Record the group's reclaim efficiency */
>  			vmpressure(sc->gfp_mask, memcg, false,
> -- 
> 2.23.0.rc1

-- 
Michal Hocko
SUSE Labs
