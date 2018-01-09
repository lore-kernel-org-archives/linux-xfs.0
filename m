Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:38064 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755520AbeAIUqJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Jan 2018 15:46:09 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w09Kfjpn075366
        for <linux-xfs@vger.kernel.org>; Tue, 9 Jan 2018 20:46:07 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2130.oracle.com with ESMTP id 2fd3r1gef9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 09 Jan 2018 20:46:07 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w09Kk6iK003698
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Tue, 9 Jan 2018 20:46:07 GMT
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w09Kk6pJ010744
        for <linux-xfs@vger.kernel.org>; Tue, 9 Jan 2018 20:46:06 GMT
Subject: [PATCH 2/3] xfs: use %pS printk format for direct instruction
 addresses
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 09 Jan 2018 12:46:05 -0800
Message-ID: <151553076542.16288.14073908543082638592.stgit@magnolia>
In-Reply-To: <151553075309.16288.5030700495895866371.stgit@magnolia>
References: <151553075309.16288.5030700495895866371.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Use the %pS instead of the %pF printk format specifier for printing
symbols from direct addresses. This is needed for the ia64, ppc64 and
parisc64 architectures.

While we're at it, be consistent with the capitalization of the 'S'.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/trace.h |   20 ++++++++++----------
 fs/xfs/xfs_inode.c   |    4 ++--
 fs/xfs/xfs_trace.h   |   22 +++++++++++-----------
 3 files changed, 23 insertions(+), 23 deletions(-)


diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index c4ebfb5..ffa4a70 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -90,7 +90,7 @@ TRACE_EVENT(xfs_scrub_op_error,
 		__entry->error = error;
 		__entry->ret_ip = ret_ip;
 	),
-	TP_printk("dev %d:%d type %u agno %u agbno %u error %d ret_ip %pF",
+	TP_printk("dev %d:%d type %u agno %u agbno %u error %d ret_ip %pS",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->type,
 		  __entry->agno,
@@ -121,7 +121,7 @@ TRACE_EVENT(xfs_scrub_file_op_error,
 		__entry->error = error;
 		__entry->ret_ip = ret_ip;
 	),
-	TP_printk("dev %d:%d ino %llu fork %d type %u offset %llu error %d ret_ip %pF",
+	TP_printk("dev %d:%d ino %llu fork %d type %u offset %llu error %d ret_ip %pS",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
 		  __entry->whichfork,
@@ -156,7 +156,7 @@ DECLARE_EVENT_CLASS(xfs_scrub_block_error_class,
 		__entry->bno = bno;
 		__entry->ret_ip = ret_ip;
 	),
-	TP_printk("dev %d:%d type %u agno %u agbno %u ret_ip %pF",
+	TP_printk("dev %d:%d type %u agno %u agbno %u ret_ip %pS",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->type,
 		  __entry->agno,
@@ -207,7 +207,7 @@ DECLARE_EVENT_CLASS(xfs_scrub_ino_error_class,
 		__entry->bno = bno;
 		__entry->ret_ip = ret_ip;
 	),
-	TP_printk("dev %d:%d ino %llu type %u agno %u agbno %u ret_ip %pF",
+	TP_printk("dev %d:%d ino %llu type %u agno %u agbno %u ret_ip %pS",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
 		  __entry->type,
@@ -246,7 +246,7 @@ DECLARE_EVENT_CLASS(xfs_scrub_fblock_error_class,
 		__entry->offset = offset;
 		__entry->ret_ip = ret_ip;
 	),
-	TP_printk("dev %d:%d ino %llu fork %d type %u offset %llu ret_ip %pF",
+	TP_printk("dev %d:%d ino %llu fork %d type %u offset %llu ret_ip %pS",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
 		  __entry->whichfork,
@@ -277,7 +277,7 @@ TRACE_EVENT(xfs_scrub_incomplete,
 		__entry->type = sc->sm->sm_type;
 		__entry->ret_ip = ret_ip;
 	),
-	TP_printk("dev %d:%d type %u ret_ip %pF",
+	TP_printk("dev %d:%d type %u ret_ip %pS",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->type,
 		  __entry->ret_ip)
@@ -311,7 +311,7 @@ TRACE_EVENT(xfs_scrub_btree_op_error,
 		__entry->error = error;
 		__entry->ret_ip = ret_ip;
 	),
-	TP_printk("dev %d:%d type %u btnum %d level %d ptr %d agno %u agbno %u error %d ret_ip %pF",
+	TP_printk("dev %d:%d type %u btnum %d level %d ptr %d agno %u agbno %u error %d ret_ip %pS",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->type,
 		  __entry->btnum,
@@ -354,7 +354,7 @@ TRACE_EVENT(xfs_scrub_ifork_btree_op_error,
 		__entry->error = error;
 		__entry->ret_ip = ret_ip;
 	),
-	TP_printk("dev %d:%d ino %llu fork %d type %u btnum %d level %d ptr %d agno %u agbno %u error %d ret_ip %pF",
+	TP_printk("dev %d:%d ino %llu fork %d type %u btnum %d level %d ptr %d agno %u agbno %u error %d ret_ip %pS",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
 		  __entry->whichfork,
@@ -393,7 +393,7 @@ TRACE_EVENT(xfs_scrub_btree_error,
 		__entry->ptr = cur->bc_ptrs[level];
 		__entry->ret_ip = ret_ip;
 	),
-	TP_printk("dev %d:%d type %u btnum %d level %d ptr %d agno %u agbno %u ret_ip %pF",
+	TP_printk("dev %d:%d type %u btnum %d level %d ptr %d agno %u agbno %u ret_ip %pS",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->type,
 		  __entry->btnum,
@@ -433,7 +433,7 @@ TRACE_EVENT(xfs_scrub_ifork_btree_error,
 		__entry->ptr = cur->bc_ptrs[level];
 		__entry->ret_ip = ret_ip;
 	),
-	TP_printk("dev %d:%d ino %llu fork %d type %u btnum %d level %d ptr %d agno %u agbno %u ret_ip %pF",
+	TP_printk("dev %d:%d ino %llu fork %d type %u btnum %d level %d ptr %d agno %u agbno %u ret_ip %pS",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
 		  __entry->whichfork,
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index e93fb88..29c47da 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3492,7 +3492,7 @@ xfs_inode_verify_forks(
 	fa = xfs_ifork_verify_data(ip, &xfs_default_ifork_ops);
 	if (fa) {
 		xfs_alert(ip->i_mount,
-				"%s: bad inode %llu inline data fork at %pF",
+				"%s: bad inode %llu inline data fork at %pS",
 				__func__, ip->i_ino, fa);
 		return false;
 	}
@@ -3500,7 +3500,7 @@ xfs_inode_verify_forks(
 	fa = xfs_ifork_verify_attr(ip, &xfs_default_ifork_ops);
 	if (fa) {
 		xfs_alert(ip->i_mount,
-				"%s: bad inode %llu inline attr fork at %pF",
+				"%s: bad inode %llu inline attr fork at %pS",
 				__func__, ip->i_ino, fa);
 		return false;
 	}
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 560545f..945de08 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -119,7 +119,7 @@ DECLARE_EVENT_CLASS(xfs_perag_class,
 		__entry->refcount = refcount;
 		__entry->caller_ip = caller_ip;
 	),
-	TP_printk("dev %d:%d agno %u refcount %d caller %ps",
+	TP_printk("dev %d:%d agno %u refcount %d caller %pS",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->agno,
 		  __entry->refcount,
@@ -252,7 +252,7 @@ DECLARE_EVENT_CLASS(xfs_bmap_class,
 		__entry->caller_ip = caller_ip;
 	),
 	TP_printk("dev %d:%d ino 0x%llx state %s cur %p/%d "
-		  "offset %lld block %lld count %lld flag %d caller %ps",
+		  "offset %lld block %lld count %lld flag %d caller %pS",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
 		  __print_flags(__entry->bmap_state, "|", XFS_BMAP_EXT_FLAGS),
@@ -301,7 +301,7 @@ DECLARE_EVENT_CLASS(xfs_buf_class,
 		__entry->caller_ip = caller_ip;
 	),
 	TP_printk("dev %d:%d bno 0x%llx nblks 0x%x hold %d pincount %d "
-		  "lock %d flags %s caller %ps",
+		  "lock %d flags %s caller %pS",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  (unsigned long long)__entry->bno,
 		  __entry->nblks,
@@ -370,7 +370,7 @@ DECLARE_EVENT_CLASS(xfs_buf_flags_class,
 		__entry->caller_ip = caller_ip;
 	),
 	TP_printk("dev %d:%d bno 0x%llx len 0x%zx hold %d pincount %d "
-		  "lock %d flags %s caller %ps",
+		  "lock %d flags %s caller %pS",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  (unsigned long long)__entry->bno,
 		  __entry->buffer_length,
@@ -579,7 +579,7 @@ DECLARE_EVENT_CLASS(xfs_lock_class,
 		__entry->lock_flags = lock_flags;
 		__entry->caller_ip = caller_ip;
 	),
-	TP_printk("dev %d:%d ino 0x%llx flags %s caller %ps",
+	TP_printk("dev %d:%d ino 0x%llx flags %s caller %pS",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
 		  __print_flags(__entry->lock_flags, "|", XFS_LOCK_FLAGS),
@@ -697,7 +697,7 @@ DECLARE_EVENT_CLASS(xfs_iref_class,
 		__entry->pincount = atomic_read(&ip->i_pincount);
 		__entry->caller_ip = caller_ip;
 	),
-	TP_printk("dev %d:%d ino 0x%llx count %d pincount %d caller %ps",
+	TP_printk("dev %d:%d ino 0x%llx count %d pincount %d caller %pS",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
 		  __entry->count,
@@ -1049,7 +1049,7 @@ TRACE_EVENT(xfs_log_force,
 		__entry->lsn = lsn;
 		__entry->caller_ip = caller_ip;
 	),
-	TP_printk("dev %d:%d lsn 0x%llx caller %ps",
+	TP_printk("dev %d:%d lsn 0x%llx caller %pS",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->lsn, (void *)__entry->caller_ip)
 )
@@ -1403,7 +1403,7 @@ TRACE_EVENT(xfs_bunmap,
 		__entry->flags = flags;
 	),
 	TP_printk("dev %d:%d ino 0x%llx size 0x%llx bno 0x%llx len 0x%llx"
-		  "flags %s caller %ps",
+		  "flags %s caller %pS",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
 		  __entry->size,
@@ -1517,7 +1517,7 @@ TRACE_EVENT(xfs_agf,
 	),
 	TP_printk("dev %d:%d agno %u flags %s length %u roots b %u c %u "
 		  "levels b %u c %u flfirst %u fllast %u flcount %u "
-		  "freeblks %u longest %u caller %ps",
+		  "freeblks %u longest %u caller %pS",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->agno,
 		  __print_flags(__entry->flags, "|", XFS_AGF_FLAGS),
@@ -2486,7 +2486,7 @@ DECLARE_EVENT_CLASS(xfs_ag_error_class,
 		__entry->error = error;
 		__entry->caller_ip = caller_ip;
 	),
-	TP_printk("dev %d:%d agno %u error %d caller %ps",
+	TP_printk("dev %d:%d agno %u error %d caller %pS",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->agno,
 		  __entry->error,
@@ -2977,7 +2977,7 @@ DECLARE_EVENT_CLASS(xfs_inode_error_class,
 		__entry->error = error;
 		__entry->caller_ip = caller_ip;
 	),
-	TP_printk("dev %d:%d ino %llx error %d caller %ps",
+	TP_printk("dev %d:%d ino %llx error %d caller %pS",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
 		  __entry->error,

