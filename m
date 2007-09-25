Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 25 Sep 2007 10:41:59 -0700 (PDT)
Received: from web32913.mail.mud.yahoo.com (web32913.mail.mud.yahoo.com [209.191.69.113])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l8PHfrQ3015945
	for <linux-xfs@oss.sgi.com>; Tue, 25 Sep 2007 10:41:55 -0700
Date: Tue, 25 Sep 2007 10:41:56 -0700 (PDT)
From: "Bryan J. Smith" <thebs413@yahoo.com>
Reply-To: b.j.smith@ieee.org
Subject: Re: mkfs options for a 16x hw raid5 and xfs (mostly large files)
In-Reply-To: <20070925172535.GD20499@p15145560.pureserver.info>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Message-ID: <625784.15537.qm@web32913.mail.mud.yahoo.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Ralf Gross <Ralf-Lists@ralfgross.de>
Cc: linux-xfs@oss.sgi.com

Ralf Gross <Ralf-Lists@ralfgross.de> wrote:
> Thanks for all the details. Before I leave the office (it's getting
> dark here): I think the Overland RAID we have (48x Disk) is from
> the same manufacturer (Xyratex) that builds some devices for
NetApp.

There's a lot of cross-fabbing these days.  I was referring more to
NetApp's combined hardware-OS-volume approach, although that was
clearly a poor tangent by myself.

> Our profile is not that performance driven, thus the ~200MB/s
> read/write performace is ok. We just need cheap storage ;)

For what application?  That is the question.  I mean, sustained
software RAID-5 writes can be a PITA.  E.g., the dd example prior
doesn't even do XOR recalculation, it merely copies the existing
parity block with data.  Doing sustained software RAID-5 writes can
easily drop under 50MBps, as the PC interconnect was not designed to
stream data (programmed I/O), only direct it (Direct Memory Access).

> Still I'm wondering how other people saturate a 4 Gb FC controller
> with one single RAID 5. At least that's what I've seen in some
> benchmarks and here on the list.

Depends on the solution, the benchmark, etc...

> If dd doesn't give me more than 200MB/s, the problem could only be
> the array, the controller or the FC connection.

I think you're getting confused.

There are many factors in how dd performs.  Using an OS-managed
volume will result in non-blocking I/O, of which dd will scream. 
Especially when the OS knows it's merely just copying one block to
another, unlike the FC array, and doesn't need to recalculate the
parity block.  I know software RAID proponents like to show those
numbers, but they are beyond removed from "real world," they
literally leverage the fact that parity doesn't need to be
recalculated for the blocks moved.

You need to benchmark from your application -- e.g., clients.  If you
want "raw" disk access benchmarks, then build a software RAID volume
with a massive number of SATA channels using "dumb" SATA ASICs. 
Don't even use an intelligent hardware RAID card in JBOD mode, that
will only slow the DTR.

> Given that other setup are similar and not using different
> controllers and stripes.

Again, benchmark from your application -- e.g., clients.  Everything
else means squat.

I cannot stress this enough.  The only way I can show otherwise, is
with hardware taps (e.g., PCI-X, PCIe).  I literally couldn't explain
"well enough" to one client was only getting 60MBps and seeing only
10% CPU utilization why their software RAID was the bottleneck until
I put in a PCI-X card and showed the amount of traffic on the bus. 
And even that wasn't the system interconnect (although it should be
possible with a HTX card on an AMD solution, although the card would
probably cost 5 figures and have some limits).


-- 
Bryan J. Smith   Professional, Technical Annoyance
b.j.smith@ieee.org    http://thebs413.blogspot.com
--------------------------------------------------
     Fission Power:  An Inconvenient Solution
