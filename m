Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 171D5C43334
	for <linux-xfs@archiver.kernel.org>; Sun,  5 Jun 2022 07:51:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244528AbiFEHvS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 5 Jun 2022 03:51:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231497AbiFEHvQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 5 Jun 2022 03:51:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 516FF47AD4
        for <linux-xfs@vger.kernel.org>; Sun,  5 Jun 2022 00:51:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A482660E8D
        for <linux-xfs@vger.kernel.org>; Sun,  5 Jun 2022 07:51:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 04DDBC341C6
        for <linux-xfs@vger.kernel.org>; Sun,  5 Jun 2022 07:51:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654415474;
        bh=/mYmnGrMYnxb7x74YBIZFYDT+EgAFvYYe7Q0h4Upbzw=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=fT+FC7uzklCjURGqAjzcJ4Eoa1I/1FNB6+T6yVJYoYNPuA1CR8+J02qbOrIIZcuca
         l0q+3SwcypY8jFOPTL7/VpyRCAEa4d34l1T2G5eEGoKnuscX93WSfHgW/G4a8Dd3pI
         JEyOfJt8BJJQI5xow/hWqyPeAzWaSTwN9FeuJ/SiPnu6Zh7VQRUR+SEVsc++rF/F4t
         VCsexggzJwQQTOEsxAUquGGzn/ei3bAAoX+huOi9t7PeU5lgNyIHpI7lGb3ShzPO7k
         ZvSQcZxt/oLhf12eqwKRCIbEhR8Q0X6kMODEpJS1to8qCq1IurkxkzT0oTiYAPiePk
         0HJWlufcMcJ2g==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id E52D8C05FF5; Sun,  5 Jun 2022 07:51:13 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 216007] XFS hangs in iowait when extracting large number of
 files
Date:   Sun, 05 Jun 2022 07:51:13 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: clockwork80@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-216007-201763-uYTTdxLIlY@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216007-201763@https.bugzilla.kernel.org/>
References: <bug-216007-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216007

--- Comment #25 from Jordi (clockwork80@gmail.com) ---
I have applied the patch on vanilla 5.18.1 kernel and the issue is not reso=
lved
on ext4.

Here's the output of dmesg:

[Sun Jun  5 09:44:51 2022] sysrq: Show Blocked State
[Sun Jun  5 09:44:51 2022] task:kworker/u24:11  state:D stack:    0 pid:  1=
45
ppid:     2 flags:0x00004000
[Sun Jun  5 09:44:51 2022] Workqueue: writeback wb_workfn (flush-8:32)
[Sun Jun  5 09:44:51 2022] Call Trace:
[Sun Jun  5 09:44:51 2022]  <TASK>
[Sun Jun  5 09:44:51 2022]  __schedule+0x26d/0xe80
[Sun Jun  5 09:44:51 2022]  ? __blk_flush_plug+0xe1/0x140
[Sun Jun  5 09:44:51 2022]  schedule+0x46/0xa0
[Sun Jun  5 09:44:51 2022]  io_schedule+0x3d/0x60
[Sun Jun  5 09:44:51 2022]  blk_mq_get_tag+0x115/0x2b0
[Sun Jun  5 09:44:51 2022]  ? destroy_sched_domains_rcu+0x20/0x20
[Sun Jun  5 09:44:51 2022]  __blk_mq_alloc_requests+0x157/0x290
[Sun Jun  5 09:44:51 2022]  blk_mq_submit_bio+0x188/0x520
[Sun Jun  5 09:44:51 2022]  submit_bio_noacct_nocheck+0x252/0x2a0
[Sun Jun  5 09:44:51 2022]  ext4_io_submit+0x1b/0x40
[Sun Jun  5 09:44:51 2022]  ext4_writepages+0x4fc/0xe80
[Sun Jun  5 09:44:51 2022]  ? ata_qc_issue+0x101/0x1b0
[Sun Jun  5 09:44:51 2022]  ? __ata_scsi_queuecmd+0x17a/0x380
[Sun Jun  5 09:44:51 2022]  ? update_load_avg+0x77/0x610
[Sun Jun  5 09:44:51 2022]  do_writepages+0xbc/0x1a0
[Sun Jun  5 09:44:51 2022]  ? __schedule+0x275/0xe80
[Sun Jun  5 09:44:51 2022]  __writeback_single_inode+0x2c/0x180
[Sun Jun  5 09:44:51 2022]  writeback_sb_inodes+0x204/0x490
[Sun Jun  5 09:44:51 2022]  __writeback_inodes_wb+0x47/0xd0
[Sun Jun  5 09:44:51 2022]  wb_writeback.isra.0+0x15d/0x1a0
[Sun Jun  5 09:44:51 2022]  wb_workfn+0x23d/0x3a0
[Sun Jun  5 09:44:51 2022]  process_one_work+0x1b0/0x300
[Sun Jun  5 09:44:51 2022]  worker_thread+0x48/0x3c0
[Sun Jun  5 09:44:51 2022]  ? rescuer_thread+0x380/0x380
[Sun Jun  5 09:44:51 2022]  kthread+0xd4/0x100
[Sun Jun  5 09:44:51 2022]  ? kthread_complete_and_exit+0x20/0x20
[Sun Jun  5 09:44:51 2022]  ret_from_fork+0x22/0x30
[Sun Jun  5 09:44:51 2022]  </TASK>
[Sun Jun  5 09:44:51 2022] task:tar             state:D stack:    0 pid:115=
76
ppid: 11566 flags:0x00000000
[Sun Jun  5 09:44:51 2022] Call Trace:
[Sun Jun  5 09:44:51 2022]  <TASK>
[Sun Jun  5 09:44:51 2022]  __schedule+0x26d/0xe80
[Sun Jun  5 09:44:51 2022]  ? __mod_timer+0x1c2/0x3b0
[Sun Jun  5 09:44:51 2022]  schedule+0x46/0xa0
[Sun Jun  5 09:44:51 2022]  schedule_timeout+0x7c/0xf0
[Sun Jun  5 09:44:51 2022]  ? fprop_fraction_percpu+0x2b/0x70
[Sun Jun  5 09:44:51 2022]  ? init_timer_key+0x30/0x30
[Sun Jun  5 09:44:51 2022]  io_schedule_timeout+0x47/0x70
[Sun Jun  5 09:44:51 2022]  balance_dirty_pages_ratelimited+0x235/0xa10
[Sun Jun  5 09:44:51 2022]  generic_perform_write+0x142/0x200
[Sun Jun  5 09:44:51 2022]  ext4_buffered_write_iter+0x76/0x100
[Sun Jun  5 09:44:51 2022]  new_sync_write+0x104/0x180
[Sun Jun  5 09:44:51 2022]  vfs_write+0x1e6/0x270
[Sun Jun  5 09:44:51 2022]  ksys_write+0x5a/0xd0
[Sun Jun  5 09:44:51 2022]  do_syscall_64+0x3b/0x90
[Sun Jun  5 09:44:51 2022]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[Sun Jun  5 09:44:51 2022] RIP: 0033:0x7f994fe7c483
[Sun Jun  5 09:44:51 2022] RSP: 002b:00007ffe79956648 EFLAGS: 00000246
ORIG_RAX: 0000000000000001
[Sun Jun  5 09:44:51 2022] RAX: ffffffffffffffda RBX: 0000000000001084 RCX:
00007f994fe7c483
[Sun Jun  5 09:44:51 2022] RDX: 0000000000001084 RSI: 000055f5bb5a9a00 RDI:
0000000000000003
[Sun Jun  5 09:44:51 2022] RBP: 000055f5bb5a9a00 R08: 00007f994fe7c260 R09:
0000000000000000
[Sun Jun  5 09:44:51 2022] R10: 00000000000001a4 R11: 0000000000000246 R12:
0000000000000003
[Sun Jun  5 09:44:51 2022] R13: 0000000000000003 R14: 000055f5bb5b5320 R15:
000055f5bb5a9a00
[Sun Jun  5 09:44:51 2022]  </TASK>

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
