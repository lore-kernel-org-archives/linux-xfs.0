Return-Path: <SRS0=BKGZ=5R=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 091F4C43331
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Apr 2020 19:02:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C5259206EB
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Apr 2020 19:02:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727661AbgDATC6 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Apr 2020 15:02:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:37448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726785AbgDATC6 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 1 Apr 2020 15:02:58 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 207053] New: fsfreeze deadlock on XFS (the FIFREEZE ioctl and
 subsequent FITHAW hang indefinitely)
Date:   Wed, 01 Apr 2020 19:02:57 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: paulfurtado91@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression
Message-ID: <bug-207053-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=207053

            Bug ID: 207053
           Summary: fsfreeze deadlock on XFS (the FIFREEZE ioctl and
                    subsequent FITHAW hang indefinitely)
           Product: File System
           Version: 2.5
    Kernel Version: 4.19.75, 5.4.20
          Hardware: x86-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: XFS
          Assignee: filesystem_xfs@kernel-bugs.kernel.org
          Reporter: paulfurtado91@gmail.com
        Regression: No

When we upgraded from kernel 4.14.146 to kernel 4.19.75, we began to experience
frequent deadlocks from our cronjobs that freeze the filesystem for
snapshotting.

The fsfreeze stack shows:
# cat /proc/33256/stack 
[<0>] __flush_work+0x177/0x1b0
[<0>] __cancel_work_timer+0x12b/0x1b0
[<0>] xfs_stop_block_reaping+0x15/0x30 [xfs]
[<0>] xfs_fs_freeze+0x15/0x40 [xfs]
[<0>] freeze_super+0xc8/0x190
[<0>] do_vfs_ioctl+0x510/0x630
[<0>] ksys_ioctl+0x70/0x80
[<0>] __x64_sys_ioctl+0x16/0x20
[<0>] do_syscall_64+0x4e/0x100
[<0>] entry_SYSCALL_64_after_hwframe+0x44/0xa9


The fsfreeze -u stack shows:
# cat /proc/37753/stack 
[<0>] rwsem_down_write_slowpath+0x257/0x510
[<0>] thaw_super+0x12/0x20
[<0>] do_vfs_ioctl+0x609/0x630
[<0>] ksys_ioctl+0x70/0x80
[<0>] __x64_sys_ioctl+0x16/0x20
[<0>] do_syscall_64+0x4e/0x100
[<0>] entry_SYSCALL_64_after_hwframe+0x44/0xa9


Echoing "j" into /proc/sysrq-trigger to emergency thaw all filesystems doesn't
solve this either. We're hitting this bug many times per week, so if there's
any more debug information you need that we could turn on, let us know. Thanks!

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
