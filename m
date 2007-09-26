Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 26 Sep 2007 10:49:40 -0700 (PDT)
Received: from web32905.mail.mud.yahoo.com (web32905.mail.mud.yahoo.com [209.191.69.82])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id l8QHnWZP004200
	for <linux-xfs@oss.sgi.com>; Wed, 26 Sep 2007 10:49:36 -0700
Date: Wed, 26 Sep 2007 10:49:31 -0700 (PDT)
From: "Bryan J. Smith" <b.j.smith@ieee.org>
Reply-To: b.j.smith@ieee.org
Subject: Re: [UNSURE] Re: mkfs options for a 16x hw raid5 and xfs (mostly large files)
In-Reply-To: <Pine.LNX.4.64.0709261336080.24646@p34.internal.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Message-ID: <730488.2449.qm@web32905.mail.mud.yahoo.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Justin Piszcz <jpiszcz@lucidpixels.com>, "Bryan J. Smith" <b.j.smith@ieee.org>
Cc: Ralf Gross <Ralf-Lists@ralfgross.de>, linux-xfs@oss.sgi.com

Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
> Do you have any type of benchmarks to similate the load you are 
> mentioning?

Yes, write different, non-zero, 100GB data files from 30 NFSv3 sync
clients at the same time.  You can easily script firing that off and
get the number of seconds it takes to commit.

Use NFS with UDP to avoid the overhead of TCP.

> What did HW RAID drop to when the same test was run with SW 
> RAID / 50 MBps under load?

I saw an aggregate commit average of around 150MBps using a pair of
8-channel 3Ware Escalade 9550SX cards (each on their own PCI-X bus),
with a LVM stripe between them.  Understand the test literally took 5
hours to run!

The software RAID-50, two "dumb" SATA 8-channel Marvell cards (each
on their own PCI-X bus), with a LVM stripe between them, was not
completed after 15 hours (overnight).  So I finally terminated it.

Each system had a 4x GbE trunk to a layer-3 switch.  I would have run
the same test with SMB TCP/IP, possibly with a LeWiz 4x GbE RX TOE
HBA, except I honestly didn't have the time to wait on it.

> Did it achieve better performance due to an on-board /
> raid-card controller cache, or?

Has nothing to do with cache.  The OS is far better at scheduling and
buffering in the system RAM, in addition to the fact that it does an
async buffer, whereas many HW RAID drivers are sync to the NVRAM of
the HW RAID card (that's part of the problem with comparisons).

It has to do with the fact in software RAID-5 you are streaming 100%
of the data through the general system interconnect for the
LOAD-XOR-STO operation.  XORs are extrmely fast.  LOAD/STO through a
general purpose CPU is not.

It's the same reason why we don't use general purpose CPUs for
layer-3 switches either, but a "core" CPU with NPE (network processor
engine) ASICs.  Same deal with most HW RAID cards, a "core" CPU with
SPE ASICs -- for off-load from the general CPU system interconnect.

XORs are done "in-line" with the transfer, instead of hogging up the
system interconnect.  It's the direct difference between PIO and DMA.
 An in-line NPE/SPE ASIC basically acts like a DMA transfer,
real-time.  A general purpose CPU and its interconnect cannot do
that, so it has all the issues of PIO.

PIO in a general purpose CPU is to be avoided at all costs when you
have other needs for the system interconnect, like I/O.  If you don't
have much else bothering the I/O, like in a web server or read-only
system (where you're not doing the writes), then it doesn't matter,
and software RAID-5 is great.


-- 
Bryan J. Smith   Professional, Technical Annoyance
b.j.smith@ieee.org    http://thebs413.blogspot.com
--------------------------------------------------
     Fission Power:  An Inconvenient Solution
