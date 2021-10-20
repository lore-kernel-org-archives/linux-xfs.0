Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04C76C433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Oct 2021 16:16:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E559A61406
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Oct 2021 16:16:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231340AbhJTQSc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 Oct 2021 12:18:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:52244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231339AbhJTQS1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 20 Oct 2021 12:18:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id CBDEA613B1
        for <linux-xfs@vger.kernel.org>; Wed, 20 Oct 2021 16:16:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634746572;
        bh=pHVBTHOmHEu4WgV6kzXCI4f8NlatOrvaUdtFHhe2HjM=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=dFxUjzja68ADCSPEeonGRtZPTg0QD1MJnTUqgd8QsahKe3C2xvlggUH10R/pVi6gU
         cH9ywozpeMXV8/ReEMJDDRm9AcvhM5bf9wFJ7/PylsngT7Bj/dQzWI816b1NLFopze
         cgLw4tj2zY4BfrgJz5CTw59x6btTVjHPNLWnalQ3eHZoyGCSVht25wgVpEqwzwm59b
         mFGPCPn03tOjgOyaB7fmmHesixRkxOs72+1lJhRuImPDdfmfSREAlJXXyP0UHgbFm5
         8KtDoc4wEdAUH/Hz7Hame7GoPngMqeNDFyBH3qDmA/AOwSYRrxN6QIz7ZBxrXxGPPf
         0H06841KWnBjw==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 214767] xfs seems to hang due to race condition? maybe related
 to (gratuitous) thaw.
Date:   Wed, 20 Oct 2021 16:16:12 +0000
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
Message-ID: <bug-214767-201763-wFcOwnSq0o@https.bugzilla.kernel.org/>
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

--- Comment #2 from Christian Theune (ct@flyingcircus.io) ---
Here's another excerpt that I dug out from a different VM with the same iss=
ue.
No thawing happening AFAICT around this time:

[848865.353541] INFO: task nix-daemon:1855245 blocked for more than 122
seconds.
[848865.355625]       Not tainted 5.10.70 #1-NixOS
[848865.356912] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables
this message.
[848865.359117] task:nix-daemon      state:D stack:    0 pid:1855245 ppid:=
=20
2165 flags:0x00000000
[848865.360999] Call Trace:
[848865.361480]  __schedule+0x271/0x860
[848865.362069]  schedule+0x46/0xb0
[848865.362657]  xfs_log_commit_cil+0x6a4/0x800 [xfs]
[848865.363436]  ? wake_up_q+0xa0/0xa0
[848865.364026]  __xfs_trans_commit+0x9d/0x310 [xfs]
[848865.364818]  xfs_create+0x472/0x560 [xfs]
[848865.365517]  xfs_generic_create+0x247/0x320 [xfs]
[848865.366310]  ? xfs_lookup+0x55/0x100 [xfs]
[848865.366984]  path_openat+0xdd7/0x1070
[848865.367617]  do_filp_open+0x88/0x130
[848865.368199]  ? getname_flags.part.0+0x29/0x1a0
[848865.368925]  do_sys_openat2+0x97/0x150
[848865.369557]  __x64_sys_openat+0x54/0x90
[848865.370176]  do_syscall_64+0x33/0x40
[848865.370787]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[848865.371619] RIP: 0033:0x7f48b24c0ea8
[848865.372196] RSP: 002b:00007ffed91cee30 EFLAGS: 00000293 ORIG_RAX:
0000000000000101
[848865.373398] RAX: ffffffffffffffda RBX: 00000000000800c1 RCX:
00007f48b24c0ea8
[848865.374530] RDX: 00000000000800c1 RSI: 00000000015c4750 RDI:
00000000ffffff9c
[848865.375661] RBP: 00000000015c4750 R08: 0000000000000000 R09:
0000000000000003
[848865.376790] R10: 00000000000001b6 R11: 0000000000000293 R12:
00007ffed91cf220
[848865.377920] R13: 00007ffed91ceee0 R14: 00007ffed91ceed0 R15:
00007ffed91d0c50

and I can see it not making any progress:

[848988.235884] INFO: task nix-daemon:1855245 blocked for more than 245
seconds.
[848988.238567]       Not tainted 5.10.70 #1-NixOS
[848988.240254] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables
this message.
[848988.242358] task:nix-daemon      state:D stack:    0 pid:1855245 ppid:=
=20
2165 flags:0x00000000
[848988.243756] Call Trace:
[848988.244183]  __schedule+0x271/0x860
[848988.244780]  schedule+0x46/0xb0
[848988.245366]  xfs_log_commit_cil+0x6a4/0x800 [xfs]
[848988.246153]  ? wake_up_q+0xa0/0xa0
[848988.246775]  __xfs_trans_commit+0x9d/0x310 [xfs]
[848988.247572]  xfs_create+0x472/0x560 [xfs]
[848988.248269]  xfs_generic_create+0x247/0x320 [xfs]
[848988.249084]  ? xfs_lookup+0x55/0x100 [xfs]
[848988.249781]  path_openat+0xdd7/0x1070
[848988.250388]  do_filp_open+0x88/0x130
[848988.251000]  ? getname_flags.part.0+0x29/0x1a0
[848988.251746]  do_sys_openat2+0x97/0x150
[848988.252366]  __x64_sys_openat+0x54/0x90
[848988.253015]  do_syscall_64+0x33/0x40
[848988.253610]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[848988.254445] RIP: 0033:0x7f48b24c0ea8
[848988.255071] RSP: 002b:00007ffed91cee30 EFLAGS: 00000293 ORIG_RAX:
0000000000000101
[848988.256292] RAX: ffffffffffffffda RBX: 00000000000800c1 RCX:
00007f48b24c0ea8
[848988.257460] RDX: 00000000000800c1 RSI: 00000000015c4750 RDI:
00000000ffffff9c
[848988.258622] RBP: 00000000015c4750 R08: 0000000000000000 R09:
0000000000000003
[848988.259777] R10: 00000000000001b6 R11: 0000000000000293 R12:
00007ffed91cf220
[848988.260933] R13: 00007ffed91ceee0 R14: 00007ffed91ceed0 R15:
00007ffed91d0c50

Both stack traces are identical in every regard so that might be useful inf=
o.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
