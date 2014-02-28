Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4BDD97F4E
	for <xfs@oss.sgi.com>; Fri, 28 Feb 2014 10:11:16 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id CC0E8AC009
	for <xfs@oss.sgi.com>; Fri, 28 Feb 2014 08:11:15 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 5lNZVrBAM2hDMVPB for
	<xfs@oss.sgi.com>; Fri, 28 Feb 2014 08:11:14 -0800 (PST)
From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 3/8] generic/008: Add test for fallocate zero range at block
	boundary
Date: Fri, 28 Feb 2014 17:11:00 +0100
Message-Id: <1393603865-26198-3-git-send-email-lczerner@redhat.com>
In-Reply-To: <1393603865-26198-1-git-send-email-lczerner@redhat.com>
References: <1393603865-26198-1-git-send-email-lczerner@redhat.com>
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
To: linux-ext4@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Lukas Czerner <lczerner@redhat.com>, xfs@oss.sgi.com

Add test for fallocate zero range at block boundary. This is similar to
the test xfs/290 however this one is generic and we're testing different
block sizes as well - namely 1k, 2k, 4k and 64k. Note that we're not
creating file systems with given block size buy rather test all 4
options.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 common/rc             |   2 +-
 tests/generic/008     |  57 +++++++
 tests/generic/008.out | 433 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/group   |   1 +
 4 files changed, 492 insertions(+), 1 deletion(-)
 create mode 100755 tests/generic/008
 create mode 100644 tests/generic/008.out

diff --git a/common/rc b/common/rc
index 7f530d0..70b8ff5 100644
--- a/common/rc
+++ b/common/rc
@@ -1310,7 +1310,7 @@ _require_xfs_io_command()
 	"falloc" )
 		testio=`$XFS_IO_PROG -F -f -c "falloc 0 1m" $testfile 2>&1`
 		;;
-	"fpunch" | "fcollapse" | "zero" )
+	"fpunch" | "fcollapse" | "zero" | "fzero" )
 		testio=`$XFS_IO_PROG -F -f -c "pwrite 0 20k" -c "fsync" \
 			-c "$command 4k 8k" $testfile 2>&1`
 		;;
diff --git a/tests/generic/008 b/tests/generic/008
new file mode 100755
index 0000000..65e1661
--- /dev/null
+++ b/tests/generic/008
@@ -0,0 +1,57 @@
+#! /bin/bash
+# FS QA Test No. 008
+#
+# Makes calls to fallocate zero range and checks tossed ranges
+#
+# Primarily tests page boundries and boundries that are
+#  off-by-one to ensure we're only tossing what's expected
+#
+#-----------------------------------------------------------------------
+# Copyright 2014 (C) Red Hat, Inc., Lukas Czerner <lczerner@redhat.com>
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
+trap "exit \$status" 0 1 2 3 15
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/punch
+
+# real QA test starts here
+
+# Modify as appropriate.
+_supported_os Linux
+
+_require_xfs_io_command "fzero"
+
+testfile=$TEST_DIR/008.$$
+
+_test_block_boundaries 1024 fzero _filter_xfs_io_unique $testfile
+_test_block_boundaries 2048 fzero _filter_xfs_io_unique $testfile
+_test_block_boundaries 4096 fzero _filter_xfs_io_unique $testfile
+_test_block_boundaries 65536 fzero _filter_xfs_io_unique $testfile
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/008.out b/tests/generic/008.out
new file mode 100644
index 0000000..0c3fb53
--- /dev/null
+++ b/tests/generic/008.out
@@ -0,0 +1,433 @@
+QA output created by 008
+zero 0, 1
+wrote 1024/1024 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 1024/1024 bytes at offset 1024
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+00000000:  00 41 41 41 41 41 41 41 41 41 41 41 41 41 41 41  .AAAAAAAAAAAAAAA
+00000010:  41 41 41 41 41 41 41 41 41 41 41 41 41 41 41 41  AAAAAAAAAAAAAAAA
+*
+00000400:  42 42 42 42 42 42 42 42 42 42 42 42 42 42 42 42  BBBBBBBBBBBBBBBB
+*
+read 2048/2048 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+zero 0, 1023
+wrote 1024/1024 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 1024/1024 bytes at offset 1024
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+00000000:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
+*
+000003f0:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 41  ...............A
+00000400:  42 42 42 42 42 42 42 42 42 42 42 42 42 42 42 42  BBBBBBBBBBBBBBBB
+*
+read 2048/2048 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+zero 0, 1024
+wrote 1024/1024 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 1024/1024 bytes at offset 1024
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+00000000:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
+*
+00000400:  42 42 42 42 42 42 42 42 42 42 42 42 42 42 42 42  BBBBBBBBBBBBBBBB
+*
+read 2048/2048 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+zero 0, 1025
+wrote 1024/1024 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 1024/1024 bytes at offset 1024
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+00000000:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
+*
+00000400:  00 42 42 42 42 42 42 42 42 42 42 42 42 42 42 42  .BBBBBBBBBBBBBBB
+00000410:  42 42 42 42 42 42 42 42 42 42 42 42 42 42 42 42  BBBBBBBBBBBBBBBB
+*
+read 2048/2048 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+zero 1023, 1024
+wrote 1024/1024 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 1024/1024 bytes at offset 1024
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+00000000:  41 41 41 41 41 41 41 41 41 41 41 41 41 41 41 41  AAAAAAAAAAAAAAAA
+*
+000003f0:  41 41 41 41 41 41 41 41 41 41 41 41 41 41 41 00  AAAAAAAAAAAAAAA.
+00000400:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
+*
+000007f0:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 42  ...............B
+read 2048/2048 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+zero 1023, 1025
+wrote 1024/1024 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 1024/1024 bytes at offset 1024
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+00000000:  41 41 41 41 41 41 41 41 41 41 41 41 41 41 41 41  AAAAAAAAAAAAAAAA
+*
+000003f0:  41 41 41 41 41 41 41 41 41 41 41 41 41 41 41 00  AAAAAAAAAAAAAAA.
+00000400:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
+*
+read 2048/2048 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+zero 1023, 1026
+wrote 1024/1024 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 1024/1024 bytes at offset 1024
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+00000000:  41 41 41 41 41 41 41 41 41 41 41 41 41 41 41 41  AAAAAAAAAAAAAAAA
+*
+000003f0:  41 41 41 41 41 41 41 41 41 41 41 41 41 41 41 00  AAAAAAAAAAAAAAA.
+00000400:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
+*
+read 2048/2048 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+zero 1024, 1024
+wrote 1024/1024 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 1024/1024 bytes at offset 1024
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+00000000:  41 41 41 41 41 41 41 41 41 41 41 41 41 41 41 41  AAAAAAAAAAAAAAAA
+*
+00000400:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
+*
+read 2048/2048 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+zero 512 , 1024
+wrote 1024/1024 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 1024/1024 bytes at offset 1024
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+00000000:  41 41 41 41 41 41 41 41 41 41 41 41 41 41 41 41  AAAAAAAAAAAAAAAA
+*
+00000200:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
+*
+00000600:  42 42 42 42 42 42 42 42 42 42 42 42 42 42 42 42  BBBBBBBBBBBBBBBB
+*
+read 2048/2048 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+zero 0, 1
+wrote 2048/2048 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 2048/2048 bytes at offset 2048
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+00000000:  00 41 41 41 41 41 41 41 41 41 41 41 41 41 41 41  .AAAAAAAAAAAAAAA
+00000010:  41 41 41 41 41 41 41 41 41 41 41 41 41 41 41 41  AAAAAAAAAAAAAAAA
+*
+00000800:  42 42 42 42 42 42 42 42 42 42 42 42 42 42 42 42  BBBBBBBBBBBBBBBB
+*
+read 4096/4096 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+zero 0, 2047
+wrote 2048/2048 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 2048/2048 bytes at offset 2048
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+00000000:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
+*
+000007f0:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 41  ...............A
+00000800:  42 42 42 42 42 42 42 42 42 42 42 42 42 42 42 42  BBBBBBBBBBBBBBBB
+*
+read 4096/4096 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+zero 0, 2048
+wrote 2048/2048 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 2048/2048 bytes at offset 2048
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+00000000:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
+*
+00000800:  42 42 42 42 42 42 42 42 42 42 42 42 42 42 42 42  BBBBBBBBBBBBBBBB
+*
+read 4096/4096 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+zero 0, 2049
+wrote 2048/2048 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 2048/2048 bytes at offset 2048
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+00000000:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
+*
+00000800:  00 42 42 42 42 42 42 42 42 42 42 42 42 42 42 42  .BBBBBBBBBBBBBBB
+00000810:  42 42 42 42 42 42 42 42 42 42 42 42 42 42 42 42  BBBBBBBBBBBBBBBB
+*
+read 4096/4096 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+zero 2047, 2048
+wrote 2048/2048 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 2048/2048 bytes at offset 2048
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+00000000:  41 41 41 41 41 41 41 41 41 41 41 41 41 41 41 41  AAAAAAAAAAAAAAAA
+*
+000007f0:  41 41 41 41 41 41 41 41 41 41 41 41 41 41 41 00  AAAAAAAAAAAAAAA.
+00000800:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
+*
+00000ff0:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 42  ...............B
+read 4096/4096 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+zero 2047, 2049
+wrote 2048/2048 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 2048/2048 bytes at offset 2048
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+00000000:  41 41 41 41 41 41 41 41 41 41 41 41 41 41 41 41  AAAAAAAAAAAAAAAA
+*
+000007f0:  41 41 41 41 41 41 41 41 41 41 41 41 41 41 41 00  AAAAAAAAAAAAAAA.
+00000800:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
+*
+read 4096/4096 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+zero 2047, 2050
+wrote 2048/2048 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 2048/2048 bytes at offset 2048
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+00000000:  41 41 41 41 41 41 41 41 41 41 41 41 41 41 41 41  AAAAAAAAAAAAAAAA
+*
+000007f0:  41 41 41 41 41 41 41 41 41 41 41 41 41 41 41 00  AAAAAAAAAAAAAAA.
+00000800:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
+*
+read 4096/4096 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+zero 2048, 2048
+wrote 2048/2048 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 2048/2048 bytes at offset 2048
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+00000000:  41 41 41 41 41 41 41 41 41 41 41 41 41 41 41 41  AAAAAAAAAAAAAAAA
+*
+00000800:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
+*
+read 4096/4096 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+zero 1024 , 2048
+wrote 2048/2048 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 2048/2048 bytes at offset 2048
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+00000000:  41 41 41 41 41 41 41 41 41 41 41 41 41 41 41 41  AAAAAAAAAAAAAAAA
+*
+00000400:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
+*
+00000c00:  42 42 42 42 42 42 42 42 42 42 42 42 42 42 42 42  BBBBBBBBBBBBBBBB
+*
+read 4096/4096 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+zero 0, 1
+wrote 4096/4096 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 4096/4096 bytes at offset 4096
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+00000000:  00 41 41 41 41 41 41 41 41 41 41 41 41 41 41 41  .AAAAAAAAAAAAAAA
+00000010:  41 41 41 41 41 41 41 41 41 41 41 41 41 41 41 41  AAAAAAAAAAAAAAAA
+*
+00001000:  42 42 42 42 42 42 42 42 42 42 42 42 42 42 42 42  BBBBBBBBBBBBBBBB
+*
+read 8192/8192 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+zero 0, 4095
+wrote 4096/4096 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 4096/4096 bytes at offset 4096
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+00000000:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
+*
+00000ff0:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 41  ...............A
+00001000:  42 42 42 42 42 42 42 42 42 42 42 42 42 42 42 42  BBBBBBBBBBBBBBBB
+*
+read 8192/8192 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+zero 0, 4096
+wrote 4096/4096 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 4096/4096 bytes at offset 4096
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+00000000:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
+*
+00001000:  42 42 42 42 42 42 42 42 42 42 42 42 42 42 42 42  BBBBBBBBBBBBBBBB
+*
+read 8192/8192 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+zero 0, 4097
+wrote 4096/4096 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 4096/4096 bytes at offset 4096
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+00000000:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
+*
+00001000:  00 42 42 42 42 42 42 42 42 42 42 42 42 42 42 42  .BBBBBBBBBBBBBBB
+00001010:  42 42 42 42 42 42 42 42 42 42 42 42 42 42 42 42  BBBBBBBBBBBBBBBB
+*
+read 8192/8192 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+zero 4095, 4096
+wrote 4096/4096 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 4096/4096 bytes at offset 4096
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+00000000:  41 41 41 41 41 41 41 41 41 41 41 41 41 41 41 41  AAAAAAAAAAAAAAAA
+*
+00000ff0:  41 41 41 41 41 41 41 41 41 41 41 41 41 41 41 00  AAAAAAAAAAAAAAA.
+00001000:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
+*
+00001ff0:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 42  ...............B
+read 8192/8192 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+zero 4095, 4097
+wrote 4096/4096 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 4096/4096 bytes at offset 4096
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+00000000:  41 41 41 41 41 41 41 41 41 41 41 41 41 41 41 41  AAAAAAAAAAAAAAAA
+*
+00000ff0:  41 41 41 41 41 41 41 41 41 41 41 41 41 41 41 00  AAAAAAAAAAAAAAA.
+00001000:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
+*
+read 8192/8192 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+zero 4095, 4098
+wrote 4096/4096 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 4096/4096 bytes at offset 4096
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+00000000:  41 41 41 41 41 41 41 41 41 41 41 41 41 41 41 41  AAAAAAAAAAAAAAAA
+*
+00000ff0:  41 41 41 41 41 41 41 41 41 41 41 41 41 41 41 00  AAAAAAAAAAAAAAA.
+00001000:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
+*
+read 8192/8192 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+zero 4096, 4096
+wrote 4096/4096 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 4096/4096 bytes at offset 4096
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+00000000:  41 41 41 41 41 41 41 41 41 41 41 41 41 41 41 41  AAAAAAAAAAAAAAAA
+*
+00001000:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
+*
+read 8192/8192 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+zero 2048 , 4096
+wrote 4096/4096 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 4096/4096 bytes at offset 4096
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+00000000:  41 41 41 41 41 41 41 41 41 41 41 41 41 41 41 41  AAAAAAAAAAAAAAAA
+*
+00000800:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
+*
+00001800:  42 42 42 42 42 42 42 42 42 42 42 42 42 42 42 42  BBBBBBBBBBBBBBBB
+*
+read 8192/8192 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+zero 0, 1
+wrote 65536/65536 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 65536/65536 bytes at offset 65536
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+00000000:  00 41 41 41 41 41 41 41 41 41 41 41 41 41 41 41  .AAAAAAAAAAAAAAA
+00000010:  41 41 41 41 41 41 41 41 41 41 41 41 41 41 41 41  AAAAAAAAAAAAAAAA
+*
+00010000:  42 42 42 42 42 42 42 42 42 42 42 42 42 42 42 42  BBBBBBBBBBBBBBBB
+*
+read 131072/131072 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+zero 0, 65535
+wrote 65536/65536 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 65536/65536 bytes at offset 65536
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+00000000:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
+*
+0000fff0:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 41  ...............A
+00010000:  42 42 42 42 42 42 42 42 42 42 42 42 42 42 42 42  BBBBBBBBBBBBBBBB
+*
+read 131072/131072 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+zero 0, 65536
+wrote 65536/65536 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 65536/65536 bytes at offset 65536
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+00000000:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
+*
+00010000:  42 42 42 42 42 42 42 42 42 42 42 42 42 42 42 42  BBBBBBBBBBBBBBBB
+*
+read 131072/131072 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+zero 0, 65537
+wrote 65536/65536 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 65536/65536 bytes at offset 65536
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+00000000:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
+*
+00010000:  00 42 42 42 42 42 42 42 42 42 42 42 42 42 42 42  .BBBBBBBBBBBBBBB
+00010010:  42 42 42 42 42 42 42 42 42 42 42 42 42 42 42 42  BBBBBBBBBBBBBBBB
+*
+read 131072/131072 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+zero 65535, 65536
+wrote 65536/65536 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 65536/65536 bytes at offset 65536
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+00000000:  41 41 41 41 41 41 41 41 41 41 41 41 41 41 41 41  AAAAAAAAAAAAAAAA
+*
+0000fff0:  41 41 41 41 41 41 41 41 41 41 41 41 41 41 41 00  AAAAAAAAAAAAAAA.
+00010000:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
+*
+0001fff0:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 42  ...............B
+read 131072/131072 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+zero 65535, 65537
+wrote 65536/65536 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 65536/65536 bytes at offset 65536
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+00000000:  41 41 41 41 41 41 41 41 41 41 41 41 41 41 41 41  AAAAAAAAAAAAAAAA
+*
+0000fff0:  41 41 41 41 41 41 41 41 41 41 41 41 41 41 41 00  AAAAAAAAAAAAAAA.
+00010000:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
+*
+read 131072/131072 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+zero 65535, 65538
+wrote 65536/65536 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 65536/65536 bytes at offset 65536
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+00000000:  41 41 41 41 41 41 41 41 41 41 41 41 41 41 41 41  AAAAAAAAAAAAAAAA
+*
+0000fff0:  41 41 41 41 41 41 41 41 41 41 41 41 41 41 41 00  AAAAAAAAAAAAAAA.
+00010000:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
+*
+read 131072/131072 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+zero 65536, 65536
+wrote 65536/65536 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 65536/65536 bytes at offset 65536
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+00000000:  41 41 41 41 41 41 41 41 41 41 41 41 41 41 41 41  AAAAAAAAAAAAAAAA
+*
+00010000:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
+*
+read 131072/131072 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+zero 32768 , 65536
+wrote 65536/65536 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 65536/65536 bytes at offset 65536
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+00000000:  41 41 41 41 41 41 41 41 41 41 41 41 41 41 41 41  AAAAAAAAAAAAAAAA
+*
+00008000:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
+*
+00018000:  42 42 42 42 42 42 42 42 42 42 42 42 42 42 42 42  BBBBBBBBBBBBBBBB
+*
+read 131072/131072 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
diff --git a/tests/generic/group b/tests/generic/group
index 34bd118..a99b6a1 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -9,6 +9,7 @@
 005 dir udf auto quick
 006 dir udf auto quick
 007 dir udf auto quick
+008 auto quick prealloc
 010 other udf auto
 011 dir udf auto quick
 013 other ioctl udf auto quick
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
