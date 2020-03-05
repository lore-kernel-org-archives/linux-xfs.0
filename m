Return-Path: <SRS0=4NJG=4W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,TVD_PH_BODY_ACCOUNTS_PRE autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB4E2C3F2CD
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Mar 2020 15:19:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B7D0D208CD
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Mar 2020 15:19:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Sa4HBHDu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726368AbgCEPTN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Mar 2020 10:19:13 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:46052 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726141AbgCEPTN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Mar 2020 10:19:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Twafj8jkRaBrKBY2Mpjz9OU6p0xLID6SJ0RKluZHUv0=; b=Sa4HBHDurgATAyX9BpnXAstbKF
        s1XHxt7l7oAtsIMeRUqKw+O1syYBOzSrGAzEm8+ViHLmsKHnIzMBPZv47XvfhZkT7qZMk6hWaBOOK
        tqkaxjiWclAN/5ZhZMbmVpcT6znMb8zlAnrO8UU3xfnGtjO3jpzBVRg1eZHAHBav0MyD5ZaCqHHJT
        qTZspIaagfG1voIJHICHD+rwCCdEy9LJZ0ZqMEdlabBvH8BI5+V9RhdgkRhmxcXeaQg3zR9yrpDw0
        IaGsLbWc4ZlDz3hoxvIYW58Rg+IDbrqWu78ZntdqVzrQa87jlnxiqvixicGEcqRikIz59CK2B+MfH
        cvl07RiA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j9sHI-0000sm-Vo; Thu, 05 Mar 2020 15:19:12 +0000
Date:   Thu, 5 Mar 2020 07:19:12 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/11] xfs: don't try to write a start record into every
 iclog
Message-ID: <20200305151912.GB8974@infradead.org>
References: <20200304075401.21558-1-david@fromorbit.com>
 <20200304075401.21558-2-david@fromorbit.com>
 <20200304154421.GA17565@infradead.org>
 <20200304212648.GZ10776@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200304212648.GZ10776@dread.disaster.area>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 05, 2020 at 08:26:48AM +1100, Dave Chinner wrote:
> > The last arg is used as a boolean in xlog_write_calc_vec_length. I
> > think it would make sense to have a need_start_rec boolean in this
> > function as well, and just hardcode the sizeof in the two places that
> > actually need the size.
> 
> I originally had that and while the code looked kinda weird
> opencoding an ophdr everywhere we wanted the size of a start record,
> that wasn't an issue. The biggest problem was that using a boolean
> resulted in _several_ logic bugs that I only tracked down once I
> realised I'd forgotten to replace existing the start record size
> variable that now wasn't initialised inside the inner loop.
> 
> So, yes, it gets converted to a boolean inside that function call,
> but I think the code in this set of nested loops is more reliable if
> it carries the size of the structure rather than open coding it
> everywhere. Making it a boolean doesn't improve the readability of
> the code at all.

I found the sized variable rather confusion.  Here is how I would
have done it, also more closely following the existing code.  Looking
at this I also think your current patch changes behavior in that
previously the start record was included in data_cnt, while now it
isn't.

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index f6006d94a581..7eb72792e1e6 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -2148,23 +2148,21 @@ xlog_print_trans(
 }
 
 /*
- * Calculate the potential space needed by the log vector.  Each region gets
- * its own xlog_op_header_t and may need to be double word aligned.
+ * Calculate the potential space needed by the log vector.  We may need a start
+ * record, and each region gets its own struct xlog_op_header and may need to be
+ * double word aligned.
  */
 static int
 xlog_write_calc_vec_length(
 	struct xlog_ticket	*ticket,
-	struct xfs_log_vec	*log_vector)
+	struct xfs_log_vec	*log_vector,
+	bool			need_start_rec)
 {
 	struct xfs_log_vec	*lv;
-	int			headers = 0;
+	int			headers = need_start_rec ? 1 : 0;
 	int			len = 0;
 	int			i;
 
-	/* acct for start rec of xact */
-	if (ticket->t_flags & XLOG_TIC_INITED)
-		headers++;
-
 	for (lv = log_vector; lv; lv = lv->lv_next) {
 		/* we don't write ordered log vectors */
 		if (lv->lv_buf_len == XFS_LOG_VEC_ORDERED)
@@ -2186,27 +2184,16 @@ xlog_write_calc_vec_length(
 	return len;
 }
 
-/*
- * If first write for transaction, insert start record  We can't be trying to
- * commit if we are inited.  We can't have any "partial_copy" if we are inited.
- */
-static int
+static void
 xlog_write_start_rec(
 	struct xlog_op_header	*ophdr,
 	struct xlog_ticket	*ticket)
 {
-	if (!(ticket->t_flags & XLOG_TIC_INITED))
-		return 0;
-
 	ophdr->oh_tid	= cpu_to_be32(ticket->t_tid);
 	ophdr->oh_clientid = ticket->t_clientid;
 	ophdr->oh_len = 0;
 	ophdr->oh_flags = XLOG_START_TRANS;
 	ophdr->oh_res2 = 0;
-
-	ticket->t_flags &= ~XLOG_TIC_INITED;
-
-	return sizeof(struct xlog_op_header);
 }
 
 static xlog_op_header_t *
@@ -2404,25 +2391,29 @@ xlog_write(
 	int			record_cnt = 0;
 	int			data_cnt = 0;
 	int			error = 0;
+	bool			need_start_rec = true;
 
 	*start_lsn = 0;
 
-	len = xlog_write_calc_vec_length(ticket, log_vector);
 
 	/*
 	 * Region headers and bytes are already accounted for.
 	 * We only need to take into account start records and
 	 * split regions in this function.
 	 */
-	if (ticket->t_flags & XLOG_TIC_INITED)
-		ticket->t_curr_res -= sizeof(xlog_op_header_t);
+	if (ticket->t_flags & XLOG_TIC_INITED) {
+		ticket->t_curr_res -= sizeof(struct xlog_op_header);
+		ticket->t_flags &= ~XLOG_TIC_INITED;
+	}
 
 	/*
 	 * Commit record headers need to be accounted for. These
 	 * come in as separate writes so are easy to detect.
 	 */
-	if (flags & (XLOG_COMMIT_TRANS | XLOG_UNMOUNT_TRANS))
-		ticket->t_curr_res -= sizeof(xlog_op_header_t);
+	if (flags & (XLOG_COMMIT_TRANS | XLOG_UNMOUNT_TRANS)) {
+		ticket->t_curr_res -= sizeof(struct xlog_op_header);
+		need_start_rec = false;
+	}
 
 	if (ticket->t_curr_res < 0) {
 		xfs_alert_tag(log->l_mp, XFS_PTAG_LOGRES,
@@ -2431,6 +2422,8 @@ xlog_write(
 		xfs_force_shutdown(log->l_mp, SHUTDOWN_LOG_IO_ERROR);
 	}
 
+	len = xlog_write_calc_vec_length(ticket, log_vector, need_start_rec);
+
 	index = 0;
 	lv = log_vector;
 	vecp = lv->lv_iovecp;
@@ -2457,7 +2450,6 @@ xlog_write(
 		while (lv && (!lv->lv_niovecs || index < lv->lv_niovecs)) {
 			struct xfs_log_iovec	*reg;
 			struct xlog_op_header	*ophdr;
-			int			start_rec_copy;
 			int			copy_len;
 			int			copy_off;
 			bool			ordered = false;
@@ -2473,11 +2465,15 @@ xlog_write(
 			ASSERT(reg->i_len % sizeof(int32_t) == 0);
 			ASSERT((unsigned long)ptr % sizeof(int32_t) == 0);
 
-			start_rec_copy = xlog_write_start_rec(ptr, ticket);
-			if (start_rec_copy) {
-				record_cnt++;
+			/*
+			 * Before we start formatting log vectors, we need to
+			 * write a start record. Only do this for the first
+			 * iclog we write to.
+			 */
+			if (need_start_rec) {
+				xlog_write_start_rec(ptr, ticket);
 				xlog_write_adv_cnt(&ptr, &len, &log_offset,
-						   start_rec_copy);
+						sizeof(struct xlog_op_header));
 			}
 
 			ophdr = xlog_write_setup_ophdr(log, ptr, ticket, flags);
@@ -2509,8 +2505,13 @@ xlog_write(
 				xlog_write_adv_cnt(&ptr, &len, &log_offset,
 						   copy_len);
 			}
-			copy_len += start_rec_copy + sizeof(xlog_op_header_t);
+			copy_len += sizeof(struct xlog_op_header);
 			record_cnt++;
+			if (need_start_rec) {
+				copy_len += sizeof(struct xlog_op_header);
+				record_cnt++;
+				need_start_rec = false;
+			}
 			data_cnt += contwr ? copy_len : 0;
 
 			error = xlog_write_copy_finish(log, iclog, flags,
