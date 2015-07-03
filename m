Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id BE7D47F8E
	for <xfs@oss.sgi.com>; Fri,  3 Jul 2015 05:14:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9C6158F8049
	for <xfs@oss.sgi.com>; Fri,  3 Jul 2015 03:14:57 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id 9JKUpABnKmqXPZnE (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 03 Jul 2015 03:14:56 -0700 (PDT)
Received: from [88.128.80.19] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1ZAxzj-0002W8-Sx
	for xfs@oss.sgi.com; Fri, 03 Jul 2015 10:14:56 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 06/13] xfsprogs: use <>-style includes in installed headers
Date: Fri,  3 Jul 2015 12:12:14 +0200
Message-Id: <1435918341-10128-7-git-send-email-hch@lst.de>
In-Reply-To: <1435918341-10128-1-git-send-email-hch@lst.de>
References: <1435918341-10128-1-git-send-email-hch@lst.de>
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

Once installed these are system headers, so we need to use <>-style include
statements between them.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/platform_defs.h.in | 10 +++++-----
 include/xfs.h              |  6 +++---
 include/xqm.h              |  2 +-
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/include/platform_defs.h.in b/include/platform_defs.h.in
index 9a1782c..529c0a6 100644
--- a/include/platform_defs.h.in
+++ b/include/platform_defs.h.in
@@ -69,15 +69,15 @@ typedef __u64	__bitwise	__be64;
 typedef struct filldir		filldir_t;
 
 #if defined(__linux__)
-#include "xfs/linux.h"
+#include <xfs/linux.h>
 #elif defined(__FreeBSD__)
-#include "xfs/freebsd.h"
+#include <xfs/freebsd.h>
 #elif defined(__FreeBSD_kernel__)
-#include "xfs/gnukfreebsd.h"
+#include <xfs/gnukfreebsd.h>
 #elif defined(__APPLE__)
-#include "xfs/darwin.h"
+#include <xfs/darwin.h>
 #elif defined(__sgi__) || defined(__sgi)
-#include "xfs/irix.h"
+#include <xfs/irix.h>
 #else
 # error unknown platform... have fun porting!
 #endif
diff --git a/include/xfs.h b/include/xfs.h
index 0cb4fb8..e32c4a8 100644
--- a/include/xfs.h
+++ b/include/xfs.h
@@ -33,8 +33,8 @@
 #ifndef __XFS_H__
 #define __XFS_H__
 
-#include "xfs/platform_defs.h"
-#include "xfs/xfs_types.h"
-#include "xfs/xfs_fs.h"
+#include <xfs/platform_defs.h>
+#include <xfs/xfs_types.h>
+#include <xfs/xfs_fs.h>
 
 #endif	/* __XFS_H__ */
diff --git a/include/xqm.h b/include/xqm.h
index 0b5dfa1..47f58a0 100644
--- a/include/xqm.h
+++ b/include/xqm.h
@@ -18,7 +18,7 @@
 #ifndef __XQM_H__
 #define __XQM_H__
 
-#include "xfs/xfs.h"
+#include <xfs/xfs.h>
 
 /*
  * Disk quota - quotactl(2) commands for the XFS Quota Manager (XQM).
-- 
1.9.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
