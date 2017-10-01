Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f47.google.com ([209.85.218.47]:43736 "EHLO
        mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751417AbdJAWKp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 1 Oct 2017 18:10:45 -0400
Received: by mail-oi0-f47.google.com with SMTP id c77so4484915oig.0
        for <linux-xfs@vger.kernel.org>; Sun, 01 Oct 2017 15:10:45 -0700 (PDT)
MIME-Version: 1.0
From: Sargun Dhillon <sargun@sargun.me>
Date: Sun, 1 Oct 2017 15:10:03 -0700
Message-ID: <CAMp4zn_YQy+Naggwfu5-aKigyx6rJJ27F7fdL=tRponn8Kug=A@mail.gmail.com>
Subject: XFS AIL lockup
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

I'm running into an issue where xfs aild is locking up. This is on
kernel version 4.9.34. It's an SMP system with 32 cores, and ~250G of
RAM (AWS R4.8XL) and an XFS filesystem with 1 SSD with project ID
quotas in use. It's the only XFS filesystem on the host. The root
partition is running EXT4, and isn't involved in this.

There are containers that use overlayfs atop this filesystem. It looks
like one of the processes (10090, or 11504) has gotten into a state
where it's holding a lock on a xfs_buf, and they're trying to lock
xfs_buf's which are currently on the xfs ail list.

xfs_info:
(root) ~ # xfs_info /mnt
meta-data=/dev/xvdb              isize=512    agcount=4, agsize=33554432 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1 spinodes=0 rmapbt=0
         =                       reflink=0
data     =                       bsize=4096   blocks=134217728, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
log      =internal               bsize=4096   blocks=65536, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

The stacks of the locked up processes are as follows:
(root) ~ # cat /proc/10090/stack
[<ffffffffad2d0981>] down+0x41/0x50
[<ffffffffc164051c>] xfs_buf_lock+0x3c/0xf0 [xfs]
[<ffffffffc1640735>] _xfs_buf_find+0x165/0x340 [xfs]
[<ffffffffc164093a>] xfs_buf_get_map+0x2a/0x280 [xfs]
[<ffffffffc16415bd>] xfs_buf_read_map+0x2d/0x180 [xfs]
[<ffffffffc1675f75>] xfs_trans_read_buf_map+0xf5/0x330 [xfs]
[<ffffffffc1625659>] xfs_read_agi+0x99/0x130 [xfs]
[<ffffffffc16530b2>] xfs_iunlink_remove+0x62/0x370 [xfs]
[<ffffffffc16571dc>] xfs_rename+0x7cc/0xb90 [xfs]
[<ffffffffc1651096>] xfs_vn_rename+0xd6/0x150 [xfs]
[<ffffffffad444268>] vfs_rename+0x758/0x980
[<ffffffffc01a8e17>] ovl_do_rename+0x37/0xa0 [overlay]
[<ffffffffc01a9e8b>] ovl_rename2+0x65b/0x720 [overlay]
[<ffffffffad444268>] vfs_rename+0x758/0x980
[<ffffffffad4487ef>] SyS_rename+0x39f/0x3c0
[<ffffffffad203b8b>] do_syscall_64+0x5b/0xc0
[<ffffffffada091ef>] entry_SYSCALL64_slow_path+0x25/0x25
[<ffffffffffffffff>] 0xffffffffffffffff

(root) ~ # cat /proc/1107/stack
[<ffffffffc1674894>] xfsaild+0xe4/0x730 [xfs]
[<ffffffffad2a5886>] kthread+0xe6/0x100
[<ffffffffada093b5>] ret_from_fork+0x25/0x30
[<ffffffffffffffff>] 0xffffffffffffffff

(root) ~ # cat /proc/11504/stack
[<ffffffffad2d0981>] down+0x41/0x50
[<ffffffffc164051c>] xfs_buf_lock+0x3c/0xf0 [xfs]
[<ffffffffc1640735>] _xfs_buf_find+0x165/0x340 [xfs]
[<ffffffffc164093a>] xfs_buf_get_map+0x2a/0x280 [xfs]
[<ffffffffc16415bd>] xfs_buf_read_map+0x2d/0x180 [xfs]
[<ffffffffc1675f75>] xfs_trans_read_buf_map+0xf5/0x330 [xfs]
[<ffffffffc15f1a36>] xfs_read_agf+0x96/0x120 [xfs]
[<ffffffffc15f1b09>] xfs_alloc_read_agf+0x49/0x140 [xfs]
[<ffffffffc15f1f5d>] xfs_alloc_fix_freelist+0x35d/0x3b0 [xfs]
[<ffffffffc15f22f4>] xfs_alloc_vextent+0x2e4/0x640 [xfs]
[<ffffffffc16243a8>] xfs_ialloc_ag_alloc+0x1a8/0x760 [xfs]
[<ffffffffc1626173>] xfs_dialloc+0x173/0x260 [xfs]
[<ffffffffc1652951>] xfs_ialloc+0x71/0x580 [xfs]
[<ffffffffc1654e53>] xfs_dir_ialloc+0x73/0x200 [xfs]
[<ffffffffc1655459>] xfs_create+0x479/0x720 [xfs]
[<ffffffffc16524b7>] xfs_generic_create+0x217/0x2f0 [xfs]
[<ffffffffc16525c4>] xfs_vn_mknod+0x14/0x20 [xfs]
[<ffffffffc1652603>] xfs_vn_create+0x13/0x20 [xfs]
[<ffffffffad442727>] vfs_create+0x127/0x190
[<ffffffffc01a932d>] ovl_create_real+0xad/0x230 [overlay]
[<ffffffffc01aa539>] ovl_create_or_link.part.5+0x119/0x6f0 [overlay]
[<ffffffffc01aac0a>] ovl_create_object+0xfa/0x110 [overlay]
[<ffffffffc01aacd3>] ovl_create+0x23/0x30 [overlay]
[<ffffffffad445808>] path_openat+0x1378/0x1440
[<ffffffffad446b91>] do_filp_open+0x91/0x100
[<ffffffffad433d74>] do_sys_open+0x124/0x210
[<ffffffffad433e7e>] SyS_open+0x1e/0x20
[<ffffffffad203b8b>] do_syscall_64+0x5b/0xc0
[<ffffffffada091ef>] entry_SYSCALL64_slow_path+0x25/0x25
[<ffffffffffffffff>] 0xffffffffffffffff

Looking at trace-cmd output, there is a constant loop of:
    xfsaild/xvdb-1107  [013] 406366.038489: xfs_buf_trylock_fail: dev
202:16 bno 0x10 nblks 0x8 hold 3 pincount 0 lock 0 flags
ASYNC|DONE|PAGES caller 0xffffffffc166994as
    xfsaild/xvdb-1107  [013] 406366.038489: xfs_ail_locked:       dev
202:16 lip 0x0xffff9f2aebdf2760 lsn 43/259079 type XFS_LI_BUF flags
IN_AIL
    xfsaild/xvdb-1107  [013] 406366.038490: xfs_buf_trylock_fail: dev
202:16 bno 0x1c19a90 nblks 0x8 hold 3 pincount 0 lock 0 flags
ASYNC|DONE|PAGES caller 0xffffffffc166994as
    xfsaild/xvdb-1107  [013] 406366.038490: xfs_ail_locked:       dev
202:16 lip 0x0xffff9f209b2351d0 lsn 43/259079 type XFS_LI_BUF flags
IN_AIL
    xfsaild/xvdb-1107  [013] 406366.038491: xfs_ilock_nowait:     dev
202:16 ino 0x3a25f27 flags ILOCK_SHARED caller 0xffffffffc166b953s
    xfsaild/xvdb-1107  [013] 406366.038492: xfs_ail_locked:       dev
202:16 lip 0x0xffff9f1ae93786e0 lsn 43/261714 type XFS_LI_INODE flags
IN_AIL
    xfsaild/xvdb-1107  [013] 406366.038492: xfs_buf_trylock_fail: dev
202:16 bno 0x8 nblks 0x8 hold 3 pincount 0 lock 0 flags
ASYNC|DONE|PAGES caller 0xffffffffc166994as
    xfsaild/xvdb-1107  [013] 406366.038492: xfs_ail_locked:       dev
202:16 lip 0x0xffff9f209b237390 lsn 43/261714 type XFS_LI_BUF flags
IN_AIL
    xfsaild/xvdb-1107  [013] 406366.038493: xfs_buf_trylock_fail: dev
202:16 bno 0x1 nblks 0x1 hold 5 pincount 0 lock 0 flags
ASYNC|DONE|KMEM caller 0xffffffffc166994as
    xfsaild/xvdb-1107  [013] 406366.038493: xfs_ail_locked:       dev
202:16 lip 0x0xffff9f209b2352c0 lsn 43/261714 type XFS_LI_BUF flags
IN_AIL
    xfsaild/xvdb-1107  [013] 406366.038494: xfs_ilock_nowait:     dev
202:16 ino 0x3a25f08 flags ILOCK_SHARED caller 0xffffffffc166b953s
    xfsaild/xvdb-1107  [013] 406366.038494: xfs_ail_locked:       dev
202:16 lip 0x0xffff9f10e249c0a0 lsn 43/261714 type XFS_LI_INODE flags
IN_AIL
    xfsaild/xvdb-1107  [013] 406366.038494: xfs_ilock_nowait:     dev
202:16 ino 0x3a25f3f flags ILOCK_SHARED caller 0xffffffffc166b953s
    xfsaild/xvdb-1107  [013] 406366.038495: xfs_ail_locked:       dev
202:16 lip 0x0xffff9f2224632b40 lsn 43/261769 type XFS_LI_INODE flags
IN_AIL
    xfsaild/xvdb-1107  [013] 406366.038495: xfs_buf_trylock_fail: dev
202:16 bno 0x2 nblks 0x1 hold 5 pincount 0 lock 0 flags
ASYNC|DONE|KMEM caller 0xffffffffc166994as
    xfsaild/xvdb-1107  [013] 406366.038496: xfs_ail_locked:       dev
202:16 lip 0x0xffff9f2208335e00 lsn 43/261769 type XFS_LI_BUF flags
IN_AIL
    xfsaild/xvdb-1107  [013] 406366.038496: xfs_ilock_nowait:     dev
202:16 ino 0x1385ab79 flags ILOCK_SHARED caller 0xffffffffc166b953s
    xfsaild/xvdb-1107  [013] 406366.038497: xfs_ail_locked:       dev
202:16 lip 0x0xffff9f1ae808c640 lsn 43/261769 type XFS_LI_INODE flags
IN_AIL
    xfsaild/xvdb-1107  [013] 406366.038497: xfs_buf_trylock_fail: dev
202:16 bno 0x138a6d68 nblks 0x8 hold 2 pincount 0 lock 0 flags
DONE|PAGES caller 0xffffffffc166994as
    xfsaild/xvdb-1107  [013] 406366.038498: xfs_ail_locked:       dev
202:16 lip 0x0xffff9f202b994f00 lsn 43/261769 type XFS_LI_BUF flags
IN_AIL
    xfsaild/xvdb-1107  [013] 406366.038498: xfs_ilock_nowait:     dev
202:16 ino 0x33c99f7a flags ILOCK_SHARED caller 0xffffffffc166b953s
    xfsaild/xvdb-1107  [013] 406366.038499: xfs_ail_locked:       dev
202:16 lip 0x0xffff9f10e8b59680 lsn 43/261769 type XFS_LI_INODE flags
IN_AIL
    xfsaild/xvdb-1107  [013] 406366.038542: xfs_ilock_nowait:     dev
202:16 ino 0x39b8f80 flags ILOCK_SHARED caller 0xffffffffc166b953s
    xfsaild/xvdb-1107  [013] 406366.038542: xfs_ail_locked:       dev
202:16 lip 0x0xffff9f30e5a23040 lsn 43/261888 type XFS_LI_INODE flags
IN_AIL
    xfsaild/xvdb-1107  [013] 406366.038543: xfs_ail_pinned:       dev
202:16 lip 0x0xffff9f1d31f8faf8 lsn 43/267138 type XFS_LI_EFI flags
IN_AIL
    xfsaild/xvdb-1107  [013] 406366.038544: xfs_ilock_nowait:     dev
202:16 ino 0x2f7d051 flags ILOCK_SHARED caller 0xffffffffc166b953s
    xfsaild/xvdb-1107  [013] 406366.038544: xfs_ail_locked:       dev
202:16 lip 0x0xffff9f24fd7c6be0 lsn 43/267138 type XFS_LI_INODE flags
IN_AIL
    xfsaild/xvdb-1107  [013] 406366.062468: xfs_log_force:        dev
202:16 lsn 0x0 caller 0xffffffffc167493cs
    xfsaild/xvdb-1107  [013] 406366.062484: xfs_buf_trylock_fail: dev
202:16 bno 0x10 nblks 0x8 hold 3 pincount 0 lock 0 flags
ASYNC|DONE|PAGES caller 0xffffffffc166994as
    xfsaild/xvdb-1107  [013] 406366.062484: xfs_ail_locked:       dev
202:16 lip 0x0xffff9f2aebdf2760 lsn 43/259079 type XFS_LI_BUF flags
IN_AIL
    xfsaild/xvdb-1107  [013] 406366.062485: xfs_buf_trylock_fail: dev
202:16 bno 0x1c19a90 nblks 0x8 hold 3 pincount 0 lock 0 flags
ASYNC|DONE|PAGES caller 0xffffffffc166994as
    xfsaild/xvdb-1107  [013] 406366.062486: xfs_ail_locked:       dev
202:16 lip 0x0xffff9f209b2351d0 lsn 43/259079 type XFS_LI_BUF flags
IN_AIL
    xfsaild/xvdb-1107  [013] 406366.062487: xfs_ilock_nowait:     dev
202:16 ino 0x3a25f27 flags ILOCK_SHARED caller 0xffffffffc166b953s
    xfsaild/xvdb-1107  [013] 406366.062487: xfs_ail_locked:       dev
202:16 lip 0x0xffff9f1ae93786e0 lsn 43/261714 type XFS_LI_INODE flags
IN_AIL
    xfsaild/xvdb-1107  [013] 406366.062488: xfs_buf_trylock_fail: dev
202:16 bno 0x8 nblks 0x8 hold 3 pincount 0 lock 0 flags
ASYNC|DONE|PAGES caller 0xffffffffc166994as
    xfsaild/xvdb-1107  [013] 406366.062488: xfs_ail_locked:       dev
202:16 lip 0x0xffff9f209b237390 lsn 43/261714 type XFS_LI_BUF flags
IN_AIL
    xfsaild/xvdb-1107  [013] 406366.062489: xfs_buf_trylock_fail: dev
202:16 bno 0x1 nblks 0x1 hold 5 pincount 0 lock 0 flags
ASYNC|DONE|KMEM caller 0xffffffffc166994as
    xfsaild/xvdb-1107  [013] 406366.062489: xfs_ail_locked:       dev
202:16 lip 0x0xffff9f209b2352c0 lsn 43/261714 type XFS_LI_BUF flags
IN_AIL
    xfsaild/xvdb-1107  [013] 406366.062490: xfs_ilock_nowait:     dev
202:16 ino 0x3a25f08 flags ILOCK_SHARED caller 0xffffffffc166b953s
    xfsaild/xvdb-1107  [013] 406366.062490: xfs_ail_locked:       dev
202:16 lip 0x0xffff9f10e249c0a0 lsn 43/261714 type XFS_LI_INODE flags
IN_AIL
    xfsaild/xvdb-1107  [013] 406366.062490: xfs_ilock_nowait:     dev
202:16 ino 0x3a25f3f flags ILOCK_SHARED caller 0xffffffffc166b953s
    xfsaild/xvdb-1107  [013] 406366.062491: xfs_ail_locked:       dev
202:16 lip 0x0xffff9f2224632b40 lsn 43/261769 type XFS_LI_INODE flags
IN_AIL
    xfsaild/xvdb-1107  [013] 406366.062491: xfs_buf_trylock_fail: dev
202:16 bno 0x2 nblks 0x1 hold 5 pincount 0 lock 0 flags
ASYNC|DONE|KMEM caller 0xffffffffc166994as
    xfsaild/xvdb-1107  [013] 406366.062492: xfs_ail_locked:       dev
202:16 lip 0x0xffff9f2208335e00 lsn 43/261769 type XFS_LI_BUF flags
IN_AIL
    xfsaild/xvdb-1107  [013] 406366.062492: xfs_ilock_nowait:     dev
202:16 ino 0x1385ab79 flags ILOCK_SHARED caller 0xffffffffc166b953s
    xfsaild/xvdb-1107  [013] 406366.062493: xfs_ail_locked:       dev
202:16 lip 0x0xffff9f1ae808c640 lsn 43/261769 type XFS_LI_INODE flags
IN_AIL
    xfsaild/xvdb-1107  [013] 406366.062493: xfs_buf_trylock_fail: dev
202:16 bno 0x138a6d68 nblks 0x8 hold 2 pincount 0 lock 0 flags
DONE|PAGES caller 0xffffffffc166994as
    xfsaild/xvdb-1107  [013] 406366.062494: xfs_ail_locked:       dev
202:16 lip 0x0xffff9f202b994f00 lsn 43/261769 type XFS_LI_BUF flags
IN_AIL
    xfsaild/xvdb-1107  [013] 406366.062494: xfs_ilock_nowait:     dev
202:16 ino 0x33c99f7a flags ILOCK_SHARED caller 0xffffffffc166b953s
    xfsaild/xvdb-1107  [013] 406366.062494: xfs_ail_locked:       dev
202:16 lip 0x0xffff9f10e8b59680 lsn 43/261769 type XFS_LI_INODE flags
IN_AIL
    xfsaild/xvdb-1107  [013] 406366.062495: xfs_ilock_nowait:     dev
202:16 ino 0x39b8f80 flags ILOCK_SHARED caller 0xffffffffc166b953s
    xfsaild/xvdb-1107  [013] 406366.062495: xfs_ail_locked:       dev
202:16 lip 0x0xffff9f30e5a23040 lsn 43/261888 type XFS_LI_INODE flags
IN_AIL
    xfsaild/xvdb-1107  [013] 406366.062496: xfs_ail_pinned:       dev
202:16 lip 0x0xffff9f1d31f8faf8 lsn 43/267138 type XFS_LI_EFI flags
IN_AIL
    xfsaild/xvdb-1107  [013] 406366.062496: xfs_ilock_nowait:     dev
202:16 ino 0x2f7d051 flags ILOCK_SHARED caller 0xffffffffc166b953s
    xfsaild/xvdb-1107  [013] 406366.062497: xfs_ail_locked:       dev
202:16 lip 0x0xffff9f24fd7c6be0 lsn 43/267138 type XFS_LI_INODE flags
IN_AIL
