Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:45414 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729008AbeH3SfB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Aug 2018 14:35:01 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 93C1D2BFC0
        for <linux-xfs@vger.kernel.org>; Thu, 30 Aug 2018 14:32:34 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 200981] New: hypervisor fs hangs at heavy write activity on VM
 (kvm, qcow2 image) having a reflink disk copy
Date: Thu, 30 Aug 2018 14:32:35 +0000
Message-ID: <bug-200981-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=200981

            Bug ID: 200981
           Summary: hypervisor fs hangs at heavy write activity on VM
                    (kvm, qcow2 image) having a reflink disk copy
           Product: File System
           Version: 2.5
    Kernel Version: 4.18.5
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: XFS
          Assignee: filesystem_xfs@kernel-bugs.kernel.org
          Reporter: git.user@gmail.com
        Regression: No

Created attachment 278203
  --> https://bugzilla.kernel.org/attachment.cgi?id=278203&action=edit
dmesg

kernel: vanilla 4.18.5
gcc (Ubuntu 7.3.0-16ubuntu3) 7.3.0
Copyright (C) 2017 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

More or less reproducible for me using next sequence:

- on host:
  create LV of appropriate size (20g in my case)
  mkfs.xfs -m reflink=1 /dev/data/LV
  mount /dev/data/LV /mnt/
  run kvm VM with qcow2 image (/mnt/disk)    

- inside vm:
  sysbench --test=fileio --file-total-size=9G prepare

- on host:
  cp --reflink=always disk disk.b

- inside vm: 
  sysbench --test=fileio --file-total-size=9G --file-test-mode=seqwr
--max-time=6000 --max-requests=0 --threads=16 run

Some time after i/o on /dev/data/LV fall to zero and fs become completely
unavailable and then I see a bunch of records:

[ 2580.058205] INFO: task worker:6343 blocked for more than 120 seconds.
[ 2580.064719]       Not tainted 4.18.5 #1
[ 2580.068614] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
message.
[ 2580.076496] worker          D    0  6343      1 0x00000000
[ 2580.082034] Call Trace:
[ 2580.084532]  ? __schedule+0x386/0xc50
[ 2580.088248]  ? xlog_grant_head_wait+0xa3/0x3a0
[ 2580.092741]  schedule+0x2f/0x90
[ 2580.095932]  xlog_grant_head_wait+0x53/0x3a0
[ 2580.100256]  xlog_grant_head_check+0xb3/0x160
[ 2580.104662]  xfs_log_reserve+0x108/0x3f0
[ 2580.108682]  xfs_trans_reserve+0x1b4/0x2b0
[ 2580.112948]  xfs_trans_alloc+0xbe/0x220
[ 2580.116952]  xfs_vn_update_time+0xcb/0x2b0
[ 2580.121220]  ? current_time+0x4d/0x90
[ 2580.125047]  file_update_time+0xe0/0x120
[ 2580.129139]  xfs_file_aio_write_checks+0x14f/0x2d0
[ 2580.134099]  xfs_file_dio_aio_write+0xcc/0x420
[ 2580.138715]  xfs_file_write_iter+0x7b/0xa0
[ 2580.142978]  do_iter_readv_writev+0x139/0x190
[ 2580.147502]  do_iter_write+0x7f/0x1c0
[ 2580.151329]  vfs_writev+0x98/0x110
[ 2580.154907]  ? lock_acquire+0x8e/0x230
[ 2580.158823]  ? __fget+0x5/0x200
[ 2580.162131]  ? do_pwritev+0x9c/0xe0
[ 2580.165782]  ? __fget_light+0x51/0x60
[ 2580.169614]  do_pwritev+0x9c/0xe0
[ 2580.173095]  do_syscall_64+0x5a/0x190
[ 2580.176922]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[ 2580.182138] RIP: 0033:0x7fe1937b784a
[ 2580.185836] Code: Bad RIP value.
[ 2580.189239] RSP: 002b:00007fe05e1f5850 EFLAGS: 00000246 ORIG_RAX:
0000000000000128
[ 2580.197058] RAX: ffffffffffffffda RBX: 0000000000000014 RCX:
00007fe1937b784a
[ 2580.204361] RDX: 000000000000001e RSI: 0000564bf126f200 RDI:
0000000000000014
[ 2580.211660] RBP: 0000564bf126f200 R08: 0000000000000000 R09:
0000000000000000
[ 2580.218968] R10: 00000000dccf0000 R11: 0000000000000246 R12:
000000000000001e
[ 2580.226265] R13: 00000000dccf0000 R14: 0000564bf13312a0 R15:
00007fe05e9f67a0

Full dmesg attached

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
