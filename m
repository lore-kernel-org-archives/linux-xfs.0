Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8Q6tnAN168155 for <xfs@oss.sgi.com>; Wed, 26 Sep 2012 01:55:49 -0500
Received: from mail-da0-f53.google.com (mail-da0-f53.google.com
	[209.85.210.53]) by cuda.sgi.com with ESMTP id SOZEaavOU5BjmjzC
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 25 Sep 2012 23:57:07 -0700 (PDT)
Received: by dadg9 with SMTP id g9so108296dad.26
	for <xfs@oss.sgi.com>; Tue, 25 Sep 2012 23:57:06 -0700 (PDT)
From: raghu.prabhu13@gmail.com
Subject: [PATCH v3 1/3] xfs: Add ratelimited printk for different alert levels
Date: Wed, 26 Sep 2012 12:26:47 +0530
Message-Id: <ca71153845539b0c76ba3e3aab9611ad6c5cf72b.1348641483.git.rprabhu@wnohang.net>
In-Reply-To: <cover.1348639531.git.rprabhu@wnohang.net>
References: <cover.1348639531.git.rprabhu@wnohang.net>
In-Reply-To: <cover.1348641483.git.rprabhu@wnohang.net>
References: <cover.1348641483.git.rprabhu@wnohang.net>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: bpm@sgi.com, elder@kernel.org, Raghavendra D Prabhu <rprabhu@wnohang.net>

From: Raghavendra D Prabhu <rprabhu@wnohang.net>

Ratelimited printk will be useful in printing xfs messages which are otherwise
not required to be printed always due to their high rate (to prevent kernel ring
buffer from overflowing), while at the same time required to be printed.

Signed-off-by: Raghavendra D Prabhu <rprabhu@wnohang.net>
---
 fs/xfs/xfs_linux.h   |  1 +
 fs/xfs/xfs_message.h | 26 ++++++++++++++++++++++++++
 2 files changed, 27 insertions(+)

diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
index 828662f..49f8505 100644
--- a/fs/xfs/xfs_linux.h
+++ b/fs/xfs/xfs_linux.h
@@ -71,6 +71,7 @@
 #include <linux/kthread.h>
 #include <linux/freezer.h>
 #include <linux/list_sort.h>
+#include <linux/ratelimit.h>
 
 #include <asm/page.h>
 #include <asm/div64.h>
diff --git a/fs/xfs/xfs_message.h b/fs/xfs/xfs_message.h
index 56dc0c1..76c8198 100644
--- a/fs/xfs/xfs_message.h
+++ b/fs/xfs/xfs_message.h
@@ -30,6 +30,32 @@ void xfs_debug(const struct xfs_mount *mp, const char *fmt, ...)
 }
 #endif
 
+#define xfs_printk_ratelimited(func, dev, fmt, ...)		\
+do {									\
+	static DEFINE_RATELIMIT_STATE(_rs,				\
+				      DEFAULT_RATELIMIT_INTERVAL,	\
+				      DEFAULT_RATELIMIT_BURST);		\
+	if (__ratelimit(&_rs))						\
+		func(dev, fmt, ##__VA_ARGS__);			\
+} while (0)
+
+#define xfs_emerg_ratelimited(dev, fmt, ...)				\
+	xfs_printk_ratelimited(xfs_emerg, dev, fmt, ##__VA_ARGS__)
+#define xfs_alert_ratelimited(dev, fmt, ...)				\
+	xfs_printk_ratelimited(xfs_alert, dev, fmt, ##__VA_ARGS__)
+#define xfs_crit_ratelimited(dev, fmt, ...)				\
+	xfs_printk_ratelimited(xfs_crit, dev, fmt, ##__VA_ARGS__)
+#define xfs_err_ratelimited(dev, fmt, ...)				\
+	xfs_printk_ratelimited(xfs_err, dev, fmt, ##__VA_ARGS__)
+#define xfs_warn_ratelimited(dev, fmt, ...)				\
+	xfs_printk_ratelimited(xfs_warn, dev, fmt, ##__VA_ARGS__)
+#define xfs_notice_ratelimited(dev, fmt, ...)				\
+	xfs_printk_ratelimited(xfs_notice, dev, fmt, ##__VA_ARGS__)
+#define xfs_info_ratelimited(dev, fmt, ...)				\
+	xfs_printk_ratelimited(xfs_info, dev, fmt, ##__VA_ARGS__)
+#define xfs_debug_ratelimited(dev, fmt, ...)				\
+	xfs_printk_ratelimited(xfs_debug, dev, fmt, ##__VA_ARGS__)
+
 extern void assfail(char *expr, char *f, int l);
 
 extern void xfs_hex_dump(void *p, int length);
-- 
1.7.12.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
