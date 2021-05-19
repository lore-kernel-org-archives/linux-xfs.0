Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93356C4361A
	for <linux-xfs@archiver.kernel.org>; Wed, 19 May 2021 12:13:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D85961040
	for <linux-xfs@archiver.kernel.org>; Wed, 19 May 2021 12:13:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346316AbhESMOr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 May 2021 08:14:47 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:49200 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1346400AbhESMOo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 May 2021 08:14:44 -0400
Received: from dread.disaster.area (pa49-195-118-180.pa.nsw.optusnet.com.au [49.195.118.180])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 9CA28861562
        for <linux-xfs@vger.kernel.org>; Wed, 19 May 2021 22:13:20 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ljL4i-002m1N-5y
        for linux-xfs@vger.kernel.org; Wed, 19 May 2021 22:13:20 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1ljL4h-002SHS-UJ
        for linux-xfs@vger.kernel.org; Wed, 19 May 2021 22:13:19 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 21/39] xfs: introduce xlog_write_single()
Date:   Wed, 19 May 2021 22:12:59 +1000
Message-Id: <20210519121317.585244-22-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210519121317.585244-1-david@fromorbit.com>
References: <20210519121317.585244-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=xcwBwyABtj18PbVNKPPJDQ==:117 a=xcwBwyABtj18PbVNKPPJDQ==:17
        a=5FLXtPjwQuUA:10 a=20KFwNOVAAAA:8 a=S83ClQuvNvUpNviAnokA:9
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
index 58f9aafce29e..3b74d21e3786 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -2225,6 +2225,52 @@ xlog_write_copy_finish(
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
+	struct xfs_log_vec	*lv;
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
@@ -2305,16 +2351,25 @@ xlog_write(
 			return error;
 
 		ASSERT(log_offset <= iclog->ic_size - 1);
-		ptr = iclog->ic_datap + log_offset;
 
 		/* Start_lsn is the first lsn written to. */
 		if (start_lsn && !*start_lsn)
 			*start_lsn = be64_to_cpu(iclog->ic_header.h_lsn);
 
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
2.31.1

