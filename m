Received: from mail.flyingcircus.io (mail.flyingcircus.io [212.122.41.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BFD2253F31;
	Thu, 12 Jun 2025 13:47:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.122.41.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749736047; cv=none; b=IfGTjSwWAa3Dw4GUdlZ49xzoG2fy40yqM05c0bXpZ65tqkFOP4P5I2FFrBwBahCywXS3LbU7QIcQkaaLyd7HyIW02f+NoxjIv9+MBh6dwnPZPNN3HH2AUcVObSe2pPXdM3NVahPmpuEi1p9Ss8yKNtM3Vh87G6ebQ7J2vsBREMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749736047; c=relaxed/simple;
	bh=Pvuj9pAxIz7mLXFOXba+t2n+RCk71xIr8nKgL9+JOO8=;
	h=From:Content-Type:Mime-Version:Subject:Message-Id:Date:Cc:To; b=e3QtI0TjFNBfnlhzcCZXcdh60ZYY2lP5UPGPpOG+GM/xSZYJLe3+D8xqMtY3UqYmn3b06cLibmHTQqSCinWy1VNxmwPx/hl8nmlzjqiEpfY1+0iaUVexoTtojP0+zCqGM9gNfm7UO21YAyytLgDb7VyIAjcObDU45ukAAiwGSZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=flyingcircus.io; spf=pass smtp.mailfrom=flyingcircus.io; dkim=pass (1024-bit key) header.d=flyingcircus.io header.i=@flyingcircus.io header.b=RwFcJeYX; arc=none smtp.client-ip=212.122.41.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=flyingcircus.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flyingcircus.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=flyingcircus.io header.i=@flyingcircus.io header.b="RwFcJeYX"
From: Christian Theune <ct@flyingcircus.io>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flyingcircus.io;
	s=mail; t=1749735440;
	bh=3TlGAtxtpqvEfwZk63765rGD1M5QWLTCKikOtsGJA0k=;
	h=From:Subject:Date:Cc:To;
	b=RwFcJeYXxl3sP4IkFDg9m9cazbxN7WhTwBh39MZymb9JH4l7f5Hz/jzI+3TFTqRMI
	 9nOqjuArh4ykq/xIX/bo/H/+ueeiykmieM5lDJALylmXXMbhGprM+pifjwzgOeVS5X
	 6FhKbDjMIHPeL5K9LOIx/r7zuFVFBnPobbbn4OiE=
Content-Type: multipart/mixed;
	boundary="Apple-Mail=_8F35269A-219F-4ACA-AF31-F1AF0952BBE5"
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.600.51.1.1\))
Subject: temporary hung tasks on XFS since updating to 6.6.92
Message-Id: <14E1A49D-23BF-4929-A679-E6D5C8977D40@flyingcircus.io>
Date: Thu, 12 Jun 2025 15:37:10 +0200
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
 regressions@lists.linux.dev
To: stable@vger.kernel.org


--Apple-Mail=_8F35269A-219F-4ACA-AF31-F1AF0952BBE5
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8

Hi,

in the last week, after updating to 6.6.92, we=E2=80=99ve encountered a =
number of VMs reporting temporarily hung tasks blocking the whole system =
for a few minutes. They unblock by themselves and have similar =
tracebacks.

The IO PSIs show 100% pressure for that time, but the underlying devices =
are still processing read and write IO (well within their capacity). =
I=E2=80=99ve eliminated the underlying storage (Ceph) as the source of =
problems as I couldn=E2=80=99t find any latency outliers or significant =
queuing during that time.

I=E2=80=99ve seen somewhat similar reports on 6.6.88 and 6.6.77, but =
those might have been different outliers.

I=E2=80=99m attaching 3 logs - my intuition and the data so far leads me =
to consider this might be a kernel bug. I haven=E2=80=99t found a way to =
reproduce this, yet.


--Apple-Mail=_8F35269A-219F-4ACA-AF31-F1AF0952BBE5
Content-Disposition: attachment;
	filename=kernel-machine1.log
Content-Type: application/octet-stream;
	x-unix-mode=0644;
	name="kernel-machine1.log"
Content-Transfer-Encoding: 7bit

Jun 10 16:03:08 machine1 kernel: INFO: task xfsaild/vda1:188 blocked for more than 122 seconds.
Jun 10 16:03:08 machine1 kernel:       Not tainted 6.6.92 #1-NixOS
Jun 10 16:03:08 machine1 kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jun 10 16:03:08 machine1 kernel: task:xfsaild/vda1    state:D stack:0     pid:188   ppid:2      flags:0x00004000
Jun 10 16:03:08 machine1 kernel: Call Trace:
Jun 10 16:03:08 machine1 kernel:  <TASK>
Jun 10 16:03:08 machine1 kernel:  __schedule+0x3fc/0x1440
Jun 10 16:03:08 machine1 kernel:  schedule+0x5e/0xe0
Jun 10 16:03:08 machine1 kernel:  schedule_timeout+0x159/0x170
Jun 10 16:03:08 machine1 kernel:  wait_for_completion+0x8a/0x160
Jun 10 16:03:08 machine1 kernel:  __flush_workqueue+0x157/0x440
Jun 10 16:03:08 machine1 kernel:  ? finish_task_switch.isra.0+0x94/0x300
Jun 10 16:03:08 machine1 kernel:  xlog_cil_push_now.isra.0+0x5e/0xa0 [xfs]
Jun 10 16:03:08 machine1 kernel:  xlog_cil_force_seq+0x69/0x250 [xfs]
Jun 10 16:03:08 machine1 kernel:  ? __timer_delete_sync+0x7d/0xe0
Jun 10 16:03:08 machine1 kernel:  xfs_log_force+0x7e/0x240 [xfs]
Jun 10 16:03:08 machine1 kernel:  xfsaild+0x17d/0x870 [xfs]
Jun 10 16:03:08 machine1 kernel:  ? __set_cpus_allowed_ptr_locked+0xf4/0x1c0
Jun 10 16:03:08 machine1 kernel:  ? __pfx_xfsaild+0x10/0x10 [xfs]
Jun 10 16:03:08 machine1 kernel:  kthread+0xe8/0x120
Jun 10 16:03:08 machine1 kernel:  ? __pfx_kthread+0x10/0x10
Jun 10 16:03:08 machine1 kernel:  ret_from_fork+0x34/0x50
Jun 10 16:03:08 machine1 kernel:  ? __pfx_kthread+0x10/0x10
Jun 10 16:03:08 machine1 kernel:  ret_from_fork_asm+0x1b/0x30
Jun 10 16:03:08 machine1 kernel:  </TASK>
Jun 10 16:03:08 machine1 kernel: INFO: task systemd-journal:407 blocked for more than 122 seconds.
Jun 10 16:03:08 machine1 kernel:       Not tainted 6.6.92 #1-NixOS
Jun 10 16:03:08 machine1 kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jun 10 16:03:08 machine1 kernel: task:systemd-journal state:D stack:0     pid:407   ppid:1      flags:0x00000002
Jun 10 16:03:08 machine1 kernel: Call Trace:
Jun 10 16:03:08 machine1 kernel:  <TASK>
Jun 10 16:03:08 machine1 kernel:  __schedule+0x3fc/0x1440
Jun 10 16:03:08 machine1 kernel:  ? __mod_memcg_lruvec_state+0x58/0xb0
Jun 10 16:03:08 machine1 kernel:  schedule+0x5e/0xe0
Jun 10 16:03:08 machine1 kernel:  xlog_grant_head_wait+0xba/0x220 [xfs]
Jun 10 16:03:08 machine1 kernel:  xlog_grant_head_check+0xdf/0x110 [xfs]
Jun 10 16:03:08 machine1 kernel:  xfs_log_reserve+0xc4/0x1f0 [xfs]
Jun 10 16:03:08 machine1 kernel:  xfs_trans_reserve+0x138/0x170 [xfs]
Jun 10 16:03:08 machine1 kernel:  xfs_trans_alloc+0xe5/0x230 [xfs]
Jun 10 16:03:08 machine1 kernel:  xfs_vn_update_time+0x90/0x1b0 [xfs]
Jun 10 16:03:08 machine1 kernel:  file_update_time+0x61/0x90
Jun 10 16:03:08 machine1 kernel:  __xfs_filemap_fault.constprop.0+0xd4/0x1d0 [xfs]
Jun 10 16:03:08 machine1 kernel:  do_page_mkwrite+0x50/0xb0
Jun 10 16:03:08 machine1 kernel:  do_wp_page+0x431/0xb80
Jun 10 16:03:08 machine1 kernel:  ? filename_lookup+0xe8/0x200
Jun 10 16:03:08 machine1 kernel:  ? __pte_offset_map+0x1b/0x190
Jun 10 16:03:08 machine1 kernel:  __handle_mm_fault+0xbcf/0xd90
Jun 10 16:03:08 machine1 kernel:  handle_mm_fault+0x17f/0x370
Jun 10 16:03:08 machine1 kernel:  do_user_addr_fault+0x1ee/0x630
Jun 10 16:03:08 machine1 kernel:  exc_page_fault+0x71/0x160
Jun 10 16:03:08 machine1 kernel:  asm_exc_page_fault+0x26/0x30
Jun 10 16:03:08 machine1 kernel: RIP: 0033:0x7fc7798def5f
Jun 10 16:03:08 machine1 kernel: RSP: 002b:00007ffd050a0ee0 EFLAGS: 00010246
Jun 10 16:03:08 machine1 kernel: RAX: 00007fc767892d68 RBX: 000055d3034cd900 RCX: 00007fc77999d300
Jun 10 16:03:08 machine1 kernel: RDX: 0000000000000000 RSI: 00007fc767892d68 RDI: 000055d3034cd900
Jun 10 16:03:08 machine1 kernel: RBP: 0000000002bc3c40 R08: 00000000000000c9 R09: 000055d3034cd938
Jun 10 16:03:08 machine1 kernel: R10: 0000000000000000 R11: 0000000000000000 R12: 00007ffd050a1b00
Jun 10 16:03:08 machine1 kernel: R13: 00000000001df770 R14: 00007ffd050a10a8 R15: 00007ffd050a10a0
Jun 10 16:03:08 machine1 kernel:  </TASK>
Jun 10 16:03:08 machine1 kernel: INFO: task systemd-timesyn:804 blocked for more than 122 seconds.
Jun 10 16:03:08 machine1 kernel:       Not tainted 6.6.92 #1-NixOS
Jun 10 16:03:08 machine1 kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jun 10 16:03:08 machine1 kernel: task:systemd-timesyn state:D stack:0     pid:804   ppid:1      flags:0x00000002
Jun 10 16:03:08 machine1 kernel: Call Trace:
Jun 10 16:03:08 machine1 kernel:  <TASK>
Jun 10 16:03:08 machine1 kernel:  __schedule+0x3fc/0x1440
Jun 10 16:03:08 machine1 kernel:  schedule+0x5e/0xe0
Jun 10 16:03:08 machine1 kernel:  xlog_grant_head_wait+0xba/0x220 [xfs]
Jun 10 16:03:08 machine1 kernel:  xlog_grant_head_check+0xdf/0x110 [xfs]
Jun 10 16:03:08 machine1 kernel:  xfs_log_reserve+0xc4/0x1f0 [xfs]
Jun 10 16:03:08 machine1 kernel:  xfs_trans_reserve+0x138/0x170 [xfs]
Jun 10 16:03:08 machine1 kernel:  xfs_trans_alloc+0xe5/0x230 [xfs]
Jun 10 16:03:08 machine1 kernel:  xfs_trans_alloc_ichange+0x85/0x200 [xfs]
Jun 10 16:03:08 machine1 kernel:  xfs_setattr_nonsize+0x9a/0x390 [xfs]
Jun 10 16:03:08 machine1 kernel:  notify_change+0x1f5/0x4c0
Jun 10 16:03:08 machine1 kernel:  ? vfs_utimes+0x141/0x270
Jun 10 16:03:08 machine1 kernel:  vfs_utimes+0x141/0x270
Jun 10 16:03:08 machine1 kernel:  do_utimes+0xf8/0x160
Jun 10 16:03:08 machine1 kernel:  __x64_sys_utimensat+0xa1/0xf0
Jun 10 16:03:08 machine1 kernel:  do_syscall_64+0x39/0x90
Jun 10 16:03:08 machine1 kernel:  entry_SYSCALL_64_after_hwframe+0x78/0xe2
Jun 10 16:03:08 machine1 kernel: RIP: 0033:0x7f0c14f0ae53
Jun 10 16:03:08 machine1 kernel: RSP: 002b:00007fff88b9d388 EFLAGS: 00000206 ORIG_RAX: 0000000000000118
Jun 10 16:03:08 machine1 kernel: RAX: ffffffffffffffda RBX: 0000000000000011 RCX: 00007f0c14f0ae53
Jun 10 16:03:08 machine1 kernel: RDX: 0000000000000000 RSI: 00007f0c15320f09 RDI: 0000000000000011
Jun 10 16:03:08 machine1 kernel: RBP: 0000000000000000 R08: 00000000ffffffff R09: 00000000ffffffff
Jun 10 16:03:08 machine1 kernel: R10: 0000000000001000 R11: 0000000000000206 R12: 000055aa6cdbc000
Jun 10 16:03:08 machine1 kernel: R13: 00000000ffffffff R14: ffffffffffffffff R15: 00000000ffffffff
Jun 10 16:03:08 machine1 kernel:  </TASK>
Jun 10 16:03:08 machine1 kernel: INFO: task filebeat:1200 blocked for more than 122 seconds.
Jun 10 16:03:08 machine1 kernel:       Not tainted 6.6.92 #1-NixOS
Jun 10 16:03:08 machine1 kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jun 10 16:03:08 machine1 kernel: task:filebeat        state:D stack:0     pid:1200  ppid:1      flags:0x00000002
Jun 10 16:03:08 machine1 kernel: Call Trace:
Jun 10 16:03:08 machine1 kernel:  <TASK>
Jun 10 16:03:08 machine1 kernel:  __schedule+0x3fc/0x1440
Jun 10 16:03:08 machine1 kernel:  ? ip6_input_finish+0x48/0x70
Jun 10 16:03:11 machine1 kernel:  ? _copy_to_iter+0x62/0x4b0
Jun 10 16:03:11 machine1 kernel:  ? free_unref_page_commit+0x76/0x180
Jun 10 16:03:11 machine1 kernel:  schedule+0x5e/0xe0
Jun 10 16:03:11 machine1 kernel:  xlog_grant_head_wait+0xba/0x220 [xfs]
Jun 10 16:03:11 machine1 kernel:  xlog_grant_head_check+0xdf/0x110 [xfs]
Jun 10 16:03:11 machine1 kernel:  xfs_log_reserve+0xc4/0x1f0 [xfs]
Jun 10 16:03:11 machine1 kernel:  xfs_trans_reserve+0x138/0x170 [xfs]
Jun 10 16:03:11 machine1 kernel:  xfs_trans_alloc+0xe5/0x230 [xfs]
Jun 10 16:03:11 machine1 kernel:  xfs_vn_update_time+0x90/0x1b0 [xfs]
Jun 10 16:03:11 machine1 kernel:  kiocb_modified+0x9b/0xd0
Jun 10 16:03:11 machine1 kernel:  xfs_file_write_checks+0x1dd/0x280 [xfs]
Jun 10 16:03:11 machine1 kernel:  xfs_file_buffered_write+0x60/0x2b0 [xfs]
Jun 10 16:03:11 machine1 kernel:  ? selinux_file_permission+0x119/0x160
Jun 10 16:03:11 machine1 kernel:  vfs_write+0x24f/0x430
Jun 10 16:03:11 machine1 kernel:  ksys_write+0x6f/0xf0
Jun 10 16:03:11 machine1 kernel:  do_syscall_64+0x39/0x90
Jun 10 16:03:11 machine1 kernel:  entry_SYSCALL_64_after_hwframe+0x78/0xe2
Jun 10 16:03:11 machine1 kernel: RIP: 0033:0x116ac4e
Jun 10 16:03:11 machine1 kernel: RSP: 002b:000000c000925600 EFLAGS: 00000212 ORIG_RAX: 0000000000000001
Jun 10 16:03:11 machine1 kernel: RAX: ffffffffffffffda RBX: 0000000000000006 RCX: 000000000116ac4e
Jun 10 16:03:11 machine1 kernel: RDX: 0000000000000175 RSI: 000000c000602000 RDI: 0000000000000006
Jun 10 16:03:11 machine1 kernel: RBP: 000000c000925640 R08: 0000000000000000 R09: 0000000000000000
Jun 10 16:03:11 machine1 kernel: R10: 0000000000000000 R11: 0000000000000212 R12: 000000c000925770
Jun 10 16:03:11 machine1 kernel: R13: 0000000000000010 R14: 000000c00044ea80 R15: 000000c00066c7e0
Jun 10 16:03:11 machine1 kernel:  </TASK>
Jun 10 16:03:11 machine1 kernel: INFO: task slapd:1168 blocked for more than 122 seconds.
Jun 10 16:03:11 machine1 kernel:       Not tainted 6.6.92 #1-NixOS
Jun 10 16:03:11 machine1 kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jun 10 16:03:11 machine1 kernel: task:slapd           state:D stack:0     pid:1168  ppid:1      flags:0x00000002
Jun 10 16:03:11 machine1 kernel: Call Trace:
Jun 10 16:03:11 machine1 kernel:  <TASK>
Jun 10 16:03:11 machine1 kernel:  __schedule+0x3fc/0x1440
Jun 10 16:03:11 machine1 kernel:  schedule+0x5e/0xe0
Jun 10 16:03:11 machine1 kernel:  xlog_grant_head_wait+0xba/0x220 [xfs]
Jun 10 16:03:11 machine1 kernel:  xlog_grant_head_check+0xdf/0x110 [xfs]
Jun 10 16:03:11 machine1 kernel:  xfs_log_reserve+0xc4/0x1f0 [xfs]
Jun 10 16:03:11 machine1 kernel:  xfs_trans_reserve+0x138/0x170 [xfs]
Jun 10 16:03:11 machine1 kernel:  xfs_trans_alloc+0xe5/0x230 [xfs]
Jun 10 16:03:11 machine1 kernel:  xfs_vn_update_time+0x90/0x1b0 [xfs]
Jun 10 16:03:11 machine1 kernel:  file_update_time+0x61/0x90
Jun 10 16:03:11 machine1 kernel:  __xfs_filemap_fault.constprop.0+0xd4/0x1d0 [xfs]
Jun 10 16:03:11 machine1 kernel:  do_page_mkwrite+0x50/0xb0
Jun 10 16:03:11 machine1 kernel:  do_wp_page+0x431/0xb80
Jun 10 16:03:11 machine1 kernel:  ? __pte_offset_map+0x1b/0x190
Jun 10 16:03:11 machine1 kernel:  __handle_mm_fault+0xbcf/0xd90
Jun 10 16:03:11 machine1 kernel:  handle_mm_fault+0x17f/0x370
Jun 10 16:03:11 machine1 kernel:  do_user_addr_fault+0x1ee/0x630
Jun 10 16:03:11 machine1 kernel:  exc_page_fault+0x71/0x160
Jun 10 16:03:11 machine1 kernel:  asm_exc_page_fault+0x26/0x30
Jun 10 16:03:11 machine1 kernel: RIP: 0033:0x4d0c04
Jun 10 16:03:11 machine1 kernel: RSP: 002b:00007efe565fd2a0 EFLAGS: 00010246
Jun 10 16:03:11 machine1 kernel: RAX: 000000000000a50b RBX: 00007efe4811ddd0 RCX: 0000000000000000
Jun 10 16:03:11 machine1 kernel: RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
Jun 10 16:03:11 machine1 kernel: RBP: 0000000039dfec40 R08: 0000000000000000 R09: 0000000000000000
Jun 10 16:03:11 machine1 kernel: R10: 0000000000000000 R11: 0000000000000000 R12: 00007efe9377d080
Jun 10 16:03:11 machine1 kernel: R13: 0000000000020000 R14: 000000000000048b R15: 00007efe9377d000
Jun 10 16:03:11 machine1 kernel:  </TASK>
Jun 10 16:03:11 machine1 kernel: INFO: task slapd:1253 blocked for more than 122 seconds.
Jun 10 16:03:11 machine1 kernel:       Not tainted 6.6.92 #1-NixOS
Jun 10 16:03:11 machine1 kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jun 10 16:03:11 machine1 kernel: task:slapd           state:D stack:0     pid:1253  ppid:1      flags:0x00000002
Jun 10 16:03:11 machine1 kernel: Call Trace:
Jun 10 16:03:11 machine1 kernel:  <TASK>
Jun 10 16:03:11 machine1 kernel:  __schedule+0x3fc/0x1440
Jun 10 16:03:11 machine1 kernel:  schedule+0x5e/0xe0
Jun 10 16:03:11 machine1 kernel:  xlog_grant_head_wait+0xba/0x220 [xfs]
Jun 10 16:03:11 machine1 kernel:  xlog_grant_head_check+0xdf/0x110 [xfs]
Jun 10 16:03:11 machine1 kernel:  xfs_log_reserve+0xc4/0x1f0 [xfs]
Jun 10 16:03:11 machine1 kernel:  xfs_trans_reserve+0x138/0x170 [xfs]
Jun 10 16:03:11 machine1 kernel:  xfs_trans_alloc+0xe5/0x230 [xfs]
Jun 10 16:03:11 machine1 kernel:  xfs_vn_update_time+0x90/0x1b0 [xfs]
Jun 10 16:03:11 machine1 kernel:  file_update_time+0x61/0x90
Jun 10 16:03:11 machine1 kernel:  __xfs_filemap_fault.constprop.0+0xd4/0x1d0 [xfs]
Jun 10 16:03:11 machine1 kernel:  do_page_mkwrite+0x50/0xb0
Jun 10 16:03:11 machine1 kernel:  do_wp_page+0x431/0xb80
Jun 10 16:03:11 machine1 kernel:  ? __pte_offset_map+0x1b/0x190
Jun 10 16:03:11 machine1 kernel:  __handle_mm_fault+0xbcf/0xd90
Jun 10 16:03:11 machine1 kernel:  handle_mm_fault+0x17f/0x370
Jun 10 16:03:11 machine1 kernel:  do_user_addr_fault+0x1ee/0x630
Jun 10 16:03:11 machine1 kernel:  exc_page_fault+0x71/0x160
Jun 10 16:03:11 machine1 kernel:  asm_exc_page_fault+0x26/0x30
Jun 10 16:03:11 machine1 kernel: RIP: 0033:0x4d0c04
Jun 10 16:03:11 machine1 kernel: RSP: 002b:00007efe47ffe2a0 EFLAGS: 00010246
Jun 10 16:03:11 machine1 kernel: RAX: 000000000000a50b RBX: 00007efe40013590 RCX: 0000000000000000
Jun 10 16:03:11 machine1 kernel: RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
Jun 10 16:03:11 machine1 kernel: RBP: 0000000039dfec40 R08: 0000000000000000 R09: 0000000000000000
Jun 10 16:03:11 machine1 kernel: R10: 0000000000000000 R11: 0000000000000000 R12: 00007efe9377d100
Jun 10 16:03:11 machine1 kernel: R13: 0000000000020000 R14: 000000000000048b R15: 00007efe9377d000
Jun 10 16:03:11 machine1 kernel:  </TASK>
Jun 10 16:03:11 machine1 kernel: INFO: task slapd:2783 blocked for more than 122 seconds.
Jun 10 16:03:11 machine1 kernel:       Not tainted 6.6.92 #1-NixOS
Jun 10 16:03:11 machine1 kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jun 10 16:03:11 machine1 kernel: task:slapd           state:D stack:0     pid:2783  ppid:1      flags:0x00000002
Jun 10 16:03:11 machine1 kernel: Call Trace:
Jun 10 16:03:11 machine1 kernel:  <TASK>
Jun 10 16:03:11 machine1 kernel:  __schedule+0x3fc/0x1440
Jun 10 16:03:11 machine1 kernel:  schedule+0x5e/0xe0
Jun 10 16:03:11 machine1 kernel:  xlog_grant_head_wait+0xba/0x220 [xfs]
Jun 10 16:03:11 machine1 kernel:  xlog_grant_head_check+0xdf/0x110 [xfs]
Jun 10 16:03:11 machine1 kernel:  xfs_log_reserve+0xc4/0x1f0 [xfs]
Jun 10 16:03:11 machine1 kernel:  xfs_trans_reserve+0x138/0x170 [xfs]
Jun 10 16:03:11 machine1 kernel:  xfs_trans_alloc+0xe5/0x230 [xfs]
Jun 10 16:03:11 machine1 kernel:  xfs_vn_update_time+0x90/0x1b0 [xfs]
Jun 10 16:03:11 machine1 kernel:  file_update_time+0x61/0x90
Jun 10 16:03:11 machine1 kernel:  __xfs_filemap_fault.constprop.0+0xd4/0x1d0 [xfs]
Jun 10 16:03:11 machine1 kernel:  do_page_mkwrite+0x50/0xb0
Jun 10 16:03:11 machine1 kernel:  do_wp_page+0x431/0xb80
Jun 10 16:03:11 machine1 kernel:  ? __pte_offset_map+0x1b/0x190
Jun 10 16:03:11 machine1 kernel:  __handle_mm_fault+0xbcf/0xd90
Jun 10 16:03:11 machine1 kernel:  handle_mm_fault+0x17f/0x370
Jun 10 16:03:11 machine1 kernel:  do_user_addr_fault+0x1ee/0x630
Jun 10 16:03:11 machine1 kernel:  exc_page_fault+0x71/0x160
Jun 10 16:03:11 machine1 kernel:  asm_exc_page_fault+0x26/0x30
Jun 10 16:03:11 machine1 kernel: RIP: 0033:0x4d0c04
Jun 10 16:03:11 machine1 kernel: RSP: 002b:00007efe44df92a0 EFLAGS: 00010246
Jun 10 16:03:11 machine1 kernel: RAX: 000000000000a50b RBX: 00007efe38132790 RCX: 0000000000000000
Jun 10 16:03:11 machine1 kernel: RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
Jun 10 16:03:11 machine1 kernel: RBP: 0000000039dfec40 R08: 0000000000000000 R09: 0000000000000000
Jun 10 16:03:11 machine1 kernel: R10: 0000000000000000 R11: 0000000000000000 R12: 00007efe9377d180
Jun 10 16:03:11 machine1 kernel: R13: 0000000000020000 R14: 000000000000048b R15: 00007efe9377d000
Jun 10 16:03:11 machine1 kernel:  </TASK>
Jun 10 16:03:11 machine1 kernel: INFO: task slapd:2787 blocked for more than 122 seconds.
Jun 10 16:03:11 machine1 kernel:       Not tainted 6.6.92 #1-NixOS
Jun 10 16:03:11 machine1 kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jun 10 16:03:11 machine1 kernel: task:slapd           state:D stack:0     pid:2787  ppid:1      flags:0x00000002
Jun 10 16:03:11 machine1 kernel: Call Trace:
Jun 10 16:03:11 machine1 kernel:  <TASK>
Jun 10 16:03:11 machine1 kernel:  __schedule+0x3fc/0x1440
Jun 10 16:03:11 machine1 kernel:  ? raw6_local_deliver+0x12a/0x250
Jun 10 16:03:11 machine1 kernel:  schedule+0x5e/0xe0
Jun 10 16:03:11 machine1 kernel:  xlog_grant_head_wait+0xba/0x220 [xfs]
Jun 10 16:03:11 machine1 kernel:  xlog_grant_head_check+0xdf/0x110 [xfs]
Jun 10 16:03:11 machine1 kernel:  xfs_log_reserve+0xc4/0x1f0 [xfs]
Jun 10 16:03:11 machine1 kernel:  xfs_trans_reserve+0x138/0x170 [xfs]
Jun 10 16:03:11 machine1 kernel:  xfs_trans_alloc+0xe5/0x230 [xfs]
Jun 10 16:03:11 machine1 kernel:  xfs_vn_update_time+0x90/0x1b0 [xfs]
Jun 10 16:03:11 machine1 kernel:  file_update_time+0x61/0x90
Jun 10 16:03:11 machine1 kernel:  __xfs_filemap_fault.constprop.0+0xd4/0x1d0 [xfs]
Jun 10 16:03:11 machine1 kernel:  do_page_mkwrite+0x50/0xb0
Jun 10 16:03:11 machine1 kernel:  do_wp_page+0x431/0xb80
Jun 10 16:03:11 machine1 kernel:  ? __pte_offset_map+0x1b/0x190
Jun 10 16:03:11 machine1 kernel:  __handle_mm_fault+0xbcf/0xd90
Jun 10 16:03:11 machine1 kernel:  handle_mm_fault+0x17f/0x370
Jun 10 16:03:11 machine1 kernel:  do_user_addr_fault+0x1ee/0x630
Jun 10 16:03:11 machine1 kernel:  exc_page_fault+0x71/0x160
Jun 10 16:03:11 machine1 kernel:  asm_exc_page_fault+0x26/0x30
Jun 10 16:03:11 machine1 kernel: RIP: 0033:0x4d0c04
Jun 10 16:03:11 machine1 kernel: RSP: 002b:00007efe3d0fa2a0 EFLAGS: 00010246
Jun 10 16:03:11 machine1 kernel: RAX: 000000000000a50b RBX: 00007efe34013c80 RCX: 0000000000000000
Jun 10 16:03:11 machine1 kernel: RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
Jun 10 16:03:11 machine1 kernel: RBP: 0000000039dfec40 R08: 0000000000000000 R09: 0000000000000000
Jun 10 16:03:11 machine1 kernel: R10: 0000000000000000 R11: 0000000000000000 R12: 00007efe9377d1c0
Jun 10 16:03:11 machine1 kernel: R13: 0000000000020000 R14: 000000000000048b R15: 00007efe9377d000
Jun 10 16:03:11 machine1 kernel:  </TASK>
Jun 10 16:03:11 machine1 kernel: INFO: task slapd:2791 blocked for more than 122 seconds.
Jun 10 16:03:11 machine1 kernel:       Not tainted 6.6.92 #1-NixOS
Jun 10 16:03:11 machine1 kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jun 10 16:03:11 machine1 kernel: task:slapd           state:D stack:0     pid:2791  ppid:1      flags:0x00000002
Jun 10 16:03:11 machine1 kernel: Call Trace:
Jun 10 16:03:11 machine1 kernel:  <TASK>
Jun 10 16:03:11 machine1 kernel:  __schedule+0x3fc/0x1440
Jun 10 16:03:11 machine1 kernel:  schedule+0x5e/0xe0
Jun 10 16:03:11 machine1 kernel:  xlog_grant_head_wait+0xba/0x220 [xfs]
Jun 10 16:03:11 machine1 kernel:  xlog_grant_head_check+0xdf/0x110 [xfs]
Jun 10 16:03:11 machine1 kernel:  xfs_log_reserve+0xc4/0x1f0 [xfs]
Jun 10 16:03:11 machine1 kernel:  xfs_trans_reserve+0x138/0x170 [xfs]
Jun 10 16:03:11 machine1 kernel:  xfs_trans_alloc+0xe5/0x230 [xfs]
Jun 10 16:03:11 machine1 kernel:  xfs_vn_update_time+0x90/0x1b0 [xfs]
Jun 10 16:03:11 machine1 kernel:  file_update_time+0x61/0x90
Jun 10 16:03:11 machine1 kernel:  __xfs_filemap_fault.constprop.0+0xd4/0x1d0 [xfs]
Jun 10 16:03:11 machine1 kernel:  do_page_mkwrite+0x50/0xb0
Jun 10 16:03:11 machine1 kernel:  do_wp_page+0x431/0xb80
Jun 10 16:03:11 machine1 kernel:  ? __pte_offset_map+0x1b/0x190
Jun 10 16:03:11 machine1 kernel:  __handle_mm_fault+0xbcf/0xd90
Jun 10 16:03:11 machine1 kernel:  handle_mm_fault+0x17f/0x370
Jun 10 16:03:11 machine1 kernel:  do_user_addr_fault+0x1ee/0x630
Jun 10 16:03:11 machine1 kernel:  exc_page_fault+0x71/0x160
Jun 10 16:03:11 machine1 kernel:  asm_exc_page_fault+0x26/0x30
Jun 10 16:03:11 machine1 kernel: RIP: 0033:0x4d0c04
Jun 10 16:03:11 machine1 kernel: RSP: 002b:00007efe2ddea250 EFLAGS: 00010246
Jun 10 16:03:11 machine1 kernel: RAX: 000000000000a50b RBX: 00007efe28203aa0 RCX: 0000000000000000
Jun 10 16:03:11 machine1 kernel: RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
Jun 10 16:03:11 machine1 kernel: RBP: 0000000039dfec40 R08: 0000000000000000 R09: 0000000000000000
Jun 10 16:03:11 machine1 kernel: R10: 0000000000000000 R11: 0000000000000000 R12: 00007efe9377d240
Jun 10 16:03:11 machine1 kernel: R13: 0000000000020000 R14: 000000000000048b R15: 00007efe9377d000
Jun 10 16:03:11 machine1 kernel:  </TASK>
Jun 10 16:03:11 machine1 kernel: INFO: task slapd:2792 blocked for more than 122 seconds.
Jun 10 16:03:11 machine1 kernel:       Not tainted 6.6.92 #1-NixOS
Jun 10 16:03:11 machine1 kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jun 10 16:03:11 machine1 kernel: task:slapd           state:D stack:0     pid:2792  ppid:1      flags:0x00000002
Jun 10 16:03:11 machine1 kernel: Call Trace:
Jun 10 16:03:11 machine1 kernel:  <TASK>
Jun 10 16:03:11 machine1 kernel:  __schedule+0x3fc/0x1440
Jun 10 16:03:11 machine1 kernel:  schedule+0x5e/0xe0
Jun 10 16:03:11 machine1 kernel:  xlog_grant_head_wait+0xba/0x220 [xfs]
Jun 10 16:03:11 machine1 kernel:  xlog_grant_head_check+0xdf/0x110 [xfs]
Jun 10 16:03:11 machine1 kernel:  xfs_log_reserve+0xc4/0x1f0 [xfs]
Jun 10 16:03:11 machine1 kernel:  xfs_trans_reserve+0x138/0x170 [xfs]
Jun 10 16:03:11 machine1 kernel:  xfs_trans_alloc+0xe5/0x230 [xfs]
Jun 10 16:03:11 machine1 kernel:  xfs_vn_update_time+0x90/0x1b0 [xfs]
Jun 10 16:03:11 machine1 kernel:  file_update_time+0x61/0x90
Jun 10 16:03:11 machine1 kernel:  __xfs_filemap_fault.constprop.0+0xd4/0x1d0 [xfs]
Jun 10 16:03:11 machine1 kernel:  do_page_mkwrite+0x50/0xb0
Jun 10 16:03:11 machine1 kernel:  do_wp_page+0x431/0xb80
Jun 10 16:03:11 machine1 kernel:  ? __pte_offset_map+0x1b/0x190
Jun 10 16:03:11 machine1 kernel:  __handle_mm_fault+0xbcf/0xd90
Jun 10 16:03:11 machine1 kernel:  handle_mm_fault+0x17f/0x370
Jun 10 16:03:11 machine1 kernel:  do_user_addr_fault+0x1ee/0x630
Jun 10 16:03:11 machine1 kernel:  exc_page_fault+0x71/0x160
Jun 10 16:03:11 machine1 kernel:  asm_exc_page_fault+0x26/0x30
Jun 10 16:03:11 machine1 kernel: RIP: 0033:0x4d0c04
Jun 10 16:03:11 machine1 kernel: RSP: 002b:00007efe2d5fa2a0 EFLAGS: 00010246
Jun 10 16:03:11 machine1 kernel: RAX: 000000000000a50b RBX: 00007efe34135cb0 RCX: 0000000000000000
Jun 10 16:03:11 machine1 kernel: RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
Jun 10 16:03:11 machine1 kernel: RBP: 0000000039dfec40 R08: 0000000000000000 R09: 0000000000000000
Jun 10 16:03:11 machine1 kernel: R10: 0000000000000000 R11: 0000000000000000 R12: 00007efe9377d2c0
Jun 10 16:03:11 machine1 kernel: R13: 0000000000020000 R14: 000000000000048b R15: 00007efe9377d000
Jun 10 16:03:11 machine1 kernel:  </TASK>
Jun 10 16:03:11 machine1 kernel: Future hung task reports are suppressed, see sysctl kernel.hung_task_warnings
Jun 10 16:03:11 machine1 systemd[1]: systemd-journald.service: Watchdog timeout (limit 3min)!
Jun 10 16:03:11 machine1 systemd[1]: systemd-journald.service: Killing process 407 (systemd-journal) with signal SIGABRT.
Jun 10 16:03:11 machine1 systemd[1]: Starting Serial console liveness marker...
Jun 10 16:03:11 machine1 systemd[1]: Starting Logrotate Service...
Jun 10 16:03:11 machine1 systemd[1]: serial-console-liveness.service: Deactivated successfully.
Jun 10 16:03:11 machine1 systemd[1]: Finished Serial console liveness marker.
Jun 10 16:03:11 machine1 systemd-coredump[274177]: Process 407 (systemd-journal) of user 0 terminated abnormally with signal 6/ABRT, processing...
Jun 10 16:03:11 machine1 systemd[1]: logrotate.service: Deactivated successfully.
Jun 10 16:03:11 machine1 systemd[1]: Finished Logrotate Service.
Jun 10 16:03:11 machine1 systemd-coredump[274177]: Process 407 (systemd-journal) of user 0 dumped core.
Jun 10 16:03:11 machine1 systemd-coredump[274177]: Coredump diverted to /var/lib/systemd/coredump/core.systemd-journal.0.42b57193ad0b49a48e0dd3e3abe28b31.407.1749564188000000.zst
Jun 10 16:03:11 machine1 systemd-coredump[274177]: Module libzstd.so.1 without build-id.
Jun 10 16:03:11 machine1 systemd-coredump[274177]: Module libaudit.so.1 without build-id.
Jun 10 16:03:11 machine1 systemd-coredump[274177]: Module libattr.so.1 without build-id.
Jun 10 16:03:11 machine1 systemd-coredump[274177]: Module libseccomp.so.2 without build-id.
Jun 10 16:03:11 machine1 systemd-coredump[274177]: Module libpam.so.0 without build-id.
Jun 10 16:03:11 machine1 systemd-coredump[274177]: Module libcrypt.so.2 without build-id.
Jun 10 16:03:11 machine1 systemd-coredump[274177]: Module libcap.so.2 without build-id.
Jun 10 16:03:11 machine1 systemd-coredump[274177]: Module libacl.so.1 without build-id.
Jun 10 16:03:11 machine1 systemd-coredump[274177]: Stack trace of thread 407:
Jun 10 16:03:11 machine1 systemd-coredump[274177]: #0  0x00007fc77968b4c0 n/a (libsystemd-shared-256.so + 0x8b4c0)
Jun 10 16:03:11 machine1 systemd-coredump[274177]: #1  0x00007fc7798decb4 journal_file_append_data (libsystemd-shared-256.so + 0x2decb4)
Jun 10 16:03:11 machine1 systemd-coredump[274177]: #2  0x00007fc7798df3f5 journal_file_append_entry (libsystemd-shared-256.so + 0x2df3f5)
Jun 10 16:03:11 machine1 systemd-coredump[274177]: #3  0x000055d2da095ff3 server_dispatch_message_real (systemd-journald + 0x11ff3)
Jun 10 16:03:11 machine1 systemd-coredump[274177]: #4  0x000055d2da08e6a0 dev_kmsg_record (systemd-journald + 0xa6a0)
Jun 10 16:03:11 machine1 systemd-coredump[274177]: #5  0x000055d2da08ec53 server_read_dev_kmsg (systemd-journald + 0xac53)
Jun 10 16:03:11 machine1 systemd-coredump[274177]: #6  0x00007fc77990b223 source_dispatch (libsystemd-shared-256.so + 0x30b223)
Jun 10 16:03:11 machine1 systemd-coredump[274177]: #7  0x00007fc77990b518 sd_event_dispatch (libsystemd-shared-256.so + 0x30b518)
Jun 10 16:03:11 machine1 systemd-coredump[274177]: #8  0x00007fc77990c040 sd_event_run (libsystemd-shared-256.so + 0x30c040)
Jun 10 16:03:11 machine1 systemd-coredump[274177]: #9  0x000055d2da08d60a main (systemd-journald + 0x960a)
Jun 10 16:03:11 machine1 systemd-coredump[274177]: #10 0x00007fc77943227e __libc_start_call_main (libc.so.6 + 0x2a27e)
Jun 10 16:03:11 machine1 systemd-coredump[274177]: #11 0x00007fc779432339 __libc_start_main@@GLIBC_2.34 (libc.so.6 + 0x2a339)
Jun 10 16:03:11 machine1 systemd-coredump[274177]: #12 0x000055d2da08db45 _start (systemd-journald + 0x9b45)
Jun 10 16:03:11 machine1 systemd-coredump[274177]: Stack trace of thread 274174:
Jun 10 16:03:11 machine1 systemd-coredump[274177]: #0  0x00007fc77950d6ea fsync (libc.so.6 + 0x1056ea)
Jun 10 16:03:11 machine1 systemd-coredump[274177]: #1  0x00007fc779739519 journal_file_set_offline_internal (libsystemd-shared-256.so + 0x139519)
Jun 10 16:03:11 machine1 systemd-coredump[274177]: #2  0x00007fc779739880 journal_file_set_offline_thread (libsystemd-shared-256.so + 0x139880)
Jun 10 16:03:11 machine1 systemd-coredump[274177]: #3  0x00007fc779498af3 start_thread (libc.so.6 + 0x90af3)
Jun 10 16:03:11 machine1 systemd-coredump[274177]: #4  0x00007fc779517d34 __clone (libc.so.6 + 0x10fd34)
Jun 10 16:03:11 machine1 systemd-coredump[274177]: ELF object binary architecture: AMD x86-64
Jun 10 16:03:11 machine1 systemd[1]: systemd-journald.service: Main process exited, code=dumped, status=6/ABRT
Jun 10 16:03:11 machine1 systemd[1]: systemd-journald.service: Failed with result 'watchdog'.
Jun 10 16:03:11 machine1 systemd[1]: systemd-journald.service: Consumed 2min 32.716s CPU time, 1.1G memory peak, 28.3M read from disk, 53.8G written to disk.
Jun 10 16:03:11 machine1 systemd[1]: run-credentials-systemd\x2djournald.service.mount: Deactivated successfully.
Jun 10 16:03:11 machine1 systemd[1]: systemd-journald.service: Scheduled restart job, restart counter is at 1.
Jun 10 16:03:11 machine1 systemd[1]: Starting Journal Service...
Jun 10 16:03:11 machine1 systemd-journald[274205]: Collecting audit messages is enabled.
Jun 10 16:03:11 machine1 systemd-journald[274205]: File /var/log/journal/04256dcb074d45a997c6639bd2b566bb/system.journal corrupted or uncleanly shut down, renaming and replacing.
Jun 10 16:03:11 machine1 systemd[1]: Started Journal Service.
Jun 10 16:03:11 machine1 systemd-journald[274205]: File /var/log/journal/04256dcb074d45a997c6639bd2b566bb/user-31004.journal corrupted or uncleanly shut down, renaming and replacing.
Jun 10 16:04:32 machine1 systemd[1]: fc-agent.service: Deactivated successfully.
Jun 10 16:04:32 machine1 systemd[1]: Finished Flying Circus Management Task.
Jun 10 16:04:32 machine1 systemd[1]: fc-agent.service: Consumed 25.773s CPU time, 1.6G memory peak, 18.5M read from disk, 479.4M written to disk, 125.2K incoming IP traffic, 20.8K o>
Jun 10 16:03:11 machine1 kernel: RBP: 0000000039dfec40 R08: 0000000000000000 R09: 0000000000000000
Jun 10 16:03:11 machine1 kernel: R10: 0000000000000000 R11: 0000000000000000 R12: 00007efe9377d1c0
Jun 10 16:03:11 machine1 kernel: R13: 0000000000020000 R14: 000000000000048b R15: 00007efe9377d000
Jun 10 16:03:11 machine1 kernel:  </TASK>
Jun 10 16:03:11 machine1 kernel: INFO: task slapd:2791 blocked for more than 122 seconds.
Jun 10 16:03:11 machine1 kernel:       Not tainted 6.6.92 #1-NixOS
Jun 10 16:03:11 machine1 kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jun 10 16:03:11 machine1 kernel: task:slapd           state:D stack:0     pid:2791  ppid:1      flags:0x00000002
Jun 10 16:03:11 machine1 kernel: Call Trace:
Jun 10 16:03:11 machine1 kernel:  <TASK>
Jun 10 16:03:11 machine1 kernel:  __schedule+0x3fc/0x1440
Jun 10 16:03:11 machine1 kernel:  schedule+0x5e/0xe0
Jun 10 16:03:11 machine1 kernel:  xlog_grant_head_wait+0xba/0x220 [xfs]
Jun 10 16:03:11 machine1 kernel:  xlog_grant_head_check+0xdf/0x110 [xfs]
Jun 10 16:03:11 machine1 kernel:  xfs_log_reserve+0xc4/0x1f0 [xfs]
Jun 10 16:03:11 machine1 kernel:  xfs_trans_reserve+0x138/0x170 [xfs]
Jun 10 16:03:11 machine1 kernel:  xfs_trans_alloc+0xe5/0x230 [xfs]
Jun 10 16:03:11 machine1 kernel:  xfs_vn_update_time+0x90/0x1b0 [xfs]
Jun 10 16:03:11 machine1 kernel:  file_update_time+0x61/0x90
Jun 10 16:03:11 machine1 kernel:  __xfs_filemap_fault.constprop.0+0xd4/0x1d0 [xfs]
Jun 10 16:03:11 machine1 kernel:  do_page_mkwrite+0x50/0xb0
Jun 10 16:03:11 machine1 kernel:  do_wp_page+0x431/0xb80
Jun 10 16:03:11 machine1 kernel:  ? __pte_offset_map+0x1b/0x190
Jun 10 16:03:11 machine1 kernel:  __handle_mm_fault+0xbcf/0xd90
Jun 10 16:03:11 machine1 kernel:  handle_mm_fault+0x17f/0x370
Jun 10 16:03:11 machine1 kernel:  do_user_addr_fault+0x1ee/0x630
Jun 10 16:03:11 machine1 kernel:  exc_page_fault+0x71/0x160
Jun 10 16:03:11 machine1 kernel:  asm_exc_page_fault+0x26/0x30
Jun 10 16:03:11 machine1 kernel: RIP: 0033:0x4d0c04
Jun 10 16:03:11 machine1 kernel: RSP: 002b:00007efe2ddea250 EFLAGS: 00010246
Jun 10 16:03:11 machine1 kernel: RAX: 000000000000a50b RBX: 00007efe28203aa0 RCX: 0000000000000000
Jun 10 16:03:11 machine1 kernel: RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
Jun 10 16:03:11 machine1 kernel: RBP: 0000000039dfec40 R08: 0000000000000000 R09: 0000000000000000
Jun 10 16:03:11 machine1 kernel: R10: 0000000000000000 R11: 0000000000000000 R12: 00007efe9377d240
Jun 10 16:03:11 machine1 kernel: R13: 0000000000020000 R14: 000000000000048b R15: 00007efe9377d000
Jun 10 16:03:11 machine1 kernel:  </TASK>
Jun 10 16:03:11 machine1 kernel: INFO: task slapd:2792 blocked for more than 122 seconds.
Jun 10 16:03:11 machine1 kernel:       Not tainted 6.6.92 #1-NixOS
Jun 10 16:03:11 machine1 kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jun 10 16:03:11 machine1 kernel: task:slapd           state:D stack:0     pid:2792  ppid:1      flags:0x00000002
Jun 10 16:03:11 machine1 kernel: Call Trace:
Jun 10 16:03:11 machine1 kernel:  <TASK>
Jun 10 16:03:11 machine1 kernel:  __schedule+0x3fc/0x1440
Jun 10 16:03:11 machine1 kernel:  schedule+0x5e/0xe0
Jun 10 16:03:11 machine1 kernel:  xlog_grant_head_wait+0xba/0x220 [xfs]
Jun 10 16:03:11 machine1 kernel:  xlog_grant_head_check+0xdf/0x110 [xfs]
Jun 10 16:03:11 machine1 kernel:  xfs_log_reserve+0xc4/0x1f0 [xfs]
Jun 10 16:03:11 machine1 kernel:  xfs_trans_reserve+0x138/0x170 [xfs]
Jun 10 16:03:11 machine1 kernel:  xfs_trans_alloc+0xe5/0x230 [xfs]
Jun 10 16:03:11 machine1 kernel:  xfs_vn_update_time+0x90/0x1b0 [xfs]
Jun 10 16:03:11 machine1 kernel:  file_update_time+0x61/0x90
Jun 10 16:03:11 machine1 kernel:  __xfs_filemap_fault.constprop.0+0xd4/0x1d0 [xfs]
Jun 10 16:03:11 machine1 kernel:  do_page_mkwrite+0x50/0xb0
Jun 10 16:03:11 machine1 kernel:  do_wp_page+0x431/0xb80
Jun 10 16:03:11 machine1 kernel:  ? __pte_offset_map+0x1b/0x190
Jun 10 16:03:11 machine1 kernel:  __handle_mm_fault+0xbcf/0xd90
Jun 10 16:03:11 machine1 kernel:  handle_mm_fault+0x17f/0x370
Jun 10 16:03:11 machine1 kernel:  do_user_addr_fault+0x1ee/0x630
Jun 10 16:03:11 machine1 kernel:  exc_page_fault+0x71/0x160
Jun 10 16:03:11 machine1 kernel:  asm_exc_page_fault+0x26/0x30
Jun 10 16:03:11 machine1 kernel: RIP: 0033:0x4d0c04
Jun 10 16:03:11 machine1 kernel: RSP: 002b:00007efe2d5fa2a0 EFLAGS: 00010246
Jun 10 16:03:11 machine1 kernel: RAX: 000000000000a50b RBX: 00007efe34135cb0 RCX: 0000000000000000
Jun 10 16:03:11 machine1 kernel: RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
Jun 10 16:03:11 machine1 kernel: RBP: 0000000039dfec40 R08: 0000000000000000 R09: 0000000000000000
Jun 10 16:03:11 machine1 kernel: R10: 0000000000000000 R11: 0000000000000000 R12: 00007efe9377d2c0
Jun 10 16:03:11 machine1 kernel: R13: 0000000000020000 R14: 000000000000048b R15: 00007efe9377d000
Jun 10 16:03:11 machine1 kernel:  </TASK>
Jun 10 16:03:11 machine1 kernel: Future hung task reports are suppressed, see sysctl kernel.hung_task_warnings
Jun 10 16:03:11 machine1 systemd[1]: systemd-journald.service: Watchdog timeout (limit 3min)!
Jun 10 16:03:11 machine1 systemd[1]: systemd-journald.service: Killing process 407 (systemd-journal) with signal SIGABRT.
Jun 10 16:03:11 machine1 systemd[1]: Starting Serial console liveness marker...
Jun 10 16:03:11 machine1 systemd[1]: Starting Logrotate Service...
Jun 10 16:03:11 machine1 systemd[1]: serial-console-liveness.service: Deactivated successfully.
Jun 10 16:03:11 machine1 systemd[1]: Finished Serial console liveness marker.
Jun 10 16:03:11 machine1 systemd-coredump[274177]: Process 407 (systemd-journal) of user 0 terminated abnormally with signal 6/ABRT, processing...
Jun 10 16:03:11 machine1 systemd[1]: logrotate.service: Deactivated successfully.
Jun 10 16:03:11 machine1 systemd[1]: Finished Logrotate Service.
Jun 10 16:03:11 machine1 systemd-coredump[274177]: Process 407 (systemd-journal) of user 0 dumped core.
Jun 10 16:03:11 machine1 systemd-coredump[274177]: Coredump diverted to /var/lib/systemd/coredump/core.systemd-journal.0.42b57193ad0b49a48e0dd3e3abe28b31.407.1749564188000000.zst
Jun 10 16:03:11 machine1 systemd-coredump[274177]: Module libzstd.so.1 without build-id.
Jun 10 16:03:11 machine1 systemd-coredump[274177]: Module libaudit.so.1 without build-id.
Jun 10 16:03:11 machine1 systemd-coredump[274177]: Module libattr.so.1 without build-id.
Jun 10 16:03:11 machine1 systemd-coredump[274177]: Module libseccomp.so.2 without build-id.
Jun 10 16:03:11 machine1 systemd-coredump[274177]: Module libpam.so.0 without build-id.
Jun 10 16:03:11 machine1 systemd-coredump[274177]: Module libcrypt.so.2 without build-id.
Jun 10 16:03:11 machine1 systemd-coredump[274177]: Module libcap.so.2 without build-id.
Jun 10 16:03:11 machine1 systemd-coredump[274177]: Module libacl.so.1 without build-id.
Jun 10 16:03:11 machine1 systemd-coredump[274177]: Stack trace of thread 407:
Jun 10 16:03:11 machine1 systemd-coredump[274177]: #0  0x00007fc77968b4c0 n/a (libsystemd-shared-256.so + 0x8b4c0)
Jun 10 16:03:11 machine1 systemd-coredump[274177]: #1  0x00007fc7798decb4 journal_file_append_data (libsystemd-shared-256.so + 0x2decb4)
Jun 10 16:03:11 machine1 systemd-coredump[274177]: #2  0x00007fc7798df3f5 journal_file_append_entry (libsystemd-shared-256.so + 0x2df3f5)
Jun 10 16:03:11 machine1 systemd-coredump[274177]: #3  0x000055d2da095ff3 server_dispatch_message_real (systemd-journald + 0x11ff3)
Jun 10 16:03:11 machine1 systemd-coredump[274177]: #4  0x000055d2da08e6a0 dev_kmsg_record (systemd-journald + 0xa6a0)
Jun 10 16:03:11 machine1 systemd-coredump[274177]: #5  0x000055d2da08ec53 server_read_dev_kmsg (systemd-journald + 0xac53)
Jun 10 16:03:11 machine1 systemd-coredump[274177]: #6  0x00007fc77990b223 source_dispatch (libsystemd-shared-256.so + 0x30b223)
Jun 10 16:03:11 machine1 systemd-coredump[274177]: #7  0x00007fc77990b518 sd_event_dispatch (libsystemd-shared-256.so + 0x30b518)
Jun 10 16:03:11 machine1 systemd-coredump[274177]: #8  0x00007fc77990c040 sd_event_run (libsystemd-shared-256.so + 0x30c040)
Jun 10 16:03:11 machine1 systemd-coredump[274177]: #9  0x000055d2da08d60a main (systemd-journald + 0x960a)
Jun 10 16:03:11 machine1 systemd-coredump[274177]: #10 0x00007fc77943227e __libc_start_call_main (libc.so.6 + 0x2a27e)
Jun 10 16:03:11 machine1 systemd-coredump[274177]: #11 0x00007fc779432339 __libc_start_main@@GLIBC_2.34 (libc.so.6 + 0x2a339)
Jun 10 16:03:11 machine1 systemd-coredump[274177]: #12 0x000055d2da08db45 _start (systemd-journald + 0x9b45)
Jun 10 16:03:11 machine1 systemd-coredump[274177]: Stack trace of thread 274174:
Jun 10 16:03:11 machine1 systemd-coredump[274177]: #0  0x00007fc77950d6ea fsync (libc.so.6 + 0x1056ea)
Jun 10 16:03:11 machine1 systemd-coredump[274177]: #1  0x00007fc779739519 journal_file_set_offline_internal (libsystemd-shared-256.so + 0x139519)
Jun 10 16:03:11 machine1 systemd-coredump[274177]: #2  0x00007fc779739880 journal_file_set_offline_thread (libsystemd-shared-256.so + 0x139880)
Jun 10 16:03:11 machine1 systemd-coredump[274177]: #3  0x00007fc779498af3 start_thread (libc.so.6 + 0x90af3)
Jun 10 16:03:11 machine1 systemd-coredump[274177]: #4  0x00007fc779517d34 __clone (libc.so.6 + 0x10fd34)
Jun 10 16:03:11 machine1 systemd-coredump[274177]: ELF object binary architecture: AMD x86-64
--Apple-Mail=_8F35269A-219F-4ACA-AF31-F1AF0952BBE5
Content-Disposition: attachment;
	filename=kernel-machine2.log
Content-Type: application/octet-stream;
	x-unix-mode=0644;
	name="kernel-machine2.log"
Content-Transfer-Encoding: 7bit

Jun 11 15:07:13 machine2 kernel: INFO: task kcompactd0:45 blocked for more than 122 seconds.
Jun 11 15:07:13 machine2 kernel:       Not tainted 6.6.92 #1-NixOS
Jun 11 15:07:13 machine2 kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jun 11 15:07:13 machine2 kernel: task:kcompactd0      state:D stack:0     pid:45    ppid:2      flags:0x00004000
Jun 11 15:07:13 machine2 kernel: Call Trace:
Jun 11 15:07:13 machine2 kernel:  <TASK>
Jun 11 15:07:13 machine2 kernel:  __schedule+0x3fc/0x1440
Jun 11 15:07:13 machine2 kernel:  ? srso_return_thunk+0x5/0x5f
Jun 11 15:07:13 machine2 kernel:  schedule+0x5e/0xe0
Jun 11 15:07:13 machine2 kernel:  io_schedule+0x46/0x80
Jun 11 15:07:13 machine2 kernel:  folio_wait_bit_common+0x13d/0x360
Jun 11 15:07:13 machine2 kernel:  ? __pfx_wake_page_function+0x10/0x10
Jun 11 15:07:13 machine2 kernel:  migrate_pages_batch+0x5c9/0xb90
Jun 11 15:07:13 machine2 kernel:  ? __pfx_compaction_free+0x10/0x10
Jun 11 15:07:13 machine2 kernel:  ? __pfx_compaction_alloc+0x10/0x10
Jun 11 15:07:13 machine2 kernel:  ? __pfx_remove_migration_pte+0x10/0x10
Jun 11 15:07:13 machine2 kernel:  migrate_pages+0xbdc/0xd50
Jun 11 15:07:13 machine2 kernel:  ? __pfx_compaction_alloc+0x10/0x10
Jun 11 15:07:13 machine2 kernel:  ? __pfx_compaction_free+0x10/0x10
Jun 11 15:07:13 machine2 kernel:  compact_zone+0x831/0xf30
Jun 11 15:07:13 machine2 kernel:  ? srso_return_thunk+0x5/0x5f
Jun 11 15:07:13 machine2 kernel:  proactive_compact_node+0x85/0xe0
Jun 11 15:07:13 machine2 kernel:  ? srso_return_thunk+0x5/0x5f
Jun 11 15:07:13 machine2 kernel:  kcompactd+0x387/0x460
Jun 11 15:07:13 machine2 kernel:  ? __pfx_autoremove_wake_function+0x10/0x10
Jun 11 15:07:13 machine2 kernel:  ? __pfx_kcompactd+0x10/0x10
Jun 11 15:07:13 machine2 kernel:  kthread+0xe8/0x120
Jun 11 15:07:13 machine2 kernel:  ? __pfx_kthread+0x10/0x10
Jun 11 15:07:13 machine2 kernel:  ret_from_fork+0x34/0x50
Jun 11 15:07:13 machine2 kernel:  ? __pfx_kthread+0x10/0x10
Jun 11 15:07:13 machine2 kernel:  ret_from_fork_asm+0x1b/0x30
Jun 11 15:07:13 machine2 kernel:  </TASK>
Jun 11 15:07:13 machine2 kernel: INFO: task xfsaild/vda1:221 blocked for more than 122 seconds.
Jun 11 15:07:13 machine2 kernel:       Not tainted 6.6.92 #1-NixOS
Jun 11 15:07:13 machine2 kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jun 11 15:07:13 machine2 kernel: task:xfsaild/vda1    state:D stack:0     pid:221   ppid:2      flags:0x00004000
Jun 11 15:07:13 machine2 kernel: Call Trace:
Jun 11 15:07:13 machine2 kernel:  <TASK>
Jun 11 15:07:13 machine2 kernel:  __schedule+0x3fc/0x1440
Jun 11 15:07:13 machine2 kernel:  ? srso_return_thunk+0x5/0x5f
Jun 11 15:07:13 machine2 kernel:  schedule+0x5e/0xe0
Jun 11 15:07:13 machine2 kernel:  schedule_timeout+0x159/0x170
Jun 11 15:07:13 machine2 kernel:  wait_for_completion+0x8a/0x160
Jun 11 15:07:13 machine2 kernel:  __flush_workqueue+0x157/0x440
Jun 11 15:07:13 machine2 kernel:  ? finish_task_switch.isra.0+0x94/0x300
Jun 11 15:07:13 machine2 kernel:  xlog_cil_push_now.isra.0+0x5e/0xa0 [xfs]
Jun 11 15:07:13 machine2 kernel:  xlog_cil_force_seq+0x69/0x250 [xfs]
Jun 11 15:07:13 machine2 kernel:  ? srso_return_thunk+0x5/0x5f
Jun 11 15:07:13 machine2 kernel:  ? __timer_delete_sync+0x7d/0xe0
Jun 11 15:07:13 machine2 kernel:  xfs_log_force+0x7e/0x240 [xfs]
Jun 11 15:07:13 machine2 kernel:  xfsaild+0x17d/0x870 [xfs]
Jun 11 15:07:13 machine2 kernel:  ? __pfx_xfsaild+0x10/0x10 [xfs]
Jun 11 15:07:13 machine2 kernel:  kthread+0xe8/0x120
Jun 11 15:07:13 machine2 kernel:  ? __pfx_kthread+0x10/0x10
Jun 11 15:07:13 machine2 kernel:  ret_from_fork+0x34/0x50
Jun 11 15:07:13 machine2 kernel:  ? __pfx_kthread+0x10/0x10
Jun 11 15:07:13 machine2 kernel:  ret_from_fork_asm+0x1b/0x30
Jun 11 15:07:13 machine2 kernel:  </TASK>
Jun 11 15:07:13 machine2 kernel: INFO: task journal-offline:804376 blocked for more than 122 seconds.
Jun 11 15:07:13 machine2 kernel:       Not tainted 6.6.92 #1-NixOS
Jun 11 15:07:13 machine2 kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jun 11 15:07:13 machine2 kernel: task:journal-offline state:D stack:0     pid:804376 ppid:1      flags:0x00004002
Jun 11 15:07:13 machine2 kernel: Call Trace:
Jun 11 15:07:13 machine2 kernel:  <TASK>
Jun 11 15:07:13 machine2 kernel:  __schedule+0x3fc/0x1440
Jun 11 15:07:13 machine2 kernel:  ? srso_return_thunk+0x5/0x5f
Jun 11 15:07:13 machine2 kernel:  ? psi_task_switch+0xb7/0x200
Jun 11 15:07:13 machine2 kernel:  ? srso_return_thunk+0x5/0x5f
Jun 11 15:07:13 machine2 kernel:  schedule+0x5e/0xe0
Jun 11 15:07:13 machine2 kernel:  schedule_timeout+0x159/0x170
Jun 11 15:07:13 machine2 kernel:  wait_for_completion+0x8a/0x160
Jun 11 15:07:13 machine2 kernel:  __flush_workqueue+0x157/0x440
Jun 11 15:07:13 machine2 kernel:  ? __folio_batch_release+0x1f/0x60
Jun 11 15:07:13 machine2 kernel:  xlog_cil_push_now.isra.0+0x5e/0xa0 [xfs]
Jun 11 15:07:13 machine2 kernel:  xlog_cil_force_seq+0x69/0x250 [xfs]
Jun 11 15:07:13 machine2 kernel:  ? srso_return_thunk+0x5/0x5f
Jun 11 15:07:13 machine2 kernel:  xfs_log_force_seq+0x75/0x180 [xfs]
Jun 11 15:07:13 machine2 kernel:  xfs_file_fsync+0x1a9/0x2b0 [xfs]
Jun 11 15:07:13 machine2 kernel:  __x64_sys_fsync+0x3b/0x70
Jun 11 15:07:13 machine2 kernel:  do_syscall_64+0x39/0x90
Jun 11 15:07:13 machine2 kernel:  entry_SYSCALL_64_after_hwframe+0x78/0xe2
Jun 11 15:07:13 machine2 kernel: RIP: 0033:0x7f208f90d6ea
Jun 11 15:07:13 machine2 kernel: RSP: 002b:00007f208effed70 EFLAGS: 00000246 ORIG_RAX: 000000000000004a
Jun 11 15:07:13 machine2 kernel: RAX: ffffffffffffffda RBX: 00005573438972c0 RCX: 00007f208f90d6ea
Jun 11 15:07:13 machine2 kernel: RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000020
Jun 11 15:07:13 machine2 kernel: RBP: 00007f208fd77700 R08: 0000000000000000 R09: 00007f208efff6c0
Jun 11 15:07:13 machine2 kernel: R10: 00007f208f898886 R11: 0000000000000246 R12: fffffffffffffe90
Jun 11 15:07:13 machine2 kernel: R13: 0000000000000000 R14: 00007fff9b527620 R15: 00007f208fef3000
Jun 11 15:07:13 machine2 kernel:  </TASK>
Jun 11 15:07:13 machine2 kernel: INFO: task journal-offline:804377 blocked for more than 122 seconds.
Jun 11 15:07:13 machine2 kernel:       Not tainted 6.6.92 #1-NixOS
Jun 11 15:07:13 machine2 kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jun 11 15:07:13 machine2 kernel: task:journal-offline state:D stack:0     pid:804377 ppid:1      flags:0x00004002
Jun 11 15:07:13 machine2 kernel: Call Trace:
Jun 11 15:07:13 machine2 kernel:  <TASK>
Jun 11 15:07:13 machine2 kernel:  __schedule+0x3fc/0x1440
Jun 11 15:07:13 machine2 kernel:  ? srso_return_thunk+0x5/0x5f
Jun 11 15:07:13 machine2 kernel:  ? psi_task_switch+0xb7/0x200
Jun 11 15:07:13 machine2 kernel:  ? srso_return_thunk+0x5/0x5f
Jun 11 15:07:13 machine2 kernel:  schedule+0x5e/0xe0
Jun 11 15:07:13 machine2 kernel:  schedule_timeout+0x159/0x170
Jun 11 15:07:13 machine2 kernel:  wait_for_completion+0x8a/0x160
Jun 11 15:07:13 machine2 kernel:  __flush_workqueue+0x157/0x440
Jun 11 15:07:13 machine2 kernel:  ? srso_return_thunk+0x5/0x5f
Jun 11 15:07:13 machine2 kernel:  xlog_cil_push_now.isra.0+0x5e/0xa0 [xfs]
Jun 11 15:07:13 machine2 kernel:  xlog_cil_force_seq+0x69/0x250 [xfs]
Jun 11 15:07:13 machine2 kernel:  ? srso_return_thunk+0x5/0x5f
Jun 11 15:07:13 machine2 kernel:  xfs_log_force_seq+0x75/0x180 [xfs]
Jun 11 15:07:13 machine2 kernel:  xfs_file_fsync+0x1a9/0x2b0 [xfs]
Jun 11 15:07:13 machine2 kernel:  __x64_sys_fsync+0x3b/0x70
Jun 11 15:07:13 machine2 kernel:  do_syscall_64+0x39/0x90
Jun 11 15:07:13 machine2 kernel:  entry_SYSCALL_64_after_hwframe+0x78/0xe2
Jun 11 15:07:13 machine2 kernel: RIP: 0033:0x7f208f90d6ea
Jun 11 15:07:13 machine2 kernel: RSP: 002b:00007f20847fed70 EFLAGS: 00000246 ORIG_RAX: 000000000000004a
Jun 11 15:07:13 machine2 kernel: RAX: ffffffffffffffda RBX: 0000557343889080 RCX: 00007f208f90d6ea
Jun 11 15:07:13 machine2 kernel: RDX: 0000000000000000 RSI: 0000000000000000 RDI: 000000000000002b
Jun 11 15:07:13 machine2 kernel: RBP: 00007f208fd77700 R08: 0000000000000000 R09: 00007f20847ff6c0
Jun 11 15:07:13 machine2 kernel: R10: 00007f208f898886 R11: 0000000000000246 R12: fffffffffffffe90
Jun 11 15:07:13 machine2 kernel: R13: 0000000000000000 R14: 00007fff9b527620 R15: 00007f208fef3000
Jun 11 15:07:13 machine2 kernel:  </TASK>
Jun 11 15:07:13 machine2 kernel: INFO: task kworker/u9:0:795821 blocked for more than 122 seconds.
Jun 11 15:07:13 machine2 kernel:       Not tainted 6.6.92 #1-NixOS
Jun 11 15:07:13 machine2 kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jun 11 15:07:13 machine2 kernel: task:kworker/u9:0    state:D stack:0     pid:795821 ppid:2      flags:0x00004000
Jun 11 15:07:13 machine2 kernel: Workqueue: xfs-cil/vda1 xlog_cil_push_work [xfs]
Jun 11 15:07:13 machine2 kernel: Call Trace:
Jun 11 15:07:13 machine2 kernel:  <TASK>
Jun 11 15:07:13 machine2 kernel:  __schedule+0x3fc/0x1440
Jun 11 15:07:13 machine2 kernel:  ? srso_return_thunk+0x5/0x5f
Jun 11 15:07:13 machine2 kernel:  ? kick_pool+0x5a/0xf0
Jun 11 15:07:13 machine2 kernel:  ? __queue_work.part.0+0x1a5/0x390
Jun 11 15:07:13 machine2 kernel:  schedule+0x5e/0xe0
Jun 11 15:07:13 machine2 kernel:  xlog_state_get_iclog_space+0x107/0x2c0 [xfs]
Jun 11 15:07:13 machine2 kernel:  ? __pfx_default_wake_function+0x10/0x10
Jun 11 15:07:13 machine2 kernel:  xlog_write+0x7a/0x470 [xfs]
Jun 11 15:07:13 machine2 kernel:  ? srso_return_thunk+0x5/0x5f
Jun 11 15:07:13 machine2 kernel:  ? merge+0x42/0xc0
Jun 11 15:07:13 machine2 kernel:  ? srso_return_thunk+0x5/0x5f
Jun 11 15:07:13 machine2 kernel:  ? xlog_cil_order_write+0x9a/0x170 [xfs]
Jun 11 15:07:13 machine2 kernel:  ? __pfx_xlog_cil_order_cmp+0x10/0x10 [xfs]
Jun 11 15:07:13 machine2 kernel:  ? srso_return_thunk+0x5/0x5f
Jun 11 15:07:13 machine2 kernel:  xlog_cil_push_work+0x72c/0x8f0 [xfs]
Jun 11 15:07:13 machine2 kernel:  process_one_work+0x18d/0x3a0
Jun 11 15:07:13 machine2 kernel:  worker_thread+0x28c/0x3b0
Jun 11 15:07:13 machine2 kernel:  ? __pfx_worker_thread+0x10/0x10
Jun 11 15:07:13 machine2 kernel:  kthread+0xe8/0x120
Jun 11 15:07:13 machine2 kernel:  ? __pfx_kthread+0x10/0x10
Jun 11 15:07:13 machine2 kernel:  ret_from_fork+0x34/0x50
Jun 11 15:07:13 machine2 kernel:  ? __pfx_kthread+0x10/0x10
Jun 11 15:07:13 machine2 kernel:  ret_from_fork_asm+0x1b/0x30
Jun 11 15:07:13 machine2 kernel:  </TASK>
Jun 11 15:07:13 machine2 kernel: INFO: task kworker/2:0:800877 blocked for more than 122 seconds.
Jun 11 15:07:13 machine2 kernel:       Not tainted 6.6.92 #1-NixOS
Jun 11 15:07:13 machine2 kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jun 11 15:07:13 machine2 kernel: task:kworker/2:0     state:D stack:0     pid:800877 ppid:2      flags:0x00004000
Jun 11 15:07:13 machine2 kernel: Workqueue: xfs-sync/vda1 xfs_log_worker [xfs]
Jun 11 15:07:13 machine2 kernel: Call Trace:
Jun 11 15:07:13 machine2 kernel:  <TASK>
Jun 11 15:07:13 machine2 kernel:  __schedule+0x3fc/0x1440
Jun 11 15:07:13 machine2 kernel:  ? ttwu_do_activate+0x64/0x230
Jun 11 15:07:13 machine2 kernel:  ? srso_return_thunk+0x5/0x5f
Jun 11 15:07:13 machine2 kernel:  schedule+0x5e/0xe0
Jun 11 15:07:13 machine2 kernel:  schedule_timeout+0x159/0x170
Jun 11 15:07:13 machine2 kernel:  wait_for_completion+0x8a/0x160
Jun 11 15:07:13 machine2 kernel:  __flush_workqueue+0x157/0x440
Jun 11 15:07:13 machine2 kernel:  ? update_load_avg+0x7e/0x7b0
Jun 11 15:07:13 machine2 kernel:  xlog_cil_push_now.isra.0+0x5e/0xa0 [xfs]
Jun 11 15:07:13 machine2 kernel:  xlog_cil_force_seq+0x69/0x250 [xfs]
Jun 11 15:07:13 machine2 kernel:  ? srso_return_thunk+0x5/0x5f
Jun 11 15:07:13 machine2 kernel:  ? kfree_rcu_monitor+0x32c/0x550
Jun 11 15:07:13 machine2 kernel:  xfs_log_force+0x7e/0x240 [xfs]
Jun 11 15:07:13 machine2 kernel:  xfs_log_worker+0x3f/0xd0 [xfs]
Jun 11 15:07:13 machine2 kernel:  process_one_work+0x18d/0x3a0
Jun 11 15:07:13 machine2 kernel:  worker_thread+0x28c/0x3b0
Jun 11 15:07:13 machine2 kernel:  ? __pfx_worker_thread+0x10/0x10
Jun 11 15:07:13 machine2 kernel:  kthread+0xe8/0x120
Jun 11 15:07:13 machine2 kernel:  ? __pfx_kthread+0x10/0x10
Jun 11 15:07:13 machine2 kernel:  ret_from_fork+0x34/0x50
Jun 11 15:07:13 machine2 kernel:  ? __pfx_kthread+0x10/0x10
Jun 11 15:07:13 machine2 kernel:  ret_from_fork_asm+0x1b/0x30
Jun 11 15:07:13 machine2 kernel:  </TASK>
Jun 11 15:07:13 machine2 kernel: INFO: task kworker/u9:1:802505 blocked for more than 122 seconds.
Jun 11 15:07:13 machine2 kernel:       Not tainted 6.6.92 #1-NixOS
Jun 11 15:07:13 machine2 kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jun 11 15:07:13 machine2 kernel: task:kworker/u9:1    state:D stack:0     pid:802505 ppid:2      flags:0x00004000
Jun 11 15:07:13 machine2 kernel: Workqueue: writeback wb_workfn (flush-253:0)
Jun 11 15:07:13 machine2 kernel: Call Trace:
Jun 11 15:07:13 machine2 kernel:  <TASK>
Jun 11 15:07:13 machine2 kernel:  __schedule+0x3fc/0x1440
Jun 11 15:07:13 machine2 kernel:  schedule+0x5e/0xe0
Jun 11 15:07:13 machine2 kernel:  schedule_timeout+0x159/0x170
Jun 11 15:07:13 machine2 kernel:  wait_for_completion+0x8a/0x160
Jun 11 15:07:13 machine2 kernel:  __flush_workqueue+0x157/0x440
Jun 11 15:07:13 machine2 kernel:  ? srso_return_thunk+0x5/0x5f
Jun 11 15:07:13 machine2 kernel:  xlog_cil_push_now.isra.0+0x5e/0xa0 [xfs]
Jun 11 15:07:13 machine2 kernel:  xlog_cil_force_seq+0x69/0x250 [xfs]
Jun 11 15:07:13 machine2 kernel:  ? srso_return_thunk+0x5/0x5f
Jun 11 15:07:13 machine2 kernel:  ? xfs_btree_insert+0x10f/0x290 [xfs]
Jun 11 15:07:13 machine2 kernel:  xfs_log_force+0x7e/0x240 [xfs]
Jun 11 15:07:13 machine2 kernel:  xfs_buf_lock+0xf2/0x100 [xfs]
Jun 11 15:07:13 machine2 kernel:  xfs_buf_find_lock+0x5b/0x120 [xfs]
Jun 11 15:07:13 machine2 kernel:  xfs_buf_get_map+0x1ab/0xa10 [xfs]
Jun 11 15:07:13 machine2 kernel:  xfs_trans_get_buf_map+0x11e/0x1d0 [xfs]
Jun 11 15:07:13 machine2 kernel:  xfs_free_agfl_block+0xcd/0x100 [xfs]
Jun 11 15:07:13 machine2 kernel:  ? srso_return_thunk+0x5/0x5f
Jun 11 15:07:13 machine2 kernel:  xfs_agfl_free_finish_item+0x176/0x190 [xfs]
Jun 11 15:07:13 machine2 kernel:  xfs_defer_finish_noroll+0x196/0x720 [xfs]
Jun 11 15:07:13 machine2 kernel:  __xfs_trans_commit+0x1f0/0x3e0 [xfs]
Jun 11 15:07:13 machine2 kernel:  xfs_bmapi_convert_one_delalloc+0x351/0x490 [xfs]
Jun 11 15:07:13 machine2 kernel:  xfs_bmapi_convert_delalloc+0x43/0x60 [xfs]
Jun 11 15:07:13 machine2 kernel:  xfs_map_blocks+0x25b/0x430 [xfs]
Jun 11 15:07:13 machine2 kernel:  iomap_do_writepage+0x23a/0x880
Jun 11 15:07:13 machine2 kernel:  write_cache_pages+0x142/0x3b0
Jun 11 15:07:13 machine2 kernel:  ? __pfx_iomap_do_writepage+0x10/0x10
Jun 11 15:07:13 machine2 kernel:  ? throtl_add_bio_tg+0x35/0x90
Jun 11 15:07:13 machine2 kernel:  iomap_writepages+0x20/0x50
Jun 11 15:07:13 machine2 kernel:  xfs_vm_writepages+0x67/0xa0 [xfs]
Jun 11 15:07:13 machine2 kernel:  do_writepages+0xcf/0x1f0
Jun 11 15:07:13 machine2 kernel:  __writeback_single_inode+0x3d/0x370
Jun 11 15:07:13 machine2 kernel:  ? srso_return_thunk+0x5/0x5f
Jun 11 15:07:13 machine2 kernel:  ? srso_return_thunk+0x5/0x5f
Jun 11 15:07:13 machine2 kernel:  writeback_sb_inodes+0x1f5/0x4c0
Jun 11 15:07:13 machine2 kernel:  __writeback_inodes_wb+0x4c/0xf0
Jun 11 15:07:13 machine2 kernel:  ? srso_return_thunk+0x5/0x5f
Jun 11 15:07:13 machine2 kernel:  wb_writeback+0x2d6/0x340
Jun 11 15:07:13 machine2 kernel:  ? srso_return_thunk+0x5/0x5f
Jun 11 15:07:13 machine2 kernel:  wb_workfn+0x35b/0x520
Jun 11 15:07:13 machine2 kernel:  ? __schedule+0x404/0x1440
Jun 11 15:07:13 machine2 kernel:  process_one_work+0x18d/0x3a0
Jun 11 15:07:13 machine2 kernel:  worker_thread+0x28c/0x3b0
Jun 11 15:07:13 machine2 kernel:  ? __pfx_worker_thread+0x10/0x10
Jun 11 15:07:13 machine2 kernel:  kthread+0xe8/0x120
Jun 11 15:07:13 machine2 kernel:  ? __pfx_kthread+0x10/0x10
Jun 11 15:07:13 machine2 kernel:  ret_from_fork+0x34/0x50
Jun 11 15:07:13 machine2 kernel:  ? __pfx_kthread+0x10/0x10
Jun 11 15:07:13 machine2 kernel:  ret_from_fork_asm+0x1b/0x30
Jun 11 15:07:13 machine2 kernel:  </TASK>
Jun 11 15:07:13 machine2 kernel: INFO: task kworker/u9:3:803550 blocked for more than 122 seconds.
Jun 11 15:07:13 machine2 kernel:       Not tainted 6.6.92 #1-NixOS
Jun 11 15:07:13 machine2 kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jun 11 15:07:13 machine2 kernel: task:kworker/u9:3    state:D stack:0     pid:803550 ppid:2      flags:0x00004000
Jun 11 15:07:13 machine2 kernel: Workqueue: xfs-cil/vda1 xlog_cil_push_work [xfs]
Jun 11 15:07:13 machine2 kernel: Call Trace:
Jun 11 15:07:13 machine2 kernel:  <TASK>
Jun 11 15:07:13 machine2 kernel:  __schedule+0x3fc/0x1440
Jun 11 15:07:13 machine2 kernel:  schedule+0x5e/0xe0
Jun 11 15:07:13 machine2 kernel:  xlog_cil_order_write+0x134/0x170 [xfs]
Jun 11 15:07:13 machine2 kernel:  ? __pfx_default_wake_function+0x10/0x10
Jun 11 15:07:13 machine2 kernel:  xlog_cil_push_work+0x5ab/0x8f0 [xfs]
Jun 11 15:07:13 machine2 kernel:  process_one_work+0x18d/0x3a0
Jun 11 15:07:13 machine2 kernel:  worker_thread+0x28c/0x3b0
Jun 11 15:07:13 machine2 kernel:  ? __pfx_worker_thread+0x10/0x10
Jun 11 15:07:13 machine2 kernel:  kthread+0xe8/0x120
Jun 11 15:07:13 machine2 kernel:  ? __pfx_kthread+0x10/0x10
Jun 11 15:07:13 machine2 kernel:  ret_from_fork+0x34/0x50
Jun 11 15:07:13 machine2 kernel:  ? __pfx_kthread+0x10/0x10
Jun 11 15:07:13 machine2 kernel:  ret_from_fork_asm+0x1b/0x30
Jun 11 15:07:13 machine2 kernel:  </TASK>
Jun 11 15:07:13 machine2 kernel: INFO: task nix-build:803925 blocked for more than 122 seconds.
Jun 11 15:07:13 machine2 kernel:       Not tainted 6.6.92 #1-NixOS
Jun 11 15:07:13 machine2 kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jun 11 15:07:13 machine2 kernel: task:nix-build       state:D stack:0     pid:803925 ppid:803923 flags:0x00004002
Jun 11 15:07:13 machine2 kernel: Call Trace:
Jun 11 15:07:13 machine2 kernel:  <TASK>
Jun 11 15:07:13 machine2 kernel:  __schedule+0x3fc/0x1440
Jun 11 15:07:13 machine2 kernel:  ? srso_return_thunk+0x5/0x5f
Jun 11 15:07:13 machine2 kernel:  ? submit_bio_noacct+0x256/0x5a0
Jun 11 15:07:13 machine2 kernel:  schedule+0x5e/0xe0
Jun 11 15:07:13 machine2 kernel:  xlog_wait_on_iclog+0x174/0x190 [xfs]
Jun 11 15:07:13 machine2 kernel:  ? __pfx_default_wake_function+0x10/0x10
Jun 11 15:07:13 machine2 kernel:  xfs_log_force_seq+0x91/0x180 [xfs]
Jun 11 15:07:13 machine2 kernel:  xfs_file_fsync+0x1a9/0x2b0 [xfs]
Jun 11 15:07:13 machine2 kernel:  __x64_sys_fdatasync+0x52/0xa0
Jun 11 15:07:13 machine2 kernel:  do_syscall_64+0x39/0x90
Jun 11 15:07:13 machine2 kernel:  entry_SYSCALL_64_after_hwframe+0x78/0xe2
Jun 11 15:07:13 machine2 kernel: RIP: 0033:0x7fceaeb0d20a
Jun 11 15:07:13 machine2 kernel: RSP: 002b:00007fce93ffdb60 EFLAGS: 00000246 ORIG_RAX: 000000000000004b
Jun 11 15:07:13 machine2 kernel: RAX: ffffffffffffffda RBX: 0000559f4c37e6a8 RCX: 00007fceaeb0d20a
Jun 11 15:07:13 machine2 kernel: RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000007
Jun 11 15:07:13 machine2 kernel: RBP: 0000559f4c37e618 R08: 0000000000000000 R09: 00000000000013bb
Jun 11 15:07:13 machine2 kernel: R10: 0000559f4c3a51d0 R11: 0000000000000246 R12: 0000000000000008
Jun 11 15:07:13 machine2 kernel: R13: 0000559f4c33a828 R14: 00007fce93ffdc20 R15: 0000000000000000
Jun 11 15:07:13 machine2 kernel:  </TASK>
Jun 11 15:07:13 machine2 kernel: INFO: task nix:804252 blocked for more than 122 seconds.
Jun 11 15:07:13 machine2 kernel:       Not tainted 6.6.92 #1-NixOS
Jun 11 15:07:13 machine2 kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jun 11 15:07:13 machine2 kernel: task:nix             state:D stack:0     pid:804252 ppid:804251 flags:0x00000002
Jun 11 15:07:13 machine2 kernel: Call Trace:
Jun 11 15:07:13 machine2 kernel:  <TASK>
Jun 11 15:07:13 machine2 kernel:  __schedule+0x3fc/0x1440
Jun 11 15:07:13 machine2 kernel:  ? kmem_cache_alloc+0x19d/0x390
Jun 11 15:07:13 machine2 kernel:  ? xlog_ticket_alloc+0x2d/0xb0 [xfs]
Jun 11 15:07:13 machine2 kernel:  schedule+0x5e/0xe0
Jun 11 15:07:13 machine2 kernel:  schedule_preempt_disabled+0x15/0x30
Jun 11 15:07:13 machine2 kernel:  rwsem_down_write_slowpath+0x1f3/0x640
Jun 11 15:07:13 machine2 kernel:  ? xfs_trans_alloc+0xe5/0x230 [xfs]
Jun 11 15:07:13 machine2 kernel:  down_write+0x6b/0x70
Jun 11 15:07:13 machine2 kernel:  xfs_trans_alloc_ichange+0x9d/0x200 [xfs]
Jun 11 15:07:13 machine2 kernel:  xfs_setattr_nonsize+0x9a/0x390 [xfs]
Jun 11 15:07:13 machine2 kernel:  notify_change+0x1f5/0x4c0
Jun 11 15:07:13 machine2 kernel:  ? chown_common+0x22a/0x240
Jun 11 15:07:13 machine2 kernel:  chown_common+0x22a/0x240
Jun 11 15:07:13 machine2 kernel:  ksys_fchown+0x85/0xd0
Jun 11 15:07:13 machine2 kernel:  __x64_sys_fchown+0x17/0x30
Jun 11 15:07:13 machine2 kernel:  do_syscall_64+0x39/0x90
Jun 11 15:07:13 machine2 kernel:  entry_SYSCALL_64_after_hwframe+0x78/0xe2
Jun 11 15:07:13 machine2 kernel: RIP: 0033:0x7f3debd05ddb
Jun 11 15:07:13 machine2 kernel: RSP: 002b:00007ffd20bf1c58 EFLAGS: 00000246 ORIG_RAX: 000000000000005d
Jun 11 15:07:13 machine2 kernel: RAX: ffffffffffffffda RBX: 0000563449847d9d RCX: 00007f3debd05ddb
Jun 11 15:07:13 machine2 kernel: RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000007
Jun 11 15:07:13 machine2 kernel: RBP: 0000000000080006 R08: 0000000000000001 R09: 0000000000000000
Jun 11 15:07:13 machine2 kernel: R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000007
Jun 11 15:07:13 machine2 kernel: R13: 0000000000020042 R14: 000056344985f8e8 R15: 0000000000000000
Jun 11 15:07:13 machine2 kernel:  </TASK>
Jun 11 15:07:13 machine2 kernel: Future hung task reports are suppressed, see sysctl kernel.hung_task_warnings
Jun 11 15:07:13 machine2 systemd[1]: systemd-journald.service: Watchdog timeout (limit 3min)!
Jun 11 15:07:13 machine2 systemd[1]: systemd-journald.service: Killing process 474 (systemd-journal) with signal SIGABRT.
Jun 11 15:07:13 machine2 systemd-coredump[804693]: Process 474 (systemd-journal) of user 0 terminated abnormally with signal 6/ABRT, processing...
Jun 11 15:07:13 machine2 systemd-coredump[804693]: Process 474 (systemd-journal) of user 0 dumped core.
Jun 11 15:07:13 machine2 systemd-coredump[804693]: Coredump diverted to /var/lib/systemd/coredump/core.systemd-journal.0.be2bc38389c9490cb71c3494a7469dc7.474.1749647228000000.zst
Jun 11 15:07:13 machine2 systemd-coredump[804693]: Module libzstd.so.1 without build-id.
Jun 11 15:07:13 machine2 systemd-coredump[804693]: Module libaudit.so.1 without build-id.
Jun 11 15:07:13 machine2 systemd-coredump[804693]: Module libattr.so.1 without build-id.
Jun 11 15:07:13 machine2 systemd-coredump[804693]: Module libseccomp.so.2 without build-id.
Jun 11 15:07:13 machine2 systemd-coredump[804693]: Module libpam.so.0 without build-id.
Jun 11 15:07:13 machine2 systemd-coredump[804693]: Module libcrypt.so.2 without build-id.
Jun 11 15:07:13 machine2 systemd-coredump[804693]: Module libcap.so.2 without build-id.
Jun 11 15:07:13 machine2 systemd-coredump[804693]: Module libacl.so.1 without build-id.
Jun 11 15:07:13 machine2 systemd-coredump[804693]: Stack trace of thread 474:
Jun 11 15:07:13 machine2 systemd-coredump[804693]: #0  0x00007f208f89513e __futex_abstimed_wait_common (libc.so.6 + 0x8d13e)
Jun 11 15:07:13 machine2 systemd-coredump[804693]: #1  0x00007f208f89a5f3 __pthread_clockjoin_ex (libc.so.6 + 0x925f3)
Jun 11 15:07:13 machine2 systemd-coredump[804693]: #2  0x00007f208fcd65ee journal_file_set_offline_thread_join (libsystemd-shared-256.so + 0x2d65ee)
Jun 11 15:07:13 machine2 systemd-coredump[804693]: #3  0x00007f208fcd66d4 journal_file_set_online (libsystemd-shared-256.so + 0x2d66d4)
Jun 11 15:07:13 machine2 systemd-coredump[804693]: #4  0x00007f208fcd95a7 journal_file_append_object (libsystemd-shared-256.so + 0x2d95a7)
Jun 11 15:07:13 machine2 systemd-coredump[804693]: #5  0x00007f208fcdeb0f journal_file_append_data (libsystemd-shared-256.so + 0x2deb0f)
--Apple-Mail=_8F35269A-219F-4ACA-AF31-F1AF0952BBE5
Content-Disposition: attachment;
	filename=kernel-machine3.log
Content-Type: application/octet-stream;
	x-unix-mode=0644;
	name="kernel-machine3.log"
Content-Transfer-Encoding: 7bit

Jun 12 14:41:26 machine3 kernel: INFO: task ib_io_wr-7:4619 blocked for more than 122 seconds.
Jun 12 14:41:26 machine3 kernel:       Not tainted 6.6.92 #1-NixOS
Jun 12 14:41:26 machine3 kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jun 12 14:41:26 machine3 kernel: task:ib_io_wr-7      state:D stack:0     pid:4619  ppid:1      flags:0x00004002
Jun 12 14:41:26 machine3 kernel: Call Trace:
Jun 12 14:41:26 machine3 kernel:  <TASK>
Jun 12 14:41:26 machine3 kernel:  __schedule+0x3fc/0x1440
Jun 12 14:41:26 machine3 kernel:  schedule+0x5e/0xe0
Jun 12 14:41:26 machine3 kernel:  xlog_wait_on_iclog+0x174/0x190 [xfs]
Jun 12 14:41:26 machine3 kernel:  ? __pfx_default_wake_function+0x10/0x10
Jun 12 14:41:26 machine3 kernel:  xfs_log_force_seq+0x91/0x180 [xfs]
Jun 12 14:41:26 machine3 kernel:  xfs_file_fsync+0x1a9/0x2b0 [xfs]
Jun 12 14:41:26 machine3 kernel:  __x64_sys_fsync+0x3b/0x70
Jun 12 14:41:26 machine3 kernel:  do_syscall_64+0x39/0x90
Jun 12 14:41:26 machine3 kernel:  entry_SYSCALL_64_after_hwframe+0x78/0xe2
Jun 12 14:41:26 machine3 kernel: RIP: 0033:0x7f4dd8f0d6ea
Jun 12 14:41:26 machine3 kernel: RSP: 002b:00007f4bb8ff62a0 EFLAGS: 00000246 ORIG_RAX: 000000000000004a
Jun 12 14:41:26 machine3 kernel: RAX: ffffffffffffffda RBX: 000000000000001d RCX: 00007f4dd8f0d6ea
Jun 12 14:41:26 machine3 kernel: RDX: 0000000000000000 RSI: 0000000000000000 RDI: 000000000000001d
Jun 12 14:41:26 machine3 kernel: RBP: 00007f4bb8ff8530 R08: 0000000000000000 R09: 00000000000020ad
Jun 12 14:41:26 machine3 kernel: R10: 0000000000000000 R11: 0000000000000246 R12: 00007f4dc6641b70
Jun 12 14:41:26 machine3 kernel: R13: 0000000000000000 R14: 00007f4dc6641f80 R15: 00000000046f7c08
Jun 12 14:41:26 machine3 kernel:  </TASK>
Jun 12 14:41:26 machine3 kernel: INFO: task ib_log_flush:4700 blocked for more than 122 seconds.
Jun 12 14:41:26 machine3 kernel:       Not tainted 6.6.92 #1-NixOS
Jun 12 14:41:26 machine3 kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jun 12 14:41:26 machine3 kernel: task:ib_log_flush    state:D stack:0     pid:4700  ppid:1      flags:0x00004002
Jun 12 14:41:26 machine3 kernel: Call Trace:
Jun 12 14:41:26 machine3 kernel:  <TASK>
Jun 12 14:41:26 machine3 kernel:  __schedule+0x3fc/0x1440
Jun 12 14:41:26 machine3 kernel:  ? __folio_batch_release+0x1f/0x60
Jun 12 14:41:26 machine3 kernel:  schedule+0x5e/0xe0
Jun 12 14:41:26 machine3 kernel:  xlog_wait_on_iclog+0x174/0x190 [xfs]
Jun 12 14:41:26 machine3 kernel:  ? __pfx_default_wake_function+0x10/0x10
Jun 12 14:41:26 machine3 kernel:  xfs_log_force_seq+0x91/0x180 [xfs]
Jun 12 14:41:26 machine3 kernel:  xfs_file_fsync+0x1a9/0x2b0 [xfs]
Jun 12 14:41:26 machine3 kernel:  __x64_sys_fsync+0x3b/0x70
Jun 12 14:41:26 machine3 kernel:  do_syscall_64+0x39/0x90
Jun 12 14:41:26 machine3 kernel:  entry_SYSCALL_64_after_hwframe+0x78/0xe2
Jun 12 14:41:26 machine3 kernel: RIP: 0033:0x7f4dd8f0d6ea
Jun 12 14:41:26 machine3 kernel: RSP: 002b:00007f4b94b89690 EFLAGS: 00000246 ORIG_RAX: 000000000000004a
Jun 12 14:41:26 machine3 kernel: RAX: ffffffffffffffda RBX: 00007f4b94b8b930 RCX: 00007f4dd8f0d6ea
Jun 12 14:41:26 machine3 kernel: RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000018
Jun 12 14:41:26 machine3 kernel: RBP: 00007f4b94b8b920 R08: 0000000000000000 R09: 0000000000000000
Jun 12 14:41:26 machine3 kernel: R10: 0000000000000000 R11: 0000000000000246 R12: 00000000046f4498
Jun 12 14:41:26 machine3 kernel: R13: 0000000000000000 R14: 00007f4dc50be340 R15: 00000000046f7c08
Jun 12 14:41:26 machine3 kernel:  </TASK>
Jun 12 14:41:26 machine3 kernel: INFO: task ib_log_writer:4702 blocked for more than 122 seconds.
Jun 12 14:41:26 machine3 kernel:       Not tainted 6.6.92 #1-NixOS
Jun 12 14:41:26 machine3 kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jun 12 14:41:26 machine3 kernel: task:ib_log_writer   state:D stack:0     pid:4702  ppid:1      flags:0x00000002
Jun 12 14:41:26 machine3 kernel: Call Trace:
Jun 12 14:41:26 machine3 kernel:  <TASK>
Jun 12 14:41:26 machine3 kernel:  __schedule+0x3fc/0x1440
Jun 12 14:41:26 machine3 kernel:  ? kmem_cache_alloc+0x19d/0x390
Jun 12 14:41:26 machine3 kernel:  ? xlog_ticket_alloc+0x2d/0xb0 [xfs]
Jun 12 14:41:26 machine3 kernel:  schedule+0x5e/0xe0
Jun 12 14:41:26 machine3 kernel:  schedule_preempt_disabled+0x15/0x30
Jun 12 14:41:26 machine3 kernel:  rwsem_down_write_slowpath+0x1f3/0x640
Jun 12 14:41:26 machine3 kernel:  ? xfs_trans_alloc+0xe5/0x230 [xfs]
Jun 12 14:41:26 machine3 kernel:  down_write+0x6b/0x70
Jun 12 14:41:26 machine3 kernel:  xfs_vn_update_time+0xa1/0x1b0 [xfs]
Jun 12 14:41:26 machine3 kernel:  kiocb_modified+0x9b/0xd0
Jun 12 14:41:26 machine3 kernel:  xfs_file_write_checks+0x1dd/0x280 [xfs]
Jun 12 14:41:26 machine3 kernel:  xfs_file_buffered_write+0x60/0x2b0 [xfs]
Jun 12 14:41:26 machine3 kernel:  ? selinux_file_permission+0x119/0x160
Jun 12 14:41:26 machine3 kernel:  vfs_write+0x24f/0x430
Jun 12 14:41:26 machine3 kernel:  __x64_sys_pwrite64+0xa4/0xd0
Jun 12 14:41:26 machine3 kernel:  do_syscall_64+0x39/0x90
Jun 12 14:41:26 machine3 kernel:  entry_SYSCALL_64_after_hwframe+0x78/0xe2
Jun 12 14:41:26 machine3 kernel: RIP: 0033:0x7f4dd8eee02f
Jun 12 14:41:26 machine3 kernel: RSP: 002b:00007f4b93b87280 EFLAGS: 00000246 ORIG_RAX: 0000000000000012
Jun 12 14:41:26 machine3 kernel: RAX: ffffffffffffffda RBX: 00007f4b9b7f0c00 RCX: 00007f4dd8eee02f
Jun 12 14:41:26 machine3 kernel: RDX: 0000000000000200 RSI: 00007f4b9b7f0c00 RDI: 0000000000000018
Jun 12 14:41:26 machine3 kernel: RBP: 00007f4b93b895a0 R08: 0000000000000000 R09: 00007f4b93b895dc
Jun 12 14:41:26 machine3 kernel: R10: 0000000000f71e00 R11: 0000000000000246 R12: 0000000000f71e00
Jun 12 14:41:26 machine3 kernel: R13: 00007f4b9b7f0c00 R14: 00000000046f7be8 R15: 00007f4dc4307210
Jun 12 14:41:26 machine3 kernel:  </TASK>
Jun 12 14:41:26 machine3 kernel: INFO: task connection:87027 blocked for more than 122 seconds.
Jun 12 14:41:26 machine3 kernel:       Not tainted 6.6.92 #1-NixOS
Jun 12 14:41:26 machine3 kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jun 12 14:41:26 machine3 kernel: task:connection      state:D stack:0     pid:87027 ppid:1      flags:0x00004002
Jun 12 14:41:26 machine3 kernel: Call Trace:
Jun 12 14:41:26 machine3 kernel:  <TASK>
Jun 12 14:41:26 machine3 kernel:  __schedule+0x3fc/0x1440
Jun 12 14:41:26 machine3 kernel:  ? __folio_batch_release+0x1f/0x60
Jun 12 14:41:26 machine3 kernel:  schedule+0x5e/0xe0
Jun 12 14:41:26 machine3 kernel:  xlog_wait_on_iclog+0x174/0x190 [xfs]
Jun 12 14:41:26 machine3 kernel:  ? __pfx_default_wake_function+0x10/0x10
Jun 12 14:41:26 machine3 kernel:  xfs_log_force_seq+0x91/0x180 [xfs]
Jun 12 14:41:26 machine3 kernel:  xfs_file_fsync+0x1a9/0x2b0 [xfs]
Jun 12 14:41:26 machine3 kernel:  __x64_sys_fdatasync+0x52/0xa0
Jun 12 14:41:26 machine3 kernel:  do_syscall_64+0x39/0x90
Jun 12 14:41:26 machine3 kernel:  entry_SYSCALL_64_after_hwframe+0x78/0xe2
Jun 12 14:41:26 machine3 kernel: RIP: 0033:0x7f4dd8f0d20a
Jun 12 14:41:26 machine3 kernel: RSP: 002b:00007f4b8a05b540 EFLAGS: 00000246 ORIG_RAX: 000000000000004b
Jun 12 14:41:26 machine3 kernel: RAX: ffffffffffffffda RBX: 00007f4b8a05b620 RCX: 00007f4dd8f0d20a
Jun 12 14:41:26 machine3 kernel: RDX: 0000000000000000 RSI: 0000000000000000 RDI: 000000000000003d
Jun 12 14:41:26 machine3 kernel: RBP: 00007f4b8a05b610 R08: 0000000000000000 R09: 0000000000000000
Jun 12 14:41:26 machine3 kernel: R10: 0000000000000000 R11: 0000000000000246 R12: 000000000000003d
Jun 12 14:41:26 machine3 kernel: R13: 0000000000000010 R14: 0000000000000000 R15: 00000000046e5f20
Jun 12 14:41:26 machine3 kernel:  </TASK>
Jun 12 14:41:26 machine3 kernel: INFO: task kworker/u5:2:80717 blocked for more than 122 seconds.
Jun 12 14:41:26 machine3 kernel:       Not tainted 6.6.92 #1-NixOS
Jun 12 14:41:26 machine3 kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jun 12 14:41:26 machine3 kernel: task:kworker/u5:2    state:D stack:0     pid:80717 ppid:2      flags:0x00004000
Jun 12 14:41:26 machine3 kernel: Workqueue: xfs-cil/vda1 xlog_cil_push_work [xfs]
Jun 12 14:41:26 machine3 kernel: Call Trace:
Jun 12 14:41:26 machine3 kernel:  <TASK>
Jun 12 14:41:26 machine3 kernel:  __schedule+0x3fc/0x1440
Jun 12 14:41:26 machine3 kernel:  schedule+0x5e/0xe0
Jun 12 14:41:26 machine3 kernel:  xlog_cil_order_write+0x134/0x170 [xfs]
Jun 12 14:41:26 machine3 kernel:  ? __pfx_default_wake_function+0x10/0x10
Jun 12 14:41:26 machine3 kernel:  xlog_cil_push_work+0x5ab/0x8f0 [xfs]
Jun 12 14:41:26 machine3 kernel:  process_one_work+0x18d/0x3a0
Jun 12 14:41:26 machine3 kernel:  worker_thread+0x28c/0x3b0
Jun 12 14:41:26 machine3 kernel:  ? __pfx_worker_thread+0x10/0x10
Jun 12 14:41:26 machine3 kernel:  kthread+0xe8/0x120
Jun 12 14:41:26 machine3 kernel:  ? __pfx_kthread+0x10/0x10
Jun 12 14:41:26 machine3 kernel:  ret_from_fork+0x34/0x50
Jun 12 14:41:26 machine3 kernel:  ? __pfx_kthread+0x10/0x10
Jun 12 14:41:26 machine3 kernel:  ret_from_fork_asm+0x1b/0x30
Jun 12 14:41:26 machine3 kernel:  </TASK>
Jun 12 14:41:26 machine3 kernel: INFO: task kworker/u5:3:81267 blocked for more than 122 seconds.
Jun 12 14:41:26 machine3 kernel:       Not tainted 6.6.92 #1-NixOS
Jun 12 14:41:26 machine3 kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jun 12 14:41:26 machine3 kernel: task:kworker/u5:3    state:D stack:0     pid:81267 ppid:2      flags:0x00004000
Jun 12 14:41:26 machine3 kernel: Workqueue: xfs-cil/vda1 xlog_cil_push_work [xfs]
Jun 12 14:41:26 machine3 kernel: Call Trace:
Jun 12 14:41:26 machine3 kernel:  <TASK>
Jun 12 14:41:26 machine3 kernel:  __schedule+0x3fc/0x1440
Jun 12 14:41:26 machine3 kernel:  ? __schedule+0x404/0x1440
Jun 12 14:41:26 machine3 kernel:  ? select_task_rq_fair+0x6e5/0x1b30
Jun 12 14:41:26 machine3 kernel:  schedule+0x5e/0xe0
Jun 12 14:41:26 machine3 kernel:  xlog_cil_order_write+0x134/0x170 [xfs]
Jun 12 14:41:26 machine3 kernel:  ? __pfx_default_wake_function+0x10/0x10
Jun 12 14:41:26 machine3 kernel:  xlog_cil_push_work+0x5ab/0x8f0 [xfs]
Jun 12 14:41:26 machine3 kernel:  process_one_work+0x18d/0x3a0
Jun 12 14:41:26 machine3 kernel:  worker_thread+0x28c/0x3b0
Jun 12 14:41:26 machine3 kernel:  ? __pfx_worker_thread+0x10/0x10
Jun 12 14:41:26 machine3 kernel:  kthread+0xe8/0x120
Jun 12 14:41:26 machine3 kernel:  ? __pfx_kthread+0x10/0x10
Jun 12 14:41:26 machine3 kernel:  ret_from_fork+0x34/0x50
Jun 12 14:41:26 machine3 kernel:  ? __pfx_kthread+0x10/0x10
Jun 12 14:41:26 machine3 kernel:  ret_from_fork_asm+0x1b/0x30
Jun 12 14:41:26 machine3 kernel:  </TASK>
Jun 12 14:41:26 machine3 kernel: INFO: task kworker/u6:3:83203 blocked for more than 122 seconds.
Jun 12 14:41:26 machine3 kernel:       Not tainted 6.6.92 #1-NixOS
Jun 12 14:41:26 machine3 kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jun 12 14:41:26 machine3 kernel: task:kworker/u6:3    state:D stack:0     pid:83203 ppid:2      flags:0x00004000
Jun 12 14:41:26 machine3 kernel: Workqueue: xfs-cil/vda1 xlog_cil_push_work [xfs]
Jun 12 14:41:26 machine3 kernel: Call Trace:
Jun 12 14:41:26 machine3 kernel:  <TASK>
Jun 12 14:41:26 machine3 kernel:  __schedule+0x3fc/0x1440
Jun 12 14:41:26 machine3 kernel:  ? blk_mq_submit_bio+0x27b/0x660
Jun 12 14:41:26 machine3 kernel:  schedule+0x5e/0xe0
Jun 12 14:41:26 machine3 kernel:  xlog_state_get_iclog_space+0x107/0x2c0 [xfs]
Jun 12 14:41:26 machine3 kernel:  ? __pfx_default_wake_function+0x10/0x10
Jun 12 14:41:26 machine3 kernel:  xlog_write_get_more_iclog_space+0xde/0x110 [xfs]
Jun 12 14:41:26 machine3 kernel:  xlog_write+0x34c/0x470 [xfs]
Jun 12 14:41:26 machine3 kernel:  xlog_cil_push_work+0x72c/0x8f0 [xfs]
Jun 12 14:41:26 machine3 kernel:  process_one_work+0x18d/0x3a0
Jun 12 14:41:26 machine3 kernel:  worker_thread+0x28c/0x3b0
Jun 12 14:41:26 machine3 kernel:  ? __pfx_worker_thread+0x10/0x10
Jun 12 14:41:26 machine3 kernel:  kthread+0xe8/0x120
Jun 12 14:41:26 machine3 kernel:  ? __pfx_kthread+0x10/0x10
Jun 12 14:41:26 machine3 kernel:  ret_from_fork+0x34/0x50
Jun 12 14:41:26 machine3 kernel:  ? __pfx_kthread+0x10/0x10
Jun 12 14:41:26 machine3 kernel:  ret_from_fork_asm+0x1b/0x30
Jun 12 14:41:26 machine3 kernel:  </TASK>
Jun 12 14:41:26 machine3 kernel: INFO: task kworker/u5:0:85256 blocked for more than 122 seconds.
Jun 12 14:41:26 machine3 kernel:       Not tainted 6.6.92 #1-NixOS
Jun 12 14:41:26 machine3 kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jun 12 14:41:26 machine3 kernel: task:kworker/u5:0    state:D stack:0     pid:85256 ppid:2      flags:0x00004000
Jun 12 14:41:26 machine3 kernel: Workqueue: xfs-cil/vda1 xlog_cil_push_work [xfs]
Jun 12 14:41:26 machine3 kernel: Call Trace:
Jun 12 14:41:26 machine3 kernel:  <TASK>
Jun 12 14:41:26 machine3 kernel:  __schedule+0x3fc/0x1440
Jun 12 14:41:26 machine3 kernel:  schedule+0x5e/0xe0
Jun 12 14:41:26 machine3 kernel:  xlog_cil_order_write+0x134/0x170 [xfs]
Jun 12 14:41:26 machine3 kernel:  ? __pfx_default_wake_function+0x10/0x10
Jun 12 14:41:26 machine3 kernel:  xlog_cil_push_work+0x5ab/0x8f0 [xfs]
Jun 12 14:41:26 machine3 kernel:  process_one_work+0x18d/0x3a0
Jun 12 14:41:26 machine3 kernel:  worker_thread+0x28c/0x3b0
Jun 12 14:41:26 machine3 kernel:  ? __pfx_worker_thread+0x10/0x10
Jun 12 14:41:26 machine3 kernel:  kthread+0xe8/0x120
Jun 12 14:41:26 machine3 kernel:  ? __pfx_kthread+0x10/0x10
Jun 12 14:41:26 machine3 kernel:  ret_from_fork+0x34/0x50
Jun 12 14:41:26 machine3 kernel:  ? __pfx_kthread+0x10/0x10
Jun 12 14:41:26 machine3 kernel:  ret_from_fork_asm+0x1b/0x30
Jun 12 14:41:26 machine3 kernel:  </TASK>
Jun 12 14:41:26 machine3 kernel: INFO: task kworker/u5:1:86241 blocked for more than 122 seconds.
Jun 12 14:41:26 machine3 kernel:       Not tainted 6.6.92 #1-NixOS
Jun 12 14:41:26 machine3 kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jun 12 14:41:26 machine3 kernel: task:kworker/u5:1    state:D stack:0     pid:86241 ppid:2      flags:0x00004000
Jun 12 14:41:26 machine3 kernel: Workqueue: xfs-cil/vda1 xlog_cil_push_work [xfs]
Jun 12 14:41:26 machine3 kernel: Call Trace:
Jun 12 14:41:26 machine3 kernel:  <TASK>
Jun 12 14:41:26 machine3 kernel:  __schedule+0x3fc/0x1440
Jun 12 14:41:26 machine3 kernel:  schedule+0x5e/0xe0
Jun 12 14:41:26 machine3 kernel:  xlog_cil_order_write+0x134/0x170 [xfs]
Jun 12 14:41:26 machine3 kernel:  ? __pfx_default_wake_function+0x10/0x10
Jun 12 14:41:26 machine3 kernel:  xlog_cil_push_work+0x5ab/0x8f0 [xfs]
Jun 12 14:41:26 machine3 kernel:  process_one_work+0x18d/0x3a0
Jun 12 14:41:26 machine3 kernel:  worker_thread+0x28c/0x3b0
Jun 12 14:41:26 machine3 kernel:  ? __pfx_worker_thread+0x10/0x10
Jun 12 14:41:26 machine3 kernel:  kthread+0xe8/0x120
Jun 12 14:41:26 machine3 kernel:  ? __pfx_kthread+0x10/0x10
Jun 12 14:41:26 machine3 kernel:  ret_from_fork+0x34/0x50
Jun 12 14:41:26 machine3 kernel:  ? __pfx_kthread+0x10/0x10
Jun 12 14:41:26 machine3 kernel:  ret_from_fork_asm+0x1b/0x30
Jun 12 14:41:26 machine3 kernel:  </TASK>
Jun 12 14:41:26 machine3 kernel: INFO: task kworker/u6:4:86403 blocked for more than 122 seconds.
Jun 12 14:41:26 machine3 kernel:       Not tainted 6.6.92 #1-NixOS
Jun 12 14:41:26 machine3 kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jun 12 14:41:26 machine3 kernel: task:kworker/u6:4    state:D stack:0     pid:86403 ppid:2      flags:0x00004000
Jun 12 14:41:26 machine3 kernel: Workqueue: xfs-cil/vda1 xlog_cil_push_work [xfs]
Jun 12 14:41:26 machine3 kernel: Call Trace:
Jun 12 14:41:26 machine3 kernel:  <TASK>
Jun 12 14:41:26 machine3 kernel:  __schedule+0x3fc/0x1440
Jun 12 14:41:26 machine3 kernel:  schedule+0x5e/0xe0
Jun 12 14:41:26 machine3 kernel:  xlog_state_get_iclog_space+0x107/0x2c0 [xfs]
Jun 12 14:41:26 machine3 kernel:  ? load_balance+0x175/0xfd0
Jun 12 14:41:26 machine3 kernel:  ? __pfx_default_wake_function+0x10/0x10
Jun 12 14:41:26 machine3 kernel:  xlog_write+0x7a/0x470 [xfs]
Jun 12 14:41:26 machine3 kernel:  ? __pfx_xlog_cil_order_cmp+0x10/0x10 [xfs]
Jun 12 14:41:26 machine3 kernel:  ? merge+0x66/0xc0
Jun 12 14:41:26 machine3 kernel:  ? xlog_cil_order_write+0x9a/0x170 [xfs]
Jun 12 14:41:26 machine3 kernel:  ? __pfx_xlog_cil_order_cmp+0x10/0x10 [xfs]
Jun 12 14:41:26 machine3 kernel:  xlog_cil_push_work+0x72c/0x8f0 [xfs]
Jun 12 14:41:26 machine3 kernel:  process_one_work+0x18d/0x3a0
Jun 12 14:41:26 machine3 kernel:  worker_thread+0x28c/0x3b0
Jun 12 14:41:26 machine3 kernel:  ? __pfx_worker_thread+0x10/0x10
Jun 12 14:41:26 machine3 kernel:  kthread+0xe8/0x120
Jun 12 14:41:26 machine3 kernel:  ? __pfx_kthread+0x10/0x10
Jun 12 14:41:26 machine3 kernel:  ret_from_fork+0x34/0x50
Jun 12 14:41:26 machine3 kernel:  ? __pfx_kthread+0x10/0x10
Jun 12 14:41:26 machine3 kernel:  ret_from_fork_asm+0x1b/0x30
Jun 12 14:41:26 machine3 kernel:  </TASK>
--Apple-Mail=_8F35269A-219F-4ACA-AF31-F1AF0952BBE5
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8



Regards,
Christian

--=20
Christian Theune =C2=B7 ct@flyingcircus.io =C2=B7 +49 345 219401 0
Flying Circus Internet Operations GmbH =C2=B7 https://flyingcircus.io
Leipziger Str. 70/71 =C2=B7 06108 Halle (Saale) =C2=B7 Deutschland
HR Stendal HRB 21169 =C2=B7 Gesch=C3=A4ftsf=C3=BChrer: Christian Theune, =
Christian Zagrodnick


--Apple-Mail=_8F35269A-219F-4ACA-AF31-F1AF0952BBE5--
