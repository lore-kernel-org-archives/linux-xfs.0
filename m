Received: from mail-il1-f206.google.com (mail-il1-f206.google.com [209.85.166.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68024156F53
	for <linux-xfs@vger.kernel.org>; Wed, 25 Dec 2024 20:38:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735159103; cv=none; b=Z3KaPl1kqVWGOZu4a3+DMBYiHyDguiKKCsfKsd8gWWS/SbNOICcf/YQNq6+tvK5p5mQLFo+fAvm5TVRwXXZGLLCh7sZJuhJfptC8Ul4f//gZYXfeXikIKjiRZv5OOHW0g6Sa0VC2+NmgR5R2az8uFppuVNGvBRBIePF1yDOPPaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735159103; c=relaxed/simple;
	bh=XwYf7Etbhwh8H0CwAYA/kdqiZDHpG+cvWN5BuIDsisg=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=cgP1SHU8oGhOeTgyoEt6t85QKYsGwPvSENv4bDa/AdMGXFSThQ+7Ajpuk/9KJUI5DRL+NYLSLS6g3GGvmhMBbVg8W68guzQ/bqHJ5uC1WBQ+5g81EYede/xIlWPjoo+cX+qlbVL75eWOFu7f0QshVSsJFe6W8tRHsxiBJM+fvAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f206.google.com with SMTP id e9e14a558f8ab-3a9cc5c246bso55500325ab.2
        for <linux-xfs@vger.kernel.org>; Wed, 25 Dec 2024 12:38:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735159100; x=1735763900;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uvXlSBxQuP3WgdxHp95pNR7prRI9lJmxfvG138waeMA=;
        b=kxYVmWsMnJjfsVTQpwd9wb9jiCxWcRpxEn9SxFLP+ta0y+PZeMc7sqIJ+qbTrC6mEH
         voEjah5fgf2l+FiayEZSoZjng1repAUiJnSEFilIfkvIME6p2Kh/z+37WkCHvy7913wc
         HQzP5j27ajEe2Pz+j/EeOX/o6EEQz96AhcpVGAbmcPLVDW0mVYeWUPY/U/UP83zMwT/l
         zH2ijOjZIoia1FLqHACzuwtIdJN9OfgndFzTKq3yEV6Qq6q7n8QH0u4IWPKVWFDSRgzt
         UnXlAs8gRvs2VdsihBPWpkWiYjXa0yLCSV1N9s2EiiGzT9+XrOXja3a3m41BT1L/ReUl
         ajRg==
X-Forwarded-Encrypted: i=1; AJvYcCVvfVBTzIQdsysjDtPK5Ex/+R7N5R154ArlVQJncuSI8NtoUjMPLwhq2zFjSxzwqVlaiOgIimP9EOs=@vger.kernel.org
X-Gm-Message-State: AOJu0YwNF7002xKQMhEN78cw8lkuAcldNGuZ0kJ2zrjxDHVw4G0K3YhU
	qfWDsUu42GA3DyLx5nGAxslZEydYtnRP9PtZ4vf2vykbG+3UXnXle1zDpf4l1Eq6iY2PAGypOzh
	p3KZguo5/HdB3dOC5agqjeLK4wUDHCoUSLStqlDn567DaxHKCoivvTlM=
X-Google-Smtp-Source: AGHT+IGjU5bR0uoFgejqjhCqy9QIVia8LF0uSIML40+Jc5Xe/xPMdr04U8xsbfZbdM8wazOt/gxBecmyu1R74BrMYQGaLvX1jYzm
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1546:b0:3a7:764c:42fc with SMTP id
 e9e14a558f8ab-3c2d5916145mr186020345ab.21.1735159100563; Wed, 25 Dec 2024
 12:38:20 -0800 (PST)
Date: Wed, 25 Dec 2024 12:38:20 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <676c6d3c.050a0220.226966.0072.GAE@google.com>
Subject: [syzbot] [xfs?] WARNING in xfs_bmapi_convert_delalloc (2)
From: syzbot <syzbot+1fcaeac63a6a5f2cc94d@syzkaller.appspotmail.com>
To: cem@kernel.org, chandan.babu@oracle.com, djwong@kernel.org, 
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    573067a5a685 Merge branch 'for-next/core' into for-kernelci
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=16e572df980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=cd7202b56d469648
dashboard link: https://syzkaller.appspot.com/bug?extid=1fcaeac63a6a5f2cc94d
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
userspace arch: arm64
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13a2bcf8580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=138f1fe8580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/9d3b5c855aa0/disk-573067a5.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/0c06fc1ead83/vmlinux-573067a5.xz
kernel image: https://storage.googleapis.com/syzbot-assets/3390e59b9e4b/Image-573067a5.gz.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/0f8df572853a/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+1fcaeac63a6a5f2cc94d@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 0 PID: 7194 at fs/xfs/libxfs/xfs_bmap.c:4682 xfs_bmapi_convert_delalloc+0x101c/0x1528 fs/xfs/libxfs/xfs_bmap.c:4787
Modules linked in:
CPU: 0 UID: 0 PID: 7194 Comm: syz-executor144 Not tainted 6.13.0-rc3-syzkaller-g573067a5a685 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
pstate: 80400005 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : xfs_bmapi_convert_delalloc+0x101c/0x1528 fs/xfs/libxfs/xfs_bmap.c:4787
lr : xfs_bmapi_convert_one_delalloc fs/xfs/libxfs/xfs_bmap.c:4682 [inline]
lr : xfs_bmapi_convert_delalloc+0x1018/0x1528 fs/xfs/libxfs/xfs_bmap.c:4787
sp : ffff8000a1b97020
x29: ffff8000a1b97300 x28: 1fffe0001a04140f x27: 1ffff00014372e58
x26: ffff8000a1b972c0 x25: ffff8000a1b97750 x24: dfff800000000000
x23: ffff0000de730000 x22: 0000000000000000 x21: 00000000fffffff5
x20: 0000000000010003 x19: ffff0000d020a000 x18: ffff0000de7301c4
x17: ffff80008f99d000 x16: ffff800083275834 x15: 0000000000000001
x14: 0000000000000000 x13: 0000000000000001 x12: ffff0000d0210000
x11: 0000000000ff0100 x10: 0000000000ff0100 x9 : 0000000000000000
x8 : ffff0000d0210000 x7 : ffff800081f098ec x6 : 0000000000000000
x5 : 0000000000000000 x4 : ffff8000a1b97210 x3 : ffff8000a1b97250
x2 : 0000000000000001 x1 : 0000000000010003 x0 : 0000000000010004
Call trace:
 xfs_bmapi_convert_delalloc+0x101c/0x1528 fs/xfs/libxfs/xfs_bmap.c:4787 (P)
 xfs_buffered_write_iomap_begin+0xa54/0x14f0 fs/xfs/xfs_iomap.c:1214
 iomap_iter+0x5c4/0x1008 fs/iomap/iter.c:90
 iomap_zero_range+0x380/0x794 fs/iomap/buffered-io.c:1441
 xfs_zero_range+0x88/0xe8 fs/xfs/xfs_iomap.c:1499
 xfs_setattr_size+0x30c/0xcc0 fs/xfs/xfs_iops.c:890
 xfs_vn_setattr_size+0x138/0x15c fs/xfs/xfs_iops.c:1040
 xfs_falloc_setsize fs/xfs/xfs_file.c:927 [inline]
 xfs_falloc_insert_range+0x310/0x3d8 fs/xfs/xfs_file.c:981
 xfs_file_fallocate+0x29c/0x3a0 fs/xfs/xfs_file.c:1133
 vfs_fallocate+0x484/0x5c0 fs/open.c:327
 ksys_fallocate fs/open.c:351 [inline]
 __do_sys_fallocate fs/open.c:356 [inline]
 __se_sys_fallocate fs/open.c:354 [inline]
 __arm64_sys_fallocate+0xc0/0x110 fs/open.c:354
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
 el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
 do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
 el0_svc+0x54/0x168 arch/arm64/kernel/entry-common.c:744
 el0t_64_sync_handler+0x84/0x108 arch/arm64/kernel/entry-common.c:762
 el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:600
irq event stamp: 104
hardirqs last  enabled at (103): [<ffff8000841068c4>] get_random_u32+0x318/0x618 drivers/char/random.c:553
hardirqs last disabled at (104): [<ffff80008b69c83c>] el1_dbg+0x24/0x80 arch/arm64/kernel/entry-common.c:488
softirqs last  enabled at (72): [<ffff800080129934>] local_bh_enable+0x10/0x34 include/linux/bottom_half.h:32
softirqs last disabled at (70): [<ffff800080129900>] local_bh_disable+0x10/0x34 include/linux/bottom_half.h:19
---[ end trace 0000000000000000 ]---


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
