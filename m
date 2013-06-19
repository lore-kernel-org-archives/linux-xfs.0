Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8743629E13
	for <xfs@oss.sgi.com>; Tue, 18 Jun 2013 23:51:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 14471AC002
	for <xfs@oss.sgi.com>; Tue, 18 Jun 2013 21:51:25 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	fi21UvQdeRWkwnVq for <xfs@oss.sgi.com>;
	Tue, 18 Jun 2013 21:51:23 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UpAMb-0002yJ-CF
	for xfs@oss.sgi.com; Wed, 19 Jun 2013 14:51:21 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UpAMR-0008Vi-8D
	for xfs@oss.sgi.com; Wed, 19 Jun 2013 14:51:11 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 07/60] xfs: Introduce ordered log vector support
Date: Wed, 19 Jun 2013 14:50:15 +1000
Message-Id: <1371617468-32559-8-git-send-email-david@fromorbit.com>
In-Reply-To: <1371617468-32559-1-git-send-email-david@fromorbit.com>
References: <1371617468-32559-1-git-send-email-david@fromorbit.com>
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

And "ordered log vector" is a log vector that is used for
tracking a log item through the CIL and into the AIL as part of the
log checkpointing. These ordered log vectors are special in that
they are not written to to journal in any way, and are not accounted
to the checkpoint being written.

The reason for this behaviour is to allow operations to attach items
to transactions and have them follow the normal transactional
lifecycle without actually having to write them to the journal. This
allows logging of items that track high level logical changes and
writing them to the log, while the physical items being modified
pass through into the AIL and pin the tail of the log (and therefore
the logical item in the log) until all the modified items are
physically written to disk.

IOWs, it allows us to write metadata without physically logging
every individual change but still maintain the full transactional
integrity guarantees we currently have w.r.t. crash recovery.

This change modifies some of the CIL item insertion loops, as
ordered log vectors introduce some new constraints as they don't
track any data. One advantage of this change is that it combines
two log vector chain walks into a single pass, so there is less
overhead in the transaction commit pass as well. It also kills some
unused code in the log vector walk loop when committing the CIL.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log.c     |   21 +++++++++++---
 fs/xfs/xfs_log.h     |    2 ++
 fs/xfs/xfs_log_cil.c |   75 ++++++++++++++++++++++++++++++++++----------------
 3 files changed, 70 insertions(+), 28 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index b345a7c..db08d34 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1963,6 +1963,10 @@ xlog_write_calc_vec_length(
 		headers++;
 
 	for (lv = log_vector; lv; lv = lv->lv_next) {
+		/* we don't write ordered log vectors */
+		if (lv->lv_buf_len == XFS_LOG_VEC_ORDERED)
+			continue;
+
 		headers += lv->lv_niovecs;
 
 		for (i = 0; i < lv->lv_niovecs; i++) {
@@ -2216,7 +2220,7 @@ xlog_write(
 	index = 0;
 	lv = log_vector;
 	vecp = lv->lv_iovecp;
-	while (lv && index < lv->lv_niovecs) {
+	while (lv && (!lv->lv_niovecs || index < lv->lv_niovecs)) {
 		void		*ptr;
 		int		log_offset;
 
@@ -2236,13 +2240,21 @@ xlog_write(
 		 * This loop writes out as many regions as can fit in the amount
 		 * of space which was allocated by xlog_state_get_iclog_space().
 		 */
-		while (lv && index < lv->lv_niovecs) {
-			struct xfs_log_iovec	*reg = &vecp[index];
+		while (lv && (!lv->lv_niovecs || index < lv->lv_niovecs)) {
+			struct xfs_log_iovec	*reg;
 			struct xlog_op_header	*ophdr;
 			int			start_rec_copy;
 			int			copy_len;
 			int			copy_off;
+			bool			ordered = false;
+
+			/* ordered log vectors have no regions to write */
+			if (lv->lv_buf_len == XFS_LOG_VEC_ORDERED) {
+				ordered = true;
+				goto next_lv;
+			}
 
+			reg = &vecp[index];
 			ASSERT(reg->i_len % sizeof(__int32_t) == 0);
 			ASSERT((unsigned long)ptr % sizeof(__int32_t) == 0);
 
@@ -2302,12 +2314,13 @@ xlog_write(
 				break;
 
 			if (++index == lv->lv_niovecs) {
+next_lv:
 				lv = lv->lv_next;
 				index = 0;
 				if (lv)
 					vecp = lv->lv_iovecp;
 			}
-			if (record_cnt == 0) {
+			if (record_cnt == 0 && ordered == false) {
 				if (!lv)
 					return 0;
 				break;
diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
index 5caee96..b20918c 100644
--- a/fs/xfs/xfs_log.h
+++ b/fs/xfs/xfs_log.h
@@ -105,6 +105,8 @@ struct xfs_log_vec {
 	int			lv_buf_len;	/* size of formatted buffer */
 };
 
+#define XFS_LOG_VEC_ORDERED	(-1)
+
 /*
  * Structure used to pass callback function and the function's argument
  * to the log manager.
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index d0833b5..02b9cf3 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -127,6 +127,7 @@ xlog_cil_prepare_log_vecs(
 		int	index;
 		int	len = 0;
 		uint	niovecs;
+		bool	ordered = false;
 
 		/* Skip items which aren't dirty in this transaction. */
 		if (!(lidp->lid_flags & XFS_LID_DIRTY))
@@ -137,14 +138,30 @@ xlog_cil_prepare_log_vecs(
 		if (!niovecs)
 			continue;
 
+		/*
+		 * Ordered items need to be tracked but we do not wish to write
+		 * them. We need a logvec to track the object, but we do not
+		 * need an iovec or buffer to be allocated for copying data.
+		 */
+		if (niovecs == XFS_LOG_VEC_ORDERED) {
+			ordered = true;
+			niovecs = 0;
+		}
+
 		new_lv = kmem_zalloc(sizeof(*new_lv) +
 				niovecs * sizeof(struct xfs_log_iovec),
 				KM_SLEEP|KM_NOFS);
 
+		new_lv->lv_item = lidp->lid_item;
+		new_lv->lv_niovecs = niovecs;
+		if (ordered) {
+			/* track as an ordered logvec */
+			new_lv->lv_buf_len = XFS_LOG_VEC_ORDERED;
+			goto next;
+		}
+
 		/* The allocated iovec region lies beyond the log vector. */
 		new_lv->lv_iovecp = (struct xfs_log_iovec *)&new_lv[1];
-		new_lv->lv_niovecs = niovecs;
-		new_lv->lv_item = lidp->lid_item;
 
 		/* build the vector array and calculate it's length */
 		IOP_FORMAT(new_lv->lv_item, new_lv->lv_iovecp);
@@ -165,6 +182,7 @@ xlog_cil_prepare_log_vecs(
 		}
 		ASSERT(ptr == new_lv->lv_buf + new_lv->lv_buf_len);
 
+next:
 		if (!ret_lv)
 			ret_lv = new_lv;
 		else
@@ -191,8 +209,18 @@ xfs_cil_prepare_item(
 
 	if (old) {
 		/* existing lv on log item, space used is a delta */
-		ASSERT(!list_empty(&lv->lv_item->li_cil));
-		ASSERT(old->lv_buf && old->lv_buf_len && old->lv_niovecs);
+		ASSERT((old->lv_buf && old->lv_buf_len && old->lv_niovecs) ||
+			old->lv_buf_len == XFS_LOG_VEC_ORDERED);
+
+		/*
+		 * If the new item is ordered, keep the old one that is already
+		 * tracking dirty or ordered regions
+		 */
+		if (lv->lv_buf_len == XFS_LOG_VEC_ORDERED) {
+			ASSERT(!lv->lv_buf);
+			kmem_free(lv);
+			return;
+		}
 
 		*len += lv->lv_buf_len - old->lv_buf_len;
 		*diff_iovecs += lv->lv_niovecs - old->lv_niovecs;
@@ -201,10 +229,11 @@ xfs_cil_prepare_item(
 	} else {
 		/* new lv, must pin the log item */
 		ASSERT(!lv->lv_item->li_lv);
-		ASSERT(list_empty(&lv->lv_item->li_cil));
 
-		*len += lv->lv_buf_len;
-		*diff_iovecs += lv->lv_niovecs;
+		if (lv->lv_buf_len != XFS_LOG_VEC_ORDERED) {
+			*len += lv->lv_buf_len;
+			*diff_iovecs += lv->lv_niovecs;
+		}
 		IOP_PIN(lv->lv_item);
 
 	}
@@ -259,18 +288,24 @@ xlog_cil_insert_items(
 	 * We can do this safely because the context can't checkpoint until we
 	 * are done so it doesn't matter exactly how we update the CIL.
 	 */
-	for (lv = log_vector; lv; lv = lv->lv_next)
-		xfs_cil_prepare_item(log, lv, &len, &diff_iovecs);
-
-	/* account for space used by new iovec headers  */
-	len += diff_iovecs * sizeof(xlog_op_header_t);
-
 	spin_lock(&cil->xc_cil_lock);
+	for (lv = log_vector; lv; ) {
+		struct xfs_log_vec *next = lv->lv_next;
 
-	/* move the items to the tail of the CIL */
-	for (lv = log_vector; lv; lv = lv->lv_next)
+		ASSERT(lv->lv_item->li_lv || list_empty(&lv->lv_item->li_cil));
+		lv->lv_next = NULL;
+
+		/*
+		 * xfs_cil_prepare_item() may free the lv, so move the item on
+		 * the CIL first.
+		 */
 		list_move_tail(&lv->lv_item->li_cil, &cil->xc_cil);
+		xfs_cil_prepare_item(log, lv, &len, &diff_iovecs);
+		lv = next;
+	}
 
+	/* account for space used by new iovec headers  */
+	len += diff_iovecs * sizeof(xlog_op_header_t);
 	ctx->nvecs += diff_iovecs;
 
 	/*
@@ -381,9 +416,7 @@ xlog_cil_push(
 	struct xfs_cil_ctx	*new_ctx;
 	struct xlog_in_core	*commit_iclog;
 	struct xlog_ticket	*tic;
-	int			num_lv;
 	int			num_iovecs;
-	int			len;
 	int			error = 0;
 	struct xfs_trans_header thdr;
 	struct xfs_log_iovec	lhdr;
@@ -428,12 +461,9 @@ xlog_cil_push(
 	 * side which is currently locked out by the flush lock.
 	 */
 	lv = NULL;
-	num_lv = 0;
 	num_iovecs = 0;
-	len = 0;
 	while (!list_empty(&cil->xc_cil)) {
 		struct xfs_log_item	*item;
-		int			i;
 
 		item = list_first_entry(&cil->xc_cil,
 					struct xfs_log_item, li_cil);
@@ -444,11 +474,7 @@ xlog_cil_push(
 			lv->lv_next = item->li_lv;
 		lv = item->li_lv;
 		item->li_lv = NULL;
-
-		num_lv++;
 		num_iovecs += lv->lv_niovecs;
-		for (i = 0; i < lv->lv_niovecs; i++)
-			len += lv->lv_iovecp[i].i_len;
 	}
 
 	/*
@@ -701,6 +727,7 @@ xfs_log_commit_cil(
 	if (commit_lsn)
 		*commit_lsn = log->l_cilp->xc_ctx->sequence;
 
+	/* xlog_cil_insert_items() destroys log_vector list */
 	xlog_cil_insert_items(log, log_vector, tp->t_ticket);
 
 	/* check we didn't blow the reservation */
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
