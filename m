Return-Path: <SRS0=rYOu=EB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9771C2D0A3
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 06:10:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3CB7720735
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 06:10:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1770261AbgJZGKp convert rfc822-to-8bit (ORCPT
        <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Oct 2020 02:10:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:55194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390490AbgJZGKp (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 26 Oct 2020 02:10:45 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 209861] New: [xfstests xfs/319] XFS: Assertion failed:
 got.br_startoff > bno, file: fs/xfs/libxfs/xfs_bmap.c, line: 4662
Date:   Mon, 26 Oct 2020 06:10:44 +0000
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
 priority component assigned_to reporter cf_regression attachments.created
Message-ID: <bug-209861-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=209861

            Bug ID: 209861
           Summary: [xfstests xfs/319] XFS: Assertion failed:
                    got.br_startoff > bno, file: fs/xfs/libxfs/xfs_bmap.c,
                    line: 4662
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

Created attachment 293193
  --> https://bugzilla.kernel.org/attachment.cgi?id=293193&action=edit
xfs-319.full

Description of problem:

xfstests xfs/319 hit below assertion failure:
[60457.326969] run fstests xfs/319 at 2020-10-25 00:58:34
[60460.035221] XFS (vda3): Mounting V5 Filesystem
[60460.060337] XFS (vda3): Ending clean mount
[60460.073563] xfs filesystem being mounted at /mnt/xfstests/scratch supports
timestamps until 2038 (0x7fffffff)
[60460.215041] XFS (vda3): Unmounting Filesystem
[60460.982765] XFS (vda3): Mounting V5 Filesystem
[60460.998978] XFS (vda3): Ending clean mount
[60461.008258] xfs filesystem being mounted at /mnt/xfstests/scratch supports
timestamps until 2038 (0x7fffffff)
[60461.518488] XFS (vda3): Injecting error (false) at file
fs/xfs/libxfs/xfs_bmap.c, line 6200, on filesystem "vda3"
[60461.523637] XFS (vda3): xfs_do_force_shutdown(0x8) called from line 504 of
file fs/xfs/libxfs/xfs_defer.c. Return address = fffffe800a571b9c
[60461.526584] XFS (vda3): Corruption of in-memory data detected.  Shutting
down filesystem
[60461.528335] XFS (vda3): Please unmount the filesystem and rectify the
problem(s)
[60461.571960] XFS (vda3): Unmounting Filesystem
[60462.250703] XFS (vda3): Mounting V5 Filesystem
[60462.287614] XFS (vda3): Starting recovery (logdev: internal)
[60462.371743] XFS: Assertion failed: got.br_startoff > bno, file:
fs/xfs/libxfs/xfs_bmap.c, line: 4662
[60462.374383] ------------[ cut here ]------------
[60462.375786] WARNING: CPU: 2 PID: 3666784 at fs/xfs/xfs_message.c:112
assfail+0x6c/0xb0 [xfs]
[60462.377596] Modules linked in: dm_delay ext2 dm_log_writes dm_thin_pool
dm_persistent_data dm_bio_prison sg dm_snapshot dm_bufio ext4 mbcache jbd2 loop
dm_flakey dm_mod rfkill crct10dif_ce ghash_ce sha2_ce sha256_arm64 sha1_ce
sunrpc vfat fat ip_tables xfs libcrc32c virtio_console virtio_blk virtio_net
net_failover failover virtio_mmio [last unloaded: scsi_debug]
[60462.384701] CPU: 2 PID: 3666784 Comm: mount Tainted: G        W        
5.9.0-rc4 #1
[60462.386543] Hardware name: QEMU KVM Virtual Machine, BIOS 0.0.0 02/06/2015
[60462.388294] pstate: 80400005 (Nzcv daif +PAN -UAO BTYPE=--)
[60462.389766] pc : assfail+0x6c/0xb0 [xfs]
[60462.390858] lr : assfail+0x30/0xb0 [xfs]
[60462.391905] sp : fffffc0133377110
[60462.392695] x29: fffffc0133377110 x28: fffffc009c014b00 
[60462.393957] x27: 0000000000000000 x26: fffffc0133373320 
[60462.395233] x25: fffffc010edc8e80 x24: fffffc00c5e82000 
[60462.396505] x23: 0000000000001000 x22: 0000000000000000 
[60462.397756] x21: fffffc009c014b48 x20: 0000000000000000 
[60462.399111] x19: 0000000000000000 x18: 0000000000000000 
[60462.400366] x17: 0000000000000000 x16: fffffe803ce50368 
[60462.401612] x15: 0000000000000000 x14: 1fffff802666ed46 
[60462.402853] x13: fffffe0029c6d489 x12: 1fffff8029c6d488 
[60462.404105] x11: 1fffff8029c6d488 x10: fffffe0029c6d488 
[60462.405364] x9 : fffffe803c667490 x8 : fffffc014e36a447 
[60462.406649] x7 : 00000000f1f1f1f1 x6 : 00000000f2f2f204 
[60462.407967] x5 : 00000000f2f2f2f2 x4 : 00000000ffffffc0 
[60462.409244] x3 : 1fffffd0015307d5 x2 : 0000000000000004 
[60462.410513] x1 : 0000000000000000 x0 : fffffe800a983000 
[60462.411905] Call trace:
[60462.412635]  assfail+0x6c/0xb0 [xfs]
[60462.413628]  xfs_bmapi_remap+0x590/0x608 [xfs]
[60462.414909]  xfs_bmap_finish_one+0x644/0xab0 [xfs]
[60462.416193]  xfs_bui_item_recover+0xaa8/0x15d0 [xfs]
[60462.417503]  xlog_recover_process_intents+0x230/0x898 [xfs]
[60462.419041]  xlog_recover_finish+0x50/0x1f0 [xfs]
[60462.420307]  xfs_log_mount_finish+0xd8/0x2b8 [xfs]
[60462.421696]  xfs_mountfs+0xf54/0x1828 [xfs]
[60462.422874]  xfs_fc_fill_super+0x880/0x1618 [xfs]
[60462.424180]  get_tree_bdev+0x39c/0x5f8
[60462.425273]  xfs_fc_get_tree+0x1c/0x28 [xfs]
[60462.426292]  vfs_get_tree+0x7c/0x2b8
[60462.427128]  path_mount+0xd00/0x19d0
[60462.428051]  do_mount+0xe8/0x100
[60462.428816]  __arm64_sys_mount+0x154/0x198
[60462.429781]  do_el0_svc+0x1c4/0x3c0
[60462.430619]  el0_sync_handler+0xf8/0x124
[60462.431639]  el0_sync+0x140/0x180
[60462.432432] irq event stamp: 8356
[60462.433290] hardirqs last  enabled at (8355): [<fffffe803c3df1f0>]
console_unlock.part.13+0x9a0/0xdd8
[60462.435526] hardirqs last disabled at (8356): [<fffffe803c189954>]
debug_exception_enter+0x12c/0x1d8
[60462.438190] softirqs last  enabled at (8140): [<fffffe800a645768>]
xfs_buf_find+0xf68/0x2ce8 [xfs]
[60462.440392] softirqs last disabled at (8138): [<fffffe800a645010>]
xfs_buf_find+0x810/0x2ce8 [xfs]
[60462.442590] ---[ end trace 2cf8baaabed4ba6a ]---
[60462.443932] XFS: Assertion failed: got.br_startoff - bno >= len, file:
fs/xfs/libxfs/xfs_bmap.c, line: 4663
[60462.446113] ------------[ cut here ]------------
[60462.447312] WARNING: CPU: 2 PID: 3666784 at fs/xfs/xfs_message.c:112
assfail+0x6c/0xb0 [xfs]
...
...

Kernel HEAD:
xfs-5.10-merge-7 of xfs-linux for-next branch

xfs/319.full get more information, refer to the attachment.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
