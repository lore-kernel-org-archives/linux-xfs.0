Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 777FB7F52
	for <xfs@oss.sgi.com>; Wed, 25 Nov 2015 14:19:57 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 663F4304059
	for <xfs@oss.sgi.com>; Wed, 25 Nov 2015 12:19:54 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id wB7CrzuzvdlMGeLz (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 25 Nov 2015 12:19:53 -0800 (PST)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 1/2] tests/xfs: test xfsprogs log formatting infrastructure
Date: Wed, 25 Nov 2015 15:19:49 -0500
Message-Id: <1448482790-44469-2-git-send-email-bfoster@redhat.com>
In-Reply-To: <1448482790-44469-1-git-send-email-bfoster@redhat.com>
References: <1448482790-44469-1-git-send-email-bfoster@redhat.com>
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
To: fstests@vger.kernel.org
Cc: xfs@oss.sgi.com

The xfsprogs libxfs layer implements its own log formatting code to
support utilities that might need to format the log, such as mkfs,
repair, metadump, etc. This code is fairly independent from kernel log
writing code. Therefore, add a test that reformats the log from
userspace with various supported log stripe unit alignments and verifies
that the end result is a correctly formatted log.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 common/rc         | 14 +++++++++++
 tests/xfs/376     | 71 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/376.out |  6 +++++
 tests/xfs/group   |  1 +
 4 files changed, 92 insertions(+)
 create mode 100755 tests/xfs/376
 create mode 100644 tests/xfs/376.out

diff --git a/common/rc b/common/rc
index 4c2f42c..a2628d7 100644
--- a/common/rc
+++ b/common/rc
@@ -1654,6 +1654,20 @@ _require_xfs_io_command()
 		_notrun "xfs_io $command failed (old kernel/wrong fs?)"
 }
 
+# check that xfs_db supports a specific command
+_require_xfs_db_command()
+{
+	if [ $# -ne 1 ]
+	then
+		echo "Usage: _require_xfs_db_command command" 1>&2
+		exit 1
+	fi
+	command=$1
+
+	$XFS_DB_PROG -x -c "help" $SCRATCH_DEV | grep $command > /dev/null || \
+		_notrun "xfs_db $command support is missing"
+}
+
 # check that kernel and filesystem support direct I/O
 _require_odirect()
 {
diff --git a/tests/xfs/376 b/tests/xfs/376
new file mode 100755
index 0000000..e8cc15d
--- /dev/null
+++ b/tests/xfs/376
@@ -0,0 +1,71 @@
+#! /bin/bash
+# FS QA Test No. 376
+#
+# This test verifies that the xfsprogs log formatting infrastructure works
+# correctly for various log stripe unit values. The log is formatted with xfs_db
+# and verified with xfs_logprint.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2015 Red Hat, Inc. All Rights Reserved.
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
+	cd /
+	rm -f $tmp.*
+}
+
+rm -f $seqres.full
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/log
+
+# real QA test starts here
+
+# Modify as appropriate.
+_supported_fs xfs
+_supported_os Linux
+_require_scratch
+_require_v2log
+_require_xfs_db_command "logformat"
+
+_scratch_mkfs >> $seqres.full 2>&1 || _fail "mkfs failed"
+
+# Reformat the log with various log stripe unit sizes and see if logprint dumps
+# any errors. Use a cycle value larger than 1 so the log is actually written
+# (the log is zeroed when cycle == 1).
+for i in 16 32 64 128 256; do
+	lsunit=$((i * 1024))
+	$XFS_DB_PROG -x -c "logformat -c 3 -s $lsunit" $SCRATCH_DEV | \
+		tee -a $seqres.full
+	# don't redirect error output so it causes test failure
+	$XFS_LOGPRINT_PROG $SCRATCH_DEV >> $seqres.full
+done
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/376.out b/tests/xfs/376.out
new file mode 100644
index 0000000..b13a150
--- /dev/null
+++ b/tests/xfs/376.out
@@ -0,0 +1,6 @@
+QA output created by 376
+Formatting the log to cycle 3, stripe unit 16384 bytes.
+Formatting the log to cycle 3, stripe unit 32768 bytes.
+Formatting the log to cycle 3, stripe unit 65536 bytes.
+Formatting the log to cycle 3, stripe unit 131072 bytes.
+Formatting the log to cycle 3, stripe unit 262144 bytes.
diff --git a/tests/xfs/group b/tests/xfs/group
index 9884329..77b9994 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -226,3 +226,4 @@
 303 auto quick quota
 304 auto quick quota
 305 auto quota
+376 auto logprint quick v2log
-- 
2.1.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
