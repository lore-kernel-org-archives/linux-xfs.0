Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3363381A0
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 05:10:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706591401; cv=none; b=nushHjp2q3aK3FbjmsMHVP2o5LHuOfGhch1N6l4g6nU3Tu0MGOmIPCEx74rv8NG5IEz27UHnyjHcVDYvANr3/15LoV9yxtgHVLH0dipqBWvMuXx1mzbiC4mTPkwg6qUPVemVExD3D6JiATPYF0yILemCiJK2tmv6D5hg2VVcICU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706591401; c=relaxed/simple;
	bh=A8/3yI12Yc5wDg5hzZVtIE/oNrOloMiyEvDqTEfKWdk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=e8PW119u8YQkvRE+X/b0lq4X9U/D998lQ7qVbBCvjslaRTyHtcASoJmQS4Qbo/v5kvhj/8W0er4JKD2yuTUd5oDuUiTljV3wjrCIljnGc3OFDy7I9D357x8tynb+IGMGMjlcQXPG2MQYDb7YS4pXBYQzqb1wHsuS47jIw3UMMG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O8e6ilJk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O8e6ilJk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ADB4C433C7;
	Tue, 30 Jan 2024 05:10:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706591401;
	bh=A8/3yI12Yc5wDg5hzZVtIE/oNrOloMiyEvDqTEfKWdk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=O8e6ilJkcND3K3C3zhyTucNCIzX5++FaJq9vTr7r3YQcWAPz0DhyU+bQv67e2m/hF
	 RiO1dxVEqi6Tr3iuUKjOSgCjeY3L+wxunk9vRPUjHoIhiWNfopM88YLntHEFzelLaL
	 2bVYkea9vYyz5PELNeLdWpU/rnoXVeQmtUjN8a7/vU4iu6ITBb2708hHGYm33GqAti
	 6DUEsEDK8Z2Ohu/V2WbTmLgGe1qky2apShtKfpmSPQdL9BZ4iiVjOmrHyRNvsoxSNm
	 58CQc8ctkjWdzbzta4QzLJgTd4fK6QT4RHTAygDiAleVWXxoHa+UalHLG59XLofmrt
	 CKG3xAlUBTyqg==
Date: Mon, 29 Jan 2024 21:10:00 -0800
Subject: [PATCH 03/11] xfs: report ag header corruption errors to the health
 tracking system
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <170659063774.3353909.904746989123529552.stgit@frogsfrogsfrogs>
In-Reply-To: <170659063695.3353909.12657412146136100266.stgit@frogsfrogsfrogs>
References: <170659063695.3353909.12657412146136100266.stgit@frogsfrogsfrogs>
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
 fs/xfs/libxfs/xfs_alloc.c  |    6 ++++++
 fs/xfs/libxfs/xfs_health.h |   13 ++++++++++---
 fs/xfs/libxfs/xfs_ialloc.c |    3 +++
 fs/xfs/libxfs/xfs_sb.c     |    2 ++
 fs/xfs/xfs_health.c        |   17 +++++++++++++++++
 fs/xfs/xfs_inode.c         |   14 ++++++++++++--
 6 files changed, 50 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 3bd0a33fee0a6..1cb2569c43cfc 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -26,6 +26,7 @@
 #include "xfs_ag.h"
 #include "xfs_ag_resv.h"
 #include "xfs_bmap.h"
+#include "xfs_health.h"
 
 struct kmem_cache	*xfs_extfree_item_cache;
 
@@ -755,6 +756,8 @@ xfs_alloc_read_agfl(
 			mp, tp, mp->m_ddev_targp,
 			XFS_AG_DADDR(mp, pag->pag_agno, XFS_AGFL_DADDR(mp)),
 			XFS_FSS_TO_BB(mp, 1), 0, &bp, &xfs_agfl_buf_ops);
+	if (xfs_metadata_is_sick(error))
+		xfs_ag_mark_sick(pag, XFS_SICK_AG_AGFL);
 	if (error)
 		return error;
 	xfs_buf_set_ref(bp, XFS_AGFL_REF);
@@ -776,6 +779,7 @@ xfs_alloc_update_counters(
 	if (unlikely(be32_to_cpu(agf->agf_freeblks) >
 		     be32_to_cpu(agf->agf_length))) {
 		xfs_buf_mark_corrupt(agbp);
+		xfs_ag_mark_sick(agbp->b_pag, XFS_SICK_AG_AGF);
 		return -EFSCORRUPTED;
 	}
 
@@ -3268,6 +3272,8 @@ xfs_read_agf(
 	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp,
 			XFS_AG_DADDR(mp, pag->pag_agno, XFS_AGF_DADDR(mp)),
 			XFS_FSS_TO_BB(mp, 1), flags, agfbpp, &xfs_agf_buf_ops);
+	if (xfs_metadata_is_sick(error))
+		xfs_ag_mark_sick(pag, XFS_SICK_AG_AGF);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/libxfs/xfs_health.h b/fs/xfs/libxfs/xfs_health.h
index 2b40fe8165702..cd7a1370a1ed8 100644
--- a/fs/xfs/libxfs/xfs_health.h
+++ b/fs/xfs/libxfs/xfs_health.h
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
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 2361a22035b0c..2531b4c08915d 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -27,6 +27,7 @@
 #include "xfs_log.h"
 #include "xfs_rmap.h"
 #include "xfs_ag.h"
+#include "xfs_health.h"
 
 /*
  * Lookup a record by ino in the btree given by cur.
@@ -2604,6 +2605,8 @@ xfs_read_agi(
 	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp,
 			XFS_AG_DADDR(mp, pag->pag_agno, XFS_AGI_DADDR(mp)),
 			XFS_FSS_TO_BB(mp, 1), 0, agibpp, &xfs_agi_buf_ops);
+	if (xfs_metadata_is_sick(error))
+		xfs_ag_mark_sick(pag, XFS_SICK_AG_AGI);
 	if (error)
 		return error;
 	if (tp)
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 5bb6e2bd6deee..d991eec054368 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -1290,6 +1290,8 @@ xfs_sb_read_secondary(
 	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp,
 			XFS_AG_DADDR(mp, agno, XFS_SB_BLOCK(mp)),
 			XFS_FSS_TO_BB(mp, 1), 0, &bp, &xfs_sb_buf_ops);
+	if (xfs_metadata_is_sick(error))
+		xfs_agno_mark_sick(mp, agno, XFS_SICK_AG_SB);
 	if (error)
 		return error;
 	xfs_buf_set_ref(bp, XFS_SSB_REF);
diff --git a/fs/xfs/xfs_health.c b/fs/xfs/xfs_health.c
index f79c332aaa076..229a51cef47ee 100644
--- a/fs/xfs/xfs_health.c
+++ b/fs/xfs/xfs_health.c
@@ -198,6 +198,23 @@ xfs_rt_measure_sickness(
 	spin_unlock(&mp->m_sb_lock);
 }
 
+/* Mark unhealthy per-ag metadata given a raw AG number. */
+void
+xfs_agno_mark_sick(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agno,
+	unsigned int		mask)
+{
+	struct xfs_perag	*pag = xfs_perag_get(mp, agno);
+
+	/* per-ag structure not set up yet? */
+	if (!pag)
+		return;
+
+	xfs_ag_mark_sick(pag, mask);
+	xfs_perag_put(pag);
+}
+
 /* Mark unhealthy per-ag metadata. */
 void
 xfs_ag_mark_sick(
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index a65ec91a5c0f8..8dabe9e12f796 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -802,6 +802,8 @@ xfs_init_new_inode(
 	 */
 	if ((pip && ino == pip->i_ino) || !xfs_verify_dir_ino(mp, ino)) {
 		xfs_alert(mp, "Allocated a known in-use inode 0x%llx!", ino);
+		xfs_agno_mark_sick(mp, XFS_INO_TO_AGNO(mp, ino),
+				XFS_SICK_AG_INOBT);
 		return -EFSCORRUPTED;
 	}
 
@@ -1983,6 +1985,7 @@ xfs_iunlink_update_bucket(
 	 */
 	if (old_value == new_agino) {
 		xfs_buf_mark_corrupt(agibp);
+		xfs_ag_mark_sick(pag, XFS_SICK_AG_AGI);
 		return -EFSCORRUPTED;
 	}
 
@@ -2032,11 +2035,14 @@ xfs_iunlink_reload_next(
 	 */
 	ino = XFS_AGINO_TO_INO(mp, pag->pag_agno, next_agino);
 	error = xfs_iget(mp, tp, ino, XFS_IGET_UNTRUSTED, 0, &next_ip);
-	if (error)
+	if (error) {
+		xfs_ag_mark_sick(pag, XFS_SICK_AG_AGI);
 		return error;
+	}
 
 	/* If this is not an unlinked inode, something is very wrong. */
 	if (VFS_I(next_ip)->i_nlink != 0) {
+		xfs_ag_mark_sick(pag, XFS_SICK_AG_AGI);
 		error = -EFSCORRUPTED;
 		goto rele;
 	}
@@ -2074,6 +2080,7 @@ xfs_iunlink_insert_inode(
 	if (next_agino == agino ||
 	    !xfs_verify_agino_or_null(pag, next_agino)) {
 		xfs_buf_mark_corrupt(agibp);
+		xfs_ag_mark_sick(pag, XFS_SICK_AG_AGI);
 		return -EFSCORRUPTED;
 	}
 
@@ -2161,6 +2168,7 @@ xfs_iunlink_remove_inode(
 	if (!xfs_verify_agino(pag, head_agino)) {
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
 				agi, sizeof(*agi));
+		xfs_ag_mark_sick(pag, XFS_SICK_AG_AGI);
 		return -EFSCORRUPTED;
 	}
 
@@ -2189,8 +2197,10 @@ xfs_iunlink_remove_inode(
 		struct xfs_inode	*prev_ip;
 
 		prev_ip = xfs_iunlink_lookup(pag, ip->i_prev_unlinked);
-		if (!prev_ip)
+		if (!prev_ip) {
+			xfs_inode_mark_sick(ip, XFS_SICK_INO_CORE);
 			return -EFSCORRUPTED;
+		}
 
 		error = xfs_iunlink_log_inode(tp, prev_ip, pag,
 				ip->i_next_unlinked);

