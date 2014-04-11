Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8973D7F3F
	for <xfs@oss.sgi.com>; Fri, 11 Apr 2014 10:52:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4A7B3304067
	for <xfs@oss.sgi.com>; Fri, 11 Apr 2014 08:52:08 -0700 (PDT)
Received: from mail-ee0-f51.google.com (mail-ee0-f51.google.com
	[74.125.83.51]) by cuda.sgi.com with ESMTP id iUNyKgDRauB5FdNu
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 11 Apr 2014 08:52:06 -0700 (PDT)
Received: by mail-ee0-f51.google.com with SMTP id c13so4266493eek.24
	for <xfs@oss.sgi.com>; Fri, 11 Apr 2014 08:52:05 -0700 (PDT)
From: Miklos Szeredi <miklos@szeredi.hu>
Subject: [PATCH 2/4] renameat2 syscall: check plain rename
Date: Fri, 11 Apr 2014 17:51:55 +0200
Message-Id: <1397231517-4641-2-git-send-email-miklos@szeredi.hu>
In-Reply-To: <1397231517-4641-1-git-send-email-miklos@szeredi.hu>
References: <1397231517-4641-1-git-send-email-miklos@szeredi.hu>
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
Cc: Miklos Szeredi <mszeredi@suse.cz>

From: Miklos Szeredi <mszeredi@suse.cz>

Check with zero flags.  This is what rename(2) and renameat(2) now call, so
this actually tests the behavior of these syscalls as well.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 tests/generic/323     | 57 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/323.out | 51 +++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/group   |  1 +
 3 files changed, 109 insertions(+)
 create mode 100755 tests/generic/323
 create mode 100644 tests/generic/323.out

diff --git a/tests/generic/323 b/tests/generic/323
new file mode 100755
index 0000000..84772bb
--- /dev/null
+++ b/tests/generic/323
@@ -0,0 +1,57 @@
+#! /bin/bash
+# FS QA Test No. generic/323
+#
+# Check renameat2 syscall without flags
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2014 Miklos Szeredi.  All Rights Reserved.
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
+    rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/renameat2
+
+_supported_fs generic
+_supported_os Linux
+
+_requires_renameat2
+
+# real QA test starts here
+
+rename_dir=$TEST_DIR/$$
+mkdir -p $rename_dir
+_rename_tests $rename_dir
+rmdir $rename_dir
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/323.out b/tests/generic/323.out
new file mode 100644
index 0000000..bb85b9a
--- /dev/null
+++ b/tests/generic/323.out
@@ -0,0 +1,51 @@
+QA output created by 323
+samedir  none/none -> No such file or directory
+samedir  none/regu -> No such file or directory
+samedir  none/symb -> No such file or directory
+samedir  none/dire -> No such file or directory
+samedir  none/tree -> No such file or directory
+samedir  regu/none -> none/regu.
+samedir  regu/regu -> none/regu.
+samedir  regu/symb -> none/regu.
+samedir  regu/dire -> Is a directory
+samedir  regu/tree -> Is a directory
+samedir  symb/none -> none/symb.
+samedir  symb/regu -> none/symb.
+samedir  symb/symb -> none/symb.
+samedir  symb/dire -> Is a directory
+samedir  symb/tree -> Is a directory
+samedir  dire/none -> none/dire.
+samedir  dire/regu -> Not a directory
+samedir  dire/symb -> Not a directory
+samedir  dire/dire -> none/dire.
+samedir  dire/tree -> Directory not empty
+samedir  tree/none -> none/tree.
+samedir  tree/regu -> Not a directory
+samedir  tree/symb -> Not a directory
+samedir  tree/dire -> none/tree.
+samedir  tree/tree -> Directory not empty
+crossdir none/none -> No such file or directory
+crossdir none/regu -> No such file or directory
+crossdir none/symb -> No such file or directory
+crossdir none/dire -> No such file or directory
+crossdir none/tree -> No such file or directory
+crossdir regu/none -> none/regu.
+crossdir regu/regu -> none/regu.
+crossdir regu/symb -> none/regu.
+crossdir regu/dire -> Is a directory
+crossdir regu/tree -> Is a directory
+crossdir symb/none -> none/symb.
+crossdir symb/regu -> none/symb.
+crossdir symb/symb -> none/symb.
+crossdir symb/dire -> Is a directory
+crossdir symb/tree -> Is a directory
+crossdir dire/none -> none/dire.
+crossdir dire/regu -> Not a directory
+crossdir dire/symb -> Not a directory
+crossdir dire/dire -> none/dire.
+crossdir dire/tree -> Directory not empty
+crossdir tree/none -> none/tree.
+crossdir tree/regu -> Not a directory
+crossdir tree/symb -> Not a directory
+crossdir tree/dire -> none/tree.
+crossdir tree/tree -> Directory not empty
diff --git a/tests/generic/group b/tests/generic/group
index 1c1693d..26e584b 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -136,3 +136,4 @@
 320 auto rw
 321 auto quick metadata log
 322 auto quick metadata log
+323 auto quick
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
