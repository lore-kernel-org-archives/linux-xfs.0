Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 792C07F50
	for <xfs@oss.sgi.com>; Wed, 27 Mar 2013 13:17:19 -0500 (CDT)
MIME-Version: 1.0
Subject: [v3 Repost] xfs: Add ratelimited printk for different alert levels
Date: Wed, 26 Sep 2012 06:56:47 -0000
From: Raghavendra D Prabhu <raghu.prabhu13@gmail.com>
Message-Id: <5515301A9.9010206@sgi.com>
References: <ca71153845539b0c76ba3e3aab9611ad6c5cf72b.1348641483.git.rprabhu@wnohang.net>
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
Cc: bpm@sgi.com, elder@kernel.org, Raghavendra D Prabhu <rprabhu@wnohang.net>

From: Raghavendra D Prabhu <rprabhu@wnohang.net>

Ratelimited printk will be useful in printing xfs messages which are otherwise
not required to be printed always due to their high rate (to prevent kernel ring
buffer from overflowing), while at the same time required to be printed.

Signed-off-by: Raghavendra D Prabhu <rprabhu@wnohang.net>
Reviewed-by: Rich Johnston <rjohnston@sgi.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>

---

Sorry this has not been committed and it's been a few months so I am
reposting this patch.  If I don't hear any objections by 10 am CST on
29 March 2013 I will commit this patch.
 

fs/xfs/xfs_linux.h   |  1 +
 fs/xfs/xfs_message.h | 26 ++++++++++++++++++++++++++
 2 files changed, 27 insertions(+)

Index: linux/fs/xfs/xfs_linux.h
===================================================================
--- linux.orig/fs/xfs/xfs_linux.h	2013-03-22 09:19:54.000000000 -0500
+++ linux/fs/xfs/xfs_linux.h	2013-03-27 12:55:33.000000000 -0500
@@ -72,6 +72,7 @@
 #include <linux/kthread.h>
 #include <linux/freezer.h>
 #include <linux/list_sort.h>
+#include <linux/ratelimit.h>
 
 #include <asm/page.h>
 #include <asm/div64.h>
Index: linux/fs/xfs/xfs_message.h
===================================================================
--- linux.orig/fs/xfs/xfs_message.h	2013-03-22 09:19:54.000000000 -0500
+++ linux/fs/xfs/xfs_message.h	2013-03-27 12:55:33.000000000 -0500
@@ -30,6 +30,32 @@
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

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
