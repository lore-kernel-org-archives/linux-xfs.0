Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:47068 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751897AbeAXCS4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Jan 2018 21:18:56 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w0O27lJT066504
        for <linux-xfs@vger.kernel.org>; Wed, 24 Jan 2018 02:18:55 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2120.oracle.com with ESMTP id 2fpgyjg1hx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 24 Jan 2018 02:18:55 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w0O2IsXI013728
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Wed, 24 Jan 2018 02:18:54 GMT
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w0O2IskJ007644
        for <linux-xfs@vger.kernel.org>; Wed, 24 Jan 2018 02:18:54 GMT
Subject: [PATCH 08/11] xfs: fix tracepoint %p formats
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 23 Jan 2018 18:18:47 -0800
Message-ID: <151676032777.12349.765325330406419659.stgit@magnolia>
In-Reply-To: <151676027743.12349.3845769501491774512.stgit@magnolia>
References: <151676027743.12349.3845769501491774512.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Tracepoint printk doesn't have any of the %p suffixes, so use %p.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/trace.h |   20 ++++++++++----------
 fs/xfs/xfs_trace.h   |   24 ++++++++++++------------
 2 files changed, 22 insertions(+), 22 deletions(-)


diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index a0a6d3c..732775f 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -90,7 +90,7 @@ TRACE_EVENT(xfs_scrub_op_error,
 		__entry->error = error;
 		__entry->ret_ip = ret_ip;
 	),
-	TP_printk("dev %d:%d type %u agno %u agbno %u error %d ret_ip %pS",
+	TP_printk("dev %d:%d type %u agno %u agbno %u error %d ret_ip %p",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->type,
 		  __entry->agno,
@@ -121,7 +121,7 @@ TRACE_EVENT(xfs_scrub_file_op_error,
 		__entry->error = error;
 		__entry->ret_ip = ret_ip;
 	),
-	TP_printk("dev %d:%d ino %llu fork %d type %u offset %llu error %d ret_ip %pS",
+	TP_printk("dev %d:%d ino %llu fork %d type %u offset %llu error %d ret_ip %p",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
 		  __entry->whichfork,
@@ -156,7 +156,7 @@ DECLARE_EVENT_CLASS(xfs_scrub_block_error_class,
 		__entry->bno = bno;
 		__entry->ret_ip = ret_ip;
 	),
-	TP_printk("dev %d:%d type %u agno %u agbno %u ret_ip %pS",
+	TP_printk("dev %d:%d type %u agno %u agbno %u ret_ip %p",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->type,
 		  __entry->agno,
@@ -207,7 +207,7 @@ DECLARE_EVENT_CLASS(xfs_scrub_ino_error_class,
 		__entry->bno = bno;
 		__entry->ret_ip = ret_ip;
 	),
-	TP_printk("dev %d:%d ino %llu type %u agno %u agbno %u ret_ip %pS",
+	TP_printk("dev %d:%d ino %llu type %u agno %u agbno %u ret_ip %p",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
 		  __entry->type,
@@ -246,7 +246,7 @@ DECLARE_EVENT_CLASS(xfs_scrub_fblock_error_class,
 		__entry->offset = offset;
 		__entry->ret_ip = ret_ip;
 	),
-	TP_printk("dev %d:%d ino %llu fork %d type %u offset %llu ret_ip %pS",
+	TP_printk("dev %d:%d ino %llu fork %d type %u offset %llu ret_ip %p",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
 		  __entry->whichfork,
@@ -277,7 +277,7 @@ TRACE_EVENT(xfs_scrub_incomplete,
 		__entry->type = sc->sm->sm_type;
 		__entry->ret_ip = ret_ip;
 	),
-	TP_printk("dev %d:%d type %u ret_ip %pS",
+	TP_printk("dev %d:%d type %u ret_ip %p",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->type,
 		  __entry->ret_ip)
@@ -311,7 +311,7 @@ TRACE_EVENT(xfs_scrub_btree_op_error,
 		__entry->error = error;
 		__entry->ret_ip = ret_ip;
 	),
-	TP_printk("dev %d:%d type %u btnum %d level %d ptr %d agno %u agbno %u error %d ret_ip %pS",
+	TP_printk("dev %d:%d type %u btnum %d level %d ptr %d agno %u agbno %u error %d ret_ip %p",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->type,
 		  __entry->btnum,
@@ -354,7 +354,7 @@ TRACE_EVENT(xfs_scrub_ifork_btree_op_error,
 		__entry->error = error;
 		__entry->ret_ip = ret_ip;
 	),
-	TP_printk("dev %d:%d ino %llu fork %d type %u btnum %d level %d ptr %d agno %u agbno %u error %d ret_ip %pS",
+	TP_printk("dev %d:%d ino %llu fork %d type %u btnum %d level %d ptr %d agno %u agbno %u error %d ret_ip %p",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
 		  __entry->whichfork,
@@ -393,7 +393,7 @@ TRACE_EVENT(xfs_scrub_btree_error,
 		__entry->ptr = cur->bc_ptrs[level];
 		__entry->ret_ip = ret_ip;
 	),
-	TP_printk("dev %d:%d type %u btnum %d level %d ptr %d agno %u agbno %u ret_ip %pS",
+	TP_printk("dev %d:%d type %u btnum %d level %d ptr %d agno %u agbno %u ret_ip %p",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->type,
 		  __entry->btnum,
@@ -433,7 +433,7 @@ TRACE_EVENT(xfs_scrub_ifork_btree_error,
 		__entry->ptr = cur->bc_ptrs[level];
 		__entry->ret_ip = ret_ip;
 	),
-	TP_printk("dev %d:%d ino %llu fork %d type %u btnum %d level %d ptr %d agno %u agbno %u ret_ip %pS",
+	TP_printk("dev %d:%d ino %llu fork %d type %u btnum %d level %d ptr %d agno %u agbno %u ret_ip %p",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
 		  __entry->whichfork,
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 945de08..893081e 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -119,7 +119,7 @@ DECLARE_EVENT_CLASS(xfs_perag_class,
 		__entry->refcount = refcount;
 		__entry->caller_ip = caller_ip;
 	),
-	TP_printk("dev %d:%d agno %u refcount %d caller %pS",
+	TP_printk("dev %d:%d agno %u refcount %d caller %p",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->agno,
 		  __entry->refcount,
@@ -252,7 +252,7 @@ DECLARE_EVENT_CLASS(xfs_bmap_class,
 		__entry->caller_ip = caller_ip;
 	),
 	TP_printk("dev %d:%d ino 0x%llx state %s cur %p/%d "
-		  "offset %lld block %lld count %lld flag %d caller %pS",
+		  "offset %lld block %lld count %lld flag %d caller %p",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
 		  __print_flags(__entry->bmap_state, "|", XFS_BMAP_EXT_FLAGS),
@@ -301,7 +301,7 @@ DECLARE_EVENT_CLASS(xfs_buf_class,
 		__entry->caller_ip = caller_ip;
 	),
 	TP_printk("dev %d:%d bno 0x%llx nblks 0x%x hold %d pincount %d "
-		  "lock %d flags %s caller %pS",
+		  "lock %d flags %s caller %p",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  (unsigned long long)__entry->bno,
 		  __entry->nblks,
@@ -370,7 +370,7 @@ DECLARE_EVENT_CLASS(xfs_buf_flags_class,
 		__entry->caller_ip = caller_ip;
 	),
 	TP_printk("dev %d:%d bno 0x%llx len 0x%zx hold %d pincount %d "
-		  "lock %d flags %s caller %pS",
+		  "lock %d flags %s caller %p",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  (unsigned long long)__entry->bno,
 		  __entry->buffer_length,
@@ -415,7 +415,7 @@ TRACE_EVENT(xfs_buf_ioerror,
 		__entry->caller_ip = caller_ip;
 	),
 	TP_printk("dev %d:%d bno 0x%llx len 0x%zx hold %d pincount %d "
-		  "lock %d error %d flags %s caller %pS",
+		  "lock %d error %d flags %s caller %p",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  (unsigned long long)__entry->bno,
 		  __entry->buffer_length,
@@ -579,7 +579,7 @@ DECLARE_EVENT_CLASS(xfs_lock_class,
 		__entry->lock_flags = lock_flags;
 		__entry->caller_ip = caller_ip;
 	),
-	TP_printk("dev %d:%d ino 0x%llx flags %s caller %pS",
+	TP_printk("dev %d:%d ino 0x%llx flags %s caller %p",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
 		  __print_flags(__entry->lock_flags, "|", XFS_LOCK_FLAGS),
@@ -697,7 +697,7 @@ DECLARE_EVENT_CLASS(xfs_iref_class,
 		__entry->pincount = atomic_read(&ip->i_pincount);
 		__entry->caller_ip = caller_ip;
 	),
-	TP_printk("dev %d:%d ino 0x%llx count %d pincount %d caller %pS",
+	TP_printk("dev %d:%d ino 0x%llx count %d pincount %d caller %p",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
 		  __entry->count,
@@ -1049,7 +1049,7 @@ TRACE_EVENT(xfs_log_force,
 		__entry->lsn = lsn;
 		__entry->caller_ip = caller_ip;
 	),
-	TP_printk("dev %d:%d lsn 0x%llx caller %pS",
+	TP_printk("dev %d:%d lsn 0x%llx caller %p",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->lsn, (void *)__entry->caller_ip)
 )
@@ -1403,7 +1403,7 @@ TRACE_EVENT(xfs_bunmap,
 		__entry->flags = flags;
 	),
 	TP_printk("dev %d:%d ino 0x%llx size 0x%llx bno 0x%llx len 0x%llx"
-		  "flags %s caller %pS",
+		  "flags %s caller %p",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
 		  __entry->size,
@@ -1517,7 +1517,7 @@ TRACE_EVENT(xfs_agf,
 	),
 	TP_printk("dev %d:%d agno %u flags %s length %u roots b %u c %u "
 		  "levels b %u c %u flfirst %u fllast %u flcount %u "
-		  "freeblks %u longest %u caller %pS",
+		  "freeblks %u longest %u caller %p",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->agno,
 		  __print_flags(__entry->flags, "|", XFS_AGF_FLAGS),
@@ -2486,7 +2486,7 @@ DECLARE_EVENT_CLASS(xfs_ag_error_class,
 		__entry->error = error;
 		__entry->caller_ip = caller_ip;
 	),
-	TP_printk("dev %d:%d agno %u error %d caller %pS",
+	TP_printk("dev %d:%d agno %u error %d caller %p",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->agno,
 		  __entry->error,
@@ -2977,7 +2977,7 @@ DECLARE_EVENT_CLASS(xfs_inode_error_class,
 		__entry->error = error;
 		__entry->caller_ip = caller_ip;
 	),
-	TP_printk("dev %d:%d ino %llx error %d caller %pS",
+	TP_printk("dev %d:%d ino %llx error %d caller %p",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
 		  __entry->error,

