Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2160A7F50
	for <xfs@oss.sgi.com>; Tue, 11 Feb 2014 20:26:56 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8D638AC003
	for <xfs@oss.sgi.com>; Tue, 11 Feb 2014 18:26:52 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id Vw7TZK8JK7r4hLsx for <xfs@oss.sgi.com>;
	Tue, 11 Feb 2014 18:26:50 -0800 (PST)
Message-ID: <52FADBE9.90101@sandeen.net>
Date: Tue, 11 Feb 2014 20:26:49 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH V2] xfstests: check that junk in V4 superblocks doesn't break
	growfs
References: <52FAD989.6020000@redhat.com>
In-Reply-To: <52FAD989.6020000@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

Test that we properly ignore old growfs-induced junk in the unused
portion of secondary V4 superblocks; at one point this would
trip up the verifiers, and cause a subsequent growfs to fail.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

V2, fix wrong summary for commit in question, in the test comments

diff --git a/tests/xfs/307 b/tests/xfs/307
new file mode 100755
index 0000000..d3c768f
--- /dev/null
+++ b/tests/xfs/307
@@ -0,0 +1,75 @@
+#! /bin/bash
+# FS QA Test No. 307
+#
+# Test that garbage in old v4 superblocks doesn't trip verifiers during growfs
+#
+# Older kernels sometimes left garbage in the unused portions
+# of the superblock during growfs; with the new verifiers this initially
+# caused failures during a subsequent growfs; see
+# 10e6e65 xfs: be more forgiving of a v4 secondary sb w/ junk in v5 fields
+# for further explanation.  (NB: while the commit log was good, the
+# patch had a bug which was subsequently fixed)
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2014 Red Hat, Inc.  All Rights Reserved.
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
+
+# Modify as appropriate.
+_supported_fs xfs
+_supported_os Linux
+
+_require_scratch
+# So we can explicitly turn it _off_:
+_require_xfs_mkfs_crc
+
+rm -f $seqres.full
+
+_scratch_mkfs_xfs -m crc=0 -d size=128m >> $seqres.full 2>&1 || _fail "mkfs failed"
+
+# Scribble past a couple V4 secondary superblocks to populate sb_crc
+# (We can't write to the structure member because it doesn't exist
+# on a v4 superblock, so we use the data type & "write fill")
+$XFS_DB_PROG -x -c "sb 1" -c "type data" -c "write fill 0xff 224 4" $SCRATCH_DEV
+$XFS_DB_PROG -x -c "sb 2" -c "type data" -c "write fill 0xff 224 4" $SCRATCH_DEV
+
+_scratch_mount
+
+# This should pass
+$XFS_GROWFS_PROG $SCRATCH_MNT >> $seqres.full 2>&1 || _fail "growfs failed"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/307.out b/tests/xfs/307.out
new file mode 100644
index 0000000..260c17c
--- /dev/null
+++ b/tests/xfs/307.out
@@ -0,0 +1 @@
+QA output created by 307
diff --git a/tests/xfs/group b/tests/xfs/group
index 279ffe2..fbcd3e3 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -186,3 +186,4 @@
 304 auto quick quota
 305 auto quota
 306 auto stress log metadata repair
+307 auto quick growfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
