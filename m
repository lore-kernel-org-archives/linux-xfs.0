From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, xfs-buf-iosubmit,
	created. v3.16-11807-g8c15612
Message-Id: <20141002232432.D7CC17F51@oss.sgi.com>
Date: Thu,  2 Oct 2014 18:24:32 -0500 (CDT)
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

The branch, xfs-buf-iosubmit has been created
        at  8c15612546bce1ecafb7dee3cce8a2a9b560e15e (commit)

- Log -----------------------------------------------------------------
commit 8c15612546bce1ecafb7dee3cce8a2a9b560e15e
Author: Christoph Hellwig <hch@infradead.org>
Date:   Thu Oct 2 09:05:44 2014 +1000

    xfs: simplify xfs_zero_remaining_bytes
    
    xfs_zero_remaining_bytes() open codes a log of buffer manupulations
    to do a read forllowed by a write. It can simply be replaced by an
    uncached read followed by a xfs_bwrite() call.
    
    Signed-off-by: Christoph Hellwig <hch@lst.de>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit ba3726742c1712c43c5a18245476f3fe9fe74773
Author: Dave Chinner <dchinner@redhat.com>
Date:   Thu Oct 2 09:05:32 2014 +1000

    xfs: check xfs_buf_read_uncached returns correctly
    
    xfs_buf_read_uncached() has two failure modes. If can either return
    NULL or bp->b_error != 0 depending on the type of failure, and not
    all callers check for both. Fix it so that xfs_buf_read_uncached()
    always returns the error status, and the buffer is returned as a
    function parameter. The buffer will only be returned on success.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 595bff75dce51e0d6d94877b4b6d11b4747a63fd
Author: Dave Chinner <dchinner@redhat.com>
Date:   Thu Oct 2 09:05:14 2014 +1000

    xfs: introduce xfs_buf_submit[_wait]
    
    There is a lot of cookie-cutter code that looks like:
    
    	if (shutdown)
    		handle buffer error
    	xfs_buf_iorequest(bp)
    	error = xfs_buf_iowait(bp)
    	if (error)
    		handle buffer error
    
    spread through XFS. There's significant complexity now in
    xfs_buf_iorequest() to specifically handle this sort of synchronous
    IO pattern, but there's all sorts of nasty surprises in different
    error handling code dependent on who owns the buffer references and
    the locks.
    
    Pull this pattern into a single helper, where we can hide all the
    synchronous IO warts and hence make the error handling for all the
    callers much saner. This removes the need for a special extra
    reference to protect IO completion processing, as we can now hold a
    single reference across dispatch and waiting, simplifying the sync
    IO smeantics and error handling.
    
    In doing this, also rename xfs_buf_iorequest to xfs_buf_submit and
    make it explicitly handle on asynchronous IO. This forces all users
    to be switched specifically to one interface or the other and
    removes any ambiguity between how the interfaces are to be used. It
    also means that xfs_buf_iowait() goes away.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 8b131973d1628f1a0c5a36fe02269d696bbe60a3
Author: Dave Chinner <dchinner@redhat.com>
Date:   Thu Oct 2 09:05:05 2014 +1000

    xfs: kill xfs_bioerror_relse
    
    There is only one caller now - xfs_trans_read_buf_map() - and it has
    very well defined call semantics - read, synchronous, and b_iodone
    is NULL. Hence it's pretty clear what error handling is necessary
    for this case. The bigger problem of untangling
    xfs_trans_read_buf_map error handling is left to a future patch.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 2718775469a521c8b35442db5d665ac0c8c3c8ac
Author: Dave Chinner <dchinner@redhat.com>
Date:   Thu Oct 2 09:04:56 2014 +1000

    xfs: xfs_bioerror can die.
    
    Internal buffer write error handling is a mess due to the unnatural
    split between xfs_bioerror and xfs_bioerror_relse().
    
    xfs_bwrite() only does sync IO and determines the handler to
    call based on b_iodone, so for this caller the only difference
    between xfs_bioerror() and xfs_bioerror_release() is the XBF_DONE
    flag. We don't care what the XBF_DONE flag state is because we stale
    the buffer in both paths - the next buffer lookup will clear
    XBF_DONE because XBF_STALE is set. Hence we can use common
    error handling for xfs_bwrite().
    
    __xfs_buf_delwri_submit() is a similar - it's only ever called
    on writes - all sync or async - and again there's no reason to
    handle them any differently at all.
    
    Clean up the nasty error handling and remove xfs_bioerror().
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 8dac39219827113f14e97507646a610ca426b69e
Author: Dave Chinner <dchinner@redhat.com>
Date:   Thu Oct 2 09:04:40 2014 +1000

    xfs: kill xfs_bdstrat_cb
    
    Only has two callers, and is just a shutdown check and error handler
    around xfs_buf_iorequest. However, the error handling is a mess of
    read and write semantics, and both internal callers only call it for
    writes. Hence kill the wrapper, and follow up with a patch to
    sanitise the error handling.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 61be9c529a4a715ab8679e9ca82bc3790c7ab66c
Author: Dave Chinner <dchinner@redhat.com>
Date:   Thu Oct 2 09:04:31 2014 +1000

    xfs: rework xfs_buf_bio_endio error handling
    
    Currently the report of a bio error from completion
    immediately marks the buffer with an error. The issue is that this
    is racy w.r.t. synchronous IO - the submitter can see b_error being
    set before the IO is complete, and hence we cannot differentiate
    between submission failures and completion failures.
    
    Add an internal b_io_error field protected by the b_lock to catch IO
    completion errors, and only propagate that to the buffer during
    final IO completion handling. Hence we can tell in xfs_buf_iorequest
    if we've had a submission failure bey checking bp->b_error before
    dropping our b_io_remaining reference - that reference will prevent
    b_io_error values from being propagated to b_error in the event that
    completion races with submission.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit e8aaba9a783c8e5d2c58ebe69650ea31b91bb745
Author: Dave Chinner <dchinner@redhat.com>
Date:   Thu Oct 2 09:04:22 2014 +1000

    xfs: xfs_buf_ioend and xfs_buf_iodone_work duplicate functionality
    
    We do some work in xfs_buf_ioend, and some work in
    xfs_buf_iodone_work, but much of that functionality is the same.
    This work can all be done in a single function, leaving
    xfs_buf_iodone just a wrapper to determine if we should execute it
    by workqueue or directly. hence rename xfs_buf_iodone_work to
    xfs_buf_ioend(), and add a new xfs_buf_ioend_async() for places that
    need async processing.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit e11bb8052c3f500e66142f33579cc054d691a8fb
Author: Dave Chinner <dchinner@redhat.com>
Date:   Thu Oct 2 09:04:11 2014 +1000

    xfs: synchronous buffer IO needs a reference
    
    When synchronous IO runs IO completion work, it does so without an
    IO reference or a hold reference on the buffer. The IO "hold
    reference" is owned by the submitter, and released when the
    submission is complete. The IO reference is released when both the
    submitter and the bio end_io processing is run, and so if the io
    completion work is run from IO completion context, it is run without
    an IO reference.
    
    Hence we can get the situation where the submitter can submit the
    IO, see an error on the buffer and unlock and free the buffer while
    there is still IO in progress. This leads to use-after-free and
    memory corruption.
    
    Fix this by taking a "sync IO hold" reference that is owned by the
    IO and not released until after the buffer completion calls are run
    to wake up synchronous waiters. This means that the buffer will not
    be freed in any circumstance until all IO processing is completed.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit cf53e99d192171a58791136d33fd3fea5d8bab35
Author: Dave Chinner <dchinner@redhat.com>
Date:   Thu Oct 2 09:04:01 2014 +1000

    xfs: Don't use xfs_buf_iowait in the delwri buffer code
    
    For the special case of delwri buffer submission and waiting, we
    don't need to issue IO synchronously at all. The second pass to call
    xfs_buf_iowait() can be replaced with  blocking on xfs_buf_lock() -
    the buffer will be unlocked when the async IO is complete.
    
    This formalises a sane the method of waiting for async IO - take an
    extra reference, submit the IO, call xfs_buf_lock() when you want to
    wait for IO completion. i.e.:
    
    	bp = xfs_buf_find();
    	xfs_buf_hold(bp);
    	bp->b_flags |= XBF_ASYNC;
    	xfs_buf_iosubmit(bp);
    	xfs_buf_lock(bp)
    	error = bp->b_error;
    	....
    	xfs_buf_relse(bp);
    
    While this is somewhat racy for gathering IO errors, none of the
    code that calls xfs_buf_delwri_submit() will race against other
    users of the buffers being submitted. Even if they do, we don't
    really care if the error is detected by the delwri code or the user
    we raced against. Either way, the error will be detected and
    handled.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit a870fe6dfaba1cc67424cde4cfd2cd3eee62bf35
Author: Dave Chinner <dchinner@redhat.com>
Date:   Thu Oct 2 09:02:28 2014 +1000

    xfs: force the log before shutting down
    
    When we have marked the filesystem for shutdown, we want to prevent
    any further buffer IO from being submitted. However, we currently
    force the log after marking the filesystem as shut down, hence
    allowing IO to the log *after* we have marked both the filesystem
    and the log as in an error state.
    
    Clean this up by forcing the log before we mark the filesytem with
    an error. This replaces the pure CIL flush that we currently have
    which works around this same issue (i.e the CIL can't be flushed
    once the shutdown flags are set) and hence enables us to clean up
    the logic substantially.
    
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
