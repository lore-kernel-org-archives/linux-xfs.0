Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1B3807F50
	for <xfs@oss.sgi.com>; Fri, 11 Apr 2014 10:52:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C15BD304053
	for <xfs@oss.sgi.com>; Fri, 11 Apr 2014 08:52:09 -0700 (PDT)
Received: from mail-ee0-f49.google.com (mail-ee0-f49.google.com
	[74.125.83.49]) by cuda.sgi.com with ESMTP id 3k5EuDKkO9F1vtF9
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 11 Apr 2014 08:52:07 -0700 (PDT)
Received: by mail-ee0-f49.google.com with SMTP id c41so4309707eek.36
	for <xfs@oss.sgi.com>; Fri, 11 Apr 2014 08:52:06 -0700 (PDT)
From: Miklos Szeredi <miklos@szeredi.hu>
Subject: [PATCH 3/4] renameat2 syscall: check noreplace rename
Date: Fri, 11 Apr 2014 17:51:56 +0200
Message-Id: <1397231517-4641-3-git-send-email-miklos@szeredi.hu>
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

Check with RENAME_NOREPLACE flag.  This flag indicates that the rename must
fail if the target of the rename exists.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 tests/generic/324     | 64 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/324.out | 51 ++++++++++++++++++++++++++++++++++++++++
 tests/generic/group   |  1 +
 3 files changed, 116 insertions(+)
 create mode 100755 tests/generic/324
 create mode 100644 tests/generic/324.out

diff --git a/tests/generic/324 b/tests/generic/324
new file mode 100755
index 0000000..7b45ca8
--- /dev/null
+++ b/tests/generic/324
@@ -0,0 +1,64 @@
+#! /bin/bash
+# FS QA Test No. generic/324
+#
+# Check renameat2 syscall with RENAME_NOREPLACE flag
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
+rename_dir=$TEST_DIR/$$
+mkdir $rename_dir
+touch $rename_dir/foo
+if ! src/renameat2 -t -n $rename_dir/foo $rename_dir/bar; then
+    rm -f $rename_dir/foo $rename_dir/bar; rmdir $rename_dir
+    _notrun "fs doesn't support RENAME_NOREPLACE"
+fi
+rm -f $rename_dir/foo $rename_dir/bar
+
+# real QA test starts here
+
+_rename_tests $rename_dir -n
+rmdir $rename_dir
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/324.out b/tests/generic/324.out
new file mode 100644
index 0000000..fff5547
--- /dev/null
+++ b/tests/generic/324.out
@@ -0,0 +1,51 @@
+QA output created by 324
+samedir  none/none -> No such file or directory
+samedir  none/regu -> No such file or directory
+samedir  none/symb -> No such file or directory
+samedir  none/dire -> No such file or directory
+samedir  none/tree -> No such file or directory
+samedir  regu/none -> none/regu.
+samedir  regu/regu -> File exists
+samedir  regu/symb -> File exists
+samedir  regu/dire -> File exists
+samedir  regu/tree -> File exists
+samedir  symb/none -> none/symb.
+samedir  symb/regu -> File exists
+samedir  symb/symb -> File exists
+samedir  symb/dire -> File exists
+samedir  symb/tree -> File exists
+samedir  dire/none -> none/dire.
+samedir  dire/regu -> File exists
+samedir  dire/symb -> File exists
+samedir  dire/dire -> File exists
+samedir  dire/tree -> File exists
+samedir  tree/none -> none/tree.
+samedir  tree/regu -> File exists
+samedir  tree/symb -> File exists
+samedir  tree/dire -> File exists
+samedir  tree/tree -> File exists
+crossdir none/none -> No such file or directory
+crossdir none/regu -> No such file or directory
+crossdir none/symb -> No such file or directory
+crossdir none/dire -> No such file or directory
+crossdir none/tree -> No such file or directory
+crossdir regu/none -> none/regu.
+crossdir regu/regu -> File exists
+crossdir regu/symb -> File exists
+crossdir regu/dire -> File exists
+crossdir regu/tree -> File exists
+crossdir symb/none -> none/symb.
+crossdir symb/regu -> File exists
+crossdir symb/symb -> File exists
+crossdir symb/dire -> File exists
+crossdir symb/tree -> File exists
+crossdir dire/none -> none/dire.
+crossdir dire/regu -> File exists
+crossdir dire/symb -> File exists
+crossdir dire/dire -> File exists
+crossdir dire/tree -> File exists
+crossdir tree/none -> none/tree.
+crossdir tree/regu -> File exists
+crossdir tree/symb -> File exists
+crossdir tree/dire -> File exists
+crossdir tree/tree -> File exists
diff --git a/tests/generic/group b/tests/generic/group
index 26e584b..37697d8 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -137,3 +137,4 @@
 321 auto quick metadata log
 322 auto quick metadata log
 323 auto quick
+324 auto quick
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
