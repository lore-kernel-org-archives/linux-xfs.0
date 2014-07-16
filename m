Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 21B527F51
	for <xfs@oss.sgi.com>; Wed, 16 Jul 2014 11:52:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 11D8430404E
	for <xfs@oss.sgi.com>; Wed, 16 Jul 2014 09:52:43 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id A5DfU61vWM8Ptv4z (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 16 Jul 2014 09:52:42 -0700 (PDT)
From: Eryu Guan <eguan@redhat.com>
Subject: [PATCH 1/2] xfs: new case to test inode allocations in post-growfs
	disk space
Date: Thu, 17 Jul 2014 00:52:33 +0800
Message-Id: <1405529554-31225-1-git-send-email-eguan@redhat.com>
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
To: fstests@vger.kernel.org
Cc: Eric Sandeen <esandeen@redhat.com>, Eryu Guan <eguan@redhat.com>, Boris Ranto <branto@redhat.com>, xfs@oss.sgi.com

Make sure inodes can be allocated in new space added by xfs_growfs.

Regression test for
xfs: allow inode allocations in post-growfs disk space

Cc: Eric Sandeen <esandeen@redhat.com>
Cc: Boris Ranto <branto@redhat.com>
Signed-off-by: Eryu Guan <eguan@redhat.com>
---
 common/rc         | 11 +++++++
 tests/xfs/015     | 99 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/015.out |  2 ++
 tests/xfs/group   |  1 +
 4 files changed, 113 insertions(+)
 create mode 100755 tests/xfs/015
 create mode 100644 tests/xfs/015.out

diff --git a/common/rc b/common/rc
index 2c83340..255dd9b 100644
--- a/common/rc
+++ b/common/rc
@@ -2225,6 +2225,17 @@ _require_btrfs_fs_feature()
 		_notrun "Feature $feat not supported by the available btrfs version"
 }
 
+_get_free_inode()
+{
+	if [ -z "$1" ]; then
+		echo "Usage: _get_free_inode <mnt>"
+		exit 1
+	fi
+	local nr_inode;
+	nr_inode=`$DF_PROG -i $1 | tail -1 | awk '{print $5}'`
+	echo $nr_inode
+}
+
 init_rc()
 {
 	if [ "$iam" == new ]
diff --git a/tests/xfs/015 b/tests/xfs/015
new file mode 100755
index 0000000..3db2e0b
--- /dev/null
+++ b/tests/xfs/015
@@ -0,0 +1,99 @@
+#! /bin/bash
+# FS QA Test No. xfs/015
+#
+# Make sure inodes can be allocated in new space added by xfs_growfs
+#
+# Regression test for
+# xfs: allow inode allocations in post-growfs disk space
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2014 Red Hat Inc.  All Rights Reserved.
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
+create_file()
+{
+	local dir=$1
+	local i=0
+
+	while echo -n >$dir/testfile_$i; do
+		let i=$i+1
+	done
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+_supported_fs xfs
+_supported_os Linux
+
+_require_scratch
+
+rm -f $seqres.full
+echo "Silence is golden"
+
+_scratch_mkfs_sized $((128 * 1024 * 1024)) | _filter_mkfs >$seqres.full 2>$tmp.mkfs
+# get original data blocks number
+. $tmp.mkfs
+_scratch_mount
+
+# Create files to consume free inodes in background
+(
+	i=0
+	while [ $i -lt 1000 ]; do
+		mkdir $SCRATCH_MNT/testdir_$i
+		create_file $SCRATCH_MNT/testdir_$i &
+		let i=$i+1
+	done
+) >/dev/null 2>&1 &
+
+# Grow fs at the same time, at least x4
+# doubling or tripling the size couldn't reproduce
+$XFS_GROWFS_PROG -D $((dblocks * 4)) $SCRATCH_MNT >>$seqres.full
+
+# Wait for background create_file to hit ENOSPC
+wait
+
+# log inode status in $seqres.full for debug purpose
+echo "Inode status after growing fs" >>$seqres.full
+$DF_PROG -i $SCRATCH_MNT >>$seqres.full
+
+# Check free inode count, we expect all free inodes are taken
+free_inode=`_get_free_inode $SCRATCH_MNT`
+if [ $free_inode -gt 0 ]; then
+	echo "$free_inode free inodes available, newly added space not being used"
+else
+	status=0
+fi
+
+exit
diff --git a/tests/xfs/015.out b/tests/xfs/015.out
new file mode 100644
index 0000000..fee0fcf
--- /dev/null
+++ b/tests/xfs/015.out
@@ -0,0 +1,2 @@
+QA output created by 015
+Silence is golden
diff --git a/tests/xfs/group b/tests/xfs/group
index d5b50b7..0aab336 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -12,6 +12,7 @@
 012 rw auto quick
 013 auto metadata stress
 014 auto enospc quick quota
+015 auto enospc growfs
 016 rw auto quick
 017 mount auto quick stress
 018 deprecated # log logprint v2log
-- 
1.9.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
