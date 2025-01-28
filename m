Received: from mail-io1-f80.google.com (mail-io1-f80.google.com [209.85.166.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E353B19C554
	for <linux-xfs@vger.kernel.org>; Tue, 28 Jan 2025 10:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738060165; cv=none; b=iKrlNNTxO2jVHGKEjXecGrSaz+8QYztyALCu9UDs/pmAttTwub+rm1uDq8uD8i2QFtb5cClB7kXBFMAkSdAHxCu4PNtZWtt0lgSKkWEO477HaaNRAivsyndKXcwEeO6+dmaGj1fOqUdt33modMYqW9F4HX1c7o68IjYVe+fOYjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738060165; c=relaxed/simple;
	bh=UZD9dpiHbyTIsbEhI5z8TgJWQuaf+CfSXfaL6EfSQis=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=XQm8j+jSxyG1C78jWWF0QbM1sm3evaj0O68WmVMq0zLw7aN9jlMzZgLZ/Yqg7+Tfc2hux7XAhKjIrBnKW40eDIlpqKXe6pV7ChjSjpu6fRaSe3VX1oPcTC6QRUn+r3+ri3y1JOmxHcAoRkJlsfTixuMk6ZLpkXzd6EoatGenaHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f80.google.com with SMTP id ca18e2360f4ac-84730592e44so340710239f.3
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jan 2025 02:29:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738060163; x=1738664963;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cwXxhyyHVm1kJBcxBKibInhYniDgl9cLBEBCjr54TVk=;
        b=l32yggjgGGsY7FokB9GExyhEmi9B7kW9hio9aW5WQCe91rL6sA3It3H6hZMdWdTdcn
         Nv2l2HT0q8it7nRZoWssLyWQREKSvtLROQ233YjJBfLWt5AsbTJl8XTuh+3qWRkDOnfj
         7tm5i2zjsaBgp4o05Ar+PUH39VOx0E5sRjuPVYV3nzZoFgC5A+Q0PkZ+SCAoO6/sud5q
         VmTkCjG2ZRCtdnTiDb0Pc3SNgDzUcBtlp/THk7PabnHghIkV4TZnADY7CiiiWRcyP2Y9
         LgFRNGOWWMakHDRvifL/2dbPMwJs85JadQaC4fZIIglU6oDktqYBCWHVPYmZqb1StQnV
         NqFw==
X-Forwarded-Encrypted: i=1; AJvYcCUjht8PCLvwGoWehqDkLrUnlypaNGm2rk18pZ9TFiudmi9oB9NclvP8ZU2x0Gbjp1ImsLGtasyq0Qk=@vger.kernel.org
X-Gm-Message-State: AOJu0YxCh25ZjLr6M0ZGkF8KBq+Xzi4gzyMvfwtLmWhVR3cBaHzP0wYb
	8pchJbNWGna2pSbjRh/mm69ofBr8QfZRHiFLc08bmt8mMS4BXk8kX7ns9pfASucPZ7jGbR059NT
	TXE95wGkUpYnZV6Tu5lFc+umPgWOQKRNo8QhL/vVmt21vmn+8refFAsI=
X-Google-Smtp-Source: AGHT+IFNqr66DKgy/Mzz25c6Lnk3rnfKkG/jeL2loxu9d8vH447lLjUXn6KPyrbiNn8AHwok46LU8UYUlblk6qUS1Wv8ecj9nOPx
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a92:cda9:0:b0:3a7:8720:9de5 with SMTP id
 e9e14a558f8ab-3cf743aee33mr375226155ab.1.1738060163008; Tue, 28 Jan 2025
 02:29:23 -0800 (PST)
Date: Tue, 28 Jan 2025 02:29:22 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6798b182.050a0220.ac840.0248.GAE@google.com>
Subject: [syzbot] [xfs?] possible deadlock in xfs_buf_find_insert
From: syzbot <syzbot+acb56162aef712929d3f@syzkaller.appspotmail.com>
To: cem@kernel.org, chandan.babu@oracle.com, djwong@kernel.org, 
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    aa22f4da2a46 Merge tag 'rproc-v6.14' of git://git.kernel.o..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=100175df980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=bdecca7d9ba0b0e8
dashboard link: https://syzkaller.appspot.com/bug?extid=acb56162aef712929d3f
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/204a46b0b3d6/disk-aa22f4da.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/d62db5dd211d/vmlinux-aa22f4da.xz
kernel image: https://storage.googleapis.com/syzbot-assets/d9ef2864f84f/bzImage-aa22f4da.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+acb56162aef712929d3f@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
6.13.0-syzkaller-07632-gaa22f4da2a46 #0 Not tainted
------------------------------------------------------
syz.4.192/7178 is trying to acquire lock:
ffff888058756e20 (&bp->b_lock){+.+.}-{3:3}, at: spin_lock include/linux/spinlock.h:351 [inline]
ffff888058756e20 (&bp->b_lock){+.+.}-{3:3}, at: xfs_buf_try_hold fs/xfs/xfs_buf.c:578 [inline]
ffff888058756e20 (&bp->b_lock){+.+.}-{3:3}, at: xfs_buf_find_insert+0x1123/0x1610 fs/xfs/xfs_buf.c:663

but task is already holding lock:
ffff88802268b180 (&bch->bc_lock){+.+.}-{3:3}, at: spin_lock include/linux/spinlock.h:351 [inline]
ffff88802268b180 (&bch->bc_lock){+.+.}-{3:3}, at: xfs_buf_find_insert+0x3da/0x1610 fs/xfs/xfs_buf.c:655

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
       xfs_read_agf+0x2dc/0x630 fs/xfs/libxfs/xfs_alloc.c:3378
       xfs_alloc_read_agf+0x196/0xbe0 fs/xfs/libxfs/xfs_alloc.c:3413
       xfs_trim_gather_extents+0x1b2/0x11a0 fs/xfs/xfs_discard.c:203
       xfs_trim_perag_extents fs/xfs/xfs_discard.c:374 [inline]
       xfs_trim_datadev_extents+0x4c7/0xbb0 fs/xfs/xfs_discard.c:429
       xfs_ioc_trim+0x758/0xa90 fs/xfs/xfs_discard.c:887
       xfs_file_ioctl+0x84c/0x1c60 fs/xfs/xfs_ioctl.c:1199
       vfs_ioctl fs/ioctl.c:51 [inline]
       __do_sys_ioctl fs/ioctl.c:906 [inline]
       __se_sys_ioctl+0xf5/0x170 fs/ioctl.c:892
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

1 lock held by syz.4.192/7178:
 #0: ffff88802268b180 (&bch->bc_lock){+.+.}-{3:3}, at: spin_lock include/linux/spinlock.h:351 [inline]
 #0: ffff88802268b180 (&bch->bc_lock){+.+.}-{3:3}, at: xfs_buf_find_insert+0x3da/0x1610 fs/xfs/xfs_buf.c:655

stack backtrace:
CPU: 1 UID: 0 PID: 7178 Comm: syz.4.192 Not tainted 6.13.0-syzkaller-07632-gaa22f4da2a46 #0
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
 xfs_read_agf+0x2dc/0x630 fs/xfs/libxfs/xfs_alloc.c:3378
 xfs_alloc_read_agf+0x196/0xbe0 fs/xfs/libxfs/xfs_alloc.c:3413
 xfs_trim_gather_extents+0x1b2/0x11a0 fs/xfs/xfs_discard.c:203
 xfs_trim_perag_extents fs/xfs/xfs_discard.c:374 [inline]
 xfs_trim_datadev_extents+0x4c7/0xbb0 fs/xfs/xfs_discard.c:429
 xfs_ioc_trim+0x758/0xa90 fs/xfs/xfs_discard.c:887
 xfs_file_ioctl+0x84c/0x1c60 fs/xfs/xfs_ioctl.c:1199
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:906 [inline]
 __se_sys_ioctl+0xf5/0x170 fs/ioctl.c:892
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f2097f8cd29
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f2098d20038 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007f20981a6080 RCX: 00007f2097f8cd29
RDX: 00000000200001c0 RSI: 00000000c0185879 RDI: 0000000000000005
RBP: 00007f209800e2a0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000001 R14: 00007f20981a6080 R15: 00007ffefbba5028
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
