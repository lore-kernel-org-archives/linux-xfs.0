Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:37108 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726382AbeK2Kcu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Nov 2018 05:32:50 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id wASNSiE7160083
        for <linux-xfs@vger.kernel.org>; Wed, 28 Nov 2018 23:29:31 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2120.oracle.com with ESMTP id 2nxxkqn737-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 28 Nov 2018 23:29:31 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id wASNTUeB028356
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 28 Nov 2018 23:29:30 GMT
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id wASNTU7K011513
        for <linux-xfs@vger.kernel.org>; Wed, 28 Nov 2018 23:29:30 GMT
Subject: [PATCH 6/6] xfs: stringify scrub types in ftrace output
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 28 Nov 2018 15:29:29 -0800
Message-ID: <154344776951.4341.14323367177195315854.stgit@magnolia>
In-Reply-To: <154344773243.4341.5458822684407979916.stgit@magnolia>
References: <154344773243.4341.5458822684407979916.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Use __print_symbolic to print the scrub type in ftrace output.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/trace.h |  103 +++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 77 insertions(+), 26 deletions(-)


diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 0141eb1ac091..3c83e8b3b39c 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -26,6 +26,57 @@ TRACE_DEFINE_ENUM(XFS_BTNUM_FINOi);
 TRACE_DEFINE_ENUM(XFS_BTNUM_RMAPi);
 TRACE_DEFINE_ENUM(XFS_BTNUM_REFCi);
 
+TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_PROBE);
+TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_SB);
+TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_AGF);
+TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_AGFL);
+TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_AGI);
+TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_BNOBT);
+TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_CNTBT);
+TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_INOBT);
+TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_FINOBT);
+TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_RMAPBT);
+TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_REFCNTBT);
+TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_INODE);
+TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_BMBTD);
+TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_BMBTA);
+TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_BMBTC);
+TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_DIR);
+TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_XATTR);
+TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_SYMLINK);
+TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_PARENT);
+TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_RTBITMAP);
+TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_RTSUM);
+TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_UQUOTA);
+TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_GQUOTA);
+TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_PQUOTA);
+
+#define XFS_SCRUB_TYPE_STRINGS \
+	{ XFS_SCRUB_TYPE_PROBE,		"probe" }, \
+	{ XFS_SCRUB_TYPE_SB,		"sb" }, \
+	{ XFS_SCRUB_TYPE_AGF,		"agf" }, \
+	{ XFS_SCRUB_TYPE_AGFL,		"agfl" }, \
+	{ XFS_SCRUB_TYPE_AGI,		"agi" }, \
+	{ XFS_SCRUB_TYPE_BNOBT,		"bnobt" }, \
+	{ XFS_SCRUB_TYPE_CNTBT,		"cntbt" }, \
+	{ XFS_SCRUB_TYPE_INOBT,		"inobt" }, \
+	{ XFS_SCRUB_TYPE_FINOBT,	"finobt" }, \
+	{ XFS_SCRUB_TYPE_RMAPBT,	"rmapbt" }, \
+	{ XFS_SCRUB_TYPE_REFCNTBT,	"refcountbt" }, \
+	{ XFS_SCRUB_TYPE_INODE,		"inode" }, \
+	{ XFS_SCRUB_TYPE_BMBTD,		"bmapbtd" }, \
+	{ XFS_SCRUB_TYPE_BMBTA,		"bmapbta" }, \
+	{ XFS_SCRUB_TYPE_BMBTC,		"bmapbtc" }, \
+	{ XFS_SCRUB_TYPE_DIR,		"directory" }, \
+	{ XFS_SCRUB_TYPE_XATTR,		"xattr" }, \
+	{ XFS_SCRUB_TYPE_SYMLINK,	"symlink" }, \
+	{ XFS_SCRUB_TYPE_PARENT,	"parent" }, \
+	{ XFS_SCRUB_TYPE_RTBITMAP,	"rtbitmap" }, \
+	{ XFS_SCRUB_TYPE_RTSUM,		"rtsummary" }, \
+	{ XFS_SCRUB_TYPE_UQUOTA,	"usrquota" }, \
+	{ XFS_SCRUB_TYPE_GQUOTA,	"grpquota" }, \
+	{ XFS_SCRUB_TYPE_PQUOTA,	"prjquota" }
+
 DECLARE_EVENT_CLASS(xchk_class,
 	TP_PROTO(struct xfs_inode *ip, struct xfs_scrub_metadata *sm,
 		 int error),
@@ -50,10 +101,10 @@ DECLARE_EVENT_CLASS(xchk_class,
 		__entry->flags = sm->sm_flags;
 		__entry->error = error;
 	),
-	TP_printk("dev %d:%d ino 0x%llx type %u agno %u inum %llu gen %u flags 0x%x error %d",
+	TP_printk("dev %d:%d ino 0x%llx type %s agno %u inum %llu gen %u flags 0x%x error %d",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
-		  __entry->type,
+		  __print_symbolic(__entry->type, XFS_SCRUB_TYPE_STRINGS),
 		  __entry->agno,
 		  __entry->inum,
 		  __entry->gen,
@@ -92,9 +143,9 @@ TRACE_EVENT(xchk_op_error,
 		__entry->error = error;
 		__entry->ret_ip = ret_ip;
 	),
-	TP_printk("dev %d:%d type %u agno %u agbno %u error %d ret_ip %pS",
+	TP_printk("dev %d:%d type %s agno %u agbno %u error %d ret_ip %pS",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
-		  __entry->type,
+		  __print_symbolic(__entry->type, XFS_SCRUB_TYPE_STRINGS),
 		  __entry->agno,
 		  __entry->bno,
 		  __entry->error,
@@ -123,11 +174,11 @@ TRACE_EVENT(xchk_file_op_error,
 		__entry->error = error;
 		__entry->ret_ip = ret_ip;
 	),
-	TP_printk("dev %d:%d ino 0x%llx fork %d type %u offset %llu error %d ret_ip %pS",
+	TP_printk("dev %d:%d ino 0x%llx fork %d type %s offset %llu error %d ret_ip %pS",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
 		  __entry->whichfork,
-		  __entry->type,
+		  __print_symbolic(__entry->type, XFS_SCRUB_TYPE_STRINGS),
 		  __entry->offset,
 		  __entry->error,
 		  __entry->ret_ip)
@@ -158,9 +209,9 @@ DECLARE_EVENT_CLASS(xchk_block_error_class,
 		__entry->bno = bno;
 		__entry->ret_ip = ret_ip;
 	),
-	TP_printk("dev %d:%d type %u agno %u agbno %u ret_ip %pS",
+	TP_printk("dev %d:%d type %s agno %u agbno %u ret_ip %pS",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
-		  __entry->type,
+		  __print_symbolic(__entry->type, XFS_SCRUB_TYPE_STRINGS),
 		  __entry->agno,
 		  __entry->bno,
 		  __entry->ret_ip)
@@ -190,10 +241,10 @@ DECLARE_EVENT_CLASS(xchk_ino_error_class,
 		__entry->type = sc->sm->sm_type;
 		__entry->ret_ip = ret_ip;
 	),
-	TP_printk("dev %d:%d ino 0x%llx type %u ret_ip %pS",
+	TP_printk("dev %d:%d ino 0x%llx type %s ret_ip %pS",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
-		  __entry->type,
+		  __print_symbolic(__entry->type, XFS_SCRUB_TYPE_STRINGS),
 		  __entry->ret_ip)
 )
 
@@ -227,11 +278,11 @@ DECLARE_EVENT_CLASS(xchk_fblock_error_class,
 		__entry->offset = offset;
 		__entry->ret_ip = ret_ip;
 	),
-	TP_printk("dev %d:%d ino 0x%llx fork %d type %u offset %llu ret_ip %pS",
+	TP_printk("dev %d:%d ino 0x%llx fork %d type %s offset %llu ret_ip %pS",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
 		  __entry->whichfork,
-		  __entry->type,
+		  __print_symbolic(__entry->type, XFS_SCRUB_TYPE_STRINGS),
 		  __entry->offset,
 		  __entry->ret_ip)
 );
@@ -258,9 +309,9 @@ TRACE_EVENT(xchk_incomplete,
 		__entry->type = sc->sm->sm_type;
 		__entry->ret_ip = ret_ip;
 	),
-	TP_printk("dev %d:%d type %u ret_ip %pS",
+	TP_printk("dev %d:%d type %s ret_ip %pS",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
-		  __entry->type,
+		  __print_symbolic(__entry->type, XFS_SCRUB_TYPE_STRINGS),
 		  __entry->ret_ip)
 );
 
@@ -292,9 +343,9 @@ TRACE_EVENT(xchk_btree_op_error,
 		__entry->error = error;
 		__entry->ret_ip = ret_ip;
 	),
-	TP_printk("dev %d:%d type %u btree %s level %d ptr %d agno %u agbno %u error %d ret_ip %pS",
+	TP_printk("dev %d:%d type %s btree %s level %d ptr %d agno %u agbno %u error %d ret_ip %pS",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
-		  __entry->type,
+		  __print_symbolic(__entry->type, XFS_SCRUB_TYPE_STRINGS),
 		  __print_symbolic(__entry->btnum, XFS_BTNUM_STRINGS),
 		  __entry->level,
 		  __entry->ptr,
@@ -335,11 +386,11 @@ TRACE_EVENT(xchk_ifork_btree_op_error,
 		__entry->error = error;
 		__entry->ret_ip = ret_ip;
 	),
-	TP_printk("dev %d:%d ino 0x%llx fork %d type %u btree %s level %d ptr %d agno %u agbno %u error %d ret_ip %pS",
+	TP_printk("dev %d:%d ino 0x%llx fork %d type %s btree %s level %d ptr %d agno %u agbno %u error %d ret_ip %pS",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
 		  __entry->whichfork,
-		  __entry->type,
+		  __print_symbolic(__entry->type, XFS_SCRUB_TYPE_STRINGS),
 		  __print_symbolic(__entry->btnum, XFS_BTNUM_STRINGS),
 		  __entry->level,
 		  __entry->ptr,
@@ -374,9 +425,9 @@ TRACE_EVENT(xchk_btree_error,
 		__entry->ptr = cur->bc_ptrs[level];
 		__entry->ret_ip = ret_ip;
 	),
-	TP_printk("dev %d:%d type %u btree %s level %d ptr %d agno %u agbno %u ret_ip %pS",
+	TP_printk("dev %d:%d type %s btree %s level %d ptr %d agno %u agbno %u ret_ip %pS",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
-		  __entry->type,
+		  __print_symbolic(__entry->type, XFS_SCRUB_TYPE_STRINGS),
 		  __print_symbolic(__entry->btnum, XFS_BTNUM_STRINGS),
 		  __entry->level,
 		  __entry->ptr,
@@ -414,11 +465,11 @@ TRACE_EVENT(xchk_ifork_btree_error,
 		__entry->ptr = cur->bc_ptrs[level];
 		__entry->ret_ip = ret_ip;
 	),
-	TP_printk("dev %d:%d ino 0x%llx fork %d type %u btree %s level %d ptr %d agno %u agbno %u ret_ip %pS",
+	TP_printk("dev %d:%d ino 0x%llx fork %d type %s btree %s level %d ptr %d agno %u agbno %u ret_ip %pS",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
 		  __entry->whichfork,
-		  __entry->type,
+		  __print_symbolic(__entry->type, XFS_SCRUB_TYPE_STRINGS),
 		  __print_symbolic(__entry->btnum, XFS_BTNUM_STRINGS),
 		  __entry->level,
 		  __entry->ptr,
@@ -453,9 +504,9 @@ DECLARE_EVENT_CLASS(xchk_sbtree_class,
 		__entry->nlevels = cur->bc_nlevels;
 		__entry->ptr = cur->bc_ptrs[level];
 	),
-	TP_printk("dev %d:%d type %u btree %s agno %u agbno %u level %d nlevels %d ptr %d",
+	TP_printk("dev %d:%d type %s btree %s agno %u agbno %u level %d nlevels %d ptr %d",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
-		  __entry->type,
+		  __print_symbolic(__entry->type, XFS_SCRUB_TYPE_STRINGS),
 		  __print_symbolic(__entry->btnum, XFS_BTNUM_STRINGS),
 		  __entry->agno,
 		  __entry->bno,
@@ -487,9 +538,9 @@ TRACE_EVENT(xchk_xref_error,
 		__entry->error = error;
 		__entry->ret_ip = ret_ip;
 	),
-	TP_printk("dev %d:%d type %u xref error %d ret_ip %pS",
+	TP_printk("dev %d:%d type %s xref error %d ret_ip %pS",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
-		  __entry->type,
+		  __print_symbolic(__entry->type, XFS_SCRUB_TYPE_STRINGS),
 		  __entry->error,
 		  __entry->ret_ip)
 );
