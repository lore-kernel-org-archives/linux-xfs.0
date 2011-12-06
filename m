Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pB63frkm177877
	for <linux-xfs@oss.sgi.com>; Mon, 5 Dec 2011 21:41:54 -0600
Received: from song.cn.fujitsu.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 68CC61F440EE
	for <linux-xfs@oss.sgi.com>; Mon,  5 Dec 2011 19:41:49 -0800 (PST)
Received: from song.cn.fujitsu.com (cn.fujitsu.com [222.73.24.84]) by
	cuda.sgi.com with ESMTP id mp5AwRPEOFVlFxqh for
	<linux-xfs@oss.sgi.com>; Mon, 05 Dec 2011 19:41:49 -0800 (PST)
Message-ID: <4EDD8F16.4050402@cn.fujitsu.com>
Date: Tue, 06 Dec 2011 11:42:14 +0800
From: Peng Haitao <penght@cn.fujitsu.com>
MIME-Version: 1.0
Subject: [PATCH] xfstests/071 FAIL with pwrite64: Invalid argument
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: hch@infradead.org
Cc: linux-xfs@oss.sgi.com


When offset + length is overflow of xfs_io builtin pread and pwrite in linux,
the error message should be "Invalid argument".

Signed-off-by: Peng Haitao <penght@cn.fujitsu.com>
---
 071           |    3 +
 071.out       |  107 ----------------------------------------------------
 071.out.irix  |  107 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 071.out.linux |  117 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 227 insertions(+), 107 deletions(-)
 delete mode 100644 071.out
 create mode 100644 071.out.irix
 create mode 100644 071.out.linux

diff --git a/071 b/071
index be9b11b..0693bd7 100755
--- a/071
+++ b/071
@@ -91,6 +91,9 @@ _scratch_mkfs_xfs | _filter_mkfs 2>$tmp.mkfs
 echo
 _scratch_mount
 
+# link correct .out file
+_link_out_file $seq.out
+
 # Okay... filesize limit depends on blocksize, bits per long and
 # also if large block device patch is enabled (can't dynamically
 # check that, so use env var USE_LBD_PATCH to override default).
diff --git a/071.out b/071.out
deleted file mode 100644
index 2ea0ef0..0000000
--- a/071.out
+++ /dev/null
@@ -1,107 +0,0 @@
-QA output created by 071
-meta-data=DDEV isize=XXX agcount=N, agsize=XXX blks
-data     = bsize=XXX blocks=XXX, imaxpct=PCT
-         = sunit=XXX swidth=XXX, unwritten=X
-naming   =VERN bsize=XXX
-log      =LDEV bsize=XXX blocks=XXX
-realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX
-
-Writing 512 bytes, offset is +0 (direct=false)
-wrote 512/512 bytes at offset <OFFSET>
-Reading 512 bytes (direct=false)
-read 512/512 bytes at offset <OFFSET>
-
-Writing 512 bytes, offset is minus 1 byte (direct=false)
-wrote 512/512 bytes at offset <OFFSET>
-Reading 512 bytes (direct=false)
-read 512/512 bytes at offset <OFFSET>
-
-Writing 512 bytes, offset is minus 1FSB (direct=false)
-wrote 512/512 bytes at offset <OFFSET>
-Reading 512 bytes (direct=false)
-read 512/512 bytes at offset <OFFSET>
-
-Writing 1 bytes, offset is minus 1FSB (direct=false)
-wrote 512/512 bytes at offset <OFFSET>
-Reading 1 bytes (direct=false)
-read 1/1 bytes at offset <OFFSET>
-
-Writing 1FSB bytes, offset is +0 (direct=true)
-wrote 512/512 bytes at offset <OFFSET>
-Reading 1FSB bytes (direct=true)
-read 512/1FSB bytes at offset <OFFSET>
-
-Writing 1FSB bytes, offset is minus 1FSB (direct=true)
-wrote 512/512 bytes at offset <OFFSET>
-Reading 1FSB bytes (direct=true)
-read 513/1FSB bytes at offset <OFFSET>
-
-=== Iterating, 2 remains
-
-
-Writing 512 bytes, offset is +0 (direct=false)
-pwrite64: File too large
-Reading 512 bytes (direct=false)
-read 0/512 bytes at offset <OFFSET>
-
-Writing 512 bytes, offset is minus 1 byte (direct=false)
-pwrite64: File too large
-Reading 512 bytes (direct=false)
-read 0/512 bytes at offset <OFFSET>
-
-Writing 512 bytes, offset is minus 1FSB (direct=false)
-wrote 512/512 bytes at offset <OFFSET>
-Reading 512 bytes (direct=false)
-read 512/512 bytes at offset <OFFSET>
-
-Writing 1 bytes, offset is minus 1FSB (direct=false)
-wrote 512/512 bytes at offset <OFFSET>
-Reading 1 bytes (direct=false)
-read 1/1 bytes at offset <OFFSET>
-
-Writing 1FSB bytes, offset is +0 (direct=true)
-pwrite64: File too large
-Reading 1FSB bytes (direct=true)
-read 0/1FSB bytes at offset <OFFSET>
-
-Writing 1FSB bytes, offset is minus 1FSB (direct=true)
-pwrite64: File too large
-Reading 1FSB bytes (direct=true)
-read 0/1FSB bytes at offset <OFFSET>
-
-=== Iterating, 1 remains
-
-
-Writing 512 bytes, offset is +0 (direct=false)
-pwrite64: File too large
-Reading 512 bytes (direct=false)
-read 0/512 bytes at offset <OFFSET>
-
-Writing 512 bytes, offset is minus 1 byte (direct=false)
-pwrite64: File too large
-Reading 512 bytes (direct=false)
-read 0/512 bytes at offset <OFFSET>
-
-Writing 512 bytes, offset is minus 1FSB (direct=false)
-pwrite64: File too large
-Reading 512 bytes (direct=false)
-read 0/512 bytes at offset <OFFSET>
-
-Writing 1 bytes, offset is minus 1FSB (direct=false)
-pwrite64: File too large
-Reading 1 bytes (direct=false)
-read 0/1 bytes at offset <OFFSET>
-
-Writing 1FSB bytes, offset is +0 (direct=true)
-pwrite64: File too large
-Reading 1FSB bytes (direct=true)
-read 0/1FSB bytes at offset <OFFSET>
-
-Writing 1FSB bytes, offset is minus 1FSB (direct=true)
-pwrite64: File too large
-Reading 1FSB bytes (direct=true)
-read 0/1FSB bytes at offset <OFFSET>
-
-=== Iterating, 0 remains
-
-
diff --git a/071.out.irix b/071.out.irix
new file mode 100644
index 0000000..2ea0ef0
--- /dev/null
+++ b/071.out.irix
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
diff --git a/071.out.linux b/071.out.linux
new file mode 100644
index 0000000..56a7b47
--- /dev/null
+++ b/071.out.linux
@@ -0,0 +1,117 @@
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
+pwrite64: Invalid argument
+Reading 512 bytes (direct=false)
+pread64: Invalid argument
+pread64: Invalid argument
+
+Writing 512 bytes, offset is minus 1 byte (direct=false)
+pwrite64: Invalid argument
+Reading 512 bytes (direct=false)
+pread64: Invalid argument
+pread64: Invalid argument
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
+pwrite64: Invalid argument
+Reading 1FSB bytes (direct=true)
+pread64: Invalid argument
+pread64: Invalid argument
+
+Writing 1FSB bytes, offset is minus 1FSB (direct=true)
+pwrite64: Invalid argument
+Reading 1FSB bytes (direct=true)
+pread64: Invalid argument
+pread64: Invalid argument
+
+=== Iterating, 1 remains
+
+
+Writing 512 bytes, offset is +0 (direct=false)
+pwrite64: Invalid argument
+Reading 512 bytes (direct=false)
+pread64: Invalid argument
+pread64: Invalid argument
+
+Writing 512 bytes, offset is minus 1 byte (direct=false)
+pwrite64: Invalid argument
+Reading 512 bytes (direct=false)
+pread64: Invalid argument
+pread64: Invalid argument
+
+Writing 512 bytes, offset is minus 1FSB (direct=false)
+pwrite64: Invalid argument
+Reading 512 bytes (direct=false)
+pread64: Invalid argument
+pread64: Invalid argument
+
+Writing 1 bytes, offset is minus 1FSB (direct=false)
+pwrite64: Invalid argument
+Reading 1 bytes (direct=false)
+pread64: Invalid argument
+pread64: Invalid argument
+
+Writing 1FSB bytes, offset is +0 (direct=true)
+pwrite64: Invalid argument
+Reading 1FSB bytes (direct=true)
+pread64: Invalid argument
+pread64: Invalid argument
+
+Writing 1FSB bytes, offset is minus 1FSB (direct=true)
+pwrite64: Invalid argument
+Reading 1FSB bytes (direct=true)
+pread64: Invalid argument
+pread64: Invalid argument
+
+=== Iterating, 0 remains
+
+
-- 
1.7.1

-- 
Best Regards,
Peng Haitao

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
