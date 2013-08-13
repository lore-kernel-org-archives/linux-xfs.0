Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 99A7A7F7C
	for <xfs@oss.sgi.com>; Tue, 13 Aug 2013 14:34:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0CC35AC001
	for <xfs@oss.sgi.com>; Tue, 13 Aug 2013 12:34:23 -0700 (PDT)
Received: from dkim2.fusionio.com (dkim2.fusionio.com [66.114.96.54]) by
	cuda.sgi.com with ESMTP id PK3XRQaUHgirDjBA (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 13 Aug 2013 12:34:22 -0700 (PDT)
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 5D2219A06B5
	for <xfs@oss.sgi.com>; Tue, 13 Aug 2013 13:34:21 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
Subject: [PATCH] xfstests: btrfs/003: regression test for subvol delete V2
Date: Tue, 13 Aug 2013 15:34:18 -0400
Message-ID: <1376422458-2339-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
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
To: linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

We were allowing users to delete their default subvolume, which is problematic.
This test is a regression test to make sure we don't let that happen in the
future.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
V1->V2: address the comments made by Eric Sandeen.

 tests/btrfs/003     |   66 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/003.out |    2 +
 tests/btrfs/group   |    1 +
 3 files changed, 69 insertions(+), 0 deletions(-)
 create mode 100755 tests/btrfs/003
 create mode 100644 tests/btrfs/003.out

diff --git a/tests/btrfs/003 b/tests/btrfs/003
new file mode 100755
index 0000000..aba883d
--- /dev/null
+++ b/tests/btrfs/003
@@ -0,0 +1,66 @@
+#! /bin/bash
+# FS QA Test No. btrfs/003
+#
+# Regression test to make sure we can't delete the default subvol
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2013 Fusion IO.  All Rights Reserved.
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
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+
+status=1	# failure is the default!
+
+_cleanup()
+{
+	rm -f $tmp.*
+}
+
+trap "_cleanup ; exit \$status" 0 1 2 3 15
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+_supported_fs btrfs
+_supported_os Linux
+_require_scratch
+
+_scratch_mkfs > /dev/null 2>&1
+_scratch_mount
+
+# This will be set to subvolid 256.  If this ever changes in the future for
+# whatever reason we'll have to pull the subvolid out of the subvol list command
+# but since it's a newly mkfs'ed fs we should be fine with this.
+$BTRFS_UTIL_PROG sub create $SCRATCH_MNT/newvol >> $seqres.full 2>&1 \
+	|| _fail "couldn't create subvol"
+subvolid=$($BTRFS_UTIL_PROG sub list $SCRATCH_MNT | grep newvol | awk '{ print $2 }')
+$BTRFS_UTIL_PROG sub set-default $subvolid $SCRATCH_MNT >> $seqres.full 2>&1 \
+	|| _fail "couldn't set default"
+$BTRFS_UTIL_PROG sub delete $SCRATCH_MNT/newvol >> $seqres.full 2>&1
+_scratch_unmount
+_scratch_mount || _fail "mount should have succeeded"
+
+echo "Silence is golden"
+status=0 ; exit
diff --git a/tests/btrfs/003.out b/tests/btrfs/003.out
new file mode 100644
index 0000000..6895fc8
--- /dev/null
+++ b/tests/btrfs/003.out
@@ -0,0 +1,2 @@
+QA output created by 003
+Silence is golden
diff --git a/tests/btrfs/group b/tests/btrfs/group
index 5b65068..86f5a5a 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -5,6 +5,7 @@
 #
 001 auto quick
 002 auto quick
+003 auto quick
 254 auto quick
 264 auto
 265 auto
-- 
1.7.7.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
