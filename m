Return-Path: <xfs-bounces@oss.sgi.com>
From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, for-next,
	updated. xfs-for-linus-v3.14-rc1-2-12959-g7161d06
Message-Id: <20140307054420.E8D9C7F56@oss.sgi.com>
Date: Thu,  6 Mar 2014 23:44:19 -0600 (CST)
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
  7161d06 Merge branch 'xfs-bug-fixes-for-3.15-2' into for-next
  fe4c224 xfs: inode log reservations are still too small
  a49935f xfs: xfs_check_page_type buffer checks need help
  e480a72 xfs: avoid AGI/AGF deadlock scenario for inode chunk allocation
  ae687e5 xfs: use NOIO contexts for vm_map_ram
  ac75a1f xfs: don't leak EFSBADCRC to userspace
      from  14e637ca53fa257cbff7f73981dd87c457a6be1e (commit)

Those revisions listed above that are new to this repository have
not appeared on any other notification email; so we list those
revisions in full, below.

- Log -----------------------------------------------------------------
commit 7161d06f73f1b3efabd717661a41ecebb4c48e6b
Merge: 14e637c fe4c224
Author: Dave Chinner <david@fromorbit.com>
Date:   Fri Mar 7 16:22:13 2014 +1100

    Merge branch 'xfs-bug-fixes-for-3.15-2' into for-next

-----------------------------------------------------------------------

Summary of changes:
 fs/xfs/kmem.c           | 21 ++++++++++++-
 fs/xfs/xfs_aops.c       | 81 ++++++++++++++++++++++++++++++-------------------
 fs/xfs/xfs_buf.c        | 11 +++++++
 fs/xfs/xfs_ialloc.c     | 12 ++++++++
 fs/xfs/xfs_mount.c      |  3 ++
 fs/xfs/xfs_symlink.c    |  4 +++
 fs/xfs/xfs_trans_buf.c  | 11 +++++++
 fs/xfs/xfs_trans_resv.c | 22 +++++++++-----
 8 files changed, 126 insertions(+), 39 deletions(-)


hooks/post-receive
-- 
XFS development tree

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
