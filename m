Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:49708 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388106AbeGWOFY (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 23 Jul 2018 10:05:24 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B70FB4059FF9
        for <linux-xfs@vger.kernel.org>; Mon, 23 Jul 2018 13:04:14 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A0DB1111AF23
        for <linux-xfs@vger.kernel.org>; Mon, 23 Jul 2018 13:04:14 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 04/15] xfs: make deferred processing safe for embedded dfops
Date: Mon, 23 Jul 2018 09:04:03 -0400
Message-Id: <20180723130414.47980-5-bfoster@redhat.com>
In-Reply-To: <20180723130414.47980-1-bfoster@redhat.com>
References: <20180723130414.47980-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

xfs_defer_finish() has a couple quirks that are not safe with
respect to the upcoming internal dfops functionality. First,
xfs_defer_finish() attaches the passed in dfops structure to
->t_dfops and caches and restores the original value. Second, it
continues to use the initial dfops reference before and after the
transaction roll.

These behaviors assume that dop is an independent memory allocation
from the transaction itself, which may not always be true once
transactions begin to use an embedded dfops structure. In the latter
model, dfops processing creates a new xfs_defer_ops structure with
each transaction and the associated state is migrated across to the
new transaction.

Fix up xfs_defer_finish() to handle the possibility of the current
dfops changing after a transaction roll. Since ->t_dfops is used
unconditionally in this path, it is no longer necessary to
attach/restore ->t_dfops and pass it explicitly down to
xfs_defer_trans_roll(). Update dop in the latter function and the
caller to ensure that it always refers to the current dfops
structure.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_defer.c | 32 ++++++++++++++------------------
 1 file changed, 14 insertions(+), 18 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index c4b0eaeb5190..ee734a8b3fa9 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -225,9 +225,9 @@ xfs_defer_trans_abort(
 /* Roll a transaction so we can do some deferred op processing. */
 STATIC int
 xfs_defer_trans_roll(
-	struct xfs_trans		**tp,
-	struct xfs_defer_ops		*dop)
+	struct xfs_trans		**tp)
 {
+	struct xfs_defer_ops		*dop = (*tp)->t_dfops;
 	int				i;
 	int				error;
 
@@ -243,6 +243,7 @@ xfs_defer_trans_roll(
 
 	/* Roll the transaction. */
 	error = xfs_trans_roll(tp);
+	dop = (*tp)->t_dfops;
 	if (error) {
 		trace_xfs_defer_trans_roll_error((*tp)->t_mountp, dop, error);
 		xfs_defer_trans_abort(*tp, dop, error);
@@ -338,31 +339,25 @@ xfs_defer_finish(
 	void				*state;
 	int				error = 0;
 	void				(*cleanup_fn)(struct xfs_trans *, void *, int);
-	struct xfs_defer_ops		*orig_dop;
 
 	ASSERT((*tp)->t_flags & XFS_TRANS_PERM_LOG_RES);
+	ASSERT((*tp)->t_dfops == dop);
 
 	trace_xfs_defer_finish((*tp)->t_mountp, dop, _RET_IP_);
 
-	/*
-	 * Attach dfops to the transaction during deferred ops processing. This
-	 * explicitly causes calls into the allocator to defer AGFL block frees.
-	 * Note that this code can go away once all dfops users attach to the
-	 * associated tp.
-	 */
-	ASSERT(!(*tp)->t_dfops || ((*tp)->t_dfops == dop));
-	orig_dop = (*tp)->t_dfops;
-	(*tp)->t_dfops = dop;
-
 	/* Until we run out of pending work to finish... */
 	while (xfs_defer_has_unfinished_work(dop)) {
 		/* Log intents for work items sitting in the intake. */
 		xfs_defer_intake_work(*tp, dop);
 
-		/* Roll the transaction. */
-		error = xfs_defer_trans_roll(tp, dop);
+		/*
+		 * Roll the transaction and update dop in case dfops was
+		 * embedded in the transaction.
+		 */
+		error = xfs_defer_trans_roll(tp);
 		if (error)
 			goto out;
+		dop = (*tp)->t_dfops;
 
 		/* Log an intent-done item for the first pending item. */
 		dfp = list_first_entry(&dop->dop_pending,
@@ -428,10 +423,11 @@ xfs_defer_finish(
 	 * Roll the transaction once more to avoid returning to the caller
 	 * with a dirty transaction.
 	 */
-	if ((*tp)->t_flags & XFS_TRANS_DIRTY)
-		error = xfs_defer_trans_roll(tp, dop);
+	if ((*tp)->t_flags & XFS_TRANS_DIRTY) {
+		error = xfs_defer_trans_roll(tp);
+		dop = (*tp)->t_dfops;
+	}
 out:
-	(*tp)->t_dfops = orig_dop;
 	if (error)
 		trace_xfs_defer_finish_error((*tp)->t_mountp, dop, error);
 	else
-- 
2.17.1

