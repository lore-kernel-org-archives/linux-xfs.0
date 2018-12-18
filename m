Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:56404 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726614AbeLRUj3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Dec 2018 15:39:29 -0500
Subject: [PATCH 1/6] xfs: fix function pointer type in ftrace format
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 18 Dec 2018 12:39:22 -0800
Message-ID: <154516556287.31776.14062881779871652355.stgit@magnolia>
In-Reply-To: <154516555511.31776.9868161112615886200.stgit@magnolia>
References: <154516555511.31776.9868161112615886200.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>, sandeen@sandeen.net

From: Darrick J. Wong <darrick.wong@oracle.com>

Use %pS instead of %pF in ftrace strings so that we record the actual
function address instead of the function descriptor.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/xfs/scrub/trace.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index f1c144c6dcc5..d67e915cf91a 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -473,7 +473,7 @@ TRACE_EVENT(xchk_xref_error,
 		__entry->error = error;
 		__entry->ret_ip = ret_ip;
 	),
-	TP_printk("dev %d:%d type %u xref error %d ret_ip %pF",
+	TP_printk("dev %d:%d type %u xref error %d ret_ip %pS",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->type,
 		  __entry->error,
