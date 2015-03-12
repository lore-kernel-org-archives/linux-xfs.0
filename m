Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id ABF3E7F50
	for <xfs@oss.sgi.com>; Wed, 11 Mar 2015 22:15:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 998A8304039
	for <xfs@oss.sgi.com>; Wed, 11 Mar 2015 20:15:00 -0700 (PDT)
Received: from na01-by2-obe.outbound.protection.outlook.com
	(mail-by2on0124.outbound.protection.outlook.com
	[207.46.100.124]) by cuda.sgi.com with ESMTP id
	rrDtwXUvJw1SpLia (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 11 Mar 2015 20:14:59 -0700 (PDT)
From: Scott Wood <scottwood@freescale.com>
Subject: [PATCH 21/22] xfs: %pF is only for function pointers
Date: Wed, 11 Mar 2015 22:13:56 -0500
Message-ID: <1426130037-17956-21-git-send-email-scottwood@freescale.com>
In-Reply-To: <1426130037-17956-1-git-send-email-scottwood@freescale.com>
References: <1426130037-17956-1-git-send-email-scottwood@freescale.com>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: trivial@kernel.org, linux-kernel@vger.kernel.org
Cc: Scott Wood <scottwood@freescale.com>, xfs@oss.sgi.com

Use %pS for actual addresses, otherwise you'll get bad output
on arches like ppc64 where %pF expects a function descriptor.

Signed-off-by: Scott Wood <scottwood@freescale.com>
Cc: xfs@oss.sgi.com
---
 fs/xfs/xfs_error.c |  2 +-
 fs/xfs/xfs_trace.h | 20 ++++++++++----------
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index 3ee186a..338e50b 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -131,7 +131,7 @@ xfs_error_report(
 {
 	if (level <= xfs_error_level) {
 		xfs_alert_tag(mp, XFS_PTAG_ERROR_REPORT,
-		"Internal error %s at line %d of file %s.  Caller %pF",
+		"Internal error %s at line %d of file %s.  Caller %pS",
 			    tag, linenum, filename, ra);
 
 		xfs_stack_trace();
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 51372e3..b5ac81e 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -115,7 +115,7 @@ DECLARE_EVENT_CLASS(xfs_perag_class,
 		__entry->refcount = refcount;
 		__entry->caller_ip = caller_ip;
 	),
-	TP_printk("dev %d:%d agno %u refcount %d caller %pf",
+	TP_printk("dev %d:%d agno %u refcount %d caller %ps",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->agno,
 		  __entry->refcount,
@@ -239,7 +239,7 @@ TRACE_EVENT(xfs_iext_insert,
 		__entry->caller_ip = caller_ip;
 	),
 	TP_printk("dev %d:%d ino 0x%llx state %s idx %ld "
-		  "offset %lld block %lld count %lld flag %d caller %pf",
+		  "offset %lld block %lld count %lld flag %d caller %ps",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
 		  __print_flags(__entry->bmap_state, "|", XFS_BMAP_EXT_FLAGS),
@@ -283,7 +283,7 @@ DECLARE_EVENT_CLASS(xfs_bmap_class,
 		__entry->caller_ip = caller_ip;
 	),
 	TP_printk("dev %d:%d ino 0x%llx state %s idx %ld "
-		  "offset %lld block %lld count %lld flag %d caller %pf",
+		  "offset %lld block %lld count %lld flag %d caller %ps",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
 		  __print_flags(__entry->bmap_state, "|", XFS_BMAP_EXT_FLAGS),
@@ -329,7 +329,7 @@ DECLARE_EVENT_CLASS(xfs_buf_class,
 		__entry->caller_ip = caller_ip;
 	),
 	TP_printk("dev %d:%d bno 0x%llx nblks 0x%x hold %d pincount %d "
-		  "lock %d flags %s caller %pf",
+		  "lock %d flags %s caller %ps",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  (unsigned long long)__entry->bno,
 		  __entry->nblks,
@@ -402,7 +402,7 @@ DECLARE_EVENT_CLASS(xfs_buf_flags_class,
 		__entry->caller_ip = caller_ip;
 	),
 	TP_printk("dev %d:%d bno 0x%llx len 0x%zx hold %d pincount %d "
-		  "lock %d flags %s caller %pf",
+		  "lock %d flags %s caller %ps",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  (unsigned long long)__entry->bno,
 		  __entry->buffer_length,
@@ -447,7 +447,7 @@ TRACE_EVENT(xfs_buf_ioerror,
 		__entry->caller_ip = caller_ip;
 	),
 	TP_printk("dev %d:%d bno 0x%llx len 0x%zx hold %d pincount %d "
-		  "lock %d error %d flags %s caller %pf",
+		  "lock %d error %d flags %s caller %ps",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  (unsigned long long)__entry->bno,
 		  __entry->buffer_length,
@@ -613,7 +613,7 @@ DECLARE_EVENT_CLASS(xfs_lock_class,
 		__entry->lock_flags = lock_flags;
 		__entry->caller_ip = caller_ip;
 	),
-	TP_printk("dev %d:%d ino 0x%llx flags %s caller %pf",
+	TP_printk("dev %d:%d ino 0x%llx flags %s caller %ps",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
 		  __print_flags(__entry->lock_flags, "|", XFS_LOCK_FLAGS),
@@ -702,7 +702,7 @@ DECLARE_EVENT_CLASS(xfs_iref_class,
 		__entry->pincount = atomic_read(&ip->i_pincount);
 		__entry->caller_ip = caller_ip;
 	),
-	TP_printk("dev %d:%d ino 0x%llx count %d pincount %d caller %pf",
+	TP_printk("dev %d:%d ino 0x%llx count %d pincount %d caller %ps",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
 		  __entry->count,
@@ -1333,7 +1333,7 @@ TRACE_EVENT(xfs_bunmap,
 		__entry->flags = flags;
 	),
 	TP_printk("dev %d:%d ino 0x%llx size 0x%llx bno 0x%llx len 0x%llx"
-		  "flags %s caller %pf",
+		  "flags %s caller %ps",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
 		  __entry->size,
@@ -1466,7 +1466,7 @@ TRACE_EVENT(xfs_agf,
 	),
 	TP_printk("dev %d:%d agno %u flags %s length %u roots b %u c %u "
 		  "levels b %u c %u flfirst %u fllast %u flcount %u "
-		  "freeblks %u longest %u caller %pf",
+		  "freeblks %u longest %u caller %ps",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->agno,
 		  __print_flags(__entry->flags, "|", XFS_AGF_FLAGS),
-- 
2.1.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
