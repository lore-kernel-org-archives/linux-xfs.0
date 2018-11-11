Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pg1-f195.google.com ([209.85.215.195]:42567 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727145AbeKKNra (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 11 Nov 2018 08:47:30 -0500
Received: by mail-pg1-f195.google.com with SMTP id i4-v6so2530556pgq.9
        for <linux-xfs@vger.kernel.org>; Sat, 10 Nov 2018 20:00:10 -0800 (PST)
From: Omar Sandoval <osandov@osandov.com>
Subject: [PATCH v2] xfs: cache minimum realtime summary level
Date: Sat, 10 Nov 2018 19:59:58 -0800
Message-Id: <49a31389f88ab40b11f07afa5c728a1368e39a45.1541908447.git.osandov@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: kernel-team@fb.com

From: Omar Sandoval <osandov@fb.com>

The realtime summary is a two-dimensional array on disk, effectively:

u32 rsum[log2(number of realtime extents) + 1][number of blocks in the bitmap]

rsum[log][bbno] is the number of extents of size 2**log which start in
bitmap block bbno.

xfs_rtallocate_extent_near() uses xfs_rtany_summary() to check whether
rsum[log][bbno] != 0 for any log level. However, the summary array is
stored in row-major order (i.e., like an array in C), so all of these
entries are not adjacent, but rather spread across the entire summary
file. In the worst case (a full bitmap block), xfs_rtany_summary() has
to check every level.

This means that on a moderately-used realtime device, an allocation will
waste a lot of time finding, reading, and releasing buffers for the
realtime summary. In particular, one of our storage services (which runs
on servers with 8 very slow CPUs and 15 8 TB XFS realtime filesystems)
spends almost 5% of its CPU cycles in xfs_rtbuf_get() and
xfs_trans_brelse() called from xfs_rtany_summary().

One solution would be to also store the summary with the dimensions
swapped. However, this would require a disk format change to a very old
component of XFS.

Instead, we can cache the minimum size which contains any extents. We do
so lazily; rather than guaranteeing that the cache contains the precise
minimum, it always contains a loose lower bound which we tighten when we
read or update a summary block. This only uses a few kilobytes of memory
and is already serialized via the realtime bitmap and summary inode
locks, so the cost is minimal. With this change, the same workload only
spends 0.2% of its CPU cycles in the realtime allocator.

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
Based on Linus' master branch.

Changes from v1:
- Clarify comment in xfs_rtmount_inodes().
- Use kmem_* instead of kvmalloc/kvfree

 fs/xfs/libxfs/xfs_rtbitmap.c |  4 ++++
 fs/xfs/xfs_mount.h           |  6 ++++++
 fs/xfs/xfs_rtalloc.c         | 27 +++++++++++++++++++++++----
 3 files changed, 33 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index b228c821bae6..6d4990717cee 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -505,6 +505,10 @@ xfs_rtmodify_summary_int(
 		uint first = (uint)((char *)sp - (char *)bp->b_addr);
 
 		*sp += delta;
+		if (*sp == 0 && log == mp->m_rsum_cache[bbno])
+			mp->m_rsum_cache[bbno]++;
+		if (*sp != 0 && log < mp->m_rsum_cache[bbno])
+			mp->m_rsum_cache[bbno] = log;
 		xfs_trans_log_buf(tp, bp, first, first + sizeof(*sp) - 1);
 	}
 	if (sum)
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 7964513c3128..2b626a4b4824 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -89,6 +89,12 @@ typedef struct xfs_mount {
 	int			m_logbsize;	/* size of each log buffer */
 	uint			m_rsumlevels;	/* rt summary levels */
 	uint			m_rsumsize;	/* size of rt summary, bytes */
+	/*
+	 * Cache of rt summary level per bitmap block with the invariant that
+	 * m_rsum_cache[bbno] <= the minimum i for which rsum[i][bbno] != 0.
+	 * Reads and writes are serialized by the rsumip inode lock.
+	 */
+	uint8_t			*m_rsum_cache;
 	struct xfs_inode	*m_rbmip;	/* pointer to bitmap inode */
 	struct xfs_inode	*m_rsumip;	/* pointer to summary inode */
 	struct xfs_inode	*m_rootip;	/* pointer to root directory */
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 926ed314ffba..330406e0af14 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -64,8 +64,12 @@ xfs_rtany_summary(
 	int		log;		/* loop counter, log2 of ext. size */
 	xfs_suminfo_t	sum;		/* summary data */
 
+	/* There are no extents at levels < m_rsum_cache[bbno]. */
+	if (low < mp->m_rsum_cache[bbno])
+		low = mp->m_rsum_cache[bbno];
+
 	/*
-	 * Loop over logs of extent sizes.  Order is irrelevant.
+	 * Loop over logs of extent sizes.
 	 */
 	for (log = low; log <= high; log++) {
 		/*
@@ -80,13 +84,17 @@ xfs_rtany_summary(
 		 */
 		if (sum) {
 			*stat = 1;
-			return 0;
+			goto out;
 		}
 	}
 	/*
 	 * Found nothing, return failure.
 	 */
 	*stat = 0;
+out:
+	/* There were no extents at levels < log. */
+	if (log > mp->m_rsum_cache[bbno])
+		mp->m_rsum_cache[bbno] = log;
 	return 0;
 }
 
@@ -1187,8 +1195,8 @@ xfs_rtmount_init(
 }
 
 /*
- * Get the bitmap and summary inodes into the mount structure
- * at mount time.
+ * Get the bitmap and summary inodes and the summary cache into the mount
+ * structure at mount time.
  */
 int					/* error */
 xfs_rtmount_inodes(
@@ -1211,6 +1219,16 @@ xfs_rtmount_inodes(
 		return error;
 	}
 	ASSERT(mp->m_rsumip != NULL);
+	/*
+	 * The rsum cache is initialized to all zeroes, which is trivially a
+	 * lower bound on the minimum level with any free extents.
+	 */
+	mp->m_rsum_cache = kmem_zalloc_large(sbp->sb_rbmblocks, KM_SLEEP);
+	if (!mp->m_rsum_cache) {
+		xfs_irele(mp->m_rbmip);
+		xfs_irele(mp->m_rsumip);
+		return -ENOMEM;
+	}
 	return 0;
 }
 
@@ -1218,6 +1236,7 @@ void
 xfs_rtunmount_inodes(
 	struct xfs_mount	*mp)
 {
+	kmem_free(mp->m_rsum_cache);
 	if (mp->m_rbmip)
 		xfs_irele(mp->m_rbmip);
 	if (mp->m_rsumip)
-- 
2.19.1
