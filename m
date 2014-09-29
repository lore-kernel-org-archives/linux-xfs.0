From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, xfs-trans-recover-cleanup,
	created. v3.16-11801-gb818cca
Message-Id: <20140929000259.150717F84@oss.sgi.com>
Date: Sun, 28 Sep 2014 19:02:57 -0500 (CDT)
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

The branch, xfs-trans-recover-cleanup has been created
        at  b818cca1976d1a01754033ac08724e05d07cce8f (commit)

- Log -----------------------------------------------------------------
commit b818cca1976d1a01754033ac08724e05d07cce8f
Author: Dave Chinner <dchinner@redhat.com>
Date:   Mon Sep 29 09:45:54 2014 +1000

    xfs: refactor recovery transaction start handling
    
    Rework the transaction lookup and allocation code in
    xlog_recovery_process_ophdr() to fold two related call-once
    helper functions into a single helper. Then fold in all the
    XLOG_START_TRANS logic to that helper to clean up the remaining
    logic in xlog_recovery_process_ophdr().
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 76560669868d3b4d650d91d9bf467a8d81171766
Author: Dave Chinner <dchinner@redhat.com>
Date:   Mon Sep 29 09:45:42 2014 +1000

    xfs: reorganise transaction recovery item code
    
    The code for managing transactions anf the items for recovery is
    spread across 3 different locations in the file. Move them all
    together so that it is easy to read the code without needing to jump
    long distances in the file.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 88b863db97a18a04c90ebd57d84e1b7863114dcb
Author: Dave Chinner <dchinner@redhat.com>
Date:   Mon Sep 29 09:45:32 2014 +1000

    xfs: fix double free in xlog_recover_commit_trans
    
    When an error occurs during buffer submission in
    xlog_recover_commit_trans(), we free the trans structure twice. Fix
    it by only freeing the structure in the caller regardless of the
    success or failure of the function.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit e9131e50f9d0a632e3011d73f283ba69be0cc682
Author: Dave Chinner <dchinner@redhat.com>
Date:   Mon Sep 29 09:45:18 2014 +1000

    xfs: recovery of XLOG_UNMOUNT_TRANS leaks memory
    
    The XLOG_UNMOUNT_TRANS case skips the transaction, despite the fact
    an unmount record is always in a standalone transaction. Hence
    whenever we come across one of these we need to free the transaction
    structure associated with it as there is no commit record that
    follows it.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit eeb1168810d8a140f6834f8c4975f7bb3277d790
Author: Dave Chinner <dchinner@redhat.com>
Date:   Mon Sep 29 09:45:03 2014 +1000

    xfs: refactor xlog_recover_process_data()
    
    Clean up xlog_recover_process_data() structure in preparation for
    fixing the allocation and freeing context of the transaction being
    recovered.
    
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
