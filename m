Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C1C4529DF7
	for <xfs@oss.sgi.com>; Thu, 11 Dec 2014 09:53:02 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5148EAC001
	for <xfs@oss.sgi.com>; Thu, 11 Dec 2014 07:52:58 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id BZRIKBg0VHathNx6 for <xfs@oss.sgi.com>;
	Thu, 11 Dec 2014 07:52:57 -0800 (PST)
Message-ID: <5489BDD7.10602@sandeen.net>
Date: Thu, 11 Dec 2014 09:52:55 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: easily reproducible filesystem crash on rebuilding array
References: <20141211123936.1f3d713d@harpe.intellique.com>
In-Reply-To: <20141211123936.1f3d713d@harpe.intellique.com>
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
To: Emmanuel Florac <eflorac@intellique.com>, xfs@oss.sgi.com

On 12/11/14 5:39 AM, Emmanuel Florac wrote:
> 
> Here's the setup: hardware RAID controller (Adaptec 7xx5 series, latest
> firmware), RAID-6 array (problem occured with different RAID width,
> sizes, and disk configuration), and different kernels from 3.2.x to
> 3.16.x.
> 
> What happens: while the array is rebuilding, simultaneously reading and
> writing is a sure way to break the filesystem and at times, corrupt
> data.
> 
> If the array is NOT rebuilding, nothing ever happens. When using the
> array in read-only mode while it rebuilds, nothing ever happens.
> However, while the array is rebuilding, relatively heavy IO almost
> certainly brings up something as follows:
> 
> Dec 10 17:00:56 TEST-ADAPTEC kernel: <1<<<<<<1<1<1>XFS (dm-0): Unmount and run xfs_repair<<<<<<<1<1<1>XFS (dm-0): Unmount and run xfs_repai<<<<<<<1<1<1>XFS (dm-0): Unmount and <<<<1<<1<1<1>XFS (dm-0): Unmount and run xfs_repair
> Dec 10 17:00:56 TEST-ADAPTEC kernel: <1<<<<<<1<1<1>XFS (dm-0): Unmount and run xf<<<<<<<1<1<1>XFS (dm-0): Unmount and run xfs_<<<<<<<1<1<1>XFS (dm-0): Unmount and run xfs<<<<<<<1<1<1>XFS (dm-0): Unmount and run<<<<<<<1<1><1>XFS (dm-0): Unmount and run<<<<<<<1><1<1>XFS (dm-0): Unmount and<<<<<<<1<1<1>XFS (dm-0): Unmount<<<<<<<1<1<1>XFS (dm-0): Unmount and run xfs_repair
> Dec 10 17:00:56 TEST-ADAPTEC kernel: <1<<<1<1<1>XFS (dm-0): Unmount and run xfs_<<<<<<<1<1<1>XFS (dm-0): Unmount and run xfs_repair
> Dec 10 17:00:56 TEST-ADAPTEC kernel: <1<<<1<1<1>XF<1>XFS (dm-0): Unmount and run xfs_repair
> Dec 10 17:00:58 TEST-ADAPTEC kernel: <1<<<<<<1<1>XFS (dm-0): Unmount and run xf<<<<1<1>XFS (dm-0): Unmount and run xfs_repa<<<<<<<1<1><1>XFS (dm-0): Unmount and run xfs_re<<<<<<<1<1<1>XFS (dm-0): Unmount and run xfs_r<<<<<<<1<1><1>XFS (dm-0): Unmount and run xfs_repair
> Dec 10 17:01:01 TEST-ADAPTEC kernel: <<<<<<<1<1<1>XFS (dm-0): Unmount and run xfs_repair<<<<<<<1<1<1>XFS (dm-0): Unmount and run xfs_repair
> Dec 10 17:01:01 TEST-ADAPTEC kernel: <<<<<<<1<1<1>XFS (dm-0): Unmount and run<<<<<<<1<1<1>XFS (dm-0): Unmount and run xfs_repair

wow, that's a mess...

> Dec 10 17:01:02 TEST-ADAPTEC kernel: CPU: 6 PID: 16818 Comm: cp Tainted: G           O  3.16.7-storiq64-opteron #1
> Dec 10 17:01:02 TEST-ADAPTEC kernel: Hardware name: Supermicro H8SGL/H8SGL, BIOS 3.0a       05/07/2013
> Dec 10 17:01:02 TEST-ADAPTEC kernel:  0000000000000000 0000000000000001 ffffffff814ca287 ffff88040404a4f8
> Dec 10 17:01:02 TEST-ADAPTEC kernel:  ffffffff81213f7d ffffffff81230203 ffff880200000001 ffff8802009ce703
> Dec 10 17:01:02 TEST-ADAPTEC kernel:  ffff8802aa193560 0000000000000001 0000000000000002 0000000000000000
> Dec 10 17:01:02 TEST-ADAPTEC kernel: Call Trace:
> Dec 10 17:01:02 TEST-ADAPTEC kernel:  [<ffffffff814ca287>] ? dump_stack+0x41/0x51
> Dec 10 17:01:02 TEST-ADAPTEC kernel:  [<ffffffff81213f7d>] ? xfs_alloc_fixup_trees+0x2dd/0x390

the actual WANT_CORRUPTED_GOTO isn't shown, but apparently xfs encountered
allocation btrees in a bad state.

Given that this only happens when your raid array is under duress, I'd lay
odds on it being a storage problem, not a filesystem problem.

-Eric

> Dec 10 17:01:02 TEST-ADAPTEC kernel:  [<ffffffff81230203>] ? xfs_btree_get_rec+0x53/0x90
> Dec 10 17:01:02 TEST-ADAPTEC kernel:  [<ffffffff812168a5>] ? xfs_alloc_ag_vextent_near+0x8a5/0xae0
> Dec 10 17:01:02 TEST-ADAPTEC kernel:  [<ffffffff81216ba5>] ? xfs_alloc_ag_vextent+0xc5/0x100
> Dec 10 17:01:02 TEST-ADAPTEC kernel:  [<ffffffff812178c1>] ? xfs_alloc_vextent+0x441/0x5f0
> Dec 10 17:01:02 TEST-ADAPTEC kernel:  [<ffffffff8121f573>] ? xfs_bmap_btalloc_nullfb+0x73/0xe0
> Dec 10 17:01:02 TEST-ADAPTEC kernel:  [<ffffffff81226aa1>] ? xfs_bmap_btalloc+0x481/0x720
> Dec 10 17:01:02 TEST-ADAPTEC kernel:  [<ffffffff812277ad>] ? xfs_bmapi_write+0x55d/0x9f0
> Dec 10 17:01:02 TEST-ADAPTEC kernel:  [<ffffffff8122a857>] ? xfs_btree_read_buf_block.constprop.28+0x87/0xc0
> Dec 10 17:01:02 TEST-ADAPTEC kernel:  [<ffffffff81231976>] ? xfs_da_grow_inode_int+0xd6/0x360
> Dec 10 17:01:02 TEST-ADAPTEC kernel:  [<ffffffff8109669d>] ? up+0xd/0x40
> Dec 10 17:01:02 TEST-ADAPTEC kernel:  [<ffffffff811fba30>] ? xfs_buf_unlock+0x10/0x60
> Dec 10 17:01:02 TEST-ADAPTEC kernel:  [<ffffffff811fb49e>] ? xfs_buf_rele+0x4e/0x170
> Dec 10 17:01:02 TEST-ADAPTEC kernel:  [<ffffffff8112d246>] ? cache_alloc_refill+0x96/0x2d0
> Dec 10 17:01:02 TEST-ADAPTEC kernel:  [<ffffffff8124b32f>] ? xfs_iread+0x11f/0x410
> Dec 10 17:01:02 TEST-ADAPTEC kernel:  [<ffffffff8123508f>] ? xfs_dir2_grow_inode+0x6f/0x130
> Dec 10 17:01:02 TEST-ADAPTEC kernel:  [<ffffffff812372b9>] ? xfs_dir2_sf_to_block+0xb9/0x5b0
> Dec 10 17:01:02 TEST-ADAPTEC kernel:  [<ffffffff812137be>] ? kmem_zone_alloc+0x6e/0xf0
> Dec 10 17:01:02 TEST-ADAPTEC kernel:  [<ffffffff8114ee0a>] ? unlock_new_inode+0x3a/0x60
> Dec 10 17:01:02 TEST-ADAPTEC kernel:  [<ffffffff8124544b>] ? xfs_ialloc+0x29b/0x530
> Dec 10 17:01:02 TEST-ADAPTEC kernel:  [<ffffffff8123edc3>] ? xfs_dir2_sf_addname+0x113/0x5d0
> Dec 10 17:01:02 TEST-ADAPTEC kernel:  [<ffffffff81235938>] ? xfs_dir_createname+0x168/0x1a0
> Dec 10 17:01:02 TEST-ADAPTEC kernel:  [<ffffffff81245f87>] ? xfs_create+0x547/0x710
> Dec 10 17:01:02 TEST-ADAPTEC kernel:  [<ffffffff8120981c>] ? xfs_generic_create+0xdc/0x250
> Dec 10 17:01:02 TEST-ADAPTEC kernel:  [<ffffffff811445c1>] ? vfs_create+0x71/0xc0
> Dec 10 17:01:02 TEST-ADAPTEC kernel:  [<ffffffff81144d45>] ? do_last.isra.62+0x735/0xd00
> Dec 10 17:01:02 TEST-ADAPTEC kernel:  [<ffffffff811415d1>] ? link_path_walk+0x61/0x7e0
> Dec 10 17:01:02 TEST-ADAPTEC kernel:  [<ffffffff811453de>] ? path_openat+0xce/0x5f0
> Dec 10 17:01:02 TEST-ADAPTEC kernel:  [<ffffffff81145a8b>] ? user_path_at_empty+0x6b/0xb0
> Dec 10 17:01:02 TEST-ADAPTEC kernel:  [<ffffffff81145b97>] ? do_filp_open+0x47/0xb0
> Dec 10 17:01:02 TEST-ADAPTEC kernel:  [<ffffffff811519da>] ? __alloc_fd+0x3a/0x100
> Dec 10 17:01:02 TEST-ADAPTEC kernel:  [<ffffffff81135bc0>] ? do_sys_open+0x140/0x230
> Dec 10 17:01:02 TEST-ADAPTEC kernel:  [<ffffffff814d08a9>] ? system_call_fastpath+0x16/0x1b
> Dec 10 17:01:02 TEST-ADAPTEC kernel: CPU: 6 PID: 16818 Comm: cp Tainted: G           O  3.16.7-storiq64-opteron #1
> Dec 10 17:01:02 TEST-ADAPTEC kernel: Hardware name: Supermicro H8SGL/H8SGL, BIOS 3.0a       05/07/2013
> Dec 10 17:01:02 TEST-ADAPTEC kernel:  0000000000000000 000000000000000c ffffffff814ca287 ffff88040cde45c8
> Dec 10 17:01:02 TEST-ADAPTEC kernel:  ffffffff81212fdf ffff8803201b1000 ffff8802aa193c68 ffff88040be30000
> Dec 10 17:01:02 TEST-ADAPTEC kernel:  ffffffff81245d8b 0000000000000023 ffff8802aa193ba8 ffff8802aa193ba4
> Dec 10 17:01:02 TEST-ADAPTEC kernel: Call Trace:
> Dec 10 17:01:02 TEST-ADAPTEC kernel:  [<ffffffff814ca287>] ? dump_stack+0x41/0x51
> Dec 10 17:01:02 TEST-ADAPTEC kernel:  [<ffffffff81212fdf>] ? xfs_trans_cancel+0xef/0x110
> Dec 10 17:01:02 TEST-ADAPTEC kernel:  [<ffffffff81245d8b>] ? xfs_create+0x34b/0x710
> Dec 10 17:01:02 TEST-ADAPTEC kernel:  [<ffffffff8120981c>] ? xfs_generic_create+0xdc/0x250
> Dec 10 17:01:02 TEST-ADAPTEC kernel:  [<ffffffff811445c1>] ? vfs_create+0x71/0xc0
> Dec 10 17:01:02 TEST-ADAPTEC kernel:  [<ffffffff81144d45>] ? do_last.isra.62+0x735/0xd00
> Dec 10 17:01:02 TEST-ADAPTEC kernel:  [<ffffffff811415d1>] ? link_path_walk+0x61/0x7e0
> Dec 10 17:01:02 TEST-ADAPTEC kernel:  [<ffffffff811453de>] ? path_openat+0xce/0x5f0
> Dec 10 17:01:02 TEST-ADAPTEC kernel:  [<ffffffff81145a8b>] ? user_path_at_empty+0x6b/0xb0
> Dec 10 17:01:02 TEST-ADAPTEC kernel:  [<ffffffff81145b97>] ? do_filp_open+0x47/0xb0
> Dec 10 17:01:02 TEST-ADAPTEC kernel:  [<ffffffff811519da>] ? __alloc_fd+0x3a/0x100
> Dec 10 17:01:02 TEST-ADAPTEC kernel:  [<ffffffff81135bc0>] ? do_sys_open+0x140/0x230
> Dec 10 17:01:02 TEST-ADAPTEC kernel:  [<ffffffff814d08a9>] ? system_call_fastpath+0x16/0x1b
> Dec 10 17:01:02 TEST-ADAPTEC kernel: XFS (dm-0): xfs_do_force_shutdown(0x8) called from line 959 of file fs/xfs/xfs_trans.c.  Return address = 0xffffffff81212ff8
> Dec 10 17:01:25 TEST-ADAPTEC kernel: XFS (dm-0): xfs_log_force: error 5 returned.
> Dec 10 17:01:55 TEST-ADAPTEC kernel: XFS (dm-0): xfs_log_force: error 5 returned.
> Dec 10 17:02:55 TEST-ADAPTEC last message repeated 2 times
> 
> Any idea is welcome...
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
