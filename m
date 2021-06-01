Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 518B3C47080
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Jun 2021 22:00:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2C28760FDC
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Jun 2021 22:00:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234698AbhFAWCk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Jun 2021 18:02:40 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:56304 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234671AbhFAWCi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Jun 2021 18:02:38 -0400
Received: from dread.disaster.area (pa49-179-138-183.pa.nsw.optusnet.com.au [49.179.138.183])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 6E4E41044B8A;
        Wed,  2 Jun 2021 08:00:55 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1loCRS-007rwN-2x; Wed, 02 Jun 2021 08:00:54 +1000
Date:   Wed, 2 Jun 2021 08:00:54 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH 06/23 V2] xfs: convert xfs_iwalk to use perag references
Message-ID: <20210601220054.GE664593@dread.disaster.area>
References: <20210519012102.450926-1-david@fromorbit.com>
 <20210519012102.450926-7-david@fromorbit.com>
 <20210527221648.GV2402049@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210527221648.GV2402049@locust>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0
        a=MnllW2CieawZLw/OcHE/Ng==:117 a=MnllW2CieawZLw/OcHE/Ng==:17
        a=kj9zAlcOel0A:10 a=r6YtysWOX24A:10 a=20KFwNOVAAAA:8
        a=f-OPZxvAVtpVvDWjN68A:9 a=CjuIK1q_8ugA:10
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Rather than manually walking the ags and passing agnunbers around,
pass the perag for the AG we are currently working on around in the
iwalk structure.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
V2: convert next_agno -> agno in perag walk macros

 fs/xfs/libxfs/xfs_ag.h | 20 +++++++-----
 fs/xfs/xfs_iwalk.c     | 86 +++++++++++++++++++++++++++++++-------------------
 2 files changed, 66 insertions(+), 40 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
index 33783120263c..2e02ec3693c5 100644
--- a/fs/xfs/libxfs/xfs_ag.h
+++ b/fs/xfs/libxfs/xfs_ag.h
@@ -117,19 +117,23 @@ void	xfs_perag_put(struct xfs_perag *pag);
 /*
  * Perag iteration APIs
  */
-#define for_each_perag(mp, next_agno, pag) \
-	for ((next_agno) = 0, (pag) = xfs_perag_get((mp), 0); \
+#define for_each_perag_from(mp, agno, pag) \
+	for ((pag) = xfs_perag_get((mp), (agno)); \
 		(pag) != NULL; \
-		(next_agno) = (pag)->pag_agno + 1, \
+		(agno) = (pag)->pag_agno + 1, \
 		xfs_perag_put(pag), \
-		(pag) = xfs_perag_get((mp), (next_agno)))
+		(pag) = xfs_perag_get((mp), (agno)))
 
-#define for_each_perag_tag(mp, next_agno, pag, tag) \
-	for ((next_agno) = 0, (pag) = xfs_perag_get_tag((mp), 0, (tag)); \
+#define for_each_perag(mp, agno, pag) \
+	(agno) = 0; \
+	for_each_perag_from((mp), (agno), (pag))
+
+#define for_each_perag_tag(mp, agno, pag, tag) \
+	for ((agno) = 0, (pag) = xfs_perag_get_tag((mp), 0, (tag)); \
 		(pag) != NULL; \
-		(next_agno) = (pag)->pag_agno + 1, \
+		(agno) = (pag)->pag_agno + 1, \
 		xfs_perag_put(pag), \
-		(pag) = xfs_perag_get_tag((mp), (next_agno), (tag)))
+		(pag) = xfs_perag_get_tag((mp), (agno), (tag)))
 
 struct aghdr_init_data {
 	/* per ag data */
diff --git a/fs/xfs/xfs_iwalk.c b/fs/xfs/xfs_iwalk.c
index c4a340f1f1e1..c7e8f48a3ec4 100644
--- a/fs/xfs/xfs_iwalk.c
+++ b/fs/xfs/xfs_iwalk.c
@@ -21,6 +21,7 @@
 #include "xfs_health.h"
 #include "xfs_trans.h"
 #include "xfs_pwork.h"
+#include "xfs_ag.h"
 
 /*
  * Walking Inodes in the Filesystem
@@ -51,6 +52,7 @@ struct xfs_iwalk_ag {
 
 	struct xfs_mount		*mp;
 	struct xfs_trans		*tp;
+	struct xfs_perag		*pag;
 
 	/* Where do we start the traversal? */
 	xfs_ino_t			startino;
@@ -90,7 +92,7 @@ struct xfs_iwalk_ag {
 STATIC void
 xfs_iwalk_ichunk_ra(
 	struct xfs_mount		*mp,
-	xfs_agnumber_t			agno,
+	struct xfs_perag		*pag,
 	struct xfs_inobt_rec_incore	*irec)
 {
 	struct xfs_ino_geometry		*igeo = M_IGEO(mp);
@@ -106,7 +108,7 @@ xfs_iwalk_ichunk_ra(
 
 		imask = xfs_inobt_maskn(i, igeo->inodes_per_cluster);
 		if (imask & ~irec->ir_free) {
-			xfs_btree_reada_bufs(mp, agno, agbno,
+			xfs_btree_reada_bufs(mp, pag->pag_agno, agbno,
 					igeo->blocks_per_cluster,
 					&xfs_inode_buf_ops);
 		}
@@ -174,26 +176,25 @@ xfs_iwalk_free(
 /* For each inuse inode in each cached inobt record, call our function. */
 STATIC int
 xfs_iwalk_ag_recs(
-	struct xfs_iwalk_ag		*iwag)
+	struct xfs_iwalk_ag	*iwag)
 {
-	struct xfs_mount		*mp = iwag->mp;
-	struct xfs_trans		*tp = iwag->tp;
-	xfs_ino_t			ino;
-	unsigned int			i, j;
-	xfs_agnumber_t			agno;
-	int				error;
+	struct xfs_mount	*mp = iwag->mp;
+	struct xfs_trans	*tp = iwag->tp;
+	struct xfs_perag	*pag = iwag->pag;
+	xfs_ino_t		ino;
+	unsigned int		i, j;
+	int			error;
 
-	agno = XFS_INO_TO_AGNO(mp, iwag->startino);
 	for (i = 0; i < iwag->nr_recs; i++) {
 		struct xfs_inobt_rec_incore	*irec = &iwag->recs[i];
 
-		trace_xfs_iwalk_ag_rec(mp, agno, irec);
+		trace_xfs_iwalk_ag_rec(mp, pag->pag_agno, irec);
 
 		if (xfs_pwork_want_abort(&iwag->pwork))
 			return 0;
 
 		if (iwag->inobt_walk_fn) {
-			error = iwag->inobt_walk_fn(mp, tp, agno, irec,
+			error = iwag->inobt_walk_fn(mp, tp, pag->pag_agno, irec,
 					iwag->data);
 			if (error)
 				return error;
@@ -211,7 +212,8 @@ xfs_iwalk_ag_recs(
 				continue;
 
 			/* Otherwise call our function. */
-			ino = XFS_AGINO_TO_INO(mp, agno, irec->ir_startino + j);
+			ino = XFS_AGINO_TO_INO(mp, pag->pag_agno,
+						irec->ir_startino + j);
 			error = iwag->iwalk_fn(mp, tp, ino, iwag->data);
 			if (error)
 				return error;
@@ -257,7 +259,6 @@ xfs_iwalk_del_inobt(
 STATIC int
 xfs_iwalk_ag_start(
 	struct xfs_iwalk_ag	*iwag,
-	xfs_agnumber_t		agno,
 	xfs_agino_t		agino,
 	struct xfs_btree_cur	**curpp,
 	struct xfs_buf		**agi_bpp,
@@ -265,12 +266,14 @@ xfs_iwalk_ag_start(
 {
 	struct xfs_mount	*mp = iwag->mp;
 	struct xfs_trans	*tp = iwag->tp;
+	struct xfs_perag	*pag = iwag->pag;
 	struct xfs_inobt_rec_incore *irec;
 	int			error;
 
 	/* Set up a fresh cursor and empty the inobt cache. */
 	iwag->nr_recs = 0;
-	error = xfs_inobt_cur(mp, tp, agno, XFS_BTNUM_INO, curpp, agi_bpp);
+	error = xfs_inobt_cur(mp, tp, pag->pag_agno, XFS_BTNUM_INO,
+				curpp, agi_bpp);
 	if (error)
 		return error;
 
@@ -304,7 +307,7 @@ xfs_iwalk_ag_start(
 	if (XFS_IS_CORRUPT(mp, *has_more != 1))
 		return -EFSCORRUPTED;
 
-	iwag->lastino = XFS_AGINO_TO_INO(mp, agno,
+	iwag->lastino = XFS_AGINO_TO_INO(mp, pag->pag_agno,
 				irec->ir_startino + XFS_INODES_PER_CHUNK - 1);
 
 	/*
@@ -345,7 +348,6 @@ xfs_iwalk_ag_start(
 STATIC int
 xfs_iwalk_run_callbacks(
 	struct xfs_iwalk_ag		*iwag,
-	xfs_agnumber_t			agno,
 	struct xfs_btree_cur		**curpp,
 	struct xfs_buf			**agi_bpp,
 	int				*has_more)
@@ -376,7 +378,8 @@ xfs_iwalk_run_callbacks(
 		return 0;
 
 	/* ...and recreate the cursor just past where we left off. */
-	error = xfs_inobt_cur(mp, tp, agno, XFS_BTNUM_INO, curpp, agi_bpp);
+	error = xfs_inobt_cur(mp, tp, iwag->pag->pag_agno, XFS_BTNUM_INO,
+				curpp, agi_bpp);
 	if (error)
 		return error;
 
@@ -390,17 +393,17 @@ xfs_iwalk_ag(
 {
 	struct xfs_mount		*mp = iwag->mp;
 	struct xfs_trans		*tp = iwag->tp;
+	struct xfs_perag		*pag = iwag->pag;
 	struct xfs_buf			*agi_bp = NULL;
 	struct xfs_btree_cur		*cur = NULL;
-	xfs_agnumber_t			agno;
 	xfs_agino_t			agino;
 	int				has_more;
 	int				error = 0;
 
 	/* Set up our cursor at the right place in the inode btree. */
-	agno = XFS_INO_TO_AGNO(mp, iwag->startino);
+	ASSERT(pag->pag_agno == XFS_INO_TO_AGNO(mp, iwag->startino));
 	agino = XFS_INO_TO_AGINO(mp, iwag->startino);
-	error = xfs_iwalk_ag_start(iwag, agno, agino, &cur, &agi_bp, &has_more);
+	error = xfs_iwalk_ag_start(iwag, agino, &cur, &agi_bp, &has_more);
 
 	while (!error && has_more) {
 		struct xfs_inobt_rec_incore	*irec;
@@ -417,7 +420,7 @@ xfs_iwalk_ag(
 			break;
 
 		/* Make sure that we always move forward. */
-		rec_fsino = XFS_AGINO_TO_INO(mp, agno, irec->ir_startino);
+		rec_fsino = XFS_AGINO_TO_INO(mp, pag->pag_agno, irec->ir_startino);
 		if (iwag->lastino != NULLFSINO &&
 		    XFS_IS_CORRUPT(mp, iwag->lastino >= rec_fsino)) {
 			error = -EFSCORRUPTED;
@@ -438,7 +441,7 @@ xfs_iwalk_ag(
 		 * walking the inodes.
 		 */
 		if (iwag->iwalk_fn)
-			xfs_iwalk_ichunk_ra(mp, agno, irec);
+			xfs_iwalk_ichunk_ra(mp, pag, irec);
 
 		/*
 		 * If there's space in the buffer for more records, increment
@@ -458,15 +461,14 @@ xfs_iwalk_ag(
 		 * we would be if we had been able to increment like above.
 		 */
 		ASSERT(has_more);
-		error = xfs_iwalk_run_callbacks(iwag, agno, &cur, &agi_bp,
-				&has_more);
+		error = xfs_iwalk_run_callbacks(iwag, &cur, &agi_bp, &has_more);
 	}
 
 	if (iwag->nr_recs == 0 || error)
 		goto out;
 
 	/* Walk the unprocessed records in the cache. */
-	error = xfs_iwalk_run_callbacks(iwag, agno, &cur, &agi_bp, &has_more);
+	error = xfs_iwalk_run_callbacks(iwag, &cur, &agi_bp, &has_more);
 
 out:
 	xfs_iwalk_del_inobt(tp, &cur, &agi_bp, error);
@@ -555,6 +557,7 @@ xfs_iwalk(
 		.pwork		= XFS_PWORK_SINGLE_THREADED,
 		.lastino	= NULLFSINO,
 	};
+	struct xfs_perag	*pag;
 	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, startino);
 	int			error;
 
@@ -565,15 +568,19 @@ xfs_iwalk(
 	if (error)
 		return error;
 
-	for (; agno < mp->m_sb.sb_agcount; agno++) {
+	for_each_perag_from(mp, agno, pag) {
+		iwag.pag = pag;
 		error = xfs_iwalk_ag(&iwag);
 		if (error)
 			break;
 		iwag.startino = XFS_AGINO_TO_INO(mp, agno + 1, 0);
 		if (flags & XFS_INOBT_WALK_SAME_AG)
 			break;
+		iwag.pag = NULL;
 	}
 
+	if (iwag.pag)
+		xfs_perag_put(pag);
 	xfs_iwalk_free(&iwag);
 	return error;
 }
@@ -598,6 +605,7 @@ xfs_iwalk_ag_work(
 	error = xfs_iwalk_ag(iwag);
 	xfs_iwalk_free(iwag);
 out:
+	xfs_perag_put(iwag->pag);
 	kmem_free(iwag);
 	return error;
 }
@@ -617,6 +625,7 @@ xfs_iwalk_threaded(
 	void			*data)
 {
 	struct xfs_pwork_ctl	pctl;
+	struct xfs_perag	*pag;
 	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, startino);
 	int			error;
 
@@ -627,7 +636,7 @@ xfs_iwalk_threaded(
 	if (error)
 		return error;
 
-	for (; agno < mp->m_sb.sb_agcount; agno++) {
+	for_each_perag_from(mp, agno, pag) {
 		struct xfs_iwalk_ag	*iwag;
 
 		if (xfs_pwork_ctl_want_abort(&pctl))
@@ -635,17 +644,25 @@ xfs_iwalk_threaded(
 
 		iwag = kmem_zalloc(sizeof(struct xfs_iwalk_ag), 0);
 		iwag->mp = mp;
+
+		/*
+		 * perag is being handed off to async work, so take another
+		 * reference for the async work to release.
+		 */
+		atomic_inc(&pag->pag_ref);
+		iwag->pag = pag;
 		iwag->iwalk_fn = iwalk_fn;
 		iwag->data = data;
 		iwag->startino = startino;
 		iwag->sz_recs = xfs_iwalk_prefetch(inode_records);
 		iwag->lastino = NULLFSINO;
 		xfs_pwork_queue(&pctl, &iwag->pwork);
-		startino = XFS_AGINO_TO_INO(mp, agno + 1, 0);
+		startino = XFS_AGINO_TO_INO(mp, pag->pag_agno + 1, 0);
 		if (flags & XFS_INOBT_WALK_SAME_AG)
 			break;
 	}
-
+	if (pag)
+		xfs_perag_put(pag);
 	if (polled)
 		xfs_pwork_poll(&pctl);
 	return xfs_pwork_destroy(&pctl);
@@ -715,6 +732,7 @@ xfs_inobt_walk(
 		.pwork		= XFS_PWORK_SINGLE_THREADED,
 		.lastino	= NULLFSINO,
 	};
+	struct xfs_perag	*pag;
 	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, startino);
 	int			error;
 
@@ -725,15 +743,19 @@ xfs_inobt_walk(
 	if (error)
 		return error;
 
-	for (; agno < mp->m_sb.sb_agcount; agno++) {
+	for_each_perag_from(mp, agno, pag) {
+		iwag.pag = pag;
 		error = xfs_iwalk_ag(&iwag);
 		if (error)
 			break;
-		iwag.startino = XFS_AGINO_TO_INO(mp, agno + 1, 0);
+		iwag.startino = XFS_AGINO_TO_INO(mp, pag->pag_agno + 1, 0);
 		if (flags & XFS_INOBT_WALK_SAME_AG)
 			break;
+		iwag.pag = NULL;
 	}
 
+	if (iwag.pag)
+		xfs_perag_put(pag);
 	xfs_iwalk_free(&iwag);
 	return error;
 }
