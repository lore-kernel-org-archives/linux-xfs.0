Return-Path: <xfs-bounces@oss.sgi.com>
From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, for-next,
	updated. xfs-for-linus-v3.12-rc3-21-g865e944
Message-Id: <20131021215808.2B34B7F55@oss.sgi.com>
Date: Mon, 21 Oct 2013 16:58:07 -0500 (CDT)
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
  865e944 xfs: fold xfs_change_file_space into xfs_ioc_space
  83aee9e xfs: simplify the fallocate path
  5f8aca8 xfs: always hold the iolock when calling xfs_change_file_space
  001a3e7 xfs: remove the unused XFS_ATTR_NONBLOCK flag
  76ca4c2 xfs: always take the iolock around xfs_setattr_size
      from  59e5a0e821d838854b3afd030d31f82cee3ecd58 (commit)

Those revisions listed above that are new to this repository have
not appeared on any other notification email; so we list those
revisions in full, below.

- Log -----------------------------------------------------------------
commit 865e9446b4c17f78be0b1387426394b6bfc278f3
Author: Christoph Hellwig <hch@infradead.org>
Date:   Sat Oct 12 00:55:08 2013 -0700

    xfs: fold xfs_change_file_space into xfs_ioc_space
    
    Now that only one caller of xfs_change_file_space is left it can be merged
    into said caller.
    
    Signed-off-by: Christoph Hellwig <hch@lst.de>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 83aee9e4c2976143f35b3a42ad1faadf58c53ae7
Author: Christoph Hellwig <hch@infradead.org>
Date:   Sat Oct 12 00:55:07 2013 -0700

    xfs: simplify the fallocate path
    
    Call xfs_alloc_file_space or xfs_free_file_space directly from
    xfs_file_fallocate instead of going through xfs_change_file_space.
    
    This simplified the code by removing the unessecary marshalling of the
    arguments into an xfs_flock64_t structure and allows removing checks that
    are already done in the VFS code.
    
    Signed-off-by: Christoph Hellwig <hch@lst.de>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 5f8aca8b43f41c4b2d4dc5389124a40cab92b644
Author: Christoph Hellwig <hch@infradead.org>
Date:   Sat Oct 12 00:55:06 2013 -0700

    xfs: always hold the iolock when calling xfs_change_file_space
    
    Currently fallocate always holds the iolock when calling into
    xfs_change_file_space, while the ioctl path lets some of the lower level
    functions take it, but leave it out in others.
    
    This patch makes sure the ioctl path also always holds the iolock and
    thus introduces consistent locking for the preallocation operations while
    simplifying the code and allowing to kill the now unused XFS_ATTR_NOLOCK
    flag.
    
    Signed-off-by: Christoph Hellwig <hch@lst.de>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 001a3e73706fcb8c52dcca1d4742679384d04184
Author: Christoph Hellwig <hch@infradead.org>
Date:   Sat Oct 12 00:55:05 2013 -0700

    xfs: remove the unused XFS_ATTR_NONBLOCK flag
    
    Signed-off-by: Christoph Hellwig <hch@lst.de>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 76ca4c238cf5858f8ba5bcd24c94c23717f1e14e
Author: Christoph Hellwig <hch@infradead.org>
Date:   Mon Oct 14 07:09:35 2013 -0700

    xfs: always take the iolock around xfs_setattr_size
    
    There is no reason to conditionally take the iolock inside xfs_setattr_size
    when we can let the caller handle it unconditionally, which just incrases
    the lock hold time for the case where it was previously taken internally
    by a few instructions.
    
    Signed-off-by: Christoph Hellwig <hch@lst.de>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

-----------------------------------------------------------------------

Summary of changes:
 fs/xfs/xfs_bmap_util.c | 277 ++++---------------------------------------------
 fs/xfs/xfs_bmap_util.h |   9 +-
 fs/xfs/xfs_file.c      |  76 +++++++++-----
 fs/xfs/xfs_ioctl.c     | 133 ++++++++++++++++++++++--
 fs/xfs/xfs_iops.c      |  39 +++----
 fs/xfs/xfs_iops.h      |   8 +-
 6 files changed, 223 insertions(+), 319 deletions(-)


hooks/post-receive
-- 
XFS development tree

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
