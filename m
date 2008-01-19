Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 19 Jan 2008 09:53:34 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m0JHrTkk031525
	for <xfs@oss.sgi.com>; Sat, 19 Jan 2008 09:53:29 -0800
Received: from sovereign.computergmbh.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 73ED9CA04CC
	for <xfs@oss.sgi.com>; Sat, 19 Jan 2008 09:53:44 -0800 (PST)
Received: from sovereign.computergmbh.de (sovereign.computergmbh.de [85.214.69.204]) by cuda.sgi.com with ESMTP id 3BDq2x1U8umHAZv0 for <xfs@oss.sgi.com>; Sat, 19 Jan 2008 09:53:44 -0800 (PST)
Date: Sat, 19 Jan 2008 18:53:06 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: Volume too big
In-Reply-To: <4792223E.7080805@sandeen.net>
Message-ID: <Pine.LNX.4.64.0801191808100.4780@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0801191650260.4780@fbirervta.pbzchgretzou.qr>
 <4792223E.7080805@sandeen.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com


On Jan 19 2008 10:15, Eric Sandeen wrote:
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
>Nope; this is probably that you can't do > 16T on a 32 bit box (core
>linux restriction, pretty much)
>get an x86_64, I think :)

Hm, JFS fails too.
But btrfs 0.11 can mount it.

>dmesg would also yield more information about the cause of the mount
>failure.

XFS: file system too large to be mounted on this system
XFS: SB validate fialed

>(Hm, argument list too long is an interesting result tho...)

I suppose it's right here:

#if XFS_BIG_BLKNOS     /* Limited by ULONG_MAX of page cache index */ 
        if (nblocks >> (PAGE_CACHE_SHIFT - sbp->sb_blocklog) > ULONG_MAX)
                return E2BIG;
#else                  /* Limited by UINT_MAX of sectors */ 
