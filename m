Return-Path: <xfs-bounces@oss.sgi.com>
From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, for-next,
	updated. xfs-for-linus-3.16-rc1-13107-g2451337
Message-Id: <20140625060326.EE3C47F51@oss.sgi.com>
Date: Wed, 25 Jun 2014 01:03:25 -0500 (CDT)
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
  2451337 xfs: global error sign conversion
  30f712c libxfs: move source files
  84be0ff libxfs: move header files
  69116a1 xfs: create libxfs infrastructure
  b474c7a xfs: Nuke XFS_ERROR macro
  d99831f xfs: return is not a function
      from  a497c3ba1d97fc69c1e78e7b96435ba8c2cb42ee (commit)

Those revisions listed above that are new to this repository have
not appeared on any other notification email; so we list those
revisions in full, below.

- Log -----------------------------------------------------------------
commit 2451337dd043901b5270b7586942abe564443e3d
Author: Dave Chinner <dchinner@redhat.com>
Date:   Wed Jun 25 14:58:08 2014 +1000

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
    
    [ with some bits I missed from Brian Foster ]
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Brian Foster <bfoster@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 30f712c9dd69348aa51351d5cb6d366bf4fae31d
Author: Dave Chinner <dchinner@redhat.com>
Date:   Wed Jun 25 14:57:53 2014 +1000

    libxfs: move source files
    
    Move all the source files that are shared with userspace into
    libxfs/. This is done as one big chunk simpy to get it done
    quickly
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Brian Foster <bfoster@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 84be0ffc9043f7c56044294eb775a2200452c76d
Author: Dave Chinner <dchinner@redhat.com>
Date:   Wed Jun 25 14:57:36 2014 +1000

    libxfs: move header files
    
    Move all the header files that are shared with userspace into
    libxfs. This is done as one big chunk simpy to get it done quickly.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Brian Foster <bfoster@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 69116a1317ce3d2292e062bfb1a22757b95dcd06
Author: Dave Chinner <dchinner@redhat.com>
Date:   Wed Jun 25 14:57:22 2014 +1000

    xfs: create libxfs infrastructure
    
    To minimise the differences between kernel and userspace code,
    split the kernel code into the same structure as the userspace code.
    That is, the gneric core functionality of XFS is moved to a libxfs/
    directory and treat it as a layering barrier in the XFS code.
    
    This patch introduces the libxfs directory, the build infrastructure
    and an initial source and header file to build. The libxfs directory
    will contain the header files that are needed to build libxfs - most
    of userspace does not care about the location of these header files
    as they are accessed indirectly. Hence keeping them inside libxfs
    makes it easy to track the changes and script the sync process as
    the directory structure will be identical.
    
    To allow this changeover to occur in the kernel code, there are some
    temporary infrastructure in the makefiles to grab the header
    filesystem from both locations. Once all the files are moved,
    modifications will be made in the source code that will make the
    need for these include directives go away.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Brian Foster <bfoster@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit b474c7ae4395ba684e85fde8f55c8cf44a39afaf
Author: Eric Sandeen <sandeen@sandeen.net>
Date:   Sun Jun 22 15:04:54 2014 +1000

    xfs: Nuke XFS_ERROR macro
    
    XFS_ERROR was designed long ago to trap return values, but it's not
    runtime configurable, it's not consistently used, and we can do
    similar error trapping with ftrace scripts and triggers from
    userspace.
    
    Just nuke XFS_ERROR and associated bits.
    
    Signed-off-by: Eric Sandeen <sandeen@redhat.com>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit d99831ff393ff2e28d6110b41f24d9fecf986222
Author: Eric Sandeen <sandeen@sandeen.net>
Date:   Sun Jun 22 15:03:54 2014 +1000

    xfs: return is not a function
    
    return is not a function.  "return(EIO);" is silly;
    "return (EIO);" moreso.  return is not a function.
    Nuke the pointless parens.
    
    [dchinner: catch a couple of extra cases in xfs_attr_list.c,
    xfs_acl.c and xfs_linux.h.]
    
    Signed-off-by: Eric Sandeen <sandeen@redhat.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

-----------------------------------------------------------------------

Summary of changes:
 fs/xfs/Makefile                          |  70 +++++----
 fs/xfs/{ => libxfs}/xfs_ag.h             |   0
 fs/xfs/{ => libxfs}/xfs_alloc.c          |  20 +--
 fs/xfs/{ => libxfs}/xfs_alloc.h          |   0
 fs/xfs/{ => libxfs}/xfs_alloc_btree.c    |   6 +-
 fs/xfs/{ => libxfs}/xfs_alloc_btree.h    |   0
 fs/xfs/{ => libxfs}/xfs_attr.c           |  92 +++++------
 fs/xfs/{ => libxfs}/xfs_attr_leaf.c      |  78 +++++-----
 fs/xfs/{ => libxfs}/xfs_attr_leaf.h      |   0
 fs/xfs/{ => libxfs}/xfs_attr_remote.c    |  22 +--
 fs/xfs/{ => libxfs}/xfs_attr_remote.h    |   0
 fs/xfs/{ => libxfs}/xfs_attr_sf.h        |   0
 fs/xfs/{ => libxfs}/xfs_bit.h            |   0
 fs/xfs/{ => libxfs}/xfs_bmap.c           |  52 +++----
 fs/xfs/{ => libxfs}/xfs_bmap.h           |   0
 fs/xfs/{ => libxfs}/xfs_bmap_btree.c     |  10 +-
 fs/xfs/{ => libxfs}/xfs_bmap_btree.h     |   0
 fs/xfs/{ => libxfs}/xfs_btree.c          |  14 +-
 fs/xfs/{ => libxfs}/xfs_btree.h          |   0
 fs/xfs/{ => libxfs}/xfs_cksum.h          |   0
 fs/xfs/{ => libxfs}/xfs_da_btree.c       | 110 ++++++-------
 fs/xfs/{ => libxfs}/xfs_da_btree.h       |   0
 fs/xfs/{ => libxfs}/xfs_da_format.c      |   0
 fs/xfs/{ => libxfs}/xfs_da_format.h      |   0
 fs/xfs/{ => libxfs}/xfs_dinode.h         |   0
 fs/xfs/{ => libxfs}/xfs_dir2.c           |  24 +--
 fs/xfs/{ => libxfs}/xfs_dir2.h           |   0
 fs/xfs/{ => libxfs}/xfs_dir2_block.c     |  18 +--
 fs/xfs/{ => libxfs}/xfs_dir2_data.c      |  10 +-
 fs/xfs/{ => libxfs}/xfs_dir2_leaf.c      |  24 +--
 fs/xfs/{ => libxfs}/xfs_dir2_node.c      |  40 ++---
 fs/xfs/{ => libxfs}/xfs_dir2_priv.h      |   0
 fs/xfs/{ => libxfs}/xfs_dir2_sf.c        |  30 ++--
 fs/xfs/{ => libxfs}/xfs_dquot_buf.c      |   6 +-
 fs/xfs/{ => libxfs}/xfs_format.h         |   0
 fs/xfs/{ => libxfs}/xfs_ialloc.c         |  34 ++--
 fs/xfs/{ => libxfs}/xfs_ialloc.h         |   0
 fs/xfs/{ => libxfs}/xfs_ialloc_btree.c   |   6 +-
 fs/xfs/{ => libxfs}/xfs_ialloc_btree.h   |   0
 fs/xfs/{ => libxfs}/xfs_inode_buf.c      |  10 +-
 fs/xfs/{ => libxfs}/xfs_inode_buf.h      |   0
 fs/xfs/{ => libxfs}/xfs_inode_fork.c     |  32 ++--
 fs/xfs/{ => libxfs}/xfs_inode_fork.h     |   0
 fs/xfs/{ => libxfs}/xfs_inum.h           |   0
 fs/xfs/{ => libxfs}/xfs_log_format.h     |   0
 fs/xfs/{ => libxfs}/xfs_log_recover.h    |   0
 fs/xfs/{ => libxfs}/xfs_log_rlimit.c     |   0
 fs/xfs/{ => libxfs}/xfs_quota_defs.h     |   0
 fs/xfs/{ => libxfs}/xfs_rtbitmap.c       |   0
 fs/xfs/{ => libxfs}/xfs_sb.c             |  32 ++--
 fs/xfs/{ => libxfs}/xfs_sb.h             |   0
 fs/xfs/{ => libxfs}/xfs_shared.h         |   0
 fs/xfs/{ => libxfs}/xfs_symlink_remote.c |   6 +-
 fs/xfs/{ => libxfs}/xfs_trans_resv.c     |   0
 fs/xfs/{ => libxfs}/xfs_trans_resv.h     |   0
 fs/xfs/{ => libxfs}/xfs_trans_space.h    |   0
 fs/xfs/xfs_acl.c                         |   8 +-
 fs/xfs/xfs_aops.c                        |  18 +--
 fs/xfs/xfs_attr_inactive.c               |  22 +--
 fs/xfs/xfs_attr_list.c                   |  38 ++---
 fs/xfs/xfs_bmap_util.c                   |  78 +++++-----
 fs/xfs/xfs_buf.c                         |  26 ++--
 fs/xfs/xfs_buf.h                         |   2 +-
 fs/xfs/xfs_buf_item.c                    |   4 +-
 fs/xfs/xfs_dir2_readdir.c                |   4 +-
 fs/xfs/xfs_discard.c                     |  18 +--
 fs/xfs/xfs_dquot.c                       |  38 ++---
 fs/xfs/xfs_error.c                       |  25 +--
 fs/xfs/xfs_error.h                       |  13 +-
 fs/xfs/xfs_export.c                      |  10 +-
 fs/xfs/xfs_extfree_item.c                |   2 +-
 fs/xfs/xfs_file.c                        |  42 ++---
 fs/xfs/xfs_filestream.c                  |   4 +-
 fs/xfs/xfs_fsops.c                       |  42 ++---
 fs/xfs/xfs_icache.c                      |  52 +++----
 fs/xfs/xfs_icache.h                      |  10 +-
 fs/xfs/xfs_inode.c                       |  66 ++++----
 fs/xfs/xfs_inode_item.c                  |   2 +-
 fs/xfs/xfs_ioctl.c                       | 256 +++++++++++++++----------------
 fs/xfs/xfs_ioctl32.c                     | 106 ++++++-------
 fs/xfs/xfs_iomap.c                       |  34 ++--
 fs/xfs/xfs_iops.c                        |  68 ++++----
 fs/xfs/xfs_itable.c                      |  24 +--
 fs/xfs/xfs_linux.h                       |   2 +-
 fs/xfs/xfs_log.c                         |  52 +++----
 fs/xfs/xfs_log_cil.c                     |   6 +-
 fs/xfs/xfs_log_recover.c                 | 191 +++++++++++------------
 fs/xfs/xfs_mount.c                       |  70 ++++-----
 fs/xfs/xfs_mru_cache.c                   |  14 +-
 fs/xfs/xfs_qm.c                          |  32 ++--
 fs/xfs/xfs_qm_bhv.c                      |   2 +-
 fs/xfs/xfs_qm_syscalls.c                 |  46 +++---
 fs/xfs/xfs_quotaops.c                    |  18 +--
 fs/xfs/xfs_rtalloc.c                     |  20 +--
 fs/xfs/xfs_rtalloc.h                     |   2 +-
 fs/xfs/xfs_super.c                       |  88 +++++------
 fs/xfs/xfs_symlink.c                     |  30 ++--
 fs/xfs/xfs_trans.c                       |  10 +-
 fs/xfs/xfs_trans_ail.c                   |   4 +-
 fs/xfs/xfs_trans_buf.c                   |  37 +++--
 fs/xfs/xfs_trans_dquot.c                 |   4 +-
 fs/xfs/xfs_xattr.c                       |   6 +-
 102 files changed, 1180 insertions(+), 1212 deletions(-)
 rename fs/xfs/{ => libxfs}/xfs_ag.h (100%)
 rename fs/xfs/{ => libxfs}/xfs_alloc.c (99%)
 rename fs/xfs/{ => libxfs}/xfs_alloc.h (100%)
 rename fs/xfs/{ => libxfs}/xfs_alloc_btree.c (99%)
 rename fs/xfs/{ => libxfs}/xfs_alloc_btree.h (100%)
 rename fs/xfs/{ => libxfs}/xfs_attr.c (97%)
 rename fs/xfs/{ => libxfs}/xfs_attr_leaf.c (98%)
 rename fs/xfs/{ => libxfs}/xfs_attr_leaf.h (100%)
 rename fs/xfs/{ => libxfs}/xfs_attr_remote.c (98%)
 rename fs/xfs/{ => libxfs}/xfs_attr_remote.h (100%)
 rename fs/xfs/{ => libxfs}/xfs_attr_sf.h (100%)
 rename fs/xfs/{ => libxfs}/xfs_bit.h (100%)
 rename fs/xfs/{ => libxfs}/xfs_bmap.c (99%)
 rename fs/xfs/{ => libxfs}/xfs_bmap.h (100%)
 rename fs/xfs/{ => libxfs}/xfs_bmap_btree.c (99%)
 rename fs/xfs/{ => libxfs}/xfs_bmap_btree.h (100%)
 rename fs/xfs/{ => libxfs}/xfs_btree.c (99%)
 rename fs/xfs/{ => libxfs}/xfs_btree.h (100%)
 rename fs/xfs/{ => libxfs}/xfs_cksum.h (100%)
 rename fs/xfs/{ => libxfs}/xfs_da_btree.c (97%)
 rename fs/xfs/{ => libxfs}/xfs_da_btree.h (100%)
 rename fs/xfs/{ => libxfs}/xfs_da_format.c (100%)
 rename fs/xfs/{ => libxfs}/xfs_da_format.h (100%)
 rename fs/xfs/{ => libxfs}/xfs_dinode.h (100%)
 rename fs/xfs/{ => libxfs}/xfs_dir2.c (98%)
 rename fs/xfs/{ => libxfs}/xfs_dir2.h (100%)
 rename fs/xfs/{ => libxfs}/xfs_dir2_block.c (99%)
 rename fs/xfs/{ => libxfs}/xfs_dir2_data.c (99%)
 rename fs/xfs/{ => libxfs}/xfs_dir2_leaf.c (99%)
 rename fs/xfs/{ => libxfs}/xfs_dir2_node.c (98%)
 rename fs/xfs/{ => libxfs}/xfs_dir2_priv.h (100%)
 rename fs/xfs/{ => libxfs}/xfs_dir2_sf.c (98%)
 rename fs/xfs/{ => libxfs}/xfs_dquot_buf.c (98%)
 rename fs/xfs/{ => libxfs}/xfs_format.h (100%)
 rename fs/xfs/{ => libxfs}/xfs_ialloc.c (99%)
 rename fs/xfs/{ => libxfs}/xfs_ialloc.h (100%)
 rename fs/xfs/{ => libxfs}/xfs_ialloc_btree.c (98%)
 rename fs/xfs/{ => libxfs}/xfs_ialloc_btree.h (100%)
 rename fs/xfs/{ => libxfs}/xfs_inode_buf.c (98%)
 rename fs/xfs/{ => libxfs}/xfs_inode_buf.h (100%)
 rename fs/xfs/{ => libxfs}/xfs_inode_fork.c (99%)
 rename fs/xfs/{ => libxfs}/xfs_inode_fork.h (100%)
 rename fs/xfs/{ => libxfs}/xfs_inum.h (100%)
 rename fs/xfs/{ => libxfs}/xfs_log_format.h (100%)
 rename fs/xfs/{ => libxfs}/xfs_log_recover.h (100%)
 rename fs/xfs/{ => libxfs}/xfs_log_rlimit.c (100%)
 rename fs/xfs/{ => libxfs}/xfs_quota_defs.h (100%)
 rename fs/xfs/{ => libxfs}/xfs_rtbitmap.c (100%)
 rename fs/xfs/{ => libxfs}/xfs_sb.c (97%)
 rename fs/xfs/{ => libxfs}/xfs_sb.h (100%)
 rename fs/xfs/{ => libxfs}/xfs_shared.h (100%)
 rename fs/xfs/{ => libxfs}/xfs_symlink_remote.c (97%)
 rename fs/xfs/{ => libxfs}/xfs_trans_resv.c (100%)
 rename fs/xfs/{ => libxfs}/xfs_trans_resv.h (100%)
 rename fs/xfs/{ => libxfs}/xfs_trans_space.h (100%)


hooks/post-receive
-- 
XFS development tree

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
