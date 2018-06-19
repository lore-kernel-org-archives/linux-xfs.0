Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:45618 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S937215AbeFSJau (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Jun 2018 05:30:50 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 3E12728B8B
        for <linux-xfs@vger.kernel.org>; Tue, 19 Jun 2018 09:30:50 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 200137] New: [xfstests generic/485] XFS: Assertion failed:
 (irec->br_startoff & ~XFS_IEXT_STARTOFF_MASK) == 0, file:
 fs/xfs/libxfs/xfs_iext_tree.c, line: 68
Date: Tue, 19 Jun 2018 09:30:21 +0000
Message-ID: <bug-200137-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=200137

            Bug ID: 200137
           Summary: [xfstests generic/485] XFS: Assertion failed:
                    (irec->br_startoff & ~XFS_IEXT_STARTOFF_MASK) == 0,
                    file: fs/xfs/libxfs/xfs_iext_tree.c, line: 68
           Product: File System
           Version: 2.5
    Kernel Version: 4.17
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

generic/485 trigger a assertion failure on 512b block size XFS:

[1113763.825934] run fstests generic/485 at 2018-06-19 03:33:56
[1113764.649666] XFS: Assertion failed: (irec->br_startoff &
~XFS_IEXT_STARTOFF_MASK) == 0, file: fs/xfs/libxfs/xfs_iext_tree.c, line: 68
[1113764.663235] ------------[ cut here ]------------
[1113764.668580] kernel BUG at fs/xfs/xfs_message.c:114!
[1113764.674233] invalid opcode: 0000 [#1] SMP PTI
[1113764.679287] CPU: 7 PID: 23870 Comm: xfs_io Not tainted 4.17.0+ #3
[1113764.686278] Hardware name: IBM System x3650 M4 -[7915ON3]-/00J6520, BIOS
-[VVE124AUS-1.30]- 11/21/2012
[1113764.696932] RIP: 0010:assfail+0x25/0x2a [xfs]
[1113764.701983] Code: ff ff 0f 0b c3 66 66 66 66 90 48 89 f1 41 89 d0 48 c7 c6
10 a1 74 c0 48 89 fa 31 ff e8 7e f9 ff ff 80 3d 32 b2 08 00 00 74 02 <0f> 0b 0f
0b c3 48 8b b3 a8 01 00 00 48 c7 c7 30 a5 74 c0 c6 05 26 
[1113764.723257] RSP: 0018:ffff973c03237ba8 EFLAGS: 00010202
[1113764.729281] RAX: 0000000000000000 RBX: ffff973c03237ce0 RCX:
0000000000000000
[1113764.737437] RDX: 00000000ffffffc0 RSI: 000000000000000a RDI:
ffffffffc073d7a1
[1113764.745591] RBP: ffff88d071c74af8 R08: 0000000000000000 R09:
0000000000000000
[1113764.753747] R10: 000000000000000a R11: f000000000000000 R12:
ffff88d071c74af0
[1113764.761903] R13: ffff973c03237ce0 R14: ffff973c03237da0 R15:
ffffffffc068a141
[1113764.770059] FS:  00007fe4fc402740(0000) GS:ffff88d07fa40000(0000)
knlGS:0000000000000000
[1113764.779280] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[1113764.785885] CR2: 00007fe4fbc0dfb8 CR3: 000000046bb48006 CR4:
00000000000606e0
[1113764.794040] Call Trace:
[1113764.796998]  xfs_iext_set.isra.10+0xd0/0x100 [xfs]
[1113764.802571]  xfs_iext_update_extent+0x61/0x130 [xfs]
[1113764.808331]  xfs_bmap_shift_update_extent.constprop.21+0xb1/0x150 [xfs]
[1113764.815912]  ? kmem_cache_alloc+0x166/0x1d0
[1113764.820801]  xfs_bmap_insert_extents+0x22f/0x410 [xfs]
[1113764.826761]  xfs_insert_file_space+0x1ed/0x260 [xfs]
[1113764.832529]  xfs_file_fallocate+0x255/0x350 [xfs]
[1113764.837976]  ? __inode_security_revalidate+0x4c/0x60
[1113764.843710]  vfs_fallocate+0x13f/0x260
[1113764.848086]  ksys_fallocate+0x3c/0x80
[1113764.852366]  __x64_sys_fallocate+0x1a/0x20
[1113764.857132]  do_syscall_64+0x5b/0x160
[1113764.861413]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[1113764.867236] RIP: 0033:0x7fe4fbcff1fd
[1113764.871417] Code: 89 cd 41 54 49 89 d4 55 89 f5 53 89 fb 48 83 ec 18 e8 87
72 01 00 4d 89 ea 4c 89 e2 89 ee 41 89 c0 89 df b8 1d 01 00 00 0f 05 <48> 3d 00
f0 ff ff 77 2d 44 89 c7 89 44 24 0c e8 bf 72 01 00 8b 44
[1113764.892689] RSP: 002b:00007ffffe17d9c0 EFLAGS: 00000293 ORIG_RAX:
000000000000011d
[1113764.901330] RAX: ffffffffffffffda RBX: 0000000000000003 RCX:
00007fe4fbcff1fd
[1113764.909485] RDX: 0000000000000000 RSI: 0000000000000020 RDI:
0000000000000003
[1113764.917640] RBP: 0000000000000020 R08: 0000000000000000 R09:
0000000000000000
[1113764.925795] R10: 0000000000000400 R11: 0000000000000293 R12:
0000000000000000
[1113764.933950] R13: 0000000000000400 R14: 0000000000913f40 R15:
0000000000000001
[1113764.942107] Modules linked in: loop sunrpc dm_flakey xfs libcrc32c
intel_rapl sb_edac x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm
igb irqbypass crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel
ptp intel_cstate ipmi_ssif iTCO_wdt cdc_ether usbnet mii iTCO_vendor_support
ioatdma ipmi_si tpm_tis pps_core ipmi_devintf intel_uncore shpchp pcspkr
i2c_i801 tpm_tis_core dca tpm wmi ipmi_msghandler lpc_ich intel_rapl_perf
mgag200 i2c_algo_bit drm_kms_helper ttm drm megaraid_sas
[1113764.991708] ---[ end trace 033f8c60892d359a ]---
[1113764.997084] RIP: 0010:assfail+0x25/0x2a [xfs]
[1113765.002144] Code: ff ff 0f 0b c3 66 66 66 66 90 48 89 f1 41 89 d0 48 c7 c6
10 a1 74 c0 48 89 fa 31 ff e8 7e f9 ff ff 80 3d 32 b2 08 00 00 74 02 <0f> 0b 0f
0b c3 48 8b b3 a8 01 00 00 48 c7 c7 30 a5 74 c0 c6 05 26 
[1113765.023422] RSP: 0018:ffff973c03237ba8 EFLAGS: 00010202
[1113765.029451] RAX: 0000000000000000 RBX: ffff973c03237ce0 RCX:
0000000000000000
[1113765.037611] RDX: 00000000ffffffc0 RSI: 000000000000000a RDI:
ffffffffc073d7a1
[1113765.045772] RBP: ffff88d071c74af8 R08: 0000000000000000 R09:
0000000000000000
[1113765.053932] R10: 000000000000000a R11: f000000000000000 R12:
ffff88d071c74af0
[1113765.062083] R13: ffff973c03237ce0 R14: ffff973c03237da0 R15:
ffffffffc068a141
[1113765.070244] FS:  00007fe4fc402740(0000) GS:ffff88d07fa40000(0000)
knlGS:0000000000000000
[1113765.079470] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[1113765.086078] CR2: 00007fe4fbc0dfb8 CR3: 000000046bb48006 CR4:
00000000000606e0

How reproducible:
100%

Steps to Reproduce:
run generic/485 on 512b block size XFS

Additional info:
Only 512b block size XFS can reproduce this bug.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.