Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from outbound-smtp16.blacknight.com ([46.22.139.233]:40626 "EHLO
        outbound-smtp16.blacknight.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388123AbfHGXsT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Aug 2019 19:48:19 -0400
Received: from mail.blacknight.com (pemlinmail04.blacknight.ie [81.17.254.17])
        by outbound-smtp16.blacknight.com (Postfix) with ESMTPS id AF64B1C2400
        for <linux-xfs@vger.kernel.org>; Thu,  8 Aug 2019 00:48:16 +0100 (IST)
Date: Thu, 8 Aug 2019 00:48:15 +0100
From: Mel Gorman <mgorman@techsingularity.net>
Subject: Re: [PATCH] [Regression, v5.0] mm: boosted kswapd reclaim b0rks
 system cache balance
Message-ID: <20190807234815.GJ2739@techsingularity.net>
References: <20190807091858.2857-1-david@fromorbit.com>
 <20190807093056.GS11812@dhcp22.suse.cz>
 <20190807150316.GL2708@suse.de>
 <20190807205615.GI2739@techsingularity.net>
 <20190807223241.GO7777@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20190807223241.GO7777@dread.disaster.area>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Michal Hocko <mhocko@kernel.org>, linux-mm@kvack.org, linux-xfs@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>

On Thu, Aug 08, 2019 at 08:32:41AM +1000, Dave Chinner wrote:
> On Wed, Aug 07, 2019 at 09:56:15PM +0100, Mel Gorman wrote:
> > On Wed, Aug 07, 2019 at 04:03:16PM +0100, Mel Gorman wrote:
> > > <SNIP>
> > >
> > > On that basis, it may justify ripping out the may_shrinkslab logic
> > > everywhere. The downside is that some microbenchmarks will notice.
> > > Specifically IO benchmarks that fill memory and reread (particularly
> > > rereading the metadata via any inode operation) may show reduced
> > > results. Such benchmarks can be strongly affected by whether the inode
> > > information is still memory resident and watermark boosting reduces
> > > the changes the data is still resident in memory. Technically still a
> > > regression but a tunable one.
> > > 
> > > Hence the following "it builds" patch that has zero supporting data on
> > > whether it's a good idea or not.
> > > 
> > 
> > This is a more complete version of the same patch that summaries the
> > problem and includes data from my own testing
> ....
> > A fsmark benchmark configuration was constructed similar to
> > what Dave reported and is codified by the mmtest configuration
> > config-io-fsmark-small-file-stream.  It was evaluated on a 1-socket machine
> > to avoid dealing with NUMA-related issues and the timing of reclaim. The
> > storage was an SSD Samsung Evo and a fresh XFS filesystem was used for
> > the test data.
> 
> Have you run fstrim on that drive recently? I'm running these tests
> on a 960 EVO ssd, and when I started looking at shrinkers 3 weeks
> ago I had all sorts of whacky performance problems and inconsistent
> results. Turned out there were all sorts of random long IO latencies
> occurring (in the hundreds of milliseconds) because the drive was
> constantly running garbage collection to free up space. As a result
> it was both blocking on GC and thermal throttling under these fsmark
> workloads.
> 

No, I was under the impression that making a new filesystem typically
trimmed it as well. Maybe that's just some filesystems (e.g. ext4) or
just completely wrong.

> I made a new XFS filesystem on it (lazy man's rm -rf *),

Ah, all IO tests I do make a new filesystem. I know there is the whole
problem of filesystem aging but I've yet to come across a methodology
that two people can agree on that is a sensible, reproducible method.

> then ran
> fstrim on it to tell the drive all the space is free. Drive temps
> dropped 30C immediately, and all of the whacky performance anomolies
> went away. I now fstrim the drive in my vm startup scripts before
> each test run, and it's giving consistent results again.
> 

I'll replicate that if making a new filesystem is not guaranteed to
trim. It'll muck up historical data but that happens to me every so
often anyway.

> > It is likely that the test configuration is not a proper match for Dave's
> > test as the results are different in terms of performance. However, my
> > configuration reports fsmark performance every 10% of memory worth of
> > files and I suspect Dave's configuration reported Files/sec when memory
> > was already full. THP was enabled for mine, disabled for Dave's and
> > probably a whole load of other methodology differences that rarely
> > get recorded properly.
> 
> Yup, like I forgot to mention that my test system is using a 4-node
> fakenuma setup (i.e. 4 nodes, 4GB RAM and 4 CPUs per node, so
> there are 4 separate kswapd's doing concurrent reclaim). That
> changes reclaim patterns as well.
> 

Good to know. In this particular case, I don't think I need to exactly
replicate what you have given that the slam reclaim behaviour is
definitely more consistent and the ratios of slab/pagecache are
predictable.

> 
> > fsmark
> >                                    5.3.0-rc3              5.3.0-rc3
> >                                      vanilla          shrinker-v1r1
> > Min       1-files/sec     5181.70 (   0.00%)     3204.20 ( -38.16%)
> > 1st-qrtle 1-files/sec    14877.10 (   0.00%)     6596.90 ( -55.66%)
> > 2nd-qrtle 1-files/sec     6521.30 (   0.00%)     5707.80 ( -12.47%)
> > 3rd-qrtle 1-files/sec     5614.30 (   0.00%)     5363.80 (  -4.46%)
> > Max-1     1-files/sec    18463.00 (   0.00%)    18479.90 (   0.09%)
> > Max-5     1-files/sec    18028.40 (   0.00%)    17829.00 (  -1.11%)
> > Max-10    1-files/sec    17502.70 (   0.00%)    17080.90 (  -2.41%)
> > Max-90    1-files/sec     5438.80 (   0.00%)     5106.60 (  -6.11%)
> > Max-95    1-files/sec     5390.30 (   0.00%)     5020.40 (  -6.86%)
> > Max-99    1-files/sec     5271.20 (   0.00%)     3376.20 ( -35.95%)
> > Max       1-files/sec    18463.00 (   0.00%)    18479.90 (   0.09%)
> > Hmean     1-files/sec     7459.11 (   0.00%)     6249.49 ( -16.22%)
> > Stddev    1-files/sec     4733.16 (   0.00%)     4362.10 (   7.84%)
> > CoeffVar  1-files/sec       51.66 (   0.00%)       57.49 ( -11.29%)
> > BHmean-99 1-files/sec     7515.09 (   0.00%)     6351.81 ( -15.48%)
> > BHmean-95 1-files/sec     7625.39 (   0.00%)     6486.09 ( -14.94%)
> > BHmean-90 1-files/sec     7803.19 (   0.00%)     6588.61 ( -15.57%)
> > BHmean-75 1-files/sec     8518.74 (   0.00%)     6954.25 ( -18.37%)
> > BHmean-50 1-files/sec    10953.31 (   0.00%)     8017.89 ( -26.80%)
> > BHmean-25 1-files/sec    16732.38 (   0.00%)    11739.65 ( -29.84%)
> > 
> >                    5.3.0-rc3   5.3.0-rc3
> >                      vanillashrinker-v1r1
> > Duration User          77.29       89.09
> > Duration System      1097.13     1332.86
> > Duration Elapsed     2014.14     2596.39
> 
> I'm not sure we are testing or measuring exactly the same things :)
> 

Probably not.

> > This is showing that fsmark runs slower as a result of this patch but
> > there are other important observations that justify the patch.
> > 
> > 1. With the vanilla kernel, the number of dirty pages in the system
> >    is very low for much of the test. With this patch, dirty pages
> >    is generally kept at 10% which matches vm.dirty_background_ratio
> >    which is normal expected historical behaviour.
> > 
> > 2. With the vanilla kernel, the ratio of Slab/Pagecache is close to
> >    0.95 for much of the test i.e. Slab is being left alone and dominating
> >    memory consumption. With the patch applied, the ratio varies between
> >    0.35 and 0.45 with the bulk of the measured ratios roughly half way
> >    between those values. This is a different balance to what Dave reported
> >    but it was at least consistent.
> 
> Yeah, the balance is typically a bit different for different configs
> and storage. The trick is getting the balance to be roughly
> consistent across a range of different configs. The fakenuma setup
> also has a significant impact on where the balance is found. And I
> can't remember if the "fixed" memory usage numbers I quoted came
> from a run with my "make XFS inode reclaim nonblocking" patchset or
> not.
> 

Again, I wouldn't sweat too much about it. The generated graphs
definitely showed more consistent behaviour even if the headline
performance was not improved.

> > 3. Slabs are scanned throughout the entire test with the patch applied.
> >    The vanille kernel has long periods with no scan activity and then
> >    relatively massive spikes.
> > 
> > 4. Overall vmstats are closer to normal expectations
> > 
> > 	                                5.3.0-rc3      5.3.0-rc3
> > 	                                  vanilla  shrinker-v1r1
> > 	Direct pages scanned             60308.00        5226.00
> > 	Kswapd pages scanned          18316110.00    12295574.00
> > 	Kswapd pages reclaimed        13121037.00     7280152.00
> > 	Direct pages reclaimed           11817.00        5226.00
> > 	Kswapd efficiency %                 71.64          59.21
> > 	Kswapd velocity                   9093.76        4735.64
> > 	Direct efficiency %                 19.59         100.00
> > 	Direct velocity                     29.94           2.01
> > 	Page reclaim immediate          247921.00           0.00
> > 	Slabs scanned                 16602344.00    29369536.00
> > 	Direct inode steals               1574.00         800.00
> > 	Kswapd inode steals             130033.00     3968788.00
> > 	Kswapd skipped wait                  0.00           0.00
> 
> That looks a lot better. Patch looks reasonable, though I'm
> interested to know what impact it has on tests you ran in the
> original commit for the boosting.
> 

I'll find out soon enough but I'm leaning on the side that kswapd reclaim
should be predictable and that even if there are some performance problems
as a result of it, there will be others that see a gain. It'll be a case
of "no matter what way you jump, someone shouts" but kswapd having spiky
unpredictable behaviour is a recipe for "sometimes my machine is crap
and I've no idea why".

-- 
Mel Gorman
SUSE Labs
