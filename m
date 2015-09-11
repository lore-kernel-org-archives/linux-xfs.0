Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 40BF37F50
	for <xfs@oss.sgi.com>; Fri, 11 Sep 2015 13:54:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 21792304039
	for <xfs@oss.sgi.com>; Fri, 11 Sep 2015 11:53:58 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 3mmuYM7ISWbRMd3R (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 11 Sep 2015 11:53:57 -0700 (PDT)
Received: from int-mx14.intmail.prod.int.phx2.redhat.com
	(int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	by mx1.redhat.com (Postfix) with ESMTPS id EF007C0A1605
	for <xfs@oss.sgi.com>; Fri, 11 Sep 2015 18:53:56 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-37.bos.redhat.com [10.18.41.37])
	by int-mx14.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t8BIruYM021782
	for <xfs@oss.sgi.com>; Fri, 11 Sep 2015 14:53:56 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [RFC v2 1/2] xfs: create a daily warning mechanism
Date: Fri, 11 Sep 2015 14:53:54 -0400
Message-Id: <1441997635-36644-2-git-send-email-bfoster@redhat.com>
In-Reply-To: <1441997635-36644-1-git-send-email-bfoster@redhat.com>
References: <1441997635-36644-1-git-send-email-bfoster@redhat.com>
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

The warning mechanism in XFS currently uses the default ratelimit time
interval and burst parameters. The default parameters are intended to
avoid flooding the logs and whatnot due to messages within fairly short
timeframes (e.g., 10 messages within 5s). The forthcoming invalid
metadata LSN detection must provide a consistent, but not incessant
warning to the user that a repair is required to reformat the log.

Update the core ratelimit mechanism to allow customized parameters,
continue to pass the ratelimit defaults for existing users, and define a
new xfs_warn_daily() mechanism to fire a message on a 24 hour interval.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_message.h | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_message.h b/fs/xfs/xfs_message.h
index 8540115..9f1a036 100644
--- a/fs/xfs/xfs_message.h
+++ b/fs/xfs/xfs_message.h
@@ -30,15 +30,22 @@ void xfs_debug(const struct xfs_mount *mp, const char *fmt, ...)
 }
 #endif
 
-#define xfs_printk_ratelimited(func, dev, fmt, ...)		\
+#define __xfs_printk_ratelimited(interval, burst, func, dev, fmt, ...)	\
 do {									\
-	static DEFINE_RATELIMIT_STATE(_rs,				\
-				      DEFAULT_RATELIMIT_INTERVAL,	\
-				      DEFAULT_RATELIMIT_BURST);		\
+	static DEFINE_RATELIMIT_STATE(_rs, interval, burst);		\
 	if (__ratelimit(&_rs))						\
 		func(dev, fmt, ##__VA_ARGS__);			\
 } while (0)
 
+#define xfs_printk_ratelimited(func, dev, fmt, ...)		\
+	__xfs_printk_ratelimited(DEFAULT_RATELIMIT_INTERVAL,	\
+				 DEFAULT_RATELIMIT_BURST,	\
+				 func, dev, fmt, ##__VA_ARGS__)
+
+#define xfs_printk_daily(func, dev, fmt, ...)			\
+	__xfs_printk_ratelimited(86400 * HZ, 1, func, dev, fmt,	\
+				 ##__VA_ARGS__)
+
 #define xfs_emerg_ratelimited(dev, fmt, ...)				\
 	xfs_printk_ratelimited(xfs_emerg, dev, fmt, ##__VA_ARGS__)
 #define xfs_alert_ratelimited(dev, fmt, ...)				\
@@ -56,6 +63,9 @@ do {									\
 #define xfs_debug_ratelimited(dev, fmt, ...)				\
 	xfs_printk_ratelimited(xfs_debug, dev, fmt, ##__VA_ARGS__)
 
+#define xfs_warn_daily(dev, fmt, ...)					\
+	xfs_printk_daily(xfs_warn, dev, fmt, ##__VA_ARGS__)
+
 extern void assfail(char *expr, char *f, int l);
 extern void asswarn(char *expr, char *f, int l);
 
-- 
2.1.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
