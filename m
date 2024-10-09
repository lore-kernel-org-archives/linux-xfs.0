Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E19C02F46
	for <linux-xfs@vger.kernel.org>; Wed,  9 Oct 2024 05:12:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728450746; cv=none; b=uFx66dwjF8yD+zQTFQgBTEaUGlUyCXNpcW9/xbvjWbST4dJ29ifd0gZj907qbub69GtoDTlrtYGGQ6YdBLy9DtEvBYhldDRiopwA4dj7jV4A9by0lHYep5TGJgU3H76uyGnkNLa06p/KfrEs//4lcByWXmpqYf7OjHbF0ufLcuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728450746; c=relaxed/simple;
	bh=7WTn9XEairr5J5mf2GodM9sUaNrqxM4Dlbe+8MGhhIw=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=IWsZVFthiV4mAq5dM07w1NjW3XjZq64nNtuv97ftRwuhFnzq3k+QhguRbgGSVwKxtIiiRvTWNzk82Eg3XK5XFjf0WO7cFxAdfifGYbhEJfjnb2Xxp2gLCPutBKzexnEtu1iAndftRVNf06VW6IW4vA/L7c7h99mDK4FFRQ+Rifg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-3a36ada9ce7so61532655ab.2
        for <linux-xfs@vger.kernel.org>; Tue, 08 Oct 2024 22:12:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728450744; x=1729055544;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9B2xga9VYJ2YPNvVTsksZaRz3GiKA9SnvAWY0ThC3vE=;
        b=e7kHuWDR7AqoC1kpHgzb9nXx6AUOlSxWLyUKi4FnRBWCEJU+nUrFu3s3x0ZXVeD9lM
         lqVG3kWu5qw3S5Q5Gqzr5rRsD5ubB535oEZ1PvvYA0x02/M2qFtrVeOY1RzPNgqUmz3r
         HgVCh5bESVpPkZj1SKRrYymVoJoOFRy0eTvbEhlwR2JMt8n9bbMPifPtjLvkKTBScj/b
         /j2msZgZgP6ViDe4kuW3u+WPm3hRcvEvh99KqtrdZXuuOW5jE6uLL7AJ+z8BK+DxIC+k
         /wyCNuo5HbSkWzvuWSfZg2F0g8ZqtIS0XMablh/dEENoYq0AdGwi3TE+b2ej/OwBfQS+
         afwQ==
X-Forwarded-Encrypted: i=1; AJvYcCVi1h5iZrkXvcSrthlduDxvY+ykIxWPwo3kLbfjH0ZnrFZ0LnW/VUEfrGnCD9Nk1r2fIGJLZRLjsGs=@vger.kernel.org
X-Gm-Message-State: AOJu0YyGsL5JPcgxzehACzGqihcCRnk6tHn6bNBP8x+lxXdVvZZxMW2x
	OBrApRnteo3WHKhF8bbHEAKHQoNoTCCPHXOwDOHo4jqQ4Bf3VyLY3szeAJOm8Xt8CwafETCOElx
	+MY6TLStPzL+va3LtMwY/QYw62MkjRi3s0A6T4eZgtM2vOIPT/zaC/20=
X-Google-Smtp-Source: AGHT+IFvmGbFFcmNTETDDtH9cpf5HoAmSWOED7xwdt13G21V3SOkcutg2DLIi+iSZVDZAlsvB9RwroX8Yb+PCIhqzRejiLX1UXoS
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1ca1:b0:3a0:4a91:224f with SMTP id
 e9e14a558f8ab-3a397ce85b3mr10545185ab.1.1728450743994; Tue, 08 Oct 2024
 22:12:23 -0700 (PDT)
Date: Tue, 08 Oct 2024 22:12:23 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <670610b7.050a0220.22840d.000e.GAE@google.com>
Subject: [syzbot] [xfs?] possible deadlock in xfs_buffered_write_iomap_end
From: syzbot <syzbot+3d96bb110d05e208ae9e@syzkaller.appspotmail.com>
To: chandan.babu@oracle.com, djwong@kernel.org, linux-kernel@vger.kernel.org, 
	linux-xfs@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    c02d24a5af66 Add linux-next specific files for 20241003
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=126f5307980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=94f9caf16c0af42d
dashboard link: https://syzkaller.appspot.com/bug?extid=3d96bb110d05e208ae9e
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/641e642c9432/disk-c02d24a5.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/98aaf20c29e0/vmlinux-c02d24a5.xz
kernel image: https://storage.googleapis.com/syzbot-assets/c23099f2d86b/bzImage-c02d24a5.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+3d96bb110d05e208ae9e@syzkaller.appspotmail.com

loop0: detected capacity change from 32768 to 0
syz.0.409: attempt to access beyond end of device
loop0: rw=2048, sector=18728, nr_sectors = 4 limit=0
============================================
WARNING: possible recursive locking detected
6.12.0-rc1-next-20241003-syzkaller #0 Not tainted
--------------------------------------------
syz.0.409/9596 is trying to acquire lock:
ffff88805e4b0c90 (mapping.invalidate_lock#6){++++}-{3:3}, at: filemap_invalidate_lock include/linux/fs.h:860 [inline]
ffff88805e4b0c90 (mapping.invalidate_lock#6){++++}-{3:3}, at: xfs_buffered_write_iomap_end+0x20c/0x490 fs/xfs/xfs_iomap.c:1246

but task is already holding lock:
ffff88805e4b0c90 (mapping.invalidate_lock#6){++++}-{3:3}, at: xfs_ilock+0x193/0x3d0 fs/xfs/xfs_inode.c:156

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(mapping.invalidate_lock#6);
  lock(mapping.invalidate_lock#6);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

3 locks held by syz.0.409/9596:
 #0: ffff888077bc0420 (sb_writers#19){++++}-{0:0}, at: file_start_write include/linux/fs.h:2950 [inline]
 #0: ffff888077bc0420 (sb_writers#19){++++}-{0:0}, at: vfs_fallocate+0x4fe/0x6e0 fs/open.c:332
 #1: ffff88805e4b0af0 (&sb->s_type->i_mutex_key#27){++++}-{3:3}, at: xfs_ilock+0x102/0x3d0 fs/xfs/xfs_inode.c:148
 #2: ffff88805e4b0c90 (mapping.invalidate_lock#6){++++}-{3:3}, at: xfs_ilock+0x193/0x3d0 fs/xfs/xfs_inode.c:156

stack backtrace:
CPU: 1 UID: 0 PID: 9596 Comm: syz.0.409 Not tainted 6.12.0-rc1-next-20241003-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
 print_deadlock_bug+0x483/0x620 kernel/locking/lockdep.c:3037
 check_deadlock kernel/locking/lockdep.c:3089 [inline]
 validate_chain+0x15e2/0x5920 kernel/locking/lockdep.c:3891
 __lock_acquire+0x1384/0x2050 kernel/locking/lockdep.c:5202
 lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5825
 down_write+0x99/0x220 kernel/locking/rwsem.c:1577
 filemap_invalidate_lock include/linux/fs.h:860 [inline]
 xfs_buffered_write_iomap_end+0x20c/0x490 fs/xfs/xfs_iomap.c:1246
 iomap_iter+0x220/0xf60 fs/iomap/iter.c:79
 iomap_file_unshare+0x380/0x6d0 fs/iomap/buffered-io.c:1343
 xfs_reflink_unshare+0x173/0x5f0 fs/xfs/xfs_reflink.c:1681
 xfs_falloc_unshare_range+0x164/0x390 fs/xfs/xfs_file.c:1033
 xfs_file_fallocate+0x289/0x3d0 fs/xfs/xfs_file.c:1125
 vfs_fallocate+0x569/0x6e0 fs/open.c:333
 ksys_fallocate fs/open.c:356 [inline]
 __do_sys_fallocate fs/open.c:364 [inline]
 __se_sys_fallocate fs/open.c:362 [inline]
 __x64_sys_fallocate+0xbd/0x110 fs/open.c:362
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f3f1df7dff9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f3f1ee0b038 EFLAGS: 00000246 ORIG_RAX: 000000000000011d
RAX: ffffffffffffffda RBX: 00007f3f1e135f80 RCX: 00007f3f1df7dff9
RDX: 000000000000000a RSI: 0000000000000040 RDI: 0000000000000004
RBP: 00007f3f1dff0296 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000005 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 00007f3f1e135f80 R15: 00007fffd33b9598
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
