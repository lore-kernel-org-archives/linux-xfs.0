Return-Path: <xfs-bounces@oss.sgi.com>
From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, xfs-async-aio-extend,
	created. xfs-for-linus-v3.14-rc1-2-12923-g9862f62
Message-Id: <20140210031723.8C7C27F55@oss.sgi.com>
Date: Sun,  9 Feb 2014 21:17:22 -0600 (CST)
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

The branch, xfs-async-aio-extend has been created
        at  9862f62faba8c279ac07415a6f610041116fbdc0 (commit)

- Log -----------------------------------------------------------------
commit 9862f62faba8c279ac07415a6f610041116fbdc0
Author: Christoph Hellwig <hch@infradead.org>
Date:   Mon Feb 10 10:28:04 2014 +1100

    xfs: allow appending aio writes
    
    XFS can easily support appending aio writes by ensuring we always allocate
    blocks as unwritten extents when performing direct I/O writes and only
    converting them to written extents at I/O completion.
    
    Signed-off-by: Christoph Hellwig <hch@lst.de>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit d531d91d69902e55633ed834f531aa0b48d618cc
Author: Christoph Hellwig <hch@infradead.org>
Date:   Mon Feb 10 10:27:43 2014 +1100

    xfs: always use unwritten extents for direct I/O writes
    
    To allow aio writes beyond i_size we need to create unwritten extents for
    newly allocated blocks, similar to how we already do inside i_size.
    
    Instead of adding another special case we now use unwritten extents
    unconditionally.  This also marks the end of directly allocation data
    extents in all of XFS - we now always use either delalloc or unwritten
    extents.
    
    Signed-off-by: Christoph Hellwig <hch@lst.de>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 6039257378e4c84da06e68230b14fef955508ce6
Author: Christoph Hellwig <hch@infradead.org>
Date:   Mon Feb 10 10:27:11 2014 +1100

    direct-io: add flag to allow aio writes beyond i_size
    
    Some filesystems can handle direct I/O writes beyond i_size safely,
    so allow them to opt into receiving them.
    
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
