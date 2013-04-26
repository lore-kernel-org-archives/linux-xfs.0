Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 35F757CBF
	for <xfs@oss.sgi.com>; Fri, 26 Apr 2013 00:29:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 25CDD30407A
	for <xfs@oss.sgi.com>; Thu, 25 Apr 2013 22:29:23 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id uFv07WW6BVEfgikX for
	<xfs@oss.sgi.com>; Thu, 25 Apr 2013 22:29:23 -0700 (PDT)
Message-ID: <517A10B1.7040107@redhat.com>
Date: Fri, 26 Apr 2013 00:29:21 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfstests: btrfs/276 - stop all fsstress before exiting
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>, linux-btrfs <linux-btrfs@vger.kernel.org>

Tests after 276 were failing because the background fsstress
hadn't quit prior to exit, devices couldn't be unmounted, etc.

Just use the same trick as generic/068 does, and use
a tmpfile to control whether the background loop keeps
running.

Also, no need to umount scratch at cleanup time, the scripts
do that for us.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

(nobody else ran into this?  really?)

diff --git a/tests/btrfs/276 b/tests/btrfs/276
index 0a5ce36..9d68b54 100755
--- a/tests/btrfs/276
+++ b/tests/btrfs/276
@@ -36,14 +36,8 @@ noise_pid=0
 
 _cleanup()
 {
-	if [ $noise_pid -ne 0 ]; then
-		echo "background noise kill $noise_pid" >>$seqres.full
-		kill $noise_pid
-		noise_pid=0
-		wait
-	fi
-	echo "*** unmount"
-	umount $SCRATCH_MNT 2>/dev/null
+	rm $tmp.running
+	wait
 	rm -f $tmp.*
 }
 trap "_cleanup; exit \$status" 0 1 2 3 15
@@ -210,7 +204,7 @@ workout()
 
 	if [ $do_bg_noise -ne 0 ]; then
 		# make background noise while backrefs are being walked
-		while /bin/true; do
+		while [ -f "$tmp.running" ]; do
 			echo background fsstress >>$seqres.full
 			run_check $FSSTRESS_PROG -d $SCRATCH_MNT/bgnoise -n 999
 			echo background rm >>$seqres.full
@@ -263,6 +257,8 @@ nfiles=4
 numprocs=1
 do_bg_noise=1
 
+touch $tmp.running
+
 workout $filesize $nfiles $numprocs $snap_name $do_bg_noise
 
 echo "*** done"
diff --git a/tests/btrfs/276.out b/tests/btrfs/276.out
index 2032dea..5113164 100644
--- a/tests/btrfs/276.out
+++ b/tests/btrfs/276.out
@@ -1,4 +1,3 @@
 QA output created by 276
 *** test backref walking
 *** done
-*** unmount

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
