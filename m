Received: from mail-oi1-f206.google.com (mail-oi1-f206.google.com [209.85.167.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EA7E3A6B86
	for <linux-xfs@vger.kernel.org>; Fri, 17 Apr 2026 14:31:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776436283; cv=none; b=MeCZHaevSoIfaDO+TrY6A7rPBcfBhKUdULkcZ+/DbrhUQ+5pyI93m0xfxv1NW+BHd/kbicj2hZrAopevNzYrkQGlbVFseno2m+XA23qfHY3OtHsyt8afgPti4C0ZtVKG1M3uLLVwDYTVUbQV9Nl4AZSUgIQ3zjLZI/cmRkz5gmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776436283; c=relaxed/simple;
	bh=gHpiF0mfwMTwb7tHUIPjUX/iW8lC2YhsGCHq1i5DDbY=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=a8BD69XrPmwIt+rAEIJI5J6YibKkIUBtQuKkcupAfCqFT3SdEQ7nXMuh1Cuqj0GlORyIKt+reuXUO7JNM7sz+XQuAV1g7bKPfPQoHobf4mOcDWaUQsOFg1uR2VvQEw6zFNeg7/dLEvXI3gBbVqrnJ7I5t0CHEJSm5QatqB4JkMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f206.google.com with SMTP id 5614622812f47-46ef241b62aso585442b6e.0
        for <linux-xfs@vger.kernel.org>; Fri, 17 Apr 2026 07:31:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776436280; x=1777041080;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1tGUFsQbNc7BeWKnVkN7vdgw4XK2T7pn5JC6Wsy8LS8=;
        b=T9MfE3SaTh75tnTUMtkgiyO8qNneZiMhak3/msLLVjzbKb2CSlOwT4vRm9ntl7bE6w
         hVpNWmmnrFNNlO2lNRA2hzOfdEuYiTAOnw2Aa5MhcZzWIAb9j/ka7bE1OUAG5dnH1yNJ
         AQoNiZrSOg/37oM9t9hZX5wSxiYyzv4h356pEbQ/yNX5f/SUSl4mrpaiDJirgCst9wxE
         V6wX77CLWlVL4ntBWBkDXY03shiXsqjyOKKN0utLUkyngZ3a4lfX0McjNMt3z5asMowg
         FRYcbRq2zCrvd0h8xTIHS8MBmyVN+Q15ZDOO80efHNg4mtD5VO8m0/ZQJWcU1auF8r7l
         QeOQ==
X-Forwarded-Encrypted: i=1; AFNElJ9rnMqOWp/62IrojdFv21wuOGqRS+zpUpQKu8Y2cZ5r3CPObic2yJ6SPi+Sh+73xZtvTR4xu04JhDI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzK0iSMmjhQkrDpe+BnjNNHUFMHYDFDDONLYglzeNT84hCKAMDu
	/g3aUdbXFJnCzNJMSNnQYdCPjd1R9HfRekrsudY9ssUAHMBD0lfWs/lued0uWdK2ATJqM3pMsLz
	/01rOzc8hy2pC5zMHRUjTObAzTsoGqkyqrLWf1jnTYtMlUawsRMCqYiwwzi8=
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:1511:b0:468:776:1ec3 with SMTP id
 5614622812f47-4799ca8c122mr1348686b6e.24.1776436280352; Fri, 17 Apr 2026
 07:31:20 -0700 (PDT)
Date: Fri, 17 Apr 2026 07:31:20 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69e24438.050a0220.1de265.0026.GAE@google.com>
Subject: [syzbot] [iomap?] WARNING in iomap_zero_range
From: syzbot <syzbot+9a51b5f7b9b484c57dd1@syzkaller.appspotmail.com>
To: brauner@kernel.org, djwong@kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    028ef9c96e96 Linux 7.0
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=11db9036580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d46eab0cfd31c214
dashboard link: https://syzkaller.appspot.com/bug?extid=9a51b5f7b9b484c57dd1
compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-028ef9c9.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/f7fbf6f85efa/vmlinux-028ef9c9.xz
kernel image: https://storage.googleapis.com/syzbot-assets/2bc3ef5a9e1b/bzImage-028ef9c9.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+9a51b5f7b9b484c57dd1@syzkaller.appspotmail.com

loop0: detected capacity change from 0 to 4096
ntfs3(loop0): Different NTFS sector size (1024) and media sector size (512).
------------[ cut here ]------------
folio_pos(folio) > iter->inode->i_size
WARNING: fs/iomap/buffered-io.c:1561 at iomap_zero_iter fs/iomap/buffered-io.c:1561 [inline], CPU#0: syz.0.0/5326
WARNING: fs/iomap/buffered-io.c:1561 at iomap_zero_range+0x8cf/0xd00 fs/iomap/buffered-io.c:1669, CPU#0: syz.0.0/5326
Modules linked in:
CPU: 0 UID: 0 PID: 5326 Comm: syz.0.0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
RIP: 0010:iomap_zero_iter fs/iomap/buffered-io.c:1561 [inline]
RIP: 0010:iomap_zero_range+0x8cf/0xd00 fs/iomap/buffered-io.c:1669
Code: 5d ff 4d 29 e6 4d 39 f7 4d 0f 42 f7 4c 89 74 24 78 4d 85 f6 0f 84 5a 02 00 00 e8 ec ee 5d ff e9 78 fc ff ff e8 e2 ee 5d ff 90 <0f> 0b 90 e9 41 fd ff ff e8 d4 ee 5d ff 90 0f 0b 90 e9 97 fd ff ff
RSP: 0018:ffffc9000e05f8e0 EFLAGS: 00010287
RAX: ffffffff8267f47e RBX: ffffea00015643c0 RCX: 0000000000100000
RDX: ffffc9000eb52000 RSI: 000000000000021a RDI: 000000000000021b
RBP: ffffc9000e05fc28 R08: ffffea00015643c7 R09: 1ffffd40002ac878
R10: dffffc0000000000 R11: fffff940002ac879 R12: 0000000000000008
R13: 1ffffd40002ac87c R14: ffffea00015643e0 R15: 0000000000001000
FS:  00007f1ef11d66c0(0000) GS:ffff88808ca49000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f1ef05ec2e0 CR3: 0000000044745000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 ntfs_extend_initialized_size+0xcc/0x170 fs/ntfs3/file.c:236
 ntfs_fallocate+0xf21/0x1220 fs/ntfs3/file.c:668
 vfs_fallocate+0x669/0x7e0 fs/open.c:340
 ksys_fallocate fs/open.c:364 [inline]
 __do_sys_fallocate fs/open.c:369 [inline]
 __se_sys_fallocate fs/open.c:367 [inline]
 __x64_sys_fallocate+0xc0/0x110 fs/open.c:367
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f1ef039c819
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f1ef11d5fe8 EFLAGS: 00000246 ORIG_RAX: 000000000000011d
RAX: ffffffffffffffda RBX: 00007f1ef0615fa0 RCX: 00007f1ef039c819
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000005
RBP: 00007f1ef0432c91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000002 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f1ef0616038 R14: 00007f1ef0615fa0 R15: 00007ffdb8222ed8
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
