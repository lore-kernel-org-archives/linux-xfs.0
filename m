From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, for-next,
	updated. xfs-for-linus-3.17-rc3-62-gbdb119b
Message-Id: <20141002232610.10E007F5A@oss.sgi.com>
Date: Thu,  2 Oct 2014 18:26:09 -0500 (CDT)
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
  bdb119b Merge branch 'xfs-misc-fixes-for-3.18-3' into for-next
  5217793 xfs: xfs_iflush_done checks the wrong log item callback
  da5f109 xfs: flush the range before zero range conversion
  07d0868 xfs: restore buffer_head unwritten bit on ioend cancel
  5cca3f6 xfs: check for null dquot in xfs_quota_calc_throttle()
  04dd1a0 xfs: fix crc field handling in xfs_sb_to/from_disk
  6ee49a2 xfs: don't send null bp to xfs_trans_brelse()
  ce57bcf xfs: check for inode size overflow in xfs_new_eof()
  a872703 xfs: only set extent size hint when asked
  9336e3a xfs: project id inheritance is a directory only flag
  e076b0f xfs: kill time.h
  b1d6cc0 xfs: compat_xfs_bstat does not have forkoff
  75e58ce Merge branch 'xfs-buf-iosubmit' into for-next
  8c15612 xfs: simplify xfs_zero_remaining_bytes
  ba37267 xfs: check xfs_buf_read_uncached returns correctly
  595bff7 xfs: introduce xfs_buf_submit[_wait]
  8b13197 xfs: kill xfs_bioerror_relse
  2718775 xfs: xfs_bioerror can die.
  8dac392 xfs: kill xfs_bdstrat_cb
  61be9c5 xfs: rework xfs_buf_bio_endio error handling
  e8aaba9 xfs: xfs_buf_ioend and xfs_buf_iodone_work duplicate functionality
  e11bb80 xfs: synchronous buffer IO needs a reference
  cf53e99 xfs: Don't use xfs_buf_iowait in the delwri buffer code
  a870fe6d xfs: force the log before shutting down
      from  bd438f825f7badafe56d117ed906488c8541f95f (commit)

Those revisions listed above that are new to this repository have
not appeared on any other notification email; so we list those
revisions in full, below.

- Log -----------------------------------------------------------------
commit bdb119bb6e9d11ee7cd5a28503de060172c3db56
Merge: 75e58ce 5217793
Author: Dave Chinner <david@fromorbit.com>
Date:   Fri Oct 3 09:10:09 2014 +1000

    Merge branch 'xfs-misc-fixes-for-3.18-3' into for-next

commit 75e58ce4c8f354f1a68a8bb8a9692827cdaf3d21
Merge: bd438f8 8c15612
Author: Dave Chinner <david@fromorbit.com>
Date:   Thu Oct 2 09:11:14 2014 +1000

    Merge branch 'xfs-buf-iosubmit' into for-next

-----------------------------------------------------------------------

Summary of changes:
 fs/xfs/kmem.c                |   1 -
 fs/xfs/libxfs/xfs_da_btree.c |   3 +-
 fs/xfs/libxfs/xfs_sb.c       |   5 +
 fs/xfs/time.h                |  36 -----
 fs/xfs/xfs_aops.c            |   7 +
 fs/xfs/xfs_bmap_util.c       |  70 +++------
 fs/xfs/xfs_buf.c             | 353 ++++++++++++++++++++++---------------------
 fs/xfs/xfs_buf.h             |  15 +-
 fs/xfs/xfs_buf_item.c        |   8 +-
 fs/xfs/xfs_fsops.c           |  11 +-
 fs/xfs/xfs_inode.c           |  10 +-
 fs/xfs/xfs_inode.h           |   2 +-
 fs/xfs/xfs_inode_item.c      |   2 +-
 fs/xfs/xfs_ioctl.c           |  20 ++-
 fs/xfs/xfs_ioctl32.c         |   2 +
 fs/xfs/xfs_ioctl32.h         |   3 +-
 fs/xfs/xfs_iomap.c           |   4 +-
 fs/xfs/xfs_linux.h           |   6 +-
 fs/xfs/xfs_log.c             |  59 +++-----
 fs/xfs/xfs_log_recover.c     |  32 ++--
 fs/xfs/xfs_mount.c           |  55 ++++---
 fs/xfs/xfs_rtalloc.c         |  30 ++--
 fs/xfs/xfs_trace.h           |   3 +-
 fs/xfs/xfs_trans_buf.c       |  16 +-
 fs/xfs/xfs_trans_inode.c     |   2 +-
 25 files changed, 337 insertions(+), 418 deletions(-)
 delete mode 100644 fs/xfs/time.h


hooks/post-receive
-- 
XFS development tree

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
