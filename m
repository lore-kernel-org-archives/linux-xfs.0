Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 22 Jul 2008 22:54:13 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6N5sBjA027112
	for <xfs@oss.sgi.com>; Tue, 22 Jul 2008 22:54:11 -0700
Received: from ti-out-0910.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6B159E89698
	for <xfs@oss.sgi.com>; Tue, 22 Jul 2008 22:55:20 -0700 (PDT)
Received: from ti-out-0910.google.com (ti-out-0910.google.com [209.85.142.189]) by cuda.sgi.com with ESMTP id 1nqdPewWDXusNz9N for <xfs@oss.sgi.com>; Tue, 22 Jul 2008 22:55:20 -0700 (PDT)
Received: by ti-out-0910.google.com with SMTP id y6so1229602tia.18
        for <xfs@oss.sgi.com>; Tue, 22 Jul 2008 22:55:19 -0700 (PDT)
Message-ID: <c49434130807222255o297d3b1cy7365ae8297b48cd8@mail.gmail.com>
Date: Wed, 23 Jul 2008 11:25:19 +0530
From: "Tharindu Rukshan Bamunuarachchi" <tharindunix@gmail.com>
Subject: Is it a bug ??
MIME-Version: 1.0
Content-Type: text/plain
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Dear XFS Gurus,

I am using "Linux tintin 2.6.25-gentoo-r6 #2 SMP PREEMPT Sun Jul 13 10:50:58
IST 2008 x86_64 Intel(R) Core(TM)2 CPU T7200 @ 2.00GHz GenuineIntel
GNU/Linux

While working I got I/O error and file system has been shutdown.

I had to run xfs_repair and now file system is working fine.

This happened several time until i repair the file system.

Is this a bug or due to hardware failure .....??

I do not know given info is enough to isolate anything, but i am happy to
provide more info if you need.

Cheers
Tharindu


[   37.074883] br0: port 2(qtap1) entering forwarding state
[   57.179699] Filesystem "sda3": XFS internal error xfs_trans_cancel at
line 1163 of file fs/xfs/xfs_trans.c.  Caller 0xffffffff80352b66
[   57.179699] Pid: 3757, comm: gconfd-2 Tainted: P         2.6.25-tintin #2
[   57.179699]
[   57.179699] Call Trace:
[   57.179699]  [<ffffffff80331fd1>] xfs_error_report+0x3c/0x3e
[   57.179699]  [<ffffffff80352b66>] ? xfs_create+0x3f3/0x477
[   57.179699]  [<ffffffff8034cacc>] xfs_trans_cancel+0x65/0x102
[   57.179699]  [<ffffffff80352b66>] xfs_create+0x3f3/0x477
[   57.179699]  [<ffffffff8035c80c>] xfs_vn_mknod+0x165/0x266
[   57.179699]  [<ffffffff8035c928>] xfs_vn_create+0xb/0xd
[   57.179699]  [<ffffffff802a0923>] vfs_create+0x8d/0x102
[   57.179699]  [<ffffffff802a3584>] open_namei+0x1ae/0x6a0
[   57.179699]  [<ffffffff802a0032>] ? __lookup_hash+0x55/0x11e
[   57.179699]  [<ffffffff802971f5>] do_filp_open+0x28/0x4b
[   57.179699]  [<ffffffff80296f79>] ? get_unused_fd_flags+0x113/0x121
[   57.179699]  [<ffffffff80297269>] do_sys_open+0x51/0xd2
[   57.179699]  [<ffffffff80297313>] sys_open+0x1b/0x1d
[   57.179699]  [<ffffffff8020be8b>] system_call_after_swapgs+0x7b/0x80
[   57.179699]
[   57.179699] xfs_force_shutdown(sda3,0x8) called from line 1164 of file
fs/xfs/xfs_trans.c.  Return address = 0xffffffff8034cae5
[   57.192307] Filesystem "sda3": Corruption of in-memory data detected.
Shutting down filesystem: sda3
[   57.192307] Please umount the filesystem, and rectify the problem(s)
[  134.906667] xfs_force_shutdown(sda3,0x1) called from line 420 of file
fs/xfs/xfs_rw.c.  Return address = 0xffffffff80355722
[  155.042525] XFS mounting filesystem sda3
[  155.050723] Starting XFS recovery on filesystem: sda3 (logdev: internal)
[  155.365958] Ending XFS recovery on filesystem: sda3 (logdev: internal)
[  261.328960] XFS mounting filesystem sda3
[  261.413972] Ending clean XFS mount for filesystem: sda3


-- 
Tharindu Rukshan Bamunuarachchi
In the end, It is the life in my years.


[[HTML alternate version deleted]]
