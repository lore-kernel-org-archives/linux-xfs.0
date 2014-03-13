Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1F0C67F88
	for <xfs@oss.sgi.com>; Thu, 13 Mar 2014 05:14:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B6E3BAC002
	for <xfs@oss.sgi.com>; Thu, 13 Mar 2014 03:14:35 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id JDAICjMezX281TzA (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 13 Mar 2014 03:14:33 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.80.1 #2 (Red
	Hat Linux)) id 1WO2en-00083g-IE
	for xfs@oss.sgi.com; Thu, 13 Mar 2014 10:14:33 +0000
Message-Id: <20140313101433.445012299@bombadil.infradead.org>
Date: Thu, 13 Mar 2014 03:13:04 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 2/3] generic: add a basic O_TMPFILE test
References: <20140313101302.996355155@bombadil.infradead.org>
Content-Disposition: inline;
	filename=0002-generic-add-a-basic-O_TMPFILE-test.patch
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
To: xfs@oss.sgi.com

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 tests/generic/004     |   70 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/004.out |    6 +++++
 tests/generic/group   |    1 +
 3 files changed, 77 insertions(+)
 create mode 100755 tests/generic/004
 create mode 100644 tests/generic/004.out

diff --git a/tests/generic/004 b/tests/generic/004
new file mode 100755
index 0000000..c653530
--- /dev/null
+++ b/tests/generic/004
@@ -0,0 +1,70 @@
+#! /bin/bash
+# FS QA Test No. 004
+#
+# Test O_TMPFILE opens
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2014 Christoph Hellwig.  All Rights Reserved.
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
+    rm -f ${testfile}
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+_supported_fs generic
+_supported_os Linux
+
+_require_xfs_io_command "flink"
+
+testfile="${TEST_DIR}/tst-tmpfile-flink"
+
+# test creating a r/w tmpfile, do I/O and link it into the namespace
+$XFS_IO_PROG -T \
+	-c "pwrite 0 4096" \
+	-c "pread 0 4096" \
+	-c "flink ${testfile}" \
+	${TEST_DIR} | _filter_xfs_io
+
+if [ ! -f "${testfile}" ]; then
+    echo "failed to link testfile into place"
+    exit 1
+fi
+
+rm -f ${tmpfile}
+
+# test creating a r/o tmpfile.  Should fail
+$XFS_IO_PROG -Tr ${TEST_DIR} -c "close" | _filter_test_dir
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/004.out b/tests/generic/004.out
new file mode 100644
index 0000000..b85c11c
--- /dev/null
+++ b/tests/generic/004.out
@@ -0,0 +1,6 @@
+QA output created by 004
+wrote 4096/4096 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+read 4096/4096 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+/mnt/test: Invalid argument
diff --git a/tests/generic/group b/tests/generic/group
index a99b6a1..ad86d11 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -6,6 +6,7 @@
 001 rw dir udf auto quick
 002 metadata udf auto quick
 003 atime auto quick
+004 auto quick
 005 dir udf auto quick
 006 dir udf auto quick
 007 dir udf auto quick
-- 
1.7.10.4


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
