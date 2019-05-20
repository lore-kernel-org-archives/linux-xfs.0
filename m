Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:49230 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726011AbfETKrL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 May 2019 06:47:11 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 1743028696
        for <linux-xfs@vger.kernel.org>; Mon, 20 May 2019 10:47:10 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 203655] New: XFS: Assertion failed: 0, xfs_log_recover.c, line:
 551
Date: Mon, 20 May 2019 10:47:07 +0000
Message-ID: <bug-203655-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=203655

            Bug ID: 203655
           Summary: XFS: Assertion failed: 0, xfs_log_recover.c, line: 551
           Product: File System
           Version: 2.5
    Kernel Version: 5.1.3
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: XFS
          Assignee: filesystem_xfs@kernel-bugs.kernel.org
          Reporter: midwinter1993@gmail.com
        Regression: No

Created attachment 282849
  --> https://bugzilla.kernel.org/attachment.cgi?id=282849&action=edit
Crafted image

When mounting the image (in the attached file), a kernel bug occurred in XFS.
Tested under kernel-5.1.3.

### Reproduce

1. download image.tar.gz
2. uncompress it:
> tar -xzvf image.tar.gz

3. mount it:
> mkdir dd
> mount bingo.img dd

4. check result:
> dmesg

--- Following is the core dump ---
```
[   20.766645] XFS (loop0): Log inconsistent (didn't find previous header)
[   20.767501] XFS: Assertion failed: 0, file:
.../linux-5.1.3/fs/xfs/xfs_log_recover.c, line: 551
[   20.768794] ------------[ cut here ]------------
[   20.769244] kernel BUG at .../linux-5.1.3/fs/xfs/xfs_message.c:102!
[   20.770232] invalid opcode: 0000 [#1] SMP KASAN PTI
[   20.770704] CPU: 1 PID: 2106 Comm: mount Not tainted 5.1.3 #2
[   20.771258] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
Ubuntu-1.8.2-1ubuntu1 04/01/2014
[   20.772171] RIP: 0010:assfail+0x54/0x60
[   20.772539] Code: fa 48 c1 ea 03 0f b6 04 02 48 89 fa 83 e2 07 38 d0 7f 04
84 c0 75 0c 80 3d 30 42 c7 02 00 75 0a 0f 0b c3 e8 0e e5 99 ff eb ed <0f> 0b 66
2e 0f 1f 84 00 00 00 00 00 48 63 f6 6a 01 49 89 f9 56 ba
[   20.774809] RSP: 0018:ffff88806c0d75c8 EFLAGS: 00010202
[   20.775479] RAX: 0000000000000004 RBX: 00000000000018b6 RCX:
0000000000000000
[   20.776431] RDX: 0000000000000000 RSI: 0000000000000000 RDI:
ffffffff889fd968
[   20.777343] RBP: ffff88806981a540 R08: ffff88806c0d7318 R09:
ffffed100da64c63
[   20.778263] R10: 0000000000000000 R11: ffffed100da64c62 R12:
ffff88806bd94000
[   20.779218] R13: dffffc0000000000 R14: ffff88806c0d7780 R15:
00000000000018b7
[   20.780134] FS:  00007f7fb60c5e40(0000) GS:ffff88806d300000(0000)
knlGS:0000000000000000
[   20.781167] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   20.781906] CR2: 000055d37135f8d0 CR3: 00000000697c6000 CR4:
00000000000006e0
[   20.782819] Call Trace:
[   20.783152]  xlog_find_verify_log_record+0x3fd/0x530
[   20.783801]  ? xlog_find_verify_cycle+0x3a0/0x3a0
[   20.784410]  ? xlog_bread+0xb1/0xf0
[   20.784865]  xlog_find_head+0x493/0x940
[   20.785367]  ? kfree+0x86/0x1b0
[   20.785784]  ? __kthread_create_on_node+0x294/0x380
[   20.786412]  ? xlog_find_zeroed+0x4a0/0x4a0
[   20.786957]  ? xfs_mountfs+0x1059/0x1bd0
[   20.787482]  ? mount_bdev+0x25d/0x310
[   20.787994]  ? legacy_get_tree+0xe4/0x1c0
[   20.788541]  ? vfs_get_tree+0x80/0x370
[   20.789054]  ? do_mount+0xd8c/0x2320
[   20.789542]  ? ksys_mount+0x79/0xc0
[   20.790018]  ? __x64_sys_mount+0xb5/0x150
[   20.790565]  ? do_syscall_64+0x8c/0x280
[   20.791088]  ? _raw_spin_lock+0x7f/0xe0
[   20.791615]  ? _raw_write_lock+0xe0/0xe0
[   20.792148]  ? kvm_sched_clock_read+0xd/0x20
[   20.792734]  ? sched_clock+0x5/0x10
[   20.793213]  ? sched_clock_cpu+0x18/0x160
[   20.793759]  ? task_rq_lock+0xbc/0x2d0
[   20.794271]  xlog_find_tail+0xc9/0x7b0
[   20.794783]  ? __set_cpus_allowed_ptr+0x15e/0x5c0
[   20.795421]  ? move_queued_task.isra.97+0x410/0x410
[   20.796081]  ? _sched_setscheduler+0x107/0x180
[   20.796682]  ? xlog_verify_head+0x4d0/0x4d0
[   20.797248]  ? __sched_setscheduler+0x1c90/0x1d70
[   20.797883]  ? check_preempt_wakeup+0x2c6/0x840
[   20.798514]  ? ttwu_do_wakeup.isra.92+0x13/0x2b0
[   20.799138]  xlog_recover+0x89/0x470
[   20.799628]  ? xlog_find_tail+0x7b0/0x7b0
[   20.800173]  ? set_cpus_allowed_ptr+0x10/0x10
[   20.800765]  ? kmem_alloc+0x81/0x130
[   20.801249]  xfs_log_mount+0x291/0x660
[   20.801760]  xfs_mountfs+0x1059/0x1bd0
[   20.802271]  ? xfs_mount_reset_sbqflags+0x130/0x130
[   20.802818]  ? kasan_unpoison_shadow+0x31/0x40
[   20.803206]  ? __kasan_kmalloc+0xd5/0xf0
[   20.803550]  ? kasan_unpoison_shadow+0x31/0x40
[   20.804172]  ? __kasan_kmalloc+0xd5/0xf0
[   20.804706]  ? kmem_alloc+0x81/0x130
[   20.805198]  ? xfs_filestream_put_ag+0x30/0x30
[   20.805808]  ? xfs_mru_cache_create+0x33b/0x530
[   20.806422]  xfs_fs_fill_super+0xbca/0x11d0
[   20.806990]  ? xfs_test_remount_options+0x70/0x70
[   20.807633]  mount_bdev+0x25d/0x310
[   20.808109]  ? xfs_finish_flags+0x390/0x390
[   20.808677]  legacy_get_tree+0xe4/0x1c0
[   20.809201]  vfs_get_tree+0x80/0x370
[   20.809689]  do_mount+0xd8c/0x2320
[   20.810164]  ? lockref_put_return+0x130/0x130
[   20.810755]  ? __fsnotify_update_child_dentry_flags.part.3+0x2e0/0x2e0
[   20.811625]  ? copy_mount_string+0x20/0x20
[   20.812242]  ? kasan_unpoison_shadow+0x31/0x40
[   20.812842]  ? __kasan_kmalloc+0xd5/0xf0
[   20.813377]  ? strndup_user+0x42/0x90
[   20.813876]  ? __kmalloc_track_caller+0xc7/0x1c0
[   20.814531]  ? _copy_from_user+0x73/0xa0
[   20.815063]  ? memdup_user+0x39/0x60
[   20.815548]  ksys_mount+0x79/0xc0
[   20.816004]  __x64_sys_mount+0xb5/0x150
[   20.816524]  do_syscall_64+0x8c/0x280
[   20.817026]  ? async_page_fault+0x8/0x30
[   20.817557]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[   20.818238] RIP: 0033:0x7f7fb578048a
[   20.818727] Code: 48 8b 0d 11 fa 2a 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e
0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01
f0 ff ff 73 01 c3 48 8b 0d de f9 2a 00 f7 d8 64 89 01 48
[   20.821228] RSP: 002b:00007ffe0ce9b038 EFLAGS: 00000202 ORIG_RAX:
00000000000000a5
[   20.822248] RAX: ffffffffffffffda RBX: 000055bb7b882500 RCX:
00007f7fb578048a
[   20.823223] RDX: 000055bb7b884ba0 RSI: 000055bb7b8843a0 RDI:
000055bb7b888e00
[   20.824184] RBP: 0000000000000000 R08: 0000000000000000 R09:
0000000000000020
[   20.825134] R10: 00000000c0ed0000 R11: 0000000000000202 R12:
000055bb7b888e00
[   20.826083] R13: 000055bb7b884ba0 R14: 0000000000000000 R15:
00000000ffffffff
[   20.827107] Modules linked in:
[   20.827525] Dumping ftrace buffer:
[   20.827998]    (ftrace buffer empty)
[   20.828586] ---[ end trace 6f4df2d64ffcde14 ]---
[   20.829232] RIP: 0010:assfail+0x54/0x60
[   20.829754] Code: fa 48 c1 ea 03 0f b6 04 02 48 89 fa 83 e2 07 38 d0 7f 04
84 c0 75 0c 80 3d 30 42 c7 02 00 75 0a 0f 0b c3 e8 0e e5 99 ff eb ed <0f> 0b 66
2e 0f 1f 84 00 00 00 00 00 48 63 f6 6a 01 49 89 f9 56 ba
[   20.832274] RSP: 0018:ffff88806c0d75c8 EFLAGS: 00010202
[   20.833002] RAX: 0000000000000004 RBX: 00000000000018b6 RCX:
0000000000000000
[   20.833981] RDX: 0000000000000000 RSI: 0000000000000000 RDI:
ffffffff889fd968
[   20.834957] RBP: ffff88806981a540 R08: ffff88806c0d7318 R09:
ffffed100da64c63
[   20.835933] R10: 0000000000000000 R11: ffffed100da64c62 R12:
ffff88806bd94000
[   20.836684] R13: dffffc0000000000 R14: ffff88806c0d7780 R15:
00000000000018b7
```

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
