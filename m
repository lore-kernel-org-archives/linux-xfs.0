Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:53238 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731054AbfETOah (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 May 2019 10:30:37 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 8EA42288EF
        for <linux-xfs@vger.kernel.org>; Mon, 20 May 2019 14:30:36 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 203653] XFS: Internal error xlog_clear_stale_blocks(2) at line
 1794 of file ../fs/xfs/xfs_log_recover.c
Date: Mon, 20 May 2019 14:30:34 +0000
Message-ID: <bug-203653-201763-7xoeyr3RHN@https.bugzilla.kernel.org/>
In-Reply-To: <bug-203653-201763@https.bugzilla.kernel.org/>
References: <bug-203653-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=203653

--- Comment #1 from bfoster@redhat.com ---
On Mon, May 20, 2019 at 06:15:42AM +0000, bugzilla-daemon@bugzilla.kernel.org
wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=203653
> 
>             Bug ID: 203653
>            Summary: XFS: Internal error xlog_clear_stale_blocks(2) at line
>                     1794 of file ../fs/xfs/xfs_log_recover.c
>            Product: File System
>            Version: 2.5
>     Kernel Version: 5.1.3
>           Hardware: All
>                 OS: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: XFS
>           Assignee: filesystem_xfs@kernel-bugs.kernel.org
>           Reporter: midwinter1993@gmail.com
>         Regression: No
> 
> Created attachment 282847
>   --> https://bugzilla.kernel.org/attachment.cgi?id=282847&action=edit
> Crafted image
> 
> ### When mounting the image (in the attached file), XFS prints an internal
> error.
> ### Tested under kernel 5.1.3 and 4.4.0.
> 
> ### Reproduce
> 
> 1. download `image.tar.gz`
> 2. uncompress it: 
> > tar -xzvf image.tar.gz
> 
> 3. mount it: 
> > mkdir dd
> > mount bingo.img dd
> 
> 4. check result:
> > dmesg
> 
> --- Following is the core dump (under kernel 5.1.3) ---
> ```
> [   67.737771] XFS (loop0): Internal error xlog_clear_stale_blocks(2) at line
> 1794 of file ../fs/xfs/xfs_log_recover.c.  Caller xlog_find_tail+0x622/0x7b0
> [   67.742886] CPU: 0 PID: 2114 Comm: mount Not tainted 5.1.3 #2
> [   67.744338] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
> Ubuntu-1.8.2-1ubuntu1 04/01/2014
> [   67.746410] Call Trace:
> [   67.746983]  dump_stack+0x5b/0x8b
> [   67.747718]  xlog_clear_stale_blocks+0x2d5/0x3d0
> [   67.748389]  xlog_find_tail+0x622/0x7b0
> [   67.748934]  ? _sched_setscheduler+0x107/0x180
> [   67.749559]  ? xlog_verify_head+0x4d0/0x4d0
> [   67.750148]  ? __sched_setscheduler+0x1c90/0x1d70
> [   67.750810]  ? check_preempt_wakeup+0x2c6/0x840
> [   67.751440]  ? ttwu_do_wakeup.isra.92+0x13/0x2b0
> [   67.752079]  xlog_recover+0x89/0x470
> [   67.752551]  ? xlog_find_tail+0x7b0/0x7b0
> [   67.753084]  ? kmem_alloc+0x81/0x130
> [   67.753562]  xfs_log_mount+0x291/0x660
> [   67.754063]  xfs_mountfs+0x1059/0x1bd0
> [   67.754565]  ? xfs_mount_reset_sbqflags+0x130/0x130
> [   67.755216]  ? kasan_unpoison_shadow+0x31/0x40
> [   67.755810]  ? __kasan_kmalloc+0xd5/0xf0
> [   67.756332]  ? kasan_unpoison_shadow+0x31/0x40
> [   67.756918]  ? __kasan_kmalloc+0xd5/0xf0
> [   67.757438]  ? kmem_alloc+0x81/0x130
> [   67.757912]  ? xfs_filestream_put_ag+0x30/0x30
> [   67.758499]  ? xfs_mru_cache_create+0x33b/0x530
> [   67.759099]  xfs_fs_fill_super+0xbca/0x11d0
> [   67.759660]  ? xfs_test_remount_options+0x70/0x70
> [   67.760287]  mount_bdev+0x25d/0x310
> [   67.760751]  ? xfs_finish_flags+0x390/0x390
> [   67.761306]  legacy_get_tree+0xe4/0x1c0
> [   67.761817]  vfs_get_tree+0x80/0x370
> [   67.762295]  do_mount+0xd8c/0x2320
> [   67.762755]  ? lockref_put_return+0x130/0x130
> [   67.763333]  ? __fsnotify_update_child_dentry_flags.part.3+0x2e0/0x2e0
> [   67.764191]  ? copy_mount_string+0x20/0x20
> [   67.764732]  ? kasan_unpoison_shadow+0x31/0x40
> [   67.765315]  ? __kasan_kmalloc+0xd5/0xf0
> [   67.765830]  ? strndup_user+0x42/0x90
> [   67.766316]  ? __kmalloc_track_caller+0xc7/0x1c0
> [   67.766928]  ? _copy_from_user+0x73/0xa0
> [   67.767449]  ? memdup_user+0x39/0x60
> [   67.767931]  ksys_mount+0x79/0xc0
> [   67.768376]  __x64_sys_mount+0xb5/0x150
> [   67.768889]  do_syscall_64+0x8c/0x280
> [   67.769377]  ? async_page_fault+0x8/0x30
> [   67.769906]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> [   67.770577] RIP: 0033:0x7f0c5185d48a
> [   67.771053] Code: 48 8b 0d 11 fa 2a 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e
> 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 49 89 ca b8 a5 00 00 00
> 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d de f9 2a 00 f7 d8 64 89 01 48
> [   67.773494] RSP: 002b:00007fff68c36b38 EFLAGS: 00000202 ORIG_RAX:
> 00000000000000a5
> [   67.774493] RAX: ffffffffffffffda RBX: 00005565e0f62080 RCX:
> 00007f0c5185d48a
> [   67.775420] RDX: 00005565e0f68db0 RSI: 00005565e0f63f60 RDI:
> 00005565e0f68d90
> [   67.776358] RBP: 0000000000000000 R08: 0000000000000000 R09:
> 0000000000000020
> [   67.777292] R10: 00000000c0ed0000 R11: 0000000000000202 R12:
> 00005565e0f68d90
> [   67.778227] R13: 00005565e0f68db0 R14: 0000000000000000 R15:
> 00000000ffffffff
> [   67.779226] XFS (loop0): failed to locate log tail
> [   67.779881] XFS (loop0): log mount/recovery failed: error -117
> [   67.780969] XFS (loop0): log mount failed
> ```
> 
> -- 
> You are receiving this mail because:
> You are watching the assignee of the bug.

How exactly was this image created? Was this corruption encountered
after a crash or was the image manually crafted?

xfs_logprint shows the following last few records in the log:

============================================================================
cycle: 1        version: 2              lsn: 1,36       tail_lsn: 1,36
length of Log Record: 512       prev offset: 34         num ops: 1
uuid: e703f609-b433-4e72-a7d5-4872d7e81ae5   format: little endian linux
h_size: 32768
----------------------------------------------------------------------------
Oper (0): tid: cfbab016  len: 8  clientid: LOG  flags: UNMOUNT 
Unmount filesystem

============================================================================
cycle: 1        version: 2              lsn: 1,90       tail_lsn: 1,38
length of Log Record: 512       prev offset: 36         num ops: 1
uuid: e703f609-b433-4e72-a7d5-4872d7e81ae5   format: little endian linux
h_size: 32768
----------------------------------------------------------------------------
Oper (0): tid: 2bb1cec8  len: 8  clientid: LOG  flags: UNMOUNT 
Unmount filesystem

============================================================================
cycle: 1        version: 2              lsn: 1,40       tail_lsn: 218,40
length of Log Record: 512       prev offset: 38         num ops: 1
uuid: e703f609-b433-4e72-a7d5-4872d7e81ae5   format: little endian linux
h_size: 32768
----------------------------------------------------------------------------
Oper (0): tid: 3467bf1d  len: 8  clientid: LOG  flags: UNMOUNT 
Unmount filesystem
...

So the log appears clean and relatively sane until we get to the last
couple of unmount records. The lsn of the second to last looks bogus
given the jump from the previous and that it's beyond the last record.
The tail_lsn of the final record is clearly bogus and is what triggers
the corruption error on log recovery because we expect the head and tail
of the log to respect constraints expected of a circular log.

Also note that this isn't exactly a crash. The dmesg output is simply
more verbose error output generated by the log recovery code. All in
all, this seems like expected behavior for the associated image. The
more interesting question is how this corruption was caused.

Brian

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
