Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 09 Apr 2008 08:19:44 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m39FJb10004332
	for <xfs@oss.sgi.com>; Wed, 9 Apr 2008 08:19:38 -0700
Received: from an-out-0708.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A998776B93C
	for <xfs@oss.sgi.com>; Wed,  9 Apr 2008 08:20:15 -0700 (PDT)
Received: from an-out-0708.google.com (an-out-0708.google.com [209.85.132.245]) by cuda.sgi.com with ESMTP id RFA8LpO6GqJRtMqy for <xfs@oss.sgi.com>; Wed, 09 Apr 2008 08:20:15 -0700 (PDT)
Received: by an-out-0708.google.com with SMTP id c38so634933ana.75
        for <xfs@oss.sgi.com>; Wed, 09 Apr 2008 08:20:14 -0700 (PDT)
Message-ID: <18b102300804090813u24423515k4c478635494534dc@mail.gmail.com>
Date: Wed, 9 Apr 2008 11:13:07 -0400
From: "James Klaas" <jklaas@appalachian.dyndns.org>
Subject: Is my partition repairable?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

I've been struggling to recover/repair an XFS partition that is on a
Linux software raid.  This is on Ubuntu Feisty (7.04) with xfsprogs
v2.8.18.

When I try to mount the system, it attempts a recovery:

[127094.470809] Filesystem "md0": Disabling barriers, not supported by
the underlying device
[127094.471954] XFS mounting filesystem md0
[127094.613551] Starting XFS recovery on filesystem: md0 (logdev: internal)
[127094.858897] Filesystem "md0": XFS internal error
xfs_btree_check_sblock at line 334 of file fs/xfs/xfs_btree.c.  Caller
0xf8eda9fb
[127094.858957] Pid: 8986, comm: mount Not tainted 2.6.24.3-test #1
[127094.859013]  [<f8ec7d9b>] xfs_btree_check_sblock+0x5b/0xd0 [xfs]
[127094.859146]  [<f8eda9fb>] xfs_inobt_lookup+0x1cb/0x450 [xfs]
[127094.859209]  [<f8eda9fb>] xfs_inobt_lookup+0x1cb/0x450 [xfs]
[127094.859277]  [<f8f024a8>] kmem_zone_zalloc+0x28/0x60 [xfs]
[127094.859347]  [<f8ed9fe5>] xfs_difree+0x265/0x630 [xfs]
[127094.859422]  [<f8eea5a0>] xfs_log_reserve+0xc0/0xe0 [xfs]
[127094.859482]  [<f8ee1c20>] xfs_ifree+0x60/0xf0 [xfs]
[127094.859539]  [<f8ef7bbb>] xfs_trans_ijoin+0x2b/0x70 [xfs]
[127094.859598]  [<f8f00a6f>] xfs_inactive+0x23f/0x4d0 [xfs]
[127094.859660]  [<f8edfa9d>] xfs_itobp+0x1fd/0x220 [xfs]
[127094.859718]  [<f8f0b40a>] xfs_fs_clear_inode+0x3a/0x80 [xfs]
[127094.859783]  [<c0177f60>] clear_inode+0x90/0x140
[127094.859814]  [<c014fe67>] truncate_inode_pages+0x17/0x20
[127094.859845]  [<c017812a>] generic_delete_inode+0xda/0xf0
[127094.859875]  [<c017790c>] iput+0x5c/0x70
[127094.859902]  [<f8eecbc2>] xlog_recover_process_iunlinks+0x462/0x490 [xfs]
[127094.859981]  [<f8eecca7>] xlog_recover_finish+0xb7/0xc0 [xfs]
[127094.860041]  [<f8ef3053>] xfs_mountfs+0xbd3/0xdb0 [xfs]
[127094.860120]  [<f8f026c5>] kmem_zalloc+0x15/0x50 [xfs]
[127094.860182]  [<f8efafe3>] xfs_mount+0x3d3/0x400 [xfs]
[127094.860244]  [<f8f0bf02>] xfs_fs_fill_super+0xa2/0x200 [xfs]
[127094.860313]  [<c01e01af>] snprintf+0x1f/0x30
[127094.860343]  [<c019fe3c>] disk_name+0x3c/0xc0
[127094.860375]  [<c01ded60>] strlcpy+0x20/0x80
[127094.860404]  [<c0167ab9>] get_sb_bdev+0xf9/0x120
[127094.860446]  [<f8f0b380>] xfs_fs_get_sb+0x20/0x30 [xfs]
[127094.860502]  [<f8f0be60>] xfs_fs_fill_super+0x0/0x200 [xfs]
[127094.860560]  [<c0167672>] vfs_kern_mount+0xa2/0x120
[127094.860595]  [<c016774d>] do_kern_mount+0x3d/0xe0
[127094.860627]  [<c017b603>] do_mount+0x5f3/0x6a0
[127094.860667]  [<c0155390>] handle_mm_fault+0x630/0x680
[127094.860712]  [<c01778e5>] iput+0x35/0x70
[127094.860745]  [<c016f7a9>] __user_walk_fd+0x49/0x60
[127094.860788]  [<c014ccb6>] __alloc_pages+0x56/0x360
[127094.860823]  [<c02e3412>] error_code+0x6a/0x70
[127094.860865]  [<c014d00e>] __get_free_pages+0x4e/0x60
[127094.860893]  [<c0179f30>] copy_mount_options+0x40/0x150
[127094.860927]  [<c017ba62>] sys_mount+0x72/0xb0
[127094.860959]  [<c0103f7e>] sysenter_past_esp+0x5f/0x85
[127094.861002]  =======================
[127094.861025] xfs_difree: xfs_inobt_lookup_le returned()  an error
117 on md0.  Returning error.
[127094.861071] xfs_inactive:   xfs_ifree() returned an error = 117 on md0
[127094.861099] xfs_force_shutdown(md0,0x1) called from line 1769 of
file fs/xfs/xfs_vnodeops.c.  Return address = 0xf8f00cf0
[127094.861151] Filesystem "md0": I/O Error Detected.  Shutting down
filesystem: md0
[127094.861192] Please umount the filesystem, and rectify the problem(s)
[127095.012602] Ending XFS recovery on filesystem: md0 (logdev: internal)

I don't know why there is an I/O error on md0 as I am able to copy the
system using dd with no I/O errors to another disk.  I get the same
erorrs when I try to mount the xfs filesystem from the copied disk.

If I run xfs_repair:

# xfs_repair /dev/md0
        - creating 2 worker thread(s)
Phase 1 - find and verify superblock...
        - reporting progress in intervals of 15 minutes
Phase 2 - using internal log
        - zero log...
ERROR: The filesystem has valuable metadata changes in a log which needs to
be replayed.  Mount the filesystem to replay the log, and unmount it before
re-running xfs_repair.  If you are unable to mount the filesystem, then use
the -L option to destroy the log and attempt a repair.
Note that destroying the log may cause corruption -- please attempt a mount
of the filesystem before doing this.

I get a long list of things though when I run "xfs_repair -n
/dev/md0".  Can I use any of the information in the output from
"xfs_repair -n" to fix it?

James
