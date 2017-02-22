Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:38105 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934010AbdBVTNC (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 22 Feb 2017 14:13:02 -0500
Date: Wed, 22 Feb 2017 12:13:00 -0700
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: XFS kernel BUG during generic/270 with v4.10
Message-ID: <20170222191300.GA29474@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org

By running generic/270 in a loop on an XFS filesystem mounted with DAX I'm
able to reliably generate the following kernel bug after a few (~10)
iterations (output passed through kasan_symbolize.py):

run fstests generic/270 at 2017-02-22 12:01:05
XFS (pmem0p2): Unmounting Filesystem
XFS (pmem0p2): DAX enabled. Warning: EXPERIMENTAL, use at your own risk
XFS (pmem0p2): Mounting V5 Filesystem
XFS (pmem0p2): Ending clean mount
XFS (pmem0p2): Quotacheck needed: Please wait.
XFS (pmem0p2): Quotacheck: Done.
XFS (pmem0p2): xlog_verify_grant_tail: space > BBTOB(tail_blocks)
XFS: Assertion failed: XFS_FORCED_SHUTDOWN(ip->i_mount) || ip->i_delayed_blks == 0, file: fs/xfs/xfs_super.c, line: 965
------------[ cut here ]------------
kernel BUG at fs/xfs/xfs_message.c:113!
invalid opcode: 0000 [#1] PREEMPT SMP
Modules linked in: dax_pmem nd_pmem dax nd_btt nd_e820 libnvdimm
CPU: 0 PID: 15817 Comm: 270 Tainted: G        W       4.10.0 #1
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.10.1-0-g8891697-prebuilt.qemu-project.org 04/01/2014
task: ffff88050f988000 task.stack: ffffc9000393c000
RIP: 0010:assfail+0x20/0x30
RSP: 0018:ffffc9000393fb48 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff8800aac34ce0 RCX: 0000000000000000
RDX: 00000000ffffffc0 RSI: 000000000000000a RDI: ffffffff81ec6d80
RBP: ffffc9000393fb48 R08: 0000000000000000 R09: 0000000000000000
R10: 000000000000000a R11: f000000000000000 R12: ffff8800aac34a40
R13: ffffffff81c55100 R14: ffffffff81f1c2fb R15: 000000000000009e
FS:  00007f876cbf8b40(0000) GS:ffff880514800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055dc62780950 CR3: 000000050e587000 CR4: 00000000001406f0
Call Trace:
[<      none      >] xfs_fs_destroy_inode+0x283/0x350 fs/xfs/xfs_super.c:965
[<      none      >] destroy_inode+0x3b/0x60 fs/inode.c:264
[<      none      >] evict+0x139/0x1c0 fs/inode.c:570
[<      none      >] dispose_list+0x56/0x80 fs/inode.c:588
[<      none      >] prune_icache_sb+0x5a/0x80 fs/inode.c:775
[<      none      >] super_cache_scan+0x14e/0x1a0 fs/super.c:102
[<     inline     >] do_shrink_slab mm/vmscan.c:378
[<      none      >] shrink_slab.part.39+0x216/0x620 mm/vmscan.c:481
[<      none      >] shrink_slab+0x29/0x30 mm/vmscan.c:441
[<      none      >] drop_slab_node+0x31/0x60 mm/vmscan.c:499
[<      none      >] drop_slab+0x3f/0x70 mm/vmscan.c:510
[<      none      >] drop_caches_sysctl_handler+0x71/0xc0 fs/drop_caches.c:58
[<      none      >] proc_sys_call_handler+0xea/0x110 fs/proc/proc_sysctl.c:548
[<      none      >] proc_sys_write+0x14/0x20 fs/proc/proc_sysctl.c:566
[<      none      >] __vfs_write+0x37/0x160 fs/read_write.c:510
 ?[<      none      >] rcu_sync_lockdep_assert+0x12/0x60 kernel/rcu/sync.c:68
 ?[<     inline     >] percpu_down_read ./include/linux/percpu-rwsem.h:59
 ?[<      none      >] __sb_start_write+0x10d/0x220 fs/super.c:1291
 ?[<     inline     >] file_start_write ./include/linux/fs.h:2547
 ?[<      none      >] vfs_write+0x19b/0x1f0 fs/read_write.c:559
 ?[<      none      >] security_file_permission+0x3b/0xc0 security/security.c:776
[<      none      >] vfs_write+0xcb/0x1f0 fs/read_write.c:560
[<     inline     >] SYSC_write fs/read_write.c:607
[<      none      >] SyS_write+0x58/0xc0 fs/read_write.c:599
[<      none      >] entry_SYSCALL_64_fastpath+0x1f/0xc2 arch/x86/entry/entry_64.S:204
RIP: 0033:0x7f876c2e1c30
RSP: 002b:00007ffe6405c148 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 00007f876c5ab5e0 RCX: 00007f876c2e1c30
RDX: 0000000000000002 RSI: 000055dc62780950 RDI: 0000000000000001
RBP: 0000000000000001 R08: 00007f876c5ac740 R09: 00007f876cbf8b40
R10: 0000000000000073 R11: 0000000000000246 R12: 000055dc62976b90
R13: 0000000000000001 R14: 0000000000000000 R15: 0000000000000001
Code: 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 55 48 89 f1 41 89 d0 48 c7 c6 b8 09 f1 81 48 89 fa 31 ff 48 89 e5 e8 b0 f8 ff ff <0f> 0b 0f 1f 40 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00
RIP: assfail+0x20/0x30 RSP: ffffc9000393fb48
---[ end trace 384d06985052f068 ]---

Here's the xfstests run:

FSTYP         -- xfs (debug)
PLATFORM      -- Linux/x86_64 alara 4.10.0
MKFS_OPTIONS  -- -f -bsize=4096 /dev/pmem0p2
MOUNT_OPTIONS -- -o dax -o context=system_u:object_r:nfs_t:s0 /dev/pmem0p2 /mnt/xfstests_scratch

generic/270 24s ..../check: line 596: 15817 Segmentation fault      ./$seq > $tmp.rawout 2>&1
 [failed, exit status 139] - output mismatch (see /root/xfstests/results//generic/270.out.bad)
    --- tests/generic/270.out	2016-10-21 15:31:10.568945780 -0600
    +++ /root/xfstests/results//generic/270.out.bad	2017-02-22 12:01:29.272718284 -0700
    @@ -3,6 +3,3 @@
     Run fsstress
     
     Run dd writers in parallel
    -Comparing user usage
    -Comparing group usage
    -Comparing filesystem consistency
    ...
    (Run 'diff -u tests/generic/270.out /root/xfstests/results//generic/270.out.bad'  to see the entire diff)

This was done in my normal test setup, which is a pair of PMEM disks that
enable DAX.

Here are the versions of xfstests and xfsprogs that I'm using:

xfstets: f438604 generic: test mmap io through DAX and non-DAX

xfsprogs: xfs_admin version 4.9.0
This is just the xfsprogs that comes packaged with Fedora 25.

Thanks,
- Ross
