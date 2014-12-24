From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, for-next,
	updated. v3.19-rc1-6-gefdca7a
Message-Id: <20141224040704.035F67F6C@oss.sgi.com>
Date: Tue, 23 Dec 2014 22:07:03 -0600 (CST)
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
  efdca7a Merge branch 'xfs-misc-fixes-for-3.20-1' into for-next
  1a43ec0 xfs: Keep sb_bad_features2 consistent with sb_features2
  77af574 xfs: remove extra newlines from xfs messages
  96ab795 xfs: initialize log buf I/O completion wq on log alloc
  d31a182 xfs: Add support to RENAME_EXCHANGE flag
  dbe1b5c xfs: Make xfs_vn_rename compliant with renameat2() syscall
      from  97bf6af1f928216fd6c5a66e8a57bfa95a659672 (commit)

Those revisions listed above that are new to this repository have
not appeared on any other notification email; so we list those
revisions in full, below.

- Log -----------------------------------------------------------------
commit efdca7aa3c41bce7a092019b3f675fbaa3b8d23f
Merge: d31a182 1a43ec0
Author: Dave Chinner <david@fromorbit.com>
Date:   Wed Dec 24 09:49:53 2014 +1100

    Merge branch 'xfs-misc-fixes-for-3.20-1' into for-next

-----------------------------------------------------------------------

Summary of changes:
 fs/xfs/libxfs/xfs_format.h |  10 ++--
 fs/xfs/xfs_buf_item.c      |   2 +-
 fs/xfs/xfs_inode.c         | 134 ++++++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_inode.h         |   2 +-
 fs/xfs/xfs_iops.c          |  21 +++++--
 fs/xfs/xfs_log.c           |  10 ++--
 fs/xfs/xfs_mount.c         |   5 +-
 fs/xfs/xfs_super.c         |   2 +-
 8 files changed, 163 insertions(+), 23 deletions(-)


hooks/post-receive
-- 
XFS development tree

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
