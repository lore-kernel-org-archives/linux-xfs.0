Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 943C97F3F
	for <xfs@oss.sgi.com>; Wed, 27 Aug 2014 23:24:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 228BEAC005
	for <xfs@oss.sgi.com>; Wed, 27 Aug 2014 21:24:06 -0700 (PDT)
Received: from mail-wi0-f176.google.com (mail-wi0-f176.google.com
	[209.85.212.176]) by cuda.sgi.com with ESMTP id
	JplefIzonbOlFJj8 (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 27 Aug 2014 21:24:04 -0700 (PDT)
Received: by mail-wi0-f176.google.com with SMTP id bs8so6806787wib.3
	for <xfs@oss.sgi.com>; Wed, 27 Aug 2014 21:24:03 -0700 (PDT)
From: Iustin Pop <iusty@k1024.org>
Subject: [PATCH xfstests] xfs: add tests for XFS_IOC_FSSETXATTR behaviour
Date: Wed, 27 Aug 2014 21:24:00 -0700
Message-Id: <1409199840-16907-1-git-send-email-iusty@k1024.org>
In-Reply-To: <20140718191314.GB27801@teal.hq.k1024.org>
References: <20140718191314.GB27801@teal.hq.k1024.org>
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
Cc: hch@infradead.org, Iustin Pop <iusty@k1024.org>

Add two tests that check for correct behaviour of XFS_IOC_FSSETXATTR:

- 307: check that extent size can always be set on a directory
- 308: check that setting a non-zero extent size directly via the ioctl
  sets the expected flags (EXTSIZE and EXTSZINHERIT)

Signed-off-by: Iustin Pop <iusty@k1024.org>
---
 tests/xfs/307     | 87 ++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/307.out |  3 ++
 tests/xfs/308     | 98 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/308.out |  3 ++
 tests/xfs/group   |  2 ++
 5 files changed, 193 insertions(+)
 create mode 100755 tests/xfs/307
 create mode 100644 tests/xfs/307.out
 create mode 100755 tests/xfs/308
 create mode 100644 tests/xfs/308.out

diff --git a/tests/xfs/307 b/tests/xfs/307
new file mode 100755
index 0000000..e8f3576
--- /dev/null
+++ b/tests/xfs/307
@@ -0,0 +1,87 @@
+#! /bin/bash
+# FS QA Test No. 307
+#
+# Test that setting extent size on directories work even for large
+# directories.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2014 Google Inc.  All Rights Reserved.
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
+# real QA test starts here
+
+# Modify as appropriate.
+_supported_fs xfs
+_supported_os Linux
+_require_test
+_require_scratch
+
+_scratch_mkfs_xfs >/dev/null 2>&1
+_scratch_mount
+
+small=$SCRATCH_MNT/small
+big=$SCRATCH_MNT/big
+
+# sanity check on a small directory
+mkdir $small
+# expect that an empty directory has no extents
+xfs_bmap $small | grep -q "no extents"
+# and that we can set an extent size on it
+xfs_io -c 'extsize 8m' $small
+# and finally check that the extent size update has taken place
+(cd $SCRATCH_MNT; xfs_io -c 'extsize' small)
+
+# now create a 'big' (with extents) directory
+mkdir $big
+idx=1
+while xfs_bmap $big | grep -q "no extents"; do
+	touch $big/$idx
+	idx=$((idx+1))
+	if [ "$idx" -gt 1048576 ]; then
+		# still no extents? giving up
+		echo "Can't make a directory to have extents even after 1M files" 1>&2
+		exit
+	fi
+done
+
+# expect that we can set the extent size on $big as well
+xfs_io -c 'extsize 8m' $big
+# and that it took effect
+(cd $SCRATCH_MNT; xfs_io -c 'extsize' big)
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/307.out b/tests/xfs/307.out
new file mode 100644
index 0000000..f825525
--- /dev/null
+++ b/tests/xfs/307.out
@@ -0,0 +1,3 @@
+QA output created by 307
+[8388608] small
+[8388608] big
diff --git a/tests/xfs/308 b/tests/xfs/308
new file mode 100755
index 0000000..7b43836
--- /dev/null
+++ b/tests/xfs/308
@@ -0,0 +1,98 @@
+#! /bin/bash
+# FS QA Test No. 308
+#
+# Test that setting extent size on files and directories (directly via
+# ioctl and not via xfs_io) sets the correct flags.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2014 Google Inc.  All Rights Reserved.
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
+# real QA test starts here
+
+# Modify as appropriate.
+_supported_fs xfs
+_supported_os Linux
+_require_test
+_require_scratch
+
+_scratch_mkfs_xfs >/dev/null 2>&1
+_scratch_mount
+
+file=$SCRATCH_MNT/file
+dir=$SCRATCH_MNT/dir
+cprog=$tmp.get_structs.c
+oprog=$tmp.get_structs
+
+touch $file
+mkdir $dir
+
+cat > $cprog << EOF
+#include <stdio.h>
+#include <xfs/xfs.h>
+
+int main(int argc, char **argv) {
+	struct fsxattr fa;
+	int fd = open(argv[1], O_RDONLY);
+	if (fd < 0) {
+		perror("open");
+		return 1;
+	}
+	fa.fsx_xflags = 0;
+	fa.fsx_extsize = 1048576 * 8;
+	int r = xfsctl(argv[1], fd, XFS_IOC_FSSETXATTR, &fa);
+	if (r < 0) {
+		perror("xfsctl");
+		return 1;
+	}
+	return 0;
+}
+EOF
+cc -o $oprog $cprog >> $seqres.full 2>&1 || \
+  _notrun "Could not compile test program (see end of $seqres.full)"
+
+$oprog $file
+$oprog $dir
+(cd $SCRATCH_MNT;
+ xfs_io -c 'lsattr' file;
+ xfs_io -c 'lsattr' dir)
+
+rm $file
+rmdir $dir
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/308.out b/tests/xfs/308.out
new file mode 100644
index 0000000..ef2d5fd
--- /dev/null
+++ b/tests/xfs/308.out
@@ -0,0 +1,3 @@
+QA output created by 308
+----------e--- file 
+-----------E-- dir 
diff --git a/tests/xfs/group b/tests/xfs/group
index 4d35df5..35f1e6a 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -197,3 +197,5 @@
 304 auto quick quota
 305 auto quota
 306 auto stress log metadata repair
+307 ioctl quick
+308 ioctl quick
-- 
2.1.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
