Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95744C4338F
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Jul 2021 18:45:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8244160F6F
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Jul 2021 18:45:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbhG2Sps (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Jul 2021 14:45:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:49670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231829AbhG2Spr (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 29 Jul 2021 14:45:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0B28D60249;
        Thu, 29 Jul 2021 18:45:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627584344;
        bh=1dux238x4nCpTc/Ks1zNtPWbwcksk/ApfN3YPgywvcA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=SWvbDoQeUGdZHwnH+rS2MFZBeQYHn/E10xWvU7oZypI6qMNnemRnwroPgBzDSlxDf
         lyqAj0YTeA5h1532BcVHklKYBluwscyVbK+iMJ4zU9h7OK+UueywdPbYj6VMcwIx6+
         SJBs3BlRWWAXpFbdr6IOGaWE6YIbY8c0L177qEDBTVgp1f8A+nKW5zvjl6b5yCjQJq
         GlPkwwVgaN7uGtUv132diyQg+459bNu26FDT2bQVh/DvuGRCKUrMQDGSgFex5xBcyT
         cL2cgA4TyV2dvueTgoiq21WU/bYxPHcEOUZIspm1KrpkWQZRttM5uR8kXUctiHu8Y8
         k3EZDbZGDCZrQ==
Subject: [PATCH 20/20] xfs: avoid buffer deadlocks when walking fs inodes
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, Christoph Hellwig <hch@lst.de>,
        linux-xfs@vger.kernel.org, david@fromorbit.com, hch@infradead.org
Date:   Thu, 29 Jul 2021 11:45:43 -0700
Message-ID: <162758434375.332903.11129823670282322016.stgit@magnolia>
In-Reply-To: <162758423315.332903.16799817941903734904.stgit@magnolia>
References: <162758423315.332903.16799817941903734904.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

When we're servicing an INUMBERS or BULKSTAT request or running
quotacheck, grab an empty transaction so that we can use its inherent
recursive buffer locking abilities to detect inode btree cycles without
hitting ABBA buffer deadlocks.  This patch requires the deferred inode
inactivation patchset because xfs_irele cannot directly call
xfs_inactive when the iwalk itself has an (empty) transaction.

Found by fuzzing an inode btree pointer to introduce a cycle into the
tree (xfs/365).

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_itable.c |   42 +++++++++++++++++++++++++++++++++++++-----
 fs/xfs/xfs_iwalk.c  |   33 ++++++++++++++++++++++++++++-----
 2 files changed, 65 insertions(+), 10 deletions(-)


diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index f331975a16de..84c17a9f9869 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -19,6 +19,7 @@
 #include "xfs_error.h"
 #include "xfs_icache.h"
 #include "xfs_health.h"
+#include "xfs_trans.h"
 
 /*
  * Bulk Stat
@@ -163,6 +164,7 @@ xfs_bulkstat_one(
 		.formatter	= formatter,
 		.breq		= breq,
 	};
+	struct xfs_trans	*tp;
 	int			error;
 
 	if (breq->mnt_userns != &init_user_ns) {
@@ -178,9 +180,18 @@ xfs_bulkstat_one(
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
@@ -244,6 +255,7 @@ xfs_bulkstat(
 		.formatter	= formatter,
 		.breq		= breq,
 	};
+	struct xfs_trans	*tp;
 	int			error;
 
 	if (breq->mnt_userns != &init_user_ns) {
@@ -259,9 +271,18 @@ xfs_bulkstat(
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
@@ -374,13 +395,24 @@ xfs_inumbers(
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
index 917d51eefee3..7558486f4937 100644
--- a/fs/xfs/xfs_iwalk.c
+++ b/fs/xfs/xfs_iwalk.c
@@ -83,6 +83,9 @@ struct xfs_iwalk_ag {
 
 	/* Skip empty inobt records? */
 	unsigned int			skip_empty:1;
+
+	/* Drop the (hopefully empty) transaction when calling iwalk_fn. */
+	unsigned int			drop_trans:1;
 };
 
 /*
@@ -352,7 +355,6 @@ xfs_iwalk_run_callbacks(
 	int				*has_more)
 {
 	struct xfs_mount		*mp = iwag->mp;
-	struct xfs_trans		*tp = iwag->tp;
 	struct xfs_inobt_rec_incore	*irec;
 	xfs_agino_t			next_agino;
 	int				error;
@@ -362,10 +364,15 @@ xfs_iwalk_run_callbacks(
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
@@ -376,8 +383,15 @@ xfs_iwalk_run_callbacks(
 	if (!has_more)
 		return 0;
 
+	if (iwag->drop_trans) {
+		error = xfs_trans_alloc_empty(mp, &iwag->tp);
+		if (error)
+			return error;
+	}
+
 	/* ...and recreate the cursor just past where we left off. */
-	error = xfs_inobt_cur(mp, tp, iwag->pag, XFS_BTNUM_INO, curpp, agi_bpp);
+	error = xfs_inobt_cur(mp, iwag->tp, iwag->pag, XFS_BTNUM_INO, curpp,
+			agi_bpp);
 	if (error)
 		return error;
 
@@ -390,7 +404,6 @@ xfs_iwalk_ag(
 	struct xfs_iwalk_ag		*iwag)
 {
 	struct xfs_mount		*mp = iwag->mp;
-	struct xfs_trans		*tp = iwag->tp;
 	struct xfs_perag		*pag = iwag->pag;
 	struct xfs_buf			*agi_bp = NULL;
 	struct xfs_btree_cur		*cur = NULL;
@@ -469,7 +482,7 @@ xfs_iwalk_ag(
 	error = xfs_iwalk_run_callbacks(iwag, &cur, &agi_bp, &has_more);
 
 out:
-	xfs_iwalk_del_inobt(tp, &cur, &agi_bp, error);
+	xfs_iwalk_del_inobt(iwag->tp, &cur, &agi_bp, error);
 	return error;
 }
 
@@ -599,8 +612,18 @@ xfs_iwalk_ag_work(
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
 	xfs_perag_put(iwag->pag);

