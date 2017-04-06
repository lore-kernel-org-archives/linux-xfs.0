Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59082 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754498AbdDFIIG (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 6 Apr 2017 04:08:06 -0400
Date: Thu, 6 Apr 2017 10:08:02 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: Metadata corruption detected at xfs_inode_buf_verify
Message-ID: <20170406080802.3g6ilun5k2fmxf2t@eorzea.usersys.redhat.com>
References: <alpine.DEB.2.21.1.1704051729340.1086@trent.utfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.21.1.1704051729340.1086@trent.utfs.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christian Kujau <lists@nerdbynature.de>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Wed, Apr 05, 2017 at 05:36:13PM -0700, Christian Kujau wrote:
> Hi,
> 
> I have a raspberrypi and try to use that as a small file server. After
> trying to delete a ~1TB direcory, it locked up and was then power cycled. 
> Now I cannot mount the XFS partition any more:
> 

Rpi will usually power cycle when it overheat, and possibly when an NMI is
triggered, since (I suspect) Rpi has no support for NMIs, so the CPU will just
reset.
If you got a soft lockup, your Rpi might have been power cycled due overhead, or
due unsupported NMI if you have got a hardlockup.

Removing 1TB directory, doesn't say much, you can have a 1TB file, which will be
quite fast to delete, or you can have 1million 1MiB files, which will require
extra processing (and maybe your Rpi couldn't handle that?)


> ===============================================
> $ mount -t xfs /dev/mapper/owc1 /mnt/disk
> mount: mount /dev/mapper/owc1 on /mnt/disk failed: Structure needs cleaning
>
You couldn't mount the FS, so, you couldn't replay whatever were in the XFS
journal.
 
>    [producing lots of messages in dmesg, see below]
> 
> 
> $ xfs_repair -v /dev/mapper/owc1
> Phase 1 - find and verify superblock...
>         - reporting progress in intervals of 15 minutes
>         - block cache size set to 26024 entries
> Phase 2 - using internal log
>         - zero log...
> zero_log: head block 3455547 tail block 3450129
> ERROR: The filesystem has valuable metadata changes in a log which needs 
> [...]
> ===============================================
>
 
> Mounting with -o ro,norecovery works, and the directory I wanted to remove 
> is still there, in parts - only about 200 GB have been deleted.
> 
Some of the remaining changes might have been logged but since you couldn't
replay it, you won't see the files being deleted.

> Full script log and .config: http://nerdbynature.de/bits/4.11.0-rc5/xfs/
> 
> Any ideas on how to solve this?
> 
You will need to xfs_repair the filesystem zeroing the logs, then you will be
able to remount it RW and continue with your operations.

See xfs_repair -L option.


> Thanks,
> Christian.
> -- 
> BOFH excuse #431:
> 

-- 
Carlos
