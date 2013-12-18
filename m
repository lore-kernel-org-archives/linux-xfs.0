Return-Path: <xfs-bounces@oss.sgi.com>
From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch,
	xfs-extent-list-locking-fixes, created. v3.12-11696-geef334e
Message-Id: <20131218221041.787A07F4E@oss.sgi.com>
Date: Wed, 18 Dec 2013 16:10:40 -0600 (CST)
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

The branch, xfs-extent-list-locking-fixes has been created
        at  eef334e5776c8ef547ada4cec17549929fe590b4 (commit)

- Log -----------------------------------------------------------------
commit eef334e5776c8ef547ada4cec17549929fe590b4
Author: Christoph Hellwig <hch@infradead.org>
Date:   Fri Dec 6 12:30:17 2013 -0800

    xfs: assert that we hold the ilock for extent map access
    
    Make sure that xfs_bmapi_read has the ilock held in some way, and that
    xfs_bmapi_write, xfs_bmapi_delay, xfs_bunmapi and xfs_iread_extents are
    called with the ilock held exclusively.
    
    Signed-off-by: Christoph Hellwig <hch@lst.de>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 568d994e9f53657cb6b3e9c95a83c130d36f83c9
Author: Christoph Hellwig <hch@infradead.org>
Date:   Fri Dec 6 12:30:16 2013 -0800

    xfs: use xfs_ilock_attr_map_shared in xfs_attr_list_int
    
    We might not have read in the extent list at this point, so make sure we
    take the ilock exclusively if we have to do so.
    
    Signed-off-by: Christoph Hellwig <hch@lst.de>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 683cb941598d1d81283c940c100e0ce40f494105
Author: Christoph Hellwig <hch@infradead.org>
Date:   Fri Dec 6 12:30:15 2013 -0800

    xfs: use xfs_ilock_attr_map_shared in xfs_attr_get
    
    We might not have read in the extent list at this point, so make sure we
    take the ilock exclusively if we have to do so.
    
    Signed-off-by: Christoph Hellwig <hch@lst.de>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit da51d32d4596a14ee33917b9eca056d4bf41706a
Author: Christoph Hellwig <hch@infradead.org>
Date:   Fri Dec 6 12:30:14 2013 -0800

    xfs: use xfs_ilock_data_map_shared in xfs_qm_dqiterate
    
    We might not have read in the extent list at this point, so make sure we
    take the ilock exclusively if we have to do so.
    
    Signed-off-by: Christoph Hellwig <hch@lst.de>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit f4df8adc8325127ff015ef9c2a8f005edaaedd07
Author: Christoph Hellwig <hch@infradead.org>
Date:   Fri Dec 6 12:30:13 2013 -0800

    xfs: use xfs_ilock_data_map_shared in xfs_qm_dqtobp
    
    We might not have read in the extent list at this point, so make sure we
    take the ilock exclusively if we have to do so.
    
    Signed-off-by: Christoph Hellwig <hch@lst.de>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 4f317369d46956ccd76b5d28cf66b3f8b24f3480
Author: Christoph Hellwig <hch@infradead.org>
Date:   Fri Dec 6 12:30:12 2013 -0800

    xfs: take the ilock around xfs_bmapi_read in xfs_zero_remaining_bytes
    
    Signed-off-by: Christoph Hellwig <hch@lst.de>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 40194ecc6d78327d98e66de3213db96ca0a31e6f
Author: Ben Myers <bpm@sgi.com>
Date:   Fri Dec 6 12:30:11 2013 -0800

    xfs: reinstate the ilock in xfs_readdir
    
    Although it was removed in commit 051e7cd44ab8, ilock needs to be taken in
    xfs_readdir because we might have to read the extent list in from disk.  This
    keeps other threads from reading from or writing to the extent list while it is
    being read in and is still in a transitional state.
    
    This has been associated with "Access to block zero" messages on directories
    with large numbers of extents resulting from excessive filesytem fragmentation,
    as well as extent list corruption.  Unfortunately no test case at this point.
    
    Signed-off-by: Ben Myers <bpm@sgi.com>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>

commit efa70be165497826f674846f681e6e2364af906c
Author: Christoph Hellwig <hch@infradead.org>
Date:   Wed Dec 18 02:14:39 2013 -0800

    xfs: add xfs_ilock_attr_map_shared
    
    Equivalent to xfs_ilock_data_map_shared, except for the attribute fork.
    
    Make xfs_getbmap use it if called for the attribute fork instead of
    xfs_ilock_data_map_shared.
    
    Signed-off-by: Christoph Hellwig <hch@lst.de>
    Reviewed-by: Ben Myers <bpm@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 309ecac8e7c937c5811ef8f0efc14b3d1bd18775
Author: Christoph Hellwig <hch@infradead.org>
Date:   Fri Dec 6 12:30:09 2013 -0800

    xfs: rename xfs_ilock_map_shared
    
    Make it clear that we're only locking against the extent map on the data
    fork.  Also clean the function up a little bit.
    
    Signed-off-by: Christoph Hellwig <hch@lst.de>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 01f4f3277556d4f4f833371db0219b0ca11c5409
Author: Christoph Hellwig <hch@infradead.org>
Date:   Fri Dec 6 12:30:08 2013 -0800

    xfs: remove xfs_iunlock_map_shared
    
    We can just use xfs_iunlock without any loss of clarity.
    
    Signed-off-by: Christoph Hellwig <hch@lst.de>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 30ba7ad54335e4715d3cc9cc8f43cbf1b3535e46
Author: Christoph Hellwig <hch@infradead.org>
Date:   Fri Dec 6 12:30:07 2013 -0800

    xfs: no need to lock the inode in xfs_find_handle
    
    Both the inode number and the generation do not change on a live inode.
    
    Signed-off-by: Christoph Hellwig <hch@lst.de>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

-----------------------------------------------------------------------


hooks/post-receive
-- 
XFS development tree

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
