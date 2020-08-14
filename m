Return-Path: <SRS0=kyg5=BY=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=BAYES_00,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0922C433DF
	for <linux-xfs@archiver.kernel.org>; Fri, 14 Aug 2020 18:43:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C3823205CB
	for <linux-xfs@archiver.kernel.org>; Fri, 14 Aug 2020 18:43:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726636AbgHNSnT convert rfc822-to-8bit (ORCPT
        <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 14 Aug 2020 14:43:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:50124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726541AbgHNSnT (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 14 Aug 2020 14:43:19 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 208907] New: [fstests generic/074 on xfs]: 5.7.10 fails with a
 hung task on
Date:   Fri, 14 Aug 2020 18:43:18 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: mcgrof@kernel.org
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression
Message-ID: <bug-208907-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=208907

            Bug ID: 208907
           Summary: [fstests generic/074 on xfs]: 5.7.10 fails with a hung
                    task on
           Product: File System
           Version: 2.5
    Kernel Version: 5.7.10
          Hardware: x86-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: XFS
          Assignee: filesystem_xfs@kernel-bugs.kernel.org
          Reporter: mcgrof@kernel.org
        Regression: No

Should be extremely easy to reproduce in 5 commands with kdevops [0], leave
everything with the defaults, and then just enable fstests.

[0] https://github.com/mcgrof/kdevops

make bringup
make fstests

Just ssh to kdevops-xfs and run:

cd /var/lib/xfstests/
./gendisks.sh -m
./check generic/074

Aug 14 18:27:34 kdevops-xfs-dev kernel: XFS (loop16): Mounting V5 Filesystem
Aug 14 18:27:34 kdevops-xfs-dev kernel: XFS (loop16): Ending clean mount
Aug 14 18:27:34 kdevops-xfs-dev kernel: xfs filesystem being mounted at
/media/test supports timestamps until 2038 (0x7fffffff)
Aug 14 18:28:16 kdevops-xfs-dev kernel: nvme nvme1: I/O 128 QID 2 timeout,
aborting
Aug 14 18:28:16 kdevops-xfs-dev kernel: nvme nvme1: Abort status: 0x4001
Aug 14 18:28:47 kdevops-xfs-dev kernel: nvme nvme1: I/O 128 QID 2 timeout,
reset controller
Aug 14 18:28:54 kdevops-xfs-dev kernel: sched: RT throttling activated
Aug 14 18:31:12 kdevops-xfs-dev kernel: INFO: task xfsaild/nvme1n1:289 blocked
for more than 120 seconds.
Aug 14 18:31:12 kdevops-xfs-dev kernel:       Not tainted 5.7.0-2-amd64 #1
Debian 5.7.10-1
Aug 14 18:31:12 kdevops-xfs-dev kernel: "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Aug 14 18:31:12 kdevops-xfs-dev kernel: xfsaild/nvme1n1 D    0   289      2
0x80004000
Aug 14 18:31:12 kdevops-xfs-dev kernel: Call Trace:
Aug 14 18:31:12 kdevops-xfs-dev kernel:  __schedule+0x2da/0x770
Aug 14 18:31:12 kdevops-xfs-dev kernel:  ? xlog_cil_force_lsn+0xc0/0x220 [xfs]
Aug 14 18:31:12 kdevops-xfs-dev kernel:  schedule+0x4a/0xb0
Aug 14 18:31:12 kdevops-xfs-dev kernel:  xlog_wait_on_iclog+0x113/0x130 [xfs]
Aug 14 18:31:12 kdevops-xfs-dev kernel:  ? wake_up_q+0xa0/0xa0
Aug 14 18:31:12 kdevops-xfs-dev kernel:  xfsaild+0x1bd/0x810 [xfs]
Aug 14 18:31:12 kdevops-xfs-dev kernel:  ? __switch_to+0x80/0x3c0
Aug 14 18:31:12 kdevops-xfs-dev kernel:  kthread+0xf9/0x130
Aug 14 18:31:12 kdevops-xfs-dev kernel:  ? xfs_trans_ail_cursor_first+0x80/0x80
[xfs]
Aug 14 18:31:12 kdevops-xfs-dev kernel:  ? kthread_park+0x90/0x90
Aug 14 18:31:12 kdevops-xfs-dev kernel:  ret_from_fork+0x35/0x40
Aug 14 18:31:12 kdevops-xfs-dev kernel: INFO: task loop16:912 blocked for more
than 120 seconds.
Aug 14 18:31:12 kdevops-xfs-dev kernel:       Not tainted 5.7.0-2-amd64 #1
Debian 5.7.10-1
Aug 14 18:31:12 kdevops-xfs-dev kernel: "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Aug 14 18:31:12 kdevops-xfs-dev kernel: loop16          D    0   912      2
0x80004000
Aug 14 18:31:12 kdevops-xfs-dev kernel: Call Trace:
Aug 14 18:31:12 kdevops-xfs-dev kernel:  __schedule+0x2da/0x770
Aug 14 18:31:12 kdevops-xfs-dev kernel:  ? xlog_cil_force_lsn+0xc0/0x220 [xfs]
Aug 14 18:31:12 kdevops-xfs-dev kernel:  schedule+0x4a/0xb0
Aug 14 18:31:12 kdevops-xfs-dev kernel:  xlog_wait_on_iclog+0x113/0x130 [xfs]
Aug 14 18:31:12 kdevops-xfs-dev kernel:  ? wake_up_q+0xa0/0xa0
Aug 14 18:31:12 kdevops-xfs-dev kernel:  xfsaild+0x1bd/0x810 [xfs]
Aug 14 18:31:12 kdevops-xfs-dev kernel:  ? __switch_to+0x80/0x3c0
Aug 14 18:31:12 kdevops-xfs-dev kernel:  kthread+0xf9/0x130
Aug 14 18:31:12 kdevops-xfs-dev kernel:  ? xfs_trans_ail_cursor_first+0x80/0x80
[xfs]
Aug 14 18:31:12 kdevops-xfs-dev kernel:  ? kthread_park+0x90/0x90
Aug 14 18:31:12 kdevops-xfs-dev kernel:  ret_from_fork+0x35/0x40
Aug 14 18:31:12 kdevops-xfs-dev kernel: INFO: task loop16:912 blocked for more
than 120 seconds.
Aug 14 18:31:12 kdevops-xfs-dev kernel:       Not tainted 5.7.0-2-amd64 #1
Debian 5.7.10-1
Aug 14 18:31:12 kdevops-xfs-dev kernel: "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Aug 14 18:31:12 kdevops-xfs-dev kernel: loop16          D    0   912      2
0x80004000
Aug 14 18:31:12 kdevops-xfs-dev kernel: Call Trace:
Aug 14 18:31:12 kdevops-xfs-dev kernel:  __schedule+0x2da/0x770
Aug 14 18:31:12 kdevops-xfs-dev kernel:  schedule+0x4a/0xb0
Aug 14 18:31:12 kdevops-xfs-dev kernel:  xlog_wait_on_iclog+0x113/0x130 [xfs]
Aug 14 18:31:12 kdevops-xfs-dev kernel:  ? wake_up_q+0xa0/0xa0
Aug 14 18:31:12 kdevops-xfs-dev kernel:  __xfs_log_force_lsn+0x10a/0x1d0 [xfs]
Aug 14 18:31:12 kdevops-xfs-dev kernel:  ? xfs_file_fsync+0x1f4/0x230 [xfs]
Aug 14 18:31:12 kdevops-xfs-dev kernel:  xfs_log_force_lsn+0x91/0x120 [xfs]
Aug 14 18:31:12 kdevops-xfs-dev kernel:  xfs_file_fsync+0x1f4/0x230 [xfs]
Aug 14 18:31:12 kdevops-xfs-dev kernel:  ? __switch_to_asm+0x34/0x70
Aug 14 18:31:12 kdevops-xfs-dev kernel:  loop_queue_work+0x47d/0xa50 [loop]
Aug 14 18:31:12 kdevops-xfs-dev kernel:  ? __switch_to+0x80/0x3c0
Aug 14 18:31:12 kdevops-xfs-dev kernel:  ? __schedule+0x2e2/0x770
Aug 14 18:31:12 kdevops-xfs-dev kernel:  kthread_worker_fn+0x73/0x1d0
Aug 14 18:31:12 kdevops-xfs-dev kernel:  kthread+0xf9/0x130
Aug 14 18:31:12 kdevops-xfs-dev kernel:  ? loop_info64_to_compat+0x220/0x220
[loop]
Aug 14 18:31:12 kdevops-xfs-dev kernel:  ? kthread_park+0x90/0x90
Aug 14 18:31:12 kdevops-xfs-dev kernel:  ret_from_fork+0x35/0x40
Aug 14 18:31:12 kdevops-xfs-dev kernel: INFO: task umount:2212 blocked for more
than 120 seconds.
Aug 14 18:31:12 kdevops-xfs-dev kernel:       Not tainted 5.7.0-2-amd64 #1
Debian 5.7.10-1
Aug 14 18:31:12 kdevops-xfs-dev kernel: "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Aug 14 18:31:12 kdevops-xfs-dev kernel: umount          D    0  2212   2208
0x00004000

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
