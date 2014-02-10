Return-Path: <xfs-bounces@oss.sgi.com>
From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, for-next,
	updated. xfs-for-linus-v3.14-rc1-2-12934-g39f30ca
Message-Id: <20140210031746.5D7A67F59@oss.sgi.com>
Date: Sun,  9 Feb 2014 21:17:45 -0600 (CST)
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
  39f30ca Merge branch 'xfs-async-aio-extend' into for-next
  0084826 Merge branch 'xfs-fixes-for-3.15-1' into for-next
  3895e51 xfs: ensure correct log item buffer alignment
  fe60a8a xfs: ensure correct timestamp updates from truncate
  9862f62 xfs: allow appending aio writes
  d531d91 xfs: always use unwritten extents for direct I/O writes
  492185e xfs: remove XFS_TRANS_DEBUG dead code
  4ae69fe xfs: return -E2BIG if hit the maximum size limits of ACLs
  392c6de xfs: sanitize sb_inopblock in xfs_mount_validate_sb
  c6f9726 xfs: convert xfs_log_commit_cil() to void
  410b11a xfs: use tr_qm_dqalloc log reservation for dquot alloc
  c19ec23 xfs: remove unused tr_swrite
  70bbca07 xfs: use tr_growrtalloc for growing rt files
      from  38dbfb59d1175ef458d006556061adeaa8751b72 (commit)

Those revisions listed above that are new to this repository have
not appeared on any other notification email; so we list those
revisions in full, below.

- Log -----------------------------------------------------------------
commit 39f30ca7eaa4fe9224094c7a9964cff36c584dab
Merge: 0084826 9862f62
Author: Dave Chinner <david@fromorbit.com>
Date:   Mon Feb 10 14:14:14 2014 +1100

    Merge branch 'xfs-async-aio-extend' into for-next

commit 008482657169c0276ddd2ba00a1ad14a324b91f0
Merge: 3895e51 492185e
Author: Dave Chinner <david@fromorbit.com>
Date:   Mon Feb 10 14:13:50 2014 +1100

    Merge branch 'xfs-fixes-for-3.15-1' into for-next

-----------------------------------------------------------------------

Summary of changes:
 fs/xfs/xfs_acl.c        |  2 +-
 fs/xfs/xfs_aops.c       |  3 ++-
 fs/xfs/xfs_buf_item.c   | 19 -------------------
 fs/xfs/xfs_dquot.c      |  2 +-
 fs/xfs/xfs_iomap.c      | 10 +++-------
 fs/xfs/xfs_iops.c       | 16 ++++++++--------
 fs/xfs/xfs_log.h        |  2 +-
 fs/xfs/xfs_log_cil.c    | 22 ++++++++++++++++------
 fs/xfs/xfs_rtalloc.c    |  2 +-
 fs/xfs/xfs_sb.c         |  1 +
 fs/xfs/xfs_trans.c      | 12 ++----------
 fs/xfs/xfs_trans_resv.c |  6 ++----
 fs/xfs/xfs_trans_resv.h |  1 -
 13 files changed, 38 insertions(+), 60 deletions(-)


hooks/post-receive
-- 
XFS development tree

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
