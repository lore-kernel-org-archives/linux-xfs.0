Return-Path: <xfs-bounces@oss.sgi.com>
From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, xfs-bug-fixes-for-3.15-2,
	created. xfs-for-linus-v3.14-rc1-2-12925-gfe4c224
Message-Id: <20140307054400.9937E7F52@oss.sgi.com>
Date: Thu,  6 Mar 2014 23:43:58 -0600 (CST)
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

The branch, xfs-bug-fixes-for-3.15-2 has been created
        at  fe4c224aa1ffa4352849ac5f452de7132739bee2 (commit)

- Log -----------------------------------------------------------------
commit fe4c224aa1ffa4352849ac5f452de7132739bee2
Author: Dave Chinner <dchinner@redhat.com>
Date:   Fri Mar 7 16:19:14 2014 +1100

    xfs: inode log reservations are still too small
    
    Back in commit 23956703 ("xfs: inode log reservations are too
    small"), the reservation size was increased to take into account the
    difference in size between the in-memory BMBT block headers and the
    on-disk BMDR headers. This solved a transaction overrun when logging
    the inode size.
    
    Recently, however, we've seen a number of these same overruns on
    kernels with the above fix in it. All of them have been by 4 bytes,
    so we must still not be accounting for something correctly.
    
    Through inspection it turns out the above commit didn't take into
    account everything it should have. That is, it only accounts for a
    single log op_hdr structure, when it can actually require up to four
    op_hdrs - one for each region (log iovec) that is formatted. These
    regions are the inode log format header, the inode core, and the two
    forks that can be held in the literal area of the inode.
    
    This means we are not accounting for 36 bytes of log space that the
    transaction can use, and hence when we get inodes in certain formats
    with particular fragmentation patterns we can overrun the
    transaction. Fix this by adding the correct accounting for log
    op_headers in the transaction.
    
    Tested-by: Brian Foster <bfoster@redhat.com>
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Eric Sandeen <sandeen@redhat.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit a49935f200e24e95fffcc705014c4b60ad78ff1f
Author: Dave Chinner <dchinner@redhat.com>
Date:   Fri Mar 7 16:19:14 2014 +1100

    xfs: xfs_check_page_type buffer checks need help
    
    xfs_aops_discard_page() was introduced in the following commit:
    
      xfs: truncate delalloc extents when IO fails in writeback
    
    ... to clean up left over delalloc ranges after I/O failure in
    ->writepage(). generic/224 tests for this scenario and occasionally
    reproduces panics on sub-4k blocksize filesystems.
    
    The cause of this is failure to clean up the delalloc range on a
    page where the first buffer does not match one of the expected
    states of xfs_check_page_type(). If a buffer is not unwritten,
    delayed or dirty&mapped, xfs_check_page_type() stops and
    immediately returns 0.
    
    The stress test of generic/224 creates a scenario where the first
    several buffers of a page with delayed buffers are mapped & uptodate
    and some subsequent buffer is delayed. If the ->writepage() happens
    to fail for this page, xfs_aops_discard_page() incorrectly skips
    the entire page.
    
    This then causes later failures either when direct IO maps the range
    and finds the stale delayed buffer, or we evict the inode and find
    that the inode still has a delayed block reservation accounted to
    it.
    
    We can easily fix this xfs_aops_discard_page() failure by making
    xfs_check_page_type() check all buffers, but this breaks
    xfs_convert_page() more than it is already broken. Indeed,
    xfs_convert_page() wants xfs_check_page_type() to tell it if the
    first buffers on the pages are of a type that can be aggregated into
    the contiguous IO that is already being built.
    
    xfs_convert_page() should not be writing random buffers out of a
    page, but the current behaviour will cause it to do so if there are
    buffers that don't match the current specification on the page.
    Hence for xfs_convert_page() we need to:
    
    	a) return "not ok" if the first buffer on the page does not
    	match the specification provided to we don't write anything;
    	and
    	b) abort it's buffer-add-to-io loop the moment we come
    	across a buffer that does not match the specification.
    
    Hence we need to fix both xfs_check_page_type() and
    xfs_convert_page() to work correctly with pages that have mixed
    buffer types, whilst allowing xfs_aops_discard_page() to scan all
    buffers on the page for a type match.
    
    Reported-by: Brian Foster <bfoster@redhat.com>
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit e480a7239723afe579060239564884d1fa4c9325
Author: Brian Foster <bfoster@redhat.com>
Date:   Fri Mar 7 16:19:14 2014 +1100

    xfs: avoid AGI/AGF deadlock scenario for inode chunk allocation
    
    The inode chunk allocation path can lead to deadlock conditions if
    a transaction is dirtied with an AGF (to fix up the freelist) for
    an AG that cannot satisfy the actual allocation request. This code
    path is written to try and avoid this scenario, but it can be
    reproduced by running xfstests generic/270 in a loop on a 512b fs.
    
    An example situation is:
    - process A attempts an inode allocation on AG 3, modifies
      the freelist, fails the allocation and ultimately moves on to
      AG 0 with the AG 3 AGF held
    - process B is doing a free space operation (i.e., truncate) and
      acquires the AG 0 AGF, waits on the AG 3 AGF
    - process A acquires the AG 0 AGI, waits on the AG 0 AGF (deadlock)
    
    The problem here is that process A acquired the AG 3 AGF while
    moving on to AG 0 (and releasing the AG 3 AGI with the AG 3 AGF
    held). xfs_dialloc() makes one pass through each of the AGs when
    attempting to allocate an inode chunk. The expectation is a clean
    transaction if a particular AG cannot satisfy the allocation
    request. xfs_ialloc_ag_alloc() is written to support this through
    use of the minalignslop allocation args field.
    
    When using the agi->agi_newino optimization, we attempt an exact
    bno allocation request based on the location of the previously
    allocated chunk. minalignslop is set to inform the allocator that
    we will require alignment on this chunk, and thus to not allow the
    request for this AG if the extra space is not available. Suppose
    that the AG in question has just enough space for this request, but
    not at the requested bno. xfs_alloc_fix_freelist() will proceed as
    normal as it determines the request should succeed, and thus it is
    allowed to modify the agf. xfs_alloc_ag_vextent() ultimately fails
    because the requested bno is not available. In response, the caller
    moves on to a NEAR_BNO allocation request for the same AG. The
    alignment is set, but the minalignslop field is never reset. This
    increases the overall requirement of the request from the first
    attempt. If this delta is the difference between allocation success
    and failure for the AG, xfs_alloc_fix_freelist() rejects this
    request outright the second time around and causes the allocation
    request to unnecessarily fail for this AG.
    
    To address this situation, reset the minalignslop field immediately
    after use and prevent it from leaking into subsequent requests.
    
    Signed-off-by: Brian Foster <bfoster@redhat.com>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit ae687e58b3f09b1b3c0faf2cac8c27fbbefb5a48
Author: Dave Chinner <dchinner@redhat.com>
Date:   Fri Mar 7 16:19:14 2014 +1100

    xfs: use NOIO contexts for vm_map_ram
    
    When we map pages in the buffer cache, we can do so in GFP_NOFS
    contexts. However, the vmap interfaces do not provide any method of
    communicating this information to memory reclaim, and hence we get
    lockdep complaining about it regularly and occassionally see hangs
    that may be vmap related reclaim deadlocks. We can also see these
    same problems from anywhere where we use vmalloc for a large buffer
    (e.g. attribute code) inside a transaction context.
    
    A typical lockdep report shows up as a reclaim state warning like so:
    
    [14046.101458] =================================
    [14046.102850] [ INFO: inconsistent lock state ]
    [14046.102850] 3.14.0-rc4+ #2 Not tainted
    [14046.102850] ---------------------------------
    [14046.102850] inconsistent {RECLAIM_FS-ON-W} -> {IN-RECLAIM_FS-W} usage.
    [14046.102850] kswapd0/14 [HC0[0]:SC0[0]:HE1:SE1] takes:
    [14046.102850]  (&xfs_dir_ilock_class){++++?+}, at: [<791a04bb>] xfs_ilock+0xff/0x16a
    [14046.102850] {RECLAIM_FS-ON-W} state was registered at:
    [14046.102850]   [<7904cdb1>] mark_held_locks+0x81/0xe7
    [14046.102850]   [<7904d390>] lockdep_trace_alloc+0x5c/0xb4
    [14046.102850]   [<790c2c28>] kmem_cache_alloc_trace+0x2b/0x11e
    [14046.102850]   [<790ba7f4>] vm_map_ram+0x119/0x3e6
    [14046.102850]   [<7914e124>] _xfs_buf_map_pages+0x5b/0xcf
    [14046.102850]   [<7914ed74>] xfs_buf_get_map+0x67/0x13f
    [14046.102850]   [<7917506f>] xfs_attr_rmtval_set+0x396/0x4d5
    [14046.102850]   [<7916e8bb>] xfs_attr_leaf_addname+0x18f/0x37d
    [14046.102850]   [<7916ed9e>] xfs_attr_set_int+0x2f5/0x3e8
    [14046.102850]   [<7916eefc>] xfs_attr_set+0x6b/0x74
    [14046.102850]   [<79168355>] xfs_xattr_set+0x61/0x81
    [14046.102850]   [<790e5b10>] generic_setxattr+0x59/0x68
    [14046.102850]   [<790e4c06>] __vfs_setxattr_noperm+0x58/0xce
    [14046.102850]   [<790e4d0a>] vfs_setxattr+0x8e/0x92
    [14046.102850]   [<790e4ddd>] setxattr+0xcf/0x159
    [14046.102850]   [<790e5423>] SyS_lsetxattr+0x88/0xbb
    [14046.102850]   [<79268438>] sysenter_do_call+0x12/0x36
    
    Now, we can't completely remove these traces - mainly because
    vm_map_ram() will do GFP_KERNEL allocation and that generates the
    above warning before we get into the reclaim code, but we can turn
    them all into false positive warnings.
    
    To do that, use the method that DM and other IO context code uses to
    avoid this problem: there is a process flag to tell memory reclaim
    not to do IO that we can set appropriately. That prevents GFP_KERNEL
    context reclaim being done from deep inside the vmalloc code in
    places we can't directly pass a GFP_NOFS context to. That interface
    has a pair of wrapper functions: memalloc_noio_save() and
    memalloc_noio_restore().
    
    Adding them around vm_map_ram and the vzalloc call in
    kmem_alloc_large() will prevent deadlocks and most lockdep reports
    for this issue. Also, convert the vzalloc() call in
    kmem_alloc_large() to use __vmalloc() so that we can pass the
    correct gfp context to the data page allocation routine inside
    __vmalloc() so that it is clear that GFP_NOFS context is important
    to this vmalloc call.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit ac75a1f7a4af4dddcc1ac3c0778f0e3f75dc8f32
Author: Dave Chinner <dchinner@redhat.com>
Date:   Fri Mar 7 16:19:14 2014 +1100

    xfs: don't leak EFSBADCRC to userspace
    
    While the verifier routines may return EFSBADCRC when a buffer has
    a bad CRC, we need to translate that to EFSCORRUPTED so that the
    higher layers treat the error appropriately and we return a
    consistent error to userspace. This fixes a xfs/005 regression.
    
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
