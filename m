Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail01.adl6.internode.on.net ([150.101.137.136]:65443 "EHLO
        ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750835AbdH3H3y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Aug 2017 03:29:54 -0400
Date: Wed, 30 Aug 2017 17:29:50 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: skip free eofblocks if inode is under written back
Message-ID: <20170830072950.GJ10621@dastard>
References: <20170830042628.5592-1-eguan@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170830042628.5592-1-eguan@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Aug 30, 2017 at 12:26:28PM +0800, Eryu Guan wrote:
> xfs_vm_writepages() saves a cached imap in a writeback context
> structure and passes it to xfs_do_writepage() for every page in this
> writeback, so xfs_writepage_map() (called by xfs_do_writepage())
> doesn't have to lookup & recalculate the mapping for every buffer it
> writes if the cached imap is considered as valid.
> 
> But there's a chance that the cached imap becomes stale (doesn't
> match the real extent entry) due to the removing of speculative
> preallocated blocks, in this case xfs_imap_valid() still reports
> imap as valid, because the buffer it's writing is still within the
> cached imap range. This could result in fs corruption and data
> corruption (data written to wrong block).
> 
> For example, the following sequences make it possible (assuming 4k
> block size XFS):
> 
>   1. delalloc write 1072 blocks, with speculative preallocation,
>   2032 blocks got allocated
> 
>   2. started a WB_SYNC_NONE writeback (so it wrote all
>   PAGECACHE_TAG_DIRTY pages, additional dirty page from step 4 can
>   be picked up, this could be a background writeback, or a bare
>   SYNC_FILE_RANGE_WRITE sync_file_range() call) on this inode,
>   filled in br_startblock, converted delayed allocation to real
>   allocation, but br_blockcount was unchanged, still 2032, and this
>   imap got cached in writeback context structure for writing
>   subsequent pages

Excellent work in tracking this down, Eryu! This has been a
longstanding issue - we've been caching the writeback map for
multi-page writeback since, well, longer than I've been working on
XFS....

First thing - checking for PAGECACHE_TAG_WRITEBACK in xfs_release()
is racy as writeback can start between the check and the EOF blocks
being trimmed in xfs_free_eofblocks(), so it's not really a solution
to the problem.

The root cause of the problem is that xfs_imap_valid() code doesn't
return false when the extent tree is modified and the map is
rendered potentially incorrect. If this was to notice we changed the
extent tree, it would trigger the writeback code to look up a new
map.

Hmmmm, that means the scope is probably wider than
xfs_free_eofblocks() - that's a xfs_bunmapi call, but we've also got
to consider that other IO operations might change the extent map,
too.

Quick patch below, doesn't work on reflink filesystems yet because
the way it handles cached COW mapping invalidation is unnecessarily
special and so doesn't work. Can you test it and see if it fixes the
problem?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

xfs: invalidate writepage mappings on extent modification

From: Dave Chinner <dchinner@redhat.com>

Pretty sure this breaks COW writeback because it's a separate
mapping path in xfs_writepage_map() and can't handle random
invalidations. More factoring is needed there to unify the
xfs_map_cow() with xfs_map_blocks() to prevent this:

XFS: Assertion failed: type != XFS_IO_COW, file: fs/xfs/xfs_aops.c, line: 357

Signed-Off-By: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_bmap.c |  7 ++++++-
 fs/xfs/xfs_aops.c        | 12 ++++++++++++
 fs/xfs/xfs_inode.h       |  6 ++++++
 fs/xfs/xfs_iomap.c       | 34 ++++++++++++++++++++++++++++++++++
 4 files changed, 58 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 9b877024c804..7ec44a39a6b6 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4156,7 +4156,6 @@ xfs_bmapi_reserve_delalloc(
 	if (error)
 		goto out_unreserve_blocks;
 
-
 	ip->i_delayed_blks += alen;
 
 	got->br_startoff = aoff;
@@ -5485,6 +5484,12 @@ __xfs_bunmapi(
 	bno = start + len - 1;
 
 	/*
+	 * We're about to make an extent map modification. Ensure any cached
+	 * writeback mapping is invalidated before it is used next.
+	 */
+	xfs_iflags_set(ip, XFS_IWBMAPINVALID);
+
+	/*
 	 * Check to see if the given block number is past the end of the
 	 * file, back up to the last block if so...
 	 */
diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 6bf120bb1a17..2398bdc554c0 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -376,6 +376,12 @@ xfs_map_blocks(
 	 */
 	if (nimaps && type == XFS_IO_OVERWRITE)
 		xfs_reflink_trim_irec_to_next_cow(ip, offset_fsb, imap);
+
+	/*
+	 * We just got a new mapping for page writeback, so clear the writeback
+	 * map invalid flag before we drop the ilock.
+	 */
+	xfs_iflags_clear(ip, XFS_IWBMAPINVALID);
 	xfs_iunlock(ip, XFS_ILOCK_SHARED);
 
 	if (error)
@@ -408,6 +414,12 @@ xfs_imap_valid(
 	struct xfs_bmbt_irec	*imap,
 	xfs_off_t		offset)
 {
+	/*
+	 * Extent list modification invalidates the currently cached map.
+	 */
+	if (xfs_iflags_test(XFS_I(inode), XFS_IWBMAPINVALID))
+		return false;
+
 	offset >>= inode->i_blkbits;
 
 	return offset >= imap->br_startoff &&
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 0ee453de239a..b08921b6b20c 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -234,6 +234,12 @@ static inline bool xfs_is_reflink_inode(struct xfs_inode *ip)
 #define XFS_IRECOVERY		(1 << 11)
 
 /*
+ * If the extent map of an inode is being modified, then any cached
+ * map in the writeback code needs to be invalidated
+ */
+#define XFS_IWBMAPINVALID		(1 << 12)
+
+/*
  * Per-lifetime flags need to be reset when re-using a reclaimable inode during
  * inode lookup. This prevents unintended behaviour on the new inode from
  * ocurring.
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 1b625d050441..c10f2a1aa0d8 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -260,6 +260,12 @@ xfs_iomap_write_direct(
 	xfs_trans_ijoin(tp, ip, 0);
 
 	/*
+	 * We're about to make an extent map modification.  Ensure any cached
+	 * writeback mapping is invalidated before it is used next.
+	 */
+	xfs_iflags_set(ip, XFS_IWBMAPINVALID);
+
+	/*
 	 * From this point onwards we overwrite the imap pointer that the
 	 * caller gave to us.
 	 */
@@ -562,6 +568,13 @@ xfs_file_iomap_begin_delay(
 		if (xfs_is_reflink_inode(ip)) {
 			bool		shared;
 
+			/*
+			 * We're about to make an extent map modification.
+			 * Ensure any cached writeback mapping is invalidated
+			 * before it is used next.
+			 */
+			xfs_iflags_set(ip, XFS_IWBMAPINVALID);
+
 			end_fsb = min(XFS_B_TO_FSB(mp, offset + count),
 					maxbytes_fsb);
 			xfs_trim_extent(&got, offset_fsb, end_fsb - offset_fsb);
@@ -612,6 +625,12 @@ xfs_file_iomap_begin_delay(
 	}
 
 retry:
+	/*
+	 * We're about to make an extent map modification.  Ensure any cached
+	 * writeback mapping is invalidated before it is used next.
+	 */
+	xfs_iflags_set(ip, XFS_IWBMAPINVALID);
+
 	error = xfs_bmapi_reserve_delalloc(ip, XFS_DATA_FORK, offset_fsb,
 			end_fsb - offset_fsb, prealloc_blocks, &got, &idx, eof);
 	switch (error) {
@@ -792,6 +811,13 @@ xfs_iomap_write_allocate(
 			if (error)
 				goto error0;
 
+			/*
+			 * We just got a new mapping for page writeback, so
+			 * clear the writeback map invalid flag before we drop
+			 * the ilock.
+			 */
+			xfs_iflags_clear(ip, XFS_IWBMAPINVALID);
+
 			xfs_iunlock(ip, XFS_ILOCK_EXCL);
 		}
 
@@ -1054,6 +1080,14 @@ xfs_file_iomap_begin(
 			error = -EAGAIN;
 			goto out_unlock;
 		}
+
+		/*
+		 * We're about to make an extent map modification.  Ensure any
+		 * cached writeback mapping is invalidated before it is used
+		 * next.
+		 */
+		xfs_iflags_set(ip, XFS_IWBMAPINVALID);
+
 		/*
 		 * We cap the maximum length we map here to MAX_WRITEBACK_PAGES
 		 * pages to keep the chunks of work done where somewhat symmetric
