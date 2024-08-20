Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17DB81AE051
	for <linux-xfs@vger.kernel.org>; Tue, 20 Aug 2024 15:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724167601; cv=none; b=TlJgQhY7GPgMQicmOmvtjI04tLUs8axF3lRtWQfH+cErYWwzbEcydVzC3WaI3Eg2dQZ6ZMssfEA+IXmXbmZtSCX3VfiB5doaQxYlowXKTb73qzW5RprCDX8GYXpg8/bgStdioLzMBA9T+AY1a4MnHHgUEpYcvd4vt5VJJCPq8kk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724167601; c=relaxed/simple;
	bh=RPfAMPU7jA4e1Li2/71oX72b2qwlEv7wP7r6GJryg74=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=j7KthbFxV9kBHpS8+clsKZkBneLJChOzHoqNwEjXYBPGao/fT8aJv4sFR+z+UWRYb5udjregCxCU2wS0vWEjwZLDPYuh2DD2WzGEJQPGoNiSfVa9O2zjRu0Y2lhj6203gl3G+S+7l14uAl4vHFIVmlEmfQ8IG/NqdyKQDr64y1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-39d4c656946so27131575ab.1
        for <linux-xfs@vger.kernel.org>; Tue, 20 Aug 2024 08:26:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724167599; x=1724772399;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ISprvdNPbjaztkIEAe3Hz2DMB21oUDV+W+bCaUcXfpY=;
        b=vBJVTGZ+ZkvK+0sV1iYQbIojZNzt5WTYgPG7P7SJ57PU7tcsqkNF7gQGvOEsFKPQim
         IZNN/E0DUGZKzZt3ts1lncbmvaWpSL+UecH4s5bw0FjC1bJu+hh9wPKS18D14ODCqVLp
         qonr+n4HnvvT+y5TvtCF4ltz9J8OkUpDmN1w70lzlFidVK3k3JXBsbMwGqr/0jCbc8sQ
         7KeapBkFi99SwdiNJpUz2/+u5QKpNF4L64rjnsT3cOxy7YA8BBD4cP/7Iig0zViJvLBk
         63E1RZUR8XTCnBHC9DClqmpTNkR3zvwSZm8Jocl8EhKBirPYZ8CGb36xemPeJ7iiyg3I
         d+AA==
X-Forwarded-Encrypted: i=1; AJvYcCV09Gbzpg7lfM7Ydxl91zsD8wT55xH2GKzWW6frwvUOdwUvO/X71IPbcObCLuyBrL/w5aov8tfk388=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz38D7OPcQwHqktuC8bBjDd1gEsNEOlcMvxblTmwsDU+jRFUbQJ
	Ouw2iyG/LFYdQbfu8sZM9XeMkW29wkyTN5y+NSvOV72845RMKaCFq1sYcx5knF3mEZ4P9+/477o
	ZgrHZKiyPMiHcWIj1emdS1QuUg33o3dY4SiCYheoy/rUhZV7VQuqdQ/I=
X-Google-Smtp-Source: AGHT+IGd96Qm98iIjghq498VpXCCebAx8Z78bITe54uldleod/mIi3miy8xLUtYvmqxZkFoAKq1s7AkT6Z6ts37al3SpgSydFJSD
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1fcf:b0:39a:eb81:ffa8 with SMTP id
 e9e14a558f8ab-39d26d9ccb0mr12081645ab.6.1724167599187; Tue, 20 Aug 2024
 08:26:39 -0700 (PDT)
Date: Tue, 20 Aug 2024 08:26:39 -0700
In-Reply-To: <00000000000015a57d0619152dcd@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000004879fa06201f0d1a@google.com>
Subject: Re: [syzbot] [xfs?] possible deadlock in xfs_ilock_attr_map_shared
From: syzbot <syzbot+069cc167ecbee6e3e91a@syzkaller.appspotmail.com>
To: chandan.babu@oracle.com, djwong@kernel.org, linux-kernel@vger.kernel.org, 
	linux-xfs@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    6e4436539ae1 Merge tag 'hid-for-linus-2024081901' of git:/..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=12dd1fbb980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=df2f0ed7e30a639d
dashboard link: https://syzkaller.appspot.com/bug?extid=069cc167ecbee6e3e91a
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1185c36b980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10eeb18d980000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7bc7510fe41f/non_bootable_disk-6e443653.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/f8f042b8e130/vmlinux-6e443653.xz
kernel image: https://storage.googleapis.com/syzbot-assets/e6b9114bca1c/bzImage-6e443653.xz
mounted in repro #1: https://storage.googleapis.com/syzbot-assets/e9ff84da5f8a/mount_0.gz
mounted in repro #2: https://storage.googleapis.com/syzbot-assets/69040d7decca/mount_7.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+069cc167ecbee6e3e91a@syzkaller.appspotmail.com

XFS (loop0): Ending clean mount
XFS (loop0): Quotacheck needed: Please wait.
XFS (loop0): Quotacheck: Done.
======================================================
WARNING: possible circular locking dependency detected
6.11.0-rc4-syzkaller-00008-g6e4436539ae1 #0 Not tainted
------------------------------------------------------
syz-executor253/5095 is trying to acquire lock:
ffffffff8ea2fd60 (fs_reclaim){+.+.}-{0:0}, at: might_alloc include/linux/sched/mm.h:334 [inline]
ffffffff8ea2fd60 (fs_reclaim){+.+.}-{0:0}, at: slab_pre_alloc_hook mm/slub.c:3939 [inline]
ffffffff8ea2fd60 (fs_reclaim){+.+.}-{0:0}, at: slab_alloc_node mm/slub.c:4017 [inline]
ffffffff8ea2fd60 (fs_reclaim){+.+.}-{0:0}, at: __do_kmalloc_node mm/slub.c:4157 [inline]
ffffffff8ea2fd60 (fs_reclaim){+.+.}-{0:0}, at: __kmalloc_noprof+0xa9/0x400 mm/slub.c:4170

but task is already holding lock:
ffff88801df8d858 (&xfs_dir_ilock_class){++++}-{3:3}, at: xfs_ilock_attr_map_shared+0x8c/0xc0 fs/xfs/xfs_inode.c:84

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (&xfs_dir_ilock_class){++++}-{3:3}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5759
       down_write_nested+0xa2/0x220 kernel/locking/rwsem.c:1695
       xfs_reclaim_inode fs/xfs/xfs_icache.c:944 [inline]
       xfs_icwalk_process_inode fs/xfs/xfs_icache.c:1630 [inline]
       xfs_icwalk_ag+0x120e/0x1ad0 fs/xfs/xfs_icache.c:1712
       xfs_icwalk fs/xfs/xfs_icache.c:1761 [inline]
       xfs_reclaim_inodes_nr+0x2d4/0x3e0 fs/xfs/xfs_icache.c:1010
       super_cache_scan+0x40f/0x4b0 fs/super.c:227
       do_shrink_slab+0x701/0x1160 mm/shrinker.c:435
       shrink_slab+0x1093/0x14d0 mm/shrinker.c:662
       shrink_one+0x43b/0x850 mm/vmscan.c:4815
       shrink_many mm/vmscan.c:4876 [inline]
       lru_gen_shrink_node mm/vmscan.c:4954 [inline]
       shrink_node+0x3799/0x3de0 mm/vmscan.c:5934
       kswapd_shrink_node mm/vmscan.c:6762 [inline]
       balance_pgdat mm/vmscan.c:6954 [inline]
       kswapd+0x1bcd/0x35a0 mm/vmscan.c:7223
       kthread+0x2f0/0x390 kernel/kthread.c:389
       ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

-> #0 (fs_reclaim){+.+.}-{0:0}:
       check_prev_add kernel/locking/lockdep.c:3133 [inline]
       check_prevs_add kernel/locking/lockdep.c:3252 [inline]
       validate_chain+0x18e0/0x5900 kernel/locking/lockdep.c:3868
       __lock_acquire+0x137a/0x2040 kernel/locking/lockdep.c:5142
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5759
       __fs_reclaim_acquire mm/page_alloc.c:3818 [inline]
       fs_reclaim_acquire+0x88/0x140 mm/page_alloc.c:3832
       might_alloc include/linux/sched/mm.h:334 [inline]
       slab_pre_alloc_hook mm/slub.c:3939 [inline]
       slab_alloc_node mm/slub.c:4017 [inline]
       __do_kmalloc_node mm/slub.c:4157 [inline]
       __kmalloc_noprof+0xa9/0x400 mm/slub.c:4170
       kmalloc_noprof include/linux/slab.h:685 [inline]
       xfs_attr_shortform_list+0x753/0x1900 fs/xfs/xfs_attr_list.c:117
       xfs_attr_list+0x1d0/0x270 fs/xfs/xfs_attr_list.c:595
       xfs_vn_listxattr+0x1d2/0x2c0 fs/xfs/xfs_xattr.c:341
       vfs_listxattr fs/xattr.c:493 [inline]
       listxattr+0x107/0x290 fs/xattr.c:841
       path_listxattr fs/xattr.c:865 [inline]
       __do_sys_listxattr fs/xattr.c:877 [inline]
       __se_sys_listxattr fs/xattr.c:874 [inline]
       __x64_sys_listxattr+0x173/0x230 fs/xattr.c:874
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
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

1 lock held by syz-executor253/5095:
 #0: ffff88801df8d858 (&xfs_dir_ilock_class){++++}-{3:3}, at: xfs_ilock_attr_map_shared+0x8c/0xc0 fs/xfs/xfs_inode.c:84

stack backtrace:
CPU: 0 UID: 0 PID: 5095 Comm: syz-executor253 Not tainted 6.11.0-rc4-syzkaller-00008-g6e4436539ae1 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:93 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:119
 check_noncircular+0x36a/0x4a0 kernel/locking/lockdep.c:2186
 check_prev_add kernel/locking/lockdep.c:3133 [inline]
 check_prevs_add kernel/locking/lockdep.c:3252 [inline]
 validate_chain+0x18e0/0x5900 kernel/locking/lockdep.c:3868
 __lock_acquire+0x137a/0x2040 kernel/locking/lockdep.c:5142
 lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5759
 __fs_reclaim_acquire mm/page_alloc.c:3818 [inline]
 fs_reclaim_acquire+0x88/0x140 mm/page_alloc.c:3832
 might_alloc include/linux/sched/mm.h:334 [inline]
 slab_pre_alloc_hook mm/slub.c:3939 [inline]
 slab_alloc_node mm/slub.c:4017 [inline]
 __do_kmalloc_node mm/slub.c:4157 [inline]
 __kmalloc_noprof+0xa9/0x400 mm/slub.c:4170
 kmalloc_noprof include/linux/slab.h:685 [inline]
 xfs_attr_shortform_list+0x753/0x1900 fs/xfs/xfs_attr_list.c:117
 xfs_attr_list+0x1d0/0x270 fs/xfs/xfs_attr_list.c:595
 xfs_vn_listxattr+0x1d2/0x2c0 fs/xfs/xfs_xattr.c:341
 vfs_listxattr fs/xattr.c:493 [inline]
 listxattr+0x107/0x290 fs/xattr.c:841
 path_listxattr fs/xattr.c:865 [inline]
 __do_sys_listxattr fs/xattr.c:877 [inline]
 __se_sys_listxattr fs/xattr.c:874 [inline]
 __x64_sys_listxattr+0x173/0x230 fs/xattr.c:874
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fc8d9067469
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 21 18 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffc1803c738 EFLAGS: 00000246 ORIG_RAX: 00000000000000c2
RAX: ffffffffffffffda RBX: 0030656c69662f2e RCX: 00007fc8d9067469
RDX: 0000000000000013 RSI: 0000000020000040 RDI: 0000000020000440
RBP: 0000000000000000 R08: 00007ffc1803c770 R09: 00007ffc1803c770
R10: 00007ffc1803c770 R11: 0000000000000246 R12: 0000000000000001
R13: 0000000000000000 R14: 431bde82d7b634db R15: 00007ffc1803c790
 </TASK>


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
