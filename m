Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:36040 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750745AbdLMGEK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Dec 2017 01:04:10 -0500
Subject: [PATCH 7/8] generic: run a long-soak write-only fsstress test
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 12 Dec 2017 22:04:04 -0800
Message-ID: <151314504409.18893.7360024939760569598.stgit@magnolia>
In-Reply-To: <151314499003.18893.8687182548758898133.stgit@magnolia>
References: <151314499003.18893.8687182548758898133.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: eguan@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Let a lot of writes soak in with multithreaded fsstress to look for bugs
and other problems.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/generic/933     |   64 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/933.out |    2 ++
 tests/generic/group   |    1 +
 3 files changed, 67 insertions(+)
 create mode 100755 tests/generic/933
 create mode 100644 tests/generic/933.out


diff --git a/tests/generic/933 b/tests/generic/933
new file mode 100755
index 0000000..0cbd081
--- /dev/null
+++ b/tests/generic/933
@@ -0,0 +1,64 @@
+#! /bin/bash
+# FS QA Test No. 933
+#
+# Run an all-writes fsstress run with multiple threads to shake out
+# bugs in the write path.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2017 Oracle, Inc.  All Rights Reserved.
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
+	$KILLALL_PROG -9 fsstress > /dev/null 2>&1
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+
+# Modify as appropriate.
+_supported_fs generic
+_supported_os Linux
+
+_require_scratch
+_require_command "$KILLALL_PROG" "killall"
+
+rm -f $seqres.full
+
+echo "Silence is golden."
+
+_scratch_mkfs > $seqres.full 2>&1
+_scratch_mount >> $seqres.full 2>&1
+
+nr_cpus=$((LOAD_FACTOR * 4))
+nr_ops=$((25000 * nr_cpus * TIME_FACTOR))
+$FSSTRESS_PROG $FSSTRESS_AVOID -w -d $SCRATCH_MNT -n $nr_ops -p $nr_cpus -v >> $seqres.full
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/933.out b/tests/generic/933.out
new file mode 100644
index 0000000..758765d
--- /dev/null
+++ b/tests/generic/933.out
@@ -0,0 +1,2 @@
+QA output created by 933
+Silence is golden.
diff --git a/tests/generic/group b/tests/generic/group
index ff1ddc9..3c4fff5 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -473,3 +473,4 @@
 468 shutdown auto quick metadata
 469 auto quick
 932 shutdown auto log metadata
+933 auto rw clone

