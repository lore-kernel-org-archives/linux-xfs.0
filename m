Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6RBXSS0182487 for <xfs@oss.sgi.com>; Tue, 27 Jul 2010 06:33:28 -0500
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DF63C1BE8CEA
	for <xfs@oss.sgi.com>; Tue, 27 Jul 2010 04:36:30 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	fUAGPwEAjJI1zHat for <xfs@oss.sgi.com>;
	Tue, 27 Jul 2010 04:36:30 -0700 (PDT)
Date: Tue, 27 Jul 2010 21:36:26 +1000
From: Nick Piggin <npiggin@kernel.dk>
Subject: XFS hang in xlog_grant_log_space (was Re: VFS scalability git tree)
Message-ID: <20100727113626.GA2884@amd>
References: <20100722190100.GA22269@amd> <20100723135514.GJ32635@dastard>
	<20100727070538.GA2893@amd> <20100727080632.GA4958@amd>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100727080632.GA4958@amd>
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

On Tue, Jul 27, 2010 at 06:06:32PM +1000, Nick Piggin wrote:
> On Tue, Jul 27, 2010 at 05:05:39PM +1000, Nick Piggin wrote:
> > On Fri, Jul 23, 2010 at 11:55:14PM +1000, Dave Chinner wrote:
> > > On Fri, Jul 23, 2010 at 05:01:00AM +1000, Nick Piggin wrote:
> > > > I'm pleased to announce I have a git tree up of my vfs scalability work.
> > > > 
> > > > git://git.kernel.org/pub/scm/linux/kernel/git/npiggin/linux-npiggin.git
> > > > http://git.kernel.org/?p=linux/kernel/git/npiggin/linux-npiggin.git
> > > > 
> > > > Branch vfs-scale-working
> > > 
> > > With a production build (i.e. no lockdep, no xfs debug), I'll
> > > run the same fs_mark parallel create/unlink workload to show
> > > scalability as I ran here:
> > > 
> > > http://oss.sgi.com/archives/xfs/2010-05/msg00329.html
> > 
> > I've made a similar setup, 2s8c machine, but using 2GB ramdisk instead
> > of a real disk (I don't have easy access to a good disk setup ATM, but
> > I guess we're more interested in code above the block layer anyway).
> > 
> > Made an XFS on /dev/ram0 with 16 ags, 64MB log, otherwise same config as
> > yours.
> > 
> > I found that performance is a little unstable, so I sync and echo 3 >
> > drop_caches between each run. When it starts reclaiming memory, things
> > get a bit more erratic (and XFS seemed to be almost livelocking for tens
> > of seconds in inode reclaim).

On this same system, same setup (vanilla kernel with sha given below),
I have now twice reproduced a complete hang in XFS. I can give more
information, test patches or options etc if required.

setup.sh looks like this:
#!/bin/bash
modprobe rd rd_size=$[2*1024*1024]
dd if=/dev/zero of=/dev/ram0 bs=4K
mkfs.xfs -f -l size=64m -d agcount=16 /dev/ram0
mount -o delaylog,logbsize=262144,nobarrier /dev/ram0 mnt

The 'dd' is required to ensure rd driver does not allocate pages
during IO (which can lead to out of memory deadlocks). Running just
involves changing into mnt directory and

while true
do
  sync
  echo 3 > /proc/sys/vm/drop_caches
  ../dbench -c ../loadfiles/client.txt -t20 8
  rm -rf clients
done

And wait for it to hang (happend in < 5 minutes here)


Sysrq of blocked tasks looks like this:

Linux version 2.6.35-rc5-00176-gcd5b8f8 (npiggin@amd) (gcc version 4.4.4 (Debian 4.4.4-7) ) #348 SMP Mon Jul 26 22:20:32 EST 2010

brd: module loaded
Enabling EXPERIMENTAL delayed logging feature - use at your own risk.
XFS mounting filesystem ram0
Ending clean XFS mount for filesystem: ram0
SysRq : Show Blocked State
  task                        PC stack   pid father
flush-1:0     D 00000000fffff8fd     0  2799      2 0x00000000
 ffff8800701ff690 0000000000000046 ffff880000000000 ffff8800701fffd8
 ffff8800071531f0 00000000000122c0 0000000000004000 ffff8800701fffd8
 0000000000004000 00000000000122c0 ffff88007f2d3750 ffff8800071531f0
Call Trace:
 [<ffffffff812361f8>] xlog_grant_log_space+0x158/0x3d0
 [<ffffffff8124a0b5>] ? kmem_zone_zalloc+0x35/0x50
 [<ffffffff81034bf0>] ? default_wake_function+0x0/0x10
 [<ffffffff8124410c>] ? xfs_trans_ail_push+0x1c/0x80
 [<ffffffff81236552>] xfs_log_reserve+0xe2/0xf0
 [<ffffffff81243307>] xfs_trans_reserve+0x97/0x200
 [<ffffffff8122b637>] ? xfs_iunlock+0x57/0xb0
 [<ffffffff8123275b>] xfs_iomap_write_allocate+0x25b/0x3c0
 [<ffffffff81232abe>] xfs_iomap+0x1fe/0x270
 [<ffffffff8124aaf7>] xfs_map_blocks+0x37/0x40
 [<ffffffff8107b8e1>] ? find_lock_page+0x21/0x70
 [<ffffffff8124bdca>] xfs_page_state_convert+0x35a/0x690
 [<ffffffff8107c38a>] ? find_or_create_page+0x3a/0xa0
 [<ffffffff8124c3a6>] xfs_vm_writepage+0x76/0x110
 [<ffffffff8108eb00>] ? __dec_zone_page_state+0x30/0x40
 [<ffffffff81082c32>] __writepage+0x12/0x40
 [<ffffffff81083367>] write_cache_pages+0x1c7/0x3d0
 [<ffffffff81082c20>] ? __writepage+0x0/0x40
 [<ffffffff8108358f>] generic_writepages+0x1f/0x30
 [<ffffffff8124c2fc>] xfs_vm_writepages+0x4c/0x60
 [<ffffffff810835bc>] do_writepages+0x1c/0x40
 [<ffffffff810d606e>] writeback_single_inode+0xce/0x3b0
 [<ffffffff810d6774>] writeback_sb_inodes+0x174/0x260
 [<ffffffff810d701f>] writeback_inodes_wb+0x8f/0x180
 [<ffffffff810d733b>] wb_writeback+0x22b/0x290
 [<ffffffff810d7536>] wb_do_writeback+0x196/0x1a0
 [<ffffffff810d7583>] bdi_writeback_task+0x43/0x120
 [<ffffffff81050f46>] ? bit_waitqueue+0x16/0xe0
 [<ffffffff8108fd00>] ? bdi_start_fn+0x0/0xe0
 [<ffffffff8108fd6c>] bdi_start_fn+0x6c/0xe0
 [<ffffffff8108fd00>] ? bdi_start_fn+0x0/0xe0
 [<ffffffff81050bee>] kthread+0x8e/0xa0
 [<ffffffff81003014>] kernel_thread_helper+0x4/0x10
 [<ffffffff81050b60>] ? kthread+0x0/0xa0
 [<ffffffff81003010>] ? kernel_thread_helper+0x0/0x10
xfssyncd/ram0 D 00000000fffff045     0  2807      2 0x00000000
 ffff880007635d00 0000000000000046 ffff880000000000 ffff880007635fd8
 ffff880007abd370 00000000000122c0 0000000000004000 ffff880007635fd8
 0000000000004000 00000000000122c0 ffff88007f2b7710 ffff880007abd370
Call Trace:
 [<ffffffff812361f8>] xlog_grant_log_space+0x158/0x3d0
 [<ffffffff8124a0b5>] ? kmem_zone_zalloc+0x35/0x50
 [<ffffffff81034bf0>] ? default_wake_function+0x0/0x10
 [<ffffffff8124410c>] ? xfs_trans_ail_push+0x1c/0x80
 [<ffffffff81236552>] xfs_log_reserve+0xe2/0xf0
 [<ffffffff81243307>] xfs_trans_reserve+0x97/0x200
 [<ffffffff812572b7>] ? xfs_inode_ag_iterator+0x57/0xd0
 [<ffffffff81256c0a>] xfs_commit_dummy_trans+0x4a/0xe0
 [<ffffffff81257454>] xfs_sync_worker+0x74/0x80
 [<ffffffff81256b2a>] xfssyncd+0x13a/0x1d0
 [<ffffffff812569f0>] ? xfssyncd+0x0/0x1d0
 [<ffffffff81050bee>] kthread+0x8e/0xa0
 [<ffffffff81003014>] kernel_thread_helper+0x4/0x10
 [<ffffffff81050b60>] ? kthread+0x0/0xa0
 [<ffffffff81003010>] ? kernel_thread_helper+0x0/0x10
dbench        D 00000000ffffefc6     0  2975   2974 0x00000000
 ffff88005ecd1ae8 0000000000000082 ffff880000000000 ffff88005ecd1fd8
 ffff8800079ce250 00000000000122c0 0000000000004000 ffff88005ecd1fd8
 0000000000004000 00000000000122c0 ffff88007f2d3750 ffff8800079ce250
Call Trace:
 [<ffffffff812361f8>] xlog_grant_log_space+0x158/0x3d0
 [<ffffffff8124a0b5>] ? kmem_zone_zalloc+0x35/0x50
 [<ffffffff81034bf0>] ? default_wake_function+0x0/0x10
 [<ffffffff8124410c>] ? xfs_trans_ail_push+0x1c/0x80
 [<ffffffff81236552>] xfs_log_reserve+0xe2/0xf0
 [<ffffffff81243307>] xfs_trans_reserve+0x97/0x200
 [<ffffffff81247920>] xfs_create+0x170/0x5d0
 [<ffffffff810ca6e2>] ? __d_lookup+0xa2/0x140
 [<ffffffff810d0724>] ? mntput_no_expire+0x24/0xe0
 [<ffffffff81253202>] xfs_vn_mknod+0xa2/0x1b0
 [<ffffffff8125332b>] xfs_vn_create+0xb/0x10
 [<ffffffff810c1471>] vfs_create+0x81/0xd0
 [<ffffffff810c2915>] do_last+0x515/0x670
 [<ffffffff810c48cd>] do_filp_open+0x21d/0x650
 [<ffffffff810c6871>] ? filldir+0x71/0xd0
 [<ffffffff8103f012>] ? current_fs_time+0x22/0x30
 [<ffffffff810ce96b>] ? alloc_fd+0x4b/0x130
 [<ffffffff810b5d34>] do_sys_open+0x64/0x140
 [<ffffffff810b5bbd>] ? filp_close+0x4d/0x80
 [<ffffffff810b5e3b>] sys_open+0x1b/0x20
 [<ffffffff810022eb>] system_call_fastpath+0x16/0x1b
dbench        D 00000000fffff045     0  2976   2974 0x00000000
 ffff880060c11b18 0000000000000086 ffff880000000000 ffff880060c11fd8
 ffff880007668630 00000000000122c0 0000000000004000 ffff880060c11fd8
 0000000000004000 00000000000122c0 ffffffff81793020 ffff880007668630
Call Trace:
 [<ffffffff81236320>] xlog_grant_log_space+0x280/0x3d0
 [<ffffffff81034bf0>] ? default_wake_function+0x0/0x10
 [<ffffffff8124410c>] ? xfs_trans_ail_push+0x1c/0x80
 [<ffffffff81236552>] xfs_log_reserve+0xe2/0xf0
 [<ffffffff81243307>] xfs_trans_reserve+0x97/0x200
 [<ffffffff812412c8>] xfs_rename+0x138/0x630
 [<ffffffff810c036e>] ? exec_permission+0x3e/0x70
 [<ffffffff81253111>] xfs_vn_rename+0x61/0x70
 [<ffffffff810c1b4e>] vfs_rename+0x41e/0x480
 [<ffffffff810c3bd6>] sys_renameat+0x236/0x270
 [<ffffffff8122551d>] ? xfs_dir2_sf_getdents+0x21d/0x390
 [<ffffffff810c6800>] ? filldir+0x0/0xd0
 [<ffffffff8103f012>] ? current_fs_time+0x22/0x30
 [<ffffffff810b8a4a>] ? fput+0x1aa/0x220
 [<ffffffff810c3c26>] sys_rename+0x16/0x20
 [<ffffffff810022eb>] system_call_fastpath+0x16/0x1b
dbench        D 00000000ffffeed4     0  2977   2974 0x00000000
 ffff88000873fa88 0000000000000082 ffff88000873fac8 ffff88000873ffd8
 ffff880007669710 00000000000122c0 0000000000004000 ffff88000873ffd8
 0000000000004000 00000000000122c0 ffff88007f2e1790 ffff880007669710
Call Trace:
 [<ffffffff8155e58d>] schedule_timeout+0x1ad/0x210
 [<ffffffff8123dbf6>] ? xfs_icsb_disable_counter+0x16/0xa0
 [<ffffffff812445bb>] ? _xfs_trans_bjoin+0x4b/0x60
 [<ffffffff8107b5c9>] ? find_get_page+0x19/0xa0
 [<ffffffff8123dcb6>] ? xfs_icsb_balance_counter_locked+0x36/0xc0
 [<ffffffff8155f4e8>] __down+0x68/0xb0
 [<ffffffff81055b0b>] down+0x3b/0x50
 [<ffffffff8124d59e>] xfs_buf_lock+0x4e/0x70
 [<ffffffff8124ebb3>] _xfs_buf_find+0x133/0x220
 [<ffffffff8124ecfb>] xfs_buf_get+0x5b/0x160
 [<ffffffff8124ee13>] xfs_buf_read+0x13/0xa0
 [<ffffffff81244780>] xfs_trans_read_buf+0x1b0/0x320
 [<ffffffff8122922f>] xfs_read_agi+0x6f/0xf0
 [<ffffffff8122fa86>] xfs_iunlink+0x46/0x160
 [<ffffffff81253d21>] ? xfs_mark_inode_dirty_sync+0x21/0x30
 [<ffffffff81253dcf>] ? xfs_ichgtime+0x9f/0xc0
 [<ffffffff81245677>] xfs_droplink+0x57/0x70
 [<ffffffff8124751a>] xfs_remove+0x28a/0x370
 [<ffffffff81253443>] xfs_vn_unlink+0x43/0x90
 [<ffffffff810c161b>] vfs_unlink+0x8b/0x110
 [<ffffffff810c0e20>] ? lookup_hash+0x30/0x40
 [<ffffffff810c3db3>] do_unlinkat+0x183/0x1c0
 [<ffffffff810bb3f1>] ? sys_newstat+0x31/0x50
 [<ffffffff810c3e01>] sys_unlink+0x11/0x20
 [<ffffffff810022eb>] system_call_fastpath+0x16/0x1b
dbench        D 00000000ffffefa8     0  2978   2974 0x00000000
 ffff880040da7c38 0000000000000082 ffff880000000000 ffff880040da7fd8
 ffff880007668090 00000000000122c0 0000000000004000 ffff880040da7fd8
 0000000000004000 00000000000122c0 ffff88012ff78b90 ffff880007668090
Call Trace:
 [<ffffffff812361f8>] xlog_grant_log_space+0x158/0x3d0
 [<ffffffff8124a0b5>] ? kmem_zone_zalloc+0x35/0x50
 [<ffffffff81034bf0>] ? default_wake_function+0x0/0x10
 [<ffffffff8124410c>] ? xfs_trans_ail_push+0x1c/0x80
 [<ffffffff81236552>] xfs_log_reserve+0xe2/0xf0
 [<ffffffff81243307>] xfs_trans_reserve+0x97/0x200
 [<ffffffff812495e9>] xfs_setattr+0x7e9/0xad0
 [<ffffffff81253766>] xfs_vn_setattr+0x16/0x20
 [<ffffffff810cdb94>] notify_change+0x104/0x2e0
 [<ffffffff810db270>] utimes_common+0xd0/0x1a0
 [<ffffffff810bb64e>] ? sys_newfstat+0x2e/0x40
 [<ffffffff810db416>] do_utimes+0xd6/0xf0
 [<ffffffff810db5ae>] sys_utime+0x1e/0x70
 [<ffffffff810022eb>] system_call_fastpath+0x16/0x1b
dbench        D 00000000ffffefd3     0  2979   2974 0x00000000
 ffff8800072c7ae8 0000000000000082 ffff8800072c7b78 ffff8800072c7fd8
 ffff880007669170 00000000000122c0 0000000000004000 ffff8800072c7fd8
 0000000000004000 00000000000122c0 ffff88012ff785f0 ffff880007669170
Call Trace:
 [<ffffffff812361f8>] xlog_grant_log_space+0x158/0x3d0
 [<ffffffff8124a0b5>] ? kmem_zone_zalloc+0x35/0x50
 [<ffffffff81034bf0>] ? default_wake_function+0x0/0x10
 [<ffffffff8124410c>] ? xfs_trans_ail_push+0x1c/0x80
 [<ffffffff81236552>] xfs_log_reserve+0xe2/0xf0
 [<ffffffff81243307>] xfs_trans_reserve+0x97/0x200
 [<ffffffff8122b637>] ? xfs_iunlock+0x57/0xb0
 [<ffffffff81247920>] xfs_create+0x170/0x5d0
 [<ffffffff810ca6e2>] ? __d_lookup+0xa2/0x140
 [<ffffffff81253202>] xfs_vn_mknod+0xa2/0x1b0
 [<ffffffff8125332b>] xfs_vn_create+0xb/0x10
 [<ffffffff810c1471>] vfs_create+0x81/0xd0
 [<ffffffff810c2915>] do_last+0x515/0x670
 [<ffffffff810c48cd>] do_filp_open+0x21d/0x650
 [<ffffffff810c6871>] ? filldir+0x71/0xd0
 [<ffffffff8103f012>] ? current_fs_time+0x22/0x30
 [<ffffffff810ce96b>] ? alloc_fd+0x4b/0x130
 [<ffffffff810b5d34>] do_sys_open+0x64/0x140
 [<ffffffff810b5bbd>] ? filp_close+0x4d/0x80
 [<ffffffff810b5e3b>] sys_open+0x1b/0x20
 [<ffffffff810022eb>] system_call_fastpath+0x16/0x1b
dbench        D 00000000ffffeed0     0  2980   2974 0x00000000
 ffff88003dd91688 0000000000000082 0000000000000000 ffff88003dd91fd8
 ffff880007abc290 00000000000122c0 0000000000004000 ffff88003dd91fd8
 0000000000004000 00000000000122c0 ffff88007f2d3750 ffff880007abc290
Call Trace:
 [<ffffffff8155e58d>] schedule_timeout+0x1ad/0x210
 [<ffffffff8155f4e8>] __down+0x68/0xb0
 [<ffffffff81055b0b>] down+0x3b/0x50
 [<ffffffff8124d59e>] xfs_buf_lock+0x4e/0x70
 [<ffffffff8124ebb3>] _xfs_buf_find+0x133/0x220
 [<ffffffff8124ecfb>] xfs_buf_get+0x5b/0x160
 [<ffffffff8124ee13>] xfs_buf_read+0x13/0xa0
 [<ffffffff81244780>] xfs_trans_read_buf+0x1b0/0x320
 [<ffffffff8122922f>] xfs_read_agi+0x6f/0xf0
 [<ffffffff812292d9>] xfs_ialloc_read_agi+0x29/0x90
 [<ffffffff8122957b>] xfs_ialloc_ag_select+0x12b/0x260
 [<ffffffff8122abc7>] xfs_dialloc+0x3d7/0x860
 [<ffffffff8124acc8>] ? __xfs_get_blocks+0x1c8/0x210
 [<ffffffff8107b5c9>] ? find_get_page+0x19/0xa0
 [<ffffffff810ddb9e>] ? unmap_underlying_metadata+0xe/0x50
 [<ffffffff8122ef4d>] xfs_ialloc+0x5d/0x690
 [<ffffffff8124a031>] ? kmem_zone_alloc+0x91/0xe0
 [<ffffffff8124570d>] xfs_dir_ialloc+0x7d/0x320
 [<ffffffff81236552>] ? xfs_log_reserve+0xe2/0xf0
 [<ffffffff81247b83>] xfs_create+0x3d3/0x5d0
 [<ffffffff81253202>] xfs_vn_mknod+0xa2/0x1b0
 [<ffffffff8125332b>] xfs_vn_create+0xb/0x10
 [<ffffffff810c1471>] vfs_create+0x81/0xd0
 [<ffffffff810c2915>] do_last+0x515/0x670
 [<ffffffff810c48cd>] do_filp_open+0x21d/0x650
 [<ffffffff810c6871>] ? filldir+0x71/0xd0
 [<ffffffff8103f012>] ? current_fs_time+0x22/0x30
 [<ffffffff810ce96b>] ? alloc_fd+0x4b/0x130
 [<ffffffff810b5d34>] do_sys_open+0x64/0x140
 [<ffffffff810b5bbd>] ? filp_close+0x4d/0x80
 [<ffffffff810b5e3b>] sys_open+0x1b/0x20
 [<ffffffff810022eb>] system_call_fastpath+0x16/0x1b
dbench        D 00000000ffffeed0     0  2981   2974 0x00000000
 ffff88005b79f618 0000000000000086 ffff88005b79f598 ffff88005b79ffd8
 ffff880007abcdd0 00000000000122c0 0000000000004000 ffff88005b79ffd8
 0000000000004000 00000000000122c0 ffff88007f2b7710 ffff880007abcdd0
Call Trace:
 [<ffffffff8155e58d>] schedule_timeout+0x1ad/0x210
 [<ffffffff8122cd44>] ? xfs_iext_bno_to_ext+0x84/0x160
 [<ffffffff8155f4e8>] __down+0x68/0xb0
 [<ffffffff81055b0b>] down+0x3b/0x50
 [<ffffffff8124d59e>] xfs_buf_lock+0x4e/0x70
 [<ffffffff8124ebb3>] _xfs_buf_find+0x133/0x220
 [<ffffffff8124ecfb>] xfs_buf_get+0x5b/0x160
 [<ffffffff81244a40>] xfs_trans_get_buf+0xc0/0xe0
 [<ffffffff8121ac3f>] xfs_da_do_buf+0x3df/0x6d0
 [<ffffffff8121b0c5>] xfs_da_get_buf+0x25/0x30
 [<ffffffff81220926>] ? xfs_dir2_data_init+0x46/0xe0
 [<ffffffff81220926>] xfs_dir2_data_init+0x46/0xe0
 [<ffffffff8121e829>] xfs_dir2_sf_to_block+0xb9/0x5a0
 [<ffffffff8105106a>] ? wake_up_bit+0x2a/0x40
 [<ffffffff81226a78>] xfs_dir2_sf_addname+0x418/0x5c0
 [<ffffffff8122f3fb>] ? xfs_ialloc+0x50b/0x690
 [<ffffffff8121e61c>] xfs_dir_createname+0x14c/0x1a0
 [<ffffffff81247bf9>] xfs_create+0x449/0x5d0
 [<ffffffff81253202>] xfs_vn_mknod+0xa2/0x1b0
 [<ffffffff8125332b>] xfs_vn_create+0xb/0x10
 [<ffffffff810c1471>] vfs_create+0x81/0xd0
 [<ffffffff810c2915>] do_last+0x515/0x670
 [<ffffffff810c48cd>] do_filp_open+0x21d/0x650
 [<ffffffff810c6871>] ? filldir+0x71/0xd0
 [<ffffffff8103f012>] ? current_fs_time+0x22/0x30
 [<ffffffff810ce96b>] ? alloc_fd+0x4b/0x130
 [<ffffffff810b5d34>] do_sys_open+0x64/0x140
 [<ffffffff810b5bbd>] ? filp_close+0x4d/0x80
 [<ffffffff810b5e3b>] sys_open+0x1b/0x20
 [<ffffffff810022eb>] system_call_fastpath+0x16/0x1b
dbench        D 00000000ffffefbf     0  2982   2974 0x00000000
 ffff88005b7f9c38 0000000000000082 ffff880000000000 ffff88005b7f9fd8
 ffff880007698150 00000000000122c0 0000000000004000 ffff88005b7f9fd8
 0000000000004000 00000000000122c0 ffff88012ff79130 ffff880007698150
Call Trace:
 [<ffffffff812361f8>] xlog_grant_log_space+0x158/0x3d0
 [<ffffffff8124a0b5>] ? kmem_zone_zalloc+0x35/0x50
 [<ffffffff81034bf0>] ? default_wake_function+0x0/0x10
 [<ffffffff8124410c>] ? xfs_trans_ail_push+0x1c/0x80
 [<ffffffff81236552>] xfs_log_reserve+0xe2/0xf0
 [<ffffffff81243307>] xfs_trans_reserve+0x97/0x200
 [<ffffffff812495e9>] xfs_setattr+0x7e9/0xad0
 [<ffffffff81253766>] xfs_vn_setattr+0x16/0x20
 [<ffffffff810cdb94>] notify_change+0x104/0x2e0
 [<ffffffff810db270>] utimes_common+0xd0/0x1a0
 [<ffffffff810bb64e>] ? sys_newfstat+0x2e/0x40
 [<ffffffff810db416>] do_utimes+0xd6/0xf0
 [<ffffffff810db5ae>] sys_utime+0x1e/0x70
 [<ffffffff810022eb>] system_call_fastpath+0x16/0x1b

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
