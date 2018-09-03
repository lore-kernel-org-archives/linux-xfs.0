Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:22131 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725866AbeIDCnd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Sep 2018 22:43:33 -0400
Received: from dave by dastard with local (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1fwxDi-0001OF-Fz
        for linux-xfs@vger.kernel.org; Tue, 04 Sep 2018 08:21:18 +1000
Date: Tue, 4 Sep 2018 08:21:18 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: 4.19-rc2 test failures
Message-ID: <20180903222118.GQ5631@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi folks,

Just wondering if anyone else is seeing these (or similar) failures
from fstests on the current 4.19-rc2 tree?

This is occurring during umount of a shutdown filesystem in generic/388:

[ 6614.655308] XFS (sdg): Mounting V5 Filesystem
[ 6614.968513] XFS (sdg): Starting recovery (logdev: internal)
[ 6615.234728] XFS (sdg): Ending recovery (logdev: internal)
[ 6616.252785] XFS (sdg): writeback error on sector 241320
[ 6616.255535] XFS (sdg): writeback error on sector 10677464
[ 6616.332337] XFS (sdg): Unmounting Filesystem
[ 6616.333862] XFS: Assertion failed: ip->i_d.di_format != XFS_DINODE_FMT_BTREE || ip->i_d.di_nextents > XFS_IFORK_MAXEXT(ip, XFS_DATA_FORK), file: fs/xfs/xfs_inode.c, line: 3328
[ 6616.338770] ------------[ cut here ]------------
[ 6616.340351] kernel BUG at fs/xfs/xfs_message.c:102!
[ 6616.341924] invalid opcode: 0000 [#1] PREEMPT SMP
[ 6616.343307] CPU: 1 PID: 28057 Comm: xfsaild/sdg Tainted: G        W         4.19.0-rc2-dgc+ #654
[ 6616.345172] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.11.1-1 04/01/2014
[ 6616.346745] RIP: 0010:assfail+0x28/0x30
[ 6616.347478] Code: c3 90 0f 1f 44 00 00 48 89 f1 41 89 d0 48 c7 c6 80 4b 2e 82 48 89 fa 31 ff e8 64 f9 ff ff 80 3d 45 9f 0a 01 00 75 03 0f 0b c3 <0f> 0b 66 0f 1f 44 00 00 0f 1f 44 00 00 48 63 f6 49 89 f9 6a 01 ba
[ 6616.350973] RSP: 0018:ffffc90001357dd8 EFLAGS: 00010202
[ 6616.351963] RAX: 0000000000000000 RBX: ffff880136fa0980 RCX: 0000000000000000
[ 6616.353316] RDX: 00000000ffffffc0 RSI: 000000000000000a RDI: ffffffff8227a104
[ 6616.354662] RBP: ffff880125074000 R08: 0000000000000000 R09: 0000000000000000
[ 6616.356002] R10: 0000000000000000 R11: f000000000000000 R12: ffffc90001357e28
[ 6616.357352] R13: ffff880136fa0a90 R14: 0000000000000080 R15: ffff880125074000
[ 6616.358692] FS:  0000000000000000(0000) GS:ffff88013fc80000(0000) knlGS:0000000000000000
[ 6616.360215] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 6616.361318] CR2: 00007fa2e4031018 CR3: 000000013281e000 CR4: 00000000000006e0
[ 6616.362666] Call Trace:
[ 6616.363755]  xfs_iflush+0x2c7/0x3a0
[ 6616.364439]  xfs_inode_item_push+0x12e/0x1e0
[ 6616.365268]  xfsaild+0x2d4/0x8b0
[ 6616.365892]  ? xfs_trans_ail_cursor_first+0x80/0x80
[ 6616.366819]  ? kthread+0x11c/0x140
[ 6616.367472]  kthread+0x11c/0x140
[ 6616.368097]  ? __kthread_bind_mask+0x60/0x60
[ 6616.368913]  ret_from_fork+0x24/0x30
[ 6616.369805] ---[ end trace 4b87f65a18fba704 ]---

No idea what is causing this yet - there have been several rounds of
shutdown and recovery before this is tripped over so it may be
another layer of the onion that generic/388 has exposed.

This is happening in xfs/442:

[14572.638804] run fstests xfs/442 at 2018-09-03 19:49:06
[14572.814258] XFS (sdb): Mounting V5 Filesystem
[14573.056531] XFS (sdb): Ending clean mount
[14573.212267] XFS (sdc): Unmounting Filesystem
[14573.534014] XFS (sdc): Mounting V5 Filesystem
[14573.568078] XFS (sdc): Ending clean mount
[14573.613221] XFS (sdc): Unmounting Filesystem
[14573.937133] XFS (sdc): Mounting V5 Filesystem
[14573.971403] XFS (sdc): Ending clean mount
[14573.973531] XFS (sdc): Quotacheck needed: Please wait.
[14573.994509] XFS (sdc): Quotacheck: Done.
[15145.646818] XFS: Assertion failed: XFS_FORCED_SHUTDOWN(ip->i_mount) || ip->i_delayed_blks == 0, file: fs/xfs/xfs_super.c, line: 954
[15145.649191] ------------[ cut here ]------------
[15145.650077] kernel BUG at fs/xfs/xfs_message.c:102!
[15145.652238] invalid opcode: 0000 [#1] PREEMPT SMP
[15145.653151] CPU: 0 PID: 22526 Comm: umount Tainted: G        W         4.19.0-rc2-dgc+ #654
[15145.654711] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.11.1-1 04/01/2014
[15145.656273] RIP: 0010:assfail+0x28/0x30
[15145.656993] Code: c3 90 0f 1f 44 00 00 48 89 f1 41 89 d0 48 c7 c6 80 4b 2e 82 48 89 fa 31 ff e8 64 f9 ff ff 80 3d 45 9f 0a 01 00 75 03 0f 0b c3 <0f> 0b 66 0f 1f 44 00 00 0f 1f 44 00 00 48 63 f6 49 8a
[15145.660446] RSP: 0018:ffffc900012f3de8 EFLAGS: 00010202
[15145.661435] RAX: 0000000000000000 RBX: ffff88001044ac50 RCX: 0000000000000000
[15145.662863] RDX: 00000000ffffffc0 RSI: 000000000000000a RDI: ffffffff8227a104
[15145.664218] RBP: ffff88001044aac0 R08: 0000000000000000 R09: 0000000000000000
[15145.665561] R10: 0000000000013fc1 R11: f000000000000000 R12: ffff88001044ac50
[15145.666892] R13: ffffffff822f64fc R14: ffff880035494d60 R15: ffff880037f86210
[15145.668229] FS:  00007fbaa2c28fc0(0000) GS:ffff88003ec00000(0000) knlGS:0000000000000000
[15145.669727] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[15145.670803] CR2: 0000562fd1c65078 CR3: 0000000032ccc000 CR4: 00000000000006f0
[15145.672139] Call Trace:
[15145.672626]  xfs_fs_destroy_inode+0x1dd/0x230
[15145.673459]  dispose_list+0x51/0x80
[15145.674131]  evict_inodes+0x15b/0x1b0
[15145.674828]  generic_shutdown_super+0x3a/0x110
[15145.675671]  kill_block_super+0x21/0x50
[15145.676416]  deactivate_locked_super+0x39/0x70
[15145.677262]  cleanup_mnt+0x3b/0x80
[15145.677916]  task_work_run+0x82/0xb0
[15145.678596]  exit_to_usermode_loop+0xd3/0xe0
[15145.679404]  do_syscall_64+0x170/0x180
[15145.680131]  entry_SYSCALL_64_after_hwframe+0x49/0xbe

Weirdly, this appears to be an unmount finishing off, but
there's no log message on the console that says the filesystem is
unmounting. How does that happen?

I'm currently trying to reproduce them to debug, but neither seem to
be easy to reproduce.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
