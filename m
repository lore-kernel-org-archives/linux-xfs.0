Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:48443 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752118AbdIQVHa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 17 Sep 2017 17:07:30 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 30/47] xfs: add log recovery tracepoint for head/tail
Date: Sun, 17 Sep 2017 14:06:55 -0700
Message-Id: <20170917210712.10804-31-hch@lst.de>
In-Reply-To: <20170917210712.10804-1-hch@lst.de>
References: <20170917210712.10804-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>, "Darrick J . Wong" <darrick.wong@oracle.com>

From: Brian Foster <bfoster@redhat.com>

commit e67d3d4246e5fbb0c7c700426d11241ca9c6f473 upstream.

Torn write detection and tail overwrite detection can shift the log
head and tail respectively in the event of CRC mismatch or
corruption errors. Add a high-level log recovery tracepoint to dump
the final log head/tail and make those values easily attainable in
debug/diagnostic situations.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_log_recover.c |  2 ++
 fs/xfs/xfs_trace.h       | 18 ++++++++++++++++++
 2 files changed, 20 insertions(+)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 83e90bf1899f..edd849b8f14d 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -5596,6 +5596,8 @@ xlog_do_recover(
 	xfs_buf_t	*bp;
 	xfs_sb_t	*sbp;
 
+	trace_xfs_log_recover(log, head_blk, tail_blk);
+
 	/*
 	 * First replay the images in the log.
 	 */
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 2df73f3a73c1..6221c3818c6e 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -1991,6 +1991,24 @@ DEFINE_EVENT(xfs_swap_extent_class, name, \
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
2.14.1

