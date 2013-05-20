Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 898967F37
	for <xfs@oss.sgi.com>; Mon, 20 May 2013 12:20:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0A886AC002
	for <xfs@oss.sgi.com>; Mon, 20 May 2013 10:20:38 -0700 (PDT)
Received: from dkim1.fusionio.com (dkim1.fusionio.com [66.114.96.53]) by
	cuda.sgi.com with ESMTP id 3DrRdgHLMdmAVQQM (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 20 May 2013 10:20:37 -0700 (PDT)
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 014F07C04D8
	for <xfs@oss.sgi.com>; Mon, 20 May 2013 11:20:37 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
Subject: [PATCH] xfstests: btrfs 308: regression test for btrfs send
Date: Mon, 20 May 2013 13:20:34 -0400
Message-ID: <1369070434-20852-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
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
To: xfs@oss.sgi.com, linux-btrfs@vger.kernel.org

I'm not sure how the numbering is supposed to work now that we've split
everything out so I'm just going with the next number in the directory.  This is
a regression test for btrfs send, we had a problem where we'd try to send a file
that had been deleted in the source snapshot.  This is just to make sure we
don't have the same problem in the future.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 src/Makefile        |    2 +-
 src/hold-open.c     |   29 ++++++++++++++++++++
 tests/btrfs/308     |   74 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/308.out |    2 +
 tests/btrfs/group   |    1 +
 5 files changed, 107 insertions(+), 1 deletions(-)
 create mode 100644 src/hold-open.c
 create mode 100644 tests/btrfs/308
 create mode 100644 tests/btrfs/308.out

diff --git a/src/Makefile b/src/Makefile
index c18ffc9..3ab9a21 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -18,7 +18,7 @@ LINUX_TARGETS = xfsctl bstat t_mtab getdevicesize preallo_rw_pattern_reader \
 	locktest unwritten_mmap bulkstat_unlink_test t_stripealign \
 	bulkstat_unlink_test_modified t_dir_offset t_futimens t_immutable \
 	stale_handle pwrite_mmap_blocked t_dir_offset2 seek_sanity_test \
-	seek_copy_test t_readdir_1 t_readdir_2 fsync-tester
+	seek_copy_test t_readdir_1 t_readdir_2 fsync-tester hold-open
 
 SUBDIRS =
 
diff --git a/src/hold-open.c b/src/hold-open.c
new file mode 100644
index 0000000..f44c1dd
--- /dev/null
+++ b/src/hold-open.c
@@ -0,0 +1,29 @@
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+#include <stdio.h>
+#include <errno.h>
+#include <unistd.h>
+
+int main(int argc, char **argv)
+{
+	int fd;
+
+	if (argc < 2) {
+		fprintf(stderr, "Usage: hold-open <filename>\n");
+		return -1;
+	}
+
+	fd = open(argv[1], O_RDONLY);
+	if (fd < 0) {
+		fprintf(stderr, "Error opening file: %d\n", errno);
+		return -1;
+	}
+
+	while (1) {
+		sleep(60);
+	}
+
+	close(fd);
+	return 0;
+}
diff --git a/tests/btrfs/308 b/tests/btrfs/308
new file mode 100644
index 0000000..144be99
--- /dev/null
+++ b/tests/btrfs/308
@@ -0,0 +1,74 @@
+#! /bin/bash
+# FS QA Test No. btrfs/308
+#
+# btrfs send ESTALE regression test, kernel.org bugzilla 57491
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2013 Fusion IO.  All Rights Reserved.
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
+
+_cleanup()
+{
+    rm -f $tmp.*
+}
+
+trap "_cleanup ; exit \$status" 0 1 2 3 15
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+_supported_fs btrfs
+_supported_os Linux
+_require_scratch
+
+_scratch_mkfs > /dev/null 2>&1
+_scratch_mount
+
+dd if=/dev/zero of=$SCRATCH_MNT/foo bs=1M count=10 > /dev/null 2>&1
+sync
+$BTRFS_UTIL_PROG subvol snap -r $SCRATCH_MNT $SCRATCH_MNT/snap > /dev/null 2>&1
+dd if=/dev/zero of=$SCRATCH_MNT/foo bs=1M count=10 oflag=append > /dev/null 2>&1
+sync
+
+# We need to hold the file open, tail -f makes the output file look weird so
+# here is this awful hack to get around that
+$here/src/hold-open $SCRATCH_MNT/foo &
+
+# need this so that tail doesn't error out racing with the rm
+sleep 1
+rm -f $SCRATCH_MNT/foo
+$BTRFS_UTIL_PROG subvol snap -r $SCRATCH_MNT $SCRATCH_MNT/snap1 > /dev/null 2>&1
+$BTRFS_UTIL_PROG send -f /dev/null -p $SCRATCH_MNT/snap $SCRATCH_MNT/snap1 >/dev/null 2>&1
+if [ $? -ne 0 ]
+then
+	echo "send failed"
+fi
+kill $!
+
+echo "Silence is golden"
+status=0 ; exit
diff --git a/tests/btrfs/308.out b/tests/btrfs/308.out
new file mode 100644
index 0000000..a731eaa
--- /dev/null
+++ b/tests/btrfs/308.out
@@ -0,0 +1,2 @@
+QA output created by 308
+Silence is golden
diff --git a/tests/btrfs/group b/tests/btrfs/group
index bc6c256..666054b 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -9,3 +9,4 @@
 276 auto rw metadata
 284 auto
 307 auto quick
+308 auto quick
-- 
1.7.7.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
