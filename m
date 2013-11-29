Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 64DC329E19
	for <xfs@oss.sgi.com>; Fri, 29 Nov 2013 01:03:48 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 503228F8054
	for <xfs@oss.sgi.com>; Thu, 28 Nov 2013 23:03:45 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id SNPtjbUNogpNzGZJ (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 28 Nov 2013 23:03:44 -0800 (PST)
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with
	ESMTP id rAT73hpN009606
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 29 Nov 2013 07:03:44 GMT
Received: from aserz7021.oracle.com (aserz7021.oracle.com [141.146.126.230])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	rAT73hrr028211
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 29 Nov 2013 07:03:43 GMT
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
	by aserz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	rAT73hCK028207 for <xfs@oss.sgi.com>; Fri, 29 Nov 2013 07:03:43 GMT
Message-ID: <52983C4B.1090202@oracle.com>
Date: Fri, 29 Nov 2013 15:03:39 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH 3/3] xfstests: introduce xfs/324 to verify turn group/project
	quota off along with fsstress
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

Introduce xfs/324 to verify that we can turn group/project quotas off
while user quota is on and fsstress is running.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 tests/xfs/324     | 89 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/324.out |  7 +++++
 tests/xfs/group   |  1 +
 3 files changed, 97 insertions(+)
 create mode 100755 tests/xfs/324
 create mode 100644 tests/xfs/324.out

diff --git a/tests/xfs/324 b/tests/xfs/324
new file mode 100755
index 0000000..98f5f73
--- /dev/null
+++ b/tests/xfs/324
@@ -0,0 +1,89 @@
+#! /bin/bash
+# FS QA Test No. 324
+#
+# Test to verify that turn group/project quotas off while fstress and
+# user quotas are left on.
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
+
+STRESS_DIR=$SCRATCH_MNT/testdir
+
+_exercise()
+{
+	type=$1
+
+	_qmount
+	mkdir -p $STRESS_DIR
+
+	$FSSTRESS_PROG -d $STRESS_DIR -n 100 -p 1000 $FSSTRESS_AVOID >>/dev/null 2>&1 &
+
+	xfs_quota -x -c "off -$type" $SCRATCH_DEV
+
+	killall -q $FSSTRESS_PROG
+	wait
+
+	rm -rf $STRESS_DIR
+	umount $SCRATCH_MNT
+}
+
+echo "*** turn off group quotas"
+_exercise g
+echo "*** done"
+
+echo "*** turn off project quotas"
+_exercise p
+echo "*** done"
+
+echo "*** turn off group/project quotas"
+_exercise gp
+echo "*** done"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/324.out b/tests/xfs/324.out
new file mode 100644
index 0000000..0f67d93
--- /dev/null
+++ b/tests/xfs/324.out
@@ -0,0 +1,7 @@
+QA output created by 324
+*** turn off group quotas
+*** done
+*** turn off project quotas
+*** done
+*** turn off group/project quotas
+*** done
diff --git a/tests/xfs/group b/tests/xfs/group
index b420e12..b0aa5df 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -184,3 +184,4 @@
 302 auto dump
 322 auto quick quota
 323 auto quick quota
+324 auto quota
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
