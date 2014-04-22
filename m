Return-Path: <xfs-bounces@oss.sgi.com>
From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, xfs-unused-args-cleanup,
	created. xfs-for-linus-3.15-rc1-14846-g5e06d14
Message-Id: <20140422222917.53BF17F4E@oss.sgi.com>
Date: Tue, 22 Apr 2014 17:29:16 -0500 (CDT)
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

The branch, xfs-unused-args-cleanup has been created
        at  5e06d148949bb79af429c46afb4b81bc31308f6e (commit)

- Log -----------------------------------------------------------------
commit 5e06d148949bb79af429c46afb4b81bc31308f6e
Author: Eric Sandeen <sandeen@sandeen.net>
Date:   Mon Apr 14 19:07:23 2014 +1000

    xfs: remove unused calculation in xfs_dir2_sf_addname()
    
    The "add_entsize" calculated here is never used.
    "incr_isize" accounts for the inode expansion of the
    old entries + parent + new entry all by itself.
    
    Once we've removed add_entsize there, it's just a pointless
    intermediate variable elsewhere, so remove it.
    For that matter, old_isize is gratuitous too, so nuke that.
    
    And add a few comments so the magic "+1's" and "+2's" make
    a bit more sense.
    
    Signed-off-by: Eric Sandeen <sandeen@redhat.com>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit e5e98bc64df122c3c0fb562c53dac5c5dfc64975
Author: Eric Sandeen <sandeen@redhat.com>
Date:   Mon Apr 14 19:06:46 2014 +1000

    xfs: remove pointless pointer increment in xfs_dir2_block_compact()
    
    xfs_dir2_block_compact() is passed a pointer to *blp, and
    advances it locally - but nobody uses the pointer (locally)
    after that.
    
    This behavior came about as part of prior refactoring,
    
    20f7e9f xfs: factor dir2 block read operations
    
    and looking at the code as it was before, it seems quite clear
    that this change introduced a bug; the pre-refactoring code
    expects blp to be modified after compaction.
    And indeed it did; see this commit which fixed it:
    
    37f1356 xfs: recalculate leaf entry pointer after compacting a dir2 block
    
    So the bug was introduced & resolved in the 3.8 cycle.
    
    Whoops.  Well, it's fixed now, and mystery solved; just remove
    the now-pointless local increment of the blp pointer.
    
    (I guess we should have run clang earlier!)
    
    Signed-off-by: Eric Sandeen <sandeen@redhat.com>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit bbe4c668694cb22a6016d3845c9b362c44e8341f
Author: Eric Sandeen <sandeen@redhat.com>
Date:   Mon Apr 14 19:06:25 2014 +1000

    xfs: remove unused trans pointer arg from xlog_recover_unmount_trans()
    
    Signed-off-by: Eric Sandeen <sandeen@redhat.com>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit e4a1e29cb0ace3a322c5c07d33dd1f4ab50dbbb8
Author: Eric Sandeen <sandeen@redhat.com>
Date:   Mon Apr 14 19:06:05 2014 +1000

    xfs: remove unused ail pointer arg from xfs_trans_ail_cursor_done()
    
    Signed-off-by: Eric Sandeen <sandeen@redhat.com>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit bda65ef8a8ab8944628b7ff1182902612efd8bc3
Author: Eric Sandeen <sandeen@redhat.com>
Date:   Mon Apr 14 19:05:43 2014 +1000

    xfs: remove unused xfs_mount arg from xfs_symlink_hdr_ok()
    
    Signed-off-by: Eric Sandeen <sandeen@redhat.com>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit fd9fdba6c366f6a1606572e46eebf770462ff484
Author: Eric Sandeen <sandeen@redhat.com>
Date:   Mon Apr 14 19:04:46 2014 +1000

    xfs: remove unused bp arg from xfs_iflush_fork()
    
    Signed-off-by: Eric Sandeen <sandeen@redhat.com>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit e009400870c16c2003b2183b2daa9f1e80ff516b
Author: Eric Sandeen <sandeen@redhat.com>
Date:   Mon Apr 14 19:04:19 2014 +1000

    xfs: remove unused pag ptr arg from iterator execute functions
    
    Signed-off-by: Eric Sandeen <sandeen@redhat.com>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 6f8950cd731432508859ef0c054b026270095b2e
Author: Eric Sandeen <sandeen@redhat.com>
Date:   Mon Apr 14 19:03:53 2014 +1000

    xfs: remove unused length arg from alloc_block ops
    
    Signed-off-by: Eric Sandeen <sandeen@redhat.com>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 6ea94bb5b30f14717e349f4e3ea4a6df03e1ee67
Author: Eric Sandeen <sandeen@redhat.com>
Date:   Mon Apr 14 19:03:34 2014 +1000

    xfs: remove unused mp arg from xfs_calc_dquots_per_chunk()
    
    Signed-off-by: Eric Sandeen <sandeen@redhat.com>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 25994053745be958aa8455a753a5c965a9006ba4
Author: Eric Sandeen <sandeen@redhat.com>
Date:   Mon Apr 14 19:02:30 2014 +1000

    xfs: remove unused mp arg from xfs_dir2 dataptr/byte functions
    
    Signed-off-by: Eric Sandeen <sandeen@redhat.com>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 9df2dd0b0d2aad3ce2480e0618bfe14d37c017a3
Author: Eric Sandeen <sandeen@redhat.com>
Date:   Mon Apr 14 19:01:59 2014 +1000

    xfs: remove unused tp arg from xfs_da_reada_buf & callers
    
    This one hits a few functions as we unravel the unused arg
    up through the callers.
    
    Signed-off-by: Eric Sandeen <sandeen@redhat.com>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 72b0636bb7aca50978da60dfbaefc44020e1600e
Author: Eric Sandeen <sandeen@redhat.com>
Date:   Mon Apr 14 19:01:34 2014 +1000

    xfs: remove unused bip arg from xfs_buf_item_log_segment()
    
    Signed-off-by: Eric Sandeen <sandeen@redhat.com>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 87937bf8cae495d4eafdae226e0726c25c3ff9f9
Author: Eric Sandeen <sandeen@redhat.com>
Date:   Mon Apr 14 19:01:20 2014 +1000

    xfs: remove unused flags arg from _xfs_buf_get_pages()
    
    Signed-off-by: Eric Sandeen <sandeen@redhat.com>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 34dcefd717dea161182c18e2622cd9bed4bb4835
Author: Eric Sandeen <sandeen@redhat.com>
Date:   Mon Apr 14 19:01:00 2014 +1000

    xfs: remove unused args from xfs_alloc_buftarg()
    
    Signed-off-by: Eric Sandeen <sandeen@redhat.com>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit a96c41519ac95bd7e8c798d235d6c98ca846090a
Author: Eric Sandeen <sandeen@redhat.com>
Date:   Mon Apr 14 19:00:29 2014 +1000

    xfs: remove unused blocksize arg from xfs_setsize_buftarg()
    
    Signed-off-by: Eric Sandeen <sandeen@redhat.com>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 0d7409b142472dda73939add752e0815900b3df9
Author: Eric Sandeen <sandeen@redhat.com>
Date:   Mon Apr 14 18:59:56 2014 +1000

    xfs: remove unused level arg from xfs_btree_read_buf_block()
    
    Signed-off-by: Eric Sandeen <sandeen@redhat.com>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 6a9edd3d548f074c484802134e719390d9585ed6
Author: Eric Sandeen <sandeen@redhat.com>
Date:   Mon Apr 14 18:59:26 2014 +1000

    xfs: remove unused mp arg from xfs_bmap_forkoff_reset()
    
    Signed-off-by: Eric Sandeen <sandeen@redhat.com>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 152d93b732d4d15a10db03b660b07ed5c44b4e0d
Author: Eric Sandeen <sandeen@redhat.com>
Date:   Mon Apr 14 18:58:51 2014 +1000

    xfs: remove unused mp arg from xfs_bmdr_maxrecs()
    
    Signed-off-by: Eric Sandeen <sandeen@redhat.com>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 6d0081a3da32c9a9e480ae2796588508347bdb9e
Author: Eric Sandeen <sandeen@redhat.com>
Date:   Mon Apr 14 18:58:29 2014 +1000

    xfs: remove unused mp arg from xfs_attr3_rmt_hdr_ok()
    
    Signed-off-by: Eric Sandeen <sandeen@redhat.com>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 7fb2cd4d32fed48d5fd88e0e922f162c182f5f8c
Author: Eric Sandeen <sandeen@redhat.com>
Date:   Mon Apr 14 18:58:05 2014 +1000

    xfs: remove unused tp arg from xfs_bmap_last_offset() and callers
    
    remove unused transaction pointer from various
    callchains leading to xfs_bmap_last_offset().
    
    Signed-off-by: Eric Sandeen <sandeen@redhat.com>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

-----------------------------------------------------------------------


hooks/post-receive
-- 
XFS development tree

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
