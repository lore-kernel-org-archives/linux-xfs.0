Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795725229;
	b=BV7/jIfj80WDeQnrTjdvQKZQb6Msk8n94TDQdkADR91gkO4bWbmss8Qe42irZjzCwyVs
	 aq7i3uWDpyFSnm0tztyyqIE3aGlMTA3e6pQMiufBraRLAJi35EdsS8+GfFOzokIHHCfRd
	 bxgZ2md4fRNvy2PO8w8Hg1+hvl26OKgXRbhzrornZ5J0UQrvUxi8a4uc9LusC8HfrxPLE
	 5iM2NF9zFGkA21y3TKUuWGcDjuOPL2UWSLpXWyQjF4aXTpCNuK7Zu6/xfl+k/6RiGyDTi
	 lRigWZHqEjSmGqZ8UUsaT3xvJEkGvDLdfYj8x5uryKAn/alX6S0lxORJFbVz07ewALA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795725229;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=rT/uTmzNKxMvsqi8XZ+5uVfICu0GrIbhrUkbcq2n7vg=;
	b=1V8wZR7/dUwcz2xugF0z0o/5AyfLkF9zP6j+GlGlFVvpfJYWfZq3NeFwcDBFMvWEnBGK
	 uot6KTnNyk4bmyFzGCqN60CKns4oz8yy7Da5b1Y2C5hZYuWtQGHYegdFEJtIwf+Az/Scs
	 37bXL2JGG822pg/x9NVLMWg4CRh9jM57DH0MPnBKEkBpapX8mAGDousNlvsEa/eVYwGvS
	 r4QRt5zHY1a4B4uOacpfgriqcrD6I5g/Yzr/WfPSgAA4ikgK5vCwMYhftSzLXI1zm7smK
	 eVKMgQ6gLXWNIEC0LYrw2NWB9VwVmf96R6qlBEl4Pwt2h+6CYhiM1VyU9Z3+Ivhlu6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ozBNRXjj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F029606A33A
	for <linux-xfs@vger.kernel.org>; Thu, 26 Nov 2026 20:33:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ozBNRXjj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E91461F000C1;
	Thu, 26 Nov 2026 20:33:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795725228;
	bh=rT/uTmzNKxMvsqi8XZ+5uVfICu0GrIbhrUkbcq2n7vg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ozBNRXjj3nKhWKFY5VKDvdopAFxRd79Dw5Ye+MI9mo5dIS4VGohX57YXHTXsc79VI
	 kgpxLFMWqTZS1UnDSGVY6wjMso5Wno2YSeQPPRCYC3f16taR+o0iGx0Xfo3i6+/eTL
	 0hbJaZSA/h6j6p1GGaBtarXMDEmvolONnRaNb5PnqsP9aFNPWs5Y8rErGBmodzCkKy
	 uHvfuvBtHF+BOSELmCKM2VAlfyHiY9dq5XIwOZjsajiNvimNPPsTKrjx/Dke84XWjD
	 B0ppuvTWBuERkydfkbVaCmA+Rdvg2jxxIzCDA5iEayBikEXYByZiMqDVMJ9UNq9A2M
	 nTSD/0Dm/6mNw==
Date: Fri, 27 Nov 2026 07:33:40 +1100
From: Dave Chinner <dgc@kernel.org>
To: "Steinar H. Gunderson" <steinar+kernel@gunderson.no>
Cc: linux-xfs@vger.kernel.org
Subject: Re: Hung I/O
Message-ID: <awiXpKJTg0RvIGE1@dread>
References: <sh2gykmlybrlf77d6mp76pddecwl47pxoookx2sbo74y6ffme4@gcu2kqu7q4o2>
 <awc-vvNFH3vfYLWv@dread>
 <w7gmeo5scvyud6uzggjcdegitwh3r4jnj3bl4ozivdzfwcrxda@tfafi2wvvnmx>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <w7gmeo5scvyud6uzggjcdegitwh3r4jnj3bl4ozivdzfwcrxda@tfafi2wvvnmx>

On Wed, Nov 25, 2026 at 10:02:25PM +0100, Steinar H. Gunderson wrote:
> On Thu, Nov 26, 2026 at 07:02:06AM +1100, Dave Chinner wrote:
> > can you post the entire dmesg output from 'echo w >
> > /proc/sysrq-trigger' and 'echo l > /proc/sysrq-trigger' to capture
> > all the currently blocked and running processes when the hang
> > happens.
> 
> Attached. (I did it a couple of times and picked out only one.)
> 
> Interestingly, the very act of taking the sysrqs seems to unblock the
> processes in some cases.

It looks like an MD RAID5 issue...

> 
> > Start with getting all the blocked tasks and building a dependency
> > map of which tasks are stuck behind others. That will narrow down
> > whether this is some internal deadlock in the filesystem or whether
> > the lower layers of the stack have lost a bunch of IO completions...
> 
> It's not quite obvious to me how to find out which ones are actually
> blocked on whom. Like, if someone is waiting for a lock, how do I
> figure out who is holding that lock?

Knowing the code is really the only way to do that...

> /* Steinar */
> -- 
> Homepage: https://www.sesse.net/

> [42462.794262] sysrq: Show Blocked State
> [42462.799066] task:md1_raid6       state:D stack:0     pid:5254  tgid:5254  ppid:2      task_flags:0x208040 flags:0x00080000
> [42462.802996] Call Trace:
> [42462.806905]  <TASK>
> [42462.810824]  ? __pfx_wbt_cleanup_cb+0x10/0x10
> [42462.814749]  __schedule+0x581/0x10b0
> [42462.818646]  ? __pfx_wbt_inflight_cb+0x10/0x10
> [42462.822517]  ? __pfx_wbt_cleanup_cb+0x10/0x10
> [42462.826320]  schedule+0x28/0xa0
> [42462.830049]  io_schedule+0x46/0x70
> [42462.833730]  rq_qos_wait+0xb3/0x150
> [42462.837317]  ? __pfx_rq_qos_wake_function+0x10/0x10
> [42462.840847]  ? __pfx_wbt_inflight_cb+0x10/0x10
> [42462.844314]  wbt_wait+0xa5/0x100
> [42462.847741]  __rq_qos_throttle+0x27/0x40
> [42462.851173]  blk_mq_submit_bio+0x589/0x8b0
> [42462.854613]  submit_bio_noacct_nocheck+0x27f/0x350
> [42462.858079]  ? bio_associate_blkg+0xb3/0x140
> [42462.861547]  ops_run_io+0x790/0xc50 [raid456]
> [42462.864992]  ? __pfx_raid5_end_write_request+0x10/0x10 [raid456]
> [42462.868420]  handle_stripe+0xb44/0x2410 [raid456]
> [42462.871894]  ? __hrtimer_rearm_deferred+0x5d/0x130
> [42462.875347]  handle_active_stripes.isra.0+0x37c/0x5a0 [raid456]
> [42462.878780]  raid5d+0x4cd/0x7a0 [raid456]
> [42462.882152]  md_thread+0xa5/0x1d0 [md_mod]
> [42462.885490]  ? __pfx_autoremove_wake_function+0x10/0x10
> [42462.888782]  ? __pfx_md_thread+0x10/0x10 [md_mod]
> [42462.891983]  kthread+0xe5/0x120
> [42462.895108]  ? __pfx_kthread+0x10/0x10
> [42462.898206]  ret_from_fork+0x2b7/0x340
> [42462.901298]  ? __pfx_kthread+0x10/0x10
> [42462.904376]  ret_from_fork_asm+0x1a/0x30

Ok, so MD stripe writeback is getting throttled by the block layer.
That'll slow -everything- filesystem related down.

> [42462.973060] task:xfsaild/dm-39   state:D stack:0     pid:10658 tgid:10658 ppid:2      task_flags:0x200840 flags:0x00080000
> [42462.975864] Call Trace:
> [42462.978626]  <TASK>
> [42462.981381]  __schedule+0x581/0x10b0
> [42462.984141]  schedule+0x28/0xa0
> [42462.986884]  raid5_get_active_stripe+0x283/0x5a0 [raid456]
> [42462.989686]  ? __pfx_autoremove_wake_function+0x10/0x10
> [42462.992503]  raid5_make_request+0x226/0x1520 [raid456]
> [42462.995344]  ? bdev_start_io_acct+0x2a/0xa0
> [42462.998171]  ? dm_io_acct+0xb9/0xf0 [dm_mod]
> [42463.000999]  ? __pfx_woken_wake_function+0x10/0x10
> [42463.003842]  md_handle_request+0x22b/0x370 [md_mod]
> [42463.006668]  ? bio_split_to_limits+0x145/0x160
> [42463.009470]  __submit_bio+0xa1/0x140
> [42463.012249]  submit_bio_noacct_nocheck+0x12a/0x350
> [42463.015033]  xfs_buf_submit+0x1b2/0x440 [xfs]
> [42463.017864]  ? down_trylock+0x34/0x40
> [42463.020618]  xfs_buf_delwri_submit_nowait+0xb8/0x130 [xfs]
> [42463.023449]  ? xfs_buf_unlock+0x17/0x70 [xfs]
> [42463.026264]  xfsaild+0x2ca/0xa40 [xfs]

XFS metadata writeback is stuck in MD waiting for stripes to become
unblocked ....

> [42463.349811] task:kworker/3:1     state:D stack:0     pid:814192 tgid:814192 ppid:2      task_flags:0x4208060 flags:0x00080000
> [42463.352793] Workqueue: xfs-sync/dm-44 xfs_log_worker [xfs]
> [42463.355839] Call Trace:
> [42463.358846]  <TASK>
> [42463.361864]  __schedule+0x581/0x10b0
> [42463.364882]  schedule+0x28/0xa0
> [42463.367869]  raid5_get_active_stripe+0x283/0x5a0 [raid456]
> [42463.370870]  ? __pfx_autoremove_wake_function+0x10/0x10
> [42463.373842]  raid5_make_request+0x226/0x1520 [raid456]
> [42463.376814]  ? bdev_start_io_acct+0x2a/0xa0
> [42463.379787]  ? dm_io_acct+0xb9/0xf0 [dm_mod]
> [42463.382765]  ? __pfx_woken_wake_function+0x10/0x10
> [42463.385762]  md_handle_request+0x22b/0x370 [md_mod]
> [42463.388726]  ? bio_split_to_limits+0x145/0x160
> [42463.391611]  __submit_bio+0xa1/0x140
> [42463.394404]  submit_bio_noacct_nocheck+0x12a/0x350
> [42463.397256]  xlog_state_release_iclog+0xe2/0x150 [xfs]
> [42463.400186]  xfs_log_force+0x1d6/0x240 [xfs]
> [42463.403110]  xfs_log_worker+0x3d/0xc0 [xfs]
> [42463.406009]  process_one_work+0x1ca/0x3c0
> [42463.408875]  worker_thread+0x1ac/0x320
> [42463.411721]  ? __pfx_worker_thread+0x10/0x10
> [42463.414570]  kthread+0xe5/0x120
> [42463.417396]  ? __pfx_kthread+0x10/0x10
> [42463.420222]  ret_from_fork+0x2b7/0x340
> [42463.423034]  ? __pfx_kthread+0x10/0x10
> [42463.425829]  ret_from_fork_asm+0x1a/0x30
> [42463.428611]  </TASK>

As is the journal flushing IO engine on a different filesystem.


> [42477.883324] task:kworker/124:3   state:D stack:0     pid:1020182 tgid:1020182 ppid:2      task_flags:0x4208060 flags:0x00080000
> [42477.889187] Workqueue: xfs-sync/dm-37 xfs_log_worker [xfs]
> [42477.892213] Call Trace:
> [42477.895145]  <TASK>
> [42477.898067]  __schedule+0x581/0x10b0
> [42477.901031]  schedule+0x28/0xa0
> [42477.903966]  raid5_get_active_stripe+0x283/0x5a0 [raid456]
> [42477.906911]  ? __pfx_autoremove_wake_function+0x10/0x10
> [42477.909783]  raid5_make_request+0x226/0x1520 [raid456]
> [42477.912567]  ? bdev_start_io_acct+0x2a/0xa0
> [42477.915325]  ? dm_io_acct+0xb9/0xf0 [dm_mod]
> [42477.918062]  ? __pfx_woken_wake_function+0x10/0x10
> [42477.920845]  md_handle_request+0x22b/0x370 [md_mod]
> [42477.923651]  ? bio_split_to_limits+0x145/0x160
> [42477.926458]  __submit_bio+0xa1/0x140
> [42477.929275]  submit_bio_noacct_nocheck+0x12a/0x350
> [42477.932124]  xlog_state_release_iclog+0xe2/0x150 [xfs]
> [42477.935029]  xfs_log_force+0x1d6/0x240 [xfs]
> [42477.937890]  xfs_log_worker+0x3d/0xc0 [xfs]
> [42477.940734]  process_one_work+0x1ca/0x3c0
> [42477.943553]  worker_thread+0x1ac/0x320
> [42477.946368]  ? __pfx_worker_thread+0x10/0x10
> [42477.949193]  kthread+0xe5/0x120
> [42477.952007]  ? __pfx_kthread+0x10/0x10
> [42477.954810]  ret_from_fork+0x2b7/0x340
> [42477.957596]  ? __pfx_kthread+0x10/0x10
> [42477.960369]  ret_from_fork_asm+0x1a/0x30

And another XFS filesystem blocked the same way.

This looks like an MD problem (slow or hang), and not a filesystem
issue at all.

> [42478.318725] task:kworker/u525:3  state:D stack:0     pid:1111037 tgid:1111037 ppid:2      task_flags:0x4248060 flags:0x00080000
> [42478.324258] Workqueue: xfs-cil/dm-23 xlog_cil_push_work [xfs]
> [42478.327161] Call Trace:
> [42478.329997]  <TASK>
> [42478.332814]  ? __pfx_wbt_cleanup_cb+0x10/0x10
> [42478.335681]  __schedule+0x581/0x10b0
> [42478.338533]  ? __pfx_wbt_inflight_cb+0x10/0x10
> [42478.341411]  ? __pfx_wbt_cleanup_cb+0x10/0x10
> [42478.344189]  schedule+0x28/0xa0
> [42478.346840]  io_schedule+0x46/0x70
> [42478.349461]  rq_qos_wait+0xb3/0x150
> [42478.352056]  ? __pfx_rq_qos_wake_function+0x10/0x10
> [42478.354697]  ? __pfx_wbt_inflight_cb+0x10/0x10
> [42478.357343]  wbt_wait+0xa5/0x100
> [42478.359980]  __rq_qos_throttle+0x27/0x40
> [42478.362636]  blk_mq_submit_bio+0x589/0x8b0
> [42478.365299]  submit_bio_noacct_nocheck+0x12a/0x350
> [42478.367987]  xlog_state_release_iclog+0xe2/0x150 [xfs]
> [42478.370736]  xlog_cil_push_work+0x719/0x9b0 [xfs]
> [42478.373491]  process_one_work+0x1ca/0x3c0
> [42478.376212]  worker_thread+0x1ac/0x320
> [42478.378908]  ? __pfx_worker_thread+0x10/0x10
> [42478.381611]  kthread+0xe5/0x120
> [42478.384294]  ? __pfx_kthread+0x10/0x10
> [42478.386952]  ret_from_fork+0x2b7/0x340
> [42478.389591]  ? __pfx_kthread+0x10/0x10
> [42478.392213]  ret_from_fork_asm+0x1a/0x30

Yup, and there's enough stuff queued in the md block devices for it
to trigger throttling on all incoming writes, even non-writeback IO.

Ok, so what's the storage config? What's the storage config? I'm
guessing the problem is wide RAID6 stripes, lots of small random
writes, and lots of partial cached stripes that need (slow) RMW
cycles to flush to disk, and slow disks....

-Dave.
-- 
Dave Chinner
dgc@kernel.org
