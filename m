Return-Path: <SRS0=xiMZ=IF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 896FBC433DB
	for <linux-xfs@archiver.kernel.org>; Sun,  7 Mar 2021 20:37:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2BCB865166
	for <linux-xfs@archiver.kernel.org>; Sun,  7 Mar 2021 20:37:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232894AbhCGUgw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 7 Mar 2021 15:36:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:54046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231732AbhCGUgj (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 7 Mar 2021 15:36:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 36E4C65165;
        Sun,  7 Mar 2021 20:36:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615149399;
        bh=+FjKFSIHie783ImBTkqzC50V34MSJ6naN+ptDEI1L+Q=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=mURJAuAe3JHXc2vaz9MY22RwVkQS9FWXeSWlHhlcNhvO5IEX/6zb6EfXbEZLPx3OY
         hTBRaJJrEzVpRhVrefj/0TWvbIzJkq0bRwLNTRx2CzTmeS2yAgyVTjzjWaapMYvbW8
         vCovz+X+jeluIaBemmBGN0uEpDiEc6tT81N78lWciJHwG+2XpOBCLF1GrQ1bOGjDrh
         VdsXZR3sr01hnHktGIwVB+HgiTzlAOXfD+Cj2fEFhQwb7QvHTgVIiSoT+tlBpX6aHm
         2Gl2OehcF58lCxbGk6J2r+AqYphxs4N7txn5aY+/aF+iHx2An0kbFC3zHu+VaZnYx5
         s47/AUFniwovg==
Date:   Sun, 7 Mar 2021 12:36:38 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     linux-xfs@vger.kernel.org, hch@lst.de, dchinner@redhat.com,
        christian.brauner@ubuntu.com
Subject: [PATCH v2.1 2/4] xfs: avoid buffer deadlocks when walking fs inodes
Message-ID: <20210307203638.GJ3419940@magnolia>
References: <161514874040.698643.2749449122589431232.stgit@magnolia>
 <161514875165.698643.17020544838073213424.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161514875165.698643.17020544838073213424.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

When we're servicing an INUMBERS or BULKSTAT request or running
quotacheck, grab an empty transaction so that we can use its inherent
recursive buffer locking abilities to detect inode btree cycles without
hitting ABBA buffer deadlocks.

Found by fuzzing an inode btree pointer to introduce a cycle into the
tree (xfs/365).

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
v2.1: actually pass tp in the bulkstat_single case
---
 fs/xfs/xfs_itable.c |   42 +++++++++++++++++++++++++++++++++++++-----
 fs/xfs/xfs_iwalk.c  |   32 +++++++++++++++++++++++++++-----
 2 files changed, 64 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index ca310a125d1e..326495c8910e 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -19,6 +19,7 @@
 #include "xfs_error.h"
 #include "xfs_icache.h"
 #include "xfs_health.h"
+#include "xfs_trans.h"
 
 /*
  * Bulk Stat
@@ -166,6 +167,7 @@ xfs_bulkstat_one(
 		.formatter	= formatter,
 		.breq		= breq,
 	};
+	struct xfs_trans	*tp;
 	int			error;
 
 	ASSERT(breq->icount == 1);
@@ -175,9 +177,18 @@ xfs_bulkstat_one(
 	if (!bc.buf)
 		return -ENOMEM;
 
-	error = xfs_bulkstat_one_int(breq->mp, breq->mnt_userns, NULL,
-				     breq->startino, &bc);
+	/*
+	 * Grab an empty transaction so that we can use its recursive buffer
+	 * locking abilities to detect cycles in the inobt without deadlocking.
+	 */
+	error = xfs_trans_alloc_empty(breq->mp, &tp);
+	if (error)
+		goto out;
 
+	error = xfs_bulkstat_one_int(breq->mp, breq->mnt_userns, tp,
+			breq->startino, &bc);
+	xfs_trans_cancel(tp);
+out:
 	kmem_free(bc.buf);
 
 	/*
@@ -241,6 +252,7 @@ xfs_bulkstat(
 		.formatter	= formatter,
 		.breq		= breq,
 	};
+	struct xfs_trans	*tp;
 	int			error;
 
 	if (breq->mnt_userns != &init_user_ns) {
@@ -256,9 +268,18 @@ xfs_bulkstat(
 	if (!bc.buf)
 		return -ENOMEM;
 
-	error = xfs_iwalk(breq->mp, NULL, breq->startino, breq->flags,
+	/*
+	 * Grab an empty transaction so that we can use its recursive buffer
+	 * locking abilities to detect cycles in the inobt without deadlocking.
+	 */
+	error = xfs_trans_alloc_empty(breq->mp, &tp);
+	if (error)
+		goto out;
+
+	error = xfs_iwalk(breq->mp, tp, breq->startino, breq->flags,
 			xfs_bulkstat_iwalk, breq->icount, &bc);
-
+	xfs_trans_cancel(tp);
+out:
 	kmem_free(bc.buf);
 
 	/*
@@ -371,13 +392,24 @@ xfs_inumbers(
 		.formatter	= formatter,
 		.breq		= breq,
 	};
+	struct xfs_trans	*tp;
 	int			error = 0;
 
 	if (xfs_bulkstat_already_done(breq->mp, breq->startino))
 		return 0;
 
-	error = xfs_inobt_walk(breq->mp, NULL, breq->startino, breq->flags,
+	/*
+	 * Grab an empty transaction so that we can use its recursive buffer
+	 * locking abilities to detect cycles in the inobt without deadlocking.
+	 */
+	error = xfs_trans_alloc_empty(breq->mp, &tp);
+	if (error)
+		goto out;
+
+	error = xfs_inobt_walk(breq->mp, tp, breq->startino, breq->flags,
 			xfs_inumbers_walk, breq->icount, &ic);
+	xfs_trans_cancel(tp);
+out:
 
 	/*
 	 * We found some inode groups, so clear the error status and return
diff --git a/fs/xfs/xfs_iwalk.c b/fs/xfs/xfs_iwalk.c
index c4a340f1f1e1..e1e889f3647f 100644
--- a/fs/xfs/xfs_iwalk.c
+++ b/fs/xfs/xfs_iwalk.c
@@ -81,6 +81,9 @@ struct xfs_iwalk_ag {
 
 	/* Skip empty inobt records? */
 	unsigned int			skip_empty:1;
+
+	/* Drop the (hopefully empty) transaction when calling iwalk_fn. */
+	unsigned int			drop_trans:1;
 };
 
 /*
@@ -351,7 +354,6 @@ xfs_iwalk_run_callbacks(
 	int				*has_more)
 {
 	struct xfs_mount		*mp = iwag->mp;
-	struct xfs_trans		*tp = iwag->tp;
 	struct xfs_inobt_rec_incore	*irec;
 	xfs_agino_t			next_agino;
 	int				error;
@@ -361,10 +363,15 @@ xfs_iwalk_run_callbacks(
 	ASSERT(iwag->nr_recs > 0);
 
 	/* Delete cursor but remember the last record we cached... */
-	xfs_iwalk_del_inobt(tp, curpp, agi_bpp, 0);
+	xfs_iwalk_del_inobt(iwag->tp, curpp, agi_bpp, 0);
 	irec = &iwag->recs[iwag->nr_recs - 1];
 	ASSERT(next_agino >= irec->ir_startino + XFS_INODES_PER_CHUNK);
 
+	if (iwag->drop_trans) {
+		xfs_trans_cancel(iwag->tp);
+		iwag->tp = NULL;
+	}
+
 	error = xfs_iwalk_ag_recs(iwag);
 	if (error)
 		return error;
@@ -375,8 +382,14 @@ xfs_iwalk_run_callbacks(
 	if (!has_more)
 		return 0;
 
+	if (iwag->drop_trans) {
+		error = xfs_trans_alloc_empty(mp, &iwag->tp);
+		if (error)
+			return error;
+	}
+
 	/* ...and recreate the cursor just past where we left off. */
-	error = xfs_inobt_cur(mp, tp, agno, XFS_BTNUM_INO, curpp, agi_bpp);
+	error = xfs_inobt_cur(mp, iwag->tp, agno, XFS_BTNUM_INO, curpp, agi_bpp);
 	if (error)
 		return error;
 
@@ -389,7 +402,6 @@ xfs_iwalk_ag(
 	struct xfs_iwalk_ag		*iwag)
 {
 	struct xfs_mount		*mp = iwag->mp;
-	struct xfs_trans		*tp = iwag->tp;
 	struct xfs_buf			*agi_bp = NULL;
 	struct xfs_btree_cur		*cur = NULL;
 	xfs_agnumber_t			agno;
@@ -469,7 +481,7 @@ xfs_iwalk_ag(
 	error = xfs_iwalk_run_callbacks(iwag, agno, &cur, &agi_bp, &has_more);
 
 out:
-	xfs_iwalk_del_inobt(tp, &cur, &agi_bp, error);
+	xfs_iwalk_del_inobt(iwag->tp, &cur, &agi_bp, error);
 	return error;
 }
 
@@ -594,8 +606,18 @@ xfs_iwalk_ag_work(
 	error = xfs_iwalk_alloc(iwag);
 	if (error)
 		goto out;
+	/*
+	 * Grab an empty transaction so that we can use its recursive buffer
+	 * locking abilities to detect cycles in the inobt without deadlocking.
+	 */
+	error = xfs_trans_alloc_empty(mp, &iwag->tp);
+	if (error)
+		goto out;
+	iwag->drop_trans = 1;
 
 	error = xfs_iwalk_ag(iwag);
+	if (iwag->tp)
+		xfs_trans_cancel(iwag->tp);
 	xfs_iwalk_free(iwag);
 out:
 	kmem_free(iwag);
