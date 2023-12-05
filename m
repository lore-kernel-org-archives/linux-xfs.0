Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E66895B1EB
	for <linux-xfs@vger.kernel.org>; Tue,  5 Dec 2023 12:26:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dKYX6scp"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7C7B2C43391
	for <linux-xfs@vger.kernel.org>; Tue,  5 Dec 2023 12:26:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701779215;
	bh=hoQYUVD24kUO+Xyy35juz1nYRmOsIAYoPYoEWL1jaYM=;
	h=From:To:Subject:Date:From;
	b=dKYX6scp8EFJVG0t6jpLnQ3wWqjmB1FyiE1TdAkD/7nTgvJ4HCj9EYPCN/3OqPUX+
	 LxOK/UW3UvZ6y7VVu0F1/2h8iyVzFW5UUjoxG5DvYxh3XnsToe0rj1aqh/o/78ZkUp
	 e8mq5VsVISR7tZUvGlU0vVj7f/y1Qybge/IuoB6d6JYuzrnU0Lutowq+R4SkwcKKQQ
	 cev7ZYjDCdEwSPrljt/M9XoOSqH5xj652sSO4pa54mWb+oWpooxFVskxVPTJgyEHmL
	 jw8mnMa9jnrwLpW1MaGq17xUxC0x9oH7ZfNH9oBUdnMeQfoQ0O32nlIWchYHkKhflf
	 gLK96zXmJcf/g==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 6CDC4C53BC6; Tue,  5 Dec 2023 12:26:55 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-xfs@vger.kernel.org
Subject: [Bug 218229] New: xfstests xfs/438 hung
Date: Tue, 05 Dec 2023 12:26:54 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: dagmcr@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version rep_platform
 op_sys bug_status bug_severity priority component assigned_to reporter
 cf_regression
Message-ID: <bug-218229-201763@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D218229

            Bug ID: 218229
           Summary: xfstests xfs/438 hung
           Product: File System
           Version: 2.5
          Hardware: Intel
                OS: Linux
            Status: NEW
          Severity: normal
          Priority: P3
         Component: XFS
          Assignee: filesystem_xfs@kernel-bugs.kernel.org
          Reporter: dagmcr@gmail.com
        Regression: No

While doing fstests baseline testing on v6.6-rc5 with kdevops [0] we found a
failure rate of ~1/2 for xfs/438 test.=20

[0] https://github.com/linux-kdevops

This fails on the following test sections as defined by kdevops [1]:

  * xfs_crc_logdev
  * xfs_reflink_logdev

[0] https://github.com/linux-kdevops
[1]
https://github.com/linux-kdevops/kdevops/blob/master/playbooks/roles/fstest=
s/templates/xfs/xfs.config

Below is just one full trace.

Oct 17 19:10:05 line-xfs-crc-logdev unknown: run fstests xfs/438 at 2023-10=
-17
19:10:05
Oct 17 19:10:06 line-xfs-crc-logdev kernel: XFS (dm-0): Mounting V5 Filesys=
tem
3e1fc16c-f101-4acb-bacb-39ae396320fe
Oct 17 19:10:07 line-xfs-crc-logdev kernel: XFS (dm-0): Ending clean mount
Oct 17 19:10:07 line-xfs-crc-logdev kernel: XFS (dm-0): Quotacheck needed:
Please wait.
Oct 17 19:10:07 line-xfs-crc-logdev kernel: XFS (dm-0): Quotacheck: Done.
Oct 17 19:10:07 line-xfs-crc-logdev kernel: XFS (dm-0): Filesystem has been
shut down due to log error (0x2).
Oct 17 19:10:07 line-xfs-crc-logdev kernel: XFS (dm-0): Please unmount the
filesystem and rectify the problem(s).
Oct 17 19:10:09 line-xfs-crc-logdev kernel: XFS (dm-0): Unmounting Filesyst=
em
3e1fc16c-f101-4acb-bacb-39ae396320fe
Oct 17 19:14:04 line-xfs-crc-logdev kernel: INFO: task umount:17146 blocked=
 for
more than 120 seconds.
Oct 17 19:14:04 line-xfs-crc-logdev kernel:       Not tainted 6.6.0-rc5 #2
Oct 17 19:14:04 line-xfs-crc-logdev kernel: "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Oct 17 19:14:04 line-xfs-crc-logdev kernel: task:umount          state:D
stack:0     pid:17146 ppid:16828  flags:0x00004002
Oct 17 19:14:04 line-xfs-crc-logdev kernel: Call Trace:
Oct 17 19:14:04 line-xfs-crc-logdev kernel:  <TASK>
Oct 17 19:14:04 line-xfs-crc-logdev kernel:  __schedule+0x3ab/0xab0
Oct 17 19:14:04 line-xfs-crc-logdev kernel:  schedule+0x5d/0xe0
Oct 17 19:14:04 line-xfs-crc-logdev kernel:  schedule_timeout+0x143/0x150
Oct 17 19:14:04 line-xfs-crc-logdev kernel:  ? __flush_workqueue+0x184/0x400
Oct 17 19:14:04 line-xfs-crc-logdev kernel:  __down_common+0xf6/0x200
Oct 17 19:14:04 line-xfs-crc-logdev kernel:  ?
__pfx_preempt_count_add+0x10/0x10
Oct 17 19:14:04 line-xfs-crc-logdev kernel:  ? preempt_count_add+0x6a/0xa0
Oct 17 19:14:04 line-xfs-crc-logdev kernel:  down+0x43/0x60
Oct 17 19:14:04 line-xfs-crc-logdev kernel:  xfs_log_unmount+0x4a/0xc0 [xfs]
Oct 17 19:14:04 line-xfs-crc-logdev kernel:  xfs_unmountfs+0x9a/0x1b0 [xfs]
Oct 17 19:14:04 line-xfs-crc-logdev kernel:  xfs_fs_put_super+0x37/0x80 [xf=
s]
Oct 17 19:14:04 line-xfs-crc-logdev kernel:  generic_shutdown_super+0x7c/0x=
110
Oct 17 19:14:04 line-xfs-crc-logdev kernel:  kill_block_super+0x16/0x40
Oct 17 19:14:04 line-xfs-crc-logdev kernel:  xfs_kill_sb+0xe/0x20 [xfs]
Oct 17 19:14:04 line-xfs-crc-logdev kernel:  deactivate_locked_super+0x2f/0=
xb0
Oct 17 19:14:04 line-xfs-crc-logdev kernel:  cleanup_mnt+0xbd/0x150
Oct 17 19:14:04 line-xfs-crc-logdev kernel:  task_work_run+0x59/0x90
Oct 17 19:14:04 line-xfs-crc-logdev kernel:=20
exit_to_user_mode_prepare+0x15c/0x160
Oct 17 19:14:04 line-xfs-crc-logdev kernel:=20
syscall_exit_to_user_mode+0x22/0x50
Oct 17 19:14:04 line-xfs-crc-logdev kernel:  do_syscall_64+0x46/0x90
Oct 17 19:14:04 line-xfs-crc-logdev kernel:=20
entry_SYSCALL_64_after_hwframe+0x6e/0xd8
Oct 17 19:14:04 line-xfs-crc-logdev kernel: RIP: 0033:0x7fb9538db737
Oct 17 19:14:04 line-xfs-crc-logdev kernel: RSP: 002b:00007fffaf33f768 EFLA=
GS:
00000246 ORIG_RAX: 00000000000000a6
Oct 17 19:14:04 line-xfs-crc-logdev kernel: RAX: 0000000000000000 RBX:
000055b4718dcb60 RCX: 00007fb9538db737
Oct 17 19:14:04 line-xfs-crc-logdev kernel: RDX: 0000000000000000 RSI:
0000000000000000 RDI: 000055b4718e0820
Oct 17 19:14:04 line-xfs-crc-logdev kernel: RBP: 0000000000000000 R08:
0000000000000007 R09: 000055b4718e0cc0
Oct 17 19:14:04 line-xfs-crc-logdev kernel: R10: 0000000000000000 R11:
0000000000000246 R12: 00007fb953a2623c
Oct 17 19:14:04 line-xfs-crc-logdev kernel: R13: 000055b4718e0820 R14:
000055b4718dce70 R15: 000055b4718dca60
Oct 17 19:14:04 line-xfs-crc-logdev kernel:  </TASK>
Oct 17 19:16:05 line-xfs-crc-logdev kernel: INFO: task umount:17146 blocked=
 for
more than 241 seconds.
Oct 17 19:16:05 line-xfs-crc-logdev kernel:       Not tainted 6.6.0-rc5 #2
Oct 17 19:16:05 line-xfs-crc-logdev kernel: "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Oct 17 19:16:05 line-xfs-crc-logdev kernel: task:umount          state:D
stack:0     pid:17146 ppid:16828  flags:0x00004002
Oct 17 19:16:05 line-xfs-crc-logdev kernel: Call Trace:
Oct 17 19:16:05 line-xfs-crc-logdev kernel:  <TASK>
Oct 17 19:16:05 line-xfs-crc-logdev kernel:  __schedule+0x3ab/0xab0
Oct 17 19:16:05 line-xfs-crc-logdev kernel:  schedule+0x5d/0xe0
Oct 17 19:16:05 line-xfs-crc-logdev kernel:  schedule_timeout+0x143/0x150
Oct 17 19:16:05 line-xfs-crc-logdev kernel:  ? __flush_workqueue+0x184/0x400
Oct 17 19:16:05 line-xfs-crc-logdev kernel:  __down_common+0xf6/0x200
Oct 17 19:16:05 line-xfs-crc-logdev kernel:  ?
__pfx_preempt_count_add+0x10/0x10
Oct 17 19:16:05 line-xfs-crc-logdev kernel:  ? preempt_count_add+0x6a/0xa0
Oct 17 19:16:05 line-xfs-crc-logdev kernel:  down+0x43/0x60
Oct 17 19:16:05 line-xfs-crc-logdev kernel:  xfs_log_unmount+0x4a/0xc0 [xfs]
Oct 17 19:16:05 line-xfs-crc-logdev kernel:  xfs_unmountfs+0x9a/0x1b0 [xfs]
Oct 17 19:16:05 line-xfs-crc-logdev kernel:  xfs_fs_put_super+0x37/0x80 [xf=
s]
Oct 17 19:16:05 line-xfs-crc-logdev kernel:  generic_shutdown_super+0x7c/0x=
110
Oct 17 19:16:05 line-xfs-crc-logdev kernel:  kill_block_super+0x16/0x40
Oct 17 19:16:05 line-xfs-crc-logdev kernel:  xfs_kill_sb+0xe/0x20 [xfs]
Oct 17 19:16:05 line-xfs-crc-logdev kernel:  deactivate_locked_super+0x2f/0=
xb0
Oct 17 19:16:05 line-xfs-crc-logdev kernel:  cleanup_mnt+0xbd/0x150
Oct 17 19:16:05 line-xfs-crc-logdev kernel:  task_work_run+0x59/0x90
Oct 17 19:16:05 line-xfs-crc-logdev kernel:=20
exit_to_user_mode_prepare+0x15c/0x160
Oct 17 19:16:05 line-xfs-crc-logdev kernel:=20
syscall_exit_to_user_mode+0x22/0x50
Oct 17 19:16:05 line-xfs-crc-logdev kernel:  do_syscall_64+0x46/0x90
Oct 17 19:16:05 line-xfs-crc-logdev kernel:=20
entry_SYSCALL_64_after_hwframe+0x6e/0xd8
Oct 17 19:16:05 line-xfs-crc-logdev kernel: RIP: 0033:0x7fb9538db737
Oct 17 19:16:05 line-xfs-crc-logdev kernel: RSP: 002b:00007fffaf33f768 EFLA=
GS:
00000246 ORIG_RAX: 00000000000000a6
Oct 17 19:16:05 line-xfs-crc-logdev kernel: RAX: 0000000000000000 RBX:
000055b4718dcb60 RCX: 00007fb9538db737
Oct 17 19:16:05 line-xfs-crc-logdev kernel: RDX: 0000000000000000 RSI:
0000000000000000 RDI: 000055b4718e0820
Oct 17 19:16:05 line-xfs-crc-logdev kernel: RBP: 0000000000000000 R08:
0000000000000007 R09: 000055b4718e0cc0
Oct 17 19:16:05 line-xfs-crc-logdev kernel: R10: 0000000000000000 R11:
0000000000000246 R12: 00007fb953a2623c
Oct 17 19:16:05 line-xfs-crc-logdev kernel: R13: 000055b4718e0820 R14:
000055b4718dce70 R15: 000055b4718dca60
Oct 17 19:16:05 line-xfs-crc-logdev kernel:  </TASK>
Oct 17 19:18:05 line-xfs-crc-logdev kernel: INFO: task umount:17146 blocked=
 for
more than 362 seconds.
Oct 17 19:18:05 line-xfs-crc-logdev kernel:       Not tainted 6.6.0-rc5 #2
Oct 17 19:18:05 line-xfs-crc-logdev kernel: "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Oct 17 19:18:05 line-xfs-crc-logdev kernel: task:umount          state:D
stack:0     pid:17146 ppid:16828  flags:0x00004002
Oct 17 19:18:05 line-xfs-crc-logdev kernel: Call Trace:
Oct 17 19:18:05 line-xfs-crc-logdev kernel:  <TASK>
Oct 17 19:18:05 line-xfs-crc-logdev kernel:  __schedule+0x3ab/0xab0
Oct 17 19:18:05 line-xfs-crc-logdev kernel:  schedule+0x5d/0xe0
Oct 17 19:18:05 line-xfs-crc-logdev kernel:  schedule_timeout+0x143/0x150
Oct 17 19:18:05 line-xfs-crc-logdev kernel:  ? __flush_workqueue+0x184/0x400
Oct 17 19:18:05 line-xfs-crc-logdev kernel:  __down_common+0xf6/0x200
Oct 17 19:18:05 line-xfs-crc-logdev kernel:  ?
__pfx_preempt_count_add+0x10/0x10
Oct 17 19:18:05 line-xfs-crc-logdev kernel:  ? preempt_count_add+0x6a/0xa0
Oct 17 19:18:05 line-xfs-crc-logdev kernel:  down+0x43/0x60
Oct 17 19:18:05 line-xfs-crc-logdev kernel:  xfs_log_unmount+0x4a/0xc0 [xfs]
Oct 17 19:18:05 line-xfs-crc-logdev kernel:  xfs_unmountfs+0x9a/0x1b0 [xfs]
Oct 17 19:18:06 line-xfs-crc-logdev kernel:  xfs_fs_put_super+0x37/0x80 [xf=
s]
Oct 17 19:18:06 line-xfs-crc-logdev kernel:  generic_shutdown_super+0x7c/0x=
110
Oct 17 19:18:06 line-xfs-crc-logdev kernel:  kill_block_super+0x16/0x40
Oct 17 19:18:06 line-xfs-crc-logdev kernel:  xfs_kill_sb+0xe/0x20 [xfs]
Oct 17 19:18:06 line-xfs-crc-logdev kernel:  deactivate_locked_super+0x2f/0=
xb0
Oct 17 19:18:06 line-xfs-crc-logdev kernel:  cleanup_mnt+0xbd/0x150
Oct 17 19:18:06 line-xfs-crc-logdev kernel:  task_work_run+0x59/0x90
Oct 17 19:18:06 line-xfs-crc-logdev kernel:=20
exit_to_user_mode_prepare+0x15c/0x160
Oct 17 19:18:06 line-xfs-crc-logdev kernel:=20
syscall_exit_to_user_mode+0x22/0x50
Oct 17 19:18:06 line-xfs-crc-logdev kernel:  do_syscall_64+0x46/0x90
Oct 17 19:18:06 line-xfs-crc-logdev kernel:=20
entry_SYSCALL_64_after_hwframe+0x6e/0xd8
Oct 17 19:18:06 line-xfs-crc-logdev kernel: RIP: 0033:0x7fb9538db737
Oct 17 19:18:06 line-xfs-crc-logdev kernel: RSP: 002b:00007fffaf33f768 EFLA=
GS:
00000246 ORIG_RAX: 00000000000000a6
Oct 17 19:18:06 line-xfs-crc-logdev kernel: RAX: 0000000000000000 RBX:
000055b4718dcb60 RCX: 00007fb9538db737
Oct 17 19:18:06 line-xfs-crc-logdev kernel: RDX: 0000000000000000 RSI:
0000000000000000 RDI: 000055b4718e0820
Oct 17 19:18:06 line-xfs-crc-logdev kernel: RBP: 0000000000000000 R08:
0000000000000007 R09: 000055b4718e0cc0
Oct 17 19:18:06 line-xfs-crc-logdev kernel: R10: 0000000000000000 R11:
0000000000000246 R12: 00007fb953a2623c
Oct 17 19:18:06 line-xfs-crc-logdev kernel: R13: 000055b4718e0820 R14:
000055b4718dce70 R15: 000055b4718dca60
Oct 17 19:18:06 line-xfs-crc-logdev kernel:  </TASK>
Oct 17 19:20:06 line-xfs-crc-logdev kernel: INFO: task umount:17146 blocked=
 for
more than 483 seconds.
Oct 17 19:20:06 line-xfs-crc-logdev kernel:       Not tainted 6.6.0-rc5 #2
Oct 17 19:20:06 line-xfs-crc-logdev kernel: "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Oct 17 19:20:06 line-xfs-crc-logdev kernel: task:umount          state:D
stack:0     pid:17146 ppid:16828  flags:0x00004002
Oct 17 19:20:06 line-xfs-crc-logdev kernel: Call Trace:
Oct 17 19:20:06 line-xfs-crc-logdev kernel:  <TASK>
Oct 17 19:20:06 line-xfs-crc-logdev kernel:  __schedule+0x3ab/0xab0
Oct 17 19:20:06 line-xfs-crc-logdev kernel:  schedule+0x5d/0xe0
Oct 17 19:20:06 line-xfs-crc-logdev kernel:  schedule_timeout+0x143/0x150
Oct 17 19:20:06 line-xfs-crc-logdev kernel:  ? __flush_workqueue+0x184/0x400
Oct 17 19:20:06 line-xfs-crc-logdev kernel:  __down_common+0xf6/0x200
Oct 17 19:20:06 line-xfs-crc-logdev kernel:  ?
__pfx_preempt_count_add+0x10/0x10
Oct 17 19:20:06 line-xfs-crc-logdev kernel:  ? preempt_count_add+0x6a/0xa0
Oct 17 19:20:06 line-xfs-crc-logdev kernel:  down+0x43/0x60
Oct 17 19:20:06 line-xfs-crc-logdev kernel:  xfs_log_unmount+0x4a/0xc0 [xfs]
Oct 17 19:20:06 line-xfs-crc-logdev kernel:  xfs_unmountfs+0x9a/0x1b0 [xfs]
Oct 17 19:20:06 line-xfs-crc-logdev kernel:  xfs_fs_put_super+0x37/0x80 [xf=
s]
Oct 17 19:20:06 line-xfs-crc-logdev kernel:  generic_shutdown_super+0x7c/0x=
110
Oct 17 19:20:06 line-xfs-crc-logdev kernel:  kill_block_super+0x16/0x40
Oct 17 19:20:06 line-xfs-crc-logdev kernel:  xfs_kill_sb+0xe/0x20 [xfs]
Oct 17 19:20:06 line-xfs-crc-logdev kernel:  deactivate_locked_super+0x2f/0=
xb0
Oct 17 19:20:06 line-xfs-crc-logdev kernel:  cleanup_mnt+0xbd/0x150
Oct 17 19:20:06 line-xfs-crc-logdev kernel:  task_work_run+0x59/0x90
Oct 17 19:20:06 line-xfs-crc-logdev kernel:=20
exit_to_user_mode_prepare+0x15c/0x160
Oct 17 19:20:06 line-xfs-crc-logdev kernel:=20
syscall_exit_to_user_mode+0x22/0x50
Oct 17 19:20:06 line-xfs-crc-logdev kernel:  do_syscall_64+0x46/0x90
Oct 17 19:20:06 line-xfs-crc-logdev kernel:=20
entry_SYSCALL_64_after_hwframe+0x6e/0xd8
Oct 17 19:20:06 line-xfs-crc-logdev kernel: RIP: 0033:0x7fb9538db737
Oct 17 19:20:06 line-xfs-crc-logdev kernel: RSP: 002b:00007fffaf33f768 EFLA=
GS:
00000246 ORIG_RAX: 00000000000000a6

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
