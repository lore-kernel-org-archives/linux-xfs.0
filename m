Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id EE3C77F56
	for <xfs@oss.sgi.com>; Tue, 25 Feb 2014 13:14:59 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D1467304077
	for <xfs@oss.sgi.com>; Tue, 25 Feb 2014 11:14:59 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id orESybZlVzOackC3 for
	<xfs@oss.sgi.com>; Tue, 25 Feb 2014 11:14:59 -0800 (PST)
From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 3/6 v2] ext4: translate fallocate mode bits to strings
Date: Tue, 25 Feb 2014 20:14:36 +0100
Message-Id: <1393355679-11160-4-git-send-email-lczerner@redhat.com>
In-Reply-To: <1393355679-11160-1-git-send-email-lczerner@redhat.com>
References: <1393355679-11160-1-git-send-email-lczerner@redhat.com>
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
To: linux-ext4@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Lukas Czerner <lczerner@redhat.com>, tytso@mit.edu, xfs@oss.sgi.com

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 fs/ext4/ext4.h              | 1 +
 fs/ext4/extents.c           | 1 -
 include/trace/events/ext4.h | 9 +++++++--
 3 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index ece5556..3b9601c 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -31,6 +31,7 @@
 #include <linux/percpu_counter.h>
 #include <linux/ratelimit.h>
 #include <crypto/hash.h>
+#include <linux/falloc.h>
 #ifdef __KERNEL__
 #include <linux/compat.h>
 #endif
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 0e675bc..e5485eb 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -37,7 +37,6 @@
 #include <linux/quotaops.h>
 #include <linux/string.h>
 #include <linux/slab.h>
-#include <linux/falloc.h>
 #include <asm/uaccess.h>
 #include <linux/fiemap.h>
 #include "ext4_jbd2.h"
diff --git a/include/trace/events/ext4.h b/include/trace/events/ext4.h
index 197d312..451e020 100644
--- a/include/trace/events/ext4.h
+++ b/include/trace/events/ext4.h
@@ -68,6 +68,11 @@ struct extent_status;
 	{ EXTENT_STATUS_DELAYED,	"D" },			\
 	{ EXTENT_STATUS_HOLE,		"H" })
 
+#define show_falloc_mode(mode) __print_flags(mode, "|",		\
+	{ FALLOC_FL_KEEP_SIZE,		"KEEP_SIZE"},		\
+	{ FALLOC_FL_PUNCH_HOLE,		"PUNCH_HOLE"},		\
+	{ FALLOC_FL_NO_HIDE_STALE,	"NO_HIDE_STALE"})
+
 
 TRACE_EVENT(ext4_free_inode,
 	TP_PROTO(struct inode *inode),
@@ -1349,10 +1354,10 @@ TRACE_EVENT(ext4_fallocate_enter,
 		__entry->mode	= mode;
 	),
 
-	TP_printk("dev %d,%d ino %lu pos %lld len %lld mode %d",
+	TP_printk("dev %d,%d ino %lu pos %lld len %lld mode %s",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  (unsigned long) __entry->ino, __entry->pos,
-		  __entry->len, __entry->mode)
+		  __entry->len, show_falloc_mode(__entry->mode))
 );
 
 TRACE_EVENT(ext4_fallocate_exit,
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
