Received: from mail-il1-f208.google.com (mail-il1-f208.google.com [209.85.166.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFE0742A8F
	for <linux-xfs@vger.kernel.org>; Sat, 14 Dec 2024 21:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734211762; cv=none; b=NgD31uQMmLJfKIO917JZB8IgQw9cNeTMgrqTWZBkqcDyiJVEa0JCSHejcVwEqtBFbE36ZDV/kLk4wskZvQfxqlZqaUE30e+ntXBvII0l8PmBa10K7+o+dp9dW+SAuRC7Q6k4gqx6umhuSgRky4qdiZqV1EN5e1o73imDtcJZUWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734211762; c=relaxed/simple;
	bh=AKu2GiIrzTepf6osi+gd35zsxDpl3zr6/O+hlAOcg3k=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=I1YRO2TGNDuM8TYH1sHQfkgs/aqVxaXYi+fNb1ReeCk7fi+97Ios915ODblszJfrHgTGKUfGfkO4qUbbIVSlywo2uk2qvIxSTJKTwPsRpKxcr0Lf43E6xKvz+mdSetNO2P/Ra8/iNv+VjUBbI1E2n/E+klUxdDS2ftCAyZGPU5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f208.google.com with SMTP id e9e14a558f8ab-3abe7375ba6so60274765ab.3
        for <linux-xfs@vger.kernel.org>; Sat, 14 Dec 2024 13:29:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734211760; x=1734816560;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=paHaFcfWBXLMk205W3buDhn9iPt32Zvb/Ivu3tiWL5E=;
        b=hDLKwEJB4EsEsR3Cl4Zd+fQIpo3lbMVWswB8ak0PCt4/JuNWFrAG75U374rZyrqb9w
         mgSYcbBG/lvFg7FkvMqjkQEg71nKxc1uFACs6IuvDfwGlskj+2RSU0NZDsPwj/u+hclM
         uOv0Zag2q7ZxOTmjRJoIEJ7sHgJYTTpY/YEJbcIWwKZl04UY7VBYAzcOwtCNcR93YSYx
         f3cpINaJ1VUg2ZcgZ1P6ehM0mVFmJX2394kL2Yg89s8IPmnukJ5M5rjybefVslQ5B3pO
         l1QjTr2lx2hzaPE0C5p5NBdFLH7xG0EUTGeE3pDAl1c+S6+Nq+I8rMKh6VdrStx8Mzlw
         bhqw==
X-Forwarded-Encrypted: i=1; AJvYcCViIedV1j6bHpGCUvMKq/PJec63tD/E0c8yFMu2UDC/z4JXw77QdNpCfxv9BzAzoC+DHWITShv7QJs=@vger.kernel.org
X-Gm-Message-State: AOJu0YxNvq1PpM8GSbxSUBVA7B4NDP9vfityJZLtGaiK98ml65fZCZKY
	q7o4wWv/SFb+SLZ3CI8V8ANElnvQFvUdb7Vt4Qz7PTijxr6snlxS/ikDJlkmGWrS6lTmXB4ZPJ7
	2kU07mcHC7QjlI5QqWjuddzq8Y38G6i2mCdDsjFLEUcM0cfeBnSxbgmQ=
X-Google-Smtp-Source: AGHT+IHxAtIaF3EuSR5gJb/0dm1RwTvHyOG5erp+QIuBp3KjmkrGTz390sp6Tb5nGh6an3lBqtxFuWv5P+wwgxbhnTJRAYIWDkuO
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:18ca:b0:3a7:d7dd:e70f with SMTP id
 e9e14a558f8ab-3afeee787ecmr98990225ab.12.1734211760152; Sat, 14 Dec 2024
 13:29:20 -0800 (PST)
Date: Sat, 14 Dec 2024 13:29:20 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <675df8b0.050a0220.37aaf.00d8.GAE@google.com>
Subject: [syzbot] [xfs?] BUG: unable to handle kernel paging request in xfs_destroy_mount_workqueues
From: syzbot <syzbot+63340199267472536cf4@syzkaller.appspotmail.com>
To: cem@kernel.org, chandan.babu@oracle.com, djwong@kernel.org, 
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    2e7aff49b5da Merge branches 'for-next/core' and 'for-next/..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=13f5a730580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=696fb014d05da3a3
dashboard link: https://syzkaller.appspot.com/bug?extid=63340199267472536cf4
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
userspace arch: arm64

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/ef408f67fde3/disk-2e7aff49.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/414ac17a20dc/vmlinux-2e7aff49.xz
kernel image: https://storage.googleapis.com/syzbot-assets/a93415d2a7e7/Image-2e7aff49.gz.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+63340199267472536cf4@syzkaller.appspotmail.com

XFS (loop3): Unmounting Filesystem ca7e2101-b8f1-4838-8e2d-7637b90620e6
Unable to handle kernel paging request at virtual address 001f7fe000182113
Mem abort info:
  ESR = 0x0000000096000004
  EC = 0x25: DABT (current EL), IL = 32 bits
  SET = 0, FnV = 0
  EA = 0, S1PTW = 0
  FSC = 0x04: level 0 translation fault
Data abort info:
  ISV = 0, ISS = 0x00000004, ISS2 = 0x00000000
  CM = 0, WnR = 0, TnD = 0, TagAccess = 0
  GCS = 0, Overlay = 0, DirtyBit = 0, Xs = 0
[001f7fe000182113] address between user and kernel address ranges
Internal error: Oops: 0000000096000004 [#1] PREEMPT SMP
Modules linked in:
CPU: 0 UID: 0 PID: 6415 Comm: syz-executor Not tainted 6.13.0-rc2-syzkaller-g2e7aff49b5da #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
pstate: 804000c5 (Nzcv daIF +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : __lock_acquire+0xfc/0x7904 kernel/locking/lockdep.c:5089
lr : lock_acquire+0x23c/0x724 kernel/locking/lockdep.c:5849
sp : ffff8000a0d87620
x29: ffff8000a0d878e0 x28: ffff800080367964 x27: 0000000000000000
x26: ffff0001b360b500 x25: 0000000000000000 x24: 0000000000000001
x23: 0000000000000000 x22: 1ffff00011f300ca x21: 00ffff0000c10898
x20: 0000000000000001 x19: 0000000000000000 x18: 1fffe000366c167e
x17: ffff80008f97d000 x16: ffff80008326d65c x15: 0000000000000001
x14: 1fffe00018211000 x13: dfff800000000000 x12: ffff7000141b0eec
x11: ffff8000804648c0 x10: ffff80008f980650 x9 : 00000000000000f3
x8 : 001fffe000182113 x7 : ffff800080367964 x6 : 0000000000000000
x5 : 0000000000000001 x4 : 0000000000000001 x3 : 0000000000000000
x2 : 0000000000000000 x1 : 0000000000000000 x0 : 00ffff0000c10898
Call trace:
 __lock_acquire+0xfc/0x7904 kernel/locking/lockdep.c:5089 (P)
 lock_acquire+0x23c/0x724 kernel/locking/lockdep.c:5849 (L)
 lock_acquire+0x23c/0x724 kernel/locking/lockdep.c:5849
 __raw_spin_lock_irq include/linux/spinlock_api_smp.h:119 [inline]
 _raw_spin_lock_irq+0x58/0x70 kernel/locking/spinlock.c:170
 put_pwq_unlocked kernel/workqueue.c:1662 [inline]
 destroy_workqueue+0x8d8/0xdc0 kernel/workqueue.c:5897
 xfs_destroy_mount_workqueues+0x58/0xdc fs/xfs/xfs_super.c:606
 xfs_fs_put_super+0x11c/0x138 fs/xfs/xfs_super.c:1157
 generic_shutdown_super+0x12c/0x2bc fs/super.c:642
 kill_block_super+0x44/0x90 fs/super.c:1710
 xfs_kill_sb+0x20/0x58 fs/xfs/xfs_super.c:2089
 deactivate_locked_super+0xc4/0x12c fs/super.c:473
 deactivate_super+0xe0/0x100 fs/super.c:506
 cleanup_mnt+0x34c/0x3dc fs/namespace.c:1373
 __cleanup_mnt+0x20/0x30 fs/namespace.c:1380
 task_work_run+0x230/0x2e0 kernel/task_work.c:239
 resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
 do_notify_resume+0x178/0x1f4 arch/arm64/kernel/entry-common.c:151
 exit_to_user_mode_prepare arch/arm64/kernel/entry-common.c:169 [inline]
 exit_to_user_mode arch/arm64/kernel/entry-common.c:178 [inline]
 el0_svc+0xac/0x168 arch/arm64/kernel/entry-common.c:745
 el0t_64_sync_handler+0x84/0x108 arch/arm64/kernel/entry-common.c:762
 el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:600
Code: 9007a8e8 b9465108 340090a8 d343fea8 (386d6908) 
---[ end trace 0000000000000000 ]---
----------------
Code disassembly (best guess):
   0:	9007a8e8 	adrp	x8, 0xf51c000
   4:	b9465108 	ldr	w8, [x8, #1616]
   8:	340090a8 	cbz	w8, 0x121c
   c:	d343fea8 	lsr	x8, x21, #3
* 10:	386d6908 	ldrb	w8, [x8, x13] <-- trapping instruction


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
