Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8798C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Oct 2021 07:36:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C8976115B
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Oct 2021 07:36:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229498AbhJTHiW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 Oct 2021 03:38:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:53448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229491AbhJTHiW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 20 Oct 2021 03:38:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 3201A611C7
        for <linux-xfs@vger.kernel.org>; Wed, 20 Oct 2021 07:36:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634715368;
        bh=okPHq75oeyz7kSdB7dYjL1PyfYCZr2tVUbYizBSxnbM=;
        h=From:To:Subject:Date:From;
        b=XNszpm4e5ztmkK0V+SGSZjnNuSSfm2Wr5LMk5GSaOwnHl4gqqTSfNoc9o5SE1l4ZO
         z/iH6ruMfgVRUe/X7dBpjz3+HGEfdYQg6lfq3ptrNjvC+KBs8beK1QbkeQ0+6On42d
         BW92uBMag6jISzooMehBUkC1MZDkom8lekAqY/ATemdcWU4L5tl+3R2mQQ5CXPcAb2
         FYRgYnUnaiWoyrhIlPh5leZ69+lVSk0aNSKvMd6LkZy/YciN3cKM46ylmgiOID3t6o
         +3neefrOxBPXXe7csq2CGvE4LuFu7QaGq20z3dNKBoTqGXDQzJObwp3uZZPlN864Ki
         U+U3Jd3jcE0lA==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 214767] New: xfs seems to hang due to race condition? maybe
 related to (gratuitous) thaw.
Date:   Wed, 20 Oct 2021 07:36:07 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
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
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression
Message-ID: <bug-214767-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D214767

            Bug ID: 214767
           Summary: xfs seems to hang due to race condition? maybe related
                    to (gratuitous) thaw.
           Product: File System
           Version: 2.5
    Kernel Version: 5.10.70
          Hardware: x86-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: XFS
          Assignee: filesystem_xfs@kernel-bugs.kernel.org
          Reporter: ct@flyingcircus.io
        Regression: No

We have been getting somewhat frequently (around 1 per day for about 500 VM=
s)
blocked tasks with tracebacks always similar to this:

First we get:

[656898.010322] INFO: task kworker/u2:1:458736 blocked for more than 122
seconds.
[656898.011988]       Not tainted 5.10.70 #1-NixOS
[656898.012981] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables
this message.
[656898.014679] task:kworker/u2:1    state:D stack:    0 pid:458736 ppid:  =
   2
flags:0x00004000
[656898.016530] Workqueue: writeback wb_workfn (flush-253:0)
[656898.017698] Call Trace:
[656898.018310]  __schedule+0x271/0x860
[656898.019208]  schedule+0x46/0xb0
[656898.019944]  rwsem_down_read_slowpath+0x169/0x490
[656898.021008]  ? mempool_alloc+0x62/0x170
[656898.022032]  xfs_map_blocks+0xb9/0x400 [xfs]
[656898.022998]  iomap_do_writepage+0x163/0x850
[656898.023587]  ? __mod_memcg_lruvec_state+0x21/0xe0
[656898.024044]  write_cache_pages+0x186/0x3d0
[656898.024463]  ? iomap_migrate_page+0xc0/0xc0
[656898.024882]  ? submit_bio_noacct+0x3a9/0x420
[656898.025303]  iomap_writepages+0x1c/0x40
[656898.025712]  xfs_vm_writepages+0x64/0x90 [xfs]
[656898.026146]  do_writepages+0x34/0xc0
[656898.026513]  __writeback_single_inode+0x39/0x2a0
[656898.026969]  writeback_sb_inodes+0x200/0x470
[656898.027388]  __writeback_inodes_wb+0x4c/0xe0
[656898.027805]  wb_writeback+0x1d8/0x290
[656898.028161]  wb_workfn+0x29b/0x4d0
[656898.028526]  ? __switch_to_asm+0x42/0x70
[656898.028915]  ? __switch_to+0x7b/0x3e0
[656898.029285]  process_one_work+0x1df/0x370
[656898.029696]  worker_thread+0x50/0x400
[656898.030054]  ? process_one_work+0x370/0x370
[656898.030475]  kthread+0x11b/0x140
[656898.030798]  ? __kthread_bind_mask+0x60/0x60
[656898.031214]  ret_from_fork+0x22/0x30
[656898.031592] INFO: task nix-daemon:459204 blocked for more than 122 seco=
nds.
[656898.032259]       Not tainted 5.10.70 #1-NixOS
[656898.032695] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables
this message.
[656898.033451] task:nix-daemon      state:D stack:    0 pid:459204 ppid:  =
1067
flags:0x00000000
[656898.034261] Call Trace:
[656898.034538]  __schedule+0x271/0x860
[656898.034881]  schedule+0x46/0xb0
[656898.035226]  xfs_log_commit_cil+0x6a4/0x800 [xfs]
[656898.035709]  ? wake_up_q+0xa0/0xa0
[656898.036073]  __xfs_trans_commit+0x9d/0x310 [xfs]
[656898.036561]  xfs_setattr_nonsize+0x342/0x520 [xfs]
[656898.037027]  notify_change+0x348/0x4c0
[656898.037407]  ? chmod_common+0xa1/0x150
[656898.037779]  chmod_common+0xa1/0x150
[656898.038139]  do_fchmodat+0x5a/0xb0
[656898.038491]  __x64_sys_chmod+0x17/0x20
[656898.038860]  do_syscall_64+0x33/0x40
[656898.039221]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[656898.039722] RIP: 0033:0x7f3d9b3a3b77
[656898.040072] RSP: 002b:00007ffc388e2b18 EFLAGS: 00000206 ORIG_RAX:
000000000000005a
[656898.040797] RAX: ffffffffffffffda RBX: 00007ffc388e2e10 RCX:
00007f3d9b3a3b77
[656898.041542] RDX: 0000000000008049 RSI: 0000000000008124 RDI:
00000000016a2400
[656898.042222] RBP: 00007ffc388e32a0 R08: 00007ffc388e4628 R09:
0000000000000000
[656898.042913] R10: 0000000000000000 R11: 0000000000000206 R12:
00007ffc388e4620
[656898.043604] R13: 0000000000000000 R14: 00007ffc388e2df0 R15:
00007ffc388e2e10


and then a while later we see this:

[657020.886633] INFO: task qemu-ga:750 blocked for more than 122 seconds.
[657020.888346]       Not tainted 5.10.70 #1-NixOS
[657020.889482] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables
this message.
[657020.891072] task:qemu-ga         state:D stack:    0 pid:  750 ppid:   =
  1
flags:0x00000080
[657020.891906] Call Trace:
[657020.892188]  __schedule+0x271/0x860
[657020.892547]  ? kvm_sched_clock_read+0xd/0x20
[657020.892983]  schedule+0x46/0xb0
[657020.893319]  rwsem_down_write_slowpath+0x218/0x480
[657020.893802]  thaw_super+0x12/0x20
[657020.894130]  __x64_sys_ioctl+0x62/0xb0
[657020.894491]  do_syscall_64+0x33/0x40
[657020.894860]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[657020.895396] RIP: 0033:0x7f69a55f2b17
[657020.895762] RSP: 002b:00007ffe5687b548 EFLAGS: 00000246 ORIG_RAX:
0000000000000010
[657020.896470] RAX: ffffffffffffffda RBX: 0000000000000000 RCX:
00007f69a55f2b17
[657020.897144] RDX: 0000000000000000 RSI: 00000000c0045878 RDI:
0000000000000006
[657020.897815] RBP: 0000000000000000 R08: 00007f69a5477c08 R09:
0000000000000000
[657020.898479] R10: 0000000000000000 R11: 0000000000000246 R12:
000055ef74a15190
[657020.899155] R13: 00007ffe5687b5c0 R14: 00007ffe5687b560 R15:
0000000000000006
[657020.899850] INFO: task kworker/u2:1:458736 blocked for more than 245
seconds.
[657020.900513]       Not tainted 5.10.70 #1-NixOS
[657020.900942] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables
this message.
[657020.901672] task:kworker/u2:1    state:D stack:    0 pid:458736 ppid:  =
   2
flags:0x00004000
[657020.902469] Workqueue: writeback wb_workfn (flush-253:0)
[657020.902976] Call Trace:
[657020.903220]  __schedule+0x271/0x860
[657020.903556]  schedule+0x46/0xb0
[657020.903870]  rwsem_down_read_slowpath+0x169/0x490
[657020.904321]  ? mempool_alloc+0x62/0x170
[657020.904996]  xfs_map_blocks+0xb9/0x400 [xfs]
[657020.905412]  iomap_do_writepage+0x163/0x850
[657020.905823]  ? __mod_memcg_lruvec_state+0x21/0xe0
[657020.906269]  write_cache_pages+0x186/0x3d0
[657020.906664]  ? iomap_migrate_page+0xc0/0xc0
[657020.907079]  ? submit_bio_noacct+0x3a9/0x420
[657020.907487]  iomap_writepages+0x1c/0x40
[657020.907942]  xfs_vm_writepages+0x64/0x90 [xfs]
[657020.908376]  do_writepages+0x34/0xc0
[657020.908760]  __writeback_single_inode+0x39/0x2a0
[657020.909222]  writeback_sb_inodes+0x200/0x470
[657020.909635]  __writeback_inodes_wb+0x4c/0xe0
[657020.910058]  wb_writeback+0x1d8/0x290
[657020.910410]  wb_workfn+0x29b/0x4d0
[657020.910756]  ? __switch_to_asm+0x42/0x70
[657020.911135]  ? __switch_to+0x7b/0x3e0
[657020.911489]  process_one_work+0x1df/0x370
[657020.911912]  worker_thread+0x50/0x400
[657020.912264]  ? process_one_work+0x370/0x370
[657020.912667]  kthread+0x11b/0x140
[657020.913008]  ? __kthread_bind_mask+0x60/0x60
[657020.913413]  ret_from_fork+0x22/0x30
[657020.913791] INFO: task nix-daemon:459204 blocked for more than 245 seco=
nds.
[657020.914440]       Not tainted 5.10.70 #1-NixOS
[657020.914879] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables
this message.
[657020.915612] task:nix-daemon      state:D stack:    0 pid:459204 ppid:  =
1067
flags:0x00000000
[657020.916399] Call Trace:
[657020.916654]  __schedule+0x271/0x860
[657020.917006]  schedule+0x46/0xb0
[657020.917343]  xfs_log_commit_cil+0x6a4/0x800 [xfs]
[657020.917806]  ? wake_up_q+0xa0/0xa0
[657020.918162]  __xfs_trans_commit+0x9d/0x310 [xfs]
[657020.918633]  xfs_setattr_nonsize+0x342/0x520 [xfs]
[657020.919101]  notify_change+0x348/0x4c0
[657020.919461]  ? chmod_common+0xa1/0x150
[657020.919831]  chmod_common+0xa1/0x150
[657020.920180]  do_fchmodat+0x5a/0xb0
[657020.920509]  __x64_sys_chmod+0x17/0x20
[657020.920878]  do_syscall_64+0x33/0x40
[657020.921222]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[657020.921703] RIP: 0033:0x7f3d9b3a3b77
[657020.922055] RSP: 002b:00007ffc388e2b18 EFLAGS: 00000206 ORIG_RAX:
000000000000005a
[657020.922772] RAX: ffffffffffffffda RBX: 00007ffc388e2e10 RCX:
00007f3d9b3a3b77
[657020.923435] RDX: 0000000000008049 RSI: 0000000000008124 RDI:
00000000016a2400
[657020.924115] RBP: 00007ffc388e32a0 R08: 00007ffc388e4628 R09:
0000000000000000
[657020.924787] R10: 0000000000000000 R11: 0000000000000206 R12:
00007ffc388e4620
[657020.925450] R13: 0000000000000000 R14: 00007ffc388e2df0 R15:
00007ffc388e2e10


IO is subsequently stalled on ALL disks (we have vda/vdb/vdc with two of th=
em
running XFS and one running swap).

I am pretty sure that this is not primarily an issue in the hypervisor (Qemu
4.1) or storage (Ceph Jewel) because I can warm reset the virtual machine u=
sing
"system-reset" and the machine will boot properly.

This could be related to https://bugzilla.kernel.org/show_bug.cgi?id=3D2070=
53 but
it doesn't look quite right.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
