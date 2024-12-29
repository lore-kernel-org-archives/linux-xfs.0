Received: from mail-io1-f80.google.com (mail-io1-f80.google.com [209.85.166.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 644F123BE
	for <linux-xfs@vger.kernel.org>; Sun, 29 Dec 2024 03:03:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735441400; cv=none; b=buD8W3uL2KAf75vliPbsFV2SVTcrrvUEgBXLx47XOy0vJ4aNvFFLCiQnw33lM5HtzMEtSJgayjeJHMcvKSkVfIjax7rUMdOIGjeAc7pFBMPs3Dv4UWgu21iSfnmEbx4OaWJzY0M8JivOFoUNuvKWlFw7lnY8wrmjynIeqJZX4xM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735441400; c=relaxed/simple;
	bh=OGtiLnYQZ8ZC+YPjVLGIdziRwc37HD5awesWlmG4+k4=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=E11OyJ+Tlq3mSo3dipHjjYXiiPk6Q4kOaBy+psbhqXXK1imwJD/LQAo+cwCNl8QmDdXShkJ46sgdim7VSoqOB2N3KE5deM09PyE4Ee+I/MMOW1WNFhPWrjVojNhxfNsBSjz6oPZVNP4JiJzDdbumhDtf3sT1PuIUHrboT4s7FCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f80.google.com with SMTP id ca18e2360f4ac-844d54c3eb5so660415439f.0
        for <linux-xfs@vger.kernel.org>; Sat, 28 Dec 2024 19:03:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735441397; x=1736046197;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RA71hd7XF1Wn1P8GYtW8wMM5quFYy1s4O8hmlYrUaa8=;
        b=T8Q5aQ+p+y1oLC0FK/9EHM4u91ycEjzPERgZ20asxUZmSIIcebW0eyyk96vH10AIh5
         6mTIekiwJd9nsNkbG4Lho4C81hDUrHbPCbil+dELfVfwicjxSz/CpjxYBeBgIashYpJc
         ff1KTMFlLF9gSVgaM3SOvTk5GOysQOUegeN7oqE8mkD/zBB1yryFO2CwRUaMnOmuwbyK
         hknoiYJ4xVnUXrr2E+okdix5cMjw6cqpiLE/LLmHMWrGxoLKYw6vEVttV/sHmf266Y6U
         AExVO4szwL3M+FuT5wH/G4s6ja13/ewhnjmwWHPposkRvz/oD8hz2O95dehay6ZJg6xv
         iyYw==
X-Forwarded-Encrypted: i=1; AJvYcCWxKsYQteJfWljAP/F1+SXMEXjdY+nyHFxjWluIKLieYy5brZ+UFWvo1NKLMt5SgLSlV0TDGXX8rcE=@vger.kernel.org
X-Gm-Message-State: AOJu0YyYlhGp2CK6wzvb4qnvyHq8tt/QAlG8hWt5s2RFIgu/FaP/aKZD
	kKnNMmVkBJh1RtN6+dXs0CERBHFfOA6ibYYfDYYZMbfLyGYMDQu0RY+SjWQjmBHN4J4GY7jOZfV
	C1yyfMHh3J8N43ayZp8xp0LapIUa5K4qLSJu4+++wbnBLFf4jY9Y2t5Y=
X-Google-Smtp-Source: AGHT+IEmp8BT177ti2oCAXnsSDBxYox8Mhb6XF8ONperdJ/pmzDR9E0Dpxqg1hVA/U8oLW49QPzdt4sCP3NV8F1Mf3HvrDgrgxws
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:3f8f:b0:3a7:a3a4:2d4b with SMTP id
 e9e14a558f8ab-3c2d2d4cfccmr236349675ab.14.1735441397529; Sat, 28 Dec 2024
 19:03:17 -0800 (PST)
Date: Sat, 28 Dec 2024 19:03:17 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6770bbf5.050a0220.226966.00b8.GAE@google.com>
Subject: [syzbot] [xfs?] possible deadlock in xfs_inactive_truncate
From: syzbot <syzbot+36fd9d5c37b411f31c58@syzkaller.appspotmail.com>
To: cem@kernel.org, chandan.babu@oracle.com, djwong@kernel.org, 
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    9b2ffa6148b1 Merge tag 'mtd/fixes-for-6.13-rc5' of git://g..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=178400b0580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d269ef41b9262400
dashboard link: https://syzkaller.appspot.com/bug?extid=36fd9d5c37b411f31c58
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/73bb7d109a64/disk-9b2ffa61.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/001f7910aa4e/vmlinux-9b2ffa61.xz
kernel image: https://storage.googleapis.com/syzbot-assets/11e525a24c33/bzImage-9b2ffa61.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+36fd9d5c37b411f31c58@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
6.13.0-rc4-syzkaller-00012-g9b2ffa6148b1 #0 Not tainted
------------------------------------------------------
kworker/0:4/5890 is trying to acquire lock:
ffff88804e12f558 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_inactive_truncate+0xee/0x240 fs/xfs/xfs_inode.c:1157

but task is already holding lock:
ffff8880711ae610 (sb_internal#4){.+.+}-{0:0}, at: xfs_inactive_truncate+0xc8/0x240 fs/xfs/xfs_inode.c:1152

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #6 (sb_internal#4){.+.+}-{0:0}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5849
       percpu_down_read include/linux/percpu-rwsem.h:51 [inline]
       __sb_start_write include/linux/fs.h:1725 [inline]
       sb_start_intwrite include/linux/fs.h:1908 [inline]
       xfs_trans_alloc+0xe5/0x830 fs/xfs/xfs_trans.c:266
       xfs_vn_update_time+0x203/0x5f0 fs/xfs/xfs_iops.c:1103
       inode_update_time fs/inode.c:2124 [inline]
       touch_atime+0x27f/0x690 fs/inode.c:2197
       file_accessed include/linux/fs.h:2539 [inline]
       xfs_file_mmap+0x1ab/0x530 fs/xfs/xfs_file.c:1589
       call_mmap include/linux/fs.h:2183 [inline]
       mmap_file mm/internal.h:124 [inline]
       __mmap_new_file_vma mm/vma.c:2291 [inline]
       __mmap_new_vma mm/vma.c:2355 [inline]
       __mmap_region+0x2250/0x2d30 mm/vma.c:2456
       mmap_region+0x1d0/0x2c0 mm/mmap.c:1348
       do_mmap+0x8f0/0x1000 mm/mmap.c:496
       vm_mmap_pgoff+0x1dd/0x3d0 mm/util.c:580
       ksys_mmap_pgoff+0x4eb/0x720 mm/mmap.c:542
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #5 (&mm->mmap_lock){++++}-{4:4}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5849
       __might_fault+0xc6/0x120 mm/memory.c:6751
       _inline_copy_from_user include/linux/uaccess.h:162 [inline]
       _copy_from_user+0x2a/0xc0 lib/usercopy.c:18
       copy_from_user include/linux/uaccess.h:212 [inline]
       __blk_trace_setup kernel/trace/blktrace.c:626 [inline]
       blk_trace_ioctl+0x1ad/0x9a0 kernel/trace/blktrace.c:740
       blkdev_ioctl+0x40c/0x6a0 block/ioctl.c:682
       vfs_ioctl fs/ioctl.c:51 [inline]
       __do_sys_ioctl fs/ioctl.c:906 [inline]
       __se_sys_ioctl+0xf7/0x170 fs/ioctl.c:892
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #4 (&q->debugfs_mutex){+.+.}-{4:4}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5849
       __mutex_lock_common kernel/locking/mutex.c:585 [inline]
       __mutex_lock+0x1ac/0xee0 kernel/locking/mutex.c:735
       blk_mq_init_sched+0x3fa/0x830 block/blk-mq-sched.c:473
       elevator_init_mq+0x20e/0x320 block/elevator.c:610
       add_disk_fwnode+0x10d/0xf80 block/genhd.c:413
       sd_probe+0xba6/0x1100 drivers/scsi/sd.c:4024
       really_probe+0x2ba/0xad0 drivers/base/dd.c:658
       __driver_probe_device+0x1a2/0x390 drivers/base/dd.c:800
       driver_probe_device+0x50/0x430 drivers/base/dd.c:830
       __device_attach_driver+0x2d6/0x530 drivers/base/dd.c:958
       bus_for_each_drv+0x250/0x2e0 drivers/base/bus.c:459
       __device_attach_async_helper+0x22d/0x300 drivers/base/dd.c:987
       async_run_entry_fn+0xaa/0x420 kernel/async.c:129
       process_one_work kernel/workqueue.c:3229 [inline]
       process_scheduled_works+0xa68/0x1840 kernel/workqueue.c:3310
       worker_thread+0x870/0xd30 kernel/workqueue.c:3391
       kthread+0x2f2/0x390 kernel/kthread.c:389
       ret_from_fork+0x4d/0x80 arch/x86/kernel/process.c:147
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

-> #3 (&q->q_usage_counter(queue)#50){++++}-{0:0}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5849
       blk_queue_enter+0xe1/0x600 block/blk-core.c:328
       blk_mq_alloc_request+0x4fa/0xaa0 block/blk-mq.c:652
       scsi_alloc_request drivers/scsi/scsi_lib.c:1222 [inline]
       scsi_execute_cmd+0x177/0x1090 drivers/scsi/scsi_lib.c:304
       read_capacity_16+0x2b4/0x1450 drivers/scsi/sd.c:2655
       sd_read_capacity drivers/scsi/sd.c:2824 [inline]
       sd_revalidate_disk+0x1013/0xbce0 drivers/scsi/sd.c:3734
       sd_probe+0x9fa/0x1100 drivers/scsi/sd.c:4010
       really_probe+0x2ba/0xad0 drivers/base/dd.c:658
       __driver_probe_device+0x1a2/0x390 drivers/base/dd.c:800
       driver_probe_device+0x50/0x430 drivers/base/dd.c:830
       __device_attach_driver+0x2d6/0x530 drivers/base/dd.c:958
       bus_for_each_drv+0x250/0x2e0 drivers/base/bus.c:459
       __device_attach_async_helper+0x22d/0x300 drivers/base/dd.c:987
       async_run_entry_fn+0xaa/0x420 kernel/async.c:129
       process_one_work kernel/workqueue.c:3229 [inline]
       process_scheduled_works+0xa68/0x1840 kernel/workqueue.c:3310
       worker_thread+0x870/0xd30 kernel/workqueue.c:3391
       kthread+0x2f2/0x390 kernel/kthread.c:389
       ret_from_fork+0x4d/0x80 arch/x86/kernel/process.c:147
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

-> #2 (&q->limits_lock){+.+.}-{4:4}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5849
       __mutex_lock_common kernel/locking/mutex.c:585 [inline]
       __mutex_lock+0x1ac/0xee0 kernel/locking/mutex.c:735
       queue_limits_start_update include/linux/blkdev.h:947 [inline]
       loop_reconfigure_limits+0x43f/0x900 drivers/block/loop.c:998
       loop_set_block_size drivers/block/loop.c:1473 [inline]
       lo_simple_ioctl drivers/block/loop.c:1496 [inline]
       lo_ioctl+0x1351/0x1f50 drivers/block/loop.c:1559
       blkdev_ioctl+0x57f/0x6a0 block/ioctl.c:693
       vfs_ioctl fs/ioctl.c:51 [inline]
       __do_sys_ioctl fs/ioctl.c:906 [inline]
       __se_sys_ioctl+0xf7/0x170 fs/ioctl.c:892
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #1 (&q->q_usage_counter(io)#23){++++}-{0:0}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5849
       bio_queue_enter block/blk.h:75 [inline]
       blk_mq_submit_bio+0x1536/0x2390 block/blk-mq.c:3090
       __submit_bio+0x2c6/0x560 block/blk-core.c:629
       __submit_bio_noacct_mq block/blk-core.c:710 [inline]
       submit_bio_noacct_nocheck+0x4d3/0xe30 block/blk-core.c:739
       xfs_buf_ioapply_map+0x461/0x5d0 fs/xfs/xfs_buf.c:1586
       _xfs_buf_ioapply+0x307/0x660 fs/xfs/xfs_buf.c:1674
       __xfs_buf_submit+0x34f/0x7e0 fs/xfs/xfs_buf.c:1758
       xfs_buf_submit fs/xfs/xfs_buf.c:61 [inline]
       _xfs_buf_read fs/xfs/xfs_buf.c:809 [inline]
       xfs_buf_read_map+0x431/0xa50 fs/xfs/xfs_buf.c:873
       xfs_trans_read_buf_map+0x260/0xab0 fs/xfs/xfs_trans_buf.c:304
       xfs_trans_read_buf fs/xfs/xfs_trans.h:213 [inline]
       xfs_read_agf+0x2dc/0x630 fs/xfs/libxfs/xfs_alloc.c:3378
       xfs_alloc_read_agf+0x196/0xbe0 fs/xfs/libxfs/xfs_alloc.c:3413
       xfs_alloc_fix_freelist+0x608/0x1bc0 fs/xfs/libxfs/xfs_alloc.c:2877
       xfs_alloc_vextent_prepare_ag+0xf9/0x6b0 fs/xfs/libxfs/xfs_alloc.c:3543
       xfs_alloc_vextent_iterate_ags+0x141/0x950 fs/xfs/libxfs/xfs_alloc.c:3727
       xfs_alloc_vextent_start_ag+0x3f6/0x950 fs/xfs/libxfs/xfs_alloc.c:3816
       xfs_bmap_btalloc_best_length fs/xfs/libxfs/xfs_bmap.c:3766 [inline]
       xfs_bmap_btalloc fs/xfs/libxfs/xfs_bmap.c:3811 [inline]
       xfs_bmapi_allocate+0x18fa/0x3450 fs/xfs/libxfs/xfs_bmap.c:4224
       xfs_bmapi_write+0xbac/0x1b40 fs/xfs/libxfs/xfs_bmap.c:4553
       xfs_dquot_disk_alloc+0x5f4/0xe20 fs/xfs/xfs_dquot.c:380
       xfs_qm_dqread+0x1a3/0x630 fs/xfs/xfs_dquot.c:719
       xfs_qm_dqget+0x2bb/0x6f0 fs/xfs/xfs_dquot.c:931
       xfs_qm_quotacheck_dqadjust+0xeb/0x5e0 fs/xfs/xfs_qm.c:1331
       xfs_qm_dqusage_adjust+0x778/0x850 fs/xfs/xfs_qm.c:1471
       xfs_iwalk_ag_recs+0x4e5/0x820 fs/xfs/xfs_iwalk.c:209
       xfs_iwalk_run_callbacks+0x218/0x470 fs/xfs/xfs_iwalk.c:370
       xfs_iwalk_ag+0xa9a/0xbb0 fs/xfs/xfs_iwalk.c:476
       xfs_iwalk_ag_work+0xfb/0x1b0 fs/xfs/xfs_iwalk.c:625
       xfs_pwork_work+0x81/0x190 fs/xfs/xfs_pwork.c:47
       process_one_work kernel/workqueue.c:3229 [inline]
       process_scheduled_works+0xa68/0x1840 kernel/workqueue.c:3310
       worker_thread+0x870/0xd30 kernel/workqueue.c:3391
       kthread+0x2f2/0x390 kernel/kthread.c:389
       ret_from_fork+0x4d/0x80 arch/x86/kernel/process.c:147
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

-> #0 (&xfs_nondir_ilock_class){++++}-{4:4}:
       check_prev_add kernel/locking/lockdep.c:3161 [inline]
       check_prevs_add kernel/locking/lockdep.c:3280 [inline]
       validate_chain+0x18ef/0x5920 kernel/locking/lockdep.c:3904
       __lock_acquire+0x1397/0x2100 kernel/locking/lockdep.c:5226
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5849
       down_write_nested+0xa2/0x220 kernel/locking/rwsem.c:1693
       xfs_inactive_truncate+0xee/0x240 fs/xfs/xfs_inode.c:1157
       xfs_inactive+0x987/0xdc0 fs/xfs/xfs_inode.c:1451
       xfs_inodegc_inactivate fs/xfs/xfs_icache.c:1939 [inline]
       xfs_inodegc_worker+0x33f/0x810 fs/xfs/xfs_icache.c:1985
       process_one_work kernel/workqueue.c:3229 [inline]
       process_scheduled_works+0xa68/0x1840 kernel/workqueue.c:3310
       worker_thread+0x870/0xd30 kernel/workqueue.c:3391
       kthread+0x2f2/0x390 kernel/kthread.c:389
       ret_from_fork+0x4d/0x80 arch/x86/kernel/process.c:147
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

other info that might help us debug this:

Chain exists of:
  &xfs_nondir_ilock_class --> &mm->mmap_lock --> sb_internal#4

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  rlock(sb_internal#4);
                               lock(&mm->mmap_lock);
                               lock(sb_internal#4);
  lock(&xfs_nondir_ilock_class);

 *** DEADLOCK ***

3 locks held by kworker/0:4/5890:
 #0: ffff8880468d3548 ((wq_completion)xfs-inodegc/loop5){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3204 [inline]
 #0: ffff8880468d3548 ((wq_completion)xfs-inodegc/loop5){+.+.}-{0:0}, at: process_scheduled_works+0x93b/0x1840 kernel/workqueue.c:3310
 #1: ffffc90003917d00 ((work_completion)(&(&gc->work)->work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3205 [inline]
 #1: ffffc90003917d00 ((work_completion)(&(&gc->work)->work)){+.+.}-{0:0}, at: process_scheduled_works+0x976/0x1840 kernel/workqueue.c:3310
 #2: ffff8880711ae610 (sb_internal#4){.+.+}-{0:0}, at: xfs_inactive_truncate+0xc8/0x240 fs/xfs/xfs_inode.c:1152

stack backtrace:
CPU: 0 UID: 0 PID: 5890 Comm: kworker/0:4 Not tainted 6.13.0-rc4-syzkaller-00012-g9b2ffa6148b1 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
Workqueue: xfs-inodegc/loop5 xfs_inodegc_worker
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
 print_circular_bug+0x13a/0x1b0 kernel/locking/lockdep.c:2074
 check_noncircular+0x36a/0x4a0 kernel/locking/lockdep.c:2206
 check_prev_add kernel/locking/lockdep.c:3161 [inline]
 check_prevs_add kernel/locking/lockdep.c:3280 [inline]
 validate_chain+0x18ef/0x5920 kernel/locking/lockdep.c:3904
 __lock_acquire+0x1397/0x2100 kernel/locking/lockdep.c:5226
 lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5849
 down_write_nested+0xa2/0x220 kernel/locking/rwsem.c:1693
 xfs_inactive_truncate+0xee/0x240 fs/xfs/xfs_inode.c:1157
 xfs_inactive+0x987/0xdc0 fs/xfs/xfs_inode.c:1451
 xfs_inodegc_inactivate fs/xfs/xfs_icache.c:1939 [inline]
 xfs_inodegc_worker+0x33f/0x810 fs/xfs/xfs_icache.c:1985
 process_one_work kernel/workqueue.c:3229 [inline]
 process_scheduled_works+0xa68/0x1840 kernel/workqueue.c:3310
 worker_thread+0x870/0xd30 kernel/workqueue.c:3391
 kthread+0x2f2/0x390 kernel/kthread.c:389
 ret_from_fork+0x4d/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup
