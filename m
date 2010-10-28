Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9SCWtSE018558 for <xfs@oss.sgi.com>; Thu, 28 Oct 2010 07:32:55 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9ABAE1E883C3
	for <xfs@oss.sgi.com>; Thu, 28 Oct 2010 05:34:14 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id QxYb5nrCkcp4bZMn for
	<xfs@oss.sgi.com>; Thu, 28 Oct 2010 05:34:14 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.72 #1 (Red Hat
	Linux)) id 1PBRgM-0006VQ-6R
	for xfs@oss.sgi.com; Thu, 28 Oct 2010 12:34:14 +0000
Date: Thu, 28 Oct 2010 08:34:14 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfstests: add _require_sparse_files
Message-ID: <20101028123414.GA24977@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
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
To: xfs@oss.sgi.com

Add a helper to check if the filesystem supports sparse files.  This is
used to guard tests that exercise sparse file functionality and would
take forever on filesystems that have to zero all blocks on extending
truncates.

Unfortunately there's no good way to autodetect this functionality, so
just implement it as a blacklist for now.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfstests-dev/014
===================================================================
--- xfstests-dev.orig/014	2010-10-28 11:51:58.000000000 +0000
+++ xfstests-dev/014	2010-10-28 11:52:06.000000000 +0000
@@ -47,6 +47,7 @@ _cleanup()
 _supported_fs generic
 _supported_os IRIX Linux
 
+_require_sparse_files
 _setup_testdir
 
 echo "brevity is wit..."
Index: xfstests-dev/129
===================================================================
--- xfstests-dev.orig/129	2010-10-28 11:52:08.000000000 +0000
+++ xfstests-dev/129	2010-10-28 11:52:24.000000000 +0000
@@ -52,8 +52,10 @@ echo_and_run()
 _supported_fs generic
 _supported_os Linux
 
-_setup_testdir
 _require_scratch
+_require_sparse_files
+
+_setup_testdir
 
 _scratch_mkfs >/dev/null 2>&1
 _scratch_mount "-o nosuid"
Index: xfstests-dev/130
===================================================================
--- xfstests-dev.orig/130	2010-10-28 11:52:26.000000000 +0000
+++ xfstests-dev/130	2010-10-28 11:52:35.000000000 +0000
@@ -55,8 +55,10 @@ _cleanup()
 _supported_fs generic
 _supported_os Linux IRIX
 
-_setup_testdir
 _require_scratch
+_require_sparse_files
+
+_setup_testdir
 
 _scratch_mkfs >/dev/null 2>&1
 _scratch_mount
Index: xfstests-dev/240
===================================================================
--- xfstests-dev.orig/240	2010-10-28 11:52:37.000000000 +0000
+++ xfstests-dev/240	2010-10-28 11:52:43.000000000 +0000
@@ -48,6 +48,8 @@ _cleanup()
 _supported_fs generic
 _supported_os Linux
 
+_require_sparse_files
+
 echo "Silence is golden."
 
 # real QA test starts here
Index: xfstests-dev/common.rc
===================================================================
--- xfstests-dev.orig/common.rc	2010-10-28 11:49:38.000000000 +0000
+++ xfstests-dev/common.rc	2010-10-28 11:51:56.000000000 +0000
@@ -857,6 +857,22 @@ _require_fs_space()
 		_notrun "This test requires at least ${GB}GB free on $MNT to run"
 }
 
+#
+# Check if the filesystem supports sparese files.
+#
+# Unfortunately there is no better way to do this than a manual black list.
+#
+_require_sparse_files()
+{
+    case $FSTYP in
+    hfsplus)
+        _notrun "Sparse files not supported by this filesystem type: $FSTYP"
+	;;
+    *)
+        ;;
+    esac
+}
+
 # check that a FS on a device is mounted
 # if so, return mount point
 #

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
