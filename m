Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEB511D8A14
	for <linux-xfs@vger.kernel.org>; Thu, 12 Dec 2024 23:19:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734045567; cv=none; b=uRHOH93B9ysj6/8FqWJ/EfYohBAazJ8CHtn46X2bxdlXbMF96QaoCtjZ6BDP4l+YjfA5gurTZBBtd1VckKsoOb2noRDMlzz/nRYZ4hjM32c8wuyOBItrnMqtW2EF1oA7IEl7JjDV3EKPnZQRo2I/58DWo8OcIis8XPtPzP4fvBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734045567; c=relaxed/simple;
	bh=Say8SdZIBsPOObAQUaRFDPsKjIzr2LAzEMwZ6A1o7N0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l4M0bk3CrGatBPwS6q5NEMFxptJbE+Y9fSqQtlk64BQ3llkXc2p87slHvTZm4MjsdaKoY9/pzXZL6Qcx4WwAo4/d+JeRrRL4xG6fA4g9vAEFt2RGnmwG6eAyd8oxioYZFvWShO6odZe+BT1rX6KQxkHLA54AQWF5pzi8uNgaUnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=ADzf70oL; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="ADzf70oL"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2165448243fso12815435ad.1
        for <linux-xfs@vger.kernel.org>; Thu, 12 Dec 2024 15:19:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1734045565; x=1734650365; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=wZZOjWbiDxgUmQMPXtT1adt7JyPKENvySFY9iEzkevs=;
        b=ADzf70oLxM1o31HJ9+195FosxFPaR2wDTD+5kJuT6efASnN9PYXLVDT6NGCGjgd/kh
         ESiU75mPACGsnMx6Z4HRYOKdebF21YHdVW8APW/SO3UA6dJIlxJmYoV+4G9KCpZy/dHX
         lyqO26TqRlZSoHGW4MawpYg0gDsinWjuTWCgwCyRQa/ghUAqd9Rqeh/SCgJVUnDp4Wo9
         qmHJwaTu/e/q8nUUWV+1nHwQUkVwFgPhn/Bo5gS0jDMmMUDRZqVq55ZZ4q/Tz69VEaUA
         YqiAo75Rpkq59wS7Ca2+arkOOe5B0aP/SPTOiYX2Tbu8B1LlI3LFdawLDYSglZF61HVx
         r55g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734045565; x=1734650365;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wZZOjWbiDxgUmQMPXtT1adt7JyPKENvySFY9iEzkevs=;
        b=fWq2XHIuvmkVOizIi+7rWMd3keDJTOV4uzGPl5YWLo7gFUHfxZ7emSXj6MIS27cO3V
         KI5wo/XBiJ4e8I21fS3TCArPRA6Mdrp4Dl2aDOY6oN+qNX+HglrOVcDzTLsetgoojeYE
         DDMt0LCN/9qQYkA596MuKXPMYTNDQmOtfYTZyucisG3AwWHGKM8sHRMkwHmsYBc+FaFC
         zaoGs5jFEZHOrm1u7E2RPGBT5emF4jVr0GD7XNodDgGDd1f+BddmCCs3v5Vh78hbAhy2
         EecH2XsI9wBGfIDY3SZU4MxNif/i+0wueTsuR5KiaJ49af8C8Cu0uyZksYtdaLpIOA/g
         Qhdg==
X-Forwarded-Encrypted: i=1; AJvYcCWcuZM2qZ22PS/jc5jXDZvOoe6g0HdOvaP4sq5yPoRcPw1xD3azOWb+6PgPG0giScC+VKgJNOOHpMg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw06UxC3Ub+FDh5y2VDEt7i2PlW1PCoRmX1T1YUyKCjRmS0aKNN
	is3mvIbAWXctsc8SZP4xsVuG2gtItfvvr0RMJkKrFlhlHJRRNu4wdTaJ78k9C0Q=
X-Gm-Gg: ASbGnctggg5dFPeYqMm9Cxepox9tEMYKfMsFrrRZgI/NieBVmP2ojo/aQeWQMapESG8
	cwK0o0efdpeO5vLHgO2X7eYPWfrILScoVStcP++w604Xoxx86r2pY760WkeU6NXs1tBDdUI6pzj
	f4kju2awwe4wmjRr6/d7nhZNatjevMj2HMB61j4NdN1iCQXNUjInUV8z4dlLPNaPbkwIdYTioIc
	MMP48ziS5RNWv47wjBD+RNvFyiH4cg+DnG7cbww6iLVoAmxKqF/0LSCKZy2Tq7TeU+AIykdAxni
	cVOiHoPABztYAeZr9vs=
X-Google-Smtp-Source: AGHT+IFoEUwtgBCzKJXdDVgPWWOZcnRClLn44YiR+59DMxCmWRI8jpMJU0Lq9UpsH0u3W9ZqUH8/fw==
X-Received: by 2002:a17:902:ea08:b0:216:4169:f9d7 with SMTP id d9443c01a7336-21892997505mr8126755ad.2.1734045565011;
        Thu, 12 Dec 2024 15:19:25 -0800 (PST)
Received: from dread.disaster.area (pa49-195-9-235.pa.nsw.optusnet.com.au. [49.195.9.235])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-215f8f0ab8fsm128979435ad.190.2024.12.12.15.19.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Dec 2024 15:19:24 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1tLsSn-00000009zQh-0113;
	Fri, 13 Dec 2024 10:19:21 +1100
Date: Fri, 13 Dec 2024 10:19:20 +1100
From: Dave Chinner <david@fromorbit.com>
To: syzbot <syzbot+5e01f56d1c53ac3749fb@syzkaller.appspotmail.com>
Cc: cem@kernel.org, chandan.babu@oracle.com, djwong@kernel.org,
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [xfs?] possible deadlock in xfs_vn_update_time
Message-ID: <Z1tveH23bU56IMcj@dread.disaster.area>
References: <675b6694.050a0220.599f4.00bd.GAE@google.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <675b6694.050a0220.599f4.00bd.GAE@google.com>

On Thu, Dec 12, 2024 at 02:41:24PM -0800, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    62b5a46999c7 Merge tag '6.13-rc1-smb3-client-fixes' of git..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=1156c3e8580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=c579265945b98812
> dashboard link: https://syzkaller.appspot.com/bug?extid=5e01f56d1c53ac3749fb
> compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
> 
> Unfortunately, I don't have any reproducer for this issue yet.
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/e972efbff321/disk-62b5a469.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/6b1ab872ed57/vmlinux-62b5a469.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/8dbcac9b80b9/bzImage-62b5a469.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+5e01f56d1c53ac3749fb@syzkaller.appspotmail.com
> 
> XFS (loop8): Ending clean mount
> ======================================================
> WARNING: possible circular locking dependency detected
> 6.13.0-rc1-syzkaller-00378-g62b5a46999c7 #0 Not tainted
> ------------------------------------------------------
> syz.8.1897/11319 is trying to acquire lock:
> ffff88807ab0a610 (sb_internal#3){.+.+}-{0:0}, at: xfs_vn_update_time+0x1e9/0x5e0 fs/xfs/xfs_iops.c:1103
> 
> but task is already holding lock:
> ffff8880347a1560 (&mm->mmap_lock){++++}-{4:4}, at: mmap_write_lock_killable include/linux/mmap_lock.h:122 [inline]
> ffff8880347a1560 (&mm->mmap_lock){++++}-{4:4}, at: vm_mmap_pgoff+0x160/0x360 mm/util.c:578
> 
> which lock already depends on the new lock.
> 
> 
> the existing dependency chain (in reverse order) is:
> 
> -> #5 (&mm->mmap_lock){++++}-{4:4}:
>        __might_fault mm/memory.c:6751 [inline]
>        __might_fault+0x11b/0x190 mm/memory.c:6744
>        _inline_copy_from_user include/linux/uaccess.h:162 [inline]
>        _copy_from_user+0x29/0xd0 lib/usercopy.c:18
>        copy_from_user include/linux/uaccess.h:212 [inline]
>        __blk_trace_setup+0xa8/0x180 kernel/trace/blktrace.c:626
>        blk_trace_ioctl+0x163/0x290 kernel/trace/blktrace.c:740
>        blkdev_ioctl+0x109/0x6d0 block/ioctl.c:682
>        vfs_ioctl fs/ioctl.c:51 [inline]
>        __do_sys_ioctl fs/ioctl.c:906 [inline]
>        __se_sys_ioctl fs/ioctl.c:892 [inline]
>        __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:892
>        do_syscall_x64 arch/x86/entry/common.c:52 [inline]
>        do_syscall_64+0xcd/0x250 arch/x86/entry/common.c:83
>        entry_SYSCALL_64_after_hwframe+0x77/0x7f

There's your problem - doing copy-in from userspace whilst holding
a q->debugfs_mutex, thereby putting mm->mmap_lock under a block
layer lock.

That then propagates through the block layer locking into filesystem
locking orders (because filesystems do IO!), and finally lockdep
complains because the filesystem is doing freeze protection
under the mm->mmap_lock as it is required to do.

Block layer issue, not XFS, so:

#syz set subsystems: block

-Dave.


> 
> -> #4 (&q->debugfs_mutex){+.+.}-{4:4}:
>        __mutex_lock_common kernel/locking/mutex.c:585 [inline]
>        __mutex_lock+0x19b/0xa60 kernel/locking/mutex.c:735
>        blk_mq_init_sched+0x42b/0x640 block/blk-mq-sched.c:473
>        elevator_init_mq+0x2cd/0x420 block/elevator.c:610
>        add_disk_fwnode+0x113/0x1300 block/genhd.c:413
>        sd_probe+0xa86/0x1000 drivers/scsi/sd.c:4024
>        call_driver_probe drivers/base/dd.c:579 [inline]
>        really_probe+0x241/0xa90 drivers/base/dd.c:658
>        __driver_probe_device+0x1de/0x440 drivers/base/dd.c:800
>        driver_probe_device+0x4c/0x1b0 drivers/base/dd.c:830
>        __device_attach_driver+0x1df/0x310 drivers/base/dd.c:958
>        bus_for_each_drv+0x15a/0x1e0 drivers/base/bus.c:459
>        __device_attach_async_helper+0x1d3/0x290 drivers/base/dd.c:987
>        async_run_entry_fn+0x9f/0x530 kernel/async.c:129
>        process_one_work+0x9c8/0x1ba0 kernel/workqueue.c:3229
>        process_scheduled_works kernel/workqueue.c:3310 [inline]
>        worker_thread+0x6c8/0xf00 kernel/workqueue.c:3391
>        kthread+0x2c4/0x3a0 kernel/kthread.c:389
>        ret_from_fork+0x48/0x80 arch/x86/kernel/process.c:147
>        ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
> 
> -> #3 (&q->q_usage_counter(queue)#50){++++}-{0:0}:
>        blk_queue_enter+0x50f/0x640 block/blk-core.c:328
>        blk_mq_alloc_request+0x59b/0x950 block/blk-mq.c:652
>        scsi_alloc_request drivers/scsi/scsi_lib.c:1222 [inline]
>        scsi_execute_cmd+0x1eb/0xf40 drivers/scsi/scsi_lib.c:304
>        read_capacity_16+0x213/0xe10 drivers/scsi/sd.c:2655
>        sd_read_capacity drivers/scsi/sd.c:2824 [inline]
>        sd_revalidate_disk.isra.0+0x1a06/0xa8d0 drivers/scsi/sd.c:3734
>        sd_probe+0x904/0x1000 drivers/scsi/sd.c:4010
>        call_driver_probe drivers/base/dd.c:579 [inline]
>        really_probe+0x241/0xa90 drivers/base/dd.c:658
>        __driver_probe_device+0x1de/0x440 drivers/base/dd.c:800
>        driver_probe_device+0x4c/0x1b0 drivers/base/dd.c:830
>        __device_attach_driver+0x1df/0x310 drivers/base/dd.c:958
>        bus_for_each_drv+0x15a/0x1e0 drivers/base/bus.c:459
>        __device_attach_async_helper+0x1d3/0x290 drivers/base/dd.c:987
>        async_run_entry_fn+0x9f/0x530 kernel/async.c:129
>        process_one_work+0x9c8/0x1ba0 kernel/workqueue.c:3229
>        process_scheduled_works kernel/workqueue.c:3310 [inline]
>        worker_thread+0x6c8/0xf00 kernel/workqueue.c:3391
>        kthread+0x2c4/0x3a0 kernel/kthread.c:389
>        ret_from_fork+0x48/0x80 arch/x86/kernel/process.c:147
>        ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
> 
> -> #2 (&q->limits_lock){+.+.}-{4:4}:
>        __mutex_lock_common kernel/locking/mutex.c:585 [inline]
>        __mutex_lock+0x19b/0xa60 kernel/locking/mutex.c:735
>        queue_limits_start_update include/linux/blkdev.h:949 [inline]
>        loop_reconfigure_limits+0x407/0x8c0 drivers/block/loop.c:998
>        loop_set_block_size drivers/block/loop.c:1473 [inline]
>        lo_simple_ioctl drivers/block/loop.c:1496 [inline]
>        lo_ioctl+0x901/0x18b0 drivers/block/loop.c:1559
>        blkdev_ioctl+0x279/0x6d0 block/ioctl.c:693
>        vfs_ioctl fs/ioctl.c:51 [inline]
>        __do_sys_ioctl fs/ioctl.c:906 [inline]
>        __se_sys_ioctl fs/ioctl.c:892 [inline]
>        __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:892
>        do_syscall_x64 arch/x86/entry/common.c:52 [inline]
>        do_syscall_64+0xcd/0x250 arch/x86/entry/common.c:83
>        entry_SYSCALL_64_after_hwframe+0x77/0x7f
> 
> -> #1 (&q->q_usage_counter(io)#23){++++}-{0:0}:
>        bio_queue_enter block/blk.h:75 [inline]
>        blk_mq_submit_bio+0x1fb6/0x24c0 block/blk-mq.c:3092
>        __submit_bio+0x384/0x540 block/blk-core.c:629
>        __submit_bio_noacct_mq block/blk-core.c:710 [inline]
>        submit_bio_noacct_nocheck+0x698/0xd70 block/blk-core.c:739
>        submit_bio_noacct+0x93a/0x1e20 block/blk-core.c:868
>        xfs_buf_ioapply_map fs/xfs/xfs_buf.c:1586 [inline]
>        _xfs_buf_ioapply+0x9f6/0xd70 fs/xfs/xfs_buf.c:1674
>        __xfs_buf_submit+0x28b/0x820 fs/xfs/xfs_buf.c:1758
>        xfs_buf_submit fs/xfs/xfs_buf.c:61 [inline]
>        _xfs_buf_read fs/xfs/xfs_buf.c:809 [inline]
>        xfs_buf_read_map+0x3fa/0xb70 fs/xfs/xfs_buf.c:873
>        xfs_trans_read_buf_map+0x352/0x9a0 fs/xfs/xfs_trans_buf.c:304
>        xfs_trans_read_buf fs/xfs/xfs_trans.h:213 [inline]
>        xfs_read_agi+0x2a1/0x5c0 fs/xfs/libxfs/xfs_ialloc.c:2760
>        xfs_ialloc_read_agi+0x10c/0x510 fs/xfs/libxfs/xfs_ialloc.c:2791
>        xfs_dialloc_try_ag fs/xfs/libxfs/xfs_ialloc.c:1809 [inline]
>        xfs_dialloc+0x898/0x1820 fs/xfs/libxfs/xfs_ialloc.c:1945
>        xfs_qm_qino_alloc+0x2a7/0x7f0 fs/xfs/xfs_qm.c:996
>        xfs_qm_init_quotainos+0x5f4/0x6c0 fs/xfs/xfs_qm.c:1845
>        xfs_qm_init_quotainfo+0xf4/0xb20 fs/xfs/xfs_qm.c:824
>        xfs_qm_mount_quotas+0x9c/0x6a0 fs/xfs/xfs_qm.c:1680
>        xfs_mountfs+0x1ed1/0x2230 fs/xfs/xfs_mount.c:1030
>        xfs_fs_fill_super+0x1557/0x1f50 fs/xfs/xfs_super.c:1791
>        get_tree_bdev_flags+0x38e/0x620 fs/super.c:1636
>        vfs_get_tree+0x92/0x380 fs/super.c:1814
>        do_new_mount fs/namespace.c:3507 [inline]
>        path_mount+0x14e6/0x1f20 fs/namespace.c:3834
>        do_mount fs/namespace.c:3847 [inline]
>        __do_sys_mount fs/namespace.c:4057 [inline]
>        __se_sys_mount fs/namespace.c:4034 [inline]
>        __x64_sys_mount+0x294/0x320 fs/namespace.c:4034
>        do_syscall_x64 arch/x86/entry/common.c:52 [inline]
>        do_syscall_64+0xcd/0x250 arch/x86/entry/common.c:83
>        entry_SYSCALL_64_after_hwframe+0x77/0x7f
> 
> -> #0 (sb_internal#3){.+.+}-{0:0}:
>        check_prev_add kernel/locking/lockdep.c:3161 [inline]
>        check_prevs_add kernel/locking/lockdep.c:3280 [inline]
>        validate_chain kernel/locking/lockdep.c:3904 [inline]
>        __lock_acquire+0x249e/0x3c40 kernel/locking/lockdep.c:5226
>        lock_acquire.part.0+0x11b/0x380 kernel/locking/lockdep.c:5849
>        percpu_down_read include/linux/percpu-rwsem.h:51 [inline]
>        __sb_start_write include/linux/fs.h:1725 [inline]
>        sb_start_intwrite include/linux/fs.h:1908 [inline]
>        xfs_trans_alloc+0x4fa/0x940 fs/xfs/xfs_trans.c:266
>        xfs_vn_update_time+0x1e9/0x5e0 fs/xfs/xfs_iops.c:1103
>        inode_update_time fs/inode.c:2124 [inline]
>        touch_atime+0x352/0x5d0 fs/inode.c:2197
>        file_accessed include/linux/fs.h:2539 [inline]
>        xfs_file_mmap+0x4ad/0x630 fs/xfs/xfs_file.c:1581
>        call_mmap include/linux/fs.h:2183 [inline]
>        mmap_file mm/internal.h:124 [inline]
>        __mmap_new_file_vma mm/vma.c:2291 [inline]
>        __mmap_new_vma mm/vma.c:2355 [inline]
>        __mmap_region+0x1789/0x2670 mm/vma.c:2456
>        mmap_region+0x270/0x320 mm/mmap.c:1347
>        do_mmap+0xc00/0xfc0 mm/mmap.c:496
>        vm_mmap_pgoff+0x1ba/0x360 mm/util.c:580
>        ksys_mmap_pgoff+0x32c/0x5c0 mm/mmap.c:542
>        __do_sys_mmap arch/x86/kernel/sys_x86_64.c:89 [inline]
>        __se_sys_mmap arch/x86/kernel/sys_x86_64.c:82 [inline]
>        __x64_sys_mmap+0x125/0x190 arch/x86/kernel/sys_x86_64.c:82
>        do_syscall_x64 arch/x86/entry/common.c:52 [inline]
>        do_syscall_64+0xcd/0x250 arch/x86/entry/common.c:83
>        entry_SYSCALL_64_after_hwframe+0x77/0x7f
> 
> other info that might help us debug this:
> 
> Chain exists of:
>   sb_internal#3 --> &q->debugfs_mutex --> &mm->mmap_lock
> 
>  Possible unsafe locking scenario:
> 
>        CPU0                    CPU1
>        ----                    ----
>   lock(&mm->mmap_lock);
>                                lock(&q->debugfs_mutex);
>                                lock(&mm->mmap_lock);
>   rlock(sb_internal#3);
> 
>  *** DEADLOCK ***
> 
> 2 locks held by syz.8.1897/11319:
>  #0: ffff8880347a1560 (&mm->mmap_lock){++++}-{4:4}, at: mmap_write_lock_killable include/linux/mmap_lock.h:122 [inline]
>  #0: ffff8880347a1560 (&mm->mmap_lock){++++}-{4:4}, at: vm_mmap_pgoff+0x160/0x360 mm/util.c:578
>  #1: ffff88807ab0a420 (sb_writers#23){.+.+}-{0:0}, at: file_accessed include/linux/fs.h:2539 [inline]
>  #1: ffff88807ab0a420 (sb_writers#23){.+.+}-{0:0}, at: xfs_file_mmap+0x4ad/0x630 fs/xfs/xfs_file.c:1581
> 
> stack backtrace:
> CPU: 0 UID: 0 PID: 11319 Comm: syz.8.1897 Not tainted 6.13.0-rc1-syzkaller-00378-g62b5a46999c7 #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
> Call Trace:
>  <TASK>
>  __dump_stack lib/dump_stack.c:94 [inline]
>  dump_stack_lvl+0x116/0x1f0 lib/dump_stack.c:120
>  print_circular_bug+0x419/0x5d0 kernel/locking/lockdep.c:2074
>  check_noncircular+0x31a/0x400 kernel/locking/lockdep.c:2206
>  check_prev_add kernel/locking/lockdep.c:3161 [inline]
>  check_prevs_add kernel/locking/lockdep.c:3280 [inline]
>  validate_chain kernel/locking/lockdep.c:3904 [inline]
>  __lock_acquire+0x249e/0x3c40 kernel/locking/lockdep.c:5226
>  lock_acquire.part.0+0x11b/0x380 kernel/locking/lockdep.c:5849
>  percpu_down_read include/linux/percpu-rwsem.h:51 [inline]
>  __sb_start_write include/linux/fs.h:1725 [inline]
>  sb_start_intwrite include/linux/fs.h:1908 [inline]
>  xfs_trans_alloc+0x4fa/0x940 fs/xfs/xfs_trans.c:266
>  xfs_vn_update_time+0x1e9/0x5e0 fs/xfs/xfs_iops.c:1103
>  inode_update_time fs/inode.c:2124 [inline]
>  touch_atime+0x352/0x5d0 fs/inode.c:2197
>  file_accessed include/linux/fs.h:2539 [inline]
>  xfs_file_mmap+0x4ad/0x630 fs/xfs/xfs_file.c:1581
>  call_mmap include/linux/fs.h:2183 [inline]
>  mmap_file mm/internal.h:124 [inline]
>  __mmap_new_file_vma mm/vma.c:2291 [inline]
>  __mmap_new_vma mm/vma.c:2355 [inline]
>  __mmap_region+0x1789/0x2670 mm/vma.c:2456
>  mmap_region+0x270/0x320 mm/mmap.c:1347
>  do_mmap+0xc00/0xfc0 mm/mmap.c:496
>  vm_mmap_pgoff+0x1ba/0x360 mm/util.c:580
>  ksys_mmap_pgoff+0x32c/0x5c0 mm/mmap.c:542
>  __do_sys_mmap arch/x86/kernel/sys_x86_64.c:89 [inline]
>  __se_sys_mmap arch/x86/kernel/sys_x86_64.c:82 [inline]
>  __x64_sys_mmap+0x125/0x190 arch/x86/kernel/sys_x86_64.c:82
>  do_syscall_x64 arch/x86/entry/common.c:52 [inline]
>  do_syscall_64+0xcd/0x250 arch/x86/entry/common.c:83
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7eff20f7fed9
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007eff1edf6058 EFLAGS: 00000246 ORIG_RAX: 0000000000000009
> RAX: ffffffffffffffda RBX: 00007eff21145fa0 RCX: 00007eff20f7fed9
> RDX: 0000000000000002 RSI: 0000000000b36000 RDI: 0000000020000000
> RBP: 00007eff20ff3cc8 R08: 0000000000000004 R09: 0000000000000000
> R10: 0000000000028011 R11: 0000000000000246 R12: 0000000000000000
> R13: 0000000000000000 R14: 00007eff21145fa0 R15: 00007ffe670abff8
>  </TASK>
> 
> 
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> 
> If the report is already addressed, let syzbot know by replying with:
> #syz fix: exact-commit-title
> 
> If you want to overwrite report's subsystems, reply with:
> #syz set subsystems: new-subsystem
> (See the list of subsystem names on the web dashboard)
> 
> If the report is a duplicate of another one, reply with:
> #syz dup: exact-subject-of-another-report
> 
> If you want to undo deduplication, reply with:
> #syz undup
> 
> 

-- 
Dave Chinner
david@fromorbit.com
