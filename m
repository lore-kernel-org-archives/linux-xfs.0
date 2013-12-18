Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0B74B29DF8
	for <xfs@oss.sgi.com>; Tue, 17 Dec 2013 21:38:15 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 9DF8EAC001
	for <xfs@oss.sgi.com>; Tue, 17 Dec 2013 19:38:11 -0800 (PST)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id sBzdzojIIQ0KA4Xu
	for <xfs@oss.sgi.com>; Tue, 17 Dec 2013 19:38:10 -0800 (PST)
Message-ID: <52B118A9.8080905@hardwarefreak.com>
Date: Tue, 17 Dec 2013 21:38:17 -0600
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: XFS blocked task in xlog_cil_force_lsn
References: <52B102FF.8040404@pzystorm.de>
In-Reply-To: <52B102FF.8040404@pzystorm.de>
Reply-To: stan@hardwarefreak.com
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
To: xfs@pzystorm.de, xfs@oss.sgi.com

On 12/17/2013 8:05 PM, Kevin Richter wrote:
> Hi,
> 
> around April 2012 there was a similar thread on this list which I have
> found via Google, so my mail topic is the same.
> 
> I have a RAID6 array with 5 disks (each 2TB, net: 6TB). While copying
> under heavy load there are always these blocks. At the bottom of this
> message I have included some line from the syslog.
> 
> Even a reboot is now not possible anymore, because the whole system
> hangs while executing the "sync" command in one of the shutdown scripts.
> 
> So... first I have thought that my disks are faulty.
> But with smartmontools I have started a short and a long test on all of
> the 5 disks: no errors
> 
> Then I have even recreated the whole array, but no improvement.
> 
> Details about my server: 3.2.0-57-generic, Ubuntu 12.04.3 LTS
> Details about the array: soft array with mdadm v3.2.5, no hardware raid
> controller in the server
> 
> The scheduler of the raid disks:
>> $ cat /sys/block/sd[cdefg]/queue/scheduler
>> noop deadline [cfq]
>> noop deadline [cfq]
>> noop deadline [cfq]
>> noop deadline [cfq]
>> noop deadline [cfq]
> 
> 
> Any ideas what I can do?

Your workload is seeking the disks to death, which is why you're getting
these timeouts.  The actuators simply can't keep up.

1.  Switch to deadline.  CFQ is not suitable for RAID storage, and not
suitable for XFS.  This may not be a silver bullet but it will help.

2.  Post your chunk size and RAID6 stripe_cache_size value.  They may be
sub optimal for your workload.  For the latter

$ cat /sys/block/mdX/md/stripe_cache_size

3.  Post 'xfs_info /dev/mdX'

4.  You're getting a lot of kswapd timeouts because you have swap and
the md/RAID6 array on the same disks.  Relocate swap to disks that are
not part of this RAID6.  Small SSDs are cheap and fast.  Buy one and put
swap on it.  Or install more RAM in the machine.  Going the SSD route is
better as it gives flexibility.  For instance, you can also relocate
your syslog files to it and anything else that does IO without eating
lots of space.  This decreases the IOPS load on your rust.

5.  Describe in some detail the workload(s) causing the heavy IO, and
thus these timeouts.


> 
> Thanks,
> Kevin
> 
> 
> 
>> Dec 18 02:19:19 kernel: [390470.193560] INFO: task kswapd0:51 blocked for more than 120 seconds.
>> Dec 18 02:19:19 kernel: [390470.194541] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>> Dec 18 02:19:19 kernel: [390470.195795] kswapd0         D ffffffff81806240     0    51      2 0x00000000
>> Dec 18 02:19:19 kernel: [390470.195804]  ffff8804658099f0 0000000000000046 ffff880465809a74 ffff880465809a78
>> Dec 18 02:19:19 kernel: [390470.195813]  ffff880465809fd8 ffff880465809fd8 ffff880465809fd8 00000000000137c0
>> Dec 18 02:19:19 kernel: [390470.195820]  ffff880465dd1700 ffff880465818000 0000000000000000 ffff88046175aa28
>> Dec 18 02:19:19 kernel: [390470.195827] Call Trace:
>> Dec 18 02:19:19 kernel: [390470.195844]  [<ffffffff8165f62f>] schedule+0x3f/0x60
>> Dec 18 02:19:19 kernel: [390470.195850]  [<ffffffff81660437>] __mutex_lock_slowpath+0xd7/0x150
>> Dec 18 02:19:19 kernel: [390470.195856]  [<ffffffff8166004a>] mutex_lock+0x2a/0x50
>> Dec 18 02:19:19 kernel: [390470.195904]  [<ffffffffa029dcf8>] xfs_reclaim_inodes_ag+0x2d8/0x3a0 [xfs]
>> Dec 18 02:19:19 kernel: [390470.195928]  [<ffffffffa029d83a>] ? __xfs_inode_set_reclaim_tag+0x4a/0x140 [xfs]
>> Dec 18 02:19:19 kernel: [390470.195951]  [<ffffffffa029d96d>] ? xfs_inode_set_reclaim_tag+0x3d/0xa0 [xfs]
>> Dec 18 02:19:19 kernel: [390470.195973]  [<ffffffffa029d9b4>] ? xfs_inode_set_reclaim_tag+0x84/0xa0 [xfs]
>> Dec 18 02:19:19 kernel: [390470.195995]  [<ffffffffa029c6a5>] ? xfs_fs_destroy_inode+0x65/0x150 [xfs]
>> Dec 18 02:19:19 kernel: [390470.196003]  [<ffffffff81194dfc>] ? destroy_inode+0x3c/0x70
>> Dec 18 02:19:19 kernel: [390470.196008]  [<ffffffff81194f5a>] ? evict+0x12a/0x1c0
>> Dec 18 02:19:19 kernel: [390470.196016]  [<ffffffff8166154e>] ? _raw_spin_lock+0xe/0x20
>> Dec 18 02:19:19 kernel: [390470.196037]  [<ffffffffa029df63>] xfs_reclaim_inodes_nr+0x33/0x40 [xfs]
>> Dec 18 02:19:19 kernel: [390470.196059]  [<ffffffffa029a715>] xfs_fs_free_cached_objects+0x15/0x20 [xfs]
>> Dec 18 02:19:19 kernel: [390470.196067]  [<ffffffff8117d71e>] prune_super+0x10e/0x1a0
>> Dec 18 02:19:19 kernel: [390470.196073]  [<ffffffff8112b924>] shrink_slab+0x154/0x300
>> Dec 18 02:19:19 kernel: [390470.196079]  [<ffffffff8112ec1a>] balance_pgdat+0x50a/0x6d0
>> Dec 18 02:19:19 kernel: [390470.196085]  [<ffffffff8112ef01>] kswapd+0x121/0x220
>> Dec 18 02:19:19 kernel: [390470.196090]  [<ffffffff8112ede0>] ? balance_pgdat+0x6d0/0x6d0
>> Dec 18 02:19:19 kernel: [390470.196097]  [<ffffffff8108b64c>] kthread+0x8c/0xa0
>> Dec 18 02:19:19 kernel: [390470.196105]  [<ffffffff8166bcf4>] kernel_thread_helper+0x4/0x10
>> Dec 18 02:19:19 kernel: [390470.196111]  [<ffffffff8108b5c0>] ? flush_kthread_worker+0xa0/0xa0
>> Dec 18 02:19:19 kernel: [390470.196117]  [<ffffffff8166bcf0>] ? gs_change+0x13/0x13
>> Dec 18 02:19:19 kernel: [390470.196121] INFO: task kswapd1:52 blocked for more than 120 seconds.
>> Dec 18 02:19:19 kernel: [390470.197086] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>> Dec 18 02:19:19 kernel: [390470.198427] kswapd1         D 0000000000000007     0    52      2 0x00000000
>> Dec 18 02:19:19 kernel: [390470.198434]  ffff88046580b840 0000000000000046 0000000000000001 00000000ffffffff
>> Dec 18 02:19:19 kernel: [390470.198441]  ffff88046580bfd8 ffff88046580bfd8 ffff88046580bfd8 00000000000137c0
>> Dec 18 02:19:19 kernel: [390470.198447]  ffff880865e8ae00 ffff880465819700 ffff88046580b830 0000000000000004
>> Dec 18 02:19:19 kernel: [390470.198454] Call Trace:
>> Dec 18 02:19:19 kernel: [390470.198462]  [<ffffffff8165f62f>] schedule+0x3f/0x60
>> Dec 18 02:19:19 kernel: [390470.198498]  [<ffffffffa02e4d17>] xlog_cil_force_lsn+0xf7/0x120 [xfs]
>> Dec 18 02:19:19 kernel: [390470.198510]  [<ffffffff811643af>] ? unfreeze_partials+0x24f/0x2b0
>> Dec 18 02:19:19 kernel: [390470.198521]  [<ffffffff810608e0>] ? try_to_wake_up+0x200/0x200
>> Dec 18 02:19:19 kernel: [390470.198554]  [<ffffffffa02d1c65>] ? xfs_iunpin_wait+0x35/0xb0 [xfs]
>> Dec 18 02:19:19 kernel: [390470.198587]  [<ffffffffa02e3367>] _xfs_log_force_lsn+0x57/0x2e0 [xfs]
>> Dec 18 02:19:19 kernel: [390470.198617]  [<ffffffffa02ba398>] ? xfs_bmbt_get_all+0x18/0x20 [xfs]
>> Dec 18 02:19:19 kernel: [390470.198646]  [<ffffffffa02ae972>] ? xfs_bmap_search_multi_extents+0x92/0x110 [xfs]
>> Dec 18 02:19:19 kernel: [390470.198677]  [<ffffffffa02d1c65>] ? xfs_iunpin_wait+0x35/0xb0 [xfs]
>> Dec 18 02:19:19 kernel: [390470.198710]  [<ffffffffa02e3608>] xfs_log_force_lsn+0x18/0x40 [xfs]
>> Dec 18 02:19:19 kernel: [390470.198740]  [<ffffffffa02cfdd4>] xfs_iunpin_nowait+0x44/0xb0 [xfs]
>> Dec 18 02:19:19 kernel: [390470.198769]  [<ffffffffa02d1c65>] xfs_iunpin_wait+0x35/0xb0 [xfs]
>> Dec 18 02:19:19 kernel: [390470.198780]  [<ffffffff8104ef9b>] ? try_wait_for_completion+0x4b/0x60
>> Dec 18 02:19:19 kernel: [390470.198806]  [<ffffffffa029cf72>] xfs_reclaim_inode+0xb2/0x2a0 [xfs]
>> Dec 18 02:19:19 kernel: [390470.198818]  [<ffffffff81314a4c>] ? radix_tree_gang_lookup_tag.part.7+0x6c/0xf0
>> Dec 18 02:19:19 kernel: [390470.198844]  [<ffffffffa029dc5f>] xfs_reclaim_inodes_ag+0x23f/0x3a0 [xfs]
>> Dec 18 02:19:19 kernel: [390470.198871]  [<ffffffffa029df63>] xfs_reclaim_inodes_nr+0x33/0x40 [xfs]
>> Dec 18 02:19:19 kernel: [390470.198895]  [<ffffffffa029a715>] xfs_fs_free_cached_objects+0x15/0x20 [xfs]
>> Dec 18 02:19:19 kernel: [390470.198905]  [<ffffffff8117d71e>] prune_super+0x10e/0x1a0
>> Dec 18 02:19:19 kernel: [390470.198913]  [<ffffffff8112b924>] shrink_slab+0x154/0x300
>> Dec 18 02:19:19 kernel: [390470.198922]  [<ffffffff8112ec1a>] balance_pgdat+0x50a/0x6d0
>> Dec 18 02:19:19 kernel: [390470.198931]  [<ffffffff8112ef01>] kswapd+0x121/0x220
>> Dec 18 02:19:19 kernel: [390470.198938]  [<ffffffff8112ede0>] ? balance_pgdat+0x6d0/0x6d0
>> Dec 18 02:19:19 kernel: [390470.198947]  [<ffffffff8108b64c>] kthread+0x8c/0xa0
>> Dec 18 02:19:19 kernel: [390470.198956]  [<ffffffff8105f750>] ? __migrate_task+0x120/0x120
>> Dec 18 02:19:19 kernel: [390470.198966]  [<ffffffff8166bcf4>] kernel_thread_helper+0x4/0x10
>> Dec 18 02:19:19 kernel: [390470.198974]  [<ffffffff8108b5c0>] ? flush_kthread_worker+0xa0/0xa0
>> Dec 18 02:19:19 kernel: [390470.198984]  [<ffffffff8166bcf0>] ? gs_change+0x13/0x13
>> Dec 18 02:19:19 kernel: [390470.199017] INFO: task xfsaild/dm-0:19192 blocked for more than 120 seconds.
>> Dec 18 02:19:19 kernel: [390470.199828] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>> Dec 18 02:19:19 kernel: [390470.200262] xfsaild/dm-0    D 0000000000000001     0 19192      2 0x00000000
>> Dec 18 02:19:19 kernel: [390470.200268]  ffff88084e847a60 0000000000000046 ffff88046454d500 0000000000000000
>> Dec 18 02:19:19 kernel: [390470.200274]  ffff88084e847fd8 ffff88084e847fd8 ffff88084e847fd8 00000000000137c0
>> Dec 18 02:19:19 kernel: [390470.200281]  ffff88045fdd0000 ffff880461b1dc00 ffff88084e847a50 ffff88085f47d080
>> Dec 18 02:19:19 kernel: [390470.200288] Call Trace:
>> Dec 18 02:19:19 kernel: [390470.200293]  [<ffffffff8165f62f>] schedule+0x3f/0x60
>> Dec 18 02:19:19 kernel: [390470.200323]  [<ffffffffa02e25da>] xlog_state_get_iclog_space+0xea/0x2e0 [xfs]
>> Dec 18 02:19:19 kernel: [390470.200330]  [<ffffffff810608e0>] ? try_to_wake_up+0x200/0x200
>> Dec 18 02:19:19 kernel: [390470.200358]  [<ffffffffa02e2b99>] xlog_write+0xe9/0x400 [xfs]
>> Dec 18 02:19:19 kernel: [390470.200382]  [<ffffffffa02a2877>] ? kmem_zone_alloc+0x67/0xe0 [xfs]
>> Dec 18 02:19:19 kernel: [390470.200410]  [<ffffffffa02e440c>] xlog_cil_push+0x20c/0x380 [xfs]
>> Dec 18 02:19:19 kernel: [390470.200438]  [<ffffffffa02e4d2e>] xlog_cil_force_lsn+0x10e/0x120 [xfs]
>> Dec 18 02:19:19 kernel: [390470.200446]  [<ffffffff810136e5>] ? __switch_to+0xf5/0x360
>> Dec 18 02:19:19 kernel: [390470.200473]  [<ffffffffa02e3098>] _xfs_log_force+0x68/0x2a0 [xfs]
>> Dec 18 02:19:19 kernel: [390470.200481]  [<ffffffff81078cb2>] ? try_to_del_timer_sync+0x92/0x130
>> Dec 18 02:19:19 kernel: [390470.200507]  [<ffffffffa02e32e8>] xfs_log_force+0x18/0x40 [xfs]
>> Dec 18 02:19:19 kernel: [390470.200535]  [<ffffffffa02e7743>] xfsaild_push+0x213/0x680 [xfs]
>> Dec 18 02:19:19 kernel: [390470.200540]  [<ffffffff8165fb45>] ? schedule_timeout+0x175/0x320
>> Dec 18 02:19:19 kernel: [390470.200568]  [<ffffffffa02e7c12>] xfsaild+0x62/0xc0 [xfs]
>> Dec 18 02:19:19 kernel: [390470.200593]  [<ffffffffa02e7bb0>] ? xfsaild_push+0x680/0x680 [xfs]
>> Dec 18 02:19:19 kernel: [390470.200599]  [<ffffffff8108b64c>] kthread+0x8c/0xa0
>> Dec 18 02:19:19 kernel: [390470.200605]  [<ffffffff8166bcf4>] kernel_thread_helper+0x4/0x10
>> Dec 18 02:19:19 kernel: [390470.200611]  [<ffffffff8108b5c0>] ? flush_kthread_worker+0xa0/0xa0
>> Dec 18 02:19:19 kernel: [390470.200617]  [<ffffffff8166bcf0>] ? gs_change+0x13/0x13

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
