Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:59318 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727157AbeIZQmo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Sep 2018 12:42:44 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w8QASOYq091206
        for <linux-xfs@vger.kernel.org>; Wed, 26 Sep 2018 10:30:22 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2120.oracle.com with ESMTP id 2mndpphhry-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 26 Sep 2018 10:30:22 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w8QAUGUm005889
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 26 Sep 2018 10:30:17 GMT
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w8QAUGQQ024880
        for <linux-xfs@vger.kernel.org>; Wed, 26 Sep 2018 10:30:16 GMT
From: Allison Henderson <allison.henderson@oracle.com>
Subject: [PATCH v2 1/1] xfstests: Add parent pointer test
Date: Wed, 26 Sep 2018 03:28:05 -0700
Message-Id: <1537957685-10753-2-git-send-email-allison.henderson@oracle.com>
In-Reply-To: <1537957685-10753-1-git-send-email-allison.henderson@oracle.com>
References: <1537957685-10753-1-git-send-email-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

This patch adds three new tests parent pointer operations.
The first test includes simple operations including link, unlink,
rename, and overwrite.  The second test exercises hardlinks and
muliple parent pointers.  The last test exercises the error inject
and recovery.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 common/parent     |  196 +++++++++++
 common/rc         |    3 +
 tests/xfs/491     |  156 +++++++++
 tests/xfs/491.out |   70 ++++
 tests/xfs/492     |  134 +++++++
 tests/xfs/492.out | 1009 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/493     |  143 ++++++++
 tests/xfs/493.out |   27 ++
 tests/xfs/group   |    4 +
 9 files changed, 1742 insertions(+)

diff --git a/common/parent b/common/parent
new file mode 100644
index 0000000..1c1295f
--- /dev/null
+++ b/common/parent
@@ -0,0 +1,196 @@
+#
+# Parent pointer common functions
+#
+
+#
+# parse_parent_pointer parents parent_inode parent_pointer_name
+#
+# Given a list of parent pointers, find the record that matches
+# the given inode and filename
+#
+# inputs:
+# parents	: A list of parent pointers in the format of:
+#		  inode/generation/name_length/name
+# parent_inode	: The parent inode to search for
+# parent_name	: The parent name to search for
+#
+# outputs:
+# PPINO         : Parent pointer inode
+# PPGEN         : Parent pointer generation
+# PPNAME        : Parent pointer name
+# PPNAME_LEN    : Parent pointer name length
+#
+_parse_parent_pointer()
+{
+	local parents=$1
+	local pino=$2
+	local parent_pointer_name=$3
+
+	local found=0
+
+	# Find the entry that has the same inode as the parent
+	# and parse out the entry info
+	while IFS=\/ read PPINO PPGEN PPNAME_LEN PPNAME; do
+		if [ "$PPINO" != "$pino" ]; then
+			continue
+		fi
+
+		if [ "$PPNAME" != "$parent_pointer_name" ]; then
+			continue
+		fi
+
+		found=1
+		break
+	done <<< $(echo "$parents")
+
+	# Check to see if we found anything
+	# We do not fail the test because we also use this
+	# routine to verify when parent pointers should
+	# be removed or updated  (ie a rename or a move
+	# operation changes your parent pointer)
+	if [ $found -eq "0" ]; then
+		return 1
+	fi
+
+	# Verify the parent pointer name length is correct
+	if [ "$PPNAME_LEN" -ne "${#parent_pointer_name}" ]
+	then
+		_fail "Bad parent pointer reclen"
+	fi
+
+	#return sucess
+	return 0
+}
+
+#
+# _verify_parent parent_path parent_pointer_name child_path
+#
+# Verify that the given child path lists the given parent as a parent pointer
+# and that the parent pointer name matches the given name
+#
+# Examples:
+#
+# #simple example
+# mkdir testfolder1
+# touch testfolder1/file1
+# verify_parent testfolder1 file1 testfolder1/file1
+#
+# # In this above example, we want to verify that "testfolder1"
+# # appears as a parent pointer of "testfolder1/file1".  Additionally
+# # we verify that the name record of the parent pointer is "file1"
+#
+#
+# #hardlink example
+# mkdir testfolder1
+# mkdir testfolder2
+# touch testfolder1/file1
+# ln testfolder1/file1 testfolder2/file1_ln
+# verify_parent testfolder2 file1_ln testfolder1/file1
+#
+# # In this above example, we want to verify that "testfolder2"
+# # appears as a parent pointer of "testfolder1/file1".  Additionally
+# # we verify that the name record of the parent pointer is "file1_ln"
+#
+_verify_parent()
+{
+
+	local parent_path=$1
+	local parent_pointer_name=$2
+	local child_path=$3
+
+	local parent_ppath="$parent_path/$parent_pointer_name"
+
+	# Verify parent exists
+	if [ ! -d $SCRATCH_MNT/$parent_path ]; then
+		_fail "$SCRATCH_MNT/$parent_path not found"
+	else
+		echo "*** $parent_path OK"
+	fi
+
+	# Verify child exists
+	if [ ! -f $SCRATCH_MNT/$child_path ]; then
+		_fail "$SCRATCH_MNT/$child_path not found"
+	else
+		echo "*** $child_path OK"
+	fi
+
+	# Verify the parent pointer name exists as a child of the parent
+	if [ ! -f $SCRATCH_MNT/$parent_ppath ]; then
+		_fail "$SCRATCH_MNT/$parent_ppath not found"
+	else
+		echo "*** $parent_ppath OK"
+	fi
+
+	# Get the inodes of both parent and child
+	pino="$(stat -c '%i' $SCRATCH_MNT/$parent_path)"
+	cino="$(stat -c '%i' $SCRATCH_MNT/$child_path)"
+
+	# Get all the parent pointers of the child
+	parents=($($XFS_IO_PROG -x -c "parent -f -i $pino -n $parent_pointer_name" $SCRATCH_MNT/$child_path))
+	if [[ $? != 0 ]]; then
+		 _fail "No parent pointers found for $child_path"
+	fi
+
+	# Parse parent pointer output.
+	# This sets PPINO PPGEN PPNAME PPNAME_LEN
+	_parse_parent_pointer $parents $pino $parent_pointer_name
+
+	# If we didnt find one, bail out
+	if [ $? -ne 0 ]; then
+		_fail "No parent pointer record found for $parent_path in $child_path"
+	fi
+
+	# Verify the inode generated by the parent pointer name is
+	# the same as the child inode
+	pppino="$(stat -c '%i' $SCRATCH_MNT/$parent_ppath)"
+	if [ $cino -ne $pppino ]
+	then
+		_fail "Bad parent pointer name value for $child_path."\
+				"$SCRATCH_MNT/$parent_ppath belongs to inode $PPPINO, but should be $cino"
+	fi
+
+	echo "*** Verified parent pointer:"\
+			"inode:$PPINO, name:$PPNAME, namelen:$PPNAME_LEN"
+	echo "*** Parent pointer OK for child $child_path inode:$cino"
+}
+
+#
+# _verify_parent parent_pointer_name pino child_path
+#
+# Verify that the given child path contains no parent pointer entry
+# for the given inode and file name
+#
+_verify_no_parent()
+{
+
+	local parent_pname=$1
+	local pino=$2
+	local child_path=$3
+
+	# Verify child exists
+	if [ ! -f $SCRATCH_MNT/$child_path ]; then
+		_fail "$SCRATCH_MNT/$child_path not found"
+	else
+		echo "*** $child_path OK"
+	fi
+
+	# Get all the parent pointers of the child
+	local parents=($($XFS_IO_PROG -x -c "parent -f -i $pino -n $parent_pname" $SCRATCH_MNT/$child_path))
+	if [[ $? != 0 ]]; then
+		return 0
+	fi
+
+	# Parse parent pointer output.
+	# This sets PPINO PPGEN PPNAME PPNAME_LEN
+	_parse_parent_pointer $parents $pino $parent_pname
+
+	# If we didnt find one, return sucess
+	if [ $? -ne 0 ]; then
+		return 0
+	fi
+
+	_fail "Parent pointer entry found where none should:"\
+			"inode:$PPINO, gen:$PPGEN,"
+			"name:$PPNAME, namelen:$PPNAME_LEN"
+}
+
diff --git a/common/rc b/common/rc
index 5090a74..f7849ef 100644
--- a/common/rc
+++ b/common/rc
@@ -2125,6 +2125,9 @@ _require_xfs_io_command()
 		echo $testio | grep -q "invalid option" && \
 			_notrun "xfs_io $command support is missing"
 		;;
+	"parent")
+		testio=`$XFS_IO_PROG -x -c "parent" $TEST_DIR 2>&1`
+		;;
 	"pwrite")
 		# -N (RWF_NOWAIT) only works with direct vectored I/O writes
 		local pwrite_opts=" "
diff --git a/tests/xfs/491 b/tests/xfs/491
new file mode 100755
index 0000000..308cf71
--- /dev/null
+++ b/tests/xfs/491
@@ -0,0 +1,156 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2018, Oracle and/or its affiliates.  All Rights Reserved.
+#
+# FS QA Test No. 491
+#
+# simple parent pointer test
+#
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+seqfull="$seqres.full"
+status=1	# failure is the default!
+trap "cleanup; exit \$status" 0 1 2 3 15
+
+cleanup()
+{
+	cd /
+	rm -f $tmp.*
+}
+
+filter_dbval()
+{
+	awk '{ print $4 }'
+}
+
+full()
+{
+    echo ""            >>$seqfull
+    echo "*** $* ***"  >>$seqfull
+    echo ""            >>$seqfull
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/reflink
+. ./common/inject
+. ./common/parent
+
+# remove previous $seqres.full before test
+rm -f $seqres.full
+
+# Modify as appropriate
+_supported_os Linux
+_supported_fs xfs
+_require_scratch
+_require_xfs_io_error_injection "delayed_attr"
+
+# real QA test starts here
+
+# Create a directory tree using a protofile and
+# make sure all inodes created have parent pointers
+
+protofile=$tmp.proto
+
+cat >$protofile <<EOF
+DUMMY1
+0 0
+: root directory
+d--777 3 1
+: a directory
+testfolder1 d--755 3 1
+file1 ---755 3 1 /dev/null
+$
+: back in the root
+testfolder2 d--755 3 1
+file2 ---755 3 1 /dev/null
+: done
+$
+EOF
+
+if [ $? -ne 0 ]
+then
+    _fail "failed to create test protofile"
+fi
+
+echo "*** create FS"
+
+rm -f $seqfull
+_scratch_unmount >/dev/null 2>&1
+
+_scratch_mkfs_xfs -f -n parent=1 -p $protofile >>$seqfull 2>&1 \
+	|| _fail "mkfs failed"
+echo "*** check FS"
+_check_scratch_fs
+
+echo "*** mount FS"
+full " mount"
+_scratch_mount >>$seqfull 2>&1 \
+	|| _fail "mount failed"
+
+testfolder1="testfolder1"
+testfolder2="testfolder2"
+file1="file1"
+file2="file2"
+file3="file3"
+file4="file4"
+file5="file5"
+file1_ln="file1_link"
+
+echo ""
+echo "Create parent pointer test"
+_verify_parent "$testfolder1" "$file1" "$testfolder1/$file1"
+
+echo ""
+echo "Move parent pointer test"
+mv $SCRATCH_MNT/$testfolder1/$file1 $SCRATCH_MNT/$testfolder2/$file1
+_verify_parent "$testfolder2" "$file1" "$testfolder2/$file1"
+
+echo ""
+echo "Hard link parent pointer test"
+ln $SCRATCH_MNT/$testfolder2/$file1 $SCRATCH_MNT/$testfolder1/$file1_ln
+_verify_parent "$testfolder1" "$file1_ln"  "$testfolder1/$file1_ln"
+_verify_parent "$testfolder1" "$file1_ln"  "$testfolder2/$file1"
+_verify_parent "$testfolder2" "$file1"     "$testfolder1/$file1_ln"
+_verify_parent "$testfolder2" "$file1"     "$testfolder2/$file1"
+
+echo ""
+echo "Remove hard link parent pointer test"
+ino="$(stat -c '%i' $SCRATCH_MNT/$testfolder2/$file1)"
+rm $SCRATCH_MNT/$testfolder2/$file1
+_verify_parent    "$testfolder1" "$file1_ln" "$testfolder1/$file1_ln"
+_verify_no_parent "$file1" "$ino" "$testfolder1/$file1_ln"
+
+echo ""
+echo "Rename parent pointer test"
+ino="$(stat -c '%i' $SCRATCH_MNT/$testfolder1/$file1_ln)"
+mv $SCRATCH_MNT/$testfolder1/$file1_ln $SCRATCH_MNT/$testfolder1/$file2
+_verify_parent    "$testfolder1" "$file2"    "$testfolder1/$file2"
+_verify_no_parent "$file1_ln" "$ino" "$testfolder1/$file2"
+
+echo ""
+echo "Over write parent pointer test"
+touch $SCRATCH_MNT/$testfolder2/$file3
+_verify_parent    "$testfolder2" "$file3"    "$testfolder2/$file3"
+ino="$(stat -c '%i' $SCRATCH_MNT/$testfolder2/$file3)"
+mv -f $SCRATCH_MNT/$testfolder2/$file3 $SCRATCH_MNT/$testfolder1/$file2
+_verify_parent    "$testfolder1" "$file2"    "$testfolder1/$file2"
+
+echo "*** unmount FS"
+full "umount"
+_scratch_unmount >>$seqfull 2>&1 \
+        || _fail "umount failed"
+
+echo "*** done"
+rm $seqfull
+status=0
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/491.out b/tests/xfs/491.out
new file mode 100644
index 0000000..f34e4e3
--- /dev/null
+++ b/tests/xfs/491.out
@@ -0,0 +1,70 @@
+QA output created by 491
+*** create FS
+*** check FS
+*** mount FS
+
+Create parent pointer test
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: inode:16777344, name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1 inode:16777345
+
+Move parent pointer test
+*** testfolder2 OK
+*** testfolder2/file1 OK
+*** testfolder2/file1 OK
+*** Verified parent pointer: inode:33613312, name:file1, namelen:5
+*** Parent pointer OK for child testfolder2/file1 inode:16777345
+
+Hard link parent pointer test
+*** testfolder1 OK
+*** testfolder1/file1_link OK
+*** testfolder1/file1_link OK
+*** Verified parent pointer: inode:16777344, name:file1_link, namelen:10
+*** Parent pointer OK for child testfolder1/file1_link inode:16777345
+*** testfolder1 OK
+*** testfolder2/file1 OK
+*** testfolder1/file1_link OK
+*** Verified parent pointer: inode:16777344, name:file1_link, namelen:10
+*** Parent pointer OK for child testfolder2/file1 inode:16777345
+*** testfolder2 OK
+*** testfolder1/file1_link OK
+*** testfolder2/file1 OK
+*** Verified parent pointer: inode:33613312, name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link inode:16777345
+*** testfolder2 OK
+*** testfolder2/file1 OK
+*** testfolder2/file1 OK
+*** Verified parent pointer: inode:33613312, name:file1, namelen:5
+*** Parent pointer OK for child testfolder2/file1 inode:16777345
+
+Remove hard link parent pointer test
+*** testfolder1 OK
+*** testfolder1/file1_link OK
+*** testfolder1/file1_link OK
+*** Verified parent pointer: inode:16777344, name:file1_link, namelen:10
+*** Parent pointer OK for child testfolder1/file1_link inode:16777345
+*** testfolder1/file1_link OK
+
+Rename parent pointer test
+*** testfolder1 OK
+*** testfolder1/file2 OK
+*** testfolder1/file2 OK
+*** Verified parent pointer: inode:16777344, name:file2, namelen:5
+*** Parent pointer OK for child testfolder1/file2 inode:16777345
+*** testfolder1/file2 OK
+
+Over write parent pointer test
+*** testfolder2 OK
+*** testfolder2/file3 OK
+*** testfolder2/file3 OK
+*** Verified parent pointer: inode:33613312, name:file3, namelen:5
+*** Parent pointer OK for child testfolder2/file3 inode:33613314
+*** testfolder1 OK
+*** testfolder1/file2 OK
+*** testfolder1/file2 OK
+*** Verified parent pointer: inode:16777344, name:file2, namelen:5
+*** Parent pointer OK for child testfolder1/file2 inode:33613314
+*** unmount FS
+*** done
diff --git a/tests/xfs/492 b/tests/xfs/492
new file mode 100755
index 0000000..514b009
--- /dev/null
+++ b/tests/xfs/492
@@ -0,0 +1,134 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2018, Oracle and/or its affiliates.  All Rights Reserved.
+#
+# FS QA Test No. 492
+#
+# multi link parent pointer test
+#
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+seqfull="$seqres.full"
+status=1	# failure is the default!
+trap "cleanup; exit \$status" 0 1 2 3 15
+
+cleanup()
+{
+	cd /
+	rm -f $tmp.*
+}
+
+filter_dbval()
+{
+	awk '{ print $4 }'
+}
+
+full()
+{
+    echo ""            >>$seqfull
+    echo "*** $* ***"  >>$seqfull
+    echo ""            >>$seqfull
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/reflink
+. ./common/inject
+. ./common/parent
+
+# remove previous $seqres.full before test
+rm -f $seqres.full
+
+# Modify as appropriate
+_supported_os Linux
+_supported_fs xfs
+_require_scratch
+_require_xfs_io_error_injection "delayed_attr"
+
+# real QA test starts here
+
+# Create a directory tree using a protofile and
+# make sure all inodes created have parent pointers
+
+protofile=$tmp.proto
+
+cat >$protofile <<EOF
+DUMMY1
+0 0
+: root directory
+d--777 3 1
+: a directory
+testfolder1 d--755 3 1
+file1 ---755 3 1 /dev/null
+$
+: back in the root
+testfolder2 d--755 3 1
+file2 ---755 3 1 /dev/null
+: done
+$
+EOF
+
+if [ $? -ne 0 ]
+then
+    _fail "failed to create test protofile"
+fi
+
+echo "*** create FS"
+
+rm -f $seqfull
+_scratch_unmount >/dev/null 2>&1
+
+_scratch_mkfs_xfs -f -n parent=1 -p $protofile >>$seqfull 2>&1 \
+	|| _fail "mkfs failed"
+echo "*** check FS"
+_check_scratch_fs
+
+echo "*** mount FS"
+full " mount"
+_scratch_mount >>$seqfull 2>&1 \
+	|| _fail "mount failed"
+
+testfolder1="testfolder1"
+testfolder2="testfolder2"
+file1="file1"
+file2="file2"
+file3="file3"
+file4="file4"
+file5="file5"
+file1_ln="file1_link"
+
+echo ""
+echo "Multi link parent pointer test"
+NLINKS=100
+touch $SCRATCH_MNT/$testfolder1/$file1
+for (( j=0; j<$NLINKS; j++ )); do
+	ln $SCRATCH_MNT/$testfolder1/$file1 $SCRATCH_MNT/$testfolder1/$file1_ln.$j
+	_verify_parent    "$testfolder1" "$file1_ln.$j"    "$testfolder1/$file1"
+	_verify_parent    "$testfolder1" "$file1"          "$testfolder1/$file1_ln.$j"
+done
+echo "Multi unlink parent pointer test"
+for (( j=$NLINKS-1; j<=0; j-- )); do
+	ino="$(stat -c '%i' $SCRATCH_MNT/$testfolder1/$file1_ln.$j)"
+	rm $SCRATCH_MNT/$testfolder1/$file1_ln.$j
+	_verify_no_parent "$file1_ln.$j" "$ino" "$testfolder1/$file1"
+done
+
+echo "*** unmount FS"
+full "umount"
+_scratch_unmount >>$seqfull 2>&1 \
+	|| _fail "umount failed"
+
+
+echo "*** done"
+rm $seqfull
+status=0
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/492.out b/tests/xfs/492.out
new file mode 100644
index 0000000..ba4c675
--- /dev/null
+++ b/tests/xfs/492.out
@@ -0,0 +1,1009 @@
+QA output created by 492
+*** create FS
+*** check FS
+*** mount FS
+
+Multi link parent pointer test
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.0 OK
+*** Verified parent pointer: inode:16777344, name:file1_link.0, namelen:12
+*** Parent pointer OK for child testfolder1/file1 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1_link.0 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: inode:16777344, name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.0 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.1 OK
+*** Verified parent pointer: inode:16777344, name:file1_link.1, namelen:12
+*** Parent pointer OK for child testfolder1/file1 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1_link.1 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: inode:16777344, name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.1 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.2 OK
+*** Verified parent pointer: inode:16777344, name:file1_link.2, namelen:12
+*** Parent pointer OK for child testfolder1/file1 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1_link.2 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: inode:16777344, name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.2 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.3 OK
+*** Verified parent pointer: inode:16777344, name:file1_link.3, namelen:12
+*** Parent pointer OK for child testfolder1/file1 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1_link.3 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: inode:16777344, name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.3 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.4 OK
+*** Verified parent pointer: inode:16777344, name:file1_link.4, namelen:12
+*** Parent pointer OK for child testfolder1/file1 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1_link.4 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: inode:16777344, name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.4 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.5 OK
+*** Verified parent pointer: inode:16777344, name:file1_link.5, namelen:12
+*** Parent pointer OK for child testfolder1/file1 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1_link.5 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: inode:16777344, name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.5 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.6 OK
+*** Verified parent pointer: inode:16777344, name:file1_link.6, namelen:12
+*** Parent pointer OK for child testfolder1/file1 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1_link.6 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: inode:16777344, name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.6 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.7 OK
+*** Verified parent pointer: inode:16777344, name:file1_link.7, namelen:12
+*** Parent pointer OK for child testfolder1/file1 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1_link.7 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: inode:16777344, name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.7 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.8 OK
+*** Verified parent pointer: inode:16777344, name:file1_link.8, namelen:12
+*** Parent pointer OK for child testfolder1/file1 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1_link.8 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: inode:16777344, name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.8 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.9 OK
+*** Verified parent pointer: inode:16777344, name:file1_link.9, namelen:12
+*** Parent pointer OK for child testfolder1/file1 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1_link.9 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: inode:16777344, name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.9 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.10 OK
+*** Verified parent pointer: inode:16777344, name:file1_link.10, namelen:13
+*** Parent pointer OK for child testfolder1/file1 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1_link.10 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: inode:16777344, name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.10 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.11 OK
+*** Verified parent pointer: inode:16777344, name:file1_link.11, namelen:13
+*** Parent pointer OK for child testfolder1/file1 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1_link.11 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: inode:16777344, name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.11 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.12 OK
+*** Verified parent pointer: inode:16777344, name:file1_link.12, namelen:13
+*** Parent pointer OK for child testfolder1/file1 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1_link.12 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: inode:16777344, name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.12 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.13 OK
+*** Verified parent pointer: inode:16777344, name:file1_link.13, namelen:13
+*** Parent pointer OK for child testfolder1/file1 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1_link.13 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: inode:16777344, name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.13 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.14 OK
+*** Verified parent pointer: inode:16777344, name:file1_link.14, namelen:13
+*** Parent pointer OK for child testfolder1/file1 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1_link.14 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: inode:16777344, name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.14 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.15 OK
+*** Verified parent pointer: inode:16777344, name:file1_link.15, namelen:13
+*** Parent pointer OK for child testfolder1/file1 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1_link.15 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: inode:16777344, name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.15 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.16 OK
+*** Verified parent pointer: inode:16777344, name:file1_link.16, namelen:13
+*** Parent pointer OK for child testfolder1/file1 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1_link.16 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: inode:16777344, name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.16 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.17 OK
+*** Verified parent pointer: inode:16777344, name:file1_link.17, namelen:13
+*** Parent pointer OK for child testfolder1/file1 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1_link.17 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: inode:16777344, name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.17 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.18 OK
+*** Verified parent pointer: inode:16777344, name:file1_link.18, namelen:13
+*** Parent pointer OK for child testfolder1/file1 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1_link.18 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: inode:16777344, name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.18 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.19 OK
+*** Verified parent pointer: inode:16777344, name:file1_link.19, namelen:13
+*** Parent pointer OK for child testfolder1/file1 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1_link.19 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: inode:16777344, name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.19 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.20 OK
+*** Verified parent pointer: inode:16777344, name:file1_link.20, namelen:13
+*** Parent pointer OK for child testfolder1/file1 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1_link.20 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: inode:16777344, name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.20 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.21 OK
+*** Verified parent pointer: inode:16777344, name:file1_link.21, namelen:13
+*** Parent pointer OK for child testfolder1/file1 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1_link.21 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: inode:16777344, name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.21 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.22 OK
+*** Verified parent pointer: inode:16777344, name:file1_link.22, namelen:13
+*** Parent pointer OK for child testfolder1/file1 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1_link.22 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: inode:16777344, name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.22 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.23 OK
+*** Verified parent pointer: inode:16777344, name:file1_link.23, namelen:13
+*** Parent pointer OK for child testfolder1/file1 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1_link.23 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: inode:16777344, name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.23 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.24 OK
+*** Verified parent pointer: inode:16777344, name:file1_link.24, namelen:13
+*** Parent pointer OK for child testfolder1/file1 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1_link.24 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: inode:16777344, name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.24 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.25 OK
+*** Verified parent pointer: inode:16777344, name:file1_link.25, namelen:13
+*** Parent pointer OK for child testfolder1/file1 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1_link.25 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: inode:16777344, name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.25 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.26 OK
+*** Verified parent pointer: inode:16777344, name:file1_link.26, namelen:13
+*** Parent pointer OK for child testfolder1/file1 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1_link.26 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: inode:16777344, name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.26 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.27 OK
+*** Verified parent pointer: inode:16777344, name:file1_link.27, namelen:13
+*** Parent pointer OK for child testfolder1/file1 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1_link.27 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: inode:16777344, name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.27 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.28 OK
+*** Verified parent pointer: inode:16777344, name:file1_link.28, namelen:13
+*** Parent pointer OK for child testfolder1/file1 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1_link.28 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: inode:16777344, name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.28 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.29 OK
+*** Verified parent pointer: inode:16777344, name:file1_link.29, namelen:13
+*** Parent pointer OK for child testfolder1/file1 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1_link.29 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: inode:16777344, name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.29 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.30 OK
+*** Verified parent pointer: inode:16777344, name:file1_link.30, namelen:13
+*** Parent pointer OK for child testfolder1/file1 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1_link.30 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: inode:16777344, name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.30 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.31 OK
+*** Verified parent pointer: inode:16777344, name:file1_link.31, namelen:13
+*** Parent pointer OK for child testfolder1/file1 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1_link.31 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: inode:16777344, name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.31 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.32 OK
+*** Verified parent pointer: inode:16777344, name:file1_link.32, namelen:13
+*** Parent pointer OK for child testfolder1/file1 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1_link.32 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: inode:16777344, name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.32 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.33 OK
+*** Verified parent pointer: inode:16777344, name:file1_link.33, namelen:13
+*** Parent pointer OK for child testfolder1/file1 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1_link.33 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: inode:16777344, name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.33 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.34 OK
+*** Verified parent pointer: inode:16777344, name:file1_link.34, namelen:13
+*** Parent pointer OK for child testfolder1/file1 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1_link.34 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: inode:16777344, name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.34 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.35 OK
+*** Verified parent pointer: inode:16777344, name:file1_link.35, namelen:13
+*** Parent pointer OK for child testfolder1/file1 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1_link.35 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: inode:16777344, name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.35 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.36 OK
+*** Verified parent pointer: inode:16777344, name:file1_link.36, namelen:13
+*** Parent pointer OK for child testfolder1/file1 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1_link.36 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: inode:16777344, name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.36 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.37 OK
+*** Verified parent pointer: inode:16777344, name:file1_link.37, namelen:13
+*** Parent pointer OK for child testfolder1/file1 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1_link.37 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: inode:16777344, name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.37 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.38 OK
+*** Verified parent pointer: inode:16777344, name:file1_link.38, namelen:13
+*** Parent pointer OK for child testfolder1/file1 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1_link.38 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: inode:16777344, name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.38 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.39 OK
+*** Verified parent pointer: inode:16777344, name:file1_link.39, namelen:13
+*** Parent pointer OK for child testfolder1/file1 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1_link.39 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: inode:16777344, name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.39 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.40 OK
+*** Verified parent pointer: inode:16777344, name:file1_link.40, namelen:13
+*** Parent pointer OK for child testfolder1/file1 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1_link.40 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: inode:16777344, name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.40 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.41 OK
+*** Verified parent pointer: inode:16777344, name:file1_link.41, namelen:13
+*** Parent pointer OK for child testfolder1/file1 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1_link.41 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: inode:16777344, name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.41 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.42 OK
+*** Verified parent pointer: inode:16777344, name:file1_link.42, namelen:13
+*** Parent pointer OK for child testfolder1/file1 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1_link.42 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: inode:16777344, name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.42 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.43 OK
+*** Verified parent pointer: inode:16777344, name:file1_link.43, namelen:13
+*** Parent pointer OK for child testfolder1/file1 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1_link.43 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: inode:16777344, name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.43 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.44 OK
+*** Verified parent pointer: inode:16777344, name:file1_link.44, namelen:13
+*** Parent pointer OK for child testfolder1/file1 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1_link.44 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: inode:16777344, name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.44 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.45 OK
+*** Verified parent pointer: inode:16777344, name:file1_link.45, namelen:13
+*** Parent pointer OK for child testfolder1/file1 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1_link.45 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: inode:16777344, name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.45 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.46 OK
+*** Verified parent pointer: inode:16777344, name:file1_link.46, namelen:13
+*** Parent pointer OK for child testfolder1/file1 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1_link.46 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: inode:16777344, name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.46 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.47 OK
+*** Verified parent pointer: inode:16777344, name:file1_link.47, namelen:13
+*** Parent pointer OK for child testfolder1/file1 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1_link.47 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: inode:16777344, name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.47 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.48 OK
+*** Verified parent pointer: inode:16777344, name:file1_link.48, namelen:13
+*** Parent pointer OK for child testfolder1/file1 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1_link.48 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: inode:16777344, name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.48 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.49 OK
+*** Verified parent pointer: inode:16777344, name:file1_link.49, namelen:13
+*** Parent pointer OK for child testfolder1/file1 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1_link.49 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: inode:16777344, name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.49 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.50 OK
+*** Verified parent pointer: inode:16777344, name:file1_link.50, namelen:13
+*** Parent pointer OK for child testfolder1/file1 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1_link.50 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: inode:16777344, name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.50 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.51 OK
+*** Verified parent pointer: inode:16777344, name:file1_link.51, namelen:13
+*** Parent pointer OK for child testfolder1/file1 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1_link.51 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: inode:16777344, name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.51 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.52 OK
+*** Verified parent pointer: inode:16777344, name:file1_link.52, namelen:13
+*** Parent pointer OK for child testfolder1/file1 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1_link.52 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: inode:16777344, name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.52 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.53 OK
+*** Verified parent pointer: inode:16777344, name:file1_link.53, namelen:13
+*** Parent pointer OK for child testfolder1/file1 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1_link.53 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: inode:16777344, name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.53 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.54 OK
+*** Verified parent pointer: inode:16777344, name:file1_link.54, namelen:13
+*** Parent pointer OK for child testfolder1/file1 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1_link.54 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: inode:16777344, name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.54 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.55 OK
+*** Verified parent pointer: inode:16777344, name:file1_link.55, namelen:13
+*** Parent pointer OK for child testfolder1/file1 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1_link.55 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: inode:16777344, name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.55 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.56 OK
+*** Verified parent pointer: inode:16777344, name:file1_link.56, namelen:13
+*** Parent pointer OK for child testfolder1/file1 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1_link.56 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: inode:16777344, name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.56 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.57 OK
+*** Verified parent pointer: inode:16777344, name:file1_link.57, namelen:13
+*** Parent pointer OK for child testfolder1/file1 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1_link.57 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: inode:16777344, name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.57 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.58 OK
+*** Verified parent pointer: inode:16777344, name:file1_link.58, namelen:13
+*** Parent pointer OK for child testfolder1/file1 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1_link.58 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: inode:16777344, name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.58 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.59 OK
+*** Verified parent pointer: inode:16777344, name:file1_link.59, namelen:13
+*** Parent pointer OK for child testfolder1/file1 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1_link.59 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: inode:16777344, name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.59 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.60 OK
+*** Verified parent pointer: inode:16777344, name:file1_link.60, namelen:13
+*** Parent pointer OK for child testfolder1/file1 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1_link.60 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: inode:16777344, name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.60 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.61 OK
+*** Verified parent pointer: inode:16777344, name:file1_link.61, namelen:13
+*** Parent pointer OK for child testfolder1/file1 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1_link.61 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: inode:16777344, name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.61 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.62 OK
+*** Verified parent pointer: inode:16777344, name:file1_link.62, namelen:13
+*** Parent pointer OK for child testfolder1/file1 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1_link.62 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: inode:16777344, name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.62 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.63 OK
+*** Verified parent pointer: inode:16777344, name:file1_link.63, namelen:13
+*** Parent pointer OK for child testfolder1/file1 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1_link.63 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: inode:16777344, name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.63 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.64 OK
+*** Verified parent pointer: inode:16777344, name:file1_link.64, namelen:13
+*** Parent pointer OK for child testfolder1/file1 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1_link.64 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: inode:16777344, name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.64 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.65 OK
+*** Verified parent pointer: inode:16777344, name:file1_link.65, namelen:13
+*** Parent pointer OK for child testfolder1/file1 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1_link.65 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: inode:16777344, name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.65 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.66 OK
+*** Verified parent pointer: inode:16777344, name:file1_link.66, namelen:13
+*** Parent pointer OK for child testfolder1/file1 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1_link.66 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: inode:16777344, name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.66 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.67 OK
+*** Verified parent pointer: inode:16777344, name:file1_link.67, namelen:13
+*** Parent pointer OK for child testfolder1/file1 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1_link.67 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: inode:16777344, name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.67 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.68 OK
+*** Verified parent pointer: inode:16777344, name:file1_link.68, namelen:13
+*** Parent pointer OK for child testfolder1/file1 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1_link.68 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: inode:16777344, name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.68 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.69 OK
+*** Verified parent pointer: inode:16777344, name:file1_link.69, namelen:13
+*** Parent pointer OK for child testfolder1/file1 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1_link.69 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: inode:16777344, name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.69 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.70 OK
+*** Verified parent pointer: inode:16777344, name:file1_link.70, namelen:13
+*** Parent pointer OK for child testfolder1/file1 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1_link.70 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: inode:16777344, name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.70 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.71 OK
+*** Verified parent pointer: inode:16777344, name:file1_link.71, namelen:13
+*** Parent pointer OK for child testfolder1/file1 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1_link.71 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: inode:16777344, name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.71 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.72 OK
+*** Verified parent pointer: inode:16777344, name:file1_link.72, namelen:13
+*** Parent pointer OK for child testfolder1/file1 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1_link.72 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: inode:16777344, name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.72 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.73 OK
+*** Verified parent pointer: inode:16777344, name:file1_link.73, namelen:13
+*** Parent pointer OK for child testfolder1/file1 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1_link.73 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: inode:16777344, name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.73 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.74 OK
+*** Verified parent pointer: inode:16777344, name:file1_link.74, namelen:13
+*** Parent pointer OK for child testfolder1/file1 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1_link.74 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: inode:16777344, name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.74 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.75 OK
+*** Verified parent pointer: inode:16777344, name:file1_link.75, namelen:13
+*** Parent pointer OK for child testfolder1/file1 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1_link.75 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: inode:16777344, name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.75 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.76 OK
+*** Verified parent pointer: inode:16777344, name:file1_link.76, namelen:13
+*** Parent pointer OK for child testfolder1/file1 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1_link.76 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: inode:16777344, name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.76 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.77 OK
+*** Verified parent pointer: inode:16777344, name:file1_link.77, namelen:13
+*** Parent pointer OK for child testfolder1/file1 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1_link.77 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: inode:16777344, name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.77 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.78 OK
+*** Verified parent pointer: inode:16777344, name:file1_link.78, namelen:13
+*** Parent pointer OK for child testfolder1/file1 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1_link.78 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: inode:16777344, name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.78 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.79 OK
+*** Verified parent pointer: inode:16777344, name:file1_link.79, namelen:13
+*** Parent pointer OK for child testfolder1/file1 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1_link.79 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: inode:16777344, name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.79 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.80 OK
+*** Verified parent pointer: inode:16777344, name:file1_link.80, namelen:13
+*** Parent pointer OK for child testfolder1/file1 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1_link.80 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: inode:16777344, name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.80 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.81 OK
+*** Verified parent pointer: inode:16777344, name:file1_link.81, namelen:13
+*** Parent pointer OK for child testfolder1/file1 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1_link.81 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: inode:16777344, name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.81 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.82 OK
+*** Verified parent pointer: inode:16777344, name:file1_link.82, namelen:13
+*** Parent pointer OK for child testfolder1/file1 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1_link.82 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: inode:16777344, name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.82 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.83 OK
+*** Verified parent pointer: inode:16777344, name:file1_link.83, namelen:13
+*** Parent pointer OK for child testfolder1/file1 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1_link.83 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: inode:16777344, name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.83 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.84 OK
+*** Verified parent pointer: inode:16777344, name:file1_link.84, namelen:13
+*** Parent pointer OK for child testfolder1/file1 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1_link.84 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: inode:16777344, name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.84 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.85 OK
+*** Verified parent pointer: inode:16777344, name:file1_link.85, namelen:13
+*** Parent pointer OK for child testfolder1/file1 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1_link.85 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: inode:16777344, name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.85 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.86 OK
+*** Verified parent pointer: inode:16777344, name:file1_link.86, namelen:13
+*** Parent pointer OK for child testfolder1/file1 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1_link.86 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: inode:16777344, name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.86 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.87 OK
+*** Verified parent pointer: inode:16777344, name:file1_link.87, namelen:13
+*** Parent pointer OK for child testfolder1/file1 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1_link.87 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: inode:16777344, name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.87 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.88 OK
+*** Verified parent pointer: inode:16777344, name:file1_link.88, namelen:13
+*** Parent pointer OK for child testfolder1/file1 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1_link.88 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: inode:16777344, name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.88 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.89 OK
+*** Verified parent pointer: inode:16777344, name:file1_link.89, namelen:13
+*** Parent pointer OK for child testfolder1/file1 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1_link.89 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: inode:16777344, name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.89 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.90 OK
+*** Verified parent pointer: inode:16777344, name:file1_link.90, namelen:13
+*** Parent pointer OK for child testfolder1/file1 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1_link.90 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: inode:16777344, name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.90 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.91 OK
+*** Verified parent pointer: inode:16777344, name:file1_link.91, namelen:13
+*** Parent pointer OK for child testfolder1/file1 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1_link.91 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: inode:16777344, name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.91 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.92 OK
+*** Verified parent pointer: inode:16777344, name:file1_link.92, namelen:13
+*** Parent pointer OK for child testfolder1/file1 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1_link.92 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: inode:16777344, name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.92 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.93 OK
+*** Verified parent pointer: inode:16777344, name:file1_link.93, namelen:13
+*** Parent pointer OK for child testfolder1/file1 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1_link.93 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: inode:16777344, name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.93 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.94 OK
+*** Verified parent pointer: inode:16777344, name:file1_link.94, namelen:13
+*** Parent pointer OK for child testfolder1/file1 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1_link.94 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: inode:16777344, name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.94 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.95 OK
+*** Verified parent pointer: inode:16777344, name:file1_link.95, namelen:13
+*** Parent pointer OK for child testfolder1/file1 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1_link.95 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: inode:16777344, name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.95 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.96 OK
+*** Verified parent pointer: inode:16777344, name:file1_link.96, namelen:13
+*** Parent pointer OK for child testfolder1/file1 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1_link.96 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: inode:16777344, name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.96 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.97 OK
+*** Verified parent pointer: inode:16777344, name:file1_link.97, namelen:13
+*** Parent pointer OK for child testfolder1/file1 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1_link.97 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: inode:16777344, name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.97 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.98 OK
+*** Verified parent pointer: inode:16777344, name:file1_link.98, namelen:13
+*** Parent pointer OK for child testfolder1/file1 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1_link.98 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: inode:16777344, name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.98 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.99 OK
+*** Verified parent pointer: inode:16777344, name:file1_link.99, namelen:13
+*** Parent pointer OK for child testfolder1/file1 inode:16777345
+*** testfolder1 OK
+*** testfolder1/file1_link.99 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: inode:16777344, name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.99 inode:16777345
+Multi unlink parent pointer test
+*** unmount FS
+*** done
diff --git a/tests/xfs/493 b/tests/xfs/493
new file mode 100755
index 0000000..a26ac89
--- /dev/null
+++ b/tests/xfs/493
@@ -0,0 +1,143 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2018, Oracle and/or its affiliates.  All Rights Reserved.
+#
+# FS QA Test No. 448
+#
+# parent pointer inject test
+#
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+seqfull="$seqres.full"
+status=1	# failure is the default!
+trap "cleanup; exit \$status" 0 1 2 3 15
+
+cleanup()
+{
+	cd /
+	rm -f $tmp.*
+}
+
+filter_dbval()
+{
+	awk '{ print $4 }'
+}
+
+full()
+{
+    echo ""            >>$seqfull
+    echo "*** $* ***"  >>$seqfull
+    echo ""            >>$seqfull
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/reflink
+. ./common/inject
+. ./common/parent
+
+# remove previous $seqres.full before test
+rm -f $seqres.full
+
+# Modify as appropriate
+_supported_os Linux
+_supported_fs xfs
+_require_scratch
+_require_xfs_io_error_injection "delayed_attr"
+
+# real QA test starts here
+
+# Create a directory tree using a protofile and
+# make sure all inodes created have parent pointers
+
+protofile=$tmp.proto
+
+cat >$protofile <<EOF
+DUMMY1
+0 0
+: root directory
+d--777 3 1
+: a directory
+testfolder1 d--755 3 1
+file1 ---755 3 1 /dev/null
+$
+: back in the root
+testfolder2 d--755 3 1
+file2 ---755 3 1 /dev/null
+: done
+$
+EOF
+
+if [ $? -ne 0 ]
+then
+    _fail "failed to create test protofile"
+fi
+
+echo "*** create FS"
+
+rm -f $seqfull
+_scratch_unmount >/dev/null 2>&1
+
+_scratch_mkfs_xfs -f -n parent=1 -p $protofile >>$seqfull 2>&1 \
+	|| _fail "mkfs failed"
+echo "*** check FS"
+_check_scratch_fs
+
+echo "*** mount FS"
+full " mount"
+_scratch_mount >>$seqfull 2>&1 \
+	|| _fail "mount failed"
+
+testfolder1="testfolder1"
+testfolder2="testfolder2"
+file1="file1"
+file2="file2"
+file3="file3"
+file4="file4"
+file5="file5"
+file1_ln="file1_link"
+
+echo ""
+echo "Error inject test"
+
+echo "Create files"
+touch $SCRATCH_MNT/$testfolder1/$file4
+_verify_parent    "$testfolder1" "$file4" "$testfolder1/$file4"
+
+echo "Inject error"
+_scratch_inject_error "delayed_attr"
+
+echo "Move files"
+mv $SCRATCH_MNT/$testfolder1/$file4 $SCRATCH_MNT/$testfolder2/$file5
+
+echo "FS should be shut down, touch will fail"
+touch $SCRATCH_MNT/$testfolder2/$file5 2>&1 | _filter_scratch
+
+echo "Remount to replay log"
+_scratch_inject_logprint >> $seqres.full
+
+echo "FS should be online, touch should succeed"
+touch $SCRATCH_MNT/$testfolder2/$file5
+
+echo "Check files again"
+_verify_parent    "$testfolder2" "$file5" "$testfolder2/$file5"
+
+echo "*** unmount FS"
+full "umount"
+_scratch_unmount >>$seqfull 2>&1 \
+	|| _fail "umount failed"
+
+
+echo "*** done"
+rm $seqfull
+status=0
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/493.out b/tests/xfs/493.out
new file mode 100644
index 0000000..024338e
--- /dev/null
+++ b/tests/xfs/493.out
@@ -0,0 +1,27 @@
+QA output created by 493
+*** create FS
+*** check FS
+*** mount FS
+
+Error inject test
+Create files
+*** testfolder1 OK
+*** testfolder1/file4 OK
+*** testfolder1/file4 OK
+*** Verified parent pointer: inode:16777344, name:file4, namelen:5
+*** Parent pointer OK for child testfolder1/file4 inode:16777346
+Inject error
+Move files
+mv: cannot move '/mnt/scratch/testfolder1/file4' to '/mnt/scratch/testfolder2/file5': Input/output error
+FS should be shut down, touch will fail
+touch: cannot touch 'SCRATCH_MNT/testfolder2/file5': Input/output error
+Remount to replay log
+FS should be online, touch should succeed
+Check files again
+*** testfolder2 OK
+*** testfolder2/file5 OK
+*** testfolder2/file5 OK
+*** Verified parent pointer: inode:33613312, name:file5, namelen:5
+*** Parent pointer OK for child testfolder2/file5 inode:16777346
+*** unmount FS
+*** done
diff --git a/tests/xfs/group b/tests/xfs/group
index 821bf2a..b25b13b 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -488,3 +488,7 @@
 488 dangerous_fuzzers dangerous_norepair
 489 dangerous_fuzzers dangerous_norepair
 490 auto quick
+491 auto quick parent
+492 auto quick parent
+493 auto quick parent
+
-- 
2.7.4
