Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8EAu5qF121083 for <xfs@oss.sgi.com>; Tue, 14 Sep 2010 05:56:06 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AA70811E4F7A
	for <xfs@oss.sgi.com>; Tue, 14 Sep 2010 04:08:36 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail12.adl6.internode.on.net
	[150.101.137.97]) by cuda.sgi.com with ESMTP id
	EpIRIOEkwGxMmcdG for <xfs@oss.sgi.com>;
	Tue, 14 Sep 2010 04:08:36 -0700 (PDT)
Received: from dastard (unverified [121.44.127.68])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	38985522-1927428
	for <xfs@oss.sgi.com>; Tue, 14 Sep 2010 20:26:50 +0930 (CST)
Received: from disturbed ([192.168.1.9]) by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1OvTBn-0004OK-4F
	for xfs@oss.sgi.com; Tue, 14 Sep 2010 20:56:39 +1000
Received: from dave by disturbed with local (Exim 4.72)
	(envelope-from <dave@disturbed.disaster>) id 1OvTBa-0000Ps-OE
	for xfs@oss.sgi.com; Tue, 14 Sep 2010 20:56:26 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 02/18] xfs: reduce the number of CIL lock round trips during
	commit
Date: Tue, 14 Sep 2010 20:56:01 +1000
Message-Id: <1284461777-1496-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1284461777-1496-1-git-send-email-david@fromorbit.com>
References: <1284461777-1496-1-git-send-email-david@fromorbit.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

When commiting a transaction, we do a lock CIL state lock round trip
on every single log vector we insert into the CIL. This is resulting
in the lock being as hot as the inode and dcache locks on 8-way
create workloads. Rework the insertion loops to bring the number
of lock round trips to one per transaction for log vectors, and one
more do the busy extents.

Also change the allocation of the log vector buffer not to zero it
as we copy over the entire allocated buffer anyway.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log_cil.c |  116 +++++++++++++++++++++++++++++--------------------
 1 files changed, 69 insertions(+), 47 deletions(-)

diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index ed575fb..f1e6184 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -146,68 +146,37 @@ xlog_cil_init_post_recovery(
 }
 
 /*
- * Insert the log item into the CIL and calculate the difference in space
+ * Insert the log items into the CIL and calculate the difference in space
  * consumed by the item. Add the space to the checkpoint ticket and calculate
  * if the change requires additional log metadata. If it does, take that space
  * as well. Remove the amount of space we addded to the checkpoint ticket from
  * the current transaction ticket so that the accounting works out correctly.
- *
- * If this is the first time the item is being placed into the CIL in this
- * context, pin it so it can't be written to disk until the CIL is flushed to
- * the iclog and the iclog written to disk.
  */
 static void
 xlog_cil_insert(
 	struct log		*log,
 	struct xlog_ticket	*ticket,
-	struct xfs_log_item	*item,
-	struct xfs_log_vec	*lv)
+	struct xfs_log_vec	*log_vector,
+	int			diff_length,
+	int			diff_iovecs)
 {
 	struct xfs_cil		*cil = log->l_cilp;
-	struct xfs_log_vec	*old = lv->lv_item->li_lv;
 	struct xfs_cil_ctx	*ctx = cil->xc_ctx;
-	int			len;
-	int			diff_iovecs;
 	int			iclog_space;
+	int			len = diff_length;
+	struct xfs_log_vec	*lv;
 
-	if (old) {
-		/* existing lv on log item, space used is a delta */
-		ASSERT(!list_empty(&item->li_cil));
-		ASSERT(old->lv_buf && old->lv_buf_len && old->lv_niovecs);
-
-		len = lv->lv_buf_len - old->lv_buf_len;
-		diff_iovecs = lv->lv_niovecs - old->lv_niovecs;
-		kmem_free(old->lv_buf);
-		kmem_free(old);
-	} else {
-		/* new lv, must pin the log item */
-		ASSERT(!lv->lv_item->li_lv);
-		ASSERT(list_empty(&item->li_cil));
+	spin_lock(&cil->xc_cil_lock);
 
-		len = lv->lv_buf_len;
-		diff_iovecs = lv->lv_niovecs;
-		IOP_PIN(lv->lv_item);
+	/* move the items to the tail of the CIL */
+	for (lv = log_vector; lv; lv = lv->lv_next)
+		list_move_tail(&lv->lv_item->li_cil, &cil->xc_cil);
 
-	}
+	/* account for space used by new iovec headers  */
 	len += diff_iovecs * sizeof(xlog_op_header_t);
-
-	/* attach new log vector to log item */
-	lv->lv_item->li_lv = lv;
-
-	spin_lock(&cil->xc_cil_lock);
-	list_move_tail(&item->li_cil, &cil->xc_cil);
 	ctx->nvecs += diff_iovecs;
 
 	/*
-	 * If this is the first time the item is being committed to the CIL,
-	 * store the sequence number on the log item so we can tell
-	 * in future commits whether this is the first checkpoint the item is
-	 * being committed into.
-	 */
-	if (!item->li_seq)
-		item->li_seq = ctx->sequence;
-
-	/*
 	 * Now transfer enough transaction reservation to the context ticket
 	 * for the checkpoint. The context ticket is special - the unit
 	 * reservation has to grow as well as the current reservation as we
@@ -286,7 +255,7 @@ xlog_cil_format_items(
 			len += lv->lv_iovecp[index].i_len;
 
 		lv->lv_buf_len = len;
-		lv->lv_buf = kmem_zalloc(lv->lv_buf_len, KM_SLEEP|KM_NOFS);
+		lv->lv_buf = kmem_alloc(lv->lv_buf_len, KM_SLEEP|KM_NOFS);
 		ptr = lv->lv_buf;
 
 		for (index = 0; index < lv->lv_niovecs; index++) {
@@ -307,14 +276,67 @@ xlog_cil_insert_items(
 	struct xlog_ticket	*ticket,
 	xfs_lsn_t		*start_lsn)
 {
-	struct xfs_log_vec *lv;
+	struct xfs_log_vec	*lv;
+	int			len = 0;
+	int			diff_iovecs = 0;
+
+	ASSERT(log_vector);
 
 	if (start_lsn)
 		*start_lsn = log->l_cilp->xc_ctx->sequence;
 
-	ASSERT(log_vector);
-	for (lv = log_vector; lv; lv = lv->lv_next)
-		xlog_cil_insert(log, ticket, lv->lv_item, lv);
+	/*
+	 * Do all the accounting aggregation and switching of log vectors
+	 * around in a separate loop to the insertion of items into the CIL.
+	 * Then we can do a separate loop to update the CIL within a single
+	 * lock/unlock pair. This reduces the number of round trips on the CIL
+	 * lock from O(nr_logvectors) to O(1) and greatly reduces the overall
+	 * hold time for the transaction commit.
+	 *
+	 * If this is the first time the item is being placed into the CIL in
+	 * this context, pin it so it can't be written to disk until the CIL is
+	 * flushed to the iclog and the iclog written to disk.
+	 *
+	 * We can do this safely because the context can't checkpoint until we
+	 * are done so it doesn't matter exactly how we update the CIL.
+	 */
+	for (lv = log_vector; lv; lv = lv->lv_next) {
+		struct xfs_log_vec	*old = lv->lv_item->li_lv;
+
+		if (old) {
+			/* existing lv on log item, space used is a delta */
+			ASSERT(!list_empty(&lv->lv_item->li_cil));
+			ASSERT(old->lv_buf && old->lv_buf_len && old->lv_niovecs);
+
+			len += lv->lv_buf_len - old->lv_buf_len;
+			diff_iovecs += lv->lv_niovecs - old->lv_niovecs;
+			kmem_free(old->lv_buf);
+			kmem_free(old);
+		} else {
+			/* new lv, must pin the log item */
+			ASSERT(!lv->lv_item->li_lv);
+			ASSERT(list_empty(&lv->lv_item->li_cil));
+
+			len += lv->lv_buf_len;
+			diff_iovecs += lv->lv_niovecs;
+			IOP_PIN(lv->lv_item);
+
+		}
+
+		/* attach new log vector to log item */
+		lv->lv_item->li_lv = lv;
+
+		/*
+		 * If this is the first time the item is being committed to the
+		 * CIL, store the sequence number on the log item so we can
+		 * tell in future commits whether this is the first checkpoint
+		 * the item is being committed into.
+		 */
+		if (!lv->lv_item->li_seq)
+			lv->lv_item->li_seq = log->l_cilp->xc_ctx->sequence;
+	}
+
+	xlog_cil_insert(log, ticket, log_vector, len, diff_iovecs);
 }
 
 static void
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
