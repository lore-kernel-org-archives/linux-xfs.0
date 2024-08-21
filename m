Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1785515FCED
	for <linux-xfs@vger.kernel.org>; Wed, 21 Aug 2024 05:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724217628; cv=none; b=VsjC8SiNvxSN7A4Nn15eCAFInhQuJCZmwsrYXt8aJ3AMG2tGprZyCDhMyeFF5+0adVqt+Pw8VInnCd0fnxfiH8MllEWsCgaqtE6HmrXqFjWCLcR9ydPS3kMxaDdxGxnDva0tE27bZ0q5T3GNge69ZdXzRYlY4tY9FoXFYgcJ5go=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724217628; c=relaxed/simple;
	bh=hbhcPm8LjZJszcwUqY6TyjhqoDXTCf668Qwo8FwjkPo=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=kBGZQbSU27BgJ4NuBH7aHqIz6k7G9tCaWqycXh3gotcNyeWTc0ayRVfhUQKItPzG2VcaEN7efitObdb8DcIWYzIJIiMUZ68/83Gjazn3EoTKZ5qq8tpZ1LbMYKExaf3Nfbnz1ip4RYilt1weqWrlLZ/V4tPR+zsQ1G6HMOxg+qc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-81f8e43f0c1so640818139f.3
        for <linux-xfs@vger.kernel.org>; Tue, 20 Aug 2024 22:20:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724217625; x=1724822425;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=21ey6o6g/C3DG6+CR6J81L1oUdiXgkPZzrt+NhqAiDI=;
        b=sgvTPyCzgoE08bHSSi184vtRWkUc0xzPMBG9eUeaQvZjimltgFrmIYrY3JDj5Q4dTs
         KDz/ajJJ0rkFMGPdsw2HM5rZq6i9BHYDDZGHnMn/8rgPVCp8INBXsTfsatYnU5klZ7RB
         cHXgeOB/K7YHhVmbrlRtqDSMpb63sxitk49JPbtsi/6xCXDauxfKI9fExIAH3olzK4nW
         uzi92lj6yVSmwZ4ZdMJOG09ZBQcx6kNQ3+2XzHzTyDdmmG6B7xbEGEewO6yxQMPqv8Ln
         8NDjcvo2XRLrp51557UXpk+TraLmCMWQtxD2Te1fqV4kvgVrvpuGxdSNVziNnoYNCe3j
         OQjQ==
X-Forwarded-Encrypted: i=1; AJvYcCWypInbpVlvPRSTM70+P23DKCGjjsE1N2mklf3MWIDGU1FBVI6RVTmrGSybNwVhlGicPg+KUufBrW8=@vger.kernel.org
X-Gm-Message-State: AOJu0YzfQTYRtQUFPwZuMwzf+xCap+Mh0NbDVFbEV9TgUaxE8owK2YjT
	QJ4CStP4wOu7xs0F42GWTmMqpESI3N3SViLRAI2qZvaeY+9Oy+k/zsBQyBVG290a+p4sEJ7e5Rx
	0yf3YaKAgyNT+mzOXjdPsYZ4yfOQ+rabgahsgXJVZF4JOE/+a3l7zgDo=
X-Google-Smtp-Source: AGHT+IFkVQAqx0NSRy7AfF2SnuY8SJDzvlpBf95xDF+LWLWEMelLhzTEi4hO4T+uDIRIPar52FCrqYNKWID4ruZSWvptINFIBhAZ
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:2149:b0:397:fa4e:3df0 with SMTP id
 e9e14a558f8ab-39d6c3c1023mr1044525ab.3.1724217625065; Tue, 20 Aug 2024
 22:20:25 -0700 (PDT)
Date: Tue, 20 Aug 2024 22:20:25 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000000ecbd306202ab365@google.com>
Subject: [syzbot] [xfs?] possible deadlock in xfs_fs_dirty_inode (2)
From: syzbot <syzbot+1116a7b7b96b9c426a1a@syzkaller.appspotmail.com>
To: chandan.babu@oracle.com, djwong@kernel.org, linux-kernel@vger.kernel.org, 
	linux-xfs@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    47ac09b91bef Linux 6.11-rc4
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=11770de5980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=df2f0ed7e30a639d
dashboard link: https://syzkaller.appspot.com/bug?extid=1116a7b7b96b9c426a1a
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7bc7510fe41f/non_bootable_disk-47ac09b9.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/6db2a1c6b666/vmlinux-47ac09b9.xz
kernel image: https://storage.googleapis.com/syzbot-assets/b1c782255526/bzImage-47ac09b9.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+1116a7b7b96b9c426a1a@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
6.11.0-rc4-syzkaller #0 Not tainted
------------------------------------------------------
kswapd0/80 is trying to acquire lock:
ffff888038052610 (sb_internal#2){.+.+}-{0:0}, at: xfs_fs_dirty_inode+0x158/0x250 fs/xfs/xfs_super.c:691

but task is already holding lock:
ffffffff8ea2fd20 (fs_reclaim){+.+.}-{0:0}, at: balance_pgdat mm/vmscan.c:6841 [inline]
ffffffff8ea2fd20 (fs_reclaim){+.+.}-{0:0}, at: kswapd+0xbb4/0x35a0 mm/vmscan.c:7223

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #2 (fs_reclaim){+.+.}-{0:0}:
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

-> #1 (&xfs_nondir_ilock_class#3){++++}-{3:3}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5759
       down_write_nested+0xa2/0x220 kernel/locking/rwsem.c:1695
       xfs_fs_dirty_inode+0x18d/0x250 fs/xfs/xfs_super.c:693
       __mark_inode_dirty+0x325/0xe20 fs/fs-writeback.c:2486
       generic_update_time+0xb0/0xc0 fs/inode.c:2004
       xfs_vn_update_time+0x2a5/0x600 fs/xfs/xfs_iops.c:1085
       inode_update_time fs/inode.c:2016 [inline]
       __file_update_time fs/inode.c:2206 [inline]
       file_modified_flags+0x38a/0x4e0 fs/inode.c:2277
       xfs_file_write_checks+0x7f2/0x9b0 fs/xfs/xfs_file.c:461
       xfs_file_buffered_write+0x215/0xad0 fs/xfs/xfs_file.c:757
       __kernel_write_iter+0x40d/0x900 fs/read_write.c:523
       __kernel_write+0x120/0x180 fs/read_write.c:543
       __dump_emit+0x237/0x360 fs/coredump.c:816
       elf_core_dump+0x31d0/0x4720 fs/binfmt_elf.c:2068
       do_coredump+0x1b04/0x2a30 fs/coredump.c:767
       get_signal+0x13fa/0x1740 kernel/signal.c:2902
       arch_do_signal_or_restart+0x96/0x860 arch/x86/kernel/signal.c:310
       exit_to_user_mode_loop kernel/entry/common.c:111 [inline]
       exit_to_user_mode_prepare include/linux/entry-common.h:328 [inline]
       irqentry_exit_to_user_mode+0x79/0x280 kernel/entry/common.c:231
       exc_page_fault+0x590/0x8c0 arch/x86/mm/fault.c:1542
       asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:623

-> #0 (sb_internal#2){.+.+}-{0:0}:
       check_prev_add kernel/locking/lockdep.c:3133 [inline]
       check_prevs_add kernel/locking/lockdep.c:3252 [inline]
       validate_chain+0x18e0/0x5900 kernel/locking/lockdep.c:3868
       __lock_acquire+0x137a/0x2040 kernel/locking/lockdep.c:5142
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5759
       percpu_down_read include/linux/percpu-rwsem.h:51 [inline]
       __sb_start_write include/linux/fs.h:1675 [inline]
       sb_start_intwrite include/linux/fs.h:1858 [inline]
       xfs_trans_alloc+0xe5/0x830 fs/xfs/xfs_trans.c:264
       xfs_fs_dirty_inode+0x158/0x250 fs/xfs/xfs_super.c:691
       __mark_inode_dirty+0x325/0xe20 fs/fs-writeback.c:2486
       mark_inode_dirty_sync include/linux/fs.h:2436 [inline]
       iput+0x1fe/0x930 fs/inode.c:1861
       __dentry_kill+0x20d/0x630 fs/dcache.c:610
       shrink_kill+0xa9/0x2c0 fs/dcache.c:1055
       shrink_dentry_list+0x2c0/0x5b0 fs/dcache.c:1082
       prune_dcache_sb+0x10f/0x180 fs/dcache.c:1163
       super_cache_scan+0x34f/0x4b0 fs/super.c:221
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

other info that might help us debug this:

Chain exists of:
  sb_internal#2 --> &xfs_nondir_ilock_class#3 --> fs_reclaim

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(fs_reclaim);
                               lock(&xfs_nondir_ilock_class#3);
                               lock(fs_reclaim);
  rlock(sb_internal#2);

 *** DEADLOCK ***

2 locks held by kswapd0/80:
 #0: ffffffff8ea2fd20 (fs_reclaim){+.+.}-{0:0}, at: balance_pgdat mm/vmscan.c:6841 [inline]
 #0: ffffffff8ea2fd20 (fs_reclaim){+.+.}-{0:0}, at: kswapd+0xbb4/0x35a0 mm/vmscan.c:7223
 #1: ffff8880380520e0 (&type->s_umount_key#48){.+.+}-{3:3}, at: super_trylock_shared fs/super.c:562 [inline]
 #1: ffff8880380520e0 (&type->s_umount_key#48){.+.+}-{3:3}, at: super_cache_scan+0x94/0x4b0 fs/super.c:196

stack backtrace:
CPU: 0 UID: 0 PID: 80 Comm: kswapd0 Not tainted 6.11.0-rc4-syzkaller #0
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
 percpu_down_read include/linux/percpu-rwsem.h:51 [inline]
 __sb_start_write include/linux/fs.h:1675 [inline]
 sb_start_intwrite include/linux/fs.h:1858 [inline]
 xfs_trans_alloc+0xe5/0x830 fs/xfs/xfs_trans.c:264
 xfs_fs_dirty_inode+0x158/0x250 fs/xfs/xfs_super.c:691
 __mark_inode_dirty+0x325/0xe20 fs/fs-writeback.c:2486
 mark_inode_dirty_sync include/linux/fs.h:2436 [inline]
 iput+0x1fe/0x930 fs/inode.c:1861
 __dentry_kill+0x20d/0x630 fs/dcache.c:610
 shrink_kill+0xa9/0x2c0 fs/dcache.c:1055
 shrink_dentry_list+0x2c0/0x5b0 fs/dcache.c:1082
 prune_dcache_sb+0x10f/0x180 fs/dcache.c:1163
 super_cache_scan+0x34f/0x4b0 fs/super.c:221
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
