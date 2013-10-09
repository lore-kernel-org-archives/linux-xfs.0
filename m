Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 493037FBE
	for <xfs@oss.sgi.com>; Wed,  9 Oct 2013 14:04:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1CF62304062
	for <xfs@oss.sgi.com>; Wed,  9 Oct 2013 12:04:45 -0700 (PDT)
Received: from dkim2.fusionio.com (dkim2.fusionio.com [66.114.96.54]) by
	cuda.sgi.com with ESMTP id RBocphzH8NEN3YmY (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 09 Oct 2013 12:04:40 -0700 (PDT)
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 4C2C79A06C2
	for <xfs@oss.sgi.com>; Wed,  9 Oct 2013 13:04:40 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
Subject: [PATCH] xfstests: btrfs/016: a regression test for subvolume rename
Date: Wed, 9 Oct 2013 15:04:37 -0400
Message-ID: <1381345477-7902-1-git-send-email-jbacik@fusionio.com>
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

A user reported a regression where we could no longer rename a subvolume into
another subvolume.  This is a test case to do just that to make sure we don't
regress on this again.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 tests/btrfs/016     | 61 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/016.out |  2 ++
 tests/btrfs/group   |  1 +
 3 files changed, 64 insertions(+)
 create mode 100644 tests/btrfs/016
 create mode 100644 tests/btrfs/016.out

diff --git a/tests/btrfs/016 b/tests/btrfs/016
new file mode 100644
index 0000000..09a8b8b
--- /dev/null
+++ b/tests/btrfs/016
@@ -0,0 +1,61 @@
+#! /bin/bash
+# FS QA Test No. btrfs/016
+#
+# Regression test to make sure we can move a subvol into another subvol
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
+rm -f $seqres.full
+
+_scratch_mkfs > /dev/null 2>&1
+_scratch_mount
+$BTRFS_UTIL_PROG subvolume create $SCRATCH_MNT/test1 >> $seqres.full 2>&1 \
+	|| _fail "couldn't create test1"
+$BTRFS_UTIL_PROG subvolume create $SCRATCH_MNT/test2 >> $seqres.full 2>&1 \
+	|| _fail "couldn't create test1"
+mv $SCRATCH_MNT/test1 $SCRATCH_MNT/test2 || _fail "Problem doing move"
+
+echo "Silence is golden"
+status=0 ; exit
diff --git a/tests/btrfs/016.out b/tests/btrfs/016.out
new file mode 100644
index 0000000..aa2526b
--- /dev/null
+++ b/tests/btrfs/016.out
@@ -0,0 +1,2 @@
+QA output created by 016
+Silence is golden
diff --git a/tests/btrfs/group b/tests/btrfs/group
index dc5bbea..65d93b9 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -18,3 +18,4 @@
 013 auto quick
 014 auto quick
 015 auto quick
+016 auto quick
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
