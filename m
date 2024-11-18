Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDF63146D6A
	for <linux-xfs@vger.kernel.org>; Mon, 18 Nov 2024 06:10:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731910227; cv=none; b=SrOY6KHJL1j2fimCvO1h1hw9LqKfqfU+VLsYJCpnI73g77B9TAZ2nKz5WXb1cONlRqMfJbx6etYNrdSMFEL2fkUD+Iy1wgwfA6iFlE0IaVfW/X9uGzLgkwGG3puVGIk1R+AEF67xpmrxJZSmqX0ES/8ZfaSPuMgPqBgj6zFqGYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731910227; c=relaxed/simple;
	bh=k41xpQpak0o3UxWeiK/hBruMxSnAsJCuhEVORVRG6a8=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=sK1zwKvH+oYnxRlA0iKlcS6ji0nqKXSQsBla/69pvDAVX9XddBzhLcijyCV/22XqDYKCQA8sEhnq5/Tiu6im3vK3X7NnbgWaPNSHx2vWSfYBOncrC09hJExiqx+RctojFqJQqoKVFF/YFlYk4ttjsMrbL6op5I4ms9WV7/x3G7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3a75dd4b1f3so11909715ab.1
        for <linux-xfs@vger.kernel.org>; Sun, 17 Nov 2024 22:10:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731910225; x=1732515025;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RgFEXeL5HW7zNvXmnwi2Z5n7swTsOKdXfoEvlu2V4iw=;
        b=fKlr/GK0k10aGQo87snust7GtHdmeE4uqW20GyOgJNAi6ssjpStGH4x9v0mjVqcsqn
         xQH7JaSfFwS2lWl4vg0oDx1O5Np3YNlVbHxMOYGAb/NSK68c94mFW6y+kRgHyfywgZjA
         1Ge/BBnfbdWYsVM2oOza7BTPoHd363bL3PbYjJI2nOM/JrXnC1cLV3Vt/g3iVQZFSjOD
         h6NhFZLl0wG/SVlg6yyE4mDrvSYfhrau9mxDxfUrTJXg2KlRe1hUh7o2XBpJBCeIBK4h
         Wd/4jSnhpXyCpPGVGJ95z68tDyAxHbPQfdkcTPz4k3V+DueQYxxYiilrnZCiDH5mWVIM
         C2Ew==
X-Forwarded-Encrypted: i=1; AJvYcCWCmmNam71kqVcRNJddhh2l7ClhHCf3/4OQP3pmjGamQhc/w5DLAFqxMGNGgKauuZRcvOHxwRdIjgI=@vger.kernel.org
X-Gm-Message-State: AOJu0YwSZqA6j8M31YPlEA3DGyFIruxG1Fgs5n9ic41HF+Xm3OP3ijU7
	OQwjHk0ep+BfLfakwspnpz2j7zIszvhjzPTyWTiH/euJwxKcj+VWMVgmt9nZtgXVoMak69uLpoi
	gbZVbhTdEg91LaNsAAXfMdWypJXch/v9g8HSPXIO2cgUsubdQOhOgFdc=
X-Google-Smtp-Source: AGHT+IGYH8gSTGwd2mCIuFF0OXuzoAsuHmAUIrK/uW22Sv+GKPxdw31ydeBykno2avs8NvMpMP41NKBxj/eY4PlvIbAQrHjnjqRf
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:188c:b0:3a7:4644:eebb with SMTP id
 e9e14a558f8ab-3a74808ea9cmr99363595ab.21.1731910224995; Sun, 17 Nov 2024
 22:10:24 -0800 (PST)
Date: Sun, 17 Nov 2024 22:10:24 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <673ada50.050a0220.87769.0022.GAE@google.com>
Subject: [syzbot] [xfs?] possible deadlock in xfs_ilock (3)
From: syzbot <syzbot+b143b25b374fbc5c3a04@syzkaller.appspotmail.com>
To: cem@kernel.org, chandan.babu@oracle.com, djwong@kernel.org, 
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    f1b785f4c787 Merge tag 'for_linus' of git://git.kernel.org..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1352c130580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c3a3896a92fb300b
dashboard link: https://syzkaller.appspot.com/bug?extid=b143b25b374fbc5c3a04
compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/3cdfef160cc2/disk-f1b785f4.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/f0f0ec3434aa/vmlinux-f1b785f4.xz
kernel image: https://storage.googleapis.com/syzbot-assets/6a901270f54d/bzImage-f1b785f4.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+b143b25b374fbc5c3a04@syzkaller.appspotmail.com

XFS (loop8): Mounting V5 Filesystem bfdc47fc-10d8-4eed-a562-11a831b3f791
XFS (loop8): Ending clean mount
======================================================
WARNING: possible circular locking dependency detected
6.12.0-rc7-syzkaller-00042-gf1b785f4c787 #0 Not tainted
------------------------------------------------------
syz.8.662/10149 is trying to acquire lock:
ffffffff8e347080 (fs_reclaim){+.+.}-{0:0}, at: might_alloc include/linux/sched/mm.h:318 [inline]
ffffffff8e347080 (fs_reclaim){+.+.}-{0:0}, at: slab_pre_alloc_hook mm/slub.c:4036 [inline]
ffffffff8e347080 (fs_reclaim){+.+.}-{0:0}, at: slab_alloc_node mm/slub.c:4114 [inline]
ffffffff8e347080 (fs_reclaim){+.+.}-{0:0}, at: __do_kmalloc_node mm/slub.c:4263 [inline]
ffffffff8e347080 (fs_reclaim){+.+.}-{0:0}, at: __kmalloc_noprof+0xb1/0x400 mm/slub.c:4276

but task is already holding lock:
ffff88805a939858 (&xfs_dir_ilock_class){++++}-{3:3}, at: xfs_ilock+0xf5/0x210 fs/xfs/xfs_inode.c:166

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (&xfs_dir_ilock_class){++++}-{3:3}:
       down_write_nested+0x97/0x210 kernel/locking/rwsem.c:1693
       xfs_ilock+0x198/0x210 fs/xfs/xfs_inode.c:164
       xfs_reclaim_inode fs/xfs/xfs_icache.c:981 [inline]
       xfs_icwalk_process_inode fs/xfs/xfs_icache.c:1675 [inline]
       xfs_icwalk_ag+0xca6/0x1780 fs/xfs/xfs_icache.c:1757
       xfs_icwalk fs/xfs/xfs_icache.c:1805 [inline]
       xfs_reclaim_inodes_nr+0x1bc/0x300 fs/xfs/xfs_icache.c:1047
       super_cache_scan+0x40c/0x550 fs/super.c:227
       do_shrink_slab+0x452/0x11c0 mm/shrinker.c:437
       shrink_slab+0x32b/0x12a0 mm/shrinker.c:664
       shrink_one+0x47e/0x7b0 mm/vmscan.c:4824
       shrink_many mm/vmscan.c:4885 [inline]
       lru_gen_shrink_node mm/vmscan.c:4963 [inline]
       shrink_node+0xb23/0x3a90 mm/vmscan.c:5943
       kswapd_shrink_node mm/vmscan.c:6771 [inline]
       balance_pgdat+0xc1f/0x18f0 mm/vmscan.c:6963
       kswapd+0x5ea/0xbf0 mm/vmscan.c:7232
       kthread+0x2c4/0x3a0 kernel/kthread.c:389
       ret_from_fork+0x48/0x80 arch/x86/kernel/process.c:147
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

-> #0 (fs_reclaim){+.+.}-{0:0}:
       check_prev_add kernel/locking/lockdep.c:3161 [inline]
       check_prevs_add kernel/locking/lockdep.c:3280 [inline]
       validate_chain kernel/locking/lockdep.c:3904 [inline]
       __lock_acquire+0x250b/0x3ce0 kernel/locking/lockdep.c:5202
       lock_acquire.part.0+0x11b/0x380 kernel/locking/lockdep.c:5825
       __fs_reclaim_acquire mm/page_alloc.c:3836 [inline]
       fs_reclaim_acquire+0x102/0x150 mm/page_alloc.c:3850
       might_alloc include/linux/sched/mm.h:318 [inline]
       slab_pre_alloc_hook mm/slub.c:4036 [inline]
       slab_alloc_node mm/slub.c:4114 [inline]
       __do_kmalloc_node mm/slub.c:4263 [inline]
       __kmalloc_noprof+0xb1/0x400 mm/slub.c:4276
       kmalloc_noprof include/linux/slab.h:882 [inline]
       xfs_attr_shortform_list fs/xfs/xfs_attr_list.c:117 [inline]
       xfs_attr_list_ilocked+0x9a0/0x1b00 fs/xfs/xfs_attr_list.c:569
       xfs_attr_list+0x1f9/0x2b0 fs/xfs/xfs_attr_list.c:595
       xfs_vn_listxattr+0x11f/0x1c0 fs/xfs/xfs_xattr.c:341
       vfs_listxattr+0xba/0x140 fs/xattr.c:493
       listxattr+0x69/0x190 fs/xattr.c:841
       path_listxattr+0xc0/0x160 fs/xattr.c:865
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xcd/0x250 arch/x86/entry/common.c:83
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

1 lock held by syz.8.662/10149:
 #0: ffff88805a939858 (&xfs_dir_ilock_class){++++}-{3:3}, at: xfs_ilock+0xf5/0x210 fs/xfs/xfs_inode.c:166

stack backtrace:
CPU: 1 UID: 0 PID: 10149 Comm: syz.8.662 Not tainted 6.12.0-rc7-syzkaller-00042-gf1b785f4c787 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/30/2024
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x116/0x1f0 lib/dump_stack.c:120
 print_circular_bug+0x41c/0x610 kernel/locking/lockdep.c:2074
 check_noncircular+0x31a/0x400 kernel/locking/lockdep.c:2206
 check_prev_add kernel/locking/lockdep.c:3161 [inline]
 check_prevs_add kernel/locking/lockdep.c:3280 [inline]
 validate_chain kernel/locking/lockdep.c:3904 [inline]
 __lock_acquire+0x250b/0x3ce0 kernel/locking/lockdep.c:5202
 lock_acquire.part.0+0x11b/0x380 kernel/locking/lockdep.c:5825
 __fs_reclaim_acquire mm/page_alloc.c:3836 [inline]
 fs_reclaim_acquire+0x102/0x150 mm/page_alloc.c:3850
 might_alloc include/linux/sched/mm.h:318 [inline]
 slab_pre_alloc_hook mm/slub.c:4036 [inline]
 slab_alloc_node mm/slub.c:4114 [inline]
 __do_kmalloc_node mm/slub.c:4263 [inline]
 __kmalloc_noprof+0xb1/0x400 mm/slub.c:4276
 kmalloc_noprof include/linux/slab.h:882 [inline]
 xfs_attr_shortform_list fs/xfs/xfs_attr_list.c:117 [inline]
 xfs_attr_list_ilocked+0x9a0/0x1b00 fs/xfs/xfs_attr_list.c:569
 xfs_attr_list+0x1f9/0x2b0 fs/xfs/xfs_attr_list.c:595
 xfs_vn_listxattr+0x11f/0x1c0 fs/xfs/xfs_xattr.c:341
 vfs_listxattr+0xba/0x140 fs/xattr.c:493
 listxattr+0x69/0x190 fs/xattr.c:841
 path_listxattr+0xc0/0x160 fs/xattr.c:865
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xcd/0x250 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f81fa37e719
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f81fb1cf038 EFLAGS: 00000246 ORIG_RAX: 00000000000000c2
RAX: ffffffffffffffda RBX: 00007f81fa535f80 RCX: 00007f81fa37e719
RDX: 0000000000000014 RSI: 0000000020000480 RDI: 0000000020000440
RBP: 00007f81fa3f175e R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 00007f81fa535f80 R15: 00007ffe5f9dc7d8
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
