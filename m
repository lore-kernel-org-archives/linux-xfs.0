Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 738052837B
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 23:01:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734994881; cv=none; b=ERyc7pFEcOUkwEGzbdnWJ1RTyndMDSB8L2+IJEPtWKDNyqLo/8DvM3wdm17Ov7dqIK3qvyFmxXMf6gAFsdw1BXIwHHHNkoFnKQbVO2Xi7Ly8V3yMU0j3Ll9EWzoGcqcbwXzUr3lppMT01rGk4OVUfhO2sFPJAVGahXBMuFgKw9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734994881; c=relaxed/simple;
	bh=EOxmWtCBXvSektmRB24HXxKuGkLQkChNjKF0ZsTCN2A=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nJY5cBcwwij/+MiD66ekUH5SKA06S63bXUag+YCJ0KRBoeaxEBp0By76PpZKhYddp/2TYucUEwiAO8W2eZpahnN4bMmBuxIXSfgX36mtfruVTi0c7hjg0nsNR4cNIHZt0bD7KekMrg1KV69iHoRtnv+l2WkuB3ahppMZTp60IVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=go5KNv0X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="go5KNv0X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0993AC4CED3;
	Mon, 23 Dec 2024 23:01:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734994881;
	bh=EOxmWtCBXvSektmRB24HXxKuGkLQkChNjKF0ZsTCN2A=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=go5KNv0XE7cenMHleZ5IneAeXTp+kitVN0EVBuu3eNygcmqtbIhQNk9+or2e4hnsg
	 cgi5hfj2t2q/DtzkzZZL7E+PXvlOPz4MwU4cN3j+i0jSqNYTWqEW6THcbQ7ZVLfhfA
	 jIr6TiCJnjFFlj3mVqDSOgtIeGUuPcfrgWdCJoyVnAPZ4m/XcQqhYbQIWCazKUm+ya
	 wvsl+yDiNmNpyexYNfC487k/xJzwCluD7/PFoBsr+FsRtxTpPLtz5wr0z1G2pTIsDp
	 GLQ4RaEpCC7WTGsgjE6U6e+DVe8UNVcKATNUm8SXyrOaHK1H8ItB/C/+iqsMGud7Dt
	 oMo2Vq3iFNAPQ==
Date: Mon, 23 Dec 2024 15:01:20 -0800
Subject: [PATCH 18/37] xfs: check that the rtrmapbt maxlevels doesn't increase
 when growing fs
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173499419026.2380130.9357248549186947263.stgit@frogsfrogsfrogs>
In-Reply-To: <173499418610.2380130.12548657506222792394.stgit@frogsfrogsfrogs>
References: <173499418610.2380130.12548657506222792394.stgit@frogsfrogsfrogs>
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

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_fsops.c   |   11 +++++++++++
 fs/xfs/xfs_rtalloc.c |   25 ++++++++++++++++++-------
 fs/xfs/xfs_rtalloc.h |   10 ++++++++++
 fs/xfs/xfs_trace.h   |   21 +++++++++++++++++++++
 4 files changed, 60 insertions(+), 7 deletions(-)


diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index e1145107d8cbd1..9df5a09c0acd3b 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -22,6 +22,7 @@
 #include "xfs_ag_resv.h"
 #include "xfs_trace.h"
 #include "xfs_rtalloc.h"
+#include "xfs_rtrmap_btree.h"
 
 /*
  * Write new AG headers to disk. Non-transactional, but need to be
@@ -114,6 +115,12 @@ xfs_growfs_data_private(
 		xfs_buf_relse(bp);
 	}
 
+	/* Make sure the new fs size won't cause problems with the log. */
+	error = xfs_growfs_check_rtgeom(mp, nb, mp->m_sb.sb_rblocks,
+			mp->m_sb.sb_rextsize);
+	if (error)
+		return error;
+
 	nb_div = nb;
 	nb_mod = do_div(nb_div, mp->m_sb.sb_agblocks);
 	if (nb_mod && nb_mod >= XFS_MIN_AG_BLOCKS)
@@ -221,7 +228,11 @@ xfs_growfs_data_private(
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
index c7efd926413981..3c1bce5a4855f2 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -989,9 +989,11 @@ xfs_growfs_rt_bmblock(
 		goto out_free;
 
 	/*
-	 * Ensure the mount RT feature flag is now set.
+	 * Ensure the mount RT feature flag is now set, and compute new
+	 * maxlevels for rt btrees.
 	 */
 	mp->m_features |= XFS_FEAT_REALTIME;
+	xfs_rtrmapbt_compute_maxlevels(mp);
 
 	kfree(nmp);
 	return 0;
@@ -1159,29 +1161,37 @@ xfs_growfs_rtg(
 	return error;
 }
 
-static int
+int
 xfs_growfs_check_rtgeom(
 	const struct xfs_mount	*mp,
+	xfs_rfsblock_t		dblocks,
 	xfs_rfsblock_t		rblocks,
 	xfs_extlen_t		rextsize)
 {
+	xfs_extlen_t		min_logfsbs;
 	struct xfs_mount	*nmp;
-	int			error = 0;
 
 	nmp = xfs_growfs_rt_alloc_fake_mount(mp, rblocks, rextsize);
 	if (!nmp)
 		return -ENOMEM;
+	nmp->m_sb.sb_dblocks = dblocks;
+
+	xfs_rtrmapbt_compute_maxlevels(nmp);
+	xfs_trans_resv_calc(nmp, M_RES(nmp));
 
 	/*
 	 * New summary size can't be more than half the size of the log.  This
 	 * prevents us from getting a log overflow, since we'll log basically
 	 * the whole summary file at once.
 	 */
-	if (nmp->m_rsumblocks > (mp->m_sb.sb_logblocks >> 1))
-		error = -EINVAL;
+	min_logfsbs = min_t(xfs_extlen_t, xfs_log_calc_minimum_size(nmp),
+			nmp->m_rsumblocks * 2);
 
 	kfree(nmp);
-	return error;
+
+	if (min_logfsbs > mp->m_sb.sb_logblocks)
+		return -EINVAL;
+	return 0;
 }
 
 /*
@@ -1300,7 +1310,8 @@ xfs_growfs_rt(
 		goto out_unlock;
 
 	/* Make sure the new fs size won't cause problems with the log. */
-	error = xfs_growfs_check_rtgeom(mp, in->newblocks, in->extsize);
+	error = xfs_growfs_check_rtgeom(mp, mp->m_sb.sb_dblocks, in->newblocks,
+			in->extsize);
 	if (error)
 		goto out_unlock;
 
diff --git a/fs/xfs/xfs_rtalloc.h b/fs/xfs/xfs_rtalloc.h
index d87523e6a55006..9044f7226ab6fc 100644
--- a/fs/xfs/xfs_rtalloc.h
+++ b/fs/xfs/xfs_rtalloc.h
@@ -46,6 +46,8 @@ xfs_growfs_rt(
 	xfs_growfs_rt_t		*in);	/* user supplied growfs struct */
 
 int xfs_rtalloc_reinit_frextents(struct xfs_mount *mp);
+int xfs_growfs_check_rtgeom(const struct xfs_mount *mp, xfs_rfsblock_t dblocks,
+		xfs_rfsblock_t rblocks, xfs_agblock_t rextsize);
 #else
 # define xfs_growfs_rt(mp,in)				(-ENOSYS)
 # define xfs_rtalloc_reinit_frextents(m)		(0)
@@ -65,6 +67,14 @@ xfs_rtmount_init(
 # define xfs_rtunmount_inodes(m)
 # define xfs_rt_resv_free(mp)				((void)0)
 # define xfs_rt_resv_init(mp)				(0)
+
+static inline int
+xfs_growfs_check_rtgeom(const struct xfs_mount *mp,
+		xfs_rfsblock_t dblocks, xfs_rfsblock_t rblocks,
+		xfs_extlen_t rextsize)
+{
+	return 0;
+}
 #endif	/* CONFIG_XFS_RT */
 
 #endif	/* __XFS_RTALLOC_H__ */
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index a098935163b7c2..84cdc145e2d96a 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -5622,6 +5622,27 @@ DEFINE_METAFILE_RESV_EVENT(xfs_metafile_resv_free_space);
 DEFINE_METAFILE_RESV_EVENT(xfs_metafile_resv_critical);
 DEFINE_INODE_ERROR_EVENT(xfs_metafile_resv_init_error);
 
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

