Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=193.35.52.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795641175;
	b=auorSDNoWkg1/wfukz0CAYEi4+i/vyyJnkk1UrIwRrYajiP4PGlOOL0tIMBQydxjgrUE
	 tNNeqvgTcQhKkD8ZNA2w5R2g7Rg/GItd6xNFt8UoYaPMItASSqnOnt+riRNR9BEE4iJFV
	 FxjHj/t2bYcRfRfeRxlcQGdtvN1vREyFM3B36zTIg31VAowficK3o4Xzk9o7Mx/q3NVyF
	 OPPtLnLkzr6eGffYuC5bJHZRrRlGnDBUGk56gRzwfi478S5hWpDUEePB8nIRTqGs//lOI
	 JThaEwgj/bSZAkdUtJFVOFUF2esQhp4LX0q0SolrKnNrMe66alqdSDavEfelHO9648Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795641175;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:X-Operating-System:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=gsi93MKqpJZ6964NrjZkr9/vvL7nFxjUXJpChFEEmvo=;
	b=1bJ3xtq5dUUaX+JCnjve9vf2DGTdTZw+W4kcTW3unvIIWdgFTzNOBoigjQLYSBFeRRVX
	 P9SqgCBAO1GYDZvnEn1mjAvvA88ZVrw1JDCuZwJo7LZ7LmfRUhNHFMeE17Ni43LLzgRN3
	 vIEY7iyOjiVvJjWQzxMtZLDdlU8TFG31HWYXj+jl1dZ65kpVtLY74V3dzb4yI+7jAj0gx
	 gvKUQtCE2oIMxQnNZz15xuFyfC4Icaswed3TXlMQ4K2jGwt0vqPEuR2486bx2YPchEnCO
	 ZMy0dgETFXpImDXGRttkk/X7x/HmWyRM7bVcbSAcYjRF78nNi230oL9I1txR81nuEug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=gunderson.no;
	spf=pass smtp.mailfrom=gunderson.no;
	dkim=pass header.d=gunderson.no header.i=@gunderson.no header.a=rsa-sha256 header.s=legacy header.b=1HocNYHT;
	arc=none smtp.remote-ip=193.35.52.50
Received: from pannekake.samfundet.no (pannekake.samfundet.no [193.35.52.50])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27FA4606A31E
	for <linux-xfs@vger.kernel.org>; Wed, 25 Nov 2026 21:12:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 27FA4606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gunderson.no
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gunderson.no
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gunderson.no header.i=@gunderson.no header.a=rsa-sha256 header.s=legacy header.b=1HocNYHT
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gunderson.no; s=legacy; h=In-Reply-To:Content-Type:MIME-Version:References:
	Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=gsi93MKqpJZ6964NrjZkr9/vvL7nFxjUXJpChFEEmvo=; b=1HocNYHTivZlSXlcvj13ZFaf4f
	OoQLLmIdWN8nOttdvblcbW47rC90HNP4inZavLHbxbF6apYh3xUas0J5lalHoyZhTK0iz7vWWMV1v
	lWortAe+jte2w3edlKS73MdXcDFFGSoqz2QfVwe/Q2rLLS2j3kR0jUnQEQ4YvV7ZaVa3WvEJ39EP4
	wPreMjdLUINeyuiOb6XpCE0fdcqXi78c6UVYTT9+wabtPBbyw//o4X8c21F2NTnAryfnDHY8k5NNo
	fUeca2m0qJ+igV8QJ26ioTYcmvrXarIR2xEK4XEde804FH6rHJCx17V+WPUOd4lLMMhyxrZe8BwnO
	OoPRSdaw==;
Received: from sesse by pannekake.samfundet.no with local (Exim 4.98.2)
	(envelope-from <steinar+bounces@gunderson.no>)
	id 1xWK8H-00000004oIP-0r30;
	Wed, 25 Nov 2026 22:05:19 +0100
Date: Wed, 25 Nov 2026 22:02:25 +0100
From: "Steinar H. Gunderson" <steinar+kernel@gunderson.no>
To: Dave Chinner <dgc@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: Hung I/O
Message-ID: <w7gmeo5scvyud6uzggjcdegitwh3r4jnj3bl4ozivdzfwcrxda@tfafi2wvvnmx>
X-Operating-System: Linux 7.3.6 on a x86_64
References: <sh2gykmlybrlf77d6mp76pddecwl47pxoookx2sbo74y6ffme4@gcu2kqu7q4o2>
 <awc-vvNFH3vfYLWv@dread>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="yjw5avaouxkl3nnd"
Content-Disposition: inline
In-Reply-To: <awc-vvNFH3vfYLWv@dread>


--yjw5avaouxkl3nnd
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

On Thu, Nov 26, 2026 at 07:02:06AM +1100, Dave Chinner wrote:
> can you post the entire dmesg output from 'echo w >
> /proc/sysrq-trigger' and 'echo l > /proc/sysrq-trigger' to capture
> all the currently blocked and running processes when the hang
> happens.

Attached. (I did it a couple of times and picked out only one.)

Interestingly, the very act of taking the sysrqs seems to unblock the
processes in some cases.

> Start with getting all the blocked tasks and building a dependency
> map of which tasks are stuck behind others. That will narrow down
> whether this is some internal deadlock in the filesystem or whether
> the lower layers of the stack have lost a bunch of IO completions...

It's not quite obvious to me how to find out which ones are actually
blocked on whom. Like, if someone is waiting for a lock, how do I
figure out who is holding that lock?

/* Steinar */
-- 
Homepage: https://www.sesse.net/

--yjw5avaouxkl3nnd
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="sysrq-output.txt"

[42462.794262] sysrq: Show Blocked State
[42462.799066] task:md1_raid6       state:D stack:0     pid:5254  tgid:5254  ppid:2      task_flags:0x208040 flags:0x00080000
[42462.802996] Call Trace:
[42462.806905]  <TASK>
[42462.810824]  ? __pfx_wbt_cleanup_cb+0x10/0x10
[42462.814749]  __schedule+0x581/0x10b0
[42462.818646]  ? __pfx_wbt_inflight_cb+0x10/0x10
[42462.822517]  ? __pfx_wbt_cleanup_cb+0x10/0x10
[42462.826320]  schedule+0x28/0xa0
[42462.830049]  io_schedule+0x46/0x70
[42462.833730]  rq_qos_wait+0xb3/0x150
[42462.837317]  ? __pfx_rq_qos_wake_function+0x10/0x10
[42462.840847]  ? __pfx_wbt_inflight_cb+0x10/0x10
[42462.844314]  wbt_wait+0xa5/0x100
[42462.847741]  __rq_qos_throttle+0x27/0x40
[42462.851173]  blk_mq_submit_bio+0x589/0x8b0
[42462.854613]  submit_bio_noacct_nocheck+0x27f/0x350
[42462.858079]  ? bio_associate_blkg+0xb3/0x140
[42462.861547]  ops_run_io+0x790/0xc50 [raid456]
[42462.864992]  ? __pfx_raid5_end_write_request+0x10/0x10 [raid456]
[42462.868420]  handle_stripe+0xb44/0x2410 [raid456]
[42462.871894]  ? __hrtimer_rearm_deferred+0x5d/0x130
[42462.875347]  handle_active_stripes.isra.0+0x37c/0x5a0 [raid456]
[42462.878780]  raid5d+0x4cd/0x7a0 [raid456]
[42462.882152]  md_thread+0xa5/0x1d0 [md_mod]
[42462.885490]  ? __pfx_autoremove_wake_function+0x10/0x10
[42462.888782]  ? __pfx_md_thread+0x10/0x10 [md_mod]
[42462.891983]  kthread+0xe5/0x120
[42462.895108]  ? __pfx_kthread+0x10/0x10
[42462.898206]  ret_from_fork+0x2b7/0x340
[42462.901298]  ? __pfx_kthread+0x10/0x10
[42462.904376]  ret_from_fork_asm+0x1a/0x30
[42462.907470]  </TASK>
[42462.910576] task:xfsaild/dm-23   state:D stack:0     pid:5667  tgid:5667  ppid:2      task_flags:0x200840 flags:0x00080000
[42462.913830] Call Trace:
[42462.917023]  <TASK>
[42462.920132]  __schedule+0x581/0x10b0
[42462.923200]  schedule+0x28/0xa0
[42462.926211]  schedule_timeout+0xbd/0x100
[42462.929146]  __wait_for_common+0x97/0x1c0
[42462.931991]  ? __pfx_schedule_timeout+0x10/0x10
[42462.934788]  __flush_workqueue+0x154/0x410
[42462.937563]  xlog_cil_push_now.isra.0+0x5e/0xa0 [xfs]
[42462.940432]  xlog_cil_force_seq+0x66/0x240 [xfs]
[42462.943275]  ? __try_to_del_timer_sync+0x57/0x90
[42462.946093]  xfs_log_force+0x78/0x240 [xfs]
[42462.948957]  xfsaild+0x170/0xa40 [xfs]
[42462.951790]  ? __set_cpus_allowed_ptr+0x68/0xc0
[42462.954581]  ? __pfx_xfsaild+0x10/0x10 [xfs]
[42462.957314]  kthread+0xe5/0x120
[42462.959919]  ? __pfx_kthread+0x10/0x10
[42462.962550]  ret_from_fork+0x2b7/0x340
[42462.965172]  ? __pfx_kthread+0x10/0x10
[42462.967779]  ret_from_fork_asm+0x1a/0x30
[42462.970379]  </TASK>
[42462.973060] task:xfsaild/dm-39   state:D stack:0     pid:10658 tgid:10658 ppid:2      task_flags:0x200840 flags:0x00080000
[42462.975864] Call Trace:
[42462.978626]  <TASK>
[42462.981381]  __schedule+0x581/0x10b0
[42462.984141]  schedule+0x28/0xa0
[42462.986884]  raid5_get_active_stripe+0x283/0x5a0 [raid456]
[42462.989686]  ? __pfx_autoremove_wake_function+0x10/0x10
[42462.992503]  raid5_make_request+0x226/0x1520 [raid456]
[42462.995344]  ? bdev_start_io_acct+0x2a/0xa0
[42462.998171]  ? dm_io_acct+0xb9/0xf0 [dm_mod]
[42463.000999]  ? __pfx_woken_wake_function+0x10/0x10
[42463.003842]  md_handle_request+0x22b/0x370 [md_mod]
[42463.006668]  ? bio_split_to_limits+0x145/0x160
[42463.009470]  __submit_bio+0xa1/0x140
[42463.012249]  submit_bio_noacct_nocheck+0x12a/0x350
[42463.015033]  xfs_buf_submit+0x1b2/0x440 [xfs]
[42463.017864]  ? down_trylock+0x34/0x40
[42463.020618]  xfs_buf_delwri_submit_nowait+0xb8/0x130 [xfs]
[42463.023449]  ? xfs_buf_unlock+0x17/0x70 [xfs]
[42463.026264]  xfsaild+0x2ca/0xa40 [xfs]
[42463.029090]  ? __set_cpus_allowed_ptr+0x68/0xc0
[42463.031883]  ? __pfx_xfsaild+0x10/0x10 [xfs]
[42463.034725]  kthread+0xe5/0x120
[42463.037517]  ? __pfx_kthread+0x10/0x10
[42463.040317]  ret_from_fork+0x2b7/0x340
[42463.043111]  ? __pfx_kthread+0x10/0x10
[42463.045805]  ret_from_fork_asm+0x1a/0x30
[42463.048418]  </TASK>
[42463.051137] task:prometheus      state:D stack:0     pid:15735 tgid:11079 ppid:1      task_flags:0x440040 flags:0x00080000
[42463.053972] Call Trace:
[42463.056767]  <TASK>
[42463.059546]  __schedule+0x581/0x10b0
[42463.062337]  schedule+0x28/0xa0
[42463.065109]  schedule_preempt_disabled+0x16/0x30
[42463.067900]  rwsem_down_write_slowpath+0x2d8/0x750
[42463.070681]  down_write+0x5c/0x60
[42463.073450]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42463.076294]  file_update_time_flags+0x7e/0x130
[42463.079087]  xfs_file_write_checks+0x183/0x2c0 [xfs]
[42463.081946]  xfs_file_buffered_write+0x60/0x2d0 [xfs]
[42463.084789]  ? security_file_permission+0x55/0x100
[42463.087606]  vfs_write+0x25c/0x450
[42463.090407]  ksys_write+0x6b/0xe0
[42463.093198]  do_syscall_64+0xc0/0x550
[42463.096001]  ? futex_wake+0x10c/0x240
[42463.098794]  ? update_cfs_rq_load_avg+0x29/0x220
[42463.101618]  ? reweight_eevdf+0x97/0x200
[42463.104443]  ? update_cfs_rq_load_avg+0x29/0x220
[42463.107190]  ? __sched_balance_update_blocked_averages+0xcb/0x6b0
[42463.109897]  ? __note_gp_changes+0x188/0x1b0
[42463.112629]  ? note_gp_changes+0x5c/0x70
[42463.115360]  ? rcu_core+0x154/0x350
[42463.118086]  ? handle_softirqs+0xc8/0x260
[42463.120799]  ? irqentry_exit+0x48/0x730
[42463.123485]  ? do_syscall_64+0x35/0x550
[42463.126134]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[42463.128806] RIP: 0033:0x40f1ae
[42463.131464] RSP: 002b:000000c000e74e10 EFLAGS: 00000216 ORIG_RAX: 0000000000000001
[42463.134221] RAX: ffffffffffffffda RBX: 00000000000000b7 RCX: 000000000040f1ae
[42463.136999] RDX: 0000000000000384 RSI: 000000c0005e5c8c RDI: 00000000000000b7
[42463.139770] RBP: 000000c000e74e50 R08: 0000000000000000 R09: 0000000000000000
[42463.142526] R10: 0000000000000000 R11: 0000000000000216 R12: 000000c000e74f80
[42463.145265] R13: fffffffffffffc83 R14: 000000c000e0ba40 R15: 000000000000037d
[42463.147998]  </TASK>
[42463.150729] task:rs:main Q:Reg   state:D stack:0     pid:11099 tgid:11082 ppid:1      task_flags:0x440140 flags:0x00080000
[42463.153637] Call Trace:
[42463.156475]  <TASK>
[42463.159281]  __schedule+0x581/0x10b0
[42463.162095]  schedule+0x28/0xa0
[42463.164894]  schedule_timeout+0xbd/0x100
[42463.167689]  __down_common+0x17c/0x340
[42463.170483]  down+0x52/0x70
[42463.173267]  xfs_buf_lock+0x32/0xd0 [xfs]
[42463.176133]  xfs_buf_find_lock+0x51/0x100 [xfs]
[42463.178977]  xfs_buf_read_map+0x94/0x2b0 [xfs]
[42463.181812]  ? xfs_read_icluster+0x7f/0xd0 [xfs]
[42463.184607]  xfs_trans_read_buf_map+0x12d/0x270 [xfs]
[42463.187337]  ? xfs_read_icluster+0x7f/0xd0 [xfs]
[42463.190087]  xfs_read_icluster+0x7f/0xd0 [xfs]
[42463.192844]  xfs_inode_item_precommit+0x22f/0x2d0 [xfs]
[42463.195637]  __xfs_trans_commit+0xb9/0x300 [xfs]
[42463.198435]  xfs_trans_commit+0x38/0x70 [xfs]
[42463.201224]  xfs_vn_update_time+0x187/0x1b0 [xfs]
[42463.204022]  file_update_time_flags+0x7e/0x130
[42463.206769]  xfs_file_write_checks+0x183/0x2c0 [xfs]
[42463.209572]  xfs_file_buffered_write+0x60/0x2d0 [xfs]
[42463.212359]  ? security_file_permission+0x55/0x100
[42463.215116]  vfs_write+0x25c/0x450
[42463.217850]  ksys_write+0x6b/0xe0
[42463.220559]  do_syscall_64+0xc0/0x550
[42463.223280]  ? do_syscall_64+0xf9/0x550
[42463.226004]  ? do_syscall_64+0xf9/0x550
[42463.228703]  ? do_syscall_64+0x35/0x550
[42463.231359]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[42463.234039] RIP: 0033:0x7f166518272e
[42463.236708] RSP: 002b:00007f1664808738 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
[42463.239453] RAX: ffffffffffffffda RBX: 00007f16648096c0 RCX: 00007f166518272e
[42463.242214] RDX: 000000000000012e RSI: 00007f165c004070 RDI: 0000000000000008
[42463.244993] RBP: 00007f165c004070 R08: 0000000000000000 R09: 0000000000000000
[42463.247772] R10: 0000000000000000 R11: 0000000000000246 R12: 00007f165c003d80
[42463.250550] R13: 0000000000000000 R14: 000056084f87c2f0 R15: 0000560853f89f00
[42463.253332]  </TASK>
[42463.256101] task:congeal         state:D stack:0     pid:11964 tgid:11964 ppid:1      task_flags:0x440100 flags:0x00080000
[42463.259065] Call Trace:
[42463.261960]  <TASK>
[42463.264782]  __schedule+0x581/0x10b0
[42463.267586]  schedule+0x28/0xa0
[42463.270364]  schedule_preempt_disabled+0x16/0x30
[42463.273177]  rwsem_down_write_slowpath+0x2d8/0x750
[42463.276006]  down_write+0x5c/0x60
[42463.278812]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42463.281653]  file_update_time_flags+0x7e/0x130
[42463.284366]  xfs_file_write_checks+0x183/0x2c0 [xfs]
[42463.287041]  xfs_file_buffered_write+0x60/0x2d0 [xfs]
[42463.289739]  ? security_file_permission+0x55/0x100
[42463.292420]  vfs_write+0x25c/0x450
[42463.295102]  ksys_write+0x6b/0xe0
[42463.297778]  do_syscall_64+0xc0/0x550
[42463.300456]  ? restore_fpregs_from_fpstate+0x3c/0xa0
[42463.303177]  ? switch_fpu_return+0x5d/0xe0
[42463.305894]  ? do_syscall_64+0x25a/0x550
[42463.308618]  ? restore_fpregs_from_fpstate+0x3c/0xa0
[42463.311378]  ? switch_fpu_return+0x5d/0xe0
[42463.314119]  ? do_syscall_64+0x25a/0x550
[42463.316843]  ? __x64_sys_recvfrom+0x24/0x30
[42463.319558]  ? do_syscall_64+0xf9/0x550
[42463.322252]  ? do_syscall_64+0x35/0x550
[42463.324903]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[42463.327570] RIP: 0033:0x7f95ab09b3a7
[42463.330221] RSP: 002b:00007ffc79313110 EFLAGS: 00000202 ORIG_RAX: 0000000000000001
[42463.332974] RAX: ffffffffffffffda RBX: 00007f95ab96da00 RCX: 00007f95ab09b3a7
[42463.335754] RDX: 0000000000001000 RSI: 0000563e8334ee60 RDI: 0000000000000004
[42463.338544] RBP: 0000563e8334ee60 R08: 0000000000000000 R09: 0000000000000000
[42463.341336] R10: 0000000000000000 R11: 0000000000000202 R12: 0000000000001000
[42463.344103] R13: 0000563e833477f0 R14: 00007f95ab1efee0 R15: 00000000000003e9
[42463.346861]  </TASK>
[42463.349811] task:kworker/3:1     state:D stack:0     pid:814192 tgid:814192 ppid:2      task_flags:0x4208060 flags:0x00080000
[42463.352793] Workqueue: xfs-sync/dm-44 xfs_log_worker [xfs]
[42463.355839] Call Trace:
[42463.358846]  <TASK>
[42463.361864]  __schedule+0x581/0x10b0
[42463.364882]  schedule+0x28/0xa0
[42463.367869]  raid5_get_active_stripe+0x283/0x5a0 [raid456]
[42463.370870]  ? __pfx_autoremove_wake_function+0x10/0x10
[42463.373842]  raid5_make_request+0x226/0x1520 [raid456]
[42463.376814]  ? bdev_start_io_acct+0x2a/0xa0
[42463.379787]  ? dm_io_acct+0xb9/0xf0 [dm_mod]
[42463.382765]  ? __pfx_woken_wake_function+0x10/0x10
[42463.385762]  md_handle_request+0x22b/0x370 [md_mod]
[42463.388726]  ? bio_split_to_limits+0x145/0x160
[42463.391611]  __submit_bio+0xa1/0x140
[42463.394404]  submit_bio_noacct_nocheck+0x12a/0x350
[42463.397256]  xlog_state_release_iclog+0xe2/0x150 [xfs]
[42463.400186]  xfs_log_force+0x1d6/0x240 [xfs]
[42463.403110]  xfs_log_worker+0x3d/0xc0 [xfs]
[42463.406009]  process_one_work+0x1ca/0x3c0
[42463.408875]  worker_thread+0x1ac/0x320
[42463.411721]  ? __pfx_worker_thread+0x10/0x10
[42463.414570]  kthread+0xe5/0x120
[42463.417396]  ? __pfx_kthread+0x10/0x10
[42463.420222]  ret_from_fork+0x2b7/0x340
[42463.423034]  ? __pfx_kthread+0x10/0x10
[42463.425829]  ret_from_fork_asm+0x1a/0x30
[42463.428611]  </TASK>
[42463.431396] task:cache-main      state:D stack:0     pid:849910 tgid:849910 ppid:13218  task_flags:0x440140 flags:0x00080000
[42463.434402] Call Trace:
[42463.437349]  <TASK>
[42463.440254]  __schedule+0x581/0x10b0
[42463.443181]  schedule+0x28/0xa0
[42463.446076]  schedule_preempt_disabled+0x16/0x30
[42463.448987]  rwsem_down_write_slowpath+0x2d8/0x750
[42463.451911]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42463.454882]  down_write+0x5c/0x60
[42463.457803]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42463.460833]  file_update_time_flags+0x7e/0x130
[42463.463808]  __xfs_write_fault+0x8c/0x260 [xfs]
[42463.466807]  do_page_mkwrite+0x4a/0xa0
[42463.469718]  do_wp_page+0x136/0x1160
[42463.472571]  ? ksys_read+0xcb/0xe0
[42463.475394]  ? do_syscall_64+0xf9/0x550
[42463.478211]  ? do_writev+0xf7/0x110
[42463.481025]  __handle_mm_fault+0xb5a/0x1170
[42463.483849]  ? do_writev+0xf7/0x110
[42463.486615]  ? lock_vma_under_rcu+0x92/0x160
[42463.489307]  handle_mm_fault+0xe3/0x300
[42463.491888]  do_user_addr_fault+0x202/0x690
[42463.494454]  exc_page_fault+0x73/0x150
[42463.497040]  asm_exc_page_fault+0x26/0x30
[42463.499635] RIP: 0033:0x55ab1f9f5816
[42463.502229] RSP: 002b:00007ffdeaf8d990 EFLAGS: 00010213
[42463.504843] RAX: 00007f331bb6a018 RBX: 0000000000000008 RCX: 00007f331adffff8
[42463.507497] RDX: 0000000000000002 RSI: 0000000000000001 RDI: 000055ab1fb0c900
[42463.510131] RBP: 00007f3316d5d114 R08: 0000000000000073 R09: 00000000ffffffff
[42463.512763] R10: 0000000000000000 R11: 0000000000000000 R12: 000055ab1fb0c900
[42463.515397] R13: 0000000000000001 R14: 0000000000000000 R15: 0000000000000800
[42463.518003]  </TASK>
[42463.520571] task:MPL_busyobj     state:D stack:0     pid:849911 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42463.523364] Call Trace:
[42463.526103]  <TASK>
[42463.528808]  __schedule+0x581/0x10b0
[42463.531511]  schedule+0x28/0xa0
[42463.534181]  schedule_timeout+0xbd/0x100
[42463.536866]  __down_common+0x17c/0x340
[42463.539549]  down+0x52/0x70
[42463.542211]  xfs_buf_lock+0x32/0xd0 [xfs]
[42463.544936]  xfs_buf_find_lock+0x51/0x100 [xfs]
[42463.547644]  xfs_buf_read_map+0x94/0x2b0 [xfs]
[42463.550340]  ? xfs_read_icluster+0x7f/0xd0 [xfs]
[42463.553085]  xfs_trans_read_buf_map+0x12d/0x270 [xfs]
[42463.555858]  ? xfs_read_icluster+0x7f/0xd0 [xfs]
[42463.558639]  xfs_read_icluster+0x7f/0xd0 [xfs]
[42463.561420]  xfs_inode_item_precommit+0x22f/0x2d0 [xfs]
[42463.564133]  __xfs_trans_commit+0xb9/0x300 [xfs]
[42463.566758]  xfs_trans_commit+0x38/0x70 [xfs]
[42463.569405]  xfs_vn_update_time+0x187/0x1b0 [xfs]
[42463.572078]  file_update_time_flags+0x7e/0x130
[42463.574718]  __xfs_write_fault+0x8c/0x260 [xfs]
[42463.577405]  do_page_mkwrite+0x4a/0xa0
[42463.580041]  do_wp_page+0x136/0x1160
[42463.582652]  ? finish_task_switch.isra.0+0xc0/0x3d0
[42463.585292]  __handle_mm_fault+0xb5a/0x1170
[42463.587922]  ? lock_vma_under_rcu+0x92/0x160
[42463.590546]  handle_mm_fault+0xe3/0x300
[42463.593164]  do_user_addr_fault+0x202/0x690
[42463.595783]  exc_page_fault+0x73/0x150
[42463.598404]  asm_exc_page_fault+0x26/0x30
[42463.601040] RIP: 0033:0x55ab1f9e2246
[42463.603677] RSP: 002b:00007f3315dfe3d0 EFLAGS: 00010246
[42463.606356] RAX: 00007f331af75018 RBX: 00007f331b024200 RCX: 000000006b074aae
[42463.609102] RDX: 0000000000000001 RSI: 000055ab1fac7ac0 RDI: 00007f331b024208
[42463.611854] RBP: 0000000000000000 R08: 00007f3315dfe3c0 R09: 00007f331bb85000
[42463.614597] R10: 0000000000000000 R11: 0000000001434d8e R12: 00007f331b02c430
[42463.617339] R13: 000000000000000a R14: 000055ab1fac7ac0 R15: 00007f33155ff000
[42463.620071]  </TASK>
[42463.622771] task:pool_poolherder state:D stack:0     pid:849913 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42463.625712] Call Trace:
[42463.628614]  <TASK>
[42463.631478]  __schedule+0x581/0x10b0
[42463.634321]  schedule+0x28/0xa0
[42463.637151]  schedule_preempt_disabled+0x16/0x30
[42463.639997]  rwsem_down_write_slowpath+0x2d8/0x750
[42463.642845]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42463.645764]  down_write+0x5c/0x60
[42463.648584]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42463.651375]  file_update_time_flags+0x7e/0x130
[42463.654038]  __xfs_write_fault+0x8c/0x260 [xfs]
[42463.656770]  do_page_mkwrite+0x4a/0xa0
[42463.659465]  do_wp_page+0x136/0x1160
[42463.662153]  ? do_nanosleep+0x5b/0x190
[42463.664860]  ? hrtimer_nanosleep+0x86/0x100
[42463.667571]  __handle_mm_fault+0xb5a/0x1170
[42463.670279]  ? __pfx_hrtimer_wakeup+0x10/0x10
[42463.673002]  ? lock_vma_under_rcu+0x92/0x160
[42463.675737]  handle_mm_fault+0xe3/0x300
[42463.678462]  do_user_addr_fault+0x202/0x690
[42463.681188]  exc_page_fault+0x73/0x150
[42463.683894]  asm_exc_page_fault+0x26/0x30
[42463.686594] RIP: 0033:0x55ab1f9e97c0
[42463.689279] RSP: 002b:00007f3314b7c3f0 EFLAGS: 00010246
[42463.691974] RAX: 00007f331bb6a018 RBX: 000055ab1fac7d30 RCX: 0000000000000000
[42463.694717] RDX: 0000000000000002 RSI: 0000000000000000 RDI: 00007f331b024528
[42463.697469] RBP: 000055ab1fb0c828 R08: 0000000000000000 R09: 0000000000000000
[42463.700216] R10: 00007f3314b7c3b0 R11: 0000000000000246 R12: 0000000000000002
[42463.702940] R13: 0000000000000000 R14: 0000000000000000 R15: 000055ab1fac7d30
[42463.705672]  </TASK>
[42463.708367] task:MPL_req0        state:D stack:0     pid:850015 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42463.711299] Call Trace:
[42463.714172]  <TASK>
[42463.717005]  __schedule+0x581/0x10b0
[42463.719853]  schedule+0x28/0xa0
[42463.722685]  schedule_timeout+0xbd/0x100
[42463.725517]  __down_common+0x17c/0x340
[42463.728344]  down+0x52/0x70
[42463.731153]  xfs_buf_lock+0x32/0xd0 [xfs]
[42463.734024]  xfs_buf_find_lock+0x51/0x100 [xfs]
[42463.736870]  xfs_buf_read_map+0x94/0x2b0 [xfs]
[42463.739674]  ? xfs_read_icluster+0x7f/0xd0 [xfs]
[42463.742498]  xfs_trans_read_buf_map+0x12d/0x270 [xfs]
[42463.745350]  ? xfs_read_icluster+0x7f/0xd0 [xfs]
[42463.748214]  xfs_read_icluster+0x7f/0xd0 [xfs]
[42463.751080]  xfs_inode_item_precommit+0x22f/0x2d0 [xfs]
[42463.753936]  __xfs_trans_commit+0xb9/0x300 [xfs]
[42463.756697]  xfs_trans_commit+0x38/0x70 [xfs]
[42463.759359]  xfs_vn_update_time+0x187/0x1b0 [xfs]
[42463.762057]  file_update_time_flags+0x7e/0x130
[42463.764728]  __xfs_write_fault+0x8c/0x260 [xfs]
[42463.767451]  do_page_mkwrite+0x4a/0xa0
[42463.770128]  do_wp_page+0x136/0x1160
[42463.772793]  ? do_anonymous_page+0x62c/0x9b0
[42463.775460]  __handle_mm_fault+0xb5a/0x1170
[42463.778118]  ? lock_vma_under_rcu+0x92/0x160
[42463.780777]  handle_mm_fault+0xe3/0x300
[42463.783420]  do_user_addr_fault+0x202/0x690
[42463.786063]  exc_page_fault+0x73/0x150
[42463.788697]  asm_exc_page_fault+0x26/0x30
[42463.791341] RIP: 0033:0x55ab1f9e3acd
[42463.793979] RSP: 002b:00007f3312ca13d0 EFLAGS: 00010206
[42463.796656] RAX: 00007f33062e15c0 RBX: 00007f3313e0f000 RCX: 000000006aef0000
[42463.799403] RDX: 00007f3314202018 RSI: 000000005dcd8000 RDI: 00007f3312ca1c78
[42463.802149] RBP: 0000000000018000 R08: 0000000000000000 R09: 00007f331b20106e
[42463.804903] R10: 00000000ffffff00 R11: 0000000000000017 R12: 00007f331bb7d240
[42463.807646] R13: 0000000000000008 R14: 000055ab1fac7ac0 R15: 00007f33124a2000
[42463.810386]  </TASK>
[42463.813095] task:MPL_sess0       state:D stack:0     pid:850017 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42463.816038] Call Trace:
[42463.818931]  <TASK>
[42463.821794]  __schedule+0x581/0x10b0
[42463.824634]  schedule+0x28/0xa0
[42463.827443]  schedule_preempt_disabled+0x16/0x30
[42463.830270]  rwsem_down_write_slowpath+0x2d8/0x750
[42463.833121]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42463.836017]  down_write+0x5c/0x60
[42463.838810]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42463.841584]  file_update_time_flags+0x7e/0x130
[42463.844237]  __xfs_write_fault+0x8c/0x260 [xfs]
[42463.846952]  do_page_mkwrite+0x4a/0xa0
[42463.849631]  do_wp_page+0x136/0x1160
[42463.852308]  ? __pfx_hrtimer_wakeup+0x10/0x10
[42463.855010]  __handle_mm_fault+0xb5a/0x1170
[42463.857719]  ? switch_fpu_return+0x5d/0xe0
[42463.860431]  ? lock_vma_under_rcu+0x92/0x160
[42463.863146]  handle_mm_fault+0xe3/0x300
[42463.865860]  do_user_addr_fault+0x202/0x690
[42463.868588]  exc_page_fault+0x73/0x150
[42463.871303]  asm_exc_page_fault+0x26/0x30
[42463.874001] RIP: 0033:0x55ab1f9e2246
[42463.876682] RSP: 002b:00007f33124a03d0 EFLAGS: 00010246
[42463.879384] RAX: 00007f331af75018 RBX: 00007f3313e07140 RCX: 000000006b074aae
[42463.882138] RDX: 0000000000000001 RSI: 000055ab1fac7ac0 RDI: 00007f3313e07148
[42463.884894] RBP: 0000000000000000 R08: 00007f33124a03c0 R09: 00007f331bb85000
[42463.887633] R10: 0000000000000000 R11: 0000000001434dc0 R12: 00007f3313e0f0b0
[42463.890355] R13: 000000000000000d R14: 000055ab1fac7ac0 R15: 00007f3311ca1000
[42463.893063]  </TASK>
[42463.895737] task:cache-epoll     state:D stack:0     pid:850018 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42463.898637] Call Trace:
[42463.901500]  <TASK>
[42463.904332]  __schedule+0x581/0x10b0
[42463.907179]  schedule+0x28/0xa0
[42463.910003]  schedule_preempt_disabled+0x16/0x30
[42463.912854]  rwsem_down_write_slowpath+0x2d8/0x750
[42463.915714]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42463.918611]  down_write+0x5c/0x60
[42463.921462]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42463.924383]  file_update_time_flags+0x7e/0x130
[42463.927266]  ? rb_erase_linked+0x39/0x70
[42463.930101]  __xfs_write_fault+0x8c/0x260 [xfs]
[42463.932983]  do_page_mkwrite+0x4a/0xa0
[42463.935825]  do_wp_page+0x136/0x1160
[42463.938652]  ? ep_send_events+0x1ab/0x240
[42463.941485]  __handle_mm_fault+0xb5a/0x1170
[42463.944277]  ? lock_vma_under_rcu+0x92/0x160
[42463.946979]  handle_mm_fault+0xe3/0x300
[42463.949585]  do_user_addr_fault+0x202/0x690
[42463.952220]  exc_page_fault+0x73/0x150
[42463.954855]  asm_exc_page_fault+0x26/0x30
[42463.957504] RIP: 0033:0x55ab1f9e1e6d
[42463.960148] RSP: 002b:00007f3311c9f3c0 EFLAGS: 00010206
[42463.962817] RAX: 00007f331af69018 RBX: 00007f3313e07370 RCX: 0000000000000000
[42463.965549] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f3313e07378
[42463.968282] RBP: 0000000000000000 R08: 00007f3311c9f3b0 R09: 00007f331bb85000
[42463.971001] R10: 0000000000000000 R11: 0000000001434e60 R12: 0000000000000016
[42463.973713] R13: 00007f3313e0f178 R14: 00007f3313e0f100 R15: 00007f33108004cc
[42463.976433]  </TASK>
[42463.979116] task:cache-worker    state:D stack:0     pid:850058 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42463.982039] Call Trace:
[42463.984919]  <TASK>
[42463.987761]  __schedule+0x581/0x10b0
[42463.990618]  schedule+0x28/0xa0
[42463.993467]  schedule_preempt_disabled+0x16/0x30
[42463.996334]  rwsem_down_write_slowpath+0x2d8/0x750
[42463.999213]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42464.002128]  down_write+0x5c/0x60
[42464.005005]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42464.007949]  file_update_time_flags+0x7e/0x130
[42464.010852]  __xfs_write_fault+0x8c/0x260 [xfs]
[42464.013763]  do_page_mkwrite+0x4a/0xa0
[42464.016617]  do_wp_page+0x136/0x1160
[42464.019466]  __handle_mm_fault+0xb5a/0x1170
[42464.022335]  ? lock_vma_under_rcu+0x92/0x160
[42464.025222]  handle_mm_fault+0xe3/0x300
[42464.028056]  do_user_addr_fault+0x202/0x690
[42464.030799]  exc_page_fault+0x73/0x150
[42464.033451]  asm_exc_page_fault+0x26/0x30
[42464.036124] RIP: 0033:0x55ab1f9e1e6d
[42464.038796] RSP: 002b:00007f3310172550 EFLAGS: 00010206
[42464.041511] RAX: 00007f331af70018 RBX: 00007f32aa407470 RCX: 0000000000000000
[42464.044295] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f32aa407478
[42464.047081] RBP: 0000000000000000 R08: 00007f3310172540 R09: 00007f331bb85000
[42464.049861] R10: 0000000000000000 R11: 0000000001434d8c R12: 0000000000000016
[42464.052636] R13: 0000000000000000 R14: 000055ab1facbd20 R15: 00007f3310173340
[42464.055396]  </TASK>
[42464.058112] task:cache-worker    state:D stack:0     pid:850060 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42464.061065] Call Trace:
[42464.063976]  <TASK>
[42464.066847]  __schedule+0x581/0x10b0
[42464.069749]  schedule+0x28/0xa0
[42464.072636]  schedule_preempt_disabled+0x16/0x30
[42464.075543]  rwsem_down_write_slowpath+0x2d8/0x750
[42464.078453]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42464.081413]  down_write+0x5c/0x60
[42464.084319]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42464.087286]  file_update_time_flags+0x7e/0x130
[42464.090223]  __xfs_write_fault+0x8c/0x260 [xfs]
[42464.093201]  do_page_mkwrite+0x4a/0xa0
[42464.096128]  do_wp_page+0x136/0x1160
[42464.099004]  ? do_syscall_64+0x25a/0x550
[42464.101874]  __handle_mm_fault+0xb5a/0x1170
[42464.104753]  ? lock_vma_under_rcu+0x92/0x160
[42464.107638]  handle_mm_fault+0xe3/0x300
[42464.110503]  do_user_addr_fault+0x202/0x690
[42464.113334]  exc_page_fault+0x73/0x150
[42464.116063]  asm_exc_page_fault+0x26/0x30
[42464.118696] RIP: 0033:0x55ab1f9e1e6d
[42464.121352] RSP: 002b:00007f3310148550 EFLAGS: 00010206
[42464.124047] RAX: 00007f331af70018 RBX: 00007f31256082b0 RCX: 0000000000000000
[42464.126813] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f31256082b8
[42464.129600] RBP: 0000000000000000 R08: 00007f3310148540 R09: 00007f331bb85000
[42464.132379] R10: 0000000000000000 R11: 0000000001434ddc R12: 0000000000000016
[42464.135148] R13: 0000000000000000 R14: 000055ab1facbd20 R15: 00007f3310149340
[42464.137897]  </TASK>
[42464.140612] task:cache-exp       state:D stack:0     pid:850120 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42464.143547] Call Trace:
[42464.146428]  <TASK>
[42464.149279]  __schedule+0x581/0x10b0
[42464.152153]  schedule+0x28/0xa0
[42464.155009]  schedule_timeout+0xbd/0x100
[42464.157862]  __down_common+0x17c/0x340
[42464.160711]  down+0x52/0x70
[42464.163541]  xfs_buf_lock+0x32/0xd0 [xfs]
[42464.166429]  xfs_buf_find_lock+0x51/0x100 [xfs]
[42464.169305]  xfs_buf_read_map+0x94/0x2b0 [xfs]
[42464.172171]  ? xfs_read_icluster+0x7f/0xd0 [xfs]
[42464.175068]  xfs_trans_read_buf_map+0x12d/0x270 [xfs]
[42464.177950]  ? xfs_read_icluster+0x7f/0xd0 [xfs]
[42464.180819]  xfs_read_icluster+0x7f/0xd0 [xfs]
[42464.183689]  xfs_inode_item_precommit+0x22f/0x2d0 [xfs]
[42464.186584]  __xfs_trans_commit+0xb9/0x300 [xfs]
[42464.189489]  xfs_trans_commit+0x38/0x70 [xfs]
[42464.192345]  xfs_vn_update_time+0x187/0x1b0 [xfs]
[42464.195125]  file_update_time_flags+0x7e/0x130
[42464.197768]  __xfs_write_fault+0x8c/0x260 [xfs]
[42464.200481]  do_page_mkwrite+0x4a/0xa0
[42464.203157]  do_wp_page+0x136/0x1160
[42464.205828]  __handle_mm_fault+0xb5a/0x1170
[42464.208515]  ? lock_vma_under_rcu+0x92/0x160
[42464.211200]  handle_mm_fault+0xe3/0x300
[42464.213867]  do_user_addr_fault+0x202/0x690
[42464.216537]  exc_page_fault+0x73/0x150
[42464.219194]  asm_exc_page_fault+0x26/0x30
[42464.221838] RIP: 0033:0x55ab1f9d0087
[42464.224478] RSP: 002b:00007f330fc5d0d0 EFLAGS: 00010203
[42464.227143] RAX: 00007f331bb6a018 RBX: 000055ab1fac6e30 RCX: 0000000000000001
[42464.229882] RDX: 0000000000000170 RSI: 000055ab1fac6df0 RDI: 00007f331b03f648
[42464.232631] RBP: 41dac1d2abad2757 R08: 0000000000000000 R09: 00007f331bb85000
[42464.235390] R10: 0000000000000000 R11: 0000000001434df4 R12: 00007f325860b240
[42464.238155] R13: 0000000000000000 R14: 00007f331b03f640 R15: 00007f331b03f648
[42464.240918]  </TASK>
[42464.243651] task:ban-lurker      state:D stack:0     pid:850122 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42464.246612] Call Trace:
[42464.249531]  <TASK>
[42464.252419]  __schedule+0x581/0x10b0
[42464.255319]  schedule+0x28/0xa0
[42464.258160]  schedule_timeout+0xbd/0x100
[42464.260992]  __down_common+0x17c/0x340
[42464.263823]  down+0x52/0x70
[42464.266629]  xfs_buf_lock+0x32/0xd0 [xfs]
[42464.269503]  xfs_buf_find_lock+0x51/0x100 [xfs]
[42464.272316]  xfs_buf_read_map+0x94/0x2b0 [xfs]
[42464.275024]  ? xfs_read_icluster+0x7f/0xd0 [xfs]
[42464.277679]  xfs_trans_read_buf_map+0x12d/0x270 [xfs]
[42464.280378]  ? xfs_read_icluster+0x7f/0xd0 [xfs]
[42464.283084]  xfs_read_icluster+0x7f/0xd0 [xfs]
[42464.285801]  xfs_inode_item_precommit+0x22f/0x2d0 [xfs]
[42464.288559]  __xfs_trans_commit+0xb9/0x300 [xfs]
[42464.291324]  xfs_trans_commit+0x38/0x70 [xfs]
[42464.294090]  xfs_vn_update_time+0x187/0x1b0 [xfs]
[42464.296881]  file_update_time_flags+0x7e/0x130
[42464.299640]  __xfs_write_fault+0x8c/0x260 [xfs]
[42464.302450]  do_page_mkwrite+0x4a/0xa0
[42464.305204]  do_wp_page+0x136/0x1160
[42464.307933]  ? do_futex+0x10c/0x210
[42464.310626]  ? __x64_sys_futex+0x126/0x1e0
[42464.313320]  __handle_mm_fault+0xb5a/0x1170
[42464.315997]  ? lock_vma_under_rcu+0x92/0x160
[42464.318660]  handle_mm_fault+0xe3/0x300
[42464.321311]  do_user_addr_fault+0x202/0x690
[42464.323962]  exc_page_fault+0x73/0x150
[42464.326598]  asm_exc_page_fault+0x26/0x30
[42464.329237] RIP: 0033:0x55ab1f9e2246
[42464.331858] RSP: 002b:00007f330e7fe030 EFLAGS: 00010246
[42464.334518] RAX: 00007f331af74018 RBX: 00007f324f20a230 RCX: 0000000000000000
[42464.337245] RDX: 0000000000000001 RSI: 000055ab1fac66c0 RDI: 00007f324f20a238
[42464.339981] RBP: 0000000000000000 R08: 00007f330e7fe020 R09: 00007f331bb85000
[42464.342714] R10: 0000000000000000 R11: 0000000000000000 R12: 00007f324b600820
[42464.345440] R13: 0000000000000000 R14: 00007f324f203a88 R15: 000055ab1fac66c0
[42464.348164]  </TASK>
[42464.350861] task:MPL_req1        state:D stack:0     pid:850123 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42464.353788] Call Trace:
[42464.356660]  <TASK>
[42464.359463]  __schedule+0x581/0x10b0
[42464.362277]  schedule+0x28/0xa0
[42464.365065]  schedule_timeout+0xbd/0x100
[42464.367838]  __down_common+0x17c/0x340
[42464.370612]  down+0x52/0x70
[42464.373323]  xfs_buf_lock+0x32/0xd0 [xfs]
[42464.376002]  xfs_buf_find_lock+0x51/0x100 [xfs]
[42464.378573]  xfs_buf_read_map+0x94/0x2b0 [xfs]
[42464.381158]  ? xfs_read_icluster+0x7f/0xd0 [xfs]
[42464.383787]  xfs_trans_read_buf_map+0x12d/0x270 [xfs]
[42464.386447]  ? xfs_read_icluster+0x7f/0xd0 [xfs]
[42464.389121]  xfs_read_icluster+0x7f/0xd0 [xfs]
[42464.391797]  xfs_inode_item_precommit+0x22f/0x2d0 [xfs]
[42464.394503]  __xfs_trans_commit+0xb9/0x300 [xfs]
[42464.397221]  xfs_trans_commit+0x38/0x70 [xfs]
[42464.399946]  xfs_vn_update_time+0x187/0x1b0 [xfs]
[42464.402692]  file_update_time_flags+0x7e/0x130
[42464.405396]  __xfs_write_fault+0x8c/0x260 [xfs]
[42464.408129]  do_page_mkwrite+0x4a/0xa0
[42464.410797]  do_wp_page+0x136/0x1160
[42464.413453]  ? do_anonymous_page+0x62c/0x9b0
[42464.416109]  ? hrtimer_nanosleep+0x86/0x100
[42464.418741]  __handle_mm_fault+0xb5a/0x1170
[42464.421362]  ? __pfx_hrtimer_wakeup+0x10/0x10
[42464.423988]  ? lock_vma_under_rcu+0x92/0x160
[42464.426602]  handle_mm_fault+0xe3/0x300
[42464.429210]  do_user_addr_fault+0x202/0x690
[42464.431815]  exc_page_fault+0x73/0x150
[42464.434421]  asm_exc_page_fault+0x26/0x30
[42464.437049] RIP: 0033:0x55ab1f9e3acd
[42464.439671] RSP: 002b:00007f330d9fe3d0 EFLAGS: 00010206
[42464.442332] RAX: 00007f33043dbac0 RBX: 00007f3313e0f200 RCX: 000000006c108000
[42464.445061] RDX: 00007f3310c00018 RSI: 000000005e548000 RDI: 00007f330d9fec78
[42464.447802] RBP: 0000000000018000 R08: 0000000000000000 R09: 00007f331b201066
[42464.450537] R10: 00000000fffffe00 R11: 0000000000000013 R12: 00007f331bb7d240
[42464.453265] R13: 0000000000000009 R14: 000055ab1fac7ac0 R15: 00007f330d1ff000
[42464.455995]  </TASK>
[42464.458692] task:MPL_sess1       state:D stack:0     pid:850124 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42464.461614] Call Trace:
[42464.464455]  <TASK>
[42464.467255]  __schedule+0x581/0x10b0
[42464.470068]  schedule+0x28/0xa0
[42464.472875]  schedule_preempt_disabled+0x16/0x30
[42464.475705]  rwsem_down_write_slowpath+0x2d8/0x750
[42464.478496]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42464.481249]  down_write+0x5c/0x60
[42464.483859]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42464.486555]  file_update_time_flags+0x7e/0x130
[42464.489230]  __xfs_write_fault+0x8c/0x260 [xfs]
[42464.491954]  do_page_mkwrite+0x4a/0xa0
[42464.494644]  do_wp_page+0x136/0x1160
[42464.497326]  ? do_syscall_64+0x25a/0x550
[42464.500015]  ? __pfx_hrtimer_wakeup+0x10/0x10
[42464.502713]  __handle_mm_fault+0xb5a/0x1170
[42464.505424]  ? lock_vma_under_rcu+0x92/0x160
[42464.508147]  handle_mm_fault+0xe3/0x300
[42464.510848]  do_user_addr_fault+0x202/0x690
[42464.513544]  exc_page_fault+0x73/0x150
[42464.516220]  asm_exc_page_fault+0x26/0x30
[42464.518886] RIP: 0033:0x55ab1f9e2246
[42464.521538] RSP: 002b:00007f330d1fd3d0 EFLAGS: 00010246
[42464.524204] RAX: 00007f331af75018 RBX: 00007f3313e075f0 RCX: 000000006b074aaf
[42464.526925] RDX: 0000000000000001 RSI: 000055ab1fac7ac0 RDI: 00007f3313e075f8
[42464.529661] RBP: 0000000000000000 R08: 00007f330d1fd3c0 R09: 00007f331bb85000
[42464.532377] R10: 0000000000000000 R11: 0000000001435028 R12: 00007f3313e0f2b0
[42464.535084] R13: 000000000000000a R14: 000055ab1fac7ac0 R15: 00007f330c9fe000
[42464.537785]  </TASK>
[42464.540459] task:cache-epoll     state:D stack:0     pid:850125 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42464.543366] Call Trace:
[42464.546231]  <TASK>
[42464.549069]  __schedule+0x581/0x10b0
[42464.551919]  schedule+0x28/0xa0
[42464.554747]  schedule_timeout+0xbd/0x100
[42464.557580]  __down_common+0x17c/0x340
[42464.560408]  down+0x52/0x70
[42464.563215]  xfs_buf_lock+0x32/0xd0 [xfs]
[42464.566091]  xfs_buf_find_lock+0x51/0x100 [xfs]
[42464.568946]  xfs_buf_read_map+0x94/0x2b0 [xfs]
[42464.571783]  ? xfs_read_icluster+0x7f/0xd0 [xfs]
[42464.574621]  xfs_trans_read_buf_map+0x12d/0x270 [xfs]
[42464.577469]  ? xfs_read_icluster+0x7f/0xd0 [xfs]
[42464.580319]  xfs_read_icluster+0x7f/0xd0 [xfs]
[42464.583177]  xfs_inode_item_precommit+0x22f/0x2d0 [xfs]
[42464.586061]  __xfs_trans_commit+0xb9/0x300 [xfs]
[42464.588907]  xfs_trans_commit+0x38/0x70 [xfs]
[42464.591662]  xfs_vn_update_time+0x187/0x1b0 [xfs]
[42464.594341]  file_update_time_flags+0x7e/0x130
[42464.597008]  __xfs_write_fault+0x8c/0x260 [xfs]
[42464.599730]  do_page_mkwrite+0x4a/0xa0
[42464.602408]  do_wp_page+0x136/0x1160
[42464.605083]  ? __pfx_ep_autoremove_wake_function+0x10/0x10
[42464.607805]  __handle_mm_fault+0xb5a/0x1170
[42464.610516]  ? switch_fpu_return+0x5d/0xe0
[42464.613221]  ? lock_vma_under_rcu+0x92/0x160
[42464.615920]  handle_mm_fault+0xe3/0x300
[42464.618599]  do_user_addr_fault+0x202/0x690
[42464.621284]  exc_page_fault+0x73/0x150
[42464.623957]  asm_exc_page_fault+0x26/0x30
[42464.626639] RIP: 0033:0x55ab1f9e1e6d
[42464.629321] RSP: 002b:00007f330c9fc3c0 EFLAGS: 00010206
[42464.632030] RAX: 00007f331af69018 RBX: 00007f3313e07780 RCX: 0000000000000000
[42464.634802] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f3313e07788
[42464.637588] RBP: 0000000000000000 R08: 00007f330c9fc3b0 R09: 00007f331bb85000
[42464.640367] R10: 0000000000000000 R11: 0000000001434d60 R12: 0000000000000016
[42464.643147] R13: 00007f3313e0f378 R14: 00007f3313e0f300 R15: 00007f330bc00fcc
[42464.645931]  </TASK>
[42464.648692] task:cache-acceptor  state:D stack:0     pid:850126 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42464.651693] Call Trace:
[42464.654642]  <TASK>
[42464.657521]  __schedule+0x581/0x10b0
[42464.660406]  schedule+0x28/0xa0
[42464.663280]  schedule_preempt_disabled+0x16/0x30
[42464.666179]  rwsem_down_write_slowpath+0x2d8/0x750
[42464.669099]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42464.672019]  down_write+0x5c/0x60
[42464.674784]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42464.677529]  file_update_time_flags+0x7e/0x130
[42464.680265]  __xfs_write_fault+0x8c/0x260 [xfs]
[42464.683049]  do_page_mkwrite+0x4a/0xa0
[42464.685798]  do_wp_page+0x136/0x1160
[42464.688548]  ? hrtimer_nanosleep+0x86/0x100
[42464.691311]  __handle_mm_fault+0xb5a/0x1170
[42464.694073]  ? restore_fpregs_from_fpstate+0x3c/0xa0
[42464.696867]  ? switch_fpu_return+0x5d/0xe0
[42464.699670]  ? lock_vma_under_rcu+0x92/0x160
[42464.702473]  handle_mm_fault+0xe3/0x300
[42464.705264]  do_user_addr_fault+0x202/0x690
[42464.708045]  exc_page_fault+0x73/0x150
[42464.710805]  asm_exc_page_fault+0x26/0x30
[42464.713560] RIP: 0033:0x55ab1f9b316f
[42464.716298] RSP: 002b:00007f330bbfe410 EFLAGS: 00010203
[42464.719048] RAX: 00007f331bb6a018 RBX: 00007f330bbfe430 RCX: 000000006b074aae
[42464.721858] RDX: 0000000000002f92 RSI: 0000000000df2df4 RDI: 7fffffffffffffff
[42464.724681] RBP: 000055ab1fb0bba0 R08: 00007f330bbfe3e0 R09: 00007f331bb85000
[42464.727514] R10: 0000000000000000 R11: 0000000001434e7a R12: 0000000000000021
[42464.730357] R13: 0000000000000000 R14: 41dac1c6c70fdb43 R15: 00007f330b3ff000
[42464.733202]  </TASK>
[42464.736023] task:cache-worker    state:D stack:0     pid:852866 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42464.739053] Call Trace:
[42464.742019]  <TASK>
[42464.744952]  __schedule+0x581/0x10b0
[42464.747906]  schedule+0x28/0xa0
[42464.750843]  schedule_preempt_disabled+0x16/0x30
[42464.753803]  rwsem_down_write_slowpath+0x2d8/0x750
[42464.756766]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42464.759779]  down_write+0x5c/0x60
[42464.762735]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42464.765751]  file_update_time_flags+0x7e/0x130
[42464.768703]  __xfs_write_fault+0x8c/0x260 [xfs]
[42464.771680]  do_page_mkwrite+0x4a/0xa0
[42464.774614]  do_wp_page+0x136/0x1160
[42464.777539]  ? __x64_sys_ioctl+0xb0/0xe0
[42464.780460]  __handle_mm_fault+0xb5a/0x1170
[42464.783335]  ? switch_fpu_return+0x5d/0xe0
[42464.786109]  ? lock_vma_under_rcu+0x92/0x160
[42464.788791]  handle_mm_fault+0xe3/0x300
[42464.791490]  do_user_addr_fault+0x202/0x690
[42464.794199]  exc_page_fault+0x73/0x150
[42464.796918]  asm_exc_page_fault+0x26/0x30
[42464.799638] RIP: 0033:0x55ab1f9e1e6d
[42464.802338] RSP: 002b:00007f329ff3e550 EFLAGS: 00010206
[42464.805065] RAX: 00007f331af70018 RBX: 00007f33016109b0 RCX: 0000000000000000
[42464.807848] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f33016109b8
[42464.810631] RBP: 0000000000000000 R08: 00007f329ff3e540 R09: 00007f331bb85000
[42464.813406] R10: 0000000000000000 R11: 0000000001434dc8 R12: 0000000000000016
[42464.816176] R13: 0000000000000000 R14: 000055ab1facbd20 R15: 00007f329ff3f340
[42464.818935]  </TASK>
[42464.821681] task:cache-worker    state:D stack:0     pid:853811 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42464.824656] Call Trace:
[42464.827589]  <TASK>
[42464.830475]  __schedule+0x581/0x10b0
[42464.833373]  schedule+0x28/0xa0
[42464.836254]  schedule_preempt_disabled+0x16/0x30
[42464.839157]  rwsem_down_write_slowpath+0x2d8/0x750
[42464.842065]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42464.845020]  down_write+0x5c/0x60
[42464.847926]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42464.850894]  file_update_time_flags+0x7e/0x130
[42464.853828]  __xfs_write_fault+0x8c/0x260 [xfs]
[42464.856768]  do_page_mkwrite+0x4a/0xa0
[42464.859643]  do_wp_page+0x136/0x1160
[42464.862484]  __handle_mm_fault+0xb5a/0x1170
[42464.865326]  ? lock_vma_under_rcu+0x92/0x160
[42464.868171]  handle_mm_fault+0xe3/0x300
[42464.870959]  do_user_addr_fault+0x202/0x690
[42464.873660]  exc_page_fault+0x73/0x150
[42464.876268]  asm_exc_page_fault+0x26/0x30
[42464.878894] RIP: 0033:0x55ab1f9e1e6d
[42464.881525] RSP: 002b:00007f3242eab550 EFLAGS: 00010206
[42464.884198] RAX: 00007f331af70018 RBX: 00007f316da08f80 RCX: 0000000000000000
[42464.886938] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f316da08f88
[42464.889687] RBP: 0000000000000000 R08: 00007f3242eab540 R09: 00007f331bb85000
[42464.892425] R10: 0000000000000000 R11: 0000000001434d68 R12: 0000000000000016
[42464.895160] R13: 0000000000000000 R14: 000055ab1facbd20 R15: 00007f3242eac340
[42464.897879]  </TASK>
[42464.900565] task:cache-worker    state:D stack:0     pid:857792 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42464.903486] Call Trace:
[42464.906353]  <TASK>
[42464.909204]  __schedule+0x581/0x10b0
[42464.912074]  schedule+0x28/0xa0
[42464.914928]  schedule_preempt_disabled+0x16/0x30
[42464.917805]  rwsem_down_write_slowpath+0x2d8/0x750
[42464.920693]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42464.923625]  down_write+0x5c/0x60
[42464.926505]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42464.929449]  file_update_time_flags+0x7e/0x130
[42464.932369]  __xfs_write_fault+0x8c/0x260 [xfs]
[42464.935327]  do_page_mkwrite+0x4a/0xa0
[42464.938234]  do_wp_page+0x136/0x1160
[42464.941098]  ? do_vfs_ioctl+0x475/0x940
[42464.943953]  ? do_vfs_ioctl+0x475/0x940
[42464.946769]  __handle_mm_fault+0xb5a/0x1170
[42464.949595]  ? lock_vma_under_rcu+0x92/0x160
[42464.952432]  handle_mm_fault+0xe3/0x300
[42464.955218]  do_user_addr_fault+0x202/0x690
[42464.957906]  exc_page_fault+0x73/0x150
[42464.960500]  asm_exc_page_fault+0x26/0x30
[42464.963117] RIP: 0033:0x55ab1f9e1e6d
[42464.965732] RSP: 002b:00007f321d455550 EFLAGS: 00010206
[42464.968392] RAX: 00007f331af70018 RBX: 00007f325c613ca0 RCX: 0000000000000000
[42464.971119] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f325c613ca8
[42464.973852] RBP: 0000000000000000 R08: 00007f321d455540 R09: 00007f331bb85000
[42464.976577] R10: 0000000000000000 R11: 0000000001434dbc R12: 0000000000000016
[42464.979294] R13: 0000000000000000 R14: 000055ab1facbd20 R15: 00007f321d456340
[42464.982000]  </TASK>
[42464.984669] task:cache-worker    state:D stack:0     pid:857859 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42464.987572] Call Trace:
[42464.990423]  <TASK>
[42464.993258]  __schedule+0x581/0x10b0
[42464.996106]  schedule+0x28/0xa0
[42464.998932]  schedule_preempt_disabled+0x16/0x30
[42465.001788]  rwsem_down_write_slowpath+0x2d8/0x750
[42465.004653]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42465.007559]  down_write+0x5c/0x60
[42465.010415]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42465.013338]  file_update_time_flags+0x7e/0x130
[42465.016226]  __xfs_write_fault+0x8c/0x260 [xfs]
[42465.019116]  do_page_mkwrite+0x4a/0xa0
[42465.021949]  do_wp_page+0x136/0x1160
[42465.024776]  __handle_mm_fault+0xb5a/0x1170
[42465.027614]  ? lock_vma_under_rcu+0x92/0x160
[42465.030453]  handle_mm_fault+0xe3/0x300
[42465.033244]  do_user_addr_fault+0x202/0x690
[42465.035942]  exc_page_fault+0x73/0x150
[42465.038537]  asm_exc_page_fault+0x26/0x30
[42465.041159] RIP: 0033:0x55ab1f9e1e6d
[42465.043783] RSP: 002b:00007f31ba2be550 EFLAGS: 00010206
[42465.046447] RAX: 00007f331af70018 RBX: 00007f3292a6d680 RCX: 0000000000000000
[42465.049184] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f3292a6d688
[42465.051929] RBP: 0000000000000000 R08: 00007f31ba2be540 R09: 00007f331bb85000
[42465.054658] R10: 0000000000000000 R11: 0000000001434d32 R12: 0000000000000016
[42465.057387] R13: 0000000000000000 R14: 000055ab1facbd20 R15: 00007f31ba2bf340
[42465.060105]  </TASK>
[42465.062782] task:cache-worker    state:D stack:0     pid:857862 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42465.065695] Call Trace:
[42465.068558]  <TASK>
[42465.071403]  __schedule+0x581/0x10b0
[42465.074264]  schedule+0x28/0xa0
[42465.077151]  schedule_preempt_disabled+0x16/0x30
[42465.080059]  rwsem_down_write_slowpath+0x2d8/0x750
[42465.082969]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42465.085924]  down_write+0x5c/0x60
[42465.088828]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42465.091793]  file_update_time_flags+0x7e/0x130
[42465.094731]  __xfs_write_fault+0x8c/0x260 [xfs]
[42465.097710]  do_page_mkwrite+0x4a/0xa0
[42465.100638]  do_wp_page+0x136/0x1160
[42465.103523]  __handle_mm_fault+0xb5a/0x1170
[42465.106402]  ? lock_vma_under_rcu+0x92/0x160
[42465.109288]  handle_mm_fault+0xe3/0x300
[42465.112168]  do_user_addr_fault+0x202/0x690
[42465.115052]  exc_page_fault+0x73/0x150
[42465.117888]  asm_exc_page_fault+0x26/0x30
[42465.120628] RIP: 0033:0x55ab1f9e1e6d
[42465.123269] RSP: 002b:00007f31ba27f550 EFLAGS: 00010206
[42465.125962] RAX: 00007f331af70018 RBX: 00007f3247c0a8c0 RCX: 0000000000000000
[42465.128733] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f3247c0a8c8
[42465.131523] RBP: 0000000000000000 R08: 00007f31ba27f540 R09: 00007f331bb85000
[42465.134309] R10: 0000000000000000 R11: 0000000001434d1a R12: 0000000000000016
[42465.137090] R13: 0000000000000000 R14: 000055ab1facbd20 R15: 00007f31ba280340
[42465.139857]  </TASK>
[42465.142591] task:cache-worker    state:D stack:0     pid:976826 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42465.145548] Call Trace:
[42465.148449]  <TASK>
[42465.151319]  __schedule+0x581/0x10b0
[42465.154199]  schedule+0x28/0xa0
[42465.157073]  schedule_preempt_disabled+0x16/0x30
[42465.159966]  rwsem_down_write_slowpath+0x2d8/0x750
[42465.162865]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42465.165803]  down_write+0x5c/0x60
[42465.168694]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42465.171646]  file_update_time_flags+0x7e/0x130
[42465.174571]  __xfs_write_fault+0x8c/0x260 [xfs]
[42465.177535]  do_page_mkwrite+0x4a/0xa0
[42465.180454]  do_wp_page+0x136/0x1160
[42465.183321]  __handle_mm_fault+0xb5a/0x1170
[42465.186182]  ? lock_vma_under_rcu+0x92/0x160
[42465.189052]  handle_mm_fault+0xe3/0x300
[42465.191913]  do_user_addr_fault+0x202/0x690
[42465.194779]  exc_page_fault+0x73/0x150
[42465.197598]  asm_exc_page_fault+0x26/0x30
[42465.200327] RIP: 0033:0x55ab1f9e1e6d
[42465.202952] RSP: 002b:00007f321d440550 EFLAGS: 00010206
[42465.205635] RAX: 00007f331af70018 RBX: 00007f316a22a5e0 RCX: 0000000000000000
[42465.208389] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f316a22a5e8
[42465.211171] RBP: 0000000000000000 R08: 00007f321d440540 R09: 00007f331bb85000
[42465.213945] R10: 0000000000000000 R11: 0000000001434d26 R12: 0000000000000016
[42465.216719] R13: 0000000000000000 R14: 000055ab1facbd20 R15: 00007f321d441340
[42465.219483]  </TASK>
[42465.222206] task:cache-worker    state:D stack:0     pid:979586 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42465.225158] Call Trace:
[42465.228056]  <TASK>
[42465.230921]  __schedule+0x581/0x10b0
[42465.233802]  schedule+0x28/0xa0
[42465.236672]  schedule_preempt_disabled+0x16/0x30
[42465.239561]  rwsem_down_write_slowpath+0x2d8/0x750
[42465.242453]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42465.245390]  down_write+0x5c/0x60
[42465.248281]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42465.251238]  file_update_time_flags+0x7e/0x130
[42465.254164]  __xfs_write_fault+0x8c/0x260 [xfs]
[42465.257129]  do_page_mkwrite+0x4a/0xa0
[42465.260045]  do_wp_page+0x136/0x1160
[42465.262911]  ? do_syscall_64+0x25a/0x550
[42465.265772]  __handle_mm_fault+0xb5a/0x1170
[42465.268640]  ? lock_vma_under_rcu+0x92/0x160
[42465.271511]  handle_mm_fault+0xe3/0x300
[42465.274377]  do_user_addr_fault+0x202/0x690
[42465.277206]  exc_page_fault+0x73/0x150
[42465.279934]  asm_exc_page_fault+0x26/0x30
[42465.282568] RIP: 0033:0x55ab1f9e1e6d
[42465.285224] RSP: 002b:00007f317b416550 EFLAGS: 00010206
[42465.287917] RAX: 00007f331af70018 RBX: 00007f325ae12e90 RCX: 0000000000000000
[42465.290686] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f325ae12e98
[42465.293476] RBP: 0000000000000000 R08: 00007f317b416540 R09: 00007f331bb85000
[42465.296253] R10: 0000000000000000 R11: 0000000001434d24 R12: 0000000000000016
[42465.299020] R13: 0000000000000000 R14: 000055ab1facbd20 R15: 00007f317b417340
[42465.301781]  </TASK>
[42465.304507] task:cache-worker    state:D stack:0     pid:979649 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42465.307457] Call Trace:
[42465.310356]  <TASK>
[42465.313224]  __schedule+0x581/0x10b0
[42465.316115]  schedule+0x28/0xa0
[42465.318986]  schedule_preempt_disabled+0x16/0x30
[42465.321879]  rwsem_down_write_slowpath+0x2d8/0x750
[42465.324784]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42465.327732]  down_write+0x5c/0x60
[42465.330625]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42465.333610]  file_update_time_flags+0x7e/0x130
[42465.336541]  __xfs_write_fault+0x8c/0x260 [xfs]
[42465.339508]  do_page_mkwrite+0x4a/0xa0
[42465.342386]  do_wp_page+0x136/0x1160
[42465.345244]  __handle_mm_fault+0xb5a/0x1170
[42465.348116]  ? lock_vma_under_rcu+0x92/0x160
[42465.350988]  handle_mm_fault+0xe3/0x300
[42465.353859]  do_user_addr_fault+0x202/0x690
[42465.356692]  exc_page_fault+0x73/0x150
[42465.359423]  asm_exc_page_fault+0x26/0x30
[42465.362058] RIP: 0033:0x55ab1f9e1e6d
[42465.364719] RSP: 002b:00007f31b8ed3550 EFLAGS: 00010206
[42465.367417] RAX: 00007f331af70018 RBX: 00007f3119e0a5f0 RCX: 0000000000000000
[42465.370184] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f3119e0a5f8
[42465.372972] RBP: 0000000000000000 R08: 00007f31b8ed3540 R09: 00007f331bb85000
[42465.375753] R10: 0000000000000000 R11: 0000000001434d34 R12: 0000000000000016
[42465.378520] R13: 0000000000000000 R14: 000055ab1facbd20 R15: 00007f31b8ed4340
[42465.381282]  </TASK>
[42465.384009] task:cache-worker    state:D stack:0     pid:979753 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42465.386953] Call Trace:
[42465.389857]  <TASK>
[42465.392723]  __schedule+0x581/0x10b0
[42465.395617]  schedule+0x28/0xa0
[42465.398494]  schedule_preempt_disabled+0x16/0x30
[42465.401393]  rwsem_down_write_slowpath+0x2d8/0x750
[42465.404301]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42465.407260]  down_write+0x5c/0x60
[42465.410157]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42465.413131]  file_update_time_flags+0x7e/0x130
[42465.416068]  __xfs_write_fault+0x8c/0x260 [xfs]
[42465.419045]  do_page_mkwrite+0x4a/0xa0
[42465.421971]  do_wp_page+0x136/0x1160
[42465.424849]  __handle_mm_fault+0xb5a/0x1170
[42465.427722]  ? restore_fpregs_from_fpstate+0x3c/0xa0
[42465.430623]  ? lock_vma_under_rcu+0x92/0x160
[42465.433527]  handle_mm_fault+0xe3/0x300
[42465.436425]  do_user_addr_fault+0x202/0x690
[42465.439279]  exc_page_fault+0x73/0x150
[42465.442029]  asm_exc_page_fault+0x26/0x30
[42465.444691] RIP: 0033:0x55ab1f9e1e6d
[42465.447370] RSP: 002b:00007f33134eb550 EFLAGS: 00010206
[42465.450086] RAX: 00007f331af70018 RBX: 00007f316b25b500 RCX: 0000000000000000
[42465.452879] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f316b25b508
[42465.455685] RBP: 0000000000000000 R08: 00007f33134eb540 R09: 00007f331bb85000
[42465.458476] R10: 0000000000000000 R11: 0000000001434d8a R12: 0000000000000016
[42465.461262] R13: 0000000000000000 R14: 000055ab1facbd20 R15: 00007f33134ec340
[42465.464038]  </TASK>
[42465.466773] task:cache-worker    state:D stack:0     pid:979759 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42465.469736] Call Trace:
[42465.472653]  <TASK>
[42465.475537]  __schedule+0x581/0x10b0
[42465.478444]  schedule+0x28/0xa0
[42465.481336]  schedule_preempt_disabled+0x16/0x30
[42465.484248]  rwsem_down_write_slowpath+0x2d8/0x750
[42465.487168]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42465.490140]  down_write+0x5c/0x60
[42465.493052]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42465.496043]  file_update_time_flags+0x7e/0x130
[42465.498986]  __xfs_write_fault+0x8c/0x260 [xfs]
[42465.501971]  do_page_mkwrite+0x4a/0xa0
[42465.504872]  do_wp_page+0x136/0x1160
[42465.507750]  __handle_mm_fault+0xb5a/0x1170
[42465.510637]  ? do_syscall_64+0x25a/0x550
[42465.513527]  ? lock_vma_under_rcu+0x92/0x160
[42465.516420]  handle_mm_fault+0xe3/0x300
[42465.519257]  do_user_addr_fault+0x202/0x690
[42465.522001]  exc_page_fault+0x73/0x150
[42465.524654]  asm_exc_page_fault+0x26/0x30
[42465.527328] RIP: 0033:0x55ab1f9e1e6d
[42465.530000] RSP: 002b:00007f327e016550 EFLAGS: 00010206
[42465.532719] RAX: 00007f331af70018 RBX: 00007f3243c1ea20 RCX: 0000000000000000
[42465.535503] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f3243c1ea28
[42465.538290] RBP: 0000000000000000 R08: 00007f327e016540 R09: 00007f331bb85000
[42465.541070] R10: 0000000000000000 R11: 0000000001434d66 R12: 0000000000000016
[42465.543841] R13: 0000000000000000 R14: 000055ab1facbd20 R15: 00007f327e017340
[42465.546597]  </TASK>
[42465.549319] task:cache-worker    state:D stack:0     pid:979873 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42465.552275] Call Trace:
[42465.555181]  <TASK>
[42465.558061]  __schedule+0x581/0x10b0
[42465.560958]  schedule+0x28/0xa0
[42465.563825]  schedule_preempt_disabled+0x16/0x30
[42465.566701]  rwsem_down_write_slowpath+0x2d8/0x750
[42465.569593]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42465.572555]  down_write+0x5c/0x60
[42465.575451]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42465.578419]  file_update_time_flags+0x7e/0x130
[42465.581342]  __xfs_write_fault+0x8c/0x260 [xfs]
[42465.584315]  do_page_mkwrite+0x4a/0xa0
[42465.587188]  do_wp_page+0x136/0x1160
[42465.590037]  ? do_syscall_64+0xf9/0x550
[42465.592895]  ? __seccomp_filter+0x42/0x5c0
[42465.595755]  __handle_mm_fault+0xb5a/0x1170
[42465.598607]  ? __x64_sys_ioctl+0xb0/0xe0
[42465.601411]  ? lock_vma_under_rcu+0x92/0x160
[42465.604125]  handle_mm_fault+0xe3/0x300
[42465.606735]  do_user_addr_fault+0x202/0x690
[42465.609375]  exc_page_fault+0x73/0x150
[42465.612014]  asm_exc_page_fault+0x26/0x30
[42465.614660] RIP: 0033:0x55ab1f9e1e6d
[42465.617306] RSP: 002b:00007f33142fc530 EFLAGS: 00010206
[42465.619975] RAX: 00007f331af70018 RBX: 00007f32cca03320 RCX: 0000000000000000
[42465.622703] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f32cca03328
[42465.625439] RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
[42465.628152] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000016
[42465.630830] R13: 000055ab1facc058 R14: 00007f310fa0c4e8 R15: 00007f33142fc820
[42465.633526]  </TASK>
[42465.636182] task:cache-worker    state:D stack:0     pid:981662 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42465.639079] Call Trace:
[42465.641934]  <TASK>
[42465.644756]  __schedule+0x581/0x10b0
[42465.647600]  schedule+0x28/0xa0
[42465.650426]  schedule_preempt_disabled+0x16/0x30
[42465.653279]  rwsem_down_write_slowpath+0x2d8/0x750
[42465.656138]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42465.659053]  down_write+0x5c/0x60
[42465.661907]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42465.664842]  file_update_time_flags+0x7e/0x130
[42465.667690]  __xfs_write_fault+0x8c/0x260 [xfs]
[42465.670591]  do_page_mkwrite+0x4a/0xa0
[42465.673425]  do_wp_page+0x136/0x1160
[42465.676247]  ? do_vfs_ioctl+0x475/0x940
[42465.679070]  ? __seccomp_filter+0x42/0x5c0
[42465.681854]  __handle_mm_fault+0xb5a/0x1170
[42465.684538]  ? lock_vma_under_rcu+0x92/0x160
[42465.687135]  handle_mm_fault+0xe3/0x300
[42465.689743]  do_user_addr_fault+0x202/0x690
[42465.692373]  exc_page_fault+0x73/0x150
[42465.694997]  asm_exc_page_fault+0x26/0x30
[42465.697626] RIP: 0033:0x55ab1f9e1e6d
[42465.700244] RSP: 002b:00007f328f440530 EFLAGS: 00010206
[42465.702884] RAX: 00007f331af70018 RBX: 00007f32c5613a20 RCX: 0000000000000000
[42465.705586] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f32c5613a28
[42465.708293] RBP: 0000000000000000 R08: 0000000000000000 R09: 00007f331bb85000
[42465.710969] R10: 0000000000000000 R11: 0000000001434d7c R12: 0000000000000016
[42465.713643] R13: 000055ab1facc058 R14: 0000000000000008 R15: 0000000000000008
[42465.716307]  </TASK>
[42465.718944] task:cache-worker    state:D stack:0     pid:981675 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42465.721821] Call Trace:
[42465.724659]  <TASK>
[42465.727478]  __schedule+0x581/0x10b0
[42465.730309]  schedule+0x28/0xa0
[42465.733129]  schedule_preempt_disabled+0x16/0x30
[42465.735969]  rwsem_down_write_slowpath+0x2d8/0x750
[42465.738815]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42465.741731]  down_write+0x5c/0x60
[42465.744577]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42465.747497]  file_update_time_flags+0x7e/0x130
[42465.750366]  __xfs_write_fault+0x8c/0x260 [xfs]
[42465.753248]  do_page_mkwrite+0x4a/0xa0
[42465.756069]  do_wp_page+0x136/0x1160
[42465.758888]  __handle_mm_fault+0xb5a/0x1170
[42465.761745]  ? lock_vma_under_rcu+0x92/0x160
[42465.764594]  handle_mm_fault+0xe3/0x300
[42465.767391]  do_user_addr_fault+0x202/0x690
[42465.770095]  exc_page_fault+0x73/0x150
[42465.772702]  asm_exc_page_fault+0x26/0x30
[42465.775332] RIP: 0033:0x55ab1f9e1e6d
[42465.777959] RSP: 002b:00007f31bd4e8550 EFLAGS: 00010206
[42465.780628] RAX: 00007f331af70018 RBX: 00007f3175e0c2b0 RCX: 0000000000000000
[42465.783369] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f3175e0c2b8
[42465.786109] RBP: 0000000000000000 R08: 00007f31bd4e8540 R09: 00007f331bb85000
[42465.788841] R10: 0000000000000000 R11: 0000000001434dae R12: 0000000000000016
[42465.791565] R13: 0000000000000000 R14: 000055ab1facbd20 R15: 00007f31bd4e9340
[42465.794276]  </TASK>
[42465.796950] task:cache-worker    state:D stack:0     pid:981685 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42465.799858] Call Trace:
[42465.802709]  <TASK>
[42465.805547]  __schedule+0x581/0x10b0
[42465.808405]  schedule+0x28/0xa0
[42465.811249]  schedule_preempt_disabled+0x16/0x30
[42465.814120]  rwsem_down_write_slowpath+0x2d8/0x750
[42465.816997]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42465.819939]  down_write+0x5c/0x60
[42465.822807]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42465.825751]  file_update_time_flags+0x7e/0x130
[42465.828661]  __xfs_write_fault+0x8c/0x260 [xfs]
[42465.831618]  do_page_mkwrite+0x4a/0xa0
[42465.834509]  do_wp_page+0x136/0x1160
[42465.837358]  __handle_mm_fault+0xb5a/0x1170
[42465.840205]  ? lock_vma_under_rcu+0x92/0x160
[42465.843071]  handle_mm_fault+0xe3/0x300
[42465.845939]  do_user_addr_fault+0x202/0x690
[42465.848815]  exc_page_fault+0x73/0x150
[42465.851647]  asm_exc_page_fault+0x26/0x30
[42465.854377] RIP: 0033:0x55ab1f9e1e6d
[42465.857008] RSP: 002b:00007f31bd494550 EFLAGS: 00010206
[42465.859697] RAX: 00007f331af70018 RBX: 00007f32a6ce48c0 RCX: 0000000000000000
[42465.862456] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f32a6ce48c8
[42465.865241] RBP: 0000000000000000 R08: 00007f31bd494540 R09: 00007f331bb85000
[42465.868027] R10: 0000000000000000 R11: 0000000001434d22 R12: 0000000000000016
[42465.870805] R13: 0000000000000000 R14: 000055ab1facbd20 R15: 00007f31bd495340
[42465.873575]  </TASK>
[42465.876307] task:cache-worker    state:D stack:0     pid:981689 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42465.879262] Call Trace:
[42465.882162]  <TASK>
[42465.885033]  __schedule+0x581/0x10b0
[42465.887915]  schedule+0x28/0xa0
[42465.890786]  schedule_preempt_disabled+0x16/0x30
[42465.893680]  rwsem_down_write_slowpath+0x2d8/0x750
[42465.896580]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42465.899534]  down_write+0x5c/0x60
[42465.902421]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42465.905382]  file_update_time_flags+0x7e/0x130
[42465.908311]  __xfs_write_fault+0x8c/0x260 [xfs]
[42465.911290]  do_page_mkwrite+0x4a/0xa0
[42465.914209]  do_wp_page+0x136/0x1160
[42465.917081]  __handle_mm_fault+0xb5a/0x1170
[42465.919954]  ? switch_fpu_return+0x5d/0xe0
[42465.922826]  ? lock_vma_under_rcu+0x92/0x160
[42465.925701]  handle_mm_fault+0xe3/0x300
[42465.928570]  do_user_addr_fault+0x202/0x690
[42465.931398]  exc_page_fault+0x73/0x150
[42465.934124]  asm_exc_page_fault+0x26/0x30
[42465.936762] RIP: 0033:0x55ab1f9e1e6d
[42465.939415] RSP: 002b:00007f330ff7a550 EFLAGS: 00010206
[42465.942103] RAX: 00007f331af70018 RBX: 00007f311d2030a0 RCX: 0000000000000000
[42465.944873] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f311d2030a8
[42465.947648] RBP: 0000000000000000 R08: 00007f330ff7a540 R09: 00007f331bb85000
[42465.950412] R10: 0000000000000000 R11: 0000000001434d44 R12: 0000000000000016
[42465.953169] R13: 0000000000000000 R14: 000055ab1facbd20 R15: 00007f330ff7b340
[42465.955915]  </TASK>
[42465.958622] task:cache-worker    state:D stack:0     pid:981718 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42465.961554] Call Trace:
[42465.964444]  <TASK>
[42465.967296]  __schedule+0x581/0x10b0
[42465.970171]  schedule+0x28/0xa0
[42465.973033]  schedule_preempt_disabled+0x16/0x30
[42465.975912]  rwsem_down_write_slowpath+0x2d8/0x750
[42465.978797]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42465.981735]  down_write+0x5c/0x60
[42465.984621]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42465.987586]  file_update_time_flags+0x7e/0x130
[42465.990502]  __xfs_write_fault+0x8c/0x260 [xfs]
[42465.993461]  do_page_mkwrite+0x4a/0xa0
[42465.996339]  do_wp_page+0x136/0x1160
[42465.999190]  __handle_mm_fault+0xb5a/0x1170
[42466.002045]  ? lock_vma_under_rcu+0x92/0x160
[42466.004913]  handle_mm_fault+0xe3/0x300
[42466.007775]  do_user_addr_fault+0x202/0x690
[42466.010597]  exc_page_fault+0x73/0x150
[42466.013323]  asm_exc_page_fault+0x26/0x30
[42466.015979] RIP: 0033:0x55ab1f9e1e6d
[42466.018628] RSP: 002b:00007f32cf66c550 EFLAGS: 00010206
[42466.021320] RAX: 00007f331af70018 RBX: 00007f32d0a04cd0 RCX: 0000000000000000
[42466.024086] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f32d0a04cd8
[42466.026859] RBP: 0000000000000000 R08: 00007f32cf66c540 R09: 00007f331bb85000
[42466.029630] R10: 0000000000000000 R11: 0000000001434daa R12: 0000000000000016
[42466.032393] R13: 0000000000000000 R14: 000055ab1facbd20 R15: 00007f32cf66d340
[42466.035149]  </TASK>
[42466.037866] task:cache-worker    state:D stack:0     pid:1003433 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42466.040807] Call Trace:
[42466.043704]  <TASK>
[42466.046560]  __schedule+0x581/0x10b0
[42466.049446]  schedule+0x28/0xa0
[42466.052313]  schedule_preempt_disabled+0x16/0x30
[42466.055203]  rwsem_down_write_slowpath+0x2d8/0x750
[42466.058100]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42466.061066]  down_write+0x5c/0x60
[42466.063961]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42466.066921]  file_update_time_flags+0x7e/0x130
[42466.069847]  __xfs_write_fault+0x8c/0x260 [xfs]
[42466.072822]  do_page_mkwrite+0x4a/0xa0
[42466.075737]  do_wp_page+0x136/0x1160
[42466.078598]  ? __x64_sys_ioctl+0xb0/0xe0
[42466.081460]  ? do_syscall_64+0xf9/0x550
[42466.084320]  __handle_mm_fault+0xb5a/0x1170
[42466.087184]  ? restore_fpregs_from_fpstate+0x3c/0xa0
[42466.090079]  ? lock_vma_under_rcu+0x92/0x160
[42466.092926]  handle_mm_fault+0xe3/0x300
[42466.095673]  do_user_addr_fault+0x202/0x690
[42466.098326]  exc_page_fault+0x73/0x150
[42466.101003]  asm_exc_page_fault+0x26/0x30
[42466.103688] RIP: 0033:0x55ab1f9e1e6d
[42466.106373] RSP: 002b:00007f330dec9550 EFLAGS: 00010206
[42466.109097] RAX: 00007f331af70018 RBX: 00007f328420ff80 RCX: 0000000000000000
[42466.111882] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f328420ff88
[42466.114666] RBP: 0000000000000000 R08: 00007f330dec9540 R09: 00007f331bb85000
[42466.117443] R10: 0000000000000000 R11: 0000000001434dea R12: 0000000000000016
[42466.120212] R13: 0000000000000000 R14: 000055ab1facbd20 R15: 00007f330deca340
[42466.122965]  </TASK>
[42466.125693] task:cache-worker    state:D stack:0     pid:1022921 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42466.128649] Call Trace:
[42466.131566]  <TASK>
[42466.134451]  __schedule+0x581/0x10b0
[42466.137348]  schedule+0x28/0xa0
[42466.140234]  schedule_preempt_disabled+0x16/0x30
[42466.143139]  rwsem_down_write_slowpath+0x2d8/0x750
[42466.146046]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42466.149010]  down_write+0x5c/0x60
[42466.151916]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42466.154879]  file_update_time_flags+0x7e/0x130
[42466.157775]  __xfs_write_fault+0x8c/0x260 [xfs]
[42466.160708]  do_page_mkwrite+0x4a/0xa0
[42466.163592]  do_wp_page+0x136/0x1160
[42466.166461]  ? switch_fpu_return+0x5d/0xe0
[42466.169342]  __handle_mm_fault+0xb5a/0x1170
[42466.172180]  ? switch_fpu_return+0x5d/0xe0
[42466.174920]  ? lock_vma_under_rcu+0x92/0x160
[42466.177568]  handle_mm_fault+0xe3/0x300
[42466.180233]  do_user_addr_fault+0x202/0x690
[42466.182908]  exc_page_fault+0x73/0x150
[42466.185589]  asm_exc_page_fault+0x26/0x30
[42466.188272] RIP: 0033:0x55ab1f9e1e6d
[42466.190941] RSP: 002b:00007f32cd655550 EFLAGS: 00010206
[42466.193641] RAX: 00007f331af70018 RBX: 00007f311b601fe0 RCX: 0000000000000000
[42466.196400] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f311b601fe8
[42466.199158] RBP: 0000000000000000 R08: 00007f32cd655540 R09: 00007f331bb85000
[42466.201904] R10: 0000000000000000 R11: 0000000001434d14 R12: 0000000000000016
[42466.204656] R13: 0000000000000000 R14: 000055ab1facbd20 R15: 00007f32cd656340
[42466.207398]  </TASK>
[42466.210117] task:cache-worker    state:D stack:0     pid:1039759 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42466.213077] Call Trace:
[42466.215994]  <TASK>
[42466.218879]  __schedule+0x581/0x10b0
[42466.221770]  schedule+0x28/0xa0
[42466.224635]  schedule_preempt_disabled+0x16/0x30
[42466.227522]  rwsem_down_write_slowpath+0x2d8/0x750
[42466.230415]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42466.233359]  down_write+0x5c/0x60
[42466.236252]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42466.239209]  file_update_time_flags+0x7e/0x130
[42466.242122]  __xfs_write_fault+0x8c/0x260 [xfs]
[42466.245044]  do_page_mkwrite+0x4a/0xa0
[42466.247911]  do_wp_page+0x136/0x1160
[42466.250762]  ? restore_fpregs_from_fpstate+0x3c/0xa0
[42466.253656]  __handle_mm_fault+0xb5a/0x1170
[42466.256555]  ? lock_vma_under_rcu+0x92/0x160
[42466.259420]  handle_mm_fault+0xe3/0x300
[42466.262167]  do_user_addr_fault+0x202/0x690
[42466.264835]  exc_page_fault+0x73/0x150
[42466.267520]  asm_exc_page_fault+0x26/0x30
[42466.270207] RIP: 0033:0x55ab1f9e1e6d
[42466.272909] RSP: 002b:00007f316fe29550 EFLAGS: 00010206
[42466.275641] RAX: 00007f331af70018 RBX: 00007f3261010370 RCX: 0000000000000000
[42466.278424] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f3261010378
[42466.281211] RBP: 0000000000000000 R08: 00007f316fe29540 R09: 00007f331bb85000
[42466.283989] R10: 0000000000000000 R11: 0000000001434dfe R12: 0000000000000016
[42466.286757] R13: 0000000000000000 R14: 000055ab1facbd20 R15: 00007f316fe2a340
[42466.289518]  </TASK>
[42466.292256] task:cache-worker    state:D stack:0     pid:1056564 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42466.295218] Call Trace:
[42466.298136]  <TASK>
[42466.301032]  __schedule+0x581/0x10b0
[42466.303947]  schedule+0x28/0xa0
[42466.306837]  schedule_preempt_disabled+0x16/0x30
[42466.309756]  rwsem_down_write_slowpath+0x2d8/0x750
[42466.312686]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42466.315662]  down_write+0x5c/0x60
[42466.318576]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42466.321561]  file_update_time_flags+0x7e/0x130
[42466.324520]  __xfs_write_fault+0x8c/0x260 [xfs]
[42466.327509]  do_page_mkwrite+0x4a/0xa0
[42466.330412]  do_wp_page+0x136/0x1160
[42466.333301]  __handle_mm_fault+0xb5a/0x1170
[42466.336201]  ? restore_fpregs_from_fpstate+0x3c/0xa0
[42466.339118]  ? switch_fpu_return+0x5d/0xe0
[42466.342039]  ? lock_vma_under_rcu+0x92/0x160
[42466.344915]  handle_mm_fault+0xe3/0x300
[42466.347684]  do_user_addr_fault+0x202/0x690
[42466.350365]  exc_page_fault+0x73/0x150
[42466.353069]  asm_exc_page_fault+0x26/0x30
[42466.355782] RIP: 0033:0x55ab1f9e1e6d
[42466.358491] RSP: 002b:00007f32cc2ff550 EFLAGS: 00010206
[42466.361239] RAX: 00007f331af70018 RBX: 00007f325e211b80 RCX: 0000000000000000
[42466.364051] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f325e211b88
[42466.366859] RBP: 0000000000000000 R08: 00007f32cc2ff540 R09: 00007f331bb85000
[42466.369663] R10: 0000000000000000 R11: 0000000001434d26 R12: 0000000000000016
[42466.372459] R13: 0000000000000000 R14: 000055ab1facbd20 R15: 00007f32cc300340
[42466.375243]  </TASK>
[42466.377995] task:cache-worker    state:D stack:0     pid:1071651 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42466.380975] Call Trace:
[42466.383918]  <TASK>
[42466.386813]  __schedule+0x581/0x10b0
[42466.389713]  schedule+0x28/0xa0
[42466.392589]  schedule_preempt_disabled+0x16/0x30
[42466.395488]  rwsem_down_write_slowpath+0x2d8/0x750
[42466.398393]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42466.401349]  down_write+0x5c/0x60
[42466.404258]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42466.407232]  file_update_time_flags+0x7e/0x130
[42466.410160]  __xfs_write_fault+0x8c/0x260 [xfs]
[42466.413101]  ? __seccomp_filter+0x42/0x5c0
[42466.415992]  do_page_mkwrite+0x4a/0xa0
[42466.418871]  do_wp_page+0x136/0x1160
[42466.421741]  ? do_syscall_64+0xf9/0x550
[42466.424615]  __handle_mm_fault+0xb5a/0x1170
[42466.427448]  ? do_syscall_64+0x25a/0x550
[42466.430180]  ? lock_vma_under_rcu+0x92/0x160
[42466.432828]  handle_mm_fault+0xe3/0x300
[42466.435490]  do_user_addr_fault+0x202/0x690
[42466.438159]  exc_page_fault+0x73/0x150
[42466.440837]  asm_exc_page_fault+0x26/0x30
[42466.443518] RIP: 0033:0x55ab1f9e1e6d
[42466.446185] RSP: 002b:00007f31ba22b550 EFLAGS: 00010206
[42466.448879] RAX: 00007f331af70018 RBX: 00007f3129a064b0 RCX: 0000000000000000
[42466.451635] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f3129a064b8
[42466.454390] RBP: 0000000000000000 R08: 00007f31ba22b540 R09: 00007f331bb85000
[42466.457140] R10: 0000000000000000 R11: 0000000001434d5a R12: 0000000000000016
[42466.459884] R13: 0000000000000000 R14: 000055ab1facbd20 R15: 00007f31ba22c340
[42466.462619]  </TASK>
[42466.465340] task:cache-worker    state:D stack:0     pid:1071968 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42466.468292] Call Trace:
[42466.471190]  <TASK>
[42466.474042]  __schedule+0x581/0x10b0
[42466.476917]  schedule+0x28/0xa0
[42466.479776]  schedule_preempt_disabled+0x16/0x30
[42466.482653]  rwsem_down_write_slowpath+0x2d8/0x750
[42466.485542]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42466.488480]  down_write+0x5c/0x60
[42466.491365]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42466.494307]  file_update_time_flags+0x7e/0x130
[42466.497182]  __xfs_write_fault+0x8c/0x260 [xfs]
[42466.500086]  do_page_mkwrite+0x4a/0xa0
[42466.502946]  do_wp_page+0x136/0x1160
[42466.505798]  __handle_mm_fault+0xb5a/0x1170
[42466.508664]  ? restore_fpregs_from_fpstate+0x3c/0xa0
[42466.511509]  ? switch_fpu_return+0x5d/0xe0
[42466.514254]  ? lock_vma_under_rcu+0x92/0x160
[42466.516912]  handle_mm_fault+0xe3/0x300
[42466.519586]  do_user_addr_fault+0x202/0x690
[42466.522269]  exc_page_fault+0x73/0x150
[42466.524964]  asm_exc_page_fault+0x26/0x30
[42466.527658] RIP: 0033:0x55ab1f9e1e6d
[42466.530339] RSP: 002b:00007f32cf618550 EFLAGS: 00010206
[42466.533049] RAX: 00007f331af70018 RBX: 00007f30f3c00550 RCX: 0000000000000000
[42466.535814] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f30f3c00558
[42466.538573] RBP: 0000000000000000 R08: 00007f32cf618540 R09: 00007f331bb85000
[42466.541330] R10: 0000000000000000 R11: 0000000001434d52 R12: 0000000000000016
[42466.544081] R13: 0000000000000000 R14: 000055ab1facbd20 R15: 00007f32cf619340
[42466.546826]  </TASK>
[42466.549546] task:cache-worker    state:D stack:0     pid:1071970 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42466.552508] Call Trace:
[42466.555429]  <TASK>
[42466.558314]  __schedule+0x581/0x10b0
[42466.561220]  schedule+0x28/0xa0
[42466.564114]  schedule_preempt_disabled+0x16/0x30
[42466.567023]  rwsem_down_write_slowpath+0x2d8/0x750
[42466.569948]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42466.572915]  down_write+0x5c/0x60
[42466.575834]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42466.578813]  file_update_time_flags+0x7e/0x130
[42466.581759]  __xfs_write_fault+0x8c/0x260 [xfs]
[42466.584709]  do_page_mkwrite+0x4a/0xa0
[42466.587600]  do_wp_page+0x136/0x1160
[42466.590473]  ? do_syscall_64+0x25a/0x550
[42466.593356]  __handle_mm_fault+0xb5a/0x1170
[42466.596247]  ? do_vfs_ioctl+0x475/0x940
[42466.599084]  ? lock_vma_under_rcu+0x92/0x160
[42466.601830]  handle_mm_fault+0xe3/0x300
[42466.604479]  do_user_addr_fault+0x202/0x690
[42466.607159]  exc_page_fault+0x73/0x150
[42466.609832]  asm_exc_page_fault+0x26/0x30
[42466.612524] RIP: 0033:0x55ab1f9e1e6d
[42466.615208] RSP: 002b:00007f321e0e8550 EFLAGS: 00010206
[42466.617912] RAX: 00007f331af70018 RBX: 00007f32a6806f70 RCX: 0000000000000000
[42466.620677] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f32a6806f78
[42466.623449] RBP: 0000000000000000 R08: 00007f321e0e8540 R09: 00007f331bb85000
[42466.626202] R10: 0000000000000000 R11: 0000000001434d1c R12: 0000000000000016
[42466.628955] R13: 0000000000000000 R14: 000055ab1facbd20 R15: 00007f321e0e9340
[42466.631703]  </TASK>
[42466.634410] task:cache-worker    state:D stack:0     pid:1072148 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42466.637366] Call Trace:
[42466.640274]  <TASK>
[42466.643142]  __schedule+0x581/0x10b0
[42466.646010]  schedule+0x28/0xa0
[42466.648869]  schedule_preempt_disabled+0x16/0x30
[42466.651750]  rwsem_down_write_slowpath+0x2d8/0x750
[42466.654637]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42466.657572]  down_write+0x5c/0x60
[42466.660459]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42466.663407]  file_update_time_flags+0x7e/0x130
[42466.666316]  __xfs_write_fault+0x8c/0x260 [xfs]
[42466.669235]  do_page_mkwrite+0x4a/0xa0
[42466.672114]  do_wp_page+0x136/0x1160
[42466.674969]  ? __x64_sys_ioctl+0xb0/0xe0
[42466.677827]  ? do_syscall_64+0xf9/0x550
[42466.680682]  __handle_mm_fault+0xb5a/0x1170
[42466.683502]  ? lock_vma_under_rcu+0x92/0x160
[42466.686225]  handle_mm_fault+0xe3/0x300
[42466.688849]  do_user_addr_fault+0x202/0x690
[42466.691504]  exc_page_fault+0x73/0x150
[42466.694157]  asm_exc_page_fault+0x26/0x30
[42466.696822] RIP: 0033:0x55ab1f9e1e6d
[42466.699485] RSP: 002b:00007f3312f2b550 EFLAGS: 00010206
[42466.702168] RAX: 00007f331af70018 RBX: 00007f326040d960 RCX: 0000000000000000
[42466.704917] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f326040d968
[42466.707665] RBP: 0000000000000000 R08: 00007f3312f2b540 R09: 00007f331bb85000
[42466.710401] R10: 0000000000000000 R11: 0000000001434dea R12: 0000000000000016
[42466.713134] R13: 0000000000000000 R14: 000055ab1facbd20 R15: 00007f3312f2c340
[42466.715862]  </TASK>
[42466.718553] task:cache-worker    state:D stack:0     pid:1072354 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42466.721494] Call Trace:
[42466.724392]  <TASK>
[42466.727259]  __schedule+0x581/0x10b0
[42466.730137]  schedule+0x28/0xa0
[42466.733008]  schedule_preempt_disabled+0x16/0x30
[42466.735901]  rwsem_down_write_slowpath+0x2d8/0x750
[42466.738796]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42466.741741]  down_write+0x5c/0x60
[42466.744639]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42466.747603]  file_update_time_flags+0x7e/0x130
[42466.750522]  __xfs_write_fault+0x8c/0x260 [xfs]
[42466.753450]  do_page_mkwrite+0x4a/0xa0
[42466.756324]  do_wp_page+0x136/0x1160
[42466.759185]  __handle_mm_fault+0xb5a/0x1170
[42466.762055]  ? lock_vma_under_rcu+0x92/0x160
[42466.764937]  handle_mm_fault+0xe3/0x300
[42466.767766]  do_user_addr_fault+0x202/0x690
[42466.770497]  exc_page_fault+0x73/0x150
[42466.773135]  asm_exc_page_fault+0x26/0x30
[42466.775797] RIP: 0033:0x55ab1f9e1e6d
[42466.778455] RSP: 002b:00007f328823e530 EFLAGS: 00010206
[42466.781159] RAX: 00007f331af70018 RBX: 00007f3257210230 RCX: 0000000000000000
[42466.783930] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f3257210238
[42466.786699] RBP: 0000000000000000 R08: 00007f328823e540 R09: 00007f331bb85000
[42466.789463] R10: 0000000000000000 R11: 00000000014355b6 R12: 0000000000000016
[42466.792217] R13: 000055ab1facc058 R14: 00007f30fb93e0e8 R15: 00007f328823e820
[42466.794971]  </TASK>
[42466.797690] task:cache-worker    state:D stack:0     pid:1072356 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42466.800644] Call Trace:
[42466.803551]  <TASK>
[42466.806429]  __schedule+0x581/0x10b0
[42466.809334]  schedule+0x28/0xa0
[42466.812229]  schedule_preempt_disabled+0x16/0x30
[42466.815142]  rwsem_down_write_slowpath+0x2d8/0x750
[42466.818063]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42466.821037]  down_write+0x5c/0x60
[42466.823955]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42466.826931]  file_update_time_flags+0x7e/0x130
[42466.829881]  __xfs_write_fault+0x8c/0x260 [xfs]
[42466.832870]  do_page_mkwrite+0x4a/0xa0
[42466.835808]  do_wp_page+0x136/0x1160
[42466.838688]  __handle_mm_fault+0xb5a/0x1170
[42466.841573]  ? switch_fpu_return+0x5d/0xe0
[42466.844466]  ? lock_vma_under_rcu+0x92/0x160
[42466.847354]  handle_mm_fault+0xe3/0x300
[42466.850230]  do_user_addr_fault+0x202/0x690
[42466.853071]  exc_page_fault+0x73/0x150
[42466.855814]  asm_exc_page_fault+0x26/0x30
[42466.858455] RIP: 0033:0x55ab1f9e1e6d
[42466.861121] RSP: 002b:00007f321b0ab530 EFLAGS: 00010206
[42466.863829] RAX: 00007f331af70018 RBX: 00007f3292a0f460 RCX: 0000000000000000
[42466.866605] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f3292a0f468
[42466.869398] RBP: 0000000000000000 R08: 00007f321b0ab540 R09: 00007f331bb85000
[42466.872182] R10: 0000000000000000 R11: 0000000001434f56 R12: 0000000000000016
[42466.874956] R13: 000055ab1facc058 R14: 00007f33073bace8 R15: 00007f321b0ab820
[42466.877739]  </TASK>
[42466.880486] task:cache-worker    state:D stack:0     pid:1073342 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42466.883461] Call Trace:
[42466.886382]  <TASK>
[42466.889272]  __schedule+0x581/0x10b0
[42466.892189]  schedule+0x28/0xa0
[42466.895080]  schedule_preempt_disabled+0x16/0x30
[42466.897995]  rwsem_down_write_slowpath+0x2d8/0x750
[42466.900922]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42466.903891]  down_write+0x5c/0x60
[42466.906803]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42466.909788]  file_update_time_flags+0x7e/0x130
[42466.912743]  __xfs_write_fault+0x8c/0x260 [xfs]
[42466.915730]  do_page_mkwrite+0x4a/0xa0
[42466.918633]  do_wp_page+0x136/0x1160
[42466.921519]  __handle_mm_fault+0xb5a/0x1170
[42466.924419]  ? lock_vma_under_rcu+0x92/0x160
[42466.927322]  handle_mm_fault+0xe3/0x300
[42466.930198]  do_user_addr_fault+0x202/0x690
[42466.933040]  exc_page_fault+0x73/0x150
[42466.935782]  asm_exc_page_fault+0x26/0x30
[42466.938424] RIP: 0033:0x55ab1f9e1e6d
[42466.941092] RSP: 002b:00007f32614ff550 EFLAGS: 00010206
[42466.943795] RAX: 00007f331af70018 RBX: 00007f32a4016870 RCX: 0000000000000000
[42466.946566] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f32a4016878
[42466.949356] RBP: 0000000000000000 R08: 00007f32614ff540 R09: 00007f331bb85000
[42466.952136] R10: 0000000000000000 R11: 0000000001434df4 R12: 0000000000000016
[42466.954899] R13: 0000000000000000 R14: 000055ab1facbd20 R15: 00007f3261500340
[42466.957656]  </TASK>
[42466.960380] task:cache-worker    state:D stack:0     pid:1073535 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42466.963328] Call Trace:
[42466.966225]  <TASK>
[42466.969090]  __schedule+0x581/0x10b0
[42466.971983]  schedule+0x28/0xa0
[42466.974854]  schedule_preempt_disabled+0x16/0x30
[42466.977750]  rwsem_down_write_slowpath+0x2d8/0x750
[42466.980658]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42466.983613]  down_write+0x5c/0x60
[42466.986507]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42466.989472]  file_update_time_flags+0x7e/0x130
[42466.992410]  __xfs_write_fault+0x8c/0x260 [xfs]
[42466.995387]  do_page_mkwrite+0x4a/0xa0
[42466.998307]  do_wp_page+0x136/0x1160
[42467.001179]  __handle_mm_fault+0xb5a/0x1170
[42467.004061]  ? lock_vma_under_rcu+0x92/0x160
[42467.006941]  handle_mm_fault+0xe3/0x300
[42467.009815]  do_user_addr_fault+0x202/0x690
[42467.012682]  exc_page_fault+0x73/0x150
[42467.015500]  asm_exc_page_fault+0x26/0x30
[42467.018217] RIP: 0033:0x55ab1f9e1e6d
[42467.020842] RSP: 002b:00007f32ce6ff550 EFLAGS: 00010206
[42467.023528] RAX: 00007f331af70018 RBX: 00007f3122000b90 RCX: 0000000000000000
[42467.026277] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f3122000b98
[42467.029043] RBP: 0000000000000000 R08: 00007f32ce6ff540 R09: 00007f331bb85000
[42467.031811] R10: 0000000000000000 R11: 0000000001434dd2 R12: 0000000000000016
[42467.034571] R13: 0000000000000000 R14: 000055ab1facbd20 R15: 00007f32ce700340
[42467.037319]  </TASK>
[42467.040064] task:cache-worker    state:D stack:0     pid:1073566 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42467.043000] Call Trace:
[42467.045887]  <TASK>
[42467.048744]  __schedule+0x581/0x10b0
[42467.051609]  schedule+0x28/0xa0
[42467.054465]  schedule_preempt_disabled+0x16/0x30
[42467.057344]  rwsem_down_write_slowpath+0x2d8/0x750
[42467.060234]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42467.063174]  down_write+0x5c/0x60
[42467.066049]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42467.068996]  file_update_time_flags+0x7e/0x130
[42467.071910]  __xfs_write_fault+0x8c/0x260 [xfs]
[42467.074863]  do_page_mkwrite+0x4a/0xa0
[42467.077768]  do_wp_page+0x136/0x1160
[42467.080624]  __handle_mm_fault+0xb5a/0x1170
[42467.083482]  ? lock_vma_under_rcu+0x92/0x160
[42467.086343]  handle_mm_fault+0xe3/0x300
[42467.089203]  do_user_addr_fault+0x202/0x690
[42467.092072]  exc_page_fault+0x73/0x150
[42467.094887]  asm_exc_page_fault+0x26/0x30
[42467.097610] RIP: 0033:0x55ab1f9e1e6d
[42467.100235] RSP: 002b:00007f32a38ea530 EFLAGS: 00010206
[42467.102914] RAX: 00007f331af70018 RBX: 00007f3126e57e80 RCX: 0000000000000000
[42467.105672] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f3126e57e88
[42467.108450] RBP: 0000000000000000 R08: 0000000000000000 R09: 00007f331bb85000
[42467.111212] R10: 0000000000000000 R11: 0000000001434dda R12: 0000000000000016
[42467.113962] R13: 000055ab1facc058 R14: 0000000000000008 R15: 0000000000000008
[42467.116700]  </TASK>
[42467.119401] task:cache-worker    state:D stack:0     pid:1073567 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42467.122324] Call Trace:
[42467.125198]  <TASK>
[42467.128043]  __schedule+0x581/0x10b0
[42467.130892]  schedule+0x28/0xa0
[42467.133741]  schedule_preempt_disabled+0x16/0x30
[42467.136606]  rwsem_down_write_slowpath+0x2d8/0x750
[42467.139476]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42467.142393]  down_write+0x5c/0x60
[42467.145261]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42467.148194]  file_update_time_flags+0x7e/0x130
[42467.151092]  __xfs_write_fault+0x8c/0x260 [xfs]
[42467.154038]  do_page_mkwrite+0x4a/0xa0
[42467.156930]  do_wp_page+0x136/0x1160
[42467.159771]  ? switch_fpu_return+0x5d/0xe0
[42467.162610]  ? do_syscall_64+0x25a/0x550
[42467.165450]  ? do_syscall_64+0x25a/0x550
[42467.168249]  __handle_mm_fault+0xb5a/0x1170
[42467.171056]  ? lock_vma_under_rcu+0x92/0x160
[42467.173829]  handle_mm_fault+0xe3/0x300
[42467.176494]  do_user_addr_fault+0x202/0x690
[42467.179068]  exc_page_fault+0x73/0x150
[42467.181667]  asm_exc_page_fault+0x26/0x30
[42467.184273] RIP: 0033:0x55ab1f9e1e6d
[42467.186876] RSP: 002b:00007f324d868530 EFLAGS: 00010206
[42467.189520] RAX: 00007f331af70018 RBX: 00007f30fc811c70 RCX: 0000000000000000
[42467.192220] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f30fc811c78
[42467.194917] RBP: 0000000000000000 R08: 00007f324d868540 R09: 00007f331bb85000
[42467.197610] R10: 0000000000000000 R11: 0000000001434d26 R12: 0000000000000016
[42467.200294] R13: 000055ab1facc058 R14: 00007f30fb9edf68 R15: 00007f324d868820
[42467.202982]  </TASK>
[42467.205645] task:cache-worker    state:D stack:0     pid:1073588 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42467.208533] Call Trace:
[42467.211389]  <TASK>
[42467.214209]  __schedule+0x581/0x10b0
[42467.217044]  schedule+0x28/0xa0
[42467.219863]  schedule_timeout+0xbd/0x100
[42467.222681]  __down_common+0x17c/0x340
[42467.225497]  down+0x52/0x70
[42467.228295]  xfs_buf_lock+0x32/0xd0 [xfs]
[42467.231160]  xfs_buf_find_lock+0x51/0x100 [xfs]
[42467.233991]  xfs_buf_read_map+0x94/0x2b0 [xfs]
[42467.236779]  ? xfs_read_icluster+0x7f/0xd0 [xfs]
[42467.239599]  xfs_trans_read_buf_map+0x12d/0x270 [xfs]
[42467.242446]  ? xfs_read_icluster+0x7f/0xd0 [xfs]
[42467.245304]  xfs_read_icluster+0x7f/0xd0 [xfs]
[42467.248170]  xfs_inode_item_precommit+0x22f/0x2d0 [xfs]
[42467.251013]  __xfs_trans_commit+0xb9/0x300 [xfs]
[42467.253767]  xfs_trans_commit+0x38/0x70 [xfs]
[42467.256426]  xfs_vn_update_time+0x187/0x1b0 [xfs]
[42467.259120]  file_update_time_flags+0x7e/0x130
[42467.261785]  __xfs_write_fault+0x8c/0x260 [xfs]
[42467.264507]  do_page_mkwrite+0x4a/0xa0
[42467.267181]  do_wp_page+0x136/0x1160
[42467.269832]  __handle_mm_fault+0xb5a/0x1170
[42467.272492]  ? lock_vma_under_rcu+0x92/0x160
[42467.275145]  handle_mm_fault+0xe3/0x300
[42467.277779]  do_user_addr_fault+0x202/0x690
[42467.280413]  exc_page_fault+0x73/0x150
[42467.283038]  asm_exc_page_fault+0x26/0x30
[42467.285663] RIP: 0033:0x55ab1f9e1e6d
[42467.288291] RSP: 002b:00007f330c1a6550 EFLAGS: 00010206
[42467.290946] RAX: 00007f331af70018 RBX: 00007f30e39721e0 RCX: 0000000000000000
[42467.293675] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f30e39721e8
[42467.296456] RBP: 0000000000000000 R08: 00007f330c1a6540 R09: 00007f331bb85000
[42467.299246] R10: 0000000000000000 R11: 0000000001434d12 R12: 0000000000000016
[42467.302012] R13: 0000000000000000 R14: 000055ab1facbd20 R15: 00007f330c1a7340
[42467.304787]  </TASK>
[42467.307528] task:cache-worker    state:D stack:0     pid:1073599 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42467.310498] Call Trace:
[42467.313433]  <TASK>
[42467.316335]  __schedule+0x581/0x10b0
[42467.319246]  schedule+0x28/0xa0
[42467.322101]  schedule_preempt_disabled+0x16/0x30
[42467.324974]  rwsem_down_write_slowpath+0x2d8/0x750
[42467.327858]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42467.330788]  down_write+0x5c/0x60
[42467.333649]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42467.336537]  file_update_time_flags+0x7e/0x130
[42467.339291]  __xfs_write_fault+0x8c/0x260 [xfs]
[42467.341990]  do_page_mkwrite+0x4a/0xa0
[42467.344672]  do_wp_page+0x136/0x1160
[42467.347354]  ? restore_fpregs_from_fpstate+0x3c/0xa0
[42467.350074]  ? switch_fpu_return+0x5d/0xe0
[42467.352807]  __handle_mm_fault+0xb5a/0x1170
[42467.355541]  ? lock_vma_under_rcu+0x92/0x160
[42467.358282]  handle_mm_fault+0xe3/0x300
[42467.361023]  do_user_addr_fault+0x202/0x690
[42467.363776]  exc_page_fault+0x73/0x150
[42467.366530]  asm_exc_page_fault+0x26/0x30
[42467.369280] RIP: 0033:0x55ab1f9e1e6d
[42467.372007] RSP: 002b:00007f31b8ee8550 EFLAGS: 00010206
[42467.374749] RAX: 00007f331af70018 RBX: 00007f325e211a90 RCX: 0000000000000000
[42467.377555] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f325e211a98
[42467.380360] RBP: 0000000000000000 R08: 00007f31b8ee8540 R09: 00007f331bb85000
[42467.383148] R10: 0000000000000000 R11: 0000000001434d1e R12: 0000000000000016
[42467.385923] R13: 0000000000000000 R14: 000055ab1facbd20 R15: 00007f31b8ee9340
[42467.388698]  </TASK>
[42467.391437] task:cache-worker    state:D stack:0     pid:1073618 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42467.394403] Call Trace:
[42467.397323]  <TASK>
[42467.400218]  __schedule+0x581/0x10b0
[42467.403128]  schedule+0x28/0xa0
[42467.406022]  schedule_preempt_disabled+0x16/0x30
[42467.408935]  rwsem_down_write_slowpath+0x2d8/0x750
[42467.411860]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42467.414827]  down_write+0x5c/0x60
[42467.417745]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42467.420739]  file_update_time_flags+0x7e/0x130
[42467.423686]  __xfs_write_fault+0x8c/0x260 [xfs]
[42467.426636]  do_page_mkwrite+0x4a/0xa0
[42467.429537]  do_wp_page+0x136/0x1160
[42467.432422]  ? do_syscall_64+0x25a/0x550
[42467.435312]  __handle_mm_fault+0xb5a/0x1170
[42467.438202]  ? lock_vma_under_rcu+0x92/0x160
[42467.441051]  handle_mm_fault+0xe3/0x300
[42467.443798]  do_user_addr_fault+0x202/0x690
[42467.446454]  exc_page_fault+0x73/0x150
[42467.449134]  asm_exc_page_fault+0x26/0x30
[42467.451820] RIP: 0033:0x55ab1f9e1e6d
[42467.454507] RSP: 002b:00007f3252f53550 EFLAGS: 00010206
[42467.457231] RAX: 00007f331af70018 RBX: 00007f3121c21aa0 RCX: 0000000000000000
[42467.460018] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f3121c21aa8
[42467.462805] RBP: 0000000000000000 R08: 00007f3252f53540 R09: 00007f331bb85000
[42467.465589] R10: 0000000000000000 R11: 0000000001434d2a R12: 0000000000000016
[42467.468364] R13: 0000000000000000 R14: 000055ab1facbd20 R15: 00007f3252f54340
[42467.471122]  </TASK>
[42467.473858] task:cache-worker    state:D stack:0     pid:1073635 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42467.476820] Call Trace:
[42467.479745]  <TASK>
[42467.482621]  __schedule+0x581/0x10b0
[42467.485512]  schedule+0x28/0xa0
[42467.488386]  schedule_preempt_disabled+0x16/0x30
[42467.491275]  rwsem_down_write_slowpath+0x2d8/0x750
[42467.494173]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42467.497123]  down_write+0x5c/0x60
[42467.500010]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42467.502968]  file_update_time_flags+0x7e/0x130
[42467.505900]  __xfs_write_fault+0x8c/0x260 [xfs]
[42467.508867]  do_page_mkwrite+0x4a/0xa0
[42467.511751]  do_wp_page+0x136/0x1160
[42467.514605]  ? do_syscall_64+0xf9/0x550
[42467.517465]  ? do_vfs_ioctl+0x475/0x940
[42467.520307]  __handle_mm_fault+0xb5a/0x1170
[42467.523160]  ? __x64_sys_ioctl+0xb0/0xe0
[42467.525954]  ? lock_vma_under_rcu+0x92/0x160
[42467.528660]  handle_mm_fault+0xe3/0x300
[42467.531265]  do_user_addr_fault+0x202/0x690
[42467.533895]  exc_page_fault+0x73/0x150
[42467.536530]  asm_exc_page_fault+0x26/0x30
[42467.539176] RIP: 0033:0x55ab1f9e1e6d
[42467.541814] RSP: 002b:00007f33102c2550 EFLAGS: 00010206
[42467.544482] RAX: 00007f331af70018 RBX: 00007f3109e13de0 RCX: 0000000000000000
[42467.547206] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f3109e13de8
[42467.549930] RBP: 0000000000000000 R08: 00007f33102c2540 R09: 00007f331bb85000
[42467.552648] R10: 0000000000000000 R11: 0000000001434d26 R12: 0000000000000016
[42467.555354] R13: 0000000000000000 R14: 000055ab1facbd20 R15: 00007f33102c3340
[42467.558055]  </TASK>
[42467.560727] task:cache-worker    state:D stack:0     pid:1073637 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42467.563643] Call Trace:
[42467.566513]  <TASK>
[42467.569356]  __schedule+0x581/0x10b0
[42467.572215]  schedule+0x28/0xa0
[42467.575053]  schedule_preempt_disabled+0x16/0x30
[42467.577919]  rwsem_down_write_slowpath+0x2d8/0x750
[42467.580791]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42467.583716]  down_write+0x5c/0x60
[42467.586582]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42467.589513]  file_update_time_flags+0x7e/0x130
[42467.592372]  __xfs_write_fault+0x8c/0x260 [xfs]
[42467.595259]  do_page_mkwrite+0x4a/0xa0
[42467.598098]  do_wp_page+0x136/0x1160
[42467.600929]  __handle_mm_fault+0xb5a/0x1170
[42467.603778]  ? lock_vma_under_rcu+0x92/0x160
[42467.606580]  handle_mm_fault+0xe3/0x300
[42467.609285]  do_user_addr_fault+0x202/0x690
[42467.611900]  exc_page_fault+0x73/0x150
[42467.614530]  asm_exc_page_fault+0x26/0x30
[42467.617169] RIP: 0033:0x55ab1f9e1e6d
[42467.619808] RSP: 002b:00007f31b7a81550 EFLAGS: 00010206
[42467.622480] RAX: 00007f331af70018 RBX: 00007f32c5212940 RCX: 0000000000000000
[42467.625219] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f32c5212948
[42467.627959] RBP: 0000000000000000 R08: 00007f31b7a81540 R09: 00007f331bb85000
[42467.630688] R10: 0000000000000000 R11: 0000000001434e08 R12: 0000000000000016
[42467.633413] R13: 0000000000000000 R14: 000055ab1facbd20 R15: 00007f31b7a82340
[42467.636128]  </TASK>
[42467.638807] task:cache-worker    state:D stack:0     pid:1073642 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42467.641721] Call Trace:
[42467.644600]  <TASK>
[42467.647452]  __schedule+0x581/0x10b0
[42467.650335]  schedule+0x28/0xa0
[42467.653204]  schedule_preempt_disabled+0x16/0x30
[42467.656096]  rwsem_down_write_slowpath+0x2d8/0x750
[42467.658998]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42467.661952]  down_write+0x5c/0x60
[42467.664852]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42467.667819]  file_update_time_flags+0x7e/0x130
[42467.670749]  __xfs_write_fault+0x8c/0x260 [xfs]
[42467.673723]  do_page_mkwrite+0x4a/0xa0
[42467.676643]  do_wp_page+0x136/0x1160
[42467.679514]  ? restore_fpregs_from_fpstate+0x3c/0xa0
[42467.682406]  __handle_mm_fault+0xb5a/0x1170
[42467.685307]  ? __x64_sys_ioctl+0xb0/0xe0
[42467.688199]  ? lock_vma_under_rcu+0x92/0x160
[42467.691094]  handle_mm_fault+0xe3/0x300
[42467.693942]  do_user_addr_fault+0x202/0x690
[42467.696696]  exc_page_fault+0x73/0x150
[42467.699354]  asm_exc_page_fault+0x26/0x30
[42467.702033] RIP: 0033:0x55ab1f9e1e6d
[42467.704721] RSP: 002b:00007f324ba81550 EFLAGS: 00010206
[42467.707453] RAX: 00007f331af70018 RBX: 00007f316ee179e0 RCX: 0000000000000000
[42467.710245] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f316ee179e8
[42467.713050] RBP: 0000000000000000 R08: 00007f324ba81540 R09: 00007f331bb85000
[42467.715841] R10: 0000000000000000 R11: 0000000001434d40 R12: 0000000000000016
[42467.718621] R13: 0000000000000000 R14: 000055ab1facbd20 R15: 00007f324ba82340
[42467.721391]  </TASK>
[42467.724123] task:cache-worker    state:D stack:0     pid:1073655 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42467.727083] Call Trace:
[42467.729997]  <TASK>
[42467.732887]  __schedule+0x581/0x10b0
[42467.735790]  schedule+0x28/0xa0
[42467.738671]  schedule_preempt_disabled+0x16/0x30
[42467.741577]  rwsem_down_write_slowpath+0x2d8/0x750
[42467.744492]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42467.747457]  down_write+0x5c/0x60
[42467.750365]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42467.753342]  file_update_time_flags+0x7e/0x130
[42467.756281]  __xfs_write_fault+0x8c/0x260 [xfs]
[42467.759224]  do_page_mkwrite+0x4a/0xa0
[42467.762104]  do_wp_page+0x136/0x1160
[42467.764980]  __handle_mm_fault+0xb5a/0x1170
[42467.767863]  ? lock_vma_under_rcu+0x92/0x160
[42467.770749]  handle_mm_fault+0xe3/0x300
[42467.773586]  do_user_addr_fault+0x202/0x690
[42467.776332]  exc_page_fault+0x73/0x150
[42467.778976]  asm_exc_page_fault+0x26/0x30
[42467.781647] RIP: 0033:0x55ab1f9e1e6d
[42467.784319] RSP: 002b:00007f330b300550 EFLAGS: 00010206
[42467.787029] RAX: 00007f331af70018 RBX: 00007f311d38c690 RCX: 0000000000000000
[42467.789814] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f311d38c698
[42467.792601] RBP: 0000000000000000 R08: 00007f330b300540 R09: 00007f331bb85000
[42467.795376] R10: 0000000000000000 R11: 0000000001434d84 R12: 0000000000000016
[42467.798138] R13: 0000000000000000 R14: 000055ab1facbd20 R15: 00007f330b301340
[42467.800897]  </TASK>
[42467.803617] task:cache-worker    state:D stack:0     pid:1073657 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42467.806569] Call Trace:
[42467.809474]  <TASK>
[42467.812358]  __schedule+0x581/0x10b0
[42467.815246]  schedule+0x28/0xa0
[42467.818099]  schedule_preempt_disabled+0x16/0x30
[42467.820985]  rwsem_down_write_slowpath+0x2d8/0x750
[42467.823880]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42467.826821]  down_write+0x5c/0x60
[42467.829709]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42467.832668]  file_update_time_flags+0x7e/0x130
[42467.835594]  __xfs_write_fault+0x8c/0x260 [xfs]
[42467.838556]  do_page_mkwrite+0x4a/0xa0
[42467.841468]  do_wp_page+0x136/0x1160
[42467.844333]  ? tomoyo_path_number_perm+0x8f/0x1f0
[42467.847216]  __handle_mm_fault+0xb5a/0x1170
[42467.850096]  ? lock_vma_under_rcu+0x92/0x160
[42467.852980]  handle_mm_fault+0xe3/0x300
[42467.855860]  do_user_addr_fault+0x202/0x690
[42467.858696]  exc_page_fault+0x73/0x150
[42467.861436]  asm_exc_page_fault+0x26/0x30
[42467.864082] RIP: 0033:0x55ab1f9e1e6d
[42467.866742] RSP: 002b:00007f3312ddb550 EFLAGS: 00010206
[42467.869447] RAX: 00007f331af70018 RBX: 00007f32cafa7870 RCX: 0000000000000000
[42467.872225] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f32cafa7878
[42467.875015] RBP: 0000000000000000 R08: 00007f3312ddb540 R09: 00007f331bb85000
[42467.877802] R10: 0000000000000000 R11: 0000000001434dbe R12: 0000000000000016
[42467.880578] R13: 0000000000000000 R14: 000055ab1facbd20 R15: 00007f3312ddc340
[42467.883347]  </TASK>
[42467.886075] task:cache-worker    state:D stack:0     pid:1073671 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42467.889032] Call Trace:
[42467.891941]  <TASK>
[42467.894814]  __schedule+0x581/0x10b0
[42467.897717]  schedule+0x28/0xa0
[42467.900600]  schedule_preempt_disabled+0x16/0x30
[42467.903505]  rwsem_down_write_slowpath+0x2d8/0x750
[42467.906415]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42467.909369]  down_write+0x5c/0x60
[42467.912270]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42467.915242]  file_update_time_flags+0x7e/0x130
[42467.918179]  __xfs_write_fault+0x8c/0x260 [xfs]
[42467.921150]  do_page_mkwrite+0x4a/0xa0
[42467.924045]  do_wp_page+0x136/0x1160
[42467.926912]  __handle_mm_fault+0xb5a/0x1170
[42467.929800]  ? switch_fpu_return+0x5d/0xe0
[42467.932685]  ? lock_vma_under_rcu+0x92/0x160
[42467.935578]  handle_mm_fault+0xe3/0x300
[42467.938410]  do_user_addr_fault+0x202/0x690
[42467.941158]  exc_page_fault+0x73/0x150
[42467.943808]  asm_exc_page_fault+0x26/0x30
[42467.946477] RIP: 0033:0x55ab1f9e1e6d
[42467.949152] RSP: 002b:00007f32ce729550 EFLAGS: 00010206
[42467.951866] RAX: 00007f331af70018 RBX: 00007f30fc40a7b0 RCX: 0000000000000000
[42467.954647] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f30fc40a7b8
[42467.957433] RBP: 0000000000000000 R08: 00007f32ce729540 R09: 00007f331bb85000
[42467.960208] R10: 0000000000000000 R11: 0000000001434d4c R12: 0000000000000016
[42467.962975] R13: 0000000000000000 R14: 000055ab1facbd20 R15: 00007f32ce72a340
[42467.965736]  </TASK>
[42467.968454] task:cache-worker    state:D stack:0     pid:1073672 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42467.971408] Call Trace:
[42467.974308]  <TASK>
[42467.977189]  __schedule+0x581/0x10b0
[42467.980075]  schedule+0x28/0xa0
[42467.982934]  schedule_preempt_disabled+0x16/0x30
[42467.985817]  rwsem_down_write_slowpath+0x2d8/0x750
[42467.988708]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42467.991642]  down_write+0x5c/0x60
[42467.994525]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42467.997476]  file_update_time_flags+0x7e/0x130
[42468.000400]  __xfs_write_fault+0x8c/0x260 [xfs]
[42468.003360]  do_page_mkwrite+0x4a/0xa0
[42468.006237]  do_wp_page+0x136/0x1160
[42468.009094]  ? restore_fpregs_from_fpstate+0x3c/0xa0
[42468.011987]  __handle_mm_fault+0xb5a/0x1170
[42468.014880]  ? lock_vma_under_rcu+0x92/0x160
[42468.017780]  handle_mm_fault+0xe3/0x300
[42468.020626]  do_user_addr_fault+0x202/0x690
[42468.023381]  exc_page_fault+0x73/0x150
[42468.026036]  asm_exc_page_fault+0x26/0x30
[42468.028724] RIP: 0033:0x55ab1f9e1e6d
[42468.031406] RSP: 002b:00007f3252eab550 EFLAGS: 00010206
[42468.034129] RAX: 00007f331af70018 RBX: 00007f30fae12460 RCX: 0000000000000000
[42468.036922] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f30fae12468
[42468.039719] RBP: 0000000000000000 R08: 00007f3252eab540 R09: 00007f331bb85000
[42468.042503] R10: 0000000000000000 R11: 0000000001434d4a R12: 0000000000000016
[42468.045287] R13: 0000000000000000 R14: 000055ab1facbd20 R15: 00007f3252eac340
[42468.048059]  </TASK>
[42468.050786] task:cache-worker    state:D stack:0     pid:1073673 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42468.053753] Call Trace:
[42468.056669]  <TASK>
[42468.059564]  __schedule+0x581/0x10b0
[42468.062468]  schedule+0x28/0xa0
[42468.065360]  schedule_preempt_disabled+0x16/0x30
[42468.068273]  rwsem_down_write_slowpath+0x2d8/0x750
[42468.071197]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42468.074162]  down_write+0x5c/0x60
[42468.077076]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42468.080059]  file_update_time_flags+0x7e/0x130
[42468.083010]  __xfs_write_fault+0x8c/0x260 [xfs]
[42468.085996]  do_page_mkwrite+0x4a/0xa0
[42468.088902]  do_wp_page+0x136/0x1160
[42468.091785]  __handle_mm_fault+0xb5a/0x1170
[42468.094679]  ? restore_fpregs_from_fpstate+0x3c/0xa0
[42468.097602]  ? lock_vma_under_rcu+0x92/0x160
[42468.100523]  handle_mm_fault+0xe3/0x300
[42468.103395]  do_user_addr_fault+0x202/0x690
[42468.106173]  exc_page_fault+0x73/0x150
[42468.108857]  asm_exc_page_fault+0x26/0x30
[42468.111566] RIP: 0033:0x55ab1f9e1e6d
[42468.114276] RSP: 002b:00007f32cf6ea550 EFLAGS: 00010206
[42468.117027] RAX: 00007f331af70018 RBX: 00007f30fd828fe0 RCX: 0000000000000000
[42468.119847] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f30fd828fe8
[42468.122666] RBP: 0000000000000000 R08: 00007f32cf6ea540 R09: 00007f331bb85000
[42468.125481] R10: 0000000000000000 R11: 0000000001434d28 R12: 0000000000000016
[42468.128286] R13: 0000000000000000 R14: 000055ab1facbd20 R15: 00007f32cf6eb340
[42468.131076]  </TASK>
[42468.133842] task:cache-worker    state:D stack:0     pid:1073866 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42468.136827] Call Trace:
[42468.139761]  <TASK>
[42468.142670]  __schedule+0x581/0x10b0
[42468.145586]  schedule+0x28/0xa0
[42468.148470]  schedule_preempt_disabled+0x16/0x30
[42468.151373]  rwsem_down_write_slowpath+0x2d8/0x750
[42468.154287]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42468.157242]  down_write+0x5c/0x60
[42468.160148]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42468.163117]  file_update_time_flags+0x7e/0x130
[42468.166062]  __xfs_write_fault+0x8c/0x260 [xfs]
[42468.169035]  do_page_mkwrite+0x4a/0xa0
[42468.171931]  do_wp_page+0x136/0x1160
[42468.174800]  ? do_syscall_64+0x25a/0x550
[42468.177677]  ? __x64_sys_ioctl+0xb0/0xe0
[42468.180545]  __handle_mm_fault+0xb5a/0x1170
[42468.183418]  ? lock_vma_under_rcu+0x92/0x160
[42468.186247]  handle_mm_fault+0xe3/0x300
[42468.188975]  do_user_addr_fault+0x202/0x690
[42468.191615]  exc_page_fault+0x73/0x150
[42468.194270]  asm_exc_page_fault+0x26/0x30
[42468.196940] RIP: 0033:0x55ab1f9e1e6d
[42468.199609] RSP: 002b:00007f32eda2b550 EFLAGS: 00010206
[42468.202309] RAX: 00007f331af70018 RBX: 00007f324b600280 RCX: 0000000000000000
[42468.205072] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f324b600288
[42468.207833] RBP: 0000000000000000 R08: 00007f32eda2b540 R09: 00007f331bb85000
[42468.210582] R10: 0000000000000000 R11: 0000000001434d66 R12: 0000000000000016
[42468.213331] R13: 0000000000000000 R14: 000055ab1facbd20 R15: 00007f32eda2c340
[42468.216066]  </TASK>
[42468.218767] task:cache-worker    state:D stack:0     pid:1073876 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42468.221700] Call Trace:
[42468.224596]  <TASK>
[42468.227461]  __schedule+0x581/0x10b0
[42468.230326]  schedule+0x28/0xa0
[42468.233173]  schedule_preempt_disabled+0x16/0x30
[42468.236039]  rwsem_down_write_slowpath+0x2d8/0x750
[42468.238910]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42468.241822]  down_write+0x5c/0x60
[42468.244692]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42468.247621]  file_update_time_flags+0x7e/0x130
[42468.250516]  __xfs_write_fault+0x8c/0x260 [xfs]
[42468.253410]  do_page_mkwrite+0x4a/0xa0
[42468.256256]  do_wp_page+0x136/0x1160
[42468.259089]  __handle_mm_fault+0xb5a/0x1170
[42468.261938]  ? lock_vma_under_rcu+0x92/0x160
[42468.264795]  handle_mm_fault+0xe3/0x300
[42468.267598]  do_user_addr_fault+0x202/0x690
[42468.270306]  exc_page_fault+0x73/0x150
[42468.272922]  asm_exc_page_fault+0x26/0x30
[42468.275560] RIP: 0033:0x55ab1f9e1e6d
[42468.278196] RSP: 002b:00007f3312fd3550 EFLAGS: 00010206
[42468.280878] RAX: 00007f331af70018 RBX: 00007f316c613e30 RCX: 0000000000000000
[42468.283629] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f316c613e38
[42468.286384] RBP: 0000000000000000 R08: 00007f3312fd3540 R09: 00007f331bb85000
[42468.289132] R10: 0000000000000000 R11: 0000000001434d20 R12: 0000000000000016
[42468.291871] R13: 0000000000000000 R14: 000055ab1facbd20 R15: 00007f3312fd4340
[42468.294597]  </TASK>
[42468.297289] task:cache-worker    state:D stack:0     pid:1073880 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42468.300213] Call Trace:
[42468.303085]  <TASK>
[42468.305943]  __schedule+0x581/0x10b0
[42468.308817]  schedule+0x28/0xa0
[42468.311683]  schedule_preempt_disabled+0x16/0x30
[42468.314570]  rwsem_down_write_slowpath+0x2d8/0x750
[42468.317468]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42468.320405]  down_write+0x5c/0x60
[42468.323296]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42468.326247]  file_update_time_flags+0x7e/0x130
[42468.329176]  __xfs_write_fault+0x8c/0x260 [xfs]
[42468.332144]  do_page_mkwrite+0x4a/0xa0
[42468.335059]  do_wp_page+0x136/0x1160
[42468.337931]  __handle_mm_fault+0xb5a/0x1170
[42468.340805]  ? lock_vma_under_rcu+0x92/0x160
[42468.343686]  handle_mm_fault+0xe3/0x300
[42468.346555]  do_user_addr_fault+0x202/0x690
[42468.349438]  exc_page_fault+0x73/0x150
[42468.352268]  asm_exc_page_fault+0x26/0x30
[42468.355001] RIP: 0033:0x55ab1f9e1e6d
[42468.357638] RSP: 002b:00007f31b50be530 EFLAGS: 00010206
[42468.360330] RAX: 00007f331af70018 RBX: 00007f3175676490 RCX: 0000000000000000
[42468.363092] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f3175676498
[42468.365882] RBP: 0000000000000000 R08: 00007f31b50be540 R09: 00007f331bb85000
[42468.368666] R10: 0000000000000000 R11: 00000000014355ea R12: 0000000000000016
[42468.371445] R13: 000055ab1facc058 R14: 00007f325e9b4028 R15: 00007f31b50be820
[42468.374226]  </TASK>
[42468.376975] task:cache-worker    state:D stack:0     pid:1073903 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42468.379952] Call Trace:
[42468.382869]  <TASK>
[42468.385761]  __schedule+0x581/0x10b0
[42468.388662]  schedule+0x28/0xa0
[42468.391553]  schedule_preempt_disabled+0x16/0x30
[42468.394462]  rwsem_down_write_slowpath+0x2d8/0x750
[42468.397380]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42468.400339]  down_write+0x5c/0x60
[42468.403253]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42468.406224]  file_update_time_flags+0x7e/0x130
[42468.409175]  __xfs_write_fault+0x8c/0x260 [xfs]
[42468.412165]  do_page_mkwrite+0x4a/0xa0
[42468.415098]  do_wp_page+0x136/0x1160
[42468.417987]  __handle_mm_fault+0xb5a/0x1170
[42468.420872]  ? lock_vma_under_rcu+0x92/0x160
[42468.423764]  handle_mm_fault+0xe3/0x300
[42468.426645]  do_user_addr_fault+0x202/0x690
[42468.429541]  exc_page_fault+0x73/0x150
[42468.432388]  asm_exc_page_fault+0x26/0x30
[42468.435135] RIP: 0033:0x55ab1f9e1e6d
[42468.437784] RSP: 002b:00007f32cc218550 EFLAGS: 00010206
[42468.440487] RAX: 00007f331af70018 RBX: 00007f3254407500 RCX: 0000000000000000
[42468.443264] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f3254407508
[42468.446055] RBP: 0000000000000000 R08: 00007f32cc218540 R09: 00007f331bb85000
[42468.448850] R10: 0000000000000000 R11: 0000000001434d34 R12: 0000000000000016
[42468.451636] R13: 0000000000000000 R14: 000055ab1facbd20 R15: 00007f32cc219340
[42468.454409]  </TASK>
[42468.457149] task:cache-worker    state:D stack:0     pid:1073904 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42468.460115] Call Trace:
[42468.463024]  <TASK>
[42468.465908]  __schedule+0x581/0x10b0
[42468.468801]  schedule+0x28/0xa0
[42468.471688]  schedule_preempt_disabled+0x16/0x30
[42468.474590]  rwsem_down_write_slowpath+0x2d8/0x750
[42468.477499]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42468.480452]  down_write+0x5c/0x60
[42468.483354]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42468.486312]  file_update_time_flags+0x7e/0x130
[42468.489251]  __xfs_write_fault+0x8c/0x260 [xfs]
[42468.492226]  do_page_mkwrite+0x4a/0xa0
[42468.495152]  do_wp_page+0x136/0x1160
[42468.498026]  __handle_mm_fault+0xb5a/0x1170
[42468.500900]  ? restore_fpregs_from_fpstate+0x3c/0xa0
[42468.503808]  ? lock_vma_under_rcu+0x92/0x160
[42468.506712]  handle_mm_fault+0xe3/0x300
[42468.509598]  do_user_addr_fault+0x202/0x690
[42468.512441]  exc_page_fault+0x73/0x150
[42468.515189]  asm_exc_page_fault+0x26/0x30
[42468.517840] RIP: 0033:0x55ab1f9e1e6d
[42468.520512] RSP: 002b:00007f33102ad550 EFLAGS: 00010206
[42468.523224] RAX: 00007f331af70018 RBX: 00007f329360e1a0 RCX: 0000000000000000
[42468.526009] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f329360e1a8
[42468.528811] RBP: 0000000000000000 R08: 00007f33102ad540 R09: 00007f331bb85000
[42468.531604] R10: 0000000000000000 R11: 0000000001434e08 R12: 0000000000000016
[42468.534388] R13: 0000000000000000 R14: 000055ab1facbd20 R15: 00007f33102ae340
[42468.537165]  </TASK>
[42468.539915] task:cache-worker    state:D stack:0     pid:1074068 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42468.542873] Call Trace:
[42468.545790]  <TASK>
[42468.548673]  __schedule+0x581/0x10b0
[42468.551578]  schedule+0x28/0xa0
[42468.554464]  schedule_preempt_disabled+0x16/0x30
[42468.557374]  rwsem_down_write_slowpath+0x2d8/0x750
[42468.560289]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42468.563247]  down_write+0x5c/0x60
[42468.566152]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42468.569127]  file_update_time_flags+0x7e/0x130
[42468.572071]  __xfs_write_fault+0x8c/0x260 [xfs]
[42468.575044]  do_page_mkwrite+0x4a/0xa0
[42468.577941]  do_wp_page+0x136/0x1160
[42468.580816]  ? switch_fpu_return+0x5d/0xe0
[42468.583705]  ? do_syscall_64+0x25a/0x550
[42468.586583]  __handle_mm_fault+0xb5a/0x1170
[42468.589474]  ? do_vfs_ioctl+0x475/0x940
[42468.592313]  ? lock_vma_under_rcu+0x92/0x160
[42468.595060]  handle_mm_fault+0xe3/0x300
[42468.597708]  do_user_addr_fault+0x202/0x690
[42468.600384]  exc_page_fault+0x73/0x150
[42468.603063]  asm_exc_page_fault+0x26/0x30
[42468.605755] RIP: 0033:0x55ab1f9e1e6d
[42468.608440] RSP: 002b:00007f32ce6575c0 EFLAGS: 00010206
[42468.611152] RAX: 00007f331af6f018 RBX: 00007f331b024f20 RCX: 0000000000000000
[42468.613919] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f331b024f28
[42468.616696] RBP: 0000000000000000 R08: 0000000000000073 R09: 00000000ffffffff
[42468.619455] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000016
[42468.622185] R13: 00007f331b03f918 R14: 00007f32ce658340 R15: 000055ab1fafd9c0
[42468.624930]  </TASK>
[42468.627637] task:cache-worker    state:D stack:0     pid:1074073 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42468.630585] Call Trace:
[42468.633496]  <TASK>
[42468.636361]  __schedule+0x581/0x10b0
[42468.639234]  schedule+0x28/0xa0
[42468.642084]  schedule_preempt_disabled+0x16/0x30
[42468.644957]  rwsem_down_write_slowpath+0x2d8/0x750
[42468.647836]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42468.650758]  down_write+0x5c/0x60
[42468.653640]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42468.656575]  file_update_time_flags+0x7e/0x130
[42468.659443]  __xfs_write_fault+0x8c/0x260 [xfs]
[42468.662333]  do_page_mkwrite+0x4a/0xa0
[42468.665188]  do_wp_page+0x136/0x1160
[42468.668028]  __handle_mm_fault+0xb5a/0x1170
[42468.670877]  ? restore_fpregs_from_fpstate+0x3c/0xa0
[42468.673712]  ? switch_fpu_return+0x5d/0xe0
[42468.676450]  ? lock_vma_under_rcu+0x92/0x160
[42468.679093]  handle_mm_fault+0xe3/0x300
[42468.681752]  do_user_addr_fault+0x202/0x690
[42468.684425]  exc_page_fault+0x73/0x150
[42468.687100]  asm_exc_page_fault+0x26/0x30
[42468.689780] RIP: 0033:0x55ab1f9e1e6d
[42468.692448] RSP: 002b:00007f32cc353550 EFLAGS: 00010206
[42468.695136] RAX: 00007f331af70018 RBX: 00007f3256235230 RCX: 0000000000000000
[42468.697887] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f3256235238
[42468.700642] RBP: 0000000000000000 R08: 00007f32cc353540 R09: 00007f331bb85000
[42468.703391] R10: 0000000000000000 R11: 0000000001434d50 R12: 0000000000000016
[42468.706133] R13: 0000000000000000 R14: 000055ab1facbd20 R15: 00007f32cc354340
[42468.708871]  </TASK>
[42468.711587] task:cache-worker    state:D stack:0     pid:1074074 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42468.714535] Call Trace:
[42468.717447]  <TASK>
[42468.720324]  __schedule+0x581/0x10b0
[42468.723219]  schedule+0x28/0xa0
[42468.726097]  schedule_preempt_disabled+0x16/0x30
[42468.729004]  rwsem_down_write_slowpath+0x2d8/0x750
[42468.731917]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42468.734869]  down_write+0x5c/0x60
[42468.737779]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42468.740747]  file_update_time_flags+0x7e/0x130
[42468.743678]  __xfs_write_fault+0x8c/0x260 [xfs]
[42468.746608]  do_page_mkwrite+0x4a/0xa0
[42468.749485]  do_wp_page+0x136/0x1160
[42468.752360]  ? restore_fpregs_from_fpstate+0x3c/0xa0
[42468.755291]  ? switch_fpu_return+0x5d/0xe0
[42468.758203]  __handle_mm_fault+0xb5a/0x1170
[42468.761075]  ? lock_vma_under_rcu+0x92/0x160
[42468.763859]  handle_mm_fault+0xe3/0x300
[42468.766535]  do_user_addr_fault+0x202/0x690
[42468.769244]  exc_page_fault+0x73/0x150
[42468.771955]  asm_exc_page_fault+0x26/0x30
[42468.774673] RIP: 0033:0x55ab1f9e1e6d
[42468.777393] RSP: 002b:00007f32cc2d5530 EFLAGS: 00010206
[42468.780134] RAX: 00007f331af70018 RBX: 00007f316e636750 RCX: 0000000000000000
[42468.782932] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f316e636758
[42468.785739] RBP: 0000000000000000 R08: 00007f32cc2d5540 R09: 00007f331bb85000
[42468.788533] R10: 0000000000000000 R11: 000000000143528a R12: 0000000000000016
[42468.791317] R13: 000055ab1facc058 R14: 00007f329d8662a8 R15: 00007f32cc2d5820
[42468.794110]  </TASK>
[42468.796876] task:cache-worker    state:D stack:0     pid:1074084 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42468.799885] Call Trace:
[42468.802841]  <TASK>
[42468.805756]  __schedule+0x581/0x10b0
[42468.808678]  schedule+0x28/0xa0
[42468.811586]  schedule_preempt_disabled+0x16/0x30
[42468.814514]  rwsem_down_write_slowpath+0x2d8/0x750
[42468.817453]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42468.820432]  down_write+0x5c/0x60
[42468.823368]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42468.826363]  file_update_time_flags+0x7e/0x130
[42468.829322]  __xfs_write_fault+0x8c/0x260 [xfs]
[42468.832286]  do_page_mkwrite+0x4a/0xa0
[42468.835193]  do_wp_page+0x136/0x1160
[42468.838087]  ? restore_fpregs_from_fpstate+0x3c/0xa0
[42468.841023]  ? switch_fpu_return+0x5d/0xe0
[42468.843960]  __handle_mm_fault+0xb5a/0x1170
[42468.846846]  ? lock_vma_under_rcu+0x92/0x160
[42468.849643]  handle_mm_fault+0xe3/0x300
[42468.852337]  do_user_addr_fault+0x202/0x690
[42468.855059]  exc_page_fault+0x73/0x150
[42468.857786]  asm_exc_page_fault+0x26/0x30
[42468.860521] RIP: 0033:0x55ab1f9e1e6d
[42468.863252] RSP: 002b:00007f329f17d550 EFLAGS: 00010206
[42468.866006] RAX: 00007f331af70018 RBX: 00007f3246000050 RCX: 0000000000000000
[42468.868821] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f3246000058
[42468.871628] RBP: 0000000000000000 R08: 00007f329f17d540 R09: 00007f331bb85000
[42468.874423] R10: 0000000000000000 R11: 0000000001434de0 R12: 0000000000000016
[42468.877213] R13: 0000000000000000 R14: 000055ab1facbd20 R15: 00007f329f17e340
[42468.879996]  </TASK>
[42468.882746] task:cache-worker    state:D stack:0     pid:1074091 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42468.885736] Call Trace:
[42468.888665]  <TASK>
[42468.891553]  __schedule+0x581/0x10b0
[42468.894456]  schedule+0x28/0xa0
[42468.897343]  schedule_preempt_disabled+0x16/0x30
[42468.900249]  rwsem_down_write_slowpath+0x2d8/0x750
[42468.903168]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42468.906127]  down_write+0x5c/0x60
[42468.909039]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42468.912014]  file_update_time_flags+0x7e/0x130
[42468.914952]  __xfs_write_fault+0x8c/0x260 [xfs]
[42468.917893]  do_page_mkwrite+0x4a/0xa0
[42468.920781]  do_wp_page+0x136/0x1160
[42468.923659]  ? restore_fpregs_from_fpstate+0x3c/0xa0
[42468.926572]  __handle_mm_fault+0xb5a/0x1170
[42468.929477]  ? lock_vma_under_rcu+0x92/0x160
[42468.932342]  handle_mm_fault+0xe3/0x300
[42468.935100]  do_user_addr_fault+0x202/0x690
[42468.937776]  exc_page_fault+0x73/0x150
[42468.940469]  asm_exc_page_fault+0x26/0x30
[42468.943174] RIP: 0033:0x55ab1f9e1e6d
[42468.945877] RSP: 002b:00007f329d73e530 EFLAGS: 00010206
[42468.948618] RAX: 00007f331af70018 RBX: 00007f32ed609d70 RCX: 0000000000000000
[42468.951417] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f32ed609d78
[42468.954212] RBP: 0000000000000000 R08: 00007f329d73e540 R09: 00007f331bb85000
[42468.957003] R10: 0000000000000000 R11: 000000000143537a R12: 0000000000000016
[42468.959783] R13: 000055ab1facc058 R14: 00007f324b322368 R15: 00007f329d73e820
[42468.962565]  </TASK>
[42468.965322] task:cache-worker    state:D stack:0     pid:1074096 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42468.968308] Call Trace:
[42468.971256]  <TASK>
[42468.974157]  __schedule+0x581/0x10b0
[42468.977068]  schedule+0x28/0xa0
[42468.979960]  schedule_preempt_disabled+0x16/0x30
[42468.982867]  rwsem_down_write_slowpath+0x2d8/0x750
[42468.985790]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42468.988760]  down_write+0x5c/0x60
[42468.991672]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42468.994649]  file_update_time_flags+0x7e/0x130
[42468.997597]  __xfs_write_fault+0x8c/0x260 [xfs]
[42469.000577]  do_page_mkwrite+0x4a/0xa0
[42469.003482]  do_wp_page+0x136/0x1160
[42469.006369]  __handle_mm_fault+0xb5a/0x1170
[42469.009273]  ? lock_vma_under_rcu+0x92/0x160
[42469.012183]  handle_mm_fault+0xe3/0x300
[42469.015086]  do_user_addr_fault+0x202/0x690
[42469.017951]  exc_page_fault+0x73/0x150
[42469.020718]  asm_exc_page_fault+0x26/0x30
[42469.023393] RIP: 0033:0x55ab1f9e1e6d
[42469.026083] RSP: 002b:00007f329b67f550 EFLAGS: 00010206
[42469.028813] RAX: 00007f331af70018 RBX: 00007f30f5a46140 RCX: 0000000000000000
[42469.031618] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f30f5a46148
[42469.034432] RBP: 0000000000000000 R08: 00007f329b67f540 R09: 00007f331bb85000
[42469.037242] R10: 0000000000000000 R11: 0000000001434d1c R12: 0000000000000016
[42469.040041] R13: 0000000000000000 R14: 000055ab1facbd20 R15: 00007f329b680340
[42469.042829]  </TASK>
[42469.045588] task:cache-worker    state:D stack:0     pid:1074120 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42469.048570] Call Trace:
[42469.051501]  <TASK>
[42469.054393]  __schedule+0x581/0x10b0
[42469.057313]  schedule+0x28/0xa0
[42469.060201]  schedule_preempt_disabled+0x16/0x30
[42469.063091]  rwsem_down_write_slowpath+0x2d8/0x750
[42469.065993]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42469.068933]  down_write+0x5c/0x60
[42469.071822]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42469.074774]  file_update_time_flags+0x7e/0x130
[42469.077700]  __xfs_write_fault+0x8c/0x260 [xfs]
[42469.080665]  do_page_mkwrite+0x4a/0xa0
[42469.083586]  do_wp_page+0x136/0x1160
[42469.086453]  ? __x64_sys_ioctl+0xb0/0xe0
[42469.089312]  __handle_mm_fault+0xb5a/0x1170
[42469.092172]  ? __x64_sys_ioctl+0xb0/0xe0
[42469.095024]  ? lock_vma_under_rcu+0x92/0x160
[42469.097872]  handle_mm_fault+0xe3/0x300
[42469.100666]  do_user_addr_fault+0x202/0x690
[42469.103369]  exc_page_fault+0x73/0x150
[42469.105971]  asm_exc_page_fault+0x26/0x30
[42469.108602] RIP: 0033:0x55ab1f9e1e6d
[42469.111233] RSP: 002b:00007f328603e550 EFLAGS: 00010206
[42469.113903] RAX: 00007f331af70018 RBX: 00007f32eb212d50 RCX: 0000000000000000
[42469.116649] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f32eb212d58
[42469.119397] RBP: 0000000000000000 R08: 00007f328603e540 R09: 00007f331bb85000
[42469.122130] R10: 0000000000000000 R11: 0000000001434d5a R12: 0000000000000016
[42469.124863] R13: 0000000000000000 R14: 000055ab1facbd20 R15: 00007f328603f340
[42469.127583]  </TASK>
[42469.130260] task:cache-worker    state:D stack:0     pid:1074128 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42469.133176] Call Trace:
[42469.136038]  <TASK>
[42469.138877]  __schedule+0x581/0x10b0
[42469.141736]  schedule+0x28/0xa0
[42469.144574]  schedule_preempt_disabled+0x16/0x30
[42469.147436]  rwsem_down_write_slowpath+0x2d8/0x750
[42469.150304]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42469.153215]  down_write+0x5c/0x60
[42469.156082]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42469.159007]  file_update_time_flags+0x7e/0x130
[42469.161910]  __xfs_write_fault+0x8c/0x260 [xfs]
[42469.164813]  do_page_mkwrite+0x4a/0xa0
[42469.167658]  do_wp_page+0x136/0x1160
[42469.170489]  ? switch_fpu_return+0x5d/0xe0
[42469.173336]  ? do_syscall_64+0x25a/0x550
[42469.176181]  __handle_mm_fault+0xb5a/0x1170
[42469.178981]  ? lock_vma_under_rcu+0x92/0x160
[42469.181690]  handle_mm_fault+0xe3/0x300
[42469.184301]  do_user_addr_fault+0x202/0x690
[42469.186937]  exc_page_fault+0x73/0x150
[42469.189579]  asm_exc_page_fault+0x26/0x30
[42469.192230] RIP: 0033:0x55ab1f9e1e6d
[42469.194876] RSP: 002b:00007f327e0a9550 EFLAGS: 00010206
[42469.197554] RAX: 00007f331af70018 RBX: 00007f311f9dafa0 RCX: 0000000000000000
[42469.200289] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f311f9dafa8
[42469.203032] RBP: 0000000000000000 R08: 00007f327e0a9540 R09: 00007f331bb85000
[42469.205766] R10: 0000000000000000 R11: 0000000001434d7a R12: 0000000000000016
[42469.208490] R13: 0000000000000000 R14: 000055ab1facbd20 R15: 00007f327e0aa340
[42469.211211]  </TASK>
[42469.213898] task:cache-worker    state:D stack:0     pid:1074177 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42469.216827] Call Trace:
[42469.219714]  <TASK>
[42469.222573]  __schedule+0x581/0x10b0
[42469.225458]  schedule+0x28/0xa0
[42469.228326]  schedule_preempt_disabled+0x16/0x30
[42469.231219]  rwsem_down_write_slowpath+0x2d8/0x750
[42469.234115]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42469.237052]  down_write+0x5c/0x60
[42469.239946]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42469.242901]  file_update_time_flags+0x7e/0x130
[42469.245825]  __xfs_write_fault+0x8c/0x260 [xfs]
[42469.248749]  do_page_mkwrite+0x4a/0xa0
[42469.251617]  do_wp_page+0x136/0x1160
[42469.254477]  ? __seccomp_filter+0x42/0x5c0
[42469.257346]  __handle_mm_fault+0xb5a/0x1170
[42469.260215]  ? do_syscall_64+0xf9/0x550
[42469.263033]  ? lock_vma_under_rcu+0x92/0x160
[42469.265761]  handle_mm_fault+0xe3/0x300
[42469.268387]  do_user_addr_fault+0x202/0x690
[42469.271040]  exc_page_fault+0x73/0x150
[42469.273699]  asm_exc_page_fault+0x26/0x30
[42469.276365] RIP: 0033:0x55ab1f9e1e6d
[42469.279025] RSP: 002b:00007f316d657550 EFLAGS: 00010206
[42469.281715] RAX: 00007f331af70018 RBX: 00007f311205e3a0 RCX: 0000000000000000
[42469.284459] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f311205e3a8
[42469.287207] RBP: 0000000000000000 R08: 00007f316d657540 R09: 00007f331bb85000
[42469.289941] R10: 0000000000000000 R11: 0000000001434df4 R12: 0000000000000016
[42469.292675] R13: 0000000000000000 R14: 000055ab1facbd20 R15: 00007f316d658340
[42469.295401]  </TASK>
[42469.298090] task:cache-worker    state:D stack:0     pid:1074184 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42469.301023] Call Trace:
[42469.303912]  <TASK>
[42469.306773]  __schedule+0x581/0x10b0
[42469.309653]  schedule+0x28/0xa0
[42469.312513]  schedule_preempt_disabled+0x16/0x30
[42469.315394]  rwsem_down_write_slowpath+0x2d8/0x750
[42469.318282]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42469.321212]  down_write+0x5c/0x60
[42469.324096]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42469.327038]  file_update_time_flags+0x7e/0x130
[42469.329950]  __xfs_write_fault+0x8c/0x260 [xfs]
[42469.332861]  ? __seccomp_filter+0x42/0x5c0
[42469.335717]  do_page_mkwrite+0x4a/0xa0
[42469.338570]  do_wp_page+0x136/0x1160
[42469.341415]  ? do_syscall_64+0xf9/0x550
[42469.344264]  __handle_mm_fault+0xb5a/0x1170
[42469.347069]  ? restore_fpregs_from_fpstate+0x3c/0xa0
[42469.349808]  ? lock_vma_under_rcu+0x92/0x160
[42469.352453]  handle_mm_fault+0xe3/0x300
[42469.355113]  do_user_addr_fault+0x202/0x690
[42469.357788]  exc_page_fault+0x73/0x150
[42469.360462]  asm_exc_page_fault+0x26/0x30
[42469.363136] RIP: 0033:0x55ab1f9e1e6d
[42469.365803] RSP: 002b:00007f3126ad3550 EFLAGS: 00010206
[42469.368490] RAX: 00007f331af70018 RBX: 00007f3250e03de0 RCX: 0000000000000000
[42469.371240] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f3250e03de8
[42469.373985] RBP: 0000000000000000 R08: 00007f3126ad3540 R09: 00007f331bb85000
[42469.376727] R10: 0000000000000000 R11: 0000000001434d60 R12: 0000000000000016
[42469.379461] R13: 0000000000000000 R14: 000055ab1facbd20 R15: 00007f3126ad4340
[42469.382185]  </TASK>
[42469.384902] task:cache-worker    state:D stack:0     pid:1074255 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42469.387844] Call Trace:
[42469.390744]  <TASK>
[42469.393614]  __schedule+0x581/0x10b0
[42469.396503]  schedule+0x28/0xa0
[42469.399377]  schedule_preempt_disabled+0x16/0x30
[42469.402269]  rwsem_down_write_slowpath+0x2d8/0x750
[42469.405177]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42469.408124]  down_write+0x5c/0x60
[42469.411021]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42469.413977]  file_update_time_flags+0x7e/0x130
[42469.416870]  __xfs_write_fault+0x8c/0x260 [xfs]
[42469.419789]  do_page_mkwrite+0x4a/0xa0
[42469.422666]  do_wp_page+0x136/0x1160
[42469.425535]  __handle_mm_fault+0xb5a/0x1170
[42469.428418]  ? lock_vma_under_rcu+0x92/0x160
[42469.431260]  handle_mm_fault+0xe3/0x300
[42469.434006]  do_user_addr_fault+0x202/0x690
[42469.436654]  exc_page_fault+0x73/0x150
[42469.439323]  asm_exc_page_fault+0x26/0x30
[42469.441995] RIP: 0033:0x55ab1f9e1e6d
[42469.444676] RSP: 002b:00007f311d4d3550 EFLAGS: 00010206
[42469.447390] RAX: 00007f331af70018 RBX: 00007f30fc40bde0 RCX: 0000000000000000
[42469.450164] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f30fc40bde8
[42469.452944] RBP: 0000000000000000 R08: 00007f311d4d3540 R09: 00007f331bb85000
[42469.455715] R10: 0000000000000000 R11: 0000000001434d4a R12: 0000000000000016
[42469.458471] R13: 0000000000000000 R14: 000055ab1facbd20 R15: 00007f311d4d4340
[42469.461221]  </TASK>
[42469.463937] task:cache-worker    state:D stack:0     pid:1074258 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42469.466882] Call Trace:
[42469.469789]  <TASK>
[42469.472670]  __schedule+0x581/0x10b0
[42469.475576]  schedule+0x28/0xa0
[42469.478456]  schedule_preempt_disabled+0x16/0x30
[42469.481347]  rwsem_down_write_slowpath+0x2d8/0x750
[42469.484236]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42469.487169]  down_write+0x5c/0x60
[42469.490053]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42469.492999]  file_update_time_flags+0x7e/0x130
[42469.495923]  __xfs_write_fault+0x8c/0x260 [xfs]
[42469.498887]  do_page_mkwrite+0x4a/0xa0
[42469.501799]  do_wp_page+0x136/0x1160
[42469.504664]  ? do_syscall_64+0xf9/0x550
[42469.507521]  __handle_mm_fault+0xb5a/0x1170
[42469.510384]  ? lock_vma_under_rcu+0x92/0x160
[42469.513256]  handle_mm_fault+0xe3/0x300
[42469.516125]  do_user_addr_fault+0x202/0x690
[42469.518948]  exc_page_fault+0x73/0x150
[42469.521675]  asm_exc_page_fault+0x26/0x30
[42469.524309] RIP: 0033:0x55ab1f9e1e6d
[42469.526958] RSP: 002b:00007f311d494550 EFLAGS: 00010206
[42469.529658] RAX: 00007f331af70018 RBX: 00007f3292a0f690 RCX: 0000000000000000
[42469.532424] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f3292a0f698
[42469.535208] RBP: 0000000000000000 R08: 00007f311d494540 R09: 00007f331bb85000
[42469.537978] R10: 0000000000000000 R11: 0000000001434d78 R12: 0000000000000016
[42469.540739] R13: 0000000000000000 R14: 000055ab1facbd20 R15: 00007f311d495340
[42469.543490]  </TASK>
[42469.546206] task:cache-worker    state:D stack:0     pid:1091848 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42469.549146] Call Trace:
[42469.552042]  <TASK>
[42469.554899]  __schedule+0x581/0x10b0
[42469.557785]  schedule+0x28/0xa0
[42469.560653]  schedule_preempt_disabled+0x16/0x30
[42469.563541]  rwsem_down_write_slowpath+0x2d8/0x750
[42469.566433]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42469.569368]  down_write+0x5c/0x60
[42469.572254]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42469.575208]  file_update_time_flags+0x7e/0x130
[42469.578127]  __xfs_write_fault+0x8c/0x260 [xfs]
[42469.581078]  do_page_mkwrite+0x4a/0xa0
[42469.583952]  do_wp_page+0x136/0x1160
[42469.586803]  ? restore_fpregs_from_fpstate+0x3c/0xa0
[42469.589698]  ? switch_fpu_return+0x5d/0xe0
[42469.592587]  __handle_mm_fault+0xb5a/0x1170
[42469.595484]  ? lock_vma_under_rcu+0x92/0x160
[42469.598336]  handle_mm_fault+0xe3/0x300
[42469.601088]  do_user_addr_fault+0x202/0x690
[42469.603753]  exc_page_fault+0x73/0x150
[42469.606436]  asm_exc_page_fault+0x26/0x30
[42469.609130] RIP: 0033:0x55ab1f9e1e6d
[42469.611824] RSP: 002b:00007f3313593550 EFLAGS: 00010206
[42469.614552] RAX: 00007f331af70018 RBX: 00007f3304e10320 RCX: 0000000000000000
[42469.617344] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f3304e10328
[42469.620134] RBP: 0000000000000000 R08: 00007f3313593540 R09: 00007f331bb85000
[42469.622909] R10: 0000000000000000 R11: 0000000001434d58 R12: 0000000000000016
[42469.625680] R13: 0000000000000000 R14: 000055ab1facbd20 R15: 00007f3313594340
[42469.628438]  </TASK>
[42469.631171] task:cache-worker    state:D stack:0     pid:1102289 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42469.634127] Call Trace:
[42469.637047]  <TASK>
[42469.639937]  __schedule+0x581/0x10b0
[42469.642839]  schedule+0x28/0xa0
[42469.645724]  schedule_preempt_disabled+0x16/0x30
[42469.648632]  rwsem_down_write_slowpath+0x2d8/0x750
[42469.651547]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42469.654504]  down_write+0x5c/0x60
[42469.657416]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42469.660390]  file_update_time_flags+0x7e/0x130
[42469.663330]  __xfs_write_fault+0x8c/0x260 [xfs]
[42469.666266]  do_page_mkwrite+0x4a/0xa0
[42469.669153]  do_wp_page+0x136/0x1160
[42469.672029]  ? restore_fpregs_from_fpstate+0x3c/0xa0
[42469.674940]  ? switch_fpu_return+0x5d/0xe0
[42469.677854]  __handle_mm_fault+0xb5a/0x1170
[42469.680724]  ? __x64_sys_ioctl+0xb0/0xe0
[42469.683491]  ? lock_vma_under_rcu+0x92/0x160
[42469.686165]  handle_mm_fault+0xe3/0x300
[42469.688859]  do_user_addr_fault+0x202/0x690
[42469.691564]  exc_page_fault+0x73/0x150
[42469.694272]  asm_exc_page_fault+0x26/0x30
[42469.696987] RIP: 0033:0x55ab1f9e1e6d
[42469.699689] RSP: 002b:00007f316d714550 EFLAGS: 00010206
[42469.702411] RAX: 00007f331af70018 RBX: 00007f3300a355f0 RCX: 0000000000000000
[42469.705194] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f3300a355f8
[42469.707975] RBP: 0000000000000000 R08: 00007f316d714540 R09: 00007f331bb85000
[42469.710740] R10: 0000000000000000 R11: 0000000001434d38 R12: 0000000000000016
[42469.713510] R13: 0000000000000000 R14: 000055ab1facbd20 R15: 00007f316d715340
[42469.716269]  </TASK>
[42469.719002] task:cache-worker    state:D stack:0     pid:1108799 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42469.721960] Call Trace:
[42469.724864]  <TASK>
[42469.727734]  __schedule+0x581/0x10b0
[42469.730614]  schedule+0x28/0xa0
[42469.733482]  schedule_preempt_disabled+0x16/0x30
[42469.736369]  rwsem_down_write_slowpath+0x2d8/0x750
[42469.739264]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42469.742198]  down_write+0x5c/0x60
[42469.745089]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42469.748035]  file_update_time_flags+0x7e/0x130
[42469.750914]  __xfs_write_fault+0x8c/0x260 [xfs]
[42469.753827]  do_page_mkwrite+0x4a/0xa0
[42469.756701]  do_wp_page+0x136/0x1160
[42469.759565]  ? __x64_sys_ioctl+0xb0/0xe0
[42469.762432]  ? do_syscall_64+0xf9/0x550
[42469.765252]  ? restore_fpregs_from_fpstate+0x3c/0xa0
[42469.767998]  __handle_mm_fault+0xb5a/0x1170
[42469.770651]  ? __x64_sys_ioctl+0xb0/0xe0
[42469.773329]  ? lock_vma_under_rcu+0x92/0x160
[42469.776018]  handle_mm_fault+0xe3/0x300
[42469.778704]  do_user_addr_fault+0x202/0x690
[42469.781400]  exc_page_fault+0x73/0x150
[42469.784086]  asm_exc_page_fault+0x26/0x30
[42469.786757] RIP: 0033:0x55ab1f9e1e6d
[42469.789423] RSP: 002b:00007f3252e57550 EFLAGS: 00010206
[42469.792128] RAX: 00007f331af70018 RBX: 00007f32ec8a7d70 RCX: 0000000000000000
[42469.794870] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f32ec8a7d78
[42469.797629] RBP: 0000000000000000 R08: 00007f3252e57540 R09: 00007f331bb85000
[42469.800381] R10: 0000000000000000 R11: 0000000001434dde R12: 0000000000000016
[42469.803140] R13: 0000000000000000 R14: 000055ab1facbd20 R15: 00007f3252e58340
[42469.805887]  </TASK>
[42469.808601] task:cache-worker    state:D stack:0     pid:1116410 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42469.811542] Call Trace:
[42469.814440]  <TASK>
[42469.817313]  __schedule+0x581/0x10b0
[42469.820202]  schedule+0x28/0xa0
[42469.823074]  schedule_preempt_disabled+0x16/0x30
[42469.825968]  rwsem_down_write_slowpath+0x2d8/0x750
[42469.828875]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42469.831822]  down_write+0x5c/0x60
[42469.834711]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42469.837632]  file_update_time_flags+0x7e/0x130
[42469.840515]  __xfs_write_fault+0x8c/0x260 [xfs]
[42469.843443]  do_page_mkwrite+0x4a/0xa0
[42469.846323]  do_wp_page+0x136/0x1160
[42469.849202]  __handle_mm_fault+0xb5a/0x1170
[42469.852042]  ? lock_vma_under_rcu+0x92/0x160
[42469.854789]  handle_mm_fault+0xe3/0x300
[42469.857436]  do_user_addr_fault+0x202/0x690
[42469.860114]  exc_page_fault+0x73/0x150
[42469.862796]  asm_exc_page_fault+0x26/0x30
[42469.865489] RIP: 0033:0x55ab1f9e1e6d
[42469.868178] RSP: 002b:00007f32eda94550 EFLAGS: 00010206
[42469.870888] RAX: 00007f331af70018 RBX: 00007f30fe847850 RCX: 0000000000000000
[42469.873665] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f30fe847858
[42469.876438] RBP: 0000000000000000 R08: 00007f32eda94540 R09: 00007f331bb85000
[42469.879205] R10: 0000000000000000 R11: 0000000001434d94 R12: 0000000000000016
[42469.881958] R13: 0000000000000000 R14: 000055ab1facbd20 R15: 00007f32eda95340
[42469.884714]  </TASK>
[42469.887433] task:cache-worker    state:D stack:0     pid:1120237 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42469.890392] Call Trace:
[42469.893315]  <TASK>
[42469.896210]  __schedule+0x581/0x10b0
[42469.899108]  schedule+0x28/0xa0
[42469.901980]  schedule_preempt_disabled+0x16/0x30
[42469.904880]  rwsem_down_write_slowpath+0x2d8/0x750
[42469.907790]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42469.910734]  down_write+0x5c/0x60
[42469.913635]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42469.916595]  file_update_time_flags+0x7e/0x130
[42469.919527]  __xfs_write_fault+0x8c/0x260 [xfs]
[42469.922493]  do_page_mkwrite+0x4a/0xa0
[42469.925415]  do_wp_page+0x136/0x1160
[42469.928286]  __handle_mm_fault+0xb5a/0x1170
[42469.931153]  ? lock_vma_under_rcu+0x92/0x160
[42469.934030]  handle_mm_fault+0xe3/0x300
[42469.936895]  do_user_addr_fault+0x202/0x690
[42469.939767]  exc_page_fault+0x73/0x150
[42469.942587]  asm_exc_page_fault+0x26/0x30
[42469.945315] RIP: 0033:0x55ab1f9e1e6d
[42469.947942] RSP: 002b:00007f32a3953550 EFLAGS: 00010206
[42469.950622] RAX: 00007f331af70018 RBX: 00007f324900a280 RCX: 0000000000000000
[42469.953380] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f324900a288
[42469.956149] RBP: 0000000000000000 R08: 00007f32a3953540 R09: 00007f331bb85000
[42469.958917] R10: 0000000000000000 R11: 0000000001434d36 R12: 0000000000000016
[42469.961687] R13: 0000000000000000 R14: 000055ab1facbd20 R15: 00007f32a3954340
[42469.964443]  </TASK>
[42469.967202] task:cache-worker    state:D stack:0     pid:1124542 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42469.970145] Call Trace:
[42469.973040]  <TASK>
[42469.975899]  __schedule+0x581/0x10b0
[42469.978766]  schedule+0x28/0xa0
[42469.981631]  schedule_preempt_disabled+0x16/0x30
[42469.984516]  rwsem_down_write_slowpath+0x2d8/0x750
[42469.987406]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42469.990336]  down_write+0x5c/0x60
[42469.993220]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42469.996164]  file_update_time_flags+0x7e/0x130
[42469.999079]  __xfs_write_fault+0x8c/0x260 [xfs]
[42470.002036]  do_page_mkwrite+0x4a/0xa0
[42470.004949]  do_wp_page+0x136/0x1160
[42470.007814]  __handle_mm_fault+0xb5a/0x1170
[42470.010675]  ? lock_vma_under_rcu+0x92/0x160
[42470.013546]  handle_mm_fault+0xe3/0x300
[42470.016410]  do_user_addr_fault+0x202/0x690
[42470.019280]  exc_page_fault+0x73/0x150
[42470.022095]  asm_exc_page_fault+0x26/0x30
[42470.024819] RIP: 0033:0x55ab1f9e1e6d
[42470.027443] RSP: 002b:00007f3281414550 EFLAGS: 00010206
[42470.030120] RAX: 00007f331af70018 RBX: 00007f316b633f00 RCX: 0000000000000000
[42470.032879] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f316b633f08
[42470.035652] RBP: 0000000000000000 R08: 00007f3281414540 R09: 00007f331bb85000
[42470.038419] R10: 0000000000000000 R11: 0000000001434e0a R12: 0000000000000016
[42470.041186] R13: 0000000000000000 R14: 000055ab1facbd20 R15: 00007f3281415340
[42470.043942]  </TASK>
[42470.046674] task:cache-worker    state:D stack:0     pid:1124595 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42470.049622] Call Trace:
[42470.052517]  <TASK>
[42470.055384]  __schedule+0x581/0x10b0
[42470.058256]  schedule+0x28/0xa0
[42470.061128]  schedule_preempt_disabled+0x16/0x30
[42470.064017]  rwsem_down_write_slowpath+0x2d8/0x750
[42470.066908]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42470.069845]  down_write+0x5c/0x60
[42470.072733]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42470.075684]  file_update_time_flags+0x7e/0x130
[42470.078608]  ? tomoyo_path_number_perm+0x8f/0x1f0
[42470.081551]  __xfs_write_fault+0x8c/0x260 [xfs]
[42470.084527]  do_page_mkwrite+0x4a/0xa0
[42470.087427]  do_wp_page+0x136/0x1160
[42470.090301]  __handle_mm_fault+0xb5a/0x1170
[42470.093192]  ? lock_vma_under_rcu+0x92/0x160
[42470.096087]  handle_mm_fault+0xe3/0x300
[42470.098974]  do_user_addr_fault+0x202/0x690
[42470.101824]  exc_page_fault+0x73/0x150
[42470.104573]  asm_exc_page_fault+0x26/0x30
[42470.107229] RIP: 0033:0x55ab1f9e1e6d
[42470.109900] RSP: 002b:00007f329ff68530 EFLAGS: 00010206
[42470.112615] RAX: 00007f331af70018 RBX: 00007f32a580d470 RCX: 0000000000000000
[42470.115407] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f32a580d478
[42470.118208] RBP: 0000000000000000 R08: 00007f329ff68540 R09: 00007f331bb85000
[42470.121003] R10: 0000000000000000 R11: 0000000001434e66 R12: 0000000000000016
[42470.123790] R13: 000055ab1facc058 R14: 00007f325eaf95a8 R15: 00007f329ff68820
[42470.126581]  </TASK>
[42470.129341] task:cache-worker    state:D stack:0     pid:1124596 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42470.132321] Call Trace:
[42470.135255]  <TASK>
[42470.138145]  __schedule+0x581/0x10b0
[42470.141065]  schedule+0x28/0xa0
[42470.143963]  schedule_preempt_disabled+0x16/0x30
[42470.146874]  rwsem_down_write_slowpath+0x2d8/0x750
[42470.149798]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42470.152767]  down_write+0x5c/0x60
[42470.155685]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42470.158666]  file_update_time_flags+0x7e/0x130
[42470.161623]  __xfs_write_fault+0x8c/0x260 [xfs]
[42470.164610]  do_page_mkwrite+0x4a/0xa0
[42470.167515]  do_wp_page+0x136/0x1160
[42470.170395]  __handle_mm_fault+0xb5a/0x1170
[42470.173295]  ? lock_vma_under_rcu+0x92/0x160
[42470.176198]  handle_mm_fault+0xe3/0x300
[42470.179088]  do_user_addr_fault+0x202/0x690
[42470.181940]  exc_page_fault+0x73/0x150
[42470.184693]  asm_exc_page_fault+0x26/0x30
[42470.187354] RIP: 0033:0x55ab1f9e1e6d
[42470.190027] RSP: 002b:00007f32edae8550 EFLAGS: 00010206
[42470.192744] RAX: 00007f331af70018 RBX: 00007f3256610730 RCX: 0000000000000000
[42470.195535] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f3256610738
[42470.198334] RBP: 0000000000000000 R08: 00007f32edae8540 R09: 00007f331bb85000
[42470.201131] R10: 0000000000000000 R11: 0000000001434db6 R12: 0000000000000016
[42470.203918] R13: 0000000000000000 R14: 000055ab1facbd20 R15: 00007f32edae9340
[42470.206692]  </TASK>
[42470.209435] task:cache-worker    state:D stack:0     pid:1124605 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42470.212401] Call Trace:
[42470.215311]  <TASK>
[42470.218177]  __schedule+0x581/0x10b0
[42470.221060]  schedule+0x28/0xa0
[42470.223937]  schedule_preempt_disabled+0x16/0x30
[42470.226829]  rwsem_down_write_slowpath+0x2d8/0x750
[42470.229733]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42470.232677]  down_write+0x5c/0x60
[42470.235574]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42470.238526]  file_update_time_flags+0x7e/0x130
[42470.241458]  __xfs_write_fault+0x8c/0x260 [xfs]
[42470.244426]  do_page_mkwrite+0x4a/0xa0
[42470.247349]  do_wp_page+0x136/0x1160
[42470.250216]  __handle_mm_fault+0xb5a/0x1170
[42470.253090]  ? switch_fpu_return+0x5d/0xe0
[42470.255965]  ? lock_vma_under_rcu+0x92/0x160
[42470.258835]  handle_mm_fault+0xe3/0x300
[42470.261687]  do_user_addr_fault+0x202/0x690
[42470.264497]  exc_page_fault+0x73/0x150
[42470.267208]  asm_exc_page_fault+0x26/0x30
[42470.269824] RIP: 0033:0x55ab1f9e1e6d
[42470.272461] RSP: 002b:00007f316fe3e550 EFLAGS: 00010206
[42470.275137] RAX: 00007f331af70018 RBX: 00007f3125e0fd50 RCX: 0000000000000000
[42470.277894] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f3125e0fd58
[42470.280664] RBP: 0000000000000000 R08: 00007f316fe3e540 R09: 00007f331bb85000
[42470.283429] R10: 0000000000000000 R11: 0000000001434d24 R12: 0000000000000016
[42470.286179] R13: 0000000000000000 R14: 000055ab1facbd20 R15: 00007f316fe3f340
[42470.288934]  </TASK>
[42470.291645] task:cache-worker    state:D stack:0     pid:1124613 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42470.294576] Call Trace:
[42470.297460]  <TASK>
[42470.300311]  __schedule+0x581/0x10b0
[42470.303191]  schedule+0x28/0xa0
[42470.306048]  schedule_preempt_disabled+0x16/0x30
[42470.308932]  rwsem_down_write_slowpath+0x2d8/0x750
[42470.311824]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42470.314757]  down_write+0x5c/0x60
[42470.317645]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42470.320599]  file_update_time_flags+0x7e/0x130
[42470.323527]  __xfs_write_fault+0x8c/0x260 [xfs]
[42470.326479]  do_page_mkwrite+0x4a/0xa0
[42470.329355]  do_wp_page+0x136/0x1160
[42470.332209]  __handle_mm_fault+0xb5a/0x1170
[42470.335076]  ? lock_vma_under_rcu+0x92/0x160
[42470.337948]  handle_mm_fault+0xe3/0x300
[42470.340812]  do_user_addr_fault+0x202/0x690
[42470.343641]  exc_page_fault+0x73/0x150
[42470.346364]  asm_exc_page_fault+0x26/0x30
[42470.348999] RIP: 0033:0x55ab1f9e1e6d
[42470.351654] RSP: 002b:00007f329f042530 EFLAGS: 00010206
[42470.354343] RAX: 00007f331af70018 RBX: 00007f3284a02170 RCX: 0000000000000000
[42470.357113] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f3284a02178
[42470.359892] RBP: 0000000000000000 R08: 00007f329f042540 R09: 00007f331bb85000
[42470.362659] R10: 0000000000000000 R11: 00000000014353cc R12: 0000000000000016
[42470.365423] R13: 000055ab1facc058 R14: 00007f30f84de1e8 R15: 00007f329f042820
[42470.368189]  </TASK>
[42470.370914] task:cache-worker    state:D stack:0     pid:1124615 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42470.373873] Call Trace:
[42470.376783]  <TASK>
[42470.379656]  __schedule+0x581/0x10b0
[42470.382551]  schedule+0x28/0xa0
[42470.385434]  schedule_preempt_disabled+0x16/0x30
[42470.388336]  rwsem_down_write_slowpath+0x2d8/0x750
[42470.391248]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42470.394199]  down_write+0x5c/0x60
[42470.397107]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42470.400080]  file_update_time_flags+0x7e/0x130
[42470.403025]  __xfs_write_fault+0x8c/0x260 [xfs]
[42470.406008]  do_page_mkwrite+0x4a/0xa0
[42470.408945]  do_wp_page+0x136/0x1160
[42470.411838]  ? do_syscall_64+0x25a/0x550
[42470.414716]  __handle_mm_fault+0xb5a/0x1170
[42470.417602]  ? lock_vma_under_rcu+0x92/0x160
[42470.420493]  handle_mm_fault+0xe3/0x300
[42470.423382]  do_user_addr_fault+0x202/0x690
[42470.426226]  exc_page_fault+0x73/0x150
[42470.428976]  asm_exc_page_fault+0x26/0x30
[42470.431629] RIP: 0033:0x55ab1f9e1e6d
[42470.434295] RSP: 002b:00007f328b855550 EFLAGS: 00010206
[42470.437005] RAX: 00007f331af70018 RBX: 00007f325ae12b20 RCX: 0000000000000000
[42470.439787] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f325ae12b28
[42470.442581] RBP: 0000000000000000 R08: 00007f328b855540 R09: 00007f331bb85000
[42470.445374] R10: 0000000000000000 R11: 0000000001434dcc R12: 0000000000000016
[42470.448152] R13: 0000000000000000 R14: 000055ab1facbd20 R15: 00007f328b856340
[42470.450919]  </TASK>
[42470.453658] task:cache-worker    state:D stack:0     pid:1124629 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42470.456617] Call Trace:
[42470.459529]  <TASK>
[42470.462402]  __schedule+0x581/0x10b0
[42470.465308]  schedule+0x28/0xa0
[42470.468192]  schedule_preempt_disabled+0x16/0x30
[42470.471089]  rwsem_down_write_slowpath+0x2d8/0x750
[42470.474003]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42470.476953]  down_write+0x5c/0x60
[42470.479855]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42470.482817]  file_update_time_flags+0x7e/0x130
[42470.485756]  __xfs_write_fault+0x8c/0x260 [xfs]
[42470.488723]  do_page_mkwrite+0x4a/0xa0
[42470.491613]  do_wp_page+0x136/0x1160
[42470.494476]  __handle_mm_fault+0xb5a/0x1170
[42470.497356]  ? switch_fpu_return+0x5d/0xe0
[42470.500233]  ? lock_vma_under_rcu+0x92/0x160
[42470.503098]  handle_mm_fault+0xe3/0x300
[42470.505917]  do_user_addr_fault+0x202/0x690
[42470.508642]  exc_page_fault+0x73/0x150
[42470.511269]  asm_exc_page_fault+0x26/0x30
[42470.513918] RIP: 0033:0x55ab1f9e1e6d
[42470.516575] RSP: 002b:00007f32edabe530 EFLAGS: 00010206
[42470.519268] RAX: 00007f331af70018 RBX: 00007f325ca2c710 RCX: 0000000000000000
[42470.522028] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f325ca2c718
[42470.524802] RBP: 0000000000000000 R08: 00007f32edabe540 R09: 00007f331bb85000
[42470.527566] R10: 0000000000000000 R11: 0000000001435174 R12: 0000000000000016
[42470.530319] R13: 000055ab1facc058 R14: 00007f310f79b728 R15: 00007f32edabe820
[42470.533078]  </TASK>
[42470.535797] task:cache-worker    state:D stack:0     pid:1124631 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42470.538747] Call Trace:
[42470.541650]  <TASK>
[42470.544530]  __schedule+0x581/0x10b0
[42470.547429]  schedule+0x28/0xa0
[42470.550306]  schedule_preempt_disabled+0x16/0x30
[42470.553209]  rwsem_down_write_slowpath+0x2d8/0x750
[42470.556119]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42470.559063]  down_write+0x5c/0x60
[42470.561962]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42470.564928]  file_update_time_flags+0x7e/0x130
[42470.567864]  __xfs_write_fault+0x8c/0x260 [xfs]
[42470.570827]  do_page_mkwrite+0x4a/0xa0
[42470.573720]  do_wp_page+0x136/0x1160
[42470.576586]  __handle_mm_fault+0xb5a/0x1170
[42470.579464]  ? __x64_sys_ioctl+0xb0/0xe0
[42470.582331]  ? lock_vma_under_rcu+0x92/0x160
[42470.585210]  handle_mm_fault+0xe3/0x300
[42470.588035]  do_user_addr_fault+0x202/0x690
[42470.590763]  exc_page_fault+0x73/0x150
[42470.593400]  asm_exc_page_fault+0x26/0x30
[42470.596061] RIP: 0033:0x55ab1f9e1e6d
[42470.598718] RSP: 002b:00007f324bb29550 EFLAGS: 00010206
[42470.601421] RAX: 00007f331af70018 RBX: 00007f3254407b90 RCX: 0000000000000000
[42470.604196] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f3254407b98
[42470.606972] RBP: 0000000000000000 R08: 00007f324bb29540 R09: 00007f331bb85000
[42470.609745] R10: 0000000000000000 R11: 0000000001434d62 R12: 0000000000000016
[42470.612510] R13: 0000000000000000 R14: 000055ab1facbd20 R15: 00007f324bb2a340
[42470.615266]  </TASK>
[42470.617979] task:cache-worker    state:D stack:0     pid:1124633 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42470.620932] Call Trace:
[42470.623834]  <TASK>
[42470.626709]  __schedule+0x581/0x10b0
[42470.629606]  schedule+0x28/0xa0
[42470.632485]  schedule_preempt_disabled+0x16/0x30
[42470.635386]  rwsem_down_write_slowpath+0x2d8/0x750
[42470.638293]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42470.641243]  down_write+0x5c/0x60
[42470.644144]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42470.647103]  file_update_time_flags+0x7e/0x130
[42470.650042]  __xfs_write_fault+0x8c/0x260 [xfs]
[42470.653009]  do_page_mkwrite+0x4a/0xa0
[42470.655905]  do_wp_page+0x136/0x1160
[42470.658762]  ? do_syscall_64+0xf9/0x550
[42470.661626]  ? do_vfs_ioctl+0x475/0x940
[42470.664474]  ? __seccomp_filter+0x42/0x5c0
[42470.667313]  __handle_mm_fault+0xb5a/0x1170
[42470.670096]  ? __x64_sys_ioctl+0xb0/0xe0
[42470.672782]  ? lock_vma_under_rcu+0x92/0x160
[42470.675381]  handle_mm_fault+0xe3/0x300
[42470.677988]  do_user_addr_fault+0x202/0x690
[42470.680614]  exc_page_fault+0x73/0x150
[42470.683245]  asm_exc_page_fault+0x26/0x30
[42470.685872] RIP: 0033:0x55ab1f9e1e6d
[42470.688493] RSP: 002b:00007f323f914550 EFLAGS: 00010206
[42470.691134] RAX: 00007f331af70018 RBX: 00007f3174a0c5d0 RCX: 0000000000000000
[42470.693841] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f3174a0c5d8
[42470.696548] RBP: 0000000000000000 R08: 00007f323f914540 R09: 00007f331bb85000
[42470.699245] R10: 0000000000000000 R11: 0000000001434d16 R12: 0000000000000016
[42470.701936] R13: 0000000000000000 R14: 000055ab1facbd20 R15: 00007f323f915340
[42470.704626]  </TASK>
[42470.707297] task:cache-worker    state:D stack:0     pid:1124646 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42470.710195] Call Trace:
[42470.713056]  <TASK>
[42470.715889]  __schedule+0x581/0x10b0
[42470.718734]  schedule+0x28/0xa0
[42470.721568]  schedule_preempt_disabled+0x16/0x30
[42470.724421]  rwsem_down_write_slowpath+0x2d8/0x750
[42470.727288]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42470.730189]  down_write+0x5c/0x60
[42470.733043]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42470.735922]  file_update_time_flags+0x7e/0x130
[42470.738755]  __xfs_write_fault+0x8c/0x260 [xfs]
[42470.741629]  do_page_mkwrite+0x4a/0xa0
[42470.744463]  do_wp_page+0x136/0x1160
[42470.747288]  __handle_mm_fault+0xb5a/0x1170
[42470.750074]  ? lock_vma_under_rcu+0x92/0x160
[42470.752775]  handle_mm_fault+0xe3/0x300
[42470.755373]  do_user_addr_fault+0x202/0x690
[42470.757996]  exc_page_fault+0x73/0x150
[42470.760627]  asm_exc_page_fault+0x26/0x30
[42470.763267] RIP: 0033:0x55ab1f9e1e6d
[42470.765896] RSP: 002b:00007f321b096550 EFLAGS: 00010206
[42470.768557] RAX: 00007f331af70018 RBX: 00007f3125a07040 RCX: 0000000000000000
[42470.771276] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f3125a07048
[42470.773994] RBP: 0000000000000000 R08: 00007f321b096540 R09: 00007f331bb85000
[42470.776708] R10: 0000000000000000 R11: 0000000001434e00 R12: 0000000000000016
[42470.779413] R13: 0000000000000000 R14: 000055ab1facbd20 R15: 00007f321b097340
[42470.782112]  </TASK>
[42470.784775] task:cache-worker    state:D stack:0     pid:1124649 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42470.787684] Call Trace:
[42470.790546]  <TASK>
[42470.793400]  __schedule+0x581/0x10b0
[42470.796273]  schedule+0x28/0xa0
[42470.799129]  schedule_preempt_disabled+0x16/0x30
[42470.802016]  rwsem_down_write_slowpath+0x2d8/0x750
[42470.804915]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42470.807855]  down_write+0x5c/0x60
[42470.810744]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42470.813695]  file_update_time_flags+0x7e/0x130
[42470.816623]  __xfs_write_fault+0x8c/0x260 [xfs]
[42470.819588]  do_page_mkwrite+0x4a/0xa0
[42470.822502]  do_wp_page+0x136/0x1160
[42470.825371]  ? restore_fpregs_from_fpstate+0x3c/0xa0
[42470.828263]  __handle_mm_fault+0xb5a/0x1170
[42470.831156]  ? lock_vma_under_rcu+0x92/0x160
[42470.834058]  handle_mm_fault+0xe3/0x300
[42470.836952]  do_user_addr_fault+0x202/0x690
[42470.839808]  exc_page_fault+0x73/0x150
[42470.842558]  asm_exc_page_fault+0x26/0x30
[42470.845220] RIP: 0033:0x55ab1f9e1e6d
[42470.847897] RSP: 002b:00007f329fe57530 EFLAGS: 00010206
[42470.850609] RAX: 00007f331af70018 RBX: 00007f328ac10190 RCX: 0000000000000000
[42470.853404] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f328ac10198
[42470.856207] RBP: 0000000000000000 R08: 00007f329fe57540 R09: 00007f331bb85000
[42470.858997] R10: 0000000000000000 R11: 000000000143544a R12: 0000000000000016
[42470.861784] R13: 000055ab1facc058 R14: 00007f31731702e8 R15: 00007f329fe57820
[42470.864575]  </TASK>
[42470.867328] task:cache-worker    state:D stack:0     pid:1124651 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42470.870304] Call Trace:
[42470.873239]  <TASK>
[42470.876136]  __schedule+0x581/0x10b0
[42470.879053]  schedule+0x28/0xa0
[42470.881958]  schedule_preempt_disabled+0x16/0x30
[42470.884877]  rwsem_down_write_slowpath+0x2d8/0x750
[42470.887809]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42470.890776]  down_write+0x5c/0x60
[42470.893700]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42470.896694]  file_update_time_flags+0x7e/0x130
[42470.899654]  __xfs_write_fault+0x8c/0x260 [xfs]
[42470.902642]  do_page_mkwrite+0x4a/0xa0
[42470.905557]  do_wp_page+0x136/0x1160
[42470.908450]  __handle_mm_fault+0xb5a/0x1170
[42470.911357]  ? lock_vma_under_rcu+0x92/0x160
[42470.914265]  handle_mm_fault+0xe3/0x300
[42470.917173]  do_user_addr_fault+0x202/0x690
[42470.920040]  exc_page_fault+0x73/0x150
[42470.922804]  asm_exc_page_fault+0x26/0x30
[42470.925480] RIP: 0033:0x55ab1f9e1e6d
[42470.928170] RSP: 002b:00007f329d6c0550 EFLAGS: 00010206
[42470.930893] RAX: 00007f331af70018 RBX: 00007f324aa000f0 RCX: 0000000000000000
[42470.933699] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f324aa000f8
[42470.936507] RBP: 0000000000000000 R08: 00007f329d6c0540 R09: 00007f331bb85000
[42470.939306] R10: 0000000000000000 R11: 0000000001434d6e R12: 0000000000000016
[42470.942095] R13: 0000000000000000 R14: 000055ab1facbd20 R15: 00007f329d6c1340
[42470.944877]  </TASK>
[42470.947618] task:cache-worker    state:D stack:0     pid:1124652 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42470.950585] Call Trace:
[42470.953513]  <TASK>
[42470.956400]  __schedule+0x581/0x10b0
[42470.959315]  schedule+0x28/0xa0
[42470.962195]  schedule_preempt_disabled+0x16/0x30
[42470.965088]  rwsem_down_write_slowpath+0x2d8/0x750
[42470.967984]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42470.970915]  down_write+0x5c/0x60
[42470.973807]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42470.976760]  file_update_time_flags+0x7e/0x130
[42470.979689]  __xfs_write_fault+0x8c/0x260 [xfs]
[42470.982650]  ? do_syscall_64+0x25a/0x550
[42470.985573]  do_page_mkwrite+0x4a/0xa0
[42470.988449]  do_wp_page+0x136/0x1160
[42470.991304]  __handle_mm_fault+0xb5a/0x1170
[42470.994170]  ? lock_vma_under_rcu+0x92/0x160
[42470.997045]  handle_mm_fault+0xe3/0x300
[42470.999898]  do_user_addr_fault+0x202/0x690
[42471.002707]  exc_page_fault+0x73/0x150
[42471.005426]  asm_exc_page_fault+0x26/0x30
[42471.008050] RIP: 0033:0x55ab1f9e1e6d
[42471.010687] RSP: 002b:00007f31200a96a0 EFLAGS: 00010206
[42471.013371] RAX: 00007f331af73018 RBX: 00007f3313e074b0 RCX: 0000000000000000
[42471.016130] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f3313e074b8
[42471.018900] RBP: 0000000000000000 R08: 0000000000000098 R09: 0000000000000000
[42471.021657] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000016
[42471.024381] R13: 000055ab1faca8e8 R14: 00007f3313e00140 R15: 00007f31200aa340
[42471.027104]  </TASK>
[42471.029798] task:cache-worker    state:D stack:0     pid:1124664 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42471.032714] Call Trace:
[42471.035587]  <TASK>
[42471.038424]  __schedule+0x581/0x10b0
[42471.041282]  schedule+0x28/0xa0
[42471.044125]  schedule_preempt_disabled+0x16/0x30
[42471.046983]  rwsem_down_write_slowpath+0x2d8/0x750
[42471.049856]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42471.052769]  down_write+0x5c/0x60
[42471.055634]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42471.058561]  file_update_time_flags+0x7e/0x130
[42471.061465]  __xfs_write_fault+0x8c/0x260 [xfs]
[42471.064402]  do_page_mkwrite+0x4a/0xa0
[42471.067259]  do_wp_page+0x136/0x1160
[42471.070096]  __handle_mm_fault+0xb5a/0x1170
[42471.072951]  ? do_vfs_ioctl+0x475/0x940
[42471.075802]  ? lock_vma_under_rcu+0x92/0x160
[42471.078654]  handle_mm_fault+0xe3/0x300
[42471.081458]  do_user_addr_fault+0x202/0x690
[42471.084168]  exc_page_fault+0x73/0x150
[42471.086775]  asm_exc_page_fault+0x26/0x30
[42471.089413] RIP: 0033:0x55ab1f9e1e6d
[42471.092050] RSP: 002b:00007f33134ac550 EFLAGS: 00010206
[42471.094725] RAX: 00007f331af70018 RBX: 00007f3109a128a0 RCX: 0000000000000000
[42471.097474] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f3109a128a8
[42471.100226] RBP: 0000000000000000 R08: 00007f33134ac540 R09: 00007f331bb85000
[42471.102967] R10: 0000000000000000 R11: 0000000001434d22 R12: 0000000000000016
[42471.105705] R13: 0000000000000000 R14: 000055ab1facbd20 R15: 00007f33134ad340
[42471.108430]  </TASK>
[42471.111113] task:cache-worker    state:D stack:0     pid:1124666 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42471.114034] Call Trace:
[42471.116907]  <TASK>
[42471.119755]  __schedule+0x581/0x10b0
[42471.122624]  schedule+0x28/0xa0
[42471.125481]  schedule_preempt_disabled+0x16/0x30
[42471.128355]  rwsem_down_write_slowpath+0x2d8/0x750
[42471.131239]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42471.134163]  down_write+0x5c/0x60
[42471.137037]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42471.139977]  file_update_time_flags+0x7e/0x130
[42471.142881]  __xfs_write_fault+0x8c/0x260 [xfs]
[42471.145825]  do_page_mkwrite+0x4a/0xa0
[42471.148687]  do_wp_page+0x136/0x1160
[42471.151522]  ? do_iter_readv_writev+0x15a/0x250
[42471.154391]  __handle_mm_fault+0xb5a/0x1170
[42471.157286]  ? lock_vma_under_rcu+0x92/0x160
[42471.160175]  handle_mm_fault+0xe3/0x300
[42471.163008]  do_user_addr_fault+0x202/0x690
[42471.165754]  exc_page_fault+0x73/0x150
[42471.168400]  asm_exc_page_fault+0x26/0x30
[42471.171068] RIP: 0033:0x55ab1f9e1e6d
[42471.173743] RSP: 002b:00007f3242e2d4d0 EFLAGS: 00010206
[42471.176456] RAX: 00007f331afea018 RBX: 00007f324800a050 RCX: 0000000000000000
[42471.179235] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f324800a058
[42471.182015] RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
[42471.184774] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000016
[42471.187498] R13: 000055ab1fac7c30 R14: 000000000043eaa4 R15: 000000001043eaa4
[42471.190211]  </TASK>
[42471.192897] task:cache-worker    state:D stack:0     pid:1124683 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42471.195812] Call Trace:
[42471.198669]  <TASK>
[42471.201510]  __schedule+0x581/0x10b0
[42471.204367]  schedule+0x28/0xa0
[42471.207209]  schedule_preempt_disabled+0x16/0x30
[42471.210071]  rwsem_down_write_slowpath+0x2d8/0x750
[42471.212948]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42471.215867]  down_write+0x5c/0x60
[42471.218734]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42471.221667]  file_update_time_flags+0x7e/0x130
[42471.224578]  __xfs_write_fault+0x8c/0x260 [xfs]
[42471.227517]  do_page_mkwrite+0x4a/0xa0
[42471.230374]  do_wp_page+0x136/0x1160
[42471.233215]  __handle_mm_fault+0xb5a/0x1170
[42471.236065]  ? lock_vma_under_rcu+0x92/0x160
[42471.238914]  handle_mm_fault+0xe3/0x300
[42471.241763]  do_user_addr_fault+0x202/0x690
[42471.244571]  exc_page_fault+0x73/0x150
[42471.247280]  asm_exc_page_fault+0x26/0x30
[42471.249892] RIP: 0033:0x55ab1f9e1e6d
[42471.252526] RSP: 002b:00007f321e02b550 EFLAGS: 00010206
[42471.255196] RAX: 00007f331af70018 RBX: 00007f3175e0a0f0 RCX: 0000000000000000
[42471.257938] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f3175e0a0f8
[42471.260696] RBP: 0000000000000000 R08: 00007f321e02b540 R09: 00007f331bb85000
[42471.263443] R10: 0000000000000000 R11: 0000000001434d58 R12: 0000000000000016
[42471.266178] R13: 0000000000000000 R14: 000055ab1facbd20 R15: 00007f321e02c340
[42471.268908]  </TASK>
[42471.271607] task:cache-worker    state:D stack:0     pid:1124708 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42471.274520] Call Trace:
[42471.277390]  <TASK>
[42471.280223]  __schedule+0x581/0x10b0
[42471.283080]  schedule+0x28/0xa0
[42471.285915]  schedule_preempt_disabled+0x16/0x30
[42471.288767]  rwsem_down_write_slowpath+0x2d8/0x750
[42471.291625]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42471.294522]  down_write+0x5c/0x60
[42471.297373]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42471.300286]  file_update_time_flags+0x7e/0x130
[42471.303173]  __xfs_write_fault+0x8c/0x260 [xfs]
[42471.306103]  do_page_mkwrite+0x4a/0xa0
[42471.308978]  do_wp_page+0x136/0x1160
[42471.311806]  __handle_mm_fault+0xb5a/0x1170
[42471.314635]  ? lock_vma_under_rcu+0x92/0x160
[42471.317492]  handle_mm_fault+0xe3/0x300
[42471.320362]  do_user_addr_fault+0x202/0x690
[42471.323237]  exc_page_fault+0x73/0x150
[42471.326058]  asm_exc_page_fault+0x26/0x30
[42471.328788] RIP: 0033:0x55ab1f9e1e6d
[42471.331416] RSP: 002b:00007f311567d550 EFLAGS: 00010206
[42471.334098] RAX: 00007f331af70018 RBX: 00007f3127e13f70 RCX: 0000000000000000
[42471.336858] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f3127e13f78
[42471.339633] RBP: 0000000000000000 R08: 00007f311567d540 R09: 00007f331bb85000
[42471.342407] R10: 0000000000000000 R11: 0000000001434d24 R12: 0000000000000016
[42471.345181] R13: 0000000000000000 R14: 000055ab1facbd20 R15: 00007f311567e340
[42471.347942]  </TASK>
[42471.350664] task:cache-worker    state:D stack:0     pid:1124718 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42471.353617] Call Trace:
[42471.356514]  <TASK>
[42471.359377]  __schedule+0x581/0x10b0
[42471.362249]  schedule+0x28/0xa0
[42471.365116]  schedule_preempt_disabled+0x16/0x30
[42471.368003]  rwsem_down_write_slowpath+0x2d8/0x750
[42471.370894]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42471.373832]  down_write+0x5c/0x60
[42471.376721]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42471.379673]  file_update_time_flags+0x7e/0x130
[42471.382594]  __xfs_write_fault+0x8c/0x260 [xfs]
[42471.385555]  do_page_mkwrite+0x4a/0xa0
[42471.388472]  do_wp_page+0x136/0x1160
[42471.391339]  ? do_syscall_64+0x25a/0x550
[42471.394196]  ? do_syscall_64+0xf9/0x550
[42471.397031]  __handle_mm_fault+0xb5a/0x1170
[42471.399872]  ? lock_vma_under_rcu+0x92/0x160
[42471.402717]  handle_mm_fault+0xe3/0x300
[42471.405520]  do_user_addr_fault+0x202/0x690
[42471.408232]  exc_page_fault+0x73/0x150
[42471.410839]  asm_exc_page_fault+0x26/0x30
[42471.413477] RIP: 0033:0x55ab1f9e1e6d
[42471.416116] RSP: 002b:00007f3179229550 EFLAGS: 00010206
[42471.418792] RAX: 00007f331af70018 RBX: 00007f325a6074e0 RCX: 0000000000000000
[42471.421543] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f325a6074e8
[42471.424297] RBP: 0000000000000000 R08: 00007f3179229540 R09: 00007f331bb85000
[42471.427037] R10: 0000000000000000 R11: 0000000001434d2e R12: 0000000000000016
[42471.429773] R13: 0000000000000000 R14: 000055ab1facbd20 R15: 00007f317922a340
[42471.432496]  </TASK>
[42471.435176] task:cache-worker    state:D stack:0     pid:1124722 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42471.438091] Call Trace:
[42471.440960]  <TASK>
[42471.443807]  __schedule+0x581/0x10b0
[42471.446665]  schedule+0x28/0xa0
[42471.449509]  schedule_preempt_disabled+0x16/0x30
[42471.452376]  rwsem_down_write_slowpath+0x2d8/0x750
[42471.455252]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42471.458166]  down_write+0x5c/0x60
[42471.461039]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42471.463977]  file_update_time_flags+0x7e/0x130
[42471.466873]  __xfs_write_fault+0x8c/0x260 [xfs]
[42471.469774]  do_page_mkwrite+0x4a/0xa0
[42471.472621]  do_wp_page+0x136/0x1160
[42471.475459]  __handle_mm_fault+0xb5a/0x1170
[42471.478301]  ? switch_fpu_return+0x5d/0xe0
[42471.481152]  ? lock_vma_under_rcu+0x92/0x160
[42471.483957]  handle_mm_fault+0xe3/0x300
[42471.486654]  do_user_addr_fault+0x202/0x690
[42471.489267]  exc_page_fault+0x73/0x150
[42471.491899]  asm_exc_page_fault+0x26/0x30
[42471.494536] RIP: 0033:0x55ab1f9e1e6d
[42471.497179] RSP: 002b:00007f3310c33550 EFLAGS: 00010206
[42471.499855] RAX: 00007f331af70018 RBX: 00007f31292164b0 RCX: 0000000000000000
[42471.502589] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f31292164b8
[42471.505334] RBP: 0000000000000000 R08: 00007f3310c33540 R09: 00007f331bb85000
[42471.508067] R10: 0000000000000000 R11: 0000000001434d2a R12: 0000000000000016
[42471.510788] R13: 0000000000000000 R14: 000055ab1facbd20 R15: 00007f3310c34340
[42471.513501]  </TASK>
[42471.516184] task:cache-worker    state:D stack:0     pid:1124733 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42471.519091] Call Trace:
[42471.521969]  <TASK>
[42471.524818]  __schedule+0x581/0x10b0
[42471.527711]  schedule+0x28/0xa0
[42471.530581]  schedule_preempt_disabled+0x16/0x30
[42471.533474]  rwsem_down_write_slowpath+0x2d8/0x750
[42471.536372]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42471.539314]  down_write+0x5c/0x60
[42471.542198]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42471.545152]  file_update_time_flags+0x7e/0x130
[42471.548077]  __xfs_write_fault+0x8c/0x260 [xfs]
[42471.551031]  do_page_mkwrite+0x4a/0xa0
[42471.553909]  do_wp_page+0x136/0x1160
[42471.556765]  __handle_mm_fault+0xb5a/0x1170
[42471.559632]  ? lock_vma_under_rcu+0x92/0x160
[42471.562505]  handle_mm_fault+0xe3/0x300
[42471.565376]  do_user_addr_fault+0x202/0x690
[42471.568204]  exc_page_fault+0x73/0x150
[42471.570930]  asm_exc_page_fault+0x26/0x30
[42471.573568] RIP: 0033:0x55ab1f9e1e6d
[42471.576223] RSP: 002b:00007f3288229550 EFLAGS: 00010206
[42471.578913] RAX: 00007f331af70018 RBX: 00007f316a22c840 RCX: 0000000000000000
[42471.581683] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f316a22c848
[42471.584464] RBP: 0000000000000000 R08: 00007f3288229540 R09: 00007f331bb85000
[42471.587238] R10: 0000000000000000 R11: 0000000001434d1c R12: 0000000000000016
[42471.590007] R13: 0000000000000000 R14: 000055ab1facbd20 R15: 00007f328822a340
[42471.592764]  </TASK>
[42471.595488] task:cache-worker    state:D stack:0     pid:1124750 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42471.598429] Call Trace:
[42471.601329]  <TASK>
[42471.604191]  __schedule+0x581/0x10b0
[42471.607074]  schedule+0x28/0xa0
[42471.609947]  schedule_preempt_disabled+0x16/0x30
[42471.612837]  rwsem_down_write_slowpath+0x2d8/0x750
[42471.615738]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42471.618681]  down_write+0x5c/0x60
[42471.621579]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42471.624543]  file_update_time_flags+0x7e/0x130
[42471.627476]  __xfs_write_fault+0x8c/0x260 [xfs]
[42471.630444]  do_page_mkwrite+0x4a/0xa0
[42471.633366]  do_wp_page+0x136/0x1160
[42471.636240]  ? do_vfs_ioctl+0x475/0x940
[42471.639094]  ? __seccomp_filter+0x42/0x5c0
[42471.641957]  ? restore_fpregs_from_fpstate+0x3c/0xa0
[42471.644844]  __handle_mm_fault+0xb5a/0x1170
[42471.647738]  ? __x64_sys_ioctl+0xb0/0xe0
[42471.650574]  ? lock_vma_under_rcu+0x92/0x160
[42471.653324]  handle_mm_fault+0xe3/0x300
[42471.655971]  do_user_addr_fault+0x202/0x690
[42471.658640]  exc_page_fault+0x73/0x150
[42471.661318]  asm_exc_page_fault+0x26/0x30
[42471.664005] RIP: 0033:0x55ab1f9e1e6d
[42471.666693] RSP: 002b:00007f3314269550 EFLAGS: 00010206
[42471.669404] RAX: 00007f331af70018 RBX: 00007f31030260a0 RCX: 0000000000000000
[42471.672173] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f31030260a8
[42471.674938] RBP: 0000000000000000 R08: 00007f3314269540 R09: 00007f331bb85000
[42471.677697] R10: 0000000000000000 R11: 0000000001434d44 R12: 0000000000000016
[42471.680447] R13: 0000000000000000 R14: 000055ab1facbd20 R15: 00007f331426a340
[42471.683193]  </TASK>
[42471.685899] task:cache-worker    state:D stack:0     pid:1124759 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42471.688851] Call Trace:
[42471.691756]  <TASK>
[42471.694624]  __schedule+0x581/0x10b0
[42471.697513]  schedule+0x28/0xa0
[42471.700384]  schedule_preempt_disabled+0x16/0x30
[42471.703278]  rwsem_down_write_slowpath+0x2d8/0x750
[42471.706181]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42471.709128]  down_write+0x5c/0x60
[42471.712020]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42471.714936]  file_update_time_flags+0x7e/0x130
[42471.717814]  __xfs_write_fault+0x8c/0x260 [xfs]
[42471.720739]  do_page_mkwrite+0x4a/0xa0
[42471.723615]  do_wp_page+0x136/0x1160
[42471.726477]  ? switch_fpu_return+0x5d/0xe0
[42471.729307]  ? do_syscall_64+0x25a/0x550
[42471.732033]  __handle_mm_fault+0xb5a/0x1170
[42471.734669]  ? lock_vma_under_rcu+0x92/0x160
[42471.737337]  handle_mm_fault+0xe3/0x300
[42471.740005]  do_user_addr_fault+0x202/0x690
[42471.742683]  exc_page_fault+0x73/0x150
[42471.745365]  asm_exc_page_fault+0x26/0x30
[42471.748040] RIP: 0033:0x55ab1f9e1e6d
[42471.750696] RSP: 002b:00007f331021a550 EFLAGS: 00010206
[42471.753384] RAX: 00007f331af70018 RBX: 00007f325ed8f870 RCX: 0000000000000000
[42471.756130] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f325ed8f878
[42471.758875] RBP: 0000000000000000 R08: 00007f331021a540 R09: 00007f331bb85000
[42471.761621] R10: 0000000000000000 R11: 0000000001434d9a R12: 0000000000000016
[42471.764363] R13: 0000000000000000 R14: 000055ab1facbd20 R15: 00007f331021b340
[42471.767107]  </TASK>
[42471.769827] task:cache-worker    state:D stack:0     pid:1124761 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42471.772784] Call Trace:
[42471.775684]  <TASK>
[42471.778534]  __schedule+0x581/0x10b0
[42471.781407]  schedule+0x28/0xa0
[42471.784265]  schedule_preempt_disabled+0x16/0x30
[42471.787143]  rwsem_down_write_slowpath+0x2d8/0x750
[42471.790035]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42471.792978]  down_write+0x5c/0x60
[42471.795865]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42471.798811]  file_update_time_flags+0x7e/0x130
[42471.801726]  __xfs_write_fault+0x8c/0x260 [xfs]
[42471.804653]  do_page_mkwrite+0x4a/0xa0
[42471.807526]  do_wp_page+0x136/0x1160
[42471.810383]  ? do_vfs_ioctl+0x475/0x940
[42471.813243]  ? __seccomp_filter+0x42/0x5c0
[42471.816108]  __handle_mm_fault+0xb5a/0x1170
[42471.818920]  ? __x64_sys_ioctl+0xb0/0xe0
[42471.821635]  ? lock_vma_under_rcu+0x92/0x160
[42471.824262]  handle_mm_fault+0xe3/0x300
[42471.826900]  do_user_addr_fault+0x202/0x690
[42471.829557]  exc_page_fault+0x73/0x150
[42471.832216]  asm_exc_page_fault+0x26/0x30
[42471.834871] RIP: 0033:0x55ab1f9e1e6d
[42471.837521] RSP: 002b:00007f31b8e2b530 EFLAGS: 00010206
[42471.840188] RAX: 00007f331af70018 RBX: 00007f3258a08e60 RCX: 0000000000000000
[42471.842915] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f3258a08e68
[42471.845650] RBP: 0000000000000000 R08: 00007f31b8e2b540 R09: 00007f331bb85000
[42471.848372] R10: 0000000000000000 R11: 0000000001435186 R12: 0000000000000016
[42471.851090] R13: 000055ab1facc058 R14: 00007f325b8e0e28 R15: 00007f31b8e2b820
[42471.853822]  </TASK>
[42471.856531] task:cache-worker    state:D stack:0     pid:1124764 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42471.859477] Call Trace:
[42471.862378]  <TASK>
[42471.865251]  __schedule+0x581/0x10b0
[42471.868142]  schedule+0x28/0xa0
[42471.871008]  schedule_preempt_disabled+0x16/0x30
[42471.873900]  rwsem_down_write_slowpath+0x2d8/0x750
[42471.876799]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42471.879751]  down_write+0x5c/0x60
[42471.882640]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42471.885592]  file_update_time_flags+0x7e/0x130
[42471.888476]  __xfs_write_fault+0x8c/0x260 [xfs]
[42471.891391]  do_page_mkwrite+0x4a/0xa0
[42471.894259]  do_wp_page+0x136/0x1160
[42471.897118]  __handle_mm_fault+0xb5a/0x1170
[42471.899992]  ? lock_vma_under_rcu+0x92/0x160
[42471.902821]  handle_mm_fault+0xe3/0x300
[42471.905557]  do_user_addr_fault+0x202/0x690
[42471.908200]  exc_page_fault+0x73/0x150
[42471.910862]  asm_exc_page_fault+0x26/0x30
[42471.913541] RIP: 0033:0x55ab1f9e1e6d
[42471.916219] RSP: 002b:00007f3243629550 EFLAGS: 00010206
[42471.918927] RAX: 00007f331af70018 RBX: 00007f3125e0d780 RCX: 0000000000000000
[42471.921703] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f3125e0d788
[42471.924477] RBP: 0000000000000000 R08: 00007f3243629540 R09: 00007f331bb85000
[42471.927244] R10: 0000000000000000 R11: 0000000001434dfe R12: 0000000000000016
[42471.930001] R13: 0000000000000000 R14: 000055ab1facbd20 R15: 00007f324362a340
[42471.932751]  </TASK>
[42471.935467] task:cache-worker    state:D stack:0     pid:1124778 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42471.938407] Call Trace:
[42471.941313]  <TASK>
[42471.944193]  __schedule+0x581/0x10b0
[42471.947087]  schedule+0x28/0xa0
[42471.949975]  schedule_preempt_disabled+0x16/0x30
[42471.952887]  rwsem_down_write_slowpath+0x2d8/0x750
[42471.955811]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42471.958779]  down_write+0x5c/0x60
[42471.961696]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42471.964679]  file_update_time_flags+0x7e/0x130
[42471.967631]  __xfs_write_fault+0x8c/0x260 [xfs]
[42471.970625]  do_page_mkwrite+0x4a/0xa0
[42471.973569]  do_wp_page+0x136/0x1160
[42471.976462]  __handle_mm_fault+0xb5a/0x1170
[42471.979354]  ? lock_vma_under_rcu+0x92/0x160
[42471.982248]  handle_mm_fault+0xe3/0x300
[42471.985139]  do_user_addr_fault+0x202/0x690
[42471.988020]  exc_page_fault+0x73/0x150
[42471.990846]  asm_exc_page_fault+0x26/0x30
[42471.993584] RIP: 0033:0x55ab1f9e1e6d
[42471.996220] RSP: 002b:00007f321d42b550 EFLAGS: 00010206
[42471.998908] RAX: 00007f331af70018 RBX: 00007f31024060a0 RCX: 0000000000000000
[42472.001675] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f31024060a8
[42472.004461] RBP: 0000000000000000 R08: 00007f321d42b540 R09: 00007f331bb85000
[42472.007247] R10: 0000000000000000 R11: 0000000001434e06 R12: 0000000000000016
[42472.010022] R13: 0000000000000000 R14: 000055ab1facbd20 R15: 00007f321d42c340
[42472.012795]  </TASK>
[42472.015538] task:cache-worker    state:D stack:0     pid:1124791 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42472.018494] Call Trace:
[42472.021401]  <TASK>
[42472.024276]  __schedule+0x581/0x10b0
[42472.027157]  schedule+0x28/0xa0
[42472.030035]  schedule_preempt_disabled+0x16/0x30
[42472.032934]  rwsem_down_write_slowpath+0x2d8/0x750
[42472.035838]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42472.038778]  down_write+0x5c/0x60
[42472.041671]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42472.044631]  file_update_time_flags+0x7e/0x130
[42472.047557]  ? switch_fpu_return+0x5d/0xe0
[42472.050476]  __xfs_write_fault+0x8c/0x260 [xfs]
[42472.053447]  do_page_mkwrite+0x4a/0xa0
[42472.056335]  do_wp_page+0x136/0x1160
[42472.059197]  ? __seccomp_filter+0x42/0x5c0
[42472.062066]  __handle_mm_fault+0xb5a/0x1170
[42472.064936]  ? lock_vma_under_rcu+0x92/0x160
[42472.067809]  handle_mm_fault+0xe3/0x300
[42472.070628]  do_user_addr_fault+0x202/0x690
[42472.073361]  exc_page_fault+0x73/0x150
[42472.075999]  asm_exc_page_fault+0x26/0x30
[42472.078655] RIP: 0033:0x55ab1f9e1e6d
[42472.081320] RSP: 002b:00007f324baea530 EFLAGS: 00010206
[42472.084023] RAX: 00007f331af70018 RBX: 00007f330820d460 RCX: 0000000000000000
[42472.086790] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f330820d468
[42472.089567] RBP: 0000000000000000 R08: 00007f324baea540 R09: 00007f331bb85000
[42472.092330] R10: 0000000000000000 R11: 0000000001435076 R12: 0000000000000016
[42472.095082] R13: 000055ab1facc058 R14: 00007f316bf7c228 R15: 00007f324baea820
[42472.097846]  </TASK>
[42472.100580] task:cache-worker    state:D stack:0     pid:1124811 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42472.103540] Call Trace:
[42472.106443]  <TASK>
[42472.109332]  __schedule+0x581/0x10b0
[42472.112233]  schedule+0x28/0xa0
[42472.115111]  schedule_preempt_disabled+0x16/0x30
[42472.118016]  rwsem_down_write_slowpath+0x2d8/0x750
[42472.120929]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42472.123884]  down_write+0x5c/0x60
[42472.126787]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42472.129758]  file_update_time_flags+0x7e/0x130
[42472.132691]  __xfs_write_fault+0x8c/0x260 [xfs]
[42472.135632]  do_page_mkwrite+0x4a/0xa0
[42472.138510]  do_wp_page+0x136/0x1160
[42472.141382]  ? switch_fpu_return+0x5d/0xe0
[42472.144264]  ? do_syscall_64+0x25a/0x550
[42472.147137]  __handle_mm_fault+0xb5a/0x1170
[42472.149974]  ? lock_vma_under_rcu+0x92/0x160
[42472.152718]  handle_mm_fault+0xe3/0x300
[42472.155365]  do_user_addr_fault+0x202/0x690
[42472.158035]  exc_page_fault+0x73/0x150
[42472.160711]  asm_exc_page_fault+0x26/0x30
[42472.163395] RIP: 0033:0x55ab1f9e1e6d
[42472.166071] RSP: 002b:00007f31b7b7d550 EFLAGS: 00010206
[42472.168781] RAX: 00007f331af70018 RBX: 00007f3305e099b0 RCX: 0000000000000000
[42472.171546] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f3305e099b8
[42472.174313] RBP: 0000000000000000 R08: 00007f31b7b7d540 R09: 00007f331bb85000
[42472.177072] R10: 0000000000000000 R11: 0000000001434d42 R12: 0000000000000016
[42472.179821] R13: 0000000000000000 R14: 000055ab1facbd20 R15: 00007f31b7b7e340
[42472.182560]  </TASK>
[42472.185270] task:cache-worker    state:D stack:0     pid:1124816 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42472.188204] Call Trace:
[42472.191097]  <TASK>
[42472.193968]  __schedule+0x581/0x10b0
[42472.196858]  schedule+0x28/0xa0
[42472.199730]  schedule_preempt_disabled+0x16/0x30
[42472.202619]  rwsem_down_write_slowpath+0x2d8/0x750
[42472.205524]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42472.208468]  down_write+0x5c/0x60
[42472.211367]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42472.214323]  file_update_time_flags+0x7e/0x130
[42472.217250]  __xfs_write_fault+0x8c/0x260 [xfs]
[42472.220179]  do_page_mkwrite+0x4a/0xa0
[42472.223054]  do_wp_page+0x136/0x1160
[42472.225926]  __handle_mm_fault+0xb5a/0x1170
[42472.228807]  ? lock_vma_under_rcu+0x92/0x160
[42472.231679]  handle_mm_fault+0xe3/0x300
[42472.234494]  do_user_addr_fault+0x202/0x690
[42472.237221]  exc_page_fault+0x73/0x150
[42472.239852]  asm_exc_page_fault+0x26/0x30
[42472.242503] RIP: 0033:0x55ab1f9e1e6d
[42472.245161] RSP: 002b:00007f32e8e2b550 EFLAGS: 00010206
[42472.247859] RAX: 00007f331af70018 RBX: 00007f30fc8118b0 RCX: 0000000000000000
[42472.250621] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f30fc8118b8
[42472.253397] RBP: 0000000000000000 R08: 00007f32e8e2b540 R09: 00007f331bb85000
[42472.256160] R10: 0000000000000000 R11: 0000000001434e06 R12: 0000000000000016
[42472.258911] R13: 0000000000000000 R14: 000055ab1facbd20 R15: 00007f32e8e2c340
[42472.261662]  </TASK>
[42472.264378] task:cache-worker    state:D stack:0     pid:1124828 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42472.267321] Call Trace:
[42472.270208]  <TASK>
[42472.273085]  __schedule+0x581/0x10b0
[42472.275974]  schedule+0x28/0xa0
[42472.278846]  schedule_preempt_disabled+0x16/0x30
[42472.281742]  rwsem_down_write_slowpath+0x2d8/0x750
[42472.284642]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42472.287583]  down_write+0x5c/0x60
[42472.290472]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42472.293433]  file_update_time_flags+0x7e/0x130
[42472.296362]  __xfs_write_fault+0x8c/0x260 [xfs]
[42472.299329]  do_page_mkwrite+0x4a/0xa0
[42472.302243]  do_wp_page+0x136/0x1160
[42472.305120]  __handle_mm_fault+0xb5a/0x1170
[42472.307996]  ? lock_vma_under_rcu+0x92/0x160
[42472.310876]  handle_mm_fault+0xe3/0x300
[42472.313753]  do_user_addr_fault+0x202/0x690
[42472.316634]  exc_page_fault+0x73/0x150
[42472.319465]  asm_exc_page_fault+0x26/0x30
[42472.322199] RIP: 0033:0x55ab1f9e1e6d
[42472.324840] RSP: 002b:00007f328143e500 EFLAGS: 00010206
[42472.327533] RAX: 00007f331af70018 RBX: 00007f3303606620 RCX: 0000000000000000
[42472.330297] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f3303606628
[42472.333086] RBP: 0000000000000000 R08: 00007f328143e540 R09: 00007f331bb85000
[42472.335873] R10: 0000000000000000 R11: 0000000001434d18 R12: 0000000000000016
[42472.338644] R13: 000055ab1facbf48 R14: 00007f3303e47520 R15: 00007f3303e47550
[42472.341424]  </TASK>
[42472.344169] task:cache-worker    state:D stack:0     pid:1124839 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42472.347135] Call Trace:
[42472.350053]  <TASK>
[42472.352935]  __schedule+0x581/0x10b0
[42472.355829]  schedule+0x28/0xa0
[42472.358711]  schedule_preempt_disabled+0x16/0x30
[42472.361619]  rwsem_down_write_slowpath+0x2d8/0x750
[42472.364532]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42472.367484]  down_write+0x5c/0x60
[42472.370386]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42472.373351]  file_update_time_flags+0x7e/0x130
[42472.376294]  ? tomoyo_path_number_perm+0x8f/0x1f0
[42472.379255]  __xfs_write_fault+0x8c/0x260 [xfs]
[42472.382242]  do_page_mkwrite+0x4a/0xa0
[42472.385153]  do_wp_page+0x136/0x1160
[42472.388040]  __handle_mm_fault+0xb5a/0x1170
[42472.390935]  ? lock_vma_under_rcu+0x92/0x160
[42472.393841]  handle_mm_fault+0xe3/0x300
[42472.396740]  do_user_addr_fault+0x202/0x690
[42472.399596]  exc_page_fault+0x73/0x150
[42472.402347]  asm_exc_page_fault+0x26/0x30
[42472.405015] RIP: 0033:0x55ab1f9e1e6d
[42472.407699] RSP: 002b:00007f321d4be550 EFLAGS: 00010206
[42472.410416] RAX: 00007f331af70018 RBX: 00007f3283605180 RCX: 0000000000000000
[42472.413221] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f3283605188
[42472.416032] RBP: 0000000000000000 R08: 00007f321d4be540 R09: 00007f331bb85000
[42472.418832] R10: 0000000000000000 R11: 0000000001434e0a R12: 0000000000000016
[42472.421628] R13: 0000000000000000 R14: 000055ab1facbd20 R15: 00007f321d4bf340
[42472.424416]  </TASK>
[42472.427166] task:cache-worker    state:D stack:0     pid:1124849 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42472.430139] Call Trace:
[42472.433066]  <TASK>
[42472.435960]  __schedule+0x581/0x10b0
[42472.438871]  schedule+0x28/0xa0
[42472.441769]  schedule_preempt_disabled+0x16/0x30
[42472.444684]  rwsem_down_write_slowpath+0x2d8/0x750
[42472.447611]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42472.450572]  down_write+0x5c/0x60
[42472.453491]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42472.456477]  file_update_time_flags+0x7e/0x130
[42472.459431]  __xfs_write_fault+0x8c/0x260 [xfs]
[42472.462411]  do_page_mkwrite+0x4a/0xa0
[42472.465319]  do_wp_page+0x136/0x1160
[42472.468203]  __handle_mm_fault+0xb5a/0x1170
[42472.471096]  ? lock_vma_under_rcu+0x92/0x160
[42472.474003]  handle_mm_fault+0xe3/0x300
[42472.476887]  do_user_addr_fault+0x202/0x690
[42472.479732]  exc_page_fault+0x73/0x150
[42472.482473]  asm_exc_page_fault+0x26/0x30
[42472.485128] RIP: 0033:0x55ab1f9e1e6d
[42472.487798] RSP: 002b:00007f324cad5500 EFLAGS: 00010206
[42472.490502] RAX: 00007f331af70018 RBX: 00007f3124800230 RCX: 0000000000000000
[42472.493287] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f3124800238
[42472.496080] RBP: 0000000000000000 R08: 00007f324cad5540 R09: 00007f331bb85000
[42472.498861] R10: 0000000000000000 R11: 0000000001434d66 R12: 0000000000000016
[42472.501641] R13: 000055ab1facbf48 R14: 00007f3303e09f20 R15: 00007f3303e09f50
[42472.504423]  </TASK>
[42472.507170] task:cache-worker    state:D stack:0     pid:1124860 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42472.510141] Call Trace:
[42472.513058]  <TASK>
[42472.515942]  __schedule+0x581/0x10b0
[42472.518827]  schedule+0x28/0xa0
[42472.521711]  schedule_preempt_disabled+0x16/0x30
[42472.524612]  rwsem_down_write_slowpath+0x2d8/0x750
[42472.527521]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42472.530463]  down_write+0x5c/0x60
[42472.533367]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42472.536329]  file_update_time_flags+0x7e/0x130
[42472.539263]  __xfs_write_fault+0x8c/0x260 [xfs]
[42472.542232]  do_page_mkwrite+0x4a/0xa0
[42472.545156]  do_wp_page+0x136/0x1160
[42472.548030]  ? restore_fpregs_from_fpstate+0x3c/0xa0
[42472.550925]  ? switch_fpu_return+0x5d/0xe0
[42472.553825]  __handle_mm_fault+0xb5a/0x1170
[42472.556727]  ? futex_wake+0x10c/0x240
[42472.559622]  ? lock_vma_under_rcu+0x92/0x160
[42472.562476]  handle_mm_fault+0xe3/0x300
[42472.565234]  do_user_addr_fault+0x202/0x690
[42472.567900]  exc_page_fault+0x73/0x150
[42472.570583]  asm_exc_page_fault+0x26/0x30
[42472.573282] RIP: 0033:0x55ab1f9e1e6d
[42472.575980] RSP: 002b:00007f329d7145d0 EFLAGS: 00010206
[42472.578706] RAX: 00007f331af70018 RBX: 00007f30e94d1190 RCX: 0000000000000000
[42472.581497] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f30e94d1198
[42472.584293] RBP: 0000000000000000 R08: 0000000000000004 R09: 000000000000001e
[42472.587065] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000016
[42472.589807] R13: 00007f329d715340 R14: 000055ab1facbf38 R15: 0000000000000001
[42472.592540]  </TASK>
[42472.595251] task:cache-worker    state:D stack:0     pid:1124874 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42472.598181] Call Trace:
[42472.601082]  <TASK>
[42472.603958]  __schedule+0x581/0x10b0
[42472.606835]  schedule+0x28/0xa0
[42472.609702]  schedule_preempt_disabled+0x16/0x30
[42472.612589]  rwsem_down_write_slowpath+0x2d8/0x750
[42472.615486]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42472.618420]  down_write+0x5c/0x60
[42472.621312]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42472.624263]  file_update_time_flags+0x7e/0x130
[42472.627143]  __xfs_write_fault+0x8c/0x260 [xfs]
[42472.630055]  do_page_mkwrite+0x4a/0xa0
[42472.632928]  do_wp_page+0x136/0x1160
[42472.635790]  ? do_syscall_64+0x25a/0x550
[42472.638638]  ? __seccomp_filter+0x42/0x5c0
[42472.641447]  __handle_mm_fault+0xb5a/0x1170
[42472.644155]  ? __x64_sys_ioctl+0xb0/0xe0
[42472.646758]  ? lock_vma_under_rcu+0x92/0x160
[42472.649392]  handle_mm_fault+0xe3/0x300
[42472.652024]  do_user_addr_fault+0x202/0x690
[42472.654672]  exc_page_fault+0x73/0x150
[42472.657315]  asm_exc_page_fault+0x26/0x30
[42472.659955] RIP: 0033:0x55ab1f9e1e6d
[42472.662573] RSP: 002b:00007f3287694530 EFLAGS: 00010206
[42472.665220] RAX: 00007f331af70018 RBX: 00007f32c2e09030 RCX: 0000000000000000
[42472.667934] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f32c2e09038
[42472.670637] RBP: 0000000000000000 R08: 00007f3287694540 R09: 00007f331bb85000
[42472.673344] R10: 0000000000000000 R11: 0000000001434d38 R12: 0000000000000016
[42472.676040] R13: 000055ab1facc058 R14: 00007f2d48605268 R15: 00007f3287694820
[42472.678754]  </TASK>
[42472.681440] task:cache-worker    state:D stack:0     pid:1124907 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42472.684341] Call Trace:
[42472.687196]  <TASK>
[42472.690018]  __schedule+0x581/0x10b0
[42472.692864]  schedule+0x28/0xa0
[42472.695693]  schedule_preempt_disabled+0x16/0x30
[42472.698540]  rwsem_down_write_slowpath+0x2d8/0x750
[42472.701398]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42472.704308]  down_write+0x5c/0x60
[42472.707159]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42472.710069]  file_update_time_flags+0x7e/0x130
[42472.712915]  __xfs_write_fault+0x8c/0x260 [xfs]
[42472.715787]  do_page_mkwrite+0x4a/0xa0
[42472.718626]  do_wp_page+0x136/0x1160
[42472.721485]  ? restore_fpregs_from_fpstate+0x3c/0xa0
[42472.724379]  __handle_mm_fault+0xb5a/0x1170
[42472.727230]  ? __x64_sys_ioctl+0xb0/0xe0
[42472.729971]  ? lock_vma_under_rcu+0x92/0x160
[42472.732629]  handle_mm_fault+0xe3/0x300
[42472.735301]  do_user_addr_fault+0x202/0x690
[42472.737982]  exc_page_fault+0x73/0x150
[42472.740673]  asm_exc_page_fault+0x26/0x30
[42472.743366] RIP: 0033:0x55ab1f9e1e6d
[42472.746042] RSP: 002b:00007f32cf768530 EFLAGS: 00010206
[42472.748746] RAX: 00007f331af70018 RBX: 00007f32cb613610 RCX: 0000000000000000
[42472.751509] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f32cb613618
[42472.754272] RBP: 0000000000000000 R08: 00007f32cf768540 R09: 00007f331bb85000
[42472.757030] R10: 0000000000000000 R11: 0000000001435142 R12: 0000000000000016
[42472.759787] R13: 000055ab1facc058 R14: 00007f310fb385e8 R15: 00007f32cf768820
[42472.762543]  </TASK>
[42472.765289] task:cache-worker    state:D stack:0     pid:1124923 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42472.768268] Call Trace:
[42472.771203]  <TASK>
[42472.774109]  __schedule+0x581/0x10b0
[42472.777041]  schedule+0x28/0xa0
[42472.779958]  schedule_preempt_disabled+0x16/0x30
[42472.782892]  rwsem_down_write_slowpath+0x2d8/0x750
[42472.785841]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42472.788829]  down_write+0x5c/0x60
[42472.791774]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42472.794777]  file_update_time_flags+0x7e/0x130
[42472.797745]  __xfs_write_fault+0x8c/0x260 [xfs]
[42472.800732]  do_page_mkwrite+0x4a/0xa0
[42472.803651]  do_wp_page+0x136/0x1160
[42472.806555]  __handle_mm_fault+0xb5a/0x1170
[42472.809475]  ? lock_vma_under_rcu+0x92/0x160
[42472.812386]  handle_mm_fault+0xe3/0x300
[42472.815244]  do_user_addr_fault+0x202/0x690
[42472.818007]  exc_page_fault+0x73/0x150
[42472.820678]  asm_exc_page_fault+0x26/0x30
[42472.823373] RIP: 0033:0x55ab1f9e1e6d
[42472.826063] RSP: 002b:00007f324cb29550 EFLAGS: 00010206
[42472.828799] RAX: 00007f331af70018 RBX: 00007f3128a153c0 RCX: 0000000000000000
[42472.831602] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f3128a153c8
[42472.834408] RBP: 0000000000000000 R08: 00007f324cb29540 R09: 00007f331bb85000
[42472.837205] R10: 0000000000000000 R11: 0000000001434d5e R12: 0000000000000016
[42472.839996] R13: 0000000000000000 R14: 000055ab1facbd20 R15: 00007f324cb2a340
[42472.842772]  </TASK>
[42472.845524] task:cache-worker    state:D stack:0     pid:1124964 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42472.848503] Call Trace:
[42472.851429]  <TASK>
[42472.854329]  __schedule+0x581/0x10b0
[42472.857234]  schedule+0x28/0xa0
[42472.860109]  schedule_preempt_disabled+0x16/0x30
[42472.863005]  rwsem_down_write_slowpath+0x2d8/0x750
[42472.865916]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42472.868869]  down_write+0x5c/0x60
[42472.871774]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42472.874738]  file_update_time_flags+0x7e/0x130
[42472.877677]  __xfs_write_fault+0x8c/0x260 [xfs]
[42472.880658]  do_page_mkwrite+0x4a/0xa0
[42472.883588]  do_wp_page+0x136/0x1160
[42472.886464]  __handle_mm_fault+0xb5a/0x1170
[42472.889341]  ? lock_vma_under_rcu+0x92/0x160
[42472.892235]  handle_mm_fault+0xe3/0x300
[42472.895184]  do_user_addr_fault+0x202/0x690
[42472.898063]  exc_page_fault+0x73/0x150
[42472.900882]  asm_exc_page_fault+0x26/0x30
[42472.903611] RIP: 0033:0x55ab1f9e1e6d
[42472.906234] RSP: 002b:00007f329b014550 EFLAGS: 00010206
[42472.908918] RAX: 00007f331af70018 RBX: 00007f316e635f80 RCX: 0000000000000000
[42472.911679] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f316e635f88
[42472.914456] RBP: 0000000000000000 R08: 00007f329b014540 R09: 00007f331bb85000
[42472.917238] R10: 0000000000000000 R11: 0000000001434d74 R12: 0000000000000016
[42472.920013] R13: 0000000000000000 R14: 000055ab1facbd20 R15: 00007f329b015340
[42472.922771]  </TASK>
[42472.925504] task:cache-worker    state:D stack:0     pid:1124974 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42472.928457] Call Trace:
[42472.931360]  <TASK>
[42472.934228]  __schedule+0x581/0x10b0
[42472.937111]  schedule+0x28/0xa0
[42472.939987]  schedule_preempt_disabled+0x16/0x30
[42472.942877]  rwsem_down_write_slowpath+0x2d8/0x750
[42472.945779]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42472.948724]  down_write+0x5c/0x60
[42472.951619]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42472.954573]  file_update_time_flags+0x7e/0x130
[42472.957503]  __xfs_write_fault+0x8c/0x260 [xfs]
[42472.960471]  do_page_mkwrite+0x4a/0xa0
[42472.963392]  do_wp_page+0x136/0x1160
[42472.966259]  __handle_mm_fault+0xb5a/0x1170
[42472.969129]  ? lock_vma_under_rcu+0x92/0x160
[42472.972007]  handle_mm_fault+0xe3/0x300
[42472.974872]  do_user_addr_fault+0x202/0x690
[42472.977749]  exc_page_fault+0x73/0x150
[42472.980575]  asm_exc_page_fault+0x26/0x30
[42472.983306] RIP: 0033:0x55ab1f9e1e6d
[42472.985935] RSP: 002b:00007f3252f3e550 EFLAGS: 00010206
[42472.988622] RAX: 00007f331af70018 RBX: 00007f311aa0a320 RCX: 0000000000000000
[42472.991389] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f311aa0a328
[42472.994170] RBP: 0000000000000000 R08: 00007f3252f3e540 R09: 00007f331bb85000
[42472.996956] R10: 0000000000000000 R11: 0000000001434d64 R12: 0000000000000016
[42472.999741] R13: 0000000000000000 R14: 000055ab1facbd20 R15: 00007f3252f3f340
[42473.002505]  </TASK>
[42473.005240] task:cache-worker    state:D stack:0     pid:1124975 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42473.008202] Call Trace:
[42473.011105]  <TASK>
[42473.013983]  __schedule+0x581/0x10b0
[42473.016869]  schedule+0x28/0xa0
[42473.019751]  schedule_preempt_disabled+0x16/0x30
[42473.022648]  rwsem_down_write_slowpath+0x2d8/0x750
[42473.025556]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42473.028509]  down_write+0x5c/0x60
[42473.031411]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42473.034369]  file_update_time_flags+0x7e/0x130
[42473.037306]  __xfs_write_fault+0x8c/0x260 [xfs]
[42473.040278]  do_page_mkwrite+0x4a/0xa0
[42473.043204]  do_wp_page+0x136/0x1160
[42473.046074]  ? restore_fpregs_from_fpstate+0x3c/0xa0
[42473.048971]  ? switch_fpu_return+0x5d/0xe0
[42473.051866]  __handle_mm_fault+0xb5a/0x1170
[42473.054759]  ? lock_vma_under_rcu+0x92/0x160
[42473.057664]  handle_mm_fault+0xe3/0x300
[42473.060517]  do_user_addr_fault+0x202/0x690
[42473.063280]  exc_page_fault+0x73/0x150
[42473.065941]  asm_exc_page_fault+0x26/0x30
[42473.068630] RIP: 0033:0x55ab1f9e1e6d
[42473.071320] RSP: 002b:00007f329b66a530 EFLAGS: 00010206
[42473.074043] RAX: 00007f331af70018 RBX: 00007f3292a11800 RCX: 0000000000000000
[42473.076839] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f3292a11808
[42473.079641] RBP: 0000000000000000 R08: 00007f329b66a540 R09: 00007f331bb85000
[42473.082426] R10: 0000000000000000 R11: 000000000143556e R12: 0000000000000016
[42473.085210] R13: 000055ab1facc058 R14: 00007f30f81be2a8 R15: 00007f329b66a820
[42473.087998]  </TASK>
[42473.090755] task:cache-worker    state:D stack:0     pid:1125124 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42473.093743] Call Trace:
[42473.096678]  <TASK>
[42473.099591]  __schedule+0x581/0x10b0
[42473.102515]  schedule+0x28/0xa0
[42473.105428]  schedule_preempt_disabled+0x16/0x30
[42473.108359]  rwsem_down_write_slowpath+0x2d8/0x750
[42473.111303]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42473.114279]  down_write+0x5c/0x60
[42473.117216]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42473.120212]  file_update_time_flags+0x7e/0x130
[42473.123170]  ? __x64_sys_ioctl+0xb0/0xe0
[42473.126089]  __xfs_write_fault+0x8c/0x260 [xfs]
[42473.129040]  do_page_mkwrite+0x4a/0xa0
[42473.131952]  do_wp_page+0x136/0x1160
[42473.134846]  __handle_mm_fault+0xb5a/0x1170
[42473.137758]  ? lock_vma_under_rcu+0x92/0x160
[42473.140626]  handle_mm_fault+0xe3/0x300
[42473.143392]  do_user_addr_fault+0x202/0x690
[42473.146065]  exc_page_fault+0x73/0x150
[42473.148763]  asm_exc_page_fault+0x26/0x30
[42473.151468] RIP: 0033:0x55ab1f9e1e6d
[42473.154169] RSP: 002b:00007f31bd440550 EFLAGS: 00010206
[42473.156908] RAX: 00007f331af70018 RBX: 00007f3175676760 RCX: 0000000000000000
[42473.159708] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f3175676768
[42473.162505] RBP: 0000000000000000 R08: 00007f31bd440540 R09: 00007f331bb85000
[42473.165299] R10: 0000000000000000 R11: 0000000001434df6 R12: 0000000000000016
[42473.168080] R13: 0000000000000000 R14: 000055ab1facbd20 R15: 00007f31bd441340
[42473.170848]  </TASK>
[42473.173594] task:cache-worker    state:D stack:0     pid:1125132 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42473.176572] Call Trace:
[42473.179507]  <TASK>
[42473.182394]  __schedule+0x581/0x10b0
[42473.185295]  schedule+0x28/0xa0
[42473.188177]  schedule_preempt_disabled+0x16/0x30
[42473.191071]  rwsem_down_write_slowpath+0x2d8/0x750
[42473.193983]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42473.196937]  down_write+0x5c/0x60
[42473.199838]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42473.202802]  file_update_time_flags+0x7e/0x130
[42473.205743]  __xfs_write_fault+0x8c/0x260 [xfs]
[42473.208722]  do_page_mkwrite+0x4a/0xa0
[42473.211613]  do_wp_page+0x136/0x1160
[42473.214480]  __handle_mm_fault+0xb5a/0x1170
[42473.217365]  ? lock_vma_under_rcu+0x92/0x160
[42473.220256]  handle_mm_fault+0xe3/0x300
[42473.223120]  do_user_addr_fault+0x202/0x690
[42473.225950]  exc_page_fault+0x73/0x150
[42473.228675]  asm_exc_page_fault+0x26/0x30
[42473.231309] RIP: 0033:0x55ab1f9e1e6d
[42473.233957] RSP: 002b:00007f32876a9550 EFLAGS: 00010206
[42473.236651] RAX: 00007f331af70018 RBX: 00007f329e8105a0 RCX: 0000000000000000
[42473.239414] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f329e8105a8
[42473.242186] RBP: 0000000000000000 R08: 00007f32876a9540 R09: 00007f331bb85000
[42473.244960] R10: 0000000000000000 R11: 0000000001434df4 R12: 0000000000000016
[42473.247721] R13: 0000000000000000 R14: 000055ab1facbd20 R15: 00007f32876aa340
[42473.250468]  </TASK>
[42473.253191] task:cache-worker    state:D stack:0     pid:1125142 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42473.256137] Call Trace:
[42473.259027]  <TASK>
[42473.261896]  __schedule+0x581/0x10b0
[42473.264776]  schedule+0x28/0xa0
[42473.267646]  schedule_preempt_disabled+0x16/0x30
[42473.270529]  rwsem_down_write_slowpath+0x2d8/0x750
[42473.273423]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42473.276356]  down_write+0x5c/0x60
[42473.279241]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42473.282184]  file_update_time_flags+0x7e/0x130
[42473.285109]  __xfs_write_fault+0x8c/0x260 [xfs]
[42473.288070]  do_page_mkwrite+0x4a/0xa0
[42473.290982]  do_wp_page+0x136/0x1160
[42473.293850]  __handle_mm_fault+0xb5a/0x1170
[42473.296718]  ? lock_vma_under_rcu+0x92/0x160
[42473.299594]  handle_mm_fault+0xe3/0x300
[42473.302456]  do_user_addr_fault+0x202/0x690
[42473.305334]  exc_page_fault+0x73/0x150
[42473.308161]  asm_exc_page_fault+0x26/0x30
[42473.310887] RIP: 0033:0x55ab1f9e1e6d
[42473.313523] RSP: 002b:00007f328767f500 EFLAGS: 00010206
[42473.316214] RAX: 00007f331af70018 RBX: 00007f329d213020 RCX: 0000000000000000
[42473.318972] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f329d213028
[42473.321757] RBP: 0000000000000000 R08: 00007f328767f540 R09: 00007f331bb85000
[42473.324543] R10: 0000000000000000 R11: 0000000001434d52 R12: 0000000000000016
[42473.327322] R13: 000055ab1facbf48 R14: 00007f330463d620 R15: 00007f330463d650
[42473.330100]  </TASK>
[42473.332848] task:cache-worker    state:D stack:0     pid:1125144 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42473.335839] Call Trace:
[42473.338752]  <TASK>
[42473.341639]  __schedule+0x581/0x10b0
[42473.344537]  schedule+0x28/0xa0
[42473.347426]  schedule_preempt_disabled+0x16/0x30
[42473.350332]  rwsem_down_write_slowpath+0x2d8/0x750
[42473.353248]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42473.356207]  down_write+0x5c/0x60
[42473.359113]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42473.362085]  file_update_time_flags+0x7e/0x130
[42473.365035]  __xfs_write_fault+0x8c/0x260 [xfs]
[42473.368019]  do_page_mkwrite+0x4a/0xa0
[42473.370950]  do_wp_page+0x136/0x1160
[42473.373837]  ? do_syscall_64+0x25a/0x550
[42473.376718]  ? __seccomp_filter+0x42/0x5c0
[42473.379597]  __handle_mm_fault+0xb5a/0x1170
[42473.382470]  ? __x64_sys_ioctl+0xb0/0xe0
[42473.385343]  ? lock_vma_under_rcu+0x92/0x160
[42473.388173]  handle_mm_fault+0xe3/0x300
[42473.390892]  do_user_addr_fault+0x202/0x690
[42473.393530]  exc_page_fault+0x73/0x150
[42473.396190]  asm_exc_page_fault+0x26/0x30
[42473.398849] RIP: 0033:0x55ab1f9e1e6d
[42473.401517] RSP: 002b:00007f328fe2b550 EFLAGS: 00010206
[42473.404222] RAX: 00007f331af70018 RBX: 00007f329e012490 RCX: 0000000000000000
[42473.406982] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f329e012498
[42473.409748] RBP: 0000000000000000 R08: 00007f328fe2b540 R09: 00007f331bb85000
[42473.412505] R10: 0000000000000000 R11: 0000000001434db6 R12: 0000000000000016
[42473.415260] R13: 0000000000000000 R14: 000055ab1facbd20 R15: 00007f328fe2c340
[42473.417992]  </TASK>
[42473.420703] task:cache-worker    state:D stack:0     pid:1125151 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42473.423642] Call Trace:
[42473.426538]  <TASK>
[42473.429408]  __schedule+0x581/0x10b0
[42473.432290]  schedule+0x28/0xa0
[42473.435152]  schedule_preempt_disabled+0x16/0x30
[42473.438039]  rwsem_down_write_slowpath+0x2d8/0x750
[42473.440932]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42473.443872]  down_write+0x5c/0x60
[42473.446754]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42473.449698]  file_update_time_flags+0x7e/0x130
[42473.452581]  __xfs_write_fault+0x8c/0x260 [xfs]
[42473.455488]  do_page_mkwrite+0x4a/0xa0
[42473.458349]  do_wp_page+0x136/0x1160
[42473.461205]  __handle_mm_fault+0xb5a/0x1170
[42473.464061]  ? switch_fpu_return+0x5d/0xe0
[42473.466864]  ? lock_vma_under_rcu+0x92/0x160
[42473.469576]  handle_mm_fault+0xe3/0x300
[42473.472189]  do_user_addr_fault+0x202/0x690
[42473.474824]  exc_page_fault+0x73/0x150
[42473.477468]  asm_exc_page_fault+0x26/0x30
[42473.480118] RIP: 0033:0x55ab1f9e1e6d
[42473.482760] RSP: 002b:00007f331aea5500 EFLAGS: 00010206
[42473.485435] RAX: 00007f331af70018 RBX: 00007f32ed609d20 RCX: 0000000000000000
[42473.488167] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f32ed609d28
[42473.490897] RBP: 0000000000000000 R08: 00007f331aea5540 R09: 00007f331bb85000
[42473.493626] R10: 0000000000000000 R11: 0000000001434d60 R12: 0000000000000016
[42473.496343] R13: 000055ab1facbf48 R14: 00007f3303e07520 R15: 00007f3303e07550
[42473.499065]  </TASK>
[42473.501769] task:cache-worker    state:D stack:0     pid:1125174 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42473.504704] Call Trace:
[42473.507598]  <TASK>
[42473.510459]  __schedule+0x581/0x10b0
[42473.513350]  schedule+0x28/0xa0
[42473.516227]  schedule_preempt_disabled+0x16/0x30
[42473.519120]  rwsem_down_write_slowpath+0x2d8/0x750
[42473.522031]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42473.524983]  down_write+0x5c/0x60
[42473.527886]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42473.530850]  file_update_time_flags+0x7e/0x130
[42473.533790]  __xfs_write_fault+0x8c/0x260 [xfs]
[42473.536758]  do_page_mkwrite+0x4a/0xa0
[42473.539649]  do_wp_page+0x136/0x1160
[42473.542511]  __handle_mm_fault+0xb5a/0x1170
[42473.545394]  ? lock_vma_under_rcu+0x92/0x160
[42473.548277]  handle_mm_fault+0xe3/0x300
[42473.551151]  do_user_addr_fault+0x202/0x690
[42473.553991]  exc_page_fault+0x73/0x150
[42473.556731]  asm_exc_page_fault+0x26/0x30
[42473.559371] RIP: 0033:0x55ab1f9e1e6d
[42473.562024] RSP: 002b:00007f321d4e8530 EFLAGS: 00010206
[42473.564725] RAX: 00007f331af70018 RBX: 00007f32a6012710 RCX: 0000000000000000
[42473.567496] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f32a6012718
[42473.570274] RBP: 0000000000000000 R08: 00007f321d4e8540 R09: 00007f331bb85000
[42473.573055] R10: 0000000000000000 R11: 000000000143527e R12: 0000000000000016
[42473.575824] R13: 000055ab1facc058 R14: 00007f31730c1c68 R15: 00007f321d4e8820
[42473.578595]  </TASK>
[42473.581343] task:cache-worker    state:D stack:0     pid:1125191 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42473.584310] Call Trace:
[42473.587229]  <TASK>
[42473.590107]  __schedule+0x581/0x10b0
[42473.593019]  schedule+0x28/0xa0
[42473.595911]  schedule_preempt_disabled+0x16/0x30
[42473.598816]  rwsem_down_write_slowpath+0x2d8/0x750
[42473.601739]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42473.604705]  down_write+0x5c/0x60
[42473.607624]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42473.610597]  file_update_time_flags+0x7e/0x130
[42473.613554]  __xfs_write_fault+0x8c/0x260 [xfs]
[42473.616546]  do_page_mkwrite+0x4a/0xa0
[42473.619491]  do_wp_page+0x136/0x1160
[42473.622382]  __handle_mm_fault+0xb5a/0x1170
[42473.625274]  ? do_vfs_ioctl+0x475/0x940
[42473.628169]  ? lock_vma_under_rcu+0x92/0x160
[42473.631058]  handle_mm_fault+0xe3/0x300
[42473.633936]  do_user_addr_fault+0x202/0x690
[42473.636774]  exc_page_fault+0x73/0x150
[42473.639510]  asm_exc_page_fault+0x26/0x30
[42473.642147] RIP: 0033:0x55ab1f9e1e6d
[42473.644810] RSP: 002b:00007f31bd455550 EFLAGS: 00010206
[42473.647513] RAX: 00007f331af70018 RBX: 00007f3292face00 RCX: 0000000000000000
[42473.650282] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f3292face08
[42473.653073] RBP: 0000000000000000 R08: 00007f31bd455540 R09: 00007f331bb85000
[42473.655856] R10: 0000000000000000 R11: 0000000001434d6c R12: 0000000000000016
[42473.658621] R13: 0000000000000000 R14: 000055ab1facbd20 R15: 00007f31bd456340
[42473.661382]  </TASK>
[42473.664108] task:cache-worker    state:D stack:0     pid:1125201 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42473.667054] Call Trace:
[42473.669961]  <TASK>
[42473.672837]  __schedule+0x581/0x10b0
[42473.675737]  schedule+0x28/0xa0
[42473.678608]  schedule_preempt_disabled+0x16/0x30
[42473.681504]  rwsem_down_write_slowpath+0x2d8/0x750
[42473.684415]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42473.687362]  down_write+0x5c/0x60
[42473.690256]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42473.693223]  file_update_time_flags+0x7e/0x130
[42473.696164]  __xfs_write_fault+0x8c/0x260 [xfs]
[42473.699138]  do_page_mkwrite+0x4a/0xa0
[42473.702033]  do_wp_page+0x136/0x1160
[42473.704908]  __handle_mm_fault+0xb5a/0x1170
[42473.707794]  ? lock_vma_under_rcu+0x92/0x160
[42473.710679]  handle_mm_fault+0xe3/0x300
[42473.713549]  do_user_addr_fault+0x202/0x690
[42473.716378]  exc_page_fault+0x73/0x150
[42473.719099]  asm_exc_page_fault+0x26/0x30
[42473.721734] RIP: 0033:0x55ab1f9e1e6d
[42473.724388] RSP: 002b:00007f330ffb9550 EFLAGS: 00010206
[42473.727073] RAX: 00007f331af70018 RBX: 00007f32ffa05d50 RCX: 0000000000000000
[42473.729841] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f32ffa05d58
[42473.732625] RBP: 0000000000000000 R08: 00007f330ffb9540 R09: 00007f331bb85000
[42473.735398] R10: 0000000000000000 R11: 0000000001434d20 R12: 0000000000000016
[42473.738153] R13: 0000000000000000 R14: 000055ab1facbd20 R15: 00007f330ffba340
[42473.740902]  </TASK>
[42473.743616] task:cache-worker    state:D stack:0     pid:1125206 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42473.746547] Call Trace:
[42473.749439]  <TASK>
[42473.752297]  __schedule+0x581/0x10b0
[42473.755178]  schedule+0x28/0xa0
[42473.758038]  schedule_preempt_disabled+0x16/0x30
[42473.760918]  rwsem_down_write_slowpath+0x2d8/0x750
[42473.763813]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42473.766743]  down_write+0x5c/0x60
[42473.769630]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42473.772581]  file_update_time_flags+0x7e/0x130
[42473.775503]  __xfs_write_fault+0x8c/0x260 [xfs]
[42473.778457]  do_page_mkwrite+0x4a/0xa0
[42473.781369]  do_wp_page+0x136/0x1160
[42473.784236]  __handle_mm_fault+0xb5a/0x1170
[42473.787096]  ? lock_vma_under_rcu+0x92/0x160
[42473.789969]  handle_mm_fault+0xe3/0x300
[42473.792837]  do_user_addr_fault+0x202/0x690
[42473.795710]  exc_page_fault+0x73/0x150
[42473.798526]  asm_exc_page_fault+0x26/0x30
[42473.801253] RIP: 0033:0x55ab1f9e1e6d
[42473.803882] RSP: 002b:00007f329ff7d550 EFLAGS: 00010206
[42473.806558] RAX: 00007f331af70018 RBX: 00007f3282610870 RCX: 0000000000000000
[42473.809316] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f3282610878
[42473.812094] RBP: 0000000000000000 R08: 00007f329ff7d540 R09: 00007f331bb85000
[42473.814867] R10: 0000000000000000 R11: 0000000001434d36 R12: 0000000000000016
[42473.817643] R13: 0000000000000000 R14: 000055ab1facbd20 R15: 00007f329ff7e340
[42473.820407]  </TASK>
[42473.823127] task:cache-worker    state:D stack:0     pid:1125208 tgid:849910 ppid:13218  task_flags:0x400040 flags:0x00080000
[42473.826077] Call Trace:
[42473.828974]  <TASK>
[42473.831838]  __schedule+0x581/0x10b0
[42473.834710]  schedule+0x28/0xa0
[42473.837578]  schedule_preempt_disabled+0x16/0x30
[42473.840467]  rwsem_down_write_slowpath+0x2d8/0x750
[42473.843362]  down_write+0x5c/0x60
[42473.846237]  xfs_buffered_write_iomap_begin+0x1ed/0xe20 [xfs]
[42473.849215]  ? __pfx_simple_copy_to_iter+0x10/0x10
[42473.852171]  xfs_buffered_write_iomap_next+0x7f/0x180 [xfs]
[42473.855181]  iomap_iter+0x44/0x2e0
[42473.858153]  iomap_page_mkwrite+0x13a/0x280
[42473.861124]  __xfs_write_fault+0x17f/0x260 [xfs]
[42473.864100]  do_page_mkwrite+0x4a/0xa0
[42473.867020]  do_wp_page+0x136/0x1160
[42473.869935]  ? ksys_read+0xcb/0xe0
[42473.872842]  __handle_mm_fault+0xb5a/0x1170
[42473.875766]  ? lock_vma_under_rcu+0x92/0x160
[42473.878643]  handle_mm_fault+0xe3/0x300
[42473.881423]  do_user_addr_fault+0x202/0x690
[42473.884113]  exc_page_fault+0x73/0x150
[42473.886814]  asm_exc_page_fault+0x26/0x30
[42473.889528] RIP: 0033:0x55ab1f9e1e6d
[42473.892241] RSP: 002b:00007f330c1bb6c0 EFLAGS: 00010206
[42473.894986] RAX: 00007f331afea018 RBX: 00007f32516f1050 RCX: 0000000000000000
[42473.897800] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f32516f1058
[42473.900619] RBP: 0000000000000000 R08: 0000000000000000 R09: 000055ab1fb05cbe
[42473.903419] R10: 000000000000000d R11: 000000000000000e R12: 0000000000000016
[42473.906192] R13: 000055ab1fafd530 R14: 00007f330c1bc340 R15: 00007f330c1bc390
[42473.908972]  </TASK>
[42473.911722] task:cache-worker    state:D stack:0     pid:1125210 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42473.914694] Call Trace:
[42473.917636]  <TASK>
[42473.920542]  __schedule+0x581/0x10b0
[42473.923468]  schedule+0x28/0xa0
[42473.926372]  schedule_preempt_disabled+0x16/0x30
[42473.929303]  rwsem_down_write_slowpath+0x2d8/0x750
[42473.932240]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42473.935226]  down_write+0x5c/0x60
[42473.938150]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42473.941140]  file_update_time_flags+0x7e/0x130
[42473.944063]  __xfs_write_fault+0x8c/0x260 [xfs]
[42473.947007]  do_page_mkwrite+0x4a/0xa0
[42473.949914]  do_wp_page+0x136/0x1160
[42473.952809]  __handle_mm_fault+0xb5a/0x1170
[42473.955718]  ? switch_fpu_return+0x5d/0xe0
[42473.958576]  ? lock_vma_under_rcu+0x92/0x160
[42473.961345]  handle_mm_fault+0xe3/0x300
[42473.964016]  do_user_addr_fault+0x202/0x690
[42473.966709]  exc_page_fault+0x73/0x150
[42473.969412]  asm_exc_page_fault+0x26/0x30
[42473.972124] RIP: 0033:0x55ab1f9e1e6d
[42473.974825] RSP: 002b:00007f33135e7530 EFLAGS: 00010206
[42473.977555] RAX: 00007f331af70018 RBX: 00007f3257212210 RCX: 0000000000000000
[42473.980340] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f3257212218
[42473.983107] RBP: 0000000000000000 R08: 00007f33135e7540 R09: 00007f331bb85000
[42473.985860] R10: 0000000000000000 R11: 0000000001435682 R12: 0000000000000016
[42473.988589] R13: 000055ab1facc058 R14: 00007f3295635568 R15: 00007f33135e7820
[42473.991313]  </TASK>
[42473.994011] task:cache-worker    state:D stack:0     pid:1125212 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42473.996940] Call Trace:
[42473.999821]  <TASK>
[42474.002676]  __schedule+0x581/0x10b0
[42474.005569]  schedule+0x28/0xa0
[42474.008444]  schedule_preempt_disabled+0x16/0x30
[42474.011335]  rwsem_down_write_slowpath+0x2d8/0x750
[42474.014232]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42474.017179]  down_write+0x5c/0x60
[42474.020076]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42474.023033]  file_update_time_flags+0x7e/0x130
[42474.025965]  __xfs_write_fault+0x8c/0x260 [xfs]
[42474.028931]  do_page_mkwrite+0x4a/0xa0
[42474.031821]  do_wp_page+0x136/0x1160
[42474.034682]  __handle_mm_fault+0xb5a/0x1170
[42474.037563]  ? lock_vma_under_rcu+0x92/0x160
[42474.040468]  handle_mm_fault+0xe3/0x300
[42474.043349]  do_user_addr_fault+0x202/0x690
[42474.046187]  exc_page_fault+0x73/0x150
[42474.048931]  asm_exc_page_fault+0x26/0x30
[42474.051579] RIP: 0033:0x55ab1f9e1e6d
[42474.054244] RSP: 002b:00007f317a229550 EFLAGS: 00010206
[42474.056954] RAX: 00007f331af70018 RBX: 00007f3254407c30 RCX: 0000000000000000
[42474.059733] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f3254407c38
[42474.062523] RBP: 0000000000000000 R08: 00007f317a229540 R09: 00007f331bb85000
[42474.065313] R10: 0000000000000000 R11: 0000000001434e08 R12: 0000000000000016
[42474.068090] R13: 0000000000000000 R14: 000055ab1facbd20 R15: 00007f317a22a340
[42474.070854]  </TASK>
[42474.073595] task:cache-worker    state:D stack:0     pid:1125223 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42474.076556] Call Trace:
[42474.079470]  <TASK>
[42474.082343]  __schedule+0x581/0x10b0
[42474.085250]  schedule+0x28/0xa0
[42474.088137]  schedule_timeout+0xbd/0x100
[42474.091018]  __down_common+0x17c/0x340
[42474.093902]  ? release_sock+0x1d/0xc0
[42474.096777]  down+0x52/0x70
[42474.099629]  xfs_buf_lock+0x32/0xd0 [xfs]
[42474.102538]  xfs_buf_find_lock+0x51/0x100 [xfs]
[42474.105439]  xfs_buf_read_map+0x94/0x2b0 [xfs]
[42474.108330]  ? xfs_read_icluster+0x7f/0xd0 [xfs]
[42474.111258]  ? sock_read_iter+0x8d/0xf0
[42474.114080]  xfs_trans_read_buf_map+0x12d/0x270 [xfs]
[42474.116978]  ? xfs_read_icluster+0x7f/0xd0 [xfs]
[42474.119881]  xfs_read_icluster+0x7f/0xd0 [xfs]
[42474.122774]  xfs_inode_item_precommit+0x22f/0x2d0 [xfs]
[42474.125690]  __xfs_trans_commit+0xb9/0x300 [xfs]
[42474.128563]  xfs_trans_commit+0x38/0x70 [xfs]
[42474.131341]  xfs_vn_update_time+0x187/0x1b0 [xfs]
[42474.134035]  file_update_time_flags+0x7e/0x130
[42474.136722]  __xfs_write_fault+0x8c/0x260 [xfs]
[42474.139455]  do_page_mkwrite+0x4a/0xa0
[42474.142145]  do_wp_page+0x136/0x1160
[42474.144830]  ? do_syscall_64+0xf9/0x550
[42474.147509]  __handle_mm_fault+0xb5a/0x1170
[42474.150180]  ? __wake_up_common+0x77/0xa0
[42474.152845]  ? lock_vma_under_rcu+0x92/0x160
[42474.155505]  handle_mm_fault+0xe3/0x300
[42474.158141]  do_user_addr_fault+0x202/0x690
[42474.160786]  exc_page_fault+0x73/0x150
[42474.163421]  asm_exc_page_fault+0x26/0x30
[42474.166062] RIP: 0033:0x55ab1f9e1e6d
[42474.168702] RSP: 002b:00007f330febd520 EFLAGS: 00010206
[42474.171368] RAX: 00007f331af6f018 RBX: 00007f331b024d90 RCX: 0000000000000000
[42474.174105] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f331b024d98
[42474.176849] RBP: 0000000000000000 R08: 0000000000000073 R09: 00000000ffffffff
[42474.179581] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000016
[42474.182295] R13: 00007f331b03f7d8 R14: 00007f330febe340 R15: 00007f3305eae700
[42474.185026]  </TASK>
[42474.187717] task:cache-worker    state:D stack:0     pid:1125224 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42474.190604] Call Trace:
[42474.193443]  <TASK>
[42474.196252]  __schedule+0x581/0x10b0
[42474.199075]  schedule+0x28/0xa0
[42474.201887]  schedule_preempt_disabled+0x16/0x30
[42474.204676]  rwsem_down_write_slowpath+0x2d8/0x750
[42474.207381]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42474.210037]  down_write+0x5c/0x60
[42474.212668]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42474.215371]  file_update_time_flags+0x7e/0x130
[42474.218050]  __xfs_write_fault+0x8c/0x260 [xfs]
[42474.220787]  do_page_mkwrite+0x4a/0xa0
[42474.223481]  do_wp_page+0x136/0x1160
[42474.226167]  __handle_mm_fault+0xb5a/0x1170
[42474.228876]  ? lock_vma_under_rcu+0x92/0x160
[42474.231594]  handle_mm_fault+0xe3/0x300
[42474.234303]  do_user_addr_fault+0x202/0x690
[42474.237030]  exc_page_fault+0x73/0x150
[42474.239749]  asm_exc_page_fault+0x26/0x30
[42474.242455] RIP: 0033:0x55ab1f9e1e6d
[42474.245150] RSP: 002b:00007f327e055550 EFLAGS: 00010206
[42474.247860] RAX: 00007f331af70018 RBX: 00007f32450cc410 RCX: 0000000000000000
[42474.250618] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f32450cc418
[42474.253384] RBP: 0000000000000000 R08: 00007f327e055540 R09: 00007f331bb85000
[42474.256131] R10: 0000000000000000 R11: 0000000001434dd4 R12: 0000000000000016
[42474.258865] R13: 0000000000000000 R14: 000055ab1facbd20 R15: 00007f327e056340
[42474.261596]  </TASK>
[42474.264291] task:cache-worker    state:D stack:0     pid:1125228 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42474.267214] Call Trace:
[42474.270082]  <TASK>
[42474.272940]  __schedule+0x581/0x10b0
[42474.275814]  schedule+0x28/0xa0
[42474.278667]  schedule_preempt_disabled+0x16/0x30
[42474.281548]  rwsem_down_write_slowpath+0x2d8/0x750
[42474.284442]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42474.287386]  down_write+0x5c/0x60
[42474.290270]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42474.293222]  file_update_time_flags+0x7e/0x130
[42474.296147]  __xfs_write_fault+0x8c/0x260 [xfs]
[42474.299108]  do_page_mkwrite+0x4a/0xa0
[42474.302023]  do_wp_page+0x136/0x1160
[42474.304892]  ? __x64_sys_ioctl+0xb0/0xe0
[42474.307752]  __handle_mm_fault+0xb5a/0x1170
[42474.310612]  ? switch_fpu_return+0x5d/0xe0
[42474.313496]  ? lock_vma_under_rcu+0x92/0x160
[42474.316368]  handle_mm_fault+0xe3/0x300
[42474.319180]  do_user_addr_fault+0x202/0x690
[42474.321908]  exc_page_fault+0x73/0x150
[42474.324538]  asm_exc_page_fault+0x26/0x30
[42474.327183] RIP: 0033:0x55ab1f9e1e6d
[42474.329839] RSP: 002b:00007f328fe40550 EFLAGS: 00010206
[42474.332533] RAX: 00007f331af70018 RBX: 00007f3125e0fcb0 RCX: 0000000000000000
[42474.335294] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f3125e0fcb8
[42474.338053] RBP: 0000000000000000 R08: 00007f328fe40540 R09: 00007f331bb85000
[42474.340809] R10: 0000000000000000 R11: 0000000001434d20 R12: 0000000000000016
[42474.343555] R13: 0000000000000000 R14: 000055ab1facbd20 R15: 00007f328fe41340
[42474.346282]  </TASK>
[42474.348976] task:cache-worker    state:D stack:0     pid:1125229 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42474.351906] Call Trace:
[42474.354774]  <TASK>
[42474.357639]  __schedule+0x581/0x10b0
[42474.360509]  schedule+0x28/0xa0
[42474.363360]  schedule_preempt_disabled+0x16/0x30
[42474.366224]  rwsem_down_write_slowpath+0x2d8/0x750
[42474.369102]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42474.372025]  down_write+0x5c/0x60
[42474.374896]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42474.377837]  file_update_time_flags+0x7e/0x130
[42474.380739]  __xfs_write_fault+0x8c/0x260 [xfs]
[42474.383647]  do_page_mkwrite+0x4a/0xa0
[42474.386494]  do_wp_page+0x136/0x1160
[42474.389338]  __handle_mm_fault+0xb5a/0x1170
[42474.392195]  ? lock_vma_under_rcu+0x92/0x160
[42474.395053]  handle_mm_fault+0xe3/0x300
[42474.397864]  do_user_addr_fault+0x202/0x690
[42474.400587]  exc_page_fault+0x73/0x150
[42474.403207]  asm_exc_page_fault+0x26/0x30
[42474.405855] RIP: 0033:0x55ab1f9e1e6d
[42474.408505] RSP: 002b:00007f324baab550 EFLAGS: 00010206
[42474.411186] RAX: 00007f331af70018 RBX: 00007f30fc811ae0 RCX: 0000000000000000
[42474.413946] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f30fc811ae8
[42474.416706] RBP: 0000000000000000 R08: 00007f324baab540 R09: 00007f331bb85000
[42474.419454] R10: 0000000000000000 R11: 0000000001434dae R12: 0000000000000016
[42474.422190] R13: 0000000000000000 R14: 000055ab1facbd20 R15: 00007f324baac340
[42474.424933]  </TASK>
[42474.427630] task:cache-worker    state:D stack:0     pid:1125234 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42474.430551] Call Trace:
[42474.433428]  <TASK>
[42474.436282]  __schedule+0x581/0x10b0
[42474.439150]  schedule+0x28/0xa0
[42474.442015]  schedule_preempt_disabled+0x16/0x30
[42474.444904]  rwsem_down_write_slowpath+0x2d8/0x750
[42474.447806]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42474.450743]  down_write+0x5c/0x60
[42474.453635]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42474.456591]  file_update_time_flags+0x7e/0x130
[42474.459521]  __xfs_write_fault+0x8c/0x260 [xfs]
[42474.462482]  do_page_mkwrite+0x4a/0xa0
[42474.465403]  do_wp_page+0x136/0x1160
[42474.468271]  ? do_syscall_64+0x25a/0x550
[42474.471123]  ? __x64_sys_ioctl+0xb0/0xe0
[42474.473983]  ? do_vfs_ioctl+0x475/0x940
[42474.476829]  ? __seccomp_filter+0x42/0x5c0
[42474.479682]  __handle_mm_fault+0xb5a/0x1170
[42474.482480]  ? __x64_sys_ioctl+0xb0/0xe0
[42474.485179]  ? lock_vma_under_rcu+0x92/0x160
[42474.487794]  handle_mm_fault+0xe3/0x300
[42474.490415]  do_user_addr_fault+0x202/0x690
[42474.493058]  exc_page_fault+0x73/0x150
[42474.495700]  asm_exc_page_fault+0x26/0x30
[42474.498342] RIP: 0033:0x55ab1f9e1e6d
[42474.500978] RSP: 002b:00007f32a38ff550 EFLAGS: 00010206
[42474.503639] RAX: 00007f331af70018 RBX: 00007f31782816a0 RCX: 0000000000000000
[42474.506354] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f31782816a8
[42474.509082] RBP: 0000000000000000 R08: 00007f32a38ff540 R09: 00007f331bb85000
[42474.511796] R10: 0000000000000000 R11: 0000000001434de0 R12: 0000000000000016
[42474.514504] R13: 0000000000000000 R14: 000055ab1facbd20 R15: 00007f32a3900340
[42474.517208]  </TASK>
[42474.519890] task:cache-worker    state:D stack:0     pid:1125236 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42474.522797] Call Trace:
[42474.525664]  <TASK>
[42474.528500]  __schedule+0x581/0x10b0
[42474.531354]  schedule+0x28/0xa0
[42474.534182]  schedule_preempt_disabled+0x16/0x30
[42474.537041]  rwsem_down_write_slowpath+0x2d8/0x750
[42474.539910]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42474.542810]  down_write+0x5c/0x60
[42474.545628]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42474.548498]  file_update_time_flags+0x7e/0x130
[42474.551344]  __xfs_write_fault+0x8c/0x260 [xfs]
[42474.554224]  do_page_mkwrite+0x4a/0xa0
[42474.557065]  do_wp_page+0x136/0x1160
[42474.559850]  __handle_mm_fault+0xb5a/0x1170
[42474.562545]  ? restore_fpregs_from_fpstate+0x3c/0xa0
[42474.565180]  ? lock_vma_under_rcu+0x92/0x160
[42474.567837]  handle_mm_fault+0xe3/0x300
[42474.570487]  do_user_addr_fault+0x202/0x690
[42474.573158]  exc_page_fault+0x73/0x150
[42474.575823]  asm_exc_page_fault+0x26/0x30
[42474.578477] RIP: 0033:0x55ab1f9e1e6d
[42474.581120] RSP: 002b:00007f328c657500 EFLAGS: 00010206
[42474.583790] RAX: 00007f331af70018 RBX: 00007f325ca2c850 RCX: 0000000000000000
[42474.586511] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f325ca2c858
[42474.589245] RBP: 0000000000000000 R08: 00007f328c657540 R09: 00007f331bb85000
[42474.591978] R10: 0000000000000000 R11: 0000000001434dc4 R12: 0000000000000016
[42474.594697] R13: 000055ab1facbf48 R14: 00007f3304603c20 R15: 00007f3304603c50
[42474.597447]  </TASK>
[42474.600168] task:cache-worker    state:D stack:0     pid:1125238 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42474.603125] Call Trace:
[42474.606051]  <TASK>
[42474.608950]  __schedule+0x581/0x10b0
[42474.611868]  schedule+0x28/0xa0
[42474.614769]  schedule_preempt_disabled+0x16/0x30
[42474.617699]  rwsem_down_write_slowpath+0x2d8/0x750
[42474.620638]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42474.623613]  down_write+0x5c/0x60
[42474.626536]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42474.629530]  file_update_time_flags+0x7e/0x130
[42474.632494]  __xfs_write_fault+0x8c/0x260 [xfs]
[42474.635489]  do_page_mkwrite+0x4a/0xa0
[42474.638397]  do_wp_page+0x136/0x1160
[42474.641283]  ? switch_fpu_return+0x5d/0xe0
[42474.644182]  ? do_syscall_64+0x25a/0x550
[42474.647068]  __handle_mm_fault+0xb5a/0x1170
[42474.649973]  ? lock_vma_under_rcu+0x92/0x160
[42474.652838]  handle_mm_fault+0xe3/0x300
[42474.655601]  do_user_addr_fault+0x202/0x690
[42474.658269]  exc_page_fault+0x73/0x150
[42474.660960]  asm_exc_page_fault+0x26/0x30
[42474.663660] RIP: 0033:0x55ab1f9e1e6d
[42474.666352] RSP: 002b:00007f3173aa9550 EFLAGS: 00010206
[42474.669086] RAX: 00007f331af70018 RBX: 00007f325c610140 RCX: 0000000000000000
[42474.671876] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f325c610148
[42474.674663] RBP: 0000000000000000 R08: 00007f3173aa9540 R09: 00007f331bb85000
[42474.677450] R10: 0000000000000000 R11: 0000000001434db0 R12: 0000000000000016
[42474.680225] R13: 0000000000000000 R14: 000055ab1facbd20 R15: 00007f3173aaa340
[42474.682986]  </TASK>
[42474.685719] task:cache-worker    state:D stack:0     pid:1125239 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42474.688686] Call Trace:
[42474.691617]  <TASK>
[42474.694511]  __schedule+0x581/0x10b0
[42474.697410]  schedule+0x28/0xa0
[42474.700284]  schedule_preempt_disabled+0x16/0x30
[42474.703176]  rwsem_down_write_slowpath+0x2d8/0x750
[42474.706083]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42474.709037]  down_write+0x5c/0x60
[42474.711941]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42474.714904]  file_update_time_flags+0x7e/0x130
[42474.717834]  ? switch_fpu_return+0x5d/0xe0
[42474.720726]  __xfs_write_fault+0x8c/0x260 [xfs]
[42474.723658]  do_page_mkwrite+0x4a/0xa0
[42474.726539]  do_wp_page+0x136/0x1160
[42474.729415]  __handle_mm_fault+0xb5a/0x1170
[42474.732287]  ? lock_vma_under_rcu+0x92/0x160
[42474.735119]  handle_mm_fault+0xe3/0x300
[42474.737850]  do_user_addr_fault+0x202/0x690
[42474.740494]  exc_page_fault+0x73/0x150
[42474.743151]  asm_exc_page_fault+0x26/0x30
[42474.745821] RIP: 0033:0x55ab1f9e1e6d
[42474.748493] RSP: 002b:00007f331aecf550 EFLAGS: 00010206
[42474.751194] RAX: 00007f331af70018 RBX: 00007f325b211810 RCX: 0000000000000000
[42474.753966] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f325b211818
[42474.756737] RBP: 0000000000000000 R08: 00007f331aecf540 R09: 00007f331bb85000
[42474.759499] R10: 0000000000000000 R11: 0000000001434dbe R12: 0000000000000016
[42474.762249] R13: 0000000000000000 R14: 000055ab1facbd20 R15: 00007f331aed0340
[42474.764996]  </TASK>
[42474.767712] task:cache-worker    state:D stack:0     pid:1125248 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42474.770650] Call Trace:
[42474.773561]  <TASK>
[42474.776441]  __schedule+0x581/0x10b0
[42474.779342]  schedule+0x28/0xa0
[42474.782220]  schedule_preempt_disabled+0x16/0x30
[42474.785116]  rwsem_down_write_slowpath+0x2d8/0x750
[42474.788021]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42474.790969]  down_write+0x5c/0x60
[42474.793870]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42474.796853]  file_update_time_flags+0x7e/0x130
[42474.799794]  ? switch_fpu_return+0x5d/0xe0
[42474.802721]  __xfs_write_fault+0x8c/0x260 [xfs]
[42474.805673]  do_page_mkwrite+0x4a/0xa0
[42474.808570]  do_wp_page+0x136/0x1160
[42474.811456]  ? do_syscall_64+0xf9/0x550
[42474.814338]  ? do_syscall_64+0x25a/0x550
[42474.817199]  ? do_syscall_64+0xf9/0x550
[42474.819991]  __handle_mm_fault+0xb5a/0x1170
[42474.822685]  ? lock_vma_under_rcu+0x92/0x160
[42474.825298]  handle_mm_fault+0xe3/0x300
[42474.827927]  do_user_addr_fault+0x202/0x690
[42474.830562]  exc_page_fault+0x73/0x150
[42474.833211]  asm_exc_page_fault+0x26/0x30
[42474.835859] RIP: 0033:0x55ab1f9e1e6d
[42474.838487] RSP: 002b:00007f33142d2550 EFLAGS: 00010206
[42474.841147] RAX: 00007f331af70018 RBX: 00007f32464023a0 RCX: 0000000000000000
[42474.843866] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f32464023a8
[42474.846581] RBP: 0000000000000000 R08: 00007f33142d2540 R09: 00007f331bb85000
[42474.849290] R10: 0000000000000000 R11: 0000000001434d48 R12: 0000000000000016
[42474.851997] R13: 0000000000000000 R14: 000055ab1facbd20 R15: 00007f33142d3340
[42474.854687]  </TASK>
[42474.857348] task:cache-worker    state:D stack:0     pid:1125252 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42474.860254] Call Trace:
[42474.863110]  <TASK>
[42474.865934]  __schedule+0x581/0x10b0
[42474.868776]  schedule+0x28/0xa0
[42474.871602]  schedule_preempt_disabled+0x16/0x30
[42474.874442]  rwsem_down_write_slowpath+0x2d8/0x750
[42474.877299]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42474.880198]  down_write+0x5c/0x60
[42474.883037]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42474.885906]  file_update_time_flags+0x7e/0x130
[42474.888736]  __xfs_write_fault+0x8c/0x260 [xfs]
[42474.891604]  do_page_mkwrite+0x4a/0xa0
[42474.894426]  do_wp_page+0x136/0x1160
[42474.897246]  __handle_mm_fault+0xb5a/0x1170
[42474.900028]  ? lock_vma_under_rcu+0x92/0x160
[42474.902717]  handle_mm_fault+0xe3/0x300
[42474.905309]  do_user_addr_fault+0x202/0x690
[42474.907931]  exc_page_fault+0x73/0x150
[42474.910552]  asm_exc_page_fault+0x26/0x30
[42474.913190] RIP: 0033:0x55ab1f9e1e6d
[42474.915822] RSP: 002b:00007f3313500550 EFLAGS: 00010206
[42474.918475] RAX: 00007f331af70018 RBX: 00007f325ae10500 RCX: 0000000000000000
[42474.921191] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f325ae10508
[42474.923907] RBP: 0000000000000000 R08: 00007f3313500540 R09: 00007f331bb85000
[42474.926604] R10: 0000000000000000 R11: 0000000001434d70 R12: 0000000000000016
[42474.929297] R13: 0000000000000000 R14: 000055ab1facbd20 R15: 00007f3313501340
[42474.931982]  </TASK>
[42474.934622] task:cache-worker    state:D stack:0     pid:1125255 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42474.937493] Call Trace:
[42474.940329]  <TASK>
[42474.943134]  __schedule+0x581/0x10b0
[42474.945988]  schedule+0x28/0xa0
[42474.948854]  schedule_preempt_disabled+0x16/0x30
[42474.951746]  rwsem_down_write_slowpath+0x2d8/0x750
[42474.954636]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42474.957572]  down_write+0x5c/0x60
[42474.960461]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42474.963411]  file_update_time_flags+0x7e/0x130
[42474.966329]  __xfs_write_fault+0x8c/0x260 [xfs]
[42474.969286]  do_page_mkwrite+0x4a/0xa0
[42474.972197]  do_wp_page+0x136/0x1160
[42474.975054]  __handle_mm_fault+0xb5a/0x1170
[42474.977915]  ? do_syscall_64+0x25a/0x550
[42474.980780]  ? restore_fpregs_from_fpstate+0x3c/0xa0
[42474.983672]  ? lock_vma_under_rcu+0x92/0x160
[42474.986558]  handle_mm_fault+0xe3/0x300
[42474.989399]  do_user_addr_fault+0x202/0x690
[42474.992151]  exc_page_fault+0x73/0x150
[42474.994797]  asm_exc_page_fault+0x26/0x30
[42474.997474] RIP: 0033:0x55ab1f9e1e6d
[42475.000152] RSP: 002b:00007f3312ffd550 EFLAGS: 00010206
[42475.002869] RAX: 00007f331af70018 RBX: 00007f32468377c0 RCX: 0000000000000000
[42475.005662] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f32468377c8
[42475.008460] RBP: 0000000000000000 R08: 00007f3312ffd540 R09: 00007f331bb85000
[42475.011247] R10: 0000000000000000 R11: 0000000001434db4 R12: 0000000000000016
[42475.014021] R13: 0000000000000000 R14: 000055ab1facbd20 R15: 00007f3312ffe340
[42475.016794]  </TASK>
[42475.019529] task:cache-worker    state:D stack:0     pid:1125259 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42475.022491] Call Trace:
[42475.025407]  <TASK>
[42475.028302]  __schedule+0x581/0x10b0
[42475.031207]  schedule+0x28/0xa0
[42475.034096]  schedule_preempt_disabled+0x16/0x30
[42475.037008]  rwsem_down_write_slowpath+0x2d8/0x750
[42475.039927]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42475.042884]  down_write+0x5c/0x60
[42475.045799]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42475.048781]  file_update_time_flags+0x7e/0x130
[42475.051723]  __xfs_write_fault+0x8c/0x260 [xfs]
[42475.054667]  do_page_mkwrite+0x4a/0xa0
[42475.057560]  do_wp_page+0x136/0x1160
[42475.060444]  ? do_syscall_64+0x25a/0x550
[42475.063336]  ? do_vfs_ioctl+0x475/0x940
[42475.066216]  __handle_mm_fault+0xb5a/0x1170
[42475.069056]  ? lock_vma_under_rcu+0x92/0x160
[42475.071808]  handle_mm_fault+0xe3/0x300
[42475.074451]  do_user_addr_fault+0x202/0x690
[42475.077130]  exc_page_fault+0x73/0x150
[42475.079811]  asm_exc_page_fault+0x26/0x30
[42475.082494] RIP: 0033:0x55ab1f9e1e6d
[42475.085181] RSP: 002b:00007f3312f01550 EFLAGS: 00010206
[42475.087893] RAX: 00007f331af70018 RBX: 00007f3283605090 RCX: 0000000000000000
[42475.090659] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f3283605098
[42475.093435] RBP: 0000000000000000 R08: 00007f3312f01540 R09: 00007f331bb85000
[42475.096206] R10: 0000000000000000 R11: 0000000001434d1c R12: 0000000000000016
[42475.098952] R13: 0000000000000000 R14: 000055ab1facbd20 R15: 00007f3312f02340
[42475.101703]  </TASK>
[42475.104423] task:cache-worker    state:D stack:0     pid:1125265 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42475.107380] Call Trace:
[42475.110285]  <TASK>
[42475.113168]  __schedule+0x581/0x10b0
[42475.116052]  schedule+0x28/0xa0
[42475.118905]  schedule_preempt_disabled+0x16/0x30
[42475.121787]  rwsem_down_write_slowpath+0x2d8/0x750
[42475.124680]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42475.127615]  down_write+0x5c/0x60
[42475.130492]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42475.133442]  file_update_time_flags+0x7e/0x130
[42475.136347]  __xfs_write_fault+0x8c/0x260 [xfs]
[42475.139256]  do_page_mkwrite+0x4a/0xa0
[42475.142102]  do_wp_page+0x136/0x1160
[42475.144946]  __handle_mm_fault+0xb5a/0x1170
[42475.147799]  ? lock_vma_under_rcu+0x92/0x160
[42475.150652]  handle_mm_fault+0xe3/0x300
[42475.153460]  do_user_addr_fault+0x202/0x690
[42475.156177]  exc_page_fault+0x73/0x150
[42475.158788]  asm_exc_page_fault+0x26/0x30
[42475.161428] RIP: 0033:0x55ab1f9e1e6d
[42475.164072] RSP: 002b:00007f3312d5d530 EFLAGS: 00010206
[42475.166750] RAX: 00007f331af70018 RBX: 00007f330820d410 RCX: 0000000000000000
[42475.169505] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f330820d418
[42475.172264] RBP: 0000000000000000 R08: 00007f3312d5d540 R09: 00007f331bb85000
[42475.175004] R10: 0000000000000000 R11: 0000000001434ed6 R12: 0000000000000016
[42475.177743] R13: 000055ab1facc058 R14: 00007f2f5cce21a8 R15: 00007f3312d5d820
[42475.180487]  </TASK>
[42475.183188] task:cache-worker    state:D stack:0     pid:1125268 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42475.186126] Call Trace:
[42475.189014]  <TASK>
[42475.191881]  __schedule+0x581/0x10b0
[42475.194762]  schedule+0x28/0xa0
[42475.197641]  schedule_preempt_disabled+0x16/0x30
[42475.200544]  rwsem_down_write_slowpath+0x2d8/0x750
[42475.203458]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42475.206408]  down_write+0x5c/0x60
[42475.209313]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42475.212278]  file_update_time_flags+0x7e/0x130
[42475.215214]  ? __x64_sys_ioctl+0xb0/0xe0
[42475.218145]  __xfs_write_fault+0x8c/0x260 [xfs]
[42475.221121]  do_page_mkwrite+0x4a/0xa0
[42475.224012]  do_wp_page+0x136/0x1160
[42475.226875]  ? do_syscall_64+0x25a/0x550
[42475.229749]  __handle_mm_fault+0xb5a/0x1170
[42475.232630]  ? lock_vma_under_rcu+0x92/0x160
[42475.235518]  handle_mm_fault+0xe3/0x300
[42475.238346]  do_user_addr_fault+0x202/0x690
[42475.241092]  exc_page_fault+0x73/0x150
[42475.243741]  asm_exc_page_fault+0x26/0x30
[42475.246408] RIP: 0033:0x55ab1f9e1e6d
[42475.249083] RSP: 002b:00007f3310c5d530 EFLAGS: 00010206
[42475.251798] RAX: 00007f331af70018 RBX: 00007f32cb613480 RCX: 0000000000000000
[42475.254577] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f32cb613488
[42475.257370] RBP: 0000000000000000 R08: 00007f3310c5d540 R09: 00007f331bb85000
[42475.260149] R10: 0000000000000000 R11: 0000000001435412 R12: 0000000000000016
[42475.262917] R13: 000055ab1facc058 R14: 00007f33062cda28 R15: 00007f3310c5d820
[42475.265695]  </TASK>
[42475.268436] task:cache-worker    state:D stack:0     pid:1125271 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42475.271417] Call Trace:
[42475.274335]  <TASK>
[42475.277253]  __schedule+0x581/0x10b0
[42475.280167]  schedule+0x28/0xa0
[42475.283059]  schedule_preempt_disabled+0x16/0x30
[42475.285979]  rwsem_down_write_slowpath+0x2d8/0x750
[42475.288906]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42475.291876]  down_write+0x5c/0x60
[42475.294792]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42475.297779]  file_update_time_flags+0x7e/0x130
[42475.300728]  __xfs_write_fault+0x8c/0x260 [xfs]
[42475.303681]  do_page_mkwrite+0x4a/0xa0
[42475.306576]  do_wp_page+0x136/0x1160
[42475.309468]  __handle_mm_fault+0xb5a/0x1170
[42475.312372]  ? lock_vma_under_rcu+0x92/0x160
[42475.315266]  handle_mm_fault+0xe3/0x300
[42475.318103]  do_user_addr_fault+0x202/0x690
[42475.320855]  exc_page_fault+0x73/0x150
[42475.323511]  asm_exc_page_fault+0x26/0x30
[42475.326184] RIP: 0033:0x55ab1f9e1e6d
[42475.328866] RSP: 002b:00007f33103fd550 EFLAGS: 00010206
[42475.331587] RAX: 00007f331af70018 RBX: 00007f3253677800 RCX: 0000000000000000
[42475.334371] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f3253677808
[42475.337166] RBP: 0000000000000000 R08: 00007f33103fd540 R09: 00007f331bb85000
[42475.339945] R10: 0000000000000000 R11: 0000000001434d36 R12: 0000000000000016
[42475.342716] R13: 0000000000000000 R14: 000055ab1facbd20 R15: 00007f33103fe340
[42475.345484]  </TASK>
[42475.348210] task:cache-worker    state:D stack:0     pid:1125276 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42475.351163] Call Trace:
[42475.354085]  <TASK>
[42475.356969]  __schedule+0x581/0x10b0
[42475.359875]  schedule+0x28/0xa0
[42475.362765]  schedule_preempt_disabled+0x16/0x30
[42475.365680]  rwsem_down_write_slowpath+0x2d8/0x750
[42475.368599]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42475.371561]  down_write+0x5c/0x60
[42475.374469]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42475.377439]  file_update_time_flags+0x7e/0x130
[42475.380383]  __xfs_write_fault+0x8c/0x260 [xfs]
[42475.383369]  do_page_mkwrite+0x4a/0xa0
[42475.386298]  do_wp_page+0x136/0x1160
[42475.389182]  ? __x64_sys_ioctl+0xb0/0xe0
[42475.392057]  __handle_mm_fault+0xb5a/0x1170
[42475.394931]  ? __x64_sys_ioctl+0xb0/0xe0
[42475.397799]  ? lock_vma_under_rcu+0x92/0x160
[42475.400661]  handle_mm_fault+0xe3/0x300
[42475.403471]  do_user_addr_fault+0x202/0x690
[42475.406185]  exc_page_fault+0x73/0x150
[42475.408804]  asm_exc_page_fault+0x26/0x30
[42475.411448] RIP: 0033:0x55ab1f9e1e6d
[42475.414090] RSP: 002b:00007f331037f550 EFLAGS: 00010206
[42475.416776] RAX: 00007f331af70018 RBX: 00007f324880c990 RCX: 0000000000000000
[42475.419530] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f324880c998
[42475.422289] RBP: 0000000000000000 R08: 00007f331037f540 R09: 00007f331bb85000
[42475.425043] R10: 0000000000000000 R11: 0000000001434dc8 R12: 0000000000000016
[42475.427787] R13: 0000000000000000 R14: 000055ab1facbd20 R15: 00007f3310380340
[42475.430517]  </TASK>
[42475.433214] task:cache-worker    state:D stack:0     pid:1125279 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42475.436145] Call Trace:
[42475.439016]  <TASK>
[42475.441875]  __schedule+0x581/0x10b0
[42475.444749]  schedule+0x28/0xa0
[42475.447601]  schedule_preempt_disabled+0x16/0x30
[42475.450471]  rwsem_down_write_slowpath+0x2d8/0x750
[42475.453359]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42475.456281]  down_write+0x5c/0x60
[42475.459159]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42475.462108]  file_update_time_flags+0x7e/0x130
[42475.465014]  __xfs_write_fault+0x8c/0x260 [xfs]
[42475.467922]  do_page_mkwrite+0x4a/0xa0
[42475.470770]  do_wp_page+0x136/0x1160
[42475.473619]  __handle_mm_fault+0xb5a/0x1170
[42475.476479]  ? restore_fpregs_from_fpstate+0x3c/0xa0
[42475.479364]  ? switch_fpu_return+0x5d/0xe0
[42475.482196]  ? lock_vma_under_rcu+0x92/0x160
[42475.484938]  handle_mm_fault+0xe3/0x300
[42475.487576]  do_user_addr_fault+0x202/0x690
[42475.490239]  exc_page_fault+0x73/0x150
[42475.492912]  asm_exc_page_fault+0x26/0x30
[42475.495593] RIP: 0033:0x55ab1f9e1e6d
[42475.498265] RSP: 002b:00007f3310283500 EFLAGS: 00010206
[42475.500968] RAX: 00007f331af70018 RBX: 00007f329c76f080 RCX: 0000000000000000
[42475.503733] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f329c76f088
[42475.506495] RBP: 0000000000000000 R08: 00007f3310283540 R09: 00007f331bb85000
[42475.509253] R10: 0000000000000000 R11: 0000000001434e04 R12: 0000000000000016
[42475.512006] R13: 000055ab1facbf48 R14: 00007f3304613e20 R15: 00007f3304613e50
[42475.514762]  </TASK>
[42475.517489] task:cache-worker    state:D stack:0     pid:1125280 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42475.520460] Call Trace:
[42475.523389]  <TASK>
[42475.526286]  __schedule+0x581/0x10b0
[42475.529210]  schedule+0x28/0xa0
[42475.532117]  schedule_preempt_disabled+0x16/0x30
[42475.535037]  rwsem_down_write_slowpath+0x2d8/0x750
[42475.537974]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42475.540952]  down_write+0x5c/0x60
[42475.543885]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42475.546874]  file_update_time_flags+0x7e/0x130
[42475.549831]  __xfs_write_fault+0x8c/0x260 [xfs]
[42475.552787]  do_page_mkwrite+0x4a/0xa0
[42475.555690]  do_wp_page+0x136/0x1160
[42475.558577]  __handle_mm_fault+0xb5a/0x1170
[42475.561483]  ? lock_vma_under_rcu+0x92/0x160
[42475.564399]  handle_mm_fault+0xe3/0x300
[42475.567263]  do_user_addr_fault+0x202/0x690
[42475.570039]  exc_page_fault+0x73/0x150
[42475.572714]  asm_exc_page_fault+0x26/0x30
[42475.575414] RIP: 0033:0x55ab1f9e1e6d
[42475.578105] RSP: 002b:00007f331026e530 EFLAGS: 00010206
[42475.580843] RAX: 00007f331af70018 RBX: 00007f316e636430 RCX: 0000000000000000
[42475.583652] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f316e636438
[42475.586463] RBP: 0000000000000000 R08: 00007f331026e540 R09: 00007f331bb85000
[42475.589271] R10: 0000000000000000 R11: 0000000001434f16 R12: 0000000000000016
[42475.592067] R13: 000055ab1facc058 R14: 00007f310fa57c28 R15: 00007f331026e820
[42475.594864]  </TASK>
[42475.597627] task:cache-worker    state:D stack:0     pid:1125288 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42475.600627] Call Trace:
[42475.603572]  <TASK>
[42475.606488]  __schedule+0x581/0x10b0
[42475.609426]  schedule+0x28/0xa0
[42475.612335]  schedule_preempt_disabled+0x16/0x30
[42475.615256]  rwsem_down_write_slowpath+0x2d8/0x750
[42475.618181]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42475.621155]  down_write+0x5c/0x60
[42475.624080]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42475.627059]  file_update_time_flags+0x7e/0x130
[42475.630020]  __xfs_write_fault+0x8c/0x260 [xfs]
[42475.633017]  do_page_mkwrite+0x4a/0xa0
[42475.635966]  do_wp_page+0x136/0x1160
[42475.638857]  __handle_mm_fault+0xb5a/0x1170
[42475.641755]  ? lock_vma_under_rcu+0x92/0x160
[42475.644661]  handle_mm_fault+0xe3/0x300
[42475.647558]  do_user_addr_fault+0x202/0x690
[42475.650441]  exc_page_fault+0x73/0x150
[42475.653283]  asm_exc_page_fault+0x26/0x30
[42475.656027] RIP: 0033:0x55ab1f9e1e6d
[42475.658665] RSP: 002b:00007f3310187550 EFLAGS: 00010206
[42475.661364] RAX: 00007f331af70018 RBX: 00007f3306e6a680 RCX: 0000000000000000
[42475.664140] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f3306e6a688
[42475.666931] RBP: 0000000000000000 R08: 00007f3310187540 R09: 00007f331bb85000
[42475.669726] R10: 0000000000000000 R11: 0000000001434dfc R12: 0000000000000016
[42475.672518] R13: 0000000000000000 R14: 000055ab1facbd20 R15: 00007f3310188340
[42475.675294]  </TASK>
[42475.678029] task:cache-worker    state:D stack:0     pid:1125290 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42475.680998] Call Trace:
[42475.683916]  <TASK>
[42475.686799]  __schedule+0x581/0x10b0
[42475.689694]  schedule+0x28/0xa0
[42475.692580]  schedule_preempt_disabled+0x16/0x30
[42475.695487]  rwsem_down_write_slowpath+0x2d8/0x750
[42475.698392]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42475.701347]  down_write+0x5c/0x60
[42475.704256]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42475.707219]  file_update_time_flags+0x7e/0x130
[42475.710168]  __xfs_write_fault+0x8c/0x260 [xfs]
[42475.713149]  do_page_mkwrite+0x4a/0xa0
[42475.716085]  do_wp_page+0x136/0x1160
[42475.718963]  __handle_mm_fault+0xb5a/0x1170
[42475.721846]  ? lock_vma_under_rcu+0x92/0x160
[42475.724736]  handle_mm_fault+0xe3/0x300
[42475.727617]  do_user_addr_fault+0x202/0x690
[42475.730484]  exc_page_fault+0x73/0x150
[42475.733309]  asm_exc_page_fault+0x26/0x30
[42475.736040] RIP: 0033:0x55ab1f9e1e6d
[42475.738666] RSP: 002b:00007f331011e530 EFLAGS: 00010206
[42475.741350] RAX: 00007f331af70018 RBX: 00007f316ee16b30 RCX: 0000000000000000
[42475.744118] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f316ee16b38
[42475.746895] RBP: 0000000000000000 R08: 00007f331011e540 R09: 00007f331bb85000
[42475.749677] R10: 0000000000000000 R11: 0000000001435076 R12: 0000000000000016
[42475.752455] R13: 000055ab1facc058 R14: 00007f310f976ae8 R15: 00007f331011e820
[42475.755238]  </TASK>
[42475.757979] task:cache-worker    state:D stack:0     pid:1125296 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42475.760951] Call Trace:
[42475.763870]  <TASK>
[42475.766751]  __schedule+0x581/0x10b0
[42475.769651]  schedule+0x28/0xa0
[42475.772542]  schedule_preempt_disabled+0x16/0x30
[42475.775452]  rwsem_down_write_slowpath+0x2d8/0x750
[42475.778360]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42475.781317]  down_write+0x5c/0x60
[42475.784226]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42475.787192]  file_update_time_flags+0x7e/0x130
[42475.790137]  __xfs_write_fault+0x8c/0x260 [xfs]
[42475.793120]  do_page_mkwrite+0x4a/0xa0
[42475.796054]  do_wp_page+0x136/0x1160
[42475.798933]  ? restore_fpregs_from_fpstate+0x3c/0xa0
[42475.801843]  ? switch_fpu_return+0x5d/0xe0
[42475.804756]  __handle_mm_fault+0xb5a/0x1170
[42475.807671]  ? lock_vma_under_rcu+0x92/0x160
[42475.810586]  handle_mm_fault+0xe3/0x300
[42475.813454]  do_user_addr_fault+0x202/0x690
[42475.816232]  exc_page_fault+0x73/0x150
[42475.818904]  asm_exc_page_fault+0x26/0x30
[42475.821608] RIP: 0033:0x55ab1f9e1e6d
[42475.824313] RSP: 002b:00007f330fee7530 EFLAGS: 00010206
[42475.827053] RAX: 00007f331af70018 RBX: 00007f3128a15910 RCX: 0000000000000000
[42475.829864] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f3128a15918
[42475.832685] RBP: 0000000000000000 R08: 00007f330fee7540 R09: 00007f331bb85000
[42475.835489] R10: 0000000000000000 R11: 0000000001434d16 R12: 0000000000000016
[42475.838278] R13: 000055ab1facc058 R14: 00007f310f71ee28 R15: 00007f330fee7820
[42475.841078]  </TASK>
[42475.843839] task:cache-worker    state:D stack:0     pid:1125300 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42475.846827] Call Trace:
[42475.849773]  <TASK>
[42475.852695]  __schedule+0x581/0x10b0
[42475.855632]  schedule+0x28/0xa0
[42475.858543]  schedule_preempt_disabled+0x16/0x30
[42475.861484]  rwsem_down_write_slowpath+0x2d8/0x750
[42475.864436]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42475.867426]  down_write+0x5c/0x60
[42475.870362]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42475.873366]  file_update_time_flags+0x7e/0x130
[42475.876334]  __xfs_write_fault+0x8c/0x260 [xfs]
[42475.879304]  do_page_mkwrite+0x4a/0xa0
[42475.882209]  do_wp_page+0x136/0x1160
[42475.885110]  __handle_mm_fault+0xb5a/0x1170
[42475.888023]  ? lock_vma_under_rcu+0x92/0x160
[42475.890924]  handle_mm_fault+0xe3/0x300
[42475.893775]  do_user_addr_fault+0x202/0x690
[42475.896535]  exc_page_fault+0x73/0x150
[42475.899189]  asm_exc_page_fault+0x26/0x30
[42475.901871] RIP: 0033:0x55ab1f9e1e6d
[42475.904558] RSP: 002b:00007f330fe93550 EFLAGS: 00010206
[42475.907290] RAX: 00007f331af70018 RBX: 00007f30e0905530 RCX: 0000000000000000
[42475.910081] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f30e0905538
[42475.912885] RBP: 0000000000000000 R08: 00007f330fe93540 R09: 00007f331bb85000
[42475.915673] R10: 0000000000000000 R11: 0000000001434da8 R12: 0000000000000016
[42475.918448] R13: 0000000000000000 R14: 000055ab1facbd20 R15: 00007f330fe94340
[42475.921219]  </TASK>
[42475.923949] task:cache-worker    state:D stack:0     pid:1125301 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42475.926906] Call Trace:
[42475.929820]  <TASK>
[42475.932712]  __schedule+0x581/0x10b0
[42475.935607]  schedule+0x28/0xa0
[42475.938471]  schedule_preempt_disabled+0x16/0x30
[42475.941360]  rwsem_down_write_slowpath+0x2d8/0x750
[42475.944256]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42475.947188]  down_write+0x5c/0x60
[42475.950075]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42475.953026]  file_update_time_flags+0x7e/0x130
[42475.955952]  __xfs_write_fault+0x8c/0x260 [xfs]
[42475.958910]  do_page_mkwrite+0x4a/0xa0
[42475.961825]  do_wp_page+0x136/0x1160
[42475.964695]  ? do_syscall_64+0x25a/0x550
[42475.967550]  __handle_mm_fault+0xb5a/0x1170
[42475.970409]  ? lock_vma_under_rcu+0x92/0x160
[42475.973283]  handle_mm_fault+0xe3/0x300
[42475.976137]  do_user_addr_fault+0x202/0x690
[42475.978946]  exc_page_fault+0x73/0x150
[42475.981661]  asm_exc_page_fault+0x26/0x30
[42475.984286] RIP: 0033:0x55ab1f9e1e6d
[42475.986922] RSP: 002b:00007f330fe69550 EFLAGS: 00010206
[42475.989603] RAX: 00007f331af70018 RBX: 00007f325067ff50 RCX: 0000000000000000
[42475.992355] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f325067ff58
[42475.995117] RBP: 0000000000000000 R08: 00007f330fe69540 R09: 00007f331bb85000
[42475.997879] R10: 0000000000000000 R11: 0000000001434d80 R12: 0000000000000016
[42476.000628] R13: 0000000000000000 R14: 000055ab1facbd20 R15: 00007f330fe6a340
[42476.003372]  </TASK>
[42476.006075] task:cache-worker    state:D stack:0     pid:1125303 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42476.009009] Call Trace:
[42476.011897]  <TASK>
[42476.014747]  __schedule+0x581/0x10b0
[42476.017625]  schedule+0x28/0xa0
[42476.020489]  schedule_preempt_disabled+0x16/0x30
[42476.023367]  rwsem_down_write_slowpath+0x2d8/0x750
[42476.026254]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42476.029188]  down_write+0x5c/0x60
[42476.032072]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42476.035023]  file_update_time_flags+0x7e/0x130
[42476.037943]  __xfs_write_fault+0x8c/0x260 [xfs]
[42476.040897]  do_page_mkwrite+0x4a/0xa0
[42476.043771]  do_wp_page+0x136/0x1160
[42476.046620]  __handle_mm_fault+0xb5a/0x1170
[42476.049491]  ? do_vfs_ioctl+0x475/0x940
[42476.052357]  ? lock_vma_under_rcu+0x92/0x160
[42476.055224]  handle_mm_fault+0xe3/0x300
[42476.058043]  do_user_addr_fault+0x202/0x690
[42476.060773]  exc_page_fault+0x73/0x150
[42476.063403]  asm_exc_page_fault+0x26/0x30
[42476.066052] RIP: 0033:0x55ab1f9e1e6d
[42476.068708] RSP: 002b:00007f330fe15550 EFLAGS: 00010206
[42476.071404] RAX: 00007f331af70018 RBX: 00007f3306e6a6d0 RCX: 0000000000000000
[42476.074159] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f3306e6a6d8
[42476.076929] RBP: 0000000000000000 R08: 00007f330fe15540 R09: 00007f331bb85000
[42476.079681] R10: 0000000000000000 R11: 0000000001434d24 R12: 0000000000000016
[42476.082419] R13: 0000000000000000 R14: 000055ab1facbd20 R15: 00007f330fe16340
[42476.085153]  </TASK>
[42476.087845] task:cache-worker    state:D stack:0     pid:1125304 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42476.090767] Call Trace:
[42476.093649]  <TASK>
[42476.096508]  __schedule+0x581/0x10b0
[42476.099387]  schedule+0x28/0xa0
[42476.102241]  schedule_preempt_disabled+0x16/0x30
[42476.105123]  rwsem_down_write_slowpath+0x2d8/0x750
[42476.108014]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42476.110941]  down_write+0x5c/0x60
[42476.113824]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42476.116775]  file_update_time_flags+0x7e/0x130
[42476.119695]  __xfs_write_fault+0x8c/0x260 [xfs]
[42476.122643]  do_page_mkwrite+0x4a/0xa0
[42476.125516]  do_wp_page+0x136/0x1160
[42476.128367]  __handle_mm_fault+0xb5a/0x1170
[42476.131223]  ? lock_vma_under_rcu+0x92/0x160
[42476.134093]  handle_mm_fault+0xe3/0x300
[42476.136951]  do_user_addr_fault+0x202/0x690
[42476.139772]  exc_page_fault+0x73/0x150
[42476.142487]  asm_exc_page_fault+0x26/0x30
[42476.145118] RIP: 0033:0x55ab1f9e1e6d
[42476.147763] RSP: 002b:00007f330fe00550 EFLAGS: 00010206
[42476.150446] RAX: 00007f331af70018 RBX: 00007f324880ca80 RCX: 0000000000000000
[42476.153212] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f324880ca88
[42476.155988] RBP: 0000000000000000 R08: 00007f330fe00540 R09: 00007f331bb85000
[42476.158748] R10: 0000000000000000 R11: 0000000001434d84 R12: 0000000000000016
[42476.161504] R13: 0000000000000000 R14: 000055ab1facbd20 R15: 00007f330fe01340
[42476.164249]  </TASK>
[42476.166949] task:cache-worker    state:D stack:0     pid:1125311 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42476.169874] Call Trace:
[42476.172757]  <TASK>
[42476.175607]  __schedule+0x581/0x10b0
[42476.178474]  schedule+0x28/0xa0
[42476.181330]  schedule_preempt_disabled+0x16/0x30
[42476.184207]  rwsem_down_write_slowpath+0x2d8/0x750
[42476.187090]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42476.190021]  down_write+0x5c/0x60
[42476.192906]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42476.195853]  file_update_time_flags+0x7e/0x130
[42476.198770]  ? switch_fpu_return+0x5d/0xe0
[42476.201693]  __xfs_write_fault+0x8c/0x260 [xfs]
[42476.204663]  do_page_mkwrite+0x4a/0xa0
[42476.207549]  do_wp_page+0x136/0x1160
[42476.210408]  ? __x64_sys_ioctl+0xb0/0xe0
[42476.213283]  __handle_mm_fault+0xb5a/0x1170
[42476.216157]  ? lock_vma_under_rcu+0x92/0x160
[42476.219033]  handle_mm_fault+0xe3/0x300
[42476.221859]  do_user_addr_fault+0x202/0x690
[42476.224598]  exc_page_fault+0x73/0x150
[42476.227239]  asm_exc_page_fault+0x26/0x30
[42476.229897] RIP: 0033:0x55ab1f9e1e6d
[42476.232564] RSP: 002b:00007f330fd2e530 EFLAGS: 00010206
[42476.235273] RAX: 00007f331af70018 RBX: 00007f3247c0dd90 RCX: 0000000000000000
[42476.238039] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f3247c0dd98
[42476.240819] RBP: 0000000000000000 R08: 00007f330fd2e540 R09: 00007f331bb85000
[42476.243586] R10: 0000000000000000 R11: 000000000143517a R12: 0000000000000016
[42476.246337] R13: 000055ab1facc058 R14: 00007f310f769728 R15: 00007f330fd2e820
[42476.249100]  </TASK>
[42476.251825] task:cache-worker    state:D stack:0     pid:1125316 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42476.254779] Call Trace:
[42476.257686]  <TASK>
[42476.260572]  __schedule+0x581/0x10b0
[42476.263475]  schedule+0x28/0xa0
[42476.266350]  schedule_preempt_disabled+0x16/0x30
[42476.269257]  rwsem_down_write_slowpath+0x2d8/0x750
[42476.272172]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42476.275125]  down_write+0x5c/0x60
[42476.278034]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42476.281005]  file_update_time_flags+0x7e/0x130
[42476.283943]  __xfs_write_fault+0x8c/0x260 [xfs]
[42476.286880]  ? do_syscall_64+0x25a/0x550
[42476.289764]  do_page_mkwrite+0x4a/0xa0
[42476.292646]  do_wp_page+0x136/0x1160
[42476.295520]  ? do_syscall_64+0xf9/0x550
[42476.298394]  ? switch_fpu_return+0x5d/0xe0
[42476.301229]  ? do_syscall_64+0x25a/0x550
[42476.303969]  __handle_mm_fault+0xb5a/0x1170
[42476.306610]  ? lock_vma_under_rcu+0x92/0x160
[42476.309281]  handle_mm_fault+0xe3/0x300
[42476.311957]  do_user_addr_fault+0x202/0x690
[42476.314640]  exc_page_fault+0x73/0x150
[42476.317327]  asm_exc_page_fault+0x26/0x30
[42476.320009] RIP: 0033:0x55ab1f9e1e6d
[42476.322669] RSP: 002b:00007f330de21550 EFLAGS: 00010206
[42476.325359] RAX: 00007f331af70018 RBX: 00007f316ee15280 RCX: 0000000000000000
[42476.328104] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f316ee15288
[42476.330846] RBP: 0000000000000000 R08: 00007f330de21540 R09: 00007f331bb85000
[42476.333589] R10: 0000000000000000 R11: 0000000001434d9e R12: 0000000000000016
[42476.336320] R13: 0000000000000000 R14: 000055ab1facbd20 R15: 00007f330de22340
[42476.339038]  </TASK>
[42476.341741] task:cache-worker    state:D stack:0     pid:1125317 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42476.344684] Call Trace:
[42476.347585]  <TASK>
[42476.350446]  __schedule+0x581/0x10b0
[42476.353332]  schedule+0x28/0xa0
[42476.356201]  schedule_preempt_disabled+0x16/0x30
[42476.359083]  rwsem_down_write_slowpath+0x2d8/0x750
[42476.361995]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42476.364937]  down_write+0x5c/0x60
[42476.367827]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42476.370733]  file_update_time_flags+0x7e/0x130
[42476.373606]  __xfs_write_fault+0x8c/0x260 [xfs]
[42476.376522]  do_page_mkwrite+0x4a/0xa0
[42476.379393]  do_wp_page+0x136/0x1160
[42476.382237]  __handle_mm_fault+0xb5a/0x1170
[42476.385054]  ? lock_vma_under_rcu+0x92/0x160
[42476.387776]  handle_mm_fault+0xe3/0x300
[42476.390393]  do_user_addr_fault+0x202/0x690
[42476.393047]  exc_page_fault+0x73/0x150
[42476.395702]  asm_exc_page_fault+0x26/0x30
[42476.398360] RIP: 0033:0x55ab1f9e1e6d
[42476.401021] RSP: 002b:00007f330c1e5550 EFLAGS: 00010206
[42476.403711] RAX: 00007f331af70018 RBX: 00007f325e2119a0 RCX: 0000000000000000
[42476.406447] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f325e2119a8
[42476.409198] RBP: 0000000000000000 R08: 00007f330c1e5540 R09: 00007f331bb85000
[42476.411937] R10: 0000000000000000 R11: 0000000001434e00 R12: 0000000000000016
[42476.414658] R13: 0000000000000000 R14: 000055ab1facbd20 R15: 00007f330c1e6340
[42476.417380]  </TASK>
[42476.420069] task:cache-worker    state:D stack:0     pid:1125321 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42476.422993] Call Trace:
[42476.425887]  <TASK>
[42476.428755]  __schedule+0x581/0x10b0
[42476.431643]  schedule+0x28/0xa0
[42476.434510]  schedule_preempt_disabled+0x16/0x30
[42476.437406]  rwsem_down_write_slowpath+0x2d8/0x750
[42476.440309]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42476.443251]  down_write+0x5c/0x60
[42476.446139]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42476.449090]  file_update_time_flags+0x7e/0x130
[42476.452021]  __xfs_write_fault+0x8c/0x260 [xfs]
[42476.454984]  do_page_mkwrite+0x4a/0xa0
[42476.457906]  do_wp_page+0x136/0x1160
[42476.460782]  ? restore_fpregs_from_fpstate+0x3c/0xa0
[42476.463682]  ? switch_fpu_return+0x5d/0xe0
[42476.466572]  __handle_mm_fault+0xb5a/0x1170
[42476.469469]  ? lock_vma_under_rcu+0x92/0x160
[42476.472374]  handle_mm_fault+0xe3/0x300
[42476.475221]  do_user_addr_fault+0x202/0x690
[42476.477982]  exc_page_fault+0x73/0x150
[42476.480648]  asm_exc_page_fault+0x26/0x30
[42476.483338] RIP: 0033:0x55ab1f9e1e6d
[42476.486019] RSP: 002b:00007f330c0e9550 EFLAGS: 00010206
[42476.488746] RAX: 00007f331af70018 RBX: 00007f325de173f0 RCX: 0000000000000000
[42476.491543] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f325de173f8
[42476.494338] RBP: 0000000000000000 R08: 00007f330c0e9540 R09: 00007f331bb85000
[42476.497128] R10: 0000000000000000 R11: 0000000001434dd4 R12: 0000000000000016
[42476.499907] R13: 0000000000000000 R14: 000055ab1facbd20 R15: 00007f330c0ea340
[42476.502671]  </TASK>
[42476.505405] task:cache-worker    state:D stack:0     pid:1125326 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42476.508373] Call Trace:
[42476.511289]  <TASK>
[42476.514179]  __schedule+0x581/0x10b0
[42476.517084]  schedule+0x28/0xa0
[42476.519972]  schedule_timeout+0xbd/0x100
[42476.522854]  __down_common+0x17c/0x340
[42476.525739]  down+0x52/0x70
[42476.528601]  xfs_buf_lock+0x32/0xd0 [xfs]
[42476.531531]  xfs_buf_find_lock+0x51/0x100 [xfs]
[42476.534434]  xfs_buf_read_map+0x94/0x2b0 [xfs]
[42476.537324]  ? xfs_read_icluster+0x7f/0xd0 [xfs]
[42476.540222]  xfs_trans_read_buf_map+0x12d/0x270 [xfs]
[42476.543117]  ? xfs_read_icluster+0x7f/0xd0 [xfs]
[42476.546023]  xfs_read_icluster+0x7f/0xd0 [xfs]
[42476.548926]  xfs_inode_item_precommit+0x22f/0x2d0 [xfs]
[42476.551859]  __xfs_trans_commit+0xb9/0x300 [xfs]
[42476.554744]  xfs_trans_commit+0x38/0x70 [xfs]
[42476.557535]  xfs_vn_update_time+0x187/0x1b0 [xfs]
[42476.560252]  file_update_time_flags+0x7e/0x130
[42476.562949]  ? futex_wake+0x10c/0x240
[42476.565654]  __xfs_write_fault+0x8c/0x260 [xfs]
[42476.568428]  do_page_mkwrite+0x4a/0xa0
[42476.571148]  do_wp_page+0x136/0x1160
[42476.573857]  __handle_mm_fault+0xb5a/0x1170
[42476.576567]  ? lock_vma_under_rcu+0x92/0x160
[42476.579272]  handle_mm_fault+0xe3/0x300
[42476.581955]  do_user_addr_fault+0x202/0x690
[42476.584642]  exc_page_fault+0x73/0x150
[42476.587322]  asm_exc_page_fault+0x26/0x30
[42476.589988] RIP: 0033:0x55ab1f9e1e6d
[42476.592665] RSP: 002b:00007f330b3546a0 EFLAGS: 00010206
[42476.595359] RAX: 00007f331af73018 RBX: 00007f3313e07000 RCX: 0000000000000000
[42476.598103] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f3313e07008
[42476.600864] RBP: 0000000000000000 R08: 0000000000000098 R09: 0000000000000000
[42476.603610] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000016
[42476.606324] R13: 000055ab1faca8e8 R14: 00007f3313e00000 R15: 00007f330b355340
[42476.609058]  </TASK>
[42476.611761] task:cache-worker    state:D stack:0     pid:1125327 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42476.614695] Call Trace:
[42476.617594]  <TASK>
[42476.620455]  __schedule+0x581/0x10b0
[42476.623298]  schedule+0x28/0xa0
[42476.626105]  schedule_preempt_disabled+0x16/0x30
[42476.628945]  rwsem_down_write_slowpath+0x2d8/0x750
[42476.631793]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42476.634687]  down_write+0x5c/0x60
[42476.637483]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42476.640253]  file_update_time_flags+0x7e/0x130
[42476.642890]  __xfs_write_fault+0x8c/0x260 [xfs]
[42476.645598]  do_page_mkwrite+0x4a/0xa0
[42476.648269]  do_wp_page+0x136/0x1160
[42476.650931]  __handle_mm_fault+0xb5a/0x1170
[42476.653630]  ? lock_vma_under_rcu+0x92/0x160
[42476.656329]  handle_mm_fault+0xe3/0x300
[42476.659018]  do_user_addr_fault+0x202/0x690
[42476.661719]  exc_page_fault+0x73/0x150
[42476.664430]  asm_exc_page_fault+0x26/0x30
[42476.667139] RIP: 0033:0x55ab1f9e1e6d
[42476.669844] RSP: 002b:00007f330b33f550 EFLAGS: 00010206
[42476.672566] RAX: 00007f331af70018 RBX: 00007f3243c1b3c0 RCX: 0000000000000000
[42476.675337] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f3243c1b3c8
[42476.678108] RBP: 0000000000000000 R08: 00007f330b33f540 R09: 00007f331bb85000
[42476.680872] R10: 0000000000000000 R11: 0000000001434d72 R12: 0000000000000016
[42476.683619] R13: 0000000000000000 R14: 000055ab1facbd20 R15: 00007f330b340340
[42476.686347]  </TASK>
[42476.689052] task:cache-worker    state:D stack:0     pid:1125334 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42476.691979] Call Trace:
[42476.694851]  <TASK>
[42476.697695]  __schedule+0x581/0x10b0
[42476.700550]  schedule+0x28/0xa0
[42476.703400]  schedule_preempt_disabled+0x16/0x30
[42476.706263]  rwsem_down_write_slowpath+0x2d8/0x750
[42476.709140]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42476.712062]  down_write+0x5c/0x60
[42476.714927]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42476.717865]  file_update_time_flags+0x7e/0x130
[42476.720778]  __xfs_write_fault+0x8c/0x260 [xfs]
[42476.723727]  do_page_mkwrite+0x4a/0xa0
[42476.726619]  do_wp_page+0x136/0x1160
[42476.729468]  ? restore_fpregs_from_fpstate+0x3c/0xa0
[42476.732344]  __handle_mm_fault+0xb5a/0x1170
[42476.735231]  ? lock_vma_under_rcu+0x92/0x160
[42476.738149]  handle_mm_fault+0xe3/0x300
[42476.741050]  do_user_addr_fault+0x202/0x690
[42476.743912]  exc_page_fault+0x73/0x150
[42476.746668]  asm_exc_page_fault+0x26/0x30
[42476.749336] RIP: 0033:0x55ab1f9e1e6d
[42476.752023] RSP: 002b:00007f330b22e550 EFLAGS: 00010206
[42476.754743] RAX: 00007f331af70018 RBX: 00007f3106e013b0 RCX: 0000000000000000
[42476.757542] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f3106e013b8
[42476.760351] RBP: 0000000000000000 R08: 00007f330b22e540 R09: 00007f331bb85000
[42476.763148] R10: 0000000000000000 R11: 0000000001434d2a R12: 0000000000000016
[42476.765942] R13: 0000000000000000 R14: 000055ab1facbd20 R15: 00007f330b22f340
[42476.768721]  </TASK>
[42476.771463] task:cache-worker    state:D stack:0     pid:1125335 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42476.774427] Call Trace:
[42476.777352]  <TASK>
[42476.780241]  __schedule+0x581/0x10b0
[42476.783149]  schedule+0x28/0xa0
[42476.786045]  schedule_preempt_disabled+0x16/0x30
[42476.788958]  rwsem_down_write_slowpath+0x2d8/0x750
[42476.791886]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42476.794849]  down_write+0x5c/0x60
[42476.797766]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42476.800750]  file_update_time_flags+0x7e/0x130
[42476.803707]  __xfs_write_fault+0x8c/0x260 [xfs]
[42476.806689]  ? do_syscall_64+0x25a/0x550
[42476.809600]  do_page_mkwrite+0x4a/0xa0
[42476.812488]  do_wp_page+0x136/0x1160
[42476.815367]  __handle_mm_fault+0xb5a/0x1170
[42476.818253]  ? lock_vma_under_rcu+0x92/0x160
[42476.821154]  handle_mm_fault+0xe3/0x300
[42476.824001]  do_user_addr_fault+0x202/0x690
[42476.826751]  exc_page_fault+0x73/0x150
[42476.829408]  asm_exc_page_fault+0x26/0x30
[42476.832086] RIP: 0033:0x55ab1f9e1e6d
[42476.834762] RSP: 002b:00007f32fea6a550 EFLAGS: 00010206
[42476.837482] RAX: 00007f331af70018 RBX: 00007f324fe3e320 RCX: 0000000000000000
[42476.840272] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f324fe3e328
[42476.843061] RBP: 0000000000000000 R08: 00007f32fea6a540 R09: 00007f331bb85000
[42476.845847] R10: 0000000000000000 R11: 0000000001434ddc R12: 0000000000000016
[42476.848625] R13: 0000000000000000 R14: 000055ab1facbd20 R15: 00007f32fea6b340
[42476.851393]  </TASK>
[42476.854114] task:cache-worker    state:D stack:0     pid:1125336 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42476.857076] Call Trace:
[42476.859989]  <TASK>
[42476.862873]  __schedule+0x581/0x10b0
[42476.865768]  schedule+0x28/0xa0
[42476.868633]  schedule_preempt_disabled+0x16/0x30
[42476.871514]  rwsem_down_write_slowpath+0x2d8/0x750
[42476.874401]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42476.877334]  down_write+0x5c/0x60
[42476.880217]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42476.883165]  file_update_time_flags+0x7e/0x130
[42476.886088]  __xfs_write_fault+0x8c/0x260 [xfs]
[42476.889044]  do_page_mkwrite+0x4a/0xa0
[42476.891921]  do_wp_page+0x136/0x1160
[42476.894772]  __handle_mm_fault+0xb5a/0x1170
[42476.897644]  ? lock_vma_under_rcu+0x92/0x160
[42476.900520]  handle_mm_fault+0xe3/0x300
[42476.903395]  do_user_addr_fault+0x202/0x690
[42476.906225]  exc_page_fault+0x73/0x150
[42476.908958]  asm_exc_page_fault+0x26/0x30
[42476.911599] RIP: 0033:0x55ab1f9e1e6d
[42476.914251] RSP: 002b:00007f32fea40550 EFLAGS: 00010206
[42476.916948] RAX: 00007f331af70018 RBX: 00007f325a607170 RCX: 0000000000000000
[42476.919722] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f325a607178
[42476.922504] RBP: 0000000000000000 R08: 00007f32fea40540 R09: 00007f331bb85000
[42476.925288] R10: 0000000000000000 R11: 0000000001434dd0 R12: 0000000000000016
[42476.928059] R13: 0000000000000000 R14: 000055ab1facbd20 R15: 00007f32fea41340
[42476.930813]  </TASK>
[42476.933539] task:cache-worker    state:D stack:0     pid:1125338 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42476.936487] Call Trace:
[42476.939390]  <TASK>
[42476.942251]  __schedule+0x581/0x10b0
[42476.945144]  schedule+0x28/0xa0
[42476.948028]  schedule_preempt_disabled+0x16/0x30
[42476.950926]  rwsem_down_write_slowpath+0x2d8/0x750
[42476.953836]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42476.956789]  down_write+0x5c/0x60
[42476.959691]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42476.962655]  file_update_time_flags+0x7e/0x130
[42476.965596]  __xfs_write_fault+0x8c/0x260 [xfs]
[42476.968574]  do_page_mkwrite+0x4a/0xa0
[42476.971504]  do_wp_page+0x136/0x1160
[42476.974377]  __handle_mm_fault+0xb5a/0x1170
[42476.977255]  ? lock_vma_under_rcu+0x92/0x160
[42476.980141]  handle_mm_fault+0xe3/0x300
[42476.983011]  do_user_addr_fault+0x202/0x690
[42476.985891]  exc_page_fault+0x73/0x150
[42476.988725]  asm_exc_page_fault+0x26/0x30
[42476.991459] RIP: 0033:0x55ab1f9e1e6d
[42476.994089] RSP: 002b:00007f32eda40550 EFLAGS: 00010206
[42476.996776] RAX: 00007f331af70018 RBX: 00007f3177ae2a30 RCX: 0000000000000000
[42476.999539] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f3177ae2a38
[42477.002318] RBP: 0000000000000000 R08: 00007f32eda40540 R09: 00007f331bb85000
[42477.005109] R10: 0000000000000000 R11: 0000000001434db4 R12: 0000000000000016
[42477.007893] R13: 0000000000000000 R14: 000055ab1facbd20 R15: 00007f32eda41340
[42477.010659]  </TASK>
[42477.013397] task:cache-worker    state:D stack:0     pid:1125342 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42477.016359] Call Trace:
[42477.019267]  <TASK>
[42477.022137]  __schedule+0x581/0x10b0
[42477.025025]  schedule+0x28/0xa0
[42477.027903]  schedule_preempt_disabled+0x16/0x30
[42477.030795]  rwsem_down_write_slowpath+0x2d8/0x750
[42477.033702]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42477.036648]  down_write+0x5c/0x60
[42477.039543]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42477.042496]  file_update_time_flags+0x7e/0x130
[42477.045432]  __xfs_write_fault+0x8c/0x260 [xfs]
[42477.048404]  do_page_mkwrite+0x4a/0xa0
[42477.051327]  do_wp_page+0x136/0x1160
[42477.054195]  __handle_mm_fault+0xb5a/0x1170
[42477.057065]  ? lock_vma_under_rcu+0x92/0x160
[42477.059941]  handle_mm_fault+0xe3/0x300
[42477.062806]  do_user_addr_fault+0x202/0x690
[42477.065686]  exc_page_fault+0x73/0x150
[42477.068510]  asm_exc_page_fault+0x26/0x30
[42477.071236] RIP: 0033:0x55ab1f9e1e6d
[42477.073871] RSP: 002b:00007f32e70fd550 EFLAGS: 00010206
[42477.076560] RAX: 00007f331af70018 RBX: 00007f325c212170 RCX: 0000000000000000
[42477.079323] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f325c212178
[42477.082102] RBP: 0000000000000000 R08: 00007f32e70fd540 R09: 00007f331bb85000
[42477.084887] R10: 0000000000000000 R11: 0000000001434d74 R12: 0000000000000016
[42477.087667] R13: 0000000000000000 R14: 000055ab1facbd20 R15: 00007f32e70fe340
[42477.090428]  </TASK>
[42477.093161] task:cache-worker    state:D stack:0     pid:1125343 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42477.096121] Call Trace:
[42477.099016]  <TASK>
[42477.101887]  __schedule+0x581/0x10b0
[42477.104773]  schedule+0x28/0xa0
[42477.107653]  schedule_preempt_disabled+0x16/0x30
[42477.110545]  rwsem_down_write_slowpath+0x2d8/0x750
[42477.113450]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42477.116398]  down_write+0x5c/0x60
[42477.119297]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42477.122254]  file_update_time_flags+0x7e/0x130
[42477.125191]  __xfs_write_fault+0x8c/0x260 [xfs]
[42477.128166]  do_page_mkwrite+0x4a/0xa0
[42477.131086]  do_wp_page+0x136/0x1160
[42477.133963]  ? sock_read_iter+0x8d/0xf0
[42477.136826]  __handle_mm_fault+0xb5a/0x1170
[42477.139690]  ? lock_vma_under_rcu+0x92/0x160
[42477.142551]  handle_mm_fault+0xe3/0x300
[42477.145415]  do_user_addr_fault+0x202/0x690
[42477.148236]  exc_page_fault+0x73/0x150
[42477.150951]  asm_exc_page_fault+0x26/0x30
[42477.153580] RIP: 0033:0x55ab1f9e1e6d
[42477.156230] RSP: 002b:00007f32e7016560 EFLAGS: 00010206
[42477.158909] RAX: 00007f331af70018 RBX: 00007f325c2127b0 RCX: 0000000000000000
[42477.161671] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f325c2127b8
[42477.164449] RBP: 0000000000000000 R08: 0000000000000001 R09: 00007f331bb85000
[42477.167199] R10: 0000000000000000 R11: 0000000001434d3c R12: 0000000000000016
[42477.169940] R13: 000055ab1facbda0 R14: 0000000000000004 R15: 0000000000000004
[42477.172667]  </TASK>
[42477.175358] task:cache-worker    state:D stack:0     pid:1125344 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42477.178267] Call Trace:
[42477.181139]  <TASK>
[42477.183977]  __schedule+0x581/0x10b0
[42477.186833]  schedule+0x28/0xa0
[42477.189678]  schedule_preempt_disabled+0x16/0x30
[42477.192541]  rwsem_down_write_slowpath+0x2d8/0x750
[42477.195416]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42477.198331]  down_write+0x5c/0x60
[42477.201198]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42477.204141]  file_update_time_flags+0x7e/0x130
[42477.207040]  __xfs_write_fault+0x8c/0x260 [xfs]
[42477.209979]  do_page_mkwrite+0x4a/0xa0
[42477.212838]  do_wp_page+0x136/0x1160
[42477.215671]  __handle_mm_fault+0xb5a/0x1170
[42477.218512]  ? lock_vma_under_rcu+0x92/0x160
[42477.221364]  handle_mm_fault+0xe3/0x300
[42477.224212]  do_user_addr_fault+0x202/0x690
[42477.227013]  exc_page_fault+0x73/0x150
[42477.229720]  asm_exc_page_fault+0x26/0x30
[42477.232333] RIP: 0033:0x55ab1f9e1e6d
[42477.234962] RSP: 002b:00007f32cf77d550 EFLAGS: 00010206
[42477.237635] RAX: 00007f331af70018 RBX: 00007f32464022b0 RCX: 0000000000000000
[42477.240381] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f32464022b8
[42477.243136] RBP: 0000000000000000 R08: 00007f32cf77d540 R09: 00007f331bb85000
[42477.245889] R10: 0000000000000000 R11: 0000000001434d54 R12: 0000000000000016
[42477.248633] R13: 0000000000000000 R14: 000055ab1facbd20 R15: 00007f32cf77e340
[42477.251369]  </TASK>
[42477.254063] task:cache-worker    state:D stack:0     pid:1125345 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42477.256987] Call Trace:
[42477.259866]  <TASK>
[42477.262703]  __schedule+0x581/0x10b0
[42477.265575]  schedule+0x28/0xa0
[42477.268437]  schedule_preempt_disabled+0x16/0x30
[42477.271321]  rwsem_down_write_slowpath+0x2d8/0x750
[42477.274204]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42477.277132]  down_write+0x5c/0x60
[42477.280015]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42477.282955]  file_update_time_flags+0x7e/0x130
[42477.285870]  __xfs_write_fault+0x8c/0x260 [xfs]
[42477.288825]  do_page_mkwrite+0x4a/0xa0
[42477.291736]  do_wp_page+0x136/0x1160
[42477.294592]  ? __x64_sys_ioctl+0xb0/0xe0
[42477.297444]  __handle_mm_fault+0xb5a/0x1170
[42477.300309]  ? lock_vma_under_rcu+0x92/0x160
[42477.303182]  handle_mm_fault+0xe3/0x300
[42477.306062]  do_user_addr_fault+0x202/0x690
[42477.308897]  exc_page_fault+0x73/0x150
[42477.311631]  asm_exc_page_fault+0x26/0x30
[42477.314268] RIP: 0033:0x55ab1f9e1e6d
[42477.316929] RSP: 002b:00007f32cf696550 EFLAGS: 00010206
[42477.319627] RAX: 00007f331af70018 RBX: 00007f32c9b2f210 RCX: 0000000000000000
[42477.322393] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f32c9b2f218
[42477.325183] RBP: 0000000000000000 R08: 00007f32cf696540 R09: 00007f331bb85000
[42477.327961] R10: 0000000000000000 R11: 0000000001434d3e R12: 0000000000000016
[42477.330724] R13: 0000000000000000 R14: 000055ab1facbd20 R15: 00007f32cf697340
[42477.333486]  </TASK>
[42477.336207] task:cache-worker    state:D stack:0     pid:1125357 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42477.339148] Call Trace:
[42477.342052]  <TASK>
[42477.344920]  __schedule+0x581/0x10b0
[42477.347812]  schedule+0x28/0xa0
[42477.350678]  schedule_timeout+0xbd/0x100
[42477.353550]  __down_common+0x17c/0x340
[42477.356416]  down+0x52/0x70
[42477.359263]  xfs_buf_lock+0x32/0xd0 [xfs]
[42477.362165]  xfs_buf_find_lock+0x51/0x100 [xfs]
[42477.365058]  xfs_buf_read_map+0x94/0x2b0 [xfs]
[42477.367941]  ? xfs_read_icluster+0x7f/0xd0 [xfs]
[42477.370851]  xfs_trans_read_buf_map+0x12d/0x270 [xfs]
[42477.373745]  ? xfs_read_icluster+0x7f/0xd0 [xfs]
[42477.376626]  xfs_read_icluster+0x7f/0xd0 [xfs]
[42477.379515]  xfs_inode_item_precommit+0x22f/0x2d0 [xfs]
[42477.382422]  __xfs_trans_commit+0xb9/0x300 [xfs]
[42477.385344]  xfs_trans_commit+0x38/0x70 [xfs]
[42477.388215]  xfs_vn_update_time+0x187/0x1b0 [xfs]
[42477.391000]  file_update_time_flags+0x7e/0x130
[42477.393660]  __xfs_write_fault+0x8c/0x260 [xfs]
[42477.396399]  do_page_mkwrite+0x4a/0xa0
[42477.399081]  do_wp_page+0x136/0x1160
[42477.401767]  ? do_syscall_64+0xf9/0x550
[42477.404456]  ? do_getsockname+0x7e/0xb0
[42477.407122]  ? sock_copy_user_timeval+0x110/0x130
[42477.409803]  __handle_mm_fault+0xb5a/0x1170
[42477.412472]  ? lock_vma_under_rcu+0x92/0x160
[42477.415133]  handle_mm_fault+0xe3/0x300
[42477.417785]  do_user_addr_fault+0x202/0x690
[42477.420440]  exc_page_fault+0x73/0x150
[42477.423079]  asm_exc_page_fault+0x26/0x30
[42477.425732] RIP: 0033:0x55ab1f9e1e6d
[42477.428383] RSP: 002b:00007f32cd6d36c0 EFLAGS: 00010206
[42477.431064] RAX: 00007f331afea018 RBX: 00007f311aa0a050 RCX: 0000000000000000
[42477.433815] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f311aa0a058
[42477.436573] RBP: 0000000000000000 R08: 0000000000000000 R09: 000055ab1fb05cbe
[42477.439321] R10: 000000000000000d R11: 000000000000000e R12: 0000000000000016
[42477.442048] R13: 000055ab1fafd530 R14: 00007f32cd6d4340 R15: 00007f32cd6d4390
[42477.444803]  </TASK>
[42477.447525] task:cache-worker    state:D stack:0     pid:1125358 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42477.450470] Call Trace:
[42477.453345]  <TASK>
[42477.456173]  __schedule+0x581/0x10b0
[42477.459017]  schedule+0x28/0xa0
[42477.461850]  schedule_preempt_disabled+0x16/0x30
[42477.464712]  rwsem_down_write_slowpath+0x2d8/0x750
[42477.467533]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42477.470299]  down_write+0x5c/0x60
[42477.472926]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42477.475641]  file_update_time_flags+0x7e/0x130
[42477.478327]  __xfs_write_fault+0x8c/0x260 [xfs]
[42477.481067]  ? __seccomp_filter+0x42/0x5c0
[42477.483781]  do_page_mkwrite+0x4a/0xa0
[42477.486483]  do_wp_page+0x136/0x1160
[42477.489182]  ? do_syscall_64+0xf9/0x550
[42477.491885]  __handle_mm_fault+0xb5a/0x1170
[42477.494596]  ? do_syscall_64+0x25a/0x550
[42477.497319]  ? lock_vma_under_rcu+0x92/0x160
[42477.500032]  handle_mm_fault+0xe3/0x300
[42477.502725]  do_user_addr_fault+0x202/0x690
[42477.505412]  exc_page_fault+0x73/0x150
[42477.508092]  asm_exc_page_fault+0x26/0x30
[42477.510750] RIP: 0033:0x55ab1f9e1e6d
[42477.513394] RSP: 002b:00007f32cd6be550 EFLAGS: 00010206
[42477.516059] RAX: 00007f331af70018 RBX: 00007f3255e3b350 RCX: 0000000000000000
[42477.518782] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f3255e3b358
[42477.521513] RBP: 0000000000000000 R08: 00007f32cd6be540 R09: 00007f331bb85000
[42477.524244] R10: 0000000000000000 R11: 0000000001434d90 R12: 0000000000000016
[42477.526964] R13: 0000000000000000 R14: 000055ab1facbd20 R15: 00007f32cd6bf340
[42477.529696]  </TASK>
[42477.532398] task:cache-worker    state:D stack:0     pid:1125362 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42477.535345] Call Trace:
[42477.538236]  <TASK>
[42477.541099]  __schedule+0x581/0x10b0
[42477.543973]  schedule+0x28/0xa0
[42477.546828]  schedule_preempt_disabled+0x16/0x30
[42477.549711]  rwsem_down_write_slowpath+0x2d8/0x750
[42477.552603]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42477.555543]  down_write+0x5c/0x60
[42477.558421]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42477.561364]  file_update_time_flags+0x7e/0x130
[42477.564238]  __xfs_write_fault+0x8c/0x260 [xfs]
[42477.567134]  do_page_mkwrite+0x4a/0xa0
[42477.570006]  do_wp_page+0x136/0x1160
[42477.572883]  __handle_mm_fault+0xb5a/0x1170
[42477.575754]  ? lock_vma_under_rcu+0x92/0x160
[42477.578578]  handle_mm_fault+0xe3/0x300
[42477.581306]  do_user_addr_fault+0x202/0x690
[42477.583944]  exc_page_fault+0x73/0x150
[42477.586596]  asm_exc_page_fault+0x26/0x30
[42477.589262] RIP: 0033:0x55ab1f9e1e6d
[42477.591930] RSP: 002b:00007f32cc2ea550 EFLAGS: 00010206
[42477.594625] RAX: 00007f331af70018 RBX: 00007f316a22d1a0 RCX: 0000000000000000
[42477.597389] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f316a22d1a8
[42477.600155] RBP: 0000000000000000 R08: 00007f32cc2ea540 R09: 00007f331bb85000
[42477.602908] R10: 0000000000000000 R11: 0000000001434d62 R12: 0000000000000016
[42477.605659] R13: 0000000000000000 R14: 000055ab1facbd20 R15: 00007f32cc2eb340
[42477.608400]  </TASK>
[42477.611105] task:cache-worker    state:D stack:0     pid:1125365 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42477.614046] Call Trace:
[42477.616944]  <TASK>
[42477.619821]  __schedule+0x581/0x10b0
[42477.622714]  schedule+0x28/0xa0
[42477.625597]  schedule_preempt_disabled+0x16/0x30
[42477.628500]  rwsem_down_write_slowpath+0x2d8/0x750
[42477.631410]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42477.634364]  down_write+0x5c/0x60
[42477.637267]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42477.640231]  file_update_time_flags+0x7e/0x130
[42477.643166]  __xfs_write_fault+0x8c/0x260 [xfs]
[42477.646140]  do_page_mkwrite+0x4a/0xa0
[42477.649069]  do_wp_page+0x136/0x1160
[42477.651948]  __handle_mm_fault+0xb5a/0x1170
[42477.654820]  ? lock_vma_under_rcu+0x92/0x160
[42477.657702]  handle_mm_fault+0xe3/0x300
[42477.660579]  do_user_addr_fault+0x202/0x690
[42477.663466]  exc_page_fault+0x73/0x150
[42477.666298]  asm_exc_page_fault+0x26/0x30
[42477.669039] RIP: 0033:0x55ab1f9e1e6d
[42477.671683] RSP: 002b:00007f32c8e3e550 EFLAGS: 00010206
[42477.674376] RAX: 00007f331af70018 RBX: 00007f311d203190 RCX: 0000000000000000
[42477.677152] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f311d203198
[42477.679946] RBP: 0000000000000000 R08: 00007f32c8e3e540 R09: 00007f331bb85000
[42477.682734] R10: 0000000000000000 R11: 0000000001434d7a R12: 0000000000000016
[42477.685521] R13: 0000000000000000 R14: 000055ab1facbd20 R15: 00007f32c8e3f340
[42477.688296]  </TASK>
[42477.691036] task:cache-worker    state:D stack:0     pid:1125376 tgid:849910 ppid:13218  task_flags:0x440040 flags:0x00080000
[42477.694000] Call Trace:
[42477.696907]  <TASK>
[42477.699785]  __schedule+0x581/0x10b0
[42477.702669]  schedule+0x28/0xa0
[42477.705554]  schedule_preempt_disabled+0x16/0x30
[42477.708458]  rwsem_down_write_slowpath+0x2d8/0x750
[42477.711367]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42477.714313]  down_write+0x5c/0x60
[42477.717217]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42477.720182]  file_update_time_flags+0x7e/0x130
[42477.720184]  __xfs_write_fault+0x8c/0x260 [xfs]
[42477.726075]  do_page_mkwrite+0x4a/0xa0
[42477.726077]  do_wp_page+0x136/0x1160
[42477.726079]  __handle_mm_fault+0xb5a/0x1170
[42477.726081]  ? do_syscall_64+0xf9/0x550
[42477.726085]  ? lock_vma_under_rcu+0x92/0x160
[42477.726087]  handle_mm_fault+0xe3/0x300
[42477.726091]  do_user_addr_fault+0x202/0x690
[42477.746079]  exc_page_fault+0x73/0x150
[42477.748780]  asm_exc_page_fault+0x26/0x30
[42477.751388] RIP: 0033:0x55ab1f9e1e6d
[42477.754007] RSP: 002b:00007f329d77d530 EFLAGS: 00010206
[42477.756674] RAX: 00007f331af70018 RBX: 00007f3127e14830 RCX: 0000000000000000
[42477.759417] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f3127e14838
[42477.762164] RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
[42477.764900] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000016
[42477.767604] R13: 000055ab1facc058 R14: 00007f330637c368 R15: 00007f329d77d820
[42477.770307]  </TASK>
[42477.773114] task:kworker/112:0   state:D stack:0     pid:1005940 tgid:1005940 ppid:2      task_flags:0x4248060 flags:0x00080000
[42477.778832] Workqueue: xfs-conv/dm-30 xfs_end_io [xfs]
[42477.781797] Call Trace:
[42477.784707]  <TASK>
[42477.787584]  __schedule+0x581/0x10b0
[42477.790470]  schedule+0x28/0xa0
[42477.793341]  schedule_timeout+0xbd/0x100
[42477.796216]  __down_common+0x17c/0x340
[42477.799077]  ? asm_sysvec_apic_timer_interrupt+0x1a/0x20
[42477.801991]  down+0x52/0x70
[42477.804887]  xfs_buf_lock+0x32/0xd0 [xfs]
[42477.807836]  xfs_buf_find_lock+0x51/0x100 [xfs]
[42477.810724]  xfs_buf_read_map+0x94/0x2b0 [xfs]
[42477.813598]  ? xfs_read_agf+0x9b/0x140 [xfs]
[42477.816512]  ? xfs_trans_add_item+0x37/0xb0 [xfs]
[42477.819414]  xfs_trans_read_buf_map+0x12d/0x270 [xfs]
[42477.822329]  ? xfs_read_agf+0x9b/0x140 [xfs]
[42477.825210]  xfs_read_agf+0x9b/0x140 [xfs]
[42477.827987]  xfs_alloc_read_agf+0x54/0x1e0 [xfs]
[42477.830670]  xfs_alloc_fix_freelist+0x3d2/0x500 [xfs]
[42477.833388]  xfs_free_extent_fix_freelist+0x64/0xa0 [xfs]
[42477.836131]  __xfs_free_extent+0x53/0x1a0 [xfs]
[42477.838875]  xfs_extent_free_finish_item+0x9e/0x1c0 [xfs]
[42477.841680]  xfs_defer_finish_one+0x101/0x290 [xfs]
[42477.844495]  xfs_defer_finish_noroll+0x1be/0x500 [xfs]
[42477.847285]  xfs_trans_commit+0x4f/0x70 [xfs]
[42477.850055]  ? xfs_iomap_write_unwritten+0x1e9/0x350 [xfs]
[42477.852862]  xfs_iomap_write_unwritten+0x140/0x350 [xfs]
[42477.855670]  xfs_end_io+0x329/0x3c0 [xfs]
[42477.858464]  process_one_work+0x1ca/0x3c0
[42477.861218]  worker_thread+0x1ac/0x320
[42477.863977]  ? __pfx_worker_thread+0x10/0x10
[42477.866743]  kthread+0xe5/0x120
[42477.869504]  ? __pfx_kthread+0x10/0x10
[42477.872275]  ret_from_fork+0x2b7/0x340
[42477.875040]  ? __pfx_kthread+0x10/0x10
[42477.877805]  ret_from_fork_asm+0x1a/0x30
[42477.880573]  </TASK>
[42477.883324] task:kworker/124:3   state:D stack:0     pid:1020182 tgid:1020182 ppid:2      task_flags:0x4208060 flags:0x00080000
[42477.889187] Workqueue: xfs-sync/dm-37 xfs_log_worker [xfs]
[42477.892213] Call Trace:
[42477.895145]  <TASK>
[42477.898067]  __schedule+0x581/0x10b0
[42477.901031]  schedule+0x28/0xa0
[42477.903966]  raid5_get_active_stripe+0x283/0x5a0 [raid456]
[42477.906911]  ? __pfx_autoremove_wake_function+0x10/0x10
[42477.909783]  raid5_make_request+0x226/0x1520 [raid456]
[42477.912567]  ? bdev_start_io_acct+0x2a/0xa0
[42477.915325]  ? dm_io_acct+0xb9/0xf0 [dm_mod]
[42477.918062]  ? __pfx_woken_wake_function+0x10/0x10
[42477.920845]  md_handle_request+0x22b/0x370 [md_mod]
[42477.923651]  ? bio_split_to_limits+0x145/0x160
[42477.926458]  __submit_bio+0xa1/0x140
[42477.929275]  submit_bio_noacct_nocheck+0x12a/0x350
[42477.932124]  xlog_state_release_iclog+0xe2/0x150 [xfs]
[42477.935029]  xfs_log_force+0x1d6/0x240 [xfs]
[42477.937890]  xfs_log_worker+0x3d/0xc0 [xfs]
[42477.940734]  process_one_work+0x1ca/0x3c0
[42477.943553]  worker_thread+0x1ac/0x320
[42477.946368]  ? __pfx_worker_thread+0x10/0x10
[42477.949193]  kthread+0xe5/0x120
[42477.952007]  ? __pfx_kthread+0x10/0x10
[42477.954810]  ret_from_fork+0x2b7/0x340
[42477.957596]  ? __pfx_kthread+0x10/0x10
[42477.960369]  ret_from_fork_asm+0x1a/0x30
[42477.963136]  </TASK>
[42477.965902] task:kworker/43:0    state:D stack:0     pid:1061131 tgid:1061131 ppid:2      task_flags:0x4248060 flags:0x00080000
[42477.971728] Workqueue: xfs-inodegc/dm-39 xfs_inodegc_worker [xfs]
[42477.974771] Call Trace:
[42477.977721]  <TASK>
[42477.980648]  __schedule+0x581/0x10b0
[42477.983586]  schedule+0x28/0xa0
[42477.986482]  schedule_timeout+0xbd/0x100
[42477.989361]  __down_common+0x17c/0x340
[42477.992223]  down+0x52/0x70
[42477.995065]  xfs_buf_lock+0x32/0xd0 [xfs]
[42477.997994]  xfs_buf_find_lock+0x51/0x100 [xfs]
[42478.000894]  xfs_buf_read_map+0x94/0x2b0 [xfs]
[42478.003785]  ? xfs_read_agf+0x9b/0x140 [xfs]
[42478.006706]  xfs_trans_read_buf_map+0x12d/0x270 [xfs]
[42478.009665]  ? xfs_read_agf+0x9b/0x140 [xfs]
[42478.012635]  xfs_read_agf+0x9b/0x140 [xfs]
[42478.015599]  xfs_alloc_read_agf+0x54/0x1e0 [xfs]
[42478.018564]  xfs_alloc_fix_freelist+0x3d2/0x500 [xfs]
[42478.021443]  xfs_free_extent_fix_freelist+0x64/0xa0 [xfs]
[42478.024238]  xfs_rmap_finish_one+0x98/0x220 [xfs]
[42478.027018]  ? kmem_cache_alloc_noprof+0x2f6/0x420
[42478.029721]  xfs_rmap_update_finish_item+0x19/0x30 [xfs]
[42478.032535]  xfs_defer_finish_one+0x101/0x290 [xfs]
[42478.035365]  xfs_defer_finish_noroll+0x1be/0x500 [xfs]
[42478.038183]  xfs_defer_finish+0x15/0x70 [xfs]
[42478.040957]  xfs_bunmapi_range+0x58/0xb0 [xfs]
[42478.043732]  xfs_itruncate_extents_flags+0x15d/0x270 [xfs]
[42478.046517]  xfs_inactive_truncate+0xab/0xe0 [xfs]
[42478.049279]  xfs_inactive+0x308/0x330 [xfs]
[42478.052027]  xfs_inodegc_worker+0xb8/0x180 [xfs]
[42478.054769]  process_one_work+0x1ca/0x3c0
[42478.057439]  worker_thread+0x1ac/0x320
[42478.060089]  ? __pfx_worker_thread+0x10/0x10
[42478.062743]  kthread+0xe5/0x120
[42478.065377]  ? __pfx_kthread+0x10/0x10
[42478.068000]  ret_from_fork+0x2b7/0x340
[42478.070597]  ? __pfx_kthread+0x10/0x10
[42478.073207]  ret_from_fork_asm+0x1a/0x30
[42478.075812]  </TASK>
[42478.078434] task:kworker/u526:1  state:D stack:0     pid:1074856 tgid:1074856 ppid:2      task_flags:0x4208060 flags:0x00080000
[42478.083979] Workqueue: writeback wb_workfn (flush-253:39)
[42478.086836] Call Trace:
[42478.089676]  <TASK>
[42478.092496]  __schedule+0x581/0x10b0
[42478.095331]  schedule+0x28/0xa0
[42478.098148]  schedule_preempt_disabled+0x16/0x30
[42478.100899]  rwsem_down_read_slowpath+0x2c9/0x590
[42478.103558]  down_read+0x49/0xa0
[42478.106154]  xfs_writeback_range+0xf3/0x470 [xfs]
[42478.108817]  iomap_writeback_folio+0x28f/0x6e0
[42478.111456]  iomap_writepages+0x5e/0xd0
[42478.114069]  xfs_vm_writepages+0x93/0x110 [xfs]
[42478.116758]  do_writepages+0xca/0x170
[42478.119415]  __writeback_single_inode+0x42/0x350
[42478.122084]  writeback_sb_inodes+0x23d/0x560
[42478.124764]  __writeback_inodes_wb+0x4c/0xf0
[42478.127449]  wb_writeback+0x1ac/0x310
[42478.130127]  wb_workfn+0x392/0x470
[42478.132803]  process_one_work+0x1ca/0x3c0
[42478.135480]  worker_thread+0x1ac/0x320
[42478.138130]  ? __pfx_worker_thread+0x10/0x10
[42478.140784]  kthread+0xe5/0x120
[42478.143424]  ? __pfx_kthread+0x10/0x10
[42478.146056]  ret_from_fork+0x2b7/0x340
[42478.148684]  ? __pfx_kthread+0x10/0x10
[42478.151290]  ret_from_fork_asm+0x1a/0x30
[42478.153882]  </TASK>
[42478.156442] task:kworker/u526:4  state:D stack:0     pid:1075438 tgid:1075438 ppid:2      task_flags:0x4248060 flags:0x00080000
[42478.161912] Workqueue: xfs-cil/dm-44 xlog_cil_push_work [xfs]
[42478.164803] Call Trace:
[42478.167610]  <TASK>
[42478.170384]  __schedule+0x581/0x10b0
[42478.173169]  schedule+0x28/0xa0
[42478.175926]  xlog_wait_on_iclog+0x159/0x190 [xfs]
[42478.178760]  ? __pfx_default_wake_function+0x10/0x10
[42478.181572]  xlog_cil_push_work+0x904/0x9b0 [xfs]
[42478.184435]  process_one_work+0x1ca/0x3c0
[42478.187258]  worker_thread+0x1ac/0x320
[42478.190066]  ? __pfx_worker_thread+0x10/0x10
[42478.192888]  kthread+0xe5/0x120
[42478.195704]  ? __pfx_kthread+0x10/0x10
[42478.198524]  ret_from_fork+0x2b7/0x340
[42478.201347]  ? __pfx_kthread+0x10/0x10
[42478.204172]  ret_from_fork_asm+0x1a/0x30
[42478.206992]  </TASK>
[42478.209800] task:kworker/118:0   state:D stack:0     pid:1097194 tgid:1097194 ppid:2      task_flags:0x4248060 flags:0x00080000
[42478.215349] Workqueue: xfs-conv/dm-39 xfs_end_io [xfs]
[42478.218217] Call Trace:
[42478.221032]  <TASK>
[42478.223823]  __schedule+0x581/0x10b0
[42478.226635]  schedule+0x28/0xa0
[42478.229441]  schedule_timeout+0xbd/0x100
[42478.232238]  __down_common+0x17c/0x340
[42478.235016]  down+0x52/0x70
[42478.237773]  xfs_buf_lock+0x32/0xd0 [xfs]
[42478.240596]  xfs_buf_find_lock+0x51/0x100 [xfs]
[42478.243411]  xfs_buf_read_map+0x94/0x2b0 [xfs]
[42478.246204]  ? xfs_btree_read_buf_block+0xa0/0x120 [xfs]
[42478.249057]  ? xfs_trans_add_item+0x37/0xb0 [xfs]
[42478.251891]  xfs_trans_read_buf_map+0x12d/0x270 [xfs]
[42478.254729]  ? xfs_btree_read_buf_block+0xa0/0x120 [xfs]
[42478.257604]  xfs_btree_read_buf_block+0xa0/0x120 [xfs]
[42478.260483]  xfs_btree_lookup_get_block+0xa3/0x1f0 [xfs]
[42478.263382]  xfs_btree_lookup+0xf2/0x550 [xfs]
[42478.266254]  xfs_rmap_lookup_le+0x56/0xc0 [xfs]
[42478.269156]  xfs_rmap_convert+0xaf/0x1460 [xfs]
[42478.272030]  xfs_rmap_finish_one+0x115/0x220 [xfs]
[42478.274898]  ? kmem_cache_alloc_noprof+0x2f6/0x420
[42478.277725]  xfs_rmap_update_finish_item+0x19/0x30 [xfs]
[42478.280644]  xfs_defer_finish_one+0x101/0x290 [xfs]
[42478.283581]  xfs_defer_finish_noroll+0x1be/0x500 [xfs]
[42478.286503]  xfs_trans_commit+0x4f/0x70 [xfs]
[42478.289435]  xfs_iomap_write_unwritten+0x140/0x350 [xfs]
[42478.292303]  xfs_end_io+0x329/0x3c0 [xfs]
[42478.295038]  process_one_work+0x1ca/0x3c0
[42478.297687]  worker_thread+0x1ac/0x320
[42478.300302]  ? __pfx_worker_thread+0x10/0x10
[42478.302950]  kthread+0xe5/0x120
[42478.305594]  ? __pfx_kthread+0x10/0x10
[42478.308251]  ret_from_fork+0x2b7/0x340
[42478.310890]  ? __pfx_kthread+0x10/0x10
[42478.313508]  ret_from_fork_asm+0x1a/0x30
[42478.316113]  </TASK>
[42478.318725] task:kworker/u525:3  state:D stack:0     pid:1111037 tgid:1111037 ppid:2      task_flags:0x4248060 flags:0x00080000
[42478.324258] Workqueue: xfs-cil/dm-23 xlog_cil_push_work [xfs]
[42478.327161] Call Trace:
[42478.329997]  <TASK>
[42478.332814]  ? __pfx_wbt_cleanup_cb+0x10/0x10
[42478.335681]  __schedule+0x581/0x10b0
[42478.338533]  ? __pfx_wbt_inflight_cb+0x10/0x10
[42478.341411]  ? __pfx_wbt_cleanup_cb+0x10/0x10
[42478.344189]  schedule+0x28/0xa0
[42478.346840]  io_schedule+0x46/0x70
[42478.349461]  rq_qos_wait+0xb3/0x150
[42478.352056]  ? __pfx_rq_qos_wake_function+0x10/0x10
[42478.354697]  ? __pfx_wbt_inflight_cb+0x10/0x10
[42478.357343]  wbt_wait+0xa5/0x100
[42478.359980]  __rq_qos_throttle+0x27/0x40
[42478.362636]  blk_mq_submit_bio+0x589/0x8b0
[42478.365299]  submit_bio_noacct_nocheck+0x12a/0x350
[42478.367987]  xlog_state_release_iclog+0xe2/0x150 [xfs]
[42478.370736]  xlog_cil_push_work+0x719/0x9b0 [xfs]
[42478.373491]  process_one_work+0x1ca/0x3c0
[42478.376212]  worker_thread+0x1ac/0x320
[42478.378908]  ? __pfx_worker_thread+0x10/0x10
[42478.381611]  kthread+0xe5/0x120
[42478.384294]  ? __pfx_kthread+0x10/0x10
[42478.386952]  ret_from_fork+0x2b7/0x340
[42478.389591]  ? __pfx_kthread+0x10/0x10
[42478.392213]  ret_from_fork_asm+0x1a/0x30
[42478.394833]  </TASK>
[42478.397433] task:kworker/u525:5  state:D stack:0     pid:1112426 tgid:1112426 ppid:2      task_flags:0x4208060 flags:0x00080000
[42478.403049] Workqueue: writeback wb_workfn (flush-253:23)
[42478.405933] Call Trace:
[42478.408779]  <TASK>
[42478.411580]  __schedule+0x581/0x10b0
[42478.414398]  schedule+0x28/0xa0
[42478.417197]  schedule_preempt_disabled+0x16/0x30
[42478.420007]  rwsem_down_read_slowpath+0x2c9/0x590
[42478.422801]  down_read+0x49/0xa0
[42478.425591]  xfs_writeback_range+0xf3/0x470 [xfs]
[42478.428477]  iomap_writeback_folio+0x28f/0x6e0
[42478.431305]  iomap_writepages+0x5e/0xd0
[42478.434098]  xfs_vm_writepages+0x93/0x110 [xfs]
[42478.436961]  do_writepages+0xca/0x170
[42478.439784]  __writeback_single_inode+0x42/0x350
[42478.442630]  writeback_sb_inodes+0x23d/0x560
[42478.445488]  __writeback_inodes_wb+0x4c/0xf0
[42478.448346]  wb_writeback+0x1ac/0x310
[42478.451100]  wb_workfn+0x392/0x470
[42478.453736]  process_one_work+0x1ca/0x3c0
[42478.456344]  worker_thread+0x1ac/0x320
[42478.458913]  ? __pfx_worker_thread+0x10/0x10
[42478.461525]  kthread+0xe5/0x120
[42478.464116]  ? __pfx_kthread+0x10/0x10
[42478.466703]  ret_from_fork+0x2b7/0x340
[42478.469279]  ? __pfx_kthread+0x10/0x10
[42478.471858]  ret_from_fork_asm+0x1a/0x30
[42478.474428]  </TASK>
[42478.477000] task:systemd-journal state:D stack:0     pid:1117465 tgid:1117465 ppid:1      task_flags:0x440100 flags:0x00080000
[42478.482537] Call Trace:
[42478.485297]  <TASK>
[42478.488021]  __schedule+0x581/0x10b0
[42478.490758]  schedule+0x28/0xa0
[42478.493491]  schedule_preempt_disabled+0x16/0x30
[42478.496235]  rwsem_down_write_slowpath+0x2d8/0x750
[42478.498966]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42478.501755]  down_write+0x5c/0x60
[42478.504473]  xfs_vn_update_time+0x147/0x1b0 [xfs]
[42478.507273]  file_update_time_flags+0x7e/0x130
[42478.510018]  __xfs_write_fault+0x8c/0x260 [xfs]
[42478.512815]  do_page_mkwrite+0x4a/0xa0
[42478.515567]  do_wp_page+0x136/0x1160
[42478.518304]  __handle_mm_fault+0xb5a/0x1170
[42478.521063]  ? ttwu_queue_wakelist+0xe1/0x100
[42478.523835]  ? lock_vma_under_rcu+0x92/0x160
[42478.526605]  handle_mm_fault+0xe3/0x300
[42478.529282]  do_user_addr_fault+0x202/0x690
[42478.531858]  exc_page_fault+0x73/0x150
[42478.534391]  asm_exc_page_fault+0x26/0x30
[42478.536911] RIP: 0033:0x7f1f0ee53947
[42478.539447] RSP: 002b:00007ffc4b19c9b0 EFLAGS: 00010246
[42478.542012] RAX: 00007f1f0cb68c68 RBX: 0000000000000089 RCX: 0000000000568c68
[42478.544656] RDX: 00007f1f0f090000 RSI: 0000000000000001 RDI: 0000558e98a2faa0
[42478.547300] RBP: 0000000000000001 R08: 0000000000000089 R09: 0000558e98a3b048
[42478.549922] R10: 0000000000000001 R11: 000000000143356e R12: 0000000000000000
[42478.552539] R13: 0000558e98a3b010 R14: 00007ffc4b19cad0 R15: 00000009dfc1c308
[42478.555152]  </TASK>
[42478.557746] task:kworker/40:0    state:D stack:0     pid:1120279 tgid:1120279 ppid:2      task_flags:0x4248060 flags:0x00080000
[42478.563304] Workqueue: xfs-inodegc/dm-23 xfs_inodegc_worker [xfs]
[42478.566224] Call Trace:
[42478.569067]  <TASK>
[42478.571869]  __schedule+0x581/0x10b0
[42478.574685]  schedule+0x28/0xa0
[42478.577485]  schedule_timeout+0xbd/0x100
[42478.580293]  __down_common+0x17c/0x340
[42478.583093]  down+0x52/0x70
[42478.585878]  xfs_buf_lock+0x32/0xd0 [xfs]
[42478.588734]  xfs_buf_find_lock+0x51/0x100 [xfs]
[42478.591568]  xfs_buf_read_map+0x94/0x2b0 [xfs]
[42478.594387]  ? xfs_read_agf+0x9b/0x140 [xfs]
[42478.597253]  xfs_trans_read_buf_map+0x12d/0x270 [xfs]
[42478.600156]  ? xfs_read_agf+0x9b/0x140 [xfs]
[42478.603045]  xfs_read_agf+0x9b/0x140 [xfs]
[42478.605938]  xfs_alloc_read_agf+0x54/0x1e0 [xfs]
[42478.608742]  xfs_alloc_fix_freelist+0x3d2/0x500 [xfs]
[42478.611439]  ? psi_group_change+0x121/0x2f0
[42478.614109]  ? kmem_cache_alloc_noprof+0x2f6/0x420
[42478.616828]  xfs_free_extent_fix_freelist+0x64/0xa0 [xfs]
[42478.619616]  __xfs_free_extent+0x53/0x1a0 [xfs]
[42478.622403]  xfs_extent_free_finish_item+0x9e/0x1c0 [xfs]
[42478.625260]  xfs_defer_finish_one+0x101/0x290 [xfs]
[42478.628116]  xfs_defer_finish_noroll+0x1be/0x500 [xfs]
[42478.630939]  xfs_defer_finish+0x15/0x70 [xfs]
[42478.633732]  xfs_bunmapi_range+0x58/0xb0 [xfs]
[42478.636529]  xfs_itruncate_extents_flags+0x15d/0x270 [xfs]
[42478.639367]  xfs_inactive_truncate+0xab/0xe0 [xfs]
[42478.642178]  xfs_inactive+0x308/0x330 [xfs]
[42478.644972]  xfs_inodegc_worker+0xb8/0x180 [xfs]
[42478.647784]  process_one_work+0x1ca/0x3c0
[42478.650533]  worker_thread+0x1ac/0x320
[42478.653273]  ? __pfx_worker_thread+0x10/0x10
[42478.656026]  kthread+0xe5/0x120
[42478.658762]  ? __pfx_kthread+0x10/0x10
[42478.661508]  ret_from_fork+0x2b7/0x340
[42478.664247]  ? __pfx_kthread+0x10/0x10
[42478.666972]  ret_from_fork_asm+0x1a/0x30
[42478.669703]  </TASK>
[42478.672404] task:kworker/43:2    state:D stack:0     pid:1120701 tgid:1120701 ppid:2      task_flags:0x4248060 flags:0x00080000
[42478.678122] Workqueue: xfs-inodegc/dm-23 xfs_inodegc_worker [xfs]
[42478.681137] Call Trace:
[42478.684088]  <TASK>
[42478.686996]  __schedule+0x581/0x10b0
[42478.689880]  schedule+0x28/0xa0
[42478.692657]  schedule_timeout+0xbd/0x100
[42478.695334]  __down_common+0x17c/0x340
[42478.697956]  down+0x52/0x70
[42478.700535]  xfs_buf_lock+0x32/0xd0 [xfs]
[42478.703203]  xfs_buf_find_lock+0x51/0x100 [xfs]
[42478.705867]  xfs_buf_read_map+0x94/0x2b0 [xfs]
[42478.708524]  ? xfs_btree_read_buf_block+0xa0/0x120 [xfs]
[42478.711254]  ? xfs_trans_add_item+0x37/0xb0 [xfs]
[42478.713987]  xfs_trans_read_buf_map+0x12d/0x270 [xfs]
[42478.716735]  ? xfs_btree_read_buf_block+0xa0/0x120 [xfs]
[42478.719515]  xfs_btree_read_buf_block+0xa0/0x120 [xfs]
[42478.722301]  xfs_btree_lookup_get_block+0xa3/0x1f0 [xfs]
[42478.725102]  xfs_btree_lookup+0xf2/0x550 [xfs]
[42478.727877]  xfs_free_ag_extent+0xdb/0xa60 [xfs]
[42478.730653]  ? xfs_free_extent_fix_freelist+0x64/0xa0 [xfs]
[42478.733450]  __xfs_free_extent+0x9c/0x1a0 [xfs]
[42478.736248]  xfs_extent_free_finish_item+0x9e/0x1c0 [xfs]
[42478.739069]  xfs_defer_finish_one+0x101/0x290 [xfs]
[42478.741894]  xfs_defer_finish_noroll+0x1be/0x500 [xfs]
[42478.744687]  xfs_defer_finish+0x15/0x70 [xfs]
[42478.747450]  xfs_bunmapi_range+0x58/0xb0 [xfs]
[42478.750198]  xfs_itruncate_extents_flags+0x15d/0x270 [xfs]
[42478.752979]  xfs_inactive_truncate+0xab/0xe0 [xfs]
[42478.755721]  xfs_inactive+0x308/0x330 [xfs]
[42478.758426]  xfs_inodegc_worker+0xb8/0x180 [xfs]
[42478.761157]  process_one_work+0x1ca/0x3c0
[42478.763844]  worker_thread+0x1ac/0x320
[42478.766519]  ? __pfx_worker_thread+0x10/0x10
[42478.769195]  kthread+0xe5/0x120
[42478.771847]  ? __pfx_kthread+0x10/0x10
[42478.774501]  ret_from_fork+0x2b7/0x340
[42478.777158]  ? __pfx_kthread+0x10/0x10
[42478.779800]  ret_from_fork_asm+0x1a/0x30
[42478.782440]  </TASK>
[42478.785058] task:kworker/u526:6  state:D stack:0     pid:1122217 tgid:1122217 ppid:2      task_flags:0x4248060 flags:0x00080000
[42478.790687] Workqueue: xfs-cil/dm-44 xlog_cil_push_work [xfs]
[42478.793656] Call Trace:
[42478.796558]  <TASK>
[42478.799437]  __schedule+0x581/0x10b0
[42478.802322]  schedule+0x28/0xa0
[42478.805103]  xlog_wait_on_iclog+0x159/0x190 [xfs]
[42478.807856]  ? __pfx_default_wake_function+0x10/0x10
[42478.810541]  xlog_cil_push_work+0x904/0x9b0 [xfs]
[42478.813242]  process_one_work+0x1ca/0x3c0
[42478.815938]  worker_thread+0x1ac/0x320
[42478.818622]  ? __pfx_worker_thread+0x10/0x10
[42478.821333]  kthread+0xe5/0x120
[42478.824044]  ? __pfx_kthread+0x10/0x10
[42478.826754]  ret_from_fork+0x2b7/0x340
[42478.829463]  ? __pfx_kthread+0x10/0x10
[42478.832164]  ret_from_fork_asm+0x1a/0x30
[42478.834871]  </TASK>
[42478.837568] task:/usr/sbin/apach state:D stack:0     pid:1124371 tgid:1124371 ppid:15065  task_flags:0x400140 flags:0x00080000
[42478.843324] Call Trace:
[42478.846176]  <TASK>
[42478.848985]  __schedule+0x581/0x10b0
[42478.851799]  schedule+0x28/0xa0
[42478.854581]  schedule_timeout+0xbd/0x100
[42478.857374]  __down_common+0x17c/0x340
[42478.860160]  down+0x52/0x70
[42478.862896]  xfs_buf_lock+0x32/0xd0 [xfs]
[42478.865722]  xfs_buf_find_lock+0x51/0x100 [xfs]
[42478.868498]  xfs_buf_read_map+0x94/0x2b0 [xfs]
[42478.871242]  ? xfs_read_icluster+0x7f/0xd0 [xfs]
[42478.874045]  xfs_trans_read_buf_map+0x12d/0x270 [xfs]
[42478.876866]  ? xfs_read_icluster+0x7f/0xd0 [xfs]
[42478.879691]  xfs_read_icluster+0x7f/0xd0 [xfs]
[42478.882487]  xfs_iget+0x350/0xa80 [xfs]
[42478.885283]  xfs_lookup+0x126/0x1b0 [xfs]
[42478.888073]  xfs_vn_lookup+0x92/0xc0 [xfs]
[42478.890843]  __lookup_slow+0x5b/0x100
[42478.893570]  lookup_slow+0x35/0x50
[42478.896288]  path_lookupat+0x18f/0x2a0
[42478.898995]  filename_lookup+0x103/0x210
[42478.901705]  vfs_statx+0x80/0x160
[42478.904409]  vfs_fstatat+0x4a/0x90
[42478.907098]  __do_sys_newfstatat+0x49/0x90
[42478.909807]  do_syscall_64+0xc0/0x550
[42478.912520]  ? step_into_slowpath+0x191/0x330
[42478.915242]  ? dput.part.0+0x25/0x190
[42478.917865]  ? mntput+0x21/0x60
[42478.920363]  ? terminate_walk+0xb3/0xf0
[42478.922821]  ? tomoyo_init_request_info+0x98/0xc0
[42478.925280]  ? tomoyo_path_perm+0xac/0x200
[42478.927747]  ? xas_load+0xd/0xc0
[42478.930203]  ? xa_load+0x77/0xb0
[42478.932642]  ? __list_lru_add.part.0+0x2f/0x90
[42478.935095]  ? list_lru_add+0x98/0x100
[42478.937526]  ? list_lru_add_obj+0x83/0xa0
[42478.939929]  ? from_kgid_munged+0x17/0x30
[42478.942304]  ? cp_new_stat+0x132/0x170
[42478.944683]  ? __do_sys_newfstatat+0x58/0x90
[42478.947056]  ? restore_fpregs_from_fpstate+0x3c/0xa0
[42478.949452]  ? switch_fpu_return+0x5d/0xe0
[42478.951847]  ? do_syscall_64+0x25a/0x550
[42478.954242]  ? irqentry_exit+0x48/0x730
[42478.956637]  ? do_syscall_64+0x35/0x550
[42478.959018]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[42478.961444] RIP: 0033:0x7f52a55a210a
[42478.963761] RSP: 002b:00007ffe865e4348 EFLAGS: 00000202 ORIG_RAX: 0000000000000106
[42478.966064] RAX: ffffffffffffffda RBX: 0000000000000171 RCX: 00007f52a55a210a
[42478.968414] RDX: 00007ffe865e4350 RSI: 00007ffe865e4420 RDI: 00000000ffffff9c
[42478.970801] RBP: 00007ffe865e4420 R08: 00007f52a4e8d000 R09: 0000000000000200
[42478.973198] R10: 0000000000000100 R11: 0000000000000202 R12: 00007ffe865e5520
[42478.975615] R13: 00007f52a4f05028 R14: 00007ffe865e4420 R15: 00007f52a4221028
[42478.978054]  </TASK>
[42478.980476] task:kworker/u526:8  state:D stack:0     pid:1126028 tgid:1126028 ppid:2      task_flags:0x4248060 flags:0x00080000
[42478.985720] Workqueue: xfs-cil/dm-44 xlog_cil_push_work [xfs]
[42478.988507] Call Trace:
[42478.991205]  <TASK>
[42478.993876]  __schedule+0x581/0x10b0
[42478.996549]  schedule+0x28/0xa0
[42478.999182]  xlog_wait_on_iclog+0x159/0x190 [xfs]
[42479.001885]  ? __pfx_default_wake_function+0x10/0x10
[42479.004575]  xlog_cil_push_work+0x904/0x9b0 [xfs]
[42479.007312]  process_one_work+0x1ca/0x3c0
[42479.010011]  worker_thread+0x1ac/0x320
[42479.012720]  ? __pfx_worker_thread+0x10/0x10
[42479.015441]  kthread+0xe5/0x120
[42479.018150]  ? __pfx_kthread+0x10/0x10
[42479.020875]  ret_from_fork+0x2b7/0x340
[42479.023595]  ? __pfx_kthread+0x10/0x10
[42479.026312]  ret_from_fork_asm+0x1a/0x30
[42479.029040]  </TASK>
[42479.031742] task:kworker/112:2   state:D stack:0     pid:1126700 tgid:1126700 ppid:2      task_flags:0x4248060 flags:0x00080000
[42479.037523] Workqueue: xfs-conv/dm-23 xfs_end_io [xfs]
[42479.040546] Call Trace:
[42479.043498]  <TASK>
[42479.046411]  __schedule+0x581/0x10b0
[42479.049356]  schedule+0x28/0xa0
[42479.052286]  schedule_timeout+0xbd/0x100
[42479.055228]  __down_common+0x17c/0x340
[42479.058171]  down+0x52/0x70
[42479.061091]  xfs_buf_lock+0x32/0xd0 [xfs]
[42479.064102]  xfs_buf_find_lock+0x51/0x100 [xfs]
[42479.067096]  xfs_buf_read_map+0x94/0x2b0 [xfs]
[42479.070086]  ? xfs_btree_read_buf_block+0xa0/0x120 [xfs]
[42479.073153]  xfs_trans_read_buf_map+0x12d/0x270 [xfs]
[42479.076209]  ? xfs_btree_read_buf_block+0xa0/0x120 [xfs]
[42479.079277]  xfs_btree_read_buf_block+0xa0/0x120 [xfs]
[42479.082340]  xfs_btree_lookup_get_block+0xa3/0x1f0 [xfs]
[42479.085427]  xfs_btree_lookup+0xf2/0x550 [xfs]
[42479.088510]  ? cpu_util+0x90/0x150
[42479.091532]  xfs_bmap_add_extent_unwritten_real+0x8e5/0x1340 [xfs]
[42479.094649]  xfs_bmapi_convert_unwritten+0xc8/0x1b0 [xfs]
[42479.097724]  xfs_bmapi_write+0x2e8/0x5e0 [xfs]
[42479.100755]  xfs_iomap_write_unwritten+0x1e9/0x350 [xfs]
[42479.103816]  xfs_end_io+0x329/0x3c0 [xfs]
[42479.106847]  process_one_work+0x1ca/0x3c0
[42479.109815]  worker_thread+0x1ac/0x320
[42479.112761]  ? __pfx_worker_thread+0x10/0x10
[42479.115676]  kthread+0xe5/0x120
[42479.118476]  ? __pfx_kthread+0x10/0x10
[42479.121182]  ret_from_fork+0x2b7/0x340
[42479.123842]  ? __pfx_kthread+0x10/0x10
[42479.126458]  ret_from_fork_asm+0x1a/0x30
[42479.129106]  </TASK>
[42479.131746] task:kworker/u525:0  state:D stack:0     pid:1126970 tgid:1126970 ppid:2      task_flags:0x4208060 flags:0x00080000
[42479.137396] Workqueue: writeback wb_workfn (flush-253:30)
[42479.140288] Call Trace:
[42479.143129]  <TASK>
[42479.145938]  __schedule+0x581/0x10b0
[42479.148770]  schedule+0x28/0xa0
[42479.151583]  schedule_preempt_disabled+0x16/0x30
[42479.154407]  rwsem_down_read_slowpath+0x2c9/0x590
[42479.157252]  down_read+0x49/0xa0
[42479.160086]  xfs_writeback_range+0xf3/0x470 [xfs]
[42479.163019]  iomap_writeback_folio+0x28f/0x6e0
[42479.165908]  iomap_writepages+0x5e/0xd0
[42479.168778]  xfs_vm_writepages+0x93/0x110 [xfs]
[42479.171601]  do_writepages+0xca/0x170
[42479.174272]  __writeback_single_inode+0x42/0x350
[42479.176943]  writeback_sb_inodes+0x23d/0x560
[42479.179597]  __writeback_inodes_wb+0x4c/0xf0
[42479.182269]  wb_writeback+0x1ac/0x310
[42479.184952]  ? sched_clock+0x11/0x30
[42479.187633]  wb_workfn+0x392/0x470
[42479.190307]  process_one_work+0x1ca/0x3c0
[42479.193000]  worker_thread+0x1ac/0x320
[42479.195693]  ? __pfx_worker_thread+0x10/0x10
[42479.198391]  kthread+0xe5/0x120
[42479.201092]  ? __pfx_kthread+0x10/0x10
[42479.203802]  ret_from_fork+0x2b7/0x340
[42479.206485]  ? __pfx_kthread+0x10/0x10
[42479.209148]  ret_from_fork_asm+0x1a/0x30
[42479.211789]  </TASK>
[42479.214386] task:kworker/53:2    state:D stack:0     pid:1127025 tgid:1127025 ppid:2      task_flags:0x4248060 flags:0x00080000
[42479.219948] Workqueue: xfs-conv/dm-23 xfs_end_io [xfs]
[42479.222850] Call Trace:
[42479.225646]  <TASK>
[42479.228389]  __schedule+0x581/0x10b0
[42479.231141]  schedule+0x28/0xa0
[42479.233878]  schedule_timeout+0xbd/0x100
[42479.236598]  __down_common+0x17c/0x340
[42479.239321]  down+0x52/0x70
[42479.242023]  xfs_buf_lock+0x32/0xd0 [xfs]
[42479.244789]  xfs_buf_find_lock+0x51/0x100 [xfs]
[42479.247544]  xfs_buf_read_map+0x94/0x2b0 [xfs]
[42479.250281]  ? xfs_btree_read_buf_block+0xa0/0x120 [xfs]
[42479.253102]  xfs_trans_read_buf_map+0x12d/0x270 [xfs]
[42479.255940]  ? xfs_btree_read_buf_block+0xa0/0x120 [xfs]
[42479.258794]  xfs_btree_read_buf_block+0xa0/0x120 [xfs]
[42479.261662]  xfs_btree_lookup_get_block+0xa3/0x1f0 [xfs]
[42479.264447]  xfs_btree_lookup+0xf2/0x550 [xfs]
[42479.267095]  xfs_bmap_add_extent_unwritten_real+0x739/0x1340 [xfs]
[42479.269779]  xfs_bmapi_convert_unwritten+0xc8/0x1b0 [xfs]
[42479.272447]  xfs_bmapi_write+0x2e8/0x5e0 [xfs]
[42479.275115]  xfs_iomap_write_unwritten+0x1e9/0x350 [xfs]
[42479.277844]  xfs_end_io+0x329/0x3c0 [xfs]
[42479.280555]  process_one_work+0x1ca/0x3c0
[42479.283210]  worker_thread+0x1ac/0x320
[42479.285862]  ? __pfx_worker_thread+0x10/0x10
[42479.288517]  kthread+0xe5/0x120
[42479.291138]  ? __pfx_kthread+0x10/0x10
[42479.293766]  ret_from_fork+0x2b7/0x340
[42479.296400]  ? __pfx_kthread+0x10/0x10
[42479.299009]  ret_from_fork_asm+0x1a/0x30
[42479.301619]  </TASK>
[42479.304209] task:kworker/118:2   state:D stack:0     pid:1127968 tgid:1127968 ppid:2      task_flags:0x4248060 flags:0x00080000
[42479.309737] Workqueue: xfs-conv/dm-39 xfs_end_io [xfs]
[42479.312612] Call Trace:
[42479.315434]  <TASK>
[42479.318224]  __schedule+0x581/0x10b0
[42479.321041]  schedule+0x28/0xa0
[42479.323844]  schedule_timeout+0xbd/0x100
[42479.326634]  __down_common+0x17c/0x340
[42479.329420]  down+0x52/0x70
[42479.332193]  xfs_buf_lock+0x32/0xd0 [xfs]
[42479.335035]  xfs_buf_find_lock+0x51/0x100 [xfs]
[42479.337875]  xfs_buf_read_map+0x94/0x2b0 [xfs]
[42479.340709]  ? xfs_btree_read_buf_block+0xa0/0x120 [xfs]
[42479.343602]  ? xfs_trans_add_item+0x37/0xb0 [xfs]
[42479.346396]  xfs_trans_read_buf_map+0x12d/0x270 [xfs]
[42479.349097]  ? xfs_btree_read_buf_block+0xa0/0x120 [xfs]
[42479.351802]  xfs_btree_read_buf_block+0xa0/0x120 [xfs]
[42479.354484]  xfs_btree_lookup_get_block+0xa3/0x1f0 [xfs]
[42479.357200]  xfs_btree_lookup+0xf2/0x550 [xfs]
[42479.359901]  xfs_rmap_lookup_le+0x56/0xc0 [xfs]
[42479.362646]  xfs_rmap_convert+0xaf/0x1460 [xfs]
[42479.365372]  xfs_rmap_finish_one+0x115/0x220 [xfs]
[42479.368100]  ? kmem_cache_alloc_noprof+0x2f6/0x420
[42479.370790]  xfs_rmap_update_finish_item+0x19/0x30 [xfs]
[42479.373571]  xfs_defer_finish_one+0x101/0x290 [xfs]
[42479.376367]  xfs_defer_finish_noroll+0x1be/0x500 [xfs]
[42479.379142]  xfs_trans_commit+0x4f/0x70 [xfs]
[42479.381913]  xfs_iomap_write_unwritten+0x140/0x350 [xfs]
[42479.384701]  xfs_end_io+0x329/0x3c0 [xfs]
[42479.387445]  process_one_work+0x1ca/0x3c0
[42479.390114]  worker_thread+0x1ac/0x320
[42479.392776]  ? __pfx_worker_thread+0x10/0x10
[42479.395460]  kthread+0xe5/0x120
[42479.398089]  ? __pfx_kthread+0x10/0x10
[42479.400708]  ret_from_fork+0x2b7/0x340
[42479.403321]  ? __pfx_kthread+0x10/0x10
[42479.405912]  ret_from_fork_asm+0x1a/0x30
[42479.408495]  </TASK>
[42479.411060] task:/usr/sbin/apach state:D stack:0     pid:1129855 tgid:1129855 ppid:15065  task_flags:0x440140 flags:0x00080000
[42479.416601] Call Trace:
[42479.419367]  <TASK>
[42479.422098]  __schedule+0x581/0x10b0
[42479.424865]  schedule+0x28/0xa0
[42479.427618]  schedule_timeout+0xbd/0x100
[42479.430370]  __down_common+0x17c/0x340
[42479.433126]  ? __skb_datagram_iter+0x19c/0x2e0
[42479.435812]  down+0x52/0x70
[42479.438363]  xfs_buf_lock+0x32/0xd0 [xfs]
[42479.440972]  xfs_buf_find_lock+0x51/0x100 [xfs]
[42479.443537]  xfs_buf_read_map+0x94/0x2b0 [xfs]
[42479.446105]  ? xfs_read_icluster+0x7f/0xd0 [xfs]
[42479.448727]  xfs_trans_read_buf_map+0x12d/0x270 [xfs]
[42479.451382]  ? xfs_read_icluster+0x7f/0xd0 [xfs]
[42479.454042]  xfs_read_icluster+0x7f/0xd0 [xfs]
[42479.456706]  xfs_inode_item_precommit+0x22f/0x2d0 [xfs]
[42479.459419]  __xfs_trans_commit+0xb9/0x300 [xfs]
[42479.462120]  xfs_trans_commit+0x38/0x70 [xfs]
[42479.464829]  xfs_vn_update_time+0x187/0x1b0 [xfs]
[42479.467573]  file_update_time_flags+0x7e/0x130
[42479.470250]  xfs_file_write_checks+0x183/0x2c0 [xfs]
[42479.472986]  xfs_file_buffered_write+0x60/0x2d0 [xfs]
[42479.475705]  ? security_file_permission+0x55/0x100
[42479.478372]  vfs_write+0x25c/0x450
[42479.481016]  ksys_write+0x6b/0xe0
[42479.483638]  do_syscall_64+0xc0/0x550
[42479.486252]  ? lock_vma_under_rcu+0x92/0x160
[42479.488882]  ? count_memcg_events+0xb4/0x160
[42479.491517]  ? __task_pid_nr_ns+0x5c/0xf0
[42479.494140]  ? __do_sys_gettid+0x1a/0x30
[42479.496753]  ? do_syscall_64+0xf9/0x550
[42479.499347]  ? do_user_addr_fault+0x202/0x690
[42479.501927]  ? irqentry_exit+0x48/0x730
[42479.504509]  ? do_syscall_64+0x35/0x550
[42479.507061]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[42479.509638] RIP: 0033:0x7f52a55313a7
[42479.512198] RSP: 002b:00007ffe865df2e0 EFLAGS: 00000202 ORIG_RAX: 0000000000000001
[42479.514863] RAX: ffffffffffffffda RBX: 00007f52a542ac00 RCX: 00007f52a55313a7
[42479.517578] RDX: 0000000000000099 RSI: 00007ffe865df4b0 RDI: 000000000000000e
[42479.520307] RBP: 00007f52a5408818 R08: 0000000000000000 R09: 0000000000000000
[42479.523025] R10: 0000000000000000 R11: 0000000000000202 R12: 00007ffe865df4b0
[42479.525756] R13: 0000000000000000 R14: 0000000000000000 R15: 00007ffe865df4b0
[42479.528462]  </TASK>
[42479.531143] task:/usr/sbin/apach state:D stack:0     pid:1129856 tgid:1129856 ppid:15065  task_flags:0x400140 flags:0x00080000
[42479.536942] Call Trace:
[42479.539740]  <TASK>
[42479.542386]  __schedule+0x581/0x10b0
[42479.545069]  schedule+0x28/0xa0
[42479.547757]  schedule_preempt_disabled+0x16/0x30
[42479.550470]  __mutex_lock.constprop.0+0x57c/0xa40
[42479.553207]  ? __task_pid_nr_ns+0x5c/0xf0
[42479.555954]  fdget_pos+0x85/0x120
[42479.558685]  ksys_write+0x2b/0xe0
[42479.561398]  do_syscall_64+0xc0/0x550
[42479.564107]  ? __handle_mm_fault+0xbb9/0x1170
[42479.566825]  ? lock_vma_under_rcu+0x92/0x160
[42479.569551]  ? count_memcg_events+0xb4/0x160
[42479.572270]  ? handle_mm_fault+0x1aa/0x300
[42479.574970]  ? do_user_addr_fault+0x202/0x690
[42479.577665]  ? irqentry_exit+0x48/0x730
[42479.580334]  ? do_syscall_64+0x35/0x550
[42479.582974]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[42479.585645] RIP: 0033:0x7f52a55313a7
[42479.588293] RSP: 002b:00007ffe865df2e0 EFLAGS: 00000202 ORIG_RAX: 0000000000000001
[42479.591026] RAX: ffffffffffffffda RBX: 00007f52a542ac00 RCX: 00007f52a55313a7
[42479.593806] RDX: 00000000000000d1 RSI: 00007ffe865df4b0 RDI: 0000000000000009
[42479.596592] RBP: 00007f52a5408300 R08: 0000000000000000 R09: 0000000000000000
[42479.599369] R10: 0000000000000000 R11: 0000000000000202 R12: 00007ffe865df4b0
[42479.602137] R13: 0000000000000000 R14: 0000000000000000 R15: 00007ffe865df4b0
[42479.604872]  </TASK>
[42479.607567] task:/usr/sbin/apach state:D stack:0     pid:1129874 tgid:1129874 ppid:15065  task_flags:0x400140 flags:0x00080000
[42479.613406] Call Trace:
[42479.616327]  <TASK>
[42479.619227]  __schedule+0x581/0x10b0
[42479.622143]  schedule+0x28/0xa0
[42479.625054]  schedule_timeout+0xbd/0x100
[42479.627973]  __down_common+0x17c/0x340
[42479.630882]  ? xfs_trans_read_buf_map+0xb0/0x270 [xfs]
[42479.633889]  down+0x52/0x70
[42479.636832]  xfs_buf_lock+0x32/0xd0 [xfs]
[42479.639837]  xfs_buf_find_lock+0x51/0x100 [xfs]
[42479.642788]  xfs_buf_read_map+0x94/0x2b0 [xfs]
[42479.645692]  ? xfs_read_icluster+0x7f/0xd0 [xfs]
[42479.648600]  xfs_trans_read_buf_map+0x12d/0x270 [xfs]
[42479.651493]  ? xfs_read_icluster+0x7f/0xd0 [xfs]
[42479.654387]  xfs_read_icluster+0x7f/0xd0 [xfs]
[42479.657278]  xfs_iget+0x350/0xa80 [xfs]
[42479.660212]  xfs_lookup+0x126/0x1b0 [xfs]
[42479.663080]  xfs_vn_lookup+0x92/0xc0 [xfs]
[42479.665840]  __lookup_slow+0x5b/0x100
[42479.668433]  lookup_slow+0x35/0x50
[42479.671016]  path_lookupat+0x18f/0x2a0
[42479.673636]  filename_lookup+0x103/0x210
[42479.676261]  vfs_statx+0x80/0x160
[42479.678872]  vfs_fstatat+0x4a/0x90
[42479.681474]  __do_sys_newfstatat+0x49/0x90
[42479.684080]  do_syscall_64+0xc0/0x550
[42479.686665]  ? cp_new_stat+0x132/0x170
[42479.689249]  ? __do_sys_newfstatat+0x58/0x90
[42479.691857]  ? do_syscall_64+0xf9/0x550
[42479.694457]  ? do_syscall_64+0x35/0x550
[42479.697022]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[42479.699625] RIP: 0033:0x7f52a55a210a
[42479.702227] RSP: 002b:00007ffe865e4348 EFLAGS: 00000202 ORIG_RAX: 0000000000000106
[42479.704943] RAX: ffffffffffffffda RBX: 0000000000000171 RCX: 00007f52a55a210a
[42479.707694] RDX: 00007ffe865e4350 RSI: 00007ffe865e4420 RDI: 00000000ffffff9c
[42479.710460] RBP: 00007ffe865e4420 R08: 00007f52a4e97000 R09: 0000000000000200
[42479.713245] R10: 0000000000000100 R11: 0000000000000202 R12: 00007ffe865e5520
[42479.716027] R13: 00007f52a4f01028 R14: 00007ffe865e4420 R15: 00007f52a4221028
[42479.718799]  </TASK>
[42479.721532] task:diskstat_iops_s state:D stack:0     pid:1130782 tgid:1130782 ppid:1      task_flags:0x440100 flags:0x00080802
[42479.727236] Call Trace:
[42479.730073]  <TASK>
[42479.732880]  __schedule+0x581/0x10b0
[42479.735733]  schedule+0x28/0xa0
[42479.738518]  schedule_timeout+0xbd/0x100
[42479.741209]  __down_common+0x17c/0x340
[42479.743783]  down+0x52/0x70
[42479.746340]  xfs_buf_lock+0x32/0xd0 [xfs]
[42479.748992]  xfs_buf_find_lock+0x51/0x100 [xfs]
[42479.751630]  xfs_buf_read_map+0x94/0x2b0 [xfs]
[42479.754267]  ? xfs_read_agi+0xa2/0x170 [xfs]
[42479.756957]  xfs_trans_read_buf_map+0x12d/0x270 [xfs]
[42479.759668]  ? xfs_read_agi+0xa2/0x170 [xfs]
[42479.762352]  xfs_read_agi+0xa2/0x170 [xfs]
[42479.765019]  ? xas_load+0xd/0xc0
[42479.767643]  xfs_ialloc_read_agi+0x4e/0x120 [xfs]
[42479.770332]  xfs_dialloc+0x1e1/0x8a0 [xfs]
[42479.773022]  ? xfs_trans_alloc+0x125/0x340 [xfs]
[42479.775739]  ? xfs_trans_alloc_icreate+0xa2/0x140 [xfs]
[42479.778424]  xfs_create+0x297/0x460 [xfs]
[42479.781106]  xfs_generic_create+0x305/0x3a0 [xfs]
[42479.783789]  ? d_splice_alias_ops+0x182/0x5f0
[42479.786432]  lookup_open+0x58a/0x870
[42479.789076]  path_openat+0x4cd/0xa00
[42479.791711]  do_file_open+0xf1/0x1a0
[42479.794335]  ? alloc_fd+0x113/0x180
[42479.796966]  do_sys_openat2+0x80/0xe0
[42479.799592]  __x64_sys_openat+0x54/0xa0
[42479.802240]  do_syscall_64+0xc0/0x550
[42479.804868]  ? do_syscall_64+0xf9/0x550
[42479.807508]  ? do_syscall_64+0xf9/0x550
[42479.810127]  ? ksys_read+0x6b/0xe0
[42479.812714]  ? do_syscall_64+0xf9/0x550
[42479.815311]  ? ksys_lseek+0x3f/0xb0
[42479.817886]  ? do_syscall_64+0xf9/0x550
[42479.820468]  ? do_syscall_64+0xf9/0x550
[42479.823042]  ? irqentry_exit+0x48/0x730
[42479.825589]  ? do_syscall_64+0x35/0x550
[42479.828109]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[42479.830610] RIP: 0033:0x7fe7385623a7
[42479.833077] RSP: 002b:00007ffdb5173d30 EFLAGS: 00000202 ORIG_RAX: 0000000000000101
[42479.835629] RAX: ffffffffffffffda RBX: 00007fe738496240 RCX: 00007fe7385623a7
[42479.838211] RDX: 00000000000a00c2 RSI: 000055b4d2a97440 RDI: ffffffffffffff9c
[42479.840808] RBP: 000055b4d25de2a0 R08: 0000000000000000 R09: 0000000000000000
[42479.843417] R10: 0000000000000180 R11: 0000000000000202 R12: 0000000000000000
[42479.845964] R13: 0000000000000000 R14: 000055b4d2a97440 R15: 000055b4d25fdc20
[42479.848420]  </TASK>
[42479.850734] task:/usr/sbin/apach state:D stack:0     pid:1130833 tgid:1130833 ppid:15065  task_flags:0x440140 flags:0x00080000
[42479.855836] Call Trace:
[42479.858396]  <TASK>
[42479.860942]  __schedule+0x581/0x10b0
[42479.863518]  schedule+0x28/0xa0
[42479.866073]  schedule_timeout+0xbd/0x100
[42479.868636]  __down_common+0x17c/0x340
[42479.871193]  down+0x52/0x70
[42479.873748]  xfs_buf_lock+0x32/0xd0 [xfs]
[42479.876380]  xfs_buf_find_lock+0x51/0x100 [xfs]
[42479.878974]  xfs_buf_read_map+0x94/0x2b0 [xfs]
[42479.881553]  ? xfs_read_icluster+0x7f/0xd0 [xfs]
[42479.884155]  xfs_trans_read_buf_map+0x12d/0x270 [xfs]
[42479.886762]  ? xfs_read_icluster+0x7f/0xd0 [xfs]
[42479.889377]  xfs_read_icluster+0x7f/0xd0 [xfs]
[42479.891986]  xfs_inode_item_precommit+0x22f/0x2d0 [xfs]
[42479.894613]  __xfs_trans_commit+0xb9/0x300 [xfs]
[42479.897249]  xfs_trans_commit+0x38/0x70 [xfs]
[42479.899887]  xfs_vn_update_time+0x187/0x1b0 [xfs]
[42479.902523]  file_update_time_flags+0x7e/0x130
[42479.905124]  xfs_file_write_checks+0x183/0x2c0 [xfs]
[42479.907773]  xfs_file_buffered_write+0x60/0x2d0 [xfs]
[42479.910403]  ? security_file_permission+0x55/0x100
[42479.913031]  vfs_write+0x25c/0x450
[42479.915661]  ksys_write+0x6b/0xe0
[42479.918276]  do_syscall_64+0xc0/0x550
[42479.920898]  ? __task_pid_nr_ns+0x5c/0xf0
[42479.923528]  ? __do_sys_getpid+0x1d/0x30
[42479.926143]  ? do_syscall_64+0xf9/0x550
[42479.928765]  ? do_syscall_64+0xf9/0x550
[42479.931383]  ? __do_sys_newfstatat+0x58/0x90
[42479.934012]  ? __task_pid_nr_ns+0x5c/0xf0
[42479.936651]  ? __do_sys_gettid+0x1a/0x30
[42479.939288]  ? do_syscall_64+0xf9/0x550
[42479.941921]  ? __memcg_slab_free_hook+0x159/0x1b0
[42479.944616]  ? __x64_sys_close+0x3d/0x80
[42479.947320]  ? kmem_cache_free+0x253/0x3c0
[42479.950029]  ? __x64_sys_close+0x3d/0x80
[42479.952716]  ? do_syscall_64+0xf9/0x550
[42479.955382]  ? do_syscall_64+0x35/0x550
[42479.957963]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[42479.960540] RIP: 0033:0x7f52a55313a7
[42479.963080] RSP: 002b:00007ffe865df2e0 EFLAGS: 00000202 ORIG_RAX: 0000000000000001
[42479.965706] RAX: ffffffffffffffda RBX: 00007f52a542ac00 RCX: 00007f52a55313a7
[42479.968384] RDX: 00000000000000d7 RSI: 00007ffe865df4b0 RDI: 0000000000000009
[42479.971070] RBP: 00007f52a5408300 R08: 0000000000000000 R09: 0000000000000000
[42479.973721] R10: 0000000000000000 R11: 0000000000000202 R12: 00007ffe865df4b0
[42479.976272] R13: 0000000000000000 R14: 0000000000000000 R15: 00007ffe865df4b0
[42479.978671]  </TASK>
[42479.981063] task:kworker/53:3    state:D stack:0     pid:1131053 tgid:1131053 ppid:2      task_flags:0x4248060 flags:0x00080000
[42479.986284] Workqueue: xfs-conv/dm-23 xfs_end_io [xfs]
[42479.989028] Call Trace:
[42479.991711]  <TASK>
[42479.994361]  __schedule+0x581/0x10b0
[42479.997038]  schedule+0x28/0xa0
[42479.999698]  schedule_timeout+0xbd/0x100
[42480.002360]  __down_common+0x17c/0x340
[42480.005035]  down+0x52/0x70
[42480.007681]  xfs_buf_lock+0x32/0xd0 [xfs]
[42480.010366]  xfs_buf_find_lock+0x51/0x100 [xfs]
[42480.013029]  xfs_buf_read_map+0x94/0x2b0 [xfs]
[42480.015675]  ? xfs_btree_read_buf_block+0xa0/0x120 [xfs]
[42480.018370]  ? xfs_trans_add_item+0x37/0xb0 [xfs]
[42480.021040]  xfs_trans_read_buf_map+0x12d/0x270 [xfs]
[42480.023710]  ? xfs_btree_read_buf_block+0xa0/0x120 [xfs]
[42480.026400]  xfs_btree_read_buf_block+0xa0/0x120 [xfs]
[42480.029085]  xfs_btree_lookup_get_block+0xa3/0x1f0 [xfs]
[42480.031769]  xfs_btree_lookup+0xf2/0x550 [xfs]
[42480.034424]  ? xfs_btree_update+0x60/0xa0 [xfs]
[42480.037082]  xfs_bmap_add_extent_unwritten_real+0x4cf/0x1340 [xfs]
[42480.039802]  xfs_bmapi_convert_unwritten+0xc8/0x1b0 [xfs]
[42480.042528]  xfs_bmapi_write+0x2e8/0x5e0 [xfs]
[42480.045255]  xfs_iomap_write_unwritten+0x1e9/0x350 [xfs]
[42480.048028]  xfs_end_io+0x329/0x3c0 [xfs]
[42480.050781]  process_one_work+0x1ca/0x3c0
[42480.053502]  worker_thread+0x1ac/0x320
[42480.056254]  ? __pfx_worker_thread+0x10/0x10
[42480.059009]  kthread+0xe5/0x120
[42480.061762]  ? __pfx_kthread+0x10/0x10
[42480.064527]  ret_from_fork+0x2b7/0x340
[42480.067290]  ? __pfx_kthread+0x10/0x10
[42480.070033]  ret_from_fork_asm+0x1a/0x30
[42480.072775]  </TASK>
[42480.075505] task:(sh)            state:D stack:0     pid:1131497 tgid:1131497 ppid:1      task_flags:0x400100 flags:0x00080000
[42480.081320] Call Trace:
[42480.084252]  <TASK>
[42480.087132]  __schedule+0x581/0x10b0
[42480.090019]  schedule+0x28/0xa0
[42480.092849]  schedule_timeout+0xbd/0x100
[42480.095627]  __wait_for_common+0x97/0x1c0
[42480.098384]  ? __pfx_schedule_timeout+0x10/0x10
[42480.101159]  synchronize_rcu_normal+0xe8/0x100
[42480.103941]  ? mntput+0x21/0x60
[42480.106735]  rcu_sync_enter+0x58/0x140
[42480.109498]  ? _kstrtoull+0x40/0xa0
[42480.112160]  percpu_down_write+0x1f/0x180
[42480.114712]  cgroup_procs_write_start+0x1fe/0x270
[42480.117264]  __cgroup_procs_write+0x62/0x1d0
[42480.119798]  ? __kmalloc_noprof+0x286/0x520
[42480.122351]  cgroup_procs_write+0x17/0x30
[42480.124913]  kernfs_fop_write_iter+0x14a/0x200
[42480.127493]  vfs_write+0x25c/0x450
[42480.130071]  ksys_write+0x6b/0xe0
[42480.132638]  do_syscall_64+0xc0/0x550
[42480.135199]  ? do_syscall_64+0xf9/0x550
[42480.137767]  ? filemap_map_pages+0x50b/0x790
[42480.140354]  ? do_fault+0x3da/0x620
[42480.142928]  ? __x64_sys_fcntl+0x80/0x110
[42480.145494]  ? do_syscall_64+0xf9/0x550
[42480.148046]  ? lock_vma_under_rcu+0x92/0x160
[42480.150586]  ? count_memcg_events+0xb4/0x160
[42480.153101]  ? handle_mm_fault+0x1aa/0x300
[42480.155591]  ? do_user_addr_fault+0x202/0x690
[42480.158073]  ? irqentry_exit+0x48/0x730
[42480.160555]  ? do_syscall_64+0x35/0x550
[42480.163007]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[42480.165468] RIP: 0033:0x7f2552c9b3a7
[42480.167904] RSP: 002b:00007ffdf9082a90 EFLAGS: 00000202 ORIG_RAX: 0000000000000001
[42480.170432] RAX: ffffffffffffffda RBX: 00007f255365c600 RCX: 00007f2552c9b3a7
[42480.172999] RDX: 0000000000000008 RSI: 00007ffdf9082cca RDI: 0000000000000003
[42480.175573] RBP: 00007ffdf9082cca R08: 0000000000000000 R09: 0000000000000000
[42480.178150] R10: 0000000000000000 R11: 0000000000000202 R12: 0000000000000008
[42480.180728] R13: 000055e1b771b2a0 R14: 00007f2552defee0 R15: 00000000fffffff7
[42480.183310]  </TASK>
[42480.185851] task:(sh)            state:D stack:0     pid:1131498 tgid:1131498 ppid:1      task_flags:0x400100 flags:0x00080000
[42480.191313] Call Trace:
[42480.194038]  <TASK>
[42480.196745]  __schedule+0x581/0x10b0
[42480.199468]  schedule+0x28/0xa0
[42480.202092]  schedule_preempt_disabled+0x16/0x30
[42480.204655]  __mutex_lock.constprop.0+0x57c/0xa40
[42480.207229]  cgroup_kn_lock_live+0x47/0x110
[42480.209844]  __cgroup_procs_write+0x3f/0x1d0
[42480.212458]  ? __kmalloc_noprof+0x286/0x520
[42480.215076]  cgroup_procs_write+0x17/0x30
[42480.217711]  kernfs_fop_write_iter+0x14a/0x200
[42480.220352]  vfs_write+0x25c/0x450
[42480.222975]  ksys_write+0x6b/0xe0
[42480.225579]  do_syscall_64+0xc0/0x550
[42480.228174]  ? __x64_sys_fcntl+0x80/0x110
[42480.230769]  ? handle_mm_fault+0x1aa/0x300
[42480.233371]  ? do_syscall_64+0xf9/0x550
[42480.235970]  ? do_user_addr_fault+0x202/0x690
[42480.238557]  ? irqentry_exit+0x48/0x730
[42480.241134]  ? do_syscall_64+0x35/0x550
[42480.243694]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[42480.246285] RIP: 0033:0x7fc467e9b3a7
[42480.248868] RSP: 002b:00007fff698e7c80 EFLAGS: 00000202 ORIG_RAX: 0000000000000001
[42480.251547] RAX: ffffffffffffffda RBX: 00007fc46885c600 RCX: 00007fc467e9b3a7
[42480.254275] RDX: 0000000000000008 RSI: 00007fff698e7eba RDI: 0000000000000003
[42480.257038] RBP: 00007fff698e7eba R08: 0000000000000000 R09: 0000000000000000
[42480.259803] R10: 0000000000000000 R11: 0000000000000202 R12: 0000000000000008
[42480.262555] R13: 00005604fe0782a0 R14: 00007fc467fefee0 R15: 00000000fffffff7
[42480.265320]  </TASK>
[42480.268179] sysrq: Show backtrace of all active CPUs
[42480.270971] NMI backtrace for cpu 43
[42480.270975] CPU: 43 UID: 0 PID: 1079724 Comm: bash Not tainted 7.3.6 #1 PREEMPT(lazy) 
[42480.270977] Hardware name:  TURIN2D16-2T/TURIN2D16-2T, BIOS 10.06 10/22/2025
[42480.270978] Call Trace:
[42480.270980]  <TASK>
[42480.270980]  dump_stack_lvl+0x4e/0x70
[42480.270984]  nmi_cpu_backtrace.cold+0x19/0x63
[42480.270985]  ? __pfx_nmi_raise_cpu_backtrace+0x10/0x10
[42480.270989]  nmi_trigger_cpumask_backtrace+0x10c/0x130
[42480.270992]  __handle_sysrq.cold+0x97/0xdc
[42480.270996]  write_sysrq_trigger+0x58/0x80
[42480.271001]  proc_reg_write+0x5a/0xa0
[42480.271003]  vfs_write+0xcf/0x450
[42480.271005]  ? __x64_sys_fcntl+0x80/0x110
[42480.271006]  ksys_write+0x6b/0xe0
[42480.271008]  do_syscall_64+0xc0/0x550
[42480.271009]  ? locks_remove_posix+0x3f/0x1a0
[42480.271013]  ? filp_flush+0x59/0x80
[42480.271016]  ? filp_close+0x1d/0x30
[42480.271017]  ? do_dup2+0xb4/0x140
[42480.271018]  ? ksys_dup3+0x63/0xf0
[42480.271020]  ? __x64_sys_dup2+0x2b/0xc0
[42480.271021]  ? do_syscall_64+0xf9/0x550
[42480.271022]  ? irqentry_exit+0x48/0x730
[42480.271023]  ? do_syscall_64+0x35/0x550
[42480.271024]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[42480.271025] RIP: 0033:0x7f84337173a7
[42480.271026] Code: 48 89 fa 4c 89 df e8 78 b3 00 00 8b 93 08 03 00 00 59 5e 48 83 f8 fc 74 1a 5b c3 0f 1f 84 00 00 00 00 00 48 8b 44 24 10 0f 05 <5b> c3 0f 1f 80 00 00 00 00 83 e2 39 83 fa 08 75 de e8 23 ff ff ff
[42480.271027] RSP: 002b:00007ffebc883b80 EFLAGS: 00000202 ORIG_RAX: 0000000000000001
[42480.271028] RAX: ffffffffffffffda RBX: 00007f8433686bc0 RCX: 00007f84337173a7
[42480.271028] RDX: 0000000000000002 RSI: 0000557c63b19ab0 RDI: 0000000000000001
[42480.271029] RBP: 0000557c63b19ab0 R08: 0000000000000000 R09: 0000000000000000
[42480.271029] R10: 0000000000000000 R11: 0000000000000202 R12: 0000000000000002
[42480.271029] R13: 00007f843386e5c0 R14: 00007f843386bee0 R15: 0000000000000000
[42480.271030]  </TASK>
[42480.271031] Sending NMI from CPU 43 to CPUs 0-42,44-127:
[42480.324162] NMI backtrace for cpu 105
[42480.324165] CPU: 105 UID: 1000 PID: 1131397 Comm: expand Not tainted 7.3.6 #1 PREEMPT(lazy) 
[42480.324168] Hardware name:  TURIN2D16-2T/TURIN2D16-2T, BIOS 10.06 10/22/2025
[42480.324168] RIP: 0033:0x56546757719b
[42480.324170] Code: 48 89 bc 24 80 00 00 00 20 c8 48 8b 0d 4e 9f 00 00 48 bf cd cc cc cc cc cc cc cc 49 01 f1 48 8d 35 1a 85 00 00 c4 e2 eb f6 d7 <4c> 89 4c 24 50 4c 89 c7 48 c1 ea 02 0f b6 0c 11 48 89 94 24 c8 00
[42480.324171] RSP: 002b:00007f5b889dbd20 EFLAGS: 00000202
[42480.324173] RAX: 0000000000000301 RBX: 000000000000010f RCX: 00007f5b9a200000
[42480.324174] RDX: 0000000bda9e56d1 RSI: 000056546757f6b0 RDI: cccccccccccccccd
[42480.324174] RBP: 00005654675950e0 R08: 0000000ed145ec86 R09: 0000000001fa1157
[42480.324175] R10: 00000000ffffffec R11: 0000000000040000 R12: 0000000043e11180
[42480.324178] R13: 0000000000000000 R14: 00005654675810e0 R15: 0000000001fa1157
[42480.324184] FS:  00007f5b889dc6c0 GS:  0000000000000000
[42480.411506] NMI backtrace for cpu 2 skipped: idling at io_idle+0x3/0x30
[42480.411520] NMI backtrace for cpu 0 skipped: idling at io_idle+0x3/0x30
[42480.411526] NMI backtrace for cpu 64
[42480.411529] CPU: 64 UID: 1000 PID: 1131374 Comm: expand Not tainted 7.3.6 #1 PREEMPT(lazy) 
[42480.411532] Hardware name:  TURIN2D16-2T/TURIN2D16-2T, BIOS 10.06 10/22/2025
[42480.411534] RIP: 0033:0x5654675779eb
[42480.411538] Code: 48 09 ca 31 db eb 18 0f 1f 84 00 00 00 00 00 89 df ff c3 44 89 7c bc 48 c4 c2 a0 f3 cb 74 70 f3 4d 0f bc fb 31 ed 49 6b ff 70 <4c> 8d 6c 07 0c eb 18 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 48
[42480.411539] RSP: 002b:00007f5b951f4d20 EFLAGS: 00000246
[42480.411541] RAX: 000056546757e830 RBX: 0000000000000000 RCX: 4000000000002400
[42480.411542] RDX: 4000000102703670 RSI: fffffffeef8fc98f RDI: 0000000000000460
[42480.411543] RBP: 0000000000000000 R08: 0000000026000000 R09: 0000000100701270
[42480.411544] R10: 0000000102701270 R11: 0000000000002400 R12: 00000000441c0a70
[42480.411545] R13: 0000000000000002 R14: 00005654675810e0 R15: 000000000000000a
[42480.411546] FS:  00007f5b951f56c0 GS:  0000000000000000
[42480.411548] NMI backtrace for cpu 65
[42480.411551] CPU: 65 UID: 1000 PID: 1131405 Comm: expand Not tainted 7.3.6 #1 PREEMPT(lazy) 
[42480.411553] Hardware name:  TURIN2D16-2T/TURIN2D16-2T, BIOS 10.06 10/22/2025
[42480.411554] RIP: 0033:0x565467577ad8
[42480.411556] Code: 8d 50 01 48 b8 ff ff ff ff ff ff ff 3f f3 49 0f bc db 48 8d 3c 02 4c 21 df 74 27 f3 4c 0f bc ff c1 e3 09 48 8d 05 e8 18 00 00 <48> 01 c3 42 8b 7c fb 04 42 8b 1c fb 83 ff 02 74 27 83 ff 01 74 66
[42480.411557] RSP: 002b:00007f5b849d3d20 EFLAGS: 00000216
[42480.411559] RAX: 00005654675793c0 RBX: 0000000000000600 RCX: 4000000000004008
[42480.411560] RDX: 4000000000004008 RSI: fffffffeef939ad7 RDI: 0000000000004000
[42480.411561] RBP: 0000000000000000 R08: 0000000000000240 R09: 00000001106c2420
[42480.411561] R10: 00000001106c2460 R11: 0000000000004008 R12: 00000000441b1290
[42480.411562] R13: 0000000000000002 R14: 00005654675810e0 R15: 000000000000000e
[42480.411563] FS:  00007f5b849d46c0 GS:  0000000000000000
[42480.411564] NMI backtrace for cpu 1
[42480.411566] CPU: 1 UID: 0 PID: 0 Comm: swapper/1 Not tainted 7.3.6 #1 PREEMPT(lazy) 
[42480.411568] Hardware name:  TURIN2D16-2T/TURIN2D16-2T, BIOS 10.06 10/22/2025
[42480.411569] RIP: 0010:llist_reverse_order+0x16/0x30
[42480.411573] Code: 00 00 66 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa 48 89 f8 48 85 ff 74 15 31 c9 eb 03 48 89 d0 48 8b 10 <48> 89 08 48 89 c1 48 85 d2 75 ef c3 cc cc cc cc 66 2e 0f 1f 84 00
[42480.411574] RSP: 0018:ff83ab31801fcf98 EFLAGS: 00000046
[42480.411575] RAX: ff31993dcf271320 RBX: ff83ab31802cfdd8 RCX: 0000000000000000
[42480.411576] RDX: 0000000000000000 RSI: 4000000000000000 RDI: ff31993dcf271320
[42480.411577] RBP: 0000000000000001 R08: 0000000000000000 R09: 0000000000000000
[42480.411577] R10: 0000000000000000 R11: ff83ab31801fcff8 R12: 0000000000000000
[42480.411578] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[42480.411578] FS:  0000000000000000(0000) GS:ff31993e2157c000(0000) knlGS:0000000000000000
[42480.411579] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[42480.411580] CR2: 00007f5e1308d406 CR3: 0000000192e6d021 CR4: 0000000000f71ef0
[42480.411581] PKRU: 55555554
[42480.411581] Call Trace:
[42480.411584]  <IRQ>
[42480.411585]  __flush_smp_call_function_queue+0x3d/0x420
[42480.411590]  __sysvec_call_function_single+0x1d/0xb0
[42480.411594]  sysvec_call_function_single+0x6c/0x90
[42480.411597]  </IRQ>
[42480.411597]  <TASK>
[42480.411597]  asm_sysvec_call_function_single+0x1a/0x20
[42480.411601] RIP: 0010:cpuidle_enter_state+0xb8/0x420
[42480.411603] Code: 93 02 00 00 e8 c9 8b 43 ff e8 54 f0 ff ff 49 89 c5 0f 1f 44 00 00 31 ff e8 95 5b 42 ff 45 84 ff 0f 85 58 01 00 00 fb 45 85 f6 <0f> 88 bc 01 00 00 48 8b 04 24 49 63 ce 4c 89 ea 48 6b f1 68 4c 01
[42480.411603] RSP: 0018:ff83ab31802cfe80 EFLAGS: 00000202
[42480.411604] RAX: ff31993e2157c000 RBX: ff31991f2157f000 RCX: 0000000000000000
[42480.411605] RDX: 000026a2bdd65b4e RSI: 000026c6f9625109 RDI: 0000000000000000
[42480.411605] RBP: 0000000000000002 R08: 0000000000000002 R09: ff31993dcf260980
[42480.411606] R10: ff31993dcf260f78 R11: 00000000ffffffff R12: ffffffffad3c09c0
[42480.411606] R13: 000026a2bdd65b4e R14: 0000000000000002 R15: 0000000000000000
[42480.411610]  cpuidle_enter+0x2d/0x40
[42480.411613]  do_idle+0x132/0x2c0
[42480.411617]  cpu_startup_entry+0x29/0x30
[42480.411618]  start_secondary+0x114/0x140
[42480.411620]  common_startup_64+0x13e/0x151
[42480.411624]  </TASK>
[42480.411625] NMI backtrace for cpu 67 skipped: idling at io_idle+0x3/0x30
[42480.411630] NMI backtrace for cpu 66
[42480.411632] CPU: 66 UID: 1000 PID: 1131384 Comm: expand Not tainted 7.3.6 #1 PREEMPT(lazy) 
[42480.411633] Hardware name:  TURIN2D16-2T/TURIN2D16-2T, BIOS 10.06 10/22/2025
[42480.411634] RIP: 0033:0x565467577861
[42480.411636] Code: 0b 48 8d 3d a1 19 00 00 48 c1 e6 04 48 01 fe 48 03 14 ce 48 b9 cd cc cc cc cc cc cc cc c4 e2 f3 f6 c9 48 c1 e9 02 0f b6 04 08 <8d> 0c 89 29 ca 48 8d 0d 43 7e 00 00 0f b6 c0 0f af 04 91 48 8d 0c
[42480.411637] RSP: 002b:00007f5b8f9e9d20 EFLAGS: 00000216
[42480.411638] RAX: 0000000000000000 RBX: 00005654675f10e0 RCX: 0000000037e97cfa
[42480.411639] RDX: 00000001178f70e4 RSI: 00005654675791e0 RDI: 00005654675791e0
[42480.411640] RBP: 000000000000001e R08: 0000000000000001 R09: 400000011066e501
[42480.411640] R10: 000056546757d904 R11: 00005654675e10e0 R12: 0000000044197101
[42480.411640] R13: 0000000000000004 R14: 00005654675810e0 R15: 00005654675890e0
[42480.411651] FS:  00007f5b8f9ea6c0 GS:  0000000000000000
[42480.411684] NMI backtrace for cpu 3
[42480.411712] CPU: 3 UID: 1000 PID: 1131369 Comm: expand Not tainted 7.3.6 #1 PREEMPT(lazy) 
[42480.411714] Hardware name:  TURIN2D16-2T/TURIN2D16-2T, BIOS 10.06 10/22/2025
[42480.411715] RIP: 0033:0x565467578003
[42480.411716] Code: b3 f6 c9 49 c1 e9 02 42 0f b6 04 08 47 8d 0c 89 44 29 ca 4c 8d 0d bd 76 00 00 0f b6 c0 41 0f af 04 91 48 8d 14 40 48 c1 ea 20 <48> 83 fa 02 0f 84 fa fd ff ff 83 fa 01 0f 85 ea fd ff ff c6 44 24
[42480.411717] RSP: 002b:00007f5b979f9d20 EFLAGS: 00000256
[42480.411719] RAX: 0000000000000000 RBX: 0000000000000110 RCX: 00005654675791f0
[42480.411719] RDX: 0000000000000000 RSI: 00005654675e10e0 RDI: 0000000044000000
[42480.411720] RBP: 00005654675950e0 R08: 0000000000000004 R09: 000056546757f6b0
[42480.411720] R10: 00000000ffffffec R11: 0000000004000000 R12: 0000000044171890
[42480.411721] R13: 0000000000000090 R14: 00005654675810e0 R15: 0000000001fccd14
[42480.411721] FS:  00007f5b979fa6c0 GS:  0000000000000000
[42480.411725] NMI backtrace for cpu 24 skipped: idling at io_idle+0x3/0x30
[42480.411738] NMI backtrace for cpu 25 skipped: idling at io_idle+0x3/0x30
[42480.411744] NMI backtrace for cpu 91
[42480.411749] CPU: 91 UID: 1000 PID: 1131364 Comm: expand Not tainted 7.3.6 #1 PREEMPT(lazy) 
[42480.411752] Hardware name:  TURIN2D16-2T/TURIN2D16-2T, BIOS 10.06 10/22/2025
[42480.411754] RIP: 0033:0x565467577861
[42480.411759] Code: 0b 48 8d 3d a1 19 00 00 48 c1 e6 04 48 01 fe 48 03 14 ce 48 b9 cd cc cc cc cc cc cc cc c4 e2 f3 f6 c9 48 c1 e9 02 0f b6 04 08 <8d> 0c 89 29 ca 48 8d 0d 43 7e 00 00 0f b6 c0 0f af 04 91 48 8d 0c
[42480.411761] RSP: 002b:00007f5b9a1fed20 EFLAGS: 00000212
[42480.411763] RAX: 0000000000000070 RBX: 00005654675ef0e0 RCX: 00000000e34f5c1a
[42480.411764] RDX: 00000004708ccc84 RSI: 00005654675791e0 RDI: 00005654675791e0
[42480.411765] RBP: 0000000000000010 R08: 0000000000000001 R09: c00000011050e1d2
[42480.411765] R10: 000056546757d9e4 R11: 00005654675e10e0 R12: 00000000441430d2
[42480.411766] R13: 0000000000000001 R14: 00005654675810e0 R15: 00005654675890e0
[42480.411767] FS:  00007f5b9a1ff6c0 GS:  0000000000000000
[42480.411768] NMI backtrace for cpu 88
[42480.411769] CPU: 88 UID: 1000 PID: 1131408 Comm: expand Not tainted 7.3.6 #1 PREEMPT(lazy) 
[42480.411771] Hardware name:  TURIN2D16-2T/TURIN2D16-2T, BIOS 10.06 10/22/2025
[42480.411772] RIP: 0033:0x565467577c75
[42480.411774] Code: ff ff f3 49 0f b8 fb 48 8b 05 77 94 00 00 48 8b 4c 24 18 41 bd 02 00 00 00 41 8d 74 32 0b 41 8d 7c 3a 13 4c 8d 15 6b 15 00 00 <48> c1 e6 04 4c 01 d6 48 03 14 fe 48 be cd cc cc cc cc cc cc cc c4
[42480.411775] RSP: 002b:00007f5b831d0d20 EFLAGS: 00000202
[42480.411777] RAX: 00007f5b9a200000 RBX: 0000000000000031 RCX: 4000000000080002
[42480.411778] RDX: 00000008ba64d059 RSI: 0000000000000001 RDI: 0000000000000001
[42480.411778] RBP: 0000000001fce6ad R08: 0000000000000014 R09: 0000000110610d01
[42480.411779] R10: 00005654675791e0 R11: 0000000000080002 R12: 0000000044188685
[42480.411779] R13: 0000000000000002 R14: 00005654675810e0 R15: 0000000000000683
[42480.411780] FS:  00007f5b831d16c0 GS:  0000000000000000
[42480.411781] NMI backtrace for cpu 89
[42480.411783] CPU: 89 UID: 1000 PID: 1131417 Comm: expand Not tainted 7.3.6 #1 PREEMPT(lazy) 
[42480.411784] Hardware name:  TURIN2D16-2T/TURIN2D16-2T, BIOS 10.06 10/22/2025
[42480.411785] RIP: 0033:0x565467577cbf
[42480.411787] Code: 04 30 8d 34 b6 29 f2 48 8d 35 0d 7a 00 00 0f b6 c0 0f af 04 96 48 8d 14 40 48 c1 ea 20 48 83 fa 01 0f 84 c4 fc ff ff 83 fa 02 <0f> 84 8f 03 00 00 b0 01 89 44 24 38 e9 b0 fc ff ff 48 8b 44 24 58
[42480.411788] RSP: 002b:00007f5b7e9c7d20 EFLAGS: 00000293
[42480.411789] RAX: 0000000000000000 RBX: 00000000000000bc RCX: 4000000000004080
[42480.411790] RDX: 0000000000000000 RSI: 000056546757f6b0 RDI: 0000000000000001
[42480.411791] RBP: 000000000214fa5a R08: 0000000020000000 R09: 0000000100711a01
[42480.411791] R10: 00005654675791e0 R11: 0000000000004080 R12: 00000000441c4d01
[42480.411792] R13: 0000000000000002 R14: 00005654675810e0 R15: 0000000000000501
[42480.411792] FS:  00007f5b7e9c86c0 GS:  0000000000000000
[42480.411794] NMI backtrace for cpu 26 skipped: idling at io_idle+0x3/0x30
[42480.411799] NMI backtrace for cpu 90
[42480.411801] CPU: 90 UID: 1000 PID: 1131388 Comm: expand Not tainted 7.3.6 #1 PREEMPT(lazy) 
[42480.411803] Hardware name:  TURIN2D16-2T/TURIN2D16-2T, BIOS 10.06 10/22/2025
[42480.411804] RIP: 0033:0x565467577fe5
[42480.411806] Code: ff ff 48 8b 05 0c 91 00 00 47 8d 4c 0a 13 4a 03 14 c9 49 b9 cd cc cc cc cc cc cc cc c4 42 b3 f6 c9 49 c1 e9 02 42 0f b6 04 08 <47> 8d 0c 89 44 29 ca 4c 8d 0d bd 76 00 00 0f b6 c0 41 0f af 04 91
[42480.411807] RSP: 002b:00007f5b8d9e5d20 EFLAGS: 00000212
[42480.411809] RAX: 0000000000000027 RBX: 0000000000000021 RCX: 00005654675791f0
[42480.411809] RDX: 000000088187a030 RSI: 00005654675e10e0 RDI: 0000000040000000
[42480.411810] RBP: 00005654675990e0 R08: 0000000000000400 R09: 00000001b3818670
[42480.411810] R10: 00000000ffffffec R11: 0000000040000000 R12: 00000000441ac109
[42480.411811] R13: 0000000000000106 R14: 00005654675810e0 R15: 00000000008a11ba
[42480.411811] FS:  00007f5b8d9e66c0 GS:  0000000000000000
[42480.411812] NMI backtrace for cpu 27
[42480.411813] CPU: 27 UID: 1000 PID: 1131407 Comm: expand Not tainted 7.3.6 #1 PREEMPT(lazy) 
[42480.411815] Hardware name:  TURIN2D16-2T/TURIN2D16-2T, BIOS 10.06 10/22/2025
[42480.411815] RIP: 0033:0x565467577dba
[42480.411816] Code: 48 09 d6 48 8d 15 46 14 00 00 48 01 d1 48 89 74 24 18 eb 1c 66 66 66 2e 0f 1f 84 00 00 00 00 00 48 8b 44 24 70 c4 e2 f8 f3 c8 <0f> 84 5b 02 00 00 f3 48 0f bc d0 48 89 44 24 70 48 8d 05 ef 57 00
[42480.411817] RSP: 002b:00007f5b839d1d20 EFLAGS: 00000206
[42480.411818] RAX: 0000000000010000 RBX: 0000000000000110 RCX: 00005654675791f0
[42480.411819] RDX: 0000000000000000 RSI: 00005654675e10e0 RDI: 0000000000000000
[42480.411820] RBP: 00005654675990e0 R08: 0000000000010000 R09: 000056546757f6b0
[42480.411820] R10: 00000000ffffffec R11: 0000000000010000 R12: 000000004411ac82
[42480.411821] R13: 0000000000000482 R14: 00005654675810e0 R15: 0000000001fc53cb
[42480.411821] FS:  00007f5b839d26c0 GS:  0000000000000000
[42480.411825] NMI backtrace for cpu 92 skipped: idling at io_idle+0x3/0x30
[42480.411838] NMI backtrace for cpu 28
[42480.411841] CPU: 28 UID: 1000 PID: 1131362 Comm: expand Not tainted 7.3.6 #1 PREEMPT(lazy) 
[42480.411845] Hardware name:  TURIN2D16-2T/TURIN2D16-2T, BIOS 10.06 10/22/2025
[42480.411846] RIP: 0033:0x565467577cd5
[42480.411852] Code: 8d 14 40 48 c1 ea 20 48 83 fa 01 0f 84 c4 fc ff ff 83 fa 02 0f 84 8f 03 00 00 b0 01 89 44 24 38 e9 b0 fc ff ff 48 8b 44 24 58 <48> 8b b4 24 90 00 00 00 c4 e2 f8 f3 c8 0f 85 68 fc ff ff 8b 44 24
[42480.411854] RSP: 002b:00007f5b7d9c5d20 EFLAGS: 00000246
[42480.411856] RAX: 0000000110200000 RBX: 0000000000000036 RCX: 4000000002000002
[42480.411857] RDX: 0000000000000000 RSI: 000056546757f6b0 RDI: 0000000110258249
[42480.411858] RBP: 0000000001fbaf83 R08: 0000000000000000 R09: 0000000110058249
[42480.411859] R10: 00005654675791e0 R11: 0000000002000002 R12: 000000004412c125
[42480.411860] R13: 0000000000000002 R14: 00005654675810e0 R15: 0000000000000125
[42480.411861] FS:  00007f5b7d9c66c0 GS:  0000000000000000
[42480.411863] NMI backtrace for cpu 93
[42480.411866] CPU: 93 UID: 1000 PID: 1131368 Comm: expand Not tainted 7.3.6 #1 PREEMPT(lazy) 
[42480.411869] Hardware name:  TURIN2D16-2T/TURIN2D16-2T, BIOS 10.06 10/22/2025
[42480.411870] RIP: 0033:0x565467577182
[42480.411873] Code: 00 00 00 00 48 8b 74 24 50 89 c1 48 0f 45 fa 0f 95 c0 41 0f 94 c1 4c 89 c2 48 89 bc 24 80 00 00 00 20 c8 48 8b 0d 4e 9f 00 00 <48> bf cd cc cc cc cc cc cc cc 49 01 f1 48 8d 35 1a 85 00 00 c4 e2
[42480.411875] RSP: 002b:00007f5b981fad20 EFLAGS: 00000202
[42480.411876] RAX: 0000000000000001 RBX: 0000000000000181 RCX: 00007f5b9a200000
[42480.411877] RDX: 0000000edb700590 RSI: 0000000001fc61fd RDI: 00000000000002f0
[42480.411878] RBP: 00005654675950e0 R08: 0000000edb700590 R09: 0000000000000000
[42480.411879] R10: 00000000ffffffec R11: 0000000008000000 R12: 0000000044122c0d
[42480.411879] R13: 0000000000000000 R14: 00005654675810e0 R15: 00000000026a7bde
[42480.411880] FS:  00007f5b981fb6c0 GS:  0000000000000000
[42480.411881] NMI backtrace for cpu 29 skipped: idling at io_idle+0x3/0x30
[42480.411887] NMI backtrace for cpu 31
[42480.411890] CPU: 31 UID: 1000 PID: 1131383 Comm: expand Not tainted 7.3.6 #1 PREEMPT(lazy) 
[42480.411892] Hardware name:  TURIN2D16-2T/TURIN2D16-2T, BIOS 10.06 10/22/2025
[42480.411893] RIP: 0033:0x565467577c3b
[42480.411896] Code: 4d 85 ed 75 1a 48 8d 44 ad 00 48 c1 ea 3e 48 8d 04 83 48 8d 14 42 eb 19 0f 1f 80 00 00 00 00 48 69 c5 19 01 00 00 48 c1 ea 3e <48> 01 d8 48 8d 14 82 f3 49 0f b8 f2 41 ba ec ff ff ff f3 49 0f b8
[42480.411897] RSP: 002b:00007f5b901ead20 EFLAGS: 00000212
[42480.411899] RAX: 000000022ea11331 RBX: 00000000000000e4 RCX: 00005654675e10e0
[42480.411899] RDX: 0000000000000001 RSI: 00005654675f10e0 RDI: 0000000000000318
[42480.411900] RBP: 0000000001fcedd9 R08: 00000000000c0800 R09: 0000000108318086
[42480.411901] R10: 0000000108318886 R11: 0000000080000200 R12: 000000004418c886
[42480.411901] R13: 0000000080000000 R14: 00005654675810e0 R15: 0000000000000486
[42480.411902] FS:  00007f5b901eb6c0 GS:  0000000000000000
[42480.411903] NMI backtrace for cpu 30
[42480.411907] CPU: 30 UID: 1000 PID: 1131403 Comm: expand Not tainted 7.3.6 #1 PREEMPT(lazy) 
[42480.411909] Hardware name:  TURIN2D16-2T/TURIN2D16-2T, BIOS 10.06 10/22/2025
[42480.411910] RIP: 0033:0x565467577985
[42480.411912] Code: 8d 05 c7 6d 00 00 4c 8b 04 d0 49 21 f0 0f 84 62 03 00 00 49 89 f9 49 0f b3 d1 48 8d 05 b4 6e 00 00 eb 19 66 90 48 8b 7c 24 28 <c4> c2 b8 f3 c8 48 8d 05 9f 6e 00 00 0f 84 39 03 00 00 c4 c2 a8 f3
[42480.411913] RSP: 002b:00007f5b859d5d20 EFLAGS: 00000246
[42480.411915] RAX: 0000000055555594 RBX: 000000000000002f RCX: 4000000000020002
[42480.411916] RDX: 0000000000000001 RSI: 000056546757f6b0 RDI: 0000000110745018
[42480.411917] RBP: 0000000001fd3057 R08: 0000000000008000 R09: 0000000110745008
[42480.411917] R10: 00005654675791e0 R11: 0000000000020002 R12: 00000000441d280c
[42480.411918] R13: 0000000000000002 R14: 00005654675810e0 R15: 0000000000000004
[42480.411919] FS:  00007f5b859d66c0 GS:  0000000000000000
[42480.411919] NMI backtrace for cpu 95 skipped: idling at io_idle+0x3/0x30
[42480.411924] NMI backtrace for cpu 94
[42480.411926] CPU: 94 UID: 1000 PID: 1131389 Comm: expand Not tainted 7.3.6 #1 PREEMPT(lazy) 
[42480.411927] Hardware name:  TURIN2D16-2T/TURIN2D16-2T, BIOS 10.06 10/22/2025
[42480.411928] RIP: 0033:0x565467577be8
[42480.411930] Code: 90 f3 cf 48 89 d7 48 f7 d7 c4 e2 82 f5 c7 41 89 c7 c4 e2 48 f7 f8 41 81 e7 ff 07 00 00 48 c1 e8 16 f3 41 0f b8 ef f3 0f b8 f7 <01> ee c1 e5 0e 48 01 cd 48 8d 0d e9 14 01 00 c1 e6 0d 48 8b 6c fd
[42480.411930] RSP: 002b:00007f5b8c9e3d20 EFLAGS: 00000202
[42480.411931] RAX: 0000000000000110 RBX: 000000000000006a RCX: 000056546758d0e0
[42480.411933] RDX: 4000000000800008 RSI: 0000000000000004 RDI: 0000000000000231
[42480.411933] RBP: 0000000000000004 R08: 0000000000000260 R09: 0000000110231884
[42480.411934] R10: 00000001102318a4 R11: 0000000000800008 R12: 0000000044118cc4
[42480.411935] R13: 0000000000800000 R14: 00005654675810e0 R15: 0000000000000454
[42480.411936] FS:  00007f5b8c9e46c0 GS:  0000000000000000
[42480.411939] NMI backtrace for cpu 80 skipped: idling at io_idle+0x3/0x30
[42480.411952] NMI backtrace for cpu 16
[42480.411955] CPU: 16 UID: 1000 PID: 1131375 Comm: expand Not tainted 7.3.6 #1 PREEMPT(lazy) 
[42480.411958] Hardware name:  TURIN2D16-2T/TURIN2D16-2T, BIOS 10.06 10/22/2025
[42480.411960] RIP: 0033:0x565467577cbf
[42480.411966] Code: 04 30 8d 34 b6 29 f2 48 8d 35 0d 7a 00 00 0f b6 c0 0f af 04 96 48 8d 14 40 48 c1 ea 20 48 83 fa 01 0f 84 c4 fc ff ff 83 fa 02 <0f> 84 8f 03 00 00 b0 01 89 44 24 38 e9 b0 fc ff ff 48 8b 44 24 58
[42480.411967] RSP: 002b:00007f5b949f3d20 EFLAGS: 00000293
[42480.411969] RAX: 000000000ca45880 RBX: 0000000000000001 RCX: 4000000000000005
[42480.411971] RDX: 0000000000000000 RSI: 000056546757f6b0 RDI: 0000000000000001
[42480.411972] RBP: 00000000005581f8 R08: 0000000080080000 R09: 000000001073b000
[42480.411973] R10: 00005654675791e0 R11: 0000000000000005 R12: 00000000441cec00
[42480.411974] R13: 0000000000000002 R14: 00005654675810e0 R15: 0000000000000400
[42480.411975] FS:  00007f5b949f46c0 GS:  0000000000000000
[42480.411978] NMI backtrace for cpu 19
[42480.411981] CPU: 19 UID: 1000 PID: 1131418 Comm: expand Not tainted 7.3.6 #1 PREEMPT(lazy) 
[42480.411984] Hardware name:  TURIN2D16-2T/TURIN2D16-2T, BIOS 10.06 10/22/2025
[42480.411985] RIP: 0033:0x565467577a0f
[42480.411988] Code: 31 ed 49 6b ff 70 4c 8d 6c 07 0c eb 18 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 48 83 c5 02 48 83 fd 0e 74 c6 41 8b 7c ed f4 <48> 83 ff 22 74 bb 48 0f a3 fa 72 11 41 8b 7c ed f8 48 83 ff 22 74
[42480.411989] RSP: 002b:00007f5b7e1c6d20 EFLAGS: 00000246
[42480.411991] RAX: 000056546757e830 RBX: 0000000000000000 RCX: 4000000002000002
[42480.411993] RDX: 4000000106293886 RSI: fffffffeedd6c779 RDI: 0000000000000016
[42480.411994] RBP: 0000000000000000 R08: 0000000024000000 R09: 0000000100293884
[42480.411994] R10: 0000000104293884 R11: 0000000002000000 R12: 0000000044149c42
[42480.411995] R13: 000056546757f32c R14: 00005654675810e0 R15: 0000000000000019
[42480.411996] FS:  00007f5b7e1c76c0 GS:  0000000000000000
[42480.411997] NMI backtrace for cpu 83
[42480.411998] CPU: 83 UID: 1000 PID: 1131367 Comm: expand Not tainted 7.3.6 #1 PREEMPT(lazy) 
[42480.412000] Hardware name:  TURIN2D16-2T/TURIN2D16-2T, BIOS 10.06 10/22/2025
[42480.412001] RIP: 0033:0x565467577c37
[42480.412002] Code: 48 03 2c c6 4d 85 ed 75 1a 48 8d 44 ad 00 48 c1 ea 3e 48 8d 04 83 48 8d 14 42 eb 19 0f 1f 80 00 00 00 00 48 69 c5 19 01 00 00 <48> c1 ea 3e 48 01 d8 48 8d 14 82 f3 49 0f b8 f2 41 ba ec ff ff ff
[42480.412003] RSP: 002b:00007f5b989fbd20 EFLAGS: 00000206
[42480.412004] RAX: 00000002101db96d RBX: 00000000000000de RCX: 00005654675e10e0
[42480.412005] RDX: 4000000000010200 RSI: 00005654675f10e0 RDI: 0000000000000305
[42480.412005] RBP: 0000000001e12175 R08: 0000000024000000 R09: 0000000100605d10
[42480.412006] R10: 0000000104605d10 R11: 0000000000010200 R12: 0000000044182f10
[42480.412006] R13: 0000000000010000 R14: 00005654675810e0 R15: 0000000000000710
[42480.412007] FS:  00007f5b989fc6c0 GS:  0000000000000000
[42480.412008] NMI backtrace for cpu 81
[42480.412012] CPU: 81 UID: 1000 PID: 1131387 Comm: expand Not tainted 7.3.6 #1 PREEMPT(lazy) 
[42480.412014] Hardware name:  TURIN2D16-2T/TURIN2D16-2T, BIOS 10.06 10/22/2025
[42480.412015] RIP: 0033:0x565467577caa
[42480.412017] Code: 48 be cd cc cc cc cc cc cc cc c4 e2 cb f6 f6 48 c1 ee 02 0f b6 04 30 8d 34 b6 29 f2 48 8d 35 0d 7a 00 00 0f b6 c0 0f af 04 96 <48> 8d 14 40 48 c1 ea 20 48 83 fa 01 0f 84 c4 fc ff ff 83 fa 02 0f
[42480.412018] RSP: 002b:00007f5b8e1e6d20 EFLAGS: 00000246
[42480.412020] RAX: 0000000055555556 RBX: 000000000000000c RCX: 4000000000081000
[42480.412021] RDX: 0000000000000000 RSI: 000056546757f6b0 RDI: 0000000000000000
[42480.412022] RBP: 0000000002efd9fc R08: 0000000000010000 R09: 0000000110460941
[42480.412022] R10: 00005654675791e0 R11: 0000000000001000 R12: 0000000044130d41
[42480.412023] R13: 0000000000000002 R14: 00005654675810e0 R15: 0000000000000141
[42480.412024] FS:  00007f5b8e1e76c0 GS:  0000000000000000
[42480.412024] NMI backtrace for cpu 17 skipped: idling at io_idle+0x3/0x30
[42480.412030] NMI backtrace for cpu 18 skipped: idling at io_idle+0x3/0x30
[42480.412037] NMI backtrace for cpu 20
[42480.412045] CPU: 20 UID: 1000 PID: 1131422 Comm: expand Not tainted 7.3.6 #1 PREEMPT(lazy) 
[42480.412048] Hardware name:  TURIN2D16-2T/TURIN2D16-2T, BIOS 10.06 10/22/2025
[42480.412049] RIP: 0033:0x565467577ee6
[42480.412056] Code: 0f 00 fe ff ff ff 49 c1 eb 3e 48 21 c3 b8 14 0d 00 00 c4 62 f8 f7 fa 48 21 f2 4c 09 fa 48 09 da 49 83 fb 03 74 12 41 83 fb 02 <75> 26 48 b8 00 00 00 00 00 00 00 c0 eb 17 48 b8 ff ff ff ff ff ff
[42480.412058] RSP: 002b:00007f5b7b1c0d20 EFLAGS: 00000293
[42480.412060] RAX: 0000000000000d14 RBX: 0000000002000000 RCX: 00005654675791f0
[42480.412061] RDX: 0000000002000010 RSI: fffffffe000fe000 RDI: 0000000001000000
[42480.412062] RBP: 00005654675a50e0 R08: 0000000000000020 R09: 0000000001000020
[42480.412063] R10: 0000000000000084 R11: 0000000000000000 R12: 000000004414019e
[42480.412064] R13: 000000000000019e R14: 00005654675810e0 R15: 0000000000000010
[42480.412065] FS:  00007f5b7b1c16c0 GS:  0000000000000000
[42480.412067] NMI backtrace for cpu 84
[42480.412068] CPU: 84 UID: 1000 PID: 1131376 Comm: expand Not tainted 7.3.6 #1 PREEMPT(lazy) 
[42480.412071] Hardware name:  TURIN2D16-2T/TURIN2D16-2T, BIOS 10.06 10/22/2025
[42480.412072] RIP: 0033:0x565467577c97
[42480.412073] Code: 13 4c 8d 15 6b 15 00 00 48 c1 e6 04 4c 01 d6 48 03 14 fe 48 be cd cc cc cc cc cc cc cc c4 e2 cb f6 f6 48 c1 ee 02 0f b6 04 30 <8d> 34 b6 29 f2 48 8d 35 0d 7a 00 00 0f b6 c0 0f af 04 96 48 8d 14
[42480.412074] RSP: 002b:00007f5b941f2d20 EFLAGS: 00000216
[42480.412076] RAX: 0000000000000000 RBX: 0000000000000094 RCX: 4000000000004020
[42480.412077] RDX: 0000000f20a7546d RSI: 000000030687ddaf RDI: 0000000000000001
[42480.412078] RBP: 00000000020c25b4 R08: 0000000008000000 R09: 0000000110520b04
[42480.412079] R10: 00005654675791e0 R11: 0000000000004020 R12: 000000004414c584
[42480.412079] R13: 0000000000000002 R14: 00005654675810e0 R15: 0000000000000584
[42480.412080] FS:  00007f5b941f36c0 GS:  0000000000000000
[42480.412081] NMI backtrace for cpu 22 skipped: idling at io_idle+0x3/0x30
[42480.412090] NMI backtrace for cpu 21
[42480.412093] CPU: 21 UID: 1000 PID: 1131370 Comm: expand Not tainted 7.3.6 #1 PREEMPT(lazy) 
[42480.412096] Hardware name:  TURIN2D16-2T/TURIN2D16-2T, BIOS 10.06 10/22/2025
[42480.412096] RIP: 0033:0x565467577cd5
[42480.412099] Code: 8d 14 40 48 c1 ea 20 48 83 fa 01 0f 84 c4 fc ff ff 83 fa 02 0f 84 8f 03 00 00 b0 01 89 44 24 38 e9 b0 fc ff ff 48 8b 44 24 58 <48> 8b b4 24 90 00 00 00 c4 e2 f8 f3 c8 0f 85 68 fc ff ff 8b 44 24
[42480.412100] RSP: 002b:00007f5b971f8d20 EFLAGS: 00000246
[42480.412102] RAX: 0000000110582180 RBX: 000000000000005a RCX: 4000000000000018
[42480.412103] RDX: 0000000000000001 RSI: 000056546757f6b0 RDI: 00000001105821c2
[42480.412103] RBP: 0000000001fcc28e R08: 0000000000000000 R09: 0000000110582142
[42480.412104] R10: 00005654675791e0 R11: 0000000000000018 R12: 0000000044160872
[42480.412105] R13: 0000000000000002 R14: 00005654675810e0 R15: 0000000000000052
[42480.412105] FS:  00007f5b971f96c0 GS:  0000000000000000
[42480.412106] NMI backtrace for cpu 86
[42480.412107] CPU: 86 UID: 1000 PID: 1131385 Comm: expand Not tainted 7.3.6 #1 PREEMPT(lazy) 
[42480.412110] Hardware name:  TURIN2D16-2T/TURIN2D16-2T, BIOS 10.06 10/22/2025
[42480.412110] RIP: 0033:0x565467577a31
[42480.412112] Code: 0e 74 c6 41 8b 7c ed f4 48 83 ff 22 74 bb 48 0f a3 fa 72 11 41 8b 7c ed f8 48 83 ff 22 74 b3 49 0f a3 fa 72 ad 41 8b 7c ed fc <48> 83 ff 22 74 99 48 0f a3 fa 72 c3 41 8b 7c ed 00 48 83 ff 22 74
[42480.412113] RSP: 002b:00007f5b8f1e8d20 EFLAGS: 00000283
[42480.412115] RAX: 000056546757e830 RBX: 0000000000000000 RCX: 4000000000001008
[42480.412116] RDX: 400000011070ba0c RSI: fffffffeef8f65f2 RDI: 0000000000000004
[42480.412116] RBP: 0000000000000000 R08: 0000000000002000 R09: 0000000110708a04
[42480.412117] R10: 000000011070aa04 R11: 0000000000001008 R12: 00000000441c2505
[42480.412117] R13: 000056546757e98c R14: 00005654675810e0 R15: 0000000000000003
[42480.412118] FS:  00007f5b8f1e96c0 GS:  0000000000000000
[42480.412119] NMI backtrace for cpu 87
[42480.412122] CPU: 87 UID: 1000 PID: 1131394 Comm: expand Not tainted 7.3.6 #1 PREEMPT(lazy) 
[42480.412124] Hardware name:  TURIN2D16-2T/TURIN2D16-2T, BIOS 10.06 10/22/2025
[42480.412125] RIP: 0033:0x565467577c11
[42480.412127] Code: f7 01 ee c1 e5 0e 48 01 cd 48 8d 0d e9 14 01 00 c1 e6 0d 48 8b 6c fd 00 4a 03 2c f9 48 8d 0d d6 94 06 00 48 01 ce 48 03 2c c6 <4d> 85 ed 75 1a 48 8d 44 ad 00 48 c1 ea 3e 48 8d 04 83 48 8d 14 42
[42480.412129] RSP: 002b:00007f5b8a1ded20 EFLAGS: 00000216
[42480.412130] RAX: 0000000000000110 RBX: 000000000000004b RCX: 00005654675e10e0
[42480.412131] RDX: 4000000000010004 RSI: 00005654675f10e0 RDI: 00000000000002c8
[42480.412132] RBP: 0000000001fcc203 R08: 0000000000100000 R09: 0000000110488832
[42480.412133] R10: 0000000110588832 R11: 0000000000010004 R12: 00000000441a441a
[42480.412133] R13: 0000000000010000 R14: 00005654675810e0 R15: 000000000000041a
[42480.412134] FS:  00007f5b8a1df6c0 GS:  0000000000000000
[42480.412135] NMI backtrace for cpu 85 skipped: idling at io_idle+0x3/0x30
[42480.412139] NMI backtrace for cpu 23 skipped: idling at io_idle+0x3/0x30
[42480.412143] NMI backtrace for cpu 82
[42480.412146] CPU: 82 UID: 1000 PID: 1131378 Comm: expand Not tainted 7.3.6 #1 PREEMPT(lazy) 
[42480.412148] Hardware name:  TURIN2D16-2T/TURIN2D16-2T, BIOS 10.06 10/22/2025
[42480.412149] RIP: 0033:0x565467577cbf
[42480.412151] Code: 04 30 8d 34 b6 29 f2 48 8d 35 0d 7a 00 00 0f b6 c0 0f af 04 96 48 8d 14 40 48 c1 ea 20 48 83 fa 01 0f 84 c4 fc ff ff 83 fa 02 <0f> 84 8f 03 00 00 b0 01 89 44 24 38 e9 b0 fc ff ff 48 8b 44 24 58
[42480.412153] RSP: 002b:00007f5b931f0d20 EFLAGS: 00000293
[42480.412155] RAX: 0000000000000000 RBX: 00000000000000e9 RCX: 4000000000004400
[42480.412156] RDX: 0000000000000000 RSI: 000056546757f6b0 RDI: 0000000000000001
[42480.412157] RBP: 0000000001fd18f1 R08: 00000000000000a0 R09: 00000001106e1004
[42480.412158] R10: 00005654675791e0 R11: 0000000000004400 R12: 00000000441b8844
[42480.412159] R13: 0000000000000002 R14: 00005654675810e0 R15: 0000000000000024
[42480.412159] FS:  00007f5b931f16c0 GS:  0000000000000000
[42480.412161] NMI backtrace for cpu 76 skipped: idling at io_idle+0x3/0x30
[42480.412174] NMI backtrace for cpu 12
[42480.412178] CPU: 12 UID: 1000 PID: 1131414 Comm: expand Not tainted 7.3.6 #1 PREEMPT(lazy) 
[42480.412181] Hardware name:  TURIN2D16-2T/TURIN2D16-2T, BIOS 10.06 10/22/2025
[42480.412183] RIP: 0033:0x565467577cbf
[42480.412188] Code: 04 30 8d 34 b6 29 f2 48 8d 35 0d 7a 00 00 0f b6 c0 0f af 04 96 48 8d 14 40 48 c1 ea 20 48 83 fa 01 0f 84 c4 fc ff ff 83 fa 02 <0f> 84 8f 03 00 00 b0 01 89 44 24 38 e9 b0 fc ff ff 48 8b 44 24 58
[42480.412190] RSP: 002b:00007f5b801cad20 EFLAGS: 00000293
[42480.412192] RAX: 0000000000000000 RBX: 0000000000000041 RCX: 4000000000000044
[42480.412193] RDX: 0000000000000000 RSI: 000056546757f6b0 RDI: 0000000000000001
[42480.412194] RBP: 0000000001fcc84c R08: 00000000c0000800 R09: 00000001105a8300
[42480.412195] R10: 00005654675791e0 R11: 0000000000000044 R12: 000000004417a0c0
[42480.412196] R13: 0000000000000002 R14: 00005654675810e0 R15: 00000000000002c0
[42480.412197] FS:  00007f5b801cb6c0 GS:  0000000000000000
[42480.412199] NMI backtrace for cpu 13
[42480.412202] CPU: 13 UID: 1000 PID: 1131401 Comm: expand Not tainted 7.3.6 #1 PREEMPT(lazy) 
[42480.412205] Hardware name:  TURIN2D16-2T/TURIN2D16-2T, BIOS 10.06 10/22/2025
[42480.412206] RIP: 0033:0x565467577ac0
[42480.412209] Code: 75 d8 eb 17 66 0f 1f 44 00 00 48 b8 ff ff ff ff ff ff ff 3f 45 31 db 48 8d 50 01 48 b8 ff ff ff ff ff ff ff 3f f3 49 0f bc db <48> 8d 3c 02 4c 21 df 74 27 f3 4c 0f bc ff c1 e3 09 48 8d 05 e8 18
[42480.412211] RSP: 002b:00007f5b869d7d20 EFLAGS: 00000202
[42480.412213] RAX: 3fffffffffffffff RBX: 0000000000000004 RCX: 4000000000000110
[42480.412215] RDX: 4000000000000110 RSI: 000056546757f6b0 RDI: 0000000000000022
[42480.412216] RBP: 0000000000000000 R08: 0000000000010200 R09: 0000000110627001
[42480.412217] R10: 0000000110627201 R11: 0000000000000110 R12: 0000000044189d01
[42480.412218] R13: 0000000000000002 R14: 00005654675810e0 R15: 0000000000000008
[42480.412219] FS:  00007f5b869d86c0 GS:  0000000000000000
[42480.412220] NMI backtrace for cpu 77 skipped: idling at io_idle+0x3/0x30
[42480.412225] NMI backtrace for cpu 79
[42480.412228] CPU: 79 UID: 1000 PID: 1131381 Comm: expand Not tainted 7.3.6 #1 PREEMPT(lazy) 
[42480.412231] Hardware name:  TURIN2D16-2T/TURIN2D16-2T, BIOS 10.06 10/22/2025
[42480.412231] RIP: 0033:0x565467577c97
[42480.412234] Code: 13 4c 8d 15 6b 15 00 00 48 c1 e6 04 4c 01 d6 48 03 14 fe 48 be cd cc cc cc cc cc cc cc c4 e2 cb f6 f6 48 c1 ee 02 0f b6 04 30 <8d> 34 b6 29 f2 48 8d 35 0d 7a 00 00 0f b6 c0 0f af 04 96 48 8d 14
[42480.412235] RSP: 002b:00007f5b919edd20 EFLAGS: 00000217
[42480.412237] RAX: 0000000000000000 RBX: 0000000000000044 RCX: 4000000000000204
[42480.412238] RDX: 0000000c3f4d2569 RSI: 00000002730f6de1 RDI: 0000000000000001
[42480.412238] RBP: 000000000164359b R08: 0000000080000000 R09: 0000000010687011
[42480.412239] R10: 00005654675791e0 R11: 0000000000000204 R12: 00000000441a1c09
[42480.412240] R13: 0000000000000002 R14: 00005654675810e0 R15: 0000000000000409
[42480.412240] FS:  00007f5b919ee6c0 GS:  0000000000000000
[42480.412241] NMI backtrace for cpu 15 skipped: idling at io_idle+0x3/0x30
[42480.412245] NMI backtrace for cpu 14
[42480.412248] CPU: 14 UID: 1000 PID: 1131386 Comm: expand Not tainted 7.3.6 #1 PREEMPT(lazy) 
[42480.412251] Hardware name:  TURIN2D16-2T/TURIN2D16-2T, BIOS 10.06 10/22/2025
[42480.412252] RIP: 0033:0x5654675779b5
[42480.412255] Code: 8d 05 9f 6e 00 00 0f 84 39 03 00 00 c4 c2 a8 f3 d8 4d 09 ca 44 89 d2 f7 d2 f7 c2 13 e0 30 01 0f 84 a4 06 00 00 4c 8b 5c 24 30 <4d> 85 db 0f 84 e2 00 00 00 4c 89 d2 48 09 ca 31 db eb 18 0f 1f 84
[42480.412256] RSP: 002b:00007f5b8e9e7d20 EFLAGS: 00000206
[42480.412258] RAX: 000056546757e830 RBX: 0000000000000102 RCX: 4000000000081000
[42480.412258] RDX: 00000000ef9ddb3e RSI: 000056546757f6b0 RDI: 00000001106224a1
[42480.412259] RBP: 0000000001fcf4d9 R08: 0000000000000040 R09: 0000000110622481
[42480.412260] R10: 00000001106224c1 R11: 0000000000081000 R12: 00000000441914a1
[42480.412260] R13: 0000000000000002 R14: 00005654675810e0 R15: 0000000000000485
[42480.412261] FS:  00007f5b8e9e86c0 GS:  0000000000000000
[42480.412262] NMI backtrace for cpu 78 skipped: idling at io_idle+0x3/0x30
[42480.412267] NMI backtrace for cpu 4
[42480.412274] CPU: 4 UID: 1000 PID: 1131379 Comm: expand Not tainted 7.3.6 #1 PREEMPT(lazy) 
[42480.412278] Hardware name:  TURIN2D16-2T/TURIN2D16-2T, BIOS 10.06 10/22/2025
[42480.412279] RIP: 0033:0x565467577861
[42480.412285] Code: 0b 48 8d 3d a1 19 00 00 48 c1 e6 04 48 01 fe 48 03 14 ce 48 b9 cd cc cc cc cc cc cc cc c4 e2 f3 f6 c9 48 c1 e9 02 0f b6 04 08 <8d> 0c 89 29 ca 48 8d 0d 43 7e 00 00 0f b6 c0 0f af 04 91 48 8d 0c
[42480.412287] RSP: 002b:00007f5b929efd20 EFLAGS: 00000217
[42480.412289] RAX: 0000000000000051 RBX: 00005654675ed0e0 RCX: 00000000444c1fc5
[42480.412291] RDX: 00000001557c9edc RSI: 00005654675791e0 RDI: 00005654675791e0
[42480.412292] RBP: 0000000000000018 R08: 0000000000000001 R09: 400000011068415b
[42480.412293] R10: 000056546757d6d4 R11: 00005654675e10e0 R12: 00000000441420ad
[42480.412294] R13: 0000000000000002 R14: 00005654675810e0 R15: 00005654675890e0
[42480.412295] FS:  00007f5b929f06c0 GS:  0000000000000000
[42480.412297] NMI backtrace for cpu 71
[42480.412300] CPU: 71 UID: 1000 PID: 1131365 Comm: expand Not tainted 7.3.6 #1 PREEMPT(lazy) 
[42480.412303] Hardware name:  TURIN2D16-2T/TURIN2D16-2T, BIOS 10.06 10/22/2025
[42480.412305] RIP: 0033:0x565467577c52
[42480.412307] Code: 19 0f 1f 80 00 00 00 00 48 69 c5 19 01 00 00 48 c1 ea 3e 48 01 d8 48 8d 14 82 f3 49 0f b8 f2 41 ba ec ff ff ff f3 49 0f b8 fb <48> 8b 05 77 94 00 00 48 8b 4c 24 18 41 bd 02 00 00 00 41 8d 74 32
[42480.412309] RSP: 002b:00007f5b999fdd20 EFLAGS: 00000202
[42480.412311] RAX: 000000005d062ecd RBX: 00000000000000ca RCX: 00005654675e10e0
[42480.412312] RDX: 000000017418bb35 RSI: 000000000000000a RDI: 0000000000000002
[42480.412313] RBP: 000000000054bf7b R08: 0000000080080000 R09: 0000000010560415
[42480.412314] R10: 00000000ffffffec R11: 0000000000000900 R12: 0000000044158215
[42480.412315] R13: 0000000000000800 R14: 00005654675810e0 R15: 0000000000000215
[42480.412316] FS:  00007f5b999fe6c0 GS:  0000000000000000
[42480.412317] NMI backtrace for cpu 7 skipped: idling at io_idle+0x3/0x30
[42480.412324] NMI backtrace for cpu 5
[42480.412327] CPU: 5 UID: 1000 PID: 1131373 Comm: expand Not tainted 7.3.6 #1 PREEMPT(lazy) 
[42480.412330] Hardware name:  TURIN2D16-2T/TURIN2D16-2T, BIOS 10.06 10/22/2025
[42480.412330] RIP: 0033:0x565467577ca3
[42480.412333] Code: 4c 01 d6 48 03 14 fe 48 be cd cc cc cc cc cc cc cc c4 e2 cb f6 f6 48 c1 ee 02 0f b6 04 30 8d 34 b6 29 f2 48 8d 35 0d 7a 00 00 <0f> b6 c0 0f af 04 96 48 8d 14 40 48 c1 ea 20 48 83 fa 01 0f 84 c4
[42480.412334] RSP: 002b:00007f5b959f5d20 EFLAGS: 00000206
[42480.412336] RAX: 000000000000001f RBX: 00000000000000ca RCX: 4000000000000900
[42480.412337] RDX: 0000000000000003 RSI: 000056546757f6b0 RDI: 0000000000000001
[42480.412337] RBP: 0000000001e12909 R08: 0000000024000000 R09: 0000000100618454
[42480.412338] R10: 00005654675791e0 R11: 0000000000000900 R12: 0000000044186254
[42480.412339] R13: 0000000000000002 R14: 00005654675810e0 R15: 0000000000000254
[42480.412339] FS:  00007f5b959f66c0 GS:  0000000000000000
[42480.412340] NMI backtrace for cpu 68 skipped: idling at io_idle+0x3/0x30
[42480.412345] NMI backtrace for cpu 69 skipped: idling at io_idle+0x3/0x30
[42480.412350] NMI backtrace for cpu 70
[42480.412353] CPU: 70 UID: 1000 PID: 1131390 Comm: expand Not tainted 7.3.6 #1 PREEMPT(lazy) 
[42480.412356] Hardware name:  TURIN2D16-2T/TURIN2D16-2T, BIOS 10.06 10/22/2025
[42480.412356] RIP: 0033:0x565467577c8a
[42480.412359] Code: 02 00 00 00 41 8d 74 32 0b 41 8d 7c 3a 13 4c 8d 15 6b 15 00 00 48 c1 e6 04 4c 01 d6 48 03 14 fe 48 be cd cc cc cc cc cc cc cc <c4> e2 cb f6 f6 48 c1 ee 02 0f b6 04 30 8d 34 b6 29 f2 48 8d 35 0d
[42480.412360] RSP: 002b:00007f5b8c1e2d20 EFLAGS: 00000216
[42480.412362] RAX: 00007f5b9a200000 RBX: 0000000000000069 RCX: 4000000000080008
[42480.412363] RDX: 0000000edc29b9f5 RSI: cccccccccccccccd RDI: 0000000000000001
[42480.412364] RBP: 0000000001fc8c49 R08: 0000000000010050 R09: 0000000110501c05
[42480.412364] R10: 00005654675791e0 R11: 0000000000080008 R12: 0000000044140e45
[42480.412365] R13: 0000000000000002 R14: 00005654675810e0 R15: 000000000000060d
[42480.412366] FS:  00007f5b8c1e36c0 GS:  0000000000000000
[42480.412367] NMI backtrace for cpu 6 skipped: idling at io_idle+0x3/0x30
[42480.412372] NMI backtrace for cpu 9
[42480.412380] CPU: 9 UID: 1000 PID: 1131391 Comm: expand Not tainted 7.3.6 #1 PREEMPT(lazy) 
[42480.412383] Hardware name:  TURIN2D16-2T/TURIN2D16-2T, BIOS 10.06 10/22/2025
[42480.412385] RIP: 0033:0x565467577c97
[42480.412391] Code: 13 4c 8d 15 6b 15 00 00 48 c1 e6 04 4c 01 d6 48 03 14 fe 48 be cd cc cc cc cc cc cc cc c4 e2 cb f6 f6 48 c1 ee 02 0f b6 04 30 <8d> 34 b6 29 f2 48 8d 35 0d 7a 00 00 0f b6 c0 0f af 04 96 48 8d 14
[42480.412393] RSP: 002b:00007f5b8b9e1d20 EFLAGS: 00000212
[42480.412396] RAX: 0000000000000075 RBX: 00000000000000d0 RCX: 4000000000020100
[42480.412397] RDX: 0000000edd2fb65d RSI: 00000002f9098adf RDI: 0000000000000001
[42480.412398] RBP: 0000000001fcc7f4 R08: 0000000000010000 R09: 0000000110584049
[42480.412399] R10: 00005654675791e0 R11: 0000000000020100 R12: 00000000441620c9
[42480.412400] R13: 0000000000000002 R14: 00005654675810e0 R15: 0000000000000049
[42480.412402] FS:  00007f5b8b9e26c0 GS:  0000000000000000
[42480.412403] NMI backtrace for cpu 11
[42480.412406] CPU: 11 UID: 1000 PID: 1131366 Comm: expand Not tainted 7.3.6 #1 PREEMPT(lazy) 
[42480.412409] Hardware name:  TURIN2D16-2T/TURIN2D16-2T, BIOS 10.06 10/22/2025
[42480.412411] RIP: 0033:0x565467577a5e
[42480.412414] Code: 22 74 99 48 0f a3 fa 72 c3 41 8b 7c ed 00 48 83 ff 22 74 91 49 0f a3 fa 73 b2 eb 89 4c 8b 5c 24 30 41 bd 02 00 00 00 48 89 ca <85> db 74 4f 89 db 45 31 ff 48 89 ca 66 0f 1f 44 00 00 42 0f b6 7c
[42480.412415] RSP: 002b:00007f5b991fcd20 EFLAGS: 00000246
[42480.412417] RAX: 000056546757e830 RBX: 0000000000000001 RCX: 4000000000081000
[42480.412419] RDX: 4000000000081000 RSI: 000056546757f6b0 RDI: 0000000000000000
[42480.412420] RBP: 0000000000000004 R08: 0000000009000000 R09: 0000000110462228
[42480.412421] R10: 0000000111462228 R11: 0000000000081000 R12: 0000000044139228
[42480.412422] R13: 0000000000000002 R14: 00005654675810e0 R15: 0000000000000013
[42480.412422] FS:  00007f5b991fd6c0 GS:  0000000000000000
[42480.412423] NMI backtrace for cpu 75 skipped: idling at io_idle+0x3/0x30
[42480.412430] NMI backtrace for cpu 8
[42480.412433] CPU: 8 UID: 1000 PID: 1131396 Comm: expand Not tainted 7.3.6 #1 PREEMPT(lazy) 
[42480.412436] Hardware name:  TURIN2D16-2T/TURIN2D16-2T, BIOS 10.06 10/22/2025
[42480.412436] RIP: 0033:0x56546757799c
[42480.412439] Code: 0f b3 d1 48 8d 05 b4 6e 00 00 eb 19 66 90 48 8b 7c 24 28 c4 c2 b8 f3 c8 48 8d 05 9f 6e 00 00 0f 84 39 03 00 00 c4 c2 a8 f3 d8 <4d> 09 ca 44 89 d2 f7 d2 f7 c2 13 e0 30 01 0f 84 a4 06 00 00 4c 8b
[42480.412440] RSP: 002b:00007f5b891dcd20 EFLAGS: 00000203
[42480.412442] RAX: 000056546757e830 RBX: 000000000000004d RCX: 4000000000040004
[42480.412442] RDX: 0000000000000001 RSI: 000056546757f6b0 RDI: 000000011050ce40
[42480.412443] RBP: 0000000001fc9b06 R08: 00000000000000a0 R09: 000000011050ce00
[42480.412444] R10: 0000000000000020 R11: 0000000000040004 R12: 0000000044146720
[42480.412445] R13: 0000000000000002 R14: 00005654675810e0 R15: 0000000000000708
[42480.412445] FS:  00007f5b891dd6c0 GS:  0000000000000000
[42480.412446] NMI backtrace for cpu 72 skipped: idling at io_idle+0x3/0x30
[42480.412451] NMI backtrace for cpu 73 skipped: idling at io_idle+0x3/0x30
[42480.412456] NMI backtrace for cpu 10
[42480.412459] CPU: 10 UID: 1000 PID: 1131380 Comm: expand Not tainted 7.3.6 #1 PREEMPT(lazy) 
[42480.412462] Hardware name:  TURIN2D16-2T/TURIN2D16-2T, BIOS 10.06 10/22/2025
[42480.412462] RIP: 0033:0x565467577a0a
[42480.412465] Code: f3 4d 0f bc fb 31 ed 49 6b ff 70 4c 8d 6c 07 0c eb 18 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 48 83 c5 02 48 83 fd 0e 74 c6 <41> 8b 7c ed f4 48 83 ff 22 74 bb 48 0f a3 fa 72 11 41 8b 7c ed f8
[42480.412466] RSP: 002b:00007f5b921eed20 EFLAGS: 00000246
[42480.412468] RAX: 000056546757e830 RBX: 0000000000000000 RCX: 4000000100000010
[42480.412469] RDX: 40000001883428b1 RSI: fffffffe77cfc74e RDI: 0000000000000e00
[42480.412469] RBP: 0000000000000000 R08: 00000000000c0000 R09: 00000000883028a1
[42480.412470] R10: 00000000883428a1 R11: 0000000100000000 R12: 0000000044181c51
[42480.412471] R13: 000056546757f63c R14: 00005654675810e0 R15: 0000000000000020
[42480.412472] FS:  00007f5b921ef6c0 GS:  0000000000000000
[42480.412472] NMI backtrace for cpu 74 skipped: idling at io_idle+0x3/0x30
[42480.412478] NMI backtrace for cpu 52
[42480.412485] CPU: 52 UID: 1000 PID: 1131420 Comm: expand Not tainted 7.3.6 #1 PREEMPT(lazy) 
[42480.412489] Hardware name:  TURIN2D16-2T/TURIN2D16-2T, BIOS 10.06 10/22/2025
[42480.412490] RIP: 0033:0x565467577cd5
[42480.412497] Code: 8d 14 40 48 c1 ea 20 48 83 fa 01 0f 84 c4 fc ff ff 83 fa 02 0f 84 8f 03 00 00 b0 01 89 44 24 38 e9 b0 fc ff ff 48 8b 44 24 58 <48> 8b b4 24 90 00 00 00 c4 e2 f8 f3 c8 0f 85 68 fc ff ff 8b 44 24
[42480.412499] RSP: 002b:00007f5b7c1c2d20 EFLAGS: 00000246
[42480.412502] RAX: 00000001106a0808 RBX: 0000000000000022 RCX: 4000000000000012
[42480.412504] RDX: 0000000000000003 RSI: fffffffeef95f7e0 RDI: 00000001106a080d
[42480.412505] RBP: 0000000001fd0f36 R08: 0000000000000000 R09: 00000001106a080c
[42480.412505] R10: 00005654675791e0 R11: 0000000000000012 R12: 00000000441a8207
[42480.412506] R13: 0000000000000002 R14: 00005654675810e0 R15: 0000000000000206
[42480.412508] FS:  00007f5b7c1c36c0 GS:  0000000000000000
[42480.412509] NMI backtrace for cpu 55 skipped: idling at io_idle+0x3/0x30
[42480.412519] NMI backtrace for cpu 119
[42480.412521] CPU: 119 UID: 1000 PID: 1131514 Comm: ps Not tainted 7.3.6 #1 PREEMPT(lazy) 
[42480.412524] Hardware name:  TURIN2D16-2T/TURIN2D16-2T, BIOS 10.06 10/22/2025
[42480.412525] RIP: 0010:pid_revalidate+0x20/0x80
[42480.412531] Code: 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa 0f 1f 44 00 00 55 53 48 89 d3 e8 bd f2 c1 ff 48 8b 5b 30 48 85 db 74 49 48 8b 7b b8 <31> f6 e8 d9 b4 b9 ff 48 89 c5 48 85 c0 74 36 0f b7 33 48 89 c7 48
[42480.412533] RSP: 0018:ff83ab31e0d6f8c8 EFLAGS: 00000282
[42480.412534] RAX: 0000000000000002 RBX: ff31992befeed2c8 RCX: 0000000000010101
[42480.412535] RDX: ff31993e5813c200 RSI: ff83ab31e0d6f990 RDI: ff31991f0778c300
[42480.412536] RBP: ff319932b5718600 R08: 0000000074617473 R09: ff31993e822d3380
[42480.412537] R10: 0000000000000020 R11: 0000000000000002 R12: ff31993e822d3380
[42480.412538] R13: ff83ab31e0d6f990 R14: ff83ab31e0d6f980 R15: ff31993e5de27bd8
[42480.412538] FS:  00007f7681532500(0000) GS:ff31995e1e0fc000(0000) knlGS:0000000000000000
[42480.412539] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[42480.412540] CR2: 0000561f987cc008 CR3: 0000002d80ca8003 CR4: 0000000000f71ef0
[42480.412540] PKRU: 55555554
[42480.412541] Call Trace:
[42480.412544]  <TASK>
[42480.412547]  lookup_fast+0x66/0x100
[42480.412553]  path_openat+0x2e7/0xa00
[42480.412556]  do_file_open+0xf1/0x1a0
[42480.412558]  ? alloc_fd+0x113/0x180
[42480.412562]  do_sys_openat2+0x80/0xe0
[42480.412566]  __x64_sys_openat+0x54/0xa0
[42480.412567]  do_syscall_64+0xc0/0x550
[42480.412571]  ? do_syscall_64+0xf9/0x550
[42480.412573]  ? do_sys_openat2+0x9f/0xe0
[42480.412574]  ? __x64_sys_openat+0x54/0xa0
[42480.412575]  ? do_syscall_64+0xf9/0x550
[42480.412576]  ? __memcg_slab_free_hook+0x159/0x1b0
[42480.412579]  ? __x64_sys_close+0x3d/0x80
[42480.412581]  ? kmem_cache_free+0x253/0x3c0
[42480.412584]  ? __x64_sys_close+0x3d/0x80
[42480.412585]  ? do_syscall_64+0xf9/0x550
[42480.412586]  ? __x64_sys_close+0x3d/0x80
[42480.412587]  ? do_syscall_64+0xf9/0x550
[42480.412589]  ? ksys_read+0x6b/0xe0
[42480.412590]  ? do_syscall_64+0xf9/0x550
[42480.412592]  ? do_syscall_64+0xf9/0x550
[42480.412593]  ? do_syscall_64+0xf9/0x550
[42480.412594]  ? do_syscall_64+0x35/0x550
[42480.412595]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[42480.412599] RIP: 0033:0x7f76817d73a7
[42480.412600] Code: 48 89 fa 4c 89 df e8 78 b3 00 00 8b 93 08 03 00 00 59 5e 48 83 f8 fc 74 1a 5b c3 0f 1f 84 00 00 00 00 00 48 8b 44 24 10 0f 05 <5b> c3 0f 1f 80 00 00 00 00 83 e2 39 83 fa 08 75 de e8 23 ff ff ff
[42480.412601] RSP: 002b:00007ffec8b769d0 EFLAGS: 00000202 ORIG_RAX: 0000000000000101
[42480.412602] RAX: ffffffffffffffda RBX: 00007f7681532500 RCX: 00007f76817d73a7
[42480.412602] RDX: 0000000000000000 RSI: 00007ffec8b76a80 RDI: ffffffffffffff9c
[42480.412603] RBP: 00007f7681532270 R08: 0000000000000000 R09: 0000000000000000
[42480.412603] R10: 0000000000000000 R11: 0000000000000202 R12: 00007ffec8b76a80
[42480.412603] R13: 0000561f98790d18 R14: 0000000000000000 R15: 00007f7681531858
[42480.412605]  </TASK>
[42480.412606] NMI backtrace for cpu 117 skipped: idling at io_idle+0x3/0x30
[42480.412611] NMI backtrace for cpu 53
[42480.412612] CPU: 53 UID: 1000 PID: 1131411 Comm: expand Not tainted 7.3.6 #1 PREEMPT(lazy) 
[42480.412614] Hardware name:  TURIN2D16-2T/TURIN2D16-2T, BIOS 10.06 10/22/2025
[42480.412615] RIP: 0033:0x565467577553
[42480.412616] Code: 04 31 c9 4c 89 94 24 90 00 00 00 eb 27 48 8b b4 24 88 00 00 00 48 8b 7c 24 28 b1 01 66 66 2e 0f 1f 84 00 00 00 00 00 49 ff c5 <49> 83 fd 07 0f 84 63 03 00 00 43 8b 6c ea fc 48 83 fd 22 0f 84 54
[42480.412617] RSP: 002b:00007f5b819cdd20 EFLAGS: 00000203
[42480.412619] RAX: 0000000029161f01 RBX: 00005654675ef0e0 RCX: 0000000000000000
[42480.412619] RDX: 000056546757d6d0 RSI: 0000000000000001 RDI: 000000011060302b
[42480.412620] RBP: 0000000000000005 R08: 0000000000000001 R09: 40000001106030af
[42480.412620] R10: 000056546757d85c R11: 00005654675e10e0 R12: 0000000044180c17
[42480.412621] R13: 0000000000000001 R14: 00005654675810e0 R15: 00005654675890e0
[42480.412621] FS:  00007f5b819ce6c0 GS:  0000000000000000
[42480.412622] NMI backtrace for cpu 54
[42480.412625] CPU: 54 UID: 1000 PID: 1131372 Comm: expand Not tainted 7.3.6 #1 PREEMPT(lazy) 
[42480.412627] Hardware name:  TURIN2D16-2T/TURIN2D16-2T, BIOS 10.06 10/22/2025
[42480.412628] RIP: 0033:0x565467577caa
[42480.412630] Code: 48 be cd cc cc cc cc cc cc cc c4 e2 cb f6 f6 48 c1 ee 02 0f b6 04 30 8d 34 b6 29 f2 48 8d 35 0d 7a 00 00 0f b6 c0 0f af 04 96 <48> 8d 14 40 48 c1 ea 20 48 83 fa 01 0f 84 c4 fc ff ff 83 fa 02 0f
[42480.412631] RSP: 002b:00007f5b961f6d20 EFLAGS: 00000206
[42480.412633] RAX: 0000000000000000 RBX: 0000000000000085 RCX: 4000000004000010
[42480.412633] RDX: 0000000000000003 RSI: 000056546757f6b0 RDI: 0000000000000001
[42480.412634] RBP: 0000000001fcf566 R08: 0000000000000003 R09: 0000000110323204
[42480.412635] R10: 00005654675791e0 R11: 0000000004000010 R12: 0000000044193904
[42480.412635] R13: 0000000000000002 R14: 00005654675810e0 R15: 0000000000000105
[42480.412636] FS:  00007f5b961f76c0 GS:  0000000000000000
[42480.412636] NMI backtrace for cpu 116 skipped: idling at io_idle+0x3/0x30
[42480.412640] NMI backtrace for cpu 118 skipped: idling at io_idle+0x3/0x30
[42480.412645] NMI backtrace for cpu 45 skipped: idling at io_idle+0x3/0x30
[42480.412661] NMI backtrace for cpu 44
[42480.412667] CPU: 44 UID: 1000 PID: 1131392 Comm: expand Not tainted 7.3.6 #1 PREEMPT(lazy) 
[42480.412670] Hardware name:  TURIN2D16-2T/TURIN2D16-2T, BIOS 10.06 10/22/2025
[42480.412672] RIP: 0033:0x565467577553
[42480.412678] Code: 04 31 c9 4c 89 94 24 90 00 00 00 eb 27 48 8b b4 24 88 00 00 00 48 8b 7c 24 28 b1 01 66 66 2e 0f 1f 84 00 00 00 00 00 49 ff c5 <49> 83 fd 07 0f 84 63 03 00 00 43 8b 6c ea fc 48 83 fd 22 0f 84 54
[42480.412679] RSP: 002b:00007f5b8b1e0d20 EFLAGS: 00000203
[42480.412682] RAX: 000000001f9add01 RBX: 00005654675ef0e0 RCX: 0000000000000000
[42480.412683] RDX: 000056546757d6d0 RSI: 0000000000000001 RDI: 0000000110511161
[42480.412684] RBP: 0000000000000006 R08: 0000000000000001 R09: 4000000110551361
[42480.412685] R10: 000056546757dac4 R11: 00005654675e10e0 R12: 0000000044148961
[42480.412686] R13: 0000000000000002 R14: 00005654675810e0 R15: 00005654675890e0
[42480.412687] FS:  00007f5b8b1e16c0 GS:  0000000000000000
[42480.412688] NMI backtrace for cpu 109
[42480.412690] CPU: 109 UID: 1000 PID: 1131363 Comm: expand Not tainted 7.3.6 #1 PREEMPT(lazy) 
[42480.412692] Hardware name:  TURIN2D16-2T/TURIN2D16-2T, BIOS 10.06 10/22/2025
[42480.412693] RIP: 0033:0x565467577c97
[42480.412695] Code: 13 4c 8d 15 6b 15 00 00 48 c1 e6 04 4c 01 d6 48 03 14 fe 48 be cd cc cc cc cc cc cc cc c4 e2 cb f6 f6 48 c1 ee 02 0f b6 04 30 <8d> 34 b6 29 f2 48 8d 35 0d 7a 00 00 0f b6 c0 0f af 04 96 48 8d 14
[42480.412697] RSP: 002b:00007f5b911ecd20 EFLAGS: 00000216
[42480.412698] RAX: 000000000000005a RBX: 00000000000000be RCX: 4000000000010080
[42480.412699] RDX: 0000000ee2497589 RSI: 00000002fa0eb11b RDI: 0000000000000001
[42480.412700] RBP: 0000000001fdf159 R08: 0000000000800000 R09: 0000000110189046
[42480.412700] R10: 00005654675791e0 R11: 0000000000010080 R12: 0000000044164846
[42480.412701] R13: 0000000000000002 R14: 00005654675810e0 R15: 0000000000000046
[42480.412701] FS:  00007f5b911ed6c0 GS:  0000000000000000
[42480.412702] NMI backtrace for cpu 46 skipped: idling at io_idle+0x3/0x30
[42480.412708] NMI backtrace for cpu 110
[42480.412710] CPU: 110 UID: 1000 PID: 1131395 Comm: expand Not tainted 7.3.6 #1 PREEMPT(lazy) 
[42480.412712] Hardware name:  TURIN2D16-2T/TURIN2D16-2T, BIOS 10.06 10/22/2025
[42480.412713] RIP: 0033:0x56546757718c
[42480.412715] Code: c1 48 0f 45 fa 0f 95 c0 41 0f 94 c1 4c 89 c2 48 89 bc 24 80 00 00 00 20 c8 48 8b 0d 4e 9f 00 00 48 bf cd cc cc cc cc cc cc cc <49> 01 f1 48 8d 35 1a 85 00 00 c4 e2 eb f6 d7 4c 89 4c 24 50 4c 89
[42480.412716] RSP: 002b:00007f5b899ddd20 EFLAGS: 00000202
[42480.412717] RAX: 0000000000000001 RBX: 0000000000000093 RCX: 00007f5b9a200000
[42480.412718] RDX: 0000000eded27b4d RSI: 0000000001fd2755 RDI: cccccccccccccccd
[42480.412718] RBP: 0000000001645638 R08: 0000000eded27b4d R09: 0000000000000000
[42480.412719] R10: 00005654675791e0 R11: 0000000000002020 R12: 00000000441c8944
[42480.412719] R13: 0000000000000000 R14: 00005654675810e0 R15: 0000000000000144
[42480.412720] FS:  00007f5b899de6c0 GS:  0000000000000000
[42480.412722] NMI backtrace for cpu 111
[42480.412725] CPU: 111 UID: 1000 PID: 1131415 Comm: expand Not tainted 7.3.6 #1 PREEMPT(lazy) 
[42480.412727] Hardware name:  TURIN2D16-2T/TURIN2D16-2T, BIOS 10.06 10/22/2025
[42480.412728] RIP: 0033:0x565467577f6e
[42480.412730] Code: 78 f7 fb 41 81 e5 ff 07 00 00 48 c1 eb 16 f3 41 0f b8 ed f3 41 0f b8 c7 01 e8 c1 e5 0e 48 01 f5 48 8d 35 75 11 01 00 c1 e0 0d <4e> 8b 7c fd 00 4e 03 3c ee 48 8d 35 62 91 06 00 48 01 f0 4c 03 3c
[42480.412731] RSP: 002b:00007f5b7f9c9d20 EFLAGS: 00000216
[42480.412733] RAX: 000000000000e000 RBX: 0000000000000032 RCX: 00005654675791f0
[42480.412734] RDX: 0000000000022000 RSI: 00005654675890e0 RDI: 0000000000006000
[42480.412735] RBP: 00005654675990e0 R08: 0000000000020000 R09: 0000000000022000
[42480.412735] R10: 0000000000000107 R11: 0000000000020000 R12: 000000004415c190
[42480.412736] R13: 0000000000000105 R14: 00005654675810e0 R15: 000000000000003a
[42480.412736] FS:  00007f5b7f9ca6c0 GS:  0000000000000000
[42480.412737] NMI backtrace for cpu 47 skipped: idling at io_idle+0x3/0x30
[42480.412741] NMI backtrace for cpu 108 skipped: idling at io_idle+0x3/0x30
[42480.412745] NMI backtrace for cpu 107 skipped: idling at io_idle+0x3/0x30
[42480.412749] NMI backtrace for cpu 106 skipped: idling at io_idle+0x3/0x30
[42480.412755] NMI backtrace for cpu 42
[42480.412757] CPU: 42 UID: 1000 PID: 1131371 Comm: expand Not tainted 7.3.6 #1 PREEMPT(lazy) 
[42480.412759] Hardware name:  TURIN2D16-2T/TURIN2D16-2T, BIOS 10.06 10/22/2025
[42480.412759] RIP: 0033:0x565467577ac0
[42480.412762] Code: 75 d8 eb 17 66 0f 1f 44 00 00 48 b8 ff ff ff ff ff ff ff 3f 45 31 db 48 8d 50 01 48 b8 ff ff ff ff ff ff ff 3f f3 49 0f bc db <48> 8d 3c 02 4c 21 df 74 27 f3 4c 0f bc ff c1 e3 09 48 8d 05 e8 18
[42480.412763] RSP: 002b:00007f5b969f7d20 EFLAGS: 00000202
[42480.412765] RAX: 3fffffffffffffff RBX: 000000000000000c RCX: 4000000000021000
[42480.412766] RDX: 4000000000021000 RSI: 000056546757f6b0 RDI: 0000000000000022
[42480.412767] RBP: 0000000000000000 R08: 000000000000c000 R09: 000000010ca40141
[42480.412767] R10: 000000010ca44141 R11: 0000000000021000 R12: 0000000043290151
[42480.412768] R13: 0000000000000002 R14: 00005654675810e0 R15: 0000000000000011
[42480.412769] FS:  00007f5b969f86c0 GS:  0000000000000000
[42480.412770] NMI backtrace for cpu 104
[42480.412773] CPU: 104 UID: 1000 PID: 1131412 Comm: expand Not tainted 7.3.6 #1 PREEMPT(lazy) 
[42480.412775] Hardware name:  TURIN2D16-2T/TURIN2D16-2T, BIOS 10.06 10/22/2025
[42480.412776] RIP: 0033:0x565467577965
[42480.412778] Code: 08 01 48 f7 d6 48 89 f8 48 89 b4 24 90 00 00 00 48 89 4c 24 18 f3 48 0f bc d0 48 89 44 24 58 48 8d 05 c7 6d 00 00 4c 8b 04 d0 <49> 21 f0 0f 84 62 03 00 00 49 89 f9 49 0f b3 d1 48 8d 05 b4 6e 00
[42480.412779] RSP: 002b:00007f5b811ccd20 EFLAGS: 00000242
[42480.412781] RAX: 000056546757e728 RBX: 00000000000000d2 RCX: 4000000000002400
[42480.412782] RDX: 0000000000000000 RSI: fffffffef2ebd9ce RDI: 000000010d140231
[42480.412783] RBP: 00000000015efbda R08: 0000000000002000 R09: 0000000001f7ccf7
[42480.412783] R10: 00005654675791e0 R11: 0000000000080100 R12: 0000000043450231
[42480.412784] R13: 0000000000000002 R14: 00005654675810e0 R15: 0000000000000231
[42480.412785] FS:  00007f5b811cd6c0 GS:  0000000000000000
[42480.412786] NMI backtrace for cpu 41 skipped: idling at io_idle+0x3/0x30
[42480.412790] NMI backtrace for cpu 40 skipped: idling at io_idle+0x3/0x30
[42480.412795] NMI backtrace for cpu 100 skipped: idling at io_idle+0x3/0x30
[42480.412810] NMI backtrace for cpu 37
[42480.412817] CPU: 37 UID: 1000 PID: 1131423 Comm: expand Not tainted 7.3.6 #1 PREEMPT(lazy) 
[42480.412820] Hardware name:  TURIN2D16-2T/TURIN2D16-2T, BIOS 10.06 10/22/2025
[42480.412822] RIP: 0033:0x565467577cae
[42480.412828] Code: cc cc cc cc cc cc c4 e2 cb f6 f6 48 c1 ee 02 0f b6 04 30 8d 34 b6 29 f2 48 8d 35 0d 7a 00 00 0f b6 c0 0f af 04 96 48 8d 14 40 <48> c1 ea 20 48 83 fa 01 0f 84 c4 fc ff ff 83 fa 02 0f 84 8f 03 00
[42480.412830] RSP: 002b:00007f5b7a9bfd20 EFLAGS: 00000a17
[42480.412832] RAX: 00000000587e6ba0 RBX: 00000000000000dc RCX: 4000000000004200
[42480.412834] RDX: 00000001097b42e0 RSI: 000056546757f6b0 RDI: 0000000000000001
[42480.412835] RBP: 0000000001fc63dd R08: 0000000000008000 R09: 0000000110483064
[42480.412835] R10: 00005654675791e0 R11: 0000000000004200 R12: 0000000044121874
[42480.412836] R13: 0000000000000002 R14: 00005654675810e0 R15: 0000000000000064
[42480.412837] FS:  00007f5b7a9c06c0 GS:  0000000000000000
[42480.412839] NMI backtrace for cpu 102
[42480.412842] CPU: 102 UID: 1000 PID: 1131360 Comm: expand Not tainted 7.3.6 #1 PREEMPT(lazy) 
[42480.412845] Hardware name:  TURIN2D16-2T/TURIN2D16-2T, BIOS 10.06 10/22/2025
[42480.412846] RIP: 0033:0x565467577553
[42480.412849] Code: 04 31 c9 4c 89 94 24 90 00 00 00 eb 27 48 8b b4 24 88 00 00 00 48 8b 7c 24 28 b1 01 66 66 2e 0f 1f 84 00 00 00 00 00 49 ff c5 <49> 83 fd 07 0f 84 63 03 00 00 43 8b 6c ea fc 48 83 fd 22 0f 84 54
[42480.412851] RSP: 002b:00007f5b7c9c3d20 EFLAGS: 00000207
[42480.412854] RAX: 0000000000000000 RBX: 000000000000005a RCX: 0000000000000000
[42480.412856] RDX: 000000000000000f RSI: 0000000000000001 RDI: 0000000110612505
[42480.412857] RBP: 0000000000000008 R08: 0000000000000001 R09: 400000011061251d
[42480.412859] R10: 000056546757d7b4 R11: 0000000000000018 R12: 0000000044184945
[42480.412860] R13: 0000000000000005 R14: 00005654675810e0 R15: 0000000000000145
[42480.412861] FS:  00007f5b7c9c46c0 GS:  0000000000000000
[42480.412862] NMI backtrace for cpu 38 skipped: idling at io_idle+0x3/0x30
[42480.412867] NMI backtrace for cpu 36
[42480.412868] CPU: 36 UID: 1000 PID: 1131419 Comm: expand Not tainted 7.3.6 #1 PREEMPT(lazy) 
[42480.412870] Hardware name:  TURIN2D16-2T/TURIN2D16-2T, BIOS 10.06 10/22/2025
[42480.412871] RIP: 0033:0x565467577c97
[42480.412873] Code: 13 4c 8d 15 6b 15 00 00 48 c1 e6 04 4c 01 d6 48 03 14 fe 48 be cd cc cc cc cc cc cc cc c4 e2 cb f6 f6 48 c1 ee 02 0f b6 04 30 <8d> 34 b6 29 f2 48 8d 35 0d 7a 00 00 0f b6 c0 0f af 04 96 48 8d 14
[42480.412874] RSP: 002b:00007f5b7d1c4d20 EFLAGS: 00000213
[42480.412875] RAX: 0000000000000003 RBX: 00000000000000d6 RCX: 4000000080000100
[42480.412876] RDX: 0000000edcef88bd RSI: 00000002f8fcb4f2 RDI: 0000000000000001
[42480.412877] RBP: 0000000001fcb956 R08: 0000000000002000 R09: 00000001082bd000
[42480.412877] R10: 00005654675791e0 R11: 0000000080000100 R12: 00000000441de800
[42480.412878] R13: 0000000000000002 R14: 00005654675810e0 R15: 0000000000000000
[42480.412878] FS:  00007f5b7d1c56c0 GS:  0000000000000000
[42480.412879] NMI backtrace for cpu 101 skipped: idling at io_idle+0x3/0x30
[42480.412884] NMI backtrace for cpu 103 skipped: idling at io_idle+0x3/0x30
[42480.412889] NMI backtrace for cpu 39
[42480.412891] CPU: 39 UID: 1000 PID: 1131377 Comm: expand Not tainted 7.3.6 #1 PREEMPT(lazy) 
[42480.412893] Hardware name:  TURIN2D16-2T/TURIN2D16-2T, BIOS 10.06 10/22/2025
[42480.412894] RIP: 0033:0x565467577c75
[42480.412897] Code: ff ff f3 49 0f b8 fb 48 8b 05 77 94 00 00 48 8b 4c 24 18 41 bd 02 00 00 00 41 8d 74 32 0b 41 8d 7c 3a 13 4c 8d 15 6b 15 00 00 <48> c1 e6 04 4c 01 d6 48 03 14 fe 48 be cd cc cc cc cc cc cc cc c4
[42480.412898] RSP: 002b:00007f5b939f1d20 EFLAGS: 00000202
[42480.412899] RAX: 00007f5b9a200000 RBX: 00000000000000e1 RCX: 4000000000080200
[42480.412900] RDX: 00000008b9769951 RSI: 0000000000000001 RDI: 0000000000000001
[42480.412901] RBP: 0000000001fcb06b R08: 000000000000400a R09: 0000000110528124
[42480.412902] R10: 00005654675791e0 R11: 0000000000080200 R12: 0000000044154134
[42480.412902] R13: 0000000000000002 R14: 00005654675810e0 R15: 0000000000000126
[42480.412903] FS:  00007f5b939f26c0 GS:  0000000000000000
[42480.412905] NMI backtrace for cpu 56
[42480.412913] CPU: 56 UID: 1000 PID: 1131382 Comm: expand Not tainted 7.3.6 #1 PREEMPT(lazy) 
[42480.412916] Hardware name:  TURIN2D16-2T/TURIN2D16-2T, BIOS 10.06 10/22/2025
[42480.412919] RIP: 0033:0x565467577bff
[42480.412925] Code: 81 e7 ff 07 00 00 48 c1 e8 16 f3 41 0f b8 ef f3 0f b8 f7 01 ee c1 e5 0e 48 01 cd 48 8d 0d e9 14 01 00 c1 e6 0d 48 8b 6c fd 00 <4a> 03 2c f9 48 8d 0d d6 94 06 00 48 01 ce 48 03 2c c6 4d 85 ed 75
[42480.412927] RSP: 002b:00007f5b909ebd20 EFLAGS: 00000216
[42480.412929] RAX: 0000000000000090 RBX: 00000000000000ad RCX: 00005654675890e0
[42480.412930] RDX: 4000000000040040 RSI: 0000000000010000 RDI: 0000000000000248
[42480.412931] RBP: 00000000000243c5 R08: 0000000080000000 R09: 0000000010488a2a
[42480.412932] R10: 0000000090488a2a R11: 0000000000040040 R12: 000000004412452a
[42480.412933] R13: 0000000000040000 R14: 00005654675810e0 R15: 000000000000052a
[42480.412934] FS:  00007f5b909ec6c0 GS:  0000000000000000
[42480.412935] NMI backtrace for cpu 57 skipped: idling at io_idle+0x3/0x30
[42480.412946] NMI backtrace for cpu 59 skipped: idling at io_idle+0x3/0x30
[42480.412952] NMI backtrace for cpu 123 skipped: idling at io_idle+0x3/0x30
[42480.412955] NMI backtrace for cpu 120 skipped: idling at io_idle+0x3/0x30
[42480.412959] NMI backtrace for cpu 121
[42480.412961] CPU: 121 UID: 1000 PID: 1131404 Comm: expand Not tainted 7.3.6 #1 PREEMPT(lazy) 
[42480.412963] Hardware name:  TURIN2D16-2T/TURIN2D16-2T, BIOS 10.06 10/22/2025
[42480.412964] RIP: 0033:0x56546757713b
[42480.412966] Code: 8c 24 a8 00 00 00 89 74 24 6c eb 32 0f 1f 00 4c 8d 2c 49 49 c1 ed 20 48 8b 94 24 80 00 00 00 44 89 e9 48 ff 84 cc f0 00 00 00 <49> ff c0 48 ff c2 4c 3b 84 24 a0 00 00 00 0f 84 81 fd ff ff 45 31
[42480.412967] RSP: 002b:00007f5b851d4d20 EFLAGS: 00000202
[42480.412968] RAX: 000000000ca45801 RBX: 00000000000000a2 RCX: 0000000000000001
[42480.412969] RDX: 00000000000002b6 RSI: 000056546757f6b0 RDI: 0000000000000001
[42480.412970] RBP: 0000000001642041 R08: 0000000edde58b3a R09: 0000000001fcf15e
[42480.412970] R10: 00005654675791e0 R11: 00000000000000c0 R12: 0000000044190256
[42480.412971] R13: 0000000000000001 R14: 00005654675810e0 R15: 0000000000000256
[42480.412971] FS:  00007f5b851d56c0 GS:  0000000000000000
[42480.412973] NMI backtrace for cpu 122 skipped: idling at io_idle+0x3/0x30
[42480.412978] NMI backtrace for cpu 58
[42480.412980] CPU: 58 UID: 1000 PID: 1131400 Comm: expand Not tainted 7.3.6 #1 PREEMPT(lazy) 
[42480.412982] Hardware name:  TURIN2D16-2T/TURIN2D16-2T, BIOS 10.06 10/22/2025
[42480.412982] RIP: 0033:0x565467577c97
[42480.412985] Code: 13 4c 8d 15 6b 15 00 00 48 c1 e6 04 4c 01 d6 48 03 14 fe 48 be cd cc cc cc cc cc cc cc c4 e2 cb f6 f6 48 c1 ee 02 0f b6 04 30 <8d> 34 b6 29 f2 48 8d 35 0d 7a 00 00 0f b6 c0 0f af 04 96 48 8d 14
[42480.412986] RSP: 002b:00007f5b871d8d20 EFLAGS: 00000216
[42480.412987] RAX: 0000000000000027 RBX: 0000000000000036 RCX: 4000000002000002
[42480.412988] RDX: 0000000e61d40c01 RSI: 00000002e05d9c00 RDI: 0000000000000001
[42480.412989] RBP: 0000000001e0af6f R08: 0000000024000000 R09: 000000010024b830
[42480.412989] R10: 00005654675791e0 R11: 0000000002000002 R12: 0000000044125c18
[42480.412989] R13: 0000000000000002 R14: 00005654675810e0 R15: 0000000000000418
[42480.412990] FS:  00007f5b871d96c0 GS:  0000000000000000
[42480.412991] NMI backtrace for cpu 49
[42480.413001] CPU: 49 UID: 1000 PID: 1131361 Comm: expand Not tainted 7.3.6 #1 PREEMPT(lazy) 
[42480.413005] Hardware name:  TURIN2D16-2T/TURIN2D16-2T, BIOS 10.06 10/22/2025
[42480.413007] RIP: 0033:0x565467577ae0
[42480.413014] Code: ff ff ff ff 3f f3 49 0f bc db 48 8d 3c 02 4c 21 df 74 27 f3 4c 0f bc ff c1 e3 09 48 8d 05 e8 18 00 00 48 01 c3 42 8b 7c fb 04 <42> 8b 1c fb 83 ff 02 74 27 83 ff 01 74 66 eb 0a 83 fb 13 77 58 83
[42480.413017] RSP: 002b:00007f5b8d1e4d20 EFLAGS: 00000206
[42480.413020] RAX: 00005654675793c0 RBX: 00005654675797c0 RCX: 4000000001000004
[42480.413022] RDX: 4000000001000004 RSI: fffffffeeed9aee9 RDI: 0000000000000000
[42480.413023] RBP: 0000000000000000 R08: 0000000000080800 R09: 0000000110264112
[42480.413023] R10: 0000000110264912 R11: 0000000001000004 R12: 000000004413288a
[42480.413024] R13: 0000000000000002 R14: 00005654675810e0 R15: 0000000000000018
[42480.413025] FS:  00007f5b8d1e56c0 GS:  0000000000000000
[42480.413027] NMI backtrace for cpu 113
[42480.413029] CPU: 113 UID: 0 PID: 1716 Comm: kworker/113:1H Not tainted 7.3.6 #1 PREEMPT(lazy) 
[42480.413031] Hardware name:  TURIN2D16-2T/TURIN2D16-2T, BIOS 10.06 10/22/2025
[42480.413032] Workqueue:  0x0 (kblockd)
[42480.413035] RIP: 0010:pick_task_fair+0x1de/0x740
[42480.413041] Code: 00 00 85 d2 0f 85 11 01 00 00 49 89 ce 8b 54 24 34 85 d2 0f 84 02 01 00 00 4d 8b 6d 00 4d 85 ed 0f 84 f1 03 00 00 41 8b 7d 50 <e8> 3d e9 06 00 48 8b 15 5e 6e 6f 01 b9 01 00 00 00 48 85 c0 48 0f
[42480.413043] RSP: 0018:ff83ab31a17a7db0 EFLAGS: 00000086
[42480.413044] RAX: 0000000000000248 RBX: 0000000100a0e758 RCX: 000026a2bdd668a0
[42480.413045] RDX: 0000000000000001 RSI: 0000000100a0e758 RDI: 0000000000000080
[42480.413046] RBP: ff31995dcbc71340 R08: 0000000000000002 R09: 0000000000000000
[42480.413047] R10: ff31993e5787e400 R11: 0000000000000248 R12: 0000000000000071
[42480.413047] R13: ff31993e57883c00 R14: 000026a2bdd668a0 R15: ff31995dcbc712c0
[42480.413049] FS:  0000000000000000(0000) GS:ff31995e1df7c000(0000) knlGS:0000000000000000
[42480.413050] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[42480.413050] CR2: 00007f5e7cb30e64 CR3: 0000002148eef004 CR4: 0000000000f71ef0
[42480.413051] PKRU: 55555554
[42480.413052] Call Trace:
[42480.413055]  <TASK>
[42480.413058]  ? sched_clock+0x11/0x30
[42480.413066]  __schedule+0x281/0x10b0
[42480.413073]  schedule+0x28/0xa0
[42480.413075]  worker_thread+0xa4/0x320
[42480.413079]  ? __pfx_worker_thread+0x10/0x10
[42480.413080]  kthread+0xe5/0x120
[42480.413084]  ? __pfx_kthread+0x10/0x10
[42480.413086]  ret_from_fork+0x2b7/0x340
[42480.413088]  ? __pfx_kthread+0x10/0x10
[42480.413090]  ret_from_fork_asm+0x1a/0x30
[42480.413095]  </TASK>
[42480.413097] NMI backtrace for cpu 50
[42480.413100] CPU: 50 UID: 1000 PID: 1131421 Comm: expand Not tainted 7.3.6 #1 PREEMPT(lazy) 
[42480.413102] Hardware name:  TURIN2D16-2T/TURIN2D16-2T, BIOS 10.06 10/22/2025
[42480.413102] RIP: 0033:0x565467578037
[42480.413105] Code: 83 fa 01 0f 85 ea fd ff ff c6 44 24 48 01 80 7c 24 48 00 41 bd 01 00 00 00 75 12 48 8b 44 24 38 f6 d0 44 0f b6 e8 41 83 e5 01 <45> 01 ed 4c 8b 44 24 20 45 85 ed 75 15 b0 01 45 31 ed e9 da f0 ff
[42480.413106] RSP: 002b:00007f5b7b9c1d20 EFLAGS: 00000246
[42480.413107] RAX: 000000001c71c7fe RBX: 000000000000008c RCX: 00005654675791f0
[42480.413108] RDX: 0000000000000000 RSI: 00005654675e10e0 RDI: 0000000000000000
[42480.413109] RBP: 00005654675950e0 R08: 0000000000000200 R09: 000056546757f6b0
[42480.413110] R10: 00000000ffffffec R11: 0000000020000000 R12: 0000000044128466
[42480.413110] R13: 0000000000000000 R14: 00005654675810e0 R15: 00000000015e8e78
[42480.413111] FS:  00007f5b7b9c26c0 GS:  0000000000000000
[42480.413111] NMI backtrace for cpu 48 skipped: idling at io_idle+0x3/0x30
[42480.413119] NMI backtrace for cpu 114 skipped: idling at io_idle+0x3/0x30
[42480.413123] NMI backtrace for cpu 115 skipped: idling at io_idle+0x3/0x30
[42480.413129] NMI backtrace for cpu 112
[42480.413131] CPU: 112 UID: 1000 PID: 1131399 Comm: expand Not tainted 7.3.6 #1 PREEMPT(lazy) 
[42480.413133] Hardware name:  TURIN2D16-2T/TURIN2D16-2T, BIOS 10.06 10/22/2025
[42480.413134] RIP: 0033:0x565467577c97
[42480.413137] Code: 13 4c 8d 15 6b 15 00 00 48 c1 e6 04 4c 01 d6 48 03 14 fe 48 be cd cc cc cc cc cc cc cc c4 e2 cb f6 f6 48 c1 ee 02 0f b6 04 30 <8d> 34 b6 29 f2 48 8d 35 0d 7a 00 00 0f b6 c0 0f af 04 96 48 8d 14
[42480.413138] RSP: 002b:00007f5b879d9d20 EFLAGS: 00000216
[42480.413139] RAX: 000000000000006f RBX: 0000000000000076 RCX: 4000000000000090
[42480.413140] RDX: 0000000edde92001 RSI: 00000002f92ea000 RDI: 0000000000000001
[42480.413141] RBP: 0000000001fcf22f R08: 0000000000040000 R09: 0000000110601560
[42480.413141] R10: 00005654675791e0 R11: 0000000000000090 R12: 00000000441a0570
[42480.413141] R13: 0000000000000002 R14: 00005654675810e0 R15: 0000000000000570
[42480.413142] FS:  00007f5b879da6c0 GS:  0000000000000000
[42480.413143] NMI backtrace for cpu 51
[42480.413144] CPU: 51 UID: 1000 PID: 1131393 Comm: expand Not tainted 7.3.6 #1 PREEMPT(lazy) 
[42480.413146] Hardware name:  TURIN2D16-2T/TURIN2D16-2T, BIOS 10.06 10/22/2025
[42480.413147] RIP: 0033:0x565467577a19
[42480.413148] Code: 0c eb 18 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 48 83 c5 02 48 83 fd 0e 74 c6 41 8b 7c ed f4 48 83 ff 22 74 bb 48 0f a3 fa <72> 11 41 8b 7c ed f8 48 83 ff 22 74 b3 49 0f a3 fa 72 ad 41 8b 7c
[42480.413149] RSP: 002b:00007f5b8a9dfd20 EFLAGS: 00000286
[42480.413151] RAX: 000056546757e830 RBX: 0000000000000000 RCX: 4000000000000404
[42480.413151] RDX: 4000000110941674 RSI: fffffffeefabe98b RDI: 0000000000000003
[42480.413152] RBP: 0000000000000000 R08: 0000000000800000 R09: 0000000110141270
[42480.413153] R10: 0000000110941270 R11: 0000000000000404 R12: 0000000044150538
[42480.413153] R13: 000056546757e91c R14: 00005654675810e0 R15: 0000000000000002
[42480.413153] FS:  00007f5b8a9e06c0 GS:  0000000000000000
[42480.413155] NMI backtrace for cpu 33 skipped: idling at io_idle+0x3/0x30
[42480.413171] NMI backtrace for cpu 97
[42480.413175] CPU: 97 UID: 1000 PID: 1131413 Comm: expand Not tainted 7.3.6 #1 PREEMPT(lazy) 
[42480.413179] Hardware name:  TURIN2D16-2T/TURIN2D16-2T, BIOS 10.06 10/22/2025
[42480.413181] RIP: 0033:0x565467577a31
[42480.413186] Code: 0e 74 c6 41 8b 7c ed f4 48 83 ff 22 74 bb 48 0f a3 fa 72 11 41 8b 7c ed f8 48 83 ff 22 74 b3 49 0f a3 fa 72 ad 41 8b 7c ed fc <48> 83 ff 22 74 99 48 0f a3 fa 72 c3 41 8b 7c ed 00 48 83 ff 22 74
[42480.413188] RSP: 002b:00007f5b809cbd20 EFLAGS: 00000297
[42480.413191] RAX: 000056546757e830 RBX: 0000000000000000 RCX: 4000000000004001
[42480.413193] RDX: 40000001108d7203 RSI: fffffffeefb28dfc RDI: 000000000000000d
[42480.413195] RBP: 0000000000000000 R08: 0000000000800000 R09: 00000001100d3202
[42480.413196] R10: 00000001108d3202 R11: 0000000000004000 R12: 0000000044135901
[42480.413197] R13: 000056546757ee5c R14: 00005654675810e0 R15: 000000000000000e
[42480.413199] FS:  00007f5b809cc6c0 GS:  0000000000000000
[42480.413200] NMI backtrace for cpu 34 skipped: idling at io_idle+0x3/0x30
[42480.413207] NMI backtrace for cpu 98
[42480.413208] CPU: 98 UID: 1000 PID: 1131402 Comm: expand Not tainted 7.3.6 #1 PREEMPT(lazy) 
[42480.413211] Hardware name:  TURIN2D16-2T/TURIN2D16-2T, BIOS 10.06 10/22/2025
[42480.413212] RIP: 0033:0x565467577c3b
[42480.413215] Code: 4d 85 ed 75 1a 48 8d 44 ad 00 48 c1 ea 3e 48 8d 04 83 48 8d 14 42 eb 19 0f 1f 80 00 00 00 00 48 69 c5 19 01 00 00 48 c1 ea 3e <48> 01 d8 48 8d 14 82 f3 49 0f b8 f2 41 ba ec ff ff ff f3 49 0f b8
[42480.413216] RSP: 002b:00007f5b861d6d20 EFLAGS: 00000212
[42480.413218] RAX: 000000022e799163 RBX: 00000000000000ca RCX: 00005654675e10e0
[42480.413219] RDX: 0000000000000001 RSI: 00005654675f10e0 RDI: 00000000000002da
[42480.413220] RBP: 0000000001fcc9db R08: 00000000000000b8 R09: 00000001105b4002
[42480.413221] R10: 00000001105b400a R11: 0000000000000900 R12: 000000004416d042
[42480.413221] R13: 0000000000000800 R14: 00005654675810e0 R15: 000000000000000a
[42480.413222] FS:  00007f5b861d76c0 GS:  0000000000000000
[42480.413223] NMI backtrace for cpu 96
[42480.413226] CPU: 96 UID: 1000 PID: 1131410 Comm: expand Not tainted 7.3.6 #1 PREEMPT(lazy) 
[42480.413229] Hardware name:  TURIN2D16-2T/TURIN2D16-2T, BIOS 10.06 10/22/2025
[42480.413230] RIP: 0033:0x565467577cb2
[42480.413232] Code: cc cc c4 e2 cb f6 f6 48 c1 ee 02 0f b6 04 30 8d 34 b6 29 f2 48 8d 35 0d 7a 00 00 0f b6 c0 0f af 04 96 48 8d 14 40 48 c1 ea 20 <48> 83 fa 01 0f 84 c4 fc ff ff 83 fa 02 0f 84 8f 03 00 00 b0 01 89
[42480.413233] RSP: 002b:00007f5b821ced20 EFLAGS: 00000256
[42480.413235] RAX: 0000000000000000 RBX: 0000000000000012 RCX: 40000000000c0000
[42480.413236] RDX: 0000000000000000 RSI: 000056546757f6b0 RDI: 0000000000000000
[42480.413237] RBP: 0000000002f053e7 R08: 0000000000008000 R09: 0000000110511824
[42480.413239] R10: 00005654675791e0 R11: 0000000000040000 R12: 0000000044151834
[42480.413240] R13: 0000000000000002 R14: 00005654675810e0 R15: 0000000000000024
[42480.413241] FS:  00007f5b821cf6c0 GS:  0000000000000000
[42480.413243] NMI backtrace for cpu 99 skipped: idling at io_idle+0x3/0x30
[42480.413249] NMI backtrace for cpu 35
[42480.413251] CPU: 35 UID: 1000 PID: 1131409 Comm: expand Not tainted 7.3.6 #1 PREEMPT(lazy) 
[42480.413254] Hardware name:  TURIN2D16-2T/TURIN2D16-2T, BIOS 10.06 10/22/2025
[42480.413255] RIP: 0033:0x565467577ffb
[42480.413257] Code: cc cc cc cc cc cc c4 42 b3 f6 c9 49 c1 e9 02 42 0f b6 04 08 47 8d 0c 89 44 29 ca 4c 8d 0d bd 76 00 00 0f b6 c0 41 0f af 04 91 <48> 8d 14 40 48 c1 ea 20 48 83 fa 02 0f 84 fa fd ff ff 83 fa 01 0f
[42480.413258] RSP: 002b:00007f5b829cfd20 EFLAGS: 00000202
[42480.413260] RAX: 0000000000000000 RBX: 0000000000000110 RCX: 00005654675791f0
[42480.413260] RDX: 0000000000000004 RSI: 00005654675e10e0 RDI: 0000000000010440
[42480.413261] RBP: 00005654675990e0 R08: 0000000000000004 R09: 000056546757f6b0
[42480.413261] R10: 00000000ffffffec R11: 0000000000000040 R12: 000000004419a602
[42480.413262] R13: 0000000000000602 R14: 00005654675810e0 R15: 0000000001fcffee
[42480.413262] FS:  00007f5b829d06c0 GS:  0000000000000000
[42480.413263] NMI backtrace for cpu 32 skipped: idling at io_idle+0x3/0x30
[42480.413268] NMI backtrace for cpu 60 skipped: idling at io_idle+0x3/0x30
[42480.413283] NMI backtrace for cpu 124
[42480.413288] CPU: 124 UID: 1000 PID: 1131416 Comm: expand Not tainted 7.3.6 #1 PREEMPT(lazy) 
[42480.413291] Hardware name:  TURIN2D16-2T/TURIN2D16-2T, BIOS 10.06 10/22/2025
[42480.413293] RIP: 0033:0x565467577562
[42480.413298] Code: b4 24 88 00 00 00 48 8b 7c 24 28 b1 01 66 66 2e 0f 1f 84 00 00 00 00 00 49 ff c5 49 83 fd 07 0f 84 63 03 00 00 43 8b 6c ea fc <48> 83 fd 22 0f 84 54 03 00 00 49 0f a3 e9 72 de 43 8b 14 ea 48 0f
[42480.413300] RSP: 002b:00007f5b7f1c8d20 EFLAGS: 00000293
[42480.413303] RAX: 0000000000000000 RBX: 00005654675eb0e0 RCX: 0000000000000000
[42480.413305] RDX: 000000000000000e RSI: 0000000000000002 RDI: 0000000110289941
[42480.413306] RBP: 0000000000000002 R08: 0000000000000001 R09: 8000000114289951
[42480.413307] R10: 000056546757d7b4 R11: 00005654675e10e0 R12: 0000000044144ca1
[42480.413308] R13: 0000000000000002 R14: 00005654675810e0 R15: 00005654675890e0
[42480.413310] FS:  00007f5b7f1c96c0 GS:  0000000000000000
[42480.413311] NMI backtrace for cpu 127 skipped: idling at io_idle+0x3/0x30
[42480.413317] NMI backtrace for cpu 63 skipped: idling at io_idle+0x3/0x30
[42480.413320] NMI backtrace for cpu 125 skipped: idling at io_idle+0x3/0x30
[42480.413326] NMI backtrace for cpu 61
[42480.413327] CPU: 61 UID: 1000 PID: 1131406 Comm: expand Not tainted 7.3.6 #1 PREEMPT(lazy) 
[42480.413330] Hardware name:  TURIN2D16-2T/TURIN2D16-2T, BIOS 10.06 10/22/2025
[42480.413330] RIP: 0033:0x565467577cae
[42480.413333] Code: cc cc cc cc cc cc c4 e2 cb f6 f6 48 c1 ee 02 0f b6 04 30 8d 34 b6 29 f2 48 8d 35 0d 7a 00 00 0f b6 c0 0f af 04 96 48 8d 14 40 <48> c1 ea 20 48 83 fa 01 0f 84 c4 fc ff ff 83 fa 02 0f 84 8f 03 00
[42480.413334] RSP: 002b:00007f5b841d2d20 EFLAGS: 00000a03
[42480.413335] RAX: 0000000055555566 RBX: 0000000000000026 RCX: 4000000000000102
[42480.413336] RDX: 0000000100000032 RSI: 000056546757f6b0 RDI: 0000000000000001
[42480.413337] RBP: 0000000001fc7061 R08: 0000000000000014 R09: 00000001104a5440
[42480.413338] R10: 00005654675791e0 R11: 0000000000000102 R12: 0000000044129524
[42480.413338] R13: 0000000000000002 R14: 00005654675810e0 R15: 0000000000000522
[42480.413339] FS:  00007f5b841d36c0 GS:  0000000000000000
[42480.413340] NMI backtrace for cpu 126
[42480.413343] CPU: 126 UID: 1000 PID: 1131398 Comm: expand Not tainted 7.3.6 #1 PREEMPT(lazy) 
[42480.413345] Hardware name:  TURIN2D16-2T/TURIN2D16-2T, BIOS 10.06 10/22/2025
[42480.413346] RIP: 0033:0x565467577cbf
[42480.413349] Code: 04 30 8d 34 b6 29 f2 48 8d 35 0d 7a 00 00 0f b6 c0 0f af 04 96 48 8d 14 40 48 c1 ea 20 48 83 fa 01 0f 84 c4 fc ff ff 83 fa 02 <0f> 84 8f 03 00 00 b0 01 89 44 24 38 e9 b0 fc ff ff 48 8b 44 24 58
[42480.413350] RSP: 002b:00007f5b881dad20 EFLAGS: 00000293
[42480.413352] RAX: 0000000000000000 RBX: 0000000000000017 RCX: 4000000001000001
[42480.413353] RDX: 0000000000000000 RSI: 000056546757f6b0 RDI: 0000000000000001
[42480.413354] RBP: 0000000001fc9e42 R08: 00000000c0020400 R09: 0000000110290a14
[42480.413354] R10: 00005654675791e0 R11: 0000000001000001 R12: 000000004416850a
[42480.413355] R13: 0000000000000002 R14: 00005654675810e0 R15: 000000000000070a
[42480.413356] FS:  00007f5b881db6c0 GS:  0000000000000000
[42480.413356] NMI backtrace for cpu 62 skipped: idling at io_idle+0x3/0x30

--yjw5avaouxkl3nnd--
