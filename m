Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 20 Oct 2007 18:28:50 -0700 (PDT)
Received: from py-out-1112.google.com (py-out-1112.google.com [64.233.166.181])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l9L1SfDi029408
	for <xfs@oss.sgi.com>; Sat, 20 Oct 2007 18:28:43 -0700
Received: by py-out-1112.google.com with SMTP id u77so1818272pyb
        for <xfs@oss.sgi.com>; Sat, 20 Oct 2007 18:28:43 -0700 (PDT)
Message-ID: <6e0c99d0710201802v2f41577dv38281b936a2389bf@mail.gmail.com>
Date: Sat, 20 Oct 2007 21:02:14 -0400
From: "Greg Martyn" <greg.martyn@gmail.com>
Subject: mount: /dev/md0: can't read superblock
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hi all,
After running "xfs_fsr -v /home", I got a bunch of error messages
saying that certain files (/home/.[three letters that i forgot])
couldn't be removed. After that, my system stopped working properly,
so I restarted. Now:

[root@localhost ~]# mount /dev/md0 /home/
mount: /dev/md0: can't read superblock

uh oh.

md0 is a raid5 that /proc/mdstat reports as working properly.

[root@localhost ~]# uname -a
Linux localhost.localdomain 2.6.22.9-91.fc7 #1 SMP Thu Sep 27 20:47:39
EDT 2007 x86_64 x86_64 x86_64 GNU/Linux
[root@localhost ~]# cat /etc/redhat-release
Fedora release 7 (Moonshine)
[root@localhost ~]# yum list xfsprogs xfsdump
Loading "changelog" plugin
Installed Packages
xfsdump.x86_64                           2.2.45-2.fc7           installed
xfsprogs.i386                            2.8.21-1.fc7           installed
xfsprogs.x86_64                          2.8.21-1.fc7           installed

Any help is appreciated.

Thanks,
greg

Here's dmesg when I try to mount:

Filesystem "md0": Disabling barriers, not supported by the underlying device
XFS mounting filesystem md0
Starting XFS recovery on filesystem: md0 (logdev: internal)
XFS internal error XFS_WANT_CORRUPTED_GOTO at line 1563 of file
fs/xfs/xfs_alloc.c.  Caller 0xffffffff88a394a3

Call Trace:
 [<ffffffff88a37943>] :xfs:xfs_free_ag_extent+0x1a6/0x6b5
 [<ffffffff88a394a3>] :xfs:xfs_free_extent+0xa9/0xc9
 [<ffffffff88a6b494>] :xfs:xlog_recover_process_efi+0xfc/0x12f
 [<ffffffff88a6c833>] :xfs:xlog_recover_process_efis+0x4f/0x81
 [<ffffffff88a6c87e>] :xfs:xlog_recover_finish+0x19/0x9a
 [<ffffffff88a712ba>] :xfs:xfs_mountfs+0x830/0x94a
 [<ffffffff810b68e2>] set_blocksize+0x8c/0x99
 [<ffffffff88a770d8>] :xfs:xfs_mount+0x317/0x39d
 [<ffffffff88a86e5e>] :xfs:xfs_fs_fill_super+0x0/0x1aa
 [<ffffffff88a86edc>] :xfs:xfs_fs_fill_super+0x7e/0x1aa
 [<ffffffff81248a41>] __down_write_nested+0x12/0x92
 [<ffffffff810a7b18>] get_filesystem+0x12/0x35
 [<ffffffff8109586b>] sget+0x37f/0x391
 [<ffffffff810952a4>] set_bdev_super+0x0/0xf
 [<ffffffff810952b3>] test_bdev_super+0x0/0xd
 [<ffffffff810962a3>] get_sb_bdev+0x11d/0x16a
 [<ffffffff81095c80>] vfs_kern_mount+0x93/0x11a
 [<ffffffff81095d56>] do_kern_mount+0x43/0xdd
 [<ffffffff810a993c>] do_mount+0x691/0x705
 [<ffffffff81115824>] radix_tree_delete+0x1b4/0x1cc
 [<ffffffff810a852f>] mntput_no_expire+0x1c/0x92
 [<ffffffff8109d87d>] link_path_walk+0xce/0xe0
 [<ffffffff810a5b77>] iput+0x42/0x7b
 [<ffffffff8109db77>] do_path_lookup+0x1a3/0x21e
 [<ffffffff8109c66e>] getname+0x14c/0x1b2
 [<ffffffff81075eda>] zone_statistics+0x3f/0x60
 [<ffffffff810708e0>] __alloc_pages+0x72/0x2d4
 [<ffffffff810a9a3a>] sys_mount+0x8a/0xcd
 [<ffffffff81009cd5>] tracesys+0xd5/0xda

XFS internal error XFS_WANT_CORRUPTED_GOTO at line 1563 of file
fs/xfs/xfs_alloc.c.  Caller 0xffffffff88a394a3

Call Trace:
 [<ffffffff88a37943>] :xfs:xfs_free_ag_extent+0x1a6/0x6b5
 [<ffffffff88a394a3>] :xfs:xfs_free_extent+0xa9/0xc9
 [<ffffffff88a747d4>] :xfs:xfs_trans_log_efd_extent+0x1c/0x4b
 [<ffffffff88a6b494>] :xfs:xlog_recover_process_efi+0xfc/0x12f
 [<ffffffff88a6c833>] :xfs:xlog_recover_process_efis+0x4f/0x81
 [<ffffffff88a6c87e>] :xfs:xlog_recover_finish+0x19/0x9a
 [<ffffffff88a712ba>] :xfs:xfs_mountfs+0x830/0x94a
 [<ffffffff810b68e2>] set_blocksize+0x8c/0x99
 [<ffffffff88a770d8>] :xfs:xfs_mount+0x317/0x39d
 [<ffffffff88a86e5e>] :xfs:xfs_fs_fill_super+0x0/0x1aa
 [<ffffffff88a86edc>] :xfs:xfs_fs_fill_super+0x7e/0x1aa
 [<ffffffff81248a41>] __down_write_nested+0x12/0x92
 [<ffffffff810a7b18>] get_filesystem+0x12/0x35
 [<ffffffff8109586b>] sget+0x37f/0x391
 [<ffffffff810952a4>] set_bdev_super+0x0/0xf
 [<ffffffff810952b3>] test_bdev_super+0x0/0xd
 [<ffffffff810962a3>] get_sb_bdev+0x11d/0x16a
 [<ffffffff81095c80>] vfs_kern_mount+0x93/0x11a
 [<ffffffff81095d56>] do_kern_mount+0x43/0xdd
 [<ffffffff810a993c>] do_mount+0x691/0x705
 [<ffffffff81115824>] radix_tree_delete+0x1b4/0x1cc
 [<ffffffff810a852f>] mntput_no_expire+0x1c/0x92
 [<ffffffff8109d87d>] link_path_walk+0xce/0xe0
 [<ffffffff810a5b77>] iput+0x42/0x7b
 [<ffffffff8109db77>] do_path_lookup+0x1a3/0x21e
 [<ffffffff8109c66e>] getname+0x14c/0x1b2
 [<ffffffff81075eda>] zone_statistics+0x3f/0x60
 [<ffffffff810708e0>] __alloc_pages+0x72/0x2d4
 [<ffffffff810a9a3a>] sys_mount+0x8a/0xcd
 [<ffffffff81009cd5>] tracesys+0xd5/0xda

XFS internal error XFS_WANT_CORRUPTED_GOTO at line 1563 of file
fs/xfs/xfs_alloc.c.  Caller 0xffffffff88a394a3

Call Trace:
 [<ffffffff88a37943>] :xfs:xfs_free_ag_extent+0x1a6/0x6b5
 [<ffffffff88a394a3>] :xfs:xfs_free_extent+0xa9/0xc9
 [<ffffffff88a42857>] :xfs:xfs_bmap_finish+0xee/0x167
 [<ffffffff88a61e40>] :xfs:xfs_itruncate_finish+0x1a0/0x2e5
 [<ffffffff88a7c8b5>] :xfs:xfs_inactive+0x241/0x43f
 [<ffffffff88a868c6>] :xfs:xfs_fs_clear_inode+0xa5/0xed
 [<ffffffff810a6445>] clear_inode+0xdd/0x134
 [<ffffffff810a6574>] generic_delete_inode+0xd8/0x136
 [<ffffffff88a6c433>] :xfs:xlog_recover_process_iunlinks+0x1d1/0x2f2
 [<ffffffff88a6c89e>] :xfs:xlog_recover_finish+0x39/0x9a
 [<ffffffff88a712ba>] :xfs:xfs_mountfs+0x830/0x94a
 [<ffffffff810b68e2>] set_blocksize+0x8c/0x99
 [<ffffffff88a770d8>] :xfs:xfs_mount+0x317/0x39d
 [<ffffffff88a86e5e>] :xfs:xfs_fs_fill_super+0x0/0x1aa
 [<ffffffff88a86edc>] :xfs:xfs_fs_fill_super+0x7e/0x1aa
 [<ffffffff81248a41>] __down_write_nested+0x12/0x92
 [<ffffffff810a7b18>] get_filesystem+0x12/0x35
 [<ffffffff8109586b>] sget+0x37f/0x391
 [<ffffffff810952a4>] set_bdev_super+0x0/0xf
 [<ffffffff810952b3>] test_bdev_super+0x0/0xd
 [<ffffffff810962a3>] get_sb_bdev+0x11d/0x16a
 [<ffffffff81095c80>] vfs_kern_mount+0x93/0x11a
 [<ffffffff81095d56>] do_kern_mount+0x43/0xdd
 [<ffffffff810a993c>] do_mount+0x691/0x705
 [<ffffffff81115824>] radix_tree_delete+0x1b4/0x1cc
 [<ffffffff810a852f>] mntput_no_expire+0x1c/0x92
 [<ffffffff8109d87d>] link_path_walk+0xce/0xe0
 [<ffffffff810a5b77>] iput+0x42/0x7b
 [<ffffffff8109db77>] do_path_lookup+0x1a3/0x21e
 [<ffffffff8109c66e>] getname+0x14c/0x1b2
 [<ffffffff81075eda>] zone_statistics+0x3f/0x60
 [<ffffffff810708e0>] __alloc_pages+0x72/0x2d4
 [<ffffffff810a9a3a>] sys_mount+0x8a/0xcd
 [<ffffffff81009cd5>] tracesys+0xd5/0xda

xfs_force_shutdown(md0,0x8) called from line 4258 of file
fs/xfs/xfs_bmap.c.  Return address = 0xffffffff88a42894
Filesystem "md0": Corruption of in-memory data detected.  Shutting
down filesystem: md0
Please umount the filesystem, and rectify the problem(s)
Ending XFS recovery on filesystem: md0 (logdev: internal)
SELinux: (dev md0, type xfs) getxattr errno 5
xfs_force_shutdown(md0,0x1) called from line 423 of file
fs/xfs/xfs_rw.c.  Return address = 0xffffffff88a7d715
xfs_force_shutdown(md0,0x1) called from line 423 of file
fs/xfs/xfs_rw.c.  Return address = 0xffffffff88a7d715
