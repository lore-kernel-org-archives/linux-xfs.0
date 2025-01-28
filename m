Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F34F19CD01;
	Tue, 28 Jan 2025 10:37:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738060624; cv=none; b=Y+hKx8pqGPiC4h6WULEbGmtm6HrRAbjbxPygOqpZy5xPqajS3WxXPfqJGopj5s0O93DYuc6cHtj53DwWza8AxxPt3tbtohp4kAht7z/KENkwvaRow5MyUuy2oel5vRGkursBNPUctAbQvwWVeT8Fe6TlgaAt2bq0mSeij5xBgWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738060624; c=relaxed/simple;
	bh=JmH8RinzUYxYMxA/bXduARV4s32b8nBpnIIRhlwj4V8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H5GHpJAHu3XDRtOIcF6Snx3YemMf0xEf3sgw0ohElR+0EC1LrfI5AknYic6kH622towrsvztsyHxxc+dyJrKtkB3qha8Kz7IA58s9ZMZKQte4rDDPIW0CH01ko+C5YFfZiQPjg+YiI5kH9bvFHQPUwJWkwDdrJVQWNnyVcelwIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PqbLm4Dg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PqbLm4Dg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4958FC4CED3;
	Tue, 28 Jan 2025 10:37:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738060624;
	bh=JmH8RinzUYxYMxA/bXduARV4s32b8nBpnIIRhlwj4V8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PqbLm4DgGj2Ad/BMR80bTOFsk3lxEU8qJ8ZzrqpaBkh+Z2bK85gCk7aqONhlt4Xb+
	 2ZEh+dVPqf5TsVRE73GqKABMQkWAs/TwsDWknnRIzsDg7hzoF8qQb/1mDxqA8EFn1N
	 wPWmOGziJovFBOcGVgIhq5jbpdmee7fiP1ed+vDTQ+aYGZIUaYvFGtJ19ip3JgopG9
	 1zbGC7HmFERcAoCHCloFJR3+7T65cnpUR8USZGCKy4yS+iJ+IfuMYcVA8kFKvYJ8Vu
	 TcYSMCqXwvBxOAjvWIa8EAQzgasmmzUqtqNNIznMD6nUfUIzWFSuDMs3PgD+oBU1uJ
	 Z2faaVvOuqvDA==
Date: Tue, 28 Jan 2025 11:36:55 +0100
From: Carlos Maiolino <cem@kernel.org>
To: syzbot <syzbot+acb56162aef712929d3f@syzkaller.appspotmail.com>
Cc: chandan.babu@oracle.com, djwong@kernel.org, 
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, syzkaller-bugs@googlegroups.com, 
	hch@lst.de
Subject: Re: [syzbot] [xfs?] possible deadlock in xfs_buf_find_insert
Message-ID: <eoq4ppitkdktcxfnxbo5zq524cuxlzw377nz5xt6gowvkmhudx@n5yjnhrf4d7i>
References: <xUgzg-Ms26GwUwJb_y_dH4Cd0_wpb0bHNZThgjgF0jAZyXDNjGasYRqOCgqPHOnBgRMUpwFAPpzdPoRfPXcn4Q==@protonmail.internalid>
 <6798b182.050a0220.ac840.0248.GAE@google.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6798b182.050a0220.ac840.0248.GAE@google.com>

On Tue, Jan 28, 2025 at 02:29:22AM -0800, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    aa22f4da2a46 Merge tag 'rproc-v6.14' of git://git.kernel.o..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=100175df980000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=bdecca7d9ba0b0e8
> dashboard link: https://syzkaller.appspot.com/bug?extid=acb56162aef712929d3f
> compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
> 
> Unfortunately, I don't have any reproducer for this issue yet.


#syz test: git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git next-rc

> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/204a46b0b3d6/disk-aa22f4da.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/d62db5dd211d/vmlinux-aa22f4da.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/d9ef2864f84f/bzImage-aa22f4da.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+acb56162aef712929d3f@syzkaller.appspotmail.com
> 
> ======================================================
> WARNING: possible circular locking dependency detected
> 6.13.0-syzkaller-07632-gaa22f4da2a46 #0 Not tainted
> ------------------------------------------------------
> syz.4.192/7178 is trying to acquire lock:
> ffff888058756e20 (&bp->b_lock){+.+.}-{3:3}, at: spin_lock include/linux/spinlock.h:351 [inline]
> ffff888058756e20 (&bp->b_lock){+.+.}-{3:3}, at: xfs_buf_try_hold fs/xfs/xfs_buf.c:578 [inline]
> ffff888058756e20 (&bp->b_lock){+.+.}-{3:3}, at: xfs_buf_find_insert+0x1123/0x1610 fs/xfs/xfs_buf.c:663
> 
> but task is already holding lock:
> ffff88802268b180 (&bch->bc_lock){+.+.}-{3:3}, at: spin_lock include/linux/spinlock.h:351 [inline]
> ffff88802268b180 (&bch->bc_lock){+.+.}-{3:3}, at: xfs_buf_find_insert+0x3da/0x1610 fs/xfs/xfs_buf.c:655
> 
> which lock already depends on the new lock.
> 
> 
> the existing dependency chain (in reverse order) is:
> 
> -> #1 (&bch->bc_lock){+.+.}-{3:3}:
>        lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5851
>        __raw_spin_lock include/linux/spinlock_api_smp.h:133 [inline]
>        _raw_spin_lock+0x2e/0x40 kernel/locking/spinlock.c:154
>        spin_lock include/linux/spinlock.h:351 [inline]
>        xfs_buf_rele_cached fs/xfs/xfs_buf.c:1093 [inline]
>        xfs_buf_rele+0x2bf/0x1660 fs/xfs/xfs_buf.c:1147
>        process_one_work kernel/workqueue.c:3236 [inline]
>        process_scheduled_works+0xa66/0x1840 kernel/workqueue.c:3317
>        worker_thread+0x870/0xd30 kernel/workqueue.c:3398
>        kthread+0x7a9/0x920 kernel/kthread.c:464
>        ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:148
>        ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
> 
> -> #0 (&bp->b_lock){+.+.}-{3:3}:
>        check_prev_add kernel/locking/lockdep.c:3163 [inline]
>        check_prevs_add kernel/locking/lockdep.c:3282 [inline]
>        validate_chain+0x18ef/0x5920 kernel/locking/lockdep.c:3906
>        __lock_acquire+0x1397/0x2100 kernel/locking/lockdep.c:5228
>        lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5851
>        __raw_spin_lock include/linux/spinlock_api_smp.h:133 [inline]
>        _raw_spin_lock+0x2e/0x40 kernel/locking/spinlock.c:154
>        spin_lock include/linux/spinlock.h:351 [inline]
>        xfs_buf_try_hold fs/xfs/xfs_buf.c:578 [inline]
>        xfs_buf_find_insert+0x1123/0x1610 fs/xfs/xfs_buf.c:663
>        xfs_buf_get_map+0x149a/0x1ac0 fs/xfs/xfs_buf.c:754
>        xfs_buf_read_map+0x110/0xa50 fs/xfs/xfs_buf.c:862
>        xfs_trans_read_buf_map+0x260/0xab0 fs/xfs/xfs_trans_buf.c:304
>        xfs_trans_read_buf fs/xfs/xfs_trans.h:212 [inline]
>        xfs_read_agf+0x2dc/0x630 fs/xfs/libxfs/xfs_alloc.c:3378
>        xfs_alloc_read_agf+0x196/0xbe0 fs/xfs/libxfs/xfs_alloc.c:3413
>        xfs_trim_gather_extents+0x1b2/0x11a0 fs/xfs/xfs_discard.c:203
>        xfs_trim_perag_extents fs/xfs/xfs_discard.c:374 [inline]
>        xfs_trim_datadev_extents+0x4c7/0xbb0 fs/xfs/xfs_discard.c:429
>        xfs_ioc_trim+0x758/0xa90 fs/xfs/xfs_discard.c:887
>        xfs_file_ioctl+0x84c/0x1c60 fs/xfs/xfs_ioctl.c:1199
>        vfs_ioctl fs/ioctl.c:51 [inline]
>        __do_sys_ioctl fs/ioctl.c:906 [inline]
>        __se_sys_ioctl+0xf5/0x170 fs/ioctl.c:892
>        do_syscall_x64 arch/x86/entry/common.c:52 [inline]
>        do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
>        entry_SYSCALL_64_after_hwframe+0x77/0x7f
> 
> other info that might help us debug this:
> 
>  Possible unsafe locking scenario:
> 
>        CPU0                    CPU1
>        ----                    ----
>   lock(&bch->bc_lock);
>                                lock(&bp->b_lock);
>                                lock(&bch->bc_lock);
>   lock(&bp->b_lock);
> 
>  *** DEADLOCK ***
> 
> 1 lock held by syz.4.192/7178:
>  #0: ffff88802268b180 (&bch->bc_lock){+.+.}-{3:3}, at: spin_lock include/linux/spinlock.h:351 [inline]
>  #0: ffff88802268b180 (&bch->bc_lock){+.+.}-{3:3}, at: xfs_buf_find_insert+0x3da/0x1610 fs/xfs/xfs_buf.c:655
> 
> stack backtrace:
> CPU: 1 UID: 0 PID: 7178 Comm: syz.4.192 Not tainted 6.13.0-syzkaller-07632-gaa22f4da2a46 #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 12/27/2024
> Call Trace:
>  <TASK>
>  __dump_stack lib/dump_stack.c:94 [inline]
>  dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
>  print_circular_bug+0x13a/0x1b0 kernel/locking/lockdep.c:2076
>  check_noncircular+0x36a/0x4a0 kernel/locking/lockdep.c:2208
>  check_prev_add kernel/locking/lockdep.c:3163 [inline]
>  check_prevs_add kernel/locking/lockdep.c:3282 [inline]
>  validate_chain+0x18ef/0x5920 kernel/locking/lockdep.c:3906
>  __lock_acquire+0x1397/0x2100 kernel/locking/lockdep.c:5228
>  lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5851
>  __raw_spin_lock include/linux/spinlock_api_smp.h:133 [inline]
>  _raw_spin_lock+0x2e/0x40 kernel/locking/spinlock.c:154
>  spin_lock include/linux/spinlock.h:351 [inline]
>  xfs_buf_try_hold fs/xfs/xfs_buf.c:578 [inline]
>  xfs_buf_find_insert+0x1123/0x1610 fs/xfs/xfs_buf.c:663
>  xfs_buf_get_map+0x149a/0x1ac0 fs/xfs/xfs_buf.c:754
>  xfs_buf_read_map+0x110/0xa50 fs/xfs/xfs_buf.c:862
>  xfs_trans_read_buf_map+0x260/0xab0 fs/xfs/xfs_trans_buf.c:304
>  xfs_trans_read_buf fs/xfs/xfs_trans.h:212 [inline]
>  xfs_read_agf+0x2dc/0x630 fs/xfs/libxfs/xfs_alloc.c:3378
>  xfs_alloc_read_agf+0x196/0xbe0 fs/xfs/libxfs/xfs_alloc.c:3413
>  xfs_trim_gather_extents+0x1b2/0x11a0 fs/xfs/xfs_discard.c:203
>  xfs_trim_perag_extents fs/xfs/xfs_discard.c:374 [inline]
>  xfs_trim_datadev_extents+0x4c7/0xbb0 fs/xfs/xfs_discard.c:429
>  xfs_ioc_trim+0x758/0xa90 fs/xfs/xfs_discard.c:887
>  xfs_file_ioctl+0x84c/0x1c60 fs/xfs/xfs_ioctl.c:1199
>  vfs_ioctl fs/ioctl.c:51 [inline]
>  __do_sys_ioctl fs/ioctl.c:906 [inline]
>  __se_sys_ioctl+0xf5/0x170 fs/ioctl.c:892
>  do_syscall_x64 arch/x86/entry/common.c:52 [inline]
>  do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f2097f8cd29
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f2098d20038 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> RAX: ffffffffffffffda RBX: 00007f20981a6080 RCX: 00007f2097f8cd29
> RDX: 00000000200001c0 RSI: 00000000c0185879 RDI: 0000000000000005
> RBP: 00007f209800e2a0 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 0000000000000001 R14: 00007f20981a6080 R15: 00007ffefbba5028
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
