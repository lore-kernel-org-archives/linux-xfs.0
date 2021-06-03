Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFA90C47096
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Jun 2021 05:23:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B170561359
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Jun 2021 05:23:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229818AbhFCFYw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Jun 2021 01:24:52 -0400
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:46514 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229813AbhFCFYv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Jun 2021 01:24:51 -0400
Received: from dread.disaster.area (pa49-179-138-183.pa.nsw.optusnet.com.au [49.179.138.183])
        by mail109.syd.optusnet.com.au (Postfix) with ESMTPS id 832E9681AF
        for <linux-xfs@vger.kernel.org>; Thu,  3 Jun 2021 15:22:51 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lofog-008Mqj-TV
        for linux-xfs@vger.kernel.org; Thu, 03 Jun 2021 15:22:50 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1lofog-000im0-LI
        for linux-xfs@vger.kernel.org; Thu, 03 Jun 2021 15:22:50 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 17/39] xfs: move log iovec alignment to preparation function
Date:   Thu,  3 Jun 2021 15:22:18 +1000
Message-Id: <20210603052240.171998-18-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210603052240.171998-1-david@fromorbit.com>
References: <20210603052240.171998-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=MnllW2CieawZLw/OcHE/Ng==:117 a=MnllW2CieawZLw/OcHE/Ng==:17
        a=r6YtysWOX24A:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8
        a=H4FU2hCJ8sVSBq7siF0A:9 a=AjGcO6oz07-iQ99wixmX:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

To include log op headers directly into the log iovec regions that
the ophdrs wrap, we need to move the buffer alignment code from
xlog_finish_iovec() to xlog_prepare_iovec(). This is because the
xlog_op_header is only 12 bytes long, and we need the buffer that
the caller formats their data into to be 8 byte aligned.

Hence once we start prepending the ophdr in xlog_prepare_iovec(), we
are going to need to manage the padding directly to ensure that the
buffer pointer returned is correctly aligned.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_log.h | 25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
index c0c3141944ea..1ca4f2edbdaf 100644
--- a/fs/xfs/xfs_log.h
+++ b/fs/xfs/xfs_log.h
@@ -21,6 +21,16 @@ struct xfs_log_vec {
 
 #define XFS_LOG_VEC_ORDERED	(-1)
 
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
 static inline void *
 xlog_prepare_iovec(struct xfs_log_vec *lv, struct xfs_log_iovec **vecp,
 		uint type)
@@ -34,6 +44,9 @@ xlog_prepare_iovec(struct xfs_log_vec *lv, struct xfs_log_iovec **vecp,
 		vec = &lv->lv_iovecp[0];
 	}
 
+	if (!IS_ALIGNED(lv->lv_buf_len, sizeof(uint64_t)))
+		lv->lv_buf_len = round_up(lv->lv_buf_len, sizeof(uint64_t));
+
 	vec->i_type = type;
 	vec->i_addr = lv->lv_buf + lv->lv_buf_len;
 
@@ -43,20 +56,10 @@ xlog_prepare_iovec(struct xfs_log_vec *lv, struct xfs_log_iovec **vecp,
 	return vec->i_addr;
 }
 
-/*
- * We need to make sure the next buffer is naturally aligned for the biggest
- * basic data type we put into it.  We already accounted for this padding when
- * sizing the buffer.
- *
- * However, this padding does not get written into the log, and hence we have to
- * track the space used by the log vectors separately to prevent log space hangs
- * due to inaccurate accounting (i.e. a leak) of the used log space through the
- * CIL context ticket.
- */
 static inline void
 xlog_finish_iovec(struct xfs_log_vec *lv, struct xfs_log_iovec *vec, int len)
 {
-	lv->lv_buf_len += round_up(len, sizeof(uint64_t));
+	lv->lv_buf_len += len;
 	lv->lv_bytes += len;
 	vec->i_len = len;
 }
-- 
2.31.1

