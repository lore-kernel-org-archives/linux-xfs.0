Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 25 Sep 2007 07:09:06 -0700 (PDT)
Received: from smtp102-mob.biz.mail.re2.yahoo.com (smtp102-mob.biz.mail.re2.yahoo.com [206.190.36.117])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l8PE90Q3030756
	for <linux-xfs@oss.sgi.com>; Tue, 25 Sep 2007 07:09:03 -0700
Message-ID: <2119512110-1190729335-cardhu_decombobulator_blackberry.rim.net-718597053-@bxe108.bisx.prod.on.blackberry>
Reply-To: b.j.smith@ieee.org
References: <20070923093841.GH19983@p15145560.pureserver.info> <20070924173155.GI19983@p15145560.pureserver.info> <Pine.LNX.4.64.0709241400370.12025@p34.internal.lan> <20070924203958.GA4082@p15145560.pureserver.info> <Pine.LNX.4.64.0709241642110.19847@p34.internal.lan> <20070924213358.GB4082@p15145560.pureserver.info> <Pine.LNX.4.64.0709241736370.19847@p34.internal.lan> <20070924215223.GC4082@p15145560.pureserver.info> <20070925123501.GA20499@p15145560.pureserver.info> <20070925125733.GA20873@luba.cern.ch><20070925134955.GB20499@p15145560.pureserver.info>
In-Reply-To: <20070925134955.GB20499@p15145560.pureserver.info>
Subject: Re: mkfs options for a 16x hw raid5 and xfs (mostly large files)
From: "=?utf-8?B?QnJ5YW4gSiBTbWl0aA==?=" <b.j.smith@ieee.org>
Date: Tue, 25 Sep 2007 14:08:52 +0000
Content-Type: text/plain
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Ralf Gross <Ralf-Lists@ralfgross.de>, linux-xfs@oss.sgi.com

Use multiple cards on multiple PCI-X/PCIe channels, each with
their own RAID-5 (or 6) volume, and then stripe (OS LVM) RAID-0
across the volumes.

Depending on your network service and application, you can use
either hardware or software for the RAID-5 (or 6).
If it's heavily read-only servicing, then software RAID works great,
because it's essentially RAID-0 (minus 1 disc).
But always use the OS RAID (e.g., LVM stripe) to stripe RAID-0
across all volumes, assuming there is not an OS volume limit
(of course ;).

Software RAID is extemely fast at XORs, that's not the problem.
The problem is how the data stream through the PC's inefficient
I/O interconnect. PC's have gotten much better, but the load still
detracts from other I/O, that services may contend with.

Software RAID-5 writes are, essentially, "programmed I/O."
Every single commit has to have it's parity blocked programmed
by the CPU, which is difficult to bechmark because the
bottleneck is not the CPU, but the LOAD-XOR-STOR of the interconnect.

An IOP is designed with ASIC peripherals to do that in-line, real-time.
In fact, by the very nature of the IOP driver, the operation is synchronous
to the OS' standpoint, unlike software RAID optimizations by the OS.


--  
Bryan J Smith - mailto:b.j.smith@ieee.org  
http://thebs413.blogspot.com  
Sent via BlackBerry from T-Mobile  
    

-----Original Message-----
From: Ralf Gross <Ralf-Lists@ralfgross.de>

Date: Tue, 25 Sep 2007 15:49:56 
To:linux-xfs@oss.sgi.com
Subject: Re: mkfs options for a 16x hw raid5 and xfs (mostly large files)


KELEMEN Peter schrieb:
> * Ralf Gross (ralf-lists@ralfgross.de) [20070925 14:35]:
> 
> > There is a second RAID device attached to the server (24x
> > RAID5). The numbers I get from this device are a bit worse than
> > the 16x RAID 5 numbers (150MB/s read with dd).
> 
> You are expecting 24 spindles to align up when you have a write
> request, which has to be 23*chunksize bytes in order to avoid RMW.
> Additionally, your array is so big that you're very likely to hit
> another error while rebuilding.  Chop up your monster RAID5 array
> into smaller arrays and stripe across them.  Even better, consider
> RAID10.

RAID10 is no option, we need 60+ TB at the moment, mostly large video
files. Basically the read/write performance we get with the 16x RAID 5
is sufficient for our needs. The 24x RAID 5 is only a test device. The
volumes that will be used in the future are the 16/15x RAIDs (48 disk
shelf with 3 volumes).

I'm just wondering how people get 400+ MB/s with HW-RAID 5.

Ralf
