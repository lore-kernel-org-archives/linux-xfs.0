Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 445E7A59
	for <linux-xfs@vger.kernel.org>; Tue,  5 Dec 2023 03:03:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D/o+A571"
Received: by smtp.kernel.org (Postfix) with ESMTPS id BAE83C433CA
	for <linux-xfs@vger.kernel.org>; Tue,  5 Dec 2023 03:03:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701745424;
	bh=H56Jj1lJYaPPikfh1XXc5R870OOa/gEnzm5WhtsCkjk=;
	h=From:To:Subject:Date:From;
	b=D/o+A571MTYPNmcgUQJHjo1kPZK0g6LVvWz8eGsKkNYt5gPakgBaAhZgsJYw0bwMH
	 6VoMFEFUYX3xFmB+UqhS1+sYwJPiL3DfwXkR1oGS8zlOdDyK4MUW+uPEUWK98S/kLn
	 967W27hxVin4vZbyWqlWj+d8q3NgXfOp/FryQWKuxPNfObQoR8dtN51WDpjezdHpUp
	 OIXagPGVpr1QumD/8gts5rJqNx7YA8oNW4JWXcAvkMSQ+g2q3jVQkwY5V7lVKTOszk
	 AXU7QlTLmCkqWReOrg64z4FOu5rNTOeU4bdtlzAukILIafFaQpbOIjA/gmF0BvkfPp
	 hPmvpqOAxPnQw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id AB086C53BD0; Tue,  5 Dec 2023 03:03:44 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-xfs@vger.kernel.org
Subject: [Bug 218225] New: xfs assert (irec->br_blockcount &
 ~XFS_IEXT_LENGTH_MASK) == 0 file: fs/xfs/libxfs/xfs_iext_tree.c, line: 58
Date: Tue, 05 Dec 2023 03:03:44 +0000
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
Message-ID: <bug-218225-201763@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D218225

            Bug ID: 218225
           Summary: xfs assert (irec->br_blockcount &
                    ~XFS_IEXT_LENGTH_MASK) =3D=3D 0 file:
                    fs/xfs/libxfs/xfs_iext_tree.c, line: 58
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

XFS: Assertion failed: (irec->br_blockcount & ~XFS_IEXT_LENGTH_MASK) =3D=3D=
 0,
file: fs/xfs/libxfs/xfs_iext_tree.c, line: 58

can be triggered with test generic/388 on the test section
xfs_crc_rtdev_extsize_28k as per kdevops XFS configs [1]

[0] https://github.com/linux-kdevops/
[1]
https://github.com/linux-kdevops/kdevops/blob/master/playbooks/roles/fstest=
s/templates/xfs/xfs.config

The trace:

Oct 28 03:40:16 line-xfs-crc-rtdev-extsize-28k unknown: run fstests generic=
/388
at 2023-10-28 03:40:16
Oct 28 03:40:16 line-xfs-crc-rtdev-extsize-28k kernel: XFS (loop5): Mountin=
g V5
Filesystem d252656e-d97a-43ad-913a-52e08b473ea2
Oct 28 03:40:17 line-xfs-crc-rtdev-extsize-28k kernel: XFS (loop5): Ending
clean mount
Oct 28 03:40:17 line-xfs-crc-rtdev-extsize-28k kernel: XFS (loop5): User
initiated shutdown received.
Oct 28 03:40:17 line-xfs-crc-rtdev-extsize-28k kernel: XFS (loop5): Metadata
I/O Error (0x4) detected at xfs_fs_goingdown+0x71/0xb0 [xfs]
(fs/xfs/xfs_fsops.c:492).  Shutting down filesystem.
Oct 28 03:40:17 line-xfs-crc-rtdev-extsize-28k kernel: XFS (loop5): Please
unmount the filesystem and rectify the problem(s)
Oct 28 03:40:17 line-xfs-crc-rtdev-extsize-28k kernel: XFS (loop5): Unmount=
ing
Filesystem d252656e-d97a-43ad-913a-52e08b473ea2
Oct 28 03:40:17 line-xfs-crc-rtdev-extsize-28k kernel: XFS (loop5): Mountin=
g V5
Filesystem 8c644744-b6ce-4f5c-bc41-8ea221eb7b4c
Oct 28 03:40:17 line-xfs-crc-rtdev-extsize-28k kernel: XFS (loop5): Ending
clean mount
Oct 28 03:40:18 line-xfs-crc-rtdev-extsize-28k kernel: XFS (loop5): User
initiated shutdown received.
Oct 28 03:40:18 line-xfs-crc-rtdev-extsize-28k kernel: XFS (loop5): Log I/O
Error (0x6) detected at xfs_fs_goingdown+0x57/0xb0 [xfs]
(fs/xfs/xfs_fsops.c:495).  Shutting down filesystem.
Oct 28 03:40:18 line-xfs-crc-rtdev-extsize-28k kernel: XFS (loop5): Please
unmount the filesystem and rectify the problem(s)
Oct 28 03:40:18 line-xfs-crc-rtdev-extsize-28k kernel: XFS (loop5): Unmount=
ing
Filesystem 8c644744-b6ce-4f5c-bc41-8ea221eb7b4c
Oct 28 03:40:18 line-xfs-crc-rtdev-extsize-28k kernel: XFS (loop5): Mountin=
g V5
Filesystem 8c644744-b6ce-4f5c-bc41-8ea221eb7b4c
Oct 28 03:40:18 line-xfs-crc-rtdev-extsize-28k kernel: XFS (loop5): Starting
recovery (logdev: internal)
Oct 28 03:40:18 line-xfs-crc-rtdev-extsize-28k kernel: XFS (loop5): Ending
recovery (logdev: internal)
Oct 28 03:40:18 line-xfs-crc-rtdev-extsize-28k kernel: XFS (loop5): Unmount=
ing
Filesystem 8c644744-b6ce-4f5c-bc41-8ea221eb7b4c
Oct 28 03:40:18 line-xfs-crc-rtdev-extsize-28k kernel: XFS (loop5): Mountin=
g V5
Filesystem 8c644744-b6ce-4f5c-bc41-8ea221eb7b4c
Oct 28 03:40:18 line-xfs-crc-rtdev-extsize-28k kernel: XFS (loop5): Ending
clean mount
Oct 28 03:40:20 line-xfs-crc-rtdev-extsize-28k kernel: XFS (loop5): User
initiated shutdown received.
Oct 28 03:40:20 line-xfs-crc-rtdev-extsize-28k kernel: XFS (loop5): Log I/O
Error (0x6) detected at xfs_fs_goingdown+0x57/0xb0 [xfs]
(fs/xfs/xfs_fsops.c:495).  Shutting down filesystem.
Oct 28 03:40:20 line-xfs-crc-rtdev-extsize-28k kernel: XFS (loop5): Please
unmount the filesystem and rectify the problem(s)
Oct 28 03:40:20 line-xfs-crc-rtdev-extsize-28k kernel: loop5: writeback err=
or
on inode 33685921, offset 16986112, sector 9327888
Oct 28 03:40:20 line-xfs-crc-rtdev-extsize-28k kernel: loop5: writeback err=
or
on inode 16777724, offset 15302656, sector 9327792
Oct 28 03:40:20 line-xfs-crc-rtdev-extsize-28k kernel: loop5: writeback err=
or
on inode 680, offset 14049280, sector 9225832
Oct 28 03:40:20 line-xfs-crc-rtdev-extsize-28k kernel: loop5: writeback err=
or
on inode 680, offset 25534464, sector 9327672
Oct 28 03:40:20 line-xfs-crc-rtdev-extsize-28k kernel: loop5: writeback err=
or
on inode 16777505, offset 45858816, sector 361616
Oct 28 03:40:20 line-xfs-crc-rtdev-extsize-28k kernel: loop5: writeback err=
or
on inode 16777638, offset 16572416, sector 259672
Oct 28 03:40:20 line-xfs-crc-rtdev-extsize-28k kernel: loop5: writeback err=
or
on inode 16777638, offset 37949440, sector 404296
Oct 28 03:40:20 line-xfs-crc-rtdev-extsize-28k kernel: XFS (loop5): Unmount=
ing
Filesystem 8c644744-b6ce-4f5c-bc41-8ea221eb7b4c
Oct 28 03:40:20 line-xfs-crc-rtdev-extsize-28k kernel: XFS (loop5): Mountin=
g V5
Filesystem 8c644744-b6ce-4f5c-bc41-8ea221eb7b4c
Oct 28 03:40:20 line-xfs-crc-rtdev-extsize-28k kernel: XFS (loop5): Starting
recovery (logdev: internal)
Oct 28 03:40:21 line-xfs-crc-rtdev-extsize-28k kernel: XFS (loop5): Ending
recovery (logdev: internal)
Oct 28 03:40:23 line-xfs-crc-rtdev-extsize-28k kernel: XFS (loop5): User
initiated shutdown received.
Oct 28 03:40:23 line-xfs-crc-rtdev-extsize-28k kernel: loop5: writeback err=
or
on inode 50332272, offset 2744320, sector 448824
Oct 28 03:40:23 line-xfs-crc-rtdev-extsize-28k kernel: XFS (loop5): Log I/O
Error (0x6) detected at xfs_fs_goingdown+0x57/0xb0 [xfs]
(fs/xfs/xfs_fsops.c:495).  Shutting down filesystem.
Oct 28 03:40:23 line-xfs-crc-rtdev-extsize-28k kernel: loop5: writeback err=
or
on inode 50332272, offset 2809856, sector 468608
Oct 28 03:40:23 line-xfs-crc-rtdev-extsize-28k kernel: loop5: writeback err=
or
on inode 33686293, offset 33497088, sector 7358528
Oct 28 03:40:23 line-xfs-crc-rtdev-extsize-28k kernel: XFS (loop5): Please
unmount the filesystem and rectify the problem(s)
Oct 28 03:40:23 line-xfs-crc-rtdev-extsize-28k kernel: XFS (loop5): Unmount=
ing
Filesystem 8c644744-b6ce-4f5c-bc41-8ea221eb7b4c
Oct 28 03:40:23 line-xfs-crc-rtdev-extsize-28k kernel: XFS (loop5): Mountin=
g V5
Filesystem 8c644744-b6ce-4f5c-bc41-8ea221eb7b4c
Oct 28 03:40:23 line-xfs-crc-rtdev-extsize-28k kernel: XFS (loop5): Starting
recovery (logdev: internal)
Oct 28 03:40:24 line-xfs-crc-rtdev-extsize-28k kernel: XFS (loop5): Ending
recovery (logdev: internal)
... 2 hours later

Oct 28 05:43:38 line-xfs-crc-rtdev-extsize-28k kernel: XFS (loop5): Unmount=
ing
Filesystem 8c644744-b6ce-4f5c-bc41-8ea221eb7b4c
Oct 28 05:43:38 line-xfs-crc-rtdev-extsize-28k kernel: XFS (loop5): Mountin=
g V5
Filesystem 8c644744-b6ce-4f5c-bc41-8ea221eb7b4c
Oct 28 05:43:38 line-xfs-crc-rtdev-extsize-28k kernel: XFS (loop5): Starting
recovery (logdev: internal)
Oct 28 05:43:38 line-xfs-crc-rtdev-extsize-28k kernel: XFS (loop5): Ending
recovery (logdev: internal)
Oct 28 05:43:40 line-xfs-crc-rtdev-extsize-28k kernel: XFS (loop5): User
initiated shutdown received.
Oct 28 05:43:40 line-xfs-crc-rtdev-extsize-28k kernel: XFS (loop5): Log I/O
Error (0x6) detected at xfs_fs_goingdown+0x57/0xb0 [xfs]
(fs/xfs/xfs_fsops.c:495).  Shutting down filesystem.
Oct 28 05:43:40 line-xfs-crc-rtdev-extsize-28k kernel: XFS (loop5): Please
unmount the filesystem and rectify the problem(s)
Oct 28 05:43:40 line-xfs-crc-rtdev-extsize-28k kernel: loop5: writeback err=
or
on inode 33699515, offset 25681920, sector 9763584
Oct 28 05:43:40 line-xfs-crc-rtdev-extsize-28k kernel: loop5: writeback err=
or
on inode 33699515, offset 25690112, sector 9963520
Oct 28 05:43:40 line-xfs-crc-rtdev-extsize-28k kernel: loop5: writeback err=
or
on inode 33699515, offset 25718784, sector 10972136
Oct 28 05:43:40 line-xfs-crc-rtdev-extsize-28k kernel: loop5: writeback err=
or
on inode 33699695, offset 475136, sector 11261352
Oct 28 05:43:40 line-xfs-crc-rtdev-extsize-28k kernel: loop5: writeback err=
or
on inode 33698483, offset 3670016, sector 11572064
Oct 28 05:43:40 line-xfs-crc-rtdev-extsize-28k kernel: loop5: writeback err=
or
on inode 33698876, offset 114688, sector 11409552
Oct 28 05:43:40 line-xfs-crc-rtdev-extsize-28k kernel: loop5: writeback err=
or
on inode 50345059, offset 1523712, sector 12672248
Oct 28 05:43:40 line-xfs-crc-rtdev-extsize-28k kernel: loop5: writeback err=
or
on inode 33698876, offset 110592, sector 11163480
Oct 28 05:43:40 line-xfs-crc-rtdev-extsize-28k kernel: loop5: writeback err=
or
on inode 50345059, offset 17182720, sector 11726192
Oct 28 05:43:40 line-xfs-crc-rtdev-extsize-28k kernel: loop5: writeback err=
or
on inode 50345059, offset 17260544, sector 11340224
Oct 28 05:43:40 line-xfs-crc-rtdev-extsize-28k kernel: XFS (loop5): Unmount=
ing
Filesystem 8c644744-b6ce-4f5c-bc41-8ea221eb7b4c
Oct 28 05:43:40 line-xfs-crc-rtdev-extsize-28k kernel: XFS (loop5): Mountin=
g V5
Filesystem 8c644744-b6ce-4f5c-bc41-8ea221eb7b4c
Oct 28 05:43:40 line-xfs-crc-rtdev-extsize-28k kernel: XFS (loop5): Starting
recovery (logdev: internal)
Oct 28 05:43:40 line-xfs-crc-rtdev-extsize-28k kernel: XFS (loop5): Ending
recovery (logdev: internal)
Oct 28 05:43:40 line-xfs-crc-rtdev-extsize-28k kernel: XFS (loop5): Unmount=
ing
Filesystem 8c644744-b6ce-4f5c-bc41-8ea221eb7b4c
Oct 28 05:43:40 line-xfs-crc-rtdev-extsize-28k kernel: XFS (loop5): Mountin=
g V5
Filesystem 8c644744-b6ce-4f5c-bc41-8ea221eb7b4c
Oct 28 05:43:40 line-xfs-crc-rtdev-extsize-28k kernel: XFS (loop5): Ending
clean mount
Oct 28 05:43:42 line-xfs-crc-rtdev-extsize-28k kernel: XFS: Assertion faile=
d:
(irec->br_blockcount & ~XFS_IEXT_LENGTH_MASK) =3D=3D 0, file:
fs/xfs/libxfs/xfs_iext_tree.c, line: 58
Oct 28 05:43:42 line-xfs-crc-rtdev-extsize-28k kernel: ------------[ cut he=
re
]------------
Oct 28 05:43:42 line-xfs-crc-rtdev-extsize-28k kernel: kernel BUG at
fs/xfs/xfs_message.c:102!
Oct 28 05:43:42 line-xfs-crc-rtdev-extsize-28k kernel: invalid opcode: 0000
[#1] PREEMPT SMP PTI
Oct 28 05:43:42 line-xfs-crc-rtdev-extsize-28k kernel: CPU: 0 PID: 1068182
Comm: kworker/0:2 Not tainted 6.6.0-rc5 #2
Oct 28 05:43:42 line-xfs-crc-rtdev-extsize-28k kernel: Hardware name: QEMU
Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Oct 28 05:43:42 line-xfs-crc-rtdev-extsize-28k kernel: Workqueue:
xfs-inodegc/loop5 xfs_inodegc_worker [xfs]
Oct 28 05:43:42 line-xfs-crc-rtdev-extsize-28k kernel: RIP:
0010:assfail+0x34/0x40 [xfs]
Oct 28 05:43:42 line-xfs-crc-rtdev-extsize-28k kernel: Code: c9 48 c7 c2 a0=
 52
19 c1 48 89 f1 48 89 fe 48 c7 c7 d8 65 18 c1 e8 7c fd ff ff 80 3d a5 09 09 =
00
00 75 07 0f 0b c3 cc cc cc cc <0>
Oct 28 05:43:42 line-xfs-crc-rtdev-extsize-28k kernel: RSP:
0018:ffffa6d641523ad8 EFLAGS: 00010202
Oct 28 05:43:42 line-xfs-crc-rtdev-extsize-28k kernel: RAX: 0000000000000000
RBX: ffffa6d641523d28 RCX: 000000007fffffff
Oct 28 05:43:42 line-xfs-crc-rtdev-extsize-28k kernel: RDX: 0000000000000000
RSI: 0000000000000000 RDI: ffffffffc11865d8
Oct 28 05:43:42 line-xfs-crc-rtdev-extsize-28k kernel: RBP: ffff95c67439f130
R08: 0000000000000000 R09: 000000000000000a
Oct 28 05:43:42 line-xfs-crc-rtdev-extsize-28k kernel: R10: 000000000000000a
R11: 0fffffffffffffff R12: ffff95c5bb34ac00
Oct 28 05:43:42 line-xfs-crc-rtdev-extsize-28k kernel: R13: 00000000000000c8
R14: 0000000000000d2e R15: ffffa6d641523cd8
Oct 28 05:43:42 line-xfs-crc-rtdev-extsize-28k kernel: FS:=20
0000000000000000(0000) GS:ffff95c6bbc00000(0000) knlGS:0000000000000000
Oct 28 05:43:42 line-xfs-crc-rtdev-extsize-28k kernel: CS:  0010 DS: 0000 E=
S:
0000 CR0: 0000000080050033
Oct 28 05:43:42 line-xfs-crc-rtdev-extsize-28k kernel: CR2: 0000560d29ba79a8
CR3: 000000000587c001 CR4: 0000000000170ef0
Oct 28 05:43:42 line-xfs-crc-rtdev-extsize-28k kernel: Call Trace:
Oct 28 05:43:42 line-xfs-crc-rtdev-extsize-28k kernel:  <TASK>
Oct 28 05:43:42 line-xfs-crc-rtdev-extsize-28k kernel:  ? die+0x32/0x80
Oct 28 05:43:42 line-xfs-crc-rtdev-extsize-28k kernel:  ? do_trap+0xd6/0x100
Oct 28 05:43:42 line-xfs-crc-rtdev-extsize-28k kernel:  ? assfail+0x34/0x40
[xfs]
Oct 28 05:43:42 line-xfs-crc-rtdev-extsize-28k kernel:  ?
do_error_trap+0x6a/0x90
Oct 28 05:43:42 line-xfs-crc-rtdev-extsize-28k kernel:  ? assfail+0x34/0x40
[xfs]
Oct 28 05:43:42 line-xfs-crc-rtdev-extsize-28k kernel:  ?
exc_invalid_op+0x4c/0x60
Oct 28 05:43:42 line-xfs-crc-rtdev-extsize-28k kernel:  ? assfail+0x34/0x40
[xfs]
Oct 28 05:43:42 line-xfs-crc-rtdev-extsize-28k kernel:  ?
asm_exc_invalid_op+0x16/0x20
Oct 28 05:43:42 line-xfs-crc-rtdev-extsize-28k kernel:  ? assfail+0x34/0x40
[xfs]
Oct 28 05:43:42 line-xfs-crc-rtdev-extsize-28k kernel:  ? assfail+0x24/0x40
[xfs]
Oct 28 05:43:42 line-xfs-crc-rtdev-extsize-28k kernel:  xfs_iext_set+0xf6/0=
x100
[xfs]
Oct 28 05:43:42 line-xfs-crc-rtdev-extsize-28k kernel:=20
xfs_iext_insert+0x13b/0x970 [xfs]
Oct 28 05:43:42 line-xfs-crc-rtdev-extsize-28k kernel:  ?
set_track_prepare+0x4a/0x70
Oct 28 05:43:42 line-xfs-crc-rtdev-extsize-28k kernel:  ?
xfs_bmbt_init_cursor+0x79/0x1e0 [xfs]
Oct 28 05:43:42 line-xfs-crc-rtdev-extsize-28k kernel:  ?
__xfs_bunmapi+0xa8b/0xcf0 [xfs]
Oct 28 05:43:42 line-xfs-crc-rtdev-extsize-28k kernel:=20
xfs_bmap_add_extent_unwritten_real+0x486/0x1270 [xfs]
Oct 28 05:43:42 line-xfs-crc-rtdev-extsize-28k kernel:=20
__xfs_bunmapi+0x395/0xcf0 [xfs]
Oct 28 05:43:42 line-xfs-crc-rtdev-extsize-28k kernel:=20
xfs_itruncate_extents_flags+0x141/0x4c0 [xfs]
Oct 28 05:43:42 line-xfs-crc-rtdev-extsize-28k kernel:=20
xfs_inactive_truncate+0xbf/0x140 [xfs]
Oct 28 05:43:42 line-xfs-crc-rtdev-extsize-28k kernel:=20
xfs_inactive+0x22d/0x290 [xfs]
Oct 28 05:43:42 line-xfs-crc-rtdev-extsize-28k kernel:=20
xfs_inodegc_worker+0xb4/0x1a0 [xfs]
Oct 28 05:43:42 line-xfs-crc-rtdev-extsize-28k kernel:=20
process_one_work+0x174/0x340
Oct 28 05:43:42 line-xfs-crc-rtdev-extsize-28k kernel:=20
worker_thread+0x277/0x390
Oct 28 05:43:42 line-xfs-crc-rtdev-extsize-28k kernel:  ?
preempt_count_add+0x6a/0xa0
Oct 28 05:43:42 line-xfs-crc-rtdev-extsize-28k kernel:  ?
__pfx_worker_thread+0x10/0x10
Oct 28 05:43:42 line-xfs-crc-rtdev-extsize-28k kernel:  kthread+0xf3/0x120
Oct 28 05:43:42 line-xfs-crc-rtdev-extsize-28k kernel:  ?
__pfx_kthread+0x10/0x10
Oct 28 05:43:42 line-xfs-crc-rtdev-extsize-28k kernel:  ret_from_fork+0x30/=
0x50
Oct 28 05:43:42 line-xfs-crc-rtdev-extsize-28k kernel:  ?
__pfx_kthread+0x10/0x10
Oct 28 05:43:42 line-xfs-crc-rtdev-extsize-28k kernel:=20
ret_from_fork_asm+0x1b/0x30
Oct 28 05:43:42 line-xfs-crc-rtdev-extsize-28k kernel:  </TASK>
Oct 28 05:43:42 line-xfs-crc-rtdev-extsize-28k kernel: Modules linked in:
dm_thin_pool dm_persistent_data dm_bio_prison sd_mod sg scsi_mod scsi_common
dm_snapshot dm_bufio dm_flakey xfs nvm>
Oct 28 05:43:42 line-xfs-crc-rtdev-extsize-28k kernel: ---[ end trace
0000000000000000 ]---
Oct 28 05:43:42 line-xfs-crc-rtdev-extsize-28k kernel: RIP:
0010:assfail+0x34/0x40 [xfs]
Oct 28 05:43:42 line-xfs-crc-rtdev-extsize-28k kernel: Code: c9 48 c7 c2 a0=
 52
19 c1 48 89 f1 48 89 fe 48 c7 c7 d8 65 18 c1 e8 7c fd ff ff 80 3d a5 09 09 =
00
00 75 07 0f 0b c3 cc cc cc cc <0>
Oct 28 05:43:42 line-xfs-crc-rtdev-extsize-28k kernel: RSP:
0018:ffffa6d641523ad8 EFLAGS: 00010202
Oct 28 05:43:42 line-xfs-crc-rtdev-extsize-28k kernel: RAX: 0000000000000000
RBX: ffffa6d641523d28 RCX: 000000007fffffff
Oct 28 05:43:42 line-xfs-crc-rtdev-extsize-28k kernel: RDX: 0000000000000000
RSI: 0000000000000000 RDI: ffffffffc11865d8
Oct 28 05:43:42 line-xfs-crc-rtdev-extsize-28k kernel: RBP: ffff95c67439f130
R08: 0000000000000000 R09: 000000000000000a
Oct 28 05:43:42 line-xfs-crc-rtdev-extsize-28k kernel: R10: 000000000000000a
R11: 0fffffffffffffff R12: ffff95c5bb34ac00
Oct 28 05:43:42 line-xfs-crc-rtdev-extsize-28k kernel: R13: 00000000000000c8
R14: 0000000000000d2e R15: ffffa6d641523cd8
Oct 28 05:43:42 line-xfs-crc-rtdev-extsize-28k kernel: FS:=20
0000000000000000(0000) GS:ffff95c6bbc00000(0000) knlGS:0000000000000000
Oct 28 05:43:42 line-xfs-crc-rtdev-extsize-28k kernel: CS:  0010 DS: 0000 E=
S:
0000 CR0: 0000000080050033
Oct 28 05:43:42 line-xfs-crc-rtdev-extsize-28k kernel: CR2: 0000560d29ba79a8
CR3: 000000000587c001 CR4: 0000000000170ef0
Oct 28 05:43:42 line-xfs-crc-rtdev-extsize-28k kernel: XFS (loop5): User
initiated shutdown received.
Oct 28 05:43:42 line-xfs-crc-rtdev-extsize-28k kernel: XFS (loop5): Log I/O
Error (0x6) detected at xfs_fs_goingdown+0x57/0xb0 [xfs]
(fs/xfs/xfs_fsops.c:495).  Shutting down filesystem.
Oct 28 05:43:42 line-xfs-crc-rtdev-extsize-28k kernel: XFS (loop5): Please
unmount the filesystem and rectify the problem(s)

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
