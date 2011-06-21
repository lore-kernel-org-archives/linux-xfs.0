Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5L4PILL223076 for <xfs@oss.sgi.com>; Mon, 20 Jun 2011 23:25:19 -0500
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2B468134B6FD
	for <xfs@oss.sgi.com>; Mon, 20 Jun 2011 21:25:16 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	s7DTCn9XJ68HVmCF for <xfs@oss.sgi.com>;
	Mon, 20 Jun 2011 21:25:16 -0700 (PDT)
Date: Tue, 21 Jun 2011 14:25:13 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: long hangs when deleting large directories (3.0-rc3)
Message-ID: <20110621042513.GN32466@dastard>
References: <20110618141950.GA1685@x4.trippels.de>
	<20110619222447.GI561@dastard>
	<20110620005415.GA1730@x4.trippels.de>
	<20110620013449.GO561@dastard>
	<20110620020236.GB1730@x4.trippels.de>
	<20110620023625.GP561@dastard>
	<20110620060351.GC1730@x4.trippels.de>
	<20110620111359.GA12632@x4.trippels.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110620111359.GA12632@x4.trippels.de>
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
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: xfs@oss.sgi.com

On Mon, Jun 20, 2011 at 01:13:59PM +0200, Markus Trippelsdorf wrote:
> On 2011.06.20 at 08:03 +0200, Markus Trippelsdorf wrote:
> > OK. I was able to reproduce the same hang on a conventional 512 sector drive.
> > The partition that I've used was the predecessor to the one on the 4k drive. So
> > it saw roughly the same usage pattern.
> > This is the output of "dstat -cdyl -C 0,1,2,3 -D sdc --disk-tps" during the
> > hang:
> > 
> > -------cpu0-usage--------------cpu1-usage--------------cpu2-usage--------------cpu3-usage------ --dsk/sdc-- ---system-- ---load-avg--- --dsk/sdc--
> > usr sys idl wai hiq siq:usr sys idl wai hiq siq:usr sys idl wai hiq siq:usr sys idl wai hiq siq| read  writ| int   csw | 1m   5m  15m |reads writs
> > 
> >   0   0 100   0   0   0:  1   0  99   0   0   0:  0   1  99   0   0   0:  1   0  99   0   0   0|   0     0 | 249   354 |0.33 0.58 0.38|   0     0 
> >   0   0 100   0   0   0:  0   0 100   0   0   0:  0   0 100   0   0   0:  0   0 100   0   0   0|   0     0 | 244   228 |0.33 0.58 0.38|   0     0 
> >   1   2  97   0   0   0:  0   1  99   0   0   0:  0   1  99   0   0   0:  0   1  99   0   0   0|   0     0 | 559   614 |0.33 0.58 0.38|   0     0 
> >   0   0 100   0   0   0:  1   0  99   0   0   0:  1   0  99   0   0   0:  1   0  99   0   0   0|   0     0 | 341   426 |0.33 0.58 0.38|   0     0 
> >   1   0  99   0   0   0:  1   4  95   0   0   0:  0   1  99   0   0   0:  1  16  83   0   0   0|   0     0 | 874   796 |0.33 0.58 0.38|   0     0 
> >   2  50  49   0   0   0:  1   9  90   0   0   0:  1   9  90   0   0   0:  1  23  76   0   0   0|   0  6400k|2803  2073 |0.46 0.60 0.39|   0    25 
> >   1  29  70   0   0   0:  1   1  98   0   0   0:  1   9  90   0   0   0:  1  53  46   0   0   0|   0  6400k|2047  1414 |0.46 0.60 0.39|   0    25 
> >   0   4  96   0   0   0:  0   0 100   0   0   0:  1  19  80   0   0   0:  0  80  20   0   0   0|   0  2048k|1425   685 |0.46 0.60 0.39|   0     8 
> >   2   1  97   0   0   0:  1   6  93   0   0   0:  0   5  95   0   0   0:  0  83  17   0   0   0|   0  4608k|1624   849 |0.46 0.60 0.39|   0    18 
> >   2  45  53   0   0   0:  1  16  83   0   0   0:  3  20  77   0   0   0:  1  15  84   0   0   0|   0  6400k|2420  1984 |0.46 0.60 0.39|   0    26 
> >   1  19  80   0   0   0:  2   8  90   0   0   0:  0  33  67   0   0   0:  0  33  67   0   0   0|   0  6400k|2694  2134 |0.59 0.63 0.40|   0    25 
> >   2   7  91   0   0   0:  2   1  97   0   0   0:  1   0  99   0   0   0:  0  49  10  41   0   0|   0  8269k|1865  1571 |0.59 0.63 0.40|   0   363 
> >   1   1  98   0   0   0:  1   1  98   0   0   0:  1   1  98   0   0   0:  0   1   0  99   0   0|   0  4778k|1509  1639 |0.59 0.63 0.40|   0   410 
> >   2   0  98   0   0   0:  2   1  97   0   0   0:  1   1  98   0   0   0:  2   0   0  98   0   0|   0  5318k|1663  1809 |0.59 0.63 0.40|   0   426 
> >   1   1  98   0   0   0:  2   7  91   0   0   0:  1   0  99   0   0   0:  1   0   0  99   0   0|   0  5446k|1659  1806 |0.59 0.63 0.40|   0   432 
> >   0   1  99   0   0   0:  1   0  99   0   0   0:  2   0  98   0   0   0:  0   1  17  82   0   0|   0  5472k|1572  1837 |0.62 0.63 0.40|   0   439 
> >   2   0  98   0   0   0:  2   2  96   0   0   0:  0   1  99   0   0   0:  0   1  99   0   0   0|   0   397k|1058  1049 |0.62 0.63 0.40|   0    36 
> >   1   1  98   0   0   0:  1   1  98   0   0   0:  1   1  98   0   0   0:  0   0 100   0   0   0|   0     0 | 617   689 |0.62 0.63 0.40|   0     0 
> >   9   4  87   0   0   0:  4   0  96   0   0   0:  1   1  98   0   0   0:  8   6  87   0   0   0|   0     0 |1234  1961 |0.62 0.63 0.40|   0     0 
> >   0   1  99   0   0   0:  1   1  98   0   0   0:  0   1  99   0   0   0:  0   1  99   0   0   0|   0     0 | 391   403 |0.62 0.63 0.40|   0     0 
> >   1   0  99   0   0   0:  1   1  98   0   0   0:  0   0 100   0   0   0:  0   0 100   0   0   0|   0     0 | 366   375 |0.57 0.62 0.40|   0     0 

What is the resolution of the samples here? Where did the hang occur
during this output?

FWIW, Can you capture the hang while running 'iostat -x -d -m 1' so
we can see what is happening with queue depths, average Io sizes,
etc?

> Here are two more examples. The time when the hang occurs is marked with
> "=>":
> ------cpu0-usage--------------cpu1-usage--------------cpu2-usage--------------cpu3-usage------ --dsk/sdb-- ---system-- ---load-avg--- --dsk/sdb--
> usr sys idl wai hiq siq:usr sys idl wai hiq siq:usr sys idl wai hiq siq:usr sys idl wai hiq siq| read  writ| int   csw | 1m   5m  15m |reads writs
.....
>   1  10  89   0   0   0:  2  38  61   0   0   0:  1   8  81  10   0   0:  0  64  36   0   0   0|   0  4476k|2378  2010 |1.12 0.59 0.28|   0   146 
> =>0   0 100   0   0   0:  0   1  99   0   0   0:  0   1   0  99   0   0:  0 100   0   0   0   0|   0     0 |1237   283 |1.12 0.59 0.28|   0     0 
>   0  27  73   0   0   0:  1   0  99   0   0   0:  0   0  47  53   0   0:  0  56  44   0   0   0|   0  5812k|1596   857 |1.12 0.59 0.28|   0   182 
.....
>   7  26  67   0   0   0:  4   1  95   0   0   0:  1  37  62   0   0   0:  3  38  59   0   0   0|   0   864k|2904  2806 |0.70 0.65 0.40|   0    33 
> =>2   1  97   0   0   0:  1   0  99   0   0   0:  0   1  99   0   0   0:  0 100   0   0   0   0|   0     0 |1725   639 |0.89 0.69 0.41|   0     0 
>   1   1  98   0   0   0:  2   1  97   0   0   0:  2   1  97   0   0   0:  0  71  29   0   0   0|   0  3968k|1793   852 |0.89 0.69 0.41|   0   123 
.....

So in both cases here the hang occurs when there is -zero- IO
occurring, and a CPU has pegged at 100% in system time. That's CPU
bound doing <something>.  It is possible that the CPU is getting
caught in a loop somewhere or has a -lot- of processing to do before
progress is made.

I know a CIL commit can take some time to process all the
objects in a checkpoint, but I haven't seen anything like this.
You've only got a relatively small log (100MB) and you're only
removing a kernel source tree, so there really shouldn't be an
excessive number of objects built up to process per checkpoint.

FWIW, I'm pretty sure a CPU getting stuck like this in the
filesystem code should not be causing problems with X or other
non-filesystem workloads. There's 3 idle CPU cores and you are
running a preemptible kernel, so I really can't see why system time
spent in XFS would cause mouse or keyboard updates to not be
processed in a timely manner. We really need to know what is
consuming all that CPU time.

That is, you really need to get a profile of the rm -rf process - or
whatever is consuming the CPU time - (e.g. via perf or ftrace)
across the hang to so we can narrow down the potential cause of the
latency. Speaking of which, latencytop might be helpful in
identifying where input is getting held up....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
