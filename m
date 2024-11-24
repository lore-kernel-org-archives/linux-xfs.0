Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0831933FE
	for <linux-xfs@vger.kernel.org>; Sun, 24 Nov 2024 07:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732434803; cv=none; b=PAAD85eyQNe9TAx4r7TFxVKUth9G7dU4Ub8ehXGE+Au9yItzO0O2IKC4J8Q4wZY605a/YJuPb/YicsWmMJlMu8M7TKbskQEZ/7Roj9hNh7+CSFSjwEAvFbO4LBFu2USJpwLvgVOXCA+xTF5viygOmcDXQoUvHzRGtqIOQwc65rQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732434803; c=relaxed/simple;
	bh=jwJtOUIfQenAVBHdp0JtAt0VzK+ZSKR1DfsHATTSRV0=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=HAH2yt22VURO1xtr1M1CvUWFH4yR4UGIF4blEY0mvcqeeTU4uRZ6Jp8JxkQyaPPGasowbb8xW40ut69lFHXbn7XpnDbQrWLJOll6h08v+osJwdnHEc3l3qPwiM6Ab9I27K6n+Uj4B1cKprKiQ2tCeCG0COJshI4I8yFbZs7jDuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-3a77fad574cso32086445ab.2
        for <linux-xfs@vger.kernel.org>; Sat, 23 Nov 2024 23:53:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732434801; x=1733039601;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BVxZfcFVquyGFJdiqGNgz+utdBg0BNv/kkHjTopv2NI=;
        b=Pjsz2dUx+9Va9XfqaRhSupB73dFEVDe7B5UGmFu07+HHyDwsrIG6zdw2RwsLZ99GD/
         s3VPmYVmd4urP6eX2aOs9tqQzhLdCujX16mWmd1QjND51kEjSsrVwG5XCz+hK2WOVrpa
         mgwRQ5RsKDLY6FttPheAb3TYtDQCsI1QoeMFhj52o4cEwgk5wV2kmA6Ly9m2NrOdjvBx
         2JzsRhdp04QCEQoex/uFpmmKXX6cp4lfycH6dUWhjTvqLPYWymbYLF46gzU+9KthHTVt
         0oMbVFg0m1lyaGQzFyPY5jZOKs1XlGM6jhDftoONu+1HWF8AFGLQnqTGMpFzAwqYCS4W
         6pmQ==
X-Forwarded-Encrypted: i=1; AJvYcCVLtEI4R5hqAlbOvPwBQNU2DZXnUQMOWaPdBDQiDCFvaKRD3FZnv19lXHXXE+CT9h2K2n3LmHIQkjk=@vger.kernel.org
X-Gm-Message-State: AOJu0YzytEo6BMpRHMptmrlZrrpLlHeu46BCzjwNLO4zPIjQjwwRpgpw
	W0A1YVFFcdW13UZX2kb0CcFkJAyeN9oGB1NdOEaOJrbNiSZBiQIvpeyk6wkzFR2zMFca5oPC+po
	5LTQQYFgIMRm/kChby87py7DMhjwU6hLt7KsVJ0vjEAKcONblsdvGZTE=
X-Google-Smtp-Source: AGHT+IFKTFx5nGWNKegye2fnLSkUqQiNnEtsHiCCb7sB+vVqYEQb0CghF3QOPEVnUxz3v8uytRnlXIYsPYHH0TjAO2+M3WQcTVQ0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1fed:b0:3a7:955e:1cc5 with SMTP id
 e9e14a558f8ab-3a79acf1b29mr100692255ab.1.1732434801229; Sat, 23 Nov 2024
 23:53:21 -0800 (PST)
Date: Sat, 23 Nov 2024 23:53:21 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6742db71.050a0220.1cc393.0036.GAE@google.com>
Subject: [syzbot] [xfs?] possible deadlock in xfs_dquot_disk_alloc
From: syzbot <syzbot+0f440b139d96ada5b0fd@syzkaller.appspotmail.com>
To: cem@kernel.org, chandan.babu@oracle.com, djwong@kernel.org, 
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    28eb75e178d3 Merge tag 'drm-next-2024-11-21' of https://gi..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=16983930580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=95b76860fd16c857
dashboard link: https://syzkaller.appspot.com/bug?extid=0f440b139d96ada5b0fd
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/1bc8b96259b1/disk-28eb75e1.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/3d3a17b8d4e1/vmlinux-28eb75e1.xz
kernel image: https://storage.googleapis.com/syzbot-assets/b86ac344a770/bzImage-28eb75e1.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+0f440b139d96ada5b0fd@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
6.12.0-syzkaller-07749-g28eb75e178d3 #0 Not tainted
------------------------------------------------------
kworker/u8:4/62 is trying to acquire lock:
ffff88807b723758 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_dquot_disk_alloc+0x399/0xe20 fs/xfs/xfs_dquot.c:337

but task is already holding lock:
ffff8880794ac610 (sb_internal#2){.+.+}-{0:0}, at: xfs_dquot_disk_alloc+0x36f/0xe20 fs/xfs/xfs_dquot.c:332

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #6 (sb_internal#2){.+.+}-{0:0}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5849
       percpu_down_read include/linux/percpu-rwsem.h:51 [inline]
       __sb_start_write include/linux/fs.h:1725 [inline]
       sb_start_intwrite include/linux/fs.h:1908 [inline]
       xfs_trans_alloc+0xe5/0x830 fs/xfs/xfs_trans.c:266
       xfs_vn_update_time+0x203/0x600 fs/xfs/xfs_iops.c:1103
       inode_update_time fs/inode.c:2125 [inline]
       touch_atime+0x27f/0x690 fs/inode.c:2198
       file_accessed include/linux/fs.h:2539 [inline]
       xfs_file_mmap+0x1ab/0x530 fs/xfs/xfs_file.c:1581
       call_mmap include/linux/fs.h:2183 [inline]
       mmap_file mm/internal.h:123 [inline]
       __mmap_region mm/mmap.c:1453 [inline]
       mmap_region+0x1a2c/0x23f0 mm/mmap.c:1603
       do_mmap+0x8f0/0x1000 mm/mmap.c:496
       vm_mmap_pgoff+0x1dd/0x3d0 mm/util.c:588
       ksys_mmap_pgoff+0x4eb/0x720 mm/mmap.c:542
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #5 (&mm->mmap_lock){++++}-{4:4}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5849
       __might_fault+0xc6/0x120 mm/memory.c:6716
       _inline_copy_from_user include/linux/uaccess.h:162 [inline]
       _copy_from_user+0x2a/0xc0 lib/usercopy.c:18
       copy_from_user include/linux/uaccess.h:212 [inline]
       __blk_trace_setup kernel/trace/blktrace.c:626 [inline]
       blk_trace_setup+0xd2/0x1e0 kernel/trace/blktrace.c:648
       sg_ioctl_common drivers/scsi/sg.c:1121 [inline]
       sg_ioctl+0xa46/0x2e80 drivers/scsi/sg.c:1163
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
       process_scheduled_works+0xa65/0x1850 kernel/workqueue.c:3310
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
       process_scheduled_works+0xa65/0x1850 kernel/workqueue.c:3310
       worker_thread+0x870/0xd30 kernel/workqueue.c:3391
       kthread+0x2f2/0x390 kernel/kthread.c:389
       ret_from_fork+0x4d/0x80 arch/x86/kernel/process.c:147
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

-> #2 (&q->limits_lock){+.+.}-{4:4}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5849
       __mutex_lock_common kernel/locking/mutex.c:585 [inline]
       __mutex_lock+0x1ac/0xee0 kernel/locking/mutex.c:735
       queue_limits_start_update include/linux/blkdev.h:945 [inline]
       loop_reconfigure_limits+0x283/0x9e0 drivers/block/loop.c:1003
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

-> #1 (&q->q_usage_counter(io)#21){++++}-{0:0}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5849
       bio_queue_enter block/blk.h:75 [inline]
       blk_mq_submit_bio+0x1536/0x23a0 block/blk-mq.c:3092
       __submit_bio+0x2c6/0x560 block/blk-core.c:629
       __submit_bio_noacct_mq block/blk-core.c:710 [inline]
       submit_bio_noacct_nocheck+0x4d3/0xe30 block/blk-core.c:739
       xfs_buf_ioapply_map+0x461/0x5d0 fs/xfs/xfs_buf.c:1586
       _xfs_buf_ioapply+0x307/0x660 fs/xfs/xfs_buf.c:1674
       __xfs_buf_submit+0x34f/0x7f0 fs/xfs/xfs_buf.c:1758
       xfs_buf_submit fs/xfs/xfs_buf.c:61 [inline]
       _xfs_buf_read fs/xfs/xfs_buf.c:809 [inline]
       xfs_buf_read_map+0x431/0xa60 fs/xfs/xfs_buf.c:873
       xfs_trans_read_buf_map+0x260/0xad0 fs/xfs/xfs_trans_buf.c:304
       xfs_trans_read_buf fs/xfs/xfs_trans.h:213 [inline]
       xfs_imap_to_bp+0x18d/0x380 fs/xfs/libxfs/xfs_inode_buf.c:139
       xfs_inode_item_precommit+0x566/0x920 fs/xfs/xfs_inode_item.c:174
       xfs_trans_run_precommits fs/xfs/xfs_trans.c:828 [inline]
       __xfs_trans_commit+0x35a/0x1290 fs/xfs/xfs_trans.c:863
       xfs_qm_qino_alloc+0x5cc/0x770 fs/xfs/xfs_qm.c:1035
       xfs_qm_init_quotainos+0x60b/0x8a0 fs/xfs/xfs_qm.c:1831
       xfs_qm_init_quotainfo+0x182/0x1270 fs/xfs/xfs_qm.c:826
       xfs_qm_mount_quotas+0xe9/0x680 fs/xfs/xfs_qm.c:1682
       xfs_mountfs+0x1e60/0x2410 fs/xfs/xfs_mount.c:1030
       xfs_fs_fill_super+0x12db/0x1590 fs/xfs/xfs_super.c:1791
       get_tree_bdev_flags+0x48e/0x5c0 fs/super.c:1636
       vfs_get_tree+0x92/0x2b0 fs/super.c:1814
       do_new_mount+0x2be/0xb40 fs/namespace.c:3507
       do_mount fs/namespace.c:3847 [inline]
       __do_sys_mount fs/namespace.c:4057 [inline]
       __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:4034
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #0 (&xfs_nondir_ilock_class){++++}-{4:4}:
       check_prev_add kernel/locking/lockdep.c:3161 [inline]
       check_prevs_add kernel/locking/lockdep.c:3280 [inline]
       validate_chain+0x18ef/0x5920 kernel/locking/lockdep.c:3904
       __lock_acquire+0x1397/0x2100 kernel/locking/lockdep.c:5226
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5849
       down_write_nested+0xa2/0x220 kernel/locking/rwsem.c:1693
       xfs_dquot_disk_alloc+0x399/0xe20 fs/xfs/xfs_dquot.c:337
       xfs_qm_dqread+0x1a3/0x650 fs/xfs/xfs_dquot.c:694
       xfs_qm_dqget+0x2bb/0x6f0 fs/xfs/xfs_dquot.c:906
       xfs_qm_quotacheck_dqadjust+0xea/0x5a0 fs/xfs/xfs_qm.c:1299
       xfs_qm_dqusage_adjust+0x5e1/0x850 fs/xfs/xfs_qm.c:1421
       xfs_iwalk_ag_recs+0x4e3/0x820 fs/xfs/xfs_iwalk.c:209
       xfs_iwalk_run_callbacks+0x218/0x470 fs/xfs/xfs_iwalk.c:370
       xfs_iwalk_ag+0xa9a/0xbb0 fs/xfs/xfs_iwalk.c:476
       xfs_iwalk_ag_work+0xfb/0x1b0 fs/xfs/xfs_iwalk.c:625
       xfs_pwork_work+0x81/0x190 fs/xfs/xfs_pwork.c:47
       process_one_work kernel/workqueue.c:3229 [inline]
       process_scheduled_works+0xa65/0x1850 kernel/workqueue.c:3310
       worker_thread+0x870/0xd30 kernel/workqueue.c:3391
       kthread+0x2f2/0x390 kernel/kthread.c:389
       ret_from_fork+0x4d/0x80 arch/x86/kernel/process.c:147
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

other info that might help us debug this:

Chain exists of:
  &xfs_nondir_ilock_class --> &mm->mmap_lock --> sb_internal#2

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  rlock(sb_internal#2);
                               lock(&mm->mmap_lock);
                               lock(sb_internal#2);
  lock(&xfs_nondir_ilock_class);

 *** DEADLOCK ***

3 locks held by kworker/u8:4/62:
 #0: ffff888025056948 ((wq_completion)xfs_iwalk-14699){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3204 [inline]
 #0: ffff888025056948 ((wq_completion)xfs_iwalk-14699){+.+.}-{0:0}, at: process_scheduled_works+0x93b/0x1850 kernel/workqueue.c:3310
 #1: ffffc9000213fd00 ((work_completion)(&pwork->work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3205 [inline]
 #1: ffffc9000213fd00 ((work_completion)(&pwork->work)){+.+.}-{0:0}, at: process_scheduled_works+0x976/0x1850 kernel/workqueue.c:3310
 #2: ffff8880794ac610 (sb_internal#2){.+.+}-{0:0}, at: xfs_dquot_disk_alloc+0x36f/0xe20 fs/xfs/xfs_dquot.c:332

stack backtrace:
CPU: 0 UID: 0 PID: 62 Comm: kworker/u8:4 Not tainted 6.12.0-syzkaller-07749-g28eb75e178d3 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/30/2024
Workqueue: xfs_iwalk-14699 xfs_pwork_work
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
 xfs_dquot_disk_alloc+0x399/0xe20 fs/xfs/xfs_dquot.c:337
 xfs_qm_dqread+0x1a3/0x650 fs/xfs/xfs_dquot.c:694
 xfs_qm_dqget+0x2bb/0x6f0 fs/xfs/xfs_dquot.c:906
 xfs_qm_quotacheck_dqadjust+0xea/0x5a0 fs/xfs/xfs_qm.c:1299
 xfs_qm_dqusage_adjust+0x5e1/0x850 fs/xfs/xfs_qm.c:1421
 xfs_iwalk_ag_recs+0x4e3/0x820 fs/xfs/xfs_iwalk.c:209
 xfs_iwalk_run_callbacks+0x218/0x470 fs/xfs/xfs_iwalk.c:370
 xfs_iwalk_ag+0xa9a/0xbb0 fs/xfs/xfs_iwalk.c:476
 xfs_iwalk_ag_work+0xfb/0x1b0 fs/xfs/xfs_iwalk.c:625
 xfs_pwork_work+0x81/0x190 fs/xfs/xfs_pwork.c:47
 process_one_work kernel/workqueue.c:3229 [inline]
 process_scheduled_works+0xa65/0x1850 kernel/workqueue.c:3310
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
