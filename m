Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 82D747F5A
	for <xfs@oss.sgi.com>; Tue, 15 Sep 2015 04:59:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 099E3AC002
	for <xfs@oss.sgi.com>; Tue, 15 Sep 2015 02:59:41 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 8zHnW8q2Fu9ADjGQ (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 15 Sep 2015 02:59:41 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (Postfix) with ESMTPS id 8D8B28C1A3
	for <xfs@oss.sgi.com>; Tue, 15 Sep 2015 09:59:40 +0000 (UTC)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 02/14] xfsprogs: Add XATTR_LIST_MAX to OS X headers
Date: Tue, 15 Sep 2015 11:59:12 +0200
Message-Id: <1442311164-12921-3-git-send-email-jtulak@redhat.com>
In-Reply-To: <1442311164-12921-1-git-send-email-jtulak@redhat.com>
References: <1442311164-12921-1-git-send-email-jtulak@redhat.com>
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
Cc: Jan Tulak <jtulak@redhat.com>

OS X has no XATTR_LIST_MAX value. So add it to the platform header.

Signed-off-by: Jan Tulak <jtulak@redhat.com>
---
 include/darwin.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/darwin.h b/include/darwin.h
index b904898..4b7ba3a 100644
--- a/include/darwin.h
+++ b/include/darwin.h
@@ -39,6 +39,11 @@
 # ifndef SYS_fsctl
 #  define SYS_fsctl	242
 # endif
+
+#ifndef XATTR_LIST_MAX
+#define XATTR_LIST_MAX  65536
+#endif
+
 static __inline__ int xfsctl(const char *path, int fd, int cmd, void *p)
 {
 	return syscall(SYS_fsctl, path, cmd, p, 0);
-- 
2.4.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
