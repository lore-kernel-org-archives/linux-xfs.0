Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43514 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727213AbfHGPDW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 7 Aug 2019 11:03:22 -0400
Date: Wed, 7 Aug 2019 16:03:16 +0100
From: Mel Gorman <mgorman@suse.de>
Subject: Re: [PATCH] [Regression, v5.0] mm: boosted kswapd reclaim b0rks
 system cache balance
Message-ID: <20190807150316.GL2708@suse.de>
References: <20190807091858.2857-1-david@fromorbit.com>
 <20190807093056.GS11812@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20190807093056.GS11812@dhcp22.suse.cz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Michal Hocko <mhocko@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>, linux-mm@kvack.org, linux-xfs@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>

On Wed, Aug 07, 2019 at 11:30:56AM +0200, Michal Hocko wrote:
> [Cc Mel and Vlastimil as it seems like fallout from 1c30844d2dfe2]
> 

More than likely.

> On Wed 07-08-19 19:18:58, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > When running a simple, steady state 4kB file creation test to
> > simulate extracting tarballs larger than memory full of small files
> > into the filesystem, I noticed that once memory fills up the cache
> > balance goes to hell.
> > 

Ok, I'm assuming you are using fsmark with -k to keep files around,
and -S0 to leave cleaning to the background flush, a number of files per
iteration to get regular reporting and a total number of iterations to
fill memory to hit what you're seeing. I've created a configuration that
should do this but it'll take a long time to run on a local test machine.

I'm not 100% certain I guessed right as to get fsmark reports while memory
fills, it would have to be fewer files so each iteration would have to
preserve files. If the number of files per iteration is large enough to
fill memory then the drop in files/sec is not visible from the fs_mark
output (or we are using different versions). I guess you could just be
calculating average files/sec over the entire run based on elapsed time.

> > The workload is creating one dirty cached inode for every dirty
> > page, both of which should require a single IO each to clean and
> > reclaim, and creation of inodes is throttled by the rate at which
> > dirty writeback runs at (via balance dirty pages). Hence the ingest
> > rate of new cached inodes and page cache pages is identical and
> > steady. As a result, memory reclaim should quickly find a steady
> > balance between page cache and inode caches.
> > 
> > It doesn't.
> > 
> > The moment memory fills, the page cache is reclaimed at a much
> > faster rate than the inode cache, and evidence suggests taht the
> > inode cache shrinker is not being called when large batches of pages
> > are being reclaimed. In roughly the same time period that it takes
> > to fill memory with 50% pages and 50% slab caches, memory reclaim
> > reduces the page cache down to just dirty pages and slab caches fill
> > the entirity of memory.
> > 
> > At the point where the page cache is reduced to just the dirty
> > pages, there is a clear change in write IO patterns. Up to this
> > point it has been running at a steady 1500 write IOPS for ~200MB/s
> > of write throughtput (data, journal and metadata).

As observed by iostat -x or something else? Sum of r/s and w/s would
approximate iops but not the breakdown of whether it is data, journal
or metadata writes. The rest can be inferred from a blktrace but I would
prefer to replicate your setup as close as possible. If you're not using
fs_mark to report Files/sec, are you simply monitoring df -i over time?

> > <SNIP additional detail on fs_mark output>
> > <SNIP additional detail on monitoring meminfo over time>
> > <SNIP observations on dirty handling>

All understood.

> > So I went looking at the code, trying to find places where pages got
> > reclaimed and the shrinkers weren't called. There's only one -
> > kswapd doing boosted reclaim as per commit 1c30844d2dfe ("mm: reclaim
> > small amounts of memory when an external fragmentation event
> > occurs"). I'm not even using THP or allocating huge pages, so this
> > code should not be active or having any effect onmemory reclaim at
> > all, yet the majority of reclaim is being done with "boost" and so
> > it's not reclaiming slab caches at all. It will only free clean
> > pages from the LRU.
> > 
> > And so when we do run out memory, it switches to normal reclaim,
> > which hits dirty pages on the LRU and does some shrinker work, too,
> > but then appears to switch back to boosted reclaim one watermarks
> > are reached.
> > 
> > The patch below restores page cache vs inode cache balance for this
> > steady state workload. It balances out at about 40% page cache, 60%
> > slab cache, and sustained performance is 10-15% higher than without
> > this patch because the IO patterns remain in control of dirty
> > writeback and the filesystem, not kswapd.
> > 
> > Performance with boosted reclaim also running shrinkers over the
> > same steady state portion of the test as above.
> > 

The boosting was not intended to target THP specifically -- it was meant
to help recover early from any fragmentation-related event for any user
that might need it. Hence, it's not tied to THP but even with THP
disabled, the boosting will still take effect.

One band-aid would be to disable watermark boosting entirely when THP is
disabled but that feels wrong. However, I would be interested in hearing
if sysctl vm.watermark_boost_factor=0 has the same effect as your patch.

The intention behind avoiding slab reclaim from kswapd context is that the
boost is due to a fragmentation-causing event. Compaction cannot move slab
pages so reclaiming them in response to fragmentation does not directly
help. However, it can indirectly help by avoiding fragmentation-causing
events due to slab allocation like inodes and also mean that reclaim
behaviour is not special cased.

On that basis, it may justify ripping out the may_shrinkslab logic
everywhere. The downside is that some microbenchmarks will notice.
Specifically IO benchmarks that fill memory and reread (particularly
rereading the metadata via any inode operation) may show reduced
results. Such benchmarks can be strongly affected by whether the inode
information is still memory resident and watermark boosting reduces
the changes the data is still resident in memory. Technically still a
regression but a tunable one.

Hence the following "it builds" patch that has zero supporting data on
whether it's a good idea or not.

diff --git a/mm/vmscan.c b/mm/vmscan.c
index dbdc46a84f63..6051a9007150 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -88,9 +88,6 @@ struct scan_control {
 	/* Can pages be swapped as part of reclaim? */
 	unsigned int may_swap:1;
 
-	/* e.g. boosted watermark reclaim leaves slabs alone */
-	unsigned int may_shrinkslab:1;
-
 	/*
 	 * Cgroups are not reclaimed below their configured memory.low,
 	 * unless we threaten to OOM. If any cgroups are skipped due to
@@ -2714,10 +2711,8 @@ static bool shrink_node(pg_data_t *pgdat, struct scan_control *sc)
 			shrink_node_memcg(pgdat, memcg, sc, &lru_pages);
 			node_lru_pages += lru_pages;
 
-			if (sc->may_shrinkslab) {
-				shrink_slab(sc->gfp_mask, pgdat->node_id,
-				    memcg, sc->priority);
-			}
+			shrink_slab(sc->gfp_mask, pgdat->node_id,
+			    memcg, sc->priority);
 
 			/* Record the group's reclaim efficiency */
 			vmpressure(sc->gfp_mask, memcg, false,
@@ -3194,7 +3189,6 @@ unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
 		.may_writepage = !laptop_mode,
 		.may_unmap = 1,
 		.may_swap = 1,
-		.may_shrinkslab = 1,
 	};
 
 	/*
@@ -3238,7 +3232,6 @@ unsigned long mem_cgroup_shrink_node(struct mem_cgroup *memcg,
 		.may_unmap = 1,
 		.reclaim_idx = MAX_NR_ZONES - 1,
 		.may_swap = !noswap,
-		.may_shrinkslab = 1,
 	};
 	unsigned long lru_pages;
 
@@ -3286,7 +3279,6 @@ unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
 		.may_writepage = !laptop_mode,
 		.may_unmap = 1,
 		.may_swap = may_swap,
-		.may_shrinkslab = 1,
 	};
 
 	set_task_reclaim_state(current, &sc.reclaim_state);
@@ -3598,7 +3590,6 @@ static int balance_pgdat(pg_data_t *pgdat, int order, int classzone_idx)
 		 */
 		sc.may_writepage = !laptop_mode && !nr_boost_reclaim;
 		sc.may_swap = !nr_boost_reclaim;
-		sc.may_shrinkslab = !nr_boost_reclaim;
 
 		/*
 		 * Do some background aging of the anon list, to give

-- 
Mel Gorman
SUSE Labs
