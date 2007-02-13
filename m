Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 13 Feb 2007 01:55:26 -0800 (PST)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l1D9tIm7032601
	for <linux-xfs@oss.sgi.com>; Tue, 13 Feb 2007 01:55:19 -0800
Date: Tue, 13 Feb 2007 04:30:20 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: mkfs and mount tips?
In-Reply-To: <20070213085037.216BE12C53@mail.edu.haifa.ac.il>
Message-ID: <Pine.LNX.4.64.0702130430030.8199@p34.internal.lan>
References: <20070213085037.216BE12C53@mail.edu.haifa.ac.il>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Leon Kolchinsky <leonk@construct.haifa.ac.il>
Cc: linux-xfs@oss.sgi.com



On Tue, 13 Feb 2007, Leon Kolchinsky wrote:

> Hello All,
>
> I have Pentium II (Deschutes) with first 10GB (/dev/hda) and second
> 60GB(/dev/hdc) disk.
> After reading gentoo xfs threads on their forum and some SGI docs and FAQs I
> came with this options for creating FS and mounting the disks:
>
> 1) To create XFS on hda:
>
> Code:
> # mkfs.xfs -l internal,size=128m -d agcount=2 /dev/hda
>
>
> I've also seen "?d unwritten=0" option:
>
> So my question:
> Is it safe to add ?d unwritten=0 option to increase performance like this
> (or will I lose some essential functionality)?:
>
> Is this how the code should look?:
> # mkfs.xfs -l internal,size=128m -d agcount=2 ?d unwritten=0 /dev/hda
>
>
> 2) To prevent data lost in case of power outage(Disabling the write back
> cache):
> Add the following to local.start:
>
> Code:
> # hdparm -W0 /dev/hda
> # hdparm -W0 /dev/hdc
> # blktool /dev/hda wcache off
> # blktool /dev/hdc wcache off
>
>
> Right?
>
> 3) Mount options:
>
> On gentoo xfs thread it's suggested that the mount options should be
> "noatime,logbufs=8"
>
> But what about "osyncisdsync" mount option.
>
> "? osyncisdsync
> ? Writes to files opened with the O_SYNC flag set will behave as if the
> O_DSYNC flag
> had been used instead.
> ? This can result in better performance without compromising data safety.
> ? However timestamp updates from O_SYNC writes can be lost if the system
> crashes.
> Use osyncisosync to disable this setting."
>
> So do you think it is safe to add "osyncisdsync" mount option to fstab?
>
>
> I'd appreciate any comments/tips/answers.
>
>
> Best Regards,
> Leon Kolchinsky
>
>
>
>
>

When I was trying out different optimizations (and what I currently use on 
a couple volumes is):

logbufs=8,logbsize=262144,biosize=16,noatime,nodiratime,nobarrier

Justin.
