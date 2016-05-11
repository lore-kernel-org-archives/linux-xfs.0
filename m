Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 82D527CA0
	for <xfs@oss.sgi.com>; Wed, 11 May 2016 12:52:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D399FAC002
	for <xfs@oss.sgi.com>; Wed, 11 May 2016 10:52:08 -0700 (PDT)
Received: from na01-bl2-obe.outbound.protection.outlook.com
	(mail-bl2on0084.outbound.protection.outlook.com [65.55.169.84])
	by cuda.sgi.com with ESMTP id yzqPGOdumc0IccDU (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 11 May 2016 10:52:06 -0700 (PDT)
From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: 4.6-rc7 xfs circular locking dependency
Message-ID: <57337140.3020905@sandisk.com>
Date: Wed, 11 May 2016 10:52:00 -0700
MIME-Version: 1.0
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Hi Dave,

While retesting the SRP initiator with xfstests on top of an XFS filesystem I
hit the below call trace once. I do not expect that this is related to the SRP
initiator changes I made. Please let me know if you need more information.

Thanks,

Bart.

======================================================
[ INFO: possible circular locking dependency detected ]
4.6.0-rc7-dbg+ #1 Not tainted
-------------------------------------------------------
fsstress/17356 is trying to acquire lock:
 (sb_internal#2){++++.+}, at: [<ffffffff81193172>] __sb_start_write+0xb2/0xf0

but task is already holding lock:
 (&s->s_sync_lock){+.+...}, at: [<ffffffff811bba2d>] sync_inodes_sb+0xbd/0x1d0

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

nc_lock){+.+...}:
       [<ffffffff810a4e70>] lock_acquire+0x60/0x80
       [<ffffffff81582d2f>] mutex_lock_nested+0x5f/0x360
       [<ffffffff811bba2d>] sync_inodes_sb+0xbd/0x1d0
       [<ffffffffa0616963>] xfs_flush_inodes+0x23/0x30 [xfs]
       [<ffffffffa060ea9f>] xfs_create+0x46f/0x5f0 [xfs]
       [<ffffffffa0609f39>] xfs_generic_create+0x1b9/0x290 [xfs]
       [<ffffffffa060a03f>] xfs_vn_mknod+0xf/0x20 [xfs]
       [<ffffffffa060a07e>] xfs_vn_create+0xe/0x10 [xfs]
       [<ffffffff8119af96>] vfs_create+0x76/0xd0
       [<ffffffff8119f13e>] path_openat+0xc1e/0x10d0
       [<ffffffff811a04d9>] do_filp_open+0x79/0xd0
       [<ffffffff8118f636>] do_sys_open+0x116/0x1f0
       [<ffffffff8118f769>] SyS_creat+0x19/0x20
       [<ffffffff81585fe5>] entry_SYSCALL_64_fastpath+0x18/0xa8

nal#2){++++.+}:
       [<ffffffff810a461f>] __lock_acquire+0x1b0f/0x1b20
       [<ffffffff810a4e70>] lock_acquire+0x60/0x80
       [<ffffffff8109edd5>] percpu_down_read+0x45/0x90
       [<ffffffff81193172>] __sb_start_write+0xb2/0xf0
       [<ffffffffa061838f>] xfs_trans_alloc+0x1f/0x40 [xfs]
       [<ffffffffa060f4d0>] xfs_inactive_truncate+0x20/0x130 [xfs]
       [<ffffffffa060fc9e>] xfs_inactive+0x1ae/0x1e0 [xfs]
       [<ffffffffa0614e88>] xfs_fs_evict_inode+0xb8/0xc0 [xfs]
       [<ffffffff811acc83>] evict+0xb3/0x180
       [<ffffffff811acefc>] iput+0x14c/0x1e0
       [<ffffffff811bbab5>] sync_inodes_sb+0x145/0x1d0
       [<ffffffff811c23e0>] sync_inodes_one_sb+0x10/0x20
       [<ffffffff81193bda>] iterate_supers+0xaa/0x100
       [<ffffffff811c26d0>] sys_sync+0x30/0x90
       [<ffffffff81585fe5>] entry_SYSCALL_64_fastpath+0x18/0xa8

other info that might help us debug this:

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&s->s_sync_lock);
                               lock(sb_internal#2);
                               lock(&s->s_sync_lock);
  lock(sb_internal#2);

 *** DEADLOCK ***

2 locks held by fsstress/17356:
 #0:  (&type->s_umount_key#34){++++++}, at: [<ffffffff81193bc4>] iterate_supers+0x94/0x100
 #1:  (&s->s_sync_lock){+.+...}, at: [<ffffffff811bba2d>] sync_inodes_sb+0xbd/0x1d0

stack backtrace:
CPU: 2 PID: 17356 Comm: fsstress Not tainted 4.6.0-rc7-dbg+ #1
Hardware name: Dell Inc. PowerEdge R430/03XKDV, BIOS 1.0.2 11/17/2014
 0000000000000000 ffff880442b3bbe0 ffffffff812ac6b5 ffffffff8238e0c0
 ffffffff8238e0c0 ffff880442b3bc20 ffffffff810a1233 ffff880442b3bc70
 ffff8804153635c0 ffff880415363598 ffff880415362d80 ffff880415363570
Call Trace:
 [<ffffffff812ac6b5>] dump_stack+0x67/0x92
 [<ffffffff810a1233>] print_circular_bug+0x1e3/0x250
 [<ffffffff810a461f>] __lock_acquire+0x1b0f/0x1b20
 [<ffffffff8112382f>] ? truncate_inode_pages_range+0x2af/0x790
 [<ffffffff810a4e70>] lock_acquire+0x60/0x80
 [<ffffffff81193172>] ? __sb_start_write+0xb2/0xf0
 [<ffffffff8109edd5>] percpu_down_read+0x45/0x90
 [<ffffffff81193172>] ? __sb_start_write+0xb2/0xf0
 [<ffffffff81193172>] __sb_start_write+0xb2/0xf0
 [<ffffffff810a266f>] ? mark_held_locks+0x6f/0xa0
 [<ffffffffa061838f>] xfs_trans_alloc+0x1f/0x40 [xfs]
 [<ffffffffa060f4d0>] xfs_inactive_truncate+0x20/0x130 [xfs]
 [<ffffffffa060fc9e>] xfs_inactive+0x1ae/0x1e0 [xfs]
 [<ffffffffa0614e88>] xfs_fs_evict_inode+0xb8/0xc0 [xfs]
 [<ffffffff811acc83>] evict+0xb3/0x180
 [<ffffffff811acefc>] iput+0x14c/0x1e0
 [<ffffffff811bbab5>] sync_inodes_sb+0x145/0x1d0
 [<ffffffff811c23d0>] ? SyS_tee+0x400/0x400
 [<ffffffff811c23e0>] sync_inodes_one_sb+0x10/0x20
 [<ffffffff81193bda>] iterate_supers+0xaa/0x100
 [<ffffffff811c26d0>] sys_sync+0x30/0x90
 [<ffffffff81585fe5>] entry_SYSCALL_64_fastpath+0x18/0xa8

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
