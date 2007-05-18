Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 17 May 2007 23:08:42 -0700 (PDT)
Received: from amanpulo.fs3.ph (amanpulo.fs3.ph [72.51.42.241])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l4I68bfB030111
	for <xfs@oss.sgi.com>; Thu, 17 May 2007 23:08:39 -0700
Received: from localhost (localhost [127.0.0.1])
	by amanpulo.fs3.ph (Postfix) with ESMTP id 4F6661E0D5966
	for <xfs@oss.sgi.com>; Fri, 18 May 2007 14:08:36 +0800 (PHT)
Received: from amanpulo.fs3.ph ([127.0.0.1])
	by localhost (amanpulo.fs3.ph [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id zxsd0wF2tgBC for <xfs@oss.sgi.com>;
	Fri, 18 May 2007 14:08:30 +0800 (PHT)
Received: from musang.fs3.ph (unknown [222.127.47.132])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by amanpulo.fs3.ph (Postfix) with ESMTP id 719C51E0D5953
	for <xfs@oss.sgi.com>; Fri, 18 May 2007 14:08:28 +0800 (PHT)
Date: Fri, 18 May 2007 14:08:25 +0800
From: Federico Sevilla III <jijo@fs3.ph>
Subject: Mount Failure: Totally Zeroed Log
Message-ID: <20070518060825.GD3340@fs3.ph>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: XFS Mailing List <xfs@oss.sgi.com>

Hi,

I encountered the following error after an unclean shutdown:

    Filesystem "md1": Disabling barriers, not supported by the underlying device
    XFS mounting filesystem md1
    XFS: totally zeroed log
    Starting XFS recovery on filesystem: md1 (logdev: internal)
    Filesystem "md1": XFS internal error xlog_valid_rec_header(1) at line 3503 of file fs/xfs/xfs_log_recover.c.  Caller 0xf8992fbd
     [<f8992a5d>] xlog_valid_rec_header+0xc5/0xd5 [xfs]
     [<f8992fbd>] xlog_do_recovery_pass+0x550/0x90f [xfs]
     [<f8992fbd>] xlog_do_recovery_pass+0x550/0x90f [xfs]
     [<f89933c1>] xlog_do_log_recovery+0x45/0xa6 [xfs]
     [<f899343f>] xlog_do_recover+0x1d/0x102 [xfs]
     [<f89935ab>] xlog_recover+0x87/0x98 [xfs]
     [<f898c4bd>] xfs_log_mount+0x8d/0xce [xfs]
     [<f8994c17>] xfs_mountfs+0x982/0xc63 [xfs]
     [<f89888ee>] xfs_ioinit+0x21/0x26 [xfs]
     [<f899b3c6>] xfs_mount+0x30b/0x37e [xfs]
     [<f89abf24>] vfs_mount+0x28/0x2c [xfs]
     [<f89abdb5>] xfs_fs_fill_super+0x6e/0x193 [xfs]
     [<c019dbd2>] snprintf+0x16/0x1a
     [<c017a1cd>] disk_name+0x25/0x66
     [<c0151c10>] get_sb_bdev+0xca/0x117
     [<c0158146>] __link_path_walk+0xadd/0xbd2
     [<f89abef8>] xfs_fs_get_sb+0x1e/0x22 [xfs]
     [<f89abd47>] xfs_fs_fill_super+0x0/0x193 [xfs]
     [<c0151de6>] vfs_kern_mount+0x35/0x66
     [<c0151e40>] do_kern_mount+0x29/0x39
     [<c0163ffd>] do_new_mount+0x67/0xa4
     [<c01645f9>] do_mount+0x153/0x16b
     [<c0164459>] copy_mount_options+0x4c/0x99
     [<c016489d>] sys_mount+0x79/0xba
     [<c010278b>] syscall_call+0x7/0xb
    XFS: log mount/recovery failed: error 117
    XFS: log mount failed

The machine runs Debian GNU/Linux 4.0 (Etch), with a custom-built 2.6.18
kernel using the Debian 2.6.18 source and the OpenVZ patch. xfs_repair
is able to repair the filesystem, but most of the files just end up in
lost+found. I have verified that write cache on both drives has been
disabled, and hdparm is set to disable them everytime during startup.

Any clues as to what could be causing this?

Thank you very much.

Cheers!

-- 
Federico Sevilla III
F S 3 Consulting Inc.
http://www.fs3.ph
