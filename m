Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wj0-f193.google.com ([209.85.210.193]:32816 "EHLO
        mail-wj0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752851AbcLYSKB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 25 Dec 2016 13:10:01 -0500
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 2/3] xfs/348: test fstat with malformed inode mode
Date: Sun, 25 Dec 2016 20:09:35 +0200
Message-Id: <1482689376-23553-3-git-send-email-amir73il@gmail.com>
In-Reply-To: <1482689376-23553-1-git-send-email-amir73il@gmail.com>
References: <1482689376-23553-1-git-send-email-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@infradead.org>
Cc: Brian Foster <bfoster@redhat.com>, fstests@vger.kernel.org, linux-xfs@vger.kernel.org

In addition to testing xfs_repair on inodes with malformed mode,
also test fstat of those inodes on a mounted fs.

This additional test is quite noisy with dmesg warnings, so
check dmesg has been disabled.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 tests/xfs/348     | 16 ++++++++++
 tests/xfs/348.out | 96 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 112 insertions(+)

diff --git a/tests/xfs/348 b/tests/xfs/348
index 9ec696a..2a54f9e 100755
--- a/tests/xfs/348
+++ b/tests/xfs/348
@@ -49,6 +49,10 @@ _supported_fs xfs
 _supported_os Linux
 _require_scratch
 
+# This test will corrupt fs intentionally, so there will be WARNINGs
+# in dmesg as expected
+_disable_dmesg_check
+
 rm -f $seqres.full
 
 _scratch_mkfs >>$seqres.full 2>&1
@@ -119,6 +123,18 @@ for dt in $dtypes; do
 		_scratch_xfs_repair -n 2>&1 | grep -q -v "^would fix ftype mismatch" || \
 			_fail "xfs_repair should not fix ftype mismatch"
 	fi
+
+	_scratch_mount
+	for file in DIR FILE SYMLINK CHRDEV BLKDEV FIFO; do
+		rm -f $tmp.stat.err
+		ftype=$(stat --printf=%F $testdir/$file 2>$tmp.stat.err)
+		if [ -s $tmp.stat.err ]; then
+			cat $tmp.stat.err
+		else
+			echo "stat: '$testdir/$file' is a $ftype"
+		fi | _filter_scratch
+	done
+	_scratch_unmount
 done
 
 # Repair should detect and junk all test files
diff --git a/tests/xfs/348.out b/tests/xfs/348.out
index bf4924b..cdb7d78 100644
--- a/tests/xfs/348.out
+++ b/tests/xfs/348.out
@@ -20,6 +20,12 @@ would have junked entry "DIR" in directory PARENT_INO
 would have junked entry "FIFO" in directory PARENT_INO
 would have junked entry "FILE" in directory PARENT_INO
 would have junked entry "SYMLINK" in directory PARENT_INO
+stat: cannot stat 'SCRATCH_MNT/test/DIR': Structure needs cleaning
+stat: cannot stat 'SCRATCH_MNT/test/FILE': Structure needs cleaning
+stat: cannot stat 'SCRATCH_MNT/test/SYMLINK': Structure needs cleaning
+stat: cannot stat 'SCRATCH_MNT/test/CHRDEV': Structure needs cleaning
+stat: cannot stat 'SCRATCH_MNT/test/BLKDEV': Structure needs cleaning
+stat: cannot stat 'SCRATCH_MNT/test/FIFO': Structure needs cleaning
 
 ===== Setting dt=1 to all files:
 core.mode = 010644
@@ -31,6 +37,12 @@ core.mode = 010644
 would have junked entry "DIR" in directory PARENT_INO
 would have junked entry "FILE" in directory PARENT_INO
 would have junked entry "SYMLINK" in directory PARENT_INO
+stat: cannot stat 'SCRATCH_MNT/test/DIR': Structure needs cleaning
+stat: cannot stat 'SCRATCH_MNT/test/FILE': Structure needs cleaning
+stat: cannot stat 'SCRATCH_MNT/test/SYMLINK': Structure needs cleaning
+stat: 'SCRATCH_MNT/test/CHRDEV' is a fifo
+stat: 'SCRATCH_MNT/test/BLKDEV' is a fifo
+stat: 'SCRATCH_MNT/test/FIFO' is a fifo
 
 ===== Setting dt=2 to all files:
 core.mode = 020644
@@ -42,6 +54,12 @@ core.mode = 020644
 would have junked entry "DIR" in directory PARENT_INO
 would have junked entry "FILE" in directory PARENT_INO
 would have junked entry "SYMLINK" in directory PARENT_INO
+stat: cannot stat 'SCRATCH_MNT/test/DIR': Structure needs cleaning
+stat: cannot stat 'SCRATCH_MNT/test/FILE': Structure needs cleaning
+stat: cannot stat 'SCRATCH_MNT/test/SYMLINK': Structure needs cleaning
+stat: 'SCRATCH_MNT/test/CHRDEV' is a character special file
+stat: 'SCRATCH_MNT/test/BLKDEV' is a character special file
+stat: 'SCRATCH_MNT/test/FIFO' is a character special file
 
 ===== Setting dt=3 to all files:
 core.mode = 030644
@@ -56,6 +74,12 @@ would have junked entry "DIR" in directory PARENT_INO
 would have junked entry "FIFO" in directory PARENT_INO
 would have junked entry "FILE" in directory PARENT_INO
 would have junked entry "SYMLINK" in directory PARENT_INO
+stat: cannot stat 'SCRATCH_MNT/test/DIR': Structure needs cleaning
+stat: cannot stat 'SCRATCH_MNT/test/FILE': Structure needs cleaning
+stat: cannot stat 'SCRATCH_MNT/test/SYMLINK': Structure needs cleaning
+stat: cannot stat 'SCRATCH_MNT/test/CHRDEV': Structure needs cleaning
+stat: cannot stat 'SCRATCH_MNT/test/BLKDEV': Structure needs cleaning
+stat: cannot stat 'SCRATCH_MNT/test/FIFO': Structure needs cleaning
 
 ===== Setting dt=4 to all files:
 core.mode = 040644
@@ -68,6 +92,12 @@ would have junked entry "BLKDEV" in directory PARENT_INO
 would have junked entry "CHRDEV" in directory PARENT_INO
 would have junked entry "FIFO" in directory PARENT_INO
 would have junked entry "FILE" in directory PARENT_INO
+stat: 'SCRATCH_MNT/test/DIR' is a directory
+stat: 'SCRATCH_MNT/test/FILE' is a directory
+stat: 'SCRATCH_MNT/test/SYMLINK' is a directory
+stat: cannot stat 'SCRATCH_MNT/test/CHRDEV': Structure needs cleaning
+stat: cannot stat 'SCRATCH_MNT/test/BLKDEV': Structure needs cleaning
+stat: cannot stat 'SCRATCH_MNT/test/FIFO': Structure needs cleaning
 
 ===== Setting dt=5 to all files:
 core.mode = 050644
@@ -82,6 +112,12 @@ would have junked entry "DIR" in directory PARENT_INO
 would have junked entry "FIFO" in directory PARENT_INO
 would have junked entry "FILE" in directory PARENT_INO
 would have junked entry "SYMLINK" in directory PARENT_INO
+stat: cannot stat 'SCRATCH_MNT/test/DIR': Structure needs cleaning
+stat: cannot stat 'SCRATCH_MNT/test/FILE': Structure needs cleaning
+stat: cannot stat 'SCRATCH_MNT/test/SYMLINK': Structure needs cleaning
+stat: cannot stat 'SCRATCH_MNT/test/CHRDEV': Structure needs cleaning
+stat: cannot stat 'SCRATCH_MNT/test/BLKDEV': Structure needs cleaning
+stat: cannot stat 'SCRATCH_MNT/test/FIFO': Structure needs cleaning
 
 ===== Setting dt=6 to all files:
 core.mode = 060644
@@ -93,6 +129,12 @@ core.mode = 060644
 would have junked entry "DIR" in directory PARENT_INO
 would have junked entry "FILE" in directory PARENT_INO
 would have junked entry "SYMLINK" in directory PARENT_INO
+stat: cannot stat 'SCRATCH_MNT/test/DIR': Structure needs cleaning
+stat: cannot stat 'SCRATCH_MNT/test/FILE': Structure needs cleaning
+stat: cannot stat 'SCRATCH_MNT/test/SYMLINK': Structure needs cleaning
+stat: 'SCRATCH_MNT/test/CHRDEV' is a block special file
+stat: 'SCRATCH_MNT/test/BLKDEV' is a block special file
+stat: 'SCRATCH_MNT/test/FIFO' is a block special file
 
 ===== Setting dt=7 to all files:
 core.mode = 070644
@@ -107,6 +149,12 @@ would have junked entry "DIR" in directory PARENT_INO
 would have junked entry "FIFO" in directory PARENT_INO
 would have junked entry "FILE" in directory PARENT_INO
 would have junked entry "SYMLINK" in directory PARENT_INO
+stat: cannot stat 'SCRATCH_MNT/test/DIR': Structure needs cleaning
+stat: cannot stat 'SCRATCH_MNT/test/FILE': Structure needs cleaning
+stat: cannot stat 'SCRATCH_MNT/test/SYMLINK': Structure needs cleaning
+stat: cannot stat 'SCRATCH_MNT/test/CHRDEV': Structure needs cleaning
+stat: cannot stat 'SCRATCH_MNT/test/BLKDEV': Structure needs cleaning
+stat: cannot stat 'SCRATCH_MNT/test/FIFO': Structure needs cleaning
 
 ===== Setting dt=10 to all files:
 core.mode = 0100644
@@ -120,6 +168,12 @@ would have junked entry "CHRDEV" in directory PARENT_INO
 would have junked entry "DIR" in directory PARENT_INO
 would have junked entry "FIFO" in directory PARENT_INO
 would have junked entry "SYMLINK" in directory PARENT_INO
+stat: cannot stat 'SCRATCH_MNT/test/DIR': Structure needs cleaning
+stat: 'SCRATCH_MNT/test/FILE' is a regular file
+stat: cannot stat 'SCRATCH_MNT/test/SYMLINK': Structure needs cleaning
+stat: cannot stat 'SCRATCH_MNT/test/CHRDEV': Structure needs cleaning
+stat: cannot stat 'SCRATCH_MNT/test/BLKDEV': Structure needs cleaning
+stat: cannot stat 'SCRATCH_MNT/test/FIFO': Structure needs cleaning
 
 ===== Setting dt=11 to all files:
 core.mode = 0110644
@@ -134,6 +188,12 @@ would have junked entry "DIR" in directory PARENT_INO
 would have junked entry "FIFO" in directory PARENT_INO
 would have junked entry "FILE" in directory PARENT_INO
 would have junked entry "SYMLINK" in directory PARENT_INO
+stat: cannot stat 'SCRATCH_MNT/test/DIR': Structure needs cleaning
+stat: cannot stat 'SCRATCH_MNT/test/FILE': Structure needs cleaning
+stat: cannot stat 'SCRATCH_MNT/test/SYMLINK': Structure needs cleaning
+stat: cannot stat 'SCRATCH_MNT/test/CHRDEV': Structure needs cleaning
+stat: cannot stat 'SCRATCH_MNT/test/BLKDEV': Structure needs cleaning
+stat: cannot stat 'SCRATCH_MNT/test/FIFO': Structure needs cleaning
 
 ===== Setting dt=12 to all files:
 core.mode = 0120644
@@ -147,6 +207,12 @@ would have junked entry "CHRDEV" in directory PARENT_INO
 would have junked entry "DIR" in directory PARENT_INO
 would have junked entry "FIFO" in directory PARENT_INO
 would have junked entry "FILE" in directory PARENT_INO
+stat: 'SCRATCH_MNT/test/DIR' is a symbolic link
+stat: 'SCRATCH_MNT/test/FILE' is a symbolic link
+stat: 'SCRATCH_MNT/test/SYMLINK' is a symbolic link
+stat: cannot stat 'SCRATCH_MNT/test/CHRDEV': Structure needs cleaning
+stat: cannot stat 'SCRATCH_MNT/test/BLKDEV': Structure needs cleaning
+stat: cannot stat 'SCRATCH_MNT/test/FIFO': Structure needs cleaning
 
 ===== Setting dt=13 to all files:
 core.mode = 0130644
@@ -161,6 +227,12 @@ would have junked entry "DIR" in directory PARENT_INO
 would have junked entry "FIFO" in directory PARENT_INO
 would have junked entry "FILE" in directory PARENT_INO
 would have junked entry "SYMLINK" in directory PARENT_INO
+stat: cannot stat 'SCRATCH_MNT/test/DIR': Structure needs cleaning
+stat: cannot stat 'SCRATCH_MNT/test/FILE': Structure needs cleaning
+stat: cannot stat 'SCRATCH_MNT/test/SYMLINK': Structure needs cleaning
+stat: cannot stat 'SCRATCH_MNT/test/CHRDEV': Structure needs cleaning
+stat: cannot stat 'SCRATCH_MNT/test/BLKDEV': Structure needs cleaning
+stat: cannot stat 'SCRATCH_MNT/test/FIFO': Structure needs cleaning
 
 ===== Setting dt=14 to all files:
 core.mode = 0140644
@@ -172,6 +244,12 @@ core.mode = 0140644
 would have junked entry "DIR" in directory PARENT_INO
 would have junked entry "FILE" in directory PARENT_INO
 would have junked entry "SYMLINK" in directory PARENT_INO
+stat: cannot stat 'SCRATCH_MNT/test/DIR': Structure needs cleaning
+stat: cannot stat 'SCRATCH_MNT/test/FILE': Structure needs cleaning
+stat: cannot stat 'SCRATCH_MNT/test/SYMLINK': Structure needs cleaning
+stat: 'SCRATCH_MNT/test/CHRDEV' is a socket
+stat: 'SCRATCH_MNT/test/BLKDEV' is a socket
+stat: 'SCRATCH_MNT/test/FIFO' is a socket
 
 ===== Setting dt=15 to all files:
 core.mode = 0150644
@@ -186,6 +264,12 @@ would have junked entry "DIR" in directory PARENT_INO
 would have junked entry "FIFO" in directory PARENT_INO
 would have junked entry "FILE" in directory PARENT_INO
 would have junked entry "SYMLINK" in directory PARENT_INO
+stat: cannot stat 'SCRATCH_MNT/test/DIR': Structure needs cleaning
+stat: cannot stat 'SCRATCH_MNT/test/FILE': Structure needs cleaning
+stat: cannot stat 'SCRATCH_MNT/test/SYMLINK': Structure needs cleaning
+stat: cannot stat 'SCRATCH_MNT/test/CHRDEV': Structure needs cleaning
+stat: cannot stat 'SCRATCH_MNT/test/BLKDEV': Structure needs cleaning
+stat: cannot stat 'SCRATCH_MNT/test/FIFO': Structure needs cleaning
 
 ===== Setting dt=16 to all files:
 core.mode = 0160644
@@ -200,6 +284,12 @@ would have junked entry "DIR" in directory PARENT_INO
 would have junked entry "FIFO" in directory PARENT_INO
 would have junked entry "FILE" in directory PARENT_INO
 would have junked entry "SYMLINK" in directory PARENT_INO
+stat: cannot stat 'SCRATCH_MNT/test/DIR': Structure needs cleaning
+stat: cannot stat 'SCRATCH_MNT/test/FILE': Structure needs cleaning
+stat: cannot stat 'SCRATCH_MNT/test/SYMLINK': Structure needs cleaning
+stat: cannot stat 'SCRATCH_MNT/test/CHRDEV': Structure needs cleaning
+stat: cannot stat 'SCRATCH_MNT/test/BLKDEV': Structure needs cleaning
+stat: cannot stat 'SCRATCH_MNT/test/FIFO': Structure needs cleaning
 
 ===== Setting dt=17 to all files:
 core.mode = 0170644
@@ -214,3 +304,9 @@ would have junked entry "DIR" in directory PARENT_INO
 would have junked entry "FIFO" in directory PARENT_INO
 would have junked entry "FILE" in directory PARENT_INO
 would have junked entry "SYMLINK" in directory PARENT_INO
+stat: cannot stat 'SCRATCH_MNT/test/DIR': Structure needs cleaning
+stat: cannot stat 'SCRATCH_MNT/test/FILE': Structure needs cleaning
+stat: cannot stat 'SCRATCH_MNT/test/SYMLINK': Structure needs cleaning
+stat: cannot stat 'SCRATCH_MNT/test/CHRDEV': Structure needs cleaning
+stat: cannot stat 'SCRATCH_MNT/test/BLKDEV': Structure needs cleaning
+stat: cannot stat 'SCRATCH_MNT/test/FIFO': Structure needs cleaning
-- 
2.7.4

