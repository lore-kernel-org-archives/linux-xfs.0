Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:51274 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751535AbeEBPDx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 2 May 2018 11:03:53 -0400
Date: Wed, 2 May 2018 08:03:48 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2 8/9] xfs: checkbashisms in all script files
Message-ID: <20180502150348.GU4127@magnolia>
References: <152518916007.23023.4793255395982876953.stgit@magnolia>
 <152518921090.23023.14958881774088486712.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152518921090.23023.14958881774088486712.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@sandeen.net
Cc: linux-xfs@vger.kernel.org, guaneryu@gmail.com, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Find all the /bin/sh scripts in xfsprogs and check for bashisms.

Cc: sandeen@sandeen.net
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v2: fix find and regex we look for
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
index 39e259e8..b7da3fba 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -443,3 +443,4 @@
 443 auto quick ioctl fsr
 444 auto quick
 445 auto quick filestreams
+711 auto quick
