Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9Q9Iaf0059638 for <xfs@oss.sgi.com>; Tue, 26 Oct 2010 04:18:36 -0500
Received: from mail-wy0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BFB501E852FD
	for <xfs@oss.sgi.com>; Tue, 26 Oct 2010 02:19:52 -0700 (PDT)
Received: from mail-wy0-f181.google.com (mail-wy0-f181.google.com
	[74.125.82.181]) by cuda.sgi.com with ESMTP id PY6pmdrrDSDW7kRF
	for <xfs@oss.sgi.com>; Tue, 26 Oct 2010 02:19:52 -0700 (PDT)
Received: by wyb40 with SMTP id 40so3922929wyb.26
	for <xfs@oss.sgi.com>; Tue, 26 Oct 2010 02:19:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTi=Zq3mh=0Q-g6oi-OqYFRsENiTjLcHfvPNsOkGa@mail.gmail.com>
References: <AANLkTi=Zq3mh=0Q-g6oi-OqYFRsENiTjLcHfvPNsOkGa@mail.gmail.com>
Date: Tue, 26 Oct 2010 09:19:52 +0000
Message-ID: <AANLkTi=Gnt+L6Cg0iNha=qn6Kd__pFK7Xhbup0NWtSUt@mail.gmail.com>
Subject: Re: Possible deadlock when deleting from realtime section
From: Denny Priebe <denny.priebe@googlemail.com>
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

After that, recovery hangs as well:

SGI XFS with ACLs, security attributes, realtime, large block/inode
numbers, debug enabled
SGI XFS Quota Management subsystem
Filesystem "sdb2": Disabling barriers, not supported with external log device
XFS mounting filesystem sdb2
Starting XFS recovery on filesystem: sdb2 (logdev: /dev/sdb1)
SysRq : Show Blocked State
  task                        PC stack   pid father
mount         D 0000000000000000     0  1481   1464 0x00000080
 ffff880186c17558 0000000000000086 ffff880100000000 ffff880186c16010
 ffff880186c17fd8 00000000000148c0 ffff880187364530 ffff8801873648e8
 ffff8801873648e0 00000000000148c0 00000000000148c0 ffff880186c17fd8
Call Trace:
 [<ffffffff81437739>] rwsem_down_failed_common+0xd3/0x105
 [<ffffffff8143777e>] rwsem_down_write_failed+0x13/0x15
 [<ffffffff81202ad3>] call_rwsem_down_write_failed+0x13/0x20
 [<ffffffff81436e3d>] ? down_write+0x40/0x44
 [<ffffffffa032b7d0>] xfs_ilock+0xb7/0x114 [xfs]
 [<ffffffffa032bead>] xfs_iget+0x34c/0x61b [xfs]
 [<ffffffffa03479b7>] xfs_trans_iget+0x1b/0x54 [xfs]
 [<ffffffffa02f588e>] xfs_rtfree_extent+0x37/0x117 [xfs]
 [<ffffffffa03311f2>] ? xfs_iext_remove+0xdd/0xef [xfs]
 [<ffffffffa030b52f>] ? xfs_bmap_del_extent+0x40c/0xab5 [xfs]
 [<ffffffffa030b3ad>] xfs_bmap_del_extent+0x28a/0xab5 [xfs]
 [<ffffffffa030dce8>] xfs_bunmapi+0xa0c/0xdd2 [xfs]
 [<ffffffff810f17ef>] ? new_slab+0x199/0x1c0
 [<ffffffffa032e26a>] xfs_itruncate_finish+0x32e/0x4f1 [xfs]
 [<ffffffffa034a5d1>] xfs_inactive+0x224/0x47a [xfs]
 [<ffffffffa035615d>] xfs_fs_evict_inode+0x101/0x109 [xfs]
 [<ffffffff8111282b>] evict+0x22/0x92
 [<ffffffff81112c60>] iput+0x1bc/0x225
 [<ffffffffa033b84a>] xlog_recover_process_one_iunlink+0x118/0x17e [xfs]
 [<ffffffffa033b930>] xlog_recover_process_iunlinks+0x80/0xf7 [xfs]
 [<ffffffffa033bc5b>] xlog_recover_finish+0x54/0xbc [xfs]
 [<ffffffffa0339e46>] xfs_log_mount_finish+0x1c/0x44 [xfs]
 [<ffffffffa0342832>] xfs_mountfs+0x559/0x683 [xfs]
 [<ffffffffa034c569>] ? kmem_zalloc+0x11/0x2c [xfs]
 [<ffffffffa0342bfb>] ? xfs_mru_cache_create+0x117/0x146 [xfs]
 [<ffffffffa0357a03>] xfs_fs_fill_super+0x1d9/0x316 [xfs]
 [<ffffffff81102c48>] get_sb_bdev+0x14b/0x1ae
 [<ffffffffa035782a>] ? xfs_fs_fill_super+0x0/0x316 [xfs]
 [<ffffffffa0355c54>] xfs_fs_get_sb+0x13/0x15 [xfs]
 [<ffffffff8110229f>] vfs_kern_mount+0xb8/0x1a2
 [<ffffffff811023e7>] do_kern_mount+0x48/0xe8
 [<ffffffff811175ef>] do_mount+0x74f/0x7c6
 [<ffffffff811176e9>] sys_mount+0x83/0xbd
 [<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b

Regards,
Denny

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
