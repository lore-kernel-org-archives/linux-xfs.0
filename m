Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 25 Sep 2007 09:48:52 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8PGmjQ3030265
	for <linux-xfs@oss.sgi.com>; Tue, 25 Sep 2007 09:48:48 -0700
Date: Tue, 25 Sep 2007 12:48:48 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: mkfs options for a 16x hw raid5 and xfs (mostly large files)
In-Reply-To: <20070925160737.GC20499@p15145560.pureserver.info>
Message-ID: <Pine.LNX.4.64.0709251248210.15156@p34.internal.lan>
References: <2119512110-1190729335-cardhu_decombobulator_blackberry.rim.net-718597053-@bxe108.bisx.prod.on.blackberry>
 <20070925160737.GC20499@p15145560.pureserver.info>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Ralf Gross <Ralf-Lists@ralfgross.de>
Cc: linux-xfs@oss.sgi.com



On Tue, 25 Sep 2007, Ralf Gross wrote:

> Bryan J Smith schrieb:
>> Use multiple cards on multiple PCI-X/PCIe channels, each with
>> their own RAID-5 (or 6) volume, and then stripe (OS LVM) RAID-0
>> across the volumes.
>
> The hardware is fixed to one PCI-X FC HBA (4Gb) and two 48x shelfs.
> The performance I get with this setup is ok for us. The data will be
> stored in bunches of multiple TB. Only few clients will access the
> data, maybe 5-10 clients at the same time.
>
>> Depending on your network service and application, you can use
>> either hardware or software for the RAID-5 (or 6).
>> If it's heavily read-only servicing, then software RAID works great,
>> because it's essentially RAID-0 (minus 1 disc).
>> But always use the OS RAID (e.g., LVM stripe) to stripe RAID-0
>> across all volumes, assuming there is not an OS volume limit
>> (of course ;).
>> [...]
>
> I always use SW-RAID for RAID0 and RAID1. But for RAID 5/6 I choose
> either external arrays or internal controllers (Areca).
>
> Ralf
>
>

Just out of curisosity have you tried SW RAID5 on this array?

Also what do you get if you use RAID0 (hw or sw)?

Justin.
