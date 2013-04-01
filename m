Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 08B3E29E09
	for <xfs@oss.sgi.com>; Mon,  1 Apr 2013 05:58:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id AA10CAC008
	for <xfs@oss.sgi.com>; Mon,  1 Apr 2013 03:58:01 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id HtgdlJwzxevsO3vI for
	<xfs@oss.sgi.com>; Mon, 01 Apr 2013 03:58:00 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r31Aw0lU027185
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Mon, 1 Apr 2013 06:58:00 -0400
From: Eryu Guan <eguan@redhat.com>
Subject: [PATCH 2/4] xfstests generic 309: test write to the last block of max
	file size on ext4
Date: Mon,  1 Apr 2013 18:57:42 +0800
Message-Id: <1364813864-10820-3-git-send-email-eguan@redhat.com>
In-Reply-To: <1364813864-10820-1-git-send-email-eguan@redhat.com>
References: <1364813864-10820-1-git-send-email-eguan@redhat.com>
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
Cc: Eryu Guan <eguan@redhat.com>

On unpatched ext4 if an extent exists which includes the block right
before the maximum file offset, and the block for the maximum file
offset is written, the kernel panics.

On patched ext4, the write would get EFBIG since we lower s_maxbytes
by one fs block.

Regression test for commit:
f17722f ext4: Fix max file size and logical block counting of extent format file

Though it's an ext4 specific issue, it's no harm to run on all file
systems, so put it in generic.

Signed-off-by: Eryu Guan <eguan@redhat.com>
---
 tests/generic/309     | 69 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/309.out |  2 ++
 tests/generic/group   |  1 +
 3 files changed, 72 insertions(+)
 create mode 100644 tests/generic/309
 create mode 100644 tests/generic/309.out

diff --git a/tests/generic/309 b/tests/generic/309
new file mode 100644
index 0000000..875c09f
--- /dev/null
+++ b/tests/generic/309
@@ -0,0 +1,69 @@
+#! /bin/bash
+# FS QA Test No. 309
+#
+# Regression test for commit:
+# f17722f ext4: Fix max file size and logical block counting of extent format file
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2013 Red Hat, Inc.  All Rights Reserved.
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
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	cd /
+	rm -f $testfile
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+testfile=$TEST_DIR/testfile.$seq
+
+# real QA test starts here
+_supported_fs generic
+_supported_os Linux
+
+rm -f $seq.full
+echo "Silence is golden"
+
+block_size=`stat -f -c %s $TEST_DIR`
+
+# On unpatched ext4, if an extent exists which includes the block right
+# before the maximum file offset, and the block for the maximum file offset
+# is written, the kernel panics
+# On patched ext4, the write would get EFBIG since we lower s_maxbytes by
+# one fs block
+
+# Create a sparse file with an extent lays at one block before old s_maxbytes
+offset=$(((2**32 - 2) * $block_size))
+$XFS_IO_PROG -f -c "pwrite $offset $block_size" -c fsync $testfile >$seq.full 2>&1
+
+# Write to the block after the extent just created
+offset=$(((2**32 - 1) * $block_size))
+$XFS_IO_PROG -f -c "pwrite $offset $block_size" -c fsync $testfile >>$seq.full 2>&1
+
+# Got here without hitting BUG_ON(), test passed
+status=0
+exit
diff --git a/tests/generic/309.out b/tests/generic/309.out
new file mode 100644
index 0000000..56330d6
--- /dev/null
+++ b/tests/generic/309.out
@@ -0,0 +1,2 @@
+QA output created by 309
+Silence is golden
diff --git a/tests/generic/group b/tests/generic/group
index 6c74b63..9ff2ab1 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -110,3 +110,4 @@
 300 auto aio enospc preallocrw stress
 306 auto quick rw
 308 auto quick
+309 auto quick
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
