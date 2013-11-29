Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B6C7E29E19
	for <xfs@oss.sgi.com>; Fri, 29 Nov 2013 01:03:47 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 54036AC002
	for <xfs@oss.sgi.com>; Thu, 28 Nov 2013 23:03:44 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id JVEmC4OiD2reKpFy (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 28 Nov 2013 23:03:43 -0800 (PST)
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with
	ESMTP id rAT73fuP009580
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 29 Nov 2013 07:03:42 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	rAT73ebH016377
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 29 Nov 2013 07:03:41 GMT
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	rAT73ell015590 for <xfs@oss.sgi.com>; Fri, 29 Nov 2013 07:03:40 GMT
Message-ID: <52983C48.50007@oracle.com>
Date: Fri, 29 Nov 2013 15:03:36 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH 2/3] xfstests: Introduce xfs/323 to verify turn group/project
	quotas off
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

Introduce xfs/323 to verify that turn group/project quotas off
while user quotas is on.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 tests/xfs/323     | 83 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/323.out |  7 +++++
 tests/xfs/group   |  1 +
 3 files changed, 91 insertions(+)
 create mode 100755 tests/xfs/323
 create mode 100644 tests/xfs/323.out

diff --git a/tests/xfs/323 b/tests/xfs/323
new file mode 100755
index 0000000..d84f77c
--- /dev/null
+++ b/tests/xfs/323
@@ -0,0 +1,83 @@
+#! /bin/bash
+# FS QA Test No. 323
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
+_require_xfs_crc_sb
+
+_qmount_option "uquota,gquota,pquota"
+_qmount
+
+TESTDIR=$SCRATCH_MNT/testdir
+
+mkdir -p $TESTDIR
+echo "*** turn off group quotas"
+xfs_quota -x -c 'off -g' $SCRATCH_MNT
+rmdir $TESTDIR
+echo "*** umount"
+umount $SCRATCH_MNT
+
+_qmount
+mkdir -p $TESTDIR
+echo "*** turn off project quotas"
+xfs_quota -x -c 'off -p' $SCRATCH_MNT
+rmdir $TESTDIR
+echo "*** umount"
+umount $SCRATCH_MNT
+
+_qmount
+mkdir -p $TESTDIR
+echo "*** turn off group/project quotas"
+xfs_quota -x -c 'off -gp' $SCRATCH_MNT
+rmdir $TESTDIR
+echo "*** umount"
+umount $SCRATCH_MNT
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/323.out b/tests/xfs/323.out
new file mode 100644
index 0000000..88f16a3
--- /dev/null
+++ b/tests/xfs/323.out
@@ -0,0 +1,7 @@
+QA output created by 323
+*** turn off group quotas
+*** umount
+*** turn off project quotas
+*** umount
+*** turn off group/project quotas
+*** umount
diff --git a/tests/xfs/group b/tests/xfs/group
index dcdeb98..b420e12 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -183,3 +183,4 @@
 301 auto dump
 302 auto dump
 322 auto quick quota
+323 auto quick quota
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
