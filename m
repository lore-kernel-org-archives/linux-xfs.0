Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60FCDA2A
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 00:12:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724371924; cv=none; b=l/3yQ1yTFzcDrgFDVOjO6oYg7nzLZP5wfROd8vusEBg7fhdYgO+KX+bFKdmpJNA/SoTzbEn1vJV4djkl/uustq5NdTSbsXvV/GxHSxIFWJfAZGGph862WmQqvzIZ5w0rIJ6PnuefQ8qjjF9hZGChSo/dcoxCLMXqFDo8pjJNI94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724371924; c=relaxed/simple;
	bh=KGcXK24m9dZJNB+A3EDjCJnZgzf9FGB3JLjy5XYcrLI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=U3iKJ/JFCa/wJ3BOnjkxyKINRXzzS1aiO1pjosoC5o8zIdCI2fOr3CySh886J+YvvHMNDeYih5ahYuRpJpeETsaOrixHQyU/ujvMQ37cRWFK5JrG/8wHZzgbzOudsb7dolHiAn60mvv2O1dGImyoYRI62HM9W5P9gAbcyWbxSX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gSdAjA2S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gSdAjA2S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D173DC32782;
	Fri, 23 Aug 2024 00:12:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724371923;
	bh=KGcXK24m9dZJNB+A3EDjCJnZgzf9FGB3JLjy5XYcrLI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=gSdAjA2SFn0dK5OGrTxAGkFsjLHWL/310ITK8poAOCpuTXdgZA1Lm0Ai1mHS56OMx
	 rbY+cHwo7LTgagnjAF4k3WPCJkOO1a5WywKEd56qgxZYRC6wdqThO49n00tHI4FqWG
	 q45E+3sQlEhdUFKBSTfNLrtgaIDVqDhWoJmiGR+2vYzyhQfeUzvmBDNWeTieb/rT2P
	 3F52s7V/XUL42oMPtfAvmrUYfnaKCIN9nJWCP9oJ9WThkd86dMJEOpTd+fUtEK61kY
	 tUV/ZCz44Rz5NEr6MZzxs/SJb8gH+xpz+NV0DiwJgPXooVAEuaaKwum4GKWywAC+dI
	 CYtk0czzSrNvg==
Date: Thu, 22 Aug 2024 17:12:03 -0700
Subject: [PATCH 12/12] xfs: push transaction join out of xfs_rtbitmap_lock and
 xfs_rtgroup_lock
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172437086225.58604.13666040100912659325.stgit@frogsfrogsfrogs>
In-Reply-To: <172437085987.58604.7735951538617329546.stgit@frogsfrogsfrogs>
References: <172437085987.58604.7735951538617329546.stgit@frogsfrogsfrogs>
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

To prepare for being able to join an already locked rtbitmap inode to a
transaction split out separate helpers for joining the transaction from
the locking helpers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c     |    3 ++-
 fs/xfs/libxfs/xfs_rtbitmap.c |   24 +++++++++++++-----------
 fs/xfs/libxfs/xfs_rtbitmap.h |    6 ++++--
 fs/xfs/xfs_rtalloc.c         |    6 ++++--
 4 files changed, 23 insertions(+), 16 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index b79803784b766..314fc7d55659a 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -5379,7 +5379,8 @@ xfs_bmap_del_extent_real(
 			 */
 			if (!(tp->t_flags & XFS_TRANS_RTBITMAP_LOCKED)) {
 				tp->t_flags |= XFS_TRANS_RTBITMAP_LOCKED;
-				xfs_rtbitmap_lock(tp, mp);
+				xfs_rtbitmap_lock(mp);
+				xfs_rtbitmap_trans_join(tp);
 			}
 			error = xfs_rtfree_blocks(tp, del->br_startblock,
 					del->br_blockcount);
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index 715d2c54ce029..d7c731aeee12d 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -1201,23 +1201,25 @@ xfs_rtsummary_wordcount(
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
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.h b/fs/xfs/libxfs/xfs_rtbitmap.h
index 0d5ab5e2cb6a3..523d3d3c12c60 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.h
+++ b/fs/xfs/libxfs/xfs_rtbitmap.h
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
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 52ed8448d9925..e809a8649c60c 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -741,7 +741,8 @@ xfs_growfs_rt_bmblock(
 		goto out_free;
 	nargs.tp = args.tp;
 
-	xfs_rtbitmap_lock(args.tp, mp);
+	xfs_rtbitmap_lock(mp);
+	xfs_rtbitmap_trans_join(args.tp);
 
 	/*
 	 * Update the bitmap inode's size ondisk and incore.  We need to update
@@ -1319,7 +1320,8 @@ xfs_bmap_rtalloc(
 	 * Lock out modifications to both the RT bitmap and summary inodes
 	 */
 	if (!rtlocked) {
-		xfs_rtbitmap_lock(ap->tp, mp);
+		xfs_rtbitmap_lock(mp);
+		xfs_rtbitmap_trans_join(ap->tp);
 		rtlocked = true;
 	}
 

