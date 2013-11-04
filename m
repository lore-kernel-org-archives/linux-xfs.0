Return-Path: <xfs-bounces@oss.sgi.com>
From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, for-next,
	updated. xfs-for-linus-v3.12-rc3-46-g2732036
Message-Id: <20131104231155.E12817F96@oss.sgi.com>
Date: Mon,  4 Nov 2013 17:11:55 -0600 (CST)
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
  2732036 xfs: xfs_remove deadlocks due to inverted AGF vs AGI lock ordering
  bb86d21 xfs: fix the extent count when allocating an new indirection array entry
      from  10e6e65dfcedff63275c3d649d329c044caa8e26 (commit)

Those revisions listed above that are new to this repository have
not appeared on any other notification email; so we list those
revisions in full, below.

- Log -----------------------------------------------------------------
commit 273203699f82667296e1f14344c5a5a6c4600470
Author: Dave Chinner <dchinner@redhat.com>
Date:   Tue Oct 29 22:11:44 2013 +1100

    xfs: xfs_remove deadlocks due to inverted AGF vs AGI lock ordering
    
    Removing an inode from the namespace involves removing the directory
    entry and dropping the link count on the inode. Removing the
    directory entry can result in locking an AGF (directory blocks were
    freed) and removing a link count can result in placing the inode on
    an unlinked list which results in locking an AGI.
    
    The big problem here is that we have an ordering constraint on AGF
    and AGI locking - inode allocation locks the AGI, then can allocate
    a new extent for new inodes, locking the AGF after the AGI.
    Similarly, freeing the inode removes the inode from the unlinked
    list, requiring that we lock the AGI first, and then freeing the
    inode can result in an inode chunk being freed and hence freeing
    disk space requiring that we lock an AGF.
    
    Hence the ordering that is imposed by other parts of the code is AGI
    before AGF. This means we cannot remove the directory entry before
    we drop the inode reference count and put it on the unlinked list as
    this results in a lock order of AGF then AGI, and this can deadlock
    against inode allocation and freeing. Therefore we must drop the
    link counts before we remove the directory entry.
    
    This is still safe from a transactional point of view - it is not
    until we get to xfs_bmap_finish() that we have the possibility of
    multiple transactions in this operation. Hence as long as we remove
    the directory entry and drop the link count in the first transaction
    of the remove operation, there are no transactional constraints on
    the ordering here.
    
    Change the ordering of the operations in the xfs_remove() function
    to align the ordering of AGI and AGF locking to match that of the
    rest of the code.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Ben Myers <bpm@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit bb86d21cba22a045b09d11b71decf5ca7c3d5def
Author: Jie Liu <jeff.liu@oracle.com>
Date:   Fri Oct 25 14:52:44 2013 +0800

    xfs: fix the extent count when allocating an new indirection array entry
    
    At xfs_iext_add(), if extent(s) are being appended to the last page in
    the indirection array and the new extent(s) don't fit in the page, the
    number of extents(erp->er_extcount) in a new allocated entry should be
    the minimum value between count and XFS_LINEAR_EXTS, instead of count.
    
    For now, there is no existing test case can demonstrates a problem with
    the er_extcount being set incorrectly here, but it obviously like a bug.
    
    Signed-off-by: Jie Liu <jeff.liu@oracle.com>
    Reviewed-by: Ben Myers <bpm@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

-----------------------------------------------------------------------

Summary of changes:
 fs/xfs/xfs_inode.c      | 72 ++++++++++++++++++++++++++++++-------------------
 fs/xfs/xfs_inode_fork.c |  9 +++----
 2 files changed, 48 insertions(+), 33 deletions(-)


hooks/post-receive
-- 
XFS development tree

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
