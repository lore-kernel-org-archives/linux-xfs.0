Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2F2QrJD033112 for <xfs@oss.sgi.com>; Wed, 14 Mar 2012 21:26:54 -0500
Received: from song.cn.fujitsu.com (cn.fujitsu.com [222.73.24.84]) by
	cuda.sgi.com with ESMTP id LNIHD6hTi7BK8ZJU for
	<xfs@oss.sgi.com>; Wed, 14 Mar 2012 19:26:49 -0700 (PDT)
From: Peng Haitao <penght@cn.fujitsu.com>
Subject: [PATCH v2] xfstests/071 FAIL with pwrite64: Invalid argument
Date: Thu, 15 Mar 2012 10:25:46 +0800
Message-Id: <1331778346-10596-1-git-send-email-penght@cn.fujitsu.com>
In-Reply-To: <20120104165341.GA21075@infradead.org>
References: <20120104165341.GA21075@infradead.org>
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
To: hch@infradead.org, david@fromorbit.com
Cc: xfs@oss.sgi.com

When offset + length is overflow of xfs_io builtin pread and pwrite in linux,
the error message should be "Invalid argument".

In 32_bit, offset + length should cause pread and pwrite to error, So the
out should be OK.

The patch fix as following:
  - "pwrite64: Invalid argument" will be replaced with "pwrite64: File too large"
  - "pread64: Invalid argument" will be replaced with "read 0/xxx bytes at offset <OFFSET>"
  - delete _filter_xfs_io
  - add auto group
  - add 071.out.32

Signed-off-by: Peng Haitao <penght@cn.fujitsu.com>
---
 071        |   30 +++++++++++++----
 071.out.32 |  107 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 071.out.64 |  107 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 group      |    2 +-
 4 files changed, 239 insertions(+), 7 deletions(-)
 create mode 100644 071.out.32
 create mode 100644 071.out.64

diff --git a/071 b/071
index be9b11b..ace0ee4 100755
--- a/071
+++ b/071
@@ -43,6 +43,15 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 . ./common.rc
 . ./common.filter
 
+bitsperlong=`src/feature -w`
+# link correct .out file
+rm -f $seq.out
+if [ "$bitsperlong" -eq 32 ]; then
+	ln -s $seq.out.32 $seq.out
+else
+	ln -s $seq.out.64 $seq.out
+fi
+
 _filter_io()
 {
     sed -e "s/$dbsize/1FSB/g" -e '/.* ops; /d'
@@ -53,6 +62,16 @@ _filter_off()
     sed -e "s/$1/<OFFSET>/g" | _filter_io
 }
 
+_filter_pwrite()
+{
+	sed -e "s/pwrite64: Invalid argument/pwrite64: File too large/g"
+}
+
+_filter_pread()
+{
+	sed -e "s/pread64: Invalid argument/read 0\/$bytes bytes at offset <OFFSET>/g" | _filter_io
+}
+
 write_block()
 {
     location=$1
@@ -66,15 +85,15 @@ write_block()
     echo "Writing $bytes bytes, offset is $words (direct=$direct)" | _filter_io
     echo "Writing $bytes bytes at $location $words (direct=$direct)" >>$seq.full
     $XFS_IO_PROG -c "pwrite $offset 512" $flags $SCRATCH_MNT/$seq \
-	2>&1 | _filter_off $offset | _filter_xfs_io | tee -a $seq.full
+	2>&1 | _filter_off $offset | tee -a $seq.full | _filter_pwrite
     xfs_bmap -v $SCRATCH_MNT/$seq >>$seq.full
 
     echo "Reading $bytes bytes (direct=$direct)" | _filter_io
     echo "Reading $bytes bytes at $location (direct=$direct)" >>$seq.full
     $XFS_IO_PROG -c "pread $offset $bytes" $flags $SCRATCH_MNT/$seq \
-	2>&1 | _filter_off $offset | _filter_xfs_io | tee -a $seq.full
+	2>&1 | _filter_off $offset | tee -a $seq.full | _filter_pread
 
-    $XFS_IO_PROG -c "pread -v $offset $bytes" $flags $SCRATCH_MNT/$seq >>$seq.full
+    $XFS_IO_PROG -c "pread -v $offset $bytes" $flags $SCRATCH_MNT/$seq >>$seq.full 2>&1
 
     echo | tee -a $seq.full
 }
@@ -94,7 +113,7 @@ _scratch_mount
 # Okay... filesize limit depends on blocksize, bits per long and
 # also if large block device patch is enabled (can't dynamically
 # check that, so use env var USE_LBD_PATCH to override default).
-# 
+#
 # Note:
 # We check from 1Tb below our guessed limit to 1Tb above it, and
 # see what happens for each 1Tb increment along the way (first
@@ -102,14 +121,13 @@ _scratch_mount
 # So, number calculated here is not the actual limit, its a ways
 # above that, hopefully.
 
-bitsperlong=`src/feature -w`
 if [ "$bitsperlong" -eq 32 ]; then
     upperbound=`expr $dbsize / 512`
     # which is 8(TB) for 4K, 4(TB) for 2k, ... etc.
     [ "$USE_LBD_PATCH" = yes ] && upperbound=16
     # limited by page cache index when LBD patch onboard.
 else
-    upperbound=`echo 8 \* 1024 \* 1024 | bc` 
+    upperbound=`echo 8 \* 1024 \* 1024 | bc`
     # 8 exabytes (working in TBs below)
 fi
 
diff --git a/071.out.32 b/071.out.32
new file mode 100644
index 0000000..48b8575
--- /dev/null
+++ b/071.out.32
@@ -0,0 +1,107 @@
+QA output created by 071
+meta-data=DDEV isize=XXX agcount=N, agsize=XXX blks
+data     = bsize=XXX blocks=XXX, imaxpct=PCT
+         = sunit=XXX swidth=XXX, unwritten=X
+naming   =VERN bsize=XXX
+log      =LDEV bsize=XXX blocks=XXX
+realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX
+
+Writing 512 bytes, offset is +0 (direct=false)
+wrote 512/512 bytes at offset <OFFSET>
+Reading 512 bytes (direct=false)
+read 512/512 bytes at offset <OFFSET>
+
+Writing 512 bytes, offset is minus 1 byte (direct=false)
+wrote 512/512 bytes at offset <OFFSET>
+Reading 512 bytes (direct=false)
+read 512/512 bytes at offset <OFFSET>
+
+Writing 512 bytes, offset is minus 1FSB (direct=false)
+wrote 512/512 bytes at offset <OFFSET>
+Reading 512 bytes (direct=false)
+read 512/512 bytes at offset <OFFSET>
+
+Writing 1 bytes, offset is minus 1FSB (direct=false)
+wrote 512/512 bytes at offset <OFFSET>
+Reading 1 bytes (direct=false)
+read 1/1 bytes at offset <OFFSET>
+
+Writing 1FSB bytes, offset is +0 (direct=true)
+wrote 512/512 bytes at offset <OFFSET>
+Reading 1FSB bytes (direct=true)
+read 512/1FSB bytes at offset <OFFSET>
+
+Writing 1FSB bytes, offset is minus 1FSB (direct=true)
+wrote 512/512 bytes at offset <OFFSET>
+Reading 1FSB bytes (direct=true)
+read 513/1FSB bytes at offset <OFFSET>
+
+=== Iterating, 2 remains
+
+
+Writing 512 bytes, offset is +0 (direct=false)
+wrote 512/512 bytes at offset <OFFSET>
+Reading 512 bytes (direct=false)
+read 512/512 bytes at offset <OFFSET>
+
+Writing 512 bytes, offset is minus 1 byte (direct=false)
+wrote 512/512 bytes at offset <OFFSET>
+Reading 512 bytes (direct=false)
+read 512/512 bytes at offset <OFFSET>
+
+Writing 512 bytes, offset is minus 1FSB (direct=false)
+wrote 512/512 bytes at offset <OFFSET>
+Reading 512 bytes (direct=false)
+read 512/512 bytes at offset <OFFSET>
+
+Writing 1 bytes, offset is minus 1FSB (direct=false)
+wrote 512/512 bytes at offset <OFFSET>
+Reading 1 bytes (direct=false)
+read 1/1 bytes at offset <OFFSET>
+
+Writing 1FSB bytes, offset is +0 (direct=true)
+wrote 512/512 bytes at offset <OFFSET>
+Reading 1FSB bytes (direct=true)
+read 512/1FSB bytes at offset <OFFSET>
+
+Writing 1FSB bytes, offset is minus 1FSB (direct=true)
+wrote 512/512 bytes at offset <OFFSET>
+Reading 1FSB bytes (direct=true)
+read 513/1FSB bytes at offset <OFFSET>
+
+=== Iterating, 1 remains
+
+
+Writing 512 bytes, offset is +0 (direct=false)
+wrote 512/512 bytes at offset <OFFSET>
+Reading 512 bytes (direct=false)
+read 512/512 bytes at offset <OFFSET>
+
+Writing 512 bytes, offset is minus 1 byte (direct=false)
+wrote 512/512 bytes at offset <OFFSET>
+Reading 512 bytes (direct=false)
+read 512/512 bytes at offset <OFFSET>
+
+Writing 512 bytes, offset is minus 1FSB (direct=false)
+wrote 512/512 bytes at offset <OFFSET>
+Reading 512 bytes (direct=false)
+read 512/512 bytes at offset <OFFSET>
+
+Writing 1 bytes, offset is minus 1FSB (direct=false)
+wrote 512/512 bytes at offset <OFFSET>
+Reading 1 bytes (direct=false)
+read 1/1 bytes at offset <OFFSET>
+
+Writing 1FSB bytes, offset is +0 (direct=true)
+wrote 512/512 bytes at offset <OFFSET>
+Reading 1FSB bytes (direct=true)
+read 512/1FSB bytes at offset <OFFSET>
+
+Writing 1FSB bytes, offset is minus 1FSB (direct=true)
+wrote 512/512 bytes at offset <OFFSET>
+Reading 1FSB bytes (direct=true)
+read 513/1FSB bytes at offset <OFFSET>
+
+=== Iterating, 0 remains
+
+
diff --git a/071.out.64 b/071.out.64
new file mode 100644
index 0000000..2ea0ef0
--- /dev/null
+++ b/071.out.64
@@ -0,0 +1,107 @@
+QA output created by 071
+meta-data=DDEV isize=XXX agcount=N, agsize=XXX blks
+data     = bsize=XXX blocks=XXX, imaxpct=PCT
+         = sunit=XXX swidth=XXX, unwritten=X
+naming   =VERN bsize=XXX
+log      =LDEV bsize=XXX blocks=XXX
+realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX
+
+Writing 512 bytes, offset is +0 (direct=false)
+wrote 512/512 bytes at offset <OFFSET>
+Reading 512 bytes (direct=false)
+read 512/512 bytes at offset <OFFSET>
+
+Writing 512 bytes, offset is minus 1 byte (direct=false)
+wrote 512/512 bytes at offset <OFFSET>
+Reading 512 bytes (direct=false)
+read 512/512 bytes at offset <OFFSET>
+
+Writing 512 bytes, offset is minus 1FSB (direct=false)
+wrote 512/512 bytes at offset <OFFSET>
+Reading 512 bytes (direct=false)
+read 512/512 bytes at offset <OFFSET>
+
+Writing 1 bytes, offset is minus 1FSB (direct=false)
+wrote 512/512 bytes at offset <OFFSET>
+Reading 1 bytes (direct=false)
+read 1/1 bytes at offset <OFFSET>
+
+Writing 1FSB bytes, offset is +0 (direct=true)
+wrote 512/512 bytes at offset <OFFSET>
+Reading 1FSB bytes (direct=true)
+read 512/1FSB bytes at offset <OFFSET>
+
+Writing 1FSB bytes, offset is minus 1FSB (direct=true)
+wrote 512/512 bytes at offset <OFFSET>
+Reading 1FSB bytes (direct=true)
+read 513/1FSB bytes at offset <OFFSET>
+
+=== Iterating, 2 remains
+
+
+Writing 512 bytes, offset is +0 (direct=false)
+pwrite64: File too large
+Reading 512 bytes (direct=false)
+read 0/512 bytes at offset <OFFSET>
+
+Writing 512 bytes, offset is minus 1 byte (direct=false)
+pwrite64: File too large
+Reading 512 bytes (direct=false)
+read 0/512 bytes at offset <OFFSET>
+
+Writing 512 bytes, offset is minus 1FSB (direct=false)
+wrote 512/512 bytes at offset <OFFSET>
+Reading 512 bytes (direct=false)
+read 512/512 bytes at offset <OFFSET>
+
+Writing 1 bytes, offset is minus 1FSB (direct=false)
+wrote 512/512 bytes at offset <OFFSET>
+Reading 1 bytes (direct=false)
+read 1/1 bytes at offset <OFFSET>
+
+Writing 1FSB bytes, offset is +0 (direct=true)
+pwrite64: File too large
+Reading 1FSB bytes (direct=true)
+read 0/1FSB bytes at offset <OFFSET>
+
+Writing 1FSB bytes, offset is minus 1FSB (direct=true)
+pwrite64: File too large
+Reading 1FSB bytes (direct=true)
+read 0/1FSB bytes at offset <OFFSET>
+
+=== Iterating, 1 remains
+
+
+Writing 512 bytes, offset is +0 (direct=false)
+pwrite64: File too large
+Reading 512 bytes (direct=false)
+read 0/512 bytes at offset <OFFSET>
+
+Writing 512 bytes, offset is minus 1 byte (direct=false)
+pwrite64: File too large
+Reading 512 bytes (direct=false)
+read 0/512 bytes at offset <OFFSET>
+
+Writing 512 bytes, offset is minus 1FSB (direct=false)
+pwrite64: File too large
+Reading 512 bytes (direct=false)
+read 0/512 bytes at offset <OFFSET>
+
+Writing 1 bytes, offset is minus 1FSB (direct=false)
+pwrite64: File too large
+Reading 1 bytes (direct=false)
+read 0/1 bytes at offset <OFFSET>
+
+Writing 1FSB bytes, offset is +0 (direct=true)
+pwrite64: File too large
+Reading 1FSB bytes (direct=true)
+read 0/1FSB bytes at offset <OFFSET>
+
+Writing 1FSB bytes, offset is minus 1FSB (direct=true)
+pwrite64: File too large
+Reading 1FSB bytes (direct=true)
+read 0/1FSB bytes at offset <OFFSET>
+
+=== Iterating, 0 remains
+
+
diff --git a/group b/group
index 01f406d..2015bee 100644
--- a/group
+++ b/group
@@ -181,7 +181,7 @@ deprecated
 068 other auto
 069 rw udf auto quick
 070 attr udf auto quick
-071 rw
+071 rw auto
 072 rw auto prealloc quick
 073 copy auto
 074 rw udf auto
-- 
1.7.10.rc0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
