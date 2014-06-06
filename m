Return-Path: <xfs-bounces@oss.sgi.com>
From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, xfs-misc-fixes-3-for-3.16,
	created. xfs-for-linus-3.15-rc5-1272-g3026511
Message-Id: <20140606070108.C21327F53@oss.sgi.com>
Date: Fri,  6 Jun 2014 02:01:08 -0500 (CDT)
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

The branch, xfs-misc-fixes-3-for-3.16 has been created
        at  30265117ee1e23fa91920f337a3ea91207f700dc (commit)

- Log -----------------------------------------------------------------
commit 30265117ee1e23fa91920f337a3ea91207f700dc
Author: Jan Kara <jack@suse.cz>
Date:   Fri Jun 6 16:06:37 2014 +1000

    xfs: Fix rounding in xfs_alloc_fix_len()
    
    Rounding in xfs_alloc_fix_len() is wrong. As the comment states, the
    result should be a number of a form (k*prod+mod) however due to sign
    mistake the result is different. As a result allocations on raid arrays
    could be misaligned in some cases.
    
    This also seems to fix occasional assertion failure:
    	XFS_WANT_CORRUPTED_GOTO(rlen <= flen, error0)
    in xfs_alloc_ag_vextent_size().
    
    Also add an assertion that the result of xfs_alloc_fix_len() is of
    expected form.
    
    Signed-off-by: Jan Kara <jack@suse.cz>
    Reviewed-by: Brian Foster <bfoster@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 448011e2ab1c44f7990a62649580bde0da5242b5
Author: Christoph Hellwig <hch@infradead.org>
Date:   Fri Jun 6 16:05:15 2014 +1000

    xfs: tone down writepage/releasepage WARN_ONs
    
    I recently ran into the issue fixed by
    
      "xfs: kill buffers over failed write ranges properly"
    
    which spams the log with lots of backtraces.  Make debugging any
    issues like that easier by using WARN_ON_ONCE in the writeback code.
    
    Signed-off-by: Christoph Hellwig <hch@lst.de>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 72208ee060635dfab2b3bd447a95e0f9c419e954
Author: Dan Carpenter <dan.carpenter@oracle.com>
Date:   Fri Jun 6 16:04:42 2014 +1000

    xfs: small cleanup in xfs_lowbit64()
    
    There are two checkpatch.pl complaints here because of the bad
    indenting and because of the assignment inside the condition.
    
    Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
    Reviewed-by: Eric Sandeen <sandeen@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 36de95567f910f5544060f50346d8677ae13ad22
Author: Dave Chinner <dchinner@redhat.com>
Date:   Fri Jun 6 16:02:12 2014 +1000

    xfs: kill xfs_buf_geterror()
    
    Most of the callers are just calling ASSERT(!xfs_buf_geterror())
    which means they are checking for bp->b_error == 0. If bp is null in
    this case, we will assert fail, and hence it's no different in
    result to oopsing because of a null bp. In some cases, errors have
    already been checked for or the function returning the buffer can't
    return a buffer with an error, so it's just a redundant assert.
    Either way, the assert can either be removed.
    
    The other two non-assert callers can just test for a buffer and
    error properly.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Brian Foster <bfoster@redhat.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 556b8883cfac3d3203557e161ea8005f8b5479b2
Author: Dave Chinner <dchinner@redhat.com>
Date:   Fri Jun 6 16:00:43 2014 +1000

    xfs: xfs_readsb needs to check for magic numbers
    
    Commit daba542 ("xfs: skip verification on initial "guess"
    superblock read") dropped the use of a verifier for the initial
    superblock read so we can probe the sector size of the filesystem
    stored in the superblock. It, however, now fails to validate that
    what was read initially is actually an XFS superblock and hence will
    fail the sector size check and return ENOSYS.
    
    This causes probe-based mounts to fail because it expects XFS to
    return EINVAL when it doesn't recognise the superblock format.
    
    cc: <stable@vger.kernel.org>
    Reported-by: Plamen Petrov <plamen.sisi@gmail.com>
    Tested-by: Plamen Petrov <plamen.sisi@gmail.com>
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 1f6d64829db78a7e1d63e15c9f48f0a5d2b5a679
Author: Dave Chinner <dchinner@redhat.com>
Date:   Fri Jun 6 15:59:59 2014 +1000

    xfs: block allocation work needs to be kswapd aware
    
    Upon memory pressure, kswapd calls xfs_vm_writepage() from
    shrink_page_list(). This can result in delayed allocation occurring
    and that gets deferred to the the allocation workqueue.
    
    The allocation then runs outside kswapd context, which means if it
    needs memory (and it does to demand page metadata from disk) it can
    block in shrink_inactive_list() waiting for IO congestion. These
    blocking waits are normally avoiding in kswapd context, so under
    memory pressure writeback from kswapd can be arbitrarily delayed by
    memory reclaim.
    
    To avoid this, pass the kswapd context to the allocation being done
    by the workqueue, so that memory reclaim understands correctly that
    the work is being done for kswapd and therefore it is not blocked
    and does not delay memory reclaim.
    
    To avoid issues with int->char conversion of flag fields (as noticed
    in v1 of this patch) convert the flag fields in the struct
    xfs_bmalloca to bool types. pahole indicates these variables are
    still single byte variables, so no extra space is consumed by this
    change.
    
    cc: <stable@vger.kernel.org>
    Reported-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

-----------------------------------------------------------------------


hooks/post-receive
-- 
XFS development tree

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
