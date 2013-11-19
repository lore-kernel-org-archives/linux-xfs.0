Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 692447F4E
	for <xfs@oss.sgi.com>; Tue, 19 Nov 2013 00:57:37 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 380648F804B
	for <xfs@oss.sgi.com>; Mon, 18 Nov 2013 22:57:34 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id 1eUucq1CixGUHSoV (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 18 Nov 2013 22:57:29 -0800 (PST)
From: Anand Jain <anand.jain@oracle.com>
Subject: [PATCH] xfstests: btrfs/023: test if raids are actually created
Date: Tue, 19 Nov 2013 15:06:25 +0800
Message-Id: <1384844785-24799-1-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1384763177-3402-1-git-send-email-anand.jain@oracle.com>
References: <1384763177-3402-1-git-send-email-anand.jain@oracle.com>
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
To: linux-btrfs@vger.kernel.org, xfs@oss.sgi.com
Cc: sandeen@sandeen.net

A test case to verify if the given raid option for the
metadata and data are actually created.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
Reviewed-by: Eric Sandeen <sandeen@redhat.com>
---
 v3: need to differentiate between RAID10 and RAID1 in the output,
     fixed the grep
 v2: a copied comment removed as Eric pointed out

 tests/btrfs/023     |   90 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/023.out |    2 +
 tests/btrfs/group   |    1 +
 3 files changed, 93 insertions(+), 0 deletions(-)
 create mode 100755 tests/btrfs/023
 create mode 100644 tests/btrfs/023.out

diff --git a/tests/btrfs/023 b/tests/btrfs/023
new file mode 100755
index 0000000..da1f818
--- /dev/null
+++ b/tests/btrfs/023
@@ -0,0 +1,90 @@
+#! /bin/bash
+# FS QA Test No. 023
+#
+# Test to verify if the group profile is created
+#
+# The test aims to create the raid and verify that its created
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2013 Oracle.  All Rights Reserved.
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
+_supported_fs btrfs
+_supported_os Linux
+_require_scratch_dev_pool 4
+rm -f $seqres.full
+
+create_group_profile()
+{
+	local mkfs_options="-d$1 -m$1"
+
+	_scratch_pool_mkfs $mkfs_options >> $seqres.full 2>&1 || _fail "mkfs failed"
+}
+
+check_group_profile()
+{
+	local test_raid="$1"
+
+	_scratch_mount
+	$BTRFS_UTIL_PROG filesystem df $SCRATCH_MNT > $tmp.tmp 2>&1
+	_scratch_unmount
+	cat $tmp.tmp >> $seqres.full
+	grep Data $tmp.tmp | grep -q "${test_raid}:"
+	[ $? -eq 0 ] || _fail "$test_raid not found for Data"
+	grep Metadata $tmp.tmp | grep -q "${test_raid}:"
+	[ $? -eq 0 ] || _fail "$test_raid not found for Metadata"
+}
+
+create_group_profile "raid0"
+check_group_profile "RAID0"
+
+create_group_profile "raid1"
+check_group_profile "RAID1"
+
+create_group_profile "raid10"
+check_group_profile "RAID10"
+
+create_group_profile "raid5"
+check_group_profile "RAID5"
+
+create_group_profile "raid6"
+check_group_profile "RAID6"
+
+# success, all done
+echo "Silence is golden"
+status=0
+exit
diff --git a/tests/btrfs/023.out b/tests/btrfs/023.out
new file mode 100644
index 0000000..5c4197b
--- /dev/null
+++ b/tests/btrfs/023.out
@@ -0,0 +1,2 @@
+QA output created by 023
+Silence is golden
diff --git a/tests/btrfs/group b/tests/btrfs/group
index 410f8ed..35db67b 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -24,3 +24,4 @@
 019 auto quick
 020 auto quick
 021 auto quick
+023 auto
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
