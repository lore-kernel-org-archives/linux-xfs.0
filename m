Received: from mail-io1-f77.google.com (mail-io1-f77.google.com [209.85.166.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCCD922F765
	for <linux-xfs@vger.kernel.org>; Wed,  9 Jul 2025 17:39:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.77
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752082772; cv=none; b=BxLNNOwrfD3aiPmbC+hyqur9tzz5ZZAqbLDupbnqr29tNDGNc6O8fUCmstiX/M34egQLmhQHCDLuUQM5l80Gyjs5orC5zxsPA4vAMWgqMksQv56hyEDbC8hSYhhumCTQI8/+d+v5tWbs6GcDZ9kxycSjvrOb/TPH0cJEaPNN0dM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752082772; c=relaxed/simple;
	bh=dLhcLXEz3T5QY3NMIKU7fpfYh0j3lYzTsI6Yk1XlaqA=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=GfWBWnErMr3B5ciA+YA5e1WPq0/IqWhag6S+SPuIVurU9m7jAaeCQdylyDO7i40PQAImNavYbjvs8TUSJ/+FKa52iR8KPNT9bEi+ODtAvyV0UgPdQmGE4Vpv5XRQj+YA9Ak/ujK36uRoMz0R4RqtcYJKgoo0zoTQZw8bH+yhRpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f77.google.com with SMTP id ca18e2360f4ac-87595d00ca0so20373839f.2
        for <linux-xfs@vger.kernel.org>; Wed, 09 Jul 2025 10:39:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752082770; x=1752687570;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=iRs/7skjGXVU+ooA28uLHDFVkU9E5UNs+MVsLcKKsyA=;
        b=nN8dD+vYvQNqvqmLB5oLekCdnE4UxqT8a4LeRvWf7FBmHLJrI2V6fCuhRpyKREpJpE
         Ul5c/4br5+ONr7UdtaKEwSMHJbQIBZVXb0XNAnynxQNwzRzmhc7l0qdJm7DlNi3bc8W9
         P3GIhIflx5LiBFxoXxD1zwJHUAceq0lbcNBZdhk2jc1KSzux8QtpWONJDqSDWuBXRySf
         hW2OzAKyNLrKXB0ndt/XSdv7s0W9I+NrzkZMpZWpdqMS35vkHyjvOLlMvEWgsxlyaRA5
         lu6ALntbufJHSF5U6FJaVrqr6VGJSPLbVZmMRZhm90+rjl4GQ2xGmrUyqebzwn9uLYD4
         th2A==
X-Forwarded-Encrypted: i=1; AJvYcCXyWf1Lut+9cXncJ6viTWiMcGc+IbvXwWulWLsVg7NYfiPPoM8b7IH6Zl9GUMaUHlHt3SfGCi4iGks=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx4/JD3RadRNcfif2AqaHfKZxJO48y31LRtE98ON+TkihM2KVd4
	J2q8d2HGVjv+ik2dHkiDptzOwgd82mBGTD5qzJudXM3/YUWP1JdulZhehH697yqtX5zd+bpUaqN
	FywSI7s/sJTESmvuUz4RpgPBgr8HqjEqpPmAfliNkvjhkAho4QGIXIJ+jno8=
X-Google-Smtp-Source: AGHT+IH/2IsU3t0l5UT5Khhmq//gwyMLdjJ/hW58e0JvU76Ijmj364iS7wt+yaYajH5XrgEzM1lKuMqUdmAYCXLQM6jMT8deDcWM
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:6d0f:b0:85d:b054:6eb9 with SMTP id
 ca18e2360f4ac-8795b4e0b43mr448729539f.14.1752082769731; Wed, 09 Jul 2025
 10:39:29 -0700 (PDT)
Date: Wed, 09 Jul 2025 10:39:29 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <686ea951.050a0220.385921.0015.GAE@google.com>
Subject: [syzbot] [xfs?] INFO: task hung in xfs_file_fsync
From: syzbot <syzbot+9bc8c0586b39708784d9@syzkaller.appspotmail.com>
To: cem@kernel.org, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    d006330be3f7 Merge tag 'sound-6.16-rc6' of git://git.kerne..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17d17f70580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b309c907eaab29da
dashboard link: https://syzkaller.appspot.com/bug?extid=9bc8c0586b39708784d9
compiler:       Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15e24a8c580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10ed3582580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/589c382b9e63/disk-d006330b.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/756fa29cc5a7/vmlinux-d006330b.xz
kernel image: https://storage.googleapis.com/syzbot-assets/41f40b8b4afc/bzImage-d006330b.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/f0df0d993fe8/mount_0.gz
  fsck result: failed (log: https://syzkaller.appspot.com/x/fsck.log?x=11e24a8c580000)

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+9bc8c0586b39708784d9@syzkaller.appspotmail.com

INFO: task syz.6.141:7477 blocked for more than 143 seconds.
      Not tainted 6.16.0-rc5-syzkaller-00025-gd006330be3f7 #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz.6.141       state:D stack:21864 pid:7477  tgid:7476  ppid:6658   task_flags:0x400140 flags:0x00004004
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5401 [inline]
 __schedule+0x16f5/0x4d00 kernel/sched/core.c:6790
 __schedule_loop kernel/sched/core.c:6868 [inline]
 schedule+0x165/0x360 kernel/sched/core.c:6883
 schedule_preempt_disabled+0x13/0x30 kernel/sched/core.c:6940
 rwsem_down_read_slowpath+0x552/0x880 kernel/locking/rwsem.c:1084
 __down_read_common kernel/locking/rwsem.c:1248 [inline]
 __down_read kernel/locking/rwsem.c:1261 [inline]
 down_read_nested+0x9a/0x2f0 kernel/locking/rwsem.c:1650
 xfs_fsync_flush_log fs/xfs/xfs_file.c:112 [inline]
 xfs_file_fsync+0x422/0xa30 fs/xfs/xfs_file.c:167
 generic_write_sync include/linux/fs.h:3031 [inline]
 xfs_file_buffered_write+0x713/0x890 fs/xfs/xfs_file.c:1018
 do_iter_readv_writev+0x56e/0x7f0 fs/read_write.c:-1
 vfs_writev+0x31a/0x960 fs/read_write.c:1057
 do_pwritev fs/read_write.c:1153 [inline]
 __do_sys_pwritev2 fs/read_write.c:1211 [inline]
 __se_sys_pwritev2+0x179/0x290 fs/read_write.c:1202
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fccbdb8e929
RSP: 002b:00007fccbe9f2038 EFLAGS: 00000246 ORIG_RAX: 0000000000000148
RAX: ffffffffffffffda RBX: 00007fccbddb5fa0 RCX: 00007fccbdb8e929
RDX: 0000000000000001 RSI: 00002000000001c0 RDI: 0000000000000004
RBP: 00007fccbdc10b39 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000e7b R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 00007fccbddb5fa0 R15: 00007ffd671078d8
 </TASK>

Showing all locks held in the system:
1 lock held by khungtaskd/31:
 #0: 
ffffffff8e13f160 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire include/linux/rcupdate.h:331 [inline]
ffffffff8e13f160 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock include/linux/rcupdate.h:841 [inline]
ffffffff8e13f160 (rcu_read_lock){....}-{1:3}, at: debug_show_all_locks+0x2e/0x180 kernel/locking/lockdep.c:6770
2 locks held by kworker/u8:5/969:
2 locks held by getty/5603:
 #0: ffff88803539a0a0 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x25/0x70 drivers/tty/tty_ldisc.c:243
 #1: ffffc9000333b2f0 (&ldata->atomic_read_lock){+.+.}-{4:4}, at: n_tty_read+0x43e/0x1400 drivers/tty/n_tty.c:2222
1 lock held by syz-executor/5979:
 #0: ffffffff8e144c78 (rcu_state.exp_mutex){+.+.}-{4:4}, at: exp_funnel_lock kernel/rcu/tree_exp.h:336 [inline]
 #0: ffffffff8e144c78 (rcu_state.exp_mutex){+.+.}-{4:4}, at: synchronize_rcu_expedited+0x3b9/0x730 kernel/rcu/tree_exp.h:998
1 lock held by syz-executor/5980:
 #0: ffffffff8e144c78 (rcu_state.exp_mutex){+.+.}-{4:4}, at: exp_funnel_lock kernel/rcu/tree_exp.h:336 [inline]
 #0: ffffffff8e144c78 (rcu_state.exp_mutex){+.+.}-{4:4}, at: synchronize_rcu_expedited+0x3b9/0x730 kernel/rcu/tree_exp.h:998
4 locks held by syz.2.46/6517:
 #0: ffff88802386a428 (sb_writers#12){.+.+}-{0:0}, at: mnt_want_write+0x41/0x90 fs/namespace.c:557
 #1: ffff888022d85870 (&sb->s_type->i_mutex_key#20){++++}-{4:4}, at: inode_lock include/linux/fs.h:869 [inline]
 #1: ffff888022d85870 (&sb->s_type->i_mutex_key#20){++++}-{4:4}, at: vfs_setxattr+0x144/0x2f0 fs/xattr.c:320
 #2: ffff88802386a618 (sb_internal#2){.+.+}-{0:0}, at: xfs_trans_alloc_inode+0x13c/0x4a0 fs/xfs/xfs_trans.c:1098
 #3: ffff888022d85658 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_trans_alloc_inode+0x161/0x4a0 fs/xfs/xfs_trans.c:1104
4 locks held by syz.5.114/7216:
 #0: ffff8880734a2428 (sb_writers#12){.+.+}-{0:0}, at: mnt_want_write+0x41/0x90 fs/namespace.c:557
 #1: ffff88804fbfc8f0 (&sb->s_type->i_mutex_key#20){++++}-{4:4}, at: inode_lock include/linux/fs.h:869 [inline]
 #1: ffff88804fbfc8f0 (&sb->s_type->i_mutex_key#20){++++}-{4:4}, at: vfs_setxattr+0x144/0x2f0 fs/xattr.c:320
 #2: ffff8880734a2618 (sb_internal#2){.+.+}-{0:0}, at: xfs_trans_alloc_inode+0x13c/0x4a0 fs/xfs/xfs_trans.c:1098
 #3: ffff88804fbfc6d8 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_trans_alloc_inode+0x161/0x4a0 fs/xfs/xfs_trans.c:1104
2 locks held by syz.6.141/7477:
 #0: ffff88805c398428 (sb_writers#12){.+.+}-{0:0}, at: file_start_write include/linux/fs.h:3096 [inline]
 #0: ffff88805c398428 (sb_writers#12){.+.+}-{0:0}, at: vfs_writev+0x288/0x960 fs/read_write.c:1055
 #1: ffff88807f90a7d8 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_fsync_flush_log fs/xfs/xfs_file.c:112 [inline]
 #1: ffff88807f90a7d8 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_file_fsync+0x422/0xa30 fs/xfs/xfs_file.c:167
4 locks held by syz.6.141/7520:
 #0: ffff88805c398428 (sb_writers#12){.+.+}-{0:0}, at: mnt_want_write+0x41/0x90 fs/namespace.c:557
 #1: ffff88807f90a9f0 (&sb->s_type->i_mutex_key#20){++++}-{4:4}, at: inode_lock include/linux/fs.h:869 [inline]
 #1: ffff88807f90a9f0 (&sb->s_type->i_mutex_key#20){++++}-{4:4}, at: vfs_setxattr+0x144/0x2f0 fs/xattr.c:320
 #2: ffff88805c398618 (sb_internal#2){.+.+}-{0:0}, at: xfs_trans_alloc_inode+0x13c/0x4a0 fs/xfs/xfs_trans.c:1098
 #3: ffff88807f90a7d8 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_trans_alloc_inode+0x161/0x4a0 fs/xfs/xfs_trans.c:1104
4 locks held by syz.0.144/7510:
 #0: ffff88807b726428 (sb_writers#12){.+.+}-{0:0}, at: mnt_want_write+0x41/0x90 fs/namespace.c:557
 #1: ffff88804fbfb1b0 (&sb->s_type->i_mutex_key#20){++++}-{4:4}, at: inode_lock include/linux/fs.h:869 [inline]
 #1: ffff88804fbfb1b0 (&sb->s_type->i_mutex_key#20){++++}-{4:4}, at: vfs_setxattr+0x144/0x2f0 fs/xattr.c:320
 #2: ffff88807b726618 (sb_internal#2){.+.+}-{0:0}, at: xfs_trans_alloc_inode+0x13c/0x4a0 fs/xfs/xfs_trans.c:1098
 #3: ffff88804fbfaf98 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_trans_alloc_inode+0x161/0x4a0 fs/xfs/xfs_trans.c:1104
4 locks held by syz.7.184/8027:
 #0: ffff888074d8c428 (sb_writers#12){.+.+}-{0:0}, at: mnt_want_write+0x41/0x90 fs/namespace.c:557
 #1: ffff88807f90d870 (&sb->s_type->i_mutex_key#20){++++}-{4:4}, at: inode_lock include/linux/fs.h:869 [inline]
 #1: ffff88807f90d870 (&sb->s_type->i_mutex_key#20){++++}-{4:4}, at: vfs_setxattr+0x144/0x2f0 fs/xattr.c:320
 #2: ffff888074d8c618 (sb_internal#2){.+.+}-{0:0}, at: xfs_trans_alloc_inode+0x13c/0x4a0 fs/xfs/xfs_trans.c:1098
 #3: ffff88807f90d658 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_trans_alloc_inode+0x161/0x4a0 fs/xfs/xfs_trans.c:1104
4 locks held by syz.9.222/8459:
 #0: ffff88802f5f8428 (sb_writers#12){.+.+}-{0:0}, at: mnt_want_write+0x41/0x90 fs/namespace.c:557
 #1: ffff88804fa20330 (&sb->s_type->i_mutex_key#20){++++}-{4:4}, at: inode_lock include/linux/fs.h:869 [inline]
 #1: ffff88804fa20330 (&sb->s_type->i_mutex_key#20){++++}-{4:4}, at: vfs_setxattr+0x144/0x2f0 fs/xattr.c:320
 #2: ffff88802f5f8618 (sb_internal#2){.+.+}-{0:0}, at: xfs_trans_alloc_inode+0x13c/0x4a0 fs/xfs/xfs_trans.c:1098
 #3: ffff88804fa20118 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_trans_alloc_inode+0x161/0x4a0 fs/xfs/xfs_trans.c:1104
4 locks held by syz.8.287/8943:
 #0: ffff8880310d6428 (sb_writers#12){.+.+}-{0:0}, at: mnt_want_write+0x41/0x90 fs/namespace.c:557
 #1: ffff88804fac0330 (&sb->s_type->i_mutex_key#20){++++}-{4:4}, at: inode_lock include/linux/fs.h:869 [inline]
 #1: ffff88804fac0330 (&sb->s_type->i_mutex_key#20){++++}-{4:4}, at: vfs_setxattr+0x144/0x2f0 fs/xattr.c:320
 #2: ffff8880310d6618 (sb_internal#2){.+.+}-{0:0}, at: xfs_trans_alloc_inode+0x13c/0x4a0 fs/xfs/xfs_trans.c:1098
 #3: ffff88804fac0118 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_trans_alloc_inode+0x161/0x4a0 fs/xfs/xfs_trans.c:1104
5 locks held by syz-executor/9036:
 #0: ffff88807b534428 (sb_writers#9){.+.+}-{0:0}, at: file_start_write include/linux/fs.h:3096 [inline]
 #0: ffff88807b534428 (sb_writers#9){.+.+}-{0:0}, at: vfs_write+0x211/0xa90 fs/read_write.c:682
 #1: ffff88804f649088 (&of->mutex){+.+.}-{4:4}, at: kernfs_fop_write_iter+0x1e0/0x4f0 fs/kernfs/file.c:325
 #2: ffffffff8e176708 (cgroup_mutex){+.+.}-{4:4}, at: cgroup_lock include/linux/cgroup.h:387 [inline]
 #2: ffffffff8e176708 (cgroup_mutex){+.+.}-{4:4}, at: cgroup_kn_lock_live+0x13c/0x230 kernel/cgroup/cgroup.c:1686
 #3: ffffffff8dfd72d0 (cpu_hotplug_lock){++++}-{0:0}, at: cgroup_attach_lock kernel/cgroup/cgroup.c:2480 [inline]
 #3: ffffffff8dfd72d0 (cpu_hotplug_lock){++++}-{0:0}, at: cgroup_procs_write_start+0x186/0x610 kernel/cgroup/cgroup.c:2984
 #4: ffffffff8e1769b0 (cgroup_threadgroup_rwsem){++++}-{0:0}, at: cgroup_attach_lock kernel/cgroup/cgroup.c:2482 [inline]
 #4: ffffffff8e1769b0 (cgroup_threadgroup_rwsem){++++}-{0:0}, at: cgroup_procs_write_start+0x19c/0x610 kernel/cgroup/cgroup.c:2984
4 locks held by syz.1.340/9228:
 #0: ffff888030946428 (sb_writers#12){.+.+}-{0:0}, at: mnt_want_write+0x41/0x90 fs/namespace.c:557
 #1: ffff88804fa26fb0 (&sb->s_type->i_mutex_key#20){++++}-{4:4}, at: inode_lock include/linux/fs.h:869 [inline]
 #1: ffff88804fa26fb0 (&sb->s_type->i_mutex_key#20){++++}-{4:4}, at: vfs_setxattr+0x144/0x2f0 fs/xattr.c:320
 #2: ffff888030946618 (sb_internal#2){.+.+}-{0:0}, at: xfs_trans_alloc_inode+0x13c/0x4a0 fs/xfs/xfs_trans.c:1098
 #3: ffff88804fa26d98 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_trans_alloc_inode+0x161/0x4a0 fs/xfs/xfs_trans.c:1104
4 locks held by syz.2.347/9266:

=============================================

NMI backtrace for cpu 0
CPU: 0 UID: 0 PID: 31 Comm: khungtaskd Not tainted 6.16.0-rc5-syzkaller-00025-gd006330be3f7 #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/07/2025
Call Trace:
 <TASK>
 dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
 nmi_cpu_backtrace+0x39e/0x3d0 lib/nmi_backtrace.c:113
 nmi_trigger_cpumask_backtrace+0x17a/0x300 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:158 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:307 [inline]
 watchdog+0xfee/0x1030 kernel/hung_task.c:470
 kthread+0x711/0x8a0 kernel/kthread.c:464
 ret_from_fork+0x3fc/0x770 arch/x86/kernel/process.c:148
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
Sending NMI from CPU 0 to CPUs 1:
NMI backtrace for cpu 1
CPU: 1 UID: 0 PID: 9264 Comm: syz.5.346 Not tainted 6.16.0-rc5-syzkaller-00025-gd006330be3f7 #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/07/2025
RIP: 0010:hlock_class kernel/locking/lockdep.c:234 [inline]
RIP: 0010:check_wait_context kernel/locking/lockdep.c:4857 [inline]
RIP: 0010:__lock_acquire+0x332/0xd20 kernel/locking/lockdep.c:5190
Code: e5 15 09 d5 09 cd 44 09 f5 41 89 6c c7 20 45 89 44 c7 24 4c 89 7c 24 10 4d 8d 34 c7 81 e5 ff 1f 00 00 48 0f a3 2d 3e ce 09 12 <73> 10 48 69 c5 c8 00 00 00 48 8d 80 f0 02 49 93 eb 40 83 3d 85 5d
RSP: 0018:ffffc90004d8f028 EFLAGS: 00000003
RAX: 0000000000000000 RBX: ffffffff8e13f160 RCX: 0000000000000007
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff888048581e00
RBP: 0000000000000007 R08: 0000000000000000 R09: ffffffff81729ae5
R10: dffffc0000000000 R11: ffffffff81acf330 R12: 0000000000020000
R13: 0000000000000000 R14: ffff8880485828f0 R15: ffff8880485828f0
FS:  00007fec077e56c0(0000) GS:ffff888125d1b000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f83ec5b7bac CR3: 00000000489aa000 CR4: 0000000000350ef0
Call Trace:
 <TASK>
 lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5871
 rcu_lock_acquire include/linux/rcupdate.h:331 [inline]
 rcu_read_lock include/linux/rcupdate.h:841 [inline]
 class_rcu_constructor include/linux/rcupdate.h:1155 [inline]
 unwind_next_frame+0xc2/0x2390 arch/x86/kernel/unwind_orc.c:479
 arch_stack_walk+0x11c/0x150 arch/x86/kernel/stacktrace.c:25
 stack_trace_save+0x9c/0xe0 kernel/stacktrace.c:122
 save_stack+0xf5/0x1f0 mm/page_owner.c:156
 __reset_page_owner+0x71/0x1f0 mm/page_owner.c:308
 reset_page_owner include/linux/page_owner.h:25 [inline]
 free_pages_prepare mm/page_alloc.c:1248 [inline]
 free_unref_folios+0xc66/0x14d0 mm/page_alloc.c:2763
 folios_put_refs+0x559/0x640 mm/swap.c:992
 folio_batch_release include/linux/pagevec.h:101 [inline]
 shmem_undo_range+0x49e/0x14b0 mm/shmem.c:1125
 shmem_truncate_range mm/shmem.c:1237 [inline]
 shmem_evict_inode+0x272/0xa70 mm/shmem.c:1365
 evict+0x504/0x9c0 fs/inode.c:810
 __dentry_kill+0x209/0x660 fs/dcache.c:669
 dput+0x19f/0x2b0 fs/dcache.c:911
 __fput+0x68e/0xa70 fs/file_table.c:473
 fput_close_sync+0x119/0x200 fs/file_table.c:570
 __do_sys_close fs/open.c:1589 [inline]
 __se_sys_close fs/open.c:1574 [inline]
 __x64_sys_close+0x7f/0x110 fs/open.c:1574
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fec0698d58a
Code: 48 3d 00 f0 ff ff 77 48 c3 0f 1f 80 00 00 00 00 48 83 ec 18 89 7c 24 0c e8 43 91 02 00 8b 7c 24 0c 89 c2 b8 03 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 36 89 d7 89 44 24 0c e8 a3 91 02 00 8b 44 24
RSP: 002b:00007fec077e4e00 EFLAGS: 00000293 ORIG_RAX: 0000000000000003
RAX: ffffffffffffffda RBX: 00000000ffffffff RCX: 00007fec0698d58a
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000003
RBP: 0000000000000010 R08: 0000000000000000 R09: 000000000000985e
R10: 0000000000000000 R11: 0000000000000293 R12: 0000000000000003
R13: 00007fec077e4ef0 R14: 00007fec077e4eb0 R15: 00007febfd600000
 </TASK>


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
