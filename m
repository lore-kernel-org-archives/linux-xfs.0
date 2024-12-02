Received: from mail-il1-f208.google.com (mail-il1-f208.google.com [209.85.166.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E0D11804A
	for <linux-xfs@vger.kernel.org>; Mon,  2 Dec 2024 01:48:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733104111; cv=none; b=FMq4aZS2IlmIWmZ1kwmdXvIqKaKTNUuZz+rjapFqKh9bFX3/MAS2LNoNMr0RRPox8CQMrRqGy0tHg3SrkdTi4fMGqHc12g9gDwbjqH3ftkcypeMF1NzptIuhu+iS9wJg4br5joh7+BRb0NvgJdyH2CwMJOLuHZF1KlpeH2mFX6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733104111; c=relaxed/simple;
	bh=9PjllhJm7+CnRDBO7Wnq4qwf6c89AiFMHLsT4Gquj6w=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=UWNgba2/H1oGwHnVWrF7fQJDtsS5k0x7N9cvzQ8JZEVsMVbchO0IS3UBTq+vWFVVEQ7jXP5/zeXl/YKfPrtMhL3wkIJwVXmIiguHZ9jrBgCZ7KaPK3fOaZ74weoVcSnGmoXw0TIe8SCCIwvdvNlHHRjr8pw/4wOJvCOQzpFpeUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f208.google.com with SMTP id e9e14a558f8ab-3a7c729bfbaso36173575ab.0
        for <linux-xfs@vger.kernel.org>; Sun, 01 Dec 2024 17:48:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733104108; x=1733708908;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pdw3pLOY/4L13DYwYHkr5SY7BMmdZN4rlTp/ll+Zuhg=;
        b=O5kXP2wy6njw2S3ppKKu5jrGELiDY6KnVUsgao6pUkwiGl2ocKCRk8w0VtgIs0xnLf
         B9YmgbDBIpNc6qoN5bfD7jlOnCoqQfDmsjhsuwPyM5f20p/djQpBWRNQphOL1hZiv5Xd
         VgVKVxtC1o9YIZRWnT/QT9duVegt9iR4IRvliGII9vd4RHH/RL5YEXhUg9moa3drndz7
         i+E6Tve7xpClzYE8V1u04yzNY0Ca1tJPLJMzVo+sZ0srlMoZYm0PFNaZaECroJ1gDizu
         eU5zMpUNpBuaxZjgtFkMANXMt5PdNNclmtTMQh24pzFC5MqPHig0+QGCiHTB192AEj+x
         eCSw==
X-Forwarded-Encrypted: i=1; AJvYcCVgqlFlz7D174czyLGp3hD4tOmh9vTu6yjDlGUy9mWg4uP+//y9QSgfd1Zp06/jtXMJS8CWk74DkJs=@vger.kernel.org
X-Gm-Message-State: AOJu0YyYV4skiAZEsCYIjq2L8rOn/BSk0hwTDR9TL/WNv1XkZf+ACAP/
	/jXfep/rAZWsPc29FEAbAtAlH3wVbePHuEXUB7/oIVJSS3DSuJUTIgM2pKghYkJSoqljv9j5iO7
	5P3ZpExFlr0GGpwa1ET2n8pQzv9K4UIwLdK9Eb+K+sCw2XiRH/aGi/7s=
X-Google-Smtp-Source: AGHT+IHlK5e6az1KCVW1n7qcXsi4eC/QWGZwwqJfJHtAzIjEiFTIAYNNKxDBollBwVyEwxzO9lR8azPmx8EkPhIIy5hJEgwFIGmq
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a26:b0:3a0:9c99:32d6 with SMTP id
 e9e14a558f8ab-3a7c55e297bmr217700045ab.24.1733104108727; Sun, 01 Dec 2024
 17:48:28 -0800 (PST)
Date: Sun, 01 Dec 2024 17:48:28 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <674d11ec.050a0220.48a03.001c.GAE@google.com>
Subject: [syzbot] [iomap?] WARNING in iomap_zero_iter
From: syzbot <syzbot+af7e25f0384dc888e1bf@syzkaller.appspotmail.com>
To: brauner@kernel.org, djwong@kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    b86545e02e8c Merge tag 'acpi-6.13-rc1-2' of git://git.kern..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=107623c0580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5f0b9d4913852126
dashboard link: https://syzkaller.appspot.com/bug?extid=af7e25f0384dc888e1bf
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-b86545e0.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/00ec87aaa7ee/vmlinux-b86545e0.xz
kernel image: https://storage.googleapis.com/syzbot-assets/fcc70e20d51b/bzImage-b86545e0.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+af7e25f0384dc888e1bf@syzkaller.appspotmail.com

loop0: detected capacity change from 0 to 32768
gfs2: fsid=syz:syz: Trying to join cluster "lock_nolock", "syz:syz"
gfs2: fsid=syz:syz: Now mounting FS (format 1801)...
gfs2: fsid=syz:syz.0: journal 0 mapped with 1 extents in 0ms
gfs2: fsid=syz:syz.0: first mount done, others may mount
------------[ cut here ]------------
WARNING: CPU: 0 PID: 5341 at fs/iomap/buffered-io.c:1373 iomap_zero_iter+0x3b3/0x4c0 fs/iomap/buffered-io.c:1373
Modules linked in:
CPU: 0 UID: 0 PID: 5341 Comm: syz.0.0 Not tainted 6.12.0-syzkaller-10553-gb86545e02e8c #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:iomap_zero_iter+0x3b3/0x4c0 fs/iomap/buffered-io.c:1373
Code: 85 ff 49 bc 00 00 00 00 00 fc ff df 7e 56 49 01 dd e8 21 66 60 ff 48 8b 1c 24 48 8d 4c 24 60 e9 0b fe ff ff e8 0e 66 60 ff 90 <0f> 0b 90 e9 1b ff ff ff 48 8b 4c 24 10 80 e1 07 fe c1 38 c1 0f 8c
RSP: 0018:ffffc9000d27f3e0 EFLAGS: 00010283
RAX: ffffffff82357e72 RBX: 0000000000000000 RCX: 0000000000100000
RDX: ffffc9000e2fa000 RSI: 000000000000053d RDI: 000000000000053e
RBP: ffffc9000d27f4b0 R08: ffffffff82357d88 R09: 1ffffd40002a07d8
R10: dffffc0000000000 R11: fffff940002a07d9 R12: 0000000000008000
R13: 0000000000008000 R14: ffffea0001503ec0 R15: 0000000000000001
FS:  00007efeb79fe6c0(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007efeb81360e8 CR3: 00000000442d8000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 iomap_zero_range+0x69b/0x970 fs/iomap/buffered-io.c:1456
 gfs2_block_zero_range fs/gfs2/bmap.c:1303 [inline]
 __gfs2_punch_hole+0x311/0xb30 fs/gfs2/bmap.c:2420
 gfs2_fallocate+0x3a1/0x490 fs/gfs2/file.c:1399
 vfs_fallocate+0x569/0x6e0 fs/open.c:327
 do_vfs_ioctl+0x258c/0x2e40 fs/ioctl.c:885
 __do_sys_ioctl fs/ioctl.c:904 [inline]
 __se_sys_ioctl+0x80/0x170 fs/ioctl.c:892
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7efeb7f80809
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007efeb79fe058 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007efeb8145fa0 RCX: 00007efeb7f80809
RDX: 0000000020000000 RSI: 0000000040305829 RDI: 0000000000000005
RBP: 00007efeb7ff393e R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 00007efeb8145fa0 R15: 00007ffd994f7a38
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
