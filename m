Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 61A857F50
	for <xfs@oss.sgi.com>; Mon, 21 Oct 2013 15:03:37 -0500 (CDT)
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4C7718F8040
	for <xfs@oss.sgi.com>; Mon, 21 Oct 2013 13:03:37 -0700 (PDT)
Received: from xfsqa-xe6.americas.sgi.com (xfsqa-xe6.americas.sgi.com
	[128.162.242.7])
	by estes.americas.sgi.com (Postfix) with ESMTP id 35DC8700295C
	for <xfs@oss.sgi.com>; Mon, 21 Oct 2013 15:03:37 -0500 (CDT)
Received: by xfsqa-xe6.americas.sgi.com (Postfix, from userid 48222)
	id 2D410620E7; Mon, 21 Oct 2013 15:03:37 -0500 (CDT)
Message-Id: <20131021193930.267197519@sgi.com>
Date: Mon, 21 Oct 2013 15:02:32 -0500
From: rjohnston@sgi.com
Subject: [PATCH V4 2/2] xfstests: xfsdump/restore test for partial_reg: Out of
	records. Extend attrs applied early
References: <20131021193830.885912820@sgi.com>
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

Multi-stream xfsdump/xfsrestore of more than partialmax wholly-sparse
files segfaults with the following warning:

  "partial_reg: Out of records. Extend attrs applied early."

Add a test that dumps and restores partialmax + 1 wholly-sparse files.

Signed-off-by: Rich Johnston <rjohnston@sgi.com>

---

diff --git a/tests/xfs/351 b/tests/xfs/351
new file mode 100755
index 0000000..c0d8afb
--- /dev/null
+++ b/tests/xfs/351
@@ -0,0 +1,68 @@
+#! /bin/bash
+# FS QA Test No. 351
+#
+# Dump and restore partialmax + 1 wholly-sparse files
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2013 SGI.  All Rights Reserved.
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
+. ./common/filter
+. ./common/dump
+
+# real QA test starts here
+
+# Modify as appropriate.
+_supported_fs xfs
+_supported_os Linux
+_require_scratch
+
+rm -f $seqres.full
+
+echo "Silence is golden."
+_wipe_fs
+mkdir $dump_dir >> $seqres.full 2>&1 || _fail "mkdir \"$dump_dir\" failed"
+for i in `seq 1 4`; do
+	$XFS_IO_PROG -f -c "truncate 1t" $dump_dir/sparsefile$i \
+		>> $seqres.full 2>&1 || _fail "failed to create sparsefile\"$i\""
+done
+# Dump and restore the files
+_prepare_restore_dir
+$XFSDUMP_PROG -L session -M label1 -M label2 -f $tmp.stream1 \
+	-f $tmp.stream2 $SCRATCH_MNT -s $dump_sdir \
+	>> $seqres.full 2>&1 || _fail "dump failed"
+$XFSRESTORE_PROG -F -f $tmp.stream1 -f $tmp.stream2 $restore_dir \
+	>> $seqres.full 2>&1 || _fail "restore failed"
+status=0
+exit 
diff --git a/tests/xfs/351.out b/tests/xfs/351.out
new file mode 100644
index 0000000..42cf52e
--- /dev/null
+++ b/tests/xfs/351.out
@@ -0,0 +1,2 @@
+QA output created by 351
+Silence is golden.
diff --git a/tests/xfs/group b/tests/xfs/group
index 17fff27..53ea498 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -179,3 +179,4 @@
 297 auto freeze
 298 auto attr symlink quick
 299 auto quota
+351 auto dump


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
