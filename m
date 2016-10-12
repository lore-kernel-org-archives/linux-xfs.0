Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:27032 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754783AbcJLMSz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Oct 2016 08:18:55 -0400
Date: Wed, 12 Oct 2016 23:18:49 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [GIT PULL] xfs: shared data extents support for 4.9-rc1
Message-ID: <20161012121849.GD27872@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: torvalds@linux-foundation.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org

Hi Linus,

This is the second part of the XFS updates for this merge cycle.
This pullreq contains the new shared data extents feature for XFS,
and can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git tags/xfs-reflink-for-linus-4.9-rc1

The full pull request output is below.

Given the complexity and size of this change I am expecting - like
the addition of reverse mapping last cycle - that there will be some
follow-up bug fixes and cleanups around the -rc3 stage for issues
that I'm sure will show up once the code hits a wider userbase.

What it is:

At the most basic level we are simply adding shared data extents to
XFS - i.e. a single extent on disk can now have multiple owners. To
do this we have to add new on-disk features to both track the shared
extents and the number of times they've been shared. This is done by
the new "refcount" btree that sits in every allocation group. When
we share or unshare an extent, this tree gets updated.

Along with this new tree, the reverse mapping tree needs to be
updated to track each owner or a shared extent. This also needs to
be updated ever share/unshare operation. These interactions at
extent allocation and freeing time have complex ordering and
recovery constraints, so there's a significant amount of new
intent-based transaction code to ensure that operations are
performed atomically from both the runtime and integrity/crash
recovery perspectives.

We also need to break sharing when writes hit a shared extent - this
is where the new copy-on-write implementation comes in. We allocate
new storage and copy the original data along with the overwrite data
into the new location.  We only do this for data as we don't share
metadata at all - each inode has it's own metadata that tracks the
shared data extents, the extents undergoing CoW and it's own private
extents.

Of course, being XFS, nothing is simple - we use delayed allocation
for CoW similar to how we use it for normal writes. ENOSPC is a
significant issue here - we build on the reservation code added
in 4.8-rc1 with the reverse mapping feature to ensure we don't get
spurious ENOSPC issues part way through a CoW operation. These
mechanisms also help minimise fragmentation due to repeated CoW
operations.  To further reduce fragmentation overhead, we've also
introduced a CoW extent size hint, which indicates how large a
region we should allocate when we execute a CoW operation.

With all this functionality in place, we can hook up
.copy_file_range, .clone_file_range and .dedupe_file_range and we
gain all the capabilities of reflink and other vfs provided
functionality that enable manipulation to shared extents. We also
added a fallocate mode that explicitly unshares a range of a file,
which we implemented as an explicit CoW of all the shared extents in
a file.

As such, it's a huge chunk of new functionality with new on-disk
format features and internal infrastructure. It warns at mount time
as an experimental feature and that it may eat data (as we do with
all new on-disk features until they stabilise).  We have not
released userspace suport for it yet - userspace support currently
requires download from Darrick's xfsprogs repo and build from
source, so the access to this feature is really developer/tester
only at this point. Initial userspace support will be released at
the same time the kernel with this code in it is released.

The new code causes 5-6 new failures with xfstests - these aren't
serious functional failures but things the output of tests changing
slightly due to perturbations in layouts, space usage, etc.  OTOH,
we've added 150+ new tests to xfstests that specifically exercise
this new functionality so it's got far better test coverage than any
functionality we've previously added to XFS.

Darrick has done a pretty amazing job getting us to this stage, and
special mention also needs to go to Christoph (review, testing,
improvements and bug fixes) and Brian (caught several intricate
bugs during review) for the effort they've also put in.

Thanks,

-Dave.

----------
The following changes since commit 155cd433b516506df065866f3d974661f6473572:

  Merge branch 'xfs-4.9-log-recovery-fixes' into for-next (2016-10-03 09:56:28 +1100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git tags/xfs-reflink-for-linus-4.9-rc1

for you to fetch changes up to feac470e3642e8956ac9b7f14224e6b301b9219d:

  xfs: convert COW blocks to real blocks before unwritten extent conversion (2016-10-11 09:03:19 +1100)

----------------------------------------------------------------
xfs: reflink update for 4.9-rc1

< XFS has gained super CoW powers! >
 ----------------------------------
        \   ^__^
         \  (oo)\_______
            (__)\       )\/\
                ||----w |
                ||     ||

Included in this update:
- unshare range (FALLOC_FL_UNSHARE) support for fallocate
- copy-on-write extent size hints (FS_XFLAG_COWEXTSIZE) for fsxattr interface
- shared extent support for XFS
- copy-on-write support for shared extents
- copy_file_range support
- clone_file_range support (implements reflink)
- dedupe_file_range support
- defrag support for reverse mapping enabled filesystems

----------------------------------------------------------------
Christoph Hellwig (1):
      xfs: convert COW blocks to real blocks before unwritten extent conversion

Darrick J. Wong (70):
      vfs: support FS_XFLAG_COWEXTSIZE and get/set of CoW extent size hint
      vfs: add a FALLOC_FL_UNSHARE mode to fallocate to unshare a range of blocks
      xfs: return an error when an inline directory is too small
      xfs: define tracepoints for refcount btree activities
      xfs: introduce refcount btree definitions
      xfs: refcount btree add more reserved blocks
      xfs: define the on-disk refcount btree format
      xfs: add refcount btree support to growfs
      xfs: account for the refcount btree in the alloc/free log reservation
      xfs: add refcount btree operations
      xfs: create refcount update intent log items
      xfs: log refcount intent items
      xfs: adjust refcount of an extent of blocks in refcount btree
      xfs: connect refcount adjust functions to upper layers
      xfs: adjust refcount when unmapping file blocks
      xfs: add refcount btree block detection to log recovery
      xfs: reserve AG space for the refcount btree root
      xfs: introduce reflink utility functions
      xfs: create bmbt update intent log items
      xfs: log bmap intent items
      xfs: map an inode's offset to an exact physical block
      xfs: pass bmapi flags through to bmap_del_extent
      xfs: implement deferred bmbt map/unmap operations
      xfs: when replaying bmap operations, don't let unlinked inodes get reaped
      xfs: return work remaining at the end of a bunmapi operation
      xfs: define tracepoints for reflink activities
      xfs: add reflink feature flag to geometry
      xfs: don't allow reflinked dir/dev/fifo/socket/pipe files
      xfs: introduce the CoW fork
      xfs: support bmapping delalloc extents in the CoW fork
      xfs: create delalloc extents in CoW fork
      xfs: support allocating delayed extents in CoW fork
      xfs: allocate delayed extents in CoW fork
      xfs: support removing extents from CoW fork
      xfs: move mappings from cow fork to data fork after copy-write
      xfs: report shared extent mappings to userspace correctly
      xfs: implement CoW for directio writes
      xfs: cancel CoW reservations and clear inode reflink flag when freeing blocks
      xfs: cancel pending CoW reservations when destroying inodes
      xfs: store in-progress CoW allocations in the refcount btree
      xfs: reflink extents from one file to another
      xfs: add clone file and clone range vfs functions
      xfs: add dedupe range vfs function
      xfs: teach get_bmapx about shared extents and the CoW fork
      xfs: swap inode reflink flags when swapping inode extents
      xfs: unshare a range of blocks via fallocate
      xfs: create a separate cow extent size hint for the allocator
      xfs: preallocate blocks for worst-case btree expansion
      xfs: don't allow reflink when the AG is low on space
      xfs: try other AGs to allocate a BMBT block
      xfs: garbage collect old cowextsz reservations
      xfs: increase log reservations for reflink
      xfs: add shared rmap map/unmap/convert log item types
      xfs: use interval query for rmap alloc operations on shared files
      xfs: convert unwritten status of reverse mappings for shared files
      xfs: set a default CoW extent size of 32 blocks
      xfs: check for invalid inode reflink flags
      xfs: don't mix reflink and DAX mode for now
      xfs: simulate per-AG reservations being critically low
      xfs: recognize the reflink feature bit
      xfs: various swapext cleanups
      xfs: refactor swapext code
      xfs: implement swapext for rmap filesystems
      xfs: check inode reflink flag before calling reflink functions
      xfs: reduce stack usage of _reflink_clear_inode_flag
      xfs: remove isize check from unshare operation
      xfs: fix label inaccuracies
      xfs: fix error initialization
      xfs: clear reflink flag if setting realtime flag
      xfs: rework refcount cow recovery error handling

 fs/open.c                          |    5 +
 fs/xfs/Makefile                    |    7 +
 fs/xfs/libxfs/xfs_ag_resv.c        |   15 +-
 fs/xfs/libxfs/xfs_alloc.c          |   23 +
 fs/xfs/libxfs/xfs_bmap.c           |  575 +++++++++++-
 fs/xfs/libxfs/xfs_bmap.h           |   67 +-
 fs/xfs/libxfs/xfs_bmap_btree.c     |   18 +
 fs/xfs/libxfs/xfs_btree.c          |    8 +-
 fs/xfs/libxfs/xfs_btree.h          |   16 +
 fs/xfs/libxfs/xfs_defer.h          |    2 +
 fs/xfs/libxfs/xfs_format.h         |   97 +-
 fs/xfs/libxfs/xfs_fs.h             |   10 +-
 fs/xfs/libxfs/xfs_inode_buf.c      |   24 +-
 fs/xfs/libxfs/xfs_inode_buf.h      |    1 +
 fs/xfs/libxfs/xfs_inode_fork.c     |   70 +-
 fs/xfs/libxfs/xfs_inode_fork.h     |   28 +-
 fs/xfs/libxfs/xfs_log_format.h     |  118 ++-
 fs/xfs/libxfs/xfs_refcount.c       | 1698 ++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_refcount.h       |   70 ++
 fs/xfs/libxfs/xfs_refcount_btree.c |  451 ++++++++++
 fs/xfs/libxfs/xfs_refcount_btree.h |   74 ++
 fs/xfs/libxfs/xfs_rmap.c           | 1120 +++++++++++++++++++++---
 fs/xfs/libxfs/xfs_rmap.h           |    7 +
 fs/xfs/libxfs/xfs_rmap_btree.c     |   82 +-
 fs/xfs/libxfs/xfs_rmap_btree.h     |    7 +
 fs/xfs/libxfs/xfs_sb.c             |    9 +
 fs/xfs/libxfs/xfs_shared.h         |    2 +
 fs/xfs/libxfs/xfs_trans_resv.c     |   23 +-
 fs/xfs/libxfs/xfs_trans_resv.h     |    3 +
 fs/xfs/libxfs/xfs_trans_space.h    |    9 +
 fs/xfs/libxfs/xfs_types.h          |    3 +-
 fs/xfs/xfs_aops.c                  |  222 ++++-
 fs/xfs/xfs_aops.h                  |    4 +-
 fs/xfs/xfs_bmap_item.c             |  508 +++++++++++
 fs/xfs/xfs_bmap_item.h             |   98 +++
 fs/xfs/xfs_bmap_util.c             |  589 ++++++++++---
 fs/xfs/xfs_dir2_readdir.c          |    3 +-
 fs/xfs/xfs_error.h                 |   10 +-
 fs/xfs/xfs_file.c                  |  221 ++++-
 fs/xfs/xfs_fsops.c                 |  107 ++-
 fs/xfs/xfs_fsops.h                 |    3 +
 fs/xfs/xfs_globals.c               |    5 +-
 fs/xfs/xfs_icache.c                |  243 +++++-
 fs/xfs/xfs_icache.h                |    7 +
 fs/xfs/xfs_inode.c                 |   51 ++
 fs/xfs/xfs_inode.h                 |   19 +
 fs/xfs/xfs_inode_item.c            |    2 +-
 fs/xfs/xfs_ioctl.c                 |   75 +-
 fs/xfs/xfs_iomap.c                 |   35 +-
 fs/xfs/xfs_iomap.h                 |    3 +-
 fs/xfs/xfs_iops.c                  |    1 +
 fs/xfs/xfs_itable.c                |    8 +-
 fs/xfs/xfs_linux.h                 |    1 +
 fs/xfs/xfs_log_recover.c           |  357 ++++++++
 fs/xfs/xfs_mount.c                 |   32 +
 fs/xfs/xfs_mount.h                 |    8 +
 fs/xfs/xfs_ondisk.h                |    3 +
 fs/xfs/xfs_pnfs.c                  |    7 +
 fs/xfs/xfs_refcount_item.c         |  539 ++++++++++++
 fs/xfs/xfs_refcount_item.h         |  101 +++
 fs/xfs/xfs_reflink.c               | 1688 +++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_reflink.h               |   58 ++
 fs/xfs/xfs_rmap_item.c             |   12 +
 fs/xfs/xfs_stats.c                 |    1 +
 fs/xfs/xfs_stats.h                 |   18 +-
 fs/xfs/xfs_super.c                 |   87 ++
 fs/xfs/xfs_sysctl.c                |    9 +
 fs/xfs/xfs_sysctl.h                |    1 +
 fs/xfs/xfs_trace.h                 |  742 +++++++++++++++-
 fs/xfs/xfs_trans.h                 |   29 +
 fs/xfs/xfs_trans_bmap.c            |  249 ++++++
 fs/xfs/xfs_trans_refcount.c        |  264 ++++++
 fs/xfs/xfs_trans_rmap.c            |    9 +
 include/linux/falloc.h             |    3 +-
 include/uapi/linux/falloc.h        |   18 +
 include/uapi/linux/fs.h            |    4 +-
 76 files changed, 10683 insertions(+), 413 deletions(-)
 create mode 100644 fs/xfs/libxfs/xfs_refcount.c
 create mode 100644 fs/xfs/libxfs/xfs_refcount.h
 create mode 100644 fs/xfs/libxfs/xfs_refcount_btree.c
 create mode 100644 fs/xfs/libxfs/xfs_refcount_btree.h
 create mode 100644 fs/xfs/xfs_bmap_item.c
 create mode 100644 fs/xfs/xfs_bmap_item.h
 create mode 100644 fs/xfs/xfs_refcount_item.c
 create mode 100644 fs/xfs/xfs_refcount_item.h
 create mode 100644 fs/xfs/xfs_reflink.c
 create mode 100644 fs/xfs/xfs_reflink.h
 create mode 100644 fs/xfs/xfs_trans_bmap.c
 create mode 100644 fs/xfs/xfs_trans_refcount.c
-- 
Dave Chinner
david@fromorbit.com
