Received: from mail-oi1-f206.google.com (mail-oi1-f206.google.com [209.85.167.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E95682E2EEE
	for <linux-xfs@vger.kernel.org>; Tue,  4 Aug 2026 01:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785805528; cv=none; b=JzeDclODkGY81rm2sRYc6DnzLIaabPvhbv2DeH750bx3il7zPLA2jRpK7EDXIBMgxLoQAUnNRz6yVzOhCUCXr/qhN8+AqS1keVMCOG0IVJ8ViDfLcQdDJpxe6M75KnyEKBahilTJD7j7gUKG0hjz6aCLfI0TmaSNmFrXEWxfM14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785805528; c=relaxed/simple;
	bh=q5uivG6MXjg7onkamaod1ScSxfO1UoV6PiFra/8BtrU=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=QW4YhHz7+Hvo2I7sa3nwjmI6ou5qxNndC8ZkQn+HPUo3FovZTrh0GXOtXh+lj7/HvO0dGz5El/zipPPGS6mMGWC3YSZ6DuJ9QS7JM0T3oi2i5xqto1AlNGHVES/quncGvoLK4RJ8fXVU9S3Evi/xozZ/kSe30L5/riceTLZ8vLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f206.google.com with SMTP id 5614622812f47-4ab4f652f9bso2695268b6e.0
        for <linux-xfs@vger.kernel.org>; Mon, 03 Aug 2026 18:05:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785805526; x=1786410326;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=n1vACsN0uKIrQKjeDZcmclxcHSR7VWwIWAJyYHQcVxk=;
        b=cZvlwPt5BrXqetJjA1UtNDuepx8fy1QX0Ob5+GkO8YV+eMSWGBHhxUKIs1ks/hbQ9j
         N5TNIn/HYyKYOfRmRlgL96AHFWnmBkvwaFVV8l71IadXVnkIVrY/0h/JelRtxcNELwB9
         oF5hBwCeVPA0035msFnyZMcr0HlpKNVoVH5BL+E3DjzJ0bEedq0EGjTTIytaILsZN68r
         8Gw62obfZ+93wCzFZW97bzunIA+hN3E/xMZkiKiVTiXD/EihFNau9o5qCTPQsUXJ8lnd
         qOFx0YiGPBWdDqTb9d0P3LCpDFnA+EpIMDQmTqcd+nS9oaOI9BQvOhNUBBkJXzFKIhwY
         eLRA==
X-Forwarded-Encrypted: i=1; AHgh+Rq/scfWDH6zpN5CONEGfeGiwoT6Nut7TCLpAQoFaDJnGUcWEyldAmP8PcoIvjRcMuo0276s5ya7AAc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxux100Sb/qV9zLn8SYk4GR29bdfkSx0h5Syoj0WiIzb7e9xqIS
	F9Y7wChhtQUBgp0ZyQVwaShNIAPfJqOeA1Pzfj4sdnOO5mQ3AIXhbrNmnKVv/Sv9+TWuqEI3N7T
	ZC6L6BTKzrbgnHaL6c12uoLMpkhpEOQRAJlM7uGQofpFJeH7NI8ckBUmTW+o=
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:6801:b0:4a4:ddde:5207 with SMTP id
 5614622812f47-4af5e0aa88amr21294085b6e.8.1785805525904; Mon, 03 Aug 2026
 18:05:25 -0700 (PDT)
Date: Mon, 03 Aug 2026 18:05:25 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a713ad5.27c771da.e23b5.005e.GAE@google.com>
Subject: [syzbot] [xfs?] WARNING in xfs_bmapi_convert_delalloc (3)
From: syzbot <syzbot+0ce92d16209e30011ebc@syzkaller.appspotmail.com>
To: cem@kernel.org, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    3708dd948844 Merge tag 'pm-7.2-rc6' of git://git.kernel.or..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=13b597b1580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4e38b15c29e6a1d9
dashboard link: https://syzkaller.appspot.com/bug?extid=0ce92d16209e30011ebc
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/52be26782cb7/disk-3708dd94.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/75068ef5ea5b/vmlinux-3708dd94.xz
kernel image: https://storage.googleapis.com/syzbot-assets/cacb93088fbd/bzImage-3708dd94.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+0ce92d16209e30011ebc@syzkaller.appspotmail.com

------------[ cut here ]------------
whichfork != XFS_COW_FORK
WARNING: fs/xfs/libxfs/xfs_bmap.c:4395 at xfs_bmapi_convert_one_delalloc fs/xfs/libxfs/xfs_bmap.c:4395 [inline], CPU#1: syz.5.576/8381
WARNING: fs/xfs/libxfs/xfs_bmap.c:4395 at xfs_bmapi_convert_delalloc+0x117b/0x1540 fs/xfs/libxfs/xfs_bmap.c:4501, CPU#1: syz.5.576/8381
Modules linked in:

CPU: 1 UID: 0 PID: 8381 Comm: syz.5.576 Tainted: G S           L      syzkaller #0 PREEMPT(full) 
Tainted: [S]=CPU_OUT_OF_SPEC, [L]=SOFTLOCKUP
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/16/2026
RIP: 0010:xfs_bmapi_convert_one_delalloc fs/xfs/libxfs/xfs_bmap.c:4395 [inline]
RIP: 0010:xfs_bmapi_convert_delalloc+0x117b/0x1540 fs/xfs/libxfs/xfs_bmap.c:4501
Code: df 31 f6 e8 a7 50 01 00 eb 05 e8 c0 ee 48 fe 48 8b bc 24 e0 01 00 00 e8 73 ce 1e 00 41 89 c4 e9 e0 f2 ff ff e8 a6 ee 48 fe 90 <0f> 0b 90 e9 bf f2 ff ff 44 89 e1 80 e1 07 38 c1 0f 8c 0e f1 ff ff
RSP: 0018:ffffc90005d86f60 EFLAGS: 00010287
RAX: ffffffff837e25ca RBX: 1ffff92000bb0e04 RCX: 0000000000080000
RDX: ffffc9000f6e3000 RSI: 00000000000004e1 RDI: 00000000000004e2
RBP: ffffc90005d871b0 R08: ffffc90005d87090 R09: 0000000000000002
R10: 0000000000000001 R11: 0000000000000002 R12: 0000000000000002
R13: 0000000000000000 R14: dffffc0000000000 R15: 1ffff92000bb0e04
FS:  00007fb5b0f8b6c0(0000) GS:ffff88812504d000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b34821ff8 CR3: 000000007d12c000 CR4: 0000000000350ef0
Call Trace:
 <TASK>
 xfs_buffered_write_iomap_begin+0xd50/0x2350 fs/xfs/xfs_iomap.c:2082
 iomap_iter+0x5f5/0xf80 fs/iomap/iter.c:110
 iomap_zero_range+0xb85/0xca0 fs/iomap/buffered-io.c:1762
 xfs_zero_range+0x9a/0x100 fs/xfs/xfs_iomap.c:2371
 xfs_file_write_zero_eof fs/xfs/xfs_file.c:443 [inline]
 xfs_file_write_checks+0x5f0/0xa80 fs/xfs/xfs_file.c:510
 xfs_file_buffered_write+0x19f/0x870 fs/xfs/xfs_file.c:1051
 aio_write+0x5cd/0x870 fs/aio.c:1687
 __io_submit_one fs/aio.c:-1 [inline]
 io_submit_one+0x798/0x13d0 fs/aio.c:2106
 __do_sys_io_submit fs/aio.c:2165 [inline]
 __se_sys_io_submit+0x195/0x340 fs/aio.c:2135
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fb5b019e019
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fb5b0f8b028 EFLAGS: 00000246 ORIG_RAX: 00000000000000d1
RAX: ffffffffffffffda RBX: 00007fb5b0426090 RCX: 00007fb5b019e019
RDX: 0000200000000540 RSI: 0000000000000008 RDI: 00007fb5b0f6a000
RBP: 00007fb5b023500c R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fb5b0426128 R14: 00007fb5b0426090 R15: 00007ffd02aa14a8
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
