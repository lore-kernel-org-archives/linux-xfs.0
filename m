Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:39228 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751781AbeAXCTC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Jan 2018 21:19:02 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w0O27i1P065828
        for <linux-xfs@vger.kernel.org>; Wed, 24 Jan 2018 02:19:02 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2130.oracle.com with ESMTP id 2fph1qr112-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 24 Jan 2018 02:19:02 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w0O2J24m002485
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Wed, 24 Jan 2018 02:19:02 GMT
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w0O2J1qP020675
        for <linux-xfs@vger.kernel.org>; Wed, 24 Jan 2018 02:19:01 GMT
Subject: [PATCH 09/11] xfs: make tracepoint inode number format consistent
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 23 Jan 2018 18:18:59 -0800
Message-ID: <151676033957.12349.16083428926683751541.stgit@magnolia>
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

Fix all the inode number formats to be consistently (0x%llx) in all
trace point definitions.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/trace.h |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)


diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 732775f..eb420a41 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -50,7 +50,7 @@ DECLARE_EVENT_CLASS(xfs_scrub_class,
 		__entry->flags = sm->sm_flags;
 		__entry->error = error;
 	),
-	TP_printk("dev %d:%d ino %llu type %u agno %u inum %llu gen %u flags 0x%x error %d",
+	TP_printk("dev %d:%d ino 0x%llx type %u agno %u inum %llu gen %u flags 0x%x error %d",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
 		  __entry->type,
@@ -121,7 +121,7 @@ TRACE_EVENT(xfs_scrub_file_op_error,
 		__entry->error = error;
 		__entry->ret_ip = ret_ip;
 	),
-	TP_printk("dev %d:%d ino %llu fork %d type %u offset %llu error %d ret_ip %p",
+	TP_printk("dev %d:%d ino 0x%llx fork %d type %u offset %llu error %d ret_ip %p",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
 		  __entry->whichfork,
@@ -207,7 +207,7 @@ DECLARE_EVENT_CLASS(xfs_scrub_ino_error_class,
 		__entry->bno = bno;
 		__entry->ret_ip = ret_ip;
 	),
-	TP_printk("dev %d:%d ino %llu type %u agno %u agbno %u ret_ip %p",
+	TP_printk("dev %d:%d ino 0x%llx type %u agno %u agbno %u ret_ip %p",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
 		  __entry->type,
@@ -246,7 +246,7 @@ DECLARE_EVENT_CLASS(xfs_scrub_fblock_error_class,
 		__entry->offset = offset;
 		__entry->ret_ip = ret_ip;
 	),
-	TP_printk("dev %d:%d ino %llu fork %d type %u offset %llu ret_ip %p",
+	TP_printk("dev %d:%d ino 0x%llx fork %d type %u offset %llu ret_ip %p",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
 		  __entry->whichfork,
@@ -354,7 +354,7 @@ TRACE_EVENT(xfs_scrub_ifork_btree_op_error,
 		__entry->error = error;
 		__entry->ret_ip = ret_ip;
 	),
-	TP_printk("dev %d:%d ino %llu fork %d type %u btnum %d level %d ptr %d agno %u agbno %u error %d ret_ip %p",
+	TP_printk("dev %d:%d ino 0x%llx fork %d type %u btnum %d level %d ptr %d agno %u agbno %u error %d ret_ip %p",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
 		  __entry->whichfork,
@@ -433,7 +433,7 @@ TRACE_EVENT(xfs_scrub_ifork_btree_error,
 		__entry->ptr = cur->bc_ptrs[level];
 		__entry->ret_ip = ret_ip;
 	),
-	TP_printk("dev %d:%d ino %llu fork %d type %u btnum %d level %d ptr %d agno %u agbno %u ret_ip %p",
+	TP_printk("dev %d:%d ino 0x%llx fork %d type %u btnum %d level %d ptr %d agno %u agbno %u ret_ip %p",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
 		  __entry->whichfork,

