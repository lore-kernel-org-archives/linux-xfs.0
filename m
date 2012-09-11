Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8BMD1j2162617 for <xfs@oss.sgi.com>; Tue, 11 Sep 2012 17:13:01 -0500
Received: from mail-pz0-f53.google.com (mail-pz0-f53.google.com
	[209.85.210.53]) by cuda.sgi.com with ESMTP id 3R2EYV1SlHgczA4s
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 11 Sep 2012 15:14:06 -0700 (PDT)
Received: by dadg9 with SMTP id g9so810705dad.26
	for <xfs@oss.sgi.com>; Tue, 11 Sep 2012 15:14:05 -0700 (PDT)
From: raghu.prabhu13@gmail.com
Subject: [PATCH 1/3] Add ratelimited printk for different alert levels
Date: Wed, 12 Sep 2012 03:43:22 +0530
Message-Id: <ef779779fdfb84c7c1216b374216246d4de83233.1347396641.git.rprabhu@wnohang.net>
In-Reply-To: <cover.1347396641.git.rprabhu@wnohang.net>
References: <cover.1347396641.git.rprabhu@wnohang.net>
In-Reply-To: <cover.1347396641.git.rprabhu@wnohang.net>
References: <cover.1347396641.git.rprabhu@wnohang.net>
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
Cc: Raghavendra D Prabhu <rprabhu@wnohang.net>, Alex Elder <elder@kernel.org>, Ben Myers <bpm@sgi.com>, open list <linux-kernel@vger.kernel.org>

From: Raghavendra D Prabhu <rprabhu@wnohang.net>

Ratelimited printk will be useful in printing xfs messages which are otherwise
not required to be printed always due to their high rate (to prevent kernel ring
buffer from overflowing), while at the same time required to be printed.

Signed-off-by: Raghavendra D Prabhu <rprabhu@wnohang.net>
---
 fs/xfs/xfs_message.h | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/fs/xfs/xfs_message.h b/fs/xfs/xfs_message.h
index 56dc0c1..87999a5 100644
--- a/fs/xfs/xfs_message.h
+++ b/fs/xfs/xfs_message.h
@@ -1,6 +1,8 @@
 #ifndef __XFS_MESSAGE_H
 #define __XFS_MESSAGE_H 1
 
+#include <linux/ratelimit.h>
+
 struct xfs_mount;
 
 extern __printf(2, 3)
@@ -30,6 +32,32 @@ void xfs_debug(const struct xfs_mount *mp, const char *fmt, ...)
 }
 #endif
 
+#define xfs_printk_ratelimited(xfs_printk, dev, fmt, ...)		\
+do {									\
+	static DEFINE_RATELIMIT_STATE(_rs,				\
+				      DEFAULT_RATELIMIT_INTERVAL,	\
+				      DEFAULT_RATELIMIT_BURST);		\
+	if (__ratelimit(&_rs))						\
+		xfs_printk(dev, fmt, ##__VA_ARGS__);			\
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
+#define xfs_dbg_ratelimited(dev, fmt, ...)				\
+	xfs_printk_ratelimited(xfs_dbg, dev, fmt, ##__VA_ARGS__)
+
 extern void assfail(char *expr, char *f, int l);
 
 extern void xfs_hex_dump(void *p, int length);
-- 
1.7.12

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
