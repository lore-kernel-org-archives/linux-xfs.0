Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6JF7RP6022067 for <xfs@oss.sgi.com>; Thu, 19 Jul 2012 10:07:27 -0500
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id 70bLxWfrcpZ9DDsj
	for <xfs@oss.sgi.com>; Wed, 18 Jul 2012 20:08:36 -0700 (PDT)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id DB9F56C0AD
	for <xfs@oss.sgi.com>; Wed, 18 Jul 2012 22:08:35 -0500 (CDT)
Message-ID: <50077A34.5070304@hardwarefreak.com>
Date: Wed, 18 Jul 2012 22:08:36 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: A little RAID experiment
References: <CAAxjCEzh3+doupD=LmgqSbCeYWzn9Ru-vE4T8tOJmoud+28FDQ@mail.gmail.com>
	<CAAxjCEzEiXv5Kna9zxZ-ePbhNg6nfRinkU=PCuyX3QHesq5qcg@mail.gmail.com>
	<5004875D.1020305@hardwarefreak.com>
	<CAAxjCEw-NJzZmX3Q5CJ+aZ_Q7Yo39pMU=-hiXk0ghTMq7q3PWA@mail.gmail.com>
	<5004C243.6040404@hardwarefreak.com>
	<20120717052621.GB23387@dastard>
	<50061CEA.4070609@hardwarefreak.com>
	<CAAxjCEwgDKLF=RY0aCCNTMsc1oefXWfyHKh+morYB9zVUrnH-A@mail.gmail.com>
	<50066115.7070807@hardwarefreak.com>
	<CAAxjCExFUJOKaD-LMPfZvCrS34V1VHgtrhgvPP0jZ3Hm1YV=6g@mail.gmail.com>
	<50068EC5.5020704@hardwarefreak.com>
	<CAAxjCEy2Yj=XWctNg2gACbFy81aTu70YJ13Ee8G6-E3Tqvvs7g@mail.gmail.com>
	<CAAxjCEzF3nTFoedyKf1o5Nv4yPUJkgvC8nCJcx_2dDx8xqWtWA@mail.gmail.com>
In-Reply-To: <CAAxjCEzF3nTFoedyKf1o5Nv4yPUJkgvC8nCJcx_2dDx8xqWtWA@mail.gmail.com>
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

Sorry for any potential dups.  Mail log shows this msg was accepted 3.5
hours ago but it hasn't spit back to me yet and no bounce.  Resending.

On 7/18/2012 7:37 AM, Stefan Ring wrote:
>> At least I have some multi-threaded results from the other two machines:
>>
>> LSI:
>>
>> 4 threads
>>
>> [   2s] reads: 0.00 MB/s writes: 63.08 MB/s fsyncs: 0.00/s response
>> time: 0.452ms (95%)
>> [   4s] reads: 0.00 MB/s writes: 34.26 MB/s fsyncs: 0.00/s response
>> time: 1.660ms (95%)
> 
> And because of the bad formatting:
> https://github.com/Ringdingcoder/sysbench/blob/master/mail2.txt

And this is why people publishing real, useable benchmark results
publish all specs of the hardware/software environment being tested.  I
think I've mentioned once or twice how critical accurate/complete
information is.

Looking at the table linked above, two things become clear:

1.  The array spindle config of the 3 systems is wildly different.

   a.  P400  = 6x  10K  SAS  RAID6
   b.  P2000 = 12x 7.2k SATA RAID6
   c.  LSI   = unknown

2.  The LSI outperforms the other two by a wide margin, yet we know
nothing of the disks attached.  At first blush, ans assuming disk config
is similar to the other two systems, the controller firmware *appears*
to perform magic.  But without knowing the spindle config of the LSI we
simply can't draw any conclusions yet.

This benchmark test seems to involve no or little metadata IO, so few
RMW cycles, and RAID6 doesn't kill us.  So if the LSI has the common 24
bay 2.5" JBOD shelf attached, with 2 spares and 22x 15K SAS drives (20
stripe spindles) in RAID6, this alone may fully explain the performance
gap, due to 6.7x the seek performance against the 6x 10k drives (4
spindles) in RAID6 on the P400.  This would also equal 4x the seek
performance of the 12 disks (10 spindles) of the P2000.

Given the results for the P2000, it seems clear that the LUN you're
hitting is not striped across 10 spindles.  It would seem that the 12
drives have been split up into two or more RAID arrays, probably 2x 6
drive RAID6s, and your test LUN sits on one of them, yielding 4x 7.2k
stripe spindles.  If it spanned 10 of 12 drives in a RAID6, it shouldn't
stall as shown in your data.  The "tell" here is that the P2000 with 10
7.2k drives has 1.7x the seek performance of the 4 spindles in your
P400, which outruns the P2000 once cache is full.  The P2000 controller
has over 4x the write cache of the P400, which is clearly demonstrated
in your data:

>From 2s to 8s, the P2000 averages ~25MB/s throughput with sub 10ms
latency.  At 10s and up, latency jumps to multiple *seconds* and
throughput drops to "zero".  This clearly shows that when cache is full
and must flush, the drives are simply overwhelmed.  10x 7.2k striped
SATA spindles would not perform this badly.  Thus it seems clear your
LUN sits on only 4 of the 12 spindles.

The cached performance of the P2000 is about 50% of the LSI, and the LSI
has 4x less cache memory.  This could be due to cache mirroring between
the two controllers eating 50% of the cache RAM bandwidth.

So in summary, it would be nice to know the disk config of the LSI.
Once we have complete hardware information, it may likely turn out that
the bulk of the performance differences simply come down to what disks
are attached to each controller.  BTW, you provided lspci output of the
chip on the RAID card.  Please provide the actual model# of the LSI
card.  Dozens of LSI and OEM cards on the market have used the SAS1078
ASIC.  The card you have may not even be an LSI card, or may even be
embedded.  We can't tell from the info given.

The devil is always in the details Stefan. ;)

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
