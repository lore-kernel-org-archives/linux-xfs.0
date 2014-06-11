Return-Path: <xfs-bounces@oss.sgi.com>
From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, xfs-libxfs-restructure,
	updated. xfs-for-linus-3.16-rc1-764-gfcec2eb
Message-Id: <20140611090515.5F28F7F69@oss.sgi.com>
Date: Wed, 11 Jun 2014 04:05:14 -0500 (CDT)
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

The branch, xfs-libxfs-restructure has been updated
  discards  d12984ec02037de7af328580075ba1bb88272ffd (commit)
  fcec2eb xfs: global error sign conversion
  e3584e3 libxfs: move source files
      from  d12984ec02037de7af328580075ba1bb88272ffd (commit)

Those revisions listed above that are new to this repository have
not appeared on any other notification email; so we list those
revisions in full, below.

- Log -----------------------------------------------------------------
commit fcec2eb6a31bde491f4ce9ddd94b41c8aacccd43
Author: Dave Chinner <dchinner@redhat.com>
Date:   Wed Jun 11 19:00:50 2014 +1000

    xfs: global error sign conversion
    
    Convert all the errors the core XFs code to negative error signs
    like the rest of the kernel and remove all the sign conversion we
    do in the interface layers.
    
    Errors for conversion (and comparison) found via searches like:
    
    $ git grep " E" fs/xfs
    $ git grep "return E" fs/xfs
    $ git grep " E[A-Z].*;$" fs/xfs
    
    Negation points found via searches like:
    
    $ git grep "= -[a-z,A-Z]" fs/xfs
    $ git grep "return -[a-z,A-D,F-Z]" fs/xfs
    $ git grep " -[a-z].*;" fs/xfs
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>

commit e3584e38615389850684fcffd699d97e2e06f2d6
Author: Dave Chinner <dchinner@redhat.com>
Date:   Wed Jun 11 08:08:14 2014 +1000

    libxfs: move source files
    
    Move all the source files that are shared with userspace into
    libxfs/. This is done as one big chunk simpy to get it done
    quickly
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>

-----------------------------------------------------------------------

Summary of changes:
 fs/xfs/Makefile                        |   7 +-
 fs/xfs/libxfs/xfs_alloc.c              |  20 ++--
 fs/xfs/libxfs/xfs_alloc_btree.c        |   6 +-
 fs/xfs/libxfs/xfs_attr.c               |  50 ++++-----
 fs/xfs/libxfs/xfs_attr_leaf.c          |  44 ++++----
 fs/xfs/libxfs/xfs_attr_remote.c        |  10 +-
 fs/xfs/libxfs/xfs_bmap.c               |  52 +++++-----
 fs/xfs/libxfs/xfs_bmap_btree.c         |  10 +-
 fs/xfs/libxfs/xfs_btree.c              |  14 +--
 fs/xfs/libxfs/xfs_da_btree.c           |  42 ++++----
 fs/xfs/libxfs/xfs_dir2.c               |  24 ++---
 fs/xfs/libxfs/xfs_dir2_block.c         |  16 +--
 fs/xfs/libxfs/xfs_dir2_data.c          |  10 +-
 fs/xfs/libxfs/xfs_dir2_leaf.c          |  22 ++--
 fs/xfs/libxfs/xfs_dir2_node.c          |  40 +++----
 fs/xfs/libxfs/xfs_dir2_sf.c            |  28 ++---
 fs/xfs/libxfs/xfs_dquot_buf.c          |   6 +-
 fs/xfs/libxfs/xfs_ialloc.c             |  32 +++---
 fs/xfs/libxfs/xfs_ialloc_btree.c       |   6 +-
 fs/xfs/libxfs/xfs_inode_buf.c          |  10 +-
 fs/xfs/libxfs/xfs_inode_fork.c         |  30 +++---
 fs/xfs/libxfs/xfs_sb.c                 |  32 +++---
 fs/xfs/libxfs/xfs_symlink_remote.c     |   6 +-
 fs/xfs/xfs_acl.c                       |   8 +-
 fs/xfs/xfs_aops.c                      |  12 +--
 fs/xfs/xfs_attr_inactive.c             |   8 +-
 fs/xfs/xfs_attr_list.c                 |  14 +--
 fs/xfs/xfs_bmap_util.c                 |  78 +++++++-------
 fs/xfs/xfs_buf.c                       |  26 ++---
 fs/xfs/xfs_buf.h                       |   2 +-
 fs/xfs/xfs_buf_item.c                  |   4 +-
 fs/xfs/{libxfs => }/xfs_dir2_readdir.c |   4 +-
 fs/xfs/xfs_discard.c                   |   8 +-
 fs/xfs/xfs_dquot.c                     |  28 ++---
 fs/xfs/xfs_error.c                     |   2 +-
 fs/xfs/xfs_error.h                     |   4 +-
 fs/xfs/xfs_export.c                    |  10 +-
 fs/xfs/xfs_extfree_item.c              |   2 +-
 fs/xfs/xfs_file.c                      |  34 +++---
 fs/xfs/xfs_filestream.c                |   4 +-
 fs/xfs/xfs_fsops.c                     |  42 ++++----
 fs/xfs/xfs_icache.c                    |  46 ++++-----
 fs/xfs/xfs_icache.h                    |  10 +-
 fs/xfs/xfs_inode.c                     |  66 ++++++------
 fs/xfs/xfs_inode_item.c                |   2 +-
 fs/xfs/xfs_ioctl.c                     | 140 ++++++++++++-------------
 fs/xfs/xfs_ioctl32.c                   |  28 ++---
 fs/xfs/xfs_iomap.c                     |  12 +--
 fs/xfs/xfs_iops.c                      |  58 +++++------
 fs/xfs/xfs_itable.c                    |  22 ++--
 fs/xfs/xfs_log.c                       |  52 +++++-----
 fs/xfs/xfs_log_cil.c                   |   6 +-
 fs/xfs/xfs_log_recover.c               | 183 +++++++++++++++++----------------
 fs/xfs/xfs_mount.c                     |  70 ++++++-------
 fs/xfs/xfs_mru_cache.c                 |  14 +--
 fs/xfs/xfs_qm.c                        |  24 ++---
 fs/xfs/xfs_qm_bhv.c                    |   2 +-
 fs/xfs/xfs_qm_syscalls.c               |  24 ++---
 fs/xfs/xfs_quotaops.c                  |  18 ++--
 fs/xfs/xfs_rtalloc.c                   |  20 ++--
 fs/xfs/xfs_rtalloc.h                   |   2 +-
 fs/xfs/xfs_super.c                     |  88 ++++++++--------
 fs/xfs/xfs_symlink.c                   |  30 +++---
 fs/xfs/xfs_trans.c                     |   8 +-
 fs/xfs/xfs_trans_ail.c                 |   4 +-
 fs/xfs/xfs_trans_buf.c                 |  24 ++---
 fs/xfs/xfs_trans_dquot.c               |   4 +-
 fs/xfs/xfs_xattr.c                     |   6 +-
 68 files changed, 884 insertions(+), 886 deletions(-)
 rename fs/xfs/{libxfs => }/xfs_dir2_readdir.c (99%)


hooks/post-receive
-- 
XFS development tree

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
