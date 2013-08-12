Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D99CA7F6B
	for <xfs@oss.sgi.com>; Mon, 12 Aug 2013 05:50:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id AC1BA304039
	for <xfs@oss.sgi.com>; Mon, 12 Aug 2013 03:50:57 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	76e5HiAY8QoO7zwF for <xfs@oss.sgi.com>;
	Mon, 12 Aug 2013 03:50:55 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1V8phX-0004YP-Je
	for xfs@oss.sgi.com; Mon, 12 Aug 2013 20:50:15 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1V8phX-000646-IF
	for xfs@oss.sgi.com; Mon, 12 Aug 2013 20:50:15 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: ***** SUSPECTED SPAM ***** [PATCH 45/50] xfs: avoid CIL allocation
	during insert
Date: Mon, 12 Aug 2013 20:50:06 +1000
Message-Id: <1376304611-22994-46-git-send-email-david@fromorbit.com>
In-Reply-To: <1376304611-22994-1-git-send-email-david@fromorbit.com>
References: <1376304611-22994-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

Now that we have the size of the log vector that has been allocated,
we can determine if we need to allocate a new log vector for
formatting and insertion. We only need to allocate a new vector if
it won't fit into the existing buffer.

However, we need to hold the CIL context lock while we do this so
that we can't race with a push draining the currently queued log
vectors. It is safe to do this as long as we do GFP_NOFS allocation
to avoid avoid memory allocation recursing into the filesystem.
Hence we can safely overwrite the existing log vector on the CIL if
it is large enough to hold all the dirty regions of the current
item.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log_cil.c | 52 +++++++++++++++++++++++++++++++++-------------------
 fs/xfs/xfs_trans.h   |  1 -
 2 files changed, 33 insertions(+), 20 deletions(-)

diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 423ceaf..b20b157 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -185,6 +185,22 @@ xlog_cil_prepare_log_vecs(
 		buf_size = sizeof(struct xfs_log_vec) + nbytes +
 				niovecs * sizeof(struct xfs_log_iovec);
 
+		/* compare to existing item size */
+		if (lip->li_lv && buf_size <= lip->li_lv->lv_size) {
+			/* same or smaller, optimise common overwrite case */
+			lv = lip->li_lv;
+			lv->lv_next = NULL;
+
+			if (ordered)
+				goto insert;
+
+			/* Ensure the lv is set up according to ->iop_size */
+			lv->lv_niovecs = niovecs;
+			lv->lv_buf = (char *)lv + buf_size - nbytes;
+			lv->lv_buf_len = xlog_cil_lv_item_format(lip, lv);
+			goto insert;
+		}
+
 		/* allocate new data chunk */
 		lv = kmem_zalloc(buf_size, KM_SLEEP|KM_NOFS);
 		lv->lv_item = lip;
@@ -204,8 +220,8 @@ xlog_cil_prepare_log_vecs(
 		lv->lv_buf = (char *)lv + buf_size - nbytes;
 
 		lv->lv_buf_len = xlog_cil_lv_item_format(lip, lv);
-		ASSERT(lv->lv_buf_len <= nbytes);
 insert:
+		ASSERT(lv->lv_buf_len <= nbytes);
 		if (!ret_lv)
 			ret_lv = lv;
 		else
@@ -230,7 +246,17 @@ xfs_cil_prepare_item(
 {
 	struct xfs_log_vec	*old = lv->lv_item->li_lv;
 
-	if (old) {
+	if (!old) {
+		/* new lv, must pin the log item */
+		ASSERT(!lv->lv_item->li_lv);
+
+		if (lv->lv_buf_len != XFS_LOG_VEC_ORDERED) {
+			*len += lv->lv_buf_len;
+			*diff_iovecs += lv->lv_niovecs;
+		}
+		lv->lv_item->li_ops->iop_pin(lv->lv_item);
+
+	} else if (old != lv) {
 		/* existing lv on log item, space used is a delta */
 		ASSERT((old->lv_buf && old->lv_buf_len && old->lv_niovecs) ||
 			old->lv_buf_len == XFS_LOG_VEC_ORDERED);
@@ -249,15 +275,8 @@ xfs_cil_prepare_item(
 		*diff_iovecs += lv->lv_niovecs - old->lv_niovecs;
 		kmem_free(old);
 	} else {
-		/* new lv, must pin the log item */
-		ASSERT(!lv->lv_item->li_lv);
-
-		if (lv->lv_buf_len != XFS_LOG_VEC_ORDERED) {
-			*len += lv->lv_buf_len;
-			*diff_iovecs += lv->lv_niovecs;
-		}
-		IOP_PIN(lv->lv_item);
-
+		/* re-used lv */
+		/* XXX: can't account for len/diff_iovecs yet */
 	}
 
 	/* attach new log vector to log item */
@@ -733,18 +752,13 @@ xfs_log_commit_cil(
 	if (flags & XFS_TRANS_RELEASE_LOG_RES)
 		log_flags = XFS_LOG_REL_PERM_RESERV;
 
-	/*
-	 * Do all the hard work of formatting items (including memory
-	 * allocation) outside the CIL context lock. This prevents stalling CIL
-	 * pushes when we are low on memory and a transaction commit spends a
-	 * lot of time in memory reclaim.
-	 */
+	/* lock out background commit */
+	down_read(&log->l_cilp->xc_ctx_lock);
+
 	log_vector = xlog_cil_prepare_log_vecs(tp);
 	if (!log_vector)
 		return ENOMEM;
 
-	/* lock out background commit */
-	down_read(&log->l_cilp->xc_ctx_lock);
 	if (commit_lsn)
 		*commit_lsn = log->l_cilp->xc_ctx->sequence;
 
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 24bbdcd..4786170 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -77,7 +77,6 @@ struct xfs_item_ops {
 	void (*iop_committing)(xfs_log_item_t *, xfs_lsn_t);
 };
 
-#define IOP_PIN(ip)		(*(ip)->li_ops->iop_pin)(ip)
 #define IOP_UNPIN(ip, remove)	(*(ip)->li_ops->iop_unpin)(ip, remove)
 #define IOP_PUSH(ip, list)	(*(ip)->li_ops->iop_push)(ip, list)
 #define IOP_UNLOCK(ip)		(*(ip)->li_ops->iop_unlock)(ip)
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
