Received: from mail-il1-f205.google.com (mail-il1-f205.google.com [209.85.166.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B9CE186E2E
	for <linux-xfs@vger.kernel.org>; Sun, 23 Nov 2025 05:08:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763874507; cv=none; b=SaJdZ9GelrG6rdIkyiKYiU/ZBTMLIWgAMLG9zKsopNTOknqah05p7ifkN1IZIE5fpsn9L0hO1UhvT62NE3shbL64dAvB3ETIP/fJeSJPwswM05B/WBeaxy8ZZlCWCgIpPNLRpHxjBDKv9O+hPsykBcaRs3E07bOxnTlv/IUsw+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763874507; c=relaxed/simple;
	bh=FYJt1nWqJCTYR1rM61GKAjbR+gvt7MddeA9Hg/637Ks=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=Ja/kn2ZrklKANFeurWqQJJBxQoQBfl7t8XzJMkkTU1bP6l/XYoAMuY+ed2Ud4vyNPBMatIsKtsle74ca3iVaYFj5w1XBmwYmH4rvEWVSS1+nmrLELvkRZcjU/+oV1ZfJb4BWYzICV9ItrnQeItqffMA73B9NknwwCwx42pNcPdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f205.google.com with SMTP id e9e14a558f8ab-43300f41682so24698485ab.1
        for <linux-xfs@vger.kernel.org>; Sat, 22 Nov 2025 21:08:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763874504; x=1764479304;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8M8/v8kt3MueOrgDP5NZ8h89wbdbx9qG5AdHKio0yhI=;
        b=aRibiekbe5alyIzBi/+VBoTHD96+c7V0O1npjspzblmRbdJr6Yy75SZuft+k1tsAJe
         xegJMBjnhzyJbd7kEHOPH+EfzAmnxzUvVdrXLrO44P+VuoiCskhiqXFXjusGUs5qRoX4
         gYQZ9DTriVPCPgyIPHt9yCugSELIVBx8u1aQlOx/pl3UcYVI7pA8/u1k1EyF52I/vdkC
         bHD9AJHK7LO0t1Yxfl8zTEqUo8Z6KAY2BBUVAGLhnfPl18nYf3kkhKc8MYjcyQBvhJNS
         4FI6A7k/rl+hnpQ4r14pcSPz382v74cY2tHQZNnEc4Q4KPEXVWnoQnrMFloNNSW02vY0
         JZOg==
X-Forwarded-Encrypted: i=1; AJvYcCVB/E/kwsgZwr0CWdx70UdckGrEd399Lum0ZCBSOJOccM6HGAigTnvHFIqu/6dJ6v3Usw+id2jo0+M=@vger.kernel.org
X-Gm-Message-State: AOJu0YyGOOeFpxf0/auqlTJuALcZ1tv1ZOLYpMCnYMD6JKExanzjfveT
	nP22L17jJcw8KZLJAlBZX7HaX8jXuk6I2ent6iuMo7iXMDhPlW/69eG6Dx5XILD9qlKBgTgT7Cn
	V84plUOX3TJDqYuT8+YV0m6FqGZhvzqSAfel0xktn32QSj5jFcQY96xUDRj4=
X-Google-Smtp-Source: AGHT+IH8oWPABdPzePVFeSgsWDrvEAfYEeo/z8DRhR0cP9rl8bpwtUFJZjcNQFnmNIJORe9kCor0jZTZ4TPFYqdBmBokUqDdfqui
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a92:cd8b:0:b0:435:a1df:a771 with SMTP id
 e9e14a558f8ab-435b98fa771mr56191415ab.39.1763874504646; Sat, 22 Nov 2025
 21:08:24 -0800 (PST)
Date: Sat, 22 Nov 2025 21:08:24 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <692296c8.a70a0220.d98e3.0060.GAE@google.com>
Subject: [syzbot] [xfs?] WARNING: kmalloc bug in xfs_buf_alloc
From: syzbot <syzbot+3735a85c5c610415e2b6@syzkaller.appspotmail.com>
To: cem@kernel.org, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    fe4d0dea039f Add linux-next specific files for 20251119
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=15917692580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f20a6db7594dcad7
dashboard link: https://syzkaller.appspot.com/bug?extid=3735a85c5c610415e2b6
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1588ba12580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16b00514580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/ce4f26d91a01/disk-fe4d0dea.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/6c9b53acf521/vmlinux-fe4d0dea.xz
kernel image: https://storage.googleapis.com/syzbot-assets/64d37d01cd64/bzImage-fe4d0dea.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/28a73d2f6731/mount_0.gz
  fsck result: failed (log: https://syzkaller.appspot.com/x/fsck.log?x=12b00514580000)

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+3735a85c5c610415e2b6@syzkaller.appspotmail.com

loop0: detected capacity change from 0 to 32768
XFS (loop0): Mounting V5 Filesystem c496e05e-540d-4c72-b591-04d79d8b4eeb
XFS (loop0): Ending clean mount
------------[ cut here ]------------
Unexpected gfp: 0x1000000 (__GFP_NOLOCKDEP). Fixing up to gfp: 0x2dc0 (GFP_KERNEL|__GFP_ZERO|__GFP_NOWARN). Fix your code!
WARNING: mm/vmalloc.c:3940 at vmalloc_fix_flags+0x9c/0xe0 mm/vmalloc.c:3939, CPU#0: syz.0.17/6023
Modules linked in:
CPU: 0 UID: 0 PID: 6023 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/02/2025
RIP: 0010:vmalloc_fix_flags+0x9c/0xe0 mm/vmalloc.c:3939
Code: 81 e6 1f 52 ae ff 89 74 24 30 81 e3 e0 ad 51 00 89 5c 24 20 90 48 c7 c7 60 db 76 8b 4c 89 fa 89 d9 4d 89 f0 e8 05 8d 6c ff 90 <0f> 0b 90 90 8b 44 24 20 48 c7 04 24 0e 36 e0 45 4b c7 04 2c 00 00
RSP: 0018:ffffc90002f0eb00 EFLAGS: 00010246
RAX: 1961bedde0732e00 RBX: 0000000000002dc0 RCX: ffff888031575b80
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000002
RBP: ffffc90002f0eb98 R08: 0000000000000003 R09: 0000000000000004
R10: dffffc0000000000 R11: fffffbfff1bba708 R12: 1ffff920005e1d60
R13: dffffc0000000000 R14: ffffc90002f0eb20 R15: ffffc90002f0eb30
FS:  000055556e61c500(0000) GS:ffff888125ebc000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000200000010000 CR3: 000000007f42c000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 __vmalloc_noprof+0xf2/0x120 mm/vmalloc.c:4126
 xfs_buf_alloc_backing_mem fs/xfs/xfs_buf.c:239 [inline]
 xfs_buf_alloc+0xe7b/0x1d50 fs/xfs/xfs_buf.c:312
 xfs_buf_find_insert+0xab/0x1470 fs/xfs/xfs_buf.c:502
 xfs_buf_get_map+0x1288/0x1880 fs/xfs/xfs_buf.c:606
 xfs_buf_get fs/xfs/xfs_buf.h:247 [inline]
 xfs_attr_rmtval_set_value+0x3ac/0x6d0 fs/xfs/libxfs/xfs_attr_remote.c:538
 xfs_attr_rmtval_alloc fs/xfs/libxfs/xfs_attr.c:645 [inline]
 xfs_attr_set_iter+0x332/0x4ba0 fs/xfs/libxfs/xfs_attr.c:866
 xfs_attr_finish_item+0xed/0x320 fs/xfs/xfs_attr_item.c:506
 xfs_defer_finish_one+0x5a8/0xd00 fs/xfs/libxfs/xfs_defer.c:595
 xfs_defer_finish_noroll+0x8d8/0x12a0 fs/xfs/libxfs/xfs_defer.c:707
 xfs_trans_commit+0x10b/0x1c0 fs/xfs/xfs_trans.c:921
 xfs_attr_set+0xdc6/0x1210 fs/xfs/libxfs/xfs_attr.c:1150
 xfs_xattr_set+0x14d/0x250 fs/xfs/xfs_xattr.c:186
 __vfs_setxattr+0x43c/0x480 fs/xattr.c:200
 __vfs_setxattr_noperm+0x12d/0x660 fs/xattr.c:234
 vfs_setxattr+0x16b/0x2f0 fs/xattr.c:321
 do_setxattr fs/xattr.c:636 [inline]
 filename_setxattr+0x274/0x600 fs/xattr.c:665
 path_setxattrat+0x364/0x3a0 fs/xattr.c:713
 __do_sys_lsetxattr fs/xattr.c:754 [inline]
 __se_sys_lsetxattr fs/xattr.c:750 [inline]
 __x64_sys_lsetxattr+0xbf/0xe0 fs/xattr.c:750
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f865218f749
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffd621091f8 EFLAGS: 00000246 ORIG_RAX: 00000000000000bd
RAX: ffffffffffffffda RBX: 00007f86523e5fa0 RCX: 00007f865218f749
RDX: 0000200000000480 RSI: 00002000000000c0 RDI: 0000200000000100
RBP: 00007f8652213f91 R08: 0000000000000000 R09: 0000000000000000
R10: 000000000000fe37 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f86523e5fa0 R14: 00007f86523e5fa0 R15: 0000000000000005
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
