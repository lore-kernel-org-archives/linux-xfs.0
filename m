Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:59490 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726617AbfGJN0R (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 10 Jul 2019 09:26:17 -0400
Subject: Re: Need help to recover root filesystem after a power supply issue
References: <871210488.20190710125617@a-j.ru>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <fcbcd66e-0c78-f13b-e7aa-1487090d1dfd@sandeen.net>
Date: Wed, 10 Jul 2019 08:26:14 -0500
MIME-Version: 1.0
In-Reply-To: <871210488.20190710125617@a-j.ru>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andrey Zhunev <a-j@a-j.ru>, linux-xfs@vger.kernel.org

On 7/10/19 4:56 AM, Andrey Zhunev wrote:
> Hello All,
> 
> I am struggling to recover my system after a PSU failure, and I was
> suggested to ask here for support.
> 
> One of the hard drives throws some read errors, and that happen to be
> my root drive...
> My system is CentOS 7, and the root partition is a part of LVM.
> 
> [root@mgmt ~]# lvscan
>   ACTIVE            '/dev/centos/root' [<98.83 GiB] inherit
>   ACTIVE            '/dev/centos/home' [<638.31 GiB] inherit
>   ACTIVE            '/dev/centos/swap' [<7.52 GiB] inherit
> [root@mgmt ~]#
> 
> [root@tftp ~]# file -s /dev/centos/root
> /dev/centos/root: symbolic link to `../dm-3'
> [root@tftp ~]# file -s /dev/centos/home
> /dev/centos/home: symbolic link to `../dm-4'
> [root@tftp ~]# file -s /dev/dm-3
> /dev/dm-3: SGI XFS filesystem data (blksz 4096, inosz 256, v2 dirs)
> [root@tftp ~]# file -s /dev/dm-4
> /dev/dm-4: SGI XFS filesystem data (blksz 4096, inosz 256, v2 dirs)
> 
> 
> [root@tftp ~]# xfs_repair /dev/centos/root
> Phase 1 - find and verify superblock...
> superblock read failed, offset 53057945600, size 131072, ag 2, rval -1
> 
> fatal error -- Input/output error

look at dmesg, see what the kernel says about the read failure.

You might be able to use https://www.gnu.org/software/ddrescue/ 
to read as many sectors off the device into an image file as possible,
and that image might be enough to work with for recovery.  That would be
my first approach:

1) use dd-rescue to create an image file of the device
2) make a copy of that image file
3) run xfs_repair -n on the copy to see what it would do
4) if that looks reasonable run xfs_repair on the copy
5) mount the copy and see what you get

But if your drive simply cannot be read at all, this is not a filesystem
problem, it is a hardware problem. If this is critical data you may wish
to hire a data recovery service.

-Eric


> [root@tftp ~]#
> 
> 
> smartctl shows some pending sectors on /dev/sda, and no reallocated
> sectors (yet?).
> 
> Can someone please give me a hand to bring root partition back to life
> (ideally)? Or, at least, recover a couple of critical configuration
> files...
> 
> 
> ---
> Best regards,
>  Andrey
> 
