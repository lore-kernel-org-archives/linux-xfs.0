Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2839E7F52
	for <xfs@oss.sgi.com>; Mon,  4 Feb 2013 06:52:43 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1549530404E
	for <xfs@oss.sgi.com>; Mon,  4 Feb 2013 04:52:39 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	GAWIhvFVcHIcEH10 for <xfs@oss.sgi.com>;
	Mon, 04 Feb 2013 04:52:38 -0800 (PST)
Date: Mon, 4 Feb 2013 23:52:34 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Looking for Linux XFS file system performance tuning tips for
	LSI9271-8i + 8 SSD's RAID0
Message-ID: <20130204125234.GK2667@dastard>
References: <courier.510ECA60.00003A99@softhome.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <courier.510ECA60.00003A99@softhome.net>
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
To: rkj@softhome.net
Cc: xfs@oss.sgi.com

On Sun, Feb 03, 2013 at 01:36:48PM -0700, rkj@softhome.net wrote:
> 
> I am working with hardware RAID0 using LSI 9271-8i + 8 SSD's.  I am
> using CentOS 6.3 on a Supermicro X9SAE-V motherboard with Intel Xeon
> E3-1275V2 CPU and 32GB 1600 MHz ECC RAM.  My application is fast
> sensor data store and forward with UDP based file transfer using
> multiple 10GbE interfaces.  So I do not have any concurrent loading,
> I am mainly interested in optimizing sequential read/write
> performance.
>
> Raw performance as measured by Gnome Disk Utility is around 4GB/s
> sustained read/write.

I don't know what that does - probably lots of concurrent IO to drive
deep queue depths to get the absolute maximum possible from the
device....

> With XFS buffer IO, my sequential writes max
> out at about  2.5 GB/s.

CPU bound on single threaded IO, I'd guess.

> With Direct IO, the sequential writes are
> around 3.5 GB/s but I noticed a drop-off in sequential reads for
> smaller record sizes.

Almost certainly IO latency bound on single threaded IO.

> I am trying to get the XFS sequential
> read/writes as close to 4 GB/s as possible.

Time to go look up how to use async IO or multithreaded direct
IO.

FWIW, the best benchmark is your application - none of what you've
talked about even come close to modelling the data flow a
network-disk-network store-and-forward system needs, and a data
rates of 4GB/s you are going to benchmark the network devices
flowing data at the same time you do disk IO....

> I have documented all of the various mkfs.xfs options I have tried,
> fstab mount options, iozone results, etc. in this forum thread:

Configuration changes won't make any difference to data IO latency
or CPU usage. IOWs, SSDs don't magically solve the problem of having
to optimise the way the applications/benchmarks do IO and so no
amount of tweaking the filesystem will get you to your goal if the
application is deficient...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
