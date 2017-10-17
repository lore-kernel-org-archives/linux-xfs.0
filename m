Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37052 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751831AbdJQMXL (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 17 Oct 2017 08:23:11 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id BDED580F94
        for <linux-xfs@vger.kernel.org>; Tue, 17 Oct 2017 12:23:11 +0000 (UTC)
Date: Tue, 17 Oct 2017 20:23:10 +0800
From: Zorro Lang <zlang@redhat.com>
Subject: [Bug Report] XFS mismatch between extent format and zero size in
 symlink
Message-ID: <20171017122309.GH21475@dhcp12-143.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: bfoster@redhat.com

Hi,

After Brian fixed a panic bug reproduced by generic/388:
  xfs: release bli from transaction properly on fs shutdown
  xfs: remove bli from AIL before release on transaction abort
I tried to run g/388 again. Then I found a corruption [1] and
lots of dmesg error output [2].

I tested on kernel-4.14.0-rc2, and I can reproduce this bug on
other architectures with different block size (512/1024/2048/4096)
by run generic/388 many times (I reproduced it within 100 times).
You can find the corrupted XFS metadump and dmesg from:

  https://drive.google.com/open?id=0B5dFDeCXGOPXU0ROMlNHN0dHZ00

Thanks,
Zorro

[1]
generic/388 97s ... 122s
_check_xfs_filesystem: filesystem on /dev/mapper/rhelp_hp--dl380pg8--01-scratchdev is inconsistent (c)
(see /root/git/xfstests-dev/results//generic/388.full for details)
_check_xfs_filesystem: filesystem on /dev/mapper/rhelp_hp--dl380pg8--01-scratchdev is inconsistent (r)
(see /root/git/xfstests-dev/results//generic/388.full for details)
_check_dmesg: something found in dmesg (see /root/git/xfstests-dev/results//generic/388.dmesg)
Ran: generic/388
Failures: generic/388
Failed 1 of 1 tests

# xfs_repair -n $SCRATCH_DEV
Phase 1 - find and verify superblock...
        - reporting progress in intervals of 15 minutes
Phase 2 - using internal log
        - zero log...
        - scan filesystem freespace and inode maps...
        - 07:25:39: scanning filesystem freespace - 16 of 16 allocation groups done
        - found root inode chunk
Phase 3 - for each AG...
        - scan (but don't clear) agi unlinked lists...
        - 07:25:39: scanning agi unlinked lists - 16 of 16 allocation groups done
        - process known inodes and perform inode discovery...
        - agno = 0
        - agno = 15
mismatch between format (2) and size (0) in symlink ino 1541
bad data fork in symlink 1541
would have cleared inode 1541
        - agno = 1
        - agno = 2
        - agno = 3
        - agno = 4
        - agno = 5
        - agno = 6
        - agno = 7
        - agno = 8
        - agno = 9
        - agno = 10
        - agno = 11
        - agno = 12
        - agno = 13
        - agno = 14
        - 07:25:39: process known inodes and inode discovery - 2624 of 2624 inodes done
        - process newly discovered inodes...
        - 07:25:39: process newly discovered inodes - 16 of 16 allocation groups done
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - 07:25:39: setting up duplicate extent list - 16 of 16 allocation groups done
        - check for inodes claiming duplicate blocks...
        - agno = 0
        - agno = 2
        - agno = 1
        - agno = 3
        - agno = 5
        - agno = 7
        - agno = 9
        - agno = 4
        - agno = 10
        - agno = 13
        - agno = 8
        - agno = 15
mismatch between format (2) and size (0) in symlink ino 1541
bad data fork in symlink 1541
would have cleared inode 1541
        - agno = 11
        - agno = 14
        - agno = 12
        - agno = 6
        - 07:25:39: check for inodes claiming duplicate blocks - 2624 of 2624 inodes done
No modify flag set, skipping phase 5   
Phase 6 - check inode connectivity...  
        - traversing filesystem ...
        - traversal finished ...
        - moving disconnected inodes to lost+found ...
Phase 7 - verify link counts...
        - 07:25:39: verify and correct link counts - 16 of 16 allocation groups done
No modify flag set, skipping filesystem flush and exiting.


[2]
[338624.310349] run fstests generic/388 at 2017-10-17 07:11:52
[338624.549497] XFS (dm-3): Unmounting Filesystem
[338624.616738] XFS (dm-3): Mounting V5 Filesystem
[338624.686806] XFS (dm-3): Ending clean mount
[338624.769491] XFS (dm-3): Unmounting Filesystem
[338624.825907] XFS (dm-3): Mounting V5 Filesystem
[338624.898474] XFS (dm-3): Ending clean mount
[338628.332795] XFS (dm-3): writeback error on sector 47226368
[338628.569190] XFS (dm-3): Unmounting Filesystem
[338628.599875] XFS (dm-3): Mounting V5 Filesystem
[338629.064760] XFS (dm-3): Starting recovery (logdev: internal)
[338629.112923] XFS (dm-3): Ending recovery (logdev: internal)
[338631.270534] XFS (dm-3): Unmounting Filesystem
[338631.303663] XFS (dm-3): Mounting V5 Filesystem
[338631.699104] XFS (dm-3): Starting recovery (logdev: internal)
[338631.748187] XFS (dm-3): Ending recovery (logdev: internal)
[338631.776481] XFS (dm-3): metadata I/O error: block 0x1e00c00 ("xlog_iodone") error 5 numblks 512
[338631.776484] XFS (dm-3): xfs_imap_lookup: xfs_ialloc_read_agi() returned error -5, agno 1
[338631.859983] XFS (dm-3): xfs_do_force_shutdown(0x2) called from line 1232 of file fs/xfs/xfs_log.c.  Return address = 0xffffffffa0310bfb
[338632.119665] XFS (dm-3): Unmounting Filesystem
[338632.148815] XFS (dm-3): Mounting V5 Filesystem
[338632.491701] XFS (dm-3): Starting recovery (logdev: internal)
[338632.528515] XFS (dm-3): Ending recovery (logdev: internal)
[338634.158276] XFS (dm-3): writeback error on sector 3995392
[338634.404761] XFS (dm-3): Unmounting Filesystem
[338634.434635] XFS (dm-3): Mounting V5 Filesystem
[338634.808965] XFS (dm-3): Starting recovery (logdev: internal)
[338634.847536] XFS (dm-3): Ending recovery (logdev: internal)
[338634.878409] XFS (dm-3): metadata I/O error: block 0x1e04200 ("xlog_iodone") error 5 numblks 512
[338634.918858] XFS (dm-3): xfs_do_force_shutdown(0x2) called from line 1232 of file fs/xfs/xfs_log.c.  Return address = 0xffffffffa0310bfb
[338635.189512] XFS (dm-3): Unmounting Filesystem
[338635.218422] XFS (dm-3): Mounting V5 Filesystem
[338635.352863] XFS (dm-3): Starting recovery (logdev: internal)
[338635.386813] XFS (dm-3): Ending recovery (logdev: internal)
[338635.679505] XFS (dm-3): Unmounting Filesystem
[338635.708240] XFS (dm-3): Mounting V5 Filesystem
[338635.851446] XFS (dm-3): Starting recovery (logdev: internal)
[338635.883376] XFS (dm-3): xfs_iread: validation failed for inode 1541
[338635.915291] ffffc9000e8f8a00: 49 4e a1 ff 03 02 00 00 00 00 00 00 00 00 00 00  IN..............
[338635.957069] ffffc9000e8f8a10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[338635.996627] ffffc9000e8f8a20: 59 e5 e5 84 02 a0 b6 a7 59 e5 e5 84 02 a0 b6 a7  Y.......Y.......
[338636.036735] ffffc9000e8f8a30: 59 e5 e5 84 02 a0 b6 a7 00 00 00 00 00 00 00 00  Y...............
[338636.076578] XFS (dm-3): Internal error xfs_iread at line 513 of file fs/xfs/libxfs/xfs_inode_buf.c.  Caller xfs_iget+0x43a/0x980 [xfs]
[338636.132678] CPU: 10 PID: 40643 Comm: mount Not tainted 4.14.0-rc2+ #8
[338636.163475] Hardware name: HP ProLiant DL380p Gen8, BIOS P70 08/02/2014
[338636.194553] Call Trace:
[338636.206731]  dump_stack+0x63/0x85
[338636.222813]  xfs_error_report+0x3b/0x40 [xfs]
[338636.243698]  ? xfs_iget+0x43a/0x980 [xfs]
[338636.262169]  xfs_corruption_error+0x55/0x80 [xfs]
[338636.283869]  xfs_iread+0x20c/0x2d0 [xfs]
[338636.301900]  ? xfs_iget+0x43a/0x980 [xfs]
[338636.320344]  xfs_iget+0x43a/0x980 [xfs]
[338636.338033]  xlog_recover_process_one_iunlink+0x52/0x240 [xfs]
[338636.364739]  ? up+0x32/0x4c
[338636.377773]  xlog_recover_process_iunlinks+0x9a/0xf0 [xfs]
[338636.404582]  xlog_recover_finish+0x39/0xb0 [xfs]
[338636.428050]  xfs_log_mount_finish+0x5f/0xc0 [xfs]
[338636.451561]  xfs_mountfs+0x754/0xa00 [xfs]
[338636.472295]  ? xfs_filestream_get_parent+0x80/0x80 [xfs]
[338636.496917]  xfs_fs_fill_super+0x41d/0x580 [xfs]
[338636.518205]  mount_bdev+0x184/0x1c0
[338636.534319]  ? xfs_finish_flags+0x140/0x140 [xfs]
[338636.555977]  xfs_fs_mount+0x15/0x20 [xfs]
[338636.574461]  mount_fs+0x39/0x150
[338636.589472]  vfs_kern_mount+0x67/0x130
[338636.606858]  do_mount+0x1f5/0xca0
[338636.622307]  SyS_mount+0x83/0xd0
[338636.637230]  do_syscall_64+0x67/0x1b0
[338636.654113]  entry_SYSCALL64_slow_path+0x25/0x25
[338636.675341] RIP: 0033:0x7f7b7e4d4aaa
[338636.693087] RSP: 002b:00007ffeb95996c8 EFLAGS: 00000202 ORIG_RAX: 00000000000000a5
[338636.727601] RAX: ffffffffffffffda RBX: 0000558b2614c080 RCX: 00007f7b7e4d4aaa
[338636.762029] RDX: 0000558b2614c2e0 RSI: 0000558b2614c340 RDI: 0000558b2614c300
[338636.794654] RBP: 0000000000000000 R08: 0000558b2614c280 R09: 0000000000000010
[338636.827444] R10: 00000000c0ed0000 R11: 0000000000000202 R12: 0000558b2614c300
[338636.859907] R13: 0000558b2614c2e0 R14: 0000558b24421380 R15: 0000558b2614c080
[338636.892460] XFS (dm-3): Corruption detected. Unmount and run xfs_repair
[338636.924378] XFS (dm-3): Ending recovery (logdev: internal)
[338636.955867] XFS (dm-3): xfs_iread: validation failed for inode 1541
[338636.956486] XFS (dm-3): writeback error on sector 43744
[338636.956506] XFS (dm-3): writeback error on sector 43776
[338636.956512] XFS (dm-3): writeback error on sector 43904
[338636.956517] XFS (dm-3): writeback error on sector 43928
[338636.956522] XFS (dm-3): writeback error on sector 43944
[338636.956527] XFS (dm-3): writeback error on sector 43960
[338636.979367] XFS (dm-3): xfs_imap_lookup: xfs_ialloc_read_agi() returned error -5, agno 0
....
....
