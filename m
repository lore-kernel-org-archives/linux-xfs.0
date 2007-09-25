Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 25 Sep 2007 10:26:00 -0700 (PDT)
Received: from stlx01.stz-softwaretechnik.com (stz-softwaretechnik.de [217.160.223.211])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8PHPqQ3012106
	for <linux-xfs@oss.sgi.com>; Tue, 25 Sep 2007 10:25:56 -0700
Received: from rg by stlx01.stz-softwaretechnik.com with local (Exim 3.36 #1 (Debian))
	id 1IaEAL-00071Z-00
	for <linux-xfs@oss.sgi.com>; Tue, 25 Sep 2007 19:25:45 +0200
Date: Tue, 25 Sep 2007 19:25:35 +0200
From: Ralf Gross <Ralf-Lists@ralfgross.de>
Subject: Re: mkfs options for a 16x hw raid5 and xfs (mostly large files)
Message-ID: <20070925172535.GD20499@p15145560.pureserver.info>
References: <20070925160737.GC20499@p15145560.pureserver.info> <152219.84729.qm@web32906.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152219.84729.qm@web32906.mail.mud.yahoo.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

Bryan J. Smith schrieb:
> Ralf Gross <Ralf-Lists@ralfgross.de> wrote:
> ... 
> I'm completely biased though, I assemble file and database servers,
> not web or other CPU-bound systems.  Turning my system interconnect
> (not the CPU, a PC CPU crunches XOR very fast) into a bottlenecked
> PIO operation is not ideal for NFS writes or large record SQL commits
> in my experience.  Heck, one look at NetApp's volume w/NVRAM and
> SPE-accelerated RAID-4 designs will quickly change your opinion as
> well (and make you wonder if they aren't worth the cost at times as
> well ;).

Thanks for all the details. Before I leave the office (it's getting
dark here): I think the Overland RAID we have (48x Disk) is from the
same manufacturer (Xyratex) that builds some devices for NetApp.

Our profile is not that performance driven, thus the ~200MB/s
read/write performace is ok. We just need cheap storage ;)

Still I'm wondering how other people saturate a 4 Gb FC controller
with one single RAID 5. At least that's what I've seen in some
benchmarks and here on the list.

If dd doesn't give me more than 200MB/s, the problem could only be the
array, the controller or the FC connection. Given that other setup are
similar and not using different controllers and stripes.

Ralf
