Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:33602 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727736AbeKBOVC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Nov 2018 10:21:02 -0400
Date: Fri, 2 Nov 2018 16:14:59 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [GIT PULL] vfs: fix many problems in vfs clone/dedupe implementation
Message-ID: <20181102051459.GS6311@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: torvalds@linux-foundation.org
Cc: djwong@kernel.org, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, sandeen@sandeen.net, david@fromorbit.com

Hi Linus,

Can you please pull update containing a rework of the VFS clone and
dedupe file range infrastructure from the tag listed below?

We discovered many issues with these interfaces late in the 4.19
cycle - the worst of them (data corruption, setuid stripping) were
fixed for XFS in 4.19-rc8, but a larger rework of the infrastructure
fixing all the problems was needed. That rework is the contents of
this pull request.

The base tree is 4.19 because there was an unrelated
vfs_clone_file_range API cleanup merged in v4.19-rc7, and combined
with the mods in 4.19-rc8 it was simpler for everyone to base this
work on a tree with all those changes already in it.

There is a simple conflict with your current tree in
Documentation/filesystems/porting. However, if you pull Al's pending
VFS tree before this there will also be a more significant conflict
fs/read_write.c in the vfs_dedupe_file_range_one() function rework.
The details of the conflict  and the resolution that the linux-next
tree is carrying can be found here:

https://lore.kernel.org/lkml/20181031115247.6adcb659@canb.auug.org.au/

If you need any more info or a tree with the conflicts already
resolved, please let me know.

Thanks,

Dave.

PS. Darrick is back up to speed so the next XFS pull request for
fixes later in the -rc cycle will probably come from him again.

The following changes since commit 84df9525b0c27f3ebc2ebb1864fa62a97fdedb7d:

  Linux 4.19 (2018-10-22 07:37:37 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/fs/xfs/xfs-linux tags/xfs-4.20-merge-2

for you to fetch changes up to bf4a1fcf0bc18d52cf0fce6571d6f327ab5eaf22:

  xfs: remove [cm]time update from reflink calls (2018-10-30 10:47:48 +1100)

----------------------------------------------------------------
vfs: rework data cloning infrastructure

Rework the vfs_clone_file_range and vfs_dedupe_file_range infrastructure to use
a common .remap_file_range method and supply generic bounds and sanity checking
functions that are shared with the data write path. The current VFS
infrastructure has problems with rlimit, LFS file sizes, file time stamps,
maximum filesystem file sizes, stripping setuid bits, etc and so they are
addressed in these commits.

We also introduce the ability for the ->remap_file_range methods to return short
clones so that clones for vfs_copy_file_range() don't get rejected if the entire
range can't be cloned. It also allows filesystems to sliently skip deduplication
of partial EOF blocks if they are not capable of doing so without requiring
errors to be thrown to userspace.

All existing filesystems are converted to user the new .remap_file_range method,
and both XFS and ocfs2 are modified to make use of the new generic checking
infrastructure.

----------------------------------------------------------------
Darrick J. Wong (28):
      vfs: vfs_clone_file_prep_inodes should return EINVAL for a clone from beyond EOF
      vfs: check file ranges before cloning files
      vfs: exit early from zero length remap operations
      vfs: strengthen checking of file range inputs to generic_remap_checks
      vfs: avoid problematic remapping requests into partial EOF block
      vfs: skip zero-length dedupe requests
      vfs: rename vfs_clone_file_prep to be more descriptive
      vfs: rename clone_verify_area to remap_verify_area
      vfs: combine the clone and dedupe into a single remap_file_range
      vfs: pass remap flags to generic_remap_file_range_prep
      vfs: pass remap flags to generic_remap_checks
      vfs: remap helper should update destination inode metadata
      vfs: make remap_file_range functions take and return bytes completed
      vfs: plumb remap flags through the vfs clone functions
      vfs: plumb remap flags through the vfs dedupe functions
      vfs: enable remap callers that can handle short operations
      vfs: hide file range comparison function
      vfs: clean up generic_remap_file_range_prep return value
      ocfs2: truncate page cache for clone destination file before remapping
      ocfs2: fix pagecache truncation prior to reflink
      ocfs2: support partial clone range and dedupe range
      ocfs2: remove ocfs2_reflink_remap_range
      xfs: fix pagecache truncation prior to reflink
      xfs: clean up xfs_reflink_remap_blocks call site
      xfs: support returning partial reflink results
      xfs: remove redundant remap partial EOF block checks
      xfs: remove xfs_reflink_remap_range
      xfs: remove [cm]time update from reflink calls

 Documentation/filesystems/porting |   5 +
 Documentation/filesystems/vfs.txt |  22 ++-
 fs/btrfs/ctree.h                  |   8 +-
 fs/btrfs/file.c                   |   3 +-
 fs/btrfs/ioctl.c                  |  50 ++---
 fs/cifs/cifsfs.c                  |  24 ++-
 fs/ioctl.c                        |  10 +-
 fs/nfs/nfs4file.c                 |  12 +-
 fs/nfsd/vfs.c                     |   8 +-
 fs/ocfs2/file.c                   |  93 +++++++--
 fs/ocfs2/refcounttree.c           | 148 ++++----------
 fs/ocfs2/refcounttree.h           |  24 ++-
 fs/overlayfs/copy_up.c            |   6 +-
 fs/overlayfs/file.c               |  43 ++--
 fs/read_write.c                   | 403 +++++++++++++++++++++-----------------
 fs/xfs/xfs_file.c                 |  82 +++++---
 fs/xfs/xfs_reflink.c              | 173 ++++------------
 fs/xfs/xfs_reflink.h              |  15 +-
 include/linux/fs.h                |  55 ++++--
 mm/filemap.c                      | 146 +++++++++++---
 20 files changed, 734 insertions(+), 596 deletions(-)
-- 
Dave Chinner
david@fromorbit.com
