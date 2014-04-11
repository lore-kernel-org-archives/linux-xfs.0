Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0C9E17F4E
	for <xfs@oss.sgi.com>; Fri, 11 Apr 2014 10:52:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id DEE78304059
	for <xfs@oss.sgi.com>; Fri, 11 Apr 2014 08:52:09 -0700 (PDT)
Received: from mail-ee0-f51.google.com (mail-ee0-f51.google.com
	[74.125.83.51]) by cuda.sgi.com with ESMTP id beVEO0rwpvJc0ibI
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 11 Apr 2014 08:52:08 -0700 (PDT)
Received: by mail-ee0-f51.google.com with SMTP id c13so4266550eek.24
	for <xfs@oss.sgi.com>; Fri, 11 Apr 2014 08:52:07 -0700 (PDT)
From: Miklos Szeredi <miklos@szeredi.hu>
Subject: [PATCH 4/4] renameat2 syscall: check cross rename
Date: Fri, 11 Apr 2014 17:51:57 +0200
Message-Id: <1397231517-4641-4-git-send-email-miklos@szeredi.hu>
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

Check with RENAME_EXCHANGE flag.  This flag indicates that the source and
destination files are to be exchanged.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 tests/generic/325     | 64 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/325.out | 51 ++++++++++++++++++++++++++++++++++++++++
 tests/generic/group   |  1 +
 3 files changed, 116 insertions(+)
 create mode 100755 tests/generic/325
 create mode 100644 tests/generic/325.out

diff --git a/tests/generic/325 b/tests/generic/325
new file mode 100755
index 0000000..6776e10
--- /dev/null
+++ b/tests/generic/325
@@ -0,0 +1,64 @@
+#! /bin/bash
+# FS QA Test No. generic/325
+#
+# Check renameat2 syscall with RENAME_EXCHANGE flag
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
+touch $rename_dir/foo $rename_dir/bar
+if ! src/renameat2 -t -x $rename_dir/foo $rename_dir/bar; then
+    rm -f $rename_dir/foo $rename_dir/bar; rmdir $rename_dir
+    _notrun "fs doesn't support RENAME_EXCHANGE"
+fi
+rm -f $rename_dir/foo $rename_dir/bar
+
+# real QA test starts here
+
+_rename_tests $rename_dir -x
+rmdir $rename_dir
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/325.out b/tests/generic/325.out
new file mode 100644
index 0000000..f73d7c1
--- /dev/null
+++ b/tests/generic/325.out
@@ -0,0 +1,51 @@
+QA output created by 325
+samedir  none/none -> No such file or directory
+samedir  none/regu -> No such file or directory
+samedir  none/symb -> No such file or directory
+samedir  none/dire -> No such file or directory
+samedir  none/tree -> No such file or directory
+samedir  regu/none -> No such file or directory
+samedir  regu/regu -> regu/regu.
+samedir  regu/symb -> symb/regu.
+samedir  regu/dire -> dire/regu.
+samedir  regu/tree -> tree/regu.
+samedir  symb/none -> No such file or directory
+samedir  symb/regu -> regu/symb.
+samedir  symb/symb -> symb/symb.
+samedir  symb/dire -> dire/symb.
+samedir  symb/tree -> tree/symb.
+samedir  dire/none -> No such file or directory
+samedir  dire/regu -> regu/dire.
+samedir  dire/symb -> symb/dire.
+samedir  dire/dire -> dire/dire.
+samedir  dire/tree -> tree/dire.
+samedir  tree/none -> No such file or directory
+samedir  tree/regu -> regu/tree.
+samedir  tree/symb -> symb/tree.
+samedir  tree/dire -> dire/tree.
+samedir  tree/tree -> tree/tree.
+crossdir none/none -> No such file or directory
+crossdir none/regu -> No such file or directory
+crossdir none/symb -> No such file or directory
+crossdir none/dire -> No such file or directory
+crossdir none/tree -> No such file or directory
+crossdir regu/none -> No such file or directory
+crossdir regu/regu -> regu/regu.
+crossdir regu/symb -> symb/regu.
+crossdir regu/dire -> dire/regu.
+crossdir regu/tree -> tree/regu.
+crossdir symb/none -> No such file or directory
+crossdir symb/regu -> regu/symb.
+crossdir symb/symb -> symb/symb.
+crossdir symb/dire -> dire/symb.
+crossdir symb/tree -> tree/symb.
+crossdir dire/none -> No such file or directory
+crossdir dire/regu -> regu/dire.
+crossdir dire/symb -> symb/dire.
+crossdir dire/dire -> dire/dire.
+crossdir dire/tree -> tree/dire.
+crossdir tree/none -> No such file or directory
+crossdir tree/regu -> regu/tree.
+crossdir tree/symb -> symb/tree.
+crossdir tree/dire -> dire/tree.
+crossdir tree/tree -> tree/tree.
diff --git a/tests/generic/group b/tests/generic/group
index 37697d8..8ea9b10 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -138,3 +138,4 @@
 322 auto quick metadata log
 323 auto quick
 324 auto quick
+325 auto quick
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
