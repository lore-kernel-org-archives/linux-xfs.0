Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:44820 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751670AbcKHXQp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Nov 2016 18:16:45 -0500
Date: Wed, 9 Nov 2016 10:16:39 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfs: for-next branch updated to 84716639acc3
Message-ID: <20161108231639.GC28922@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, jack@suse.cz, tytso@mit.edu, ross.zwisler@linux.intel.com

Hi folks,

The for-next branch of the xfs kernel repository at

git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git

has just been updated.

This update includes the DAX iomap PMD fault infrastructure, a bunch
of libxfs cleanups that sync the kernel code with changes that
have been made in the userspace libxfs and a few bug fixes thrown in
there for good measure.

Jan, Ted and Ross:

I have pushed the DAX changes into a stable topic branch named
"dax-4.10-iomap-pmd".  Any fixes to this code will be appended to
this branch - the commits are now stable so that it can be pulled
into other trees for further development of DAX features for this
cycle.

The dax-4.10-iomap-pmd branch will also reach linux-next via the
merge into the for-next branch. However, keep in mind that the 
for-next in the XFS tree is not a stable branch - it may get
rebased from time to time as stable topic branches have commits
appended - so treat the for-next branch like you treat linux-next.

-Dave.

The new head of the for-next branch is commit:

84716639acc3 Merge branch 'xfs-4.10-misc-fixes-1' into for-next

New Commits:

Brian Foster (2):
      [399372349a7f] xfs: don't skip cow forks w/ delalloc blocks in cowblocks scan
      [04197b341f23] xfs: don't BUG() on mixed direct and mapped I/O

Darrick J. Wong (8):
      [755c7bf5ddca] libxfs: convert ushort to unsigned short
      [420fbeb4bff4] libxfs: synchronize dinode_verify with userspace
      [68c098582b20] libxfs: fix whitespace problems
      [ae90b994b40f] libxfs: fix xfs_attr_shortform_bytesfit declaration
      [523b2e76e3ec] libxfs: clean up _dir2_data_freescan
      [5e52365ac863] xfs: move dir_ino_validate declaration per xfsprogs
      [4fd29ec47212] xfs: check return value of _trans_reserve_quota_nblks
      [132f2ac5055a] xfs: check minimum block size for CRC filesystems

Dave Chinner (3):
      [e823656675ac] Merge branch 'dax-4.10-iomap-pmd' into for-next
      [baa5baeb87de] Merge branch 'xfs-4.10-libxfs-cleanups' into for-next
      [84716639acc3] Merge branch 'xfs-4.10-misc-fixes-1' into for-next

Eric Sandeen (3):
      [e6fc6fcf4447] xfs: don't call xfs_sb_quota_from_disk twice
      [4dfce57db635] xfs: fix up xfs_swap_extent_forks inline extent handling
      [5d829300bee0] xfs: provide helper for counting extents from if_bytes

Ross Zwisler (16):
      [547edce3ba23] ext4: tell DAX the size of allocation holes
      [fa0d3fce7cef] dax: remove buffer_size_valid()
      [03e0990fc88f] ext2: remove support for DAX PMD faults
      [ce95ab0fa669] dax: make 'wait_table' global variable static
      [aada54f98004] dax: remove the last BUG_ON() from fs/dax.c
      [e3ad61c64abc] dax: consistent variable naming for DAX entries
      [63e95b5c4f16] dax: coordinate locking for offsets in PMD range
      [b9fde0462e34] dax: remove dax_pmd_fault()
      [11c59c92f44d] dax: correct dax iomap code namespace
      [333ccc978e1e] dax: add dax_iomap_sector() helper function
      [1550290b0801] dax: dax_iomap_fault() needs to call iomap_end()
      [fa28f7296a7c] dax: move RADIX_DAX_* defines to dax.h
      [422476c4641e] dax: move put_(un)locked_mapping_entry() in dax.c
      [642261ac995e] dax: add struct iomap based DAX PMD support
      [862f1b9d6718] xfs: use struct iomap based DAX PMD fault path
      [190b5caad750] dax: remove "depends on BROKEN" from FS_DAX_PMD


Code Diffstat:

 fs/Kconfig                      |   1 -
 fs/dax.c                        | 826 ++++++++++++++++++++++++-------------------
 fs/ext2/file.c                  |  35 +-
 fs/ext4/inode.c                 |   3 +
 fs/xfs/libxfs/xfs_attr_leaf.h   |   2 +-
 fs/xfs/libxfs/xfs_bmap.c        |  54 +--
 fs/xfs/libxfs/xfs_dir2.h        |   5 +
 fs/xfs/libxfs/xfs_dir2_data.c   |  24 +-
 fs/xfs/libxfs/xfs_dir2_priv.h   |   1 -
 fs/xfs/libxfs/xfs_ialloc.c      |   5 +-
 fs/xfs/libxfs/xfs_inode_buf.c   |   6 +-
 fs/xfs/libxfs/xfs_inode_buf.h   |   4 +-
 fs/xfs/libxfs/xfs_inode_fork.c  |  31 +-
 fs/xfs/libxfs/xfs_inode_fork.h  |   1 +
 fs/xfs/libxfs/xfs_log_format.h  |   4 +-
 fs/xfs/libxfs/xfs_log_recover.h |   2 +-
 fs/xfs/libxfs/xfs_rtbitmap.c    |   1 -
 fs/xfs/libxfs/xfs_sb.c          |  14 +-
 fs/xfs/libxfs/xfs_types.h       |   3 +
 fs/xfs/xfs_aops.c               |  48 +--
 fs/xfs/xfs_aops.h               |   3 -
 fs/xfs/xfs_bmap_util.c          |  33 +-
 fs/xfs/xfs_file.c               |  10 +-
 fs/xfs/xfs_icache.c             |   7 +-
 fs/xfs/xfs_inode_item.c         |   4 +-
 fs/xfs/xfs_ioctl.c              |   6 +-
 fs/xfs/xfs_log_recover.c        |   4 +-
 fs/xfs/xfs_qm.c                 |   2 +-
 fs/xfs/xfs_reflink.c            |  38 +-
 fs/xfs/xfs_reflink.h            |   2 -
 include/linux/dax.h             |  58 ++-
 mm/filemap.c                    |   5 +-
 32 files changed, 683 insertions(+), 559 deletions(-)
-- 
Dave Chinner
david@fromorbit.com
