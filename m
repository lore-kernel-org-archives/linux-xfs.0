Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7GDucKB134958 for <xfs@oss.sgi.com>; Thu, 16 Aug 2012 08:56:38 -0500
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id yB5DFUpoKAMCc2YZ (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 16 Aug 2012 06:56:37 -0700 (PDT)
Received: from relay1.suse.de (unknown [195.135.220.254])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx2.suse.de (Postfix) with ESMTP id 3AC59A2FD6
	for <xfs@oss.sgi.com>; Thu, 16 Aug 2012 15:56:36 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH] xfstests: Provide test whether fs supports direct IO and use
	it
Date: Thu, 16 Aug 2012 15:56:31 +0200
Message-Id: <1345125391-15055-1-git-send-email-jack@suse.cz>
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
Cc: Jan Kara <jack@suse.cz>

ext3 in data=journal mode does not support direct IO. Tests which use
direct IO fail due to that. Provide function checking whether direct IO
is supported and skip tests needing direct IO if it's not.

There are a few tests which use direct IO but would be meaningful even
without it since they test several different things. Making these tests
useful for filesystems without dio support is left for future if somebody
is interested...

Signed-off-by: Jan Kara <jack@suse.cz>
---
 091       |    1 +
 113       |    1 +
 130       |    1 +
 133       |    1 +
 135       |    1 +
 198       |    1 +
 208       |    1 +
 209       |    1 +
 210       |    1 +
 226       |    1 +
 239       |    1 +
 240       |    1 +
 263       |    1 +
 common.rc |   12 ++++++++++++
 14 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/091 b/091
index 8a14602..d197fec 100755
--- a/091
+++ b/091
@@ -39,6 +39,7 @@ trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
 # real QA test starts here
 _supported_fs generic
 _supported_os Linux
+_require_direct_io
 
 rm -f $seq.full
 
diff --git a/113 b/113
index b2ec510..e1c2cfa 100755
--- a/113
+++ b/113
@@ -82,6 +82,7 @@ _supported_os Linux
 
 [ -x $here/ltp/aio-stress ] || _notrun "aio-stress not built for this platform"
 
+_require_direct_io
 _setup_testdir
 
 echo "brevity is wit..."
diff --git a/130 b/130
index ea5270d..25638f0 100755
--- a/130
+++ b/130
@@ -57,6 +57,7 @@ _supported_os Linux IRIX
 
 _require_scratch
 _require_sparse_files
+_require_direct_io
 
 _setup_testdir
 
diff --git a/133 b/133
index 9dbcb64..288e510 100755
--- a/133
+++ b/133
@@ -44,6 +44,7 @@ _cleanup()
 # real QA test starts here
 _supported_fs generic
 _supported_os Linux IRIX
+_require_direct_io
 
 _setup_testdir
 
diff --git a/135 b/135
index 976619d..2dfda17 100755
--- a/135
+++ b/135
@@ -48,6 +48,7 @@ _supported_os Linux IRIX
 
 _setup_testdir
 _require_scratch
+_require_direct_io
 _scratch_mkfs >/dev/null 2>&1
 
 _umount_mount()
diff --git a/198 b/198
index 2c72677..e4532b4 100755
--- a/198
+++ b/198
@@ -44,6 +44,7 @@ _cleanup()
 
 _supported_fs generic
 _supported_os Linux
+_require_direct_io
 _require_aiodio aiodio_sparse2
 
 echo "Silence is golden."
diff --git a/208 b/208
index ca01558..10c74ef 100755
--- a/208
+++ b/208
@@ -45,6 +45,7 @@ _cleanup()
 
 _supported_fs generic
 _supported_os Linux
+_require_direct_io
 
 _run_aiodio aio-dio-invalidate-failure
 
diff --git a/209 b/209
index 650e300..d2832d7 100755
--- a/209
+++ b/209
@@ -45,6 +45,7 @@ _cleanup()
 
 _supported_fs generic
 _supported_os Linux
+_require_direct_io
 
 _run_aiodio aio-dio-invalidate-readahead
 
diff --git a/210 b/210
index a0873f8..71a298d 100755
--- a/210
+++ b/210
@@ -45,6 +45,7 @@ _cleanup()
 
 _supported_fs generic
 _supported_os Linux
+_require_direct_io
 
 _run_aiodio aio-dio-subblock-eof-read
 
diff --git a/226 b/226
index 6f28ac9..799c4d9 100755
--- a/226
+++ b/226
@@ -38,6 +38,7 @@ trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
 _supported_fs generic
 _supported_os Linux IRIX
 _require_scratch
+_require_direct_io
 
 # real QA test starts here
 rm -f $seq.full
diff --git a/239 b/239
index 6457c46..0a6754c 100755
--- a/239
+++ b/239
@@ -46,6 +46,7 @@ _supported_fs generic
 _supported_os Linux
 
 _require_sparse_files
+_require_direct_io
 _require_aiodio aio-dio-hole-filling-race
 
 echo "Silence is golden"
diff --git a/240 b/240
index dafcef3..97d9e7d 100755
--- a/240
+++ b/240
@@ -52,6 +52,7 @@ _supported_fs generic
 _supported_os Linux
 
 _require_sparse_files
+_require_direct_io
 _require_aiodio aiodio_sparse2
 
 echo "Silence is golden."
diff --git a/263 b/263
index 315a938..6453163 100755
--- a/263
+++ b/263
@@ -39,6 +39,7 @@ trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
 # real QA test starts here
 _supported_fs generic
 _supported_os Linux
+_require_direct_io
 
 rm -f $seq.full
 
diff --git a/common.rc b/common.rc
index 602513a..720d137 100644
--- a/common.rc
+++ b/common.rc
@@ -1027,6 +1027,18 @@ _require_sparse_files()
     esac
 }
 
+#
+# Check if the filesystem supports direct IO
+#
+_require_direct_io()
+{
+	testfile=$TEST_DIR/$$.dio
+	testio=`$XFS_IO_PROG -F -f -d -c "" $testfile 2>&1`
+	rm -f $testfile 2>&1 > /dev/null
+	echo $testio | grep -q "Invalid argument" && \
+		_notrun "direct IO not supported"
+}
+
 # check that a FS on a device is mounted
 # if so, return mount point
 #
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
