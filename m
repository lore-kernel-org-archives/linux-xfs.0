Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90E55C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Oct 2021 16:31:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 64E1D61354
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Oct 2021 16:31:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229941AbhJTQdX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 Oct 2021 12:33:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:35188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229817AbhJTQdW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 20 Oct 2021 12:33:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 04A8261260
        for <linux-xfs@vger.kernel.org>; Wed, 20 Oct 2021 16:31:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634747468;
        bh=phsWdXJ85cSTZE4o11xlO4Q90OIiUfxV088yw/k7XM0=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=W6xVqXKMTCZswOB3+QidPg5qb3EsYQwP/hgjGMzn3eH99ccOs6JtVTKaN3/pmAHAW
         hDC5NTWM58h7Fis5PSpYWYTNaSD++JDltivcs3OLhglLBdeJm4JdbN0oIHNp4qS9ib
         umqnErsWG1tn75rgbZs+Bs5Ot6DqFPao9jPoXp+zjW1UwGKFJO3BXwF9YLtV7OWWcb
         kQsc3l+khqqAXMz7vkkg+rrIinmHI7e2W7B7AjOgW6gppgy080KP+PiSPgJ31DDft8
         bs/AbgfgJODm03LRYUiTS9p2hwONonP5Y71nn/6UeyX6reGN4pBYo/Udw7PUK+QX7C
         Rq39fSjNsjFWw==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 214767] xfs seems to hang due to race condition? maybe related
 to (gratuitous) thaw.
Date:   Wed, 20 Oct 2021 16:31:07 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: ct@flyingcircus.io
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-214767-201763-GZw49KOx95@https.bugzilla.kernel.org/>
In-Reply-To: <bug-214767-201763@https.bugzilla.kernel.org/>
References: <bug-214767-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D214767

--- Comment #3 from Christian Theune (ct@flyingcircus.io) ---
I have another machine that managed to break free after 20 minutes which did
around 3 thaws around that time:

Oct 20 18:05:22 pixometerstag04 kernel: INFO: task nix-daemon:1387736 block=
ed
for more than 1228 seconds.
Oct 20 18:05:22 pixometerstag04 kernel:       Not tainted 5.10.70 #1-NixOS
Oct 20 18:05:22 pixometerstag04 kernel: "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Oct 20 18:05:22 pixometerstag04 kernel: task:nix-daemon      state:D stack:=
=20=20=20
0 pid:1387736 ppid:  1356 flags:0x00000000
Oct 20 18:05:22 pixometerstag04 kernel: Call Trace:
Oct 20 18:05:22 pixometerstag04 kernel:  __schedule+0x271/0x860
Oct 20 18:05:22 pixometerstag04 kernel:  schedule+0x46/0xb0
Oct 20 18:05:22 pixometerstag04 kernel:  xfs_log_commit_cil+0x6a4/0x800 [xf=
s]
Oct 20 18:05:22 pixometerstag04 kernel:  ? wake_up_q+0xa0/0xa0
Oct 20 18:05:22 pixometerstag04 kernel:  __xfs_trans_commit+0x9d/0x310 [xfs]
Oct 20 18:05:22 pixometerstag04 kernel:  xfs_create+0x472/0x560 [xfs]
Oct 20 18:05:22 pixometerstag04 kernel:  xfs_generic_create+0x247/0x320 [xf=
s]
Oct 20 18:05:22 pixometerstag04 kernel:  ? xfs_lookup+0x55/0x100 [xfs]
Oct 20 18:05:22 pixometerstag04 kernel:  path_openat+0xdd7/0x1070
Oct 20 18:05:22 pixometerstag04 kernel:  do_filp_open+0x88/0x130
Oct 20 18:05:22 pixometerstag04 kernel:  ? getname_flags.part.0+0x29/0x1a0
Oct 20 18:05:22 pixometerstag04 kernel:  do_sys_openat2+0x97/0x150
Oct 20 18:05:22 pixometerstag04 kernel:  __x64_sys_openat+0x54/0x90
Oct 20 18:05:22 pixometerstag04 kernel:  do_syscall_64+0x33/0x40
Oct 20 18:05:22 pixometerstag04 kernel:=20
entry_SYSCALL_64_after_hwframe+0x44/0xa9
Oct 20 18:05:22 pixometerstag04 kernel: RIP: 0033:0x7f3e3114dea8
Oct 20 18:05:22 pixometerstag04 kernel: RSP: 002b:00007ffd92f7df10 EFLAGS:
00000293 ORIG_RAX: 0000000000000101
Oct 20 18:05:22 pixometerstag04 kernel: RAX: ffffffffffffffda RBX:
00000000000800c1 RCX: 00007f3e3114dea8
Oct 20 18:05:22 pixometerstag04 kernel: RDX: 00000000000800c1 RSI:
000000000195cb50 RDI: 00000000ffffff9c
Oct 20 18:05:22 pixometerstag04 kernel: RBP: 000000000195cb50 R08:
0000000000000000 R09: 0000000000000003
Oct 20 18:05:22 pixometerstag04 kernel: R10: 00000000000001b6 R11:
0000000000000293 R12: 00007ffd92f7e300
Oct 20 18:05:22 pixometerstag04 kernel: R13: 00007ffd92f7dfc0 R14:
00007ffd92f7dfb0 R15: 00007ffd92f7fd30

However, the first thaw came between when the machine already reported 122 =
and
245s of hangs and the last thaw came after it broke free.

Interestingly it also logs a variety of things that worked while those were
logged, maybe it only happened for the /tmp filesystem and not / ... appare=
ntly
postgresql was still writing stuff on the disk in that period, so I'd guess
this only happened on /tmp

This is square in the middle of the reported blocks:

Oct 20 17:52:00 pixometerstag04 postgres[1008]: user=3D,db=3D LOG:  checkpo=
int
complete: wrote 0 buffers (0.0%); 0 transaction log file(s) added, 0 remove=
d, 0
recycled; write=3D0.004 s, sync=3D0.001 s, total=3D0.018 s; sync fi>

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
