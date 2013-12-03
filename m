Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 169E429E12
	for <xfs@oss.sgi.com>; Tue,  3 Dec 2013 06:00:07 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 94337AC004
	for <xfs@oss.sgi.com>; Tue,  3 Dec 2013 04:00:06 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id MjRq7OIyPpaM7Rwt (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 03 Dec 2013 04:00:05 -0800 (PST)
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with
	ESMTP id rB3C04Gp032658
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 3 Dec 2013 12:00:04 GMT
Received: from userz7021.oracle.com (userz7021.oracle.com [156.151.31.85])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	rB3C03JM004374
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Tue, 3 Dec 2013 12:00:04 GMT
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
	by userz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	rB3C025r019660 for <xfs@oss.sgi.com>; Tue, 3 Dec 2013 12:00:03 GMT
Message-ID: <529DC7BE.7050304@oracle.com>
Date: Tue, 03 Dec 2013 19:59:58 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH v2 3/4] xfstests: xfs/304, verify turn group/project quotas
	off while user quotas is on
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

Introduce xfs/304 to verify that we can turn group/project quotas
off while user quotas is on.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 tests/xfs/304     | 86 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/304.out |  7 +++++
 tests/xfs/group   |  1 +
 3 files changed, 94 insertions(+)
 create mode 100755 tests/xfs/304
 create mode 100644 tests/xfs/304.out

diff --git a/tests/xfs/304 b/tests/xfs/304
new file mode 100755
index 0000000..ef8643a
--- /dev/null
+++ b/tests/xfs/304
@@ -0,0 +1,86 @@
+#! /bin/bash
+# FS QA Test No. 304
+#
+# Test to verify that turn group/project quotas off while user quotas
+# are left on.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2013 Oracle, Inc.  All Rights Reserved.
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
+. ./common/quota
+
+# Modify as appropriate.
+_supported_fs xfs
+_supported_os Linux
+
+_require_scratch
+_require_xfs_quota
+_require_xfs_mkfs_crc
+_require_xfs_crc
+
+_scratch_mkfs_xfs -m crc=1 >/dev/null 2>&1
+
+_qmount_option "uquota,gquota,pquota"
+_qmount
+
+QUOTA_DIR=$SCRATCH_MNT/quota_dir
+
+mkdir -p $QUOTA_DIR
+echo "*** turn off group quotas"
+xfs_quota -x -c 'off -g' $SCRATCH_MNT
+rmdir $QUOTA_DIR
+echo "*** umount"
+umount $SCRATCH_MNT
+
+_qmount
+mkdir -p $QUOTA_DIR
+echo "*** turn off project quotas"
+xfs_quota -x -c 'off -p' $SCRATCH_MNT
+rmdir $QUOTA_DIR
+echo "*** umount"
+umount $SCRATCH_MNT
+
+_qmount
+mkdir -p $QUOTA_DIR
+echo "*** turn off group/project quotas"
+xfs_quota -x -c 'off -gp' $SCRATCH_MNT
+rmdir $QUOTA_DIR
+echo "*** umount"
+umount $SCRATCH_MNT
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/304.out b/tests/xfs/304.out
new file mode 100644
index 0000000..09ab851
--- /dev/null
+++ b/tests/xfs/304.out
@@ -0,0 +1,7 @@
+QA output created by 304
+*** turn off group quotas
+*** umount
+*** turn off project quotas
+*** umount
+*** turn off group/project quotas
+*** umount
diff --git a/tests/xfs/group b/tests/xfs/group
index 7a16c25..7798d62 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -183,3 +183,4 @@
 301 auto dump
 302 auto dump
 303 auto quick quota
+304 auto quick quota
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
