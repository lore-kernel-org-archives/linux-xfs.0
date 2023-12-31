Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEEE2C2C0
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G9A3KzzX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 355C2C433C8;
	Sun, 31 Dec 2023 23:47:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704066439;
	bh=zSnmF8pwWboFaKfSKgIH66VWyiO7c3G0J7BiznPbKts=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=G9A3KzzX8db4kVUWT2ooyTCeLBvhlXcgGWnwNwTf5vOJ9Ixp9r0zxca8SAt40C2SG
	 jAr2uIZs+94P7QPTabaPKvBbelDcvIIPLEp0SS8EgLHYiFI3nhQdAwVckpAPxHJF19
	 DEI1Lf8UGHDl9Q5Y5I93KxyY/Z7LnIEEZrm+k+Zhm6ePAHneKPW8g6k8czSjv8GwQO
	 bcI0zFjwZmAY8mESIF2FIYZKoTWl2rtVcNfwCl1Vu6XO4+fJZe77+1J57IYusEC8w5
	 kT9eKQ22SpadBDYt95XY618hiXi3qjAdRPw+5q8m15Xo0Ear9JIPneQCmf6SFtWULq
	 OxtNeddWGUh3w==
Date: Sun, 31 Dec 2023 15:47:18 -0800
Subject: [PATCH 1/2] xfs: refactor realtime inode locking
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405011762.1811141.3689996494445152207.stgit@frogsfrogsfrogs>
In-Reply-To: <170405011748.1811141.16068744852666586384.stgit@frogsfrogsfrogs>
References: <170405011748.1811141.16068744852666586384.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Create helper functions to deal with locking realtime metadata inodes.
This enables us to maintain correct locking order once we start adding
the realtime rmap and refcount btree inodes.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/libxfs_priv.h  |    3 +++
 libxfs/xfs_bmap.c     |    7 ++----
 libxfs/xfs_rtbitmap.c |   57 +++++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_rtbitmap.h |   17 +++++++++++++++
 4 files changed, 79 insertions(+), 5 deletions(-)


diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index f4614ee9631..178330aafa1 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -174,9 +174,12 @@ enum ce { CE_DEBUG, CE_CONT, CE_NOTE, CE_WARN, CE_ALERT, CE_PANIC };
 	(unlikely(expr) ? XFS_WARN_CORRUPT((mp), (expr)) : false)
 
 #define XFS_ERRLEVEL_LOW		1
+#define XFS_ILOCK_SHARED		0
 #define XFS_ILOCK_EXCL			0
 #define XFS_IOLOCK_SHARED		0
 #define XFS_IOLOCK_EXCL			0
+#define XFS_ILOCK_RTSUM			0
+#define XFS_ILOCK_RTBITMAP		0
 #define XFS_STATS_INC(mp, count)	do { (mp) = (mp); } while (0)
 #define XFS_STATS_DEC(mp, count, x)	do { (mp) = (mp); } while (0)
 #define XFS_STATS_ADD(mp, count, x)	do { (mp) = (mp); } while (0)
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 0dfb37073a7..c69cb5c66df 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -5370,12 +5370,9 @@ __xfs_bunmapi(
 
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
diff --git a/libxfs/xfs_rtbitmap.c b/libxfs/xfs_rtbitmap.c
index b4da1b07c73..72d9d0f0ec9 100644
--- a/libxfs/xfs_rtbitmap.c
+++ b/libxfs/xfs_rtbitmap.c
@@ -1192,3 +1192,60 @@ xfs_rtsummary_wordcount(
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
diff --git a/libxfs/xfs_rtbitmap.h b/libxfs/xfs_rtbitmap.h
index 1c84b52de3d..6ac17f0195e 100644
--- a/libxfs/xfs_rtbitmap.h
+++ b/libxfs/xfs_rtbitmap.h
@@ -374,6 +374,19 @@ xfs_filblks_t xfs_rtsummary_blockcount(struct xfs_mount *mp,
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
@@ -394,6 +407,10 @@ xfs_rtbitmap_blockcount(struct xfs_mount *mp, xfs_rtbxlen_t rtextents)
 # define xfs_rtbitmap_wordcount(mp, r)			(0)
 # define xfs_rtsummary_blockcount(mp, l, b)		(0)
 # define xfs_rtsummary_wordcount(mp, l, b)		(0)
+# define xfs_rtbitmap_lock(tp, mp)		do { } while (0)
+# define xfs_rtbitmap_unlock(mp)		do { } while (0)
+# define xfs_rtbitmap_lock_shared(mp, lf)	do { } while (0)
+# define xfs_rtbitmap_unlock_shared(mp, lf)	do { } while (0)
 #endif /* CONFIG_XFS_RT */
 
 #endif /* __XFS_RTBITMAP_H__ */

