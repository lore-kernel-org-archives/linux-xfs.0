Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id AAC407F9E
	for <xfs@oss.sgi.com>; Fri,  9 Oct 2015 22:24:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8CD2E304032
	for <xfs@oss.sgi.com>; Fri,  9 Oct 2015 20:24:41 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id qjIzaRhOyOvEKQwV (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 09 Oct 2015 20:24:40 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (Postfix) with ESMTPS id B441EA58BD
	for <xfs@oss.sgi.com>; Sat, 10 Oct 2015 03:24:39 +0000 (UTC)
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t9A3ObhR008418
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 9 Oct 2015 23:24:39 -0400
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfs: more info from kmem deadlocks and high-level error msgs
Message-ID: <561884F5.2050808@redhat.com>
Date: Fri, 9 Oct 2015 22:24:37 -0500
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

In an effort to get more useful out of "possible memory
allocation deadlock" messages, print the size of the
requested allocation, and dump the stack if the xfs error
level is tuned high.

The stack dump is implemented in define_xfs_printk_level()
for error levels >= LOGLEVEL_ERR, partly because it
seems generically useful, and also because kmem.c has
no knowledge of xfs error level tunables or other such bits,
it's very kmem-specific.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/xfs/kmem.c b/fs/xfs/kmem.c
index a7a3a63..dfe3a8b 100644
--- a/fs/xfs/kmem.c
+++ b/fs/xfs/kmem.c
@@ -55,8 +55,8 @@ kmem_alloc(size_t size, xfs_km_flags_t flags)
 			return ptr;
 		if (!(++retries % 100))
 			xfs_err(NULL,
-		"possible memory allocation deadlock in %s (mode:0x%x)",
-					__func__, lflags);
+		"possible memory allocation deadlock size %u in %s (mode:0x%x)",
+					(unsigned int)size, __func__, lflags);
 		congestion_wait(BLK_RW_ASYNC, HZ/50);
 	} while (1);
 }
diff --git a/fs/xfs/xfs_message.c b/fs/xfs/xfs_message.c
index d8b6754..11792d8 100644
--- a/fs/xfs/xfs_message.c
+++ b/fs/xfs/xfs_message.c
@@ -17,6 +17,7 @@
 
 #include "xfs.h"
 #include "xfs_fs.h"
+#include "xfs_error.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
@@ -43,6 +44,7 @@ void func(const struct xfs_mount *mp, const char *fmt, ...)	\
 {								\
 	struct va_format	vaf;				\
 	va_list			args;				\
+	int			level;				\
 								\
 	va_start(args, fmt);					\
 								\
@@ -51,6 +53,11 @@ void func(const struct xfs_mount *mp, const char *fmt, ...)	\
 								\
 	__xfs_printk(kern_level, mp, &vaf);			\
 	va_end(args);						\
+								\
+	if (!kstrtoint(kern_level, 0, &level) &&		\
+	    level <= LOGLEVEL_ERR &&				\
+	    xfs_error_level >= XFS_ERRLEVEL_HIGH)		\
+		xfs_stack_trace();				\
 }								\
 
 define_xfs_printk_level(xfs_emerg, KERN_EMERG);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
