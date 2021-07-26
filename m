Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50CC3C4338F
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Jul 2021 06:07:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 33F7760F0F
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Jul 2021 06:07:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231263AbhGZF06 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Jul 2021 01:26:58 -0400
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:56884 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231640AbhGZF05 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Jul 2021 01:26:57 -0400
Received: from dread.disaster.area (pa49-181-34-10.pa.nsw.optusnet.com.au [49.181.34.10])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id 1BE2E68BE
        for <linux-xfs@vger.kernel.org>; Mon, 26 Jul 2021 16:07:19 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1m7tlm-00AtQT-Sv
        for linux-xfs@vger.kernel.org; Mon, 26 Jul 2021 16:07:18 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1m7tlm-00DpCc-LB
        for linux-xfs@vger.kernel.org; Mon, 26 Jul 2021 16:07:18 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 10/10] xfs: need to see iclog flags in tracing
Date:   Mon, 26 Jul 2021 16:07:16 +1000
Message-Id: <20210726060716.3295008-11-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210726060716.3295008-1-david@fromorbit.com>
References: <20210726060716.3295008-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0
        a=hdaoRb6WoHYrV466vVKEyw==:117 a=hdaoRb6WoHYrV466vVKEyw==:17
        a=e_q4qTt1xDgA:10 a=20KFwNOVAAAA:8 a=adk7kjRAOmbrecc0ti4A:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Because I cannot tell if the NEED_FLUSH flag is being set correctly
by the log force and CIL push machinery without it.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log_priv.h | 13 ++++++++++---
 fs/xfs/xfs_trace.h    |  5 ++++-
 2 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 7cbde0b4f990..f3e79a45d60a 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -59,6 +59,16 @@ enum xlog_iclog_state {
 	{ XLOG_STATE_DIRTY,	"XLOG_STATE_DIRTY" }, \
 	{ XLOG_STATE_IOERROR,	"XLOG_STATE_IOERROR" }
 
+/*
+ * In core log flags
+ */
+#define XLOG_ICL_NEED_FLUSH	(1 << 0)	/* iclog needs REQ_PREFLUSH */
+#define XLOG_ICL_NEED_FUA	(1 << 1)	/* iclog needs REQ_FUA */
+
+#define XLOG_ICL_STRINGS \
+	{ XLOG_ICL_NEED_FLUSH,	"XLOG_ICL_NEED_FLUSH" }, \
+	{ XLOG_ICL_NEED_FUA,	"XLOG_ICL_NEED_FUA" }
+
 
 /*
  * Log ticket flags
@@ -143,9 +153,6 @@ enum xlog_iclog_state {
 
 #define XLOG_COVER_OPS		5
 
-#define XLOG_ICL_NEED_FLUSH	(1 << 0)	/* iclog needs REQ_PREFLUSH */
-#define XLOG_ICL_NEED_FUA	(1 << 1)	/* iclog needs REQ_FUA */
-
 /* Ticket reservation region accounting */ 
 #define XLOG_TIC_LEN_MAX	15
 
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index f9d8d605f9b1..19260291ff8b 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3944,6 +3944,7 @@ DECLARE_EVENT_CLASS(xlog_iclog_class,
 		__field(uint32_t, state)
 		__field(int32_t, refcount)
 		__field(uint32_t, offset)
+		__field(uint32_t, flags)
 		__field(unsigned long long, lsn)
 		__field(unsigned long, caller_ip)
 	),
@@ -3952,15 +3953,17 @@ DECLARE_EVENT_CLASS(xlog_iclog_class,
 		__entry->state = iclog->ic_state;
 		__entry->refcount = atomic_read(&iclog->ic_refcnt);
 		__entry->offset = iclog->ic_offset;
+		__entry->flags = iclog->ic_flags;
 		__entry->lsn = be64_to_cpu(iclog->ic_header.h_lsn);
 		__entry->caller_ip = caller_ip;
 	),
-	TP_printk("dev %d:%d state %s refcnt %d offset %u lsn 0x%llx caller %pS",
+	TP_printk("dev %d:%d state %s refcnt %d offset %u lsn 0x%llx flags %s caller %pS",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __print_symbolic(__entry->state, XLOG_STATE_STRINGS),
 		  __entry->refcount,
 		  __entry->offset,
 		  __entry->lsn,
+		  __print_flags(__entry->flags, "|", XLOG_ICL_STRINGS),
 		  (char *)__entry->caller_ip)
 
 );
-- 
2.31.1

