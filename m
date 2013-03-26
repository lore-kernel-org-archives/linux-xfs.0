Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3B8797F67
	for <xfs@oss.sgi.com>; Tue, 26 Mar 2013 07:53:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 19C80304053
	for <xfs@oss.sgi.com>; Tue, 26 Mar 2013 05:53:43 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id CNDqQsbDQFZz8wtY for
	<xfs@oss.sgi.com>; Tue, 26 Mar 2013 05:53:40 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r2QCrdKV032526
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 26 Mar 2013 08:53:39 -0400
From: Eryu Guan <eguan@redhat.com>
Subject: [PATCH v2 2/2] xfstests 309: test write to the last block of max file
	size on ext4
Date: Tue, 26 Mar 2013 20:52:22 +0800
Message-Id: <1364302342-3841-2-git-send-email-eguan@redhat.com>
In-Reply-To: <1364302342-3841-1-git-send-email-eguan@redhat.com>
References: <1364302342-3841-1-git-send-email-eguan@redhat.com>
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

Regression test for commit:
f17722f ext4: Fix max file size and logical block counting of extent format file

Signed-off-by: Eryu Guan <eguan@redhat.com>
---
v2: revised after Dave Chinner's review
  1. add more comments to explain what the test does, I hope it does the job...
  2. use xfs_io instead of dd
  3. use stat -f -c %s $TEST_DIR to get block size
  4. rebase on top of master

 309     | 70 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 309.out |  2 ++
 group   |  1 +
 3 files changed, 73 insertions(+)
 create mode 100644 309
 create mode 100644 309.out

diff --git a/309 b/309
new file mode 100644
index 0000000..c2791c0
--- /dev/null
+++ b/309
@@ -0,0 +1,70 @@
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
+# creator
+owner=eguan@redhat.com
+
+seq=`basename $0`
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
+. ./common.rc
+. ./common.filter
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
diff --git a/309.out b/309.out
new file mode 100644
index 0000000..56330d6
--- /dev/null
+++ b/309.out
@@ -0,0 +1,2 @@
+QA output created by 309
+Silence is golden
diff --git a/group b/group
index 88f6800..d950628 100644
--- a/group
+++ b/group
@@ -432,3 +432,4 @@ stress
 306 auto quick rw
 307 auto quick
 308 auto quick
+309 auto quick
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
