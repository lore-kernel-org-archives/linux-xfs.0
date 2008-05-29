Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 29 May 2008 10:19:12 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4THJ8Vc028908
	for <xfs@oss.sgi.com>; Thu, 29 May 2008 10:19:09 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 260301754261
	for <xfs@oss.sgi.com>; Thu, 29 May 2008 10:20:00 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id QHGj6QIEKotriACA for <xfs@oss.sgi.com>; Thu, 29 May 2008 10:20:00 -0700 (PDT)
Message-ID: <483EE5BD.8020407@sandeen.net>
Date: Thu, 29 May 2008 12:19:57 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS: SB validate failed
References: <3607657a0805291005k457791cej1c5f867da0f95965@mail.gmail.com>
In-Reply-To: <3607657a0805291005k457791cej1c5f867da0f95965@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Spam Magnet <spam.wax@gmail.com>
Cc: xfs@oss.sgi.com

Spam Magnet wrote:
> Hello there :)
> 
> I have a Iomega Jaz cartrdige which seems to be formatted in xfs under
> Irix 6.5.
> When I insert the cartridge in a drive attached to an Octane machine
> (running IRIX 6.5) I get an error message saying that the drive could not
> be mounted:
> The file system on device: /dev/dsk/dks1d3s7 cannot be mounted
> 
> I connected the Jaz drive to a Linux box using a SCSI-to-USB
> adapter. When I do a fdisk I get:
> 
> $ sudo fdisk -l /dev/sdb
> 
> Disk /dev/sdb (SGI disk label): 33 heads, 62 sectors, 1022 cylinders
> Units = cylinders of 2046 * 512 bytes
> 
> ----- partitions -----
> Pt#    Device  Info     Start       End   Sectors  Id  System
>  8: /dev/sdb1               2      1021   2087936   a  SGI xfs
>  9: /dev/sdb2               0         1      3072   0  SGI volhdr
> 11: /dev/sdb3               0      1021   2091008   6  SGI volume

I can't remember how sgi disklabels work under linux; does this show up
as /dev/sdb8 /dev/sdb9 /dev/sdb11 or  as /dev/sdb1 /dev/sdb2 /dev/sdb3
in linux?

Look at /proc/partitions...

point file -s at /dev/sdb$WHATEVER

see if any of them say "xfs"

and try to mount that :)

-Eric
