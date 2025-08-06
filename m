Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0473E7261C;
	Wed,  6 Aug 2025 11:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754480432; cv=none; b=PILGEBrTrlM2NoXj8O175jMwX+MQSpZ7qSWP8QRAwmU3z7zWaWjdW6VkO2YfTAsocdPhpe+9pSTHMqvl+SnPuleVCwyGRgUZdj1Ab7zK3HVlYuoxdg7IxbeAqY2U4Zgq+I3LHeIML2+TxG2hbQ3D3tV6o9XHyosWAwLSEVozfVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754480432; c=relaxed/simple;
	bh=Kn+WATT1sSZAd5q7aENFP0QfU/5mD6hQIMO6M/1vlmo=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=job9TQKN7qk4LFfw2HyFbrNDQEShQeuJXG5dq0BlA4QTE2VnabLwJD/D6bB4S3gkzOpBxjQ4qZ/hKc3DY9uAfykV/cWp2LfMfAI4lay72B3lzmVJJa5K9DQhyHskW020URWnegR6LQHehBvnsw9Ms3r3eM6pW6U9QbBa1LgEzxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bnVgi2tZ; arc=none smtp.client-ip=209.85.128.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bnVgi2tZ"
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-71b71a8d5f0so60291167b3.3;
        Wed, 06 Aug 2025 04:40:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754480430; x=1755085230; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=jVIpf0qiY0Ldv+0LrjGOiPJCL3q35L2WnE3JZyx/p7s=;
        b=bnVgi2tZkg8q0Fn4Cc4ewVdm7NUiw2iOw8H7cjMbCDcJVguGL0pC7eNbNQa0l4vHdi
         0tXtJEHwH/bpJdsVEBJR9FVJBj9qjAlKLTz5iMrQ2onqsv92xTbiUbC2F1NfmyHq3hZ6
         Ko6xvflDNyJgu8ChF76DY7c+9cRHIOUMsyo3+7sJc6/kMwt4ld0IkMl1NFrpH0baGcuz
         Ce7DqkGMvoNVOHA7ckL9FOLpzTUyyjekcl1A7xhBTXHCWxbS9RtbWzCWGYfv9ttemFZH
         kLtzXmfg9nTYX2c3GTWx0hdXHdP+DK7wbAiOY0Vh26cNU0Tfc0vjpDs4e29U12ozhyAs
         1toQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754480430; x=1755085230;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jVIpf0qiY0Ldv+0LrjGOiPJCL3q35L2WnE3JZyx/p7s=;
        b=iRTI/2hUtns8CLdjOTW58MCp8gMnvi5MqDvFtfnMjM7sWDP5d1jvy4TKyOMbgzUQNi
         j3e6CM9iAIRstxGXo4qOp1nnKYmzOeL27cJWGsifYYSc42ED184zGhf6Jz/I1xBVKD48
         ju9CvHGjMt6SflMEVbjd6XQbbE8dzHyUsQ7gVz718+JBFYv8g2pprSQkz0O1eT6dnBus
         zoeHqRuQVbQQ3epgw06EEj0XoChBafp0JaWWhUY+BT+Jchnzg9Dxq2dQnm1v4TDZFm+p
         LFPF86aeNDfVwmlHi/yK0gm+vbfr6R/HijpLmBtyDQb0XdoMUJp9L6S9hQHhGd3UU/kT
         boIA==
X-Forwarded-Encrypted: i=1; AJvYcCXYUOqkAq4czCXSU3RlLvFJSd7DHTzqSYoqbIZ2SnLuVbHpkbiIcYKoUa6O0xCzW+vzfEsLEyIb/aw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy2H5QMbpemP3ZwGrPBDcO6IPPeWDqVoDPTg57cCfs6X2M9YmeY
	XXPvXLWYqIFjGzdNA49MOO5VZ0tVXCmSbEaaiYCTTxFYjQmyT6USfyqIi0CsZCurxwTjXJAgalh
	xQ6E59qM2bWViyRW/6Vc13IaXmH8a1i0=
X-Gm-Gg: ASbGncv9qO/In213UvDjlvpHsUIscgbip+x/b3k1duDYftRsyFUHCa+Jz6DrDR+UQOb
	SBv63qwN0ukNoYH4IHoBKfDTf9cx7x6zjneNGm6KnkxRzsow9+1aG8+wP2ydlddKaoZ8BR23Nah
	fRlSgCsW/zTOyOsCcicf62upfZE73566CR0LHN6QG7fjNZ/CkbeNuEg4I2AKMsqynK8g/dP59WB
	nsdqw==
X-Google-Smtp-Source: AGHT+IEy2wbr9LfDsieDS31MyhaVQg/8KZ4TUvkvQEODy7oLFWaSdKnFrjbUJjd585GaVYb2XAnIC+qnN2hRWX5SF8c=
X-Received: by 2002:a05:690c:368b:b0:719:6608:f488 with SMTP id
 00721157ae682-71bcc8e72a7mr22619947b3.38.1754480429789; Wed, 06 Aug 2025
 04:40:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: cen zhang <zzzccc427@gmail.com>
Date: Wed, 6 Aug 2025 19:40:19 +0800
X-Gm-Features: Ac12FXyfaQOwtUbkH8D6sSXABiejkxDSa4-NSx5q-wIcMZ4RFphNgQPpDHreF9k
Message-ID: <CAFRLqsXrTagA7woSffBUUPUQ12VK1Ks292FT=miCv_NQktJY1A@mail.gmail.com>
Subject: [BUG] xfs: Assertion failure in dio_write( flags &
 IOMAP_DIO_OVERWRITE_ONLY) with a UAF
To: cem@kernel.org
Cc: linux-kernel@vger.kernel.org, baijiaju1990@gmail.com, 
	zhenghaoran154@gmail.com, r33s3n6@gmail.com, gality365@gmail.com, 
	linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hello maintainers,

I would like to report a kernel panic found using syzkaller on a 6.16.0-rc6.

The kernel log shows two distinct but closely timed crash reports,
which I guess are related.

1. An XFS assertion failure: Assertion failed: flags &
IOMAP_DIO_OVERWRITE_ONLY, file: fs/xfs/xfs_file.c, line: 876 triggered
by a write() system call in xfs_file_dio_write_unaligned.

2. A KASAN use-after-free report on a task_struct object, triggered
during an ioctl() call (likely FICLONE or FIDEDUPERANGE). The crash
occurs in rwsem_down_write_slowpath when trying to lock an inode via
xfs_reflink_remap_prep.

Unfortunately, I have not been able to create a standalone C
reproducer, and attempts to use syzkaller's repro tool on the syz-prog
have not reliably triggered the bug again.

Below are the full kernel oops messages:

=======================================================
XFS: Assertion failed: flags & IOMAP_DIO_OVERWRITE_ONLY, file:
fs/xfs/xfs_file.c, line: 876
------------[ cut here ]------------
kernel BUG at fs/xfs/xfs_message.c:102!
Oops: invalid opcode: 0000 [#1] SMP KASAN PTI
CPU: 1 UID: 0 PID: 467280 Comm: syz-executor.0 Not tainted
6.16.0-rc6-00002-g155a3c003e55-dirty #14 PREEMPT(voluntary)
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
RIP: 0010:assfail+0x9d/0xa0 fs/xfs/xfs_message.c:102
Code: 75 22 e8 b6 88 3a ff 90 0f 0b 90 5b 5d 41 5c 41 5d e9 c7 2d 78
02 48 c7 c7 78 af 63 a1 e8 2b 5a 6f ff eb ca e8 94 88 3a ff 90 <0f> 0b
90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 66 0f 1f
RSP: 0018:ffff888113327c18 EFLAGS: 00010293
RAX: 0000000000000000 RBX: 0000000000000001 RCX: ffffffff9db22a2c
RDX: ffff88816e9c2dc0 RSI: 0000000000000000 RDI: 0000000000000001
RBP: 0000000000000000 R08: 0000000000000001 R09: ffffed1022664f18
R10: 0000000000000001 R11: 737341203a534658 R12: ffffffffa05c63a0
R13: 000000000000036c R14: ffff888113327c70 R15: 0000000000000000
FS:  00007f1f761ae640(0000) GS:ffff88840c16a000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f1f761adff0 CR3: 00000001e3458000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 xfs_file_dio_write_unaligned+0x5a9/0x620 fs/xfs/xfs_file.c:876
 xfs_file_dio_write fs/xfs/xfs_file.c:909 [inline]
 xfs_file_write_iter+0x919/0xb50 fs/xfs/xfs_file.c:1124
 new_sync_write fs/read_write.c:593 [inline]
 vfs_write+0xa78/0xd70 fs/read_write.c:686
 ksys_write+0x124/0x240 fs/read_write.c:738
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xa8/0x270 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f1f76e6002d
Code: c3 e8 97 2b 00 00 0f 1f 80 00 00 00 00 f3 0f 1e fa 48 89 f8 48
89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d
01 f0 ff ff 73 01 c3 48 c7 c1 b0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f1f761ae028 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 00007f1f76f9c050 RCX: 00007f1f76e6002d
RDX: 0000000018000000 RSI: 0000000020000400 RDI: 0000000000000003
RBP: 00007f1f76ec14a6 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 000000000000000b R14: 00007f1f76f9c050 R15: 00007f1f7618e000
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:assfail+0x9d/0xa0 fs/xfs/xfs_message.c:102
Code: 75 22 e8 b6 88 3a ff 90 0f 0b 90 5b 5d 41 5c 41 5d e9 c7 2d 78
02 48 c7 c7 78 af 63 a1 e8 2b 5a 6f ff eb ca e8 94 88 3a ff 90 <0f> 0b
90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 66 0f 1f
RSP: 0018:ffff888113327c18 EFLAGS: 00010293
RAX: 0000000000000000 RBX: 0000000000000001 RCX: ffffffff9db22a2c
RDX: ffff88816e9c2dc0 RSI: 0000000000000000 RDI: 0000000000000001
RBP: 0000000000000000 R08: 0000000000000001 R09: ffffed1022664f18
R10: 0000000000000001 R11: 737341203a534658 R12: ffffffffa05c63a0
R13: 000000000000036c R14: ffff888113327c70 R15: 0000000000000000
FS:  00007f1f761ae640(0000) GS:ffff88840c16a000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f1f761adff0 CR3: 00000001e3458000 CR4: 00000000000006f0
==================================================================
BUG: KASAN: slab-use-after-free in owner_on_cpu
include/linux/sched.h:2236 [inline]
BUG: KASAN: slab-use-after-free in rwsem_can_spin_on_owner
kernel/locking/rwsem.c:723 [inline]
BUG: KASAN: slab-use-after-free in
rwsem_down_write_slowpath+0x109e/0x1100 kernel/locking/rwsem.c:1111
Read of size 4 at addr ffff88816e9c2df4 by task syz-executor.0/467290

CPU: 5 UID: 0 PID: 467290 Comm: syz-executor.0 Tainted: G      D
      6.16.0-rc6-00002-g155a3c003e55-dirty #14 PREEMPT(voluntary)
Tainted: [D]=DIE
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0xab/0xe0 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:378 [inline]
 print_report+0xcb/0x5f0 mm/kasan/report.c:480
 kasan_report+0xb8/0xf0 mm/kasan/report.c:593
 owner_on_cpu include/linux/sched.h:2236 [inline]
 rwsem_can_spin_on_owner kernel/locking/rwsem.c:723 [inline]
 rwsem_down_write_slowpath+0x109e/0x1100 kernel/locking/rwsem.c:1111
 __down_write_common kernel/locking/rwsem.c:1304 [inline]
 __down_write kernel/locking/rwsem.c:1313 [inline]
 down_write+0x114/0x130 kernel/locking/rwsem.c:1578
 inode_lock include/linux/fs.h:869 [inline]
 xfs_iolock_two_inodes_and_break_layout fs/xfs/xfs_inode.c:2705 [inline]
 xfs_ilock2_io_mmap+0x18e/0x4f0 fs/xfs/xfs_inode.c:2781
 xfs_reflink_remap_prep+0x98/0x940 fs/xfs/xfs_reflink.c:1667
 xfs_file_remap_range+0x202/0xc10 fs/xfs/xfs_file.c:1507
 vfs_dedupe_file_range_one+0x5a3/0x6d0 fs/remap_range.c:483
 vfs_dedupe_file_range+0x4f5/0x7f0 fs/remap_range.c:551
 ioctl_file_dedupe_range fs/ioctl.c:443 [inline]
 do_vfs_ioctl+0x103b/0x17d0 fs/ioctl.c:857
 __do_sys_ioctl fs/ioctl.c:905 [inline]
 __se_sys_ioctl fs/ioctl.c:893 [inline]
 __x64_sys_ioctl+0x116/0x210 fs/ioctl.c:893
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xa8/0x270 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f1f76e6002d
Code: c3 e8 97 2b 00 00 0f 1f 80 00 00 00 00 f3 0f 1e fa 48 89 f8 48
89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d
01 f0 ff ff 73 01 c3 48 c7 c1 b0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f1f761cf028 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007f1f76f9bf80 RCX: 00007f1f76e6002d
RDX: 0000000020000140 RSI: 00000000c0189436 RDI: 0000000000000003
RBP: 00007f1f76ec14a6 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 000000000000000b R14: 00007f1f76f9bf80 R15: 00007f1f761af000
 </TASK>

Allocated by task 467239:
 kasan_save_stack+0x24/0x50 mm/kasan/common.c:47
 kasan_save_track+0x14/0x30 mm/kasan/common.c:68
 unpoison_slab_object mm/kasan/common.c:319 [inline]
 __kasan_slab_alloc+0x59/0x70 mm/kasan/common.c:345
 kasan_slab_alloc include/linux/kasan.h:250 [inline]
 slab_post_alloc_hook mm/slub.c:4148 [inline]
 slab_alloc_node mm/slub.c:4197 [inline]
 kmem_cache_alloc_node_noprof+0xf7/0x340 mm/slub.c:4249
 alloc_task_struct_node kernel/fork.c:183 [inline]
 dup_task_struct kernel/fork.c:869 [inline]
 copy_process+0x491/0x6a80 kernel/fork.c:1999
 kernel_clone+0xe3/0x8e0 kernel/fork.c:2599
 __do_sys_clone3+0x1f6/0x280 kernel/fork.c:2903
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xa8/0x270 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Freed by task 164:
 kasan_save_stack+0x24/0x50 mm/kasan/common.c:47
 kasan_save_track+0x14/0x30 mm/kasan/common.c:68
 kasan_save_free_info+0x3b/0x60 mm/kasan/generic.c:576
 poison_slab_object mm/kasan/common.c:247 [inline]
 __kasan_slab_free+0x38/0x50 mm/kasan/common.c:264
 kasan_slab_free include/linux/kasan.h:233 [inline]
 slab_free_hook mm/slub.c:2381 [inline]
 slab_free mm/slub.c:4643 [inline]
 kmem_cache_free+0x130/0x380 mm/slub.c:4745
 put_task_struct include/linux/sched/task.h:145 [inline]
 delayed_put_task_struct+0x171/0x1c0 kernel/exit.c:230
 rcu_do_batch kernel/rcu/tree.c:2576 [inline]
 rcu_core+0x5f6/0x1a20 kernel/rcu/tree.c:2832
 handle_softirqs+0x176/0x530 kernel/softirq.c:579
 __do_softirq kernel/softirq.c:613 [inline]
 invoke_softirq kernel/softirq.c:453 [inline]
 __irq_exit_rcu kernel/softirq.c:680 [inline]
 irq_exit_rcu+0xaf/0xe0 kernel/softirq.c:696
 instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1050 [inline]
 sysvec_apic_timer_interrupt+0x70/0x80 arch/x86/kernel/apic/apic.c:1050
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:702

Last potentially related work creation:
 kasan_save_stack+0x24/0x50 mm/kasan/common.c:47
 kasan_record_aux_stack+0x8c/0xa0 mm/kasan/generic.c:548
 __call_rcu_common.constprop.0+0x70/0x930 kernel/rcu/tree.c:3094
 put_task_struct_rcu_user+0x75/0xc0 kernel/exit.c:236
 context_switch kernel/sched/core.c:5400 [inline]
 __schedule+0xeba/0x2960 kernel/sched/core.c:6786
 schedule_idle+0x5c/0x90 kernel/sched/core.c:6905
 do_idle+0x266/0x480 kernel/sched/idle.c:353
 cpu_startup_entry+0x4f/0x60 kernel/sched/idle.c:423
 start_secondary+0x1b8/0x210 arch/x86/kernel/smpboot.c:315
 common_startup_64+0x13e/0x148

The buggy address belongs to the object at ffff88816e9c2dc0
 which belongs to the cache task_struct of size 3776
The buggy address is located 52 bytes inside of
 freed 3776-byte region [ffff88816e9c2dc0, ffff88816e9c3c80)

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x16e9c0
head: order:3 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
flags: 0x200000000000040(head|node=0|zone=2)
page_type: f5(slab)
raw: 0200000000000040 ffff8881001cadc0 ffffea0004023600 dead000000000006
raw: 0000000000000000 0000000000080008 00000000f5000000 0000000000000000
head: 0200000000000040 ffff8881001cadc0 ffffea0004023600 dead000000000006
head: 0000000000000000 0000000000080008 00000000f5000000 0000000000000000
head: 0200000000000003 ffffea0005ba7001 00000000ffffffff 00000000ffffffff
head: 0000000000000000 0000000000000000 00000000ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff88816e9c2c80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88816e9c2d00: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
>ffff88816e9c2d80: fc fc fc fc fc fc fc fc fa fb fb fb fb fb fb fb
                                                             ^
 ffff88816e9c2e00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88816e9c2e80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================
