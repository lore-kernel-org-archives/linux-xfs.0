Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 27 Sep 2007 08:23:00 -0700 (PDT)
Received: from stlx01.stz-softwaretechnik.com (stz-softwaretechnik.de [217.160.223.211])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l8RFMrvD011614
	for <linux-xfs@oss.sgi.com>; Thu, 27 Sep 2007 08:22:54 -0700
Received: from rg by stlx01.stz-softwaretechnik.com with local (Exim 3.36 #1 (Debian))
	id 1IavCL-0000YP-00
	for <linux-xfs@oss.sgi.com>; Thu, 27 Sep 2007 17:22:41 +0200
Date: Thu, 27 Sep 2007 17:22:31 +0200
From: Ralf Gross <Ralf-Lists@ralfgross.de>
Subject: Re: mkfs options for a 16x hw raid5 and xfs (mostly large files)
Message-ID: <20070927152231.GF30287@p15145560.pureserver.info>
References: <20070923093841.GH19983@p15145560.pureserver.info> <18166.25242.174049.175729@base.ty.sabi.co.UK> <20070926145417.GC30287@p15145560.pureserver.info>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070926145417.GC30287@p15145560.pureserver.info>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

Ralf Gross schrieb:
> Peter Grandi schrieb:
> > Ralf> Hi, we have a new large raid array, the shelf has 48 disks,
> > Ralf> the max. amount of disks in a single raid 5 set is 16.
> > 
> > Too bad about that petty limitation ;-).
> 
> Yeah, I prefer 24x RAID 5 without spare. Why waste so much space ;)
> 
> After talking to the people that own the data and wanted to use as
> much as possible space of the device, we'll start with four 12/11
> disk RAID 6 volumes (47 disk + 1 spare). That's ~12% less space than
> before with five RAID 5 volumes. I think this is a good compromise
> between safety and max.  usable disk space.

Ok, the init of the new 12 disk RAID 6 volume is complete. The
numbers I get now are a bit dissapointing: ~210 MB/s for read and ~110
MB/s for write.

I know that RAID 6 is slower than RAID 5, and that less data disks (10
instead of 15) also slow things down. But 390 MB/s read performance
compared to 220 MB/s is a bit suprising. Particularly because the RAID
5 read performance was limited by the FC (I think). I thought I still
would get 1/3 of the RAID 5 read throughput because of the 5 fewer
disks of the RAID 6. I have to test this again with a larger chunk
size (256k), we'll how much this affects read/write performance.

Ralf
