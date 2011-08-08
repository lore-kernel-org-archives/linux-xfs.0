Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p78FtIlr042094 for <xfs@oss.sgi.com>; Mon, 8 Aug 2011 10:55:18 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 31719C58BF
	for <xfs@oss.sgi.com>; Mon,  8 Aug 2011 08:55:17 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 0wVTIsP6cCjlPeAT for
	<xfs@oss.sgi.com>; Mon, 08 Aug 2011 08:55:17 -0700 (PDT)
From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] xfstests: fsx: fix fallocate logging
Date: Mon,  8 Aug 2011 11:55:14 -0400
Message-Id: <1312818914-9950-1-git-send-email-josef@redhat.com>
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
To: xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org

I've been getting segfaults on fsx tests with btrfs because we're using the
wrong values for the logging with fallocate.  We were using the numbers 1,2 and
3 to indicate the type of preallocate we were doing, however we use these to
point to an array, so obviously array[3] for a 3 element array is wrong, so fix
these to do 0,1, and 2.  Also spit out of we're using KEEP_SIZE in the log to
make it easier to figure out what's going on.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 ltp/fsx.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/ltp/fsx.c b/ltp/fsx.c
index 0683853..662af38 100644
--- a/ltp/fsx.c
+++ b/ltp/fsx.c
@@ -878,11 +878,11 @@ do_preallocate(unsigned offset, unsigned length)
 
 	/*
 	 * last arg:
-	 * 	1: allocate past EOF
-	 * 	2: extending prealloc
-	 * 	3: interior prealloc
+	 * 	0: allocate past EOF
+	 * 	1: extending prealloc
+	 * 	2: interior prealloc
 	 */
-	log4(OP_FALLOCATE, offset, length, (end_offset > file_size) ? (keep_size ? 1 : 2) : 3);
+	log4(OP_FALLOCATE, offset, length, (end_offset > file_size) ? (keep_size ? 0 : 1) : 2);
 
 	if (end_offset > file_size) {
 		memset(good_buf + file_size, '\0', end_offset - file_size);
@@ -895,7 +895,8 @@ do_preallocate(unsigned offset, unsigned length)
 	if ((progressinterval && testcalls % progressinterval == 0) ||
 	    (debug && (monitorstart == -1 || monitorend == -1 ||
 		      end_offset <= monitorend)))
-		prt("%lu falloc\tfrom 0x%x to 0x%x\n", testcalls, offset, length);
+		prt("%lu falloc\tfrom 0x%x to 0x%x%s\n", testcalls, offset, length,
+		    keep_size ? " (KEEP_SIZE)" : "");
 	if (fallocate(fd, keep_size ? FALLOC_FL_KEEP_SIZE : 0, (loff_t)offset, (loff_t)length) == -1) {
 	        prt("fallocate: %x to %x\n", offset, length);
 		prterr("do_preallocate: fallocate");
-- 
1.7.5.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
