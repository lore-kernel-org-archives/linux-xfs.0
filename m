Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:42536 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932346AbeGDEu5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Jul 2018 00:50:57 -0400
Subject: [PATCH 1/7] generic/{279,
 28[1-3]}: hide SIGBUS reporting from golden output
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 03 Jul 2018 21:50:53 -0700
Message-ID: <153067985383.28393.15559670747546571392.stgit@magnolia>
In-Reply-To: <153067984748.28393.1595618163831671652.stgit@magnolia>
References: <153067984748.28393.1595618163831671652.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: guaneryu@gmail.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

These four tests check that mmap'd cow writes fail when the filesystem
goes down.  For regular filesystems the msync reports EIO, but if quotas
are enabled on xfs the write itself terminates xfs_io with a SIGBUS.  We
don't care how the write fails, so don't let the SIGBUS report escape to
the golden output.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/generic/279 |    6 ++++++
 tests/generic/281 |    6 ++++++
 tests/generic/282 |    9 ++++++++-
 tests/generic/283 |   14 ++++++++++----
 4 files changed, 30 insertions(+), 5 deletions(-)


diff --git a/tests/generic/279 b/tests/generic/279
index 1355c641..af699144 100755
--- a/tests/generic/279
+++ b/tests/generic/279
@@ -66,8 +66,14 @@ md5sum $testdir/file2 | _filter_scratch
 echo "CoW and unmount"
 sync
 _dmerror_load_error_table
+# Insulate ourselves against bash reporting the SIGBUS when we try to modify
+# the metadata.
+cat > $tmp.run << ENDL
+ulimit -c 0
 $XFS_IO_PROG -f -c "mmap -rw 0 $filesize" -c "mwrite -S 0x63 0 $filesize" \
 	-c "msync -s 0 $filesize" $testdir/file2 >> $seqres.full 2>&1
+ENDL
+bash $tmp.run 2> /dev/null
 _dmerror_load_working_table
 _dmerror_unmount
 _dmerror_mount
diff --git a/tests/generic/281 b/tests/generic/281
index 75c4b39a..75deab7c 100755
--- a/tests/generic/281
+++ b/tests/generic/281
@@ -66,8 +66,14 @@ md5sum $testdir/file2 | _filter_scratch
 echo "CoW and unmount"
 sync
 _dmerror_load_error_table
+# Insulate ourselves against bash reporting the SIGBUS when we try to modify
+# the metadata.
+cat > $tmp.run << ENDL
+ulimit -c 0
 $XFS_IO_PROG -f -c "mmap -rw 0 $filesize" -c "mwrite -S 0x63 0 $filesize" \
 	-c "msync -s 0 $filesize" $testdir/file2 >> $seqres.full 2>&1
+ENDL
+bash $tmp.run 2> /dev/null
 
 echo "Clean up the mess"
 _dmerror_unmount
diff --git a/tests/generic/282 b/tests/generic/282
index aea7ce58..44ffe278 100755
--- a/tests/generic/282
+++ b/tests/generic/282
@@ -66,7 +66,14 @@ md5sum $testdir/file2 | _filter_scratch
 echo "CoW and unmount"
 sync
 _dmerror_load_error_table
-$XFS_IO_PROG -f -c "mmap -rw 0 $filesize" -c "mwrite -S 0x63 0 $filesize" $testdir/file2 >> $seqres.full 2>&1
+# Insulate ourselves against bash reporting the SIGBUS when we try to modify
+# the metadata.
+cat > $tmp.run << ENDL
+ulimit -c 0
+$XFS_IO_PROG -f -c "mmap -rw 0 $filesize" \
+	-c "mwrite -S 0x63 0 $filesize" $testdir/file2 >> $seqres.full 2>&1
+ENDL
+bash $tmp.run 2> /dev/null
 _dmerror_load_working_table
 rm -rf $testdir/file2 >> $seqres.full 2>&1
 _dmerror_unmount
diff --git a/tests/generic/283 b/tests/generic/283
index 79caddb5..84a1666a 100755
--- a/tests/generic/283
+++ b/tests/generic/283
@@ -67,10 +67,16 @@ md5sum $testdir/file2 | _filter_scratch
 echo "CoW and unmount"
 sync
 _dmerror_load_error_table
-urk=$($XFS_IO_PROG -f -c "mmap -rw 0 $filesize" -c "mwrite -S 0x63 0 $filesize" \
-	-c "msync -s 0 $filesize" $testdir/file2 2>&1)
-echo $urk >> $seqres.full
-echo "$urk" | grep -q "error" || _fail "mwrite did not fail"
+# Insulate ourselves against bash reporting the SIGBUS when we try to modify
+# the metadata.
+cat > $tmp.run << ENDL
+ulimit -c 0
+$XFS_IO_PROG -f -c "mmap -rw 0 $filesize" -c "mwrite -S 0x63 0 $filesize" \
+	-c "msync -s 0 $filesize" $testdir/file2 2>&1
+ENDL
+bash $tmp.run > $tmp.output 2>&1
+cat $tmp.output >> $seqres.full
+grep -q error $tmp.output || _fail "mwrite did not fail"
 _dmerror_load_working_table
 
 echo "Rewrite"

