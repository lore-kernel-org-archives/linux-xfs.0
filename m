Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6B4117F4E
	for <xfs@oss.sgi.com>; Tue,  4 Mar 2014 11:21:30 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3FCEF304039
	for <xfs@oss.sgi.com>; Tue,  4 Mar 2014 09:21:27 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id ps1YhFSaj1CZq4F3 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 04 Mar 2014 09:21:25 -0800 (PST)
Date: Tue, 4 Mar 2014 09:21:25 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 1/2] generic: add a basic O_TMPFILE test
Message-ID: <20140304172125.GB24528@infradead.org>
References: <20140304172103.GA24528@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140304172103.GA24528@infradead.org>
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
To: xfs@oss.sgi.com
Cc: Zhi Yong Wu <zwu.kernel@gmail.com>

diff --git a/tests/generic/004 b/tests/generic/004
new file mode 100755
index 0000000..2848d36
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
+#_require_xfs_io_falloc_flink
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
index 34bd118..cf2e5ee 100644
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

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
