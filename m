Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4DB0C433EF
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Dec 2021 00:01:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377734AbhLCAE7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 2 Dec 2021 19:04:59 -0500
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:58186 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1377741AbhLCAEz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Dec 2021 19:04:55 -0500
Received: from dread.disaster.area (pa49-195-103-97.pa.nsw.optusnet.com.au [49.195.103.97])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id 78644606C62
        for <linux-xfs@vger.kernel.org>; Fri,  3 Dec 2021 11:01:23 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1msw0o-00G1Jv-7d
        for linux-xfs@vger.kernel.org; Fri, 03 Dec 2021 11:01:14 +1100
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1msw0o-00BkgI-6P
        for linux-xfs@vger.kernel.org;
        Fri, 03 Dec 2021 11:01:14 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 01/36] xfs: make last AG grow/shrink perag centric
Date:   Fri,  3 Dec 2021 11:00:36 +1100
Message-Id: <20211203000111.2800982-2-david@fromorbit.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211203000111.2800982-1-david@fromorbit.com>
References: <20211203000111.2800982-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=61a95e53
        a=fP9RlOTWD4uZJjPSFnn6Ew==:117 a=fP9RlOTWD4uZJjPSFnn6Ew==:17
        a=IOMw9HtfNCkA:10 a=20KFwNOVAAAA:8 a=rNnZobXno7lJzOInF4AA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Because the perag must exist for these operations, look it up as
part of the common shrink operations and pass it instead of the
mount/agno pair.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_ag.c | 48 ++++++++++++++++--------------------------
 fs/xfs/libxfs/xfs_ag.h | 11 +++++-----
 fs/xfs/xfs_fsops.c     | 11 ++++++----
 fs/xfs/xfs_ioctl.c     |  8 ++++++-
 4 files changed, 37 insertions(+), 41 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index 1e4ee042d52f..84f8b0f12b50 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -762,11 +762,11 @@ xfs_ag_init_headers(
 
 int
 xfs_ag_shrink_space(
-	struct xfs_mount	*mp,
+	struct xfs_perag	*pag,
 	struct xfs_trans	**tpp,
-	xfs_agnumber_t		agno,
 	xfs_extlen_t		delta)
 {
+	struct xfs_mount	*mp = pag->pag_mount;
 	struct xfs_alloc_arg	args = {
 		.tp	= *tpp,
 		.mp	= mp,
@@ -783,14 +783,14 @@ xfs_ag_shrink_space(
 	xfs_agblock_t		aglen;
 	int			error, err2;
 
-	ASSERT(agno == mp->m_sb.sb_agcount - 1);
-	error = xfs_ialloc_read_agi(mp, *tpp, agno, &agibp);
+	ASSERT(pag->pag_agno == mp->m_sb.sb_agcount - 1);
+	error = xfs_ialloc_read_agi(mp, *tpp, pag->pag_agno, &agibp);
 	if (error)
 		return error;
 
 	agi = agibp->b_addr;
 
-	error = xfs_alloc_read_agf(mp, *tpp, agno, 0, &agfbp);
+	error = xfs_alloc_read_agf(mp, *tpp, pag->pag_agno, 0, &agfbp);
 	if (error)
 		return error;
 
@@ -802,13 +802,13 @@ xfs_ag_shrink_space(
 	if (delta >= aglen)
 		return -EINVAL;
 
-	args.fsbno = XFS_AGB_TO_FSB(mp, agno, aglen - delta);
+	args.fsbno = XFS_AGB_TO_FSB(mp, pag->pag_agno, aglen - delta);
 
 	/*
 	 * Make sure that the last inode cluster cannot overlap with the new
 	 * end of the AG, even if it's sparse.
 	 */
-	error = xfs_ialloc_check_shrink(*tpp, agno, agibp, aglen - delta);
+	error = xfs_ialloc_check_shrink(*tpp, pag->pag_agno, agibp, aglen - delta);
 	if (error)
 		return error;
 
@@ -884,9 +884,8 @@ xfs_ag_shrink_space(
  */
 int
 xfs_ag_extend_space(
-	struct xfs_mount	*mp,
+	struct xfs_perag	*pag,
 	struct xfs_trans	*tp,
-	struct aghdr_init_data	*id,
 	xfs_extlen_t		len)
 {
 	struct xfs_buf		*bp;
@@ -894,23 +893,20 @@ xfs_ag_extend_space(
 	struct xfs_agf		*agf;
 	int			error;
 
-	/*
-	 * Change the agi length.
-	 */
-	error = xfs_ialloc_read_agi(mp, tp, id->agno, &bp);
+	ASSERT(pag->pag_agno == pag->pag_mount->m_sb.sb_agcount - 1);
+
+	error = xfs_ialloc_read_agi(pag->pag_mount, tp, pag->pag_agno, &bp);
 	if (error)
 		return error;
 
 	agi = bp->b_addr;
 	be32_add_cpu(&agi->agi_length, len);
-	ASSERT(id->agno == mp->m_sb.sb_agcount - 1 ||
-	       be32_to_cpu(agi->agi_length) == mp->m_sb.sb_agblocks);
 	xfs_ialloc_log_agi(tp, bp, XFS_AGI_LENGTH);
 
 	/*
 	 * Change agf length.
 	 */
-	error = xfs_alloc_read_agf(mp, tp, id->agno, 0, &bp);
+	error = xfs_alloc_read_agf(pag->pag_mount, tp, pag->pag_agno, 0, &bp);
 	if (error)
 		return error;
 
@@ -925,13 +921,12 @@ xfs_ag_extend_space(
 	 * XFS_RMAP_OINFO_SKIP_UPDATE is used here to tell the rmap btree that
 	 * this doesn't actually exist in the rmap btree.
 	 */
-	error = xfs_rmap_free(tp, bp, bp->b_pag,
-				be32_to_cpu(agf->agf_length) - len,
+	error = xfs_rmap_free(tp, bp, pag, be32_to_cpu(agf->agf_length) - len,
 				len, &XFS_RMAP_OINFO_SKIP_UPDATE);
 	if (error)
 		return error;
 
-	return  xfs_free_extent(tp, XFS_AGB_TO_FSB(mp, id->agno,
+	return  xfs_free_extent(tp, XFS_AGB_TO_FSB(pag->pag_mount, pag->pag_agno,
 					be32_to_cpu(agf->agf_length) - len),
 				len, &XFS_RMAP_OINFO_SKIP_UPDATE,
 				XFS_AG_RESV_NONE);
@@ -940,34 +935,27 @@ xfs_ag_extend_space(
 /* Retrieve AG geometry. */
 int
 xfs_ag_get_geometry(
-	struct xfs_mount	*mp,
-	xfs_agnumber_t		agno,
+	struct xfs_perag	*pag,
 	struct xfs_ag_geometry	*ageo)
 {
 	struct xfs_buf		*agi_bp;
 	struct xfs_buf		*agf_bp;
 	struct xfs_agi		*agi;
 	struct xfs_agf		*agf;
-	struct xfs_perag	*pag;
 	unsigned int		freeblks;
 	int			error;
 
-	if (agno >= mp->m_sb.sb_agcount)
-		return -EINVAL;
-
 	/* Lock the AG headers. */
-	error = xfs_ialloc_read_agi(mp, NULL, agno, &agi_bp);
+	error = xfs_ialloc_read_agi(pag->pag_mount, NULL, pag->pag_agno, &agi_bp);
 	if (error)
 		return error;
-	error = xfs_alloc_read_agf(mp, NULL, agno, 0, &agf_bp);
+	error = xfs_alloc_read_agf(pag->pag_mount, NULL, pag->pag_agno, 0, &agf_bp);
 	if (error)
 		goto out_agi;
 
-	pag = agi_bp->b_pag;
-
 	/* Fill out form. */
 	memset(ageo, 0, sizeof(*ageo));
-	ageo->ag_number = agno;
+	ageo->ag_number = pag->pag_agno;
 
 	agi = agi_bp->b_addr;
 	ageo->ag_icount = be32_to_cpu(agi->agi_count);
diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
index e411d51c2589..1132cda9a92f 100644
--- a/fs/xfs/libxfs/xfs_ag.h
+++ b/fs/xfs/libxfs/xfs_ag.h
@@ -168,11 +168,10 @@ struct aghdr_init_data {
 };
 
 int xfs_ag_init_headers(struct xfs_mount *mp, struct aghdr_init_data *id);
-int xfs_ag_shrink_space(struct xfs_mount *mp, struct xfs_trans **tpp,
-			xfs_agnumber_t agno, xfs_extlen_t delta);
-int xfs_ag_extend_space(struct xfs_mount *mp, struct xfs_trans *tp,
-			struct aghdr_init_data *id, xfs_extlen_t len);
-int xfs_ag_get_geometry(struct xfs_mount *mp, xfs_agnumber_t agno,
-			struct xfs_ag_geometry *ageo);
+int xfs_ag_shrink_space(struct xfs_perag *pag, struct xfs_trans **tpp,
+			xfs_extlen_t delta);
+int xfs_ag_extend_space(struct xfs_perag *pag, struct xfs_trans *tp,
+			xfs_extlen_t len);
+int xfs_ag_get_geometry(struct xfs_perag *pag, struct xfs_ag_geometry *ageo);
 
 #endif /* __LIBXFS_AG_H */
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 33e26690a8c4..7a209fd9eec7 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -40,6 +40,7 @@ xfs_resizefs_init_new_ags(
 	xfs_agnumber_t		oagcount,
 	xfs_agnumber_t		nagcount,
 	xfs_rfsblock_t		delta,
+	struct xfs_perag	*last_pag,
 	bool			*lastag_extended)
 {
 	struct xfs_mount	*mp = tp->t_mountp;
@@ -72,7 +73,7 @@ xfs_resizefs_init_new_ags(
 
 	if (delta) {
 		*lastag_extended = true;
-		error = xfs_ag_extend_space(mp, tp, id, delta);
+		error = xfs_ag_extend_space(last_pag, tp, delta);
 	}
 	return error;
 }
@@ -95,6 +96,7 @@ xfs_growfs_data_private(
 	xfs_agnumber_t		oagcount;
 	struct xfs_trans	*tp;
 	struct aghdr_init_data	id = {};
+	struct xfs_perag	*last_pag;
 
 	nb = in->newblocks;
 	error = xfs_sb_validate_fsb_count(&mp->m_sb, nb);
@@ -127,7 +129,6 @@ xfs_growfs_data_private(
 		return -EINVAL;
 
 	oagcount = mp->m_sb.sb_agcount;
-
 	/* allocate the new per-ag structures */
 	if (nagcount > oagcount) {
 		error = xfs_initialize_perag(mp, nagcount, &nagimax);
@@ -144,9 +145,10 @@ xfs_growfs_data_private(
 	if (error)
 		return error;
 
+	last_pag = xfs_perag_get(mp, oagcount - 1);
 	if (delta > 0) {
 		error = xfs_resizefs_init_new_ags(tp, &id, oagcount, nagcount,
-						  delta, &lastag_extended);
+				delta, last_pag, &lastag_extended);
 	} else {
 		static struct ratelimit_state shrink_warning = \
 			RATELIMIT_STATE_INIT("shrink_warning", 86400 * HZ, 1);
@@ -156,8 +158,9 @@ xfs_growfs_data_private(
 			xfs_alert(mp,
 	"EXPERIMENTAL online shrink feature in use. Use at your own risk!");
 
-		error = xfs_ag_shrink_space(mp, &tp, nagcount - 1, -delta);
+		error = xfs_ag_shrink_space(last_pag, &tp, -delta);
 	}
+	xfs_perag_put(last_pag);
 	if (error)
 		goto out_trans_cancel;
 
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 174cd8950cb6..5af4da0e6621 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1031,6 +1031,7 @@ xfs_ioc_ag_geometry(
 	struct xfs_mount	*mp,
 	void			__user *arg)
 {
+	struct xfs_perag	*pag;
 	struct xfs_ag_geometry	ageo;
 	int			error;
 
@@ -1041,7 +1042,12 @@ xfs_ioc_ag_geometry(
 	if (memchr_inv(&ageo.ag_reserved, 0, sizeof(ageo.ag_reserved)))
 		return -EINVAL;
 
-	error = xfs_ag_get_geometry(mp, ageo.ag_number, &ageo);
+	pag = xfs_perag_get(mp, ageo.ag_number);
+	if (!pag)
+		return -EINVAL;
+
+	error = xfs_ag_get_geometry(pag, &ageo);
+	xfs_perag_put(pag);
 	if (error)
 		return error;
 
-- 
2.33.0

