Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1GMoOIM083556 for <xfs@oss.sgi.com>; Wed, 16 Feb 2011 16:50:24 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D779B1278109
	for <xfs@oss.sgi.com>; Wed, 16 Feb 2011 14:53:02 -0800 (PST)
Received: from mail.sandeen.net (64-131-28-21.usfamily.net [64.131.28.21]) by
	cuda.sgi.com with ESMTP id vIpPxFGIsWCCVt2T for
	<xfs@oss.sgi.com>; Wed, 16 Feb 2011 14:53:02 -0800 (PST)
Message-ID: <4D5C554D.8080004@sandeen.net>
Date: Wed, 16 Feb 2011 16:53:01 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] xfstests: Notify via syslog when godown is shutting down
 fs
References: <1297798863.32230.222.camel@chandra-lucid.beaverton.ibm.com>	<20110215223022.GE13052@dastard>	<1297886433.32230.224.camel@chandra-lucid.beaverton.ibm.com>
	<20110216221433.GG13052@dastard>
In-Reply-To: <20110216221433.GG13052@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Chandra Seetharaman <sekharan@us.ibm.com>, xfs@oss.sgi.com

Just a hint for those perusing logs that the ensuing shutdown is
intentional...

Feb 16 17:06:17 hostname godown: xfstests-induced forced shutdown of /mnt/scratch
Feb 16 17:06:17 hostname kernel: Filesystem "sdb3": xfs_log_force: error 5 returned.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/src/godown.c b/src/godown.c
index 07b6980..b140a41 100644
--- a/src/godown.c
+++ b/src/godown.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <syslog.h>
 #include "global.h"
 
 static char *xprogname;
@@ -109,6 +110,8 @@ main(int argc, char *argv[])
 	if (verbose_opt) {
 		printf("Calling XFS_IOC_GOINGDOWN\n");
 	}
+	syslog(LOG_WARNING, "xfstests-induced forced shutdown of %s:\n",
+		mnt_dir);
 	if ((xfsctl(mnt_dir, fd, XFS_IOC_GOINGDOWN, &flag)) == -1) {
 		fprintf(stderr, "%s: error on xfsctl(GOINGDOWN) of \"%s\": %s\n",
 			xprogname, mnt_dir, strerror(errno));

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
