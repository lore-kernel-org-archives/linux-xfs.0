Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o316xqEc098989 for <xfs@oss.sgi.com>; Thu, 1 Apr 2010 01:59:52 -0500
Received: from moutng.kundenserver.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3A3FE294626
	for <xfs@oss.sgi.com>; Thu,  1 Apr 2010 00:01:38 -0700 (PDT)
Received: from moutng.kundenserver.de (moutng.kundenserver.de [212.227.17.9])
	by cuda.sgi.com with ESMTP id ehMEymlfK26SgWeB for
	<xfs@oss.sgi.com>; Thu, 01 Apr 2010 00:01:38 -0700 (PDT)
Received: from localhost ([127.0.0.1])
	by bogon.housecafe.de with esmtp (Exim 4.69)
	(envelope-from <lists@nerdbynature.de>) id 1NxEPI-0004Oy-P4
	for xfs@oss.sgi.com; Thu, 01 Apr 2010 09:01:36 +0200
Date: Thu, 1 Apr 2010 00:01:36 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: 2.6.32: dirty log written in incompatible format
In-Reply-To: <alpine.DEB.2.01.1003312325110.5493@bogon.housecafe.de>
Message-ID: <alpine.DEB.2.01.1003312359490.5493@bogon.housecafe.de>
References: <alpine.DEB.2.01.1003312325110.5493@bogon.housecafe.de>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

On Wed, 31 Mar 2010 at 23:45, Christian Kujau wrote:
> recently I had some hardware-related trouble with this external dual disk 
> enclosure, which is usually connected vua USB to a powerpc32 machine 
> running mostly vanilla kernels. I think the USB port is dead so I 
> had to take the the enclosure into another box - this time via Firewire to 
> a Intel Mac (2.6.32-18 ubuntu kernel)

Oh, it seems to be an endianness issue indeed:

   http://oss.sgi.com/pipermail/xfs/2009-November/043183.html

If only I had found this one /before/ writing to the list :-)

Christian.

> One of the disks (same model, same GPT partitioning) is formatted with 
> ext4 (which is fine), the other one with xfs - and I can't mount the xfs 
> disk (partition) any more:
> 
> disko# mount -t xfs /dev/mapper/wdc1 /mnt/wdc1
> mount: /dev/mapper/wdc1: can't read superblock
> 
> SGI XFS with ACLs, security attributes, realtime, large block/inode numbers, no debug enabled
> SGI XFS Quota Management subsystem
> XFS mounting filesystem dm-0
> Starting XFS recovery on filesystem: dm-0 (logdev: internal)
> XFS: dirty log written in incompatible format - can't recover
> XFS: log mount/recovery failed: error 5
> XFS: log mount failed
> 
> When the disk was mounted the last time (usb, powerpc32) an rsync process 
> was busy copying data between directories and "rm" was also involved - 
> then the disk issues kicked in again (USB disconnect, etc) and XFS was 
> shutting down, of course.
> 
> However, the powerpc32 machine already was on 2.6.34-rc2 (I'm tracking
> -rc versions, so it was running -rc1 before ...and so on) - could it be 
> that the 2.6.32 Ubuntu kernel doesn't understand the dirty log from 
> 2.6.34-rc2? Or is it arch related?
> 
> FWIW, xfs_check advises to mount the filesystem first, xfs_repair *would* 
> do quite a few operations on the filesystem. I've put a few more details 
> here: http://nerdbynature.de/bits/2.6.32/xfs/
> 
> Oh, and the whole xfs (resp. ext4) stuff is on top of dm-crypt/LUKS, but 
> it's not a keying issue, as I can clearly see the XFS partition.
> 
> Thanks for reading (and replying!)
> Christian.
> -- 
> BOFH excuse #315:
> 
> The recent proliferation of Nuclear Testing
-- 
BOFH excuse #92:

Stale file handle (next time use Tupperware(tm)!)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
