Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 377EB2701C4;
	Fri, 17 Apr 2026 13:48:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.97.179.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776433727; cv=none; b=MBb5x8sM5h9sIZa9N8whpc/IpK2AUS97FxN/Ub8YdOMK7QKE+Iv6YVceekRk3tBm96s07oGhuLrsNdIfNDKmK0Dp8+KzCmM9VKbUFlmT8jX+Qh8jxTmnLRp3E03wMvsb1YoTy6ZzR5jJH/za8DkVNSB4JF+YA9m4T3AYyZrrWEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776433727; c=relaxed/simple;
	bh=n42VjY78xuxoxgrsizUsr3Je2gDWz7oqnKOREIL/m8c=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=QkIyi7ZYCJqyA1VHHvWPy/fh6sSJtbDpMEvVJkgQnwa7H/LdewwRiv89Dn6xul3QBrB9uASPMSM3R6zlo7RtRaU3kSG6LjhsqSiCzFFX6o0CZ4SUHOeAhW/Y7/eoh+3l+4SE3bJnpzj/ddDkWXOF3SCd1rahy9qNmyU/dRZQe+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com; spf=pass smtp.mailfrom=igalia.com; dkim=pass (2048-bit key) header.d=igalia.com header.i=@igalia.com header.b=N36GMW+4; arc=none smtp.client-ip=213.97.179.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=igalia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=igalia.com header.i=@igalia.com header.b="N36GMW+4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:Cc:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=xdRngwhzYA6FP10MZ/qd0+bi0jOt7R1m6DUqsVTmi3s=; b=N36GMW+4NYve5gwgETc3qLLFQ9
	GQDyQ2l7VWd9tLqaXob2SpQ8tA+01eOoH/xvxnkcfJYyQ7sfkQpbXNLFzQ0LSb2FMnyJXJo6t53YT
	5SIyCjmHe9xYwW1UJn39QdTp9hTGceXg14DN1x0bsMOKsvnYunmohkeMtx9SxEVC0HEyHcTMfOsH6
	kH8G9xfz9yq8njNljt0kK0xxr/O4BWnrjU2uhmmmpb9anIeI2xx9lwPHCTnOYdrw3pl3+ODb15MR7
	Dvsyx3iPjmlUL6iYznxrf9JYyusqDAdViWLLFo3EszEiiJXxwchiQ1cL62eQ0P81NPNNhbDmCSKBo
	c60bjPeA==;
Received: from [179.244.2.202] (helo=[192.168.68.133])
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128) (Exim)
	id 1wDjYl-00HUBX-9s; Fri, 17 Apr 2026 15:48:39 +0200
Message-ID: <4507ddab-967a-439d-a8c9-3adcb6da6060@igalia.com>
Date: Fri, 17 Apr 2026 10:48:35 -0300
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [xfs?] inconsistent lock state in igrab
To: syzbot <syzbot+5eb0d61dfb76ca12670c@syzkaller.appspotmail.com>,
 cem@kernel.org, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
 syzkaller-bugs@googlegroups.com
References: <699000b2.050a0220.3a4a67.00a6.GAE@google.com>
Content-Language: en-US
From: Helen Koike <koike@igalia.com>
In-Reply-To: <699000b2.050a0220.3a4a67.00a6.GAE@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

I couldn't reproduce on upstream/master (3cd8b194bf34) anymore.
Bisection pointed that the following commit fixes it (which make sense):

#syz fix: "iomap: fix lockdep complaint when reads fail"

On 2/14/26 1:57 AM, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    8a5203c630c6 Merge tag 'v7.0-rc-part1-smb3-client-fixes' o..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=158b97fa580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=e987256b161b7ac5
> dashboard link: https://syzkaller.appspot.com/bug?extid=5eb0d61dfb76ca12670c
> compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
> 
> Unfortunately, I don't have any reproducer for this issue yet.
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/a3e5efac4c35/disk-8a5203c6.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/d4bd99ed6dad/vmlinux-8a5203c6.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/228bf34253f1/bzImage-8a5203c6.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+5eb0d61dfb76ca12670c@syzkaller.appspotmail.com
> 
> I/O error, dev loop8, sector 18692 op 0x0:(READ) flags 0x880700 phys_seg 1 prio class 2
> ================================
> WARNING: inconsistent lock state
> syzkaller #0 Tainted: G             L
> --------------------------------
> inconsistent {SOFTIRQ-ON-W} -> {IN-SOFTIRQ-W} usage.
> kworker/u8:12/11736 [HC0[0]:SC1[1]:HE1:SE0] takes:
> ffff88807fafd500 (&sb->s_type->i_lock_key#50){+.?.}-{3:3}, at: spin_lock include/linux/spinlock.h:351 [inline]
> ffff88807fafd500 (&sb->s_type->i_lock_key#50){+.?.}-{3:3}, at: igrab+0x2a/0x230 fs/inode.c:1574
> {SOFTIRQ-ON-W} state was registered at:
>    lock_acquire kernel/locking/lockdep.c:5868 [inline]
>    lock_acquire+0x17c/0x330 kernel/locking/lockdep.c:5825
>    __raw_spin_lock include/linux/spinlock_api_smp.h:133 [inline]
>    _raw_spin_lock+0x2e/0x40 kernel/locking/spinlock.c:154
>    spin_lock include/linux/spinlock.h:351 [inline]
>    unlock_new_inode+0x7a/0x330 fs/inode.c:1213
>    xfs_finish_inode_setup fs/xfs/xfs_inode.h:630 [inline]
>    xfs_setup_existing_inode fs/xfs/xfs_inode.h:637 [inline]
>    xfs_iget+0x1196/0x30f0 fs/xfs/xfs_icache.c:814
>    xfs_mountfs+0x108c/0x20b0 fs/xfs/xfs_mount.c:1072
>    xfs_fs_fill_super+0x153f/0x1f20 fs/xfs/xfs_super.c:1947
>    get_tree_bdev_flags+0x38c/0x620 fs/super.c:1694
>    vfs_get_tree+0x92/0x320 fs/super.c:1754
>    fc_mount fs/namespace.c:1193 [inline]
>    do_new_mount_fc fs/namespace.c:3761 [inline]
>    do_new_mount fs/namespace.c:3837 [inline]
>    path_mount+0x7d0/0x23d0 fs/namespace.c:4147
>    do_mount fs/namespace.c:4160 [inline]
>    __do_sys_mount fs/namespace.c:4349 [inline]
>    __se_sys_mount fs/namespace.c:4326 [inline]
>    __x64_sys_mount+0x293/0x310 fs/namespace.c:4326
>    do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>    do_syscall_64+0xc9/0xf80 arch/x86/entry/syscall_64.c:94
>    entry_SYSCALL_64_after_hwframe+0x77/0x7f
> irq event stamp: 1437372
> hardirqs last  enabled at (1437372): [<ffffffff8b7b9792>] __raw_spin_unlock_irqrestore include/linux/spinlock_api_smp.h:151 [inline]
> hardirqs last  enabled at (1437372): [<ffffffff8b7b9792>] _raw_spin_unlock_irqrestore+0x52/0x80 kernel/locking/spinlock.c:194
> hardirqs last disabled at (1437371): [<ffffffff8b7b94a2>] __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:108 [inline]
> hardirqs last disabled at (1437371): [<ffffffff8b7b94a2>] _raw_spin_lock_irqsave+0x52/0x60 kernel/locking/spinlock.c:162
> softirqs last  enabled at (1437320): [<ffffffff872b1a07>] spin_unlock_bh include/linux/spinlock.h:396 [inline]
> softirqs last  enabled at (1437320): [<ffffffff872b1a07>] nsim_dev_trap_report drivers/net/netdevsim/dev.c:890 [inline]
> softirqs last  enabled at (1437320): [<ffffffff872b1a07>] nsim_dev_trap_report_work+0x8c7/0xd10 drivers/net/netdevsim/dev.c:921
> softirqs last disabled at (1437353): [<ffffffff81c7a2cf>] __do_softirq kernel/softirq.c:656 [inline]
> softirqs last disabled at (1437353): [<ffffffff81c7a2cf>] invoke_softirq kernel/softirq.c:496 [inline]
> softirqs last disabled at (1437353): [<ffffffff81c7a2cf>] __irq_exit_rcu+0xef/0x150 kernel/softirq.c:723
> 
> other info that might help us debug this:
>   Possible unsafe locking scenario:
> 
>         CPU0
>         ----
>    lock(&sb->s_type->i_lock_key#50);
>    <Interrupt>
>      lock(&sb->s_type->i_lock_key#50);
> 
>   *** DEADLOCK ***
> 
> 2 locks held by kworker/u8:12/11736:
>   #0: ffff888079e6c148 ((wq_completion)loop8){+.+.}-{0:0}, at: process_one_work+0x11ae/0x1840 kernel/workqueue.c:3232
>   #1: ffffc9001333fc98 ((work_completion)(&worker->work)){+.+.}-{0:0}, at: process_one_work+0x927/0x1840 kernel/workqueue.c:3233
> 
> stack backtrace:
> CPU: 1 UID: 0 PID: 11736 Comm: kworker/u8:12 Tainted: G             L      syzkaller #0 PREEMPT(full)
> Tainted: [L]=SOFTLOCKUP
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/24/2026
> Workqueue: loop8 loop_workfn
> Call Trace:
>   <IRQ>
>   __dump_stack lib/dump_stack.c:94 [inline]
>   dump_stack_lvl+0x100/0x190 lib/dump_stack.c:120
>   print_usage_bug.part.0+0x257/0x340 kernel/locking/lockdep.c:4042
>   print_usage_bug kernel/locking/lockdep.c:4010 [inline]
>   valid_state kernel/locking/lockdep.c:4056 [inline]
>   mark_lock_irq kernel/locking/lockdep.c:4267 [inline]
>   mark_lock+0x74a/0xa20 kernel/locking/lockdep.c:4753
>   mark_usage kernel/locking/lockdep.c:4642 [inline]
>   __lock_acquire+0x103a/0x2630 kernel/locking/lockdep.c:5191
>   lock_acquire kernel/locking/lockdep.c:5868 [inline]
>   lock_acquire+0x17c/0x330 kernel/locking/lockdep.c:5825
>   __raw_spin_lock include/linux/spinlock_api_smp.h:133 [inline]
>   _raw_spin_lock+0x2e/0x40 kernel/locking/spinlock.c:154
>   spin_lock include/linux/spinlock.h:351 [inline]
>   igrab+0x2a/0x230 fs/inode.c:1574
>   fserror_report+0x3fd/0x750 fs/fserror.c:159
>   fserror_report_io include/linux/fserror.h:48 [inline]
>   iomap_finish_folio_read+0x168/0x2c0 fs/iomap/buffered-io.c:407
>   iomap_read_end_io+0x11a/0x430 fs/iomap/bio.c:17
>   bio_endio+0x755/0x8b0 block/bio.c:1709
>   blk_update_request+0x741/0x1330 block/blk-mq.c:1007
>   blk_mq_end_request+0x5b/0x420 block/blk-mq.c:1169
>   lo_complete_rq+0x1d4/0x2a0 drivers/block/loop.c:314
>   blk_complete_reqs+0xb1/0xf0 block/blk-mq.c:1244
>   handle_softirqs+0x1ea/0x910 kernel/softirq.c:622
>   __do_softirq kernel/softirq.c:656 [inline]
>   invoke_softirq kernel/softirq.c:496 [inline]
>   __irq_exit_rcu+0xef/0x150 kernel/softirq.c:723
>   irq_exit_rcu+0x9/0x30 kernel/softirq.c:739
>   instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1056 [inline]
>   sysvec_apic_timer_interrupt+0xa3/0xc0 arch/x86/kernel/apic/apic.c:1056
>   </IRQ>
>   <TASK>
>   asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:697
> RIP: 0010:__raw_spin_unlock_irq include/linux/spinlock_api_smp.h:160 [inline]
> RIP: 0010:_raw_spin_unlock_irq+0x29/0x50 kernel/locking/spinlock.c:202
> Code: 90 f3 0f 1e fa 53 48 8b 74 24 08 48 89 fb 48 83 c7 18 e8 fa 9c 67 f6 48 89 df e8 e2 ea 67 f6 e8 fd 31 93 f6 fb bf 01 00 00 00 <e8> 92 39 58 f6 65 8b 05 1b 79 6a 08 85 c0 74 06 5b e9 ec a9 94 f5
> RSP: 0018:ffffc9001333fb30 EFLAGS: 00000202
> RAX: 000000000015eea7 RBX: ffff888141bdd0c8 RCX: 0000000000000040
> RDX: 0000000000000000 RSI: ffffffff8dc4d62d RDI: 0000000000000001
> RBP: ffff888141bdd168 R08: 0000000000000001 R09: 0000000000000000
> R10: 0000000000000001 R11: 0000000000000000 R12: ffff888141bdd168
> R13: ffff888141bdd170 R14: ffffffff8e211280 R15: 0000000004208060
>   spin_unlock_irq include/linux/spinlock.h:401 [inline]
>   loop_process_work+0xa0a/0x11c0 drivers/block/loop.c:1977
>   process_one_work+0x9c2/0x1840 kernel/workqueue.c:3257
>   process_scheduled_works kernel/workqueue.c:3340 [inline]
>   worker_thread+0x5da/0xe40 kernel/workqueue.c:3421
>   kthread+0x3b3/0x730 kernel/kthread.c:463
>   ret_from_fork+0x754/0xaf0 arch/x86/kernel/process.c:158
>   ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:246
>   </TASK>
> ----------------
> Code disassembly (best guess):
>     0:	90                   	nop
>     1:	f3 0f 1e fa          	endbr64
>     5:	53                   	push   %rbx
>     6:	48 8b 74 24 08       	mov    0x8(%rsp),%rsi
>     b:	48 89 fb             	mov    %rdi,%rbx
>     e:	48 83 c7 18          	add    $0x18,%rdi
>    12:	e8 fa 9c 67 f6       	call   0xf6679d11
>    17:	48 89 df             	mov    %rbx,%rdi
>    1a:	e8 e2 ea 67 f6       	call   0xf667eb01
>    1f:	e8 fd 31 93 f6       	call   0xf6933221
>    24:	fb                   	sti
>    25:	bf 01 00 00 00       	mov    $0x1,%edi
> * 2a:	e8 92 39 58 f6       	call   0xf65839c1 <-- trapping instruction
>    2f:	65 8b 05 1b 79 6a 08 	mov    %gs:0x86a791b(%rip),%eax        # 0x86a7951
>    36:	85 c0                	test   %eax,%eax
>    38:	74 06                	je     0x40
>    3a:	5b                   	pop    %rbx
>    3b:	e9 ec a9 94 f5       	jmp    0xf594aa2c
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

