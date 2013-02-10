Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 870C27F50
	for <xfs@oss.sgi.com>; Sun, 10 Feb 2013 15:07:08 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 66D5A304032
	for <xfs@oss.sgi.com>; Sun, 10 Feb 2013 13:07:05 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	jTvF82cjOF0p6rBb for <xfs@oss.sgi.com>;
	Sun, 10 Feb 2013 13:07:00 -0800 (PST)
Date: Mon, 11 Feb 2013 08:06:52 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_inode slab
Message-ID: <20130210210652.GB8257@dastard>
References: <1360480449.4034.8.camel@hakkenden.homenet>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1360480449.4034.8.camel@hakkenden.homenet>
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
To: "Nikolay S." <nowhere@hakkenden.ath.cx>
Cc: xfs@oss.sgi.com

On Sun, Feb 10, 2013 at 11:14:09AM +0400, Nikolay S. wrote:
> Hello there,
> 
> I see some bad behavior of xfs, which I can reproduce:
> 
> 1. Create some directories and files on xfs volume (I use ~800000 files
> and 80000 directories on 4GB RAM system)
> 2. Create workload, that produces light page cache pressure (say, 4-8
> MB/s) and while pagecache eats all of free ram. I use the code from [1])
> 3. Stat all the objects on xfs volume
> 
> The result depends on kernel version:
> 	3.2) See kswapd struggling through D-state for several minutes.
> 	3.7) See kswapd struggling through D-state forever

I can't reproduce it on any of my test boxes (range from 1GB to 8GB
RAM) on XFS or ext4. Indeed, this is a stress test I use
all the time (file creation, traversal and removal under page cache
pressure using 50-100 million files), and I haven't seen a stall for
a long time....

> Same steps on ext4 do not produce any bad results
> 
> --
> [1]	https://bugzilla.kernel.org/show_bug.cgi?id=53031

Having looked at the bz, I don't see what XFS has to do with this
kswapd problem - it looks like it is THP/compaction related, and I
don't enable THP and/or compaction on my test machines. kswapd
is stuck deep in the VM on the page LRUs, so it doesn't look like an
XFS problem at all. If you turn off THP/compaction, does the problem
go away?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
