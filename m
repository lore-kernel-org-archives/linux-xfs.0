Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBHI2lhO250102 for <xfs@oss.sgi.com>; Fri, 17 Dec 2010 12:02:48 -0600
Received: from mail-wy0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A0DA614611B7
	for <xfs@oss.sgi.com>; Fri, 17 Dec 2010 10:04:41 -0800 (PST)
Received: from mail-wy0-f181.google.com (mail-wy0-f181.google.com
	[74.125.82.181]) by cuda.sgi.com with ESMTP id 7OHA2bcU8zE2CoMT
	for <xfs@oss.sgi.com>; Fri, 17 Dec 2010 10:04:41 -0800 (PST)
Received: by wyf22 with SMTP id 22so924888wyf.26
	for <xfs@oss.sgi.com>; Fri, 17 Dec 2010 10:04:40 -0800 (PST)
MIME-Version: 1.0
Date: Sat, 18 Dec 2010 05:04:40 +1100
Message-ID: <AANLkTi=LrU2CsC-VZmJ5M9U7eJpjqfAv8UgaEYv=Sg01@mail.gmail.com>
Subject: xfs_efi_item slab leak
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
To: xfs@oss.sgi.com

After running xfstests and then unmounting and rmmodding xfs, I get this bug

[ 3473.194517] =============================================================================
[ 3473.194697] BUG xfs_efi_item: Objects remaining on kmem_cache_close()
[ 3473.194793] -----------------------------------------------------------------------------
[ 3473.194794]
[ 3473.195056] INFO: Slab 0xffffea0006ad5e00 objects=35 used=2
fp=0xffff8801e8640e80 flags=0xc000000000004080
[ 3473.195201] Pid: 22011, comm: rmmod Not tainted 2.6.37-rc6+ #116
[ 3473.195201] Call Trace:
[ 3473.195201]  [<ffffffff8110bcf1>] slab_err+0x91/0xa0
[ 3473.195201]  [<ffffffff8110f088>] ? __slab_alloc+0x138/0x480
[ 3473.195201]  [<ffffffff8108081d>] ? trace_hardirqs_off+0xd/0x10
[ 3473.195201]  [<ffffffff811112a4>] ? kmem_cache_destroy+0x154/0x3e0
[ 3473.195201]  [<ffffffff8108081d>] ? trace_hardirqs_off+0xd/0x10
[ 3473.195201]  [<ffffffff811105a4>] ? __kmalloc+0x104/0x220
[ 3473.195201]  [<ffffffff811112c7>] kmem_cache_destroy+0x177/0x3e0
[ 3473.195201]  [<ffffffffa0086e47>] xfs_destroy_zones+0x37/0x100 [xfs]
[ 3473.195201]  [<ffffffffa0088f88>] exit_xfs_fs+0x33/0x3d [xfs]
[ 3473.195201]  [<ffffffff8109060a>] sys_delete_module+0x17a/0x270
[ 3473.195201]  [<ffffffff8160340f>] ? lockdep_sys_exit_thunk+0x35/0x67
[ 3473.195201]  [<ffffffff810030bb>] system_call_fastpath+0x16/0x1b
[ 3473.195201] INFO: Object 0xffff8801e8640910 @offset=2320
[ 3473.195201] INFO: Allocated in kmem_zone_alloc+0x8c/0xd0 [xfs]
age=2263917 cpu=15 pid=4514
[ 3473.195201] INFO: Freed in xfs_efi_item_free+0x19/0x30 [xfs]
age=2263918 cpu=15 pid=4514
[ 3473.195201] INFO: Object 0xffff8801e86427e0 @offset=10208
[ 3473.195201] INFO: Allocated in kmem_zone_alloc+0x8c/0xd0 [xfs]
age=2103034 cpu=15 pid=22329
[ 3473.195201] INFO: Freed in xfs_efi_item_free+0x19/0x30 [xfs]
age=2103034 cpu=15 pid=22329
[ 3473.197616] SLUB xfs_efi_item: kmem_cache_destroy called for cache
that still has objects.
[ 3473.197794] Pid: 22011, comm: rmmod Not tainted 2.6.37-rc6+ #116
[ 3473.197892] Call Trace:
[ 3473.197980]  [<ffffffff811114a7>] kmem_cache_destroy+0x357/0x3e0
[ 3473.198120]  [<ffffffffa0086e47>] xfs_destroy_zones+0x37/0x100 [xfs]
[ 3473.198240]  [<ffffffffa0088f88>] exit_xfs_fs+0x33/0x3d [xfs]
[ 3473.198337]  [<ffffffff8109060a>] sys_delete_module+0x17a/0x270
[ 3473.198435]  [<ffffffff8160340f>] ? lockdep_sys_exit_thunk+0x35/0x67
[ 3473.198534]  [<ffffffff810030bb>] system_call_fastpath+0x16/0x1b

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
