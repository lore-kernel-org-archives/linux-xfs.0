Return-Path: <SRS0=4VMi=2H=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97C06C43603
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Dec 2019 12:03:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6565B207FF
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Dec 2019 12:03:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726709AbfLQMDQ convert rfc822-to-8bit (ORCPT
        <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Dec 2019 07:03:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:35836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726608AbfLQMDP (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 17 Dec 2019 07:03:15 -0500
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 205833] fsfreeze blocks close(fd) on xfs sometimes
Date:   Tue, 17 Dec 2019 12:03:14 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: bfoster@redhat.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-205833-201763-5VNjAN6lsV@https.bugzilla.kernel.org/>
In-Reply-To: <bug-205833-201763@https.bugzilla.kernel.org/>
References: <bug-205833-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=205833

--- Comment #3 from bfoster@redhat.com ---
On Tue, Dec 17, 2019 at 09:34:34AM +0000, bugzilla-daemon@bugzilla.kernel.org
wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=205833
> 
> --- Comment #2 from Stefan @dns2utf8 Schindler (kernel.org@estada.ch) ---
> Hi Brian
> 
> Thank you! Here is the stack of a blocked `tail 0.txt` process:
> 
> cat /proc/276/stack
> [<0>] call_rwsem_down_read_failed+0x18/0x30
> [<0>] __percpu_down_read+0x58/0x80
> [<0>] __sb_start_write+0x65/0x70
> [<0>] xfs_trans_alloc+0xec/0x130 [xfs]
> [<0>] xfs_free_eofblocks+0x12a/0x1e0 [xfs]
> [<0>] xfs_release+0x144/0x170 [xfs]
> [<0>] xfs_file_release+0x15/0x20 [xfs]
> [<0>] __fput+0xea/0x220
> [<0>] ____fput+0xe/0x10
> [<0>] task_work_run+0x9d/0xc0
> [<0>] ptrace_notify+0x84/0x90
> [<0>] tracehook_report_syscall_exit+0x90/0xd0
> [<0>] syscall_slow_exit_work+0x50/0xd0
> [<0>] do_syscall_64+0x12b/0x130
> [<0>] entry_SYSCALL_64_after_hwframe+0x3d/0xa2
> [<0>] 0xffffffffffffffff
> 
> Your explanation matches the behaviour I see on the system.
> 
> If there was a patch, do you think it would get backported or just stay in
> mainline and ship with the regular releases?
> 

There was a patch, but it was RFC and hadn't been merged because IIRC
more investigation/testing was required to evaluate side effects. For
reference, the last post I see is the one below. In particular, patch 3
bypasses EOF block truncation from read-only file descriptors (I believe
the file writer task would still block).

https://marc.info/?l=linux-xfs&m=154951612101291&w=2

Based on the stack above, note that this is (at least for the time
being) expected behavior on XFS.

Brian

> Best,
> Stefan
> 
> -- 
> You are receiving this mail because:
> You are watching the assignee of the bug.
>

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
