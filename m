Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oA9BXQ9S151385 for <xfs@oss.sgi.com>; Tue, 9 Nov 2010 05:33:27 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A5C6D4CDE37
	for <xfs@oss.sgi.com>; Tue,  9 Nov 2010 03:34:54 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id dVr9uU5fYtoQBOv4 for
	<xfs@oss.sgi.com>; Tue, 09 Nov 2010 03:34:54 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.72 #1 (Red Hat
	Linux)) id 1PFmTW-0005Yp-44
	for xfs@oss.sgi.com; Tue, 09 Nov 2010 11:34:54 +0000
Date: Tue, 9 Nov 2010 06:34:54 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests: add _require_sparse_files
Message-ID: <20101109113453.GA21237@infradead.org>
References: <20101028123414.GA24977@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20101028123414.GA24977@infradead.org>
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

updated version to also include test 239 which reqires the check, too.

---
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] xfstests: add _require_sparse_files

Add a helper to check if the filesystem supports sparse files.  This is
used to guard tests that exercise sparse file functionality and would
take forever on filesystems that have to zero all blocks on extending
truncates.

Unfortunately there's no good way to autodetect this functionality, so
just implement it as a blacklist for now.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfstests-dev/014
===================================================================
--- xfstests-dev.orig/014	2010-11-09 11:28:58.000000000 +0000
+++ xfstests-dev/014	2010-11-09 11:30:14.000000000 +0000
@@ -47,6 +47,7 @@ _cleanup()
 _supported_fs generic
 _supported_os IRIX Linux
 
+_require_sparse_files
 _setup_testdir
 
 echo "brevity is wit..."
Index: xfstests-dev/129
===================================================================
--- xfstests-dev.orig/129	2010-11-09 11:28:58.000000000 +0000
+++ xfstests-dev/129	2010-11-09 11:30:14.000000000 +0000
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
--- xfstests-dev.orig/130	2010-11-09 11:28:58.000000000 +0000
+++ xfstests-dev/130	2010-11-09 11:30:14.000000000 +0000
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
--- xfstests-dev.orig/240	2010-11-09 11:28:58.000000000 +0000
+++ xfstests-dev/240	2010-11-09 11:30:14.000000000 +0000
@@ -48,6 +48,8 @@ _cleanup()
 _supported_fs generic
 _supported_os Linux
 
+_require_sparse_files
+
 echo "Silence is golden."
 
 # real QA test starts here
Index: xfstests-dev/common.rc
===================================================================
--- xfstests-dev.orig/common.rc	2010-11-09 11:28:58.000000000 +0000
+++ xfstests-dev/common.rc	2010-11-09 11:30:14.000000000 +0000
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
Index: xfstests-dev/239
===================================================================
--- xfstests-dev.orig/239	2010-11-09 11:30:18.000000000 +0000
+++ xfstests-dev/239	2010-11-09 11:30:23.000000000 +0000
@@ -45,6 +45,8 @@ _cleanup()
 _supported_fs generic
 _supported_os Linux
 
+_require_sparse_files
+
 AIO_TEST=src/aio-dio-regress/aio-dio-hole-filling-race
 [ -x $AIO_TEST ] || _notrun "$AIO_TEST not built"
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
