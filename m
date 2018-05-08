Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:51708 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932606AbeEHQyF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 May 2018 12:54:05 -0400
Subject: [PATCH 1/2] xfs: checkbashisms in all script files
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 08 May 2018 09:53:59 -0700
Message-ID: <152579843989.18959.14108003206856326245.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: guaneryu@gmail.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, sandeen@sandeen.net, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Find all the /bin/sh scripts in xfsprogs and check for bashisms.

Cc: sandeen@sandeen.net
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/711     |   51 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/711.out |    1 +
 tests/xfs/group   |    1 +
 3 files changed, 53 insertions(+)
 create mode 100755 tests/xfs/711
 create mode 100644 tests/xfs/711.out


diff --git a/tests/xfs/711 b/tests/xfs/711
new file mode 100755
index 00000000..d15f3b9d
--- /dev/null
+++ b/tests/xfs/711
@@ -0,0 +1,51 @@
+#! /bin/bash
+# FS QA Test No. 711
+#
+# checkbashisms on all /bin/sh scripts.  This is a maintainer script.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2018 Oracle, Inc.
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
+status=1	# failure is the default!
+trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
+
+# get standard environment
+. ./common/rc
+
+# real QA test starts here
+_supported_fs xfs
+_supported_os Linux
+export CHECKBASHISMS_PROG="`set_prog_path checkbashisms`"
+_require_command "$CHECKBASHISMS_PROG" checkbashisms
+
+test -z "$WORKAREA" && _notrun "Can't find xfsprogs source"
+
+rm -f $seqres.full
+
+find $WORKAREA -type f -name 'xfs*.sh' -print0 | xargs -0 grep '^#!.*/bin/sh' | sed -e 's/:.*$//g' | while read f; do
+	$CHECKBASHISMS_PROG $f
+done
+
+status=0
diff --git a/tests/xfs/711.out b/tests/xfs/711.out
new file mode 100644
index 00000000..52ff4745
--- /dev/null
+++ b/tests/xfs/711.out
@@ -0,0 +1 @@
+QA output created by 711
diff --git a/tests/xfs/group b/tests/xfs/group
index 32bf4f71..633dca0c 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -442,3 +442,4 @@
 443 auto quick ioctl fsr
 444 auto quick
 445 auto quick filestreams
+711 auto quick

