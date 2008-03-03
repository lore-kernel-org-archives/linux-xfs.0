Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 03 Mar 2008 05:58:12 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m23Dvq5k030763
	for <xfs@oss.sgi.com>; Mon, 3 Mar 2008 05:57:52 -0800
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 09B21642436
	for <xfs@oss.sgi.com>; Mon,  3 Mar 2008 05:58:16 -0800 (PST)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by cuda.sgi.com with ESMTP id LMZlQHMGhmfUtkWA for <xfs@oss.sgi.com>; Mon, 03 Mar 2008 05:58:16 -0800 (PST)
Date: Mon, 3 Mar 2008 08:58:16 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: disappearing xfs partition
In-Reply-To: <e03b90ae0803030514v585249ecjf93af325287b59f@mail.gmail.com>
Message-ID: <alpine.DEB.1.00.0803030857590.29466@p34.internal.lan>
References: <e03b90ae0803030514v585249ecjf93af325287b59f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Jeff Breidenbach <jeff@jab.org>
Cc: xfs@oss.sgi.com

Looks like a udev problem or something is not making /dev/sde1? Have you 
tried a manual mknod of the device?

On Mon, 3 Mar 2008, Jeff Breidenbach wrote:

> I have no special reason to believe this is xfs specific, but
> is it common for partitions to vanish from the face of the
> earth, at least as far as mount is concerned? I usually mount
> by UUID, but here's a sightly interesting transcript by drive
> letters. If this is not xfs relevant, any suggestions where
> to start digging?
>
> This is a standard format XFS partition, created with an
> xfsprogs that I compiled a couple weeks ago from a source
> code download. Note that other xfs partitions are mounting
> fine on the same machine.
>
>
> -- after a fresh reboot ---
>
> # cfdisk /dev/sde
>
>    Name        Flags      Part Type  FS Type          [Label]        Size (MB)
> ------------------------------------------------------------------------------
>    sde1                    Primary   Linux XFS                      1000202.28
>
> # mount /dev/sde1 /mnt
> mount: special device /dev/sde1 does not exist
>
> # xfs_check /dev/sde1
> /dev/sde1: No such file or directory
>
> fatal error -- couldn't initialize XFS library
>
> # fdisk /dev/sde
>
> The number of cylinders for this disk is set to 121601.
> There is nothing wrong with that, but this is larger than 1024,
> and could in certain setups cause problems with:
> 1) software that runs at boot time (e.g., old versions of LILO)
> 2) booting and partitioning software from other OSs
>   (e.g., DOS FDISK, OS/2 FDISK)
>
> Command (m for help): p
>
> Disk /dev/sde: 1000.2 GB, 1000204886016 bytes
> 255 heads, 63 sectors/track, 121601 cylinders
> Units = cylinders of 16065 * 512 = 8225280 bytes
> Disk identifier: 0x00000000
>
>   Device Boot      Start         End      Blocks   Id  System
> /dev/sde1               1      121601   976760001   83  Linux
>
> # cat /proc/version
> Linux version 2.6.24-8-server (buildd@yellow) (gcc version 4.2.3
> (Ubuntu 4.2.3-1ubuntu2)) #1 SMP Thu Feb 14 20:42:20 UTC 2008
>
> # dpkg -l xfsprogs
> Desired=Unknown/Install/Remove/Purge/Hold
> | Status=Not/Installed/Config-f/Unpacked/Failed-cfg/Half-inst/t-aWait/T-pend
> |/ Err?=(none)/Hold/Reinst-required/X=both-problems (Status,Err: uppercase=bad)
> ||/ Name           Version        Description
> +++-==============-==============-============================================
> ii  xfsprogs       2.9.5-1        Utilities for managing the XFS filesystem
>
>
