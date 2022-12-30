Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F20C4C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:37:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229527AbiL3Xh3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:37:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231174AbiL3Xh3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:37:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2B0C1DDDC
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:37:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 77B8D61C35
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:37:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D33E9C433EF;
        Fri, 30 Dec 2022 23:37:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672443446;
        bh=1+TDsQT+rZBPHdRCHxZdWarUyHxP91MT/2kbJvnJWy8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=CQAaEy02IKFYexORTi88p1ZVxUC83gjYQkPfqBup9R+nrue8XuFO3ZIellpeUF1MU
         QkIRrE517gMVD7C3pxgxchaF4flX7numiLNWBeFWj4uQJ0HwW9YZ6nT6hf7Azdxv/E
         Ahzo9AY4U9QyFlQ/l4AlAC6Q86j+44xsRzIy9wZxM4djUMi0ZWJTdO7Sqkz/PgVspg
         SvHdgvLZpBhSN4KKTNQU3ZocGvCVFqCxBFB8RaLrlD5n8wPPhBqi0vYUSoJpSY1+ef
         wqIj8jAb/iE8VEFSXhkmybt9ALmNWXPilaB4D3KKKpFfayKl5tae6PiC1eFN9wuoZK
         ou1N1xwMEXw2Q==
Subject: [PATCH 03/11] xfs: report ag header corruption errors to the health
 tracking system
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:13:15 -0800
Message-ID: <167243839502.695999.12047368799170028400.stgit@magnolia>
In-Reply-To: <167243839445.695999.12861421643354894719.stgit@magnolia>
References: <167243839445.695999.12861421643354894719.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Whenever we encounter a corrupt AG header, we should report that to the
health monitoring system for later reporting.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_alloc.c  |    6 ++++++
 fs/xfs/libxfs/xfs_health.h |   13 ++++++++++---
 fs/xfs/libxfs/xfs_ialloc.c |    3 +++
 fs/xfs/libxfs/xfs_sb.c     |    2 ++
 fs/xfs/xfs_health.c        |   17 +++++++++++++++++
 fs/xfs/xfs_inode.c         |   15 +++++++++++++--
 6 files changed, 51 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 62136ecaa071..819a38170351 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -26,6 +26,7 @@
 #include "xfs_ag.h"
 #include "xfs_ag_resv.h"
 #include "xfs_bmap.h"
+#include "xfs_health.h"
 
 struct kmem_cache	*xfs_extfree_item_cache;
 
@@ -754,6 +755,8 @@ xfs_alloc_read_agfl(
 			mp, tp, mp->m_ddev_targp,
 			XFS_AG_DADDR(mp, pag->pag_agno, XFS_AGFL_DADDR(mp)),
 			XFS_FSS_TO_BB(mp, 1), 0, &bp, &xfs_agfl_buf_ops);
+	if (xfs_metadata_is_sick(error))
+		xfs_ag_mark_sick(pag, XFS_SICK_AG_AGFL);
 	if (error)
 		return error;
 	xfs_buf_set_ref(bp, XFS_AGFL_REF);
@@ -775,6 +778,7 @@ xfs_alloc_update_counters(
 	if (unlikely(be32_to_cpu(agf->agf_freeblks) >
 		     be32_to_cpu(agf->agf_length))) {
 		xfs_buf_mark_corrupt(agbp);
+		xfs_ag_mark_sick(agbp->b_pag, XFS_SICK_AG_AGF);
 		return -EFSCORRUPTED;
 	}
 
@@ -3106,6 +3110,8 @@ xfs_read_agf(
 	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp,
 			XFS_AG_DADDR(mp, pag->pag_agno, XFS_AGF_DADDR(mp)),
 			XFS_FSS_TO_BB(mp, 1), flags, agfbpp, &xfs_agf_buf_ops);
+	if (xfs_metadata_is_sick(error))
+		xfs_ag_mark_sick(pag, XFS_SICK_AG_AGF);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/libxfs/xfs_health.h b/fs/xfs/libxfs/xfs_health.h
index aa4771fad505..5a4995391ae7 100644
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
@@ -125,6 +127,8 @@ void xfs_rt_mark_healthy(struct xfs_mount *mp, unsigned int mask);
 void xfs_rt_measure_sickness(struct xfs_mount *mp, unsigned int *sick,
 		unsigned int *checked);
 
+void xfs_agno_mark_sick(struct xfs_mount *mp, xfs_agnumber_t agno,
+		unsigned int mask);
 void xfs_ag_mark_sick(struct xfs_perag *pag, unsigned int mask);
 void xfs_ag_mark_checked(struct xfs_perag *pag, unsigned int mask);
 void xfs_ag_mark_healthy(struct xfs_perag *pag, unsigned int mask);
@@ -205,4 +209,7 @@ void xfs_fsop_geom_health(struct xfs_mount *mp, struct xfs_fsop_geom *geo);
 void xfs_ag_geom_health(struct xfs_perag *pag, struct xfs_ag_geometry *ageo);
 void xfs_bulkstat_health(struct xfs_inode *ip, struct xfs_bulkstat *bs);
 
+#define xfs_metadata_is_sick(error) \
+	(unlikely((error) == -EFSCORRUPTED || (error) == -EFSBADCRC))
+
 #endif	/* __XFS_HEALTH_H__ */
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 98961914dc01..0f5a4a591775 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -27,6 +27,7 @@
 #include "xfs_log.h"
 #include "xfs_rmap.h"
 #include "xfs_ag.h"
+#include "xfs_health.h"
 
 /*
  * Lookup a record by ino in the btree given by cur.
@@ -2622,6 +2623,8 @@ xfs_read_agi(
 	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp,
 			XFS_AG_DADDR(mp, pag->pag_agno, XFS_AGI_DADDR(mp)),
 			XFS_FSS_TO_BB(mp, 1), 0, agibpp, &xfs_agi_buf_ops);
+	if (xfs_metadata_is_sick(error))
+		xfs_ag_mark_sick(pag, XFS_SICK_AG_AGI);
 	if (error)
 		return error;
 	if (tp)
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 1eeecf2eb2a7..b3e8ab247b28 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -1229,6 +1229,8 @@ xfs_sb_read_secondary(
 	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp,
 			XFS_AG_DADDR(mp, agno, XFS_SB_BLOCK(mp)),
 			XFS_FSS_TO_BB(mp, 1), 0, &bp, &xfs_sb_buf_ops);
+	if (xfs_metadata_is_sick(error))
+		xfs_agno_mark_sick(mp, agno, XFS_SICK_AG_SB);
 	if (error)
 		return error;
 	xfs_buf_set_ref(bp, XFS_SSB_REF);
diff --git a/fs/xfs/xfs_health.c b/fs/xfs/xfs_health.c
index 3ef91601bc2b..ec987aebb042 100644
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
index d6eeb59217b4..c238f43bd773 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -37,6 +37,7 @@
 #include "xfs_reflink.h"
 #include "xfs_ag.h"
 #include "xfs_log_priv.h"
+#include "xfs_health.h"
 
 struct kmem_cache *xfs_inode_cache;
 
@@ -799,6 +800,8 @@ xfs_init_new_inode(
 	 */
 	if ((pip && ino == pip->i_ino) || !xfs_verify_dir_ino(mp, ino)) {
 		xfs_alert(mp, "Allocated a known in-use inode 0x%llx!", ino);
+		xfs_agno_mark_sick(mp, XFS_INO_TO_AGNO(mp, ino),
+				XFS_SICK_AG_INOBT);
 		return -EFSCORRUPTED;
 	}
 
@@ -1965,8 +1968,11 @@ xfs_iunlink_update_backref(
 		return 0;
 
 	ip = xfs_iunlink_lookup(pag, next_agino);
-	if (!ip)
+	if (!ip) {
+		xfs_ag_mark_sick(pag, XFS_SICK_AG_AGI);
 		return -EFSCORRUPTED;
+	}
+
 	ip->i_prev_unlinked = prev_agino;
 	return 0;
 }
@@ -2000,6 +2006,7 @@ xfs_iunlink_update_bucket(
 	 */
 	if (old_value == new_agino) {
 		xfs_buf_mark_corrupt(agibp);
+		xfs_ag_mark_sick(pag, XFS_SICK_AG_AGI);
 		return -EFSCORRUPTED;
 	}
 
@@ -2033,6 +2040,7 @@ xfs_iunlink_insert_inode(
 	if (next_agino == agino ||
 	    !xfs_verify_agino_or_null(pag, next_agino)) {
 		xfs_buf_mark_corrupt(agibp);
+		xfs_ag_mark_sick(pag, XFS_SICK_AG_AGI);
 		return -EFSCORRUPTED;
 	}
 
@@ -2117,6 +2125,7 @@ xfs_iunlink_remove_inode(
 	if (!xfs_verify_agino(pag, head_agino)) {
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
 				agi, sizeof(*agi));
+		xfs_ag_mark_sick(pag, XFS_SICK_AG_AGI);
 		return -EFSCORRUPTED;
 	}
 
@@ -2142,8 +2151,10 @@ xfs_iunlink_remove_inode(
 		struct xfs_inode	*prev_ip;
 
 		prev_ip = xfs_iunlink_lookup(pag, ip->i_prev_unlinked);
-		if (!prev_ip)
+		if (!prev_ip) {
+			xfs_inode_mark_sick(ip, XFS_SICK_INO_CORE);
 			return -EFSCORRUPTED;
+		}
 
 		error = xfs_iunlink_log_inode(tp, prev_ip, pag,
 				ip->i_next_unlinked);

