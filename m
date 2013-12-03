Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DF15829DF9
	for <xfs@oss.sgi.com>; Tue,  3 Dec 2013 06:00:19 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CDCF9304071
	for <xfs@oss.sgi.com>; Tue,  3 Dec 2013 04:00:19 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id oHzE1tw5dBtOlJqO (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 03 Dec 2013 04:00:18 -0800 (PST)
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with
	ESMTP id rB3C0H3J000577
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 3 Dec 2013 12:00:18 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	rB3C0GZ8005958
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Tue, 3 Dec 2013 12:00:17 GMT
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	rB3C0GEC020678 for <xfs@oss.sgi.com>; Tue, 3 Dec 2013 12:00:16 GMT
Message-ID: <529DC7CC.7090804@oracle.com>
Date: Tue, 03 Dec 2013 20:00:12 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH v2 4/4] xfstests: xfs/305, verify turn group/project quotas
	off along with fsstress
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

Introduce xfs/305 to verify that we can turn group/project quotas
off while user quotas is on and fsstress is running at the same time.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 tests/xfs/305     | 89 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/305.out |  7 +++++
 tests/xfs/group   |  1 +
 3 files changed, 97 insertions(+)
 create mode 100755 tests/xfs/305
 create mode 100644 tests/xfs/305.out

diff --git a/tests/xfs/305 b/tests/xfs/305
new file mode 100755
index 0000000..d925b8b
--- /dev/null
+++ b/tests/xfs/305
@@ -0,0 +1,89 @@
+#! /bin/bash
+# FS QA Test No. 305
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
+_require_xfs_mkfs_crc
+_require_xfs_crc
+
+_scratch_mkfs_xfs -m crc=1 >/dev/null 2>&1
+
+_qmount_option "uquota,gquota,pquota"
+
+QUOTA_DIR=$SCRATCH_MNT/quota_dir
+
+_exercise()
+{
+	type=$1
+
+	_qmount
+	mkdir -p $QUOTA_DIR
+
+	$FSSTRESS_PROG -d $QUOTA_DIR -n 1000 -p 100 $FSSTRESS_AVOID >/dev/null 2>&1 &
+	sleep 10
+	xfs_quota -x -c "off -$type" $SCRATCH_DEV
+	sleep 5
+	killall -q $FSSTRESS_PROG
+	wait
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
diff --git a/tests/xfs/305.out b/tests/xfs/305.out
new file mode 100644
index 0000000..df900b9
--- /dev/null
+++ b/tests/xfs/305.out
@@ -0,0 +1,7 @@
+QA output created by 305
+*** turn off group quotas
+*** done
+*** turn off project quotas
+*** done
+*** turn off group/project quotas
+*** done
diff --git a/tests/xfs/group b/tests/xfs/group
index 7798d62..f6543ed 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -184,3 +184,4 @@
 302 auto dump
 303 auto quick quota
 304 auto quick quota
+305 auto quota
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
