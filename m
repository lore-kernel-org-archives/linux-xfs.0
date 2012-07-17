Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6H1dFoJ033918 for <xfs@oss.sgi.com>; Mon, 16 Jul 2012 20:39:15 -0500
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id NaCoBaPSXxNaBF4w
	for <xfs@oss.sgi.com>; Mon, 16 Jul 2012 18:39:14 -0700 (PDT)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id 980EB6C08F
	for <xfs@oss.sgi.com>; Mon, 16 Jul 2012 20:39:14 -0500 (CDT)
Message-ID: <5004C243.6040404@hardwarefreak.com>
Date: Mon, 16 Jul 2012 20:39:15 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: A little RAID experiment
References: <CAAxjCEzh3+doupD=LmgqSbCeYWzn9Ru-vE4T8tOJmoud+28FDQ@mail.gmail.com>
	<CAAxjCEzEiXv5Kna9zxZ-ePbhNg6nfRinkU=PCuyX3QHesq5qcg@mail.gmail.com>
	<5004875D.1020305@hardwarefreak.com>
	<CAAxjCEw-NJzZmX3Q5CJ+aZ_Q7Yo39pMU=-hiXk0ghTMq7q3PWA@mail.gmail.com>
In-Reply-To: <CAAxjCEw-NJzZmX3Q5CJ+aZ_Q7Yo39pMU=-hiXk0ghTMq7q3PWA@mail.gmail.com>
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

On 7/16/2012 4:58 PM, Stefan Ring wrote:

> I'm pretty sure that the data is correct, and the test is not flawed.

That may be true.  Nonetheless, what you presented does not paint a
coherent picture.

> The only relevant omission is that I've run the test a few times in a
> row. 

You also omitted whether you had exclusive access to the P2000 array.
The P2000 has 2GB write cache.  The numbers you report are far below
what this unit is capable of.  Your data suggests

1.  You didn't have exclusive access during testing
2.  A configuration issue

>> Again, the response times suggest all these writes are being
>> acknowledged by BBWC.  Given this is a PCIe RAID HBA, the throughput
>> numbers to BBWC should be hundreds of megs per second.
> 
> It's semi-random, quite small writes -- actually not very random, but
> still not exactly linear --, so some performance degradation is
> expected.

The data set I commented on here shows all responses were from BBWC.
How can you "expect" degradation from cache?

>> Again, due to the response times, all the writes appear acknowledged by
>> BBWC.  While the LSI throughput is better, it is still far far lower
>> than what it should be, i.e. hundreds of megs per second to BBWC.
> 
> The cache gets filled up quickly in this case, so it can only accept
> as much data as it manages to write out to the disks.

This is not what the data I quoted shows Stefan.  The data shows all the
writes were acked by cache, according to response times.

> Maybe so, but it might also be worthwhile to point out flaws with
> current real hardware, when it does not behave the way one would
> expect.

The only "flaw" you've identified, long ago, is that low end HP hardware
based RAID5/6 is not suitable for metadata heavy workloads.  Everyone
here told you RAID5/6, whether hardware or software, was not a good
candidate for such workloads.  You played with RAID10 and a concat
setup, and received greatly enhanced performance.

It depends on the one, and what the one expects.  Most people on this
list would never expect parity RAID to perform well with the workloads
you're throwing at it.  Your expectations are clearly different than
most on this list.

The kicker here is that most of the data you presented shows almost all
writes being acked by cache, in which case RAID level should be
irrelevant, but at the same time showing abysmal throughput.  When all
write hit cache, throughput should be through the roof.

So again, something is amiss here.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
