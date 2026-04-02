Received: from mail-oo1-f77.google.com (mail-oo1-f77.google.com [209.85.161.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3A27309EEC
	for <linux-xfs@vger.kernel.org>; Thu,  2 Apr 2026 18:55:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.77
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775156124; cv=none; b=LeEeinBXqqyKNiu2k10t3Uw4Xjud0hdhU1BLVSEqlapmv/pWeQ5V4EiUQSc5Z1nUHLAGbH5/BRmVfntRk5G01WgeZMD5xYBQCsz6qZGtrfVvlQ6zg7gUsZyJOzE726u9tgOxtPdElgsabWRJpq5yP3sO5pwbhxufzYsJ20A+yqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775156124; c=relaxed/simple;
	bh=v4D8ZsKHnbaJ67QDI3+zxUksXBKK82rn1hgW2WsB3t8=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=IUZcdKZ02aXFbg64Kc89amNHFFMXytP3aPpetKxccCYQLk1a+1lYoguXEa/OnXsFQozUyUj6MqLl/3hLbHQwLYVCFdKOdSK6nnWVys5jA+rjk3QGEmEMrgQA0RfgzLV1sR/WV6dkfrQcfK8M02KyrC7ulAOU7zBEAZRaZcPy8pA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f77.google.com with SMTP id 006d021491bc7-67e4258e5b7so3765950eaf.1
        for <linux-xfs@vger.kernel.org>; Thu, 02 Apr 2026 11:55:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775156122; x=1775760922;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wNcxSEY5NOWNLka6D9MuHLN0NTGzwvctLz+fnYD5UIM=;
        b=CkgaLQwpimqzKm0IQQZweB6yyFrKpDKX7z1zYt1+O/er7piKUCMZgUhmV9xGhlqYMV
         hfsPtnpvYHpDg6BH6t4qmuh1c/2vg4fMrzjkmLQ+pKyGJd1J1g5dZKQOXILfEDIVyvPE
         EsIH5sEnDgq5nH3w7h03IV47byCSDjbSmemJJzQzFGNzjy2dwM0czRbXCyYOMXAaSmC7
         Iq+TShXoH3IHsUC0DOdts59ZNTso5HEUIIZOjBsZOQa4t93PV2Gw6y/xeItay0nx1KoZ
         Jghn9kgrH48ZXrfgvGsjkO5ZW0ae+70i7DqIIPBQ4ptThEM34CyJ5eIPaor3466kEpcg
         XxYw==
X-Forwarded-Encrypted: i=1; AJvYcCVZaApIBndLFODgHK4krxQd1jGqcCEN/xTQIlaz524Mv6H7YEuXDS9zFVnJz1MFhJn8VsIYZdcceGA=@vger.kernel.org
X-Gm-Message-State: AOJu0YyZ8dTozp+vr68LhYPLhGUgSAo+QiUAk6CmMU+osTlkxn88xsEB
	g++esTZRNq1higum075iKQKNk9ccaUoxlE7Gq/S8zQbrSluszhnIhFoSBchyO2UOsMy0AqyP/s6
	Ejj4ms84VASKItOanh9bE8QRbS2NjKmEf9mFsGG45E+4qQLgauGMbi+p1OuQ=
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:2215:b0:67e:1be4:da46 with SMTP id
 006d021491bc7-6821fe61a6bmr199698eaf.39.1775156121939; Thu, 02 Apr 2026
 11:55:21 -0700 (PDT)
Date: Thu, 02 Apr 2026 11:55:21 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69cebb99.050a0220.2dbe29.0007.GAE@google.com>
Subject: [syzbot] [xfs?] KMSAN: uninit-value in xlog_verify_head
From: syzbot <syzbot+b7dfbed0c6c2b5e9fd34@syzkaller.appspotmail.com>
To: cem@kernel.org, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    cbfffcca2bf0 Merge tag 'trace-v7.0-rc5' of git://git.kerne..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=13b5ff52580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=963de479f54c6dbb
dashboard link: https://syzkaller.appspot.com/bug?extid=b7dfbed0c6c2b5e9fd34
compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
userspace arch: i386

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/b6db7d9b793c/disk-cbfffcca.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/027636820b95/vmlinux-cbfffcca.xz
kernel image: https://storage.googleapis.com/syzbot-assets/b7d1a553de59/bzImage-cbfffcca.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+b7dfbed0c6c2b5e9fd34@syzkaller.appspotmail.com

XFS (loop4): Mounting V5 Filesystem d7dc424e-7990-42cb-9f91-9cb7200a101d
=====================================================
BUG: KMSAN: uninit-value in xlog_verify_head+0x6c3/0x910 fs/xfs/xfs_log_recover.c:1058
 xlog_verify_head+0x6c3/0x910 fs/xfs/xfs_log_recover.c:1058
 xlog_find_tail+0xc2e/0x1a50 fs/xfs/xfs_log_recover.c:1315
 xlog_recover+0x6d/0x800 fs/xfs/xfs_log_recover.c:3426
 xfs_log_mount+0x4da/0x880 fs/xfs/xfs_log.c:617
 xfs_mountfs+0x1599/0x2d00 fs/xfs/xfs_mount.c:1034
 xfs_fs_fill_super+0x2603/0x2be0 fs/xfs/xfs_super.c:1938
 get_tree_bdev_flags+0x6e6/0x920 fs/super.c:1694
 get_tree_bdev+0x38/0x50 fs/super.c:1717
 xfs_fs_get_tree+0x35/0x40 fs/xfs/xfs_super.c:1985
 vfs_get_tree+0xb3/0x5d0 fs/super.c:1754
 fc_mount fs/namespace.c:1193 [inline]
 do_new_mount_fc fs/namespace.c:3763 [inline]
 do_new_mount+0x885/0x1dd0 fs/namespace.c:3839
 path_mount+0x7a2/0x20b0 fs/namespace.c:4159
 do_mount fs/namespace.c:4172 [inline]
 __do_sys_mount fs/namespace.c:4361 [inline]
 __se_sys_mount+0x704/0x7f0 fs/namespace.c:4338
 __ia32_sys_mount+0xe2/0x150 fs/namespace.c:4338
 ia32_sys_call+0x27fe/0x4360 arch/x86/include/generated/asm/syscalls_32.h:22
 do_syscall_32_irqs_on arch/x86/entry/syscall_32.c:83 [inline]
 __do_fast_syscall_32+0x17f/0x3f0 arch/x86/entry/syscall_32.c:307
 do_fast_syscall_32+0x37/0x80 arch/x86/entry/syscall_32.c:332
 do_SYSENTER_32+0x1f/0x30 arch/x86/entry/syscall_32.c:370
 entry_SYSENTER_compat_after_hwframe+0x84/0x8e

Uninit was stored to memory at:
 xlog_verify_head+0x6bc/0x910 fs/xfs/xfs_log_recover.c:1058
 xlog_find_tail+0xc2e/0x1a50 fs/xfs/xfs_log_recover.c:1315
 xlog_recover+0x6d/0x800 fs/xfs/xfs_log_recover.c:3426
 xfs_log_mount+0x4da/0x880 fs/xfs/xfs_log.c:617
 xfs_mountfs+0x1599/0x2d00 fs/xfs/xfs_mount.c:1034
 xfs_fs_fill_super+0x2603/0x2be0 fs/xfs/xfs_super.c:1938
 get_tree_bdev_flags+0x6e6/0x920 fs/super.c:1694
 get_tree_bdev+0x38/0x50 fs/super.c:1717
 xfs_fs_get_tree+0x35/0x40 fs/xfs/xfs_super.c:1985
 vfs_get_tree+0xb3/0x5d0 fs/super.c:1754
 fc_mount fs/namespace.c:1193 [inline]
 do_new_mount_fc fs/namespace.c:3763 [inline]
 do_new_mount+0x885/0x1dd0 fs/namespace.c:3839
 path_mount+0x7a2/0x20b0 fs/namespace.c:4159
 do_mount fs/namespace.c:4172 [inline]
 __do_sys_mount fs/namespace.c:4361 [inline]
 __se_sys_mount+0x704/0x7f0 fs/namespace.c:4338
 __ia32_sys_mount+0xe2/0x150 fs/namespace.c:4338
 ia32_sys_call+0x27fe/0x4360 arch/x86/include/generated/asm/syscalls_32.h:22
 do_syscall_32_irqs_on arch/x86/entry/syscall_32.c:83 [inline]
 __do_fast_syscall_32+0x17f/0x3f0 arch/x86/entry/syscall_32.c:307
 do_fast_syscall_32+0x37/0x80 arch/x86/entry/syscall_32.c:332
 do_SYSENTER_32+0x1f/0x30 arch/x86/entry/syscall_32.c:370
 entry_SYSENTER_compat_after_hwframe+0x84/0x8e

Local variable tmp_rhead_blk created at:
 xlog_verify_head+0x81/0x910 fs/xfs/xfs_log_recover.c:1032
 xlog_find_tail+0xc2e/0x1a50 fs/xfs/xfs_log_recover.c:1315

CPU: 1 UID: 0 PID: 7664 Comm: syz.4.285 Tainted: G             L      syzkaller #0 PREEMPT(full) 
Tainted: [L]=SOFTLOCKUP
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 02/12/2026
=====================================================


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
