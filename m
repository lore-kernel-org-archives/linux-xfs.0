Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:36394 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752426AbcLYSKD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 25 Dec 2016 13:10:03 -0500
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 3/3] xfs/348: test readlink/readdir with malformed inode mode
Date: Sun, 25 Dec 2016 20:09:36 +0200
Message-Id: <1482689376-23553-4-git-send-email-amir73il@gmail.com>
In-Reply-To: <1482689376-23553-1-git-send-email-amir73il@gmail.com>
References: <1482689376-23553-1-git-send-email-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@infradead.org>
Cc: Brian Foster <bfoster@redhat.com>, fstests@vger.kernel.org, linux-xfs@vger.kernel.org

In addition to testing xfs_repair on inodes with malformed mode,
and fstat of those inodes on a mounted fs, try to also list content
of mock directory and readlink of mock symlink.

Readdir of mock directory triggers XFS assertion on umount:
 XFS: Assertion failed: !rwsem_is_locked(&inode->i_rwsem), file:
 /home/amir/build/src/linux/fs/xfs/xfs_super.c, line: 951

To reproduce, need to comment out the variable 'safety'.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 tests/xfs/348 | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/tests/xfs/348 b/tests/xfs/348
index 2a54f9e..cb0e3ea 100755
--- a/tests/xfs/348
+++ b/tests/xfs/348
@@ -132,6 +132,16 @@ for dt in $dtypes; do
 			cat $tmp.stat.err
 		else
 			echo "stat: '$testdir/$file' is a $ftype"
+			# Verify that readlink of a file posing as a symlink
+			# and ls of a file posing as a directory does not blow up
+			safety="-d"
+			# NOTE that ls DOES blow up with kernel 4.9 on malformed
+			# directory - remove the safety pin to explode
+			if [ -d $testdir/$file ]; then
+				ls "$safety" $testdir/$file &> /dev/null
+			elif [ -h $testdir/$file ]; then
+				readlink $testdir/$file &> /dev/null
+			fi
 		fi | _filter_scratch
 	done
 	_scratch_unmount
-- 
2.7.4

