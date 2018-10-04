Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:59324 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725998AbeJEGVg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Oct 2018 02:21:36 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 1023E294AC
        for <linux-xfs@vger.kernel.org>; Thu,  4 Oct 2018 23:25:50 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 201331] deadlock (XFS?)
Date: Thu, 04 Oct 2018 23:25:49 +0000
Message-ID: <bug-201331-201763-PBFOGZcV41@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201331-201763@https.bugzilla.kernel.org/>
References: <bug-201331-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=201331

--- Comment #4 from edo (edo.rus@gmail.com) ---
I tested with 4.17 and 4.18 prebuilt Debian kernels, behavior is the same:
Sep 30 16:01:23 storage10x10n1 kernel: [23683.218388] INFO: task
kworker/u24:0:21848 blocked for more than 120 seconds.
Sep 30 16:01:23 storage10x10n1 kernel: [23683.218495]       Not tainted
4.18.0-0.bpo.1-amd64 #1 Debian 4.18.6-1~bpo9+1
Sep 30 16:01:23 storage10x10n1 kernel: [23683.218593] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Sep 30 16:01:23 storage10x10n1 kernel: [23683.218712] kworker/u24:0   D    0
21848      2 0x80000000
Sep 30 16:01:23 storage10x10n1 kernel: [23683.218814] Workqueue: writeback
wb_workfn (flush-9:3)
Sep 30 16:01:23 storage10x10n1 kernel: [23683.218910] Call Trace:
Sep 30 16:01:23 storage10x10n1 kernel: [23683.219005]  ? __schedule+0x3f5/0x880
Sep 30 16:01:23 storage10x10n1 kernel: [23683.219096]  schedule+0x32/0x80
Sep 30 16:01:23 storage10x10n1 kernel: [23683.219192] 
bitmap_startwrite+0x161/0x1e0 [md_mod]
Sep 30 16:01:23 storage10x10n1 kernel: [23683.219291]  ?
remove_wait_queue+0x60/0x60
Sep 30 16:01:23 storage10x10n1 kernel: [23683.219388] 
add_stripe_bio+0x441/0x7d0 [raid456]
Sep 30 16:01:23 storage10x10n1 kernel: [23683.219484] 
raid5_make_request+0x1ae/0xb10 [raid456]
Sep 30 16:01:23 storage10x10n1 kernel: [23683.219580]  ?
remove_wait_queue+0x60/0x60
Sep 30 16:01:23 storage10x10n1 kernel: [23683.219675]  ?
blk_queue_split+0x222/0x5e0
Sep 30 16:01:23 storage10x10n1 kernel: [23683.219770] 
md_handle_request+0x116/0x190 [md_mod]
Sep 30 16:01:23 storage10x10n1 kernel: [23683.219867] 
md_make_request+0x65/0x160 [md_mod]
Sep 30 16:01:23 storage10x10n1 kernel: [23683.219962] 
generic_make_request+0x1e7/0x410
Sep 30 16:01:23 storage10x10n1 kernel: [23683.220058]  ? submit_bio+0x6c/0x140
Sep 30 16:01:23 storage10x10n1 kernel: [23683.220148]  submit_bio+0x6c/0x140
Sep 30 16:01:23 storage10x10n1 kernel: [23683.220294] 
xfs_add_to_ioend+0x14c/0x280 [xfs]
Sep 30 16:01:23 storage10x10n1 kernel: [23683.220415]  ?
xfs_map_buffer.isra.14+0x37/0x70 [xfs]
Sep 30 16:01:23 storage10x10n1 kernel: [23683.220534] 
xfs_do_writepage+0x2bb/0x680 [xfs]
Sep 30 16:01:23 storage10x10n1 kernel: [23683.220632]  ?
clear_page_dirty_for_io+0x20c/0x2a0
Sep 30 16:01:23 storage10x10n1 kernel: [23683.220727] 
write_cache_pages+0x1ed/0x430
Sep 30 16:01:23 storage10x10n1 kernel: [23683.220852]  ?
xfs_add_to_ioend+0x280/0x280 [xfs]
Sep 30 16:01:23 storage10x10n1 kernel: [23683.220971] 
xfs_vm_writepages+0x64/0xa0 [xfs]
Sep 30 16:01:23 storage10x10n1 kernel: [23683.221068]  do_writepages+0x1a/0x60
Sep 30 16:01:23 storage10x10n1 kernel: [23683.221161] 
__writeback_single_inode+0x3d/0x320
Sep 30 16:01:23 storage10x10n1 kernel: [23683.221255] 
writeback_sb_inodes+0x221/0x4b0
Sep 30 16:01:23 storage10x10n1 kernel: [23683.221349] 
__writeback_inodes_wb+0x87/0xb0
Sep 30 16:01:23 storage10x10n1 kernel: [23683.221442]  wb_writeback+0x288/0x320
Sep 30 16:01:23 storage10x10n1 kernel: [23683.221534]  ? cpumask_next+0x16/0x20
Sep 30 16:01:23 storage10x10n1 kernel: [23683.221626]  ? wb_workfn+0x37c/0x450
Sep 30 16:01:23 storage10x10n1 kernel: [23683.221717]  wb_workfn+0x37c/0x450
Sep 30 16:01:23 storage10x10n1 kernel: [23683.221811] 
process_one_work+0x191/0x370
Sep 30 16:01:23 storage10x10n1 kernel: [23683.221904]  worker_thread+0x4f/0x3b0
Sep 30 16:01:23 storage10x10n1 kernel: [23683.221995]  kthread+0xf8/0x130
Sep 30 16:01:23 storage10x10n1 kernel: [23683.222086]  ?
rescuer_thread+0x340/0x340
Sep 30 16:01:23 storage10x10n1 kernel: [23683.222179]  ?
kthread_create_worker_on_cpu+0x70/0x70
Sep 30 16:01:23 storage10x10n1 kernel: [23683.222276]  ret_from_fork+0x1f/0x40

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
