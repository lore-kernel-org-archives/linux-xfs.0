Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 430BA7CA3
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:28:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A0B13AC002
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:28:50 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id iSJdhKy82yPL1LSl (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:28:48 -0700 (PDT)
Subject: [PATCH 04/13] generic/159, 160: deal with EACCESS -> EPERM transition
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:28:44 -0700
Message-ID: <147216772479.32641.3592660842211217853.stgit@birch.djwong.org>
In-Reply-To: <147216769914.32641.55434969009554013.stgit@birch.djwong.org>
References: <147216769914.32641.55434969009554013.stgit@birch.djwong.org>
MIME-Version: 1.0
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: david@fromorbit.com, eguan@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org, xfs@oss.sgi.com

As of 4.8 we can receive EPERM (instead of EACCESS) for attempts to
reflink/dedupe to an immutable file.  Fix this up so that we accept
either answer.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/generic/159 |    6 +++++-
 tests/generic/160 |    6 +++++-
 2 files changed, 10 insertions(+), 2 deletions(-)


diff --git a/tests/generic/159 b/tests/generic/159
index 8898d58..726333a 100755
--- a/tests/generic/159
+++ b/tests/generic/159
@@ -65,9 +65,13 @@ _pwrite_byte 0x61 0 $sz $testdir1/file1 >> $seqres.full
 _pwrite_byte 0x61 0 $sz $testdir1/file2 >> $seqres.full
 sync
 
+do_filter_output() {
+	_filter_test_dir | sed -e 's/Operation not permitted/Permission denied/g'
+}
+
 echo "Try reflink on immutable files"
 $CHATTR_PROG +i $testdir1/file1 $testdir1/file2
-_reflink_range $testdir1/file1 0 $testdir1/file2 0 $blksz 2>&1 | _filter_test_dir
+_reflink_range $testdir1/file1 0 $testdir1/file2 0 $blksz 2>&1 | do_filter_output
 $CHATTR_PROG -i $testdir1/file1 $testdir1/file2
 
 # success, all done
diff --git a/tests/generic/160 b/tests/generic/160
index 3a91dc8..4946bfc 100755
--- a/tests/generic/160
+++ b/tests/generic/160
@@ -65,9 +65,13 @@ _pwrite_byte 0x61 0 $sz $testdir1/file1 >> $seqres.full
 _pwrite_byte 0x61 0 $sz $testdir1/file2 >> $seqres.full
 sync
 
+do_filter_output() {
+	_filter_test_dir | sed -e 's/Operation not permitted/Permission denied/g'
+}
+
 echo "Try dedupe on immutable files"
 $CHATTR_PROG +i $testdir1/file1 $testdir1/file2
-_dedupe_range $testdir1/file1 0 $testdir1/file2 0 $blksz 2>&1 | _filter_test_dir
+_dedupe_range $testdir1/file1 0 $testdir1/file2 0 $blksz 2>&1 | do_filter_output
 $CHATTR_PROG -i $testdir1/file1 $testdir1/file2
 
 # success, all done

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
