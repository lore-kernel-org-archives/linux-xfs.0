From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, xfs-misc-fixes-for-3.20-1,
	created. v3.19-rc1-3-g1a43ec0
Message-Id: <20141224040647.C80D27F66@oss.sgi.com>
Date: Tue, 23 Dec 2014 22:06:47 -0600 (CST)
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

The branch, xfs-misc-fixes-for-3.20-1 has been created
        at  1a43ec03ddd40793db00dbc7340685f5accf6fc3 (commit)

- Log -----------------------------------------------------------------
commit 1a43ec03ddd40793db00dbc7340685f5accf6fc3
Author: Jan Kara <jack@suse.cz>
Date:   Wed Dec 24 09:48:35 2014 +1100

    xfs: Keep sb_bad_features2 consistent with sb_features2
    
    Currently when we modify sb_features2, we store the same value also in
    sb_bad_features2. However in most places we forget to mark field
    sb_bad_features2 for logging and thus it can happen that a change to it
    is lost. This results in an inconsistent sb_features2 and
    sb_bad_features2 fields e.g. after xfstests test xfs/187.
    
    Fix the problem by changing XFS_SB_FEATURES2 to actually mean both
    sb_features2 and sb_bad_features2 fields since this is always what we
    want to log. This isn't ideal because the fact that XFS_SB_FEATURES2
    means two fields could cause some problem in future however the code is
    hopefully less error prone that it is now.
    
    Signed-off-by: Jan Kara <jack@suse.cz>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 77af574eef78c404ea630f7955a5ed0c926a63fe
Author: Eric Sandeen <sandeen@redhat.com>
Date:   Wed Dec 24 09:47:27 2014 +1100

    xfs: remove extra newlines from xfs messages
    
    xfs_warn() and friends add a newline by default, but some
    messages add another one.
    
    Particularly for the failing write message below, this can
    waste a lot of console real estate!
    
    Signed-off-by: Eric Sandeen <sandeen@redhat.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 96ab7954bca0eeedfb17094719db1351fba361d3
Author: Brian Foster <bfoster@redhat.com>
Date:   Wed Dec 24 09:46:23 2014 +1100

    xfs: initialize log buf I/O completion wq on log alloc
    
    Log buffer I/O completion passes through the high priority
    m_log_workqueue rather than the default metadata buffer workqueue. The
    log buffer wq is initialized at I/O submission time. The log buffers are
    reused once initialized, however, so this is not necessary.
    
    Initialize the log buffer I/O completion workqueue pointers once when
    the log is allocated and log buffers initialized rather than on every
    log buffer I/O submission.
    
    Signed-off-by: Brian Foster <bfoster@redhat.com>
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
