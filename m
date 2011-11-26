Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAQF1t7J133140 for <xfs@oss.sgi.com>; Sat, 26 Nov 2011 09:01:55 -0600
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 472538F8033
	for <xfs@oss.sgi.com>; Sat, 26 Nov 2011 07:01:52 -0800 (PST)
Received: from arenaud-laptop (cf-vpn-hw-arenaud-5.corp.sgi.com
	[134.15.95.102])
	by estes.americas.sgi.com (Postfix) with ESMTP id 11A3A7000753
	for <xfs@oss.sgi.com>; Sat, 26 Nov 2011 09:01:52 -0600 (CST)
From: Alain Renaud <arenaud@sgi.com>
Date: Sat, 26 Nov 2011 09:15:25 -0500
Subject: [PATCH] xfstest: Change test output to specify 4TB not 2TB
Message-Id: <20111126150149.42E549F79B@arenaud-laptop>
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

 This is a simple modification to the test 259. The script test 4TB
 Filesystem but state that it is testing 2TB filesystem. This
 modification simply change the the output message.

Signed-off-by: Alain Renaud <arenaud@sgi.com>
---
 259     |    2 +-
 259.out |   12 ++++++------
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/259 b/259
index 02938a5..d260b79 100755
--- a/259
+++ b/259
@@ -51,7 +51,7 @@ testfile=$TEST_DIR/259.image
 four_TB=$(_math "2^42")
 for del in 1 512 1024 1025 2048 4096; do
 	ddseek=$(_math "$four_TB - $del")
-	echo "Trying to make (2 TB - $del) B long xfs fs image"
+	echo "Trying to make (4 TB - $del) B long xfs fs image"
 	rm -f "$testfile"
 	dd if=/dev/zero "of=$testfile" bs=1 count=0 seek=$ddseek \
 					>/dev/null 2>&1 || echo "dd failed"
diff --git a/259.out b/259.out
index 4620082..263bb1b 100644
--- a/259.out
+++ b/259.out
@@ -1,7 +1,7 @@
 QA output created by 259
-Trying to make (2 TB - 1) B long xfs fs image
-Trying to make (2 TB - 512) B long xfs fs image
-Trying to make (2 TB - 1024) B long xfs fs image
-Trying to make (2 TB - 1025) B long xfs fs image
-Trying to make (2 TB - 2048) B long xfs fs image
-Trying to make (2 TB - 4096) B long xfs fs image
+Trying to make (4 TB - 1) B long xfs fs image
+Trying to make (4 TB - 512) B long xfs fs image
+Trying to make (4 TB - 1024) B long xfs fs image
+Trying to make (4 TB - 1025) B long xfs fs image
+Trying to make (4 TB - 2048) B long xfs fs image
+Trying to make (4 TB - 4096) B long xfs fs image
-- 
1.7.4.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
