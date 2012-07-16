Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6GLwB67019297 for <xfs@oss.sgi.com>; Mon, 16 Jul 2012 16:58:11 -0500
Received: from mail-yw0-f53.google.com (mail-yw0-f53.google.com
	[209.85.213.53]) by cuda.sgi.com with ESMTP id PBzRKok2RkPCC42P
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 16 Jul 2012 14:58:09 -0700 (PDT)
Received: by yhp26 with SMTP id 26so7161460yhp.26
	for <xfs@oss.sgi.com>; Mon, 16 Jul 2012 14:58:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5004875D.1020305@hardwarefreak.com>
References: <CAAxjCEzh3+doupD=LmgqSbCeYWzn9Ru-vE4T8tOJmoud+28FDQ@mail.gmail.com>
	<CAAxjCEzEiXv5Kna9zxZ-ePbhNg6nfRinkU=PCuyX3QHesq5qcg@mail.gmail.com>
	<5004875D.1020305@hardwarefreak.com>
Date: Mon, 16 Jul 2012 23:58:09 +0200
Message-ID: <CAAxjCEw-NJzZmX3Q5CJ+aZ_Q7Yo39pMU=-hiXk0ghTMq7q3PWA@mail.gmail.com>
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

> These writes appear to all be larger than the BBWC, according to the
> response times.  It's odd that the data written is 0.00MB/s, meaning
> nothing was actually written.  How does writing nothing takes over 1 second?

The writes are 4KB all the time, but at this point the FBWC has been
filled up. I guess it's not "nothing", but close to it, and the MB/s
figure is rounded. If it takes > 1 sec for a single write to get
through, not much gets written in a 2 second interval.

> Either there is something wrong with your test, critical data omitted
> from these reports, it isn't reporting coherent data, or I'm simply not
> "trained" to read this output.  The output doesn't make any sense.

I'm pretty sure that the data is correct, and the test is not flawed.
The only relevant omission is that I've run the test a few times in a
row. That should explain the first "0.07MB/s" line, because the cache
was already loaded. The output does make sense, it's just the
controller that's behaving erratically. It seems to accept data into
the cache up to a point, then it starts writing it out to disk and not
doing much else during that time.

>> [  30s] reads: 0.00 MB/s writes: 5.27 MB/s fsyncs: 0.00/s response
>> time: 0.254ms (95%)
>> Operations performed:  0 reads, 42890 writes, 0 Other = 42890 Total
>> Read 0b  Written 167.54Mb  Total transferred 167.54Mb  (5.5773Mb/sec)
>>  1427.80 Requests/sec executed
>
> Again, the response times suggest all these writes are being
> acknowledged by BBWC.  Given this is a PCIe RAID HBA, the throughput
> numbers to BBWC should be hundreds of megs per second.

It's semi-random, quite small writes -- actually not very random, but
still not exactly linear --, so some performance degradation is
expected.

>> [  28s] reads: 0.00 MB/s writes: 36.15 MB/s fsyncs: 0.00/s response
>> time: 0.232ms (95%)
>> Operations performed:  0 reads, 284087 writes, 0 Other = 284087 Total
>> Read 0b  Written 1.0837Gb  Total transferred 1.0837Gb  (36.99Mb/sec)
>>  9469.55 Requests/sec executed
>
> Again, due to the response times, all the writes appear acknowledged by
> BBWC.  While the LSI throughput is better, it is still far far lower
> than what it should be, i.e. hundreds of megs per second to BBWC.

The cache gets filled up quickly in this case, so it can only accept
as much data as it manages to write out to the disks.

> I'm not familiar with sysbench.  That said, your command line seems to
> be specifying 8GB files.  Your original issue reported here long ago was
> low performance with huge metadata, i.e. deleting kernel trees etc.
> What storage characteristics is the command above supposed to test?

You're right. When I had the issue with a metadata-intensive workload
-- it was mostly free space fragmentation that caused trouble,
apparently --, I ran seekwatcher and noticed a pattern that I tried to
illustrate in <http://oss.sgi.com/pipermail/xfs/2012-April/018231.html>.
The SmartArray controller was not able to make sense of this pattern,
although in theory, it would be very easy to optimize. I was familiar
with sysbench, which offers a handy random write test of with
selectable block size, and I modified it so it would write out the
blocks in the order suggested by the pattern.

> I'd like a pony.  If anyone here were to give me a pony that would
> satisfy one desire of one person.  Ergo, if others performing your test
> will have a positive impact on the XFS code and user base, and not
> simply serve to satisfy the curiosity of one user, I'm sure others would
> be glad to run such tests.  At this point though it seems such testing
> would only satisfy the former, and not the latter.

Maybe so, but it might also be worthwhile to point out flaws with
current real hardware, when it does not behave the way one would
expect.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
