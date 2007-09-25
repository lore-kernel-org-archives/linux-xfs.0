Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 25 Sep 2007 13:23:55 -0700 (PDT)
Received: from web32906.mail.mud.yahoo.com (web32906.mail.mud.yahoo.com [209.191.69.83])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l8PKNiQ3015805
	for <linux-xfs@oss.sgi.com>; Tue, 25 Sep 2007 13:23:50 -0700
Date: Tue, 25 Sep 2007 13:23:47 -0700 (PDT)
From: "Bryan J. Smith" <thebs413@yahoo.com>
Reply-To: b.j.smith@ieee.org
Subject: Re: mkfs options for a 16x hw raid5 and xfs (mostly large files)
In-Reply-To: <20070925191358.GF20499@p15145560.pureserver.info>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Message-ID: <656917.81056.qm@web32906.mail.mud.yahoo.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Ralf Gross <Ralf-Lists@ralfgross.de>, linux-xfs@oss.sgi.com

Ralf Gross <Ralf-Lists@ralfgross.de> wrote:
> The server should be able to provide five 17MB/s streams (5 win
> clients). Each file is ~2GB large. The clients will access the
> data with smb/cifs, I think the main bottleneck will be samba.

So it's largely read-only SMB access?

So we're talking ...
- Largely read-only disk access
- Largely server TX-only TCP/IP serving

Read-only is cheap, and software RAID-5 is essentially RAID-0 (sans
one disc).  So software RAID-5 is just fine there (assuming there are
no volume addressing limitations).

Server TX is also cheap, most commodity server NICs (i.e., even those
built into mainboards, or typical dual-MAC 96-128KiB SRAM unified
buffer) have a TX TCP Off-load Engine (TOE), some even with Linux
driver support.

You don't need any hardware accelerated RAID or RX TOE (which is far,
far more expensive than TX TOE, largely for receive buffer and
processing).

> Furthermore, the win clients read the data from external USB/PCIe
> SATA drives.

Ouch.  But I won't go there.  ;)

> Sometimes the clients transfers the data from a external
> enclosure with 5 drives (no raid) to the server. The will also be a
> limiting factor.

Ouch.  But I won't go there.  ;)

> I've seen benchmark results from 3ware, areca and other hw raid 5
> vendors (bonnie++, tiobench).

Bonnie++ is really only good for NFS mounts from multiple clients to
a server, and then it will vary.  Aggregate, median, etc... studies
are required.

> Maybe I'm just confused by the benchmarks I found in the
> net and my 200MB/s sql. read/write with tiobench are
> perfectly ok.

I've striped RAID-0 over two, RAID-10 volumes on old 3Ware Escalade
8500-8LP series products over two PCI-X (66MHz) busses and reached
close to 400MBps reads, and over 200MBps writes.  And that was old
ASIC+SRAM (only 4MB) technology in the Escalade 8500 series, not even
native SATA (PATA with SATA PHY).

But I wouldn't get even close to that over the network, especially
not for SMB, unless I used a 4xGbE with a RX TOE and a layer-3
switch.


-- 
Bryan J. Smith   Professional, Technical Annoyance
b.j.smith@ieee.org    http://thebs413.blogspot.com
--------------------------------------------------
     Fission Power:  An Inconvenient Solution
