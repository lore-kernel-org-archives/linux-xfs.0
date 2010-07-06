Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o66AtGeC177977 for <xfs@oss.sgi.com>; Tue, 6 Jul 2010 05:55:17 -0500
Received: from mail-vw0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DB0741B24F02
	for <xfs@oss.sgi.com>; Tue,  6 Jul 2010 03:58:06 -0700 (PDT)
Received: from mail-vw0-f53.google.com (mail-vw0-f53.google.com
	[209.85.212.53]) by cuda.sgi.com with ESMTP id sxW6m2WBi5w0QuVM
	for <xfs@oss.sgi.com>; Tue, 06 Jul 2010 03:58:06 -0700 (PDT)
Received: by vws15 with SMTP id 15so6876364vws.26
	for <xfs@oss.sgi.com>; Tue, 06 Jul 2010 03:58:05 -0700 (PDT)
MIME-Version: 1.0
From: Shaun Adolphson <shaun@adolphson.net>
Date: Tue, 6 Jul 2010 20:57:45 +1000
Message-ID: <AANLkTimKKEvfJx6EQZeQF_HnlBLj6B8Kjfy6jUHGPnz5@mail.gmail.com>
Subject: CentOS 5.5 XFS internal errors (XFS_WANT_CORRUPTED_GOTO)
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hi,

We have been able to repeatably produce xfs internal errors
(XFS_WANT_CORRUPTED_GOTO) on one of our fileservers. We are attempting
to locally copy a 248Gig file off a usb drive formated as NTFS to the
xfs drive. The copy gets about 96% of the way through and we get the
following messages:

Jun 28 22:14:46 terrorserver kernel: XFS internal error
XFS_WANT_CORRUPTED_GOTO at line 2092 of file fs/xfs/xfs_bmap_btree.c.
Caller 0xffffffff8837446f
Jun 28 22:14:46 terrorserver kernel:
Jun 28 22:14:46 terrorserver kernel: Call Trace:
Jun 28 22:14:46 terrorserver kernel:  [<ffffffff8837c360>]
:xfs:xfs_bmbt_insert+0xac/0x13a
Jun 28 22:14:46 terrorserver kernel:  [<ffffffff8837446f>]
:xfs:xfs_bmap_add_extent_delay_real+0x8cd/0x103a
Jun 28 22:14:46 terrorserver kernel:  [<ffffffff88368cfa>]
:xfs:xfs_alloc_vextent+0x379/0x3ff
Jun 28 22:14:46 terrorserver kernel:  [<ffffffff8837543a>]
:xfs:xfs_bmap_add_extent+0x1fb/0x390
Jun 28 22:14:46 terrorserver kernel:  [<ffffffff88377f34>]
:xfs:xfs_bmapi+0x895/0xe79
Jun 28 22:14:46 terrorserver kernel:  [<ffffffff88398ff2>]
:xfs:xfs_log_reserve+0xad/0xc9
Jun 28 22:14:46 terrorserver kernel:  [<ffffffff88394082>]
:xfs:xfs_iomap_write_allocate+0x201/0x328
Jun 28 22:14:46 terrorserver kernel:  [<ffffffff88394b09>]
:xfs:xfs_iomap+0x22a/0x2a5
Jun 28 22:14:46 terrorserver kernel:  [<ffffffff883a9ae3>]
:xfs:xfs_map_blocks+0x2d/0x65
Jun 28 22:14:46 terrorserver kernel:  [<ffffffff883aa723>]
:xfs:xfs_page_state_convert+0x2af/0x544
Jun 28 22:14:46 terrorserver kernel:  [<ffffffff883aab04>]
:xfs:xfs_vm_writepage+0xa7/0xdf
Jun 28 22:14:46 terrorserver kernel:  [<ffffffff800cae35>]
shrink_inactive_list+0x3fd/0x8d8
Jun 28 22:14:46 terrorserver kernel:  [<ffffffff8001311b>]
shrink_zone+0x127/0x18d
Jun 28 22:14:46 terrorserver kernel:  [<ffffffff80057e60>] kswapd+0x323/0x46c
Jun 28 22:14:46 terrorserver kernel:  [<ffffffff800a0abe>]
autoremove_wake_function+0x0/0x2e
Jun 28 22:14:46 terrorserver kernel:  [<ffffffff800a08a6>]
keventd_create_kthread+0x0/0xc4
Jun 28 22:14:46 terrorserver kernel:  [<ffffffff80057b3d>] kswapd+0x0/0x46c
Jun 28 22:14:46 terrorserver kernel:  [<ffffffff800a08a6>]
keventd_create_kthread+0x0/0xc4
Jun 28 22:14:46 terrorserver kernel:  [<ffffffff80032894>] kthread+0xfe/0x132
Jun 28 22:14:46 terrorserver kernel:  [<ffffffff8009d734>]
request_module+0x0/0x14d
Jun 28 22:14:46 terrorserver kernel:  [<ffffffff8005dfb1>] child_rip+0xa/0x11
Jun 28 22:14:46 terrorserver kernel:  [<ffffffff800a08a6>]
keventd_create_kthread+0x0/0xc4
Jun 28 22:14:46 terrorserver kernel:  [<ffffffff80032796>] kthread+0x0/0x132
Jun 28 22:14:46 terrorserver kernel:  [<ffffffff8005dfa7>] child_rip+0x0/0x11
Jun 28 22:14:46 terrorserver kernel:
Jun 28 22:14:46 terrorserver kernel: Filesystem "dm-0": XFS internal
error xfs_trans_cancel at line 1164 of file fs/xfs/xfs_trans.c.
Caller 0xffffffff88394186
Jun 28 22:14:46 terrorserver kernel:
Jun 28 22:14:46 terrorserver kernel: Call Trace:
Jun 28 22:14:46 terrorserver kernel:  [<ffffffff883a1b37>]
:xfs:xfs_trans_cancel+0x55/0xfa
Jun 28 22:14:46 terrorserver kernel:  [<ffffffff88394186>]
:xfs:xfs_iomap_write_allocate+0x305/0x328
Jun 28 22:14:46 terrorserver kernel:  [<ffffffff88394b09>]
:xfs:xfs_iomap+0x22a/0x2a5
Jun 28 22:14:46 terrorserver kernel:  [<ffffffff883a9ae3>]
:xfs:xfs_map_blocks+0x2d/0x65
Jun 28 22:14:46 terrorserver kernel:  [<ffffffff883aa723>]
:xfs:xfs_page_state_convert+0x2af/0x544
Jun 28 22:14:46 terrorserver kernel:  [<ffffffff883aab04>]
:xfs:xfs_vm_writepage+0xa7/0xdf
Jun 28 22:14:46 terrorserver kernel:  [<ffffffff800cae35>]
shrink_inactive_list+0x3fd/0x8d8
Jun 28 22:14:46 terrorserver kernel:  [<ffffffff8001311b>]
shrink_zone+0x127/0x18d
Jun 28 22:14:46 terrorserver kernel:  [<ffffffff80057e60>] kswapd+0x323/0x46c
Jun 28 22:14:46 terrorserver kernel:  [<ffffffff800a0abe>]
autoremove_wake_function+0x0/0x2e
Jun 28 22:14:46 terrorserver kernel:  [<ffffffff800a08a6>]
keventd_create_kthread+0x0/0xc4
Jun 28 22:14:46 terrorserver kernel:  [<ffffffff80057b3d>] kswapd+0x0/0x46c
Jun 28 22:14:46 terrorserver kernel:  [<ffffffff800a08a6>]
keventd_create_kthread+0x0/0xc4
Jun 28 22:14:46 terrorserver kernel:  [<ffffffff80032894>] kthread+0xfe/0x132
Jun 28 22:14:46 terrorserver kernel:  [<ffffffff8009d734>]
request_module+0x0/0x14d
Jun 28 22:14:46 terrorserver kernel:  [<ffffffff8005dfb1>] child_rip+0xa/0x11
Jun 28 22:14:46 terrorserver kernel:  [<ffffffff800a08a6>]
keventd_create_kthread+0x0/0xc4
Jun 28 22:14:46 terrorserver kernel:  [<ffffffff80032796>] kthread+0x0/0x132
Jun 28 22:14:46 terrorserver kernel:  [<ffffffff8005dfa7>] child_rip+0x0/0x11
Jun 28 22:14:46 terrorserver kernel:
Jun 28 22:14:46 terrorserver kernel: xfs_force_shutdown(dm-0,0x8)
called from line 1165 of file fs/xfs/xfs_trans.c.  Return address =
0xffffffff883a1b50
Jun 28 22:14:46 terrorserver kernel: Filesystem "dm-0": Corruption of
in-memory data detected.  Shutting down filesystem: dm-0
Jun 28 22:14:46 terrorserver kernel: Please umount the filesystem, and
rectify the problem(s)
Jun 28 22:14:47 terrorserver kernel: Filesystem "dm-0": xfs_log_force:
error 5 returned.

We have reproduced the condition 3 times and each time we have been
able to remount the drive ( to replay the transaction log ) and then
preform and xfs_repair.

We are just using cp to copy the file.

Some further details about the system:

Software:
- Fresh install of CentOS 5.5 64bit all patches up to date
- Kernel 2.6.18-194.3.1.el5.centos.plus

RAID Hardware:
- 3ware 9650SE 12 port sata controler
- 6 x 1.5tb disk in a raid 5 (sde)
- 6 x 2.0tb disks in a raid 5 (sdf)

Configuration
- LVM across sde and sdf
- Formatted as XFS ( ~16 TB )

Any guidance to resolving this issue would be much appreciated. I am
able to provide any other information that is required.

Thanks for any assistance you can provide.
Regards,
Shaun

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
