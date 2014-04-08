Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 685EE8131
	for <xfs@oss.sgi.com>; Tue,  8 Apr 2014 18:27:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 60B8530407B
	for <xfs@oss.sgi.com>; Tue,  8 Apr 2014 16:26:55 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id dnSEe1D284nDHupR for <xfs@oss.sgi.com>;
	Tue, 08 Apr 2014 16:26:34 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 02/14] xfsprogs: refactor fsrall_cleanup in xfs_fsr
Date: Tue,  8 Apr 2014 18:24:52 -0500
Message-Id: <1396999504-13769-3-git-send-email-sandeen@redhat.com>
In-Reply-To: <1396999504-13769-1-git-send-email-sandeen@redhat.com>
References: <1396999504-13769-1-git-send-email-sandeen@redhat.com>
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

fsrall_cleanup leaked an fd in the non-timeout
case - but the logic was weird and tortured, refactor
it to make more sense and fix the fd leak as well.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fsr/xfs_fsr.c |   24 ++++++++++++------------
 1 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
index 6b5d260..3818f02 100644
--- a/fsr/xfs_fsr.c
+++ b/fsr/xfs_fsr.c
@@ -647,14 +647,19 @@ fsrall_cleanup(int timeout)
 	int ret;
 	char buf[SMBUFSZ];
 
-	/* record where we left off */
 	unlink(leftofffile);
-	fd = open(leftofffile, O_WRONLY|O_CREAT|O_EXCL, 0644);
-	if (fd == -1)
-		fsrprintf(_("open(%s) failed: %s\n"),
-		          leftofffile, strerror(errno));
-	else {
-		if (timeout) {
+
+	if (timeout) {
+		fsrprintf(_("%s startpass %d, endpass %d, time %d seconds\n"),
+			progname, startpass, fs->npass,
+			time(0) - endtime + howlong);
+
+		/* record where we left off */
+		fd = open(leftofffile, O_WRONLY|O_CREAT|O_EXCL, 0644);
+		if (fd == -1) {
+			fsrprintf(_("open(%s) failed: %s\n"),
+			          leftofffile, strerror(errno));
+		} else {
 			ret = sprintf(buf, "%s %d %llu\n", fs->dev,
 			        fs->npass, (unsigned long long)leftoffino);
 			if (write(fd, buf, ret) < strlen(buf))
@@ -663,11 +668,6 @@ fsrall_cleanup(int timeout)
 			close(fd);
 		}
 	}
-
-	if (timeout)
-		fsrprintf(_("%s startpass %d, endpass %d, time %d seconds\n"),
-			progname, startpass, fs->npass,
-			time(0) - endtime + howlong);
 }
 
 /*
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
