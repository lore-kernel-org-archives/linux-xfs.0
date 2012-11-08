Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA8KEMaK019557 for <xfs@oss.sgi.com>; Thu, 8 Nov 2012 14:14:22 -0600
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id YBPTVQdxsE4Yqkwx for
	<xfs@oss.sgi.com>; Thu, 08 Nov 2012 12:16:20 -0800 (PST)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id qA8KGJcQ026290
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 8 Nov 2012 15:16:19 -0500
Received: from bfoster.bfoster (dhcp-191-48.bos.redhat.com [10.16.191.48])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id qA8KGJbv018740
	for <xfs@oss.sgi.com>; Thu, 8 Nov 2012 15:16:19 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH RFC] xfstests: speculative preallocaction trimming test
Date: Thu,  8 Nov 2012 15:18:09 -0500
Message-Id: <1352405889-41186-1-git-send-email-bfoster@redhat.com>
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

Hi all,

This is my first stab at an xfstests test for the eofblocks patchset. This
depends on the xfs_spaceman tool and associated 'prealloc' command. The bits to
check the latter command are included for brevity, but I could certainly break
that stuff into a 1/2 patch in subsequent posts if desired. This has been lightly
tested against the v7 eofblocks set running in a VM. Thoughts appreciated.

Brian

 290           |  176 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 290.out       |   55 ++++++++++++++++++
 common.config |    1 +
 common.rc     |   10 +++
 group         |    1 +
 5 files changed, 243 insertions(+), 0 deletions(-)
 create mode 100755 290
 create mode 100644 290.out

diff --git a/290 b/290
new file mode 100755
index 0000000..12ce9c2
--- /dev/null
+++ b/290
@@ -0,0 +1,176 @@
+#! /bin/bash
+# FS QA Test No. 290
+#
+# Verify speculative preallocation trimming functionality.
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
+_write_prealloc_file()
+{
+	file=$1
+	size=$2
+
+	for i in "1" "1" "$size"
+	do
+		$XFS_IO_PROG -f -c "pwrite -b 4k 0 $i" $file \
+			>> $seq.full 2>&1 || _fail "failed to write file"
+	done
+}
+
+_trim_prealloc()
+{
+	file=$1
+	args=$2
+
+	$XFS_SPACEMAN_PROG -c "prealloc $args" $file >> $seq.full 2>&1 \
+		|| _fail "failed to trim file preallocation"
+}
+
+_stat_files()
+{
+	for i in $SCRATCH_MNT/test.*
+	do
+		echo -n "$(basename $i) "
+		stat -c "%s bytes %b blocks" $i
+	done
+}
+
+# Create a set of test.* files that fall under different filters for prealloc
+# scanning.
+_create_files()
+{
+	rm -f $SCRATCH_MNT/test.*
+	
+	_write_prealloc_file $SCRATCH_MNT/test.${qa_user} 6m
+	chown ${qa_user}:${qa_user} $SCRATCH_MNT/test.${qa_user}
+
+	_write_prealloc_file $SCRATCH_MNT/test.${qa_user}.root 6m
+	chown ${qa_user}:root $SCRATCH_MNT/test.${qa_user}.root
+
+	_write_prealloc_file $SCRATCH_MNT/test.prid.42 6m
+	$XFS_QUOTA_PROG -x -c "project -s -p $SCRATCH_MNT/test.prid.42 42" \
+		$SCRATCH_MNT >> $seq.full 2>&1 || _fail "failed to set project id"
+
+	_write_prealloc_file $SCRATCH_MNT/test.10m 10m
+
+	_write_prealloc_file $SCRATCH_MNT/test.falloc 6m
+	$XFS_IO_PROG -c "falloc 0 1" $SCRATCH_MNT/test.falloc \
+		>> $seq.full 2>&1 || _fail "failed to fallocate file"
+}
+
+_set_speculative_prealloc_lifetime()
+{
+	seconds=$1
+	echo $seconds > /proc/sys/fs/xfs/speculative_prealloc_lifetime || \
+		_fail "failed to set speculative_prealloc_lifetime"
+}
+
+# real QA test starts here
+_supported_fs xfs
+_require_xfs_spaceman_prealloc
+_require_scratch
+_require_user
+_require_xfs_quota
+
+_scratch_mkfs_xfs -d size=200m >> $seq.full 2>&1 || _fail "mkfs failed"
+_scratch_mount
+
+echo "==================="
+echo -e "speculative preallocation trim"
+
+_create_files
+echo -e "\nfiles"
+_stat_files
+# trim all files
+_trim_prealloc $SCRATCH_MNT "-s"
+echo -e "\nno filter"
+_stat_files
+
+_create_files
+# trim files >=10MB
+_trim_prealloc $SCRATCH_MNT "-s -m $((1024*1024*10))"
+echo -e "\n10m size filter"
+_stat_files
+
+_create_files
+# trim project id 42
+_trim_prealloc $SCRATCH_MNT "-s -p 42"
+echo -e "\nproject id filter"
+_stat_files
+
+_create_files
+# trim files owned by $qa_user
+_trim_prealloc $SCRATCH_MNT "-s -u $(id -u $qa_user)"
+echo -e "\nuid filter"
+_stat_files
+
+_create_files
+# trim files with $qa_user owner and group
+_trim_prealloc $SCRATCH_MNT "-s -u $(id -u $qa_user) -g $(id -g $qa_user)"
+echo -e "\nuid/gid filter"
+_stat_files
+
+echo -e "\n==================="
+echo -e "background speculative preallocation trim"
+
+# Clean up (unmount), set the lifetime to 5s and remount to ensure that the new
+# lifetime kicks in immediately.
+
+_cleanup
+_set_speculative_prealloc_lifetime 5
+
+_scratch_mount
+_create_files
+
+# flush and wait a few scan intervals
+sync
+sleep 15
+echo -e "\nbackground scan"
+_stat_files
+
+_set_speculative_prealloc_lifetime 300
+
+status=0
+exit
+
diff --git a/290.out b/290.out
new file mode 100644
index 0000000..a295830
--- /dev/null
+++ b/290.out
@@ -0,0 +1,55 @@
+QA output created by 290
+===================
+speculative preallocation trim
+
+files
+test.10m 10485760 bytes 32768 blocks
+test.falloc 6291456 bytes 16384 blocks
+test.fsgqa 6291456 bytes 16384 blocks
+test.fsgqa.root 6291456 bytes 16384 blocks
+test.prid.42 6291456 bytes 16384 blocks
+
+no filter
+test.10m 10485760 bytes 20480 blocks
+test.falloc 6291456 bytes 16384 blocks
+test.fsgqa 6291456 bytes 12288 blocks
+test.fsgqa.root 6291456 bytes 12288 blocks
+test.prid.42 6291456 bytes 12288 blocks
+
+10m size filter
+test.10m 10485760 bytes 20480 blocks
+test.falloc 6291456 bytes 16384 blocks
+test.fsgqa 6291456 bytes 16384 blocks
+test.fsgqa.root 6291456 bytes 16384 blocks
+test.prid.42 6291456 bytes 16384 blocks
+
+project id filter
+test.10m 10485760 bytes 32768 blocks
+test.falloc 6291456 bytes 16384 blocks
+test.fsgqa 6291456 bytes 16384 blocks
+test.fsgqa.root 6291456 bytes 16384 blocks
+test.prid.42 6291456 bytes 12288 blocks
+
+uid filter
+test.10m 10485760 bytes 32768 blocks
+test.falloc 6291456 bytes 16384 blocks
+test.fsgqa 6291456 bytes 12288 blocks
+test.fsgqa.root 6291456 bytes 12288 blocks
+test.prid.42 6291456 bytes 16384 blocks
+
+uid/gid filter
+test.10m 10485760 bytes 32768 blocks
+test.falloc 6291456 bytes 16384 blocks
+test.fsgqa 6291456 bytes 12288 blocks
+test.fsgqa.root 6291456 bytes 16384 blocks
+test.prid.42 6291456 bytes 16384 blocks
+
+===================
+background speculative preallocation trim
+
+background scan
+test.10m 10485760 bytes 20480 blocks
+test.falloc 6291456 bytes 16384 blocks
+test.fsgqa 6291456 bytes 12288 blocks
+test.fsgqa.root 6291456 bytes 12288 blocks
+test.prid.42 6291456 bytes 12288 blocks
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
index a846b60..675d5b5 100644
--- a/group
+++ b/group
@@ -408,3 +408,4 @@ deprecated
 287 auto dump quota quick
 288 auto quick ioctl trim
 289 auto quick
+290 auto quick
-- 
1.7.7.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
