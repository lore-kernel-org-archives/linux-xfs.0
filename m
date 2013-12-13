Return-Path: <xfs-bounces@oss.sgi.com>
From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, tip-log-format,
	created. v3.12-11695-gffda4e8
Message-Id: <20131213054619.498727F51@oss.sgi.com>
Date: Thu, 12 Dec 2013 23:46:17 -0600 (CST)
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

The branch, tip-log-format has been created
        at  ffda4e83aa107ff55345dc583efdb24fca486fb5 (commit)

- Log -----------------------------------------------------------------
commit ffda4e83aa107ff55345dc583efdb24fca486fb5
Author: Christoph Hellwig <hch@infradead.org>
Date:   Fri Dec 13 11:34:08 2013 +1100

    xfs: remove the quotaoff log format from the quotaoff log item
    
    This one doesn't save a whole lot of memory, but still makes the
    code simpler.
    
    Signed-off-by: Christoph Hellwig <hch@lst.de>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit ce8e962939ca12218092f8eb3c8cfb196cd8cc51
Author: Christoph Hellwig <hch@infradead.org>
Date:   Fri Dec 13 11:34:07 2013 +1100

    xfs: remove the dquot log format from the dquot log item
    
    No need to keep the dquot log format around all the time, we can
    easily generate it at iop_format time.
    
    Signed-off-by: Christoph Hellwig <hch@lst.de>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 2f251293b09065118d78ae4e883e5639cc22f94e
Author: Christoph Hellwig <hch@infradead.org>
Date:   Fri Dec 13 11:34:05 2013 +1100

    xfs: remove the inode log format from the inode log item
    
    No need to keep the inode log format around all the time, we can
    easily generate it at iop_format time.
    
    Signed-off-by: Christoph Hellwig <hch@lst.de>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit da7765031de15273d370d18a5354e1d8001ce2a9
Author: Christoph Hellwig <hch@infradead.org>
Date:   Fri Dec 13 11:34:04 2013 +1100

    xfs: format logged extents directly into the CIL
    
    With the new iop_format scheme there is no need to have a temporary buffer
    to format logged extents into, we can do so directly into the CIL.  This
    also allows to remove the shortcut for big endian systems that probably
    hasn't gotten a lot of test coverage for a long time.
    
    Signed-off-by: Christoph Hellwig <hch@lst.de>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit bde7cff67c39227c6ad503394e19e58debdbc5e3
Author: Christoph Hellwig <hch@infradead.org>
Date:   Fri Dec 13 11:34:02 2013 +1100

    xfs: format log items write directly into the linear CIL buffer
    
    Instead of setting up pointers to memory locations in iop_format which then
    get copied into the CIL linear buffer after return move the copy into
    the individual inode items.  This avoids the need to always have a memory
    block in the exact same layout that gets written into the log around, and
    allow the log items to be much more flexible in their in-memory layouts.
    
    The only caveat is that we need to properly align the data for each
    iovec so that don't have structures misaligned in subsequent iovecs.
    
    Note that all log item format routines now need to be careful to modify
    the copy of the item that was placed into the CIL after calls to
    xlog_copy_iovec instead of the in-memory copy.
    
    Signed-off-by: Christoph Hellwig <hch@lst.de>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 1234351cba958cd5d4338172ccfc869a687cd736
Author: Christoph Hellwig <hch@infradead.org>
Date:   Fri Dec 13 11:00:43 2013 +1100

    xfs: introduce xlog_copy_iovec
    
    Add a helper to abstract out filling the log iovecs in the log item
    format handlers.  This will allow us to change the way we do the log
    item formatting more easily.
    
    The copy in the name is a bit confusing for now as it just assigns a
    pointer and lets the CIL code perform the copy, but that will change
    soon.
    
    Signed-off-by: Christoph Hellwig <hch@lst.de>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 3de559fbd04d67473b9be2bd183823c40c4b7557
Author: Christoph Hellwig <hch@infradead.org>
Date:   Fri Dec 13 11:00:43 2013 +1100

    xfs: refactor xfs_inode_item_format
    
    Split out a function to handle the data and attr fork, as well as a
    helper for the really old v1 inodes.
    
    Signed-off-by: Christoph Hellwig <hch@lst.de>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit ce9641d6c981aad0463b2d1455f0b60e5c8671c5
Author: Christoph Hellwig <hch@infradead.org>
Date:   Fri Dec 13 11:00:43 2013 +1100

    xfs: refactor xfs_inode_item_size
    
    Split out two helpers to size the data and attribute to make the
    function more readable.
    
    Signed-off-by: Christoph Hellwig <hch@lst.de>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 7aeb72224120e0c49ba4c93d75f8f0d6a87f6afd
Author: Christoph Hellwig <hch@infradead.org>
Date:   Fri Dec 13 11:00:43 2013 +1100

    xfs: refactor xfs_buf_item_format_segment
    
    Add two helpers to make the code more readable.
    
    Signed-off-by: Christoph Hellwig <hch@lst.de>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 9597df6b26a1988a5a04762711149f98ec6ab388
Author: Christoph Hellwig <hch@infradead.org>
Date:   Fri Dec 13 11:00:42 2013 +1100

    xfs: remove duplicate code in xlog_cil_insert_format_items
    
    Share code that was previously duplicated in two branches.
    
    Signed-off-by: Christoph Hellwig <hch@lst.de>
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
