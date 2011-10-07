Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p97MgT31003290 for <xfs@oss.sgi.com>; Fri, 7 Oct 2011 17:42:29 -0500
Received: from xmail.sgi.com (pv-excas3-dc21-nlb.corp.sgi.com [137.38.102.207])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1CF9C8F804B
	for <xfs@oss.sgi.com>; Fri,  7 Oct 2011 15:42:29 -0700 (PDT)
Subject: [Fwd: [PATCH] xfstests: 259: convert to use the _math() function]
From: Alex Elder <aelder@sgi.com>
Date: Fri, 7 Oct 2011 17:42:00 -0500
Message-ID: <1318027320.2810.83.camel@doink>
MIME-Version: 1.0
Reply-To: aelder@sgi.com
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

Review?

-------- Forwarded Message --------
From: Alex Elder <aelder@sgi.com>
To: xfs@oss.sgi.com
Subject: [PATCH] xfstests: 259: convert to use the _math() function
Date: Mon, 26 Sep 2011 16:59:34 -0500

Make test 259 a bit more readable by using the new _math() function.

Signed-off-by: Alex Elder <aelder@sgi.com>

---
 259     |   17 ++++++-----------
 259.out |   12 ++++++------
 2 files changed, 12 insertions(+), 17 deletions(-)

Index: b/259
===================================================================
--- a/259
+++ b/259
@@ -43,20 +43,15 @@ trap "_cleanup ; exit \$status" 0 1 2 3 
 _supported_fs xfs
 _supported_os Linux
 
+_require_math
+
 testfile=$TEST_DIR/259.image
 
 # Test various sizes slightly less than 4 TB
-# 4398046511103 = 2^42 - 1
-# 4398046510592 = 2^42 - 512
-# 4398046510080 = 2^42 - 1024
-# 4398046510079 = 2^42 - 1025
-# 4398046509056 = 2^42 - 2048
-# 4398046507008 = 2^42 - 4096
-
-for ddseek in 4398046511103 4398046510592 4398046510080 \
-	4398046510079 4398046509056 4398046507008;
-do
-	echo "Trying to make $ddseek B long xfs fs image"
+four_TB=$(_math "2^42")
+for del in 1 512 1024 1025 2048 4096; do
+	ddseek=$(_math "$four_TB - $del")
+	echo "Trying to make (2 TB - $del) B long xfs fs image"
 	rm -f "$testfile"
 	dd if=/dev/zero "of=$testfile" bs=1 count=0 seek=$ddseek \
 					>/dev/null 2>&1 || echo "dd failed"
Index: b/259.out
===================================================================
--- a/259.out
+++ b/259.out
@@ -1,7 +1,7 @@
 QA output created by 259
-Trying to make 4398046511103 B long xfs fs image
-Trying to make 4398046510592 B long xfs fs image
-Trying to make 4398046510080 B long xfs fs image
-Trying to make 4398046510079 B long xfs fs image
-Trying to make 4398046509056 B long xfs fs image
-Trying to make 4398046507008 B long xfs fs image
+Trying to make (2 TB - 1) B long xfs fs image
+Trying to make (2 TB - 512) B long xfs fs image
+Trying to make (2 TB - 1024) B long xfs fs image
+Trying to make (2 TB - 1025) B long xfs fs image
+Trying to make (2 TB - 2048) B long xfs fs image
+Trying to make (2 TB - 4096) B long xfs fs image


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
