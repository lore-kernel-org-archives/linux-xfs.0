Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6ICWbvK189334 for <xfs@oss.sgi.com>; Wed, 18 Jul 2012 07:32:37 -0500
Received: from mail-ob0-f181.google.com (mail-ob0-f181.google.com
	[209.85.214.181]) by cuda.sgi.com with ESMTP id
	CtEMBhh80rTp0LXN (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 18 Jul 2012 05:32:35 -0700 (PDT)
Received: by obbup19 with SMTP id up19so2273129obb.26
	for <xfs@oss.sgi.com>; Wed, 18 Jul 2012 05:32:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <50068EC5.5020704@hardwarefreak.com>
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
Date: Wed, 18 Jul 2012 14:32:35 +0200
Message-ID: <CAAxjCEy2Yj=XWctNg2gACbFy81aTu70YJ13Ee8G6-E3Tqvvs7g@mail.gmail.com>
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

> Given the LSI 1078 based RAID card with 1 thread runs circles around the
> P2000 with 4, 8, or 16 threads, and never stalls, with responses less
> than 1ms, meaning all writes hit cache, it would seem other workloads
> are hitting the P2000 simultaneously with your test, limiting your
> performance.  Either that or some kind of quotas have been set on the
> LUNs to prevent one host from saturating the controllers.  Or both.

Maybe there exists a load quota of some kind as you are suggesting,
but from what I've seen from screenshots in the installation manuals,
I don't remember any of this.

> This is why I asked about exclusive access.  Without it your results for
> the P2000 are literally worthless.  Lacking complete configuration info
> puts you in the same boat.  You simply can't draw any realistic
> conclusions about the P2000 performance without having complete control
> of the device for dedicated testing purposes.

That's a reasonable suggestion. Alas, I'm not expecting to get that
level of access to the device. I know for a fact though, that it is
only connected to a single machine, which is otherwise completely idle
and controlled by "us" (the company I work for). But even so, I cannot
set up XFS there on a whim because it's in preparation for production
use.

> You have such control of the P400 and LSI do you not?  Concentrate your
> testing and comparisons on those.

The period of full control over the P400 is over, but at least I know
how it is configured. The LSI is in production (meaning: untouchable),
but seems reasonably configured.

At least I have some multi-threaded results from the other two machines:

LSI:

4 threads

[   2s] reads: 0.00 MB/s writes: 63.08 MB/s fsyncs: 0.00/s response
time: 0.452ms (95%)
[   4s] reads: 0.00 MB/s writes: 34.26 MB/s fsyncs: 0.00/s response
time: 1.660ms (95%)
[   6s] reads: 0.00 MB/s writes: 33.92 MB/s fsyncs: 0.00/s response
time: 1.478ms (95%)
[   8s] reads: 0.00 MB/s writes: 36.34 MB/s fsyncs: 0.00/s response
time: 1.589ms (95%)
[  10s] reads: 0.00 MB/s writes: 34.99 MB/s fsyncs: 0.00/s response
time: 1.621ms (95%)
[  12s] reads: 0.00 MB/s writes: 36.41 MB/s fsyncs: 0.00/s response
time: 1.639ms (95%)

8 threads

[   2s] reads: 0.00 MB/s writes: 45.34 MB/s fsyncs: 0.00/s response
time: 2.749ms (95%)
[   4s] reads: 0.00 MB/s writes: 32.15 MB/s fsyncs: 0.00/s response
time: 4.579ms (95%)
[   6s] reads: 0.00 MB/s writes: 33.64 MB/s fsyncs: 0.00/s response
time: 4.644ms (95%)
[   8s] reads: 0.00 MB/s writes: 35.20 MB/s fsyncs: 0.00/s response
time: 4.131ms (95%)
[  10s] reads: 0.00 MB/s writes: 33.88 MB/s fsyncs: 0.00/s response
time: 3.876ms (95%)
[  12s] reads: 0.00 MB/s writes: 33.65 MB/s fsyncs: 0.00/s response
time: 4.929ms (95%)

16 threads

[   2s] reads: 0.00 MB/s writes: 36.90 MB/s fsyncs: 0.00/s response
time: 3.510ms (95%)
[   4s] reads: 0.00 MB/s writes: 35.36 MB/s fsyncs: 0.00/s response
time: 8.629ms (95%)
[   6s] reads: 0.00 MB/s writes: 32.27 MB/s fsyncs: 0.00/s response
time: 10.091ms (95%)
[   8s] reads: 0.00 MB/s writes: 34.79 MB/s fsyncs: 0.00/s response
time: 9.499ms (95%)
[  10s] reads: 0.00 MB/s writes: 35.62 MB/s fsyncs: 0.00/s response
time: 8.801ms (95%)
[  12s] reads: 0.00 MB/s writes: 34.64 MB/s fsyncs: 0.00/s response
time: 9.488ms (95%)

... and so on. Nothing noteworthy after that.

Response time is higher, throughput stays the same.

P400:

4 threads

[   2s] reads: 0.00 MB/s writes: 33.59 MB/s fsyncs: 0.00/s response
time: 0.255ms (95%)
[   4s] reads: 0.00 MB/s writes: 5.11 MB/s fsyncs: 0.00/s response
time: 12.853ms (95%)
[   6s] reads: 0.00 MB/s writes: 5.45 MB/s fsyncs: 0.00/s response
time: 0.677ms (95%)
[   8s] reads: 0.00 MB/s writes: 5.16 MB/s fsyncs: 0.00/s response
time: 0.902ms (95%)
[  10s] reads: 0.00 MB/s writes: 4.56 MB/s fsyncs: 0.00/s response
time: 58.242ms (95%)
[  12s] reads: 0.00 MB/s writes: 5.30 MB/s fsyncs: 0.00/s response
time: 0.669ms (95%)
[  14s] reads: 0.00 MB/s writes: 5.22 MB/s fsyncs: 0.00/s response
time: 0.743ms (95%)
[  16s] reads: 0.00 MB/s writes: 4.73 MB/s fsyncs: 0.00/s response
time: 57.877ms (95%)
[  18s] reads: 0.00 MB/s writes: 4.39 MB/s fsyncs: 0.00/s response
time: 58.417ms (95%)
[  20s] reads: 0.00 MB/s writes: 4.56 MB/s fsyncs: 0.00/s response
time: 57.704ms (95%)
[  22s] reads: 0.00 MB/s writes: 4.81 MB/s fsyncs: 0.00/s response
time: 57.429ms (95%)
[  24s] reads: 0.00 MB/s writes: 4.53 MB/s fsyncs: 0.00/s response
time: 57.895ms (95%)

Some response time fluctuation at first, but it settles quickly.

8 threads

[   2s] reads: 0.00 MB/s writes: 38.61 MB/s fsyncs: 0.00/s response
time: 0.969ms (95%)
[   4s] reads: 0.00 MB/s writes: 4.98 MB/s fsyncs: 0.00/s response
time: 59.886ms (95%)
[   6s] reads: 0.00 MB/s writes: 4.69 MB/s fsyncs: 0.00/s response
time: 60.300ms (95%)
[   8s] reads: 0.00 MB/s writes: 4.57 MB/s fsyncs: 0.00/s response
time: 60.246ms (95%)
[  10s] reads: 0.00 MB/s writes: 4.46 MB/s fsyncs: 0.00/s response
time: 60.626ms (95%)
[  12s] reads: 0.00 MB/s writes: 4.46 MB/s fsyncs: 0.00/s response
time: 60.445ms (95%)
[  14s] reads: 0.00 MB/s writes: 4.61 MB/s fsyncs: 0.00/s response
time: 60.662ms (95%)
[  16s] reads: 0.00 MB/s writes: 4.35 MB/s fsyncs: 0.00/s response
time: 60.571ms (95%)
[  18s] reads: 0.00 MB/s writes: 4.87 MB/s fsyncs: 0.00/s response
time: 60.156ms (95%)
[  20s] reads: 0.00 MB/s writes: 4.77 MB/s fsyncs: 0.00/s response
time: 60.210ms (95%)
[  22s] reads: 0.00 MB/s writes: 4.58 MB/s fsyncs: 0.00/s response
time: 60.463ms (95%)
[  24s] reads: 0.00 MB/s writes: 4.65 MB/s fsyncs: 0.00/s response
time: 60.264ms (95%)

16 threads

[   2s] reads: 0.00 MB/s writes: 17.35 MB/s fsyncs: 0.00/s response
time: 7.764ms (95%)
[   4s] reads: 0.00 MB/s writes: 5.17 MB/s fsyncs: 0.00/s response
time: 62.655ms (95%)
[   6s] reads: 0.00 MB/s writes: 5.15 MB/s fsyncs: 0.00/s response
time: 62.749ms (95%)
[   8s] reads: 0.00 MB/s writes: 4.89 MB/s fsyncs: 0.00/s response
time: 63.258ms (95%)
[  10s] reads: 0.00 MB/s writes: 4.98 MB/s fsyncs: 0.00/s response
time: 62.862ms (95%)
[  12s] reads: 0.00 MB/s writes: 5.26 MB/s fsyncs: 0.00/s response
time: 63.032ms (95%)
[  14s] reads: 0.00 MB/s writes: 5.27 MB/s fsyncs: 0.00/s response
time: 62.599ms (95%)
[  16s] reads: 0.00 MB/s writes: 4.80 MB/s fsyncs: 0.00/s response
time: 63.088ms (95%)
[  18s] reads: 0.00 MB/s writes: 4.84 MB/s fsyncs: 0.00/s response
time: 63.239ms (95%)
[  20s] reads: 0.00 MB/s writes: 5.24 MB/s fsyncs: 0.00/s response
time: 62.712ms (95%)
[  22s] reads: 0.00 MB/s writes: 4.25 MB/s fsyncs: 0.00/s response
time: 63.619ms (95%)
[  24s] reads: 0.00 MB/s writes: 4.90 MB/s fsyncs: 0.00/s response
time: 63.202ms (95%)

Pretty boring.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
