Return-Path: <SRS0=kniB=ZV=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D45EAC43215
	for <linux-xfs@archiver.kernel.org>; Fri, 29 Nov 2019 11:47:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A11B621774
	for <linux-xfs@archiver.kernel.org>; Fri, 29 Nov 2019 11:47:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726793AbfK2LrX convert rfc822-to-8bit (ORCPT
        <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 29 Nov 2019 06:47:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:47810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726791AbfK2LrW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 29 Nov 2019 06:47:22 -0500
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 205703] New: [xfstests generic/461]: BUG: KASAN: use-after-free
 in iomap_finish_ioend+0x58c/0x5c0
Date:   Fri, 29 Nov 2019 11:47:21 +0000
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
Message-ID: <bug-205703-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=205703

            Bug ID: 205703
           Summary: [xfstests generic/461]: BUG: KASAN: use-after-free in
                    iomap_finish_ioend+0x58c/0x5c0
           Product: File System
           Version: 2.5
    Kernel Version: linux 5.4+ with xfs-5.5-merge-15 and
                    iomap-5.5-merge-11
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

generic/461 hit a KASAN BUG on latest upstream mainline kernel with
xfs-5.5-merge-15 and iomap-5.5-merge-11, as below:

FSTYP         -- xfs (non-debug)
PLATFORM      -- Linux/aarch64 hpe-apollo-cn99xx-19 5.4.0+ #1 SMP Wed Nov 27
00:00:45 EST 2019
MKFS_OPTIONS  -- -f -bsize=4096 /dev/sda5
MOUNT_OPTIONS -- -o context=system_u:object_r:nfs_t:s0 /dev/sda5
/mnt/xfstests/mnt2

generic/461 24s ... _check_dmesg: something found in dmesg (see
/var/lib/xfstests/results//generic/461.dmesg)

Ran: generic/461
Failures: generic/461
Failed 1 of 1 tests

# cat generic/461.full
meta-data=/dev/sda5              isize=512    agcount=4, agsize=983040 blks
         =                       sectsz=4096  attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=0
         =                       reflink=1
data     =                       bsize=4096   blocks=3932160, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=2560, version=2
         =                       sectsz=4096  sunit=1 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

# cat generic/461.dmesg
[20546.220860] run fstests generic/461 at 2019-11-27 06:02:10
[20547.342821] XFS (sda5): Mounting V5 Filesystem
[20547.380750] XFS (sda5): Ending clean mount
[20547.389760] xfs filesystem being mounted at /mnt/xfstests/mnt2 supports
timestamps until 2038 (0x7fffffff)
[20547.407045] XFS (sda5): User initiated shutdown received. Shutting down
filesystem
[20547.424167] XFS (sda5): Unmounting Filesystem
[20548.307193] XFS (sda5): Mounting V5 Filesystem
[20548.355535] XFS (sda5): Ending clean mount
[20548.365016] xfs filesystem being mounted at /mnt/xfstests/mnt2 supports
timestamps until 2038 (0x7fffffff)
[20563.616817] XFS (sda5): User initiated shutdown received. Shutting down
filesystem
[20563.620286]
==================================================================
[20563.631624] BUG: KASAN: use-after-free in iomap_finish_ioend+0x58c/0x5c0
[20563.638319] Read of size 8 at addr fffffc0c54a36928 by task
kworker/123:2/22184

[20563.647107] CPU: 123 PID: 22184 Comm: kworker/123:2 Not tainted 5.4.0+ #1
[20563.653887] Hardware name: HPE Apollo 70             /C01_APACHE_MB        
, BIOS L50_5.13_1.11 06/18/2019
[20563.664499] Workqueue: xfs-conv/sda5 xfs_end_io [xfs]
[20563.669547] Call trace:
[20563.671993]  dump_backtrace+0x0/0x370
[20563.675648]  show_stack+0x1c/0x28
[20563.678958]  dump_stack+0x138/0x1b0
[20563.682455]  print_address_description.isra.9+0x60/0x378
[20563.687759]  __kasan_report+0x1a4/0x2a8
[20563.691587]  kasan_report+0xc/0x18
[20563.694985]  __asan_report_load8_noabort+0x18/0x20
[20563.699769]  iomap_finish_ioend+0x58c/0x5c0
[20563.703944]  iomap_finish_ioends+0x110/0x270
[20563.708396]  xfs_end_ioend+0x168/0x598 [xfs]
[20563.712823]  xfs_end_io+0x1e0/0x2d0 [xfs]
[20563.716834]  process_one_work+0x7f0/0x1ac8
[20563.720922]  worker_thread+0x334/0xae0
[20563.724664]  kthread+0x2c4/0x348
[20563.727889]  ret_from_fork+0x10/0x18

[20563.732941] Allocated by task 83403:
[20563.736512]  save_stack+0x24/0xb0
[20563.739820]  __kasan_kmalloc.isra.9+0xc4/0xe0
[20563.744169]  kasan_slab_alloc+0x14/0x20
[20563.747998]  slab_post_alloc_hook+0x50/0xa8
[20563.752173]  kmem_cache_alloc+0x154/0x330
[20563.756185]  mempool_alloc_slab+0x20/0x28
[20563.760186]  mempool_alloc+0xf4/0x2a8
[20563.763845]  bio_alloc_bioset+0x2d0/0x448
[20563.767849]  iomap_writepage_map+0x4b8/0x1740
[20563.772198]  iomap_do_writepage+0x200/0x8d0
[20563.776380]  write_cache_pages+0x8a4/0xed8
[20563.780469]  iomap_writepages+0x4c/0xb0
[20563.784463]  xfs_vm_writepages+0xf8/0x148 [xfs]
[20563.788989]  do_writepages+0xc8/0x218
[20563.792658]  __writeback_single_inode+0x168/0x18f8
[20563.797441]  writeback_sb_inodes+0x370/0xd30
[20563.801703]  wb_writeback+0x2d4/0x1270
[20563.805446]  wb_workfn+0x344/0x1178
[20563.808928]  process_one_work+0x7f0/0x1ac8
[20563.813016]  worker_thread+0x334/0xae0
[20563.816757]  kthread+0x2c4/0x348
[20563.819979]  ret_from_fork+0x10/0x18

[20563.825028] Freed by task 22184:
[20563.828251]  save_stack+0x24/0xb0
[20563.831559]  __kasan_slab_free+0x10c/0x180
[20563.835648]  kasan_slab_free+0x10/0x18
[20563.839389]  slab_free_freelist_hook+0xb4/0x1c0
[20563.843912]  kmem_cache_free+0x8c/0x3e8
[20563.847745]  mempool_free_slab+0x20/0x28
[20563.851660]  mempool_free+0xd4/0x2f8
[20563.855231]  bio_free+0x33c/0x518
[20563.858537]  bio_put+0xb8/0x100
[20563.861672]  iomap_finish_ioend+0x168/0x5c0
[20563.865847]  iomap_finish_ioends+0x110/0x270
[20563.870328]  xfs_end_ioend+0x168/0x598 [xfs]
[20563.874751]  xfs_end_io+0x1e0/0x2d0 [xfs]
[20563.878755]  process_one_work+0x7f0/0x1ac8
[20563.882844]  worker_thread+0x334/0xae0
[20563.886584]  kthread+0x2c4/0x348
[20563.889804]  ret_from_fork+0x10/0x18

[20563.894855] The buggy address belongs to the object at fffffc0c54a36900
                which belongs to the cache bio-1 of size 248
[20563.906844] The buggy address is located 40 bytes inside of
                248-byte region [fffffc0c54a36900, fffffc0c54a369f8)
[20563.918485] The buggy address belongs to the page:
[20563.923269] page:ffffffff82f528c0 refcount:1 mapcount:0
mapping:fffffc8e4ba31900 index:0xfffffc0c54a33300
[20563.932832] raw: 17ffff8000000200 ffffffffa3060100 0000000700000007
fffffc8e4ba31900
[20563.940567] raw: fffffc0c54a33300 0000000080aa0042 00000001ffffffff
0000000000000000
[20563.948300] page dumped because: kasan: bad access detected

[20563.955345] Memory state around the buggy address:
[20563.960129]  fffffc0c54a36800: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
fc
[20563.967342]  fffffc0c54a36880: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
fc
[20563.974554] >fffffc0c54a36900: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
fb
[20563.981766]                                   ^
[20563.986288]  fffffc0c54a36980: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
fc
[20563.993501]  fffffc0c54a36a00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
fc
[20564.000713]
==================================================================
[20564.008173] sda5: writeback error on inode 16819694, offset 6569984, sector
117547992
[20564.008272] sda5: writeback error on inode 27891, offset 60567552, sector
101805992
[20569.967881] XFS (sda5): Unmounting Filesystem
[20570.481702] XFS (sda4): Unmounting Filesystem

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
