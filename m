Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 536637FA8
	for <xfs@oss.sgi.com>; Tue,  4 Aug 2015 04:01:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id CFD48AC001
	for <xfs@oss.sgi.com>; Tue,  4 Aug 2015 02:01:21 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id VlYld3Y1pvrllhOB (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 04 Aug 2015 02:01:20 -0700 (PDT)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH v4 11/11] xfsprogs: prevent LIST_ macros conflicts
Date: Tue,  4 Aug 2015 11:01:14 +0200
Message-Id: <1438678874-23765-1-git-send-email-jtulak@redhat.com>
In-Reply-To: <1438612789-17486-12-git-send-email-jtulak@redhat.com>
References: <1438612789-17486-12-git-send-email-jtulak@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: hch@infradead.org, Jan Tulak <jtulak@redhat.com>

BSD 4.4 added some LIST_ macros into system header files, which
causes "macro redefined" warnings. To ensure we use our own macros,
undefine the system ones at first.

The conflicting macros are LIST_HEAD and LIST_HEAD_INIT

Signed-off-by: Jan Tulak <jtulak@redhat.com>
---
 include/list.h | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/include/list.h b/include/list.h
index 3f087a4..f92faed 100644
--- a/include/list.h
+++ b/include/list.h
@@ -19,6 +19,20 @@
 #define __LIST_H__
 
 /*
+ * This undef is here because BSD 4.4 added some LIST_ macros into system
+ * header file sys/queue.h. This header is included in many other system
+ * headers and thus causes "macro redefined" warnings.
+ *
+ * As OS X is kind of a derivate of BSD, this affects OS X too.
+ *
+ * To use our own LIST_ macros (copied from kernel code), we have to
+ * at first undefine the conflicting system macros.
+ *
+ */
+#undef LIST_HEAD
+#undef LIST_HEAD_INIT
+
+/*
  * Simple, generic doubly-linked list implementation.
  */
 
-- 
2.4.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
