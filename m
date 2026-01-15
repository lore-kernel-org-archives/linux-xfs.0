Received: from mail-oi1-f206.google.com (mail-oi1-f206.google.com [209.85.167.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE6B4329E44
	for <linux-xfs@vger.kernel.org>; Thu, 15 Jan 2026 08:12:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768464743; cv=none; b=LdWJxYfc3wGtjCH4zaK4rKKUhbuzMVxuP0IQ1PYDgaBGax6j/V73XuNsrrKieUEuP1ITDM8fQ6eGn75/FElCoG+x9HfHkqOuY9/0+XkQFpgjpwFGgvRm/cEtUnHir3yMOIsNns6jmFXImxIMRdAoB6ST+8P8QoRP526+gXpraZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768464743; c=relaxed/simple;
	bh=Kt1aG1Qqw5udkt/U6jZYpTx751QM62eIRmLLRZQI5NI=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=KtGJz6XGRFBsUji3SNpOQTIFsPXGsbRMJEFcCSRd//n8+ss/Db5f+3I/tnRTje4UtzU2mCc4UVplhasHu5sg62to7oMlHKIJtkOQLTPV4Al8z6sFDx0KqDXxgGtDl1h7OU9e8FgXRnNKQyUjbkMo9dSoVwZd7CxpgXHzd2Wj+c4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f206.google.com with SMTP id 5614622812f47-45c805d2e94so1094241b6e.0
        for <linux-xfs@vger.kernel.org>; Thu, 15 Jan 2026 00:12:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768464740; x=1769069540;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rn1vd4KPJeuZ9DXDf74Guf7gmmsSPgatZ6FXXGUFuNM=;
        b=L9f3S30qlkuES5jeQ2U61mbNkywgZkxMp0ws2nDAA6SifHDN7rDDe3DChT32n47eoI
         M9Bo+1sbhNs6ePJHel4ZMmoukGcK6ui7jKAaFVSig2GSeKdeyESIAANlsupcQ3YSgMXV
         oMy5/mjVcuoEPIDAWjo4qX9z3vSKfm5yVG6CWQ26VUfzk/oVKHsJrcOI9GlSwmz7av5a
         vy7KZHhd6VcTiWQ/m9c9RaqM0YRzcKPUz24npev5M7/yZV0NNYOqbZqWEMB+7KXM28Xp
         fOGCh/Fwa9EEbZSGNYRXuuUsItczZo599tCfXTpdDHkqhwTJW0bPxKIGATr0f0i+EOIa
         ICLg==
X-Forwarded-Encrypted: i=1; AJvYcCVTbNydriscxYNY3DIjfBGbhm2nCkvDtlHM2O4ikRQ996sobb+5RxlNk6fJCaX2TxQcDcxOZaLHvZ0=@vger.kernel.org
X-Gm-Message-State: AOJu0YwZcvibfEOACZyPRIZFr6dkZUxaSAujhGRKNYQ/jDaOxqzIa/rz
	vbNsTyUFHu4E7HH/Uw1cRlD6rAbjEQuaWuqEN5R37lxu7uzXcth1IfscXUrPCZswLXBkOdkLaIJ
	QpK1h+35v+4+0OcTDUq1RDxRvaxIWTlUERZoWsSi523Jr8lwAysQ65bxH3LA=
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:1207:b0:455:7fe4:b229 with SMTP id
 5614622812f47-45c714f27a7mr3084513b6e.53.1768464740707; Thu, 15 Jan 2026
 00:12:20 -0800 (PST)
Date: Thu, 15 Jan 2026 00:12:20 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6968a164.050a0220.58bed.0011.GAE@google.com>
Subject: [syzbot] [iomap?] WARNING in ifs_free
From: syzbot <syzbot+d3a62bea0e61f9d121da@syzkaller.appspotmail.com>
To: brauner@kernel.org, djwong@kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    f417b7ffcbef Add linux-next specific files for 20260109
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=17e6943a580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=63a1fc1b4011ac76
dashboard link: https://syzkaller.appspot.com/bug?extid=d3a62bea0e61f9d121da
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/1f048080a918/disk-f417b7ff.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/dfd5ea190c96/vmlinux-f417b7ff.xz
kernel image: https://storage.googleapis.com/syzbot-assets/db24c176e0df/bzImage-f417b7ff.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+d3a62bea0e61f9d121da@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: fs/iomap/buffered-io.c:255 at ifs_free+0x358/0x420 fs/iomap/buffered-io.c:254, CPU#1: syz-executor/9813
Modules linked in:
CPU: 1 UID: 0 PID: 9813 Comm: syz-executor Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/25/2025
RIP: 0010:ifs_free+0x358/0x420 fs/iomap/buffered-io.c:254
Code: 41 5f 5d e9 aa ec c0 ff e8 05 d2 65 ff 90 0f 0b 90 e9 d0 fe ff ff e8 f7 d1 65 ff 90 0f 0b 90 e9 0a ff ff ff e8 e9 d1 65 ff 90 <0f> 0b 90 eb c3 44 89 e1 80 e1 07 80 c1 03 38 c1 0f 8c 06 fe ff ff
RSP: 0018:ffffc90005287670 EFLAGS: 00010293
RAX: ffffffff825ae8d7 RBX: 0000000000000008 RCX: ffff88802f4c9e40
RDX: 0000000000000000 RSI: 0000000000000008 RDI: 0000000000000000
RBP: 00000000825b5701 R08: ffffea0002bb5887 R09: 1ffffd4000576b10
R10: dffffc0000000000 R11: fffff94000576b11 R12: ffff8880202d0144
R13: ffff8880202d0100 R14: ffffea0002bb5880 R15: 1ffffd4000576b11
FS:  00005555773e5500(0000) GS:ffff888125d07000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f27239ff000 CR3: 0000000033afe000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 folio_invalidate mm/truncate.c:140 [inline]
 truncate_cleanup_folio+0x2d8/0x430 mm/truncate.c:160
 truncate_inode_pages_range+0x233/0xd90 mm/truncate.c:404
 ntfs_evict_inode+0x19/0x40 fs/ntfs3/inode.c:1799
 evict+0x5f4/0xae0 fs/inode.c:837
 dispose_list fs/inode.c:879 [inline]
 evict_inodes+0x753/0x7e0 fs/inode.c:933
 generic_shutdown_super+0x9a/0x2c0 fs/super.c:628
 kill_block_super+0x44/0x90 fs/super.c:1722
 ntfs3_kill_sb+0x44/0x1c0 fs/ntfs3/super.c:1860
 deactivate_locked_super+0xbc/0x130 fs/super.c:474
 cleanup_mnt+0x425/0x4c0 fs/namespace.c:1312
 task_work_run+0x1d4/0x260 kernel/task_work.c:233
 resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
 __exit_to_user_mode_loop kernel/entry/common.c:44 [inline]
 exit_to_user_mode_loop+0xef/0x4e0 kernel/entry/common.c:75
 __exit_to_user_mode_prepare include/linux/irq-entry-common.h:226 [inline]
 syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:256 [inline]
 syscall_exit_to_user_mode_work include/linux/entry-common.h:159 [inline]
 syscall_exit_to_user_mode include/linux/entry-common.h:194 [inline]
 do_syscall_64+0x2c1/0xf80 arch/x86/entry/syscall_64.c:100
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fba68d90a77
Code: a8 ff ff ff f7 d8 64 89 01 48 83 c8 ff c3 0f 1f 44 00 00 31 f6 e9 09 00 00 00 66 0f 1f 84 00 00 00 00 00 b8 a6 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 01 c3 48 c7 c2 a8 ff ff ff f7 d8 64 89 02 b8
RSP: 002b:00007ffc83b0f988 EFLAGS: 00000246 ORIG_RAX: 00000000000000a6
RAX: 0000000000000000 RBX: 00007fba68e13d7d RCX: 00007fba68d90a77
RDX: 0000000000000000 RSI: 0000000000000009 RDI: 00007ffc83b0fa40
RBP: 00007ffc83b0fa40 R08: 0000000000000000 R09: 0000000000000000
R10: 00000000ffffffff R11: 0000000000000246 R12: 00007ffc83b10ad0
R13: 00007fba68e13d7d R14: 0000000000069557 R15: 00007ffc83b10b10
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
