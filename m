Return-Path: <xfs-bounces@oss.sgi.com>
From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, for-next,
	updated. xfs-for-linus-3.15-rc2-47-gd4f8a22
Message-Id: <20140506004535.8F13529DF8@oss.sgi.com>
Date: Mon,  5 May 2014 19:45:35 -0500 (CDT)
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
  d4f8a22 Merge branch 'xfs-fixes-for-3.15-rc5' into for-next
  8275cdd xfs: remote attribute overwrite causes transaction overrun
  d540e43 xfs: initialize default acls for ->tmpfile()
  c99d609 xfs: fully support v5 format filesystems
      from  b8b39d39f94c0d3ea5771d1df3151c569599c20a (commit)

Those revisions listed above that are new to this repository have
not appeared on any other notification email; so we list those
revisions in full, below.

- Log -----------------------------------------------------------------
commit d4f8a227bda5d95a2280bd2a96ad0a0b545349da
Merge: b8b39d3 8275cdd
Author: Dave Chinner <david@fromorbit.com>
Date:   Tue May 6 10:02:13 2014 +1000

    Merge branch 'xfs-fixes-for-3.15-rc5' into for-next

-----------------------------------------------------------------------

Summary of changes:
 fs/xfs/xfs_attr.c        | 24 ++++++++++++++++++++-
 fs/xfs/xfs_attr_leaf.c   | 21 +++++++++---------
 fs/xfs/xfs_attr_list.c   |  1 +
 fs/xfs/xfs_attr_remote.c |  8 ++++---
 fs/xfs/xfs_da_btree.h    |  2 ++
 fs/xfs/xfs_iops.c        | 55 +++++++++++++++++++++++++-----------------------
 fs/xfs/xfs_log.c         | 10 +++++----
 fs/xfs/xfs_mount.c       |  2 --
 fs/xfs/xfs_sb.c          |  4 ----
 9 files changed, 77 insertions(+), 50 deletions(-)


hooks/post-receive
-- 
XFS development tree

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
