Received: from mail-il1-f205.google.com (mail-il1-f205.google.com [209.85.166.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D7C91C36
	for <linux-xfs@vger.kernel.org>; Thu, 23 May 2024 01:43:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716428604; cv=none; b=XzMIwa89t7cG5z/DBy6aZNm3AASn1+p17S9gPnYOxdnsvCJA5uB0fkPUj/M+a9pG22vtyCctl27liXCN64d6O15nt8BJXkI9tDofQL6SgirpfvmAHoa+0C4IbYE/QOGW2TRusvd/i/vyAg7ah1kO3EkRcQXRX49pgcfh2V1CwEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716428604; c=relaxed/simple;
	bh=Z5WdbOyFbS252rSgLKRem8n+kAHsN9IjibFP7J7flHQ=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=DzLlb+d54YZJzW4zffZjObWDmzLWUxSVzL+L6UMmbs/N7SrraRDBbFjVic9WvnPuEmI+zdi8yYA/QgvHGBOFXCFqsAxVdSISZMHTXM2Cm941UN6EFKExX0iQ3G1sThEbaT38eHxsBdOlhHe1VLFoQed4Tni6WSFtrJViuqn/b1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f205.google.com with SMTP id e9e14a558f8ab-36c8c30f0edso14347435ab.2
        for <linux-xfs@vger.kernel.org>; Wed, 22 May 2024 18:43:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716428601; x=1717033401;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EfGOwghk0SEybfh8KkfhSSWI7803jUVK6U//DXwFXno=;
        b=quLEX3oqOfJPaPSzyblWVyAuNX99hSxiIV19H4pUQtjvVzKS9Wj5N8b4FlR57VklWx
         orAeVzQ/y117Sl9qJfdPEIycvC7JK2gzEzKOIo7fuj2L1BcCDlma/xscFIHbrirxFZFM
         pbaT9do3Q+kyc/+R33iEWcqOf35eOsSgMSbV4lirljgcZ9Og13WeIfWapiVl+4IlnMa8
         hlGp4/mvRalaq0OgvBbi69BKLpcdBxygJcJ/mnY5zzQr3mHQUHTfJ2TH1gda75pPEqmP
         7ZEGdBpq4yaz4bldijPcErUFNXQesi1xeolk/fQ1vndKhOaN45MqngTVa3wz6GAU4ros
         Re/w==
X-Forwarded-Encrypted: i=1; AJvYcCX21NfAXg8iBAyraDEfynjcdVDdME5H9gd2KkzBUUljsbdN19eQSMHFL22QAyLE5LgEo8CXQgyFaw6sbmob3uuqOLlkqO4MYJ7J
X-Gm-Message-State: AOJu0YzmVPefvMfxlB+nKR0MfRROjm3uO4UMTJodtCLspnGAs3yP9yh3
	QI7+7TJalT9F7InwdVMfnZx1HxxDhktViU0TgDYOWDDap+7C6IMLm0j7x9WGApm2BSBWgpTpHJF
	elhvKTRd+A5pxREegOJqVftA2W/fFLPT9h/cl85VCgDWXWNC0AksWaxc=
X-Google-Smtp-Source: AGHT+IFcRc/GlHtCDjx7gDnLS8p3d5nIGXpLvlZqLJU38jtJZ6rK4/24MovDS4MaQQP81TeeSfzYKBFVInIto7xM4eNS2y5HfCvr
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1c87:b0:36d:a6b0:f4fa with SMTP id
 e9e14a558f8ab-371fcdae973mr2622235ab.4.1716428601659; Wed, 22 May 2024
 18:43:21 -0700 (PDT)
Date: Wed, 22 May 2024 18:43:21 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000015a57d0619152dcd@google.com>
Subject: [syzbot] [xfs?] possible deadlock in xfs_ilock_attr_map_shared
From: syzbot <syzbot+069cc167ecbee6e3e91a@syzkaller.appspotmail.com>
To: chandan.babu@oracle.com, djwong@kernel.org, linux-kernel@vger.kernel.org, 
	linux-xfs@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    4b377b4868ef kprobe/ftrace: fix build error due to bad fun..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=16f19368980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=17ffd15f654c98ba
dashboard link: https://syzkaller.appspot.com/bug?extid=069cc167ecbee6e3e91a
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/80503f9339d4/disk-4b377b48.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/c74a52927209/vmlinux-4b377b48.xz
kernel image: https://storage.googleapis.com/syzbot-assets/6ea396d85317/bzImage-4b377b48.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+069cc167ecbee6e3e91a@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
6.9.0-syzkaller-08544-g4b377b4868ef #0 Not tainted
------------------------------------------------------
syz-executor.3/11981 is trying to acquire lock:
ffffffff8e42ad40 (fs_reclaim){+.+.}-{0:0}, at: might_alloc include/linux/sched/mm.h:312 [inline]
ffffffff8e42ad40 (fs_reclaim){+.+.}-{0:0}, at: slab_pre_alloc_hook mm/slub.c:3819 [inline]
ffffffff8e42ad40 (fs_reclaim){+.+.}-{0:0}, at: slab_alloc_node mm/slub.c:3900 [inline]
ffffffff8e42ad40 (fs_reclaim){+.+.}-{0:0}, at: __do_kmalloc_node mm/slub.c:4038 [inline]
ffffffff8e42ad40 (fs_reclaim){+.+.}-{0:0}, at: __kmalloc+0xb7/0x4a0 mm/slub.c:4052

but task is already holding lock:
ffff88806a1308d8 (&xfs_dir_ilock_class){++++}-{3:3}, at: xfs_ilock_attr_map_shared+0x8c/0xc0 fs/xfs/xfs_inode.c:126

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (&xfs_dir_ilock_class){++++}-{3:3}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5754
       down_write_nested+0x3d/0x50 kernel/locking/rwsem.c:1695
       xfs_reclaim_inode fs/xfs/xfs_icache.c:945 [inline]
       xfs_icwalk_process_inode fs/xfs/xfs_icache.c:1631 [inline]
       xfs_icwalk_ag+0x120e/0x1ad0 fs/xfs/xfs_icache.c:1713
       xfs_icwalk fs/xfs/xfs_icache.c:1762 [inline]
       xfs_reclaim_inodes_nr+0x257/0x360 fs/xfs/xfs_icache.c:1011
       super_cache_scan+0x411/0x4b0 fs/super.c:227
       do_shrink_slab+0x707/0x1160 mm/shrinker.c:435
       shrink_slab_memcg mm/shrinker.c:548 [inline]
       shrink_slab+0x883/0x14d0 mm/shrinker.c:626
       shrink_one+0x453/0x880 mm/vmscan.c:4774
       shrink_many mm/vmscan.c:4835 [inline]
       lru_gen_shrink_node mm/vmscan.c:4935 [inline]
       shrink_node+0x3b17/0x4310 mm/vmscan.c:5894
       kswapd_shrink_node mm/vmscan.c:6704 [inline]
       balance_pgdat mm/vmscan.c:6895 [inline]
       kswapd+0x1882/0x38a0 mm/vmscan.c:7164
       kthread+0x2f2/0x390 kernel/kthread.c:389
       ret_from_fork+0x4d/0x80 arch/x86/kernel/process.c:147
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

-> #0 (fs_reclaim){+.+.}-{0:0}:
       check_prev_add kernel/locking/lockdep.c:3134 [inline]
       check_prevs_add kernel/locking/lockdep.c:3253 [inline]
       validate_chain+0x18cb/0x58e0 kernel/locking/lockdep.c:3869
       __lock_acquire+0x1346/0x1fd0 kernel/locking/lockdep.c:5137
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5754
       __fs_reclaim_acquire mm/page_alloc.c:3698 [inline]
       fs_reclaim_acquire+0x88/0x140 mm/page_alloc.c:3712
       might_alloc include/linux/sched/mm.h:312 [inline]
       slab_pre_alloc_hook mm/slub.c:3819 [inline]
       slab_alloc_node mm/slub.c:3900 [inline]
       __do_kmalloc_node mm/slub.c:4038 [inline]
       __kmalloc+0xb7/0x4a0 mm/slub.c:4052
       kmalloc include/linux/slab.h:632 [inline]
       xfs_attr_shortform_list+0x6f3/0x17a0 fs/xfs/xfs_attr_list.c:115
       xfs_attr_list_ilocked fs/xfs/xfs_attr_list.c:527 [inline]
       xfs_attr_list+0x25b/0x350 fs/xfs/xfs_attr_list.c:547
       xfs_vn_listxattr+0x1d2/0x2c0 fs/xfs/xfs_xattr.c:314
       vfs_listxattr fs/xattr.c:493 [inline]
       listxattr+0x109/0x290 fs/xattr.c:840
       path_listxattr fs/xattr.c:864 [inline]
       __do_sys_listxattr fs/xattr.c:876 [inline]
       __se_sys_listxattr fs/xattr.c:873 [inline]
       __x64_sys_listxattr+0x176/0x240 fs/xattr.c:873
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf5/0x240 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

other info that might help us debug this:

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  rlock(&xfs_dir_ilock_class);
                               lock(fs_reclaim);
                               lock(&xfs_dir_ilock_class);
  lock(fs_reclaim);

 *** DEADLOCK ***

1 lock held by syz-executor.3/11981:
 #0: ffff88806a1308d8 (&xfs_dir_ilock_class){++++}-{3:3}, at: xfs_ilock_attr_map_shared+0x8c/0xc0 fs/xfs/xfs_inode.c:126

stack backtrace:
CPU: 0 PID: 11981 Comm: syz-executor.3 Not tainted 6.9.0-syzkaller-08544-g4b377b4868ef #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/02/2024
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:114
 check_noncircular+0x36a/0x4a0 kernel/locking/lockdep.c:2187
 check_prev_add kernel/locking/lockdep.c:3134 [inline]
 check_prevs_add kernel/locking/lockdep.c:3253 [inline]
 validate_chain+0x18cb/0x58e0 kernel/locking/lockdep.c:3869
 __lock_acquire+0x1346/0x1fd0 kernel/locking/lockdep.c:5137
 lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5754
 __fs_reclaim_acquire mm/page_alloc.c:3698 [inline]
 fs_reclaim_acquire+0x88/0x140 mm/page_alloc.c:3712
 might_alloc include/linux/sched/mm.h:312 [inline]
 slab_pre_alloc_hook mm/slub.c:3819 [inline]
 slab_alloc_node mm/slub.c:3900 [inline]
 __do_kmalloc_node mm/slub.c:4038 [inline]
 __kmalloc+0xb7/0x4a0 mm/slub.c:4052
 kmalloc include/linux/slab.h:632 [inline]
 xfs_attr_shortform_list+0x6f3/0x17a0 fs/xfs/xfs_attr_list.c:115
 xfs_attr_list_ilocked fs/xfs/xfs_attr_list.c:527 [inline]
 xfs_attr_list+0x25b/0x350 fs/xfs/xfs_attr_list.c:547
 xfs_vn_listxattr+0x1d2/0x2c0 fs/xfs/xfs_xattr.c:314
 vfs_listxattr fs/xattr.c:493 [inline]
 listxattr+0x109/0x290 fs/xattr.c:840
 path_listxattr fs/xattr.c:864 [inline]
 __do_sys_listxattr fs/xattr.c:876 [inline]
 __se_sys_listxattr fs/xattr.c:873 [inline]
 __x64_sys_listxattr+0x176/0x240 fs/xattr.c:873
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf5/0x240 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fa1f3a7cee9
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 e1 20 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fa1f48160c8 EFLAGS: 00000246 ORIG_RAX: 00000000000000c2
RAX: ffffffffffffffda RBX: 00007fa1f3bac050 RCX: 00007fa1f3a7cee9
RDX: 0000000000000011 RSI: 0000000000000000 RDI: 0000000020000140
RBP: 00007fa1f3ac949e R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 000000000000006e R14: 00007fa1f3bac050 R15: 00007ffdecee0588
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
