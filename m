Return-Path: <SRS0=rYOu=EB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E305DC2D0A3
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 05:52:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C6EF223AB
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 05:52:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1769785AbgJZFwJ convert rfc822-to-8bit (ORCPT
        <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Oct 2020 01:52:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:48358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1769636AbgJZFwI (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 26 Oct 2020 01:52:08 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 209859] New: [xfstests generic/333] XFS: Assertion failed:
 xfs_perag_resv(pag, XFS_AG_RESV_METADATA)->ar_reserved + xfs_perag_resv(pag,
 XFS_AG_RESV_RMAPBT)->ar_reserved <= pag->pagf_freeblks + pag->pagf_flcount,
 file: fs/xfs/libxfs/xfs_ag_resv.c, line: 313
Date:   Mon, 26 Oct 2020 05:52:07 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: zlang@redhat.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression
Message-ID: <bug-209859-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=209859

            Bug ID: 209859
           Summary: [xfstests generic/333] XFS: Assertion failed:
                    xfs_perag_resv(pag, XFS_AG_RESV_METADATA)->ar_reserved
                    + xfs_perag_resv(pag, XFS_AG_RESV_RMAPBT)->ar_reserved
                    <= pag->pagf_freeblks + pag->pagf_flcount, file:
                    fs/xfs/libxfs/xfs_ag_resv.c, line: 313
           Product: File System
           Version: 2.5
    Kernel Version: xfs-linux xfs-5.10-merge-7
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

Description of problem:

xfstests generic/333 hit below assertion failure once:
[26390.360615] run fstests generic/333 at 2020-10-24 15:22:45
[26393.449100] XFS (sda4): Mounting V5 Filesystem
[26393.607759] XFS (sda4): Ending clean mount
[26393.647446] xfs filesystem being mounted at /mnt/xfstests/scratch supports
timestamps until 2038 (0x7fffffff)
[26393.771356] XFS (sda4): Unmounting Filesystem
[26394.344163] XFS (sda4): Mounting V5 Filesystem
[26394.505265] XFS (sda4): Ending clean mount
[26394.534050] xfs filesystem being mounted at /mnt/xfstests/scratch supports
timestamps until 2038 (0x7fffffff)
[26395.439090] XFS (sda4): Unmounting Filesystem
[26395.646184] XFS (sda4): Mounting V5 Filesystem
[26395.807203] XFS (sda4): Ending clean mount
[26395.840963] xfs filesystem being mounted at /mnt/xfstests/scratch supports
timestamps until 2038 (0x7fffffff)
[26634.854276] XFS (sda5): Unmounting Filesystem
[26871.488167] XFS (sda4): Unmounting Filesystem
[26875.011990] XFS (sda4): Mounting V5 Filesystem
[26875.175333] XFS (sda4): Ending clean mount
[26875.200997] XFS: Assertion failed: xfs_perag_resv(pag,
XFS_AG_RESV_METADATA)->ar_reserved + xfs_perag_resv(pag,
XFS_AG_RESV_RMAPBT)->ar_reserved <= pag->pagf_freeblks + pag->pagf_flcount,
file: fs/xfs/libxfs/xfs_ag_resv.c, line: 313
[26875.293983] ------------[ cut here ]------------
[26875.314999] WARNING: CPU: 13 PID: 1341766 at fs/xfs/xfs_message.c:112
assfail+0x5a/0x80 [xfs]
[26875.353500] Modules linked in: dm_snapshot dm_bufio ext4 mbcache jbd2 loop
dm_flakey dm_mod amd64_edac_mod edac_mce_amd kvm_amd rfkill ccp kvm mgag200
i2c_algo_bit drm_kms_helper irqbypass syscopyarea sysfillrect crct10dif_pclmul
sysimgblt crc32_pclmul fb_sys_fops ghash_clmulni_intel drm pcspkr sp5100_tco
fam15h_power k10temp ipmi_ssif i2c_piix4 acpi_ipmi hpwdt ipmi_si hpilo
ipmi_devintf ipmi_msghandler sunrpc acpi_power_meter ip_tables xfs libcrc32c
sr_mod cdrom sd_mod t10_pi sg ata_generic ahci libahci hpsa libata crc32c_intel
tg3 serio_raw scsi_transport_sas [last unloaded: scsi_debug]
[26875.595545] CPU: 13 PID: 1341766 Comm: mount Tainted: G        W        
5.9.0-rc4 #1
[26875.631091] Hardware name: HP ProLiant DL385p Gen8, BIOS A28 02/06/2014
[26875.661025] RIP: 0010:assfail+0x5a/0x80 [xfs]
[26875.680727] Code: c1 ea 03 0f b6 04 02 48 89 fa 83 e2 07 38 d0 7f 04 84 c0
75 19 0f b6 1d e0 87 2a 00 80 fb 01 0f 87 dd 36 12 00 83 e3 01 75 0b <0f> 0b 5b
c3 e8 ad 64 20 e1 eb e0 0f 0b 48 c7 c7 20 2c e0 c0 e8 b9
[26875.765474] RSP: 0018:ffff88869fc279e0 EFLAGS: 00010246
[26875.789477] RAX: 0000000000000000 RBX: 0000000000000000 RCX:
0000000000000000
[26875.821897] RDX: 0000000000000004 RSI: 000000000000000a RDI:
ffffffffc0df382c
[26875.854300] RBP: 1ffff110d3f84f40 R08: ffffed1106cfe305 R09:
ffffed1106cfe305
[26875.886669] R10: ffff8888367f1827 R11: ffffed1106cfe304 R12:
000000000000000f
[26875.918850] R13: 0000000000000057 R14: ffff8888330e8000 R15:
0000000000000000
[26875.951057] FS:  00007f2e45817080(0000) GS:ffff888836600000(0000)
knlGS:0000000000000000
[26875.987511] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[26876.013425] CR2: 00007f2e44790400 CR3: 000000080b59a000 CR4:
00000000000406e0
[26876.046603] Call Trace:
[26876.058516]  xfs_ag_resv_init+0x40b/0x4b0 [xfs]
[26876.080842]  ? xfs_ag_resv_free+0x40/0x40 [xfs]
[26876.103318]  ? rcu_read_lock_bh_held+0xd0/0xd0
[26876.123949]  ? __percpu_counter_compare+0x58/0xe0
[26876.145289]  ? xfs_perag_get+0x3c9/0x480 [xfs]
[26876.166206]  ? xfs_fs_reserve_ag_blocks+0xa5/0x150 [xfs]
[26876.191824]  xfs_fs_reserve_ag_blocks+0xb2/0x150 [xfs]
[26876.216117]  xfs_mountfs+0x1114/0x1ba0 [xfs]
[26876.236136]  ? xfs_mount_reset_sbqflags+0xf0/0xf0 [xfs]
[26876.259752]  ? cpumask_next+0x54/0x70
[26876.276272]  ? module_assert_mutex_or_preempt+0x41/0x70
[26876.299874]  ? rcu_read_lock_sched_held+0xaf/0xe0
[26876.321189]  ? rcu_read_lock_bh_held+0xd0/0xd0
[26876.341575]  ? xfs_mru_cache_create+0x35d/0x570 [xfs]
[26876.364520]  xfs_fc_fill_super+0x875/0x1480 [xfs]
[26876.385840]  get_tree_bdev+0x40f/0x690
[26876.402854]  ? xfs_fs_show_options+0x730/0x730 [xfs]
[26876.425286]  vfs_get_tree+0x89/0x330
[26876.441441]  ? ns_capable_common+0x64/0xe0
[26876.459943]  path_mount+0xe10/0x1810
[26876.476058]  ? copy_mount_string+0x20/0x20
[26876.494563]  ? strncpy_from_user+0x8e/0x370
[26876.513417]  ? getname_flags+0xf8/0x510
[26876.530827]  do_mount+0xcb/0xf0
[26876.545095]  ? path_mount+0x1810/0x1810
[26876.564088]  ? _copy_from_user+0xbe/0x100
[26876.584172]  ? memdup_user+0x54/0x80
[26876.601594]  __x64_sys_mount+0x162/0x1b0
[26876.620623]  do_syscall_64+0x33/0x40
[26876.637173]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[26876.659920] RIP: 0033:0x7f2e4483da9e
[26876.676033] Code: 48 8b 0d ed f3 2b 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e
0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01
f0 ff ff 73 01 c3 48 8b 0d ba f3 2b 00 f7 d8 64 89 01 48
[26876.760797] RSP: 002b:00007ffcbcb05ee8 EFLAGS: 00000246 ORIG_RAX:
00000000000000a5
[26876.795185] RAX: ffffffffffffffda RBX: 000055f680993310 RCX:
00007f2e4483da9e
[26876.827393] RDX: 000055f6809934f0 RSI: 000055f680993530 RDI:
000055f680993510
[26876.861041] RBP: 00007f2e455f8184 R08: 0000000000000000 R09:
00007f2e4487ce20
[26876.893323] R10: 00000000c0ed0000 R11: 0000000000000246 R12:
0000000000000000
[26876.925490] R13: 00000000c0ed0000 R14: 000055f680993510 R15:
000055f6809934f0
[26876.957927] irq event stamp: 52131
[26876.973260] hardirqs last  enabled at (52141): [<ffffffffa17aaf9a>]
console_unlock+0x7ea/0xa60
[26877.012079] hardirqs last disabled at (52150): [<ffffffffa17aae73>]
console_unlock+0x6c3/0xa60
[26877.050973] softirqs last  enabled at (52164): [<ffffffffa380071d>]
__do_softirq+0x71d/0xab0
[26877.091029] softirqs last disabled at (52159): [<ffffffffa3601032>]
asm_call_on_stack+0x12/0x20
[26877.133747] ---[ end trace eea0580f6e9a4f4c ]---
[26877.160274] xfs filesystem being mounted at /mnt/xfstests/scratch supports
timestamps until 2038 (0x7fffffff)
[26877.238991] XFS (sda4): Unmounting Filesystem

Kernel HEAD:
xfs-5.10-merge-7 of xfs-linux for-next branch

generic/333.full output:
meta-data=/dev/sda4              isize=512    agcount=8, agsize=12800 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=1
         =                       reflink=1
data     =                       bsize=4096   blocks=102400, imaxpct=25
         =                       sunit=64     swidth=192 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=6144, version=2
         =                       sectsz=512   sunit=64 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

wrote 67108864/67108864 bytes at offset 0
64 MiB, 16384 ops; 0.4962 sec (128.968 MiB/sec and 33015.7502 ops/sec)
wrote 65536/65536 bytes at offset 67043328 64 KiB, 16 ops; 0.0358 sec (1.741
MiB/sec and 445.7942 ops/sec)
wrote 65536/65536 bytes at offset 66977792 64 KiB, 16 ops; 0.0344 sec (1.813
MiB/sec and 464.1448 ops/sec)
wrote 65536/65536 bytes at offset 66912256 64 KiB, 16 ops; 0.0395 sec (1.579
MiB/sec and 404.3263 ops/sec)
wrote 65536/65536 bytes at offset 66846720 64 KiB, 16 ops; 0.0299 sec (2.089
MiB/sec and 534.6879 ops/sec)
wrote 65536/65536 bytes at offset 66781184 64 KiB, 16 ops; 0.0354 sec (1.765
MiB/sec and 451.9519 ops/sec)
wrote 65536/65536 bytes at offset 66715648 64 KiB, 16 ops; 0.0394 sec (1.585
MiB/sec and 405.8339 ops/sec)
wrote 65536/65536 bytes at offset 66650112 64 KiB, 16 ops; 0.0367 sec (1.701
MiB/sec and 435.5401 ops/sec)
...
...

wrote 65536/65536 bytes at offset 58327040 64 KiB, 16 ops; 0.1378 sec (464.408
KiB/sec and 116.1019 ops/sec)
wrote 65536/65536 bytes at offset 58261504 64 KiB, 16 ops; 0.1374 sec (465.556
KiB/sec and 116.3890 ops/sec)
wrote 65536/65536 bytes at offset 58195968 64 KiB, 16 ops; 0.0359 sec (1.736
MiB/sec and 444.4691 ops/sec)

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
