Return-Path: <xfs-bounces@oss.sgi.com>
From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, for-next,
	updated. v3.10-rc1-43-g80a4049
Message-Id: <20130626174451.035137F59@oss.sgi.com>
Date: Wed, 26 Jun 2013 12:44:50 -0500 (CDT)
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
  80a4049 xfs: Remove dead function prototype xfs_sync_inode_grab()
  43df2ee xfs: Remove the left function variable from xfs_ialloc_get_rec()
  427d9fe xfs: check on-disk (not incore) btree root size in dfrag.c
  39a45d8 xfs: Remove XFS_MOUNT_RETERR
      from  2fb8b5027dbde32a45edf5f3d7ee082be9261d93 (commit)

Those revisions listed above that are new to this repository have
not appeared on any other notification email; so we list those
revisions in full, below.

- Log -----------------------------------------------------------------
commit 80a4049813a2ae0977d8e5db78e711c7f21c420b
Author: Jie Liu <jeff.liu@oracle.com>
Date:   Mon Jun 24 13:38:34 2013 +0800

    xfs: Remove dead function prototype xfs_sync_inode_grab()
    
    Remove dead function prototype xfs_sync_inode_grab()
    from xfs_icache.h.
    
    Signed-off-by: Jie Liu <jeff.liu@oracle.com>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 43df2ee659d3d854d17686f8f38fc1071b25774b
Author: Jie Liu <jeff.liu@oracle.com>
Date:   Mon Jun 24 13:37:23 2013 +0800

    xfs: Remove the left function variable from xfs_ialloc_get_rec()
    
    This patch clean out the left function variable as it is
    useless to xfs_ialloc_get_rec().
    
    Signed-off-by: Jie Liu <jeff.liu@oracle.com>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 427d9fe233ccec3a293be4bcf07f9bac12463a99
Author: Eric Sandeen <sandeen@redhat.com>
Date:   Tue Mar 27 15:40:26 2012 -0500

    xfs: check on-disk (not incore) btree root size in dfrag.c
    
    xfs_swap_extents_check_format() contains checks to make sure that
    original and the temporary files during defrag are compatible;
    Gabriel VLASIU ran into a case where xfs_fsr returned EINVAL
    because the tests found the btree root to be of size 120,
    while the fork offset was only 104; IOW, they overlapped.
    
    However, this is just due to an error in the
    xfs_swap_extents_check_format() tests, because it is checking
    the in-memory btree root size against the on-disk fork offset.
    We should be checking the on-disk sizes in both cases.
    
    This patch adds a new macro to calculate this size, and uses
    it in the tests.
    
    With this change, the filesystem image provided by Gabriel
    allows for proper file degragmentation.
    
    Reported-by: Gabriel VLASIU <gabriel@vlasiu.net>
    Signed-off-by: Eric Sandeen <sandeen@redhat.com>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 39a45d8463d98ea57347b871641136be64b216a9
Author: Jie Liu <jeff.liu@oracle.com>
Date:   Thu May 2 19:27:47 2013 +0800

    xfs: Remove XFS_MOUNT_RETERR
    
    XFS_MOUNT_RETERR is going to be set at xfs_parseargs() if
    mp->m_dalign is enabled, so any time we enter "if (mp->m_dalign)"
    branch in xfs_update_alignment(), XFS_MOUNT_RETERR is set and so
    we always be emitting a warning and returning an error.
    
    Hence, we can remove it and get rid of a couple of redundant
    check up against it at xfs_upate_alignment().
    
    Thanks Dave Chinner for the suggestions of simplify the code
    in xfs_parseargs().
    
    Signed-off-by: Jie Liu <jeff.liu@oracle.com>
    Cc: Dave Chinner <dchinner@redhat.com>
    Cc: Mark Tinguely <tinguely@sgi.com>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

-----------------------------------------------------------------------

Summary of changes:
 fs/xfs/xfs_bmap_btree.h |  2 ++
 fs/xfs/xfs_dfrag.c      |  8 +++++---
 fs/xfs/xfs_ialloc.c     |  7 +++----
 fs/xfs/xfs_icache.h     |  1 -
 fs/xfs/xfs_mount.c      | 37 +++++++++++--------------------------
 fs/xfs/xfs_mount.h      |  2 --
 fs/xfs/xfs_super.c      | 11 +++--------
 7 files changed, 24 insertions(+), 44 deletions(-)


hooks/post-receive
-- 
XFS development tree

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
