Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o736HmYr227950 for <xfs@oss.sgi.com>; Tue, 3 Aug 2010 01:17:49 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AB06148E3D6
	for <xfs@oss.sgi.com>; Mon,  2 Aug 2010 23:18:06 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	0ECpHzKeHjLuQCZa for <xfs@oss.sgi.com>;
	Mon, 02 Aug 2010 23:18:06 -0700 (PDT)
Received: from dastard (unverified [121.44.216.100])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	33661580-1927428
	for <xfs@oss.sgi.com>; Tue, 03 Aug 2010 15:48:05 +0930 (CST)
Received: from disturbed ([192.168.1.9]) by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1OgAp9-00078v-AU
	for xfs@oss.sgi.com; Tue, 03 Aug 2010 16:18:03 +1000
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1OgAp3-0007fp-7h
	for xfs@oss.sgi.com; Tue, 03 Aug 2010 16:17:57 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfstests: add a test for XFS_IOC_ZERO_RANGE
Date: Tue,  3 Aug 2010 16:17:57 +1000
Message-Id: <1280816277-29473-1-git-send-email-david@fromorbit.com>
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

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 241     |  192 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 241.out |   57 +++++++++++++++++++
 group   |    1 +
 3 files changed, 250 insertions(+), 0 deletions(-)
 create mode 100644 241
 create mode 100644 241.out

diff --git a/241 b/241
new file mode 100644
index 0000000..b627438
--- /dev/null
+++ b/241
@@ -0,0 +1,192 @@
+#! /bin/bash
+# FS QA Test No. 241
+#
+# Test XFS_IOC_ZERO_RANGE
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2010 Red Hat.  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+#
+#-----------------------------------------------------------------------
+#
+# creator
+owner=dchinner@redhat.com
+
+seq=`basename $0`
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+
+_cleanup()
+{
+    rm -f $tmp.*
+}
+
+trap "_cleanup ; exit \$status" 0 1 2 3 15
+
+# get standard environment, filters and checks
+. ./common.rc
+. ./common.filter
+
+# real QA test starts here
+_supported_fs xfs
+_supported_os Linux
+
+die_now()
+{
+	status=1
+	exit
+}
+
+_filter_bmap()
+{
+    awk '$3 ~ /hole/ { print $1, $2, $3; next }
+         $7 ~ /10000/ { print $1, $2, "unwritten"; next }
+         $7 ~ /00000/ {print $1, $2, "data" }'
+}
+
+# test the different corner cases for zeroing a range:
+#
+#	1. into a hole
+#	2. into allocated space
+#	3. into unwritten space
+#	4. hole -> data
+#	5. hole -> unwritten
+#	6. data -> hole
+#	7. data -> unwritten
+#	8. unwritten -> hole
+#	9. unwritten -> data
+#	10. hole -> data -> hole
+#	11. data -> hole -> data
+#	12. unwritten -> data -> unwritten
+#	13. data -> unwritten -> data
+
+testfile=$TEST_DIR/241.$$
+
+echo "	1. into a hole"
+rm -f $testfile
+$XFS_IO_PROG -f -c "truncate 20k" \
+	-c "zero 4k 8k" \
+	-c "bmap -vp" $testfile | _filter_bmap
+[ $? -ne 0 ] && die_now
+
+echo "	2. into allocated space"
+rm -f $testfile
+$XFS_IO_PROG -f -c "truncate 20k" \
+	-c "pwrite 0 20k" -c "fsync" \
+	-c "zero 4k 8k" \
+	-c "bmap -vp" $testfile | _filter_bmap
+[ $? -ne 0 ] && die_now
+
+echo "	3. into unwritten space"
+rm -f $testfile
+$XFS_IO_PROG -f -c "truncate 20k" \
+	-c "resvsp 0 20k" \
+	-c "zero 4k 8k" \
+	-c "bmap -vp" $testfile | _filter_bmap
+[ $? -ne 0 ] && die_now
+
+echo "	4. hole -> data"
+rm -f $testfile
+$XFS_IO_PROG -f -c "truncate 20k" \
+	-c "pwrite 8k 8k" -c "fsync" \
+	-c "zero 4k 8k" \
+	-c "bmap -vp" $testfile | _filter_bmap
+[ $? -ne 0 ] && die_now
+
+echo "	5. hole -> unwritten"
+rm -f $testfile
+$XFS_IO_PROG -f -c "truncate 20k" \
+	-c "resvsp 8k 8k" \
+	-c "zero 4k 8k" \
+	-c "bmap -vp" $testfile | _filter_bmap
+[ $? -ne 0 ] && die_now
+
+echo "	6. data -> hole"
+rm -f $testfile
+$XFS_IO_PROG -f -c "truncate 20k" \
+	-c "pwrite 0 8k" -c "fsync" \
+	-c "zero 4k 8k" \
+	-c "bmap -vp" $testfile | _filter_bmap
+[ $? -ne 0 ] && die_now
+
+echo "	7. data -> unwritten"
+rm -f $testfile
+$XFS_IO_PROG -f -c "truncate 20k" \
+	-c "pwrite 0 8k" -c "fsync" \
+	-c "resvsp 8k 8k" \
+	-c "zero 4k 8k" \
+	-c "bmap -vp" $testfile | _filter_bmap
+[ $? -ne 0 ] && die_now
+
+echo "	8. unwritten -> hole"
+rm -f $testfile
+$XFS_IO_PROG -f -c "truncate 20k" \
+	-c "resvsp 0 8k" \
+	-c "zero 4k 8k" \
+	-c "bmap -vp" $testfile | _filter_bmap
+[ $? -ne 0 ] && die_now
+
+echo "	9. unwritten -> data"
+rm -f $testfile
+$XFS_IO_PROG -f -c "truncate 20k" \
+	-c "resvsp 0 8k" \
+	-c "pwrite 8k 8k" -c "fsync" \
+	-c "zero 4k 8k" \
+	-c "bmap -vp" $testfile | _filter_bmap
+[ $? -ne 0 ] && die_now
+
+echo "	10. hole -> data -> hole"
+rm -f $testfile
+$XFS_IO_PROG -f -c "truncate 20k" \
+	-c "pwrite 8k 4k" -c "fsync" \
+	-c "zero 4k 12k" \
+	-c "bmap -vp" $testfile | _filter_bmap
+[ $? -ne 0 ] && die_now
+
+echo "	11. data -> hole -> data"
+rm -f $testfile
+$XFS_IO_PROG -f -c "truncate 20k" \
+	-c "resvsp 0 20k" \
+	-c "pwrite 0 8k" \
+	-c "pwrite 12k 8k" -c "fsync" \
+	-c "unresvsp 8k 4k" \
+	-c "zero 4k 12k" \
+	-c "bmap -vp" $testfile | _filter_bmap
+[ $? -ne 0 ] && die_now
+
+echo "	12. unwritten -> data -> unwritten"
+rm -f $testfile
+$XFS_IO_PROG -f -c "truncate 20k" \
+	-c "resvsp 0 20k" \
+	-c "pwrite 8k 4k" -c "fsync" \
+	-c "zero 4k 12k" \
+	-c "bmap -vp" $testfile | _filter_bmap
+[ $? -ne 0 ] && die_now
+
+
+echo "	13. data -> unwritten -> data"
+rm -f $testfile
+$XFS_IO_PROG -f -c "truncate 20k" \
+	-c "resvsp 0 20k" \
+	-c "pwrite 0k 8k" -c "fsync" \
+	-c "pwrite 12k 8k" -c "fsync" \
+	-c "zero 4k 12k" \
+	-c "bmap -vp" $testfile | _filter_bmap
+[ $? -ne 0 ] && die_now
+
+status=0 ; exit
diff --git a/241.out b/241.out
new file mode 100644
index 0000000..7b3481f
--- /dev/null
+++ b/241.out
@@ -0,0 +1,57 @@
+QA output created by 241
+	1. into a hole
+0: [0..7]: hole
+1: [8..23]: unwritten
+2: [24..39]: hole
+	2. into allocated space
+0: [0..7]: data
+1: [8..23]: unwritten
+2: [24..39]: data
+	3. into unwritten space
+0: [0..39]: unwritten
+	4. hole -> data
+0: [0..7]: hole
+1: [8..15]: unwritten
+2: [16..23]: unwritten
+3: [24..31]: data
+4: [32..39]: hole
+	5. hole -> unwritten
+0: [0..7]: hole
+1: [8..15]: unwritten
+2: [16..31]: unwritten
+3: [32..39]: hole
+	6. data -> hole
+0: [0..7]: data
+1: [8..15]: unwritten
+2: [16..23]: unwritten
+3: [24..39]: hole
+	7. data -> unwritten
+0: [0..7]: data
+1: [8..15]: unwritten
+2: [16..31]: unwritten
+3: [32..39]: hole
+	8. unwritten -> hole
+0: [0..15]: unwritten
+1: [16..23]: unwritten
+2: [24..39]: hole
+	9. unwritten -> data
+0: [0..15]: unwritten
+1: [16..23]: unwritten
+2: [24..31]: data
+3: [32..39]: hole
+	10. hole -> data -> hole
+0: [0..7]: hole
+1: [8..15]: unwritten
+2: [16..23]: unwritten
+3: [24..31]: unwritten
+4: [32..39]: hole
+	11. data -> hole -> data
+0: [0..7]: data
+1: [8..31]: unwritten
+2: [32..39]: data
+	12. unwritten -> data -> unwritten
+0: [0..39]: unwritten
+	13. data -> unwritten -> data
+0: [0..7]: data
+1: [8..31]: unwritten
+2: [32..39]: data
diff --git a/group b/group
index afe7614..f6e8d7b 100644
--- a/group
+++ b/group
@@ -354,3 +354,4 @@ deprecated
 238 auto quick metadata ioctl
 239 auto aio rw
 240 auto aio quick rw
+241 auto quick prealloc
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
