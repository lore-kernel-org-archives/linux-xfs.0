Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33603437472;
	Tue, 11 Aug 2026 11:21:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786447300; cv=none; b=kT03FOZDXifthpp+j+dz09dnXPudAJDp5eRTzaOK0tT0YNLBAfj/y/bPsddB1Plyj7FfPO37gCbZOhV+9wM9p0UwKOpkte79Qw6nLlLHBcIBLWxwI/o8aKhvPJE8lUeAdr8JtjEVfox+/01gmfSaGfXalt38I6ue3rcvPvzw2Kk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786447300; c=relaxed/simple;
	bh=ihCDGTLDO/8BDQcsApjnRyWmmm+fr4iVTJI/jfzjsJw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EHgTbvviBTfAYKJ0lCHM4PJDog2Wo582bd0Z/IsTuPRKdXYJgtQZJh0YuniClk0HICyhhyTVeYqtLH2rvxQA8+SWe08Hf1liURreJFZZY03YCBVR0n1YL2dT4oJvq7dTLmbcTDlC3NU8bdH9Fr2bO4b3W2NCNNtSmihKmalho0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k6V+7pu/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k6V+7pu/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 870351F00A3A;
	Tue, 11 Aug 2026 11:21:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786447293;
	bh=ItqqIGsGoJL6FHy3XeGYDx+XuWP4CiIjJLQMgN/jVUg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=k6V+7pu/vlQb+PTDmSKZaGQ6SmrZVJADI7Wy+N/eg7JvUfRYRNR/FISdgTDukKoWM
	 hCNnd4U3w6qNYkb2vnvQJMmOTLJq88Mca3wBmGjnJfiDx1BqinrlbQx1hnzEog/uH5
	 wCSPIvCGkgwhHodBtQx2jBVqGIRRgeJOGYs57KedN+8Bnc/Kp7c8WMOijzRdqTstqm
	 QN1xEY1BPzb5yau00cGILhpNiz0YNFcSGi3oyQTGU8BgWOVor3efE/82qcwgCqnHyM
	 b0/qT8XGUcXxyfwA4bctPVnBgB+CFV6HmFM+7PqvnRZQv3Iks/ZOXoAoQm4uHB/57R
	 qNpU7a5mnNh3A==
Date: Tue, 11 Aug 2026 13:21:28 +0200
From: Christian Brauner <brauner@kernel.org>
To: syzbot <syzbot+b3fba2e269970207b61d@syzkaller.appspotmail.com>
Cc: cem@kernel.org, gregkh@linuxfoundation.org, jack@suse.cz, 
	jfs-discussion@lists.sourceforge.net, kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-xfs@vger.kernel.org, shaggy@kernel.org, syzkaller-bugs@googlegroups.com, 
	tj@kernel.org, viro@zeniv.linux.org.uk
Subject: Re: [syzbot] [kernfs?] [ext4?] INFO: task hung in sb_start_write (2)
Message-ID: <20260811-schlecht-arkaden-spickzettel-0dfee4014102@brauner>
References: <682ffdaa.a70a0220.253bc2.0061.GAE@google.com>
 <6a75a39e.01d0871a.3a0d52.0042.GAE@google.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <6a75a39e.01d0871a.3a0d52.0042.GAE@google.com>

On Fri, Aug 07, 2026 at 02:21:34AM -0700, syzbot wrote:
> syzbot has found a reproducer for the following issue on:
> 
> HEAD commit:    f9a2394a2348 Merge tag 'mm-hotfixes-stable-2026-08-06-18-4..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=1379cfb9580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=98da55a882774dfe
> dashboard link: https://syzkaller.appspot.com/bug?extid=b3fba2e269970207b61d
> compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14b9d7b9580000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+b3fba2e269970207b61d@syzkaller.appspotmail.com
> 
> INFO: task syz-executor328:5959 blocked for more than 15 seconds.
>       Not tainted syzkaller #0
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> task:syz-executor328 state:D stack:28328 pid:5959  tgid:5959  ppid:5947   task_flags:0x400040 flags:0x00080000
> Call Trace:
>  <TASK>
>  context_switch kernel/sched/core.c:5510 [inline]
>  __schedule+0x16dc/0x5500 kernel/sched/core.c:7234
>  __schedule_loop kernel/sched/core.c:7311 [inline]
>  schedule+0x164/0x2b0 kernel/sched/core.c:7326
>  percpu_rwsem_wait+0x32d/0x4a0 kernel/locking/percpu-rwsem.c:164
>  __percpu_down_read+0xf8/0x140 kernel/locking/percpu-rwsem.c:180
>  percpu_down_read_internal include/linux/percpu-rwsem.h:67 [inline]
>  percpu_down_read_freezable include/linux/percpu-rwsem.h:83 [inline]
>  __sb_start_write include/linux/fs/super.h:19 [inline]
>  sb_start_write+0x18e/0x1c0 include/linux/fs/super.h:125
>  mnt_want_write+0x41/0x90 fs/namespace.c:494
>  do_tmpfile+0x6c/0x240 fs/namei.c:4817
>  path_openat+0x3095/0x3850 fs/namei.c:4854
>  do_file_open+0x23e/0x4a0 fs/namei.c:4892
>  do_sys_openat2+0x115/0x200 fs/open.c:1368
>  do_sys_open fs/open.c:1374 [inline]
>  __do_sys_openat fs/open.c:1390 [inline]
>  __se_sys_openat fs/open.c:1385 [inline]
>  __x64_sys_openat+0x138/0x170 fs/open.c:1385
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f3fb490aaf7
> RSP: 002b:00007fff7f2f6f10 EFLAGS: 00000202 ORIG_RAX: 0000000000000101
> RAX: ffffffffffffffda RBX: 0000555578a51400 RCX: 00007f3fb490aaf7
> RDX: 0000000000410001 RSI: 00007f3fb494a764 RDI: ffffffffffffff9c
> RBP: 00007f3fb494a764 R08: 0000000000000000 R09: 0000000000000000
> R10: 00000000000001b6 R11: 0000000000000202 R12: 00007fff7f2f70d8
> R13: 0000000000000002 R14: 00007f3fb4970c80 R15: 0000000000000002
>  </TASK>
> 
> Showing all locks held in the system:
> 1 lock held by khungtaskd/38:
>  #0: ffffffff8e1c3000 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire include/linux/rcupdate.h:300 [inline]
>  #0: ffffffff8e1c3000 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock include/linux/rcupdate.h:840 [inline]
>  #0: ffffffff8e1c3000 (rcu_read_lock){....}-{1:3}, at: debug_show_all_locks+0x2e/0x180 kernel/locking/lockdep.c:6775
> 2 locks held by getty/5356:
>  #0: ffff88803688d0a0 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x25/0x70 drivers/tty/tty_ldisc.c:243
>  #1: ffffc90003cc62e0 (&ldata->atomic_read_lock){+.+.}-{4:4}, at: n_tty_read+0x460/0x1360 drivers/tty/n_tty.c:2211
> 1 lock held by syz-executor328/5959:
>  #0: ffff888035a88500 (sb_writers#4){++++}-{0:0}, at: mnt_want_write+0x41/0x90 fs/namespace.c:494
> 
> =============================================
> 
> NMI backtrace for cpu 1
> CPU: 1 UID: 0 PID: 38 Comm: khungtaskd Not tainted syzkaller #0 PREEMPT_{RT,(full)} 
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/24/2026
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  nmi_cpu_backtrace+0x274/0x2d0 lib/nmi_backtrace.c:122
>  nmi_trigger_cpumask_backtrace+0x17a/0x380 lib/nmi_backtrace.c:65
>  trigger_all_cpu_backtrace include/linux/nmi.h:162 [inline]
>  __sys_info lib/sys_info.c:157 [inline]
>  sys_info+0x135/0x170 lib/sys_info.c:165
>  check_hung_uninterruptible_tasks kernel/hung_task.c:353 [inline]
>  watchdog+0xfd7/0x1030 kernel/hung_task.c:561
>  kthread+0x388/0x470 kernel/kthread.c:436
>  ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>  </TASK>
> Sending NMI from CPU 1 to CPUs 0:
> NMI backtrace for cpu 0
> CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Not tainted syzkaller #0 PREEMPT_{RT,(full)} 
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/24/2026
> RIP: 0010:pv_native_safe_halt+0xf/0x20 arch/x86/kernel/paravirt.c:64
> Code: cb 6e 02 e9 13 cf 03 00 cc cc cc 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa 66 90 0f 00 2d 33 44 24 00 fb f4 <c3> cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc 90 90 90 90 90
> RSP: 0018:ffffffff8de07de0 EFLAGS: 00000242
> RAX: 000000000009a1e9 RBX: ffffffff81998590 RCX: 0000000080000001
> RDX: 0000000000000001 RSI: ffffffff8d887e30 RDI: ffffffff8bca6d80
> RBP: ffffffff8de07eb8 R08: ffff8880b8633d5b R09: 1ffff110170c67ab
> R10: dffffc0000000000 R11: ffffed10170c67ac R12: 0000000000000000
> R13: 1ffffffff1bdede8 R14: 1ffffffff1bc0fc4 R15: dffffc0000000000
> FS:  0000000000000000(0000) GS:ffff888125c36000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000563216b981d0 CR3: 000000000dfb0000 CR4: 00000000003526f0
> Call Trace:
>  <TASK>
>  arch_safe_halt arch/x86/kernel/process.c:767 [inline]
>  default_idle+0x9/0x20 arch/x86/kernel/process.c:768
>  default_idle_call+0x72/0xb0 kernel/sched/idle.c:122
>  cpuidle_idle_call kernel/sched/idle.c:199 [inline]
>  do_idle+0x2e0/0x540 kernel/sched/idle.c:355
>  cpu_startup_entry+0x43/0x60 kernel/sched/idle.c:454
>  rest_init+0x2de/0x300 init/main.c:717
>  start_kernel+0x392/0x3e0 init/main.c:1175
>  x86_64_start_reservations+0x24/0x30 arch/x86/kernel/head64.c:310
>  x86_64_start_kernel+0x137/0x1b0 arch/x86/kernel/head64.c:291
>  common_startup_64+0x13e/0x157
>  </TASK>
> 
> 
> ---
> If you want syzbot to run the reproducer, reply with:
> #syz test: git://repo/address.git branch-or-commit-hash
> If you attach or paste a git patch, syzbot will apply it before testing.
> 

The reproducer freezes the root filesystem with FIFREEZE and then opens
O_TMPFILE on it from a child. Excellent. In addition to that it also
lowers hung_task_timeout_secs to 15 before freezing and only thaws after
60 seconds... Nothing is stuck and the machine recovers.

The older crashes look like the same thing. So the fuzzer freezes a
filesystem and some other program writes to it. That also explains why
there's only ever the one blocked task and nothing else in the system
holding anything.

So maybe gate that ioctl for syzkaller?

And the LLM thing that is attached to the report is wrong.

#syz invalid
