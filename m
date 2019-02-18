Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr1-f66.google.com ([209.85.221.66]:44688 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390760AbfBROWI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Feb 2019 09:22:08 -0500
Received: by mail-wr1-f66.google.com with SMTP id w2so3954553wrt.11
        for <linux-xfs@vger.kernel.org>; Mon, 18 Feb 2019 06:22:06 -0800 (PST)
Date: Mon, 18 Feb 2019 15:22:03 +0100
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: Corruption of in-memory data detected. Shutting down filesystem
Message-ID: <20190218142203.p53qvipc4yul6mv6@hades.usersys.redhat.com>
References: <b4141aed-70f1-83de-92e3-b8c9494900c7@molgen.mpg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b4141aed-70f1-83de-92e3-b8c9494900c7@molgen.mpg.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Paul Menzel <pmenzel@molgen.mpg.de>
Cc: linux-xfs@vger.kernel.org

Hi.

> Dear XFS folks,
> 
> 

> [   25.506600] XFS (sdd): Mounting V5 Filesystem
> [   25.629621] XFS (sdd): Starting recovery (logdev: internal)
> [   25.685100] NFSD: starting 90-second grace period (net f0000098)
> [   26.433828] XFS (sdd): xfs_do_force_shutdown(0x8) called from line 368 of file fs/xfs/xfs_trans.c.  Return address = 00000000cfa623e1
> [   26.433834] XFS (sdd): Corruption of in-memory data detected.  Shutting down filesystem
> [   26.433835] XFS (sdd): Please umount the filesystem and rectify the problem(s)
> [   26.433857] XFS (sdd): xfs_imap_to_bp: xfs_trans_read_buf() returned error -5.
> 
Ok, filesystem shut itself down likely because blocks allocated in the
transaction exceeded the reservation.

Could you please post the whole dmesg?

> We mounted it with an overlay files,

I'm not sure what you meant here, could you please specify what you meant by
'overlay files'? Are you using this XFS filesystem as an upper/lower FS for
overlayfs?

> and the xfs_repair shows the
> summary below.
> 
> ```
> # xfs_repair -vv /dev/mapper/sddovl
>         - block cache size set to 4201400 entries
> Phase 2 - using internal log
>         - zero log...
> zero_log: head block 3930112 tail block 3929088
> ERROR: The filesystem has valuable metadata changes in a log which needs to
> be replayed.  Mount the filesystem to replay the log, and unmount it before
> re-running xfs_repair.  If you are unable to mount the filesystem, then use
> the -L option to destroy the log and attempt a repair.
> Note that destroying the log may cause corruption -- please attempt a mount

Have you tried to mount/umount the filesystem before zeroing the log? This is
supposed to be used as a last resort. Zero out the logs I mean.

> 
> The directory `lost+found` contains almost five million files
> 
>     # find lost+found | wc
>     4859687 4859687 110985720

We don't have neither the whole xfs_repair output nor more information about the
filesystem itself, but looks like you had huge directory(ies) update in your log
which were not replayed, and all orphan inodes ended up in the lost+found =/

> 
> We saved the output of `xfs_repair`, but it’s over 500 MB in size, so we
> cannot attach it.
> 
> `sudo xfs_metadump -go /dev/sdd sdd-metadump.dump` takes over 15 minutes
> and the dump files is 8.8 GB in size.

At this point, xfs_metadump won't help much once you already repaired the
filesystem.
Although, why are you getting a metadump from /dev/sdd, when the fs you tried to
repair is a device-mapper device? Are you facing this issue in more than one
filesystem?

> 
> It’d be great, if you could give hints on debugging this issue further,
> and comment, if you think it is possible to recover the files, that means,
> to fix the log, so that it can be cleanly applied.

Unfortunately, you already got rid of the log, so, you can't recover it anymore,
but all the recovered files will be in lost+found, with their inode numbers as
file name.


Ok, so below is the dmesg, thanks for having attached it.

One thing is there are 2 devices failing. sdd and dm-0. So my question again, is
this the same filesystem or are they 2 separated filesystems showing exactly the
same issue? The filesystem has found corrupted inodes in the AG's unlinked
bucket, but this shouldn't affect log recovery.

If they are two separated devices, did you xfs_repair'ed both of them? After you
repaired the filesystem(s), do you still see the memory corruption issue?

At this point, there is not much we can do regarding the filesystem metadata,
once you already forced a xfs_repair zeroing the logs.

So, could you please tell the current state of the filesystem (or filesystems if
there is more than one)? Are you still seeing the same memory corruption error
even after xfs_repair it?

And for completeness, please provide us as much information as possible from
this(these) filesystem(s):

http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F

Cheers.

> [ 1380.869451] XFS (sdd): Mounting V5 Filesystem
> [ 1380.912559] XFS (sdd): Starting recovery (logdev: internal)
> [ 1381.030780] XFS (sdd): xfs_do_force_shutdown(0x8) called from line 368 of file fs/xfs/xfs_trans.c.  Return address = 00000000cfa623e1
> [ 1381.030785] XFS (sdd): Corruption of in-memory data detected.  Shutting down filesystem
> [ 1381.030786] XFS (sdd): Please umount the filesystem and rectify the problem(s)
> [ 1381.031086] XFS (sdd): xlog_recover_clear_agi_bucket: failed to clear agi 0. Continuing.
> [ 1381.031088] XFS (sdd): xfs_imap_to_bp: xfs_trans_read_buf() returned error -5.
> [ 1381.031090] XFS (sdd): xlog_recover_clear_agi_bucket: failed to clear agi 0. Continuing.
> [ 1381.031093] XFS (sdd): xfs_imap_to_bp: xfs_trans_read_buf() returned error -5.
> [ 1381.031095] XFS (sdd): xlog_recover_clear_agi_bucket: failed to clear agi 0. Continuing.
<...>
> [ 1381.031113] XFS (sdd): Ending recovery (logdev: internal)
> [ 1381.031490] XFS (sdd): Error -5 reserving per-AG metadata reserve pool.
> [ 1381.031492] XFS (sdd): xfs_do_force_shutdown(0x8) called from line 548 of file fs/xfs/xfs_fsops.c.  Return address = 00000000217dbba5

> [ 2795.123228] XFS (dm-0): Ending recovery (logdev: internal)
> [ 2795.231020] XFS (dm-0): Error -5 reserving per-AG metadata reserve pool.
> [ 2795.231023] XFS (dm-0): xfs_do_force_shutdown(0x8) called from line 548 of file fs/xfs/xfs_fsops.c.  Return address = 00000000217dbba5

> [10944.023429] XFS (dm-0): Mounting V5 Filesystem
> [10944.035260] XFS (dm-0): Ending clean mount
> [11664.862376] XFS (dm-0): Unmounting Filesystem
> [11689.260213] XFS (dm-0): Mounting V5 Filesystem
> [11689.338187] XFS (dm-0): Ending clean mount




-- 
Carlos
