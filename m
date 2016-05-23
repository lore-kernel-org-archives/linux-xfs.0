Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5270B7CB5
	for <xfs@oss.sgi.com>; Mon, 23 May 2016 10:04:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 240A78F8040
	for <xfs@oss.sgi.com>; Mon, 23 May 2016 08:04:08 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id rgS1VlLt1wYpG4qv (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 23 May 2016 08:04:06 -0700 (PDT)
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/2] linux.h: include <linux/fs.h>
Date: Mon, 23 May 2016 17:03:56 +0200
Message-Id: <1464015836-25127-3-git-send-email-hch@lst.de>
In-Reply-To: <1464015836-25127-1-git-send-email-hch@lst.de>
References: <1464015836-25127-1-git-send-email-hch@lst.de>
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
Cc: jbastian@redhat.com

To reliably prevent the redefinition of struct fsxattr.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reported-by: Jeffrey Bastian <jbastian@redhat.com>
---
 include/linux.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux.h b/include/linux.h
index cc0f70c..0c616f4 100644
--- a/include/linux.h
+++ b/include/linux.h
@@ -32,6 +32,7 @@
 #include <stdio.h>
 #include <asm/types.h>
 #include <mntent.h>
+#include <linux/fs.h> /* fsxattr defintion for new kernels */
 
 static __inline__ int xfsctl(const char *path, int fd, int cmd, void *p)
 {
-- 
2.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
