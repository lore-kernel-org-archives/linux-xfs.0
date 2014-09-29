From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, xfs-sparse-fixes,
	created. v3.16-11811-gb972d07
Message-Id: <20140929010115.084977FA7@oss.sgi.com>
Date: Sun, 28 Sep 2014 20:01:14 -0500 (CDT)
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

The branch, xfs-sparse-fixes has been created
        at  b972d0797180d8414351d9dc8ff65071c692d058 (commit)

- Log -----------------------------------------------------------------
commit b972d0797180d8414351d9dc8ff65071c692d058
Author: Dave Chinner <dchinner@redhat.com>
Date:   Mon Sep 29 10:46:22 2014 +1000

    xfs: annotate user variables passed as void
    
    Some argument callbacks can contain user buffers, and sparse warns
    about passing them as void pointers. Cast appropriately to remove
    the sparse warnings.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit e3aed1a08190c038c4ea41b73ea6f07bc0e3290c
Author: Dave Chinner <dchinner@redhat.com>
Date:   Mon Sep 29 10:46:08 2014 +1000

    xfs: xfs_kset should be static
    
    As it is accessed through the struct xfs_mount and can be set up
    entirely from fs/xfs/xfs_super.c
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit bf1ed3833078e3bb0ba8cd03468090b9359d0912
Author: Dave Chinner <dchinner@redhat.com>
Date:   Mon Sep 29 10:43:40 2014 +1000

    xfs: xfs_qm_dquot_isolate needs locking annotations for sparse
    
    To remove noise from the build.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit e68ed77521f695d165cbae070f6dda8a4778438f
Author: Dave Chinner <david@fromorbit.com>
Date:   Mon Sep 29 10:43:15 2014 +1000

    xfs: fix use of agi_newino in finobt lookup
    
    Sparse warns that we are passing the big-endian valueo f agi_newino
    to the initial btree lookup function when trying to find a new
    inode. This is wrong - we need to pass the host order value, not the
    disk order value. This will adversely affect the next inode
    allocated, but given that the free inode btree is usually much
    smaller than the allocated inode btree it is much less likely to be
    a performance issue if we start the search in the wrong place.
    
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
