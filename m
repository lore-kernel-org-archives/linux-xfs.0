Return-Path: <xfs-bounces@oss.sgi.com>
From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, xfs-for-3.16-rc5,
	created. xfs-for-linus-3.16-rc1-13104-g03e0134
Message-Id: <20140714222459.933217F6C@oss.sgi.com>
Date: Mon, 14 Jul 2014 17:24:59 -0500 (CDT)
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

This is an automated email from the git hooks/post-receive script. It was
generated because a ref change was pushed to the repository containing
the project "XFS development tree".

The branch, xfs-for-3.16-rc5 has been created
        at  03e01349c654fbdea80d3d9b4ab599244eb55bb7 (commit)

- Log -----------------------------------------------------------------
commit 03e01349c654fbdea80d3d9b4ab599244eb55bb7
Author: Dave Chinner <dchinner@redhat.com>
Date:   Tue Jul 15 07:28:41 2014 +1000

    xfs: null unused quota inodes when quota is on
    
    When quota is on, it is expected that unused quota inodes have a
    value of NULLFSINO. The changes to support a separate project quota
    in 3.12 broken this rule for non-project quota inode enabled
    filesystem, as the code now refuses to write the group quota inode
    if neither group or project quotas are enabled. This regression was
    introduced by commit d892d58 ("xfs: Start using pquotaino from the
    superblock").
    
    In this case, we should be writing NULLFSINO rather than nothing to
    ensure that we leave the group quota inode in a valid state while
    quotas are enabled.
    
    Failure to do so doesn't cause a current kernel to break - the
    separate project quota inodes introduced translation code to always
    treat a zero inode as NULLFSINO. This was introduced by commit
    0102629 ("xfs: Initialize all quota inodes to be NULLFSINO") with is
    also in 3.12 but older kernels do not do this and hence taking a
    filesystem back to an older kernel can result in quotas failing
    initialisation at mount time. When that happens, we see this in
    dmesg:
    
    [ 1649.215390] XFS (sdb): Mounting Filesystem
    [ 1649.316894] XFS (sdb): Failed to initialize disk quotas.
    [ 1649.316902] XFS (sdb): Ending clean mount
    
    By ensuring that we write NULLFSINO to quota inodes that aren't
    active, we avoid this problem. We have to be really careful when
    determining if the quota inodes are active or not, because we don't
    want to write a NULLFSINO if the quota inodes are active and we
    simply aren't updating them.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Brian Foster <bfoster@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit cf11da9c5d374962913ca5ba0ce0886b58286224
Author: Dave Chinner <dchinner@redhat.com>
Date:   Tue Jul 15 07:08:24 2014 +1000

    xfs: refine the allocation stack switch
    
    The allocation stack switch at xfs_bmapi_allocate() has served it's
    purpose, but is no longer a sufficient solution to the stack usage
    problem we have in the XFS allocation path.
    
    Whilst the kernel stack size is now 16k, that is not a valid reason
    for undoing all our "keep stack usage down" modifications. What it
    does allow us to do is have the freedom to refine and perfect the
    modifications knowing that if we get it wrong it won't blow up in
    our faces - we have a safety net now.
    
    This is important because we still have the issue of older kernels
    having smaller stacks and that they are still supported and are
    demonstrating a wide range of different stack overflows.  Red Hat
    has several open bugs for allocation based stack overflows from
    directory modifications and direct IO block allocation and these
    problems still need to be solved. If we can solve them upstream,
    then distro's won't need to bake their own unique solutions.
    
    To that end, I've observed that every allocation based stack
    overflow report has had a specific characteristic - it has happened
    during or directly after a bmap btree block split. That event
    requires a new block to be allocated to the tree, and so we
    effectively stack one allocation stack on top of another, and that's
    when we get into trouble.
    
    A further observation is that bmap btree block splits are much rarer
    than writeback allocation - over a range of different workloads I've
    observed the ratio of bmap btree inserts to splits ranges from 100:1
    (xfstests run) to 10000:1 (local VM image server with sparse files
    that range in the hundreds of thousands to millions of extents).
    Either way, bmap btree split events are much, much rarer than
    allocation events.
    
    Finally, we have to move the kswapd state to the allocation workqueue
    work when allocation is done on behalf of kswapd. This is proving to
    cause significant perturbation in performance under memory pressure
    and appears to be generating allocation deadlock warnings under some
    workloads, so avoiding the use of a workqueue for the majority of
    kswapd writeback allocation will minimise the impact of such
    behaviour.
    
    Hence it makes sense to move the stack switch to xfs_btree_split()
    and only do it for bmap btree splits. Stack switches during
    allocation will be much rarer, so there won't be significant
    performacne overhead caused by switching stacks. The worse case
    stack from all allocation paths will be split, not just writeback.
    And the majority of memory allocations will be done in the correct
    context (e.g. kswapd) without causing additional latency, and so we
    simplify the memory reclaim interactions between processes,
    workqueues and kswapd.
    
    The worst stack I've been able to generate with this patch in place
    is 5600 bytes deep. It's very revealing because we exit XFS at:
    
    37)     1768      64   kmem_cache_alloc+0x13b/0x170
    
    about 1800 bytes of stack consumed, and the remaining 3800 bytes
    (and 36 functions) is memory reclaim, swap and the IO stack. And
    this occurs in the inode allocation from an open(O_CREAT) syscall,
    not writeback.
    
    The amount of stack being used is much less than I've previously be
    able to generate - fs_mark testing has been able to generate stack
    usage of around 7k without too much trouble; with this patch it's
    only just getting to 5.5k. This is primarily because the metadata
    allocation paths (e.g. directory blocks) are no longer causing
    double splits on the same stack, and hence now stack tracing is
    showing swapping being the worst stack consumer rather than XFS.
    
    Performance of fs_mark inode create workloads is unchanged.
    Performance of fs_mark async fsync workloads is consistently good
    with context switches reduced by around 150,000/s (30%).
    Performance of dbench, streaming IO and postmark is unchanged.
    Allocation deadlock warnings have not been seen on the workloads
    that generated them since adding this patch.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Brian Foster <bfoster@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit aa182e64f16fc29a4984c2d79191b161888bbd9b
Author: Dave Chinner <dchinner@redhat.com>
Date:   Tue Jul 15 07:08:10 2014 +1000

    Revert "xfs: block allocation work needs to be kswapd aware"
    
    This reverts commit 1f6d64829db78a7e1d63e15c9f48f0a5d2b5a679.
    
    This commit resulted in regressions in performance in low
    memory situations where kswapd was doing writeback of delayed
    allocation blocks. It resulted in significant parallelism of the
    kswapd work and with the special kswapd flags meant that hundreds of
    active allocation could dip into kswapd specific memory reserves and
    avoid being throttled. This cause a large amount of performance
    variation, as well as random OOM-killer invocations that didn't
    previously exist.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Brian Foster <bfoster@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

-----------------------------------------------------------------------


hooks/post-receive
-- 
XFS development tree

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
