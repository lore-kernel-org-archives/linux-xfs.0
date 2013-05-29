Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5CCD07F37
	for <xfs@oss.sgi.com>; Wed, 29 May 2013 17:30:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3D4BA304071
	for <xfs@oss.sgi.com>; Wed, 29 May 2013 15:30:20 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id bYzZZH3y3K4hGAKF for
	<xfs@oss.sgi.com>; Wed, 29 May 2013 15:30:19 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r4TMUGl2022992
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Wed, 29 May 2013 18:30:18 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id r4TMUDnH002616
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Wed, 29 May 2013 18:30:15 -0400
Message-ID: <51A68175.9020202@redhat.com>
Date: Wed, 29 May 2013 17:30:13 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfstests: generic/313, test sgid inheritance on subdirs
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

On XFS this test fails today due to some over-eager
SGID removal in xfs core code; ext4 & btrfs pass.
Document it in a test, will send xfs patch in a bit.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

p.s.  I'm going to just flaunt my ignorance and say:
I've never understood acls well.  I'm hoping someone who does
can help me write a better changelog, because this one
is no good at all!

diff --git a/tests/generic/313 b/tests/generic/313
new file mode 100755
index 0000000..289fd6f
--- /dev/null
+++ b/tests/generic/313
@@ -0,0 +1,67 @@
+#! /bin/bash
+# FS QA Test No. 313
+#
+# Test SGID inheritance on subdirectories
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
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+_supported_fs generic
+_require_acls
+_require_user
+_need_to_be_root
+
+rm -rf $TEST_DIR/$seq-dir
+
+# Make dir owned by qa user, and an unrelated group:
+mkdir $TEST_DIR/$seq-dir
+chown $qa_user:12345 $TEST_DIR/$seq-dir
+
+# Make parent dir sgid
+chmod 2775 $TEST_DIR/$seq-dir
+
+# Make subdirs before & after acl set
+su $qa_user -c "mkdir $TEST_DIR/$seq-dir/subdir"
+su $qa_user -c "setfacl -m u:$qa_user:rwx,d:u:$qa_user:rwx $TEST_DIR/$seq-dir"
+su $qa_user -c "mkdir $TEST_DIR/$seq-dir/subdir2"
+
+# Both subdirs should have inherited sgid
+ls -ld $TEST_DIR/$seq-dir/subdir* | _filter_test_dir | awk '{print $1,$NF}'
+
+status=0
+exit
diff --git a/tests/generic/313.out b/tests/generic/313.out
new file mode 100644
index 0000000..326a929
--- /dev/null
+++ b/tests/generic/313.out
@@ -0,0 +1,3 @@
+QA output created by 313
+drwxr-sr-x. TEST_DIR/313-dir/subdir
+drwxrwsr-x+ TEST_DIR/313-dir/subdir2
diff --git a/tests/generic/group b/tests/generic/group
index bd443c1..d5ec8d5 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -115,3 +115,4 @@
 310 auto
 311 auto metadata log
 312 auto quick prealloc enospc
+313 auto quick acl

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
