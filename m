Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:59296 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726575AbfEGQ5N (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 May 2019 12:57:13 -0400
Subject: [PATCH 2/3] xfs/216: always disable rmap and reflink when creating
 log size test fs
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 07 May 2019 09:57:03 -0700
Message-ID: <155724822301.2624631.12786681370099485635.stgit@magnolia>
In-Reply-To: <155724821034.2624631.4172554705843296757.stgit@magnolia>
References: <155724821034.2624631.4172554705843296757.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: guaneryu@gmail.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, xuyang2018.jy@cn.fujitsu.com, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

This test seems to check that log sizes scale up properly with the size
of the filesystem, given a carefully controlled set of mkfs parameters.
Since turning on reflink or rmap will change the minimum log size,
change the test to detect their presence and ensure they're disabled.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/216 |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)


diff --git a/tests/xfs/216 b/tests/xfs/216
index b1fd8ecc..15ff9ae1 100755
--- a/tests/xfs/216
+++ b/tests/xfs/216
@@ -37,12 +37,18 @@ _require_loop
 LOOP_DEV=$SCRATCH_MNT/test_fs
 LOOP_MNT=$SCRATCH_MNT/test_fs_dir
 
+loop_mkfs_opts=
+$MKFS_XFS_PROG 2>&1 | grep -q rmapbt && \
+	loop_mkfs_opts="$loop_mkfs_opts -m rmapbt=0"
+$MKFS_XFS_PROG 2>&1 | grep -q reflink && \
+	loop_mkfs_opts="$loop_mkfs_opts -m reflink=0"
+
 _do_mkfs()
 {
 	for i in $*; do
 		echo -n "fssize=${i}g "
 		$MKFS_XFS_PROG -f -b size=4096 -l version=2 \
-			-d name=$LOOP_DEV,size=${i}g |grep log
+			-d name=$LOOP_DEV,size=${i}g $loop_mkfs_opts |grep log
 		mount -o loop -t xfs $LOOP_DEV $LOOP_MNT
 		echo "test write" > $LOOP_MNT/test
 		umount $LOOP_MNT > /dev/null 2>&1
