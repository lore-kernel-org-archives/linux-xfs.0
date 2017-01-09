Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:35059 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S938450AbdAINa4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 Jan 2017 08:30:56 -0500
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v3 2/3] xfs: test fstat with malformed inode mode
Date: Mon,  9 Jan 2017 15:30:24 +0200
Message-Id: <1483968625-29160-3-git-send-email-amir73il@gmail.com>
In-Reply-To: <1483968625-29160-1-git-send-email-amir73il@gmail.com>
References: <1483968625-29160-1-git-send-email-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: Brian Foster <bfoster@redhat.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, fstests@vger.kernel.org, linux-xfs@vger.kernel.org

In addition to testing xfs_repair on inodes with malformed mode,
also test fstat of those inodes on a mounted fs.

This additional test is quite noisy with dmesg warnings, so
check dmesg has been disabled.

This test fails on kernel 4.9 because a zero size inode is not
identified as malformed dir. A patch has been sent to fix this
("xfs: sanity check directory inode di_size").

This test may be merged before the fix patch.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 tests/xfs/348     |  16 ++++++++
 tests/xfs/348.out | 112 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 128 insertions(+)

diff --git a/tests/xfs/348 b/tests/xfs/348
index c5249eb..30825a4 100755
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
@@ -120,6 +124,18 @@ for dt in $dtypes; do
 		_scratch_xfs_repair -n 2>&1 | grep -q -v "^would fix ftype mismatch" || \
 			_fail "xfs_repair should not fix ftype mismatch"
 	fi
+
+	_scratch_mount
+	for file in DIR DATA EMPTY SYMLINK CHRDEV BLKDEV FIFO; do
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
index 31cf415..805d530 100644
--- a/tests/xfs/348.out
+++ b/tests/xfs/348.out
@@ -23,6 +23,13 @@ would have junked entry "DIR" in directory PARENT_INO
 would have junked entry "EMPTY" in directory PARENT_INO
 would have junked entry "FIFO" in directory PARENT_INO
 would have junked entry "SYMLINK" in directory PARENT_INO
+stat: cannot stat 'SCRATCH_MNT/test/DIR': Structure needs cleaning
+stat: cannot stat 'SCRATCH_MNT/test/DATA': Structure needs cleaning
+stat: cannot stat 'SCRATCH_MNT/test/EMPTY': Structure needs cleaning
+stat: cannot stat 'SCRATCH_MNT/test/SYMLINK': Structure needs cleaning
+stat: cannot stat 'SCRATCH_MNT/test/CHRDEV': Structure needs cleaning
+stat: cannot stat 'SCRATCH_MNT/test/BLKDEV': Structure needs cleaning
+stat: cannot stat 'SCRATCH_MNT/test/FIFO': Structure needs cleaning
 
 ===== Setting dt=1 to all files:
 core.mode = 010644
@@ -36,6 +43,13 @@ would have junked entry "DATA" in directory PARENT_INO
 would have junked entry "DIR" in directory PARENT_INO
 would have junked entry "EMPTY" in directory PARENT_INO
 would have junked entry "SYMLINK" in directory PARENT_INO
+stat: cannot stat 'SCRATCH_MNT/test/DIR': Structure needs cleaning
+stat: cannot stat 'SCRATCH_MNT/test/DATA': Structure needs cleaning
+stat: cannot stat 'SCRATCH_MNT/test/EMPTY': Structure needs cleaning
+stat: cannot stat 'SCRATCH_MNT/test/SYMLINK': Structure needs cleaning
+stat: 'SCRATCH_MNT/test/CHRDEV' is a fifo
+stat: 'SCRATCH_MNT/test/BLKDEV' is a fifo
+stat: 'SCRATCH_MNT/test/FIFO' is a fifo
 
 ===== Setting dt=2 to all files:
 core.mode = 020644
@@ -49,6 +63,13 @@ would have junked entry "DATA" in directory PARENT_INO
 would have junked entry "DIR" in directory PARENT_INO
 would have junked entry "EMPTY" in directory PARENT_INO
 would have junked entry "SYMLINK" in directory PARENT_INO
+stat: cannot stat 'SCRATCH_MNT/test/DIR': Structure needs cleaning
+stat: cannot stat 'SCRATCH_MNT/test/DATA': Structure needs cleaning
+stat: cannot stat 'SCRATCH_MNT/test/EMPTY': Structure needs cleaning
+stat: cannot stat 'SCRATCH_MNT/test/SYMLINK': Structure needs cleaning
+stat: 'SCRATCH_MNT/test/CHRDEV' is a character special file
+stat: 'SCRATCH_MNT/test/BLKDEV' is a character special file
+stat: 'SCRATCH_MNT/test/FIFO' is a character special file
 
 ===== Setting dt=3 to all files:
 core.mode = 030644
@@ -65,6 +86,13 @@ would have junked entry "DIR" in directory PARENT_INO
 would have junked entry "EMPTY" in directory PARENT_INO
 would have junked entry "FIFO" in directory PARENT_INO
 would have junked entry "SYMLINK" in directory PARENT_INO
+stat: cannot stat 'SCRATCH_MNT/test/DIR': Structure needs cleaning
+stat: cannot stat 'SCRATCH_MNT/test/DATA': Structure needs cleaning
+stat: cannot stat 'SCRATCH_MNT/test/EMPTY': Structure needs cleaning
+stat: cannot stat 'SCRATCH_MNT/test/SYMLINK': Structure needs cleaning
+stat: cannot stat 'SCRATCH_MNT/test/CHRDEV': Structure needs cleaning
+stat: cannot stat 'SCRATCH_MNT/test/BLKDEV': Structure needs cleaning
+stat: cannot stat 'SCRATCH_MNT/test/FIFO': Structure needs cleaning
 
 ===== Setting dt=4 to all files:
 core.mode = 040644
@@ -79,6 +107,13 @@ would have junked entry "CHRDEV" in directory PARENT_INO
 would have junked entry "DATA" in directory PARENT_INO
 would have junked entry "EMPTY" in directory PARENT_INO
 would have junked entry "FIFO" in directory PARENT_INO
+stat: 'SCRATCH_MNT/test/DIR' is a directory
+stat: 'SCRATCH_MNT/test/DATA' is a directory
+stat: cannot stat 'SCRATCH_MNT/test/EMPTY': Structure needs cleaning
+stat: 'SCRATCH_MNT/test/SYMLINK' is a directory
+stat: cannot stat 'SCRATCH_MNT/test/CHRDEV': Structure needs cleaning
+stat: cannot stat 'SCRATCH_MNT/test/BLKDEV': Structure needs cleaning
+stat: cannot stat 'SCRATCH_MNT/test/FIFO': Structure needs cleaning
 
 ===== Setting dt=5 to all files:
 core.mode = 050644
@@ -95,6 +130,13 @@ would have junked entry "DIR" in directory PARENT_INO
 would have junked entry "EMPTY" in directory PARENT_INO
 would have junked entry "FIFO" in directory PARENT_INO
 would have junked entry "SYMLINK" in directory PARENT_INO
+stat: cannot stat 'SCRATCH_MNT/test/DIR': Structure needs cleaning
+stat: cannot stat 'SCRATCH_MNT/test/DATA': Structure needs cleaning
+stat: cannot stat 'SCRATCH_MNT/test/EMPTY': Structure needs cleaning
+stat: cannot stat 'SCRATCH_MNT/test/SYMLINK': Structure needs cleaning
+stat: cannot stat 'SCRATCH_MNT/test/CHRDEV': Structure needs cleaning
+stat: cannot stat 'SCRATCH_MNT/test/BLKDEV': Structure needs cleaning
+stat: cannot stat 'SCRATCH_MNT/test/FIFO': Structure needs cleaning
 
 ===== Setting dt=6 to all files:
 core.mode = 060644
@@ -108,6 +150,13 @@ would have junked entry "DATA" in directory PARENT_INO
 would have junked entry "DIR" in directory PARENT_INO
 would have junked entry "EMPTY" in directory PARENT_INO
 would have junked entry "SYMLINK" in directory PARENT_INO
+stat: cannot stat 'SCRATCH_MNT/test/DIR': Structure needs cleaning
+stat: cannot stat 'SCRATCH_MNT/test/DATA': Structure needs cleaning
+stat: cannot stat 'SCRATCH_MNT/test/EMPTY': Structure needs cleaning
+stat: cannot stat 'SCRATCH_MNT/test/SYMLINK': Structure needs cleaning
+stat: 'SCRATCH_MNT/test/CHRDEV' is a block special file
+stat: 'SCRATCH_MNT/test/BLKDEV' is a block special file
+stat: 'SCRATCH_MNT/test/FIFO' is a block special file
 
 ===== Setting dt=7 to all files:
 core.mode = 070644
@@ -124,6 +173,13 @@ would have junked entry "DIR" in directory PARENT_INO
 would have junked entry "EMPTY" in directory PARENT_INO
 would have junked entry "FIFO" in directory PARENT_INO
 would have junked entry "SYMLINK" in directory PARENT_INO
+stat: cannot stat 'SCRATCH_MNT/test/DIR': Structure needs cleaning
+stat: cannot stat 'SCRATCH_MNT/test/DATA': Structure needs cleaning
+stat: cannot stat 'SCRATCH_MNT/test/EMPTY': Structure needs cleaning
+stat: cannot stat 'SCRATCH_MNT/test/SYMLINK': Structure needs cleaning
+stat: cannot stat 'SCRATCH_MNT/test/CHRDEV': Structure needs cleaning
+stat: cannot stat 'SCRATCH_MNT/test/BLKDEV': Structure needs cleaning
+stat: cannot stat 'SCRATCH_MNT/test/FIFO': Structure needs cleaning
 
 ===== Setting dt=10 to all files:
 core.mode = 0100644
@@ -138,6 +194,13 @@ would have junked entry "CHRDEV" in directory PARENT_INO
 would have junked entry "DIR" in directory PARENT_INO
 would have junked entry "FIFO" in directory PARENT_INO
 would have junked entry "SYMLINK" in directory PARENT_INO
+stat: cannot stat 'SCRATCH_MNT/test/DIR': Structure needs cleaning
+stat: 'SCRATCH_MNT/test/DATA' is a regular file
+stat: 'SCRATCH_MNT/test/EMPTY' is a regular empty file
+stat: cannot stat 'SCRATCH_MNT/test/SYMLINK': Structure needs cleaning
+stat: cannot stat 'SCRATCH_MNT/test/CHRDEV': Structure needs cleaning
+stat: cannot stat 'SCRATCH_MNT/test/BLKDEV': Structure needs cleaning
+stat: cannot stat 'SCRATCH_MNT/test/FIFO': Structure needs cleaning
 
 ===== Setting dt=11 to all files:
 core.mode = 0110644
@@ -154,6 +217,13 @@ would have junked entry "DIR" in directory PARENT_INO
 would have junked entry "EMPTY" in directory PARENT_INO
 would have junked entry "FIFO" in directory PARENT_INO
 would have junked entry "SYMLINK" in directory PARENT_INO
+stat: cannot stat 'SCRATCH_MNT/test/DIR': Structure needs cleaning
+stat: cannot stat 'SCRATCH_MNT/test/DATA': Structure needs cleaning
+stat: cannot stat 'SCRATCH_MNT/test/EMPTY': Structure needs cleaning
+stat: cannot stat 'SCRATCH_MNT/test/SYMLINK': Structure needs cleaning
+stat: cannot stat 'SCRATCH_MNT/test/CHRDEV': Structure needs cleaning
+stat: cannot stat 'SCRATCH_MNT/test/BLKDEV': Structure needs cleaning
+stat: cannot stat 'SCRATCH_MNT/test/FIFO': Structure needs cleaning
 
 ===== Setting dt=12 to all files:
 core.mode = 0120644
@@ -169,6 +239,13 @@ would have junked entry "DATA" in directory PARENT_INO
 would have junked entry "DIR" in directory PARENT_INO
 would have junked entry "EMPTY" in directory PARENT_INO
 would have junked entry "FIFO" in directory PARENT_INO
+stat: 'SCRATCH_MNT/test/DIR' is a symbolic link
+stat: 'SCRATCH_MNT/test/DATA' is a symbolic link
+stat: cannot stat 'SCRATCH_MNT/test/EMPTY': Structure needs cleaning
+stat: 'SCRATCH_MNT/test/SYMLINK' is a symbolic link
+stat: cannot stat 'SCRATCH_MNT/test/CHRDEV': Structure needs cleaning
+stat: cannot stat 'SCRATCH_MNT/test/BLKDEV': Structure needs cleaning
+stat: cannot stat 'SCRATCH_MNT/test/FIFO': Structure needs cleaning
 
 ===== Setting dt=13 to all files:
 core.mode = 0130644
@@ -185,6 +262,13 @@ would have junked entry "DIR" in directory PARENT_INO
 would have junked entry "EMPTY" in directory PARENT_INO
 would have junked entry "FIFO" in directory PARENT_INO
 would have junked entry "SYMLINK" in directory PARENT_INO
+stat: cannot stat 'SCRATCH_MNT/test/DIR': Structure needs cleaning
+stat: cannot stat 'SCRATCH_MNT/test/DATA': Structure needs cleaning
+stat: cannot stat 'SCRATCH_MNT/test/EMPTY': Structure needs cleaning
+stat: cannot stat 'SCRATCH_MNT/test/SYMLINK': Structure needs cleaning
+stat: cannot stat 'SCRATCH_MNT/test/CHRDEV': Structure needs cleaning
+stat: cannot stat 'SCRATCH_MNT/test/BLKDEV': Structure needs cleaning
+stat: cannot stat 'SCRATCH_MNT/test/FIFO': Structure needs cleaning
 
 ===== Setting dt=14 to all files:
 core.mode = 0140644
@@ -198,6 +282,13 @@ would have junked entry "DATA" in directory PARENT_INO
 would have junked entry "DIR" in directory PARENT_INO
 would have junked entry "EMPTY" in directory PARENT_INO
 would have junked entry "SYMLINK" in directory PARENT_INO
+stat: cannot stat 'SCRATCH_MNT/test/DIR': Structure needs cleaning
+stat: cannot stat 'SCRATCH_MNT/test/DATA': Structure needs cleaning
+stat: cannot stat 'SCRATCH_MNT/test/EMPTY': Structure needs cleaning
+stat: cannot stat 'SCRATCH_MNT/test/SYMLINK': Structure needs cleaning
+stat: 'SCRATCH_MNT/test/CHRDEV' is a socket
+stat: 'SCRATCH_MNT/test/BLKDEV' is a socket
+stat: 'SCRATCH_MNT/test/FIFO' is a socket
 
 ===== Setting dt=15 to all files:
 core.mode = 0150644
@@ -214,6 +305,13 @@ would have junked entry "DIR" in directory PARENT_INO
 would have junked entry "EMPTY" in directory PARENT_INO
 would have junked entry "FIFO" in directory PARENT_INO
 would have junked entry "SYMLINK" in directory PARENT_INO
+stat: cannot stat 'SCRATCH_MNT/test/DIR': Structure needs cleaning
+stat: cannot stat 'SCRATCH_MNT/test/DATA': Structure needs cleaning
+stat: cannot stat 'SCRATCH_MNT/test/EMPTY': Structure needs cleaning
+stat: cannot stat 'SCRATCH_MNT/test/SYMLINK': Structure needs cleaning
+stat: cannot stat 'SCRATCH_MNT/test/CHRDEV': Structure needs cleaning
+stat: cannot stat 'SCRATCH_MNT/test/BLKDEV': Structure needs cleaning
+stat: cannot stat 'SCRATCH_MNT/test/FIFO': Structure needs cleaning
 
 ===== Setting dt=16 to all files:
 core.mode = 0160644
@@ -230,6 +328,13 @@ would have junked entry "DIR" in directory PARENT_INO
 would have junked entry "EMPTY" in directory PARENT_INO
 would have junked entry "FIFO" in directory PARENT_INO
 would have junked entry "SYMLINK" in directory PARENT_INO
+stat: cannot stat 'SCRATCH_MNT/test/DIR': Structure needs cleaning
+stat: cannot stat 'SCRATCH_MNT/test/DATA': Structure needs cleaning
+stat: cannot stat 'SCRATCH_MNT/test/EMPTY': Structure needs cleaning
+stat: cannot stat 'SCRATCH_MNT/test/SYMLINK': Structure needs cleaning
+stat: cannot stat 'SCRATCH_MNT/test/CHRDEV': Structure needs cleaning
+stat: cannot stat 'SCRATCH_MNT/test/BLKDEV': Structure needs cleaning
+stat: cannot stat 'SCRATCH_MNT/test/FIFO': Structure needs cleaning
 
 ===== Setting dt=17 to all files:
 core.mode = 0170644
@@ -246,3 +351,10 @@ would have junked entry "DIR" in directory PARENT_INO
 would have junked entry "EMPTY" in directory PARENT_INO
 would have junked entry "FIFO" in directory PARENT_INO
 would have junked entry "SYMLINK" in directory PARENT_INO
+stat: cannot stat 'SCRATCH_MNT/test/DIR': Structure needs cleaning
+stat: cannot stat 'SCRATCH_MNT/test/DATA': Structure needs cleaning
+stat: cannot stat 'SCRATCH_MNT/test/EMPTY': Structure needs cleaning
+stat: cannot stat 'SCRATCH_MNT/test/SYMLINK': Structure needs cleaning
+stat: cannot stat 'SCRATCH_MNT/test/CHRDEV': Structure needs cleaning
+stat: cannot stat 'SCRATCH_MNT/test/BLKDEV': Structure needs cleaning
+stat: cannot stat 'SCRATCH_MNT/test/FIFO': Structure needs cleaning
-- 
2.7.4

