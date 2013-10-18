Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2173A7F60
	for <xfs@oss.sgi.com>; Fri, 18 Oct 2013 13:26:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 10D028F8050
	for <xfs@oss.sgi.com>; Fri, 18 Oct 2013 11:26:46 -0700 (PDT)
Received: from dkim2.fusionio.com (dkim2.fusionio.com [66.114.96.54]) by
	cuda.sgi.com with ESMTP id wJ7Oz2cHjToKSavI (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 18 Oct 2013 11:26:45 -0700 (PDT)
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id CDCEE9A0359
	for <xfs@oss.sgi.com>; Fri, 18 Oct 2013 12:26:44 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
Subject: [PATCH 7/8] xfstests: btrfs/017: add a regression test for snapshot
	creation
Date: Fri, 18 Oct 2013 14:26:29 -0400
Message-ID: <1382120790-31060-7-git-send-email-jbacik@fusionio.com>
In-Reply-To: <1382120790-31060-1-git-send-email-jbacik@fusionio.com>
References: <1382120790-31060-1-git-send-email-jbacik@fusionio.com>
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

We had a regression where you couldn't snapshot a file system if you mounted it
ro and then remounted it rw.  This is a test that does just that to make sure we
don't have this problem again.  I ran the test without the fix and it blew up,
and then applied the fix and verified that it passed.  Thanks,

Reviewed-by: Stefan Behrens <sbehrens@giantdisaster.de>
Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 tests/btrfs/017     | 61 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/017.out |  2 ++
 tests/btrfs/group   |  1 +
 3 files changed, 64 insertions(+)
 create mode 100644 tests/btrfs/017
 create mode 100644 tests/btrfs/017.out

diff --git a/tests/btrfs/017 b/tests/btrfs/017
new file mode 100644
index 0000000..d45f32a
--- /dev/null
+++ b/tests/btrfs/017
@@ -0,0 +1,61 @@
+#! /bin/bash
+# FS QA Test No. btrfs/017
+#
+# Regression test to make sure we can create a snapshot after mounting with
+# readonly and remounting rw.
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
+_scratch_mount -o ro
+_scratch_mount -o rw,remount
+
+$BTRFS_UTIL_PROG sub snap $SCRATCH_MNT $SCRATCH_MNT/snap >> $seqres.full 2>&1 \
+	|| _fail "couldn't create snapshot"
+
+echo "Silence is golden"
+status=0 ; exit
diff --git a/tests/btrfs/017.out b/tests/btrfs/017.out
new file mode 100644
index 0000000..8222844
--- /dev/null
+++ b/tests/btrfs/017.out
@@ -0,0 +1,2 @@
+QA output created by 017
+Silence is golden
diff --git a/tests/btrfs/group b/tests/btrfs/group
index 082fd67..be9476d 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -19,3 +19,4 @@
 014 auto
 015 auto quick
 016 auto quick
+017 auto quick
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
