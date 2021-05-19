Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68C3CC43600
	for <linux-xfs@archiver.kernel.org>; Wed, 19 May 2021 12:13:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 440A261353
	for <linux-xfs@archiver.kernel.org>; Wed, 19 May 2021 12:13:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353389AbhESMOv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 May 2021 08:14:51 -0400
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:47966 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1353390AbhESMOp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 May 2021 08:14:45 -0400
Received: from dread.disaster.area (pa49-195-118-180.pa.nsw.optusnet.com.au [49.195.118.180])
        by mail109.syd.optusnet.com.au (Postfix) with ESMTPS id 809C267DA9
        for <linux-xfs@vger.kernel.org>; Wed, 19 May 2021 22:13:20 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ljL4i-002m1E-2d
        for linux-xfs@vger.kernel.org; Wed, 19 May 2021 22:13:20 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1ljL4h-002SHJ-Qq
        for linux-xfs@vger.kernel.org; Wed, 19 May 2021 22:13:19 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 18/39] xfs: reserve space and initialise xlog_op_header in item formatting
Date:   Wed, 19 May 2021 22:12:56 +1000
Message-Id: <20210519121317.585244-19-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210519121317.585244-1-david@fromorbit.com>
References: <20210519121317.585244-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0
        a=xcwBwyABtj18PbVNKPPJDQ==:117 a=xcwBwyABtj18PbVNKPPJDQ==:17
        a=5FLXtPjwQuUA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8
        a=hH36q76zEQHc0ou5sH0A:9 a=GixTnvO1OEtgUAe4:21 a=sWFYjEUKniITNhTs:21
        a=AjGcO6oz07-iQ99wixmX:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Current xlog_write() adds op headers to the log manually for every
log item region that is in the vector passed to it. While
xlog_write() needs to stamp the transaction ID into the ophdr, we
already know it's length, flags, clientid, etc at CIL commit time.

This means the only time that xlog write really needs to format and
reserve space for a new ophdr is when a region is split across two
iclogs. Adding the opheader and accounting for it as part of the
normal formatted item region means we simplify the accounting
of space used by a transaction and we don't have to special case
reserving of space in for the ophdrs in xlog_write(). It also means
we can largely initialise the ophdr in transaction commit instead
of xlog_write, making the xlog_write formatting inner loop much
tighter.

xlog_prepare_iovec() is now too large to stay as an inline function,
so we move it out of line and into xfs_log.c.

Object sizes:
text	   data	    bss	    dec	    hex	filename
1125934	 305951	    484	1432369	 15db31 fs/xfs/built-in.a.before
1123360	 305951	    484	1429795	 15d123 fs/xfs/built-in.a.after

So the code is a roughly 2.5kB smaller with xlog_prepare_iovec() now
out of line, even though it grew in size itself.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_log.c     | 115 +++++++++++++++++++++++++++++--------------
 fs/xfs/xfs_log.h     |  42 +++-------------
 fs/xfs/xfs_log_cil.c |  25 +++++-----
 3 files changed, 99 insertions(+), 83 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index ccf584914b6a..48890fb6122e 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -89,6 +89,62 @@ xlog_iclogs_empty(
 static int
 xfs_log_cover(struct xfs_mount *);
 
+/*
+ * We need to make sure the buffer pointer returned is naturally aligned for the
+ * biggest basic data type we put into it. We have already accounted for this
+ * padding when sizing the buffer.
+ *
+ * However, this padding does not get written into the log, and hence we have to
+ * track the space used by the log vectors separately to prevent log space hangs
+ * due to inaccurate accounting (i.e. a leak) of the used log space through the
+ * CIL context ticket.
+ *
+ * We also add space for the xlog_op_header that describes this region in the
+ * log. This prepends the data region we return to the caller to copy their data
+ * into, so do all the static initialisation of the ophdr now. Because the ophdr
+ * is not 8 byte aligned, we have to be careful to ensure that we align the
+ * start of the buffer such that the region we return to the call is 8 byte
+ * aligned and packed against the tail of the ophdr.
+ */
+void *
+xlog_prepare_iovec(
+	struct xfs_log_vec	*lv,
+	struct xfs_log_iovec	**vecp,
+	uint			type)
+{
+	struct xfs_log_iovec	*vec = *vecp;
+	struct xlog_op_header	*oph;
+	uint32_t		len;
+	void			*buf;
+
+	if (vec) {
+		ASSERT(vec - lv->lv_iovecp < lv->lv_niovecs);
+		vec++;
+	} else {
+		vec = &lv->lv_iovecp[0];
+	}
+
+	len = lv->lv_buf_len + sizeof(struct xlog_op_header);
+	if (!IS_ALIGNED(len, sizeof(uint64_t))) {
+		lv->lv_buf_len = round_up(len, sizeof(uint64_t)) -
+					sizeof(struct xlog_op_header);
+	}
+
+	vec->i_type = type;
+	vec->i_addr = lv->lv_buf + lv->lv_buf_len;
+
+	oph = vec->i_addr;
+	oph->oh_clientid = XFS_TRANSACTION;
+	oph->oh_res2 = 0;
+	oph->oh_flags = 0;
+
+	buf = vec->i_addr + sizeof(struct xlog_op_header);
+	ASSERT(IS_ALIGNED((unsigned long)buf, sizeof(uint64_t)));
+
+	*vecp = vec;
+	return buf;
+}
+
 static void
 xlog_grant_sub_space(
 	struct xlog		*log,
@@ -2131,9 +2187,9 @@ xlog_print_trans(
 }
 
 /*
- * Calculate the potential space needed by the log vector. If this is a start
- * transaction, the caller has already accounted for both opheaders in the start
- * transaction, so we don't need to account for them here.
+ * Calculate the potential space needed by the log vector. All regions contain
+ * their own opheaders and they are accounted for in region space so we don't
+ * need to add them to the vector length here.
  */
 static int
 xlog_write_calc_vec_length(
@@ -2160,18 +2216,7 @@ xlog_write_calc_vec_length(
 			xlog_tic_add_region(ticket, vecp->i_len, vecp->i_type);
 		}
 	}
-
-	/* Don't account for regions with embedded ophdrs */
-	if (optype && headers > 0) {
-		headers--;
-		if (optype & XLOG_START_TRANS) {
-			ASSERT(headers >= 1);
-			headers--;
-		}
-	}
-
 	ticket->t_res_num_ophdrs += headers;
-	len += headers * sizeof(struct xlog_op_header);
 
 	return len;
 }
@@ -2181,7 +2226,6 @@ xlog_write_setup_ophdr(
 	struct xlog_op_header	*ophdr,
 	struct xlog_ticket	*ticket)
 {
-	ophdr->oh_tid = cpu_to_be32(ticket->t_tid);
 	ophdr->oh_clientid = XFS_TRANSACTION;
 	ophdr->oh_res2 = 0;
 	ophdr->oh_flags = 0;
@@ -2404,21 +2448,25 @@ xlog_write(
 			ASSERT((unsigned long)ptr % sizeof(int32_t) == 0);
 
 			/*
-			 * The XLOG_START_TRANS has embedded ophdrs for the
-			 * start record and transaction header. They will always
-			 * be the first two regions in the lv chain. Commit and
-			 * unmount records also have embedded ophdrs.
+			 * Regions always have their ophdr at the start of the
+			 * region, except for:
+			 * - a transaction start which has a start record ophdr
+			 *   before the first region ophdr; and
+			 * - the previous region didn't fully fit into an iclog
+			 *   so needs a continuation ophdr to prepend the region
+			 *   in this new iclog.
 			 */
-			if (optype) {
-				ophdr = reg->i_addr;
-				if (index)
-					optype &= ~XLOG_START_TRANS;
-			} else {
+			ophdr = reg->i_addr;
+			if (optype && index) {
+				optype &= ~XLOG_START_TRANS;
+			} else if (partial_copy) {
                                 ophdr = xlog_write_setup_ophdr(ptr, ticket);
 				xlog_write_adv_cnt(&ptr, &len, &log_offset,
 					   sizeof(struct xlog_op_header));
 				added_ophdr = true;
 			}
+			ophdr->oh_tid = cpu_to_be32(ticket->t_tid);
+
 			len += xlog_write_setup_copy(ticket, ophdr,
 						     iclog->ic_size-log_offset,
 						     reg->i_len,
@@ -2436,20 +2484,11 @@ xlog_write(
 				ophdr->oh_len = cpu_to_be32(copy_len -
 						sizeof(struct xlog_op_header));
 			}
-			/*
-			 * Copy region.
-			 *
-			 * Commit records just log an opheader, so
-			 * we can have empty payloads with no data region to
-			 * copy.  Hence we only copy the payload if the vector
-			 * says it has data to copy.
-			 */
-			ASSERT(copy_len >= 0);
-			if (copy_len > 0) {
-				memcpy(ptr, reg->i_addr + copy_off, copy_len);
-				xlog_write_adv_cnt(&ptr, &len, &log_offset,
-						   copy_len);
-			}
+
+			ASSERT(copy_len > 0);
+			memcpy(ptr, reg->i_addr + copy_off, copy_len);
+			xlog_write_adv_cnt(&ptr, &len, &log_offset, copy_len);
+
 			if (added_ophdr)
 				copy_len += sizeof(struct xlog_op_header);
 			record_cnt++;
diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
index 1ca4f2edbdaf..af54ea3f8c90 100644
--- a/fs/xfs/xfs_log.h
+++ b/fs/xfs/xfs_log.h
@@ -21,44 +21,18 @@ struct xfs_log_vec {
 
 #define XFS_LOG_VEC_ORDERED	(-1)
 
-/*
- * We need to make sure the buffer pointer returned is naturally aligned for the
- * biggest basic data type we put into it. We have already accounted for this
- * padding when sizing the buffer.
- *
- * However, this padding does not get written into the log, and hence we have to
- * track the space used by the log vectors separately to prevent log space hangs
- * due to inaccurate accounting (i.e. a leak) of the used log space through the
- * CIL context ticket.
- */
-static inline void *
-xlog_prepare_iovec(struct xfs_log_vec *lv, struct xfs_log_iovec **vecp,
-		uint type)
-{
-	struct xfs_log_iovec *vec = *vecp;
-
-	if (vec) {
-		ASSERT(vec - lv->lv_iovecp < lv->lv_niovecs);
-		vec++;
-	} else {
-		vec = &lv->lv_iovecp[0];
-	}
-
-	if (!IS_ALIGNED(lv->lv_buf_len, sizeof(uint64_t)))
-		lv->lv_buf_len = round_up(lv->lv_buf_len, sizeof(uint64_t));
-
-	vec->i_type = type;
-	vec->i_addr = lv->lv_buf + lv->lv_buf_len;
-
-	ASSERT(IS_ALIGNED((unsigned long)vec->i_addr, sizeof(uint64_t)));
-
-	*vecp = vec;
-	return vec->i_addr;
-}
+void *xlog_prepare_iovec(struct xfs_log_vec *lv, struct xfs_log_iovec **vecp,
+		uint type);
 
 static inline void
 xlog_finish_iovec(struct xfs_log_vec *lv, struct xfs_log_iovec *vec, int len)
 {
+	struct xlog_op_header	*oph = vec->i_addr;
+
+	/* opheader tracks payload length, logvec tracks region length */
+	oph->oh_len = len;
+
+	len += sizeof(struct xlog_op_header);
 	lv->lv_buf_len += len;
 	lv->lv_bytes += len;
 	vec->i_len = len;
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 9d3a495f1c78..58900171de09 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -181,13 +181,20 @@ xlog_cil_alloc_shadow_bufs(
 		}
 
 		/*
-		 * We 64-bit align the length of each iovec so that the start
-		 * of the next one is naturally aligned.  We'll need to
-		 * account for that slack space here. Then round nbytes up
-		 * to 64-bit alignment so that the initial buffer alignment is
-		 * easy to calculate and verify.
+		 * We 64-bit align the length of each iovec so that the start of
+		 * the next one is naturally aligned.  We'll need to account for
+		 * that slack space here.
+		 *
+		 * We also add the xlog_op_header to each region when
+		 * formatting, but that's not accounted to the size of the item
+		 * at this point. Hence we'll need an addition number of bytes
+		 * for each vector to hold an opheader.
+		 *
+		 * Then round nbytes up to 64-bit alignment so that the initial
+		 * buffer alignment is easy to calculate and verify.
 		 */
-		nbytes += niovecs * sizeof(uint64_t);
+		nbytes += niovecs *
+			(sizeof(uint64_t) + sizeof(struct xlog_op_header));
 		nbytes = round_up(nbytes, sizeof(uint64_t));
 
 		/*
@@ -433,11 +440,6 @@ xlog_cil_insert_items(
 
 	spin_lock(&cil->xc_cil_lock);
 
-	/* account for space used by new iovec headers  */
-	iovhdr_res = diff_iovecs * sizeof(xlog_op_header_t);
-	len += iovhdr_res;
-	ctx->nvecs += diff_iovecs;
-
 	/* attach the transaction to the CIL if it has any busy extents */
 	if (!list_empty(&tp->t_busy))
 		list_splice_init(&tp->t_busy, &ctx->busy_extents);
@@ -469,6 +471,7 @@ xlog_cil_insert_items(
 	}
 	tp->t_ticket->t_curr_res -= len;
 	ctx->space_used += len;
+	ctx->nvecs += diff_iovecs;
 
 	/*
 	 * If we've overrun the reservation, dump the tx details before we move
-- 
2.31.1

