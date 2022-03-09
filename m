Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EF5CC433EF
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Mar 2022 05:29:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229449AbiCIFak (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Mar 2022 00:30:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229620AbiCIFak (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Mar 2022 00:30:40 -0500
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2D8E93DA6F
        for <linux-xfs@vger.kernel.org>; Tue,  8 Mar 2022 21:29:41 -0800 (PST)
Received: from dread.disaster.area (pa49-186-17-0.pa.vic.optusnet.com.au [49.186.17.0])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id A9157531125
        for <linux-xfs@vger.kernel.org>; Wed,  9 Mar 2022 16:29:40 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nRotH-003H5Q-Og
        for linux-xfs@vger.kernel.org; Wed, 09 Mar 2022 16:29:39 +1100
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1nRotH-00BJXM-Mv
        for linux-xfs@vger.kernel.org;
        Wed, 09 Mar 2022 16:29:39 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 11/16] xfs: introduce xlog_write_full()
Date:   Wed,  9 Mar 2022 16:29:32 +1100
Message-Id: <20220309052937.2696447-12-david@fromorbit.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220309052937.2696447-1-david@fromorbit.com>
References: <20220309052937.2696447-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=62283b44
        a=+dVDrTVfsjPpH/ci3UuFng==:117 a=+dVDrTVfsjPpH/ci3UuFng==:17
        a=o8Y5sQTvuykA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
        a=amZg4xYmHcCeHWh378EA:9 a=AjGcO6oz07-iQ99wixmX:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Introduce an optimised version of xlog_write() that is used when the
entire write will fit in a single iclog. This greatly simplifies the
implementation of writing a log vector chain into an iclog, and sets
the ground work for a much more understandable xlog_write()
implementation.

This incorporates some factoring and simplifications proposed by
Christoph Hellwig.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_log.c | 69 +++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 66 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index f26c85dbc765..6d93b2c96262 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -2224,6 +2224,58 @@ xlog_print_trans(
 	}
 }
 
+static inline void
+xlog_write_iovec(
+	struct xlog_in_core	*iclog,
+	uint32_t		*log_offset,
+	void			*data,
+	uint32_t		write_len,
+	int			*bytes_left,
+	uint32_t		*record_cnt,
+	uint32_t		*data_cnt)
+{
+	ASSERT(*log_offset % sizeof(int32_t) == 0);
+	ASSERT(write_len % sizeof(int32_t) == 0);
+
+	memcpy(iclog->ic_datap + *log_offset, data, write_len);
+	*log_offset += write_len;
+	*bytes_left -= write_len;
+	(*record_cnt)++;
+	*data_cnt += write_len;
+}
+
+/*
+ * Write log vectors into a single iclog which is guaranteed by the caller
+ * to have enough space to write the entire log vector into.
+ */
+static void
+xlog_write_full(
+	struct xfs_log_vec	*lv,
+	struct xlog_ticket	*ticket,
+	struct xlog_in_core	*iclog,
+	uint32_t		*log_offset,
+	uint32_t		*len,
+	uint32_t		*record_cnt,
+	uint32_t		*data_cnt)
+{
+	int			index;
+
+	ASSERT(*log_offset + *len <= iclog->ic_size);
+
+	/*
+	 * Ordered log vectors have no regions to write so this
+	 * loop will naturally skip them.
+	 */
+	for (index = 0; index < lv->lv_niovecs; index++) {
+		struct xfs_log_iovec	*reg = &lv->lv_iovecp[index];
+		struct xlog_op_header	*ophdr = reg->i_addr;
+
+		ophdr->oh_tid = cpu_to_be32(ticket->t_tid);
+		xlog_write_iovec(iclog, log_offset, reg->i_addr,
+				reg->i_len, len, record_cnt, data_cnt);
+	}
+}
+
 static xlog_op_header_t *
 xlog_write_setup_ophdr(
 	struct xlog_op_header	*ophdr,
@@ -2388,8 +2440,8 @@ xlog_write(
 	int			partial_copy = 0;
 	int			partial_copy_len = 0;
 	int			contwr = 0;
-	int			record_cnt = 0;
-	int			data_cnt = 0;
+	uint32_t		record_cnt = 0;
+	uint32_t		data_cnt = 0;
 	int			error = 0;
 
 	if (ticket->t_curr_res < 0) {
@@ -2409,7 +2461,6 @@ xlog_write(
 			return error;
 
 		ASSERT(log_offset <= iclog->ic_size - 1);
-		ptr = iclog->ic_datap + log_offset;
 
 		/*
 		 * If we have a context pointer, pass it the first iclog we are
@@ -2421,10 +2472,22 @@ xlog_write(
 			ctx = NULL;
 		}
 
+		/* If this is a single iclog write, go fast... */
+		if (!contwr && lv == log_vector) {
+			while (lv) {
+				xlog_write_full(lv, ticket, iclog, &log_offset,
+						 &len, &record_cnt, &data_cnt);
+				lv = lv->lv_next;
+			}
+			data_cnt = 0;
+			break;
+		}
+
 		/*
 		 * This loop writes out as many regions as can fit in the amount
 		 * of space which was allocated by xlog_state_get_iclog_space().
 		 */
+		ptr = iclog->ic_datap + log_offset;
 		while (lv && (!lv->lv_niovecs || index < lv->lv_niovecs)) {
 			struct xfs_log_iovec	*reg;
 			struct xlog_op_header	*ophdr;
-- 
2.33.0

