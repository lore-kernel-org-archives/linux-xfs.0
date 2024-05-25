Received: from mail-il1-f208.google.com (mail-il1-f208.google.com [209.85.166.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04198F9F8
	for <linux-xfs@vger.kernel.org>; Sat, 25 May 2024 18:13:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716660806; cv=none; b=JUPdOjHtWPoiFN8wrkUYwJnhqSG1Ab8vYKysJHZ4y0siYvGW8EarWC9knOlOhiuFxTAppoADCEQd7f2uDyU9axhp+6Q2/VQzMaSaqr5XhZ40k/bo5vYHyWocRZ5BP3+BDky76QJ73vmkro99xWMr7OpDCe47Ci1eKluUK+eVpR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716660806; c=relaxed/simple;
	bh=E7yg1jo1ugTYXdCsqnyGkXutUYOxpqIWT1O7iAc9fxg=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=Nm/VtXYoKLcGZRow/C09dZigIuxyZIHU4gZtuQlkK5KqgN1I4NaGvfp0kINAiWG9FVWMq1zCnOSAIde3GGvtGAZs+4sonTeObxoubwZAJsGBdf2SrgaSzrD6xpRh4dlrwwy0713UfexTGwOud0BybU6N6Ex9CyfGLzfVABAXFiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f208.google.com with SMTP id e9e14a558f8ab-3737b3ee909so19807795ab.2
        for <linux-xfs@vger.kernel.org>; Sat, 25 May 2024 11:13:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716660804; x=1717265604;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=sHk/zeMEFPra7B+OBp8VDhWRW437hyoA2QKN8GIJ7rA=;
        b=L2vRlq3nR/vUvr8Hfiph4VyfuzIM2dXoV8BAO8zVgXiE1zDd2hexfopIUNXfFuIKxp
         ZiHxR9+5m6HGz7fKZg5YmMg8tfT5u9JUIhLflSuwweGVUFMHStNlUbZxZSGOg/53WBdl
         1homINhDwXpb4wr5QbLv9BarAM9e4V+8Y+cgOKfDiuc4AQDajNT6U1O/YBBqxpqb/8LE
         cQ7RH3VtXfQyHiGftnvXbL3L2Tfbccb2GBi17axhpMTDIIriXUC3MLtZcxaAPQNgSc2G
         Kc4B1nsIfiq3kb3bdUFlzt4AOpZTdtc76WPmo+F6gYIc2Sk6k7z93qTbBZ6o8rpj93pd
         7wug==
X-Forwarded-Encrypted: i=1; AJvYcCXnuGQxZpbGDp6a5/r9JCywGxp66Fo2vbvlgfiAI5jnk84GtP4hDQ1Ycg2aG3qVXSaDe+M+HRsRxHiWzyDL7g0lEpDcWwMvUfYA
X-Gm-Message-State: AOJu0YxSxlkHsFYdw2HYQIc9hqvmn+1D5BXRvmSGawtoMSLoEBoiXp4J
	ezY35MXZZ+JXi99UAY5rl69tby+0hTPcEKMxn3eYGORXPQD3RkR9kZRCMWlJZqo0KfHQR8agNxe
	32SeSi+27kN67r00617YQeI6mf9ZSBYcuuO58JHnoSJqOuHa/mtBTaJk=
X-Google-Smtp-Source: AGHT+IGwleP/xZ8NyYVvSZOqNxY4RqQGqH0/5WcKJzRUGWW3GuXe9sbzjf/VnqI6SkLAjH7FnbsiB/3ZK5v3stJ9+gDirkPTmthZ
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:156f:b0:36d:e026:88f9 with SMTP id
 e9e14a558f8ab-3737b358795mr4609405ab.4.1716660804280; Sat, 25 May 2024
 11:13:24 -0700 (PDT)
Date: Sat, 25 May 2024 11:13:24 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000070775206194b3dd0@google.com>
Subject: [syzbot] [xfs?] WARNING in mod_delayed_work_on
From: syzbot <syzbot+d9c37490b32d66c6bc78@syzkaller.appspotmail.com>
To: chandan.babu@oracle.com, djwong@kernel.org, linux-kernel@vger.kernel.org, 
	linux-xfs@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    8f6a15f095a6 Merge tag 'cocci-for-6.10' of git://git.kerne..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=157a2844980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=cec8dc951d3cca13
dashboard link: https://syzkaller.appspot.com/bug?extid=d9c37490b32d66c6bc78
compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
userspace arch: i386

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7bc7510fe41f/non_bootable_disk-8f6a15f0.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/e76220459de3/vmlinux-8f6a15f0.xz
kernel image: https://storage.googleapis.com/syzbot-assets/584cb4587029/bzImage-8f6a15f0.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+d9c37490b32d66c6bc78@syzkaller.appspotmail.com

XFS (loop0): Quotacheck needed: Please wait.
XFS (loop0): Quotacheck: Done.
netlink: 'syz-executor.0': attribute type 1 has an invalid length.
------------[ cut here ]------------
WARNING: CPU: 0 PID: 5436 at kernel/workqueue.c:2518 __queue_delayed_work+0x268/0x2e0 kernel/workqueue.c:2518
Modules linked in:
CPU: 0 PID: 5436 Comm: syz-executor.0 Not tainted 6.9.0-syzkaller-10323-g8f6a15f095a6 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:__queue_delayed_work+0x268/0x2e0 kernel/workqueue.c:2518
Code: 0f 0b 90 e9 dc fd ff ff e8 05 dd 34 00 90 0f 0b 90 e9 00 fe ff ff e8 f7 dc 34 00 90 0f 0b 90 e9 23 fe ff ff e8 e9 dc 34 00 90 <0f> 0b 90 e9 46 fe ff ff e8 6b 17 92 00 e9 ae fe ff ff e8 d1 dc 34
RSP: 0018:ffffc90007a9fc28 EFLAGS: 00010083
RAX: 00000000000284b9 RBX: ffffe8ffad067510 RCX: ffffc90002d89000
RDX: 0000000000040000 RSI: ffffffff8159a7b7 RDI: ffffe8ffad067560
RBP: 0000000000000001 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffff888058dd0400
R13: 0000000000000000 R14: ffffe8ffad067518 R15: 0000000000000001
FS:  0000000000000000(0000) GS:ffff88802c000000(0063) knlGS:00000000f5f1db40
CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
CR2: 0000000032040000 CR3: 000000004ae12000 CR4: 0000000000350ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 mod_delayed_work_on+0x19a/0x1d0 kernel/workqueue.c:2608
 xfs_inodegc_queue fs/xfs/xfs_icache.c:2113 [inline]
 xfs_inode_mark_reclaimable+0x5c3/0xf60 fs/xfs/xfs_icache.c:2149
 destroy_inode+0xc4/0x1b0 fs/inode.c:311
 iput_final fs/inode.c:1741 [inline]
 iput.part.0+0x5a8/0x7f0 fs/inode.c:1767
 iput+0x5c/0x80 fs/inode.c:1757
 dentry_unlink_inode+0x295/0x480 fs/dcache.c:400
 __dentry_kill+0x1d0/0x600 fs/dcache.c:603
 dput.part.0+0x4b1/0x9b0 fs/dcache.c:845
 dput+0x1f/0x30 fs/dcache.c:835
 __fput+0x54e/0xbb0 fs/file_table.c:430
 __fput_sync+0x47/0x50 fs/file_table.c:507
 __do_sys_close fs/open.c:1556 [inline]
 __se_sys_close fs/open.c:1541 [inline]
 __ia32_sys_close+0x86/0x100 fs/open.c:1541
 do_syscall_32_irqs_on arch/x86/entry/common.c:165 [inline]
 __do_fast_syscall_32+0x75/0x120 arch/x86/entry/common.c:386
 do_fast_syscall_32+0x32/0x80 arch/x86/entry/common.c:411
 entry_SYSENTER_compat_after_hwframe+0x84/0x8e
RIP: 0023:0xf732b579
Code: b8 01 10 06 03 74 b4 01 10 07 03 74 b0 01 10 08 03 74 d8 01 00 00 00 00 00 00 00 00 00 00 00 00 00 51 52 55 89 e5 0f 34 cd 80 <5d> 5a 59 c3 90 90 90 90 8d b4 26 00 00 00 00 8d b4 26 00 00 00 00
RSP: 002b:00000000f5f1d5ac EFLAGS: 00000292 ORIG_RAX: 0000000000000006
RAX: ffffffffffffffda RBX: 0000000000000004 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000292 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
 </TASK>
----------------
Code disassembly (best guess), 2 bytes skipped:
   0:	10 06                	adc    %al,(%rsi)
   2:	03 74 b4 01          	add    0x1(%rsp,%rsi,4),%esi
   6:	10 07                	adc    %al,(%rdi)
   8:	03 74 b0 01          	add    0x1(%rax,%rsi,4),%esi
   c:	10 08                	adc    %cl,(%rax)
   e:	03 74 d8 01          	add    0x1(%rax,%rbx,8),%esi
  1e:	00 51 52             	add    %dl,0x52(%rcx)
  21:	55                   	push   %rbp
  22:	89 e5                	mov    %esp,%ebp
  24:	0f 34                	sysenter
  26:	cd 80                	int    $0x80
* 28:	5d                   	pop    %rbp <-- trapping instruction
  29:	5a                   	pop    %rdx
  2a:	59                   	pop    %rcx
  2b:	c3                   	ret
  2c:	90                   	nop
  2d:	90                   	nop
  2e:	90                   	nop
  2f:	90                   	nop
  30:	8d b4 26 00 00 00 00 	lea    0x0(%rsi,%riz,1),%esi
  37:	8d b4 26 00 00 00 00 	lea    0x0(%rsi,%riz,1),%esi


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
