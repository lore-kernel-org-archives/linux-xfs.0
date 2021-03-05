Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69D19C43381
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Mar 2021 05:12:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4B5F165013
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Mar 2021 05:12:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229595AbhCEFM1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 5 Mar 2021 00:12:27 -0500
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:55937 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229597AbhCEFMC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Mar 2021 00:12:02 -0500
Received: from dread.disaster.area (pa49-179-130-210.pa.nsw.optusnet.com.au [49.179.130.210])
        by mail109.syd.optusnet.com.au (Postfix) with ESMTPS id 9F46E6294D
        for <linux-xfs@vger.kernel.org>; Fri,  5 Mar 2021 16:11:51 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lI2kh-00Fbp4-3e
        for linux-xfs@vger.kernel.org; Fri, 05 Mar 2021 16:11:51 +1100
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1lI2kg-000la6-SK
        for linux-xfs@vger.kernel.org; Fri, 05 Mar 2021 16:11:50 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 28/45] xfs: introduce xlog_write_single()
Date:   Fri,  5 Mar 2021 16:11:26 +1100
Message-Id: <20210305051143.182133-29-david@fromorbit.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20210305051143.182133-1-david@fromorbit.com>
References: <20210305051143.182133-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0 cx=a_idp_d
        a=JD06eNgDs9tuHP7JIKoLzw==:117 a=JD06eNgDs9tuHP7JIKoLzw==:17
        a=dESyimp9J3IA:10 a=20KFwNOVAAAA:8 a=S83ClQuvNvUpNviAnokA:9
        a=0bXxn9q0MV6snEgNplNhOjQmxlI=:19
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Introduce an optimised version of xlog_write() that is used when the
entire write will fit in a single iclog. This greatly simplifies the
implementation of writing a log vector chain into an iclog, and sets
the ground work for a much more understandable xlog_write()
implementation.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log.c | 57 +++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 56 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 22f97914ab99..590c1e6db475 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -2214,6 +2214,52 @@ xlog_write_copy_finish(
 	return error;
 }
 
+/*
+ * Write log vectors into a single iclog which is guaranteed by the caller
+ * to have enough space to write the entire log vector into. Return the number
+ * of log vectors written into the iclog.
+ */
+static int
+xlog_write_single(
+	struct xfs_log_vec	*log_vector,
+	struct xlog_ticket	*ticket,
+	struct xlog_in_core	*iclog,
+	uint32_t		log_offset,
+	uint32_t		len)
+{
+	struct xfs_log_vec	*lv = log_vector;
+	void			*ptr;
+	int			index = 0;
+	int			record_cnt = 0;
+
+	ASSERT(log_offset + len <= iclog->ic_size);
+
+	ptr = iclog->ic_datap + log_offset;
+	for (lv = log_vector; lv; lv = lv->lv_next) {
+		/*
+		 * Ordered log vectors have no regions to write so this
+		 * loop will naturally skip them.
+		 */
+		for (index = 0; index < lv->lv_niovecs; index++) {
+			struct xfs_log_iovec	*reg = &lv->lv_iovecp[index];
+			struct xlog_op_header	*ophdr = reg->i_addr;
+
+			ASSERT(reg->i_len % sizeof(int32_t) == 0);
+			ASSERT((unsigned long)ptr % sizeof(int32_t) == 0);
+
+			ophdr->oh_tid = cpu_to_be32(ticket->t_tid);
+			ophdr->oh_len = cpu_to_be32(reg->i_len -
+						sizeof(struct xlog_op_header));
+			memcpy(ptr, reg->i_addr, reg->i_len);
+			xlog_write_adv_cnt(&ptr, &len, &log_offset, reg->i_len);
+			record_cnt++;
+		}
+	}
+	ASSERT(len == 0);
+	return record_cnt;
+}
+
+
 /*
  * Write some region out to in-core log
  *
@@ -2294,7 +2340,6 @@ xlog_write(
 			return error;
 
 		ASSERT(log_offset <= iclog->ic_size - 1);
-		ptr = iclog->ic_datap + log_offset;
 
 		/* Start_lsn is the first lsn written to. */
 		if (start_lsn && !*start_lsn)
@@ -2311,10 +2356,20 @@ xlog_write(
 						XLOG_ICL_NEED_FUA);
 		}
 
+		/* If this is a single iclog write, go fast... */
+		if (!contwr && lv == log_vector) {
+			record_cnt = xlog_write_single(lv, ticket, iclog,
+						log_offset, len);
+			len = 0;
+			data_cnt = len;
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
2.28.0

