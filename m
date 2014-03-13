Return-Path: <xfs-bounces@oss.sgi.com>
From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, for-next,
	updated. xfs-for-linus-v3.14-rc1-2-12965-gfe986f9
Message-Id: <20140313083635.CB4C07F80@oss.sgi.com>
Date: Thu, 13 Mar 2014 03:36:34 -0500 (CDT)
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
  discards  7161d06f73f1b3efabd717661a41ecebb4c48e6b (commit)
  discards  14e637ca53fa257cbff7f73981dd87c457a6be1e (commit)
  discards  181d1a1134f5d4924c307ea90708e55c80eaf3b0 (commit)
  discards  f13780692e659df3623461ca5398b66739a6c56f (commit)
  fe986f9 Merge branch 'xfs-O_TMPFILE-support' into for-next
  5f44e4c Merge branch 'xfs-bug-fixes-for-3.15-2' into for-next
  49ae4b9 Merge branch 'xfs-verifier-cleanup' into for-next
  730357a Merge branch 'xfs-stack-fixes' into for-next
  b6db055 Merge branch 'xfs-collapse-range' into for-next
  376ba31 xfs: Add support for FALLOC_FL_ZERO_RANGE
  ab29743 xfs: allow linkat() on O_TMPFILE files
  99b6436 xfs: add O_TMPFILE support
  163467d xfs: factor prid related codes into xfs_get_initial_prid()
      from  7161d06f73f1b3efabd717661a41ecebb4c48e6b (commit)

Those revisions listed above that are new to this repository have
not appeared on any other notification email; so we list those
revisions in full, below.

- Log -----------------------------------------------------------------
commit fe986f9d88ab8079c91669b7f175081f15491a80
Merge: 5f44e4c ab29743
Author: Dave Chinner <david@fromorbit.com>
Date:   Thu Mar 13 19:14:43 2014 +1100

    Merge branch 'xfs-O_TMPFILE-support' into for-next
    
    Conflicts:
    	fs/xfs/xfs_trans_resv.c
    	- fix for XFS_INODE_CLUSTER_SIZE macro removal

commit 5f44e4c185ec5a4a438841cbd4983d0c4a106a4a
Merge: 49ae4b9 fe4c224
Author: Dave Chinner <david@fromorbit.com>
Date:   Thu Mar 13 19:13:05 2014 +1100

    Merge branch 'xfs-bug-fixes-for-3.15-2' into for-next

commit 49ae4b97d760d2e63394b96a7e14cbb43b9dc942
Merge: 730357a ce5028c
Author: Dave Chinner <david@fromorbit.com>
Date:   Thu Mar 13 19:12:33 2014 +1100

    Merge branch 'xfs-verifier-cleanup' into for-next

commit 730357a5cb72d9754a396a350653ff98a9e44783
Merge: b6db055 93a8614
Author: Dave Chinner <david@fromorbit.com>
Date:   Thu Mar 13 19:12:13 2014 +1100

    Merge branch 'xfs-stack-fixes' into for-next

commit b6db0551fddfc8826bc07fc99d64d830530b2d77
Merge: 027f185 376ba31
Author: Dave Chinner <david@fromorbit.com>
Date:   Thu Mar 13 19:11:06 2014 +1100

    Merge branch 'xfs-collapse-range' into for-next

-----------------------------------------------------------------------

Summary of changes:
 fs/xfs/xfs_file.c       |   9 ++--
 fs/xfs/xfs_inode.c      | 123 +++++++++++++++++++++++++++++++++++++++++++++---
 fs/xfs/xfs_inode.h      |  12 +++++
 fs/xfs/xfs_iops.c       |  16 +++++++
 fs/xfs/xfs_shared.h     |   4 +-
 fs/xfs/xfs_symlink.c    |   5 +-
 fs/xfs/xfs_trans_resv.c |  54 +++++++++++++++++++--
 fs/xfs/xfs_trans_resv.h |   2 +
 8 files changed, 207 insertions(+), 18 deletions(-)


hooks/post-receive
-- 
XFS development tree

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
