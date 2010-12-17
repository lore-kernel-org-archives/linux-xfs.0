Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBHHcUBm248408 for <xfs@oss.sgi.com>; Fri, 17 Dec 2010 11:38:30 -0600
Received: from mail-wy0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DC8881CD949A
	for <xfs@oss.sgi.com>; Fri, 17 Dec 2010 09:40:24 -0800 (PST)
Received: from mail-wy0-f181.google.com (mail-wy0-f181.google.com
	[74.125.82.181]) by cuda.sgi.com with ESMTP id iNl6zYSZKKANI6aN
	for <xfs@oss.sgi.com>; Fri, 17 Dec 2010 09:40:24 -0800 (PST)
Received: by wyf22 with SMTP id 22so901160wyf.26
	for <xfs@oss.sgi.com>; Fri, 17 Dec 2010 09:40:23 -0800 (PST)
MIME-Version: 1.0
Date: Sat, 18 Dec 2010 04:40:23 +1100
Message-ID: <AANLkTi=0E2eh=wnX+Kr=egLoigkMDq5UuaGyOxnk+T1Q@mail.gmail.com>
Subject: Another questionable lock order bug
From: Nick Piggin <npiggin@gmail.com>
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
To: xfs@oss.sgi.com, Dave Chinner <dchinner@redhat.com>

With the iprune_sem and iolock lock order warnings taken care of,
lockdep soon after chokes on i_lock


[  716.364005] inconsistent {RECLAIM_FS-ON-R} -> {IN-RECLAIM_FS-W} usage.
[  716.364005] cp/8370 [HC0[0]:SC0[0]:HE1:SE1] takes:
[  716.364005]  (&(&ip->i_lock)->mr_lock){++++-?}, at:
[<ffffffffa005537c>] xfs_ilock+0x8c/0x150 [xfs]
[  716.364005] {RECLAIM_FS-ON-R} state was registered at:
[  716.364005]   [<ffffffff8108392b>] mark_held_locks+0x6b/0xa0
[  716.364005]   [<ffffffff810839f1>] lockdep_trace_alloc+0x91/0xd0
[  716.364005]   [<ffffffff811104fa>] __kmalloc+0x5a/0x220
[  716.364005]   [<ffffffffa0078717>] kmem_alloc+0x87/0xd0 [xfs]
[  716.364005]   [<ffffffffa002b8fb>] xfs_attr_shortform_list+0xfb/0x480 [xfs]
[  716.364005]   [<ffffffffa0027ab8>] xfs_attr_list_int+0xd8/0xe0 [xfs]
[  716.364005]   [<ffffffffa0088b5f>] xfs_vn_listxattr+0x7f/0x160 [xfs]
[  716.364005]   [<ffffffff811396ef>] vfs_listxattr+0x1f/0x30
[  716.364005]   [<ffffffff81139b1f>] listxattr+0x3f/0xf0
[  716.364005]   [<ffffffff81139c14>] sys_flistxattr+0x44/0x70
[  716.364005]   [<ffffffff810030bb>] system_call_fastpath+0x16/0x1b[
716.364005] irq event stamp: 322521151
[  716.364005] hardirqs last  enabled at (322521151):
[<ffffffff81601cbd>] mutex_trylock+0x11d/0x190
[  716.364005] hardirqs last disabled at (322521150):
[<ffffffff81601bde>] mutex_trylock+0x3e/0x190
[  716.364005] softirqs last  enabled at (322518910):
[<ffffffff81050d0e>] __do_softirq+0x16e/0x360
[  716.364005] softirqs last disabled at (322518881):
[<ffffffff81003f8c>] call_softirq+0x1c/0x50
[  716.364005]
[  716.364005] other info that might help us debug this:
[  716.364005] 3 locks held by cp/8370:
[  716.364005]  #0:  (xfs_iolock_active){++++++}, at:
[<ffffffffa0055395>] xfs_ilock+0xa5/0x150 [xfs]
[  716.364005]  #1:  (shrinker_rwsem){++++..}, at:
[<ffffffff810d91c8>] shrink_slab+0x38/0x190
[  716.364005]  #2:  (&pag->pag_ici_reclaim_lock){+.+...}, at:
[<ffffffffa00875c4>] xfs_reclaim_inodes_ag+
0xa4/0x360 [xfs]
[  716.364005]
[  716.364005] stack backtrace:
[  716.364005] Pid: 8370, comm: cp Not tainted 2.6.37-rc6+ #116
[  716.364005] Call Trace:
[  716.364005]  [<ffffffff81082a10>] print_usage_bug+0x170/0x180
[  716.364005]  [<ffffffff810836d1>] mark_lock+0x211/0x400
[  716.364005]  [<ffffffff810842ce>] __lock_acquire+0x40e/0x1490
[  716.364005]  [<ffffffff810853e5>] lock_acquire+0x95/0x1b0
[  716.364005]  [<ffffffffa005537c>] ? xfs_ilock+0x8c/0x150 [xfs]
[  716.364005]  [<ffffffff8127c35c>] ? rcu_read_lock_held+0x2c/0x30
[  716.364005]  [<ffffffff81073d5a>] down_write_nested+0x4a/0x70
[  716.364005]  [<ffffffffa005537c>] ? xfs_ilock+0x8c/0x150 [xfs]
[  716.364005]  [<ffffffffa005537c>] xfs_ilock+0x8c/0x150 [xfs]
[  716.364005]  [<ffffffffa00872e6>] xfs_reclaim_inode+0x36/0x270 [xfs]
[  716.364005]  [<ffffffffa008772f>] xfs_reclaim_inodes_ag+0x20f/0x360 [xfs]
[  716.364005]  [<ffffffffa00878f8>] xfs_reclaim_inode_shrink+0x78/0x80 [xfs]
[  716.364005]  [<ffffffff810d92b7>] shrink_slab+0x127/0x190
[  716.364005]  [<ffffffff810dc189>] zone_reclaim+0x349/0x420

I assume this should be a false positive too, for the same reason,
and could be handled the same way as iolock.

Thanks,
Nick

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
