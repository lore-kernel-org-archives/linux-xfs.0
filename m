Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6I6i31f166527 for <xfs@oss.sgi.com>; Wed, 18 Jul 2012 01:44:03 -0500
Received: from mail-ob0-f181.google.com (mail-ob0-f181.google.com
	[209.85.214.181]) by cuda.sgi.com with ESMTP id
	mkt7pFygaCGWy7CO (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 17 Jul 2012 23:44:02 -0700 (PDT)
Received: by obbup19 with SMTP id up19so1875191obb.26
	for <xfs@oss.sgi.com>; Tue, 17 Jul 2012 23:44:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <50061CEA.4070609@hardwarefreak.com>
References: <CAAxjCEzh3+doupD=LmgqSbCeYWzn9Ru-vE4T8tOJmoud+28FDQ@mail.gmail.com>
	<CAAxjCEzEiXv5Kna9zxZ-ePbhNg6nfRinkU=PCuyX3QHesq5qcg@mail.gmail.com>
	<5004875D.1020305@hardwarefreak.com>
	<CAAxjCEw-NJzZmX3Q5CJ+aZ_Q7Yo39pMU=-hiXk0ghTMq7q3PWA@mail.gmail.com>
	<5004C243.6040404@hardwarefreak.com>
	<20120717052621.GB23387@dastard>
	<50061CEA.4070609@hardwarefreak.com>
Date: Wed, 18 Jul 2012 08:44:01 +0200
Message-ID: <CAAxjCEwgDKLF=RY0aCCNTMsc1oefXWfyHKh+morYB9zVUrnH-A@mail.gmail.com>
Subject: Re: A little RAID experiment
From: Stefan Ring <stefanrin@gmail.com>
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
To: stan@hardwarefreak.com
Cc: xfs@oss.sgi.com

On Wed, Jul 18, 2012 at 4:18 AM, Stan Hoeppner <stan@hardwarefreak.com> wrote:
> On 7/17/2012 12:26 AM, Dave Chinner wrote:
> ...
>> I bet it's single threaded, which means it is:
>
> The data given seems to strongly suggest a single thread.
>
>> Which means throughput is limited by IO latency, not bandwidth.
>> If it takes 10us to do the write(2), issue and process the IO
>> completion, and it takes 10us for the hardware to do the IO, you're
>> limited to 50,000 IOPS, or 200MB/s. Given that the best being seen
>> is around 35MB/s, you're looking at around 10,000 IOPS of 100us
>> round trip time. At 5MB/s, it's 1200 IOPS or around 800us round
>> trip.
>>
>> That's why you get different performance from the different raid
>> controllers - some process cache hits a lot faster than others.
> ...
>> IOWs, welcome to Understanding RAID Controller Caching Behaviours
>> 101 :)
>
> It would be somewhat interesting to see Stefan's latency and throughput
> numbers for 4/8/16 threads.  Maybe the sysbench "--num-threads=" option
> is the ticket.  The docs state this is for testing scheduler
> performance, and it's not clear whether this actually does threaded IO.
>  If not, time for a new IO benchmark.

Yes, it is intentionally single-threaded and round-trip-bound, as that
is exactly the kind of behavior that XFS chose to display.

I tested with more threads now. It is initially faster, which only
serves to hasten the tanking, and the response time goes through the
roof. I also needed to increase the --file-num. Apparently the
filesystem (ext3) in this case cannot handle concurrent accesses to
the same file.

4 threads:

[   2s] reads: 0.00 MB/s writes: 23.55 MB/s fsyncs: 0.00/s response
time: 1.171ms (95%)
[   4s] reads: 0.00 MB/s writes: 24.35 MB/s fsyncs: 0.00/s response
time: 1.129ms (95%)
[   6s] reads: 0.00 MB/s writes: 24.55 MB/s fsyncs: 0.00/s response
time: 1.141ms (95%)
[   8s] reads: 0.00 MB/s writes: 25.73 MB/s fsyncs: 0.00/s response
time: 1.088ms (95%)
[  10s] reads: 0.00 MB/s writes: 6.14 MB/s fsyncs: 0.00/s response
time: 0.994ms (95%)
[  12s] reads: 0.00 MB/s writes: 0.01 MB/s fsyncs: 0.00/s response
time: 2735.611ms (95%)
[  14s] reads: 0.00 MB/s writes: 0.01 MB/s fsyncs: 0.00/s response
time: 3800.107ms (95%)
[  16s] reads: 0.00 MB/s writes: 0.01 MB/s fsyncs: 0.00/s response
time: 4404.397ms (95%)
[  18s] reads: 0.00 MB/s writes: 0.00 MB/s fsyncs: 0.00/s response
time: 3153.588ms (95%)
[  20s] reads: 0.00 MB/s writes: 0.01 MB/s fsyncs: 0.00/s response
time: 4769.433ms (95%)


8 threads:

[   2s] reads: 0.00 MB/s writes: 26.99 MB/s fsyncs: 0.00/s response
time: 2.451ms (95%)
[   4s] reads: 0.00 MB/s writes: 28.12 MB/s fsyncs: 0.00/s response
time: 3.153ms (95%)
[   6s] reads: 0.00 MB/s writes: 25.97 MB/s fsyncs: 0.00/s response
time: 2.965ms (95%)
[   8s] reads: 0.00 MB/s writes: 23.23 MB/s fsyncs: 0.00/s response
time: 2.560ms (95%)
[  10s] reads: 0.00 MB/s writes: 0.00 MB/s fsyncs: 0.00/s response
time: 791.041ms (95%)
[  12s] reads: 0.00 MB/s writes: 0.01 MB/s fsyncs: 0.00/s response
time: 3458.162ms (95%)
[  14s] reads: 0.00 MB/s writes: 0.01 MB/s fsyncs: 0.00/s response
time: 5519.598ms (95%)
[  16s] reads: 0.00 MB/s writes: 0.01 MB/s fsyncs: 0.00/s response
time: 3219.401ms (95%)
[  18s] reads: 0.00 MB/s writes: 0.01 MB/s fsyncs: 0.00/s response
time: 10235.289ms (95%)
[  20s] reads: 0.00 MB/s writes: 0.01 MB/s fsyncs: 0.00/s response
time: 3765.007ms (95%)

16 threads:

[   2s] reads: 0.00 MB/s writes: 34.27 MB/s fsyncs: 0.00/s response
time: 3.899ms (95%)
[   4s] reads: 0.00 MB/s writes: 28.62 MB/s fsyncs: 0.00/s response
time: 6.910ms (95%)
[   6s] reads: 0.00 MB/s writes: 27.94 MB/s fsyncs: 0.00/s response
time: 6.869ms (95%)
[   8s] reads: 0.00 MB/s writes: 13.50 MB/s fsyncs: 0.00/s response
time: 7.594ms (95%)
[  10s] reads: 0.00 MB/s writes: 0.01 MB/s fsyncs: 0.00/s response
time: 2308.573ms (95%)
[  12s] reads: 0.00 MB/s writes: 0.01 MB/s fsyncs: 0.00/s response
time: 4811.016ms (95%)
[  14s] reads: 0.00 MB/s writes: 0.00 MB/s fsyncs: 0.00/s response
time: 4635.714ms (95%)
[  16s] reads: 0.00 MB/s writes: 0.01 MB/s fsyncs: 0.00/s response
time: 3200.185ms (95%)
[  18s] reads: 0.00 MB/s writes: 0.03 MB/s fsyncs: 0.00/s response
time: 9623.207ms (95%)
[  20s] reads: 0.00 MB/s writes: 0.01 MB/s fsyncs: 0.00/s response
time: 8053.211ms (95%)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
