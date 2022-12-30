Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5955C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:30:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236232AbiLaCaw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:30:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236141AbiLaCav (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:30:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57A19FD39
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:30:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E993261CD4
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:30:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AF31C433EF;
        Sat, 31 Dec 2022 02:30:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672453849;
        bh=qkiB7nk7CdeuODSrnI1szo/Ry33IQrlLPo1w52ppYD8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=t2hZ1E5RlwHHdR+DLEnqF1pyEylCHb+kAZ8fnr2F60BCi1Ep1cpGr+2tK/Mal3ETd
         Ni7z00qF0ysUHGxgQRur534QagN6SthgUV8vNefec7zVGESK1XZQB7ymnYtnXVNk9k
         EOVjZS+AOSeR/DSmXjkPMv/e+1WWQmkp5UvgAiERE4L+7y/Acy/J8T3NzeOPXNQMtt
         qt7uTLKmYlyBEDoOpBL+Htc0ZqhISaeVl7gPZNuHy1DNsWHoKHNh6BUI45HHwCt+UL
         z7LcmcE1yxoRrRz1ZQ9KOInYLcE5fsXCJ2bWhCp8SlR0jznDRx1IFJVQazRTWc2esy
         QLkU6WCZX4+og==
Subject: [PATCH 03/45] xfs: update primary realtime super every time we update
 the primary fs super
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:44 -0800
Message-ID: <167243878406.731133.6106890863183020755.stgit@magnolia>
In-Reply-To: <167243878346.731133.14642166452774753637.stgit@magnolia>
References: <167243878346.731133.14642166452774753637.stgit@magnolia>
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
index bfaee7e8fed..0ecf0a95560 100644
--- a/include/xfs_trans.h
+++ b/include/xfs_trans.h
@@ -98,6 +98,7 @@ int	libxfs_trans_reserve_more(struct xfs_trans *tp, uint blocks,
 void xfs_defer_cancel(struct xfs_trans *);
 
 struct xfs_buf *libxfs_trans_getsb(struct xfs_trans *);
+struct xfs_buf *libxfs_trans_getrtsb(struct xfs_trans *tp);
 
 void	libxfs_trans_ijoin(struct xfs_trans *, struct xfs_inode *, uint);
 void	libxfs_trans_log_inode (struct xfs_trans *, struct xfs_inode *,
diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 7ce9686c00d..4d9499529c0 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -263,6 +263,7 @@
 #define xfs_trans_dirty_buf		libxfs_trans_dirty_buf
 #define xfs_trans_get_buf		libxfs_trans_get_buf
 #define xfs_trans_get_buf_map		libxfs_trans_get_buf_map
+#define xfs_trans_getrtsb		libxfs_trans_getrtsb
 #define xfs_trans_getsb			libxfs_trans_getsb
 #define xfs_trans_ichgtime		libxfs_trans_ichgtime
 #define xfs_trans_ijoin			libxfs_trans_ijoin
diff --git a/libxfs/libxfs_io.h b/libxfs/libxfs_io.h
index fb536c1c3c9..d54258c7355 100644
--- a/libxfs/libxfs_io.h
+++ b/libxfs/libxfs_io.h
@@ -197,6 +197,7 @@ libxfs_buf_read(
 
 int libxfs_readbuf_verify(struct xfs_buf *bp, const struct xfs_buf_ops *ops);
 struct xfs_buf *libxfs_getsb(struct xfs_mount *mp);
+struct xfs_buf *libxfs_getrtsb(struct xfs_mount *mp);
 extern void	libxfs_bcache_purge(struct xfs_mount *mp);
 extern void	libxfs_bcache_free(void);
 extern void	libxfs_bcache_flush(struct xfs_mount *mp);
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 2c66b84ff83..1c91f557f41 100644
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
index 3120d8b1dea..06d3655c33b 100644
--- a/libxfs/trans.c
+++ b/libxfs/trans.c
@@ -511,6 +511,35 @@ libxfs_trans_getsb(
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
index ef1d1f29d64..a96df704070 100644
--- a/libxfs/xfs_rtgroup.c
+++ b/libxfs/xfs_rtgroup.c
@@ -305,3 +305,77 @@ const struct xfs_buf_ops xfs_rtsb_buf_ops = {
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
index ff9b01d8c50..c6db6b0d2ae 100644
--- a/libxfs/xfs_rtgroup.h
+++ b/libxfs/xfs_rtgroup.h
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
diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index aec147fe5f8..7b8baf64e82 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -24,6 +24,7 @@
 #include "xfs_health.h"
 #include "xfs_ag.h"
 #include "xfs_swapext.h"
+#include "xfs_rtgroup.h"
 
 /*
  * Physical superblock buffer manipulations. Shared with libxfs in userspace.
@@ -1098,6 +1099,8 @@ xfs_log_sb(
 	xfs_sb_to_disk(bp->b_addr, &mp->m_sb);
 	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_SB_BUF);
 	xfs_trans_log_buf(tp, bp, 0, sizeof(struct xfs_dsb) - 1);
+
+	xfs_rtgroup_log_super(tp, bp);
 }
 
 /*
@@ -1214,6 +1217,7 @@ xfs_sync_sb_buf(
 {
 	struct xfs_trans	*tp;
 	struct xfs_buf		*bp;
+	struct xfs_buf		*rtsb_bp = NULL;
 	int			error;
 
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_sb, 0, 0, 0, &tp);
@@ -1223,6 +1227,11 @@ xfs_sync_sb_buf(
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
@@ -1231,7 +1240,11 @@ xfs_sync_sb_buf(
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

