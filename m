Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:9729 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751773AbdJAWtH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 1 Oct 2017 18:49:07 -0400
Date: Mon, 2 Oct 2017 09:49:04 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS AIL lockup
Message-ID: <20171001224904.GG3666@dastard>
References: <CAMp4zn_YQy+Naggwfu5-aKigyx6rJJ27F7fdL=tRponn8Kug=A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMp4zn_YQy+Naggwfu5-aKigyx6rJJ27F7fdL=tRponn8Kug=A@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Sargun Dhillon <sargun@sargun.me>
Cc: linux-xfs@vger.kernel.org

On Sun, Oct 01, 2017 at 03:10:03PM -0700, Sargun Dhillon wrote:
> I'm running into an issue where xfs aild is locking up. This is on
> kernel version 4.9.34. It's an SMP system with 32 cores, and ~250G of
> RAM (AWS R4.8XL) and an XFS filesystem with 1 SSD with project ID
> quotas in use. It's the only XFS filesystem on the host. The root
> partition is running EXT4, and isn't involved in this.
> 
> There are containers that use overlayfs atop this filesystem. It looks
> like one of the processes (10090, or 11504) has gotten into a state
> where it's holding a lock on a xfs_buf, and they're trying to lock
> xfs_buf's which are currently on the xfs ail list.
> 
> xfs_info:
> (root) ~ # xfs_info /mnt
> meta-data=/dev/xvdb              isize=512    agcount=4, agsize=33554432 blks
>          =                       sectsz=512   attr=2, projid32bit=1
>          =                       crc=1        finobt=1 spinodes=0 rmapbt=0
>          =                       reflink=0
> data     =                       bsize=4096   blocks=134217728, imaxpct=25
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
> log      =internal               bsize=4096   blocks=65536, version=2
>          =                       sectsz=512   sunit=0 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> 
> The stacks of the locked up processes are as follows:
> (root) ~ # cat /proc/10090/stack
> [<ffffffffad2d0981>] down+0x41/0x50
> [<ffffffffc164051c>] xfs_buf_lock+0x3c/0xf0 [xfs]
> [<ffffffffc1640735>] _xfs_buf_find+0x165/0x340 [xfs]
> [<ffffffffc164093a>] xfs_buf_get_map+0x2a/0x280 [xfs]
> [<ffffffffc16415bd>] xfs_buf_read_map+0x2d/0x180 [xfs]
> [<ffffffffc1675f75>] xfs_trans_read_buf_map+0xf5/0x330 [xfs]
> [<ffffffffc1625659>] xfs_read_agi+0x99/0x130 [xfs]
> [<ffffffffc16530b2>] xfs_iunlink_remove+0x62/0x370 [xfs]
> [<ffffffffc16571dc>] xfs_rename+0x7cc/0xb90 [xfs]
> [<ffffffffc1651096>] xfs_vn_rename+0xd6/0x150 [xfs]
> [<ffffffffad444268>] vfs_rename+0x758/0x980
> [<ffffffffc01a8e17>] ovl_do_rename+0x37/0xa0 [overlay]
> [<ffffffffc01a9e8b>] ovl_rename2+0x65b/0x720 [overlay]
> [<ffffffffad444268>] vfs_rename+0x758/0x980
> [<ffffffffad4487ef>] SyS_rename+0x39f/0x3c0
> [<ffffffffad203b8b>] do_syscall_64+0x5b/0xc0
> [<ffffffffada091ef>] entry_SYSCALL64_slow_path+0x25/0x25
> [<ffffffffffffffff>] 0xffffffffffffffff

Ok, this is a RENAME_WHITEOUT case, and that points to the issue.
The whiteout inode is allocated as a temporary inode, which means
it remains on the unlinked list so that if we crash part way through
the update log recovery will free it again.

Once all the dirent updates and other rename work is done, we remove
the whiteout inode from the unlinked list, and that requires
grabbing the AGI lock. That's what we are stuck on here.

> (root) ~ # cat /proc/1107/stack
> [<ffffffffc1674894>] xfsaild+0xe4/0x730 [xfs]
> [<ffffffffad2a5886>] kthread+0xe6/0x100
> [<ffffffffada093b5>] ret_from_fork+0x25/0x30
> [<ffffffffffffffff>] 0xffffffffffffffff

The AIL and it's behaviour is irrelevant here.

> (root) ~ # cat /proc/11504/stack
> [<ffffffffad2d0981>] down+0x41/0x50
> [<ffffffffc164051c>] xfs_buf_lock+0x3c/0xf0 [xfs]
> [<ffffffffc1640735>] _xfs_buf_find+0x165/0x340 [xfs]
> [<ffffffffc164093a>] xfs_buf_get_map+0x2a/0x280 [xfs]
> [<ffffffffc16415bd>] xfs_buf_read_map+0x2d/0x180 [xfs]
> [<ffffffffc1675f75>] xfs_trans_read_buf_map+0xf5/0x330 [xfs]
> [<ffffffffc15f1a36>] xfs_read_agf+0x96/0x120 [xfs]
> [<ffffffffc15f1b09>] xfs_alloc_read_agf+0x49/0x140 [xfs]
> [<ffffffffc15f1f5d>] xfs_alloc_fix_freelist+0x35d/0x3b0 [xfs]
> [<ffffffffc15f22f4>] xfs_alloc_vextent+0x2e4/0x640 [xfs]
> [<ffffffffc16243a8>] xfs_ialloc_ag_alloc+0x1a8/0x760 [xfs]
> [<ffffffffc1626173>] xfs_dialloc+0x173/0x260 [xfs]
> [<ffffffffc1652951>] xfs_ialloc+0x71/0x580 [xfs]
> [<ffffffffc1654e53>] xfs_dir_ialloc+0x73/0x200 [xfs]
> [<ffffffffc1655459>] xfs_create+0x479/0x720 [xfs]
> [<ffffffffc16524b7>] xfs_generic_create+0x217/0x2f0 [xfs]
> [<ffffffffc16525c4>] xfs_vn_mknod+0x14/0x20 [xfs]
> [<ffffffffc1652603>] xfs_vn_create+0x13/0x20 [xfs]
> [<ffffffffad442727>] vfs_create+0x127/0x190
> [<ffffffffc01a932d>] ovl_create_real+0xad/0x230 [overlay]
> [<ffffffffc01aa539>] ovl_create_or_link.part.5+0x119/0x6f0 [overlay]
> [<ffffffffc01aac0a>] ovl_create_object+0xfa/0x110 [overlay]
> [<ffffffffc01aacd3>] ovl_create+0x23/0x30 [overlay]
> [<ffffffffad445808>] path_openat+0x1378/0x1440
> [<ffffffffad446b91>] do_filp_open+0x91/0x100
> [<ffffffffad433d74>] do_sys_open+0x124/0x210
> [<ffffffffad433e7e>] SyS_open+0x1e/0x20
> [<ffffffffad203b8b>] do_syscall_64+0x5b/0xc0
> [<ffffffffada091ef>] entry_SYSCALL64_slow_path+0x25/0x25
> [<ffffffffffffffff>] 0xffffffffffffffff

Because this is the deadlock - we're trying to lock the AGF with an
AGI already locked. That means the above RENAME_WHITEOUT has either
allocated or freed extents in manipulating the dirents during
rename, and so holds an AGF locked. It's a classic ABBA deadlock.

That's the problem, not sure what the solution is yet - there's no
obvious or simple way around this RENAME_WHITEOUT behaviour (which
only affects overlay, fwiw). I'll have a think about it.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
