Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C65F67F47
	for <xfs@oss.sgi.com>; Thu, 23 Apr 2015 17:49:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B8BBC8F8049
	for <xfs@oss.sgi.com>; Thu, 23 Apr 2015 15:49:43 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	ooyuvv3yuly5AEAv for <xfs@oss.sgi.com>;
	Thu, 23 Apr 2015 15:49:41 -0700 (PDT)
Date: Fri, 24 Apr 2015 08:43:24 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Inode and dentry cache behavior
Message-ID: <20150423224324.GM15810@dastard>
References: <CABppvi55C+vE7Ei8u=_ntC_heDQb4HwUcKom-_9hGkunk84Sfw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CABppvi55C+vE7Ei8u=_ntC_heDQb4HwUcKom-_9hGkunk84Sfw@mail.gmail.com>
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
To: Shrinand Javadekar <shrinand@maginatics.com>
Cc: xfs@oss.sgi.com

On Thu, Apr 23, 2015 at 12:50:15PM -0700, Shrinand Javadekar wrote:
> Hi,
> 
> I am running Openstack Swift on a single server with 8 disks. All
> these 8 disks are formatted with default XFS parameters. Each disk has
> a capacity of 3TB. The machine has 64GB of data.
> 
> Here's what Openstack Swift does:
....
> * We observe that the time for fsync remains pretty much constant throughout.
> * What seems to be causing the performance to nosedive, is that inode
> and dentry caching doesn't seem to be working.
> * For experiment sake, we set vfs_cache_pressure to 0 so there would
> be no reclaiming of inode and dentry cache entries. However, that does
> not seem to help.
> * We see openat() calls taking close to 1 second.
> 
> Any ideas, what might be causing this behavior? Are there other
> params, specifically, xfs params that can be tuned for this workload.
> The sequence of events above is the typical workload, at high
> concurrency.

Work out why you're disks are reporting 100% utilisation when they
have little or no IO being issued to them.

> See the attached files iostat_log and vmstat_log.

from the iostat log:

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
.....
dm-6              0.00     0.00    0.20   22.40     0.00     0.09    8.00    22.28  839.01 1224.00  835.57  44.25 100.00                                              
dm-7              0.00     0.00    0.00    1.20     0.00     0.00    8.00     2.82 1517.33    0.00 1517.33 833.33 100.00                                              
dm-8              0.00     0.00    0.00  195.20     0.00     0.76    8.00  1727.51 4178.89    0.00 4178.89   5.12 100.00                                              
...
dm-7              0.00     0.00    0.00    0.00     0.00     0.00     0.00     1.00    0.00    0.00    0.00   0.00 100.00                                              
dm-8              0.00     0.00    0.00    0.00     0.00     0.00     0.00  1178.85    0.00    0.00    0.00   0.00 100.00                                              

dm-7 is showing almost a second for single IO wait times, when it is
actually completing IO. dm-8 has a massive queue depth - I can only
assume you've tuned  sys/block/*/queue/nr_requests to something
really large? But like dm-7, it's showing very long IO times, and
that's likely the source of your latency problems.

i.e. this looks like a storage problem, not an XFS problem.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
