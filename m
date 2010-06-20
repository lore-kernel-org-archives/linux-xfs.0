Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5KNeQFH091400 for <xfs@oss.sgi.com>; Sun, 20 Jun 2010 18:40:27 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 91D2D1D5E147
	for <xfs@oss.sgi.com>; Sun, 20 Jun 2010 16:43:05 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	Fq988u5DclKEke8Q for <xfs@oss.sgi.com>;
	Sun, 20 Jun 2010 16:43:05 -0700 (PDT)
Received: from dastard (unverified [121.44.96.63])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	28463014-1927428
	for <xfs@oss.sgi.com>; Mon, 21 Jun 2010 09:13:03 +0930 (CST)
Received: from disturbed ([192.168.1.9]) by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1OQUAH-00034H-Tl
	for xfs@oss.sgi.com; Mon, 21 Jun 2010 09:43:01 +1000
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1OQUAE-0004ff-K9
	for xfs@oss.sgi.com; Mon, 21 Jun 2010 09:42:58 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfsqa: test 214 leaves files around that cause 236 to fail
Date: Mon, 21 Jun 2010 09:42:58 +1000
Message-Id: <1277077378-17927-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

Test 214 and 236 use the same file names for test files in the TEST
filesystem and don't check/create clean initial test state. Hence if
you run 214 then 236, 236 will fail with:

+link: cannot create link `/mnt/test/ouch2' to `/mnt/test/ouch': File exists
+ctime: 1277076527 -> 1277076527
+Fatal error: ctime not updated after link

Ensure that both tests clean up after themselves properly and also
ensure a clean state before they start.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 214 |    2 ++
 236 |   13 +++++--------
 2 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/214 b/214
index eb18825..cef7626 100755
--- a/214
+++ b/214
@@ -29,6 +29,7 @@ echo "QA output created by $seq"
 
 _cleanup()
 {
+	rm -f $TEST_DIR/ouch*
 	cd /
 	rm -f $tmp.*
 }
@@ -51,6 +52,7 @@ _supported_os Linux
 [ -n "$XFS_IO_PROG" ] || _notrun "xfs_io executable not found"
 
 rm -f $seq.full
+rm -f $TEST_DIR/ouch*
 
 _require_xfs_io_falloc
 
diff --git a/236 b/236
index 4d257f0..a7500ed 100644
--- a/236
+++ b/236
@@ -30,15 +30,12 @@ echo "QA output created by $seq"
 
 _cleanup()
 {
-	if [ -a $TEST_DIR/ouch2 ]; then
-		rm -f $TEST_DIR/ouch2
-	fi
-	if [ -a $TEST_DIR/ouch ]; then
-		rm -f $TEST_DIR/ouch
-	fi
+	rm -f $TEST_DIR/ouch*
 }
 
 here=`pwd`
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
 
 # get standard environment, filters and checks
 . ./common.rc
@@ -48,6 +45,8 @@ _supported_fs generic
 # only Linux supports fallocate
 _supported_os Linux
 
+rm -f $TEST_DIR/ouch*
+
 # create a file and get its ctime
 touch $TEST_DIR/ouch
 ctime=`stat -c %Z $TEST_DIR/ouch`
@@ -65,8 +64,6 @@ if [ $ctime2 -le $ctime ]; then
 	exit 1
 fi
 
-_cleanup
-
 echo "Test over."
 # success, all done
 status=0
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
