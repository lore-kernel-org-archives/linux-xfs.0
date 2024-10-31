Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C142419F430
	for <linux-xfs@vger.kernel.org>; Thu, 31 Oct 2024 23:12:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730416325; cv=none; b=Vxj0ba3LBv7IOQ+Npk+cDUwbnCoaXU/bB6TuYfEMevRfuDkQxDEzdl5FQonWPNHLHwOoj1A+HdKd3HAYJWx5i971oCV/jinugOIB2RsZrRS+rqkDT6F0bgV1w+IMlc0/NMvGJt6LdvmKZZBhZ4I4POkhI751PwpNm1u9vS2vOts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730416325; c=relaxed/simple;
	bh=puQ75ii0lltlveV/actzFuGRC1zAWDrLanJfuUqHLrI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BKCldNI+Y+04vYvJHPgla+oEnttpcVyoJfx6ZdqAoB87tQg7oyzpH8qtnL3ubonwWJMYHhTOl8avobw8rDGvhPifTqvt7Ux35VAySN4z2NeghcUQmwFa8YYxOVEI2fiADOW4lW/U+Eos7YZz0rRzzOb6+4CA7fWDvU0i8y4VCVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oNupHn6q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oNupHn6q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 951B8C4CEC3;
	Thu, 31 Oct 2024 23:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730416325;
	bh=puQ75ii0lltlveV/actzFuGRC1zAWDrLanJfuUqHLrI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=oNupHn6qxby0xP094s6ywD3rm2g5qS+scd0necCAuAJhyUC6uC22MuUQx1nfVhuCm
	 JCBcLqvUt7zxbQQdbPnRCpf4dMMXa7ypYRWW5Mh3pcQZhqZJVtxBB3yb+KVF+6uMOw
	 hy5wvpZItji77FLXuG8E94//YYCkEWQ6Rsng/rRZ2f0cs1nXDNUBnEhIIOXEaxNWWn
	 wOjIVL1wQqB4926+1ZLskV8V6064RccVWeCHpURjnQyRyxWURy7rXOkvhCSEdLT1zx
	 ATh2Uen315H5NYplUQ8xl9uQwh0SSaRp/zTQ2W2WEhCE5vhBEelUxibs1QQYEXWY3g
	 Y5mVebWU/5JfQ==
Date: Thu, 31 Oct 2024 16:12:05 -0700
Subject: [PATCH 13/41] xfs: push transaction join out of xfs_rtbitmap_lock and
 xfs_rtgroup_lock
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173041566117.962545.15007403731898758310.stgit@frogsfrogsfrogs>
In-Reply-To: <173041565874.962545.15559186670255081566.stgit@frogsfrogsfrogs>
References: <173041565874.962545.15559186670255081566.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: 0a59e4f3e1670bc49d60e1bd1a9b19ca156ae9cb

To prepare for being able to join an already locked rtbitmap inode to a
transaction split out separate helpers for joining the transaction from
the locking helpers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_bmap.c     |    3 ++-
 libxfs/xfs_rtbitmap.c |   24 +++++++++++++-----------
 libxfs/xfs_rtbitmap.h |    6 ++++--
 3 files changed, 19 insertions(+), 14 deletions(-)


diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 4b10f169f1eb94..1f63dc775ea393 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -5370,7 +5370,8 @@ xfs_bmap_del_extent_real(
 			 */
 			if (!(tp->t_flags & XFS_TRANS_RTBITMAP_LOCKED)) {
 				tp->t_flags |= XFS_TRANS_RTBITMAP_LOCKED;
-				xfs_rtbitmap_lock(tp, mp);
+				xfs_rtbitmap_lock(mp);
+				xfs_rtbitmap_trans_join(tp);
 			}
 			error = xfs_rtfree_blocks(tp, del->br_startblock,
 					del->br_blockcount);
diff --git a/libxfs/xfs_rtbitmap.c b/libxfs/xfs_rtbitmap.c
index 9d771af677adb1..c86de2aa13cea9 100644
--- a/libxfs/xfs_rtbitmap.c
+++ b/libxfs/xfs_rtbitmap.c
@@ -1199,23 +1199,25 @@ xfs_rtsummary_wordcount(
 	return XFS_FSB_TO_B(mp, blocks) >> XFS_WORDLOG;
 }
 
-/*
- * Lock both realtime free space metadata inodes for a freespace update.  If a
- * transaction is given, the inodes will be joined to the transaction and the
- * ILOCKs will be released on transaction commit.
- */
+/* Lock both realtime free space metadata inodes for a freespace update. */
 void
 xfs_rtbitmap_lock(
-	struct xfs_trans	*tp,
 	struct xfs_mount	*mp)
 {
 	xfs_ilock(mp->m_rbmip, XFS_ILOCK_EXCL | XFS_ILOCK_RTBITMAP);
-	if (tp)
-		xfs_trans_ijoin(tp, mp->m_rbmip, XFS_ILOCK_EXCL);
-
 	xfs_ilock(mp->m_rsumip, XFS_ILOCK_EXCL | XFS_ILOCK_RTSUM);
-	if (tp)
-		xfs_trans_ijoin(tp, mp->m_rsumip, XFS_ILOCK_EXCL);
+}
+
+/*
+ * Join both realtime free space metadata inodes to the transaction.  The
+ * ILOCKs will be released on transaction commit.
+ */
+void
+xfs_rtbitmap_trans_join(
+	struct xfs_trans	*tp)
+{
+	xfs_trans_ijoin(tp, tp->t_mountp->m_rbmip, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, tp->t_mountp->m_rsumip, XFS_ILOCK_EXCL);
 }
 
 /* Unlock both realtime free space metadata inodes after a freespace update. */
diff --git a/libxfs/xfs_rtbitmap.h b/libxfs/xfs_rtbitmap.h
index 0d5ab5e2cb6a32..523d3d3c12c608 100644
--- a/libxfs/xfs_rtbitmap.h
+++ b/libxfs/xfs_rtbitmap.h
@@ -346,8 +346,9 @@ unsigned long long xfs_rtsummary_wordcount(struct xfs_mount *mp,
 int xfs_rtfile_initialize_blocks(struct xfs_inode *ip,
 		xfs_fileoff_t offset_fsb, xfs_fileoff_t end_fsb, void *data);
 
-void xfs_rtbitmap_lock(struct xfs_trans *tp, struct xfs_mount *mp);
+void xfs_rtbitmap_lock(struct xfs_mount *mp);
 void xfs_rtbitmap_unlock(struct xfs_mount *mp);
+void xfs_rtbitmap_trans_join(struct xfs_trans *tp);
 
 /* Lock the rt bitmap inode in shared mode */
 #define XFS_RBMLOCK_BITMAP	(1U << 0)
@@ -376,7 +377,8 @@ xfs_rtbitmap_blockcount(struct xfs_mount *mp, xfs_rtbxlen_t rtextents)
 # define xfs_rtbitmap_wordcount(mp, r)			(0)
 # define xfs_rtsummary_blockcount(mp, l, b)		(0)
 # define xfs_rtsummary_wordcount(mp, l, b)		(0)
-# define xfs_rtbitmap_lock(tp, mp)		do { } while (0)
+# define xfs_rtbitmap_lock(mp)			do { } while (0)
+# define xfs_rtbitmap_trans_join(tp)		do { } while (0)
 # define xfs_rtbitmap_unlock(mp)		do { } while (0)
 # define xfs_rtbitmap_lock_shared(mp, lf)	do { } while (0)
 # define xfs_rtbitmap_unlock_shared(mp, lf)	do { } while (0)

