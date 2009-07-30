Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6UIuCDJ095198 for <xfs@oss.sgi.com>; Thu, 30 Jul 2009 13:56:12 -0500
Received: from cobra.newdream.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A381339765A
	for <xfs@oss.sgi.com>; Thu, 30 Jul 2009 11:56:58 -0700 (PDT)
Received: from cobra.newdream.net (cobra.newdream.net [66.33.216.30]) by
	cuda.sgi.com with ESMTP id BroyR3bbypc8OExE for
	<xfs@oss.sgi.com>; Thu, 30 Jul 2009 11:56:58 -0700 (PDT)
Date: Thu, 30 Jul 2009 11:56:58 -0700 (PDT)
From: Sage Weil <sage@newdream.net>
Subject: Re: [PATCH 0/9] fixes for memory allocator recursions into the
	filesystem
In-Reply-To: <20090718221452.594956000@bombadil.infradead.org>
Message-ID: <Pine.LNX.4.64.0907301143510.14757@cobra.newdream.net>
References: <20090718221452.594956000@bombadil.infradead.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Hi Christoph,

I just noticed another warning (the same as the second one I sent 
before) with your patchset applied to 2.6.30.  This is the unresolved 
iolock issue you mentioned?  Just FYI.

sage


[ 4328.303413] =================================
[ 4328.305294] [ INFO: inconsistent lock state ]
[ 4328.305294] 2.6.30 #24
[ 4328.305294] ---------------------------------
[ 4328.305294] inconsistent {RECLAIM_FS-ON-W} -> {IN-RECLAIM_FS-W} usage.
[ 4328.305294] kswapd0/290 [HC0[0]:SC0[0]:HE1:SE1] takes:
[ 4328.305294]  (&(&ip->i_iolock)->mr_lock){++++?+}, at: [<ffffffff803afe7e>] xfs_ilock+0x27/0x79
[ 4328.305294] {RECLAIM_FS-ON-W} state was registered at:
[ 4328.305294]   [<ffffffff8025c43b>] mark_held_locks+0x4d/0x6b
[ 4328.305294]   [<ffffffff8025c501>] lockdep_trace_alloc+0xa8/0xc3
[ 4328.305294]   [<ffffffff80287fba>] __alloc_pages_internal+0x6d/0x457
[ 4328.305294]   [<ffffffff802a8348>] alloc_pages_current+0xbe/0xc6
[ 4328.305294]   [<ffffffff80281f85>] grab_cache_page_write_begin+0x5e/0xa2
[ 4328.305294]   [<ffffffff802d300d>] block_write_begin+0x3d/0xcf
[ 4328.305294]   [<ffffffff803cbf84>] xfs_vm_write_begin+0x25/0x27
[ 4328.305294]   [<ffffffff80282926>] generic_file_buffered_write+0x139/0x2ff
[ 4328.305294]   [<ffffffff803d207e>] xfs_write+0x4de/0x717
[ 4328.305294]   [<ffffffff803cea45>] xfs_file_aio_write+0x61/0x63
[ 4328.305294]   [<ffffffff802b0d7a>] do_sync_write+0xe7/0x12d
[ 4328.305294]   [<ffffffff802b172f>] vfs_write+0xae/0x137
[ 4328.305294]   [<ffffffff802b187c>] sys_write+0x47/0x6e
[ 4328.305294]   [<ffffffff8020bb2b>] system_call_fastpath+0x16/0x1b
[ 4328.305294]   [<ffffffffffffffff>] 0xffffffffffffffff
[ 4328.305294] irq event stamp: 8357751
[ 4328.305294] hardirqs last  enabled at (8357751): [<ffffffff8062d0ec>] _spin_unlock_irqrestore+0x3f/0x68
[ 4328.450537] hardirqs last disabled at (8357750): [<ffffffff8062d440>] _spin_lock_irqsave+0x19/0x7f
[ 4328.450537] softirqs last  enabled at (8357742): [<ffffffff80240910>] __do_softirq+0x1d9/0x1e5
[ 4328.450537] softirqs last disabled at (8357721): [<ffffffff8020ccbc>] call_softirq+0x1c/0x28
[ 4328.450537] 
[ 4328.450537] other info that might help us debug this:
[ 4328.450537] 2 locks held by kswapd0/290:
[ 4328.450537]  #0:  (shrinker_rwsem){++++..}, at: [<ffffffff8028db78>] shrink_slab+0x38/0x188
[ 4328.450537]  #1:  (iprune_mutex){+.+.-.}, at: [<ffffffff802c3f97>] shrink_icache_memory+0x4b/0x23b
[ 4328.514337] 
[ 4328.514337] stack backtrace:
[ 4328.518349] Pid: 290, comm: kswapd0 Not tainted 2.6.30 #24
[ 4328.522330] Call Trace:
[ 4328.522330]  [<ffffffff8025bea5>] print_usage_bug+0x1b2/0x1c3
[ 4328.522330]  [<ffffffff8025ca86>] ? check_usage_forwards+0x0/0x9c
[ 4328.522330]  [<ffffffff8025c1b0>] mark_lock+0x2fa/0x538
[ 4328.522330]  [<ffffffff8025db79>] __lock_acquire+0x80d/0x16a9
[ 4328.522330]  [<ffffffff8025eb0b>] lock_acquire+0xf6/0x11a
[ 4328.522330]  [<ffffffff803afe7e>] ? xfs_ilock+0x27/0x79
[ 4328.522330]  [<ffffffff80252b5d>] down_write_nested+0x46/0x7a
[ 4328.522330]  [<ffffffff803afe7e>] ? xfs_ilock+0x27/0x79
[ 4328.522330]  [<ffffffff803afe7e>] xfs_ilock+0x27/0x79
[ 4328.522330]  [<ffffffff803aff8c>] xfs_ireclaim+0x8d/0x153
[ 4328.522330]  [<ffffffff803d47c8>] xfs_reclaim_inode+0x131/0x13f
[ 4328.522330]  [<ffffffff803c6ae4>] xfs_reclaim+0x98/0xa9
[ 4328.522330]  [<ffffffff803d2e86>] xfs_fs_destroy_inode+0x37/0x57
[ 4328.522330]  [<ffffffff802c3e3f>] destroy_inode+0x3a/0x4f
[ 4328.522330]  [<ffffffff802c3f18>] dispose_list+0xc4/0xf8
[ 4328.522330]  [<ffffffff802c4151>] shrink_icache_memory+0x205/0x23b
[ 4328.522330]  [<ffffffff8028dc1f>] shrink_slab+0xdf/0x188
[ 4328.522330]  [<ffffffff8028e475>] kswapd+0x4fc/0x6b2
[ 4328.522330]  [<ffffffff80232d48>] ? finish_task_switch+0x3b/0xdc
[ 4328.522330]  [<ffffffff8028bbb4>] ? isolate_pages_global+0x0/0x208
[ 4328.522330]  [<ffffffff8024fdbc>] ? autoremove_wake_function+0x0/0x38
[ 4328.522330]  [<ffffffff8025c70c>] ? trace_hardirqs_on+0xd/0xf
[ 4328.522330]  [<ffffffff8028df79>] ? kswapd+0x0/0x6b2
[ 4328.522330]  [<ffffffff8028df79>] ? kswapd+0x0/0x6b2
[ 4328.522330]  [<ffffffff8024f97d>] kthread+0x56/0x83
[ 4328.522330]  [<ffffffff8020cbba>] child_rip+0xa/0x20
[ 4328.522330]  [<ffffffff8020c580>] ? restore_args+0x0/0x30
[ 4328.522330]  [<ffffffff8062a00f>] ? __schedule+0xf9/0x948
[ 4328.522330]  [<ffffffff8024f927>] ? kthread+0x0/0x83
[ 4328.522330]  [<ffffffff8020cbb0>] ? child_rip+0x0/0x20


On Sat, 18 Jul 2009, Christoph Hellwig wrote:

> lockdep has recently start tracking if a lock is used in reclaim context
> and if so warns if we do allocations without the NOFS flag inside it.
> 
> This patch series fixes the easy targers involving the i_lock by switching
> various allocations to the NOFS variant, or in case of the growfs code
> moving the allocation out of the lock.
> 
> We still have some more issues that involve the iolock, but I think we
> can simply get rid of the iolock in the reclaim path, but I'll send that
> our for a separate discussion.
> 
> Sage, this should fix the two reports you've sent a while ago.
> 
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
