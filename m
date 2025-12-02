Received: from mail-ot1-f78.google.com (mail-ot1-f78.google.com [209.85.210.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD478204F93
	for <linux-xfs@vger.kernel.org>; Tue,  2 Dec 2025 03:35:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764646531; cv=none; b=leS9Wmw+wPuy50DTMI20WZgsmrqGFfOBv8UFz+fkLUtBbsCYrkJFxIpLchdPIf5Vw0SZAxeMLnbLoYfLk1QnnyvGi56g25jCG9P/Ugir+IwlXHacn+0XFWYlSARz6d5koWOMxany9eRXy+b9KJdu8HvTP4JMk+CGathYBtQ3Sb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764646531; c=relaxed/simple;
	bh=RBi9PlC/yze8bexCz5w4b1qxsQHrmhHyVesm6S1cATU=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=BpdfLYKV4Qcpzr9RHp/ox3L5nyeyJjKVcxx8KLchmX4EVUzdkIhpGRHsTVyEANnaRjIibTq1ZspDv3p14fk6/5T3j2baTJwvhwP167hiPXZgTffTUKyYXmQTd7O8WOUmt2+5wNvfxViSVjVex1yHRxPlMALu6VC/whZqeFNfSDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f78.google.com with SMTP id 46e09a7af769-7c7032a5b40so2743925a34.1
        for <linux-xfs@vger.kernel.org>; Mon, 01 Dec 2025 19:35:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764646529; x=1765251329;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SV+0NUc6KYNRknUnk0JMkJ2cQCE2CIACaMUraNFuewk=;
        b=YAPmb5TiGSDgOgb6fV7opQTxtEPXvytHlzpsG0ArL4rGjMe0Y7f5C5xyaAcnWUtKth
         Jcwaq4Tl/DgJ6MYo011e2IygP7RFJ9dpkrOCMecaqCRyTaJOpoM6lRjw91QLLfDUnYa+
         nP7IizM5SnkpuhqrdfoLXTzqHJKd+AUVfYgFuZMcgtqIlhzOl1yUzjUAaq5z6RihXshf
         Ayjg0b1YeJ6bStgCuGHQ8uTheGTyEjNHd8ipgt7tQzqefo7W95F3ZfVYwgfjVg6Jdl/b
         qseZjU+uEFdoTDHY3GNOZU8OKJHZgHT4LzkPa/Clc7+6wbzq5t2k0c7UFNaI4bpXttID
         bA7Q==
X-Forwarded-Encrypted: i=1; AJvYcCWHiaEpqJW39hWHn83woRSdbOrvsz7u1BhgF8II7/9h8F+WF+r13UYijOA6DCuq27/qj4Ym75hlSq8=@vger.kernel.org
X-Gm-Message-State: AOJu0YzBE4hSndEwHUeBpaMhLW9klsQGTaf0onG27r8qmJNxtuKuukES
	68x2Zscwe5NQvceC4iFeV5i6+26sSniCBsgEfiv+rKPKczEcR2O5zzdyRNg9UC9tOTyFHUxhLM+
	e3Xl5hwFUuEDbTzGgkf7GyRAe89qD+RJOx9mhRgKDlYAHe/zWYk0+LbcYzzA=
X-Google-Smtp-Source: AGHT+IGhlk8rLUpX7k25k9Lw7ZjJQC4w6OTHgju8dQxy1Auh1CRCgV36cDXsYKtm7EV8RHncKwcHfTJ3Bv6TqTOTl56Q3eJdElb0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:3094:b0:44d:ae36:dd86 with SMTP id
 5614622812f47-45115b3cb56mr16027752b6e.59.1764646529024; Mon, 01 Dec 2025
 19:35:29 -0800 (PST)
Date: Mon, 01 Dec 2025 19:35:29 -0800
In-Reply-To: <689a0c9f.050a0220.51d73.009e.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <692e5e81.a70a0220.2ea503.00bf.GAE@google.com>
Subject: Re: [syzbot] [xfs?] possible deadlock in xfs_icwalk_ag (3)
From: syzbot <syzbot+789028412a4af61a2b61@syzkaller.appspotmail.com>
To: cem@kernel.org, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	mmpgouride@gmail.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    1d18101a644e Merge tag 'kernel-6.19-rc1.cred' of git://git..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=13d1a192580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a1db0fea040c2a9f
dashboard link: https://syzkaller.appspot.com/bug?extid=789028412a4af61a2b61
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10ae38c2580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17606512580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-1d18101a.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/98f78b52cccd/vmlinux-1d18101a.xz
kernel image: https://storage.googleapis.com/syzbot-assets/7a8898061bfb/bzImage-1d18101a.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/28373feef258/mount_0.gz
  fsck result: failed (log: https://syzkaller.appspot.com/x/fsck.log?x=172e38c2580000)

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+789028412a4af61a2b61@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
syzkaller #0 Not tainted
------------------------------------------------------
kswapd0/79 is trying to acquire lock:
ffff888041afd798 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_reclaim_inode fs/xfs/xfs_icache.c:1040 [inline]
ffff888041afd798 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_icwalk_process_inode fs/xfs/xfs_icache.c:1732 [inline]
ffff888041afd798 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_icwalk_ag+0x12c5/0x1ab0 fs/xfs/xfs_icache.c:1814

but task is already holding lock:
ffffffff8e047ae0 (fs_reclaim){+.+.}-{0:0}, at: balance_pgdat mm/vmscan.c:7015 [inline]
ffffffff8e047ae0 (fs_reclaim){+.+.}-{0:0}, at: kswapd+0x951/0x2800 mm/vmscan.c:7389

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (fs_reclaim){+.+.}-{0:0}:
       lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5868
       __fs_reclaim_acquire mm/page_alloc.c:4264 [inline]
       fs_reclaim_acquire+0x72/0x100 mm/page_alloc.c:4278
       might_alloc include/linux/sched/mm.h:318 [inline]
       slab_pre_alloc_hook mm/slub.c:4929 [inline]
       slab_alloc_node mm/slub.c:5264 [inline]
       __kmalloc_cache_noprof+0x40/0x6f0 mm/slub.c:5766
       kmalloc_noprof include/linux/slab.h:957 [inline]
       iomap_fill_dirty_folios+0xf4/0x260 fs/iomap/buffered-io.c:1557
       xfs_buffered_write_iomap_begin+0xa23/0x1a70 fs/xfs/xfs_iomap.c:1857
       iomap_iter+0x5f2/0xf10 fs/iomap/iter.c:110
       iomap_zero_range+0x1cc/0xa50 fs/iomap/buffered-io.c:1590
       iomap_truncate_page+0xb1/0x110 fs/iomap/buffered-io.c:1629
       xfs_setattr_size+0x452/0xee0 fs/xfs/xfs_iops.c:996
       __xfs_file_fallocate+0x10e1/0x1610 include/linux/fs.h:-1
       xfs_file_fallocate+0x27b/0x340 fs/xfs/xfs_file.c:1462
       vfs_fallocate+0x669/0x7e0 fs/open.c:342
       ksys_fallocate fs/open.c:366 [inline]
       __do_sys_fallocate fs/open.c:371 [inline]
       __se_sys_fallocate fs/open.c:369 [inline]
       __x64_sys_fallocate+0xc0/0x110 fs/open.c:369
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #0 (&xfs_nondir_ilock_class){++++}-{4:4}:
       check_prev_add kernel/locking/lockdep.c:3165 [inline]
       check_prevs_add kernel/locking/lockdep.c:3284 [inline]
       validate_chain+0xb9b/0x2140 kernel/locking/lockdep.c:3908
       __lock_acquire+0xab9/0xd20 kernel/locking/lockdep.c:5237
       lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5868
       down_write_nested+0x9d/0x200 kernel/locking/rwsem.c:1706
       xfs_reclaim_inode fs/xfs/xfs_icache.c:1040 [inline]
       xfs_icwalk_process_inode fs/xfs/xfs_icache.c:1732 [inline]
       xfs_icwalk_ag+0x12c5/0x1ab0 fs/xfs/xfs_icache.c:1814
       xfs_icwalk fs/xfs/xfs_icache.c:1862 [inline]
       xfs_reclaim_inodes_nr+0x1e3/0x260 fs/xfs/xfs_icache.c:1106
       super_cache_scan+0x41b/0x4b0 fs/super.c:228
       do_shrink_slab+0x6ef/0x1110 mm/shrinker.c:437
       shrink_slab_memcg mm/shrinker.c:550 [inline]
       shrink_slab+0x7ef/0x10d0 mm/shrinker.c:628
       shrink_one+0x28a/0x7c0 mm/vmscan.c:4955
       shrink_many mm/vmscan.c:5016 [inline]
       lru_gen_shrink_node mm/vmscan.c:5094 [inline]
       shrink_node+0x315d/0x3780 mm/vmscan.c:6081
       kswapd_shrink_node mm/vmscan.c:6941 [inline]
       balance_pgdat mm/vmscan.c:7124 [inline]
       kswapd+0x147c/0x2800 mm/vmscan.c:7389
       kthread+0x711/0x8a0 kernel/kthread.c:463
       ret_from_fork+0x4bc/0x870 arch/x86/kernel/process.c:158
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

other info that might help us debug this:

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(fs_reclaim);
                               lock(&xfs_nondir_ilock_class);
                               lock(fs_reclaim);
  lock(&xfs_nondir_ilock_class);

 *** DEADLOCK ***

2 locks held by kswapd0/79:
 #0: ffffffff8e047ae0 (fs_reclaim){+.+.}-{0:0}, at: balance_pgdat mm/vmscan.c:7015 [inline]
 #0: ffffffff8e047ae0 (fs_reclaim){+.+.}-{0:0}, at: kswapd+0x951/0x2800 mm/vmscan.c:7389
 #1: ffff8880113de0e0 (&type->s_umount_key#55){++++}-{4:4}, at: super_trylock_shared fs/super.c:563 [inline]
 #1: ffff8880113de0e0 (&type->s_umount_key#55){++++}-{4:4}, at: super_cache_scan+0x91/0x4b0 fs/super.c:197

stack backtrace:
CPU: 0 UID: 0 PID: 79 Comm: kswapd0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
 print_circular_bug+0x2ee/0x310 kernel/locking/lockdep.c:2043
 check_noncircular+0x134/0x160 kernel/locking/lockdep.c:2175
 check_prev_add kernel/locking/lockdep.c:3165 [inline]
 check_prevs_add kernel/locking/lockdep.c:3284 [inline]
 validate_chain+0xb9b/0x2140 kernel/locking/lockdep.c:3908
 __lock_acquire+0xab9/0xd20 kernel/locking/lockdep.c:5237
 lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5868
 down_write_nested+0x9d/0x200 kernel/locking/rwsem.c:1706
 xfs_reclaim_inode fs/xfs/xfs_icache.c:1040 [inline]
 xfs_icwalk_process_inode fs/xfs/xfs_icache.c:1732 [inline]
 xfs_icwalk_ag+0x12c5/0x1ab0 fs/xfs/xfs_icache.c:1814
 xfs_icwalk fs/xfs/xfs_icache.c:1862 [inline]
 xfs_reclaim_inodes_nr+0x1e3/0x260 fs/xfs/xfs_icache.c:1106
 super_cache_scan+0x41b/0x4b0 fs/super.c:228
 do_shrink_slab+0x6ef/0x1110 mm/shrinker.c:437
 shrink_slab_memcg mm/shrinker.c:550 [inline]
 shrink_slab+0x7ef/0x10d0 mm/shrinker.c:628
 shrink_one+0x28a/0x7c0 mm/vmscan.c:4955
 shrink_many mm/vmscan.c:5016 [inline]
 lru_gen_shrink_node mm/vmscan.c:5094 [inline]
 shrink_node+0x315d/0x3780 mm/vmscan.c:6081
 kswapd_shrink_node mm/vmscan.c:6941 [inline]
 balance_pgdat mm/vmscan.c:7124 [inline]
 kswapd+0x147c/0x2800 mm/vmscan.c:7389
 kthread+0x711/0x8a0 kernel/kthread.c:463
 ret_from_fork+0x4bc/0x870 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
