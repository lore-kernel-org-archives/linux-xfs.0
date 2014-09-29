From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, for-next,
	updated. xfs-for-linus-3.17-rc3-33-g2f43bbd
Message-Id: <20140929000314.2D6447F92@oss.sgi.com>
Date: Sun, 28 Sep 2014 19:03:13 -0500 (CDT)
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
  2f43bbd Merge branch 'xfs-trans-recover-cleanup' into for-next
  b818cca xfs: refactor recovery transaction start handling
  7656066 xfs: reorganise transaction recovery item code
  88b863d xfs: fix double free in xlog_recover_commit_trans
  e9131e5 xfs: recovery of XLOG_UNMOUNT_TRANS leaks memory
  eeb1168 xfs: refactor xlog_recover_process_data()
      from  33044dc408e6e6bb7f270c0a2e12598ef5592987 (commit)

Those revisions listed above that are new to this repository have
not appeared on any other notification email; so we list those
revisions in full, below.

- Log -----------------------------------------------------------------
commit 2f43bbd96e43d0b85803f5092be94bbb92d8eac9
Merge: 33044dc b818cca
Author: Dave Chinner <david@fromorbit.com>
Date:   Mon Sep 29 10:00:24 2014 +1000

    Merge branch 'xfs-trans-recover-cleanup' into for-next

-----------------------------------------------------------------------

Summary of changes:
 fs/xfs/xfs_log_recover.c | 564 ++++++++++++++++++++++++++---------------------
 1 file changed, 308 insertions(+), 256 deletions(-)


hooks/post-receive
-- 
XFS development tree

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
