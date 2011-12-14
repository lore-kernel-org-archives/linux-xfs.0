Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBFCvdTl005504 for <xfs@oss.sgi.com>; Thu, 15 Dec 2011 06:57:40 -0600
Received: from andromeda.usersys.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1B9282C4C2E
	for <xfs@oss.sgi.com>; Thu, 15 Dec 2011 04:57:38 -0800 (PST)
Received: from andromeda.usersys.redhat.com
	(189-039-034-231.static.spo.ctbc.com.br [189.39.34.231]) by
	cuda.sgi.com with ESMTP id c3Il4sFWhDeqJJ4F for
	<xfs@oss.sgi.com>; Thu, 15 Dec 2011 04:57:38 -0800 (PST)
From: cmaiolino@redhat.com
Subject: [PATCH] xfstests 276: Ensure lost+found is not created with wrong
	link count (V2)
Date: Wed, 14 Dec 2011 16:33:34 -0200
Message-Id: <1323887614-21290-1-git-send-email-cmaiolino@redhat.com>
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
Cc: Carlos Maiolino <cmaiolino@redhat.com>

From: Carlos Maiolino <cmaiolino@redhat.com>

xfs_repair was leaving lost+found directory with a wrong link count when a
cleaned inode was re-used to create lost+found. This test case confirm that,
after xfs_repair is executed, the lost+found inode is left in a consistent
state.

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 276   |   87 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 group |    1 +
 2 files changed, 88 insertions(+), 0 deletions(-)
 create mode 100755 276

diff --git a/276 b/276
new file mode 100755
index 0000000..f7b6bb5
--- /dev/null
+++ b/276
@@ -0,0 +1,87 @@
+#! /bin/bash
+# FS QA Test No. 276
+#
+# Test xfs_repair to ensure it fixes the lost+found link count
+# at the first run. See also commit 198b747f255346bca64408875763b6ca0ed3d57d
+# from xfsprogs tree.
+# 
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2011 Red Hat, Inc.  All Rights Reserved.
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
+# creator
+owner=cmaiolino@redhat.com
+
+seq=`basename $0`
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
+. ./common.rc
+. ./common.filter
+
+# real QA test starts here
+_supported_fs xfs 
+_supported_os Linux
+_require_scratch
+_scratch_mkfs >/dev/null 2>&1
+_scratch_mount
+
+mkdir -p $SCRATCH_MNT/dir/subdir
+
+#get inodes to be changed
+DIR_INO=`ls -i $SCRATCH_MNT |awk '{print $1}'`
+SUBDIR_INO=`ls -i $SCRATCH_MNT/dir |awk '{print $1}'`
+
+_scratch_unmount
+
+echo "Silence is goodness..."
+
+# Corrupt DIR
+xfs_db -x -c "inode $DIR_INO" -c "write u.sfdir2.list[0].inumber.i4 0" $SCRATCH_DEV >> $seq.full
+xfs_db -x -c "inode $DIR_INO" -c "write u.sfdir2.list[0].name 0" $SCRATCH_DEV >> $seq.full
+xfs_db -x -c "inode $DIR_INO" -c "write u.sfdir2.list[0].offset 0" $SCRATCH_DEV >> $seq.full
+xfs_db -x -c "inode $DIR_INO" -c "write u.sfdir2.list[0].namelen 0" $SCRATCH_DEV >> $seq.full
+xfs_db -x -c "inode $DIR_INO" -c "write u.sfdir2.hdr.parent.i4 0" $SCRATCH_DEV >> $seq.full
+xfs_db -x -c "inode $DIR_INO" -c "write core.nlinkv2 0" $SCRATCH_DEV >> $seq.full
+
+# Corrupt SUBDIR
+xfs_db -x -c "inode $SUBDIR_INO" -c "write u.sfdir2.hdr.parent.i4 0" $SCRATCH_DEV >> $seq.full
+xfs_db -x -c "inode $SUBDIR_INO" -c "write core.nlinkv2 0" $SCRATCH_DEV >> $seq.full
+
+echo "===== BEGIN of xfs_repair =====" >> $seq.full
+echo "" >>$seq.full
+
+xfs_repair  $SCRATCH_DEV &>> $seq.full
+echo "===== END of xfs_repair =====" >> $seq.full
+
+if _check_scratch_fs; then
+	status=0
+else
+	status=1
+fi
+exit
diff --git a/group b/group
index 08d999a..8693d19 100644
--- a/group
+++ b/group
@@ -389,3 +389,4 @@ deprecated
 273 auto rw
 274 auto rw
 275 auto rw
+276 repair auto
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
