Received: from mail-il1-f206.google.com (mail-il1-f206.google.com [209.85.166.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FF8A1BC4E
	for <linux-xfs@vger.kernel.org>; Sun,  2 Feb 2025 00:53:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738457606; cv=none; b=K5V2emUekwkukb4+8uDRJbSnQxuOk5f2r6U9tr90VuyPibndTNTeCoMWBLB5Gtv+RrQmU0/ajWiiwfUfv04VA/AvLKoFKTPFf//2MF3INpVX9ynv/CWOzW1JrhKXdGzo+4BxNtj8C4rjurQ9jbTrtKILbLCIB6bEOv+U+beTnXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738457606; c=relaxed/simple;
	bh=kF8wgEknyoTDL1knNHdsWrlkgKbJRjWMcZeYZpKFtpc=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=u+ns4kIS4e1WZyefqE5/aboNpJPoWuX8aSpzl2+Vg6JYf4mFDqRkYFxvlJtSHWdrtSGAAYNhwCa2NGo43Dfxg/1gXkK1ZgGdEnaMxTpkPn6WKduDvqT2gYSJaU1qgrbCa0kbeuFRuTzG2vuF896PhaucMWe2p+0YLVHDPg1KBX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f206.google.com with SMTP id e9e14a558f8ab-3cffc8affa1so19868965ab.3
        for <linux-xfs@vger.kernel.org>; Sat, 01 Feb 2025 16:53:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738457603; x=1739062403;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=e6RALuq9KYNd4yyYjO576kU9P8ehAAePy7C4CDzxpXo=;
        b=p6h4HkY/8G3ec4JEqRpaTsjHz+Cib6CNHFDgJCco1GhwjpH+6I7z1ONetXPctZntBE
         Z+Ct0ld9qPjyoV02oDqgb3waBQyrlCFA9RyX1lHRLMhCAMw6c5SzPVDmr9MW1Z4A896W
         BiUxZ0ldENnHe/9S85qWjHjkvzyimUsFXABvWAim8d2AANpPpGWX2esUQqmS8CYAewZn
         vTd/w+IDbwBgV3FLozcICi093eHuEVyU5BtaUk7Ba0uSbx0x2GN2kCLj0dbh4W2knH/j
         vkLuyrUMlWw4iAC6d2hEyAFQvbVD8JVfzKQCagXbcOy+m0uuH08R9GkxCo6nBo8KRjqZ
         GAOw==
X-Forwarded-Encrypted: i=1; AJvYcCVmrypkJEB4wvyQ8XMX3wiKRi1dXtIAJxpBScBhAv+u4sAYgm5VZ6BIzvjpue9ckmmTFwVyIYrZjiM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxZvcLisKIrKW5yBAgx5m/p1lAscPpfqddGF59WSMpNaLBYi1G+
	QFASDcSVu0dSsaep019zOlXH9xW2sLn7ivQ1BFGW4+EQULq7hBwHIYNeiTwMM6IoQfd8cAvXOSP
	MrP4z81Nbx6GwP7OPuls7aAZ2nSCICzcO9J/7aUVYkQNp67cbE6tEYOw=
X-Google-Smtp-Source: AGHT+IFSxil6V1oK618o/WcawTuywvZC8sOmE46cpYwep8L5e2dX9GTrRggbGGuIMO9zcpYO5KiSsk66OncEkT3OIgPcrlksuK5I
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a92:cda7:0:b0:3ce:4b12:fa17 with SMTP id
 e9e14a558f8ab-3cffe4453e0mr136861275ab.19.1738457603674; Sat, 01 Feb 2025
 16:53:23 -0800 (PST)
Date: Sat, 01 Feb 2025 16:53:23 -0800
In-Reply-To: <6798b182.050a0220.ac840.0248.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <679ec203.050a0220.d7c5a.0063.GAE@google.com>
Subject: Re: [syzbot] [xfs?] possible deadlock in xfs_buf_find_insert
From: syzbot <syzbot+acb56162aef712929d3f@syzkaller.appspotmail.com>
To: cem@kernel.org, chandan.babu@oracle.com, djwong@kernel.org, hch@lst.de, 
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    69b8923f5003 Merge tag 'for-linus-6.14-ofs4' of git://git...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1361fddf980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=57ab43c279fa614d
dashboard link: https://syzkaller.appspot.com/bug?extid=acb56162aef712929d3f
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=174cd5f8580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=162e2d18580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/ea84ac864e92/disk-69b8923f.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/6a465997b4e0/vmlinux-69b8923f.xz
kernel image: https://storage.googleapis.com/syzbot-assets/d72b67b2bd15/bzImage-69b8923f.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/2d5b00530bed/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+acb56162aef712929d3f@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
6.13.0-syzkaller-09793-g69b8923f5003 #0 Not tainted
------------------------------------------------------
syz-executor278/5867 is trying to acquire lock:
ffff8880787b0da0 (&bp->b_lock){+.+.}-{3:3}, at: spin_lock include/linux/spinlock.h:351 [inline]
ffff8880787b0da0 (&bp->b_lock){+.+.}-{3:3}, at: xfs_buf_try_hold fs/xfs/xfs_buf.c:578 [inline]
ffff8880787b0da0 (&bp->b_lock){+.+.}-{3:3}, at: xfs_buf_find_insert+0x1123/0x1610 fs/xfs/xfs_buf.c:663

but task is already holding lock:
ffff888026f07980 (&bch->bc_lock){+.+.}-{3:3}, at: spin_lock include/linux/spinlock.h:351 [inline]
ffff888026f07980 (&bch->bc_lock){+.+.}-{3:3}, at: xfs_buf_find_insert+0x3da/0x1610 fs/xfs/xfs_buf.c:655

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (&bch->bc_lock){+.+.}-{3:3}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5851
       __raw_spin_lock include/linux/spinlock_api_smp.h:133 [inline]
       _raw_spin_lock+0x2e/0x40 kernel/locking/spinlock.c:154
       spin_lock include/linux/spinlock.h:351 [inline]
       xfs_buf_rele_cached fs/xfs/xfs_buf.c:1093 [inline]
       xfs_buf_rele+0x2bf/0x1660 fs/xfs/xfs_buf.c:1147
       process_one_work kernel/workqueue.c:3236 [inline]
       process_scheduled_works+0xa66/0x1840 kernel/workqueue.c:3317
       worker_thread+0x870/0xd30 kernel/workqueue.c:3398
       kthread+0x7a9/0x920 kernel/kthread.c:464
       ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:148
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

-> #0 (&bp->b_lock){+.+.}-{3:3}:
       check_prev_add kernel/locking/lockdep.c:3163 [inline]
       check_prevs_add kernel/locking/lockdep.c:3282 [inline]
       validate_chain+0x18ef/0x5920 kernel/locking/lockdep.c:3906
       __lock_acquire+0x1397/0x2100 kernel/locking/lockdep.c:5228
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5851
       __raw_spin_lock include/linux/spinlock_api_smp.h:133 [inline]
       _raw_spin_lock+0x2e/0x40 kernel/locking/spinlock.c:154
       spin_lock include/linux/spinlock.h:351 [inline]
       xfs_buf_try_hold fs/xfs/xfs_buf.c:578 [inline]
       xfs_buf_find_insert+0x1123/0x1610 fs/xfs/xfs_buf.c:663
       xfs_buf_get_map+0x149a/0x1ac0 fs/xfs/xfs_buf.c:754
       xfs_buf_read_map+0x110/0xa50 fs/xfs/xfs_buf.c:862
       xfs_trans_read_buf_map+0x260/0xab0 fs/xfs/xfs_trans_buf.c:304
       xfs_trans_read_buf fs/xfs/xfs_trans.h:212 [inline]
       xfs_imap_to_bp+0x18d/0x380 fs/xfs/libxfs/xfs_inode_buf.c:139
       xfs_iget_cache_miss fs/xfs/xfs_icache.c:664 [inline]
       xfs_iget+0xbe9/0x2ec0 fs/xfs/xfs_icache.c:806
       xfs_lookup+0x356/0x690 fs/xfs/xfs_inode.c:553
       xfs_vn_lookup+0x192/0x290 fs/xfs/xfs_iops.c:326
       __lookup_slow+0x296/0x400 fs/namei.c:1793
       lookup_slow+0x53/0x70 fs/namei.c:1810
       walk_component+0x2e1/0x410 fs/namei.c:2114
       lookup_last fs/namei.c:2612 [inline]
       path_lookupat+0x16f/0x450 fs/namei.c:2636
       filename_lookup+0x2a3/0x670 fs/namei.c:2665
       do_linkat+0x13f/0x6f0 fs/namei.c:4845
       __do_sys_link fs/namei.c:4899 [inline]
       __se_sys_link fs/namei.c:4897 [inline]
       __x64_sys_link+0x82/0x90 fs/namei.c:4897
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

other info that might help us debug this:

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&bch->bc_lock);
                               lock(&bp->b_lock);
                               lock(&bch->bc_lock);
  lock(&bp->b_lock);

 *** DEADLOCK ***

2 locks held by syz-executor278/5867:
 #0: ffff8880787e67f0 (&inode->i_sb->s_type->i_mutex_dir_key){.+.+}-{4:4}, at: inode_lock_shared include/linux/fs.h:875 [inline]
 #0: ffff8880787e67f0 (&inode->i_sb->s_type->i_mutex_dir_key){.+.+}-{4:4}, at: lookup_slow+0x45/0x70 fs/namei.c:1809
 #1: ffff888026f07980 (&bch->bc_lock){+.+.}-{3:3}, at: spin_lock include/linux/spinlock.h:351 [inline]
 #1: ffff888026f07980 (&bch->bc_lock){+.+.}-{3:3}, at: xfs_buf_find_insert+0x3da/0x1610 fs/xfs/xfs_buf.c:655

stack backtrace:
CPU: 0 UID: 0 PID: 5867 Comm: syz-executor278 Not tainted 6.13.0-syzkaller-09793-g69b8923f5003 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 12/27/2024
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
 print_circular_bug+0x13a/0x1b0 kernel/locking/lockdep.c:2076
 check_noncircular+0x36a/0x4a0 kernel/locking/lockdep.c:2208
 check_prev_add kernel/locking/lockdep.c:3163 [inline]
 check_prevs_add kernel/locking/lockdep.c:3282 [inline]
 validate_chain+0x18ef/0x5920 kernel/locking/lockdep.c:3906
 __lock_acquire+0x1397/0x2100 kernel/locking/lockdep.c:5228
 lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5851
 __raw_spin_lock include/linux/spinlock_api_smp.h:133 [inline]
 _raw_spin_lock+0x2e/0x40 kernel/locking/spinlock.c:154
 spin_lock include/linux/spinlock.h:351 [inline]
 xfs_buf_try_hold fs/xfs/xfs_buf.c:578 [inline]
 xfs_buf_find_insert+0x1123/0x1610 fs/xfs/xfs_buf.c:663
 xfs_buf_get_map+0x149a/0x1ac0 fs/xfs/xfs_buf.c:754
 xfs_buf_read_map+0x110/0xa50 fs/xfs/xfs_buf.c:862
 xfs_trans_read_buf_map+0x260/0xab0 fs/xfs/xfs_trans_buf.c:304
 xfs_trans_read_buf fs/xfs/xfs_trans.h:212 [inline]
 xfs_imap_to_bp+0x18d/0x380 fs/xfs/libxfs/xfs_inode_buf.c:139
 xfs_iget_cache_miss fs/xfs/xfs_icache.c:664 [inline]
 xfs_iget+0xbe9/0x2ec0 fs/xfs/xfs_icache.c:806
 xfs_lookup+0x356/0x690 fs/xfs/xfs_inode.c:553
 xfs_vn_lookup+0x192/0x290 fs/xfs/xfs_iops.c:326
 __lookup_slow+0x296/0x400 fs/namei.c:1793
 lookup_slow+0x53/0x70 fs/namei.c:1810
 walk_component+0x2e1/0x410 fs/namei.c:2114
 lookup_last fs/namei.c:2612 [inline]
 path_lookupat+0x16f/0x450 fs/namei.c:2636
 filename_lookup+0x2a3/0x670 fs/namei.c:2665
 do_linkat+0x13f/0x6f0 fs/namei.c:4845
 __do_sys_link fs/namei.c:4899 [inline]
 __se_sys_link fs/namei.c:4897 [inline]
 __x64_sys_link+0x82/0x90 fs/namei.c:4897
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f681317ba59
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 b1 18 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f6813111218 EFLAGS: 00000246 ORIG_RAX: 0000000000000056
RAX: ffffffffffffffda RBX: 00007f681320d6b8 RCX: 00007f681317ba59
RDX: 00007f68131550c6 RSI: 0000000000000000 RDI: 0000000020000040
RBP: 00007f681320d6b0 R08: 00007ffc23404e87 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0031656c69662f2e
R13: 0030656c69662f2e R14: 0031656c69662f30 R15: 2f30656c69662f2e
 </TASK>


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
