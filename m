Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4972129E17
	for <xfs@oss.sgi.com>; Mon, 17 Aug 2015 11:23:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2C4C930406B
	for <xfs@oss.sgi.com>; Mon, 17 Aug 2015 09:23:58 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id lMwNjwcmHe2jjUdz (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 17 Aug 2015 09:23:57 -0700 (PDT)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 09/11] xfsprogs: prevent LIST_ macros conflicts
Date: Mon, 17 Aug 2015 18:23:24 +0200
Message-Id: <1439828606-7886-10-git-send-email-jtulak@redhat.com>
In-Reply-To: <1439828606-7886-1-git-send-email-jtulak@redhat.com>
References: <1439828606-7886-1-git-send-email-jtulak@redhat.com>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
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
2.4.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
