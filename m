Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:47576 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725833AbeHQFhu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Aug 2018 01:37:50 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 9EA3B2B401
        for <linux-xfs@vger.kernel.org>; Fri, 17 Aug 2018 02:36:18 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 200835] XFS hangs in xfs_reclaim_inode()
Date: Fri, 17 Aug 2018 02:36:19 +0000
Message-ID: <bug-200835-201763-gSZgxeX2Zh@https.bugzilla.kernel.org/>
In-Reply-To: <bug-200835-201763@https.bugzilla.kernel.org/>
References: <bug-200835-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=200835

Dave Chinner (david@fromorbit.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |david@fromorbit.com

--- Comment #2 from Dave Chinner (david@fromorbit.com) ---
Memory reclaim is stuck waiting for log forces to complete. The log force is
stuck in both cases waiting for iclog IO completion here:

Aug 04 04:33:45 hpmicroserver kernel: INFO: task kworker/1:2:30142 blocked for
more than 120 seconds.
Aug 04 04:33:45 hpmicroserver kernel:       Not tainted 4.14.52-1-lts #1
Aug 04 04:33:45 hpmicroserver kernel: "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Aug 04 04:33:45 hpmicroserver kernel: kworker/1:2     D    0 30142      2
0x80000000
Aug 04 04:33:45 hpmicroserver kernel: Workqueue: xfs-cil/dm-4
xlog_cil_push_work [xfs]
Aug 04 04:33:45 hpmicroserver kernel: Call Trace:
Aug 04 04:33:45 hpmicroserver kernel:  ? __schedule+0x284/0x870
Aug 04 04:33:45 hpmicroserver kernel:  ? wake_up_q+0x70/0x70
Aug 04 04:33:45 hpmicroserver kernel:  schedule+0x28/0x80
Aug 04 04:33:45 hpmicroserver kernel:  xlog_state_get_iclog_space+0x105/0x2c0
[xfs]
Aug 04 04:33:45 hpmicroserver kernel:  ? wake_up_q+0x70/0x70
Aug 04 04:33:45 hpmicroserver kernel:  xlog_write+0x163/0x6e0 [xfs]
Aug 04 04:33:45 hpmicroserver kernel:  xlog_cil_push+0x21d/0x3c0 [xfs]
Aug 04 04:33:45 hpmicroserver kernel:  process_one_work+0x1e9/0x3b0
Aug 04 04:33:45 hpmicroserver kernel:  worker_thread+0x21f/0x3f0
Aug 04 04:33:45 hpmicroserver kernel:  ? pwq_unbound_release_workfn+0xc0/0xc0
Aug 04 04:33:45 hpmicroserver kernel:  kthread+0x119/0x130
Aug 04 04:33:45 hpmicroserver kernel:  ? __kthread_parkme+0xa0/0xa0
Aug 04 04:33:45 hpmicroserver kernel:  ret_from_fork+0x22/0x40

This indicates the log force is in progress, and it is waiting for log buffer
space to become available to continue writing the in-memory journal to disk.
This means that all log buffers are currently under IO, and the journal is
waiting for IO completion to occur before it can issue more IO to the journal
to make further progress.

This typically occurs when there is an IO problem in the layers below XFS.
Without seeing the full logs, or knowing any other details about your system,
hardware or storage I can't say any more than this.

-Dave.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
