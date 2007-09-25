Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 25 Sep 2007 09:55:18 -0700 (PDT)
Received: from web32906.mail.mud.yahoo.com (web32906.mail.mud.yahoo.com [209.191.69.83])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l8PGt8Q3032765
	for <linux-xfs@oss.sgi.com>; Tue, 25 Sep 2007 09:55:12 -0700
Date: Tue, 25 Sep 2007 09:28:29 -0700 (PDT)
From: "Bryan J. Smith" <thebs413@yahoo.com>
Reply-To: b.j.smith@ieee.org
Subject: Re: mkfs options for a 16x hw raid5 and xfs (mostly large files)
In-Reply-To: <20070925160737.GC20499@p15145560.pureserver.info>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Message-ID: <152219.84729.qm@web32906.mail.mud.yahoo.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Ralf Gross <Ralf-Lists@ralfgross.de>
Cc: linux-xfs@oss.sgi.com

Ralf Gross <Ralf-Lists@ralfgross.de> wrote:
> The hardware is fixed to one PCI-X FC HBA (4Gb) and two 48x shelfs.
> The performance I get with this setup is ok for us. The data will
> be stored in bunches of multiple TB. Only few clients will access
> the data, maybe 5-10 clients at the same time.

If raw performance is your ultimate goal, the closer you are to the
hardware, and the less overhead in the protocol, the better.

Direct SATA channels (software RAID-10), or taking advantage of the
3Ware ASIC+SRAM (hardware RAID-10) is most ideal.  I've put in a
setup myself that used three (3) 3Ware Escalade 9550SX cards on three
(3) different PCI-X channels, and then striped RAID-0 across all
three (3) volumes (found little difference between using the OS LVM
or the 3Ware manager for the RAID-0 stripe across volumes).

Using a buffered RAID-5 hardware solution is not going to get you the
best latency or direct DTR, if that is what matters.  In most cases,
it does not, depending on your application.

> I always use SW-RAID for RAID0 and RAID1. But for RAID 5/6 I choose
> either external arrays or internal controllers (Areca).

Areca is the Intel IOP + firmware.  Intel's X-Scale storage
processing engines (SPE) seem to best 3Ware's AMCC PowerPC engine. 
The off-load is massive when I/O is an issue.  Unfortunately, I still
find I prefer 3Ware's firmware and software support in Linux over
Areca, and Intel clearly does not have the dedication to addressing
issues that 3Ware does (just like back in the IOP30x/i960 days,
sigh).

To me, support is key.  I've yet to drop a 3Ware volume myself.  The
only people who seem to drop a volume are typically using 3Ware in
JBOD mode, or are "early adopters" of new products.  I don't care if
it's hardware or software, "early adoption" of anything is just not
worth it.  I'd rather have reduced performance for "piece-of-mind." 
3Ware has a solid history on Linux, and my experiences are the
ultimate after 7 years.**

[ **NOTE:  Don't get me started.  The common "proprietary" or
"hardware reliance" argument doesn't hold, because 3Ware's volume
upward compatibility is proven (I've moved volumes of ATA 6000 to
7000 series, SATA 8000 to 9000, etc...), and they have shared the
data organization so you can read them with dmraid as well.  I.e.,
you can always fall back to reading your data off a 3Ware volume with
dmraid these days.  I've also _never_ had an "ATA timeout" issue with
3Ware cards, because 3Ware updates its firmware regularly to "deal"
with troublesome [S]ATA drives.  That has bitten me far too many
times in Linux with direct [S]ATA -- not Linux's fault, just the
fault of hardware [S]ATA PHY chips and their on-drive IDE firmware,
something 3Ware has mitigated for me time and time again. ]

I'm completely biased though, I assemble file and database servers,
not web or other CPU-bound systems.  Turning my system interconnect
(not the CPU, a PC CPU crunches XOR very fast) into a bottlenecked
PIO operation is not ideal for NFS writes or large record SQL commits
in my experience.  Heck, one look at NetApp's volume w/NVRAM and
SPE-accelerated RAID-4 designs will quickly change your opinion as
well (and make you wonder if they aren't worth the cost at times as
well ;).


-- 
Bryan J. Smith   Professional, Technical Annoyance
b.j.smith@ieee.org    http://thebs413.blogspot.com
--------------------------------------------------
     Fission Power:  An Inconvenient Solution
