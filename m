Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C13D81CB51D
	for <linux-xfs@vger.kernel.org>; Sun, 17 Nov 2024 13:42:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731850965; cv=none; b=dFdkQNOW3WWMpxCXQaM2pXasplc2UsMbNBo2g1iWcDL/h0kZXWx5NNvUu9th1LVqGwDiA6tm03jmgVATNFdy2QmcLj/vFT1s3whR686HCTC17CWtCapQxnDGvk/p4F8BXLIAgOy3jtJLzdKduExThvZTLt0ZOSo6HvEVgfi6qO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731850965; c=relaxed/simple;
	bh=cxBHCNGDM6QHvvuGBlakc3bVgo03+m++ohOoi5wnMv8=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=LxVvS4s8Ipl8bHN1Y8enmjsyCddn7EY4GOX2RTuZcybM4F18mGk5YEoDenWog1BqGWfSih7QGgL4muFKC8DmQcOcIUEfN5XPZ22qMeYE2h0ZmGQLFXJXc3RJTf9AtlYL3+mCi7UiNrWZ3j1EgkRqQ9ZqS7Z1AzT59Z3J405ZhNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H89Px/gc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H89Px/gc"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 46157C4CEDA
	for <linux-xfs@vger.kernel.org>; Sun, 17 Nov 2024 13:42:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731850965;
	bh=cxBHCNGDM6QHvvuGBlakc3bVgo03+m++ohOoi5wnMv8=;
	h=From:To:Subject:Date:From;
	b=H89Px/gcqjP4G+5238IqbEbW3agfmjz48wU/6Vs39mmCUj2JYPDA3BYoXes+Ga8+2
	 54e7XIaRtACI/KW4F/a8QA8pd0oYAT9w6asS22AAEBu9GqHMvq2BeSZjnc8msSkh9C
	 ZP6UZxAl71rJwRcuJ2tgOH8vMIG8h3opZ6zy+QT2uMK34mm800LN86KJVMBQXMCJG0
	 +isOCjy4YeQn8Nw5SvlcOOVn0z9PdlfLbQ+Wkf6Q+MuxigvUE8+5bT5zntQiqA8Lxm
	 +Aottc5kBQ/J95hliB7f2NOuTqpc15L+IC3MbMEm0ILSMIN+a40zIR05YptMAGBrfC
	 qVHCF8FV1zLLg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 39198C53BBF; Sun, 17 Nov 2024 13:42:45 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-xfs@vger.kernel.org
Subject: [Bug 219504] New: XFS crashes with kernel Version > 6.1.91. Perhaps
 Changes in kernel 6.1.92 for XFS/iomap causing the problems?
Date: Sun, 17 Nov 2024 13:42:44 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: speedcracker@hotmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version rep_platform
 op_sys bug_status bug_severity priority component assigned_to reporter
 cf_regression
Message-ID: <bug-219504-201763@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D219504

            Bug ID: 219504
           Summary: XFS crashes with kernel Version > 6.1.91. Perhaps
                    Changes in kernel 6.1.92 for XFS/iomap causing the
                    problems?
           Product: File System
           Version: 2.5
          Hardware: AMD
                OS: Linux
            Status: NEW
          Severity: normal
          Priority: P3
         Component: XFS
          Assignee: filesystem_xfs@kernel-bugs.kernel.org
          Reporter: speedcracker@hotmail.com
        Regression: No

Hi there,

the reason for this message is, with changes in Kernel 6.1.92, I've got some
trouble with high I/O by using the XFS filesystem.
I think the reason for the kernel-backtrace, which is mentioned later, is o=
ne
of the following commits (in Kernel 6.1.92):
e811fec51c66a0056459daa1ac834aea7d8d98f5,
ea67e73129fceffd40b9193da93544c34d81b9c2,
54a37e5d07478358dcbf6e73b6c7e40e50a6f375,
580f40b4c956f38e83f66ebed4d81bbe4a7d82fb,
12339ec6fe4d41e69a81a13ca5e1c443fbe5bcba... and so on.

By using kernel 6.1.91 or lower version, no problems occur. By using kernel
6.1.92 or up (latest tests I've done with 6.1.105 - then I gave up) and high
I/O workload, the problem occur.

I'm using XFS as a underlaying file-system with a 32bit kernel for exporting
LUN's by using SCST (https://github.com/SCST-project/scst) through fileio (=
not
blockio).
I'm using the latest SCST git release.
One of the scst developers also sees the problem here as being more in the
direction of the Linux kernel, high I/O and XFS file system.


Here is the kernel-backtrace:

[Tue Aug 20 00:02:00 2024] ------------[ cut here ]------------
[Tue Aug 20 00:02:00 2024] WARNING: CPU: 5 PID: 2048 at
fs/iomap/buffered-io.c:980 iomap_file_buffered_write_punch_delalloc+0x3b0/0=
x440
[Tue Aug 20 00:02:00 2024] Modules linked in: iscsi_scst(O) scst_vdisk(O)
scst(O) dlm quota_v2 quota_tree autofs4 tcp_bbr sch_fq udf crc_itu_t input_=
leds
led_class ses enclosure hid_generic wmi_bmof edac_mce_amd crc32_pclmul usbh=
id
aesni_intel crypto_simd uas hid usb_storage rapl r8169 bnx2 i2c_piix4 mpt3s=
as
ccp i2c_core sha1_generic k10temp pcspkr video wmi backlight
[Tue Aug 20 00:02:00 2024] CPU: 5 PID: 2048 Comm: disk042_0 Tainted: G S=20=
=20=20=20=20=20=20
 O       6.1.106_LFS_FILE01 #1
[Tue Aug 20 00:02:00 2024] Hardware name: To Be Filled By O.E.M. X370 Pro4/=
X370
Pro4, BIOS P10.08 01/22/2024
[Tue Aug 20 00:02:00 2024] EIP:
iomap_file_buffered_write_punch_delalloc+0x3b0/0x440
[Tue Aug 20 00:02:00 2024] Code: 26 00 89 c6 89 d8 e8 4f e3 ed ff f0 ff 4b =
1c
75 9c 89 d8 e8 22 0a ef ff 66 90 eb 91 8d b6 00 00 00 00 0f 0b e9 f5 fd ff =
ff
90 <0f> 0b e9 df fd ff ff 90 0f 0b 8b 45 ec 8b 55 f0 89 f9 39 c6 19 d1
[Tue Aug 20 00:02:00 2024] EAX: a733e000 EBX: 0007f000 ECX: fffffef2 EDX:
0000010e
[Tue Aug 20 00:02:00 2024] ESI: a733f000 EDI: 00000000 EBP: 86df3bd0 ESP:
86df3b80
[Tue Aug 20 00:02:00 2024] DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068 EFL=
AGS:
00010293
[Tue Aug 20 00:02:00 2024] CR0: 80050033 CR2: 37f87000 CR3: 0185a6e0 CR4:
00350ef0
[Tue Aug 20 00:02:00 2024] Call Trace:
[Tue Aug 20 00:02:00 2024]  ? show_regs.cold+0x16/0x1b
[Tue Aug 20 00:02:00 2024]  ?
iomap_file_buffered_write_punch_delalloc+0x3b0/0x440
[Tue Aug 20 00:02:00 2024]  ? __warn+0x87/0xe0
[Tue Aug 20 00:02:00 2024]  ?
iomap_file_buffered_write_punch_delalloc+0x3b0/0x440
[Tue Aug 20 00:02:00 2024]  ?
iomap_file_buffered_write_punch_delalloc+0x3b0/0x440
[Tue Aug 20 00:02:00 2024]  ? report_bug+0xe5/0x170
[Tue Aug 20 00:02:00 2024]  ? exc_overflow+0x60/0x60
[Tue Aug 20 00:02:00 2024]  ? handle_bug+0x2a/0x50
[Tue Aug 20 00:02:00 2024]  ? exc_invalid_op+0x1e/0x70
[Tue Aug 20 00:02:00 2024]  ? handle_exception+0x101/0x101
[Tue Aug 20 00:02:00 2024]  ? exc_overflow+0x60/0x60
[Tue Aug 20 00:02:00 2024]  ?
iomap_file_buffered_write_punch_delalloc+0x3b0/0x440
[Tue Aug 20 00:02:00 2024]  ? exc_overflow+0x60/0x60
[Tue Aug 20 00:02:00 2024]  ?
iomap_file_buffered_write_punch_delalloc+0x3b0/0x440
[Tue Aug 20 00:02:00 2024]  ? xfs_dax_write_iomap_end+0xa0/0xa0
[Tue Aug 20 00:02:00 2024]  xfs_buffered_write_iomap_end+0x52/0xc0
[Tue Aug 20 00:02:00 2024]  ? xfs_buffered_write_iomap_end+0xc0/0xc0
[Tue Aug 20 00:02:00 2024]  iomap_iter+0xce/0x4b0
[Tue Aug 20 00:02:00 2024]  ? xfs_dax_write_iomap_end+0xa0/0xa0
[Tue Aug 20 00:02:00 2024]  iomap_file_buffered_write+0xa9/0x420
[Tue Aug 20 00:02:00 2024]  xfs_file_buffered_write+0x9d/0x2e0
[Tue Aug 20 00:02:00 2024]  xfs_file_write_iter+0xc9/0x100
[Tue Aug 20 00:02:00 2024]  fileio_exec_async+0x25e/0x3a0 [scst_vdisk]
[Tue Aug 20 00:02:00 2024]  fileio_exec_write+0x2ce/0x400 [scst_vdisk]
[Tue Aug 20 00:02:00 2024]  ? __switch_to_asm+0xdd/0xf0
[Tue Aug 20 00:02:00 2024]  ? __switch_to_asm+0xd7/0xf0
[Tue Aug 20 00:02:00 2024]  ? __switch_to_asm+0xd1/0xf0
[Tue Aug 20 00:02:00 2024]  ? __switch_to_asm+0xcb/0xf0
[Tue Aug 20 00:02:00 2024]  vdev_do_job+0x36/0xe0 [scst_vdisk]
[Tue Aug 20 00:02:00 2024]  ? __switch_to_asm+0x8f/0xf0
[Tue Aug 20 00:02:00 2024]  fileio_exec+0x1f/0x30 [scst_vdisk]
[Tue Aug 20 00:02:00 2024]  scst_do_real_exec+0x51/0x130 [scst]
[Tue Aug 20 00:02:00 2024]  scst_exec_check_blocking+0xa8/0x220 [scst]
[Tue Aug 20 00:02:00 2024]  scst_process_active_cmd+0x200/0x18f0 [scst]
[Tue Aug 20 00:02:00 2024]  scst_cmd_thread+0x15c/0x500 [scst]
[Tue Aug 20 00:02:00 2024]  ? prepare_to_wait_event+0x160/0x160
[Tue Aug 20 00:02:00 2024]  kthread+0xd2/0x100
[Tue Aug 20 00:02:00 2024]  ? scst_cmd_done_local+0x90/0x90 [scst]
[Tue Aug 20 00:02:00 2024]  ? kthread_complete_and_exit+0x20/0x20
[Tue Aug 20 00:02:00 2024]  ret_from_fork+0x1c/0x28
[Tue Aug 20 00:02:00 2024] ---[ end trace 0000000000000000 ]---
[Tue Aug 20 00:02:00 2024] ------------[ cut here ]------------
[Tue Aug 20 00:02:00 2024] WARNING: CPU: 5 PID: 2048 at
fs/iomap/buffered-io.c:993 iomap_file_buffered_write_punch_delalloc+0x2f0/0=
x440
[Tue Aug 20 00:02:00 2024] Modules linked in: iscsi_scst(O) scst_vdisk(O)
scst(O) dlm quota_v2 quota_tree autofs4 tcp_bbr sch_fq udf crc_itu_t input_=
leds
led_class ses enclosure hid_generic wmi_bmof edac_mce_amd crc32_pclmul usbh=
id
aesni_intel crypto_simd uas hid usb_storage rapl r8169 bnx2 i2c_piix4 mpt3s=
as
ccp i2c_core sha1_generic k10temp pcspkr video wmi backlight
[Tue Aug 20 00:02:00 2024] CPU: 5 PID: 2048 Comm: disk042_0 Tainted: G S   =
   W
 O       6.1.106_LFS_FILE01 #1
[Tue Aug 20 00:02:00 2024] Hardware name: To Be Filled By O.E.M. X370 Pro4/=
X370
Pro4, BIOS P10.08 01/22/2024
[Tue Aug 20 00:02:00 2024] EIP:
iomap_file_buffered_write_punch_delalloc+0x2f0/0x440
[Tue Aug 20 00:02:00 2024] Code: 8b 7d f0 01 c2 c1 e2 0c c7 45 d8 00 00 00 =
00
89 55 d4 39 d6 89 f9 83 d9 00 0f 8d 1e ff ff ff 89 75 d4 89 7d d8 e9 13 ff =
ff
ff <0f> 0b 39 45 dc 8b 4d e4 19 d1 0f 8c b8 00 00 00 8b 45 ec 8b 7d dc
[Tue Aug 20 00:02:00 2024] EAX: a733f000 EBX: 00000000 ECX: a733f000 EDX:
00000000
[Tue Aug 20 00:02:00 2024] ESI: a733f000 EDI: 00000000 EBP: 86df3bd0 ESP:
86df3b80
[Tue Aug 20 00:02:00 2024] DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068 EFL=
AGS:
00010246
[Tue Aug 20 00:02:00 2024] CR0: 80050033 CR2: 37f87000 CR3: 0185a6e0 CR4:
00350ef0
[Tue Aug 20 00:02:00 2024] Call Trace:
[Tue Aug 20 00:02:00 2024]  ? show_regs.cold+0x16/0x1b
[Tue Aug 20 00:02:00 2024]  ?
iomap_file_buffered_write_punch_delalloc+0x2f0/0x440
[Tue Aug 20 00:02:00 2024]  ? __warn+0x87/0xe0
[Tue Aug 20 00:02:00 2024]  ?
iomap_file_buffered_write_punch_delalloc+0x2f0/0x440
[Tue Aug 20 00:02:00 2024]  ?
iomap_file_buffered_write_punch_delalloc+0x2f0/0x440
[Tue Aug 20 00:02:00 2024]  ? report_bug+0xe5/0x170
[Tue Aug 20 00:02:00 2024]  ? exc_overflow+0x60/0x60
[Tue Aug 20 00:02:00 2024]  ? handle_bug+0x2a/0x50
[Tue Aug 20 00:02:00 2024]  ? exc_invalid_op+0x1e/0x70
[Tue Aug 20 00:02:00 2024]  ? handle_exception+0x101/0x101
[Tue Aug 20 00:02:00 2024]  ? exc_overflow+0x60/0x60
[Tue Aug 20 00:02:00 2024]  ?
iomap_file_buffered_write_punch_delalloc+0x2f0/0x440
[Tue Aug 20 00:02:00 2024]  ? exc_overflow+0x60/0x60
[Tue Aug 20 00:02:00 2024]  ?
iomap_file_buffered_write_punch_delalloc+0x2f0/0x440
[Tue Aug 20 00:02:00 2024]  ? xfs_dax_write_iomap_end+0xa0/0xa0
[Tue Aug 20 00:02:00 2024]  xfs_buffered_write_iomap_end+0x52/0xc0
[Tue Aug 20 00:02:00 2024]  ? xfs_buffered_write_iomap_end+0xc0/0xc0
[Tue Aug 20 00:02:00 2024]  iomap_iter+0xce/0x4b0
[Tue Aug 20 00:02:00 2024]  ? xfs_dax_write_iomap_end+0xa0/0xa0
[Tue Aug 20 00:02:00 2024]  iomap_file_buffered_write+0xa9/0x420
[Tue Aug 20 00:02:00 2024]  xfs_file_buffered_write+0x9d/0x2e0
[Tue Aug 20 00:02:00 2024]  xfs_file_write_iter+0xc9/0x100
[Tue Aug 20 00:02:00 2024]  fileio_exec_async+0x25e/0x3a0 [scst_vdisk]
[Tue Aug 20 00:02:00 2024]  fileio_exec_write+0x2ce/0x400 [scst_vdisk]
[Tue Aug 20 00:02:00 2024]  ? __switch_to_asm+0xdd/0xf0
[Tue Aug 20 00:02:00 2024]  ? __switch_to_asm+0xd7/0xf0
[Tue Aug 20 00:02:00 2024]  ? __switch_to_asm+0xd1/0xf0
[Tue Aug 20 00:02:00 2024]  ? __switch_to_asm+0xcb/0xf0
[Tue Aug 20 00:02:00 2024]  vdev_do_job+0x36/0xe0 [scst_vdisk]
[Tue Aug 20 00:02:00 2024]  ? __switch_to_asm+0x8f/0xf0
[Tue Aug 20 00:02:00 2024]  fileio_exec+0x1f/0x30 [scst_vdisk]
[Tue Aug 20 00:02:00 2024]  scst_do_real_exec+0x51/0x130 [scst]
[Tue Aug 20 00:02:00 2024]  scst_exec_check_blocking+0xa8/0x220 [scst]
[Tue Aug 20 00:02:00 2024]  scst_process_active_cmd+0x200/0x18f0 [scst]
[Tue Aug 20 00:02:00 2024]  scst_cmd_thread+0x15c/0x500 [scst]
[Tue Aug 20 00:02:00 2024]  ? prepare_to_wait_event+0x160/0x160
[Tue Aug 20 00:02:00 2024]  kthread+0xd2/0x100
[Tue Aug 20 00:02:00 2024]  ? scst_cmd_done_local+0x90/0x90 [scst]
[Tue Aug 20 00:02:00 2024]  ? kthread_complete_and_exit+0x20/0x20
[Tue Aug 20 00:02:00 2024]  ret_from_fork+0x1c/0x28
[Tue Aug 20 00:02:00 2024] ---[ end trace 0000000000000000 ]---

Now my question is:
Where we have to search for the problem? At the kernel-maintaining staff or=
 at
the maintainer @SCST?

Thanks in advance and for investigation,
Mike

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
