Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DEA2F80B3
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:47:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 97B0F304043
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:47:02 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id RMeXR4ByJERk0vLd (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:47:00 -0700 (PDT)
Subject: [PATCH 04/71] xfs: defer should allow ->finish_item to request a
	new transaction
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:46:56 -0700
Message-ID: <147216881696.4420.16237985704832808995.stgit@birch.djwong.org>
In-Reply-To: <147216879156.4420.2446767701729565218.stgit@birch.djwong.org>
References: <147216879156.4420.2446767701729565218.stgit@birch.djwong.org>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, xfs@oss.sgi.com

When xfs_defer_finish calls ->finish_item, it's possible that
(refcount) won't be able to finish all the work in a single
transaction.  When this happens, the ->finish_item handler should
shorten the log done item's list count, update the work item to
reflect where work should continue, and return -EAGAIN so that
defer_finish knows to retain the pending item on the pending list,
roll the transaction, and restart processing where we left off.

Plumb in the code and document how this mechanism is supposed to work.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_defer.c |   78 +++++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 71 insertions(+), 7 deletions(-)


diff --git a/libxfs/xfs_defer.c b/libxfs/xfs_defer.c
index 06d56ba..27fef4b 100644
--- a/libxfs/xfs_defer.c
+++ b/libxfs/xfs_defer.c
@@ -81,6 +81,10 @@
  *   - For each work item attached to the log intent item,
  *     * Perform the described action.
  *     * Attach the work item to the log done item.
+ *     * If the result of doing the work was -EAGAIN, ->finish work
+ *       wants a new transaction.  See the "Requesting a Fresh
+ *       Transaction while Finishing Deferred Work" section below for
+ *       details.
  *
  * The key here is that we must log an intent item for all pending
  * work items every time we roll the transaction, and that we must log
@@ -88,6 +92,34 @@
  * we can perform complex remapping operations, chaining intent items
  * as needed.
  *
+ * Requesting a Fresh Transaction while Finishing Deferred Work
+ *
+ * If ->finish_item decides that it needs a fresh transaction to
+ * finish the work, it must ask its caller (xfs_defer_finish) for a
+ * continuation.  The most likely cause of this circumstance are the
+ * refcount adjust functions deciding that they've logged enough items
+ * to be at risk of exceeding the transaction reservation.
+ *
+ * To get a fresh transaction, we want to log the existing log done
+ * item to prevent the log intent item from replaying, immediately log
+ * a new log intent item with the unfinished work items, roll the
+ * transaction, and re-call ->finish_item wherever it left off.  The
+ * log done item and the new log intent item must be in the same
+ * transaction or atomicity cannot be guaranteed; defer_finish ensures
+ * that this happens.
+ *
+ * This requires some coordination between ->finish_item and
+ * defer_finish.  Upon deciding to request a new transaction,
+ * ->finish_item should update the current work item to reflect the
+ * unfinished work.  Next, it should reset the log done item's list
+ * count to the number of items finished, and return -EAGAIN.
+ * defer_finish sees the -EAGAIN, logs the new log intent item
+ * with the remaining work items, and leaves the xfs_defer_pending
+ * item at the head of the dop_work queue.  Then it rolls the
+ * transaction and picks up processing where it left off.  It is
+ * required that ->finish_item must be careful to leave enough
+ * transaction reservation to fit the new log intent item.
+ *
  * This is an example of remapping the extent (E, E+B) into file X at
  * offset A and dealing with the extent (C, C+B) already being mapped
  * there:
@@ -104,21 +136,26 @@
  * | Intent to add rmap (X, E, A, B)                 |
  * +-------------------------------------------------+
  * | Reduce refcount for extent (C, B)               | t2
- * | Done reducing refcount for extent (C, B)        |
+ * | Done reducing refcount for extent (C, 9)        |
+ * | Intent to reduce refcount for extent (C+9, B-9) |
+ * | (ran out of space after 9 refcount updates)     |
+ * +-------------------------------------------------+
+ * | Reduce refcount for extent (C+9, B+9)           | t3
+ * | Done reducing refcount for extent (C+9, B-9)    |
  * | Increase refcount for extent (E, B)             |
  * | Done increasing refcount for extent (E, B)      |
  * | Intent to free extent (C, B)                    |
  * | Intent to free extent (F, 1) (refcountbt block) |
  * | Intent to remove rmap (F, 1, REFC)              |
  * +-------------------------------------------------+
- * | Remove rmap (X, C, A, B)                        | t3
+ * | Remove rmap (X, C, A, B)                        | t4
  * | Done removing rmap (X, C, A, B)                 |
  * | Add rmap (X, E, A, B)                           |
  * | Done adding rmap (X, E, A, B)                   |
  * | Remove rmap (F, 1, REFC)                        |
  * | Done removing rmap (F, 1, REFC)                 |
  * +-------------------------------------------------+
- * | Free extent (C, B)                              | t4
+ * | Free extent (C, B)                              | t5
  * | Done freeing extent (C, B)                      |
  * | Free extent (D, 1)                              |
  * | Done freeing extent (D, 1)                      |
@@ -141,6 +178,9 @@
  * - Intent to free extent (C, B)
  * - Intent to free extent (F, 1) (refcountbt block)
  * - Intent to remove rmap (F, 1, REFC)
+ *
+ * Note that the continuation requested between t2 and t3 is likely to
+ * reoccur.
  */
 
 static const struct xfs_defer_op_type *defer_op_types[XFS_DEFER_OPS_TYPE_MAX];
@@ -332,7 +372,16 @@ xfs_defer_finish(
 			dfp->dfp_count--;
 			error = dfp->dfp_type->finish_item(*tp, dop, li,
 					done_item, &state);
-			if (error) {
+			if (error == -EAGAIN) {
+				/*
+				 * Caller wants a fresh transaction;
+				 * put the work item back on the list
+				 * and jump out.
+				 */
+				list_add(li, &dfp->dfp_work);
+				dfp->dfp_count++;
+				break;
+			} else if (error) {
 				/*
 				 * Clean up after ourselves and jump out.
 				 * xfs_defer_cancel will take care of freeing
@@ -344,9 +393,24 @@ xfs_defer_finish(
 				goto out;
 			}
 		}
-		/* Done with the dfp, free it. */
-		list_del(&dfp->dfp_list);
-		kmem_free(dfp);
+		if (error == -EAGAIN) {
+			/*
+			 * Caller wants a fresh transaction, so log a
+			 * new log intent item to replace the old one
+			 * and roll the transaction.  See "Requesting
+			 * a Fresh Transaction while Finishing
+			 * Deferred Work" above.
+			 */
+			dfp->dfp_intent = dfp->dfp_type->create_intent(*tp,
+					dfp->dfp_count);
+			list_for_each(li, &dfp->dfp_work)
+				dfp->dfp_type->log_item(*tp, dfp->dfp_intent,
+						li);
+		} else {
+			/* Done with the dfp, free it. */
+			list_del(&dfp->dfp_list);
+			kmem_free(dfp);
+		}
 
 		if (cleanup_fn)
 			cleanup_fn(*tp, state, error);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
