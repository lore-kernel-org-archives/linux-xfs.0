Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 695D429E0D
	for <xfs@oss.sgi.com>; Mon,  1 Apr 2013 05:58:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E9F8BAC007
	for <xfs@oss.sgi.com>; Mon,  1 Apr 2013 03:58:06 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id VLiXyIqMfvx4FRhb for
	<xfs@oss.sgi.com>; Mon, 01 Apr 2013 03:58:05 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r31Aw5ZO011203
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Mon, 1 Apr 2013 06:58:05 -0400
From: Eryu Guan <eguan@redhat.com>
Subject: [PATCH 4/4] xfstests generic 311: test dir mtime and ctime are
	updated on rename
Date: Mon,  1 Apr 2013 18:57:44 +0800
Message-Id: <1364813864-10820-5-git-send-email-eguan@redhat.com>
In-Reply-To: <1364813864-10820-1-git-send-email-eguan@redhat.com>
References: <1364813864-10820-1-git-send-email-eguan@redhat.com>
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

Test directory mtime and ctime are updated when moving a file onto an
existing file in the directory

Regression test for commit:
0b23076 ext3: fix update of mtime and ctime on rename

Signed-off-by: Eryu Guan <eguan@redhat.com>
---
 tests/generic/311     | 74 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/311.out |  2 ++
 tests/generic/group   |  1 +
 3 files changed, 77 insertions(+)
 create mode 100644 tests/generic/311
 create mode 100644 tests/generic/311.out

diff --git a/tests/generic/311 b/tests/generic/311
new file mode 100644
index 0000000..46cc791
--- /dev/null
+++ b/tests/generic/311
@@ -0,0 +1,74 @@
+#! /bin/bash
+# FS QA Test No. 311
+#
+# Test directory mtime and ctime are updated when moving a file onto an
+# existing file in the directory
+#
+# Regression test for commit:
+# 0b23076 ext3: fix update of mtime and ctime on rename
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
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+status=0	# success is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+    cd /
+    rm -rf $TEST_DIR/testdir_$seq
+    rm -f $TEST_DIR/testfile.$seq
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+_supported_fs generic
+_supported_os IRIX Linux
+
+echo "Silence is golden"
+
+mkdir -p $TEST_DIR/testdir_$seq
+touch $TEST_DIR/testdir_$seq/testfile
+touch $TEST_DIR/testfile.$seq
+
+mtime1=`stat -c %Y $TEST_DIR/testdir_$seq`
+ctime1=`stat -c %Z $TEST_DIR/testdir_$seq`
+
+sleep 1
+mv $TEST_DIR/testfile.$seq $TEST_DIR/testdir_$seq/testfile
+
+mtime2=`stat -c %Y $TEST_DIR/testdir_$seq`
+ctime2=`stat -c %Z $TEST_DIR/testdir_$seq`
+
+if [ "$mtime1" == "$mtime2" ]; then
+	echo "mtime not updated"
+	let status=$status+1
+fi
+if [ "$ctime1" == "$ctime2" ]; then
+	echo "ctime not updated"
+	let status=$status+1
+fi
+
+exit
diff --git a/tests/generic/311.out b/tests/generic/311.out
new file mode 100644
index 0000000..62f2530
--- /dev/null
+++ b/tests/generic/311.out
@@ -0,0 +1,2 @@
+QA output created by 311
+Silence is golden
diff --git a/tests/generic/group b/tests/generic/group
index 9ff2ab1..1f4b62e 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -111,3 +111,4 @@
 306 auto quick rw
 308 auto quick
 309 auto quick
+311 auto quick
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
