Return-Path: <xfs-bounces@oss.sgi.com>
From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, for-next,
	updated. v3.18-rc2-23-g216875a
Message-Id: <20141128111637.3A0E47F5F@oss.sgi.com>
Date: Fri, 28 Nov 2014 05:16:36 -0600 (CST)
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
  216875a Merge branch 'xfs-consolidate-format-defs' into for-next
  4bd47c1 Merge branch 'xfs-misc-fixes-for-3.19-1' into for-next
  508b6b3 xfs: merge xfs_inum.h into xfs_format.h
  bb58e61 xfs: move most of xfs_sb.h to xfs_format.h
  4fb6e8a xfs: merge xfs_ag.h into xfs_format.h
  5beda58 xfs: move acl structures to xfs_format.h
  6d3ebaa xfs: merge xfs_dinode.h into xfs_format.h
  db52d09e xfs: catch invalid negative blknos in _xfs_buf_find()
  91ee575 xfs: allow lazy sb counter sync during filesystem freeze sequence
  5d45ee1 xfs: fix error handling in xfs_qm_log_quotaoff()
  062647a xfs: replace on-stack xfs_trans_res with pointer in xfs_create()
  78c931b xfs: replace global xfslogd wq with per-mount wq
      from  002758992693ae63c04122603ea9261a0a58d728 (commit)

Those revisions listed above that are new to this repository have
not appeared on any other notification email; so we list those
revisions in full, below.

- Log -----------------------------------------------------------------
commit 216875a594e0b4fc72830e3690b8fbe7430738e2
Merge: 4bd47c1 508b6b3
Author: Dave Chinner <david@fromorbit.com>
Date:   Fri Nov 28 14:52:16 2014 +1100

    Merge branch 'xfs-consolidate-format-defs' into for-next

commit 4bd47c1bf4a64225a855ed77e259eeb37944ba33
Merge: 0027589 db52d09e
Author: Dave Chinner <david@fromorbit.com>
Date:   Fri Nov 28 14:52:02 2014 +1100

    Merge branch 'xfs-misc-fixes-for-3.19-1' into for-next

-----------------------------------------------------------------------

Summary of changes:
 fs/xfs/libxfs/xfs_ag.h             |  281 ---------
 fs/xfs/libxfs/xfs_alloc.c          |    1 -
 fs/xfs/libxfs/xfs_alloc.h          |    3 +
 fs/xfs/libxfs/xfs_alloc_btree.c    |    1 -
 fs/xfs/libxfs/xfs_attr.c           |    3 -
 fs/xfs/libxfs/xfs_attr_leaf.c      |    2 -
 fs/xfs/libxfs/xfs_attr_remote.c    |    2 -
 fs/xfs/libxfs/xfs_bmap.c           |    3 -
 fs/xfs/libxfs/xfs_bmap_btree.c     |    3 -
 fs/xfs/libxfs/xfs_btree.c          |    2 -
 fs/xfs/libxfs/xfs_da_btree.c       |    2 -
 fs/xfs/libxfs/xfs_da_format.c      |    2 -
 fs/xfs/libxfs/xfs_dinode.h         |  243 --------
 fs/xfs/libxfs/xfs_dir2.c           |    4 -
 fs/xfs/libxfs/xfs_dir2_block.c     |    3 -
 fs/xfs/libxfs/xfs_dir2_data.c      |    2 -
 fs/xfs/libxfs/xfs_dir2_leaf.c      |    2 -
 fs/xfs/libxfs/xfs_dir2_node.c      |    2 -
 fs/xfs/libxfs/xfs_dir2_sf.c        |    3 -
 fs/xfs/libxfs/xfs_dquot_buf.c      |    2 -
 fs/xfs/libxfs/xfs_format.h         | 1107 ++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_ialloc.c         |    3 -
 fs/xfs/libxfs/xfs_ialloc.h         |    4 +
 fs/xfs/libxfs/xfs_ialloc_btree.c   |    2 -
 fs/xfs/libxfs/xfs_inode_buf.c      |    3 -
 fs/xfs/libxfs/xfs_inode_fork.c     |    4 -
 fs/xfs/libxfs/xfs_inum.h           |   60 --
 fs/xfs/libxfs/xfs_log_format.h     |    2 +-
 fs/xfs/libxfs/xfs_log_rlimit.c     |    2 -
 fs/xfs/libxfs/xfs_rtbitmap.c       |    3 -
 fs/xfs/libxfs/xfs_sb.c             |    2 -
 fs/xfs/libxfs/xfs_sb.h             |  584 -------------------
 fs/xfs/libxfs/xfs_symlink_remote.c |    2 -
 fs/xfs/libxfs/xfs_trans_resv.c     |    2 -
 fs/xfs/xfs_acl.c                   |    2 -
 fs/xfs/xfs_acl.h                   |   36 --
 fs/xfs/xfs_aops.c                  |    3 -
 fs/xfs/xfs_attr_inactive.c         |    3 -
 fs/xfs/xfs_attr_list.c             |    3 -
 fs/xfs/xfs_bmap_util.c             |    3 -
 fs/xfs/xfs_buf.c                   |   16 +-
 fs/xfs/xfs_buf_item.c              |    2 +-
 fs/xfs/xfs_dir2_readdir.c          |    3 -
 fs/xfs/xfs_discard.c               |    1 -
 fs/xfs/xfs_dquot.c                 |    2 -
 fs/xfs/xfs_dquot_item.c            |    2 -
 fs/xfs/xfs_error.c                 |    2 -
 fs/xfs/xfs_export.c                |    2 -
 fs/xfs/xfs_extent_busy.c           |    1 -
 fs/xfs/xfs_extfree_item.c          |    3 +-
 fs/xfs/xfs_file.c                  |    3 -
 fs/xfs/xfs_filestream.c            |    3 -
 fs/xfs/xfs_fsops.c                 |    2 -
 fs/xfs/xfs_icache.c                |    2 -
 fs/xfs/xfs_icache.h                |    8 +
 fs/xfs/xfs_icreate_item.c          |    3 +-
 fs/xfs/xfs_inode.c                 |   17 +-
 fs/xfs/xfs_inode.h                 |    2 -
 fs/xfs/xfs_inode_item.c            |    3 -
 fs/xfs/xfs_ioctl.c                 |    3 -
 fs/xfs/xfs_ioctl32.c               |    2 -
 fs/xfs/xfs_iomap.c                 |    3 -
 fs/xfs/xfs_iops.c                  |    3 -
 fs/xfs/xfs_itable.c                |    4 -
 fs/xfs/xfs_linux.h                 |    6 +
 fs/xfs/xfs_log.c                   |    4 +-
 fs/xfs/xfs_log_cil.c               |    3 +-
 fs/xfs/xfs_log_recover.c           |    3 -
 fs/xfs/xfs_message.c               |    3 +-
 fs/xfs/xfs_mount.c                 |   32 +-
 fs/xfs/xfs_mount.h                 |    8 +-
 fs/xfs/xfs_qm.c                    |    2 -
 fs/xfs/xfs_qm_bhv.c                |    2 -
 fs/xfs/xfs_qm_syscalls.c           |   27 +-
 fs/xfs/xfs_quotaops.c              |    2 -
 fs/xfs/xfs_rtalloc.c               |    3 -
 fs/xfs/xfs_super.c                 |   14 +-
 fs/xfs/xfs_symlink.c               |    3 -
 fs/xfs/xfs_trace.c                 |    2 -
 fs/xfs/xfs_trans.c                 |    2 -
 fs/xfs/xfs_trans_ail.c             |    3 +-
 fs/xfs/xfs_trans_buf.c             |    2 -
 fs/xfs/xfs_trans_dquot.c           |    2 -
 fs/xfs/xfs_trans_extfree.c         |    3 +-
 fs/xfs/xfs_trans_inode.c           |    2 -
 fs/xfs/xfs_xattr.c                 |    2 -
 86 files changed, 1190 insertions(+), 1428 deletions(-)
 delete mode 100644 fs/xfs/libxfs/xfs_ag.h
 delete mode 100644 fs/xfs/libxfs/xfs_dinode.h
 delete mode 100644 fs/xfs/libxfs/xfs_inum.h


hooks/post-receive
-- 
XFS development tree

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
