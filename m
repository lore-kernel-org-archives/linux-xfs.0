Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14ED31465A8
	for <linux-xfs@vger.kernel.org>; Mon, 22 Apr 2024 11:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713784832; cv=none; b=r+6UBCoPEcQFubAchOe3+76UrlSx1NQNYtwY+ewckyyRdMe4EHcsgDhu4bFoF/I06aPCgawJm77tE3R+L7sLLzHEGUKH5wajSRvoyv72tlQtCjCbiQR2zzMGe90vzb5MgQRlMdK68bKszCu4/eFfoYS2+PA2x4PPAN0Omuc4EPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713784832; c=relaxed/simple;
	bh=VDNy3pcET7x9+z7m/ONVdtcLbZeitrYwaSFZXOZXSb4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qH1VvJowTARUQx+QmXznTa6wS/dc8IXDYgGV68D4bWaEGrlor30pMBLg0J5/g48NFSjJnh/ZNgIrRubZ+5ie6pWB048+i3+zB0rlXDq8MEQg1UexUAaAmLPiH/rjA4/Ob/5ixuYc6U/GyS36RVnIJlMLT9LfaREY4PoXc0o3Upg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=1f3JIA4H; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="1f3JIA4H"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=sB1Y+gRfR1DGqonPdEeznq+nFa45twz6CXQU7IIrxAo=; b=1f3JIA4Hv9O509c8jUFKbUmVp4
	H6snjpvkFrNYdrRqrJZsmxsW7iQeLvScRMhnICyNMvKYjJsr5rAQCouvm4TQHC2hbsKGOvqkRR3Mn
	EaLOh3rHZavHq4v8Lm9KfHFM6yA4d5cj7ge1H2XCJbFqzZaSvxDp6HNFX4+1pyj0jbmw93oo5AHYh
	dBULGMqpkuKr48RThXRYmsSgiOo4+/7IMj5pDUArpiHmRpJzHVdhFDcvxlyYahq61s6+dTESHEcxK
	4w+cL0McQF+TNZoD0rCaTpJqEZoz3AehnghSzPXQ55rAV5IjaSltYeJk2jtvagEF/v+CjJ7Z7R3aU
	1gM3UMaw==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1ryrin-0000000DKzT-3gl4;
	Mon, 22 Apr 2024 11:20:30 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	linux-xfs@vger.kernel.org,
	Dave Chinner <dchinner@redhat.com>
Subject: [PATCH 02/13] xfs: refactor realtime inode locking
Date: Mon, 22 Apr 2024 13:20:08 +0200
Message-Id: <20240422112019.212467-3-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240422112019.212467-1-hch@lst.de>
References: <20240422112019.212467-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Create helper functions to deal with locking realtime metadata inodes.
This enables us to maintain correct locking order once we start adding
the realtime rmap and refcount btree inodes.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
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
index 59b8b9dc29ccff..3e56173a8fe4db 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -5418,12 +5418,9 @@ __xfs_bunmapi(
 
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
index 48302532d10d13..a7d3a22796620c 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -32,6 +32,7 @@
 #include "xfs_error.h"
 #include "xfs_quota.h"
 #include "xfs_exchmaps.h"
+#include "xfs_rtbitmap.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/trace.h"
diff --git a/fs/xfs/scrub/fscounters.c b/fs/xfs/scrub/fscounters.c
index da2f6729699dd4..67ac870052b16d 100644
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

