Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9FMRrZO158198 for <xfs@oss.sgi.com>; Fri, 15 Oct 2010 17:27:53 -0500
Received: from canuck.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 49057F4EC8
	for <xfs@oss.sgi.com>; Fri, 15 Oct 2010 15:29:03 -0700 (PDT)
Received: from canuck.infradead.org (canuck.infradead.org [134.117.69.58]) by
	cuda.sgi.com with ESMTP id Ce9y74aCh4uoY7h9 for
	<xfs@oss.sgi.com>; Fri, 15 Oct 2010 15:29:03 -0700 (PDT)
Received: from hch by canuck.infradead.org with local (Exim 4.72 #1 (Red Hat
	Linux)) id 1P6slq-0000zH-R0
	for xfs@oss.sgi.com; Fri, 15 Oct 2010 22:29:02 +0000
Date: Fri, 15 Oct 2010 18:29:02 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 2/4] xfstests: add _require_attrs
Message-ID: <20101015222902.GB3781@infradead.org>
References: <20101015222820.GA3655@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20101015222820.GA3655@infradead.org>
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

Add a new helper to check if extended attributes are supported.  It
errors out if any of the attr tools are not found, or if a filesystem
does not support setting attributes.

Remove the opencoded checks for the attr tools from various tests
now that we do them in common code.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfstests-dev/common.attr
===================================================================
--- xfstests-dev.orig/common.attr	2010-10-15 12:52:54.000000000 +0000
+++ xfstests-dev/common.attr	2010-10-15 12:52:59.000000000 +0000
@@ -148,5 +148,33 @@ _list_acl()
     ls -dD $file | _acl_filter_id
 }
 
+_require_attrs()
+{
+    [ -n $ATTR_PROG ] || _notrun "attr command not found"
+    [ -n $GETFATTR_PROG ] || _notrun "getfattr command not found"
+    [ -n $SETFATTR_PROG ] || _notrun "setfattr command not found"
+
+    #
+    # Test if chacl is able to write an attribute on the target filesystems.
+    # On really old kernels the system calls might not be implemented at all,
+    # but the more common case is that the tested filesystem simply doesn't
+    # support attributes.  Note that we can't simply list attributes as
+    # various security modules generate synthetic attributes not actually
+    # stored on disk.
+    #
+    touch $TEST_DIR/syscalltest
+    attr -s "user.xfstests" -V "attr" /mnt/test/ > $TEST_DIR/syscalltest.out 2>&1
+    cat $TEST_DIR/syscalltest.out >> $here/$seq.full
+
+    if grep -q 'Function not implemented' $TEST_DIR/syscalltest.out; then
+      _notrun "kernel does not support attrs"
+    fi
+    if grep -q 'Operation not supported' $TEST_DIR/syscalltest.out; then
+      _notrun "attrs not supported by this filesystem type: $FSTYP"
+    fi
+
+    rm -f $TEST_DIR/syscalltest.out
+}
+
 # make sure this script returns success
 /bin/true
Index: xfstests-dev/020
===================================================================
--- xfstests-dev.orig/020	2010-10-15 12:52:08.000000000 +0000
+++ xfstests-dev/020	2010-10-15 14:10:59.000000000 +0000
@@ -35,6 +35,7 @@ trap "_cleanup; rm -f $tmp.* $testfile;
 # get standard environment, filters and checks
 . ./common.rc
 . ./common.filter
+. ./common.attr
 
 _cleanup()
 {
@@ -82,8 +83,7 @@ _attr_list()
 _supported_fs xfs udf
 _supported_os Linux
 
-[ -n $ATTR_PROG ] || _notrun "attr is not installed"
-[ -n $GETFATTR_PROG ] || _notrun "getfattr is not installed"
+_require_attrs
 
 _setup_testdir
 
Index: xfstests-dev/021
===================================================================
--- xfstests-dev.orig/021	2010-10-15 12:52:08.000000000 +0000
+++ xfstests-dev/021	2010-10-15 14:11:10.000000000 +0000
@@ -33,6 +33,7 @@ status=0	# success is the default!
 # get standard environment, filters and checks
 . ./common.rc
 . ./common.filter
+. ./common.attr
 
 _cleanup()
 {
@@ -76,10 +77,8 @@ _getfattr()
 _supported_fs xfs
 _supported_os Linux
 
-[ -n $ATTR_PROG ] || _notrun "attr is not installed"
-[ -n $GETFATTR_PROG ] || _notrun "getfattr is not installed"
-
 _require_scratch
+_require_attrs
 
 rm -f $seq.full
 umount $SCRATCH_DEV >/dev/null 2>&1
Index: xfstests-dev/062
===================================================================
--- xfstests-dev.orig/062	2010-10-15 12:52:08.000000000 +0000
+++ xfstests-dev/062	2010-10-15 14:11:22.000000000 +0000
@@ -35,6 +35,7 @@ status=1	# failure is the default!
 # get standard environment, filters and checks
 . ./common.rc
 . ./common.filter
+. ./common.attr
 
 _cleanup()
 {
@@ -120,6 +121,8 @@ _supported_fs xfs udf nfs
 _supported_os Linux
 
 _require_scratch
+_require_attrs
+
 rm -f $tmp.backup1 $tmp.backup2 $seq.full
 
 # real QA test starts here
Index: xfstests-dev/063
===================================================================
--- xfstests-dev.orig/063	2010-10-15 12:52:09.000000000 +0000
+++ xfstests-dev/063	2010-10-15 14:11:29.000000000 +0000
@@ -36,11 +36,14 @@ trap "rm -f $tmp.*; exit \$status" 0 1 2
 . ./common.rc
 . ./common.filter
 . ./common.dump
+. ./common.attr
 
 # real QA test starts here
 _supported_fs xfs
 _supported_os Linux
 
+_require_attrs
+
 # create files with EAs
 _create_dumpdir_fill_ea
 
Index: xfstests-dev/067
===================================================================
--- xfstests-dev.orig/067	2010-10-15 12:52:09.000000000 +0000
+++ xfstests-dev/067	2010-10-15 12:52:59.000000000 +0000
@@ -42,6 +42,7 @@ _supported_fs xfs
 _supported_os Linux
 
 _need_to_be_root
+_require_attrs
 _require_acls
 _require_scratch
 
Index: xfstests-dev/070
===================================================================
--- xfstests-dev.orig/070	2010-10-15 12:52:08.000000000 +0000
+++ xfstests-dev/070	2010-10-15 14:11:36.000000000 +0000
@@ -42,11 +42,14 @@ _cleanup()
 # get standard environment, filters and checks
 . ./common.rc
 . ./common.filter
+. ./common.attr
 
 # real QA test starts here
 _supported_fs generic
 _supported_os IRIX Linux
 
+_require_attrs
+
 _setup_testdir
 
 $FSSTRESS_PROG \
Index: xfstests-dev/077
===================================================================
--- xfstests-dev.orig/077	2010-10-15 12:52:09.000000000 +0000
+++ xfstests-dev/077	2010-10-15 12:52:59.000000000 +0000
@@ -52,7 +52,7 @@ _supported_os Linux
 
 [ ! -d $filler ] && _notrun "No directory to source files from"
 
-_require_scratch
+_require_attrs
 _require_acls
 _require_user
 
Index: xfstests-dev/079
===================================================================
--- xfstests-dev.orig/079	2010-10-15 12:52:09.000000000 +0000
+++ xfstests-dev/079	2010-10-15 14:11:55.000000000 +0000
@@ -44,11 +44,14 @@ _cleanup()
 # get standard environment, filters and checks
 . ./common.rc
 . ./common.filter
+. ./common.attr
 
 _supported_fs xfs
 _supported_os Linux
 
+_require_attrs
 _require_scratch
+
 [ -x $timmutable ] || _notrun "t_immutable was not built for this platform"
 
 # real QA test starts here
Index: xfstests-dev/093
===================================================================
--- xfstests-dev.orig/093	2010-10-15 12:52:09.000000000 +0000
+++ xfstests-dev/093	2010-10-15 12:52:59.000000000 +0000
@@ -60,6 +60,8 @@ _filefilter()
 _supported_fs generic
 _supported_os IRIX
 
+_require_attrs
+
 [ -x $runas ] || _notrun "$runas executable not found"
 
 rm -f $seq.full
Index: xfstests-dev/114
===================================================================
--- xfstests-dev.orig/114	2010-10-15 12:52:09.000000000 +0000
+++ xfstests-dev/114	2010-10-15 14:12:11.000000000 +0000
@@ -308,11 +308,13 @@ _test_dirstress()
 # get standard environment, filters and checks
 . ./common.rc
 . ./common.filter
+. ./common.attr
 
 _supported_fs xfs
 _supported_os IRIX
 
 _require_scratch
+_require_attrs
 _need_to_be_root
 
 rm -f $here/$seq.full
Index: xfstests-dev/115
===================================================================
--- xfstests-dev.orig/115	2010-10-15 12:52:09.000000000 +0000
+++ xfstests-dev/115	2010-10-15 14:12:21.000000000 +0000
@@ -95,11 +95,13 @@ _filter()
 # get standard environment, filters and checks
 . ./common.rc
 . ./common.filter
+. ./common.attr
 
 _supported_fs xfs
 _supported_os IRIX
 
 _require_scratch
+_require_attrs
 
 rm -f $here/$seq.full
 
Index: xfstests-dev/117
===================================================================
--- xfstests-dev.orig/117	2010-10-15 12:52:09.000000000 +0000
+++ xfstests-dev/117	2010-10-15 14:12:27.000000000 +0000
@@ -48,6 +48,7 @@ _cleanup()
 # get standard environment, filters and checks
 . ./common.rc
 . ./common.filter
+. ./common.attr
 
 # real QA test starts here
 _supported_fs xfs
@@ -55,6 +56,7 @@ _supported_os IRIX Linux
 
 _setup_testdir
 _require_scratch
+_require_attrs
 
 rm -f $seq.full
 umount $SCRATCH_DEV >/dev/null 2>&1
Index: xfstests-dev/136
===================================================================
--- xfstests-dev.orig/136	2010-10-15 12:52:33.000000000 +0000
+++ xfstests-dev/136	2010-10-15 14:12:35.000000000 +0000
@@ -43,6 +43,7 @@ _cleanup()
 # get standard environment, filters and checks
 . ./common.rc
 . ./common.filter
+. ./common.attr
 
 # real QA test starts here
 
@@ -51,7 +52,9 @@ _cleanup()
 # Modify as appropriate.
 _supported_fs xfs
 _supported_os IRIX Linux
+
 _require_scratch
+_require_attrs
 
 export MKFS_OPTIONS="-i size=512,attr=2"
 _scratch_mkfs_xfs > /dev/null 2>&1
Index: xfstests-dev/186
===================================================================
--- xfstests-dev.orig/186	2010-10-15 12:52:09.000000000 +0000
+++ xfstests-dev/186	2010-10-15 14:12:51.000000000 +0000
@@ -139,13 +139,17 @@ _changeto_attr1()
 # get standard environment, filters and checks
 . ./common.rc
 . ./common.filter
+. ./common.attr
 
 # real QA test starts here
 
 # Modify as appropriate.
 _supported_fs xfs
 _supported_os Linux
+
 _require_scratch
+_require_attrs
+
 rm -f $seq.full
 
 _scratch_mkfs -i attr=2,size=512 -l lazy-count=1 >/dev/null 2>&1
Index: xfstests-dev/187
===================================================================
--- xfstests-dev.orig/187	2010-10-15 12:52:08.000000000 +0000
+++ xfstests-dev/187	2010-10-15 14:12:58.000000000 +0000
@@ -51,11 +51,15 @@ _filter_version()
 # get standard environment, filters and checks
 . ./common.rc
 . ./common.filter
+. ./common.attr
 
 # real QA test starts here
-_require_scratch
 _supported_fs xfs
 _supported_os Linux
+
+_require_scratch
+_require_attrs
+
 rm -f $seq.full
 
 # lazysb and attr2 are in features2 and will require morebitsbit on

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
