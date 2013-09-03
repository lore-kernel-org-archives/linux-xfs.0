Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 29F9C7F54
	for <xfs@oss.sgi.com>; Mon,  2 Sep 2013 19:15:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 199CD8F804B
	for <xfs@oss.sgi.com>; Mon,  2 Sep 2013 17:15:03 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	5fDNhzcSdi7BJIuS for <xfs@oss.sgi.com>;
	Mon, 02 Sep 2013 17:15:01 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1VGeGn-0002JA-HB
	for xfs@oss.sgi.com; Tue, 03 Sep 2013 10:14:57 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1VGeGn-0001zL-GO
	for xfs@oss.sgi.com; Tue, 03 Sep 2013 10:14:57 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3/3] xfstests: Make 204 work with different block and inode
	sizes.
Date: Tue,  3 Sep 2013 10:14:55 +1000
Message-Id: <1378167295-7566-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1378167295-7566-1-git-send-email-david@fromorbit.com>
References: <1378167295-7566-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

Otherwise it fails with ENOSPC on CRC enabled filesystems because
ofhte larger inode size.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 common/filter     | 10 +++++++++-
 tests/generic/204 | 34 ++++++++++++++++++++++++++++++----
 2 files changed, 39 insertions(+), 5 deletions(-)

diff --git a/common/filter b/common/filter
index ee738ca..dc9e197 100644
--- a/common/filter
+++ b/common/filter
@@ -131,9 +131,17 @@ _filter_date()
 }
 
 # prints filtered output on stdout, values (use eval) on stderr
-# 
+# Non XFS filesystems always return a 4k block size and a 256 byte inode.
 _filter_mkfs()
 {
+    case $FSTYP in
+    xfs)
+	;;
+    *)
+	perl -e 'print STDERR "dbsize=4096\nisize=256\n"'
+	return ;;
+    esac
+
     set -
     perl -ne '
     if (/^meta-data=([\w,|\/.-]+)\s+isize=(\d+)\s+agcount=(\d+), agsize=(\d+) blks/) {
diff --git a/tests/generic/204 b/tests/generic/204
index a054c8f..598b805 100755
--- a/tests/generic/204
+++ b/tests/generic/204
@@ -28,6 +28,12 @@ echo "QA output created by $seq"
 here=`pwd`
 tmp=/tmp/$$
 status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	rm -f $tmp.*
+}
 
 # get standard environment, filters and checks
 . ./common/rc
@@ -41,15 +47,35 @@ _require_scratch
 
 rm -f $seqres.full
 
+# get the block size first
+_scratch_mkfs 2> /dev/null | _filter_mkfs 2> $tmp.mkfs > /dev/null
+. $tmp.mkfs
+
 SIZE=`expr 104 \* 1024 \* 1024`
-_scratch_mkfs_sized $SIZE  &> /dev/null
+_scratch_mkfs_sized $SIZE $dbsize 2> /dev/null \
+		| _filter_mkfs 2> $tmp.mkfs > /dev/null
 _scratch_mount
 
+. $tmp.mkfs
+
 # fix the reserve block pool to a known size so that the enospc calculations
-# work out correctly.
-_scratch_resvblks 1024 >> $seqres.full 2>&1
+# work out correctly. Space usages is based 22500 files and 1024 reserved blocks
+# on a 4k block size 256 byte inode size filesystem.
+resv_blks=1024
+space=97920000
+
+# decrease files for inode size.
+#	22500 * (256 + 4k) = ~97MB
+#	files * (isize + bsize) = 97MB
+#	files = (97920000 / (isize + bsize))
+
+files=$((space / (isize + dbsize)))
+resv_blks=$((resv_blks * (4096 / dbsize)))
+
+echo files $files, resvblks $resv_blks >> $seqres.full
+_scratch_resvblks $resv_blks >> $seqres.full 2>&1
 
-for i in `seq 1 22500`; do
+for i in `seq 1 $files`; do
     echo -n > $SCRATCH_MNT/$i
     echo XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX > $SCRATCH_MNT/$i
 done
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
