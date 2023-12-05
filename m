Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5314A11CA3
	for <linux-xfs@vger.kernel.org>; Tue,  5 Dec 2023 02:41:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y4wk12Pl"
Received: by smtp.kernel.org (Postfix) with ESMTPS id D30C8C433CD
	for <linux-xfs@vger.kernel.org>; Tue,  5 Dec 2023 02:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701744111;
	bh=dNm89A8eND0PIOzq/G0Z8bkrnWvb5LSE/1aVImPcq7A=;
	h=From:To:Subject:Date:From;
	b=Y4wk12PlDmnbUcvNkW0p53FHbf19oMKsC4Jg3yMcOWKLoQOI/rMNnf3O9+L8Ln4Um
	 9V0/KuYPDivWZSx8FejZhDpkPvRJ8DA8OZzUxDGWzemjaXNbI+7C842a1FohsNvanU
	 VRXIMXQJ0cxp/PLXC3xX0DMjexkskbRVQZVDtOYWLdBCfgrNCNnZB2tqhBgGuYZ9FX
	 QFNpzniblrpkqX0RBXE0jcYHmfZOXuWNH1OXqgKsGFOgbj68NsGMs7QntnNoEss6qn
	 kv3yLj/ZAf+LMHSb3JevemoA/Xl6G0A1UqMDGNOxqaNpZeFhevC6ja6mtiq49nxL6B
	 x9v+ud89qcmTg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id C131AC53BCD; Tue,  5 Dec 2023 02:41:51 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-xfs@vger.kernel.org
Subject: [Bug 218224] New: XFS: Assertion failed: ip->i_nblocks == 0 file:
 fs/xfs/xfs_inode.c, line: 2359
Date: Tue, 05 Dec 2023 02:41:51 +0000
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
Message-ID: <bug-218224-201763@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D218224

            Bug ID: 218224
           Summary: XFS: Assertion failed: ip->i_nblocks =3D=3D 0 file:
                    fs/xfs/xfs_inode.c, line: 2359
           Product: File System
           Version: 2.5
          Hardware: Intel
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

XFS: Assertion failed: ip->i_nblocks =3D=3D 0, file: fs/xfs/xfs_inode.c, li=
ne: 2359

can be triggered by many fstests tests:

  * generic/475:
https://gist.github.com/mcgrof/5d6f504f4695ba27cea7df5d63f35197
  * generic/388:
https://gist.github.com/mcgrof/c1c8b1dc76fdc1032a5f0aab6c2a14bf
  * generic/648:
https://gist.github.com/mcgrof/1e506ecbe898b45428d6e7febfc02db1

This fails on the following test sections as defined by kdevops [1]:

  * xfs_nocrc_2k
  * xfs_reflink
  * xfs_reflink_1024
  * xfs_reflink_2k
  * xfs_reflink_4k
  * xfs_reflink_dir_bsize_8k
  * xfs_reflink_logdev
  * xfs_reflink_normapbt
  * xfs_reflink_nrext64

[0] https://github.com/linux-kdevops/
[1]
https://github.com/linux-kdevops/kdevops/blob/master/playbooks/roles/fstest=
s/templates/xfs/xfs.config

This is most easily reproduced when using ftests with SOAK_DURATION=3D9900.=
 Below
is just one full trace.

Oct 28 08:02:44 line-xfs-reflink-4k unknown: run fstests generic/475 at
2023-10-28 08:02:44
Oct 28 08:02:45 line-xfs-reflink-4k kernel: XFS (loop16): Mounting V5
Filesystem 7f327ba7-53be-4654-8ac3-dafe4ae3bfa4
Oct 28 08:02:45 line-xfs-reflink-4k kernel: XFS (loop16): Ending clean mount
Oct 28 08:02:45 line-xfs-reflink-4k kernel: XFS (dm-0): Mounting V5 Filesys=
tem
581ec1f6-137c-4e4a-b7fe-d12927837ac0
Oct 28 08:02:45 line-xfs-reflink-4k kernel: XFS (dm-0): Ending clean mount
Oct 28 08:02:46 line-xfs-reflink-4k kernel: XFS (dm-0): log I/O error -5
Oct 28 08:02:46 line-xfs-reflink-4k kernel: XFS (dm-0): Filesystem has been
shut down due to log error (0x2).
Oct 28 08:02:46 line-xfs-reflink-4k kernel: XFS (dm-0): Please unmount the
filesystem and rectify the problem(s).
Oct 28 08:02:46 line-xfs-reflink-4k kernel: XFS (dm-0): log I/O error -5
Oct 28 08:02:46 line-xfs-reflink-4k kernel: Buffer I/O error on dev dm-0,
logical block 0, async page read
Oct 28 08:02:46 line-xfs-reflink-4k kernel: Buffer I/O error on dev dm-0,
logical block 1, async page read
Oct 28 08:02:46 line-xfs-reflink-4k kernel: Buffer I/O error on dev dm-0,
logical block 2, async page read
Oct 28 08:02:46 line-xfs-reflink-4k kernel: Buffer I/O error on dev dm-0,
logical block 3, async page read
Oct 28 08:02:46 line-xfs-reflink-4k kernel: Buffer I/O error on dev dm-0,
logical block 4, async page read
Oct 28 08:02:46 line-xfs-reflink-4k kernel: Buffer I/O error on dev dm-0,
logical block 5, async page read
Oct 28 08:02:46 line-xfs-reflink-4k kernel: Buffer I/O error on dev dm-0,
logical block 6, async page read
Oct 28 08:02:46 line-xfs-reflink-4k kernel: Buffer I/O error on dev dm-0,
logical block 7, async page read
Oct 28 08:02:47 line-xfs-reflink-4k kernel: XFS (dm-0): Unmounting Filesyst=
em
581ec1f6-137c-4e4a-b7fe-d12927837ac0
Oct 28 08:02:47 line-xfs-reflink-4k kernel: XFS (dm-0): Mounting V5 Filesys=
tem
581ec1f6-137c-4e4a-b7fe-d12927837ac0
Oct 28 08:02:47 line-xfs-reflink-4k kernel: XFS (dm-0): Starting recovery
(logdev: internal)
Oct 28 08:02:47 line-xfs-reflink-4k kernel: XFS (dm-0): Ending recovery
(logdev: internal)
Oct 28 08:02:47 line-xfs-reflink-4k kernel: iomap_finish_ioend: 10 callbacks
suppressed
Oct 28 08:02:47 line-xfs-reflink-4k kernel: dm-0: writeback error on inode
16778760, offset 1449984, sector 10494304
Oct 28 08:02:47 line-xfs-reflink-4k kernel: XFS (dm-0): log I/O error -5
Oct 28 08:02:47 line-xfs-reflink-4k kernel: dm-0: writeback error on inode
33693419, offset 2088960, sector 21148048
Oct 28 08:02:47 line-xfs-reflink-4k kernel: dm-0: writeback error on inode
33693416, offset 147456, sector 21119984
Oct 28 08:02:47 line-xfs-reflink-4k kernel: dm-0: writeback error on inode
33693416, offset 1200128, sector 21144416
Oct 28 08:02:47 line-xfs-reflink-4k kernel: XFS (dm-0): Filesystem has been
shut down due to log error (0x2).
Oct 28 08:02:47 line-xfs-reflink-4k kernel: Buffer I/O error on dev dm-0,
logical block 0, async page read
Oct 28 08:02:47 line-xfs-reflink-4k kernel: XFS (dm-0): Please unmount the
filesystem and rectify the problem(s).
Oct 28 08:02:47 line-xfs-reflink-4k kernel: Buffer I/O error on dev dm-0,
logical block 1, async page read
Oct 28 08:02:47 line-xfs-reflink-4k kernel: XFS (dm-0): log I/O error -5
Oct 28 08:02:47 line-xfs-reflink-4k kernel: XFS (dm-0): Unmounting Filesyst=
em
581ec1f6-137c-4e4a-b7fe-d12927837ac0
Oct 28 08:02:47 line-xfs-reflink-4k kernel: XFS (dm-0): Mounting V5 Filesys=
tem
581ec1f6-137c-4e4a-b7fe-d12927837ac0
Oct 28 08:02:47 line-xfs-reflink-4k kernel: XFS (dm-0): Starting recovery
(logdev: internal)
Oct 28 08:02:47 line-xfs-reflink-4k kernel: XFS (dm-0): Ending recovery
(logdev: internal)

... and 18 minutes later:

Oct 28 08:20:12 line-xfs-reflink-4k kernel: XFS (dm-0): Unmounting Filesyst=
em
581ec1f6-137c-4e4a-b7fe-d12927837ac0
Oct 28 08:20:12 line-xfs-reflink-4k kernel: XFS (dm-0): Mounting V5 Filesys=
tem
581ec1f6-137c-4e4a-b7fe-d12927837ac0
Oct 28 08:20:12 line-xfs-reflink-4k kernel: XFS (dm-0): Starting recovery
(logdev: internal)
Oct 28 08:20:13 line-xfs-reflink-4k kernel: XFS (dm-0): Ending recovery
(logdev: internal)
Oct 28 08:20:14 line-xfs-reflink-4k kernel: buffer_io_error: 30 callbacks
suppressed
Oct 28 08:20:14 line-xfs-reflink-4k kernel: Buffer I/O error on dev dm-0,
logical block 0, async page read
Oct 28 08:20:14 line-xfs-reflink-4k kernel: XFS (dm-0): metadata I/O error =
in
"xfs_imap_to_bp+0x53/0x80 [xfs]" at daddr 0x1e64460 len 32 error 5
Oct 28 08:20:14 line-xfs-reflink-4k kernel: Buffer I/O error on dev dm-0,
logical block 1, async page read
Oct 28 08:20:14 line-xfs-reflink-4k kernel: XFS (dm-0): metadata I/O error =
in
"xfs_imap_to_bp+0x53/0x80 [xfs]" at daddr 0x1e64460 len 32 error 5
Oct 28 08:20:14 line-xfs-reflink-4k kernel: Buffer I/O error on dev dm-0,
logical block 2, async page read
Oct 28 08:20:14 line-xfs-reflink-4k kernel: XFS (dm-0): metadata I/O error =
in
"xfs_imap_to_bp+0x53/0x80 [xfs]" at daddr 0x1e64460 len 32 error 5
Oct 28 08:20:14 line-xfs-reflink-4k kernel: Buffer I/O error on dev dm-0,
logical block 3, async page read
Oct 28 08:20:14 line-xfs-reflink-4k kernel: XFS (dm-0): metadata I/O error =
in
"xfs_imap_to_bp+0x53/0x80 [xfs]" at daddr 0x1e64460 len 32 error 5
Oct 28 08:20:14 line-xfs-reflink-4k kernel: Buffer I/O error on dev dm-0,
logical block 4, async page read
Oct 28 08:20:14 line-xfs-reflink-4k kernel: XFS (dm-0): metadata I/O error =
in
"xfs_imap_to_bp+0x53/0x80 [xfs]" at daddr 0x1e64460 len 32 error 5
Oct 28 08:20:14 line-xfs-reflink-4k kernel: Buffer I/O error on dev dm-0,
logical block 5, async page read
Oct 28 08:20:14 line-xfs-reflink-4k kernel: XFS (dm-0): metadata I/O error =
in
"xfs_imap_to_bp+0x53/0x80 [xfs]" at daddr 0x1e64460 len 32 error 5
Oct 28 08:20:14 line-xfs-reflink-4k kernel: Buffer I/O error on dev dm-0,
logical block 6, async page read
Oct 28 08:20:14 line-xfs-reflink-4k kernel: XFS (dm-0): metadata I/O error =
in
"xfs_btree_read_buf_block.constprop.0+0xa5/0xe0 [xfs]" at daddr 0x146b050 l=
en 8
error 5
Oct 28 08:20:14 line-xfs-reflink-4k kernel: XFS (dm-0): log I/O error -5
Oct 28 08:20:14 line-xfs-reflink-4k kernel: XFS (dm-0): Corruption of in-me=
mory
data (0x8) detected at xfs_defer_finish_noroll+0x296/0x760 [xfs]
(fs/xfs/libxfs/xfs_defer.c:575).  Shutting d>
Oct 28 08:20:14 line-xfs-reflink-4k kernel: Buffer I/O error on dev dm-0,
logical block 7, async page read
Oct 28 08:20:14 line-xfs-reflink-4k kernel: XFS (dm-0): Please unmount the
filesystem and rectify the problem(s)
Oct 28 08:20:14 line-xfs-reflink-4k kernel: XFS (dm-0): Unmounting Filesyst=
em
581ec1f6-137c-4e4a-b7fe-d12927837ac0
Oct 28 08:20:14 line-xfs-reflink-4k kernel: XFS (dm-0): Mounting V5 Filesys=
tem
581ec1f6-137c-4e4a-b7fe-d12927837ac0
Oct 28 08:20:14 line-xfs-reflink-4k kernel: XFS (dm-0): Starting recovery
(logdev: internal)
Oct 28 08:20:14 line-xfs-reflink-4k kernel: XFS (dm-0): Ending recovery
(logdev: internal)
Oct 28 08:20:16 line-xfs-reflink-4k kernel: XFS (dm-0): log I/O error -5
Oct 28 08:20:16 line-xfs-reflink-4k kernel: XFS (dm-0): Filesystem has been
shut down due to log error (0x2).
Oct 28 08:20:16 line-xfs-reflink-4k kernel: XFS (dm-0): Please unmount the
filesystem and rectify the problem(s).
Oct 28 08:20:16 line-xfs-reflink-4k kernel: Buffer I/O error on dev dm-0,
logical block 0, async page read
Oct 28 08:20:16 line-xfs-reflink-4k kernel: Buffer I/O error on dev dm-0,
logical block 1, async page read
Oct 28 08:20:16 line-xfs-reflink-4k kernel: XFS (dm-0): Unmounting Filesyst=
em
581ec1f6-137c-4e4a-b7fe-d12927837ac0
Oct 28 08:20:17 line-xfs-reflink-4k kernel: XFS (dm-0): Mounting V5 Filesys=
tem
581ec1f6-137c-4e4a-b7fe-d12927837ac0
Oct 28 08:20:17 line-xfs-reflink-4k kernel: XFS (dm-0): Starting recovery
(logdev: internal)
Oct 28 08:20:17 line-xfs-reflink-4k kernel: XFS (dm-0): Ending recovery
(logdev: internal)
Oct 28 08:20:19 line-xfs-reflink-4k kernel: iomap_finish_ioend: 19 callbacks
suppressed
Oct 28 08:20:19 line-xfs-reflink-4k kernel: dm-0: writeback error on inode
18753482, offset 1769472, sector 12905504
Oct 28 08:20:19 line-xfs-reflink-4k kernel: dm-0: writeback error on inode
35725283, offset 5734400, sector 23574648
Oct 28 08:20:19 line-xfs-reflink-4k kernel: dm-0: writeback error on inode
1073101, offset 462848, sector 1068080
Oct 28 08:20:19 line-xfs-reflink-4k kernel: XFS (dm-0): metadata I/O error =
in
"xfs_da_read_buf+0xdc/0x130 [xfs]" at daddr 0x1fa8d58 len 8 error 5
Oct 28 08:20:19 line-xfs-reflink-4k kernel: dm-0: writeback error on inode
1073101, offset 4272128, sector 2551584
Oct 28 08:20:19 line-xfs-reflink-4k kernel: dm-0: writeback error on inode
35752735, offset 77824, sector 23205528
Oct 28 08:20:19 line-xfs-reflink-4k kernel: dm-0: writeback error on inode
52398842, offset 2654208, sector 33812128
Oct 28 08:20:19 line-xfs-reflink-4k kernel: dm-0: writeback error on inode
35752746, offset 167936, sector 23533800
Oct 28 08:20:19 line-xfs-reflink-4k kernel: dm-0: writeback error on inode
35752746, offset 274432, sector 23569344
Oct 28 08:20:19 line-xfs-reflink-4k kernel: buffer_io_error: 6 callbacks
suppressed
Oct 28 08:20:19 line-xfs-reflink-4k kernel: Buffer I/O error on dev dm-0,
logical block 0, async page read
Oct 28 08:20:19 line-xfs-reflink-4k kernel: dm-0: writeback error on inode
35725283, offset 4075520, sector 23530360
Oct 28 08:20:19 line-xfs-reflink-4k kernel: dm-0: writeback error on inode
35752746, offset 151552, sector 23171432
Oct 28 08:20:19 line-xfs-reflink-4k kernel: XFS (dm-0): metadata I/O error =
in
"xfs_da_read_buf+0xdc/0x130 [xfs]" at daddr 0x1618af0 len 8 error 5
Oct 28 08:20:19 line-xfs-reflink-4k kernel: Buffer I/O error on dev dm-0,
logical block 1, async page read
Oct 28 08:20:19 line-xfs-reflink-4k kernel: XFS: Assertion failed:
ip->i_nblocks =3D=3D 0, file: fs/xfs/xfs_inode.c, line: 2359
Oct 28 08:20:19 line-xfs-reflink-4k kernel: Buffer I/O error on dev dm-0,
logical block 2, async page read
Oct 28 08:20:19 line-xfs-reflink-4k kernel: ------------[ cut here
]------------
Oct 28 08:20:19 line-xfs-reflink-4k kernel: Buffer I/O error on dev dm-0,
logical block 3, async page read
Oct 28 08:20:19 line-xfs-reflink-4k kernel: kernel BUG at
fs/xfs/xfs_message.c:102!
Oct 28 08:20:19 line-xfs-reflink-4k kernel: Buffer I/O error on dev dm-0,
logical block 4, async page read
Oct 28 08:20:19 line-xfs-reflink-4k kernel: invalid opcode: 0000 [#1] PREEM=
PT
SMP PTI
Oct 28 08:20:19 line-xfs-reflink-4k kernel: Buffer I/O error on dev dm-0,
logical block 5, async page read
Oct 28 08:20:19 line-xfs-reflink-4k kernel: CPU: 0 PID: 1834877 Comm:
kworker/0:2 Not tainted 6.6.0-rc5 #2
Oct 28 08:20:19 line-xfs-reflink-4k kernel: Hardware name: QEMU Standard PC
(Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Oct 28 08:20:19 line-xfs-reflink-4k kernel: Workqueue: xfs-inodegc/dm-0
xfs_inodegc_worker [xfs]
Oct 28 08:20:19 line-xfs-reflink-4k kernel: Buffer I/O error on dev dm-0,
logical block 6, async page read
Oct 28 08:20:19 line-xfs-reflink-4k kernel:=20
Oct 28 08:20:19 line-xfs-reflink-4k kernel: Buffer I/O error on dev dm-0,
logical block 7, async page read
Oct 28 08:20:19 line-xfs-reflink-4k kernel: RIP: 0010:assfail+0x34/0x40 [xf=
s]
Oct 28 08:20:19 line-xfs-reflink-4k kernel: XFS (dm-0): log I/O error -5
Oct 28 08:20:19 line-xfs-reflink-4k kernel: Code: c9 48 c7 c2 a0 22 ff c0 4=
8 89
f1 48 89 fe 48 c7 c7 d8 35 fe c0 e8 7c fd ff ff 80 3d a5 09 09 00 00 75 07 =
0f
0b c3 cc cc cc cc <0f> 0b 66 2e>
Oct 28 08:20:19 line-xfs-reflink-4k kernel: RSP: 0018:ffffaf75c026bd28 EFLA=
GS:
00010202
Oct 28 08:20:19 line-xfs-reflink-4k kernel: RAX: 0000000000000000 RBX:
ffff8bd09e473708 RCX: 000000007fffffff
Oct 28 08:20:19 line-xfs-reflink-4k kernel: RDX: 0000000000000000 RSI:
0000000000000000 RDI: ffffffffc0fe35d8
Oct 28 08:20:19 line-xfs-reflink-4k kernel: XFS (dm-0): Filesystem has been
shut down due to log error (0x2).
Oct 28 08:20:19 line-xfs-reflink-4k kernel: RBP: ffff8bcff7bd5400 R08:
0000000000000000 R09: 000000000000000a
Oct 28 08:20:19 line-xfs-reflink-4k kernel: R10: 000000000000000a R11:
0fffffffffffffff R12: ffff8bd08c247000
Oct 28 08:20:19 line-xfs-reflink-4k kernel: XFS (dm-0): Please unmount the
filesystem and rectify the problem(s).
Oct 28 08:20:19 line-xfs-reflink-4k kernel: R13: ffff8bd08c247000 R14:
ffffcf75bfc09910 R15: ffff8bd0b0cea9f8
Oct 28 08:20:19 line-xfs-reflink-4k kernel: FS:  0000000000000000(0000)
GS:ffff8bd0fbc00000(0000) knlGS:0000000000000000
Oct 28 08:20:19 line-xfs-reflink-4k kernel: CS:  0010 DS: 0000 ES: 0000 CR0:
0000000080050033
Oct 28 08:20:19 line-xfs-reflink-4k kernel: CR2: 00007ffcb5051aa8 CR3:
000000010c188002 CR4: 0000000000170ef0
Oct 28 08:20:19 line-xfs-reflink-4k kernel: Call Trace:
Oct 28 08:20:19 line-xfs-reflink-4k kernel:  <TASK>
Oct 28 08:20:19 line-xfs-reflink-4k kernel:  ? die+0x32/0x80
Oct 28 08:20:19 line-xfs-reflink-4k kernel:  ? do_trap+0xd6/0x100
Oct 28 08:20:19 line-xfs-reflink-4k kernel:  ? assfail+0x34/0x40 [xfs]
Oct 28 08:20:19 line-xfs-reflink-4k kernel:  ? do_error_trap+0x6a/0x90
Oct 28 08:20:19 line-xfs-reflink-4k kernel:  ? assfail+0x34/0x40 [xfs]
Oct 28 08:20:19 line-xfs-reflink-4k kernel:  ? exc_invalid_op+0x4c/0x60
Oct 28 08:20:19 line-xfs-reflink-4k kernel:  ? assfail+0x34/0x40 [xfs]
Oct 28 08:20:19 line-xfs-reflink-4k kernel:  ? asm_exc_invalid_op+0x16/0x20
Oct 28 08:20:19 line-xfs-reflink-4k kernel:  ? assfail+0x34/0x40 [xfs]
Oct 28 08:20:19 line-xfs-reflink-4k kernel:  ? assfail+0x24/0x40 [xfs]
Oct 28 08:20:19 line-xfs-reflink-4k kernel:  xfs_ifree+0x60e/0x6b0 [xfs]
Oct 28 08:20:19 line-xfs-reflink-4k kernel:  ? xfs_trans_reserve+0x199/0x270
[xfs]
Oct 28 08:20:19 line-xfs-reflink-4k kernel:  ? xfs_trans_alloc+0x10a/0x2b0
[xfs]
Oct 28 08:20:19 line-xfs-reflink-4k kernel:  xfs_inactive_ifree+0xb8/0x200
[xfs]
Oct 28 08:20:19 line-xfs-reflink-4k kernel:  xfs_inactive+0x16b/0x290 [xfs]
Oct 28 08:20:19 line-xfs-reflink-4k kernel:  xfs_inodegc_worker+0xb4/0x1a0
[xfs]
Oct 28 08:20:19 line-xfs-reflink-4k kernel:  process_one_work+0x174/0x340
Oct 28 08:20:19 line-xfs-reflink-4k kernel:  worker_thread+0x277/0x390
Oct 28 08:20:19 line-xfs-reflink-4k kernel:  ? preempt_count_add+0x6a/0xa0
Oct 28 08:20:19 line-xfs-reflink-4k kernel:  ? __pfx_worker_thread+0x10/0x10
Oct 28 08:20:19 line-xfs-reflink-4k kernel:  kthread+0xf3/0x120
Oct 28 08:20:19 line-xfs-reflink-4k kernel:  ? __pfx_kthread+0x10/0x10
Oct 28 08:20:19 line-xfs-reflink-4k kernel:  ret_from_fork+0x30/0x50
Oct 28 08:20:19 line-xfs-reflink-4k kernel:  ? __pfx_kthread+0x10/0x10
Oct 28 08:20:19 line-xfs-reflink-4k kernel:  ret_from_fork_asm+0x1b/0x30
Oct 28 08:20:19 line-xfs-reflink-4k kernel:  </TASK>
Oct 28 08:20:19 line-xfs-reflink-4k kernel: Modules linked in: dm_log_writes
dm_thin_pool dm_persistent_data dm_bio_prison sd_mod sg scsi_mod scsi_common
dm_snapshot dm_bufio dm_flakey xfs >
Oct 28 08:20:19 line-xfs-reflink-4k kernel: ---[ end trace 0000000000000000
]---
Oct 28 08:20:19 line-xfs-reflink-4k kernel: RIP: 0010:assfail+0x34/0x40 [xf=
s]
Oct 28 08:20:19 line-xfs-reflink-4k kernel: Code: c9 48 c7 c2 a0 22 ff c0 4=
8 89
f1 48 89 fe 48 c7 c7 d8 35 fe c0 e8 7c fd ff ff 80 3d a5 09 09 00 00 75 07 =
0f
0b c3 cc cc cc cc <0f> 0b 66 2e>
Oct 28 08:20:19 line-xfs-reflink-4k kernel: RSP: 0018:ffffaf75c026bd28 EFLA=
GS:
00010202
Oct 28 08:20:19 line-xfs-reflink-4k kernel: RAX: 0000000000000000 RBX:
ffff8bd09e473708 RCX: 000000007fffffff
Oct 28 08:20:19 line-xfs-reflink-4k kernel: RDX: 0000000000000000 RSI:
0000000000000000 RDI: ffffffffc0fe35d8
Oct 28 08:20:19 line-xfs-reflink-4k kernel: RBP: ffff8bcff7bd5400 R08:
0000000000000000 R09: 000000000000000a
Oct 28 08:20:19 line-xfs-reflink-4k kernel: R10: 000000000000000a R11:
0fffffffffffffff R12: ffff8bd08c247000
Oct 28 08:20:19 line-xfs-reflink-4k kernel: R13: ffff8bd08c247000 R14:
ffffcf75bfc09910 R15: ffff8bd0b0cea9f8
Oct 28 08:20:19 line-xfs-reflink-4k kernel: FS:  0000000000000000(0000)
GS:ffff8bd0fbc00000(0000) knlGS:0000000000000000
Oct 28 08:20:19 line-xfs-reflink-4k kernel: CS:  0010 DS: 0000 ES: 0000 CR0:
0000000080050033
Oct 28 08:20:19 line-xfs-reflink-4k kernel: CR2: 00007ffcb5051aa8 CR3:
00000001087d6001 CR4: 0000000000170ef0
Oct 28 08:20:19 line-xfs-reflink-4k kernel: XFS (dm-0): Unmounting Filesyst=
em
581ec1f6-137c-4e4a-b7fe-d12927837ac0

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
