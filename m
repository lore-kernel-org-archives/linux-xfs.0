Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44557 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754168AbdGJN2C (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 10 Jul 2017 09:28:02 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D5F1EC04B310
        for <linux-xfs@vger.kernel.org>; Mon, 10 Jul 2017 13:28:01 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-20.bos.redhat.com [10.18.41.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BAD967D50B
        for <linux-xfs@vger.kernel.org>; Mon, 10 Jul 2017 13:28:01 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 6/6] xfs: add log recovery tracepoint for head/tail
Date: Mon, 10 Jul 2017 09:28:00 -0400
Message-Id: <20170710132800.19506-7-bfoster@redhat.com>
In-Reply-To: <20170710132800.19506-1-bfoster@redhat.com>
References: <20170710132800.19506-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Torn write detection and tail overwrite detection can shift the log
head and tail respectively in the event of CRC mismatch or
corruption errors. Add a high-level log recovery tracepoint to dump
the final log head/tail and make those values easily attainable in
debug/diagnostic situations.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_log_recover.c |  2 ++
 fs/xfs/xfs_trace.h       | 18 ++++++++++++++++++
 2 files changed, 20 insertions(+)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 2e34797..dd2ad2a 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -5598,6 +5598,8 @@ xlog_do_recover(
 	xfs_buf_t	*bp;
 	xfs_sb_t	*sbp;
 
+	trace_xfs_log_recover(log, head_blk, tail_blk);
+
 	/*
 	 * First replay the images in the log.
 	 */
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index bcc3cdf..6881047 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -1963,6 +1963,24 @@ DEFINE_EVENT(xfs_swap_extent_class, name, \
 DEFINE_SWAPEXT_EVENT(xfs_swap_extent_before);
 DEFINE_SWAPEXT_EVENT(xfs_swap_extent_after);
 
+TRACE_EVENT(xfs_log_recover,
+	TP_PROTO(struct xlog *log, xfs_daddr_t headblk, xfs_daddr_t tailblk),
+	TP_ARGS(log, headblk, tailblk),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_daddr_t, headblk)
+		__field(xfs_daddr_t, tailblk)
+	),
+	TP_fast_assign(
+		__entry->dev = log->l_mp->m_super->s_dev;
+		__entry->headblk = headblk;
+		__entry->tailblk = tailblk;
+	),
+	TP_printk("dev %d:%d headblk 0x%llx tailblk 0x%llx",
+		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->headblk,
+		  __entry->tailblk)
+)
+
 TRACE_EVENT(xfs_log_recover_record,
 	TP_PROTO(struct xlog *log, struct xlog_rec_header *rhead, int pass),
 	TP_ARGS(log, rhead, pass),
-- 
2.9.4

