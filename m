Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8D3957CA0
	for <xfs@oss.sgi.com>; Mon, 29 Aug 2016 22:39:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5C7858F804C
	for <xfs@oss.sgi.com>; Mon, 29 Aug 2016 20:39:51 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id JH59KfXfGgWaYVmo (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 29 Aug 2016 20:39:49 -0700 (PDT)
Date: Mon, 29 Aug 2016 20:39:17 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2] xfs: track log done items directly in the deferred
	pending work item
Message-ID: <20160830033917.GI22760@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
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
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

Christoph reports slab corruption when a deferred refcount update
aborts during _defer_finish().  The cause of this was broken log item
state tracking in xfs_defer_pending -- upon an abort,
_defer_trans_abort() will call abort_intent on all intent items,
including the ones that have already had a done item attached.

This is incorrect because each intent item has 2 refcount: the first
is released when the intent item is committed to the log; and the
second is released when the _done_ item is committed to the log, or
by the intent creator if there is no done item.  In other words, once
we log the done item, responsibility for releasing the intent item's
second refcount is transferred to the done item and /must not/ be
performed by anything else.

The dfp_committed flag should have been tracking whether or not we had
a done item so that _defer_trans_abort could decide if it needs to
abort the intent item, but due to a thinko this was not the case.  Rip
it out and track the done item directly so that we do the right thing
w.r.t. intent item freeing.

v2: Push patch to the head of the stack.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reported-by: Christoph Hellwig <hch@infradead.org>
---
 fs/xfs/libxfs/xfs_defer.c |   17 ++++-------------
 fs/xfs/libxfs/xfs_defer.h |    2 +-
 fs/xfs/xfs_trace.h        |    2 +-
 3 files changed, 6 insertions(+), 15 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index 054a203..c221d0e 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -194,7 +194,7 @@ xfs_defer_trans_abort(
 	/* Abort intent items. */
 	list_for_each_entry(dfp, &dop->dop_pending, dfp_list) {
 		trace_xfs_defer_pending_abort(tp->t_mountp, dfp);
-		if (dfp->dfp_committed)
+		if (!dfp->dfp_done)
 			dfp->dfp_type->abort_intent(dfp->dfp_intent);
 	}
 
@@ -290,7 +290,6 @@ xfs_defer_finish(
 	struct xfs_defer_pending	*dfp;
 	struct list_head		*li;
 	struct list_head		*n;
-	void				*done_item = NULL;
 	void				*state;
 	int				error = 0;
 	void				(*cleanup_fn)(struct xfs_trans *, void *, int);
@@ -309,19 +308,11 @@ xfs_defer_finish(
 		if (error)
 			goto out;
 
-		/* Mark all pending intents as committed. */
-		list_for_each_entry_reverse(dfp, &dop->dop_pending, dfp_list) {
-			if (dfp->dfp_committed)
-				break;
-			trace_xfs_defer_pending_commit((*tp)->t_mountp, dfp);
-			dfp->dfp_committed = true;
-		}
-
 		/* Log an intent-done item for the first pending item. */
 		dfp = list_first_entry(&dop->dop_pending,
 				struct xfs_defer_pending, dfp_list);
 		trace_xfs_defer_pending_finish((*tp)->t_mountp, dfp);
-		done_item = dfp->dfp_type->create_done(*tp, dfp->dfp_intent,
+		dfp->dfp_done = dfp->dfp_type->create_done(*tp, dfp->dfp_intent,
 				dfp->dfp_count);
 		cleanup_fn = dfp->dfp_type->finish_cleanup;
 
@@ -331,7 +322,7 @@ xfs_defer_finish(
 			list_del(li);
 			dfp->dfp_count--;
 			error = dfp->dfp_type->finish_item(*tp, dop, li,
-					done_item, &state);
+					dfp->dfp_done, &state);
 			if (error) {
 				/*
 				 * Clean up after ourselves and jump out.
@@ -428,8 +419,8 @@ xfs_defer_add(
 		dfp = kmem_alloc(sizeof(struct xfs_defer_pending),
 				KM_SLEEP | KM_NOFS);
 		dfp->dfp_type = defer_op_types[type];
-		dfp->dfp_committed = false;
 		dfp->dfp_intent = NULL;
+		dfp->dfp_done = NULL;
 		dfp->dfp_count = 0;
 		INIT_LIST_HEAD(&dfp->dfp_work);
 		list_add_tail(&dfp->dfp_list, &dop->dop_intake);
diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
index cc3981c..e96533d 100644
--- a/fs/xfs/libxfs/xfs_defer.h
+++ b/fs/xfs/libxfs/xfs_defer.h
@@ -30,8 +30,8 @@ struct xfs_defer_op_type;
 struct xfs_defer_pending {
 	const struct xfs_defer_op_type	*dfp_type;	/* function pointers */
 	struct list_head		dfp_list;	/* pending items */
-	bool				dfp_committed;	/* committed trans? */
 	void				*dfp_intent;	/* log intent item */
+	void				*dfp_done;	/* log done item */
 	struct list_head		dfp_work;	/* work items */
 	unsigned int			dfp_count;	/* # extent items */
 };
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 7e88bec..d303a66 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -2295,7 +2295,7 @@ DECLARE_EVENT_CLASS(xfs_defer_pending_class,
 		__entry->dev = mp ? mp->m_super->s_dev : 0;
 		__entry->type = dfp->dfp_type->type;
 		__entry->intent = dfp->dfp_intent;
-		__entry->committed = dfp->dfp_committed;
+		__entry->committed = dfp->dfp_done != NULL;
 		__entry->nr = dfp->dfp_count;
 	),
 	TP_printk("dev %d:%d optype %d intent %p committed %d nr %d\n",

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
