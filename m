Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1SEUFsu193548 for <xfs@oss.sgi.com>; Tue, 28 Feb 2012 08:30:16 -0600
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id exxXzHCEBaeYhkQO for
	<xfs@oss.sgi.com>; Tue, 28 Feb 2012 06:30:14 -0800 (PST)
From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH] 251: Make fstrim call a bit more random
Date: Tue, 28 Feb 2012 15:30:00 +0100
Message-Id: <1330439400-26390-1-git-send-email-lczerner@redhat.com>
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
Cc: Lukas Czerner <lczerner@redhat.com>, aelder@sgi.com

To cover cases when fstrim arguments are not block/block group/file
system size aligned, we can be a bit more random. This commit changes
fstrim argument computing to use $RANDOM bash variable in order to have
different minlen, start, len argument settings and change the full fs
fstrim to be called randomly as well.

Also make kill and wait not complain about non existent process, since
it may have already finished before we attempt to kill it and wait for
it. No reason to fail the test.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 251 |   23 +++++++++++++----------
 1 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/251 b/251
index fa3d74a..0b68898 100755
--- a/251
+++ b/251
@@ -54,21 +54,21 @@ _cleanup()
 
 _destroy()
 {
-	kill $pids $fstrim_pid
-	wait $pids $fstrim_pid
+	kill $pids $fstrim_pid 2> /dev/null
+	wait $pids $fstrim_pid 2> /dev/null
 	rm -rf $tmp
 }
 
 _destroy_fstrim()
 {
-	kill $fpid
-	wait $fpid
+	kill $fpid 2> /dev/null
+	wait $fpid 2> /dev/null
 }
 
 _fail()
 {
 	echo "$1"
-	kill $mypid
+	kill $mypid 2> /dev/null
 }
 
 _check_fstrim_support()
@@ -87,13 +87,16 @@ fstrim_loop()
 	fsize=$(df | grep $SCRATCH_MNT | grep $SCRATCH_DEV  | awk '{print $2}')
 
 	while true ; do
-		step=1048576
+		step=$((RANDOM*$RANDOM))
+		minlen=$((RANDOM*($RANDOM%2+1)))
 		start=0
-		$here/src/fstrim $SCRATCH_MNT &
-		fpid=$!
-		wait $fpid
+		if [ $((RANDOM%10)) -gt 7 ]; then
+			$here/src/fstrim $SCRATCH_MNT &
+			fpid=$!
+			wait $fpid
+		fi
 		while [ $start -lt $fsize ] ; do
-			$here/src/fstrim -s ${start}k -l ${step}k $SCRATCH_MNT &
+			$here/src/fstrim -m ${minlen}k -s ${start}k -l ${step}k $SCRATCH_MNT &
 			fpid=$!
 			wait $fpid
 			start=$(( $start + $step ))
-- 
1.7.4.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
