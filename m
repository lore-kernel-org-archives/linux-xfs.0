Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:40598 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754097AbcJVCNl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Oct 2016 22:13:41 -0400
Date: Fri, 21 Oct 2016 19:13:37 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs: defer should abort intent items if the trans roll fails
Message-ID: <20161022021337.GC5256@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

If the deferred ops transaction roll fails, we need to abort the intent
items if we haven't already logged a done item for it, regardless of
whether or not the deferred ops has had a transaction committed.  Dave
found this while running generic/388.

Move the tracepoint to make it easier to track object lifetimes.

Reported-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_defer.c |   17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index 613c5cf..5c2929f 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -199,9 +199,9 @@ xfs_defer_intake_work(
 	struct xfs_defer_pending	*dfp;
 
 	list_for_each_entry(dfp, &dop->dop_intake, dfp_list) {
-		trace_xfs_defer_intake_work(tp->t_mountp, dfp);
 		dfp->dfp_intent = dfp->dfp_type->create_intent(tp,
 				dfp->dfp_count);
+		trace_xfs_defer_intake_work(tp->t_mountp, dfp);
 		list_sort(tp->t_mountp, &dfp->dfp_work,
 				dfp->dfp_type->diff_items);
 		list_for_each(li, &dfp->dfp_work)
@@ -221,21 +221,14 @@ xfs_defer_trans_abort(
 	struct xfs_defer_pending	*dfp;
 
 	trace_xfs_defer_trans_abort(tp->t_mountp, dop);
-	/*
-	 * If the transaction was committed, drop the intent reference
-	 * since we're bailing out of here. The other reference is
-	 * dropped when the intent hits the AIL.  If the transaction
-	 * was not committed, the intent is freed by the intent item
-	 * unlock handler on abort.
-	 */
-	if (!dop->dop_committed)
-		return;
 
-	/* Abort intent items. */
+	/* Abort intent items that don't have a done item. */
 	list_for_each_entry(dfp, &dop->dop_pending, dfp_list) {
 		trace_xfs_defer_pending_abort(tp->t_mountp, dfp);
-		if (!dfp->dfp_done)
+		if (dfp->dfp_intent && !dfp->dfp_done) {
 			dfp->dfp_type->abort_intent(dfp->dfp_intent);
+			dfp->dfp_intent = NULL;
+		}
 	}
 
 	/* Shut down FS. */
