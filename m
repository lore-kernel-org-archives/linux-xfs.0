Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9214EC56201
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Nov 2020 05:53:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 395FA2076C
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Nov 2020 05:53:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728814AbgKXFxL convert rfc822-to-8bit (ORCPT
        <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Nov 2020 00:53:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:57484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729002AbgKXFxL (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 24 Nov 2020 00:53:11 -0500
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 210341] New: XFS (dm-3): Internal error xfs_trans_cancel at
 line 1041 of file fs/xfs/xfs_trans.c.
Date:   Tue, 24 Nov 2020 05:53:09 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: blocking
X-Bugzilla-Who: lokendra.rathour@hsc.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression attachments.created
Message-ID: <bug-210341-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=210341

            Bug ID: 210341
           Summary: XFS (dm-3): Internal error xfs_trans_cancel at line
                    1041 of file fs/xfs/xfs_trans.c.
           Product: File System
           Version: 2.5
    Kernel Version: 4.18.0-147
          Hardware: Intel
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: blocking
          Priority: P1
         Component: XFS
          Assignee: filesystem_xfs@kernel-bugs.kernel.org
          Reporter: lokendra.rathour@hsc.com
        Regression: No

Created attachment 293797
  --> https://bugzilla.kernel.org/attachment.cgi?id=293797&action=edit
Detailed logs as shown above

Getting errror for xfs file system :

2020-11-11T11:55:16.809 controller-1 kernel: alert [419472.614847] XFS (dm-3):
xfs_dabuf_map: bno 8388608 dir: inode 122425344
2020-11-11T11:55:16.809 controller-1 kernel: alert [419472.621963] XFS (dm-3):
[00] br_startoff 8388608 br_startblock -2 br_blockcount 1 br_state 0
2020-11-11T11:55:16.823 controller-1 kernel: alert [419472.630908] XFS (dm-3):
Internal error xfs_da_do_buf(1) at line 2558 of file
fs/xfs/libxfs/xfs_da_btree.c.  Caller xfs_da_read_buf+0x6c/0x120 [xfs]
2020-11-11T11:55:16.824 controller-1 kernel: warning [419472.644671] CPU: 1
PID: 83210 Comm: heat-manage Kdump: loaded Tainted: G           O     ---------
-t - 4.18.0-147.3.1.el8_1.7.tis.x86_64 #1
2020-11-11T11:55:16.824 controller-1 kernel: warning [419472.644672] Hardware
name: HPE ProLiant DL360 Gen10/ProLiant DL360 Gen10, BIOS U32 04/18/2019
2020-11-11T11:55:16.824 controller-1 kernel: warning [419472.644673] Call
Trace:
2020-11-11T11:55:16.824 controller-1 kernel: warning [419472.644679] 
dump_stack+0x5a/0x73
2020-11-11T11:55:16.824 controller-1 kernel: warning [419472.644708] 
xfs_dabuf_map.constprop.18+0x166/0x380 [xfs]
2020-11-11T11:55:16.824 controller-1 kernel: warning [419472.644725] 
xfs_da_read_buf+0x6c/0x120 [xfs]
2020-11-11T11:55:16.824 controller-1 kernel: warning [419472.644739] 
xfs_da3_node_read+0x1e/0x100 [xfs]
2020-11-11T11:55:16.824 controller-1 kernel: warning [419472.644754] 
xfs_da3_node_lookup_int+0x6e/0x340 [xfs]
2020-11-11T11:55:16.824 controller-1 kernel: warning [419472.644775]  ?
kmem_zone_alloc+0x95/0x100 [xfs]
2020-11-11T11:55:16.824 controller-1 kernel: warning [419472.644791] 
xfs_dir2_node_removename+0x4e/0x610 [xfs]
2020-11-11T11:55:16.824 controller-1 kernel: warning [419472.644806]  ?
xfs_bmap_last_extent+0x5c/0xa0 [xfs]
2020-11-11T11:55:16.824 controller-1 kernel: warning [419472.644821]  ?
xfs_bmap_last_offset+0x54/0xc0 [xfs]
2020-11-11T11:55:16.824 controller-1 kernel: warning [419472.644841]  ?
kmem_alloc+0x96/0x100 [xfs]
2020-11-11T11:55:16.824 controller-1 kernel: warning [419472.644858] 
xfs_dir_removename+0x16d/0x180 [xfs]
2020-11-11T11:55:16.824 controller-1 kernel: warning [419472.644879] 
xfs_remove+0x250/0x300 [xfs]
2020-11-11T11:55:16.824 controller-1 kernel: warning [419472.644900] 
xfs_vn_unlink+0x55/0xa0 [xfs]
2020-11-11T11:55:16.824 controller-1 kernel: warning [419472.644904] 
vfs_unlink+0xe1/0x1a0
2020-11-11T11:55:16.824 controller-1 kernel: warning [419472.644909] 
ovl_do_remove+0x381/0x490 [overlay]
2020-11-11T11:55:16.824 controller-1 kernel: warning [419472.644912] 
vfs_unlink+0xe1/0x1a0
2020-11-11T11:55:16.824 controller-1 kernel: warning [419472.644914] 
do_unlinkat+0x25f/0x2b0
2020-11-11T11:55:16.824 controller-1 kernel: warning [419472.644917] 
do_syscall_64+0x5b/0x1c0
2020-11-11T11:55:16.824 controller-1 kernel: warning [419472.644919] 
entry_SYSCALL_64_after_hwframe+0x65/0xca
2020-11-11T11:55:16.824 controller-1 kernel: warning [419472.644921] RIP:
0033:0x7f7334c08147
2020-11-11T11:55:16.824 controller-1 kernel: warning [419472.644923] Code: 48
3d 00 f0 ff ff 77 03 48 98 c3 48 8b 15 21 5d 2d 00 f7 d8 64 89 02 48 83 c8 ff
eb eb 66 0f 1f 44 00 00 b8 57 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b
0d f9 5c 2d 00 f7 d8 64 89 01 48

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
