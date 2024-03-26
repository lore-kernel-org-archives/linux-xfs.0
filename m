Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1650286AC1
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:33:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711423987; cv=none; b=S1ZGrhNWPL2O7TR9P4JsyBfxmKrAT/gHpAp+rWW3nsjyabreOzYlRU2nWzW9K1ixvRurfMXo6+NmZAS6UlpQoqwDRwEP7ZknywHGNK4vMtnv7/xwUpM7YKsoywHu+EopSX4yzW8OHA12WFg/JfOkJfooiSbtrsnnmsCJoWR9B/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711423987; c=relaxed/simple;
	bh=wA9nUqTPxhvXwrfOvK33SIeS99rjJDaYOY0pslD560c=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cy0VmuZhdvggDYKokjl3Rrkq4xNwicWcN/hQpNS5zXBsYSzG2hTMDmGchow4uySLF91P+UHpmAE6Ot9BeXTTpRb885ua+gog+ooPpShEMl8iggW6X8I0mbCLqSQ6J08Sm5Hrua5kpqyCDGuHzNpX+2MD+qje4eUpjnxjn8vu7ic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tqwHQhQA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tqwHQhQA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F2E7C433C7;
	Tue, 26 Mar 2024 03:33:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711423986;
	bh=wA9nUqTPxhvXwrfOvK33SIeS99rjJDaYOY0pslD560c=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=tqwHQhQABdmg0GDKnuP+mCN6RzZviU3RBDLigh2v8MQiJPj+FLh+bI8MKm+zzfKRa
	 xH0DOBZ9zRHDtPK3vxsS/9SELZlZEfjTOOuU+Zp0yWeC2t2DL0uMyWykwpz7fyH1H+
	 h7rNon23kREPeaMhEKrfi8e+Y6JsbBwj+1DqDXuNb12ulogblwPG4/H8Yi7MjToPBK
	 825EOl8YTuYh5sNALDEShpLasfJPgoPb8fTcT9h0+7LP6gcA88oDaw8sVvyhKjDgpe
	 LF5O3xQa7WMza1dL/rvlrz6xyfltLYy61345q5XLtlobsLCbmM/P/2ccgDqKwPB5l5
	 9n6rBaKZu7DrA==
Date: Mon, 25 Mar 2024 20:33:06 -0700
Subject: [PATCH 018/110] xfs: report ag header corruption errors to the health
 tracking system
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171142131644.2215168.12815713859360977969.stgit@frogsfrogsfrogs>
In-Reply-To: <171142131228.2215168.2795743548791967397.stgit@frogsfrogsfrogs>
References: <171142131228.2215168.2795743548791967397.stgit@frogsfrogsfrogs>
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

Source kernel commit: de6077ec4198b9313c6e09e4c6acbe9179d057c1

Whenever we encounter a corrupt AG header, we should report that to the
health monitoring system for later reporting.  Buffer readers that don't
respond to corruption events with a _mark_sick call can be detected with
the following script:

#!/bin/bash

# Detect missing calls to xfs_*_mark_sick

filter=cat
tty -s && filter=less

git grep -A10  -E '( = xfs_trans_read_buf| = xfs_buf_read\()' fs/xfs/*.[ch] fs/xfs/libxfs/*.[ch] | awk '
BEGIN {
ignore = 0;
lineno = 0;
delete lines;
}
{
if ($0 == "--") {
if (!ignore) {
for (i = 0; i < lineno; i++) {
print(lines[i]);
}
printf("--\n");
}
delete lines;
lineno = 0;
ignore = 0;
} else if ($0 ~ /mark_sick/) {
ignore = 1;
} else {
lines[lineno++] = $0;
}
}
' | $filter

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/util.c       |    3 +++
 libxfs/xfs_alloc.c  |    6 ++++++
 libxfs/xfs_health.h |   13 ++++++++++---
 libxfs/xfs_ialloc.c |    3 +++
 libxfs/xfs_sb.c     |    2 ++
 5 files changed, 24 insertions(+), 3 deletions(-)


diff --git a/libxfs/util.c b/libxfs/util.c
index 26339171ff82..c30d83a8d6fb 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -729,3 +729,6 @@ xfs_fs_mark_healthy(
 
 void xfs_ag_geom_health(struct xfs_perag *pag, struct xfs_ag_geometry *ageo) { }
 void xfs_fs_mark_sick(struct xfs_mount *mp, unsigned int mask) { }
+void xfs_agno_mark_sick(struct xfs_mount *mp, xfs_agnumber_t agno,
+		unsigned int mask) { }
+void xfs_ag_mark_sick(struct xfs_perag *pag, unsigned int mask) { }
diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index 352efbeca9f4..1894a0913807 100644
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
index bec7adf9fcf7..fb3f2b49087d 100644
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
@@ -142,6 +144,8 @@ void xfs_rt_mark_healthy(struct xfs_mount *mp, unsigned int mask);
 void xfs_rt_measure_sickness(struct xfs_mount *mp, unsigned int *sick,
 		unsigned int *checked);
 
+void xfs_agno_mark_sick(struct xfs_mount *mp, xfs_agnumber_t agno,
+		unsigned int mask);
 void xfs_ag_mark_sick(struct xfs_perag *pag, unsigned int mask);
 void xfs_ag_mark_corrupt(struct xfs_perag *pag, unsigned int mask);
 void xfs_ag_mark_healthy(struct xfs_perag *pag, unsigned int mask);
@@ -222,4 +226,7 @@ void xfs_fsop_geom_health(struct xfs_mount *mp, struct xfs_fsop_geom *geo);
 void xfs_ag_geom_health(struct xfs_perag *pag, struct xfs_ag_geometry *ageo);
 void xfs_bulkstat_health(struct xfs_inode *ip, struct xfs_bulkstat *bs);
 
+#define xfs_metadata_is_sick(error) \
+	(unlikely((error) == -EFSCORRUPTED || (error) == -EFSBADCRC))
+
 #endif	/* __XFS_HEALTH_H__ */
diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index 5ff09c8c9439..c801250a33bf 100644
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
index 402f03a557e0..00b0a937d61e 100644
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

