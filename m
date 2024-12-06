Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC8E3148827
	for <linux-xfs@vger.kernel.org>; Fri,  6 Dec 2024 23:54:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733529285; cv=none; b=oi95xM/870c8DEabDsOBKZ7qPOY9TRbee7h0p786v0DJSgpQCSeDU1l2/AjwQxzYDDkVoPGBhOadHKNgtc+0HCidafYdR0iS6Z5hCIQgoZ+GfEQnWv2BAq3pRRG8CTdqDHApXbMh0ToGn1UjLHhdTwVf8sfbdY8i7sKTAPUw9/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733529285; c=relaxed/simple;
	bh=pcB/9UTmQjkWNV9pyqkckr8ZaJ3VBHUKnBqYx67/76A=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kAVdXDT8pjYhByZwB7XCqP2Wff0snqGqZDAORhXWBQrvh3soTSaY+SGwJO1ZFK85Xn9qiCL/zcHGW6Fs9aXaBGrvTEAGIY1KrfAV6r1CMAB8FGieFdMDRSl/hKonq7wXPDJzvONYU3QVApOWMBeUMor/NpF/g6BscPNtuNwLy40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U/ygavtr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U/ygavtr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF432C4CED1;
	Fri,  6 Dec 2024 23:54:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733529285;
	bh=pcB/9UTmQjkWNV9pyqkckr8ZaJ3VBHUKnBqYx67/76A=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=U/ygavtrNKOLsFsZwmJqKzBK2XAvOq5eU2NHFkY5b7AtD0tFu0wOMEfcmlrAkhWtU
	 IYsndj1bM4SmhUK8fIHSHY+W8DV8hqa+0jhejAXW/LracQU92GQAfPX8klRJbWGrUn
	 Cbv4bxlSUIGox2Rwh0qer4tFbGIKVFQogfSftrHZ5jLpZrm1BSLZcDceOnq+5o6/hO
	 oUsv5mMjT8BYNY3t+uvNwGp/Te/gKLKc0fKoELWuIv1XcySZawH57X3SDeYp877J1E
	 KMRSzrzwyKwQ8idSH0Sr5ETOd6OWyf/KqsmQkir+NiCLvDcRJQE5QkBwQrxryV7cEx
	 B93Rm0AKJEhGA==
Date: Fri, 06 Dec 2024 15:54:45 -0800
Subject: [PATCH 13/46] xfs: update realtime super every time we update the
 primary fs super
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352750193.124560.18441630494682776110.stgit@frogsfrogsfrogs>
In-Reply-To: <173352749923.124560.17452697523660805471.stgit@frogsfrogsfrogs>
References: <173352749923.124560.17452697523660805471.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: 76d3be00df91a56f7c05142ed500f8f8544d5457

Every time we update parts of the primary filesystem superblock that are
echoed in the rt superblock, we must update the rt super.  Avoid
changing the log to support logging to the rt device by using ordered
buffers.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 include/xfs_trans.h      |    1 +
 libxfs/libxfs_api_defs.h |    1 +
 libxfs/libxfs_io.h       |    1 +
 libxfs/rdwr.c            |   17 +++++++++++++
 libxfs/trans.c           |   29 ++++++++++++++++++++++
 libxfs/xfs_rtgroup.c     |   60 ++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_rtgroup.h     |    7 +++++
 libxfs/xfs_sb.c          |   14 ++++++++++-
 libxfs/xfs_sb.h          |    2 +-
 9 files changed, 130 insertions(+), 2 deletions(-)


diff --git a/include/xfs_trans.h b/include/xfs_trans.h
index d508f8947a301c..248064019a0ab5 100644
--- a/include/xfs_trans.h
+++ b/include/xfs_trans.h
@@ -108,6 +108,7 @@ int	libxfs_trans_reserve_more(struct xfs_trans *tp, uint blocks,
 void xfs_defer_cancel(struct xfs_trans *);
 
 struct xfs_buf *libxfs_trans_getsb(struct xfs_trans *);
+struct xfs_buf *libxfs_trans_getrtsb(struct xfs_trans *tp);
 
 void	libxfs_trans_ijoin(struct xfs_trans *, struct xfs_inode *, uint);
 void	libxfs_trans_log_inode (struct xfs_trans *, struct xfs_inode *,
diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index c869a4b0a46551..50da547f8f21d4 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -324,6 +324,7 @@
 #define xfs_trans_dirty_buf		libxfs_trans_dirty_buf
 #define xfs_trans_get_buf		libxfs_trans_get_buf
 #define xfs_trans_get_buf_map		libxfs_trans_get_buf_map
+#define xfs_trans_getrtsb		libxfs_trans_getrtsb
 #define xfs_trans_getsb			libxfs_trans_getsb
 #define xfs_trans_ichgtime		libxfs_trans_ichgtime
 #define xfs_trans_ijoin			libxfs_trans_ijoin
diff --git a/libxfs/libxfs_io.h b/libxfs/libxfs_io.h
index 82d86f1d1b37bf..99372eb6d3d13c 100644
--- a/libxfs/libxfs_io.h
+++ b/libxfs/libxfs_io.h
@@ -208,6 +208,7 @@ libxfs_buf_read(
 
 int libxfs_readbuf_verify(struct xfs_buf *bp, const struct xfs_buf_ops *ops);
 struct xfs_buf *libxfs_getsb(struct xfs_mount *mp);
+struct xfs_buf *libxfs_getrtsb(struct xfs_mount *mp);
 extern void	libxfs_bcache_purge(struct xfs_mount *mp);
 extern void	libxfs_bcache_free(void);
 extern void	libxfs_bcache_flush(struct xfs_mount *mp);
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 7d4d93e4f094e6..35be785c435a97 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -165,6 +165,23 @@ libxfs_getsb(
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
index 72f26591053716..01834eff4b77ca 100644
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
index e294a295b3d0d8..6eabc66099dc50 100644
--- a/libxfs/xfs_rtgroup.c
+++ b/libxfs/xfs_rtgroup.c
@@ -561,3 +561,63 @@ const struct xfs_buf_ops xfs_rtsb_buf_ops = {
 	.verify_write	= xfs_rtsb_write_verify,
 	.verify_struct	= xfs_rtsb_verify_all,
 };
+
+/* Update a realtime superblock from the primary fs super */
+void
+xfs_update_rtsb(
+	struct xfs_buf		*rtsb_bp,
+	const struct xfs_buf	*sb_bp)
+{
+	const struct xfs_dsb	*dsb = sb_bp->b_addr;
+	struct xfs_rtsb		*rsb = rtsb_bp->b_addr;
+	const uuid_t		*meta_uuid;
+
+	rsb->rsb_magicnum = cpu_to_be32(XFS_RTSB_MAGIC);
+
+	rsb->rsb_pad = 0;
+	memcpy(&rsb->rsb_fname, &dsb->sb_fname, XFSLABEL_MAX);
+
+	memcpy(&rsb->rsb_uuid, &dsb->sb_uuid, sizeof(rsb->rsb_uuid));
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
+ * Update the realtime superblock from a filesystem superblock and log it to
+ * the given transaction.
+ */
+struct xfs_buf *
+xfs_log_rtsb(
+	struct xfs_trans	*tp,
+	const struct xfs_buf	*sb_bp)
+{
+	struct xfs_buf		*rtsb_bp;
+
+	if (!xfs_has_rtsb(tp->t_mountp))
+		return NULL;
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
+		return NULL;
+	}
+
+	xfs_update_rtsb(rtsb_bp, sb_bp);
+	xfs_trans_ordered_buf(tp, rtsb_bp);
+	return rtsb_bp;
+}
diff --git a/libxfs/xfs_rtgroup.h b/libxfs/xfs_rtgroup.h
index 6ccf31bb6bc7a7..e7679fafff8ce7 100644
--- a/libxfs/xfs_rtgroup.h
+++ b/libxfs/xfs_rtgroup.h
@@ -251,6 +251,11 @@ static inline const char *xfs_rtginode_path(xfs_rgnumber_t rgno,
 {
 	return kasprintf(GFP_KERNEL, "%u.%s", rgno, xfs_rtginode_name(type));
 }
+
+void xfs_update_rtsb(struct xfs_buf *rtsb_bp,
+		const struct xfs_buf *sb_bp);
+struct xfs_buf *xfs_log_rtsb(struct xfs_trans *tp,
+		const struct xfs_buf *sb_bp);
 #else
 static inline void xfs_free_rtgroups(struct xfs_mount *mp,
 		xfs_rgnumber_t first_rgno, xfs_rgnumber_t end_rgno)
@@ -269,6 +274,8 @@ static inline int xfs_initialize_rtgroups(struct xfs_mount *mp,
 # define xfs_rtgroup_lock(rtg, gf)		((void)0)
 # define xfs_rtgroup_unlock(rtg, gf)		((void)0)
 # define xfs_rtgroup_trans_join(tp, rtg, gf)	((void)0)
+# define xfs_update_rtsb(bp, sb_bp)	((void)0)
+# define xfs_log_rtsb(tp, sb_bp)	(NULL)
 #endif /* CONFIG_XFS_RT */
 
 #endif /* __LIBXFS_RTGROUP_H */
diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index 3c80413b67f6ec..96b0a73682f435 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -24,6 +24,7 @@
 #include "xfs_health.h"
 #include "xfs_ag.h"
 #include "xfs_rtbitmap.h"
+#include "xfs_rtgroup.h"
 
 /*
  * Physical superblock buffer manipulations. Shared with libxfs in userspace.
@@ -1287,10 +1288,12 @@ xfs_update_secondary_sbs(
  */
 int
 xfs_sync_sb_buf(
-	struct xfs_mount	*mp)
+	struct xfs_mount	*mp,
+	bool			update_rtsb)
 {
 	struct xfs_trans	*tp;
 	struct xfs_buf		*bp;
+	struct xfs_buf		*rtsb_bp = NULL;
 	int			error;
 
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_sb, 0, 0, 0, &tp);
@@ -1300,6 +1303,11 @@ xfs_sync_sb_buf(
 	bp = xfs_trans_getsb(tp);
 	xfs_log_sb(tp);
 	xfs_trans_bhold(tp, bp);
+	if (update_rtsb) {
+		rtsb_bp = xfs_log_rtsb(tp, bp);
+		if (rtsb_bp)
+			xfs_trans_bhold(tp, rtsb_bp);
+	}
 	xfs_trans_set_sync(tp);
 	error = xfs_trans_commit(tp);
 	if (error)
@@ -1308,7 +1316,11 @@ xfs_sync_sb_buf(
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
diff --git a/libxfs/xfs_sb.h b/libxfs/xfs_sb.h
index 885c837559914d..999dcfccdaf960 100644
--- a/libxfs/xfs_sb.h
+++ b/libxfs/xfs_sb.h
@@ -15,7 +15,7 @@ struct xfs_perag;
 
 extern void	xfs_log_sb(struct xfs_trans *tp);
 extern int	xfs_sync_sb(struct xfs_mount *mp, bool wait);
-extern int	xfs_sync_sb_buf(struct xfs_mount *mp);
+extern int	xfs_sync_sb_buf(struct xfs_mount *mp, bool update_rtsb);
 extern void	xfs_sb_mount_common(struct xfs_mount *mp, struct xfs_sb *sbp);
 void		xfs_mount_sb_set_rextsize(struct xfs_mount *mp,
 			struct xfs_sb *sbp);

