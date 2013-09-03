Return-Path: <xfs-bounces@oss.sgi.com>
From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, master,
	updated. for-linus-v3.11-rc1-2-12225-g1d03c6f
Message-Id: <20130903222005.70ADA7F50@oss.sgi.com>
Date: Tue,  3 Sep 2013 17:20:04 -0500 (CDT)
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

The branch, master has been updated
  1d03c6f xfs: XFS_MOUNT_QUOTA_ALL needed by userspace
  50fc5f7 xfs: dtype changed xfs_dir2_sfe_put_ino to xfs_dir3_sfe_put_ino
      from  914ed44b17dc30ce0d783e8e23fce58a1a92412c (commit)

Those revisions listed above that are new to this repository have
not appeared on any other notification email; so we list those
revisions in full, below.

- Log -----------------------------------------------------------------
commit 1d03c6fa88af35e55047a1f2ab116f0fdf2f55aa
Author: Dave Chinner <dchinner@redhat.com>
Date:   Fri Aug 30 16:21:21 2013 +1000

    xfs: XFS_MOUNT_QUOTA_ALL needed by userspace
    
    So move it to a header file shared with userspace.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 50fc5f7accfeaaaa1bba07725f26945cf8033bb7
Author: Dave Chinner <david@fromorbit.com>
Date:   Mon Sep 2 12:15:59 2013 +1000

    xfs: dtype changed xfs_dir2_sfe_put_ino to xfs_dir3_sfe_put_ino
    
    So fix up the export in xfs_dir2.h that is needed by userspace.
    
    <sigh>
    
    Now xfs_dir3_sfe_put_ino has been made static. Revert 98f7462 ("xfs:
    xfs_dir3_sfe_put_ino can be static") to being non static so that the
    code shared with userspace is identical again.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Ben Myers <bpm@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

-----------------------------------------------------------------------

Summary of changes:
 fs/xfs/xfs_dir2.h       | 5 +++--
 fs/xfs/xfs_dir2_sf.c    | 2 +-
 fs/xfs/xfs_log_format.h | 6 ++++++
 fs/xfs/xfs_quota.h      | 7 -------
 4 files changed, 10 insertions(+), 10 deletions(-)


hooks/post-receive
-- 
XFS development tree

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
