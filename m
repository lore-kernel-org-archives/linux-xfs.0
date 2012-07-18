Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6IAO6sO181551 for <xfs@oss.sgi.com>; Wed, 18 Jul 2012 05:24:06 -0500
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id 6CL8LYzEfOMqFn58
	for <xfs@oss.sgi.com>; Wed, 18 Jul 2012 03:24:05 -0700 (PDT)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id C630C6C0A1
	for <xfs@oss.sgi.com>; Wed, 18 Jul 2012 05:24:04 -0500 (CDT)
Message-ID: <50068EC5.5020704@hardwarefreak.com>
Date: Wed, 18 Jul 2012 05:24:05 -0500
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
In-Reply-To: <CAAxjCExFUJOKaD-LMPfZvCrS34V1VHgtrhgvPP0jZ3Hm1YV=6g@mail.gmail.com>
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

On 7/18/2012 2:22 AM, Stefan Ring wrote:

> Because it was XFS originally which hammered the controller with this
> disadvantageous pattern. 

Do you feel you have researched and tested this theory thoroughly enough
to draw such a conclusion?  Note the LSI numbers with a single thread
compared to the P400.  It seems at this point the LSI has no problem
with the pattern.  How about threaded results?

> Except for the concurrency, it doesn't matter
> much on which filesystem sysbench operates. I've previously verified
> this on another system.

It's hard to believe a 4 generation old (6-7 years) LSI ASIC with
256/512MB cache is able to sink this workload without ever stalling when
flushing to rust, where the HP P2000 FC SAN array shows pretty sad
performance.  I'd really like to see the threaded results for the LSI at
this point.  I think that would be informative.

> It was the Fibre Channel controller, the one with the collapsing
> throughput. (P2000 G3 MSA, QLogic Corp. ISP2532-based 8Gb Fibre
> Channel to PCI Express HBA)

Given the LSI 1078 based RAID card with 1 thread runs circles around the
P2000 with 4, 8, or 16 threads, and never stalls, with responses less
than 1ms, meaning all writes hit cache, it would seem other workloads
are hitting the P2000 simultaneously with your test, limiting your
performance.  Either that or some kind of quotas have been set on the
LUNs to prevent one host from saturating the controllers.  Or both.

This is why I asked about exclusive access.  Without it your results for
the P2000 are literally worthless.  Lacking complete configuration info
puts you in the same boat.  You simply can't draw any realistic
conclusions about the P2000 performance without having complete control
of the device for dedicated testing purposes.

You have such control of the P400 and LSI do you not?  Concentrate your
testing and comparisons on those.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
