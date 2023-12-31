Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65468C12B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dyTaV/Aa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34D39C433C8;
	Sun, 31 Dec 2023 22:11:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704060717;
	bh=L86+pAsBrr7rrZE0J2DQa9bSLXuWKvwpOpQSKk+UxYI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=dyTaV/AaCgh6WQoCGPWEhmPb7ATx+BL33TWQoUlx72NrIKiCAUm5JIRZnRTggAfzS
	 Ea6MIvt1VCCtOlortDIMoX0WX4yv4ZqhnPm3wldB0iBVGJcj5n6g+ZK5JksyYuR0W4
	 WNzwy9jhLira5TIOKsI7NBcll/IW+E+dOayrKDHn9/O+o5u9Sh9N3EViWghpMDUWv9
	 ZJ67hCoq1v+Zt8Gu5gKq83ZHskHWqVG+Kv5L0vViRXvXyQmSpMtPqy40Vk8OcQmkeG
	 4U204k522K9SqKvLo6KQ5qBkIZy0T0a5/Axv/uYqciAbq79FEO05hxpltjQt978cLK
	 Zf9GiMK8LcN0A==
Date: Sun, 31 Dec 2023 14:11:56 -0800
Subject: [PATCH 3/9] xfs: report ag header corruption errors to the health
 tracking system
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404991991.1794070.485161857977764006.stgit@frogsfrogsfrogs>
In-Reply-To: <170404991943.1794070.7853125417143732405.stgit@frogsfrogsfrogs>
References: <170404991943.1794070.7853125417143732405.stgit@frogsfrogsfrogs>
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

Whenever we encounter a corrupt AG header, we should report that to the
health monitoring system for later reporting.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/util.c       |    3 +++
 libxfs/xfs_alloc.c  |    6 ++++++
 libxfs/xfs_health.h |   13 ++++++++++---
 libxfs/xfs_ialloc.c |    3 +++
 libxfs/xfs_sb.c     |    2 ++
 5 files changed, 24 insertions(+), 3 deletions(-)


diff --git a/libxfs/util.c b/libxfs/util.c
index 931cb78eaef..b2d4356fd41 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -729,3 +729,6 @@ xfs_fs_mark_healthy(
 
 void xfs_ag_geom_health(struct xfs_perag *pag, struct xfs_ag_geometry *ageo) { }
 void xfs_fs_mark_sick(struct xfs_mount *mp, unsigned int mask) { }
+void xfs_agno_mark_sick(struct xfs_mount *mp, xfs_agnumber_t agno,
+		unsigned int mask) { }
+void xfs_ag_mark_sick(struct xfs_perag *pag, unsigned int mask) { }
diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index 352efbeca9f..1894a091380 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -22,6 +22,7 @@
 #include "xfs_ag.h"
 #include "xfs_ag_resv.h"
 #include "xfs_bmap.h"
+#include "xfs_health.h"
 
 struct kmem_cache	*xfs_extfree_item_cache;
 
@@ -751,6 +752,8 @@ xfs_alloc_read_agfl(
 			mp, tp, mp->m_ddev_targp,
 			XFS_AG_DADDR(mp, pag->pag_agno, XFS_AGFL_DADDR(mp)),
 			XFS_FSS_TO_BB(mp, 1), 0, &bp, &xfs_agfl_buf_ops);
+	if (xfs_metadata_is_sick(error))
+		xfs_ag_mark_sick(pag, XFS_SICK_AG_AGFL);
 	if (error)
 		return error;
 	xfs_buf_set_ref(bp, XFS_AGFL_REF);
@@ -772,6 +775,7 @@ xfs_alloc_update_counters(
 	if (unlikely(be32_to_cpu(agf->agf_freeblks) >
 		     be32_to_cpu(agf->agf_length))) {
 		xfs_buf_mark_corrupt(agbp);
+		xfs_ag_mark_sick(agbp->b_pag, XFS_SICK_AG_AGF);
 		return -EFSCORRUPTED;
 	}
 
@@ -3264,6 +3268,8 @@ xfs_read_agf(
 	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp,
 			XFS_AG_DADDR(mp, pag->pag_agno, XFS_AGF_DADDR(mp)),
 			XFS_FSS_TO_BB(mp, 1), flags, agfbpp, &xfs_agf_buf_ops);
+	if (xfs_metadata_is_sick(error))
+		xfs_ag_mark_sick(pag, XFS_SICK_AG_AGF);
 	if (error)
 		return error;
 
diff --git a/libxfs/xfs_health.h b/libxfs/xfs_health.h
index 2b40fe81657..cd7a1370a1e 100644
--- a/libxfs/xfs_health.h
+++ b/libxfs/xfs_health.h
@@ -26,9 +26,11 @@
  * and the "sick" field tells us if that piece was found to need repairs.
  * Therefore we can conclude that for a given sick flag value:
  *
- *  - checked && sick  => metadata needs repair
- *  - checked && !sick => metadata is ok
- *  - !checked         => has not been examined since mount
+ *  - checked && sick   => metadata needs repair
+ *  - checked && !sick  => metadata is ok
+ *  - !checked && sick  => errors have been observed during normal operation,
+ *                         but the metadata has not been checked thoroughly
+ *  - !checked && !sick => has not been examined since mount
  */
 
 struct xfs_mount;
@@ -135,6 +137,8 @@ void xfs_rt_mark_healthy(struct xfs_mount *mp, unsigned int mask);
 void xfs_rt_measure_sickness(struct xfs_mount *mp, unsigned int *sick,
 		unsigned int *checked);
 
+void xfs_agno_mark_sick(struct xfs_mount *mp, xfs_agnumber_t agno,
+		unsigned int mask);
 void xfs_ag_mark_sick(struct xfs_perag *pag, unsigned int mask);
 void xfs_ag_mark_checked(struct xfs_perag *pag, unsigned int mask);
 void xfs_ag_mark_healthy(struct xfs_perag *pag, unsigned int mask);
@@ -215,4 +219,7 @@ void xfs_fsop_geom_health(struct xfs_mount *mp, struct xfs_fsop_geom *geo);
 void xfs_ag_geom_health(struct xfs_perag *pag, struct xfs_ag_geometry *ageo);
 void xfs_bulkstat_health(struct xfs_inode *ip, struct xfs_bulkstat *bs);
 
+#define xfs_metadata_is_sick(error) \
+	(unlikely((error) == -EFSCORRUPTED || (error) == -EFSBADCRC))
+
 #endif	/* __XFS_HEALTH_H__ */
diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index 5ff09c8c943..c801250a33b 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -22,6 +22,7 @@
 #include "xfs_trace.h"
 #include "xfs_rmap.h"
 #include "xfs_ag.h"
+#include "xfs_health.h"
 
 /*
  * Lookup a record by ino in the btree given by cur.
@@ -2599,6 +2600,8 @@ xfs_read_agi(
 	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp,
 			XFS_AG_DADDR(mp, pag->pag_agno, XFS_AGI_DADDR(mp)),
 			XFS_FSS_TO_BB(mp, 1), 0, agibpp, &xfs_agi_buf_ops);
+	if (xfs_metadata_is_sick(error))
+		xfs_ag_mark_sick(pag, XFS_SICK_AG_AGI);
 	if (error)
 		return error;
 	if (tp)
diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index 7a72d5a1791..30a6bc07d88 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -1288,6 +1288,8 @@ xfs_sb_read_secondary(
 	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp,
 			XFS_AG_DADDR(mp, agno, XFS_SB_BLOCK(mp)),
 			XFS_FSS_TO_BB(mp, 1), 0, &bp, &xfs_sb_buf_ops);
+	if (xfs_metadata_is_sick(error))
+		xfs_agno_mark_sick(mp, agno, XFS_SICK_AG_SB);
 	if (error)
 		return error;
 	xfs_buf_set_ref(bp, XFS_SSB_REF);

