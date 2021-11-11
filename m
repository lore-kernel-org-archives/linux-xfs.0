Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB0BBC433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Nov 2021 08:10:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A62886108B
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Nov 2021 08:10:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229649AbhKKIMw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 11 Nov 2021 03:12:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbhKKIMw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Nov 2021 03:12:52 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D01BC061766
        for <linux-xfs@vger.kernel.org>; Thu, 11 Nov 2021 00:10:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=v15MSELu4AQrtdlVvHIUOcfsROlWi9ekY32fhSxYZV0=; b=oJDQMPycd4jm+65eEzv459jkb4
        Ah28bYnn8IU9LE7OceAzDQGrJqmFBELV+hmyUm6E6hjdVcSCaH7sfQ9fGuFIUfdZTae8juHtkT75V
        at2QvtDC1dIi6yLND78dIdQSfFc4NFzYXk6t3R4C9Ev/JGFdUFAZnFlRXMDpJN1YqSdam+x/5YCSd
        o+1dwpwZVF9dB9KYT1qIRir5ZwtaPukrmDlB2DaXe4fv1AElfC6ZPX5ckQY4vQ5vdGvZ5js1DZW0M
        NLxH+2UlLiCnNTl31iQvSOdI3K2en1cqbMNiqyccELo0KrJ/NCa3pDQS/dvztHHoL5trEopeZ+qbv
        JkTVPj+Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ml59n-007T9y-58; Thu, 11 Nov 2021 08:10:03 +0000
Date:   Thu, 11 Nov 2021 00:10:03 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/16] xfs: reserve space and initialise xlog_op_header
 in item formatting
Message-ID: <YYzP26bJQjGElBFw@infradead.org>
References: <20211109015055.1547604-1-david@fromorbit.com>
 <20211109015055.1547604-8-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="dF9sR5IfDOwUtOGy"
Content-Disposition: inline
In-Reply-To: <20211109015055.1547604-8-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


--dF9sR5IfDOwUtOGy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Having the code changes in the same commit as the move makes this
really hard to review, so I had to split it.  See below for the split
version (which does not have properly updated commit logs).  I'd much
prefer to get the split version in, but the technical changes look
fine either way:

Reviewed-by: Christoph Hellwig <hch@lst.de>

--dF9sR5IfDOwUtOGy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-xfs-move-xlog_prepare_iovec-out-of-line.patch"

From efdaedb01bd2e961616df1db09a6aad55139b114 Mon Sep 17 00:00:00 2001
From: Dave Chinner <dchinner@redhat.com>
Date: Thu, 11 Nov 2021 09:04:16 +0100
Subject: xfs: move xlog_prepare_iovec out of line

---
 fs/xfs/xfs_log.c | 37 +++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_log.h | 36 ++----------------------------------
 2 files changed, 39 insertions(+), 34 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index f09663d3664be8..f17147c0fd2ff2 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -90,6 +90,43 @@ xlog_iclogs_empty(
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
+ */
+void *
+xlog_prepare_iovec(
+	struct xfs_log_vec	*lv,
+	struct xfs_log_iovec	**vecp,
+	uint			type)
+{
+	struct xfs_log_iovec	*vec = *vecp;
+
+	if (vec) {
+		ASSERT(vec - lv->lv_iovecp < lv->lv_niovecs);
+		vec++;
+	} else {
+		vec = &lv->lv_iovecp[0];
+	}
+
+	if (!IS_ALIGNED(lv->lv_buf_len, sizeof(uint64_t)))
+		lv->lv_buf_len = round_up(lv->lv_buf_len, sizeof(uint64_t));
+
+	vec->i_type = type;
+	vec->i_addr = lv->lv_buf + lv->lv_buf_len;
+
+	ASSERT(IS_ALIGNED((unsigned long)vec->i_addr, sizeof(uint64_t)));
+
+	*vecp = vec;
+	return vec->i_addr;
+}
+
 static void
 xlog_grant_sub_space(
 	struct xlog		*log,
diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
index d1fc434761667d..391adc36931885 100644
--- a/fs/xfs/xfs_log.h
+++ b/fs/xfs/xfs_log.h
@@ -21,40 +21,8 @@ struct xfs_log_vec {
 
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
-- 
2.30.2


--dF9sR5IfDOwUtOGy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment;
	filename="0002-xfs-reserve-space-and-initialise-xlog_op_header-in-i.patch"

From a87258e5cf9b44b5b16c520fced2524d479c7e71 Mon Sep 17 00:00:00 2001
From: Dave Chinner <dchinner@redhat.com>
Date: Sun, 31 Oct 2021 03:35:55 +1100
Subject: xfs: reserve space and initialise xlog_op_header in item formatting

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
 fs/xfs/xfs_log.c     | 86 ++++++++++++++++++++++----------------------
 fs/xfs/xfs_log.h     |  6 ++++
 fs/xfs/xfs_log_cil.c | 25 +++++++------
 3 files changed, 64 insertions(+), 53 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index f17147c0fd2ff2..0923bee8d4e286 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -99,6 +99,13 @@ xfs_log_cover(struct xfs_mount *);
  * track the space used by the log vectors separately to prevent log space hangs
  * due to inaccurate accounting (i.e. a leak) of the used log space through the
  * CIL context ticket.
+ *
+ * We also add space for the xlog_op_header that describes this region in the
+ * log. This prepends the data region we return to the caller to copy their data
+ * into, so do all the static initialisation of the ophdr now. Because the ophdr
+ * is not 8 byte aligned, we have to be careful to ensure that we align the
+ * start of the buffer such that the region we return to the call is 8 byte
+ * aligned and packed against the tail of the ophdr.
  */
 void *
 xlog_prepare_iovec(
@@ -107,6 +114,9 @@ xlog_prepare_iovec(
 	uint			type)
 {
 	struct xfs_log_iovec	*vec = *vecp;
+	struct xlog_op_header	*oph;
+	uint32_t		len;
+	void			*buf;
 
 	if (vec) {
 		ASSERT(vec - lv->lv_iovecp < lv->lv_niovecs);
@@ -115,16 +125,25 @@ xlog_prepare_iovec(
 		vec = &lv->lv_iovecp[0];
 	}
 
-	if (!IS_ALIGNED(lv->lv_buf_len, sizeof(uint64_t)))
-		lv->lv_buf_len = round_up(lv->lv_buf_len, sizeof(uint64_t));
+	len = lv->lv_buf_len + sizeof(struct xlog_op_header);
+	if (!IS_ALIGNED(len, sizeof(uint64_t))) {
+		lv->lv_buf_len = round_up(len, sizeof(uint64_t)) -
+					sizeof(struct xlog_op_header);
+	}
 
 	vec->i_type = type;
 	vec->i_addr = lv->lv_buf + lv->lv_buf_len;
 
-	ASSERT(IS_ALIGNED((unsigned long)vec->i_addr, sizeof(uint64_t)));
+	oph = vec->i_addr;
+	oph->oh_clientid = XFS_TRANSACTION;
+	oph->oh_res2 = 0;
+	oph->oh_flags = 0;
+
+	buf = vec->i_addr + sizeof(struct xlog_op_header);
+	ASSERT(IS_ALIGNED((unsigned long)buf, sizeof(uint64_t)));
 
 	*vecp = vec;
-	return vec->i_addr;
+	return buf;
 }
 
 static void
@@ -2283,9 +2302,9 @@ xlog_print_trans(
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
@@ -2312,18 +2331,7 @@ xlog_write_calc_vec_length(
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
@@ -2333,7 +2341,6 @@ xlog_write_setup_ophdr(
 	struct xlog_op_header	*ophdr,
 	struct xlog_ticket	*ticket)
 {
-	ophdr->oh_tid = cpu_to_be32(ticket->t_tid);
 	ophdr->oh_clientid = XFS_TRANSACTION;
 	ophdr->oh_res2 = 0;
 	ophdr->oh_flags = 0;
@@ -2551,21 +2558,25 @@ xlog_write(
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
@@ -2583,20 +2594,11 @@ xlog_write(
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
index 391adc36931885..f4b96991870d85 100644
--- a/fs/xfs/xfs_log.h
+++ b/fs/xfs/xfs_log.h
@@ -27,6 +27,12 @@ void *xlog_prepare_iovec(struct xfs_log_vec *lv, struct xfs_log_iovec **vecp,
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
index 75c40c7e34de61..103031f784d58d 100644
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
@@ -441,11 +448,6 @@ xlog_cil_insert_items(
 
 	spin_lock(&cil->xc_cil_lock);
 
-	/* account for space used by new iovec headers  */
-	iovhdr_res = diff_iovecs * sizeof(xlog_op_header_t);
-	len += iovhdr_res;
-	ctx->nvecs += diff_iovecs;
-
 	/* attach the transaction to the CIL if it has any busy extents */
 	if (!list_empty(&tp->t_busy))
 		list_splice_init(&tp->t_busy, &ctx->busy_extents);
@@ -477,6 +479,7 @@ xlog_cil_insert_items(
 	}
 	tp->t_ticket->t_curr_res -= len;
 	ctx->space_used += len;
+	ctx->nvecs += diff_iovecs;
 
 	/*
 	 * If we've overrun the reservation, dump the tx details before we move
-- 
2.30.2


--dF9sR5IfDOwUtOGy--
