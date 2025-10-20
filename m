Received: from mail-il1-f208.google.com (mail-il1-f208.google.com [209.85.166.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DC752E6CBE
	for <linux-xfs@vger.kernel.org>; Mon, 20 Oct 2025 21:08:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760994507; cv=none; b=qusiZKeoeVnC+fJ0lihphqqAApG1bPaEX6FRFfjqp57Rgotsfjpc5fgvydGO3VzQCrEHFiMVB72g9y1LAnmXzGHrxSHboSrzGaLeZVWyY79w8U8BVTqyN96RrSvistvcfbV2j+5mA26WgDSWr4E1cHkZF2yPiZpuW8wsxJp1XUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760994507; c=relaxed/simple;
	bh=6M7rCIWUHwretY2dkQusuOpshxDC/gQAN5l3fsCb5yc=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=fBLZa0TT+HxbGOmfI4B9aEzvaOvEgDY2pWrKrOyJMx/tczt7sXjbCqrBqcszDwTEhbcQNEgE0NNTpMZAYDts6QdfJbxjxXdG1Mi4m9S1mN+0A65p+9+1EQgSrMHocOc4NFK7zqNi2EPS8YnUd/GZ3Dfco7J6cUZhjzlcG1c3VTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f208.google.com with SMTP id e9e14a558f8ab-430ca53080bso37700235ab.1
        for <linux-xfs@vger.kernel.org>; Mon, 20 Oct 2025 14:08:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760994504; x=1761599304;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=I0eXYf3TjrYmmJbW09ZvPArClIX2HBveW+wmmrkYZcI=;
        b=EyB5hoX3wQ+QB6QVgJckSeBHIprsGcgG2XeSGKo+Op0lBlmsJzfobxy0IqQo664Q4V
         jLT7XwKObzOv6Rq0CkXXT4VEW7oThjneLNFXh7b5AScNWS6p5rgBUeUCDzFd5iAFYA2t
         UbIhtSskJVP4uJ+W6ctNsCqLNjBwvG1GqG67nJNHEg2XeCZwm/jjSOL8ck/jUTIdCyLM
         5HE/ZZV7AHkF0JYvOStp5bd/FHvAcNpMEibUr/LGX9KvqvDMjvLK7Yn8hdS+SZfTKvCQ
         M5WojLMvkPegcoOCNACBXUde6aky5D7XqC+JQwde8EwY+jsYGN7EuqAFnNziHWa+hHqB
         sneg==
X-Forwarded-Encrypted: i=1; AJvYcCX15CYSbT0zo7UTOi0/mLeHzd+yScoVEXEWLD8/mnKs/TZaM+doVu4wzBueBL24CfDPlz9mDjz47GA=@vger.kernel.org
X-Gm-Message-State: AOJu0YyNNBDQBbr0d1Fk0RCOypsgca6A4MJWpy6jPAg6IUZLQ0qZWL6Z
	xOLD+gRXdRrlt6ETfNXIa8wOlQyPFRcthEnJKJLwuyIGzGVtqRgIEfdVg6nPwKbnDtfNz5/9Q8R
	ypUHzpK47U3NfnPhWU9p5NHfvs/LEz19ajZq0MLJlh43zUdVG6RpbzZ5E9+M=
X-Google-Smtp-Source: AGHT+IHbdtDVSpXjuhxh36FgFokNZFak1pGN6vBsD5YgawEkDR+EYvTO78CPnmFZzbu5yb+piDW8LKG1ghDoW5pLH8GshetdwwH/
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:4417:10b0:430:d21d:7b24 with SMTP id
 e9e14a558f8ab-430d21d7b55mr120263865ab.32.1760994504385; Mon, 20 Oct 2025
 14:08:24 -0700 (PDT)
Date: Mon, 20 Oct 2025 14:08:24 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68f6a4c8.050a0220.1be48.0012.GAE@google.com>
Subject: [syzbot] [nilfs?] [xfs?] INFO: task hung in xfs_buf_get_map
From: syzbot <syzbot+d74d844bdcee0902b28a@syzkaller.appspotmail.com>
To: anna-maria@linutronix.de, cem@kernel.org, frederic@kernel.org, 
	konishi.ryusuke@gmail.com, linux-kernel@vger.kernel.org, 
	linux-nilfs@vger.kernel.org, linux-xfs@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com, tglx@linutronix.de
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    93f3bab4310d Add linux-next specific files for 20251017
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=164183cd980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=408308c229eef498
dashboard link: https://syzkaller.appspot.com/bug?extid=d74d844bdcee0902b28a
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15731492580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/c955a9337646/disk-93f3bab4.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/843962ea5283/vmlinux-93f3bab4.xz
kernel image: https://storage.googleapis.com/syzbot-assets/42360a7c5734/bzImage-93f3bab4.xz
mounted in repro #1: https://storage.googleapis.com/syzbot-assets/79eeb7cc5dde/mount_0.gz
  fsck result: failed (log: https://syzkaller.appspot.com/x/fsck.log?x=16995de2580000)
mounted in repro #2: https://storage.googleapis.com/syzbot-assets/9596ff3df6a7/mount_4.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+d74d844bdcee0902b28a@syzkaller.appspotmail.com

INFO: task syz.2.368:9928 blocked for more than 143 seconds.
      Not tainted syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz.2.368       state:D stack:20840 pid:9928  tgid:9927  ppid:5959   task_flags:0x440140 flags:0x00080003
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5254 [inline]
 __schedule+0x17c4/0x4d60 kernel/sched/core.c:6862
 __schedule_loop kernel/sched/core.c:6944 [inline]
 schedule+0x165/0x360 kernel/sched/core.c:6959
 schedule_timeout+0x9a/0x270 kernel/time/sleep_timeout.c:75
 ___down_common kernel/locking/semaphore.c:268 [inline]
 __down_common+0x319/0x6a0 kernel/locking/semaphore.c:293
 down+0x80/0xd0 kernel/locking/semaphore.c:100
 xfs_buf_lock+0x15d/0x4d0 fs/xfs/xfs_buf.c:993
 xfs_buf_find_lock+0x42/0x4c0 fs/xfs/xfs_buf.c:419
 xfs_buf_lookup fs/xfs/xfs_buf.c:472 [inline]
 xfs_buf_get_map+0x10cf/0x1840 fs/xfs/xfs_buf.c:594
 xfs_buf_read_map+0x82/0xa50 fs/xfs/xfs_buf.c:699
 xfs_trans_read_buf_map+0x1d7/0x8e0 fs/xfs/xfs_trans_buf.c:304
 xfs_trans_read_buf fs/xfs/xfs_trans.h:210 [inline]
 xfs_read_agf+0x281/0x5c0 fs/xfs/libxfs/xfs_alloc.c:3376
 xfs_alloc_read_agf+0x17c/0xb70 fs/xfs/libxfs/xfs_alloc.c:3411
 xfs_alloc_fix_freelist+0x60a/0x1300 fs/xfs/libxfs/xfs_alloc.c:2875
 xfs_free_extent_fix_freelist+0x13e/0x240 fs/xfs/libxfs/xfs_alloc.c:3990
 xfs_rmap_finish_init_cursor+0xae/0x210 fs/xfs/libxfs/xfs_rmap.c:2645
 xfs_rmap_finish_one+0x2a2/0x710 fs/xfs/libxfs/xfs_rmap.c:2708
 xfs_rmap_update_finish_item+0x25/0x40 fs/xfs/xfs_rmap_item.c:437
 xfs_defer_finish_one+0x5c8/0xcf0 fs/xfs/libxfs/xfs_defer.c:595
 xfs_defer_finish_noroll+0x910/0x12d0 fs/xfs/libxfs/xfs_defer.c:707
 xfs_trans_commit+0x10b/0x1c0 fs/xfs/xfs_trans.c:921
 xfs_attr_set+0xdc6/0x1210 fs/xfs/libxfs/xfs_attr.c:1150
 xfs_xattr_set+0x14d/0x250 fs/xfs/xfs_xattr.c:186
 __vfs_setxattr+0x43c/0x480 fs/xattr.c:200
 __vfs_setxattr_noperm+0x12d/0x660 fs/xattr.c:234
 vfs_setxattr+0x16b/0x2f0 fs/xattr.c:321
 do_setxattr fs/xattr.c:636 [inline]
 filename_setxattr+0x274/0x600 fs/xattr.c:665
 path_setxattrat+0x364/0x3a0 fs/xattr.c:713
 __do_sys_setxattr fs/xattr.c:747 [inline]
 __se_sys_setxattr fs/xattr.c:743 [inline]
 __x64_sys_setxattr+0xbc/0xe0 fs/xattr.c:743
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f141038efc9
RSP: 002b:00007f1411141038 EFLAGS: 00000246 ORIG_RAX: 00000000000000bc
RAX: ffffffffffffffda RBX: 00007f14105e5fa0 RCX: 00007f141038efc9
RDX: 00002000000013c0 RSI: 0000200000000140 RDI: 0000200000000100
RBP: 00007f1410411f91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000700 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f14105e6038 R14: 00007f14105e5fa0 R15: 00007ffeca4978b8
 </TASK>

Showing all locks held in the system:
1 lock held by khungtaskd/31:
 #0: ffffffff8e13d720 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire include/linux/rcupdate.h:331 [inline]
 #0: ffffffff8e13d720 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock include/linux/rcupdate.h:867 [inline]
 #0: ffffffff8e13d720 (rcu_read_lock){....}-{1:3}, at: debug_show_all_locks+0x2e/0x180 kernel/locking/lockdep.c:6775
2 locks held by getty/5586:
 #0: ffff88803370d0a0 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x25/0x70 drivers/tty/tty_ldisc.c:243
 #1: ffffc900036bb2f0 (&ldata->atomic_read_lock){+.+.}-{4:4}, at: n_tty_read+0x43e/0x1400 drivers/tty/n_tty.c:2222
2 locks held by udevd/5851:
1 lock held by syz-executor/5948:
 #0: ffffffff8e1431b8 (rcu_state.exp_mutex){+.+.}-{4:4}, at: exp_funnel_lock kernel/rcu/tree_exp.h:343 [inline]
 #0: ffffffff8e1431b8 (rcu_state.exp_mutex){+.+.}-{4:4}, at: synchronize_rcu_expedited+0x3b9/0x730 kernel/rcu/tree_exp.h:957
2 locks held by syz-executor/5951:
 #0: ffff8880334640e0 (&type->s_umount_key#53){+.+.}-{4:4}, at: __super_lock fs/super.c:57 [inline]
 #0: ffff8880334640e0 (&type->s_umount_key#53){+.+.}-{4:4}, at: __super_lock_excl fs/super.c:72 [inline]
 #0: ffff8880334640e0 (&type->s_umount_key#53){+.+.}-{4:4}, at: deactivate_super+0xa9/0xe0 fs/super.c:505
 #1: ffff88801cab0188 (&root->kernfs_rwsem){++++}-{4:4}, at: kernfs_remove_by_name_ns+0x3d/0x130 fs/kernfs/dir.c:1712
5 locks held by kworker/u8:9/8967:
4 locks held by syz.2.368/9928:
 #0: ffff888026af0420 (sb_writers#12){.+.+}-{0:0}, at: mnt_want_write+0x41/0x90 fs/namespace.c:508
 #1: ffff8880571d8ab0 (&sb->s_type->i_mutex_key#20){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:980 [inline]
 #1: ffff8880571d8ab0 (&sb->s_type->i_mutex_key#20){+.+.}-{4:4}, at: vfs_setxattr+0x144/0x2f0 fs/xattr.c:320
 #2: ffff888026af0610 (sb_internal#2){.+.+}-{0:0}, at: xfs_trans_alloc+0xd7/0x980 fs/xfs/xfs_trans.c:256
 #3: ffff8880571d8898 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_trans_alloc_inode+0x161/0x4a0 fs/xfs/xfs_trans.c:1082
4 locks held by syz.2.368/9964:
 #0: ffff888026af0420 (sb_writers#12){.+.+}-{0:0}, at: mnt_want_write+0x41/0x90 fs/namespace.c:508
 #1: ffff88805722d5b0 (&inode->i_sb->s_type->i_mutex_dir_key){++++}-{4:4}, at: inode_lock include/linux/fs.h:980 [inline]
 #1: ffff88805722d5b0 (&inode->i_sb->s_type->i_mutex_dir_key){++++}-{4:4}, at: vfs_setxattr+0x144/0x2f0 fs/xattr.c:320
 #2: ffff888026af0610 (sb_internal#2){.+.+}-{0:0}, at: xfs_trans_alloc+0xd7/0x980 fs/xfs/xfs_trans.c:256
 #3: ffff88805722d398 (&xfs_dir_ilock_class){++++}-{4:4}, at: xfs_trans_alloc_inode+0x161/0x4a0 fs/xfs/xfs_trans.c:1082
1 lock held by syz-executor/10238:
2 locks held by syz.3.652/13032:
 #0: ffff888031bc20e0 (&type->s_umount_key#52/1){+.+.}-{4:4}, at: alloc_super+0x1bb/0x930 fs/super.c:344
 #1: ffff8880b863a058 (&rq->__lock){-.-.}-{2:2}, at: raw_spin_rq_lock_nested+0x2a/0x140 kernel/sched/core.c:638

=============================================



---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup
