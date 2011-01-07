Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p073Sd4e222543 for <xfs@oss.sgi.com>; Thu, 6 Jan 2011 21:28:39 -0600
Date: Fri, 7 Jan 2011 14:30:41 +1100
From: Anton Blanchard <anton@samba.org>
Subject: xfs: Add log level to assertion printk
Message-ID: <20110107143041.1d07e34f@kryten>
Mime-Version: 1.0
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Alex Elder <aelder@sgi.com>, Dave Chinner <dchinner@redhat.com>, Christoph Hellwig <hch@lst.de>
Cc: xfs-masters@oss.sgi.com, xfs@oss.sgi.com


I received a ppc64 bug report involving xfs but the assertion was filtered out
by the console log level. Use KERN_CRIT to ensure it makes it out.

Signed-off-by: Anton Blanchard <anton@samba.org>
---

diff --git a/fs/xfs/support/debug.c b/fs/xfs/support/debug.c
index 975aa10..86162e5 100644
--- a/fs/xfs/support/debug.c
+++ b/fs/xfs/support/debug.c
@@ -104,7 +104,8 @@ xfs_fs_vcmn_err(
 void
 assfail(char *expr, char *file, int line)
 {
-	printk("Assertion failed: %s, file: %s, line: %d\n", expr, file, line);
+	printk(KERN_CRIT "Assertion failed: %s, file: %s, line: %d\n", expr,
+	       file, line);
 	BUG();
 }
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
