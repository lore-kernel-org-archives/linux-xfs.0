Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:58497 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727213AbfHGWJb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Aug 2019 18:09:31 -0400
Date: Thu, 8 Aug 2019 08:08:17 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] [Regression, v5.0] mm: boosted kswapd reclaim b0rks
 system cache balance
Message-ID: <20190807220817.GN7777@dread.disaster.area>
References: <20190807091858.2857-1-david@fromorbit.com>
 <20190807093056.GS11812@dhcp22.suse.cz>
 <20190807150316.GL2708@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190807150316.GL2708@suse.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@kernel.org>, linux-mm@kvack.org, linux-xfs@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>

On Wed, Aug 07, 2019 at 04:03:16PM +0100, Mel Gorman wrote:
> On Wed, Aug 07, 2019 at 11:30:56AM +0200, Michal Hocko wrote:
> > [Cc Mel and Vlastimil as it seems like fallout from 1c30844d2dfe2]
> > 
> 
> More than likely.
> 
> > On Wed 07-08-19 19:18:58, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > When running a simple, steady state 4kB file creation test to
> > > simulate extracting tarballs larger than memory full of small files
> > > into the filesystem, I noticed that once memory fills up the cache
> > > balance goes to hell.
> > > 
> 
> Ok, I'm assuming you are using fsmark with -k to keep files around,
> and -S0 to leave cleaning to the background flush, a number of files per
> iteration to get regular reporting and a total number of iterations to
> fill memory to hit what you're seeing. I've created a configuration that
> should do this but it'll take a long time to run on a local test machine.

./fs_mark  -D  10000  -S0  -n  10000  -s  4096  -L  60 \
-d /mnt/scratch/0  -d  /mnt/scratch/1  -d  /mnt/scratch/2 \
-d /mnt/scratch/3  -d  /mnt/scratch/4  -d  /mnt/scratch/5 \
-d /mnt/scratch/6  -d  /mnt/scratch/7  -d  /mnt/scratch/8 \
-d /mnt/scratch/9  -d  /mnt/scratch/10  -d  /mnt/scratch/11 \
-d /mnt/scratch/12  -d  /mnt/scratch/13  -d  /mnt/scratch/14 \
-d /mnt/scratch/15

This doesn't delete files at all, creates 160,000 files per
iteration in directories of 10,000 files at a time, and runs 60
iterations. It leaves all writeback (data and metadata) to
background kernel mechanisms.

> I'm not 100% certain I guessed right as to get fsmark reports while memory
> fills, it would have to be fewer files so each iteration would have to
> preserve files. If the number of files per iteration is large enough to
> fill memory then the drop in files/sec is not visible from the fs_mark
> output (or we are using different versions). I guess you could just be
> calculating average files/sec over the entire run based on elapsed time.

The files/s average is the average of the fsmark iteration output.
(i.e. the rate at which it creates each group of 160k files).

> 
> > > The workload is creating one dirty cached inode for every dirty
> > > page, both of which should require a single IO each to clean and
> > > reclaim, and creation of inodes is throttled by the rate at which
> > > dirty writeback runs at (via balance dirty pages). Hence the ingest
> > > rate of new cached inodes and page cache pages is identical and
> > > steady. As a result, memory reclaim should quickly find a steady
> > > balance between page cache and inode caches.
> > > 
> > > It doesn't.
> > > 
> > > The moment memory fills, the page cache is reclaimed at a much
> > > faster rate than the inode cache, and evidence suggests taht the
> > > inode cache shrinker is not being called when large batches of pages
> > > are being reclaimed. In roughly the same time period that it takes
> > > to fill memory with 50% pages and 50% slab caches, memory reclaim
> > > reduces the page cache down to just dirty pages and slab caches fill
> > > the entirity of memory.
> > > 
> > > At the point where the page cache is reduced to just the dirty
> > > pages, there is a clear change in write IO patterns. Up to this
> > > point it has been running at a steady 1500 write IOPS for ~200MB/s
> > > of write throughtput (data, journal and metadata).
> 
> As observed by iostat -x or something else? Sum of r/s and w/s would

PCP + live pmcharts. Same as I've done for 15+ years :)

I could look at iostat, but it's much easier to watch graphs run
and then be able to double click on any point and get the actual
value.

I've attached a screen shot of the test machine overview while the
vanilla kernel runs the fsmark test (cpu, iops, IO bandwidth, XFS
create/remove/lookup ops, context switch rate and memory usage) at a
1 second sample rate. You can see the IO patterns change, the
context switch rate go nuts and the CPU usage pattern change when
the page cache hits empty.

> approximate iops but not the breakdown of whether it is data, journal
> or metadata writes.

I have that in other charts - the log chart tells me how many log
IOs are being done (constant 30MB/s in ~150 IOs/sec). And the >1GB/s
IO spike every 30s is the metadata writeback being aggregated into
large IOs by metadata writeback. That doesn't change, either...

> The rest can be inferred from a blktrace but I would
> prefer to replicate your setup as close as possible. If you're not using
> fs_mark to report Files/sec, are you simply monitoring df -i over time?

The way I run fsmark is iterative - the count field tells you how
many inodes it has created...

> > > So I went looking at the code, trying to find places where pages got
> > > reclaimed and the shrinkers weren't called. There's only one -
> > > kswapd doing boosted reclaim as per commit 1c30844d2dfe ("mm: reclaim
> > > small amounts of memory when an external fragmentation event
> > > occurs"). I'm not even using THP or allocating huge pages, so this
> > > code should not be active or having any effect onmemory reclaim at
> > > all, yet the majority of reclaim is being done with "boost" and so
> > > it's not reclaiming slab caches at all. It will only free clean
> > > pages from the LRU.
> > > 
> > > And so when we do run out memory, it switches to normal reclaim,
> > > which hits dirty pages on the LRU and does some shrinker work, too,
> > > but then appears to switch back to boosted reclaim one watermarks
> > > are reached.
> > > 
> > > The patch below restores page cache vs inode cache balance for this
> > > steady state workload. It balances out at about 40% page cache, 60%
> > > slab cache, and sustained performance is 10-15% higher than without
> > > this patch because the IO patterns remain in control of dirty
> > > writeback and the filesystem, not kswapd.
> > > 
> > > Performance with boosted reclaim also running shrinkers over the
> > > same steady state portion of the test as above.
> > > 
> 
> The boosting was not intended to target THP specifically -- it was meant
> to help recover early from any fragmentation-related event for any user
> that might need it. Hence, it's not tied to THP but even with THP
> disabled, the boosting will still take effect.
> 
> One band-aid would be to disable watermark boosting entirely when THP is
> disabled but that feels wrong. However, I would be interested in hearing
> if sysctl vm.watermark_boost_factor=0 has the same effect as your patch.

<runs test>

Ok, it still runs it out of page cache, but it doesn't drive page
cache reclaim as hard once there's none left. The IO patterns are
less peaky, context switch rates are increased from ~3k/s to 15k/s
but remain pretty steady.

Test ran 5s faster and  file rate improved by ~2%. So it's better
once the page cache is largerly fully reclaimed, but it doesn't
prevent the page cache from being reclaimed instead of inodes....


> On that basis, it may justify ripping out the may_shrinkslab logic
> everywhere. The downside is that some microbenchmarks will notice.
> Specifically IO benchmarks that fill memory and reread (particularly
> rereading the metadata via any inode operation) may show reduced
> results.

Sure, but right now benchmarks that rely on page cache being
retained are being screwed over :)

> Such benchmarks can be strongly affected by whether the inode
> information is still memory resident and watermark boosting reduces
> the changes the data is still resident in memory. Technically still a
> regression but a tunable one.

/proc/sys/vm/vfs_cache_pressure is for tuning page cache/inode cache
balance. It should not occur as a side effect of watermark boosting.
Everyone knows about vfs_cache_pressure. Lots of people complain
when it doesn't work, and that's something watermark boosting to
change cache balance does.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
