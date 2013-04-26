Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 27A637CBE
	for <xfs@oss.sgi.com>; Fri, 26 Apr 2013 13:45:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 105B68F8033
	for <xfs@oss.sgi.com>; Fri, 26 Apr 2013 11:45:30 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 89VYh06nPA9374Cx for
	<xfs@oss.sgi.com>; Fri, 26 Apr 2013 11:45:30 -0700 (PDT)
Message-ID: <517ACB41.2030002@redhat.com>
Date: Fri, 26 Apr 2013 13:45:21 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfstests btrfs/284: shorten duration, fix output
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
To: xfs-oss <xfs@oss.sgi.com>
Cc: Liu Bo <liubo2009@cn.fujitsu.com>, linux-btrfs <linux-btrfs@vger.kernel.org>

test 284 had... some issues.

First, it took so long nobody ran it; so shorten the extent
count by a factor of about 100.

Having fixed that, we see failures in 2 cases; when start or
len is -1, but the golden output file didn't have error
output, as if they should pass.

I'm going to argue that these *should* both fail; start = -1
has no real meaning.  length = -1 might mean "the rest
of the file" but if that's what you really want, just
don't specify -l.

So add failure output for those cases.

Send all command output to $seq.full, in case that changes
in the future; just capture the return value.

Then remove the return value echo on failure (50?) because
who knows when that might change to some other magic value.

Ok, then when defrag actually works, old defrag returned
"20" (because?) but a recent commit changed it to 0.
So accommodate that too.

And remove a stray "HAVE_DEFRAG=1" while we're at it.
That variable is never used.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/tests/btrfs/284 b/tests/btrfs/284
old mode 100644
new mode 100755
index d952977..67161a3
--- a/tests/btrfs/284
+++ b/tests/btrfs/284
@@ -26,7 +26,7 @@ seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 here="`pwd`"
 tmp=/tmp/$$
-cnt=11999
+cnt=119
 filesize=48000
 
 status=1	# failure is the default!
@@ -58,11 +58,12 @@ _create_file()
 _btrfs_online_defrag()
 {
 	str=""
+	# start = -1 is invalid, should fail
 	if [ "$2" = "2" ];then
 		str="$str -s -1 -l $((filesize / 2)) "
 	elif [ "$2" = "3" ];then
 		str="$str -s $((filesize + 1)) -l $((filesize / 2)) "
-		HAVE_DEFRAG=1
+	# len = -1 is invalid, should fail
 	elif [ "$2" = "4" ];then
 		str="$str -l -1 "
 	elif [ "$2" = "5" ];then
@@ -76,20 +77,22 @@ _btrfs_online_defrag()
 	fi
 
 	if [ "$str" != "" ]; then
-		$BTRFS_UTIL_PROG filesystem defragment $str $SCRATCH_MNT/tmp_file
+		$BTRFS_UTIL_PROG filesystem defragment $str $SCRATCH_MNT/tmp_file >> $seq.full 2>&1
 	else
 		if [ "$1" = "1" ];then
-			$BTRFS_UTIL_PROG filesystem defragment $SCRATCH_MNT/tmp_file
+			$BTRFS_UTIL_PROG filesystem defragment $SCRATCH_MNT/tmp_file >> $seq.full 2>&1
 		elif [ "$1" = "2" ];then
-			$BTRFS_UTIL_PROG filesystem defragment $SCRATCH_MNT/tmp_dir
+			$BTRFS_UTIL_PROG filesystem defragment $SCRATCH_MNT/tmp_dir >> $seq.full 2>&1
 		elif [ "$1" = "3" ];then
-			$BTRFS_UTIL_PROG filesystem defragment $SCRATCH_MNT
+			$BTRFS_UTIL_PROG filesystem defragment $SCRATCH_MNT >> $seq.full 2>&1
 		fi
 	fi
 	ret_val=$?
 	_scratch_remount
-	if [ $ret_val -ne 20 ];then
-		echo "btrfs filesystem defragment failed! err is $ret_val"
+	# Older defrag returned "20" for success
+	# e9393c2 btrfs-progs: defrag return zero on success
+	if [ $ret_val -ne 0 -a $ret_val -ne 20 ]; then
+		echo "btrfs filesystem defragment failed!"
 	fi
 }
 
@@ -140,19 +143,19 @@ _scratch_mount
 _require_defrag
 
 echo "defrag object | defragment range | defragment compress"
-echo "a single file |  default | off"
+echo "a single file | default | off"
 _rundefrag 1 1 1
 
 echo "a single file | default |  on"
 _rundefrag 1 1 2
 
-echo "a single file | start < 0 && 0 < len < file size | off"
+echo "a single file | start < 0 && 0 < len < file size | off (should fail)"
 _rundefrag 1 2 1
 
 echo "a single file | start > file size && 0 < len < file size | off"
 _rundefrag 1 3 1
 
-echo "a single file | start = 0 && len < 0 | off"
+echo "a single file | start = 0 && len < 0 | off (should fail)"
 _rundefrag 1 4 1
 
 echo "a single file | start = 0 && len > file size | off"
diff --git a/tests/btrfs/284.out b/tests/btrfs/284.out
index 4a69f82..c942271 100644
--- a/tests/btrfs/284.out
+++ b/tests/btrfs/284.out
@@ -1,10 +1,12 @@
 QA output created by 284
 defrag object | defragment range | defragment compress
-a single file |  default | off
+a single file | default | off
 a single file | default |  on
-a single file | start < 0 && 0 < len < file size | off
+a single file | start < 0 && 0 < len < file size | off (should fail)
+btrfs filesystem defragment failed!
 a single file | start > file size && 0 < len < file size | off
-a single file | start = 0 && len < 0 | off
+a single file | start = 0 && len < 0 | off (should fail)
+btrfs filesystem defragment failed!
 a single file | start = 0 && len > file size | off
 a single file | start = 0 && 0 < len < file size | off
 a directory | default | off


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
