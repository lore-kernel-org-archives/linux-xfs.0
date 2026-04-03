Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0CB63BC689
	for <linux-xfs@vger.kernel.org>; Fri,  3 Apr 2026 15:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775230554; cv=none; b=dYrnKePz7JLiTFYIy7majEkXpzawaTAO/ccGia7zhcXNYmHvScaUTiz0qqN21Shoeu+FxYkIgHqHwzalS6Pw/8vrREHPJyyG/Ny6FO1tST695cLdCE1bynJFXSQLjS9K7vchOSbcoZp+kf75Cwifk3jQ71j6MPYI5pf8cUxxPuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775230554; c=relaxed/simple;
	bh=OhqNZC9EWGOJTRXMAMSXOVy8yp69ltx+Kcmp3MY/fpo=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=THEFIkwqenz6jBnwMjHKiD9/UlYssrfLtgGI8ECJz26Z617+i/Is7jE++z5tzQn6wOxFjU6ryXA6M7nU2zxwDdDhsFC7palSgqxWHWq/bmhsWoot0+lidjUDO7LTLaZKfqTVoH2XkMSDvH1eDEj/519gMhy5IvNYqV1oX7odoq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=kK+LHeRV; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="kK+LHeRV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Type:MIME-Version:Message-ID:
	Subject:To:From:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=Yg3avPiJBKLO1HHEAp2S8qX1VaErTRzXG868jEBL2ak=; b=kK+LHeRVCC9OnAnL/Vv1f3OQek
	1gW9JIP4GhxfBE9R53SgnNOK3Eo71D/8fn9q84eUy00xIWWoJa1udDCU5Slq0PS7CCXV6vFaC87Y5
	43eOVoGyf3zmKIy6jrZm/J4hrsnY9ukoYXu90yK6OMMnL3PDljaOD+S0tNZJ2xMKy6T6PMd0OJcp1
	Y7WJOZR815Vebe1n695YMt0mt75Epc7cvwKw7k4K7l/MSFjOOgCSdHCTN+qlIotyUorz2u38NxUGz
	HO4ocQaw6DdDN40Qmx5Mqoey5tbcXHKz7vCHozpuAh93hylSUKJCCY8PGuyu1wb6rIGCQ3q/KLNVo
	5e15ehLA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w8gYl-0000000EeOd-0dDN
	for linux-xfs@vger.kernel.org;
	Fri, 03 Apr 2026 15:35:47 +0000
Date: Fri, 3 Apr 2026 16:35:46 +0100
From: Matthew Wilcox <willy@infradead.org>
To: linux-xfs@vger.kernel.org
Subject: Hang with xfs/285 on 2026-03-02 kernel
Message-ID: <ac_eUsuxqf6IYN7F@casper.infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

This is with commit 5619b098e2fb so after 7.0-rc6

xfs/285       run fstests xfs/285 at 2026-04-03 06:11:42
XFS (vdc): Mounting V5 Filesystem e091474f-2cd9-4425-a30c-1114d62d130b
XFS (vdc): Ending clean mount
INFO: task fsstress:3762792 blocked for more than 120 seconds.
      Not tainted 7.0.0-rc6-ktest-00166-g5619b098e2fb #104
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:fsstress        state:D stack:0     pid:3762792 tgid:3762792 ppid:3762783 task_flags:0x440140 flags:0x00080000
Call Trace:
 <TASK>
 __schedule+0x560/0xfc0
 schedule+0x3e/0x140
 schedule_timeout+0xb3/0x110
 __down_common+0x15c/0x2c0
 __down+0x1d/0x30
 down+0x68/0x80
 xfs_buf_lock+0x4b/0x170
 xfs_buf_find_lock+0x69/0x140
 xfs_buf_get_map+0x265/0xbd0
 xfs_buf_read_map+0x59/0x2e0
 xfs_trans_read_buf_map+0x1bb/0x560
 ? xfs_read_agi+0xab/0x1a0
 xfs_read_agi+0xab/0x1a0
 xfs_ialloc_read_agi+0x61/0x200
 xfs_iwalk_ag_start.constprop.0+0x4e/0x1e0
 xfs_iwalk_ag+0x78/0x2d0
 xfs_iwalk_args.constprop.0+0x67/0x120
 xfs_iwalk+0x93/0xa0
 ? __pfx_xfs_bulkstat_iwalk+0x10/0x10
 xfs_bulkstat+0xce/0x150
 ? __pfx_xfs_fsbulkstat_one_fmt+0x10/0x10
 xfs_ioc_fsbulkstat.isra.0+0x122/0x1f0
 xfs_file_ioctl+0xd52/0x1230
 ? find_held_lock+0x31/0x90
 ? kmem_cache_free+0x26c/0x460
 ? lock_release+0xba/0x260
 ? putname+0x45/0x80
 ? kmem_cache_free+0x271/0x460
 __x64_sys_ioctl+0x4d0/0x9d0
 x64_sys_call+0xf1f/0x1dd0
 do_syscall_64+0x74/0x3f0
 entry_SYSCALL_64_after_hwframe+0x76/0x7e
RIP: 0033:0x7f37be22237b
RSP: 002b:00007ffe8acd1a30 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 0000000000002300 RCX: 00007f37be22237b
RDX: 00007ffe8acd1aa0 RSI: ffffffffc0205865 RDI: 0000000000000003
RBP: 0000000000000003 R08: 00007f37be2fdac0 R09: 0000000000000001
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000080
R13: 00007ffe8acd1aa0 R14: 000055ac9b289fe0 R15: 000000000001382d
 </TASK>
INFO: task fsstress:3762792 blocked on a semaphore likely last held by task fsstress:3762793
task:fsstress        state:D stack:0     pid:3762793 tgid:3762793 ppid:3762783 task_flags:0x440140 flags:0x00080800
Call Trace:
 <TASK>
 __schedule+0x560/0xfc0
 schedule+0x3e/0x140
 schedule_timeout+0x84/0x110
 ? __pfx_process_timeout+0x10/0x10
 io_schedule_timeout+0x5b/0x80
 xfs_buf_alloc+0x793/0x7d0
 xfs_buf_get_map+0x651/0xbd0
 ? _raw_spin_unlock+0x26/0x50
 xfs_trans_get_buf_map+0x141/0x300
 xfs_ialloc_inode_init+0x130/0x2c0
 xfs_ialloc_ag_alloc+0x226/0x710
 xfs_dialloc+0x22d/0x980
 ? xfs_ilock+0x168/0x2b0
 xfs_create+0x29e/0x4a0
 ? __get_acl+0x2d/0x1c0
 xfs_generic_create+0x2a4/0x330
 xfs_vn_mkdir+0x1e/0x30
 vfs_mkdir+0xaf/0x1f0
 filename_mkdirat+0x81/0x190
 __x64_sys_mkdir+0x32/0x50
 x64_sys_call+0x8e4/0x1dd0
 do_syscall_64+0x74/0x3f0
 entry_SYSCALL_64_after_hwframe+0x76/0x7e
RIP: 0033:0x7f37be218b47
RSP: 002b:00007ffe8acd1958 EFLAGS: 00000206 ORIG_RAX: 0000000000000053
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f37be218b47
RDX: 0000000000000000 RSI: 00000000000001ff RDI: 000055ac9ac6de40
RBP: 00007ffe8acd1ac0 R08: 000000055ac9aeaa R09: 00007f37be2fdac0
R10: 0000000000000007 R11: 0000000000000206 R12: 00000000000001ff
R13: 00007ffe8acd1ac0 R14: 0000000000002a8d R15: 000055ac98e46790
 </TASK>
INFO: task fsstress:3762794 blocked for more than 120 seconds.
      Not tainted 7.0.0-rc6-ktest-00166-g5619b098e2fb #104
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:fsstress        state:D stack:0     pid:3762794 tgid:3762794 ppid:3762783 task_flags:0x440140 flags:0x00080000
Call Trace:
 <TASK>
 __schedule+0x560/0xfc0
 schedule+0x3e/0x140
 schedule_timeout+0xb3/0x110
 __down_common+0x15c/0x2c0
 __down+0x1d/0x30
 down+0x68/0x80
 xfs_buf_lock+0x4b/0x170
 xfs_buf_find_lock+0x69/0x140
 xfs_buf_get_map+0x265/0xbd0
 ? find_held_lock+0x31/0x90
 xfs_buf_read_map+0x59/0x2e0
 xfs_trans_read_buf_map+0x1bb/0x560
 ? xfs_read_agi+0xab/0x1a0
 xfs_read_agi+0xab/0x1a0
 xfs_ialloc_read_agi+0x61/0x200
 xfs_dialloc+0x1f1/0x980
 ? xfs_ilock+0x168/0x2b0
 xfs_create+0x29e/0x4a0
 ? __get_acl+0x2d/0x1c0
 xfs_generic_create+0x2a4/0x330
 xfs_vn_mknod+0x18/0x20
 vfs_mknod+0xcd/0x200
 filename_mknodat+0x1fd/0x2a0
 __x64_sys_mknodat+0x3f/0x60
 x64_sys_call+0x1c77/0x1dd0
 do_syscall_64+0x74/0x3f0
 entry_SYSCALL_64_after_hwframe+0x76/0x7e
RIP: 0033:0x7f37be218bf3
RSP: 002b:00007ffe8acd1958 EFLAGS: 00000256 ORIG_RAX: 0000000000000103
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f37be218bf3
RDX: 0000000000002124 RSI: 000055ac9ac3ff40 RDI: 00000000ffffff9c
RBP: 00007ffe8acd1ac0 R08: 000000055ac9afba R09: 00007f37be2fdac0
R10: 0000000000000000 R11: 0000000000000256 R12: 0000000000002124
R13: 0000000000000000 R14: 00000000000017a5 R15: 000055ac98e468f0
 </TASK>
INFO: task fsstress:3762794 blocked on a semaphore likely last held by task fsstress:3762793
task:fsstress        state:D stack:0     pid:3762793 tgid:3762793 ppid:3762783 task_flags:0x440140 flags:0x00080800
Call Trace:
 <TASK>
 __schedule+0x560/0xfc0
 schedule+0x3e/0x140
 schedule_timeout+0x84/0x110
 ? __pfx_process_timeout+0x10/0x10
 io_schedule_timeout+0x5b/0x80
 xfs_buf_alloc+0x793/0x7d0
 xfs_buf_get_map+0x651/0xbd0
 ? _raw_spin_unlock+0x26/0x50
 xfs_trans_get_buf_map+0x141/0x300
 xfs_ialloc_inode_init+0x130/0x2c0
 xfs_ialloc_ag_alloc+0x226/0x710
 xfs_dialloc+0x22d/0x980
 ? xfs_ilock+0x168/0x2b0
 xfs_create+0x29e/0x4a0
 ? __get_acl+0x2d/0x1c0
 xfs_generic_create+0x2a4/0x330
 xfs_vn_mkdir+0x1e/0x30
 vfs_mkdir+0xaf/0x1f0
 filename_mkdirat+0x81/0x190
 __x64_sys_mkdir+0x32/0x50
 x64_sys_call+0x8e4/0x1dd0
 do_syscall_64+0x74/0x3f0
 entry_SYSCALL_64_after_hwframe+0x76/0x7e
RIP: 0033:0x7f37be218b47
RSP: 002b:00007ffe8acd1958 EFLAGS: 00000206 ORIG_RAX: 0000000000000053
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f37be218b47
RDX: 0000000000000000 RSI: 00000000000001ff RDI: 000055ac9ac6de40
RBP: 00007ffe8acd1ac0 R08: 000000055ac9aeaa R09: 00007f37be2fdac0
R10: 0000000000000007 R11: 0000000000000206 R12: 00000000000001ff
R13: 00007ffe8acd1ac0 R14: 0000000000002a8d R15: 000055ac98e46790
 </TASK>
INFO: task fsstress:3762795 blocked for more than 120 seconds.
      Not tainted 7.0.0-rc6-ktest-00166-g5619b098e2fb #104
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:fsstress        state:D stack:0     pid:3762795 tgid:3762795 ppid:3762783 task_flags:0x440140 flags:0x00080000
Call Trace:
 <TASK>
 __schedule+0x560/0xfc0
 schedule+0x3e/0x140
 schedule_timeout+0xb3/0x110
 __down_common+0x15c/0x2c0
 __down+0x1d/0x30
 down+0x68/0x80
 xfs_buf_lock+0x4b/0x170
 xfs_buf_find_lock+0x69/0x140
 xfs_buf_get_map+0x265/0xbd0
 ? xfs_trans_add_item+0xf2/0x1b0
 xfs_buf_read_map+0x59/0x2e0
 xfs_trans_read_buf_map+0x1bb/0x560
 ? xfs_read_agi+0xab/0x1a0
 xfs_read_agi+0xab/0x1a0
 xfs_ialloc_read_agi+0x61/0x200
 xfs_iwalk_ag_start.constprop.0+0x4e/0x1e0
 xfs_iwalk_ag+0x78/0x2d0
 xfs_iwalk_args.constprop.0+0x67/0x120
 xfs_iwalk+0x93/0xa0
 ? __pfx_xfs_bulkstat_iwalk+0x10/0x10
 xfs_bulkstat+0xce/0x150
 ? __pfx_xfs_fsbulkstat_one_fmt+0x10/0x10
 xfs_ioc_fsbulkstat.isra.0+0x122/0x1f0
 xfs_file_ioctl+0xd52/0x1230
 ? find_held_lock+0x31/0x90
 ? kmem_cache_free+0x26c/0x460
 ? lock_release+0xba/0x260
 ? putname+0x45/0x80
 ? kmem_cache_free+0x271/0x460
 __x64_sys_ioctl+0x4d0/0x9d0
 x64_sys_call+0xf1f/0x1dd0
 do_syscall_64+0x74/0x3f0
 entry_SYSCALL_64_after_hwframe+0x76/0x7e
RIP: 0033:0x7f37be22237b
RSP: 002b:00007ffe8acd1a30 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 0000000000001f38 RCX: 00007f37be22237b
RDX: 00007ffe8acd1aa0 RSI: ffffffffc0205865 RDI: 0000000000000003
RBP: 0000000000000003 R08: 00007f37be2fdac0 R09: 0000000000000001
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000000003e7
R13: 00007ffe8acd1aa0 R14: 000055ac9b20b7d0 R15: 00000000000130f4
 </TASK>
INFO: task fsstress:3762795 blocked on a semaphore likely last held by task fsstress:3762793
task:fsstress        state:D stack:0     pid:3762793 tgid:3762793 ppid:3762783 task_flags:0x440140 flags:0x00080800
Call Trace:
 <TASK>
 __schedule+0x560/0xfc0
 schedule+0x3e/0x140
 schedule_timeout+0x84/0x110
 ? __pfx_process_timeout+0x10/0x10
 io_schedule_timeout+0x5b/0x80
 xfs_buf_alloc+0x793/0x7d0
 xfs_buf_get_map+0x651/0xbd0
 ? _raw_spin_unlock+0x26/0x50
 xfs_trans_get_buf_map+0x141/0x300
 xfs_ialloc_inode_init+0x130/0x2c0
 xfs_ialloc_ag_alloc+0x226/0x710
 xfs_dialloc+0x22d/0x980
 ? xfs_ilock+0x168/0x2b0
 xfs_create+0x29e/0x4a0
 ? __get_acl+0x2d/0x1c0
 xfs_generic_create+0x2a4/0x330
 xfs_vn_mkdir+0x1e/0x30
 vfs_mkdir+0xaf/0x1f0
 filename_mkdirat+0x81/0x190
 __x64_sys_mkdir+0x32/0x50
 x64_sys_call+0x8e4/0x1dd0
 do_syscall_64+0x74/0x3f0
 entry_SYSCALL_64_after_hwframe+0x76/0x7e
RIP: 0033:0x7f37be218b47
RSP: 002b:00007ffe8acd1958 EFLAGS: 00000206 ORIG_RAX: 0000000000000053
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f37be218b47
RDX: 0000000000000000 RSI: 00000000000001ff RDI: 000055ac9ac6de40
RBP: 00007ffe8acd1ac0 R08: 000000055ac9aeaa R09: 00007f37be2fdac0
R10: 0000000000000007 R11: 0000000000000206 R12: 00000000000001ff
R13: 00007ffe8acd1ac0 R14: 0000000000002a8d R15: 000055ac98e46790
 </TASK>
INFO: task kworker/8:19:3762862 blocked for more than 120 seconds.
      Not tainted 7.0.0-rc6-ktest-00166-g5619b098e2fb #104
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/8:19    state:D stack:0     pid:3762862 tgid:3762862 ppid:2      task_flags:0x4248060 flags:0x00080000
Workqueue: xfs-conv/vdc xfs_end_io
Call Trace:
 <TASK>
 __schedule+0x560/0xfc0
 schedule+0x3e/0x140
 schedule_timeout+0xb3/0x110
 __down_common+0x15c/0x2c0
 __down+0x1d/0x30
 down+0x68/0x80
 xfs_buf_lock+0x4b/0x170
 xfs_buf_find_lock+0x69/0x140
 xfs_buf_get_map+0x265/0xbd0
 ? xfs_btree_overlapped_query_range+0x39f/0x620
 xfs_buf_read_map+0x59/0x2e0
 xfs_trans_read_buf_map+0x1bb/0x560
 ? xfs_read_agf+0xa3/0x170
 xfs_read_agf+0xa3/0x170
 xfs_alloc_read_agf+0x73/0x370
 xfs_alloc_fix_freelist+0x2dc/0x670
 ? find_held_lock+0x31/0x90
 xfs_free_extent_fix_freelist+0x5e/0x80
 xfs_rmap_finish_one+0xc4/0x300
 ? kmem_cache_alloc_noprof+0x36a/0x450
 ? xfs_rmap_update_create_done+0x29/0xb0
 xfs_rmap_update_finish_item+0x1e/0x40
 xfs_defer_finish_one+0xc0/0x2d0
 ? xfs_defer_relog+0x56/0x280
 xfs_defer_finish_noroll+0x1ad/0x540
 xfs_trans_commit+0x4e/0x70
 xfs_iomap_write_unwritten+0xdd/0x340
 xfs_end_ioend_write+0x219/0x2c0
 xfs_end_io+0xdc/0xf0
 process_one_work+0x1fb/0x570
 ? lock_is_held_type+0x93/0x100
 worker_thread+0x1e6/0x3f0
 ? __pfx_worker_thread+0x10/0x10
 kthread+0x10d/0x140
 ? __pfx_kthread+0x10/0x10
 ret_from_fork+0x1b4/0x250
 ? __pfx_kthread+0x10/0x10
 ret_from_fork_asm+0x1a/0x30
 </TASK>
INFO: task kworker/8:19:3762862 blocked on a semaphore likely last held by task fsstress:3762793
task:fsstress        state:D stack:0     pid:3762793 tgid:3762793 ppid:3762783 task_flags:0x440140 flags:0x00080800
Call Trace:
 <TASK>
 __schedule+0x560/0xfc0
 schedule+0x3e/0x140
 schedule_timeout+0x84/0x110
 ? __pfx_process_timeout+0x10/0x10
 io_schedule_timeout+0x5b/0x80
 xfs_buf_alloc+0x793/0x7d0
 xfs_buf_get_map+0x651/0xbd0
 ? _raw_spin_unlock+0x26/0x50
 xfs_trans_get_buf_map+0x141/0x300
 xfs_ialloc_inode_init+0x130/0x2c0
 xfs_ialloc_ag_alloc+0x226/0x710
 xfs_dialloc+0x22d/0x980
 ? xfs_ilock+0x168/0x2b0
 xfs_create+0x29e/0x4a0
 ? __get_acl+0x2d/0x1c0
 xfs_generic_create+0x2a4/0x330
 xfs_vn_mkdir+0x1e/0x30
 vfs_mkdir+0xaf/0x1f0
 filename_mkdirat+0x81/0x190
 __x64_sys_mkdir+0x32/0x50
 x64_sys_call+0x8e4/0x1dd0
 do_syscall_64+0x74/0x3f0
 entry_SYSCALL_64_after_hwframe+0x76/0x7e
RIP: 0033:0x7f37be218b47
RSP: 002b:00007ffe8acd1958 EFLAGS: 00000206 ORIG_RAX: 0000000000000053
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f37be218b47
RDX: 0000000000000000 RSI: 00000000000001ff RDI: 000055ac9ac6de40
RBP: 00007ffe8acd1ac0 R08: 000000055ac9aeaa R09: 00007f37be2fdac0
R10: 0000000000000007 R11: 0000000000000206 R12: 00000000000001ff
R13: 00007ffe8acd1ac0 R14: 0000000000002a8d R15: 000055ac98e46790
 </TASK>

Showing all locks held in the system:
1 lock held by khungtaskd/100:
 #0: ffffffff826d67c0 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x51/0x115
5 locks held by kworker/u64:0/3558666:
 #0: ffff88810331dd48 ((wq_completion)xfs-blockgc/vdc){....}-{0:0}, at: process_one_work+0x45c/0x570
 #1: ffff88810f08fe48 ((work_completion)(&(&pag->pag_blockgc_work)->work)){....}-{0:0}, at: process_one_work+0x1bb/0x570
 #2: ffff888155e3c928 (&sb->s_type->i_mutex_key#17){....}-{3:3}, at: xfs_ilock_nowait+0x1ee/0x330
 #3: ffff8881478f55e0 (sb_internal#2){....}-{0:0}, at: xfs_free_eofblocks+0xda/0x1c0
 #4: ffff888155e3c718 (&xfs_nondir_ilock_class){....}-{3:3}, at: xfs_ilock+0x168/0x2b0
4 locks held by fsstress/3762793:
 #0: ffff8881478f53f0 (sb_writers#10){....}-{0:0}, at: filename_create+0x6e/0x180
 #1: ffff88816e264228 (&inode->i_sb->s_type->i_mutex_dir_key/1){....}-{3:3}, at: filename_create+0xad/0x180
 #2: ffff8881478f55e0 (sb_internal#2){....}-{0:0}, at: xfs_trans_alloc_icreate+0x58/0x100
 #3: ffff88816e264018 (&xfs_dir_ilock_class/5){....}-{3:3}, at: xfs_ilock+0x168/0x2b0
4 locks held by fsstress/3762794:
 #0: ffff8881478f53f0 (sb_writers#10){....}-{0:0}, at: filename_create+0x6e/0x180
 #1: ffff888038517328 (&inode->i_sb->s_type->i_mutex_dir_key/1){....}-{3:3}, at: filename_create+0xad/0x180
 #2: ffff8881478f55e0 (sb_internal#2){....}-{0:0}, at: xfs_trans_alloc_icreate+0x58/0x100
 #3: ffff888038517118 (&xfs_dir_ilock_class/5){....}-{3:3}, at: xfs_ilock+0x168/0x2b0
4 locks held by kworker/8:19/3762862:
 #0: ffff88815e73ed48 ((wq_completion)xfs-conv/vdc){....}-{0:0}, at: process_one_work+0x45c/0x570
 #1: ffff888104efbe48 ((work_completion)(&ip->i_ioend_work)){....}-{0:0}, at: process_one_work+0x1bb/0x570
 #2: ffff8881478f55e0 (sb_internal#2){....}-{0:0}, at: xfs_trans_alloc_inode+0x7d/0x190
 #3: ffff888137bb2b18 (&xfs_nondir_ilock_class){....}-{3:3}, at: xfs_ilock+0x168/0x2b0

(there are more messages after this, but i doubt they're useful)
