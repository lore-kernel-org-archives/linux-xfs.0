Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:34697 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934344AbdDGQ7O (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 7 Apr 2017 12:59:14 -0400
Date: Fri, 7 Apr 2017 09:58:43 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: lockdep warning on 4.11.0-rc5 kernel
Message-ID: <20170407165843.GI4864@birch.djwong.org>
References: <20170405205211.GB4475@redhat.com>
 <20170407151009.GA55851@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170407151009.GA55851@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, linux-xfs@vger.kernel.org, hch@infradead.org

On Fri, Apr 07, 2017 at 11:10:09AM -0400, Brian Foster wrote:
> On Wed, Apr 05, 2017 at 04:52:11PM -0400, Vivek Goyal wrote:
> > Hi,
> > 
> > I am running 4.11.0-rc5 kernel and did a kernel build and noticed
> > following lockdep warning on console. Have not analyzed it. Lots of
> > xfs in backtrace, so sending it to xfs mailing list.
> > 
> 
> Darrick pointed out on irc yesterday that this is likely due to the
> lock_inode() call in chmod_common(). I was confused as to where the
> iolock came into play here, but apparently we now reuse the core
> inode->i_rwsem for that.
> 
> In any event, I was playing around with this and reproduce pretty easily
> by populating an fs with a bunch files with speculative preallocation
> and then generating some memory pressure. I reproduce with the following
> stack, however:
> 
> [  434.220605] =================================
> [  434.222286] [ INFO: inconsistent lock state ]
> [  434.224092] 4.11.0-rc4+ #36 Tainted: G           OE  
> [  434.225839] ---------------------------------
> [  434.227587] inconsistent {RECLAIM_FS-ON-W} -> {IN-RECLAIM_FS-W}
> usage.
> [  434.229995] kswapd0/59 [HC0[0]:SC0[0]:HE1:SE1] takes:
> [  434.231851]  (&sb->s_type->i_mutex_key#17){+.+.?.}, at:
> [<ffffffffc078e0aa>] xfs_ilock+0x20a/0x300 [xfs]
> [  434.235473] {RECLAIM_FS-ON-W} state was registered at:
> [  434.237427]   mark_held_locks+0x76/0xa0
> [  434.238840]   lockdep_trace_alloc+0x7d/0xe0
> [  434.240362]   kmem_cache_alloc+0x2f/0x2d0
> [  434.241871]   kmem_zone_alloc+0x81/0x120 [xfs]
> [  434.243559]   xfs_trans_alloc+0x6c/0x130 [xfs]
> [  434.245233]   xfs_vn_update_time+0x75/0x230 [xfs]
> [  434.247031]   file_update_time+0xbc/0x110
> [  434.248593]   xfs_file_aio_write_checks+0x19b/0x1c0 [xfs]
> [  434.250762]   xfs_file_buffered_aio_write+0x75/0x350 [xfs]
> [  434.252978]   xfs_file_write_iter+0x103/0x150 [xfs]
> [  434.254935]   __vfs_write+0xe8/0x160
> [  434.256325]   vfs_write+0xcb/0x1f0
> [  434.257625]   SyS_pwrite64+0x98/0xc0
> [  434.258963]   entry_SYSCALL_64_fastpath+0x1f/0xc2
> 
> ... so this isn't just a chmod thing. OTOH, I think we agree that this
> is not a real deadlock vector because the iolock is taken in the
> destroy_inode() path and so there should be no other reference to the
> inode.
> 
> That aside, the IOLOCK_EXCL was added to xfs_inactive() in commit
> a36b926180 ("xfs: pull up iolock from xfs_free_eofblocks()") purely to
> honor the cleaner call semantics that patch defined for
> xfs_free_eofblocks(). We could probably either drop the iolock from here
> (though we would then have to kill the assert in xfs_free_eofblocks()),
> or use something like the diff below that quiets the lockdep splat for
> me. Thoughts?

Well... the inode is inactive, which means there won't be any io to
protect ourselves against, so we don't need to take the iolock, right?
Why not remove the iolock grabbing and either change the iolock assert
in _free_eofblocks to detect that we're coming from _inactive and not
blow the assert, or just make a __xfs_free_eofblocks that skips the
assert.

(Or I guess teach lockdep better?  I'd rather just get rid of a lock
grab if we can feasibly do it...)

--D

> 
> Brian
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 7605d83..eb80d31 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -1908,7 +1908,11 @@ xfs_inactive(
>  		 * broken free space accounting.
>  		 */
>  		if (xfs_can_free_eofblocks(ip, true)) {
> -			xfs_ilock(ip, XFS_IOLOCK_EXCL);
> +			/* trylock to quiet lockdep, iolock should be free */
> +			if (!xfs_ilock_nowait(ip, XFS_IOLOCK_EXCL)) {
> +				ASSERT(0);
> +				xfs_ilock(ip, XFS_IOLOCK_EXCL);
> +			}
>  			xfs_free_eofblocks(ip);
>  			xfs_iunlock(ip, XFS_IOLOCK_EXCL);
>  		}
> 
> > Thanks
> > Vivek
> > 
> > login: [ 4931.174758] 
> > [ 4931.175065] =================================
> > [ 4931.175731] [ INFO: inconsistent lock state ]
> > [ 4931.176365] 4.11.0-rc5+ #87 Not tainted
> > [ 4931.176920] ---------------------------------
> > [ 4931.177537] inconsistent {RECLAIM_FS-ON-W} -> {IN-RECLAIM_FS-W} usage.
> > [ 4931.178463] kswapd0/128 [HC0[0]:SC0[0]:HE1:SE1] takes:
> > [ 4931.179198]  (&sb->s_type->i_mutex_key#12){++++?+}, at: [<ffffffffa01fcb0a>] xfs_ilock+0x13a/0x210 [xfs]
> > [ 4931.180584] {RECLAIM_FS-ON-W} state was registered at:
> > [ 4931.181320]   mark_held_locks+0x6f/0xa0
> > [ 4931.181878]   lockdep_trace_alloc+0x7d/0xe0
> > [ 4931.182474]   kmem_cache_alloc+0x2f/0x2a0
> > [ 4931.183083]   kmem_zone_alloc+0x81/0x120 [xfs]
> > [ 4931.183739]   xfs_trans_alloc+0x6c/0x130 [xfs]
> > [ 4931.184407]   xfs_setattr_nonsize+0x239/0x560 [xfs]
> > [ 4931.185135]   xfs_vn_setattr_nonsize+0x59/0x150 [xfs]
> > [ 4931.185890]   xfs_vn_setattr+0x22/0x70 [xfs]
> > [ 4931.186503]   notify_change+0x2ee/0x440
> > [ 4931.187058]   chmod_common+0xc5/0x150
> > [ 4931.187582]   SyS_fchmod+0x53/0x90
> > [ 4931.188077]   do_syscall_64+0x6c/0x1f0
> > [ 4931.188616]   return_from_SYSCALL_64+0x0/0x7a
> > [ 4931.189238] irq event stamp: 397343
> > [ 4931.189739] hardirqs last  enabled at (397343): [<ffffffff81135cca>] __call_rcu+0x1fa/0x340
> > [ 4931.190909] hardirqs last disabled at (397342): [<ffffffff81135b21>] __call_rcu+0x51/0x340
> > [ 4931.192070] softirqs last  enabled at (397192): [<ffffffff818fb86d>] __do_softirq+0x38d/0x4c3
> > [ 4931.193263] softirqs last disabled at (397185): [<ffffffff810bae27>] irq_exit+0xf7/0x100
> > [ 4931.194397] 
> > [ 4931.194397] other info that might help us debug this:
> > [ 4931.195318]  Possible unsafe locking scenario:
> > [ 4931.195318] 
> > [ 4931.196155]        CPU0
> > [ 4931.196511]        ----
> > [ 4931.196874]   lock(&sb->s_type->i_mutex_key#12);
> > [ 4931.197526]   <Interrupt>
> > [ 4931.197912]     lock(&sb->s_type->i_mutex_key#12);
> > [ 4931.198591] 
> > [ 4931.198591]  *** DEADLOCK ***
> > [ 4931.198591] 
> > [ 4931.199429] 2 locks held by kswapd0/128:
> > [ 4931.199990]  #0:  (shrinker_rwsem){++++..}, at: [<ffffffff8121a16e>] shrink_slab.part.46+0x5e/0x600
> > [ 4931.201261]  #1:  (&type->s_umount_key#48){++++++}, at: [<ffffffff812aa54b>] trylock_super+0x1b/0x50
> > [ 4931.202832] 
> > [ 4931.202832] stack backtrace:
> > [ 4931.203878] CPU: 2 PID: 128 Comm: kswapd0 Not tainted 4.11.0-rc5+ #87
> > [ 4931.204998] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.8.2-20150714_191134- 04/01/2014
> > [ 4931.206533] Call Trace:
> > [ 4931.207114]  dump_stack+0x86/0xc3
> > [ 4931.207807]  print_usage_bug+0x1d0/0x1e0
> > [ 4931.208573]  mark_lock+0x559/0x5c0
> > [ 4931.209274]  ? print_shortest_lock_dependencies+0x1a0/0x1a0
> > [ 4931.210274]  __lock_acquire+0x6ce/0x13c0
> > [ 4931.211049]  lock_acquire+0xe3/0x1d0
> > [ 4931.211776]  ? lock_acquire+0xe3/0x1d0
> > [ 4931.212556]  ? xfs_ilock+0x13a/0x210 [xfs]
> > [ 4931.213373]  ? xfs_inactive+0xec/0x130 [xfs]
> > [ 4931.214231]  down_write_nested+0x46/0x80
> > [ 4931.215038]  ? xfs_ilock+0x13a/0x210 [xfs]
> > [ 4931.215851]  xfs_ilock+0x13a/0x210 [xfs]
> > [ 4931.216634]  xfs_inactive+0xec/0x130 [xfs]
> > [ 4931.217699]  xfs_fs_destroy_inode+0xbb/0x2d0 [xfs]
> > [ 4931.218594]  destroy_inode+0x3b/0x60
> > [ 4931.219314]  evict+0x139/0x1c0
> > [ 4931.220061]  dispose_list+0x56/0x80
> > [ 4931.220765]  prune_icache_sb+0x5a/0x80
> > [ 4931.221498]  super_cache_scan+0x14e/0x1a0
> > [ 4931.222269]  shrink_slab.part.46+0x216/0x600
> > [ 4931.223075]  shrink_slab+0x29/0x30
> > [ 4931.223883]  shrink_node+0x108/0x320
> > [ 4931.224588]  kswapd+0x391/0x990
> > [ 4931.225246]  kthread+0x10c/0x140
> > [ 4931.225902]  ? mem_cgroup_shrink_node+0x300/0x300
> > [ 4931.226760]  ? kthread_create_on_node+0x70/0x70
> > [ 4931.227579]  ret_from_fork+0x31/0x40
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
