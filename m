Received: from mail-il1-f208.google.com (mail-il1-f208.google.com [209.85.166.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45AED1D5CC7
	for <linux-xfs@vger.kernel.org>; Sun,  2 Mar 2025 17:15:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740935730; cv=none; b=ghcIlen4zl+fnfUC0HxBfiHCQ2JVV8Hhd2HdJscZ9vjeKOnOpngP1ci5ZQBiOAyIXae8YLC2CD/DEQYD8IfTaHiB0fLtVS4Ohh0u375kThEV0z6PTkidl+YcSI9r0JeiXhS9sX+5m+Rn6NkdRjg50+6HKQ7I6vSLk86QVl1AWa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740935730; c=relaxed/simple;
	bh=cE/SPCiYDZcOR99Z9M3tRDLTiaexuCJ5bEtRTIgmWG0=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=dtIYDpl0M0b5BCqowGaKN5zQpdiAv1kb8tctfYqo1Ww4KEfAzs2M0NGCXaRYRot5UwSK5MJzDub7KEXIwYwNcJp3TKLbNC9dOdna09e65j9Dyb7mrH4ZR92XsIYKojZhPLvML7kQ7p/vMfhS1Ag/+5Z0J8qIxl5qrI8WKpgcnAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f208.google.com with SMTP id e9e14a558f8ab-3cf64584097so41992905ab.2
        for <linux-xfs@vger.kernel.org>; Sun, 02 Mar 2025 09:15:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740935728; x=1741540528;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EjQINonG+fKzFryFSkBLx3n1n0DbYPP/R0V4wiSURIc=;
        b=Lx75Hz9IXSv7qB3Cf4VIa0MkZ1qz99tD308CgPu1LTSuhqosBrGV8by7yo5ny+n5u8
         OI0OG6ZlUju+wdYcPQnHsTLzLFzRj+RPglkNxsd8ha9oQdcvHbWrkaEuVxkXqlwAYmRB
         Ad9FTMeggUI0/3YCm9+uTcqAW74/HMOfKRBwTdVABKmF47nLHA57znUov/pfdQQ6HrET
         vjjl4o9GSFAdPArh9iqBYjuvgZzZq9/xoPn5sv/F3V6zR8K44UZ4J9XwFxarRAzyufxb
         OagbI0bg3UMOwUFs9DRMo8gBw8Yig4I5vJalDah+4Xf6WaIr+oXw9449kI4xjFYO5Rn7
         UgPg==
X-Forwarded-Encrypted: i=1; AJvYcCV69P+Favr9VXiuC+lPGDdeOx7vSYAp4SAnRd2HuF7Ivk6i/xCrNGZ6SEk0n4QDVgd5gAMC2cR7ZlE=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywf5QIgSxCUMRj2dApqiR9tq2cPI7lXDshkbJgpLjfggvaOJbj8
	OVoVeSq8jIU80KLLf8IIaihADq/IWZqmjGZaHG1adLcQDJ0CKaB7oUUQgadssMm+b/pEBatYfPI
	so0zAyYjX64eaW/dJnMvztBwLpb7puKbio5VbhiDIMBUe5aDxWf6XCAc=
X-Google-Smtp-Source: AGHT+IGSc9CsSIB8PvYkUlwIEWl1Vzgh9G7d69cBMweqfT4MmH4kG2MlNKLcVgOobeINwZfwg7yFQU/KgKjQk83g7yiogBiuM9jy
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1d14:b0:3d0:21aa:a752 with SMTP id
 e9e14a558f8ab-3d3e6e2109amr103084195ab.2.1740935728391; Sun, 02 Mar 2025
 09:15:28 -0800 (PST)
Date: Sun, 02 Mar 2025 09:15:28 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67c49230.050a0220.55417.04d5.GAE@google.com>
Subject: [syzbot] [xfs?] [mm?] WARNING: bad unlock balance in __mm_populate
From: syzbot <syzbot+8f9f411152c9539f4e59@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, chandan.babu@oracle.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-xfs@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    e056da87c780 Merge remote-tracking branch 'will/for-next/p..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=1206ba97980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d6b7e15dc5b5e776
dashboard link: https://syzkaller.appspot.com/bug?extid=8f9f411152c9539f4e59
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
userspace arch: arm64
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=126168b7980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=122265a8580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/3d8b1b7cc4c0/disk-e056da87.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/b84c04cff235/vmlinux-e056da87.xz
kernel image: https://storage.googleapis.com/syzbot-assets/2ae4d0525881/Image-e056da87.gz.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/9d88fc8b2cfc/mount_0.gz
  fsck result: failed (log: https://syzkaller.appspot.com/x/fsck.log?x=12f4cfb8580000)

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+8f9f411152c9539f4e59@syzkaller.appspotmail.com

XFS (loop0): Ending clean mount
XFS (loop0): Quotacheck needed: Please wait.
XFS (loop0): Quotacheck: Done.
=====================================
WARNING: bad unlock balance detected!
6.14.0-rc4-syzkaller-ge056da87c780 #0 Not tainted
-------------------------------------
syz-executor109/6436 is trying to release lock (&mm->mmap_lock) at:
[<ffff800080a63c54>] mmap_read_unlock include/linux/mmap_lock.h:217 [inline]
[<ffff800080a63c54>] __mm_populate+0x328/0x3d8 mm/gup.c:2044
but there are no more locks to release!

other info that might help us debug this:
no locks held by syz-executor109/6436.

stack backtrace:
CPU: 1 UID: 0 PID: 6436 Comm: syz-executor109 Not tainted 6.14.0-rc4-syzkaller-ge056da87c780 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 12/27/2024
Call trace:
 show_stack+0x2c/0x3c arch/arm64/kernel/stacktrace.c:466 (C)
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0xe4/0x150 lib/dump_stack.c:120
 dump_stack+0x1c/0x28 lib/dump_stack.c:129
 print_unlock_imbalance_bug+0x254/0x2ac kernel/locking/lockdep.c:5289
 __lock_release kernel/locking/lockdep.c:5518 [inline]
 lock_release+0x410/0x9e4 kernel/locking/lockdep.c:5872
 up_read+0x24/0x3c kernel/locking/rwsem.c:1619
 mmap_read_unlock include/linux/mmap_lock.h:217 [inline]
 __mm_populate+0x328/0x3d8 mm/gup.c:2044
 mm_populate include/linux/mm.h:3386 [inline]
 vm_mmap_pgoff+0x304/0x3c4 mm/util.c:580
 ksys_mmap_pgoff+0x3a4/0x5c8 mm/mmap.c:607
 __do_sys_mmap arch/arm64/kernel/sys.c:28 [inline]
 __se_sys_mmap arch/arm64/kernel/sys.c:21 [inline]
 __arm64_sys_mmap+0xf8/0x110 arch/arm64/kernel/sys.c:21
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
 el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
 do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
 el0_svc+0x54/0x168 arch/arm64/kernel/entry-common.c:744
 el0t_64_sync_handler+0x84/0x108 arch/arm64/kernel/entry-common.c:762
 el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:600
------------[ cut here ]------------
DEBUG_RWSEMS_WARN_ON(tmp < 0): count = 0xffffffffffffff00, magic = 0xffff0000d86e4de0, owner = 0x1, curr 0xffff0000c69a0000, list empty
WARNING: CPU: 1 PID: 6436 at kernel/locking/rwsem.c:1346 __up_read+0x3bc/0x5f8 kernel/locking/rwsem.c:1346
Modules linked in:
CPU: 1 UID: 0 PID: 6436 Comm: syz-executor109 Not tainted 6.14.0-rc4-syzkaller-ge056da87c780 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 12/27/2024
pstate: 60400005 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : __up_read+0x3bc/0x5f8 kernel/locking/rwsem.c:1346
lr : __up_read+0x3bc/0x5f8 kernel/locking/rwsem.c:1346
sp : ffff80009cdd79e0
x29: ffff80009cdd7a60 x28: 1ffff00011f780cb x27: ffff80008fbc0000
x26: dfff800000000000 x25: ffffffffffffff00 x24: ffff0000d86e4e38
x23: ffff0000d86e4de0 x22: ffffffffffffff00 x21: 0000000000000001
x20: ffff0000c69a0000 x19: ffff0000d86e4de0 x18: 0000000000000008
x17: 0000000000000000 x16: ffff8000832b5180 x15: 0000000000000001
x14: 1ffff000139bae94 x13: 0000000000000000 x12: 0000000000000000
x11: 0000000000000003 x10: 0000000000ff0100 x9 : aaeea068a75a4000
x8 : aaeea068a75a4000 x7 : 0000000000000001 x6 : 0000000000000001
x5 : ffff80009cdd7198 x4 : ffff80008fcaf780 x3 : ffff800083247194
x2 : 0000000000000001 x1 : 0000000100000001 x0 : 0000000000000000
Call trace:
 __up_read+0x3bc/0x5f8 kernel/locking/rwsem.c:1346 (P)
 up_read+0x2c/0x3c kernel/locking/rwsem.c:1620
 mmap_read_unlock include/linux/mmap_lock.h:217 [inline]
 __mm_populate+0x328/0x3d8 mm/gup.c:2044
 mm_populate include/linux/mm.h:3386 [inline]
 vm_mmap_pgoff+0x304/0x3c4 mm/util.c:580
 ksys_mmap_pgoff+0x3a4/0x5c8 mm/mmap.c:607
 __do_sys_mmap arch/arm64/kernel/sys.c:28 [inline]
 __se_sys_mmap arch/arm64/kernel/sys.c:21 [inline]
 __arm64_sys_mmap+0xf8/0x110 arch/arm64/kernel/sys.c:21
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
 el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
 do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
 el0_svc+0x54/0x168 arch/arm64/kernel/entry-common.c:744
 el0t_64_sync_handler+0x84/0x108 arch/arm64/kernel/entry-common.c:762
 el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:600
irq event stamp: 64843
hardirqs last  enabled at (64843): [<ffff80008b7e75f8>] __raw_spin_unlock_irqrestore include/linux/spinlock_api_smp.h:151 [inline]
hardirqs last  enabled at (64843): [<ffff80008b7e75f8>] _raw_spin_unlock_irqrestore+0x38/0x98 kernel/locking/spinlock.c:194
hardirqs last disabled at (64842): [<ffff80008b7e7428>] __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:108 [inline]
hardirqs last disabled at (64842): [<ffff80008b7e7428>] _raw_spin_lock_irqsave+0x2c/0x7c kernel/locking/spinlock.c:162
softirqs last  enabled at (64286): [<ffff8000801283e0>] local_bh_enable+0x10/0x34 include/linux/bottom_half.h:32
softirqs last disabled at (64284): [<ffff8000801283ac>] local_bh_disable+0x10/0x34 include/linux/bottom_half.h:19
---[ end trace 0000000000000000 ]---


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
