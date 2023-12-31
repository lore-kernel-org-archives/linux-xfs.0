Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92BC6C2CC
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:48:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pZq/GInv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60645C433C8;
	Sun, 31 Dec 2023 23:48:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704066517;
	bh=pLZgo1Ag0nlDgcgEqDhQnBQOFZNgGPyeAfTSj/i0lSY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=pZq/GInvB4kABMWhJ3YxdbYUFe0npXz9p/YgLlV/CtsHBDkx/vrAdlITc/KthvgoC
	 8+4CweJ8zaEK2Xhpl5IbvbFNdLfV6+wGacqUxgFkCJLWrfRp/WaUZxg4lekj8kxBZ+
	 QX9w9E19C4Pbl4WUymBOchM0Y87mHn1pF4AjNngMRfrk2OnrwJuNIOqczEloaCZkfo
	 vKE4/Jvw+3OY5jvZkviZw1XuA6D4PEYKS5uoIOjmUoCkUAibSSwr+mJPEYeFR04l5x
	 goX8Pf9oEnpsY6gbfzurrALbvYK3UDnvBCoqER2zQ/pKI8AXYv91f1K2j2Gnp391h4
	 5eGMVNAoOVlKg==
Date: Sun, 31 Dec 2023 15:48:37 -0800
Subject: [PATCH 04/52] xfs: update primary realtime super every time we update
 the primary fs super
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405012223.1811243.5934863300543667393.stgit@frogsfrogsfrogs>
In-Reply-To: <170405012128.1811243.5724050972228209086.stgit@frogsfrogsfrogs>
References: <170405012128.1811243.5724050972228209086.stgit@frogsfrogsfrogs>
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

Every time we update parts of the primary filesystem superblock that are
echoed in the primary rt super, we should update that primary realtime
super.  Avoid an ondisk log format change by using ordered buffers to
write the primary rt super.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 include/xfs_trans.h      |    1 +
 libxfs/libxfs_api_defs.h |    1 +
 libxfs/libxfs_io.h       |    1 +
 libxfs/rdwr.c            |   17 +++++++++++
 libxfs/trans.c           |   29 ++++++++++++++++++
 libxfs/xfs_rtgroup.c     |   74 ++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_rtgroup.h     |    6 ++++
 libxfs/xfs_sb.c          |   13 ++++++++
 8 files changed, 142 insertions(+)


diff --git a/include/xfs_trans.h b/include/xfs_trans.h
index 183163e81a5..630bc85ce37 100644
--- a/include/xfs_trans.h
+++ b/include/xfs_trans.h
@@ -108,6 +108,7 @@ int	libxfs_trans_reserve_more(struct xfs_trans *tp, uint blocks,
 void xfs_defer_cancel(struct xfs_trans *);
 
 struct xfs_buf *libxfs_trans_getsb(struct xfs_trans *);
+struct xfs_buf *libxfs_trans_getrtsb(struct xfs_trans *tp);
 
 void	libxfs_trans_ijoin(struct xfs_trans *, struct xfs_inode *, uint);
 void	libxfs_trans_log_inode (struct xfs_trans *, struct xfs_inode *,
diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index ce255ec3a87..fff0e6d0f60 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -309,6 +309,7 @@
 #define xfs_trans_dirty_buf		libxfs_trans_dirty_buf
 #define xfs_trans_get_buf		libxfs_trans_get_buf
 #define xfs_trans_get_buf_map		libxfs_trans_get_buf_map
+#define xfs_trans_getrtsb		libxfs_trans_getrtsb
 #define xfs_trans_getsb			libxfs_trans_getsb
 #define xfs_trans_ichgtime		libxfs_trans_ichgtime
 #define xfs_trans_ijoin			libxfs_trans_ijoin
diff --git a/libxfs/libxfs_io.h b/libxfs/libxfs_io.h
index 8a99955ee73..f118cb5e836 100644
--- a/libxfs/libxfs_io.h
+++ b/libxfs/libxfs_io.h
@@ -189,6 +189,7 @@ libxfs_buf_read(
 
 int libxfs_readbuf_verify(struct xfs_buf *bp, const struct xfs_buf_ops *ops);
 struct xfs_buf *libxfs_getsb(struct xfs_mount *mp);
+struct xfs_buf *libxfs_getrtsb(struct xfs_mount *mp);
 extern void	libxfs_bcache_purge(struct xfs_mount *mp);
 extern void	libxfs_bcache_free(void);
 extern void	libxfs_bcache_flush(struct xfs_mount *mp);
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index ecf10f7946b..17abced06c9 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -164,6 +164,23 @@ libxfs_getsb(
 	return bp;
 }
 
+struct xfs_buf *
+libxfs_getrtsb(
+	struct xfs_mount	*mp)
+{
+	struct xfs_buf		*bp;
+	int			error;
+
+	if (!mp->m_rtdev_targp->bt_bdev)
+		return NULL;
+
+	error = libxfs_buf_read_uncached(mp->m_rtdev_targp, XFS_RTSB_DADDR,
+			XFS_FSB_TO_BB(mp, 1), 0, &bp, &xfs_rtsb_buf_ops);
+	if (error)
+		return NULL;
+	return bp;
+}
+
 struct kmem_cache			*xfs_buf_cache;
 
 static struct cache_mru		xfs_buf_freelist =
diff --git a/libxfs/trans.c b/libxfs/trans.c
index 8d969400984..aab9923d9ad 100644
--- a/libxfs/trans.c
+++ b/libxfs/trans.c
@@ -512,6 +512,35 @@ libxfs_trans_getsb(
 	return bp;
 }
 
+struct xfs_buf *
+libxfs_trans_getrtsb(
+	struct xfs_trans	*tp)
+{
+	struct xfs_mount	*mp = tp->t_mountp;
+	struct xfs_buf		*bp;
+	struct xfs_buf_log_item	*bip;
+	int			len = XFS_FSS_TO_BB(mp, 1);
+	DEFINE_SINGLE_BUF_MAP(map, XFS_SB_DADDR, len);
+
+	bp = xfs_trans_buf_item_match(tp, mp->m_rtdev, &map, 1);
+	if (bp != NULL) {
+		ASSERT(bp->b_transp == tp);
+		bip = bp->b_log_item;
+		ASSERT(bip != NULL);
+		bip->bli_recur++;
+		trace_xfs_trans_getsb_recur(bip);
+		return bp;
+	}
+
+	bp = libxfs_getrtsb(mp);
+	if (bp == NULL)
+		return NULL;
+
+	_libxfs_trans_bjoin(tp, bp, 1);
+	trace_xfs_trans_getsb(bp->b_log_item);
+	return bp;
+}
+
 int
 libxfs_trans_read_buf_map(
 	struct xfs_mount	*mp,
diff --git a/libxfs/xfs_rtgroup.c b/libxfs/xfs_rtgroup.c
index c72ef884909..26b2d3e03e7 100644
--- a/libxfs/xfs_rtgroup.c
+++ b/libxfs/xfs_rtgroup.c
@@ -342,3 +342,77 @@ const struct xfs_buf_ops xfs_rtsb_buf_ops = {
 	.verify_write = xfs_rtsb_write_verify,
 	.verify_struct = xfs_rtsb_verify,
 };
+
+/* Update a realtime superblock from the primary fs super */
+void
+xfs_rtgroup_update_super(
+	struct xfs_buf		*rtsb_bp,
+	const struct xfs_buf	*sb_bp)
+{
+	const struct xfs_dsb	*dsb = sb_bp->b_addr;
+	struct xfs_rtsb		*rsb = rtsb_bp->b_addr;
+	const uuid_t		*meta_uuid;
+
+	rsb->rsb_magicnum = cpu_to_be32(XFS_RTSB_MAGIC);
+	rsb->rsb_blocksize = dsb->sb_blocksize;
+	rsb->rsb_rblocks = dsb->sb_rblocks;
+
+	rsb->rsb_rextents = dsb->sb_rextents;
+	rsb->rsb_lsn = 0;
+
+	memcpy(&rsb->rsb_uuid, &dsb->sb_uuid, sizeof(rsb->rsb_uuid));
+
+	rsb->rsb_rgcount = dsb->sb_rgcount;
+	memcpy(&rsb->rsb_fname, &dsb->sb_fname, XFSLABEL_MAX);
+
+	rsb->rsb_rextsize = dsb->sb_rextsize;
+	rsb->rsb_rbmblocks = dsb->sb_rbmblocks;
+
+	rsb->rsb_rgblocks = dsb->sb_rgblocks;
+	rsb->rsb_blocklog = dsb->sb_blocklog;
+	rsb->rsb_sectlog = dsb->sb_sectlog;
+	rsb->rsb_rextslog = dsb->sb_rextslog;
+	rsb->rsb_pad = 0;
+	rsb->rsb_pad2 = 0;
+
+	/*
+	 * The metadata uuid is the fs uuid if the metauuid feature is not
+	 * enabled.
+	 */
+	if (dsb->sb_features_incompat &
+				cpu_to_be32(XFS_SB_FEAT_INCOMPAT_META_UUID))
+		meta_uuid = &dsb->sb_meta_uuid;
+	else
+		meta_uuid = &dsb->sb_uuid;
+	memcpy(&rsb->rsb_meta_uuid, meta_uuid, sizeof(rsb->rsb_meta_uuid));
+}
+
+/*
+ * Update the primary realtime superblock from a filesystem superblock and
+ * log it to the given transaction.
+ */
+void
+xfs_rtgroup_log_super(
+	struct xfs_trans	*tp,
+	const struct xfs_buf	*sb_bp)
+{
+	struct xfs_buf		*rtsb_bp;
+
+	if (!xfs_has_rtgroups(tp->t_mountp))
+		return;
+
+	rtsb_bp = xfs_trans_getrtsb(tp);
+	if (!rtsb_bp) {
+		/*
+		 * It's possible for the rtgroups feature to be enabled but
+		 * there is no incore rt superblock buffer if the rt geometry
+		 * was specified at mkfs time but the rt section has not yet
+		 * been attached.  In this case, rblocks must be zero.
+		 */
+		ASSERT(tp->t_mountp->m_sb.sb_rblocks == 0);
+		return;
+	}
+
+	xfs_rtgroup_update_super(rtsb_bp, sb_bp);
+	xfs_trans_ordered_buf(tp, rtsb_bp);
+}
diff --git a/libxfs/xfs_rtgroup.h b/libxfs/xfs_rtgroup.h
index 924c8c95acb..83bbd43f727 100644
--- a/libxfs/xfs_rtgroup.h
+++ b/libxfs/xfs_rtgroup.h
@@ -208,8 +208,14 @@ xfs_daddr_to_rgbno(
 #ifdef CONFIG_XFS_RT
 xfs_rgblock_t xfs_rtgroup_block_count(struct xfs_mount *mp,
 		xfs_rgnumber_t rgno);
+
+void xfs_rtgroup_update_super(struct xfs_buf *rtsb_bp,
+		const struct xfs_buf *sb_bp);
+void xfs_rtgroup_log_super(struct xfs_trans *tp, const struct xfs_buf *sb_bp);
 #else
 # define xfs_rtgroup_block_count(mp, rgno)	(0)
+# define xfs_rtgroup_update_super(bp, sb_bp)	((void)0)
+# define xfs_rtgroup_log_super(tp, sb_bp)	((void)0)
 #endif /* CONFIG_XFS_RT */
 
 #endif /* __LIBXFS_RTGROUP_H */
diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index b5e4367d4ca..2de270171a4 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -25,6 +25,7 @@
 #include "xfs_ag.h"
 #include "xfs_rtbitmap.h"
 #include "xfs_swapext.h"
+#include "xfs_rtgroup.h"
 
 /*
  * Physical superblock buffer manipulations. Shared with libxfs in userspace.
@@ -1159,6 +1160,8 @@ xfs_log_sb(
 	xfs_sb_to_disk(bp->b_addr, &mp->m_sb);
 	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_SB_BUF);
 	xfs_trans_log_buf(tp, bp, 0, sizeof(struct xfs_dsb) - 1);
+
+	xfs_rtgroup_log_super(tp, bp);
 }
 
 /*
@@ -1275,6 +1278,7 @@ xfs_sync_sb_buf(
 {
 	struct xfs_trans	*tp;
 	struct xfs_buf		*bp;
+	struct xfs_buf		*rtsb_bp = NULL;
 	int			error;
 
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_sb, 0, 0, 0, &tp);
@@ -1284,6 +1288,11 @@ xfs_sync_sb_buf(
 	bp = xfs_trans_getsb(tp);
 	xfs_log_sb(tp);
 	xfs_trans_bhold(tp, bp);
+	if (xfs_has_rtgroups(mp)) {
+		rtsb_bp = xfs_trans_getrtsb(tp);
+		if (rtsb_bp)
+			xfs_trans_bhold(tp, rtsb_bp);
+	}
 	xfs_trans_set_sync(tp);
 	error = xfs_trans_commit(tp);
 	if (error)
@@ -1292,7 +1301,11 @@ xfs_sync_sb_buf(
 	 * write out the sb buffer to get the changes to disk
 	 */
 	error = xfs_bwrite(bp);
+	if (!error && rtsb_bp)
+		error = xfs_bwrite(rtsb_bp);
 out:
+	if (rtsb_bp)
+		xfs_buf_relse(rtsb_bp);
 	xfs_buf_relse(bp);
 	return error;
 }

