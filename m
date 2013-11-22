Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D999D7F50
	for <xfs@oss.sgi.com>; Fri, 22 Nov 2013 04:09:52 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C1486304059
	for <xfs@oss.sgi.com>; Fri, 22 Nov 2013 02:09:49 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id nud7C3kfeFsSpTTG (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 22 Nov 2013 02:09:48 -0800 (PST)
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with
	ESMTP id rAMA9kxS017599
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 22 Nov 2013 10:09:47 GMT
Received: from aserz7021.oracle.com (aserz7021.oracle.com [141.146.126.230])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	rAMA9k81022265
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 22 Nov 2013 10:09:46 GMT
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
	by aserz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	rAMA9jOq022242 for <xfs@oss.sgi.com>; Fri, 22 Nov 2013 10:09:45 GMT
Message-ID: <528F2D67.9050800@oracle.com>
Date: Fri, 22 Nov 2013 18:09:43 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH v2] xfstests: xfs/322, verify xfs_quota administrator commands
	against invalid mount path
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
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

From: Jie Liu <jeff.liu@oracle.com>

Introduce xfs/322 to verify xfs_quota administrator commands can
deal with invalid XFS mount path properly without NULL pointer
dereference issue.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 v2: support XFS only, mark it belong to quota test group as well

 tests/xfs/322     | 66 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/322.out |  2 ++
 tests/xfs/group   |  1 +
 3 files changed, 69 insertions(+)
 create mode 100755 tests/xfs/322
 create mode 100644 tests/xfs/322.out

diff --git a/tests/xfs/322 b/tests/xfs/322
new file mode 100755
index 0000000..1fcbee4
--- /dev/null
+++ b/tests/xfs/322
@@ -0,0 +1,66 @@
+#! /bin/bash
+# FS QA Test No. 322
+#
+# Test to verify xfs_quota(8) administrator commands can deal with invalid
+# storage mount point without NULL pointer dereference problem.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2013 Oracle Inc.  All Rights Reserved.
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
+_supported_fs xfs
+_supported_os IRIX Linux
+
+echo "Silence is golden"
+
+# To run this sanity check we don't need to enable quota function
+# nor need a scratch device as quota tool will get the mount path
+# at first.
+# An non-existent xfs mount point
+INVALID_PATH="/INVALID_XFS_MOUNT_POINT"
+
+xfs_quota -x -c 'report -a' $INVALID_PATH	2>/dev/null
+xfs_quota -x -c 'state -a' $INVALID_PATH	2>/dev/null
+xfs_quota -x -c 'free -h' $INVALID_PATH		2>/dev/null
+xfs_quota -x -c 'quot -v' $INVALID_PATH		2>/dev/null
+xfs_quota -x -c 'remove' $INALID_PATH		2>/dev/null
+xfs_quota -x -c 'disable' $INVALID_PATH		2>/dev/null
+xfs_quota -x -c 'enable' $INVALID_PATH		2>/dev/null
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/322.out b/tests/xfs/322.out
new file mode 100644
index 0000000..8bcca16
--- /dev/null
+++ b/tests/xfs/322.out
@@ -0,0 +1,2 @@
+QA output created by 322
+Silence is golden
diff --git a/tests/xfs/group b/tests/xfs/group
index 26ea9b6..dcdeb98 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -182,3 +182,4 @@
 300 auto fsr
 301 auto dump
 302 auto dump
+322 auto quick quota
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
