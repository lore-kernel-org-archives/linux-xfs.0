Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:37903 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725782AbeICJ7i (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Sep 2018 05:59:38 -0400
Date: Mon, 3 Sep 2018 15:41:00 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v8 00/28] Parent Pointers v8
Message-ID: <20180903054100.GP5631@dastard>
References: <1535484161-11059-1-git-send-email-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1535484161-11059-1-git-send-email-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Allison Henderson <allison.henderson@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Aug 28, 2018 at 12:22:13PM -0700, Allison Henderson wrote:
> Hi all,
> 
> This is the 8th version of parent pointer attributes for xfs. The goal of
> this patch set is to add a parent pointer attribute to each inode.  The
> attribute name containing the parent inode, generation, and directory offset,
> while the  attribute value contains the file name.  This feature will enable
> future optimizations for online scrub, or any other feature that could make
> use of quickly deriving an inodes path from  the mount point.  This set also
> introduces deferred attribute operations, though it is currently only used by
>  the new parent pointer code.

Another assert failure on generic/026:

SECTION       -- xfs
FSTYP         -- xfs (debug)
PLATFORM      -- Linux/x86_64 test1 4.19.0-rc2-dgc+
MKFS_OPTIONS  -- -f -m rmapbt=1,reflink=1 -i sparse=1 -b size=1k /dev/sdc
MOUNT_OPTIONS -- /dev/sdc /mnt/scratch

(though it appears block size has nothing to do with the failure as
all my other test VMs also failed on this test, too)


[  368.699416] run fstests generic/026 at 2018-09-03 13:46:29
[  376.651705] XFS: Assertion failed: tp->t_ticket != NULL, file: fs/xfs/xfs_trans.c, line: 952
[  376.653346] ------------[ cut here ]------------
[  376.654174] kernel BUG at fs/xfs/xfs_message.c:102!
[  376.655537] invalid opcode: 0000 [#1] PREEMPT SMP
[  376.656545] CPU: 0 PID: 12468 Comm: chacl Not tainted 4.19.0-rc2-dgc+ #653
[  376.657742] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.11.1-1 04/01/2014
[  376.659193] RIP: 0010:assfail+0x28/0x30
[  376.659861] Code: c3 90 0f 1f 44 00 00 48 89 f1 41 89 d0 48 c7 c6 98 50 2e 82 48 89 fa 31 ff e8 64 f9 ff ff 80 3d f5 9a 0a 01 00 75 03 0f 0b c3 <0f> 0b 66 0f 1f 44 00 00 0f 1f 44 00 00 48 63 f6 49 8a
[  376.663050] RSP: 0018:ffffc90000babaa0 EFLAGS: 00010202
[  376.663950] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
[  376.665167] RDX: 00000000ffffffc0 RSI: 000000000000000a RDI: ffffffff8227a5fc
[  376.666397] RBP: ffffffff822e68d0 R08: 0000000000000000 R09: 0000000000000000
[  376.667618] R10: 0000000000000008 R11: f000000000000000 R12: 0000000000000000
[  376.668841] R13: ffff88002d236000 R14: ffffffff814d6701 R15: 0000000000000025
[  376.670075] FS:  00007fd8e35dc740(0000) GS:ffff88003ec00000(0000) knlGS:0000000000000000
[  376.671462] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  376.672451] CR2: 000055624ed0c000 CR3: 00000000292b5000 CR4: 00000000000006f0
[  376.673678] Call Trace:
[  376.674136]  __xfs_trans_commit+0x35c/0x370
[  376.674870]  xfs_attr_set+0x241/0x2d0
[  376.675510]  __xfs_set_acl+0xf4/0x1a0
[  376.676146]  xfs_set_acl+0xa8/0x100
[  376.676759]  ? posix_acl_valid+0xb6/0xd0
[  376.677444]  ? set_posix_acl+0xa0/0xa0
[  376.678108]  posix_acl_xattr_set+0x3f/0x90
[  376.678833]  __vfs_setxattr+0x64/0x80
[  376.679484]  __vfs_setxattr_noperm+0x69/0x1a0
[  376.680243]  ? unlazy_walk+0x4c/0xb0
[  376.680871]  vfs_setxattr+0xa0/0xb0
[  376.681485]  setxattr+0x132/0x1a0
[  376.682088]  ? __handle_mm_fault+0x95b/0x10c0
[  376.682850]  ? __mnt_want_write+0x5e/0x90
[  376.683547]  ? preempt_count_sub+0x43/0x50
[  376.684262]  path_setxattr+0xbe/0xe0
[  376.684884]  __x64_sys_setxattr+0x27/0x30
[  376.685584]  do_syscall_64+0x5a/0x180
[  376.686236]  entry_SYSCALL_64_after_hwframe+0x49/0xbe

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
