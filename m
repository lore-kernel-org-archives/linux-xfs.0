Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q86AcQOA044397 for <xfs@oss.sgi.com>; Thu, 6 Sep 2012 05:38:26 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id y7zPlFhZz3VR6ZCz for
	<xfs@oss.sgi.com>; Thu, 06 Sep 2012 03:39:25 -0700 (PDT)
Date: Thu, 6 Sep 2012 06:39:21 -0400
From: Jeff Layton <jlayton@redhat.com>
Subject: xfs freeze annotation problem on 3.6.0-rc3+ kernel
Message-ID: <20120906063921.749a850a@corrin.poochiereds.net>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>

I got the following xfs-related lockdep pop on a 3.6.0-rc3+ kernel. 
I've been able to reproduce this twice now by doing a kernel build on
xfs.

The last commit from Linus' tree in this kernel is 9acb172. It also has
a pile of my own and Al Viro's patches on top, but I don't think any of
them would affect this. I should be able to test patches for this if
you come up with one, but since I've only seen it twice I'm not sure
how reproducible it is yet.

[ 4175.887865] 
[ 4175.888032] =========================================================
[ 4175.888032] [ INFO: possible irq lock inversion dependency detected ]
[ 4175.888032] 3.6.0-rc3+ #11 Not tainted
[ 4175.888032] ---------------------------------------------------------
[ 4175.888032] kswapd0/41 just changed the state of lock:
[ 4175.888032]  (sb_internal){.+.+.?}, at: [<ffffffffa00f60ad>] xfs_trans_alloc+0x2d/0x50 [xfs]
[ 4175.888032] but this lock took another, RECLAIM_FS-unsafe lock in the past:
[ 4175.888032]  (&(&ip->i_lock)->mr_lock/1){+.+.+.}
[ 4175.888032] 
[ 4175.888032] and interrupts could create inverse lock ordering between them.
[ 4175.888032] 
[ 4175.888032] 
[ 4175.888032] other info that might help us debug this:
[ 4175.888032]  Possible interrupt unsafe locking scenario:
[ 4175.888032] 
[ 4175.888032]        CPU0                    CPU1
[ 4175.888032]        ----                    ----
[ 4175.888032]   lock(&(&ip->i_lock)->mr_lock/1);
[ 4175.888032]                                local_irq_disable();
[ 4175.888032]                                lock(sb_internal);
[ 4175.888032]                                lock(&(&ip->i_lock)->mr_lock/1);
[ 4175.888032]   <Interrupt>
[ 4175.888032]     lock(sb_internal);
[ 4175.888032] 
[ 4175.888032]  *** DEADLOCK ***
[ 4175.888032] 
[ 4175.888032] 2 locks held by kswapd0/41:
[ 4175.888032]  #0:  (shrinker_rwsem){++++..}, at: [<ffffffff8116f8cc>] shrink_slab+0x3c/0x500
[ 4175.888032]  #1:  (&type->s_umount_key#19){++++.+}, at: [<ffffffff811ce3e4>] grab_super_passive+0x44/0x90
[ 4175.888032] 
[ 4175.888032] the shortest dependencies between 2nd lock and 1st lock:
[ 4175.888032]  -> (&(&ip->i_lock)->mr_lock/1){+.+.+.} ops: 14891 {
[ 4175.888032]     HARDIRQ-ON-W at:
[ 4175.888032]                       [<ffffffff810d3e66>] __lock_acquire+0x5d6/0x1ad0
[ 4175.888032]                       [<ffffffff810d5a41>] lock_acquire+0xa1/0x1f0
[ 4175.888032]                       [<ffffffff81098dc5>] down_write_nested+0x65/0xb0
[ 4175.888032]                       [<ffffffffa009f741>] xfs_ilock+0x121/0x200 [xfs]
[ 4175.888032]                       [<ffffffffa00af143>] xfs_create+0x243/0x7f0 [xfs]
[ 4175.888032]                       [<ffffffffa00a4e36>] xfs_vn_mknod+0xa6/0x1b0 [xfs]
[ 4175.888032]                       [<ffffffffa00a4f73>] xfs_vn_create+0x13/0x20 [xfs]
[ 4175.888032]                       [<ffffffff811dae05>] vfs_create+0xb5/0x120
[ 4175.888032]                       [<ffffffff811db802>] do_last+0x992/0xe30
[ 4175.888032]                       [<ffffffff811dbd5f>] path_openat+0xbf/0x500
[ 4175.888032]                       [<ffffffff811dc628>] do_filp_open+0x38/0x90
[ 4175.888032]                       [<ffffffff811c9356>] do_sys_open+0xf6/0x1e0
[ 4175.888032]                       [<ffffffff811c9461>] sys_open+0x21/0x30
[ 4175.888032]                       [<ffffffff816dac29>] system_call_fastpath+0x16/0x1b
[ 4175.888032]     SOFTIRQ-ON-W at:
[ 4175.888032]                       [<ffffffff810d3e94>] __lock_acquire+0x604/0x1ad0
[ 4175.888032]                       [<ffffffff810d5a41>] lock_acquire+0xa1/0x1f0
[ 4175.888032]                       [<ffffffff81098dc5>] down_write_nested+0x65/0xb0
[ 4175.888032]                       [<ffffffffa009f741>] xfs_ilock+0x121/0x200 [xfs]
[ 4175.888032]                       [<ffffffffa00af143>] xfs_create+0x243/0x7f0 [xfs]
[ 4175.888032]                       [<ffffffffa00a4e36>] xfs_vn_mknod+0xa6/0x1b0 [xfs]
[ 4175.888032]                       [<ffffffffa00a4f73>] xfs_vn_create+0x13/0x20 [xfs]
[ 4175.888032]                       [<ffffffff811dae05>] vfs_create+0xb5/0x120
[ 4175.888032]                       [<ffffffff811db802>] do_last+0x992/0xe30
[ 4175.888032]                       [<ffffffff811dbd5f>] path_openat+0xbf/0x500
[ 4175.888032]                       [<ffffffff811dc628>] do_filp_open+0x38/0x90
[ 4175.888032]                       [<ffffffff811c9356>] do_sys_open+0xf6/0x1e0
[ 4175.888032]                       [<ffffffff811c9461>] sys_open+0x21/0x30
[ 4175.888032]                       [<ffffffff816dac29>] system_call_fastpath+0x16/0x1b
[ 4175.888032]     RECLAIM_FS-ON-W at:
[ 4175.888032]                          [<ffffffff810d6442>] mark_held_locks+0xb2/0x130
[ 4175.888032]                          [<ffffffff810d6b95>] lockdep_trace_alloc+0x75/0xd0
[ 4175.888032]                          [<ffffffff811b069a>] kmem_cache_alloc_node_trace+0x3a/0x280
[ 4175.888032]                          [<ffffffff81197074>] vm_map_ram+0x294/0x7a0
[ 4175.888032]                          [<ffffffffa0094f8b>] _xfs_buf_map_pages+0x4b/0xf0 [xfs]
[ 4175.888032]                          [<ffffffffa0096b9b>] xfs_buf_get_map+0x13b/0x250 [xfs]
[ 4175.888032]                          [<ffffffffa0101af1>] xfs_trans_get_buf_map+0x131/0x2e0 [xfs]
[ 4175.888032]                          [<ffffffffa00e3d64>] xfs_ialloc_inode_init+0xe4/0x1f0 [xfs]
[ 4175.888032]                          [<ffffffffa00e4322>] xfs_ialloc_ag_alloc+0x1c2/0x570 [xfs]
[ 4175.888032]                          [<ffffffffa00e5b2e>] xfs_dialloc+0x11e/0x2b0 [xfs]
[ 4175.888032]                          [<ffffffffa00e7427>] xfs_ialloc+0x57/0x650 [xfs]
[ 4175.888032]                          [<ffffffffa00ad48a>] xfs_dir_ialloc+0x6a/0x2a0 [xfs]
[ 4175.888032]                          [<ffffffffa00af44c>] xfs_create+0x54c/0x7f0 [xfs]
[ 4175.888032]                          [<ffffffffa00a4e36>] xfs_vn_mknod+0xa6/0x1b0 [xfs]
[ 4175.888032]                          [<ffffffffa00a4f73>] xfs_vn_create+0x13/0x20 [xfs]
[ 4175.888032]                          [<ffffffff811dae05>] vfs_create+0xb5/0x120
[ 4175.888032]                          [<ffffffff811db802>] do_last+0x992/0xe30
[ 4175.888032]                          [<ffffffff811dbd5f>] path_openat+0xbf/0x500
[ 4175.888032]                          [<ffffffff811dc628>] do_filp_open+0x38/0x90
[ 4175.888032]                          [<ffffffff811c9356>] do_sys_open+0xf6/0x1e0
[ 4175.888032]                          [<ffffffff811c9461>] sys_open+0x21/0x30
[ 4175.888032]                          [<ffffffff816dac29>] system_call_fastpath+0x16/0x1b
[ 4175.888032]     INITIAL USE at:
[ 4175.888032]                      [<ffffffff810d3ba7>] __lock_acquire+0x317/0x1ad0
[ 4175.888032]                      [<ffffffff810d5a41>] lock_acquire+0xa1/0x1f0
[ 4175.888032]                      [<ffffffff81098dc5>] down_write_nested+0x65/0xb0
[ 4175.888032]                      [<ffffffffa009f741>] xfs_ilock+0x121/0x200 [xfs]
[ 4175.888032]                      [<ffffffffa00af143>] xfs_create+0x243/0x7f0 [xfs]
[ 4175.888032]                      [<ffffffffa00a4e36>] xfs_vn_mknod+0xa6/0x1b0 [xfs]
[ 4175.888032]                      [<ffffffffa00a4f73>] xfs_vn_create+0x13/0x20 [xfs]
[ 4175.888032]                      [<ffffffff811dae05>] vfs_create+0xb5/0x120
[ 4175.888032]                      [<ffffffff811db802>] do_last+0x992/0xe30
[ 4175.888032]                      [<ffffffff811dbd5f>] path_openat+0xbf/0x500
[ 4175.888032]                      [<ffffffff811dc628>] do_filp_open+0x38/0x90
[ 4175.888032]                      [<ffffffff811c9356>] do_sys_open+0xf6/0x1e0
[ 4175.888032]                      [<ffffffff811c9461>] sys_open+0x21/0x30
[ 4175.888032]                      [<ffffffff816dac29>] system_call_fastpath+0x16/0x1b
[ 4175.888032]   }
[ 4175.888032]   ... key      at: [<ffffffffa013bce9>] __key.50301+0x1/0xfffffffffffd4318 [xfs]
[ 4175.888032]   ... acquired at:
[ 4175.888032]    [<ffffffff810d5a41>] lock_acquire+0xa1/0x1f0
[ 4175.888032]    [<ffffffff81098dc5>] down_write_nested+0x65/0xb0
[ 4175.888032]    [<ffffffffa009f741>] xfs_ilock+0x121/0x200 [xfs]
[ 4175.888032]    [<ffffffffa00af143>] xfs_create+0x243/0x7f0 [xfs]
[ 4175.888032]    [<ffffffffa00a4e36>] xfs_vn_mknod+0xa6/0x1b0 [xfs]
[ 4175.888032]    [<ffffffffa00a4f73>] xfs_vn_create+0x13/0x20 [xfs]
[ 4175.888032]    [<ffffffff811dae05>] vfs_create+0xb5/0x120
[ 4175.888032]    [<ffffffff811db802>] do_last+0x992/0xe30
[ 4175.888032]    [<ffffffff811dbd5f>] path_openat+0xbf/0x500
[ 4175.888032]    [<ffffffff811dc628>] do_filp_open+0x38/0x90
[ 4175.888032]    [<ffffffff811c9356>] do_sys_open+0xf6/0x1e0
[ 4175.888032]    [<ffffffff811c9461>] sys_open+0x21/0x30
[ 4175.888032]    [<ffffffff816dac29>] system_call_fastpath+0x16/0x1b
[ 4175.888032] 
[ 4175.888032] -> (sb_internal){.+.+.?} ops: 233575 {
[ 4175.888032]    HARDIRQ-ON-R at:
[ 4175.888032]                     [<ffffffff810d3d78>] __lock_acquire+0x4e8/0x1ad0
[ 4175.888032]                     [<ffffffff810d5a41>] lock_acquire+0xa1/0x1f0
[ 4175.888032]                     [<ffffffff811cd117>] __sb_start_write+0xd7/0x1d0
[ 4175.888032]                     [<ffffffffa00f60ad>] xfs_trans_alloc+0x2d/0x50 [xfs]
[ 4175.888032]                     [<ffffffffa00a580a>] xfs_vn_update_time+0x4a/0x260 [xfs]
[ 4175.888032]                     [<ffffffff811e7e55>] update_time+0x25/0xc0
[ 4175.888032]                     [<ffffffff811e80d2>] touch_atime+0xf2/0x140
[ 4175.888032]                     [<ffffffff8115e414>] generic_file_aio_read+0x504/0x720
[ 4175.888032]                     [<ffffffffa009c409>] xfs_file_aio_read+0x159/0x380 [xfs]
[ 4175.888032]                     [<ffffffff811c97a7>] do_sync_read+0xa7/0xe0
[ 4175.888032]                     [<ffffffff811ca14c>] vfs_read+0xac/0x180
[ 4175.888032]                     [<ffffffff811ca26d>] sys_read+0x4d/0x90
[ 4175.888032]                     [<ffffffff816dac29>] system_call_fastpath+0x16/0x1b
[ 4175.888032]    SOFTIRQ-ON-R at:
[ 4175.888032]                     [<ffffffff810d3e94>] __lock_acquire+0x604/0x1ad0
[ 4175.888032]                     [<ffffffff810d5a41>] lock_acquire+0xa1/0x1f0
[ 4175.888032]                     [<ffffffff811cd117>] __sb_start_write+0xd7/0x1d0
[ 4175.888032]                     [<ffffffffa00f60ad>] xfs_trans_alloc+0x2d/0x50 [xfs]
[ 4175.888032]                     [<ffffffffa00a580a>] xfs_vn_update_time+0x4a/0x260 [xfs]
[ 4175.888032]                     [<ffffffff811e7e55>] update_time+0x25/0xc0
[ 4175.888032]                     [<ffffffff811e80d2>] touch_atime+0xf2/0x140
[ 4175.888032]                     [<ffffffff8115e414>] generic_file_aio_read+0x504/0x720
[ 4175.888032]                     [<ffffffffa009c409>] xfs_file_aio_read+0x159/0x380 [xfs]
[ 4175.888032]                     [<ffffffff811c97a7>] do_sync_read+0xa7/0xe0
[ 4175.888032]                     [<ffffffff811ca14c>] vfs_read+0xac/0x180
[ 4175.888032]                     [<ffffffff811ca26d>] sys_read+0x4d/0x90
[ 4175.888032]                     [<ffffffff816dac29>] system_call_fastpath+0x16/0x1b
[ 4175.888032]    IN-RECLAIM_FS-R at:
[ 4175.888032]                        [<ffffffff810d3ddc>] __lock_acquire+0x54c/0x1ad0
[ 4175.888032]                        [<ffffffff810d5a41>] lock_acquire+0xa1/0x1f0
[ 4175.888032]                        [<ffffffff811cd117>] __sb_start_write+0xd7/0x1d0
[ 4175.888032]                        [<ffffffffa00f60ad>] xfs_trans_alloc+0x2d/0x50 [xfs]
[ 4175.888032]                        [<ffffffffa00ad981>] xfs_free_eofblocks+0x101/0x240 [xfs]
[ 4175.888032]                        [<ffffffffa00ae93f>] xfs_inactive+0xaf/0x490 [xfs]
[ 4175.888032]                        [<ffffffffa00aa7e4>] xfs_fs_evict_inode+0x84/0x190 [xfs]
[ 4175.888032]                        [<ffffffff811e8aa7>] evict+0xa7/0x1a0
[ 4175.888032]                        [<ffffffff811e90ee>] dispose_list+0x3e/0x60
[ 4175.888032]                        [<ffffffff811e9a1b>] prune_icache_sb+0x16b/0x320
[ 4175.888032]                        [<ffffffff811ce515>] prune_super+0xe5/0x1b0
[ 4175.888032]                        [<ffffffff8116f9fb>] shrink_slab+0x16b/0x500
[ 4175.888032]                        [<ffffffff81173c31>] balance_pgdat+0x611/0x7e0
[ 4175.888032]                        [<ffffffff81173f91>] kswapd+0x191/0x610
[ 4175.888032]                        [<ffffffff81092487>] kthread+0xb7/0xc0
[ 4175.888032]                        [<ffffffff816dbe04>] kernel_thread_helper+0x4/0x10
[ 4175.888032]    RECLAIM_FS-ON-R at:
[ 4175.888032]                        [<ffffffff810d6442>] mark_held_locks+0xb2/0x130
[ 4175.888032]                        [<ffffffff810d6b95>] lockdep_trace_alloc+0x75/0xd0
[ 4175.888032]                        [<ffffffff811afbff>] kmem_cache_alloc+0x2f/0x260
[ 4175.888032]                        [<ffffffffa00b1437>] kmem_zone_alloc+0x67/0xf0 [xfs]
[ 4175.888032]                        [<ffffffffa00b14dd>] kmem_zone_zalloc+0x1d/0x50 [xfs]
[ 4175.888032]                        [<ffffffffa00f6017>] _xfs_trans_alloc+0x37/0xa0 [xfs]
[ 4175.888032]                        [<ffffffffa00f60bd>] xfs_trans_alloc+0x3d/0x50 [xfs]
[ 4175.888032]                        [<ffffffffa00a580a>] xfs_vn_update_time+0x4a/0x260 [xfs]
[ 4175.888032]                        [<ffffffff811e7e55>] update_time+0x25/0xc0
[ 4175.888032]                        [<ffffffff811e80d2>] touch_atime+0xf2/0x140
[ 4175.888032]                        [<ffffffff8115e414>] generic_file_aio_read+0x504/0x720
[ 4175.888032]                        [<ffffffffa009c409>] xfs_file_aio_read+0x159/0x380 [xfs]
[ 4175.888032]                        [<ffffffff811c97a7>] do_sync_read+0xa7/0xe0
[ 4175.888032]                        [<ffffffff811ca14c>] vfs_read+0xac/0x180
[ 4175.888032]                        [<ffffffff811ca26d>] sys_read+0x4d/0x90
[ 4175.888032]                        [<ffffffff816dac29>] system_call_fastpath+0x16/0x1b
[ 4175.888032]    INITIAL USE at:
[ 4175.888032]                    [<ffffffff810d3ba7>] __lock_acquire+0x317/0x1ad0
[ 4175.888032]                    [<ffffffff810d5a41>] lock_acquire+0xa1/0x1f0
[ 4175.888032]                    [<ffffffff811cd117>] __sb_start_write+0xd7/0x1d0
[ 4175.888032]                    [<ffffffffa00f60ad>] xfs_trans_alloc+0x2d/0x50 [xfs]
[ 4175.888032]                    [<ffffffffa00a580a>] xfs_vn_update_time+0x4a/0x260 [xfs]
[ 4175.888032]                    [<ffffffff811e7e55>] update_time+0x25/0xc0
[ 4175.888032]                    [<ffffffff811e80d2>] touch_atime+0xf2/0x140
[ 4175.888032]                    [<ffffffff8115e414>] generic_file_aio_read+0x504/0x720
[ 4175.888032]                    [<ffffffffa009c409>] xfs_file_aio_read+0x159/0x380 [xfs]
[ 4175.888032]                    [<ffffffff811c97a7>] do_sync_read+0xa7/0xe0
[ 4175.888032]                    [<ffffffff811ca14c>] vfs_read+0xac/0x180
[ 4175.888032]                    [<ffffffff811ca26d>] sys_read+0x4d/0x90
[ 4175.888032]                    [<ffffffff816dac29>] system_call_fastpath+0x16/0x1b
[ 4175.888032]  }
[ 4175.888032]  ... key      at: [<ffffffffa0133480>] xfs_fs_type+0x60/0xfffffffffffdcbe0 [xfs]
[ 4175.888032]  ... acquired at:
[ 4175.888032]    [<ffffffff810d2de6>] check_usage_forwards+0x136/0x140
[ 4175.888032]    [<ffffffff810d3756>] mark_lock+0x176/0x2b0
[ 4175.888032]    [<ffffffff810d3ddc>] __lock_acquire+0x54c/0x1ad0
[ 4175.888032]    [<ffffffff810d5a41>] lock_acquire+0xa1/0x1f0
[ 4175.888032]    [<ffffffff811cd117>] __sb_start_write+0xd7/0x1d0
[ 4175.888032]    [<ffffffffa00f60ad>] xfs_trans_alloc+0x2d/0x50 [xfs]
[ 4175.888032]    [<ffffffffa00ad981>] xfs_free_eofblocks+0x101/0x240 [xfs]
[ 4175.888032]    [<ffffffffa00ae93f>] xfs_inactive+0xaf/0x490 [xfs]
[ 4175.888032]    [<ffffffffa00aa7e4>] xfs_fs_evict_inode+0x84/0x190 [xfs]
[ 4175.888032]    [<ffffffff811e8aa7>] evict+0xa7/0x1a0
[ 4175.888032]    [<ffffffff811e90ee>] dispose_list+0x3e/0x60
[ 4175.888032]    [<ffffffff811e9a1b>] prune_icache_sb+0x16b/0x320
[ 4175.888032]    [<ffffffff811ce515>] prune_super+0xe5/0x1b0
[ 4175.888032]    [<ffffffff8116f9fb>] shrink_slab+0x16b/0x500
[ 4175.888032]    [<ffffffff81173c31>] balance_pgdat+0x611/0x7e0
[ 4175.888032]    [<ffffffff81173f91>] kswapd+0x191/0x610
[ 4175.888032]    [<ffffffff81092487>] kthread+0xb7/0xc0
[ 4175.888032]    [<ffffffff816dbe04>] kernel_thread_helper+0x4/0x10
[ 4175.888032] 
[ 4175.888032] 
[ 4175.888032] stack backtrace:
[ 4175.888032] Pid: 41, comm: kswapd0 Not tainted 3.6.0-rc3+ #11
[ 4175.888032] Call Trace:
[ 4175.888032]  [<ffffffff816c5bf1>] print_irq_inversion_bug.part.40+0x1b0/0x1bf
[ 4175.888032]  [<ffffffff810d2de6>] check_usage_forwards+0x136/0x140
[ 4175.888032]  [<ffffffff810d2cb0>] ? print_shortest_lock_dependencies+0x1c0/0x1c0
[ 4175.888032]  [<ffffffff810d3756>] mark_lock+0x176/0x2b0
[ 4175.888032]  [<ffffffff810d3ddc>] __lock_acquire+0x54c/0x1ad0
[ 4175.888032]  [<ffffffff810ac128>] ? sched_clock_cpu+0xa8/0x120
[ 4175.888032]  [<ffffffffa00e8a87>] ? xfs_iext_bno_to_ext+0x97/0x170 [xfs]
[ 4175.888032]  [<ffffffff8104bd71>] ? pvclock_clocksource_read+0x61/0xf0
[ 4175.888032]  [<ffffffff810d5a41>] lock_acquire+0xa1/0x1f0
[ 4175.888032]  [<ffffffffa00f60ad>] ? xfs_trans_alloc+0x2d/0x50 [xfs]
[ 4175.888032]  [<ffffffff810abf85>] ? sched_clock_local+0x25/0xa0
[ 4175.888032]  [<ffffffff811cd117>] __sb_start_write+0xd7/0x1d0
[ 4175.888032]  [<ffffffffa00f60ad>] ? xfs_trans_alloc+0x2d/0x50 [xfs]
[ 4175.888032]  [<ffffffffa00f60ad>] ? xfs_trans_alloc+0x2d/0x50 [xfs]
[ 4175.888032]  [<ffffffffa00f60ad>] xfs_trans_alloc+0x2d/0x50 [xfs]
[ 4175.888032]  [<ffffffffa00ad981>] xfs_free_eofblocks+0x101/0x240 [xfs]
[ 4175.888032]  [<ffffffffa00ae93f>] xfs_inactive+0xaf/0x490 [xfs]
[ 4175.888032]  [<ffffffff816d1c70>] ? _raw_spin_unlock_irq+0x30/0x50
[ 4175.888032]  [<ffffffffa00aa7e4>] xfs_fs_evict_inode+0x84/0x190 [xfs]
[ 4175.888032]  [<ffffffff811e8aa7>] evict+0xa7/0x1a0
[ 4175.888032]  [<ffffffff811e90ee>] dispose_list+0x3e/0x60
[ 4175.888032]  [<ffffffff811e9a1b>] prune_icache_sb+0x16b/0x320
[ 4175.888032]  [<ffffffff811ce515>] prune_super+0xe5/0x1b0
[ 4175.888032]  [<ffffffff8116f9fb>] shrink_slab+0x16b/0x500
[ 4175.888032]  [<ffffffff811bc8c0>] ? mem_cgroup_iter+0x190/0x300
[ 4175.888032]  [<ffffffff811bc80f>] ? mem_cgroup_iter+0xdf/0x300
[ 4175.888032]  [<ffffffff81173c31>] balance_pgdat+0x611/0x7e0
[ 4175.888032]  [<ffffffff810d666d>] ? trace_hardirqs_on+0xd/0x10
[ 4175.888032]  [<ffffffff81173f91>] kswapd+0x191/0x610
[ 4175.888032]  [<ffffffff81093250>] ? wake_up_bit+0x40/0x40
[ 4175.888032]  [<ffffffff81173e00>] ? balance_pgdat+0x7e0/0x7e0
[ 4175.888032]  [<ffffffff81092487>] kthread+0xb7/0xc0
[ 4175.888032]  [<ffffffff816dbe04>] kernel_thread_helper+0x4/0x10
[ 4175.888032]  [<ffffffff816d2170>] ? retint_restore_args+0x13/0x13
[ 4175.888032]  [<ffffffff810923d0>] ? __init_kthread_worker+0x70/0x70
[ 4175.888032]  [<ffffffff816dbe00>] ? gs_change+0x13/0x13

-- 
Jeff Layton <jlayton@redhat.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
