Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18B45C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:28:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236091AbiLaB2g (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:28:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235752AbiLaB2e (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:28:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C0031DF18
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:28:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2FC93B81DE5
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:28:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB4EFC433EF;
        Sat, 31 Dec 2022 01:28:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672450110;
        bh=p72jB2EPhzVpfxP9g6KvsnDwVXJsHhlij6e85O5oPQ4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=KspKB4Xm3Uf48jP56fGvM/8ly0MH381BYiGgWbthjYew+f//33yDqXAk4H5sCiy64
         Yvl6h6bXsSi1Wt95loSG0bPe3Yye97UJG2WfSIRuUAKq/ozVd5UjOGRnyrTP1sNQ+/
         KwJEu+thwHXk2+wCZECzholci5xSIfnzBU9Cyw0xp4Giu4z7OeJO1Kf6bu0iRB9XhF
         DxPMP05GKRVm0WWQTS1NXaQPRxyckVWHT6vALbhRBWG4DOB1IdDvk+8RdeuvpMdJNO
         9PNTwF6IefUEHfXs8J55acZbmfwTNf/LnFqCmKLY2p181cMKVVwmo4monBfxUpxB0y
         oA1vJlKSwdVQw==
Subject: [PATCH 04/22] xfs: update primary realtime super every time we update
 the primary fs super
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:53 -0800
Message-ID: <167243867327.712847.16568431395173815876.stgit@magnolia>
In-Reply-To: <167243867242.712847.10106105868862621775.stgit@magnolia>
References: <167243867242.712847.10106105868862621775.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

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
index edbc427725c3..e9655e699f4f 100644
--- a/fs/xfs/libxfs/xfs_rtgroup.c
+++ b/fs/xfs/libxfs/xfs_rtgroup.c
@@ -308,3 +308,77 @@ const struct xfs_buf_ops xfs_rtsb_buf_ops = {
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
index ff9b01d8c501..c6db6b0d2ae5 100644
--- a/fs/xfs/libxfs/xfs_rtgroup.h
+++ b/fs/xfs/libxfs/xfs_rtgroup.h
@@ -197,8 +197,14 @@ xfs_daddr_to_rgbno(
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
index bbadf78b4628..2e8ec9214c6c 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -26,6 +26,7 @@
 #include "xfs_health.h"
 #include "xfs_ag.h"
 #include "xfs_swapext.h"
+#include "xfs_rtgroup.h"
 
 /*
  * Physical superblock buffer manipulations. Shared with libxfs in userspace.
@@ -1100,6 +1101,8 @@ xfs_log_sb(
 	xfs_sb_to_disk(bp->b_addr, &mp->m_sb);
 	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_SB_BUF);
 	xfs_trans_log_buf(tp, bp, 0, sizeof(struct xfs_dsb) - 1);
+
+	xfs_rtgroup_log_super(tp, bp);
 }
 
 /*
@@ -1216,6 +1219,7 @@ xfs_sync_sb_buf(
 {
 	struct xfs_trans	*tp;
 	struct xfs_buf		*bp;
+	struct xfs_buf		*rtsb_bp = NULL;
 	int			error;
 
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_sb, 0, 0, 0, &tp);
@@ -1225,6 +1229,11 @@ xfs_sync_sb_buf(
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
@@ -1233,7 +1242,11 @@ xfs_sync_sb_buf(
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
index ffa94102094d..6587d18b21c3 100644
--- a/fs/xfs/xfs_buf_item_recover.c
+++ b/fs/xfs/xfs_buf_item_recover.c
@@ -22,6 +22,7 @@
 #include "xfs_inode.h"
 #include "xfs_dir2.h"
 #include "xfs_quota.h"
+#include "xfs_rtgroup.h"
 
 /*
  * This is the number of entries in the l_buf_cancel_table used during
@@ -985,6 +986,23 @@ xlog_recover_buf_commit_pass2(
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
index f39c5daeef86..979aba1b2fc8 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -25,6 +25,7 @@
 #include "xfs_dquot.h"
 #include "xfs_icache.h"
 #include "xfs_rtbitmap.h"
+#include "xfs_rtgroup.h"
 
 struct kmem_cache	*xfs_trans_cache;
 
@@ -531,6 +532,7 @@ xfs_trans_apply_sb_deltas(
 {
 	struct xfs_dsb	*sbp;
 	struct xfs_buf	*bp;
+	bool		update_rtsb = false;
 	int		whole = 0;
 
 	bp = xfs_trans_getsb(tp);
@@ -591,22 +593,27 @@ xfs_trans_apply_sb_deltas(
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
@@ -623,6 +630,9 @@ xfs_trans_apply_sb_deltas(
 		xfs_trans_log_buf(tp, bp, offsetof(struct xfs_dsb, sb_icount),
 				  offsetof(struct xfs_dsb, sb_frextents) +
 				  sizeof(sbp->sb_frextents) - 1);
+
+	if (update_rtsb)
+		xfs_rtgroup_log_super(tp, bp);
 }
 
 /*
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 0a9ec6929bbc..37cde68f3a31 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -216,6 +216,7 @@ xfs_trans_read_buf(
 }
 
 struct xfs_buf	*xfs_trans_getsb(struct xfs_trans *);
+struct xfs_buf	*xfs_trans_getrtsb(struct xfs_trans *tp);
 
 void		xfs_trans_brelse(xfs_trans_t *, struct xfs_buf *);
 void		xfs_trans_bjoin(xfs_trans_t *, struct xfs_buf *);
diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
index e28ab74af4f0..8e886ecfd69a 100644
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

