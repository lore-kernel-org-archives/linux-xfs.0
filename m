Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7AEbkLx063649 for <xfs@oss.sgi.com>; Mon, 10 Aug 2009 09:37:46 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 29A823B8AB3
	for <xfs@oss.sgi.com>; Mon, 10 Aug 2009 07:38:39 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id 3NV0HBCvcqGSAMYt for
	<xfs@oss.sgi.com>; Mon, 10 Aug 2009 07:38:39 -0700 (PDT)
Message-ID: <4A8030F1.9060004@sandeen.net>
Date: Mon, 10 Aug 2009 09:38:41 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH V2 1/2] xfstests: split out xfs & generic quota existence tests
References: <4A7C7C1C.2010202@redhat.com>
In-Reply-To: <4A7C7C1C.2010202@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

Split out xfs & generic quota existence tests

Make a new test to test for generic quota tools, for
generic filesystem testing.  Move the existing quota test
to a new "xfs" name.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

diff --git a/common.quota b/common.quota
index a9dfb42..e2a7872 100644
--- a/common.quota
+++ b/common.quota
@@ -21,14 +21,27 @@
 #
 
 #
-# checks that the XFS quota support in the kernel is enabled
+# checks that the generic quota support in the kernel is enabled
 # and that we have valid quota user tools installed.
 #
 _require_quota()
 {
+    [ -x /usr/bin/quota ] || _notrun "Quota user tools not installed"
+    _scratch_mount "-o usrquota,grpquota"
+    ret=$?
+    umount $SCRATCH_MNT
+    [ $ret -ne 0 ] && _notrun "Installed kernel does not support quota"
+}
+
+#
+# checks that the XFS quota support in the kernel is enabled
+# and that we have valid quota user tools installed.
+#
+_require_xfs_quota()
+{
     src/feature -q $TEST_DEV
     [ $? -ne 0 ] && _notrun "Installed kernel does not support XFS quota"
-    [ -x /usr/sbin/xfs_quota ] || _notrun "Quota user tools not installed"
+    [ -x /usr/sbin/xfs_quota ] || _notrun "XFS quota user tools not installed"
 }
 
 #diff --git a/050 b/050
index abb806a..306a7b5 100755
--- a/050
+++ b/050
@@ -55,7 +55,7 @@ cp /dev/null $seq.full
 chmod a+rwx $seq.full	# arbitrary users will write here
 
 _require_scratch
-_require_quota
+_require_xfs_quota
 
 bsoft=100
 bhard=500
diff --git a/052 b/052
index 16c78de..3d8bb9e 100755
--- a/052
+++ b/052
@@ -54,7 +54,7 @@ _supported_os IRIX Linux
 rm -f $seq.full
 
 _require_scratch
-_require_quota
+_require_xfs_quota
 _require_nobody
 
 # setup a default run
diff --git a/054 b/054
index b495e51..b38efab 100755
--- a/054
+++ b/054
@@ -52,7 +52,7 @@ cp /dev/null $seq.full
 chmod ugo+rwx $seq.full
 
 _require_scratch
-_require_quota
+_require_xfs_quota
 
 _filter_stat()
 {
diff --git a/081 b/081
index 3036484..c8eba80 100755
--- a/081
+++ b/081
@@ -54,7 +54,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 # prelim
 rm -f $seq.full $tmp.*
 _require_scratch
-_require_quota
+_require_xfs_quota
 _require_v2log
  
 echo "*** init FS"
diff --git a/106 b/106
index 7154979..30f740b 100755
--- a/106
+++ b/106
@@ -42,7 +42,7 @@ trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
 _supported_fs xfs
 _supported_os Linux #IRIX
 _require_scratch
-_require_quota
+_require_xfs_quota
 _require_prjquota
 
 # real QA test starts here
diff --git a/107 b/107
index cfa8213..f36dc21 100755
--- a/107
+++ b/107
@@ -54,7 +54,7 @@ s/Inode: \#\d+ \(\d+ blocks, \d+ extents\)/Inode: #[INO] (X blocks, Y extents)/;
 _supported_fs xfs
 _supported_os Linux #IRIX
 _require_scratch
-_require_quota
+_require_xfs_quota
 _require_prjquota
 
 # real QA test starts here
diff --git a/108 b/108
index 3f3e1fb..3a1fee9 100755
--- a/108
+++ b/108
@@ -49,7 +49,7 @@ s,$SCRATCH_DEV,[SCR_DEV],;
 _supported_fs xfs
 _supported_os Linux #IRIX
 _require_scratch
-_require_quota
+_require_xfs_quota
 _require_prjquota
 
 test_files()
diff --git a/116 b/116
index 8394054..e902ce9 100755
--- a/116
+++ b/116
@@ -51,7 +51,7 @@ _supported_fs xfs
 _supported_os IRIX Linux
 
 _require_scratch
-_require_quota
+_require_xfs_quota
 
 mkfs.xfs -f $SCRATCH_DEV >/dev/null 2>&1
 mount -o uquota $SCRATCH_DEV $SCRATCH_MNT
diff --git a/118 b/118
index 6b28055..cb0e5ee 100755
--- a/118
+++ b/118
@@ -52,7 +52,7 @@ _supported_fs xfs
 _supported_os IRIX Linux
 
 _require_scratch
-_require_quota
+_require_xfs_quota
 
 _chowning_file()
 {
diff --git a/134 b/134
index fc2ab74..f00e1f0 100755
--- a/134
+++ b/134
@@ -50,7 +50,7 @@ _cleanup()
 _supported_fs xfs
 _supported_os Linux IRIX
 
-_require_quota
+_require_xfs_quota
 
 dir=$SCRATCH_MNT/project
 
diff --git a/196 b/196
index 7768618..5da3659 100755
--- a/196
+++ b/196
@@ -51,7 +51,7 @@ _supported_fs xfs
 _supported_os Linux
 
 _require_scratch
-_require_quota
+_require_xfs_quota
 
 #
 # Setup temporary replacements for /etc/projects and /etc/projid


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
