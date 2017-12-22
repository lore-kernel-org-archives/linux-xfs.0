Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755940AbdLVTad (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 22 Dec 2017 14:30:33 -0500
Date: Fri, 22 Dec 2017 11:30:32 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
Subject: [GIT PULL] xfs: fixes for 4.15-rc5
Message-ID: <20171222193032.GC12613@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Eric Sandeen <sandeen@sandeen.net>

Hi Linus,

Here are some XFS fixes for 4.15-rc5.  Apologies for the unusually large
number of patches this late, but I wanted to make sure the corruption
fixes were really ready to go.

That said, there's a merge conflict with the MS_RDONLY/SB_RDONLY
conversion, with a fairly simple resolution:

diff --cc fs/xfs/xfs_super.c
index 5122d3021117,2db6a40a96bd..000000000000
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@@ -1368,7 -1369,15 +1369,15 @@@ xfs_fs_remount
  	}
  
  	/* rw -> ro */
 -	if (!(mp->m_flags & XFS_MOUNT_RDONLY) && (*flags & MS_RDONLY)) {
 +	if (!(mp->m_flags & XFS_MOUNT_RDONLY) && (*flags & SB_RDONLY)) {
+ 		/* Get rid of any leftover CoW reservations... */
+ 		cancel_delayed_work_sync(&mp->m_cowblocks_work);
+ 		error = xfs_icache_free_cowblocks(mp, NULL);
+ 		if (error) {
+ 			xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
+ 			return error;
+ 		}
+ 
  		/* Free the per-AG metadata reservation pool. */
  		error = xfs_fs_unreserve_ag_blocks(mp);
  		if (error) {

If you prefer I send you a pull request with a rebased branch, please
let me know.

--D

The following changes since commit b7e0b6ff54dd92febbb1914ab93cd6a21622e169:

  xfs: make iomap_begin functions trim iomaps consistently (2017-12-08 17:51:05 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-4.15-fixes-8

for you to fetch changes up to 68c58e9b9a88c1a9d0c2eaf6c7acefb00f5fbbfb:

  xfs: only skip rmap owner checks for unknown-owner rmap removal (2017-12-21 08:48:38 -0800)

----------------------------------------------------------------
Changes since last update:
- Fix a locking problem during xattr block conversion that could lead to
  the log checkpointing thread to try to write an incomplete buffer to
  disk, which leads to a corruption shutdown
- Fix a null pointer dereference when removing delayed allocation extents
- Remove post-eof speculative allocations when reflinking a block past
  current inode size so that we don't just leave them there and assert on
  inode reclaim
- Relax an assert which didn't accurately reflect the way locking works
  and would trigger under heavy io load
- Avoid infinite loop when cancelling copy on write extents after a
  writeback failure
- Try to avoid copy on write transaction reservation overflows when
  remapping after a successful write
- Fix various problems with the copy-on-write reservation automatic
  garbage collection not being cleaned up properly during a ro remount
- Fix problems with rmap log items being processed in the wrong order,
  leading to corruption shutdowns
- Fix problems with EFI recovery wherein the "remove any rmapping if
  present" mechanism wasn't actually doing anything, which would lead
  to corruption problems later when the extent is reallocated, leading
  to multiple rmaps for the same extent

----------------------------------------------------------------
Darrick J. Wong (15):
      xfs: add the ability to join a held buffer to a defer_ops
      xfs: hold xfs_buf locked between shortform->leaf conversion and the addition of an attribute
      xfs: account for null transactions in bunmapi
      xfs: move xfs_iext_insert tracepoint to report useful information
      xfs: remove dest file's post-eof preallocations before reflinking
      xfs: relax is_reflink_inode assert in xfs_reflink_find_cow_mapping
      xfs: avoid infinite loop when cancelling CoW blocks after writeback failure
      xfs: allow CoW remap transactions to use reserve blocks
      xfs: track cowblocks separately in i_flags
      xfs: don't be so eager to clear the cowblocks tag on truncate
      xfs: remove leftover CoW reservations when remounting ro
      xfs: set cowblocks tag for direct cow writes too
      xfs: queue deferred rmap ops for cow staging extent alloc/free in the right order
      xfs: always honor OWN_UNKNOWN rmap removal requests
      xfs: only skip rmap owner checks for unknown-owner rmap removal

 fs/xfs/libxfs/xfs_alloc.c     |  4 +-
 fs/xfs/libxfs/xfs_attr.c      | 20 ++++++---
 fs/xfs/libxfs/xfs_attr_leaf.c |  9 ++--
 fs/xfs/libxfs/xfs_attr_leaf.h |  3 +-
 fs/xfs/libxfs/xfs_bmap.c      |  2 +-
 fs/xfs/libxfs/xfs_defer.c     | 39 +++++++++++++++--
 fs/xfs/libxfs/xfs_defer.h     |  5 ++-
 fs/xfs/libxfs/xfs_iext_tree.c |  4 +-
 fs/xfs/libxfs/xfs_refcount.c  | 52 +++++++++--------------
 fs/xfs/libxfs/xfs_rmap.c      | 99 +++++++++++++++++++++++++++++++++----------
 fs/xfs/libxfs/xfs_rmap.h      | 16 ++++++-
 fs/xfs/xfs_extfree_item.c     |  2 +-
 fs/xfs/xfs_fsops.c            |  5 +++
 fs/xfs/xfs_icache.c           | 35 ++++++++++-----
 fs/xfs/xfs_icache.h           |  1 +
 fs/xfs/xfs_inode.c            | 28 ++++++++----
 fs/xfs/xfs_inode.h            |  1 +
 fs/xfs/xfs_reflink.c          | 21 ++++++++-
 fs/xfs/xfs_super.c            |  9 ++++
 19 files changed, 258 insertions(+), 97 deletions(-)
