Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BD9865EB1
	for <linux-xfs@vger.kernel.org>; Tue,  5 Dec 2023 14:29:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="s2rt8yTH"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 18844C433D9
	for <linux-xfs@vger.kernel.org>; Tue,  5 Dec 2023 14:29:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701786543;
	bh=YShnrjxW2RERFg1rtBcVbBIN2dXNbknVonSG3LXYMvs=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=s2rt8yTHxHIDlzLuGN/Yx97rtdReBPMlX3yBoPvQZJ9NTvachvsTuVLiO3NoWVoex
	 H3yfG6xDNILDWYnFJqEzHXvs6Ys6gPJSqw200ltDaUCzdrGA0J5Pp09JJ2n2KxT4lf
	 2Ct0AXiU9tZBQ3OUdCjjlNCJFtOwPC+5qySF2sVzdB27gPq+sUcnPM4dSkOj45t+iv
	 rcVj9xXWbbNzj8JsnmASgv0a6G6oyuIxMzF4WxQtLL8386J8A+O52CET+J0gPnafFo
	 SCxviF7wRqW2Jnb2pcZg520YAr6PWPqaXRaM71hC+1GjNq07SYgohcUG0rvjGsrIQq
	 /LqS/6ZgsSNzA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 09334C53BC6; Tue,  5 Dec 2023 14:29:03 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-xfs@vger.kernel.org
Subject: [Bug 218230] xfstests xfs/538 hung
Date: Tue, 05 Dec 2023 14:29:02 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: chandanbabu@kernel.org
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-218230-201763-FKGdPQu2af@https.bugzilla.kernel.org/>
In-Reply-To: <bug-218230-201763@https.bugzilla.kernel.org/>
References: <bug-218230-201763@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D218230

--- Comment #1 from chandanbabu@kernel.org ---
On Tue, Dec 05, 2023 at 12:31:34 PM +0000, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=3D218230
>
>             Bug ID: 218230
>            Summary: xfstests xfs/538 hung
>            Product: File System
>            Version: 2.5
>           Hardware: All
>                 OS: Linux
>             Status: NEW
>           Severity: normal
>           Priority: P3
>          Component: XFS
>           Assignee: filesystem_xfs@kernel-bugs.kernel.org
>           Reporter: dagmcr@gmail.com
>         Regression: No
>
> While doing fstests baseline testing on v6.6-rc5 with kdevops [0] we foun=
d a
> failure for xfs/538 test.=20
>
> [0] https://github.com/linux-kdevops
>
> This fails on the following test sections as defined by kdevops [1]:
>
>   * xfs_crc_logdev_rtdev: failure rate ~1/17
>   * xfs_crc_rtdev_extsize_64k: failure rate ~1/3
>
> [0] https://github.com/linux-kdevops
> [1]
>
> https://github.com/linux-kdevops/kdevops/blob/master/playbooks/roles/fste=
sts/templates/xfs/xfs.config
>
> Below is just one full trace.
>
> Nov 02 20:23:13 line-xfs-crc-logdev-rtdev unknown: run fstests xfs/538 at
> 2023-11-02 20:23:13
> Nov 02 20:23:14 line-xfs-crc-logdev-rtdev kernel: XFS (loop5): Mounting V5
> Filesystem 8e731ab8-42fb-48c5-8877-b4fb526e9609
> Nov 02 20:23:14 line-xfs-crc-logdev-rtdev kernel: XFS (loop5): Ending cle=
an
> mount
> Nov 02 20:23:23 line-xfs-crc-logdev-rtdev kernel: XFS (loop5): Injecting
> error
> (false) at file fs/xfs/libxfs/xfs_bmap.c, line 4123, on filesystem "loop5"
> Nov 02 20:23:23 line-xfs-crc-logdev-rtdev kernel: XFS (loop5): Injecting
> error
> (false) at file fs/xfs/libxfs/xfs_bmap.c, line 4082, on filesystem "loop5"
> Nov 02 20:23:23 line-xfs-crc-logdev-rtdev kernel: XFS (loop5): Injecting
> error
> (false) at file fs/xfs/libxfs/xfs_bmap.c, line 4082, on filesystem "loop5"
> Nov 02 20:23:23 line-xfs-crc-logdev-rtdev kernel: XFS (loop5): Injecting
> error
> (false) at file fs/xfs/libxfs/xfs_bmap.c, line 4082, on filesystem "loop5"
> Nov 02 20:23:23 line-xfs-crc-logdev-rtdev kernel: XFS (loop5): Injecting
> error
> (false) at file fs/xfs/libxfs/xfs_bmap.c, line 4082, on filesystem "loop5"
> Nov 02 20:23:23 line-xfs-crc-logdev-rtdev kernel: XFS (loop5): Injecting
> error
> (false) at file fs/xfs/libxfs/xfs_bmap.c, line 4082, on filesystem "loop5"
> Nov 02 20:23:23 line-xfs-crc-logdev-rtdev kernel: XFS (loop5): Injecting
> error
> (false) at file fs/xfs/libxfs/xfs_bmap.c, line 4082, on filesystem "loop5"
> Nov 02 20:23:23 line-xfs-crc-logdev-rtdev kernel: XFS (loop5): Injecting
> error
> (false) at file fs/xfs/libxfs/xfs_bmap.c, line 4082, on filesystem "loop5"
> Nov 02 20:23:23 line-xfs-crc-logdev-rtdev kernel: XFS (loop5): Injecting
> error
> (false) at file fs/xfs/libxfs/xfs_bmap.c, line 4082, on filesystem "loop5"
> Nov 02 20:23:23 line-xfs-crc-logdev-rtdev kernel: XFS (loop5): Injecting
> error
> (false) at file fs/xfs/libxfs/xfs_bmap.c, line 4082, on filesystem "loop5"
> Nov 02 20:23:28 line-xfs-crc-logdev-rtdev kernel: xfs_errortag_test: 43825
> callbacks suppressed
> Nov 02 20:23:28 line-xfs-crc-logdev-rtdev kernel: XFS (loop5): Injecting
> error
> (false) at file fs/xfs/libxfs/xfs_bmap.c, line 4082, on filesystem "loop5"
> Nov 02 20:23:28 line-xfs-crc-logdev-rtdev kernel: XFS (loop5): Injecting
> error
> (false) at file fs/xfs/libxfs/xfs_bmap.c, line 4082, on filesystem "loop5"
> Nov 02 20:23:28 line-xfs-crc-logdev-rtdev kernel: XFS (loop5): Injecting
> error
> (false) at file fs/xfs/libxfs/xfs_bmap.c, line 4082, on filesystem "loop5"
> Nov 02 20:23:28 line-xfs-crc-logdev-rtdev kernel: XFS (loop5): Injecting
> error
> (false) at file fs/xfs/libxfs/xfs_bmap.c, line 4082, on filesystem "loop5"
> Nov 02 20:23:28 line-xfs-crc-logdev-rtdev kernel: XFS (loop5): Injecting
> error
> (false) at file fs/xfs/libxfs/xfs_bmap.c, line 4082, on filesystem "loop5"
> Nov 02 20:23:28 line-xfs-crc-logdev-rtdev kernel: XFS (loop5): Injecting
> error
> (false) at file fs/xfs/libxfs/xfs_bmap.c, line 4082, on filesystem "loop5"
> Nov 02 20:23:28 line-xfs-crc-logdev-rtdev kernel: XFS (loop5): Injecting
> error
> (false) at file fs/xfs/libxfs/xfs_bmap.c, line 4082, on filesystem "loop5"
> Nov 02 20:23:28 line-xfs-crc-logdev-rtdev kernel: XFS (loop5): Injecting
> error
> (false) at file fs/xfs/libxfs/xfs_bmap.c, line 4082, on filesystem "loop5"
> Nov 02 20:23:28 line-xfs-crc-logdev-rtdev kernel: XFS (loop5): Injecting
> error
> (false) at file fs/xfs/libxfs/xfs_bmap.c, line 4082, on filesystem "loop5"
> Nov 02 20:23:28 line-xfs-crc-logdev-rtdev kernel: XFS (loop5): Injecting
> error
> (false) at file fs/xfs/libxfs/xfs_bmap.c, line 4082, on filesystem "loop5"
> Nov 02 20:23:33 line-xfs-crc-logdev-rtdev kernel: xfs_errortag_test: 37630
> callbacks suppressed
> Nov 02 20:23:38 line-xfs-crc-logdev-rtdev kernel: XFS (loop5): Injecting
> error
> (false) at file fs/xfs/libxfs/xfs_bmap.c, line 4082, on filesystem "loop5"
> Nov 02 20:23:38 line-xfs-crc-logdev-rtdev kernel: XFS (loop5): Injecting
> error
> (false) at file fs/xfs/libxfs/xfs_bmap.c, line 4082, on filesystem "loop5"
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel: INFO: task kcompactd0:71
> blocked for more than 120 seconds.
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel:       Not tainted 6.6.0=
-rc5
> #2
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel: "echo 0 >
> /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel: task:kcompactd0=20=20=
=20=20=20
> state:D
> stack:0     pid:71    ppid:2      flags:0x00004000
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel: Call Trace:
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel:  <TASK>
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel:  __schedule+0x3ab/0xab0
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel:  schedule+0x5d/0xe0
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel:  io_schedule+0x42/0x70
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel:=20
> folio_wait_bit_common+0x12e/0x380
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel:  ?
> __pfx_wake_page_function+0x10/0x10
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel:=20
> migrate_pages_batch+0x632/0xdb0
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel:  ?
> __pfx_compaction_free+0x10/0x10
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel:  ?
> __pfx_compaction_alloc+0x10/0x10
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel:  ?
> __pfx_remove_migration_pte+0x10/0x10
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel:  migrate_pages+0xc22/0x=
da0
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel:  ?
> __pfx_compaction_alloc+0x10/0x10
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel:  ?
> __pfx_compaction_free+0x10/0x10
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel:  compact_zone+0x927/0xf=
e0
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel:  ?
> _raw_spin_unlock+0x15/0x30
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel:  ?
> finish_task_switch.isra.0+0x91/0x2a0
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel:  ? __switch_to+0x106/0x=
3a0
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel:=20
> proactive_compact_node+0x87/0xe0
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel:  ? finish_wait+0x41/0x90
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel:  kcompactd+0x30d/0x3f0
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel:  ?
> __pfx_autoremove_wake_function+0x10/0x10
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel:  ?
> __pfx_kcompactd+0x10/0x10
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel:  kthread+0xf3/0x120
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel:  ? __pfx_kthread+0x10/0=
x10
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel:  ret_from_fork+0x30/0x50
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel:  ? __pfx_kthread+0x10/0=
x10
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel:=20
> ret_from_fork_asm+0x1b/0x30
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel:  </TASK>
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel: INFO: task
> kworker/5:0:2369803 blocked for more than 120 seconds.
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel:       Not tainted 6.6.0=
-rc5
> #2
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel: "echo 0 >
> /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel: task:kworker/5:0=20=20=
=20=20
> state:D
> stack:0     pid:2369803 ppid:2      flags:0x00004000
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel: Workqueue:
> xfs-inodegc/loop5
> xfs_inodegc_worker [xfs]
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel: Call Trace:
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel:  <TASK>
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel:  __schedule+0x3ab/0xab0
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel:  ?
> finish_task_switch.isra.0+0x91/0x2a0
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel:  schedule+0x5d/0xe0
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel:=20
> schedule_timeout+0x143/0x150
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel:  ?
> preempt_count_add+0x6a/0xa0
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel:  __down_common+0xf6/0x2=
00
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel:  down+0x43/0x60
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel:  xfs_buf_lock+0x2d/0xe0
> [xfs]
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel:=20
> xfs_buf_find_lock+0x60/0x140
> [xfs]
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel:=20
> xfs_buf_get_map+0x1bd/0xaf0
> [xfs]
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel:  ?
> __module_address+0x2f/0xb0
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel:  ?
> __module_address+0x2f/0xb0
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel:  ?
> preempt_count_add+0x47/0xa0
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel:=20
> xfs_buf_read_map+0x54/0x250
> [xfs]
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel:  ? xfs_read_agf+0x90/0x=
130
> [xfs]
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel:=20
> xfs_trans_read_buf_map+0x1c2/0x4d0 [xfs]
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel:  ? xfs_read_agf+0x90/0x=
130
> [xfs]
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel:  xfs_read_agf+0x90/0x130
> [xfs]
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel:=20
> xfs_alloc_read_agf+0x5e/0x390 [xfs]
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel:  ?
> __xfs_trans_commit+0xc8/0x390 [xfs]
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel:=20
> xfs_alloc_fix_freelist+0x3cb/0x750 [xfs]
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel:  ?
> unwind_next_frame+0x120/0x890
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel:  ?
> arch_stack_walk+0x88/0xf0
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel:  ?
> ret_from_fork_asm+0x1b/0x30
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel:  ?
> __stack_depot_save+0x35/0x480
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel:=20
> xfs_free_extent_fix_freelist+0x61/0xa0 [xfs]
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel:=20
> __xfs_free_extent+0x8c/0x1f0
> [xfs]
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel:=20
> xfs_trans_free_extent+0x97/0x270 [xfs]
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel:=20
> xfs_extent_free_finish_item+0xf/0x40 [xfs]
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel:=20
> xfs_defer_finish_noroll+0x19f/0x760 [xfs]
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel:  xfs_defer_finish+0x11/=
0xa0
> [xfs]
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel:=20
> xfs_itruncate_extents_flags+0x14f/0x4c0 [xfs]
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel:=20
> xfs_inactive_truncate+0xbf/0x140 [xfs]
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel:  xfs_inactive+0x22d/0x2=
90
> [xfs]
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel:=20
> xfs_inodegc_worker+0xb4/0x1a0 [xfs]
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel:=20
> process_one_work+0x174/0x340
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel:  worker_thread+0x277/0x=
390
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel:  ?
> __pfx_worker_thread+0x10/0x10
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel:  kthread+0xf3/0x120
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel:  ? __pfx_kthread+0x10/0=
x10
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel:  ret_from_fork+0x30/0x50
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel:  ? __pfx_kthread+0x10/0=
x10
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel:=20
> ret_from_fork_asm+0x1b/0x30
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel:  </TASK>
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel: INFO: task
> kworker/u17:7:3188941 blocked for more than 120 seconds.
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel:       Not tainted 6.6.0=
-rc5
> #2
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel: "echo 0 >
> /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel: task:kworker/u17:7=20=20
> state:D
> stack:0     pid:3188941 ppid:2      flags:0x00004000
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel: Workqueue: writeback
> wb_workfn (flush-7:5)
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel: Call Trace:
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel:  <TASK>
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel:  __schedule+0x3ab/0xab0
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel:  schedule+0x5d/0xe0
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel:=20
> schedule_timeout+0x143/0x150
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel:  ?
> _raw_spin_unlock_irqrestore+0x23/0x40
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel:  ?
> preempt_count_add+0x6a/0xa0
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel:  ?
> _raw_spin_lock_irqsave+0x23/0x50
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel:  __down_common+0xf6/0x2=
00
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel:  down+0x43/0x60
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel:  xfs_buf_lock+0x2d/0xe0
> [xfs]
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel:=20
> xfs_buf_find_lock+0x60/0x140
> [xfs]
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel:=20
> xfs_buf_get_map+0x1bd/0xaf0
> [xfs]
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel:  ?
> _xfs_trans_bjoin+0x76/0x120 [xfs]
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel:=20
> xfs_buf_read_map+0x54/0x250
> [xfs]
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel:  ? xfs_read_agf+0x90/0x=
130
> [xfs]
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel:=20
> xfs_trans_read_buf_map+0x1c2/0x4d0 [xfs]
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel:  ? xfs_read_agf+0x90/0x=
130
> [xfs]
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel:  xfs_read_agf+0x90/0x130
> [xfs]
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel:=20
> xfs_alloc_read_agf+0x5e/0x390 [xfs]
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel:=20
> xfs_alloc_fix_freelist+0x3cb/0x750 [xfs]
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel:  ? wb_workfn+0x30f/0x4b0
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel:  ?
> set_track_prepare+0x4a/0x70
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel:  ?
> xlog_ticket_alloc+0x29/0xa0 [xfs]
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel:  ?
> xfs_log_reserve+0x9c/0x220
> [xfs]
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel:  ?
> xfs_trans_reserve+0x199/0x270 [xfs]
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel:  ?
> __pv_queued_spin_lock_slowpath+0x16c/0x380
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel:=20
> xfs_alloc_vextent_prepare_ag+0x2d/0x120 [xfs]
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel:=20
> xfs_alloc_vextent_iterate_ags.constprop.0+0x99/0x230 [xfs]
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel:=20
> xfs_alloc_vextent_first_ag+0xf1/0x130 [xfs]
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel:=20
> xfs_bmap_exact_minlen_extent_alloc+0x138/0x1b0 [xfs]
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel:=20
> xfs_bmapi_allocate+0x282/0x450 [xfs]
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel:=20
> xfs_bmapi_convert_delalloc+0x2ee/0x4e0 [xfs]
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel:  xfs_map_blocks+0x1f2/0=
x590
> [xfs]
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel:=20
> iomap_do_writepage+0x28b/0x8d0
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel:=20
> write_cache_pages+0x159/0x3c0
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel:  ?
> __pfx_iomap_do_writepage+0x10/0x10
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel:  iomap_writepages+0x1c/=
0x40
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel:=20
> xfs_vm_writepages+0x79/0xb0
> [xfs]
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel:  do_writepages+0xcb/0x1=
a0
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel:  ? touch_atime+0x1c/0x1=
60
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel:  ? filemap_read+0x32f/0=
x340
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel:=20
> __writeback_single_inode+0x3d/0x350
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel:  ? _raw_spin_lock+0x13/=
0x40
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel:=20
> writeback_sb_inodes+0x1f5/0x4c0
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel:=20
> __writeback_inodes_wb+0x4c/0xe0
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel:  wb_writeback+0x26b/0x2=
e0
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel:  wb_workfn+0x30f/0x4b0
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel:  ?
> _raw_spin_unlock+0x15/0x30
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel:  ?
> finish_task_switch.isra.0+0x91/0x2a0
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel:  ? __switch_to+0x106/0x=
3a0
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel:=20
> process_one_work+0x174/0x340
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel:  worker_thread+0x277/0x=
390
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel:  ?
> __pfx_worker_thread+0x10/0x10
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel:  kthread+0xf3/0x120
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel:  ? __pfx_kthread+0x10/0=
x10
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel:  ret_from_fork+0x30/0x50
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel:  ? __pfx_kthread+0x10/0=
x10
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel:=20
> ret_from_fork_asm+0x1b/0x30
> Nov 02 20:27:11 line-xfs-crc-logdev-rtdev kernel:  </TASK>

I have root caused the bug and hope to post the patches soon.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
