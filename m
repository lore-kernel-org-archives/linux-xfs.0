Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6H5QR4B048968 for <xfs@oss.sgi.com>; Tue, 17 Jul 2012 00:26:28 -0500
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	6jIvIkzqRDOHddwP for <xfs@oss.sgi.com>;
	Mon, 16 Jul 2012 22:26:25 -0700 (PDT)
Date: Tue, 17 Jul 2012 15:26:21 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: A little RAID experiment
Message-ID: <20120717052621.GB23387@dastard>
References: <CAAxjCEzh3+doupD=LmgqSbCeYWzn9Ru-vE4T8tOJmoud+28FDQ@mail.gmail.com>
	<CAAxjCEzEiXv5Kna9zxZ-ePbhNg6nfRinkU=PCuyX3QHesq5qcg@mail.gmail.com>
	<5004875D.1020305@hardwarefreak.com>
	<CAAxjCEw-NJzZmX3Q5CJ+aZ_Q7Yo39pMU=-hiXk0ghTMq7q3PWA@mail.gmail.com>
	<5004C243.6040404@hardwarefreak.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5004C243.6040404@hardwarefreak.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: xfs@oss.sgi.com

On Mon, Jul 16, 2012 at 08:39:15PM -0500, Stan Hoeppner wrote:
> It depends on the one, and what the one expects.  Most people on this
> list would never expect parity RAID to perform well with the workloads
> you're throwing at it.  Your expectations are clearly different than
> most on this list.

Rule of thumb: don't use RAID5/6 for small random write workloads.

> The kicker here is that most of the data you presented shows almost all
> writes being acked by cache, in which case RAID level should be
> irrelevant, but at the same time showing abysmal throughput.  When all
> write hit cache, throughput should be through the roof.

I bet it's single threaded, which means it is:

	sysbench		kernel
	write(2)
				issue io
				wait for completion
	write(2)
				issue io
				wait for completion
	write(2)
	.....

Which means throughput is limited by IO latency, not bandwidth.
If it takes 10us to do the write(2), issue and process the IO
completion, and it takes 10us for the hardware to do the IO, you're
limited to 50,000 IOPS, or 200MB/s. Given that the best being seen
is around 35MB/s, you're looking at around 10,000 IOPS of 100us
round trip time. At 5MB/s, it's 1200 IOPS or around 800us round
trip.

That's why you get different performance from the different raid
controllers - some process cache hits a lot faster than others.

As to the one that stalled - when the cache hits a certain level of
dirtiness (say 50%), it will start flushing cached writes and
depending on the algorithm may start behaving like a FIFO to new
requests. i.e. each new request coming in needs to wait for one to
drain. At that point, the write rate will tank to maybe 50 IOPS,
which will barely register on the benchmark throughput. (just look
at what happens to the IO latency that is measured...)

IOWs, welcome to Understanding RAID Controller Caching Behaviours
101 :)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
