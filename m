Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4RIrNwi204168 for <xfs@oss.sgi.com>; Wed, 27 May 2009 13:53:23 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A6D2414865BA
	for <xfs@oss.sgi.com>; Wed, 27 May 2009 11:59:32 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id HwlWJlD5Vh6IJVbK for
	<xfs@oss.sgi.com>; Wed, 27 May 2009 11:59:32 -0700 (PDT)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [PATCH 5/9] Set up testdir for generic filesystems
Date: Wed, 27 May 2009 13:53:29 -0500
Message-Id: <1243450413-12681-6-git-send-email-sandeen@sandeen.net>
In-Reply-To: <1243450413-12681-1-git-send-email-sandeen@sandeen.net>
References: <1243450413-12681-1-git-send-email-sandeen@sandeen.net>
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
To: xfs@oss.sgi.com
Cc: Eric Sandeen <sandeen@sandeen.net>

Make the default filesystem testdir setup the same as
what xfs did; simply set up the testdir variable.

Update the comment for UDF & NFS, as to why they are
currently doing something different.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---
 common.rc |   31 ++++++++++---------------------
 1 files changed, 10 insertions(+), 21 deletions(-)

diff --git a/common.rc b/common.rc
index f649bc2..78514f4 100644
--- a/common.rc
+++ b/common.rc
@@ -988,15 +988,6 @@ _check_testdir()
     esac
 }
 
-
-_setup_xfs_testdir()
-{
-    [ "$FSTYP" != "xfs" ] \
-	&& _fail "setup_xfs_testdir: \$FSTYP ($FSTYP) is not xfs"
-
-    testdir=$TEST_DIR
-}
-
 _setup_udf_scratchdir()
 {
     [ "$FSTYP" != "udf" ] \
@@ -1050,16 +1041,17 @@ _setup_nfs_scratchdir()
 }
 
 #
-# Warning for UDF and NFS this function calls _setup_udf_scratchdir and
-# _setup_udf_scratchdir. This is done because testdir is a persistent
-# XFS only partition.
+# Warning for UDF and NFS:
+# this function calls _setup_udf_scratchdir and _setup_udf_scratchdir
+# which actually uses the scratch dir for the test dir.
+#
+# This was done because testdir was intended to be a persistent
+# XFS only partition.  This should eventually change, and treat
+# at least local filesystems all the same.
 #
 _setup_testdir()
 {
     case $FSTYP in
-    xfs)
-	_setup_xfs_testdir
-	;;
     udf)
 	_setup_udf_scratchdir
 	;;
@@ -1067,7 +1059,7 @@ _setup_testdir()
 	_setup_nfs_scratchdir
 	;;
     *)
-	_fail "\$FSTYP is not xfs, udf or nfs"
+	testdir=$TEST_DIR
 	;;
     esac
 }
@@ -1075,10 +1067,6 @@ _setup_testdir()
 _cleanup_testdir()
 {
     case $FSTYP in
-    xfs)
-	# do nothing, testdir is $TEST_DIR
-	:
-	;;
     udf)
 	# umount testdir as it is $SCRATCH_MNT which could be used by xfs next
 	[ -n "$testdir" ] && $UMOUNT_PROG $testdir
@@ -1088,7 +1076,8 @@ _cleanup_testdir()
 	[ -n "$testdir" ] && $UMOUNT_PROG $testdir
 	;;
     *)
-	_fail "\$FSTYP is not xfs, udf or nfs"
+	# do nothing, testdir is $TEST_DIR
+	:
 	;;
     esac
 }
-- 
1.5.5.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
