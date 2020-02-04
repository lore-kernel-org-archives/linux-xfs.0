Return-Path: <SRS0=4Qc2=3Y=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 006D1C3524A
	for <linux-xfs@archiver.kernel.org>; Tue,  4 Feb 2020 06:13:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B95002086A
	for <linux-xfs@archiver.kernel.org>; Tue,  4 Feb 2020 06:13:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726053AbgBDGNS convert rfc822-to-8bit (ORCPT
        <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 4 Feb 2020 01:13:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:46328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725834AbgBDGNR (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 4 Feb 2020 01:13:17 -0500
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 206399] New: [xfstests xfs/433] BUG: KASAN: use-after-free in
 xfs_attr3_node_inactive+0x6c8/0x7b0 [xfs]
Date:   Tue, 04 Feb 2020 06:13:15 +0000
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
Message-ID: <bug-206399-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=206399

            Bug ID: 206399
           Summary: [xfstests xfs/433] BUG: KASAN: use-after-free in
                    xfs_attr3_node_inactive+0x6c8/0x7b0 [xfs]
           Product: File System
           Version: 2.5
    Kernel Version: linux 5.5+ with xfs-linux xfs-5.6-merge-7
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

xfs/443 always hit below KASAN BUG:
FSTYP         -- xfs (debug)
PLATFORM      -- Linux/x86_64 hpe-tm200-01 5.5.0+ #1 SMP Wed Jan 29 06:10:18
EST 2020
MKFS_OPTIONS  -- -f -m crc=1,finobt=1,rmapbt=1,reflink=1 -i sparse=1 /dev/sda4
MOUNT_OPTIONS -- -o context=system_u:object_r:nfs_t:s0 /dev/sda4
/mnt/xfstests/mnt2

xfs/433 _check_dmesg: something found in dmesg (see
/var/lib/xfstests/results//xfs/433.dmesg)

Ran: xfs/433
Failures: xfs/433
Failed 1 of 1 tests



[75618.288080] run fstests xfs/433 at 2020-01-30 04:00:53
[75620.394755] XFS (sda5): Mounting V5 Filesystem
[75620.488847] XFS (sda5): Ending clean mount
[75620.522825] xfs filesystem being mounted at /mnt/xfstests/mnt2 supports
timestamps until 2038 (0x7fffffff)
[75625.506275] XFS (sda5): Unmounting Filesystem
[75625.680838] XFS (sda5): Mounting V5 Filesystem
[75625.834275] XFS (sda5): Ending clean mount
[75625.885694] xfs filesystem being mounted at /mnt/xfstests/mnt2 supports
timestamps until 2038 (0x7fffffff)
[75625.985258] XFS (sda5): Injecting error (false) at file fs/xfs/xfs_buf.c,
line 2119, on filesystem "sda5"
[75626.029242] XFS (sda5): Injecting error (false) at file fs/xfs/xfs_buf.c,
line 2119, on filesystem "sda5"
[75626.078339] XFS (sda5): Injecting error (false) at file fs/xfs/xfs_buf.c,
line 2119, on filesystem "sda5"
[75626.124795] XFS (sda5): Injecting error (false) at file fs/xfs/xfs_buf.c,
line 2119, on filesystem "sda5"
[75626.169098] XFS (sda5): Injecting error (false) at file fs/xfs/xfs_buf.c,
line 2119, on filesystem "sda5"
[75626.212549]
==================================================================
[75626.245606] BUG: KASAN: use-after-free in
xfs_attr3_node_inactive+0x61e/0x8a0 [xfs]
[75626.280164] Read of size 4 at addr ffff88881ffab004 by task rm/30390

[75626.315595] CPU: 13 PID: 30390 Comm: rm Tainted: G        W         5.5.0+
#1
[75626.347856] Hardware name: HP ProLiant DL380p Gen8, BIOS P70 08/02/2014
[75626.377864] Call Trace:
[75626.388868]  dump_stack+0x96/0xe0
[75626.403778]  print_address_description.constprop.4+0x1f/0x300
[75626.429656]  __kasan_report.cold.8+0x76/0xb0
[75626.448950]  ? xfs_trans_ordered_buf+0x410/0x440 [xfs]
[75626.472393]  ? xfs_attr3_node_inactive+0x61e/0x8a0 [xfs]
[75626.496705]  kasan_report+0xe/0x20
[75626.512134]  xfs_attr3_node_inactive+0x61e/0x8a0 [xfs]
[75626.535328]  ? xfs_da_read_buf+0x235/0x2c0 [xfs]
[75626.557270]  ? xfs_attr3_leaf_inactive+0x470/0x470 [xfs]
[75626.583199]  ? xfs_da3_root_split+0x1050/0x1050 [xfs]
[75626.607952]  ? lock_contended+0xd20/0xd20
[75626.626615]  ? xfs_ilock+0x149/0x4c0 [xfs]
[75626.644661]  ? down_write_nested+0x187/0x3c0
[75626.663892]  ? down_write_trylock+0x2f0/0x2f0
[75626.683496]  ? __sb_start_write+0x1c4/0x310
[75626.702389]  ? down_read_trylock+0x360/0x360
[75626.721669]  ? xfs_trans_buf_set_type+0x90/0x1e0 [xfs]
[75626.745171]  xfs_attr_inactive+0x3e5/0x7b0 [xfs]
[75626.766097]  ? xfs_attr3_node_inactive+0x8a0/0x8a0 [xfs]
[75626.790101]  ? lock_downgrade+0x6d0/0x6d0
[75626.808122]  ? do_raw_spin_trylock+0xb2/0x180
[75626.827859]  ? lock_contended+0xd20/0xd20
[75626.846154]  xfs_inactive+0x4b8/0x5b0 [xfs]
[75626.865504]  xfs_fs_destroy_inode+0x3dc/0xb80 [xfs]
[75626.887615]  destroy_inode+0xbc/0x1a0
[75626.904172]  do_unlinkat+0x451/0x5d0
[75626.920325]  ? __ia32_sys_rmdir+0x40/0x40
[75626.938485]  ? __check_object_size+0x275/0x324
[75626.958819]  ? strncpy_from_user+0x7d/0x350
[75626.977848]  do_syscall_64+0x9f/0x4f0
[75626.994333]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[75627.017173] RIP: 0033:0x7f968239567b
[75627.033260] Code: 73 01 c3 48 8b 0d 0d d8 2c 00 f7 d8 64 89 01 48 83 c8 ff
c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa b8 07 01 00 00 0f 05 <48> 3d 01
f0 ff ff 73 01 c3 48 8b 0d dd d7 2c 00 f7 d8 64 89 01 48
[75627.123796] RSP: 002b:00007ffcdf66ad38 EFLAGS: 00000246 ORIG_RAX:
0000000000000107
[75627.158521] RAX: ffffffffffffffda RBX: 0000562cd8b5d5b0 RCX:
00007f968239567b
[75627.190764] RDX: 0000000000000000 RSI: 0000562cd8b5c380 RDI:
00000000ffffff9c
[75627.222921] RBP: 0000562cd8b5c2f0 R08: 0000000000000003 R09:
0000000000000000
[75627.255236] R10: 0000000000000000 R11: 0000000000000246 R12:
00007ffcdf66af20
[75627.287435] R13: 0000000000000000 R14: 0000562cd8b5d5b0 R15:
0000000000000000

[75627.326616] Allocated by task 30390:
[75627.342780]  save_stack+0x19/0x80
[75627.357980]  __kasan_kmalloc.constprop.7+0xc1/0xd0
[75627.379553]  kmem_cache_alloc+0xc8/0x300
[75627.397288]  kmem_zone_alloc+0x10a/0x3f0 [xfs]
[75627.417376]  _xfs_buf_alloc+0x56/0x1140 [xfs]
[75627.437051]  xfs_buf_get_map+0x126/0x7c0 [xfs]
[75627.457103]  xfs_buf_read_map+0xb2/0xaa0 [xfs]
[75627.477180]  xfs_trans_read_buf_map+0x6c8/0x12d0 [xfs]
[75627.500420]  xfs_da_read_buf+0x1d9/0x2c0 [xfs]
[75627.520579]  xfs_da3_node_read+0x23/0x80 [xfs]
[75627.540620]  xfs_attr_inactive+0x5c5/0x7b0 [xfs]
[75627.561609]  xfs_inactive+0x4b8/0x5b0 [xfs]
[75627.581541]  xfs_fs_destroy_inode+0x3dc/0xb80 [xfs]
[75627.605628]  destroy_inode+0xbc/0x1a0
[75627.624025]  do_unlinkat+0x451/0x5d0
[75627.641629]  do_syscall_64+0x9f/0x4f0
[75627.658156]  entry_SYSCALL_64_after_hwframe+0x49/0xbe

[75627.687232] Freed by task 30390:
[75627.701882]  save_stack+0x19/0x80
[75627.716821]  __kasan_slab_free+0x125/0x170
[75627.735329]  kmem_cache_free+0xcd/0x400
[75627.752745]  xfs_buf_rele+0x30a/0xcb0 [xfs]
[75627.772731]  xfs_attr3_node_inactive+0x1c7/0x8a0 [xfs]
[75627.797384]  xfs_attr_inactive+0x3e5/0x7b0 [xfs]
[75627.818450]  xfs_inactive+0x4b8/0x5b0 [xfs]
[75627.837455]  xfs_fs_destroy_inode+0x3dc/0xb80 [xfs]
[75627.859765]  destroy_inode+0xbc/0x1a0
[75627.876296]  do_unlinkat+0x451/0x5d0
[75627.892466]  do_syscall_64+0x9f/0x4f0
[75627.909015]  entry_SYSCALL_64_after_hwframe+0x49/0xbe

[75627.938572] The buggy address belongs to the object at ffff88881ffaad80
                which belongs to the cache xfs_buf of size 680
[75627.994075] The buggy address is located 644 bytes inside of
                680-byte region [ffff88881ffaad80, ffff88881ffab028)
[75628.047015] The buggy address belongs to the page:
[75628.069056] page:ffffea00207fea00 refcount:1 mapcount:0
mapping:ffff888098515400 index:0xffff88881ffa9d40 compound_mapcount: 0
[75628.124539] raw: 0057ffffc0010200 dead000000000100 dead000000000122
ffff888098515400
[75628.162598] raw: ffff88881ffa9d40 0000000080270025 00000001ffffffff
0000000000000000
[75628.197491] page dumped because: kasan: bad access detected

[75628.230389] Memory state around the buggy address:
[75628.252072]  ffff88881ffaaf00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
fb
[75628.284801]  ffff88881ffaaf80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
fb
[75628.317587] >ffff88881ffab000: fb fb fb fb fb fc fc fc fc fc fc fc fc fc fc
fc
[75628.350592]                    ^
[75628.364746]  ffff88881ffab080: fc fc fc fc fc fc fc fc fb fb fb fb fb fb fb
fb
[75628.397289]  ffff88881ffab100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
fb
[75628.429955]
==================================================================
[75628.463111] XFS (sda5): Injecting error (false) at file fs/xfs/xfs_buf.c,
line 2119, on filesystem "sda5"
[75628.507525] XFS (sda5): Injecting error (false) at file fs/xfs/xfs_buf.c,
line 2119, on filesystem "sda5"
[75628.551292] XFS (sda5): Injecting error (false) at file fs/xfs/xfs_buf.c,
line 2119, on filesystem "sda5"
[75628.595229] XFS (sda5): Injecting error (false) at file fs/xfs/xfs_buf.c,
line 2119, on filesystem "sda5"
[75628.642924] XFS (sda5): Injecting error (false) at file fs/xfs/xfs_buf.c,
line 2119, on filesystem "sda5"
[75628.814284] XFS (sda3): Unmounting Filesystem
[75629.252213] XFS (sda5): Unmounting Filesystem
[75630.354563] XFS (sda5): Mounting V5 Filesystem
[75630.502015] XFS (sda5): Ending clean mount
[75630.551753] xfs filesystem being mounted at /mnt/xfstests/mnt2 supports
timestamps until 2038 (0x7fffffff)
[75630.629204] XFS (sda5): Unmounting Filesystem

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
