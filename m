Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9PFwAUN244600 for <xfs@oss.sgi.com>; Mon, 25 Oct 2010 10:58:10 -0500
Received: from mail-ey0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4C2081969F09
	for <xfs@oss.sgi.com>; Mon, 25 Oct 2010 08:59:23 -0700 (PDT)
Received: from mail-ey0-f181.google.com (mail-ey0-f181.google.com
	[209.85.215.181]) by cuda.sgi.com with ESMTP id
	KJPS7tjkFEJJyIEJ for <xfs@oss.sgi.com>;
	Mon, 25 Oct 2010 08:59:23 -0700 (PDT)
Received: by eyg5 with SMTP id 5so1723993eyg.26
	for <xfs@oss.sgi.com>; Mon, 25 Oct 2010 08:59:22 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 25 Oct 2010 15:59:22 +0000
Message-ID: <AANLkTi=Zq3mh=0Q-g6oi-OqYFRsENiTjLcHfvPNsOkGa@mail.gmail.com>
Subject: Possible deadlock when deleting from realtime section
From: Denny Priebe <denny.priebe@googlemail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hi,

I'm experiencing a deadlock situation when deleting directories placed in
the realtime section. This is reproducable with kernel versions 2.6.35.7 and
2.6.36-rc8. I haven't tried final 2.6.36 yet. The same setup is working
perfectly without using the realtime section. The file system has been
created with

=A0mkfs.xfs -f -l logdev=3D/dev/sdb1 -r rtdev=3D/dev/sdb3,extsize=3D256k /d=
ev/sdb2

and mounted with

=A0mount -t xfs -o logdev=3D/dev/sdb1,rtdev=3D/dev/sdb3,sunit=3D512,swidth=
=3D2048 \
=A0/dev/sdb2 /there

This is where rm blocks:

SysRq : Show Blocked State
=A0task =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0PC stack =A0 pid fat=
her
rm =A0 =A0 =A0 =A0 =A0 =A0D 0000000000000005 =A0 =A0 0 =A01705 =A0 1658 0x0=
0000080
ffff88018c40d858 0000000000000086 ffff880100000000 ffff88018c40c010
ffff88018c40dfd8 00000000000148c0 ffff88018b1c2e20 ffff88018b1c31d8
ffff88018b1c31d0 00000000000148c0 00000000000148c0 ffff88018c40dfd8
Call Trace:
[<ffffffff81437739>] rwsem_down_failed_common+0xd3/0x105
[<ffffffff8143777e>] rwsem_down_write_failed+0x13/0x15
[<ffffffff81202ad3>] call_rwsem_down_write_failed+0x13/0x20
[<ffffffff81436e3d>] ? down_write+0x40/0x44
[<ffffffffa033be9b>] xfs_ilock+0x4a/0x9a [xfs]
[<ffffffffa033c413>] xfs_iget+0x34c/0x5cd [xfs]
[<ffffffffa0351fa9>] xfs_trans_iget+0x1b/0x56 [xfs]
[<ffffffffa0313035>] xfs_rtfree_extent+0x37/0xdc [xfs]
[<ffffffffa033fce2>] ? xfs_iext_remove+0xc0/0xd2 [xfs]
[<ffffffffa0324ffe>] ? xfs_bmap_del_extent+0x2e8/0x93d [xfs]
[<ffffffffa0324e87>] xfs_bmap_del_extent+0x171/0x93d [xfs]
[<ffffffffa03506eb>] ? xfs_trans_commit_iclog+0x2ba/0x2d3 [xfs]
[<ffffffffa0325dc3>] xfs_bunmapi+0x770/0xa28 [xfs]
[<ffffffffa033e44e>] xfs_itruncate_finish+0x185/0x2b8 [xfs]
[<ffffffffa0354437>] xfs_inactive+0x1c8/0x3d5 [xfs]
[<ffffffffa035f38c>] xfs_fs_evict_inode+0xd5/0xdd [xfs]
[<ffffffff8111282b>] evict+0x22/0x92
[<ffffffff81112c60>] iput+0x1bc/0x225
[<ffffffff8110b079>] do_unlinkat+0x103/0x156
[<ffffffff811086c5>] ? path_put+0x1d/0x22
[<ffffffff81093e2c>] ? audit_syscall_entry+0x119/0x145
[<ffffffff8110b205>] sys_unlinkat+0x24/0x26
[<ffffffff81009ac2>] system_call_fastpath+0x16/0x1b

Thanks in advance for any feedback,
Denny

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
