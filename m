Received: from mail-io1-f78.google.com (mail-io1-f78.google.com [209.85.166.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9057033998
	for <linux-xfs@vger.kernel.org>; Wed, 15 May 2024 03:32:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715743946; cv=none; b=ZEruB6OWpxk2hN9SaYjSyyYVfe+eg/wawxOfxVXE7RqF8zGERVQn6XqtrAojbp+Oc+MqA20AA48pe9mjLucb53uy9q8SulQf2c7X8eZ60Z6A/JdxZKKJnUaKtmclVDM3cyJ5pNqIqrxWrD98bPJ/0hTzRJJ+ytMEfQFup7GHKPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715743946; c=relaxed/simple;
	bh=PFWUFl5xs/gFdfGkAdAl3OzIOKpEu4Qy25iqSWO8fJ4=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=Rfh8rUMBsYnYW2d5LZSN+FNmKfi/G6tCyza9fFbTW1HFcfjwG+m85TES2VzcEGj/CwM2S2DkjDy6ebv6hXRW7AdZsezHoIPJ4c3QUgc4o87CST2nXLUrF6+/W2ASaeWIPJ4AhzU9LBsq8nrTNo9IEA9XRloyE2NTXVYotvguPnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f78.google.com with SMTP id ca18e2360f4ac-7e1db7e5386so411109639f.3
        for <linux-xfs@vger.kernel.org>; Tue, 14 May 2024 20:32:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715743944; x=1716348744;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fA8zvYJYF4/8RIWJyNwOX0fYHJhk5bAzn4yU1hD+pEg=;
        b=JJQz71jiyQYs6t7lHyq45V8ACnqN7e1yNAkjm9vOcgl08sJ9ywANDWwt41eYI2rx++
         5jcDywM6h7GDRS0Uhjaoqp0eEw7ZK7m6jXii0MKCUGkls5NuLYkRnp1voMiUu7ALsnJA
         c2I4OHArGahxyo5iTyovXTgR5dVZO0oL/RcLaFsnsvbqFNgx5ba454NMWZdzw3rSi86V
         5lClvtzzpBprdX7uhcT6bhVRdpC0oIEwYEnxhok/LavLugBrR5w8CRdoI9HDztUHvlxc
         fqMh6K4Ph8l3RLMnDt7PrxFNnvHyN/vQsNgWoLYkD0uZcsRXEi5THiTC79YKudoya8ov
         Q5cQ==
X-Forwarded-Encrypted: i=1; AJvYcCVXtX9pATYWYDELa5MCld/ffkjdMDVy65ThaF1HzLizZCtZ5yKazBR6G05KOSBzUtw/QDOXmw0zpqXxlKMSYpyfl4ePTas3/vxB
X-Gm-Message-State: AOJu0YxsDtYyeQmKBpafnHUfWikI1SiufJ/6pWKY9TNyI9TLQI5YDpE/
	XqTg+FfUp1v9c/5CIpvgXg57qZkYodfbQkX16rZ9JcCnOwhU0gz/hj9HCwR2VsCicToPlWujd95
	8RP5wo/d9HKfzjnzjtfFhfNxpol29O5GyTVVMJzuyVJsSmomVTxLTLOs=
X-Google-Smtp-Source: AGHT+IEYEIB3z9bMMTfighLAfKaO/l1BaFDlsPh2OKypMUfXNa75ugkGs8npOp+VO8QQyy4iA6Pc+l5trkC02qtxkq8F3QHvhQjz
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6638:7101:b0:488:77ea:f194 with SMTP id
 8926c6da1cb9f-4895903263emr1175586173.5.1715743943782; Tue, 14 May 2024
 20:32:23 -0700 (PDT)
Date: Tue, 14 May 2024 20:32:23 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000004b84e2061875c4a2@google.com>
Subject: [syzbot] [xfs?] possible deadlock in xfs_qm_dquot_isolate
From: syzbot <syzbot+6d8d043596bb844b6947@syzkaller.appspotmail.com>
To: chandan.babu@oracle.com, djwong@kernel.org, linux-kernel@vger.kernel.org, 
	linux-xfs@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    f4345f05c0df Merge tag 'block-6.9-20240510' of git://git.k..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=10c35598980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a450595960709c8
dashboard link: https://syzkaller.appspot.com/bug?extid=6d8d043596bb844b6947
compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
userspace arch: i386

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7bc7510fe41f/non_bootable_disk-f4345f05.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/5e01373e68f5/vmlinux-f4345f05.xz
kernel image: https://storage.googleapis.com/syzbot-assets/dd55eb82d95f/bzImage-f4345f05.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+6d8d043596bb844b6947@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
6.9.0-rc7-syzkaller-00136-gf4345f05c0df #0 Not tainted
------------------------------------------------------
syz-executor.3/11149 is trying to acquire lock:
ffffffff8d937180 (fs_reclaim){+.+.}-{0:0}, at: might_alloc include/linux/sched/mm.h:312 [inline]
ffffffff8d937180 (fs_reclaim){+.+.}-{0:0}, at: slab_pre_alloc_hook mm/slub.c:3752 [inline]
ffffffff8d937180 (fs_reclaim){+.+.}-{0:0}, at: slab_alloc_node mm/slub.c:3833 [inline]
ffffffff8d937180 (fs_reclaim){+.+.}-{0:0}, at: kmalloc_trace+0x51/0x340 mm/slub.c:3998

but task is already holding lock:
ffff88806900e5a8 (&dqp->q_qlock){+.+.}-{3:3}, at: xfs_dqlock_nowait fs/xfs/xfs_dquot.h:120 [inline]
ffff88806900e5a8 (&dqp->q_qlock){+.+.}-{3:3}, at: xfs_qm_dquot_isolate+0x85/0x1420 fs/xfs/xfs_qm.c:423

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #2 (&dqp->q_qlock){+.+.}-{3:3}:
       __lock_release kernel/locking/lockdep.c:5468 [inline]
       lock_release+0x33e/0x6c0 kernel/locking/lockdep.c:5774
       __mutex_unlock_slowpath+0xa3/0x650 kernel/locking/mutex.c:912
       xfs_qm_dqget_cache_lookup+0x428/0x880 fs/xfs/xfs_dquot.c:802
       xfs_qm_dqget_inode+0x1e7/0x6d0 fs/xfs/xfs_dquot.c:994
       xfs_qm_dqattach_one+0x26f/0x590 fs/xfs/xfs_qm.c:278
       xfs_qm_dqattach_locked+0x226/0x2d0 fs/xfs/xfs_qm.c:329
       xfs_qm_vop_dqalloc+0x344/0xe40 fs/xfs/xfs_qm.c:1710
       xfs_create+0x422/0x1170 fs/xfs/xfs_inode.c:1041
       xfs_generic_create+0x631/0x7c0 fs/xfs/xfs_iops.c:199
       vfs_mkdir+0x57d/0x820 fs/namei.c:4123
       do_mkdirat+0x301/0x3a0 fs/namei.c:4146
       __do_sys_mkdir fs/namei.c:4166 [inline]
       __se_sys_mkdir fs/namei.c:4164 [inline]
       __ia32_sys_mkdir+0xf0/0x140 fs/namei.c:4164
       do_syscall_32_irqs_on arch/x86/entry/common.c:165 [inline]
       __do_fast_syscall_32+0x75/0x120 arch/x86/entry/common.c:386
       do_fast_syscall_32+0x32/0x80 arch/x86/entry/common.c:411
       entry_SYSENTER_compat_after_hwframe+0x84/0x8e

-> #1 (&xfs_dir_ilock_class){++++}-{3:3}:
       down_write_nested+0x3d/0x50 kernel/locking/rwsem.c:1695
       xfs_ilock+0x2ef/0x420 fs/xfs/xfs_inode.c:206
       xfs_reclaim_inode fs/xfs/xfs_icache.c:945 [inline]
       xfs_icwalk_process_inode fs/xfs/xfs_icache.c:1631 [inline]
       xfs_icwalk_ag+0xca6/0x1780 fs/xfs/xfs_icache.c:1713
       xfs_icwalk+0x57/0x100 fs/xfs/xfs_icache.c:1762
       xfs_reclaim_inodes_nr+0x182/0x250 fs/xfs/xfs_icache.c:1011
       super_cache_scan+0x409/0x550 fs/super.c:227
       do_shrink_slab+0x44f/0x11c0 mm/shrinker.c:435
       shrink_slab+0x18a/0x1310 mm/shrinker.c:662
       shrink_one+0x493/0x7c0 mm/vmscan.c:4774
       shrink_many mm/vmscan.c:4835 [inline]
       lru_gen_shrink_node+0x89f/0x1750 mm/vmscan.c:4935
       shrink_node mm/vmscan.c:5894 [inline]
       kswapd_shrink_node mm/vmscan.c:6704 [inline]
       balance_pgdat+0x10d1/0x1a10 mm/vmscan.c:6895
       kswapd+0x5ea/0xbf0 mm/vmscan.c:7164
       kthread+0x2c1/0x3a0 kernel/kthread.c:388
       ret_from_fork+0x45/0x80 arch/x86/kernel/process.c:147
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

-> #0 (fs_reclaim){+.+.}-{0:0}:
       check_prev_add kernel/locking/lockdep.c:3134 [inline]
       check_prevs_add kernel/locking/lockdep.c:3253 [inline]
       validate_chain kernel/locking/lockdep.c:3869 [inline]
       __lock_acquire+0x2478/0x3b30 kernel/locking/lockdep.c:5137
       lock_acquire kernel/locking/lockdep.c:5754 [inline]
       lock_acquire+0x1b1/0x560 kernel/locking/lockdep.c:5719
       __fs_reclaim_acquire mm/page_alloc.c:3698 [inline]
       fs_reclaim_acquire+0x102/0x160 mm/page_alloc.c:3712
       might_alloc include/linux/sched/mm.h:312 [inline]
       slab_pre_alloc_hook mm/slub.c:3752 [inline]
       slab_alloc_node mm/slub.c:3833 [inline]
       kmalloc_trace+0x51/0x340 mm/slub.c:3998
       kmalloc include/linux/slab.h:628 [inline]
       add_stack_record_to_list mm/page_owner.c:177 [inline]
       inc_stack_record_count mm/page_owner.c:219 [inline]
       __set_page_owner+0x517/0x7a0 mm/page_owner.c:334
       set_page_owner include/linux/page_owner.h:32 [inline]
       post_alloc_hook+0x2d4/0x350 mm/page_alloc.c:1534
       prep_new_page mm/page_alloc.c:1541 [inline]
       get_page_from_freelist+0xa28/0x3780 mm/page_alloc.c:3317
       __alloc_pages+0x22b/0x2460 mm/page_alloc.c:4575
       __alloc_pages_bulk+0x742/0x14f0 mm/page_alloc.c:4523
       alloc_pages_bulk_array include/linux/gfp.h:202 [inline]
       xfs_buf_alloc_pages+0x20f/0x9d0 fs/xfs/xfs_buf.c:398
       xfs_buf_find_insert fs/xfs/xfs_buf.c:650 [inline]
       xfs_buf_get_map+0x1e69/0x30d0 fs/xfs/xfs_buf.c:755
       xfs_buf_read_map+0xd2/0xb40 fs/xfs/xfs_buf.c:860
       xfs_trans_read_buf_map+0x352/0x990 fs/xfs/xfs_trans_buf.c:289
       xfs_trans_read_buf fs/xfs/xfs_trans.h:210 [inline]
       xfs_qm_dqflush+0x224/0x1470 fs/xfs/xfs_dquot.c:1271
       xfs_qm_dquot_isolate+0xc8f/0x1420 fs/xfs/xfs_qm.c:465
       __list_lru_walk_one+0x19f/0x690 mm/list_lru.c:218
       list_lru_walk_one+0xac/0xf0 mm/list_lru.c:266
       list_lru_shrink_walk include/linux/list_lru.h:228 [inline]
       xfs_qm_shrink_scan+0x1fc/0x3f0 fs/xfs/xfs_qm.c:519
       do_shrink_slab+0x44f/0x11c0 mm/shrinker.c:435
       shrink_slab+0x18a/0x1310 mm/shrinker.c:662
       drop_slab_node mm/vmscan.c:393 [inline]
       drop_slab+0x14c/0x2c0 mm/vmscan.c:411
       drop_caches_sysctl_handler+0x171/0x190 fs/drop_caches.c:68
       proc_sys_call_handler+0x4cc/0x6f0 fs/proc/proc_sysctl.c:595
       call_write_iter include/linux/fs.h:2110 [inline]
       iter_file_splice_write+0x906/0x10b0 fs/splice.c:743
       do_splice_from fs/splice.c:941 [inline]
       direct_splice_actor+0x19b/0x6d0 fs/splice.c:1164
       splice_direct_to_actor+0x346/0xa40 fs/splice.c:1108
       do_splice_direct_actor fs/splice.c:1207 [inline]
       do_splice_direct+0x17e/0x250 fs/splice.c:1233
       do_sendfile+0xaa8/0xdb0 fs/read_write.c:1295
       __do_compat_sys_sendfile fs/read_write.c:1377 [inline]
       __se_compat_sys_sendfile fs/read_write.c:1366 [inline]
       __ia32_compat_sys_sendfile+0x163/0x230 fs/read_write.c:1366
       do_syscall_32_irqs_on arch/x86/entry/common.c:165 [inline]
       __do_fast_syscall_32+0x75/0x120 arch/x86/entry/common.c:386
       do_fast_syscall_32+0x32/0x80 arch/x86/entry/common.c:411
       entry_SYSENTER_compat_after_hwframe+0x84/0x8e

other info that might help us debug this:

Chain exists of:
  fs_reclaim --> &xfs_dir_ilock_class --> &dqp->q_qlock

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&dqp->q_qlock);
                               lock(&xfs_dir_ilock_class);
                               lock(&dqp->q_qlock);
  lock(fs_reclaim);

 *** DEADLOCK ***

2 locks held by syz-executor.3/11149:
 #0: ffff888021f1e420 (sb_writers#3){.+.+}-{0:0}, at: splice_direct_to_actor+0x346/0xa40 fs/splice.c:1108
 #1: ffff88806900e5a8 (&dqp->q_qlock){+.+.}-{3:3}, at: xfs_dqlock_nowait fs/xfs/xfs_dquot.h:120 [inline]
 #1: ffff88806900e5a8 (&dqp->q_qlock){+.+.}-{3:3}, at: xfs_qm_dquot_isolate+0x85/0x1420 fs/xfs/xfs_qm.c:423

stack backtrace:
CPU: 0 PID: 11149 Comm: syz-executor.3 Not tainted 6.9.0-rc7-syzkaller-00136-gf4345f05c0df #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x116/0x1f0 lib/dump_stack.c:114
 check_noncircular+0x31a/0x400 kernel/locking/lockdep.c:2187
 check_prev_add kernel/locking/lockdep.c:3134 [inline]
 check_prevs_add kernel/locking/lockdep.c:3253 [inline]
 validate_chain kernel/locking/lockdep.c:3869 [inline]
 __lock_acquire+0x2478/0x3b30 kernel/locking/lockdep.c:5137
 lock_acquire kernel/locking/lockdep.c:5754 [inline]
 lock_acquire+0x1b1/0x560 kernel/locking/lockdep.c:5719
 __fs_reclaim_acquire mm/page_alloc.c:3698 [inline]
 fs_reclaim_acquire+0x102/0x160 mm/page_alloc.c:3712
 might_alloc include/linux/sched/mm.h:312 [inline]
 slab_pre_alloc_hook mm/slub.c:3752 [inline]
 slab_alloc_node mm/slub.c:3833 [inline]
 kmalloc_trace+0x51/0x340 mm/slub.c:3998
 kmalloc include/linux/slab.h:628 [inline]
 add_stack_record_to_list mm/page_owner.c:177 [inline]
 inc_stack_record_count mm/page_owner.c:219 [inline]
 __set_page_owner+0x517/0x7a0 mm/page_owner.c:334
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x2d4/0x350 mm/page_alloc.c:1534
 prep_new_page mm/page_alloc.c:1541 [inline]
 get_page_from_freelist+0xa28/0x3780 mm/page_alloc.c:3317
 __alloc_pages+0x22b/0x2460 mm/page_alloc.c:4575
 __alloc_pages_bulk+0x742/0x14f0 mm/page_alloc.c:4523
 alloc_pages_bulk_array include/linux/gfp.h:202 [inline]
 xfs_buf_alloc_pages+0x20f/0x9d0 fs/xfs/xfs_buf.c:398
 xfs_buf_find_insert fs/xfs/xfs_buf.c:650 [inline]
 xfs_buf_get_map+0x1e69/0x30d0 fs/xfs/xfs_buf.c:755
 xfs_buf_read_map+0xd2/0xb40 fs/xfs/xfs_buf.c:860
 xfs_trans_read_buf_map+0x352/0x990 fs/xfs/xfs_trans_buf.c:289
 xfs_trans_read_buf fs/xfs/xfs_trans.h:210 [inline]
 xfs_qm_dqflush+0x224/0x1470 fs/xfs/xfs_dquot.c:1271
 xfs_qm_dquot_isolate+0xc8f/0x1420 fs/xfs/xfs_qm.c:465
 __list_lru_walk_one+0x19f/0x690 mm/list_lru.c:218
 list_lru_walk_one+0xac/0xf0 mm/list_lru.c:266
 list_lru_shrink_walk include/linux/list_lru.h:228 [inline]
 xfs_qm_shrink_scan+0x1fc/0x3f0 fs/xfs/xfs_qm.c:519
 do_shrink_slab+0x44f/0x11c0 mm/shrinker.c:435
 shrink_slab+0x18a/0x1310 mm/shrinker.c:662
 drop_slab_node mm/vmscan.c:393 [inline]
 drop_slab+0x14c/0x2c0 mm/vmscan.c:411
 drop_caches_sysctl_handler+0x171/0x190 fs/drop_caches.c:68
 proc_sys_call_handler+0x4cc/0x6f0 fs/proc/proc_sysctl.c:595
 call_write_iter include/linux/fs.h:2110 [inline]
 iter_file_splice_write+0x906/0x10b0 fs/splice.c:743
 do_splice_from fs/splice.c:941 [inline]
 direct_splice_actor+0x19b/0x6d0 fs/splice.c:1164
 splice_direct_to_actor+0x346/0xa40 fs/splice.c:1108
 do_splice_direct_actor fs/splice.c:1207 [inline]
 do_splice_direct+0x17e/0x250 fs/splice.c:1233
 do_sendfile+0xaa8/0xdb0 fs/read_write.c:1295
 __do_compat_sys_sendfile fs/read_write.c:1377 [inline]
 __se_compat_sys_sendfile fs/read_write.c:1366 [inline]
 __ia32_compat_sys_sendfile+0x163/0x230 fs/read_write.c:1366
 do_syscall_32_irqs_on arch/x86/entry/common.c:165 [inline]
 __do_fast_syscall_32+0x75/0x120 arch/x86/entry/common.c:386
 do_fast_syscall_32+0x32/0x80 arch/x86/entry/common.c:411
 entry_SYSENTER_compat_after_hwframe+0x84/0x8e
RIP: 0023:0xf7353579
Code: b8 01 10 06 03 74 b4 01 10 07 03 74 b0 01 10 08 03 74 d8 01 00 00 00 00 00 00 00 00 00 00 00 00 00 51 52 55 89 e5 0f 34 cd 80 <5d> 5a 59 c3 90 90 90 90 8d b4 26 00 00 00 00 8d b4 26 00 00 00 00
RSP: 002b:00000000f5f455ac EFLAGS: 00000292 ORIG_RAX: 00000000000000bb
RAX: ffffffffffffffda RBX: 0000000000000005 RCX: 0000000000000004
RDX: 0000000020002080 RSI: 000000000000023b RDI: 0000000000000000
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
 </TASK>
syz-executor.3 (11149): drop_caches: 2
syz-executor.3 (11149): drop_caches: 2
----------------
Code disassembly (best guess), 2 bytes skipped:
   0:	10 06                	adc    %al,(%rsi)
   2:	03 74 b4 01          	add    0x1(%rsp,%rsi,4),%esi
   6:	10 07                	adc    %al,(%rdi)
   8:	03 74 b0 01          	add    0x1(%rax,%rsi,4),%esi
   c:	10 08                	adc    %cl,(%rax)
   e:	03 74 d8 01          	add    0x1(%rax,%rbx,8),%esi
  1e:	00 51 52             	add    %dl,0x52(%rcx)
  21:	55                   	push   %rbp
  22:	89 e5                	mov    %esp,%ebp
  24:	0f 34                	sysenter
  26:	cd 80                	int    $0x80
* 28:	5d                   	pop    %rbp <-- trapping instruction
  29:	5a                   	pop    %rdx
  2a:	59                   	pop    %rcx
  2b:	c3                   	ret
  2c:	90                   	nop
  2d:	90                   	nop
  2e:	90                   	nop
  2f:	90                   	nop
  30:	8d b4 26 00 00 00 00 	lea    0x0(%rsi,%riz,1),%esi
  37:	8d b4 26 00 00 00 00 	lea    0x0(%rsi,%riz,1),%esi


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
