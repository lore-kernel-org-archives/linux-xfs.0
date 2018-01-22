Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42702 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750886AbeAVLVM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 22 Jan 2018 06:21:12 -0500
Date: Mon, 22 Jan 2018 06:21:10 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: XFS_Repair - Fatal error -- couldn't map inode - version 4.13.1
Message-ID: <20180122112110.GA25777@bfoster.bfoster>
References: <CAH=0+ChNca2EP2v=YK5Sj-Qe9a4voeVO2oR+LUrq8_LMUe8OrA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAH=0+ChNca2EP2v=YK5Sj-Qe9a4voeVO2oR+LUrq8_LMUe8OrA@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jermey Spies <spiedeerjx12@gmail.com>
Cc: linux-xfs@vger.kernel.org

On Sun, Jan 21, 2018 at 02:29:13PM -0500, Jermey Spies wrote:
> Hello.
> 
> I first want to say I am predominately an end-user with only basic
> knowledge of XFS, although I have been reading (and learning) a lot
> recently trying to fix an issue that popped up with one of the drives
> in an unRAID 6.4 (Slackware 14.2) storage array.
> 
> Any help you or any user you direct me to can provide would be deeply
> appreciated.
> 
> I was directed to seek help from a XFS developer and/or power user
> from unRAID's forums when I found that running xfs_repair -L -v on a
> partition failed with an error. unRAID includes xfs_repair version
> 4.13.1, which should be recent.
> 
> I have attached a copy of the xfs_repair log from that drive
> (xfs_repair -L -v). From what I can see, there seems to be serious
> corruption with super-block 12, however, the error occurs with a file
> on super-block 2. I have also looked into the odd UUID issue and have
> found mostly old bug reports that have been since closed.
> 
> I can, with confidence, guarantee this corruption was not caused by an
> external power outage or hard-reset (unless there is something wrong
> with the back-plane, which I have no reason to suspect). The partition
> was actively being written to when an "I/O error" occurred. Upon
> attempts to remount the drive, the log shows:
> 
> Jan 21 07:38:13 SRV58302 kernel: XFS (md5): Mounting V5 Filesystem
> Jan 21 07:38:13 SRV58302 kernel: XFS (md5): Starting recovery (logdev: internal)
> Jan 21 07:38:14 SRV58302 kernel: XFS (md5): Metadata corruption
> detected at _xfs_buf_ioapply+0x95/0x38a [xfs], xfs_allocbt block
> 0x15d514890
> Jan 21 07:38:14 SRV58302 kernel: XFS (md5): Unmount and run xfs_repair
> Jan 21 07:38:14 SRV58302 kernel: XFS (md5): xfs_do_force_shutdown(0x8)
> called from line 1367 of file fs/xfs/xfs_buf.c.  Return address =
> 0xffffffffa03d1082
> Jan 21 07:38:14 SRV58302 kernel: XFS (md5): Corruption of in-memory
> data detected.  Shutting down filesystem
> Jan 21 07:38:14 SRV58302 kernel: XFS (md5): Please umount the
> filesystem and rectify the problem(s)
> Jan 21 07:38:14 SRV58302 kernel: XFS (md5): log mount/recovery failed:
> error -117
> Jan 21 07:38:14 SRV58302 kernel: XFS (md5): log mount failed
> Jan 21 07:38:14 SRV58302 root: mount: /mnt/disk5: mount(2) system call
> failed: Structure needs cleaning.
> Jan 21 07:38:14 SRV58302 emhttpd: shcmd (73): exit status: 32
> Jan 21 07:38:14 SRV58302 emhttpd: /mnt/disk5 mount error: No file system
> Jan 21 07:38:14 SRV58302 emhttpd: shcmd (74): umount /mnt/disk5
> Jan 21 07:38:14 SRV58302 root: umount: /mnt/disk5: not mounted.
> Jan 21 07:38:14 SRV58302 emhttpd: shcmd (74): exit status: 32
> Jan 21 07:38:14 SRV58302 emhttpd: shcmd (75): rmdir /mnt/disk5
> 
> The drive is installed in a 24-bay Supermicro chassis/back-plane and
> exposed through a LSI 2008 HBA on a Supermicro X10SRL-F with a Xeon E5
> and ECC DDR4. The server is on a 240V 3000VA Eaton UPS with an EBM and
> has dual 1.1KW PSUs. The server has also just passed 24 hrs of memory
> testing with no memory/ECC issues logged. The drive in question is an
> 8TB WD Red 5400 RPM drive, and it has passed both quick and extended
> SMART tests, with zero issues.
> 
> I am willing to try any and all commands to try to fix this. Before I
> did anything, I made a dd clone of the suspect drive in case my
> efforts with xfs_repair have already damaged it. From what I can see
> there are no differences in the output of xfs_repair -n from before
> and after running xfs_repair -L -v. I have another drive coming to
> make a master clone, and will attempt xfs_repair outside unRAID.
> 
> Thank you for your assistance! I am happy to receive any and all guidance.

> Phase 1 - find and verify superblock...
>         - reporting progress in intervals of 15 minutes
>         - block cache size set to 1479176 entries
> Phase 2 - using internal log
...
> Phase 6 - check inode connectivity...
>         - resetting contents of realtime bitmap and summary inodes
>         - traversing filesystem ...
>         - agno = 0
...
> entry "#sanitized#" in directory inode 1093051943 points to non-existent inode 6448754488, marking entry to be junked
> bad hash table for directory inode 1093051943 (no data entry): rebuilding
> rebuilding directory inode 1093051943
> Invalid inode number 0x0
> xfs_dir_ino_validate: XFS_ERROR_REPORT
> 
> fatal error -- couldn't map inode 1124413091, err = 117

This is most likely the same issue reported here[1] where an inode read
verifier is running in a context that gets in the way of repair doing
its job. Please try running xfs_repair v4.10 against your fs. That is
the last release that does not include this change.

Brian

[1] https://marc.info/?l=linux-xfs&m=151625684323031&w=2
