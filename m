Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 25 Sep 2007 12:14:25 -0700 (PDT)
Received: from stlx01.stz-softwaretechnik.com (stz-softwaretechnik.de [217.160.223.211])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8PJEFQ3031436
	for <linux-xfs@oss.sgi.com>; Tue, 25 Sep 2007 12:14:19 -0700
Received: from rg by stlx01.stz-softwaretechnik.com with local (Exim 3.36 #1 (Debian))
	id 1IaFrE-0004ST-00
	for <linux-xfs@oss.sgi.com>; Tue, 25 Sep 2007 21:14:08 +0200
Date: Tue, 25 Sep 2007 21:13:58 +0200
From: Ralf Gross <Ralf-Lists@ralfgross.de>
Subject: Re: mkfs options for a 16x hw raid5 and xfs (mostly large files)
Message-ID: <20070925191358.GF20499@p15145560.pureserver.info>
References: <20070925172535.GD20499@p15145560.pureserver.info> <625784.15537.qm@web32913.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <625784.15537.qm@web32913.mail.mud.yahoo.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

Bryan J. Smith schrieb:
> > Our profile is not that performance driven, thus the ~200MB/s
> > read/write performace is ok. We just need cheap storage ;)
> 
> For what application?  That is the question.  I mean, sustained
> software RAID-5 writes can be a PITA.  E.g., the dd example prior
> doesn't even do XOR recalculation, it merely copies the existing
> parity block with data.  Doing sustained software RAID-5 writes can
> easily drop under 50MBps, as the PC interconnect was not designed to
> stream data (programmed I/O), only direct it (Direct Memory Access).

The server should be able to provide five 17MB/s streams (5 win
clients). Each file is ~2GB large. The clients will access the
data with smb/cifs, I think the main bottleneck will be samba.

There will not be much write access, the data that later will be
streamed to the clients will be transferend to the server from the win
clients first. The files will not be changed afterwards. So there will
be weeks where no data is written, and some days where several TB will be
transfered to the server in 48 hours.

Furthermore, the win clients read the data from external USB/PCIe SATA
drives. Sometimes the clients transfers the data from a external
enclosure with 5 drives (no raid) to the server. The will also be a
limiting factor.
 
> > Still I'm wondering how other people saturate a 4 Gb FC controller
> > with one single RAID 5. At least that's what I've seen in some
> > benchmarks and here on the list.
> 
> Depends on the solution, the benchmark, etc...

I've seen benchmark results from 3ware, areca and other hw raid 5
vendors (bonnie++, tiobench).
 
> > If dd doesn't give me more than 200MB/s, the problem could only be
> > the array, the controller or the FC connection.
> 
> I think you're getting confused.
> 
> There are many factors in how dd performs.  Using an OS-managed
> volume will result in non-blocking I/O, of which dd will scream. 
> Especially when the OS knows it's merely just copying one block to
> another, unlike the FC array, and doesn't need to recalculate the
> parity block.  I know software RAID proponents like to show those
> numbers, but they are beyond removed from "real world," they
> literally leverage the fact that parity doesn't need to be
> recalculated for the blocks moved.
> 
> You need to benchmark from your application -- e.g., clients.  If you
> want "raw" disk access benchmarks, then build a software RAID volume
> with a massive number of SATA channels using "dumb" SATA ASICs. 
> Don't even use an intelligent hardware RAID card in JBOD mode, that
> will only slow the DTR.
> 
> > Given that other setup are similar and not using different
> > controllers and stripes.
> 
> Again, benchmark from your application -- e.g., clients.  Everything
> else means squat.
> 
> I cannot stress this enough.  The only way I can show otherwise, is
> with hardware taps (e.g., PCI-X, PCIe).  I literally couldn't explain
> "well enough" to one client was only getting 60MBps and seeing only
> 10% CPU utilization why their software RAID was the bottleneck until
> I put in a PCI-X card and showed the amount of traffic on the bus. 
> And even that wasn't the system interconnect (although it should be
> possible with a HTX card on an AMD solution, although the card would
> probably cost 5 figures and have some limits).

Maybe I'm just confused by the benchmarks I found in the net and my
200MB/s sql. read/write with tiobench are perfectly ok.

@Justin Piszcz: could you provide some tiobench numbers for you sw
raid 5?

Ralf
