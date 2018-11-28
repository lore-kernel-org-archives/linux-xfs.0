Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:51018 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727303AbeK1Owq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Nov 2018 09:52:46 -0500
From: Allison Henderson <allison.henderson@oracle.com>
Subject: [PATCH v1 7/7] xfs: Add tracepoints and logging to alternate device retry
Date: Tue, 27 Nov 2018 20:49:51 -0700
Message-Id: <1543376991-5764-8-git-send-email-allison.henderson@oracle.com>
In-Reply-To: <1543376991-5764-1-git-send-email-allison.henderson@oracle.com>
References: <1543376991-5764-1-git-send-email-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-block@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: martin.petersen@oracle.com, shirley.ma@oracle.com, bob.liu@oracle.com, allison.henderson@oracle.com

This patch adds new log entries and trace points to the
alternate device retry error path

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/xfs_buf.c   | 14 +++++++++++++-
 fs/xfs/xfs_buf.h   |  1 +
 fs/xfs/xfs_trace.h |  6 +++++-
 3 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 81f6491..f203ddebe 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -833,6 +833,10 @@ xfs_buf_read_map(
 		for (i = 0; i <= blk_queue_get_mirrors(q); i++) {
 			bp->b_error = 0;
 			bp->b_rw_hint = i;
+
+			if (i > 0)
+				xfs_alert(bp->b_target->bt_mount,
+					  "Retrying read from disk %hu",i);
 			_xfs_buf_read(bp, flags);
 
 			switch (bp->b_error) {
@@ -840,6 +844,11 @@ xfs_buf_read_map(
 			case -EFSCORRUPTED:
 			case -EFSBADCRC:
 				/* loop again */
+				trace_xfs_buf_ioretry(bp, _RET_IP_);
+				xfs_alert(bp->b_target->bt_mount,
+					  "Read error:%d from disk number %hu",
+					   bp->b_error, bp->b_rw_hint);
+
 				continue;
 			default:
 				goto retry_done;
@@ -852,8 +861,11 @@ xfs_buf_read_map(
 		 * if we had to try more than one mirror to sucessfully read
 		 * the buffer, write the buffer back
 		 */
-		if (!bp->b_error && i > 0)
+		if (!bp->b_error && i > 0) {
+			xfs_alert(bp->b_target->bt_mount,
+				"Re-writeing verified data");
 			xfs_bwrite(bp);
+		}
 
 		return bp;
 	}
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index db138e5..23c9c3e 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -300,6 +300,7 @@ extern void __xfs_buf_ioerror(struct xfs_buf *bp, int error,
 		xfs_failaddr_t failaddr);
 #define xfs_buf_ioerror(bp, err) __xfs_buf_ioerror((bp), (err), __this_address)
 extern void xfs_buf_ioerror_alert(struct xfs_buf *, const char *func);
+extern void xfs_buf_ioretry_alert(struct xfs_buf *, const char *func);
 
 extern int __xfs_buf_submit(struct xfs_buf *bp, bool);
 static inline int xfs_buf_submit(struct xfs_buf *bp)
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 3043e5e..1d98a3e 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -276,6 +276,7 @@ DECLARE_EVENT_CLASS(xfs_buf_class,
 		__field(int, pincount)
 		__field(unsigned, lockval)
 		__field(unsigned, flags)
+		__field(unsigned short, rw_hint)
 		__field(unsigned long, caller_ip)
 	),
 	TP_fast_assign(
@@ -286,10 +287,11 @@ DECLARE_EVENT_CLASS(xfs_buf_class,
 		__entry->pincount = atomic_read(&bp->b_pin_count);
 		__entry->lockval = bp->b_sema.count;
 		__entry->flags = bp->b_flags;
+		__entry->rw_hint = bp->b_rw_hint;
 		__entry->caller_ip = caller_ip;
 	),
 	TP_printk("dev %d:%d bno 0x%llx nblks 0x%x hold %d pincount %d "
-		  "lock %d flags %s caller %pS",
+		  "lock %d flags %s rw_hint %hu caller %pS",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  (unsigned long long)__entry->bno,
 		  __entry->nblks,
@@ -297,6 +299,7 @@ DECLARE_EVENT_CLASS(xfs_buf_class,
 		  __entry->pincount,
 		  __entry->lockval,
 		  __print_flags(__entry->flags, "|", XFS_BUF_FLAGS),
+		  __entry->rw_hint,
 		  (void *)__entry->caller_ip)
 )
 
@@ -309,6 +312,7 @@ DEFINE_BUF_EVENT(xfs_buf_free);
 DEFINE_BUF_EVENT(xfs_buf_hold);
 DEFINE_BUF_EVENT(xfs_buf_rele);
 DEFINE_BUF_EVENT(xfs_buf_iodone);
+DEFINE_BUF_EVENT(xfs_buf_ioretry);
 DEFINE_BUF_EVENT(xfs_buf_submit);
 DEFINE_BUF_EVENT(xfs_buf_lock);
 DEFINE_BUF_EVENT(xfs_buf_lock_done);
-- 
2.7.4
