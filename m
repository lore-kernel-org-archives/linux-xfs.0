Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id AD8E47F37
	for <xfs@oss.sgi.com>; Thu, 13 Jun 2013 10:14:04 -0500 (CDT)
Received: from eagdhcp-232-136.americas.sgi.com
	(eagdhcp-232-136.americas.sgi.com [128.162.232.136])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7CDFF304043
	for <xfs@oss.sgi.com>; Thu, 13 Jun 2013 08:14:01 -0700 (PDT)
Received: from eagdhcp-232-136.americas.sgi.com (localhost [127.0.0.1])
	by eagdhcp-232-136.americas.sgi.com (8.14.5/8.14.5) with ESMTP id
	r5DFE20O002406
	for <xfs@oss.sgi.com>; Thu, 13 Jun 2013 10:14:02 -0500 (CDT)
	(envelope-from tinguely@sgi.com)
Message-Id: <20130613151037.271434256@sgi.com>
Date: Thu, 13 Jun 2013 10:10:08 -0500
From: Mark Tinguely <tinguely@sgi.com>
Subject: [PATCH] xfstest: ensure small symlink is removed
References: <20130613151007.449190598@sgi.com>
Content-Disposition: inline;
	filename=xfstests-small_remote_symlink_removal.patch
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

Tests that XFS symlinks that are small enough to be in the
inode, but were move to a remote symlink due to an extended
attribute were correctly removed.

Signed-off-by: Mark Tinguely <tinguely@sgi.com>
---
 new/xfstests/tests/xfs/298     |   92 +++++++++++++++++++++++++++++++++++++++++
 new/xfstests/tests/xfs/298.out |   33 ++++++++++++++
 new/xfstests/tests/xfs/group   |    1 
 3 files changed, 126 insertions(+)

Index: b/new/xfstests/tests/xfs/298
===================================================================
--- /dev/null
+++ b/new/xfstests/tests/xfs/298
@@ -0,0 +1,92 @@
+#! /bin/bash
+# FS QA Test No. 298
+#
+# Test that inline symlinks are removed from the inode when an extended
+# attributes forces it into being remote symlink.
+# Warning: this test will ASSERT on unpatched DEBUG XFS.
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
+
+# real QA test starts here
+
+# Modify as appropriate.
+_supported_fs xfs
+_supported_os Linux
+
+_require_scratch
+
+rm -f $seqres.full
+_scratch_mkfs_xfs >/dev/null 2>&1
+
+SYMLINK_FILE="$SCRATCH_MNT/symlink"
+SYMLINK=""
+SYMLINK_ADD="0123456789ABCDEF01234567890ABCDEF"
+
+# test 32 to 512 byte symlink. This should make sure that 256 and
+# 512 byte inodes version 2 and 3 are covered.
+LOOP=16
+SIZE=32
+while [ $LOOP -gt 0 ];do
+	_scratch_mount >/dev/null 2>&1
+	cd $SCRATCH_MNT
+	echo "Testing symlink size $SIZE"
+	SYMLINK="${SYMLINK}${SYMLINK_ADD}"
+	ln -s $SYMLINK $SYMLINK_FILE > /dev/null 2>&1
+
+	inode=`ls -li $SYMLINK_FILE | awk '{print $1}'`
+# add the extended attributes
+	attr  -Rs 1234567890ab $SYMLINK_FILE < /dev/null > /dev/null 2>&1
+	attr  -Rs 1234567890ac $SYMLINK_FILE < /dev/null > /dev/null 2>&1
+	attr  -Rs 1234567890ad $SYMLINK_FILE < /dev/null > /dev/null 2>&1
+# remove the extended attributes
+	attr  -Rr 1234567890ab $SYMLINK_FILE > /dev/null 2>&1
+	attr  -Rr 1234567890ac $SYMLINK_FILE > /dev/null 2>&1
+	attr  -Rr 1234567890ad $SYMLINK_FILE > /dev/null 2>&1
+# remove the symlink - make sure ifree removes the remote symlink.
+	rm $SYMLINK_FILE
+# umount and check the number of extents on the inode. Should be 0.
+	cd
+	_scratch_unmount >/dev/null 2>&1
+	$XFS_DB_PROG  -c "inode $inode" -c "p core.nextents" $SCRATCH_DEV
+
+	let LOOP=$LOOP-1
+	let SIZE=$SIZE+32
+done
+
+status=0
+exit
Index: b/new/xfstests/tests/xfs/298.out
===================================================================
--- /dev/null
+++ b/new/xfstests/tests/xfs/298.out
@@ -0,0 +1,33 @@
+QA output created by 298
+Testing symlink size 32
+core.nextents = 0
+Testing symlink size 64
+core.nextents = 0
+Testing symlink size 96
+core.nextents = 0
+Testing symlink size 128
+core.nextents = 0
+Testing symlink size 160
+core.nextents = 0
+Testing symlink size 192
+core.nextents = 0
+Testing symlink size 224
+core.nextents = 0
+Testing symlink size 256
+core.nextents = 0
+Testing symlink size 288
+core.nextents = 0
+Testing symlink size 320
+core.nextents = 0
+Testing symlink size 352
+core.nextents = 0
+Testing symlink size 384
+core.nextents = 0
+Testing symlink size 416
+core.nextents = 0
+Testing symlink size 448
+core.nextents = 0
+Testing symlink size 480
+core.nextents = 0
+Testing symlink size 512
+core.nextents = 0
Index: b/new/xfstests/tests/xfs/group
===================================================================
--- a/new/xfstests/tests/xfs/group
+++ b/new/xfstests/tests/xfs/group
@@ -177,3 +177,4 @@
 295 auto logprint quick
 296 dump auto quick
 297 auto freeze
+298 auto attr symlink


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
