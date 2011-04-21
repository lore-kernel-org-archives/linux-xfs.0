Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3LL4wAB176487 for <xfs@oss.sgi.com>; Thu, 21 Apr 2011 16:04:59 -0500
From: Joe Perches <joe@perches.com>
Subject: [PATCH] xfs: Remove duplicate XFS from xfs_alert_tag, neatening
Date: Thu, 21 Apr 2011 14:08:23 -0700
Message-Id: <59d707d5d1bc37ef3a08fdd23c8e1fe72fa55fbb.1303419931.git.joe@perches.com>
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
To: Alex Elder <aelder@sgi.com>, linux-kernel@vger.kernel.org
Cc: xfs-masters@oss.sgi.com, xfs@oss.sgi.com, Dave Chinner <dchinner@redhat.com>

The xfs_printk in xfs_alert_tag doesn't need an XFS: prefix
as it's added by xfs_printk.

Add format checking to the non-debug inline function xfs_debug.
Miscellaneous function prototype argument alignment.

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/xfs/linux-2.6/xfs_message.c |    3 +--
 fs/xfs/linux-2.6/xfs_message.h |    5 +++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_message.c b/fs/xfs/linux-2.6/xfs_message.c
index 9f76cce..e894ab2 100644
--- a/fs/xfs/linux-2.6/xfs_message.c
+++ b/fs/xfs/linux-2.6/xfs_message.c
@@ -95,8 +95,7 @@ xfs_alert_tag(
 	int			do_panic = 0;
 
 	if (xfs_panic_mask && (xfs_panic_mask & panic_tag)) {
-		xfs_printk(KERN_ALERT, mp,
-			"XFS: Transforming an alert into a BUG.");
+		xfs_alert(mp, "Transforming an alert into a BUG.");
 		do_panic = 1;
 	}
 
diff --git a/fs/xfs/linux-2.6/xfs_message.h b/fs/xfs/linux-2.6/xfs_message.h
index f1b3fc1..c11f415 100644
--- a/fs/xfs/linux-2.6/xfs_message.h
+++ b/fs/xfs/linux-2.6/xfs_message.h
@@ -11,7 +11,7 @@ extern void xfs_emerg(const struct xfs_mount *mp, const char *fmt, ...)
 extern void xfs_alert(const struct xfs_mount *mp, const char *fmt, ...)
         __attribute__ ((format (printf, 2, 3)));
 extern void xfs_alert_tag(const struct xfs_mount *mp, int tag,
-			 const char *fmt, ...)
+			  const char *fmt, ...)
         __attribute__ ((format (printf, 3, 4)));
 extern void xfs_crit(const struct xfs_mount *mp, const char *fmt, ...)
         __attribute__ ((format (printf, 2, 3)));
@@ -28,7 +28,8 @@ extern void xfs_info(const struct xfs_mount *mp, const char *fmt, ...)
 extern void xfs_debug(const struct xfs_mount *mp, const char *fmt, ...)
         __attribute__ ((format (printf, 2, 3)));
 #else
-static inline void xfs_debug(const struct xfs_mount *mp, const char *fmt, ...)
+static inline __attribute__ ((format (printf, 2, 3)))
+void xfs_debug(const struct xfs_mount *mp, const char *fmt, ...)
 {
 }
 #endif
-- 
1.7.5.rc3.dirty

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
