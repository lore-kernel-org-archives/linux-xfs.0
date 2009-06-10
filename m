Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5AHvFQU104490 for <xfs@oss.sgi.com>; Wed, 10 Jun 2009 12:57:15 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 40739126EE2F
	for <xfs@oss.sgi.com>; Wed, 10 Jun 2009 11:04:46 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id pHm3NyOH2X8GY9L9 for
	<xfs@oss.sgi.com>; Wed, 10 Jun 2009 11:04:46 -0700 (PDT)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.sandeen.net (Postfix) with ESMTP id 3F4918F271B
	for <xfs@oss.sgi.com>; Wed, 10 Jun 2009 12:57:34 -0500 (CDT)
Message-ID: <4A2FF40F.1090808@sandeen.net>
Date: Wed, 10 Jun 2009 12:57:35 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] xfstests: Gracefully fail aio tests if they weren't built
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
To: xfs-oss <xfs@oss.sgi.com>

Gracefully fail aio tests if they weren't built

configure & make succeeds w/o aio headers or libs,
so tests should handle that.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---


diff --git a/207 b/207
index 89f88d0..8e29e90 100755
--- a/207
+++ b/207
@@ -47,7 +47,9 @@ _supported_fs generic
 _supported_os Linux
 
 rm -f $TEST_DIR/aio-testfile
-src/aio-dio-regress/aio-dio-extend-stat $TEST_DIR/aio-testfile 2>&1
+AIO_TEST=src/aio-dio-regress/aio-dio-extend-stat
+[ -x $AIO_TEST ] || _notrun "$AIO_TEST not built"
+$AIO_TEST $TEST_DIR/aio-testfile 2>&1
 status=$?
 rm -f $TEST_DIR/aio-testfile
 
diff --git a/208 b/208
index 6043df3..9848f2f 100755
--- a/208
+++ b/208
@@ -47,7 +47,9 @@ _supported_fs generic
 _supported_os Linux
 
 rm -f $TEST_DIR/aio-testfile
-src/aio-dio-regress/aio-dio-invalidate-failure  $TEST_DIR/aio-testfile 2>&1
+AIO_TEST=src/aio-dio-regress/aio-dio-invalidate-failure
+[ -x $AIO_TEST ] || _notrun "$AIO_TEST not built"
+$AIO_TEST $TEST_DIR/aio-testfile 2>&1
 status=$?
 rm -f $TEST_DIR/aio-testfile
 
diff --git a/209 b/209
index 8e42fad..57cd429 100755
--- a/209
+++ b/209
@@ -47,7 +47,9 @@ _supported_fs generic
 _supported_os Linux
 
 rm -f $TEST_DIR/aio-testfile
-src/aio-dio-regress/aio-dio-invalidate-readahead $TEST_DIR/aio-testfile 2>&1
+AIO_TEST=src/aio-dio-regress/aio-dio-invalidate-readahead
+[ -x $AIO_TEST ] || _notrun "$AIO_TEST not built"
+$AIO_TEST $TEST_DIR/aio-testfile 2>&1
 status=$?
 rm -f $TEST_DIR/aio-testfile
 
diff --git a/210 b/210
index d12be17..8db47b4 100755
--- a/210
+++ b/210
@@ -47,7 +47,9 @@ _supported_fs generic
 _supported_os Linux
 
 rm -f $TEST_DIR/aio-testfile
-src/aio-dio-regress/aio-dio-subblock-eof-read $TEST_DIR/aio-testfile 2>&1
+AIO_TEST=src/aio-dio-regress/aio-dio-subblock-eof-read
+[ -x $AIO_TEST ] || _notrun "$AIO_TEST not built"
+$AIO_TEST $TEST_DIR/aio-testfile 2>&1
 status=$?
 rm -f $TEST_DIR/aio-testfile
 
diff --git a/211 b/211
index f7581c2..57ab2b4 100755
--- a/211
+++ b/211
@@ -47,7 +47,9 @@ _supported_fs generic
 _supported_os Linux
 
 rm -f $TEST_DIR/aio-testfile
-src/aio-dio-regress/aio-free-ring-with-bogus-nr-pages $TEST_DIR/aio-testfile 2>&1
+AIO_TEST=src/aio-dio-regress/aio-free-ring-with-bogus-nr-pages
+[ -x $AIO_TEST ] || _notrun "$AIO_TEST not built"
+$AIO_TEST $TEST_DIR/aio-testfile 2>&1
 status=$?
 rm -f $TEST_DIR/aio-testfile
 
diff --git a/212 b/212
index 44a23bf..f3e62ac 100755
--- a/212
+++ b/212
@@ -48,7 +48,9 @@ _supported_fs generic
 _supported_os Linux
 
 rm -f $TEST_DIR/aio-testfile
-src/aio-dio-regress/aio-io-setup-with-nonwritable-context-pointer $TEST_DIR/aio-testfile 2>&1
+AIO_TEST=src/aio-dio-regress/aio-io-setup-with-nonwritable-context-pointer
+[ -x $AIO_TEST ] || _notrun "$AIO_TEST not built"
+$AIO_TEST $TEST_DIR/aio-testfile 2>&1
 status=$?
 rm -f $TEST_DIR/aio-testfile
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
