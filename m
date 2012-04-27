Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3RFAXp0177708 for <xfs@oss.sgi.com>; Fri, 27 Apr 2012 10:10:33 -0500
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id TMu35A2nP0sU3kUy
	for <xfs@oss.sgi.com>; Fri, 27 Apr 2012 08:10:32 -0700 (PDT)
Message-ID: <4F9AB6E9.2050201@hardwarefreak.com>
Date: Fri, 27 Apr 2012 10:10:33 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: A little RAID experiment
References: <CAAxjCEzh3+doupD=LmgqSbCeYWzn9Ru-vE4T8tOJmoud+28FDQ@mail.gmail.com>
	<1335363423.4586.431.camel@montana.filmlight.ltd.uk>
	<CAAxjCExzLXGMw2O32kR8xGS6-EpfwfKm-zkM0Vy58bryWygZuQ@mail.gmail.com>
In-Reply-To: <CAAxjCExzLXGMw2O32kR8xGS6-EpfwfKm-zkM0Vy58bryWygZuQ@mail.gmail.com>
Reply-To: stan@hardwarefreak.com
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Stefan Ring <stefanrin@gmail.com>
Cc: Roger Willcocks <roger@filmlight.ltd.uk>, Linux fs XFS <xfs@oss.sgi.com>

On 4/26/2012 3:53 AM, Stefan Ring wrote:
>> Read 0b  Written 995.77Mb  Total transferred 995.77Mb  (66.337Mb/sec)
>>  8491.11 Requests/sec executed]
> =

> I was a bit sceptical towards your measurement at first, especially
> since your xfs_bmap shows that the file is split into 4 regions which
> nicely aligns (almost) with the agcount=3D4 setup that the benchmark
> emulates, but this seems to be just a coincidence.
> =

> Meanwhile, I've found a customer's system, where we have a MegaRAID
> SAS 1078 with a 6-disk RAID 6 volume, and this one delivers 54MB/sec,
> which really puts the SmartArray controller to shame at its measly
> 4MB/sec.

That's interesting considering the MegaRAID 8708/8880, which I assume is
the 1078 based card above, and the P400 are of roughly the same IC
generation.  Both use PowerPC cores, the P400 at 440MHz and the 1078 at
500MHz, both with DDR2 DRAM, the P400 @533 and the 8880 @667.  On paper
they're very similar.  I'd guess the cause of the big performance
difference is that the 1078 has dedicated parity circuitry and the P400
likely calculates parity in software on the PPC core.  FYI, the parity
engines on the 2208 dual core ASIC are apparently lightning fast
compared to any previous generations.  This chip is found on the
MegaRAID 9265, 9266, 9285, each board having 1GB DDR3-1333 cache.

> I just want to stress that our machine with the SmartArray controller
> is not a cheap old dusty leftover, but a recently-bought (December
> 2011) not exactly cheap Blade server, and that=92s all you get from HP.

The fact they still sell a product doesn't mean it's recent technology.
 On the contrary, HP, IBM, and to a lesser extent Dell, tend to keep
some models on the shelf for a very long time, often 4 years or more.
The P400 has likely been around even longer, given it's DDR2 memory and
SATA 3Gb interfaces.

-- =

Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
