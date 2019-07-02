Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:45644 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727750AbfGBIEe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Jul 2019 04:04:34 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 30B712870F
        for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2019 08:04:33 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 204049] New: [xfstests generic/388]: XFS: Assertion failed:
 ip->i_d.di_format != XFS_DINODE_FMT_BTREE || ip->i_d.di_nextents >
 XFS_IFORK_MAXEXT(ip, XFS_DATA_FORK), file: fs/xfs/xfs_inode.c, line: 3646
Date: Tue, 02 Jul 2019 08:04:30 +0000
Message-ID: <bug-204049-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=204049

            Bug ID: 204049
           Summary: [xfstests generic/388]: XFS: Assertion failed:
                    ip->i_d.di_format != XFS_DINODE_FMT_BTREE ||
                    ip->i_d.di_nextents > XFS_IFORK_MAXEXT(ip,
                    XFS_DATA_FORK), file: fs/xfs/xfs_inode.c, line: 3646
           Product: File System
           Version: 2.5
    Kernel Version: xfs-linux xfs-5.3-merge-6
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

xfstests generic/388 hit below Assertion failure[2] on a x86_64 machine, the
xfs_info is [1]:

[1]
meta-data=/dev/sda4              isize=512    agcount=4, agsize=983040 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=0
         =                       reflink=1
data     =                       bsize=4096   blocks=3932160, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=2560, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

[2]
[18058.947904] run fstests generic/388 at 2019-07-01 10:37:17
[18059.342474] XFS (sda5): Unmounting Filesystem
[18059.492756] XFS (sda5): Mounting V5 Filesystem
[18059.502816] XFS (sda5): Ending clean mount
[18059.514150] XFS (sda5): User initiated shutdown received. Shutting down
filesystem
[18059.526721] XFS (sda5): Unmounting Filesystem
[18059.677616] XFS (sda5): Mounting V5 Filesystem
[18059.687990] XFS (sda5): Ending clean mount
[18061.708968] XFS (sda5): User initiated shutdown received. Shutting down
filesystem
[18062.171108] XFS (sda5): Unmounting Filesystem
[18062.344704] XFS (sda5): Mounting V5 Filesystem
[18062.406633] XFS (sda5): Starting recovery (logdev: internal)
[18063.442664] XFS (sda5): Ending recovery (logdev: internal)
[18064.576092] XFS (sda5): User initiated shutdown received. Shutting down
filesystem
[18064.955382] XFS (sda5): Unmounting Filesystem
[18065.200871] XFS (sda5): Mounting V5 Filesystem
[18065.372833] XFS (sda5): Starting recovery (logdev: internal)
[18065.990160] XFS (sda5): Ending recovery (logdev: internal)
[18066.019511] XFS (sda5): User initiated shutdown received. Shutting down
filesystem
[18066.019514] XFS (sda5): xfs_imap_lookup: xfs_ialloc_read_agi() returned
error -5, agno 0
[18066.019627] XFS (sda5): xfs_imap_to_bp: xfs_trans_read_buf() returned error
-5.
[18066.021626] XFS (sda5): xfs_imap_lookup: xfs_ialloc_read_agi() returned
error -5, agno 0
[18066.230882] XFS (sda5): Unmounting Filesystem
[18066.378139] XFS (sda5): Mounting V5 Filesystem
[18066.504392] XFS (sda5): Starting recovery (logdev: internal)
[18066.540025] XFS (sda5): Ending recovery (logdev: internal)
[18068.665850] XFS (sda5): User initiated shutdown received. Shutting down
filesystem
[18069.126055] XFS (sda5): Unmounting Filesystem
[18069.328492] XFS (sda5): Mounting V5 Filesystem
[18069.403893] XFS (sda5): Starting recovery (logdev: internal)
[18070.272804] XFS (sda5): Ending recovery (logdev: internal)
[18070.301110] XFS (sda5): User initiated shutdown received. Shutting down
filesystem
[18070.302552] XFS (sda5): xfs_imap_lookup: xfs_ialloc_read_agi() returned
error -5, agno 0
[18070.637949] XFS (sda5): Unmounting Filesystem
[18070.783472] XFS (sda5): Mounting V5 Filesystem
[18070.905981] XFS (sda5): Starting recovery (logdev: internal)
[18070.933962] XFS (sda5): Ending recovery (logdev: internal)
[18072.952290] XFS (sda5): User initiated shutdown received. Shutting down
filesystem
[18072.952589] XFS (sda5): writeback error on sector 89915760
[18072.965465] XFS (sda5): writeback error on sector 105649096
[18072.971080] XFS (sda5): writeback error on sector 105650776
[18073.411515] XFS (sda5): Unmounting Filesystem
[18073.416678] XFS: Assertion failed: ip->i_d.di_format != XFS_DINODE_FMT_BTREE
|| ip->i_d.di_nextents > XFS_IFORK_MAXEXT(ip, XFS_DATA_FORK), file:
fs/xfs/xfs_inode.c, line: 3646
[18073.432407] WARNING: CPU: 14 PID: 11667 at fs/xfs/xfs_message.c:93
asswarn+0x1c/0x1f [xfs]
[18073.440664] Modules linked in: dm_log_writes dm_mod intel_rapl skx_edac nfit
x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm sunrpc irqbypass
crct10dif_pclmul crc32_pclmul ghash_clmulni_intel iTCO_wdt ipmi_ssif dcdbas
iTCO_vendor_support intel_cstate intel_uncore ipmi_si nd_pmem dax_pmem_compat
sg device_dax dax_pmem_core intel_rapl_perf pcspkr ipmi_devintf ipmi_msghandler
mei_me acpi_power_meter mei i2c_i801 lpc_ich xfs libcrc32c sd_mod mgag200
drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops ttm drm ahci igb
libahci crc32c_intel megaraid_sas libata dca i2c_algo_bit
[18073.492975] CPU: 14 PID: 11667 Comm: xfsaild/sda5 Tainted: G        W       
 5.2.0-rc4+ #1
[18073.501317] Hardware name: Dell Inc. PowerEdge R640/0W23H8, BIOS 1.4.9
06/29/2018
[18073.508835] RIP: 0010:asswarn+0x1c/0x1f [xfs]
[18073.513191] Code: 00 00 00 5b 41 5c 41 5d 41 5e 41 5f 5d c3 0f 1f 44 00 00
48 89 f1 41 89 d0 48 c7 c6 40 a4 b7 c0 48 89 fa 31 ff e8 06 fa ff ff <0f> 0b c3
0f 1f 44 00 00 48 89 f1 41 89 d0 48 c7 c6 40 a4 b7 c0 48
[18073.531936] RSP: 0018:ffff888a488bfbd0 EFLAGS: 00010282
[18073.537160] RAX: 0000000000000000 RBX: 1ffff11149117f7d RCX:
0000000000000000
[18073.544293] RDX: dffffc0000000000 RSI: 000000000000000a RDI:
ffffed1149117f6c
[18073.551426] RBP: ffff888a51133fd0 R08: ffffed116d27dfb1 R09:
ffffed116d27dfb0
[18073.558559] R10: ffffed116d27dfb0 R11: ffff888b693efd87 R12:
ffff888102f65500
[18073.565690] R13: 0000000000000150 R14: ffff888a51134018 R15:
ffff888a51133e00
[18073.572822] FS:  0000000000000000(0000) GS:ffff888b69200000(0000)
knlGS:0000000000000000
[18073.580908] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[18073.586653] CR2: 000055c4a6a3c150 CR3: 0000000b08816005 CR4:
00000000007606e0
[18073.593786] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[18073.600918] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
0000000000000400
[18073.608049] PKRU: 55555554
[18073.610761] Call Trace:
[18073.613249]  xfs_iflush+0x50c/0x870 [xfs]
[18073.617297]  ? xfs_iflush_cluster+0xd60/0xd60 [xfs]
[18073.622179]  ? lock_downgrade+0x620/0x620
[18073.626189]  ? lock_contended+0xd50/0xd50
[18073.630238]  xfs_inode_item_push+0x2bc/0x590 [xfs]
[18073.635061]  ? xfs_inode_item_size+0x1e0/0x1e0 [xfs]
[18073.640063]  ? xfs_buf_item_push+0x1a0/0x4d0 [xfs]
[18073.644890]  xfsaild+0xab3/0x2170 [xfs]
[18073.648767]  ? xfs_trans_ail_cursor_first+0x180/0x180 [xfs]
[18073.654336]  ? lock_downgrade+0x620/0x620
[18073.658349]  ? do_raw_spin_lock+0x290/0x290
[18073.662538]  ? firmware_map_remove+0x16d/0x16d
[18073.666982]  ? __kthread_parkme+0xb6/0x180
[18073.671111]  ? xfs_trans_ail_cursor_first+0x180/0x180 [xfs]
[18073.676686]  kthread+0x326/0x3f0
[18073.679919]  ? kthread_create_on_node+0xc0/0xc0
[18073.684452]  ret_from_fork+0x3a/0x50
[18073.688033] irq event stamp: 0
[18073.691087] hardirqs last  enabled at (0): [<0000000000000000>] 0x0
[18073.697354] hardirqs last disabled at (0): [<ffffffffb85b045b>]
copy_process.part.33+0x187b/0x5e40
[18073.706304] softirqs last  enabled at (0): [<ffffffffb85b04f7>]
copy_process.part.33+0x1917/0x5e40
[18073.715255] softirqs last disabled at (0): [<0000000000000000>] 0x0
[18073.721524] ---[ end trace e8ea57bbbcc47164 ]---
[18073.890399] XFS (sda5): Mounting V5 Filesystem
[18073.944258] XFS (sda5): Starting recovery (logdev: internal)
[18074.710479] XFS (sda5): Ending recovery (logdev: internal)
[18075.739799] XFS (sda5): User initiated shutdown received. Shutting down
filesystem
[18076.072802] XFS (sda5): Unmounting Filesystem
[18076.278093] XFS (sda5): Mounting V5 Filesystem

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
