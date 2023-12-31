Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37FF4BA22
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ntZG3vhs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB1F9C433C8;
	Sun, 31 Dec 2023 21:37:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704058620;
	bh=+XNhfkSrBFegwmzhPOYnyf9QQ5vP60c2ra534jTk3UY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ntZG3vhsTq0PiOEjPfCGK/ft1i4K+gSXyAM682ktJDP1oxZCT/zWQAifQMtP1jI/B
	 NhxrgZ7UzRIMPIkzwJreikdbWtbCVO8l02LzqXkVJbPLeraS38siarkflcieP5uZlY
	 VbtLf4s41jnLBpgvXyan0ts7uiIzZTmbknflV8dKGfV6bBnAweU9rNDXxysrzDZ8OW
	 S1pI8ucJ1X1NXaI+ZXmBrk8Yp/oU4qiy2C7EKZDXY71noneX2tUHhXoiZ2H6ZF3FfX
	 VtokYuxQ8yh2/t+rTFFdIbjaJmL7N1vfdZ0qufHpQ142VPOCQl+vVPaW83VvYoeJlD
	 QbID31etuN9yQ==
Date: Sun, 31 Dec 2023 13:37:00 -0800
Subject: [PATCH 20/39] xfs: check that the rtrmapbt maxlevels doesn't increase
 when growing fs
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404850221.1764998.5077676356604159966.stgit@frogsfrogsfrogs>
In-Reply-To: <170404849811.1764998.10873316890301599216.stgit@frogsfrogsfrogs>
References: <170404849811.1764998.10873316890301599216.stgit@frogsfrogsfrogs>
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

The size of filesystem transaction reservations depends on the maximum
height (maxlevels) of the realtime btrees.  Since we don't want a grow
operation to increase the reservation size enough that we'll fail the
minimum log size checks on the next mount, constrain growfs operations
if they would cause an increase in those maxlevels.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_fsops.c   |   12 +++++++++
 fs/xfs/xfs_rtalloc.c |   64 +++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_rtalloc.h |    5 ++++
 fs/xfs/xfs_trace.h   |   21 ++++++++++++++++
 4 files changed, 101 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 99f9f5c8d9b6e..e78ee67b9dd12 100644
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
 	if (nb_mod && nb_mod >= XFS_MIN_AG_BLOCKS)
@@ -227,7 +235,11 @@ xfs_growfs_data_private(
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
index 2f2a92672de9a..ac6580bda2052 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -27,6 +27,7 @@
 #include "xfs_rtgroup.h"
 #include "xfs_error.h"
 #include "xfs_rtrmap_btree.h"
+#include "xfs_trace.h"
 
 /*
  * Realtime metadata files are not quite regular files because userspace can't
@@ -1016,6 +1017,57 @@ xfs_growfs_rt_init_primary(
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
@@ -1107,6 +1159,12 @@ xfs_growfs_rt(
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
 		uint64_t	new_rgcount;
@@ -1301,8 +1359,12 @@ xfs_growfs_rt(
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
index c01ca192646a9..8a7b6cfa13cf0 100644
--- a/fs/xfs/xfs_rtalloc.h
+++ b/fs/xfs/xfs_rtalloc.h
@@ -80,6 +80,10 @@ xfs_growfs_rt(
 	xfs_growfs_rt_t		*in);	/* user supplied growfs struct */
 
 int xfs_rtalloc_reinit_frextents(struct xfs_mount *mp);
+int xfs_growfs_check_rtgeom(const struct xfs_mount *mp, xfs_rfsblock_t dblocks,
+		xfs_rfsblock_t rblocks, xfs_agblock_t rextsize,
+		xfs_rtblock_t rextents, xfs_extlen_t rbmblocks,
+		uint8_t rextslog);
 #else
 # define xfs_rtallocate_extent(t,b,min,max,l,f,p,rb)	(-ENOSYS)
 # define xfs_rtpick_extent(m,t,l,rb)			(-ENOSYS)
@@ -101,6 +105,7 @@ xfs_rtmount_init(
 # define xfs_rtunmount_inodes(m)
 # define xfs_rt_resv_free(mp)				((void)0)
 # define xfs_rt_resv_init(mp)				(0)
+# define xfs_growfs_check_rtgeom(mp, d, r, rs, rx, rb, rl)	(0)
 #endif	/* CONFIG_XFS_RT */
 
 #endif	/* __XFS_RTALLOC_H__ */
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 8ebdfb216266c..2dc991730c303 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -5406,6 +5406,27 @@ DEFINE_IMETA_RESV_EVENT(xfs_imeta_resv_free_extent);
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

