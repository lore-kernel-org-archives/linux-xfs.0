Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 34DA87F4C
	for <xfs@oss.sgi.com>; Mon, 18 Feb 2013 22:16:03 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 24B1330404E
	for <xfs@oss.sgi.com>; Mon, 18 Feb 2013 20:16:00 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id fOOZI3ahpisWUAfS for
	<xfs@oss.sgi.com>; Mon, 18 Feb 2013 20:15:59 -0800 (PST)
Received: from int-mx12.intmail.prod.int.phx2.redhat.com
	(int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r1J4FwkF017232
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Mon, 18 Feb 2013 23:15:58 -0500
From: Eryu Guan <eguan@redhat.com>
Subject: [PATCH v4] xfstests 297: test xfs direct IO nested transaction
	deadlock
Date: Tue, 19 Feb 2013 12:15:28 +0800
Message-Id: <1361247328-22175-1-git-send-email-eguan@redhat.com>
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
Cc: Eryu Guan <eguan@redhat.com>

Regression test case for commit:

437a255 xfs: fix direct IO nested transaction deadlock.

Signed-off-by: Eryu Guan <eguan@redhat.com>
---
v4:
	1. rebase on top of master
v3:
	1. rename TESTDIR to STRESS_DIR
	2. decrease variable by using "let"
	3. call wait instead of sync after killing all fsstress processes
	4. rebase on top of master
v2:
	1. drop generic freeze vs fsstress test, 068 has done this
	2. remove unnecessary _scratch_unmount
	3. rm $seq.full before _scratch_mkfs_xfs
	4. remove unnecessary sleep
	5. remove unnecessary output
	6. run fixed number(10) of iterations of freeze/thaw cycles
	7. remove from dangerous group

 297     | 88 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 297.out |  3 +++
 group   |  1 +
 3 files changed, 92 insertions(+)
 create mode 100644 297
 create mode 100644 297.out

diff --git a/297 b/297
new file mode 100644
index 0000000..a7ea491
--- /dev/null
+++ b/297
@@ -0,0 +1,88 @@
+#! /bin/bash
+# FS QA Test No. 297
+#
+# Test freeze/unfreeze file system randomly under fsstress
+# Regression test for commit:
+# 437a255 xfs: fix direct IO nested transaction deadlock.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2013 Red Hat, Inc.  All Rights Reserved.
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
+#-----------------------------------------------------------------------
+#
+# creator
+owner=eguan@redhat.com
+
+seq=`basename $0`
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+    cd /
+    rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common.rc
+. ./common.filter
+
+# real QA test starts here
+_supported_fs xfs
+_supported_os IRIX Linux
+
+_require_scratch
+_require_freeze
+
+rm -f $seq.full
+_scratch_mkfs_xfs -d agcount=16,su=256k,sw=12 -l su=256k,size=2560b >/dev/null 2>&1
+_scratch_mount >/dev/null 2>&1
+
+STRESS_DIR="$SCRATCH_MNT/testdir"
+mkdir -p $STRESS_DIR
+
+$FSSTRESS_PROG -d $STRESS_DIR -n 100 -p 1000 $FSSTRESS_AVOID >/dev/null 2>&1 &
+
+# Freeze/unfreeze file system randomly
+echo "Start freeze/unfreeze randomly" | tee -a $seq.full
+LOOP=10
+while [ $LOOP -gt 0 ];do
+	TIMEOUT=`expr $RANDOM % 5`
+	sleep $TIMEOUT
+	echo "* Freeze file system after sleeping $TIMEOUT seconds" >>$seq.full
+	xfs_freeze -f $SCRATCH_MNT
+	if [ $? -ne 0 ];then
+		echo " - Error: freeze filesystem failed" | tee -a $seq.full
+	fi
+	TIMEOUT=`expr $RANDOM % 3`
+	sleep $TIMEOUT
+	echo "* Unfreeze file system after sleeping $TIMEOUT seconds" >>$seq.full
+	xfs_freeze -u $SCRATCH_MNT
+	if [ $? -ne 0 ];then
+		echo " - Error: unfreeze filesystem failed" | tee -a $seq.full
+	fi
+	let LOOP=$LOOP-1
+done
+echo "Test done" | tee -a $seq.full
+killall -q $FSSTRESS_PROG
+wait
+
+_check_scratch_fs
+status=0
+exit
diff --git a/297.out b/297.out
new file mode 100644
index 0000000..f9ea257
--- /dev/null
+++ b/297.out
@@ -0,0 +1,3 @@
+QA output created by 297
+Start freeze/unfreeze randomly
+Test done
diff --git a/group b/group
index eb4f375..d6df4de 100644
--- a/group
+++ b/group
@@ -415,3 +415,4 @@ deprecated
 294 auto quick
 295 auto logprint quick
 296 dump auto quick
+297 auto freeze
-- 
1.8.0.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
