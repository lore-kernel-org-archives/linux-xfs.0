Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:60792 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725927AbeLXHQl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Dec 2018 02:16:41 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id CFE7728E77
        for <linux-xfs@vger.kernel.org>; Mon, 24 Dec 2018 07:16:40 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 202053] New: [xfstests generic/464]: XFS corruption and
 Assertion failed: 0, file: fs/xfs/xfs_super.c, line: 985
Date: Mon, 24 Dec 2018 07:16:40 +0000
Message-ID: <bug-202053-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=202053

            Bug ID: 202053
           Summary: [xfstests generic/464]: XFS corruption and Assertion
                    failed: 0, file: fs/xfs/xfs_super.c, line: 985
           Product: File System
           Version: 2.5
    Kernel Version: 4.20-rc6 with xfs-4.21-merge-2
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: XFS
          Assignee: filesystem_xfs@kernel-bugs.kernel.org
          Reporter: zlang@redhat.com
        Regression: No

generic/464 reproduced a xfs corruption:

# while true; do generic/464|break;done
...
...
FSTYP         -- xfs (non-debug)
PLATFORM      -- Linux/x86_64 ibm-x3650m4-10 4.20.0-rc6
MKFS_OPTIONS  -- -f -m reflink=1,rmapbt=1,finobt=1,crc=1 -i sparse=1
/dev/mapper/rhel_ibm--x3650m4--10-xfscratch
MOUNT_OPTIONS -- -o context=system_u:object_r:root_t:s0
/dev/mapper/rhel_ibm--x3650m4--10-xfscratch /mnt/scratch

generic/464 80s ... [failed, exit status 1]- output mismatch (see
/home/git/xfstests-dev/results//generic/464.out.bad)
    --- tests/generic/464.out   2018-11-25 23:54:50.485528602 -0500
    +++ /home/git/xfstests-dev/results//generic/464.out.bad     2018-12-24
01:47:45.633426963 -0500
    @@ -1,2 +1,3 @@
     QA output created by 464
    -Silence is golden
    +_check_xfs_filesystem: filesystem on
/dev/mapper/rhel_ibm--x3650m4--10-xfscratch is inconsistent (r)
    +(see /home/git/xfstests-dev/results//generic/464.full for details)
    ...
    (Run 'diff -u /home/git/xfstests-dev/tests/generic/464.out
/home/git/xfstests-dev/results//generic/464.out.bad'  to see the entire diff)
Ran: generic/464
Failures: generic/464
Failed 1 of 1 tests

# xfs_repair -n /dev/mapper/rhel_ibm--x3650m4--10-xfscratch
Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - zero log...
        - scan filesystem freespace and inode maps...
sb_fdblocks 22130881, counted 22130887
        - found root inode chunk
Phase 3 - for each AG...
        - scan (but don't clear) agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno = 0
        - agno = 1
        - agno = 2
        - agno = 3
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - check for inodes claiming duplicate blocks...
        - agno = 0
        - agno = 2
        - agno = 1
        - agno = 3
No modify flag set, skipping phase 5
Phase 6 - check inode connectivity...
        - traversing filesystem ...
        - traversal finished ...
        - moving disconnected inodes to lost+found ...
Phase 7 - verify link counts...
No modify flag set, skipping filesystem flush and exiting.

# dmesg
[ 2121.041622] run fstests generic/464 at 2018-12-24 01:47:12
[ 2121.967789] XFS (dm-5): Unmounting Filesystem
[ 2123.883676] XFS (dm-5): Mounting V5 Filesystem
[ 2124.004010] XFS (dm-5): Ending clean mount
[ 2130.837461] XFS (dm-5): Unmounting Filesystem
[ 2131.542125] XFS (dm-5): Mounting V5 Filesystem
[ 2131.604660] XFS (dm-5): Ending clean mount
[ 2138.112176] XFS (dm-5): Unmounting Filesystem
[ 2138.825792] XFS (dm-5): Mounting V5 Filesystem
[ 2138.912444] XFS (dm-5): Ending clean mount
[ 2145.256700] XFS (dm-5): Unmounting Filesystem
[ 2145.995742] XFS (dm-5): Mounting V5 Filesystem
[ 2146.106208] XFS (dm-5): Ending clean mount
[ 2152.590844] XFS: Assertion failed: 0, file: fs/xfs/xfs_super.c, line: 985
[ 2152.598602] WARNING: CPU: 22 PID: 7791 at fs/xfs/xfs_message.c:93
asswarn+0x1c/0x1f [xfs]
[ 2152.607732] Modules linked in: sunrpc intel_rapl sb_edac
x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm irqbypass
crct10dif_pclmul crc32_pclmul ipmi_ssif ghash_clmulni_intel
intel_cstate iTCO_wdt iTCO_vendor_support intel_uncore ipmi_si ioatdma
intel_rapl_perf sg pcspkr ipmi_devintf i2c_i801 lpc_ich ipmi_msghandler xfs
libcrc32c sd_mod mgag200 drm_kms_helper sysc
opyarea wmi sysfillrect sysimgblt fb_sys_fops ttm igb dca drm crc32c_intel
megaraid_sas i2c_algo_bit rndis_host cdc_ether usbnet mii dm_mirror
dm_region_hash dm_log dm_mod
[ 2152.661611] CPU: 22 PID: 7791 Comm: umount Not tainted 4.20.0-rc6 #4
[ 2152.668706] Hardware name: IBM System x3650 M4 -[7915ON3]-/00J6520, BIOS
-[VVE124AUS-1.30]- 11/21/2012
[ 2152.679152] RIP: 0010:asswarn+0x1c/0x1f [xfs]
[ 2152.684018] Code: 00 00 00 5b 41 5c 41 5d 41 5e 41 5f 5d c3 66 66 66 66 90
48 89 f1 41 89 d0 48 c7 c6 00 bf ec c0 48 89 fa 31 ff e8 06 fa ff ff <0f> 0b c3
66 66 66 66 90 48 89 f1 41 89 d0 48 c7 c6 00 bf ec c0 48
[ 2152.704976] RSP: 0018:ffff88845bedfc70 EFLAGS: 00010286
[ 2152.710811] RAX: 0000000000000000 RBX: ffff8881c418e0c0 RCX:
0000000000000000
[ 2152.718776] RDX: dffffc0000000000 RSI: 000000000000000a RDI:
ffffed108b7dbf80
[ 2152.726742] RBP: ffff88845d701100 R08: ffffed108ef3cf91 R09:
ffffed108ef3cf90
[ 2152.734707] R10: ffffed108ef3cf90 R11: ffff8884779e7c87 R12:
ffff8881c418de40
[ 2152.742672] R13: 0000000000000016 R14: ffffffffc0fc0000 R15:
0000000000000016
[ 2152.750631] FS:  00007f3aef255080(0000) GS:ffff888477800000(0000)
knlGS:0000000000000000
[ 2152.759662] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 2152.766076] CR2: 0000564c78b672e8 CR3: 000000046771c002 CR4:
00000000000606e0
[ 2152.774042] Call Trace:
[ 2152.776829]  xfs_fs_destroy_inode+0x584/0x8e0 [xfs]
[ 2152.782286]  dispose_list+0xfa/0x1d0
[ 2152.786284]  evict_inodes+0x29e/0x390
[ 2152.790378]  ? dispose_list+0x1d0/0x1d0
[ 2152.794673]  generic_shutdown_super+0xac/0x330
[ 2152.799638]  kill_block_super+0x94/0xe0
[ 2152.803923]  deactivate_locked_super+0x82/0xd0
[ 2152.808885]  deactivate_super+0x123/0x140
[ 2152.813363]  ? get_super_exclusive_thawed+0x10/0x10
[ 2152.818813]  ? rcu_is_watching+0x2c/0x80
[ 2152.823201]  cleanup_mnt+0x9f/0x130
[ 2152.827089]  task_work_run+0x10e/0x190
[ 2152.831294]  exit_to_usermode_loop+0x136/0x160
[ 2152.836260]  do_syscall_64+0x3c3/0x480
[ 2152.840452]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[ 2152.846092] RIP: 0033:0x7f3aee28da3b
[ 2152.850083] Code: 14 2c 00 f7 d8 64 89 01 48 83 c8 ff c3 66 90 f3 0f 1e fa
31 f6 e9 05 00 00 00 0f 1f 44 00 00 f3 0f 1e fa b8 a6 00 00 00 0f 05 <48> 3d 01
f0 ff ff 73 01 c3 48 8b 0d 1d 14 2c 00 f7 d8 64 89 01 48
[ 2152.871041] RSP: 002b:00007ffff8962718 EFLAGS: 00000246 ORIG_RAX:
00000000000000a6
[ 2152.879485] RAX: 0000000000000000 RBX: 0000564c78b5c2d0 RCX:
00007f3aee28da3b
[ 2152.887441] RDX: 0000000000000001 RSI: 0000000000000000 RDI:
0000564c78b64db0
[ 2152.895412] RBP: 0000000000000000 R08: 0000564c78b64dd0 R09:
00007ffff8960f80
[ 2152.903376] R10: 0000000000000000 R11: 0000000000000246 R12:
0000564c78b64db0
[ 2152.911343] R13: 00007f3aef039184 R14: 0000564c78b5c4b0 R15:
00000000ffffffff
[ 2152.919317] irq event stamp: 46282
[ 2152.923116] hardirqs last  enabled at (46281): [<ffffffffb570eeb2>]
console_unlock+0x672/0xc50
[ 2152.932731] hardirqs last disabled at (46282): [<ffffffffb54054d1>]
trace_hardirqs_off_thunk+0x1a/0x1c
[ 2152.943113] softirqs last  enabled at (46278): [<ffffffffb72006a8>]
__do_softirq+0x6a8/0xa1c
[ 2152.952535] softirqs last disabled at (46271): [<ffffffffb55c0c71>]
irq_exit+0x281/0x2d0
[ 2152.961568] ---[ end trace 94749dfc843d5970 ]---
[ 2153.124997] XFS (dm-5): Unmounting Filesystem
[ 2154.012646] XFS (dm-2): Unmounting Filesystem


I tested on xfs-linux for-next branch:
# git log --oneline
65eed012d1f2 (HEAD -> for-next, tag: xfs-4.21-merge-2, origin/xfs-4.21-merge,
origin/for-next) xfs: reallocate realtime summary cache on growfs
86d163dbfe2a (tag: xfs-4.21-merge-1) xfs: stringify scrub types in ftrace
output
...
...

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
