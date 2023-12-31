Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A429CBA22
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:16:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lsmgR3vR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FEC8C433C8;
	Sun, 31 Dec 2023 21:16:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704057415;
	bh=CyQ6xe168nReaTvfg3AY7d6MF7LiDCc7WIk2m7/lYHY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=lsmgR3vR6QQnT32MHXlcb4yop+oynD2y7RcWXCwPSe6iJ7vkmKGaXSy3T333ApsrI
	 JafyMUsoep0k8yBgXIKiIe8sDAStbISOW9VPVuFllzjIq323gCvygPvQnpotyAU7uS
	 PB8hFm3sl+dAt1YvX3i0V0cJivMm7TTarnkcXn8wQgUAa6wt1EoCKPUp6qIyxRiXJQ
	 YlQOEO7VUyVtiC98tas8gjRCmbtSJH972ChBCfLmAhIQjoAbtG1WvvxVk7b02fj/7s
	 SaS5a2N2LAMcRBbB+rNN+taU1lbydhdkm1wASlCr/9Oz6OqN3CO4Cq7v1Bn1AVQ+oY
	 WrrIzRO+Q3c2g==
Date: Sun, 31 Dec 2023 13:16:55 -0800
Subject: [PATCH 05/24] xfs: update primary realtime super every time we update
 the primary fs super
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404846322.1763124.15754856029181407257.stgit@frogsfrogsfrogs>
In-Reply-To: <170404846187.1763124.7316400597964398308.stgit@frogsfrogsfrogs>
References: <170404846187.1763124.7316400597964398308.stgit@frogsfrogsfrogs>
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
 fs/xfs/libxfs/xfs_rtgroup.c   |   74 +++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_rtgroup.h   |    6 +++
 fs/xfs/libxfs/xfs_sb.c        |   13 +++++++
 fs/xfs/xfs_buf_item_recover.c |   18 ++++++++++
 fs/xfs/xfs_trans.c            |   10 ++++++
 fs/xfs/xfs_trans.h            |    1 +
 fs/xfs/xfs_trans_buf.c        |   25 +++++++++++---
 7 files changed, 142 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_rtgroup.c b/fs/xfs/libxfs/xfs_rtgroup.c
index a82dd23cf0c79..325e4eb8f8781 100644
--- a/fs/xfs/libxfs/xfs_rtgroup.c
+++ b/fs/xfs/libxfs/xfs_rtgroup.c
@@ -345,3 +345,77 @@ const struct xfs_buf_ops xfs_rtsb_buf_ops = {
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
diff --git a/fs/xfs/libxfs/xfs_rtgroup.h b/fs/xfs/libxfs/xfs_rtgroup.h
index 924c8c95acbc3..83bbd43f7271a 100644
--- a/fs/xfs/libxfs/xfs_rtgroup.h
+++ b/fs/xfs/libxfs/xfs_rtgroup.h
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
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 6a6877c365ae9..b37924cf67a93 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -27,6 +27,7 @@
 #include "xfs_ag.h"
 #include "xfs_rtbitmap.h"
 #include "xfs_swapext.h"
+#include "xfs_rtgroup.h"
 
 /*
  * Physical superblock buffer manipulations. Shared with libxfs in userspace.
@@ -1161,6 +1162,8 @@ xfs_log_sb(
 	xfs_sb_to_disk(bp->b_addr, &mp->m_sb);
 	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_SB_BUF);
 	xfs_trans_log_buf(tp, bp, 0, sizeof(struct xfs_dsb) - 1);
+
+	xfs_rtgroup_log_super(tp, bp);
 }
 
 /*
@@ -1277,6 +1280,7 @@ xfs_sync_sb_buf(
 {
 	struct xfs_trans	*tp;
 	struct xfs_buf		*bp;
+	struct xfs_buf		*rtsb_bp = NULL;
 	int			error;
 
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_sb, 0, 0, 0, &tp);
@@ -1286,6 +1290,11 @@ xfs_sync_sb_buf(
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
@@ -1294,7 +1303,11 @@ xfs_sync_sb_buf(
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
diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
index 43167f543afc3..4be9a384dc6f7 100644
--- a/fs/xfs/xfs_buf_item_recover.c
+++ b/fs/xfs/xfs_buf_item_recover.c
@@ -22,6 +22,7 @@
 #include "xfs_inode.h"
 #include "xfs_dir2.h"
 #include "xfs_quota.h"
+#include "xfs_rtgroup.h"
 
 /*
  * This is the number of entries in the l_buf_cancel_table used during
@@ -995,6 +996,23 @@ xlog_recover_buf_commit_pass2(
 		ASSERT(bp->b_mount == mp);
 		bp->b_flags |= _XBF_LOGRECOVERY;
 		xfs_buf_delwri_queue(bp, buffer_list);
+
+		/*
+		 * Update the primary rt super if we just recovered the primary
+		 * fs super.
+		 */
+		if (xfs_has_rtgroups(mp) && bp->b_ops == &xfs_sb_buf_ops) {
+			struct xfs_buf	*rtsb_bp = mp->m_rtsb_bp;
+
+			if (rtsb_bp) {
+				xfs_buf_lock(rtsb_bp);
+				xfs_buf_hold(rtsb_bp);
+				xfs_rtgroup_update_super(rtsb_bp, bp);
+				rtsb_bp->b_flags |= _XBF_LOGRECOVERY;
+				xfs_buf_delwri_queue(rtsb_bp, buffer_list);
+				xfs_buf_relse(rtsb_bp);
+			}
+		}
 	}
 
 out_release:
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 81337fdb89ab8..fab625f64189f 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -25,6 +25,7 @@
 #include "xfs_dquot.h"
 #include "xfs_icache.h"
 #include "xfs_rtbitmap.h"
+#include "xfs_rtgroup.h"
 
 struct kmem_cache	*xfs_trans_cache;
 
@@ -477,6 +478,7 @@ xfs_trans_apply_sb_deltas(
 {
 	struct xfs_dsb	*sbp;
 	struct xfs_buf	*bp;
+	bool		update_rtsb = false;
 	int		whole = 0;
 
 	bp = xfs_trans_getsb(tp);
@@ -537,22 +539,27 @@ xfs_trans_apply_sb_deltas(
 	if (tp->t_rextsize_delta) {
 		be32_add_cpu(&sbp->sb_rextsize, tp->t_rextsize_delta);
 		whole = 1;
+		update_rtsb = true;
 	}
 	if (tp->t_rbmblocks_delta) {
 		be32_add_cpu(&sbp->sb_rbmblocks, tp->t_rbmblocks_delta);
 		whole = 1;
+		update_rtsb = true;
 	}
 	if (tp->t_rblocks_delta) {
 		be64_add_cpu(&sbp->sb_rblocks, tp->t_rblocks_delta);
 		whole = 1;
+		update_rtsb = true;
 	}
 	if (tp->t_rextents_delta) {
 		be64_add_cpu(&sbp->sb_rextents, tp->t_rextents_delta);
 		whole = 1;
+		update_rtsb = true;
 	}
 	if (tp->t_rextslog_delta) {
 		sbp->sb_rextslog += tp->t_rextslog_delta;
 		whole = 1;
+		update_rtsb = true;
 	}
 
 	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_SB_BUF);
@@ -569,6 +576,9 @@ xfs_trans_apply_sb_deltas(
 		xfs_trans_log_buf(tp, bp, offsetof(struct xfs_dsb, sb_icount),
 				  offsetof(struct xfs_dsb, sb_frextents) +
 				  sizeof(sbp->sb_frextents) - 1);
+
+	if (update_rtsb)
+		xfs_rtgroup_log_super(tp, bp);
 }
 
 /*
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 3cffc3cb41814..f3ddb05f3bcc6 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -212,6 +212,7 @@ xfs_trans_read_buf(
 }
 
 struct xfs_buf	*xfs_trans_getsb(struct xfs_trans *);
+struct xfs_buf	*xfs_trans_getrtsb(struct xfs_trans *tp);
 
 void		xfs_trans_brelse(xfs_trans_t *, struct xfs_buf *);
 void		xfs_trans_bjoin(xfs_trans_t *, struct xfs_buf *);
diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
index e28ab74af4f0e..8e886ecfd69a3 100644
--- a/fs/xfs/xfs_trans_buf.c
+++ b/fs/xfs/xfs_trans_buf.c
@@ -168,12 +168,11 @@ xfs_trans_get_buf_map(
 /*
  * Get and lock the superblock buffer for the given transaction.
  */
-struct xfs_buf *
-xfs_trans_getsb(
-	struct xfs_trans	*tp)
+static struct xfs_buf *
+__xfs_trans_getsb(
+	struct xfs_trans	*tp,
+	struct xfs_buf		*bp)
 {
-	struct xfs_buf		*bp = tp->t_mountp->m_sb_bp;
-
 	/*
 	 * Just increment the lock recursion count if the buffer is already
 	 * attached to this transaction.
@@ -197,6 +196,22 @@ xfs_trans_getsb(
 	return bp;
 }
 
+struct xfs_buf *
+xfs_trans_getsb(
+	struct xfs_trans	*tp)
+{
+	return __xfs_trans_getsb(tp, tp->t_mountp->m_sb_bp);
+}
+
+struct xfs_buf *
+xfs_trans_getrtsb(
+	struct xfs_trans	*tp)
+{
+	if (!tp->t_mountp->m_rtsb_bp)
+		return NULL;
+	return __xfs_trans_getsb(tp, tp->t_mountp->m_rtsb_bp);
+}
+
 /*
  * Get and lock the buffer for the caller if it is not already
  * locked within the given transaction.  If it has not yet been

