Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p78Fw2Hn042198 for <xfs@oss.sgi.com>; Mon, 8 Aug 2011 10:58:02 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 534CAC58FA
	for <xfs@oss.sgi.com>; Mon,  8 Aug 2011 08:58:01 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id KI7sQYjAhq6EzjFc for
	<xfs@oss.sgi.com>; Mon, 08 Aug 2011 08:58:01 -0700 (PDT)
From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] xfstests: fsx: fix the hole punching test
Date: Mon,  8 Aug 2011 11:58:00 -0400
Message-Id: <1312819080-10083-1-git-send-email-josef@redhat.com>
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
To: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

The test to make sure we support hole punching is just wrong.  First it passes
the mode options into the len argument, and secondly it uses 0 for what I assume
was meant for the length, which doesn't work right.  Also it uses warn instead
of just normal prt, which will cause xfstests to blow up for no reason.  So fix
the arguments and the error message so that we can actually run xfstests with
fsx on fs's that don't support hole punching yet.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 ltp/fsx.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/ltp/fsx.c b/ltp/fsx.c
index 662af38..692ad58 100644
--- a/ltp/fsx.c
+++ b/ltp/fsx.c
@@ -1261,11 +1261,10 @@ test_punch_hole()
 {
 #ifdef FALLOC_FL_PUNCH_HOLE
 	if (!lite && punch_hole_calls) {
-		if (fallocate(fd, 0, 0,
-			FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE) &&
-			errno == EOPNOTSUPP) {
-
-			warn("main: filesystem does not support fallocate punch hole, disabling");
+		if (fallocate(fd, FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE, 0, 1) &&
+		    errno == EOPNOTSUPP) {
+			if (!quiet)
+				prt("main: filesystem does not support fallocate punch hole, disabling\n");
 			punch_hole_calls = 0;
 		}
 	}
-- 
1.7.5.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
