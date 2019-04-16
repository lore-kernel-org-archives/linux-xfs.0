Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:32800 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727214AbfDPBxg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 15 Apr 2019 21:53:36 -0400
Date: Mon, 15 Apr 2019 18:53:28 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Assertions tripping in xfs/104
Message-ID: <20190416015328.GL4752@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

Hi Brian,

When running fstests against what will become the xfs-5.2-merge tree, I
hit an assert in xfs/104; the dmesg for that is pasted below.

I'm pretty sure that what's going on here is that we hit a deferred AGFL
free while growing the filesystem and need to do a defer_roll, but
tr_growdata is not one of the permanent reservation transactions and
that's why we trip some asserts.

FSTYP         -- xfs (debug)
PLATFORM      -- Linux/x86_64 mtr01 5.1.0-rc5-djw
MKFS_OPTIONS  -- -f -m reflink=1,rmapbt=1, -i sparse=1, -b size=1024, /dev/sdd
MOUNT_OPTIONS -- -o usrquota,grpquota,prjquota, /dev/sdd /opt

Granted this is the first time I've seen this in several months of
nightly fstests runs, so chances are this one is hard to reproduce.

--D

[ 3422.450915] run fstests xfs/104 at 2019-04-15 16:39:07
[ 3422.889932] XFS (sde): Mounting V5 Filesystem
[ 3422.907936] XFS (sde): Ending clean mount
[ 3423.550860] XFS (sdd): Mounting V5 Filesystem
[ 3423.561930] XFS (sdd): Ending clean mount
[ 3423.566160] XFS (sdd): Quotacheck needed: Please wait.
[ 3423.571716] XFS (sdd): Quotacheck: Done.
[ 3431.662624] XFS: Assertion failed: tp->t_flags & XFS_TRANS_PERM_LOG_RES, file: fs/xfs/libxfs/xfs_defer.c, line: 500
[ 3431.670386] WARNING: CPU: 1 PID: 543157 at fs/xfs/xfs_message.c:104 assfail+0x27/0x2a [xfs]
[ 3431.672302] Modules linked in: dm_snapshot dm_bufio dm_flakey xfs libcrc32c xt_REDIRECT iptable_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 ip6t_REJECT nf_reject_ipv6 ipt_REJECT nf_reject_ipv4 xt_tcpudp ip_set_hash_net xt_set ip_set_hash_mac mq_deadline ip_set nfnetlink bfq ip6table_filter ip6_tables iptable_filter dax_pmem_compat device_dax dax_pmem_core nd_pmem sch_fq_codel ip_tables x_tables nfsv4 af_packet [last unloaded: scsi_debug]
[ 3431.681545] CPU: 1 PID: 543157 Comm: xfs_growfs Tainted: G        W         5.1.0-rc5-djw #rc5
[ 3431.683654] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.10.2-1ubuntu1 04/01/2014
[ 3431.685918] RIP: 0010:assfail+0x27/0x2a [xfs]
[ 3431.686727] Code: 0f 0b c3 66 66 66 66 90 48 89 f1 41 89 d0 48 c7 c6 50 fb 3e a0 48 89 fa 31 ff e8 a6 f8 ff ff 80 3d a5 97 0a 00 00 74 02 0f 0b <0f> 0b c3 48 8b b3 a8 02 00 00 48 c7 c7 e8 ff 3e a0 c6 05 c6 92 0a
[ 3431.689868] RSP: 0018:ffffc900021fb818 EFLAGS: 00010246
[ 3431.690824] RAX: 0000000000000000 RBX: ffffc900021fb968 RCX: 0000000000000000
[ 3431.692198] RDX: 00000000ffffffc0 RSI: 000000000000000a RDI: ffffffffa03e1c53
[ 3431.693607] RBP: ffff88803c4ad600 R08: 0000000000000000 R09: 0000000000000000
[ 3431.695014] R10: 000000000000000a R11: f000000000000000 R12: ffff8880389ace10
[ 3431.696439] R13: 0000000000000004 R14: 0000000000000006 R15: ffffc900021fb908
[ 3431.697811] FS:  00007f8bab534780(0000) GS:ffff88803ea00000(0000) knlGS:0000000000000000
[ 3431.699387] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 3431.700528] CR2: 000056480a0e0078 CR3: 0000000008618001 CR4: 00000000000606a0
[ 3431.701922] Call Trace:
[ 3431.702658]  xfs_defer_add+0x121/0x130 [xfs]
[ 3431.703702]  xfs_alloc_fix_freelist+0x15c/0x5d0 [xfs]
[ 3431.704872]  xfs_free_extent_fix_freelist+0x69/0xd0 [xfs]
[ 3431.706082]  __xfs_free_extent+0xa3/0x220 [xfs]
[ 3431.707109]  xfs_ag_extend_space+0x128/0x1a0 [xfs]
[ 3431.708230]  xfs_growfs_data+0x45e/0x4c0 [xfs]
[ 3431.709218]  xfs_file_ioctl+0x9e1/0xea0 [xfs]
[ 3431.710158]  do_vfs_ioctl+0xad/0x730
[ 3431.710902]  ksys_ioctl+0x3a/0x70
[ 3431.711597]  __x64_sys_ioctl+0x16/0x20
[ 3431.712391]  do_syscall_64+0x50/0x160
[ 3431.713160]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[ 3431.714172] RIP: 0033:0x7f8baac195d7
[ 3431.714904] Code: b3 66 90 48 8b 05 b1 48 2d 00 64 c7 00 26 00 00 00 48 c7 c0 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 81 48 2d 00 f7 d8 64 89 01 48
[ 3431.718428] RSP: 002b:00007ffdd977c848 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[ 3431.719936] RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 00007f8baac195d7
[ 3431.721394] RDX: 00007ffdd977c8c0 RSI: 000000004010586e RDI: 0000000000000004
[ 3431.722800] RBP: 0000000000000000 R08: 000000000005e400 R09: 0000000000000001
[ 3431.724195] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000005000
[ 3431.725605] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000001
[ 3431.727018] irq event stamp: 6508
[ 3431.727733] hardirqs last  enabled at (6507): [<ffffffff810cf53d>] console_unlock+0x43d/0x590
[ 3431.729394] hardirqs last disabled at (6508): [<ffffffff81001c8a>] trace_hardirqs_off_thunk+0x1a/0x1c
[ 3431.731177] softirqs last  enabled at (6504): [<ffffffff81a003a8>] __do_softirq+0x3a8/0x4bd
[ 3431.732769] softirqs last disabled at (6431): [<ffffffff8106289c>] irq_exit+0xbc/0xe0
[ 3431.734265] ---[ end trace 13812e5238b0fe50 ]---
[ 3431.735549] XFS: Assertion failed: tp->t_flags & XFS_TRANS_PERM_LOG_RES, file: fs/xfs/libxfs/xfs_defer.c, line: 500
[ 3431.737990] WARNING: CPU: 1 PID: 543157 at fs/xfs/xfs_message.c:104 assfail+0x27/0x2a [xfs]
[ 3431.739673] Modules linked in: dm_snapshot dm_bufio dm_flakey xfs libcrc32c xt_REDIRECT iptable_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 ip6t_REJECT nf_reject_ipv6 ipt_REJECT nf_reject_ipv4 xt_tcpudp ip_set_hash_net xt_set ip_set_hash_mac mq_deadline ip_set nfnetlink bfq ip6table_filter ip6_tables iptable_filter dax_pmem_compat device_dax dax_pmem_core nd_pmem sch_fq_codel ip_tables x_tables nfsv4 af_packet [last unloaded: scsi_debug]
[ 3431.746746] CPU: 1 PID: 543157 Comm: xfs_growfs Tainted: G        W         5.1.0-rc5-djw #rc5
[ 3431.748199] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.10.2-1ubuntu1 04/01/2014
[ 3431.750019] RIP: 0010:assfail+0x27/0x2a [xfs]
[ 3431.750944] Code: 0f 0b c3 66 66 66 66 90 48 89 f1 41 89 d0 48 c7 c6 50 fb 3e a0 48 89 fa 31 ff e8 a6 f8 ff ff 80 3d a5 97 0a 00 00 74 02 0f 0b <0f> 0b c3 48 8b b3 a8 02 00 00 48 c7 c7 e8 ff 3e a0 c6 05 c6 92 0a
[ 3431.754422] RSP: 0018:ffffc900021fb818 EFLAGS: 00010246
[ 3431.755489] RAX: 0000000000000000 RBX: ffffc900021fb968 RCX: 0000000000000000
[ 3431.756899] RDX: 00000000ffffffc0 RSI: 000000000000000a RDI: ffffffffa03e1c53
[ 3431.758308] RBP: ffff88803c4ad600 R08: 0000000000000000 R09: 0000000000000000
[ 3431.759719] R10: 000000000000000a R11: f000000000000000 R12: ffff8880389ac0d0
[ 3431.761162] R13: 0000000000000004 R14: 0000000000000006 R15: ffffc900021fb908
[ 3431.762572] FS:  00007f8bab534780(0000) GS:ffff88803ea00000(0000) knlGS:0000000000000000
[ 3431.764161] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 3431.765310] CR2: 000056480a0e0078 CR3: 0000000008618001 CR4: 00000000000606a0
[ 3431.766688] Call Trace:
[ 3431.767348]  xfs_defer_add+0x121/0x130 [xfs]
[ 3431.768250]  xfs_alloc_fix_freelist+0x15c/0x5d0 [xfs]
[ 3431.769375]  xfs_free_extent_fix_freelist+0x69/0xd0 [xfs]
[ 3431.770550]  __xfs_free_extent+0xa3/0x220 [xfs]
[ 3431.771539]  xfs_ag_extend_space+0x128/0x1a0 [xfs]
[ 3431.772601]  xfs_growfs_data+0x45e/0x4c0 [xfs]
[ 3431.773588]  xfs_file_ioctl+0x9e1/0xea0 [xfs]
[ 3431.774565]  do_vfs_ioctl+0xad/0x730
[ 3431.775309]  ksys_ioctl+0x3a/0x70
[ 3431.776008]  __x64_sys_ioctl+0x16/0x20
[ 3431.776789]  do_syscall_64+0x50/0x160
[ 3431.777555]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[ 3431.778612] RIP: 0033:0x7f8baac195d7
[ 3431.779356] Code: b3 66 90 48 8b 05 b1 48 2d 00 64 c7 00 26 00 00 00 48 c7 c0 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 81 48 2d 00 f7 d8 64 89 01 48
[ 3431.782844] RSP: 002b:00007ffdd977c848 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[ 3431.784352] RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 00007f8baac195d7
[ 3431.785743] RDX: 00007ffdd977c8c0 RSI: 000000004010586e RDI: 0000000000000004
[ 3431.787148] RBP: 0000000000000000 R08: 000000000005e400 R09: 0000000000000001
[ 3431.788564] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000005000
[ 3431.789933] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000001
[ 3431.791357] irq event stamp: 6828
[ 3431.792062] hardirqs last  enabled at (6827): [<ffffffff810cf53d>] console_unlock+0x43d/0x590
[ 3431.793735] hardirqs last disabled at (6828): [<ffffffff81001c8a>] trace_hardirqs_off_thunk+0x1a/0x1c
[ 3431.795547] softirqs last  enabled at (6824): [<ffffffff81a003a8>] __do_softirq+0x3a8/0x4bd
[ 3431.797182] softirqs last disabled at (6545): [<ffffffff8106289c>] irq_exit+0xbc/0xe0
[ 3431.798725] ---[ end trace 13812e5238b0fe51 ]---
[ 3431.800000] XFS: Assertion failed: tp->t_flags & XFS_TRANS_PERM_LOG_RES, file: fs/xfs/libxfs/xfs_defer.c, line: 500
[ 3431.802333] WARNING: CPU: 1 PID: 543157 at fs/xfs/xfs_message.c:104 assfail+0x27/0x2a [xfs]
[ 3431.804029] Modules linked in: dm_snapshot dm_bufio dm_flakey xfs libcrc32c xt_REDIRECT iptable_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 ip6t_REJECT nf_reject_ipv6 ipt_REJECT nf_reject_ipv4 xt_tcpudp ip_set_hash_net xt_set ip_set_hash_mac mq_deadline ip_set nfnetlink bfq ip6table_filter ip6_tables iptable_filter dax_pmem_compat device_dax dax_pmem_core nd_pmem sch_fq_codel ip_tables x_tables nfsv4 af_packet [last unloaded: scsi_debug]
[ 3431.811394] CPU: 1 PID: 543157 Comm: xfs_growfs Tainted: G        W         5.1.0-rc5-djw #rc5
[ 3431.813078] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.10.2-1ubuntu1 04/01/2014
[ 3431.814919] RIP: 0010:assfail+0x27/0x2a [xfs]
[ 3431.815794] Code: 0f 0b c3 66 66 66 66 90 48 89 f1 41 89 d0 48 c7 c6 50 fb 3e a0 48 89 fa 31 ff e8 a6 f8 ff ff 80 3d a5 97 0a 00 00 74 02 0f 0b <0f> 0b c3 48 8b b3 a8 02 00 00 48 c7 c7 e8 ff 3e a0 c6 05 c6 92 0a
[ 3431.819346] RSP: 0018:ffffc900021fb818 EFLAGS: 00010246
[ 3431.820401] RAX: 0000000000000000 RBX: ffffc900021fb968 RCX: 0000000000000000
[ 3431.821784] RDX: 00000000ffffffc0 RSI: 000000000000000a RDI: ffffffffa03e1c53
[ 3431.823166] RBP: ffff88803c4ad600 R08: 0000000000000000 R09: 0000000000000000
[ 3431.824589] R10: 000000000000000a R11: f000000000000000 R12: ffff8880389ac090
[ 3431.825980] R13: 0000000000000004 R14: 0000000000000006 R15: ffffc900021fb908
[ 3431.827440] FS:  00007f8bab534780(0000) GS:ffff88803ea00000(0000) knlGS:0000000000000000
[ 3431.829018] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 3431.830158] CR2: 000056480a0e0078 CR3: 0000000008618001 CR4: 00000000000606a0
[ 3431.831618] Call Trace:
[ 3431.832367]  xfs_defer_add+0x121/0x130 [xfs]
[ 3431.833323]  xfs_alloc_fix_freelist+0x15c/0x5d0 [xfs]
[ 3431.834477]  xfs_free_extent_fix_freelist+0x69/0xd0 [xfs]
[ 3431.835873]  __xfs_free_extent+0xa3/0x220 [xfs]
[ 3431.836755]  xfs_ag_extend_space+0x128/0x1a0 [xfs]
[ 3431.837666]  xfs_growfs_data+0x45e/0x4c0 [xfs]
[ 3431.838544]  xfs_file_ioctl+0x9e1/0xea0 [xfs]
[ 3431.839382]  do_vfs_ioctl+0xad/0x730
[ 3431.840042]  ksys_ioctl+0x3a/0x70
[ 3431.840665]  __x64_sys_ioctl+0x16/0x20
[ 3431.841370]  do_syscall_64+0x50/0x160
[ 3431.842060]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[ 3431.842971] RIP: 0033:0x7f8baac195d7
[ 3431.843659] Code: b3 66 90 48 8b 05 b1 48 2d 00 64 c7 00 26 00 00 00 48 c7 c0 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 81 48 2d 00 f7 d8 64 89 01 48
[ 3431.846744] RSP: 002b:00007ffdd977c848 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[ 3431.848078] RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 00007f8baac195d7
[ 3431.849465] RDX: 00007ffdd977c8c0 RSI: 000000004010586e RDI: 0000000000000004
[ 3431.850841] RBP: 0000000000000000 R08: 000000000005e400 R09: 0000000000000001
[ 3431.852199] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000005000
[ 3431.853581] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000001
[ 3431.854983] irq event stamp: 6880
[ 3431.855706] hardirqs last  enabled at (6879): [<ffffffff810cf53d>] console_unlock+0x43d/0x590
[ 3431.857390] hardirqs last disabled at (6880): [<ffffffff81001c8a>] trace_hardirqs_off_thunk+0x1a/0x1c
[ 3431.859166] softirqs last  enabled at (6876): [<ffffffff81a003a8>] __do_softirq+0x3a8/0x4bd
[ 3431.860773] softirqs last disabled at (6859): [<ffffffff8106289c>] irq_exit+0xbc/0xe0
[ 3431.862249] ---[ end trace 13812e5238b0fe52 ]---
[ 3431.863771] WARNING: CPU: 1 PID: 543157 at fs/xfs/xfs_trans.c:936 __xfs_trans_commit+0x81/0x420 [xfs]
[ 3431.865553] Modules linked in: dm_snapshot dm_bufio dm_flakey xfs libcrc32c xt_REDIRECT iptable_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 ip6t_REJECT nf_reject_ipv6 ipt_REJECT nf_reject_ipv4 xt_tcpudp ip_set_hash_net xt_set ip_set_hash_mac mq_deadline ip_set nfnetlink bfq ip6table_filter ip6_tables iptable_filter dax_pmem_compat device_dax dax_pmem_core nd_pmem sch_fq_codel ip_tables x_tables nfsv4 af_packet [last unloaded: scsi_debug]
[ 3431.872823] CPU: 1 PID: 543157 Comm: xfs_growfs Tainted: G        W         5.1.0-rc5-djw #rc5
[ 3431.874503] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.10.2-1ubuntu1 04/01/2014
[ 3431.876451] RIP: 0010:__xfs_trans_commit+0x81/0x420 [xfs]
[ 3431.877548] Code: 6d 02 00 00 48 8b 3c 24 48 8b 97 e8 00 00 00 48 8d 8f e8 00 00 00 8b 47 1c 48 39 d1 0f 84 39 02 00 00 a8 04 0f 85 dd 00 00 00 <0f> 0b a8 01 0f 84 fd 00 00 00 41 f6 84 24 80 05 00 00 10 0f 85 69
[ 3431.881025] RSP: 0018:ffffc900021fba78 EFLAGS: 00010246
[ 3431.882078] RAX: 000000000000002b RBX: 000000000000a800 RCX: ffff88803c4ad6e8
[ 3431.883495] RDX: ffff88806734e680 RSI: ffffffff82063680 RDI: ffff88803c4ad600
[ 3431.884889] RBP: 0000000000000000 R08: 000003e4df7e1cfc R09: 0000000000000001
[ 3431.886302] R10: 0000000000000001 R11: 0000000000000000 R12: ffff888076f68000
[ 3431.887705] R13: 000000000000002b R14: ffffffffa036f5e9 R15: ffff888076f68000
[ 3431.889104] FS:  00007f8bab534780(0000) GS:ffff88803ea00000(0000) knlGS:0000000000000000
[ 3431.890680] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 3431.891807] CR2: 000056480a0e0078 CR3: 0000000008618001 CR4: 00000000000606a0
[ 3431.893189] Call Trace:
[ 3431.893836]  xfs_growfs_data+0x3a9/0x4c0 [xfs]
[ 3431.894781]  xfs_file_ioctl+0x9e1/0xea0 [xfs]
[ 3431.895705]  do_vfs_ioctl+0xad/0x730
[ 3431.896472]  ksys_ioctl+0x3a/0x70
[ 3431.897192]  __x64_sys_ioctl+0x16/0x20
[ 3431.897962]  do_syscall_64+0x50/0x160
[ 3431.898728]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[ 3431.899734] RIP: 0033:0x7f8baac195d7
[ 3431.900491] Code: b3 66 90 48 8b 05 b1 48 2d 00 64 c7 00 26 00 00 00 48 c7 c0 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 81 48 2d 00 f7 d8 64 89 01 48
[ 3431.904089] RSP: 002b:00007ffdd977c848 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[ 3431.905596] RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 00007f8baac195d7
[ 3431.907029] RDX: 00007ffdd977c8c0 RSI: 000000004010586e RDI: 0000000000000004
[ 3431.908447] RBP: 0000000000000000 R08: 000000000005e400 R09: 0000000000000001
[ 3431.909851] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000005000
[ 3431.911253] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000001
[ 3431.912716] irq event stamp: 6916
[ 3431.913428] hardirqs last  enabled at (6915): [<ffffffff81225366>] kmem_cache_free+0x1a6/0x2a0
[ 3431.915116] hardirqs last disabled at (6916): [<ffffffff81001c8a>] trace_hardirqs_off_thunk+0x1a/0x1c
[ 3431.916988] softirqs last  enabled at (6902): [<ffffffff81a003a8>] __do_softirq+0x3a8/0x4bd
[ 3431.918609] softirqs last disabled at (6883): [<ffffffff8106289c>] irq_exit+0xbc/0xe0
[ 3431.920209] ---[ end trace 13812e5238b0fe53 ]---
[ 3431.921314] XFS: Assertion failed: (tp->t_fdblocks_delta + tp->t_res_fdblocks_delta) == (tp->t_ag_freeblks_delta + tp->t_ag_flist_delta + tp->t_ag_btree_delta), file: fs/xfs/xfs_trans.c, line: 463
[ 3431.924917] WARNING: CPU: 1 PID: 543157 at fs/xfs/xfs_message.c:104 assfail+0x27/0x2a [xfs]
[ 3431.926587] Modules linked in: dm_snapshot dm_bufio dm_flakey xfs libcrc32c xt_REDIRECT iptable_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 ip6t_REJECT nf_reject_ipv6 ipt_REJECT nf_reject_ipv4 xt_tcpudp ip_set_hash_net xt_set ip_set_hash_mac mq_deadline ip_set nfnetlink bfq ip6table_filter ip6_tables iptable_filter dax_pmem_compat device_dax dax_pmem_core nd_pmem sch_fq_codel ip_tables x_tables nfsv4 af_packet [last unloaded: scsi_debug]
[ 3431.933999] CPU: 1 PID: 543157 Comm: xfs_growfs Tainted: G        W         5.1.0-rc5-djw #rc5
[ 3431.935668] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.10.2-1ubuntu1 04/01/2014
[ 3431.937546] RIP: 0010:assfail+0x27/0x2a [xfs]
[ 3431.938456] Code: 0f 0b c3 66 66 66 66 90 48 89 f1 41 89 d0 48 c7 c6 50 fb 3e a0 48 89 fa 31 ff e8 a6 f8 ff ff 80 3d a5 97 0a 00 00 74 02 0f 0b <0f> 0b c3 48 8b b3 a8 02 00 00 48 c7 c7 e8 ff 3e a0 c6 05 c6 92 0a
[ 3431.941605] RSP: 0018:ffffc900021fba48 EFLAGS: 00010246
[ 3431.942529] RAX: 0000000000000000 RBX: ffff88803c4ad600 RCX: 0000000000000000
[ 3431.943791] RDX: 00000000ffffffc0 RSI: 000000000000000a RDI: ffffffffa03e1c53
[ 3431.945048] RBP: ffff88806739c000 R08: 0000000000000000 R09: 0000000000000000
[ 3431.946322] R10: 000000000000000a R11: f000000000000000 R12: ffff888041edd600
[ 3431.947567] R13: 000000000000002b R14: ffffffffa036f5e9 R15: ffff888076f68000
[ 3431.948792] FS:  00007f8bab534780(0000) GS:ffff88803ea00000(0000) knlGS:0000000000000000
[ 3431.950190] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 3431.951246] CR2: 000056480a0e0078 CR3: 0000000008618001 CR4: 00000000000606a0
[ 3431.952486] Call Trace:
[ 3431.953190]  xfs_trans_apply_sb_deltas+0x293/0x2a0 [xfs]
[ 3431.954244]  __xfs_trans_commit+0x388/0x420 [xfs]
[ 3431.955201]  xfs_growfs_data+0x3a9/0x4c0 [xfs]
[ 3431.956107]  xfs_file_ioctl+0x9e1/0xea0 [xfs]
[ 3431.956932]  do_vfs_ioctl+0xad/0x730
[ 3431.957579]  ksys_ioctl+0x3a/0x70
[ 3431.958181]  __x64_sys_ioctl+0x16/0x20
[ 3431.958851]  do_syscall_64+0x50/0x160
[ 3431.959506]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[ 3431.960398] RIP: 0033:0x7f8baac195d7
[ 3431.961039] Code: b3 66 90 48 8b 05 b1 48 2d 00 64 c7 00 26 00 00 00 48 c7 c0 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 81 48 2d 00 f7 d8 64 89 01 48
[ 3431.964113] RSP: 002b:00007ffdd977c848 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[ 3431.965434] RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 00007f8baac195d7
[ 3431.966646] RDX: 00007ffdd977c8c0 RSI: 000000004010586e RDI: 0000000000000004
[ 3431.967846] RBP: 0000000000000000 R08: 000000000005e400 R09: 0000000000000001
[ 3431.969024] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000005000
[ 3431.970257] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000001
[ 3431.971539] irq event stamp: 6948
[ 3431.972169] hardirqs last  enabled at (6947): [<ffffffff810cf53d>] console_unlock+0x43d/0x590
[ 3431.973645] hardirqs last disabled at (6948): [<ffffffff81001c8a>] trace_hardirqs_off_thunk+0x1a/0x1c
[ 3431.975180] softirqs last  enabled at (6934): [<ffffffff81a003a8>] __do_softirq+0x3a8/0x4bd
[ 3431.976573] softirqs last disabled at (6919): [<ffffffff8106289c>] irq_exit+0xbc/0xe0
[ 3431.977882] ---[ end trace 13812e5238b0fe54 ]---
[ 3436.580895] XFS (sdd): Unmounting Filesystem
[ 3436.911861] XFS (sde): Unmounting Filesystem
