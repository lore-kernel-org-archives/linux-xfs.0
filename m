Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q21LELF2187409 for <xfs@oss.sgi.com>; Thu, 1 Mar 2012 15:14:21 -0600
Received: from MMS3.broadcom.com (mms3.broadcom.com [216.31.210.19]) by
	cuda.sgi.com with ESMTP id EN5xnXt8f6M6fczc for
	<xfs@oss.sgi.com>; Thu, 01 Mar 2012 13:14:20 -0800 (PST)
From: "Kamal Dasu" <kdasu.kdev@gmail.com>
Subject: [PATCH 1/2] xfsprogs: replace deprecated ustat call with statfs
	in libxfs/linux.c
Date: Thu, 1 Mar 2012 16:11:24 -0500
Message-ID: <de74feb44ebd887269fe85d9a5879765afccf4c2.1330635228.git.kdasu.kdev@gmail.com>
In-Reply-To: <1330636285-11200-1-git-send-email-kdasu.kdev@gmail.com>
References: <1330636285-11200-1-git-send-email-kdasu.kdev@gmail.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Kamal Dasu <kdasu.kdev@gmail.com>

>From the ustat man page

NOTES
       ustat() is deprecated and has only  been  provided  for  compatibility.
       All new programs should use statfs(2) instead.

Signed-off-by: Kamal Dasu <kdasu.kdev@gmail.com>
---
 libxfs/linux.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/libxfs/linux.c b/libxfs/linux.c
index 2e07d54..b8cc028 100644
--- a/libxfs/linux.c
+++ b/libxfs/linux.c
@@ -21,7 +21,9 @@
 #include <mntent.h>
 #include <sys/stat.h>
 #undef ustat
-#include <sys/ustat.h>
+#include <sys/statfs.h>
+#include <sys/types.h>
+
 #include <sys/mount.h>
 #include <sys/ioctl.h>
 #include <sys/sysinfo.h>
@@ -50,7 +52,7 @@ int
 platform_check_ismounted(char *name, char *block, struct stat64 *s, int verbose)
 {
 	/* Pad ust; pre-2.6.28 linux copies out too much in 32bit compat mode */
-	struct ustat	ust[2];
+	struct statfs	fst;
 	struct stat64	st;
 
 	if (!s) {
@@ -61,7 +63,7 @@ platform_check_ismounted(char *name, char *block, struct stat64 *s, int verbose)
 		s = &st;
 	}
 
-	if (ustat(s->st_rdev, ust) >= 0) {
+	if (statfs(block, &fst) >= 0) {
 		if (verbose)
 			fprintf(stderr,
 				_("%s: %s contains a mounted filesystem\n"),
-- 
1.7.5.4


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
