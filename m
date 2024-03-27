Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F4946125
	for <linux-xfs@vger.kernel.org>; Wed, 27 Mar 2024 11:03:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711537414; cv=none; b=fQXlIFWwsdNxAmwIxGYh9lhFUgYYxWsbP9sX/npAjvIiRcKMvhpaEXeR8vRb+p1CsQqaIoBcnwFq94siYxKLaZHOMO3J1lu5f45L6ujOs4g3iQQyE2kL1cxVsDT7XCuS2B9iqdBJROYIVoYh8IynyeWROGfPG1o22eZA9PxbPZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711537414; c=relaxed/simple;
	bh=7R6sW5ptA2d6Og3brP6HFTCqk24HhH06dPZUnxIoQsc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qCz2LkEeF1c2pODkoPME2ZqkrVFf0cNrMYfT3S1RJRcl7dBeQ61xoVALEhfnKEw8+l1zzTAm+pKVgAKHFsIqd8CSJK1vcC9zzZ6YrBRujENV/QyML0Fu5Q5UzZQhzVF1gW/qpzTpqjA1NKwraaCMYTQNN2S3665c7njHmKW8JrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=St+Kmf5J; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="St+Kmf5J"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=2b+vTaw1hsnHOPzrwMGhszOqZYh33rvU28DJVvWINCY=; b=St+Kmf5JxdROPTABSXcw2eg5hh
	wg2asAlp4qXlk50QMekN7R/eYq3E5cjgpNWMk1modALp3GuKOmXgBLx9wdeKe2sVcrHpxwEPm3llA
	VN8sNe7YJsnBbGJk3GYMdRxN3hwkXXJlorlEq78DyDW6978iyG+UxsxS7bL66jOuQL2MI78i14//I
	eon1dVuNrMt+5AcyjyzOLgB48mW3BaJTRFMPbF3wB077thsC+Nfg7r9RB5cUnXqXXK/IUPzvwyuxW
	ppLeOZZuxgQHTh4U7Xn02TaMeMyaGlosflv/5D76XSY/PFPLrZcGbGMYlMmGIw7NJGaE5DjV5p0Sr
	+ClENMRg==;
Received: from [89.144.223.137] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rpR45-00000008WWk-12j3;
	Wed, 27 Mar 2024 11:03:30 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 02/13] xfs: refactor realtime inode locking
Date: Wed, 27 Mar 2024 12:03:07 +0100
Message-Id: <20240327110318.2776850-3-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240327110318.2776850-1-hch@lst.de>
References: <20240327110318.2776850-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

From: "Darrick J. Wong" <djwong@kernel.org>

Create helper functions to deal with locking realtime metadata inodes.
This enables us to maintain correct locking order once we start adding
the realtime rmap and refcount btree inodes.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c     |  7 ++---
 fs/xfs/libxfs/xfs_rtbitmap.c | 57 ++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_rtbitmap.h | 17 +++++++++++
 fs/xfs/scrub/common.c        |  1 +
 fs/xfs/scrub/fscounters.c    |  4 +--
 fs/xfs/xfs_fsmap.c           |  4 +--
 fs/xfs/xfs_rtalloc.c         | 20 ++++---------
 7 files changed, 87 insertions(+), 23 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 656c95a22f2e6d..09d4b730ee9709 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -5416,12 +5416,9 @@ __xfs_bunmapi(
 
 	if (isrt) {
 		/*
-		 * Synchronize by locking the bitmap inode.
+		 * Synchronize by locking the realtime bitmap.
 		 */
-		xfs_ilock(mp->m_rbmip, XFS_ILOCK_EXCL|XFS_ILOCK_RTBITMAP);
-		xfs_trans_ijoin(tp, mp->m_rbmip, XFS_ILOCK_EXCL);
-		xfs_ilock(mp->m_rsumip, XFS_ILOCK_EXCL|XFS_ILOCK_RTSUM);
-		xfs_trans_ijoin(tp, mp->m_rsumip, XFS_ILOCK_EXCL);
+		xfs_rtbitmap_lock(tp, mp);
 	}
 
 	extno = 0;
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index f246d6dbf4eca8..386b672c505896 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -1168,3 +1168,60 @@ xfs_rtsummary_wordcount(
 	blocks = xfs_rtsummary_blockcount(mp, rsumlevels, rbmblocks);
 	return XFS_FSB_TO_B(mp, blocks) >> XFS_WORDLOG;
 }
+
+/*
+ * Lock both realtime free space metadata inodes for a freespace update.  If a
+ * transaction is given, the inodes will be joined to the transaction and the
+ * ILOCKs will be released on transaction commit.
+ */
+void
+xfs_rtbitmap_lock(
+	struct xfs_trans	*tp,
+	struct xfs_mount	*mp)
+{
+	xfs_ilock(mp->m_rbmip, XFS_ILOCK_EXCL | XFS_ILOCK_RTBITMAP);
+	if (tp)
+		xfs_trans_ijoin(tp, mp->m_rbmip, XFS_ILOCK_EXCL);
+
+	xfs_ilock(mp->m_rsumip, XFS_ILOCK_EXCL | XFS_ILOCK_RTSUM);
+	if (tp)
+		xfs_trans_ijoin(tp, mp->m_rsumip, XFS_ILOCK_EXCL);
+}
+
+/* Unlock both realtime free space metadata inodes after a freespace update. */
+void
+xfs_rtbitmap_unlock(
+	struct xfs_mount	*mp)
+{
+	xfs_iunlock(mp->m_rsumip, XFS_ILOCK_EXCL | XFS_ILOCK_RTSUM);
+	xfs_iunlock(mp->m_rbmip, XFS_ILOCK_EXCL | XFS_ILOCK_RTBITMAP);
+}
+
+/*
+ * Lock the realtime free space metadata inodes for a freespace scan.  Callers
+ * must walk metadata blocks in order of increasing file offset.
+ */
+void
+xfs_rtbitmap_lock_shared(
+	struct xfs_mount	*mp,
+	unsigned int		rbmlock_flags)
+{
+	if (rbmlock_flags & XFS_RBMLOCK_BITMAP)
+		xfs_ilock(mp->m_rbmip, XFS_ILOCK_SHARED | XFS_ILOCK_RTBITMAP);
+
+	if (rbmlock_flags & XFS_RBMLOCK_SUMMARY)
+		xfs_ilock(mp->m_rsumip, XFS_ILOCK_SHARED | XFS_ILOCK_RTSUM);
+}
+
+/* Unlock the realtime free space metadata inodes after a freespace scan. */
+void
+xfs_rtbitmap_unlock_shared(
+	struct xfs_mount	*mp,
+	unsigned int		rbmlock_flags)
+{
+	if (rbmlock_flags & XFS_RBMLOCK_SUMMARY)
+		xfs_iunlock(mp->m_rsumip, XFS_ILOCK_SHARED | XFS_ILOCK_RTSUM);
+
+	if (rbmlock_flags & XFS_RBMLOCK_BITMAP)
+		xfs_iunlock(mp->m_rbmip, XFS_ILOCK_SHARED | XFS_ILOCK_RTBITMAP);
+}
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.h b/fs/xfs/libxfs/xfs_rtbitmap.h
index 152a66750af554..6186585f2c376d 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.h
+++ b/fs/xfs/libxfs/xfs_rtbitmap.h
@@ -360,6 +360,19 @@ xfs_filblks_t xfs_rtsummary_blockcount(struct xfs_mount *mp,
 		unsigned int rsumlevels, xfs_extlen_t rbmblocks);
 unsigned long long xfs_rtsummary_wordcount(struct xfs_mount *mp,
 		unsigned int rsumlevels, xfs_extlen_t rbmblocks);
+
+void xfs_rtbitmap_lock(struct xfs_trans *tp, struct xfs_mount *mp);
+void xfs_rtbitmap_unlock(struct xfs_mount *mp);
+
+/* Lock the rt bitmap inode in shared mode */
+#define XFS_RBMLOCK_BITMAP	(1U << 0)
+/* Lock the rt summary inode in shared mode */
+#define XFS_RBMLOCK_SUMMARY	(1U << 1)
+
+void xfs_rtbitmap_lock_shared(struct xfs_mount *mp,
+		unsigned int rbmlock_flags);
+void xfs_rtbitmap_unlock_shared(struct xfs_mount *mp,
+		unsigned int rbmlock_flags);
 #else /* CONFIG_XFS_RT */
 # define xfs_rtfree_extent(t,b,l)			(-ENOSYS)
 # define xfs_rtfree_blocks(t,rb,rl)			(-ENOSYS)
@@ -378,6 +391,10 @@ xfs_rtbitmap_blockcount(struct xfs_mount *mp, xfs_rtbxlen_t rtextents)
 # define xfs_rtbitmap_wordcount(mp, r)			(0)
 # define xfs_rtsummary_blockcount(mp, l, b)		(0)
 # define xfs_rtsummary_wordcount(mp, l, b)		(0)
+# define xfs_rtbitmap_lock(tp, mp)		do { } while (0)
+# define xfs_rtbitmap_unlock(mp)		do { } while (0)
+# define xfs_rtbitmap_lock_shared(mp, lf)	do { } while (0)
+# define xfs_rtbitmap_unlock_shared(mp, lf)	do { } while (0)
 #endif /* CONFIG_XFS_RT */
 
 #endif /* __XFS_RTBITMAP_H__ */
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 47a20cf5205f00..48887a163e6a3b 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -31,6 +31,7 @@
 #include "xfs_ag.h"
 #include "xfs_error.h"
 #include "xfs_quota.h"
+#include "xfs_rtbitmap.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/trace.h"
diff --git a/fs/xfs/scrub/fscounters.c b/fs/xfs/scrub/fscounters.c
index d310737c882367..2b4bd2eb71b57d 100644
--- a/fs/xfs/scrub/fscounters.c
+++ b/fs/xfs/scrub/fscounters.c
@@ -415,7 +415,7 @@ xchk_fscount_count_frextents(
 	if (!xfs_has_realtime(mp))
 		return 0;
 
-	xfs_ilock(sc->mp->m_rbmip, XFS_ILOCK_SHARED | XFS_ILOCK_RTBITMAP);
+	xfs_rtbitmap_lock_shared(sc->mp, XFS_RBMLOCK_BITMAP);
 	error = xfs_rtalloc_query_all(sc->mp, sc->tp,
 			xchk_fscount_add_frextent, fsc);
 	if (error) {
@@ -424,7 +424,7 @@ xchk_fscount_count_frextents(
 	}
 
 out_unlock:
-	xfs_iunlock(sc->mp->m_rbmip, XFS_ILOCK_SHARED | XFS_ILOCK_RTBITMAP);
+	xfs_rtbitmap_unlock_shared(sc->mp, XFS_RBMLOCK_BITMAP);
 	return error;
 }
 #else
diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index de59eec7476575..85dbb46452ca0b 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -533,7 +533,7 @@ xfs_getfsmap_rtdev_rtbitmap(
 	trace_xfs_fsmap_low_key_linear(mp, info->dev, start_rtb);
 	trace_xfs_fsmap_high_key_linear(mp, info->dev, end_rtb);
 
-	xfs_ilock(mp->m_rbmip, XFS_ILOCK_SHARED | XFS_ILOCK_RTBITMAP);
+	xfs_rtbitmap_lock_shared(mp, XFS_RBMLOCK_BITMAP);
 
 	/*
 	 * Set up query parameters to return free rtextents covering the range
@@ -557,7 +557,7 @@ xfs_getfsmap_rtdev_rtbitmap(
 	if (error)
 		goto err;
 err:
-	xfs_iunlock(mp->m_rbmip, XFS_ILOCK_SHARED | XFS_ILOCK_RTBITMAP);
+	xfs_rtbitmap_unlock_shared(mp, XFS_RBMLOCK_BITMAP);
 	return error;
 }
 #endif /* CONFIG_XFS_RT */
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index e66f9bd5de5cff..86f928d30feda9 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -957,10 +957,10 @@ xfs_growfs_rt(
 		nargs.tp = tp;
 
 		/*
-		 * Lock out other callers by grabbing the bitmap inode lock.
+		 * Lock out other callers by grabbing the bitmap and summary
+		 * inode locks and joining them to the transaction.
 		 */
-		xfs_ilock(mp->m_rbmip, XFS_ILOCK_EXCL | XFS_ILOCK_RTBITMAP);
-		xfs_trans_ijoin(tp, mp->m_rbmip, XFS_ILOCK_EXCL);
+		xfs_rtbitmap_lock(tp, mp);
 		/*
 		 * Update the bitmap inode's size ondisk and incore.  We need
 		 * to update the incore size so that inode inactivation won't
@@ -970,11 +970,6 @@ xfs_growfs_rt(
 			nsbp->sb_rbmblocks * nsbp->sb_blocksize;
 		i_size_write(VFS_I(mp->m_rbmip), mp->m_rbmip->i_disk_size);
 		xfs_trans_log_inode(tp, mp->m_rbmip, XFS_ILOG_CORE);
-		/*
-		 * Get the summary inode into the transaction.
-		 */
-		xfs_ilock(mp->m_rsumip, XFS_ILOCK_EXCL | XFS_ILOCK_RTSUM);
-		xfs_trans_ijoin(tp, mp->m_rsumip, XFS_ILOCK_EXCL);
 		/*
 		 * Update the summary inode's size.  We need to update the
 		 * incore size so that inode inactivation won't punch what it
@@ -1142,10 +1137,10 @@ xfs_rtalloc_reinit_frextents(
 	uint64_t		val = 0;
 	int			error;
 
-	xfs_ilock(mp->m_rbmip, XFS_ILOCK_SHARED | XFS_ILOCK_RTBITMAP);
+	xfs_rtbitmap_lock_shared(mp, XFS_RBMLOCK_BITMAP);
 	error = xfs_rtalloc_query_all(mp, NULL, xfs_rtalloc_count_frextent,
 			&val);
-	xfs_iunlock(mp->m_rbmip, XFS_ILOCK_SHARED | XFS_ILOCK_RTBITMAP);
+	xfs_rtbitmap_unlock_shared(mp, XFS_RBMLOCK_BITMAP);
 	if (error)
 		return error;
 
@@ -1382,10 +1377,7 @@ xfs_bmap_rtalloc(
 	 * Lock out modifications to both the RT bitmap and summary inodes
 	 */
 	if (!rtlocked) {
-		xfs_ilock(mp->m_rbmip, XFS_ILOCK_EXCL|XFS_ILOCK_RTBITMAP);
-		xfs_trans_ijoin(ap->tp, mp->m_rbmip, XFS_ILOCK_EXCL);
-		xfs_ilock(mp->m_rsumip, XFS_ILOCK_EXCL|XFS_ILOCK_RTSUM);
-		xfs_trans_ijoin(ap->tp, mp->m_rsumip, XFS_ILOCK_EXCL);
+		xfs_rtbitmap_lock(ap->tp, mp);
 		rtlocked = true;
 	}
 
-- 
2.39.2

