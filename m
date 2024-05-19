Received: from mail-io1-f79.google.com (mail-io1-f79.google.com [209.85.166.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0310245BE3
	for <linux-xfs@vger.kernel.org>; Sun, 19 May 2024 15:13:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.79
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716131615; cv=none; b=aZ7AHWScbdDwACLB/Xx4/hi5XdmAfDvDOO/qmEhgKozm8jGQxGnLndC7z9tOubLla0IRaDfEXXK/L01uSjskjG1dE39gH2/8nvnOdPY0j6K806xGkckeisGIVEQbm3MgzqL/GOm0tEswwe8Fkjel6nHg2g4dJ+nZQTvSVoMA34U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716131615; c=relaxed/simple;
	bh=MJUPxX56HGGrIK4aaikbev83k3zRKcYGHMLd8xLpd8s=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=Q+J0c6Y3pHzT9W6RpzAeIoO/MwryxgHvHULDazCZ0WGp5tHjC5aRQCT19a3MWJmpnevzb5CoWq/UjrLv1gv178EGm5eYF+BESb6jgenceOygVEy3Jt17K6Mh3dJW5n2p7HAXtTG8g7wYuNef9E3Bwa4iu2Zj2HwzPR+cGBtSJlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f79.google.com with SMTP id ca18e2360f4ac-7e1be009e6eso1090763239f.2
        for <linux-xfs@vger.kernel.org>; Sun, 19 May 2024 08:13:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716131613; x=1716736413;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=smR1dJ/4o22GjiEDZr5sAywceevYZmvv3tjC4yjOxUw=;
        b=DskH2GMNO+pjKrKaXs62kgW+EP5MGzNQOtC7wje13UmHlgSdmMCdN6r6Szr6Qs31xq
         T4++F1NLKf1znGkGQKBY5nBWmDpmMRz/Gr9oztRhWSiQZjXnbpuWwg2TIXDK3lO+Ez4T
         lkyw1Z05nQ7g0jVw8oYtMibO8AfzeUGZWJ7H/xBxuQamkmuDzZixJj5p0dDVDxDZsMAi
         S+WrZP/dhKmehDk7BppJ245sXDqTf+zNQOlSc6YZ0haUEpKzpotvDIZFFs1hjQE7oE1m
         n1MNnQ3gQ6/1Bd80COLlBvZRQwOnZ/D8iGQljHQfJb2Jw0RDjZ5VFh+KeErebpantDHv
         F0gw==
X-Forwarded-Encrypted: i=1; AJvYcCU26vENy24QVA7QNlVFY2ugN9Pk4isR/NYn9CLFhxoc45Ew6+P6f8HzEmFdmMNbCbw8d1buHOnPzneEYonNCudw4/dTHbfKYqCM
X-Gm-Message-State: AOJu0YxUezE1lVgfNOWztTwomsEJF1kQFNo4izzz/4/lnFeMSOmuSHX5
	BZuIzFGpz6sIpguwzeHBlsRwk47lm9YQ+0cSuozuouC6jYiec+CdB8ETICdD6M8132TO5nM+mB/
	Xndw3KYojdycc7EhDDQkPTPV7BuP0uhmpO/4n+LMM7yKe/+S5+Wg+xAg=
X-Google-Smtp-Source: AGHT+IGmPDAzTX4BtsSK4GI1NujT+CdfFC3Zawbq8lFRZwcgyThaGAyOKTQYTz4r8OGqJ6rs1iy8kN42kjCjl4hpqfLuRea+yipC
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:1609:b0:7de:da9b:21f4 with SMTP id
 ca18e2360f4ac-7e1b5208d2amr91328839f.2.1716131613163; Sun, 19 May 2024
 08:13:33 -0700 (PDT)
Date: Sun, 19 May 2024 08:13:33 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000030d1420618d00731@google.com>
Subject: [syzbot] [xfs?] general protection fault in xfs_destroy_mount_workqueues
From: syzbot <syzbot+8905ded1b49ae88b96a6@syzkaller.appspotmail.com>
To: chandan.babu@oracle.com, djwong@kernel.org, linux-kernel@vger.kernel.org, 
	linux-xfs@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    3d25a941ea50 Merge tag 'block-6.9-20240503' of git://git.k..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=16832004980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3310e643b6ef5d69
dashboard link: https://syzkaller.appspot.com/bug?extid=8905ded1b49ae88b96a6
compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7bc7510fe41f/non_bootable_disk-3d25a941.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/9d8ed74e49f1/vmlinux-3d25a941.xz
kernel image: https://storage.googleapis.com/syzbot-assets/d724e9151b52/bzImage-3d25a941.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+8905ded1b49ae88b96a6@syzkaller.appspotmail.com

XFS (loop3): Unmounting Filesystem 4194cad6-cad4-4798-ac4c-c2118f686eb1
general protection fault, probably for non-canonical address 0xe01ffbf1100d6a7e: 0000 [#1] PREEMPT SMP KASAN NOPTI
KASAN: maybe wild-memory-access in range [0x00ffff88806b53f0-0x00ffff88806b53f7]
CPU: 2 PID: 1404 Comm: syz-executor.3 Not tainted 6.9.0-rc6-syzkaller-00227-g3d25a941ea50 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:__lock_acquire+0xe3e/0x3b30 kernel/locking/lockdep.c:5005
Code: 11 00 00 39 05 f3 80 de 11 0f 82 be 05 00 00 ba 01 00 00 00 e9 e4 00 00 00 48 b8 00 00 00 00 00 fc ff df 4c 89 e2 48 c1 ea 03 <80> 3c 02 00 0f 85 82 1f 00 00 49 81 3c 24 a0 2c a1 92 0f 84 98 f2
RSP: 0018:ffffc90004047ab8 EFLAGS: 00010006
RAX: dffffc0000000000 RBX: 0000000000000001 RCX: 0000000000000000
RDX: 001ffff1100d6a7e RSI: ffff888052a24880 RDI: 00ffff88806b53f1
RBP: 0000000000000000 R08: 0000000000000001 R09: 0000000000000001
R10: ffffffff8f9f5217 R11: 0000000000000003 R12: 00ffff88806b53f1
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000001
FS:  0000555587484480(0000) GS:ffff88806b400000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffd649d1c18 CR3: 000000005b7a0000 CR4: 0000000000350ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 lock_acquire kernel/locking/lockdep.c:5754 [inline]
 lock_acquire+0x1b1/0x560 kernel/locking/lockdep.c:5719
 __raw_spin_lock_irq include/linux/spinlock_api_smp.h:119 [inline]
 _raw_spin_lock_irq+0x36/0x50 kernel/locking/spinlock.c:170
 put_pwq_unlocked kernel/workqueue.c:1671 [inline]
 put_pwq_unlocked kernel/workqueue.c:1664 [inline]
 destroy_workqueue+0x5df/0xaa0 kernel/workqueue.c:5739
 xfs_destroy_mount_workqueues+0x37/0x150 fs/xfs/xfs_super.c:599
 xfs_fs_put_super+0x134/0x160 fs/xfs/xfs_super.c:1141
 generic_shutdown_super+0x159/0x3d0 fs/super.c:641
 kill_block_super+0x3b/0x90 fs/super.c:1675
 xfs_kill_sb+0x15/0x50 fs/xfs/xfs_super.c:2026
 deactivate_locked_super+0xbe/0x1a0 fs/super.c:472
 deactivate_super+0xde/0x100 fs/super.c:505
 cleanup_mnt+0x222/0x450 fs/namespace.c:1267
 task_work_run+0x14e/0x250 kernel/task_work.c:180
 resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:114 [inline]
 exit_to_user_mode_prepare include/linux/entry-common.h:328 [inline]
 __syscall_exit_to_user_mode_work kernel/entry/common.c:207 [inline]
 syscall_exit_to_user_mode+0x278/0x2a0 kernel/entry/common.c:218
 do_syscall_64+0xdc/0x260 arch/x86/entry/common.c:89
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f9526a7efd7
Code: b0 ff ff ff f7 d8 64 89 01 48 83 c8 ff c3 0f 1f 44 00 00 31 f6 e9 09 00 00 00 66 0f 1f 84 00 00 00 00 00 b8 a6 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 01 c3 48 c7 c2 b0 ff ff ff f7 d8 64 89 02 b8
RSP: 002b:00007ffd649d23c8 EFLAGS: 00000246 ORIG_RAX: 00000000000000a6
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 00007f9526a7efd7
RDX: 0000000000000000 RSI: 0000000000000009 RDI: 00007ffd649d2480
RBP: 00007ffd649d2480 R08: 0000000000000000 R09: 0000000000000000
R10: 00000000ffffffff R11: 0000000000000246 R12: 00007ffd649d3540
R13: 00007f9526ac83b9 R14: 00000000000ddcc5 R15: 0000000000000014
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:__lock_acquire+0xe3e/0x3b30 kernel/locking/lockdep.c:5005
Code: 11 00 00 39 05 f3 80 de 11 0f 82 be 05 00 00 ba 01 00 00 00 e9 e4 00 00 00 48 b8 00 00 00 00 00 fc ff df 4c 89 e2 48 c1 ea 03 <80> 3c 02 00 0f 85 82 1f 00 00 49 81 3c 24 a0 2c a1 92 0f 84 98 f2
RSP: 0018:ffffc90004047ab8 EFLAGS: 00010006
RAX: dffffc0000000000 RBX: 0000000000000001 RCX: 0000000000000000
RDX: 001ffff1100d6a7e RSI: ffff888052a24880 RDI: 00ffff88806b53f1
RBP: 0000000000000000 R08: 0000000000000001 R09: 0000000000000001
R10: ffffffff8f9f5217 R11: 0000000000000003 R12: 00ffff88806b53f1
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000001
FS:  0000555587484480(0000) GS:ffff88806b400000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffd649d1c18 CR3: 000000005b7a0000 CR4: 0000000000350ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess):
   0:	11 00                	adc    %eax,(%rax)
   2:	00 39                	add    %bh,(%rcx)
   4:	05 f3 80 de 11       	add    $0x11de80f3,%eax
   9:	0f 82 be 05 00 00    	jb     0x5cd
   f:	ba 01 00 00 00       	mov    $0x1,%edx
  14:	e9 e4 00 00 00       	jmp    0xfd
  19:	48 b8 00 00 00 00 00 	movabs $0xdffffc0000000000,%rax
  20:	fc ff df
  23:	4c 89 e2             	mov    %r12,%rdx
  26:	48 c1 ea 03          	shr    $0x3,%rdx
* 2a:	80 3c 02 00          	cmpb   $0x0,(%rdx,%rax,1) <-- trapping instruction
  2e:	0f 85 82 1f 00 00    	jne    0x1fb6
  34:	49 81 3c 24 a0 2c a1 	cmpq   $0xffffffff92a12ca0,(%r12)
  3b:	92
  3c:	0f                   	.byte 0xf
  3d:	84                   	.byte 0x84
  3e:	98                   	cwtl
  3f:	f2                   	repnz


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
