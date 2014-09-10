Return-Path: <xfs-bounces@oss.sgi.com>
From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, for-next,
	updated. xfs-for-linus-3.17-rc3-12-ga4241ae
Message-Id: <20140910000021.BA0737F6B@oss.sgi.com>
Date: Tue,  9 Sep 2014 19:00:21 -0500 (CDT)
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
  a4241ae Merge branch 'xfs-misc-fixes-for-3.18-1' into for-next
  ab6978c xfs: remove rbpp check from xfs_rtmodify_summary_int
  afabfd3 xfs: combine xfs_rtmodify_summary and xfs_rtget_summary
  b16ed7c xfs: combine xfs_dir_canenter into xfs_dir_createname
  94f3cad xfs: check resblks before calling xfs_dir_canenter
  970fd3f xfs: deduplicate xlog_do_recovery_pass()
  59f9c00 xfs: lseek: the "whence" argument is called "whence"
  49c6959 xfs: combine xfs_seek_hole & xfs_seek_data
  2e22717 xfs: export log_recovery_delay to delay mount time log recovery
  65b6573 xfs: add debug sysfs attribute set
  e1b0572 xfs: add a few more verifier tests
  8018ec0 xfs: mark all internal workqueues as freezable
      from  41b9d7263ea1e270019c5d04fa0ab15db50b9725 (commit)

Those revisions listed above that are new to this repository have
not appeared on any other notification email; so we list those
revisions in full, below.

- Log -----------------------------------------------------------------
commit a4241aebe924136d6838fd516da6daa727fcd728
Merge: 41b9d72 ab6978c
Author: Dave Chinner <david@fromorbit.com>
Date:   Tue Sep 9 13:25:31 2014 +1000

    Merge branch 'xfs-misc-fixes-for-3.18-1' into for-next

-----------------------------------------------------------------------

Summary of changes:
 fs/xfs/libxfs/xfs_alloc.c    |   4 +
 fs/xfs/libxfs/xfs_dir2.c     |  67 +++-------------
 fs/xfs/libxfs/xfs_dir2.h     |   2 +-
 fs/xfs/libxfs/xfs_ialloc.c   |   2 +
 fs/xfs/libxfs/xfs_rtbitmap.c |  49 ++++++++----
 fs/xfs/libxfs/xfs_sb.c       |   2 +
 fs/xfs/xfs_buf.c             |   2 +-
 fs/xfs/xfs_file.c            | 178 +++++++++++++------------------------------
 fs/xfs/xfs_globals.c         |   4 +
 fs/xfs/xfs_inode.c           |  24 +++---
 fs/xfs/xfs_log_recover.c     |  93 ++++++++++------------
 fs/xfs/xfs_mru_cache.c       |   3 +-
 fs/xfs/xfs_rtalloc.c         |  55 +------------
 fs/xfs/xfs_rtalloc.h         |   4 +
 fs/xfs/xfs_super.c           |  38 ++++++---
 fs/xfs/xfs_symlink.c         |   8 +-
 fs/xfs/xfs_sysctl.h          |   5 ++
 fs/xfs/xfs_sysfs.c           |  74 ++++++++++++++++++
 fs/xfs/xfs_sysfs.h           |   1 +
 19 files changed, 290 insertions(+), 325 deletions(-)


hooks/post-receive
-- 
XFS development tree

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
