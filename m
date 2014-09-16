Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 923247F47
	for <xfs@oss.sgi.com>; Tue, 16 Sep 2014 16:53:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7D80B8F8039
	for <xfs@oss.sgi.com>; Tue, 16 Sep 2014 14:53:52 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	BsM3qlmeVrWPDSDk for <xfs@oss.sgi.com>;
	Tue, 16 Sep 2014 14:53:49 -0700 (PDT)
Date: Wed, 17 Sep 2014 07:53:36 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [BUG, 3.17-rc4] dentry still in use during unmount
Message-ID: <20140916215336.GL4322@dastard>
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
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

Hi Al,

One of my xfstest rigs tripped over this last night when running
xfs/301 on a pair of 4G ramdisks during an auto group run:

BUG: Dentry ffff8803c14fc870{i=0,n=dir}  still in use (-127) [unmount of xfs ram1]
------------[ cut here ]------------
WARNING: CPU: 4 PID: 27856 at fs/dcache.c:1319 umount_check+0x7f/0x90()
Modules linked in:
CPU: 4 PID: 27856 Comm: umount Tainted: G        W      3.17.0-rc4-dgc+ #479
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
 0000000000000009 ffff88025eeefd80 ffffffff81cf7327 0000000000000000
 ffff88025eeefdb8 ffffffff810933bd ffff8803c14fc870 ffff88011aeba800
 ffffffff81db2860 ffff88023acf72c0 00000000002353d2 ffff88025eeefdc8
Call Trace:
 [<ffffffff81cf7327>] dump_stack+0x45/0x56
 [<ffffffff810933bd>] warn_slowpath_common+0x7d/0xa0
 [<ffffffff8109349a>] warn_slowpath_null+0x1a/0x20
 [<ffffffff811c1baf>] umount_check+0x7f/0x90
 [<ffffffff811c2ea6>] d_walk+0x66/0x2c0
 [<ffffffff811c1b30>] ? d_lru_del+0xa0/0xa0
 [<ffffffff811c3286>] do_one_tree+0x26/0x40
 [<ffffffff811c43ba>] shrink_dcache_for_umount+0x5a/0x90
 [<ffffffff811aebe1>] generic_shutdown_super+0x21/0xf0
 [<ffffffff811aefdc>] kill_block_super+0x3c/0x90
 [<ffffffff811af309>] deactivate_locked_super+0x49/0x60
 [<ffffffff811af8b6>] deactivate_super+0x46/0x60
 [<ffffffff811cb04a>] mntput_no_expire+0xca/0x120
 [<ffffffff811cc5ce>] SyS_umount+0x8e/0x100
 [<ffffffff81d025e9>] system_call_fastpath+0x16/0x1b
---[ end trace 15254c3c565abf1a ]---
VFS: Busy inodes after unmount of ram1. Self-destruct in 5 seconds.  Have a nice day...

I can't reproduce it easily:

$ sudo MKFS_OPTIONS="-m crc=1,finobt=1" ./check xfs/301
FSTYP         -- xfs (debug)
PLATFORM      -- Linux/x86_64 test4 3.17.0-rc4-dgc+
MKFS_OPTIONS  -- -f -m crc=1,finobt=1 /dev/ram1
MOUNT_OPTIONS -- /dev/ram1 /mnt/scr

xfs/301 12s ... 12s
Ran: xfs/301
Passed all 1 tests
$

And even run in a loop for 20 minutes it hasn't triggered the error.
I haven't seen this before, so I thought I better give you the heads
up just in case.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
