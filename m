Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 957081FDF85
	for <linux-xfs@vger.kernel.org>; Mon, 21 Oct 2024 22:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729548139; cv=none; b=a/9iUYxfa/u8DgjqMn/agz94wCWJ+ZVX/NkLOtBubJsph+KdhjawxYfJnJgnh+Vtk/nSnjqFW4jw/ymD5hxsQ3notzefydIGTxZ9ZL/1I3hlU2A5MyByeVkuaGGk1hAKPPsdpaAJXd7h/Xpm4/mOQyFZxtmMIEZiaKeABdqrC/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729548139; c=relaxed/simple;
	bh=puQ75ii0lltlveV/actzFuGRC1zAWDrLanJfuUqHLrI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=g0X6rsjpOgTqCjQpBSh+mFYJsMJ3GmheHI5A4cH4J7mdfZpz8CHpgLtN+OutMKi/ouMx3XS7d0rZseF2HYt2yHrLohlhZ27MIe6Af4WspjNbT7hWgBvcfuiGGny9reAJNuToLIXrwz3yFfN9916aaiWpwbr/tDHNMSmVIb95njE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ADDPxJPt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ADDPxJPt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DEA6C4CEC3;
	Mon, 21 Oct 2024 22:02:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729548139;
	bh=puQ75ii0lltlveV/actzFuGRC1zAWDrLanJfuUqHLrI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ADDPxJPtkwQpKyxk/3xSocaIo8Y02qd9CZFU9NbjQCeZjKKEdLfbIcMIULFphpPM5
	 +wPBO7xUk4thq6kTlhqaIjE7PtPnZFonmQBWsGuuEC14w8dBO2kfttUJuwbFJ4y2X8
	 b8eoDAA+ev7LeKFyCrrd4rX3GDh838lVf4hQ2vnpWSJ1NQ4kBdVapp7Imx0PHwhlYg
	 MO8f0jCVTEjjtgPiXN2s6WoMeXjz8svOmcpk8EnoL3O19OBPc8V5gfx1iCyLUvr+i0
	 XsQlnnA7sfRQJDTyrn4HnvlWBmhJyKUgogKbn0OtLQEOYHiEcZG1vIkELIkExRF7CK
	 KI7pI/FBv+UQA==
Date: Mon, 21 Oct 2024 15:02:18 -0700
Subject: [PATCH 13/37] xfs: push transaction join out of xfs_rtbitmap_lock and
 xfs_rtgroup_lock
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <172954783668.34558.7651064684450347098.stgit@frogsfrogsfrogs>
In-Reply-To: <172954783428.34558.6301509765231998083.stgit@frogsfrogsfrogs>
References: <172954783428.34558.6301509765231998083.stgit@frogsfrogsfrogs>
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

