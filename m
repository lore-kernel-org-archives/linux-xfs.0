Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3963A12AAC6
	for <linux-xfs@vger.kernel.org>; Thu, 25 Apr 2024 14:46:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714056390; cv=none; b=XXE2yg1vMJSRpakLxOxqn+GZae4BH8gPi1mBVvdul408bXQBnGfzwmXdfI7HqS+sTqJKCoWPC3cLI1qEZYdORuO99kA2P++F0EXIBm0lDYjmt+mPL4r8l4Tsy2eRZmUISJql6mKUbF2p/aQ0G/Garlz0at9caRuJdVggiQBW+tk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714056390; c=relaxed/simple;
	bh=LbcXiESM2K+fsAzZFsa5YUMaQ8WR2R0cpCdRwcYrAis=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=OjcCt1f6RYeh919OMrsIj9u2FJjDbgNhheFi98kHkbJzdEhjPLnyOD+wCQCqvu77zpQ2YeQFQWqhmd4qLY/D0RbcNkIA6O/+OBU4DIHFUl8Rq9cF/I+Fx3QJHktzZiEXWMOO9wOmdNd6c5qVKCY0qYYujmibyklnvc9qY1trJWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-7d9913d3174so104980939f.0
        for <linux-xfs@vger.kernel.org>; Thu, 25 Apr 2024 07:46:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714056388; x=1714661188;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TDFN7R2/p9RmgqWGRxT96W+fH7Ymc+EZMEYfuX8yDdw=;
        b=RVWTijRpkUXU13RgRsWpJYkzEKvWTWKlrInFK/T2OAXyyiVFgH3GqrG9Rbmb1PiTvs
         zs/QJHfNx1At3uvV/DxQ3l0wk/sslfrjT7X0v9HV6Ivxr7dp5ulocDSxyMOQOX4r2VEm
         43QhT94oyztoFQSTdRknryQuXoRCQBFMaRd9Wq+vwKeCS1WyfI7YURZ9E0xaH7STtD2N
         qE0kthnD5hvUCEkpQOAG4wKHS+4i3gMN82E839Qcb8FaPihZ/dFfk5mc8BWnPzQuF/gW
         DORj+33HtohPxqsJLaQWEobamOKFy6aBN5KDmYGrcPRZtokWaI50yAy4Y1UOb233p7eX
         U5Mw==
X-Forwarded-Encrypted: i=1; AJvYcCXZqywueQXh4AIJqY8xkUKI6kPFSX/tGYvsf1Is4XsGYZjUcV6fkG4owEv5oV0dVUfxrgABVBb3PNkt2tD5B6+p0RiGUfdJ9370
X-Gm-Message-State: AOJu0Ywr+z8a48u7sZtlJotBdKgZYQ4/D7wl4xio8ph6YqlaT1bIkdTd
	j/Z+/MiGhOK2l0sH35x+/YCy8tSRq/BI8CAjVgqLPhO3b6U7FrN7Z1fszC+XuQwStjdTmHNzr08
	qKn2lI8WCIOBfmEafjovhFIORnTJvyzobu9qUpLJA3wOyrOt+ttgYNKM=
X-Google-Smtp-Source: AGHT+IEjwlQiDfvJ+MGw8XDbQCE40iCD7Z14+XIebyYskPX56r6Wi+S0CJz5Dslktqn0cq/gr1eZ4VrGj0yrznTwLhyfsSy644f6
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6638:830b:b0:487:2291:ae31 with SMTP id
 io11-20020a056638830b00b004872291ae31mr81446jab.1.1714056388462; Thu, 25 Apr
 2024 07:46:28 -0700 (PDT)
Date: Thu, 25 Apr 2024 07:46:28 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000028dd9a0616ecda61@google.com>
Subject: [syzbot] [xfs?] possible deadlock in xfs_ilock_data_map_shared
From: syzbot <syzbot+b7e8d799f0ab724876f9@syzkaller.appspotmail.com>
To: chandan.babu@oracle.com, djwong@kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    977b1ef51866 Merge tag 'block-6.9-20240420' of git://git.k..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=126497cd180000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d239903bd07761e5
dashboard link: https://syzkaller.appspot.com/bug?extid=b7e8d799f0ab724876f9
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/08d7b6e107aa/disk-977b1ef5.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/9c5e543ffdcf/vmlinux-977b1ef5.xz
kernel image: https://storage.googleapis.com/syzbot-assets/04a6d79d2f69/bzImage-977b1ef5.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+b7e8d799f0ab724876f9@syzkaller.appspotmail.com

XFS (loop2): Ending clean mount
======================================================
WARNING: possible circular locking dependency detected
6.9.0-rc4-syzkaller-00266-g977b1ef51866 #0 Not tainted
------------------------------------------------------
syz-executor.2/7915 is trying to acquire lock:
ffffffff8e42a800 (fs_reclaim){+.+.}-{0:0}, at: might_alloc include/linux/sched/mm.h:312 [inline]
ffffffff8e42a800 (fs_reclaim){+.+.}-{0:0}, at: slab_pre_alloc_hook mm/slub.c:3746 [inline]
ffffffff8e42a800 (fs_reclaim){+.+.}-{0:0}, at: slab_alloc_node mm/slub.c:3827 [inline]
ffffffff8e42a800 (fs_reclaim){+.+.}-{0:0}, at: kmalloc_trace+0x47/0x360 mm/slub.c:3992

but task is already holding lock:
ffff888056da8118 (&xfs_dir_ilock_class){++++}-{3:3}, at: xfs_ilock_data_map_shared+0x4f/0x70 fs/xfs/xfs_inode.c:114

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (&xfs_dir_ilock_class){++++}-{3:3}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5754
       down_write_nested+0x3d/0x50 kernel/locking/rwsem.c:1695
       xfs_reclaim_inode fs/xfs/xfs_icache.c:945 [inline]
       xfs_icwalk_process_inode fs/xfs/xfs_icache.c:1631 [inline]
       xfs_icwalk_ag+0x120e/0x1ad0 fs/xfs/xfs_icache.c:1713
       xfs_icwalk fs/xfs/xfs_icache.c:1762 [inline]
       xfs_reclaim_inodes_nr+0x257/0x360 fs/xfs/xfs_icache.c:1011
       super_cache_scan+0x411/0x4b0 fs/super.c:227
       do_shrink_slab+0x707/0x1160 mm/shrinker.c:435
       shrink_slab+0x1092/0x14d0 mm/shrinker.c:662
       shrink_one+0x453/0x880 mm/vmscan.c:4774
       shrink_many mm/vmscan.c:4835 [inline]
       lru_gen_shrink_node mm/vmscan.c:4935 [inline]
       shrink_node+0x3b17/0x4310 mm/vmscan.c:5894
       kswapd_shrink_node mm/vmscan.c:6704 [inline]
       balance_pgdat mm/vmscan.c:6895 [inline]
       kswapd+0x1882/0x38a0 mm/vmscan.c:7164
       kthread+0x2f2/0x390 kernel/kthread.c:388
       ret_from_fork+0x4d/0x80 arch/x86/kernel/process.c:147
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

-> #0 (fs_reclaim){+.+.}-{0:0}:
       check_prev_add kernel/locking/lockdep.c:3134 [inline]
       check_prevs_add kernel/locking/lockdep.c:3253 [inline]
       validate_chain+0x18cb/0x58e0 kernel/locking/lockdep.c:3869
       __lock_acquire+0x1346/0x1fd0 kernel/locking/lockdep.c:5137
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5754
       __fs_reclaim_acquire mm/page_alloc.c:3698 [inline]
       fs_reclaim_acquire+0x88/0x140 mm/page_alloc.c:3712
       might_alloc include/linux/sched/mm.h:312 [inline]
       slab_pre_alloc_hook mm/slub.c:3746 [inline]
       slab_alloc_node mm/slub.c:3827 [inline]
       kmalloc_trace+0x47/0x360 mm/slub.c:3992
       kmalloc include/linux/slab.h:628 [inline]
       add_stack_record_to_list mm/page_owner.c:177 [inline]
       inc_stack_record_count mm/page_owner.c:219 [inline]
       __set_page_owner+0x561/0x810 mm/page_owner.c:334
       set_page_owner include/linux/page_owner.h:32 [inline]
       post_alloc_hook+0x1ea/0x210 mm/page_alloc.c:1534
       prep_new_page mm/page_alloc.c:1541 [inline]
       get_page_from_freelist+0x3410/0x35b0 mm/page_alloc.c:3317
       __alloc_pages+0x256/0x6c0 mm/page_alloc.c:4575
       __alloc_pages_bulk+0x729/0xd40 mm/page_alloc.c:4523
       alloc_pages_bulk_array include/linux/gfp.h:202 [inline]
       xfs_buf_alloc_pages+0x1a7/0x860 fs/xfs/xfs_buf.c:398
       xfs_buf_find_insert+0x19a/0x1540 fs/xfs/xfs_buf.c:650
       xfs_buf_get_map+0x149c/0x1ae0 fs/xfs/xfs_buf.c:755
       xfs_buf_read_map+0x111/0xa60 fs/xfs/xfs_buf.c:860
       xfs_trans_read_buf_map+0x260/0xad0 fs/xfs/xfs_trans_buf.c:289
       xfs_da_read_buf+0x2b1/0x470 fs/xfs/libxfs/xfs_da_btree.c:2674
       xfs_dir3_block_read+0x92/0x1a0 fs/xfs/libxfs/xfs_dir2_block.c:145
       xfs_dir2_block_lookup_int+0x109/0x7d0 fs/xfs/libxfs/xfs_dir2_block.c:700
       xfs_dir2_block_lookup+0x19a/0x630 fs/xfs/libxfs/xfs_dir2_block.c:650
       xfs_dir_lookup+0x633/0xaf0 fs/xfs/libxfs/xfs_dir2.c:399
       xfs_lookup+0x298/0x550 fs/xfs/xfs_inode.c:640
       xfs_vn_lookup+0x192/0x290 fs/xfs/xfs_iops.c:303
       lookup_open fs/namei.c:3475 [inline]
       open_last_lookups fs/namei.c:3566 [inline]
       path_openat+0x1035/0x3240 fs/namei.c:3796
       do_filp_open+0x235/0x490 fs/namei.c:3826
       do_sys_openat2+0x13e/0x1d0 fs/open.c:1406
       do_sys_open fs/open.c:1421 [inline]
       __do_sys_openat fs/open.c:1437 [inline]
       __se_sys_openat fs/open.c:1432 [inline]
       __x64_sys_openat+0x247/0x2a0 fs/open.c:1432
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf5/0x240 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

other info that might help us debug this:

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  rlock(&xfs_dir_ilock_class);
                               lock(fs_reclaim);
                               lock(&xfs_dir_ilock_class);
  lock(fs_reclaim);

 *** DEADLOCK ***

3 locks held by syz-executor.2/7915:
 #0: ffff8881d0472420 (sb_writers#14){.+.+}-{0:0}, at: mnt_want_write+0x3f/0x90 fs/namespace.c:409
 #1: ffff888056da8338 (&inode->i_sb->s_type->i_mutex_dir_key){++++}-{3:3}, at: inode_lock include/linux/fs.h:795 [inline]
 #1: ffff888056da8338 (&inode->i_sb->s_type->i_mutex_dir_key){++++}-{3:3}, at: open_last_lookups fs/namei.c:3563 [inline]
 #1: ffff888056da8338 (&inode->i_sb->s_type->i_mutex_dir_key){++++}-{3:3}, at: path_openat+0x7d3/0x3240 fs/namei.c:3796
 #2: ffff888056da8118 (&xfs_dir_ilock_class){++++}-{3:3}, at: xfs_ilock_data_map_shared+0x4f/0x70 fs/xfs/xfs_inode.c:114

stack backtrace:
CPU: 1 PID: 7915 Comm: syz-executor.2 Not tainted 6.9.0-rc4-syzkaller-00266-g977b1ef51866 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 03/27/2024
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:114
 check_noncircular+0x36a/0x4a0 kernel/locking/lockdep.c:2187
 check_prev_add kernel/locking/lockdep.c:3134 [inline]
 check_prevs_add kernel/locking/lockdep.c:3253 [inline]
 validate_chain+0x18cb/0x58e0 kernel/locking/lockdep.c:3869
 __lock_acquire+0x1346/0x1fd0 kernel/locking/lockdep.c:5137
 lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5754
 __fs_reclaim_acquire mm/page_alloc.c:3698 [inline]
 fs_reclaim_acquire+0x88/0x140 mm/page_alloc.c:3712
 might_alloc include/linux/sched/mm.h:312 [inline]
 slab_pre_alloc_hook mm/slub.c:3746 [inline]
 slab_alloc_node mm/slub.c:3827 [inline]
 kmalloc_trace+0x47/0x360 mm/slub.c:3992
 kmalloc include/linux/slab.h:628 [inline]
 add_stack_record_to_list mm/page_owner.c:177 [inline]
 inc_stack_record_count mm/page_owner.c:219 [inline]
 __set_page_owner+0x561/0x810 mm/page_owner.c:334
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x1ea/0x210 mm/page_alloc.c:1534
 prep_new_page mm/page_alloc.c:1541 [inline]
 get_page_from_freelist+0x3410/0x35b0 mm/page_alloc.c:3317
 __alloc_pages+0x256/0x6c0 mm/page_alloc.c:4575
 __alloc_pages_bulk+0x729/0xd40 mm/page_alloc.c:4523
 alloc_pages_bulk_array include/linux/gfp.h:202 [inline]
 xfs_buf_alloc_pages+0x1a7/0x860 fs/xfs/xfs_buf.c:398
 xfs_buf_find_insert+0x19a/0x1540 fs/xfs/xfs_buf.c:650
 xfs_buf_get_map+0x149c/0x1ae0 fs/xfs/xfs_buf.c:755
 xfs_buf_read_map+0x111/0xa60 fs/xfs/xfs_buf.c:860
 xfs_trans_read_buf_map+0x260/0xad0 fs/xfs/xfs_trans_buf.c:289
 xfs_da_read_buf+0x2b1/0x470 fs/xfs/libxfs/xfs_da_btree.c:2674
 xfs_dir3_block_read+0x92/0x1a0 fs/xfs/libxfs/xfs_dir2_block.c:145
 xfs_dir2_block_lookup_int+0x109/0x7d0 fs/xfs/libxfs/xfs_dir2_block.c:700
 xfs_dir2_block_lookup+0x19a/0x630 fs/xfs/libxfs/xfs_dir2_block.c:650
 xfs_dir_lookup+0x633/0xaf0 fs/xfs/libxfs/xfs_dir2.c:399
 xfs_lookup+0x298/0x550 fs/xfs/xfs_inode.c:640
 xfs_vn_lookup+0x192/0x290 fs/xfs/xfs_iops.c:303
 lookup_open fs/namei.c:3475 [inline]
 open_last_lookups fs/namei.c:3566 [inline]
 path_openat+0x1035/0x3240 fs/namei.c:3796
 do_filp_open+0x235/0x490 fs/namei.c:3826
 do_sys_openat2+0x13e/0x1d0 fs/open.c:1406
 do_sys_open fs/open.c:1421 [inline]
 __do_sys_openat fs/open.c:1437 [inline]
 __se_sys_openat fs/open.c:1432 [inline]
 __x64_sys_openat+0x247/0x2a0 fs/open.c:1432
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf5/0x240 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f23c887dea9
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 e1 20 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f23c95950c8 EFLAGS: 00000246 ORIG_RAX: 0000000000000101
RAX: ffffffffffffffda RBX: 00007f23c89abf80 RCX: 00007f23c887dea9
RDX: 000000000000275a RSI: 0000000020000080 RDI: ffffffffffffff9c
RBP: 00007f23c88ca4a4 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 000000000000000b R14: 00007f23c89abf80 R15: 00007fff62a26428
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
