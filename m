Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3411C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:42:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235900AbiLaBmi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:42:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236017AbiLaBmh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:42:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A249F026
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:42:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EB3EB61C3A
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:42:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 572A3C433EF;
        Sat, 31 Dec 2022 01:42:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672450955;
        bh=xAuTIVosJ1K+CNexj+btz6+sNpBwD4lR1S39fHNvpvw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=YD6Ul9qZSm1Zc1eQFyidglIlNow5p5EwKHWdUwBkz02vtaL9+Gf6Pu/aw8X6sNjsm
         yZWUIczSMKuzl/e8WGCUH3jIf3W2g/0FLIl3w4aEnqFWga6XezBySzD9F0P2Wfu42t
         gw1RogJ9Ld9dqYoUtVY4WGC4Fdfv7N5y5jpt/brI0KGon6lXokQrQ/z1ned0NtGmIk
         41TkNZhQ4djvOy4YVzkfZdZaZZPVxXdwyg8v+JI1lGjCYZKT/E0E/a8pld9iBDTQzb
         jN41DiPKbxeq8rUl66or9QhJF+SfQ9Fbc4jBxW1y292RwfHljTL+D+y7XnF0g3mdMT
         PwE7p6SU06HwQ==
Subject: [PATCH 22/38] xfs: check that the rtrmapbt maxlevels doesn't increase
 when growing fs
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:19 -0800
Message-ID: <167243869913.715303.244818263733598492.stgit@magnolia>
In-Reply-To: <167243869558.715303.13347105677486333748.stgit@magnolia>
References: <167243869558.715303.13347105677486333748.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

The size of filesystem transaction reservations depends on the maximum
height (maxlevels) of the realtime btrees.  Since we don't want a grow
operation to increase the reservation size enough that we'll fail the
minimum log size checks on the next mount, constrain growfs operations
if they would cause an increase in those maxlevels.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_fsops.c   |   12 ++++++++++
 fs/xfs/xfs_rtalloc.c |   63 +++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_rtalloc.h |    6 +++++
 fs/xfs/xfs_trace.h   |   21 +++++++++++++++++
 4 files changed, 101 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 9770916acd69..65b44ad8884e 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -23,6 +23,7 @@
 #include "xfs_trace.h"
 #include "xfs_rtgroup.h"
 #include "xfs_rtalloc.h"
+#include "xfs_rtrmap_btree.h"
 
 /*
  * Write new AG headers to disk. Non-transactional, but need to be
@@ -115,6 +116,13 @@ xfs_growfs_data_private(
 		xfs_buf_relse(bp);
 	}
 
+	/* Make sure the new fs size won't cause problems with the log. */
+	error = xfs_growfs_check_rtgeom(mp, nb, mp->m_sb.sb_rblocks,
+			mp->m_sb.sb_rextsize, mp->m_sb.sb_rextents,
+			mp->m_sb.sb_rbmblocks, mp->m_sb.sb_rextslog);
+	if (error)
+		return error;
+
 	nb_div = nb;
 	nb_mod = do_div(nb_div, mp->m_sb.sb_agblocks);
 	nagcount = nb_div + (nb_mod != 0);
@@ -214,7 +222,11 @@ xfs_growfs_data_private(
 		error = xfs_fs_reserve_ag_blocks(mp);
 		if (error == -ENOSPC)
 			error = 0;
+
+		/* Compute new maxlevels for rt btrees. */
+		xfs_rtrmapbt_compute_maxlevels(mp);
 	}
+
 	return error;
 
 out_trans_cancel:
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index c3d27cb85c26..7b7e22b36d48 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1049,6 +1049,57 @@ xfs_growfs_rt_init_primary(
 	return 0;
 }
 
+/*
+ * Check that changes to the realtime geometry won't affect the minimum
+ * log size, which would cause the fs to become unusable.
+ */
+int
+xfs_growfs_check_rtgeom(
+	const struct xfs_mount	*mp,
+	xfs_rfsblock_t		dblocks,
+	xfs_rfsblock_t		rblocks,
+	xfs_agblock_t		rextsize,
+	xfs_rtblock_t		rextents,
+	xfs_extlen_t		rbmblocks,
+	uint8_t			rextslog)
+{
+	struct xfs_mount	*fake_mp;
+	int			min_logfsbs;
+
+	fake_mp = kmem_alloc(sizeof(struct xfs_mount), KM_MAYFAIL);
+	if (!fake_mp)
+		return -ENOMEM;
+
+	/*
+	 * Create a dummy xfs_mount with the new rt geometry, and compute the
+	 * new minimum log size.  This ensures that the log is big enough to
+	 * handle the larger transactions that we could start sending.
+	 */
+	memcpy(fake_mp, mp, sizeof(struct xfs_mount));
+
+	fake_mp->m_sb.sb_dblocks = dblocks;
+	fake_mp->m_sb.sb_rblocks = rblocks;
+	fake_mp->m_sb.sb_rextents = rextents;
+	fake_mp->m_sb.sb_rextsize = rextsize;
+	fake_mp->m_sb.sb_rbmblocks = rbmblocks;
+	fake_mp->m_sb.sb_rextslog = rextslog;
+	if (rblocks > 0)
+		fake_mp->m_features |= XFS_FEAT_REALTIME;
+
+	xfs_rtrmapbt_compute_maxlevels(fake_mp);
+
+	xfs_trans_resv_calc(fake_mp, M_RES(fake_mp));
+	min_logfsbs = xfs_log_calc_minimum_size(fake_mp);
+	trace_xfs_growfs_check_rtgeom(mp, min_logfsbs);
+
+	kmem_free(fake_mp);
+
+	if (mp->m_sb.sb_logblocks < min_logfsbs)
+		return -ENOSPC;
+
+	return 0;
+}
+
 /*
  * Grow the realtime area of the filesystem.
  */
@@ -1139,6 +1190,12 @@ xfs_growfs_rt(
 	if (nrsumblocks > (mp->m_sb.sb_logblocks >> 1))
 		return -EINVAL;
 
+	/* Make sure the new fs size won't cause problems with the log. */
+	error = xfs_growfs_check_rtgeom(mp, mp->m_sb.sb_dblocks, nrblocks,
+			in->extsize, nrextents, nrbmblocks, nrextslog);
+	if (error)
+		return error;
+
 	/* Allocate the new rt group structures */
 	if (xfs_has_rtgroups(mp)) {
 		/*
@@ -1313,8 +1370,12 @@ xfs_growfs_rt(
 			rtg->rtg_blockcount = xfs_rtgroup_block_count(mp,
 								rtg->rtg_rgno);
 
-		/* Ensure the mount RT feature flag is now set. */
+		/*
+		 * Ensure the mount RT feature flag is now set, and compute new
+		 * maxlevels for rt btrees.
+		 */
 		mp->m_features |= XFS_FEAT_REALTIME;
+		xfs_rtrmapbt_compute_maxlevels(mp);
 	}
 	if (error)
 		goto out_free;
diff --git a/fs/xfs/xfs_rtalloc.h b/fs/xfs/xfs_rtalloc.h
index 873ebac239dd..35737a09cdb9 100644
--- a/fs/xfs/xfs_rtalloc.h
+++ b/fs/xfs/xfs_rtalloc.h
@@ -84,6 +84,11 @@ xfs_growfs_rt(
 int xfs_rtalloc_reinit_frextents(struct xfs_mount *mp);
 int xfs_rtfile_convert_unwritten(struct xfs_inode *ip, loff_t pos,
 		uint64_t len);
+
+int xfs_growfs_check_rtgeom(const struct xfs_mount *mp, xfs_rfsblock_t dblocks,
+		xfs_rfsblock_t rblocks, xfs_agblock_t rextsize,
+		xfs_rtblock_t rextents, xfs_extlen_t rbmblocks,
+		uint8_t rextslog);
 #else
 # define xfs_rtallocate_extent(t,b,min,max,l,f,p,rb)	(-ENOSYS)
 # define xfs_rtpick_extent(m,t,l,rb)			(-ENOSYS)
@@ -107,6 +112,7 @@ xfs_rtmount_init(
 # define xfs_rt_resv_free(mp)				((void)0)
 # define xfs_rt_resv_init(mp)				(0)
 # define xfs_rtmount_dqattach(mp)			(0)
+# define xfs_growfs_check_rtgeom(mp, d, r, rs, rx, rb, rl)	(0)
 #endif	/* CONFIG_XFS_RT */
 
 #endif	/* __XFS_RTALLOC_H__ */
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 77f4acc1b923..d90e9183dfc7 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -5196,6 +5196,27 @@ DEFINE_IMETA_RESV_EVENT(xfs_imeta_resv_free_extent);
 DEFINE_IMETA_RESV_EVENT(xfs_imeta_resv_critical);
 DEFINE_INODE_ERROR_EVENT(xfs_imeta_resv_init_error);
 
+#ifdef CONFIG_XFS_RT
+TRACE_EVENT(xfs_growfs_check_rtgeom,
+	TP_PROTO(const struct xfs_mount *mp, unsigned int min_logfsbs),
+	TP_ARGS(mp, min_logfsbs),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(unsigned int, logblocks)
+		__field(unsigned int, min_logfsbs)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->logblocks = mp->m_sb.sb_logblocks;
+		__entry->min_logfsbs = min_logfsbs;
+	),
+	TP_printk("dev %d:%d logblocks %u min_logfsbs %u",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->logblocks,
+		  __entry->min_logfsbs)
+);
+#endif /* CONFIG_XFS_RT */
+
 #endif /* _TRACE_XFS_H */
 
 #undef TRACE_INCLUDE_PATH

