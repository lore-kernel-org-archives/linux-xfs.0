Received: from mail-io1-f77.google.com (mail-io1-f77.google.com [209.85.166.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAB9E208B0
	for <linux-xfs@vger.kernel.org>; Sat,  1 Jun 2024 11:12:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.77
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717240357; cv=none; b=Orj1acTIUN+FAt0zJHeqJz5V1tswyUNlomTp0taJhQZmqPdZw8L76CnV53C+I7eJuC6t54sLAiznYhIwlgkoAa9E+wJo0EN9srlEw+zysNEO4CfizbrLxvm4B0vLAGmYhl5kesUSakjNC9jQBGPdWg4t6qZ/P5RTaRP7k2ZlRUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717240357; c=relaxed/simple;
	bh=32WwZF3/QA1CjNqfrvhrAZCOhOPsDYeB4078HiZ1lo8=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=ibbUjCKJZQogBD+AUOG61+MyJwZ3vNSLbH4QnrERRp1Gk5icd3SVx82RLHK33dZ2A0G2SSyVDu9NhnrBP38i/fCzpcmiSu71iLe9CIrHliuuvswy/9MJXK93r3uD78kjC7u8bcpkYe3IrhyUO95PQRbxoHuNfCjDhT5YXBowDgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f77.google.com with SMTP id ca18e2360f4ac-7ea8fc6bd4dso347698339f.1
        for <linux-xfs@vger.kernel.org>; Sat, 01 Jun 2024 04:12:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717240355; x=1717845155;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=haJLjVBSN5VVEyOIvDxDEpwNuq4r9JOqsfVuXZhRM44=;
        b=FUiYfHsKgcdGLnS2YElhaOn91LVAfpVU7qkjfKDF0fjHIgnd6Cui3vdh2tOefeAQK2
         7zGV4MvVu5Awp+zsRdO9+1kafZqm2MyHGvvi1sSdJJDC2ewQPKUGKD4YGyvZLfpW2jpH
         Q0n7zIxs1NU3ATU3OYNXfmM1XCc/puz9eb0w3M5u1nTp6mr5+hcyrWAn6Qsg1TO8re7O
         eTJva4PiZ+yrBLSCipQyy0D4F91oEbZoDOqqmoW6rA8LsRHCfHjRZjsYeIcsb7m0TfsC
         0ii8TWNZY5Y3/fI6b9CI/ZgEq2RhgIAcG5H0xnMbG5zysZ/sBD0qhu+zUzBkWhjuJEsS
         pT7A==
X-Forwarded-Encrypted: i=1; AJvYcCXpncEeyW9rOt7w8Qb611W26xpKzISnqB17Nhu2D2OvubtkKujprqrTma67CdkvCR6Ff04t1bBMi4ww0UhpN04bwYfXyexBSX0Y
X-Gm-Message-State: AOJu0YxgnPhC+q+2zbEtVcF3IBwtAbIoqPfBjlil9aZUu7GGs5zVMyuq
	qeysYLPIt/b+nPoUleM9ZMb742aZiC0LBnT61Y/bOKG69pqANzQ13ZFBfNjqgTPdqHM4iN1Ijzm
	QHORMUL6h7rG0IY1sJjZRqP+sXsh9nyuRwYMttfIbixozyRiBA2TAzH0=
X-Google-Smtp-Source: AGHT+IE8BMZGXn3e3+Odr4QpT5aqczHVeg+2m0ardriFrn+W6qy/cyJSWdu/KFWbM1gO3dPBG7mgZZw1R7BNOJqbyxog6AtFSrrB
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:6425:b0:7ea:fe9a:8055 with SMTP id
 ca18e2360f4ac-7eafff3441bmr32930239f.2.1717240355125; Sat, 01 Jun 2024
 04:12:35 -0700 (PDT)
Date: Sat, 01 Jun 2024 04:12:35 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000005c8f0a0619d22d65@google.com>
Subject: [syzbot] [xfs?] BUG: corrupted list in xlog_cil_commit
From: syzbot <syzbot+ea15576a86ef3f03216a@syzkaller.appspotmail.com>
To: chandan.babu@oracle.com, djwong@kernel.org, linux-kernel@vger.kernel.org, 
	linux-xfs@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    cc8ed4d0a848 Merge tag 'drm-fixes-2024-06-01' of https://g..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17039cba980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=733cc7a95171d8e7
dashboard link: https://syzkaller.appspot.com/bug?extid=ea15576a86ef3f03216a
compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
userspace arch: i386

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7bc7510fe41f/non_bootable_disk-cc8ed4d0.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/36abdd995432/vmlinux-cc8ed4d0.xz
kernel image: https://storage.googleapis.com/syzbot-assets/5e4e0a6f67db/bzImage-cc8ed4d0.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+ea15576a86ef3f03216a@syzkaller.appspotmail.com

list_add corruption. prev->next should be next (ffffe8ffad379458), but was ffffe8ffad379546. (prev=ffffe8ffad379458).
------------[ cut here ]------------
kernel BUG at lib/list_debug.c:32!
Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN NOPTI
CPU: 3 PID: 57 Comm: kworker/3:1 Not tainted 6.10.0-rc1-syzkaller-00267-gcc8ed4d0a848 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Workqueue: xfs-conv/loop2 xfs_end_io
RIP: 0010:__list_add_valid_or_report+0xbe/0x100 lib/list_debug.c:32
Code: e9 fc 90 0f 0b 48 89 d9 48 c7 c7 20 c0 8f 8b e8 88 50 e9 fc 90 0f 0b 48 89 f1 48 c7 c7 a0 c0 8f 8b 48 89 de e8 73 50 e9 fc 90 <0f> 0b 48 89 f2 48 89 d9 48 89 ee 48 c7 c7 20 c1 8f 8b e8 5b 50 e9
RSP: 0000:ffffc9000077f450 EFLAGS: 00010286
RAX: 0000000000000075 RBX: ffffe8ffad379458 RCX: ffffffff816f3159
RDX: 0000000000000000 RSI: ffffffff816fbd56 RDI: 0000000000000005
RBP: ffff88804c565d18 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000007 R12: ffffe8ffad379458
R13: ffff88804c565cb0 R14: ffff88804c565d18 R15: ffffe8ffad379440
FS:  0000000000000000(0000) GS:ffff88802c300000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000033533000 CR3: 000000004c7bc000 CR4: 0000000000350ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 __list_add_valid include/linux/list.h:88 [inline]
 __list_add include/linux/list.h:150 [inline]
 list_add_tail include/linux/list.h:183 [inline]
 xlog_cil_insert_items fs/xfs/xfs_log_cil.c:675 [inline]
 xlog_cil_commit+0x125b/0x32d0 fs/xfs/xfs_log_cil.c:1593
 __xfs_trans_commit+0x346/0xe90 fs/xfs/xfs_trans.c:1020
 xfs_trans_roll+0x1a9/0x430 fs/xfs/xfs_trans.c:1168
 xfs_defer_trans_roll+0x1b8/0x610 fs/xfs/libxfs/xfs_defer.c:478
 xfs_defer_finish_noroll+0x6b2/0x1490 fs/xfs/libxfs/xfs_defer.c:687
 __xfs_trans_commit+0x941/0xe90 fs/xfs/xfs_trans.c:980
 xfs_iomap_write_unwritten+0x32e/0x9d0 fs/xfs/xfs_iomap.c:649
 xfs_end_ioend+0x3e4/0x530 fs/xfs/xfs_aops.c:131
 xfs_end_io+0x217/0x340 fs/xfs/xfs_aops.c:173
 process_one_work+0x958/0x1ad0 kernel/workqueue.c:3231
 process_scheduled_works kernel/workqueue.c:3312 [inline]
 worker_thread+0x6c8/0xf70 kernel/workqueue.c:3393
 kthread+0x2c1/0x3a0 kernel/kthread.c:389
 ret_from_fork+0x45/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:__list_add_valid_or_report+0xbe/0x100 lib/list_debug.c:32
Code: e9 fc 90 0f 0b 48 89 d9 48 c7 c7 20 c0 8f 8b e8 88 50 e9 fc 90 0f 0b 48 89 f1 48 c7 c7 a0 c0 8f 8b 48 89 de e8 73 50 e9 fc 90 <0f> 0b 48 89 f2 48 89 d9 48 89 ee 48 c7 c7 20 c1 8f 8b e8 5b 50 e9
RSP: 0000:ffffc9000077f450 EFLAGS: 00010286
RAX: 0000000000000075 RBX: ffffe8ffad379458 RCX: ffffffff816f3159
RDX: 0000000000000000 RSI: ffffffff816fbd56 RDI: 0000000000000005
RBP: ffff88804c565d18 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000007 R12: ffffe8ffad379458
R13: ffff88804c565cb0 R14: ffff88804c565d18 R15: ffffe8ffad379440
FS:  0000000000000000(0000) GS:ffff88802c300000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000033533000 CR3: 000000004c7bc000 CR4: 0000000000350ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


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
