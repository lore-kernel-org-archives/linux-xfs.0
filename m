Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3D22224AE3
	for <linux-xfs@vger.kernel.org>; Thu, 19 Dec 2024 13:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734616719; cv=none; b=JC9b/wiN5gM2NnO+rmD9JcOB56f15rCGBSS5CgErI/AmTbPX/GafqXWg2NhcUo3yf5v1ScDqkHwHJQjsKAX0U1ldy2jVSC2c9vqxi19o/haLP5JTC6xiUCkkikMo0HaHkiwQ4Jm8885lhSOKU5+vlccp32SFI1niAGgL+tUnIAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734616719; c=relaxed/simple;
	bh=a3gABU68ZHg7WBjOKd2l1+bqSv81PQ3BEBi/YdbDUM8=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=n1/4xkGaA6KcXa0PPNWKtBWoAlHhDkXR0//aEUYOmVjyHB7/ejqPZ1lPqsME2vuiRRg5txIzlqnQNMBCMzs/z5K9IbRM5DqADGSdGHoajGbnUuAw3ew8G2pB9WpmAoYgwD2H0vCEV1L7g9HsXEGKxr89FiqSManG7ijd1kdms/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S1ClcavD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S1ClcavD"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3AA6FC4CEDF
	for <linux-xfs@vger.kernel.org>; Thu, 19 Dec 2024 13:58:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734616719;
	bh=a3gABU68ZHg7WBjOKd2l1+bqSv81PQ3BEBi/YdbDUM8=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=S1ClcavD4kIZsu3Q1LUoPzn8Sd97I2j+e+AmCbEw7BNLhlihpyaSggBbDm1tMzJAa
	 y7z00dgwFDB9CrQ1K1smGWPUz3zZb7K/UCGX/s7kiogN8oWWav/ypoQYMC5pARbNME
	 UQkLXSkt73sGX2048MHDOUhxvxw3NiD5WNkHpvxERxrPHYDrfC7EmkGeF+gVD0YvJA
	 GwBGyvL/odi4BE+t7d7XNAMBmPR0Ts3KbUnejV6iKPdddfkTpKY75NnOd/xdxOax+j
	 8CTgtvK+mp+cJKVSVGTgrx6PEFC7UztPDYPi533torCj7DefyehYBZieLBK3MX7+gn
	 a8gSbFiIsC7mA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 348E9C3279E; Thu, 19 Dec 2024 13:58:39 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-xfs@vger.kernel.org
Subject: [Bug 219504] XFS crashes with kernel Version > 6.1.91. Perhaps
 Changes in kernel 6.1.92 for XFS/iomap causing the problems?
Date: Thu, 19 Dec 2024 13:58:38 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: speedcracker@hotmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: component cf_kernel_version product
Message-ID: <bug-219504-201763-muHGWZfemd@https.bugzilla.kernel.org/>
In-Reply-To: <bug-219504-201763@https.bugzilla.kernel.org/>
References: <bug-219504-201763@https.bugzilla.kernel.org/>
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

Mike-SPC (speedcracker@hotmail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
          Component|XFS                         |Other
     Kernel Version|6.1.92 and up               |since 6.1.92 and up
            Product|File System                 |IO/Storage

--- Comment #3 from Mike-SPC (speedcracker@hotmail.com) ---
Hi there,

rechecked the newest kernel version 6.1.120.

Get the same problem.

Here is the kernel-backtrace:

[Thu Dec 19 14:03:21 2024] ------------[ cut here ]------------
[Thu Dec 19 14:03:21 2024] WARNING: CPU: 0 PID: 24318 at
fs/iomap/buffered-io.c:980 iomap_file_buffered_write_punch_delalloc+0x398/0=
x440
[Thu Dec 19 14:03:21 2024] Modules linked in: iscsi_scst(O) scst_vdisk(O)
scst(O) dlm quota_v2 quota_tree autofs4 tcp_bbr sch_fq udf crc_itu_t ses
enclosure hid_generic wmi_bmof usbhid edac_mce_amd uas crc32_pclmul aesni_i=
ntel
hid crypto_simd usb_storage rapl bnx2 i2c_piix4 r8169 pcspkr k10temp ccp
i2c_core sha1_generic video mpt3sas backlight wmi
[Thu Dec 19 14:03:21 2024] CPU: 0 PID: 24318 Comm: disk014_0 Tainted: G S=
=20=20=20=20=20=20
  O       6.1.120_LFS_FILE01 #1
[Thu Dec 19 14:03:21 2024] Hardware name: To Be Filled By O.E.M. X370 Pro4/=
X370
Pro4, BIOS P10.08 01/22/2024
[Thu Dec 19 14:03:21 2024] EIP:
iomap_file_buffered_write_punch_delalloc+0x398/0x440
[Thu Dec 19 14:03:21 2024] Code: 84 8d 00 00 00 8b 45 e0 8b 40 20 83 c0 10 =
e8
2f 31 e0 ff 83 c4 44 89 f0 5b 5e 5f 5d e9 f5 31 8e 00 90 0f 0b e9 13 fe ff =
ff
90 <0f> 0b e9 fd fd ff ff 90 0f 0b e9 6b fe ff ff 90 0f 0b 8d b6 00 00
[Thu Dec 19 14:03:21 2024] EAX: bb68e000 EBX: ffffff85 ECX: bb68f000 EDX:
0000007b
[Thu Dec 19 14:03:21 2024] ESI: bb68f000 EDI: 00000000 EBP: 5137fbd0 ESP:
5137fb80
[Thu Dec 19 14:03:21 2024] DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068 EFL=
AGS:
00010293
[Thu Dec 19 14:03:21 2024] CR0: 80050033 CR2: 0175a2d0 CR3: 03d1b720 CR4:
00350ef0
[Thu Dec 19 14:03:21 2024] Call Trace:
[Thu Dec 19 14:03:21 2024]  ? show_regs.cold+0x16/0x1b
[Thu Dec 19 14:03:21 2024]  ?
iomap_file_buffered_write_punch_delalloc+0x398/0x440
[Thu Dec 19 14:03:21 2024]  ? __warn+0x87/0xe0
[Thu Dec 19 14:03:21 2024]  ?
iomap_file_buffered_write_punch_delalloc+0x398/0x440
[Thu Dec 19 14:03:21 2024]  ?
iomap_file_buffered_write_punch_delalloc+0x398/0x440
[Thu Dec 19 14:03:21 2024]  ? report_bug+0xe5/0x170
[Thu Dec 19 14:03:21 2024]  ? exc_overflow+0x60/0x60
[Thu Dec 19 14:03:21 2024]  ? handle_bug+0x2a/0x50
[Thu Dec 19 14:03:21 2024]  ? exc_invalid_op+0x1e/0x70
[Thu Dec 19 14:03:21 2024]  ? handle_exception+0x101/0x101
[Thu Dec 19 14:03:21 2024]  ? exc_overflow+0x60/0x60
[Thu Dec 19 14:03:21 2024]  ?
iomap_file_buffered_write_punch_delalloc+0x398/0x440
[Thu Dec 19 14:03:21 2024]  ? exc_overflow+0x60/0x60
[Thu Dec 19 14:03:21 2024]  ?
iomap_file_buffered_write_punch_delalloc+0x398/0x440
[Thu Dec 19 14:03:21 2024]  ? xfs_dax_write_iomap_end+0xa0/0xa0
[Thu Dec 19 14:03:21 2024]  ? xfs_buffered_write_iomap_end+0x52/0xc0
[Thu Dec 19 14:03:21 2024]  ? xfs_buffered_write_iomap_end+0xc0/0xc0
[Thu Dec 19 14:03:21 2024]  ? iomap_iter+0xce/0x4b0
[Thu Dec 19 14:03:21 2024]  ? xfs_dax_write_iomap_end+0xa0/0xa0
[Thu Dec 19 14:03:21 2024]  ? iomap_file_buffered_write+0xa9/0x420
[Thu Dec 19 14:03:21 2024]  ? xfs_file_buffered_write+0x9d/0x2e0
[Thu Dec 19 14:03:21 2024]  ? xfs_file_write_iter+0xc9/0x100
[Thu Dec 19 14:03:21 2024]  ? fileio_exec_async+0x25e/0x3a0 [scst_vdisk]
[Thu Dec 19 14:03:21 2024]  ? fileio_exec_write+0x2ce/0x400 [scst_vdisk]
[Thu Dec 19 14:03:21 2024]  ? vdev_do_job+0x36/0xe0 [scst_vdisk]
[Thu Dec 19 14:03:21 2024]  ? fileio_exec+0x1f/0x30 [scst_vdisk]
[Thu Dec 19 14:03:21 2024]  ? scst_do_real_exec+0x51/0x130 [scst]
[Thu Dec 19 14:03:21 2024]  ? scst_exec_check_blocking+0xa8/0x220 [scst]
[Thu Dec 19 14:03:21 2024]  ? scst_process_active_cmd+0x200/0x18f0 [scst]
[Thu Dec 19 14:03:21 2024]  ? scst_cmd_thread+0x15c/0x500 [scst]
[Thu Dec 19 14:03:21 2024]  ? prepare_to_wait_event+0x160/0x160
[Thu Dec 19 14:03:21 2024]  ? kthread+0xd2/0x100
[Thu Dec 19 14:03:21 2024]  ? scst_cmd_done_local+0x90/0x90 [scst]
[Thu Dec 19 14:03:21 2024]  ? kthread_complete_and_exit+0x20/0x20
[Thu Dec 19 14:03:21 2024]  ? ret_from_fork+0x1c/0x28
[Thu Dec 19 14:03:21 2024] ---[ end trace 0000000000000000 ]---

Thanks in advance and for investigation,
Mike

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
