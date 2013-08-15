Return-Path: <xfs-bounces@oss.sgi.com>
From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, for-next,
	updated. for-linus-v3.11-rc1-2-12170-g4bb928c
Message-Id: <20130815210712.309E57F52@oss.sgi.com>
Date: Thu, 15 Aug 2013 16:07:11 -0500 (CDT)
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

The branch, for-next has been updated
  4bb928c xfs: split the CIL lock
  991aaf6 xfs: Combine CIL insert and prepare passes
  f5baac3 xfs: avoid CIL allocation during insert
  7492c5b xfs: Reduce allocations during CIL insertion
  166d136 xfs: return log item size in IOP_SIZE
  050a195 xfs:free bp in xlog_find_tail() error path
  5d0a654 xfs: free bp in xlog_find_zeroed() error path
  6dd93e9 xfs: avoid double-free in xfs_attr_node_addname
      from  2c2bcc0735f4ab052559b539f3fcab4087187232 (commit)

Those revisions listed above that are new to this repository have
not appeared on any other notification email; so we list those
revisions in full, below.

- Log -----------------------------------------------------------------
commit 4bb928cdb900d0614f4766d5f1ca5bc3844f7656
Author: Dave Chinner <dchinner@redhat.com>
Date:   Mon Aug 12 20:50:08 2013 +1000

    xfs: split the CIL lock
    
    The xc_cil_lock is used for two purposes - to protect the CIL
    itself, and to protect the push/commit state and lists. These are
    two logically separate structures and operations, so can have their
    own locks. This means that pushing on the CIL and the commit wait
    ordering won't contend for a lock with other transactions that are
    completing concurrently. As the CIL insertion is the hottest path
    throught eh CIL, this is a big win.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 991aaf65ff0addc2692cfa8dc1ff082dcf69d26f
Author: Dave Chinner <dchinner@redhat.com>
Date:   Mon Aug 12 20:50:07 2013 +1000

    xfs: Combine CIL insert and prepare passes
    
    Now that all the log item preparation and formatting is done under
    the CIL lock, we can get rid of the intermediate log vector chain
    used to track items to be inserted into the CIL.
    
    We can already find all the items to be committed from the
    transaction handle, so as long as we attach the log vectors to the
    item before we insert the items into the CIL, we don't need to
    create a log vector chain to pass around.
    
    This means we can move all the item insertion code into and optimise
    it into a pair of simple passes across all the items in the
    transaction. The first pass does the formatting and accounting, the
    second inserts them all into the CIL.
    
    We keep this two pass split so that we can separate the CIL
    insertion - which must be done under the CIL spinlock - from the
    formatting. We could insert each item into the CIL with a single
    pass, but that massively increases the number of times we have to
    grab the CIL spinlock. It is much more efficient (and hence
    scalable) to do a batch operation and insert all objects in a single
    lock grab.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit f5baac354db8b6abfe8ed4ff6b6c3438c42ea606
Author: Dave Chinner <dchinner@redhat.com>
Date:   Mon Aug 12 20:50:06 2013 +1000

    xfs: avoid CIL allocation during insert
    
    Now that we have the size of the log vector that has been allocated,
    we can determine if we need to allocate a new log vector for
    formatting and insertion. We only need to allocate a new vector if
    it won't fit into the existing buffer.
    
    However, we need to hold the CIL context lock while we do this so
    that we can't race with a push draining the currently queued log
    vectors. It is safe to do this as long as we do GFP_NOFS allocation
    to avoid avoid memory allocation recursing into the filesystem.
    Hence we can safely overwrite the existing log vector on the CIL if
    it is large enough to hold all the dirty regions of the current
    item.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 7492c5b42de857c13d8b7e0dafb2a5e331598e00
Author: Dave Chinner <dchinner@redhat.com>
Date:   Mon Aug 12 20:50:05 2013 +1000

    xfs: Reduce allocations during CIL insertion
    
    Now that we have the size of the object before the formatting pass
    is called, we can allocation the log vector and it's buffer in a
    single allocation rather than two separate allocations.
    
    Store the size of the allocated buffer in the log vector so that
    we potentially avoid allocation for future modifications of the
    object.
    
    While touching this code, remove the IOP_FORMAT definition.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 166d13688a0e2d0aa379e259af8e2ee6a401de9a
Author: Dave Chinner <dchinner@redhat.com>
Date:   Mon Aug 12 20:50:04 2013 +1000

    xfs: return log item size in IOP_SIZE
    
    To begin optimising the CIL commit process, we need to have IOP_SIZE
    return both the number of vectors and the size of the data pointed
    to by the vectors. This enables us to calculate the size ofthe
    memory allocation needed before the formatting step and reduces the
    number of memory allocations per item by one.
    
    While there, kill the IOP_SIZE macro.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 050a1952c3f9304eccddc4f084e2401b5205ff55
Author: Eric Sandeen <sandeen@redhat.com>
Date:   Wed Jul 31 20:33:47 2013 -0500

    xfs:free bp in xlog_find_tail() error path
    
    xlog_find_tail() currently leaks a bp on one error path.
    
    There is no error target, so manually free the bp before
    returning the error.
    
    Found by Coverity.
    
    Signed-off-by: Eric Sandeen <sandeen@redhat.com>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 5d0a654974c5cac03ce7c577bcfd6bca0f2b2c5a
Author: Eric Sandeen <sandeen@redhat.com>
Date:   Wed Jul 31 20:32:30 2013 -0500

    xfs: free bp in xlog_find_zeroed() error path
    
    xlog_find_zeroed() currently leaks a bp on one error path.
    
    Using the bp_err: target resolves this.
    
    Found by Coverity.
    
    Signed-off-by: Eric Sandeen <sandeen@redhat.com>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 6dd93e9e5eb19e81a74b3df8426a945a08ad8a1f
Author: Eric Sandeen <sandeen@redhat.com>
Date:   Wed Jul 31 20:18:54 2013 -0500

    xfs: avoid double-free in xfs_attr_node_addname
    
    xfs_attr_node_addname()'s error handling tests whether it
    should free "state" in the out: error handling label:
    
    out:
            if (state)
                    xfs_da_state_free(state);
    
    but an earlier free doesn't set state to NULL afterwards; this
    could lead to a double free.  Fix it by setting state to NULL
    after it's freed.
    
    This was found by Coverity.
    
    Signed-off-by: Eric Sandeen <sandeen@redhat.com>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

-----------------------------------------------------------------------

Summary of changes:
 fs/xfs/xfs_attr.c         |   1 +
 fs/xfs/xfs_buf_item.c     |  52 ++++---
 fs/xfs/xfs_dquot_item.c   |  22 +--
 fs/xfs/xfs_extfree_item.c |  50 ++++---
 fs/xfs/xfs_icreate_item.c |   9 +-
 fs/xfs/xfs_inode_item.c   |  53 ++++---
 fs/xfs/xfs_log.h          |   1 +
 fs/xfs/xfs_log_cil.c      | 371 ++++++++++++++++++++++++----------------------
 fs/xfs/xfs_log_priv.h     |   9 +-
 fs/xfs/xfs_log_recover.c  |   4 +-
 fs/xfs/xfs_trans.h        |   5 +-
 11 files changed, 320 insertions(+), 257 deletions(-)


hooks/post-receive
-- 
XFS development tree

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
