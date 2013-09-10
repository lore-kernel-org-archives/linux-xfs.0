Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7B2B97F5D
	for <xfs@oss.sgi.com>; Tue, 10 Sep 2013 02:36:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id EC537AC002
	for <xfs@oss.sgi.com>; Tue, 10 Sep 2013 00:36:36 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	4yxPcFq5sJUvMdrl for <xfs@oss.sgi.com>;
	Tue, 10 Sep 2013 00:36:35 -0700 (PDT)
Received: from dave by dastard with local (Exim 4.76)
	(envelope-from <david@fromorbit.com>) id 1VJIUv-00055I-2E
	for xfs@oss.sgi.com; Tue, 10 Sep 2013 17:36:29 +1000
Date: Tue, 10 Sep 2013 17:36:29 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [deadlock] AGI vs AGF ordering deadlocks
Message-ID: <20130910073629.GA19103@dastard>
MIME-Version: 1.0
Content-Disposition: inline
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

FOlks,

I just got confirmation of a deadlock I suspected has existed for
some time. A concurrent 16-way create and 16-way unlink just locked
up with two threads looking like this:

fs_mark         D ffff88021bd931c0  3656  7204   7117 0x00000000
 ffff8801e75293a8 0000000000000086 ffff88012c6d0000 ffff8801e7529fd8
 ffff8801e7529fd8 ffff8801e7529fd8 ffff8802d32aae40 ffff88012c6d0000
 ffff8801a2f79d40 7fffffffffffffff ffff8801ee733bb0 0000000000000002
Call Trace:
 [<ffffffff819b0d19>] schedule+0x29/0x70
 [<ffffffff819acd09>] schedule_timeout+0x149/0x1f0
 [<ffffffff819af6bc>] __down_common+0x91/0xe8
 [<ffffffff819af786>] __down+0x1d/0x1f
 [<ffffffff810b5211>] down+0x41/0x50
 [<ffffffff81423dd0>] xfs_buf_lock+0x40/0xf0
 [<ffffffff81424051>] _xfs_buf_find+0x1d1/0x4d0
 [<ffffffff814244f5>] xfs_buf_get_map+0x35/0x180
 [<ffffffff81425517>] xfs_buf_read_map+0x37/0x110
 [<ffffffff8149e299>] xfs_trans_read_buf_map+0x379/0x600
 [<ffffffff81444178>] xfs_read_agf+0xa8/0x100
 [<ffffffff8144423a>] xfs_alloc_read_agf+0x6a/0x250
 [<ffffffff81444950>] xfs_alloc_fix_freelist+0x4f0/0x5a0
 [<ffffffff81444e40>] xfs_alloc_vextent+0x440/0x840
 [<ffffffff8147d0cf>] xfs_ialloc_ag_alloc+0x13f/0x520
 [<ffffffff8147e871>] xfs_dialloc+0x121/0x2d0
 [<ffffffff814803db>] xfs_ialloc+0x5b/0x7c0
 [<ffffffff81480bda>] xfs_dir_ialloc+0x9a/0x2f0
 [<ffffffff8148134d>] xfs_create+0x47d/0x6a0
 [<ffffffff814343ea>] xfs_vn_mknod+0xba/0x1c0
 [<ffffffff81434523>] xfs_vn_create+0x13/0x20
 [<ffffffff811a62a5>] vfs_create+0xb5/0xf0
 [<ffffffff811a6a40>] do_last.isra.56+0x760/0xd10
 [<ffffffff811a70ae>] path_openat+0xbe/0x620
 [<ffffffff811a7bc3>] do_filp_open+0x43/0xa0
 [<ffffffff811969cc>] do_sys_open+0x13c/0x230
 [<ffffffff81196ae2>] SyS_open+0x22/0x30
 [<ffffffff819bae19>] system_call_fastpath+0x16/0x1b

That a thread holding an AGI and blocking trying to get the AGF to
do an inode chunk allocation.

rm              D ffff88021bd931c0  3048  7073   7063 0x00000000
 ffff8802bc66d998 0000000000000086 ffff8802d32aae40 ffff8802bc66dfd8
 ffff8802bc66dfd8 ffff8802bc66dfd8 ffff88012c6d5c80 ffff8802d32aae40
 ffff8804091b2b00 7fffffffffffffff ffff8801b943c570 0000000000000002
Call Trace:
 [<ffffffff819b0d19>] schedule+0x29/0x70
 [<ffffffff819acd09>] schedule_timeout+0x149/0x1f0
 [<ffffffff819af6bc>] __down_common+0x91/0xe8
 [<ffffffff819af786>] __down+0x1d/0x1f
 [<ffffffff810b5211>] down+0x41/0x50
 [<ffffffff81423dd0>] xfs_buf_lock+0x40/0xf0
 [<ffffffff81424051>] _xfs_buf_find+0x1d1/0x4d0
 [<ffffffff814244f5>] xfs_buf_get_map+0x35/0x180
 [<ffffffff81425517>] xfs_buf_read_map+0x37/0x110
 [<ffffffff8149e299>] xfs_trans_read_buf_map+0x379/0x600
 [<ffffffff8147d8ca>] xfs_read_agi+0xaa/0x100
 [<ffffffff81481f4e>] xfs_iunlink+0x8e/0x260
 [<ffffffff81482198>] xfs_droplink+0x78/0x80
 [<ffffffff81483671>] xfs_remove+0x331/0x420
 [<ffffffff814340f2>] xfs_vn_unlink+0x52/0xa0
 [<ffffffff811a4f9e>] vfs_unlink+0x9e/0x110
 [<ffffffff811a51b1>] do_unlinkat+0x1a1/0x230
 [<ffffffff811a805b>] SyS_unlinkat+0x1b/0x40

And that's a thread that has just freed a directory block and so
holds an AGF lock, and is trying to take the AGI lock to add the
inode to the unlinked list.  Everything else is now stuck waiting
for log space because one of the two buffers we've deadlocked on
here pins the tail of the log.

The solution is to place the inode on the unlinked list before we
remove the directory entry so that we keep the same locking order as
inode allocation.

I don't have time to look at this for at least a week, so if someone
could work up solution that'd be wonderful...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
