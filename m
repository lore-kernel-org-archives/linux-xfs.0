Return-Path: <xfs-bounces@oss.sgi.com>
From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, for-next,
	updated. xfs-for-linus-v3.13-rc4-49-g324bb26
Message-Id: <20131218164133.CF8647F4E@oss.sgi.com>
Date: Wed, 18 Dec 2013 10:41:33 -0600 (CST)
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
  324bb26 Merge branch 'xfs-for-linus-v3.13-rc5' into for-next
  ac8809f xfs: abort metadata writeback on permanent errors
  33177f0 xfs: swalloc doesn't align allocations properly
  83a0adc xfs: remove xfsbdstrat error
  6e708bc xfs: align initial file allocations correctly
  718cc6f xfs: fix infinite loop by detaching the group/project hints from user dquot
  5c22727 xfs: fix assertion failure at xfs_setattr_nonsize
  30d161c xfs: fix false assertion at xfs_qm_vop_create_dqattach
  3a8c920 xfs: fix memory leak in xfs_dir2_node_removename
  f94c445 xfs: growfs overruns AGFL buffer on V4 filesystems
  2f42d61 xfs: don't perform discard if the given range length is less than block size
  31978b5 xfs: underflow bug in xfs_attrlist_by_handle()
      from  46f23adf78545c49591619a615edeec41ed5a549 (commit)

Those revisions listed above that are new to this repository have
not appeared on any other notification email; so we list those
revisions in full, below.

- Log -----------------------------------------------------------------
commit 324bb26144e9be037227ff75fae1042d048a15b4
Merge: 46f23ad ac8809f
Author: Ben Myers <bpm@sgi.com>
Date:   Wed Dec 18 10:36:58 2013 -0600

    Merge branch 'xfs-for-linus-v3.13-rc5' into for-next

-----------------------------------------------------------------------

Summary of changes:
 fs/xfs/xfs_bmap.c        | 23 +++++++++++++++++------
 fs/xfs/xfs_bmap_util.c   | 14 ++++++++++++--
 fs/xfs/xfs_buf.c         | 37 ++++++++++++++-----------------------
 fs/xfs/xfs_buf.h         | 11 +++++++----
 fs/xfs/xfs_buf_item.c    | 21 +++++++++++++++++++--
 fs/xfs/xfs_log_recover.c | 13 +++++++++++--
 fs/xfs/xfs_trans_buf.c   | 13 ++++++++++++-
 7 files changed, 92 insertions(+), 40 deletions(-)


hooks/post-receive
-- 
XFS development tree

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
