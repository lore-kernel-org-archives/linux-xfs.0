Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com [209.85.167.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC2E82C234E
	for <linux-xfs@vger.kernel.org>; Wed, 11 Mar 2026 04:25:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773203135; cv=none; b=EHnzMVTywG8H/NOiYpbq1cDW34l6RKfuYSlCUznYR671yAE8+ETDdbPliA0j9tLSPKRz0ZanFykPlyjdHNrDu532yr+zc4cAaRIajNB4MvB8lQ/lKNevC41q9cQg2JEWg0Yr3xR+ZCUTH6iQtI7NELPHcV8nEIbUt4ze+Z0VCtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773203135; c=relaxed/simple;
	bh=OV282ESBR2B6HOLfmgxSEz7bKzYuzM6j5PzCZ1QmAQ4=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=X0UueNA7yFCVb+s14GIERFNF99X1+83QePEDmxKPhS8Po+Aj+QraIGdapLhJVOnad0iM+W0OW/FFbZ+IL8jMRVI7bYpCtfcwjjGM6YFbrCAHaOtgYFQroI4xiOlqJTD5bF5LzUCxglW8FtS98v85EFCaFpyNGhtWe+wNhCStxDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-463ee33f9b2so50578625b6e.3
        for <linux-xfs@vger.kernel.org>; Tue, 10 Mar 2026 21:25:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773203133; x=1773807933;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MJBej/m7/3WxM0PGbEN1Gz6ax2HLqIM5iGAI2FUH2YI=;
        b=EZqyZYC1+uM1u4RfX4qX4pJXL0GyEO1kX9UPpdUvA6HliJ8yx9LyrSZpc9XICarILT
         LpqWDcB0QUUvLTl7W0ca9nGeVA3eFxpYh25lnmnYf1uVZVsvaqkVrplGJdzB9pcMvFDw
         V5QTCSC9GEfEYbmZ4nicRTH5N3IPaGj6qabs7N3j1KGmRQjO0bnXEe5rLJamVwmzzJ5O
         XMrYC2rg4ZwaZ1QZQ4U6wVoZIFogRyXm+lJlQ5rRhmYzRQdInUdYJHOOrs8eXX8knahp
         TRTW8FRWAufy44liJgJZiYTFGf6yQW/Sas2KAyEIBsN0MhBRKJEqLEcc505kf2LhC6B8
         yj3w==
X-Forwarded-Encrypted: i=1; AJvYcCXbkyKzxcXMJdSF41rVEC6uYQZsSep02jJBr3DDNqZOqRBwQBd0yqYyjjpZzvuoY2YsFTYhF2sJ+XU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxrAE/IZTCMTcjwcWKzo6t36QhdDDq4G53Dh2+jSnRqJgpqQNdp
	gV9KIZei5ijIlh2jBeB5soHgh9Td1keb9i/+vXkW1msOLHhUU+kZIB3+XU6Rey+obdqOTzmdvvN
	o4YScfKyH0Eo9PB2F2W+f46akZfrqztD2KUORbr9URiVxJP6GRz+O61PwM68=
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:1787:b0:45e:f09f:6359 with SMTP id
 5614622812f47-467335b7dbemr654821b6e.53.1773203132866; Tue, 10 Mar 2026
 21:25:32 -0700 (PDT)
Date: Tue, 10 Mar 2026 21:25:32 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69b0eebc.050a0220.381736.0048.GAE@google.com>
Subject: [syzbot] [xfs?] WARNING in refill_objects
From: syzbot <syzbot+d78ace33ad4ee69329d5@syzkaller.appspotmail.com>
To: cem@kernel.org, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    651690480a96 Merge tag 'spi-fix-v7.0-rc2' of git://git.ker..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1660ca02580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c5c49ee0942d1cdb
dashboard link: https://syzkaller.appspot.com/bug?extid=d78ace33ad4ee69329d5
compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-65169048.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/87d1bc3c7c70/vmlinux-65169048.xz
kernel image: https://storage.googleapis.com/syzbot-assets/8ab02990eba5/bzImage-65169048.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+d78ace33ad4ee69329d5@syzkaller.appspotmail.com

------------[ cut here ]------------
current->flags & PF_MEMALLOC
WARNING: mm/page_alloc.c:4741 at __alloc_pages_slowpath+0xd0a/0xd40 mm/page_alloc.c:4741, CPU#0: kswapd0/70
Modules linked in:
CPU: 0 UID: 0 PID: 70 Comm: kswapd0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
RIP: 0010:__alloc_pages_slowpath+0xd0a/0xd40 mm/page_alloc.c:4741
Code: 48 8b 1d 31 3b f9 10 48 83 c3 2c 48 89 d8 48 c1 e8 03 0f b6 04 08 84 c0 75 23 f6 43 01 08 48 8b 54 24 08 0f 84 41 f3 ff ff 90 <0f> 0b 90 e9 38 f3 ff ff e8 59 7c 8c 09 90 0f 0b 90 eb c2 89 d9 80
RSP: 0018:ffffc90000b1ec98 EFLAGS: 00010202
RAX: 0000000000000000 RBX: ffff888000e3c9ac RCX: dffffc0000000000
RDX: ffffc90000b1edc0 RSI: 0000000000000000 RDI: 00000000000cacc0
RBP: 00000000000cacc0 R08: ffff88802fffd9b0 R09: 1ffff1100bffae52
R10: dffffc0000000000 R11: ffffed100bffae53 R12: ffffc90000b1edc0
R13: 1ffff92000163db4 R14: 00000000000cacc0 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88808ca56000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fc9045ff000 CR3: 00000000121ca000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 __alloc_frozen_pages_noprof+0x322/0x380 mm/page_alloc.c:5263
 alloc_slab_page mm/slub.c:3296 [inline]
 allocate_slab+0x11f/0x660 mm/slub.c:3493
 new_slab mm/slub.c:3543 [inline]
 refill_objects+0x331/0x3c0 mm/slub.c:7178
 __pcs_replace_empty_main+0x2f9/0x5e0 mm/slub.c:-1
 alloc_from_pcs mm/slub.c:4720 [inline]
 slab_alloc_node mm/slub.c:4854 [inline]
 kmem_cache_alloc_noprof+0x37d/0x650 mm/slub.c:4876
 __xfs_trans_alloc+0x26/0x410 fs/xfs/xfs_trans.c:220
 xfs_trans_alloc+0xd7/0x9b0 fs/xfs/xfs_trans.c:254
 xfs_vn_sync_lazytime+0xaf/0x150 fs/xfs/xfs_iops.c:1238
 sync_lazytime+0x12d/0x2d0 fs/fs-writeback.c:1721
 iput+0x230/0xe80 fs/inode.c:1997
 __dentry_kill+0x1a2/0x5e0 fs/dcache.c:670
 shrink_kill+0xa9/0x2c0 fs/dcache.c:1147
 shrink_dentry_list+0x2e0/0x5e0 fs/dcache.c:1174
 prune_dcache_sb+0x119/0x180 fs/dcache.c:1256
 super_cache_scan+0x369/0x4b0 fs/super.c:223
 do_shrink_slab+0x6df/0x1170 mm/shrinker.c:437
 shrink_slab_memcg mm/shrinker.c:550 [inline]
 shrink_slab+0x830/0x1150 mm/shrinker.c:628
 shrink_one+0x2d9/0x710 mm/vmscan.c:4928
 shrink_many mm/vmscan.c:4989 [inline]
 lru_gen_shrink_node mm/vmscan.c:5067 [inline]
 shrink_node+0x3197/0x3a90 mm/vmscan.c:6047
 kswapd_shrink_node mm/vmscan.c:6894 [inline]
 balance_pgdat mm/vmscan.c:7070 [inline]
 kswapd+0x1742/0x2e10 mm/vmscan.c:7343
 kthread+0x388/0x470 kernel/kthread.c:436
 ret_from_fork+0x51e/0xb90 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
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
