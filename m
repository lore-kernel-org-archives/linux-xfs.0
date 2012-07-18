Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6I2IJMq134737 for <xfs@oss.sgi.com>; Tue, 17 Jul 2012 21:18:19 -0500
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id 0hRUZ19I4NwbiJwL
	for <xfs@oss.sgi.com>; Tue, 17 Jul 2012 19:18:18 -0700 (PDT)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id B75AD6C1AF
	for <xfs@oss.sgi.com>; Tue, 17 Jul 2012 21:18:17 -0500 (CDT)
Message-ID: <50061CEA.4070609@hardwarefreak.com>
Date: Tue, 17 Jul 2012 21:18:18 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: A little RAID experiment
References: <CAAxjCEzh3+doupD=LmgqSbCeYWzn9Ru-vE4T8tOJmoud+28FDQ@mail.gmail.com>
	<CAAxjCEzEiXv5Kna9zxZ-ePbhNg6nfRinkU=PCuyX3QHesq5qcg@mail.gmail.com>
	<5004875D.1020305@hardwarefreak.com>
	<CAAxjCEw-NJzZmX3Q5CJ+aZ_Q7Yo39pMU=-hiXk0ghTMq7q3PWA@mail.gmail.com>
	<5004C243.6040404@hardwarefreak.com>
	<20120717052621.GB23387@dastard>
In-Reply-To: <20120717052621.GB23387@dastard>
Reply-To: stan@hardwarefreak.com
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
To: xfs@oss.sgi.com

On 7/17/2012 12:26 AM, Dave Chinner wrote:
...
> I bet it's single threaded, which means it is:

The data given seems to strongly suggest a single thread.

> Which means throughput is limited by IO latency, not bandwidth.
> If it takes 10us to do the write(2), issue and process the IO
> completion, and it takes 10us for the hardware to do the IO, you're
> limited to 50,000 IOPS, or 200MB/s. Given that the best being seen
> is around 35MB/s, you're looking at around 10,000 IOPS of 100us
> round trip time. At 5MB/s, it's 1200 IOPS or around 800us round
> trip.
> 
> That's why you get different performance from the different raid
> controllers - some process cache hits a lot faster than others.
...
> IOWs, welcome to Understanding RAID Controller Caching Behaviours
> 101 :)

It would be somewhat interesting to see Stefan's latency and throughput
numbers for 4/8/16 threads.  Maybe the sysbench "--num-threads=" option
is the ticket.  The docs state this is for testing scheduler
performance, and it's not clear whether this actually does threaded IO.
 If not, time for a new IO benchmark.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
