Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 25 Sep 2007 09:08:05 -0700 (PDT)
Received: from stlx01.stz-softwaretechnik.com (stz-softwaretechnik.de [217.160.223.211])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8PG7tQ3021470
	for <linux-xfs@oss.sgi.com>; Tue, 25 Sep 2007 09:07:57 -0700
Received: from rg by stlx01.stz-softwaretechnik.com with local (Exim 3.36 #1 (Debian))
	id 1IaCwt-0003Zj-00
	for <linux-xfs@oss.sgi.com>; Tue, 25 Sep 2007 18:07:47 +0200
Date: Tue, 25 Sep 2007 18:07:37 +0200
From: Ralf Gross <Ralf-Lists@ralfgross.de>
Subject: Re: mkfs options for a 16x hw raid5 and xfs (mostly large files)
Message-ID: <20070925160737.GC20499@p15145560.pureserver.info>
References: <2119512110-1190729335-cardhu_decombobulator_blackberry.rim.net-718597053-@bxe108.bisx.prod.on.blackberry>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2119512110-1190729335-cardhu_decombobulator_blackberry.rim.net-718597053-@bxe108.bisx.prod.on.blackberry>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

Bryan J Smith schrieb:
> Use multiple cards on multiple PCI-X/PCIe channels, each with
> their own RAID-5 (or 6) volume, and then stripe (OS LVM) RAID-0
> across the volumes.

The hardware is fixed to one PCI-X FC HBA (4Gb) and two 48x shelfs.
The performance I get with this setup is ok for us. The data will be
stored in bunches of multiple TB. Only few clients will access the
data, maybe 5-10 clients at the same time.
 
> Depending on your network service and application, you can use
> either hardware or software for the RAID-5 (or 6).
> If it's heavily read-only servicing, then software RAID works great,
> because it's essentially RAID-0 (minus 1 disc).
> But always use the OS RAID (e.g., LVM stripe) to stripe RAID-0
> across all volumes, assuming there is not an OS volume limit
> (of course ;).
> [...]

I always use SW-RAID for RAID0 and RAID1. But for RAID 5/6 I choose
either external arrays or internal controllers (Areca).

Ralf
