Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 554DCC2C0
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:32:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JHwBC3Jh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2765EC433C8;
	Sun, 31 Dec 2023 23:32:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704065579;
	bh=JqodD+mwE8JdGYNa40gKTt/FY++8KHq3IaRbdcamr44=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=JHwBC3Jh7M5df9ywlz9Vail8P1DfH7dWhYdjUaGOXV1H/1/lamd8aojKd4Gdws5s8
	 LXn7F++k6hVkuuSDEDIdZoyag8ozOxRgra8zSmdg9OxhCwQWaZO8HMbOZxki/cD7kx
	 1p4khnD8ZZcxQzjD8jfGfVBqkDIsTTlVNWgrsQNJCD48dHe5ZkSRlGe0yUZGKG+ezi
	 WiCP7WwKLoUw/nFADxFKhFwCGkKn4ln13MXh8N5H/aHcCSxrTFcKAiEW+mXmNapbPY
	 lpelolSgykyKkLD8A3Pt8k/K3eo2TA1L9we1GXxKgx2hjnxUztsIGb5Ih+87LjDH7K
	 s89YBpCJluVTQ==
Date: Sun, 31 Dec 2023 15:32:58 -0800
Subject: [PATCH 13/58] xfs: allow deletion of metadata directory files
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405010120.1809361.3163682949496483488.stgit@frogsfrogsfrogs>
In-Reply-To: <170405009903.1809361.17191356040741566208.stgit@frogsfrogsfrogs>
References: <170405009903.1809361.17191356040741566208.stgit@frogsfrogsfrogs>
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

Make it possible to free metadata files once we've unlinked them from
the directory structure.  We don't do this in the kernel, at least not
yet, but don't leave a logic bomb for later.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 include/xfs_inode.h      |    3 +
 libxfs/inode.c           |   93 ++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/libxfs_api_defs.h |    1 
 libxfs/xfs_imeta.c       |   49 ++++++++++++++++++++++++
 4 files changed, 145 insertions(+), 1 deletion(-)


diff --git a/include/xfs_inode.h b/include/xfs_inode.h
index 1fdae6c1d3a..4aacc488fa5 100644
--- a/include/xfs_inode.h
+++ b/include/xfs_inode.h
@@ -418,4 +418,7 @@ extern void	libxfs_irele(struct xfs_inode *ip);
 #define xfs_inherit_nosymlinks	(false)
 #define xfs_inherit_nodefrag	(false)
 
+int libxfs_ifree_cluster(struct xfs_trans *tp, struct xfs_perag *pag,
+		struct xfs_inode *free_ip, struct xfs_icluster *xic);
+
 #endif /* __XFS_INODE_H__ */
diff --git a/libxfs/inode.c b/libxfs/inode.c
index 5cb2fd7891a..87b5df84f2a 100644
--- a/libxfs/inode.c
+++ b/libxfs/inode.c
@@ -317,3 +317,96 @@ void inode_init_owner(struct mnt_idmap *idmap, struct inode *inode,
 		inode_fsgid_set(inode, idmap);
 	inode->i_mode = mode;
 }
+
+/*
+ * This call is used to indicate that the buffer is going to
+ * be staled and was an inode buffer. This means it gets
+ * special processing during unpin - where any inodes
+ * associated with the buffer should be removed from ail.
+ * There is also special processing during recovery,
+ * any replay of the inodes in the buffer needs to be
+ * prevented as the buffer may have been reused.
+ */
+static void
+xfs_trans_stale_inode_buf(
+	xfs_trans_t		*tp,
+	struct xfs_buf		*bp)
+{
+	ASSERT(bp->b_transp == tp);
+	ASSERT(bip != NULL);
+	ASSERT(atomic_read(&bip->bli_refcount) > 0);
+
+	bp->b_flags |= _XBF_INODES;
+	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_DINO_BUF);
+}
+
+/*
+ * A big issue when freeing the inode cluster is that we _cannot_ skip any
+ * inodes that are in memory - they all must be marked stale and attached to
+ * the cluster buffer.
+ */
+int
+libxfs_ifree_cluster(
+	struct xfs_trans	*tp,
+	struct xfs_perag	*pag,
+	struct xfs_inode	*free_ip,
+	struct xfs_icluster	*xic)
+{
+	struct xfs_mount	*mp = free_ip->i_mount;
+	struct xfs_ino_geometry	*igeo = M_IGEO(mp);
+	struct xfs_buf		*bp;
+	xfs_daddr_t		blkno;
+	xfs_ino_t		inum = xic->first_ino;
+	int			nbufs;
+	int			j;
+	int			ioffset;
+	int			error;
+
+	nbufs = igeo->ialloc_blks / igeo->blocks_per_cluster;
+
+	for (j = 0; j < nbufs; j++, inum += igeo->inodes_per_cluster) {
+		/*
+		 * The allocation bitmap tells us which inodes of the chunk were
+		 * physically allocated. Skip the cluster if an inode falls into
+		 * a sparse region.
+		 */
+		ioffset = inum - xic->first_ino;
+		if ((xic->alloc & XFS_INOBT_MASK(ioffset)) == 0) {
+			ASSERT(ioffset % igeo->inodes_per_cluster == 0);
+			continue;
+		}
+
+		blkno = XFS_AGB_TO_DADDR(mp, XFS_INO_TO_AGNO(mp, inum),
+					 XFS_INO_TO_AGBNO(mp, inum));
+
+		/*
+		 * We obtain and lock the backing buffer first in the process
+		 * here to ensure dirty inodes attached to the buffer remain in
+		 * the flushing state while we mark them stale.
+		 *
+		 * If we scan the in-memory inodes first, then buffer IO can
+		 * complete before we get a lock on it, and hence we may fail
+		 * to mark all the active inodes on the buffer stale.
+		 */
+		error = xfs_trans_get_buf(tp, mp->m_ddev_targp, blkno,
+				mp->m_bsize * igeo->blocks_per_cluster,
+				XBF_UNMAPPED, &bp);
+		if (error)
+			return error;
+
+		/*
+		 * This buffer may not have been correctly initialised as we
+		 * didn't read it from disk. That's not important because we are
+		 * only using to mark the buffer as stale in the log, and to
+		 * attach stale cached inodes on it. That means it will never be
+		 * dispatched for IO. If it is, we want to know about it, and we
+		 * want it to fail. We can acheive this by adding a write
+		 * verifier to the buffer.
+		 */
+		bp->b_ops = &xfs_inode_buf_ops;
+
+		xfs_trans_stale_inode_buf(tp, bp);
+		xfs_trans_binval(tp, bp);
+	}
+	return 0;
+}
diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 873995f265c..a0cdad40ff9 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -171,6 +171,7 @@
 #define xfs_iext_lookup_extent		libxfs_iext_lookup_extent
 #define xfs_iext_next			libxfs_iext_next
 #define xfs_ifork_zap_attr		libxfs_ifork_zap_attr
+#define xfs_ifree_cluster		libxfs_ifree_cluster
 #define xfs_imap_to_bp			libxfs_imap_to_bp
 
 #define xfs_imeta_cancel_update		libxfs_imeta_cancel_update
diff --git a/libxfs/xfs_imeta.c b/libxfs/xfs_imeta.c
index e59b0f414ed..672aba4d0e7 100644
--- a/libxfs/xfs_imeta.c
+++ b/libxfs/xfs_imeta.c
@@ -22,6 +22,7 @@
 #include "xfs_da_format.h"
 #include "xfs_da_btree.h"
 #include "xfs_trans_space.h"
+#include "xfs_ag.h"
 
 /*
  * Metadata File Management
@@ -359,6 +360,38 @@ xfs_imeta_create(
 	return error;
 }
 
+/* Free a file from the metadata directory tree. */
+STATIC int
+xfs_imeta_ifree(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_perag	*pag;
+	struct xfs_icluster	xic = { 0 };
+	int			error;
+
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
+	ASSERT(VFS_I(ip)->i_nlink == 0);
+	ASSERT(ip->i_df.if_nextents == 0);
+	ASSERT(ip->i_disk_size == 0 || !S_ISREG(VFS_I(ip)->i_mode));
+	ASSERT(ip->i_nblocks == 0);
+
+	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
+
+	error = xfs_dir_ifree(tp, pag, ip, &xic);
+	if (error)
+		goto out;
+
+	/* Metadata files do not support ownership changes or DMAPI. */
+
+	if (xic.deleted)
+		error = xfs_ifree_cluster(tp, pag, ip, &xic);
+out:
+	xfs_perag_put(pag);
+	return error;
+}
+
 /*
  * Unlink a metadata inode @upd->ip from the metadata directory given by @path.
  * The path must already exist.
@@ -367,10 +400,24 @@ int
 xfs_imeta_unlink(
 	struct xfs_imeta_update		*upd)
 {
+	int				error;
+
 	ASSERT(xfs_imeta_path_check(upd->path));
 	ASSERT(xfs_imeta_verify(upd->mp, upd->ip->i_ino));
 
-	return xfs_imeta_sb_unlink(upd);
+	error = xfs_imeta_sb_unlink(upd);
+	if (error)
+		return error;
+
+	/*
+	 * Metadata files require explicit resource cleanup.  In other words,
+	 * the inactivation system will not touch these files, so we must free
+	 * the ondisk inode by ourselves if warranted.
+	 */
+	if (VFS_I(upd->ip)->i_nlink > 0)
+		return 0;
+
+	return xfs_imeta_ifree(upd->tp, upd->ip);
 }
 
 /*

