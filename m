Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 07AA87F59
	for <xfs@oss.sgi.com>; Fri, 22 Feb 2013 01:17:46 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id EA238304066
	for <xfs@oss.sgi.com>; Thu, 21 Feb 2013 23:17:42 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id KbskBhXGJL1IhA7f for
	<xfs@oss.sgi.com>; Thu, 21 Feb 2013 23:17:15 -0800 (PST)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r1M7HFw4027613
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 22 Feb 2013 02:17:15 -0500
From: Eryu Guan <eguan@redhat.com>
Subject: [PATCH 2/2] xfstests 299: test write to the last block of a sparse
	file
Date: Fri, 22 Feb 2013 14:59:29 +0800
Message-Id: <1361516369-7480-2-git-send-email-eguan@redhat.com>
In-Reply-To: <1361516369-7480-1-git-send-email-eguan@redhat.com>
References: <1361516369-7480-1-git-send-email-eguan@redhat.com>
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

Write to the last block of a sparse file in extent format on ext4 would
hit BUG_ON() on unpatched kernel.

Regression test for commit:
f17722f ext4: Fix max file size and logical block counting of extent format file

Signed-off-by: Eryu Guan <eguan@redhat.com>
---

Note that the second dd could triger a BUG_ON() on ext4/3.8 kernel in
ext4_es_remove_extent().

I sent a patch for this issue, please see
http://www.spinics.net/lists/linux-ext4/msg36784.html

 299     | 62 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 299.out |  1 +
 group   |  1 +
 3 files changed, 64 insertions(+)
 create mode 100644 299
 create mode 100644 299.out

diff --git a/299 b/299
new file mode 100644
index 0000000..9b52243
--- /dev/null
+++ b/299
@@ -0,0 +1,62 @@
+#! /bin/bash
+# FS QA Test No. 299
+#
+# Write to the last block of a sparse file in extent format on ext4 would
+# hit BUG_ON() on unpatched kernel.
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
+block_size=`stat -f $TEST_DEV | grep "Block size" | cut -d " " -f3`
+
+# Create sparse file
+dd if=/dev/zero of=$testfile bs=$block_size count=1 seek=$((2**32 - 2)) >/dev/null 2>&1
+sync
+# Write to the last block
+dd if=/dev/zero of=$testfile bs=$block_size count=1 seek=$((2**32 - 1)) >/dev/null 2>&1
+
+# Got here without hitting BUG_ON(), test passed
+status=0
+exit
diff --git a/299.out b/299.out
new file mode 100644
index 0000000..0b41c6f
--- /dev/null
+++ b/299.out
@@ -0,0 +1 @@
+QA output created by 299
diff --git a/group b/group
index 3039af4..a993729 100644
--- a/group
+++ b/group
@@ -417,3 +417,4 @@ deprecated
 296 dump auto quick
 297 auto freeze
 298 auto quick metadata
+299 auto quick
-- 
1.8.0.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
