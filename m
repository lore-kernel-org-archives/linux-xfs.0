Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33288 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932522AbcJYNjP (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 25 Oct 2016 09:39:15 -0400
From: Eryu Guan <eguan@redhat.com>
Subject: [PATCH v2] xfs/054: only filter ROOT_INO at the beginning
Date: Tue, 25 Oct 2016 21:38:49 +0800
Message-Id: <1477402729-13934-1-git-send-email-eguan@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, Eryu Guan <eguan@redhat.com>

In the test ROOT_INO is filtered out and/or replaced, but if
ROOT_INO is also 32, more "32"s are filtered and replaced than
expected. This happens to me when testing 512B block size XFS and 1k
block size CRC enabled XFS.

Fix it by filtering out only ROOT_INO at the beginning of a line,
and removing all "g" modifiers in sed expressions.

Also the ROOT_INO should be the root inode number of TEST_DIR not
SCRATCH_MNT.

Signed-off-by: Eryu Guan <eguan@redhat.com>
---
v2:
- remove all "g" modifiers in sed expressions

 tests/xfs/054 | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/tests/xfs/054 b/tests/xfs/054
index 7d08f8a..57b49e7 100755
--- a/tests/xfs/054
+++ b/tests/xfs/054
@@ -52,13 +52,13 @@ _require_test
 _require_xfs_io_command "inode"
 
 # We know the root inode is there
-ROOT_INO=`ls -id $SCRATCH_MNT | awk '{print $1}'`
+ROOT_INO=`ls -id $TEST_DIR | awk '{print $1}'`
 
 touch $TEST_DIR/file
 
 $XFS_IO_PROG -c "inode"       $TEST_DIR/file
 $XFS_IO_PROG -c "inode -v"    $TEST_DIR/file | \
-		grep -vw $ROOT_INO | sed -e s/.*:/LAST:/g
+		grep -vw "^$ROOT_INO" | sed -e s/.*:/LAST:/
 
 #  These should fail, -n requires an inode
 $XFS_IO_PROG -c "inode -n"    $TEST_DIR/file 2>&1 | grep -q Query \
@@ -83,15 +83,15 @@ $XFS_IO_PROG -c "inode -n -v badnumber" $TEST_DIR/file | grep -q numeric \
 # These should all work, and return $ROOT_INO or the next inode...
 # grep out ROOT_INO (which is incorrect) when we should be getting next inode
 $XFS_IO_PROG -c "inode       $ROOT_INO" $TEST_DIR/file | \
-		sed -e s/$ROOT_INO/ROOT_INO/g
+		sed -e s/$ROOT_INO/ROOT_INO/
 $XFS_IO_PROG -c "inode -v    $ROOT_INO" $TEST_DIR/file | \
-		sed -e s/$ROOT_INO/ROOT_INO/g
+		sed -e s/$ROOT_INO/ROOT_INO/
 $XFS_IO_PROG -c "inode -n    $ROOT_INO" $TEST_DIR/file | \
-		grep -vw $ROOT_INO | sed -e s/.*/NEXT/g
+		grep -vw "^$ROOT_INO" | sed -e s/.*/NEXT/
 $XFS_IO_PROG -c "inode -nv   $ROOT_INO" $TEST_DIR/file | \
-		grep -vw $ROOT_INO | sed -e s/.*:/NEXT:/g
+		grep -vw "^$ROOT_INO" | sed -e s/.*:/NEXT:/
 $XFS_IO_PROG -c "inode -n -v $ROOT_INO" $TEST_DIR/file | \
-		grep -vw $ROOT_INO | sed -e s/.*:/NEXT:/g
+		grep -vw "^$ROOT_INO" | sed -e s/.*:/NEXT:/
 
 # Try one that doesn't exist, 2^64-2?  Should get 0
 $XFS_IO_PROG -c "inode       18446744073709551614" $TEST_DIR/file
-- 
2.7.4

