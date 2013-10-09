Return-Path: <xfs-bounces@oss.sgi.com>
From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, for-next,
	updated. xfs-for-linus-v3.12-rc3-12-g74564fb
Message-Id: <20131009002601.938247FE1@oss.sgi.com>
Date: Tue,  8 Oct 2013 19:26:01 -0500 (CDT)
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
  74564fb xfs: clean up xfs_inactive() error handling, kill VN_INACTIVE_[NO]CACHE
  88877d2 xfs: push down inactive transaction mgmt for ifree
  f7be2d7 xfs: push down inactive transaction mgmt for truncate
  36b21dd xfs: push down inactive transaction mgmt for remote symlinks
  2900a57 xfs: add the inode directory type support to XFS_IOC_FSGEOM
      from  d948709b8e468510d8c855d1e4c9f1cb7b524880 (commit)

Those revisions listed above that are new to this repository have
not appeared on any other notification email; so we list those
revisions in full, below.

- Log -----------------------------------------------------------------
commit 74564fb48cbfcb5b433c1baec1f3158ea638b203
Author: Brian Foster <bfoster@redhat.com>
Date:   Fri Sep 20 11:06:12 2013 -0400

    xfs: clean up xfs_inactive() error handling, kill VN_INACTIVE_[NO]CACHE
    
    The xfs_inactive() return value is meaningless. Turn xfs_inactive()
    into a void function and clean up the error handling appropriately.
    Kill the VN_INACTIVE_[NO]CACHE directives as they are not relevant
    to Linux.
    
    Signed-off-by: Brian Foster <bfoster@redhat.com>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 88877d2b9727a14431bfe48216ff86331ab47ea5
Author: Brian Foster <bfoster@redhat.com>
Date:   Fri Sep 20 11:06:11 2013 -0400

    xfs: push down inactive transaction mgmt for ifree
    
    Push the inode free work performed during xfs_inactive() down into
    a new xfs_inactive_ifree() helper. This clears xfs_inactive() from
    all inode locking and transaction management more directly
    associated with freeing the inode xattrs, extents and the inode
    itself.
    
    Signed-off-by: Brian Foster <bfoster@redhat.com>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit f7be2d7f594cbc7a00902b5427332a1ad519a528
Author: Brian Foster <bfoster@redhat.com>
Date:   Fri Sep 20 11:06:10 2013 -0400

    xfs: push down inactive transaction mgmt for truncate
    
    Create the new xfs_inactive_truncate() function to handle the
    truncate portion of xfs_inactive(). Push the locking and
    transaction management into the new function.
    
    Signed-off-by: Brian Foster <bfoster@redhat.com>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 36b21dde6e899d2f25077b7c239d2d6bcff17d73
Author: Brian Foster <bfoster@redhat.com>
Date:   Fri Sep 20 11:06:09 2013 -0400

    xfs: push down inactive transaction mgmt for remote symlinks
    
    Push down the transaction management for remote symlinks from
    xfs_inactive() down to xfs_inactive_symlink_rmt(). The latter is
    cleaned up to avoid transaction management intended for the
    calling context (i.e., trans duplication, reservation, item
    attachment).
    
    Signed-off-by: Brian Foster <bfoster@redhat.com>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 2900a579abcea13e4e77c40f89eb16eeecb5508e
Author: Mark Tinguely <tinguely@sgi.com>
Date:   Wed Oct 2 16:00:06 2013 -0500

    xfs: add the inode directory type support to XFS_IOC_FSGEOM
    
    Add the inode type directory type support to XFS_IOC_FSGEOM
    so that xfs_repair/xfs_info knows if the superblock v4 filesystem
    enabled the feature.
    
    Signed-off-by: Mark Tinguely <tinguely@sgi.com>
    Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

-----------------------------------------------------------------------

Summary of changes:
 fs/xfs/xfs_fs.h      |   4 +-
 fs/xfs/xfs_fsops.c   |   4 +-
 fs/xfs/xfs_inode.c   | 241 +++++++++++++++++++++++++++++----------------------
 fs/xfs/xfs_inode.h   |   2 +-
 fs/xfs/xfs_symlink.c |  86 +++++++++---------
 fs/xfs/xfs_symlink.h |   2 +-
 fs/xfs/xfs_vnode.h   |   8 --
 7 files changed, 185 insertions(+), 162 deletions(-)


hooks/post-receive
-- 
XFS development tree

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
