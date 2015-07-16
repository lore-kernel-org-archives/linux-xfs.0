Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 070307F8B
	for <xfs@oss.sgi.com>; Thu, 16 Jul 2015 11:03:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E653D304039
	for <xfs@oss.sgi.com>; Thu, 16 Jul 2015 09:03:20 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 3oBxdTLSwj2oekgX for <xfs@oss.sgi.com>;
	Thu, 16 Jul 2015 09:03:11 -0700 (PDT)
Message-ID: <55A7D5BD.7050805@sandeen.net>
Date: Thu, 16 Jul 2015 11:03:09 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: PATCH 3/3 V6] xfs: test changing UUID on V5 superblock
References: <55A7D414.2050606@sandeen.net>
In-Reply-To: <55A7D414.2050606@sandeen.net>
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
To: xfs-oss <xfs@oss.sgi.com>, "fstests@vger.kernel.org" <fstests@vger.kernel.org>

Tests xfs_db's ability to change & restore UUIDs on V5 filesystems,
and tests xfs_copy's ability to change the UUID on the copy.

Update to _filter_uuid is so that it will catch the UUID output
from xfs_admin -u, which is slightly different than the regexp it
was expecting.

This requires new userspace which knows how to change the UUID on
a V5 superblock.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

V6: Take into account Brian's prior review.

diff --git a/common/filter b/common/filter
index 05dbae6..8db1b3e 100644
--- a/common/filter
+++ b/common/filter
@@ -275,9 +275,9 @@ _filter_uuid()
 {
 	if [ ! -z $1 ]; then
 		UUID=$1
-		sed -e "s/\(uuid:\) $UUID/\1 <EXACTUUID>/i"
+		sed -e "s/\(uuid[ :=]\+\) $UUID/\1 <EXACTUUID>/i"
 	else
-		sed -e "s/\(uuid:\) *[0-9a-f-][0-9a-f-]*/\1 <UUID>/i"
+		sed -e "s/\(uuid[ :=]\+\) *[0-9a-f-][0-9a-f-]*/\1 <UUID>/ig"
 	fi
 }
 
diff --git a/common/rc b/common/rc
index 610045e..00b529b 100644
--- a/common/rc
+++ b/common/rc
@@ -2702,6 +2702,21 @@ _require_test_fcntl_advisory_locks()
 		_notrun "Require fcntl advisory locks support"
 }
 
+# XFS ability to change UUIDs on V5/CRC filesystems
+#
+_require_meta_uuid()
+{
+	# This will create a crc fs on $SCRATCH_DEV
+	_require_xfs_crc
+
+	$XFS_DB_PROG -x -c "uuid generate" $SCRATCH_DEV >/dev/null 2>&1 \
+	   || _notrun "Userspace doesn't support meta_uuid feature"
+
+	_scratch_mount >/dev/null 2>&1 \
+	   || _notrun "Kernel doesn't support meta_uuid feature"
+	umount $SCRATCH_MNT
+}
+
 _get_total_inode()
 {
 	if [ -z "$1" ]; then
diff --git a/tests/xfs/074 b/tests/xfs/074
new file mode 100755
index 0000000..2592e89
--- /dev/null
+++ b/tests/xfs/074
@@ -0,0 +1,143 @@
+#! /bin/bash
+# FS QA Test 074
+#
+# test UUID modification of CRC-enabled filesystems
+#
+# CRC-enabled / V5 superblock filesystems have a UUID stamped into
+# every piece of metadata, and a mechanism was added later to allow
+# changing the user-visible UUID by copying the original UUID (which
+# matches all the existing metadata) to a new superblock location.
+# Exercise some of that behavior.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2015 Red Hat, Inc.  All Rights Reserved.
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
+	cd /
+	rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+
+_supported_fs xfs
+_supported_os Linux
+_require_scratch
+_require_xfs_crc
+_require_meta_uuid
+
+# Takes 2 args, 2nd optional:
+#  1: generate, rewrite, or restore
+#  2: Expected UUID after the action.  Blank if new uuid generated
+# After the action check the fs, and make sure it can be mounted
+# Sets NEW_UUID to the resulting UUID.
+_test_uuid()
+{
+	ACTION=$1
+	EXPECTED_UUID=$2
+
+	$XFS_DB_PROG -x -c "uuid $ACTION" $SCRATCH_DEV \
+					| _filter_uuid $EXPECTED_UUID
+	NEW_UUID=`$XFS_DB_PROG -c "uuid"  $SCRATCH_DEV | awk '{print $NF}'`
+	_check_scratch_fs
+	_scratch_mount || _fail "Mount failed after UUID $ACTION"
+	_scratch_unmount
+
+}
+
+_fs_has_META_UUID()
+{
+	FS=$1
+	$XFS_DB_PROG -r -c version $FS | grep -q META_UUID
+}
+
+rm -f $seqres.full
+
+_scratch_mkfs_xfs -m crc=1 >> $seqres.full 2>&1 || _fail "mkfs failed"
+
+ORIG_UUID=`$XFS_DB_PROG -c "uuid" $SCRATCH_DEV | awk '{print $NF}'`
+
+_scratch_mount
+# Put some stuff on the fs
+$FSSTRESS_PROG -d $SCRATCH_MNT -n 100 -p 4 >> $seqres.full 2>&1
+_scratch_unmount
+
+# Can xfs_db change it?
+
+echo "== Generate new UUID"
+_test_uuid generate
+[ "$NEW_UUID" == "$ORIG_UUID" ] && _fail "Failed to change UUID"
+_fs_has_META_UUID $SCRATCH_DEV || _fail "META_UUID feature not set"
+
+# This should be a no-op
+echo "== Rewrite UUID"
+_test_uuid rewrite $NEW_UUID
+_fs_has_META_UUID $SCRATCH_DEV || _fail "META_UUID feature not set"
+
+# Can we change it back?
+echo "== Restore old UUID"
+_test_uuid restore $ORIG_UUID
+[ "$NEW_UUID" != "$ORIG_UUID" ] && _fail "Failed to restore UUID"
+_fs_has_META_UUID $SCRATCH_DEV && _fail "META_UUID feature should not be not set"
+
+# This should be a no-op too.
+echo "== Rewrite UUID"
+_test_uuid rewrite $ORIG_UUID
+_fs_has_META_UUID $SCRATCH_DEV && _fail "META_UUID feature should not be not set"
+
+# Ok, now what does xfs_copy do; it changes UUID by default
+
+IMGFILE=$TEST_DIR/$seq.copy.img
+rm -f $IMGFILE
+
+# xfs_copy changes the UUID by default
+echo "== xfs_copy with new UUID"
+$XFS_COPY_PROG $SCRATCH_DEV $IMGFILE 2>&1 >> $seqres.full || \
+	_fail "xfs_copy (new UUID) failed"
+_check_xfs_filesystem $IMGFILE none none || _fail "Copy looks corrupted"
+# The copy should have META_UUID feature set
+_fs_has_META_UUID $IMGFILE || _fail "META_UUID feature not set on copy"
+_scratch_mount || _fail "Mount failed after UUID rewrite"
+_scratch_unmount
+
+rm -f $IMGFILE
+
+# duplicating the UUID should be fine too
+echo "== xfs_copy with duplicate UUID"
+$XFS_COPY_PROG -d $SCRATCH_DEV $IMGFILE 2>&1 >> $seqres.full || \
+	_fail "xfs_copy (duplicate) failed"
+_check_xfs_filesystem $IMGFILE none none || _fail "Duplicate copy looks corrupted"
+# The copy should not have META_UUID feature set
+_fs_has_META_UUID $IMGFILE && _fail "META_UUID feature should not be set on copy"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/074.out b/tests/xfs/074.out
new file mode 100644
index 0000000..b511107
--- /dev/null
+++ b/tests/xfs/074.out
@@ -0,0 +1,21 @@
+QA output created by 074
+== Generate new UUID
+Clearing log and setting UUID
+writing all SBs
+new UUID =  <UUID>
+== Rewrite UUID
+old UUID = <EXACTUUID>
+Clearing log and setting UUID
+writing all SBs
+new UUID = <EXACTUUID>
+== Restore old UUID
+Clearing log and setting UUID
+writing all SBs
+new UUID = <EXACTUUID>
+== Rewrite UUID
+old UUID = <EXACTUUID>
+Clearing log and setting UUID
+writing all SBs
+new UUID = <EXACTUUID>
+== xfs_copy with new UUID
+== xfs_copy with duplicate UUID
diff --git a/tests/xfs/group b/tests/xfs/group
index 848a1bd..a66869a 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -71,6 +71,7 @@
 071 rw auto
 072 rw auto prealloc quick
 073 copy auto
+074 auto quick copy
 078 growfs auto quick
 080 rw ioctl
 081 deprecated # log logprint quota

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
