Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57410 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751358AbdARHqc (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 18 Jan 2017 02:46:32 -0500
Received: from smtp.corp.redhat.com (int-mx16.intmail.prod.int.phx2.redhat.com [10.5.11.28])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1D9256316C
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jan 2017 07:46:33 +0000 (UTC)
Received: from localhost (vpn1-6-85.pek2.redhat.com [10.72.6.85])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 703C922C664
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jan 2017 07:46:32 +0000 (UTC)
Date: Wed, 18 Jan 2017 15:46:28 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: [BUG] generic/232 hangs on XFS DAX mount
Message-ID: <20170118074628.GP1859@eguan.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi all,

I hit a generic/232 hang on XFS DAX mount, kernel is 4.10-rc4, 4.9
kernel also could reproduce, so at least it's not a 4.10 regression. I
haven't tested other kernel versions yet.

I reproduced it by running generic/232 in a tight loop, it usually hangs
within 50 iterations. test dev is 15G brd ramdisk.

I append detailed host info and test config at the end. If you need more
info please let me know.

Thanks,
Eryu

TEST_DEV=/dev/ram0
SCRATCH_DEV=/dev/ram1
TEST_DIR=/mnt/test
SCRATCH_MNT=/mnt/scratch
MKFS_OPTIONS="-f -m crc=1 -b size=4k"
MOUNT_OPTIONS="-o dax"

[ 4489.611370] sysrq: SysRq : Show Blocked State
[ 4489.632865]   task                        PC stack   pid father
[ 4489.661722] xfs_quota       D    0 30771  30468 0x00000080
[ 4489.689072] Call Trace:
[ 4489.701239]  __schedule+0x21c/0x6b0
[ 4489.717525]  ? __free_pages+0x19/0x30
[ 4489.734712]  schedule+0x36/0x80
[ 4489.749458]  schedule_timeout+0x21c/0x3a0
[ 4489.768249]  ? __slab_free+0x9b/0x2c0
[ 4489.785477]  wait_for_completion+0x11c/0x180
[ 4489.805688]  ? wake_up_q+0x80/0x80
[ 4489.821670]  xfs_qm_dqpurge+0x6b/0x1b0 [xfs]
[ 4489.841764]  ? xfs_qm_need_dqattach+0x80/0x80 [xfs]
[ 4489.864823]  xfs_qm_dquot_walk.isra.10+0xfb/0x190 [xfs]
[ 4489.889610]  xfs_qm_dqpurge_all+0x5c/0x80 [xfs]
[ 4489.910959]  xfs_qm_scall_quotaoff+0x127/0x380 [xfs]
[ 4489.934407]  xfs_quota_disable+0x3d/0x50 [xfs]
[ 4489.955286]  SyS_quotactl+0x391/0x850
[ 4489.972522]  ? __audit_syscall_entry+0xaf/0x100
[ 4489.993523]  ? syscall_trace_enter+0x1d0/0x2b0
[ 4490.014486]  ? __audit_syscall_exit+0x209/0x290
[ 4490.035763]  do_syscall_64+0x67/0x180
[ 4490.053266]  entry_SYSCALL64_slow_path+0x25/0x25
[ 4490.074955] RIP: 0033:0x7eff755e2fea
[ 4490.091854] RSP: 002b:00007ffe012179d8 EFLAGS: 00000206 ORIG_RAX: 00000000000000b3
[ 4490.127517] RAX: ffffffffffffffda RBX: 0000000000000005 RCX: 00007eff755e2fea
[ 4490.162364] RDX: 0000000000000000 RSI: 00000000012ee2f0 RDI: 0000000000580200
[ 4490.196833] RBP: 00000000012ee310 R08: 00007ffe012179ec R09: 0000000000000000
[ 4490.231139] R10: 00007ffe012179ec R11: 0000000000000206 R12: 00000000012ee2d0
[ 4490.264475] R13: 00000000012ed0a0 R14: 0000000000000000 R15: 00000000012ed080

[root@hp-dl360g9-15 xfstests]# lscpu
Architecture:          x86_64
CPU op-mode(s):        32-bit, 64-bit
Byte Order:            Little Endian
CPU(s):                16
On-line CPU(s) list:   0-15
Thread(s) per core:    1
Core(s) per socket:    8
Socket(s):             2
NUMA node(s):          2
Vendor ID:             GenuineIntel
CPU family:            6
Model:                 63
Model name:            Intel(R) Xeon(R) CPU E5-2630 v3 @ 2.40GHz
Stepping:              2
CPU MHz:               2400.000
BogoMIPS:              4801.94
Virtualization:        VT-x
L1d cache:             32K
L1i cache:             32K
L2 cache:              256K
L3 cache:              20480K
NUMA node0 CPU(s):     0-3,8-11
NUMA node1 CPU(s):     4-7,12-15
[root@hp-dl360g9-15 xfstests]# free -m
              total        used        free      shared  buff/cache   available
Mem:          64305         761       63382           9         161       63071
Swap:         16379           0       16379
[root@hp-dl360g9-15 xfstests]# uname -a
Linux hp-dl360g9-15 4.10.0-rc4 #18 SMP Wed Jan 18 11:39:05 CST 2017 x86_64 x86_64 x86_64 GNU/Linux
