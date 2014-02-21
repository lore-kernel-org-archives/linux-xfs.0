Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 79F4B7F92
	for <xfs@oss.sgi.com>; Fri, 21 Feb 2014 01:47:24 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 542068F8040
	for <xfs@oss.sgi.com>; Thu, 20 Feb 2014 23:47:20 -0800 (PST)
Received: from smtprelay.restena.lu (smtprelay.restena.lu [158.64.1.62]) by
	cuda.sgi.com with ESMTP id NsLuhio0k4reLzSl for
	<xfs@oss.sgi.com>; Thu, 20 Feb 2014 23:47:19 -0800 (PST)
Date: Fri, 21 Feb 2014 08:47:17 +0100
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
Subject: XFS Failed to recover EFIs - XFS_WANT_CORRUPTED_GOTO at line 1602
	of xfs_alloc.c
Message-ID: <20140221084717.3364a23e@pluto>
Mime-Version: 1.0
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
Cc: Ben Myers <bpm@sgi.com>

Hi,

A virtual server of mine stopped working properly yesterday because one
partition became corrupted (or corruption has been stumbled over).


Restarting the system any attempt to mount that partition (without
-o norecovery,ro) results in the following trace (transcribed):
XFS (sda5): Mounting Filesystem
XFS (sda5): Starting recovery (logdev: internal)
XFS: Internal error XFS_WANT_CORRUPTED_GOTO at line 1602 of file
     /var/cache/kernel/linux-git/fs/xfs/xfs_alloc.c. Caller
0xffffffff8116d926
CPU: 0 PID: 606 Commm: mount Not tainted 3.13.0-hetzner #1
Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
 000000000002eb84 ffff88001dc53ab8 ffffffff813ca339 ffff88001dc53ad8
 ffffffff81156d4a ffffffff8116d926 00000000000002a8 ffff88001dc53b68
 ffffffff8116b8dd ffff88001dd7ccc0 0000000000000000 0000000000000001
Call Trace:
 [<ffffffff813ca339>] dump_stack+0x19/0x1b
 [<ffffffff81156d4a>] xfs_error_report+0x3a0x40
 [<ffffffff8116d926>] ? xfs_free_extent+0xd6/0x120
 [<ffffffff8116b8dd>] xfs_free_ag_extent+0x48d/0x5c0
 [<ffffffff8116d926>] xfs_free_extent+0xd6/0x120
 [<ffffffff810d5fa4>] ? kmem_cache_alloc+0xa4/0xb0
 [<ffffffff8119c390>] xlog_recover_process_efi+0x170/0x1b0
 [<ffffffff81074709>] ? wake_up_bit+0x29/0x40
 [<ffffffff8119d106>] xlog_recover_process_efis.isra.27+0x46/0x80
 [<ffffffff811a17c5>] xlog_recover_finish+0x2c/0x50
 [<ffffffff811a5c4c>] xfs_log_mount_finish+0x2c/0x50
 [<ffffffff811958ee>] ? xfs_iunlock+0x6e/0x90
 [<ffffffff81164733>] xfs_mountfs+0x473/0x690
 [<ffffffff81167072>] xfs_fs_fill_super+0x292/0x310
 [<ffffffff810e7a61>] mount_bdev+0x191/0x1d0
 [<ffffffff811e337c>] ? ida_get_new_above+0x21c/0x290
 [<ffffffff81166de0>] ? xfs_parseargs+0xc10/0xc10
 [<ffffffff81165310>] xfs_fs_mount+0x10/0x20
 [<ffffffff810e7cab>] mount_fs+0x1b/0xd0
 [<ffffffff811001ad>] vfs_kern_mount+0x6d/0x100
 [<ffffffff811019bb>] do_mount+0x1fb/0x9d0
 [<ffffffff810b3b43>] ? strndup_user+0x53/0x70
 [<ffffffff81102469>] SyS_mount+0x89/0xd0
 [<ffffffff831ce4b7>] system_call_fastpath+0x16/0x1b
XFS (sda5): Failed to recover EFIs
XFS (sda5): log mount finish failed


After that the mount process remains in D state and any attempt to
xfs_repair that fileysystem blocks (reboot needed to do anything).

Is that expected or should the mount either completely fail, returning
proper error to mount and leave system in a state as if the mount had
never been attempted (except for the log messages)?


>From the cause of this, I guess it's some left-over of "unclean"
live migration of the KVM guest this system is running on some longer
time ago. After live migration some processes started dying weird
deaths. Rebooting the system worked fine by the time though.

The only major load on that system (not so heavy, about 10-20 IO-ops
per second on average, mostly writes) is updating RRD files and
running a slave MySQL (InnoDB) database.

I recovered the filesystem with xfs_repair -L /dev/sda5 though the
InnoDB state remaining is rather broken.
xfs_repair reported only claimed free space issues (I didn't save its
output).

Bruno

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
