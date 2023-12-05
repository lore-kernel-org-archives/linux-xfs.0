Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D6136AC2
	for <linux-xfs@vger.kernel.org>; Tue,  5 Dec 2023 03:22:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HOzOLZRP"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 22BB4C433CD
	for <linux-xfs@vger.kernel.org>; Tue,  5 Dec 2023 03:22:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701746565;
	bh=/v+9SP/Ngs6A0AdWSqXnfBBLi5DDYvuuVdehN8NldxU=;
	h=From:To:Subject:Date:From;
	b=HOzOLZRPKDCYKNl4PPmuQ1OTi8vnyr7FYQaP5trpdpcM8o7e/2a/DNu+J7isi9omT
	 viHFT/PTlKg2kyL2ZW2VYYeyf4ybf1b7p3/JFIpdIZ6ABJVuCsRcKywCYyQwKML2gu
	 bDL1DuApnthY+HQbvDTYcoSGrfzZPmmobrVRzZPxhWx/7yQ/SMtmpTh5conEIizMaC
	 JKnV62MxYynDDLKGnDr0dH2JBRlmEqdPp05VHozuRzPFAxoC6WGeTDyPnKiHLOGFVV
	 g/gJp+7T6oP3u90+nLf4OziwJMhriSBAW5xLLLpS4OLp7bO6tVY7znEpEI4Dyv9m8f
	 JIu0+hnhAMdbA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 11B77C53BC6; Tue,  5 Dec 2023 03:22:45 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-xfs@vger.kernel.org
Subject: [Bug 218226] New: XFS: Assertion failed: bp->b_flags & XBF_DONE,
 file: fs/xfs/xfs_trans_buf.c, line: 241
Date: Tue, 05 Dec 2023 03:22:44 +0000
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
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version rep_platform
 op_sys bug_status bug_severity priority component assigned_to reporter
 cf_regression
Message-ID: <bug-218226-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

https://bugzilla.kernel.org/show_bug.cgi?id=3D218226

            Bug ID: 218226
           Summary: XFS: Assertion failed: bp->b_flags & XBF_DONE, file:
                    fs/xfs/xfs_trans_buf.c, line: 241
           Product: File System
           Version: 2.5
          Hardware: All
                OS: Linux
            Status: NEW
          Severity: normal
          Priority: P3
         Component: XFS
          Assignee: filesystem_xfs@kernel-bugs.kernel.org
          Reporter: mcgrof@kernel.org
        Regression: No

While doing fstests baseline testing on v6.6-rc5 with kdevops [0] we found =
that
the XFS assertion with:

XFS: Assertion failed: bp->b_flags & XBF_DONE, file: fs/xfs/xfs_trans_buf.c,
line: 241


This fails on the following tests and respective sections as defined by XFS
configs [1]

  * xfs_crc:
  - generic/531:
https://gist.github.com/mcgrof/adff5df7cea8f531f2e9d291c324899f

  * xfs_crc_logdev_rtdev:
  - generic/251:
https://gist.github.com/mcgrof/62726d57286409a96cccc27f7b795eaa
  - generic/531:
https://gist.github.com/mcgrof/7f54eeaeeac1a249ec39c228a3fb7e2b

  * xfs_crc_rtdev:
  - generic/251:
https://gist.github.com/mcgrof/56b9e68c408c653f6286735259ff52e9
  - generic/531:
https://gist.github.com/mcgrof/eb56d1cb8e44d90b4a73ebf031c28125

  * xfs_crc_rtdev_extsize_28k:
  - generic/251:
https://gist.github.com/mcgrof/88a092f0679baf01571c3fdea85ab523

  * xfs_crc_rtdev_extsize_64k:
  - generic/251:
https://gist.github.com/mcgrof/56b9e68c408c653f6286735259ff52e9
  - generic/388:
https://gist.github.com/mcgrof/c8d223d635b393a64d08dbb84b1b766c

  * xfs_nocrc_4k:
  - xfs/013: https://gist.github.com/mcgrof/eee36d38828a7d59abcc2c4706bcbd33

  * xfs_nocrc_512:
  - generic/388:
https://gist.github.com/mcgrof/155c431f5804921ff10a59a12710cbb0
  - generic/650:
https://gist.github.com/mcgrof/8a4ac7107fa75ac3b44f634e6a1552ef

  * xfs_reflink_dir_bsize_8k:
  - generic/531:
https://gist.github.com/mcgrof/fee63ab2a0c62aad91b112f599ea3f4a

[0] https://github.com/linux-kdevops/
[1]
https://github.com/linux-kdevops/kdevops/blob/master/playbooks/roles/fstest=
s/templates/xfs/xfs.config

There are many logs available for different tests and sections, here is just
one:

Oct 19 00:09:09 base-xfs-crc unknown: run fstests generic/531 at 2023-10-19
00:09:09
Oct 19 00:09:09 base-xfs-crc kernel: XFS (loop16): Mounting V5 Filesystem
ea25e038-9814-46b1-8695-61d46b67237a
Oct 19 00:09:09 base-xfs-crc kernel: XFS (loop16): Ending clean mount
Oct 19 00:09:09 base-xfs-crc kernel: XFS (loop5): Mounting V5 Filesystem
3ee270b3-47f7-470a-9156-ea182f7eeeea
Oct 19 00:09:09 base-xfs-crc kernel: XFS (loop5): Ending clean mount
Oct 19 00:09:43 base-xfs-crc kernel: XFS: Assertion failed: bp->b_flags &
XBF_DONE, file: fs/xfs/xfs_trans_buf.c, line: 241
Oct 19 00:09:43 base-xfs-crc kernel: ------------[ cut here ]------------
Oct 19 00:09:43 base-xfs-crc kernel: kernel BUG at fs/xfs/xfs_message.c:102!
Oct 19 00:09:43 base-xfs-crc kernel: invalid opcode: 0000 [#1] PREEMPT SMP
NOPTI
Oct 19 00:09:43 base-xfs-crc kernel: CPU: 1 PID: 1281741 Comm: kworker/1:0 =
Not
tainted 6.6.0-rc5 #2
Oct 19 00:09:43 base-xfs-crc kernel: Hardware name: QEMU Standard PC (Q35 +
ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Oct 19 00:09:43 base-xfs-crc kernel: Workqueue: xfs-inodegc/loop5
xfs_inodegc_worker [xfs]
Oct 19 00:09:43 base-xfs-crc kernel: RIP: 0010:assfail+0x34/0x40 [xfs]
Oct 19 00:09:43 base-xfs-crc kernel: Code: c9 48 c7 c2 90 c2 1d c1 48 89 f1=
 48
89 fe 48 c7 c7 d8 d5 1c c1 e8 7c fd ff ff 80 3d 05 0a 09 00 00 75 07 0f 0b =
c3
cc cc cc cc <0f> 0b 66 2e 0f 1f >
Oct 19 00:09:43 base-xfs-crc kernel: RSP: 0018:ffffbe084494bc78 EFLAGS:
00010202
Oct 19 00:09:43 base-xfs-crc kernel: RAX: 0000000000000000 RBX:
ffff9637ddafccb0 RCX: 000000007fffffff
Oct 19 00:09:43 base-xfs-crc kernel: RDX: 0000000000000000 RSI:
0000000000000000 RDI: ffffffffc11cd5d8
Oct 19 00:09:43 base-xfs-crc kernel: RBP: ffff963806ea5800 R08:
0000000000000000 R09: 000000000000000a
Oct 19 00:09:43 base-xfs-crc kernel: R10: 000000000000000a R11:
0fffffffffffffff R12: ffff9637d0c0e000
Oct 19 00:09:43 base-xfs-crc kernel: R13: ffffbe084494bce8 R14:
ffffbe084494bd18 R15: ffffffffc11bbc40
Oct 19 00:09:43 base-xfs-crc kernel: FS:  0000000000000000(0000)
GS:ffff96383bc40000(0000) knlGS:0000000000000000
Oct 19 00:09:43 base-xfs-crc kernel: CS:  0010 DS: 0000 ES: 0000 CR0:
0000000080050033
Oct 19 00:09:43 base-xfs-crc kernel: CR2: 000055f11a996ef0 CR3:
00000001429a6005 CR4: 0000000000770ee0
Oct 19 00:09:43 base-xfs-crc kernel: DR0: 0000000000000000 DR1:
0000000000000000 DR2: 0000000000000000
Oct 19 00:09:43 base-xfs-crc kernel: DR3: 0000000000000000 DR6:
00000000fffe0ff0 DR7: 0000000000000400
Oct 19 00:09:43 base-xfs-crc kernel: PKRU: 55555554
Oct 19 00:09:43 base-xfs-crc kernel: Call Trace:
Oct 19 00:09:43 base-xfs-crc kernel:  <TASK>
Oct 19 00:09:43 base-xfs-crc kernel:  ? die+0x32/0x80
Oct 19 00:09:43 base-xfs-crc kernel:  ? do_trap+0xd6/0x100
Oct 19 00:09:43 base-xfs-crc kernel:  ? assfail+0x34/0x40 [xfs]
Oct 19 00:09:43 base-xfs-crc kernel:  ? do_error_trap+0x6a/0x90
Oct 19 00:09:43 base-xfs-crc kernel:  ? assfail+0x34/0x40 [xfs]
Oct 19 00:09:43 base-xfs-crc kernel:  ? exc_invalid_op+0x4c/0x60
Oct 19 00:09:43 base-xfs-crc kernel:  ? assfail+0x34/0x40 [xfs]
Oct 19 00:09:43 base-xfs-crc kernel:  ? asm_exc_invalid_op+0x16/0x20
Oct 19 00:09:43 base-xfs-crc kernel:  ? assfail+0x34/0x40 [xfs]
Oct 19 00:09:43 base-xfs-crc kernel:  ? assfail+0x24/0x40 [xfs]
Oct 19 00:09:43 base-xfs-crc kernel:  xfs_trans_read_buf_map+0x337/0x4e0 [x=
fs]
Oct 19 00:09:43 base-xfs-crc kernel:  xfs_imap_to_bp+0x53/0x80 [xfs]
Oct 19 00:09:43 base-xfs-crc kernel:  xfs_inode_item_precommit+0x19f/0x230
[xfs]
Oct 19 00:09:43 base-xfs-crc kernel:  xfs_trans_run_precommits+0x65/0xd0 [x=
fs]
Oct 19 00:09:43 base-xfs-crc kernel:  __xfs_trans_commit+0x51/0x390 [xfs]
Oct 19 00:09:43 base-xfs-crc kernel:  xfs_inactive_ifree+0x104/0x200 [xfs]
Oct 19 00:09:43 base-xfs-crc kernel:  xfs_inactive+0x16b/0x290 [xfs]
Oct 19 00:09:43 base-xfs-crc kernel:  xfs_inodegc_worker+0xaf/0x190 [xfs]
Oct 19 00:09:43 base-xfs-crc kernel:  process_one_work+0x171/0x340
Oct 19 00:09:43 base-xfs-crc kernel:  worker_thread+0x277/0x3a0
Oct 19 00:09:43 base-xfs-crc kernel:  ? preempt_count_add+0x6a/0xa0
Oct 19 00:09:43 base-xfs-crc kernel:  ? _raw_spin_lock_irqsave+0x23/0x50
Oct 19 00:09:43 base-xfs-crc kernel:  ? __pfx_worker_thread+0x10/0x10
Oct 19 00:09:43 base-xfs-crc kernel:  kthread+0xf0/0x120
Oct 19 00:09:43 base-xfs-crc kernel:  ? __pfx_kthread+0x10/0x10
Oct 19 00:09:43 base-xfs-crc kernel:  ret_from_fork+0x2d/0x50
Oct 19 00:09:43 base-xfs-crc kernel:  ? __pfx_kthread+0x10/0x10
Oct 19 00:09:43 base-xfs-crc kernel:  ret_from_fork_asm+0x1b/0x30
Oct 19 00:09:43 base-xfs-crc kernel:  </TASK>
Oct 19 00:09:43 base-xfs-crc kernel: Modules linked in: dm_log_writes
dm_thin_pool dm_persistent_data dm_bio_prison sd_mod sg scsi_mod scsi_common
dm_snapshot dm_bufio dm_flakey xfs sunrpc >
Oct 19 00:09:43 base-xfs-crc kernel: ---[ end trace 0000000000000000 ]---
Oct 19 00:09:43 base-xfs-crc kernel: RIP: 0010:assfail+0x34/0x40 [xfs]
Oct 19 00:09:43 base-xfs-crc kernel: Code: c9 48 c7 c2 90 c2 1d c1 48 89 f1=
 48
89 fe 48 c7 c7 d8 d5 1c c1 e8 7c fd ff ff 80 3d 05 0a 09 00 00 75 07 0f 0b =
c3
cc cc cc cc <0f> 0b 66 2e 0f 1f >
Oct 19 00:09:43 base-xfs-crc kernel: RSP: 0018:ffffbe084494bc78 EFLAGS:
00010202
Oct 19 00:09:43 base-xfs-crc kernel: RAX: 0000000000000000 RBX:
ffff9637ddafccb0 RCX: 000000007fffffff
Oct 19 00:09:43 base-xfs-crc kernel: RDX: 0000000000000000 RSI:
0000000000000000 RDI: ffffffffc11cd5d8
Oct 19 00:09:43 base-xfs-crc kernel: RBP: ffff963806ea5800 R08:
0000000000000000 R09: 000000000000000a
Oct 19 00:09:43 base-xfs-crc kernel: R10: 000000000000000a R11:
0fffffffffffffff R12: ffff9637d0c0e000
Oct 19 00:09:43 base-xfs-crc kernel: R13: ffffbe084494bce8 R14:
ffffbe084494bd18 R15: ffffffffc11bbc40
Oct 19 00:09:43 base-xfs-crc kernel: FS:  0000000000000000(0000)
GS:ffff96383bc40000(0000) knlGS:0000000000000000
Oct 19 00:09:43 base-xfs-crc kernel: CS:  0010 DS: 0000 ES: 0000 CR0:
0000000080050033
Oct 19 00:09:43 base-xfs-crc kernel: CR2: 000055f11a996ef0 CR3:
00000001429a6005 CR4: 0000000000770ee0
Oct 19 00:09:43 base-xfs-crc kernel: DR0: 0000000000000000 DR1:
0000000000000000 DR2: 0000000000000000
Oct 19 00:09:43 base-xfs-crc kernel: DR3: 0000000000000000 DR6:
00000000fffe0ff0 DR7: 0000000000000400
Oct 19 00:09:43 base-xfs-crc kernel: PKRU: 55555554

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
