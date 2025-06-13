Received: from mail-io1-f78.google.com (mail-io1-f78.google.com [209.85.166.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE07E1DF258
	for <linux-xfs@vger.kernel.org>; Fri, 13 Jun 2025 23:30:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749857436; cv=none; b=auALGbBa5d+QPD+emnuy3cTDsrkzbSHWCw+bNHiCmZ+TeRqJXxRQeMqNC7xRtEjdYMVvD55xRIiDCak257kLX2x3YD9oDW9EJy+g9C0kA3T6qjRdbXJTCN7YR5sw0rmJgeziVmW84KFB9fx06rTcjc04vhtxHvvrfdw0Vc/80X4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749857436; c=relaxed/simple;
	bh=0abnlyb7tMAEy1Y0XS37gQsAYKpdOw5VGv59YK1IzDs=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=X5awtPkz2LdMNH46nm95VPl+A/YlwlDPPOoeqnq6kuYDQDSswwuqIQeTSF2tQ3ex/t9c2uzWJ05hzmirHThTe4wO0ReBPuSCalsTOIc0+KekKyMUfXMfnuvWpO7QLjnFYbk2ELtR3nbU+8RZRzjAOE4GHL72O7+EdsaTcanFm7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f78.google.com with SMTP id ca18e2360f4ac-86f4e2434b6so311456239f.2
        for <linux-xfs@vger.kernel.org>; Fri, 13 Jun 2025 16:30:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749857434; x=1750462234;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vF7xs1A3Q2dAycwY5p/OJbr9P/yojYK9Yt6rhyL/AFs=;
        b=tJ0x6m66pt08cfKOGjELZjSqU6vT1p9SHgFkvoAvxnCrFgnktk3rYT6AtwMboq3Wk+
         3MjYTXncHWnrGFxlONcmVDEONvxfpJr6GcJ/XvlR/WbCTSG14yb7vLyqcJh8tql8896k
         IhZ3na75uUzzqfzz0t1oRH7XrWTwbo+dx7J5cT2HfLiIu+dpZ+lywD7KXlGbIa1oKV4N
         ngKvwwXJ0AL4ho7F/d/wsBr9PoVFK1MTJmQDv99MzkHga9C6VpByyAWr9ct2IpQ7gMyP
         V+EOTEE/IveL660XXUcn2Mnp7Y9GIoX2OmhYKwwgWMhnSgQqlZt0dJcORAplXcTeu4pn
         W9Rg==
X-Forwarded-Encrypted: i=1; AJvYcCUd8XRV6qAvGkNuI4rudyJ7mgqbieDrjCOkX8vk/17n4qxFxZ84uGeFZrDQWg+fA0O0eDvDzTFMTwY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxf4HgWURrWvH8cD6ohkMPoYCVoy7xIqBcCEaUlmNVfta/QGbr0
	eB7HKOGORwj7KtNtQzBiUYZ0r5I7n47W/DxF0iy5X7RcaKWm2XPxQx3uszQV5PX9FmKSJmp4Rro
	tWHCH3CVMCYcSgyaoNMk68aNDS9EkZoB61/+RaBGIBkzZrdTMqnEwXVq+jlk=
X-Google-Smtp-Source: AGHT+IGRAA9OJyHdZx3olCjGPopW4j7o8RyPYuTFqvQIi0A6jUryimHBx8pugZDlISqy0X3182xYzFab7qTndPBx+vXNFNIaT6dB
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:168b:b0:3dc:7cc1:b731 with SMTP id
 e9e14a558f8ab-3de07c21db4mr17551605ab.0.1749857433818; Fri, 13 Jun 2025
 16:30:33 -0700 (PDT)
Date: Fri, 13 Jun 2025 16:30:33 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <684cb499.a00a0220.c6bd7.0010.GAE@google.com>
Subject: [syzbot] [iomap?] [erofs?] WARNING in iomap_iter (5)
From: syzbot <syzbot+d8f000c609f05f52d9b5@syzkaller.appspotmail.com>
To: brauner@kernel.org, chao@kernel.org, djwong@kernel.org, 
	linux-erofs@lists.ozlabs.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com, xiang@kernel.org
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    27605c8c0f69 Merge tag 'net-6.16-rc2' of git://git.kernel...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=171079d4580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3a936e3316f9e2dc
dashboard link: https://syzkaller.appspot.com/bug?extid=d8f000c609f05f52d9b5
compiler:       Debian clang version 20.1.6 (++20250514063057+1e4d39e07757-1~exp1~20250514183223.118), Debian LLD 20.1.6
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1725310c580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=115e0e82580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-27605c8c.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/c55edb669703/vmlinux-27605c8c.xz
kernel image: https://storage.googleapis.com/syzbot-assets/e12830584492/bzImage-27605c8c.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/36391cabb242/mount_2.gz
  fsck result: failed (log: https://syzkaller.appspot.com/x/fsck.log?x=165e0e82580000)

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+d8f000c609f05f52d9b5@syzkaller.appspotmail.com

erofs (device loop0): EXPERIMENTAL EROFS subpage compressed block support in use. Use at your own risk!
erofs (device loop0): mounted with root inode @ nid 36.
------------[ cut here ]------------
WARNING: CPU: 0 PID: 5317 at fs/iomap/iter.c:33 iomap_iter_done fs/iomap/iter.c:33 [inline]
WARNING: CPU: 0 PID: 5317 at fs/iomap/iter.c:33 iomap_iter+0x87c/0xdf0 fs/iomap/iter.c:113
Modules linked in:
CPU: 0 UID: 0 PID: 5317 Comm: syz-executor245 Not tainted 6.16.0-rc1-syzkaller-00101-g27605c8c0f69 #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:iomap_iter_done fs/iomap/iter.c:33 [inline]
RIP: 0010:iomap_iter+0x87c/0xdf0 fs/iomap/iter.c:113
Code: cc cc cc e8 a6 eb 6b ff 90 0f 0b 90 e9 31 f8 ff ff e8 98 eb 6b ff 90 0f 0b 90 bd fb ff ff ff e9 ad fb ff ff e8 85 eb 6b ff 90 <0f> 0b 90 e9 22 fd ff ff e8 77 eb 6b ff 90 0f 0b 90 e9 53 fd ff ff
RSP: 0018:ffffc9000d08f808 EFLAGS: 00010293
RAX: ffffffff8254736b RBX: ffffc9000d08f920 RCX: ffff88803a692440
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000074
RBP: 1ffff92001a11f2a R08: ffffea00010c5277 R09: 1ffffd4000218a4e
R10: dffffc0000000000 R11: fffff94000218a4f R12: 0000000000000074
R13: 0000000000000000 R14: ffffc9000d08f950 R15: 1ffff92001a11f25
FS:  0000555562dab380(0000) GS:ffff88808d252000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffeb97cc968 CR3: 0000000043323000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 iomap_fiemap+0x117/0x530 fs/iomap/fiemap.c:79
 ioctl_fiemap fs/ioctl.c:220 [inline]
 do_vfs_ioctl+0x16d3/0x1990 fs/ioctl.c:841
 __do_sys_ioctl fs/ioctl.c:905 [inline]
 __se_sys_ioctl+0x82/0x170 fs/ioctl.c:893
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fbc6028fe59
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 f1 17 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffccc462b68 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fbc6028fe59
RDX: 0000200000000580 RSI: 00000000c020660b RDI: 0000000000000005
RBP: 00007fbc603045f0 R08: 0000555562dac4c0 R09: 0000555562dac4c0
R10: 00000000000001ca R11: 0000000000000246 R12: 00007ffccc462b90
R13: 00007ffccc462db8 R14: 431bde82d7b634db R15: 00007fbc602d903b
 </TASK>


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
