Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F8AFEEAB
	for <linux-xfs@vger.kernel.org>; Wed,  5 Nov 2025 00:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762302796; cv=none; b=UmnoEq4Cin2peRRqxhxV6tAQxrs4i65TprRHaZ8zP0CCUm2eTQzMxNO+sQQh7U7MsQcgjBq53yb0sf7YbnNMfSSBs4w7qUfa1bSYNRM45gFgje5fzkx7+tXRnnqiHnmgFzNAJTOxCLHK+8GHGOWVY2YvrT7/oHLF7BA9sxji5Qs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762302796; c=relaxed/simple;
	bh=Lap24ZXKtU/OJ1iRgAVRSl0ytQ+C/P519pAPtwHNmEA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Xg0816gxG9rW2X1Std8MfEgHPecCDoUfjfRUxlhBojuh1OIb2pPVg1NK0hXr1f0nVAnYn0GzkwYbejoU2+eSwYxll+2vKciXqkyDPCP6pHLNfau4tUSj5o2tKgqZDhSo0LfpQ8KWVGBjp6XYMd20PIzBHVdcnr6+E/egXJPEMFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VgAOoDQN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VgAOoDQN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8173C116B1;
	Wed,  5 Nov 2025 00:33:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762302795;
	bh=Lap24ZXKtU/OJ1iRgAVRSl0ytQ+C/P519pAPtwHNmEA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VgAOoDQNgUIKMnUACdG50tIOYzgS5w0TrV8+1jCZTGM2lHxHuep3i4xQnTyTH1Mq1
	 3tPdnwVqiZ2XO9xXPgaRCZTQKmO9kOjA3FCbcofbFtwWXx8LUm8CqbLhrdZlrCZXf4
	 WQlox0siDlIeFzdFGGgEM/cFeEhspc0nQ7YzItwglABRwdQUwkBgLe3EHbZIeAsiNX
	 bZ0unkyhhhEkF5nySKCX7tZuP5eo1UQeoDa0vXBqgGk1hvyNZFHZsRN9w8UjqYmAh9
	 sQiCwVYIPczUyePF+R9Y3l2ZWsWY6Xdq6lwv3CXwpP5SU2l/rwkUJ9jqmHT8cUTYZH
	 F3mmEglHRM35w==
Date: Tue, 4 Nov 2025 16:33:15 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	John Garry <john.g.garry@oracle.com>, ojaswin@linux.ibm.com
Subject: Re: [bug report] fstests generic/774 hang
Message-ID: <20251105003315.GZ196370@frogsfrogsfrogs>
References: <cmk52aqexackyz65phxgme55a3tdrermo3o4skr4lo4pwvvvcp@jmcblnfikbp2>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cmk52aqexackyz65phxgme55a3tdrermo3o4skr4lo4pwvvvcp@jmcblnfikbp2>

[add jogarry/ojaswin since this is a new atomic writes test]

On Thu, Oct 30, 2025 at 08:45:05AM +0000, Shinichiro Kawasaki wrote:
> I observe the fstests test case generic/774 hangs, when I run it for xfs on 8GiB
> TCMU fileio devices. It was observed with v6.17 and v6.18-rcX kernel versions.
> FYI, here I attach the kernel message log that was taken with v6.18-rc3 kernel
> [1]. The hang is recreated in stable manner by repeating the test case a few
> times in my environment.
> 
> Actions for fix will be appreciated. If I can do any help, please let me know.

I wonder, does your disk support atomic writes or are we just using the
software fallback in xfs?
> 
> [1]
> 
> Oct 30 15:11:25 redsun117q unknown: run fstests generic/774 at 2025-10-30 15:11:25
> Oct 30 15:11:25 redsun117q kernel: MODE SENSE: unimplemented page/subpage: 0x0a/0x05
> Oct 30 15:11:25 redsun117q kernel: MODE SENSE: unimplemented page/subpage: 0x0a/0x05
> Oct 30 15:11:25 redsun117q kernel: MODE SENSE: unimplemented page/subpage: 0x0a/0x05
> Oct 30 15:11:27 redsun117q kernel: MODE SENSE: unimplemented page/subpage: 0x0a/0x05

My guess is the disk doesn't support atomic writes?

--D

> Oct 30 15:11:28 redsun117q kernel: XFS (sdh): Mounting V5 Filesystem f93350d1-9b73-448c-bca2-b5b69343922f
> Oct 30 15:11:28 redsun117q kernel: XFS (sdh): Ending clean mount
> Oct 30 15:11:28 redsun117q kernel: XFS (sdh): Unmounting Filesystem f93350d1-9b73-448c-bca2-b5b69343922f
> Oct 30 15:11:29 redsun117q kernel: MODE SENSE: unimplemented page/subpage: 0x0a/0x05
> Oct 30 15:11:29 redsun117q kernel: XFS (sdh): Mounting V5 Filesystem 55534b79-27e6-4ded-82e3-5c249c68cb4a
> Oct 30 15:11:29 redsun117q kernel: XFS (sdh): Ending clean mount
> Oct 30 15:33:37 redsun117q kernel: INFO: task kworker/0:0:9 blocked for more than 122 seconds.
> Oct 30 15:33:37 redsun117q kernel:       Tainted: G        W           6.18.0-rc3-kts #3
> Oct 30 15:33:37 redsun117q kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> Oct 30 15:33:37 redsun117q kernel: task:kworker/0:0     state:D stack:0     pid:9     tgid:9     ppid:2      task_flags:0x4248060 flags:0x00080000
> Oct 30 15:33:37 redsun117q kernel: Workqueue: dio/sdh iomap_dio_complete_work
> Oct 30 15:33:37 redsun117q kernel: Call Trace:
> Oct 30 15:33:37 redsun117q kernel:  <TASK>
> Oct 30 15:33:37 redsun117q kernel:  __schedule+0x8bb/0x1ab0
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx_osq_unlock+0x10/0x10
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx___schedule+0x10/0x10
> Oct 30 15:33:37 redsun117q kernel:  ? rwsem_optimistic_spin+0x1d1/0x430
> Oct 30 15:33:37 redsun117q kernel:  ? do_raw_spin_lock+0x128/0x270
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx_do_raw_spin_lock+0x10/0x10
> Oct 30 15:33:37 redsun117q kernel:  ? lock_acquire+0xf6/0x140
> Oct 30 15:33:37 redsun117q kernel:  schedule+0xd1/0x250
> Oct 30 15:33:37 redsun117q kernel:  schedule_preempt_disabled+0x15/0x30
> Oct 30 15:33:37 redsun117q kernel:  rwsem_down_write_slowpath+0x4c6/0x1320
> Oct 30 15:33:37 redsun117q kernel:  ? lock_release+0xcb/0x110
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx_rwsem_down_write_slowpath+0x10/0x10
> Oct 30 15:33:37 redsun117q kernel:  ? percpu_counter_add_batch+0x80/0x220
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx___might_resched+0x10/0x10
> Oct 30 15:33:37 redsun117q kernel:  ? lock_acquire+0xf6/0x140
> Oct 30 15:33:37 redsun117q kernel:  down_write_nested+0x1c4/0x1f0
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx_down_write_nested+0x10/0x10
> Oct 30 15:33:37 redsun117q kernel:  xfs_reflink_end_atomic_cow+0x2b9/0x500 [xfs]
> Oct 30 15:33:37 redsun117q kernel:  ? dequeue_entity+0x33e/0x1df0
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx_xfs_reflink_end_atomic_cow+0x10/0x10 [xfs]
> Oct 30 15:33:37 redsun117q kernel:  ? update_load_avg+0x226/0x2200
> Oct 30 15:33:37 redsun117q kernel:  ? kvm_sched_clock_read+0x11/0x20
> Oct 30 15:33:37 redsun117q kernel:  ? sched_clock+0x10/0x30
> Oct 30 15:33:37 redsun117q kernel:  ? sched_clock_cpu+0x69/0x5a0
> Oct 30 15:33:37 redsun117q kernel:  xfs_dio_write_end_io+0x555/0x7c0 [xfs]
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx_xfs_dio_write_end_io+0x10/0x10 [xfs]
> Oct 30 15:33:37 redsun117q kernel:  iomap_dio_complete+0x13e/0x8d0
> Oct 30 15:33:37 redsun117q kernel:  ? trace_hardirqs_on+0x18/0x150
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx_aio_complete_rw+0x10/0x10
> Oct 30 15:33:37 redsun117q kernel:  iomap_dio_complete_work+0x58/0x90
> Oct 30 15:33:37 redsun117q kernel:  process_one_work+0x86b/0x14c0
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx_process_one_work+0x10/0x10
> Oct 30 15:33:37 redsun117q kernel:  ? asm_sysvec_apic_timer_interrupt+0x1a/0x20
> Oct 30 15:33:37 redsun117q kernel:  ? assign_work+0x156/0x390
> Oct 30 15:33:37 redsun117q kernel:  worker_thread+0x5f2/0xfd0
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx_worker_thread+0x10/0x10
> Oct 30 15:33:37 redsun117q kernel:  kthread+0x3a4/0x760
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx_kthread+0x10/0x10
> Oct 30 15:33:37 redsun117q kernel:  ? __lock_release.isra.0+0x59/0x170
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx_kthread+0x10/0x10
> Oct 30 15:33:37 redsun117q kernel:  ret_from_fork+0x2d6/0x3e0
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx_kthread+0x10/0x10
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx_kthread+0x10/0x10
> Oct 30 15:33:37 redsun117q kernel:  ret_from_fork_asm+0x1a/0x30
> Oct 30 15:33:37 redsun117q kernel:  </TASK>
> Oct 30 15:33:37 redsun117q kernel: INFO: task kworker/0:0:9 <writer> blocked on an rw-semaphore likely owned by task kworker/0:7:2826 <writer>
> Oct 30 15:33:37 redsun117q kernel: INFO: task kworker/1:0:45 blocked for more than 122 seconds.
> Oct 30 15:33:37 redsun117q kernel:       Tainted: G        W           6.18.0-rc3-kts #3
> Oct 30 15:33:37 redsun117q kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> Oct 30 15:33:37 redsun117q kernel: task:kworker/1:0     state:D stack:0     pid:45    tgid:45    ppid:2      task_flags:0x4248060 flags:0x00080000
> Oct 30 15:33:37 redsun117q kernel: Workqueue: dio/sdh iomap_dio_complete_work
> Oct 30 15:33:37 redsun117q kernel: Call Trace:
> Oct 30 15:33:37 redsun117q kernel:  <TASK>
> Oct 30 15:33:37 redsun117q kernel:  __schedule+0x8bb/0x1ab0
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx_osq_unlock+0x10/0x10
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx___schedule+0x10/0x10
> Oct 30 15:33:37 redsun117q kernel:  ? rwsem_optimistic_spin+0x1d1/0x430
> Oct 30 15:33:37 redsun117q kernel:  ? do_raw_spin_lock+0x128/0x270
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx_do_raw_spin_lock+0x10/0x10
> Oct 30 15:33:37 redsun117q kernel:  ? lock_acquire+0xf6/0x140
> Oct 30 15:33:37 redsun117q kernel:  schedule+0xd1/0x250
> Oct 30 15:33:37 redsun117q kernel:  schedule_preempt_disabled+0x15/0x30
> Oct 30 15:33:37 redsun117q kernel:  rwsem_down_write_slowpath+0x4c6/0x1320
> Oct 30 15:33:37 redsun117q kernel:  ? lock_release+0xcb/0x110
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx_rwsem_down_write_slowpath+0x10/0x10
> Oct 30 15:33:37 redsun117q kernel:  ? percpu_counter_add_batch+0x80/0x220
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx___might_resched+0x10/0x10
> Oct 30 15:33:37 redsun117q kernel:  ? lock_acquire+0xf6/0x140
> Oct 30 15:33:37 redsun117q kernel:  down_write_nested+0x1c4/0x1f0
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx_down_write_nested+0x10/0x10
> Oct 30 15:33:37 redsun117q kernel:  xfs_reflink_end_atomic_cow+0x2b9/0x500 [xfs]
> Oct 30 15:33:37 redsun117q kernel:  ? dequeue_entity+0x33e/0x1df0
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx_xfs_reflink_end_atomic_cow+0x10/0x10 [xfs]
> Oct 30 15:33:37 redsun117q kernel:  ? update_load_avg+0x226/0x2200
> Oct 30 15:33:37 redsun117q kernel:  ? dequeue_entities+0x24b/0x1530
> Oct 30 15:33:37 redsun117q kernel:  ? kvm_sched_clock_read+0x11/0x20
> Oct 30 15:33:37 redsun117q kernel:  ? sched_clock+0x10/0x30
> Oct 30 15:33:37 redsun117q kernel:  ? sched_clock_cpu+0x69/0x5a0
> Oct 30 15:33:37 redsun117q kernel:  xfs_dio_write_end_io+0x555/0x7c0 [xfs]
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx_xfs_dio_write_end_io+0x10/0x10 [xfs]
> Oct 30 15:33:37 redsun117q kernel:  iomap_dio_complete+0x13e/0x8d0
> Oct 30 15:33:37 redsun117q kernel:  ? trace_hardirqs_on+0x18/0x150
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx_aio_complete_rw+0x10/0x10
> Oct 30 15:33:37 redsun117q kernel:  iomap_dio_complete_work+0x58/0x90
> Oct 30 15:33:37 redsun117q kernel:  process_one_work+0x86b/0x14c0
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx_process_one_work+0x10/0x10
> Oct 30 15:33:37 redsun117q kernel:  ? schedule+0x1cc/0x250
> Oct 30 15:33:37 redsun117q kernel:  ? assign_work+0x156/0x390
> Oct 30 15:33:37 redsun117q kernel:  worker_thread+0x5f2/0xfd0
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx_worker_thread+0x10/0x10
> Oct 30 15:33:37 redsun117q kernel:  kthread+0x3a4/0x760
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx_kthread+0x10/0x10
> Oct 30 15:33:37 redsun117q kernel:  ? __lock_release.isra.0+0x59/0x170
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx_kthread+0x10/0x10
> Oct 30 15:33:37 redsun117q kernel:  ret_from_fork+0x2d6/0x3e0
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx_kthread+0x10/0x10
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx_kthread+0x10/0x10
> Oct 30 15:33:37 redsun117q kernel:  ret_from_fork_asm+0x1a/0x30
> Oct 30 15:33:37 redsun117q kernel:  </TASK>
> Oct 30 15:33:37 redsun117q kernel: INFO: task kworker/1:0:45 <writer> blocked on an rw-semaphore likely owned by task kworker/0:7:2826 <writer>
> Oct 30 15:33:37 redsun117q kernel: INFO: task kworker/13:0:105 blocked for more than 123 seconds.
> Oct 30 15:33:37 redsun117q kernel:       Tainted: G        W           6.18.0-rc3-kts #3
> Oct 30 15:33:37 redsun117q kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> Oct 30 15:33:37 redsun117q kernel: task:kworker/13:0    state:D stack:0     pid:105   tgid:105   ppid:2      task_flags:0x4248060 flags:0x00080000
> Oct 30 15:33:37 redsun117q kernel: Workqueue: dio/sdh iomap_dio_complete_work
> Oct 30 15:33:37 redsun117q kernel: Call Trace:
> Oct 30 15:33:37 redsun117q kernel:  <TASK>
> Oct 30 15:33:37 redsun117q kernel:  __schedule+0x8bb/0x1ab0
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx_osq_unlock+0x10/0x10
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx___schedule+0x10/0x10
> Oct 30 15:33:37 redsun117q kernel:  ? lock_acquire+0xf6/0x140
> Oct 30 15:33:37 redsun117q kernel:  schedule+0xd1/0x250
> Oct 30 15:33:37 redsun117q kernel:  schedule_preempt_disabled+0x15/0x30
> Oct 30 15:33:37 redsun117q kernel:  rwsem_down_write_slowpath+0x4c6/0x1320
> Oct 30 15:33:37 redsun117q kernel:  ? lock_release+0xcb/0x110
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx_rwsem_down_write_slowpath+0x10/0x10
> Oct 30 15:33:37 redsun117q kernel:  ? percpu_counter_add_batch+0x80/0x220
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx___might_resched+0x10/0x10
> Oct 30 15:33:37 redsun117q kernel:  ? lock_acquire+0xf6/0x140
> Oct 30 15:33:37 redsun117q kernel:  down_write_nested+0x1c4/0x1f0
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx_down_write_nested+0x10/0x10
> Oct 30 15:33:37 redsun117q kernel:  xfs_reflink_end_atomic_cow+0x2b9/0x500 [xfs]
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx_xfs_reflink_end_atomic_cow+0x10/0x10 [xfs]
> Oct 30 15:33:37 redsun117q kernel:  ? update_load_avg+0x226/0x2200
> Oct 30 15:33:37 redsun117q kernel:  ? kvm_sched_clock_read+0x11/0x20
> Oct 30 15:33:37 redsun117q kernel:  ? sched_clock+0x10/0x30
> Oct 30 15:33:37 redsun117q kernel:  ? sched_clock_cpu+0x69/0x5a0
> Oct 30 15:33:37 redsun117q kernel:  xfs_dio_write_end_io+0x555/0x7c0 [xfs]
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx_xfs_dio_write_end_io+0x10/0x10 [xfs]
> Oct 30 15:33:37 redsun117q kernel:  iomap_dio_complete+0x13e/0x8d0
> Oct 30 15:33:37 redsun117q kernel:  ? trace_hardirqs_on+0x18/0x150
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx_aio_complete_rw+0x10/0x10
> Oct 30 15:33:37 redsun117q kernel:  iomap_dio_complete_work+0x58/0x90
> Oct 30 15:33:37 redsun117q kernel:  process_one_work+0x86b/0x14c0
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx_process_one_work+0x10/0x10
> Oct 30 15:33:37 redsun117q kernel:  ? asm_sysvec_apic_timer_interrupt+0x1a/0x20
> Oct 30 15:33:37 redsun117q kernel:  ? assign_work+0x156/0x390
> Oct 30 15:33:37 redsun117q kernel:  worker_thread+0x5f2/0xfd0
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx_worker_thread+0x10/0x10
> Oct 30 15:33:37 redsun117q kernel:  kthread+0x3a4/0x760
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx_kthread+0x10/0x10
> Oct 30 15:33:37 redsun117q kernel:  ? __lock_release.isra.0+0x59/0x170
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx_kthread+0x10/0x10
> Oct 30 15:33:37 redsun117q kernel:  ret_from_fork+0x2d6/0x3e0
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx_kthread+0x10/0x10
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx_kthread+0x10/0x10
> Oct 30 15:33:37 redsun117q kernel:  ret_from_fork_asm+0x1a/0x30
> Oct 30 15:33:37 redsun117q kernel:  </TASK>
> Oct 30 15:33:37 redsun117q kernel: INFO: task kworker/13:0:105 <writer> blocked on an rw-semaphore likely owned by task kworker/0:7:2826 <writer>
> Oct 30 15:33:37 redsun117q kernel: INFO: task kworker/1:1:189 blocked for more than 123 seconds.
> Oct 30 15:33:37 redsun117q kernel:       Tainted: G        W           6.18.0-rc3-kts #3
> Oct 30 15:33:37 redsun117q kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> Oct 30 15:33:37 redsun117q kernel: task:kworker/1:1     state:D stack:0     pid:189   tgid:189   ppid:2      task_flags:0x4248060 flags:0x00080000
> Oct 30 15:33:37 redsun117q kernel: Workqueue: dio/sdh iomap_dio_complete_work
> Oct 30 15:33:37 redsun117q kernel: Call Trace:
> Oct 30 15:33:37 redsun117q kernel:  <TASK>
> Oct 30 15:33:37 redsun117q kernel:  __schedule+0x8bb/0x1ab0
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx_osq_unlock+0x10/0x10
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx___schedule+0x10/0x10
> Oct 30 15:33:37 redsun117q kernel:  ? preempt_schedule_notrace+0x53/0x90
> Oct 30 15:33:37 redsun117q kernel:  ? schedule+0xfe/0x250
> Oct 30 15:33:37 redsun117q kernel:  ? rcu_is_watching+0x67/0x80
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx_do_raw_spin_lock+0x10/0x10
> Oct 30 15:33:37 redsun117q kernel:  ? lock_acquire+0xf6/0x140
> Oct 30 15:33:37 redsun117q kernel:  schedule+0xd1/0x250
> Oct 30 15:33:37 redsun117q kernel:  schedule_preempt_disabled+0x15/0x30
> Oct 30 15:33:37 redsun117q kernel:  rwsem_down_write_slowpath+0x4c6/0x1320
> Oct 30 15:33:37 redsun117q kernel:  ? lock_release+0xcb/0x110
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx_rwsem_down_write_slowpath+0x10/0x10
> Oct 30 15:33:37 redsun117q kernel:  ? percpu_counter_add_batch+0x80/0x220
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx___might_resched+0x10/0x10
> Oct 30 15:33:37 redsun117q kernel:  ? lock_acquire+0xf6/0x140
> Oct 30 15:33:37 redsun117q kernel:  down_write_nested+0x1c4/0x1f0
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx_down_write_nested+0x10/0x10
> Oct 30 15:33:37 redsun117q kernel:  xfs_reflink_end_atomic_cow+0x2b9/0x500 [xfs]
> Oct 30 15:33:37 redsun117q kernel:  ? dequeue_entity+0x482/0x1df0
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx_xfs_reflink_end_atomic_cow+0x10/0x10 [xfs]
> Oct 30 15:33:37 redsun117q kernel:  ? update_load_avg+0x226/0x2200
> Oct 30 15:33:37 redsun117q kernel:  ? kvm_sched_clock_read+0x11/0x20
> Oct 30 15:33:37 redsun117q kernel:  ? sched_clock+0x10/0x30
> Oct 30 15:33:37 redsun117q kernel:  ? sched_clock_cpu+0x69/0x5a0
> Oct 30 15:33:37 redsun117q kernel:  xfs_dio_write_end_io+0x555/0x7c0 [xfs]
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx_xfs_dio_write_end_io+0x10/0x10 [xfs]
> Oct 30 15:33:37 redsun117q kernel:  iomap_dio_complete+0x13e/0x8d0
> Oct 30 15:33:37 redsun117q kernel:  ? trace_hardirqs_on+0x18/0x150
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx_aio_complete_rw+0x10/0x10
> Oct 30 15:33:37 redsun117q kernel:  iomap_dio_complete_work+0x58/0x90
> Oct 30 15:33:37 redsun117q kernel:  process_one_work+0x86b/0x14c0
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx_process_one_work+0x10/0x10
> Oct 30 15:33:37 redsun117q kernel:  ? __try_to_del_timer_sync+0xd7/0x130
> Oct 30 15:33:37 redsun117q kernel:  ? assign_work+0x156/0x390
> Oct 30 15:33:37 redsun117q kernel:  worker_thread+0x5f2/0xfd0
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx_worker_thread+0x10/0x10
> Oct 30 15:33:37 redsun117q kernel:  kthread+0x3a4/0x760
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx_kthread+0x10/0x10
> Oct 30 15:33:37 redsun117q kernel:  ? lock_acquire+0xf6/0x140
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx_kthread+0x10/0x10
> Oct 30 15:33:37 redsun117q kernel:  ret_from_fork+0x2d6/0x3e0
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx_kthread+0x10/0x10
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx_kthread+0x10/0x10
> Oct 30 15:33:37 redsun117q kernel:  ret_from_fork_asm+0x1a/0x30
> Oct 30 15:33:37 redsun117q kernel:  </TASK>
> Oct 30 15:33:37 redsun117q kernel: INFO: task kworker/1:1:189 <writer> blocked on an rw-semaphore likely owned by task kworker/0:7:2826 <writer>
> Oct 30 15:33:37 redsun117q kernel: INFO: task kworker/13:1:204 blocked for more than 123 seconds.
> Oct 30 15:33:37 redsun117q kernel:       Tainted: G        W           6.18.0-rc3-kts #3
> Oct 30 15:33:37 redsun117q kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> Oct 30 15:33:37 redsun117q kernel: task:kworker/13:1    state:D stack:0     pid:204   tgid:204   ppid:2      task_flags:0x4248060 flags:0x00080000
> Oct 30 15:33:37 redsun117q kernel: Workqueue: dio/sdh iomap_dio_complete_work
> Oct 30 15:33:37 redsun117q kernel: Call Trace:
> Oct 30 15:33:37 redsun117q kernel:  <TASK>
> Oct 30 15:33:37 redsun117q kernel:  __schedule+0x8bb/0x1ab0
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx_osq_unlock+0x10/0x10
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx___schedule+0x10/0x10
> Oct 30 15:33:37 redsun117q kernel:  ? rwsem_optimistic_spin+0x1d1/0x430
> Oct 30 15:33:37 redsun117q kernel:  ? do_raw_spin_lock+0x128/0x270
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx_do_raw_spin_lock+0x10/0x10
> Oct 30 15:33:37 redsun117q kernel:  ? lock_acquire+0xf6/0x140
> Oct 30 15:33:37 redsun117q kernel:  schedule+0xd1/0x250
> Oct 30 15:33:37 redsun117q kernel:  schedule_preempt_disabled+0x15/0x30
> Oct 30 15:33:37 redsun117q kernel:  rwsem_down_write_slowpath+0x4c6/0x1320
> Oct 30 15:33:37 redsun117q kernel:  ? lock_release+0xcb/0x110
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx_rwsem_down_write_slowpath+0x10/0x10
> Oct 30 15:33:37 redsun117q kernel:  ? percpu_counter_add_batch+0x80/0x220
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx___might_resched+0x10/0x10
> Oct 30 15:33:37 redsun117q kernel:  ? lock_acquire+0xf6/0x140
> Oct 30 15:33:37 redsun117q kernel:  down_write_nested+0x1c4/0x1f0
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx_down_write_nested+0x10/0x10
> Oct 30 15:33:37 redsun117q kernel:  xfs_reflink_end_atomic_cow+0x2b9/0x500 [xfs]
> Oct 30 15:33:37 redsun117q kernel:  ? dequeue_entity+0x33e/0x1df0
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx_xfs_reflink_end_atomic_cow+0x10/0x10 [xfs]
> Oct 30 15:33:37 redsun117q kernel:  ? update_load_avg+0x226/0x2200
> Oct 30 15:33:37 redsun117q kernel:  ? dequeue_entities+0x24b/0x1530
> Oct 30 15:33:37 redsun117q kernel:  ? kvm_sched_clock_read+0x11/0x20
> Oct 30 15:33:37 redsun117q kernel:  ? sched_clock+0x10/0x30
> Oct 30 15:33:37 redsun117q kernel:  ? sched_clock_cpu+0x69/0x5a0
> Oct 30 15:33:37 redsun117q kernel:  xfs_dio_write_end_io+0x555/0x7c0 [xfs]
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx_xfs_dio_write_end_io+0x10/0x10 [xfs]
> Oct 30 15:33:37 redsun117q kernel:  iomap_dio_complete+0x13e/0x8d0
> Oct 30 15:33:37 redsun117q kernel:  ? trace_hardirqs_on+0x18/0x150
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx_aio_complete_rw+0x10/0x10
> Oct 30 15:33:37 redsun117q kernel:  iomap_dio_complete_work+0x58/0x90
> Oct 30 15:33:37 redsun117q kernel:  process_one_work+0x86b/0x14c0
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx_process_one_work+0x10/0x10
> Oct 30 15:33:37 redsun117q kernel:  ? asm_sysvec_apic_timer_interrupt+0x1a/0x20
> Oct 30 15:33:37 redsun117q kernel:  ? assign_work+0x156/0x390
> Oct 30 15:33:37 redsun117q kernel:  worker_thread+0x5f2/0xfd0
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx_worker_thread+0x10/0x10
> Oct 30 15:33:37 redsun117q kernel:  ? __kthread_parkme+0xb3/0x1f0
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx_worker_thread+0x10/0x10
> Oct 30 15:33:37 redsun117q kernel:  kthread+0x3a4/0x760
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx_kthread+0x10/0x10
> Oct 30 15:33:37 redsun117q kernel:  ? lock_acquire+0xf6/0x140
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx_kthread+0x10/0x10
> Oct 30 15:33:37 redsun117q kernel:  ret_from_fork+0x2d6/0x3e0
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx_kthread+0x10/0x10
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx_kthread+0x10/0x10
> Oct 30 15:33:37 redsun117q kernel:  ret_from_fork_asm+0x1a/0x30
> Oct 30 15:33:37 redsun117q kernel:  </TASK>
> Oct 30 15:33:37 redsun117q kernel: INFO: task kworker/13:1:204 <writer> blocked on an rw-semaphore likely owned by task kworker/0:7:2826 <writer>
> Oct 30 15:33:37 redsun117q kernel: INFO: task kworker/2:1:261 blocked for more than 123 seconds.
> Oct 30 15:33:37 redsun117q kernel:       Tainted: G        W           6.18.0-rc3-kts #3
> Oct 30 15:33:37 redsun117q kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> Oct 30 15:33:37 redsun117q kernel: task:kworker/2:1     state:D stack:0     pid:261   tgid:261   ppid:2      task_flags:0x4248060 flags:0x00080000
> Oct 30 15:33:37 redsun117q kernel: Workqueue: dio/sdh iomap_dio_complete_work
> Oct 30 15:33:37 redsun117q kernel: Call Trace:
> Oct 30 15:33:37 redsun117q kernel:  <TASK>
> Oct 30 15:33:37 redsun117q kernel:  __schedule+0x8bb/0x1ab0
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx_osq_unlock+0x10/0x10
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx___schedule+0x10/0x10
> Oct 30 15:33:37 redsun117q kernel:  ? lock_acquire+0xf6/0x140
> Oct 30 15:33:37 redsun117q kernel:  schedule+0xd1/0x250
> Oct 30 15:33:37 redsun117q kernel:  schedule_preempt_disabled+0x15/0x30
> Oct 30 15:33:37 redsun117q kernel:  rwsem_down_write_slowpath+0x4c6/0x1320
> Oct 30 15:33:37 redsun117q kernel:  ? __kasan_slab_alloc+0x7e/0x90
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx_rwsem_down_write_slowpath+0x10/0x10
> Oct 30 15:33:37 redsun117q kernel:  ? percpu_counter_add_batch+0x80/0x220
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx___might_resched+0x10/0x10
> Oct 30 15:33:37 redsun117q kernel:  ? lock_acquire+0xf6/0x140
> Oct 30 15:33:37 redsun117q kernel:  down_write_nested+0x1c4/0x1f0
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx_down_write_nested+0x10/0x10
> Oct 30 15:33:37 redsun117q kernel:  xfs_reflink_end_atomic_cow+0x2b9/0x500 [xfs]
> Oct 30 15:33:37 redsun117q kernel:  ? dequeue_entity+0x482/0x1df0
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx_xfs_reflink_end_atomic_cow+0x10/0x10 [xfs]
> Oct 30 15:33:37 redsun117q kernel:  ? update_load_avg+0x226/0x2200
> Oct 30 15:33:37 redsun117q kernel:  ? kvm_sched_clock_read+0x11/0x20
> Oct 30 15:33:37 redsun117q kernel:  ? sched_clock+0x10/0x30
> Oct 30 15:33:37 redsun117q kernel:  ? sched_clock_cpu+0x69/0x5a0
> Oct 30 15:33:37 redsun117q kernel:  xfs_dio_write_end_io+0x555/0x7c0 [xfs]
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx_xfs_dio_write_end_io+0x10/0x10 [xfs]
> Oct 30 15:33:37 redsun117q kernel:  iomap_dio_complete+0x13e/0x8d0
> Oct 30 15:33:37 redsun117q kernel:  ? trace_hardirqs_on+0x18/0x150
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx_aio_complete_rw+0x10/0x10
> Oct 30 15:33:37 redsun117q kernel:  iomap_dio_complete_work+0x58/0x90
> Oct 30 15:33:37 redsun117q kernel:  process_one_work+0x86b/0x14c0
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx_process_one_work+0x10/0x10
> Oct 30 15:33:37 redsun117q kernel:  ? asm_sysvec_apic_timer_interrupt+0x1a/0x20
> Oct 30 15:33:37 redsun117q kernel:  ? assign_work+0x156/0x390
> Oct 30 15:33:37 redsun117q kernel:  worker_thread+0x5f2/0xfd0
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx_worker_thread+0x10/0x10
> Oct 30 15:33:37 redsun117q kernel:  ? __kthread_parkme+0xb3/0x1f0
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx_worker_thread+0x10/0x10
> Oct 30 15:33:37 redsun117q kernel:  kthread+0x3a4/0x760
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx_kthread+0x10/0x10
> Oct 30 15:33:37 redsun117q kernel:  ? lock_acquire+0xf6/0x140
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx_kthread+0x10/0x10
> Oct 30 15:33:37 redsun117q kernel:  ret_from_fork+0x2d6/0x3e0
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx_kthread+0x10/0x10
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx_kthread+0x10/0x10
> Oct 30 15:33:37 redsun117q kernel:  ret_from_fork_asm+0x1a/0x30
> Oct 30 15:33:37 redsun117q kernel:  </TASK>
> Oct 30 15:33:37 redsun117q kernel: INFO: task kworker/2:1:261 <writer> blocked on an rw-semaphore likely owned by task kworker/0:7:2826 <writer>
> Oct 30 15:33:37 redsun117q kernel: INFO: task kworker/12:4:352 blocked for more than 123 seconds.
> Oct 30 15:33:37 redsun117q kernel:       Tainted: G        W           6.18.0-rc3-kts #3
> Oct 30 15:33:37 redsun117q kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> Oct 30 15:33:37 redsun117q kernel: task:kworker/12:4    state:D stack:0     pid:352   tgid:352   ppid:2      task_flags:0x4248060 flags:0x00080000
> Oct 30 15:33:37 redsun117q kernel: Workqueue: dio/sdh iomap_dio_complete_work
> Oct 30 15:33:37 redsun117q kernel: Call Trace:
> Oct 30 15:33:37 redsun117q kernel:  <TASK>
> Oct 30 15:33:37 redsun117q kernel:  __schedule+0x8bb/0x1ab0
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx___schedule+0x10/0x10
> Oct 30 15:33:37 redsun117q kernel:  ? kick_pool+0x1a5/0x860
> Oct 30 15:33:37 redsun117q kernel:  schedule+0xd1/0x250
> Oct 30 15:33:37 redsun117q kernel:  schedule_preempt_disabled+0x15/0x30
> Oct 30 15:33:37 redsun117q kernel:  rwsem_down_write_slowpath+0x4c6/0x1320
> Oct 30 15:33:37 redsun117q kernel:  ? lock_release+0xcb/0x110
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx_rwsem_down_write_slowpath+0x10/0x10
> Oct 30 15:33:37 redsun117q kernel:  ? percpu_counter_add_batch+0x80/0x220
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx___might_resched+0x10/0x10
> Oct 30 15:33:37 redsun117q kernel:  ? lock_acquire+0xf6/0x140
> Oct 30 15:33:37 redsun117q kernel:  down_write_nested+0x1c4/0x1f0
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx_down_write_nested+0x10/0x10
> Oct 30 15:33:37 redsun117q kernel:  xfs_reflink_end_atomic_cow+0x2b9/0x500 [xfs]
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx_xfs_reflink_end_atomic_cow+0x10/0x10 [xfs]
> Oct 30 15:33:37 redsun117q kernel:  ? update_load_avg+0x226/0x2200
> Oct 30 15:33:37 redsun117q kernel:  ? kvm_sched_clock_read+0x11/0x20
> Oct 30 15:33:37 redsun117q kernel:  ? sched_clock+0x10/0x30
> Oct 30 15:33:37 redsun117q kernel:  ? sched_clock_cpu+0x69/0x5a0
> Oct 30 15:33:37 redsun117q kernel:  xfs_dio_write_end_io+0x555/0x7c0 [xfs]
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx_xfs_dio_write_end_io+0x10/0x10 [xfs]
> Oct 30 15:33:37 redsun117q kernel:  iomap_dio_complete+0x13e/0x8d0
> Oct 30 15:33:37 redsun117q kernel:  ? trace_hardirqs_on+0x18/0x150
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx_aio_complete_rw+0x10/0x10
> Oct 30 15:33:37 redsun117q kernel:  iomap_dio_complete_work+0x58/0x90
> Oct 30 15:33:37 redsun117q kernel:  process_one_work+0x86b/0x14c0
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx_process_one_work+0x10/0x10
> Oct 30 15:33:37 redsun117q kernel:  ? asm_sysvec_apic_timer_interrupt+0x1a/0x20
> Oct 30 15:33:37 redsun117q kernel:  ? assign_work+0x156/0x390
> Oct 30 15:33:37 redsun117q kernel:  worker_thread+0x5f2/0xfd0
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx_worker_thread+0x10/0x10
> Oct 30 15:33:37 redsun117q kernel:  kthread+0x3a4/0x760
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx_kthread+0x10/0x10
> Oct 30 15:33:37 redsun117q kernel:  ? lock_acquire+0xf6/0x140
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx_kthread+0x10/0x10
> Oct 30 15:33:37 redsun117q kernel:  ret_from_fork+0x2d6/0x3e0
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx_kthread+0x10/0x10
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx_kthread+0x10/0x10
> Oct 30 15:33:37 redsun117q kernel:  ret_from_fork_asm+0x1a/0x30
> Oct 30 15:33:37 redsun117q kernel:  </TASK>
> Oct 30 15:33:37 redsun117q kernel: INFO: task kworker/12:4:352 <writer> blocked on an rw-semaphore likely owned by task kworker/0:7:2826 <writer>
> Oct 30 15:33:37 redsun117q kernel: INFO: task kworker/3:2:545 blocked for more than 123 seconds.
> Oct 30 15:33:37 redsun117q kernel:       Tainted: G        W           6.18.0-rc3-kts #3
> Oct 30 15:33:37 redsun117q kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> Oct 30 15:33:37 redsun117q kernel: task:kworker/3:2     state:D stack:0     pid:545   tgid:545   ppid:2      task_flags:0x4248060 flags:0x00080000
> Oct 30 15:33:37 redsun117q kernel: Workqueue: dio/sdh iomap_dio_complete_work
> Oct 30 15:33:37 redsun117q kernel: Call Trace:
> Oct 30 15:33:37 redsun117q kernel:  <TASK>
> Oct 30 15:33:37 redsun117q kernel:  __schedule+0x8bb/0x1ab0
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx_osq_unlock+0x10/0x10
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx___schedule+0x10/0x10
> Oct 30 15:33:37 redsun117q kernel:  ? rwsem_optimistic_spin+0x1d1/0x430
> Oct 30 15:33:37 redsun117q kernel:  ? do_raw_spin_lock+0x128/0x270
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx_do_raw_spin_lock+0x10/0x10
> Oct 30 15:33:37 redsun117q kernel:  ? lock_acquire+0xf6/0x140
> Oct 30 15:33:37 redsun117q kernel:  schedule+0xd1/0x250
> Oct 30 15:33:37 redsun117q kernel:  schedule_preempt_disabled+0x15/0x30
> Oct 30 15:33:37 redsun117q kernel:  rwsem_down_write_slowpath+0x4c6/0x1320
> Oct 30 15:33:37 redsun117q kernel:  ? lock_release+0xcb/0x110
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx_rwsem_down_write_slowpath+0x10/0x10
> Oct 30 15:33:37 redsun117q kernel:  ? percpu_counter_add_batch+0x80/0x220
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx___might_resched+0x10/0x10
> Oct 30 15:33:37 redsun117q kernel:  ? lock_acquire+0xf6/0x140
> Oct 30 15:33:37 redsun117q kernel:  down_write_nested+0x1c4/0x1f0
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx_down_write_nested+0x10/0x10
> Oct 30 15:33:37 redsun117q kernel:  xfs_reflink_end_atomic_cow+0x2b9/0x500 [xfs]
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx_xfs_reflink_end_atomic_cow+0x10/0x10 [xfs]
> Oct 30 15:33:37 redsun117q kernel:  ? update_load_avg+0x226/0x2200
> Oct 30 15:33:37 redsun117q kernel:  ? kvm_sched_clock_read+0x11/0x20
> Oct 30 15:33:37 redsun117q kernel:  ? sched_clock+0x10/0x30
> Oct 30 15:33:37 redsun117q kernel:  ? sched_clock_cpu+0x69/0x5a0
> Oct 30 15:33:37 redsun117q kernel:  xfs_dio_write_end_io+0x555/0x7c0 [xfs]
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx_xfs_dio_write_end_io+0x10/0x10 [xfs]
> Oct 30 15:33:37 redsun117q kernel:  iomap_dio_complete+0x13e/0x8d0
> Oct 30 15:33:37 redsun117q kernel:  ? trace_hardirqs_on+0x18/0x150
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx_aio_complete_rw+0x10/0x10
> Oct 30 15:33:37 redsun117q kernel:  iomap_dio_complete_work+0x58/0x90
> Oct 30 15:33:37 redsun117q kernel:  process_one_work+0x86b/0x14c0
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx_process_one_work+0x10/0x10
> Oct 30 15:33:37 redsun117q kernel:  ? asm_sysvec_apic_timer_interrupt+0x1a/0x20
> Oct 30 15:33:37 redsun117q kernel:  ? assign_work+0x156/0x390
> Oct 30 15:33:37 redsun117q kernel:  worker_thread+0x5f2/0xfd0
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx_worker_thread+0x10/0x10
> Oct 30 15:33:37 redsun117q kernel:  kthread+0x3a4/0x760
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx_kthread+0x10/0x10
> Oct 30 15:33:37 redsun117q kernel:  ? lock_acquire+0xf6/0x140
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx_kthread+0x10/0x10
> Oct 30 15:33:37 redsun117q kernel:  ret_from_fork+0x2d6/0x3e0
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx_kthread+0x10/0x10
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx_kthread+0x10/0x10
> Oct 30 15:33:37 redsun117q kernel:  ret_from_fork_asm+0x1a/0x30
> Oct 30 15:33:37 redsun117q kernel:  </TASK>
> Oct 30 15:33:37 redsun117q kernel: INFO: task kworker/3:2:545 <writer> blocked on an rw-semaphore likely owned by task kworker/0:7:2826 <writer>
> Oct 30 15:33:37 redsun117q kernel: INFO: task kworker/2:2:549 blocked for more than 123 seconds.
> Oct 30 15:33:37 redsun117q kernel:       Tainted: G        W           6.18.0-rc3-kts #3
> Oct 30 15:33:37 redsun117q kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> Oct 30 15:33:37 redsun117q kernel: task:kworker/2:2     state:D stack:0     pid:549   tgid:549   ppid:2      task_flags:0x4248060 flags:0x00080000
> Oct 30 15:33:37 redsun117q kernel: Workqueue: dio/sdh iomap_dio_complete_work
> Oct 30 15:33:37 redsun117q kernel: Call Trace:
> Oct 30 15:33:37 redsun117q kernel:  <TASK>
> Oct 30 15:33:37 redsun117q kernel:  __schedule+0x8bb/0x1ab0
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx_osq_unlock+0x10/0x10
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx___schedule+0x10/0x10
> Oct 30 15:33:37 redsun117q kernel:  ? rwsem_optimistic_spin+0x1d1/0x430
> Oct 30 15:33:37 redsun117q kernel:  ? do_raw_spin_lock+0x128/0x270
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx_do_raw_spin_lock+0x10/0x10
> Oct 30 15:33:37 redsun117q kernel:  ? lock_acquire+0xf6/0x140
> Oct 30 15:33:37 redsun117q kernel:  schedule+0xd1/0x250
> Oct 30 15:33:37 redsun117q kernel:  schedule_preempt_disabled+0x15/0x30
> Oct 30 15:33:37 redsun117q kernel:  rwsem_down_write_slowpath+0x4c6/0x1320
> Oct 30 15:33:37 redsun117q kernel:  ? lock_release+0xcb/0x110
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx_rwsem_down_write_slowpath+0x10/0x10
> Oct 30 15:33:37 redsun117q kernel:  ? percpu_counter_add_batch+0x80/0x220
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx___might_resched+0x10/0x10
> Oct 30 15:33:37 redsun117q kernel:  ? lock_acquire+0xf6/0x140
> Oct 30 15:33:37 redsun117q kernel:  down_write_nested+0x1c4/0x1f0
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx_down_write_nested+0x10/0x10
> Oct 30 15:33:37 redsun117q kernel:  xfs_reflink_end_atomic_cow+0x2b9/0x500 [xfs]
> Oct 30 15:33:37 redsun117q kernel:  ? dequeue_entity+0x33e/0x1df0
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx_xfs_reflink_end_atomic_cow+0x10/0x10 [xfs]
> Oct 30 15:33:37 redsun117q kernel:  ? update_load_avg+0x226/0x2200
> Oct 30 15:33:37 redsun117q kernel:  ? kvm_sched_clock_read+0x11/0x20
> Oct 30 15:33:37 redsun117q kernel:  ? sched_clock+0x10/0x30
> Oct 30 15:33:37 redsun117q kernel:  ? sched_clock_cpu+0x69/0x5a0
> Oct 30 15:33:37 redsun117q kernel:  xfs_dio_write_end_io+0x555/0x7c0 [xfs]
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx_xfs_dio_write_end_io+0x10/0x10 [xfs]
> Oct 30 15:33:37 redsun117q kernel:  iomap_dio_complete+0x13e/0x8d0
> Oct 30 15:33:37 redsun117q kernel:  ? trace_hardirqs_on+0x18/0x150
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx_aio_complete_rw+0x10/0x10
> Oct 30 15:33:37 redsun117q kernel:  iomap_dio_complete_work+0x58/0x90
> Oct 30 15:33:37 redsun117q kernel:  process_one_work+0x86b/0x14c0
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx_process_one_work+0x10/0x10
> Oct 30 15:33:37 redsun117q kernel:  ? asm_sysvec_apic_timer_interrupt+0x1a/0x20
> Oct 30 15:33:37 redsun117q kernel:  ? assign_work+0x156/0x390
> Oct 30 15:33:37 redsun117q kernel:  worker_thread+0x5f2/0xfd0
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx_worker_thread+0x10/0x10
> Oct 30 15:33:37 redsun117q kernel:  kthread+0x3a4/0x760
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx_kthread+0x10/0x10
> Oct 30 15:33:37 redsun117q kernel:  ? lock_acquire+0xf6/0x140
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx_kthread+0x10/0x10
> Oct 30 15:33:37 redsun117q kernel:  ret_from_fork+0x2d6/0x3e0
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx_kthread+0x10/0x10
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx_kthread+0x10/0x10
> Oct 30 15:33:37 redsun117q kernel:  ret_from_fork_asm+0x1a/0x30
> Oct 30 15:33:37 redsun117q kernel:  </TASK>
> Oct 30 15:33:37 redsun117q kernel: INFO: task kworker/2:2:549 <writer> blocked on an rw-semaphore likely owned by task kworker/0:7:2826 <writer>
> Oct 30 15:33:37 redsun117q kernel: INFO: task kworker/6:2:557 blocked for more than 123 seconds.
> Oct 30 15:33:37 redsun117q kernel:       Tainted: G        W           6.18.0-rc3-kts #3
> Oct 30 15:33:37 redsun117q kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> Oct 30 15:33:37 redsun117q kernel: task:kworker/6:2     state:D stack:0     pid:557   tgid:557   ppid:2      task_flags:0x4248060 flags:0x00080000
> Oct 30 15:33:37 redsun117q kernel: Workqueue: dio/sdh iomap_dio_complete_work
> Oct 30 15:33:37 redsun117q kernel: Call Trace:
> Oct 30 15:33:37 redsun117q kernel:  <TASK>
> Oct 30 15:33:37 redsun117q kernel:  __schedule+0x8bb/0x1ab0
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx_osq_unlock+0x10/0x10
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx___schedule+0x10/0x10
> Oct 30 15:33:37 redsun117q kernel:  ? lock_acquire+0xf6/0x140
> Oct 30 15:33:37 redsun117q kernel:  schedule+0xd1/0x250
> Oct 30 15:33:37 redsun117q kernel:  schedule_preempt_disabled+0x15/0x30
> Oct 30 15:33:37 redsun117q kernel:  rwsem_down_write_slowpath+0x4c6/0x1320
> Oct 30 15:33:37 redsun117q kernel:  ? lock_release+0xcb/0x110
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx_rwsem_down_write_slowpath+0x10/0x10
> Oct 30 15:33:37 redsun117q kernel:  ? percpu_counter_add_batch+0x80/0x220
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx___might_resched+0x10/0x10
> Oct 30 15:33:37 redsun117q kernel:  ? lock_acquire+0xf6/0x140
> Oct 30 15:33:37 redsun117q kernel:  down_write_nested+0x1c4/0x1f0
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx_down_write_nested+0x10/0x10
> Oct 30 15:33:37 redsun117q kernel:  xfs_reflink_end_atomic_cow+0x2b9/0x500 [xfs]
> Oct 30 15:33:37 redsun117q kernel:  ? dequeue_entity+0x33e/0x1df0
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx_xfs_reflink_end_atomic_cow+0x10/0x10 [xfs]
> Oct 30 15:33:37 redsun117q kernel:  ? update_load_avg+0x226/0x2200
> Oct 30 15:33:37 redsun117q kernel:  ? kvm_sched_clock_read+0x11/0x20
> Oct 30 15:33:37 redsun117q kernel:  ? sched_clock+0x10/0x30
> Oct 30 15:33:37 redsun117q kernel:  ? sched_clock_cpu+0x69/0x5a0
> Oct 30 15:33:37 redsun117q kernel:  xfs_dio_write_end_io+0x555/0x7c0 [xfs]
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx_xfs_dio_write_end_io+0x10/0x10 [xfs]
> Oct 30 15:33:37 redsun117q kernel:  iomap_dio_complete+0x13e/0x8d0
> Oct 30 15:33:37 redsun117q kernel:  ? trace_hardirqs_on+0x18/0x150
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx_aio_complete_rw+0x10/0x10
> Oct 30 15:33:37 redsun117q kernel:  iomap_dio_complete_work+0x58/0x90
> Oct 30 15:33:37 redsun117q kernel:  process_one_work+0x86b/0x14c0
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx_process_one_work+0x10/0x10
> Oct 30 15:33:37 redsun117q kernel:  ? asm_sysvec_apic_timer_interrupt+0x1a/0x20
> Oct 30 15:33:37 redsun117q kernel:  ? assign_work+0x156/0x390
> Oct 30 15:33:37 redsun117q kernel:  worker_thread+0x5f2/0xfd0
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx_worker_thread+0x10/0x10
> Oct 30 15:33:37 redsun117q kernel:  kthread+0x3a4/0x760
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx_kthread+0x10/0x10
> Oct 30 15:33:37 redsun117q kernel:  ? lock_acquire+0xf6/0x140
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx_kthread+0x10/0x10
> Oct 30 15:33:37 redsun117q kernel:  ret_from_fork+0x2d6/0x3e0
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx_kthread+0x10/0x10
> Oct 30 15:33:37 redsun117q kernel:  ? __pfx_kthread+0x10/0x10
> Oct 30 15:33:37 redsun117q kernel:  ret_from_fork_asm+0x1a/0x30
> Oct 30 15:33:37 redsun117q kernel:  </TASK>
> Oct 30 15:33:37 redsun117q kernel: INFO: task kworker/6:2:557 <writer> blocked on an rw-semaphore likely owned by task kworker/0:7:2826 <writer>
> Oct 30 15:33:37 redsun117q kernel: Future hung task reports are suppressed, see sysctl kernel.hung_task_warnings
> Oct 30 15:33:37 redsun117q kernel: INFO: lockdep is turned off.
