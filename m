Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59536 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750723AbdH3E1W (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 30 Aug 2017 00:27:22 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B2EF04E909
        for <linux-xfs@vger.kernel.org>; Wed, 30 Aug 2017 04:27:22 +0000 (UTC)
From: Eryu Guan <eguan@redhat.com>
Subject: [PATCH] xfs: skip free eofblocks if inode is under written back
Date: Wed, 30 Aug 2017 12:26:28 +0800
Message-Id: <20170830042628.5592-1-eguan@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Eryu Guan <eguan@redhat.com>

xfs_vm_writepages() saves a cached imap in a writeback context
structure and passes it to xfs_do_writepage() for every page in this
writeback, so xfs_writepage_map() (called by xfs_do_writepage())
doesn't have to lookup & recalculate the mapping for every buffer it
writes if the cached imap is considered as valid.

But there's a chance that the cached imap becomes stale (doesn't
match the real extent entry) due to the removing of speculative
preallocated blocks, in this case xfs_imap_valid() still reports
imap as valid, because the buffer it's writing is still within the
cached imap range. This could result in fs corruption and data
corruption (data written to wrong block).

For example, the following sequences make it possible (assuming 4k
block size XFS):

  1. delalloc write 1072 blocks, with speculative preallocation,
  2032 blocks got allocated

  2. started a WB_SYNC_NONE writeback (so it wrote all
  PAGECACHE_TAG_DIRTY pages, additional dirty page from step 4 can
  be picked up, this could be a background writeback, or a bare
  SYNC_FILE_RANGE_WRITE sync_file_range() call) on this inode,
  filled in br_startblock, converted delayed allocation to real
  allocation, but br_blockcount was unchanged, still 2032, and this
  imap got cached in writeback context structure for writing
  subsequent pages

  3. close file, xfs_release() called xfs_free_eofblocks() to remove
  any speculative allocated blocks, br_blockcount changed to 1072,
  but cached imap still had 2032,

  4. another delalloc append write one more block to this file, a
  new extent was allocated, with br_startoff = 1072 (because
  previous extent was converted to a real allocation, new delalloc
  extent can't be merged with previous one), dirty the associated
  page and close file

  5. xfs_vm_writepages() dealt with the newly dirtied page (index
  1072), the cached imap was still considered as valid (as 0 <= 1072
  < 2032), so the buffer associated with the page was written to
  wrong block, leaving the new delalloc extent unprocessed and
  leaking i_delayed_blks, which caused sb_fdblocks inconsistency

This is not easy to reproduce, Zorro Lang once hit it by running
generic/224 on ppc64 host. But with the lustre-racer test[1], it can
be reproduced within minutes if you have good luck. Changing
RACER_PROGS in racer.sh to only contain "file_create file_rm
dir_create file_concat" seems to make it eaiser.

Fix it by simply skipping free eofblocks in xfs_release() if the
inode is currently under written back to avoid the imap change in
the middle of a writeback.

[1] https://git.hpdd.intel.com/?p=fs/lustre-release.git;a=tree;f=lustre/tests/racer;hb=HEAD

Signed-off-by: Eryu Guan <eguan@redhat.com>
---

I've tested this patch with lustre-racer, and fstests with various configs (v4,
v5, different block sizes, reflink or not, rmapbt or not), and I didn't see any
new failures. And I'll work on a new fstests case to cover this bug.

 fs/xfs/xfs_inode.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index ff48f0096810..f9e09f6c6d36 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1656,9 +1656,10 @@ xfs_release(
 	xfs_inode_t	*ip)
 {
 	xfs_mount_t	*mp = ip->i_mount;
+	struct inode	*inode = VFS_I(ip);
 	int		error;
 
-	if (!S_ISREG(VFS_I(ip)->i_mode) || (VFS_I(ip)->i_mode == 0))
+	if (!S_ISREG(inode->i_mode) || (inode->i_mode == 0))
 		return 0;
 
 	/* If this is a read-only mount, don't do this (would generate I/O) */
@@ -1682,14 +1683,14 @@ xfs_release(
 		if (truncated) {
 			xfs_iflags_clear(ip, XFS_IDIRTY_RELEASE);
 			if (ip->i_delayed_blks > 0) {
-				error = filemap_flush(VFS_I(ip)->i_mapping);
+				error = filemap_flush(inode->i_mapping);
 				if (error)
 					return error;
 			}
 		}
 	}
 
-	if (VFS_I(ip)->i_nlink == 0)
+	if (inode->i_nlink == 0)
 		return 0;
 
 	if (xfs_can_free_eofblocks(ip, false)) {
@@ -1710,6 +1711,17 @@ xfs_release(
 		 */
 		if (xfs_iflags_test(ip, XFS_IDIRTY_RELEASE))
 			return 0;
+
+		/*
+		 * Skip if inode is under written back, because removing past
+		 * EOF blocks changes imap, shortens br_blockcount, which could
+		 * confuse the cached imap in xfs_vm_writepages() and
+		 * potentially result in writing data to wrong block in
+		 * writeback.
+		 */
+		if (mapping_tagged(inode->i_mapping, PAGECACHE_TAG_WRITEBACK))
+			return 0;
+
 		/*
 		 * If we can't get the iolock just skip truncating the blocks
 		 * past EOF because we could deadlock with the mmap_sem
-- 
2.13.5

