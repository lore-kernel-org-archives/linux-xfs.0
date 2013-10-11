Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1114E7F56
	for <xfs@oss.sgi.com>; Thu, 10 Oct 2013 23:28:52 -0500 (CDT)
Received: from gulag1.americas.sgi.com (gulag1.americas.sgi.com
	[128.162.236.41])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E09EA8F8050
	for <xfs@oss.sgi.com>; Thu, 10 Oct 2013 21:28:51 -0700 (PDT)
Message-Id: <20131011042008.042241192@sgi.com>
Date: Thu, 10 Oct 2013 23:19:13 -0500
From: rjohnston@sgi.com
Subject: [PATCH 2/2] xfstests: xfsdump/restore test for partial_reg: Out of
	records. Extend attrs applied early
References: <20131011041911.238407600@sgi.com>
Content-Disposition: inline;
	filename=xfstests-multi-stream-xfsdump-xfsrestore-of-wholly-sparse-files.patch
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

diff --git a/tests/xfs/351 b/tests/xfs/351
new file mode 100755
index 0000000..43b14c2
--- /dev/null
+++ b/tests/xfs/351
@@ -0,0 +1,71 @@
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
+#dump_dir=/mnt/test/$dump_sdir
+
+rm -f $seqres.full
+rm -rf $restore_dir/*
+rm -f $tmp.stream? 
+
+echo "Silence is golden."
+_wipe_fs
+mkdir $dump_dir 2>&1 >> $seqres.full || _fail "mkdir \"$dump_dir\" failed"
+for i in `seq 1 4`; do
+	$XFS_IO_PROG -f -c "truncate 1t" $dump_dir/sparsefile$i \
+		2>&1 >> $seqres.full || _fail "failed to create sparsefile\"$i\""
+done
+# Dump and restore the files
+_prepare_restore_dir
+$XFSDUMP_PROG -L session -M label1 -M label2 -f $tmp.stream1 \
+	-f $tmp.stream2 $SCRATCH_MNT -s $dump_sdir \
+	2>&1 >> $seqres.full || _fail "dump failed"
+$XFSRESTORE_PROG -F -f $tmp.stream1 -f $tmp.stream2 $restore_dir \
+	2>&1 >> $seqres.full || _fail "restore failed"
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
index 352a4c5..3e73f1d 100644
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
