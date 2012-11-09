Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA9FcSmU122495 for <xfs@oss.sgi.com>; Fri, 9 Nov 2012 09:38:28 -0600
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id fqrVLeLgAVP9rGT2 for
	<xfs@oss.sgi.com>; Fri, 09 Nov 2012 07:40:27 -0800 (PST)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id qA9FeNAJ010637
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 9 Nov 2012 10:40:26 -0500
Received: from bfoster.bfoster (dhcp-191-48.bos.redhat.com [10.16.191.48])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id qA9FeMnk022517
	for <xfs@oss.sgi.com>; Fri, 9 Nov 2012 10:40:23 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 RFC] xfstests: speculative preallocaction trimming test
Date: Fri,  9 Nov 2012 10:42:12 -0500
Message-Id: <1352475732-61384-1-git-send-email-bfoster@redhat.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

The speculative preallocation trimming test verifies that files
with post-EOF blocks are trimmed when the scan is invoked.
Background scans and the various scan filters are tested as well.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---

v2:
- Fix up comments, test description and style/output issues.
- Replace _fail with appropriate filters.
- Cleaned up the trim_prealloc and stat_files functions. I left the functions
  around because I think they improve readability, but I'll open-code them if
  there are objections to how things look in this version.
- Added the test to the rw and ioctl groups. I wonder if the prealloc group also
  makes sense?

 290           |  158 ++++++++++++++++++++++++++++++++++++++
 290.out       |  235 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 common.config |    1 +
 common.rc     |   10 +++
 group         |    1 +
 5 files changed, 405 insertions(+), 0 deletions(-)
 create mode 100755 290
 create mode 100644 290.out

diff --git a/290 b/290
new file mode 100755
index 0000000..9d84366
--- /dev/null
+++ b/290
@@ -0,0 +1,158 @@
+#! /bin/bash
+# FS QA Test No. 290
+#
+# Verify speculative preallocation trimming functionality.
+#
+# XFS speculatively preallocates post-EOF blocks on sequential writes. Such space
+# is typically trimmed when a file is closed, but repeated open-write-close
+# patterns (i.e., NFS) cause this space to hang around until inodes are flushed.
+# The XFS-specific FREE_EOFBLOCKS command exists to scan preallocated files (with
+# various filtration parameters) and trim the excess space. A background scanner
+# also exists to prevent files with excess space from lingering too long. The
+# purpose of this test is to verify the functionality of the scan ioctl (via
+# xfs_spaceman), the various filters and the background scanner.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2012 Red Hat, Inc. All Rights Reserved.
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
+# creator
+owner=bfoster@redhat.com
+
+seq=`basename $0`
+echo "QA output created by $seq"
+tmp=/tmp/$$
+here=`pwd`
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+rm -f $seq.full
+
+# get standard environment, filters and checks
+. ./common.rc
+. ./common.filter
+. ./common.quota
+
+_cleanup()
+{
+	cd /
+	umount $SCRATCH_MNT 2>/dev/null
+	rm -rf $tmp.*
+}
+
+# Write a file of specified size after sending a couple 1 byte writes. The
+# repeated writes triggers the open-write-close optimization that keeps post-EOF
+# preallocated space around.
+write_prealloc_file()
+{
+	file=$1
+	size=$2
+
+	for i in "1" "1" "$size"
+	do
+		$XFS_IO_PROG -f -c "pwrite -b 4k 0 $i" $file | _filter_xfs_io
+	done
+}
+
+trim_prealloc()
+{
+	args=$1
+
+	$XFS_SPACEMAN_PROG -c "prealloc $args" $SCRATCH_MNT
+}
+
+stat_files()
+{
+	echo $1
+	stat -c "%n %s bytes %b blocks" $SCRATCH_MNT/test.* | _filter_scratch
+}
+
+# Create a set of test.* files that fall under different filters for prealloc
+# scanning.
+create_files()
+{
+	rm -f $SCRATCH_MNT/test.*
+	
+	write_prealloc_file $SCRATCH_MNT/test.${qa_user} 6m
+	chown ${qa_user}:${qa_user} $SCRATCH_MNT/test.${qa_user}
+
+	write_prealloc_file $SCRATCH_MNT/test.${qa_user}.root 6m
+	chown ${qa_user}:root $SCRATCH_MNT/test.${qa_user}.root
+
+	write_prealloc_file $SCRATCH_MNT/test.prid.42 6m
+	$XFS_QUOTA_PROG -x -c "project -s -p $SCRATCH_MNT/test.prid.42 42" \
+		$SCRATCH_MNT | _filter_scratch
+
+	write_prealloc_file $SCRATCH_MNT/test.10m 10m
+
+	write_prealloc_file $SCRATCH_MNT/test.falloc 6m
+	$XFS_IO_PROG -c "falloc 0 1" $SCRATCH_MNT/test.falloc
+}
+
+# real QA test starts here
+_supported_fs xfs
+_require_xfs_spaceman_prealloc
+_require_scratch
+_require_user
+_require_xfs_quota
+
+_scratch_mkfs_sized 200m >> $seq.full 2>&1
+_scratch_mount
+
+# global scan (no filter)
+create_files
+stat_files "files"
+trim_prealloc "-s"
+stat_files "no filter"
+
+# filter by file size
+create_files
+trim_prealloc "-s -m $((1024*1024*10))"
+stat_files "10m size filter"
+
+# filter by project id
+create_files
+trim_prealloc "-s -p 42"
+stat_files "project id filter"
+
+# filter by uid
+create_files
+trim_prealloc "-s -u $(id -u $qa_user)"
+stat_files "uid filter"
+
+# filter by uid/gid
+create_files
+trim_prealloc "-s -u $(id -u $qa_user) -g $(id -g $qa_user)"
+stat_files "uid/gid filter"
+
+# To test the background scan, clean up (unmount), set the prealloc lifetime to 5s
+# and remount to ensure that the new lifetime kicks in immediately.
+_cleanup
+old_lifetime=`cat /proc/sys/fs/xfs/speculative_prealloc_lifetime`
+echo 5 > /proc/sys/fs/xfs/speculative_prealloc_lifetime
+
+# flush and wait for a few background scan intervals
+_scratch_mount
+create_files
+sync
+sleep 15
+stat_files "background scan"
+
+echo $old_lifetime > /proc/sys/fs/xfs/speculative_prealloc_lifetime
+
+status=0
+exit
+
diff --git a/290.out b/290.out
new file mode 100644
index 0000000..0c040bd
--- /dev/null
+++ b/290.out
@@ -0,0 +1,235 @@
+QA output created by 290
+wrote 1/1 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 1/1 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 6291456/6291456 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 1/1 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 1/1 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 6291456/6291456 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 1/1 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 1/1 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 6291456/6291456 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+Setting up project 42 (path SCRATCH_MNT/test.prid.42)...
+Processed 1 (/etc/projects and cmdline) paths for project 42 with recursion depth infinite (-1).
+wrote 1/1 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 1/1 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 10485760/10485760 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 1/1 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 1/1 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 6291456/6291456 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+files
+SCRATCH_MNT/test.10m 10485760 bytes 32768 blocks
+SCRATCH_MNT/test.falloc 6291456 bytes 16384 blocks
+SCRATCH_MNT/test.fsgqa 6291456 bytes 16384 blocks
+SCRATCH_MNT/test.fsgqa.root 6291456 bytes 16384 blocks
+SCRATCH_MNT/test.prid.42 6291456 bytes 16384 blocks
+no filter
+SCRATCH_MNT/test.10m 10485760 bytes 20480 blocks
+SCRATCH_MNT/test.falloc 6291456 bytes 16384 blocks
+SCRATCH_MNT/test.fsgqa 6291456 bytes 12288 blocks
+SCRATCH_MNT/test.fsgqa.root 6291456 bytes 12288 blocks
+SCRATCH_MNT/test.prid.42 6291456 bytes 12288 blocks
+wrote 1/1 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 1/1 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 6291456/6291456 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 1/1 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 1/1 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 6291456/6291456 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 1/1 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 1/1 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 6291456/6291456 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+Setting up project 42 (path SCRATCH_MNT/test.prid.42)...
+Processed 1 (/etc/projects and cmdline) paths for project 42 with recursion depth infinite (-1).
+wrote 1/1 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 1/1 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 10485760/10485760 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 1/1 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 1/1 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 6291456/6291456 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+10m size filter
+SCRATCH_MNT/test.10m 10485760 bytes 20480 blocks
+SCRATCH_MNT/test.falloc 6291456 bytes 16384 blocks
+SCRATCH_MNT/test.fsgqa 6291456 bytes 16384 blocks
+SCRATCH_MNT/test.fsgqa.root 6291456 bytes 16384 blocks
+SCRATCH_MNT/test.prid.42 6291456 bytes 16384 blocks
+wrote 1/1 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 1/1 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 6291456/6291456 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 1/1 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 1/1 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 6291456/6291456 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 1/1 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 1/1 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 6291456/6291456 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+Setting up project 42 (path SCRATCH_MNT/test.prid.42)...
+Processed 1 (/etc/projects and cmdline) paths for project 42 with recursion depth infinite (-1).
+wrote 1/1 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 1/1 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 10485760/10485760 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 1/1 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 1/1 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 6291456/6291456 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+project id filter
+SCRATCH_MNT/test.10m 10485760 bytes 32768 blocks
+SCRATCH_MNT/test.falloc 6291456 bytes 16384 blocks
+SCRATCH_MNT/test.fsgqa 6291456 bytes 16384 blocks
+SCRATCH_MNT/test.fsgqa.root 6291456 bytes 16384 blocks
+SCRATCH_MNT/test.prid.42 6291456 bytes 12288 blocks
+wrote 1/1 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 1/1 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 6291456/6291456 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 1/1 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 1/1 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 6291456/6291456 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 1/1 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 1/1 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 6291456/6291456 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+Setting up project 42 (path SCRATCH_MNT/test.prid.42)...
+Processed 1 (/etc/projects and cmdline) paths for project 42 with recursion depth infinite (-1).
+wrote 1/1 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 1/1 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 10485760/10485760 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 1/1 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 1/1 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 6291456/6291456 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+uid filter
+SCRATCH_MNT/test.10m 10485760 bytes 32768 blocks
+SCRATCH_MNT/test.falloc 6291456 bytes 16384 blocks
+SCRATCH_MNT/test.fsgqa 6291456 bytes 12288 blocks
+SCRATCH_MNT/test.fsgqa.root 6291456 bytes 12288 blocks
+SCRATCH_MNT/test.prid.42 6291456 bytes 16384 blocks
+wrote 1/1 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 1/1 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 6291456/6291456 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 1/1 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 1/1 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 6291456/6291456 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 1/1 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 1/1 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 6291456/6291456 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+Setting up project 42 (path SCRATCH_MNT/test.prid.42)...
+Processed 1 (/etc/projects and cmdline) paths for project 42 with recursion depth infinite (-1).
+wrote 1/1 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 1/1 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 10485760/10485760 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 1/1 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 1/1 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 6291456/6291456 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+uid/gid filter
+SCRATCH_MNT/test.10m 10485760 bytes 32768 blocks
+SCRATCH_MNT/test.falloc 6291456 bytes 16384 blocks
+SCRATCH_MNT/test.fsgqa 6291456 bytes 12288 blocks
+SCRATCH_MNT/test.fsgqa.root 6291456 bytes 16384 blocks
+SCRATCH_MNT/test.prid.42 6291456 bytes 16384 blocks
+wrote 1/1 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 1/1 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 6291456/6291456 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 1/1 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 1/1 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 6291456/6291456 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 1/1 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 1/1 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 6291456/6291456 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+Setting up project 42 (path SCRATCH_MNT/test.prid.42)...
+Processed 1 (/etc/projects and cmdline) paths for project 42 with recursion depth infinite (-1).
+wrote 1/1 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 1/1 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 10485760/10485760 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 1/1 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 1/1 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 6291456/6291456 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+background scan
+SCRATCH_MNT/test.10m 10485760 bytes 20480 blocks
+SCRATCH_MNT/test.falloc 6291456 bytes 16384 blocks
+SCRATCH_MNT/test.fsgqa 6291456 bytes 12288 blocks
+SCRATCH_MNT/test.fsgqa.root 6291456 bytes 12288 blocks
+SCRATCH_MNT/test.prid.42 6291456 bytes 12288 blocks
diff --git a/common.config b/common.config
index 585b150..7d63067 100644
--- a/common.config
+++ b/common.config
@@ -159,6 +159,7 @@ export KILLALL_PROG="`set_prog_path killall`"
 export INDENT_PROG="`set_prog_path indent`"
 export XFS_COPY_PROG="`set_prog_path xfs_copy`"
 export FSTRIM_PROG="`set_prog_path fstrim`"
+export XFS_SPACEMAN_PROG="`set_prog_path xfs_spaceman`"
 
 # Generate a comparable xfsprogs version number in the form of
 # major * 10000 + minor * 100 + release
diff --git a/common.rc b/common.rc
index f7c1688..e221599 100644
--- a/common.rc
+++ b/common.rc
@@ -998,6 +998,16 @@ _require_xfs_io_fiemap()
 		_notrun "xfs_io fiemap command failed (no fs support?)"
 }
 
+# check that xfs_spaceman exists and supports the prealloc command
+_require_xfs_spaceman_prealloc()
+{
+	[ "$XFS_SPACEMAN_PROG" != "" ] || _notrun "xfs_spaceman not installed"
+
+	testio=`$XFS_SPACEMAN_PROG -c "prealloc -a" $TEST_DIR 2>&1`
+	echo $testio | grep -q "Inappropriate ioctl for device" && \
+		_notrun "xfs_spaceman prealloc command failed (no fs support?)"
+}
+
 # Check that a fs has enough free space (in 1024b blocks)
 #
 _require_fs_space()
diff --git a/group b/group
index a846b60..790e3c6 100644
--- a/group
+++ b/group
@@ -408,3 +408,4 @@ deprecated
 287 auto dump quota quick
 288 auto quick ioctl trim
 289 auto quick
+290 auto quick rw ioctl
-- 
1.7.7.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
