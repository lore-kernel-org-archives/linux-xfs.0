Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4EF0C7F6F
	for <xfs@oss.sgi.com>; Tue,  8 Oct 2013 09:48:03 -0500 (CDT)
Received: from gulag1.americas.sgi.com (gulag1.americas.sgi.com
	[128.162.236.41])
	by relay3.corp.sgi.com (Postfix) with ESMTP id BBFA7AC001
	for <xfs@oss.sgi.com>; Tue,  8 Oct 2013 07:48:02 -0700 (PDT)
Message-Id: <20131008144432.934569855@sgi.com>
Date: Tue, 08 Oct 2013 09:43:57 -0500
From: rjohnston@sgi.com
Subject: [PATCH V2] xfstests XFS: verify extended attributes after
	multi-stream xfsdump/xfsrestore are not lost
References: <524AF8AE.5030300@sgi.com>
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

Verify extended attributes are not lost after multi-stream
xfsdump/xfsrestore of wholly-sparse files.  xfsrestore did not
recognize that if the LAST header was reached with no restoredsz set,
(i.e the LAST header is the only header), the following warning is
displayed:

  "partial_reg: Out of records. Extend attrs applied early."

and the extended attributes on the current and following restored
files are lost.

Signed-off-by: Rich Johnston <rjohnston@sgi.com>

---
V2:
Updated test description and comments
Changed test status to default to failure
Added missing _requires_XXXX statements
Removed the attr root (-R) namespace argument

diff --git a/tests/xfs/350 b/tests/xfs/350
new file mode 100644
index 0000000..47e0b7d
--- /dev/null
+++ b/tests/xfs/350
@@ -0,0 +1,139 @@
+#! /bin/bash
+# FS QA Test No. 350
+#
+# Verify extended attributes are not lost after multi-stream
+# xfsdump/xfsrestore of wholly-sparse files. The same root cause
+# occurs with successful dumps (test 1) and also segfaults (test 2). 
+
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
+#
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
+trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/dump
+
+# real QA test starts here
+_supported_fs xfs
+_supported_os Linux
+_require_scratch
+_scratch_mkfs
+_scratch_mount
+
+_require_multi_stream
+
+# dir where we'll restore
+RESTOREDIR=$SCRATCH_MNT/restore
+
+# subdir used for dump/restore
+DUMPDIR=dumpsrc
+
+# test extended attributes
+attr_name=testattr
+attr_value=1234
+
+# setup for test
+rm -r $seqres.full
+mkdir -p $RESTOREDIR
+mkdir -p $SCRATCH_MNT/$DUMPDIR
+
+# cleanup for next dump/restore.
+_clean_dirs()
+{
+	rm -rf $SCRATCH_MNT/$DUMPDIR/*
+	rm -rf $RESTOREDIR/*
+	rm -f $tmp.stream?
+}
+
+# set the extended attributes on the test files.
+_set_attrs()
+{
+	for fname in $(ls -dD $SCRATCH_MNT/$DUMPDIR/*); do
+		attr -s $attr_name -V $attr_value $fname \
+		2>&1 >> $seqres.full || _fail "could not set ATTR for $fname"
+	done
+}
+
+# perform a dump and restore.
+_do_dump_restore()
+{
+	$XFSDUMP_PROG -L session -M label1 -M label2 -f $tmp.stream1 \
+		-f $tmp.stream2 $SCRATCH_MNT -s $DUMPDIR \
+		2>&1 >> $seqres.full || _fail "dump failed"
+	$XFSRESTORE_PROG -F -f $tmp.stream1 -f $tmp.stream2 $RESTOREDIR \
+		2>&1 >> $seqres.full || _fail "restore failed"
+}
+
+# verify the restored files extended attributes and echo the error
+# (if any) so the test will continue on to test 2. If the restore is
+# not successful this will not be called to show the attributes are lost.
+_verify_attrs()
+{
+	for fname in $(ls -dD $RESTOREDIR/$DUMPDIR/*); do
+		attr -g $attr_name $fname 2>&1 | tee -a $seqres.full | \
+			grep $attr_value 2>&1 >> $seqres.full || \
+			echo "ATTR for $fname  DOES NOT match"
+	done
+}
+
+# create files for test 1, a large file so the sparse file
+# is in the next stream.
+_create_test1_files()
+{
+
+	dd if=/dev/zero of=$SCRATCH_MNT/$DUMPDIR/10MB bs=1MB \
+		count=10 2>&1 >> $seqres.full | _filter_dd
+	$XFS_IO_PROG -c "truncate --size=1t" $SCRATCH_MNT/$DUMPDIR/sparse0 \
+		2>&1 >> $seqres.full
+}
+
+# create 4 sparse files for test 2
+_create_test2_files()
+{
+	for i in `seq 1 4`; do
+		truncate --size=1t $SCRATCH_MNT/$DUMPDIR/sparse$i 2>&1 >> \
+		$seqres.full || _fail "failed to create sparse \"$i\""
+	done
+}
+echo "Silence is golden."
+echo "Starting Test 1" >> $seqres.full
+_clean_dirs
+_create_test1_files
+_set_attrs
+_do_dump_restore
+_verify_attrs
+
+echo "Starting Test 2" >> $seqres.full
+_clean_dirs
+_create_test2_files
+_set_attrs
+_do_dump_restore
+_verify_attrs
+
+# success, all done
+exit
diff --git a/tests/xfs/350.out b/tests/xfs/350.out
new file mode 100644
index 0000000..c725135
--- /dev/null
+++ b/tests/xfs/350.out
@@ -0,0 +1,2 @@
+QA output created by 350
+Silence is golden.
diff --git a/tests/xfs/group b/tests/xfs/group
index 352a4c5..2cd3cf0 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -179,3 +179,4 @@
 297 auto freeze
 298 auto attr symlink quick
 299 auto quota
+350 dump auto


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
