Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 19 Jan 2008 09:28:56 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m0JHSj2r030002
	for <xfs@oss.sgi.com>; Sat, 19 Jan 2008 09:28:47 -0800
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E280853AA43
	for <xfs@oss.sgi.com>; Sat, 19 Jan 2008 09:29:04 -0800 (PST)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by cuda.sgi.com with ESMTP id SHCR9EFFgFrow4cn for <xfs@oss.sgi.com>; Sat, 19 Jan 2008 09:29:04 -0800 (PST)
Date: Sat, 19 Jan 2008 12:29:03 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Volume too big
In-Reply-To: <4792223E.7080805@sandeen.net>
Message-ID: <alpine.DEB.0.999999.0801191228450.20223@p34.internal.lan>
References: <Pine.LNX.4.64.0801191650260.4780@fbirervta.pbzchgretzou.qr> <4792223E.7080805@sandeen.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Jan Engelhardt <jengelh@computergmbh.de>, xfs@oss.sgi.com



On Sat, 19 Jan 2008, Eric Sandeen wrote:

> Jan Engelhardt wrote:
>> Hi,
>>
>>
>>
>> 16:51 localhost:~ # fdisk -l /dev/md0
>>
>> Disk /dev/md0: 60183.2 GB, 60183225368576 bytes
>> 2 heads, 4 sectors/track, -1 cylinders
>> Units = cylinders of 8 * 512 = 4096 bytes
>> Disk identifier: 0x00000000
>>
>> Disk /dev/md0 doesn't contain a valid partition table
>>
>> 16:51 localhost:~ # mkfs.xfs -ff /dev/md0
>> meta-data=/dev/md0               isize=256    agcount=55, agsize=268435455 blks
>>          =                       sectsz=512   attr=0
>> data     =                       bsize=4096   blocks=14693170256, imaxpct=25
>>          =                       sunit=0      swidth=0 blks, unwritten=1
>> naming   =version 2              bsize=4096
>> log      =internal log           bsize=4096   blocks=32768, version=1
>>          =                       sectsz=512   sunit=0 blks, lazy-count=0
>> realtime =none                   extsz=4096   blocks=0, rtextents=0
>>
>> 16:51 localhost:~ # strace -e mount mount /dev/md0 /mnt
>> mount("/dev/md0", "/mnt", "xfs", MS_MGC_VAL, NULL) = -1 E2BIG (Argument
>> list too long)
>> mount: Argument list too long
>>
>> 16:51 localhost:~ # uname -a
>> Linux localhost 2.6.23.14-ccj63-regular #1 SMP 2007/10/26 14:17:15 UTC
>> i686 athlon i386 GNU/Linux
>>
>> CONFIG_LBD=y. Do I need an extra flag for mkfs?
>
> Nope; this is probably that you can't do > 16T on a 32 bit box (core
> linux restriction, pretty much)
>
> dmesg would also yield more information about the cause of the mount
> failure.
>
> (Hm, argument list too long is an interesting result tho...)
>
> get an x86_64, I think :)
>
> -Eric
>
>

Is that on one of those thumper boxes?

What type of HW?

Justin.
