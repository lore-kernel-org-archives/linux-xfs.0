Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D3EC10E9
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:32:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722299528; cv=none; b=d+w+js76VMeAXsosJN4cdtQNYsw5Ip8xXq2bvhs5wYgF4Vl8MSEtsEXywn6mrYZXr3mSajCOR84GbH36pbNpTL6+90c0YU86V0Uwq3uGHDnxNytKh6jBg3mzPFfdh7FDR1ZypBIJR+jLuKjb5utI6LoUB1fiEWmButblmFtMvnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722299528; c=relaxed/simple;
	bh=SBm8C8bObeUPQXjYiatG6+ooHe4gUdRyYKW+4XxOXM8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=URnkIdgKIb7Geeq47ac5JBy9gOBwX/JiwYu1/YptESq2edLR0vX0SirRuiEQa2qV8a1fh9CYipgsh7zD9SySlJlJI0nIzJ8MdqXpVanFxPa14bYtkXKF/opDJtd4sQCYCUlTkMlC0qNuG1FBhu2/Zf/kNBga24nusW5ab5dh2sc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Lb9a1j8e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Lb9a1j8e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EF02C4AF07;
	Tue, 30 Jul 2024 00:32:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722299527;
	bh=SBm8C8bObeUPQXjYiatG6+ooHe4gUdRyYKW+4XxOXM8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Lb9a1j8egA9GiCyu0o+X+Ho6beBlN+lMWCnvRlYT9llPiHSiIdWQtwfF37yzvh2iZ
	 4rxc1kRRg0tBHZ6WhLWns1EBmQK3avjSnEmqgzEAU9mY6XQt+G3TD8mywMc0BvbhrY
	 CVRyRdFRIGnL2C1tRcuItaotC4VqyJTTh8WJTmZ35qv4cJxhCUNRyyV68KXOUnBAAt
	 lvbSLeeekdLRn1UWFgN14K8QCiHpYObjFMrQKdwDaXTJdQ30pFNVYORoqVEu3W+sJ9
	 BImoNYuq2KPQytStxt27IyobA1SELlhv+KKDCTNyA7Lbtb/ZGjtMfiFdaGZWwY/yKa
	 iQTpaZHxY72pA==
Date: Mon, 29 Jul 2024 17:32:07 -0700
Subject: [PATCH 032/115] xfs: refactor realtime inode locking
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Dave Chinner <dchinner@redhat.com>,
 Chandan Babu R <chandanbabu@kernel.org>, linux-xfs@vger.kernel.org
Message-ID: <172229842895.1338752.7344801696812241993.stgit@frogsfrogsfrogs>
In-Reply-To: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
References: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: b7e23c0e2e3b1c520a3370f058870b914071a470

Create helper functions to deal with locking realtime metadata inodes.
This enables us to maintain correct locking order once we start adding
the realtime rmap and refcount btree inodes.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
---
 libxfs/libxfs_priv.h  |    3 +++
 libxfs/xfs_bmap.c     |    7 ++----
 libxfs/xfs_rtbitmap.c |   57 +++++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_rtbitmap.h |   17 +++++++++++++++
 4 files changed, 79 insertions(+), 5 deletions(-)


diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index aa0a3adb4..fa7cad0e0 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -170,6 +170,9 @@ enum ce { CE_DEBUG, CE_CONT, CE_NOTE, CE_WARN, CE_ALERT, CE_PANIC };
 
 #define XFS_ERRLEVEL_LOW		1
 #define XFS_ILOCK_EXCL			0
+#define XFS_ILOCK_SHARED		0
+#define XFS_ILOCK_RTBITMAP		0
+#define XFS_ILOCK_RTSUM			0
 #define XFS_STATS_INC(mp, count)	do { (mp) = (mp); } while (0)
 #define XFS_STATS_DEC(mp, count, x)	do { (mp) = (mp); } while (0)
 #define XFS_STATS_ADD(mp, count, x)	do { (mp) = (mp); } while (0)
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 63feb20e2..f339e16a1 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -5412,12 +5412,9 @@ __xfs_bunmapi(
 
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
index 543cfd2fb..58a3ba992 100644
--- a/libxfs/xfs_rtbitmap.c
+++ b/libxfs/xfs_rtbitmap.c
@@ -1166,3 +1166,60 @@ xfs_rtsummary_wordcount(
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
index 152a66750..6186585f2 100644
--- a/libxfs/xfs_rtbitmap.h
+++ b/libxfs/xfs_rtbitmap.h
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

