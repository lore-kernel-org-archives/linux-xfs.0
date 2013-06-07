Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E830F7F37
	for <xfs@oss.sgi.com>; Fri,  7 Jun 2013 08:06:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 66B72AC002
	for <xfs@oss.sgi.com>; Fri,  7 Jun 2013 06:06:48 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	XL7NfxSlKLFEvPO3 for <xfs@oss.sgi.com>;
	Fri, 07 Jun 2013 06:06:46 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UkwNN-0005aK-F1
	for xfs@oss.sgi.com; Fri, 07 Jun 2013 23:06:41 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UkwNN-0003p0-6X
	for xfs@oss.sgi.com; Fri, 07 Jun 2013 23:06:41 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 4/6] xfstests: Make 204 work with different block and inode
	sizes.
Date: Fri,  7 Jun 2013 23:06:36 +1000
Message-Id: <1370610398-14630-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1370610398-14630-1-git-send-email-david@fromorbit.com>
References: <1370610398-14630-1-git-send-email-david@fromorbit.com>
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
 common/filter     |   10 +++++++++-
 tests/generic/204 |   37 ++++++++++++++++++++++++++++++++-----
 2 files changed, 41 insertions(+), 6 deletions(-)

diff --git a/common/filter b/common/filter
index dbb1674..1bf9e9c 100644
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
index 62bd248..ecc9923 100755
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
@@ -39,20 +45,41 @@ _supported_os Linux
 
 _require_scratch
 
+rm -f $seqres.full
+
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
-_scratch_resvblks 1024 > $seqres.full 2>&1
+# work out correctly. Space usages is based 22500 files and 1024 reserved blocks
+# on a 4k block size 256 byte inode size filesystem.
+resv_blks=1024
+space=97920000
 
-for i in `seq 1 22500`; do
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
+
+for i in `seq 1 $files`; do
     echo -n > $SCRATCH_MNT/$i
     echo XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX > $SCRATCH_MNT/$i
 done
 
 # success, all done
 echo "*** done"
-rm -f $seqres.full
 status=0
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
