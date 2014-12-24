From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, xfs-renameat-extensions,
	created. v3.19-rc1-2-gd31a182
Message-Id: <20141224040628.C4EDE7F5F@oss.sgi.com>
Date: Tue, 23 Dec 2014 22:06:28 -0600 (CST)
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

The branch, xfs-renameat-extensions has been created
        at  d31a1825450062b85282b4afed1c840fd306d012 (commit)

- Log -----------------------------------------------------------------
commit d31a1825450062b85282b4afed1c840fd306d012
Author: Carlos Maiolino <cmaiolino@redhat.com>
Date:   Wed Dec 24 08:51:42 2014 +1100

    xfs: Add support to RENAME_EXCHANGE flag
    
    Adds a new function named xfs_cross_rename(), responsible for
    handling requests from sys_renameat2() using RENAME_EXCHANGE flag.
    
    Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
    Reviewed-by: Brian Foster <bfoster@redhat.com>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit dbe1b5ca26396b6c61d711c8ac4de13ebb02e9f6
Author: Carlos Maiolino <cmaiolino@redhat.com>
Date:   Wed Dec 24 08:51:38 2014 +1100

    xfs: Make xfs_vn_rename compliant with renameat2() syscall
    
    To be able to support RENAME_EXCHANGE flag from renameat2() system
    call, XFS must have its inode_operations updated, exporting .rename2
    method, instead of .rename.
    
    This patch just replaces the (now old) .rename method by .rename2,
    using the same infra-structure, but checking rename flags.  Calls to
    .rename2 using RENAME_EXCHANGE flag, although now handled inside
    XFS, still return -EINVAL.
    
    RENAME_NOREPLACE is handled via VFS and we don't need to care about
    it inside xfs_vn_rename.
    
    Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
    Reviewed-by: Brian Foster <bfoster@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

-----------------------------------------------------------------------


hooks/post-receive
-- 
XFS development tree

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
