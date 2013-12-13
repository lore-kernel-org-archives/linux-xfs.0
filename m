Return-Path: <xfs-bounces@oss.sgi.com>
From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, tip-icluster-factor,
	created. v3.12-11693-gf9e5abc
Message-Id: <20131213054649.6846B7F56@oss.sgi.com>
Date: Thu, 12 Dec 2013 23:46:48 -0600 (CST)
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

The branch, tip-icluster-factor has been created
        at  f9e5abcfc5b299a988cf8f9d0ad11e03da14806b (commit)

- Log -----------------------------------------------------------------
commit f9e5abcfc5b299a988cf8f9d0ad11e03da14806b
Author: Jie Liu <jeff.liu@oracle.com>
Date:   Fri Dec 13 15:51:49 2013 +1100

    xfs: use xfs_icluster_size_fsb in xfs_imap
    
    Use xfs_icluster_size_fsb() in xfs_imap().
    
    Signed-off-by: Jie Liu <jeff.liu@oracle.com>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 982e939e4ddc8c00cb478fb4d725d0e3d18971cc
Author: Jie Liu <jeff.liu@oracle.com>
Date:   Fri Dec 13 15:51:49 2013 +1100

    xfs: use xfs_icluster_size_fsb in xfs_ifree_cluster
    
    Use xfs_icluster_size_fsb() in xfs_ifree_cluster(), rename variable
    ninodes to inodes_per_cluster, the latter is more meaningful.
    
    Signed-off-by: Jie Liu <jeff.liu@oracle.com>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 6e0c7b8c3ea62d684af267d34fc015253e7cd6e5
Author: Jie Liu <jeff.liu@oracle.com>
Date:   Fri Dec 13 15:51:49 2013 +1100

    xfs: use xfs_icluster_size_fsb in xfs_ialloc_inode_init
    
    Use xfs_icluster_size_fsb() in xfs_ialloc_inode_init(), rename variable
    ninodes to inodes_per_cluster, the latter is more meaningful.
    
    Signed-off-by: Jie Liu <jeff.liu@oracle.com>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit a2ba07b2d2215bed560aa67c84275304314d9691
Author: Jie Liu <jeff.liu@oracle.com>
Date:   Fri Dec 13 15:51:48 2013 +1100

    xfs: use xfs_icluster_size_fsb in xfs_bulkstat
    
    Use xfs_icluster_size_fsb() in xfs_bulkstat(), make the related
    variables more meaningful and remove an unused variable nimask
    from it.
    
    Signed-off-by: Jie Liu <jeff.liu@oracle.com>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 904957b75033149509dc0fecc0af34348f87c78c
Author: Jie Liu <jeff.liu@oracle.com>
Date:   Fri Dec 13 15:51:48 2013 +1100

    xfs: introduce a common helper xfs_icluster_size_fsb
    
    Introduce a common routine xfs_icluster_size_fsb() to calculate
    and return the number of file system blocks per inode cluster.
    
    Signed-off-by: Jie Liu <jeff.liu@oracle.com>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 126cd105d4408ff52437a72d681aecdb29cc80e8
Author: Jie Liu <jeff.liu@oracle.com>
Date:   Fri Dec 13 15:51:48 2013 +1100

    xfs: get rid of XFS_IALLOC_BLOCKS macros
    
    Get rid of XFS_IALLOC_BLOCKS() marcos, use mp->m_ialloc_blks directly.
    
    Signed-off-by: Jie Liu <jeff.liu@oracle.com>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 0f49efd805229fc747761213ec820c1ba3ab64db
Author: Jie Liu <jeff.liu@oracle.com>
Date:   Fri Dec 13 15:51:48 2013 +1100

    xfs: get rid of XFS_INODE_CLUSTER_SIZE macros
    
    Get rid of XFS_INODE_CLUSTER_SIZE() macros, use mp->m_inode_cluster_size
    directly.
    
    Signed-off-by: Jie Liu <jeff.liu@oracle.com>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 717834383c6ad2173323b823b97c521c9fb8fbbb
Author: Jie Liu <jeff.liu@oracle.com>
Date:   Fri Dec 13 15:51:46 2013 +1100

    xfs: get rid of XFS_IALLOC_INODES macros
    
    Get rid of XFS_IALLOC_INODES() marcos, use mp->m_ialloc_inos directly.
    
    Signed-off-by: Jie Liu <jeff.liu@oracle.com>
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
