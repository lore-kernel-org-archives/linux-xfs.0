Received: from mail-io1-f80.google.com (mail-io1-f80.google.com [209.85.166.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61BE419DFAB
	for <linux-xfs@vger.kernel.org>; Mon, 18 Aug 2025 01:51:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755481890; cv=none; b=INneN86oRtwMUkh0wWDrCQEodGXIf8VtfPiWGxYtluNa5S1//p0fphkKntoIYfzcIgxsX0VLBZ+Sb/ywe5arblRwC048j2c7a6v7mA5ULgK3YXOiDewUi8NxJGBQWyYbjYAdwIguhs3HplxXmiqr3h0NlzNpIbkEEJ/4+dzRrC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755481890; c=relaxed/simple;
	bh=GTKj99jgKPX44cFsHEjuWHT3/Sv1bBvUxx4iw1Ex1Uk=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=Mzjw0Mw6fuJERD0OcFFanCK13flVnRE4ZnwHNEe0/VWmCUFaz6MaVEdrkhgilHHaxmBN1EEX546Fcq5BetWYPQvA6NDIR7KFTJ69sfwAoVV1eVBQ8wa7dL8FBqbb8IKUJ3ZlAt6nVWcZDa1DXtw5Kv7BneX5dysXCxWTVBIUxQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f80.google.com with SMTP id ca18e2360f4ac-88432e1d004so405180139f.2
        for <linux-xfs@vger.kernel.org>; Sun, 17 Aug 2025 18:51:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755481888; x=1756086688;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RK5qO1TPZ8k2YOyWwCFjYhmfAaUf62lFW133PN4xikA=;
        b=dazcC3ZQmlUmQkeIO2aEPOtVcg/AuXk8g/W+NevlVVU+Mt8EkDysX+f+Iii/u6yXTo
         reKuUwlHsBKyVg/vyP55NjPERU9v0f1mRPAEe2PZ+BwtfGAOXeWlPqdkdPNN6v3+Wwwu
         dyQIu0z7EtmFvoEvbMlnnak9mibViXtXj0Hqd69vuaE/4298JWGTbHoEfQBeVVrN+Q+L
         P+NkzFR/KZhFbdCWq2jEDNM5M0mC5RH0FqdaJJ1L+Ke3FY9S7U4bVEohE9U5rFnG+L10
         QzV6qBVI0fsvlZyieb6vfq9PZ+XWAdFF5y4DvjVqyhiJIzq5JjYdylQdGaqUxTkkgyNq
         z0iw==
X-Forwarded-Encrypted: i=1; AJvYcCVfXDS53i75Bbvxf5aIec4kBTF4SG7GUPnbhVRQhCt9fh8f4NEehl9qRt5Sjz88+qIyOufQh1jNK2s=@vger.kernel.org
X-Gm-Message-State: AOJu0YxBvezrN0w3eg3gzIuCLISCnTCe6yphQ7Nc/uUS4t8cpGCHieco
	oNMmXOVUM1EVec9uD1xTvtC8RNagyUjnZQ/oD0QPFVk+vGh8p2/BXrTGk1ndXta923f5HC425dX
	JybtrWJlFcyEEe1nWM4UvhmZ1lEGFGprnx89LLjWZyTxKtY2ULNUOdOHQFpo=
X-Google-Smtp-Source: AGHT+IFUtAwSNFpept1CqNTKNeDDA07oPYmKqdl6pqgDtDO8tElJJ1359AwRLqXK2QGmHt2IAqsqS3NHAt3lbXiGrPjU1aO6t0zP
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:6d84:b0:87c:30c6:a7cf with SMTP id
 ca18e2360f4ac-8843e23ef9fmr1885138139f.0.1755481888561; Sun, 17 Aug 2025
 18:51:28 -0700 (PDT)
Date: Sun, 17 Aug 2025 18:51:28 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68a28720.050a0220.e29e5.0080.GAE@google.com>
Subject: [syzbot] [xfs?] WARNING in xfs_trans_alloc
From: syzbot <syzbot+ab02e4744b96de7d3499@syzkaller.appspotmail.com>
To: cem@kernel.org, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    dfc0f6373094 Merge tag 'erofs-for-6.17-rc2-fixes' of git:/..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=12bfcda2580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=13f39c6a0380a209
dashboard link: https://syzkaller.appspot.com/bug?extid=ab02e4744b96de7d3499
compiler:       Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/471a095bde0f/disk-dfc0f637.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/dfa0446324a1/vmlinux-dfc0f637.xz
kernel image: https://storage.googleapis.com/syzbot-assets/9a43829df052/bzImage-dfc0f637.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+ab02e4744b96de7d3499@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 0 PID: 990 at fs/xfs/xfs_trans.c:256 xfs_trans_alloc+0x4d8/0x980 fs/xfs/xfs_trans.c:256
Modules linked in:
CPU: 0 UID: 0 PID: 990 Comm: kworker/0:2 Tainted: G        W           6.17.0-rc1-syzkaller-00036-gdfc0f6373094 #0 PREEMPT_{RT,(full)} 
Tainted: [W]=WARN
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/12/2025
Workqueue: xfs-inodegc/loop2 xfs_inodegc_worker
RIP: 0010:xfs_trans_alloc+0x4d8/0x980 fs/xfs/xfs_trans.c:256
Code: 89 ef e8 1b 49 fa ff 85 c0 0f 85 14 02 00 00 e8 8e 3e 57 fe b0 01 89 44 24 24 4c 8b 64 24 78 e9 f9 fb ff ff e8 79 3e 57 fe 90 <0f> 0b 90 e9 3f fc ff ff 89 d9 80 e1 07 fe c1 38 c1 0f 8c 13 fc ff
RSP: 0018:ffffc90004acf7f8 EFLAGS: 00010293
RAX: ffffffff83671cc7 RBX: 0000000000000004 RCX: ffff8880253cd940
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffff888053a08000 R08: 0000000000000000 R09: 0000000000000000
R10: dffffc0000000000 R11: fffffbfff1e3a727 R12: ffff888053a08130
R13: 0000000000000000 R14: 1ffff1100a741073 R15: dffffc0000000000
FS:  0000000000000000(0000) GS:ffff8881268c5000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ff8b6a64f98 CR3: 000000002370a000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 xfs_inactive_truncate+0xa5/0x1b0 fs/xfs/xfs_inode.c:1152
 xfs_inactive+0x949/0xcd0 fs/xfs/xfs_inode.c:1454
 xfs_inodegc_inactivate fs/xfs/xfs_icache.c:1944 [inline]
 xfs_inodegc_worker+0x31e/0x7c0 fs/xfs/xfs_icache.c:1990
 process_one_work kernel/workqueue.c:3236 [inline]
 process_scheduled_works+0xae1/0x17b0 kernel/workqueue.c:3319
 worker_thread+0x8a0/0xda0 kernel/workqueue.c:3400
 kthread+0x711/0x8a0 kernel/kthread.c:463
 ret_from_fork+0x3fc/0x770 arch/x86/kernel/process.c:148
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
