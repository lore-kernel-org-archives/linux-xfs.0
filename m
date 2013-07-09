Return-Path: <xfs-bounces@oss.sgi.com>
From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, for-next,
	updated. for-linus-v3.11-rc1-3-g862a629
Message-Id: <20130709205435.CA6D329E10@oss.sgi.com>
Date: Tue,  9 Jul 2013 15:54:35 -0500 (CDT)
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

The branch, for-next has been updated
  862a629 xfs: use get_unused_fd_flags(0) instead of get_unused_fd()
  9cee4c5 xfs: clean up unused codes at xfs_bulkstat()
      from  a69c7c077228b0bef38ccb1d385c099e132fe54b (commit)

Those revisions listed above that are new to this repository have
not appeared on any other notification email; so we list those
revisions in full, below.

- Log -----------------------------------------------------------------
commit 862a62937e76a91da218c1ee4dceb7b0700fed67
Author: Yann Droneaud <ydroneaud@opteya.com>
Date:   Tue Jul 2 18:39:34 2013 +0200

    xfs: use get_unused_fd_flags(0) instead of get_unused_fd()
    
    Macro get_unused_fd() is used to allocate a file descriptor with
    default flags. Those default flags (0) can be "unsafe":
    O_CLOEXEC must be used by default to not leak file descriptor
    across exec().
    
    Instead of macro get_unused_fd(), functions anon_inode_getfd()
    or get_unused_fd_flags() should be used with flags given by userspace.
    If not possible, flags should be set to O_CLOEXEC to provide userspace
    with a default safe behavor.
    
    In a further patch, get_unused_fd() will be removed so that
    new code start using anon_inode_getfd() or get_unused_fd_flags()
    with correct flags.
    
    This patch replaces calls to get_unused_fd() with equivalent call to
    get_unused_fd_flags(0) to preserve current behavor for existing code.
    
    The hard coded flag value (0) should be reviewed on a per-subsystem basis,
    and, if possible, set to O_CLOEXEC.
    
    Signed-off-by: Yann Droneaud <ydroneaud@opteya.com>
    Reviewed-by: Ben Myers <bpm@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 9cee4c5b7b706157554cb06ca949997240da725a
Author: Jie Liu <jeff.liu@oracle.com>
Date:   Mon Jul 1 21:51:32 2013 +0800

    xfs: clean up unused codes at xfs_bulkstat()
    
    There are some unused codes at xfs_bulkstat():
    
    - Variable bp is defined to point to the on-disk inode cluster
      buffer, but it proved to be of no practical help.
    
    - We process the chunks of good inodes which were fetched by iterating
      btree records from an AG.  When processing inodes from each chunk,
      the code recomputing agbno if run into the first inode of a cluster,
      however, the agbno is not being used thereafter.
    
    This patch tries to clean up those things.
    
    Signed-off-by: Jie Liu <jeff.liu@oracle.com>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

-----------------------------------------------------------------------

Summary of changes:
 fs/xfs/xfs_ioctl.c  |  2 +-
 fs/xfs/xfs_itable.c | 28 +---------------------------
 2 files changed, 2 insertions(+), 28 deletions(-)


hooks/post-receive
-- 
XFS development tree

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
