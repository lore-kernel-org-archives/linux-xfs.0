Return-Path: <xfs-bounces@oss.sgi.com>
From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, for-next,
	updated. xfs-for-linus-v3.14-rc1-3-g7c71ee7
Message-Id: <20140124195415.719677FAD@oss.sgi.com>
Date: Fri, 24 Jan 2014 13:54:15 -0600 (CST)
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
  7c71ee7 xfs: allow logical-sector sized O_DIRECT
  6da5417 xfs: rename xfs_buftarg structure members
  f0bc998 xfs: clean up xfs_buftarg
      from  bf3964c188d686424ff7b69a45941851b9f437f0 (commit)

Those revisions listed above that are new to this repository have
not appeared on any other notification email; so we list those
revisions in full, below.

- Log -----------------------------------------------------------------
commit 7c71ee78031c248dca13fc94dea9a4cc217db6cf
Author: Eric Sandeen <sandeen@sandeen.net>
Date:   Tue Jan 21 16:46:23 2014 -0600

    xfs: allow logical-sector sized O_DIRECT
    
    Some time ago, mkfs.xfs started picking the storage physical
    sector size as the default filesystem "sector size" in order
    to avoid RMW costs incurred by doing IOs at logical sector
    size alignments.
    
    However, this means that for a filesystem made with i.e.
    a 4k sector size on an "advanced format" 4k/512 disk,
    512-byte direct IOs are no longer allowed.  This means
    that XFS has essentially turned this AF drive into a hard
    4K device, from the filesystem on up.
    
    XFS's mkfs-specified "sector size" is really just controlling
    the minimum size & alignment of filesystem metadata.
    
    There is no real need to tightly couple XFS's minimal
    metadata size to the minimum allowed direct IO size;
    XFS can continue doing metadata in optimal sizes, but
    still allow smaller DIOs for apps which issue them,
    for whatever reason.
    
    This patch adds a new field to the xfs_buftarg, so that
    we now track 2 sizes:
    
     1) The metadata sector size, which is the minimum unit and
        alignment of IO which will be performed by metadata operations.
     2) The device logical sector size
    
    The first is used internally by the file system for metadata
    alignment and IOs.
    The second is used for the minimum allowed direct IO alignment.
    
    This has passed xfstests on filesystems made with 4k sectors,
    including when run under the patch I sent to ignore
    XFS_IOC_DIOINFO, and issue 512 DIOs anyway.  I also directly
    tested end of block behavior on preallocated, sparse, and
    existing files when we do a 512 IO into a 4k file on a
    4k-sector filesystem, to be sure there were no unexpected
    behaviors.
    
    Signed-off-by: Eric Sandeen <sandeen@redhat.com>
    Reviewed-by: Brian Foster <bfoster@redhat.com>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 6da54179b3f1bb6a302fd5f3b38fae32ee463ed1
Author: Eric Sandeen <sandeen@sandeen.net>
Date:   Tue Jan 21 16:45:52 2014 -0600

    xfs: rename xfs_buftarg structure members
    
    In preparation for adding new members to the structure,
    give these old ones more descriptive names:
    
    	bt_ssize -> bt_meta_sectorsize
    	bt_smask -> bt_meta_sectormask
    
    Signed-off-by: Eric Sandeen <sandeen@redhat.com>
    Reviewed-by: Brian Foster <bfoster@redhat.com>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit f0bc9985fe8bf4377d5557cd7957d9be43ec8861
Author: Eric Sandeen <sandeen@sandeen.net>
Date:   Tue Jan 21 16:44:57 2014 -0600

    xfs: clean up xfs_buftarg
    
    Clean up the xfs_buftarg structure a bit:
    - remove bt_bsize which is never used
    - replace bt_sshift with bt_ssize; we only ever shift it back
    
    Signed-off-by: Eric Sandeen <sandeen@redhat.com>
    Reviewed-by: Brian Foster <bfoster@redhat.com>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

-----------------------------------------------------------------------

Summary of changes:
 fs/xfs/xfs_buf.c   | 14 +++++++++-----
 fs/xfs/xfs_buf.h   | 20 +++++++++++++++++---
 fs/xfs/xfs_file.c  |  7 +++++--
 fs/xfs/xfs_ioctl.c |  2 +-
 4 files changed, 32 insertions(+), 11 deletions(-)


hooks/post-receive
-- 
XFS development tree

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
