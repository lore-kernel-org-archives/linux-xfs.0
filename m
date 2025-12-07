Received: from mail-oo1-f78.google.com (mail-oo1-f78.google.com [209.85.161.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E56CA27FB1F
	for <linux-xfs@vger.kernel.org>; Sun,  7 Dec 2025 23:10:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765149027; cv=none; b=AyWpw6hunevrbNW/Y4Mua7QSZ4Hru9w4/rCalhqhYkTP8OGledTUMy+dXXOJnZdDJP4z4IoWyTlV+4Mhvf2GPciut2cwET5SSgZfsBNuK4HkTwLr1b9Wsdub4Pv0krhhA2lQrFbjNoJtAvptsHN4PQW21+VCQj7vLEl8sRlGrfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765149027; c=relaxed/simple;
	bh=xvA3wJ95ESkh/W15YX+tBpM8gaX4RiBVNA81d5Fq2fw=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=KKy2atf7MQbmEc/x+1UqjlnYHVVVNpnT+h/1j/uVoVogFwSYBCC9DpUsgb7up7bh/Vjb9xpfBGopxV1hyN7gYQw9zcS3a/9tVFkDx0bC1oXPW94sIVkD2bD7TxW+UT8g0e93c2yLJJuJoAgGVJ8qglXxpfj5FxGGTuK+/OQVkdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f78.google.com with SMTP id 006d021491bc7-65703b66ebfso6189087eaf.0
        for <linux-xfs@vger.kernel.org>; Sun, 07 Dec 2025 15:10:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765149025; x=1765753825;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=K3TjN1lC9PmJRJTbDliRzjd8s4GPl05Xk/bkbCNY3vs=;
        b=Ih9AKhlp1TMpDqUzvXRYSued089REWZSjjGPuADVuI7kIPdtKm/MRApwuO3Jloem+Z
         Rt7Ka+QfaYHpEXpqZdbIBOj3wGWvfBJ9MQ6OUxenQ3I7+MaisFTImVjBeBEQldda5Q1n
         Ece54BwJdyHw8WLerCxCnUBdo9qSDZf5SVtw5FXm5svW8CpkmVHwXyU4XyGX3s8tdKyJ
         POUwpFtV3U4xR4bwsIJ4baAnBS5bc7bNJqz6Hcy4SobiXVQ8koz+g3KDGH9wiZXpRGka
         SX87n6UyzMShSbU2gWZu5687r7FQTYPUwx441UmKcdhBpS42IInKpemIbF89gHLpPxO2
         CvYQ==
X-Forwarded-Encrypted: i=1; AJvYcCVOZpwjaANgs+MNMsfWr+A5I3lWhJ71hMA3yxSk5bw2SZ7Rd/wB7ewU46TAO23YJKpE2stagWWbx3M=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy/A4CEqMbIX8psSWa0n1/NgAS5tMHtNaeLRzB7e/s5BSCE5ilz
	IIWwm4JSV+WgQPQkFTRb1nzL4aIYWbrBjod6VfD8+z2fSr4T/A7zkUSDF118n1n5sM9Wx1YBNcC
	TSbN3jZCzHsYweQMhoqZKX4bFL9zNgbUt67JPLZIKchjYVOGKZIdH790nLPU=
X-Google-Smtp-Source: AGHT+IGMTGz9jBXDq0w61fme6YsRgDTkGhumkKCNU38mA0/bu/I8RAO/1fU3eNFGpchb9W9bkbDastoi76B78MoeLOMSkqGw4f7b
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a4a:bc90:0:b0:659:9a49:8e36 with SMTP id
 006d021491bc7-6599a49c3f6mr2280519eaf.40.1765149024993; Sun, 07 Dec 2025
 15:10:24 -0800 (PST)
Date: Sun, 07 Dec 2025 15:10:24 -0800
In-Reply-To: <693377bd.a70a0220.243dc6.0023.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69360960.a70a0220.38f243.006f.GAE@google.com>
Subject: Re: [syzbot] [xfs?] possible deadlock in xfs_buffered_write_iomap_begin
From: syzbot <syzbot+5f5f36a9ed0aadd614f3@syzkaller.appspotmail.com>
To: cem@kernel.org, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    37bb2e7217b0 Merge tag 'staging-6.19-rc1' of git://git.ker..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17992eb4580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=cf15a4b50e1152e3
dashboard link: https://syzkaller.appspot.com/bug?extid=5f5f36a9ed0aadd614f3
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=119ad21a580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10c96992580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-37bb2e72.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/81ecfc98ace2/vmlinux-37bb2e72.xz
kernel image: https://storage.googleapis.com/syzbot-assets/4e99cf6c2ce3/bzImage-37bb2e72.xz
mounted in repro #1: https://storage.googleapis.com/syzbot-assets/e65cf8e90d15/mount_1.gz
  fsck result: failed (log: https://syzkaller.appspot.com/x/fsck.log?x=11fce6c2580000)
mounted in repro #2: https://storage.googleapis.com/syzbot-assets/aa9270f8ef66/mount_5.gz
  fsck result: failed (log: https://syzkaller.appspot.com/x/fsck.log?x=11380a1a580000)
mounted in repro #3: https://storage.googleapis.com/syzbot-assets/a3fc66ae7424/mount_14.gz
  fsck result: failed (log: https://syzkaller.appspot.com/x/fsck.log?x=169ad21a580000)

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+5f5f36a9ed0aadd614f3@syzkaller.appspotmail.com

XFS (loop0): Ending clean mount
XFS (loop0): Quotacheck needed: Please wait.
XFS (loop0): Quotacheck: Done.
======================================================
WARNING: possible circular locking dependency detected
syzkaller #0 Not tainted
------------------------------------------------------
syz.0.17/5508 is trying to acquire lock:
ffffffff8e251780 (fs_reclaim){+.+.}-{0:0}, at: might_alloc include/linux/sched/mm.h:317 [inline]
ffffffff8e251780 (fs_reclaim){+.+.}-{0:0}, at: slab_pre_alloc_hook mm/slub.c:4899 [inline]
ffffffff8e251780 (fs_reclaim){+.+.}-{0:0}, at: slab_alloc_node mm/slub.c:5234 [inline]
ffffffff8e251780 (fs_reclaim){+.+.}-{0:0}, at: __kmalloc_cache_noprof+0x40/0x700 mm/slub.c:5766

but task is already holding lock:
ffff88804779d798 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_ilock_for_iomap fs/xfs/xfs_iomap.c:789 [inline]
ffff88804779d798 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_buffered_write_iomap_begin+0x4d1/0x1a70 fs/xfs/xfs_iomap.c:1793

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (&xfs_nondir_ilock_class){++++}-{4:4}:
       down_write_nested+0x9d/0x200 kernel/locking/rwsem.c:1706
       xfs_reclaim_inode fs/xfs/xfs_icache.c:1035 [inline]
       xfs_icwalk_process_inode fs/xfs/xfs_icache.c:1727 [inline]
       xfs_icwalk_ag+0x1229/0x1a90 fs/xfs/xfs_icache.c:1809
       xfs_icwalk fs/xfs/xfs_icache.c:1857 [inline]
       xfs_reclaim_inodes_nr+0x1e3/0x260 fs/xfs/xfs_icache.c:1101
       super_cache_scan+0x41b/0x4b0 fs/super.c:228
       do_shrink_slab+0x6df/0x10d0 mm/shrinker.c:437
       shrink_slab+0xd74/0x10d0 mm/shrinker.c:664
       shrink_one+0x2d9/0x720 mm/vmscan.c:4919
       shrink_many mm/vmscan.c:4980 [inline]
       lru_gen_shrink_node mm/vmscan.c:5058 [inline]
       shrink_node+0x2f7d/0x35b0 mm/vmscan.c:6045
       kswapd_shrink_node mm/vmscan.c:6899 [inline]
       balance_pgdat mm/vmscan.c:7082 [inline]
       kswapd+0x145a/0x2820 mm/vmscan.c:7352
       kthread+0x711/0x8a0 kernel/kthread.c:463
       ret_from_fork+0x599/0xb30 arch/x86/kernel/process.c:158
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:246

-> #0 (fs_reclaim){+.+.}-{0:0}:
       check_prev_add kernel/locking/lockdep.c:3165 [inline]
       check_prevs_add kernel/locking/lockdep.c:3284 [inline]
       validate_chain kernel/locking/lockdep.c:3908 [inline]
       __lock_acquire+0x15a6/0x2cf0 kernel/locking/lockdep.c:5237
       lock_acquire+0x117/0x340 kernel/locking/lockdep.c:5868
       __fs_reclaim_acquire mm/page_alloc.c:4301 [inline]
       fs_reclaim_acquire+0x72/0x100 mm/page_alloc.c:4315
       might_alloc include/linux/sched/mm.h:317 [inline]
       slab_pre_alloc_hook mm/slub.c:4899 [inline]
       slab_alloc_node mm/slub.c:5234 [inline]
       __kmalloc_cache_noprof+0x40/0x700 mm/slub.c:5766
       kmalloc_noprof include/linux/slab.h:957 [inline]
       iomap_fill_dirty_folios+0xf4/0x260 fs/iomap/buffered-io.c:1557
       xfs_buffered_write_iomap_begin+0xa23/0x1a70 fs/xfs/xfs_iomap.c:1857
       iomap_iter+0x5ef/0xeb0 fs/iomap/iter.c:110
       iomap_zero_range+0x1cc/0xa30 fs/iomap/buffered-io.c:1590
       xfs_zero_range+0x9a/0x100 fs/xfs/xfs_iomap.c:2289
       xfs_free_file_space+0x8ad/0xcc0 fs/xfs/xfs_bmap_util.c:900
       __xfs_file_fallocate+0x568/0x15f0 fs/xfs/xfs_file.c:1387
       xfs_file_fallocate+0x27b/0x340 fs/xfs/xfs_file.c:1462
       vfs_fallocate+0x669/0x7e0 fs/open.c:339
       ksys_fallocate fs/open.c:363 [inline]
       __do_sys_fallocate fs/open.c:368 [inline]
       __se_sys_fallocate fs/open.c:366 [inline]
       __x64_sys_fallocate+0xc0/0x110 fs/open.c:366
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0xfa/0xf80 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

other info that might help us debug this:

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&xfs_nondir_ilock_class);
                               lock(fs_reclaim);
                               lock(&xfs_nondir_ilock_class);
  lock(fs_reclaim);

 *** DEADLOCK ***

4 locks held by syz.0.17/5508:
 #0: ffff88803d5a2420 (sb_writers#13){.+.+}-{0:0}, at: file_start_write include/linux/fs.h:2681 [inline]
 #0: ffff88803d5a2420 (sb_writers#13){.+.+}-{0:0}, at: vfs_fallocate+0x5f0/0x7e0 fs/open.c:338
 #1: ffff88804779d9b0 (&sb->s_type->i_mutex_key#25){++++}-{4:4}, at: xfs_ilock+0xee/0x370 fs/xfs/xfs_inode.c:149
 #2: ffff88804779db50 (mapping.invalidate_lock#3){++++}-{4:4}, at: xfs_ilock+0x16c/0x370 fs/xfs/xfs_inode.c:157
 #3: ffff88804779d798 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_ilock_for_iomap fs/xfs/xfs_iomap.c:789 [inline]
 #3: ffff88804779d798 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_buffered_write_iomap_begin+0x4d1/0x1a70 fs/xfs/xfs_iomap.c:1793

stack backtrace:
CPU: 0 UID: 0 PID: 5508 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
 print_circular_bug+0x2e2/0x300 kernel/locking/lockdep.c:2043
 check_noncircular+0x12e/0x150 kernel/locking/lockdep.c:2175
 check_prev_add kernel/locking/lockdep.c:3165 [inline]
 check_prevs_add kernel/locking/lockdep.c:3284 [inline]
 validate_chain kernel/locking/lockdep.c:3908 [inline]
 __lock_acquire+0x15a6/0x2cf0 kernel/locking/lockdep.c:5237
 lock_acquire+0x117/0x340 kernel/locking/lockdep.c:5868
 __fs_reclaim_acquire mm/page_alloc.c:4301 [inline]
 fs_reclaim_acquire+0x72/0x100 mm/page_alloc.c:4315
 might_alloc include/linux/sched/mm.h:317 [inline]
 slab_pre_alloc_hook mm/slub.c:4899 [inline]
 slab_alloc_node mm/slub.c:5234 [inline]
 __kmalloc_cache_noprof+0x40/0x700 mm/slub.c:5766
 kmalloc_noprof include/linux/slab.h:957 [inline]
 iomap_fill_dirty_folios+0xf4/0x260 fs/iomap/buffered-io.c:1557
 xfs_buffered_write_iomap_begin+0xa23/0x1a70 fs/xfs/xfs_iomap.c:1857
 iomap_iter+0x5ef/0xeb0 fs/iomap/iter.c:110
 iomap_zero_range+0x1cc/0xa30 fs/iomap/buffered-io.c:1590
 xfs_zero_range+0x9a/0x100 fs/xfs/xfs_iomap.c:2289
 xfs_free_file_space+0x8ad/0xcc0 fs/xfs/xfs_bmap_util.c:900
 __xfs_file_fallocate+0x568/0x15f0 fs/xfs/xfs_file.c:1387
 xfs_file_fallocate+0x27b/0x340 fs/xfs/xfs_file.c:1462
 vfs_fallocate+0x669/0x7e0 fs/open.c:339
 ksys_fallocate fs/open.c:363 [inline]
 __do_sys_fallocate fs/open.c:368 [inline]
 __se_sys_fallocate fs/open.c:366 [inline]
 __x64_sys_fallocate+0xc0/0x110 fs/open.c:366
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fdf0878f7c9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fffb9feb238 EFLAGS: 00000246 ORIG_RAX: 000000000000011d
RAX: ffffffffffffffda RBX: 00007fdf089e5fa0 RCX: 00007fdf0878f7c9
RDX: 000000000000036e RSI: 0000000000000003 RDI: 0000000000000005
RBP: 00007fdf08813f91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000010000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fdf089e5fa0 R14: 00007fdf089e5fa0 R15: 0000000000000004
 </TASK>


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
