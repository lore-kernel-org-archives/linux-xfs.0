Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44810 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750823AbdFULvi (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 21 Jun 2017 07:51:38 -0400
Date: Wed, 21 Jun 2017 13:51:34 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 2/2] xfs: Properly retry failed inode items in case of
 error during buffer writeback
Message-ID: <20170621115134.nmokq6sprzgv7nj6@eorzea.usersys.redhat.com>
References: <20170616105445.3314-1-cmaiolino@redhat.com>
 <20170616105445.3314-3-cmaiolino@redhat.com>
 <20170616183510.GC21846@wotan.suse.de>
 <20170620070103.amrnv3nalfzohku2@eorzea.usersys.redhat.com>
 <20170620162408.GN21846@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170620162408.GN21846@wotan.suse.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: linux-xfs@vger.kernel.org, Gionatan Danti <g.danti@assyoma.it>

Hi Luis

> 
> Curious, since you can reproduce what happens if you do a hard reset on the
> system when this trigger, once it boots back up? I'd guess it covers but just
> want to be sure.
> 

Just for context, the problem with the stuck unmounts happens because the items
in AIL can't be written back to their specific locations in the disk due lack of
real space. But, instead of shutting down the FS when somebody tries to unmount,
or permanently fail the buffer when trying to write it back (if XFS is
configured to fail at some point), xfsaild keep spinning around on such buffers
because the items are flush locked, and they are not even retried at all.

giving this small resumed context, and now answering your question regarding a
hard reset.

When you hard reset the system in such state, after the system comes back alive,
the filesystem in question will be unmountable, because the journal will be
dirty, and XFS won't be able to replay it during the mount due lack of space in
the physical device:

# mount <volume> /mnt
[   91.843429] XFS (dm-5): Mounting V5 Filesystem
[   91.864321] device-mapper: thin: 253:2: reached low water mark for data
device: sending event.
[   91.889451] device-mapper: thin: 253:2: switching pool to out-of-data-space
(error IO) mode
[   91.890821] XFS (dm-5): xfs_do_force_shutdown(0x1) called from line 1201 of
file fs/xfs/xfs_buf.c.  Return address = 0xffffffff813bb416
[   91.893590] XFS (dm-5): I/O Error Detected. Shutting down filesystem
[   91.894813] XFS (dm-5): Please umount the filesystem and rectify the
problem(s)
[   91.896158] XFS (dm-5): metadata I/O error: block 0x31f80 ("xlog_bwrite")
error 28 numblks 4096
[   91.902234] XFS (dm-5): failed to locate log tail
[   91.902920] XFS (dm-5): log mount/recovery failed: error -28
[   91.903712] XFS (dm-5): log mount failed
mount: mount <volume> on /mnt failed: No space left
on device

Although, simply my expanding the thin pool, everything comes back to normal
again:

#lvextend -L +500M <POOL>

# mount <volume> /mnt
[  248.935258] XFS (dm-5): Mounting V5 Filesystem
[  248.954288] XFS (dm-5): Starting recovery (logdev: internal)
[  248.985238] XFS (dm-5): Ending recovery (logdev: internal)


-- 
Carlos
