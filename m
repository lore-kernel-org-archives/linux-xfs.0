Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:34623 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751169AbdHSPqw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 19 Aug 2017 11:46:52 -0400
Date: Sat, 19 Aug 2017 08:46:45 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs: test xfs_db fuzz command verbs
Message-ID: <20170819154645.GD4794@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>

Ensure that the fuzz command does what it says.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/1386     |   74 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1386.out |   28 ++++++++++++++++++++
 tests/xfs/group    |    1 +
 3 files changed, 103 insertions(+)
 create mode 100755 tests/xfs/1386
 create mode 100644 tests/xfs/1386.out

diff --git a/tests/xfs/1386 b/tests/xfs/1386
new file mode 100755
index 0000000..1c8eb83
--- /dev/null
+++ b/tests/xfs/1386
@@ -0,0 +1,74 @@
+#! /bin/bash
+# FS QA Test No. 1386
+#
+# Ensure that xfs_db fuzz command works as advertised.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2017, Oracle and/or its affiliates.  All Rights Reserved.
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
+
+seq=`basename "$0"`
+seqres="$RESULT_DIR/$seq"
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1    # failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	cd /
+	rm -rf "$tmp".*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/fuzzy
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_scratch_nocheck
+_require_command "$XFS_DB_PROG" "xfs_db"
+_require_xfs_db_command "fuzz"
+
+rm -f "$seqres.full"
+
+echo "Format"
+_scratch_mkfs > "$seqres.full" 2>&1
+
+# Make sure that each fuzz verb works.  For the firstbit/middlebit/lastbit
+# tests, we depend on 'ones' having set the field to all ones.
+field="fdblocks"
+_scratch_xfs_db -x -c 'sb 0' -c "write -d ${field} 0"
+SCRATCH_XFS_LIST_FUZZ_VERBS= _scratch_xfs_list_fuzz_verbs | while read verb; do
+	test "${verb}" = "random" && continue
+	echo "Test verb ${verb}"
+	_scratch_xfs_db -x -c 'sb 0' -c "fuzz -d ${field} ${verb}"
+done
+
+echo "Test verb random"
+before="$(_scratch_xfs_get_metadata_field "${field}" 'sb 0')"
+_scratch_xfs_db -x -c 'sb 0' -c "fuzz -d ${field} random" >> $seqres.full
+after="$(_scratch_xfs_get_metadata_field "${field}" 'sb 0')"
+test "${before}" != "${after}" && echo "${field} changed"
+
+echo "Done"
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1386.out b/tests/xfs/1386.out
new file mode 100644
index 0000000..f30da83
--- /dev/null
+++ b/tests/xfs/1386.out
@@ -0,0 +1,28 @@
+QA output created by 1386
+Format
+Allowing write of corrupted data with good CRC
+fdblocks = 0
+Test verb zeroes
+Allowing fuzz of corrupted data with good CRC
+fdblocks = 0
+Test verb ones
+Allowing fuzz of corrupted data with good CRC
+fdblocks = 18446744073709551615
+Test verb firstbit
+Allowing fuzz of corrupted data with good CRC
+fdblocks = 9223372036854775807
+Test verb middlebit
+Allowing fuzz of corrupted data with good CRC
+fdblocks = 9223372034707292159
+Test verb lastbit
+Allowing fuzz of corrupted data with good CRC
+fdblocks = 9223372034707292158
+Test verb add
+Allowing fuzz of corrupted data with good CRC
+fdblocks = 9223372034707294175
+Test verb sub
+Allowing fuzz of corrupted data with good CRC
+fdblocks = 9223372034707292158
+Test verb random
+fdblocks changed
+Done
diff --git a/tests/xfs/group b/tests/xfs/group
index 1bb40f9..0468e4b 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -428,3 +428,4 @@
 1383 dangerous_fuzzers dangerous_scrub dangerous_online_repair
 1384 dangerous_fuzzers dangerous_scrub dangerous_repair
 1385 dangerous_fuzzers dangerous_scrub dangerous_online_repair
+1386 auto quick fuzzers
