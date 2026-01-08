Received: from mail-oo1-f77.google.com (mail-oo1-f77.google.com [209.85.161.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1592E238C1F
	for <linux-xfs@vger.kernel.org>; Thu,  8 Jan 2026 02:14:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.77
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767838465; cv=none; b=sQFP9FVjzLMyHrt9qGZxeheeNC4iUsOQHSMq4aY3/G0qO0CcHqAUqR217+H/IdHR7hHO3mrFxek4H1Vn5tJMTODZx6xiXicHRNZe9oy0xHlVpGMp647zIQSvQFx+V85uw592lYKwYeg51Lx9GypQa+ZeC3Xl4WK8RNsAF30Omts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767838465; c=relaxed/simple;
	bh=ykTzXFGKP0PVKQq822H7oRz5g6dlOKD+6KlJnpFXV8g=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=jdNCRq+Mc6icS33w9VdkZbyLMaHRCrqhkaWiaCm4nfwINy2aj3YX9ficP8VHNpyWxxVaNBvfuUJqnhH2bYePdZvqIpRGi+sXBaxI5bJy/FKednXArgvuXdOc0eXDGHIpifODYm+jdnU1AGBa4gnuNbrzud+ErFut9FcphWuO/TE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f77.google.com with SMTP id 006d021491bc7-65b73eb22d2so1434820eaf.2
        for <linux-xfs@vger.kernel.org>; Wed, 07 Jan 2026 18:14:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767838463; x=1768443263;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qk2PTNnrkdogg3Kq7VmGlTdJve12OxYuWAY9sCufHbs=;
        b=nZRVU0i+SVMvItJ2KZ/lyBggraIJUaUSfow6MX7K7r7RDbDrr5jNitSE/zP1caYF9J
         ywr8gIjCYYDTm7UqoeZMNS8d6IViVNNnyeqoy3VguzWtW/QBDMEuAqqyVYmUBHJCqrY8
         EIjyEMJl3DMgBKWc9E7fiwa+WP7bo9GJMEMzK6Se82vSFf2aGDvj4UEeaCjLnex3QBU4
         W1JmyZpgqLh/ZvMxFfoynj8W4lcMFxdIoIgFyoNDZ8wTnoayxXuBjNRNeCulHqOQga6h
         8BtxvEQANXRnTQt+B3cHzDRXZPRRhJDpv502KZSh9BYghaRuZZvdhr1YjNIDw0sa6Q13
         u7Yw==
X-Forwarded-Encrypted: i=1; AJvYcCU9lHz3A/RvsCpXUFEHhnmDAgCGmrZQO0EwyDfifxB/6pgmnJTFZYnK2A5FUwJjRz5O4zWsSnDshJ0=@vger.kernel.org
X-Gm-Message-State: AOJu0YwUn0Fq4CoiAllSuaw6RcwwdTOu2YIy/rTAaPvq3u/jOq45MTPF
	7Abw8tiJpujgjXv/BcmWcqUbxaDGxsw+z2jUVDgDcsVLyv3hl51A54pw9m2YoWnqUEldnf32L/3
	Th900DSRrjxATCTOiq80itAlztD4G/oiDVXABzlygmZJ2JxxtV0itS7Dfr1w=
X-Google-Smtp-Source: AGHT+IGjRCvQJkBbGSUa49mVzuF1YCFC+lYCiex0XWjI6CHXXo2UBcSHSE36PKVd/2/x1CfiEH9j3J2nJVhTfo3UWAxldcK4vuQE
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:22aa:b0:65c:f14f:91ca with SMTP id
 006d021491bc7-65f54f5a25cmr1834226eaf.49.1767838462982; Wed, 07 Jan 2026
 18:14:22 -0800 (PST)
Date: Wed, 07 Jan 2026 18:14:22 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <695f12fe.050a0220.1c677c.0388.GAE@google.com>
Subject: [syzbot] [xfs?] KMSAN: uninit-value in xlog_sync
From: syzbot <syzbot+97f2c05378c5d68dcb8c@syzkaller.appspotmail.com>
To: cem@kernel.org, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    aacb0a6d604a Merge tag 'pmdomain-v6.19-rc3' of git://git.k..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1709369a580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b3903bdf68407a14
dashboard link: https://syzkaller.appspot.com/bug?extid=97f2c05378c5d68dcb8c
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/24545d9fc2ef/disk-aacb0a6d.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/f2a05b79c179/vmlinux-aacb0a6d.xz
kernel image: https://storage.googleapis.com/syzbot-assets/171d38d2cf56/bzImage-aacb0a6d.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+97f2c05378c5d68dcb8c@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: uninit-value in crc32c_arch lib/crc/x86/crc32.h:90 [inline]
BUG: KMSAN: uninit-value in crc32c+0x131/0x540 lib/crc/crc32-main.c:86
 crc32c_arch lib/crc/x86/crc32.h:90 [inline]
 crc32c+0x131/0x540 lib/crc/crc32-main.c:86
 xfs_start_cksum_update fs/xfs/libxfs/xfs_cksum.h:41 [inline]
 xlog_cksum fs/xfs/xfs_log.c:1551 [inline]
 xlog_sync+0x973/0xdf0 fs/xfs/xfs_log.c:1789
 xlog_state_release_iclog+0x310/0x690 fs/xfs/xfs_log.c:568
 xlog_force_iclog fs/xfs/xfs_log.c:803 [inline]
 xlog_force_and_check_iclog fs/xfs/xfs_log.c:2815 [inline]
 xlog_force_lsn+0x8c6/0xba0 fs/xfs/xfs_log.c:2987
 xfs_log_force_seq+0x234/0x700 fs/xfs/xfs_log.c:3052
 xfs_fsync_flush_log fs/xfs/xfs_file.c:119 [inline]
 xfs_file_fsync+0x69c/0xdf0 fs/xfs/xfs_file.c:162
 vfs_fsync_range+0x1a1/0x240 fs/sync.c:188
 generic_write_sync include/linux/fs.h:2616 [inline]
 iomap_dio_complete+0xbd1/0x1030 fs/iomap/direct-io.c:125
 iomap_dio_rw+0x13c/0x180 fs/iomap/direct-io.c:851
 xfs_file_dio_write_aligned+0x23f/0x410 fs/xfs/xfs_file.c:707
 xfs_file_dio_write fs/xfs/xfs_file.c:910 [inline]
 xfs_file_write_iter+0x1025/0x10c0 fs/xfs/xfs_file.c:1122
 iter_file_splice_write+0x12b3/0x20b0 fs/splice.c:738
 do_splice_from fs/splice.c:938 [inline]
 direct_splice_actor+0x31a/0x7d0 fs/splice.c:1161
 splice_direct_to_actor+0x9a2/0x1550 fs/splice.c:1105
 do_splice_direct_actor fs/splice.c:1204 [inline]
 do_splice_direct+0x1e0/0x350 fs/splice.c:1230
 do_sendfile+0x9eb/0x1110 fs/read_write.c:1370
 __do_sys_sendfile64 fs/read_write.c:1431 [inline]
 __se_sys_sendfile64+0x1e3/0x280 fs/read_write.c:1417
 __x64_sys_sendfile64+0xbd/0x120 fs/read_write.c:1417
 x64_sys_call+0x3a6f/0x3e70 arch/x86/include/generated/asm/syscalls_64.h:41
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xd3/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Uninit was stored to memory at:
 xlog_pack_data+0x257/0x450 fs/xfs/xfs_log.c:1525
 xlog_sync+0x136/0xdf0 fs/xfs/xfs_log.c:1771
 xlog_state_release_iclog+0x310/0x690 fs/xfs/xfs_log.c:568
 xlog_force_iclog fs/xfs/xfs_log.c:803 [inline]
 xlog_force_and_check_iclog fs/xfs/xfs_log.c:2815 [inline]
 xlog_force_lsn+0x8c6/0xba0 fs/xfs/xfs_log.c:2987
 xfs_log_force_seq+0x234/0x700 fs/xfs/xfs_log.c:3052
 xfs_fsync_flush_log fs/xfs/xfs_file.c:119 [inline]
 xfs_file_fsync+0x69c/0xdf0 fs/xfs/xfs_file.c:162
 vfs_fsync_range+0x1a1/0x240 fs/sync.c:188
 generic_write_sync include/linux/fs.h:2616 [inline]
 iomap_dio_complete+0xbd1/0x1030 fs/iomap/direct-io.c:125
 iomap_dio_rw+0x13c/0x180 fs/iomap/direct-io.c:851
 xfs_file_dio_write_aligned+0x23f/0x410 fs/xfs/xfs_file.c:707
 xfs_file_dio_write fs/xfs/xfs_file.c:910 [inline]
 xfs_file_write_iter+0x1025/0x10c0 fs/xfs/xfs_file.c:1122
 iter_file_splice_write+0x12b3/0x20b0 fs/splice.c:738
 do_splice_from fs/splice.c:938 [inline]
 direct_splice_actor+0x31a/0x7d0 fs/splice.c:1161
 splice_direct_to_actor+0x9a2/0x1550 fs/splice.c:1105
 do_splice_direct_actor fs/splice.c:1204 [inline]
 do_splice_direct+0x1e0/0x350 fs/splice.c:1230
 do_sendfile+0x9eb/0x1110 fs/read_write.c:1370
 __do_sys_sendfile64 fs/read_write.c:1431 [inline]
 __se_sys_sendfile64+0x1e3/0x280 fs/read_write.c:1417
 __x64_sys_sendfile64+0xbd/0x120 fs/read_write.c:1417
 x64_sys_call+0x3a6f/0x3e70 arch/x86/include/generated/asm/syscalls_64.h:41
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xd3/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Uninit was stored to memory at:
 xlog_write_iovec fs/xfs/xfs_log.c:1937 [inline]
 xlog_write_full fs/xfs/xfs_log.c:1972 [inline]
 xlog_write+0x1d5b/0x2380 fs/xfs/xfs_log.c:2241
 xlog_cil_write_chain fs/xfs/xfs_log_cil.c:1077 [inline]
 xlog_cil_push_work+0x2fc0/0x46e0 fs/xfs/xfs_log_cil.c:1429
 process_one_work kernel/workqueue.c:3257 [inline]
 process_scheduled_works+0xb91/0x1d80 kernel/workqueue.c:3340
 worker_thread+0xedf/0x1590 kernel/workqueue.c:3421
 kthread+0xd5c/0xf00 kernel/kthread.c:463
 ret_from_fork+0x208/0x710 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:246

Uninit was stored to memory at:
 xlog_copy_iovec fs/xfs/xfs_log.h:123 [inline]
 xfs_inode_item_format_data_fork+0x78a/0x1240 fs/xfs/xfs_inode_item.c:377
 xfs_inode_item_format+0x2004/0x2360 fs/xfs/xfs_inode_item.c:675
 xlog_cil_insert_format_items fs/xfs/xfs_log_cil.c:505 [inline]
 xlog_cil_insert_items fs/xfs/xfs_log_cil.c:556 [inline]
 xlog_cil_commit+0x16cc/0x4750 fs/xfs/xfs_log_cil.c:1752
 __xfs_trans_commit+0x55c/0xf60 fs/xfs/xfs_trans.c:870
 xfs_trans_commit+0x227/0x270 fs/xfs/xfs_trans.c:928
 xfs_iomap_write_unwritten+0x926/0x10d0 fs/xfs/xfs_iomap.c:697
 xfs_dio_write_end_io+0x821/0xc40 fs/xfs/xfs_file.c:589
 iomap_dio_complete+0x174/0x1030 fs/iomap/direct-io.c:89
 iomap_dio_rw+0x13c/0x180 fs/iomap/direct-io.c:851
 xfs_file_dio_write_aligned+0x23f/0x410 fs/xfs/xfs_file.c:707
 xfs_file_dio_write fs/xfs/xfs_file.c:910 [inline]
 xfs_file_write_iter+0x1025/0x10c0 fs/xfs/xfs_file.c:1122
 iter_file_splice_write+0x12b3/0x20b0 fs/splice.c:738
 do_splice_from fs/splice.c:938 [inline]
 direct_splice_actor+0x31a/0x7d0 fs/splice.c:1161
 splice_direct_to_actor+0x9a2/0x1550 fs/splice.c:1105
 do_splice_direct_actor fs/splice.c:1204 [inline]
 do_splice_direct+0x1e0/0x350 fs/splice.c:1230
 do_sendfile+0x9eb/0x1110 fs/read_write.c:1370
 __do_sys_sendfile64 fs/read_write.c:1431 [inline]
 __se_sys_sendfile64+0x1e3/0x280 fs/read_write.c:1417
 __x64_sys_sendfile64+0xbd/0x120 fs/read_write.c:1417
 x64_sys_call+0x3a6f/0x3e70 arch/x86/include/generated/asm/syscalls_64.h:41
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xd3/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Uninit was created at:
 slab_post_alloc_hook mm/slub.c:4960 [inline]
 slab_alloc_node mm/slub.c:5263 [inline]
 __do_kmalloc_node mm/slub.c:5656 [inline]
 __kmalloc_node_track_caller_noprof+0xb77/0x1c90 mm/slub.c:5764
 __do_krealloc mm/slub.c:7014 [inline]
 krealloc_node_align_noprof+0x478/0xf60 mm/slub.c:7073
 xfs_broot_realloc+0x361/0x480 fs/xfs/libxfs/xfs_inode_fork.c:431
 xfs_bmap_broot_realloc+0x507/0x640 fs/xfs/libxfs/xfs_bmap_btree.c:-1
 xfs_bmap_extents_to_btree+0x1f8/0x1440 fs/xfs/libxfs/xfs_bmap.c:660
 xfs_bmap_add_extent_hole_real+0x226e/0x3050 fs/xfs/libxfs/xfs_bmap.c:2791
 xfs_bmapi_allocate+0x48d6/0x4f50 fs/xfs/libxfs/xfs_bmap.c:3977
 xfs_bmapi_write+0x10a3/0x26b0 fs/xfs/libxfs/xfs_bmap.c:4267
 xfs_iomap_write_direct+0x6f0/0xa50 fs/xfs/xfs_iomap.c:335
 xfs_direct_write_iomap_begin+0x1a37/0x2570 fs/xfs/xfs_iomap.c:1009
 iomap_iter+0x975/0x1390 fs/iomap/iter.c:110
 __iomap_dio_rw+0x15cc/0x3950 fs/iomap/direct-io.c:752
 iomap_dio_rw+0x5d/0x180 fs/iomap/direct-io.c:847
 xfs_file_dio_write_aligned+0x23f/0x410 fs/xfs/xfs_file.c:707
 xfs_file_dio_write fs/xfs/xfs_file.c:910 [inline]
 xfs_file_write_iter+0x1025/0x10c0 fs/xfs/xfs_file.c:1122
 iter_file_splice_write+0x12b3/0x20b0 fs/splice.c:738
 do_splice_from fs/splice.c:938 [inline]
 direct_splice_actor+0x31a/0x7d0 fs/splice.c:1161
 splice_direct_to_actor+0x9a2/0x1550 fs/splice.c:1105
 do_splice_direct_actor fs/splice.c:1204 [inline]
 do_splice_direct+0x1e0/0x350 fs/splice.c:1230
 do_sendfile+0x9eb/0x1110 fs/read_write.c:1370
 __do_sys_sendfile64 fs/read_write.c:1431 [inline]
 __se_sys_sendfile64+0x1e3/0x280 fs/read_write.c:1417
 __x64_sys_sendfile64+0xbd/0x120 fs/read_write.c:1417
 x64_sys_call+0x3a6f/0x3e70 arch/x86/include/generated/asm/syscalls_64.h:41
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xd3/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

CPU: 0 UID: 0 PID: 10729 Comm: syz.4.1732 Not tainted syzkaller #0 PREEMPT(none) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/25/2025
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
