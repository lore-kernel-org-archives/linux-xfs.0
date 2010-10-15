Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9FMRhJL158176 for <xfs@oss.sgi.com>; Fri, 15 Oct 2010 17:27:43 -0500
Received: from canuck.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D9F741C02D54
	for <xfs@oss.sgi.com>; Fri, 15 Oct 2010 15:28:52 -0700 (PDT)
Received: from canuck.infradead.org (canuck.infradead.org [134.117.69.58]) by
	cuda.sgi.com with ESMTP id 1L1M6WNqEc38SCsl for
	<xfs@oss.sgi.com>; Fri, 15 Oct 2010 15:28:52 -0700 (PDT)
Received: from hch by canuck.infradead.org with local (Exim 4.72 #1 (Red Hat
	Linux)) id 1P6slg-0000zC-Aj
	for xfs@oss.sgi.com; Fri, 15 Oct 2010 22:28:52 +0000
Date: Fri, 15 Oct 2010 18:28:52 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 1/4] xfstests: fix _require_acl
Message-ID: <20101015222852.GA3781@infradead.org>
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

Skip ACL tests if we get EOPNOTUPP back from the acl calls.  This is
the error code we get on a kernel that does support the xattr system
calls, but does not support the attributes used to handle Posix ACLs.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfstests-dev/105
===================================================================
--- xfstests-dev.orig/105	2010-10-14 17:41:18.000000000 +0000
+++ xfstests-dev/105	2010-10-14 17:41:48.000000000 +0000
@@ -54,9 +54,9 @@ _supported_os IRIX Linux
 rm -f $seq.full
 
 _require_scratch
+_require_acls
 
 _acl_setup_ids
-_require_acls
 
 umount $SCRATCH_DEV >/dev/null 2>&1
 echo "*** MKFS ***"                         >>$seq.full
Index: xfstests-dev/common.attr
===================================================================
--- xfstests-dev.orig/common.attr	2010-10-14 17:35:06.000000000 +0000
+++ xfstests-dev/common.attr	2010-10-14 18:02:48.000000000 +0000
@@ -115,25 +115,30 @@ _filter_aces_notypes()
     sed -e 's/u:/user:/' -e 's/g:/group:/' -e 's/o:/other:/' -e 's/m:/mask:/'
 }
 
-# test if acl code will work
-#
 _require_acls()
 {
-    xfsdir=$TEST_DIR
-    
-
     if [ ! -x /bin/chacl -a ! -x /usr/bin/chacl -a ! -x /sbin/chacl ]; then
     	_notrun "chacl command not found"
     fi
 
-    # test if acl_get syscall is operational
-    # and hence the ACL config has been turned on  
-    touch $xfsdir/syscalltest
-    if chacl -l $xfsdir/syscalltest 2>&1 | tee -a $here/$seq.full | grep 'Function not implemented' >/dev/null
-    then
-      cd $here
-      _notrun "requires kernel ACL support"
+    #
+    # Test if chacl is able to list ACLs on the target filesystems.  On really
+    # old kernels the system calls might not be implemented at all, but the
+    # more common case is that the tested filesystem simply doesn't support
+    # ACLs.
+    #
+    touch $TEST_DIR/syscalltest
+    chacl -l $TEST_DIR/syscalltest > $TEST_DIR/syscalltest.out 2>&1
+    cat $TEST_DIR/syscalltest.out >> $here/$seq.full
+
+    if grep -q 'Function not implemented' $TEST_DIR/syscalltest.out; then
+      _notrun "kernel does not support ACLs"
     fi
+    if grep -q 'Operation not supported' $TEST_DIR/syscalltest.out; then
+      _notrun "ACLs not supported by this filesystem type: $FSTYP"
+    fi
+
+    rm -f $TEST_DIR/syscalltest.out
 }
 
 _list_acl()

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
