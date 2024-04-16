Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0E9912A16E
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 12:02:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713268950; cv=none; b=M6FEjtpuHaSo/KHYGPt+3zY0Wtq2UFxQzTAeK3F/5V9QTRL9JxthvXPbRzDhaQ84KVA9YpK7y1Gs5ePZVMgDq0yIjyEKWhpAONdcMQOv8t0oUwGVjxIKV73PVi2p96NeTaMO9uj+0KX29QwIOkQLibMLnVNcfxvV+YGyduO1gUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713268950; c=relaxed/simple;
	bh=1C8QensAqDcvNf44zqn5EdvvsKL0UVn3tH+ErfAOl+M=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=nInC3tkqgZIhr8ZFODVSOw570q33PzuSasF0SRw0r5XD8bggU57z/7d5YmGWX1wixhzIz6QtOJ3WF6w8FiUbeVxs/4HV7BDfShQpx8cZOwhYXpQ4106XgGgvxefbVYNaITZ8pkiZhRot9GcPASM+2ap7z+AvTrz38hfWvdxBeoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-36a14031548so44652135ab.2
        for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 05:02:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713268945; x=1713873745;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RliH/lwwNQjo2LcJr03DjdCa5kWkv5xAiJHUNHgwVYw=;
        b=ZQsLuC5ZLzE/x5uLmlP9GPH3HaQcQr8yjf6gsjjvHA7zTCxbUSNTVjzQpLv7KneHZf
         82AfUFB23aKpRKaNHBircWH3iF30Egnfzq2PZc1mu3jkNxbQwgNWG0OOehv6rVfsn7z9
         3DrR4H6BH4bl3G15p3srcTh7YRIrhNX2Kuc2M5WUtOV+OqMweJs7hqqlEDnPe1w1uc7f
         B01CD/pzriytsL6iesUdwByrga4f/9fV7nRNf3D2sLMubdqq507lbh9XYpysR7W1KxN5
         7/qVdxwmR++CtfCQdF4xDVdunbcxkVwxB/BdqndwfZaGJehseuZGK1AfgRVRznOWdcDa
         w4CQ==
X-Forwarded-Encrypted: i=1; AJvYcCVlRXh0OYagtyZAUe8owYOCM99GX40F6b4csbRjWcDlNVUJtYCD5GpUVrjvJnxvnp/w7CrUsMK5/S4/z03JT4CI3eMJa/uwDfKE
X-Gm-Message-State: AOJu0Yzxk7N1JzQ/aeFkg1FQ1nLkgWaRxSUNh4LoKCq/fXdIYaczy/xy
	O8EObP4aIo9O1cte3mnFaTfD9dC0Gij3zIVnLaGER/QvG1DDZR2huzvfn2l5eG2ZLtVhZCBV7WF
	9wSikw+pPBRUDEb+rQfkeBYYzj8Pns35PL4Ifx7xXj0trX5W/Y5JKyvc=
X-Google-Smtp-Source: AGHT+IGPHdee8JjKHOeuBQgVBStbNj/c5ul3p6q9T2b8cyMj+j+acL2QyjWoUjWV1FqPD1NBTzOcmL94+78qDTWCLGtM5nTs7iPr
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:2199:b0:36a:3f1f:bd4e with SMTP id
 j25-20020a056e02219900b0036a3f1fbd4emr836028ila.5.1713268945260; Tue, 16 Apr
 2024 05:02:25 -0700 (PDT)
Date: Tue, 16 Apr 2024 05:02:25 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e33add0616358204@google.com>
Subject: [syzbot] [xfs?] possible deadlock in xfs_icwalk_ag (2)
From: syzbot <syzbot+4248e91deb3db78358a2@syzkaller.appspotmail.com>
To: chandan.babu@oracle.com, djwong@kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    9ed46da14b9b Add linux-next specific files for 20240412
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=100fbfcb180000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7ea0abc478c49859
dashboard link: https://syzkaller.appspot.com/bug?extid=4248e91deb3db78358a2
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/fc649744d68c/disk-9ed46da1.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/11eab7b9945d/vmlinux-9ed46da1.xz
kernel image: https://storage.googleapis.com/syzbot-assets/e7885afd198d/bzImage-9ed46da1.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+4248e91deb3db78358a2@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
6.9.0-rc3-next-20240412-syzkaller #0 Not tainted
------------------------------------------------------
kswapd0/88 is trying to acquire lock:
ffff88807b8bc6d8 (&xfs_dir_ilock_class){++++}-{3:3}, at: xfs_reclaim_inode fs/xfs/xfs_icache.c:945 [inline]
ffff88807b8bc6d8 (&xfs_dir_ilock_class){++++}-{3:3}, at: xfs_icwalk_process_inode fs/xfs/xfs_icache.c:1631 [inline]
ffff88807b8bc6d8 (&xfs_dir_ilock_class){++++}-{3:3}, at: xfs_icwalk_ag+0x120e/0x1ad0 fs/xfs/xfs_icache.c:1713

but task is already holding lock:
ffffffff8e429e80 (fs_reclaim){+.+.}-{0:0}, at: balance_pgdat mm/vmscan.c:6819 [inline]
ffffffff8e429e80 (fs_reclaim){+.+.}-{0:0}, at: kswapd+0xbe8/0x38a0 mm/vmscan.c:7201

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (fs_reclaim){+.+.}-{0:0}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5754
       __fs_reclaim_acquire mm/page_alloc.c:3825 [inline]
       fs_reclaim_acquire+0x88/0x140 mm/page_alloc.c:3839
       might_alloc include/linux/sched/mm.h:334 [inline]
       slab_pre_alloc_hook mm/slub.c:3847 [inline]
       slab_alloc_node mm/slub.c:3937 [inline]
       __do_kmalloc_node mm/slub.c:4077 [inline]
       __kmalloc_noprof+0xae/0x400 mm/slub.c:4091
       kmalloc_noprof include/linux/slab.h:664 [inline]
       xfs_attr_shortform_list+0x6f1/0x17b0 fs/xfs/xfs_attr_list.c:115
       xfs_attr_list_ilocked fs/xfs/xfs_attr_list.c:527 [inline]
       xfs_attr_list+0x25b/0x350 fs/xfs/xfs_attr_list.c:547
       xfs_vn_listxattr+0x1d2/0x2c0 fs/xfs/xfs_xattr.c:314
       vfs_listxattr fs/xattr.c:493 [inline]
       listxattr+0x107/0x290 fs/xattr.c:840
       path_listxattr fs/xattr.c:864 [inline]
       __do_sys_listxattr fs/xattr.c:876 [inline]
       __se_sys_listxattr fs/xattr.c:873 [inline]
       __x64_sys_listxattr+0x176/0x240 fs/xattr.c:873
       do_syscall_x64 arch/x86/entry/common.c:74 [inline]
       do_syscall_64+0xfa/0x250 arch/x86/entry/common.c:105
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #0 (&xfs_dir_ilock_class){++++}-{3:3}:
       check_prev_add kernel/locking/lockdep.c:3134 [inline]
       check_prevs_add kernel/locking/lockdep.c:3253 [inline]
       validate_chain+0x18cb/0x58e0 kernel/locking/lockdep.c:3869
       __lock_acquire+0x1346/0x1fd0 kernel/locking/lockdep.c:5137
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5754
       down_write_nested+0x3d/0x50 kernel/locking/rwsem.c:1695
       xfs_reclaim_inode fs/xfs/xfs_icache.c:945 [inline]
       xfs_icwalk_process_inode fs/xfs/xfs_icache.c:1631 [inline]
       xfs_icwalk_ag+0x120e/0x1ad0 fs/xfs/xfs_icache.c:1713
       xfs_icwalk fs/xfs/xfs_icache.c:1762 [inline]
       xfs_reclaim_inodes_nr+0x257/0x360 fs/xfs/xfs_icache.c:1011
       super_cache_scan+0x40f/0x4b0 fs/super.c:227
       do_shrink_slab+0x705/0x1160 mm/shrinker.c:435
       shrink_slab+0x1092/0x14d0 mm/shrinker.c:662
       shrink_one+0x453/0x880 mm/vmscan.c:4809
       shrink_many mm/vmscan.c:4870 [inline]
       lru_gen_shrink_node mm/vmscan.c:4970 [inline]
       shrink_node+0x3b17/0x4310 mm/vmscan.c:5929
       kswapd_shrink_node mm/vmscan.c:6741 [inline]
       balance_pgdat mm/vmscan.c:6932 [inline]
       kswapd+0x1882/0x38a0 mm/vmscan.c:7201
       kthread+0x2f0/0x390 kernel/kthread.c:389
       ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

other info that might help us debug this:

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(fs_reclaim);
                               lock(&xfs_dir_ilock_class);
                               lock(fs_reclaim);
  lock(&xfs_dir_ilock_class);

 *** DEADLOCK ***

2 locks held by kswapd0/88:
 #0: ffffffff8e429e80 (fs_reclaim){+.+.}-{0:0}, at: balance_pgdat mm/vmscan.c:6819 [inline]
 #0: ffffffff8e429e80 (fs_reclaim){+.+.}-{0:0}, at: kswapd+0xbe8/0x38a0 mm/vmscan.c:7201
 #1: ffff8880866840e0 (&type->s_umount_key#74){++++}-{3:3}, at: super_trylock_shared fs/super.c:561 [inline]
 #1: ffff8880866840e0 (&type->s_umount_key#74){++++}-{3:3}, at: super_cache_scan+0x94/0x4b0 fs/super.c:196

stack backtrace:
CPU: 1 PID: 88 Comm: kswapd0 Not tainted 6.9.0-rc3-next-20240412-syzkaller #0
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
 down_write_nested+0x3d/0x50 kernel/locking/rwsem.c:1695
 xfs_reclaim_inode fs/xfs/xfs_icache.c:945 [inline]
 xfs_icwalk_process_inode fs/xfs/xfs_icache.c:1631 [inline]
 xfs_icwalk_ag+0x120e/0x1ad0 fs/xfs/xfs_icache.c:1713
 xfs_icwalk fs/xfs/xfs_icache.c:1762 [inline]
 xfs_reclaim_inodes_nr+0x257/0x360 fs/xfs/xfs_icache.c:1011
 super_cache_scan+0x40f/0x4b0 fs/super.c:227
 do_shrink_slab+0x705/0x1160 mm/shrinker.c:435
 shrink_slab+0x1092/0x14d0 mm/shrinker.c:662
 shrink_one+0x453/0x880 mm/vmscan.c:4809
 shrink_many mm/vmscan.c:4870 [inline]
 lru_gen_shrink_node mm/vmscan.c:4970 [inline]
 shrink_node+0x3b17/0x4310 mm/vmscan.c:5929
 kswapd_shrink_node mm/vmscan.c:6741 [inline]
 balance_pgdat mm/vmscan.c:6932 [inline]
 kswapd+0x1882/0x38a0 mm/vmscan.c:7201
 kthread+0x2f0/0x390 kernel/kthread.c:389
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
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
