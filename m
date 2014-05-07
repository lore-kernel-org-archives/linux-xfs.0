Return-Path: <xfs-bounces@oss.sgi.com>
From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, for-next,
	updated. xfs-for-linus-3.15-rc2-55-ga3f9298
Message-Id: <20140507080937.32D707F52@oss.sgi.com>
Date: Wed,  7 May 2014 03:09:37 -0500 (CDT)
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
  a3f9298 Merge branch 'xfs-misc-fixes-1-for-3.16' into for-next
  8cfcc3e xfs: fix directory readahead offset off-by-one
  ac98351 xfs: don't sleep in xlog_cil_force_lsn on shutdown
  49abc3a xfs: truncate_setsize should be outside transactions
  b28fd7b xfs: Fix wrong error codes being returned
  3c35337 xfs: remove dquot hints
  f58522c xfs: bulletfproof xfs_qm_scall_trunc_qfiles()
  9da93f9 xfs: fix Q_XQUOTARM ioctl
      from  d4f8a227bda5d95a2280bd2a96ad0a0b545349da (commit)

Those revisions listed above that are new to this repository have
not appeared on any other notification email; so we list those
revisions in full, below.

- Log -----------------------------------------------------------------
commit a3f929877fab0bd5f759a62c9a1b5cf5673525d2
Merge: d4f8a22 8cfcc3e
Author: Dave Chinner <david@fromorbit.com>
Date:   Wed May 7 08:36:30 2014 +1000

    Merge branch 'xfs-misc-fixes-1-for-3.16' into for-next

-----------------------------------------------------------------------

Summary of changes:
 fs/xfs/xfs_dir2_readdir.c |   3 +-
 fs/xfs/xfs_dquot.c        |  53 ++----------
 fs/xfs/xfs_dquot.h        |   2 -
 fs/xfs/xfs_ioctl.c        |   5 +-
 fs/xfs/xfs_ioctl32.c      |   5 +-
 fs/xfs/xfs_iops.c         |  20 ++++-
 fs/xfs/xfs_log.c          |   9 +-
 fs/xfs/xfs_log_cil.c      |  50 +++++++++--
 fs/xfs/xfs_qm.c           | 214 +++++-----------------------------------------
 fs/xfs/xfs_qm_syscalls.c  |   5 +-
 fs/xfs/xfs_quotaops.c     |  29 ++++++-
 11 files changed, 128 insertions(+), 267 deletions(-)


hooks/post-receive
-- 
XFS development tree

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
