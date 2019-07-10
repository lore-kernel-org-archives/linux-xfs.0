Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from egyptian.birch.relay.mailchannels.net ([23.83.209.56]:5658 "EHLO
        egyptian.birch.relay.mailchannels.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726080AbfGJN6y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 Jul 2019 09:58:54 -0400
Date: Wed, 10 Jul 2019 16:58:41 +0300
From: Andrey Zhunev <a-j@a-j.ru>
Message-ID: <433120592.20190710165841@a-j.ru>
Subject: Re: Need help to recover root filesystem after a power supply issue
In-Reply-To: <fcbcd66e-0c78-f13b-e7aa-1487090d1dfd@sandeen.net>
References: <871210488.20190710125617@a-j.ru> <fcbcd66e-0c78-f13b-e7aa-1487090d1dfd@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org

Wednesday, July 10, 2019, 4:26:14 PM, you wrote:

> On 7/10/19 4:56 AM, Andrey Zhunev wrote:
>> Hello All,
>> 
>> I am struggling to recover my system after a PSU failure, and I was
>> suggested to ask here for support.
>> 
>> One of the hard drives throws some read errors, and that happen to be
>> my root drive...
>> My system is CentOS 7, and the root partition is a part of LVM.
>> 
>> [root@mgmt ~]# lvscan
>>   ACTIVE            '/dev/centos/root' [<98.83 GiB] inherit
>>   ACTIVE            '/dev/centos/home' [<638.31 GiB] inherit
>>   ACTIVE            '/dev/centos/swap' [<7.52 GiB] inherit
>> [root@mgmt ~]#
>> 
>> [root@tftp ~]# file -s /dev/centos/root
>> /dev/centos/root: symbolic link to `../dm-3'
>> [root@tftp ~]# file -s /dev/centos/home
>> /dev/centos/home: symbolic link to `../dm-4'
>> [root@tftp ~]# file -s /dev/dm-3
>> /dev/dm-3: SGI XFS filesystem data (blksz 4096, inosz 256, v2 dirs)
>> [root@tftp ~]# file -s /dev/dm-4
>> /dev/dm-4: SGI XFS filesystem data (blksz 4096, inosz 256, v2 dirs)
>> 
>> 
>> [root@tftp ~]# xfs_repair /dev/centos/root
>> Phase 1 - find and verify superblock...
>> superblock read failed, offset 53057945600, size 131072, ag 2, rval -1
>> 
>> fatal error -- Input/output error

> look at dmesg, see what the kernel says about the read failure.

> You might be able to use https://www.gnu.org/software/ddrescue/ 
> to read as many sectors off the device into an image file as possible,
> and that image might be enough to work with for recovery.  That would be
> my first approach:

> 1) use dd-rescue to create an image file of the device
> 2) make a copy of that image file
> 3) run xfs_repair -n on the copy to see what it would do
> 4) if that looks reasonable run xfs_repair on the copy
> 5) mount the copy and see what you get

> But if your drive simply cannot be read at all, this is not a filesystem
> problem, it is a hardware problem. If this is critical data you may wish
> to hire a data recovery service.

> -Eric


Hi Eric,

Thanks for your message!
I already started to copy the failing drive with ddrescue. This is a
large drive, so it takes some time to complete...

When I tried to run xfs_repair on the original (failing) drive, the
xfs_repair was unable to read the superblock and then just quitted
with an 'io error'.
Do you think it can behave differently on a copied image ?

I will definitely give it a try once the ddrescue finishes.


P.S. The data on this drive is not THAT critical to hire a
professional data recovery service. Still, there are some files I
would really like to restore (mostly settings and configuration
files - nothing large, but important)... This will save me weeks to
reconfigure and get the system back to its original state...
Backups, always make backups... yeah, I know... :(


 ---
 Best regards,
  Andrey
