Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 10 Dec 2007 15:10:16 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lBANA7mg022230
	for <linux-xfs@oss.sgi.com>; Mon, 10 Dec 2007 15:10:08 -0800
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 829F646768D
	for <linux-xfs@oss.sgi.com>; Mon, 10 Dec 2007 14:55:49 -0800 (PST)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by cuda.sgi.com with ESMTP id U5FoYK4DRjlGJqna for <linux-xfs@oss.sgi.com>; Mon, 10 Dec 2007 14:55:49 -0800 (PST)
Date: Mon, 10 Dec 2007 17:55:17 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Unexpected XFS SB number 0x00000000
In-Reply-To: <002a01c83b74$52060330$f6120990$@de>
Message-ID: <Pine.LNX.4.64.0712101754400.30570@p34.internal.lan>
References: <002a01c83b74$52060330$f6120990$@de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Chris <hsvchris@gmx.de>
Cc: linux-xfs@oss.sgi.com



On Mon, 10 Dec 2007, Chris wrote:

> Hello!
>
> I'm running a home file server with Debian GNU/Linux 4.0 4.0r1 etch
> (2.6.18-5-amd64 Kernel) and an Areca ARC-1220 hardware RAID controller.
> I used to have 4 750GB HDDs connected and set up as RAID 5 array, single
> volume, single XFS partition (set up during the installation of Debian). No
> problems so far.
>
> Now I added another 750GB HDD to the array, online capacity/volume expansion
> by the controller finished just fine.
> My plan was to add the extra space to the above mentioned XFS partition. So
> I unmounted the partition, started cfdisk, removed the partition table and
> wrote a new one that included the new free space.
> After rebooting the partition wasn't mounted, so I couldn't use xfs_growth
> to expand the filesystem.
>
> xfs_check: unexpected XFS SB magic number 0x00000000
>
> xfs_repair -n:
> Phase 1 - find and verify superblock...
> bad primary superblock - bad magic number !!!
> attempting to find secondary superblock.......[...].............found
> candidate secondary superblock...unable to verify superblock,
> continuing..........[...]................
> .......Sorry, could not find valid secondary superblock
> Exciting now.
>
> I realize the magic number 0x00000000 is probably not a good thing and maybe
> using fdisk to write a new table was not the way to do it?
> Any suggestions on restoring the old partition table / magic number or how
> to proceed? Is there an easy fix or is this a serious problem?
>
> Kind Regards,
> Chris
>
>

When I grew mine, I used mdadm/raid5, expanded the array and then you run 
xfs_growfs on the mounted filesystem and it worked.

Wiping out the partition is not the way to do it.

Justin.
