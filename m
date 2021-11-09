Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F554C4167B
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Nov 2021 01:51:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 130DE61105
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Nov 2021 01:51:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237370AbhKIBxs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 8 Nov 2021 20:53:48 -0500
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:40624 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240143AbhKIBxq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 8 Nov 2021 20:53:46 -0500
Received: from dread.disaster.area (pa49-195-103-97.pa.nsw.optusnet.com.au [49.195.103.97])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id 19B901B8A82
        for <linux-xfs@vger.kernel.org>; Tue,  9 Nov 2021 12:50:59 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mkGHq-006ZXr-3s
        for linux-xfs@vger.kernel.org; Tue, 09 Nov 2021 12:50:58 +1100
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1mkGHq-006UcN-2W
        for linux-xfs@vger.kernel.org;
        Tue, 09 Nov 2021 12:50:58 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 02/16] xfs: only CIL pushes require a start record
Date:   Tue,  9 Nov 2021 12:50:41 +1100
Message-Id: <20211109015055.1547604-3-david@fromorbit.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109015055.1547604-1-david@fromorbit.com>
References: <20211109015055.1547604-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=epq8cqlX c=1 sm=1 tr=0 ts=6189d403
        a=fP9RlOTWD4uZJjPSFnn6Ew==:117 a=fP9RlOTWD4uZJjPSFnn6Ew==:17
        a=vIxV3rELxO4A:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8
        a=KPKL3CcRt_6iA-bUn9MA:9 a=AjGcO6oz07-iQ99wixmX:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

So move the one-off start record writing in xlog_write() out into
the static header that the CIL push builds to write into the log
initially. This simplifes the xlog_write() logic a lot.

pahole on x86-64 confirms that the xlog_cil_trans_hdr is correctly
32 bit aligned and packed for copying the log op and transaction
headers directly into the log as a single log region copy.

struct xlog_cil_trans_hdr {
        struct xlog_op_header      oph[2];               /*     0    24 */
        struct xfs_trans_header    thdr;                 /*    24    16 */
        struct xfs_log_iovec       lhdr[2];              /*    40    32 */

        /* size: 72, cachelines: 2, members: 3 */
        /* last cacheline: 8 bytes */
};

A wart is needed to handle the fact that length of the region the
opheader points to doesn't include the opheader length. hence if
we embed the opheader, we have to substract the opheader length from
the length written into the opheader by the generic copying code.
This will eventually go away when everything is converted to
embedded opheaders.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_log.c     | 90 ++++++++++++++++++++++----------------------
 fs/xfs/xfs_log_cil.c | 44 ++++++++++++++++++----
 2 files changed, 81 insertions(+), 53 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 89fec9a18c34..e2953ce470de 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -2235,9 +2235,9 @@ xlog_print_trans(
 }
 
 /*
- * Calculate the potential space needed by the log vector.  We may need a start
- * record, and each region gets its own struct xlog_op_header and may need to be
- * double word aligned.
+ * Calculate the potential space needed by the log vector. If this is a start
+ * transaction, the caller has already accounted for both opheaders in the start
+ * transaction, so we don't need to account for them here.
  */
 static int
 xlog_write_calc_vec_length(
@@ -2250,9 +2250,6 @@ xlog_write_calc_vec_length(
 	int			len = 0;
 	int			i;
 
-	if (optype & XLOG_START_TRANS)
-		headers++;
-
 	for (lv = log_vector; lv; lv = lv->lv_next) {
 		/* we don't write ordered log vectors */
 		if (lv->lv_buf_len == XFS_LOG_VEC_ORDERED)
@@ -2268,24 +2265,20 @@ xlog_write_calc_vec_length(
 		}
 	}
 
+	/* Don't account for regions with embedded ophdrs */
+	if (optype && headers > 0) {
+		if (optype & XLOG_START_TRANS) {
+			ASSERT(headers >= 2);
+			headers -= 2;
+		}
+	}
+
 	ticket->t_res_num_ophdrs += headers;
 	len += headers * sizeof(struct xlog_op_header);
 
 	return len;
 }
 
-static void
-xlog_write_start_rec(
-	struct xlog_op_header	*ophdr,
-	struct xlog_ticket	*ticket)
-{
-	ophdr->oh_tid	= cpu_to_be32(ticket->t_tid);
-	ophdr->oh_clientid = ticket->t_clientid;
-	ophdr->oh_len = 0;
-	ophdr->oh_flags = XLOG_START_TRANS;
-	ophdr->oh_res2 = 0;
-}
-
 static xlog_op_header_t *
 xlog_write_setup_ophdr(
 	struct xlog		*log,
@@ -2481,9 +2474,11 @@ xlog_write(
 	 * If this is a commit or unmount transaction, we don't need a start
 	 * record to be written.  We do, however, have to account for the
 	 * commit or unmount header that gets written. Hence we always have
-	 * to account for an extra xlog_op_header here.
+	 * to account for an extra xlog_op_header here for commit and unmount
+	 * records.
 	 */
-	ticket->t_curr_res -= sizeof(struct xlog_op_header);
+	if (optype & (XLOG_COMMIT_TRANS | XLOG_UNMOUNT_TRANS))
+		ticket->t_curr_res -= sizeof(struct xlog_op_header);
 	if (ticket->t_curr_res < 0) {
 		xfs_alert_tag(log->l_mp, XFS_PTAG_LOGRES,
 		     "ctx ticket reservation ran out. Need to up reservation");
@@ -2524,7 +2519,7 @@ xlog_write(
 			int			copy_len;
 			int			copy_off;
 			bool			ordered = false;
-			bool			wrote_start_rec = false;
+			bool			added_ophdr = false;
 
 			/* ordered log vectors have no regions to write */
 			if (lv->lv_buf_len == XFS_LOG_VEC_ORDERED) {
@@ -2538,25 +2533,24 @@ xlog_write(
 			ASSERT((unsigned long)ptr % sizeof(int32_t) == 0);
 
 			/*
-			 * Before we start formatting log vectors, we need to
-			 * write a start record. Only do this for the first
-			 * iclog we write to.
+			 * The XLOG_START_TRANS has embedded ophdrs for the
+			 * start record and transaction header. They will always
+			 * be the first two regions in the lv chain.
 			 */
 			if (optype & XLOG_START_TRANS) {
-				xlog_write_start_rec(ptr, ticket);
-				xlog_write_adv_cnt(&ptr, &len, &log_offset,
-						sizeof(struct xlog_op_header));
-				optype &= ~XLOG_START_TRANS;
-				wrote_start_rec = true;
-			}
-
-			ophdr = xlog_write_setup_ophdr(log, ptr, ticket, optype);
-			if (!ophdr)
-				return -EIO;
+				ophdr = reg->i_addr;
+				if (index)
+					optype &= ~XLOG_START_TRANS;
+			} else {
+				ophdr = xlog_write_setup_ophdr(log, ptr,
+							ticket, optype);
+				if (!ophdr)
+					return -EIO;
 
-			xlog_write_adv_cnt(&ptr, &len, &log_offset,
+				xlog_write_adv_cnt(&ptr, &len, &log_offset,
 					   sizeof(struct xlog_op_header));
-
+				added_ophdr = true;
+			}
 			len += xlog_write_setup_copy(ticket, ophdr,
 						     iclog->ic_size-log_offset,
 						     reg->i_len,
@@ -2565,13 +2559,22 @@ xlog_write(
 						     &partial_copy_len);
 			xlog_verify_dest_ptr(log, ptr);
 
+
+			/*
+			 * Wart: need to update length in embedded ophdr not
+			 * to include it's own length.
+			 */
+			if (!added_ophdr) {
+				ophdr->oh_len = cpu_to_be32(copy_len -
+						sizeof(struct xlog_op_header));
+			}
 			/*
 			 * Copy region.
 			 *
-			 * Unmount records just log an opheader, so can have
-			 * empty payloads with no data region to copy. Hence we
-			 * only copy the payload if the vector says it has data
-			 * to copy.
+			 * Commit and unmount records just log an opheader, so
+			 * we can have empty payloads with no data region to
+			 * copy.  Hence we only copy the payload if the vector
+			 * says it has data to copy.
 			 */
 			ASSERT(copy_len >= 0);
 			if (copy_len > 0) {
@@ -2579,12 +2582,9 @@ xlog_write(
 				xlog_write_adv_cnt(&ptr, &len, &log_offset,
 						   copy_len);
 			}
-			copy_len += sizeof(struct xlog_op_header);
-			record_cnt++;
-			if (wrote_start_rec) {
+			if (added_ophdr)
 				copy_len += sizeof(struct xlog_op_header);
-				record_cnt++;
-			}
+			record_cnt++;
 			data_cnt += contwr ? copy_len : 0;
 
 			error = xlog_write_copy_finish(log, iclog, optype,
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 28f8104fbef1..560af08d81dc 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -835,14 +835,22 @@ xlog_cil_write_commit_record(
 }
 
 struct xlog_cil_trans_hdr {
+	struct xlog_op_header	oph[2];
 	struct xfs_trans_header	thdr;
-	struct xfs_log_iovec	lhdr;
+	struct xfs_log_iovec	lhdr[2];
 };
 
 /*
  * Build a checkpoint transaction header to begin the journal transaction.  We
  * need to account for the space used by the transaction header here as it is
  * not accounted for in xlog_write().
+ *
+ * This is the only place we write a transaction header, so we also build the
+ * log opheaders that indicate the start of a log transaction and wrap the
+ * transaction header. We keep the start record in it's own log vector rather
+ * than compacting them into a single region as this ends up making the logic
+ * in xlog_write() for handling empty opheaders for start, commit and unmount
+ * records much simpler.
  */
 static void
 xlog_cil_build_trans_hdr(
@@ -852,20 +860,40 @@ xlog_cil_build_trans_hdr(
 	int			num_iovecs)
 {
 	struct xlog_ticket	*tic = ctx->ticket;
+	uint32_t		tid = cpu_to_be32(tic->t_tid);
 
 	memset(hdr, 0, sizeof(*hdr));
 
+	/* Log start record */
+	hdr->oph[0].oh_tid = tid;
+	hdr->oph[0].oh_clientid = XFS_TRANSACTION;
+	hdr->oph[0].oh_flags = XLOG_START_TRANS;
+
+	/* log iovec region pointer */
+	hdr->lhdr[0].i_addr = &hdr->oph[0];
+	hdr->lhdr[0].i_len = sizeof(struct xlog_op_header);
+	hdr->lhdr[0].i_type = XLOG_REG_TYPE_LRHEADER;
+
+	/* log opheader */
+	hdr->oph[1].oh_tid = tid;
+	hdr->oph[1].oh_clientid = XFS_TRANSACTION;
+
+	/* transaction header */
 	hdr->thdr.th_magic = XFS_TRANS_HEADER_MAGIC;
 	hdr->thdr.th_type = XFS_TRANS_CHECKPOINT;
-	hdr->thdr.th_tid = tic->t_tid;
+	hdr->thdr.th_tid = tid;
 	hdr->thdr.th_num_items = num_iovecs;
-	hdr->lhdr.i_addr = &hdr->thdr;
-	hdr->lhdr.i_len = sizeof(xfs_trans_header_t);
-	hdr->lhdr.i_type = XLOG_REG_TYPE_TRANSHDR;
-	tic->t_curr_res -= hdr->lhdr.i_len + sizeof(struct xlog_op_header);
 
-	lvhdr->lv_niovecs = 1;
-	lvhdr->lv_iovecp = &hdr->lhdr;
+	/* log iovec region pointer */
+	hdr->lhdr[1].i_addr = &hdr->oph[1];
+	hdr->lhdr[1].i_len = sizeof(struct xlog_op_header) +
+				sizeof(struct xfs_trans_header);
+	hdr->lhdr[1].i_type = XLOG_REG_TYPE_TRANSHDR;
+
+	tic->t_curr_res -= hdr->lhdr[0].i_len + hdr->lhdr[1].i_len;
+
+	lvhdr->lv_niovecs = 2;
+	lvhdr->lv_iovecp = &hdr->lhdr[0];
 	lvhdr->lv_next = ctx->lv_chain;
 }
 
-- 
2.33.0

