Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 29 May 2008 14:06:04 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4TL62Rv014410
	for <xfs@oss.sgi.com>; Thu, 29 May 2008 14:06:03 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 933D01CE657
	for <xfs@oss.sgi.com>; Thu, 29 May 2008 14:06:54 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id oOVxN7iWyOZoS4r7 for <xfs@oss.sgi.com>; Thu, 29 May 2008 14:06:54 -0700 (PDT)
Message-ID: <483F1AED.3010808@sandeen.net>
Date: Thu, 29 May 2008 16:06:53 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS: SB validate failed
References: <3607657a0805291005k457791cej1c5f867da0f95965@mail.gmail.com>	 <483EE5BD.8020407@sandeen.net>	 <3607657a0805291255i59fd006fi9d6836cf528d19a6@mail.gmail.com>	 <483F0BC3.2050901@sandeen.net> <3607657a0805291400h3c50165lea6fbea919deed0f@mail.gmail.com>
In-Reply-To: <3607657a0805291400h3c50165lea6fbea919deed0f@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Spam Magnet <spam.wax@gmail.com>
Cc: xfs@oss.sgi.com

Spam Magnet wrote:
>> Byte ordering is only an issue for the log replay; you'd get a message
>> about that if it were the issue.
>>
>> Does file -s /dev/sdb? say that any of those things even look like an
>> xfs filesystem?
>>
>> If so point xfs_db at it like:
>>
>> xfs_db -r -c "sb 0" -c "p" /dev/sdb<whatever>
>>
> it's indeed an xfs filesystem:
> $ sudo file -s /dev/sdb8
> /dev/sdb8: SGI XFS filesystem data (blksz 4096, inosz 256, v2 dirs)
> 

...

> 
> I can mount and see the content of this disk: using:
> mount -t xfs /dev/sdb8 /mnt

oh, I thought you couldn't mount it :)

> But xfs_check still crashes on me :(
> /usr/sbin/xfs_check: line 28: 26782 Segmentation fault (core dumped)
> xfs_db$DBOPTS -i -p xfs_check -c "check$OPTS" $1

try xfs_repair -n then maybe.  Or update xfsprogs.  check shouldn't
segfault, regardless of the fs state.

> Will it be ok if I made a 1:1 image of my disks under Irix (using dd):
> 
> $ dd if=/dev/dsk/dks1d3vol of=disk.img bs=512 conv=ignerror,sync
> 
> And tried to use xfs module in Linux to mount them ? or this programs
> are only meant to work with actual device rather than an image file ?

nah that's fine, images or disks, whichever.

-Eric

> thanks for your patience
> 
