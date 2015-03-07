Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6EF737F5D
	for <xfs@oss.sgi.com>; Sat,  7 Mar 2015 10:37:11 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5D5AD8F8040
	for <xfs@oss.sgi.com>; Sat,  7 Mar 2015 08:37:08 -0800 (PST)
Received: from mail-wi0-f180.google.com (mail-wi0-f180.google.com
	[209.85.212.180]) by cuda.sgi.com with ESMTP id
	5iiIVQtl8qEVvy7l (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sat, 07 Mar 2015 08:37:03 -0800 (PST)
Received: by wivr20 with SMTP id r20so10315470wiv.5
	for <xfs@oss.sgi.com>; Sat, 07 Mar 2015 08:37:02 -0800 (PST)
Date: Sat, 7 Mar 2015 17:36:58 +0100
From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 4/4] mm: numa: Slow PTE scan rate if migration failures
	occur
Message-ID: <20150307163657.GA9702@gmail.com>
References: <1425741651-29152-1-git-send-email-mgorman@suse.de>
	<1425741651-29152-5-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1425741651-29152-5-git-send-email-mgorman@suse.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Mel Gorman <mgorman@suse.de>
Cc: linuxppc-dev@lists.ozlabs.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Linux-MM <linux-mm@kvack.org>, Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>


* Mel Gorman <mgorman@suse.de> wrote:

> Dave Chinner reported the following on https://lkml.org/lkml/2015/3/1/226
> 
> Across the board the 4.0-rc1 numbers are much slower, and the 
> degradation is far worse when using the large memory footprint 
> configs. Perf points straight at the cause - this is from 4.0-rc1 on 
> the "-o bhash=101073" config:
> 
> [...]

>            4.0.0-rc1   4.0.0-rc1      3.19.0
>              vanilla  slowscan-v2     vanilla
> User        53384.29    56093.11    46119.12
> System        692.14      311.64      306.41
> Elapsed      1236.87     1328.61     1039.88
> 
> Note that the system CPU usage is now similar to 3.19-vanilla.

Similar, but still worse, and also the elapsed time is still much 
worse. User time is much higher, although it's the same amount of work 
done on every kernel, right?

> I also tested with a workload very similar to Dave's. The machine 
> configuration and storage is completely different so it's not an 
> equivalent test unfortunately. It's reporting the elapsed time and 
> CPU time while fsmark is running to create the inodes and when 
> runnig xfsrepair afterwards
> 
> xfsrepair
>                                     4.0.0-rc1             4.0.0-rc1                3.19.0
>                                       vanilla           slowscan-v2               vanilla
> Min      real-fsmark        1157.41 (  0.00%)     1150.38 (  0.61%)     1164.44 ( -0.61%)
> Min      syst-fsmark        3998.06 (  0.00%)     3988.42 (  0.24%)     4016.12 ( -0.45%)
> Min      real-xfsrepair      497.64 (  0.00%)      456.87 (  8.19%)      442.64 ( 11.05%)
> Min      syst-xfsrepair      500.61 (  0.00%)      263.41 ( 47.38%)      194.97 ( 61.05%)
> Amean    real-fsmark        1166.63 (  0.00%)     1155.97 (  0.91%)     1166.28 (  0.03%)
> Amean    syst-fsmark        4020.94 (  0.00%)     4004.19 (  0.42%)     4025.87 ( -0.12%)
> Amean    real-xfsrepair      507.85 (  0.00%)      459.58 (  9.50%)      447.66 ( 11.85%)
> Amean    syst-xfsrepair      519.88 (  0.00%)      281.63 ( 45.83%)      202.93 ( 60.97%)
> Stddev   real-fsmark           6.55 (  0.00%)        3.97 ( 39.30%)        1.44 ( 77.98%)
> Stddev   syst-fsmark          16.22 (  0.00%)       15.09 (  6.96%)        9.76 ( 39.86%)
> Stddev   real-xfsrepair       11.17 (  0.00%)        3.41 ( 69.43%)        5.57 ( 50.17%)
> Stddev   syst-xfsrepair       13.98 (  0.00%)       19.94 (-42.60%)        5.69 ( 59.31%)
> CoeffVar real-fsmark           0.56 (  0.00%)        0.34 ( 38.74%)        0.12 ( 77.97%)
> CoeffVar syst-fsmark           0.40 (  0.00%)        0.38 (  6.57%)        0.24 ( 39.93%)
> CoeffVar real-xfsrepair        2.20 (  0.00%)        0.74 ( 66.22%)        1.24 ( 43.47%)
> CoeffVar syst-xfsrepair        2.69 (  0.00%)        7.08 (-163.23%)        2.80 ( -4.23%)
> Max      real-fsmark        1171.98 (  0.00%)     1159.25 (  1.09%)     1167.96 (  0.34%)
> Max      syst-fsmark        4033.84 (  0.00%)     4024.53 (  0.23%)     4039.20 ( -0.13%)
> Max      real-xfsrepair      523.40 (  0.00%)      464.40 ( 11.27%)      455.42 ( 12.99%)
> Max      syst-xfsrepair      533.37 (  0.00%)      309.38 ( 42.00%)      207.94 ( 61.01%)
> 
> The key point is that system CPU usage for xfsrepair (syst-xfsrepair)
> is almost cut in half. It's still not as low as 3.19-vanilla but it's
> much closer
> 
>                              4.0.0-rc1   4.0.0-rc1      3.19.0
>                                vanilla  slowscan-v2     vanilla
> NUMA alloc hit               146138883   121929782   104019526
> NUMA alloc miss               13146328    11456356     7806370
> NUMA interleave hit                  0           0           0
> NUMA alloc local             146060848   121865921   103953085
> NUMA base PTE updates        242201535   117237258   216624143
> NUMA huge PMD updates           113270       52121      127782
> NUMA page range updates      300195775   143923210   282048527
> NUMA hint faults             180388025    87299060   147235021
> NUMA hint local faults        72784532    32939258    61866265
> NUMA hint local percent             40          37          42
> NUMA pages migrated           71175262    41395302    23237799
> 
> Note the big differences in faults trapped and pages migrated. 
> 3.19-vanilla still migrated fewer pages but if necessary the 
> threshold at which we start throttling migrations can be lowered.

This too is still worse than what v3.19 had.

So what worries me is that Dave bisected the regression to:

  4d9424669946 ("mm: convert p[te|md]_mknonnuma and remaining page table manipulations")

And clearly your patch #4 just tunes balancing/migration intensity - 
is that a workaround for the real problem/bug?

And the patch Dave bisected to is a relatively simple patch.
Why not simply revert it to see whether that cures much of the 
problem?

Am I missing something fundamental?

Thanks,

	Ingo

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
