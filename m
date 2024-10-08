Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D83D82185B0
	for <linux-xfs@vger.kernel.org>; Tue,  8 Oct 2024 23:43:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728431005; cv=none; b=X1YSmGuJOV1DdhEn1Hc/MfnDQUGzpWZBvcoQiW5KNRZOWqNZLSEyoLE5DsrGerRjooGdVDHtVkDplxCMQsolApERr1sH0sGUGk6bcaj4mHYqY2Xn+1grSO1SiBV96LrKPpnZv0mD/FT6t44p5Cz5dqwbH2T9dtjzSc6LTmyShec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728431005; c=relaxed/simple;
	bh=hvFwZ685hyIt21w8mmdVedVdoaIqNJBwbKnv8axuuro=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=YC2/Es9Ep8BLtubjZSpnlsCfnUrRI8JvrlWKsd62rRaCC+YrA0nTkmFpaNDH5eMQtF4P+PIyimpzM6p58ZE3hmw1QSjSjdS0vxtHOVvSY8A1CY1tgT9GDZ80LJnlg5lkmCPOLR5YmPoL4aIkfEHGnQRJDU6ThD/DzRfNsGg0UJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3a3972c435dso4000065ab.0
        for <linux-xfs@vger.kernel.org>; Tue, 08 Oct 2024 16:43:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728431003; x=1729035803;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xXzKkitN8PR+TnJMD7nb2qAAUzE05QdQUBobAP0aOT4=;
        b=hqw6lnchzyhxAhfGxfcIpmJgafD+GAFVnzCmBcnwz0+FBWFlzgAvprGu2rzxypsuMb
         XOWW4I+lIXOO+Q2GLnicxEcbuzURwl7klhkICQUStZ/+QDfwXfgQMtXt9+xr7ZDaQxyj
         68zjgz6UsU+axI/AnQ7Z/8z4dnOpRD5Kp6WqFgf67rOvCGn/qtdvbpQHVkefe531iX3y
         +YuD/s7r+uvq3bKcqr2U6XTimwcAAoDZ8oSD571JoL3vYB4U+/nY1NHqY0Yh10Rb2JFR
         ofuBKXrW7q/5Gl4OLb53R2q+YHn5WhteAUKwXshcCTzyvncY65xKnantXtDmL5gCvfFd
         nDZQ==
X-Forwarded-Encrypted: i=1; AJvYcCWLO0H2/J8XqC8J0dOnseOMDVO9CcbmXupUpHY750h9GVC5eNu5fT17pYlZFh5jHzsW4rHDKFlfOlI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxIyo8t5bFr9bJg50KZFx1jv2Mnl/h+NYH1IgpwHAbk2zlyQFSl
	dNnV13Opp7vfaJfHP8YlmNUfKIqdSGhcrNo3AviJq7ooIoegP7uT0WyixWep6w+Mh6JLto1y6d+
	e08sQLJ/+hIePL3PlQJoZ/7BDWIvG+Y37P6ogJqJSOny/D7mt91M1Pp0=
X-Google-Smtp-Source: AGHT+IHOEOB1mxvcC94blicK1WU6cHtMi0YFohOr/46UT26ZKSKjL/HJqShcOVupslfDZ+mBlIEZaUH/7bXqYKTr0+ian45vBTpB
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a92:c56e:0:b0:3a2:76c9:f2b7 with SMTP id
 e9e14a558f8ab-3a397d17d54mr5288605ab.24.1728431003100; Tue, 08 Oct 2024
 16:43:23 -0700 (PDT)
Date: Tue, 08 Oct 2024 16:43:23 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6705c39b.050a0220.22840d.000a.GAE@google.com>
Subject: [syzbot] [xfs?] KFENCE: memory corruption in xfs_idata_realloc
From: syzbot <syzbot+8a8170685a482c92e86a@syzkaller.appspotmail.com>
To: chandan.babu@oracle.com, djwong@kernel.org, linux-kernel@vger.kernel.org, 
	linux-xfs@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    c02d24a5af66 Add linux-next specific files for 20241003
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=164f779f980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=94f9caf16c0af42d
dashboard link: https://syzkaller.appspot.com/bug?extid=8a8170685a482c92e86a
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13012707980000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/641e642c9432/disk-c02d24a5.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/98aaf20c29e0/vmlinux-c02d24a5.xz
kernel image: https://storage.googleapis.com/syzbot-assets/c23099f2d86b/bzImage-c02d24a5.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/547c3034fd79/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+8a8170685a482c92e86a@syzkaller.appspotmail.com

XFS (loop2): Quotacheck: Done.
==================================================================
BUG: KFENCE: memory corruption in krealloc_noprof+0x160/0x2e0

Corrupted memory at 0xffff88823bedafeb [ 0x03 0x00 0xd8 0x62 0x75 0x73 0x01 0x00 0x00 0x11 0x4c 0x00 0x00 0x00 0x00 0x00 ] (in kfence-#108):
 krealloc_noprof+0x160/0x2e0
 xfs_idata_realloc+0x116/0x1b0 fs/xfs/libxfs/xfs_inode_fork.c:523
 xfs_dir2_sf_addname_easy fs/xfs/libxfs/xfs_dir2_sf.c:469 [inline]
 xfs_dir2_sf_addname+0x899/0x1b60 fs/xfs/libxfs/xfs_dir2_sf.c:432
 xfs_dir_createname_args+0x152/0x200 fs/xfs/libxfs/xfs_dir2.c:308
 xfs_dir_createname+0x4b3/0x640 fs/xfs/libxfs/xfs_dir2.c:361
 xfs_dir_create_child+0xe3/0x490 fs/xfs/libxfs/xfs_dir2.c:860
 xfs_create+0x8cc/0xf60 fs/xfs/xfs_inode.c:722
 xfs_generic_create+0x5d5/0xf50 fs/xfs/xfs_iops.c:213
 lookup_open fs/namei.c:3595 [inline]
 open_last_lookups fs/namei.c:3694 [inline]
 path_openat+0x1c03/0x3590 fs/namei.c:3930
 do_filp_open+0x235/0x490 fs/namei.c:3960
 do_sys_openat2+0x13e/0x1d0 fs/open.c:1415
 do_sys_open fs/open.c:1430 [inline]
 __do_sys_openat fs/open.c:1446 [inline]
 __se_sys_openat fs/open.c:1441 [inline]
 __x64_sys_openat+0x247/0x2a0 fs/open.c:1441
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

kfence-#108: 0xffff88823bedafa0-0xffff88823bedafea, size=75, cache=kmalloc-96

allocated by task 7203 on cpu 1 at 147.184900s (0.409032s ago):
 kmalloc_noprof include/linux/slab.h:882 [inline]
 xfs_init_local_fork fs/xfs/libxfs/xfs_inode_fork.c:55 [inline]
 xfs_iformat_local+0x2db/0x620 fs/xfs/libxfs/xfs_inode_fork.c:97
 xfs_iformat_data_fork+0x38f/0x7b0 fs/xfs/libxfs/xfs_inode_fork.c:264
 xfs_inode_from_disk+0xaa9/0xf60 fs/xfs/libxfs/xfs_inode_buf.c:254
 xfs_iget_cache_miss fs/xfs/xfs_icache.c:683 [inline]
 xfs_iget+0xc5a/0x2f00 fs/xfs/xfs_icache.c:821
 xfs_mountfs+0x1040/0x2020 fs/xfs/xfs_mount.c:873
 xfs_fs_fill_super+0x11f0/0x1460 fs/xfs/xfs_super.c:1765
 get_tree_bdev+0x3f7/0x570 fs/super.c:1635
 vfs_get_tree+0x90/0x2b0 fs/super.c:1800
 do_new_mount+0x2be/0xb40 fs/namespace.c:3507
 do_mount fs/namespace.c:3847 [inline]
 __do_sys_mount fs/namespace.c:4055 [inline]
 __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:4032
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

freed by task 7203 on cpu 0 at 147.535434s (0.189887s ago):
 krealloc_noprof+0x160/0x2e0
 xfs_idata_realloc+0x116/0x1b0 fs/xfs/libxfs/xfs_inode_fork.c:523
 xfs_dir2_sf_addname_easy fs/xfs/libxfs/xfs_dir2_sf.c:469 [inline]
 xfs_dir2_sf_addname+0x899/0x1b60 fs/xfs/libxfs/xfs_dir2_sf.c:432
 xfs_dir_createname_args+0x152/0x200 fs/xfs/libxfs/xfs_dir2.c:308
 xfs_dir_createname+0x4b3/0x640 fs/xfs/libxfs/xfs_dir2.c:361
 xfs_dir_create_child+0xe3/0x490 fs/xfs/libxfs/xfs_dir2.c:860
 xfs_create+0x8cc/0xf60 fs/xfs/xfs_inode.c:722
 xfs_generic_create+0x5d5/0xf50 fs/xfs/xfs_iops.c:213
 lookup_open fs/namei.c:3595 [inline]
 open_last_lookups fs/namei.c:3694 [inline]
 path_openat+0x1c03/0x3590 fs/namei.c:3930
 do_filp_open+0x235/0x490 fs/namei.c:3960
 do_sys_openat2+0x13e/0x1d0 fs/open.c:1415
 do_sys_open fs/open.c:1430 [inline]
 __do_sys_openat fs/open.c:1446 [inline]
 __se_sys_openat fs/open.c:1441 [inline]
 __x64_sys_openat+0x247/0x2a0 fs/open.c:1441
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

CPU: 0 UID: 0 PID: 7203 Comm: syz.2.194 Not tainted 6.12.0-rc1-next-20241003-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
==================================================================


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
