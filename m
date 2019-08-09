Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43118 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726054AbfHIIqV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 9 Aug 2019 04:46:21 -0400
Subject: Re: [PATCH] mm, vmscan: Do not special-case slab reclaim when
 watermarks are boosted
References: <20190808182946.GM2739@techsingularity.net>
From: Vlastimil Babka <vbabka@suse.cz>
Message-ID: <7c39799f-ce00-e506-ef3b-4cd8fbff643c@suse.cz>
Date: Fri, 9 Aug 2019 10:46:19 +0200
MIME-Version: 1.0
In-Reply-To: <20190808182946.GM2739@techsingularity.net>
Content-Type: text/plain; charset=iso-8859-15
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Mel Gorman <mgorman@techsingularity.net>, Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Chinner <david@fromorbit.com>, Michal Hocko <mhocko@kernel.org>, linux-mm@kvack.org, linux-xfs@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

On 8/8/19 8:29 PM, Mel Gorman wrote:

...

> Removing the special casing can still indirectly help fragmentation by

I think you mean e.g. 'against fragmentation'?

> avoiding fragmentation-causing events due to slab allocation as pages
> from a slab pageblock will have some slab objects freed.  Furthermore,
> with the special casing, reclaim behaviour is unpredictable as kswapd
> sometimes examines slab and sometimes does not in a manner that is tricky
> to tune or analyse.
> 
> This patch removes the special casing. The downside is that this is not a
> universal performance win. Some benchmarks that depend on the residency
> of data when rereading metadata may see a regression when slab reclaim
> is restored to its original behaviour. Similarly, some benchmarks that
> only read-once or write-once may perform better when page reclaim is too
> aggressive. The primary upside is that slab shrinker is less surprising
> (arguably more sane but that's a matter of opinion), behaves consistently
> regardless of the fragmentation state of the system and properly obeys
> VM sysctls.
> 
> A fsmark benchmark configuration was constructed similar to
> what Dave reported and is codified by the mmtest configuration
> config-io-fsmark-small-file-stream.  It was evaluated on a 1-socket machine
> to avoid dealing with NUMA-related issues and the timing of reclaim. The
> storage was an SSD Samsung Evo and a fresh trimmed XFS filesystem was
> used for the test data.
> 
> This is not an exact replication of Dave's setup. The configuration
> scales its parameters depending on the memory size of the SUT to behave
> similarly across machines. The parameters mean the first sample reported
> by fs_mark is using 50% of RAM which will barely be throttled and look
> like a big outlier. Dave used fake NUMA to have multiple kswapd instances
> which I didn't replicate.  Finally, the number of iterations differ from
> Dave's test as the target disk was not large enough.  While not identical,
> it should be representative.
> 
> fsmark
>                                    5.3.0-rc3              5.3.0-rc3
>                                      vanilla          shrinker-v1r1
> Min       1-files/sec     4444.80 (   0.00%)     4765.60 (   7.22%)
> 1st-qrtle 1-files/sec     5005.10 (   0.00%)     5091.70 (   1.73%)
> 2nd-qrtle 1-files/sec     4917.80 (   0.00%)     4855.60 (  -1.26%)
> 3rd-qrtle 1-files/sec     4667.40 (   0.00%)     4831.20 (   3.51%)
> Max-1     1-files/sec    11421.50 (   0.00%)     9999.30 ( -12.45%)
> Max-5     1-files/sec    11421.50 (   0.00%)     9999.30 ( -12.45%)
> Max-10    1-files/sec    11421.50 (   0.00%)     9999.30 ( -12.45%)
> Max-90    1-files/sec     4649.60 (   0.00%)     4780.70 (   2.82%)
> Max-95    1-files/sec     4491.00 (   0.00%)     4768.20 (   6.17%)
> Max-99    1-files/sec     4491.00 (   0.00%)     4768.20 (   6.17%)
> Max       1-files/sec    11421.50 (   0.00%)     9999.30 ( -12.45%)
> Hmean     1-files/sec     5004.75 (   0.00%)     5075.96 (   1.42%)
> Stddev    1-files/sec     1778.70 (   0.00%)     1369.66 (  23.00%)
> CoeffVar  1-files/sec       33.70 (   0.00%)       26.05 (  22.71%)
> BHmean-99 1-files/sec     5053.72 (   0.00%)     5101.52 (   0.95%)
> BHmean-95 1-files/sec     5053.72 (   0.00%)     5101.52 (   0.95%)
> BHmean-90 1-files/sec     5107.05 (   0.00%)     5131.41 (   0.48%)
> BHmean-75 1-files/sec     5208.45 (   0.00%)     5206.68 (  -0.03%)
> BHmean-50 1-files/sec     5405.53 (   0.00%)     5381.62 (  -0.44%)
> BHmean-25 1-files/sec     6179.75 (   0.00%)     6095.14 (  -1.37%)
> 
>                    5.3.0-rc3   5.3.0-rc3
>                      vanillashrinker-v1r1
> Duration User         501.82      497.29
> Duration System      4401.44     4424.08
> Duration Elapsed     8124.76     8358.05
> 
> This is showing a slight skew for the max result representing a
> large outlier for the 1st, 2nd and 3rd quartile are similar indicating
> that the bulk of the results show little difference. Note that an
> earlier version of the fsmark configuration showed a regression but
> that included more samples taken while memory was still filling.
> 
> Note that the elapsed time is higher. Part of this is that the
> configuration included time to delete all the test files when the test
> completes -- the test automation handles the possibility of testing fsmark
> with multiple thread counts. Without the patch, many of these objects
> would be memory resident which is part of what the patch is addressing.
> 
> There are other important observations that justify the patch.
> 
> 1. With the vanilla kernel, the number of dirty pages in the system
>    is very low for much of the test. With this patch, dirty pages
>    is generally kept at 10% which matches vm.dirty_background_ratio
>    which is normal expected historical behaviour.
> 
> 2. With the vanilla kernel, the ratio of Slab/Pagecache is close to
>    0.95 for much of the test i.e. Slab is being left alone and dominating
>    memory consumption. With the patch applied, the ratio varies between
>    0.35 and 0.45 with the bulk of the measured ratios roughly half way
>    between those values. This is a different balance to what Dave reported
>    but it was at least consistent.
> 
> 3. Slabs are scanned throughout the entire test with the patch applied.
>    The vanille kernel has periods with no scan activity and then relatively
>    massive spikes.
> 
> 4. Without the patch, kswapd scan rates are very variable. With the patch,
>    the scan rates remain quite stead.
> 
> 4. Overall vmstats are closer to normal expectations
> 
> 	                                5.3.0-rc3      5.3.0-rc3
> 	                                  vanilla  shrinker-v1r1
>     Ops Direct pages scanned             99388.00      328410.00
>     Ops Kswapd pages scanned          45382917.00    33451026.00
>     Ops Kswapd pages reclaimed        30869570.00    25239655.00
>     Ops Direct pages reclaimed           74131.00        5830.00
>     Ops Kswapd efficiency %                 68.02          75.45
>     Ops Kswapd velocity                   5585.75        4002.25
>     Ops Page reclaim immediate         1179721.00      430927.00
>     Ops Slabs scanned                 62367361.00    73581394.00
>     Ops Direct inode steals               2103.00        1002.00
>     Ops Kswapd inode steals             570180.00     5183206.00
> 
> 	o Vanilla kernel is hitting direct reclaim more frequently,
> 	  not very much in absolute terms but the fact the patch
> 	  reduces it is interesting
> 	o "Page reclaim immediate" in the vanilla kernel indicates
> 	  dirty pages are being encountered at the tail of the LRU.
> 	  This is generally bad and means in this case that the LRU
> 	  is not long enough for dirty pages to be cleaned by the
> 	  background flush in time. This is much reduced by the
> 	  patch.
> 	o With the patch, kswapd is reclaiming 10 times more slab
> 	  pages than with the vanilla kernel. This is indicative
> 	  of the watermark boosting over-protecting slab
> 
> A more complete set of tests were run that were part of the basis
> for introducing boosting and while there are some differences, they
> are well within tolerances.
> 
> Bottom line, the special casing kswapd to avoid slab behaviour is
> unpredictable and can lead to abnormal results for normal workloads. This
> patch restores the expected behaviour that slab and page cache is
> balanced consistently for a workload with a steady allocation ratio of
> slab/pagecache pages. It also means that if there are workloads that
> favour the preservation of slab over pagecache that it can be tuned via
> vm.vfs_cache_pressure where as the vanilla kernel effectively ignores
> the parameter when boosting is active.
> 
> Fixes: 1c30844d2dfe ("mm: reclaim small amounts of memory when an external fragmentation event occurs")
> Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> Cc: stable@vger.kernel.org # v5.0+

Acked-by: Vlastimil Babka <vbabka@suse.cz>
