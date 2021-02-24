Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FBD4C433E9
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Feb 2021 06:36:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4622C64EC9
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Feb 2021 06:36:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232631AbhBXGft (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Feb 2021 01:35:49 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:39888 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233491AbhBXGfp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Feb 2021 01:35:45 -0500
Received: from dread.disaster.area (pa49-179-130-210.pa.nsw.optusnet.com.au [49.179.130.210])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 79754827F53
        for <linux-xfs@vger.kernel.org>; Wed, 24 Feb 2021 17:35:03 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lEnlG-001lom-TU
        for linux-xfs@vger.kernel.org; Wed, 24 Feb 2021 17:35:02 +1100
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1lEnlG-00EQrA-M1
        for linux-xfs@vger.kernel.org; Wed, 24 Feb 2021 17:35:02 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 10/13] xfs: introduce xlog_write_single()
Date:   Wed, 24 Feb 2021 17:34:56 +1100
Message-Id: <20210224063459.3436852-11-david@fromorbit.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20210224063459.3436852-1-david@fromorbit.com>
References: <20210224063459.3436852-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0 cx=a_idp_d
        a=JD06eNgDs9tuHP7JIKoLzw==:117 a=JD06eNgDs9tuHP7JIKoLzw==:17
        a=qa6Q16uM49sA:10 a=20KFwNOVAAAA:8 a=qPJzbXnRhO7wPh-uoHkA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Vector out to an optimised version of xlog_write() if the entire
write will fit in a single iclog. This greatly simplifies the
implementation of writing a log vector chain into an iclog, and
sets the ground work for a much more understandable xlog_write()
implementation.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log.c | 69 +++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 68 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 50c7ed3972d7..456ab3294621 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -2243,6 +2243,64 @@ xlog_write_copy_finish(
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
+	struct xfs_log_iovec	*reg;
+	struct xlog_op_header	*ophdr;
+	void			*ptr;
+	int			index = 0;
+	int			record_cnt = 0;
+
+	ASSERT(log_offset + len <= iclog->ic_size);
+
+	ptr = iclog->ic_datap + log_offset;
+	while (lv && (!lv->lv_niovecs || index < lv->lv_niovecs)) {
+
+
+		/* ordered log vectors have no regions to write */
+		if (lv->lv_buf_len == XFS_LOG_VEC_ORDERED) {
+			ASSERT(lv->lv_niovecs == 0);
+			goto next_lv;
+		}
+
+		reg = &lv->lv_iovecp[index];
+		ASSERT(reg->i_len % sizeof(int32_t) == 0);
+		ASSERT((unsigned long)ptr % sizeof(int32_t) == 0);
+
+		ophdr = reg->i_addr;
+		ophdr->oh_tid = cpu_to_be32(ticket->t_tid);
+		ophdr->oh_len = cpu_to_be32(reg->i_len -
+					sizeof(struct xlog_op_header));
+
+		memcpy(ptr, reg->i_addr, reg->i_len);
+		xlog_write_adv_cnt(&ptr, &len, &log_offset, reg->i_len);
+		record_cnt++;
+
+		/* move to the next iovec */
+		if (++index < lv->lv_niovecs)
+			continue;
+next_lv:
+		/* move to the next logvec */
+		lv = lv->lv_next;
+		index = 0;
+	}
+	ASSERT(len == 0);
+	return record_cnt;
+}
+
+
 /*
  * Write some region out to in-core log
  *
@@ -2323,7 +2381,6 @@ xlog_write(
 			return error;
 
 		ASSERT(log_offset <= iclog->ic_size - 1);
-		ptr = iclog->ic_datap + log_offset;
 
 		/* Start_lsn is the first lsn written to. */
 		if (start_lsn && !*start_lsn)
@@ -2340,10 +2397,20 @@ xlog_write(
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

