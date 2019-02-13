Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:53472 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732639AbfBMJxy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Feb 2019 04:53:54 -0500
From: Bob Liu <bob.liu@oracle.com>
Subject: [RFC PATCH v2 9/9] xfs: Add tracepoints and logging to alternate device retry
Date: Wed, 13 Feb 2019 17:50:44 +0800
Message-Id: <20190213095044.29628-10-bob.liu@oracle.com>
In-Reply-To: <20190213095044.29628-1-bob.liu@oracle.com>
References: <20190213095044.29628-1-bob.liu@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-block@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, martin.petersen@oracle.com, shirley.ma@oracle.com, allison.henderson@oracle.com, david@fromorbit.com, darrick.wong@oracle.com, hch@infradead.org, adilger@dilger.ca

From: Allison Henderson <allison.henderson@oracle.com>

This patch adds new log entries and trace points to the
alternate device retry error path

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/xfs_buf.c   | 10 ++++++++++
 fs/xfs/xfs_buf.h   |  1 +
 fs/xfs/xfs_trace.h |  6 +++++-
 3 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index e54dbc776d15..1a0427137883 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -847,6 +847,11 @@ xfs_buf_read_map(
 
 		for (i = 0; i <= retries; i++) {
 			bp->b_error = 0;
+
+			if (i > 0)
+				xfs_alert(bp->b_target->bt_mount,
+					  "Retrying read from disk %lu",i);
+
 			_xfs_buf_read(bp, flags);
 
 			switch (bp->b_error) {
@@ -854,6 +859,11 @@ xfs_buf_read_map(
 			case -EFSCORRUPTED:
 			case -EFSBADCRC:
 				/* loop again */
+				trace_xfs_buf_ioretry(bp, _RET_IP_);
+				xfs_alert(bp->b_target->bt_mount,
+					  "Read error:%d from disk number %lu",
+					   bp->b_error, *bp->b_rd_hint);
+
 				continue;
 			default:
 				goto retry_done;
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index af9bdff29e66..69605a50c15e 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -306,6 +306,7 @@ extern void __xfs_buf_ioerror(struct xfs_buf *bp, int error,
 		xfs_failaddr_t failaddr);
 #define xfs_buf_ioerror(bp, err) __xfs_buf_ioerror((bp), (err), __this_address)
 extern void xfs_buf_ioerror_alert(struct xfs_buf *, const char *func);
+extern void xfs_buf_ioretry_alert(struct xfs_buf *, const char *func);
 
 extern int __xfs_buf_submit(struct xfs_buf *bp, bool);
 static inline int xfs_buf_submit(struct xfs_buf *bp)
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 6fcc893dfc91..4b948cf2dd65 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -276,6 +276,7 @@ DECLARE_EVENT_CLASS(xfs_buf_class,
 		__field(int, pincount)
 		__field(unsigned, lockval)
 		__field(unsigned, flags)
+		__field(unsigned short, rd_hint)
 		__field(unsigned long, caller_ip)
 	),
 	TP_fast_assign(
@@ -289,10 +290,11 @@ DECLARE_EVENT_CLASS(xfs_buf_class,
 		__entry->pincount = atomic_read(&bp->b_pin_count);
 		__entry->lockval = bp->b_sema.count;
 		__entry->flags = bp->b_flags;
+		__entry->rd_hint = bp->b_rd_hint;
 		__entry->caller_ip = caller_ip;
 	),
 	TP_printk("dev %d:%d bno 0x%llx nblks 0x%x hold %d pincount %d "
-		  "lock %d flags %s caller %pS",
+		  "lock %d flags %s rd_hint %hu caller %pS",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  (unsigned long long)__entry->bno,
 		  __entry->nblks,
@@ -300,6 +302,7 @@ DECLARE_EVENT_CLASS(xfs_buf_class,
 		  __entry->pincount,
 		  __entry->lockval,
 		  __print_flags(__entry->flags, "|", XFS_BUF_FLAGS),
+		  __entry->rd_hint,
 		  (void *)__entry->caller_ip)
 )
 
@@ -312,6 +315,7 @@ DEFINE_BUF_EVENT(xfs_buf_free);
 DEFINE_BUF_EVENT(xfs_buf_hold);
 DEFINE_BUF_EVENT(xfs_buf_rele);
 DEFINE_BUF_EVENT(xfs_buf_iodone);
+DEFINE_BUF_EVENT(xfs_buf_ioretry);
 DEFINE_BUF_EVENT(xfs_buf_submit);
 DEFINE_BUF_EVENT(xfs_buf_lock);
 DEFINE_BUF_EVENT(xfs_buf_lock_done);
-- 
2.17.1
