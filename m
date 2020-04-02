Return-Path: <SRS0=h0IP=5S=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15498C18E5B
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Apr 2020 00:15:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D3538206D3
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Apr 2020 00:15:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732872AbgDBAPa convert rfc822-to-8bit (ORCPT
        <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Apr 2020 20:15:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:50696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732752AbgDBAPa (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 1 Apr 2020 20:15:30 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 207053] fsfreeze deadlock on XFS (the FIFREEZE ioctl and
 subsequent FITHAW hang indefinitely)
Date:   Thu, 02 Apr 2020 00:15:29 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: david@fromorbit.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-207053-201763-pBbHaft3ls@https.bugzilla.kernel.org/>
In-Reply-To: <bug-207053-201763@https.bugzilla.kernel.org/>
References: <bug-207053-201763@https.bugzilla.kernel.org/>
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

--- Comment #1 from Dave Chinner (david@fromorbit.com) ---
On Wed, Apr 01, 2020 at 07:02:57PM +0000, bugzilla-daemon@bugzilla.kernel.org
wrote:
> When we upgraded from kernel 4.14.146 to kernel 4.19.75, we began to
> experience
> frequent deadlocks from our cronjobs that freeze the filesystem for
> snapshotting.

Probably commit d6b636ebb1c9 ("xfs: halt auto-reclamation activities
while rebuilding rmap") in 4.18, but that fixes a bug that allowed
reaping functions to attempt to modify the filesystem while it was
frozen...

> The fsfreeze stack shows:
> # cat /proc/33256/stack 
> [<0>] __flush_work+0x177/0x1b0
> [<0>] __cancel_work_timer+0x12b/0x1b0
> [<0>] xfs_stop_block_reaping+0x15/0x30 [xfs]
> [<0>] xfs_fs_freeze+0x15/0x40 [xfs]
> [<0>] freeze_super+0xc8/0x190
> [<0>] do_vfs_ioctl+0x510/0x630
> [<0>] ksys_ioctl+0x70/0x80
> [<0>] __x64_sys_ioctl+0x16/0x20
> [<0>] do_syscall_64+0x4e/0x100
> [<0>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

This indicates that the reaping worker is still busy doing work. It
needs to finish before the freeze will continue to make progress.
So either the system is still doing work, or the kworker has blocked
somewhere.

What is the dmesg output of 'echo w > /prox/sysrq-trigger'?

Cheers,

Dave.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
